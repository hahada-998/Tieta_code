//=================================================================================================
// Copyright(c) 2017, New H3C Technologies Co., Ltd, All right reserved
// Filename   : pwrseq_master.v
// Project    : H3C common code
// Author     : QIURONGLIN
// Date       : 2017-07-18
// Email      : qiu.ronglin@h3c.com
// Company    : New H3C Technologies Co., Ltd
// Description: This module is the power sequencing master. It is responsible for directing the
//   system's power sequencing slaves to enable/disable VRMs. The master is responsible for
//   monitoring each of the power goods coming back from the slaves. These power goods are
//   consolidated to pgd_so_far When a power fault occurs, the master will normally transition to
//   the SM_CRITICAL_FAIL state to allow the slave to capture the source of the fault. The master
//   will then proceed with power-down sequence to protect the system.
//   This module uses a single WDT counter for all timeout logic so it determines the largest
//   counter needed based on the largest timeout parameter given below. This, together with
//   sequence_tick and psu_on_tick, each platform can vary the granularity of the timeout values.
// Parameter  :
//   LIM_RECOV_MAX_RETRY_ATTEMPT: Number of allowed power-on retry attempt following a limited
//     recoverable fault condition. Once the max number of attempt is reached, the system will only
//     be recoverable by cycling aux efuse.
//     Default: 2
//   WDT_NBITS: Number of counter bits to use to support the timeout values below.
//     Default: 8 (max of 255 for any timeout values)
//     For the parameters below, it is assumed that the sequence_tick rate is 2ms while psu_on_tick
//     rate is 32ms. Platform can use a different tick as needed.
//   DSW_PWROK_TIMEOUT_VAL: ��cpu�ϵ�ʹ�ã����ó�20ms
//     Default: 10 (sequence_tick=2ms * 10 = 20ms)
//   PCH_WATCHDOG_TIMEOUT_VAL: ����p3v3�ϵ磬�����Դ���ϵ�ʱ����
//     Default: 1000 (sequence_tick=2ms * 1000 = 2s)
//   PON_WATCHDOG_TIMEOUT_VAL: Wait time for VRM turn on before considering it faulted.
//     Default: 112 (sequence_tick=2ms * 112 = 224ms)
//   PSU_WATCHDOG_TIMEOUT_VAL: 1st stage wait time for PSU turn on. If PSU is good during this
//     time, power sequencer proceed to next stage. Otherwise, wait for 2nd stage.
//     Default: 10 (psu_on_tick=32ms * 10 = 320ms)
//   EFUSE_WATCHDOG_TIMEOUT_VAL: Wait time for efuse turnon before considering it faulted.
//     Default: 137 (sequence_tick=2ms * 137 = 274ms)
//   VCORE_WATCHDOG_TIMEOUT_VAL: Wait time for CPU vcore turn on before considering it faulted.
//     Default: 112 (sequence_tick=2ms * 112 = 224ms)
//   PDN_WATCHDOG_TIMEOUT_VAL: Wait time for VRM turn off during no-fault condition.
//     Default: 2 (sequence_tick=2ms * 2 = 4ms)
//   PDN_WATCHDOG_TIMEOUT_FAULT_VAL: Wait time for VRM turn off during fault condition.
//     Default: 2 (sequence_tick=2ms * 2 = 4ms)
//   DISABLE_INTEL_VCCIN_TIMEOUT_VAL, DISABLE_INTEL_VCCIN_TIMEOUT_FAULT_VAL: Wait time for VRM turn
//     off during SM_DISABLE_INTEL_VCCIN state for both normal and fault condition.
//     This is a state specific timout value.
//     Default: PDN_WATCHDOG_TIMEOUT_VAL
//   DISABLE_3V3_TIMEOUT_VAL, DISABLE_3V3_TIMEOUT_FAULT_VAL: Wait time for VRM turn off during
//     SM_DISABLE_3V3 state for both normal and fault condition.
//     This is a state specific timout value.
//     Default: PDN_WATCHDOG_TIMEOUT_VAL
//   PON_65MS_WATCHDOG_TIMEOUT_VAL: Wait before transitioning to SM_STEADY_PWROK after all VRM has turnd on.
//     Default: 34 (sequence_tick=2ms * 34 = 68ms)
//   DC_ON_WAIT_COMPLETE_NOFLT_VAL: Time to wait in SM_OFF_STANDBY before proceeding to turn on w/o fault.
//     Default: 17 (256ms * 17 = 4.3s)
//   DC_ON_WAIT_COMPLETE_FAULT_VAL: Time to wait in SM_OFF_STANDBY before proceeding to turn on with fault.
//     Default: 2 (256ms * 2 = 512ms)
//   PF_ON_WAIT_COMPLETE_VAL: Time to wait in SM_HALT_POWER_CYCLE before allowing recovery, if
//     allowed. This is also the time used to assert PCH PWRBTN# input to force S0->S5 transition.
//     Default: 33 (256ms * 33 = 8.4s)
//   PO_ON_WAIT_COMPLETE_VAL: Time to assert the PCH PWRBTN# input to force an S5->S0 transition.
//     Default: 1 (256ms * 1 = 256ms)
//   S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL, S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL: Time to wait in
//     SM_OFF_STANDBY before proceeding to enable the S5 devices.
//     Default: 0 (256ms * 0 = 0)
// History    :
//   Date      By          Revision  Change Description
//   20170718  QIURONGLIN  1.0       file created
//=================================================================================================
`include "rs35m2c16s_g5_define.vh"
module pwrseq_master #(
  parameter LIM_RECOV_MAX_RETRY_ATTEMPT           = 2                         , // 最大恢复重试次数
  parameter WDT_NBITS                             = 10                        , // 看门狗计数器位宽
  parameter DSW_PWROK_TIMEOUT_VAL                 = 10                        , // 
  parameter PCH_WATCHDOG_TIMEOUT_VAL              = 1000                      , // 
  parameter PON_WATCHDOG_TIMEOUT_VAL              = 112                       , // 上电看门狗超时时间
  parameter PSU_WATCHDOG_TIMEOUT_VAL              = 10                        , // 
  parameter EFUSE_WATCHDOG_TIMEOUT_VAL            = 137                       , // 
  parameter VCORE_WATCHDOG_TIMEOUT_VAL            = PON_WATCHDOG_TIMEOUT_VAL  , // 
  parameter PDN_WATCHDOG_TIMEOUT_VAL              = 2                         , // 
  parameter PDN_WATCHDOG_TIMEOUT_FAULT_VAL        = PDN_WATCHDOG_TIMEOUT_VAL  , // 
  parameter DISABLE_INTEL_VCCIN_TIMEOUT_VAL       = PDN_WATCHDOG_TIMEOUT_VAL  , // 
  parameter DISABLE_INTEL_VCCIN_TIMEOUT_FAULT_VAL = PDN_WATCHDOG_TIMEOUT_VAL  , // 
  parameter DISABLE_3V3_TIMEOUT_VAL               = PDN_WATCHDOG_TIMEOUT_VAL  , // 
  parameter DISABLE_3V3_TIMEOUT_FAULT_VAL         = PDN_WATCHDOG_TIMEOUT_VAL  , // 
  parameter PON_65MS_WATCHDOG_TIMEOUT_VAL         = 34                        , // 上电65ms看门狗超时时间
  parameter DC_ON_WAIT_COMPLETE_NOFLT_VAL         = 17                        , // 无故障时DC ON等待完成时间 
  parameter DC_ON_WAIT_COMPLETE_FAULT_VAL         = 2                         , // 有故障时DC ON等待完成时间 
  parameter PF_ON_WAIT_COMPLETE_VAL               = 33                        , // 电源故障等待完成时间
  parameter PO_ON_WAIT_COMPLETE_VAL               = 1                         , // 电源开启等待完成时间
  parameter S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL = 0                         , // 无故障时S5设备开启等待时间                       
  parameter S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL = 0                           // 有故障时S5设备开启等待时间
)(                      
  input            clk,                     // clock
  input            reset,                   // reset
  input            t1us,                    // 10ns pulse every 1us
  input            t512us,                  // 10ns pulse every 512us
  input            t256ms,                  // 10ns pulse every 256ms
  input            t512ms,                  // 10ns pulse every 500ms
  input            sequence_tick,           // tick used for wdt timeout during power-up/down states
  input            psu_on_tick,             // tick used for wdt timeout during PS on state

  // Physical power button and south bridge status/control
  input            sys_sw_in_n,             // system's power button switch
//  input            pch_slp4_n,              // SB (south bridge) system sleep state
  input            pch_pwrbtn_n,            // SB power button input (same signal driven to SB PWRBTN)
  input            pch_pwrbtn_s,            // SB power button input (same signal driven to SB PWRBTN) delay 1s
  
  input            pch_thermtrip_n,          // SB bound thermtrip signal (same signal driven to SB THERMTRIP)
  output reg       force_pwrbtn_n,          // forces SB to switch to S5 after power shutdown due to fault

  input            cpu_reboot,                // cpu�ͳ����������1��Ч,���5s�ͳ�
  input            cpu_reboot_x,             // cpu�ͳ����������1��Ч,���3s�ͳ�
  input            cpu_power_off,                // CPU �ͳ����µ����0��Ч


  input            xr_ps_en,                // system allowed to power on (Xreg's ps_enable)  //�Ĵ���51.Ĭ������0,��ʾ����PSU���������(PSON
//YHY  input            pwron_override_n,        // power-on override    Ĭ������1
//YHY  input            interlock_broken,        // interlock broken indicator
  input            allow_recovery,          // allow power button press to recover from HALT_POWER_CYCLE
//YHY  input            aux_video_holdoff,       // allow AUX video to hold turning on of system
//YHY  input            pgood_rst_mask,          // from ADR module to mask shutdown events
//YHY  input            cpu_mcp_en,              // any CPU is MCP enabled which enables P1V0_CPU and PVMCP_CPU rails
  input            keep_alive_on_fault,     // prevent transition to critical fail on power up
//yhy  input            no_vppen,                // set to 1'b1 if platform does not have an explicity EN for VPP rails
//yhy  input            hold_pch_rsmrst,         // set to 1'b1 to stall power sequencer in state before RSMRST# is released
  output reg       pgd_raw,                 // de-asserts on SM_STEADY_OK on fault condition

  // S5 powered device control
  input            s5dev_pwren_request,     // S5 powered device enable request
  input            s5dev_pwrdis_request,    // S5 powered device disable request

  // Slave sequencer interface
  input            pgd_so_far,              // current overall power status
  input            any_pwr_fault_det,       // any type of power fault
  input            any_lim_recov_fault,     // any limited recovery fault
  input            any_non_recov_fault,     // any non-recoverable fault
  output reg       dc_on_wait_complete,     // 4s flag - used by slave for stuck on check
  output reg       rt_critical_fail_store,  // asserts when during runtime when critical failure detected
  output reg       fault_clear,             // clear fault flags
  output     [5:0] power_seq_sm,            // copy of the state variable

//POWER_OFF_FLAG
output reg  pch_thermtrip_FLAG, 
output reg  CPU_OFF_FLAG,
output reg  REBOOT_FLAG, 


   input  Power_WAKE_R_N,
   input  pch_sys_reset_n,
   output  reg turn_system_on,

  // Status
  output reg       power_fault,             // power fault is active
  output reg       stby_failure_detected,   // standby failure detected (goes to Xreg byte07[4]
  output reg       po_failure_detected,     // poweron failure detected (goes to Xreg byte07[2])
  output reg       rt_failure_detected,     // runtime failure detected (goes to Xreg byte07[5])
  output reg       cpld_latch_sys_off,      // system in non-recovery state (goes to Xreg byte08[6])
  output reg       turn_on_wait             // system waiting to turn on
);

`include "pwrseq_define.vh"

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


// FSM 
reg    [5:0]                                  state                             ; // 当前状态
reg    [5:0]                                  state_ns                          ; // 下一状态
reg    [5:0]                                  power_seq_sm_last                 ; // 上一个状态

wire                                          st_off_standby                    ; //状态机 SM_OFF_STANDBY 状态
wire                                          st_ps_on                          ; //状态机 SM_PS_ON 状态
wire                                          st_steady_pwrok                   ; //状态机 SM_STEADY_PWROK 状态
wire                                          st_critical_fail                  ; //状态机 SM_CRITICAL_FAIL 状态
wire                                          st_halt_power_cycle               ; //状态机 SM_HALT_POWER_CYCLE 状态
wire                                          st_disable_main_efuse             ; //状态机 SM_DISABLE_MAIN_EFUSE 状态

// 上下电看门狗计数器
reg     [WDT_NBITS-1:0]                       wdt_counter                       ; // 看门狗计数器
wire                                          wdt_tick                          ; // 看门狗计数器的时钟信号
wire                                          wdt_counter_clr                   ; // 看门狗计数器清零信号

// 各阶段超时标志：电源组A/B就绪超时、上电超时、PSU超时、eFuse超时、Vcore超时、断电超时等
reg                                           dsw_pwrok_timeout                 ;
reg                                           pch_watchdog_timeout              ;
reg                                           pon_watchdog_timeout              ;
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

/* ------------------------------------------------------------------------------------------------------------
主板上下电状态机
---------------------------------------------------------------------------------------------------------------*/
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
        SM_RESET_STATE: begin
            state_ns = SM_EN_P3V3_VCC;
        end

        SM_EN_P3V3_VCC: begin
            if(critical_fail_en_sm_en_p3v3_vcc)                       
                state_ns = SM_CRITICAL_FAIL;
            else if(trans_en_sm_en_p3v3_vcc)                          
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
            else if(psu_watchdog_timeout && pgd_so_far)               
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
            else if(efuse_watchdog_timeout && pgd_so_far)             
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
            else if(pon_65ms_watchdog_timeout && pgd_so_far)          
                state_ns = SM_STEADY_PWROK;
        end

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
        SM_DISABLE_3V3:         if (disable_3v3_timeout)             state_ns = SM_DISABLE_5V;
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
reg                                           assert_button_clr                 ; // 清除按钮信号

// 
reg                                           stby_failure_detected_clr         ;
reg                                           stby_failure_detected_set         ;
reg                                           po_failure_detected_clr           ;
reg                                           po_failure_detected_set           ;
reg                                           rt_failure_detected_clr           ;
reg                                           rt_failure_detected_set           ;

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
        SM_RESET_STATE: begin
            stby_failure_detected_clr = 1'b1;
            po_failure_detected_clr   = 1'b1;
            rt_failure_detected_clr   = 1'b1;
            POWER_DOWN_FLAG_clr       = 1'b1;
        end

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


// Button logic
wire Power_WAKE_R_N_ne;
wire cpu_reboot_ne;
  wire pch_pwrbtn_n_ne;
wire sys_sw_in_n_ne;
reg  assert_power_button;
reg  assert_physical_button;
reg  assert_button_clr;

// Fault flags
reg  stby_failure_detected_clr;
reg  stby_failure_detected_set;
reg  po_failure_detected_clr;
reg  po_failure_detected_set;
reg  rt_failure_detected_clr;
reg  rt_failure_detected_set;

// Limited recovery logic
reg  ready_for_recov;
reg  ready_for_recov_clr;
reg  ready_for_recov_set;
reg  [LIM_RECOV_RETRY_NBITS-1:0] lim_recov_retry_count;
reg  lim_recov_retry_incr;
reg  lim_recov_retry_clr;
wire lim_recov_retry_max;

// Misc
reg  off_state;

wire pch_thermtrip_n_delay;
reg  fault_clear_ns;

// State transition
 reg  pchdsw_state_trans_en;
 reg  pchdsw_critical_fail_en;
 reg  pch_state_trans_en;
 reg  pch_critical_fail_en;
reg  pwrup_state_trans_en;
reg  pwron_critical_fail_en;
reg  psu_critical_fail_en;
reg  efuse_critical_fail_en;
//yhy reg  vcore_critical_fail_en;
reg  wait_steady_pwrok_fail_en;
wire rt_critical_fail_check;
wire rt_normal_pwr_down;


// SM states
assign st_off_standby        = (power_seq_sm == SM_OFF_STANDBY);
assign st_ps_on              = (power_seq_sm == SM_PS_ON);
assign st_steady_pwrok       = (power_seq_sm == SM_STEADY_PWROK);
assign st_critical_fail      = (power_seq_sm == SM_CRITICAL_FAIL);
assign st_halt_power_cycle   = (power_seq_sm == SM_HALT_POWER_CYCLE);
assign st_disable_main_efuse = (power_seq_sm == SM_DISABLE_MAIN_EFUSE);


//------------------------------------------------------------------------------
// Watchdog logic
//------------------------------------------------------------------------------
// Tick rate depends on which state we're in.
assign wdt_tick = (off_state) ? t256ms       :
                  (st_ps_on)  ? psu_on_tick  :  //YHY 32MS
                                sequence_tick;  //YHY  2MS

// Clear counter - generates a 1us pulse on entry to new state
always @(posedge clk or posedge reset) begin
  if (reset)
    power_seq_sm_last <= SM_RESET_STATE;
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
    if (wdt_counter == DSW_PWROK_TIMEOUT_VAL)         //10 yhy                                 
      dsw_pwrok_timeout <= 1'b1;                                                           
                                                                                           
   if (wdt_counter == PCH_WATCHDOG_TIMEOUT_VAL)      //1000yhy                                  
     pch_watchdog_timeout <= 1'b1;                                                        
                                                                                           
    if (wdt_counter == PON_WATCHDOG_TIMEOUT_VAL)     //112                                   
      pon_watchdog_timeout <= 1'b1;                                                        
                                                                                           
    if (wdt_counter == PSU_WATCHDOG_TIMEOUT_VAL)     //10                                      
      psu_watchdog_timeout <= 1'b1;                                                        
                                                                                           
    if (wdt_counter == EFUSE_WATCHDOG_TIMEOUT_VAL)   //137                                      
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
always @(posedge clk or posedge reset) begin                                              
  if (reset) begin                                                                        
    dc_on_wait_complete         <= 1'b0;                                                  
    po_on_wait_complete         <= 1'b0;                                                  
    s5_devices_on_wait_complete <= 1'b0;
  end
  else if (t1us) begin
//YHY    if (!off_state || interlock_broken) begin
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

// pf_on_wait_complete is separated from above since it needs to also assert
// during interlock_broken case.
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
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    turn_system_on <= 1'b0;
  else if (t1us)
//YHY    turn_system_on <= (xr_ps_en | ~pwron_override_n | turn_system_on)   &  // allowed to turn on
//YHY                      pch_slp4_n                                        &  // SB in S0 state
//YHY                      ~interlock_broken                                 &  // nothing is broken
//YHY                      ~aux_video_holdoff;

//YHYLINSHI  turn_system_on <= (xr_ps_en  | turn_system_on) & pch_pwrbtn_n & cpu_power_off;         //�Ĵ���51.Ĭ������0,��ʾ����PSU���������(PSON             
                      
  turn_system_on <= (xr_ps_en  | turn_system_on)  ;         //�Ĵ���51.Ĭ������0,��ʾ����PSU���������(PSON             
                      
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




always @(posedge clk or posedge reset) begin
  if (reset)
    assert_power_button <= 1'b0;
  else if (assert_button_clr || ~force_pwrbtn_n)    

    assert_power_button <= 1'b0;
//YHY   else if (pch_pwrbtn_n_ne && off_state  )
   else if ((pch_pwrbtn_n_ne  | Power_WAKE_R_N_ne |  cpu_reboot_ne) && off_state   )

    assert_power_button <= 1'b1;
end

always @(posedge clk or posedge reset) begin
  if (reset)
    assert_physical_button <= 1'b0;
  else if (assert_button_clr)
    assert_physical_button <= 1'b0;
  else if ((sys_sw_in_n_ne  |  Power_WAKE_R_N_ne |  cpu_reboot_ne )  && st_halt_power_cycle)
    assert_physical_button <= 1'b1;
end


//------------------------------------------------------------------------------
// force_pwrbtn_n
// - Asserts low when power sequencer needs to toggle SB power button input.
// - Note the differet behavior between BL and non-BL platform
//------------------------------------------------------------------------------
   always @(posedge clk or posedge reset) begin
     if (reset)
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
   //YHY    force_pwrbtn_n <=
   //YHY      ~((           st_halt_power_cycle   &  power_fault                          // \ 1.
   //YHY                                          & ~pf_on_wait_complete)              |  // /
   //YHY        (           st_off_standby        &  power_fault                          // \ 4.
   //YHY                                          &  (po_on_wait_complete)                // |
   //YHY                                          &  assert_power_button                  // |
   //YHY                                          & ~pch_slp4_n));                        // /
       force_pwrbtn_n <=
         ~((           st_halt_power_cycle   &  power_fault                          // \ 1.
                                             & ~pf_on_wait_complete)              |  // /
           (           st_off_standby        &  power_fault                          // \ 4.
                                             &  (po_on_wait_complete)                // |
                                             &  assert_power_button                  // |
                                             ));                        // /                                          
                                             
     end
   end


//------------------------------------------------------------------------------
// turn_on_wait
// - Asserts when system has been triggered to turn on and keep asserted until
//   SM_STEADY_PWROK or SM_CRITICAL_FAIL is reached.
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    turn_on_wait <= 1'b0;
  else if (t1us)
//YHY    turn_on_wait <= (st_off_standby & turn_system_on) |
//YHY                    (assert_power_button)             |
//YHY                    (turn_on_wait & ~(st_steady_pwrok | st_critical_fail));     
    turn_on_wait <= (assert_power_button)             |                                        
                    (turn_on_wait & ~(st_steady_pwrok | st_critical_fail));                    
end


//------------------------------------------------------------------------------
// cpld_latch_sys_off
// - Asserts when in SM_HALT_POWER_CYCLE and we've reached the max number of
//   retry attempt. Aux power cycle is required.
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    cpld_latch_sys_off <= 1'b0;
  else
    cpld_latch_sys_off <= st_halt_power_cycle & lim_recov_retry_max;
end


//------------------------------------------------------------------------------
// stby, poweron and runtime fault flags
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


reg pch_thermtrip_FLAG_SET;
reg CPU_OFF_FLAG_SET;
reg REBOOT_FLAG_SET;
reg POWER_DOWN_FLAG_clr;

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
//------------------------------------------------------------------------------
// Asserts when SM is ready to move to the next VRD enablement
always @(posedge clk or posedge reset) begin
  if (reset) begin
    pchdsw_state_trans_en <= 1'b0;
    pch_state_trans_en    <= 1'b0;
    pwrup_state_trans_en  <= 1'b0;
  end
  else begin
    pchdsw_state_trans_en <= dsw_pwrok_timeout & pgd_so_far;
    pch_state_trans_en    <= pch_watchdog_timeout & pgd_so_far;
    pwrup_state_trans_en  <= pon_watchdog_timeout & pgd_so_far;
  end
end

 `ifdef SPECIFIC_POWER_P1V8_PCH_STBY
  `define TIMEOUT_SM_EN_P3V3_VCC      8'd2
//YHY  `define TIMEOUT_SM_EN_PCH_DSW_PWROK 8'd2

  reg watchdog_timout_sm_en_p3v3_vcc      ;
//YHY  reg watchdog_timout_sm_en_pch_dsw_pwrok ;
  reg trans_en_sm_en_p3v3_vcc             ;
//YHY  reg trans_en_sm_en_pch_dsw_pwrok        ;
  reg critical_fail_en_sm_en_p3v3_vcc     ;
//YHY  reg critical_fail_en_sm_en_pch_dsw_pwrok;

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    	watchdog_timout_sm_en_p3v3_vcc <= 1'b0;
    else if (wdt_counter_clr)
    	watchdog_timout_sm_en_p3v3_vcc <= 1'b0;
    else if (wdt_tick) begin
      if (wdt_counter==`TIMEOUT_SM_EN_P3V3_VCC)
    	  watchdog_timout_sm_en_p3v3_vcc <= 1'b1;
    end
  end

//YHY   always @(posedge clk or posedge reset)
//YHY   begin
//YHY     if (reset)
//YHY     	watchdog_timout_sm_en_pch_dsw_pwrok <= 1'b0;
//YHY     else if (wdt_counter_clr)
//YHY     	watchdog_timout_sm_en_pch_dsw_pwrok <= 1'b0;
//YHY     else if (wdt_tick) begin
//YHY       if (wdt_counter==`TIMEOUT_SM_EN_PCH_DSW_PWROK)
//YHY     	  watchdog_timout_sm_en_pch_dsw_pwrok <= 1'b1;
//YHY     end
//YHY   end
//YHY 
  always @(posedge clk or posedge reset)
  begin
    if (reset) begin
    	trans_en_sm_en_p3v3_vcc      <= 1'b0;
//YHY    	trans_en_sm_en_pch_dsw_pwrok <= 1'b0;
    end
    else begin
    	trans_en_sm_en_p3v3_vcc      <= watchdog_timout_sm_en_p3v3_vcc      & pgd_so_far;
//YHY    	trans_en_sm_en_pch_dsw_pwrok <= watchdog_timout_sm_en_pch_dsw_pwrok & pgd_so_far;


    end
  end

  always @(posedge clk or posedge reset)
  begin
    if (reset) begin
    	critical_fail_en_sm_en_p3v3_vcc      <= 1'b0;
//YHY    	critical_fail_en_sm_en_pch_dsw_pwrok <= 1'b0;
    end
    else if (keep_alive_on_fault) begin
    	critical_fail_en_sm_en_p3v3_vcc      <= 1'b0;
//YHY    	critical_fail_en_sm_en_pch_dsw_pwrok <= 1'b0;
    end
    else begin
    	critical_fail_en_sm_en_p3v3_vcc      <= (watchdog_timout_sm_en_p3v3_vcc      & (~pgd_so_far)) | any_pwr_fault_det;
//YHY    	critical_fail_en_sm_en_pch_dsw_pwrok <= (watchdog_timout_sm_en_pch_dsw_pwrok & (~pgd_so_far)) | any_pwr_fault_det;

    end
  end
`endif


// Registered to ease timing
always @(posedge clk or posedge reset) begin
  if (reset) begin
    pchdsw_critical_fail_en   <= 1'b0;
    pch_critical_fail_en      <= 1'b0;
    pwron_critical_fail_en    <= 1'b0;
    psu_critical_fail_en      <= 1'b0;
    efuse_critical_fail_en    <= 1'b0;
//yhy    vcore_critical_fail_en    <= 1'b0;
    wait_steady_pwrok_fail_en <= 1'b0;
  end
  else if (keep_alive_on_fault) begin
    pchdsw_critical_fail_en   <= 1'b0;
    pch_critical_fail_en      <= 1'b0;
    pwron_critical_fail_en    <= 1'b0;
    psu_critical_fail_en      <= 1'b0;
    efuse_critical_fail_en    <= 1'b0;
//yhy    vcore_critical_fail_en    <= 1'b0;
    wait_steady_pwrok_fail_en <= 1'b0;
  end
  else begin
    pchdsw_critical_fail_en   <= (dsw_pwrok_timeout          & ~pgd_so_far) | any_pwr_fault_det;
    pch_critical_fail_en      <= (pch_watchdog_timeout       & ~pgd_so_far) | any_pwr_fault_det;
    pwron_critical_fail_en    <= (pon_watchdog_timeout       & ~pgd_so_far) | any_pwr_fault_det;
    psu_critical_fail_en      <= (psu_watchdog_timeout       & ~pgd_so_far) | any_pwr_fault_det;
    efuse_critical_fail_en    <= (efuse_watchdog_timeout     & ~pgd_so_far) | any_pwr_fault_det;
//yhy    vcore_critical_fail_en    <= (vcore_watchdog_timeout     & ~pgd_so_far) | any_pwr_fault_det;
    wait_steady_pwrok_fail_en <= (pon_65ms_watchdog_timeout  & ~pgd_so_far) | any_pwr_fault_det;
  end
end


// On fault during runtime, assert flag for the duration of SM_STEADY_OK until
// FSM transitions to SM_CRITICAL_FAIL. Flag deasserts on entry to SM_CRITICAL_FAIL.
//YHY assign rt_critical_fail_check = any_pwr_fault_det | interlock_broken;
assign rt_critical_fail_check = any_pwr_fault_det ;

always @(posedge clk or posedge reset) begin
  if (reset)
    rt_critical_fail_store <= 1'b0;
  else
    rt_critical_fail_store <= ( st_steady_pwrok  & rt_critical_fail_check) |
                              (~st_critical_fail & rt_critical_fail_store);
end

// Shutdown events
//YHY   assign rt_normal_pwr_down = ~pgood_rst_mask                         &  // > not masked by ADR and ...
//YHY                               (~turn_system_on | (pch_thermtrip_n_delay & pch_slp4_n));      //system turn off event or unresponsive PCH or (no S5 transition from THERMTRIP#) ...
assign rt_normal_pwr_down =  (~turn_system_on | pch_thermtrip_n_delay  );      //system turn off event or unresponsive PCH or (no S5 transition from THERMTRIP#) ...



// pgd_raw asserts on SM_STEADY_PWROK while pgd_so_far is high and
// rt_critical_fail_check is low. If any of these two terms switches states,
// pgd_raw will immediately de-asserts.
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
    state <= SM_RESET_STATE;
  else if (t1us)
    state <= state_ns;
end

// 'power_seq_sm' is an alias for state
assign power_seq_sm = state;


//------------------------------------------------------------------------------
// Combinatorial portion of FSM
//------------------------------------------------------------------------------
always @(*) begin
  state_ns                  = state;
  assert_button_clr         = 1'b0;
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
  off_state                 = 1'b0;
  fault_clear_ns            = 1'b0;
  
  POWER_DOWN_FLAG_clr    = 1'b0;
  pch_thermtrip_FLAG_SET = 1'b0;
        CPU_OFF_FLAG_SET = 1'b0;
        REBOOT_FLAG_SET  = 1'b0;


  case (state)
    SM_RESET_STATE : begin
      state_ns = SM_EN_P3V3_VCC;

      stby_failure_detected_clr = 1'b1;
      po_failure_detected_clr   = 1'b1;
      rt_failure_detected_clr   = 1'b1;
      POWER_DOWN_FLAG_clr       = 1'b1;
    end

//yhy   `ifdef SPECIFIC_POWER_P1V8_PCH_STBY
    SM_EN_P3V3_VCC : begin
      if (critical_fail_en_sm_en_p3v3_vcc) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (trans_en_sm_en_p3v3_vcc) begin
//YHY        state_ns = SM_EN_PCH_DSW_PWROK;
        state_ns = SM_OFF_STANDBY;
      end
    end



    SM_ENABLE_S5_DEVICES : begin
      if (pwron_critical_fail_en) begin
        // - Fault detected while trying to turn on S5 device.
        // - Non-BL/BT, go to Disable S5 device.
        state_ns = SM_DISABLE_S5_DEVICES;
        po_failure_detected_set = 1'b1;
      end
      else if (pwrup_state_trans_en) begin
        state_ns = SM_OFF_STANDBY;
      end
    end

    SM_OFF_STANDBY : begin
      if (any_pwr_fault_det) begin
        // Fault detected. Using new STBY flag for standby failure.
        state_ns = SM_CRITICAL_FAIL;
        stby_failure_detected_set = 1'b1;
      end
      else if (s5dev_pwrdis_request) begin
        // S5 device disable request or request to shutdown e-fuse (BL only)
        state_ns = SM_DISABLE_S5_DEVICES;
      end
      else if (s5dev_pwren_request && s5_devices_on_wait_complete) begin
        // S5 device enable request
        state_ns = SM_ENABLE_S5_DEVICES;
      end
    //YHY  else if (turn_system_on && (dc_on_wait_complete) ) begin	   
	   else if (turn_system_on && (dc_on_wait_complete) && (( ~pch_pwrbtn_n) | ( ~pch_pwrbtn_s) | ( ~Power_WAKE_R_N ) | ( ~cpu_reboot )) ) begin
        // Let's power on. Note that if miss_turn_on_window is asserted, there's
        // no need to wait for dc_on_wait_complete since we just went through
        // SM_MISS_TURNON which is long enough wait time for the next power up.
        state_ns = SM_PS_ON;

        // Clear assert_*_button flags and set fault_clear
        assert_button_clr = 1'b1;
        fault_clear_ns = 1'b1;
      end

      // This is an offstate
      off_state = 1'b1;
    end
    
    

    SM_PS_ON : begin
      if (psu_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (psu_watchdog_timeout && pgd_so_far ) begin  //YHY
        state_ns = SM_EN_5V_STBY;
      end
    end

    SM_EN_5V_STBY : begin
      // - Enable telemetry rails (P3V3_PWM_CTRL and PVCC_HPMOS).
      // - BL, skipped since telemetry rails are enabled during ??
      if (pwron_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (pwrup_state_trans_en) begin
        state_ns = SM_EN_TELEM;
      end
    end



    SM_EN_TELEM : begin
      // - Enable telemetry rails (P3V3_PWM_CTRL and PVCC_HPMOS).
      // - BL, skipped since telemetry rails are enabled during ??
      if (pwron_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (pwrup_state_trans_en) begin
        state_ns = SM_EN_MAIN_EFUSE;
      end
    end

    SM_EN_MAIN_EFUSE : begin
      // - BL, called after SM_EN_P3V3_VCC state. Go to enabling PCH rails next.
      // - Non-BL, part of power-on sequence.
      if (efuse_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (efuse_watchdog_timeout && pgd_so_far) begin
        state_ns = SM_EN_5V;
      end
    end

    SM_EN_5V : begin
      if (pwron_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (pwrup_state_trans_en ) begin
        state_ns = SM_EN_3V3;
      end
    end

    SM_EN_3V3 : begin
      if (pch_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (pch_state_trans_en) begin
//yhy        state_ns = (no_vppen) ? SM_EN_P0V6_VTT : SM_EN_P2V5_VPP;
                state_ns =  SM_EN_P1V8;
      end
    end


       


    SM_EN_P1V8 : begin
      // Skipped if no_vppen is set
      if (pchdsw_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (pchdsw_state_trans_en) begin
        state_ns = SM_EN_P2V5_VPP;
      end
    end



    SM_EN_P2V5_VPP : begin
      // Skipped if no_vppen is set
      if (pchdsw_critical_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (pchdsw_state_trans_en) begin
//YHY        state_ns = SM_EN_P0V6_VTT;   
     state_ns = SM_EN_VP;   
      end
    end


         SM_EN_VP : begin                        
           if (pchdsw_critical_fail_en) begin        
             state_ns = SM_CRITICAL_FAIL;           
             po_failure_detected_set = 1'b1;        
           end                                      
           else if (pchdsw_state_trans_en) begin     
//yhy             state_ns = SM_EN_VCC1V8;   
             state_ns = SM_EN_P0V8;               
           end                                      
         end                                        



        SM_EN_P0V8 : begin                   
          if (pchdsw_critical_fail_en) begin    
            state_ns = SM_CRITICAL_FAIL;       
            po_failure_detected_set = 1'b1;    
          end                                  
          else if (pchdsw_state_trans_en) begin 
            state_ns = SM_EN_VDD;           
          end                                  
        end                                    
	
	                        

       SM_EN_VDD : begin                   
         if (pchdsw_critical_fail_en) begin    
           state_ns = SM_CRITICAL_FAIL;       
           po_failure_detected_set = 1'b1;    
         end                                  
         else if (pchdsw_state_trans_en) begin 
 //yhy          state_ns = SM_EN_VCCIN;            
         state_ns = PEX_RESET;            

         end                                  
       end	
       
       
         PEX_RESET  : begin                   
         if (pchdsw_critical_fail_en) begin    
           state_ns = SM_CRITICAL_FAIL;       
           po_failure_detected_set = 1'b1;    
         end                                  
         else if (pchdsw_state_trans_en) begin 
 //yhy          state_ns = SM_EN_VCCIN;            
         state_ns = SM_CPU_RESET;            

         end                                  
       end
       
       SM_CPU_RESET    : begin                   
 //YHY        if (pwron_critical_fail_en) begin    
     if (pchdsw_critical_fail_en) begin    
           state_ns = SM_CRITICAL_FAIL;       
           po_failure_detected_set = 1'b1;    
         end                                  
 //YHY        else if (pwrup_state_trans_en) begin 
      else if (pchdsw_state_trans_en) begin 
 //yhy          state_ns = SM_EN_VCCIN;            
         state_ns = SM_WAIT_POWEROK;            

         end                                  
       end		                        



    SM_WAIT_POWEROK : begin
      if (wait_steady_pwrok_fail_en) begin
        state_ns = SM_CRITICAL_FAIL;
        po_failure_detected_set = 1'b1;
      end
      else if (pon_65ms_watchdog_timeout && pgd_so_far) begin
        state_ns = SM_STEADY_PWROK;
         POWER_DOWN_FLAG_clr = 1'b1;

      end
    end

      SM_STEADY_PWROK : begin
  //YHY      if (rt_critical_fail_store && !pgood_rst_mask) begin
        if (rt_critical_fail_store ) begin
  
          state_ns = SM_CRITICAL_FAIL;
          rt_failure_detected_set = 1'b1;
        end

    
    
    //YHY        else if (rt_normal_pwr_down) begin
    //YHY    else if (rt_normal_pwr_down |  ( ~pch_pwrbtn_n)) begin  //����ɾ��|  ( ~pch_pwrbtn_n)����ǰΪ�˷��㲻ֱ�Ӱ�3s�µ�
        	else if (rt_normal_pwr_down ) begin  //����ɾ��|  ( ~pch_pwrbtn_n)����ǰΪ�˷��㲻ֱ�Ӱ�3s�µ�

//YHY         else if (rt_normal_pwr_down |  ( ~pch_pwrbtn_n) | ( ~cpu_power_off)|( ~pch_sys_reset_n)) begin  //pch_pwrbtn_n�Ƕ̰������������µ�
      	
           pch_thermtrip_FLAG_SET = 1'b1;
       	
//yhy          state_ns = (cpu_mcp_en) ? SM_DISABLE_VMCP : SM_DISABLE_VCCSA;
        state_ns = SM_CRITICAL_FAIL;
        end

        else if (  ~cpu_power_off) begin
        state_ns = SM_CRITICAL_FAIL;
        CPU_OFF_FLAG_SET = 1'b1;

        end
        
        else if ( ~pch_sys_reset_n) begin
        state_ns = SM_CRITICAL_FAIL;
        REBOOT_FLAG_SET = 1'b1;

        end
       

      // Clear retry counter on clean powerup
      lim_recov_retry_clr = 1'b1;
    end
    
    
    
    
    
    
    
    
    
    

    SM_CRITICAL_FAIL : begin
//yhy      state_ns = (cpu_mcp_en) ? SM_DISABLE_VMCP : SM_DISABLE_VCCSA;
    state_ns = SM_DISABLE_VDD;
      assert_button_clr = 1'b1;
    end

//yhy    SM_DISABLE_VMCP : begin
//yhy      if (pdn_watchdog_timeout) begin
//yhy        state_ns = SM_DISABLE_1V0;
//yhy      end
//yhy    end
//yhy
//yhy    SM_DISABLE_1V0 : begin
//yhy      if (pdn_watchdog_timeout) begin
//yhy        state_ns = SM_DISABLE_VCCSA;
//yhy      end
//yhy    end
//yhy
//yhy    SM_DISABLE_VCCSA : begin
//yhy      if (pdn_watchdog_timeout) begin
//yhy        state_ns = SM_DISABLE_VCCIN;
//yhy      end
//yhy    end
/*
    SM_DISABLE_VCCIN : begin
      if (disable_intel_vccin_timeout) begin
        state_ns = SM_DISABLE_VCCIO;
      end
    end
*/
/***********************************************************************************************/
//yhy     SM_DISABLE_VCCIN : begin
//yhy       if (disable_intel_vccin_timeout) begin
//yhy //YHY        state_ns = SM_DISABLE_VCCANA;
//yhy       end
//yhy     end
	
//yhy     SM_DISABLE_VCCANA : begin
//yhy       if (pdn_watchdog_timeout) begin
//yhy //yhy        state_ns = SM_DISABLE_VCC1V8;
//yhy       end
//yhy     end	

          SM_DISABLE_VDD : begin              
            if (pdn_watchdog_timeout) begin            
            state_ns = SM_DISABLE_P0V8;          
            end                                  
          end	                                  

//yhy    SM_DISABLE_VCC1V8 : begin
//yhy      if (pdn_watchdog_timeout) begin
//yhy       state_ns = SM_DISABLE_VCCIO;
//yhy      end  
//yhy    end	

      SM_DISABLE_P0V8 : begin                  
        if (pdn_watchdog_timeout) begin          
          state_ns = SM_DISABLE_VP;              
        end                                      
      end	                                    

/***********************************************************************************************/
//yhy     SM_DISABLE_VCCIO : begin
//yhy       if (pdn_watchdog_timeout) begin
//yhy //yhy        state_ns = SM_DISABLE_P0V6_VTT;
//yhy         state_ns = SM_DISABLE_P2V5_VPP;
//yhy       end
//yhy     end

    SM_DISABLE_VP : begin
      if (pdn_watchdog_timeout) begin
//yhy        state_ns = SM_DISABLE_P0V6_VTT;
        state_ns = SM_DISABLE_P2V5_VPP;
      end
    end


//yhy     SM_DISABLE_P0V6_VTT : begin
//yhy       if (pdn_watchdog_timeout) begin
//yhy //yhy        state_ns = (no_vppen) ? SM_DISABLE_3V3 : SM_DISABLE_P2V5_VPP;
//yhy         state_ns =  SM_DISABLE_P2V5_VPP;
//yhy       end
//yhy     end

    SM_DISABLE_P2V5_VPP : begin
      if (pdn_watchdog_timeout) begin
//yhy        state_ns = SM_DISABLE_3V3;
      state_ns = SM_DISABLE_P1V8;
      end
    end    
    
  SM_DISABLE_P1V8 : begin
      if (pdn_watchdog_timeout) begin
        state_ns = SM_DISABLE_3V3;
      end
    end       
    
    

    SM_DISABLE_3V3 : begin
      if (disable_3v3_timeout) begin
        state_ns = SM_DISABLE_5V;
      end
    end

    SM_DISABLE_5V : begin
      // - BL, last group to turn off so proceed to disable S5 devices if any
      //   power fault is detected. Otherwise, this is normal shutdown so go
      //   to standby.
      // - Non-BL, not the last group yet so proceed to next pwrdn state.
      if (pdn_watchdog_timeout)
        state_ns = SM_DISABLE_MAIN_EFUSE;
    end

    SM_DISABLE_MAIN_EFUSE : begin
      // - BL, last one to turn off due to power fault or was forced off.
      // - Non-BL, part of pwrdn flow so go to turning off of telemetry rails.
      if (pdn_watchdog_timeout) begin
        state_ns = SM_DISABLE_TELEM;
      end

      off_state = 1'b0;
    end

    SM_DISABLE_TELEM : begin
      // - BT, last pwrdn stage. Go to DISABLE_S5_DEVICES if there's any power fault.
      // - Non-BT, not last group yet.
      if (pdn_watchdog_timeout) begin
        state_ns = SM_DISABLE_PS_ON;
      end
    end

    SM_DISABLE_PS_ON : begin
      // - BL/BT, not used
      // - Non-BL/BT, disable PSU. This is the last stage. Proceed to disable S5
      //   devices if there are any power fault
      if (pdn_watchdog_timeout)
        state_ns = (any_pwr_fault_det) ? SM_DISABLE_S5_DEVICES : SM_OFF_STANDBY;
//YHY        state_ns = SM_HALT_POWER_CYCLE;
    end

    SM_DISABLE_S5_DEVICES : begin
      // - If no fault, go back to SM_OFF_STANDBY. Otherwise,
      // - BL, proceed to disable main efuse if e-fuse is forced off or we have
      //   limited/non-recoverable fault.
      // - For anything else, go to SM_HALT_POWER_CYCLE
      if (pdn_watchdog_timeout) begin
      	if (any_pwr_fault_det)
          state_ns = SM_HALT_POWER_CYCLE;
        else
          state_ns = SM_OFF_STANDBY;
      end
    end

    SM_HALT_POWER_CYCLE : begin
      // - We have a power fault waiting for user interaction. Recovery is based
      //   on what the user does. We'll force PCH to transition to S5 here in
      //   this state before before honoring any recovery.
      // - For non-BT, the following are the recovery mechanism.
      //   - Virtual or physical button recovery on any of the following:
      //     - allow_recovery = 1 (any fault is recoverable)
      //     - recoverable fault
      //   - Physical button only recovery on any of the following:
      //     - allow_recovery = 0 AND any_lim_recov_fault
      //   - For either recovery mechanism, a max of LIM_RECOV_RETRY_ATTEMP
      //     recovery attemp is allowed. Counter is incremented for every visit
      //     to this state and cleared on successful power-on. No further
      //     recovery possible if max count is reached.
      // - For BT, getting to this state means a recovery was forced from
      //   SM_SYSTEM_LOCKOUT state. A virtual or physical button press will exit
      //   this state.
      //   - No recovery possible with any_non_recov_fault set.
      if (ready_for_recov && !any_non_recov_fault) begin
          if (!lim_recov_retry_max)
            if ((assert_power_button && (allow_recovery || ~any_lim_recov_fault)) ||         //yhy  any_lim_recov_fault�κ�һ·��Դ���ϵ�ʱ��Ϊ1��������ϵ�ʱ��Ϊ0
                (assert_physical_button && !allow_recovery && any_lim_recov_fault)) begin    //yhy  .allow_recovery         (1'b0)   
              state_ns = SM_AUX_FAIL_RECOVERY;
              lim_recov_retry_incr = 1'b1;
            end
      end

      // Set a flag that indicates we're ready for recovery. This flag is
      // to allow system recovery when user first do a virtual power button
      // (no recovery yet) followed by physical button press (recovery expected).
      // In this case, the virtual power button press will cause PCH to switch to
      // S0 which de-asserts pch_slp4_n. Without this latched flag, subsequent
      // physical power button press won't recover since pch_slp4_n is not
      // asserted anymore.
//YHY      ready_for_recov_set = pf_on_wait_complete & ~pch_slp4_n;
      ready_for_recov_set = pf_on_wait_complete ;
      
      // This is an offstate
      off_state = 1'b1;
    end

    SM_AUX_FAIL_RECOVERY : begin
      // Clear faults
      stby_failure_detected_clr = 1'b1;
      po_failure_detected_clr   = 1'b1;
      rt_failure_detected_clr   = 1'b1;
      ready_for_recov_clr       = 1'b1;
      fault_clear_ns            = 1'b1;
      off_state = 1'b1;

      state_ns = SM_EN_P3V3_VCC;
    end

    default : begin
      state_ns = SM_RESET_STATE;
    end
  endcase
end

endmodule


