/* =================================================================================================
电源上下电模块
上电时序如下
1. CPU_VDD_CORE电: 
    - P3V3_STBY电稳定后2ms内使能 PAL_CPU0/1_VDD_CORE_EN_R
2. CPU0_Dn_GPIO_VDDH/CPU_VT_AVDDH/CPU0_D0_EFUSE_VDDH/电:
    - CPU_VDD_CORE电稳定后2ms内使能 PAL_CPU0_Dn_GPIO_VDDH_EN_R/PAL_CPU_VT_AVDDH_EN_R/PAL_CPU0_D0_EFUSE_VDDH_EN_R

===================================================================================================*/
`include "rs35m2c16s_g5_define.vh"
`include "pwrseq_define.vh"
module pwrseq_master #(
    parameter LIM_RECOV_MAX_RETRY_ATTEMPT           = 2                         , // 最大恢复重试次数
    parameter WDT_NBITS                             = 10                        , // 看门狗计数器位宽
    
    parameter P3V3_VCC_WATCHDOG_TIOMEOUT_VAL        = 2                         , // P3V3          超时时间
    parameter PON_WATCHDOG_TIMEOUT_VAL              = 112                       , // PON_PWROK     超时时间
    parameter PSU_WATCHDOG_TIMEOUT_VAL              = 10                        , // PSU_PWROK     超时时间
    parameter EFUSE_WATCHDOG_TIMEOUT_VAL            = 137                       , // EFUSE_PWROK   超时时间
    parameter PCH_WATCHDOG_TIMEOUT_VAL              = 1000                      , // PCH_PWROK     超时时间
    parameter DSW_PWROK_TIMEOUT_VAL                 = 10                        , // DSW_PWROK     超时时间
    parameter PON_65MS_WATCHDOG_TIMEOUT_VAL         = 34                        , // 上电使用, 65ms 超时时间

 
    parameter VCORE_WATCHDOG_TIMEOUT_VAL            = PON_WATCHDOG_TIMEOUT_VAL  , // 
    parameter PDN_WATCHDOG_TIMEOUT_VAL              = 2                         , // 
    parameter PDN_WATCHDOG_TIMEOUT_FAULT_VAL        = PDN_WATCHDOG_TIMEOUT_VAL  , // 
    parameter DISABLE_INTEL_VCCIN_TIMEOUT_VAL       = PDN_WATCHDOG_TIMEOUT_VAL  , // 
    parameter DISABLE_INTEL_VCCIN_TIMEOUT_FAULT_VAL = PDN_WATCHDOG_TIMEOUT_VAL  , // 
    parameter DISABLE_3V3_TIMEOUT_VAL               = PDN_WATCHDOG_TIMEOUT_VAL  , // 
    parameter DISABLE_3V3_TIMEOUT_FAULT_VAL         = PDN_WATCHDOG_TIMEOUT_VAL  , // 
    

    parameter PF_ON_WAIT_COMPLETE_VAL               = 33                        , // 电源故障等待完成时间
    parameter PO_ON_WAIT_COMPLETE_VAL               = 1                         , // 电源开启等待完成时间

    parameter S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL = 0                         , // 无故障时S5设备开启等待时间                       
    parameter S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL = 0                         , // 有故障时S5设备开启等待时间
    parameter DC_ON_WAIT_COMPLETE_NOFLT_VAL         = 17                        , // 无故障时DC ON等待完成时间 
    parameter DC_ON_WAIT_COMPLETE_FAULT_VAL         = 2                           // 有故障时DC ON等待完成时间 
)(                      
    input            clk                        , // clock
    input            reset                      , // reset

    input            t1us                       , // 10ns pulse every 1us
    input            t512us                     , // 10ns pulse every 512us
    input            t256ms                     , // 10ns pulse every 256ms
    input            t512ms                     , // 10ns pulse every 500ms
    input            sequence_tick              , // tick used for wdt timeout during power-up/down states
    input            psu_on_tick                , // tick used for wdt timeout during PS on state

    // Physical power button and south bridge status/control
    input            sys_sw_in_n                , // system's power button switch
    // input            pch_slp4_n                , // SB (south bridge) system sleep state
    input            pch_pwrbtn_n               , // SB power button input (same signal driven to SB PWRBTN)
    input            pch_pwrbtn_s               , // SB power button input (same signal driven to SB PWRBTN) delay 1s
  
    input            pch_thermtrip_n            , // SB bound thermtrip signal (same signal driven to SB THERMTRIP)
    output reg       force_pwrbtn_n             , // forces SB to switch to S5 after power shutdown due to fault

    input            cpu_reboot                 , // cpu�ͳ����������1��Ч,���5s�ͳ�
    input            cpu_reboot_x               , // cpu�ͳ����������1��Ч,���3s�ͳ�
    input            cpu_power_off              , // CPU �ͳ����µ����0��Ч

    input            xr_ps_en                   , // system allowed to power on (Xreg's ps_enable)  //�Ĵ���51.Ĭ������0,��ʾ����PSU���������(PSON
    //YHY  input            pwron_override_n,      // power-on override    Ĭ������1
    //YHY  input            interlock_broken,      // interlock broken indicator
    input            allow_recovery             , // allow power button press to recover from HALT_POWER_CYCLE
    //YHY  input            aux_video_holdoff,     // allow AUX video to hold turning on of system
    //YHY  input            pgood_rst_mask,        // from ADR module to mask shutdown events
    //YHY  input            cpu_mcp_en,            // any CPU is MCP enabled which enables P1V0_CPU and PVMCP_CPU rails
    input            keep_alive_on_fault        , // prevent transition to critical fail on power up
    //yhy  input            no_vppen,              // set to 1'b1 if platform does not have an explicity EN for VPP rails
    //yhy  input            hold_pch_rsmrst,       // set to 1'b1 to stall power sequencer in state before RSMRST# is released
    output reg       pgd_raw                    , // de-asserts on SM_STEADY_OK on fault condition

    // S5 powered device control
    input            s5dev_pwren_request        , // S5 powered device enable request
    input            s5dev_pwrdis_request       , // S5 powered device disable request

    // Slave sequencer interface
    input            pgd_so_far                 , // current overall power status
    input            any_pwr_fault_det          , // any type of power fault
    input            any_lim_recov_fault        , // any limited recovery fault
    input            any_non_recov_fault        , // any non-recoverable fault
    output reg       dc_on_wait_complete        , // 4s flag - used by slave for stuck on check
    output reg       rt_critical_fail_store     , // asserts when during runtime when critical failure detected
    output reg       fault_clear                , // clear fault flags
    output [5:0]     power_seq_sm               , // copy of the state variable

    //POWER_OFF_FLAG
    output reg       pch_thermtrip_FLAG         , 
    output reg       CPU_OFF_FLAG               ,
    output reg       REBOOT_FLAG                , 

    input            Power_WAKE_R_N             ,
    input            pch_sys_reset_n            ,
    output reg       turn_system_on             ,

    // 状态监控
    output reg       power_fault                , // power fault is active
    output reg       stby_failure_detected      , // standby failure detected (goes to Xreg byte07[4]
    output reg       po_failure_detected        , // poweron failure detected (goes to Xreg byte07[2])
    output reg       rt_failure_detected        , // runtime failure detected (goes to Xreg byte07[5])
    output reg       cpld_latch_sys_off         , // system in non-recovery state (goes to Xreg byte08[6])
    output reg       turn_on_wait                 // system waiting to turn on
);

// “有限恢复最大重试次数”，自动计算重试计数器的位宽，避免手动定义位宽导致的资源浪费或计数溢出。
function integer clogb2 (input [31:0] value);
    reg [31:0] tmp;
    begin
        tmp = (value <= 2) ? 2 : (value - 1); // 处理边界：value≤2时强制tmp=2，避免位宽不足
        for (clogb2 = 0; tmp > 0; clogb2 = clogb2 + 1)
            tmp = tmp >> 1;
    end
endfunction
localparam LIM_RECOV_RETRY_NBITS = clogb2(LIM_RECOV_MAX_RETRY_ATTEMPT);

/* ------------------------------------------------------------------------------------------------------------
状态监控, 计数器用于控制各个上电状态延时, 状态跳转
---------------------------------------------------------------------------------------------------------------*/
reg    [5:0]                                  power_seq_sm_last                 ; //上一个状态
wire                                          st_off_standby                    ; //状态机 SM_OFF_STANDBY 状态
wire                                          st_ps_on                          ; //状态机 SM_PS_ON 状态
wire                                          st_steady_pwrok                   ; //状态机 SM_STEADY_PWROK 状态
wire                                          st_critical_fail                  ; //状态机 SM_CRITICAL_FAIL 状态
wire                                          st_halt_power_cycle               ; //状态机 SM_HALT_POWER_CYCLE 状态
wire                                          st_disable_main_efuse             ; //状态机 SM_DISABLE_MAIN_EFUSE 状态

// 当前状态信号枚举分类
assign st_off_standby        = (power_seq_sm == `SM_OFF_STANDBY         );
assign st_ps_on              = (power_seq_sm == `SM_PS_ON               );
assign st_steady_pwrok       = (power_seq_sm == `SM_STEADY_PWROK        );
assign st_critical_fail      = (power_seq_sm == `SM_CRITICAL_FAIL       );
assign st_halt_power_cycle   = (power_seq_sm == `SM_HALT_POWER_CYCLE    );
assign st_disable_main_efuse = (power_seq_sm == `SM_DISABLE_MAIN_EFUSE  );

// 上下电状态输出, 供外部模块判断使用
assign power_seq_sm = state;

// 监测状态机状态变化, 清零看门狗计数器, 时间间隔1us
always @(posedge clk or posedge reset) begin
  if (reset)
    power_seq_sm_last <= `SM_RESET_STATE;
  else if(t1us)
    power_seq_sm_last <= power_seq_sm;
end

// 上下电看门狗计数器
wire                                          wdt_tick                          ; // 看门狗计数器触发脉冲
reg     [WDT_NBITS-1:0]                       wdt_counter                       ; // 看门狗计数器
wire                                          wdt_counter_clr                   ; // 看门狗计数器清零信号

// 状态跳转时清空看门狗计数器
assign wdt_counter_clr = (power_seq_sm_last != power_seq_sm);

// 看门狗计数器触发脉冲生成
assign  wdt_tick = (off_state) ? t256ms       :  // 256ms 下电状态
                   (st_ps_on ) ? psu_on_tick  :  // 32ms  S5-S3状态
                                 sequence_tick;  // 2ms   其他状态

// 状态跳转时计数器清空
assign  wdt_counter_clr = (power_seq_sm_last != power_seq_sm);

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
// 各阶段超时标志：电源组A/B就绪超时、上电超时、PSU超时、eFuse超时、Vcore超时、断电超时等
reg                                           p3v3_vcc_watchdog_timeout         ;
reg                                           pon_watchdog_timeout              ;
reg                                           pch_watchdog_timeout              ;
reg                                           dsw_pwrok_timeout                 ;


reg                                           psu_watchdog_timeout              ;
reg                                           efuse_watchdog_timeout            ;
reg                                           vcore_watchdog_timeout            ;
reg                                           pdn_watchdog_timeout              ;
reg                                           disable_intel_vccin_timeout       ;
reg                                           disable_3v3_timeout               ;
reg                                           pon_65ms_watchdog_timeout         ;
reg                                           pf_on_wait_complete               ;
reg                                           po_on_wait_complete               ;
reg                                           s5_devices_on_wait_complete       ;

// 上电延时
always @(posedge clk or posedge reset) begin
    if (reset)begin
        p3v3_vcc_watchdog_timeout   <= 1'b0;
        pon_watchdog_timeout        <= 1'b0;
        psu_watchdog_timeout        <= 1'b0;
        efuse_watchdog_timeout      <= 1'b0;
        pch_watchdog_timeout        <= 1'b0;
        dsw_pwrok_timeout           <= 1'b0;

        

        vcore_watchdog_timeout      <= 1'b0;
        pon_65ms_watchdog_timeout   <= 1'b0;
        pdn_watchdog_timeout        <= 1'b0;
        disable_intel_vccin_timeout <= 1'b0;
        disable_3v3_timeout         <= 1'b0;
    end
  else if(wdt_counter_clr)begin
        p3v3_vcc_watchdog_timeout   <= 1'b0;
        pon_watchdog_timeout        <= 1'b0;
        psu_watchdog_timeout        <= 1'b0;
        efuse_watchdog_timeout      <= 1'b0;
        pch_watchdog_timeout        <= 1'b0;
        dsw_pwrok_timeout           <= 1'b0;

        

        vcore_watchdog_timeout      <= 1'b0;
        pon_65ms_watchdog_timeout   <= 1'b0;
        pdn_watchdog_timeout        <= 1'b0;
        disable_intel_vccin_timeout <= 1'b0;
        disable_3v3_timeout         <= 1'b0;
  end
  else if (wdt_tick) begin
      if(wdt_counter == P3V3_VCC_WATCHDOG_TIOMEOUT_VAL)// 2ms                                  
          p3v3_vcc_watchdog_timeout <= 1'b1; 

      if(wdt_counter == PON_WATCHDOG_TIMEOUT_VAL)// 112ms                                  
          pon_watchdog_timeout <= 1'b1;   

      if(wdt_counter == PSU_WATCHDOG_TIMEOUT_VAL)// 10ms                                     
          psu_watchdog_timeout <= 1'b1;  

      if(wdt_counter == EFUSE_WATCHDOG_TIMEOUT_VAL)// 137ms                                     
          efuse_watchdog_timeout <= 1'b1;   

      if(wdt_counter == PCH_WATCHDOG_TIMEOUT_VAL)// 1000ms                                 
          pch_watchdog_timeout <= 1'b1; 

      if(wdt_counter == DSW_PWROK_TIMEOUT_VAL)// 10ms                                
          dsw_pwrok_timeout <= 1'b1;        

      if (wdt_counter == PON_65MS_WATCHDOG_TIMEOUT_VAL) // 65ms                                     
          pon_65ms_watchdog_timeout <= 1'b1;   


      if (wdt_counter == VCORE_WATCHDOG_TIMEOUT_VAL)                                         
          vcore_watchdog_timeout <= 1'b1;                                                      
                                                                                           
                                                      
                                                                                          
      if (((wdt_counter == PDN_WATCHDOG_TIMEOUT_VAL)       && !power_fault) ||              
          ((wdt_counter == PDN_WATCHDOG_TIMEOUT_FAULT_VAL) &&  power_fault))                
          pdn_watchdog_timeout <= 1'b1;                                                       
                                                                                          
      if (((wdt_counter == DISABLE_INTEL_VCCIN_TIMEOUT_VAL)       && !power_fault) ||       
          ((wdt_counter == DISABLE_INTEL_VCCIN_TIMEOUT_FAULT_VAL) &&  power_fault))         
          disable_intel_vccin_timeout <= 1'b1;                                                
                                                                                          
      if (((wdt_counter == DISABLE_3V3_TIMEOUT_VAL)       && !power_fault) ||               
          ((wdt_counter == DISABLE_3V3_TIMEOUT_FAULT_VAL) &&  power_fault))                 
          disable_3v3_timeout <= 1'b1;                                                        
    end                                                                                     
end

/* ------------------------------------------------------------------------------------------------------------
系统上下电控制信号 fail/en 
供状态机跳转使用
---------------------------------------------------------------------------------------------------------------*/
// 上电状态跳转的cril/en标志, PG+延时控制
reg                                          p3v3_vcc_critical_fail_en        ;
reg                                          p3v3_vcc_state_trans_en          ;

reg                                          pwron_critical_fail_en           ;
reg                                          pwrup_state_trans_en             ;

reg                                          psu_critical_fail_en             ;
reg                                          psu_state_trans_en               ;

reg                                          efuse_critical_fail_en           ;
reg                                          efuse_state_trans_en             ;

reg                                          pch_critical_fail_en             ;
reg                                          pch_state_trans_en               ;

reg                                          pchdsw_critical_fail_en          ;
reg                                          pchdsw_state_trans_en            ;

reg                                          wait_steady_pwrok_fail_en        ;
reg                                          wait_steady_pwrok_state_trans_en ; 

// 上电 critical
always @(posedge clk or posedge reset)begin
    if(reset)begin
        p3v3_vcc_critical_fail_en <= 1'b0;
        pwron_critical_fail_en    <= 1'b0;
        psu_critical_fail_en      <= 1'b0;
        efuse_critical_fail_en    <= 1'b0;
        pch_critical_fail_en      <= 1'b0;
        pchdsw_critical_fail_en   <= 1'b0;
        wait_steady_pwrok_fail_en <= 1'b0;
    end 
    else if(keep_alive_on_fault)begin
        p3v3_vcc_critical_fail_en <= 1'b0;
        pwron_critical_fail_en    <= 1'b0;
        psu_critical_fail_en      <= 1'b0;
        efuse_critical_fail_en    <= 1'b0;
        pch_critical_fail_en      <= 1'b0;
        pchdsw_critical_fail_en   <= 1'b0;
        wait_steady_pwrok_fail_en <= 1'b0;
    end 
    else begin
        p3v3_vcc_critical_fail_en <= (p3v3_vcc_watchdog_timeout & ~pgd_so_far) | any_pwr_fault_det;
        pwron_critical_fail_en    <= (pon_watchdog_timeout      & ~pgd_so_far) | any_pwr_fault_det;  
        psu_critical_fail_en      <= (psu_watchdog_timeout      & ~pgd_so_far) | any_pwr_fault_det;
        efuse_critical_fail_en    <= (efuse_watchdog_timeout    & ~pgd_so_far) | any_pwr_fault_det;
        pch_critical_fail_en      <= (pch_watchdog_timeout      & ~pgd_so_far) | any_pwr_fault_det;
        pchdsw_critical_fail_en   <= (dsw_pwrok_timeout         & ~pgd_so_far) | any_pwr_fault_det;
        wait_steady_pwrok_fail_en <= (pon_65ms_watchdog_timeout & ~pgd_so_far) | any_pwr_fault_det;
    end 
end 

// 上电 en
always @(posedge clk or posedge reset)begin
    if(reset)begin
        p3v3_vcc_state_trans_en          <= 1'b0;
        pwrup_state_trans_en             <= 1'b0;
        psu_state_trans_en               <= 1'b0;
        efuse_state_trans_en             <= 1'b0;
        pch_state_trans_en               <= 1'b0;
        pchdsw_state_trans_en            <= 1'b0;
        wait_steady_pwrok_state_trans_en <= 1'b0;
    end 
    else begin
        p3v3_vcc_state_trans_en          <= p3v3_vcc_watchdog_timeout & pgd_so_far;
        pwrup_state_trans_en             <= pon_watchdog_timeout      & pgd_so_far;
        psu_state_trans_en               <= psu_watchdog_timeout      & pgd_so_far;
        efuse_state_trans_en             <= efuse_watchdog_timeout    & pgd_so_far;
        pch_state_trans_en               <= pch_watchdog_timeout      & pgd_so_far;
        pchdsw_state_trans_en            <= dsw_pwrok_timeout         & pgd_so_far; 
        wait_steady_pwrok_state_trans_en <= pon_65ms_watchdog_timeout & pgd_so_far;
    end 
end

/* ------------------------------------------------------------------------------------------------------------
系统上下电控制信号, 其他
供状态机跳转使用
---------------------------------------------------------------------------------------------------------------*/
// 上电各阶段complete标志（CPU反馈信息控制）
reg                                       s5_devices_on_wait_complete ; // S5设备开启完成
reg                                       dc_on_wait_complete         ; // DC_ON等待完成; 非fault:17ms; fault:2ms     
reg                                       po_on_wait_complete         ; // PO_ON等待完成; 1ms;
reg                                       pf_on_wait_complete         ; // PO_FAULT等待完成; 17ms;

always @(posedge clk or posedge reset) begin                                              
    if(reset)begin 
        s5_devices_on_wait_complete <= 1'b0;                                                                       
        dc_on_wait_complete         <= 1'b0;                                                  
        po_on_wait_complete         <= 1'b0;                                                  
        pf_on_wait_complete         <= 1'b0;
    end
  else if(t1us)begin
    	if(!off_state)begin
          s5_devices_on_wait_complete <= 1'b0;
          dc_on_wait_complete         <= 1'b0;
          po_on_wait_complete         <= 1'b0;
          pf_on_wait_complete         <= 1'b0;
      end
      else begin
        if(((wdt_counter == S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL) && !power_fault) ||
           ((wdt_counter == S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL) &&  power_fault))
            s5_devices_on_wait_complete <= 1'b1;

        if(((wdt_counter == DC_ON_WAIT_COMPLETE_NOFLT_VAL) && !power_fault) ||
           ((wdt_counter == DC_ON_WAIT_COMPLETE_FAULT_VAL) &&  power_fault))
            dc_on_wait_complete <= 1'b1;

        if(wdt_counter == PO_ON_WAIT_COMPLETE_VAL)
            po_on_wait_complete <= 1'b1;
        
        if(wdt_counter == PF_ON_WAIT_COMPLETE_VAL)
            pf_on_wait_complete <= 1'b1;
      end
  end
end

// 上下电按钮相关的逻辑
wire                                      pch_pwrbtn_n_ne             ;
wire                                      sys_sw_in_n_ne              ;

wire                                      Power_WAKE_R_N_ne           ;
wire                                      cpu_reboot_ne               ;

reg                                       assert_power_button         ;
reg                                       assert_physical_button      ;
reg                                       assert_button_clr           ;

// 物理按键 负边沿检测
edge_detect #(.SIGCNT(2), .DEF_INIT(2'b11)) edge_detect_button_ne_inst (
    .reset       (reset),
    .clk         (clk),
    .tick        (1'b1),
    .signal_in   ({pch_pwrbtn_n, sys_sw_in_n}), // pch_pwrbtn_n和sys_sw_in_n相同, 均为低有效.
    .detect_pe   (),
    .detect_ne   ({pch_pwrbtn_n_ne, sys_sw_in_n_ne}),
    .detect_any  ()
);

// CPU_WAKE_R_N 和 cpu_reboot 负边沿检测
edge_detect #(.SIGCNT(2), .DEF_INIT(2'b11)) edge_detect_ne_inst (
    .reset       (reset),
    .clk         (clk),
    .tick        (1'b1),
    .signal_in   ({Power_WAKE_R_N, cpu_reboot_x}),
    .detect_pe   (),
    .detect_ne   ({Power_WAKE_R_N_ne, cpu_reboot_ne}),
    .detect_any  ()
);

//------------------------------------------------------------------------------
// force_pwrbtn_n 强制按键”输出，低有效
/*
两类触发条件

在SM_HALT_POWER_CYCLE期间且存在power_fault，并且pf_on_wait_complete尚未完成：
用于故障关机后，维持一段时间的强制按键，使SB完成S0→S5转换。
pf_on_wait_complete的超时参数PF_ON_WAIT_COMPLETE_VAL通常≈8.4s，期间保持低。
在SM_OFF_STANDBY期间且存在power_fault，并且po_on_wait_complete到时，且assert_power_button为真：
用于故障后从S5请求上电（S5→S0），在等待窗口到达时拉低按键一小段时间。
po_on_wait_complete的时间通常≈256ms。
*/
// - Asserts low when power sequencer needs to toggle SB power button input.
// - Note the differet behavior between BL and non-BL platform
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset)begin
    if(reset)
        force_pwrbtn_n <= 1'b1;
    else if (t1us) begin
        // Forces SB power button assertion when any of the following:
        // 1. (Any)   Power fault and waiting for pf_on_wait_complete. Asserts for 8s.
        // 2. (BL/BT) Software request to turn E-fuse back on.
        //            CHECKME: Is this a request to turn-on? Shouldn't this be
        //            po_on_wait_complete as using pf_on_wait_complete will assert the
        //            signal for 8s.
        // 3. (BL)    Power fault and waiting for pf_on_wait_complete. Asserts for 8s.
        // 4. (Any)   Power fault and SB in S5 and power button is asserted. This is a
        //            request to turn on. po_on_wait_complete is masked in BL/BT.
        // 5. (BL/BT) This is a hold term. Keep asserted for 250ms and while SB is in S5.
        // 6. (BL)    In SM_MISS_TURNON state and either pf_on_wait_complete is not
        //            done or SB is still in S0 state. This term is forcing SB to S5.
        // 7. (BL)    In SM_MISS_TURNON and now allowed to turn on (xr_ps_en asserts)
        //            causing f_btn_sr to start shifting. Asserts for 250ms as f_btn_sr
        //            is shifted only every 250ms.
        // YHY    force_pwrbtn_n <=
        // YHY      ~((           st_halt_power_cycle   &  power_fault                          // \ 1.
        // YHY                                          & ~pf_on_wait_complete)              |  // /
        // YHY        (           st_off_standby        &  power_fault                          // \ 4.
        // YHY                                          &  (po_on_wait_complete)                // |
        // YHY                                          &  assert_power_button                  // |
        // YHY                                          & ~pch_slp4_n));                        // /
        // 1. 暂停电源循环状态 + 故障 + 未完成故障恢复等待：强制按钮低（触发下电）
        // 2. 待机状态 + 故障 + 上电完成等待 + 按钮触发 + 南桥非S4：强制按钮低（重试上电）
        force_pwrbtn_n <= ~((st_halt_power_cycle & power_fault & ~pf_on_wait_complete) |  
                            (st_off_standby      & power_fault & (po_on_wait_complete) & assert_power_button));                                                                                             
    end
end

// 物理电源按钮触发标志：标记“用户手动按下物理按钮”事件
always @(posedge clk or posedge reset) begin
    if (reset)
        assert_power_button <= 1'b0;
    else if(assert_button_clr || ~force_pwrbtn_n)    
        assert_power_button <= 1'b0;
    else if ((pch_pwrbtn_n_ne | Power_WAKE_R_N_ne | cpu_reboot_ne) && off_state)
        assert_power_button <= 1'b1;
end

// 物理电源按钮触发标志：在SM_HALT_POWER_CYCLE期间，标记“物理按钮被按下”事件
always @(posedge clk or posedge reset) begin
    if (reset)
        assert_physical_button <= 1'b0;
    else if (assert_button_clr)
        assert_physical_button <= 1'b0;
    else if ((sys_sw_in_n_ne  |  Power_WAKE_R_N_ne |  cpu_reboot_ne )  && st_halt_power_cycle)
        assert_physical_button <= 1'b1;
end

// 系统被允许/请求开始上电（当前xr_ps_en控制写死）
reg                                          turn_system_on ;
always @(posedge clk or posedge reset) begin
    if (reset)
        turn_system_on <= 1'b0;
    else if(t1us)
        turn_system_on <= (xr_ps_en | turn_system_on);                         
end

// 系统上电等待标志
always @(posedge clk or posedge reset) begin
    if (reset)
        turn_on_wait <= 1'b0;
    else if (t1us)     
        turn_on_wait <= (assert_power_button) | (turn_on_wait & ~(st_steady_pwrok | st_critical_fail));                    
end

// 南桥热跳变信号（低有效，表示 CPU / 南桥过温，需紧急下电）
wire pch_thermtrip_n_delay;
edge_delay #(.CNTR_NBITS    (2)) sb_thermtrip_delay_inst (
    .clk           (clk),
    .reset         (reset),
    .cnt_size      (2'b10),
    .cnt_step      (t512us),
    .signal_in     (~pch_thermtrip_n & st_steady_pwrok),
    .delay_output  (pch_thermtrip_n_delay)
);

// 运行下电标志
wire rt_normal_pwr_down;
assign rt_normal_pwr_down =  (~turn_system_on | pch_thermtrip_n_delay);



/* ------------------------------------------------------------------------------------------------------------
主板上下电状态机
---------------------------------------------------------------------------------------------------------------*/
// FSM 状态变量
reg    [5:0]                                  state                             ; // 当前状态
reg    [5:0]                                  state_ns                          ; // 下一状态

// FSM 1
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= `SM_RESET_STATE ; // 初始复位状态
    else if(t1us)
        state <= state_ns        ; // 状态切换, 每1us更新一次
end

// FSM 2
always @(*) begin
    // 默认值，防止锁存
    state_ns = state; 

    case (state)
        `SM_RESET_STATE: begin
            state_ns = `SM_EN_P0V8_CPU_VDD_VCORE;
        end

        `SM_EN_P0V8_CPU_VDD_VCORE: begin
            if(p0v8_vdd_core_critical_fail_en)
                state_ns = `SM_CRITICAL_FAIL    ;
            else if(p0v8_vdd_core_state_trans_en)
                state_ns = `SM_EN_P1V8_CPU_GPIO ;
        end

        `SM_EN_P1V8_CPU_GPIO: begin
            if(p1v8_cpu_gpio_critical_fail_en)
                state_ns = `SM_CRITICAL_FAIL    ;
            else if(p1v8_cpu_gpio_state_trans_en)
                state_ns = `SM_EN_DDR_VDDQ      ;

        end

        `SM_EN_DDR_VDDQ: begin
            if(ddr_vddq_critical_fail_en)
                state_ns = `SM_CRITICAL_FAIL    ;
            else if(ddr_vddq_state_trans_en)
                state_ns = `SM_EN_PCIE_VP_VPU   ;
        end

        `SM_EN_PCIE_VP_VPU: begin
            if(pcie_vp_vpu_critical_fail_en)
                state_ns = `SM_CRITICAL_FAIL    ;
            else if(pcie_vp_vpu_state_trans_en)
                state_ns = `SM_DEVICE_PCIE_RESET;
        end 

        `SM_DEVICE_PCIE_RESET: begin
            if(pcie_reset_critical_fail_en)
                state_ns = `SM_CRITICAL_FAIL    ;
            else if(pcie_reset_state_trans_en)
                state_ns = `SM_CPU_RESET        ;
        end

        `SM_CPU_RESET: begin
            if(cpu_reset_critical_fail_en)
                state_ns = `SM_CRITICAL_FAIL    ;
            else if(cpu_reset_state_trans_en)
                state_ns = `SM_CPU_RESET        ;
        end 

        `SM_WAIT_POWEROK: begin
            if(wait_steady_pwrok_fail_en)                             
                state_ns = SM_CRITICAL_FAIL     ;
            else if(wait_steady_pwrok_state_trans_en)      
                state_ns = SM_STEADY_PWROK      ;
        end 

        `SM_STEADY_PWROK: begin
            if(rt_critical_fail_store)                                
                state_ns = SM_CRITICAL_FAIL;
            else if(rt_normal_pwr_down)                               
                state_ns = SM_CRITICAL_FAIL;
            else if (~cpu_power_off)                                   
                state_ns = SM_CRITICAL_FAIL;
            else if (~pch_sys_reset_n)                                 
                state_ns = SM_CRITICAL_FAIL;
            else 
                state_ns = SM_STEADY_PWROK ;
        end

        `SM_CRITICAL_FAIL: begin
            if(pdn_watchdog_timeout)
                state_ns = `SM_DISABLE_PCIE_VP_VPU;
        end 

        `SM_DISABLE_PCIE_VP_VPU: begin
            if(pdn_watchdog_timeout)
                state_ns = `SM_DISABLE_DDR_VDDQ_VDDQCK_PLL;
        end 

        `SM_DISABLE_DDR_VDDQ_VDDQCK_PLL: begin
            if(pdn_watchdog_timeout)
                state_ns = `SM_DISABLE_P1V8_CPU_GPIO_VT_EFUSE;
        end 

        `SM_DISABLE_P1V8_CPU_GPIO_VT_EFUSE: begin
            if(pdn_watchdog_timeout)
                state_ns = `SM_DISABLE_P0V8_CPU_VDD_VCORE;
        end 

        `SM_DISABLE_P0V8_CPU_VDD_VCORE: begin
            if(pdn_watchdog_timeout)begin
                if(any_pwr_fault_det)
                    state_ns = `SM_DISABLE_P0V8_CPU_VDD_VCORE;
                else 
                    state_ns = `SM_RESET_STATE               ;   
            end
        end 

        default : state_ns = `SM_RESET_STATE               ;  
    endcase

end 


always @(*) begin
    // 默认值，防止锁存
    state_ns = state;

    case (state)
        SM_RESET_STATE: begin
            state_ns = SM_EN_P3V3_VCC;
        end

        SM_EN_P3V3_VCC: begin
            if(p3v3_vcc_critical_fail_en)                       
                state_ns = SM_CRITICAL_FAIL;
            else if(p3v3_vcc_state_trans_en)                          
                state_ns = SM_OFF_STANDBY  ;
        end

        SM_ENABLE_S5_DEVICES: begin
            if(pwron_critical_fail_en)                                
                state_ns = SM_CRITICAL_FAIL;
            else if(pwrup_state_trans_en)                             
                state_ns = SM_OFF_STANDBY  ;
        end

        SM_OFF_STANDBY: begin
            if(any_pwr_fault_det)                                     
                state_ns = SM_CRITICAL_FAIL;
            else if(s5dev_pwrdis_request)                             
                state_ns = SM_DISABLE_S5_DEVICES;
            else if(s5dev_pwren_request && s5_devices_on_wait_complete) 
                state_ns = SM_ENABLE_S5_DEVICES;
            else if(turn_system_on && 
                    dc_on_wait_complete &&
                    ((~pch_pwrbtn_n) | (~pch_pwrbtn_s) | (~Power_WAKE_R_N) | (~cpu_reboot))
                    )
                state_ns = SM_PS_ON;
        end

        SM_PS_ON: begin
            if(psu_critical_fail_en)                                  
                state_ns = SM_CRITICAL_FAIL;
            // else if(psu_watchdog_timeout && pgd_so_far) 
            else if(psu_state_trans_en)              
                state_ns = SM_EN_5V_STBY;
        end

        SM_EN_5V_STBY: begin
            if(pwron_critical_fail_en)                                
                state_ns = SM_CRITICAL_FAIL;
            else if(pwrup_state_trans_en)                             
                state_ns = SM_EN_TELEM;
        end

        SM_EN_TELEM: begin
            if(pwron_critical_fail_en)                                
                state_ns = SM_CRITICAL_FAIL;
            else if(pwrup_state_trans_en)                             
                state_ns = SM_EN_MAIN_EFUSE;
        end

        SM_EN_MAIN_EFUSE: begin
            if(efuse_critical_fail_en)                                
                state_ns = SM_CRITICAL_FAIL;
            // else if(efuse_watchdog_timeout && pgd_so_far) 
            else if(efuse_state_trans_en)            
                state_ns = SM_EN_5V;
        end

        SM_EN_5V: begin
            if(pwron_critical_fail_en)                                
                state_ns = SM_CRITICAL_FAIL;
            else if(pwrup_state_trans_en)                             
                state_ns = SM_EN_3V3;
        end

        SM_EN_3V3: begin
            if(pch_critical_fail_en)                                  
                state_ns = SM_CRITICAL_FAIL;
            else if(pch_state_trans_en)                               
                state_ns = SM_EN_P1V8;
        end

        SM_EN_P1V8: begin
            if(pchdsw_critical_fail_en)                               
                state_ns = SM_CRITICAL_FAIL;
            else if(pchdsw_state_trans_en)                            
                state_ns = SM_EN_P2V5_VPP;
        end

        SM_EN_P2V5_VPP: begin
            if(pchdsw_critical_fail_en)                               
                state_ns = SM_CRITICAL_FAIL;
            else if (pchdsw_state_trans_en)                            
                state_ns = SM_EN_VP;
        end

        SM_EN_VP: begin
            if(pchdsw_critical_fail_en)                               
                state_ns = SM_CRITICAL_FAIL;
            else if(pchdsw_state_trans_en)                            
                state_ns = SM_EN_P0V8;
        end

        SM_EN_P0V8: begin
            if(pchdsw_critical_fail_en)                               
                state_ns = SM_CRITICAL_FAIL;
            else if(pchdsw_state_trans_en)                            
                state_ns = SM_EN_VDD;
        end

        SM_EN_VDD: begin
            if(pchdsw_critical_fail_en)                               
                state_ns = SM_CRITICAL_FAIL;
            else if(pchdsw_state_trans_en)                            
                state_ns = PEX_RESET;
        end

        PEX_RESET: begin
            if(pchdsw_critical_fail_en)                               
                state_ns = SM_CRITICAL_FAIL;
            else if(pchdsw_state_trans_en)                            
                state_ns = SM_CPU_RESET;
        end

        SM_CPU_RESET: begin
            if(pchdsw_critical_fail_en)                               
                state_ns = SM_CRITICAL_FAIL;
            else if(pchdsw_state_trans_en)                            
                state_ns = SM_WAIT_POWEROK;
        end

        SM_WAIT_POWEROK: begin
            if(wait_steady_pwrok_fail_en)                             
                state_ns = SM_CRITICAL_FAIL;
            // else if(pon_65ms_watchdog_timeout && pgd_so_far)    
            else if(wait_steady_pwrok_state_trans_en)      
                state_ns = SM_STEADY_PWROK;
        end

        // 正常上电维持状态
        SM_STEADY_PWROK: begin
            if(rt_critical_fail_store)                                
                state_ns = SM_CRITICAL_FAIL;
            else if(rt_normal_pwr_down)                               
                state_ns = SM_CRITICAL_FAIL;
            else if (~cpu_power_off)                                   
                state_ns = SM_CRITICAL_FAIL;
            else if (~pch_sys_reset_n)                                 
                state_ns = SM_CRITICAL_FAIL;
            else 
                state_ns = SM_STEADY_PWROK ;
        end

        SM_CRITICAL_FAIL: begin
            state_ns = SM_DISABLE_VDD;
        end

        // 下电状态跳转
        SM_DISABLE_VDD:         if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_P0V8;
        SM_DISABLE_P0V8:        if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_VP;
        SM_DISABLE_VP:          if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_P2V5_VPP;
        SM_DISABLE_P2V5_VPP:    if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_P1V8;
        SM_DISABLE_P1V8:        if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_3V3;
        SM_DISABLE_3V3:         if (disable_3v3_timeout )            state_ns = SM_DISABLE_5V;
        SM_DISABLE_5V:          if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_MAIN_EFUSE;
        SM_DISABLE_MAIN_EFUSE:  if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_TELEM;
        SM_DISABLE_TELEM:       if (pdn_watchdog_timeout)            state_ns = SM_DISABLE_PS_ON;


        SM_DISABLE_PS_ON: begin
            if (pdn_watchdog_timeout)
                state_ns = (any_pwr_fault_det) ? SM_DISABLE_S5_DEVICES : SM_OFF_STANDBY;
        end

        SM_DISABLE_S5_DEVICES: begin
            if (pdn_watchdog_timeout) begin
                if (any_pwr_fault_det)                                    
                    state_ns = SM_HALT_POWER_CYCLE;
                else                                                      
                    state_ns = SM_OFF_STANDBY;
            end
        end

        SM_HALT_POWER_CYCLE: begin
            if(ready_for_recov && !any_non_recov_fault && !lim_recov_retry_max) begin
                if((assert_power_button && (allow_recovery || ~any_lim_recov_fault)) ||
                   (assert_physical_button && !allow_recovery && any_lim_recov_fault))
                    state_ns = SM_AUX_FAIL_RECOVERY;
            end
        end

        SM_AUX_FAIL_RECOVERY: begin
            state_ns = SM_EN_P3V3_VCC;
        end

        default: state_ns = SM_RESET_STATE;
    endcase
end

// FSM 3
wire                                          assert_button_clr                 ; // 清除按钮信号

wire                                          stby_failure_detected_clr         ; // 清除待机故障检测信号
wire                                          stby_failure_detected_set         ; // 置位待机故障检测信号

wire                                          po_failure_detected_clr           ; // 清除上电故障检测信号
wire                                          po_failure_detected_set           ; // 置位上电故障检测信号

wire                                          rt_failure_detected_clr           ; // 清除运行时故障检测信号
wire                                          rt_failure_detected_set           ; // 置位运行时故障检测信号

// begin：有限恢复重试逻辑
wire                                          ready_for_recov_clr               ; // 故障最大恢复辅助信号 (清除故障恢复信号) 
wire                                          ready_for_recov_set               ; // 故障最大恢复辅助信号 (置位故障恢复信号) 
wire                                          lim_recov_retry_clr               ; // 清除"有限恢复重试计数信号"标志
wire                                          lim_recov_retry_incr              ; // 递增"有限恢复重试计数信号"标志 
reg                                           ready_for_recov                   ; // 准备好进行故障恢复的标志
wire                                          lim_recov_retry_max               ; // 达到最大有限恢复重试次数标志
reg   [LIM_RECOV_RETRY_NBITS-1:0]             lim_recov_retry_count             ; // 有限恢复重试计数器
// end：  有限恢复重试逻辑

wire                                          off_state                         ; // 系统处于"下电状态"的标志
wire                                          fault_clear_ns                    ; // 系统处于"清除故障状态"的标志

wire                                          POWER_DOWN_FLAG_clr               ; // 清除POWER_DOWN_FLAG标志
wire                                          pch_thermtrip_FLAG_SET            ; // 置位pch_thermtrip_FLAG标志
wire                                          CPU_OFF_FLAG_SET                  ; // 置位CPU_OFF_FLAG标志
wire                                          REBOOT_FLAG_SET                   ; // 置位REBOOT_FLAG标志

// 按钮按下清除（在待机或进入故障时清除）
assign assert_button_clr         = ((state == SM_OFF_STANDBY) && turn_system_on && dc_on_wait_complete && ((~pch_pwrbtn_n) | (~pch_pwrbtn_s) | (~Power_WAKE_R_N) | (~cpu_reboot)))
                                   || (state == SM_CRITICAL_FAIL);

// --------------------------------------------------------------------------------------------------------------
// begin： 待机故障
// --------------------------------------------------------------------------------------------------------------
// 待机故障清除
assign stby_failure_detected_clr = (state == SM_RESET_STATE) || (state == SM_AUX_FAIL_RECOVERY);

// 待机故障置位
assign stby_failure_detected_set = (state == SM_OFF_STANDBY) && any_pwr_fault_det;

// 待机故障检测寄存器
always @(posedge clk or posedge reset) begin
  if (reset)
    stby_failure_detected <= 1'b0;
  else if (t1us && stby_failure_detected_clr)
    stby_failure_detected <= 1'b0;
  else if (t1us && stby_failure_detected_set)
    stby_failure_detected <= 1'b1;
end
// --------------------------------------------------------------------------------------------------------------
// end： 待机故障
// --------------------------------------------------------------------------------------------------------------


// --------------------------------------------------------------------------------------------------------------
// begin： 上电故障
// --------------------------------------------------------------------------------------------------------------
// 上电故障清除
assign po_failure_detected_clr   = (state == SM_RESET_STATE) || (state == SM_AUX_FAIL_RECOVERY);

// 上电故障置位
assign po_failure_detected_set   = ((state == SM_EN_P3V3_VCC)       && p3v3_vcc_critical_fail_en      ) ||
                                   ((state == SM_ENABLE_S5_DEVICES) && pwron_critical_fail_en         ) ||
                                   ((state == SM_PS_ON)             && psu_critical_fail_en           ) ||
                                   ((state == SM_EN_5V_STBY)        && pwron_critical_fail_en         ) ||
                                   ((state == SM_EN_TELEM)          && pwron_critical_fail_en         ) ||
                                   ((state == SM_EN_MAIN_EFUSE)     && efuse_critical_fail_en         ) ||
                                   ((state == SM_EN_5V)             && pwron_critical_fail_en         ) ||
                                   ((state == SM_EN_3V3)            && pch_critical_fail_en           ) ||
                                   (((state == SM_EN_P1V8) || (state == SM_EN_P2V5_VPP) || 
                                     (state == SM_EN_VP)   || (state == SM_EN_P0V8)     || 
                                     (state == SM_EN_VDD)  || (state == PEX_RESET)      ||
                                     (state == SM_CPU_RESET)) 
                                     && pchdsw_critical_fail_en) ||
                                   ((state == SM_WAIT_POWEROK)      && wait_steady_pwrok_fail_en      );

// 上电故障检测寄存器
always @(posedge clk or posedge reset) begin
  if (reset)
    po_failure_detected <= 1'b0;
  else if (t1us && po_failure_detected_clr)
    po_failure_detected <= 1'b0;
  else if (t1us && po_failure_detected_set)
    po_failure_detected <= 1'b1;
end
// --------------------------------------------------------------------------------------------------------------
// begin： 上电故障
// --------------------------------------------------------------------------------------------------------------


// --------------------------------------------------------------------------------------------------------------
// begin： 运行故障
// --------------------------------------------------------------------------------------------------------------
// 运行故障清除
assign rt_failure_detected_clr    = (state == SM_RESET_STATE) || (state == SM_AUX_FAIL_RECOVERY);

// 运行故障置位
assign rt_failure_detected_set    = (state == SM_STEADY_PWROK) && rt_critical_fail_store;

// 运行故障检测寄存器
always @(posedge clk or posedge reset) begin
  if (reset)
    rt_failure_detected <= 1'b0;
  else if (t1us && rt_failure_detected_clr)
    rt_failure_detected <= 1'b0;
  else if (t1us && rt_failure_detected_set)
    rt_failure_detected <= 1'b1;
end

// 运行故障总标志寄存器
always @(posedge clk or posedge reset) begin
  if (reset)
    power_fault <= 1'b0;
  else if (t1us)
    power_fault <= stby_failure_detected | po_failure_detected | rt_failure_detected;
end
// --------------------------------------------------------------------------------------------------------------
// end： 运行故障
// --------------------------------------------------------------------------------------------------------------

// 故障恢复窗口控制
assign ready_for_recov_clr        = (state == SM_AUX_FAIL_RECOVERY);
assign ready_for_recov_set        = (state == SM_HALT_POWER_CYCLE) && pf_on_wait_complete;

// --------------------------------------------------------------------------------------------------------------
// begin： 有限恢复重试计数控制
// --------------------------------------------------------------------------------------------------------------
// 清空重试计数：进入稳定上电状态
assign lim_recov_retry_clr        = (state == SM_STEADY_PWROK);

// 有限故障恢复准备标志
always @(posedge clk or posedge reset)begin
    if (reset)
        ready_for_recov <= 1'b0;
    else if(t1us && ready_for_recov_clr)
        ready_for_recov <= 1'b0;
    else if (t1us && ready_for_recov_set)
        ready_for_recov <= 1'b1;
end

// 有限恢复重试计数到达最大值标志
assign lim_recov_retry_max = (lim_recov_retry_count == LIM_RECOV_MAX_RETRY_ATTEMPT);

// 有限恢复重试计数递增
assign lim_recov_retry_incr       = (state == SM_HALT_POWER_CYCLE) && ready_for_recov && !any_non_recov_fault && !lim_recov_retry_max &&
                                    ((assert_power_button && (allow_recovery || ~any_lim_recov_fault)) || (assert_physical_button && !allow_recovery && any_lim_recov_fault));

// 有限恢复重试计数器
always @(posedge clk or posedge reset)begin
    if (reset)
        lim_recov_retry_count <= {LIM_RECOV_RETRY_NBITS{1'b0}};
    else if(t1us && lim_recov_retry_clr)
        lim_recov_retry_count <= {LIM_RECOV_RETRY_NBITS{1'b0}};
    else if (t1us && lim_recov_retry_incr)
        lim_recov_retry_count <= lim_recov_retry_count + 1'b1;
end
// --------------------------------------------------------------------------------------------------------------
// end： 有限恢复重试计数控制
// --------------------------------------------------------------------------------------------------------------

// 待机与故障恢复等待阶段置位
assign off_state                  =  (state == SM_OFF_STANDBY) || (state == SM_HALT_POWER_CYCLE) || (state == SM_AUX_FAIL_RECOVERY);

// 清除故障锁存：开始上电或AUX恢复
assign fault_clear_ns             = (
                                      ((state == SM_OFF_STANDBY) && turn_system_on && dc_on_wait_complete && ((~pch_pwrbtn_n) | (~pch_pwrbtn_s) | (~Power_WAKE_R_N) | (~cpu_reboot))) ||
                                      (state == SM_AUX_FAIL_RECOVERY)
                                    );

always @(posedge clk or posedge reset)begin
    if (reset)
        fault_clear <= 1'b0;
    else
        fault_clear <= fault_clear_ns;
end

// --------------------------------------------------------------------------------------------------------------
// begin： 下电关机标志清除/置位
// --------------------------------------------------------------------------------------------------------------
assign POWER_DOWN_FLAG_clr    = (state == SM_RESET_STATE) || ((state == SM_WAIT_POWEROK) && pon_65ms_watchdog_timeout && pgd_so_far);

assign pch_thermtrip_FLAG_SET = (state == SM_STEADY_PWROK) && rt_normal_pwr_down;

assign CPU_OFF_FLAG_SET       = (state == SM_STEADY_PWROK) && (~cpu_power_off);

assign REBOOT_FLAG_SET        = (state == SM_STEADY_PWROK) && (~pch_sys_reset_n);

always @(posedge clk or posedge reset)begin
    if(reset)begin
        pch_thermtrip_FLAG <= 1'b0;
        CPU_OFF_FLAG       <= 1'b0;
        REBOOT_FLAG        <= 1'b0;
    end 
    else if(t1us && POWER_DOWN_FLAG_clr)begin 
        pch_thermtrip_FLAG <= 1'b0;
        CPU_OFF_FLAG       <= 1'b0;
        REBOOT_FLAG        <= 1'b0;
    end

    else if (t1us && pch_thermtrip_FLAG_SET)
        pch_thermtrip_FLAG <= 1'b1;
    else if (t1us && CPU_OFF_FLAG_SET)
        CPU_OFF_FLAG       <= 1'b1;
    else if (t1us && REBOOT_FLAG_SET)
        REBOOT_FLAG        <= 1'b1;
end
// --------------------------------------------------------------------------------------------------------------
// end： 下电关机标志清除/置位
// --------------------------------------------------------------------------------------------------------------



wire rt_critical_fail_check;
assign rt_critical_fail_check = any_pwr_fault_det ;

always @(posedge clk or posedge reset) begin
    if (reset)
        rt_critical_fail_store <= 1'b0;
    else
        rt_critical_fail_store <= ( st_steady_pwrok  & rt_critical_fail_check) |
                                  (~st_critical_fail & rt_critical_fail_store);
end

always @(posedge clk or posedge reset) begin
    if (reset)
        pgd_raw <= 1'b0;
    else if (t1us)
        pgd_raw <= pgd_so_far & st_steady_pwrok & ~rt_critical_fail_check;
    else
        pgd_raw <= pgd_so_far & pgd_raw & ~rt_critical_fail_check;
end
                
//------------------------------------------------------------------------------
// 锁存“系统关闭”状态，避免故障恢复时误上电
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
    if (reset)
        cpld_latch_sys_off <= 1'b0;
    else
        cpld_latch_sys_off <= st_halt_power_cycle & lim_recov_retry_max;
end

endmodule


/*
always @(*) begin
    // 默认值，防止锁存
    assert_button_clr           = 1'b0;

    stby_failure_detected_clr   = 1'b0;
    stby_failure_detected_set   = 1'b0;

    po_failure_detected_clr     = 1'b0;
    po_failure_detected_set     = 1'b0;

    rt_failure_detected_clr     = 1'b0;
    rt_failure_detected_set     = 1'b0;

    ready_for_recov_clr         = 1'b0;
    ready_for_recov_set         = 1'b0;
    lim_recov_retry_clr         = 1'b0;
    lim_recov_retry_incr        = 1'b0;

    off_state                   = 1'b0;
    fault_clear_ns              = 1'b0;

    POWER_DOWN_FLAG_clr         = 1'b0;
    pch_thermtrip_FLAG_SET      = 1'b0;
    CPU_OFF_FLAG_SET            = 1'b0;
    REBOOT_FLAG_SET             = 1'b0;

    case (state)
        // Reset 状态
        SM_RESET_STATE: begin
            stby_failure_detected_clr = 1'b1; // 上电fail相关的clr置位, 待机故障
            po_failure_detected_clr   = 1'b1; // 上电fail相关的clr置位, 上电故障
            rt_failure_detected_clr   = 1'b1; // 上电fail相关的clr置位, 运行故障
            POWER_DOWN_FLAG_clr       = 1'b1; // 上电fail相关的clr置位, 下电flag
        end

        // SM_EN_P3V3_VCC 状态
        SM_EN_P3V3_VCC: begin
            if(critical_fail_en_sm_en_p3v3_vcc)  
                po_failure_detected_set = 1'b1;
        end

        SM_ENABLE_S5_DEVICES: begin
            if(pwron_critical_fail_en)           
                po_failure_detected_set = 1'b1;
        end

        SM_OFF_STANDBY: begin
            if(any_pwr_fault_det)                
                stby_failure_detected_set = 1'b1;
            else if(turn_system_on && 
                    dc_on_wait_complete &&
                    ((~pch_pwrbtn_n) | (~pch_pwrbtn_s) | (~Power_WAKE_R_N) | (~cpu_reboot))
                  ) begin
                assert_button_clr = 1'b1;
                fault_clear_ns    = 1'b1;
            end
            off_state = 1'b1;
        end

        SM_PS_ON: begin
            if(psu_critical_fail_en)             
                po_failure_detected_set = 1'b1;
        end

        SM_EN_5V_STBY: begin
            if(pwron_critical_fail_en)           
                po_failure_detected_set = 1'b1;
        end

        SM_EN_TELEM: begin
            if(pwron_critical_fail_en)           
                po_failure_detected_set = 1'b1;
        end

        SM_EN_MAIN_EFUSE: begin
            if(efuse_critical_fail_en)           
                po_failure_detected_set = 1'b1;
        end

        SM_EN_5V: begin
            if(pwron_critical_fail_en)           
                po_failure_detected_set = 1'b1;
        end

        SM_EN_3V3: begin
            if(pch_critical_fail_en)             
                po_failure_detected_set = 1'b1;
        end

        SM_EN_P1V8    ,
        SM_EN_P2V5_VPP,
        SM_EN_VP      ,
        SM_EN_P0V8    ,
        SM_EN_VDD     ,
        PEX_RESET     ,
        SM_CPU_RESET: begin
            if (pchdsw_critical_fail_en)          
                po_failure_detected_set = 1'b1;
        end

        SM_WAIT_POWEROK: begin
            if (wait_steady_pwrok_fail_en)        
                po_failure_detected_set = 1'b1;
            else if (pon_65ms_watchdog_timeout && pgd_so_far)
                POWER_DOWN_FLAG_clr = 1'b1;
        end

        SM_STEADY_PWROK: begin
            if (rt_critical_fail_store)           
                rt_failure_detected_set = 1'b1;
            else if (rt_normal_pwr_down)          
                pch_thermtrip_FLAG_SET  = 1'b1;
            else if (~cpu_power_off)              
                CPU_OFF_FLAG_SET        = 1'b1;
            else if (~pch_sys_reset_n)            
                REBOOT_FLAG_SET         = 1'b1;

            // 正常稳态期间清空“限定恢复”重试计数
            lim_recov_retry_clr = 1'b1;
        end

        SM_CRITICAL_FAIL: begin
            assert_button_clr = 1'b1;
        end

        SM_DISABLE_MAIN_EFUSE: begin
            off_state = 1'b0; // 与原逻辑保持一致
        end

        SM_HALT_POWER_CYCLE: begin
            // 等待窗口完成后允许恢复
            ready_for_recov_set = pf_on_wait_complete ;
            off_state           = 1'b1                ;

            if(ready_for_recov && !any_non_recov_fault && !lim_recov_retry_max) begin
                if((assert_power_button && (allow_recovery || ~any_lim_recov_fault)) ||
                  (assert_physical_button && !allow_recovery && any_lim_recov_fault))
                  lim_recov_retry_incr = 1'b1;
            end
        end

        SM_AUX_FAIL_RECOVERY: begin
            stby_failure_detected_clr = 1'b1;
            po_failure_detected_clr   = 1'b1;
            rt_failure_detected_clr   = 1'b1;
            ready_for_recov_clr       = 1'b1;
            fault_clear_ns            = 1'b1;
            off_state                 = 1'b1;
        end

        default: ;
    endcase
end
*/


