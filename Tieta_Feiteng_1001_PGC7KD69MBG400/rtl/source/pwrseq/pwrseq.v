/* =================================================================================================
模块功能：电源上下电时序控制、状态监控
1. 上电时序如下: GR1->GR2->GR3->GR4->PCIE_RESET->CPU_POR_N->PWROK, 各组电源之间上电延时2ms
2. 下电时序如下: PWROK->CPU_POR_N->PCIE_RESET->GR4->GR3->GR2->GR1, 各组电源之间下电延时2ms
3. 各组电源上电后, 需等待PGood信号有效后, 再进入下一组电源上电, 否则进入错误处理状态
4. 各组电源下电时, 直接关闭对应电源EN信号, 不等待PGood信号失效
5. 各组电源上电、下电均有看门狗计时器, 超时则进入错误处理状态
6. 错误处理状态: 依次关闭各组电源, 直至全部关闭后, 若无任何电源故障信号, 则重新开始上电序列
7. 监控到电源故障, 输出Fault信号, 组寄存器写入日志
===================================================================================================*/
`include "pwrseq_define.vh"
module pwrseq#(
    parameter LIM_RECOV_MAX_RETRY_ATTEMPT           = 2                         , // 上电失败最大重试次数
    parameter WDT_NBITS                             = 10                        , // 看门狗计数器位宽
    
    parameter DSW_PWROK_TIMEOUT_VAL                 = 2                         , // CPU各组电源上电超时时间
    parameter PCH_WATCHDOG_TIMEOUT_VAL              = 100                       , // 主板上电超时时间
    parameter PON_WATCHDOG_TIMEOUT_VAL              = 12                        , // S5设备上电超时时间
    parameter PSU_WATCHDOG_TIMEOUT_VAL              = 10                        , // PSU上电超时时间
    parameter EFUSE_WATCHDOG_TIMEOUT_VAL            = 14                        , // EFUSE上电超时时间
    parameter PDN_WATCHDOG_TIMEOUT_VAL              = 2                         , // 下电超时时间
    parameter POR_WATCHDOG_TIMEOUT_VAL              = 112                       , // PON_PWROK超时时间

    parameter PON_65MS_WATCHDOG_TIMEOUT_VAL         = 65,
    parameter DC_ON_WAIT_COMPLETE_NOFLT_VAL         = 17,
    parameter DC_ON_WAIT_COMPLETE_FAULT_VAL         = 2,
    parameter PF_ON_WAIT_COMPLETE_VAL               = 33,
    parameter PO_ON_WAIT_COMPLETE_VAL               = 1,
    parameter S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL = 0,
    parameter S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL = 0

    
)(
    input            clk                                , // clock
    input            reset                              , // reset

    // 状态跳转控制使用
    input            t1us,                    // 10ns pulse every 1us
    input            t1ms_tick                          , // 1ms   时钟脉冲
    // input            t2ms_tick                          , // 2ms   时钟脉冲
    input            t32ms_tick                         , // 32ms  时钟脉冲
    input            t256ms_tick                        , // 256ms 时钟脉冲

    // 各组电源轨EN信号输出
    // GR1: CPU0_VDD P0V8
    // GR1: CPU1_VDD P0V8
    input   reg      o_pal_cpu0_vdd_core_p0v8_en        ,
    input   reg      o_pal_cpu1_vdd_core_p0v8_en        ,
    // GR2: CPU0_GPIO_VDDH/CPU0_VT_AVDDH/CPU0_D0_EFUSE/CPU0_D1_EFUSE P1V8
    // GR2: CPU1_GPIO_VDDH/CPU1_VT_AVDDH/CPU1_D0_EFUSE/CPU1_D1_EFUSE P1V8
    input   reg      o_pal_cpu0_p1v8_en                 ,
    input   reg      o_pal_cpu1_p1v8_en                 ,
    // GR3: CPU0_VDDQ P1V1、CPU0_DDR_HM_PLL_VDDA P0V8、CPU0 
    // GR3: CPU1_VDDQ P1V1、CPU1_DDR_HM_PLL_VDDA P0V8、CPU1 
    input   reg      o_pal_cpu0_vddq_p1v1_en            ,
    input   reg      o_pal_cpu1_vddq_p1v1_en            ,
    input   reg      o_pal_cpu0_ddr_vdd_en              ,
    input   reg      o_pal_cpu1_ddr_vdd_en              ,
    input   reg      o_pal_cpu0_pll_p1v8_en             ,
    input   reg      o_pal_cpu1_pll_p1v8_en             ,
    // GR4: CPU0_D0_VP P0V9、CPU0_D0_VPH P1V8
    // GR4: CPU1_D0_VP P0V9、CPU1_D0_VPH P1V8
    input   reg      o_pal_cpu0_d0_vp_p1v1_en           ,
    input   reg      o_pal_cpu0_d1_vp_p1v1_en           ,
    input   reg      o_pal_cpu0_d0_vph_p1v8_en          ,
    input   reg      o_pal_cpu0_d1_vph_p1v8_en          ,
    input   reg      o_pal_cpu1_d0_vp_p1v1_en           ,
    input   reg      o_pal_cpu1_d1_vp_p1v1_en           ,
    input   reg      o_pal_cpu1_d0_vph_p1v8_en          ,
    input   reg      o_pal_cpu1_d1_vph_p1v8_en          ,
    
    // 各组电源轨PGood信号输入
    // GR1: CPU0_VDD P0V8
    // GR1: CPU1_VDD P0V8
    input            i_pal_cpu0_vdd_core_p0v8_pg        ,
    input            i_pal_cpu1_vdd_core_p0v8_pg        ,
    // GR2: CPU0_GPIO_VDDH/CPU0_VT_AVDDH/CPU0_D0_EFUSE/CPU0_D1_EFUSE P1V8
    // GR2: CPU1_GPIO_VDDH/CPU1_VT_AVDDH/CPU1_D0_EFUSE/CPU1_D1_EFUSE P1V8
    input            i_pal_cpu0_p1v8_pg                 ,
    input            i_pal_cpu1_p1v8_pg                 ,
    // GR3: CPU0_VDDQ P1V1、CPU0_DDR_HM_PLL_VDDA P0V8、CPU0 
    // GR3: CPU1_VDDQ P1V1、CPU1_DDR_HM_PLL_VDDA P0V8、CPU1 
    input            i_pal_cpu0_vddq_p1v1_pg            ,
    input            i_pal_cpu1_vddq_p1v1_pg            ,
    input            i_pal_cpu0_ddr_vdd_pg              ,
    input            i_pal_cpu1_ddr_vdd_pg              ,
    input            i_pal_cpu0_pll_p1v8_pg             ,
    input            i_pal_cpu1_pll_p1v8_pg             ,
    // GR4: CPU0_D0_VP P0V9、CPU0_D0_VPH P1V8
    // GR4: CPU1_D0_VP P0V9、CPU1_D0_VPH P1V8
    input            i_pal_cpu0_d0_vp_p1v1_pg           ,
    input            i_pal_cpu0_d1_vp_p1v1_pg           ,
    input            i_pal_cpu0_d0_vph_p1v8_pg          ,
    input            i_pal_cpu0_d1_vph_p1v8_pg          ,
    input            i_pal_cpu1_d0_vp_p1v1_pg           ,
    input            i_pal_cpu1_d1_vp_p1v1_pg           ,
    input            i_pal_cpu1_d0_vph_p1v8_pg          ,
    input            i_pal_cpu1_d1_vph_p1v8_pg          ,

    // 输出Fault信号检测
    // GR1: CPU0_VDD P0V8
    // GR1: CPU1_VDD P0V8
    output           o_cpu0_vdd_core_p0v8_fault_det     ,
    output           o_cpu1_vdd_core_p0v8_fault_det     ,
    // GR2: CPU0_GPIO_VDDH/CPU0_VT_AVDDH/CPU0_D0_EFUSE/CPU0_D1_EFUSE P1V8
    // GR2: CPU1_GPIO_VDDH/CPU1_VT_AVDDH/CPU1_D0_EFUSE/CPU1_D1_EFUSE P1V8
    output           o_pal_cpu0_p1v8_fault_det          ,
    output           o_pal_cpu1_p1v8_fault_det          ,
    // GR3: CPU0_VDDQ P1V1、CPU0_DDR_HM_PLL_VDDA P0V8、CPU0 
    // GR3: CPU1_VDDQ P1V1、CPU1_DDR_HM_PLL_VDDA P0V8、CPU1 
    output           o_pal_cpu0_vddq_p1v1_fault_det     ,
    output           o_pal_cpu1_vddq_p1v1_fault_det     ,
    output           o_pal_cpu0_ddr_vdd_fault_det       ,
    output           o_pal_cpu1_ddr_vdd_fault_det       ,
    output           o_pal_cpu0_pll_p1v8_fault_det      ,
    output           o_pal_cpu1_pll_p1v8_fault_det      ,
    // GR4: CPU0_D0_VP P0V9、CPU0_D0_VPH P1V8
    // GR4: CPU1_D0_VP P0V9、CPU1_D0_VPH P1V8
    output           o_pal_cpu0_d0_vp_p1v1_fault_det    ,
    output           o_pal_cpu0_d1_vp_p1v1_fault_det    ,
    output           o_pal_cpu0_d0_vph_p1v8_fault_det   ,
    output           o_pal_cpu0_d1_vph_p1v8_fault_det   ,
    output           o_pal_cpu1_d0_vp_p1v1_fault_det    ,
    output           o_pal_cpu1_d1_vp_p1v1_fault_det    ,
    output           o_pal_cpu1_d0_vph_p1v8_fault_det   ,
    output           o_pal_cpu1_d1_vph_p1v8_fault_det   ,

    // DEVICE_PCIE_RESET 控制信号
    input            i_cpu_peu_prest_n_r                ,

    // CPU0/1_POR_N_R 控制信号
    output reg       o_cpu0_por_n_r                     ,
    output reg       o_cpu1_por_n_r                     ,

    // 其他 PWRGOOD 信号
    output reg       reached_sm_wait_powerok            ,  
    output reg       o_cpu_power_good                   ,

    // 供外部监控当前状态机状态使用
    output reg       power_seq_sm                       ,
);

/* ------------------------------------------------------------------------------------------------------------
全局计时器, 控制上下电跳转使用
---------------------------------------------------------------------------------------------------------------*/
// 上下电看门狗计数器
wire                                          wdt_tick          ; // 看门狗计数器触发脉冲
wire                                          wdt_counter_clr   ; // 看门狗计数器清零信号
reg     [WDT_NBITS-1:0]                       wdt_counter       ; // 看门狗计数器

assign wdt_tick = (off_state) ? t256ms       :
                  (st_ps_on)  ? t32ms_tick   :  
                                t1ms_tick    ;  

// 状态跳转时清空看门狗计数器
assign  wdt_counter_clr = (next_state != curr_state) ? 1'b1 : 1'b0 ;

// 看门狗计数器
always @(posedge clk or posedge reset) begin
    if (reset)
        wdt_counter <= {WDT_NBITS{1'b0}} ;
    else if (wdt_counter_clr)
        wdt_counter <= {WDT_NBITS{1'b0}} ;
    else if (wdt_tick)
        wdt_counter <= wdt_counter + 1'b1;
end

/* ------------------------------------------------------------------------------------------------------------
状态监控, “状态超时标志信号” 信号, 供状态机跳转使用
各类挂死的超时标志, 达到阈值时置位，直到下次清零 
---------------------------------------------------------------------------------------------------------------*/
// 超时标志：电源组1/2/3/4就绪超时; CPU_POR_N 超时 
reg                                           pgd_so_far                          ; // 全局PGD信号
reg                                           power_on_critical_fail_en           ; // 上电故障使能信号
reg                                           pcie_reset_state_trans_en           ; // PCIE_RESET 状态跳转使能信号

reg                                           dsw_pwrok_timeout                   ; // 电源组1/2/3/4就绪超时
reg                                           pch_watchdog_timeout                ; // 主板上电超时
reg                                           pon_watchdog_timeout                ; // S5设备上电超时
reg                                           psu_watchdog_timeout                ; // PSU上电超时
reg                                           efuse_watchdog_timeout              ; // EFUSE上电超时
reg                                           vcore_watchdog_timeout              ; // VCORE上电超时
reg                                           pdn_watchdog_timeout                ; // 下电超时
reg                                           disable_intel_vccin_timeout         ; // 关闭INTEL_VCCIN超时
reg                                           disable_3v3_timeout                 ; // 关闭3V3超时
reg                                           pon_65ms_watchdog_timeout           ; // 65ms上电超时
reg                                           pf_on_wait_complete                 ; // PF上电等待完成超时
reg                                           po_on_wait_complete                 ; // PO上电等待完成超时
reg                                           s5_devices_on_wait_complete         ; // S5设备上电等待完成超时

// 上电延时
always @(posedge clk or posedge reset) begin
    if (reset)begin
        dsw_pwrok_timeout           <= 1'b0;
        pch_watchdog_timeout        <= 1'b0;
        pon_watchdog_timeout        <= 1'b0;
        psu_watchdog_timeout        <= 1'b0;
        efuse_watchdog_timeout      <= 1'b0;
        vcore_watchdog_timeout      <= 1'b0;
        pdn_watchdog_timeout        <= 1'b0;
        disable_intel_vccin_timeout <= 1'b0;
        disable_3v3_timeout         <= 1'b0;
    end
    else if(wdt_counter_clr) begin
        dsw_pwrok_timeout           <= 1'b0;
        pch_watchdog_timeout        <= 1'b0;
        pon_watchdog_timeout        <= 1'b0;
        psu_watchdog_timeout        <= 1'b0;
        efuse_watchdog_timeout      <= 1'b0;
        vcore_watchdog_timeout      <= 1'b0;
        pdn_watchdog_timeout        <= 1'b0;
        disable_intel_vccin_timeout <= 1'b0;
        disable_3v3_timeout         <= 1'b0;
    end
    else begin
        if (wdt_counter == DSW_PWROK_TIMEOUT_VAL) // 2ms
            dsw_pwrok_timeout <= 1'b1;

        if (wdt_counter == PCH_WATCHDOG_TIMEOUT_VAL) // 100ms                                    
            pch_watchdog_timeout <= 1'b1;                                                        
                                                                                           
        if (wdt_counter == PON_WATCHDOG_TIMEOUT_VAL) // 12ms                                  
            pon_watchdog_timeout <= 1'b1;                                                        
                                                                                           
        if (wdt_counter == PSU_WATCHDOG_TIMEOUT_VAL) // 10ms                                    
           psu_watchdog_timeout <= 1'b1;                                                        
                                                                                           
        if (wdt_counter == EFUSE_WATCHDOG_TIMEOUT_VAL) // 14ms                                     
            efuse_watchdog_timeout <= 1'b1;                                                      
                                                                                           
        if (wdt_counter == DSW_PWROK_TIMEOUT_VAL) // 2ms                                       
            vcore_watchdog_timeout <= 1'b1;                                                      
                                                                                           
        if (wdt_counter == PON_65MS_WATCHDOG_TIMEOUT_VAL) // 65ms                                   
            pon_65ms_watchdog_timeout <= 1'b1;                                                   
                                                                                          
        if (wdt_counter == PDN_WATCHDOG_TIMEOUT_VAL) // 2ms              
            pdn_watchdog_timeout <= 1'b1;                                                                                                                                                                                                     
    end 
end 

// Complete flags                                                                         
// - Used for holding off actions form occurring until enough time has passed             
always @(posedge clk or posedge reset) begin                                              
  if (reset) begin                                                                        
    dc_on_wait_complete         <= 1'b0;                                                  
    po_on_wait_complete         <= 1'b0;                                                  
    s5_devices_on_wait_complete <= 1'b0;
  end
  else if (t1us) begin
    if (!off_state ) begin
        dc_on_wait_complete         <= 1'b0;
        po_on_wait_complete         <= 1'b0;
        s5_devices_on_wait_complete <= 1'b0;
    end
    else begin
      if (((wdt_counter == DC_ON_WAIT_COMPLETE_NOFLT_VAL) && !power_fault) ||
          ((wdt_counter == DC_ON_WAIT_COMPLETE_FAULT_VAL) &&  power_fault))
        dc_on_wait_complete <= 1'b1;

      if (wdt_counter == PO_ON_WAIT_COMPLETE_VAL)
        po_on_wait_complete <= 1'b1;

      if (((wdt_counter == S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL) && !power_fault) ||
          ((wdt_counter == S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL) &&  power_fault))
        s5_devices_on_wait_complete <= 1'b1;
    end
  end
end

// 全局PGD信号
always @(posedge clk or posedge reset) begin
  if (reset)
    pgd_so_far <= 1'b0;
  else
    pgd_so_far <= 1'b1;
end

// 上电故障
always @(posedge clk or posedge reset)begin
    if(reset)
        power_on_critical_fail_en <= 1'b0;
    else if(keep_alive_on_fault)
        power_on_critical_fail_en <= 1'b0;
    else 
        power_on_critical_fail_en <= (dsw_pwrok_timeout & ~pgd_so_far) | any_pwr_fault_det;
end

// PCIE_RESET 状态跳转使能信号(等待DEVICE_PCIE_RST_N所有)
always @(posedge clk or posedge reset)begin
    if(reset)
        pcie_reset_state_trans_en <= 1'b0               ;
    else 
        pcie_reset_state_trans_en <= i_cpu_peu_prest_n_r;
end

// 记录当前状态机状态
wire        st_off_standby                 ;
wire        st_ps_on                       ;
wire        st_steady_pwrok                ;
wire        st_critical_fail               ;
wire        st_halt_power_cycle            ;
wire        st_disable_main_efuse          ;

assign power_seq_sm          = curr_state                               ;

assign st_off_standby        = (power_seq_sm == SM_OFF_STANDBY)         ;
assign st_ps_on              = (power_seq_sm == SM_PS_ON)               ;
assign st_steady_pwrok       = (power_seq_sm == SM_STEADY_PWROK)        ;
assign st_critical_fail      = (power_seq_sm == SM_CRITICAL_FAIL)       ;
assign st_halt_power_cycle   = (power_seq_sm == SM_HALT_POWER_CYCLE)    ;
assign st_disable_main_efuse = (power_seq_sm == SM_DISABLE_MAIN_EFUSE)  ;

/* ------------------------------------------------------------------------------------------------------------
主板上下电状态机
---------------------------------------------------------------------------------------------------------------*/
// FSM 状态变量
reg    [5:0]                                  curr_state                          ; // 当前状态
reg    [5:0]                                  next_state                          ; // 下一状态

// FSM 1
always @(posedge clk or posedge reset) begin
    if (reset)
        curr_state <= `SM_RESET_STATE ; // 初始复位状态
    else if(t1us)
        curr_state <= next_state      ; // 状态切换, 每1us更新一次
end

// FSM 2
always @(*) begin
    // 默认值，防止锁存
    next_state = curr_state; 

    case (curr_state)
        `SM_RESET_STATE: begin
            next_state = `SM_EN_P3V3_VCC          ;
        end

        `SM_EN_P3V3_VCC: begin
            if(critical_fail_en_sm_en_p3v3_vcc)
                next_state = `SM_CRITICAL_FAIL    ;
            else if(dsw_pwrok_timeout)
                next_state = `SM_EN_P1V8_CPU_GPIO ;
        end

        `SM_RESET_STATE: begin
            next_state = `SM_EN_P0V8_CPU_VDD_VCORE;
        end

        `SM_EN_P0V8_CPU_VDD_VCORE: begin
            if(power_on_critical_fail_en)
                next_state = `SM_CRITICAL_FAIL    ;
            else if()
            else if(dsw_pwrok_timeout)
                next_state = `SM_EN_P1V8_CPU_GPIO ;
        end

        `SM_EN_P1V8_CPU_GPIO: begin
            if(power_on_critical_fail_en)
                next_state = `SM_CRITICAL_FAIL    ;
            else if(dsw_pwrok_timeout)
                next_state = `SM_EN_DDR_VDDQ      ;

        end

        `SM_EN_DDR_VDDQ: begin
            if(power_on_critical_fail_en)
                next_state = `SM_CRITICAL_FAIL    ;
            else if(dsw_pwrok_timeout)
                next_state = `SM_EN_PCIE_VP_VPU   ;
        end

        `SM_EN_PCIE_VP_VPU: begin
            if(power_on_critical_fail_en)
                next_state = `SM_CRITICAL_FAIL    ;
            else if(dsw_pwrok_timeout)
                next_state = `SM_DEVICE_PCIE_RESET;
        end 

        `SM_DEVICE_PCIE_RESET: begin
            if(power_on_critical_fail_en)
                next_state = `SM_CRITICAL_FAIL    ;
            else if(pcie_reset_state_trans_en) // 等待PCIE解复位后, 等待10ms再释放CPU POR
                next_state = `SM_CPU_POR_N        ;
        end

        `SM_CPU_POR_N: begin
            if(power_on_critical_fail_en)
                next_state = `SM_CRITICAL_FAIL    ;
            else if(por_watchdog_timeout) // 等待10ms
                next_state = `SM_WAIT_POWEROK     ;
        end 

        `SM_WAIT_POWEROK: begin
            if(power_on_critical_fail_en)                             
                next_state = SM_CRITICAL_FAIL     ;
            else if(pon_watchdog_timeout)      
                next_state = SM_STEADY_PWROK      ;
        end 

        `SM_STEADY_PWROK: begin
            if(rt_critical_fail_store)                                
                next_state = SM_CRITICAL_FAIL;
            else if(rt_normal_pwr_down)                               
                next_state = SM_CRITICAL_FAIL;
            else if (~cpu_power_off)                                   
                next_state = SM_CRITICAL_FAIL;
            else if (~pch_sys_reset_n)                                 
                next_state = SM_CRITICAL_FAIL;
            else 
                next_state = SM_STEADY_PWROK ;
        end

        `SM_CRITICAL_FAIL: begin
            if(pon_watchdog_timeout)
                next_state = `SM_DISABLE_PCIE_VP_VPU;
        end 

        `SM_DISABLE_PCIE_VP_VPU: begin
            if(pon_watchdog_timeout)
                next_state = `SM_DISABLE_DDR_VDDQ_VDDQCK_PLL;
        end 

        `SM_DISABLE_DDR_VDDQ_VDDQCK_PLL: begin
            if(pon_watchdog_timeout)
                next_state = `SM_DISABLE_P1V8_CPU_GPIO_VT_EFUSE;
        end 

        `SM_DISABLE_P1V8_CPU_GPIO_VT_EFUSE: begin
            if(pon_watchdog_timeout)
                next_state = `SM_DISABLE_P0V8_CPU_VDD_VCORE;
        end 

        `SM_DISABLE_P0V8_CPU_VDD_VCORE: begin
            if(pon_watchdog_timeout)begin
                if(any_pwr_fault_det)
                    next_state = `SM_DISABLE_P0V8_CPU_VDD_VCORE;
                else 
                    next_state = `SM_RESET_STATE               ;   
            end
        end 
        default : next_state = `SM_RESET_STATE               ;  
    endcase
end 

// FSM3
// 各组电源轨EN信号输出
always @(posedge clk or posedge reset) begin
    if(reset)begin
        // GR1 
		o_pal_cpu0_vdd_core_p0v8_en <= 1'b0;
        o_pal_cpu1_vdd_core_p0v8_en <= 1'b0;
        // GR2
        o_pal_cpu0_p1v8_en          <= 1'b0;
        o_pal_cpu1_p1v8_en          <= 1'b0;
        // GR3
        o_pal_cpu0_vddq_p1v1_en     <= 1'b0;
        o_pal_cpu1_vddq_p1v1_en     <= 1'b0;
        o_pal_cpu0_ddr_vdd_en       <= 1'b0;
        o_pal_cpu1_ddr_vdd_en       <= 1'b0;
        o_pal_cpu0_pll_p1v8_en      <= 1'b0;
        o_pal_cpu1_pll_p1v8_en      <= 1'b0;
        // GR4
        o_pal_cpu0_d0_vp_p1v1_en    <= 1'b0;
        o_pal_cpu0_d1_vp_p1v1_en    <= 1'b0;
        o_pal_cpu0_d0_vph_p1v8_en   <= 1'b0;
        o_pal_cpu0_d1_vph_p1v8_en   <= 1'b0;
        o_pal_cpu1_d0_vp_p1v1_en    <= 1'b0;
        o_pal_cpu1_d1_vp_p1v1_en    <= 1'b0;
        o_pal_cpu1_d0_vph_p1v8_en   <= 1'b0;
        o_pal_cpu1_d1_vph_p1v8_en   <= 1'b0;
	end
    else begin
        case(curr_state)
            `SM_RESET_STATE: begin
                // GR1
                o_pal_cpu0_vdd_core_p0v8_en <= 1'b0;
                o_pal_cpu1_vdd_core_p0v8_en <= 1'b0;
                // GR2
                o_pal_cpu0_p1v8_en          <= 1'b0;
                o_pal_cpu1_p1v8_en          <= 1'b0;
                // GR3
                o_pal_cpu0_vddq_p1v1_en     <= 1'b0;
                o_pal_cpu1_vddq_p1v1_en     <= 1'b0;
                o_pal_cpu0_ddr_vdd_en       <= 1'b0;
                o_pal_cpu1_ddr_vdd_en       <= 1'b0;
                o_pal_cpu0_pll_p1v8_en      <= 1'b0;
                o_pal_cpu1_pll_p1v8_en      <= 1'b0;
                // GR4
                o_pal_cpu0_d0_vp_p1v1_en    <= 1'b0;
                o_pal_cpu0_d1_vp_p1v1_en    <= 1'b0;
                o_pal_cpu0_d0_vph_p1v8_en   <= 1'b0;
                o_pal_cpu0_d1_vph_p1v8_en   <= 1'b0;
                o_pal_cpu1_d0_vp_p1v1_en    <= 1'b0;
                o_pal_cpu1_d1_vp_p1v1_en    <= 1'b0;
                o_pal_cpu1_d0_vph_p1v8_en   <= 1'b0;
                o_pal_cpu1_d1_vph_p1v8_en   <= 1'b0;
                // POR_N(待PCIE解复位后, 等待10ms再释放CPU POR)
                o_cpu0_por_n_r              <= 1'b0;
                o_cpu1_por_n_r              <= 1'b0;
            end
            `SM_EN_P0V8_CPU_VDD_VCORE: begin
                // GR1
                o_pal_cpu0_vdd_core_p0v8_en <= 1'b1;
                o_pal_cpu1_vdd_core_p0v8_en <= 1'b1;
            end

            `SM_EN_P1V8_CPU_GPIO: begin
                // GR2
                o_pal_cpu0_p1v8_en          <= 1'b1;
                o_pal_cpu1_p1v8_en          <= 1'b1;
            end

            `SM_EN_DDR_VDDQ: begin
                // GR3
                o_pal_cpu0_vddq_p1v1_en     <= 1'b1;
                o_pal_cpu1_vddq_p1v1_en     <= 1'b1;
                o_pal_cpu0_ddr_vdd_en       <= 1'b1;
                o_pal_cpu1_ddr_vdd_en       <= 1'b1;
                o_pal_cpu0_pll_p1v8_en      <= 1'b1;
                o_pal_cpu1_pll_p1v8_en      <= 1'b1;
            end

            `SM_EN_PCIE_VP_VPU: begin
                // GR4
                o_pal_cpu0_d0_vp_p1v1_en    <= 1'b1;
                o_pal_cpu0_d1_vp_p1v1_en    <= 1'b1;
                o_pal_cpu0_d0_vph_p1v8_en   <= 1'b1;
                o_pal_cpu0_d1_vph_p1v8_en   <= 1'b1;
                o_pal_cpu1_d0_vp_p1v1_en    <= 1'b1;
                o_pal_cpu1_d1_vp_p1v1_en    <= 1'b1;
                o_pal_cpu1_d0_vph_p1v8_en   <= 1'b1;
                o_pal_cpu1_d1_vph_p1v8_en   <= 1'b1;
            end

            `SM_DEVICE_PCIE_RESET: begin
                // POR_N(要等待PCIE解复位后, 等待10ms再释放CPU POR)
                o_cpu0_por_n_r              <= 1'b0;
                o_cpu1_por_n_r              <= 1'b0;
            end

            `SM_CPU_POR_N: begin
                // POR_N(待PCIE解复位后, 等待10ms再释放CPU POR)
                o_cpu0_por_n_r              <= 1'b1;
                o_cpu1_por_n_r              <= 1'b1;
            end 

            `SM_STEADY_PWROK: begin
                // CPU_POWER_GOOD 输出高
                o_cpu_power_good            <= 1'b1;
            end

            `SM_CRITICAL_FAIL: begin
                // 上电错误时, 拉低CPU_POWER_GOOD
                o_cpu_power_good            <= 1'b0;
                // 上电错误时, 拉低CPU0/1_POR_N_R
                o_cpu0_por_n_r              <= 1'b0;
                o_cpu1_por_n_r              <= 1'b0;
            end

            `SM_DISABLE_PCIE_VP_VPU: begin
                // GR4
                o_pal_cpu0_d0_vp_p1v1_en    <= 1'b0;
                o_pal_cpu0_d1_vp_p1v1_en    <= 1'b0;
                o_pal_cpu0_d0_vph_p1v8_en   <= 1'b0;
                o_pal_cpu0_d1_vph_p1v8_en   <= 1'b0;
                o_pal_cpu1_d0_vp_p1v1_en    <= 1'b0;
                o_pal_cpu1_d1_vp_p1v1_en    <= 1'b0;
                o_pal_cpu1_d0_vph_p1v8_en   <= 1'b0;
                o_pal_cpu1_d1_vph_p1v8_en   <= 1'b0;
            end

            `SM_DISABLE_DDR_VDDQ_VDDQCK_PLL：begin
                // GR3
                o_pal_cpu0_vddq_p1v1_en     <= 1'b0;
                o_pal_cpu1_vddq_p1v1_en     <= 1'b0;
                o_pal_cpu0_ddr_vdd_en       <= 1'b0;
                o_pal_cpu1_ddr_vdd_en       <= 1'b0;
                o_pal_cpu0_pll_p1v8_en      <= 1'b0;
                o_pal_cpu1_pll_p1v8_en      <= 1'b0;
            end 

            `SM_DISABLE_P1V8_CPU_GPIO_VT_EFUSE: begin
                // GR2
                o_pal_cpu0_p1v8_en          <= 1'b0;
                o_pal_cpu1_p1v8_en          <= 1'b0;
            end
            
            `SM_DISABLE_P0V8_CPU_VDD_VCORE: begin
                // GR1
                o_pal_cpu0_vdd_core_p0v8_en <= 1'b0;
                o_pal_cpu1_vdd_core_p0v8_en <= 1'b0;
            end
        endcase
    end 
end 

// 状态机控制其他信号输出
always @(posedge clk or posedge reset) begin
    if (reset) begin
        reached_sm_wait_powerok <= 1'b0;
    end 
    else begin
        case (curr_state)
            `SM_RESET_STATE : begin
                reached_sm_wait_powerok    <= 1'b0; 
            end 
            `SM_WAIT_POWEROK: begin
                reached_sm_wait_powerok    <= 1'b1; 
            end 

            `SM_DISABLE_PCIE_VP_VPU: begin
                reached_sm_wait_powerok    <= 1'b0; 
            end 
        endcase
    end 



endmodule