//=================================================================================================
// Copyright(c) 2017, New H3C Technologies Co., Ltd, All right reserved
// Filename   : header.v
// Project    : H3C common code
// Author     : QIURONGLIN
// Date       : 2017-07-18
// Email      : qiu.ronglin@h3c.com
// Company    : New H3C Technologies Co., Ltd
// Description: This module defines the platform xregisters as well as interrupt genertion.
//   Notes: Want to handle PAL_CPUX_MEMYZ_HOT signals for G9?
// History    :
//   Date      By          Revision  Change Description
//   20170718  QIURONGLIN  1.0       file created
//=================================================================================================

//`include "wpspo_g5_define.vh"
`include "rs35m2c16s_g5_define.v"
module thermal(
   input                          clk,
   input                          pgd_p3v3_stby_async,
   input                          pgd_aux_system,
   input                          pgd_p3v3,
    input                          pch_sys_pwrok,   //ÓÀÔ¶Îª1
   input                          st_steady_pwrok,
   input       [`NUM_CPUVR-1:0]   cpu_vr_hot_n,
   input       [`NUM_MEMVR-1:0]   mem_vr_hot_n,
//YHY   input         [`NUM_CPU-1:0]   cpu_prsnt_n,
//YHY   input                          override_cpu_prsnt_sw_n,
   input         [`NUM_CPU-1:0]   cpu_thermtrip_in,
   input                          thermtrip_ena,
   input                          emc_alert_n,
   input                          lom_temp_dead,  //ÓÀÔ¶Îª0
   input                          lom_prsnt_n,
   input                          aroc_temp_dead,//ÓÀÔ¶Îª0
//YHY   input                          aroc_inst_n,
//YHY   input         [`NUM_CPU-1:0]   cpu_hot,
   input         [`NUM_CPU-1:0]   cpu_ab_alert_n,
   input         [`NUM_CPU-1:0]   cpu_cd_alert_n,
//YHY   input                          gpo_overtemp,
   input                          pch_pltrst_n,
   output reg  [`NUM_CPUVR-1:0]  qual_cpu_vr_hot_n,
   output reg  [`NUM_MEMVR-1:0]  qual_mem_vr_hot_n,
//YHY   output                        or_all_vr_hot,
   output                        or_all_cpu_thermtrip,
   output reg                    sensor_thermtrip,
//YHY   output reg    [`NUM_CPU-1:0]  qual_cpu_hot_n,
//YHY   output                        or_all_qual_cpu_hot_n,
   output reg    [`NUM_CPU-1:0]  qual_cpu_ab_alert,
   output reg    [`NUM_CPU-1:0]  qual_cpu_cd_alert
//YHY   output reg                    overtemp_led
);

   reg  [`NUM_CPU-1:0] cpu_thermtrip_r;
   wire [`NUM_CPU-1:0] cpu_thermtrip_delay;

//YHY assign or_all_vr_hot         = ~( (&qual_cpu_vr_hot_n) & (&qual_mem_vr_hot_n) );
 assign or_all_cpu_thermtrip  = |cpu_thermtrip_r;
//YHY  assign or_all_qual_cpu_hot_n = &qual_cpu_hot_n;

// Register VRD hot signals in core clock domain and qualify/filter
always @(posedge clk or negedge pgd_p3v3_stby_async) begin
   if (!pgd_p3v3_stby_async) begin
      qual_cpu_vr_hot_n <= {`NUM_CPUVR{1'b1}};
      qual_mem_vr_hot_n <= {`NUM_MEMVR{1'b1}};
//YHY      qual_cpu_hot_n    <= {`NUM_CPU{1'b1}};
      qual_cpu_ab_alert <= {`NUM_CPU{1'b0}};
      qual_cpu_cd_alert <= {`NUM_CPU{1'b0}};
   end
   else if (!st_steady_pwrok) begin
      // NOTE: Added this block since Quartus barfs when st_steady_pwrok is included
      //       in the if block above.
      qual_cpu_vr_hot_n <= {`NUM_CPUVR{1'b1}};
      qual_mem_vr_hot_n <= {`NUM_MEMVR{1'b1}};
//YHY      qual_cpu_hot_n    <= {`NUM_CPU{1'b1}};
      qual_cpu_ab_alert <= {`NUM_CPU{1'b0}};
      qual_cpu_cd_alert <= {`NUM_CPU{1'b0}};
   end
   else begin
      // CHECKME: What to do if #CPU > #CPU_VR?
//YHY      qual_cpu_vr_hot_n <= (cpu_prsnt_n & {`NUM_CPU{override_cpu_prsnt_sw_n}}) |  cpu_vr_hot_n;
//YHY      qual_mem_vr_hot_n <= (cpu_prsnt_n & {`NUM_CPU{override_cpu_prsnt_sw_n}}) |  mem_vr_hot_n;  
      qual_cpu_vr_hot_n <= cpu_vr_hot_n;      
      qual_mem_vr_hot_n <= mem_vr_hot_n;   
       // CHECKME: Should qual_cpu_hot_n also include PGD_PVCCIN_CPU# as does the DL360G9?
//YHY      qual_cpu_hot_n    <= (cpu_prsnt_n & {`NUM_CPU{override_cpu_prsnt_sw_n}}) | ~cpu_hot;
      qual_cpu_ab_alert <= ~cpu_ab_alert_n;
      qual_cpu_cd_alert <= ~cpu_cd_alert_n;
   end
end

// Register CPU thermal signals in core clock domain
  always @(posedge clk or negedge pgd_p3v3_stby_async) begin
     if (!pgd_p3v3_stby_async) begin
        cpu_thermtrip_r   <= {`NUM_CPU{1'b0}};
        sensor_thermtrip  <= 1'b0;
  
     end
     else begin
        // No need to include PGD_PVCCIN_CPU below since if that trips, system
        // immediately starts shutting down and de-asserts thermtrip_ena.
        cpu_thermtrip_r   <= {`NUM_CPU{thermtrip_ena & pch_pltrst_n}} & cpu_thermtrip_delay;                 
  
        // CHECKME: Removed PAL_PWR_LOM_EN & PGD_LOM_PWR from equation.  I don't see the need to inc these terms.  Same concern about AROC
  //YHY      sensor_thermtrip  <= ( (~emc_alert_n    &  pgd_p3v3)    |
  //YHY                             ( lom_temp_dead  & ~lom_prsnt_n) |
  //YHY                             ( aroc_temp_dead & ~aroc_inst_n) ) &
  //YHY                                                 pch_sys_pwrok;
        sensor_thermtrip  <= ( (~emc_alert_n    &  pgd_p3v3)    |
                               ( lom_temp_dead  & ~lom_prsnt_n) |  //ÓÀÔ¶Îª0
                               ( aroc_temp_dead ) ) &              //ÓÀÔ¶Îª0
                                                   pch_sys_pwrok;        //ÓÀÔ¶Îª1                                             
                                                   
     end
  end

// iLO will control the SID overtemp LED via the GPO chain bit
// CHECKME: Since gpo_chain synchronizes all parallel inputs, this block can likely be removed
//YHY  always @(posedge clk or negedge pgd_aux_system) begin
//YHY     if (!pgd_aux_system)
//YHY        overtemp_led <= 1'b0;
//YHY     else
//YHY        overtemp_led <= gpo_overtemp;
//YHY  end
//YHY  
//------------------------------------------------------------------------------
// Generate delay version of cpu_thmtrip
// - CPU asserts both FIVR_FAULT and THERMTRIP# at the same time during FIVR
//   fault condition. To prevent capturing false thermtrip condition, the
//   cpu_thmtrip is delayed for 200ns.
//------------------------------------------------------------------------------
genvar i;
generate
  for (i = 0; i < `NUM_CPU; i = i + 1)
  begin : cpu_thermtrip_delay_timer
    delay_timer #(.CNT_SIZE(5)) cpu_thermtrip_delay_inst (
      .clk           (clk),
      .reset         (~pgd_p3v3_stby_async),
      .signal_in     (cpu_thermtrip_in[i]),
      .cnt_step      (1'b1),
      .cnt_size      (5'b10100),
      .delay_output  (cpu_thermtrip_delay[i])
    );
  end
endgenerate
   
endmodule

//20170107 qiuronglin
//+ Change cpu_thermtrip(input) to cpu_thermtrip_in



