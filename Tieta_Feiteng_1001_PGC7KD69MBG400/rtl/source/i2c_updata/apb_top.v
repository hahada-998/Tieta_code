/**********************************************************************************************************************************/
// Copyright(c) 2020, Hangzhou CNIT Technologies Co., Ltd, All right reserved
// Project      :   
// Filename     :   apb_top.v
// Author       :   w00641
// Email        :   wanglin@cloudnineinfo.com
// Date         :   2025-05-19
// Description  :   
// Device       :   
// Modification History:
/**************************************************************版本记录************************************************************/
// 2025-05-19   wanglin        1.0           1、文件创建；2、按照CPLD开发checklist2.0版本check修改
// 2025-10-14   caohong        1.1           1、支持紫光PDS工具不同版本选择GTP_APB原语模块;

module apb_top # (
    parameter       PG_PDS_VER = "PDS2024.2" , // 紫光PDS版本信息
    parameter       SIM_DEVICE = "PGC7KD"    
)
(
    input           clk         ,
    input           rst_n       ,
    output [7:0]    i2c_tx_data ,
    input           i2c_tx_req  ,
    output          i2c_tx_vld  ,
    input  [7:0]    i2c_rx_data ,
    input           i2c_rx_vld  ,
    output          i2c_rx_rdy  /* synthesis PAP_MARK_DEBUG="true" */,
    output          o_check_done/* synthesis PAP_MARK_DEBUG="true" */,

    input  [1:0]    mux_sel     ,
    input  [4:0]    APB_PADDR   ,
    input           APB_PSEL    ,
    input           APB_PENABLE ,
    output          APB_PREADY  , 
    input           APB_PWRITE  ,
    input  [7:0]    APB_PWDATA  ,
    output [7:0]    APB_PRDATA  

    //input         scki        ,
    //input         sdai        ,
    //output        scko        ,
    //output        sdao        ,
    //inout         sck         , 
    //inout         sda         ,
    //output        o_check_done
);

//localparam SLAVE_ADDR = 7'h4a ;

wire [4:0] 	apb_addr	;
wire        apb_sel		;
wire       	apb_en		;
wire       	apb_wr		;
wire [7:0] 	apb_wdata	;
wire [7:0] 	apb_rdata	;
wire       	apb_rdy		/* synthesis PAP_MARK_DEBUG="true" */; 
wire       	apb_irq		;		
//wire [7:0]i2c_tx_data	;
//wire      i2c_tx_req	;
//wire      i2c_tx_vld	; 
//wire [7:0]i2c_rx_data	;
//wire      i2c_rx_vld	;
//wire      i2c_rx_rdy	;
wire        i2c_lost_arb;
wire        i2c_rst_n   /* synthesis PAP_MARK_DEBUG="true" */;

assign i2c_rst_n = rst_n & o_check_done;

/*
assign sda = sdao ? 1'bz : 1'b0;
assign sdai = sda;

assign sck = scko ? 1'bz : 1'b0;
assign scki = sck;

pgr_i2c_sif u_sif(
    .clk                (clk                ),
    .rst_n              (i2c_rst_n          ),

    .sck_i              (scki               ),
    .sck_o              (scko               ),
    .sda_i              (sdai               ),
    .sda_o              (sdao               ),

    .device_addr        (SLAVE_ADDR         ),
    .addr_ack_wr        (1'b1               ),
    .addr_ack_rd        (1'b1               ),
    .rx_ack_en          (1'b1               ),
    .hold_timer         (16'b0              ),
    .hold_timer_en      (1'b0               ),

    .tx_data            (i2c_tx_data        ),//input
    .tx_req             (i2c_tx_req         ),
    .tx_vld             (i2c_tx_vld         ),
    .rx_data            (i2c_rx_data        ),//output
    .rx_vld             (i2c_rx_vld         ),
    .rx_rdy             (i2c_rx_rdy         ),

    .lost_arb           (i2c_lost_arb       )
);*/

iic2apb_ctrl u_iic2apb_ctrl(
    .clk		        ( clk		    ),//pclk rise      in
    .rst_n		        ( i2c_rst_n     ),//presetn        in
    .apb_addr	        ( apb_addr	    ),//paddr[4:0]     out
    .apb_sel	        ( apb_sel	    ),//psel           out
    .apb_en		        ( apb_en        ),//penable        out 
    .apb_wr		        ( apb_wr	    ),//pwrite 1 write out 
    .apb_wdata	        ( apb_wdata	    ),//pwdata[7:0]    out 
    .apb_rdata	        ( apb_rdata	    ),//prdata         in
    .apb_rdy	        ( apb_rdy	    ),//pready         in
    .apb_irq	        ( apb_irq	    ),//user_apb_irq   in
    .i2c_tx_data        ( i2c_tx_data   ),//output 8bit
    .i2c_tx_req	        ( i2c_tx_req	),//input 
    .i2c_tx_vld	        ( i2c_tx_vld	),//output 
    .i2c_rx_data        ( i2c_rx_data   ),//input  8bit
    .i2c_rx_vld	        ( i2c_rx_vld	),//input
    .i2c_rx_rdy	        ( i2c_rx_rdy	),//output
    .i2c_lost_arb       ( 1'b0          ) //input
);

bar_top #(
    .PG_PDS_VER         (PG_PDS_VER     ),
    .SIM_DEVICE         (SIM_DEVICE     )
)
u_bar_top(
    .i_clk              (clk            ),
    .i_rst_n            (rst_n          ),
    .o_check_done       (o_check_done   ),
    .user_apb_rdata     (apb_rdata      ),
    .user_apb_addr      (apb_addr       ),
    .user_apb_wdata     (apb_wdata      ),
    .user_apb_irq       (apb_irq        ),
    .user_apb_irq_ccs   (               ),
    .user_apb_rdy       (apb_rdy        ),
    .user_apb_clk       (clk            ),
    .user_apb_en        (apb_en         ),
    .user_apb_rst_n     (rst_n          ),
    .user_apb_sel_ccs   (apb_sel        ),
    .user_apb_sel_i2c0  (1'b0           ),
    .user_apb_sel_i2c1  (1'b0           ),
    .user_apb_sel_pll0  (1'b0           ),
    .user_apb_sel_pll1  (1'b0           ),
    .user_apb_sel_spi   (1'b0           ),
    .user_apb_sel_timer (1'b0           ),
    .user_apb_wr        (apb_wr         ),

    .mux_sel            (mux_sel        ),
    .APB_PADDR 			(APB_PADDR 	    ),
    .APB_PSEL  			(APB_PSEL  	    ),
    .APB_PENABLE		(APB_PENABLE    ),
    .APB_PREADY			(APB_PREADY	    ), 
    .APB_PWRITE			(APB_PWRITE	    ),
    .APB_PWDATA			(APB_PWDATA	    ),
    .APB_PRDATA			(APB_PRDATA	    )		     
);

endmodule
