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

module pwrseq_master #(
    parameter LIM_RECOV_MAX_RETRY_ATTEMPT           = 2                         ,
    parameter WDT_NBITS                             = 10                        ,
    parameter DSW_PWROK_TIMEOUT_VAL                 = 10                        ,
    parameter PCH_WATCHDOG_TIMEOUT_VAL              = 1000                      ,
    parameter PON_WATCHDOG_TIMEOUT_VAL              = 112                       ,
    parameter PSU_WATCHDOG_TIMEOUT_VAL              = 10                        ,
    parameter EFUSE_WATCHDOG_TIMEOUT_VAL            = 137                       ,
    parameter VCORE_WATCHDOG_TIMEOUT_VAL            = PON_WATCHDOG_TIMEOUT_VAL  ,
    parameter PDN_WATCHDOG_TIMEOUT_VAL              = 2                         ,
    parameter PDN_WATCHDOG_TIMEOUT_FAULT_VAL        = PDN_WATCHDOG_TIMEOUT_VAL  ,
    parameter DISABLE_INTEL_VCCIN_TIMEOUT_VAL       = PDN_WATCHDOG_TIMEOUT_VAL  ,
    parameter DISABLE_INTEL_VCCIN_TIMEOUT_FAULT_VAL = PDN_WATCHDOG_TIMEOUT_VAL  ,
    parameter DISABLE_3V3_TIMEOUT_VAL               = PDN_WATCHDOG_TIMEOUT_VAL  ,
    parameter DISABLE_3V3_TIMEOUT_FAULT_VAL         = PDN_WATCHDOG_TIMEOUT_VAL  ,
    parameter PON_65MS_WATCHDOG_TIMEOUT_VAL         = 34                        ,
    parameter DC_ON_WAIT_COMPLETE_NOFLT_VAL         = 17                        ,
    parameter DC_ON_WAIT_COMPLETE_FAULT_VAL         = 2                         ,
    parameter PF_ON_WAIT_COMPLETE_VAL               = 33                        ,
    parameter PO_ON_WAIT_COMPLETE_VAL               = 1                         ,
    parameter S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL = 0                         ,
    parameter S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL = 0) (

    // 时钟; 上电/下电时序控制使用
    input            clk,                     // clock
    input            reset,                   // reset
    input            t1us,                    // 10ns pulse every 1us
    input            t512us,                  // 10ns pulse every 512us
    input            t256ms,                  // 10ns pulse every 256ms
    input            t512ms,                  // 10ns pulse every 500ms
    input            sequence_tick,           // tick used for wdt timeout during power-up/down states
    input            psu_on_tick,             // tick used for wdt timeout during PS on state

    // 物理电源按钮及南桥状态/控制信号
    input            sys_sw_in_n,             // system's power button switch
    input            pch_pwrbtn_n,            // SB power button input (same signal driven to SB PWRBTN)
    input            pch_pwrbtn_s,            // SB power button input (same signal driven to SB PWRBTN) delay 1s
    input            pch_thermtrip_n,         // SB bound thermtrip signal (same signal driven to SB THERMTRIP)
    input            xr_ps_en,                // system allowed to power on (Xreg's ps_enable)
    output reg       force_pwrbtn_n,          // forces SB to switch to S5 after power shutdown due to fault

    // CPU 重启和关机信号（实际未使用）
    input            cpu_reboot,               
    input            cpu_reboot_x,             
    input            cpu_power_off,     

    // 故障状态输出的flag信号（实际未使用）
    output reg       pch_thermtrip_FLAG, 
    output reg       CPU_OFF_FLAG,
    output reg       REBOOT_FLAG,        

    // 允许恢复和保持存活控制信号（实际未使用）
    input            allow_recovery,         

    // 保持存活控制信号
    input            keep_alive_on_fault,   

    // 点灯观察使用
    output           pgd_raw,  

    // S5 上电设备控制信号（不使用）
    input            s5dev_pwren_request,     // S5 powered device enable request
    input            s5dev_pwrdis_request,    // S5 powered device disable request

    // 上电slave接口
    input            pgd_so_far,              // current overall power status
    input            any_pwr_fault_det,       // any type of power fault
    input            any_lim_recov_fault,     // any limited recovery fault
    input            any_non_recov_fault,     // any non-recoverable fault
    output reg       dc_on_wait_complete,     // 4s flag - used by slave for stuck on check
    output reg       rt_critical_fail_store,  // asserts when during runtime when critical failure detected
    output reg       fault_clear,             // clear fault flags
    output     [5:0] power_seq_sm,            // copy of the state variable
    input            Power_WAKE_R_N,
    output  reg      turn_system_on,

    // Status
    output reg       power_fault,             // power fault is active
    output reg       stby_failure_detected,   // standby failure detected (goes to Xreg byte07[4]
    output reg       po_failure_detected,     // poweron failure detected (goes to Xreg byte07[2])
    output reg       rt_failure_detected,     // runtime failure detected (goes to Xreg byte07[5])
    output reg       cpld_latch_sys_off,      // system in non-recovery state (goes to Xreg byte08[6])
    output reg       turn_on_wait             // system waiting to turn on
);

// 恢复计数器位宽计算
function integer clogb2 (input [31:0] value);
    reg [31:0] tmp;
    begin
        tmp = (value <= 2) ? 2 : (value - 1);
        for (clogb2 = 0; tmp > 0; clogb2 = clogb2 + 1)
            tmp = tmp >> 1;
    end
endfunction

localparam LIM_RECOV_RETRY_NBITS = clogb2(LIM_RECOV_MAX_RETRY_ATTEMPT);


// FSM
reg  [5:0]                              state                       ;
reg  [5:0]                              state_ns                    ;

wire                                    st_off_standby              ;
wire                                    st_ps_on                    ;
wire                                    st_steady_pwrok             ;
wire                                    st_critical_fail            ;
wire                                    st_halt_power_cycle         ;
wire                                    st_disable_main_efuse       ;

// Watchdog logic
reg  [WDT_NBITS-1:0]                    wdt_counter                 ;
wire                                    wdt_tick                    ;
reg  [5:0]                              power_seq_sm_last           ;
wire                                    wdt_counter_clr             ;
reg                                     dsw_pwrok_timeout           ;
reg                                     pch_watchdog_timeout        ;
reg                                     pon_watchdog_timeout        ;
reg                                     psu_watchdog_timeout        ;
reg                                     efuse_watchdog_timeout      ;
reg                                     vcore_watchdog_timeout      ;
reg                                     pdn_watchdog_timeout        ;
reg                                     disable_intel_vccin_timeout ;
reg                                     disable_3v3_timeout         ;
reg                                     pon_65ms_watchdog_timeout   ;
reg                                     pf_on_wait_complete         ;
reg                                     po_on_wait_complete         ;
reg                                     s5_devices_on_wait_complete ;

// Button logic; 下降沿检测后使用
wire                                    Power_WAKE_R_N_ne           ;
wire                                    cpu_reboot_ne               ;
wire                                    pch_pwrbtn_n_ne             ; 
wire                                    sys_sw_in_n_ne              ;
reg                                     assert_power_button         ;
reg                                     assert_physical_button      ;
reg                                     assert_button_clr           ;

// Fault flags
// 故障标志位, stby+po+rt 三种故障分别独立记录
reg                                     stby_failure_detected_clr   ;
reg                                     stby_failure_detected_set   ;
reg                                     po_failure_detected_clr     ;
reg                                     po_failure_detected_set     ;
reg                                     rt_failure_detected_clr     ;
reg                                     rt_failure_detected_set     ;

// Limited recovery logic
// 有限恢复相关逻辑
reg                                     ready_for_recov             ;
reg                                     ready_for_recov_clr         ;
reg                                     ready_for_recov_set         ;
reg  [LIM_RECOV_RETRY_NBITS-1:0]        lim_recov_retry_count       ;
reg                                     lim_recov_retry_incr        ;
reg                                     lim_recov_retry_clr         ;
wire                                    lim_recov_retry_max         ;

// Misc
reg                                     off_state                   ;
wire                                    pch_thermtrip_n_delay       ;
reg                                     fault_clear_ns              ;

// State transition
// 各状态跳转使能信号
reg                                     pchdsw_state_trans_en       ;
reg                                     pchdsw_critical_fail_en     ;
reg                                     pch_state_trans_en          ;
reg                                     pch_critical_fail_en        ;
reg                                     pwrup_state_trans_en        ;
reg                                     pwron_critical_fail_en      ;
reg                                     psu_critical_fail_en        ;
reg                                     efuse_critical_fail_en      ;
reg                                     wait_steady_pwrok_fail_en   ;

wire                                    rt_critical_fail_check      ;
wire                                    rt_normal_pwr_down          ;

// SM states
assign st_off_standby        = (power_seq_sm == SM_OFF_STANDBY)         ; // S5待机状态
assign st_ps_on              = (power_seq_sm == SM_PS_ON)               ; // PSU上电状态
assign st_steady_pwrok       = (power_seq_sm == SM_STEADY_PWROK)        ; // 稳定PWROK状态
assign st_critical_fail      = (power_seq_sm == SM_CRITICAL_FAIL)       ; // 严重故障处理状态
assign st_halt_power_cycle   = (power_seq_sm == SM_HALT_POWER_CYCLE)    ; // 停止电源循环状态
assign st_disable_main_efuse = (power_seq_sm == SM_DISABLE_MAIN_EFUSE)  ; // 禁用主E-fuse状态


//------------------------------------------------------------------------------
// Watchdog logic
// 生成看门狗计时器时钟脉冲
//------------------------------------------------------------------------------
assign wdt_tick = (off_state) ? t256ms       : // S5 待机使用 256ms 计时
                  (st_ps_on)  ? psu_on_tick  : // PSU 上电使用 32ms 上电计时
                                sequence_tick; // 其余状态使用 2ms 计时

// Clear counter - generates a 1us pulse on entry to new state
always @(posedge clk or posedge reset) begin
    if (reset)
        power_seq_sm_last <= `SM_RESET_STATE;
    else if (t1us)
        power_seq_sm_last <= power_seq_sm;
end

assign wdt_counter_clr = (power_seq_sm_last != power_seq_sm);

// Counter
always @(posedge clk or posedge reset) begin
    if (reset)
        wdt_counter <= {WDT_NBITS{1'b0}};
    else if (wdt_counter_clr)
        wdt_counter <= {WDT_NBITS{1'b0}};
    else if (wdt_tick)
        wdt_counter <= wdt_counter + 1'b1;
end

// Timeout flags
// - Used for waiting on power-up/down sequence states
always @(posedge clk or posedge reset) begin
    if (reset) begin
        dsw_pwrok_timeout           <= 1'b0;
        pch_watchdog_timeout        <= 1'b0;
        pon_watchdog_timeout        <= 1'b0;
        psu_watchdog_timeout        <= 1'b0;
        efuse_watchdog_timeout      <= 1'b0;
        vcore_watchdog_timeout      <= 1'b0;
        pon_65ms_watchdog_timeout   <= 1'b0;
        pdn_watchdog_timeout        <= 1'b0;
        disable_intel_vccin_timeout <= 1'b0;
        disable_3v3_timeout         <= 1'b0;
    end
    else if (wdt_counter_clr) begin
        dsw_pwrok_timeout           <= 1'b0;
        pch_watchdog_timeout        <= 1'b0;
        pon_watchdog_timeout        <= 1'b0;
        psu_watchdog_timeout        <= 1'b0;
        efuse_watchdog_timeout      <= 1'b0;
        vcore_watchdog_timeout      <= 1'b0;
        pon_65ms_watchdog_timeout   <= 1'b0;
        pdn_watchdog_timeout        <= 1'b0;
        disable_intel_vccin_timeout <= 1'b0;
        disable_3v3_timeout         <= 1'b0;
    end
    else if (wdt_tick) begin
        if (wdt_counter == DSW_PWROK_TIMEOUT_VAL)                                        
          dsw_pwrok_timeout <= 1'b1;                                                           

        if (wdt_counter == PCH_WATCHDOG_TIMEOUT_VAL)                                         
         pch_watchdog_timeout <= 1'b1;                                                        

        if (wdt_counter == PON_WATCHDOG_TIMEOUT_VAL)                                      
          pon_watchdog_timeout <= 1'b1;                                                        

        if (wdt_counter == PSU_WATCHDOG_TIMEOUT_VAL)                                        
          psu_watchdog_timeout <= 1'b1;                                                        

        if (wdt_counter == EFUSE_WATCHDOG_TIMEOUT_VAL)                                      
          efuse_watchdog_timeout <= 1'b1;                                                      

        if (wdt_counter == VCORE_WATCHDOG_TIMEOUT_VAL)                                         
          vcore_watchdog_timeout <= 1'b1;                                                      

        if (wdt_counter == PON_65MS_WATCHDOG_TIMEOUT_VAL)                                      
          pon_65ms_watchdog_timeout <= 1'b1;                                                   

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
                                                                                         
// Complete flags                                                                         
// - Used for holding off actions form occurring until enough time has passed 
// 生成各等待完成标志            
always @(posedge clk or posedge reset) begin                                              
    if (reset) begin                                                                        
        dc_on_wait_complete         <= 1'b0;                                                  
        po_on_wait_complete         <= 1'b0;                                                  
        s5_devices_on_wait_complete <= 1'b0;
    end
    else if (t1us) begin
        if (!off_state) begin
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

// pf_on_wait_complete is separated from above since it needs to also assert
// during interlock_broken case.
// 生成 pf_on_wait_complete 标志
always @(posedge clk or posedge reset) begin
  if (reset)
    pf_on_wait_complete <= 1'b0;
  else if (t1us && !off_state)
    pf_on_wait_complete <= 1'b0;
  else if (t1us && (wdt_counter == PF_ON_WAIT_COMPLETE_VAL))
    pf_on_wait_complete <= 1'b1;
end


//------------------------------------------------------------------------------
// turn_system_on
// - Asserts when system is requested to turn on and have satisfied all
//   required conditions for turn on.
// 系统开机控制使能信号, 已经写死
//------------------------------------------------------------------------------
reg  [2:0]              r_pwrbtn_1s_cnt     ; // 计数到 4 秒 （0..4）
reg                     r_Pwrbtn_long       ; // 长按指示 按下 >=4s 时置1（保留直到被清除）
reg                     r_Pwrbtn_long_flag  ; // 指示长按大于4s后, 用该信号维持住SM_OFF_STANDBY状态

always @(posedge clk or posedge reset) begin
    if (reset)
        r_pwrbtn_1s_cnt <= 3'd0;
    else begin
        // 每512ms采样一次按键状态
        if(t512ms_tick) begin
            if ((~pch_pwrbtn_n) && st_steady_pwrok) begin
                // 按下且处于运行稳定态，计数递增直到 4
                if (r_pwrbtn_1s_cnt < 3'd7)
                    r_pwrbtn_1s_cnt <= r_pwrbtn_1s_cnt + 3'd1;
                else
                    r_pwrbtn_1s_cnt <= r_pwrbtn_1s_cnt;
            end
            else begin
                r_pwrbtn_1s_cnt <= 3'd0;
            end
        end
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) 
        r_Pwrbtn_long   <= 1'b0;
    else if(t512ms_tick && (~pch_pwrbtn_n) && st_steady_pwrok && (r_pwrbtn_1s_cnt == 3'd7))
        // 每512ms采样一次按键状态
        r_Pwrbtn_long <= 1'b1;
    else if(assert_button_clr)
        // 允许外部清除在任意时钟周期生效     
        r_Pwrbtn_long <= 1'b0;
end

always @(posedge clk or posedge reset) begin
    r_Pwrbtn_long_flag <= ~pch_pwrbtn_n & r_Pwrbtn_long;
end 

always @(posedge clk or posedge reset) begin
    if (reset)
        turn_system_on <= 1'b0;
    else if (t1us)                         
        turn_system_on <= (xr_ps_en  | turn_system_on)  ;                                         
end

//------------------------------------------------------------------------------
// assert_power_button, phys_power_button
// - Asserts when power button is pressed while in 'off' states unless the
//   assertion is due to force_pwrbtn_n. Mask out in this case. We don't want
//   that asserted due to pwrseq forcing power button assertion.
// - Remains asserted until we hit SM_CRITICAL_FAIL or the start of power-on.
// - phys_power_button only asserts on sys_sw_in_n assertion alone.
//------------------------------------------------------------------------------
edge_detect #(.SIGCNT(2), .DEF_INIT(2'b11)) edge_detect_button_ne_inst (
    .reset       (reset),
    .clk         (clk),
    .tick        (1'b1),
    .signal_in   ({pch_pwrbtn_n,    sys_sw_in_n}),
    .detect_pe   (),
    .detect_ne   ({pch_pwrbtn_n_ne, sys_sw_in_n_ne}),
    .detect_any  ()
);

edge_detect #(.SIGCNT(2), .DEF_INIT(2'b11)) edge_detect_ne_inst (
    .reset       (reset),
    .clk         (clk),
    .tick        (1'b1),
    .signal_in   ({  Power_WAKE_R_N,  cpu_reboot_x}),
    .detect_pe   (),
    .detect_ne   ({  Power_WAKE_R_N_ne,  cpu_reboot_ne  }),
    .detect_any  ()
);

// 开机按钮按下检测及保持
always @(posedge clk or posedge reset) begin
    if (reset)
        assert_power_button <= 1'b0;
    else if (assert_button_clr || ~force_pwrbtn_n)    
        assert_power_button <= 1'b0;
    else if ((pch_pwrbtn_n_ne  | Power_WAKE_R_N_ne |  cpu_reboot_ne) && off_state)
        assert_power_button <= 1'b1;
end

// halt_power_cycle 状态下物理按键保持
always @(posedge clk or posedge reset) begin
  if (reset)
    assert_physical_button <= 1'b0;
  else if (assert_button_clr)
    assert_physical_button <= 1'b0;
  else if ((sys_sw_in_n_ne  |  Power_WAKE_R_N_ne |  cpu_reboot_ne ) && st_halt_power_cycle)
    assert_physical_button <= 1'b1;
end


//------------------------------------------------------------------------------
// force_pwrbtn_n
// - Asserts low when power sequencer needs to toggle SB power button input.
// - Note the differet behavior between BL and non-BL platform
// 强制关机信号, 实际未使用
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
    if (reset)
        force_pwrbtn_n <= 1'b1;
    else if (t1us) begin
        force_pwrbtn_n <=
         ~((st_halt_power_cycle & power_fault & ~pf_on_wait_complete) | // 非BL平台, 故障且等待完成前强制关机
           (st_off_standby      & power_fault & (po_on_wait_complete) &  assert_power_button) // BL平台, 故障且等待完成后按键强制关机
        );                                                                                            
    end
end


//------------------------------------------------------------------------------
// turn_on_wait
// - Asserts when system has been triggered to turn on and keep asserted until
//   SM_STEADY_PWROK or SM_CRITICAL_FAIL is reached.
// SM_STEADY_PWROK 或 SM_CRITICAL_FAIL 状态到达前保持开机等待状态
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    turn_on_wait <= 1'b0;
  else if (t1us)    
    turn_on_wait <= (assert_power_button)             |                                        
                    (turn_on_wait & ~(st_steady_pwrok | st_critical_fail));                    
end


//------------------------------------------------------------------------------
// cpld_latch_sys_off
// - Asserts when in SM_HALT_POWER_CYCLE and we've reached the max number of
//   retry attempt. Aux power cycle is required.
//  限制恢复达到最大重试次数后, CPLD系统关闭保持信号
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    cpld_latch_sys_off <= 1'b0;
  else
    cpld_latch_sys_off <= st_halt_power_cycle & lim_recov_retry_max;
end


//------------------------------------------------------------------------------
// stby, poweron and runtime fault flags
// stby, po, rt 三种故障标志位
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
    if (reset)
        stby_failure_detected <= 1'b0;
    else if (t1us && stby_failure_detected_clr)
        stby_failure_detected <= 1'b0;
    else if (t1us && stby_failure_detected_set)
        stby_failure_detected <= 1'b1;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        po_failure_detected <= 1'b0;
    else if (t1us && po_failure_detected_clr)
        po_failure_detected <= 1'b0;
    else if (t1us && po_failure_detected_set)
        po_failure_detected <= 1'b1;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        rt_failure_detected <= 1'b0;
    else if (t1us && rt_failure_detected_clr)
        rt_failure_detected <= 1'b0;
    else if (t1us && rt_failure_detected_set)
        rt_failure_detected <= 1'b1;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        power_fault <= 1'b0;
    else if (t1us)
        power_fault <= stby_failure_detected | po_failure_detected | rt_failure_detected;
end

//------------------------------------------------------------------------------
// CPU_OFF_FLAG, REBOOT_FLAG, pch_thermtrip_FLAG, 热跳变及重启关机标志位
//------------------------------------------------------------------------------
reg                                 pch_thermtrip_FLAG_SET      ;
reg                                 CPU_OFF_FLAG_SET            ;
reg                                 REBOOT_FLAG_SET             ;
reg                                 POWER_DOWN_FLAG_clr         ;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pch_thermtrip_FLAG <= 1'b0;
        CPU_OFF_FLAG       <= 1'b0;
        REBOOT_FLAG        <= 1'b0;
    end 
    else if (t1us && POWER_DOWN_FLAG_clr)begin 
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

//------------------------------------------------------------------------------
// Limited-recovery logic
// 有限恢复相关逻辑
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
    if (reset)
        ready_for_recov <= 1'b0;
    else if (t1us && ready_for_recov_clr)
        ready_for_recov <= 1'b0;
    else if (t1us && ready_for_recov_set)
        ready_for_recov <= 1'b1;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        lim_recov_retry_count <= {LIM_RECOV_RETRY_NBITS{1'b0}};
    else if (t1us && lim_recov_retry_clr)
        lim_recov_retry_count <= {LIM_RECOV_RETRY_NBITS{1'b0}};
    else if (t1us && lim_recov_retry_incr)
        lim_recov_retry_count <= lim_recov_retry_count + 1'b1;
end

assign lim_recov_retry_max = (lim_recov_retry_count == LIM_RECOV_MAX_RETRY_ATTEMPT);


//------------------------------------------------------------------------------
// Generate a 1ms delayed version of pch_thermtrip_n when in SM_STEADY_PWROK.
// This is used to trigger a power-down.
// pch热跳变信号延时1ms后使用
//------------------------------------------------------------------------------
edge_delay #(
    .CNTR_NBITS    (2)
) sb_thermtrip_delay_inst (
    .clk           (clk),
    .reset         (reset),
    .cnt_size      (2'b10),
    .cnt_step      (t512us),
    .signal_in     (~pch_thermtrip_n & st_steady_pwrok),
    .delay_output  (pch_thermtrip_n_delay)
);

//------------------------------------------------------------------------------
// fault_clear
// - Clears any outstanding faults on AUX_FAIL_RECOVERY state or during the
//   start of power on sequence.
// - Registered fault_clear to ease out timing since that drives all fault_detectB
//   instances in this module. The extra clock is here is acceptable since SM
//   changes state only every 1us.
// fault_clear 信号生成
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    fault_clear <= 1'b0;
  else
    fault_clear <= fault_clear_ns;
end


//------------------------------------------------------------------------------
// state transition logic
// - These signals are used by SM to steer state transition. The logic are
//   too big to put in the SM block so an intermediate variable is used.
// 状态跳转使能信号生成/ 故障检测使能信号生成
//------------------------------------------------------------------------------
// Asserts when SM is ready to move to the next VRD enablement
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pchdsw_state_trans_en <= 1'b0; // 主电源组上电看门狗超时使能
        pch_state_trans_en    <= 1'b0; // 南桥上电看门狗超时使能
        pwrup_state_trans_en  <= 1'b0; // 辅电源组上电看门狗超时使能
    end
    else begin
        pchdsw_state_trans_en <= dsw_pwrok_timeout    & pgd_so_far;
        pch_state_trans_en    <= pch_watchdog_timeout & pgd_so_far;
        pwrup_state_trans_en  <= pon_watchdog_timeout & pgd_so_far;
    end
end

// 故障检测使能信号
always @(posedge clk or posedge reset) begin
    if(reset) begin
        pchdsw_critical_fail_en   <= 1'b0;
        pch_critical_fail_en      <= 1'b0;
        pwron_critical_fail_en    <= 1'b0;
        psu_critical_fail_en      <= 1'b0;
        efuse_critical_fail_en    <= 1'b0;
        wait_steady_pwrok_fail_en <= 1'b0;
    end
    else if(keep_alive_on_fault) begin
        pchdsw_critical_fail_en   <= 1'b0;
        pch_critical_fail_en      <= 1'b0;
        pwron_critical_fail_en    <= 1'b0;
        psu_critical_fail_en      <= 1'b0;
        efuse_critical_fail_en    <= 1'b0; // EFUSE上电看门狗超时使能
        wait_steady_pwrok_fail_en <= 1'b0;
    end
    else begin
        pchdsw_critical_fail_en   <= (dsw_pwrok_timeout          & ~pgd_so_far) | any_pwr_fault_det;
        pch_critical_fail_en      <= (pch_watchdog_timeout       & ~pgd_so_far) | any_pwr_fault_det;
        pwron_critical_fail_en    <= (pon_watchdog_timeout       & ~pgd_so_far) | any_pwr_fault_det;
        psu_critical_fail_en      <= (psu_watchdog_timeout       & ~pgd_so_far) | any_pwr_fault_det;
        efuse_critical_fail_en    <= (efuse_watchdog_timeout     & ~pgd_so_far) | any_pwr_fault_det;
        wait_steady_pwrok_fail_en <= (pon_65ms_watchdog_timeout  & ~pgd_so_far) | any_pwr_fault_det;
    end
end

// 寄存故障检测结果
assign rt_critical_fail_check = any_pwr_fault_det ;
always @(posedge clk or posedge reset) begin
    if (reset)
        rt_critical_fail_store <= 1'b0;
    else
        rt_critical_fail_store <= ( st_steady_pwrok  & rt_critical_fail_check) |
                                  (~st_critical_fail & rt_critical_fail_store);
end

assign rt_normal_pwr_down = (~turn_system_on | pch_thermtrip_n_delay);      

// 输出点灯观察使用
always @(posedge clk or posedge reset) begin
    if (reset)
        pgd_raw <= 1'b0;
    else if (t1us)
        pgd_raw <= pgd_so_far & st_steady_pwrok & ~rt_critical_fail_check;
    else
        pgd_raw <= pgd_so_far & pgd_raw & ~rt_critical_fail_check;
end


//------------------------------------------------------------------------------
// Synchronous portion of FSM
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= `SM_RESET_STATE;
    else if (t1us)
        state <= state_ns;
end

assign power_seq_sm = state;


//------------------------------------------------------------------------------
// Combinatorial portion of FSM
//------------------------------------------------------------------------------
always @(*) begin
    // 初始值赋予
    state_ns                  = state;

    // 清除开机按钮使用
    assert_button_clr         = 1'b0;

    // 故障标志位使用， stby, po, rt 三种故障分别独立记录
    stby_failure_detected_clr = 1'b0;
    stby_failure_detected_set = 1'b0;

    po_failure_detected_clr   = 1'b0;
    po_failure_detected_set   = 1'b0;

    rt_failure_detected_clr   = 1'b0;
    rt_failure_detected_set   = 1'b0;

    ready_for_recov_clr       = 1'b0;
    ready_for_recov_set       = 1'b0;
    lim_recov_retry_clr       = 1'b0;
    lim_recov_retry_incr      = 1'b0;

    // SM_OFF_STANDBY 状态使用
    off_state                 = 1'b0;

    // fault_clear 信号使用
    fault_clear_ns            = 1'b0;
    POWER_DOWN_FLAG_clr       = 1'b0;

    // 热跳变及重启关机标志位使用
    pch_thermtrip_FLAG_SET    = 1'b0;
    CPU_OFF_FLAG_SET          = 1'b0;
    REBOOT_FLAG_SET           = 1'b0;

    case (state)
        `SM_RESET_STATE : begin
            state_ns = `SM_OFF_STANDBY;

            stby_failure_detected_clr = 1'b1;
            po_failure_detected_clr   = 1'b1;
            rt_failure_detected_clr   = 1'b1;
            POWER_DOWN_FLAG_clr       = 1'b1;
        end

        // 上电状态
        // 1. S5 设备使能状态, 开始上S5设备上电
        `SM_ENABLE_S5_DEVICES : begin
            if(pwron_critical_fail_en) begin
                state_ns = `SM_DISABLE_S5_DEVICES;
                po_failure_detected_set = 1'b1;
            end
            else if (pwrup_state_trans_en) begin
                state_ns = `SM_OFF_STANDBY;
            end
        end

        // 2. S5 设备上电后, 等待系统开机请求
        `SM_OFF_STANDBY : begin
            if (any_pwr_fault_det) begin
                state_ns = `SM_CRITICAL_FAIL;
                stby_failure_detected_set = 1'b1;
            end
            else if(s5dev_pwrdis_request) begin
                state_ns = `SM_DISABLE_S5_DEVICES;
            end
            else if(s5dev_pwren_request && s5_devices_on_wait_complete) begin
                state_ns = `SM_ENABLE_S5_DEVICES;
            end
            else if(turn_system_on && r_Pwrbtn_long_flag && dc_on_wait_complete)begin
                state_ns = `SM_OFF_STANDBY      ;
            end
	        else if(turn_system_on && (dc_on_wait_complete) && ((~pch_pwrbtn_n) | ( ~pch_pwrbtn_s) | ( ~Power_WAKE_R_N ) | ( ~cpu_reboot)))begin
                //开启 off_state 信号后等待判断按键信号
                state_ns = `SM_PS_ON;
                // 清除开机按钮和故障标志位
                assert_button_clr = 1'b1;
                fault_clear_ns    = 1'b1;
            end

            // 开启 off_state 信号
            off_state = 1'b1;
        end
    
        // 3. PSU 上电状态
        `SM_PS_ON : begin
            if(psu_critical_fail_en)begin
                state_ns = `SM_CRITICAL_FAIL;
                po_failure_detected_set = 1'b1;
            end
            else if (psu_watchdog_timeout && pgd_so_far) begin  
                state_ns = `SM_EN_5V_STBY;
            end
        end

        `SM_EN_5V_STBY : begin
            // - Enable telemetry rails (P3V3_PWM_CTRL and PVCC_HPMOS).
            // - BL, skipped since telemetry rails are enabled during ??
            if (pwron_critical_fail_en) begin
              state_ns = `SM_CRITICAL_FAIL;
              po_failure_detected_set = 1'b1;
            end
            else if (pwrup_state_trans_en) begin
              state_ns = `SM_EN_TELEM;
            end
        end

        `SM_EN_TELEM : begin
          // - Enable telemetry rails (P3V3_PWM_CTRL and PVCC_HPMOS).
          // - BL, skipped since telemetry rails are enabled during ??
          if(pwron_critical_fail_en) begin
                state_ns = `SM_CRITICAL_FAIL;
                po_failure_detected_set = 1'b1;
          end
          else if(pwrup_state_trans_en) begin
                state_ns = `SM_EN_MAIN_EFUSE;
          end
        end

        `SM_EN_MAIN_EFUSE : begin
            // - BL, called after `SM_EN_P3V3_VCC` state. Go to enabling PCH rails next.
            // - Non-BL, part of power-on sequence.
            if (efuse_critical_fail_en) begin
                state_ns = `SM_CRITICAL_FAIL;
                po_failure_detected_set = 1'b1;
            end
            else if (efuse_watchdog_timeout && pgd_so_far) begin
                state_ns = `SM_EN_5V;
            end
        end

        `SM_EN_5V : begin
            if (pwron_critical_fail_en) begin
                state_ns = `SM_CRITICAL_FAIL;
                po_failure_detected_set = 1'b1;
            end
            else if (pwrup_state_trans_en ) begin
                state_ns = `SM_EN_3V3;
            end
        end

        `SM_EN_3V3 : begin
            if (pch_critical_fail_en) begin
                state_ns = `SM_CRITICAL_FAIL;
                po_failure_detected_set = 1'b1;
            end
            else if (pch_state_trans_en) begin
                state_ns =  `SM_EN_P1V8;
            end
        end

        // 4. CPU 主电源组上电序列
        `SM_EN_P1V8 : begin
          if (pchdsw_critical_fail_en) begin
                state_ns = `SM_CRITICAL_FAIL;
                po_failure_detected_set = 1'b1;
          end
          else if (pchdsw_state_trans_en) begin
                state_ns = `SM_EN_P2V5_VPP;
          end
        end

        `SM_EN_P2V5_VPP : begin
            if (pchdsw_critical_fail_en) begin
                  state_ns = `SM_CRITICAL_FAIL;
                  po_failure_detected_set = 1'b1;
            end
            else if (pchdsw_state_trans_en) begin
                  state_ns = `SM_EN_VP;   
            end
        end


        `SM_EN_VP : begin                        
            if (pchdsw_critical_fail_en) begin        
                state_ns = `SM_CRITICAL_FAIL;           
                po_failure_detected_set = 1'b1;        
            end                                      
            else if (pchdsw_state_trans_en) begin      
                state_ns = `SM_EN_P0V8;               
            end                                      
        end                                        

        `SM_EN_P0V8 : begin                   
            if (pchdsw_critical_fail_en) begin    
                state_ns = `SM_CRITICAL_FAIL;       
                po_failure_detected_set = 1'b1;    
            end                                  
            else if (pchdsw_state_trans_en) begin 
                state_ns = `SM_EN_VDD;           
            end                                  
        end                                    
	
        `SM_EN_VDD : begin                   
            if (pchdsw_critical_fail_en) begin    
                state_ns = `SM_CRITICAL_FAIL;       
                po_failure_detected_set = 1'b1;    
            end                                  
            else if (pchdsw_state_trans_en) begin             
                state_ns = `PEX_RESET;            
            end                                  
        end	
       
       
        `PEX_RESET  : begin                   
            if(pchdsw_critical_fail_en)begin    
                state_ns = `SM_CRITICAL_FAIL;       
                po_failure_detected_set = 1'b1;    
            end                                  
            else if (pchdsw_state_trans_en) begin            
                state_ns = `SM_CPU_RESET;            
            end                                  
        end
       
        `SM_CPU_RESET    : begin                   
             if (pchdsw_critical_fail_en) begin    
                 state_ns = `SM_CRITICAL_FAIL;       
                 po_failure_detected_set = 1'b1;    
             end                                  
             else if (pchdsw_state_trans_en) begin      
                 state_ns = `SM_WAIT_POWEROK;            
             end                                  
        end		                        

        // 5. CPU复位释放后等待65ms稳定时间
        `SM_WAIT_POWEROK : begin
            if (wait_steady_pwrok_fail_en) begin
                state_ns = `SM_CRITICAL_FAIL;
                po_failure_detected_set = 1'b1;
            end
            else if(pon_65ms_watchdog_timeout && pgd_so_far) begin
                state_ns = `SM_STEADY_PWROK;
                POWER_DOWN_FLAG_clr = 1'b1;
            end
        end

        // 6. 上电稳定运行状态
        `SM_STEADY_PWROK : begin
            if (rt_critical_fail_store)begin  
                state_ns = `SM_CRITICAL_FAIL;
                rt_failure_detected_set = 1'b1;
            end
            else if(rt_normal_pwr_down || r_Pwrbtn_long)begin  
                state_ns = `SM_CRITICAL_FAIL;  	
                pch_thermtrip_FLAG_SET = 1'b1;            
            end
            else if (~cpu_power_off) begin
                state_ns = `SM_CRITICAL_FAIL;
                CPU_OFF_FLAG_SET = 1'b1;
            end

            else if (~pch_sys_reset_n) begin
                state_ns = `SM_CRITICAL_FAIL;
                REBOOT_FLAG_SET = 1'b1;
            end
            // 有限恢复相关状态flag清除
            lim_recov_retry_clr = 1'b1;
        end
    
        // 下电状态
        // 1. 故障下电开始
        `SM_CRITICAL_FAIL : begin
            state_ns = `SM_DISABLE_VDD;
            assert_button_clr = 1'b1;
        end

        // 2. CPU 主电源组下电序列
        `SM_DISABLE_VDD : begin              
            if (pdn_watchdog_timeout) begin            
                state_ns = `SM_DISABLE_P0V8;              
            end                                  
        end	                                  

        `SM_DISABLE_P0V8 : begin                  
            if (pdn_watchdog_timeout) begin          
                state_ns = `SM_DISABLE_VP;              
            end                                      
        end	                                    

        `SM_DISABLE_VP : begin
            if (pdn_watchdog_timeout) begin
                state_ns = `SM_DISABLE_P2V5_VPP;
            end
        end

        `SM_DISABLE_P2V5_VPP : begin
            if (pdn_watchdog_timeout) begin
                state_ns = `SM_DISABLE_P1V8;
            end
        end    
    
        `SM_DISABLE_P1V8 : begin
            if (pdn_watchdog_timeout) begin
                state_ns = `SM_DISABLE_3V3;
            end
        end       
    
        // 3. 辅电下电
        `SM_DISABLE_3V3 : begin
            if (disable_3v3_timeout) begin
                state_ns = `SM_DISABLE_5V;
            end
        end

        `SM_DISABLE_5V : begin
            if (pdn_watchdog_timeout)
                state_ns = `SM_DISABLE_MAIN_EFUSE;
        end

        `SM_DISABLE_MAIN_EFUSE : begin
            if (pdn_watchdog_timeout) begin
                state_ns = `SM_DISABLE_TELEM;
          end
            off_state = 1'b0;
        end

        `SM_DISABLE_TELEM : begin
            if (pdn_watchdog_timeout) begin
                state_ns = `SM_DISABLE_PS_ON;
            end
        end

        `SM_DISABLE_PS_ON : begin
            if (pdn_watchdog_timeout)
                state_ns = (any_pwr_fault_det) ? `SM_DISABLE_S5_DEVICES : `SM_OFF_STANDBY;
        end

        `SM_DISABLE_S5_DEVICES : begin
            if (pdn_watchdog_timeout) begin
      	        if (any_pwr_fault_det)
                    state_ns = `SM_HALT_POWER_CYCLE;
            else
                state_ns = `SM_OFF_STANDBY;
            end
        end

        `SM_HALT_POWER_CYCLE : begin
            if (ready_for_recov && !any_non_recov_fault) begin
                if (!lim_recov_retry_max)
                  if ((assert_power_button && (allow_recovery || ~any_lim_recov_fault)) ||         //yhy  any_lim_recov_fault�κ�һ·��Դ���ϵ�ʱ��Ϊ1��������ϵ�ʱ��Ϊ0
                      (assert_physical_button && !allow_recovery && any_lim_recov_fault)) begin    //yhy  .allow_recovery         (1'b0)   
                    state_ns = `SM_AUX_FAIL_RECOVERY;
                    lim_recov_retry_incr = 1'b1;
                  end
            end
            ready_for_recov_set = pf_on_wait_complete ;  
            // This is an offstate
            off_state = 1'b1;
        end

        `SM_AUX_FAIL_RECOVERY : begin
            // Clear faults
            stby_failure_detected_clr = 1'b1;
            po_failure_detected_clr   = 1'b1;
            rt_failure_detected_clr   = 1'b1;
            ready_for_recov_clr       = 1'b1;
            fault_clear_ns            = 1'b1;
            off_state                 = 1'b1;

            state_ns = `SM_OFF_STANDBY;
        end

        default : begin
            state_ns = `SM_RESET_STATE;
        end
    endcase
end

endmodule


