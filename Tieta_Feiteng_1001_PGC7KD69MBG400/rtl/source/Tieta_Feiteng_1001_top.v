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
// BMC UID按钮信号
input  i_PAL_BMCUID_BUTTON_R                  /* synthesis LOC = "A17"*/,// from  BMC/GENZ_168PIN                                to  CPLD_M                                       default 1  // BMC UID按钮信号输入                           新增

// BMC 卡存在信号
input  i_PAL_BMC_CARD_PRSNT_N                 /* synthesis LOC = "N15"*/,// from  BMC/GENZ_168PIN                                to  CPLD_M                                       default 0  // BMC卡存在信号输入

// BMC 预留信号
// 不使用
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

// 不使用
output o_CPLD_M_S_SGPIO1_CLK_R                /* synthesis LOC = "G15"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1时钟信号输出
output o_CPLD_M_S_SGPIO1_LD_N_R               /* synthesis LOC = "K17"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1负载使能信号输出
output o_CPLD_M_S_SGPIO1_MOSI_R               /* synthesis LOC = "C20"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1 MOSI信号输出
input  i_CPLD_M_S_SGPIO1_MISO                 /* synthesis LOC = "F17"*/,// from  CPLD_S                                        to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的SGPIO1 MISO信号输入

// 不使用
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
output o_PAL_P12V_DISCHARGE_R                 /* synthesis LOC = "L1"*/ ,// from  CPLD_M                                         to  PSU_MISC2/PAL_P12V_DISCHARGE                 default 1  // 12V放电信号输出         
// 未使用
input  i_PAL_MAIN_PWR_OK                      /* synthesis LOC = "K6"*/ ,// from  RISER_AUX/J16                                  to  CPLD_M                                       default 1  // 主模块电源良好信号输入(未使用)

// 辅助电源模块 电源良好信号
inout  io_PAL_BP1_PWR_ON_R                    /* synthesis LOC = "E14"*/,// from  CPLD_M                                         to  BP_AUX_PWR/J84_PAL_BP1_PWR_ON_R              default 1  // BP1辅助电源开启信号输出                       新增
inout  io_PAL_BP2_PWR_ON_R                    /* synthesis LOC = "U1"*/ ,// from  CPLD_M                                         to  REAR_BP_AUX_PWR/J86_1338_201/A1              default 1  // 后置背板电源开启信号输入输出           
// 不使用
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
// output o_PAL_FRONT_BP_EFUSE_EN_R              /* synthesis LOC = "N16"*/,
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
// CPU0 D0 区域软关机中断信号输出
output o_CPU0_D0_SOFT_SHUTDOWN_INT_N          /* synthesis LOC = "R11"*/ ,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/CPU0_D0_SOFT_SHUTDOWN_INT_N default 1  // CPU0 D0 区域软关机中断信号输出

// 机箱安全检测接口
input  i_FRONT_PAL_INTRUDER                   /* synthesis LOC = "C10"*/,// from  INTRUDER_CONN                                 to  CPLD_M                                       default 1  // 机箱安全检测接口
input  i_INTRUDER_CABLE_INST_N                /* synthesis LOC = "C14"*/,// from  CPLD_M                                         to  INTRUDER_CONN                                default 1  

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
input  i_PAL_USB_UPD2_OCI2B                   /* synthesis LOC = "A12"*/,// from  USB3.0/U311_JW7111SSOTBTRPBF                   to  CPLD_M                                      default 1  // USB UPD2 OCI2B信号输入输出
input  i_PAL_USB_UPD2_OCI1B                   /* synthesis LOC = "B15"*/,// from  USB3.0                                         to  CPLD_M                                       default 1  // USB UPD2 OCIIB信号输入                       新增
// 未使用
input  i_PAL_UPD72020_VCC_ALART               /* synthesis LOC = "G17"*/,// from  WX1860_POL_U82_JW7111SSOTBTRPBF/OUT            to  CPLD_M                                       default 1  // UPD72020 VCC电源告警信号输入

// CPU0/1 3.3V 电源告警信号输入
input  i_SMB_PEHP_CPU0_3V3_ALERT_N            /* synthesis LOC = "N5"*/ ,// from  CPU0_MCIO_0/1/SIDEBAND3                        to  CPLD_M                                       default 1  // CPU0    3v3电源告警信号输入
input  i_SMB_PEHP_CPU1_3V3_ALERT_N            /* synthesis LOC = "J17"*/,// from  REAR BP AUX PWR/SMB_CPU1_AUX1_ALERT_N          to  CPLD_M                                       default 1  // CPU1    3v3电源告警信号输入

// CPU0/1 NVME 告警信号输出
output o_PAL_CPU0_NVME_ALERT_N_R              /* synthesis LOC = "W4"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_QSPI_CSM[2]    default 0  // CPU0    NVME告警信号                 
output o_PAL_CPU1_NVME_ALERT_N_R              /* synthesis LOC = "T13"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_QSPI_CSM[2]    default 0  // CPU1    NVME告警信号

// WX1860A2 存在与复位信号输入
// ？这两个信号什么时候赋值？
output o_PAL_WX1860_NRST_R                    /* synthesis LOC = "A15"*/,// from  PEX_WX1860A2/U20_WX1860A2                      to  CPLD_M                                       default 1  // WX1860 复位信号输入                           新增
output o_PAL_WX1860_PERST_R                   /* synthesis LOC = "A16"*/,// from  PEX_WX1860A2/U20_WX1860A2                      to  CPLD_M                                       default 1  // WX1860 存在信号输入                         新增

// TPM 模块存在信号输入
// input  i_TPM_MODULE_PRSNT_N                /* synthesis LOC = "N17"*/,// from  TPM                                            to  CPLD_M                                       default 1  // TPM模块存在信号输入（低电平有效）               新增

// CPU0/1 D0 区域插槽ID信号输入
// 未使用
output o_CPU0_D0123_SOCKET_ID_R               /* synthesis LOC = "Y4"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_INSTANCELD_1   default 1  // CPU0 D0 区域插槽ID信号                
output o_CPU1_D0123_SOCKET_ID_R               /* synthesis LOC = "T7"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_INSTANCELD_1   default 0  // CPU1 D0 区域插槽ID信号            

// CPU0/1 D0/D1 区域安全恢复信号输入
output o_CPU0_D1_SE_RECOVERY_R                /* synthesis LOC = "U12"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO2/D1_SE_RECOVERY    default 1  // CPU0 D1 区域安全恢复信号
output o_CPU1_D0_SE_RECOVERY_R                /* synthesis LOC = "P11"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_SE_RECOVERY    default 1  // CPU1 D0 区域安全恢复信号

// CPU0/1 I2C 传输使能信号输出
output o_CPU0_I2C_TRAN_EN_R                   /* synthesis LOC = "W1"*/,// from  CPLD_M                                        to  U213/214_RS0302YH8                           default 1  // CPU0    I2C传输使能信号（CPU 与 DDR 之间的 I2C 电平转换电路）
output o_CPU1_I2C_TRAN_EN_R                   /* synthesis LOC = "Y1"*/,// from  CPLD_M                                        to  U217/218_RS0302YH8                           default 1  // CPU1    I2C传输使能信号（CPU 与 DDR 之间的 I2C 电平转换电路）

// CPU0/1 SCP从Flash启动信号输出
// 不使用
output o_FT_CPU0_SCP_BOOT_FROM_FLASH_R        /* synthesis LOC = "W20"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/REV9              default 1  // CPU0 SCP从Flash启动信号
output o_FT_CPU1_SCP_BOOT_FROM_FLASH_R        /* synthesis LOC = "R15"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/REV9              default 1  // CPU1 SCP从Flash启动信号

// CPU1 D0 区域软关机中断信号
output o_CPU0_D0_SOFT_SHUTDOWN_INT_N          /* synthesis LOC = "Y1" */,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/D0_UART2_TXD      default 0  // CPU0 D0 区域软关机中断信号 , 触发系统软关机流程
// 未使用
output o_CPU1_D0_SOFT_SHUTDOWN_INT_N          /* synthesis LOC = "Y1"*/, // from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/D0_UART2_TXD      default 0  // CPU1 D0 区域软关机中断信号 , 触发系统软关机流程

// CPU0/1 主板区域温度过高告警信号输出
output o_CPU0_BOARD_TEMP_OVER_R               /* synthesis LOC = "Y11"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU0_GPIO1/BOARD_TEMP_OVER   default 1  // CPU0    主板区域温度过高告警信号输出
output o_CPU1_BOARD_TEMP_OVER_R               /* synthesis LOC = "Y11"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/BOARD_TEMP_OVER   default 1  // CPU1    主板区域温度过高告警信号输出

// CPU0/1 电压调节器（VR）上报电源异常状态输入
// 未使用
output o_PAL_CPU0_VR_PMALT_R                  /* synthesis LOC = "P8"*/, // from  S5000C32_3200_C/CPU0_GPIO1/PMBALERT_IN_N      to  CPLD_M                                       default 1  // CPU0 电压调节器（VR）上报电源异常状态    
output o_PAL_CPU1_VR_PMALT_R                  /* synthesis LOC = "U15"*/,// from  CPLD_M                                        to  S5000C32_3200_C/CPU1_GPIO1/PMBALERT_IN_N     default 1  // CPU1    电压调节器（VR）向CPLD上报电源异常状态

// CPU0/1 温度传感器告警信号输入
// 未使用
input  i_PAL_CPU0_TMP_ALERT_N                 /* synthesis LOC = "T4"*/ ,// from  CPU0_TMP/U187_EMC1413_A_AIA_TR                to  CPLD_M                                       default 0  // CPU0 温度告警信号输入
input  i_PAL_CPU1_TMP_ALERT_N                 /* synthesis LOC = "N3"*/ ,// from  CPU1_TMP/U188_EMC1413_A_AIA_TR                to  CPLD_M                                       default 0  // CPU1温度告警信号输入              

// CPU0/1 D0/D1 区域BIOS超时信号输入
// 未使用
input  i_CPU1_D0_BIOS_OVER                    /* synthesis LOC = "Y12"*/,// from  CPU1_GPIO1/D0_UART2_RXD                       to  CPLD_M                                       default 1  // CPU1 D0 区域BIOS超时信号 

// CPU0/1 TIMER FORCE START 信号输入
// 未使用
input  i_CPU01_TIMER_FORCE_START              /* synthesis LOC = "V15"*/,// 未使用

// CPU0/1 VR8 CAT 故障信号输入
input  i_CPU0_VR8_CAT_FLT                     /* synthesis LOC = "V1"*/ ,// from  CPU_VR8_Controler/VR_FAULT                    to  CPLD_M                                       default 1  // CPU0 VR8 CAT故障信号输入
input  i_CPU0_VR_ALERT_N_R                    /* synthesis LOC = "T1"*/ ,// from  CPU_VR8_Controler/I2C_VR_ALERT_N              to  CPLD_M                                       default 1  // CPU0 电压调节器告警信号输入             新增       
input  i_CPU1_VR8_CAT_FLT                     /* synthesis LOC = "M4"*/ ,// from  CPU_VR8_Controler/VR_FAULT                    to  CPLD_M                                       default 1  // CPU1 VR8 CAT故障信号输入                    
input  i_CPU1_VR_ALERT_N_R                    /* synthesis LOC = "T2"*/ ,// from  CPU_VR8_Controler/I2C_VR_ALERT_N              to  CPLD_M                                       default 1  // CPU1电压调节器告警信号输入             新增   

// CPU0/1 D0/D1 区域电源控制信号输入
// 未使用
input  i_CPU0_D1_PWR_CTR0_R                   /* synthesis LOC = "Y6"*/, // from  CPU0_GPIO2/D1_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU0 D1 区域电源控制信号0
input  i_CPU0_D1_PWR_CTR1_R                   /* synthesis LOC = "W3"*/, // from  CPU0_GPIO2/D1_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU0 D1 区域电源控制信号1
input  i_CPU1_D0_PWR_CTR0_R                   /* synthesis LOC = "T9"*/, // from  CPU1_GPIO1/D0_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU1 D0 区域电源控制信号0
input  i_CPU1_D0_PWR_CTR1_R                   /* synthesis LOC = "R8"*/, // from  CPU1_GPIO1/D0_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU1 D0 区域电源控制信号1
input  i_CPU1_D1_PWR_CTR0_R                   /* synthesis LOC = "W15"*/,// from  CPU1_GPIO2/D1_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU1 D1 区域电源控制信号0
input  i_CPU1_D1_PWR_CTR1_R                   /* synthesis LOC = "Y19"*/,// from  CPU1_GPIO2/D1_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU1 D1 区域电源控制信号1

input  i_CPU0_D0_PWR_CTR0_R                   /* synthesis LOC = "Y2"*/, // form  CPU0_GPIO1/D0_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU0 D0 区域电源控制信号0（cpu的状态反馈, 解除重上电）
input  i_CPU0_D0_PWR_CTR1_R                   /* synthesis LOC = "V6"*/, // from  CPU0_GPIO1/D0_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU0 D0 区域电源控制信号1（cpu的状态反馈, 控制重上电）

// CPU0/1 D0 区域内存电源中断初始化信号输入
// 未使用
input  i_CPU0_D0_MEMORY_POWER_INT_N           /* synthesis LOC = "R13"*/,// from  CPU0_GPIO1/D0_QSPI_CSN[3]                     to  CPLD_M                                       default 0  // CPU0 D0 区域 VDD_IO_P1V8 电源中断 初始化信号
input  i_CPU1_D0_MEMORY_POWER_INT_N           /* synthesis LOC = "T6"*/ ,// from  CPU1_GPIO1/D0_QSPI_CSN[3]                     to  CPLD_M                                       default 0  // CPU1 D0 区域 VDD_IO_P1V8 电源中断 初始化信号

// CK440_CLK 电源关闭信号输出
output o_PAL_CK440_PWRDN_N_R                  /* synthesis LOC = "H20"*/,// from  CPLD_M                                        to  CK440_CLKEN/PAL_CK440_PWRDN_N                default 1  // CK440电源关闭信号输出

// RTC 实时时钟芯片选择信号输出, BMC控制
output o_PAL_RTC_SELECT_N                     /* synthesis LOC = "A11"*/,// from  CPLD_M                                         to  RTC                                          default 1  // RTC选择信号输出（低电平有效）

// EEPROM 芯片旁路控制信号输出, BMC控制
output o_PAL_SYS_EEPROM_BYPASS_N_R            /* synthesis LOC = "D16"*/,

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
input  i_CPU1_D0_GPIO_PORT4_R                 /* synthesis LOC = "Y10"*/// from  CPU1_GPIO1/D0_GPIO_PORT[4]                     to  CPLD_M                                       default 1  // CPU1 D0 区域 通用输入输出端口 4        新增
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
线网, 寄存器, 参数声明
------------------------------------------------------------------------------------------------------------------------------------------------*/
// clks & resets
parameter                                   PEAVEY_SUPPORT       = 1'b1 ;  
wire                                        done_booting_delayed = 1'b1 ; // 不使用, 系统booting_done, 来自BMC, 默认写1
wire                                        clk_50m                     ; // 系统时钟
wire                                        clk_25m                     ; // 不使用
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
// 2. SM_EN_5V_STBY 状态上电使能
wire                                        p5v_stby_en_r               ;
// 3. SM_EN_TELEM 状态上电使能
wire                                        pvcc_hpmos_cpu_en_r         ;
// 4. SM_EN_MAIN_EFUSE 状态上电使能
wire                                        power_supply_on             ; 
wire                                        ocp_main_en                 ; // 不使用 
wire                                        pal_main_efuse_en           ; // 不使用
wire                                        p12v_bp_rear_en             ; // 不使用 
wire                                        p12v_bp_front_en            ; // 不使用
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
wire                                        db_i_pal_fan_efuse_pg               ;// 不使用
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
wire                                        db_i_pal_reat_bp_efuse_pg  		      ;// 

wire                                        db_i_pal_p5v0_pgd                   ;//  

wire                                        db_i_pal_vcc_1v1_pg                 ;// 新增

wire                                        db_i_pal_cpu1_vdd_core_pg           ;//    
wire                                        db_i_pal_cpu0_vdd_core_pg           ;// 

wire                                        db_i_pal_cpu1_p1v8_pg               ;// 
wire                                        db_i_pal_cpu0_p1v8_pg  		          ;//  

wire                                        db_i_pal_cpu1_vddq_pg               ;// 
wire                                        db_i_pal_cpu0_vddq_pg			          ;//  	
wire                                        db_i_pal_cpu1_ddr_vdd_pg            ;// 
wire                                        db_i_pal_cpu0_ddr_vdd_pg  		      ;// 
wire                                        db_i_pal_cpu1_pll_p1v8_pg           ;//         
wire                                        db_i_pal_cpu0_pll_p1v8_pg			      ;// 

wire                                        db_i_pal_cpu0_pcie_p1v8_pg  		    ;//  不使用       	
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
wire                                        any_aux_vrm_fault                   ;
wire [`NUM_CPU-1:0]                         cpu_thermtrip_fault_det             ;

wire                                        db_i_dimm_sns_alert                 ;
wire                                        db_i_fan_sns_alert                  ;
wire                                        db_i_p12v_stby_sns_alert            ;



wire                                        p5v_stby_fault_det                ;
wire                                        p3v3_stby_fault_det               ;
wire                                        p3v3_stby_bp_fault_det            ;
wire                                        p12v_fan_efuse_fault_det          ;
wire                                        p12v_dimm_efuse_fault_det         ;
wire                                        p12v_cpu0_vin_fault_det           ;
wire                                        p12v_cpu1_vin_fault_det           ;
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

wire                                        db_cpu_nvme17_prsnt_n             ;
wire                                        db_cpu_nvme16_prsnt_n             ;
wire                                        db_cpu_nvme15_prsnt_n             ;
wire                                        db_cpu_nvme14_prsnt_n             ;
wire                                        db_cpu_nvme13_prsnt_n             ;
wire                                        db_cpu_nvme12_prsnt_n             ;
wire                                        db_cpu_nvme11_prsnt_n             ;
wire                                        db_cpu_nvme10_prsnt_n             ;
wire                                        db_cpu_nvme19_prsnt_n             ;
wire                                        db_cpu_nvme18_prsnt_n             ;
wire                                        db_cpu_nvme23_prsnt_n             ;
wire                                        db_cpu_nvme22_prsnt_n             ;
wire                                        db_cpu_nvme7_prsnt_n              ;
wire                                        db_cpu_nvme6_prsnt_n              ;
wire                                        db_cpu_nvme5_prsnt_n              ;
wire                                        db_cpu_nvme4_prsnt_n              ;
wire                                        db_cpu_nvme3_prsnt_n              ;
wire                                        db_cpu_nvme2_prsnt_n              ;
wire                                        db_cpu_nvme1_prsnt_n              ;
wire                                        db_cpu_nvme0_prsnt_n              ;
wire                                        db_cpu_nvme9_prsnt_n              ;
wire                                        db_cpu_nvme8_prsnt_n              ;
wire                                        db_cpu_nvme25_prsnt_n             ;
wire                                        db_cpu_nvme24_prsnt_n             ;
wire                                        cpu_nvme17_prsnt_n                ;
wire                                        cpu_nvme16_prsnt_n                ;
wire                                        cpu_nvme15_prsnt_n                ;
wire                                        cpu_nvme14_prsnt_n                ;
wire                                        cpu_nvme13_prsnt_n                ;
wire                                        cpu_nvme12_prsnt_n                ;
wire                                        cpu_nvme11_prsnt_n                ;
wire                                        cpu_nvme10_prsnt_n                ;
wire                                        cpu_nvme19_prsnt_n                ;
wire                                        cpu_nvme18_prsnt_n                ;
wire                                        cpu_nvme23_prsnt_n                ;
wire                                        cpu_nvme22_prsnt_n                ;
wire                                        cpu_nvme7_prsnt_n                 ;
wire                                        cpu_nvme6_prsnt_n                 ;
wire                                        cpu_nvme5_prsnt_n                 ;
wire                                        cpu_nvme4_prsnt_n                 ;
wire                                        cpu_nvme3_prsnt_n                 ;
wire                                        cpu_nvme2_prsnt_n                 ;
wire                                        cpu_nvme1_prsnt_n                 ;
wire                                        cpu_nvme0_prsnt_n                 ;
wire                                        cpu_nvme9_prsnt_n                 ;
wire                                        cpu_nvme8_prsnt_n                 ;
wire                                        cpu_nvme25_prsnt_n                ;
wire                                        cpu_nvme24_prsnt_n                ;

wire                                        db_sys_sw_in_n                    ;
wire                                        db_i_front_pal_intruder           ; // 机箱入侵检测信号输入
wire                                        debug_sw1                         ;
wire                                        debug_sw2                         ;
wire                                        debug_sw3                         ;
wire                                        debug_sw4                         ;
wire                                        debug_sw5                         ;
wire                                        debug_sw6                         ;
wire                                        debug_sw7                         ;
wire                                        debug_sw8                         ;
wire [7:0]                                  cpld_jtag_sel                     ;
wire                                        uid_led_hold                      ;
wire                                        uid_led_force_on;
wire                                        bmc_uid_update;
// wire                                        db_i_pal_uid_sw_in_n              ; // UID按键输入信号    
wire                                        uid_led_out                       ;
wire                                        led_uid                           ;
wire                                        pf_blink_code                     ;
wire                                        ocp_led                           ;
wire                                        pal_led_nic_act                   ;
wire                                        uid_led_state                     ;
wire                                        ilo_hard_reset                    ;
wire                                        ilo_rstreq_n                      ;
wire                                        vwire_bmc_nmi                     ;
wire                                        vwire_bmc_wakeup                  ;
wire                                        vwire_bmc_sysrst                  ;
wire                                        s_bmc_sysrst_n                    ;
wire                                        vwire_bmc_shutdown                ;
wire                                        s_bmc_shutdown                    ;
wire                                        db_pal_ext_rst_n                  ;
wire                                        rst_btn_mask                      ;
wire                                        bmc_ctrl_shutdown                 ;
wire                                        aux_pcycle                        ;
wire                                        efuse_power_cycle                 ;
wire                                        pwrbtn_bl_mask;
wire                                        vwire_pwrbtn_bl;
wire                                        pwrcap_en;
wire                                        pwron_denied;
wire                                        power_wake_r_n;
wire                                        wol_en;
wire [1:0]                                  sideband_sel;
wire                                        rom_mux_bios_bmc_en;
wire                                        rom_mux_bios_bmc_sel;
wire                                        rom_bios_ma_rst;
wire                                        rom_bios_bk_rst;
wire                                        rom_bmc_bk_rst;
wire                                        rom_bmc_ma_rst;
wire                                        bmc_eeprom_wp;
wire                                        bios_eeprom_wp;
wire                                        cpld_rst_bmc;
wire                                        power_fault;
wire                                        db_gmt_fail_n;
wire                                        sys_hlth_grn_blink_n;
wire                                        sys_hlth_red_blink_n;
wire                                        hsb_fail_n;
wire                                        st_reset_state;
wire                                        st_off_standby;
wire                                        st_steady_pwrok;
wire                                        st_halt_power_cycle;
wire                                        st_aux_fail_recovery;
wire                                        dc_on_wait_complete;
wire                                        rt_critical_fail_store;
wire                                        fault_clear;
wire                                        pch_sys_reset;
wire                                        pch_sys_reset_n;
wire                                        rst_bmc_n;
wire [`NUM_IO-1:0]                          rst_io_n;
wire [`NUM_PSU-1:0]                         xr_ps_enable;
wire [`NUM_PSU-1:0]                         db_ps_prsnt_n;
// wire [`NUM_PSU-1:0] db_ps_acok;
// wire [`NUM_PSU-1:0] db_ps_dcok;
wire [`NUM_PSU-1:0]                         ps_on_dly_n;
wire [`NUM_PSU-1:0]                         ps_on_n;
wire [`NUM_PSU-1:0]                         ps_fail;
wire [7:0]                                  hd_bp_fault_det;
wire                                        ps_caution;
wire                                        ps_critical;
wire                                        brownout_warning;
wire                                        brownout_fault;
wire                                        db_emc_alert_n;
wire                                        pwrbtn_mask;
wire                                        s_bmc_wakeup_n;
wire                                        interlock_broken;
wire                                        cpu_thermtrip;
wire [`NUM_CPU-1:0]                         cpu_thermtrip_event;
wire [`NUM_CPU-1:0]                         cpu_thermtrip_fault;
wire                                        pch_pwrbtn;
wire                                        pch_thrmtrip;
wire                                        force_pwrbtn_n;
wire                                        pch_thermtrip_flag;
wire                                        cpu_off_flag;
wire                                        reboot_flag;
wire                                        pgd_raw;
wire                                        pgd_so_far;
wire                                        turn_system_on;
wire                                        any_pwr_fault_det;
wire                                        any_lim_recov_fault;
wire                                        any_non_recov_fault;

wire [`NUM_PSU-1:0]                         mismatched_ps;
wire                                        s_cpu_rst_pcie_n;
wire                                        vwire_cpu_rst_pcie;
wire                                        db_i_pal_lcd_card_in;
wire                                        ifist_prsnt_n;
wire [7:0]                                  bios_post_code;
wire [7:0]                                  post_led_n;
wire                                        vga2_dis;
wire [`NUM_PSU-1:0]                         s_ps_smb_alert_n;
wire [`NUM_CPU-1:0]                         qual_cpu_vr_hot_n;
wire [`NUM_CPU-1:0]                         mem_abcd_hot_alert;
wire [`NUM_CPU-1:0]                         mem_efgh_hot_alert;
wire [`NUM_CPU-1:0]                         cpu_mem_abcd_forcepr;
wire [`NUM_CPU-1:0]                         cpu_mem_efgh_forcepr;
wire                                        pwrcap_wait;
wire                                        turn_on_wait;
wire                                        keep_alive_on_fault;
wire                                        pal_pwrbtn_grn_led;
wire                                        pal_pwrbtn_amb_led;
wire                                        ebrake;
wire                                        db_vr_hot_n;
wire                                        all_emc_alert_n;
wire                                        emc_alert_mask;
wire                                        riser1_tmp_alert_n;
wire                                        riser2_tmp_alert_n;
wire                                        riser1_emc_alert_mask;
wire                                        riser2_emc_alert_mask;
wire                                        db_riser1_tmp_alert_n;
wire                                        db_riser2_tmp_alert_n;
wire                                        pal_riser1_prsnt_n;
wire                                        pal_riser2_prsnt_n;
wire                                        db_pal_riser1_prsnt_n;
wire                                        db_pal_riser2_prsnt_n;
wire                                        ocp_temp_alert_mask  ;
wire                                        sensor_thermtrip;
wire                                        pal_m2_1_sel_r;
wire                                        pal_m2_1_prsnt_n;
wire                                        pal_m2_0_prsnt_n;
wire                                        front_m2_card_prsnt;
wire [7:0]                                  db_debug_sw;
wire [7:0]                                  bmc_i2c_rst;
wire [7:0]                                  bmc_i2c_rst2;
wire [7:0]                                  bmc_i2c_rst3;
wire                                        rst_i2c0_mux_n;
wire                                        rst_i2c3_mux_n;
wire                                        rst_i2c13_mux_n;
wire                                        rst_i2c1_mux_n;
wire                                        rst_i2c4_2_mux_n;
wire                                        rst_i2c8_mux_n;
wire                                        rst_i2c2_mux_n;
wire                                        rst_i2c5_mux_n;
wire                                        rst_i2c12_mux_n;
wire                                        rst_i2c11_mux_n;
wire                                        rst_i2c4_1_mux_n;
wire                                        rst_i2c10_mux_n;
wire                                        rst_i2c_riser1_pca9548_n;
wire                                        rst_i2c_riser2_pca9548_n;
wire                                        pal_lcd_busy;
wire                                        pal_lcd_prsnt;
wire                                        tpm_pp;
wire                                        tpm_rst;
wire                                        tpm_prsnt_n;
wire                                        db_tpm_prsnt_n;
wire                                        db_i_intruder_cable_inst_n;
// wire db_i_pal_cpu1_dimm_pwrgd_f;
wire [`NUM_CPU-1:0]                         s_vr_cpu_i2c_alert_n;
wire                                        db_i_pal_ocp1_fan_prsnt_n;
wire                                        db_i_pal_bmc_card_prsnt_n;
wire                                        db_i_pal_cpu0_dimm_pwrgd_f;
wire                                        rst_pal_extrst_r_n;
wire                                        db_i_pal_bmcuid_button_r;
wire                                        bmc_extrst_uid;
wire                                        test_bat_en;
wire                                        i_pal_wdt_rst_n_r;
wire [1:0]                                  bmcctl_uart_sw;
wire                                        fan_dbg_mode;
wire [15:0]                                 mb_cpld2_ver;

wire [7:0]                                  i2c_ram_1050;
wire [7:0]                                  i2c_ram_1051;
wire [7:0]                                  i2c_ram_1052;
wire [7:0]                                  i2c_ram_1053;
wire [7:0]                                  i2c_ram_1054;
wire [7:0]                                  i2c_ram_1055;
wire [7:0]                                  i2c_ram_1056;
wire [7:0]                                  i2c_ram_1057;
wire [7:0]                                  i2c_ram_1058;

wire                                        pca_revision_0;
wire                                        pca_revision_1;
wire                                        pca_revision_2;
wire                                        pcb_revision_0;
wire                                        pcb_revision_1;
wire [15:0]                                 bmc_cpld_version;
wire [2:0]                                  db_chassis_id;
wire [2:0]                                  chassis_id;
wire [1:0]                                  mb_class_id;
wire [3:0]                                  led_custom_mode;
wire                                        mb_t1hz_clk;
wire                                        board_id5;
wire                                        board_id6;
wire                                        board_id7;
wire                                        power_on_off;
wire [7:0]                                  pf_class0_b0;
wire [7:0]                                  pf_class0_b1;
wire [7:0]                                  pf_class0_b2;
wire [7:0]                                  pf_class0_b3;
wire [7:0]                                  pf_class1_b0;
wire [7:0]                                  pf_class1_b1;
wire [7:0]                                  pf_class2_b0;
wire [7:0]                                  pf_class2_b1;
wire [7:0]                                  pf_class4_b0;
wire [7:0]                                  pf_class5_b0;
wire [7:0]                                  pf_class6_b0;
wire [7:0]                                  pf_class9_b0;
wire [7:0]                                  pf_classa_b0;



wire                                        bmc_security_bypass;
wire                                        bios_security_bypass;
wire                                        bmc_read_flag;
wire                                        bmc_read_flag_1;
wire [39:0]                                 pfr_to_led;
wire [7:0]                                  led_class_date1;
wire [7:0]                                  led_class_date2;
wire [7:0]                                  led_class_date3;
wire [7:0]                                  led_class_date4;
wire [7:0]                                  led_class_date5;

wire [7:0]                                  s_ocp_act_n;
wire [7:0]                                  s_ocp_link_n;
wire [7:0]                                  s_ocp2_act_n;
wire [7:0]                                  s_ocp2_link_n;
wire                                        ocp2_pvt_link_spdb_p5_n;       
wire                                        ocp2_pvt_act_p5_n;             
wire                                        ocp2_pvt_link_spda_p6_n;      
wire                                        ocp2_pvt_link_spdb_p6_n;       
wire                                        ocp2_pvt_act_p6_n;             
wire                                        ocp2_pvt_link_spda_p7_n;      
wire                                        ocp2_pvt_link_spdb_p7_n;       
wire                                        ocp2_pvt_act_p7_n;             
wire                                        ocp2_pvt_act_p2_n;             
wire                                        ocp2_pvt_link_spda_p3_n;       
wire                                        ocp2_pvt_link_spdb_p3_n;       
wire                                        ocp2_pvt_act_p3_n;             
wire                                        ocp2_pvt_link_spda_p4_n;       
wire                                        ocp2_pvt_link_spdb_p4_n;       
wire                                        ocp2_pvt_act_p4_n;             
wire                                        ocp2_pvt_link_spda_p5_n;       
wire                                        ocp2_pvt_link_spda_p0_n;       
wire                                        ocp2_pvt_link_spdb_p0_n;       
wire                                        ocp2_pvt_act_p0_n;             
wire                                        ocp2_pvt_link_spda_p1_n;       
wire                                        ocp2_pvt_link_spdb_p1_n;       
wire                                        ocp2_pvt_act_p1_n;             
wire                                        ocp2_pvt_link_spda_p2_n;       
wire                                        ocp2_pvt_link_spdb_p2_n;       
wire                                        ocp2_pvt_prsntb0_n;            
wire                                        ocp2_pvt_prsntb1_n;            
wire                                        ocp2_pvt_prsntb2_n;            
wire                                        ocp2_pvt_prsntb3_n;           
wire                                        ocp2_pvt_wake_n;               
wire                                        ocp2_pvt_temp_warn_n;         
wire                                        ocp2_pvt_temp_crit_n;          
wire                                        ocp2_pvt_fan_on_aux;           
wire                                        ocp_pvt_link_spdb_p5_n;        
wire                                        ocp_pvt_act_p5_n;              
wire                                        ocp_pvt_link_spda_p6_n;        
wire                                        ocp_pvt_link_spdb_p6_n;        
wire                                        ocp_pvt_act_p6_n;              
wire                                        ocp_pvt_link_spda_p7_n;        
wire                                        ocp_pvt_link_spdb_p7_n;       
wire                                        ocp_pvt_act_p7_n;              
wire                                        ocp_pvt_act_p2_n;              
wire                                        ocp_pvt_link_spda_p3_n;        
wire                                        ocp_pvt_link_spdb_p3_n;        
wire                                        ocp_pvt_act_p3_n;              
wire                                        ocp_pvt_link_spda_p4_n;        
wire                                        ocp_pvt_link_spdb_p4_n;        
wire                                        ocp_pvt_act_p4_n;              
wire                                        ocp_pvt_link_spda_p5_n;        
wire                                        ocp_pvt_link_spda_p0_n;        
wire                                        ocp_pvt_link_spdb_p0_n;        
wire                                        ocp_pvt_act_p0_n;              
wire                                        ocp_pvt_link_spda_p1_n;        
wire                                        ocp_pvt_link_spdb_p1_n;        
wire                                        ocp_pvt_act_p1_n;              
wire                                        ocp_pvt_link_spda_p2_n;        
wire                                        ocp_pvt_link_spdb_p2_n;        
wire                                        ocp_pvt_prsntb0_n;             
wire                                        ocp_pvt_prsntb1_n;             
wire                                        ocp_pvt_prsntb2_n;             
wire                                        ocp_pvt_prsntb3_n;             
wire                                        ocp_pvt_wake_n;               
wire                                        ocp_pvt_temp_warn_n;           
wire                                        ocp_pvt_temp_crit_n;           
wire                                        ocp_pvt_fan_on_aux;
wire                                        db_ocp_pvt_fan_on_aux;
wire                                        db_ocp2_pvt_fan_on_aux;
wire                                        pal_ocp1_ncsi_en;
wire                                        pal_ocp2_ncsi_en;
wire                                        pal_ocp_ncsi_sw_en;

wire                                        auxint; 
wire                                        pme_event;
wire                                        pfr_pe_wake_n;     
wire                                        db_pme_source_all;
wire                                        dsd_uart_prsnt_n;
wire                                        db_i_dsd_uart_prsnt_n;
wire                                        db_i_leakage_prsnt_n;
wire                                        db_i_break_det_do_n;
wire                                        db_i_leakage_det_do_n;
wire                                        db_i_pal_ocp1_fan_foo;
wire                                        db_i_pal_ocp2_fan_foo;
wire                                        db_i_pal_ocp2_fan_prsnt_n;
wire                                        pal_gpu_fan1_foo;
wire                                        pal_gpu_fan2_foo;
wire                                        pal_gpu_fan3_foo;
wire                                        pal_gpu_fan4_foo;
wire                                        pal_gpu_fan4_prsnt;
wire                                        pal_gpu_fan3_prsnt;
wire                                        pal_gpu_fan2_prsnt;
wire                                        pal_gpu_fan1_prsnt;
wire                                        lom_thermal_trip;
wire                                        lom_prsnt_n;
wire                                        cpu0_temp_over;
wire                                        cpu1_temp_over;
wire                                        bmc_pgd_p0v8_stby;
wire                                        bmc_pgd_p1v1_stby;
wire                                        bmc_pgd_p1v2_stby;
wire                                        bmc_pgd_p1v8_stby;
wire                                        bmc_pgd_p3v3_stby;
wire                                        bmc_ready_flag; // 从CPLD获取BMC就绪标志
wire                                        w_sys_healthy_red;
wire                                        w_sys_healthy_grn;

wire                                        bmcctl_front_nic_led;
wire                                        nic_led_bmc_ctl;
wire                                        pfr_vpp_alert;
wire                                        usb3_right_ear_en;
wire                                        usb2_left_ear_en;
wire                                        rtc_select_n;
wire                                        cpu1_vr_select_n;
wire                                        cpu0_vr_select_n;
wire [`NUM_NIC-1:0]                         ocp_fault_det1;
wire [`NUM_NIC-1:0]                         ocp_fault_det2;
wire                                        db_i_pal_usb_upd2_oci1b;
wire                                        db_i_pal_usb_upd2_oci2b;
wire                                        db_i_pal_usb_upd1_oci4b;
wire                                        pal_upd72020_1_alart;
wire                                        pal_upd72020_2_alart;
wire                                        vga2_oc_alert;
wire                                        usb2_lcd_alert;
wire                                        db_pal_upd72020_1_alart;
wire                                        db_pal_upd72020_2_alart;
wire                                        db_vga2_oc_alert;
wire                                        db_usb2_lcd_alert;
wire                                        pgd_p1v8_stby_dly32ms;
wire                                        pgd_p1v8_stby_dly30ms;
wire                                        bios_read_flag;
wire                                        machine_rev;

wire [7:0]                                  bios_post_rate;
wire [7:0]                                  bios_post_phase;

wire [3:0]                                  bmc_card_type                 ; // 已使用   SCPLD -> MCPLD    addr 0x0070[7:4]        
wire [2:0]                                  bmc_card_pcb_rev              ; // 已使用   SCPLD -> MCPLD    addr 0x0070[3:1]        

wire [7:0]                                  riser1_pvti_byte3             ; // 未使用   SCPLD -> MCPLD 
wire [7:0]                                  riser1_pvti_byte2             ; // 未使用   SCPLD -> MCPLD 
wire [7:0]                                  riser1_pvti_byte1             ; // 未使用   SCPLD -> MCPLD 
wire [7:0]                                  riser1_pvti_byte0             ; // 未使用   SCPLD -> MCPLD 
wire [7:0]                                  riser2_pvti_byte3             ; // 未使用   SCPLD -> MCPLD 
wire [7:0]                                  riser2_pvti_byte2             ; // 未使用   SCPLD -> MCPLD 
wire [7:0]                                  riser2_pvti_byte1             ; // 未使用   SCPLD -> MCPLD 
wire [7:0]                                  riser2_pvti_byte0             ; // 未使用   SCPLD -> MCPLD 

wire                                        riser1_cb_prsnt_slot1_n       ; // 未使用   SCPLD -> MCPLD
wire                                        riser1_cb_prsnt_slot2_n       ; // 未使用   SCPLD -> MCPLD
wire                                        riser1_cb_prsnt_slot3_n       ; // 未使用   SCPLD -> MCPLD

wire                                        riser1_pwr_det0               ; // 未使用   SCPLD -> MCPLD
wire                                        riser1_pwr_det1               ; // 未使用   SCPLD -> MCPLD
wire                                        riser1_pcb_rev0               ; // 未使用   SCPLD -> MCPLD
wire                                        riser1_pcb_rev1               ; // 未使用   SCPLD -> MCPLD

wire                                        riser1_pwr_alert_n            ; // 已使用   pwrseq_slave
wire                                        riser1_emc_alert_n            ; // 未使用   SCPLD -> MCPLD

wire                                        riser1_slot1_prsnt_n          ; // 未使用   SCPLD -> MCPLD
wire                                        riser1_slot2_prsnt_n          ; // 未使用   SCPLD -> MCPLD
wire                                        riser1_slot3_prsnt_n          ; // 未使用   SCPLD -> MCPLD

wire [5:0]                                  riser1_id                     ; // 未使用   SCPLD -> MCPLD

wire                                        pal_riser1_pwrgd              ; // 已使用   pwrseq_slave
wire                                        pal_riser1_pe_wake_n          ; // 未使用   SCPLD -> MCPLD

wire                                        riser2_cb_prsnt_slot1_n       ; // 未使用   SCPLD -> MCPLD
wire                                        riser2_cb_prsnt_slot2_n       ; // 未使用   SCPLD -> MCPLD
wire                                        riser2_cb_prsnt_slot3_n       ; // 未使用   SCPLD -> MCPLD

wire                                        riser2_pwr_det0               ; // 未使用   SCPLD -> MCPLD
wire                                        riser2_pwr_det1               ; // 未使用   SCPLD -> MCPLD
wire                                        riser2_pcb_rev0               ; // 未使用   SCPLD -> MCPLD
wire                                        riser2_pcb_rev1               ; // 未使用   SCPLD -> MCPLD

wire                                        riser2_pwr_alert_n            ; // 已使用   pwrseq_slave
wire                                        riser2_emc_alert_n            ; // 未使用   SCPLD -> MCPLD

wire                                        riser2_slot1_prsnt_n          ; // 未使用   SCPLD -> MCPLD
wire                                        riser2_slot2_prsnt_n          ; // 未使用   SCPLD -> MCPLD
wire                                        riser2_slot3_prsnt_n          ; // 未使用   SCPLD -> MCPLD

wire [5:0]                                  riser2_id                     ; // 未使用   SCPLD -> MCPLD

wire                                        pal_riser2_pwrgd              ; // 未使用   SCPLD -> MCPLD
wire                                        pal_riser2_pe_wake_n          ; // 未使用   SCPLD -> MCPLD

wire [3:0]                                  riser2_pwr_cable_prsnt_n      ; // 未使用   SCPLD -> MCPLD
wire [3:0]                                  riser1_pwr_cable_prsnt_n      ; // 未使用   SCPLD -> MCPLD
wire                                        w4GpuRiser2Flag               ; // 未使用   SCPLD -> MCPLD
wire                                        w4GpuRiser1Flag               ; // 未使用   SCPLD -> MCPLD

wire                                        riser3_slot7_prsnt_n          ; // 未使用   SCPLD -> MCPLD
wire                                        riser3_slot8_prsnt_n          ; // 未使用   SCPLD -> MCPLD
wire                                        riser4_slot9_prsnt_n          ; // 未使用   SCPLD -> MCPLD
wire                                        riser4_slot10_prsnt_n         ; // 未使用   SCPLD -> MCPLD

wire                                        riser3_1_prsnt_n              ; // 未使用   SCPLD -> MCPLD
wire                                        riser3_2_prsnt_n              ; // 未使用   SCPLD -> MCPLD
wire                                        riser4_1_prsnt_n              ; // 未使用   SCPLD -> MCPLD
wire                                        riser4_2_prsnt_n              ; // 未使用   SCPLD -> MCPLD

wire                                        riser4_2_pwr_en               ; // 未使用 
wire                                        riser4_1_pwr_en               ; // 未使用 
wire                                        riser3_2_pwr_en               ; // 未使用 
wire                                        riser3_1_pwr_en               ; // 未使用 
wire                                        riser2_pwr_en                 ; 
wire                                        riser1_pwr_en                 ; 

wire [5:0]                                  riser3_slot7_id               ; // 未使用   SCPLD -> MCPLD
wire [5:0]                                  riser3_slot8_id               ; // 未使用   SCPLD -> MCPLD
wire [5:0]                                  riser4_slot9_id               ; // 未使用   SCPLD -> MCPLD
wire [5:0]                                  riser4_slot10_id              ; // 未使用   SCPLD -> MCPLD

wire                                        db_riser_prsnt_det_2          ; // 未使用   SCPLD -> MCPLD
wire                                        db_riser_prsnt_det_3          ; // 未使用   SCPLD -> MCPLD
wire                                        db_riser_prsnt_det_0          ; // 未使用   SCPLD -> MCPLD
wire                                        db_riser_prsnt_det_1          ; // 未使用   SCPLD -> MCPLD
wire                                        db_i_riser_prsnt_det_9        ; // 未使用   SCPLD -> MCPLD
wire                                        db_i_riser_prsnt_det_8        ; // 未使用   SCPLD -> MCPLD
wire                                        db_riser_prsnt_det_6          ; // 未使用   SCPLD -> MCPLD
wire                                        db_riser_prsnt_det_7          ; // 未使用   SCPLD -> MCPLD
wire                                        db_riser_prsnt_det_4          ; // 未使用   SCPLD -> MCPLD
wire                                        db_riser_prsnt_det_5          ; // 未使用   SCPLD -> MCPLD
wire                                        db_i_riser_prsnt_det_11       ; // 未使用   SCPLD -> MCPLD
wire                                        db_i_riser_prsnt_det_10       ; // 未使用   SCPLD -> MCPLD

wire [7:0]                                  db_bp_aux_pg                  ; // 未使用
wire [7:0]                                  bp_int                        ; // 未使用
wire [7:0]                                  bp_power_good                 ; // 未使用
wire [7:0]                                  bp_prsnt                      ; // 已使用   SCPLD -> MCPLD    addr 0x0071[7:0]   

wire [31:0]                                 AUX_BP_type                   ; // 未使用   MCPLD -> SCPLD
wire [127:0]                                pcie_detect                   ; // 未使用   MCPLD -> SCPLD
wire [7:0]                                  pcie_detect_int               ; // 未使用   

wire [15:0]                                 o_mb_cb_prsnt_bmc             ; // 未使用   MCPLD -> SCPLD
wire [7:0]                                  debug_reg_15                  ; // 未使用   MCPLD -> SCPLD
wire [15:0]                                 mb_cb_prsnt                   ; // 未使用   SCPLD -> MCPLD
wire [19:0]                                 riser_ocp_m2_slot_number      ; // 未使用   SCPLD -> MCPLD    0x30[7:0],0x31[7:0],0x32[2:0]
wire [43:0]                                 nvme_slot_number              ; // 未使用   SCPLD -> MCPLD    0x37[6:0],0x36[7:0],0x35[7:0],0x34[7:0],0x33[7:0],0x32[7:3]

wire gmt_fail_n = 1'b1;
//d00412 end

/*-----------------------------------------------------------------------------------------------------------------------------------------------
系统时钟: input 25MHz, output 100MHz/50MHz/25MHz
------------------------------------------------------------------------------------------------------------------------------------------------*/
pll_i25M_o50M_o25M pll_inst (
    .clkin1                                 (i_CLK_PAL_IN_25M           ), // input 25.0000MHz
    .rst                                    (~i_PAL_P3V3_STBY_PGD       ), // input
    .clkout0                                (clk_50m                    ), // output 50.00000000MHz
    .clkout1                                (clk_25m                    ), // output 25.00000000MHz
    .lock                                   (pll_lock                   )  // output

);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
全局复位 
------------------------------------------------------------------------------------------------------------------------------------------------*/
pon_reset pon_reset_inst( 
    .clk                                    (clk_50m                    ),// input:  复位/PGD 同步时钟源（25MHz）
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
    .clk                                    (clk_50m                    ),
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
    .clk(clk_50m),
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
		 i_PAL_BMCUID_BUTTON_R                    ,//11
		 //chassis_id0_n                          ,//13
		 //chassis_id1_n                          ,//14
		 //chassis_id2_n                          ,//15
		 i_PAL_USB_UPD2_OCI1B                   ,//16
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
		 db_i_pal_bmcuid_button_r                 ,//11
		 //db_chassis_id[0]                         ,//13
		 //db_chassis_id[1]                         ,//14
		 //db_chassis_id[2]                         ,//15
		 db_i_pal_usb_upd2_oci1b                  ,//16
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
    .SIGCNT                                 (51                         ), 
    .NBITS                                  (2'b11                      ), 
    .ENABLE                                 (1'b1                       )
) db_inst_cpu_rail (
    .clk                                    (clk_50m                    ),
    .rst                                    (~pon_reset_n               ),
    .timer_tick                             (1'b1                       ),
    .din                                    (
                                            {
                                            i_PAL_P12V_CPU1_VIN_PG              ,// 50
                                            i_PAL_P12V_CPU0_VIN_PG              ,// 49
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
                                            db_i_pal_p12v_cpu1_vin_pg           ,// 50
                                            db_i_pal_p12v_cpu0_vin_pg           ,// 49
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
// 未使用
PGM_DEBOUNCE_N #(.SIGCNT(8), .NBITS(2'b11), .ENABLE(1'b1)) db_bp_pgood_fault (
    .clk                               (clk_50m                    ),
    .rst_n                             (pon_reset_n                ),
    .timer_tick                        (1'b1                       ),
    .din                               ({
		                                    bp_power_good[7:0]                  		
                                       }),
    .dout                              ({
		                                    db_bp_aux_pg[7:0]              		 
		                                   })		 
 );

// 机箱入侵检测信号消抖
PGM_DEBOUNCE_N #(.SIGCNT(1), .NBITS(2'b11), .ENABLE(1'b1)) db_intruder (
    .clk			                        (clk_50m                   ),
    .rst_n		                            (pon_reset_n                ),
    .timer_tick	                            (t512us_tick                ),
    .din                                    ({
	                                        i_FRONT_PAL_INTRUDER       //01
	        
	                                        }),             
  .dout                                     ({
	                                        db_i_front_pal_intruder    //01
	                                        }) 
);


// PSU DCOK 信号消抖
PGM_DEBOUNCE #(.SIGCNT(2), .NBITS(2'b10), .ENABLE(1'b1)) db_inst_psu (
  .clk                                      (clk_50m                   ),
  .rst                                      (~pon_reset_n               ),
  .timer_tick                               (t64ms_tick                 ),
  .din                                      ({
	                                         i_PAL_PS1_DCOK          ,//01
		                                     i_PAL_PS2_DCOK           //02
                                            }),             
    .dout                                   ({
                                             db_i_ps1_dc_ok          ,//01    
                                             db_i_ps2_dc_ok           //02 
                                            }) 
);

// 风扇/OCP/NVME等在位信号消抖
PGM_DEBOUNCE #(.SIGCNT(47), .NBITS (2'b10), .ENABLE(1'b1)) db_inst_prsnt(
    .clk                                    (clk_50m),
    .timer_tick                             (t512us_tick),
    .rst                                    (~pon_reset_n),
    .din                                    ({	
                                            fan1_install_n            ,//01
                                            fan2_install_n            ,//02
                                            fan3_install_n            ,//03
                                            fan4_install_n            ,//04
                                            fan5_install_n            ,//05
                                            fan6_install_n            ,//06
                                            fan7_install_n            ,//07
                                            fan8_install_n            ,//08
		                                        ocp1_prsnt_n              ,//09
		                                        ocp2_prsnt_n              ,//10
		                                        cpu_nvme17_prsnt_n        ,//11
		                                        cpu_nvme16_prsnt_n        ,//12
		                                        cpu_nvme15_prsnt_n        ,//13
		                                        cpu_nvme14_prsnt_n        ,//14
		                                        cpu_nvme13_prsnt_n        ,//15
		                                        cpu_nvme12_prsnt_n        ,//16
		                                        cpu_nvme11_prsnt_n        ,//17
		                                        cpu_nvme10_prsnt_n        ,//18
		                                        cpu_nvme19_prsnt_n        ,//19
		                                        cpu_nvme18_prsnt_n        ,//20
		                                        cpu_nvme23_prsnt_n        ,//21
		                                        cpu_nvme22_prsnt_n        ,//22
		                                        cpu_nvme7_prsnt_n         ,//23
		                                        cpu_nvme6_prsnt_n         ,//24
		                                        cpu_nvme5_prsnt_n         ,//25
		                                        cpu_nvme4_prsnt_n         ,//26
		                                        cpu_nvme3_prsnt_n         ,//27
		                                        cpu_nvme2_prsnt_n         ,//28
		                                        cpu_nvme1_prsnt_n         ,//29
		                                        cpu_nvme0_prsnt_n         ,//30
		                                        cpu_nvme9_prsnt_n         ,//31
		                                        cpu_nvme8_prsnt_n         ,//32
		                                        cpu_nvme25_prsnt_n        ,//33
		                                        cpu_nvme24_prsnt_n        ,//34
		                                        ~i_PAL_PS1_PRSNT          ,//35
		                                        ~i_PAL_PS2_PRSNT          ,//36
		                                        pal_riser1_prsnt_n        ,//37
		                                        pal_riser2_prsnt_n        ,//38
		                                        tpm_prsnt_n               ,//39
		                                        i_INTRUDER_CABLE_INST_N   ,//40
		                                        i_PAL_OCP1_FAN_PRSNT_N    ,//41
		                                        //i_PAL_GPU_FAN1_PRSNT      ,//42
		                                        //i_PAL_GPU_FAN2_PRSNT      ,//43
		                                        //i_PAL_GPU_FAN3_PRSNT      ,//44
		                                        //i_PAL_GPU_FAN4_PRSNT      ,//45
		                                        i_PAL_BMC_CARD_PRSNT_N    ,//46
		                                        dsd_uart_prsnt_n          ,//47
		                                        i_LEAKAGE_PRSNT_N         ,//48
		                                        i_BREAK_DET_DO_N          ,//49
		                                        i_LEAKAGE_DET_DO_N        ,//50
		                                        i_PAL_OCP1_FAN_FOO         //51
	  }),                   
    .dout                                   ({
                                            db_fan_prsnt_n[0]         ,//1
                                            db_fan_prsnt_n[1]         ,//2
                                            db_fan_prsnt_n[2]         ,//3
                                            db_fan_prsnt_n[3]         ,//4
                                            db_fan_prsnt_n[4]         ,//5
                                            db_fan_prsnt_n[5]         ,//6
                                            db_fan_prsnt_n[6]         ,//7
                                            db_fan_prsnt_n[7]         ,//8
		                                        db_ocp1_prsnt_n           ,//9
		                                        db_ocp2_prsnt_n           ,//10
		                                        db_cpu_nvme17_prsnt_n     ,//11
		                                        db_cpu_nvme16_prsnt_n     ,//12
		                                        db_cpu_nvme15_prsnt_n     ,//13
		                                        db_cpu_nvme14_prsnt_n     ,//14
		                                        db_cpu_nvme13_prsnt_n     ,//15
		                                        db_cpu_nvme12_prsnt_n     ,//16
		                                        db_cpu_nvme11_prsnt_n     ,//17
		                                        db_cpu_nvme10_prsnt_n     ,//18
		                                        db_cpu_nvme19_prsnt_n     ,//19
		                                        db_cpu_nvme18_prsnt_n     ,//20
		                                        db_cpu_nvme23_prsnt_n     ,//21
		                                        db_cpu_nvme22_prsnt_n     ,//22
		                                        db_cpu_nvme7_prsnt_n      ,//23
		                                        db_cpu_nvme6_prsnt_n      ,//24
		                                        db_cpu_nvme5_prsnt_n      ,//25
		                                        db_cpu_nvme4_prsnt_n      ,//26
		                                        db_cpu_nvme3_prsnt_n      ,//27
		                                        db_cpu_nvme2_prsnt_n      ,//28
		                                        db_cpu_nvme1_prsnt_n      ,//29
		                                        db_cpu_nvme0_prsnt_n      ,//30
		                                        db_cpu_nvme9_prsnt_n      ,//31
		                                        db_cpu_nvme8_prsnt_n      ,//32
		                                        db_cpu_nvme25_prsnt_n     ,//33
		                                        db_cpu_nvme24_prsnt_n     ,//34
		                                        db_ps_prsnt_n[0]          ,//35
		                                        db_ps_prsnt_n[1]          ,//36
		                                        db_pal_riser1_prsnt_n     ,//37
		                                        db_pal_riser2_prsnt_n     ,//38
		                                        db_tpm_prsnt_n            ,//39
		                                        db_i_intruder_cable_inst_n,//40
		                                        db_i_pal_ocp1_fan_prsnt_n ,//41
		                                        //db_i_pal_gpu_fan_prsnt[0] ,//42
		                                        //db_i_pal_gpu_fan_prsnt[1] ,//43
		                                        //db_i_pal_gpu_fan_prsnt[2] ,//44
		                                        //db_i_pal_gpu_fan_prsnt[3] ,//45
		                                        db_i_pal_bmc_card_prsnt_n ,//46 // 未使用
		                                        db_i_dsd_uart_prsnt_n     ,//47
		                                        db_i_leakage_prsnt_n      ,//48
		                                        db_i_break_det_do_n       ,//49
		                                        db_i_leakage_det_do_n     ,//50
		                                        db_i_pal_ocp1_fan_foo      //51
	   })
);

// EMC_ALERT 和 GMT_FAIL 信号消抖
PGM_DEBOUNCE #(.SIGCNT(2), .NBITS(2'b11), .ENABLE(1'b1)) db_pgood_fault2_n (
    .clk(clk_50m),
    .rst(~pon_reset_n),
    .timer_tick(1'b1),
    .din({           
        emc_alert_n              ,//01
		    gmt_fail_n                //02
        }),
    .dout({
        db_emc_alert_n           ,//01
		    db_gmt_fail_n             //02 // 未使用
      })
);

// 低速信号同步
SYNC_DATA_N #(.SIGCNT(3)) sync_data_low (
    .clk    (clk_50m),
    .rst_n  (pon_reset_n),
    .din    ({
             vwire_bmc_shutdown,       //01
		     ocp_pvt_fan_on_aux,       //02
		     ocp2_pvt_fan_on_aux       //03
	         }),           
    .dout   ({
            s_bmc_shutdown,           //01
		    db_ocp_pvt_fan_on_aux,    //02
		    db_ocp2_pvt_fan_on_aux    //03
		    })   
);

// 高速信号同步
SYNC_DATA #(.SIGCNT(5)) sync_data_high1 (
    .clk    (clk_50m),
    .rst    (~pon_reset_n),
    .din    ({
		     ~vwire_bmc_wakeup              ,     //01
		     ~vwire_bmc_sysrst              ,     //02
		     ~vwire_cpu_rst_pcie            ,     //03
		     i_PAL_CPU0_VR_PMALT_UPD        ,     //04
		     i_PAL_CPU1_VR_PMALT_UPD              //05    
            }),      
    .dout   ({
		    s_bmc_wakeup_n                 ,     //01
		    s_bmc_sysrst_n                 ,     //02
		    s_cpu_rst_pcie_n               ,     //03 
		    s_vr_cpu_i2c_alert_n[0]        ,     //04
            s_vr_cpu_i2c_alert_n[1]              //05
         })        
);

// OCP/NVME PVT信号同步
SYNC_DATA #(.SIGCNT(32)) sync_data_ocp (
    .clk    (clk_50m),
    .rst    (~pon_reset_db_n),
    .din    ({ocp_pvt_act_p0_n,//01
    		  ocp_pvt_act_p1_n,//02
    		  ocp_pvt_act_p2_n,//03
    		  ocp_pvt_act_p3_n,//04
    		  ocp_pvt_act_p4_n,//05
    		  ocp_pvt_act_p5_n,//06
              ocp_pvt_act_p6_n,//07
              ocp_pvt_act_p7_n,//08
              ocp_pvt_link_spda_p0_n & ocp_pvt_link_spdb_p0_n,//09
              ocp_pvt_link_spda_p1_n & ocp_pvt_link_spdb_p1_n,//10
              ocp_pvt_link_spda_p2_n & ocp_pvt_link_spdb_p2_n,//11
              ocp_pvt_link_spda_p3_n & ocp_pvt_link_spdb_p3_n,//12
    		  ocp_pvt_link_spda_p4_n & ocp_pvt_link_spdb_p4_n,//13
              ocp_pvt_link_spda_p5_n & ocp_pvt_link_spdb_p5_n,//14
              ocp_pvt_link_spda_p6_n & ocp_pvt_link_spdb_p6_n,//15
              ocp_pvt_link_spda_p7_n & ocp_pvt_link_spdb_p7_n,//16
    		  ocp2_pvt_act_p0_n,//17
    		  ocp2_pvt_act_p1_n,//18
    		  ocp2_pvt_act_p2_n,//19
    		  ocp2_pvt_act_p3_n,//20
    		  ocp2_pvt_act_p4_n,//21
    		  ocp2_pvt_act_p5_n,//22
    		  ocp2_pvt_act_p6_n,//23
    		  ocp2_pvt_act_p7_n,//24
    		  ocp2_pvt_link_spda_p0_n & ocp2_pvt_link_spdb_p0_n,//25
    		  ocp2_pvt_link_spda_p1_n & ocp2_pvt_link_spdb_p1_n,//26
    		  ocp2_pvt_link_spda_p2_n & ocp2_pvt_link_spdb_p2_n,//27
    		  ocp2_pvt_link_spda_p3_n & ocp2_pvt_link_spdb_p3_n,//28
    		  ocp2_pvt_link_spda_p4_n & ocp2_pvt_link_spdb_p4_n,//29
    		  ocp2_pvt_link_spda_p5_n & ocp2_pvt_link_spdb_p5_n,//30
    		  ocp2_pvt_link_spda_p6_n & ocp2_pvt_link_spdb_p6_n,//31
    		  ocp2_pvt_link_spda_p7_n & ocp2_pvt_link_spdb_p7_n //32		  
            }),      

    .dout   ({s_ocp_act_n[0],//01
    		  s_ocp_act_n[1],//02
    		  s_ocp_act_n[2],//03
    		  s_ocp_act_n[3],//04 
    		  s_ocp_act_n[4],//05
              s_ocp_act_n[5],//06
    		  s_ocp_act_n[6],//07 
    		  s_ocp_act_n[7],//08
              s_ocp_link_n[0],//09	
    		  s_ocp_link_n[1],//10
    		  s_ocp_link_n[2],//11
    		  s_ocp_link_n[3],//12
    		  s_ocp_link_n[4],//13
    		  s_ocp_link_n[5],//14
    		  s_ocp_link_n[6],//15
    		  s_ocp_link_n[7],//16
    		  s_ocp2_act_n[0],//17
    		  s_ocp2_act_n[1],//18
    		  s_ocp2_act_n[2],//19
    		  s_ocp2_act_n[3],//20
    		  s_ocp2_act_n[4],//21
    		  s_ocp2_act_n[5],//22
    		  s_ocp2_act_n[6],//23
    		  s_ocp2_act_n[7],//24
    		  s_ocp2_link_n[0],//25
    		  s_ocp2_link_n[1],//26
    		  s_ocp2_link_n[2],//27
    		  s_ocp2_link_n[3],//28
    		  s_ocp2_link_n[4],//29
    		  s_ocp2_link_n[5],//30
    		  s_ocp2_link_n[6],//31
    		  s_ocp2_link_n[7]//32
             })        
);

// SMB_ALERT 信号消抖
PGM_DEBOUNCE #(.SIGCNT(2), .NBITS(2'b11), .ENABLE(1'b1)) db_inst_alert (
    .clk        (clk_50m),
    .rst        (~pon_reset_n),
    .timer_tick (1'b1),
    .din        ({
                riser1_tmp_alert_n   ,	  //01 
                riser2_tmp_alert_n        //02    
                }),   
    .dout       ({                            
    	        db_riser1_tmp_alert_n,    //01
    	        db_riser2_tmp_alert_n     //02 
    	        })   
);

// SMB_ALERT 信号消抖
PGM_DEBOUNCE #(.SIGCNT(2), .NBITS(2'b10), .ENABLE(1'b1)) db_alert_inst1 (
    .clk        (clk_50m),
    .rst        (~pon_reset_n),
    .timer_tick (1'b1),
    .din        ({
                i_PAL_PS1_SMB_ALERT_TO_FPGA      ,	  //01 
                i_PAL_PS2_SMB_ALERT_TO_FPGA           //02    
                }),   
    .dout       ({                            
    	        db_i_ps1_smb_alert               ,    //01
    	        db_i_ps2_smb_alert                    //02 
    	        })   
);

// CPU 反馈的复位信号, PEU_PREST控制状态机跳转, 其他写入寄存器监控使用
PGM_DEBOUNCE #(
    .SIGCNT                                 (26                         ), 
    .NBITS                                  (2'b11                      ), 
    .ENABLE                                 (1'b1                       )
) db_inst_cpu_rail (
    .clk                                    (clk_50m                    ),
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

/*-----------------------------------------------------------------------------------------------------------------------------------------------
SGPIO 信号处理 M_CPLD<->S_CPLD
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                        t1hz_clk_cmu                ;
wire                                        t2p5hz_clk_scpld            ;

wire [511:0]                                mcpld_to_scpld_p2s_data     ;
wire [511:0]                                scpld_to_mcpld_s2p_data     ;
wire                                        scpld_sgpio_ld_n            ;
wire                                        scpld_sgpio_clk             ;

reg [426:0]	                                scpld_to_mcpld_data_filter  ;
reg 	                                    scpld_sgpio_fail            ;

always@(posedge clk_50m or negedge pon_reset_n)begin
	if(~pon_reset_n)
		begin
			scpld_to_mcpld_data_filter <= {427{1'b0}};
			scpld_sgpio_fail <=1'b0;
		end
	else if
		((scpld_to_mcpld_s2p_data[3:0] == 4'b0101)&& (scpld_to_mcpld_s2p_data[511:508] == 4'b1010))
		begin
			scpld_to_mcpld_data_filter <= scpld_to_mcpld_s2p_data[430:4];
			scpld_sgpio_fail <=1'b0;
		end
	else
		begin
			scpld_to_mcpld_data_filter <= scpld_to_mcpld_data_filter;
			scpld_sgpio_fail <=1'b1;
		end
end


//S CPLD ---> M CPLD
s2p_master #(.NBIT(512)) inst_scpld_to_mcpld_s2p(
    .clk            (clk_50m					), //in
    .rst            (~pon_reset_n				), //in
    .tick           (t1us_tick					), //in
    .si             (i_CPLD_M_S_SGPIO_MISO		), //in   //SGPIO_MISO  Serial Signal input
    .po             (scpld_to_mcpld_s2p_data	), //out  //Parallel Signal output
    .sld_n          (scpld_sgpio_ld_n			), //out  //SGPIO_LOAD
    .sclk           (scpld_sgpio_clk 			)  //out  //SGPIO_CLK
);

assign o_CPLD_M_S_SGPIO_LD_N_R = scpld_sgpio_ld_n; //SGPIO_LOAD
assign o_CPLD_M_S_SGPIO_CLK_R  = scpld_sgpio_clk ;  //SGPIO_CLK

//M CPLD  ---> S CPLD
p2s_slave #(.NBIT(512)) inst_mcpld_to_scpld_p2s(
	.clk            (clk_50m					),//in
	.rst            (~pon_reset_n				),//in
	.pi             (mcpld_to_scpld_p2s_data	),//in   //Parallel Signal input
	.so             (o_CPLD_M_S_SGPIO_MOSI_R 	),//out  //SGPIO_MOSI Serial Signal output
	.sld_n          (o_CPLD_M_S_SGPIO_LD_N_R	),//in   //SGPIO_LOAD
	.sclk           (o_CPLD_M_S_SGPIO_CLK_R		) //in   //SGPIO_CLK
);

//S CPLD ---> M CPLD
assign  bmc_ready_flag                = scpld_to_mcpld_data_filter[426];
assign  bmc_pgd_p3v3_stby             = scpld_to_mcpld_data_filter[425];
assign  bmc_pgd_p1v8_stby             = scpld_to_mcpld_data_filter[424];
assign  bmc_pgd_p1v2_stby             = scpld_to_mcpld_data_filter[423];
assign  bmc_pgd_p1v1_stby             = scpld_to_mcpld_data_filter[422];
assign  bmc_pgd_p0v8_stby             = scpld_to_mcpld_data_filter[421];
assign  cpu1_temp_over                = scpld_to_mcpld_data_filter[420];
assign  cpu0_temp_over                = scpld_to_mcpld_data_filter[419];
assign  lom_prsnt_n                   = scpld_to_mcpld_data_filter[418];
assign  lom_thermal_trip              = scpld_to_mcpld_data_filter[417];
assign  db_i_pal_ocp2_fan_prsnt_n     = scpld_to_mcpld_data_filter[416];
assign  db_i_pal_ocp2_fan_foo         = scpld_to_mcpld_data_filter[415];
assign  db_i_pal_lcd_card_in          = scpld_to_mcpld_data_filter[414];
assign  ifist_prsnt_n                 = scpld_to_mcpld_data_filter[413];
assign  bios_post_code[7:0]           = scpld_to_mcpld_data_filter[412:405];
assign  bios_post_phase[7:0]          = scpld_to_mcpld_data_filter[404:397];
assign  bios_post_rate[7:0]           = scpld_to_mcpld_data_filter[396:389];
assign  bios_read_flag                = scpld_to_mcpld_data_filter[388];
assign  bp_prsnt[7:0]                 = scpld_to_mcpld_data_filter[387:380];
assign  usb2_lcd_alert                = scpld_to_mcpld_data_filter[379];
assign  vga2_oc_alert                 = scpld_to_mcpld_data_filter[378];
assign  pal_upd72020_2_alart          = scpld_to_mcpld_data_filter[377];
assign  pal_upd72020_1_alart          = scpld_to_mcpld_data_filter[376];
assign  usb3_right_ear_en             = scpld_to_mcpld_data_filter[375];
assign  usb2_left_ear_en              = scpld_to_mcpld_data_filter[374];
assign  dsd_uart_prsnt_n              = scpld_to_mcpld_data_filter[373];
assign  pfr_pe_wake_n                 = scpld_to_mcpld_data_filter[372];
assign  ocp2_pvt_link_spdb_p5_n       = scpld_to_mcpld_data_filter[371];//1
assign  ocp2_pvt_act_p5_n             = scpld_to_mcpld_data_filter[370];//1
assign  ocp2_pvt_link_spda_p6_n       = scpld_to_mcpld_data_filter[369];//1
assign  ocp2_pvt_link_spdb_p6_n       = scpld_to_mcpld_data_filter[368];//1
assign  ocp2_pvt_act_p6_n             = scpld_to_mcpld_data_filter[367];//1
assign  ocp2_pvt_link_spda_p7_n       = scpld_to_mcpld_data_filter[366];//1
assign  ocp2_pvt_link_spdb_p7_n       = scpld_to_mcpld_data_filter[365];//1
assign  ocp2_pvt_act_p7_n             = scpld_to_mcpld_data_filter[364];//1
assign  ocp2_pvt_act_p2_n             = scpld_to_mcpld_data_filter[363];//1
assign  ocp2_pvt_link_spda_p3_n       = scpld_to_mcpld_data_filter[362];//1
assign  ocp2_pvt_link_spdb_p3_n       = scpld_to_mcpld_data_filter[361];//1
assign  ocp2_pvt_act_p3_n             = scpld_to_mcpld_data_filter[360];//1
assign  ocp2_pvt_link_spda_p4_n       = scpld_to_mcpld_data_filter[359];//1
assign  ocp2_pvt_link_spdb_p4_n       = scpld_to_mcpld_data_filter[358];//1
assign  ocp2_pvt_act_p4_n             = scpld_to_mcpld_data_filter[357];//1
assign  ocp2_pvt_link_spda_p5_n       = scpld_to_mcpld_data_filter[356];//1
assign  ocp2_pvt_link_spda_p0_n       = scpld_to_mcpld_data_filter[355];//1
assign  ocp2_pvt_link_spdb_p0_n       = scpld_to_mcpld_data_filter[354];//1
assign  ocp2_pvt_act_p0_n             = scpld_to_mcpld_data_filter[353];//1
assign  ocp2_pvt_link_spda_p1_n       = scpld_to_mcpld_data_filter[352];//1
assign  ocp2_pvt_link_spdb_p1_n       = scpld_to_mcpld_data_filter[351];//1
assign  ocp2_pvt_act_p1_n             = scpld_to_mcpld_data_filter[350];//1
assign  ocp2_pvt_link_spda_p2_n       = scpld_to_mcpld_data_filter[349];//1
assign  ocp2_pvt_link_spdb_p2_n       = scpld_to_mcpld_data_filter[348];//1
assign  ocp2_pvt_prsntb0_n            = scpld_to_mcpld_data_filter[347];//1
assign  ocp2_pvt_prsntb1_n            = scpld_to_mcpld_data_filter[346];//1
assign  ocp2_pvt_prsntb2_n            = scpld_to_mcpld_data_filter[345];//1
assign  ocp2_pvt_prsntb3_n            = scpld_to_mcpld_data_filter[344];//1
assign  ocp2_pvt_wake_n               = scpld_to_mcpld_data_filter[343];//1
assign  ocp2_pvt_temp_warn_n          = scpld_to_mcpld_data_filter[342];//1
assign  ocp2_pvt_temp_crit_n          = scpld_to_mcpld_data_filter[341];//1
assign  ocp2_pvt_fan_on_aux           = scpld_to_mcpld_data_filter[340];//0
assign  ocp_pvt_link_spdb_p5_n        = scpld_to_mcpld_data_filter[339];//1
assign  ocp_pvt_act_p5_n              = scpld_to_mcpld_data_filter[338];//1
assign  ocp_pvt_link_spda_p6_n        = scpld_to_mcpld_data_filter[337];//1
assign  ocp_pvt_link_spdb_p6_n        = scpld_to_mcpld_data_filter[336];//1
assign  ocp_pvt_act_p6_n              = scpld_to_mcpld_data_filter[335];//1
assign  ocp_pvt_link_spda_p7_n        = scpld_to_mcpld_data_filter[334];//1
assign  ocp_pvt_link_spdb_p7_n        = scpld_to_mcpld_data_filter[333];//1
assign  ocp_pvt_act_p7_n              = scpld_to_mcpld_data_filter[332];//1
assign  ocp_pvt_act_p2_n              = scpld_to_mcpld_data_filter[331];//1
assign  ocp_pvt_link_spda_p3_n        = scpld_to_mcpld_data_filter[330];//1
assign  ocp_pvt_link_spdb_p3_n        = scpld_to_mcpld_data_filter[329];//1
assign  ocp_pvt_act_p3_n              = scpld_to_mcpld_data_filter[328];//1
assign  ocp_pvt_link_spda_p4_n        = scpld_to_mcpld_data_filter[327];//1
assign  ocp_pvt_link_spdb_p4_n        = scpld_to_mcpld_data_filter[326];//1
assign  ocp_pvt_act_p4_n              = scpld_to_mcpld_data_filter[325];//1
assign  ocp_pvt_link_spda_p5_n        = scpld_to_mcpld_data_filter[324];//1
assign  ocp_pvt_link_spda_p0_n        = scpld_to_mcpld_data_filter[323];//1
assign  ocp_pvt_link_spdb_p0_n        = scpld_to_mcpld_data_filter[322];//1
assign  ocp_pvt_act_p0_n              = scpld_to_mcpld_data_filter[321];//1
assign  ocp_pvt_link_spda_p1_n        = scpld_to_mcpld_data_filter[320];//1
assign  ocp_pvt_link_spdb_p1_n        = scpld_to_mcpld_data_filter[319];//1
assign  ocp_pvt_act_p1_n              = scpld_to_mcpld_data_filter[318];//1
assign  ocp_pvt_link_spda_p2_n        = scpld_to_mcpld_data_filter[317];//1
assign  ocp_pvt_link_spdb_p2_n        = scpld_to_mcpld_data_filter[316];//1
assign  ocp_pvt_prsntb0_n             = scpld_to_mcpld_data_filter[315];//1
assign  ocp_pvt_prsntb1_n             = scpld_to_mcpld_data_filter[314];//1
assign  ocp_pvt_prsntb2_n             = scpld_to_mcpld_data_filter[313];//1
assign  ocp_pvt_prsntb3_n             = scpld_to_mcpld_data_filter[312];//1
assign  ocp_pvt_wake_n                = scpld_to_mcpld_data_filter[311];//1
assign  ocp_pvt_temp_warn_n           = scpld_to_mcpld_data_filter[310];//1
assign  ocp_pvt_temp_crit_n           = scpld_to_mcpld_data_filter[309];//1
assign  ocp_pvt_fan_on_aux            = scpld_to_mcpld_data_filter[308];//0

assign  bmc_card_type                 = scpld_to_mcpld_data_filter[307:304];
assign  bmc_card_pcb_rev              = scpld_to_mcpld_data_filter[303:301];
assign  riser4_slot10_id              = scpld_to_mcpld_data_filter[300:295];
assign  riser4_slot9_id               = scpld_to_mcpld_data_filter[294:289];
assign  riser3_slot8_id               = scpld_to_mcpld_data_filter[288:283];
assign  riser3_slot7_id               = scpld_to_mcpld_data_filter[282:277];
assign  riser4_2_prsnt_n              = scpld_to_mcpld_data_filter[276];
assign  riser4_1_prsnt_n              = scpld_to_mcpld_data_filter[275];
assign  riser3_2_prsnt_n              = scpld_to_mcpld_data_filter[274];
assign  riser3_1_prsnt_n              = scpld_to_mcpld_data_filter[273];
assign  riser4_slot10_prsnt_n         = scpld_to_mcpld_data_filter[272];
assign  riser4_slot9_prsnt_n          = scpld_to_mcpld_data_filter[271];
assign  riser3_slot8_prsnt_n          = scpld_to_mcpld_data_filter[270];
assign  riser3_slot7_prsnt_n          = scpld_to_mcpld_data_filter[269];
assign  w4GpuRiser2Flag               = scpld_to_mcpld_data_filter[268];
assign  w4GpuRiser1Flag               = scpld_to_mcpld_data_filter[267];
assign  riser2_pvti_byte3             = scpld_to_mcpld_data_filter[266:259];
assign  riser2_pvti_byte2             = scpld_to_mcpld_data_filter[258:251];
assign  riser2_pvti_byte1             = scpld_to_mcpld_data_filter[250:243];
assign  riser2_pvti_byte0             = scpld_to_mcpld_data_filter[242:235];
assign  riser1_pvti_byte3             = scpld_to_mcpld_data_filter[234:227];
assign  riser1_pvti_byte2             = scpld_to_mcpld_data_filter[226:219];
assign  riser1_pvti_byte1             = scpld_to_mcpld_data_filter[218:211];
assign  riser1_pvti_byte0             = scpld_to_mcpld_data_filter[210:203];
assign  mb_cb_prsnt[15:0]             = scpld_to_mcpld_data_filter[202:187];
assign  db_riser_prsnt_det_2          = scpld_to_mcpld_data_filter[186];
assign  db_riser_prsnt_det_3          = scpld_to_mcpld_data_filter[185];
assign  db_riser_prsnt_det_0          = scpld_to_mcpld_data_filter[184];
assign  db_riser_prsnt_det_1          = scpld_to_mcpld_data_filter[183];
assign  db_i_riser_prsnt_det_9        = scpld_to_mcpld_data_filter[182];
assign  db_i_riser_prsnt_det_8        = scpld_to_mcpld_data_filter[181];
assign  db_riser_prsnt_det_6          = scpld_to_mcpld_data_filter[180];
assign  db_riser_prsnt_det_7          = scpld_to_mcpld_data_filter[179];
assign  db_riser_prsnt_det_4          = scpld_to_mcpld_data_filter[178];
assign  db_riser_prsnt_det_5          = scpld_to_mcpld_data_filter[177];
assign  db_i_riser_prsnt_det_11       = scpld_to_mcpld_data_filter[176];
assign  db_i_riser_prsnt_det_10       = scpld_to_mcpld_data_filter[175];
assign  nvme_slot_number[43:0]        = scpld_to_mcpld_data_filter[174:131];
assign  riser_ocp_m2_slot_number[19:0]= scpld_to_mcpld_data_filter[130:111];
assign  db_i_p12v_stby_sns_alert      = scpld_to_mcpld_data_filter[110];
assign  db_i_fan_sns_alert            = scpld_to_mcpld_data_filter[109];
assign  db_i_dimm_sns_alert           = scpld_to_mcpld_data_filter[108];
assign  board_id7                     = scpld_to_mcpld_data_filter[107];
assign  board_id6                     = scpld_to_mcpld_data_filter[106];
assign  board_id5                     = scpld_to_mcpld_data_filter[105];
assign  pal_gpu_fan4_prsnt            = scpld_to_mcpld_data_filter[104];
assign  pal_gpu_fan3_prsnt            = scpld_to_mcpld_data_filter[103];
assign  pal_gpu_fan2_prsnt            = scpld_to_mcpld_data_filter[102];
assign  pal_gpu_fan1_prsnt            = scpld_to_mcpld_data_filter[101];
assign  pal_gpu_fan4_foo              = scpld_to_mcpld_data_filter[100];
assign  pal_gpu_fan3_foo              = scpld_to_mcpld_data_filter[99];
assign  pal_gpu_fan2_foo              = scpld_to_mcpld_data_filter[98];
assign  pal_gpu_fan1_foo              = scpld_to_mcpld_data_filter[97];
assign  bmc_cpld_version              = scpld_to_mcpld_data_filter[96:81];
assign  pcb_revision_1                = scpld_to_mcpld_data_filter[80];
assign  pcb_revision_0                = scpld_to_mcpld_data_filter[79];
assign  pca_revision_2                = scpld_to_mcpld_data_filter[78];
assign  pca_revision_1                = scpld_to_mcpld_data_filter[77];
assign  pca_revision_0                = scpld_to_mcpld_data_filter[76];
assign  mb_cpld2_ver                  = scpld_to_mcpld_data_filter[75:60];
assign  i_pal_wdt_rst_n_r             = scpld_to_mcpld_data_filter[59];
assign  tpm_prsnt_n                   = scpld_to_mcpld_data_filter[58];
assign  tpm_pp                        = scpld_to_mcpld_data_filter[57];
assign  pal_lcd_prsnt                 = scpld_to_mcpld_data_filter[56];
assign  pal_m2_1_sel_r                = scpld_to_mcpld_data_filter[55];
assign  pal_m2_1_prsnt_n              = scpld_to_mcpld_data_filter[54];
assign  pal_m2_0_prsnt_n              = scpld_to_mcpld_data_filter[53];
assign  pal_riser2_prsnt_n            = scpld_to_mcpld_data_filter[52];
assign  pal_riser1_prsnt_n            = scpld_to_mcpld_data_filter[51];
assign  riser2_tmp_alert_n            = scpld_to_mcpld_data_filter[50];
assign  riser1_tmp_alert_n            = scpld_to_mcpld_data_filter[49];
assign  db_pal_ext_rst_n              = scpld_to_mcpld_data_filter[48];
assign  debug_sw8                     = scpld_to_mcpld_data_filter[47];
assign  debug_sw7                     = scpld_to_mcpld_data_filter[46];
assign  debug_sw6                     = scpld_to_mcpld_data_filter[45];
assign  debug_sw5                     = scpld_to_mcpld_data_filter[44];
assign  debug_sw4                     = scpld_to_mcpld_data_filter[43];
assign  debug_sw3                     = scpld_to_mcpld_data_filter[42];
assign  debug_sw2                     = scpld_to_mcpld_data_filter[41];
assign  debug_sw1                     = scpld_to_mcpld_data_filter[40];
assign  cpu_nvme17_prsnt_n            = scpld_to_mcpld_data_filter[39];
assign  cpu_nvme16_prsnt_n            = scpld_to_mcpld_data_filter[38];
assign  cpu_nvme15_prsnt_n            = scpld_to_mcpld_data_filter[37];
assign  cpu_nvme14_prsnt_n            = scpld_to_mcpld_data_filter[36];
assign  cpu_nvme13_prsnt_n            = scpld_to_mcpld_data_filter[35];
assign  cpu_nvme12_prsnt_n            = scpld_to_mcpld_data_filter[34];
assign  cpu_nvme11_prsnt_n            = scpld_to_mcpld_data_filter[33];
assign  cpu_nvme10_prsnt_n            = scpld_to_mcpld_data_filter[32];
assign  cpu_nvme19_prsnt_n            = scpld_to_mcpld_data_filter[31];
assign  cpu_nvme18_prsnt_n            = scpld_to_mcpld_data_filter[30];
assign  cpu_nvme23_prsnt_n            = scpld_to_mcpld_data_filter[29];
assign  cpu_nvme22_prsnt_n            = scpld_to_mcpld_data_filter[28];
assign  cpu_nvme7_prsnt_n             = scpld_to_mcpld_data_filter[27];
assign  cpu_nvme6_prsnt_n             = scpld_to_mcpld_data_filter[26];
assign  cpu_nvme5_prsnt_n             = scpld_to_mcpld_data_filter[25];
assign  cpu_nvme4_prsnt_n             = scpld_to_mcpld_data_filter[24];
assign  cpu_nvme3_prsnt_n             = scpld_to_mcpld_data_filter[23];
assign  cpu_nvme2_prsnt_n             = scpld_to_mcpld_data_filter[22];
assign  cpu_nvme1_prsnt_n             = scpld_to_mcpld_data_filter[21];
assign  cpu_nvme0_prsnt_n             = scpld_to_mcpld_data_filter[20];
assign  cpu_nvme9_prsnt_n             = scpld_to_mcpld_data_filter[19];
assign  cpu_nvme8_prsnt_n             = scpld_to_mcpld_data_filter[18];
assign  cpu_nvme25_prsnt_n            = scpld_to_mcpld_data_filter[17]; 
assign  cpu_nvme24_prsnt_n            = scpld_to_mcpld_data_filter[16];
assign  ocp_prsent_b7_n               = scpld_to_mcpld_data_filter[15];
assign  ocp_prsent_b6_n               = scpld_to_mcpld_data_filter[14];
assign  ocp_prsent_b5_n               = scpld_to_mcpld_data_filter[13];
assign  ocp_prsent_b4_n               = scpld_to_mcpld_data_filter[12];
assign  ocp_prsent_b3_n               = scpld_to_mcpld_data_filter[11];
assign  ocp_prsent_b2_n               = scpld_to_mcpld_data_filter[10];
assign  ocp_prsent_b1_n               = scpld_to_mcpld_data_filter[9] ;
assign  ocp_prsent_b0_n               = scpld_to_mcpld_data_filter[8] ;
assign  fan8_install_n                = scpld_to_mcpld_data_filter[7] ;
assign  fan7_install_n                = scpld_to_mcpld_data_filter[6] ;
assign  fan6_install_n                = scpld_to_mcpld_data_filter[5] ;
assign  fan5_install_n                = scpld_to_mcpld_data_filter[4] ;
assign  fan4_install_n                = scpld_to_mcpld_data_filter[3] ;
assign  fan3_install_n                = scpld_to_mcpld_data_filter[2] ;
assign  fan2_install_n                = scpld_to_mcpld_data_filter[1] ;
assign  fan1_install_n                = scpld_to_mcpld_data_filter[0] ;

//M CPLD ---> S CPLD 
assign mcpld_to_scpld_p2s_data[511]     =  1'b1                      ; 
assign mcpld_to_scpld_p2s_data[510]     =  1'b0                      ;
assign mcpld_to_scpld_p2s_data[509]     =  1'b1                      ; 
assign mcpld_to_scpld_p2s_data[508]     =  1'b0                      ;
assign mcpld_to_scpld_p2s_data[507:350] = 158'b0                     ;
assign mcpld_to_scpld_p2s_data[349]     = test_bat_en                ;
assign mcpld_to_scpld_p2s_data[348]     = bmc_extrst_uid             ;
assign mcpld_to_scpld_p2s_data[347]     = i_PAL_M2_0_SEL_LV33_R      ;
assign mcpld_to_scpld_p2s_data[346:339] = i2c_ram_1058               ;
assign mcpld_to_scpld_p2s_data[338:331] = i2c_ram_1057               ;
assign mcpld_to_scpld_p2s_data[330:323] = i2c_ram_1056               ;
assign mcpld_to_scpld_p2s_data[322:315] = i2c_ram_1055               ;
assign mcpld_to_scpld_p2s_data[314:307] = i2c_ram_1054               ;
assign mcpld_to_scpld_p2s_data[306:299] = i2c_ram_1053               ;
assign mcpld_to_scpld_p2s_data[298:291] = i2c_ram_1052               ;
assign mcpld_to_scpld_p2s_data[290:283] = i2c_ram_1051               ;
assign mcpld_to_scpld_p2s_data[282:275] = i2c_ram_1050               ;
assign mcpld_to_scpld_p2s_data[274]     = db_i_pal_front_bp_efuse_pg | db_i_pal_reat_bp_efuse_pg;
assign mcpld_to_scpld_p2s_data[273]     = rst_i2c0_mux_n             ;
assign mcpld_to_scpld_p2s_data[272]     = pal_led_nic_act            ;
assign mcpld_to_scpld_p2s_data[271]     = rst_i2c_riser2_pca9548_n   ;
assign mcpld_to_scpld_p2s_data[270]     = rst_i2c_riser1_pca9548_n   ;
assign mcpld_to_scpld_p2s_data[269]     = i_CPU0_D0_BIOS_OVER        ;
assign mcpld_to_scpld_p2s_data[268]     = bmc_read_flag_1            ;
assign mcpld_to_scpld_p2s_data[267]     = vga2_dis                   ;
assign mcpld_to_scpld_p2s_data[266:227] = pfr_to_led[39:0]           ;
assign mcpld_to_scpld_p2s_data[226]     = pgd_p1v8_stby_dly32ms      ;
assign mcpld_to_scpld_p2s_data[225]     = pgd_p1v8_stby_dly30ms      ;
assign mcpld_to_scpld_p2s_data[224]     = bios_security_bypass       ;
assign mcpld_to_scpld_p2s_data[223]     = i_PAL_RTC_INTB             ;
assign mcpld_to_scpld_p2s_data[222]     = pal_ocp_ncsi_sw_en         ;
assign mcpld_to_scpld_p2s_data[221]     = pal_ocp2_ncsi_en           ;
assign mcpld_to_scpld_p2s_data[220]     = pal_ocp1_ncsi_en           ;
assign mcpld_to_scpld_p2s_data[219]     = i_PAL_PE_WAKE_N_R          ;
assign mcpld_to_scpld_p2s_data[218]     = i_SMB_PEHP_CPU1_3V3_ALERT_N;
assign mcpld_to_scpld_p2s_data[217:216] = debug_reg_15[1:0]          ;
assign mcpld_to_scpld_p2s_data[215]     =  rom_mux_bios_bmc_en       ;
assign mcpld_to_scpld_p2s_data[214:183] =  AUX_BP_type[31:0]         ;
assign mcpld_to_scpld_p2s_data[182:55]  =  pcie_detect[127:0]        ;
assign mcpld_to_scpld_p2s_data[54:39]   =  o_mb_cb_prsnt_bmc[15:0]   ;
assign mcpld_to_scpld_p2s_data[38]      =  rom_mux_bios_bmc_sel      ;
//assign mcpld_to_scpld_p2s_data[37]    =  bmcctl_uart_sw_en         ;
assign mcpld_to_scpld_p2s_data[37:36]   =  bmcctl_uart_sw[1:0]       ;
assign mcpld_to_scpld_p2s_data[35]      =  rom_bmc_bk_rst            ;
assign mcpld_to_scpld_p2s_data[34]      =  rom_bmc_ma_rst            ;
assign mcpld_to_scpld_p2s_data[33]      =  rst_pal_extrst_r_n        ;
assign mcpld_to_scpld_p2s_data[32]      =  db_i_leakage_det_do_n     ;
assign mcpld_to_scpld_p2s_data[31]      =  tpm_rst                   ;
assign mcpld_to_scpld_p2s_data[30]      =  rst_i2c13_mux_n           ;
assign mcpld_to_scpld_p2s_data[29]      =  rst_i2c12_mux_n           ;
assign mcpld_to_scpld_p2s_data[28]      =  rst_i2c11_mux_n           ;
assign mcpld_to_scpld_p2s_data[27]      =  rst_i2c10_mux_n           ;
assign mcpld_to_scpld_p2s_data[26]      =  rst_i2c8_mux_n            ;
assign mcpld_to_scpld_p2s_data[25]      =  rst_i2c5_mux_n            ;
assign mcpld_to_scpld_p2s_data[24]      =  rst_i2c4_2_mux_n          ;
assign mcpld_to_scpld_p2s_data[23]      =  rst_i2c4_1_mux_n          ;
assign mcpld_to_scpld_p2s_data[22]      =  rst_i2c3_mux_n            ;
assign mcpld_to_scpld_p2s_data[21]      =  rst_i2c2_mux_n            ;
assign mcpld_to_scpld_p2s_data[20]      =  rst_i2c1_mux_n            ;
assign mcpld_to_scpld_p2s_data[19]      =  sys_hlth_red_blink_n      ;
assign mcpld_to_scpld_p2s_data[18]      =  sys_hlth_grn_blink_n      ;
assign mcpld_to_scpld_p2s_data[17]      =  led_uid                   ;
assign mcpld_to_scpld_p2s_data[16]      =  power_supply_on           ;
assign mcpld_to_scpld_p2s_data[15]      =  ocp_main_en               ;
assign mcpld_to_scpld_p2s_data[14]      =  ocp_aux_en                ;
assign mcpld_to_scpld_p2s_data[13]      =  pex_reset_n               ;
assign mcpld_to_scpld_p2s_data[12]      =  reached_sm_wait_powerok   ;
assign mcpld_to_scpld_p2s_data[11]      =  usb_ponrst_r_n            ;
assign mcpld_to_scpld_p2s_data[10]      =  t4hz_clk                  ;
assign mcpld_to_scpld_p2s_data[9:4]     =  power_seq_sm              ;
assign mcpld_to_scpld_p2s_data[3]       =  1'b0                      ;
assign mcpld_to_scpld_p2s_data[2]       =  1'b1                      ;
assign mcpld_to_scpld_p2s_data[1]       =  1'b0                      ;
assign mcpld_to_scpld_p2s_data[0]       =  1'b1                      ;


assign riser1_cb_prsnt_slot1_n          = riser1_pvti_byte3[7];
assign riser1_cb_prsnt_slot2_n          = riser1_pvti_byte3[6];
assign riser1_cb_prsnt_slot3_n          = riser1_pvti_byte3[5];

assign riser1_pwr_det0                  = riser1_pvti_byte2[5];
assign riser1_pwr_det1                  = riser1_pvti_byte2[4];
assign riser1_pcb_rev0                  = riser1_pvti_byte2[3];
assign riser1_pcb_rev1                  = riser1_pvti_byte2[2];
assign riser1_pwr_alert_n               = riser1_pvti_byte2[1];
assign riser1_emc_alert_n               = riser1_pvti_byte2[0];

assign riser1_slot1_prsnt_n             = riser1_pvti_byte1[7];
assign riser1_slot2_prsnt_n             = riser1_pvti_byte1[6];
assign riser1_slot3_prsnt_n             = riser1_pvti_byte1[5];

assign riser1_id[0]                     = riser1_pvti_byte0[7];
assign riser1_id[1]                     = riser1_pvti_byte0[6];
assign riser1_id[2]                     = riser1_pvti_byte0[5];
assign riser1_id[3]                     = riser1_pvti_byte0[4];
assign riser1_id[4]                     = riser1_pvti_byte0[3];
assign riser1_id[5]                     = riser1_pvti_byte0[2];
assign pal_riser1_pwrgd                 = riser1_pvti_byte0[1];
assign pal_riser1_pe_wake_n             = riser1_pvti_byte0[0];

assign riser2_cb_prsnt_slot1_n          = riser2_pvti_byte3[7];
assign riser2_cb_prsnt_slot2_n          = riser2_pvti_byte3[6];
assign riser2_cb_prsnt_slot3_n          = riser2_pvti_byte3[5];

assign riser2_pwr_det0                  = riser2_pvti_byte2[5];
assign riser2_pwr_det1                  = riser2_pvti_byte2[4];
assign riser2_pcb_rev0                  = riser2_pvti_byte2[3];
assign riser2_pcb_rev1                  = riser2_pvti_byte2[2];
assign riser2_pwr_alert_n               = riser2_pvti_byte2[1];
assign riser2_emc_alert_n               = riser2_pvti_byte2[0];

assign riser2_slot1_prsnt_n             = riser2_pvti_byte1[7];
assign riser2_slot2_prsnt_n             = riser2_pvti_byte1[6];
assign riser2_slot3_prsnt_n             = riser2_pvti_byte1[5];

assign riser2_id[0]                     = riser2_pvti_byte0[7];
assign riser2_id[1]                     = riser2_pvti_byte0[6];
assign riser2_id[2]                     = riser2_pvti_byte0[5];
assign riser2_id[3]                     = riser2_pvti_byte0[4];
assign riser2_id[4]                     = riser2_pvti_byte0[3];
assign riser2_id[5]                     = riser2_pvti_byte0[2];
assign pal_riser2_pwrgd                 = riser2_pvti_byte0[1];
assign pal_riser2_pe_wake_n             = riser2_pvti_byte0[0];

assign riser2_pwr_cable_prsnt_n[0]      = riser2_pvti_byte2[5];
assign riser2_pwr_cable_prsnt_n[1]      = riser2_pvti_byte2[4];
assign riser2_pwr_cable_prsnt_n[2]      = riser2_pvti_byte2[7];
assign riser2_pwr_cable_prsnt_n[3]      = riser2_pvti_byte2[6];//4GPU POWER CANLE DET

assign riser1_pwr_cable_prsnt_n[0]      = riser1_pvti_byte2[5];
assign riser1_pwr_cable_prsnt_n[1]      = riser1_pvti_byte2[4];
assign riser1_pwr_cable_prsnt_n[2]      = riser1_pvti_byte2[7];
assign riser1_pwr_cable_prsnt_n[3]      = riser1_pvti_byte2[6];//4GPU POWER CANLE DET

/*-----------------------------------------------------------------------------------------------------------------------------------------------
按键控制
------------------------------------------------------------------------------------------------------------------------------------------------*/
power_button power_button_inst  (
    .clk                   (clk_50m        ),
    .reset                 (~pgd_aux_system ),
    .t1s                   (t1s_tick        ),
    .gpo_pwr_btn_mask      (pwrbtn_mask     ),
    .xreg_pwr_btn_passthru (pwrbtn_bl_mask  ),
    .xreg_vir_pwr_btn      (vwire_pwrbtn_bl ),
    .defeat_pwr_btn_dis_n  (1'b0            ),
    .turn_on_override      (1'b0            ),
    .sys_sw_in_n           (db_sys_sw_in_n  ),
    .gmt_shutdown          (s_bmc_shutdown  ),
    .gmt_wakeup_n          (s_bmc_wakeup_n  ),
    .cpu_thermtrip         (cpu_thermtrip   ),
    .temp_deadly           (1'b0            ),
    .interlock_broken      (interlock_broken),
    .st_steady_pwrok       (st_steady_pwrok ),
    .st_off_standby        (st_off_standby  ),
    .pch_pwrbtn            (pch_pwrbtn      ),
    .pch_thrmtrip          (pch_thrmtrip    ) 
);

assign interlock_broken = 1'b0;


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
.clk                        (clk_50m                    ),
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
    .clk                    (clk_50m                            ),
    .reset                  (~pgd_aux_system                    ),
    .cnt_size               (4'b1000                            ),
    .cnt_step               (t1s_tick                           ),
    .signal_in              (reached_sm_wait_powerok            ),
    .delay_output           (cpu_gpio_ok                        )
);

always@(posedge clk_50m or negedge pgd_aux_system) begin 
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



always @(posedge clk_50m or negedge pgd_aux_system) begin
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

always @(posedge clk_50m or negedge pgd_aux_system) begin
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

always @(posedge clk_50m or negedge pgd_aux_system)begin
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
    .clk                                    (clk_50m                    ), // 输入：50MHz 工作时钟（模块内部时序逻辑的基准，如状态机跳转、计数器计时）
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
    .clk                                    (clk_50m                    ),
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
    .p5v_stby_pgd			                      (db_i_pal_p5v_stby_pgd	     ),
    // 4. SM_EN_MAIN_EFUSE 状态上电使能
    .dimm_efuse_pg			                    (1'b1 /*db_i_pal_dimm_efuse_pg*/),  
    .fan_efuse_pg			                      (db_i_pal_fan_efuse_pg	     ),
    .pgd_main_efuse                         (1'b1                        ),  //in
    .pgd_p12v                               (db_i_pal_pgd_p12v_droop     ),  //in
    .pgd_p12v_stby_droop                    (db_i_pal_pgd_p12v_stby_droop),  //in
    .reat_bp_efuse_pg                       (db_i_pal_reat_bp_efuse_pg   ),
    .front_bp_efuse_pg      	              (db_i_pal_front_bp_efuse_pg  ),
    .p12v_cpu1_vin_pg                       (db_i_pal_p12v_cpu1_vin_pg   ),
    .p12v_cpu0_vin_pg                       (db_i_pal_p12v_cpu0_vin_pg   ),
    // 5. SM_EN_5V 状态上电使能
    .p5v_pgd                                (db_i_pal_p5v0_pgd           ),
    // 6. SM_EN_3V3 状态上电使能
    .p3v3_pgd                               (1'b1                        ), 
    // 7. SM_EN_1V1 状态上电使能
    .p1v1_pgd                               (db_i_pal_vcc_1v1_pg         ), 
    // 主电源使能信号
    // 1. SM_EN_VDD 状态上电使能
    .cpu1_vdd_core_pg		                    (db_i_pal_cpu1_vdd_core_pg   ),
    .cpu0_vdd_core_pg			                  (db_i_pal_cpu0_vdd_core_pg   ),
    // 2. SM_EN_P1V8 状态上电使能   
    .cpu1_p1v8_pg		                        (db_i_pal_cpu1_p1v8_pg	     ),
    .cpu0_p1v8_pg		                        (db_i_pal_cpu0_p1v8_pg	     ),
    // 3. SM_EN_P2V5_VPP 状态上电使能
    .cpu1_pll_p1v8_pg		                    (db_i_pal_cpu1_pll_p1v8_pg   ),
    .cpu0_pll_p1v8_pg		                    (db_i_pal_cpu0_pll_p1v8_pg   ),
    .cpu1_vddq_pg				                    (db_i_pal_cpu1_vddq_pg	     ),  
    .cpu0_vddq_pg		                        (db_i_pal_cpu0_vddq_pg	     ),
    .cpu1_ddr_vdd_pg	                      (db_i_pal_cpu1_ddr_vdd_pg	   ),
    .cpu0_ddr_vdd_pg                        (db_i_pal_cpu0_ddr_vdd_pg    ),
    // 4. SM_EN_P0V8 状态上电使能
    .cpu0_pcie_p1v8_pg		                  (db_i_pal_cpu0_pcie_p1v8_pg  ),  
    .cpu1_pcie_p1v8_pg		                  (db_i_pal_cpu1_pcie_p1v8_pg  ),    
    .cpu0_pcie_p0v9_pg		                  (db_i_pal_cpu0_pcie_p0v9_pg  ),
    .cpu1_pcie_p0v9_pg		                  (db_i_pal_cpu1_pcie_p0v9_pg  ), 
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
    .ocp_aux_en				                      (ocp_aux_en			             ), //out
    .cpu_bios_en                            (cpu_bios_en                 ), //out
    // 2. SM_EN_5V_STBY 状态上电使能
    .p5v_stby_en_r                          (p5v_stby_en_r               ), //out
    // 3. SM_EN_TELEM 状态上电使能
    .pvcc_hpmos_cpu_en_r                    (pvcc_hpmos_cpu_en_r         ), //out
    // 4. SM_EN_MAIN_EFUSE 状态上电使能
    .power_supply_on                        (power_supply_on               ), //out
    .ocp_main_en				                    (ocp_main_en			             ), //out
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
    .p5v_stby_fault_det		                  (p5v_stby_fault_det	            ),
    .p3v3_stby_bp_fault_det                 (p3v3_stby_bp_fault_det         ),//out  
    .main_efuse_fault_det                   (main_efuse_fault_det           ),//out
    .p3v3_stby_fault_det                    (p3v3_stby_fault_det            ),//out
    
    .p12v_front_bp_efuse_fault_det          (p12v_front_bp_efuse_fault_det  ),
    .p12v_reat_bp_efuse_fault_det	          (p12v_reat_bp_efuse_fault_det	),
    .p12v_fan_efuse_fault_det		            (p12v_fan_efuse_fault_det	    ),
    .p12v_dimm_efuse_fault_det              (p12v_dimm_efuse_fault_det	    ),
    .p12v_cpu1_vin_fault_det                (p12v_cpu0_vin_fault_det        ),
    .p12v_cpu0_vin_fault_det                (p12v_cpu1_vin_fault_det        ),
    .p12v_fault_det                         (p12v_fault_det                 ),//out
    .p12v_stby_droop_fault_det              (p12v_stby_droop_fault_det      ),//out

    .p5v_fault_det		                      (p5v_fault_det	                ),
    .p3v3_fault_det                         (p3v3_fault_det                 ),
    .vcc_1v1_fault_det                      (vcc_1v1_fault_det              ),

    .cpu0_vdd_core_fault_det	              (cpu0_vdd_core_fault_det	    ),
    .cpu1_vdd_core_fault_det	              (cpu1_vdd_core_fault_det	    ),

    .cpu0_p1v8_fault_det		                (cpu0_p1v8_fault_det	        ),
    .cpu1_p1v8_fault_det		                (cpu1_p1v8_fault_det	        ),

    .cpu0_vddq_fault_det		                (cpu0_vddq_fault_det	        ),
    .cpu1_vddq_fault_det		                (cpu1_vddq_fault_det	        ),
    .cpu0_ddr_vdd_fault_det	                (cpu0_ddr_vdd_fault_det	        ),
    .cpu1_ddr_vdd_fault_det	                (cpu1_ddr_vdd_fault_det	        ),
    .cpu0_pll_p1v8_fault_det	              (cpu0_pll_p1v8_fault_det        ),
    .cpu1_pll_p1v8_fault_det	              (cpu1_pll_p1v8_fault_det        ),
              
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

    .pwrseq_sm_fault_det		                (pwrseq_sm_fault_det	          ),
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

/*-----------------------------------------------------------------------------------------------------------------------------------------------
风扇控制
------------------------------------------------------------------------------------------------------------------------------------------------*/
reg [7:0]                               cpld_pwm_main_cnt       ;
reg [`NUM_FAN-1:0]                      fan_pwm_n               ;
reg                                     cpld_pwm_main_timeout   ;
wire                                    fan_wdt_sel             ;
wire                                    cpld_pwm_aux            ;
wire                                    cpld_pwm_main           ;
wire [7:0]                              duty_0                  ;
wire [7:0]                              duty_1                  ;
wire [7:0]                              duty_2                  ;
wire [7:0]                              duty_3                  ;
wire [7:0]                              duty_4                  ;
wire [7:0]                              duty_5                  ;
wire [7:0]                              duty_6                  ;
wire [7:0]                              duty_7                  ;
wire [7:0]                              duty_aux                ;
wire [7:0]                              duty_main               ;
wire [7:0]                              duty_main_max           ;
wire [7:0]                              duty_main_min           ;
wire [1:0]                              cpld_pwm_main_type      ;
wire [7:0]                              bmc_pwm_main            ;

//parameter FAN_PCT_0   = 8'h00;//  0/256= 0.000%
//parameter FAN_PCT_10  = 8'h19;// 25/256= 9.766%
//parameter FAN_PCT_20  = 8'h33;// 51/256=19.922%
//parameter FAN_PCT_30  = 8'h49;// 76/256=29.688%
  parameter FAN_PCT_40  = 8'h66;//102/256=39.844%
  parameter FAN_PCT_50  = 8'h80;//128/256=50.000%
//parameter FAN_PCT_60  = 8'h99;//153/256=59.766%
//parameter FAN_PCT_67  = 8'hAB;//171/256=66.797%
  parameter FAN_PCT_70  = 8'hB3;//179/256=69.922%
  parameter FAN_PCT_80  = 8'hCC;//204/256=79.688%
//parameter FAN_PCT_85  = 8'hD9;//217/256=84.766%
  parameter FAN_PCT_90  = 8'hE6;//230/256=89.844%
//parameter FAN_PCT_95  = 8'hF3;//243/256=94.922%
  parameter FAN_PCT_100 = 8'hFF;//255/256=99.219%

/*
fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst2(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_aux),
  .fan_pwm_out(cpld_pwm_aux));
*/
//assign duty_aux      = 8'h80;
assign duty_main_max = 8'hE6;
assign duty_main_min = 8'h80;

always @(posedge clk_50m or negedge db_i_pal_p5v_pgd)begin
    if (!db_i_pal_p5v_pgd)
    begin
      cpld_pwm_main_cnt     <= 8'h00;
      cpld_pwm_main_timeout <= 1'b0;
    end
    else
    begin
      if (cpld_pwm_main_cnt==8'h78)
      begin
        cpld_pwm_main_cnt    <= cpld_pwm_main_cnt;
        cpld_pwm_main_timeout <= 1'b1;
      end
      else
      begin
        cpld_pwm_main_cnt     <= t1s_tick ? cpld_pwm_main_cnt + 8'h01 : cpld_pwm_main_cnt;
        cpld_pwm_main_timeout <= 1'b0;
      end
    end
end

assign duty_main = cpld_pwm_main_timeout ? duty_main_max : duty_main_min;
assign cpld_pwm_main_type[1:0] = (duty_main==duty_main_max) ? 2'b10 : 
                                 (duty_main==duty_main_min) ? 2'b01 : 2'b00;

fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst1(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_main),
  .fan_pwm_out(cpld_pwm_main));

fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst3(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_0),
  .fan_pwm_out(bmc_pwm_main[0]));

fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst4(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_1),
  .fan_pwm_out(bmc_pwm_main[1]));

fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst5(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_2),
  .fan_pwm_out(bmc_pwm_main[2]));

fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst6(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_3),
  .fan_pwm_out(bmc_pwm_main[3]));

fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst7(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_4),
  .fan_pwm_out(bmc_pwm_main[4]));
  
fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst8(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_5),
  .fan_pwm_out(bmc_pwm_main[5]));

fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst9(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_6),
  .fan_pwm_out(bmc_pwm_main[6]));
  
fan_pwm # (.TOTAL_BITS(8), .POL(1'b1)) fan_pwm_inst10(
  .pwm_clk    (t6m25_clk),
  .reset_n    (pon_reset_n),
  .enable     (1'b1),
  .duty_cycle (duty_7),
  .fan_pwm_out(bmc_pwm_main[7]));

//assign bmc_pwm_main[7:0] = (~db_fan_prsnt_n[7:0]) & ({ i_PAL_FAN_BMC_PWM8,i_PAL_FAN_BMC_PWM7,i_PAL_FAN_BMC_PWM6,i_PAL_FAN_BMC_PWM5,i_PAL_FAN_BMC_PWM4,i_PAL_FAN_BMC_PWM3,i_PAL_FAN_BMC_PWM2,i_PAL_FAN_BMC_PWM1});

always @(*)
  begin
    case({db_i_pal_p5v_pgd, bmc_ready_flag})
      2'b00: begin
        //fan_pwm_n[7]   <= 1'b1;
		//fan_pwm_n[6]   <= 1'b1;
        //fan_pwm_n[5]   <= ((~(s5dev_prsnt_n[0] & s5dev_prsnt_n[1])) & (s5dev_fan_on_aux)) ? cpld_pwm_aux : 1'b1;
        //fan_pwm_n[4:0] <= 5'h1F;
		  fan_pwm_n[7:0] <= 8'hFF;
      end
      2'b01: begin
        //fan_pwm_n[7]   <= 1'b1;
		//fan_pwm_n[6]   <= 1'b1;
        //fan_pwm_n[5]   <= ((~(s5dev_prsnt_n[0] & s5dev_prsnt_n[1])) & (s5dev_fan_on_aux)) ? cpld_pwm_aux : 1'b1;
        //fan_pwm_n[4:0] <= 5'h1F;
		  fan_pwm_n[7:0] <= bmc_pwm_main[7:0];
      end
      2'b10  : fan_pwm_n[7:0] <= {8{cpld_pwm_main}};
      2'b11  : fan_pwm_n[7:0] <= bmc_pwm_main[7:0];
      default: fan_pwm_n[7:0] <= 8'hFF;
    endcase
  end

assign emc_alert_n = i_PAL_TMP1_ALERT_N & i_PAL_TMP2_ALERT_N & i_PAL_TMP3_ALERT_N;
assign fan_wdt_sel = 1'b0;
assign s5dev_prsnt_n[0]  = db_ocp1_prsnt_n ;
assign s5dev_prsnt_n[1]  = db_ocp2_prsnt_n ;
assign s5dev_fan_on_aux  = ((~(db_ocp1_prsnt_n & db_ocp2_prsnt_n)) & (~db_emc_alert_n ) );

assign o_PAL_FAN1_PWM_R =   db_fan_prsnt_n[0] ?  1'b0:  (~fan_pwm_n[0] );
assign o_PAL_FAN2_PWM_R =   db_fan_prsnt_n[1] ?  1'b0:  (~fan_pwm_n[1] );
assign o_PAL_FAN3_PWM_R =   db_fan_prsnt_n[2] ?  1'b0:  (~fan_pwm_n[2] );
assign o_PAL_FAN4_PWM_R =   db_fan_prsnt_n[3] ?  1'b0:  (~fan_pwm_n[3] );
assign o_PAL_FAN5_PWM_R =   db_fan_prsnt_n[4] ?  1'b0:  (~fan_pwm_n[4] );
assign o_PAL_FAN6_PWM_R =   db_fan_prsnt_n[5] ?  1'b0:  (~fan_pwm_n[5] );  
assign o_PAL_FAN7_PWM   =   db_fan_prsnt_n[6] ?  1'b0:  (~fan_pwm_n[6] );
assign o_PAL_FAN8_PWM   =   db_fan_prsnt_n[7] ?  1'b0:  (~fan_pwm_n[7] );

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach1(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH1),
.fan_rotor_byte2   (fan_tach1_byte2),
.fan_rotor_byte1   (fan_tach1_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach2(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH1),
.fan_rotor_byte2   (fan_tach2_byte2),
.fan_rotor_byte1   (fan_tach2_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach3(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH2),
.fan_rotor_byte2   (fan_tach3_byte2),
.fan_rotor_byte1   (fan_tach3_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach4(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH2),
.fan_rotor_byte2   (fan_tach4_byte2),
.fan_rotor_byte1   (fan_tach4_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach5(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH3),
.fan_rotor_byte2   (fan_tach5_byte2),
.fan_rotor_byte1   (fan_tach5_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach6(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH3),
.fan_rotor_byte2   (fan_tach6_byte2),
.fan_rotor_byte1   (fan_tach6_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach7(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH4),
.fan_rotor_byte2   (fan_tach7_byte2),
.fan_rotor_byte1   (fan_tach7_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach8(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH4),
.fan_rotor_byte2   (fan_tach8_byte2),
.fan_rotor_byte1   (fan_tach8_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach9(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH5),
.fan_rotor_byte2   (fan_tach9_byte2),
.fan_rotor_byte1   (fan_tach9_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach10(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH5),
.fan_rotor_byte2   (fan_tach10_byte2),
.fan_rotor_byte1   (fan_tach10_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach11(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH6),
.fan_rotor_byte2   (fan_tach11_byte2),
.fan_rotor_byte1   (fan_tach11_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach12(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH6),
.fan_rotor_byte2   (fan_tach12_byte2),
.fan_rotor_byte1   (fan_tach12_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach13(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH7),
.fan_rotor_byte2   (fan_tach13_byte2),
.fan_rotor_byte1   (fan_tach13_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach14(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH7),
.fan_rotor_byte2   (fan_tach14_byte2),
.fan_rotor_byte1   (fan_tach14_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach15(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_FRONT_TACH8),
.fan_rotor_byte2   (fan_tach15_byte2),
.fan_rotor_byte1   (fan_tach15_byte1));

fan_speed_detect # (.TOTAL_BITS(8), .POL(1'b1)) fan_speed_detect_tach16(
.count_step        (t8us_tick),
.count_clear_step  (t1s_tick),
.clk_50m           (clk_50m),
.pon_reset_n       (pon_reset_n),
.signal_in         (i_FAN_REAR_TACH8),
.fan_rotor_byte2   (fan_tach16_byte2),
.fan_rotor_byte1   (fan_tach16_byte1));


//------------------------------------------------------------------------------
// force_reb logic (emergency power down)
// - Asserts when uid bottom is held at least 6s.
// - This is one of the shutdown events
//------------------------------------------------------------------------------
reg  [2:0] force_reb_count;

always @(posedge clk_50m or negedge pgd_aux_system)
begin
  if (~pgd_aux_system)
  begin
    force_reb_count <= 2'b00;
    force_reb       <= 1'b1;
  end
  else if (db_i_pal_uid_sw_in_n)
  begin
    force_reb_count <= 2'b00;
    force_reb       <= 1'b1;
  end
  else if (t1s_tick && (force_reb_count == 3'b111))
  begin
    force_reb       <= 1'b0;
  end
  else if (t1s_tick && !db_i_pal_uid_sw_in_n )
  begin
    force_reb_count <= force_reb_count + 1'b1;
  end
end


//------------------------------------------------------------------------------
// force_reb logic (emergency power down)
// - Asserts when uid bottom is held at least 6s.
// - This is one of the shutdown events
//------------------------------------------------------------------------------
reg  [1:0] force_reb_in_count;
reg        force_reb_in;

always @(posedge clk_50m or negedge pgd_aux_system)
begin
  if (~pgd_aux_system)
  begin
    force_reb_in_count <= 2'b00;
    force_reb_in       <= 1'b1;
  end
  else if (db_pal_ext_rst_n)
  begin
    force_reb_in_count <= 2'b00;
    force_reb_in       <= 1'b1;
  end
  else if (t1s_tick && (force_reb_in_count == 2'b11))
  begin
    force_reb_in       <= 1'b0;
  end
//YHY  else if (t1s && !sys_sw_in_n && gpo_pwr_btn_mask)
    else if (t1s_tick && !db_pal_ext_rst_n )

  begin
    force_reb_in_count <= force_reb_in_count + 1'b1;
  end
end


//------------------------------------------------------------------------------
// PME Event
// CHECKME: PE_WAKE_N (CR15) includes:
// AROC   J21, only MEZZ type existed
// RISER1 J1
// RISER2 J39
// RISER3 Slot7/8
// RISER4 Slot9/10
// OCP1/OCP2/AUX7 PEWAK
// BMC    PAL_BMC_PE_WAKE_N, not used in G2 yet.
//------------------------------------------------------------------------------
pme_filter pme_filter_inst (
  .clk              (clk_50m         ),//in
  .t1hz_tick        (t1s_tick         ),//in
  .pgoodaux         (pon_reset_db_n   ),//in
  .pme_source_or_all(~pfr_pe_wake_n   ),//in ���е��ӿ�������wake�źţ�����pme_filter��1��Ч  
  .pme_mask_n       (~power_supply_on ),//in psuʹ���źš�����pme_filter��0��ʾpsu�ϵ磬�򲻻ᴥ��db_pme_source_all��1��ʾpsuû�ϵ磬��ᴥ��db_pme_source_all������psu
  .db_pme_source_all(db_pme_source_all),//out ���wake
  .pme_event_pls    (pme_event        ) //out �ϱ��жϣ�1��ʾ����wake
);

assign power_wake_r_n = (!db_pme_source_all || power_supply_on || !wol_en) ? 1'b1 : 1'b0;  //ADD YHY

//------------------------------------------------------------------------------
// UID logic
// CHECKME: Need to validate connections with new top level
//------------------------------------------------------------------------------
wire w_uid_btn_evt_wc;
wire w_uid_rstbmc_evt_wc;
wire uid_btn_all_invert;
wire uid_button_long_evt;
wire uid_button_short_evt;
wire [7:0] w_uid_led_ctl;

UID_Function#(
.LONG_PRESS        (4'd5)
)UID_Function_u0(
.i_clk                    (clk_50m		        ),//input Clk
.i_1mSEC                  (t1ms_tick	        ),
.i_20mSEC                 (t32ms_tick	        ),
.i_rst_n                  (pon_reset_n	        ),//Global rst,Active Low
.i_clr_flag_short         (~w_uid_btn_evt_wc    ),//Use the same signal on common design
.i_clr_flag_long          (~w_uid_rstbmc_evt_wc ),//Use the same signal on common design 
.i_UID_BMC_BTN_N          (1'b1                 ),
.i_UID_BTN_RP_CPLD_N      (i_PAL_BMCUID_BUTTON_R),//i_UID_BTN_CPLD_N
.i_UID_BTN_FP_CPLD_N      (1'b1), 

//Output Signal
.o_BMC_UID_CPLD_N         (                    ),// reserved, bmc control uid led via i2c
.o_BMC_EXTRST_CPLD_OUT_N  (bmc_extrst_uid	   ),
.o_UID_BTN_short_pos      (uid_btn_all_invert  ),

.o_uid_button_long        (uid_button_long_evt ),
.o_uid_button_short       (uid_button_short_evt),

.i_uid_valid              (1'b0                ),//reserved
.i_uid_status             (8'h00               ),//reserved
.o_uid_act_st             (                    )//reserved
);

//bmc control uid led when bmc active, or uid button will control uid led when bmc die;
reg r_BMC_UID_CPLD_N;
reg [7:0] r_uid_led_ctl;
//assign o_uid_led_ctl    = r_uid_led_ctl;
assign led_uid = r_BMC_UID_CPLD_N;
always@(posedge clk_50m or negedge pon_reset_n)
begin
    if(~pon_reset_n)
	begin
        r_BMC_UID_CPLD_N  <= 1'b1;
		r_uid_led_ctl     <= 8'h00;
	end
	else if(bmc_ready_flag) 
    begin
		r_uid_led_ctl  <= w_uid_led_ctl;
	    case (w_uid_led_ctl)
	    8'h00: r_BMC_UID_CPLD_N  <= 1'b1;
		8'h01: r_BMC_UID_CPLD_N  <= t0p5hz_clk;
		8'h02: r_BMC_UID_CPLD_N  <= t1hz_clk;
		8'h04: r_BMC_UID_CPLD_N  <= t4hz_clk;
		8'hff: r_BMC_UID_CPLD_N  <= 1'b0;
		default: r_BMC_UID_CPLD_N  <= 1'b1;
	    endcase
	end
	else  
	begin
		case (r_uid_led_ctl)
		8'h00: 	
		begin
			r_BMC_UID_CPLD_N  <= 1'b1;
			if(uid_btn_all_invert) 		        
		        r_uid_led_ctl     <= 8'hff;
		end
		8'h01: 
		begin
			if(uid_btn_all_invert)
			    r_uid_led_ctl     <= 8'hff;
		end
		8'h02: 
		begin
			if(uid_btn_all_invert)
			    r_uid_led_ctl     <= 8'hff;
		end
		8'h04: 
		begin
			if(uid_btn_all_invert)
			    r_uid_led_ctl     <= 8'hff;
		end		
		8'hff:
		begin
			r_BMC_UID_CPLD_N  <= 1'b0;
			if(uid_btn_all_invert) 			    
		        r_uid_led_ctl     <= 8'h00;
		end
		default: 
		begin 
		    r_uid_led_ctl     <= 8'h00; 
       	end	
		endcase	 
	end
end


//------------------------------------------------------------------------------
// SYSTEM HEALTHY LED
// CHECKME: Need to validate connections with new top level
//------------------------------------------------------------------------------
reg r_pal_led_hel_red_r;
reg r_pal_led_hel_gr_r;

always@(posedge clk_50m or negedge pon_reset_n)//2023-4-25 add 
begin
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
// PSU 上电逻辑
//------------------------------------------------------------------------------
wire                    ps_on_dly_n             ;
wire                    ps_fail                 ;
wire                    ps_critical             ;      
wire                    brownout_warning        ;
wire                    brownout_fault          ;

psu #(
    .NUM_PSU(`NUM_PSU)
) psu_inst (
    .clk                (clk_50m                ),
    .reset              (~pon_reset_n           ),
    .t1us               (t1us_tick              ),
    .t1ms               (t1ms_tick              ),
    .t1s                (t1s_tick               ),
    .xreg_ps_enable     (xr_ps_enable           ), // 可以不使用
    .xreg_ps_mismatch   (2'b0                   ),
    .gpo_cpld_rst       (1'b0                   ),
    .power_seq_sm       (power_seq_sm           ),
    .power_supply_on    (power_supply_on        ),
    .bad_fuse_det       (1'b0                   ),
    .lom_prsnt_n        (1'b0                   ),
    .lom_fan_on_aux     (1'b0                   ),
    .ps_prsnt_n         (db_ps_prsnt_n          ),
    .ps_acok            (db_ps_acok             ),
    .ps_dcok            (db_ps_dcok             ),
    .pgd_p12v_droop     (db_i_pal_pgd_p12v_droop),// 确保正确
    .ps_on_n            (ps_on_dly_n            ),	
    .ps_cyc_pwr_n       (                       ),
    .ps_acok_link       (                       ),
    .ps_fail            (ps_fail                ),
    .ps_caution         (                       ),
    .ps_critical        (ps_critical            ),
    .brownout_warning   (brownout_warning       ),
    .brownout_fault     (brownout_fault         )
);

// delay 1s for ps_on_n(fall)
edge_delay #(.CNTR_NBITS(2), .DEF_OUTPUT(1'b1), .DELAY_MODE(1'b0)) edge_delay_ps0_on_n (
    .clk                (clk_50m                ),
    .reset              (~pon_reset_n           ),
    .cnt_size           (2'b10                  ),
    .cnt_step           (t512ms_tick            ),
    .signal_in          (ps_on_dly_n[0]         ),
    .delay_output       (ps_on_n[0]             )
);

edge_delay #(.CNTR_NBITS(2), .DEF_OUTPUT(1'b1), .DELAY_MODE(1'b0)) edge_delay_ps1_on_n(
    .clk                (clk_50m                ),
    .reset              (~pon_reset_n           ),
    .cnt_size           (2'b10                  ),
    .cnt_step           (t512ms_tick            ),
    .signal_in          (ps_on_dly_n[1]         ),
    .delay_output       (ps_on_n[1]             )
);

// PS1/PS2 12V使能信号，低电平有效
assign o_PAL_PS1_P12V_ON_R    = ~ps_on_n[0]                     ;
assign o_PAL_PS2_P12V_ON_R    = ~ps_on_n[1]                     ;   
assign o_PAL_P12V_DISCHARGE_R = (&ps_on_n[1:0]) ? 1'bz : 1'b0   ; // 实际未使用

//------------------------------------------------------------------------------
// 健康灯SYSTEM HEALTHY LED
// CHECKME: Need to validate connections with new top level
//------------------------------------------------------------------------------
reg r_pal_led_hel_red_r;
reg r_pal_led_hel_gr_r ;

always@(posedge clk_50m or negedge pon_reset_n)begin
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
wire    [15:0]                          w_mb_to_bp_aux1_data    ;
wire    [15:0]                          w_mb_to_bp_aux2_data    ;

wire    [15:0]                          w_bp_to_mb_aux1_data    ;
wire    [15:0]                          w_bp_to_mb_aux2_data    ;

// bit[7:6] rsv bit5:locate en bit[4:1]:locate bit0:pwr en
wire    [5:0]                           w_aux_rsvd_bit15_10     ;
wire    [1:0]                           w_mb_type               ; // mb_type 00:ICX  01:EGS  10:EGS 4U  11:ICX 4U
wire    [3:0]                           w_aux_rsvd_bit7_4       ;
wire    [2:0]                           w_aux_num_aux1          ;
wire    [2:0]                           w_aux_num_aux2          ;

wire                                    w_pal_bp1_pwr_on_r      ;
wire                                    w_pal_bp2_pwr_on_r      ;

assign w_aux_rsvd_bit15_10 = 6'b0  ;
assign w_mb_type           = 2'b01 ;
assign w_aux_rsvd_bit7_4   = 4'b0  ;
assign w_aux_num_aux1      = 3'b001;
assign w_aux_num_aux2      = 3'b010;

// MB_CPLD 输出的数据格式
assign w_pal_bp1_pwr_on_r = db_i_pal_front_bp_efuse_pg | db_i_pal_reat_bp_efuse_pg;
assign w_pal_bp2_pwr_on_r = db_i_pal_front_bp_efuse_pg | db_i_pal_reat_bp_efuse_pg;

assign w_mb_to_bp_aux1_data = {w_aux_rsvd_bit15_10,w_mb_type,w_aux_rsvd_bit7_4,w_aux_num_aux1,w_pal_bp1_pwr_on_r};
assign w_mb_to_bp_aux2_data = {w_aux_rsvd_bit15_10,w_mb_type,w_aux_rsvd_bit7_4,w_aux_num_aux2,w_pal_bp2_pwr_on_r};

// BP_CPLD 输入的数据格式
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
    .clk                        (clk_50m             ),//input  系统时钟
    .rst                        (~pon_reset_n        ),//input
    .tick                       (t16us_tick          ),//input  BPS计数时钟
    .t128ms_tick                (t128ms_tick         ),//input 
    //Physical Pin        
    .ser_data                   (io_PAL_BP1_PWR_ON_R ),//inout  MB_CPLD输出的串口数据, BP_CPLD输入的串口数据
    //Physical Data
    .par_data_in                (w_mb_to_bp_aux1_data),//input  MB_CPLD输入的并行数据, 16位
    .par_data_out               (w_bp_to_mb_aux1_data),//output MB_CPLD输出的并行数据, 16位
    .send_enable                (1'b1                ),//input
    .pass_through               (w_pal_bp1_pwr_on_r  ),//input
    .error_flag                 (                    ) //output
);

//----------------------------------------------------------------------------------------------------------------------
//AUX2  J86    Board_ID
// ---------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u2 (
    .clk                        (clk_50m             ),//input  系统时钟
    .rst                        (~pon_reset_n        ),//input
    .tick                       (t16us_tick          ),//input  BPS计数时钟
    .t128ms_tick                (t128ms_tick         ),//input
    //Physical Pin        
    .ser_data                   (io_PAL_BP2_PWR_ON_R ),//inout  MB_CPLD输出的串口数据, BP_CPLD输入的串口数据
    //Physical Data
    .par_data_in                (w_mb_to_bp_aux2_data),//input  MB_CPLD输入的并行数据, 16位
    .par_data_out               (w_bp_to_mb_aux2_data),//output MB_CPLD输出的并行数据, 16位
    .send_enable                (1'b1                ),//input
    .pass_through               (w_pal_bp2_pwr_on_r  ),//input
    .error_flag                 (                    ) //output
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
    .clk                        (clk_50m		        ),
    .reset                      (~pon_reset_n	        ),
    .cnt_size                   (5'h19		            ),
    .cnt_step                   (t2ms_tick	            ),
    .signal_in                  (ocp_main_en             ),
    .delay_output               (ocp_main_en_dly50ms     )
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
assign o_P1V8_STBY_CPLD_EN_R       = 1'b1;
// CK44_PWRDN_N 信号， 高电平有效
assign o_PAL_CK440_PWRDN_N_R       = 1'b1;

// assign o_CPU0_D0_SE_RECOVERY_R = 1'b0; // 不使用
// assign o_CPU0_D2_SE_RECOVERY_R = 1'b0; // 不使用
// assign o_CPU0_D3_SE_RECOVERY_R = 1'b0; // 不使用
// assign o_CPU1_D1_SE_RECOVERY_R = 1'b0; // 不使用
// assign o_CPU1_D2_SE_RECOVERY_R = 1'b0; // 不使用
// assign o_CPU1_D3_SE_RECOVERY_R = 1'b0; // 不使用
// CPU0 D1 SE RECOVERY 信号， 高电平有效, 暂时写死为0
assign o_CPU0_D1_SE_RECOVERY_R = 1'b0;
assign o_CPU1_D0_SE_RECOVERY_R = 1'b0;

// 辅电源
// 1. SM_OFF_STANDBY 状态上电使能
assign o_BIOS0_RST_N_R            = ~rom_bios_ma_rst    ; // cpu_bios_en ? (~rom_bios_ma_rst) : 1'bz; // BIOS FLASH 复位信号输出，低电平有效  
assign o_BIOS1_RST_N_R            = ~rom_bios_bk_rst    ; // cpu_bios_en ? (~rom_bios_bk_rst) : 1'bz; // BIOS FLASH 复位信号输出，低电平有效 

assign o_PAL_FRONT_BP_EFUSE_EN_R  = p12v_bp_front_en    ; // 12V 前背板供电使能信号
assign o_PAL_REAT_BP_EFUSE_EN_R   = p12v_bp_rear_en  ; // 12V 后背板供电使能信号, 未使用

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

// assign o_PAL_DIMM_EFUSE_EN_R       = power_supply_on    ;  
// assign o_PAL_GPU1_EFUSE_EN_R       = power_supply_on    ;//20240517 d00412 VB change
// assign o_PAL_GPU3_EFUSE_EN_R       = power_supply_on    ;//20240517 d00412 VB change
// assign o_PAL_GPU2_EFUSE_EN_R       = power_supply_on    ;//20240517 d00412 VB change
// assign o_PAL_GPU_FAN4_PWR_EN_R     = power_supply_on    ;
// assign o_PAL_GPU_FAN3_PWR_EN_R     = power_supply_on    ;
// assign o_PAL_GPU_FAN1_PWR_EN_R     = power_supply_on    ;
// assign o_PAL_GPU_FAN2_PWR_EN_R     = power_supply_on    ;


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
assign o_CPU0_I2C_TRAN_EN_R       =  cpu0_vddq_en_r     ;//20231221 d00412 VB add
assign o_CPU1_I2C_TRAN_EN_R       =  cpu1_vddq_en_r     ;//20231221 d00412 VB add

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








//------------------------------------------------------------------------------
// Power capping
//------------------------------------------------------------------------------
pwrcap #(
  .NUMBER_OF_CPUS(`NUM_CPU),
  .NUMBER_OF_PSU(`NUM_PSU),
  .NUMBER_OF_CHANNEL(`NUM_CHN)
) pwrcap_inst (
  .clk_50m             (clk_50m                                ),
  .reset_n             (pon_reset_db_n                          ),
  .power_fault         (power_fault                             ),//in
  .fault_blink_code    (pf_blink_code                           ),//in
  .t30p5us             (t32us_tick                              ),
  .pm_stpclk           (1'b0                                    ),
  .sw_stpclk           (1'b0                                    ),//in,from xbus 0x14.2  cpu_throttle_force     
  .vr_hot_n            (2'b1                                    ),//in ��ȥ��ʵ��û���� from thermal_inst qual_cpu_vr_hot_n                       
  .ddr_pwrcap_enable   (1'b0                                    ),//in, from xbus 0x14.1       
  .ddr_pwrcap_sw_therm (1'b0                                    ),//XREG 0X14 BIT0 ��ֵ0//in,from xbus 0x14.0       
  .ddr_pwrcap_throttle (4'b0                                    ),//in                         
  .dimm_alert          ({mem_efgh_hot_alert, mem_abcd_hot_alert}),//in, from thermal_inst        
  .ddr_pwrcap_assert_ch(                                        ),//X86�͸�cpu,����ûȥ��,//out
  .vdd3_pgood          (db_i_pal_p5v_pgd                        ),//in                  
  .onehz_clk           (t1hz_clk                                ),//in                  
  .pwrcap_en           (1'b0                                    ),//����pwrcap_grn����ʹ��                                 
  .pwrcap_denied       (1'b0                                    ),//����pwrcap_amb����ʹ�� pwron_denied                                
  .pwrcap_wait         (1'b0                                    ),//in,from xbus   pwrcap_wait                                     
  .pwrseq_wait         (turn_on_wait                            ),//in,from MASTER                                      
  .pwrcap_grn          (                                        ),//out,no use                                         
  .pwrcap_amb          (                                        ),//out,no use                                         
  .pwrbtn_grn          (pal_pwrbtn_grn_led                      ),//out,�Ҷ���Դ��     
  .pwrbtn_amb          (pal_pwrbtn_amb_led                      ),//out,�Ҷ���Դ��     
  .ebrake_en           (1'b0                                    ),//in,from xbus 0x14.3 ebrake_en
  .ps_ac_ok            (db_ps_acok                              ),//in                  
  .ebrake_state        (ebrake                                  ) //ac power loss//out,ac power loss  
);


//------------------------------------------------------------------------------
// thermal 
//------------------------------------------------------------------------------
//cpu_thermtrip_event=1 ��ʾ���������¼�
assign cpu_thermtrip_event[0]  = cpu0_temp_over;
assign cpu_thermtrip_event[1]  = cpu1_temp_over;

thermal thermal_inst (
  .clk                    (clk_50m           ),
  .pgd_p3v3_stby_async    (pon_reset_db_n     ),
  .pgd_aux_system         (pgd_aux_system     ),
  .pgd_p3v3               (db_i_pal_p5v_pgd   ),
  .pch_sys_pwrok          (1'b1               ),
  .st_steady_pwrok        (st_steady_pwrok    ),
  .cpu_vr_hot_n           (2'b11              ),
  .mem_vr_hot_n           (4'b1111            ),
  .cpu_thermtrip_in       (cpu_thermtrip_event),
  .thermtrip_ena          (1'b1               ),
  .emc_alert_n            (1'b1               ),//all_emc_alert_n
  .lom_temp_dead          (1'b0               ),
  .lom_prsnt_n            (1'b1               ),
  .aroc_temp_dead         (1'b0               ),
  .cpu_ab_alert_n         (2'b11              ),
  .cpu_cd_alert_n         (2'b11              ),
  .pch_pltrst_n           (1'b1               ),
  .qual_cpu_vr_hot_n      (qual_cpu_vr_hot_n  ),
  .qual_mem_vr_hot_n      (                   ),
  .or_all_cpu_thermtrip   (cpu_thermtrip      ),
  .sensor_thermtrip       (sensor_thermtrip   ),
  .qual_cpu_ab_alert      (mem_abcd_hot_alert ),
  .qual_cpu_cd_alert      (mem_efgh_hot_alert )
);

assign all_emc_alert_n = (db_emc_alert_n        | emc_alert_mask                               ) |
                         (db_riser1_tmp_alert_n | riser1_emc_alert_mask | db_pal_riser1_prsnt_n) |
                         (db_riser2_tmp_alert_n | riser2_emc_alert_mask | db_pal_riser2_prsnt_n) |
                         ( ocp_temp_alert_mask  | (db_ocp1_prsnt_n & db_ocp2_prsnt_n           ));
	
	
//------------------------------------------------------------------------------
// System reset
//------------------------------------------------------------------------------
system_reset #(
  .PEAVEY_SUPPORT              (PEAVEY_SUPPORT),
  .MAX_HSB_EVENTS_PER_RESET    (20),
  .MAX_HSB_RST_ATTEMPT         (4),
  .NUM_CPU                     (`NUM_CPU),
  .NUM_IO                      (`NUM_IO)
) system_reset_inst (
  .clk                         (clk_50m                     ),
  .reset                       (~pgd_aux_system              ),
  .t1us                        (t1us_tick                    ),
  .st_steady_pwrok             (st_steady_pwrok              ),
  .reached_sm_pre_wait_powerok (reached_sm_wait_powerok      ),
  .rt_critical_fail_store      (rt_critical_fail_store       ),
  .glp_bootnext_n              (1'b1                         ),//s_bmc_bootnext_n��Զ��1
  .glp_sysrst_n                (s_bmc_sysrst_n | rst_btn_mask),//change in 2020311 by g14161  ��ȥ��δʹ��
  .sysrst_button_n             (force_reb_in | rst_btn_mask  ),//change in 2020311 by g14161 //20201212  �޸ĳɳ���4s���ܴ���  
  .xdp_cpu_syspwrok            (1'b1                         ),//BMC_SYS_PWROK
  .rst_pcie_cpu_n              (s_cpu_rst_pcie_n             ),//s_cpu_rst_pcie_n��Զ��1 
  .hsb_en                      (1'b0                         ),//db_xdp_prsnt_n
  .hsb_fail_n                  (hsb_fail_n                   ),
  .pal_sys_reset               (pch_sys_reset                ),
  .pal_sys_reset_n             (pch_sys_reset_n              ),
  .rst_gmt_n                   (rst_bmc_n                    ),//��s_pch_pltrst_n��Ϊ����֮һ��BMC��λ//NOUSE
  .gmt_lreset_n                (                             ),
  .rst_io_n                    (rst_io_n                     ) //NOUSE
);


//------------------------------------------------------------------------------
// NIC LED
//------------------------------------------------------------------------------
/*
nic_leds #(.NUMBER_OF_NICS(16)) ocp_leds_inst (
  .clk_50m           (clk_50m),               //input
  .reset_n           (pon_reset_db_n),        //input
  .lom_present_n     (1'b0),                  //input       db_ocp_prsnt_n
  .t62p5ms           (t64ms_tick),            //input
  .nic_link          ({~s_ocp_link_n[7:0],~s_ocp2_link_n[7:0]}),//input
  .nic_act           ({~s_ocp_act_n[7:0],~s_ocp2_act_n[7:0]}), //input
  .power_fault       (power_fault),           //input
  .fault_blink_code  (pf_blink_code),         //input
  .sid_nic_leds      (),                      //output
  .fp_nic_led        (ocp_led)                //output
);
*/
assign pal_led_nic_act = bmcctl_front_nic_led ? t4hz_clk : 
                         ~(ocp_pvt_act_p0_n & ocp_pvt_act_p1_n & ocp_pvt_act_p2_n & ocp_pvt_act_p3_n & ocp_pvt_act_p4_n & ocp_pvt_act_p5_n & ocp_pvt_act_p6_n & ocp_pvt_act_p7_n & 
						 ocp2_pvt_act_p0_n & ocp2_pvt_act_p1_n & ocp2_pvt_act_p2_n & ocp2_pvt_act_p3_n & ocp2_pvt_act_p4_n & ocp2_pvt_act_p5_n & ocp2_pvt_act_p6_n & ocp2_pvt_act_p7_n) ? t1hz_clk : 
						 ~(ocp_pvt_link_spda_p0_n & ocp_pvt_link_spdb_p0_n & 
						 ocp_pvt_link_spda_p1_n & ocp_pvt_link_spdb_p1_n & 
						 ocp_pvt_link_spda_p2_n & ocp_pvt_link_spdb_p2_n & 
						 ocp_pvt_link_spda_p3_n & ocp_pvt_link_spdb_p3_n & 
						 ocp_pvt_link_spda_p4_n & ocp_pvt_link_spdb_p4_n & 
						 ocp_pvt_link_spda_p5_n & ocp_pvt_link_spdb_p5_n & 
						 ocp_pvt_link_spda_p6_n & ocp_pvt_link_spdb_p6_n & 
						 ocp_pvt_link_spda_p7_n & ocp_pvt_link_spdb_p7_n & 
						 ocp2_pvt_link_spda_p0_n & ocp2_pvt_link_spdb_p0_n & 
						 ocp2_pvt_link_spda_p1_n & ocp2_pvt_link_spdb_p1_n & 
						 ocp2_pvt_link_spda_p2_n & ocp2_pvt_link_spdb_p2_n & 
						 ocp2_pvt_link_spda_p3_n & ocp2_pvt_link_spdb_p3_n & 
						 ocp2_pvt_link_spda_p4_n & ocp2_pvt_link_spdb_p4_n & 
						 ocp2_pvt_link_spda_p5_n & ocp2_pvt_link_spdb_p5_n & 
						 ocp2_pvt_link_spda_p6_n & ocp2_pvt_link_spdb_p6_n & 
						 ocp2_pvt_link_spda_p7_n & ocp2_pvt_link_spdb_p7_n) ? 1'b1 : 1'b0;


//------------------------------------------------------------------------------
// LED blink code
// - Generates correct blink code based on power fault class
//------------------------------------------------------------------------------
  wire [7:0] pf_class0 = pf_class0_b0 | pf_class0_b1 | pf_class0_b2 | pf_class0_b3;
  wire [7:0] pf_class1 = pf_class1_b0 | pf_class1_b1;
  wire [7:0] pf_class2 = 8'b0;//pf_class2_b0 | pf_class2_b1;
  wire [7:0] pf_class3 = 8'b0;
  wire [7:0] pf_class4 = pf_class4_b0;
  wire [7:0] pf_class5 = pf_class5_b0;
  wire [7:0] pf_class6 = pf_class6_b0;
  wire [7:0] pf_class7 = 8'b0;
  wire [7:0] pf_class8 = 8'b0;
  wire [7:0] pf_class9 = pf_class9_b0;
  wire [7:0] pf_classa = pf_classa_b0;

led_blink_code #(.CLASS_SIZE(8)) led_blink_code_inst (
  .reset_n   (pgd_aux_system),
  .clk_50m   (clk_50m      ),
  .blink_clk (t2p5hz_clk    ),
  .class_0   (pf_class0     ),
  .class_1   (pf_class1     ),
  .class_2   (pf_class2     ),
  .class_3   (pf_class3     ),
  .class_4   (pf_class4     ),
  .class_5   (pf_class5     ),
  .class_6   (pf_class6     ),
  .class_7   (pf_class7     ),
  .class_8   (pf_class8     ),
  .class_9   (pf_class9     ),
  .class_A   (pf_classa     ),
  .health_led(pf_blink_code )   //out
  );


//------------------------------------------------------------------------------
// POST LEDs
//------------------------------------------------------------------------------
wire debug_mode_led;

post_leds post_leds_inst (
  .clk_50m     (clk_50m),
  .reset_n     (pgd_aux_system),
  .sys_pgood   (1'b1),
  .onehz_clk   (t1hz_clk),
  .mux_led     (1'b1),
  .mux_pwrseq  (~debug_mode_led),//ON=Sequence  //~db_debug_sw[3]
  .power_seq_sm(power_seq_sm),
  .pal_ver_led ({8'h00,8'h00,8'hFF,`CPLD_VER,8'hFF}),
  .gpo_leds    (bios_post_code),
  .gmt_leds    (8'h00),//bmc_led
  .led_n       (post_led_n)
);

assign debug_mode_led = (~db_debug_sw[7]) ? db_debug_sw[3] : 1'b1;//0:LED For Debug Mode 1:LED For Normal Mode


//------------------------------------------------------------------------------
// Power fault reporting
//------------------------------------------------------------------------------
//0xA2
assign pf_class0_b0  = {2'b0,
                        p12v_cpu0_vin_fault_det,
                        p12v_cpu1_vin_fault_det,
                        p12v_dimm_efuse_fault_det,
                        p5v_fault_det,
						p12v_front_bp_efuse_fault_det,
						p12v_reat_bp_efuse_fault_det
						};
//0xA3						
assign pf_class0_b1  = {any_aux_vrm_fault         ,
                        4'b0                      ,                         
			            p5v_stby_fault_det        ,
                        p3v3_stby_fault_det       ,
                        p3v3_stby_bp_fault_det
						};
//0xA4	
assign pf_class0_b2  = { keep_alive_on_fault,
                         4'b0,
                         db_i_dimm_sns_alert      ,
		                 ~db_i_fan_sns_alert      ,   
                         db_i_p12v_stby_sns_alert
						 };  
//0xA5
assign pf_class0_b3  = {3'b0                      , 
                        ~bmc_pgd_p3v3_stby        ,      
                        ~bmc_pgd_p1v8_stby        ,       
                        ~bmc_pgd_p1v2_stby        ,      
                        ~bmc_pgd_p1v1_stby        ,	
                        ~bmc_pgd_p0v8_stby 	                
						};
//0xA6
assign pf_class1_b0  = {cpu_thermtrip_fault_det[0],
                        cpu0_p1v8_fault_det       ,
                        cpu0_pll_p1v8_fault_det   ,
                        cpu0_ddr_vdd_fault_det    ,
			            cpu0_pcie_p0v9_fault_det  ,
			            cpu0_pcie_p1v8_fault_det  ,
                        cpu0_vddq_fault_det       ,
						cpu0_vdd_core_fault_det
						};
//0xA7						
assign pf_class1_b1  = {cpu_thermtrip_fault_det[1],
                        cpu1_p1v8_fault_det       ,
                        cpu1_pll_p1v8_fault_det   ,
                        cpu1_ddr_vdd_fault_det    ,
                        cpu1_pcie_p0v9_fault_det  ,
                        cpu1_pcie_p1v8_fault_det  ,      
                        cpu1_vddq_fault_det       ,
						cpu1_vdd_core_fault_det   
						};
//0xA8
assign pf_class2_b0  = {6'b0,
                        i_CPU0_VR8_CAT_FLT        ,
                        i_CPU0_VR_ALERT_N_R
                        // ~i_PAL_CPU0_VR_OD           
                        }; 
//0xA9						
assign pf_class2_b1  = {6'b0,
                        i_CPU1_VR8_CAT_FLT        ,
                        ~i_CPU1_VR_ALERT_N_R 
                        // ~i_PAL_CPU1_VR_OD          
						};
//0xAA Riser
assign pf_class4_b0  = {8'b0};

//0xAC OCP
assign pf_class5_b0  = {8'b0};
//0xAD 
assign pf_class6_b0  = {8'b0};
//0xAE BP
assign pf_class9_b0  = {8'b0};//hd_bp_fault_det;
//0xAF PSU
assign pf_classa_b0  = {3'b0,
                        brownout_fault,
                        4'b0         
					   };
//------------------------------------------------------------------------------
// BMC Logic Begin
//------------------------------------------------------------------------------
assign rst_pal_extrst_r_n = bmc_extrst_uid;//ilo_hard_reset ? 1'b0 : 1'b1;
assign o_PAL_BMC_SRST_R   = bmc_extrst_uid;//ilo_hard_reset ? 1'b0 : 1'b1;


//BMC INTERRUPT
reg auxint_n_r;
always @(posedge clk_50m or negedge pgd_aux_system)
 begin
   if (!pgd_aux_system)
     auxint_n_r <= 1'b1;
   else if (~pgd_aux_system_sasd)
     auxint_n_r <= 1'b1;
   else
     auxint_n_r <= ~auxint;
 end

assign o_PAL_BMC_INT_N = auxint_n_r;

//------------------------------------------------------------------------------
// BMC Logic End
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ID logic
//------------------------------------------------------------------------------
//assign board_id[7:0]      = {board_id7,board_id6,board_id5,board_id4,board_id3,board_id2,board_id1,board_id0};

//------------------------------------------------------------------------------
// I2C MUX logic
//------------------------------------------------------------------------------
assign rst_i2c1_mux_n           = ~bmc_i2c_rst[0] ;
assign rst_i2c2_mux_n           = ~bmc_i2c_rst[1] ;
assign rst_i2c3_mux_n           = ~bmc_i2c_rst[2] ;
assign rst_i2c4_1_mux_n         = ~bmc_i2c_rst[3] ;
//assign rst_i2c4_2_mux_n         = ~bmc_i2c_rst[4] ;
assign rst_i2c0_mux_n           = ~bmc_i2c_rst[4] ;
assign rst_i2c5_mux_n           = ~bmc_i2c_rst[5] ;
assign rst_i2c8_mux_n           = ~bmc_i2c_rst[6] ;
assign rst_i2c10_mux_n          = ~bmc_i2c_rst[7] ;
assign rst_i2c11_mux_n          = ~bmc_i2c_rst2[0];
assign rst_i2c12_mux_n          = ~bmc_i2c_rst2[1];
assign rst_i2c13_mux_n          = ~bmc_i2c_rst2[2];
assign o_PAL_RST_CPU1_VPP_N_R   = ~bmc_i2c_rst2[3];
assign o_PAL_RST_CPU0_VPP_N_R   = ~bmc_i2c_rst2[4];
assign rst_i2c_riser1_pca9548_n = ~bmc_i2c_rst2[5];
assign rst_i2c_riser2_pca9548_n = ~bmc_i2c_rst2[6];
assign rst_i2c4_2_mux_n         = ~bmc_i2c_rst2[7];

assign o_PAL_OCP_DEBUG_EN_R    = 1'b1;//1 enable sw (U39)


//------------------------------------------------------------------------------
// Security Bypass
//------------------------------------------------------------------------------
assign bmc_security_bypass  = db_debug_sw[7] ? (~db_debug_sw[0]) : 1'b0;//0:HDM use custom account & password 1:HDM use default account & password
assign bios_security_bypass = db_debug_sw[7] ? (~db_debug_sw[5]) : 1'b0;//BIOS normal boot 1:clear BIOS's password boot


//------------------------------------------------------------------------------
// OC logic
//------------------------------------------------------------------------------
assign ocp_fault_det1 = {db_pal_upd72020_1_alart,db_pal_upd72020_2_alart,db_i_pal_usb_upd2_oci1b,db_i_pal_usb_upd2_oci2b};
assign ocp_fault_det2 = {db_i_pal_usb_upd1_oci4b,db_vga2_oc_alert,db_usb2_lcd_alert,1'b0};

//------------------------------------------------------------------------------
// Misc logic
//------------------------------------------------------------------------------
assign power_on_off = (power_seq_sm==SM_OFF_STANDBY      ) ? 1'b0:
                      (power_seq_sm==SM_STEADY_PWROK     ) ? 1'b1: power_on_off;

assign o_PAL_CPU0_VR_SELECT_N_R = i_CPU0_D0_BIOS_OVER ? 1'b0 : 1'b1     ; //cpu0_vr_select_n;
assign o_PAL_CPU1_VR_SELECT_N_R = i_CPU0_D0_BIOS_OVER ? 1'b0 : 1'b1     ; //cpu1_vr_select_n;
assign o_PAL_RTC_SELECT_N       = bmc_ready_flag ? rtc_select_n : 1'b0  ; // BMC下发rtc_select_n;
assign bmc_read_flag_1          = fan_wdt_sel ? bmc_read_flag: 1'b1     ;

assign o_CPLD_M_S_EXCHANGE_S1_R = i_PAL_P3V3_STBY_PGD;

assign o_CPU0_POR_N_R = cpu_por_n;
assign o_CPU1_POR_N_R = cpu_por_n;//& cpu1_pwr_ctrl_en;//20231121



assign ft_cpu_rst_ok  =	ft_cpu0_rst_ok & ft_cpu1_rst_ok;
assign ft_cpu0_rst_ok = i_CPU0_D1_CRU_RST_OK & i_CPU0_D0_CRU_RST_OK & i_CPU0_D2_CRU_RST_OK & i_CPU0_D3_CRU_RST_OK;
assign ft_cpu1_rst_ok = i_CPU1_D1_CRU_RST_OK & i_CPU1_D0_CRU_RST_OK & i_CPU1_D2_CRU_RST_OK & i_CPU1_D3_CRU_RST_OK;



assign o_PAL_FAN_EFUSE_EN_R       = db_i_pal_p3v3_stby_pgd;//power_supply_on     ;  
assign o_PAL_PVCC_HPMOS_CPU_EN_R  =  pvcc_hpmos_cpu_en_r; 
assign o_PAL_CPU1_P1V8_EN_R       =  cpu1_p1v8_en_r     ;//& cpu1_pwr_ctrl_en;//20231121
assign o_PAL_CPU1_PLL_P1V8_EN_R   =  cpu1_pll_p1v8_en_r ;//& cpu1_pwr_ctrl_en;//20231121
assign o_PAL_CPU1_PCIE_P0V9_EN_R  =  cpu1_pcie_p0v9_en_r;//& cpu1_pwr_ctrl_en;//20231121



assign o_PAL_P5V_EN_R             =  p5v_en_r           ;
assign o_PAL_CPU0_PCIE_P0V9_EN_R  =  cpu0_pcie_p0v9_en_r;
assign o_PAL_CPU1_PCIE_P1V8_EN_R  =  cpu1_pcie_p1v8_en_r;//& cpu1_pwr_ctrl_en;//20231121
assign o_PAL_CPU1_VDD_CORE_EN_R   =  cpu1_vdd_core_en_r ;//& cpu1_pwr_ctrl_en;//20231121
assign o_PAL_CPU0_P1V8_EN_R       =  cpu0_p1v8_en_r     ;
assign o_PAL_CPU0_VDD_CORE_EN_R   =  cpu0_vdd_core_en_r ;
assign o_PAL_CPU0_PLL_P1V8_EN_R   =  cpu0_pll_p1v8_en_r ;
assign o_PAL_CPU0_PCIE_P1V8_EN_R  =  cpu0_pcie_p1v8_en_r;
assign o_PAL_CPU0_DDR_VDD_EN_R    =  cpu0_ddr_vdd_en_r  ;
assign o_PAL_CPU1_DDR_VDD_EN_R    =  cpu1_ddr_vdd_en_r  ;//& cpu1_pwr_ctrl_en;//20231121
assign o_CPU0_SB_EN_R             =  1'b0               ;
assign o_CPU1_SB_EN_R             =  1'b0               ;

assign o_PAL_PWR_LOM_EN_R         = 1'b1                ;//20240517 d00412 VB change


assign o_USB2_LEFT_EAR_EN_R       =  usb2_left_ear_en   ;

//assign o_USB3_RIGHT_EAR_EN_R    =  usb3_right_ear_en  ;//20240517 d00412 VB change
assign o_PAL_OCP1_FAN_PWR_EN_R    =  1'b1               ;

            
			
assign o_PAL_OCP1_MAINPWR_ON_R    =  1'b1               ;
assign o_PAL_OCP1_AUXPWR_ON_R     =  1'b1               ;


assign o_PAL_CPU0_VR8_RESET_R  = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);
assign o_CPU0_VR_AVRST_R       = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);
assign o_PAL_CPU1_VR8_RESET_R  = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);
assign o_CPU1_VR_AVRST_R       = (~db_i_ps1_dc_ok) | (~db_i_ps2_dc_ok);


assign o_CPU0_PE1_RST_N_R      = reached_sm_wait_powerok;
assign o_CPU0_PE2_RST_N_R      = reached_sm_wait_powerok;
assign o_CPU0_PE3_RST_N_R      = reached_sm_wait_powerok;
assign o_CPU1_PE1_RST_N_R      = reached_sm_wait_powerok;
assign o_CPU1_PE2_RST_N_R      = reached_sm_wait_powerok;
assign o_CPU1_PE3_RST_N_R      = reached_sm_wait_powerok;
assign o_CPU1_RSVD_PE_RST_N_R  = reached_sm_wait_powerok;
assign o_PAL_UPD2_PERST_N_R    = reached_sm_wait_powerok;//20240517 d00412 VB change
assign o_BMC_CPLD_RSVD_GPIO2_R = i_PAL_RTC_INTB;

assign o_BMC_RESERVE_0         = i_CPLD_M_S_EXCHANGE_S2_R;
assign o_BMC_RESERVE_1         = i_PAL_UID_SW_IN_N;
//------------------------------------------------------------------------------
// POWER Sequence  Start
//------------------------------------------------------------------------------
assign st_reset_state       = (power_seq_sm==SM_RESET_STATE      );
assign st_off_standby       = (power_seq_sm==SM_OFF_STANDBY      );
assign st_steady_pwrok      = (power_seq_sm==SM_STEADY_PWROK     );
assign st_halt_power_cycle  = (power_seq_sm==SM_HALT_POWER_CYCLE );
assign st_aux_fail_recovery = (power_seq_sm==SM_AUX_FAIL_RECOVERY);


//riser rst
//assign o_PAL_RISER1_RST_N_R   = reached_sm_wait_powerok;//VB CHANGE
//assign o_PAL_RISER2_RST_N_R   = reached_sm_wait_powerok;//VB CHANGE
assign o_PAL_BMC_PERST_N_R    = reached_sm_wait_powerok;

//M.2
assign front_m2_card_prsnt    = ~(pal_m2_0_prsnt_n & pal_m2_1_prsnt_n);


//NCSI Switch
assign pal_ocp1_ncsi_en   = pgd_aux_system ? (sideband_sel == 2'b01) : 1'b0;//Ĭ��״̬OCP1
assign pal_ocp2_ncsi_en   = pgd_aux_system ? (sideband_sel == 2'b10) : 1'b0;//OCP2
assign pal_ocp_ncsi_sw_en = pgd_aux_system ? (sideband_sel == 2'b11) : 1'b0;//OCP3


//OCP
wire ocp_aux_50ms_pgd;
wire ocp_main_en_dly50ms;
wire ocp_aux_pgd;
edge_delay #(
  .CNTR_NBITS    (5)
) ocp_main_en_delay_inst (
  .clk           (clk_50m		),
  .reset         (~pon_reset_n	),
  .cnt_size      (5'h19		),
  .cnt_step      (t2ms_tick	),
  .signal_in     (ocp_main_en),
  .delay_output  (ocp_main_en_dly50ms)
);
assign ocp1_prsnt_n = ocp_prsent_b3_n & ocp_prsent_b2_n & ocp_prsent_b1_n & ocp_prsent_b0_n;
assign ocp2_prsnt_n = ocp_prsent_b4_n & ocp_prsent_b5_n & ocp_prsent_b6_n & ocp_prsent_b7_n;

assign ocp_aux_50ms_pgd         = (ocp_main_en_dly50ms)  ? db_i_pal_ocp1_pwrgd : 1'b1;
assign ocp_aux_pgd            = (ocp_main_en		)    ? ocp_aux_50ms_pgd    : db_i_pal_ocp1_pwrgd; 

assign o_PAL_OCP1_HP_SW_EN_R    = 1'b0       ;
assign o_PAL_OCP1_STBY_PWR_EN_R = ocp_aux_en ;
assign o_PAL_OCP1_MAIN_PWR_EN_R = ocp_main_en;
assign o_PAL_OCP1_PERST0_N_R    = reached_sm_wait_powerok;
assign o_PAL_OCP1_PERST1_N_R    = reached_sm_wait_powerok;


//BIOS FLASH
assign o_BIOS0_RST_N_R = ~rom_bios_ma_rst;//cpu_bios_en ? (~rom_bios_ma_rst) : 1'bz;  
assign o_BIOS1_RST_N_R = ~rom_bios_bk_rst;//cpu_bios_en ? (~rom_bios_bk_rst) : 1'bz;

//SYS EEPROM WP
assign o_PAL_SYS_EEPROM_BYPASS_N_R = bios_eeprom_wp ; //BMC控制

//MCIO PRSNT
assign o_CPU0_D0_PEU_PREST_0_N_R = 1'bz;
assign o_CPU0_D0_PEU_PREST_1_N_R = 1'bz;
assign o_CPU0_D0_PEU_PREST_2_N_R = 1'bz;
assign o_CPU0_D0_PEU_PREST_3_N_R = 1'bz;
assign o_CPU0_D1_PEU_PREST_0_N_R = db_cpu_nvme24_prsnt_n;//db_cpu_nvme24_prsnt_n;
assign o_CPU0_D1_PEU_PREST_1_N_R = db_cpu_nvme9_prsnt_n;//db_cpu_nvme25_prsnt_n;
assign o_CPU0_D1_PEU_PREST_2_N_R = db_cpu_nvme25_prsnt_n;//db_cpu_nvme8_prsnt_n ;
assign o_CPU0_D1_PEU_PREST_3_N_R = db_cpu_nvme8_prsnt_n;//db_cpu_nvme9_prsnt_n ;
assign o_CPU0_D2_PEU_PREST_0_N_R = db_cpu_nvme0_prsnt_n;//db_cpu_nvme0_prsnt_n ;
assign o_CPU0_D2_PEU_PREST_1_N_R = db_cpu_nvme3_prsnt_n;//db_cpu_nvme1_prsnt_n ;
assign o_CPU0_D2_PEU_PREST_2_N_R = db_cpu_nvme1_prsnt_n;//db_cpu_nvme2_prsnt_n ;
assign o_CPU0_D2_PEU_PREST_3_N_R = db_cpu_nvme2_prsnt_n;//db_cpu_nvme3_prsnt_n ;
assign o_CPU0_D3_PEU_PREST_0_N_R = db_cpu_nvme4_prsnt_n;//db_cpu_nvme4_prsnt_n ;
assign o_CPU0_D3_PEU_PREST_1_N_R = db_cpu_nvme7_prsnt_n;//db_cpu_nvme5_prsnt_n ;
assign o_CPU0_D3_PEU_PREST_2_N_R = db_cpu_nvme5_prsnt_n;//db_cpu_nvme6_prsnt_n ;
assign o_CPU0_D3_PEU_PREST_3_N_R = db_cpu_nvme6_prsnt_n;//db_cpu_nvme7_prsnt_n ;
assign o_CPU1_D0_PEU_PREST_0_N_R = db_cpu_nvme22_prsnt_n;//db_cpu_nvme22_prsnt_n;
assign o_CPU1_D0_PEU_PREST_1_N_R = db_cpu_nvme19_prsnt_n;//db_cpu_nvme23_prsnt_n;
assign o_CPU1_D0_PEU_PREST_2_N_R = db_cpu_nvme23_prsnt_n;//db_cpu_nvme18_prsnt_n;
assign o_CPU1_D0_PEU_PREST_3_N_R = db_cpu_nvme18_prsnt_n;//db_cpu_nvme19_prsnt_n;
assign o_CPU1_D1_PEU_PREST_0_N_R = 1'bz;
assign o_CPU1_D1_PEU_PREST_1_N_R = 1'bz;
assign o_CPU1_D1_PEU_PREST_2_N_R = 1'bz;
assign o_CPU1_D1_PEU_PREST_3_N_R = 1'bz;
assign o_CPU1_D2_PEU_PREST_0_N_R = db_cpu_nvme10_prsnt_n;//db_cpu_nvme10_prsnt_n;
assign o_CPU1_D2_PEU_PREST_1_N_R = db_cpu_nvme13_prsnt_n;//db_cpu_nvme11_prsnt_n;
assign o_CPU1_D2_PEU_PREST_2_N_R = db_cpu_nvme11_prsnt_n;//db_cpu_nvme12_prsnt_n;
assign o_CPU1_D2_PEU_PREST_3_N_R = db_cpu_nvme12_prsnt_n;//db_cpu_nvme13_prsnt_n;
assign o_CPU1_D3_PEU_PREST_0_N_R = db_cpu_nvme14_prsnt_n;//db_cpu_nvme14_prsnt_n;
assign o_CPU1_D3_PEU_PREST_1_N_R = db_cpu_nvme17_prsnt_n;//db_cpu_nvme15_prsnt_n;
assign o_CPU1_D3_PEU_PREST_2_N_R = db_cpu_nvme15_prsnt_n;//db_cpu_nvme16_prsnt_n;
assign o_CPU1_D3_PEU_PREST_3_N_R = db_cpu_nvme16_prsnt_n;//db_cpu_nvme17_prsnt_n;

assign pfr_vpp_alert = i_SMB_PEHP_CPU0_3V3_ALERT_N & i_SMB_PEHP_CPU1_3V3_ALERT_N;
assign o_PAL_CPU0_NVME_ALERT_N_R = pfr_vpp_alert ? 1'bz : 1'b0;
assign o_PAL_CPU1_NVME_ALERT_N_R = pfr_vpp_alert ? 1'bz : 1'b0;


//PAL_P3V3_STBY_RST_N is active high (with pulldown), while others is active low (with pullup).
assign o_PAL_P3V3_STBY_RST_R     = (aux_pcycle || (st_off_standby && brownout_fault)) ? 1'b1 : 1'bz;//efuse_power_cycle ? 1'b1 : 1'bz;
// assign o_PAL_P3V3_STBY_BP_RST_R  = (aux_pcycle || (st_off_standby && brownout_fault)) ? 1'b1 : 1'bz;//efuse_power_cycle ? 1'b1 : 1'bz;




//------------------------------------------------------------------------------
// I2C Update Start
//------------------------------------------------------------------------------
wire                                    wb_clk      ;
defparam inst_osch.NOM_FREQ = "4.29";
OSCH inst_osch(
    .STDBY		    (1'b0		                ),
    .OSC		    (wb_clk		                ),
    .SEDSTDBY	    (			                )
);
I2C_UPDATE inst_i2c_update_flash_config(
    .wb_clk_i	    (wb_clk	                    ),
    .wb_rst_i	    (		                    ),
    .wb_cyc_i	    (		                    ),
    .wb_stb_i	    (		                    ),
    .wb_we_i	    (		                    ),
    .wb_adr_i	    (		                    ),
    .wb_dat_i	    (		                    ),
    .wb_dat_o	    (		                    ),
    .wb_ack_o	    (		                    ),
    .i2c1_irqo	    (						    ),
    .i2c1_scl	    (i_BMC_I2C9_PAL_M_SCL_R     ),
    .i2c1_sda	    (io_BMC_I2C9_PAL_M_SDA_R    )
); 

wire [15:0]                             mb_cpld1_ver; 
assign mb_cpld1_ver = 16'h01A1;

bmc_cpld_i2c_ram #(
    .DLY_LEN       (16)   //50MHz,330ns
) bmc_cpld_i2c_ram_u0 (
    .i_rst_n                       (pon_reset_n             ),  
    .i_clk                         (clk_50m	                ),
    .t1s                           (t1s_tick                ),
    .t1us                          (t1us_tick               ),
    .t125ms                        (t128ms_tick             ),
    .pgoodaux                      (pgd_aux_system          ),
    .pon_reset_sasd                (~pgd_aux_system_sasd    ),
    .i_1ms_clk                     (t1ms_tick               ),	          
    .i_rst_i2c_n                   (1'b1                    ),//(i_BMC_CPLD_I2C_RST_R_N),
    .i_scl                         (i_BMC_I2C9_PAL_M_SCL1_R ), 
    .io_sda                        (io_BMC_I2C9_PAL_M_SDA1_R),
 
    .bmc_security_bypass           (bmc_security_bypass      ),//addr 0x0000[6]      in

    .cpld_pwm_main_type            (cpld_pwm_main_type[1:0]  ),//addr 0x0002[6:5]    in   01:50%  10:90%
    .fan_wdt_sel 			       (bmc_ready_flag           ),//addr 0x0002[4]      in
    .fm_bmc_fan_wdt_feed	       (i_pal_wdt_rst_n_r        ),//addr 0x0002[1]      in

    .vwire_bmc_wakeup 	           (vwire_bmc_wakeup         ),//addr 0x0003[6]      out
    .vwire_bmc_sysrst              (vwire_bmc_sysrst         ),//addr 0x0003[5]      out
    .vwire_bmc_shutdown            (vwire_bmc_shutdown       ),//addr 0x0003[4]      out
    .pwr_btn_state                 (~db_sys_sw_in_n          ),//addr 0x0003[3]      in
    .rst_btn_state                 (~force_reb_in            ),//addr 0x0003[2]      in
    .rst_btn_mask                  (rst_btn_mask             ),//addr 0x0003[0]      out

    .bmc_ctrl_shutdown             (bmc_ctrl_shutdown        ),//addr 0x0004[6]      out
    .aux_pcycle                    (aux_pcycle               ),//addr 0x0004[4]      out
    .pwrbtn_bl_mask                (pwrbtn_bl_mask           ),//addr 0x0004[3]      out  reserved
    .vwire_pwrbtn_bl               (vwire_pwrbtn_bl          ),//addr 0x0004[2]      out  reserved
    .physical_pwrbtn_mask          (pwrbtn_mask              ),//addr 0x0004[1]      out
    .st_steady_pwrok               (st_steady_pwrok          ),//addr 0x0004[0]      in

    .bmc_uid_update                (bmc_uid_update           ),//addr 0x0005[7]      out

    .wol_en                        (wol_en                   ),//addr 0x0006[3]      out
    .sideband_sel                  (sideband_sel[1:0]        ),//addr 0x0006[1:0]    out

    .rom_mux_bios_bmc_en           (rom_mux_bios_bmc_en      ),//addr 0x0007[7]      out
    .rom_mux_bios_bmc_sel          (rom_mux_bios_bmc_sel     ),//addr 0x0007[6]      out
    .rom_bios_bk_rst               (rom_bios_bk_rst          ),//addr 0x0007[3]      out
    .rom_bios_ma_rst    	       (rom_bios_ma_rst          ),//addr 0x0007[2]      out
    .rom_bmc_bk_rst                (rom_bmc_bk_rst           ),//addr 0x0007[1]      out
    .rom_bmc_ma_rst                (rom_bmc_ma_rst           ),//addr 0x0007[0]      out

    .test_bat_en                   (test_bat_en              ),//addr 0x0008[7]      out
    .bios_eeprom_wp                (bios_eeprom_wp           ),//addr 0x0008[6]      out

    .o_uid_led_ctl				   (w_uid_led_ctl  	         ),//addr 0x0009[7:0]    out

    .i_uid_btn_evt				   (uid_button_short_evt     ),//addr 0x000A[1]      in 
    .o_uid_btn_evt_clr			   (w_uid_btn_evt_wc	     ),//addr 0x000A[1]      out
    .i_uid_rstbmc_evt			   (uid_button_long_evt      ),//addr 0x000A[0]      in
    .o_uid_rstbmc_evt_clr		   (w_uid_rstbmc_evt_wc      ),//addr 0x000A[0]      out

    .bmcctl_front_nic_led          (bmcctl_front_nic_led     ),//addr 0x000B[2]      out
    .o_sys_healthy_red             (w_sys_healthy_red        ),//addr 0x000B[1]      out
    .o_sys_healthy_grn             (w_sys_healthy_grn        ),//addr 0x000B[0]      out

    .port_80         		       (bios_post_code[7:0]      ),//addr 0x000D[7:0]    in

    .port_84                       (bios_post_rate[7:0]      ),//addr 0x000E[7:0]    in         

    .lpc_io_data_port85            (bios_post_phase[7:0]     ),//addr 0x000F[7:0]    in

    .rtc_select_n                  (rtc_select_n             ),//addr 0x0010[4]      out
    .vga2_dis                      (vga2_dis                 ),//addr 0x0010[3]      out
    .cpu0_d0_bios_over             (i_CPU0_D0_BIOS_OVER      ),//addr 0x0010[0]      in

    .bios_read_flag                (bios_read_flag           ),//addr 0x0013[7]      in 
    .bmc_read_flag                 (bmc_read_flag            ),//addr 0x0013[6]      out

    .m2_slot2_type                 (pal_m2_1_sel_r           ),//addr 0x0015[4]      in
    .m2_slot1_type                 (i_PAL_M2_0_SEL_LV33_R    ),//addr 0x0015[3]      in
    .m2_slot2_prsnt                (~pal_m2_1_prsnt_n        ),//addr 0x0015[2]      in
    .m2_slot1_prsnt                (~pal_m2_0_prsnt_n        ),//addr 0x0015[1]      in
    .m2_card_prsnt                 (front_m2_card_prsnt      ),//addr 0x0015[0]      in

    .bmcctl_uart_sw                (bmcctl_uart_sw[1:0]      ),//addr 0x0016[7:6]    out

    .bmc_i2c_rst                   (bmc_i2c_rst              ),//addr 0x0019[7:0]    out

    .bmc_i2c_rst2                  (bmc_i2c_rst2             ),//addr 0x001A[7:0]    out

    .bmc_i2c_rst3                  (bmc_i2c_rst3             ),//addr 0x001B[7:0]    out

    .tpm_rst      	               (tpm_rst                  ),//addr 0x001D[7]      out                     
    .tpm_prsnt                     (~db_tpm_prsnt_n          ),//addr 0x001D[6]      in
    .intruder            		       (db_i_front_pal_intruder  ),//addr 0x001D[5]      in
    .intruder_cable_prsnt		       (~db_i_intruder_cable_inst_n),//addr 0x001D[4]    in
    .dsd_prsnt              	     (~db_i_dsd_uart_prsnt_n   ),//addr 0x001D[3]    in

    .fan_tach1_byte2               (fan_tach1_byte2          ),//addr 0x0020[7:0]    in
    .fan_tach1_byte1               (fan_tach1_byte1          ),//addr 0x0021[7:0]    in
    .fan_tach2_byte2               (fan_tach2_byte2          ),//addr 0x0022[7:0]    in
    .fan_tach2_byte1               (fan_tach2_byte1          ),//addr 0x0023[7:0]    in
    .fan_tach3_byte2               (fan_tach3_byte2          ),//addr 0x0024[7:0]    in
    .fan_tach3_byte1               (fan_tach3_byte1          ),//addr 0x0025[7:0]    in
    .fan_tach4_byte2               (fan_tach4_byte2          ),//addr 0x0026[7:0]    in
    .fan_tach4_byte1               (fan_tach4_byte1          ),//addr 0x0027[7:0]    in
    .fan_tach5_byte2               (fan_tach5_byte2          ),//addr 0x0028[7:0]    in
    .fan_tach5_byte1               (fan_tach5_byte1          ),//addr 0x0029[7:0]    in
    .fan_tach6_byte2               (fan_tach6_byte2          ),//addr 0x002A[7:0]    in
    .fan_tach6_byte1               (fan_tach6_byte1          ),//addr 0x002B[7:0]    in
    .fan_tach7_byte2               (fan_tach7_byte2          ),//addr 0x002C[7:0]    in
    .fan_tach7_byte1               (fan_tach7_byte1          ),//addr 0x002D[7:0]    in
    .fan_tach8_byte2               (fan_tach8_byte2          ),//addr 0x002E[7:0]    in
    .fan_tach8_byte1               (fan_tach8_byte1          ),//addr 0x002F[7:0]    in
    .fan_tach9_byte2               (fan_tach9_byte2          ),//addr 0x0030[7:0]    in
    .fan_tach9_byte1               (fan_tach9_byte1          ),//addr 0x0031[7:0]    in
    .fan_tach10_byte2              (fan_tach10_byte2         ),//addr 0x0032[7:0]    in
    .fan_tach10_byte1              (fan_tach10_byte1         ),//addr 0x0033[7:0]    in
    .fan_tach11_byte2              (fan_tach11_byte2         ),//addr 0x0034[7:0]    in
    .fan_tach11_byte1              (fan_tach11_byte1         ),//addr 0x0035[7:0]    in
    .fan_tach12_byte2              (fan_tach12_byte2         ),//addr 0x0036[7:0]    in
    .fan_tach12_byte1              (fan_tach12_byte1         ),//addr 0x0037[7:0]    in
    .fan_tach13_byte2              (fan_tach13_byte2         ),//addr 0x0038[7:0]    in
    .fan_tach13_byte1              (fan_tach13_byte1         ),//addr 0x0039[7:0]    in
    .fan_tach14_byte2              (fan_tach14_byte2         ),//addr 0x003A[7:0]    in
    .fan_tach14_byte1              (fan_tach14_byte1         ),//addr 0x003B[7:0]    in
    .fan_tach15_byte2              (fan_tach15_byte2         ),//addr 0x003C[7:0]    in
    .fan_tach15_byte1              (fan_tach15_byte1         ),//addr 0x003D[7:0]    in
    .fan_tach16_byte2              (fan_tach16_byte2         ),//addr 0x003E[7:0]    in
    .fan_tach16_byte1              (fan_tach16_byte1         ),//addr 0x003F[7:0]    in

    .duty_0                        (duty_0                   ),//addr 0x0040[7:0]    out
    .duty_1                        (duty_1                   ),//addr 0x0041[7:0]    out
    .duty_2                        (duty_2                   ),//addr 0x0042[7:0]    out
    .duty_3                        (duty_3                   ),//addr 0x0043[7:0]    out
    .duty_4                        (duty_4                   ),//addr 0x0044[7:0]    out
    .duty_5                        (duty_5                   ),//addr 0x0045[7:0]    out
    .duty_6                        (duty_6                   ),//addr 0x0046[7:0]    out
    .duty_7                        (duty_7                   ),//addr 0x0047[7:0]    out

    .ps_prsnt                      (~db_ps_prsnt_n           ),//addr 0x0050[1:0]    in
    .psu_smb_alert_n               ({db_i_ps2_smb_alert,db_i_ps1_smb_alert}),//addr 0x52[1:0]  in
    .ps_fail                       (db_ps_acok               ),//addr 0x0053[1:0]    in from PSU
    .ps_dcok                       (db_ps_dcok               ),//addr 0x0054[1:0]    in
    .pal_gpu_fan4_foo              (pal_gpu_fan4_foo         ),//addr 0x0056[3]      in
    .pal_gpu_fan3_foo              (pal_gpu_fan3_foo         ),//addr 0x0056[2]      in
    .pal_gpu_fan2_foo              (pal_gpu_fan2_foo         ),//addr 0x0056[1]      in
    .pal_gpu_fan1_foo              (pal_gpu_fan1_foo         ),//addr 0x0056[0]      in
    .ocp2_fan_foo                  (db_i_pal_ocp2_fan_foo    ),//addr 0x0057[7]      in
    .ocp2_fan_prsnt               (~db_i_pal_ocp2_fan_prsnt_n),//addr 0x0057[6]      in
    .ocp1_fan_foo                  (db_i_pal_ocp1_fan_foo    ),//addr 0x0057[5]      in
    .ocp1_fan_prsnt               (~db_i_pal_ocp1_fan_prsnt_n),//addr 0x0057[4]      in
    .fan_prsnt                     (~db_fan_prsnt_n[7:0]     ),//addr 0x0058[7:0]    in
    .gpu_fan_prsnt              ({~pal_gpu_fan4_prsnt,~pal_gpu_fan3_prsnt,~pal_gpu_fan2_prsnt,~pal_gpu_fan1_prsnt}),//addr 0x0059[3:0]  in

    .board2_type                   (bmc_card_type            ),//addr 0x0070[7:4]    in
    .board2_pcb_rev                (bmc_card_pcb_rev         ),//addr 0x0070[3:1]    in
    .bp_prsnt                      (bp_prsnt                 ),//addr 0x0071[7:0]    in
    .ocp2_fan_on_aux               (db_ocp2_pvt_fan_on_aux   ),//addr 0x0072[7]      in
    .ocp2_prsnt                    (~db_ocp2_prsnt_n         ),//addr 0x0072[6]      in
    .ocp_fan_on_aux                (db_ocp_pvt_fan_on_aux    ),//addr 0x0072[5]      in
    .ocp_prsnt                     (~db_ocp1_prsnt_n         ),//addr 0x0072[4]      in

    .riser2_prsnt                  (~db_pal_riser2_prsnt_n   ),//addr 0x0080[1]      in
    .riser1_prsnt                  (~db_pal_riser1_prsnt_n   ),//addr 0x0080[0]      in

    .cpu_nvme0_prsnt_n             (~cpu_nvme0_prsnt_n       ),//addr 0x0090[7]      in
    .cpu_nvme1_prsnt_n             (~cpu_nvme1_prsnt_n       ),//addr 0x0090[6]      in
    .cpu_nvme2_prsnt_n             (~cpu_nvme2_prsnt_n       ),//addr 0x0090[5]      in
    .cpu_nvme3_prsnt_n             (~cpu_nvme3_prsnt_n       ),//addr 0x0090[4]      in
    .cpu_nvme4_prsnt_n             (~cpu_nvme4_prsnt_n       ),//addr 0x0090[3]      in
    .cpu_nvme5_prsnt_n             (~cpu_nvme5_prsnt_n       ),//addr 0x0090[2]      in
    .cpu_nvme6_prsnt_n             (~cpu_nvme6_prsnt_n       ),//addr 0x0090[1]      in
    .cpu_nvme7_prsnt_n             (~cpu_nvme7_prsnt_n       ),//addr 0x0090[0]      in

    .cpu_nvme8_prsnt_n             (~cpu_nvme8_prsnt_n       ),//addr 0x0091[7]      in
    .cpu_nvme9_prsnt_n             (~cpu_nvme9_prsnt_n       ),//addr 0x0091[6]      in
    .cpu_nvme10_prsnt_n            (~cpu_nvme10_prsnt_n      ),//addr 0x0091[5]      in
    .cpu_nvme11_prsnt_n            (~cpu_nvme11_prsnt_n      ),//addr 0x0091[4]      in
    .cpu_nvme12_prsnt_n            (~cpu_nvme12_prsnt_n      ),//addr 0x0091[3]      in
    .cpu_nvme13_prsnt_n            (~cpu_nvme13_prsnt_n      ),//addr 0x0091[2]      in
    .cpu_nvme14_prsnt_n            (~cpu_nvme14_prsnt_n      ),//addr 0x0091[1]      in
    .cpu_nvme15_prsnt_n            (~cpu_nvme15_prsnt_n      ),//addr 0x0091[0]      in

    .cpu_nvme16_prsnt_n            (~cpu_nvme16_prsnt_n      ),//addr 0x0092[7]      in
    .cpu_nvme17_prsnt_n            (~cpu_nvme17_prsnt_n      ),//addr 0x0092[6]      in
    .cpu_nvme18_prsnt_n            (~cpu_nvme18_prsnt_n      ),//addr 0x0092[5]      in
    .cpu_nvme19_prsnt_n            (~cpu_nvme19_prsnt_n      ),//addr 0x0092[4]      in
    .cpu_nvme22_prsnt_n            (~cpu_nvme22_prsnt_n      ),//addr 0x0092[3]      in
    .cpu_nvme23_prsnt_n            (~cpu_nvme23_prsnt_n      ),//addr 0x0092[2]      in
    .cpu_nvme24_prsnt_n            (~cpu_nvme24_prsnt_n      ),//addr 0x0092[1]      in
    .cpu_nvme25_prsnt_n            (~cpu_nvme25_prsnt_n      ),//addr 0x0092[0]      in

    .power_on_off                  (power_on_off             ),//addr 0x00A0[6]      in
    .power_seq_sm                  (power_seq_sm[5:0]        ),//addr 0x00A0[5-0]    in

    .power_fault                   (power_fault              ),//addr 0x00A1[6]      in
    .pwrseq_sm_fault_det           (pwrseq_sm_fault_det[5:0] ),//addr 0x00A1[5-0]    in

    .pf_class0_b0                  (pf_class0_b0[7:0]        ),//addr 0x00A2[7-0]    in
    .pf_class0_b1                  (pf_class0_b1[7:0]        ),//addr 0x00A3[7-0]    in
    .pf_class0_b2                  (pf_class0_b2[7:0]        ),//addr 0x00A4[7-0]    in
    .pf_class0_b3                  (pf_class0_b3[7:0]        ),//addr 0x00A5[7-0]    in
    .pf_class1_b0                  (pf_class1_b0[7:0]        ),//addr 0x00A6[7-0]    in
    .pf_class1_b1                  (pf_class1_b1[7:0]        ),//addr 0x00A7[7-0]    in
    .pf_class2_b0                  (pf_class2_b0[7:0]        ),//addr 0x00A8[7-0]    in
    .pf_class2_b1                  (pf_class2_b1[7:0]        ),//addr 0x00A9[7-0]    in
    .pf_class4_b0                  (pf_class4_b0[7:0]        ),//addr 0x00AA[7-0]    in
    .pf_class5_b0                  (pf_class5_b0[7:0]        ),//addr 0x00AC[7-0]    in
    .pf_class6_b0                  (pf_class6_b0[7:0]        ),//addr 0x00AD[7-0]    in
    .pf_class9_b0                  (pf_class9_b0[7:0]        ),//addr 0x00AE[7-0]    in
    .pf_classa_b0                  (pf_classa_b0[7:0]        ),//addr 0x00AF[4]      in

    .pdt_line                      (8'h00                    ),//addr 0x00C2[7:0]    in
    .pdt_gen                       (8'h06                    ),//addr 0x00C3[7:0]    in
    .server_id                     (8'h21                    ),//addr 0x00C5[7:0]    in
    .board_id                      (8'h01                    ),//addr 0x00C6[7:0]    in

    .pcb_rev   				       ({1'b0,pcb_revision_1,pcb_revision_0}),//addr 0xF1[2-0]  in

    .bmc_cpld_version              (bmc_cpld_version[15:0]   ),//addr 0x00FA-0x00FB[7:0]    in
    .mb_cpld2_ver                  (mb_cpld2_ver[15:0]       ),//addr 0x00FC-0x00FD[7:0]    in
    .mb_cpld1_ver                  (mb_cpld1_ver[15:0]       ),//addr 0x00FE-0x00FF[7:0]    in

    .i2c_ram_1050                  (i2c_ram_1050             ),//addr 0x1050[7:0]    out        
    .i2c_ram_1051                  (i2c_ram_1051             ),//addr 0x1051[7:0]    out
    .i2c_ram_1052                  (i2c_ram_1052             ),//addr 0x1052[7:0]    out
    .i2c_ram_1053                  (i2c_ram_1053             ),//addr 0x1053[7:0]    out
    .i2c_ram_1054                  (i2c_ram_1054             ),//addr 0x1054[7:0]    out
    .i2c_ram_1055                  (i2c_ram_1055             ),//addr 0x1055[7:0]    in
    .i2c_ram_1056                  (i2c_ram_1056             ),//addr 0x1056[7:0]    in
    .i2c_ram_1057                  (i2c_ram_1057             ),//addr 0x1057[7:0]    in
    .i2c_ram_1058                  (i2c_ram_1058             ),//addr 0x1058[7:0]    in

    .ilo_hard_reset                (ilo_hard_reset           ) //in
);


// BMC下发CPU软关机中断信号
wire                                bmc_ctrl_shutdown_neg       ;
reg                                 soft_shutdown               ;
reg [29:0]                          time_cnt                    ;
reg                                 state                       ;

Edge_Detect1 Edge_Detect_u3(
    .i_clk                          (clk_50m                    ),//input Clk
    .i_rst_n                        (pon_reset_n                ),//Global rst,Active Low
    .i_signal                       (bmc_ctrl_shutdown          ),
    .o_signal_pos                   (                           ),
    .o_signal_neg                   (bmc_ctrl_shutdown_neg      ),
    .o_signal_invert                (                           )
);

always @(posedge clk_50m or negedge pon_reset_n)begin
	if(~pon_reset_n)begin
		soft_shutdown <= 1'b0;
		time_cnt      <= 30'd0;
		state         <= 0;
	end
	else begin
		case(state)
		   0: begin
				soft_shutdown <= 1'b0;
				time_cnt	  <= 30'd0;
				if(bmc_ctrl_shutdown_neg)
					state	  <= 1;
				else
					state	  <= state;
			end 
            1: begin
				time_cnt	  <=  (time_cnt >= 30'd2000000) ? 30'd0 : time_cnt + 1'd1;
				state		  <= !(time_cnt	>= 30'd2000000)                          ;
				soft_shutdown <=  (time_cnt	>= 30'd1000000)	? 1'b1  : 1'b0           ;
			end
		endcase
	end
end

assign o_CPU0_D0_SOFT_SHUTDOWN_INT_N = soft_shutdown;
// assign o_CPU1_D0_SOFT_SHUTDOWN_INT_N = soft_shutdown;

endmodule