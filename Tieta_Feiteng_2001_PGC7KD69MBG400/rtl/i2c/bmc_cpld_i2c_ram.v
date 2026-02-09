

module bmc_cpld_i2c_ram #( 
parameter DLY_LEN       = 3   //24.18MHz,330ns
)
(
input  i_rst_n, 
input  i_clk,
input  i_1ms_clk,	
input  i_rst_i2c_n,



/*AS03MB03 RAM START*/
/*CPLD Common Register*/
input  [7:0] i_product_id,             //addr 0x0000
input  [7:0] i_vender_id,              //addr 0x0001
input  [7:0] i_board_id,               //addr 0x0002
input  [7:0] i_pcb_version,            //addr 0x0003
input  [7:0] i_bom_id,                 //addr 0x0004
input  [7:0] i_cpld_version,           //addr 0x0005
output [7:0] o_test_reg,               //addr 0x0006
input  [7:0] i_year,                   //addr 0x0007
input  [7:0] i_month,                  //addr 0x0008
input  [7:0] i_day,                    //addr 0x0009
input  [7:0] i_cpld_compa_version,     //addr 0x000b
input  [7:0] i_cpld_debug_version,     //addr 0x000c
/*CPLD System Register*/
input  [7:0] i_error_code_msb,         //addr 0x0010
input  [7:0] i_error_code_lsb,         //addr 0x0011

input  i_bmc_alarm_flag,               //addr 0x0012 bit7,addr 0x0260 bit0
input  i_dimm_alarm_flag,              //addr 0x0012 bit5,addr 0x0300 bit0
input  i_cpu_alarm_flag,               //addr 0x0012 bit4,addr 0x0290 bit0
input  i_operate_alarm_flag,           //addr 0x0012 bit3
input  i_power_alarm_flag,             //addr 0x0012 bit0

input  i_hdb_alarm_flag,               //addr 0x0013 bit4  
input  i_reset_alarm_flag,             //addr 0x0013 bit2
input  i_psu_alarm_flag,               //addr 0x0013 bit0,addr 0x0460 bit0

/*Power Common Register*/
input  i_stb_pwron_tmout_fail,         //addr 0x0030 bit7  
input  i_stb_pwrdown_ukwn_fail,        //addr 0x0030 bit6
input  i_poweron_tmout_fail,           //addr 0x0030 bit5
input  i_powerdown_ukwn_fail,          //addr 0x0030 bit4
input  i_system_pwr_sts,               //addr 0x0030 bit0

input  i_all_stbpwrpg_sts,             //addr 0x0031 bit7 
input  i_all_pwrpg_sts,                //addr 0x0031 bit6
input  i_pwr_unnormal_fail,            //addr 0x0031 bit5
input  i_slps5_sts,                    //addr 0x0031 bit4
input  i_slps3_sts,                    //addr 0x0031 bit2

input  i_power_on_fail_err_code,       //addr 0x0032
input  i_power_down_fail_err_code,     //addr 0x0033
input  i_power_hot,                    //addr 0x0034,OLD NAME:i_power_hot&fault&alert_err_code

input [7:0] i_power_seq_state_machine,	//addr 0x0035 
input [7:0] i_power_seq_fault_latch	,	//addr 0x0036



/*Power EN Register*/
input  i_pdb_p12v_en,                  //addr 0x0059 bit7
input  i_ncsi_aux_pwr_en,              //addr 0x0059 bit6
input  i_scm_p3v3_stby_en_r,           //addr 0x0059 bit5
input  i_p5v_stby_en,                  //addr 0x0059 bit4
input  i_p1_vdd_18_stby_en,            //addr 0x0059 bit3
input  i_p0_vdd_18_stby_en,            //addr 0x0059 bit2
input  i_p1_vddc_en,                   //addr 0x0059 bit1
input  i_p0_vddc_en,                   //addr 0x0059 bit0

input  i_en_p1v0_stby,                 //addr 0x005A bit6
input  i_en_p1v05_stby,                //addr 0x005A bit5
input  i_en_p1v2_stby,                 //addr 0x005A bit4
input  i_en_p1v8_stby,                 //addr 0x005A bit3
input  i_en_p2v5_2,                    //addr 0x005A bit2
input  i_en_p3v3_bmc_rgm,              //addr 0x005A bit1
input  i_en_p5v0_stby,                 //addr 0x005A bit0

input  i_pal_cpu0_dimm_efuse_en,       //addr 0x005B bit5
input  i_pal_p0_vdd_11_sus_en,         //addr 0x005B bit4
input  i_pal_p0_vddio_en_r,            //addr 0x005B bit3
input  i_pal_p0_vdd_soc_en,            //addr 0x005B bit2
input  i_pal_p0_vdd_core_0_en_r,       //addr 0x005B bit1
input  i_pal_p0_vdd_core_1_en_r,       //addr 0x005B bit0

input  i_pal_cpu1_dimm_efuse_en,       //addr 0x005C bit5
input  i_pal_p1_vdd_11_sus_en,         //addr 0x005C bit4
input  i_pal_p1_vddio_en_r,            //addr 0x005C bit3
input  i_pal_p1_vdd_soc_en,            //addr 0x005C bit2
input  i_pal_p1_vdd_core_0_en_r,       //addr 0x005C bit1
input  i_pal_p1_vdd_core_1_en_r,       //addr 0x005C bit0

input  i_front_bp0_pwr_en,             //addr 0x005D bit7 
input  i_front_bp1_pwr_en,             //addr 0x005D bit6
input  i_rear_bp0_pwr_en,              //addr 0x005D bit5
input  i_rear_bp1_pwr_en,              //addr 0x005D bit4
input  i_ncsi_main_pwr_en,             //addr 0x005D bit3
input  i_p3v3_en,                      //addr 0x005D bit2
input  i_en_p12v_ssd_efuse,            //addr 0x005D bit1
input  i_en_p12v_efuse,                //addr 0x005D bit0

input  i_en_p3v3_m2,                   //addr 0x005E bit7

/*Power PG Register*/
input  i_p5v_stby_pgood,               //addr 0x0062 bit3
input  i_p1v8_stby_pg,                 //addr 0x0062 bit2
input  i_p3v3_stby_pgood,              //addr 0x0062 bit1
input  i_pg_p12v_stby_efuse,           //addr 0x0062 bit0

input  i_pwrgd_vdd_18_stby1,           //addr 0x0063 bit5
input  i_pwrgd_vdd_18_stby0,           //addr 0x0063 bit4
input  i_pwrgd_vdd_33_stby1,           //addr 0x0063 bit3
input  i_pwrgd_vdd_33_stby0,           //addr 0x0063 bit2

input  i_pg_p3v3_stby,                  //addr 0x0064 bit7
input  i_pg_p1v0_stby,                  //addr 0x0064 bit6
input  i_pg_p1v05_stby,                 //addr 0x0064 bit5
input  i_pg_p1v2_stby,                  //addr 0x0064 bit4
input  i_pg_p1v8_stby,                  //addr 0x0064 bit3
input  i_pg_p2v5_stby,                  //addr 0x0064 bit2
input  i_pg_p3v3_stby_bmc,              //addr 0x0064 bit1   OLD NAME:i_pg_p3v3_stby_bmc_pv33d_rgm,
input  i_pg_p5v0_stby,                  //addr 0x0064 bit0

input  i_pwrgd_p3v3_m2_r,               //addr 0x0066 bit7

input  i_p0_efuse_pwrgd,                //addr 0x006B bit5
input  i_pal_pgd_p0_vdd_core_1,         //addr 0x006B bit4
input  i_pal_pgd_p0_vdd_core_0,         //addr 0x006B bit3
input  i_pal_pgd_p0_vdd_soc_0,          //addr 0x006B bit2
input  i_pal_pgd_p0_vddio,              //addr 0x006B bit1
input  i_pal_pgd_p0_vdd_sus_0,          //addr 0x006B bit0

input  i_p1_efuse_pwrgd,                //addr 0x006C bit5
input  i_pal_pgd_p1_vdd_core_1,         //addr 0x006C bit4
input  i_pal_pgd_p1_vdd_core_0,         //addr 0x006C bit3
input  i_pal_pgd_p1_vdd_soc_0,          //addr 0x006C bit2
input  i_pal_pgd_p1_vddio,              //addr 0x006C bit1
input  i_pal_pgd_p1_vdd_sus_0,          //addr 0x006C bit0

input  i_p3v3_pgood,                    //addr 0x006D bit2
input  i_pg_p12v_ssd_efuse,             //addr 0x006D bit1
input  i_pg_p12v_efuse,                 //addr 0x006D bit0

input  i_p1_pwrgd_out_r,                //addr 0x0072 bit5
input  i_p0_pwrgd_out_r,                //addr 0x0072 bit4
input  i_p1_pwrok_r,                    //addr 0x0072 bit3
input  i_p0_pwrok_r,                    //addr 0x0072 bit2
input  i_p1_pwr_good_r,                 //addr 0x0072 bit1
input  i_p0_pwr_good_r,                 //addr 0x0072 bit0

input  i_pwrgd_ocp0_nic_pwrgd,          //addr 0x0073 bit0

/*Power Events Record Register*/
input  i_irq_pvccio_cpu1_vrhot,         //addr 0x0090 bit7
input  i_pvddq_def_cpu1_vrhot,          //addr 0x0090 bit6
input  i_pvddq_abc_cpu1_vrhot,          //addr 0x0090 bit5
input  i_irq_pvccin_cpu1_vrhot,         //addr 0x0090 bit4
input  i_irq_pvccio_cpu0_vrhot,         //addr 0x0090 bit3
input  i_pvddq_def_cpu0_vrhot,          //addr 0x0090 bit2
input  i_pvddq_abc_cpu0_vrhot,          //addr 0x0090 bit1
input  i_irq_pvccin_cpu0_vrhot,         //addr 0x0090 bit0

input  i_p5v_stby_fault_det				,//addr 0x0091 bit6
input  i_p5v_stby_usb0_fault_det		,//addr 0x0091 bit5 
input  i_p5v_stby_usb1_fault_det		,//addr 0x0091 bit4
input  i_grp_b_p0_33_s5_fault_det		,//addr 0x0091 bit3
input  i_grp_b_p1_33_s5_fault_det		,//addr 0x0091 bit2
input  i_grp_b_p0_18_s5_fault_det		,//addr 0x0091 bit1
input  i_grp_b_p1_18_s5_fault_det		,//addr 0x0091 bit0

input  i_p3v3_fault_det					,//addr 0x0092 bit6
input  i_p12v_efuse_fault_det			,//addr 0x0092 bit5
input  i_p12v_ssd_efuse_fault_det		,//addr 0x0092 bit4
input  i_p12v_p0_dimm_fault_det			,//addr 0x0092 bit3
input  i_p12v_p1_dimm_fault_det			,//addr 0x0092 bit2
input  i_grp_c_p0_fault_det				,//addr 0x0092 bit1
input  i_grp_c_p1_fault_det				,//addr 0x0092 bit0
  
input  i_grp_d_vddio_p0_fault_det		,//addr 0x0093 bit7 
input  i_grp_d_vddio_p1_fault_det		,//addr 0x0093 bit6   
input  i_grp_d_soc_p0_fault_det			,//addr 0x0093 bit5 
input  i_grp_d_soc_p1_fault_det			,//addr 0x0093 bit4  
input  i_grp_d_p0_vddcore0_fault_det	,//addr 0x0093 bit3
input  i_grp_d_p1_vddcore0_fault_det	,//addr 0x0093 bit2 
input  i_grp_d_p0_vddcore1_fault_det	,//addr 0x0093 bit1
input  i_grp_d_p1_vddcore1_fault_det	,//addr 0x0093 bit0   
  
  



input  i_p0_usb_oc0_n,					 //addr 0x009C bit7
input  i_p0_usb_oc1_n,					 //addr 0x009C bit6
input  i_p1_vr_i2c7_alert_n,            //addr 0x009C bit5
input  i_p0_vr_i2c7_alert_n,            //addr 0x009C bit4
input  i_p12v_ssd_efuse_alert_n,        //addr 0x009C bit3
input  i_p12v_efuse_alert_n,            //addr 0x009C bit2
input  i_ina3221_warning,               //addr 0x009C bit1
input  i_p12v_stby_efuse_alert_n,       //addr 0x009C bit0

input  i_p1_vdd_core_1_ocp_n,           //addr 0x009D bit7
input  i_p1_vdd_core_0_ocp_n,           //addr 0x009D bit6
input  i_p1_vddio_ocp_n,                //addr 0x009D bit5
input  i_p1_efuse_fault_n,              //addr 0x009D bit4
input  i_p0_vdd_core_1_ocp_n,           //addr 0x009D bit3
input  i_p0_vdd_core_0_ocp_n,           //addr 0x009D bit2
input  i_p0_vddio_ocp_n,                //addr 0x009D bit1
input  i_p0_efuse_fault_n,              //addr 0x009D bit0

/*Power Control Register*/
output  o_force_allpwron_ctl,           //addr 0x00A0 bit0

/*CLK Common Register*/
input   i_clk_alarm_flag,               //addr 0x00B0 bit0

/*RTC CLK State Register*/
input   i_clk_rtc_susclk_r,             //addr 0x00C0 bit0

/*CLK Control Register*/
output  o_fm_pld_db800_4_clks_dev_en,   //addr 0x00D1 bit7
output  o_fm_pld_db800_3_clks_dev_en,   //addr 0x00D1 bit6
output  o_fm_pld_db800_2_clks_dev_en,   //addr 0x00D1 bit5
output  fm_pld_db800_1_clks_dev_en,     //addr 0x00D1 bit4
output  o_clk_db800_4_oe_n,             //addr 0x00D1 bit3
output  o_clk_db800_3_oe_n,             //addr 0x00D1 bit2
output  o_clk_db800_2_oe_n,             //addr 0x00D1 bit1
output  o_clk_db800_1_oe_n,             //addr 0x00D1 bit0

output  o_clk_gen_pg_pd_n,              //addr 0x00D2 bit7
output  o_clk_gen_en_n,                 //addr 0x00D2 bit6
output  o_clk_mux_2_sel0,               //addr 0x00D2 bit3
output  o_clk_mux_2_sel1,               //addr 0x00D2 bit2
output  o_clk_mux_1_sel0,               //addr 0x00D2 bit1
output  o_clk_mux_1_sel1,               //addr 0x00D2 bit0

output  o_clk_mux2_en4,                 //addr 0x00D3 bit7
output  o_clk_mux2_en3,                 //addr 0x00D3 bit6
output  o_clk_mux2_en2,                 //addr 0x00D3 bit5
output  o_clk_mux2_en1,                 //addr 0x00D3 bit4
output  o_clk_mux1_en4,                 //addr 0x00D3 bit3
output  o_clk_mux1_en3,                 //addr 0x00D3 bit2
output  o_clk_mux1_en2,                 //addr 0x00D3 bit1
output  o_clk_mux1_en1,                 //addr 0x00D3 bit0

output  o_db800_oe4_n_cmu,              //addr 0x00D4 bit4
output  o_db800_oe3_n_cmu,              //addr 0x00D4 bit3
output  o_db800_oe2_n_cmu,              //addr 0x00D4 bit2
output  o_db800_oe1_n_cmu,              //addr 0x00D4 bit1
output  o_db800_oe0_n_cmu,              //addr 0x00D4 bit0

/*RST Common Register*/
input   i_rst_alarm_flag,               //addr 0x00E0 bit0

/*RST State Register*/
input   i_p1_kbrst_r_n,                 //addr 0x00F1 bit7
input   i_p0_kbrst_r_n,                 //addr 0x00F1 bit6
input   i_cpld_p1_pcie_rst_n,           //addr 0x00F1 bit5
input   i_cpld_p0_pcie_rst_n,           //addr 0x00F1 bit4
input   i_p1_pcie_rst_n_1,              //addr 0x00F1 bit3
input   i_p1_pcie_rst_n_0,              //addr 0x00F1 bit2
input   i_p0_pcie_rst_n_1,              //addr 0x00F1 bit1
input   i_p0_pcie_rst_n_0,              //addr 0x00F1 bit0

output  o_pcie_genz_rst_n_r,            //addr 0x00F2 bit6,addr 0x0104 bit0
output  o_rst_moc1_n,                   //addr 0x00F2 bit5
output  o_rst_moc0_n,                   //addr 0x00F2 bit4
output  o_rst_pcie_perst1_ocp3_n,       //addr 0x00F2 bit3
output  o_rst_pcie_perst1_ocp2_n,       //addr 0x00F2 bit2
output  o_rst_pcie_perst1_ocp1_n,       //addr 0x00F2 bit1
output  o_rst_pcie_perst1_ocp0_n,       //addr 0x00F2 bit0

input   i_plt_rst_fault,                //addr 0x00F8 bit0

/*RST Control Register*/
input   i_bmc_i2c9_9545_rst_n,          //addr 0x0102 bit7
input   i_bmc_i2c9_9548_1_rst_n,        //addr 0x0102 bit6
input   i_bmc_i2c9_9548_2_rst_n,        //addr 0x0102 bit5
input   i_bmc_i2c9_9548_3_rst_n,        //addr 0x0102 bit4
input   i_bmc_i2c9_9548_4_rst_n,        //addr 0x0102 bit3
input   i_p1_vpp_9545_rst_n,            //addr 0x0102 bit2
input   i_p0_vpp_9545_rst_n,            //addr 0x0102 bit1
input   i_rst_ocp0_card_smb_r_n,        //addr 0x0102 bit0

input   i_p1_vdd_core_0_soc_rst_l_n,    //addr 0x0103 bit7
input   i_p1_vdd_core_1_11_sus_rst_l_n, //addr 0x0103 bit6
input   i_p1_vddio_rst_l_n,             //addr 0x0103 bit5
input   i_p0_vddio_rst_l_n,             //addr 0x0103 bit4
input   i_p0_vdd_core_0_soc_rst_l_n,    //addr 0x0103 bit3
input   i_p0_vdd_core_1_11_sus_rst_l_n, //addr 0x0103 bit2
input   i_cpu_sys_reset_r_n,            //addr 0x0103 bit1
input   i_cpu_rsmrst_r_n,               //addr 0x0103 bit0

output  o_usb_pe_rst_n,                 //addr 0x0104 bit4
output  o_rst_pltrst_bmc_r_n,           //addr 0x0104 bit3
output  o_pcie_m2_1_perst_n,            //addr 0x0104 bit2
output  o_pcie_m2_0_perst_n,            //addr 0x0104 bit1
//output  o_pcie_genz_rst_n_r,            


output  o_usb_ponrst_r_n,               //addr 0x0105 bit6
output  o_tpcm_reset_n,                 //addr 0x0105 bit5
output  o_jtag_cpld_bmc_ntrst_r,        //addr 0x0105 bit4
output  o_cpld_bmc_extrst_n,            //addr 0x0105 bit3
output  o_fm_bmc_arm_rstind_r_n,        //addr 0x0105 bit2
output  o_cpld_bmc_srst_n,              //addr 0x0105 bit1
output  o_bmc_cpld_i2c_rst_r_n,         //addr 0x0105 bit0

/*Button LED Common Register*/
input   i_btn_press_flag,               //addr 0x0110 bit0 

output  o_sbtn_pwron_evt,               //addr 0x0120 bit4            
output  o_lbtn_pwrdown_evt,             //addr 0x0120 bit3 
output  o_sbtn_sysrst_evt,              //addr 0x0120 bit2
output  o_uid_btn_evt,                  //addr 0x0120 bit1 
output  o_uid_rstbmc_evt,               //addr 0x0120 bit0

input   i_port80,                       //addr 0x0121



/*Button LED control Register*/
output  o_pwr_btn_lock,                 //addr 0x0130 bit4
output  o_bmc_sbtn_powrdown_ctl,        //addr 0x0130 bit3
output  o_bmc_lbtn_pwrdown_ctl,         //addr 0x0130 bit2
output  o_bmc_sbtn_powron_ctl,          //addr 0x0130 bit1
output  o_bmc_lbtn_powrdown_ctl,        //addr 0x0130 bit0

output  o_bmc_pwr_led_grn_r_ctl,        //addr 0x0140 [7:4]
output  o_mc_pwr_ledred_r_clt,          //addr 0x0140 [3:0]
output  o_health_greled_ctl,            //addr 0x0141 [7:4]
output  o_health__redled_ctl,           //addr 0x0141 [3:0]
output  o_uid_led_ctl,                  //addr 0x0142
output  o_port80_ctl,                   //addr 0x0143

/*BMC Common Register*/
//input   i_bmc_alarm_flag,               

/*BMC State Register*/ 
output  o_bmc_wdt_rst_evt,              //addr 0x0270 bit1
input   i_bmc_ready_flag,               //addr 0x0271 bit0

/*CPU Common Register*/
//input   i_cpu_alarm_flag,              

input   i_cpu1_intr_prsnt,              //addr 0x0291 bit1
input   i_cpu0_intr_prsnt,              //addr 0x0291 bit0

/*CPU State Register*/
input   i_cpu0_prochot_lvt3_n,          //addr 0x02A4 bit2
input   i_cpu0_fivr_fault,              //addr 0x02A4 bit0

input   i_cpu1_thermtrip,               //addr 0x02A8 bit7
input   i_p1_nmi_sync_flood_r,          //addr 0x02A8 bit5
input   i_p1_smerr_r_n,                 //addr 0x02A8 bit3


input   i_cpu1_prochot_lvt3_n,          //addr 0x02AB bit2
input   i_cpu1_fivr_fault,              //addr 0x02AB bit0

/*CPU ID Record Register*/
input   i_p0_coretype2,                 //addr 0x02E0 bit6
input   i_p0_coretype1,                 //addr 0x02E0 bit5
input   i_p0_coretype0,                 //addr 0x02E0 bit4
input   i_p0_sp5r4,                     //addr 0x02E0 bit3
input   i_p0_sp5r3,                     //addr 0x02E0 bit2
input   i_p0_sp5r2,                     //addr 0x02E0 bit1
input   i_p0_sp5r1,                     //addr 0x02E0 bit0

input   i_p1_coretype2,                 //addr 0x02E8 bit6
input   i_p1_coretype1,                 //addr 0x02E8 bit5
input   i_p1_coretype0,                 //addr 0x02E8 bit4
input   i_p1_sp5r4,                     //addr 0x02E8 bit3
input   i_p1_sp5r3,                     //addr 0x02E8 bit2
input   i_p1_sp5r2,                     //addr 0x02E8 bit1
input   i_p1_sp5r1,                     //addr 0x02E8 bit0

/*DIMM Common Register*/
//input   i_dimm_alarm_flag,              

/*DIMM State Register*/
input   i_cpu1_memhot,                  //addr 0x0310 bit1
input   i_cpu0_memhot,                  //addr 0x0310 bit0
input   i_cpu1_mem_therm_event,         //addr 0x0311 bit1
input   i_cpu0_mem_therm_event,         //addr 0x0311 bit1

/*FAN Common Register*/
input   i_fan_alarm_flag,               //addr 0x03E0 bit0

/*FAN State Register*/
input   i_fan_int,                      //addr 0x03F0 bit0

/*FAN ID Register*/
input   i_fan_board_id_2,               //addr 0x0440 bit2
input   i_fan_board_id_1,               //addr 0x0440 bit1
input   i_fan_board_id_0,               //addr 0x0440 bit0

/*PSU Common Register*/
//input   i_psu_alarm_flag,               

input   i_ps2_prsnt,                    //addr 0x0461 bit1
input   i_ps1_prsnt,                    //addr 0x0461 bit0


/*PSU State Register*/
input   i_ps2_alert,                    //addr 0x0470 bit5
input   i_ps1_alert,                    //addr 0x0470 bit4

input   i_ps2_dcok,                     //addr 0x0471 bit5  
input   i_ps1_dcok,                     //addr 0x0471 bit4 
input   i_ps2_acok,                     //addr 0x0471 bit1 
input   i_ps1_acok,                     //addr 0x0471 bit0 



/*CMU State Register*/
input   i_bmc_tpcm_sw,                  //addr 0x04B0 bit6 
input   i_tpcm_bios_sw,                 //addr 0x04B0 bit5
input   i_tpcm_bmc_sw,                  //addr 0x04B0 bit4 
input   i_bmc_rom_tm_done,              //addr 0x04B0 bit2 
input   i_bios_rom_tm_done,             //addr 0x04B0 bit1
input   i_tpcm_presnt,                  //addr 0x04B0 bit0 

/*IO Board Common Register*/
input   i_io_board_alarm_flag,          //addr 0x0560 bit0

/*PCIe Devices Common Register*/
input   i_pcie_alarm_flag,              //addr 0x0640 bit0

output  o_moc_card_present_n,           //addr 0x0641 bit0


 
 
/*AS03MB03 RAM END */


input    i_scl, 
inout    io_sda
);
	
///////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////
//CPLD TOP --> CPLD RAM , BMC read
///////////////////////////////////////////////////////////////////////
wire w_i2c_start;
wire w_WR       ;
wire w_data_vld_pos;
wire [15:0]w_i2c_command ;
wire [7:0] w_i2c_data_out;

wire [7:0] w_ram_0000;
wire [7:0] w_ram_0001;
wire [7:0] w_ram_0002;
wire [7:0] w_ram_0003;
wire [7:0] w_ram_0004;
wire [7:0] w_ram_0005;
wire [7:0] w_ram_0007;
wire [7:0] w_ram_0008;
wire [7:0] w_ram_0009;
wire [7:0] w_ram_000b;
wire [7:0] w_ram_000c;
wire [7:0] w_ram_0010;
wire [7:0] w_ram_0011;
wire [7:0] w_ram_0012;
wire [7:0] w_ram_0013;
wire [7:0] w_ram_0030;
wire [7:0] w_ram_0031;
wire [7:0] w_ram_0032;
wire [7:0] w_ram_0033;
wire [7:0] w_ram_0034;
wire [7:0] w_ram_0035;
wire [7:0] w_ram_0036;
wire [7:0] w_ram_0059;
wire [7:0] w_ram_005A;
wire [7:0] w_ram_005B;
wire [7:0] w_ram_005C;
wire [7:0] w_ram_005D;
wire [7:0] w_ram_005E;
wire [7:0] w_ram_0062;
wire [7:0] w_ram_0063;
wire [7:0] w_ram_0064;

wire [7:0] w_ram_0066;
wire [7:0] w_ram_006B;
wire [7:0] w_ram_006C;
wire [7:0] w_ram_006D;
wire [7:0] w_ram_0072;
wire [7:0] w_ram_0073;
wire [7:0] w_ram_0090;
wire [7:0] w_ram_0091;
wire [7:0] w_ram_0092;
wire [7:0] w_ram_0093;
wire [7:0] w_ram_009C;
wire [7:0] w_ram_009D;
wire [7:0] w_ram_00B0;
wire [7:0] w_ram_00C0;
wire [7:0] w_ram_00E0;
wire [7:0] w_ram_00F1;
wire [7:0] w_ram_00F8;
wire [7:0] w_ram_0102;
wire [7:0] w_ram_0103;
wire [7:0] w_ram_0110;
wire [7:0] w_ram_0121;
wire [7:0] w_ram_0260;
wire [7:0] w_ram_0271;
wire [7:0] w_ram_0290;
wire [7:0] w_ram_0291;
wire [7:0] w_ram_02A4;
wire [7:0] w_ram_02A8;
wire [7:0] w_ram_02AB;
wire [7:0] w_ram_02E0;
wire [7:0] w_ram_02E8;
wire [7:0] w_ram_0300;
wire [7:0] w_ram_0310;
wire [7:0] w_ram_0311;
wire [7:0] w_ram_03E0;
wire [7:0] w_ram_03F0;
wire [7:0] w_ram_0440;
wire [7:0] w_ram_0460;
wire [7:0] w_ram_0461;
wire [7:0] w_ram_0470;
wire [7:0] w_ram_0471;
wire [7:0] w_ram_04B0;
wire [7:0] w_ram_0560;
wire [7:0] w_ram_0640;
wire [7:0] w_ram_0641;
///////////////////////////////////////////////////////////////////////
//reg  BMC --->CPLD RAM
///////////////////////////////////////////////////////////////////////
reg [7:0] r_i2c_data_in;

reg [7:0] r_reg_0006;
reg [7:0] r_reg_00A0;
reg [7:0] r_reg_00D1;
reg [7:0] r_reg_00D2;
reg [7:0] r_reg_00D3;
reg [7:0] r_reg_00D4;
reg [7:0] r_reg_00F2;
reg [7:0] r_reg_0104;
reg [7:0] r_reg_0105;
reg [7:0] r_reg_0120;
reg [7:0] r_reg_0130;
reg [7:0] r_reg_0140;
reg [7:0] r_reg_0141;
reg [7:0] r_reg_0142;
reg [7:0] r_reg_0143;
reg [7:0] r_reg_0270;
reg [7:0] r_reg_0641;


assign  o_test_reg = r_reg_0006;
assign  o_force_allpwron_ctl = r_reg_00A0[0];

assign  o_fm_pld_db800_4_clks_dev_en = r_reg_00D1[7]; 
assign  o_fm_pld_db800_3_clks_dev_en = r_reg_00D1[6]; 
assign  o_fm_pld_db800_2_clks_dev_en = r_reg_00D1[5]; 
assign  fm_pld_db800_1_clks_dev_en = r_reg_00D1[4];   
assign  o_clk_db800_4_oe_n = r_reg_00D1[3];           
assign  o_clk_db800_3_oe_n = r_reg_00D1[2];           
assign  o_clk_db800_2_oe_n = r_reg_00D1[1];           
assign  o_clk_db800_1_oe_n = r_reg_00D1[0]; 

assign  o_clk_gen_pg_pd_n =  r_reg_00D2[7]; 
assign  o_clk_gen_en_n    =  r_reg_00D2[6];              
assign  o_clk_mux_2_sel0  =  r_reg_00D2[3];   
assign  o_clk_mux_2_sel1  =  r_reg_00D2[2];           
assign  o_clk_mux_1_sel0  =  r_reg_00D2[1];          
assign  o_clk_mux_1_sel1  =  r_reg_00D2[0];

assign  o_clk_mux2_en4    =  r_reg_00D3[7];           
assign  o_clk_mux2_en3    =  r_reg_00D3[6];                
assign  o_clk_mux2_en2    =  r_reg_00D3[5];                
assign  o_clk_mux2_en1    =  r_reg_00D3[4];               
assign  o_clk_mux1_en4    =  r_reg_00D3[3];               
assign  o_clk_mux1_en3    =  r_reg_00D3[2];               
assign  o_clk_mux1_en2    =  r_reg_00D3[1];               
assign  o_clk_mux1_en1    =  r_reg_00D3[0];

assign  o_db800_oe4_n_cmu =  r_reg_00D4[4];          
assign  o_db800_oe3_n_cmu =  r_reg_00D4[3];         
assign  o_db800_oe2_n_cmu =  r_reg_00D4[2];          
assign  o_db800_oe1_n_cmu =  r_reg_00D4[1];           
assign  o_db800_oe0_n_cmu =  r_reg_00D4[0];

assign  o_pcie_genz_rst_n_r      = r_reg_00F2[6] & r_reg_0105[0];          
assign  o_rst_moc1_n             = r_reg_00F2[5];                 
assign  o_rst_moc0_n             = r_reg_00F2[4];                 
assign  o_rst_pcie_perst1_ocp3_n = r_reg_00F2[3];    
assign  o_rst_pcie_perst1_ocp2_n = r_reg_00F2[2];     
assign  o_rst_pcie_perst1_ocp1_n = r_reg_00F2[1];     
assign  o_rst_pcie_perst1_ocp0_n = r_reg_00F2[0]; 

assign  o_usb_pe_rst_n           = r_reg_0105[4];               
assign  o_rst_pltrst_bmc_r_n     = r_reg_0105[3];   
assign  o_pcie_m2_1_perst_n      = r_reg_0105[2];  
assign  o_pcie_m2_0_perst_n      = r_reg_0105[1];    
//assign  o_pcie_genz_rst_n_r      = r_reg_0105[0];   


assign  o_usb_ponrst_r_n         = r_reg_0105[6];               
assign  o_tpcm_reset_n           = r_reg_0105[5];               
assign  o_jtag_cpld_bmc_ntrst_r  = r_reg_0105[4];      
assign  o_cpld_bmc_extrst_n      = r_reg_0105[3];         
assign  o_fm_bmc_arm_rstind_r_n  = r_reg_0105[2];       
assign  o_cpld_bmc_srst_n        = r_reg_0105[1];            
assign  o_bmc_cpld_i2c_rst_r_n   = r_reg_0105[0]; 

assign  o_sbtn_pwron_evt         = r_reg_0120[4];                               
assign  o_lbtn_pwrdown_evt       = r_reg_0120[3];     
assign  o_sbtn_sysrst_evt        = r_reg_0120[2];       
assign  o_uid_btn_evt            = r_reg_0120[1];       
assign  o_uid_rstbmc_evt         = r_reg_0120[0]; 

assign  o_pwr_btn_lock           = r_reg_0130[4];
assign  o_bmc_sbtn_powrdown_ctl  = r_reg_0130[3];
assign  o_bmc_lbtn_pwrdown_ctl   = r_reg_0130[2];
assign  o_bmc_sbtn_powron_ctl    = r_reg_0130[1];
assign  o_bmc_lbtn_powrdown_ctl  = r_reg_0130[0]; 

assign  o_bmc_pwr_led_grn_r_ctl  = r_reg_0140[7:4];       
assign  o_mc_pwr_ledred_r_clt    = r_reg_0140[3:0]; 

assign  o_health_greled_ctl      = r_reg_0141[7:4];
assign  o_health__redled_ctl     = r_reg_0141[3:0];          

assign  o_uid_led_ctl            = r_reg_0142; 

assign  o_port80_ctl             = r_reg_0143; 

assign  o_bmc_wdt_rst_evt        = r_reg_0270[1];

assign  o_moc_card_present_n     = r_reg_0641[0];


/////////////////////////////////////////////////////////////////////////
//read byte from cpld
////////////////////////////////////////////////////////////////////////
assign w_ram_0000    = i_product_id	;
assign w_ram_0001    = i_vender_id	;
assign w_ram_0002    = i_board_id	;
assign w_ram_0003    = i_pcb_version;
assign w_ram_0004    = i_bom_id		;
assign w_ram_0005    = i_cpld_version;
assign w_ram_0007    = i_year;
assign w_ram_0008    = i_month;
assign w_ram_0009    = i_day;
assign w_ram_000b	 = i_cpld_compa_version;
assign w_ram_000c	 = i_cpld_debug_version;
assign w_ram_0121    = i_port80;
assign w_ram_0010    = i_error_code_msb;
assign w_ram_0011    = i_error_code_lsb;
assign w_ram_0012    = {
                        i_bmc_alarm_flag,
						1'b0,
						i_dimm_alarm_flag,
                        i_cpu_alarm_flag,
                        i_operate_alarm_flag,
                        2'b0,
						i_power_alarm_flag
                         };
						
assign w_ram_0013    =  {
                         3'b0,
                         i_hdb_alarm_flag,
						 1'b0,
                         i_reset_alarm_flag,
						 1'b0,
                         i_psu_alarm_flag
                         };	
assign w_ram_0030    =   {
                         i_stb_pwron_tmout_fail,
                         i_stb_pwrdown_ukwn_fail,
                         i_poweron_tmout_fail,
                         i_powerdown_ukwn_fail,
                         3'b0,
						 i_system_pwr_sts
                         };
                        						          					
assign w_ram_0031    = {
                        i_all_stbpwrpg_sts,
                        i_all_pwrpg_sts,
                        i_pwr_unnormal_fail,
                        i_slps5_sts,
						1'b0,
                        i_slps3_sts,
                        2'b0
						};
						
assign w_ram_0032 = i_power_on_fail_err_code;
assign w_ram_0033 = i_power_down_fail_err_code;
assign w_ram_0034 = i_power_hot;                //OLD NAME i_power_hot&fault&alert_err_code;
assign w_ram_0035 = i_power_seq_state_machine;
assign w_ram_0036 = i_power_seq_fault_latch;

assign w_ram_0059 = {
                     i_pdb_p12v_en,
                     i_ncsi_aux_pwr_en,
                     i_scm_p3v3_stby_en_r,
                     i_p5v_stby_en,
                     i_p1_vdd_18_stby_en,
                     i_p0_vdd_18_stby_en,
                     i_p1_vddc_en,
                     i_p0_vddc_en
                     };

assign w_ram_005A = {
                     1'b0,
                     i_en_p1v0_stby,
                     i_en_p1v05_stby,
                     i_en_p1v2_stby,
                     i_en_p1v8_stby,
                     i_en_p2v5_2,
                     i_en_p3v3_bmc_rgm,
                     i_en_p5v0_stby
                     };
					 
assign w_ram_005B = {
                     2'b0,
					 i_pal_cpu0_dimm_efuse_en,
                     i_pal_p0_vdd_11_sus_en,
                     i_pal_p0_vddio_en_r,
                     i_pal_p0_vdd_soc_en,
                     i_pal_p0_vdd_core_0_en_r,
                     i_pal_p0_vdd_core_1_en_r
					 };

assign w_ram_005C = {
                     2'b0,
                     i_pal_cpu1_dimm_efuse_en,
                     i_pal_p1_vdd_11_sus_en,
                     i_pal_p1_vddio_en_r,
                     i_pal_p1_vdd_soc_en,
                     i_pal_p1_vdd_core_0_en_r,
                     i_pal_p1_vdd_core_1_en_r		 
					 };

assign w_ram_005D = {
                     i_front_bp0_pwr_en,
                     i_front_bp1_pwr_en,
                     i_rear_bp0_pwr_en,
                     i_rear_bp1_pwr_en,
                     i_ncsi_main_pwr_en,
                     i_p3v3_en,
                     i_en_p12v_ssd_efuse,
                     i_en_p12v_efuse
					 };
					
assign w_ram_005E = {
                     i_en_p3v3_m2,
					 7'b0
					 };
					 
assign w_ram_0062 = {
                     4'b0,
					 i_p5v_stby_pgood,
                     i_p1v8_stby_pg,
                     i_p3v3_stby_pgood,
                     i_pg_p12v_stby_efuse
					 };					 
					 
assign w_ram_0063 = {
                     2'b0,
					 i_pwrgd_vdd_18_stby1,
                     i_pwrgd_vdd_18_stby0,
                     i_pwrgd_vdd_33_stby1,
                     i_pwrgd_vdd_33_stby0,
					 2'b0
					 };					 
					 
assign w_ram_0064 = {
                     i_pg_p3v3_stby,
                     i_pg_p1v0_stby,
                     i_pg_p1v05_stby,
                     i_pg_p1v2_stby,
                     i_pg_p1v8_stby,
                     i_pg_p2v5_stby,
                     i_pg_p3v3_stby_bmc,
                     i_pg_p5v0_stby
					 };		
					 
assign w_ram_0066 = {
                     i_pwrgd_p3v3_m2_r,
                     7'b0
					 };

assign w_ram_006B = {
                     2'b0,
                     i_p0_efuse_pwrgd,
                     i_pal_pgd_p0_vdd_core_1,
                     i_pal_pgd_p0_vdd_core_0,
                     i_pal_pgd_p0_vdd_soc_0,
                     i_pal_pgd_p0_vddio,
                     i_pal_pgd_p0_vdd_sus_0
					 };

assign w_ram_006C = {
                     2'b0,
					 i_p1_efuse_pwrgd,
                     i_pal_pgd_p1_vdd_core_1,
                     i_pal_pgd_p1_vdd_core_0,
                     i_pal_pgd_p1_vdd_soc_0,
                     i_pal_pgd_p1_vddio,
                     i_pal_pgd_p1_vdd_sus_0
					  };
					  
assign w_ram_006D = {
                     5'b0,
					 i_p3v3_pgood,
                     i_pg_p12v_ssd_efuse,
                     i_pg_p12v_efuse
					 };

assign w_ram_0072 = {
                     2'b0,
					 i_p1_pwrgd_out_r,
                     i_p0_pwrgd_out_r,
                     i_p1_pwrok_r,
                     i_p0_pwrok_r,
                     i_p1_pwr_good_r,
                     i_p0_pwr_good_r
                     };
					 
assign w_ram_0073 = {
                     7'b0,
					 i_pwrgd_ocp0_nic_pwrgd
					 };
assign w_ram_0090 = {
                     i_irq_pvccio_cpu1_vrhot,
                     i_pvddq_def_cpu1_vrhot,
                     i_pvddq_abc_cpu1_vrhot,
                     i_irq_pvccin_cpu1_vrhot,
                     i_irq_pvccio_cpu0_vrhot,
                     i_pvddq_def_cpu0_vrhot,
                     i_pvddq_abc_cpu0_vrhot,
                     i_irq_pvccin_cpu0_vrhot
					 };
assign w_ram_0091 = {
					1'b0,
					i_p5v_stby_fault_det			,
					i_p5v_stby_usb0_fault_det		,
					i_p5v_stby_usb1_fault_det		,
					i_grp_b_p0_33_s5_fault_det		,
					i_grp_b_p1_33_s5_fault_det		,
					i_grp_b_p0_18_s5_fault_det		,
					i_grp_b_p1_18_s5_fault_det		
					};

assign w_ram_0092 = {
					1'b0,
					i_p3v3_fault_det				,
					i_p12v_efuse_fault_det			,
					i_p12v_ssd_efuse_fault_det		,
					i_p12v_p0_dimm_fault_det		,
					i_p12v_p1_dimm_fault_det		,
					i_grp_c_p0_fault_det			,
					i_grp_c_p1_fault_det
					};					
assign w_ram_0093 = { 
					i_grp_d_vddio_p0_fault_det		,
					i_grp_d_vddio_p1_fault_det		,
					i_grp_d_soc_p0_fault_det		,
					i_grp_d_soc_p1_fault_det		,
					i_grp_d_p0_vddcore0_fault_det	,
					i_grp_d_p1_vddcore0_fault_det	, 
					i_grp_d_p0_vddcore1_fault_det	,
					i_grp_d_p1_vddcore1_fault_det	
					};

 assign w_ram_009C = {
                       i_p0_usb_oc0_n,
					   i_p0_usb_oc1_n,
					   i_p1_vr_i2c7_alert_n,
                       i_p0_vr_i2c7_alert_n,
                       i_p12v_ssd_efuse_alert_n,
                       i_p12v_efuse_alert_n,
                       i_ina3221_warning,
                       i_p12v_stby_efuse_alert_n
					   };
					   
 assign w_ram_009D = {
                      i_p1_vdd_core_1_ocp_n,
                      i_p1_vdd_core_0_ocp_n,
                      i_p1_vddio_ocp_n,
                      i_p1_efuse_fault_n,
                      i_p0_vdd_core_1_ocp_n,
                      i_p0_vdd_core_0_ocp_n,
                      i_p0_vddio_ocp_n,
                      i_p0_efuse_fault_n
					   };					   
 
 
 assign w_ram_00B0 = {
                     7'b0,
					 i_clk_alarm_flag
					 }; 
 
 assign w_ram_00C0 = {
                     7'b0,
					 i_clk_rtc_susclk_r
					 }; 
					 
 assign w_ram_00E0 = {
                     7'b0,
					 i_rst_alarm_flag
					 }; 
					 
 assign w_ram_00F1 = {
                     i_p1_kbrst_r_n,
                     i_p0_kbrst_r_n,
                     i_cpld_p1_pcie_rst_n,
                     i_cpld_p0_pcie_rst_n,
                     i_p1_pcie_rst_n_1,
                     i_p1_pcie_rst_n_0,
                     i_p0_pcie_rst_n_1,
                     i_p0_pcie_rst_n_0
					 };
 
 assign w_ram_00F8 = {
                     7'b0,
					 i_plt_rst_fault
					 }; 
 
 assign w_ram_0102 = {
                      i_bmc_i2c9_9545_rst_n,   
                      i_bmc_i2c9_9548_1_rst_n,
                      i_bmc_i2c9_9548_2_rst_n,
                      i_bmc_i2c9_9548_3_rst_n,
                      i_bmc_i2c9_9548_4_rst_n,
                      i_p1_vpp_9545_rst_n,
                      i_p0_vpp_9545_rst_n,
                      i_rst_ocp0_card_smb_r_n
					 }; 
					 
 assign w_ram_0103 = {
                      i_p1_vdd_core_0_soc_rst_l_n,   
                      i_p1_vdd_core_1_11_sus_rst_l_n,
                      i_p1_vddio_rst_l_n,            
                      i_p0_vddio_rst_l_n,            
                      i_p0_vdd_core_0_soc_rst_l_n,   
                      i_p0_vdd_core_1_11_sus_rst_l_n,
                      i_cpu_sys_reset_r_n,            
                      i_cpu_rsmrst_r_n              
					 }; 

 assign w_ram_0110 = {
                      7'b0,
					  i_btn_press_flag
					 }; 

 assign w_ram_0260 = {
                     7'b0,
					 i_bmc_alarm_flag
					 };

 assign w_ram_0271 = {
                     7'b0,
					 i_bmc_ready_flag
					 };
					 
					 
					 
 assign w_ram_0290 = {
                     7'b0,
					 i_cpu_alarm_flag
					 };

 assign w_ram_0291 = {
                     6'b0,
					 i_cpu1_intr_prsnt,
                     i_cpu0_intr_prsnt
					 };

 assign w_ram_02A4 = {
                     5'b0,
					 i_cpu0_prochot_lvt3_n,
                     1'b0,
					 i_cpu0_fivr_fault
					 };

 assign w_ram_02AB = {
                     5'b0,
					 i_cpu1_prochot_lvt3_n,
					 1'b0,
					 i_cpu1_fivr_fault
					 };

 assign w_ram_02A8 = {
                      i_cpu1_thermtrip,
                      1'b0,
                      i_p1_nmi_sync_flood_r,
                      1'b0,
                      i_p1_smerr_r_n,
                      3'b0
					 }; 

 assign w_ram_02E0 = {
                     1'b0,
					 i_p0_coretype2,
                     i_p0_coretype1,
                     i_p0_coretype0,
                     i_p0_sp5r4,
                     i_p0_sp5r3,
                     i_p0_sp5r2,
                     i_p0_sp5r1
					 };

 assign w_ram_02E8 = {
                     1'b0,
					 i_p1_coretype2,
                     i_p1_coretype1,
                     i_p1_coretype0,
                     i_p1_sp5r4,
                     i_p1_sp5r3,
                     i_p1_sp5r2,
                     i_p1_sp5r1
					 };

 assign w_ram_0300 = {
                      7'b0,
					  i_dimm_alarm_flag
					  };

 assign w_ram_0310 = {
                     6'b0,
					 i_cpu1_memhot,
                     i_cpu0_memhot
					 };

 assign w_ram_0311 = {
                     6'b0,
					 i_cpu1_mem_therm_event,
					 i_cpu0_mem_therm_event
					 };

 assign w_ram_03E0 = {
					 7'b0,
					 i_fan_alarm_flag
					 };

 assign w_ram_03F0 = {
					 7'b0,
					 i_fan_int
					 };					 

 assign w_ram_0440 = {
                     5'b0,
					 i_fan_board_id_2,
                     i_fan_board_id_1,
                     i_fan_board_id_0
					 };


 assign w_ram_0460 = {
                      7'b0,
					  i_psu_alarm_flag
					 };
					 
 assign w_ram_0461 = {
                      6'b0,
					  i_ps2_prsnt,
                      i_ps1_prsnt
					 };
					 
 assign w_ram_0470 = {
                      2'b0,
					  i_ps2_alert,
                      i_ps1_alert,
					  4'b0
					 };	
					 
 assign w_ram_0471 = {
                      2'b0,
					  i_ps2_dcok,
                      i_ps1_dcok,
					  2'b0,
					  i_ps2_acok,
                      i_ps1_acok
					 };

 assign w_ram_04B0 = {
                      1'b0,
					  i_bmc_tpcm_sw,
                      i_tpcm_bios_sw,
                      i_tpcm_bmc_sw,
                      1'b0,
                      i_bmc_rom_tm_done,
                      i_bios_rom_tm_done,
                      i_tpcm_presnt
					 };

 assign w_ram_0560 = {
                      7'b0,
					  i_io_board_alarm_flag
					 };					 

 assign w_ram_0640 = {
                      7'b0,
					  i_pcie_alarm_flag
					 };

					 
always@(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
	begin
	    r_i2c_data_in  <= 8'h00;
	end
	else 
	begin
	case(w_i2c_command)
	16'h0000: r_i2c_data_in  <= w_ram_0000;  
	16'h0001: r_i2c_data_in  <= w_ram_0001;  
	16'h0002: r_i2c_data_in  <= w_ram_0002;  
	16'h0003: r_i2c_data_in  <= w_ram_0003;  
	16'h0004: r_i2c_data_in  <= w_ram_0004;  
	16'h0005: r_i2c_data_in  <= w_ram_0005;  
	16'h0006: r_i2c_data_in  <= r_reg_0006;  
	16'h0007: r_i2c_data_in  <= w_ram_0007;  
	16'h0008: r_i2c_data_in  <= w_ram_0008;  
	16'h0009: r_i2c_data_in  <= w_ram_0009; 
	16'h000b: r_i2c_data_in  <= w_ram_000b;  
	16'h000c: r_i2c_data_in  <= w_ram_000c;  	
	16'h0010: r_i2c_data_in  <= w_ram_0010;  
	16'h0011: r_i2c_data_in  <= w_ram_0011;
	16'h0012: r_i2c_data_in  <= w_ram_0012;
	16'h0013: r_i2c_data_in  <= w_ram_0013;	
	16'h0030: r_i2c_data_in  <= w_ram_0030;
	16'h0031: r_i2c_data_in  <= w_ram_0031;
	16'h0032: r_i2c_data_in  <= w_ram_0032;
	16'h0033: r_i2c_data_in  <= w_ram_0033;
	16'h0034: r_i2c_data_in  <= w_ram_0034;
	16'h0035: r_i2c_data_in  <= w_ram_0035;
	16'h0036: r_i2c_data_in  <= w_ram_0036;
	16'h0059: r_i2c_data_in  <= w_ram_0059;
	16'h005A: r_i2c_data_in  <= w_ram_005A;
	16'h005B: r_i2c_data_in  <= w_ram_005B;
    16'h005C: r_i2c_data_in  <= w_ram_005C;
    16'h005D: r_i2c_data_in  <= w_ram_005D;	
    16'h005E: r_i2c_data_in  <= w_ram_005E;
	16'h0062: r_i2c_data_in  <= w_ram_0062;
	16'h0063: r_i2c_data_in  <= w_ram_0063;
	16'h0064: r_i2c_data_in  <= w_ram_0064;
	16'h0066: r_i2c_data_in  <= w_ram_0066;
	16'h006B: r_i2c_data_in  <= w_ram_006B;
	16'h006C: r_i2c_data_in  <= w_ram_006C;
	16'h006D: r_i2c_data_in  <= w_ram_006D;
	16'h0072: r_i2c_data_in  <= w_ram_0072;
	16'h0073: r_i2c_data_in  <= w_ram_0073;
	16'h0090: r_i2c_data_in  <= w_ram_0090;
	16'h0091: r_i2c_data_in  <= w_ram_0091; 
	16'h0092: r_i2c_data_in  <= w_ram_0092; 
	16'h0093: r_i2c_data_in  <= w_ram_0093; 
	16'h009C: r_i2c_data_in  <= w_ram_009C;
	16'h009D: r_i2c_data_in  <= w_ram_009D;
	16'h00A0: r_i2c_data_in  <= r_reg_00A0;
	16'h00B0: r_i2c_data_in  <= w_ram_00B0;
	16'h00C0: r_i2c_data_in  <= w_ram_00C0;
	16'h00D1: r_i2c_data_in  <= r_reg_00D1;
	16'h00D2: r_i2c_data_in  <= r_reg_00D2;
	16'h00D3: r_i2c_data_in  <= r_reg_00D3;
	16'h00D4: r_i2c_data_in  <= r_reg_00D4;
	16'h00E0: r_i2c_data_in  <= w_ram_00E0;
	16'h00F1: r_i2c_data_in  <= w_ram_00F1;
	16'h00F2: r_i2c_data_in  <= r_reg_00F2;
	16'h00F8: r_i2c_data_in  <= w_ram_00F8;
	16'h0102: r_i2c_data_in  <= w_ram_0102;
	16'h0103: r_i2c_data_in  <= w_ram_0103;
	16'h0110: r_i2c_data_in  <= w_ram_0110;
	16'h0104: r_i2c_data_in  <= r_reg_0104;
	16'h0105: r_i2c_data_in  <= r_reg_0105;
	16'h0120: r_i2c_data_in  <= r_reg_0120;
	16'h0121: r_i2c_data_in  <= w_ram_0121;
	16'h0130: r_i2c_data_in  <= r_reg_0130;
	16'h0140: r_i2c_data_in  <= r_reg_0140;
	16'h0141: r_i2c_data_in  <= r_reg_0141;
	16'h0142: r_i2c_data_in  <= r_reg_0142;
	16'h0143: r_i2c_data_in  <= r_reg_0143;
	16'h0260: r_i2c_data_in  <= w_ram_0260;
	16'h0271: r_i2c_data_in  <= w_ram_0271;
	16'h0270: r_i2c_data_in  <= r_reg_0270;
	16'h0290: r_i2c_data_in  <= w_ram_0290;
	16'h0291: r_i2c_data_in  <= w_ram_0291;
	16'h02A4: r_i2c_data_in  <= w_ram_02A4;
	16'h02AB: r_i2c_data_in  <= w_ram_02AB;
	16'h02A8: r_i2c_data_in  <= w_ram_02A8;
	16'h02E0: r_i2c_data_in  <= w_ram_02E0;
	16'h02E8: r_i2c_data_in  <= w_ram_02E8;
	16'h0300: r_i2c_data_in  <= w_ram_0300;
	16'h0310: r_i2c_data_in  <= w_ram_0310;
	16'h0311: r_i2c_data_in  <= w_ram_0311;
	16'h03E0: r_i2c_data_in  <= w_ram_03E0;
	16'h03F0: r_i2c_data_in  <= w_ram_03F0;
	16'h0440: r_i2c_data_in  <= w_ram_0440;
	16'h0460: r_i2c_data_in  <= w_ram_0460;
	16'h0461: r_i2c_data_in  <= w_ram_0461;
	16'h0470: r_i2c_data_in  <= w_ram_0470;
	16'h0471: r_i2c_data_in  <= w_ram_0471;
	16'h04B0: r_i2c_data_in  <= w_ram_04B0;
	16'h0560: r_i2c_data_in  <= w_ram_0560;
	16'h0640: r_i2c_data_in  <= w_ram_0640;
	16'h0641: r_i2c_data_in  <= r_reg_0641;
	

	default: r_i2c_data_in <= 8'h00;
	endcase
	end
end
 

///////////////////////////////////////////////////////////////////////
//write data to cpld
///////////////////////////////////////////////////////////////////////

//0x0006
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0006  <=8'h55;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0006) && w_data_vld_pos)  begin
        r_reg_0006  <= ~w_i2c_data_out;
    end
end

//0x00A0 
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_00A0  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h00A0) && w_data_vld_pos)  begin
        r_reg_00A0  <= w_i2c_data_out;
    end
end

//0x00D1
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_00D1  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h00D1) && w_data_vld_pos)  begin
        r_reg_00D1  <= w_i2c_data_out;
    end
end

//0x00D2
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_00D2  <=8'hff;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h00D2) && w_data_vld_pos)  begin
        r_reg_00D2  <= w_i2c_data_out;
    end
end

//0X00D3
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_00D3  <=8'h80;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h00D3) && w_data_vld_pos)  begin
        r_reg_00D3  <= w_i2c_data_out;
    end
end

//0X00D4
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_00D4  <=8'hff;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h00D4) && w_data_vld_pos)  begin
        r_reg_00D4  <= w_i2c_data_out;
    end
end

//0X00F2
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_00F2  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h00F2) && w_data_vld_pos)  begin
        r_reg_00F2  <= w_i2c_data_out;
    end
end

//0X0104
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0104  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0104) && w_data_vld_pos)  begin
        r_reg_0104  <= w_i2c_data_out;
    end
end

//0X0105
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0105  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0105) && w_data_vld_pos)  begin
        r_reg_0105  <= w_i2c_data_out;
    end
end


//0X0120
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0120  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0120) && w_data_vld_pos)  begin
        r_reg_0120  <= w_i2c_data_out;
    end
end

//0X0130
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0130  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0130) && w_data_vld_pos)  begin
        r_reg_0130  <= w_i2c_data_out;
    end
end

//0X0140
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0140  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0140) && w_data_vld_pos)  begin
        r_reg_0140  <= w_i2c_data_out;
    end
end

//0X0141
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0141  <=8'hf0;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0141) && w_data_vld_pos)  begin
        r_reg_0141  <= w_i2c_data_out;
    end
end

//0X0142
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0142  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0142) && w_data_vld_pos)  begin
        r_reg_0142  <= w_i2c_data_out;
    end
end

//0X0143
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0143  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0143) && w_data_vld_pos)  begin
        r_reg_0143  <= w_i2c_data_out;
    end
end

//0X0270
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0270  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0270) && w_data_vld_pos)  begin
        r_reg_0270  <= w_i2c_data_out;
    end
end

//0X00641
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0641  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0641) && w_data_vld_pos)  begin
        r_reg_0641  <= w_i2c_data_out;
    end
end

///////////////////////////////////////////////////////////////////////
//i2c slave
///////////////////////////////////////////////////////////////////////

i2c_slave_bmc  #(
.DLY_LEN                 (DLY_LEN)      //3   //24.18MHz,330ns
)i2c_slave_bmc_u0(
.i_rst_n                 (i_rst_n    ), 
.i_clk                   (i_clk      ),
.i_1ms_clk               (i_1ms_clk  ),
.i_rst_i2c_n             (i_rst_i2c_n),

.i_scl                   (i_scl         ),
.io_sda                  (io_sda        ),

.i_i2c_address           (7'h10         ),
.o_i2c_start             (w_i2c_start   ),
.o_WR                    (w_WR          ),
.o_data_vld_pos          (w_data_vld_pos),
.o_i2c_command           (w_i2c_command ),
.i_i2c_data_in           (r_i2c_data_in),
.o_i2c_data_out          (w_i2c_data_out)
); 


	
	
	
endmodule 