/**********************************************************************************************************************************/
// Copyright(c) 2020, Hangzhou CNIT Technologies Co., Ltd, All right reserved
// Project      :   
// Filename     :   bar_top.v
// Author       :   w00641
// Email        :   wanglin@cloudnineinfo.com
// Date         :   2025-05-19
// Description  :   
// Device       :   
// Modification History:
/**************************************************************版本记录************************************************************/
// 2025-05-19   wanglin        1.0           1、文件创建;
// 2025-10-14   caohong        1.1           1、按照CPLD开发checklist2.0版本check修改;
//                                           2、支持紫光PDS工具不同版本选择GTP_APB原语模块;

module bar_top #(
    parameter       PG_PDS_VER = "PDS2024.2" , // 紫光PDS版本信息
    parameter       SIM_DEVICE = "PGC7KD"
)
(
    input           i_clk             ,
    input           i_rst_n           ,
    output          o_check_done      /* synthesis PAP_MARK_DEBUG="true" */,
    output  [7:0]   user_apb_rdata    ,
    input   [4:0]   user_apb_addr     ,
    input   [7:0]   user_apb_wdata    ,
    output          user_apb_irq      ,
    output          user_apb_irq_ccs  ,
    output          user_apb_rdy      /* synthesis PAP_MARK_DEBUG="true" */,
    input           user_apb_clk      ,
    input           user_apb_en       ,
    input           user_apb_rst_n    ,
    input           user_apb_sel_ccs  ,
    input           user_apb_sel_i2c0 ,
    input           user_apb_sel_i2c1 ,
    input           user_apb_sel_pll0 ,
    input           user_apb_sel_pll1 ,
    input           user_apb_sel_spi  ,
    input           user_apb_sel_timer,
    input           user_apb_wr       ,

    input   [1:0]   mux_sel           ,
    input   [4:0]   APB_PADDR         ,
    input           APB_PSEL          ,
    input           APB_PENABLE       ,
    output          APB_PREADY        , 
    input           APB_PWRITE        ,
    input   [7:0]   APB_PWDATA        ,
    output  [7:0]   APB_PRDATA        
);

wire WR                               ;
wire SEL_TIMER                        ;
wire SEL_SPI                          ;
wire SEL_PLL1                         ;
wire SEL_PLL0                         ;
wire SEL_I2C1                         ;
wire SEL_I2C0                         ;
wire SEL_CCS                          /* synthesis PAP_MARK_DEBUG="true" */;
wire RST_N                            /* synthesis PAP_MARK_DEBUG="true" */;
wire EN                               /* synthesis PAP_MARK_DEBUG="true" */;
wire CLK                              /* synthesis PAP_MARK_DEBUG="true" */;
wire RDY                              /* synthesis PAP_MARK_DEBUG="true" */;
wire IRQ_CCS                          ;
wire IRQ                              ;
wire [7:0] WDATA                      /* synthesis PAP_MARK_DEBUG="true" */;
wire [4:0] ADDR                       /* synthesis PAP_MARK_DEBUG="true" */;
wire [7:0] RDATA                      /* synthesis PAP_MARK_DEBUG="true" */;
wire wr                               ;
wire sel_ccs                          ;
wire en                               ;
wire rdy                              ;
wire [7:0] wdata                      ;
wire [4:0] addr                       ;
wire [7:0] rdata                      ;

generate    
    if (PG_PDS_VER == "PDS2022.2") begin
        GTP_APB #(
            .IDCODE        ('b10101010101010100101010101010101),
            .USERCODE      ('b00000000000000000000000000000000)
        ) u_gtp_apb0 (
            .RDATA         ( RDATA          ),        // OUTPUT[7:0]     prdata[7:0]
            .ADDR          ( ADDR           ),        // INPUT[4:0]      paddr[4:0]
            .WDATA         ( WDATA          ),        // INPUT[7:0]   ---pwdata[7:0]
            .IRQ           ( IRQ            ),        // OUTPUT  
            .IRQ_CCS       ( IRQ_CCS        ),        // OUTPUT  
            .RDY           ( RDY            ),        // OUTPUT       ----pready
            .CLK           ( CLK            ),        // INPUT        ----pclk
            .EN            ( EN             ),        // INPUT        ----penable
            .RST_N         ( RST_N          ),        // INPUT        ----presetn
            .SEL_CCS       ( SEL_CCS        ),        // INPUT        ----psel
            .SEL_I2C0      ( SEL_I2C0       ),        // INPUT  
            .SEL_I2C1      ( SEL_I2C1       ),        // INPUT  
            .SEL_PLL0      ( SEL_PLL0       ),        // INPUT  
            .SEL_PLL1      ( SEL_PLL1       ),        // INPUT  
            .SEL_SPI       ( SEL_SPI        ),        // INPUT  
            .SEL_TIMER     ( SEL_TIMER      ),        // INPUT  
            .WR            ( WR             )         // INPUT        ----pwrite
        );
    end 
    else begin // 默认为PDS2024.2版本
        GTP_APB #(
            .SIM_DEVICE    (SIM_DEVICE),              //string
            .IDCODE        ('b10101010101010100101010101010101),
            .USERCODE      ('b00000000000000000000000000000000)
        ) u_gtp_apb1 (
            .RDATA         ( RDATA          ),        // OUTPUT[7:0]     prdata[7:0]
            .ADDR          ( ADDR           ),        // INPUT[4:0]      paddr[4:0]
            .WDATA         ( WDATA          ),        // INPUT[7:0]   ---pwdata[7:0]
            .IRQ           ( IRQ            ),        // OUTPUT  
            .IRQ_CCS       ( IRQ_CCS        ),        // OUTPUT  
            .RDY           ( RDY            ),        // OUTPUT       ----pready
            .CLK           ( CLK            ),        // INPUT        ----pclk
            .EN            ( EN             ),        // INPUT        ----penable
            .RST_N         ( RST_N          ),        // INPUT        ----presetn
            .SEL_CCS       ( SEL_CCS        ),        // INPUT        ----psel
            .SEL_I2C0      ( SEL_I2C0       ),        // INPUT  
            .SEL_I2C1      ( SEL_I2C1       ),        // INPUT  
            .SEL_PLL0      ( SEL_PLL0       ),        // INPUT  
            .SEL_PLL1      ( SEL_PLL1       ),        // INPUT  
            .SEL_SPI       ( SEL_SPI        ),        // INPUT  
            .SEL_TIMER     ( SEL_TIMER      ),        // INPUT  
            .WR            ( WR             )         // INPUT        ----pwrite
        );
    end
endgenerate

//apb_ctrl u_apb_ctrl(
//    .i_clk       ( i_clk          ) ,
//    .i_rst_n     ( i_rst_n        ) ,
//    .o_check_done( o_check_done   ) ,
//    .o_wr        ( wr             ) , // pwrite
//    .o_sel_ccs   ( sel_ccs        ) ,
//    .o_en        ( en             ) , // penable
//    .i_rdy       ( rdy            ) , // input
//    .o_wdata     ( wdata          ) ,
//    .o_addr      ( addr           ) ,
//    .i_rdata     ( rdata          ) 
//);

assign o_check_done = 1'b0;

apb_mux u_apb_mux(
    .mux_sel            ( mux_sel                ),
    .RDATA              ( RDATA                  ),
    .ADDR               ( ADDR                   ),
    .WDATA              ( WDATA                  ),
    .IRQ                ( IRQ                    ),
    .IRQ_CCS            ( IRQ_CCS                ),
    .RDY                ( RDY                    ),
    .CLK                ( CLK                    ),
    .EN                 ( EN                     ),
    .RST_N              ( RST_N                  ),
    .SEL_CCS            ( SEL_CCS                ),
    .SEL_I2C0           ( SEL_I2C0               ),
    .SEL_I2C1           ( SEL_I2C1               ),
    .SEL_PLL0           ( SEL_PLL0               ),
    .SEL_PLL1           ( SEL_PLL1               ),
    .SEL_SPI            ( SEL_SPI                ),
    .SEL_TIMER          ( SEL_TIMER              ),
    .WR                 ( WR                     ),
    .bar_rdata          ( rdata                  ),
    .bar_addr           ( 5'd0                   ),
    .bar_wdata          ( 8'd0                   ),
    .bar_irq            (                        ),
    .bar_irq_ccs        (                        ),
    .bar_rdy            ( rdy                    ),
    .bar_clk            ( i_clk                  ),
    .bar_en             ( 1'b0                   ),
    .bar_rst_n          ( 1'b1                   ),
    .bar_sel_ccs        ( 1'b1                   ),
    .bar_sel_i2c0       ( 1'b0                   ),
    .bar_sel_i2c1       ( 1'b0                   ),
    .bar_sel_pll0       ( 1'b0                   ),
    .bar_sel_pll1       ( 1'b0                   ),
    .bar_sel_spi        ( 1'b0                   ),
    .bar_sel_timer      ( 1'b0                   ),
    .bar_wr             ( 1'b0                   ),// pwrite
    .user_apb_rdata     ( user_apb_rdata         ),
    .user_apb_addr      ( user_apb_addr          ),
    .user_apb_wdata     ( user_apb_wdata         ),
    .user_apb_irq       ( user_apb_irq           ),
    .user_apb_irq_ccs   ( user_apb_irq_ccs       ),
    .user_apb_rdy       ( user_apb_rdy           ),
    .user_apb_clk       ( user_apb_clk           ),
    .user_apb_en        ( user_apb_en            ),
    .user_apb_rst_n     ( user_apb_rst_n         ),
    .user_apb_sel_ccs   ( user_apb_sel_ccs       ),
    .user_apb_sel_i2c0  ( user_apb_sel_i2c0      ),
    .user_apb_sel_i2c1  ( user_apb_sel_i2c1      ),
    .user_apb_sel_pll0  ( user_apb_sel_pll0      ),
    .user_apb_sel_pll1  ( user_apb_sel_pll1      ),
    .user_apb_sel_spi   ( user_apb_sel_spi       ),
    .user_apb_sel_timer ( user_apb_sel_timer     ),
    .user_apb_wr        ( user_apb_wr            ),

    .APB_PADDR 			(APB_PADDR 	             ),
    .APB_PSEL  			(APB_PSEL  	             ),
    .APB_PENABLE		(APB_PENABLE             ),
    .APB_PREADY			(APB_PREADY	             ), 
    .APB_PWRITE			(APB_PWRITE	             ),
    .APB_PWDATA			(APB_PWDATA	             ),
    .APB_PRDATA			(APB_PRDATA	             )		    
);

endmodule
