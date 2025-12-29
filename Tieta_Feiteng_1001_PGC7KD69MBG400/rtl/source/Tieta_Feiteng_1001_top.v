`include "rs35m2c16s_g5_define.vh"
`include "pwrseq_define.vh"

parameter PEAVEY_SUPPORT = 1'b1;  //comment1,ph configuration

/*------------------------------------------------------------------
PLL 例化 
--------------------------------------------------------------------*/
pll_i25M_o50M_o25M pll_inst(
  .CLKI  (i_CLK_PAL_IN_25M          ),
  .RST   (~i_PAL_P3V3_STBY_PGD      ),
  .CLKOP (clk_100m                  ),
  .CLKOS (pll_clkos1                ),
  .LOCK  (pll_lock                  )
);

/*------------------------------------------------------------------
PLL 例化 
--------------------------------------------------------------------*/
pll_i25M_o50M_o25M pll_inst(
  .CLKI  (i_CLK_PAL_IN_25M          ),
  .RST   (~i_PAL_P3V3_STBY_PGD      ),
  .CLKOP (clk_100m                  ),
  .CLKOS (pll_clkos1                ),
  .LOCK  (pll_lock                  )
);

endmodule