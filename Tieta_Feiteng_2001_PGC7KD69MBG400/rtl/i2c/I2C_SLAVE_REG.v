//V001B0 w22909 20220831 IIO V1.5 to V1.6
//20221204  Wangqilong  1.1    PCIe bandwidth&Slot loop back scheme.

`include "as03mb03_define.v" 
module I2C_SLAVE_REG 
(
    input             rc_reset_n,
	//input			  sys_reset_n,
    input             clk,

    input       [7:0] reg_addr,
    output reg  [7:0] rdata,
    input             wrdata_en,
    input       [7:0] wrdata,
    
    output 		[5:0] test_pin,
	
	output      [7:0] o_usb_en,
	
	output 		[7:0] o_bios_read_rtc,
	
	output 		[7:0] o_bios_post_80,	        //20220624 by w22909 add
	output 		[7:0] o_bios_post_84,	        //20220607 by w22909 add
	output 		[7:0] o_bios_post_85,  	        //20220607 by w22909 add
	
	input		      bios_security_bypass,     //0x10[0]
	
	input             bmc_read_flag,            //0x11[0]
    input       [7:0] sw,                       //0x18[7:0]
	
	input		[7:0]  reg1_special_confi,		//0x29[7:0]	//V002B3 w22909 20221204 loop back
	output      [15:0] o_mb_cb_prsnt,		    //0x2A,0x2C    //V002B3 w22909 20221204 loop back
    input		[19:0] riser_ocp_m2_slot_number,//0x32[2:0],0x31[7:0],0x30[7:0]
	input		[43:0] nvme_slot_number,		//0x37[6:0],0x36[7:0],0x35[7:0],0x34[7:0],0x33[7:0],0x32[7:3]
	
	input 		[4:0] board_id, 	            //0xC6[4:0]
	input 		[2:0] chassis_id,	            //0xC7[1:0]	
	input       [2:0] pca_rev,                  //0xF4[7:3]
	input 		[1:0] pcb_rev,	                //0xF4[2:0]
	
	input             cpu0_mcio0_cable_id0,    //CPU0 DIE2-L--J18
	input             cpu0_mcio0_cable_id1,
	input             cpu0_mcio1_cable_id0,    //CPU0 DIE2-H--J17
	input             cpu0_mcio1_cable_id1,
	input             cpu0_mcio2_cable_id0,    //CPU0 DIE3-L--J20
	input             cpu0_mcio2_cable_id1,
	input             cpu0_mcio3_cable_id0,    //CPU0 DIE3-H--J19
	input             cpu0_mcio3_cable_id1,
	input             cpu0_mcio4_cable_id0,    //CPU0 DIE1-H--J16
	input             cpu0_mcio4_cable_id1,
	input             cpu0_mcio5_cable_id0,    //CPU0 DIE1-L--J29
	input             cpu0_mcio5_cable_id1,
	input             cpu1_mcio0_cable_id0,    //CPU1 DIE2-L--J21 
	input             cpu1_mcio0_cable_id1,
	input             cpu1_mcio1_cable_id0,    //CPU1 DIE2-H--J22
	input             cpu1_mcio1_cable_id1,
	input             cpu1_mcio2_cable_id0,    //CPU1 DIE3-L--J23
	input             cpu1_mcio2_cable_id1,
	input             cpu1_mcio3_cable_id0,    //CPU1 DIE3-H--J24
	input             cpu1_mcio3_cable_id1,
	input             cpu1_mcio4_cable_id0,    //CPU1 DIE0-H--J25
	input             cpu1_mcio4_cable_id1,
	input             cpu1_mcio6_cable_id0,    //CPU1 DIE0-L--J74
	input             cpu1_mcio6_cable_id1,
	
	input             pal_mcio11_cable_id1,    //CPU0 DIE0-H--J1
	input             pal_mcio11_cable_id0,
	input             pal_mcio12_cable_id1,    //CPU0 DIE0-L--J1
	input             pal_mcio12_cable_id0,
	input             pal_mcio15_cable_id1,
	input             pal_mcio15_cable_id0,
	input             pal_mcio16_cable_id1,
	input             pal_mcio16_cable_id0,
	input             i_ocp1_x16_or_x8    ,
	input             ocp1_prsnt_n        ,
	input             ocp2_prsnt_n        ,       

//2024-6-14 add for slot_id
    input        [7:0]i_i2c_ram_60        ,
    input        [7:0]i_i2c_ram_61        ,
    input        [7:0]i_i2c_ram_62        ,
    input        [7:0]i_i2c_ram_63        ,
    input        [7:0]i_i2c_ram_64        ,
    input        [7:0]i_i2c_ram_65        ,
    input        [7:0]i_i2c_ram_66        ,
    input        [7:0]i_i2c_ram_67        ,
    input        [7:0]i_i2c_ram_68        ,
    input        [7:0]i_i2c_ram_69        ,
    input        [7:0]i_i2c_ram_6A        ,
    input        [7:0]i_i2c_ram_6B        ,
    input        [7:0]i_i2c_ram_6C        ,
    input        [7:0]i_i2c_ram_6D        ,
    input        [7:0]i_i2c_ram_6E        ,
    input        [7:0]i_i2c_ram_6F        ,

	input        [7:0]i_i2c_ram_70        ,
    input        [7:0]i_i2c_ram_71        ,
    input        [7:0]i_i2c_ram_72        ,
    input        [7:0]i_i2c_ram_73        ,
    input        [7:0]i_i2c_ram_74        ,
    input        [7:0]i_i2c_ram_75        ,
    input        [7:0]i_i2c_ram_76        ,
    input        [7:0]i_i2c_ram_77        ,
    input        [7:0]i_i2c_ram_78        
    		
);

wire [7:0]  mfr_id        = `MFR_ID_H3C ;
wire [7:0]  odm_id        = `ODM_ID_H3C ;
wire [7:0]  pdt_line      = 8'h63;
wire [7:0]  pdt_gen       = 8'h06;
wire [7:0]  pdt_rev       = 8'h71;
wire [7:0]  server_id     = 8'h01;
wire [7:0] 	xreg_board_id  	= {4'b0, board_id[3:0]};//8'hC6
wire [7:0] 	xreg_chassis_id	= {6'b0, chassis_id[1:0]};//8'hC7
wire [7:0] 	pcb_id = {2'b0,pca_rev,1'b0,pcb_rev};//8'hF4

wire [3:0]  cpu0_die0_alloc;
wire [3:0]  cpu0_die1_alloc_1;
wire [3:0]  cpu0_die1_alloc_2;
wire [3:0]  cpu0_die2_alloc;
wire [3:0]  cpu0_die3_alloc;
wire [3:0]  cpu1_die0_alloc_1;
wire [3:0]  cpu1_die0_alloc_2;
wire [3:0]  cpu1_die1_alloc;
wire [3:0]  cpu1_die2_alloc;
wire [3:0]  cpu1_die3_alloc;

//BIOS Read Register buff
wire [7:0] w_ram_00;
wire [7:0] w_ram_01;
wire [7:0] w_ram_02;
wire [7:0] w_ram_03;
wire [7:0] w_ram_04;
wire [7:0] w_ram_05;
wire [7:0] w_ram_06;
wire [7:0] w_ram_07;
wire [7:0] w_ram_08;
wire [7:0] w_ram_09;
wire [7:0] w_ram_0A;
wire [7:0] w_ram_0B;
wire [7:0] w_ram_0C;
wire [7:0] w_ram_0D;
wire [7:0] w_ram_0E;
wire [7:0] w_ram_0F;
wire [7:0] w_ram_10;
wire [7:0] w_ram_11;
wire [7:0] w_ram_12;
wire [7:0] w_ram_13;
wire [7:0] w_ram_14;
wire [7:0] w_ram_15;
wire [7:0] w_ram_16;
wire [7:0] w_ram_17;
wire [7:0] w_ram_18;
wire [7:0] w_ram_19;
wire [7:0] w_ram_1A;
wire [7:0] w_ram_1B;
wire [7:0] w_ram_1C;
wire [7:0] w_ram_1D;
wire [7:0] w_ram_1E;
wire [7:0] w_ram_1F;
wire [7:0] w_ram_20;
wire [7:0] w_ram_21;
wire [7:0] w_ram_22;
wire [7:0] w_ram_23;
wire [7:0] w_ram_24;
wire [7:0] w_ram_25;
wire [7:0] w_ram_26;
wire [7:0] w_ram_27;
wire [7:0] w_ram_28;
wire [7:0] w_ram_29;
wire [7:0] w_ram_2A;
wire [7:0] w_ram_2B;
wire [7:0] w_ram_2C;
wire [7:0] w_ram_2D;
wire [7:0] w_ram_2E;
wire [7:0] w_ram_2F;
wire [7:0] w_ram_30;
wire [7:0] w_ram_31;
wire [7:0] w_ram_32;
wire [7:0] w_ram_33;
wire [7:0] w_ram_34;
wire [7:0] w_ram_35;
wire [7:0] w_ram_36;
wire [7:0] w_ram_37;
wire [7:0] w_ram_38;
wire [7:0] w_ram_39;
wire [7:0] w_ram_3A;
wire [7:0] w_ram_3B;
wire [7:0] w_ram_3C;
wire [7:0] w_ram_3D;
wire [7:0] w_ram_3E;
wire [7:0] w_ram_3F;
wire [7:0] w_ram_40;
wire [7:0] w_ram_41;
wire [7:0] w_ram_42;
wire [7:0] w_ram_43;
wire [7:0] w_ram_44;
wire [7:0] w_ram_45;
wire [7:0] w_ram_46;
wire [7:0] w_ram_47;
wire [7:0] w_ram_48;
wire [7:0] w_ram_49;
wire [7:0] w_ram_4A;
wire [7:0] w_ram_4B;
wire [7:0] w_ram_4C;
wire [7:0] w_ram_4D;
wire [7:0] w_ram_4E;
wire [7:0] w_ram_4F;
wire [7:0] w_ram_50;
wire [7:0] w_ram_51;
wire [7:0] w_ram_52;
wire [7:0] w_ram_53;
wire [7:0] w_ram_54;
wire [7:0] w_ram_55;
wire [7:0] w_ram_56;
wire [7:0] w_ram_57;
wire [7:0] w_ram_58;
wire [7:0] w_ram_59;
wire [7:0] w_ram_5A;
wire [7:0] w_ram_5B;
wire [7:0] w_ram_5C;
wire [7:0] w_ram_5D;
wire [7:0] w_ram_5E;
wire [7:0] w_ram_5F;
wire [7:0] w_ram_60;
wire [7:0] w_ram_61;
wire [7:0] w_ram_62;
wire [7:0] w_ram_63;
wire [7:0] w_ram_64;
wire [7:0] w_ram_65;
wire [7:0] w_ram_66;
wire [7:0] w_ram_67;
wire [7:0] w_ram_68;
wire [7:0] w_ram_69;
wire [7:0] w_ram_6A;
wire [7:0] w_ram_6B;
wire [7:0] w_ram_6C;
wire [7:0] w_ram_6D;
wire [7:0] w_ram_6E;
wire [7:0] w_ram_6F;
wire [7:0] w_ram_70;
wire [7:0] w_ram_71;
wire [7:0] w_ram_72;
wire [7:0] w_ram_73;
wire [7:0] w_ram_74;
wire [7:0] w_ram_75;
wire [7:0] w_ram_76;
wire [7:0] w_ram_77;
wire [7:0] w_ram_78;
wire [7:0] w_ram_79;
wire [7:0] w_ram_7A;
wire [7:0] w_ram_7B;
wire [7:0] w_ram_7C;
wire [7:0] w_ram_7D;
wire [7:0] w_ram_7E;
wire [7:0] w_ram_7F;
wire [7:0] w_ram_80;
wire [7:0] w_ram_81;
wire [7:0] w_ram_82;
wire [7:0] w_ram_83;
wire [7:0] w_ram_84;
wire [7:0] w_ram_85;
wire [7:0] w_ram_86;
wire [7:0] w_ram_87;
wire [7:0] w_ram_88;
wire [7:0] w_ram_89;
wire [7:0] w_ram_8A;
wire [7:0] w_ram_8B;
wire [7:0] w_ram_8C;
wire [7:0] w_ram_8D;
wire [7:0] w_ram_8E;
wire [7:0] w_ram_8F;
wire [7:0] w_ram_90;
wire [7:0] w_ram_91;
wire [7:0] w_ram_92;
wire [7:0] w_ram_93;
wire [7:0] w_ram_94;
wire [7:0] w_ram_95;
wire [7:0] w_ram_96;
wire [7:0] w_ram_97;
wire [7:0] w_ram_98;
wire [7:0] w_ram_99;
wire [7:0] w_ram_9A;
wire [7:0] w_ram_9B;
wire [7:0] w_ram_9C;
wire [7:0] w_ram_9D;
wire [7:0] w_ram_9E;
wire [7:0] w_ram_9F;
wire [7:0] w_ram_A0;
wire [7:0] w_ram_A1;
wire [7:0] w_ram_A2;
wire [7:0] w_ram_A3;
wire [7:0] w_ram_A4;
wire [7:0] w_ram_A5;
wire [7:0] w_ram_A6;
wire [7:0] w_ram_A7;
wire [7:0] w_ram_A8;
wire [7:0] w_ram_A9;
wire [7:0] w_ram_AA;
wire [7:0] w_ram_AB;
wire [7:0] w_ram_AC;
wire [7:0] w_ram_AD;
wire [7:0] w_ram_AE;
wire [7:0] w_ram_AF;
wire [7:0] w_ram_B0;
wire [7:0] w_ram_B1;
wire [7:0] w_ram_B2;
wire [7:0] w_ram_B3;
wire [7:0] w_ram_B4;
wire [7:0] w_ram_B5;
wire [7:0] w_ram_B6;
wire [7:0] w_ram_B7;
wire [7:0] w_ram_B8;
wire [7:0] w_ram_B9;
wire [7:0] w_ram_BA;
wire [7:0] w_ram_BB;
wire [7:0] w_ram_BC;
wire [7:0] w_ram_BD;
wire [7:0] w_ram_BE;
wire [7:0] w_ram_BF;
wire [7:0] w_ram_C0;
wire [7:0] w_ram_C1;
wire [7:0] w_ram_C2;
wire [7:0] w_ram_C3;
wire [7:0] w_ram_C4;
wire [7:0] w_ram_C5;
wire [7:0] w_ram_C6;
wire [7:0] w_ram_C7;
wire [7:0] w_ram_C8;
wire [7:0] w_ram_C9;
wire [7:0] w_ram_CA;
wire [7:0] w_ram_CB;
wire [7:0] w_ram_CC;
wire [7:0] w_ram_CD;
wire [7:0] w_ram_CE;
wire [7:0] w_ram_CF;
wire [7:0] w_ram_D0;
wire [7:0] w_ram_D1;
wire [7:0] w_ram_D2;
wire [7:0] w_ram_D3;
wire [7:0] w_ram_D4;
wire [7:0] w_ram_D5;
wire [7:0] w_ram_D6;
wire [7:0] w_ram_D7;
wire [7:0] w_ram_D8;
wire [7:0] w_ram_D9;
wire [7:0] w_ram_DA;
wire [7:0] w_ram_DB;
wire [7:0] w_ram_DC;
wire [7:0] w_ram_DD;
wire [7:0] w_ram_DE;
wire [7:0] w_ram_DF;
wire [7:0] w_ram_E0;
wire [7:0] w_ram_E1;
wire [7:0] w_ram_E2;
wire [7:0] w_ram_E3;
wire [7:0] w_ram_E4;
wire [7:0] w_ram_E5;
wire [7:0] w_ram_E6;
wire [7:0] w_ram_E7;
wire [7:0] w_ram_E8;
wire [7:0] w_ram_E9;
wire [7:0] w_ram_EA;
wire [7:0] w_ram_EB;
wire [7:0] w_ram_EC;
wire [7:0] w_ram_ED;
wire [7:0] w_ram_EE;
wire [7:0] w_ram_EF;
wire [7:0] w_ram_F0;
wire [7:0] w_ram_F1;
wire [7:0] w_ram_F2;
wire [7:0] w_ram_F3;
wire [7:0] w_ram_F4;
wire [7:0] w_ram_F5;
wire [7:0] w_ram_F6;
wire [7:0] w_ram_F7;
wire [7:0] w_ram_F8;
wire [7:0] w_ram_F9;
wire [7:0] w_ram_FA;
wire [7:0] w_ram_FB;
wire [7:0] w_ram_FC;
wire [7:0] w_ram_FD;
wire [7:0] w_ram_FE;
wire [7:0] w_ram_FF;

//BIOS Write Register buff
reg [7:0] r_reg_00;
reg [7:0] r_reg_01;
reg [7:0] r_reg_02;
reg [7:0] r_reg_03;
reg [7:0] r_reg_04;
reg [7:0] r_reg_05;
reg [7:0] r_reg_06;
reg [7:0] r_reg_07;
reg [7:0] r_reg_08;
reg [7:0] r_reg_09;
reg [7:0] r_reg_0A;
reg [7:0] r_reg_0B;
reg [7:0] r_reg_0C;
reg [7:0] r_reg_0D;
reg [7:0] r_reg_0E;
reg [7:0] r_reg_0F;
reg [7:0] r_reg_2A;
reg [7:0] r_reg_2C;


////////////////////////////////////////////////////////////////////////////////////
//PCIE DYNC ALLOC 
////////////////////////////////////////////////////////////////////////////////////
pcie_dync_alloc  w_cpu0_die0_alloc
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (pal_mcio12_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (pal_mcio12_cable_id0  ), //1'b1
    .i_cable_id1_l       (pal_mcio11_cable_id1  ),  
    .i_cable_id0_l       (pal_mcio11_cable_id0  ),//1'b1
    .o_pcie_date         (cpu0_die0_alloc       )
);

pcie_dync_alloc  w_cpu0_die1_alloc_1
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (cpu0_mcio4_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (cpu0_mcio4_cable_id0  ), //1'b1
    .i_cable_id1_l       (cpu0_mcio5_cable_id1  ),  
    .i_cable_id0_l       (cpu0_mcio5_cable_id0  ),//1'b1
    .o_pcie_date         (cpu0_die1_alloc_1     )
);

pcie_dync_alloc  w_cpu0_die1_alloc_2
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (i_ocp1_x16_or_x8 ? 1'b1:1'b0  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (1'b1                  ), //1'b1
    .i_cable_id1_l       (i_ocp1_x16_or_x8 ? 1'b1:1'b0  ),  
    .i_cable_id0_l       (1'b1                  ),//1'b1
    .o_pcie_date         (cpu0_die1_alloc_2     )
);

pcie_dync_alloc  w_cpu0_die2_alloc
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (cpu0_mcio1_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (cpu0_mcio1_cable_id0  ), //1'b1
    .i_cable_id1_l       (cpu0_mcio0_cable_id1  ),  
    .i_cable_id0_l       (cpu0_mcio0_cable_id0  ),//1'b1
    .o_pcie_date         (cpu0_die2_alloc       )
);

pcie_dync_alloc  w_cpu0_die3_alloc
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (cpu0_mcio3_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (cpu0_mcio3_cable_id0  ), //1'b1
    .i_cable_id1_l       (cpu0_mcio2_cable_id1  ),  
    .i_cable_id0_l       (cpu0_mcio2_cable_id0  ),//1'b1
    .o_pcie_date         (cpu0_die3_alloc       )
);

pcie_dync_alloc  w_cpu1_die1_alloc
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (pal_mcio16_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (pal_mcio16_cable_id0  ), //1'b1
    .i_cable_id1_l       (pal_mcio15_cable_id1  ),  
    .i_cable_id0_l       (pal_mcio15_cable_id0  ),//1'b1
    .o_pcie_date         (cpu1_die1_alloc       )
);

pcie_dync_alloc  w_cpu1_die0_alloc_1
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (cpu1_mcio4_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (cpu1_mcio4_cable_id0  ), //1'b1
    .i_cable_id1_l       (cpu1_mcio6_cable_id1  ),  
    .i_cable_id0_l       (cpu1_mcio6_cable_id0  ),//1'b1
    .o_pcie_date         (cpu1_die0_alloc_1     )
);

pcie_dync_alloc  w_cpu1_die2_alloc
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (cpu1_mcio1_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (cpu1_mcio1_cable_id0  ), //1'b1
    .i_cable_id1_l       (cpu1_mcio0_cable_id1  ),  
    .i_cable_id0_l       (cpu1_mcio0_cable_id0  ),//1'b1
    .o_pcie_date         (cpu1_die2_alloc       )
);

pcie_dync_alloc  w_cpu1_die3_alloc
(
    .i_rst_n             (rc_reset_n            ), 
    .i_clk               (clk                   ),
    .i_cable_id1_h       (cpu1_mcio3_cable_id1  ),   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (cpu1_mcio3_cable_id0  ), //1'b1
    .i_cable_id1_l       (cpu1_mcio2_cable_id1  ),  
    .i_cable_id0_l       (cpu1_mcio2_cable_id0  ),//1'b1
    .o_pcie_date         (cpu1_die3_alloc       )
);


//Write Register
assign o_usb_en [7 :0]      = r_reg_00;
assign o_bios_read_rtc      = r_reg_0C;
assign o_bios_post_80       = r_reg_0D;
assign o_bios_post_84       = r_reg_0E;
assign o_bios_post_85       = r_reg_0F;

assign o_mb_cb_prsnt[7 :0] = r_reg_2A;
assign o_mb_cb_prsnt[15:8] = r_reg_2C;

//Read Register
assign w_ram_00[7:0] = o_usb_en[7:0];
assign w_ram_0C[7:0] = o_bios_read_rtc;
assign w_ram_0D[7:0] = o_bios_post_80;
assign w_ram_0E[7:0] = o_bios_post_84;
assign w_ram_0F[7:0] = o_bios_post_85;

assign w_ram_10[7:0] = {7'b0,bios_security_bypass};
assign w_ram_11[7:0] = {7'b0,bmc_read_flag};
assign w_ram_18[7:0] = sw;
assign w_ram_29[7:0] = reg1_special_confi;

assign w_ram_30[7:0] = riser_ocp_m2_slot_number[7:0];
assign w_ram_31[7:0] = riser_ocp_m2_slot_number[15:8];
assign w_ram_32[2:0] = riser_ocp_m2_slot_number[18:16];
assign w_ram_32[7:3] = nvme_slot_number[4:0];
assign w_ram_33[7:0] = nvme_slot_number[12:5];
assign w_ram_34[7:0] = nvme_slot_number[20:13];
assign w_ram_35[7:0] = nvme_slot_number[28:21];
assign w_ram_36[7:0] = nvme_slot_number[36:29];
assign w_ram_37[6:0] = nvme_slot_number[43:37];
assign w_ram_37[7]   = 1'b1;

//2024-6-14 add for slot_id
assign w_ram_60   	 = i_i2c_ram_60;
assign w_ram_61   	 = i_i2c_ram_61;
assign w_ram_62   	 = i_i2c_ram_62;
assign w_ram_63   	 = i_i2c_ram_63;
assign w_ram_64   	 = i_i2c_ram_64;
assign w_ram_65   	 = i_i2c_ram_65;
assign w_ram_66   	 = i_i2c_ram_66;
assign w_ram_67   	 = i_i2c_ram_67;
assign w_ram_68   	 = i_i2c_ram_68;
assign w_ram_69   	 = i_i2c_ram_69;
assign w_ram_6A   	 = i_i2c_ram_6A;
assign w_ram_6B   	 = i_i2c_ram_6B;
assign w_ram_6C   	 = i_i2c_ram_6C;
assign w_ram_6D   	 = i_i2c_ram_6D;
assign w_ram_6E   	 = i_i2c_ram_6E;
assign w_ram_6F   	 = i_i2c_ram_6F;

assign w_ram_70   	 = i_i2c_ram_70;
assign w_ram_71   	 = i_i2c_ram_71;
assign w_ram_72   	 = i_i2c_ram_72;
assign w_ram_73   	 = i_i2c_ram_73;
assign w_ram_74   	 = i_i2c_ram_74;
assign w_ram_75   	 = i_i2c_ram_75;
assign w_ram_76   	 = i_i2c_ram_76;
assign w_ram_77   	 = i_i2c_ram_77;
assign w_ram_78   	 = i_i2c_ram_78;

assign w_ram_80[7:0] = {4'b0001,cpu0_die1_alloc_2};
assign w_ram_81[7:0] = {cpu0_die1_alloc_1,cpu0_die0_alloc};
assign w_ram_82[7:0] = {cpu0_die3_alloc,cpu0_die2_alloc};
assign w_ram_83[7:0] = {cpu1_die1_alloc,4'b0};
assign w_ram_84[7:0] = {4'b0,cpu1_die0_alloc_1};
assign w_ram_85[7:0] = {cpu1_die3_alloc,cpu1_die2_alloc};
assign w_ram_86[7:0] = {6'b0,ocp2_prsnt_n,ocp1_prsnt_n};

assign w_ram_C0   	   = mfr_id		;
assign w_ram_C1  	   = odm_id		;
assign w_ram_C2	 	   = pdt_line	;
assign w_ram_C3		   = pdt_gen	;
assign w_ram_C4		   = pdt_rev	;
assign w_ram_C5		   = server_id	;
assign w_ram_C6		   = xreg_board_id		;
assign w_ram_C7		   = xreg_chassis_id	;
assign w_ram_F4		   = pcb_id	    ;


//BIOS to Read CPLD Reg
always @(*) begin
    case (reg_addr)
          8'h00 : rdata <= w_ram_00;
          8'h01 : rdata <= w_ram_01;
          8'h02 : rdata <= w_ram_02;
          8'h03 : rdata <= w_ram_03;
          8'h04 : rdata <= w_ram_04;
          8'h05 : rdata <= w_ram_05;
          8'h06 : rdata <= w_ram_06;
          8'h07 : rdata <= w_ram_07;
          8'h08 : rdata <= w_ram_08;
          8'h09 : rdata <= w_ram_09;
          8'h0A : rdata <= w_ram_0A;
          8'h0B : rdata <= w_ram_0B;
          8'h0C : rdata <= w_ram_0C;
          8'h0D : rdata <= w_ram_0D;
          8'h0E : rdata <= w_ram_0E;
          8'h0F : rdata <= w_ram_0F;
          8'h10 : rdata <= w_ram_10;
          8'h11 : rdata <= w_ram_11;
          8'h12 : rdata <= w_ram_12;
          8'h13 : rdata <= w_ram_13;
          8'h14 : rdata <= w_ram_14;
          8'h15 : rdata <= w_ram_15;
          8'h16 : rdata <= w_ram_16;
          8'h17 : rdata <= w_ram_17;
          8'h18 : rdata <= w_ram_18;
          8'h19 : rdata <= w_ram_19;
          8'h1A : rdata <= w_ram_1A;
          8'h1B : rdata <= w_ram_1B;
          8'h1C : rdata <= w_ram_1C;
          8'h1D : rdata <= w_ram_1D;
          8'h1E : rdata <= w_ram_1E;
          8'h1F : rdata <= w_ram_1F;
          8'h20 : rdata <= w_ram_20;
          8'h21 : rdata <= w_ram_21;
          8'h22 : rdata <= w_ram_22;
          8'h23 : rdata <= w_ram_23;
          8'h24 : rdata <= w_ram_24;
          8'h25 : rdata <= w_ram_25;
          8'h26 : rdata <= w_ram_26;
          8'h27 : rdata <= w_ram_27;
          8'h28 : rdata <= w_ram_28;
          8'h29 : rdata <= w_ram_29;
          8'h2A : rdata <= w_ram_2A;
          8'h2B : rdata <= w_ram_2B;
          8'h2C : rdata <= w_ram_2C;
          8'h2D : rdata <= w_ram_2D;
          8'h2E : rdata <= w_ram_2E;
          8'h2F : rdata <= w_ram_2F;
          8'h30 : rdata <= w_ram_30;
          8'h31 : rdata <= w_ram_31;
          8'h32 : rdata <= w_ram_32;
          8'h33 : rdata <= w_ram_33;
          8'h34 : rdata <= w_ram_34;
          8'h35 : rdata <= w_ram_35;
          8'h36 : rdata <= w_ram_36;
          8'h37 : rdata <= w_ram_37;
          8'h38 : rdata <= w_ram_38;
          8'h39 : rdata <= w_ram_39;
          8'h3A : rdata <= w_ram_3A;
          8'h3B : rdata <= w_ram_3B;
          8'h3C : rdata <= w_ram_3C;
          8'h3D : rdata <= w_ram_3D;
          8'h3E : rdata <= w_ram_3E;
          8'h3F : rdata <= w_ram_3F;
          8'h40 : rdata <= w_ram_40;
          8'h41 : rdata <= w_ram_41;
          8'h42 : rdata <= w_ram_42;
          8'h43 : rdata <= w_ram_43;
          8'h44 : rdata <= w_ram_44;
          8'h45 : rdata <= w_ram_45;
          8'h46 : rdata <= w_ram_46;
          8'h47 : rdata <= w_ram_47;
          8'h48 : rdata <= w_ram_48;
          8'h49 : rdata <= w_ram_49;
          8'h4A : rdata <= w_ram_4A;
          8'h4B : rdata <= w_ram_4B;
          8'h4C : rdata <= w_ram_4C;
          8'h4D : rdata <= w_ram_4D;
          8'h4E : rdata <= w_ram_4E;
          8'h4F : rdata <= w_ram_4F;
          8'h50 : rdata <= w_ram_50;
          8'h51 : rdata <= w_ram_51;
          8'h52 : rdata <= w_ram_52;
          8'h53 : rdata <= w_ram_53;
          8'h54 : rdata <= w_ram_54;
          8'h55 : rdata <= w_ram_55;
          8'h56 : rdata <= w_ram_56;
          8'h57 : rdata <= w_ram_57;
          8'h58 : rdata <= w_ram_58;
          8'h59 : rdata <= w_ram_59;
          8'h5A : rdata <= w_ram_5A;
          8'h5B : rdata <= w_ram_5B;
          8'h5C : rdata <= w_ram_5C;
          8'h5D : rdata <= w_ram_5D;
          8'h5E : rdata <= w_ram_5E;
          8'h5F : rdata <= w_ram_5F;
          8'h60 : rdata <= w_ram_60;
          8'h61 : rdata <= w_ram_61;
          8'h62 : rdata <= w_ram_62;
          8'h63 : rdata <= w_ram_63;
          8'h64 : rdata <= w_ram_64;
          8'h65 : rdata <= w_ram_65;
          8'h66 : rdata <= w_ram_66;
          8'h67 : rdata <= w_ram_67;
          8'h68 : rdata <= w_ram_68;
          8'h69 : rdata <= w_ram_69;
          8'h6A : rdata <= w_ram_6A;
          8'h6B : rdata <= w_ram_6B;
          8'h6C : rdata <= w_ram_6C;
          8'h6D : rdata <= w_ram_6D;
          8'h6E : rdata <= w_ram_6E;
          8'h6F : rdata <= w_ram_6F;
          8'h70 : rdata <= w_ram_70;
          8'h71 : rdata <= w_ram_71;
          8'h72 : rdata <= w_ram_72;
          8'h73 : rdata <= w_ram_73;
          8'h74 : rdata <= w_ram_74;
          8'h75 : rdata <= w_ram_75;
          8'h76 : rdata <= w_ram_76;
          8'h77 : rdata <= w_ram_77;
          8'h78 : rdata <= w_ram_78;
          8'h79 : rdata <= w_ram_79;
          8'h7A : rdata <= w_ram_7A;
          8'h7B : rdata <= w_ram_7B;
          8'h7C : rdata <= w_ram_7C;
          8'h7D : rdata <= w_ram_7D;
          8'h7E : rdata <= w_ram_7E;
          8'h7F : rdata <= w_ram_7F;
          8'h80 : rdata <= w_ram_80;
          8'h81 : rdata <= w_ram_81;
          8'h82 : rdata <= w_ram_82;
          8'h83 : rdata <= w_ram_83;
          8'h84 : rdata <= w_ram_84;
          8'h85 : rdata <= w_ram_85;
          8'h86 : rdata <= w_ram_86;
          8'h87 : rdata <= w_ram_87;
          8'h88 : rdata <= w_ram_88;
          8'h89 : rdata <= w_ram_89;
          8'h8A : rdata <= w_ram_8A;
          8'h8B : rdata <= w_ram_8B;
          8'h8C : rdata <= w_ram_8C;
          8'h8D : rdata <= w_ram_8D;
          8'h8E : rdata <= w_ram_8E;
          8'h8F : rdata <= w_ram_8F;
          8'h90 : rdata <= w_ram_90;
          8'h91 : rdata <= w_ram_91;
          8'h92 : rdata <= w_ram_92;
          8'h93 : rdata <= w_ram_93;
          8'h94 : rdata <= w_ram_94;
          8'h95 : rdata <= w_ram_95;
          8'h96 : rdata <= w_ram_96;
          8'h97 : rdata <= w_ram_97;
          8'h98 : rdata <= w_ram_98;
          8'h99 : rdata <= w_ram_99;
          8'h9A : rdata <= w_ram_9A;
          8'h9B : rdata <= w_ram_9B;
          8'h9C : rdata <= w_ram_9C;
          8'h9D : rdata <= w_ram_9D;
          8'h9E : rdata <= w_ram_9E;
          8'h9F : rdata <= w_ram_9F;
          8'hA0 : rdata <= w_ram_A0;
          8'hA1 : rdata <= w_ram_A1;
          8'hA2 : rdata <= w_ram_A2;
          8'hA3 : rdata <= w_ram_A3;
          8'hA4 : rdata <= w_ram_A4;
          8'hA5 : rdata <= w_ram_A5;
          8'hA6 : rdata <= w_ram_A6;
          8'hA7 : rdata <= w_ram_A7;
          8'hA8 : rdata <= w_ram_A8;
          8'hA9 : rdata <= w_ram_A9;
          8'hAA : rdata <= w_ram_AA;
          8'hAB : rdata <= w_ram_AB;
          8'hAC : rdata <= w_ram_AC;
          8'hAD : rdata <= w_ram_AD;
          8'hAE : rdata <= w_ram_AE;
          8'hAF : rdata <= w_ram_AF;
          8'hB0 : rdata <= w_ram_B0;
          8'hB1 : rdata <= w_ram_B1;
          8'hB2 : rdata <= w_ram_B2;
          8'hB3 : rdata <= w_ram_B3;
          8'hB4 : rdata <= w_ram_B4;
          8'hB5 : rdata <= w_ram_B5;
          8'hB6 : rdata <= w_ram_B6;
          8'hB7 : rdata <= w_ram_B7;
          8'hB8 : rdata <= w_ram_B8;
          8'hB9 : rdata <= w_ram_B9;
          8'hBA : rdata <= w_ram_BA;
          8'hBB : rdata <= w_ram_BB;
          8'hBC : rdata <= w_ram_BC;
          8'hBD : rdata <= w_ram_BD;
          8'hBE : rdata <= w_ram_BE;
          8'hBF : rdata <= w_ram_BF;
          8'hC0 : rdata <= w_ram_C0;
          8'hC1 : rdata <= w_ram_C1;
          8'hC2 : rdata <= w_ram_C2;
          8'hC3 : rdata <= w_ram_C3;
          8'hC4 : rdata <= w_ram_C4;
          8'hC5 : rdata <= w_ram_C5;
          8'hC6 : rdata <= w_ram_C6;
          8'hC7 : rdata <= w_ram_C7;
          8'hC8 : rdata <= w_ram_C8;
          8'hC9 : rdata <= w_ram_C9;
          8'hCA : rdata <= w_ram_CA;
          8'hCB : rdata <= w_ram_CB;
          8'hCC : rdata <= w_ram_CC;
          8'hCD : rdata <= w_ram_CD;
          8'hCE : rdata <= w_ram_CE;
          8'hCF : rdata <= w_ram_CF;
          8'hD0 : rdata <= w_ram_D0;
          8'hD1 : rdata <= w_ram_D1;
          8'hD2 : rdata <= w_ram_D2;
          8'hD3 : rdata <= w_ram_D3;
          8'hD4 : rdata <= w_ram_D4;
          8'hD5 : rdata <= w_ram_D5;
          8'hD6 : rdata <= w_ram_D6;
          8'hD7 : rdata <= w_ram_D7;
          8'hD8 : rdata <= w_ram_D8;
          8'hD9 : rdata <= w_ram_D9;
          8'hDA : rdata <= w_ram_DA;
          8'hDB : rdata <= w_ram_DB;
          8'hDC : rdata <= w_ram_DC;
          8'hDD : rdata <= w_ram_DD;
          8'hDE : rdata <= w_ram_DE;
          8'hDF : rdata <= w_ram_DF;
          8'hE0 : rdata <= w_ram_E0;
          8'hE1 : rdata <= w_ram_E1;
          8'hE2 : rdata <= w_ram_E2;
          8'hE3 : rdata <= w_ram_E3;
          8'hE4 : rdata <= w_ram_E4;
          8'hE5 : rdata <= w_ram_E5;
          8'hE6 : rdata <= w_ram_E6;
          8'hE7 : rdata <= w_ram_E7;
          8'hE8 : rdata <= w_ram_E8;
          8'hE9 : rdata <= w_ram_E9;
          8'hEA : rdata <= w_ram_EA;
          8'hEB : rdata <= w_ram_EB;
          8'hEC : rdata <= w_ram_EC;
          8'hED : rdata <= w_ram_ED;
          8'hEE : rdata <= w_ram_EE;
          8'hEF : rdata <= w_ram_EF;
          8'hF0 : rdata <= w_ram_F0;
          8'hF1 : rdata <= w_ram_F1;
          8'hF2 : rdata <= w_ram_F2;
          8'hF3 : rdata <= w_ram_F3;
          8'hF4 : rdata <= w_ram_F4;
          8'hF5 : rdata <= w_ram_F5;
          8'hF6 : rdata <= w_ram_F6;
          8'hF7 : rdata <= w_ram_F7;
          8'hF8 : rdata <= w_ram_F8;
          8'hF9 : rdata <= w_ram_F9;
          8'hFA : rdata <= w_ram_FA;
          8'hFB : rdata <= w_ram_FB;
          8'hFC : rdata <= w_ram_FC;
          8'hFD : rdata <= w_ram_FD;
          8'hFE : rdata <= w_ram_FE;
          8'hFF : rdata <= w_ram_FF;
        default: rdata  <= 8'h00;
    endcase
end

//BMC to write CPLD Reg
always @(posedge clk or negedge rc_reset_n)
begin
    if (!rc_reset_n)
    begin
        r_reg_00 <= 8'hFF;
		r_reg_0C <= 8'h01;
		r_reg_0D <= 8'h00;
        r_reg_0E <= 8'h00;
        r_reg_0F <= 8'h00;
		r_reg_2A <= 8'h00;
		r_reg_2C <= 8'h00;
        end
    else if (wrdata_en) 
    begin
        case (reg_addr)
		  8'h00: r_reg_00 <= wrdata;
		  8'h0C: r_reg_0C <= wrdata;
		  8'h0D: r_reg_0D <= wrdata;
          8'h0E: r_reg_0E <= wrdata;
          8'h0F: r_reg_0F <= wrdata;
		  
		  8'h2A: r_reg_2A <= wrdata;
		  8'h2C: r_reg_2C <= wrdata;
        endcase
    end
end


endmodule