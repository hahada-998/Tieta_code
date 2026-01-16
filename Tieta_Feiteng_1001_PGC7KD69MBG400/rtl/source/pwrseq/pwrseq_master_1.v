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

// FSM3
always @(posedge clk or posedge reset) begin


end 

endmodule