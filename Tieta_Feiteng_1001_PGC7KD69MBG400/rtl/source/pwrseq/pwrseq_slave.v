
//=================================================================================================
// Copyright(c) 2017, New H3C Technologies Co., Ltd, All right reserved
// Filename   : pwrseq_slave.v
// Project    : H3C common code
// Author     : QIURONGLIN
// Date       : 2017-07-18
// Email      : qiu.ronglin@h3c.com
// Company    : New H3C Technologies Co., Ltd
// Description: This module handles power enablement and fault detection. It relies on
//   pwrseq_master module for much of the control here.
//   SHARED_P5V_STBY_HPMOS: When set, platform uses P5V_STBY as the HPMOS source. Sequencer ensures
//     that P5V_STBY is up when HPMOS enable is turned on and any rails that depend on HPMOS.
//     Default: 1'b0
//   S5DEV_STUCKON_FAULT_CHK: When set, enable stuckon fault check for s5dev where PGD is asserted
//     while EN is de-asserted.
//     Default: 1'b0
//   BOUND_SYS_PWROK: If set, wait for delay of 25ms once in SM_STEADY_OK before asserting 
//     pch_sys_pwrok instead of waiting on gmt_sysrst_n. If cleared, wait for de-assertion of 
//     gmt_sysrst_n before asserting pch_sys_pwrok. This parameter allows bounding the
//     pch_sys_pwrok assertion to bound PCH's PROCPWRGD to PLTRST# delay.
//     Default: 1'b1
//   NUM_CPU: Number of CPUs to support
//     Default: 2
//   NUM_OPT_AUX: Number of additional aux rails to support and check. If this is a not zero, the
//     opt_aux_pgd rails are monitored when opt_check_en is enabled. Any fault detected will be 
//     binned to any_aux_vrm_fault. If set to 0, the check is disabled. Note there is no separate
//     parameter to enable checking.
//     Default: 0
//   NUM_S5DEV: Number of S5 devices (ALOM/BLOM/Tbird mezz) to support. A value of 0 disables support.
//     Default: 0
//   NUM_SAS: Number of SAS device (AROC/BROC) to support. A value of 0 disables
//     support.
//     Default: 0
//   NUM_HD_BP: Number of HDD backplane to support. A value of 0 disables support.
//     Default: 0
//   NUM_M2_BP
//   - Number of M2 backplane to support. A value of 0 disables support.
//     Default: 0
//   NUM_RISER: Number of riser card to support. A value of 0 disables support.
//     Default: 0
//   NUM_MEZZ: Number of c-class blade mezz card to support. A value of 0 disables support.
//     Default: 0
//   HPMOS_TYPE: Used only when BT_MODE is set. When clear, the corresponding HPMOS type is VRD.
//     When set, it's pass-thru fet which will depend on HPMOS_OWNER. This is NUM_CPU wide 
//     parameter with each bit corresponding to each CPU.
//     Default: 2'b10 (CPU1 = FET, CPU0 = VRD)
//   HPMOS_OWNER: Used only when BT_MODE is set. Specifies which HPMOS source is used for the 
//     corresponding CPU. Each corresponds to 2 bits in this array. For example, 8'b01_00_00_00
//     means CPU0/CPU1/CPU2's source is CPU0.  CPU3's source is CPU1.
//     Default: 4'b00_00 (CPU0/CPU1 source is CPU0)
//   RECOV_FAULT_MASK: Determines which fault is recoverable. Search for fault_vec_mapping below
//     for signal mapping.
//     Default: 40'bx
//   LIM_RECOV_FAULT_MASK: Determines which fault has limited recovery via 3-strike.
//     Default: 40'bx
//   NON_RECOV_FAULT_MASK: Determines which fault has no recovery (needs aux power cycle).
//     Default: 40'bx
// History    :
//   Date      By          Revision  Change Description
//   20170718  QIURONGLIN  1.0       file created
//=================================================================================================

//`include "wpspo_g5_define.vh"
`include "rs35m2c16s_g5_define.vh"
module pwrseq_slave #(
  parameter SHARED_P5V_STBY_HPMOS       = 1'b0,
  parameter S5DEV_STUCKON_FAULT_CHK     = 1'b0,
  parameter BOUND_SYS_PWROK             = 1'b1,
  parameter NUM_CPU                     = 2,
  parameter NUM_OPT_AUX                 = 0,
  parameter NUM_S5DEV                   = 0,
  parameter NUM_SAS                     = 0,
  parameter NUM_HD_BP                   = 0,
  parameter NUM_M2_BP                   = 0,
  parameter NUM_RISER                   = 0,
//YHY  parameter NUM_MEZZ                    = 0,
//parameter   [NUM_CPU-1:0] HPMOS_TYPE  = 2'b10,
//parameter [2*NUM_CPU-1:0] HPMOS_OWNER = 4'b00_00,
  parameter FAULT_VEC_SIZE              = 40,
  // bit location guide for mask below                      3         3         2         1
  //                                                        9         1         3         5         7
  parameter [FAULT_VEC_SIZE-1:0] RECOV_FAULT_MASK     = 40'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111,
  parameter [FAULT_VEC_SIZE-1:0] LIM_RECOV_FAULT_MASK = 40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000,
  parameter [FAULT_VEC_SIZE-1:0] NON_RECOV_FAULT_MASK = 40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000) (

  input                    clk,                               // clock
  input                    reset,                             // reset
  input                    t1us,                              // 10ns pulse every 1us
  input                    t512us,                            // 10ns pulse every 0.5ms
  input                    t1ms,                              // 10ns pulse every 1ms
  input                    t2ms,                              // 10ns pulse every 2ms
  input                    t64ms,                             // 10ns pulse every 64ms
  input                    t1s,                               // 10ns pulse every 1s

  // Master sequencer interface
  output reg               pgd_so_far /* synthesis syn_allow_retiming = 0 */,  // current overall power status
  output reg               any_pwr_fault_det,                 // any type of power fault
  output                   any_aux_vrm_fault,                 // any aux VRM power fault
  output reg               any_recov_fault,                   // any recoverable fault
  output reg               any_lim_recov_fault,               // any limited recovery fault
  output reg               any_non_recov_fault,               // any non-recoverable fault
  input                    dc_on_wait_complete,               // from master module, for stuck-on fault check
  input                    rt_critical_fail_store,            // asserts when during runtime when critical failure detected
  input                    fault_clear,                       // clear fault flags
  input              [5:0] power_seq_sm,                      // current power sequencer state

//from Power Controller PG signal
  input                    front_bp_efuse_pg           ,
  input                    cpu1_vdd_core_pg            ,
  input                    cpu0_pll_p1v8_pg            ,
  input                    cpu0_vddq_pg                ,
  input                    cpu0_p1v8_pg                ,
  input                    cpu0_ddr_vdd_pg             ,
  input                    reat_bp_efuse_pg            ,
  input                    cpu0_pcie_p1v8_pg           ,
  input                    cpu1_pcie_p1v8_pg           ,
  input                    cpu0_pcie_p0v9_pg           ,
  input                    cpu1_pcie_p0v9_pg           ,
  input                    fan_efuse_pg                ,
  input                    cpu1_ddr_vdd_pg             ,
  input                    cpu0_vdd_core_pg            ,
  input                    cpu1_vddq_pg                ,
  input                    cpu1_p1v8_pg                ,
  input                    cpu1_pll_p1v8_pg            ,
  input                    p5v_stby_pgd                ,
  input                    dimm_efuse_pg               ,
  input                    p5v_pgd                     ,
  input                    pgd_main_efuse              ,//Main-efuse pgood
  input                    pgd_p12v                    ,//12V main status, in additon main efuse (set to 1'b1 if not used)
  input                    pgd_p12v_stby_droop         ,//PSU 12V main power status
  input                    p3v3_stby_bp_pg             ,
  input  				   p3v3_stby_pg                ,
// Brownout status - set to 1'b0 if no PSU
  input                    brownout_warning            ,//brownout warning

//Fault Detect Signal
  output reg         [5:0]  pwrseq_sm_fault_det			,//SM state where fault occurred
  output					cpu0_p1v8_fault_det			,
  output					cpu1_p1v8_fault_det			,
  output					cpu0_pll_p1v8_fault_det		,
  output					cpu1_pll_p1v8_fault_det		,
  output					cpu0_ddr_vdd_fault_det		,
  output					cpu1_ddr_vdd_fault_det		,
  output					cpu0_pcie_p0v9_fault_det	,
  output					cpu1_pcie_p0v9_fault_det	,
  output					cpu0_pcie_p1v8_fault_det	,
  output					cpu1_pcie_p1v8_fault_det	,
  output					cpu0_vddq_fault_det			,
  output					cpu1_vddq_fault_det			,
  output					cpu0_vdd_core_fault_det		,
  output					cpu1_vdd_core_fault_det		,
  output					p5v_stby_fault_det			,
  output					p5v_fault_det			    ,
  output                    p12v_front_bp_efuse_fault_det,
  output                    p12v_reat_bp_efuse_fault_det,
  output                    p12v_fan_efuse_fault_det    ,
  output                    p12v_dimm_efuse_fault_det   ,
  output                    p12v_fault_det              ,// 12V main fault
  output                    main_efuse_fault_det        ,// main e-fuse fault
  output                    p12v_stby_droop_fault_det   ,// p12v_stby_droop fault
  output                    p3v3_stby_bp_fault_det      ,
  output                    p3v3_stby_fault_det         ,
  output [NUM_CPU-1:0]      cpu_thermtrip_fault_det     ,
//to Power Controller Enable Pin
  output                   pvcc_hpmos_cpu_en_r     ,
  output                   cpu0_p1v8_en_r          ,
  output                   cpu1_p1v8_en_r          ,
  output                   cpu0_pll_p1v8_en_r      ,
  output                   cpu1_pll_p1v8_en_r      ,
  output                   cpu0_ddr_vdd_en_r       ,
  output                   cpu1_ddr_vdd_en_r       ,
  output                   cpu0_pcie_p0v9_en_r     ,
  output                   cpu1_pcie_p0v9_en_r     ,
  output                   cpu0_pcie_p1v8_en_r     ,
  output                   cpu1_pcie_p1v8_en_r     ,
  output                   cpu0_vddq_en_r          ,
  output                   cpu1_vddq_en_r          ,
  output                   cpu0_vdd_core_en_r      ,
  output                   cpu1_vdd_core_en_r      ,
  output                   p5v_stby_en_r           ,
  output                   p5v_en_r                ,
  output                   pal_main_efuse_en       ,// main e-fuse enable
  output                   power_supply_on         ,
  output                   p12v_bp_front_en        ,
  output                   p12v_bp_rear_en         ,
// HDD backplane
  input  [(NUM_HD_BP ? NUM_HD_BP:1)-1:0] hd_bp_prsnt_n,             // drive backplane presence
  input  [(NUM_HD_BP ? NUM_HD_BP:1)-1:0] hd_bp_pgd,                 // drive backplane pgood
  output [(NUM_HD_BP ? NUM_HD_BP:1)-1:0] hd_bp_fault_det,           // drive backplane power fault  
// Riser card
  input  [(NUM_RISER ? NUM_RISER:1)-1:0] riser_prsnt_n,             // riser card presence
  input  [(NUM_RISER ? NUM_RISER:1)-1:0] riser_pgd,                 // riser card pgood
  output [(NUM_RISER ? NUM_RISER:1)-1:0] riser_fault_det,           // riser card fault
  output [(NUM_RISER ? NUM_RISER:1)-1:0] pal_riser_en,              // riser card enable
//to CPU
  output                   cpu_por_n               ,               
  output             reg   usb_ponrst_r_n          ,
  output                   pex_reset_r_n           ,
  output             reg   ocp_aux_en              ,
  output             reg   ocp_main_en             ,
  output             reg   cpu_bios_en	           ,
  // Misc
//YHY  input      [NUM_CPU-1:0] cpu_prsnt_n,                       // cpu presence
//input                    gmt_sysrst_n,                      // iLO initiated system reset
  input                    aux_pcycle              ,// GPO to initiate AUX e-fuse power cycle
//input                    aux_efuse_force_off, // GPO to force AUX e-fuse to turn off
//input                    telem_aux_en,                  // VRM aux power enable
//input                    xreg_aux_video_en,                 // AUX video enable
//input                    xreg_vrd_flash_mode,               // Enable VRD logic supply
//input                    vwire_usb_pe,                      // iLO USB power enable
//input                    pwm_ctrl_vdd_force_on,             // debug2_sw8 or maint_sw12 when PGD_BMC fault
//input                    done_booting_delayed,              // from dual_boot module (if not used, set to 1'b1)
//YHY  input               pgood_rst_mask,                    // from adr module
  input                    keep_alive_on_fault,               // when asserted, a fault will not mask the corresponding enable signal (default to 1'b0, debug only)
//input                    ti_vrd_seq,                        // when set, enable TI specific VRD sequence
//YHY  input      [NUM_CPU-1:0] cpu_mcp_en,                        // when set, CPU is MCP (fabric) enabled
//yhy  input                    no_vppen,                          // set to 1'b1 if platform does not have an explicity EN for VPP rails
// Therm status
  input      [NUM_CPU-1:0] i_cpu_thermtrip,  // CPU THERMTRIP indicator
  output     [NUM_CPU-1:0] o_cpu_thermtrip_fault,
  output reg               reached_sm_wait_powerok,           // SM reached SM_WAIT_POWEROK
//output reg               reg_ocp_en,   
      
  // PCH nets
//YHY  input                    pch_slpsus_n,                      // PCH SLPSUS# signal
//YHY  input                    pch_cpupwrok,                      // PCH CPUPWROK signal
//YHY  input                    pch_pltrst_n,                      // PCH PLTRST# output
//YHY  output                   pch_dsw_pwrok,                     // PCH DSW_PWPROK signal
//YHY  output                   pch_rsmrst_n,                      // PCH RSMRST#
//YHY  output                   pch_pwrok,                         // PCH PWROK
//YHY  output                   pch_sys_pwrok,                     // PCH SYS_PWROK

  // DRAM_PWR_OK to CPU
  //output reg               pal_drampwrgd,                     // Drives DRAM_PWR_OK to CPU

  // Aux Efuse control
//output                   pal_ok_fb,                         // Aux e-fuse FPGA/CPLD OK feedback
  output                   pal_efuse_pcycle         // Aux e-fuse cycle

  // OCP, clock, discharge
//input              [1:0] ocp_shtdn,                         // OCP indicator (OR of VR_P12Vx_SHTDN nets)
//YHY  input                    interlock_broken,                  // interlock broken
//output                   pal_clk_en_n,                      // clock buffer
  
  //from Power Controller PG signal          
 
);

`include "pwrseq_define.vh"

genvar i;

wire st_reset_state             ;
wire st_off_standby             ;
wire st_steady_pwrok            ;
wire st_halt_power_cycle        ;
wire st_aux_fail_recovery       ;
wire st_critical_fail           ;
wire st_en_5v;
wire st_disable_main_efuse;
wire p12v_main_fault;
// Aux rails
wire opt_aux_fault;

wire any_pex_fault_det;
// Riser
wire reg_riser_chk_en;
wire riser_pgd_so_far;
wire riser_mod_fault;

reg reg_pvcc_hpmos_cpu_en_r		;
reg reg_cpu0_p1v8_en_r			;
reg reg_cpu1_p1v8_en_r          ; 
reg reg_cpu0_pll_p1v8_en_r		;
reg reg_cpu1_pll_p1v8_en_r		;
reg reg_cpu0_ddr_vdd_en_r		;
reg reg_cpu1_ddr_vdd_en_r		;
reg reg_cpu0_pcie_p0v9_en_r	    ;
reg reg_cpu1_pcie_p0v9_en_r		;
reg reg_cpu0_pcie_p1v8_en_r		;
reg reg_cpu1_pcie_p1v8_en_r     ;
reg reg_cpu0_vddq_en_r	        ;
reg reg_cpu1_vddq_en_r	        ;
reg reg_cpu0_vdd_core_en_r		;
reg reg_cpu1_vdd_core_en_r		;
reg reg_p5v_stby_en_r		    ;
reg reg_p5v_en_r		        ;
reg reg_power_supply_on	        ;
reg reg_cpu_por_n	            ;
reg reg_pex_reset_r_n           ;
reg reg_p12v_en                 ;
// main e-fuse
reg  reg_main_efuse_en;

reg ok_to_reset_aux             ;


assign pvcc_hpmos_cpu_en_r  =  reg_pvcc_hpmos_cpu_en_r;
assign cpu0_p1v8_en_r	    =  reg_cpu0_p1v8_en_r      & ( ~cpu0_p1v8_fault_det      | keep_alive_on_fault );
assign cpu1_p1v8_en_r	    =  reg_cpu1_p1v8_en_r      & ( ~cpu1_p1v8_fault_det      | keep_alive_on_fault );
assign cpu0_pll_p1v8_en_r	=  reg_cpu0_pll_p1v8_en_r  & ( ~cpu0_pll_p1v8_fault_det  | keep_alive_on_fault );
assign cpu1_pll_p1v8_en_r	=  reg_cpu1_pll_p1v8_en_r  & ( ~cpu1_pll_p1v8_fault_det  | keep_alive_on_fault );
assign cpu0_ddr_vdd_en_r	=  reg_cpu0_ddr_vdd_en_r   & ( ~cpu0_ddr_vdd_fault_det   | keep_alive_on_fault );
assign cpu1_ddr_vdd_en_r	=  reg_cpu1_ddr_vdd_en_r   & ( ~cpu1_ddr_vdd_fault_det   | keep_alive_on_fault );
assign cpu0_pcie_p0v9_en_r	=  reg_cpu0_pcie_p0v9_en_r & ( ~cpu0_pcie_p0v9_fault_det | keep_alive_on_fault );
assign cpu1_pcie_p0v9_en_r	=  reg_cpu1_pcie_p0v9_en_r & ( ~cpu1_pcie_p0v9_fault_det | keep_alive_on_fault );
assign cpu0_pcie_p1v8_en_r	=  reg_cpu0_pcie_p1v8_en_r & ( ~cpu0_pcie_p1v8_fault_det | keep_alive_on_fault );
assign cpu1_pcie_p1v8_en_r	=  reg_cpu1_pcie_p1v8_en_r & ( ~cpu1_pcie_p1v8_fault_det | keep_alive_on_fault );
assign cpu0_vddq_en_r	    =  reg_cpu0_vddq_en_r      & ( ~cpu0_vddq_fault_det      | keep_alive_on_fault );
assign cpu1_vddq_en_r	    =  reg_cpu1_vddq_en_r      & ( ~cpu1_vddq_fault_det      | keep_alive_on_fault );
assign cpu0_vdd_core_en_r	=  reg_cpu0_vdd_core_en_r  & ( ~cpu0_vdd_core_fault_det  | keep_alive_on_fault );
assign cpu1_vdd_core_en_r	=  reg_cpu1_vdd_core_en_r  & ( ~cpu1_vdd_core_fault_det  | keep_alive_on_fault );
assign p5v_stby_en_r	    =  reg_p5v_stby_en_r       & ( ~p5v_stby_fault_det       | keep_alive_on_fault );
assign p5v_en_r          	=  reg_p5v_en_r            & ( ~p5v_fault_det            | keep_alive_on_fault );
assign power_supply_on	    =  reg_power_supply_on     ;     
assign cpu_por_n	        =  reg_cpu_por_n           ;
assign pex_reset_r_n	    =  reg_pex_reset_r_n       ;
assign p12v_bp_front_en     =  reg_p12v_en             & ( ~p12v_front_bp_efuse_fault_det  | keep_alive_on_fault);
assign p12v_bp_rear_en      =  reg_p12v_en             & ( ~p12v_reat_bp_efuse_fault_det   | keep_alive_on_fault);



//------------------------------------------------------------------------------
// Reset and SM states
// - The st_* stuff are just convenience variable that can be used throughout.
//------------------------------------------------------------------------------
assign st_reset_state       = (power_seq_sm == SM_RESET_STATE       );
assign st_off_standby       = (power_seq_sm == SM_OFF_STANDBY       );
assign st_steady_pwrok      = (power_seq_sm == SM_STEADY_PWROK      );
assign st_critical_fail     = (power_seq_sm == SM_CRITICAL_FAIL     );
assign st_halt_power_cycle  = (power_seq_sm == SM_HALT_POWER_CYCLE  );
assign st_aux_fail_recovery = (power_seq_sm == SM_AUX_FAIL_RECOVERY );
assign st_en_5v             = (power_seq_sm == SM_EN_5V             );
assign st_disable_main_efuse= (power_seq_sm == SM_DISABLE_MAIN_EFUSE);
// Shortcut to select whether the next state is VTT or VPP
//YHY assign vpp_or_vtt_next = (no_vppen) ? st_en_p0v6_vtt : st_en_p2v5_vpp;

//------------------------------------------------------------------------------
// Slave VRM enable/disable registers
// - These registers do not control the VRMs directly. These registers indicate
//   that a VRM has an opportunity to turn on. Additional combinational terms
//   are required to protect the system from VRM faults and ensures that proper
//   voltage sequencing is maintained.
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
    if (reset) begin
        reached_sm_wait_powerok    <= 1'b0; 
        reg_pvcc_hpmos_cpu_en_r    <= 1'b0;
        reg_cpu0_p1v8_en_r         <= 1'b0;
        reg_cpu1_p1v8_en_r         <= 1'b0;
        reg_cpu0_pll_p1v8_en_r     <= 1'b0;
        reg_cpu1_pll_p1v8_en_r     <= 1'b0;
        reg_cpu0_ddr_vdd_en_r      <= 1'b0;
        reg_cpu1_ddr_vdd_en_r      <= 1'b0;
        reg_cpu0_pcie_p0v9_en_r    <= 1'b0;
        reg_cpu1_pcie_p0v9_en_r    <= 1'b0;
        reg_cpu0_pcie_p1v8_en_r    <= 1'b0;
        reg_cpu1_pcie_p1v8_en_r    <= 1'b0;
        reg_cpu0_vddq_en_r         <= 1'b0;
        reg_cpu1_vddq_en_r         <= 1'b0;
        reg_cpu0_vdd_core_en_r     <= 1'b0;
        reg_cpu1_vdd_core_en_r     <= 1'b0;
        reg_p5v_stby_en_r          <= 1'b0;   
        reg_p5v_en_r               <= 1'b0;   
        reg_power_supply_on        <= 1'b0;
	      reg_cpu_por_n              <= 1'b0;      
        usb_ponrst_r_n             <= 1'b0;
	      reg_pex_reset_r_n          <= 1'b0;
	      cpu_bios_en                <= 1'b0;
	      reg_main_efuse_en          <= 1'b0;
	      reg_p12v_en                <= 1'b0; 
    end
  else if (t1us) begin
    case (power_seq_sm)
    SM_RESET_STATE : begin
    reached_sm_wait_powerok    <= 1'b0; 
    reg_pvcc_hpmos_cpu_en_r    <= 1'b0;
    reg_cpu0_p1v8_en_r         <= 1'b0;
    reg_cpu1_p1v8_en_r         <= 1'b0;
    reg_cpu0_pll_p1v8_en_r     <= 1'b0;
    reg_cpu1_pll_p1v8_en_r     <= 1'b0;
    reg_cpu0_ddr_vdd_en_r      <= 1'b0;
    reg_cpu1_ddr_vdd_en_r      <= 1'b0;
    reg_cpu0_pcie_p0v9_en_r    <= 1'b0;
    reg_cpu1_pcie_p0v9_en_r    <= 1'b0;
    reg_cpu0_pcie_p1v8_en_r    <= 1'b0;
    reg_cpu1_pcie_p1v8_en_r    <= 1'b0;
    reg_cpu0_vddq_en_r         <= 1'b0;
    reg_cpu1_vddq_en_r         <= 1'b0;
    reg_cpu0_vdd_core_en_r     <= 1'b0;
    reg_cpu1_vdd_core_en_r     <= 1'b0;
    reg_p5v_stby_en_r          <= 1'b0;   
    reg_p5v_en_r               <= 1'b0;   
    reg_power_supply_on        <= 1'b0;
	reg_cpu_por_n              <= 1'b0;
	usb_ponrst_r_n             <= 1'b0;
	reg_pex_reset_r_n          <= 1'b0;
	ocp_aux_en                 <= 1'b0;
	ocp_main_en                <= 1'b0;
	cpu_bios_en                <= 1'b0;
	reg_main_efuse_en          <= 1'b0;
	reg_p12v_en                <= 1'b0;
	
      end

      SM_EN_P3V3_VCC : begin
        
      end
 
      SM_OFF_STANDBY : begin
       reg_p5v_stby_en_r           <= 1'b1;
	   ocp_aux_en                  <= 1'b1;
	   cpu_bios_en                 <= 1'b1;
	   reg_p12v_en                 <= 1'b0;
      end

      SM_PS_ON : begin
        
      end

      SM_EN_5V_STBY: begin
            
      end


      SM_EN_TELEM : begin
        // - Non-BL, enable PWM_CTRL_VDD and PVCC_HPMOS
        // - BL, enabled later in SM_EN_3V3
        reg_pvcc_hpmos_cpu_en_r    <= 1'b1;
      end

      SM_EN_MAIN_EFUSE : begin
        reg_power_supply_on        <= 1'b1;
		ocp_main_en                <= 1'b1;
		reg_main_efuse_en          <= 1'b1;
		reg_p12v_en                <= 1'b1;
		
      end

      SM_EN_5V : begin
        reg_p5v_en_r <= 1'b1;
        
      end

      SM_EN_3V3 : begin
        cpu_bios_en                <= 1'b0;
        //reg_cpu0_pll_p1v8_en_r   <= 1'b1;//20240112 d00412
        //reg_cpu1_pll_p1v8_en_r   <= 1'b1;//20240112 d00412
	  end


      SM_EN_P1V8 : begin
        reg_cpu0_p1v8_en_r         <= 1'b1;
        reg_cpu1_p1v8_en_r         <= 1'b1;
        reg_cpu0_pll_p1v8_en_r     <= 1'b1;//20240112 d00412
        reg_cpu1_pll_p1v8_en_r     <= 1'b1;//20240112 d00412
      end

      SM_EN_P2V5_VPP : begin
        reg_cpu0_ddr_vdd_en_r      <= 1'b1;
        reg_cpu1_ddr_vdd_en_r      <= 1'b1;
		//reg_cpu0_vddq_en_r       <= 1'b1;//20240112 d00412
        //reg_cpu1_vddq_en_r       <= 1'b1;//20240112 d00412
        cpu_bios_en                <= 1'b1;
      end

//YHY      SM_EN_P0V6_VTT : begin
//YHY        reg_pvddq_en      <= 1'b1;
//YHY        reg_clk_en        <= 1'b1;  // for no_vppen case
//YHY        reg_hd_bp_chk_en  <= 1'b1;  // for no_vppen case
//YHY      end

//yhy        SM_EN_VCCIO : begin
//yhy          reg_pvccio_en <= 1'b1;
//yhy  //YHY        reg_mezz_en   <= 1'b1;
//yhy        end

      SM_EN_VP : begin
        
//YHY        reg_mezz_en   <= 1'b1;
      end
      
/*******************************************************************************/
//pwr
//yhy      SM_EN_VCC1V8 : begin
//yhy        reg_pvcc1v8_en <= 1'b1;
//yhy      end

      SM_EN_P0V8: begin
        reg_cpu0_pcie_p0v9_en_r    <= 1'b1;
        reg_cpu1_pcie_p0v9_en_r    <= 1'b1;
        reg_cpu0_pcie_p1v8_en_r    <= 1'b1;
        reg_cpu1_pcie_p1v8_en_r    <= 1'b1;
      
	  end
                
//YHY      SM_EN_VCCANA : begin
//YHY        reg_pvccana_en <= 1'b1;
//YHY      end
     SM_EN_VDD : begin          
       reg_cpu0_vddq_en_r         <= 1'b1;//20240112 d00412
       reg_cpu1_vddq_en_r         <= 1'b1;//20240112 d00412
       reg_cpu0_vdd_core_en_r     <= 1'b1;
       reg_cpu1_vdd_core_en_r     <= 1'b1;
          
     end  
         
     PEX_RESET : begin          
       reg_pex_reset_r_n          <= 1'b1; 
     end 
     
     SM_CPU_RESET : begin          
        reg_cpu_por_n             <= 1'b1;
		usb_ponrst_r_n            <= 1'b1;
        
     end      
           
      SM_WAIT_POWEROK : begin
        reached_sm_wait_powerok   <= 1'b1;     
        
      end

      SM_CRITICAL_FAIL : begin
      	reg_main_efuse_en         <= 1'b0;       
      end
	  
       SM_DISABLE_VDD : begin
       reg_cpu0_vddq_en_r         <= 1'b0;//20240112 d00412
       reg_cpu1_vddq_en_r         <= 1'b0;//20240112 d00412
       reg_cpu0_vdd_core_en_r     <= 1'b0;
       reg_cpu1_vdd_core_en_r     <= 1'b0;
	   usb_ponrst_r_n             <= 1'b0;
	   reached_sm_wait_powerok    <= 1'b0;
	   reg_pex_reset_r_n          <= 1'b0;
	   ocp_main_en                <= 1'b0;
	   cpu_bios_en                <= 1'b0;
 
            end  
/***********************************************************************************************/

       SM_DISABLE_P0V8 : begin
        reg_cpu0_pcie_p0v9_en_r    <= 1'b0;
        reg_cpu1_pcie_p0v9_en_r    <= 1'b0;
        reg_cpu0_pcie_p1v8_en_r    <= 1'b0;
        reg_cpu1_pcie_p1v8_en_r    <= 1'b0;
             
            end         
                                 
//yhy  SM_DISABLE_VCCIO : begin
//yhy    reg_pvccio_en <= 1'b0;
//yhy    reg_mezz_en   <= 1'b0;
//yhy       end
            
       SM_DISABLE_VP : begin
        
//YHY    reg_mezz_en   <= 1'b0;
      end

//YHY  SM_DISABLE_P0V6_VTT : begin
//YHY     reg_pvddq_en      <= 1'b0;
//YHY     reg_clk_en        <= 1'b0;
//YHY     end

      SM_DISABLE_P2V5_VPP : begin
        // Not used if no_vppen is set
        reg_cpu0_ddr_vdd_en_r      <= 1'b0;
        reg_cpu1_ddr_vdd_en_r      <= 1'b0;
		//reg_cpu0_vddq_en_r       <= 1'b0;//20240112 d00412
        //reg_cpu1_vddq_en_r       <= 1'b0;//20240112 d00412

      end

      SM_DISABLE_P1V8 : begin
        // Not used if no_vppen is set
        reg_cpu0_p1v8_en_r         <= 1'b0;
        reg_cpu1_p1v8_en_r         <= 1'b0;
        reg_cpu0_pll_p1v8_en_r     <= 1'b0;//20240112 d00412
        reg_cpu1_pll_p1v8_en_r     <= 1'b0;//20240112 d00412
        
      end

      SM_DISABLE_3V3 : begin
        //reg_cpu0_pll_p1v8_en_r   <= 1'b0;//20240112 d00412
        //reg_cpu1_pll_p1v8_en_r   <= 1'b0;//20240112 d00412
      end

      SM_DISABLE_5V : begin
        reg_p5v_en_r <= 1'b0;
      end

      SM_DISABLE_MAIN_EFUSE : begin
       reg_power_supply_on <= 1'b0;
	   reg_main_efuse_en   <= 1'b0;
	   reg_p12v_en         <= 1'b0;

      end

      SM_DISABLE_TELEM : begin
        reg_pvcc_hpmos_cpu_en_r    <= 1'b0;
        
      end

      SM_DISABLE_PS_ON : begin
       cpu_bios_en                 <= 1'b1; 
      end

      SM_AUX_FAIL_RECOVERY : begin
          //FIXME: Want this low for poweron board bringup. Revert back to 1'b1 for DP1.
      end

/*  
  default : begin
	  reached_sm_wait_powerok    <= 1'b0; 
    reg_pvcc_hpmos_cpu_en_r    <= 1'b0;
    reg_cpu0_p1v8_en_r         <= 1'b0;
    reg_cpu1_p1v8_en_r         <= 1'b0;
    reg_cpu0_pll_p1v8_en_r     <= 1'b0;
    reg_cpu1_pll_p1v8_en_r     <= 1'b0;
    reg_cpu0_ddr_vdd_en_r      <= 1'b0;
    reg_cpu1_ddr_vdd_en_r      <= 1'b0;
    reg_cpu0_pcie_p0v9_en_r    <= 1'b0;
    reg_cpu1_pcie_p0v9_en_r    <= 1'b0;
    reg_cpu0_pcie_p1v8_en_r    <= 1'b0;
    reg_cpu1_pcie_p1v8_en_r    <= 1'b0;
    reg_cpu0_vddq_en_r         <= 1'b0;
    reg_cpu1_vddq_en_r         <= 1'b0;
    reg_cpu0_vdd_core_en_r     <= 1'b0;
    reg_cpu1_vdd_core_en_r     <= 1'b0;
    reg_p5v_stby_en_r          <= 1'b0;   
    reg_p5v_en_r               <= 1'b0;   
    reg_power_supply_on        <= 1'b0;
	reg_cpu_por_n              <= 1'b0;
	  
	  end
*/	  
    endcase
  end
end


//------------------------------------------------------------------------------
// ok_to_reset_aux
// - Asserts when in state where AUX power can be cycled
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    ok_to_reset_aux <= 1'b0;
  else
    ok_to_reset_aux <= st_reset_state      |
                       st_off_standby      |
                       st_halt_power_cycle |
                       st_aux_fail_recovery;
end


//------------------------------------------------------------------------------
// VRM enable logic
// - Unless keep_alive_on_fault is set, a fault on a particular rail will disable
//   the corresponding EN signal immediately.
//------------------------------------------------------------------------------
// Main e-fuse
assign pal_main_efuse_en = reg_main_efuse_en & (~main_efuse_fault_det | keep_alive_on_fault);


//------------------------------------------------------------------------------
// Aux e-fuse control
//------------------------------------------------------------------------------
// Asserts when FPGA is alive. If not asserted within 375ms, AUX e-fuse turns off.
// For BL, qualify with pgd_aux_system (same as reset) to keep it up only if iLO
// rails are up.
assign pal_efuse_pcycle = aux_pcycle & ok_to_reset_aux;

//------------------------------------------------------------------------------
// Aux (P5V_STBY) fault detect
// - P5V_STBY can be enabled while system in standby so need to check if it
//   comes up. It takes time to ramp so we'll give it ~120ms to do it.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// P5V_STBY Fault detect 
//------------------------------------------------------------------------------
wire p5v_stby_en_r_check;

edge_delay #(.CNTR_NBITS(2)) p5v_stby_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p5v_stby_en_r),
  .delay_output  (p5v_stby_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p5v_stby_fault_detect_inst (
  .clk              (clk),
  .reset            (reset),
  .vrm_enable       (p5v_stby_en_r & p5v_stby_en_r_check),
  .vrm_pgood        (p5v_stby_pgd),
  .vrm_chklive_en   (p5v_stby_en_r_check),
  .vrm_chklive_dis  (~p5v_stby_en_r_check),
  .critical_fail    (st_critical_fail),
  .fault_clear      (fault_clear),
  .lock             (any_pwr_fault_det),
  .any_vrm_fault    (),
  .vrm_fault        (p5v_stby_fault_det)
);


//------------------------------------------------------------------------------
// P3V3_STBY Fault detect 
//------------------------------------------------------------------------------
wire   p3v3_stby_en;
wire   p3v3_stby_en_check;
assign p3v3_stby_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) p3v3_stby_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p3v3_stby_en),
  .delay_output  (p3v3_stby_en_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p3v3_stby_fault_detect_inst (
  .clk              (clk  ),							 //in
  .reset            (reset),							 //in
  .vrm_enable       (p3v3_stby_en && p3v3_stby_en_check),//in
  .vrm_pgood        (p3v3_stby_pg                      ),//in
  .vrm_chklive_en   (p3v3_stby_en_check                ),//in
  .vrm_chklive_dis  (~p3v3_stby_en_check               ),//in
  .critical_fail    (st_critical_fail                  ),//in
  .fault_clear      (fault_clear                       ),//in
  .lock             (any_pwr_fault_det                 ),//in
  .any_vrm_fault    (),								     //out
  .vrm_fault        (p3v3_stby_fault_det               ) //out
);


//------------------------------------------------------------------------------
// P3V3_STBY_BP Fault detect 
//------------------------------------------------------------------------------
wire   p3v3_stby_bp_en;
wire   p3v3_stby_bp_en_check;
assign p3v3_stby_bp_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) p3v3_stby_bp_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p3v3_stby_bp_en),
  .delay_output  (p3v3_stby_bp_en_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p3v3_stby_bp_fault_detect_inst (
  .clk              (clk  ),							 //in
  .reset            (reset),							 //in
  .vrm_enable       (p3v3_stby_bp_en && p3v3_stby_bp_en_check),//in
  .vrm_pgood        (p3v3_stby_bp_pg                         ),//in
  .vrm_chklive_en   (p3v3_stby_bp_en_check                   ),//in
  .vrm_chklive_dis  (~p3v3_stby_bp_en_check                  ),//in
  .critical_fail    (st_critical_fail                        ),//in
  .fault_clear      (fault_clear                             ),//in
  .lock             (any_pwr_fault_det                       ),//in
  .any_vrm_fault    (),								           //out
  .vrm_fault        (p3v3_stby_bp_fault_det                  ) //out
);
//------------------------------------------------------------------------------
// Main 12V fault detect
// - Efuse (all platform)
// - PSU (non-BL/BT)
// - Brownout fault (non-BL/BT)
// - If there's a brownout warning, a drop in pgd_p12v_stby_droop will cause
//   a brownout fault. No need to set p12v_stby_droop_fault_det.
//------------------------------------------------------------------------------
wire   p12v_stby_en;
wire   p12v_stby_en_check;
assign p12v_stby_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) p12v_stby_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p12v_stby_en),
  .delay_output  (p12v_stby_en_check)
);

generate begin : _P12V_FAULT_DETECT_
fault_detectB_chklive #(.NUMBER_OF_VRM(3)) p12_fault_detect_inst (
 .clk              (clk),
 .reset            (reset),
 .vrm_enable       ({pal_main_efuse_en,
                     pal_main_efuse_en,
                    (p12v_stby_en && p12v_stby_en_check)}),
 .vrm_pgood        ({pgd_main_efuse,
                     pgd_p12v,
                     pgd_p12v_stby_droop}),
 .vrm_chklive_en   ({st_en_5v,
                     st_en_5v,
                     p12v_stby_en_check}),
 .vrm_chklive_dis  ({st_disable_main_efuse,
                     st_disable_main_efuse,  
                     ~p12v_stby_en_check}),   
 .critical_fail    (st_critical_fail),
 .fault_clear      (fault_clear),
 .lock             (any_pwr_fault_det),
 .any_vrm_fault    (p12v_main_fault),
 .vrm_fault        ({main_efuse_fault_det,
                     p12v_fault_det,
                     p12v_stby_droop_fault_det})
);
end
endgenerate


//------------------------------------------------------------------------------
// P12V_EFFUSE Fault detect 
//------------------------------------------------------------------------------
wire power_supply_on_check;

edge_delay #(.CNTR_NBITS(2)) power_supply_on_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (power_supply_on),
  .delay_output  (power_supply_on_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_fan_efuse_fault_detect_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (power_supply_on && power_supply_on_check),			//in
  .vrm_pgood        (fan_efuse_pg),							//in
  .vrm_chklive_en   (power_supply_on_check),					//in
  .vrm_chklive_dis  (~power_supply_on_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (p12v_fan_efuse_fault_det)					//out
); 
  
fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_dimm_efuse_fault_detect_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (power_supply_on && power_supply_on_check),			//in
  .vrm_pgood        (dimm_efuse_pg),							//in
  .vrm_chklive_en   (power_supply_on_check),					//in
  .vrm_chklive_dis  (~power_supply_on_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (p12v_dimm_efuse_fault_det)					//out
);   
  
//------------------------------------------------------------------------------
// P12V_BP_FRONT Fault detect 
//------------------------------------------------------------------------------  
wire p12v_bp_front_en_check;

edge_delay #(.CNTR_NBITS(2)) p12v_bp_front_en_check_inst (
  .clk           (clk   ),
  .reset         (reset ),
  .cnt_size      (2'b10 ),
  .cnt_step      (t64ms ),
  .signal_in     (p12v_bp_front_en            ),
  .delay_output  (p12v_bp_front_en_check      )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_front_bp_efuse_fault_detect_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (p12v_bp_front_en & p12v_bp_front_en_check),//in
  .vrm_pgood        (front_bp_efuse_pg                        ),//in
  .vrm_chklive_en   (p12v_bp_front_en_check                   ),//in
  .vrm_chklive_dis  (~p12v_bp_front_en_check                  ),//in
  .critical_fail    (st_critical_fail                         ),//in
  .fault_clear      (fault_clear                              ),//in
  .lock             (any_pwr_fault_det                        ),//in
  .any_vrm_fault    (),									        //out
  .vrm_fault        (p12v_front_bp_efuse_fault_det            )	//out
);   

//------------------------------------------------------------------------------
// P12V_BP_REAR Fault detect 
//------------------------------------------------------------------------------
wire p12v_bp_rear_en_check;  

edge_delay #(.CNTR_NBITS(2)) p12v_bp_rear_en_check_inst (
  .clk           (clk   ),
  .reset         (reset ),
  .cnt_size      (2'b10 ),
  .cnt_step      (t64ms ),
  .signal_in     (p12v_bp_rear_en            ),
  .delay_output  (p12v_bp_rear_en_check      )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_reat_bp_efuse_fault_detect_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (p12v_bp_rear_en & p12v_bp_rear_en_check),			//in
  .vrm_pgood        (reat_bp_efuse_pg),							//in
  .vrm_chklive_en   (p12v_bp_rear_en_check),					//in
  .vrm_chklive_dis  (~p12v_bp_rear_en_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (p12v_reat_bp_efuse_fault_det)					//out
);


//------------------------------------------------------------------------------
// P5V Fault detect 
//------------------------------------------------------------------------------
wire p5v_en_r_check;

edge_delay #(.CNTR_NBITS(2)) p5v_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p5v_en_r),
  .delay_output  (p5v_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p5v_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (p5v_en_r & p5v_en_r_check),	    //in
  .vrm_pgood        (p5v_pgd),							//in
  .vrm_chklive_en   (p5v_en_r_check),					//in
  .vrm_chklive_dis  (~p5v_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (p5v_fault_det)					    //out
); 


//------------------------------------------------------------------------------
// CPU0_P1V8 & CPU1_P1V8 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_p1v8_en_r),
  .delay_output  (cpu0_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_p1v8_en_r & cpu0_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu0_p1v8_pg),						//in
  .vrm_chklive_en   (cpu0_p1v8_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_p1v8_fault_det)			//out
);

wire cpu1_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_p1v8_en_r),
  .delay_output  (cpu1_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_p1v8_en_r && cpu1_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu1_p1v8_pg),						//in
  .vrm_chklive_en   (cpu1_p1v8_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_p1v8_fault_det)			//out
);


//------------------------------------------------------------------------------
// CPU0_PLL_P1V8 & CPU1_PLL_P1V8 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_pll_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_pll_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_pll_p1v8_en_r),
  .delay_output  (cpu0_pll_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_pll_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_pll_p1v8_en_r & cpu0_pll_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu0_pll_p1v8_pg),						//in
  .vrm_chklive_en   (cpu0_pll_p1v8_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_pll_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_pll_p1v8_fault_det)			//out
);

wire cpu1_pll_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_pll_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_pll_p1v8_en_r),
  .delay_output  (cpu1_pll_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_pll_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_pll_p1v8_en_r && cpu1_pll_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu1_pll_p1v8_pg),						//in
  .vrm_chklive_en   (cpu1_pll_p1v8_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_pll_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_pll_p1v8_fault_det)			//out
);


//------------------------------------------------------------------------------
// CPU0_DDR_VDD & CPU1_DDR_VDD Fault detect 
//------------------------------------------------------------------------------
wire cpu0_ddr_vdd_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_ddr_vdd_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_ddr_vdd_en_r),
  .delay_output  (cpu0_ddr_vdd_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_ddr_vdd_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_ddr_vdd_en_r && cpu0_ddr_vdd_en_r_check),	//in
  .vrm_pgood        (cpu0_ddr_vdd_pg),						//in
  .vrm_chklive_en   (cpu0_ddr_vdd_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_ddr_vdd_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_ddr_vdd_fault_det)			//out
);

wire cpu1_ddr_vdd_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_ddr_vdd_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_ddr_vdd_en_r),
  .delay_output  (cpu1_ddr_vdd_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_ddr_vdd_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_ddr_vdd_en_r && cpu1_ddr_vdd_en_r_check),	//in
  .vrm_pgood        (cpu1_ddr_vdd_pg),						//in
  .vrm_chklive_en   (cpu1_ddr_vdd_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_ddr_vdd_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_ddr_vdd_fault_det)			//out
);


//------------------------------------------------------------------------------
// CPU0_PCIE_P0V9 & CPU1_PCIE_P0V9 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_pcie_p0v9_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_pcie_p0v9_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_pcie_p0v9_en_r),
  .delay_output  (cpu0_pcie_p0v9_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_pcie_p0v9_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_pcie_p0v9_en_r && cpu0_pcie_p0v9_en_r_check),	//in
  .vrm_pgood        (cpu0_pcie_p0v9_pg),						//in
  .vrm_chklive_en   (cpu0_pcie_p0v9_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_pcie_p0v9_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_pcie_p0v9_fault_det)			//out
);

wire cpu1_pcie_p0v9_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_pcie_p0v9_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_pcie_p0v9_en_r),
  .delay_output  (cpu1_pcie_p0v9_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_pcie_p0v9_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_pcie_p0v9_en_r && cpu1_pcie_p0v9_en_r_check),	//in
  .vrm_pgood        (cpu1_pcie_p0v9_pg),						//in
  .vrm_chklive_en   (cpu1_pcie_p0v9_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_pcie_p0v9_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_pcie_p0v9_fault_det)			//out
);


//------------------------------------------------------------------------------
// CPU0_PCIE_P1V8 & CPU1_PCIE_P1V8 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_pcie_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_pcie_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_pcie_p1v8_en_r),
  .delay_output  (cpu0_pcie_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_pcie_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_pcie_p1v8_en_r && cpu0_pcie_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu0_pcie_p1v8_pg),						//in
  .vrm_chklive_en   (cpu0_pcie_p1v8_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_pcie_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_pcie_p1v8_fault_det)			//out
);

wire cpu1_pcie_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_pcie_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_pcie_p1v8_en_r),
  .delay_output  (cpu1_pcie_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_pcie_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_pcie_p1v8_en_r && cpu1_pcie_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu1_pcie_p1v8_pg),						//in
  .vrm_chklive_en   (cpu1_pcie_p1v8_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_pcie_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_pcie_p1v8_fault_det)			//out
);


//------------------------------------------------------------------------------
// CPU0_VDDQ & CPU1_VDDQ Fault detect 
//------------------------------------------------------------------------------
wire cpu0_vddq_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_vddq_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_vddq_en_r),
  .delay_output  (cpu0_vddq_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_vddq_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_vddq_en_r && cpu0_vddq_en_r_check),	//in
  .vrm_pgood        (cpu0_vddq_pg),						//in
  .vrm_chklive_en   (cpu0_vddq_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_vddq_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_vddq_fault_det)			//out
);

wire cpu1_vddq_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_vddq_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_vddq_en_r),
  .delay_output  (cpu1_vddq_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_vddq_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_vddq_en_r && cpu1_vddq_en_r_check),	//in
  .vrm_pgood        (cpu1_vddq_pg),						//in
  .vrm_chklive_en   (cpu1_vddq_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_vddq_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_vddq_fault_det)			    //out
);


//------------------------------------------------------------------------------
// CPU0_VDD_CORE & CPU1_VDD_CORE Fault detect 
//------------------------------------------------------------------------------
wire cpu0_vdd_core_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_vdd_core_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_vdd_core_en_r),
  .delay_output  (cpu0_vdd_core_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_vdd_core_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_vdd_core_en_r && cpu0_vdd_core_en_r_check),	//in
  .vrm_pgood        (cpu0_vdd_core_pg),						//in
  .vrm_chklive_en   (cpu0_vdd_core_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_vdd_core_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_vdd_core_fault_det)			//out
);

wire cpu1_vdd_core_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_vdd_core_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_vdd_core_en_r),
  .delay_output  (cpu1_vdd_core_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_vdd_core_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_vdd_core_en_r && cpu1_vdd_core_en_r_check),	//in
  .vrm_pgood        (cpu1_vdd_core_pg),						//in
  .vrm_chklive_en   (cpu1_vdd_core_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_vdd_core_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_vdd_core_fault_det)			    //out
);

//------------------------------------------------------------------------------
// THERMTRIP_DETECT
//------------------------------------------------------------------------------
wire   cpupwrok_en;
wire   cpupwrok_en_check;
assign cpupwrok_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) cpupwrok_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpupwrok_en),
  .delay_output  (cpupwrok_en_check)
);

generate for (i = 0; i < NUM_CPU; i = i + 1) begin : _CPU_THERMTRIP_DETECT_BLOCK_
  fault_detectB_chklive #(.NUMBER_OF_VRM(1)) inst_cpu_thermtrip_fault_det (
    .clk              (clk),
    .reset            (reset),
    .vrm_enable       (cpupwrok_en & cpupwrok_en_check),
    .vrm_pgood        (~i_cpu_thermtrip[i]),
    .vrm_chklive_en   (st_steady_pwrok),
    .vrm_chklive_dis  (st_off_standby),
    .critical_fail    (st_critical_fail),
    .fault_clear      (fault_clear),
    .lock             (any_pwr_fault_det),
    .any_vrm_fault    (o_cpu_thermtrip_fault[i]),
    .vrm_fault        (cpu_thermtrip_fault_det[i])
  );
end
endgenerate

//------------------------------------------------------------------------------
// HD backplane subsystem
// - Handles hard drive backplane related power monitoring and fault detection
//------------------------------------------------------------------------------
wire hd_bp_pwr_en_check;//p5v_bp_en dealy 128+128ms is hd_bp_pwr_en_check(dected bp pgd)--//V001 z25168 20221024 bp pwr_en check; IDMS:202210110152
edge_delay #(.CNTR_NBITS(3)) bp_en_check_inst (
  .clk           (clk   ),
  .reset         (reset ),
  .cnt_size      (3'b100 ),
  .cnt_step      (t64ms ),
  .signal_in     (reg_p12v_en            ),
  .delay_output  (hd_bp_pwr_en_check      )
);

generate for (i = 0; i < NUM_HD_BP; i = i + 1) begin : _HD_BP_PWR_DETECT_BLOCK_
  fault_detectB_chklive #(.NUMBER_OF_VRM(1)) inst_hd_bp_pwr_fault_det (
    .clk              (clk),
    .reset            (reset),
    .vrm_enable       (~hd_bp_prsnt_n[i] & hd_bp_pwr_en_check),
    .vrm_pgood        (hd_bp_pgd[i]       ),
    .vrm_chklive_en   (hd_bp_pwr_en_check ),
    .vrm_chklive_dis  (~hd_bp_pwr_en_check  ),
    .critical_fail    (st_critical_fail   ),
    .fault_clear      (fault_clear      ),
    .lock             (any_pwr_fault_det  ),
    .any_vrm_fault    (            ),
    .vrm_fault        (hd_bp_fault_det[i] )
  );
end
endgenerate

//------------------------------------------------------------------------------
// Riser card subsystem
// - Handles riser card card related power monitoring and fault detection
//------------------------------------------------------------------------------

edge_delay #(.CNTR_NBITS(2)) riser_pwr_en_check_inst (
  .clk           (clk   ),
  .reset         (reset ),
  .cnt_size      (2'b10 ),
  .cnt_step      (t64ms ),
  .signal_in     (reg_p12v_en            ),
  .delay_output  (reg_riser_chk_en      )
);

generate if (NUM_RISER > 0) begin : _RISER_PWR_CNTLR_BLOCK_
  pwrseq_slave_dev #(.NUM_DEV(NUM_RISER)) pwrseq_slave_riser_inst (
    .reset                  (reset),
    .clk                    (clk),
    .t1us                   (t1us),
    .gate_en                (reg_p12v_en),
    .keep_alive_on_fault    (keep_alive_on_fault),//1'b0
    .chklive_en             ( reg_riser_chk_en),
    .chklive_dis            (~reg_riser_chk_en),
    .pwrdis_en              (1'b0),
    .sm_critical_fail       (st_critical_fail),
    .fault_clear            (fault_clear),
    .any_pwr_fault_det      (any_pwr_fault_det),
    .pgd_so_far             (riser_pgd_so_far),
    .prsnt_n                (riser_prsnt_n),
    .pal_en                 (pal_riser_en),
    .pgd_pwr                (riser_pgd),
    .mod_fault              (riser_mod_fault),
    .fault_det              (riser_fault_det),
    .fault_pwrdis           ()
  );
end
else begin
  assign riser_pgd_so_far = 1'b1;
  assign pal_riser_en     = 1'b0;
  assign riser_mod_fault  = 1'b0;
  assign riser_fault_det  = 1'b0;
end
endgenerate

//------------------------------------------------------------------------------
// Aux rails to check
// - check enabled when NUM_OPT_AUX is > 0
//------------------------------------------------------------------------------
//Fault Flag
wire [FAULT_VEC_SIZE-1:0] fault_vec;
wire [FAULT_VEC_SIZE-1:0] any_recov_fault_vec;
wire [FAULT_VEC_SIZE-1:0] any_lim_recov_fault_vec;
wire [FAULT_VEC_SIZE-1:0] any_non_recov_fault_vec;
wire any_recov_fault_c;
wire any_lim_recov_fault_c;
wire any_non_recov_fault_c;

wire aux_fault;

assign any_aux_vrm_fault = aux_fault;


// fault_vec_mapping
assign fault_vec[0]  = p5v_stby_fault_det ;  
assign fault_vec[1]  = p5v_fault_det ;
assign fault_vec[2]  = p12v_front_bp_efuse_fault_det;
assign fault_vec[3]  = p12v_reat_bp_efuse_fault_det;
assign fault_vec[4]  = 1'b0;//p12v_fan_efuse_fault_det;
assign fault_vec[5]  = p12v_dimm_efuse_fault_det;
assign fault_vec[6]  = cpu0_p1v8_fault_det;
assign fault_vec[7]  = cpu1_p1v8_fault_det;
assign fault_vec[8]  = cpu0_pll_p1v8_fault_det;
assign fault_vec[9]  = cpu1_pll_p1v8_fault_det;
assign fault_vec[10] = cpu0_ddr_vdd_fault_det;
assign fault_vec[11] = cpu1_ddr_vdd_fault_det;
assign fault_vec[12] = cpu0_pcie_p0v9_fault_det;
assign fault_vec[13] = cpu1_pcie_p0v9_fault_det;
assign fault_vec[14] = cpu0_pcie_p1v8_fault_det;
assign fault_vec[15] = cpu1_pcie_p1v8_fault_det;
assign fault_vec[16] = cpu0_vddq_fault_det;    
assign fault_vec[17] = cpu1_vddq_fault_det; 
assign fault_vec[18] = cpu0_vdd_core_fault_det;  
assign fault_vec[19] = cpu1_vdd_core_fault_det;
assign fault_vec[20] = p3v3_stby_fault_det;  
assign fault_vec[21] = p3v3_stby_bp_fault_det;
assign fault_vec[22] = 1'b0;//riser_mod_fault;
assign fault_vec[23] = 1'b0;//|hd_bp_fault_det;
assign fault_vec[24] = 1'b0;  // RSVD
assign fault_vec[25] = 1'b0;  // RSVD
assign fault_vec[26] = 1'b0;  // RSVD
assign fault_vec[27] = 1'b0;  // RSVD
assign fault_vec[28] = 1'b0;  // RSVD
assign fault_vec[29] = 1'b0;  // RSVD
assign fault_vec[30] = 1'b0;  // RSVD
assign fault_vec[31] = 1'b0;  // RSVD
assign fault_vec[32] = 1'b0;  // RSVD
assign fault_vec[33] = 1'b0;  // RSVD
assign fault_vec[34] = 1'b0;  // RSVD
assign fault_vec[35] = 1'b0;  // RSVD
assign fault_vec[36] = 1'b0;  // RSVD
assign fault_vec[37] = 1'b0;  // RSVD
assign fault_vec[38] = 1'b0;  // RSVD
assign fault_vec[39] = 1'b0;  // RSVD


// Mask each fault with the corresponding bits
generate for (i = 0; i < FAULT_VEC_SIZE; i = i + 1) begin : _fault_vec_block_
  assign any_recov_fault_vec[i]     = fault_vec[i] & RECOV_FAULT_MASK[i];
  assign any_lim_recov_fault_vec[i] = fault_vec[i] & LIM_RECOV_FAULT_MASK[i];
  assign any_non_recov_fault_vec[i] = fault_vec[i] & NON_RECOV_FAULT_MASK[i];
end
endgenerate

assign any_recov_fault_c     = |any_recov_fault_vec;
assign any_lim_recov_fault_c = |any_lim_recov_fault_vec;
assign any_non_recov_fault_c = |any_non_recov_fault_vec;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    any_pwr_fault_det   <= 1'b0;
    any_recov_fault     <= 1'b0;
    any_lim_recov_fault <= 1'b0;
    any_non_recov_fault <= 1'b0;
  end
  else begin
    any_pwr_fault_det   <= any_recov_fault_c | any_lim_recov_fault_c | any_non_recov_fault_c;
    any_recov_fault     <= any_recov_fault_c;
    any_lim_recov_fault <= any_lim_recov_fault_c;
    any_non_recov_fault <= any_non_recov_fault_c;
  end
end
/*******************************************************************************
//------------------------------------------------------------------------------
// Fault Detect End
//------------------------------------------------------------------------------
********************************************************************************/


//------------------------------------------------------------------------------
// pwrseq_sm_fault_det
// - Stores the power sequencer state where a power fault was detected.
//------------------------------------------------------------------------------
reg  fault_save_en;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    fault_save_en       <= 1'b1;
    pwrseq_sm_fault_det <= 6'b0;
  end
  else if (t1us && fault_clear) begin
    fault_save_en       <= 1'b1;
    pwrseq_sm_fault_det <= 6'b0;
  end
  else if (t1us && st_critical_fail)
    fault_save_en       <= 1'b0;
  else if (t1us && fault_save_en)
    pwrseq_sm_fault_det <= power_seq_sm;
end


//------------------------------------------------------------------------------
// pgd_so_far
// - Reflects current status of power rail pgood signal qualified by their
//   respective enable signal. This signal is used by pwrseq_master.
//20170526 QIURONGLIN, PWM_CTRL_VDD/P5V_STBY is forced on once BMC AUX power is OK,
//which is independent of the normal power sequence, and whose pwr_ok detection would
//cause the sequence abnormally.
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    pgd_so_far <= 1'b0;
  else
    pgd_so_far <= 1'b1;
end

endmodule