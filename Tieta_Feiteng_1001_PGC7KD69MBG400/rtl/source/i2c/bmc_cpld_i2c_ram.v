

module bmc_cpld_i2c_ram #( 
    parameter DLY_LEN       = 3   //24.18MHz,330ns
)(
    input           i_rst_n                 , 
    input           i_clk                   ,
    input           t1s                     , 
    input           t1us                    ,
    input           t125ms                  ,
    input           pgoodaux                , 
    input           pon_reset_sasd          ,
    input           i_1ms_clk               ,	
    input           i_rst_i2c_n             ,

    input           i_scl                   , 
    inout           io_sda                  ,
    /*CLK Control Register*/
    input   [15:0]  bmc_cpld_version,         //addr 0x00FA-0x00FB[7:0]
    input   [15:0]  mb_cpld2_ver,             //addr 0x00FC-0x00FD[7:0]
    input   [15:0]  mb_cpld1_ver,             //addr 0x00FE-0x00FF[7:0]  
    input           bmc_security_bypass,      //addr 0x0000[6]
 
input   [1:0] cpld_pwm_main_type,       //addr 0x0002[6:5]
input         fan_wdt_sel,              //addr 0x0002[4]
input         fm_bmc_fan_wdt_feed,      //addr 0x0002[1]  
input         ilo_hard_reset,

output        vwire_bmc_wakeup,         //addr 0x0003 [6]
output        vwire_bmc_sysrst,         //addr 0x0003 [5]
output        vwire_bmc_shutdown,       //addr 0x0003 [4]
input         pwr_btn_state,            //addr 0x0003 [3]
input         rst_btn_state,            //addr 0x0003 [2]
output        rst_btn_mask,             //addr 0x0003 [0]

output        bmc_ctrl_shutdown,        //addr 0x0004 [6]
output        aux_pcycle,               //addr 0x0004 [4]
output        pwrbtn_bl_mask,           //addr 0x0004 [3]
output        vwire_pwrbtn_bl,          //addr 0x0004 [2]
output        physical_pwrbtn_mask,     //addr 0x0004 [1]
input         st_steady_pwrok,          //addr 0x0004 [0]

output        bmc_uid_update,            //addr 0x0005 [7]

output        wol_en,                   //addr 0x0006 [3]          
output  [1:0] sideband_sel,             //addr 0x0006 [1:0]

output        rom_mux_bios_bmc_en,      //addr 0x0007 [7]
output        rom_mux_bios_bmc_sel,     //addr 0x0007 [6]
output        rom_bios_bk_rst,          //addr 0x0007 [3]
output        rom_bios_ma_rst,          //addr 0x0007 [2]
output        rom_bmc_bk_rst,           //addr 0x0007 [1]
output        rom_bmc_ma_rst,           //addr 0x0007 [0]

output        test_bat_en,              //addr 0x0008 [7]
output        bios_eeprom_wp,           //addr 0x0008 [6]

output wire [7:0] o_uid_led_ctl,        //addr 0x0009 [7:0]

input  wire   i_uid_btn_evt,            //addr 0x000A[1]
output wire   o_uid_btn_evt_clr,        //addr 0x000A[0]
input  wire   i_uid_rstbmc_evt,         //addr 0x000A[1]
output wire   o_uid_rstbmc_evt_clr,     //addr 0x000A[0]

output        bmcctl_front_nic_led,     //addr 0x000B[2]
output wire   o_sys_healthy_red,        //addr 0x000B[1]
output wire   o_sys_healthy_grn,        //addr 0x000B[0]
          
input   [7:0] port_80,                  //addr 0x000d [7:0]

input   [7:0] port_84,                  //addr 0x000e [7:0]

input   [7:0] lpc_io_data_port85,       //addr 0x000f [7:0]          

output        rtc_select_n,             //addr 0x0010 [4]         
output        vga2_dis,                 //addr 0x0010 [3]                 
input         cpu0_d0_bios_over,        //addr 0x0010 [0]        

input         bios_read_flag,           //addr 0x0013 [7]          
output        bmc_read_flag,            //addr 0x0013 [6]          

input         m2_slot2_type,            //addr 0x0015 [4]          
input         m2_slot1_type,            //addr 0x0015 [3]
input         m2_slot2_prsnt,           //addr 0x0015 [2]          
input         m2_slot1_prsnt,           //addr 0x0015 [1]          
input         m2_card_prsnt,            //addr 0x0015 [0]          

output  [1:0] bmcctl_uart_sw,           //addr 0x0016 [7:6]

output  [7:0] bmc_i2c_rst,              //addr 0x0019 [7:0]
output  [7:0] bmc_i2c_rst2,             //addr 0x001A [7:0]
output  [7:0] bmc_i2c_rst3,             //addr 0x001B [7:0]

output        tpm_rst,                  //addr 0x001D [7]           
input         tpm_prsnt,                //addr 0x001D [6]
input         intruder,                 //addr 0x001D [5]
input         intruder_cable_prsnt,     //addr 0x001D [4]
input         dsd_prsnt,                //addr 0x001D [3]

input         i_fan0_prsnt_n  ,
input         i_fan0_p12v_gok ,
input         i_fan1_prsnt_n  ,
input         i_fan1_p12v_gok ,
input         i_fan2_prsnt_n  ,
input         i_fan2_p12v_gok ,
input         i_fan3_prsnt_n  ,
input         i_fan3_p12v_gok ,

output        o_fan3_p12v_en  ,
output        o_fan2_p12v_en  ,
output        o_fan1_p12v_en  ,
output        o_fan0_p12v_en  ,

output  [7:0] o_pwm_bmc_fan0  ,
output  [7:0] o_pwm_bmc_fan1  ,
output  [7:0] o_pwm_bmc_fan2  ,
output  [7:0] o_pwm_bmc_fan3  ,

input   [7:0] i_fan0_type     ,
input   [7:0] i_fan1_type     ,
input   [7:0] i_fan2_type     ,
input   [7:0] i_fan3_type     ,

output  [7:0] o_bmc_ctr_fan_led_status,

input   [7:0]  i_fan0_tach0_real_h,
input   [7:0]  i_fan0_tach0_real_l,
input   [7:0]  i_fan1_tach1_real_h,
input   [7:0]  i_fan1_tach1_real_l,
input   [7:0]  i_fan2_tach2_real_h,
input   [7:0]  i_fan2_tach2_real_l,
input   [7:0]  i_fan3_tach3_real_h,
input   [7:0]  i_fan3_tach3_real_l,


/*
input    [7:0]fan_tach1_byte2,          //addr 0x0020 [7:0]
input    [7:0]fan_tach1_byte1,          //addr 0x0021 [7:0]
input    [7:0]fan_tach2_byte2,          //addr 0x0022 [7:0]
input    [7:0]fan_tach2_byte1,          //addr 0x0023 [7:0]
input    [7:0]fan_tach3_byte2,          //addr 0x0024 [7:0]
input    [7:0]fan_tach3_byte1,          //addr 0x0025 [7:0]
input    [7:0]fan_tach4_byte2,          //addr 0x0026 [7:0]
input    [7:0]fan_tach4_byte1,          //addr 0x0027 [7:0]
input    [7:0]fan_tach5_byte2,          //addr 0x0028 [7:0]
input    [7:0]fan_tach5_byte1,          //addr 0x0029 [7:0]
input    [7:0]fan_tach6_byte2,          //addr 0x002A [7:0]
input    [7:0]fan_tach6_byte1,          //addr 0x002B [7:0]
input    [7:0]fan_tach7_byte2,          //addr 0x002C [7:0]
input    [7:0]fan_tach7_byte1,          //addr 0x002D [7:0]
input    [7:0]fan_tach8_byte2,          //addr 0x002E [7:0]
input    [7:0]fan_tach8_byte1,          //addr 0x002F [7:0]
input    [7:0]fan_tach9_byte2,          //addr 0x0030 [7:0]
input    [7:0]fan_tach9_byte1,          //addr 0x0031 [7:0]
input    [7:0]fan_tach10_byte2,         //addr 0x0032 [7:0]
input    [7:0]fan_tach10_byte1,         //addr 0x0033 [7:0]
input    [7:0]fan_tach11_byte2,         //addr 0x0034 [7:0]
input    [7:0]fan_tach11_byte1,         //addr 0x0035 [7:0]
input    [7:0]fan_tach12_byte2,         //addr 0x0036 [7:0]
input    [7:0]fan_tach12_byte1,         //addr 0x0037 [7:0]
input    [7:0]fan_tach13_byte2,         //addr 0x0038 [7:0]
input    [7:0]fan_tach13_byte1,         //addr 0x0039 [7:0]
input    [7:0]fan_tach14_byte2,         //addr 0x003A [7:0]
input    [7:0]fan_tach14_byte1,         //addr 0x003B [7:0]
input    [7:0]fan_tach15_byte2,         //addr 0x003C [7:0]
input    [7:0]fan_tach15_byte1,         //addr 0x003D [7:0]
input    [7:0]fan_tach16_byte2,         //addr 0x003E [7:0]
input    [7:0]fan_tach16_byte1,         //addr 0x003F [7:0]

output  [7:0]  duty_0,                  //addr 0x0040 [7:0]           
output  [7:0]  duty_1,                  //addr 0x0041 [7:0]            
output  [7:0]  duty_2,                  //addr 0x0042 [7:0]            
output  [7:0]  duty_3,                  //addr 0x0043 [7:0]            
output  [7:0]  duty_4,                  //addr 0x0044 [7:0]            
output  [7:0]  duty_5,                  //addr 0x0045 [7:0]           
output  [7:0]  duty_6,                  //addr 0x0046 [7:0]           
output  [7:0]  duty_7,                  //addr 0x0047 [7:0]  
*/

input   [1:0]  ps_prsnt,                //addr 0x0050 [1:0]
input   [1:0]  psu_smb_alert_n,         //addr 0x0052 [1:0]
input   [1:0]  ps_fail,                 //addr 0x0053 [1:0]
input   [1:0]  ps_dcok,                 //addr 0x0054 [1:0]
input          pal_gpu_fan4_foo,        //addr 0x0056 [3]
input          pal_gpu_fan3_foo,        //addr 0x0056 [2]
input          pal_gpu_fan2_foo,        //addr 0x0056 [1]
input          pal_gpu_fan1_foo,        //addr 0x0056 [0]
input          ocp2_fan_foo,            //addr 0x0057 [7]
input          ocp2_fan_prsnt,          //addr 0x0057 [6]
input          ocp1_fan_foo,            //addr 0x0057 [5]
input          ocp1_fan_prsnt,          //addr 0x0057 [4]
input          ocp2_fan_on_aux,         //addr 0x0057 [3]
input          ocp_fan_on_aux,          //addr 0x0057 [2]
input   [7:0]  fan_prsnt,               //addr 0x0058 [7:0] 
input   [3:0]  gpu_fan_prsnt,           //addr 0x0059 [3:0]

input   [3:0]  board2_type,             //addr 0x0070 [7:4]
input   [2:0]  board2_pcb_rev,          //addr 0x0070 [3:1]
input   [7:0]  bp_prsnt,                //addr 0x0071 [7:0]
input          ocp2_prsnt,              //addr 0x0072 [6]
input          ocp_prsnt,               //addr 0x0072 [4] 

input          riser2_prsnt,            //addr 0x0080 [2]
input          riser1_prsnt,            //addr 0x0080 [1]

input          cpu_nvme0_prsnt_n,       //addr 0x0090 [7]
input          cpu_nvme1_prsnt_n,       //addr 0x0090 [6]
input          cpu_nvme2_prsnt_n,       //addr 0x0090 [5]
input          cpu_nvme3_prsnt_n,       //addr 0x0090 [4]
input          cpu_nvme4_prsnt_n,       //addr 0x0090 [3]
input          cpu_nvme5_prsnt_n,       //addr 0x0090 [2]
input          cpu_nvme6_prsnt_n,       //addr 0x0090 [1]
input          cpu_nvme7_prsnt_n,       //addr 0x0090 [0]

input          cpu_nvme8_prsnt_n,       //addr 0x0091 [7]
input          cpu_nvme9_prsnt_n,       //addr 0x0091 [6]
input          cpu_nvme10_prsnt_n,      //addr 0x0091 [5]
input          cpu_nvme11_prsnt_n,      //addr 0x0091 [4]
input          cpu_nvme12_prsnt_n,      //addr 0x0091 [3]
input          cpu_nvme13_prsnt_n,      //addr 0x0091 [2]
input          cpu_nvme14_prsnt_n,      //addr 0x0091 [1]
input          cpu_nvme15_prsnt_n,      //addr 0x0091 [0]

input          cpu_nvme16_prsnt_n,      //addr 0x0092 [7]
input          cpu_nvme17_prsnt_n,      //addr 0x0092 [6]
input          cpu_nvme18_prsnt_n,      //addr 0x0092 [5]
input          cpu_nvme19_prsnt_n,      //addr 0x0092 [4]
input          cpu_nvme22_prsnt_n,      //addr 0x0092 [3]
input          cpu_nvme23_prsnt_n,      //addr 0x0092 [2]
input          cpu_nvme24_prsnt_n,      //addr 0x0092 [1]
input          cpu_nvme25_prsnt_n,      //addr 0x0092 [0]

input          power_on_off,            //addr 0x00A0 [6]
input    [5:0] power_seq_sm,            //addr 0x00A0 [5:0]


input          power_fault,             //addr 0x00A1 [6]           
input    [5:0] pwrseq_sm_fault_det,     //addr 0x00A1 [5:0]      
  
input    [7:0] pf_class0_b0,            //addr 0x00A2 [5:0]              
input    [7:0] pf_class0_b1,            //addr 0x00A3 [5:0]           
input    [7:0] pf_class0_b2,            //addr 0x00A4 [5:0]           
input    [7:0] pf_class0_b3,            //addr 0x00A5 [5:0]                  
input    [7:0] pf_class1_b0,            //addr 0x00A6 [5:0]          
input    [7:0] pf_class1_b1,            //addr 0x00A7 [5:0]          
input    [7:0] pf_class2_b0,            //addr 0x00A8 [5:0]          
input    [7:0] pf_class2_b1,            //addr 0x00A9 [5:0]           
input    [7:0] pf_class4_b0,            //addr 0x00AA [5:0]          
input    [7:0] pf_class5_b0,            //addr 0x00AC [5:0]           
input    [7:0] pf_class6_b0,            //addr 0x00AD [5:0]                 
input    [7:0] pf_class9_b0,            //addr 0x00AE [5:0]         
input    [7:0] pf_classa_b0,            //addr 0x00AF [5:0]         

input    [7:0] pdt_line,                //addr 0x00C2 [7:0]
input    [7:0] pdt_gen,                 //addr 0x00C3 [7:0]
input    [7:0] server_id,               //addr 0x00C5 [7:0]
input    [7:0] board_id,                //addr 0x00C6 [7:0]

input    [2:0] pcb_rev,                 //addr 0x00F1[2:0] 

output wire [7:0] i2c_ram_1050,         //addr 0x1050 [7:0] //default 0xff
output wire [7:0] i2c_ram_1051,         //addr 0x1051 [7:0] //default 0xff
output wire [7:0] i2c_ram_1052,         //addr 0x1052 [7:0] //default 0xff
output wire [7:0] i2c_ram_1053,         //addr 0x1053 [7:0] //default 0xff
output wire [7:0] i2c_ram_1054,         //addr 0x1054 [7:0] //default 0xff
input  wire [7:0] i2c_ram_1055,         //addr 0x1055 [7:0] //default 0xff
input  wire [7:0] i2c_ram_1056,         //addr 0x1056 [7:0] //default 0xff
input  wire [7:0] i2c_ram_1057,         //addr 0x1057 [7:0] //default 0xff
input  wire [7:0] i2c_ram_1058          //addr 0x1058 [7:0] //default 0xff
   
);
	
///////////////////////////////////////////////////////////////////////
//parameter VAL_FAN_WDT = 6'd5;

reg        fan_wdt_en         ;			//0x02.0    
reg        fan_wdt_feed       ;
reg        fan_wdt_timeout    ;			//0x02.2    
reg  [1:0] fan_wdt_timeout_r  ;
reg  [5:0] fan_wdt_cnt        ;
reg  [5:0] fan_wdt_timeout_cnt;//0x08.5-0    
reg  [2:0] fan_wdt_feed_r     ;//change by x14162 20220222
wire       fan_wdt_feed_p     ;
wire       fan_wdt_timeout_p  ;

wire [31:0] mb_cpld1_date = 32'h20240813;//`CPLD_DATE_YYYYMMDD;
wire [31:0] mb_cpld1_time = 32'h11200000;//`CPLD_TIME_HHMMSSXX;

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
wire [7:0] w_ram_0006;
wire [7:0] w_ram_0007;
wire [7:0] w_ram_0008;
wire [7:0] w_ram_0009;
wire [7:0] w_ram_000A;
wire [7:0] w_ram_000b;
//wire [7:0] w_ram_000c;
wire [7:0] w_ram_000d;
wire [7:0] w_ram_000e;
wire [7:0] w_ram_000f;
wire [7:0] w_ram_0010;  
//wire [7:0] w_ram_0011;  
//wire [7:0] w_ram_0012;
wire [7:0] w_ram_0013;
wire [7:0] w_ram_0015;
wire [7:0] w_ram_0016;
wire [7:0] w_ram_001D;
wire [7:0] w_ram_0020;
wire [7:0] w_ram_0021;
wire [7:0] w_ram_0022;
wire [7:0] w_ram_0023;
wire [7:0] w_ram_0024;
wire [7:0] w_ram_0025;
wire [7:0] w_ram_0026;
wire [7:0] w_ram_0027;
wire [7:0] w_ram_0028;
wire [7:0] w_ram_0029;
wire [7:0] w_ram_002A;
wire [7:0] w_ram_002B;
wire [7:0] w_ram_002C;
wire [7:0] w_ram_002D;
wire [7:0] w_ram_002E;
wire [7:0] w_ram_002F;
wire [7:0] w_ram_0030;
wire [7:0] w_ram_0031;
wire [7:0] w_ram_0032;
wire [7:0] w_ram_0033;
wire [7:0] w_ram_0034;  
wire [7:0] w_ram_0035;
wire [7:0] w_ram_0036;
wire [7:0] w_ram_0037;
wire [7:0] w_ram_0038;
wire [7:0] w_ram_0039;  
wire [7:0] w_ram_003A;
wire [7:0] w_ram_003B;
wire [7:0] w_ram_003C;
wire [7:0] w_ram_003D;
wire [7:0] w_ram_003E;
wire [7:0] w_ram_003F;
wire [7:0] w_ram_0050;
wire [7:0] w_ram_0052;
wire [7:0] w_ram_0053;
wire [7:0] w_ram_0054;
wire [7:0] w_ram_0056;
wire [7:0] w_ram_0057;
wire [7:0] w_ram_0058;
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
wire [7:0] w_ram_0070;
wire [7:0] w_ram_0071;
wire [7:0] w_ram_0072;
wire [7:0] w_ram_0073;
wire [7:0] w_ram_0080;
wire [7:0] w_ram_0090;
wire [7:0] w_ram_0091;
wire [7:0] w_ram_0092;
wire [7:0] w_ram_0093;
wire [7:0] w_ram_009C;
wire [7:0] w_ram_009D;
wire [7:0] w_ram_009E;
wire [7:0] w_ram_009F;
wire [7:0] w_ram_00A0;
wire [7:0] w_ram_00A1;
wire [7:0] w_ram_00A2;
wire [7:0] w_ram_00A3;
wire [7:0] w_ram_00A4;
wire [7:0] w_ram_00A5;
wire [7:0] w_ram_00A6;
wire [7:0] w_ram_00A7;
wire [7:0] w_ram_00A8;
wire [7:0] w_ram_00A9;
wire [7:0] w_ram_00AA;
wire [7:0] w_ram_00AC;
wire [7:0] w_ram_00AD;
wire [7:0] w_ram_00AE;
wire [7:0] w_ram_00AF;
wire [7:0] w_ram_00B0;
wire [7:0] w_ram_00C0;
wire [7:0] w_ram_00C2;
wire [7:0] w_ram_00C3;
wire [7:0] w_ram_00C5;
wire [7:0] w_ram_00C6;
wire [7:0] w_ram_00E0;
wire [7:0] w_ram_00F0;
wire [7:0] w_ram_00F1;
wire [7:0] w_ram_00F2;
wire [7:0] w_ram_00F3;
wire [7:0] w_ram_00F4;
wire [7:0] w_ram_00F5;
wire [7:0] w_ram_00F6;
wire [7:0] w_ram_00F7;
wire [7:0] w_ram_00F8;
wire [7:0] w_ram_00F9;
wire [7:0] w_ram_00FA;
wire [7:0] w_ram_00FB;
wire [7:0] w_ram_00FC;
wire [7:0] w_ram_00FD;
wire [7:0] w_ram_00FE;
wire [7:0] w_ram_00FF;
wire [7:0] w_ram_0103;
wire [7:0] w_ram_0104;
wire [7:0] w_ram_0105;//c00268 20220123 RDC:3691189
wire [7:0] w_ram_0110;
wire [7:0] w_ram_0111;
wire [7:0] w_ram_0120;
wire [7:0] w_ram_0121;
wire [7:0] w_ram_0260;
wire [7:0] w_ram_0271;//20220530 d00412
wire [7:0] w_ram_0290;
wire [7:0] w_ram_0291;
wire [7:0] w_ram_02A1;//20220106 c00268;idms:202201040006
wire [7:0] w_ram_02A3;
wire [7:0] w_ram_02A4;
wire [7:0] w_ram_02A8;
wire [7:0] w_ram_02AB;
wire [7:0] w_ram_02E0;
wire [7:0] w_ram_02E8;
wire [7:0] w_ram_0300;
wire [7:0] w_ram_0310;
wire [7:0] w_ram_0311;
wire [7:0] w_ram_0312;
wire [7:0] w_ram_03E0;
wire [7:0] w_ram_03F0;
wire [7:0] w_ram_0440;
wire [7:0] w_ram_0460;
wire [7:0] w_ram_0461;
wire [7:0] w_ram_0470;
wire [7:0] w_ram_0471;
wire [7:0] w_ram_04B0;
wire [7:0] w_ram_0560;
wire [7:0] w_ram_05D0;//20220528 d00412 rdc:3704704
wire [7:0] w_ram_0640;
wire [7:0] w_ram_0641;

wire [7:0] w_ram_1055;                                                        
wire [7:0] w_ram_1056;                                                        
wire [7:0] w_ram_1057;                                                        
wire [7:0] w_ram_1058; 
///////////////////////////////////////////////////////////////////////
//reg  BMC --->CPLD RAM
///////////////////////////////////////////////////////////////////////
reg [7:0] r_i2c_data_in;
reg [7:0] r_reg_0003;
reg [7:0] r_reg_0004;
reg [7:0] r_reg_0005;
reg [7:0] r_reg_0006;
reg [7:0] r_reg_0007;
reg [7:0] r_reg_0008;
reg [7:0] r_reg_0009;
reg [7:0] r_reg_000A;
reg [7:0] r_reg_000B;
reg [7:0] r_reg_0010;
reg [7:0] r_reg_0011;
reg [7:0] r_reg_0013;
reg [7:0] r_reg_0016;
reg [7:0] r_reg_0019;
reg [7:0] r_reg_001A;
reg [7:0] r_reg_001B;
reg [7:0] r_reg_001D;
reg [7:0] r_reg_0030;
reg [7:0] r_reg_0032;
reg [7:0] r_reg_0033;
reg [7:0] r_reg_0040;
reg [7:0] r_reg_0041;
reg [7:0] r_reg_0042;
reg [7:0] r_reg_0043;
reg [7:0] r_reg_0044;
reg [7:0] r_reg_0045;
reg [7:0] r_reg_0046;
reg [7:0] r_reg_0047;
reg [7:0] r_reg_00A0;
reg [7:0] r_reg_00D1;
reg [7:0] r_reg_00D2;
reg [7:0] r_reg_00D3;
reg [7:0] r_reg_00D4;
reg [7:0] r_reg_00F2;
//reg [7:0] r_reg_0100;
reg [7:0] r_reg_0101;
reg [7:0] r_reg_0102;
reg [7:0] r_reg_0105;
reg [7:0] r_reg_0120;
reg [7:0] r_reg_0130;
//reg [7:0] r_reg_0140;  //20220915 d00412
reg [7:0] r_reg_0141;
reg [7:0] r_reg_0142;
reg [7:0] r_reg_0143;
reg [7:0] r_reg_0270;
reg [7:0] r_reg_02A1;//20220106 c00268;idms:202201060004
reg [7:0] r_reg_02A2;//c00268 rdc:3706081
reg [7:0] r_reg_02A8;//20220106 c00268;idms:202201060004
reg [7:0] r_reg_02A9;//c00268 rdc:3706081
reg [7:0] r_reg_02C0;//20220106 c00268;idms:202201060004
reg [7:0] r_reg_0312;
reg [7:0] r_reg_03A0;
reg [7:0] r_reg_03A1;//20220106 c00268;idms:202201060004
reg [7:0] r_reg_04D0;
reg [7:0] r_reg_04D1;
reg [7:0] r_reg_04D2;
//reg [7:0] r_reg_0500;//20220106 c00268;idms:202201040006  //20220915 d00412
reg [7:0] r_reg_0641;
reg [7:0] r_reg_0800;
reg [7:0] r_reg_1050;
reg [7:0] r_reg_1051;                                                         
reg [7:0] r_reg_1052;                                                         
reg [7:0] r_reg_1053;                                                         
reg [7:0] r_reg_1054;


assign vwire_bmc_wakeup     = r_reg_0003[6];
assign vwire_bmc_sysrst     = r_reg_0003[5];
assign vwire_bmc_shutdown   = r_reg_0003[4];
assign rst_btn_mask         = r_reg_0003[0];

assign bmc_ctrl_shutdown    = r_reg_0004[6];
assign aux_pcycle           = r_reg_0004[4];
assign pwrbtn_bl_mask       = r_reg_0004[3];
assign vwire_pwrbtn_bl      = r_reg_0004[2];
assign physical_pwrbtn_mask = r_reg_0004[1];

assign bmc_uid_update       = r_reg_0005[7];

assign wol_en               = r_reg_0006[3];
assign sideband_sel         = r_reg_0006[1:0];

assign rom_mux_bios_bmc_en  = r_reg_0007[7];
assign rom_mux_bios_bmc_sel = r_reg_0007[6];
assign rom_bios_bk_rst      = r_reg_0007[3];
assign rom_bios_ma_rst      = r_reg_0007[2];
assign rom_bmc_bk_rst       = r_reg_0007[1];
assign rom_bmc_ma_rst       = r_reg_0007[0];

assign test_bat_en          = r_reg_0008[7];
assign bios_eeprom_wp       = r_reg_0008[6];

assign o_uid_led_ctl        = r_reg_0009[7:0];

assign o_uid_btn_evt_clr    = r_reg_000A[1];       
assign o_uid_rstbmc_evt_clr = r_reg_000A[0];

assign bmcctl_front_nic_led = r_reg_000B[2];
assign o_sys_healthy_red    = r_reg_000B[1];
assign o_sys_healthy_grn    = r_reg_000B[0];

assign rtc_select_n         = r_reg_0010[4];
assign vga2_dis             = r_reg_0010[3];

assign bmc_read_flag        = r_reg_0013[6];

assign bmcctl_uart_sw       = r_reg_0016[7:6];

assign bmc_i2c_rst          = r_reg_0019[7:0];
assign bmc_i2c_rst2         = r_reg_001A[7:0];
assign bmc_i2c_rst3         = r_reg_001B[7:0];

assign tpm_rst              = r_reg_001D[6];

// assign duty_0               = r_reg_0040[7:0];
// assign duty_1               = r_reg_0041[7:0];
// assign duty_2               = r_reg_0042[7:0];
// assign duty_3               = r_reg_0043[7:0];
// assign duty_4               = r_reg_0044[7:0];
// assign duty_5               = r_reg_0045[7:0];
// assign duty_6               = r_reg_0046[7:0];
// assign duty_7               = r_reg_0047[7:0];

assign i2c_ram_1050         = r_reg_1050[7:0];
assign i2c_ram_1051         = r_reg_1051[7:0];
assign i2c_ram_1052         = r_reg_1052[7:0];
assign i2c_ram_1053         = r_reg_1053[7:0];
assign i2c_ram_1054         = r_reg_1054[7:0];

/////////////////////////////////////////////////////////////////////////
//read byte from cpld
////////////////////////////////////////////////////////////////////////
assign w_ram_0000 = {1'b0,bmc_security_bypass,6'b0};
assign w_ram_0002 = {1'b0,cpld_pwm_main_type,fan_wdt_sel,1'b0,fan_wdt_timeout,fm_bmc_fan_wdt_feed,fan_wdt_en};
assign w_ram_0003 = {1'b0,vwire_bmc_wakeup,vwire_bmc_sysrst,vwire_bmc_shutdown,pwr_btn_state,rst_btn_state,1'b0,rst_btn_mask};
assign w_ram_0004 = {1'b0,bmc_ctrl_shutdown,1'b0,aux_pcycle,pwrbtn_bl_mask,vwire_pwrbtn_bl,physical_pwrbtn_mask,st_steady_pwrok};
assign w_ram_0005 = {bmc_uid_update,7'b0};
assign w_ram_0006 = {4'b0,wol_en,1'b0,sideband_sel};
assign w_ram_0007 = {rom_mux_bios_bmc_en,rom_mux_bios_bmc_sel,2'b0,rom_bios_bk_rst,rom_bios_ma_rst,rom_bmc_bk_rst,rom_bmc_ma_rst};
assign w_ram_0008 = {test_bat_en,bios_eeprom_wp,fan_wdt_timeout_cnt[5:0]};
assign w_ram_0009 = 8'b0;
assign w_ram_000A = {6'b0,i_uid_btn_evt,i_uid_rstbmc_evt};
assign w_ram_000d = port_80;
assign w_ram_000e = port_84;
assign w_ram_000f = lpc_io_data_port85;
assign w_ram_0010 = {3'b0,rtc_select_n,vga2_dis,2'b0,cpu0_d0_bios_over};
assign w_ram_0013 = {bios_read_flag,bmc_read_flag,6'b0};
assign w_ram_0015 = {3'b0,m2_slot2_type,m2_slot1_type,m2_slot2_prsnt,m2_slot1_prsnt,m2_card_prsnt};
assign w_ram_0016 = {bmcctl_uart_sw,6'b0};
assign w_ram_001D = {tpm_rst,tpm_prsnt,intruder,intruder_cable_prsnt,dsd_prsnt,3'b0};
// assign w_ram_0020 = fan_tach1_byte2;
// assign w_ram_0021 = fan_tach1_byte1;
// assign w_ram_0022 = fan_tach2_byte2;
// assign w_ram_0023 = fan_tach2_byte1;
// assign w_ram_0024 = fan_tach3_byte2;
// assign w_ram_0025 = fan_tach3_byte1;
// assign w_ram_0026 = fan_tach4_byte2;
// assign w_ram_0027 = fan_tach4_byte1;
// assign w_ram_0028 = fan_tach5_byte2;
// assign w_ram_0029 = fan_tach5_byte1;
// assign w_ram_002A = fan_tach6_byte2;
// assign w_ram_002B = fan_tach6_byte1;
// assign w_ram_002C = fan_tach7_byte2;
// assign w_ram_002D = fan_tach7_byte1;
// assign w_ram_002E = fan_tach8_byte2;
// assign w_ram_002F = fan_tach8_byte1;
// assign w_ram_0030 = fan_tach9_byte2;
// assign w_ram_0031 = fan_tach9_byte1;
// assign w_ram_0032 = fan_tach10_byte2;
// assign w_ram_0033 = fan_tach10_byte1;
// assign w_ram_0034 = fan_tach11_byte2;
// assign w_ram_0035 = fan_tach11_byte1;
// assign w_ram_0036 = fan_tach12_byte2;
// assign w_ram_0037 = fan_tach12_byte1;
// assign w_ram_0038 = fan_tach13_byte2;
// assign w_ram_0039 = fan_tach13_byte1;
// assign w_ram_003A = fan_tach14_byte2;
// assign w_ram_003B = fan_tach14_byte1;
// assign w_ram_003C = fan_tach15_byte2;
// assign w_ram_003D = fan_tach15_byte1;
// assign w_ram_003E = fan_tach16_byte2;
// assign w_ram_003F = fan_tach16_byte1;
assign w_ram_0050 = {6'b0,ps_prsnt[1:0]};
assign w_ram_0052 = {6'b0,psu_smb_alert_n[1:0]};
assign w_ram_0053 = {6'b0,ps_fail[1:0]};
assign w_ram_0054 = {6'b0,ps_dcok[1:0]};
assign w_ram_0056 = {4'b0,pal_gpu_fan4_foo,pal_gpu_fan3_foo,pal_gpu_fan2_foo,pal_gpu_fan1_foo};
assign w_ram_0057 = {ocp2_fan_foo,ocp2_fan_prsnt,ocp1_fan_foo,ocp1_fan_prsnt,ocp2_fan_on_aux,ocp_fan_on_aux,2'b0};
assign w_ram_0058 = fan_prsnt;
assign w_ram_0059 = {4'b0,gpu_fan_prsnt[3:0]};
assign w_ram_0070 = {board2_type,board2_pcb_rev,1'b0};
assign w_ram_0071 = bp_prsnt;
assign w_ram_0072 = {ocp2_fan_on_aux,ocp2_prsnt,ocp_fan_on_aux,ocp_prsnt,4'b0};
assign w_ram_0080 = {6'b0,riser2_prsnt,riser1_prsnt};
assign w_ram_0090 = {cpu_nvme0_prsnt_n,cpu_nvme1_prsnt_n,cpu_nvme2_prsnt_n,cpu_nvme3_prsnt_n,cpu_nvme4_prsnt_n,cpu_nvme5_prsnt_n,cpu_nvme6_prsnt_n,cpu_nvme7_prsnt_n};
assign w_ram_0091 = {cpu_nvme8_prsnt_n,cpu_nvme9_prsnt_n,cpu_nvme10_prsnt_n,cpu_nvme11_prsnt_n,cpu_nvme12_prsnt_n,cpu_nvme13_prsnt_n,cpu_nvme14_prsnt_n,cpu_nvme15_prsnt_n};
assign w_ram_0092 = {cpu_nvme16_prsnt_n,cpu_nvme17_prsnt_n,cpu_nvme18_prsnt_n,cpu_nvme19_prsnt_n,cpu_nvme22_prsnt_n,cpu_nvme23_prsnt_n,cpu_nvme24_prsnt_n,cpu_nvme25_prsnt_n};
assign w_ram_00A0 = {st_steady_pwrok, power_on_off, power_seq_sm};
assign w_ram_00A1 = {1'b0,power_fault,pwrseq_sm_fault_det};
assign w_ram_00A2 = pf_class0_b0;
assign w_ram_00A3 = pf_class0_b1;
assign w_ram_00A4 = pf_class0_b2;
assign w_ram_00A5 = pf_class0_b3;
assign w_ram_00A6 = pf_class1_b0;
assign w_ram_00A7 = pf_class1_b1;
assign w_ram_00A8 = pf_class2_b0;
assign w_ram_00A9 = pf_class2_b1;
assign w_ram_00AA = pf_class4_b0;
assign w_ram_00AC = pf_class5_b0;
assign w_ram_00AD = pf_class6_b0;
assign w_ram_00AE = pf_class9_b0;
assign w_ram_00AF = pf_classa_b0;
assign w_ram_00C2 = pdt_line;
assign w_ram_00C3 = pdt_gen;
assign w_ram_00C5 = server_id;
assign w_ram_00C6 = board_id;
assign w_ram_00F1 = {5'b0,pcb_rev};
assign w_ram_00F2 = mb_cpld1_date[31:24];
assign w_ram_00F3 = mb_cpld1_date[23:16];
assign w_ram_00F4 = mb_cpld1_date[15:8];
assign w_ram_00F5 = mb_cpld1_date[7:0];
assign w_ram_00F6 = mb_cpld1_time[31:24]; 
assign w_ram_00F7 = mb_cpld1_time[23:16];
assign w_ram_00F8 = mb_cpld1_time[15:8];
assign w_ram_00F9 = mb_cpld1_time[7:0];

assign w_ram_00FB = bmc_cpld_version[15:8];
assign w_ram_00FC = mb_cpld2_ver[7:0];
assign w_ram_00FD = mb_cpld2_ver[15:8];
assign w_ram_00FE = mb_cpld1_ver[7:0];
assign w_ram_00FF = mb_cpld1_ver[15:8];
				
assign w_ram_1055 = i2c_ram_1055; //2024-3-23 add
assign w_ram_1056 = i2c_ram_1056;
assign w_ram_1057 = i2c_ram_1057;
assign w_ram_1058 = i2c_ram_1058;

				
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
	16'h0006: r_i2c_data_in  <= w_ram_0006;  
	16'h0007: r_i2c_data_in  <= w_ram_0007;  
	16'h0008: r_i2c_data_in  <= w_ram_0008;  
	16'h0009: r_i2c_data_in  <= r_reg_0009;
	16'h000A: r_i2c_data_in  <= w_ram_000A;
	16'h000B: r_i2c_data_in  <= r_reg_000B;  
  //16'h000c: r_i2c_data_in  <= w_ram_000c; 
    16'h000d: r_i2c_data_in  <= w_ram_000d;
	16'h000e: r_i2c_data_in  <= w_ram_000e;
	16'h000f: r_i2c_data_in  <= w_ram_000f;
    16'h0010: r_i2c_data_in  <= w_ram_0010;    
	16'h0011: r_i2c_data_in  <= ~r_reg_0011;  
  //16'h0012: r_i2c_data_in  <= w_ram_0012;
	16'h0013: r_i2c_data_in  <= w_ram_0013;
	16'h0015: r_i2c_data_in  <= w_ram_0015;
	16'h0016: r_i2c_data_in  <= w_ram_0016;
	16'h0019: r_i2c_data_in  <= r_reg_0019;
	16'h001A: r_i2c_data_in  <= r_reg_001A;
	16'h001B: r_i2c_data_in  <= r_reg_001B;
	16'h001D: r_i2c_data_in  <= w_ram_001D;
	16'h0020: r_i2c_data_in  <= w_ram_0020;
	16'h0021: r_i2c_data_in  <= w_ram_0021;
	16'h0022: r_i2c_data_in  <= w_ram_0022;
	16'h0023: r_i2c_data_in  <= w_ram_0023;
	16'h0024: r_i2c_data_in  <= w_ram_0024;
	16'h0025: r_i2c_data_in  <= w_ram_0025;
	16'h0026: r_i2c_data_in  <= w_ram_0026;
	16'h0027: r_i2c_data_in  <= w_ram_0027;
	16'h0028: r_i2c_data_in  <= w_ram_0028;
	16'h0029: r_i2c_data_in  <= w_ram_0029;
	16'h002A: r_i2c_data_in  <= w_ram_002A;
	16'h002B: r_i2c_data_in  <= w_ram_002B;
	16'h002C: r_i2c_data_in  <= w_ram_002C;
	16'h002D: r_i2c_data_in  <= w_ram_002D;
	16'h002E: r_i2c_data_in  <= w_ram_002E;
	16'h002F: r_i2c_data_in  <= w_ram_002F;
	16'h0030: r_i2c_data_in  <= w_ram_0030;
	16'h0031: r_i2c_data_in  <= w_ram_0031;
	16'h0032: r_i2c_data_in  <= w_ram_0032;
	16'h0033: r_i2c_data_in  <= w_ram_0033;
	16'h0034: r_i2c_data_in  <= w_ram_0034;
	16'h0035: r_i2c_data_in  <= w_ram_0035;
	16'h0036: r_i2c_data_in  <= w_ram_0036;
	16'h0037: r_i2c_data_in  <= w_ram_0037;
	16'h0038: r_i2c_data_in  <= w_ram_0038;
	16'h0039: r_i2c_data_in  <= w_ram_0039;
	16'h003A: r_i2c_data_in  <= w_ram_003A;
	16'h003B: r_i2c_data_in  <= w_ram_003B;
	16'h003C: r_i2c_data_in  <= w_ram_003C;
	16'h003D: r_i2c_data_in  <= w_ram_003D;	
	16'h003E: r_i2c_data_in  <= w_ram_003E;
	16'h003F: r_i2c_data_in  <= w_ram_003F;	
	16'h0040: r_i2c_data_in  <= r_reg_0040;
	16'h0041: r_i2c_data_in  <= r_reg_0041;
	16'h0042: r_i2c_data_in  <= r_reg_0042;
	16'h0043: r_i2c_data_in  <= r_reg_0043;
	16'h0044: r_i2c_data_in  <= r_reg_0044;
	16'h0045: r_i2c_data_in  <= r_reg_0045;
	16'h0046: r_i2c_data_in  <= r_reg_0046;
	16'h0047: r_i2c_data_in  <= r_reg_0047;
    16'h0050: r_i2c_data_in  <= w_ram_0050;
	16'h0052: r_i2c_data_in  <= w_ram_0052;
	16'h0053: r_i2c_data_in  <= w_ram_0053;
	16'h0054: r_i2c_data_in  <= w_ram_0054;
    16'h0056: r_i2c_data_in  <= w_ram_0056;	
	16'h0057: r_i2c_data_in  <= w_ram_0057;
	16'h0058: r_i2c_data_in  <= w_ram_0058;
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
	16'h0070: r_i2c_data_in  <= w_ram_0070;
	16'h0071: r_i2c_data_in  <= w_ram_0071;
	16'h0072: r_i2c_data_in  <= w_ram_0072;
	16'h0073: r_i2c_data_in  <= w_ram_0073;
	16'h0080: r_i2c_data_in  <= w_ram_0080;
	16'h0090: r_i2c_data_in  <= w_ram_0090;
	16'h0091: r_i2c_data_in  <= w_ram_0091; 
	16'h0092: r_i2c_data_in  <= w_ram_0092; 
	16'h0093: r_i2c_data_in  <= w_ram_0093; 
	16'h009C: r_i2c_data_in  <= w_ram_009C;
	16'h009D: r_i2c_data_in  <= w_ram_009D;
	16'h009E: r_i2c_data_in  <= w_ram_009E;
	16'h00A0: r_i2c_data_in  <= w_ram_00A0;
	16'h00A1: r_i2c_data_in  <= w_ram_00A1;
	16'h00A2: r_i2c_data_in  <= w_ram_00A2;
	16'h00A3: r_i2c_data_in  <= w_ram_00A3;
	16'h00A4: r_i2c_data_in  <= w_ram_00A4;
	16'h00A5: r_i2c_data_in  <= w_ram_00A5;
	16'h00A6: r_i2c_data_in  <= w_ram_00A6;
	16'h00A7: r_i2c_data_in  <= w_ram_00A7;
	16'h00A8: r_i2c_data_in  <= w_ram_00A8;
	16'h00A9: r_i2c_data_in  <= w_ram_00A9;
	16'h00AA: r_i2c_data_in  <= w_ram_00AA;
	16'h00AC: r_i2c_data_in  <= w_ram_00AC;
	16'h00AD: r_i2c_data_in  <= w_ram_00AD;
	16'h00AE: r_i2c_data_in  <= w_ram_00AE;
	16'h00AF: r_i2c_data_in  <= w_ram_00AF;	
	16'h00B0: r_i2c_data_in  <= w_ram_00B0;
	16'h00C0: r_i2c_data_in  <= w_ram_00C0;
	16'h00C2: r_i2c_data_in  <= w_ram_00C2;
	16'h00C3: r_i2c_data_in  <= w_ram_00C3;
	16'h00C5: r_i2c_data_in  <= w_ram_00C5;
	16'h00C6: r_i2c_data_in  <= w_ram_00C6;
	16'h00D1: r_i2c_data_in  <= r_reg_00D1;
	16'h00D2: r_i2c_data_in  <= r_reg_00D2;
	16'h00D4: r_i2c_data_in  <= r_reg_00D4;
	16'h00E0: r_i2c_data_in  <= w_ram_00E0;
	16'h00F0: r_i2c_data_in  <= w_ram_00F0;
	16'h00F1: r_i2c_data_in  <= w_ram_00F1;
	16'h00F2: r_i2c_data_in  <= w_ram_00F2;
	16'h00F3: r_i2c_data_in  <= w_ram_00F3;
	16'h00F4: r_i2c_data_in  <= w_ram_00F4;
	16'h00F5: r_i2c_data_in  <= w_ram_00F5;
	16'h00F6: r_i2c_data_in  <= w_ram_00F6;
	16'h00F7: r_i2c_data_in  <= w_ram_00F7;
	16'h00F8: r_i2c_data_in  <= w_ram_00F8;
	16'h00F9: r_i2c_data_in  <= w_ram_00F9;	
	16'h00FA: r_i2c_data_in  <= w_ram_00FA;
	16'h00FB: r_i2c_data_in  <= w_ram_00FB;
	16'h00FC: r_i2c_data_in  <= w_ram_00FC;
	16'h00FD: r_i2c_data_in  <= w_ram_00FD;
	16'h00FE: r_i2c_data_in  <= w_ram_00FE;
	16'h00FF: r_i2c_data_in  <= w_ram_00FF;
	//16'h0100: r_i2c_data_in  <= r_reg_0100;
	16'h0101: r_i2c_data_in  <= r_reg_0101;
	16'h0102: r_i2c_data_in  <= r_reg_0102;
	16'h0103: r_i2c_data_in  <= w_ram_0103;
	16'h0104: r_i2c_data_in  <= w_ram_0104;
	16'h0105: r_i2c_data_in  <= w_ram_0105;//c00268 20220123 RDC:3691189
	16'h0110: r_i2c_data_in  <= w_ram_0110;
	16'h0111: r_i2c_data_in  <= w_ram_0111;
	16'h0120: r_i2c_data_in  <= w_ram_0120;
	16'h0121: r_i2c_data_in  <= w_ram_0121;
	16'h0130: r_i2c_data_in  <= r_reg_0130;
	//16'h0140: r_i2c_data_in  <= r_reg_0140;  //20220915 d00412
	16'h0141: r_i2c_data_in  <= r_reg_0141;
	16'h0142: r_i2c_data_in  <= r_reg_0142;
	16'h0143: r_i2c_data_in  <= r_reg_0143;
	16'h0260: r_i2c_data_in  <= w_ram_0260;
	16'h0270: r_i2c_data_in  <= r_reg_0270;
	16'h0271: r_i2c_data_in  <= w_ram_0271;  //20220530 d00412
	16'h0290: r_i2c_data_in  <= w_ram_0290;
	16'h0291: r_i2c_data_in  <= w_ram_0291;
	16'h02A1: r_i2c_data_in  <= w_ram_02A1;	 //20220106 c00268;idms:202201040006
	16'h02A2: r_i2c_data_in  <= r_reg_02A2;  //c00268 rdc:3706081
	16'h02A9: r_i2c_data_in  <= r_reg_02A9;  //c00268 rdc:3706081	
	16'h02A3: r_i2c_data_in  <= w_ram_02A3;	
	16'h02A4: r_i2c_data_in  <= w_ram_02A4;
	16'h02AB: r_i2c_data_in  <= w_ram_02AB;
	16'h02A8: r_i2c_data_in  <= w_ram_02A8;
	16'h02C0: r_i2c_data_in  <= r_reg_02C0;	//20220106 c00268;idms:202201040006
	16'h02E0: r_i2c_data_in  <= w_ram_02E0;
	16'h02E8: r_i2c_data_in  <= w_ram_02E8;
	16'h0300: r_i2c_data_in  <= w_ram_0300;
	16'h0310: r_i2c_data_in  <= w_ram_0310;
	16'h0311: r_i2c_data_in  <= w_ram_0311;
	16'h0312: r_i2c_data_in  <= w_ram_0312;
	16'h03A0: r_i2c_data_in  <= r_reg_03A0;
	16'h03A1: r_i2c_data_in  <= r_reg_03A1; //20220111 c00268;idms:202201040006
	16'h03E0: r_i2c_data_in  <= w_ram_03E0;
	16'h03F0: r_i2c_data_in  <= w_ram_03F0;
	16'h0440: r_i2c_data_in  <= w_ram_0440;
	16'h0460: r_i2c_data_in  <= w_ram_0460;
	16'h0461: r_i2c_data_in  <= w_ram_0461;
	16'h0470: r_i2c_data_in  <= w_ram_0470;
	16'h0471: r_i2c_data_in  <= w_ram_0471;
	16'h04B0: r_i2c_data_in  <= w_ram_04B0;
	16'h04D0: r_i2c_data_in  <= r_reg_04D0;
	16'h04D1: r_i2c_data_in  <= r_reg_04D1;
	16'h04D2: r_i2c_data_in  <= r_reg_04D2;
	16'h0560: r_i2c_data_in  <= w_ram_0560;
	16'h05D0: r_i2c_data_in  <= w_ram_05D0; 
	16'h0640: r_i2c_data_in  <= w_ram_0640;
	16'h0641: r_i2c_data_in  <= r_reg_0641;
	16'h0800: r_i2c_data_in  <= r_reg_0800; 
	16'h1050: r_i2c_data_in  <= r_reg_1050;//RW
	16'h1051: r_i2c_data_in  <= r_reg_1051;//RW
	16'h1052: r_i2c_data_in  <= r_reg_1052;//RW
	16'h1053: r_i2c_data_in  <= r_reg_1053;//RW
	16'h1054: r_i2c_data_in  <= r_reg_1054;//RW
    16'h1055: r_i2c_data_in  <= w_ram_1055;//RO 
    16'h1056: r_i2c_data_in  <= w_ram_1056;//RO
    16'h1057: r_i2c_data_in  <= w_ram_1057;//RO
    16'h1058: r_i2c_data_in  <= w_ram_1058;//RO

	default: r_i2c_data_in <= 8'h00;
	endcase
	end
end
 

///////////////////////////////////////////////////////////////////////
//write data to cpld
///////////////////////////////////////////////////////////////////////
//0x0003
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0003  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0003) && w_data_vld_pos)  begin
        r_reg_0003  <= w_i2c_data_out;
    end
end

//0x0004
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0004  <=8'h40;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0004) && w_data_vld_pos)  begin
        r_reg_0004  <= w_i2c_data_out;
    end
end

//0x0005
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0005  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0005) && w_data_vld_pos)  begin
        r_reg_0005  <= w_i2c_data_out;
    end
end

//0x0006
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0006  <=8'h01;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0006) && w_data_vld_pos)  begin
        r_reg_0006  <= w_i2c_data_out;
    end
end

//0x0007
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0007  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0007) && w_data_vld_pos)  begin
        r_reg_0007  <= w_i2c_data_out;
    end
end

//0x0008
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0008  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0008) && w_data_vld_pos)  begin
        r_reg_0008  <= w_i2c_data_out;
    end
end

//0x0009
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0009  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0009) && w_data_vld_pos)  begin
        r_reg_0009  <= w_i2c_data_out;
    end
end

//0x000A
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_000A  <=8'hff;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h000A) && w_data_vld_pos)  begin
        r_reg_000A  <= w_i2c_data_out;
    end
	else if(~i_uid_btn_evt) begin
		r_reg_000A[1] <= 1'b1;
    end
	else if(~i_uid_rstbmc_evt) begin
		r_reg_000A[0] <= 1'b1;
	end	
end

//0x000B
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_000B  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h000B) && w_data_vld_pos)  begin
        r_reg_000B  <= w_i2c_data_out;
    end
end

//0x0010
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0010  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0010) && w_data_vld_pos)  begin
        r_reg_0010  <= w_i2c_data_out;
    end
end

//0x0011
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0011  <=8'hff;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0011) && w_data_vld_pos)  begin
        r_reg_0011  <= w_i2c_data_out;
    end
end

//0x0013
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0013  <=8'h40;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0013) && w_data_vld_pos)  begin
        r_reg_0013  <= w_i2c_data_out;
    end
end

//0x0016
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0016  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0016) && w_data_vld_pos)  begin
        r_reg_0016  <= w_i2c_data_out;
    end
end

//0x0019
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0019  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0019) && w_data_vld_pos)  begin
        r_reg_0019  <= w_i2c_data_out;
    end
end

//0x001A
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_001A  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h001A) && w_data_vld_pos)  begin
        r_reg_001A  <= w_i2c_data_out;
    end
end

//0x001B
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_001B  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h001B) && w_data_vld_pos)  begin
        r_reg_001B  <= w_i2c_data_out;
    end
end

//0x001D
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_001D  <=8'h00;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h001D) && w_data_vld_pos)  begin
        r_reg_001D  <= w_i2c_data_out;
    end
end

//0x0040
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0040  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0040) && w_data_vld_pos)  begin
        r_reg_0040  <= w_i2c_data_out;
    end
end

//0x0041
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0041  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0041) && w_data_vld_pos)  begin
        r_reg_0041  <= w_i2c_data_out;
    end
end

//0x0042
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0042  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0042) && w_data_vld_pos)  begin
        r_reg_0042  <= w_i2c_data_out;
    end
end

//0x0043
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0043  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0043) && w_data_vld_pos)  begin
        r_reg_0043  <= w_i2c_data_out;
    end
end

//0x0044
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0044  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0044) && w_data_vld_pos)  begin
        r_reg_0044  <= w_i2c_data_out;
    end
end

//0x0045
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0045  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0045) && w_data_vld_pos)  begin
        r_reg_0045  <= w_i2c_data_out;
    end
end

//0x0046
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0046  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0046) && w_data_vld_pos)  begin
        r_reg_0046  <= w_i2c_data_out;
    end
end

//0x0047
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_0047  <=8'h33;
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h0047) && w_data_vld_pos)  begin
        r_reg_0047  <= w_i2c_data_out;
    end
end

//0x1050
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1050  <=8'hff; 
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h1050) && w_data_vld_pos)  begin
        r_reg_1050  <= w_i2c_data_out;
    end
end

//0x1051
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1051  <=8'hff; 
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h1051) && w_data_vld_pos)  begin
        r_reg_1051  <= w_i2c_data_out;
    end
end

//0x1052
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1052  <=8'hff; 
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h1052) && w_data_vld_pos)  begin
        r_reg_1052  <= w_i2c_data_out;
    end
end

//0x1053
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1053  <=8'hff; 
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h1053) && w_data_vld_pos)  begin
        r_reg_1053  <= w_i2c_data_out;
    end
end

//0x1054
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1054  <=8'hff; 
    end
    else if((w_WR==1'b0)&&(w_i2c_command==16'h1054) && w_data_vld_pos)  begin
        r_reg_1054  <= w_i2c_data_out;
    end
end























always@(posedge i_clk or negedge pgoodaux) 
  begin
    if (!pgoodaux)
      fan_wdt_feed_r[2:0] <= 3'b0;
    else if (pon_reset_sasd)
      fan_wdt_feed_r[2:0] <= 3'b0;
    else 
      fan_wdt_feed_r[2:0] <= {fan_wdt_feed_r[1:0], fm_bmc_fan_wdt_feed};
  end

  assign fan_wdt_feed_p =(fan_wdt_feed_r[2:1]==2'b01) | (fan_wdt_feed_r[2:1]==2'b10);
  
  always@(posedge i_clk or negedge pgoodaux)
  begin
   if (!pgoodaux)
      fan_wdt_en <= 1'b0;
    else if (pon_reset_sasd)
      fan_wdt_en <= 1'b0;
         else if (fan_wdt_feed_p)
      fan_wdt_en <= 1'b1;
         else if (fan_wdt_en)
           fan_wdt_en <= fan_wdt_en;
  end
//------------------------------------------------------------------------------
  always@(posedge i_clk or negedge pgoodaux)
  begin
    if (!pgoodaux)
      fan_wdt_cnt <= 6'b0;
    else if (pon_reset_sasd)
      fan_wdt_cnt <= 6'b0;
    else if (fan_wdt_en) begin
      if (fan_wdt_feed_p)
        fan_wdt_cnt <= 6'b0;
      else if (t1s) begin
        if (fan_wdt_cnt==6'h3F)
          fan_wdt_cnt <= fan_wdt_cnt;
        else
          fan_wdt_cnt <= fan_wdt_cnt + 1'b1;
      end
    end
    else
      fan_wdt_cnt <= 6'b0;
  end

  always@(posedge i_clk or negedge pgoodaux)
  begin
    if (!pgoodaux)
      fan_wdt_timeout <= 1'b0;
    else if (pon_reset_sasd)
      fan_wdt_timeout <= 1'b0;
    else if (fan_wdt_en) begin
      if (fan_wdt_cnt==6'b0)
        fan_wdt_timeout <= 1'b0;
      else if (fan_wdt_cnt==6'd5)//VAL_FAN_WDT
        fan_wdt_timeout <= 1'b1;
    end
    else
      fan_wdt_timeout <= 1'b0;
  end

  always@(posedge i_clk or negedge pgoodaux)
  begin
    if (!pgoodaux)
      fan_wdt_timeout_r[1:0] <= 2'b00;
    else if (pon_reset_sasd)
      fan_wdt_timeout_r[1:0] <= 2'b00;
    else
      fan_wdt_timeout_r[1:0] <= {fan_wdt_timeout_r[0], fan_wdt_timeout};
  end

  assign fan_wdt_timeout_p = (fan_wdt_timeout_r[1:0]==2'b01);

  always@(posedge i_clk or negedge pgoodaux)
  begin
    if (!pgoodaux)
      fan_wdt_timeout_cnt <= 8'b0;
    else if (pon_reset_sasd)
      fan_wdt_timeout_cnt <= 8'b0;
    else if (fan_wdt_timeout_p)
      fan_wdt_timeout_cnt <= fan_wdt_timeout_cnt + 1'b1;
  end

/*
always@(posedge i_clk or negedge pgoodaux)//0-CPLD, 1-BMC
  begin
    if (!pgoodaux)
      fan_wdt_sel <= 1'b0;
    else if (pon_reset_sasd)
      fan_wdt_sel <= 1'b0;
    else if (ilo_hard_reset)
      fan_wdt_sel <= 1'b0;
    else if (fan_wdt_en) begin
      if (fan_wdt_timeout)
      fan_wdt_sel <= 1'b0;
      else
      fan_wdt_sel <=1'b1 ;//BMC
    end
    else
      fan_wdt_sel <= 1'b0;
  end
*/
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