/* ============================================================================================================================================================
模块功能（概述）
1、在上电/PLL锁定/待机电源良好/系统就绪等条件下，产生全局上电复位信号（原始与带就绪限定版本），并对 AUX 电源 PGD 信号进行同步与整形。
2、使用异步低有效复位（由 pgd_p3v3_stby & pll_lock 构成）清零同步寄存器；在主时钟域内对复位释放进行多拍同步，降低毛刺与亚稳风险。
3、done_booting_delayed 用于在系统就绪后再最终释放去抖复位，提高上电时序的稳定性；pgd_aux_system_sasd 通过两级寄存器实现时序域缓冲。

关键输出：
- pon_reset_n：全局复位（低有效），依据 pgd_p3v3_stby 与 pll_lock，并经 3 拍同步释放。
- pon_reset_db_n：在 pon_reset_n 为高（复位释放）且 done_booting_delayed 有效后才拉高，保证系统真正就绪后再解除复位。
- pgd_aux_system：AUX PGD（结合 pgd_p3v3_stby 与 pgd_aux_gmt）经同步后的稳定版本。
- pgd_aux_system_sasd：面向 SASD 的 AUX PGD，通过两级寄存器进一步稳定。
- cpld_ready：CPLD 就绪指示（低表示就绪），与 done_booting 取反关系。

设计要点：
- master_reset_n 作为异步低有效清零源，确保在电源/PLL 不良时所有同步寄存器归零。
- 所有输出在 clk 域内同步生成，避免跨时钟域亚稳态与毛刺输出。
=============================================================================================================================================================*/

module pon_reset (
  input       clk,                          // 主时钟（例：25/50/100MHz），用于对复位与PGD进行同步
  input       pll_lock,                     // PLL锁定指示，高有效。未锁定时应保持复位
  input       pgd_p3v3_stby,                // 待机3.3V电源良好（PGD），高有效
  input       pgd_aux_gmt,                  // 来自BMC/电源监控的 AUX PGD 原始输入（需同步）
  input       done_booting,                 // FPGA/系统完成启动指示（若不使用，置 1'b1）
  input       done_booting_delayed,         // done_booting 的延迟/滤波版本（若不使用，置 1'b1）
  output      pon_reset_n,                  // 全局复位（低有效），依据 pgd_p3v3_stby & pll_lock 并经同步
  output reg  pon_reset_db_n,               // 在 done_booting_delayed 有效后才拉高的复位释放版本（低有效）
  output      pgd_aux_system,               // 系统域的 AUX PGD（基于 pgd_p3v3_stby 与 pgd_aux_gmt，同步后输出）
  output reg  pgd_aux_system_sasd,          // 面向 SASD 的 AUX PGD，两级寄存器加强稳定性
  output      cpld_ready                    // CPLD 就绪（0 表示就绪），done_booting 的反相
);

wire       master_reset_n;                  // 异步低有效复位源：P3V3_STBY 与 PLL_LOCK 均有效时为高
reg  [2:0] reset1_reg;                      // 用于生成 pon_reset_n 的3拍同步寄存器链
reg  [2:0] reset2_reg;                      // 用于生成 pgd_aux_system 的3拍同步寄存器链（含 pgd_aux_gmt）
reg        pgd_aux_system_reg;              // pgd_aux_system 的一级寄存（用于生成 SASD 版的二级缓冲）

//------------------------------------------------------------------------------
// Reset output
//------------------------------------------------------------------------------
// 当 pgd_p3v3_stby 或 pll_lock 任何一个为低时，说明电源/时钟条件不满足，应保持复位。
assign master_reset_n = pgd_p3v3_stby & pll_lock;

// 同步释放复位与 PGD：使用异步清零 + 多拍移位，保证复位解除与PGD输出平滑无毛刺。
// 注意：resetX_reg 在 master_reset_n 低时被异步清零，因此移位内容在复位期间为 0。
always @(posedge clk or negedge master_reset_n)
begin
  if (!master_reset_n)
  begin
    reset1_reg <= 3'b0;                     // 对应复位链：清零，保持 pon_reset_n 为低（复位）
    reset2_reg <= 3'b0;                     // 对应PGD链：清零，保持 pgd_aux_system 为低（不良）
  end
  else
  begin
    reset1_reg <= {reset1_reg[1:0], 1'b1};  // 逐拍移入1，第三拍为1表示复位释放完成
    // 将 pgd_aux_gmt 在 clk 域内同步，多拍滤波；结合上游 master_reset_n 保证电源/PLL不良时输出为0
    reset2_reg <= {reset2_reg[1:0], pgd_aux_gmt};
  end
end

assign pon_reset_n    = reset1_reg[2];      // 第3拍输出高，表示复位解除（低有效复位拉高）
assign pgd_aux_system = reset2_reg[2];      // 第3拍输出高，表示 AUX PGD 稳定有效

// 生成 SASD 版本的 pgd_aux_system：两级寄存器用于进一步保证时序稳定性与跨域缓冲。
always @(posedge clk)
begin
  if (!master_reset_n)
  begin
    pgd_aux_system_reg  <= 1'b0;            // 一级寄存清零
    pgd_aux_system_sasd <= 1'b0;            // 二级寄存清零（面向 SASD 域）
  end
  else
  begin
    pgd_aux_system_reg  <= pgd_aux_system;  // 一级寄存
    pgd_aux_system_sasd <= pgd_aux_system_reg; // 二级寄存
  end
end

// 生成带系统就绪限定的复位释放版本：只有在 pon_reset_n 为高（复位解除）且 done_booting_delayed 为高时才将 pon_reset_db_n 拉高。
// 异步低有效复位沿采用 pon_reset_n 作为清零条件，确保在任何复位条件回落时立即拉低。
always @(posedge clk or negedge pon_reset_n)
begin
  if (!pon_reset_n)
    pon_reset_db_n <= 1'b0;                 // 复位条件触发时，立即拉低（保持复位）
  else if (done_booting_delayed)
    pon_reset_db_n <= 1'b1;                 // 系统就绪（延迟版）到达后，释放复位
  // 若 done_booting_delayed 为低，则保持上一拍的 pon_reset_db_n，不会提前释放
end

// 当系统完成启动（done_booting=1）时，cpld_ready 置 0（就绪）；否则为 1（不就绪）。
assign cpld_ready = ~done_booting;

endmodule
