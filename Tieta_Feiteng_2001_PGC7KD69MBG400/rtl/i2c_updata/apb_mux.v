/**********************************************************************************************************************************/
// Copyright(c) 2020, Hangzhou CNIT Technologies Co., Ltd, All right reserved
// Project      :   
// Filename     :   apb_mux.v
// Author       :   w00641
// Email        :   wanglin@cloudnineinfo.com
// Date         :   2025-05-19
// Description  :   
// Device       :   
// Modification History:
/**************************************************************版本记录************************************************************/
// 2025-05-19   wanglin        1.0           1、文件创建；2、按照CPLD开发checklist2.0版本check修改;
// 2025-10-14   caohong        1.1           1、消除APB_PRDATA、APB_PREADY等信号组合逻辑报latch告警问题;

module apb_mux(
input       [1:0]   mux_sel         /* synthesis PAP_MARK_DEBUG="true" */,
input       [7:0]   RDATA           ,
output reg  [4:0]   ADDR            ,
output reg  [7:0]   WDATA           ,
input               IRQ             ,
input               IRQ_CCS         ,
input               RDY             ,
output reg          CLK             ,
output reg          EN              ,
output reg          RST_N           ,
output reg          SEL_CCS         ,
output reg          SEL_I2C0        ,
output reg          SEL_I2C1        ,
output reg          SEL_PLL0        ,
output reg          SEL_PLL1        ,
output reg          SEL_SPI         ,
output reg          SEL_TIMER       ,
output reg          WR              ,
output reg  [7:0]   bar_rdata       ,
input       [4:0]   bar_addr        ,
input       [7:0]   bar_wdata       ,
output reg          bar_irq         ,
output reg          bar_irq_ccs     ,
output reg          bar_rdy         ,
input               bar_clk         ,
input               bar_en          ,
input               bar_rst_n       ,
input               bar_sel_ccs     ,
input               bar_sel_i2c0    ,
input               bar_sel_i2c1    ,
input               bar_sel_pll0    ,
input               bar_sel_pll1    ,
input               bar_sel_spi     ,
input               bar_sel_timer   ,
input               bar_wr          ,
output reg  [7:0]   user_apb_rdata  ,
input       [4:0]   user_apb_addr   ,
input       [7:0]   user_apb_wdata  ,
output reg          user_apb_irq    ,
output reg          user_apb_irq_ccs,
output reg          user_apb_rdy    /* synthesis PAP_MARK_DEBUG="true" */,
input               user_apb_clk    ,
input               user_apb_en     ,
input               user_apb_rst_n  ,
input               user_apb_sel_ccs    ,
input               user_apb_sel_i2c0   ,
input               user_apb_sel_i2c1   ,
input               user_apb_sel_pll0   ,
input               user_apb_sel_pll1   ,
input               user_apb_sel_spi    ,
input               user_apb_sel_timer  ,
input               user_apb_wr     ,

input       [4:0]   APB_PADDR       ,
input               APB_PSEL        ,
input               APB_PENABLE     ,
output reg          APB_PREADY      ,
input               APB_PWRITE      ,
input       [7:0]   APB_PWDATA      ,
output reg  [7:0]   APB_PRDATA      
);

always@(*)
begin
    if(mux_sel == 2'b01) begin
        ADDR            = user_apb_addr;
        WDATA           = user_apb_wdata;
        CLK             = user_apb_clk;
        EN              = user_apb_en;
        RST_N           = user_apb_rst_n;
        SEL_CCS         = user_apb_sel_ccs;
        SEL_I2C0        = user_apb_sel_i2c0;
        SEL_I2C1        = user_apb_sel_i2c1;
        SEL_PLL0        = user_apb_sel_pll0;
        SEL_PLL1        = user_apb_sel_pll1;
        SEL_SPI         = user_apb_sel_spi;
        SEL_TIMER       = user_apb_sel_timer;
        WR              = user_apb_wr;
        user_apb_rdata  = RDATA;
        user_apb_irq    = IRQ;
        user_apb_irq_ccs= IRQ_CCS;
        user_apb_rdy    = RDY;
        bar_rdata       = 8'b0;
        bar_irq         = 1'b0;
        bar_irq_ccs     = 1'b0;
        bar_rdy         = 1'b0;
        APB_PRDATA      = 8'b0;
        APB_PREADY      = 1'b0;
    end
    else if(mux_sel == 2'b10) begin
        ADDR            = APB_PADDR;
        WDATA           = APB_PWDATA;
        CLK             = user_apb_clk;
        EN              = APB_PENABLE;
        RST_N           = user_apb_rst_n;
        SEL_CCS         = APB_PSEL;
        SEL_I2C0        = 1'b0;
        SEL_I2C1        = 1'b0;
        SEL_PLL0        = 1'b0;
        SEL_PLL1        = 1'b0;
        SEL_SPI         = 1'b0;
        SEL_TIMER       = 1'b0;
        WR              = APB_PWRITE;
        APB_PRDATA      = RDATA;
        user_apb_irq    = IRQ;
        user_apb_irq_ccs= IRQ_CCS;
        APB_PREADY      = RDY;
        bar_rdata       = 8'b0;
        bar_irq         = 1'b0;
        bar_irq_ccs     = 1'b0;
        bar_rdy         = 1'b0;
        user_apb_rdata  = 8'b0;
        user_apb_rdy    = 1'b0;
    end
    else begin
        ADDR            = bar_addr;
        WDATA           = bar_wdata;
        CLK             = bar_clk;
        EN              = bar_en;
        RST_N           = bar_rst_n;
        SEL_CCS         = bar_sel_ccs;
        SEL_I2C0        = bar_sel_i2c0;
        SEL_I2C1        = bar_sel_i2c1;
        SEL_PLL0        = bar_sel_pll0;
        SEL_PLL1        = bar_sel_pll1;
        SEL_SPI         = bar_sel_spi;
        SEL_TIMER       = bar_sel_timer;
        WR              = bar_wr;
        bar_rdata       = RDATA;
        bar_irq         = IRQ;
        bar_irq_ccs     = IRQ_CCS;
        bar_rdy         = RDY;
        user_apb_rdata  = 8'b0;
        user_apb_irq    = 1'b0;
        user_apb_irq_ccs= 1'b0;
        user_apb_rdy    = 1'b0;
        APB_PRDATA      = 8'b0;
        APB_PREADY      = 1'b0;
    end
end

endmodule
