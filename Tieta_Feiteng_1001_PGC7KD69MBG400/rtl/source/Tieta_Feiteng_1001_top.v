`include "pwrseq_define.vh"
module Tieta_Feiteng_1001_top(
// =============================================================================
//  系统时钟 
// =============================================================================
input  i_CLK_PAL_IN_25M                       /* synthesis LOC = "K19"*/,// from  CPLD_M_PWR/OSC3/U26_AU5424GB_DNR               to  CPLD_M                                        default 0  // CPLD_M的25MHz时钟输入


// =============================================================================
//  I2C  
// =============================================================================
input  i_BMC_I2C9_PAL_M_SCL_R                 /* synthesis LOC = "C11"*/,// from  BMC_I2C_MUX1/GENZ_168PIN/BMC                   to  CPLD_M                                        default 1  // BMC I2C9 PAL主设备SCL信号输入（反向）
inout  io_BMC_I2C9_PAL_M_SDA_R                /* synthesis LOC = "D11"*/,// from  CPLD_M                                         to  BMC_I2C_MUX1/GENZ_168PIN/BMC                  default 1  // BMC I2C9 PAL主设备SDA信号输入（反向）
input  i_BMC_I2C9_PAL_M_SCL1_R                /* synthesis LOC = "B10"*/,// from  BMC_I2C_MUX1/GENZ_168PIN/BMC                   to  CPLD_M                                        default 1  // BMC I2C9 PAL主设备SCL1信号输入              新增
inout  io_BMC_I2C9_PAL_M_SDA1_R               /* synthesis LOC = "D5"*/ ,// from  CPLD_M                                         to  BMC_I2C_MUX1/GENZ_168PIN/BMC                  default 1  // BMC I2C9 PAL主设备SDA1电源良好信号输入       新增


// =============================================================================
//  JTAG  
// =============================================================================
/* begin: JTAG BMC和插座二选一 */
// BMC JTAG信号
input  i_BMC_JTAGM_NTRST_R                    /* synthesis LOC = "P20"*/,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 1  // BMC JTAG复位信号输入                         新增
// 插座 JTAG信号
// input  i_PAL_M_JTAGEN                      /* synthesis LOC = "C13"*/,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 1  // 主JTAG使能信号输入                           新增
// input  i_PAL_M_SN                          /* synthesis LOC = "Y20"*/,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M   
// input  i_PAL_M_PROGRAM_N                   /* synthesis LOC = "D13"*/,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 1  // 主编程信号输入（低电平有效，反向）
// input  i_PAL_M_INITN                       /* synthesis LOC = "C17"*/,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 0  // 主INITN信号输入（低电平有效）
// input  i_PAL_M_DONE                        /* synthesis LOC = "A19"*/ // from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 0  // 主DONE信号输入
// output o_PAL_TDO                           /* synthesis LOC = "E8"*/ ,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 1  // TDO测试数据输出信号输出                       新增
// input  i_PAL_TDI                           /* synthesis LOC = "C7"*/ ,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 1  // TDI测试数据输入信号输入                       新增
// input  i_PAL_TCK                           /* synthesis LOC = "C9"*/ ,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 1  // TCK测试时钟信号输入
// input  i_PAL_TMS                           /* synthesis LOC = "D9"*/ ,// from  GENZ_168PIN/BMC 或者 JTAG插座                   to  CPLD_M                                        default 1  // TMS测试模式选择信号输入
/* end: JTAG BMC和插座二选一 */


// =============================================================================
//  BMC 相关信号 
// =============================================================================
// BMC UID按钮/卡存在信号
input  i_PAL_BMCUID_BUTTON_R                  /* synthesis LOC = "A17"*/,// from  BMC/GENZ_168PIN                                to  CPLD_M                                       default 1  // BMC UID按钮信号输入                           新增
input  i_PAL_BMC_CARD_PRSNT_N                 /* synthesis LOC = "N15"*/,// from  BMC/GENZ_168PIN                                to  CPLD_M                                       default 0  // BMC卡存在信号输入

// BMC 预留信号
input  i_BMC_RESERVE_18                       /* synthesis LOC = "H19"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号18, I2C总线的仲裁请求信号输出
input  i_BMC_RESERVE_17                       /* synthesis LOC = "N19"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号17                               新增
input  i_BMC_RESERVE_16                       /* synthesis LOC = "N18"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号16                               新增
input  i_BMC_RESERVE_15                       /* synthesis LOC = "M15"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号15                               新增
input  i_BMC_RESERVE_14                       /* synthesis LOC = "T20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号14                               新增
input  i_BMC_RESERVE_13                       /* synthesis LOC = "U20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号13                               新增
input  i_BMC_RESERVE_12                       /* synthesis LOC = "V20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号12                               新增
input  i_BMC_RESERVE_11                       /* synthesis LOC = "R17"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号11                               新增
input  i_BMC_RESERVE_10                       /* synthesis LOC = "U18"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号10                               新增
input  i_BMC_RESERVE_9                        /* synthesis LOC = "R16"*/,// from  GENZ_168PIN_J98/BMC                            to  CPLD_M                                        default 1  // BMC 保留信号9                                新增
input  i_BMC_RESERVE_8                        /* synthesis LOC = "T17"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号8                                新增
input  i_BMC_RESERVE_7                        /* synthesis LOC = "C19"*/,// from  GENZ_168PIN_J98/BMC                            to  CPLD_M                                        default 1  // BMC 保留信号7
input  i_BMC_RESERVE_6                        /* synthesis LOC = "E17"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号6
input  i_BMC_RESERVE_5                        /* synthesis LOC = "F16"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号5
input  i_BMC_RESERVE_4                        /* synthesis LOC = "B20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号4
input  i_BMC_RESERVE_3                        /* synthesis LOC = "F18"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号3
input  i_BMC_RESERVE_2                        /* synthesis LOC = "E20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号2
input  i_BMC_RESERVE_1                        /* synthesis LOC = "F19"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号1
input  i_BMC_RESERVE_0                        /* synthesis LOC = "G19"*/,// from  CPLD_M                                        to  GENZ_168PIN_J98_5653E5/GND_29                default 1  // BMC 保留信号0

// =============================================================================
//  CPLD_M 与 CPLD_S 之间的交换信号
// =============================================================================
output o_CPLD_M_S_EXCHANGE_S1_R               /* synthesis LOC = "J14"*/,// from  CPLD_M                                         to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的交换信号S1输出            新增
input  i_CPLD_M_S_EXCHANGE_S2_R               /* synthesis LOC = "F20"*/,// from  CPLD_S                                         to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的交换信号S2输入            新增
output o_CPLD_M_S_EXCHANGE_S3_R               /* synthesis LOC = "H17"*/,// from  CPLD_M                                         to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的交换信号S3输出   
input  i_CPLD_M_S_EXCHANGE_S4_R               /* synthesis LOC = "J16"*/,// from  CPLD_S                                         to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的交换信号S4输入            新增
output o_CPLD_M_S_EXCHANGE_S5_R               /* synthesis LOC = "J18"*/,// from  CPLD_M                                         to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的交换信号S5输出            新增


// =============================================================================
//  SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S, CPU0_D1 -> CPLD_M
// =============================================================================
output o_CPLD_M_S_SGPIO_CLK_R                 /* synthesis LOC = "D18"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO时钟信号输出
output o_CPLD_M_S_SGPIO_LD_N_R                /* synthesis LOC = "J20"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO负载使能信号输出
output o_CPLD_M_S_SGPIO_MOSI_R                /* synthesis LOC = "F10"*/,// from  CPLD_M                                         to  CPU_VR8_Controler                            default 1  // S_SGPIO 主设备MOSI信号输出
input  i_CPLD_M_S_SGPIO_MISO                  /* synthesis LOC = "H15"*/,// from  CPLD_S                                        to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的SGPIO MISO信号输入

output o_CPLD_M_S_SGPIO1_CLK_R                /* synthesis LOC = "G15"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1时钟信号输出
output o_CPLD_M_S_SGPIO1_LD_N_R               /* synthesis LOC = "K17"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1负载使能信号输出
output o_CPLD_M_S_SGPIO1_MOSI_R               /* synthesis LOC = "C20"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1 MOSI信号输出
input  i_CPLD_M_S_SGPIO1_MISO                 /* synthesis LOC = "F17"*/,// from  CPLD_S                                        to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的SGPIO1 MISO信号输入

input  i_CPU0_D1_SPI0_SCK                     /* synthesis LOC = "W12"*/,// from  CPU0_GPIO2/D1_SPIO_SCK                        to  CPLD_M                                       default 1  // CPU0 D1 区域SPI0 SCK信号 
input  i_CPU0_D1_SPI0_CS                      /* synthesis LOC = "P10"*/,// from  CPU0_GPIO2/D1_SPIO_CSN0                       to  CPLD_M                                       default 1  // CPU0 D1 区域SPI0 片选信号 
input  i_CPU0_D1_SPI0_MISO_R                  /* synthesis LOC = "V9"*/ ,// from  CPU0_GPIO2/D1_SPI0_MISO                       to  CPLD_M                                       default 1  // CPU0 D1 区域SPI0 MISO信号
output o_CPU0_D1_SPI0_MOSI                    /* synthesis LOC = "Y9" */,// from  CPLD_M                                        to  U192/TPM                                     default 1  // CPU0 D1 区域SPI0 MOSI信号

// =============================================================================
//  电源上下电管理信号
// =============================================================================
// 主供电模块 电源开启信号
output o_PAL_PS1_P12V_ON_R                    /* synthesis LOC = "G8"*/ ,// from  CPLD_M                                         to  PSU_MISC2                                    default 1  // PS1 12V开启信号输入（反向）
output o_PAL_PS2_P12V_ON_R                    /* synthesis LOC = "G7"*/ ,// from  CPLD_M                                         to  PSU_MISC2/PAL_PS2_P12V_ON_R                  default 1  // PS2 12V开启信号输入
input  i_PAL_MAIN_PWR_OK                      /* synthesis LOC = "K7"*/ ,// from  RISER_AUX/J16                                  to  CPLD_M                                       default 1  // 主模块电源良好信号输入(未使用)


// 辅助电源模块 电源良好信号
inout  io_PAL_BP1_PWR_ON_R                    /* synthesis LOC = "E14"*/,// from  CPLD_M                                         to  BP_AUX_PWR/J84_PAL_BP1_PWR_ON_R              default 1  // BP1辅助电源开启信号输出                       新增
inout  io_PAL_BP2_PWR_ON_R                    /* synthesis LOC = "U1"*/ ,// from  CPLD_M                                         to  REAR_BP_AUX_PWR/J86_1338_201/A1              default 1  // 后置背板电源开启信号输入输出           
input  i_PAL_BP1_AUX_PG                       /* synthesis LOC = "A3"*/ ,// from  CPLD_M                                         to  BP_AUX_PWR/J84_PAL_BP1_AUX_PG                default 1  // BP1辅助电源良好信号输入                       接入寄存器
input  i_PAL_BP2_AUX_PG                       /* synthesis LOC = "E7"*/ ,// from  BP_AUX_PWR/J86_PAL_BP2_AUX_PG                  to  CPLD_M                                       default 1  // 辅助电源良好信号输入                          接入寄存器

// Riser 电源使能信号
output o_PAL_P12V_RISER1_VIN_EN_R             /* synthesis LOC = "C8"*/ ,// from  CPLD_M                                         to  P12_RISER1_VIN                               default 1  // 12V Riser1输入使能信号输入                   同时上电 
output o_PAL_P12V_RISER2_VIN_EN_R             /* synthesis LOC = "B9"*/ ,// from  CPLD_M                                         to  P12_RISER2_VIN                               default 1  // 12V Riser2输入使能信号输入                   同时上电 
output o_PAL_RISER1_PWR_EN_R                  /* synthesis LOC = "L19"*/,// from  CPLD_M                                         to  RISER1/J1_G64V3421MHR/8633B&RS53319/EN       default 1  // Riser1电源使能信号输出                       同时上电
output o_PAL_RISER2_PWR_EN_R                  /* synthesis LOC = "M5"*/ ,// from  CPLD_M                                         to  RISER2/U240_SGM6505HYTQF24G_TR               default 1  // Riser2电源使能信号输出                       同时上电

// PVCC_HPMOS_CPU 电源使能信号
output o_PAL_PVCC_HPMOS_CPU_EN_R              /* synthesis LOC = "D16"*/,

// 不使用
output o_CPU0_SB_EN_R                         /* synthesis LOC = "W2"*/ ,
output o_CPU1_SB_EN_R                         /* synthesis LOC = "T8"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/SB_EN             default 1  // CPU1    南桥使能信号                     

// LOM 电源使能信号
output o_PAL_PWR_LOM_EN_R                     /* synthesis LOC = "K1"*/ ,// from  CPLD_M                                        to  RISER_AUX/J16                                default 1  // LOM电源使能信号输出

// ？其他电源管理信号？
output o_PAL_P5V_BD_EN_R                      /* synthesis LOC = "M3"*/ ,// from  CPLD_M                                        to  U39_JW7111SSOTBTRPBF                         default 1  // 5V主板电源使能信号输出, 电压转换后给DB模块供电  // 新增
output o_PAL_UPD_VCC_3V3_EN_R                 /* synthesis LOC = "E19"*/,// from  CPLD_M                                        to  WX1860_POL_U82_JW7111SSOTBTRPBF/EN           default 1  // 3v3转1v1电源使能信号输出            新增
output o_P5V_USB_MB_UP_EN_R                   /* synthesis LOC = "J1"*/ ,// from  CPLD_M                                        to  REAR USB3.0/J15_AUSB0072_P304A01             default 1  // 5V USB主板上电使能信号输出            新增
output o_P5V_USB_MB_DOWN_EN_R                 /* synthesis LOC = "J2"*/ ,// from  CPLD_M                                        to  REAR USB3.0/J15_AUSB0072_P304A02             default 1  // 5V USB主板下电使能信号输出            新增

// 12V 主供电模块 电源滤波信号
output o_PAL_P12V_CPU0_VIN_EN_R               /* synthesis LOC = "B6"*/ ,// from  CURRENT_DET0/P12V_CPU0_VIN                     to  CPLD_M                                       default 1  // 12V CPU0输入使能信号输入（反向）               新增
input  i_PAL_P12V_CPU0_VIN_FLTB               /* synthesis LOC = "N2"*/ ,// from  CURRENT_DET0/P12V_CPU0_FLTB                   to  CPLD_M                                       default 1  // 12V CPU0输入电源滤波信号输入                   新增
input  i_PAL_P12V_CPU0_VIN_PG                 /* synthesis LOC = "N1"*/ ,// from  CURRENT_DET0/P12V_CPU0_VIN                    to  CPLD_M                                       default 1  // 12V CPU0输入电源良好信号输入                   新增

output o_PAL_P12V_CPU1_VIN_EN_R               /* synthesis LOC = "F8"*/ ,// from  CURRENT_DET0/P12V_CPU1_VIN                     to  CPLD_M                                       default 1  // 12V CPU1输入使能信号输入（反向）               新增
input  i_PAL_P12V_CPU1_VIN_FLTB               /* synthesis LOC = "P2"*/ ,// from  CURRENT_DET0/P12V_CPU1_FLTB                   to  CPLD_M                                       default 1  // 12V CPU1输入电源滤波信号输入                   新增
input  i_PAL_P12V_CPU1_VIN_PG                 /* synthesis LOC = "P1"*/ ,// from  CURRENT_DET0/P12V_CPU1_VIN                    to  CPLD_M                                       default 1  // 12V CPU1输入电源良好信号输入                   新增

// 12V PGD压降信号输入 / 12V 待机PGD压降信号输入
input  i_PAL_PGD_P12V_DROOP                   /* synthesis LOC = "B14"*/,// from  P12V_DROOP                                     to  CPLD_M                                       default 1  // 12V PGD压降信号输入
input  i_PAL_PGD_P12V_STBY_DROOP              /* synthesis LOC = "D8"*/ ,// from  P12V_DROOP                                     to  CPLD_M                                       default 1  // 12V待机PGD压降信号输入

// 12V 风扇供电模块 电源良好信号
output o_PAL_P12V_FAN0_EN_R                   /* synthesis LOC = "D2"*/ ,// from  CPLD_M                                        to  FAN_PWR                                      default 1  // 12V风扇0使能信号输入                              // 新增
input  i_PAL_P12V_FAN0_PG                     /* synthesis LOC = "F4"*/ ,// from  FAN_PWR/PAL_P12V_FAN0_PG                       to  CPLD_M                                       default 1  // 12V风扇0电源良好信号输入                          // 新增
input  i_PAL_P12V_FAN0_FLTB                   /* synthesis LOC = "F3"*/ ,// from  FAN_PWR/PAL_P12V_FAN0_FLTB                     to  CPLD_M                                       default 1  // 12V风扇0故障信号输入                             // 新增

output o_PAL_P12V_FAN1_EN_R                   /* synthesis LOC = "D1"*/ ,// from  CPLD_M                                        to  FAN_PWR                                      default 1  // 12V风扇1使能信号输入                              // 新增
input  i_PAL_P12V_FAN1_PG                     /* synthesis LOC = "H6"*/ ,// from  FAN_PWR/PAL_P12V_FAN1_PG                       to  CPLD_M                                       default 1  // 12V风扇1电源良好信号输入                          // 新增
input  i_PAL_P12V_FAN1_FLTB                   /* synthesis LOC = "H7"*/ ,// from  FAN_PWR/PAL_P12V_FAN1_FLTB                     to  CPLD_M                                       default 1  // 12V风扇1故障信号输入                             // 新增

output o_PAL_P12V_FAN2_EN_R                   /* synthesis LOC = "F5"*/ ,// from  CPLD_M                                        to  FAN_PWR                                      default 1  // 12V风扇2使能信号输入                              // 新增
input  i_PAL_P12V_FAN2_PG                     /* synthesis LOC = "E2"*/ ,// from  FAN_PWR/PAL_P12V_FAN2_PG                       to  CPLD_M                                       default 1  // 12V风扇2电源良好信号输入                         // 新增
input  i_PAL_P12V_FAN2_FLTB                   /* synthesis LOC = "E1"*/ ,// from  FAN_PWR/PAL_P12V_FAN2_FLTB                     to  CPLD_M                                       default 1  // 12V风扇2故障信号输入                             // 新增

output o_PAL_P12V_FAN3_EN_R                   /* synthesis LOC = "G5"*/ ,// from  CPLD_M                                        to  FAN_PWR                                      default 1  // 
input  i_PAL_P12V_FAN3_PG                     /* synthesis LOC = "F2"*/ ,// from  FAN_PWR/PAL_P12V_FAN3_PG                       to  CPLD_M                                       default 1  // 12V风扇3电源良好信号输入                         // 新增
input  i_PAL_P12V_FAN3_FLTB                   /* synthesis LOC = "F1"*/ ,// from  FAN_PWR/PAL_P12V_FAN3_FLTB                     to  CPLD_M                                       default 1  // 12V风扇3故障信号输入                             // 新增

// 5.0V 主供电模块 电源良好信号
output o_PAL_P5V_STBY_EN_R                    /* synthesis LOC = "P19"*/,// from  CPLD_M                                        to  PWR_P5V_STBY/PAL_P5V_STBY_EN                 default 1  // 5v待机电源使能信号输出
input  i_PAL_P5V_STBY_PGD                     /* synthesis LOC = "B11"*/,// from  PWR_P5V_STBY                                   to  CPLD_M                                       default 1  // 5V待机PGD信号输入

// 3.3V 主供电模块 电源良好信号
input  i_PAL_P3V3_STBY_PGD                    /* synthesis LOC = "L16"*/,// from  PWR_P3V3_STBY/PAL_P3V3_STBY_PGD                to  CPLD_M                                       default 1  // 3v3待机电源良好信号输入
output o_PAL_P3V3_STBY_RST_R                  /* synthesis LOC = "G20"*/,// from  CPLD_M                                        to  PWR_P3V3_STBY/PAL_P3V3_STBY_RST              default 1  // 3v3待机电源复位信号输出

// 3.3V CPU0/1 DIMM 电源良好信号
input  i_PAL_CPU0_DIMM_PWRGD_F                /* synthesis LOC = "M16"*/,// from  CPU0_DIMM0_WHITE/J1001/CPU0_DDR0_PWRGD         to  CPLD_M                                       default 1  // CPU0 DIMM槽位                 3.3V 电源良好信号输入
input  i_PAL_CPU1_DIMM_PWRGD_F                /* synthesis LOC = "D15"*/,// from  CPU1_DIMM3_WHITE/J1001/CPU0_DDR0_PWRGD         to  CPLD_M                                       default 1  // CPU1 DIMM槽位                 3.3V 电源良好信号输入

// 3.3V 机箱后部面向背板的辅助供电模块 电源良好信号
output o_PAL_REAT_BP_EFUSE_EN_R               /* synthesis LOC = "M1"*/ ,// from  CPLD_M                                        to  CURRENT_DET1/P12V_REAR_BP_VIN                default 1  // REAT BP eFUSE使能信号输出                     // 新增
input  i_PAL_REAT_BP_EFUSE_OC                 /* synthesis LOC = "L3"*/ ,// from  CURRENT_DET1/P12V_REAR_BP_VIN                  to  CPLD_M                                       default 1  // REAT BP eFUSE过流信号输入                     // 新增
input  i_PAL_REAT_BP_EFUSE_PG                 /* synthesis LOC = "M2"*/ ,// from  CURRENT_DET1/P12V_REAR_BP_VIN                  to  CPLD_M                                       default 1  // REAT BP eFUSE电源良好信号输入                 // 新增

// 1.8V CPLD供电模块 电源良好信号
output o_P1V8_STBY_CPLD_EN_R                  /* synthesis LOC = "J3"*/ ,// from  CPLD_M                                         to  CPLD_M_PWR                                   default 1  // 88SE9230 1.0V电源使能信号输出                   // 新增
input  i_P1V8_STBY_CPLD_PG                    /* synthesis LOC = "K16"*/,// from  PSU/RS31386/RS53317/3.3STBY/TPL910ADJ          to  CPLD_M                                       default 1  // CPLD_M的1V8_STBY_PG信号输入

// 1.8V 88SE9230 PCIE转SATA芯片 电源良好信号
output o_PWR_88SE9230_P1V8_EN_R               /* synthesis LOC = "J4"*/ ,// from  CPLD_M                                         to  PEX_88SE9230/U93_XSAT2204LACGR               default 1  // 88SE9230 1.0V电源使能信号输出                   // 新增
input  i_PAL_PGD_88SE9230_P1V8                /* synthesis LOC = "B16"*/,// from  PEX_88SE9230/U93_XSAT2204LACGR                 to  CPLD_M                                       default 1  // 88SE9230 1.8V PGD信号输入                    新增

// 1.1V 88SE9230 PCIE转SATA芯片 电源良好信号
output o_PWR_88SE9230_P1V0_EN_R               /* synthesis LOC = "H1"*/ ,// from  CPLD_M                                         to  PEX_88SE9230/U93_XSAT2204LACGR               default 1  // 88SE9230 1.0V电源使能信号输出                   // 新增
input  i_PAL_PGD_88SE9230_VDD1V0              /* synthesis LOC = "D19"*/,// from  3V3M2/SMG61030_3V3to1v1                        to  CPLD_M                                       default 1  // 88SE9230 VDD1V0电源良好信号输入

// 1.1V 主供电模块 电源良好信号
output o_PAL_VCC_1V1_EN_R                     /* synthesis LOC = "F15"*/,// from  CPLD_M                                        to  SMG61030_3V3to1v1                            default 1  // 3v3转1v1电源使能信号输出
input  i_PAL_VCC_1V1_PG                       /* synthesis LOC = "G16"*/,// from  WX1860_POL_SGM61030_3V3to1V1/PAL_VCC_1V1_PG    to  CPLD_M                                       default 1  // 1v1电源良好信号输入

// GR1: CPU0/1 CPU运算核心 0.8V 电源良好信号
output o_PAL_CPU0_VDD_CORE_EN_R               /* synthesis LOC = "L14"*/,// from  CPLD_M                                        to  CPU_VR8_Controler/PAL_CPU0_VDD_CORE_EN       default 1  // CPU0 VDD_CORE电源使能信号输出
input  i_PAL_CPU0_VDD_VCORE_P0V8_PG           /* synthesis LOC = "M18"*/,// from  CPU_VR8_Controler/.._PG                        to  CPLD_M                                       default 1  // CPU0 CPU运算核心、缓存         0.8V 电源良好信号输入       新增
output o_PAL_CPU1_VDD_CORE_EN_R               /* synthesis LOC = "L5"*/ ,// from  CPLD_M                                         to  CPU_VR8_Controler                            default 1  // CPU1 VDD_CORE电源使能信号输出                 // 新增
input  i_PAL_CPU1_VDD_VCORE_P0V8_PG           /* synthesis LOC = "A10"*/,// from  CPU_VR8_Controler                              to  CPLD_M                                       default 1  // CPU1 PCIe 0.9V电源良好信号输入

// GR2: CPU0/1 GPIO/VT_AVDDH/EFUSE 模块 1.8V 电源良好信号
output o_PAL_CPU0_P1V8_EN_R                   /* synthesis LOC = "M20"*/,// from  CPLD_M                                        to  CPU_PLL_P1V8/EN                              default 1  // CPU0 1.8V电源使能信号输出
input  i_PAL_CPU0_P1V8_PG                     /* synthesis LOC = "M7"*/ ,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU0 GPIO/VT_AVDDH/EFUSE 模块 1.8V 电源良好信号输入
output o_PAL_CPU1_P1V8_EN_R                   /* synthesis LOC = "A8"*/ ,// from  CPLD_M                                         to  CPU_PLL_P1V8                                 default 1  // CPU1 1.8V电源使能信号输入
input  i_PAL_CPU1_P1V8_PG                     /* synthesis LOC = "C15"*/,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU1 PLL 1.8V电源良好信号输入

// GR3: CPU0/1 DDR内存控制器总线 1.1V 电源良好信号
// GR3: CPU0/1 DDR内存颗粒核心 0.8V 电源良好信号
// GR3: CPU0/1 PLL 区域 1.8V 电源良好信号
output o_PAL_CPU0_VDDQ_EN_R                   /* synthesis LOC = "U19"*/,// from  CPLD_M                                        to  CPU_VR8_Contrler/PAL_CPU0_VDDQ_EN            default 1  // CPU0 DDR VDDQ电源使能信号输出
input  i_PAL_CPU0_VDDQ_P1V1_PG                /* synthesis LOC = "B1"*/ ,// from  CPU_VR8_Controler/.._PG                        to  CPLD_M                                       default 1  // CPU0 DDR内存控制器总线         1.1V 电源良好信号输入       新增

output o_PAL_CPU0_DDR_VDD_EN_R                /* synthesis LOC = "L20"*/,// from  CPLD_M                                        to  CPU_DDR_HM_PLL_VDDA_P0V8/PAL_CPU0_DDR_VDD_EN default 1  // CPU0 DDR电源使能信号输出
input  i_PAL_CPU0_DDR_VDD_PG                  /* synthesis LOC = "L7"*/ ,// from  CPU_DDR_HM_PLL_VDDA_P0V8/.._PG                 to  CPLD_M                                       default 1  // CPU0 DDR内存颗粒核心           0.8V 电源良好信号输入

output o_PAL_CPU0_PLL_P1V8_EN_R               /* synthesis LOC = "L17"*/,// from  CPLD_M                                        to  CPU_PLL_P1V8/PAL_CPU0_PLL_P1V8_EN            default 1  // CPU0 PLL区域1.8V电源使能信号输出          新增
input  i_PAL_CPU0_PLL_P1V8_PG                 /* synthesis LOC = "U2"*/ ,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU0 PLL区域                  1.8V 电源良好信号输入    

output o_PAL_CPU1_VDDQ_EN_R                   /* synthesis LOC = "F13"*/,// from  CPLD_M                                         to  CPU_VR8_Controler                            default 0  // CPU1 DDR VDDQ电源使能信号输入（反向）
input  i_PAL_CPU1_VDDQ_P1V1_PG                /* synthesis LOC = "G10"*/,// from  CPU_VR8_Controler                              to  CPLD_M                                       default 1  // CPU1 DDR VDDQ 1.1V电源良好信号输入            新增 

output o_PAL_CPU1_DDR_VDD_EN_R                /* synthesis LOC = "L4"*/ ,// from  CPLD_M                                        to  CPU_DDR_HM_PLL_VDDA_P0V8/PAL_CPU1_DDR_VDD_EN default 1  // CPU1 DDR电源使能信号输出
input  i_PAL_CPU1_DDR_VDD_PG                  /* synthesis LOC = "A5"*/ ,// from  CPU_DDR_HM_PLL_VDDA_P0V8/.._PG                 to  CPLD_M                                       default 1  // CPU1 DDR内存颗粒核心           0.8V 电源良好信号输入

output o_PAL_CPU1_PLL_P1V8_EN_R               /* synthesis LOC = "B7"*/ ,// from  CPLD_M                                         to  CPU_PLL_P1V8                                 default 1  // CPU1 PLL区域1.8V电源使能信号输入（反向）
input  i_PAL_CPU1_PLL_P1V8_PG                 /* synthesis LOC = "B18"*/,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU1 PLL 1.8V电源良好信号输入


// GR4: CPU0/1 D0和D1区域 1.8V VPH 低速相关辅助电路链路 电源良好信号
// GR4: CPU0/1 D0和D1区域 0.9V VP 高速相关辅助电路链路 电源良好信号
output o_PAL_CPU0_D0_VP_0V9_EN                /* synthesis LOC = "D14"*/,// from  CPLD_M                                         to  CPU_PCIE_C2C_VP_VPH/VP_0V9_USE8633A&RS53318  default 1  // CPU0 D0 VP 0.9V电源使能信号输入（反向）
input  i_PAL_CPU0_D0_VP_0V9_PG                /* synthesis LOC = "V2"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/.._PG        to  CPLD_M                                       default 1  // CPU0 D0 区域 VP               0.9V 电源良好信号输入       新增

output o_PAL_CPU0_D1_VP_0V9_EN                /* synthesis LOC = "H16"*/,// from  CPLD_M                                        to  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/EN         default 1  // CPU0 D1区域0v9电源使能信号输出      新增
input  i_PAL_CPU0_D1_VP_0V9_PG                /* synthesis LOC = "N6"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/.._PG        to  CPLD_M                                       default 1  // CPU0 D1 区域 VP               0.9V 电源良好信号输入       新增

output o_PAL_CPU0_D0_VPH_1V8_EN               /* synthesis LOC = "L15"*/,// from  CPLD_M                                        to  CPU_PCIE_C2C_VP_VPH/8633B&RS53317/EN         default 1  // CPU0 D0区域1.8V电源使能信号输出          新增
input  i_PAL_CPU0_D0_VPH_1V8_PG               /* synthesis LOC = "T5"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU0 D0 区域 VPH              1.8V 电源良好信号输入       新增

output o_PAL_CPU0_D1_VPH_1V8_EN               /* synthesis LOC = "P16"*/,// from  CPLD_M                                         to  CPU_PCIE_C2C_VP_VPH/VPH_1V8_USE8633A&RS53318 default 1  // CPU1 D1 VPH 1.8V电源使能信号输入（反向）
input  i_PAL_CPU0_D1_VPH_1V8_PG               /* synthesis LOC = "R5"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU0 D1 区域 VPH              1.8V 电源良好信号输入       新增

output o_PAL_CPU1_D0_VP_0V9_EN                /* synthesis LOC = "H18"*/,// from  CPLD_M                                        to  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/EN         default 1  // CPU1 D0区域0v9电源使能信号输出      新增
input  i_PAL_CPU1_D0_VP_0V9_PG                /* synthesis LOC = "M6"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/.._PG        to  CPLD_M                                       default 1  // CPU1 D0 区域 VP               0.9V 电源良好信号输入       新增

output o_PAL_CPU1_D1_VP_0V9_EN                /* synthesis LOC = "J19"*/,// from  CPLD_M                                        to  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/EN         default 1  // CPU1 D1区域0v9电源使能信号输出              新增
input  i_PAL_CPU1_D1_VP_0V9_PG                /* synthesis LOC = "N4"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU1 D1 区域 VP               0.9V 电源良好信号输入       新增

output o_PAL_CPU1_D0_VPH_1V8_EN               /* synthesis LOC = "V17"*/,// from  CPLD_M                                        to  CPU_PCIE_C2C_VP_VPH/8633B&RS53317/EN         default 1  // CPU1 D0区域1.8V电源使能信号输出       新增
input  i_PAL_CPU1_D0_VPH_1V8_PG               /* synthesis LOC = "P5"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU1 D0 区域 VPH              1.8V 电源良好信号输入       新增

output o_PAL_CPU1_D1_VPH_1V8_EN               /* synthesis LOC = "G12"*/,// from  CPLD_M                                         to  CPU_PCIE_C2C_VP_VPH/VPH_1V8_USE8633A&RS53318 default 1  // CPU1 D1 VPH 1.8V电源使能信号输入（反向）
input  i_PAL_CPU1_D1_VPH_1V8_PG               /* synthesis LOC = "V4"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU1 D1 区域 VPH              1.8V 电源良好信号输入       新增

// =============================================================================
//  风扇信号
// =============================================================================
input  i_FAN0_PRSNT_N                         /* synthesis LOC = "R20"*/,// from  FAN_INSTALL/FAN_PRSNT_N                       to  CPLD_M                                       default 0  // 风扇0存在信号输入                     新增
input  i_FAN1_PRSNT_N                         /* synthesis LOC = "M14"*/,// from  FAN_INSTALL/FAN_PRSNT_N                       to  CPLD_M                                       default 0  // 风扇1存在信号输入                     新增
input  i_FAN2_PRSNT_N                         /* synthesis LOC = "R19"*/,// from  FAN_INSTALL/FAN_PRSNT_N                       to  CPLD_M                                       default 0  // 风扇2存在信号输入                     新增
input  i_FAN3_PRSNT_N                         /* synthesis LOC = "T19"*/,// from  FAN_INSTALL/FAN_PRSNT_N                       to  CPLD_M                                       default 0  // 风扇3存在信号输入                     新增

input  i_FAN_TACH_0_D                         /* synthesis LOC = "C4"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇0转速信号输入                     新增
input  i_FAN_TACH_1_D                         /* synthesis LOC = "C3"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇1转速信号输入                     新增
input  i_FAN_TACH_2_D                         /* synthesis LOC = "F6"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇2转速信号输入                     新增
input  i_FAN_TACH_3_D                         /* synthesis LOC = "G6"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇3转速信号输入                     新增
input  i_FAN_TACH_4_D                         /* synthesis LOC = "C2"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇4转速信号输入                     新增 
input  i_FAN_TACH_5_D                         /* synthesis LOC = "C1"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇5转速信号输入                     新增 
input  i_FAN_TACH_6_D                         /* synthesis LOC = "E4"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇6转速信号输入                     新增 
input  i_FAN_TACH_7_D                         /* synthesis LOC = "E3"*/ ,// from  FAN_TACH                                      to  CPLD_M                                       default 1  // 风扇7转速信号输入                     新增  

input  i_PAL_FAN0_PWM_R                       /* synthesis LOC = "L6"*/ ,// from  CPLD_M                                        to  FAN_CONN/FAN_ESD/PAL_FAN1_PWM                default 1  // 风扇1 PWM调速信号输出
input  i_PAL_FAN1_PWM_R                       /* synthesis LOC = "L6"*/ ,// from  CPLD_M                                        to  FAN_CONN/FAN_ESD/PAL_FAN1_PWM                default 1  // 风扇1 PWM调速信号输出
input  i_PAL_FAN2_PWM_R                       /* synthesis LOC = "P4"*/ ,// from  CPLD_M                                        to  FAN_CONN/FAN_ESD/PAL_FAN2_PWM                default 1  // 风扇2 PWM调速信号输出                 
input  i_PAL_FAN3_PWM_R                       /* synthesis LOC = "R2"*/ ,// from  CPLD_M                                        to  FAN_CONN/FAN_ESD/PAL_FAN3_PWM                default 1  // 风扇3 PWM调速信号输出

output o_PAL_FAN_FAIL_LED0_R                  /* synthesis LOC = "R3"*/ ,// from  CPLD_M                                        to  FAN_FAIL_LED0/D36_18_225SURSYGC_S530_...     default 1  // 风扇故障LED0控制信号输出              新增
output o_PAL_FAN_FAIL_LED1_R                  /* synthesis LOC = "P6"*/ ,// from  CPLD_M                                        to  FAN_FAIL_LED1/D37_18_225SURSYGC_S530_...     default 1  // 风扇故障LED1控制信号输出              新增
output o_PAL_FAN_FAIL_LED2_R                  /* synthesis LOC = "k5"*/ ,// from  CPLD_M                                        to  FAN_FAIL_LED2/D38_18_225SURSYGC_S530_...     default 1  // 风扇故障LED2控制信号输出              新增         
output o_PAL_FAN_FAIL_LED3_R                  /* synthesis LOC = "K6"*/ ,// from  CPLD_M                                        to  FAN_FAIL_LED3/D39_18_225SURSYGC_S530_...     default 1  // 风扇故障LED3控制信号输出              新增

output o_PAL_FAN_NRML_LED0_R                  /* synthesis LOC = "P3"*/ ,// from  CPLD_M                                        to  FAN_NORMAL_LED0/D36_18_225SURSYGC_S530_...   default 1  // 风扇正常LED0控制信号输出              新增
output o_PAL_FAN_NRML_LED1_R                  /* synthesis LOC = "T3"*/ ,// from  CPLD_M                                        to  FAN_NORMAL_LED1/D37_18_225SURSYGC_S530_...   default 1  // 风扇正常LED1控制信号输出              新增
output o_PAL_FAN_NRML_LED2_R                  /* synthesis LOC = "U4"*/ ,// from  CPLD_M                                        to  FAN_NORMAL_LED2/D38_18_225SURSYGC_S530_...   default 1  // 风扇正常LED2控制信号输出              新增
output o_PAL_FAN_NRML_LED3_R                  /* synthesis LOC = "K2"*/ ,// from  CPLD_M                                        to  FAN_NORMAL_LED3/D39_18_225SURSYGC_S530_...   default 1  // 风扇正常LED3控制信号输出              新增

output o_FAN_P12V_DISCHARGE_R                 /* synthesis LOC = "N16"*/,// from  CPLD_M                                        to  FAN_P12V_DISCHARGE/FAN_P12V_DISCHARGE        default 1  // 风扇12V电源放电信号输出


// =============================================================================
//  DPLL控制信号
// =============================================================================
output o_PAL_DPLL_GPIO0_R                     /* synthesis LOC = "K14"*/,// from  CPLD_M                                        to  DB_MODULE/J27_10154478_067RCMLF/NC_PEWAKE    default 1  // PAL模块DPLL GPIO0信号输出                 新增
output o_PAL_DPLL_GPIO1_R                     /* synthesis LOC = "P18"*/,// from  CPLD_M                                        to  DB_MODULE/J27_10154478_067RCMLF/SUSCLK       default 1  // 输出DB_MODULE的SUSCLK                 新增
output o_PAL_DPLL_INIT_R                      /* synthesis LOC = "U17"*/,// from  CPLD_M                                        to  DB_MODULE/J27_10154478_067RCMLF/NC_CLKERQ    default 1  // DPLL模块初始化信号输出                新增
output o_PAL_DPLL_RESET_R                     /* synthesis LOC = "V19"*/,// from  CPLD_M                                        to  DB_MODULE/J27_10154478_067RCMLF/NC_RESET     default 1  // DPLL模块复位信号输出                  新增

// =============================================================================
//  复位控制信号
// =============================================================================
// BMC 中断和复位信号
input  i_PAL_BMC_INT_N                        /* synthesis LOC = "P16"*/,// from  CPLD_M                                        to  GENZ_168PIN_J98_5653E5/PERP_10               default 1  // BMC中断信号输出
output o_PAL_BMC_PREST_N_R                    /* synthesis LOC = "P15"*/,// from  CPLD_M                                        to  GENZ_168PIN_J98_5653E5/PERN_9                default 1  // BMC预置复位信号输出                   新增
output o_PAL_BMC_SRST_R                       /* synthesis LOC = "T18"*/,// from  CPLD_M                                        to  GENZ_168PIN_J98_5653E5/PERN_10               default 1  // BMC复位信号输出

// BIOS 复位信号
output o_BIOS0_RST_N_R                        /* synthesis LOC = "K18"*/,// from  CPLD_M                                         to  BIOS_FLASH0/BIOS0_RST_N                      default 1  // BIOS0复位信号输出
output o_BIOS1_RST_N_R                        /* synthesis LOC = "B2"*/ ,// from  CPLD_M                                         to  BIOS_FLASH1/BIOS1_RST_N                      default 1  // BIOS0复位信号输出 

// CPU0/1 上电复位信号输出
input  i_CPU0_D0_PEU_PREST_0_N_R              /* synthesis LOC = "Y5"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_PCIE_PREST_0_N default 0  // CPU0 D0 区域PEU预置复位信号0
input  i_CPU0_D0_PEU_PREST_1_N_R              /* synthesis LOC = "W7"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_PCIE_PREST_1_N default 0  // CPU0 D0 区域PEU预置复位信号1   
input  i_CPU0_D0_PEU_PREST_2_N_R              /* synthesis LOC = "T12"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_PCIE_PREST_2_N default 0  // CPU0 D0 区域PEU预置复位信号2
input  i_CPU0_D0_PEU_PREST_3_N_R              /* synthesis LOC = "T9"*/,

input  i_CPU0_D1_PEU_PREST_0_N_R              /* synthesis LOC = "R9"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_0_N default 0  // CPU0 D1 区域PEU预置复位信号0
input  i_CPU0_D1_PEU_PREST_1_N_R              /* synthesis LOC = "W8"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_1_N default 0  // CPU0 D1 区域PEU预置复位信号1  
input  i_CPU0_D1_PEU_PREST_2_N_R              /* synthesis LOC = "Y7"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_2_N default 0  // CPU0 D1 区域PEU预置复位信号2
input  i_CPU0_D1_PEU_PREST_3_N_R              /* synthesis LOC = "U9"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_3_N default 0  // CPU0 D1 区域PEU预置复位信号3   

input  i_CPU1_D0_PEU_PREST_0_N_R              /* synthesis LOC = "Y5"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_PCIE_PREST_0_N default 0  // CPU0 D0 区域PEU预置复位信号0
input  i_CPU1_D0_PEU_PREST_1_N_R              /* synthesis LOC = "W7"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_PCIE_PREST_1_N default 0  // CPU0 D0 区域PEU预置复位信号1   
input  i_CPU1_D0_PEU_PREST_2_N_R              /* synthesis LOC = "T12"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_PCIE_PREST_2_N default 0  // CPU0 D0 区域PEU预置复位信号2
input  i_CPU1_D0_PEU_PREST_3_N_R              /* synthesis LOC = "T9"*/,

input  i_CPU1_D1_PEU_PREST_0_N_R              /* synthesis LOC = "R9"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_0_N default 0  // CPU0 D1 区域PEU预置复位信号0
input  i_CPU1_D1_PEU_PREST_1_N_R              /* synthesis LOC = "W8"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_1_N default 0  // CPU0 D1 区域PEU预置复位信号1  
input  i_CPU1_D1_PEU_PREST_2_N_R              /* synthesis LOC = "Y7"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_2_N default 0  // CPU0 D1 区域PEU预置复位信号2
input  i_CPU1_D1_PEU_PREST_3_N_R              /* synthesis LOC = "U9"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_PCIE_PREST_3_N default 0  // CPU0 D1 区域PEU预置复位信号3   

input  i_CPU0_D0_PCIE_RST                     /* synthesis LOC = "R11"*/,// form  CPU0_GPIO1/D0_PCIE_RST                        to  CPLD_M                                       default 1  // CPU0 D0 区域 VDD_IO_P1V8 电源中断 PCIe 链路复位信号
input  i_CPU1_D0_PCIE_RST                     /* synthesis LOC = "T16"*/,// from  CPU1_GPIO1/D0_PCIE_RST                        to  CPLD_M                                       default 1  // CPU1 D0 区域 PCIe 链路复位信号
input  i_CPU0_D1_PCIE_RST                     /* synthesis LOC = "Y8"*/, // from  CPU0_GPIO2/D1_PCIE_RST                        to  CPLD_M                                       default 1  // CPU0 D1 区域 VDD_IO_P1V8 电源中断 PCIe 链路复位信号
input  i_CPU1_D1_PCIE_RST                     /* synthesis LOC = "T14"*/,// from  CPU1_GPIO2/D1_PCIE_RST                        to  CPLD_M                                       default 1  // CPU1 D1 区域PCIE复位信号

input  i_CPU0_D0_CRU_RST_OK                   /* synthesis LOC = "Y13"*/,// form  CPU0_GPIO1/D0_CRU_RST_OK                      to  CPLD_M                                       default 0  // CPU0 D0 区域CRU复位完成信input  i_CPU0_D0_BIOS_OVER                    /* synthesis LOC = "U10"*/,// from  CPU0_GPIO1/D0_UART2_RXD                       to  CPLD_M                                       default 0  // CPU0 D0 区域BIOS超时信号
input  i_CPU0_D1_CRU_RST_OK                   /* synthesis LOC = "P9"*/, // from  CPU0_GPIO2/D1_CRU_RST_OK                      to  CPLD_M                                       default 1  // CPU0 D1 区域CRU复位完成信号
input  i_CPU1_D0_CRU_RST_OK                   /* synthesis LOC = "R6"*/ ,// form  CPU1_GPIO1/D0_CRU_RST_OK                      to  CPLD_M                                       default 1  // CPU1 D0 区域CRU复位完成信号
input  i_CPU1_D1_CRU_RST_OK                   /* synthesis LOC = "W14"*/,// form  CPU1_GPIO2/D1_CRU_RST_OK                      to  CPLD_M                                       default 1  // CPU1 D1 区域CRU复位完成信号

input  i_CPU0_RST_VPP_I2C_N                   /* synthesis LOC = "R10"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[11]                   to  CPLD_M                                       default 0  // CPU0 VPP电源域 VDD_IO_P1V8 电源中断 I2C复位信号
input  i_CPU1_RST_VPP_I2C_N                   /* synthesis LOC = "W6"*/, // from  CPU1_GPIO1/D0_GPIO_PORT[11]                   to  CPLD_M                                       default 0  // CPU1 VPP电源域 VDD_IO_P1V8 电源中断 I2C复位信号

output o_CPU0_PE2_RST_N_R                     /* synthesis LOC = "R1"*/ ,// from  CPLD_M                                        to  CPU0_MCIO_0/1/SIDEBAND_2                     default 1  // CPU0 PE2复位信号输出
output o_CPU0_PE3_RST_N_R                     /* synthesis LOC = "F7"*/ ,// from  CPLD_M                                        to  CPU0_MCIO_2/3 / CPU0_NVM4/6_PERST_N          default 1  // CPU0 PE3复位信号输出
output o_CPU1_PE1_RST_N_R                     /* synthesis LOC = "G13"*/,// from  CPU1_MCIO_2/3 / J23_G97V22312HR               to  CPLD_M                                       default 1  // CPU1 PE1(process element)复位信号输入
output o_CPU1_PE2_RST_N_R                     /* synthesis LOC = "F12"*/,// from  CPU1_MCIO_2/3 / J23_G97V22312HR               to  CPLD_M                                       default 1  // CPU1 PE2(process element)复位信号输入

output o_PAL_88SE9230_RST_N_R                 /* synthesis LOC = "V3"*/ ,// from  CPLD_M                                        to  PEX_88SE9230/U93_XSAT2204LACGR               default 1  // 88SE9230复位信号输出（反向）
output o_CPU1_D0_DOWN_GPIO8_RST_N             /* synthesis LOC = "P14"*/,// from  CPU1_GPIO1/D0_GPIO_PORT[8]                    to  CPLD_M                                       default 0  // CPU1 D0 区域 VDD_IO_P1V8 GPIO8复位信号

output o_PAL_RST_CPU0_VPP_N_R                 /* synthesis LOC = "A1"*/ ,// from  CPLD_M                                         to  I2C_VPP_U182                                 default 1  // CPU0 VPP复位信号输出
output o_PAL_RST_CPU1_VPP_N_R                 /* synthesis LOC = "B17"*/,// from  CPLD_M                                         to  I2C_VPP_U183                                 default 1  // CPU1 VPP复位信号输入（反向）

output o_PAL_CPU0_VR8_RESET_R                 /* synthesis LOC = "K15"*/,// from  CPLD_M                                        to  CPU_VR8_Controler/SV13_VR_RESET_N            default 1  // CPU0    VR8复位信号输出
output o_PAL_CPU1_VR8_RESET_R                 /* synthesis LOC = "L2"*/ ,// from  CPLD_M                                        to  CPU_VR8_Controler/SV13_VR_RESET_N            default 1  // CPU1    VR8复位信号输出

output o_CPU0_POR_N_R                         /* synthesis LOC = "Y14"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/POR_N             default 0  // CPU0    上电复位信号
output o_CPU1_POR_N_R                         /* synthesis LOC = "V16"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/POR_N             default 0  // CPU1    上电复位信号


// =============================================================================
//  DEBUG相关信号
// =============================================================================
// 机箱安全检测接口
input  i_FRONT_PAL_INTRUDER                   /* synthesis LOC = "C10"*/,// from  INTRUDER_CONN                                 to  CPLD_M                                       default 1  // 机箱安全检测接口

// 网口芯片的管理GPIO信号
input  i_MNG_GPIO_0_PCIE_R                    /* synthesis LOC = "C12"*/,// from  P12V_DISCHARGE/U20_WX1860A2                   to  CPLD_M                                       default 1  // 网口芯片的管理GPIO0 PCIe信号输入      新增

// 88SE9230 PCIE转SATA芯片唤醒信号
input  i_PAL_88SE9230_WAKE_N                  /* synthesis LOC = "K4"*/ ,// from  PEX_88SE9230/U93_XSAT2204LACGR                to  CPLD_M                                       default 1  // 88SE9230芯片唤醒信号输入

// CPU0/1 电压调节器选择信号输出
output o_PAL_CPU0_VR_SELECT_N_R               /* synthesis LOC = "C16"*/,// from  CPLD_M                                         to  CPU_I2C_LEVEL_TRAN/U33_PAL_CPU1_VR_SELECT_N  default 0  // CPU0 电压调节器选择信号输出                     // 新增
output o_PAL_CPU1_VR_SELECT_N_R               /* synthesis LOC = "E6"*/ ,// from  CPLD_M                                         to  CPU_I2C_LEVEL_TRAN/U33_PAL_CPU1_VR_SELECT_N  default 0  // CPU1 电压调节器选择信号输出                     // 新增

// PSU1 电源模块 交流故障信号/直流电源良好信号/存在信号/SMBus告警到FPGA 信号
input  i_PAL_PS1_ACFAIL                       /* synthesis LOC = "D7"*/ ,// from  PSU_MISC2                                      to  CPLD_M                                       default 1  // PS1交流故障信号输入
input  i_PAL_PS1_DCOK                         /* synthesis LOC = "B8"*/ ,// from  PSU_MISC2                                      to  CPLD_M                                       default 1  // PS1 DCOK信号输入
input  i_PAL_PS1_PRSNT                        /* synthesis LOC = "A7"*/ ,// from  PSU_MISC2                                      to  CPLD_M                                       default 1  // PS1存在信号输入
input  i_PAL_PS1_SMB_ALERT_TO_FPGA            /* synthesis LOC = "G9"*/ ,// from  PSU_MISC2                                      to  CPLD_M                                       default 1  // PS1 SMBus告警到FPGA信号输入

// PSU2 电源模块 交流故障信号/直流电源良好信号/存在信号/SMBus告警到FPGA 信号
input  i_PAL_PS2_ACFAIL                       /* synthesis LOC = "A2"*/ ,// from  PSU_MISC2/PS2_ACFAIL                           to  CPLD_M                                       default 1  // PS2交流故障信号输入
input  i_PAL_PS2_DCOK                         /* synthesis LOC = "B5"*/ ,// from  PSU_MISC2                                      to  CPLD_M                                       default 1  // PS2 DCOK信号输入
input  i_PAL_PS2_PRSNT                        /* synthesis LOC = "B4"*/ ,// from  PSU_MISC2                                      to  CPLD_M                                       default 1  // PS2存在信号输入
input  i_PAL_PS2_SMB_ALERT_TO_FPGA            /* synthesis LOC = "F9"*/ ,// from  PSU_MISC2                                      to  CPLD_M                                       default 1  // PS2 SMBus告警到FPGA信号输入

// BP1/2 CPU 配置检测与模式控制信号输入
input  i_PAL_BP1_CPU_1P2P                     /* synthesis LOC = "B3"*/ ,// from  BP_AUX_PWR/J84                                 to  CPLD_M                                       default 1  // BP1 CPU 配置检测与模式控制, 告知 CPLD 当前系统处于 1P（单 CPU）或 2P（双 CPU）配置，并据此切换平台的供电、内存映射与 I/O 拓扑规则
input  i_PAL_BP2_CPU_1P2P                     /* synthesis LOC = "A4"*/ ,// from  BP_AUX_PWR/J86                                 to  CPLD_M                                       default 1  // BP1 CPU 配置检测与模式控制, 告知 CPLD 当前系统处于 1P（单 CPU）或 2P（双 CPU）配置，并据此切换平台的供电、内存映射与 I/O 拓扑规则
input  i_PAL_BP1_PRSNT_N                      /* synthesis LOC = "A9"*/ ,// from  BP_AUX_PER/J84                                 to  CPLD_M                                       default 1  // BP1 存在信号输入（低电平有效）                  新增
input  i_PAL_BP2_PRSNT_N                      /* synthesis LOC = "C6"*/ ,// from  BP_AUX_PWR/J86                                 to  CPLD_M                                       default 1  // BP2 存在信号输入（低电平有效）                  新增

// DEBUG 信号输入
input  i_PAL_DB_GPIO0_R                       /* synthesis LOC = "G4"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO0           to  CPLD_M                                       default 1  // DEBUG GPIO0信号输入                              // 新增
input  i_PAL_DB_GPIO1_R                       /* synthesis LOC = "G3"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO1           to  CPLD_M                                       default 1  // DEBUG GPIO1信号输入                              // 新增
input  i_PAL_DB_GPIO2_R                       /* synthesis LOC = "H3"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO2           to  CPLD_M                                       default 1  // DEBUG GPIO2信号输入                              // 新增
input  i_PAL_DB_GPIO3_R                       /* synthesis LOC = "H4"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO2           to  CPLD_M                                       default 1  // DEBUG GPIO2信号输入                              // 新增
input  i_PAL_DB_GPIO4_R                       /* synthesis LOC = "G2"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO4           to  CPLD_M                                       default 1  // DEBUG GPIO4信号输入                              // 新增
input  i_PAL_DB_GPIO5_R                       /* synthesis LOC = "J5"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO5           to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增

// DB 模块电源初始化/上电使能/存在信号输入
input  i_PAL_DB_INT_N_R                       /* synthesis LOC = "H2"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/PAL_DB_INIT_N      to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增
input  i_PAL_DB_ON_N_R                        /* synthesis LOC = "G1"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/PAL_DB_ON_N        to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增
input  i_PAL_DB_PRSNT_N_R                     /* synthesis LOC = "J6"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/PAL_DB_PRSNT_N     to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增

// DPLL 模块 DEBUG 信号输入
input  i_PAL_DPLL_GPIO2_R                     /* synthesis LOC = "N14"*/,// from  DB_MODULE/J27_10154478_067RCMLF/DAS_DSS        to  CPLD_M                                       default 1  // DEGUB DPLL GPIO2信号输入(PCIe 扩展卡或其他高速设备传递数据选通的控制逻辑)          新增(未使用)
input  i_PAL_DPLL_GPIO3_R                     /* synthesis LOC = "M17"*/,// from  DB_MODULE/J27_10154478_067RCMLF/SEVSLP         to  CPLD_M                                       default 1  // DEGUB DB_MODUL的DEVSLP信号输入               新增(未使用)
input  i_PAL_DPLL_GPIO4_R                     /* synthesis LOC = "J15"*/,// from  DB_MODULE/J27_10154478_067RCMLF/NC_1           to  CPLD_M                                       default 1  // DEGUB DPLL GPIO4信号输入                 新增(未使用)
input  i_PAL_DPLL_GPIO5_R                     /* synthesis LOC = "D20"*/,// from  DB_MODULE/J27_10154478_067RCMLF/NC_2           to  CPLD_M                                       default 1  // DEGUB DPLL GPIO5信号输入                 新增(未使用)
input  i_PAL_DPLL_RRSNT_R                     /* synthesis LOC = "N20"*/,// from  DB_MODULE/J27_10154478_067RCMLF/RRSNT_N        to  CPLD_M                                       default 1  // DEGUB DB_MODUL的RRSNT信号输入                新增(未使用)

// RTC 实时时钟芯片中断信号
input  i_PAL_RTC_INTB                         /* synthesis LOC = "D6"*/ ,// from  RTC                                            to  CPLD_M                                       default 1  // RTC中断信号输入

// TMP431ADGKR 温度传感器告警信号输入
input  i_PAL_TMP1_ALERT_N                     /* synthesis LOC = "R4"*/ ,// from  FRU_EER_TMP/U8_TMP431ADGKR1                    to  CPLD_M                                       default 0  // 温度传感器1告警信号输入
input  i_PAL_TMP2_ALERT_N                     /* synthesis LOC = "H14"*/,// from  FRU_EER_TMP/U9_TMP431ADGKR                     to  CPLD_M                                       default 0  // 温度传感器2告警信号输入
input  i_PAL_TMP3_ALERT_N                     /* synthesis LOC = "P17"*/,// from  FRU_EER_TMP/U7_TMP431ADGKR2                    to  CPLD_M                                       default 0  // 温度传感器3告警信号输入               

// UPD72020 软硬盘控制器电源告警信号输入
input  i_PAL_UPD72020_VCC_ALART               /* synthesis LOC = "G17"*/,// from  WX1860_POL_U82_JW7111SSOTBTRPBF/OUT            to  CPLD_M                                       default 1  // UPD72020 VCC电源告警信号输入
input  i_PAL_USB_UPD2_OCI2B                   /* synthesis LOC = "A12"*/,// from  USB3.0/U311_JW7111SSOTBTRPBF                   to  CPLD_M                                      default 1  // USB UPD2 OCI2B信号输入输出
input  i_PAL_USB_UPD2_OCIIB                   /* synthesis LOC = "B15"*/,// from  USB3.0                                         to  CPLD_M                                       default 1  // USB UPD2 OCIIB信号输入                       新增

// CPU0/1 3.3V 电源告警信号输入
input  i_SMB_PEHP_CPU0_3V3_ALERT_N            /* synthesis LOC = "N5"*/ ,// from  CPU0_MCIO_0/1/SIDEBAND3                        to  CPLD_M                                       default 1  // CPU0    3v3电源告警信号输入
input  i_SMB_PEHP_CPU1_3V3_ALERT_N            /* synthesis LOC = "J17"*/,// from  REAR BP AUX PWR/SMB_CPU1_AUX1_ALERT_N          to  CPLD_M                                       default 1  // CPU1    3v3电源告警信号输入

// WX1860A2 存在与复位信号输入
input  i_PAL_WX1860_NRST_R                    /* synthesis LOC = "A15"*/,// from  PEX_WX1860A2/U20_WX1860A2                      to  CPLD_M                                       default 1  // WX1860 复位信号输入                           新增
input  i_PAL_WX1860_PERST_R                   /* synthesis LOC = "A16"*/,// from  PEX_WX1860A2/U20_WX1860A2                      to  CPLD_M                                       default 1  // WX1860 存在信号输入                         新增

// TPM 模块存在信号输入
input  i_TPM_MODULE_PRSNT_N                   /* synthesis LOC = "N17"*/,// from  TPM                                            to  CPLD_M                                       default 1  // TPM模块存在信号输入（低电平有效）               新增

// CPU0 主板区域温度过高告警信号输出
output o_CPU0_BOARD_TEMP_OVER_R               /* synthesis LOC = "P13"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/BOARD_TEMP_OVER   default 1  // CPU0    主板区域温度过高告警信号输出

// CPU0/1 D0 区域插槽ID信号输入
input  i_CPU0_D0123_SOCKET_ID_R               /* synthesis LOC = "Y4"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_INSTANCELD_1   default 1  // CPU0 D0 区域插槽ID信号                
input  i_CPU1_D0123_SOCKET_ID_R               /* synthesis LOC = "T7"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_INSTANCELD_1   default 0  // CPU1 D0 区域插槽ID信号            

// CPU0/1 D0/D1 区域安全恢复信号输入
input  i_CPU0_D1_SE_RECOVERY_R                /* synthesis LOC = "U12"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_SE_RECOVERY    default 1  // CPU0 D1 区域安全恢复信号
input  i_CPU1_D0_SE_RECOVERY_R                /* synthesis LOC = "P11"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_SE_RECOVERY    default 1  // CPU1 D0 区域安全恢复信号

// CPU0/1 I2C 传输使能信号输出
output o_CPU0_I2C_TRAN_EN_R                   /* synthesis LOC = "W1"*/,// from  CPLD_M                                        to  U213/214_RS0302YH8                           default 1  // CPU0    I2C传输使能信号（CPU 与 DDR 之间的 I2C 电平转换电路）
output o_CPU1_I2C_TRAN_EN_R                   /* synthesis LOC = "Y1"*/,// from  CPLD_M                                        to  U217/218_RS0302YH8                           default 1  // CPU1    I2C传输使能信号（CPU 与 DDR 之间的 I2C 电平转换电路）

// CPU0/1 SCP从Flash启动信号输出
output o_FT_CPU0_SCP_BOOT_FROM_FLASH_R        /* synthesis LOC = "W20"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/REV9              default 1  // CPU0 SCP从Flash启动信号
output o_FT_CPU1_SCP_BOOT_FROM_FLASH_R        /* synthesis LOC = "R15"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/REV9              default 1  // CPU1 SCP从Flash启动信号

// CPU1 D0 区域软关机中断信号
input  i_CPU0_D0_SOFT_SHUTDOWN_INT_N          /* synthesis LOC = "Y1" */,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_UART2_TXD      default 0  // CPU0 D0 区域软关机中断信号 , 触发系统软关机流程
input  i_CPU1_D0_SOFT_SHUTDOWN_INT_N          /* synthesis LOC = "Y1"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_UART2_TXD      default 0  // CPU1 D0 区域软关机中断信号 , 触发系统软关机流程

// CPU0/1 NVME 告警信号输入
input  i_PAL_CPU0_NVME_ALERT_N_R              /* synthesis LOC = "W4"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_QSPI_CSM[2]    default 0  // CPU0    NVME告警信号                 
input  i_PAL_CPU1_NVME_ALERT_N_R              /* synthesis LOC = "T13"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_QSPI_CSM[2]    default 0  // CPU1    NVME告警信号

// CPU0/1 主板区域温度过高告警信号输出
input  i_CPU0_BOARD_TEMP_OVER_R               /* synthesis LOC = "Y11"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/BOARD_TEMP_OVER   default 1  // CPU0    主板区域温度过高告警信号输出
input  i_CPU1_BOARD_TEMP_OVER_R               /* synthesis LOC = "Y11"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/BOARD_TEMP_OVER   default 1  // CPU1    主板区域温度过高告警信号输出

// CPU0/1 电压调节器（VR）上报电源异常状态输入
input  i_PAL_CPU0_VR_PMALT_R                  /* synthesis LOC = "P8"*/, // from  S5000C32_3200_C/CPU0_GPIO1/PMBALERT_IN_N      to  CPLD_M                                       default 1  // CPU0 电压调节器（VR）上报电源异常状态    
input  i_PAL_CPU1_VR_PMALT_R                  /* synthesis LOC = "U15"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/PMBALERT_IN_N     default 1  // CPU1    电压调节器（VR）向CPLD上报电源异常状态

// CPU0/1 温度传感器告警信号输入
input  i_PAL_CPU0_TMP_ALERT_N                 /* synthesis LOC = "T4"*/ ,// from  CPU0_TMP/U187_EMC1413_A_AIA_TR                to  CPLD_M                                       default 0  // CPU0 温度告警信号输入
input  i_PAL_CPU1_TMP_ALERT_N                 /* synthesis LOC = "N3"*/ ,// from  CPU1_TMP/U188_EMC1413_A_AIA_TR                to  CPLD_M                                       default 0  // CPU1温度告警信号输入              

// CPU0/1 D0/D1 区域BIOS超时信号输入
input  i_CPU1_D0_BIOS_OVER                    /* synthesis LOC = "Y12"*/,// from  CPU1_GPIO1/D0_UART2_RXD                       to  CPLD_M                                       default 1  // CPU1 D0 区域BIOS超时信号 

// CPU0/1 TIMER FORCE START 信号输入
input  i_CPU01_TIMER_FORCE_START              /* synthesis LOC = "V15"*/,// 未使用

// CPU0/1 VR8 CAT 故障信号输入
input  i_CPU0_VR8_CAT_FLT                     /* synthesis LOC = "V1"*/ ,// from  CPU_VR8_Controler/VR_FAULT                    to  CPLD_M                                       default 1  // CPU0 VR8 CAT故障信号输入
input  i_CPU0_VR_ALERT_N_R                    /* synthesis LOC = "T1"*/ ,// from  CPU_VR8_Controler/I2C_VR_ALERT_N              to  CPLD_M                                       default 1  // CPU0 电压调节器告警信号输入             新增       
input  i_CPU1_VR8_CAT_FLT                     /* synthesis LOC = "M4"*/ ,// from  CPU_VR8_Controler/VR_FAULT                    to  CPLD_M                                       default 1  // CPU1 VR8 CAT故障信号输入                    
input  i_CPU1_VR_ALERT_N_R                    /* synthesis LOC = "T2"*/ ,// from  CPU_VR8_Controler/I2C_VR_ALERT_N              to  CPLD_M                                       default 1  // CPU1电压调节器告警信号输入             新增   

// CPU0/1 D0/D1 区域电源控制信号输入
input  i_CPU0_D1_PWR_CTR0_R                   /* synthesis LOC = "Y6"*/, // from  CPU0_GPIO2/D1_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU0 D1 区域电源控制信号0
input  i_CPU0_D1_PWR_CTR1_R                   /* synthesis LOC = "W3"*/, // from  CPU0_GPIO2/D1_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU0 D1 区域电源控制信号1
input  i_CPU1_D0_PWR_CTR0_R                   /* synthesis LOC = "T9"*/, // from  CPU1_GPIO1/D0_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU1 D0 区域电源控制信号0
input  i_CPU1_D0_PWR_CTR1_R                   /* synthesis LOC = "R8"*/, // from  CPU1_GPIO1/D0_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU1 D0 区域电源控制信号1
input  i_CPU1_D1_PWR_CTR0_R                   /* synthesis LOC = "W15"*/,// from  CPU1_GPIO2/D1_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU1 D1 区域电源控制信号0
input  i_CPU1_D1_PWR_CTR1_R                   /* synthesis LOC = "Y19"*/,// from  CPU1_GPIO2/D1_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU1 D1 区域电源控制信号1
input  i_CPU0_D0_PWR_CTR0_R                   /* synthesis LOC = "Y2"*/, // form  CPU0_GPIO1/D0_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU0 D0 区域电源控制信号0（cpu的状态反馈, 解除重上电）
input  i_CPU0_D0_PWR_CTR1_R                   /* synthesis LOC = "V6"*/, // from  CPU0_GPIO1/D0_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU0 D0 区域电源控制信号1（cpu的状态反馈, 控制重上电）

// CPU0/1 D0 区域内存电源中断初始化信号输入
input  i_CPU0_D0_MEMORY_POWER_INT_N           /* synthesis LOC = "R13"*/,// from  CPU0_GPIO1/D0_QSPI_CSN[3]                     to  CPLD_M                                       default 0  // CPU0 D0 区域 VDD_IO_P1V8 电源中断 初始化信号
input  i_CPU1_D0_MEMORY_POWER_INT_N           /* synthesis LOC = "T6"*/ ,// from  CPU1_GPIO1/D0_QSPI_CSN[3]                     to  CPLD_M                                       default 0  // CPU1 D0 区域 VDD_IO_P1V8 电源中断 初始化信号

// CK440 电源关闭信号输入
input  i_PAL_CK440_PWRDN_N_R                  /* synthesis LOC = "H20"*/,// from  CPLD_M                                        to  CK440_CLKEN/PAL_CK440_PWRDN_N                default 1  // CK440电源关闭信号输出

output o_INTRUDER_CABLE_INST_N                /* synthesis LOC = "C14"*/,// from  CPLD_M                                         to  INTRUDER_CONN                                default 1  
output o_PAL_RTC_SELECT_N                     /* synthesis LOC = "A11"*/,// from  CPLD_M                                         to  RTC                                          default 1  // RTC选择信号输出（低电平有效）
input  i_PAL_SYS_EEPROM_BYPASS_N_R            /* synthesis LOC = "D16"*/,

// 预留GPIO口数据
input  i_CPU0_D0_GPIO_PORT0_R                 /* synthesis LOC = "V10"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[0]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 0
input  i_CPU0_D0_GPIO_PORT1_R                 /* synthesis LOC = "W11"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[1]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 1
input  i_CPU0_D0_GPIO_PORT2_R                 /* synthesis LOC = "P12"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[2]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 2
input  i_CPU0_D0_GPIO_PORT3_R                 /* synthesis LOC = "U11"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[3]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 3
input  i_CPU0_D0_GPIO_PORT4_R                 /* synthesis LOC = "W1"*/ ,// form  CPU0_GPIO1/D0_GPIO_PORT[0]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 4  新增
input  i_CPU0_D0_GPIO_PORT5_R                 /* synthesis LOC = "R6"*/ ,// form  CPU0_GPIO1/D0_GPIO_PORT[5]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 5  新增
input  i_CPU0_D0_GPIO_PORT6_R                 /* synthesis LOC = "T6"*/ ,// form  CPU0_GPIO1/D0_GPIO_PORT[6]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 6  新增
input  i_CPU0_D0_GPIO_PORT7_R                 /* synthesis LOC = "P7"*/ ,// from  CPU0_GPIO1/D0_GPIO_PORT[7]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 7  新增
input  i_CPU0_D0_DOWN_GPIO8_RST_N             /* synthesis LOC = "R7"*/ ,// from  CPU0_GPIO1/D0_GPIO_PORT[8]                    to  CPLD_M                                       default 0  // CPU0 D0 区域下行GPIO8复位信号
input  i_CPU0_D0_GPIO_PORT9_R                 /* synthesis LOC = "R7"*/ ,// from  CPU0_GPIO1/D0_GPIO_PORT[9]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 9  新增
input  i_CPU0_D0_GPIO_PORT10_R                /* synthesis LOC = "Y3"*/ ,// from  CPU0_GPIO1/D0_GPIO_PORT[10]                   to  CPLD_M                                       default 1  // CPU0 D0 区域通用输入输出端口 10 新增
input  i_CPU1_D0_GPIO_PORT4_R                 /* synthesis LOC = "Y10"*/// from  CPU1_GPIO1/D0_GPIO_PORT[4]                    to  CPLD_M                                       default 1  // CPU1 D0 区域 通用输入输出端口 4        新增
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
线网, 寄存器, 参数声明
------------------------------------------------------------------------------------------------------------------------------------------------*/
// clks & resets
parameter                                   PEAVEY_SUPPORT       = 1'b1 ;  
wire                                        done_booting_delayed = 1'b1 ; // 不使用, 系统booting_done, 来自BMC, 默认写1
wire                                        clk_50m                     ; // 不使用
wire                                        sys_clk                     ; // 系统时钟
wire                                        pll_lock                    ;
wire                                        pon_reset_n                 ; // 使用  , 全局复位
wire                                        pon_reset_db_n              ; // 不使用, 复位
wire                                        pgd_aux_system              ; // 不使用, 复位
wire                                        pgd_aux_system_sasd         ; // 不使用, 复位
wire                                        pgd_aux_bmc          = 1'b1 ; // 不使用, BMC_PDG, 来自BMC, 默认写1
wire                                        reached_sm_wait_powerok     ; // 不使用, 传给从使用
wire                                        cpld_ready                  ; // 不使用, 复位

// tick 定时脉冲; clk 频率时钟
wire                                        t40ns_tick                  ;
wire                                        t80ns_tick                  ;
wire                                        t160ns_tick                 ;
wire                                        t1us_tick                   ;
wire                                        t2us_tick                   ;  
wire                                        t8us_tick                   ;
wire                                        t16us_tick                  ;
wire                                        t32us_tick                  ;
wire                                        t128us_tick                 ;
wire                                        t512us_tick                 ;
wire                                        t1ms_tick                   ;
wire                                        t2ms_tick                   ;
wire                                        t16ms_tick                  ;
wire                                        t32ms_tick                  ;
wire                                        t64ms_tick                  ;
wire                                        t128ms_tick                 ;
wire                                        t256ms_tick                 ;
wire                                        t512ms_tick                 ;
wire                                        t1s_tick                    ;
wire                                        t8s_tick                    ;
wire                                        t0p5hz_clk                  ;
wire                                        t1hz_clk                    ;
wire                                        t2p5hz_clk                  ;
wire                                        t4hz_clk                    ;
wire                                        t16khz_clk                  ;
wire                                        t6m25_clk                   ;

// S5DEV 不使用电源模块状态与控制信号
wire [`NUM_S5DEV-1:0]                       s5dev_prsnt_n               ;
wire [`NUM_S5DEV-1:0]                       s5dev_aux_pgd               ;
wire [`NUM_S5DEV-1:0]                       s5dev_aux_en                ;
wire [`NUM_S5DEV-1:0]                       s5dev_main_en               ;
wire [`NUM_S5DEV-1:0]                       s5dev_aux_fault             ; 
wire                                        s5dev_aux_pwren_request     ;
wire                                        s5dev_aux_pwrdis_request    ;
wire [`NUM_S5DEV-1:0]                       s5dev_main_pgd              ;
wire [`NUM_S5DEV-1:0]                       s5dev_main_fault            ; 
wire                                        s5dev_fan_on_aux            ;

// 辅电源使能信号
// 1. SM_OFF_STANDBY 状态上电使能
wire                                        ocp_aux_en                  ; // 不使用
wire                                        cpu_bios_en                 ; // 不使用
wire                                        p12v_bp_front_en            ; // 不使用
// 2. SM_EN_5V_STBY 状态上电使能
wire                                        p5v_stby_en_r               ;
// 3. SM_EN_TELEM 状态上电使能
wire                                        pvcc_hpmos_cpu_en_r         ;
// 4. SM_EN_MAIN_EFUSE 状态上电使能
wire                                        power_supply_on             ; 
wire                                        ocp_main_en                 ; // 不使用 
wire                                        pal_main_efuse_en           ; // 不使用
wire                                        p12v_bp_rear_en             ; // 不使用 
wire                                        p12v_bp_front_en            ;
// 5. SM_EN_5V 状态上电使能
wire                                        p5v_en_r                    ;
// 6. SM_EN_3V3 状态上电使能
wire                                        p3v3_en_r                    ;

// 主电源使能信号
// 1. SM_EN_VDD 状态上电使能
wire                                        cpu0_vdd_core_en_r          ;
wire                                        cpu1_vdd_core_en_r          ;
// 2. SM_EN_P1V8 状态上电使能
wire                                        cpu0_p1v8_en_r              ;
wire                                        cpu1_p1v8_en_r              ;
// 3. SM_EN_P2V5_VPP 状态上电使能
wire                                        cpu0_vddq_en_r              ;
wire                                        cpu1_vddq_en_r              ;
wire                                        cpu0_ddr_vdd_en_r           ;
wire                                        cpu1_ddr_vdd_en_r           ;
wire                                        cpu0_pll_p1v8_en_r          ;
wire                                        cpu1_pll_p1v8_en_r          ;
// 4. SM_EN_P0V8 状态上电使能
wire                                        cpu0_d0_vp_p0v9_en_r        ;
wire                                        cpu0_d1_vp_p0v9_en_r        ;
wire                                        cpu0_d0_vph_p1v8_en_r       ;
wire                                        cpu0_d1_vph_p1v8_en_r       ;
wire                                        cpu1_d0_vp_p0v9_en_r        ;
wire                                        cpu1_d1_vp_p0v9_en_r        ;
wire                                        cpu1_d0_vph_p1v8_en_r       ;
wire                                        cpu1_d1_vph_p1v8_en_r       ;

// CPLD控制复位输出
wire                                        pex_reset_n                 ; // 传到从cpld
wire                                        usb_ponrst_r_n              ; // 不使用
wire                                        usb_perst_r_n               ; // 不使用

// PCIE复位信号输入, 滤波后输出给cpu_por_n使用
wire                                        db_i_cpu0_rst_vpp_i2c_n             ;     
wire                                        db_i_cpu1_rst_vpp_i2c_n             ; 
wire                                        db_i_cpu0_d0_cru_rst_ok             ;    
wire                                        db_i_cpu0_d1_cru_rst_ok             ;    
wire                                        db_i_cpu1_d0_cru_rst_ok             ;    
wire                                        db_i_cpu1_d1_cru_rst_ok             ;
wire                                        db_i_cpu0_d0_pcie_rst               ;       
wire                                        db_i_cpu1_d0_pcie_rst               ;      
wire                                        db_i_cpu0_d1_pcie_rst               ;      
wire                                        db_i_cpu1_d1_pcie_rst               ;
wire                                        db_i_cpu0_d0_peu_prest_0_n_r        ;
wire                                        db_i_cpu0_d0_peu_prest_1_n_r        ; 
wire                                        db_i_cpu0_d0_peu_prest_2_n_r        ; 
wire                                        db_i_cpu0_d0_peu_prest_3_n_r        ; 
wire                                        db_i_cpu0_d1_peu_prest_0_n_r        ;
wire                                        db_i_cpu0_d1_peu_prest_1_n_r        ;
wire                                        db_i_cpu0_d1_peu_prest_2_n_r        ;
wire                                        db_i_cpu0_d1_peu_prest_3_n_r        ;
wire                                        db_i_cpu1_d0_peu_prest_0_n_r        ;   
wire                                        db_i_cpu1_d0_peu_prest_1_n_r        ; 
wire                                        db_i_cpu1_d0_peu_prest_2_n_r        ; 
wire                                        db_i_cpu1_d0_peu_prest_3_n_r        ; 
wire                                        db_i_cpu1_d1_peu_prest_0_n_r        ;
wire                                        db_i_cpu1_d1_peu_prest_1_n_r        ;
wire                                        db_i_cpu1_d1_peu_prest_2_n_r        ;
wire                                        db_i_cpu1_d1_peu_prest_3_n_r        ;

wire                                        db_i_cpu_peu_prest_n_r              ;
wire                                        cpu_por_n                           ;


// 电源模块PG状态输入信号
wire                                        db_i_pal_ocp1_pwrgd                 ;//  不使用
wire                                        db_i_pal_dimm_efuse_pg              ;//  不使用
wire [`NUM_PSU-1:0]                         db_ps_acok                          ;
wire [`NUM_PSU-1:0]                         db_ps_dcok                          ;
wire                                        db_i_pal_cpu1_dimm_pwrgd_f          ;// 不使用
wire                                        db_i_pal_p3v3_stby_bp_pgd           ;// 
wire                                        db_i_pal_cpu0_dimm_pwrgd_f          ;// 不使用
wire                                        db_i_pal_p3v3_stby_pgd              ;//  
wire                                        db_i_pal_fan_efuse_pg               ;//  不使用
wire                                        db_i_pal_bp2_aux_pg                 ;// 
wire                                        db_i_pal_bp1_aux_pg                 ;// 
wire                                        db_i_pal_p12v_fan3_pg               ;// 
wire                                        db_i_pal_p12v_fan2_pg               ;// 
wire                                        db_i_pal_p12v_fan1_pg               ;// 
wire                                        db_i_pal_p12v_fan0_pg               ;// 

wire                                        db_i_pal_pgd_88se9230_p1v8          ;// 写死为1
wire                                        db_i_pal_pgd_88se9230_vdd1v0        ;// 写死为1
wire                                        db_i_p1v8_stby_cpld_pg              ;// 写死为1

wire                                        db_i_pal_p5v_stby_pgd               ;// 

wire                                        db_i_pal_pgd_p12v_stby_droop        ;// 
wire                                        db_i_pal_pgd_p12v_droop             ;// 
wire                                        db_i_pal_front_bp_efuse_pg          ;// 
wire                                        db_i_pal_reat_bp_efuse_pg  		    ;// 

wire                                        db_i_pal_p5v0_pgd                    ;//  

wire                                        db_i_pal_vcc_1v1_pg                 ;// 新增

wire                                        db_i_pal_cpu1_vdd_core_pg           ;//    
wire                                        db_i_pal_cpu0_vdd_core_pg           ;// 

wire                                        db_i_pal_cpu1_p1v8_pg               ;// 
wire                                        db_i_pal_cpu0_p1v8_pg  		        ;//  

wire                                        db_i_pal_cpu1_vddq_pg               ;// 
wire                                        db_i_pal_cpu0_vddq_pg			    ;//  	
wire                                        db_i_pal_cpu1_ddr_vdd_pg            ;// 
wire                                        db_i_pal_cpu0_ddr_vdd_pg  		    ;// 
wire                                        db_i_pal_cpu1_pll_p1v8_pg           ;//         
wire                                        db_i_pal_cpu0_pll_p1v8_pg			;// 

wire                                        db_i_pal_cpu0_pcie_p1v8_pg  		;//  不使用       	
wire                                        db_i_pal_cpu1_pcie_p1v8_pg 	        ;//  不使用           			
wire                                        db_i_pal_cpu0_pcie_p0v9_pg          ;//  不使用    
wire                                        db_i_pal_cpu1_pcie_p0v9_pg          ;//  不使用

wire                                        db_i_pal_cpu0_d0_vp_0v9_pg          ;//
wire                                        db_i_pal_cpu0_d1_vp_0v9_pg          ;//
wire                                        db_i_pal_cpu0_d0_vph_1v8_pg         ;//
wire                                        db_i_pal_cpu0_d1_vph_1v8_pg         ;//
wire                                        db_i_pal_cpu1_d0_vp_0v9_pg          ;//
wire                                        db_i_pal_cpu1_d1_vp_0v9_pg          ;//
wire                                        db_i_pal_cpu1_d0_vph_1v8_pg         ;//
wire                                        db_i_pal_cpu1_d1_vph_1v8_pg         ;//

// 电源故障检测信号
wire                                        any_aux_vrm_fault                 ;
wire [`NUM_CPU-1:0]                         cpu_thermtrip_fault_det           ;

wire                                        db_i_dimm_sns_alert               ;
wire                                        db_i_fan_sns_alert                ;
wire                                        db_i_p12v_stby_sns_alert          ;



wire                                        p5v_stby_fault_det                ;
wire                                        p3v3_stby_fault_det               ;
wire                                        p3v3_stby_bp_fault_det            ;
wire                                        p12v_fan_efuse_fault_det          ;
wire                                        p12v_dimm_efuse_fault_det         ;
wire                                        main_efuse_fault_det              ;

wire                                        p12v_front_bp_efuse_fault_det     ;
wire                                        p12v_reat_bp_efuse_fault_det      ;       
wire                                        p12v_fault_det                    ;
wire                                        p12v_stby_droop_fault_det         ;

wire                                        p5v_fault_det                     ;
wire                                        p3v3_fault_det                    ;
wire                                        vcc_1v1_fault_det                 ;  

wire                                        cpu0_vdd_core_fault_det           ;
wire                                        cpu1_vdd_core_fault_det           ;

wire                                        cpu0_p1v8_fault_det               ;
wire                                        cpu1_p1v8_fault_det               ;

wire                                        cpu1_vddq_fault_det               ;
wire                                        cpu0_vddq_fault_det               ;
wire                                        cpu0_ddr_vdd_fault_det            ;
wire                                        cpu1_ddr_vdd_fault_det            ;
wire                                        cpu0_pll_p1v8_fault_det           ;
wire                                        cpu1_pll_p1v8_fault_det           ;
              
wire                                        cpu1_pcie_p1v8_fault_det          ;// 不使用
wire                                        cpu0_pcie_p1v8_fault_det          ;// 不使用
wire                                        cpu1_pcie_p0v9_fault_det          ;// 不使用 
wire                                        cpu0_pcie_p0v9_fault_det          ;// 不使用 

wire                                        cpu0_d0_vp_0v9_fault_det          ;//
wire                                        cpu0_d1_vp_0v9_fault_det          ;//
wire                                        cpu0_d0_vph_1v8_fault_det         ;//
wire                                        cpu0_d1_vph_1v8_fault_det         ;//
wire                                        cpu1_d0_vp_0v9_fault_det          ;//
wire                                        cpu1_d1_vp_0v9_fault_det          ;//
wire                                        cpu1_d0_vph_1v8_fault_det         ;//
wire                                        cpu1_d1_vph_1v8_fault_det         ;//

wire                                        riser4_2_pwr_fault_det            ;// 未使用
wire                                        riser4_1_pwr_fault_det            ;// 未使用
wire                                        riser3_2_pwr_fault_det            ;// 未使用
wire                                        riser3_1_pwr_fault_det            ;// 未使用
wire                                        riser2_pwr_fault_det              ;// 未使用
wire                                        riser1_pwr_fault_det              ;// 未使用
wire                                        ft_cpu0_rst_ok                    ;// 未使用
wire                                        ft_cpu1_rst_ok                    ;// 未使用
wire                                        ft_cpu_rst_ok                     ;// 未使用

wire                                        db_i_ps1_dc_ok                    ;// ps dc_ok 后释放CPU_VR的RST
wire                                        db_i_ps2_dc_ok                    ;// ps dc_ok 后释放CPU_VR的RST

wire [5:0]                                  power_seq_sm                      ;
wire [5:0]                                  pwrseq_sm_fault_det               ;

wire [`NUM_FAN-1:0]                         db_fan_prsnt_n                    ;
wire                                        db_ocp_prsnt_n                    ;
wire                                        fan1_install_n                    ;
wire                                        fan2_install_n                    ;
wire                                        fan3_install_n                    ;
wire                                        fan4_install_n                    ;
wire                                        fan5_install_n                    ;
wire                                        fan6_install_n                    ;
wire                                        fan7_install_n                    ;
wire                                        fan8_install_n                    ;
wire                                        ocp_prsent_b0_n                   ;
wire                                        ocp_prsent_b1_n                   ;
wire                                        ocp_prsent_b2_n                   ;
wire                                        ocp_prsent_b3_n                   ;
wire                                        ocp_prsent_b4_n                   ;
wire                                        ocp_prsent_b5_n                   ;
wire                                        ocp_prsent_b6_n                   ;
wire                                        ocp_prsent_b7_n                   ;
wire                                        db_ocp1_prsnt_n                   ;
wire                                        db_ocp2_prsnt_n                   ;
wire                                        ocp1_prsnt_n                      ;
wire                                        ocp2_prsnt_n                      ;
wire                                        emc_alert_n                       ;
wire                                        db_i_ps1_smb_alert                ;
wire                                        db_i_ps2_smb_alert                ;

wire [7:0]                                  fan_tach1_byte2                   ;
wire [7:0]                                  fan_tach1_byte1                   ;
wire [7:0]                                  fan_tach2_byte2                   ;
wire [7:0]                                  fan_tach2_byte1                   ;
wire [7:0]                                  fan_tach3_byte2                   ;
wire [7:0]                                  fan_tach3_byte1                   ;
wire [7:0]                                  fan_tach4_byte2                   ;
wire [7:0]                                  fan_tach4_byte1                   ;
wire [7:0]                                  fan_tach5_byte2                   ;
wire [7:0]                                  fan_tach5_byte1                   ;
wire [7:0]                                  fan_tach6_byte2                   ;
wire [7:0]                                  fan_tach6_byte1                   ;
wire [7:0]                                  fan_tach7_byte2                   ;
wire [7:0]                                  fan_tach7_byte1                   ;
wire [7:0]                                  fan_tach8_byte2                   ;
wire [7:0]                                  fan_tach8_byte1                   ;
wire [7:0]                                  fan_tach9_byte2                   ;
wire [7:0]                                  fan_tach9_byte1                   ;
wire [7:0]                                  fan_tach10_byte2                  ;
wire [7:0]                                  fan_tach10_byte1                  ;
wire [7:0]                                  fan_tach11_byte2                  ;
wire [7:0]                                  fan_tach11_byte1                  ;
wire [7:0]                                  fan_tach12_byte2                  ;
wire [7:0]                                  fan_tach12_byte1                  ;
wire [7:0]                                  fan_tach13_byte2                  ;
wire [7:0]                                  fan_tach13_byte1                  ;
wire [7:0]                                  fan_tach14_byte2                  ;
wire [7:0]                                  fan_tach14_byte1                  ;
wire [7:0]                                  fan_tach15_byte2                  ;
wire [7:0]                                  fan_tach15_byte1                  ;
wire [7:0]                                  fan_tach16_byte2                  ;
wire [7:0]                                  fan_tach16_byte1                  ;

wire db_cpu_nvme17_prsnt_n;
wire db_cpu_nvme16_prsnt_n;
wire db_cpu_nvme15_prsnt_n;
wire db_cpu_nvme14_prsnt_n;
wire db_cpu_nvme13_prsnt_n;
wire db_cpu_nvme12_prsnt_n;
wire db_cpu_nvme11_prsnt_n;
wire db_cpu_nvme10_prsnt_n;
wire db_cpu_nvme19_prsnt_n;
wire db_cpu_nvme18_prsnt_n;
wire db_cpu_nvme23_prsnt_n;
wire db_cpu_nvme22_prsnt_n;
wire db_cpu_nvme7_prsnt_n ;
wire db_cpu_nvme6_prsnt_n ;
wire db_cpu_nvme5_prsnt_n ;
wire db_cpu_nvme4_prsnt_n ;
wire db_cpu_nvme3_prsnt_n ;
wire db_cpu_nvme2_prsnt_n ;
wire db_cpu_nvme1_prsnt_n ;
wire db_cpu_nvme0_prsnt_n ;
wire db_cpu_nvme9_prsnt_n ;
wire db_cpu_nvme8_prsnt_n ;
wire db_cpu_nvme25_prsnt_n;
wire db_cpu_nvme24_prsnt_n;
wire cpu_nvme17_prsnt_n;
wire cpu_nvme16_prsnt_n;
wire cpu_nvme15_prsnt_n;
wire cpu_nvme14_prsnt_n;
wire cpu_nvme13_prsnt_n;
wire cpu_nvme12_prsnt_n;
wire cpu_nvme11_prsnt_n;
wire cpu_nvme10_prsnt_n;
wire cpu_nvme19_prsnt_n;
wire cpu_nvme18_prsnt_n;
wire cpu_nvme23_prsnt_n;
wire cpu_nvme22_prsnt_n;
wire cpu_nvme7_prsnt_n ;
wire cpu_nvme6_prsnt_n ;
wire cpu_nvme5_prsnt_n ;
wire cpu_nvme4_prsnt_n ;
wire cpu_nvme3_prsnt_n ;
wire cpu_nvme2_prsnt_n ;
wire cpu_nvme1_prsnt_n ;
wire cpu_nvme0_prsnt_n ;
wire cpu_nvme9_prsnt_n ;
wire cpu_nvme8_prsnt_n ;
wire cpu_nvme25_prsnt_n;
wire cpu_nvme24_prsnt_n;

wire db_sys_sw_in_n;
wire db_i_front_pal_intruder;
wire debug_sw1;
wire debug_sw2;
wire debug_sw3;
wire debug_sw4;
wire debug_sw5;
wire debug_sw6;
wire debug_sw7;
wire debug_sw8;
wire [7:0] cpld_jtag_sel;
wire uid_led_hold;
wire uid_led_force_on;
wire bmc_uid_update;
wire db_i_pal_uid_sw_in_n;
wire uid_led_out;
wire led_uid;
wire pf_blink_code;
wire ocp_led;
wire pal_led_nic_act;
wire uid_led_state;
wire ilo_hard_reset;
wire ilo_rstreq_n;
wire vwire_bmc_nmi;
wire vwire_bmc_wakeup;
wire vwire_bmc_sysrst;
wire s_bmc_sysrst_n;
wire vwire_bmc_shutdown;
wire s_bmc_shutdown;
wire db_pal_ext_rst_n;
wire rst_btn_mask;
wire bmc_ctrl_shutdown;
wire aux_pcycle;
wire efuse_power_cycle;
wire pwrbtn_bl_mask;
wire vwire_pwrbtn_bl;
wire pwrcap_en;
wire pwron_denied;
wire power_wake_r_n;
wire wol_en;
wire [1:0] sideband_sel;
wire rom_mux_bios_bmc_en;
wire rom_mux_bios_bmc_sel;
wire rom_bios_ma_rst;
wire rom_bios_bk_rst;
wire rom_bmc_bk_rst;
wire rom_bmc_ma_rst;
wire bmc_eeprom_wp;
wire bios_eeprom_wp;
wire cpld_rst_bmc;
wire power_fault;
wire db_gmt_fail_n;
wire sys_hlth_grn_blink_n;
wire sys_hlth_red_blink_n;
wire hsb_fail_n;
wire st_reset_state;
wire st_off_standby;
wire st_steady_pwrok;
wire st_halt_power_cycle;
wire st_aux_fail_recovery;
wire dc_on_wait_complete;
wire rt_critical_fail_store;
wire fault_clear;
wire pch_sys_reset;
wire pch_sys_reset_n;
wire rst_bmc_n;
wire [`NUM_IO-1:0] rst_io_n;
wire [`NUM_PSU-1:0] xr_ps_enable;
wire [`NUM_PSU-1:0] db_ps_prsnt_n;
// wire [`NUM_PSU-1:0] db_ps_acok;
// wire [`NUM_PSU-1:0] db_ps_dcok;
wire [`NUM_PSU-1:0] ps_on_dly_n;
wire [`NUM_PSU-1:0] ps_on_n;
wire [`NUM_PSU-1:0] ps_fail;
wire [7:0] hd_bp_fault_det;
wire ps_caution;
wire ps_critical;
wire brownout_warning;
wire brownout_fault;
wire db_emc_alert_n;
wire pwrbtn_mask;
wire s_bmc_wakeup_n;
wire interlock_broken;
wire cpu_thermtrip;
wire [`NUM_CPU-1:0]cpu_thermtrip_event;
wire [`NUM_CPU-1:0]cpu_thermtrip_fault;
wire pch_pwrbtn;
wire pch_thrmtrip;
wire force_pwrbtn_n;
wire pch_thermtrip_flag;
wire cpu_off_flag;
wire reboot_flag;
wire pgd_raw;
wire pgd_so_far;
wire turn_system_on;
wire any_pwr_fault_det;
wire any_lim_recov_fault;
wire any_non_recov_fault;

wire [`NUM_PSU-1:0] mismatched_ps;
wire s_cpu_rst_pcie_n;
wire vwire_cpu_rst_pcie;
wire db_i_pal_lcd_card_in;
wire ifist_prsnt_n;
wire [7:0] bios_post_code;
wire [7:0] post_led_n;
wire vga2_dis;
wire [`NUM_PSU-1:0] s_ps_smb_alert_n;
wire [`NUM_CPU-1:0] qual_cpu_vr_hot_n;
wire [`NUM_CPU-1:0] mem_abcd_hot_alert;
wire [`NUM_CPU-1:0] mem_efgh_hot_alert;
wire [`NUM_CPU-1:0] cpu_mem_abcd_forcepr;
wire [`NUM_CPU-1:0] cpu_mem_efgh_forcepr;
wire pwrcap_wait;
wire turn_on_wait;
wire keep_alive_on_fault;
wire pal_pwrbtn_grn_led;
wire pal_pwrbtn_amb_led;
wire ebrake;
wire db_vr_hot_n;
wire all_emc_alert_n;
wire emc_alert_mask;
wire riser1_tmp_alert_n;
wire riser2_tmp_alert_n;
wire riser1_emc_alert_mask;
wire riser2_emc_alert_mask;
wire db_riser1_tmp_alert_n;
wire db_riser2_tmp_alert_n;
wire pal_riser1_prsnt_n;
wire pal_riser2_prsnt_n;
wire db_pal_riser1_prsnt_n;
wire db_pal_riser2_prsnt_n;
wire ocp_temp_alert_mask  ;
wire sensor_thermtrip;
wire pal_m2_1_sel_r;
wire pal_m2_1_prsnt_n;
wire pal_m2_0_prsnt_n;
wire front_m2_card_prsnt;
wire [7:0] db_debug_sw;
wire [7:0] bmc_i2c_rst;
wire [7:0] bmc_i2c_rst2;
wire [7:0] bmc_i2c_rst3;
wire rst_i2c0_mux_n;
wire rst_i2c3_mux_n;
wire rst_i2c13_mux_n;
wire rst_i2c1_mux_n;
wire rst_i2c4_2_mux_n;
wire rst_i2c8_mux_n;
wire rst_i2c2_mux_n;
wire rst_i2c5_mux_n;
wire rst_i2c12_mux_n;
wire rst_i2c11_mux_n;
wire rst_i2c4_1_mux_n;
wire rst_i2c10_mux_n;
wire rst_i2c_riser1_pca9548_n;
wire rst_i2c_riser2_pca9548_n;
wire pal_lcd_busy;
wire pal_lcd_prsnt;
wire tpm_pp;
wire tpm_rst;
wire tpm_prsnt_n;
wire db_tpm_prsnt_n;
wire db_i_intruder_cable_inst_n;
// wire db_i_pal_cpu1_dimm_pwrgd_f;
wire [`NUM_CPU-1:0] s_vr_cpu_i2c_alert_n;
wire db_i_pal_ocp1_fan_prsnt_n;
wire db_i_pal_bmc_card_prsnt_n;
wire db_i_pal_cpu0_dimm_pwrgd_f;
wire rst_pal_extrst_r_n;
wire db_i_pal_bmcuid_button_r;
wire bmc_extrst_uid;
wire test_bat_en;
wire i_pal_wdt_rst_n_r;
wire [1:0]bmcctl_uart_sw;
wire fan_dbg_mode;
wire [15:0] mb_cpld2_ver;

wire [7:0]i2c_ram_1050;
wire [7:0]i2c_ram_1051;
wire [7:0]i2c_ram_1052;
wire [7:0]i2c_ram_1053;
wire [7:0]i2c_ram_1054;
wire [7:0]i2c_ram_1055;
wire [7:0]i2c_ram_1056;
wire [7:0]i2c_ram_1057;
wire [7:0]i2c_ram_1058;

wire pca_revision_0;
wire pca_revision_1;
wire pca_revision_2;
wire pcb_revision_0;
wire pcb_revision_1;
wire [15:0]bmc_cpld_version;
wire [2:0] db_chassis_id;
wire [2:0] chassis_id;
wire [1:0] mb_class_id;
wire [3:0] led_custom_mode;
wire mb_t1hz_clk;
wire board_id5;
wire board_id6;
wire board_id7;
wire power_on_off;
wire [7:0] pf_class0_b0;
wire [7:0] pf_class0_b1;
wire [7:0] pf_class0_b2;
wire [7:0] pf_class0_b3;
wire [7:0] pf_class1_b0;
wire [7:0] pf_class1_b1;
wire [7:0] pf_class2_b0;
wire [7:0] pf_class2_b1;
wire [7:0] pf_class4_b0;
wire [7:0] pf_class5_b0;
wire [7:0] pf_class6_b0;
wire [7:0] pf_class9_b0;
wire [7:0] pf_classa_b0;



wire bmc_security_bypass;
wire bios_security_bypass;
wire bmc_read_flag;
wire bmc_read_flag_1;
wire [39:0]pfr_to_led;
wire [7:0]led_class_date1;
wire [7:0]led_class_date2;
wire [7:0]led_class_date3;
wire [7:0]led_class_date4;
wire [7:0]led_class_date5;

wire [7:0]s_ocp_act_n;
wire [7:0]s_ocp_link_n;
wire [7:0]s_ocp2_act_n;
wire [7:0]s_ocp2_link_n;
wire  ocp2_pvt_link_spdb_p5_n;       
wire  ocp2_pvt_act_p5_n;             
wire  ocp2_pvt_link_spda_p6_n;      
wire  ocp2_pvt_link_spdb_p6_n;       
wire  ocp2_pvt_act_p6_n;             
wire  ocp2_pvt_link_spda_p7_n;      
wire  ocp2_pvt_link_spdb_p7_n;       
wire  ocp2_pvt_act_p7_n;             
wire  ocp2_pvt_act_p2_n;             
wire  ocp2_pvt_link_spda_p3_n;       
wire  ocp2_pvt_link_spdb_p3_n;       
wire  ocp2_pvt_act_p3_n;             
wire  ocp2_pvt_link_spda_p4_n;       
wire  ocp2_pvt_link_spdb_p4_n;       
wire  ocp2_pvt_act_p4_n;             
wire  ocp2_pvt_link_spda_p5_n;       
wire  ocp2_pvt_link_spda_p0_n;       
wire  ocp2_pvt_link_spdb_p0_n;       
wire  ocp2_pvt_act_p0_n;             
wire  ocp2_pvt_link_spda_p1_n;       
wire  ocp2_pvt_link_spdb_p1_n;       
wire  ocp2_pvt_act_p1_n;             
wire  ocp2_pvt_link_spda_p2_n;       
wire  ocp2_pvt_link_spdb_p2_n;       
wire  ocp2_pvt_prsntb0_n;            
wire  ocp2_pvt_prsntb1_n;            
wire  ocp2_pvt_prsntb2_n;            
wire  ocp2_pvt_prsntb3_n;           
wire  ocp2_pvt_wake_n;               
wire  ocp2_pvt_temp_warn_n;         
wire  ocp2_pvt_temp_crit_n;          
wire  ocp2_pvt_fan_on_aux;           
wire  ocp_pvt_link_spdb_p5_n;        
wire  ocp_pvt_act_p5_n;              
wire  ocp_pvt_link_spda_p6_n;        
wire  ocp_pvt_link_spdb_p6_n;        
wire  ocp_pvt_act_p6_n;              
wire  ocp_pvt_link_spda_p7_n;        
wire  ocp_pvt_link_spdb_p7_n;       
wire  ocp_pvt_act_p7_n;              
wire  ocp_pvt_act_p2_n;              
wire  ocp_pvt_link_spda_p3_n;        
wire  ocp_pvt_link_spdb_p3_n;        
wire  ocp_pvt_act_p3_n;              
wire  ocp_pvt_link_spda_p4_n;        
wire  ocp_pvt_link_spdb_p4_n;        
wire  ocp_pvt_act_p4_n;              
wire  ocp_pvt_link_spda_p5_n;        
wire  ocp_pvt_link_spda_p0_n;        
wire  ocp_pvt_link_spdb_p0_n;        
wire  ocp_pvt_act_p0_n;              
wire  ocp_pvt_link_spda_p1_n;        
wire  ocp_pvt_link_spdb_p1_n;        
wire  ocp_pvt_act_p1_n;              
wire  ocp_pvt_link_spda_p2_n;        
wire  ocp_pvt_link_spdb_p2_n;        
wire  ocp_pvt_prsntb0_n;             
wire  ocp_pvt_prsntb1_n;             
wire  ocp_pvt_prsntb2_n;             
wire  ocp_pvt_prsntb3_n;             
wire  ocp_pvt_wake_n;               
wire  ocp_pvt_temp_warn_n;           
wire  ocp_pvt_temp_crit_n;           
wire  ocp_pvt_fan_on_aux;
wire db_ocp_pvt_fan_on_aux;
wire db_ocp2_pvt_fan_on_aux;
wire pal_ocp1_ncsi_en;
wire pal_ocp2_ncsi_en;
wire pal_ocp_ncsi_sw_en;

wire auxint; 
wire pme_event;
wire pfr_pe_wake_n;     
wire db_pme_source_all;
wire dsd_uart_prsnt_n;
wire db_i_dsd_uart_prsnt_n;
wire db_i_leakage_prsnt_n;
wire db_i_break_det_do_n;
wire db_i_leakage_det_do_n;
wire db_i_pal_ocp1_fan_foo;
wire db_i_pal_ocp2_fan_foo;
wire db_i_pal_ocp2_fan_prsnt_n;
wire pal_gpu_fan1_foo;
wire pal_gpu_fan2_foo;
wire pal_gpu_fan3_foo;
wire pal_gpu_fan4_foo;
wire pal_gpu_fan4_prsnt;
wire pal_gpu_fan3_prsnt;
wire pal_gpu_fan2_prsnt;
wire pal_gpu_fan1_prsnt;
wire lom_thermal_trip;
wire lom_prsnt_n;
wire cpu0_temp_over;
wire cpu1_temp_over;
wire bmc_pgd_p0v8_stby;
wire bmc_pgd_p1v1_stby;
wire bmc_pgd_p1v2_stby;
wire bmc_pgd_p1v8_stby;
wire bmc_pgd_p3v3_stby;
wire bmc_ready_flag;
wire w_sys_healthy_red;
wire w_sys_healthy_grn;

wire bmcctl_front_nic_led;
wire nic_led_bmc_ctl;
wire pfr_vpp_alert;
wire usb3_right_ear_en;
wire usb2_left_ear_en;
wire rtc_select_n;
wire cpu1_vr_select_n;
wire cpu0_vr_select_n;
wire [`NUM_NIC-1:0] ocp_fault_det1;
wire [`NUM_NIC-1:0] ocp_fault_det2;
//wire db_i_pal_usb_upd2_oci1b;
wire db_i_pal_usb_upd2_oci2b;
//wire db_i_pal_usb_upd1_oci4b;
wire pal_upd72020_1_alart;
wire pal_upd72020_2_alart;
wire vga2_oc_alert;
wire usb2_lcd_alert;
wire db_pal_upd72020_1_alart;
wire db_pal_upd72020_2_alart;
wire db_vga2_oc_alert;
wire db_usb2_lcd_alert;
wire pgd_p1v8_stby_dly32ms;
wire pgd_p1v8_stby_dly30ms;
wire bios_read_flag;
wire machine_rev;
wire [7:0] bios_post_rate;
wire [7:0] bios_post_phase;

wire [3:0] bmc_card_type;
wire [2:0] bmc_card_pcb_rev;
wire [7:0] riser1_pvti_byte3;
wire [7:0] riser1_pvti_byte2;
wire [7:0] riser1_pvti_byte1;
wire [7:0] riser1_pvti_byte0;
wire [7:0] riser2_pvti_byte3;
wire [7:0] riser2_pvti_byte2;
wire [7:0] riser2_pvti_byte1;
wire [7:0] riser2_pvti_byte0;
wire riser1_cb_prsnt_slot1_n;
wire riser1_cb_prsnt_slot2_n;
wire riser1_cb_prsnt_slot3_n;
wire riser1_pwr_det0;
wire riser1_pwr_det1;
wire riser1_pcb_rev0;
wire riser1_pcb_rev1;
wire riser1_pwr_alert_n;
wire riser1_emc_alert_n;
wire riser1_slot1_prsnt_n;
wire riser1_slot2_prsnt_n;
wire riser1_slot3_prsnt_n;
wire [5:0]riser1_id;
wire pal_riser1_pwrgd;
wire pal_riser1_pe_wake_n;
wire riser2_cb_prsnt_slot1_n;
wire riser2_cb_prsnt_slot2_n;
wire riser2_cb_prsnt_slot3_n;
wire riser2_pwr_det0;
wire riser2_pwr_det1;
wire riser2_pcb_rev0;
wire riser2_pcb_rev1;
wire riser2_pwr_alert_n;
wire riser2_emc_alert_n;
wire riser2_slot1_prsnt_n;
wire riser2_slot2_prsnt_n;
wire riser2_slot3_prsnt_n;
wire [5:0]riser2_id;
wire pal_riser2_pwrgd;
wire pal_riser2_pe_wake_n;
wire [3:0]riser2_pwr_cable_prsnt_n;
wire [3:0]riser1_pwr_cable_prsnt_n;
wire w4GpuRiser2Flag;
wire w4GpuRiser1Flag;
wire riser3_slot7_prsnt_n;
wire riser3_slot8_prsnt_n;
wire riser4_slot9_prsnt_n;
wire riser4_slot10_prsnt_n;
wire riser3_1_prsnt_n;
wire riser3_2_prsnt_n;
wire riser4_1_prsnt_n;
wire riser4_2_prsnt_n;

wire riser4_2_pwr_en;
wire riser4_1_pwr_en;
wire riser3_2_pwr_en;
wire riser3_1_pwr_en;
wire riser2_pwr_en;
wire riser1_pwr_en;

wire [5:0]riser3_slot7_id;
wire [5:0]riser3_slot8_id;
wire [5:0]riser4_slot9_id;
wire [5:0]riser4_slot10_id;

wire db_riser_prsnt_det_2;
wire db_riser_prsnt_det_3;
wire db_riser_prsnt_det_0;
wire db_riser_prsnt_det_1;
wire db_i_riser_prsnt_det_9;
wire db_i_riser_prsnt_det_8;
wire db_riser_prsnt_det_6;
wire db_riser_prsnt_det_7;
wire db_riser_prsnt_det_4;
wire db_riser_prsnt_det_5;
wire db_i_riser_prsnt_det_11;
wire db_i_riser_prsnt_det_10;
wire [7:0] db_bp_aux_pg;
wire [7:0] bp_int;
wire [7:0] bp_power_good;
wire [7:0] bp_prsnt;
wire [31:0] AUX_BP_type;
wire [127:0] pcie_detect;
wire [7:0] pcie_detect_int;

wire [15:0] o_mb_cb_prsnt_bmc;
wire [7:0] debug_reg_15;
wire [15:0] mb_cb_prsnt;
wire [19:0] riser_ocp_m2_slot_number;//0x30[7:0],0x31[7:0],0x32[2:0]
wire [43:0] nvme_slot_number;        //0x37[6:0],0x36[7:0],0x35[7:0],0x34[7:0],0x33[7:0],0x32[7:3]


wire gmt_fail_n = 1'b1;
//d00412 end

/*-----------------------------------------------------------------------------------------------------------------------------------------------
系统时钟: input 25MHz, output 100MHz/50MHz/25MHz
------------------------------------------------------------------------------------------------------------------------------------------------*/
pll_i25M_o50M_o25M pll_inst (
    .clkin1                                 (i_CLK_PAL_IN_25M           ), // input 25.0000MHz
    .rst                                    (~i_PAL_P3V3_STBY_PGD       ), // input
    .clkout0                                (clk_50m                    ), // output 50.00000000MHz
    .clkout1                                (sys_clk                    ), // output 25.00000000MHz
    .lock                                   (pll_lock                   )  // output

);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
全局复位 
------------------------------------------------------------------------------------------------------------------------------------------------*/
pon_reset pon_reset_inst( 
    .clk                                    (sys_clk                    ),// input:  复位/PGD 同步时钟源（25MHz）
    .pll_lock                               (pll_lock                   ),// input:  仅在 PLL 锁定后才允许释放复位
    .pgd_p3v3_stby                          (i_PAL_P3V3_STBY_PGD        ),// input:  待机 3.3V 电源良好指示（PGD）
    .pgd_aux_gmt                            (pgd_aux_bmc                ),// input:  来自 BMC 的 AUX PGD 原始输入
    .done_booting                           (1'b1                       ),// input:  系统就绪输入：此处常置 1，表示无需等待外部就绪
    .done_booting_delayed                   (done_booting_delayed       ),// output: 系统就绪延迟版，供时序控制/监控
    .pon_reset_n                            (pon_reset_n                ),// output: 全局复位（低有效，不考虑pdg_aux_bmc）
    .pon_reset_db_n                         (pon_reset_db_n             ),// output: 全局复位（低有效, 考虑pdg_aux_bmc）
    .pgd_aux_system                         (pgd_aux_system             ),// output: 系统域 AUX PGD（稳定）
    .pgd_aux_system_sasd                    (pgd_aux_system_sasd        ),// output: 系统域 AUX PGD（稳定）
    .cpld_ready                             (cpld_ready                 ) // output：CPLD 就绪指示（低有效）
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
时钟树
------------------------------------------------------------------------------------------------------------------------------------------------*/
timer_gen timer_gen_inst(
    .clk                                    (sys_clk                    ),
    .reset                                  (~pon_reset_n               ),
    .t40ns                                  (t40ns_tick                 ),
    .t80ns                                  (t80ns_tick                 ),
    .t160ns                                 (t160ns_tick                ),
    .t1us                                   (t1us_tick                  ),
    .t2us                                   (t2us_tick                  ),
    .t8us                                   (t8us_tick                  ),
    .t16us                                  (t16us_tick                 ),
    .t32us                                  (t32us_tick                 ),
    .t128us                                 (t128us_tick                ),
    .t512us                                 (t512us_tick                ),
    .t1ms                                   (t1ms_tick                  ),
    .t2ms                                   (t2ms_tick                  ),
    .t16ms                                  (t16ms_tick                 ),
    .t32ms                                  (t32ms_tick                 ),
    .t64ms                                  (t64ms_tick                 ),
    .t128ms                                 (t128ms_tick                ),
    .t256ms                                 (t256ms_tick                ),
    .t512ms                                 (t512ms_tick                ),
    .t1s                                    (t1s_tick                   ),
    .t8s                                    (t8s_tick                   ),
    .clk_0p5hz                              (t0p5hz_clk	                ),
    .clk_1hz                                (t1hz_clk                   ),
    .clk_2p5hz                              (t2p5hz_clk                 ),
    .clk_4hz                                (t4hz_clk                   ),
    .clk_16khz                              (t16khz_clk                 ),
    .clk_6m25                               (t6m25_clk                  )
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
输入信号消抖
------------------------------------------------------------------------------------------------------------------------------------------------*/
PGM_DEBOUNCE #(.SIGCNT(15), .NBITS(2'b10), .ENABLE(1'b1)) db_inst_button (
    .clk(clk_100m),
    .rst(~pon_reset_n),
    .timer_tick(t64ms_tick),
    .din ({
         i_CPLD_M_S_EXCHANGE_S2_R | pwrbtn_mask   ,//01 
         // i_FRONT_PAL_INTRUDER                     ,//02
         debug_sw1                                ,//03
         debug_sw2                                ,//04
         debug_sw3                                ,//05
         debug_sw4	                              ,//06
         debug_sw5	                              ,//07
		 debug_sw6                                ,//08
		 debug_sw7                                ,//09
		 debug_sw8                                ,//10
		 /*i_PAL_UID_SW_IN_N & */i_PAL_BMCUID_BUTTON_R,//11
		 //i_PAL_BMCUID_BUTTON_R                  ,//12
		 //chassis_id0_n                          ,//13
		 //chassis_id1_n                          ,//14
		 //chassis_id2_n                          ,//15
		 //i_PAL_USB_UPD2_OCI1B                   ,//16
		 i_PAL_USB_UPD2_OCI2B                     ,//17
		 //i_PAL_USB_UPD1_OCI4B                     ,//18
		 pal_upd72020_1_alart                     ,//19 // 不使用
		 pal_upd72020_2_alart                     ,//20 // 不使用
		 vga2_oc_alert                            ,//21
		 usb2_lcd_alert                            //22
    }),                           
    .dout({
         db_sys_sw_in_n                           ,//01 
         // db_i_front_pal_intruder                  ,//02
		 db_debug_sw[0]                           ,//03
		 db_debug_sw[1]                           ,//04
		 db_debug_sw[2]                           ,//05
		 db_debug_sw[3]                           ,//06
		 db_debug_sw[4]                           ,//07
		 db_debug_sw[5]                           ,//08
		 db_debug_sw[6]                           ,//09
		 db_debug_sw[7]                           ,//10
		 db_i_pal_uid_sw_in_n                     ,//11
		 //db_i_pal_bmcuid_button_r                 ,//12
		 //db_chassis_id[0]                         ,//13
		 //db_chassis_id[1]                         ,//14
		 //db_chassis_id[2]                         ,//15
		 //db_i_pal_usb_upd2_oci1b                  ,//16
		 db_i_pal_usb_upd2_oci2b                  ,//17
		 //db_i_pal_usb_upd1_oci4b                  ,//18
		 db_pal_upd72020_1_alart                  ,//19
		 db_pal_upd72020_2_alart                  ,//20
		 db_vga2_oc_alert                         ,//21
		 db_usb2_lcd_alert                         //22                    
  })             
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
PG信号信号消抖
------------------------------------------------------------------------------------------------------------------------------------------------*/
// 未使用的信号列表：
wire  i_PAL_CPU0_PCIE_P1V8_PG = 1'b1;
wire  i_PAL_CPU1_PCIE_P1V8_PG = 1'b1;
wire  i_PAL_CPU0_PCIE_P0V9_PG = 1'b1;
wire  i_PAL_CPU1_PCIE_P0V9_PG = 1'b1;
wire  i_PAL_FAN_EFUSE_PG      = 1'b1;
wire  i_PAL_FRONT_BP_EFUSE_PG = 1'b1;
wire  i_PAL_OCP1_PWRGD        = 1'b1;
wire  i_PAL_DIMM_EFUSE_PG     = 1'b1;
wire  i_PAL_P5V_PGD           = 1'b1;
PGM_DEBOUNCE #(
    .SIGCNT                                 (49                         ), 
    .NBITS                                  (2'b11                      ), 
    .ENABLE                                 (1'b1                       )
) db_inst_cpu_rail (
    .clk                                    (sys_clk                    ),
    .rst                                    (~pon_reset_n               ),
    .timer_tick                             (1'b1                       ),
    .din                                    (
                                            {
                                            i_PAL_CPU0_D0_VP_0V9_PG             ,// 48
                                            i_PAL_CPU0_D1_VP_0V9_PG             ,// 47
                                            i_PAL_CPU0_D0_VPH_1V8_PG            ,// 46
                                            i_PAL_CPU0_D1_VPH_1V8_PG            ,// 45
                                            i_PAL_CPU1_D0_VP_0V9_PG             ,// 44
                                            i_PAL_CPU1_D1_VP_0V9_PG             ,// 43
                                            i_PAL_CPU1_D0_VPH_1V8_PG            ,// 42
                                            i_PAL_CPU1_D1_VPH_1V8_PG            ,// 41
                                            i_PAL_BP2_AUX_PG                    ,// 40
                                            i_PAL_BP1_AUX_PG                    ,// 39
                                            i_PAL_P12V_FAN3_PG                  ,// 38
                                            i_PAL_P12V_FAN2_PG                  ,// 37
                                            i_PAL_P12V_FAN1_PG                  ,// 36
                                            i_PAL_P12V_FAN0_PG                  ,// 35
                                            i_PAL_VCC_1V1_PG                    ,// 34
                                            i_PAL_FRONT_BP_EFUSE_PG             ,// 33 不使用                               
                                            i_PAL_CPU1_VDD_VCORE_P0V8_PG        ,// 32                            
                                            i_PAL_CPU0_PLL_P1V8_PG              ,// 31                            
                                            i_PAL_CPU0_VDDQ_P1V1_PG 		    ,// 30 	                        
                                            i_PAL_CPU0_P1V8_PG   			    ,// 29          
                                            i_PAL_CPU0_DDR_VDD_PG   			,// 28         
                                            i_PAL_REAT_BP_EFUSE_PG   			,// 27        
                                            i_PAL_CPU0_PCIE_P1V8_PG             ,// 26 不使用       
                                            i_PAL_CPU1_PCIE_P1V8_PG             ,// 25 不使用       
                                            i_PAL_CPU0_PCIE_P0V9_PG   		    ,// 24 不使用        
                                            i_PAL_CPU1_PCIE_P0V9_PG             ,// 23 不使用
    	                                    i_PAL_FAN_EFUSE_PG                  ,// 22 不使用
    	                                    i_PAL_CPU1_DDR_VDD_PG               ,// 21
    	                                    i_PAL_CPU0_VDD_VCORE_P0V8_PG        ,// 20
    	                                    i_PAL_CPU1_VDDQ_P1V1_PG             ,// 19
    	                                    i_PAL_CPU1_P1V8_PG                  ,// 18
    	                                    i_PAL_CPU1_PLL_P1V8_PG              ,// 17
                                            i_PAL_P5V_STBY_PGD                  ,// 16
                                            i_PAL_OCP1_PWRGD                    ,// 15 不使用
                                            i_PAL_DIMM_EFUSE_PG                 ,// 14 不使用
                                            i_PAL_P5V_PGD                       ,// 13 不使用
                                            i_PAL_PGD_P12V_STBY_DROOP           ,// 12
    	                                    i_PAL_PGD_P12V_DROOP                ,// 11
                                            i_PAL_PS1_ACFAIL & i_PAL_PS1_PRSNT  ,// 10
    	                                    i_PAL_PS2_ACFAIL & i_PAL_PS2_PRSNT  ,// 09
    	                                    ~i_PAL_PS1_DCOK  & i_PAL_PS1_PRSNT  ,// 08
    	                                    ~i_PAL_PS2_DCOK  & i_PAL_PS2_PRSNT  ,// 07
                                            i_PAL_CPU1_DIMM_PWRGD_F             ,// 06
    	                                    i_PAL_P3V3_STBY_PGD                 ,// 05
                                            i_PAL_PGD_88SE9230_VDD1V0           ,// 04
                                            i_PAL_PGD_88SE9230_P1V8             ,// 03
                                            i_PAL_CPU0_DIMM_PWRGD_F             ,// 02
                                            i_P1V8_STBY_CPLD_PG                 ,// 01              
    	                                    i_PAL_P3V3_STBY_PGD                  // 00 
                                            }
                                            ),
    .dout                                   (
                                            {
                                            db_i_pal_cpu0_d0_vp_0v9_pg          ,// 48
                                            db_i_pal_cpu0_d1_vp_0v9_pg          ,// 47
                                            db_i_pal_cpu0_d0_vph_1v8_pg         ,// 46
                                            db_i_pal_cpu0_d1_vph_1v8_pg         ,// 45
                                            db_i_pal_cpu1_d0_vp_0v9_pg          ,// 44
                                            db_i_pal_cpu1_d1_vp_0v9_pg          ,// 43
                                            db_i_pal_cpu1_d0_vph_1v8_pg         ,// 42
                                            db_i_pal_cpu1_d1_vph_1v8_pg         ,// 41                             
                                            db_i_pal_bp2_aux_pg                 ,// 40
                                            db_i_pal_bp1_aux_pg                 ,// 39
                                            db_i_pal_p12v_fan3_pg               ,// 38
                                            db_i_pal_p12v_fan2_pg               ,// 37
                                            db_i_pal_p12v_fan1_pg               ,// 36
                                            db_i_pal_p12v_fan0_pg               ,// 35
                                            db_i_pal_vcc_1v1_pg                 ,// 34
                                            db_i_pal_front_bp_efuse_pg          ,// 33 不使用    
                                            db_i_pal_cpu1_vdd_core_pg           ,// 32           
                                            db_i_pal_cpu0_pll_p1v8_pg			,// 31                                               
                                            db_i_pal_cpu0_vddq_pg			    ,// 30 	         
                                            db_i_pal_cpu0_p1v8_pg  		        ,// 29                             			
                                            db_i_pal_cpu0_ddr_vdd_pg  		    ,// 28         
                                            db_i_pal_reat_bp_efuse_pg  		    ,// 27        
                                            db_i_pal_cpu0_pcie_p1v8_pg  		,// 26 不使用       	
                                            db_i_pal_cpu1_pcie_p1v8_pg 	        ,// 25 不使用           			
                                            db_i_pal_cpu0_pcie_p0v9_pg          ,// 24 不使用    
                                            db_i_pal_cpu1_pcie_p0v9_pg          ,// 23 不使用
                                            db_i_pal_fan_efuse_pg               ,// 22 
		                                    db_i_pal_cpu1_ddr_vdd_pg            ,// 21
		                                    db_i_pal_cpu0_vdd_core_pg           ,// 20
		                                    db_i_pal_cpu1_vddq_pg               ,// 19
		                                    db_i_pal_cpu1_p1v8_pg               ,// 18
		                                    db_i_pal_cpu1_pll_p1v8_pg           ,// 17
		                                    db_i_pal_p5v_stby_pgd               ,// 16
		                                    db_i_pal_ocp1_pwrgd                 ,// 15 不使用
		                                    db_i_pal_dimm_efuse_pg              ,// 14 不使用
		                                    db_i_pal_p5v0_pgd                    ,// 13 不使用
		                                    db_i_pal_pgd_p12v_stby_droop        ,// 12
		                                    db_i_pal_pgd_p12v_droop             ,// 11
		                                    db_ps_acok[0]                       ,// 10
		                                    db_ps_acok[1]                       ,// 09
		                                    db_ps_dcok[0]                       ,// 08
		                                    db_ps_dcok[1]                       ,// 07
		                                    db_i_pal_cpu1_dimm_pwrgd_f          ,// 06
		                                    db_i_pal_p3v3_stby_bp_pgd           ,// 05
		                                    db_i_pal_pgd_88se9230_vdd1v0        ,// 04
		                                    db_i_pal_pgd_88se9230_p1v8          ,// 03
		                                    db_i_pal_cpu0_dimm_pwrgd_f          ,// 02
		                                    db_i_p1v8_stby_cpld_pg              ,// 01           
		                                    db_i_pal_p3v3_stby_pgd               // 00 
		                                    })		 
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
BP PG信号信号消抖
------------------------------------------------------------------------------------------------------------------------------------------------*/


// CPU 反馈的复位信号, PEU_PREST控制状态机跳转, 其他写入寄存器监控使用
PGM_DEBOUNCE #(
    .SIGCNT                                 (26                         ), 
    .NBITS                                  (2'b11                      ), 
    .ENABLE                                 (1'b1                       )
) db_inst_cpu_rail (
    .clk                                    (sys_clk                    ),
    .rst                                    (~pon_reset_n               ),
    .timer_tick                             (1'b1                       ),
    .din                                    (
                                            {
                                            i_CPU0_RST_VPP_I2C_N           ,// 25   
                                            i_CPU1_RST_VPP_I2C_N           ,// 24
                                            i_CPU0_D0_CRU_RST_OK           ,// 23      
                                            i_CPU0_D1_CRU_RST_OK           ,// 22      
                                            i_CPU1_D0_CRU_RST_OK           ,// 21      
                                            i_CPU1_D1_CRU_RST_OK           ,// 20 
                                            i_CPU0_D0_PCIE_RST             ,// 19       
                                            i_CPU1_D0_PCIE_RST             ,// 18       
                                            i_CPU0_D1_PCIE_RST             ,// 17     
                                            i_CPU1_D1_PCIE_RST             ,// 16
                                            i_CPU1_D1_PEU_PREST_3_N_R      ,// 15
                                            i_CPU1_D1_PEU_PREST_2_N_R      ,// 14
                                            i_CPU1_D1_PEU_PREST_1_N_R      ,// 13
                                            i_CPU1_D1_PEU_PREST_0_N_R      ,// 12
                                            i_CPU1_D0_PEU_PREST_3_N_R      ,// 11
                                            i_CPU1_D0_PEU_PREST_2_N_R      ,// 10
                                            i_CPU1_D0_PEU_PREST_1_N_R      ,// 09
                                            i_CPU1_D0_PEU_PREST_0_N_R      ,// 08
                                            i_CPU0_D1_PEU_PREST_3_N_R      ,// 07
                                            i_CPU0_D1_PEU_PREST_2_N_R      ,// 06
                                            i_CPU0_D1_PEU_PREST_1_N_R      ,// 05
                                            i_CPU0_D1_PEU_PREST_0_N_R      ,// 04
                                            i_CPU0_D0_PEU_PREST_3_N_R      ,// 03
                                            i_CPU0_D0_PEU_PREST_2_N_R      ,// 02
                                            i_CPU0_D0_PEU_PREST_1_N_R      ,// 01
                                            i_CPU0_D0_PEU_PREST_0_N_R       // 00
                                            }
                                            ),
    .dout                                   (
                                            {
                                            db_i_cpu0_rst_vpp_i2c_n        ,// 25     
                                            db_i_cpu1_rst_vpp_i2c_n        ,// 24 
                                            db_i_cpu0_d0_cru_rst_ok        ,// 23    
                                            db_i_cpu0_d1_cru_rst_ok        ,// 22    
                                            db_i_cpu1_d0_cru_rst_ok        ,// 21    
                                            db_i_cpu1_d1_cru_rst_ok        ,// 20
                                            db_i_cpu0_d0_pcie_rst          ,// 19       
                                            db_i_cpu1_d0_pcie_rst          ,// 18      
                                            db_i_cpu0_d1_pcie_rst          ,// 17      
                                            db_i_cpu1_d1_pcie_rst          ,// 16
                                            db_i_cpu0_d0_peu_prest_0_n_r   ,// 15
                                            db_i_cpu0_d0_peu_prest_1_n_r   ,// 14 
                                            db_i_cpu0_d0_peu_prest_2_n_r   ,// 13 
                                            db_i_cpu0_d0_peu_prest_3_n_r   ,// 12 
                                            db_i_cpu0_d1_peu_prest_0_n_r   ,// 11
                                            db_i_cpu0_d1_peu_prest_1_n_r   ,// 10
                                            db_i_cpu0_d1_peu_prest_2_n_r   ,// 09
                                            db_i_cpu0_d1_peu_prest_3_n_r   ,// 08
                                            db_i_cpu1_d0_peu_prest_0_n_r   ,// 07   
                                            db_i_cpu1_d0_peu_prest_1_n_r   ,// 06 
                                            db_i_cpu1_d0_peu_prest_2_n_r   ,// 05 
                                            db_i_cpu1_d0_peu_prest_3_n_r   ,// 04 
                                            db_i_cpu1_d1_peu_prest_0_n_r   ,// 03
                                            db_i_cpu1_d1_peu_prest_1_n_r   ,// 02
                                            db_i_cpu1_d1_peu_prest_2_n_r   ,// 01
                                            db_i_cpu1_d1_peu_prest_3_n_r    // 00
                                            }
                                            )
);



// PSU DCOK 信号消抖
PGM_DEBOUNCE #(.SIGCNT(2), .NBITS(2'b10), .ENABLE(1'b1)) db_inst_psu (
  .clk                                      (clk_100m               ),
  .rst                                      (~pon_reset_n           ),
  .timer_tick                               (t64ms_tick             ),
  .din                                      ({
	                                         i_PAL_PS1_DCOK          ,//01
		                                     i_PAL_PS2_DCOK           //02
                                            }),             
    .dout                                   ({
                                             db_i_ps1_dc_ok          ,//01    
                                             db_i_ps2_dc_ok           //02 
                                            }) 
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
CPU 重启
------------------------------------------------------------------------------------------------------------------------------------------------*/
reg                         cpu_reboot                      ; // CPU 重启信号
reg                         cpu_reboot_S                    ; 
reg                         cpu_reboot_x                    ;  
reg                         cpu_power_off                   ;
wire                        cpu_gpio_ok                     ;
wire                        cpu_rb_flag                     ;
wire                        cpu_po_flag                     ;

// PWR_CRT0/PWR_CRT1 控制 CPU 的reboot和power_on
assign cpu_rb_flag = ((~i_CPU0_D0_PWR_CTR0_R) & i_CPU0_D0_PWR_CTR1_R) ;
assign cpu_po_flag = ((~i_CPU0_D0_PWR_CTR1_R) & i_CPU0_D0_PWR_CTR0_R) ; 

edge_delay #(.CNTR_NBITS(4), .DEF_OUTPUT(1'b0), .DELAY_MODE(1'b0)) edge_delay_cpu_gpio_ok (
    .clk                    (sys_clk                            ),
    .reset                  (~pgd_aux_system                    ),
    .cnt_size               (4'b1000                            ),
    .cnt_step               (t1s_tick                           ),
    .signal_in              (reached_sm_wait_powerok            ),
    .delay_output           (cpu_gpio_ok                        )
);

always@(posedge sys_clk or negedge pgd_aux_system) begin 
    if(!pgd_aux_system) begin
        cpu_reboot      <= 1'b1;
        cpu_power_off   <= 1'b1;
    end
    else begin
        if(cpu_gpio_ok & cpu_po_flag)begin
    	    cpu_reboot      <= 1'b1 ;
            cpu_power_off   <= 1'b0 ;
        end 
        else if(cpu_gpio_ok & cpu_rb_flag) begin
        	cpu_reboot      <= 1'b0;
            cpu_power_off   <= 1'b0;
        end 
        else begin
            cpu_reboot      <= 1'b1;
            cpu_power_off   <= 1'b1;
        end	
    end  
end

reg                     singal_s0                           ;
reg                     singal_s1                           ;
wire                    singal_n                            ;
reg                     force_reb                           ;
reg [29:0]              count                               ;
reg [29:0]              counts                              ;



always @(posedge sys_clk or negedge pgd_aux_system) begin
    if(!pgd_aux_system) begin
        singal_s0   <= 1'b1;
        singal_s1   <= 1'b1;
    end
    else begin
        singal_s0   <= cpu_reboot & pch_sys_reset_n;          
        singal_s1   <= singal_s0                   ;
    end
end

assign singal_n = !singal_s0 & singal_s1;

always @(posedge sys_clk or negedge pgd_aux_system) begin
    if(!pgd_aux_system)begin
        counts          <= 30'b0;
        cpu_reboot_x    <= 1'b1 ;
    end
    else if(singal_n==1'b1) begin
        counts          <=30'b1;
        cpu_reboot_x    <=1'b1;
    end
    else if ((counts>=30'b1)&&(counts<=30'd75000000))begin
        cpu_reboot_x    <=1'b1;
        counts          <=counts+1;
    end
    else if((counts<=30'd75001000)&&(counts>=30'd75000001))begin
        cpu_reboot_x    <=1'b0;
        counts          <=counts+1;
    end
    else if(counts>=30'd75001001)begin
        cpu_reboot_x    <=1'b1 ;
        counts          <=30'b0;
    end
    else begin
        counts          <=30'b0;
        cpu_reboot_x    <=1'b1 ;             
    end
end

always @(posedge sys_clk or negedge pgd_aux_system)begin
    if(!pgd_aux_system) begin
        count           <= 30'b0;
        cpu_reboot_S    <=1'b1;
    end 
    else if( singal_n==1'b1)begin
        count           <=30'b1;
        cpu_reboot_S    <=1'b1;
    end
    else if ((count>=30'b1)&&(count<=30'd225000000))begin
        cpu_reboot_S    <=1'b1;
        count           <=count+1;
    end
    else if((count<=30'd225001000)&&(count>=30'd225000001))begin
        cpu_reboot_S    <=1'b0;
        count           <=count+1;
    end
    else if(count>=30'd225001001)begin
        cpu_reboot_S    <=1'b1;
        count           <=30'b0;
    end
    else begin
        count           <=30'b0;
        cpu_reboot_S    <=1'b1 ;             
    end
end


//SW
reg [29:0]countp;

reg singal_p0;
reg singal_p1;

wire  singal_p;

  reg  pch_pwrbtn_s;

always @(negedge pgd_aux_system or posedge i_CLK_PAL_IN_25M)
begin
  if(!pgd_aux_system) 
           begin
                   singal_p0<= 1'b1;
                   singal_p1 <= 1'b1;
           end
  else 
    begin
                   singal_p0<=  (~pch_pwrbtn) | (~st_halt_power_cycle);
                   singal_p1 <= singal_p0;
         end
end

assign singal_p=  !singal_p0&singal_p1;



always @(negedge pgd_aux_system or posedge i_CLK_PAL_IN_25M)
begin
         if(!pgd_aux_system) 
                   begin
                            countp <= 30'b0;
                            pch_pwrbtn_s<=1'b1;
                   end
         
         else if ( singal_p==1'b1)//��⵽�½���
                   begin
                            countp<=30'b1;
                            pch_pwrbtn_s<=1'b1;
                   end
         else if ((countp>=30'b1)&&(countp<=30'd500000000))//��ʼ������������3s
                   begin
                            pch_pwrbtn_s<=1'b1;
                            countp<=countp+1;
                   end
         else if((countp<=30'd500001000)&&(countp>=30'd500000001))//cpu_reboot_S��ʼ����͵�ƽ
                   begin
                            pch_pwrbtn_s<=1'b0;
                            countp<=countp+1;
                   end
         else if(countp>=30'd501001001)//��ʱһ��ʱ������
                   begin
                            pch_pwrbtn_s<=1'b1;
                            countp<=30'b0;
                   end
         else
                   begin
                            countp<=30'b0;
                            pch_pwrbtn_s<=1'b1 ;             
                   end
end




/*-----------------------------------------------------------------------------------------------------------------------------------------------
上下电模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                        db_sys_sw_in_n              ;
wire                                        pch_pwrbtn                  ;   
wire                                        pch_pwrbtn_s                ;

wire                                        pch_thrmtrip                ;
wire                                        force_pwrbtn_n              ;

wire                                        cpu_reboot_S                ; 
wire                                        cpu_reboot_x                ; 
wire                                        cpu_power_off               ; 

wire                                        keep_alive_on_fault         ;
wire                                        pgd_raw                     ;

wire                                        pgd_so_far                  ;     
wire                                        any_pwr_fault_det           ;     
wire                                        any_lim_recov_fault         ;     
wire                                        any_non_recov_fault         ;     
wire                                        dc_on_wait_complete         ;    
wire                                        rt_critical_fail_store      ;     
wire                                        fault_clear                 ;     

wire                                        pch_thermtrip_flag          ;
wire                                        cpu_off_flag                ;
wire                                        reboot_flag                 ;
wire                                        power_wake_r_n              ;
wire                                        pch_sys_reset_n             ;
wire                                        turn_system_on              ;

wire                                        power_fault                 ; 
wire                                        stby_failure_detected       ; 
wire                                        dc_failure_detected         ; 
wire                                        rt_failure_detected         ; 
wire                                        cpld_latch_sys_off          ; 
wire                                        turn_on_wait                ; 

// 上下电 master
pwrseq_master #(
    .LIM_RECOV_MAX_RETRY_ATTEMPT            (2                          ),
    .WDT_NBITS                              (10                         ),

    .P3V3_VCC_WATCHDOG_TIOMEOUT_VAL         (2                          ),
    .PON_WATCHDOG_TIMEOUT_VAL               (256                        ),
    .PSU_WATCHDOG_TIMEOUT_VAL               (10                         ),
    .EFUSE_WATCHDOG_TIMEOUT_VAL             (137                        ),
    .PCH_WATCHDOG_TIMEOUT_VAL               (256                        ),
    .DSW_PWROK_TIMEOUT_VAL                  (75                         ),
    .PON_65MS_WATCHDOG_TIMEOUT_VAL          (2                          ),
    
    .VCORE_WATCHDOG_TIMEOUT_VAL             (PON_WATCHDOG_TIMEOUT_VAL   ),
    .PDN_WATCHDOG_TIMEOUT_VAL               (2                          ),
    .PDN_WATCHDOG_TIMEOUT_FAULT_VAL         (PDN_WATCHDOG_TIMEOUT_VAL   ),
    .DISABLE_INTEL_VCCIN_TIMEOUT_VAL        (PDN_WATCHDOG_TIMEOUT_VAL   ),
    .DISABLE_INTEL_VCCIN_TIMEOUT_FAULT_VAL  (PDN_WATCHDOG_TIMEOUT_VAL   ),
    .DISABLE_3V3_TIMEOUT_VAL                (34                         ),
    .DISABLE_3V3_TIMEOUT_FAULT_VAL          (17                         ),

    .PF_ON_WAIT_COMPLETE_VAL                (4                          ),
    .PO_ON_WAIT_COMPLETE_VAL                (0                          ),

    .S5_DEVICES_ON_WAIT_COMPLETE_NOFLT_VAL  (75                         ),
    .S5_DEVICES_ON_WAIT_COMPLETE_FAULT_VAL  (6                          ),
    
    .DC_ON_WAIT_COMPLETE_NOFLT_VAL          (33                         ),
    .DC_ON_WAIT_COMPLETE_FAULT_VAL          (1                          )
) pwrseq_master_inst (
    // -----------------------------------------------------------
    // 1. 时钟与复位接口（模块时序基准与初始化）
    // -----------------------------------------------------------
    .clk                                    (sys_clk                    ), // 输入：50MHz 工作时钟（模块内部时序逻辑的基准，如状态机跳转、计数器计时）
    .reset                                  (~pon_reset_n               ), // 输入：模块复位信号（高电平有效）
    // .cmu_fault_clear_rst		            (~pon_reset_n               ), // 输入：CMU（电源管理芯片）故障清除复位信号

    // -----------------------------------------------------------
    // 2. 定时脉冲接口（模块内部时序控制与计时基准）
    // -----------------------------------------------------------
    .t1us                                   (t1us_tick                  ),
    .t512us                                 (t512us_tick                ),
    .t256ms                                 (t256ms_tick                ),
    .t512ms                                 (t512ms_tick                ),
    .sequence_tick                          (t2ms_tick                  ),
    .psu_on_tick                            (t32ms_tick                 ), 

    // -----------------------------------------------------------
    // 3. 物理按键信号; 南桥状态和控制信息; 
    // -----------------------------------------------------------
    .sys_sw_in_n                            (db_sys_sw_in_n             ),
    // .pch_slp4_n                             (pch_slp4_n                 ),
    .pch_pwrbtn_n                           (~pch_pwrbtn                ),
    .pch_pwrbtn_s                           (pch_pwrbtn_s               ),
    
    .pch_thermtrip_n                        (~pch_thrmtrip              ), // 输入：PCH 热跳闸信号（低电平有效，1=无过热，0=CPU 过热触发下电）
    .force_pwrbtn_n                         (force_pwrbtn_n             ), // 输出：强制电源按钮信号（低电平有效，送至 PSU，当前未使用）
                                                                           // 备用功能：故障下电后，强制 PCH 切换到 S5 状态，确保彻底断电

    .cpu_reboot                             (cpu_reboot_S               ), // 输入：CPU重启 YHY  ADD  
    .cpu_reboot_x                           (cpu_reboot_x               ), // 输入：CPU重启 YHY  ADD   
    .cpu_power_off                          (cpu_power_off              ), // 输入：CPU下电 YHY  ADD  
    
    .xr_ps_en                               (1'b1                       ), // 输入：XR 电源使能信号（1=使能，0=禁用）

    .allow_recovery                         (1'b0                       ), // 输入：允许故障恢复信号（1=允许自动恢复，0=禁止）
                                                                           // 功能：此处固定为 0：故障后不自动重试，需人工或 BMC 干预，避免反复故障
    .keep_alive_on_fault                    (keep_alive_on_fault        ), // 输入：故障时保持上电信号（来自前文定义，控制故障后是否下电）

    .pgd_raw                                (pgd_raw                    ), // 输出：原始电源好信号（送至电源按钮指示灯，当前未使用）
                                                                           // 备用功能：指示灯显示电源好状态，方便现场排查

    // -----------------------------------------------------------
    // 4. 电源S5上电控制 来自? BMC or PWR_SEQ_SLAVE ?
    // -----------------------------------------------------------                                                              
    .s5dev_pwren_request                    (1'b0                       ), // 输入：S5 状态设备上电请求信号（来自电源请求从模块 pwrseq_slave）
                                                                           // 功能：S5 休眠状态下，外部设备（如 BMC）请求上电时触发该信号
    .s5dev_pwrdis_request                   (1'b0                       ), // 输入：S5 状态设备断电请求信号（来自 pwrweq_slave）
                                                                           // 功能：S5 状态下，外部设备请求断电时触发该信号

    // -----------------------------------------------------------
    // 5. pwrseq_slave模块接口
    // -----------------------------------------------------------  
    .pgd_so_far                             (pgd_so_far                 ),// 输入：电源好（PGD）累积信号（来自 pwrweq_slave）
                                                                          // 功能：汇总所有子模块的电源好信号，用于判断整体电源是否稳定  
    .any_pwr_fault_det                      (any_pwr_fault_det          ),// 输入：任意电源故障检测信号（来自 pwrweq_slave）
                                                                          // 功能：检测到任一子模块电源故障时为 1，触发主模块故障处理 
    .any_lim_recov_fault                    (any_lim_recov_fault        ),// 输入：任意有限恢复故障信号（来自 pwrweq_slave）
                                                                          // 功能：轻微故障（如电压波动），可通过重试恢复   
    .any_non_recov_fault                    (any_non_recov_fault        ),// 输入：任意非恢复故障信号（来自 pwrweq_slave）
                                                                          // 功能：严重故障（如电源短路），无法恢复，需立即下电 
    .dc_on_wait_complete                    (dc_on_wait_complete        ),// 输出：DC 电源上电等待完成信号（送至电源序列从模块 slave）
                                                                          // 功能：告知从模块“主模块已完成 DC 上电等待，可执行后续步骤”
    .rt_critical_fail_store                 (rt_critical_fail_store     ),// 输出：RT 关键故障存储信号（送至从模块/复位模块）
                                                                          // 功能：存储关键故障信息，用于故障复位后追溯原因
    .fault_clear                            (fault_clear                ),// 输出：故障清除信号（送至从模块/PSU/热管理模块）
                                                                          // 功能：BMC 或人工清除故障后，该信号触发下游模块清除故障标志
    .power_seq_sm                           (power_seq_sm               ),// 输出：电源序列状态机信号（核心输出，告知所有模块当前电源阶段）
                                                                          // 常见状态：上电初始化、电源升压、电源稳定、下电等

    // -----------------------------------------------------------
    // 6. 电源上下电接口
    // ----------------------------------------------------------- 
    // POWER_OFF_FLAG
    .pch_thermtrip_FLAG                     (pch_thermtrip_flag         ), // 输出：南桥过热
                                                                           // 功能：过热下电
    .CPU_OFF_FLAG                           (cpu_off_flag               ), // 输出：CPU下电
                                                                           // 功能：CPU下电
    .REBOOT_FLAG                            (reboot_flag                ), // 输出：CPU重启
                                                                           // 功能：CPU重启 
    .Power_WAKE_R_N                         (power_wake_r_n             ), // 输入：CPU输入的wake信号
                                                                           // 功能：上电退出s5
    .pch_sys_reset_n                        (pch_sys_reset_n            ), // 输入：南桥复位       YHY  ADD //force_reb & pch_sys_reset_n
                                                                           // 功能：复位下电
    .turn_system_on                         (turn_system_on             ), // 输出：系统开机信号（送至电源序列从模块 slave）
                                                                           // 功能：触发从模块执行系统开机序列
    
    // -----------------------------------------------------------
    // 7. 状态监控
    // ----------------------------------------------------------- 
    .power_fault                            (power_fault                ),// 输出：电源故障信号（送至故障处理模块/指示灯/网卡）
                                                                          // 功能：触发故障指示灯亮、网卡上报故障，告知外部系统电源异常
    .stby_failure_detected                  (stby_failure_detected      ),// 输出：待机故障检测信号（送至故障处理模块）
                                                                          // 功能：检测到待机电源（如 5V_STB）故障时输出 1
    .po_failure_detected                    (dc_failure_detected        ),// 输出：DC 电源故障检测信号（送至故障处理模块）
                                                                          // 功能：检测到 DC 主电源（如 12V/5V）故障时输出 1
    .rt_failure_detected                    (rt_failure_detected        ),// 输出：RT 电源故障检测信号（送至故障处理模块）
                                                                          // 功能：检测到 RT 电源（如 CPU 核心供电）故障时输出 1
    .cpld_latch_sys_off                     (cpld_latch_sys_off         ),// 输出：CPLD 锁存系统关闭信号（送至扩展寄存器 XREG）
                                                                          // 功能：锁存“系统关闭”状态，避免故障恢复时误上电
    .turn_on_wait                           (turn_on_wait               ) // 输出：开机等待信号（送至电源按钮指示灯）
                                                                          // 功能：开机过程中点亮指示灯，告知用户“系统正在上电，请勿操作”
);

// 上下电 slave
assign db_i_cpu_peu_prest_n_r = db_i_cpu0_d0_peu_prest_0_n_r &
                                db_i_cpu0_d0_peu_prest_1_n_r &
                                db_i_cpu0_d0_peu_prest_2_n_r &
                                db_i_cpu0_d0_peu_prest_3_n_r &
                                db_i_cpu0_d1_peu_prest_0_n_r &
                                db_i_cpu0_d1_peu_prest_1_n_r &
                                db_i_cpu0_d1_peu_prest_2_n_r &
                                db_i_cpu0_d1_peu_prest_3_n_r &
                                db_i_cpu1_d0_peu_prest_0_n_r &
                                db_i_cpu1_d0_peu_prest_1_n_r &
                                db_i_cpu1_d0_peu_prest_2_n_r &
                                db_i_cpu1_d0_peu_prest_3_n_r &
                                db_i_cpu1_d1_peu_prest_0_n_r &
                                db_i_cpu1_d1_peu_prest_1_n_r &
                                db_i_cpu1_d1_peu_prest_2_n_r &
                                db_i_cpu1_d1_peu_prest_3_n_r ;

pwrseq_slave #(
    .SHARED_P5V_STBY_HPMOS                  (1'b1                       ),
    .S5DEV_STUCKON_FAULT_CHK                (1'b0                       ),
    .BOUND_SYS_PWROK                        (1'b1                       ),       
    .NUM_CPU                                (`NUM_CPU                   ),
    .NUM_OPT_AUX                            (0                          ),
    .NUM_S5DEV                              (`NUM_S5DEV                 ),
    .NUM_SAS                                (1                          ),
    .NUM_HD_BP                              (8                          ),        //change in 20191212
    .NUM_M2_BP                              (1                          ),
    .NUM_RISER                              (`NUM_RISER                 ),
    //.HPMOS_TYPE(2'b10),
    //.HPMOS_OWNER(4'b0000),
    .FAULT_VEC_SIZE                         (40),
    .RECOV_FAULT_MASK                       (40'b0000_1111_1111_0000_0000_0000_0000_0000_0000_0000),
    .LIM_RECOV_FAULT_MASK                   (40'b0011_0000_0000_1111_1111_1111_1111_1111_1111_1111),
    .NON_RECOV_FAULT_MASK                   (40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000)
) pwrseq_slave_inst (
    .clk                                    (sys_clk                    ),
    .reset                                  (~pon_reset_n               ),
    .t1us                                   (t1us_tick                  ),
    .t512us                                 (t512us_tick                ),
    .t1ms                                   (t1ms_tick                  ),
    .t2ms                                   (t2ms_tick                  ),
    .t64ms                                  (t64ms_tick                 ),
    .t1s                                    (t1s_tick                   ),

    .keep_alive_on_fault                    (keep_alive_on_fault        ),

    // PGOOD 输入信号
    // stby电不受状态机控制
    .p3v3_stby_bp_pg                        (db_i_pal_p3v3_stby_bp_pgd   ),  //in
    .p3v3_stby_pg                           (db_i_pal_p3v3_stby_pgd      ),  //in
    // 2. `SM_EN_5V_STBY 状态上电使能
    .p5v_stby_pgd			                (db_i_pal_p5v_stby_pgd	     ),
    // 4. SM_EN_MAIN_EFUSE 状态上电使能
    .dimm_efuse_pg			                (1'b1 /*db_i_pal_dimm_efuse_pg*/),  
    .fan_efuse_pg			                (db_i_pal_fan_efuse_pg	     ),
    .pgd_main_efuse                         (1'b1                        ),  //in
    .pgd_p12v                               (db_i_pal_pgd_p12v_droop     ),  //in
    .pgd_p12v_stby_droop                    (db_i_pal_pgd_p12v_stby_droop),  //in
    .reat_bp_efuse_pg                       (db_i_pal_reat_bp_efuse_pg   ),
    .front_bp_efuse_pg      	            (db_i_pal_front_bp_efuse_pg  ),
    // 5. SM_EN_5V 状态上电使能
    .p5v_pgd                                (db_i_pal_p5v0_pgd           ),
    // 6. SM_EN_3V3 状态上电使能
    .p3v3_pgd                               (1'b1                        ), 
    // 7. SM_EN_1V1 状态上电使能
    .p1v1_pgd                               (db_i_pal_vcc_1v1_pg         ), 
    // 主电源使能信号
    // 1. SM_EN_VDD 状态上电使能
    .cpu1_vdd_core_pg		                (db_i_pal_cpu1_vdd_core_pg   ),
    .cpu0_vdd_core_pg			            (db_i_pal_cpu0_vdd_core_pg   ),
    // 2. SM_EN_P1V8 状态上电使能
    .cpu1_p1v8_pg		                    (db_i_pal_cpu1_p1v8_pg	     ),
    .cpu0_p1v8_pg		                    (db_i_pal_cpu0_p1v8_pg	     ),
    // 3. SM_EN_P2V5_VPP 状态上电使能
    .cpu1_pll_p1v8_pg		                (db_i_pal_cpu1_pll_p1v8_pg   ),
    .cpu0_pll_p1v8_pg		                (db_i_pal_cpu0_pll_p1v8_pg   ),
    .cpu1_vddq_pg				            (db_i_pal_cpu1_vddq_pg	     ),  
    .cpu0_vddq_pg		                    (db_i_pal_cpu0_vddq_pg	     ),
    .cpu1_ddr_vdd_pg	                    (db_i_pal_cpu1_ddr_vdd_pg	 ),
    .cpu0_ddr_vdd_pg                        (db_i_pal_cpu0_ddr_vdd_pg    ),
    // 4. SM_EN_P0V8 状态上电使能
    .cpu0_pcie_p1v8_pg		                (db_i_pal_cpu0_pcie_p1v8_pg  ),  
    .cpu1_pcie_p1v8_pg		                (db_i_pal_cpu1_pcie_p1v8_pg  ),    
    .cpu0_pcie_p0v9_pg		                (db_i_pal_cpu0_pcie_p0v9_pg  ),
    .cpu1_pcie_p0v9_pg		                (db_i_pal_cpu1_pcie_p0v9_pg  ), 
    .cpu0_d0_vp_0v9_pg                      (db_i_pal_cpu0_d0_vp_0v9_pg  ),
    .cpu0_d1_vp_0v9_pg                      (db_i_pal_cpu0_d1_vp_0v9_pg  ),
    .cpu0_d0_vph_1v8_pg                     (db_i_pal_cpu0_d0_vph_1v8_pg ),
    .cpu0_d1_vph_1v8_pg                     (db_i_pal_cpu0_d1_vph_1v8_pg ),
    .cpu1_d0_vp_0v9_pg                      (db_i_pal_cpu1_d0_vp_0v9_pg  ),
    .cpu1_d1_vp_0v9_pg                      (db_i_pal_cpu1_d1_vp_0v9_pg  ),
    .cpu1_d0_vph_1v8_pg                     (db_i_pal_cpu1_d0_vph_1v8_pg ),
    .cpu1_d1_vph_1v8_pg                     (db_i_pal_cpu1_d1_vph_1v8_pg ),

    // 上电使能信号
    // 1. SM_OFF_STANDBY 状态上电使能
    .ocp_aux_en				                (ocp_aux_en			           ), //out
    .cpu_bios_en                            (cpu_bios_en                   ), //out
    // 2. SM_EN_5V_STBY 状态上电使能
    .p5v_stby_en_r                          (p5v_stby_en_r                 ), //out
    // 3. SM_EN_TELEM 状态上电使能
    .pvcc_hpmos_cpu_en_r                    (pvcc_hpmos_cpu_en_r           ), //out
    // 4. SM_EN_MAIN_EFUSE 状态上电使能
    .power_supply_on                        (power_supply_on               ), //out
    .ocp_main_en				            (ocp_main_en			       ), //out
    .pal_main_efuse_en                      (pal_main_efuse_en             ), //out
    .p12v_bp_front_en                       (p12v_bp_front_en              ), //out
    .p12v_bp_rear_en                        (p12v_bp_rear_en               ), //out
    // 5. SM_EN_5V 状态上电使能
    .p5v_en_r                               (p5v_en_r                      ), //out
    // 6. SM_EN_3V3 状态上电使能
    .p3v3_en_r                              (p3v3_en_r                     ), //out
    // 7. SM_EN_1V1 状态上电使能
    .p1v1_en_r                              (p1v1_en_r                     ), //out

    // 主电源使能信号
    // 1. SM_EN_VDD 状态上电使能
    .cpu0_vdd_core_en_r                     (cpu0_vdd_core_en_r         ),  //out
    .cpu1_vdd_core_en_r                     (cpu1_vdd_core_en_r         ),  //out
    // 2. SM_EN_P1V8 状态上电使能
    .cpu0_p1v8_en_r                         (cpu0_p1v8_en_r             ),  //out
    .cpu1_p1v8_en_r                         (cpu1_p1v8_en_r             ),  //out
    // 3. SM_EN_P2V5_VPP 状态上电使能
    .cpu0_vddq_en_r                         (cpu0_vddq_en_r             ),  //out
    .cpu1_vddq_en_r                         (cpu1_vddq_en_r             ),  //out
    .cpu0_ddr_vdd_en_r                      (cpu0_ddr_vdd_en_r          ),  //out
    .cpu1_ddr_vdd_en_r                      (cpu1_ddr_vdd_en_r          ),  //out
    .cpu0_pll_p1v8_en_r                     (cpu0_pll_p1v8_en_r         ),  //out
    .cpu1_pll_p1v8_en_r                     (cpu1_pll_p1v8_en_r         ),  //out
    // 4. SM_EN_P0V8 状态上电使能
    .cpu0_d0_vp_p0v9_en_r                   (cpu0_d0_vp_p0v9_en_r       ),  //out
    .cpu0_d1_vp_p0v9_en_r                   (cpu0_d1_vp_p0v9_en_r       ),  //out
    .cpu0_d0_vph_p1v8_en_r                  (cpu0_d0_vph_p1v8_en_r      ),  //out
    .cpu0_d1_vph_p1v8_en_r                  (cpu0_d1_vph_p1v8_en_r      ),  //out
    .cpu1_d0_vp_p0v9_en_r                   (cpu1_d0_vp_p0v9_en_r       ),  //out
    .cpu1_d1_vp_p0v9_en_r                   (cpu1_d1_vp_p0v9_en_r       ),  //out
    .cpu1_d0_vph_p1v8_en_r                  (cpu1_d0_vph_p1v8_en_r      ),  //out
    .cpu1_d1_vph_p1v8_en_r                  (cpu1_d1_vph_p1v8_en_r      ),  //out
    
    // 复位信号输出
    .cpu_peu_prest_n_r                      (db_i_cpu_peu_prest_n_r         ),  //in
    .cpu_por_n                              (cpu_por_n                      ),  //out
    .usb_ponrst_r_n                         (usb_ponrst_r_n                 ),  //out 不使用
    .pex_reset_r_n                          (pex_reset_n                    ),  //out 不使用
    
    // 故障检测信号
    .p5v_stby_fault_det		                (p5v_stby_fault_det	            ),
    .p3v3_stby_bp_fault_det                 (p3v3_stby_bp_fault_det         ),//out  
    .main_efuse_fault_det                   (main_efuse_fault_det           ),//out
    .p3v3_stby_fault_det                    (p3v3_stby_fault_det            ),//out
    
    .p12v_front_bp_efuse_fault_det          (p12v_front_bp_efuse_fault_det  ),
    .p12v_reat_bp_efuse_fault_det	        (p12v_reat_bp_efuse_fault_det	),
    .p12v_fan_efuse_fault_det		        (p12v_fan_efuse_fault_det	    ),
    .p12v_dimm_efuse_fault_det              (p12v_dimm_efuse_fault_det	    ),
    .p12v_fault_det                         (p12v_fault_det                 ),//out
    .p12v_stby_droop_fault_det              (p12v_stby_droop_fault_det      ),//out

    .p5v_fault_det		                    (p5v_fault_det	                ),
    .p3v3_fault_det                         (p3v3_fault_det                 ),
    .vcc_1v1_fault_det                      (vcc_1v1_fault_det              ),

    .cpu0_vdd_core_fault_det	            (cpu0_vdd_core_fault_det	    ),
    .cpu1_vdd_core_fault_det	            (cpu1_vdd_core_fault_det	    ),

    .cpu0_p1v8_fault_det		            (cpu0_p1v8_fault_det	        ),
    .cpu1_p1v8_fault_det		            (cpu1_p1v8_fault_det	        ),

    .cpu0_vddq_fault_det		            (cpu0_vddq_fault_det	        ),
    .cpu1_vddq_fault_det		            (cpu1_vddq_fault_det	        ),
    .cpu0_ddr_vdd_fault_det	                (cpu0_ddr_vdd_fault_det	        ),
    .cpu1_ddr_vdd_fault_det	                (cpu1_ddr_vdd_fault_det	        ),
    .cpu0_pll_p1v8_fault_det	            (cpu0_pll_p1v8_fault_det        ),
    .cpu1_pll_p1v8_fault_det	            (cpu1_pll_p1v8_fault_det        ),
              
    .cpu1_pcie_p1v8_fault_det               (cpu1_pcie_p1v8_fault_det       ),// 不使用
    .cpu0_pcie_p1v8_fault_det               (cpu0_pcie_p1v8_fault_det       ),// 不使用
    .cpu1_pcie_p0v9_fault_det               (cpu1_pcie_p0v9_fault_det       ),// 不使用 
    .cpu0_pcie_p0v9_fault_det               (cpu0_pcie_p0v9_fault_det       ),// 不使用 

    .cpu0_d0_vp_0v9_fault_det               (cpu0_d0_vp_0v9_fault_det       ),
    .cpu0_d1_vp_0v9_fault_det               (cpu0_d1_vp_0v9_fault_det       ),
    .cpu0_d0_vph_1v8_fault_det              (cpu0_d0_vph_1v8_fault_det      ),
    .cpu0_d1_vph_1v8_fault_det              (cpu0_d1_vph_1v8_fault_det      ),
    .cpu1_d0_vp_0v9_fault_det               (cpu1_d0_vp_0v9_fault_det       ),
    .cpu1_d1_vp_0v9_fault_det               (cpu1_d1_vp_0v9_fault_det       ),
    .cpu1_d0_vph_1v8_fault_det              (cpu1_d0_vph_1v8_fault_det      ),
    .cpu1_d1_vph_1v8_fault_det              (cpu1_d1_vph_1v8_fault_det      ),

    .pwrseq_sm_fault_det		            (pwrseq_sm_fault_det	        ),
    .cpu_thermtrip_fault_det                (cpu_thermtrip_fault_det        ),
  
    // 其他信号  
    .brownout_warning                       (brownout_warning              ),//FROM PSU

    // CPU 热保护输入及故障输出
    .i_cpu_thermtrip                        (cpu_thermtrip_event           ),// CPU THERMTRIP indicator
    .o_cpu_thermtrip_fault                  (cpu_thermtrip_fault           ),// out 
    
    .pal_efuse_pcycle                       (efuse_power_cycle             ),// out 

    // HDD backplane           
    .hd_bp_prsnt_n                          (bp_prsnt                      ),//drive backplane presence
    .hd_bp_pgd                              (db_bp_aux_pg                  ),//drive backplane pgood
    .hd_bp_fault_det                        (hd_bp_fault_det               ),//drive backplane power fault
    // Riser card
    .riser_prsnt_n                          ({riser4_2_prsnt_n,riser4_1_prsnt_n,riser3_2_prsnt_n,riser3_1_prsnt_n,db_pal_riser2_prsnt_n,db_pal_riser1_prsnt_n}),//in
    .riser_pgd                              ({4'b1111, pal_riser2_pwrgd & riser2_pwr_alert_n, pal_riser1_pwrgd & riser1_pwr_alert_n}),//in
    .riser_fault_det                        ({riser4_2_pwr_fault_det,riser4_1_pwr_fault_det,riser3_2_pwr_fault_det,riser3_1_pwr_fault_det,riser2_pwr_fault_det,riser1_pwr_fault_det}),//in
    .pal_riser_en                           ({riser4_2_pwr_en,riser4_1_pwr_en,riser3_2_pwr_en,riser3_1_pwr_en,riser2_pwr_en,riser1_pwr_en}),//out

    .power_seq_sm                           (power_seq_sm                  ),//in FROM MASTER
    .reached_sm_wait_powerok                (reached_sm_wait_powerok       ),//TO SYSTEM_RESET
   
    .pgd_so_far                             (pgd_so_far                    ),//out,TO MASTER
    .any_pwr_fault_det                      (any_pwr_fault_det             ),//out,TO MASTER
    .any_aux_vrm_fault                      (any_aux_vrm_fault             ),//out
    .any_recov_fault                        (),
    .any_lim_recov_fault                    (any_lim_recov_fault           ),//out,TO MASTER
    .any_non_recov_fault                    (any_non_recov_fault           ),//out,TO MASTER
    .dc_on_wait_complete                    (dc_on_wait_complete           ),//in FROM MASTER
    .rt_critical_fail_store                 (rt_critical_fail_store        ),//in FROM MASTER
    .fault_clear                            (fault_clear                   ),//in FROM MASTER

    .aux_pcycle                             (aux_pcycle                    ) //FROM XREG 
);


//------------------------------------------------------------------------------
// Power button
//------------------------------------------------------------------------------
wire                        pch_pwrbtn                  ; // BMC 控制短按  
wire                        pwrbtn_bl_mask              ; // BMC 控制长按
wire                        vwire_pwrbtn_bl             ; // BMC 控制长按
wire                        db_sys_sw_in_n   
wire                        s_bmc_shutdown   
wire                        s_bmc_wakeup_n   
wire                        cpu_thermtrip              
wire                        interlock_broken 
wire                        st_steady_pwrok  
wire                        st_off_standby   
wire                        pch_pwrbtn       
wire                        pch_thrmtrip     

power_button power_button_inst  (
.clk                        (sys_clk                    ),
.reset                      (~pgd_aux_system            ),
.t1s                        (t1s_tick                   ),
.gpo_pwr_btn_mask           (pwrbtn_mask                ),
.xreg_pwr_btn_passthru      (pwrbtn_bl_mask             ),
.xreg_vir_pwr_btn           (vwire_pwrbtn_bl            ),
.defeat_pwr_btn_dis_n       (1'b0                       ),
.turn_on_override           (1'b0                       ),
.sys_sw_in_n                (db_sys_sw_in_n             ),
.gmt_shutdown               (s_bmc_shutdown             ),
.gmt_wakeup_n               (s_bmc_wakeup_n             ),
.cpu_thermtrip              (cpu_thermtrip              ),
.temp_deadly                (1'b0                       ),
.interlock_broken           (interlock_broken           ),
.st_steady_pwrok            (st_steady_pwrok            ),
.st_off_standby             (st_off_standby             ),
.pch_pwrbtn                 (pch_pwrbtn                 ),
.pch_thrmtrip               (pch_thrmtrip               ) 
);


//------------------------------------------------------------------------------
// PSU 上电逻辑
//------------------------------------------------------------------------------
wire                ps_on_dly_n            ;
wire                ps_fail                ;
wire                ps_critical            ;      
wire                brownout_warning       ;
wire                brownout_fault         ;

psu #(
  .NUM_PSU(`NUM_PSU)
) psu_inst (
  .clk             (sys_clk                ),
  .reset           (~pon_reset_n           ),
  .t1us            (t1us_tick              ),
  .t1ms            (t1ms_tick              ),
  .t1s             (t1s_tick               ),
  .xreg_ps_enable  (xr_ps_enable           ),
  .xreg_ps_mismatch(2'b0                   ),
  .gpo_cpld_rst    (1'b0                   ),
  .power_seq_sm    (power_seq_sm           ),
  .power_supply_on (power_supply_on        ),
  .bad_fuse_det    (1'b0                   ),
  .lom_prsnt_n     (1'b0                   ),
  .lom_fan_on_aux  (1'b0                   ),
  .ps_prsnt_n      (db_ps_prsnt_n          ),
  .ps_acok         (db_ps_acok             ),
  .ps_dcok         (db_ps_dcok             ),
  .pgd_p12v_droop  (db_i_pal_pgd_p12v_droop),
  .ps_on_n         (ps_on_dly_n            ),	
  .ps_cyc_pwr_n    (                       ),
  .ps_acok_link    (                       ),
  .ps_fail         (ps_fail                ),
  .ps_caution      (/*ps_caution*/         ),
  .ps_critical     (ps_critical            ),
  .brownout_warning(brownout_warning       ),
  .brownout_fault  (brownout_fault         )
);

//delay 1s for ps_on_n(fall)
edge_delay #(.CNTR_NBITS(2), .DEF_OUTPUT(1'b1), .DELAY_MODE(1'b0)) edge_delay_ps0_on_n(
  .clk         (sys_clk             ),
  .reset       (~pon_reset_n        ),
  .cnt_size    (2'b10               ),
  .cnt_step    (t512ms_tick         ),
  .signal_in   (ps_on_dly_n[0]      ),
  .delay_output(ps_on_n[0]          )
);

edge_delay #(.CNTR_NBITS(2), .DEF_OUTPUT(1'b1), .DELAY_MODE(1'b0)) edge_delay_ps1_on_n(
  .clk         (sys_clk             ),
  .reset       (~pon_reset_n        ),
  .cnt_size    (2'b10               ),
  .cnt_step    (t512ms_tick         ),
  .signal_in   (ps_on_dly_n[1]      ),
  .delay_output(ps_on_n[1]          )
);

// PS1/PS2 12V使能信号，低电平有效
assign o_PAL_PS1_P12V_ON_R    = ~ps_on_n[0]                     ;
assign o_PAL_PS2_P12V_ON_R    = ~ps_on_n[1]                     ;
assign o_PAL_P12V_DISCHARGE_R = (&ps_on_n[1:0]) ? 1'bz : 1'b0   ;

//------------------------------------------------------------------------------
// 健康灯SYSTEM HEALTHY LED
// CHECKME: Need to validate connections with new top level
//------------------------------------------------------------------------------
reg r_pal_led_hel_red_r;
reg r_pal_led_hel_gr_r ;

always@(posedge sys_clk or negedge pon_reset_n)begin
	if(~pon_reset_n)
	  begin
		r_pal_led_hel_red_r  <= 1'b0;
		r_pal_led_hel_gr_r   <= 1'b0;
	end
	else 
	begin
	case({w_sys_healthy_red,w_sys_healthy_grn}) 		
        2'b00: begin
		    r_pal_led_hel_red_r  <= 1'b0;
		    r_pal_led_hel_gr_r   <= 1'b0;
		end
		2'b01: begin
		    r_pal_led_hel_red_r  <= 1'b0;
		    r_pal_led_hel_gr_r   <= 1'b1;
		end
		2'b10: begin
		    r_pal_led_hel_red_r  <= t1hz_clk;
		    r_pal_led_hel_gr_r   <= 1'b0;
		end
		2'b11: begin
		    r_pal_led_hel_red_r  <= t1hz_clk;
		    r_pal_led_hel_gr_r   <= t1hz_clk;
		end
	default: 	
	begin
	    r_pal_led_hel_red_r  <= 1'b0;
		r_pal_led_hel_gr_r   <= 1'b0;
	end
	endcase
	end
end

assign sys_hlth_red_blink_n = r_pal_led_hel_red_r   ;
assign sys_hlth_grn_blink_n = r_pal_led_hel_gr_r    ;


//PANEL logic
assign o_LED_PWRBTN_GR_R  = (power_seq_sm==SM_STEADY_PWROK) ? 1'b1 : 1'b0                ;
assign o_LED_PWRBTN_AMB_R = (power_seq_sm==SM_STEADY_PWROK) ? 1'b0 : 1'b1                ;

//------------------------------------------------------------------------------
// BACKPLANE logic
// 背板上电辅助信号处理
//------------------------------------------------------------------------------
wire[15:0]w_mb_to_bp_aux1_data;
wire[15:0]w_mb_to_bp_aux2_data;

wire[15:0]w_bp_to_mb_aux1_data;
wire[15:0]w_bp_to_mb_aux2_data;

//bit[7:6] rsv bit5:locate en bit[4:1]:locate bit0:pwr en
wire[5:0]w_aux_rsvd_bit15_10;
wire[1:0]w_mb_type;//mb_type 00:ICX  01:EGS  10:EGS 4U   11:ICX 4U
wire[3:0]w_aux_rsvd_bit7_4;
wire[2:0]w_aux_num_aux1;
wire[2:0]w_aux_num_aux2;

wire w_pal_bp1_pwr_on_r;
wire w_pal_bp2_pwr_on_r;

assign w_aux_rsvd_bit15_10 = 6'b0  ;
assign w_mb_type           = 2'b01 ;
assign w_aux_rsvd_bit7_4   = 4'b0  ;
assign w_aux_num_aux1      = 3'b001;
assign w_aux_num_aux2      = 3'b010;


assign w_pal_bp1_pwr_on_r = db_i_pal_front_bp_efuse_pg | db_i_pal_reat_bp_efuse_pg;
assign w_pal_bp2_pwr_on_r = db_i_pal_front_bp_efuse_pg | db_i_pal_reat_bp_efuse_pg;

assign w_mb_to_bp_aux1_data = {w_aux_rsvd_bit15_10,w_mb_type,w_aux_rsvd_bit7_4,w_aux_num_aux1,w_pal_bp1_pwr_on_r};
assign w_mb_to_bp_aux2_data = {w_aux_rsvd_bit15_10,w_mb_type,w_aux_rsvd_bit7_4,w_aux_num_aux2,w_pal_bp2_pwr_on_r};

assign i2c_ram_1055[0] = (w_bp_to_mb_aux1_data[7:0] == 8'b10011101) ? 1'b0 : 1'b1;//12LTG5
assign i2c_ram_1055[1] = (w_bp_to_mb_aux1_data[7:0] == 8'b00001010) ? 1'b0 : 1'b1;//8+4
assign i2c_ram_1055[2] = (w_bp_to_mb_aux1_data[7:0] == 8'b10011110) ? 1'b0 : 1'b1;//4+8
// assign i2c_ram_1055[3] = (w_bp_to_mb_aux6_data[7:0] == 8'b10000101) ? 1'b0 : 1'b1;//2STG5
// assign i2c_ram_1055[4] = (w_bp_to_mb_aux7_data[7:0] == 8'b10000101) ? 1'b0 : 1'b1;//2STG5
assign i2c_ram_1055[5] = (w_bp_to_mb_aux1_data[7:0] == 8'b10000011) ? 1'b0 : 1'b1;//8SSG3-BP1
assign i2c_ram_1055[6] = (w_bp_to_mb_aux2_data[7:0] == 8'b10000011) ? 1'b0 : 1'b1;//8SSG3-BP2
// assign i2c_ram_1055[7] = (w_bp_to_mb_aux3_data[7:0] == 8'b10000011) ? 1'b0 : 1'b1;//8SSG3-BP3

assign i2c_ram_1056[0] = 1'b1;
assign i2c_ram_1056[1] = 1'b1;
assign i2c_ram_1056[2] = (w_bp_to_mb_aux1_data[7:0] == 8'b10010100) ? 1'b0 : 1'b1;//12LSG4
assign i2c_ram_1056[3] = (w_bp_to_mb_aux1_data[7:0] == 8'b10011001) ? 1'b0 : 1'b1;//8LSG3
assign i2c_ram_1056[4] = (w_bp_to_mb_aux1_data[7:0] == 8'b10000100) ? 1'b0 : 1'b1;//8SSG3-BP3
assign i2c_ram_1056[5] = (w_bp_to_mb_aux2_data[7:0] == 8'b10000100) ? 1'b0 : 1'b1;//8SSG3-BP2
// assign i2c_ram_1056[6] = (w_bp_to_mb_aux3_data[7:0] == 8'b10000100) ? 1'b0 : 1'b1;//8SSG3-BP1
// assign i2c_ram_1056[7] = (w_bp_to_mb_aux4_data[7:0] == 8'b10000000) ? 1'b0 : 1'b1;//2LSG3      
// assign i2c_ram_1057[0] = (w_bp_to_mb_aux7_data[7:0] == 8'b10000000) ? 1'b0 : 1'b1;//2LSG3
assign i2c_ram_1057[7:1] = 7'h7f;

//----------------------------------------------------------------------------------------------------------------------
//AUX1  J84    Board_ID
// ---------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u1 (
.clk             (clk_100m            ),//input
.rst             (~pon_reset_n        ),//input
.tick            (t16us_tick          ),//input
.t128ms_tick     (t128ms_tick         ),//input
//Physical Pin        
.ser_data        (io_PAL_BP1_PWR_ON_R ),//inout 
//Physical Data
.par_data_in     (w_mb_to_bp_aux1_data),//input 
.par_data_out    (w_bp_to_mb_aux1_data),//output
.send_enable     (1'b1                ),//input
.pass_through    (w_pal_bp1_pwr_on_r  ),//input
.error_flag      (                    ) //output
);

//----------------------------------------------------------------------------------------------------------------------
//AUX2  J86    Board_ID
// ---------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u2 (
.clk             (clk_100m            ),//input
.rst             (~pon_reset_n        ),//input
.tick            (t16us_tick          ),//input
.t128ms_tick     (t128ms_tick         ),//input
//Physical Pin        
.ser_data        (io_PAL_BP2_PWR_ON_R ),//inout 
//Physical Data
.par_data_in     (w_mb_to_bp_aux2_data),//input 
.par_data_out    (w_bp_to_mb_aux2_data),//output
.send_enable     (1'b1                ),//input
.pass_through    (w_pal_bp2_pwr_on_r  ),//input
.error_flag      (                    ) //output
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
OCP 
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                            ocp_aux_50ms_pgd            ;
wire                            ocp_main_en_dly50ms         ;
wire                            ocp_aux_pgd                 ;

edge_delay #(
    .CNTR_NBITS    (5                       )
) ocp_main_en_delay_inst (
    .clk           (clk_100m		        ),
    .reset         (~pon_reset_n	        ),
    .cnt_size      (5'h19		            ),
    .cnt_step      (t2ms_tick	            ),
    .signal_in     (ocp_main_en             ),
    .delay_output  (ocp_main_en_dly50ms     )
);
assign ocp1_prsnt_n = ocp_prsent_b3_n & ocp_prsent_b2_n & ocp_prsent_b1_n & ocp_prsent_b0_n;
assign ocp2_prsnt_n = ocp_prsent_b4_n & ocp_prsent_b5_n & ocp_prsent_b6_n & ocp_prsent_b7_n;

assign ocp_aux_50ms_pgd = (ocp_main_en_dly50ms)  ? db_i_pal_ocp1_pwrgd : 1'b1;
assign ocp_aux_pgd      = (ocp_main_en		)    ? ocp_aux_50ms_pgd    : db_i_pal_ocp1_pwrgd; 

assign o_PAL_OCP1_HP_SW_EN_R    = 1'b0                   ;
assign o_PAL_OCP1_STBY_PWR_EN_R = ocp_aux_en             ; // OCP 辅助供电使能信号, 未使用
assign o_PAL_OCP1_MAIN_PWR_EN_R = ocp_main_en            ; // OCP 主供电使能信号, 未使用
assign o_PAL_OCP1_PERST0_N_R    = reached_sm_wait_powerok;
assign o_PAL_OCP1_PERST1_N_R    = reached_sm_wait_powerok;



/*-----------------------------------------------------------------------------------------------------------------------------------------------
复位与电源管理
------------------------------------------------------------------------------------------------------------------------------------------------*/
// CPU 超频背板使能信号，低电平有效, 不使用
assign o_CPU0_SB_EN_R              = 1'b0;
assign o_CPU1_SB_EN_R              = 1'b0;
// LOM 供电使能信号，高电平有效，始终使能
assign o_PAL_PWR_LOM_EN_R          = 1'b1;
// 88SE9230 供电使能信号，高电平有效
assign o_PWR_88SE9230_P1V8_EN_R    = 1'b1;
assign o_PWR_88SE9230_P1V0_EN_R    = 1'b1;
// CPU PLL 1.8V 使能信号
assign o_P1V8_STBY_CPLD_EN_R      = 1'b1;

// 辅电源
// 1. SM_OFF_STANDBY 状态上电使能
assign o_BIOS0_RST_N_R            = ~rom_bios_ma_rst    ; // cpu_bios_en ? (~rom_bios_ma_rst) : 1'bz; // BIOS FLASH 复位信号输出，低电平有效  
assign o_BIOS1_RST_N_R            = ~rom_bios_bk_rst    ; // cpu_bios_en ? (~rom_bios_bk_rst) : 1'bz; // BIOS FLASH 复位信号输出，低电平有效 

assign o_PAL_FRONT_BP_EFUSE_EN_R  = p12v_bp_front_en    ; // 12V 前背板供电使能信号

// 2. SM_EN_5V_STBY 状态上电使能
assign o_PAL_P5V_STBY_EN_R        = p5v_stby_en_r       ; // 5V 待机电源使能信号

// 3. SM_EN_TELEM 状态上电使能
assign o_PAL_PVCC_HPMOS_CPU_EN_R  =  pvcc_hpmos_cpu_en_r; // CPU MOSFET 供电使能信号

// 4. SM_EN_MAIN_EFUSE 状态上电使能
// RISER 卡供电使能信号， 高电平有效
assign o_PAL_P12V_RISER1_VIN_EN_R  = power_supply_on    ; // RISER 卡供电使能信号， 高电平有效
assign o_PAL_P12V_RISER2_VIN_EN_R  = power_supply_on    ; // RISER 卡供电使能信号， 高电平有效
assign o_PAL_RISER1_PWR_EN_R       = power_supply_on    ; // RISER 卡供电使能信号， 高电平有效
assign o_PAL_RISER2_PWR_EN_R       = power_supply_on    ; // RISER 卡供电使能信号， 高电平有效
assign o_PAL_P12V_CPU0_VIN_EN_R    = power_supply_on    ; // CPU 12V 输入使能信号，高电平有效
assign o_PAL_P12V_CPU1_VIN_EN_R    = power_supply_on    ; // CPU 12V 输入使能信号，高电平有效

// assign o_PAL_FRONT_BP_EFUSE_EN_R  = p12v_bp_front_en ; // 12V 前背板供电使能信号, 未使用
// assign o_PAL_REAT_BP_EFUSE_EN_R   = p12v_bp_rear_en  ; // 12V 后背板供电使能信号, 未使用

// 5. SM_EN_5V 状态上电使能
assign o_PAL_P5V_BD_EN_R           = p5v_en_r            ; // 5V 主板电源使能信号
assign o_P5V_USB_MB_UP_EN_R        = p5v_en_r            ; // 5V USB 上行使能信号
assign o_P5V_USB_MB_DOWN_EN_R      = p5v_en_r            ; // 5V USB 上行使能信号

// 6. SM_EN_3V3 状态上电使能
assign o_PAL_UPD_VCC_3V3_EN_R      = p3v3_en_r            ; // 3.3V 电源使能信号
assign o_PAL_VCC_1V1_EN_R          = p1v1_en_r            ; // 1.1V 电源使能信号


// 主电源
// CPU_GR1 供电使能信号
assign o_PAL_CPU0_VDD_CORE_EN_R   =  cpu0_vdd_core_en_r ;
assign o_PAL_CPU1_VDD_CORE_EN_R   =  cpu1_vdd_core_en_r ;

// CPU GR2 供电使能信号
assign o_PAL_CPU0_P1V8_EN_R       =  cpu0_p1v8_en_r     ;
assign o_PAL_CPU1_P1V8_EN_R       =  cpu1_p1v8_en_r     ;

// CPU GR3 供电使能信号
assign o_PAL_CPU0_VDDQ_EN_R       =  cpu0_vddq_en_r     ;
assign o_PAL_CPU1_VDDQ_EN_R       =  cpu1_vddq_en_r     ;//& cpu1_pwr_ctrl_en;//20231121

assign o_PAL_CPU0_DDR_VDD_EN_R    =  cpu0_ddr_vdd_en_r  ;
assign o_PAL_CPU1_DDR_VDD_EN_R    =  cpu1_ddr_vdd_en_r  ;//& cpu1_pwr_ctrl_en;//20231121

assign o_PAL_CPU0_PLL_P1V8_EN_R   =  cpu0_pll_p1v8_en_r ;
assign o_PAL_CPU1_PLL_P1V8_EN_R   =  cpu1_pll_p1v8_en_r ;//& cpu1_pwr_ctrl_en;//20231121

// CPU GR4 供电使能信号
assign o_PAL_CPU0_D0_VP_0V9_EN    =  cpu0_d0_vp_p0v9_en_r  ;
assign o_PAL_CPU0_D1_VP_0V9_EN    =  cpu0_d1_vp_p0v9_en_r  ;
assign o_PAL_CPU0_D0_VPH_1V8_EN   =  cpu0_d0_vph_p1v8_en_r ;
assign o_PAL_CPU0_D1_VPH_1V8_EN   =  cpu0_d1_vph_p1v8_en_r ;
assign o_PAL_CPU1_D0_VP_0V9_EN    =  cpu1_d0_vp_p0v9_en_r  ;
assign o_PAL_CPU1_D1_VP_0V9_EN    =  cpu1_d1_vp_p0v9_en_r  ;
assign o_PAL_CPU1_D0_VPH_1V8_EN   =  cpu1_d0_vph_p1v8_en_r ;
assign o_PAL_CPU1_D1_VPH_1V8_EN   =  cpu1_d1_vph_p1v8_en_r ;

//------------------------------------------------------------------------------
// Misc logic
//------------------------------------------------------------------------------
assign ft_cpu_rst_ok  =	ft_cpu0_rst_ok & ft_cpu1_rst_ok;
assign ft_cpu0_rst_ok = i_CPU0_D1_CRU_RST_OK & i_CPU0_D0_CRU_RST_OK & i_CPU0_D2_CRU_RST_OK & i_CPU0_D3_CRU_RST_OK;
assign ft_cpu1_rst_ok = i_CPU1_D1_CRU_RST_OK & i_CPU1_D0_CRU_RST_OK & i_CPU1_D2_CRU_RST_OK & i_CPU1_D3_CRU_RST_OK;


assign o_PAL_CPU0_VR8_RESET_R  = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);
// assign o_CPU0_VR_AVRST_R       = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);
assign o_PAL_CPU1_VR8_RESET_R  = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);
// assign o_CPU1_VR_AVRST_R       = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);

endmodule