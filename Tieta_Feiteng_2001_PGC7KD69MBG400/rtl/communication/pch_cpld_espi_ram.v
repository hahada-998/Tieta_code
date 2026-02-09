//2023-2-27 new created 
//2023-2-28 add espi wdt --0x1010  0x1011  0x1012
module pch_cpld_espi_ram 
(
input  i_rst_n      , 
input  i_clk        ,
input  i_clk_10ms   ,

input        [15:0]  i_espi_addr     ,	
input        [7:0]   i_espi_date_out ,
output       [7:0]   o_espi_date_in  , 
input                i_espi_wdata_en ,

/*ESPI RAM START*/
input                i_pal_mcio1_cable_id0  ,  //CPU0 PE4-H--J44
input                i_pal_mcio1_cable_id1  , 

input                i_pal_mcio2_cable_id0  ,  //CPU0 PE4-L--J45
input                i_pal_mcio2_cable_id1  ,

input                i_pal_mcio3_cable_id0  ,  //CPU0 PE3-H--J43
input                i_pal_mcio3_cable_id1  , 

input                i_pal_mcio4_cable_id0  ,  //CPU0 PE3-L--J42
input                i_pal_mcio4_cable_id1  ,  
  
input                i_pal_mcio5_cable_id0  ,  //CPU1 PE4-H--J209
input                i_pal_mcio5_cable_id1  , 

input                i_pal_mcio6_cable_id0  ,  //CPU1 PE4-L--J210
input                i_pal_mcio6_cable_id1  ,

input                i_pal_mcio7_cable_id0  ,  //CPU1 PE3-H--J208
input                i_pal_mcio7_cable_id1  , 

input                i_pal_mcio8_cable_id0  ,  //CPU1 PE3-L--J207
input                i_pal_mcio8_cable_id1  ,  

input                i_pal_mcio10_cable_id0 ,  //CPU0 PE0-L--J185 --0 1 id1 id0
input                i_pal_mcio10_cable_id1 ,  

input                i_pal_mcio13_cable_id0 ,  //CPU0 PE2-H--J41
input                i_pal_mcio13_cable_id1 ,
 
input                i_pal_mcio14_cable_id0 ,  //CPU0 PE2-L--J40
input                i_pal_mcio14_cable_id1 ,

input                i_pal_mcio17_cable_id0 ,  //CPU1 PE1-H--J203
input                i_pal_mcio17_cable_id1 , 

input                i_pal_mcio18_cable_id0 ,  //CPU1 PE1-L--J204
input                i_pal_mcio18_cable_id1 , 
    
input                i_pal_mcio19_cable_id0 ,  //CPU1 PE2-H--J206
input                i_pal_mcio19_cable_id1 , 

input                i_pal_mcio20_cable_id0 ,  //CPU1 PE2-L--J205
input                i_pal_mcio20_cable_id1 ,

input                i_pal_mcio11_cable_id0 , //2023-5-25 add 
input                i_pal_mcio11_cable_id1 ,//CPU0 PE1 --J171 id1 h 

input                i_pal_mcio12_cable_id0 , //2024-2-26 add 
input                i_pal_mcio12_cable_id1 ,//CPU0 PE1 --J171 id1 l

input                i_pal_mcio15_cable_id0 ,
input                i_pal_mcio15_cable_id1 ,//CPU1 PE0 --J170 id1 h

input                i_pal_mcio16_cable_id0 ,//2024-2-26 add 
input                i_pal_mcio16_cable_id1 ,//CPU1 PE0 --J170 id1 l

input                i_ocp1_x16_or_x8 ,//CPU1 PE0 --J170 id1 l


output       [7:0]   o_test_reg             ,

// output       [7:0]   o_espi_wdt_cfg         ,
// output       [7:0]   o_espi_wdt_value_set   ,
// output       [7:0]   o_espi_wdt_cnt_clr     ,
// output       [7:0]   o_espi_int_clr         ,
// // input                i_espi_int_clr_done    ,
// output               o_espi_wdt_done        ,
// input                i_opposite_wdt_done    ,

/*ESPI RAM END */
//2024-3-26 add
input        [7:0]   i_PRODUCT_LINE_C2,
input        [7:0]   i_PRODUCT_GEN_ID_C3,
input        [7:0]   i_SERVER_ID_C5,
input        [7:0]   i_BOARD_ID_C6,

// output       [7:0]   o_espi_debug_ram_1000,   //2023-3-30 add for bios debug
// output       [7:0]   o_espi_debug_ram_1001,
// output       [7:0]   o_espi_debug_ram_1002,
// output       [7:0]   o_espi_debug_ram_1003,
// output       [7:0]   o_espi_debug_ram_1004,
// output       [7:0]   o_espi_debug_ram_1005,
// output       [7:0]   o_espi_debug_ram_1014,

////////////////////////////////////VMD ON OFF 2023-12-13 ADD ////////////////////////////////////////////////////////////////////
output       [7:0]   o_espi_debug_ram_1020,
output       [7:0]   o_espi_debug_ram_1021,
output       [7:0]   o_espi_debug_ram_1022,
output       [7:0]   o_espi_debug_ram_1023,
output       [7:0]   o_espi_debug_ram_1024,
output       [7:0]   o_espi_debug_ram_1025,
output       [7:0]   o_espi_debug_ram_1026,
output       [7:0]   o_espi_debug_ram_1027,
output       [7:0]   o_espi_debug_ram_1028,
output       [7:0]   o_espi_debug_ram_1029,
output       [7:0]   o_espi_debug_ram_102a,
output       [7:0]   o_espi_debug_ram_102b,
////////////////////////////////////VMD ON OFF 2023-12-13 ADD ////////////////////////////////////////////////////////////////////

input        [7:0]   i_espi_ram_1050,
input        [7:0]   i_espi_ram_1051,
input        [7:0]   i_espi_ram_1052,
input        [7:0]   i_espi_ram_1053,
input        [7:0]   i_espi_ram_1054,
input        [7:0]   i_espi_ram_1055,
input        [7:0]   i_espi_ram_1056,
input        [7:0]   i_espi_ram_1057,
input        [7:0]   i_espi_ram_1058,

// input        [7:0]   i_riser1_id    , //2023-9-20 ADD 
// input        [7:0]   i_riser2_id    ,
// input                i_riser1_prsnt , //J171
// input                i_riser2_prsnt , //J170
// input                i_12lug_prsnt   ,//2023-10-14 add 


//2024-3-24 add for slot_id
input        [7:0]   i_espi_ram_1100,
input        [7:0]   i_espi_ram_1101,
input        [7:0]   i_espi_ram_1102,
input        [7:0]   i_espi_ram_1103,
input        [7:0]   i_espi_ram_1104,
input        [7:0]   i_espi_ram_1105,
input        [7:0]   i_espi_ram_1106,
input        [7:0]   i_espi_ram_1107,
input        [7:0]   i_espi_ram_1108,
input        [7:0]   i_espi_ram_1109,
input        [7:0]   i_espi_ram_110a,
input        [7:0]   i_espi_ram_110b,
input        [7:0]   i_espi_ram_110c,
input        [7:0]   i_espi_ram_110d,
input        [7:0]   i_espi_ram_110e,
input        [7:0]   i_espi_ram_110f,
input        [7:0]   i_espi_ram_1110,
input        [7:0]   i_espi_ram_1111,
input        [7:0]   i_espi_ram_1112,
input        [7:0]   i_espi_ram_1113,
input        [7:0]   i_espi_ram_1114

);

// wire w_clk_10ms_pos;

////////////////////////////////////////////////////////////////////////////////////
//for SLOT JUDEGE  2023-9-20 add 
////////////////////////////////////////////////////////////////////////////////////

// reg r_1050_bit7_prsnt;
// reg r_1051_bit0_prsnt;
// reg r_1051_bit1_prsnt;
// reg r_1051_bit2_prsnt;

// reg r_1053_bit6_prsnt; //2023-12-11 add //2023-12-12 delete
// reg r_1053_bit5_prsnt; //2023-11-8 add 
// reg r_1053_bit4_prsnt;
// reg r_1053_bit3_prsnt;
// reg r_1053_bit2_prsnt;

//8
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n) begin
		// r_1050_bit7_prsnt <= 1'b1;
	// end
	// else if (i_riser1_prsnt == 1'b0 && i_riser1_id == 8'h1b) begin  //J171 & 3x8 riser   i_riser2_prsnt = J170  i_riser1_prsnt = J171
	    // r_1050_bit7_prsnt <= 1'b0;                                  //                   i_riser1_id = J171     i_riser2_id = J170
	// end
	// else 
	    // r_1050_bit7_prsnt <= 1'b1;
// end
//9
// always@(posedge i_clk or negedge i_rst_n) begin                    //2023-11-8 chg 3x8 riser boardID 8'h1f to 8'h1b
    // if(~i_rst_n) begin
		// r_1051_bit0_prsnt <= 1'b1;
	// end
	// else if (i_riser2_prsnt == 1'b0 && i_riser2_id == 8'h1b) begin  //J170 & 3x8 riser 
	    // r_1051_bit0_prsnt <= 1'b0;
	// end
	// else 
	    // r_1051_bit0_prsnt <= 1'b1;
// end
//10
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n) begin
		// r_1051_bit1_prsnt <= 1'b1;
	// end
	// else if (i_riser1_prsnt == 1'b0 && i_riser1_id == 8'h1e) begin  //J171 & 3x16 riser  
	    // r_1051_bit1_prsnt <= 1'b0;                                   
	// end
	// else 
	    // r_1051_bit1_prsnt <= 1'b1;
// end
//11
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n) begin
		// r_1051_bit2_prsnt <= 1'b1;
	// end
	// else if (i_riser2_prsnt == 1'b0 && i_riser2_id == 8'h1e) begin  //J170 & 3x16 riser  
	    // r_1051_bit2_prsnt <= 1'b0;
	// end
	// else 
	    // r_1051_bit2_prsnt <= 1'b1;
// end
//27
// always@(posedge i_clk or negedge i_rst_n) begin                    
    // if(~i_rst_n) begin
		// r_1053_bit2_prsnt <= 1'b1;
	// end
	// else if (i_riser1_prsnt == 1'b0 && i_riser1_id == 8'h1a) begin  //J171 & 2x8 riser 
	    // r_1053_bit2_prsnt <= 1'b0;
	// end
	// else 
	    // r_1053_bit2_prsnt <= 1'b1;
// end
//28
// always@(posedge i_clk or negedge i_rst_n) begin                    
    // if(~i_rst_n) begin
		// r_1053_bit3_prsnt <= 1'b1;
	// end
	// else if (i_riser2_prsnt == 1'b0 && i_riser2_id == 8'h1a) begin  //J170 & 2x8 riser 
	    // r_1053_bit3_prsnt <= 1'b0;
	// end
	// else 
	    // r_1053_bit3_prsnt <= 1'b1;
// end
//29
// always@(posedge i_clk or negedge i_rst_n) begin                    
    // if(~i_rst_n) begin
		// r_1053_bit4_prsnt <= 1'b1;
	// end
	// else if (i_riser1_prsnt == 1'b0 && i_riser1_id == 8'h19) begin  //J171 & 2x16 riser 
	    // r_1053_bit4_prsnt <= 1'b0;
	// end
	// else 
	    // r_1053_bit4_prsnt <= 1'b1;
// end
//30
// always@(posedge i_clk or negedge i_rst_n) begin                    
    // if(~i_rst_n) begin
		// r_1053_bit5_prsnt <= 1'b1;
	// end
	// else if (i_riser2_prsnt == 1'b0 && i_riser2_id == 8'h19) begin  //J170 & 2x16 riser 
	    // r_1053_bit5_prsnt <= 1'b0;
	// end
	// else 
	    // r_1053_bit5_prsnt <= 1'b1;
// end
//31
// always@(posedge i_clk or negedge i_rst_n) begin                    
    // if(~i_rst_n) begin
		// r_1053_bit6_prsnt <= 1'b1;
	// end
	// else if (i_riser2_prsnt == 1'b0 && i_riser2_id == 8'h0b) begin  //J170 & 2x16 hudie riser 
	    // r_1053_bit6_prsnt <= 1'b0;
	// end
	// else 
	    // r_1053_bit6_prsnt <= 1'b1;
// end



////////////////////////////////////////////////////////////////////////////////////
//for espi_ram
////////////////////////////////////////////////////////////////////////////////////
reg [7:0]  r_espi_date_in ;

assign o_espi_date_in = r_espi_date_in;

wire [3:0]  w_cpu0_pe0_alloc;
wire [3:0]  w_cpu0_pe1_alloc;
wire [3:0]  w_cpu0_pe2_alloc;
wire [3:0]  w_cpu0_pe3_alloc;
wire [3:0]  w_cpu0_pe4_alloc;
wire [3:0]  w_cpu1_pe0_alloc;
wire [3:0]  w_cpu1_pe1_alloc;
wire [3:0]  w_cpu1_pe2_alloc;
wire [3:0]  w_cpu1_pe3_alloc;
wire [3:0]  w_cpu1_pe4_alloc;


reg         r_espi_wdt_done ;

assign o_espi_wdt_done = r_espi_wdt_done;


////////////////////////////////////////////////////////////////////////////////////
//read only register
////////////////////////////////////////////////////////////////////////////////////
wire [7:0] w_ram_00c2 ;//2024-3-26 add
wire [7:0] w_ram_00c3 ;
wire [7:0] w_ram_00c5 ;
wire [7:0] w_ram_00c6 ;

wire [7:0] w_ram_1000 ;
wire [7:0] w_ram_1001 ;
wire [7:0] w_ram_1002 ;
wire [7:0] w_ram_1003 ;
wire [7:0] w_ram_1004 ;
wire [7:0] w_ram_1005 ;

// wire [7:0] w_ram_1014 ;


wire [7:0] w_ram_1050 ;
wire [7:0] w_ram_1051 ;
wire [7:0] w_ram_1052 ;
wire [7:0] w_ram_1053 ;
wire [7:0] w_ram_1054 ;
wire [7:0] w_ram_1055 ;
wire [7:0] w_ram_1056 ;
wire [7:0] w_ram_1057 ;
wire [7:0] w_ram_1058 ;


//2024-3-24 add for slot_id
wire [7:0] w_ram_1100 ;
wire [7:0] w_ram_1101 ;
wire [7:0] w_ram_1102 ;
wire [7:0] w_ram_1103 ;
wire [7:0] w_ram_1104 ;
wire [7:0] w_ram_1105 ;
wire [7:0] w_ram_1106 ;
wire [7:0] w_ram_1107 ;
wire [7:0] w_ram_1108 ;
wire [7:0] w_ram_1109 ;
wire [7:0] w_ram_110a ;
wire [7:0] w_ram_110b ;
wire [7:0] w_ram_110c ;
wire [7:0] w_ram_110d ;
wire [7:0] w_ram_110e ;
wire [7:0] w_ram_110f ;
wire [7:0] w_ram_1110 ;
wire [7:0] w_ram_1111 ;
wire [7:0] w_ram_1112 ;
wire [7:0] w_ram_1113 ;
wire [7:0] w_ram_1114 ;

////////////////////////////////////////////////////////////////////////////////////
//raed & write  register
////////////////////////////////////////////////////////////////////////////////////
reg [7:0]  r_reg_1006 ;  //test register

// reg [7:0]  r_reg_1010 ; 
// reg [7:0]  r_reg_1011 ; 
// reg [7:0]  r_reg_1012 ; 
// reg [7:0]  r_reg_1013 ;


reg [7:0]  r_reg_1020 ; 
reg [7:0]  r_reg_1021 ; 
reg [7:0]  r_reg_1022 ; 
reg [7:0]  r_reg_1023 ; 
reg [7:0]  r_reg_1024 ; 
reg [7:0]  r_reg_1025 ; 
reg [7:0]  r_reg_1026 ; 
reg [7:0]  r_reg_1027 ; 
reg [7:0]  r_reg_1028 ; 
reg [7:0]  r_reg_1029 ; 
reg [7:0]  r_reg_102a ; 
reg [7:0]  r_reg_102b ; 


////////////////////////////////////////////////////////////////////////////////////
//PCIE DYNC ALLOC 
////////////////////////////////////////////////////////////////////////////////////	
pcie_dync_alloc  cpu0_pe0_alloc
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_ocp1_x16_or_x8?1'b1:1'b0) ,  //2024-4-28 chg 1'b0 to 1'b1 for OCP x16//2024-5-7 i_ocp1_x16_or_x8
    .i_cable_id0_h       (1'b1) , 
    .i_cable_id1_l       (i_pal_mcio10_cable_id1) ,  
    .i_cable_id0_l       (i_pal_mcio10_cable_id0) ,
    .o_pcie_date         (w_cpu0_pe0_alloc)
);

pcie_dync_alloc  cpu0_pe1_alloc
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio11_cable_id1) ,   //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (i_pal_mcio11_cable_id0) , //1'b1
    .i_cable_id1_l       (i_pal_mcio12_cable_id1) ,  
    .i_cable_id0_l       (i_pal_mcio12_cable_id0) ,//1'b1
    .o_pcie_date         (w_cpu0_pe1_alloc)
);

pcie_dync_alloc  cpu0_pe2_alloc
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio13_cable_id1) ,  
    .i_cable_id0_h       (i_pal_mcio13_cable_id0) , 
    .i_cable_id1_l       (i_pal_mcio14_cable_id1) ,  
    .i_cable_id0_l       (i_pal_mcio14_cable_id0) ,
    .o_pcie_date         (w_cpu0_pe2_alloc)
);

// pcie_dync_alloc  cpu0_pe3_alloc
// (
    // .i_rst_n             (i_rst_n) , 
    // .i_clk               (i_clk) ,
    // .i_cable_id1_h       (1'b0) ,    //i_pal_mcio3_cable_id1  //2023-5-29 chg to fix 4'b0000
    // .i_cable_id0_h       (1'b0) ,    //i_pal_mcio3_cable_id0
    // .i_cable_id1_l       (1'b0) ,    //i_pal_mcio4_cable_id1
    // .i_cable_id0_l       (1'b0) ,    //i_pal_mcio4_cable_id0
    // .o_pcie_date         (w_cpu0_pe3_alloc)
// );
pcie_dync_alloc  cpu0_pe3_alloc  //2023-6-28 chg back to normal
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio3_cable_id1) ,    // 1'b0
    .i_cable_id0_h       (i_pal_mcio3_cable_id0) ,    // 1'b0
    .i_cable_id1_l       (i_pal_mcio4_cable_id1) ,    // 1'b0
    .i_cable_id0_l       (i_pal_mcio4_cable_id0) ,    // 1'b0
    .o_pcie_date         (w_cpu0_pe3_alloc)
);

pcie_dync_alloc  cpu0_pe4_alloc //2023-6-28 chg back to normal
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio1_cable_id1) ,  
    .i_cable_id0_h       (i_pal_mcio1_cable_id0) , 
    .i_cable_id1_l       (i_pal_mcio2_cable_id1) ,  
    .i_cable_id0_l       (i_pal_mcio2_cable_id0) ,
    .o_pcie_date         (w_cpu0_pe4_alloc)
);

// reg [3:0]     r_cpu0_pe4_alloc;  //2023-5-29 add 

// always@(posedge i_clk or negedge i_rst_n)
// begin
    // if(~i_rst_n)
	// begin
	    // r_cpu0_pe4_alloc <= 4'b1111;
	// end
	// else 
	// begin
	// case({i_pal_mcio1_cable_id1,i_pal_mcio1_cable_id0,i_pal_mcio2_cable_id1,i_pal_mcio2_cable_id0})
        // 4'b0000: r_cpu0_pe4_alloc <= 4'b0000;  	 
		// 4'b0101: r_cpu0_pe4_alloc <= 4'b0000; 
		// 4'b0111: r_cpu0_pe4_alloc <= 4'b0010;   //X4+X4+X8      //2023-5-31 add  //X8+X4+X4  //2023-6-1 chg to  X4+X4+X8
		// 4'b1101: r_cpu0_pe4_alloc <= 4'b0010;   //X4+X4+X8      //2023-5-31 add  //X8+X4+X4
        // 4'b1111: r_cpu0_pe4_alloc <= 4'b1111;   
	// default: r_cpu0_pe4_alloc <= 4'b1111;
	// endcase
	// end
// end

pcie_dync_alloc  cpu1_pe0_alloc
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio15_cable_id1) ,  //2023-5-25 add chg from 1111 to x1x1
    .i_cable_id0_h       (i_pal_mcio15_cable_id0) , //1'b1
    .i_cable_id1_l       (i_pal_mcio16_cable_id1) ,  
    .i_cable_id0_l       (i_pal_mcio16_cable_id0) ,//1'b1
    .o_pcie_date         (w_cpu1_pe0_alloc)
);

pcie_dync_alloc  cpu1_pe1_alloc
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio17_cable_id1) ,  
    .i_cable_id0_h       (i_pal_mcio17_cable_id0) , 
    .i_cable_id1_l       (i_pal_mcio18_cable_id1) ,  
    .i_cable_id0_l       (i_pal_mcio18_cable_id0) ,
    .o_pcie_date         (w_cpu1_pe1_alloc)
);

pcie_dync_alloc  cpu1_pe2_alloc  //2023-12-1 add back
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio19_cable_id1) ,  
    .i_cable_id0_h       (i_pal_mcio19_cable_id0) , 
    .i_cable_id1_l       (i_pal_mcio20_cable_id1) ,  
    .i_cable_id0_l       (i_pal_mcio20_cable_id0) ,
    .o_pcie_date         (w_cpu1_pe2_alloc)
);

// reg [3:0]     r_cpu1_pe2_alloc;  //2023-6-1 add  2023-6-29    //2023-12-1 delete

// always@(posedge i_clk or negedge i_rst_n)
// begin
    // if(~i_rst_n)
	// begin
	    // r_cpu1_pe2_alloc <= 4'b0000;
	// end
	// else 
	// begin
	// case({i_pal_mcio19_cable_id1,i_pal_mcio19_cable_id0,i_pal_mcio20_cable_id1,i_pal_mcio20_cable_id0}) //2023-6-1 add  
        // 4'b1111: r_cpu1_pe2_alloc <= 4'b1111;   
	// default: r_cpu1_pe2_alloc <= 4'b0000;
	// endcase
	// end
// end

// pcie_dync_alloc  cpu1_pe3_alloc
// (
    // .i_rst_n             (i_rst_n) , 
    // .i_clk               (i_clk) ,
    // .i_cable_id1_h       (1'b0) ,   //i_pal_mcio7_cable_id1  //2023-5-29 chg to fix 4'b0000
    // .i_cable_id0_h       (1'b0) ,   //i_pal_mcio7_cable_id0
    // .i_cable_id1_l       (1'b0) ,   //i_pal_mcio8_cable_id1
    // .i_cable_id0_l       (1'b0) ,   //i_pal_mcio8_cable_id0
    // .o_pcie_date         (w_cpu1_pe3_alloc)
// );
pcie_dync_alloc  cpu1_pe3_alloc   //2023-6-28 chg back to normal
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio7_cable_id1) ,   // 1'b0 
    .i_cable_id0_h       (i_pal_mcio7_cable_id0) ,   // 1'b0
    .i_cable_id1_l       (i_pal_mcio8_cable_id1) ,   // 1'b0
    .i_cable_id0_l       (i_pal_mcio8_cable_id0) ,   // 1'b0
    .o_pcie_date         (w_cpu1_pe3_alloc)
);

pcie_dync_alloc  cpu1_pe4_alloc
(
    .i_rst_n             (i_rst_n) , 
    .i_clk               (i_clk) ,
    .i_cable_id1_h       (i_pal_mcio5_cable_id1) ,   // 1'b0
    .i_cable_id0_h       (i_pal_mcio5_cable_id0) ,   // 1'b1
    .i_cable_id1_l       (i_pal_mcio6_cable_id1) ,   // 1'b0
    .i_cable_id0_l       (i_pal_mcio6_cable_id0) ,   // 1'b0
    .o_pcie_date         (w_cpu1_pe4_alloc)
);
// pcie_dync_alloc  cpu1_pe4_alloc
// (
    // .i_rst_n             (i_rst_n) , 
    // .i_clk               (i_clk) ,
    // .i_cable_id1_h       (1'b0) ,   //i_pal_mcio5_cable_id1  //2023-5-29 chg to fix 4'b0000  //2023-5-31 chg to fix 4'b0100
    // .i_cable_id0_h       (1'b1) ,   //i_pal_mcio5_cable_id0
    // .i_cable_id1_l       (1'b0) ,   //i_pal_mcio6_cable_id1
    // .i_cable_id0_l       (1'b0) ,   //i_pal_mcio6_cable_id0
    // .o_pcie_date         (w_cpu1_pe4_alloc)
// );

// reg [3:0]     r_cpu1_pe4_alloc;  //2023-5-31 add 

// always@(posedge i_clk or negedge i_rst_n)
// begin
    // if(~i_rst_n)
	// begin
	    // r_cpu1_pe4_alloc <= 4'b1111;
	// end
	// else 
	// begin
	// case({i_pal_mcio5_cable_id1,i_pal_mcio5_cable_id0,i_pal_mcio6_cable_id1,i_pal_mcio6_cable_id0}) //2023-5-31 chg 
        // 4'b0000: r_cpu1_pe4_alloc <= 4'b0000;  	 
		// 4'b0101: r_cpu1_pe4_alloc <= 4'b0000; 
		// 4'b0111: r_cpu1_pe4_alloc <= 4'b0010;   //X4+X4+X8   //X8+X4+X4   //2023-5-31 add    //2023-6-1 chg to  X4+X4+X8
		// 4'b1101: r_cpu1_pe4_alloc <= 4'b0010;   //X4+X4+X8   //X8+X4+X4   //2023-5-31 add
        // 4'b1111: r_cpu1_pe4_alloc <= 4'b1111;   
	// default: r_cpu1_pe4_alloc <= 4'b1111;
	// endcase
	// end
// end


////////////////////////////////////////////////////////////////////////////////////
//RO REG assignment
////////////////////////////////////////////////////////////////////////////////////
assign  w_ram_00c2  =   i_PRODUCT_LINE_C2;//2024-3-26 add
assign  w_ram_00c3  =   i_PRODUCT_GEN_ID_C3;
assign  w_ram_00c5  =   i_SERVER_ID_C5;
assign  w_ram_00c6  =   i_BOARD_ID_C6;

assign  w_ram_1000 = {w_cpu0_pe0_alloc,4'b1111}           ;
assign  w_ram_1001 = {w_cpu0_pe2_alloc,w_cpu0_pe1_alloc}  ;
assign  w_ram_1002 = {w_cpu0_pe4_alloc,w_cpu0_pe3_alloc}  ; //2023-6-28 chg back to normal
assign  w_ram_1003 = {w_cpu1_pe0_alloc,4'b0001}           ;
assign  w_ram_1004 = {w_cpu1_pe2_alloc,w_cpu1_pe1_alloc}  ; //2023-12-1 modify
assign  w_ram_1005 = {w_cpu1_pe4_alloc,w_cpu1_pe3_alloc}  ; //2023-6-28 chg back to normal

// assign  w_ram_1000 = {w_cpu0_pe0_alloc,4'b1111}           ;
// assign  w_ram_1001 = {w_cpu0_pe2_alloc,w_cpu0_pe1_alloc}  ;
// assign  w_ram_1002 = {r_cpu0_pe4_alloc,w_cpu0_pe3_alloc}  ; //w_cpu0_pe4_alloc //2023-5-29
// assign  w_ram_1003 = {w_cpu1_pe0_alloc,4'b0001}           ;
// assign  w_ram_1004 = {r_cpu1_pe2_alloc,w_cpu1_pe1_alloc}  ; //w_cpu1_pe2_alloc //2023-6-1
// assign  w_ram_1005 = {r_cpu1_pe4_alloc,w_cpu1_pe3_alloc}  ; //w_cpu1_pe4_alloc //2023-5-31

// assign  w_ram_1014 = {7'b0000000,i_opposite_wdt_done}     ;

// assign  o_espi_debug_ram_1000 = w_ram_1000;//2023-3-30 add for bios debug
// assign  o_espi_debug_ram_1001 = w_ram_1001;
// assign  o_espi_debug_ram_1002 = w_ram_1002;
// assign  o_espi_debug_ram_1003 = w_ram_1003;
// assign  o_espi_debug_ram_1004 = w_ram_1004;
// assign  o_espi_debug_ram_1005 = w_ram_1005;
// assign  o_espi_debug_ram_1014 = w_ram_1014;

// assign  w_ram_1050 = {r_1050_bit7_prsnt,i_espi_ram_1050[6:0]} ; //2023-9-20 modify
// assign  w_ram_1051 = {i_espi_ram_1051[7:3],r_1051_bit2_prsnt,r_1051_bit1_prsnt,r_1051_bit0_prsnt};
// assign  w_ram_1052 = i_espi_ram_1052 ;
// assign  w_ram_1053 = {7'b0000000,i_12lug_prsnt} ; //2023-10-14 modify  //2023-11-8 delete
// assign  w_ram_1053 = {i_espi_ram_1053[7:6],r_1053_bit5_prsnt,r_1053_bit4_prsnt,r_1053_bit3_prsnt,r_1053_bit2_prsnt,i_espi_ram_1053[1:0]} ; //2023-12-12 delete bit6
assign  w_ram_1050  = i_espi_ram_1050;
assign  w_ram_1051  = i_espi_ram_1051;
assign  w_ram_1052  = i_espi_ram_1052;
assign  w_ram_1053  = i_espi_ram_1053;
assign  w_ram_1054  = i_espi_ram_1054;
assign  w_ram_1055  = i_espi_ram_1055;
assign  w_ram_1056  = i_espi_ram_1056;
assign  w_ram_1057  = i_espi_ram_1057;
assign  w_ram_1058  = i_espi_ram_1058;


//2024-3-25 add for slot_id
assign  w_ram_1100 = i_espi_ram_1100 ;
assign  w_ram_1101 = i_espi_ram_1101 ;
assign  w_ram_1102 = i_espi_ram_1102 ;
assign  w_ram_1103 = i_espi_ram_1103 ;
assign  w_ram_1104 = i_espi_ram_1104 ;
assign  w_ram_1105 = i_espi_ram_1105 ;
assign  w_ram_1106 = i_espi_ram_1106 ;
assign  w_ram_1107 = i_espi_ram_1107 ;
assign  w_ram_1108 = i_espi_ram_1108 ;
assign  w_ram_1109 = i_espi_ram_1109 ;
assign  w_ram_110a = i_espi_ram_110a ;
assign  w_ram_110b = i_espi_ram_110b ;
assign  w_ram_110c = i_espi_ram_110c ;
assign  w_ram_110d = i_espi_ram_110d ;
assign  w_ram_110e = i_espi_ram_110e ;
assign  w_ram_110f = i_espi_ram_110f ;
assign  w_ram_1110 = i_espi_ram_1110 ;
assign  w_ram_1111 = i_espi_ram_1111 ;
assign  w_ram_1112 = i_espi_ram_1112 ;
assign  w_ram_1113 = i_espi_ram_1113 ;
assign  w_ram_1114 = i_espi_ram_1114 ;


////////////////////////////////////////////////////////////////////////////////////
//RW REG assignment
////////////////////////////////////////////////////////////////////////////////////
assign  o_test_reg           = r_reg_1006 ;

// assign  o_espi_wdt_cfg       = r_reg_1010 ;
// assign  o_espi_wdt_value_set = r_reg_1011 ;
// assign  o_espi_wdt_cnt_clr   = r_reg_1012 ;
// assign  o_espi_int_clr       = r_reg_1013 ;

////////////////////////////////////VMD ON OFF 2023-12-13 ADD ////////////////////////////////////////////////////////////////////
assign  o_espi_debug_ram_1020  = r_reg_1020 ;
assign  o_espi_debug_ram_1021  = r_reg_1021 ;
assign  o_espi_debug_ram_1022  = r_reg_1022 ;
assign  o_espi_debug_ram_1023  = r_reg_1023 ;
assign  o_espi_debug_ram_1024  = r_reg_1024 ;
assign  o_espi_debug_ram_1025  = r_reg_1025 ;
assign  o_espi_debug_ram_1026  = r_reg_1026 ;
assign  o_espi_debug_ram_1027  = r_reg_1027 ;
assign  o_espi_debug_ram_1028  = r_reg_1028 ;
assign  o_espi_debug_ram_1029  = r_reg_1029 ;
assign  o_espi_debug_ram_102a  = r_reg_102a ;
assign  o_espi_debug_ram_102b  = r_reg_102b ;
////////////////////////////////////VMD ON OFF 2023-12-13 ADD ////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Read data from cpld
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always@(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
	begin
	    r_espi_date_in  <= 8'h00;
	end
	else 
	begin
	case(i_espi_addr)
                16'h00c2: r_espi_date_in <= w_ram_00c2;//RO
                16'h00c3: r_espi_date_in <= w_ram_00c3;//RO
                16'h00c5: r_espi_date_in <= w_ram_00c5;//RO
                16'h00c6: r_espi_date_in <= w_ram_00c6;//RO
                
                16'h1000: r_espi_date_in <= w_ram_1000;//RO
                16'h1001: r_espi_date_in <= w_ram_1001;//RO
                16'h1002: r_espi_date_in <= w_ram_1002;//RO
                16'h1003: r_espi_date_in <= w_ram_1003;//RO
                16'h1004: r_espi_date_in <= w_ram_1004;//RO
                16'h1005: r_espi_date_in <= w_ram_1005;//RO
                16'h1006: r_espi_date_in <= r_reg_1006;//Rw
		
		// 16'h1010: r_espi_date_in <= r_reg_1010;//Rw
		// 16'h1011: r_espi_date_in <= r_reg_1011;//Rw
		// 16'h1012: r_espi_date_in <= r_reg_1012;//Rw
		// 16'h1013: r_espi_date_in <= r_reg_1013;//Rw
		// 16'h1014: r_espi_date_in <= w_ram_1014;//RO
		
		16'h1020: r_espi_date_in <= r_reg_1020;//Rw  //2023-12-13 add for VMD
		16'h1021: r_espi_date_in <= r_reg_1021;//Rw
		16'h1022: r_espi_date_in <= r_reg_1022;//Rw
		16'h1023: r_espi_date_in <= r_reg_1023;//Rw
		16'h1024: r_espi_date_in <= r_reg_1024;//Rw
		16'h1025: r_espi_date_in <= r_reg_1025;//Rw
		16'h1026: r_espi_date_in <= r_reg_1026;//Rw
		16'h1027: r_espi_date_in <= r_reg_1027;//Rw
		16'h1028: r_espi_date_in <= r_reg_1028;//Rw
		16'h1029: r_espi_date_in <= r_reg_1029;//Rw
		16'h102a: r_espi_date_in <= r_reg_102a;//Rw
		16'h102b: r_espi_date_in <= r_reg_102b;//Rw
		
		16'h1050: r_espi_date_in <= w_ram_1050;//RO
		16'h1051: r_espi_date_in <= w_ram_1051;//RO
		16'h1052: r_espi_date_in <= w_ram_1052;//RO		
		16'h1053: r_espi_date_in <= w_ram_1053;//RO
		16'h1054: r_espi_date_in <= w_ram_1054;//RO		
		16'h1055: r_espi_date_in <= w_ram_1055;//RO
		16'h1056: r_espi_date_in <= w_ram_1056;//RO
		16'h1057: r_espi_date_in <= w_ram_1057;//RO		
		16'h1058: r_espi_date_in <= w_ram_1058;//RO

                //2024-3-24 add for slot_id
                16'h1100: r_espi_date_in <= w_ram_1100;//RO
                16'h1101: r_espi_date_in <= w_ram_1101;//RO
                16'h1102: r_espi_date_in <= w_ram_1102;//RO
                16'h1103: r_espi_date_in <= w_ram_1103;//RO
                16'h1104: r_espi_date_in <= w_ram_1104;//RO
                16'h1105: r_espi_date_in <= w_ram_1105;//RO
                16'h1106: r_espi_date_in <= w_ram_1106;//RO
                16'h1107: r_espi_date_in <= w_ram_1107;//RO
                16'h1108: r_espi_date_in <= w_ram_1108;//RO
                16'h1109: r_espi_date_in <= w_ram_1109;//RO
                16'h110a: r_espi_date_in <= w_ram_110a;//RO
                16'h110b: r_espi_date_in <= w_ram_110b;//RO
                16'h110c: r_espi_date_in <= w_ram_110c;//RO
                16'h110d: r_espi_date_in <= w_ram_110d;//RO
                16'h110e: r_espi_date_in <= w_ram_110e;//RO
                16'h110f: r_espi_date_in <= w_ram_110f;//RO
                16'h1110: r_espi_date_in <= w_ram_1110;//RO
                16'h1111: r_espi_date_in <= w_ram_1111;//RO
                16'h1112: r_espi_date_in <= w_ram_1112;//RO
                16'h1113: r_espi_date_in <= w_ram_1113;//RO
                16'h1114: r_espi_date_in <= w_ram_1114;//RO

		
	default: r_espi_date_in <= 8'h00;
	endcase
	end
end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//write data to cpld
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  
//0x1006 test register
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1006  <=8'h55;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1006))  begin
        r_reg_1006  <= ~i_espi_date_out;
    end
end

// //0x1010 espi wdt cfg register
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n)  begin
        // r_reg_1010  <=8'hff;
    // end
    // else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1010))  begin
        // r_reg_1010  <= i_espi_date_out;
    // end
// end

// //0x1011 wdt value set register
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n)  begin
        // r_reg_1011  <=8'hc4;//0xc4 //2023-5-4
    // end
    // else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1011))  begin
        // r_reg_1011  <= i_espi_date_out;
    // end
// end

// //0x1012 espi wdt cnt clr register
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n)  begin
        // r_reg_1012  <= 8'h00;
    // end
	// else begin
	    // if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1012))  begin
		    // r_reg_1012  <=  8'h00; 
		// end
		// else if (r_reg_1012 == r_reg_1011) begin 
		    // r_reg_1012  <= r_reg_1012 ;
		// end
		// else if (i_clk_10ms && (r_reg_1010[0] == 1'b0)) begin 
		    // r_reg_1012  <= r_reg_1012 + 1'b1;
		// end
		// else begin 
		    // r_reg_1012  <= r_reg_1012;
		// end
	// end
// end	
	
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n)  begin
		// r_espi_wdt_done <= 1'b0;
    // end
	// else begin
	    // if(r_reg_1012 == 8'h00)  begin
			// r_espi_wdt_done <= 1'b0;
		// end
		// else if (r_reg_1012 == r_reg_1011) begin 
		    // r_espi_wdt_done <= 1'b1;
		// end
	// end
// end	
	
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n)  begin
        // r_reg_1012  <=8'h00;
		// r_espi_wdt_done <= 1'b0;
    // end
    // else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1012))  begin //  pch clear wdt cnt every 50ms
        // r_reg_1012  <= i_espi_date_out; //8'h00;
		// r_espi_wdt_done <= 1'b0;
    // end
    // else if(r_reg_1012 >= r_reg_1011) begin    // cnt value overload     
	    // r_reg_1012      <= r_reg_1012;
	    // r_espi_wdt_done <= 1'b1;
	// end
	// else if(i_clk_10ms && (r_reg_1010[0] == 1'b0))
		// r_reg_1012  <= r_reg_1012 + 1;
    // else
        // r_reg_1012  <= r_reg_1012;
// end	
	
	
	
	
    // else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1012))  begin //  pch clear wdt cnt every 50ms
        // r_reg_1012  <= i_espi_date_out; //8'h00; i_espi_date_out //
		// r_espi_wdt_done <= 1'b0;
    // end
    // else if((r_reg_1012 >= 8'hff)) begin    // cnt value overload    
	    // r_reg_1012      <= r_reg_1012;
	    // r_espi_wdt_done <= 1'b1;
	// end
	// else if(i_clk_10ms && (r_reg_1010[0] == 1'b0) && i_SW_8) begin//2023-5-6 chg to w_clk_10ms_pos
		// r_reg_1012  <= r_reg_1012 + 1'b1;
		// r_espi_wdt_done <= 1'b0;
	// end
    // else begin
        // r_reg_1012  <= r_reg_1012;
		// r_espi_wdt_done <= 1'b0;
	// end
// end

// //0x1013 int clr register
// always@(posedge i_clk or negedge i_rst_n) begin
    // if(~i_rst_n)  begin
        // r_reg_1013  <=8'hff;
    // end
    // else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1013))  begin
        // r_reg_1013  <= i_espi_date_out;//8'hfe;
    // end
	// // else if((i_espi_int_clr_done == 1'b0))  begin  //2023-5-4
        // // r_reg_1013[0]  <= 1'b1;
    // // end
	// // else  begin          //2023-5-6
        // // r_reg_1013[4]  <= i_opposite_wdt_done; //2023-5-8 delete
    // // end
	
// end	

////////////////////////////////////VMD ON OFF 2023-12-13 ADD ////////////////////////////////////////////////////////////////////
//0x1020
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1020  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1020))  begin
        r_reg_1020  <= i_espi_date_out;
    end
end

//0x1021
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1021  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1021))  begin
        r_reg_1021  <= i_espi_date_out;
    end
end

//0x1022
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1022  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1022))  begin
        r_reg_1022  <= i_espi_date_out;
    end
end

//0x1023
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1023  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1023))  begin
        r_reg_1023  <= i_espi_date_out;
    end
end

//0x1024
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1024  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1024))  begin
        r_reg_1024  <= i_espi_date_out;
    end
end

//0x1025
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1025  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1025))  begin
        r_reg_1025  <= i_espi_date_out;
    end
end

//0x1026
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1026  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1026))  begin
        r_reg_1026  <= i_espi_date_out;
    end
end

//0x1027
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1027  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1027))  begin
        r_reg_1027  <= i_espi_date_out;
    end
end

//0x1028
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1028  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1028))  begin
        r_reg_1028  <= i_espi_date_out;
    end
end

//0x1029
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_1029  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h1029))  begin
        r_reg_1029  <= i_espi_date_out;
    end
end

//0x102a
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_102a  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h102a))  begin
        r_reg_102a  <= i_espi_date_out;
    end
end

//0x102b
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)  begin
        r_reg_102b  <=8'hff;
    end
    else if((i_espi_wdata_en == 1'b1)&&(i_espi_addr==16'h102b))  begin
        r_reg_102b  <= i_espi_date_out;
    end
end
////////////////////////////////////VMD ON OFF 2023-12-13 ADD ////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//espi wdt 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// //2023-5-6 add 
// Edge_Detect(
// .i_clk              (i_clk),  //input Clk
// .i_rst_n            (i_rst_n),  //Global rst,Active Low
// .i_signal           (i_clk_10ms),

// .o_signal_pos       (w_clk_10ms_pos),
// .o_signal_neg       (),
// .o_signal_invert    ()
// );






















// reg  r_int_cnt;     
// reg  r_int_cnt_done;


// always@(posedge i_rst_n or negedge i_rst_n) 
// begin
    // if(~i_rst_n)    
	// begin
		// r_int_cnt      <= 8'd0; 
		// r_int_cnt_done <= 1'b0;
	// end
	// else 
    // begin
		// if(r_reg_1013[0] ==1'b0) // clr cnt 
		// begin
			// r_int_cnt       <= 8'd0;
			// r_int_cnt_done  <= 1'b0;		
		// end
		// else if(r_int_cnt >= 50)    // cnt value overload    
		// begin
			// r_int_cnt      <= r_int_cnt;
			// r_int_cnt_done <= 1'b1;
		// end
		// else if(i_clk_10ms)
			// r_int_cnt  <= r_int_cnt + 1;
        // else
            // r_int_cnt  <= r_int_cnt;     		
	// end
// end


















	
endmodule 