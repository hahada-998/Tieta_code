module Tieta_Feiteng_1001_top(
// 系统时钟
input  i_CLK_PAL_IN_25M                       /* synthesis LOC = "K19"*/,// from  CPLD_M_PWR/OSC3/U26_AU5424GB_DNR               to  CPLD_M                                        default 0  // CPLD_M的25MHz时钟输入


/* begin: I2C */
input  i_BMC_I2C9_PAL_M_SCL_R                 /* synthesis LOC = "C11"*/,// from  BMC_I2C_MUX1/GENZ_168PIN/BMC                   to  CPLD_M                                        default 1  // BMC I2C9 PAL主设备SCL信号输入（反向）
inout  io_BMC_I2C9_PAL_M_SDA_R                /* synthesis LOC = "D11"*/,// from  CPLD_M                                         to  BMC_I2C_MUX1/GENZ_168PIN/BMC                  default 1  // BMC I2C9 PAL主设备SDA信号输入（反向）
input  i_BMC_I2C9_PAL_M_SCL1_R                /* synthesis LOC = "B10"*/,// from  BMC_I2C_MUX1/GENZ_168PIN/BMC                   to  CPLD_M                                        default 1  // BMC I2C9 PAL主设备SCL1信号输入              新增
inout  io_BMC_I2C9_PAL_M_SDA1_R               /* synthesis LOC = "D5"*/ ,// from  CPLD_M                                         to  BMC_I2C_MUX1/GENZ_168PIN/BMC                  default 1  // BMC I2C9 PAL主设备SDA1电源良好信号输入       新增
/* end: I2C */


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


/* begin：BMC 相关信号 */
// BMC UID按钮/卡存在信号
input  i_PAL_BMCUID_BUTTON_R                  /* synthesis LOC = "A17"*/,// from  BMC/GENZ_168PIN                                to  CPLD_M                                       default 1  // BMC UID按钮信号输入                           新增
input  i_PAL_BMC_CARD_PRSNT_N                 /* synthesis LOC = "N15"*/,// from  BMC/GENZ_168PIN                                to  CPLD_M                                       default 0  // BMC卡存在信号输入
// BMC 预留信号
input  i_BMC_RESERVE_19                       /* synthesis LOC = "C18"*/,// from  GENZ_168PIN_J98/BMC                            to  CPLD_M                                        default 1  // BMC 保留信号19, I2C总线的仲裁结果
output o_BMC_RESERVE_18                       /* synthesis LOC = "H19"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号18, I2C总线的仲裁请求信号输出
output o_BMC_RESERVE_17                       /* synthesis LOC = "N19"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号17                               新增
output o_BMC_RESERVE_16                       /* synthesis LOC = "N18"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号16                               新增
output o_BMC_RESERVE_15                       /* synthesis LOC = "M15"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号15                               新增
output o_BMC_RESERVE_14                       /* synthesis LOC = "T20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号14                               新增
output o_BMC_RESERVE_13                       /* synthesis LOC = "U20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号13                               新增
output o_BMC_RESERVE_12                       /* synthesis LOC = "V20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号12                               新增
output o_BMC_RESERVE_11                       /* synthesis LOC = "R17"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号11                               新增
output o_BMC_RESERVE_10                       /* synthesis LOC = "U18"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号10                               新增
input  i_BMC_RESERVE_9                        /* synthesis LOC = "R16"*/,// from  GENZ_168PIN_J98/BMC                            to  CPLD_M                                        default 1  // BMC 保留信号9                                新增
output o_BMC_RESERVE_8                        /* synthesis LOC = "T17"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号8                                新增
input  i_BMC_RESERVE_7                        /* synthesis LOC = "C19"*/,// from  GENZ_168PIN_J98/BMC                            to  CPLD_M                                        default 1  // BMC 保留信号7
output o_BMC_RESERVE_6                        /* synthesis LOC = "E17"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号6
output o_BMC_RESERVE_5                        /* synthesis LOC = "F16"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号5
output o_BMC_RESERVE_4                        /* synthesis LOC = "B20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号4
output o_BMC_RESERVE_3                        /* synthesis LOC = "F18"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号3
output o_BMC_RESERVE_2                        /* synthesis LOC = "E20"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号2
output o_BMC_RESERVE_1                        /* synthesis LOC = "F19"*/,// from  CPLD_M                                         to  GENZ_168PIN_J98/BMC                           default 1  // BMC 保留信号1
/* end：BMC 相关信号 */


/* begin: BIOS 相关信号 */
output o_BIOS0_RST_N_R                        /* synthesis LOC = "K18"*/,// from  CPLD_M                                         to  BIOS_FLASH0/BIOS0_RST_N                      default 1  // BIOS0复位信号输出
output o_BIOS1_RST_N_R                        /* synthesis LOC = "B2"*/ ,// from  CPLD_M                                         to  BIOS_FLASH1/BIOS1_RST_N                      default 1  // BIOS I2C SMBUS复位信号输出                      
/* end: BIOS 相关信号 */


/* begin: CPLD_M 与 CPLD_S 之间的交换信号 */
output o_CPLD_M_S_EXCHANGE_S1_R               /* synthesis LOC = "J14"*/,// from  CPLD_M                                         to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的交换信号S1输出            新增
input  i_CPLD_M_S_EXCHANGE_S2_R               /* synthesis LOC = "F20"*/,// from  CPLD_S                                         to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的交换信号S2输入            新增
output o_CPLD_M_S_EXCHANGE_S3_R               /* synthesis LOC = "H17"*/,// from  CPLD_M                                         to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的交换信号S3输出   
input  i_CPLD_M_S_EXCHANGE_S4_R               /* synthesis LOC = "J16"*/,// from  CPLD_S                                         to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的交换信号S4输入            新增
output o_CPLD_M_S_EXCHANGE_S5_R               /* synthesis LOC = "J18"*/,// from  CPLD_M                                         to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的交换信号S5输出            新增
/* end: CPLD_M 与 CPLD_S 之间的交换信号 */


/* begin: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */
output o_CPLD_M_S_SGPIO_CLK_R                 /* synthesis LOC = "D18"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO时钟信号输出
output o_CPLD_M_S_SGPIO_LD_N_R                /* synthesis LOC = "J20"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO负载使能信号输出
output o_CPLD_M_S_SGPIO_MOSI_R                /* synthesis LOC = "F10"*/,// from  CPLD_M                                         to  CPU_VR8_Controler                            default 1  // S_SGPIO 主设备MOSI信号输出
input  i_CPLD_M_S_SGPIO_MISO                  /* synthesis LOC = "H15"*/,// from  CPLD_S                                        to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的SGPIO MISO信号输入

output o_CPLD_M_S_SGPIO1_CLK_R                /* synthesis LOC = "G15"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1时钟信号输出
output o_CPLD_M_S_SGPIO1_LD_N_R               /* synthesis LOC = "K17"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1负载使能信号输出
output o_CPLD_M_S_SGPIO1_MOSI_R               /* synthesis LOC = "C20"*/,// from  CPLD_M                                        to  CPLD_S                                       default 1  // CPLD_M到CPLD_S的SGPIO1 MOSI信号输出
input  i_CPLD_M_S_SGPIO1_MISO                 /* synthesis LOC = "F17"*/,// from  CPLD_S                                        to  CPLD_M                                       default 1  // CPLD_S到CPLD_M的SGPIO1 MISO信号输入
/* end: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */


/* begin: CPU0/1 D0/D1相关信号 */
// CPU0 D0 区域信号
input  i_CPU0_D0_CRU_RST_OK                   /* synthesis LOC = "Y13"*/,// form  CPU0_GPIO1/D0_CRU_RST_OK                      to  CPLD_M                                       default 0  // CPU0 D0 区域CRU复位完成信号
input  i_CPU0_D0_BIOS_OVER                    /* synthesis LOC = "U10"*/,// from  CPU0_GPIO1/D0_UART2_RXD                       to  CPLD_M                                       default 0  // CPU0 D0 区域BIOS超时信号

input  i_CPU0_D0_MEMORY_POWER_INT_N           /* synthesis LOC = "R13"*/,// from  CPU0_GPIO1/D0_QSPI_CSN[3]                     to  CPLD_M                                       default 0  // CPU0 D0 区域 VDD_IO_P1V8 电源中断 初始化信号
input  i_CPU0_D0_PCIE_RST                     /* synthesis LOC = "R11"*/,// form  CPU0_GPIO1/D0_PCIE_RST                        to  CPLD_M                                       default 1  // CPU0 D0 区域 VDD_IO_P1V8 电源中断 PCIe 链路复位信号

input  i_CPU0_D0_PWR_CTR0_R                   /* synthesis LOC = "Y2"*/, // form  CPU0_GPIO1/D0_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU0 D0 区域电源控制信号0（cpu的状态反馈, 解除重上电）
input  i_CPU0_D0_PWR_CTR1_R                   /* synthesis LOC = "V6"*/, // from  CPU0_GPIO1/D0_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU0 D0 区域电源控制信号1（cpu的状态反馈, 控制重上电）

input  i_CPU0_D0_GPIO_PORT0_R                 /* synthesis LOC = "V10"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[0]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 0
input  i_CPU0_D0_GPIO_PORT1_R                 /* synthesis LOC = "W11"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[1]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 1
input  i_CPU0_D0_GPIO_PORT2_R                 /* synthesis LOC = "P12"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[2]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 2
input  i_CPU0_D0_GPIO_PORT3_R                 /* synthesis LOC = "U11"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[3]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 3
input  i_CPU0_D0_GPIO_PORT4_R                 /* synthesis LOC = "W1"*/ ,// form  CPU0_GPIO1/D0_GPIO_PORT[0]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 4  新增
input  i_CPU0_D0_GPIO_PORT5_R                 /* synthesis LOC = "R6"*/ ,// form  CPU0_GPIO1/D0_GPIO_PORT[5]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 5  新增
input  i_CPU0_D0_GPIO_PORT6_R                 /* synthesis LOC = "T6"*/ ,// form  CPU0_GPIO1/D0_GPIO_PORT[6]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 6  新增
input  i_CPU0_D0_GPIO_PORT7_R                 /* synthesis LOC = "P7"*/ ,// from  CPU0_GPIO1/D0_GPIO_PORT[7]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 7  新增
input  i_CPU0_D0_DOWN_GPIO8_RST_N             /* synthesis LOC = "W10"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[8]                    to  CPLD_M                                       default 0  // CPU0 D0 区域下行GPIO8复位信号
input  i_CPU0_D0_GPIO_PORT9_R                 /* synthesis LOC = "R7"*/ ,// from  CPU0_GPIO1/D0_GPIO_PORT[9]                    to  CPLD_M                                       default 0  // CPU0 D0 区域通用输入输出端口 9  新增
input  i_CPU0_D0_GPIO_PORT10_R                /* synthesis LOC = "Y3"*/ ,// from  CPU0_GPIO1/D0_GPIO_PORT[10]                   to  CPLD_M                                       default 1  // CPU0 D0 区域通用输入输出端口 10 新增

// CPU0 D1 区域信号
input  i_CPU0_D1_CRU_RST_OK                   /* synthesis LOC = "P9"*/, // from  CPU0_GPIO2/D1_CRU_RST_OK                      to  CPLD_M                                       default 1  // CPU0 D1 区域CRU复位完成信号
input  i_CPU0_D1_PCIE_RST                     /* synthesis LOC = "Y8"*/, // from  CPU0_GPIO2/D1_PCIE_RST                        to  CPLD_M                                       default 1  // CPU0 D1 区域 VDD_IO_P1V8 电源中断 PCIe 链路复位信号

input  i_CPU0_D1_PWR_CTR0_R                   /* synthesis LOC = "Y6"*/, // from  CPU0_GPIO2/D1_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU0 D1 区域电源控制信号0
input  i_CPU0_D1_PWR_CTR1_R                   /* synthesis LOC = "W3"*/, // from  CPU0_GPIO2/D1_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU0 D1 区域电源控制信号1

input  i_CPU0_D1_SPI0_SCK                     /* synthesis LOC = "W12"*/,// from  CPU0_GPIO2/D1_SPIO_SCK                        to  CPLD_M                                       default 1  // CPU0 D1 区域SPI0 SCK信号 
input  i_CPU0_D1_SPI0_CS                      /* synthesis LOC = "P10"*/,// from  CPU0_GPIO2/D1_SPIO_CSN0                       to  CPLD_M                                       default 1  // CPU0 D1 区域SPI0 片选信号 
input  i_CPU0_D1_SPI0_MISO_R                  /* synthesis LOC = "V9"*/ ,// from  CPU0_GPIO2/D1_SPI0_MISO                       to  CPLD_M                                       default 1  // CPU0 D1 区域SPI0 MISO信号

input  i_CPU0_RST_VPP_I2C_N                   /* synthesis LOC = "R10"*/,// from  CPU0_GPIO1/D0_GPIO_PORT[11]                   to  CPLD_M                                       default 0  // CPU0 VPP电源域 VDD_IO_P1V8 电源中断 I2C复位信号

input  i_CPU0_VR8_CAT_FLT                     /* synthesis LOC = "V1"*/ ,// from  CPU_VR8_Controler/VR_FAULT                    to  CPLD_M                                       default 1  // CPU0 VR8 CAT故障信号输入
input  i_CPU0_VR_ALERT_N_R                    /* synthesis LOC = "T1"*/ ,// from  CPU_VR8_Controler/I2C_VR_ALERT_N              to  CPLD_M                                       default 1  // CPU0 电压调节器告警信号输入             新增       


// CPU1 D0 区域信号
input  i_CPU1_D0_CRU_RST_OK                   /* synthesis LOC = "V13"*/,// form  CPU1_GPIO1/D0_CRU_RST_OK                      to  CPLD_M                                       default 1  // CPU1 D0 区域CRU复位完成信号
input  i_CPU1_D0_BIOS_OVER                    /* synthesis LOC = "Y12"*/,// from  CPU1_GPIO1/D0_UART2_RXD                       to  CPLD_M                                       default 1  // CPU1 D0 区域BIOS超时信号 

input  i_CPU1_D0_DOWN_GPIO8_RST_N             /* synthesis LOC = "P14"*/,// from  CPU1_GPIO1/D0_GPIO_PORT[8]                    to  CPLD_M                                       default 0  // CPU1 D0 区域 VDD_IO_P1V8 GPIO8复位信号
input  i_CPU1_D0_MEMORY_POWER_INT_N           /* synthesis LOC = "V14"*/,// from  CPU1_GPIO1/D0_QSPI_CSN[3]                     to  CPLD_M                                       default 0  // CPU1 D0 区域 VDD_IO_P1V8 电源中断 初始化信号
input  i_CPU1_D0_PCIE_RST                     /* synthesis LOC = "T16"*/,// from  CPU1_GPIO1/D0_PCIE_RST                        to  CPLD_M                                       default 1  // CPU1 D0 区域 PCIe 链路复位信号

input  i_CPU1_D0_PWR_CTR0_R                   /* synthesis LOC = "T9"*/, // from  CPU1_GPIO1/D0_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU1 D0 区域电源控制信号0
input  i_CPU1_D0_PWR_CTR1_R                   /* synthesis LOC = "R8"*/, // from  CPU1_GPIO1/D0_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU1 D0 区域电源控制信号1

input  i_CPU1_D0_GPIO_PORT4_R                 /* synthesis LOC = "Y10"*/,// from  CPU1_GPIO1/D0_GPIO_PORT[4]                    to  CPLD_M                                       default 1  // CPU1 D0 区域 通用输入输出端口 4        新增


// CPU1 D1 区域信号
input  i_CPU1_D1_CRU_RST_OK                   /* synthesis LOC = "W14"*/,// form  CPU1_GPIO2/D1_CRU_RST_OK                      to  CPLD_M                                       default 1  // CPU1 D1 区域CRU复位完成信号
input  i_CPU1_D1_PCIE_RST                     /* synthesis LOC = "T14"*/,// from  CPU1_GPIO2/D1_PCIE_RST                        to  CPLD_M                                       default 1  // CPU1 D1 区域PCIE复位信号

input  i_CPU1_D1_PWR_CTR0_R                   /* synthesis LOC = "W15"*/,// from  CPU1_GPIO2/D1_PWR_CTR[0]                      to  CPLD_M                                       default 1  // CPU1 D1 区域电源控制信号0
input  i_CPU1_D1_PWR_CTR1_R                   /* synthesis LOC = "Y19"*/,// from  CPU1_GPIO2/D1_PWR_CTR[1]                      to  CPLD_M                                       default 1  // CPU1 D1 区域电源控制信号1

input  i_CPU1_PE1_RST_N_R                     /* synthesis LOC = "G13"*/,// from  CPU1_MCIO_2/3 / J23_G97V22312HR               to  CPLD_M                                       default 1  // CPU1 PE1(process element)复位信号输入
input  i_CPU1_PE2_RST_N_R                     /* synthesis LOC = "F12"*/,// from  CPU1_MCIO_2/3 / J23_G97V22312HR               to  CPLD_M                                       default 1  // CPU1 PE2(process element)复位信号输入

input  i_CPU1_RST_VPP_I2C_N                   /* synthesis LOC = "W6"*/, // from  CPU1_GPIO1/D0_GPIO_PORT[11]                   to  CPLD_M                                       default 0  // CPU1 VPP电源域 VDD_IO_P1V8 电源中断 I2C复位信号

input  i_CPU1_VR8_CAT_FLT                     /* synthesis LOC = "M4"*/ ,// from  CPU_VR8_Controler/VR_FAULT                    to  CPLD_M                                       default 1  // CPU1 VR8 CAT故障信号输入                    
input  i_CPU1_VR_ALERT_N_R                    /* synthesis LOC = "T2"*/ ,// from  CPU_VR8_Controler/I2C_VR_ALERT_N              to  CPLD_M                                       default 1  // CPU1电压调节器告警信号输入             新增      

input  i_CPU01_TIMER_FORCE_START              /* synthesis LOC = "V15"*/,// 未使用
input  i_PAL_CPU0_TMP_ALERT_N                 /* synthesis LOC = "T4"*/ ,// from  CPU0_TMP/U187_EMC1413_A_AIA_TR                to  CPLD_M                                       default 0  // CPU0 温度告警信号输入
input  i_PAL_CPU0_VR_PMALT_R                  /* synthesis LOC = "P8"*/, // from  S5000C32_3200_C/CPU0_GPIO1/PMBALERT_IN_N      to  CPLD_M                                       default 1  // CPU0 电压调节器（VR）上报电源异常状态    
input  i_PAL_CPU0_VR_SELECT_N_R               /* synthesis LOC = "C16"*/,// from  CPU_I2C_LEVEL_TRAN/U32_PAL_CPU0_VR_SELECT_N   to  CPLD_M                                       default 0  // CPU0 电压调节器选择信号输入（反向）

input  i_PAL_CPU1_TMP_ALERT_N                 /* synthesis LOC = "N3"*/ ,// from  CPU1_TMP/U188_EMC1413_A_AIA_TR                to  CPLD_M                                       default 0  // CPU1温度告警信号输入              
/* end: CPU0/1 D0/D1相关信号 */


// 风扇 控制信号
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

input  i_PAL_FAN0_PWM_R                       /* synthesis LOC = "D10"*/,// from  FAN_CONN/J5_AWAF0055_P002A                     to  CPLD_M                                      default 1  // 风扇0 PWM调速信号输入                新增

// 机箱安全检测接口
input  i_FRONT_PAL_INTRUDER                   /* synthesis LOC = "C10"*/,// from  INTRUDER_CONN                                 to  CPLD_M                                       default 1  // 机箱安全检测接口

// 网口芯片的管理GPIO信号
input  i_MNG_GPIO_0_PCIE_R                    /* synthesis LOC = "C12"*/,// from  P12V_DISCHARGE/U20_WX1860A2                   to  CPLD_M                                       default 1  // 网口芯片的管理GPIO0 PCIe信号输入      新增

// 88SE9230 PCIE转SATA芯片唤醒信号
input  i_PAL_88SE9230_WAKE_N                  /* synthesis LOC = "K4"*/ ,// from  PEX_88SE9230/U93_XSAT2204LACGR                to  CPLD_M                                       default 1  // 88SE9230芯片唤醒信号输入





/* begin: 电源上下电管理信号 */
// 主模块 电源良好信号
input  i_PAL_MAIN_PWR_OK                      /* synthesis LOC = "K7"*/ ,// from  RISER_AUX/J16                                 to  CPLD_M                                       default 1  // 主模块电源良好信号输入

// 12V 主供电模块 电源滤波信号
input  i_PAL_P12V_CPU0_VIN_FLTB               /* synthesis LOC = "N2"*/ ,// from  CURRENT_DET0/P12V_CPU0_FLTB                   to  CPLD_M                                       default 1  // 12V CPU0输入电源滤波信号输入                   新增
input  i_PAL_P12V_CPU0_VIN_PG                 /* synthesis LOC = "N1"*/ ,// from  CURRENT_DET0/P12V_CPU0_VIN                    to  CPLD_M                                       default 1  // 12V CPU0输入电源良好信号输入                   新增
input  i_PAL_P12V_CPU1_VIN_FLTB               /* synthesis LOC = "P2"*/ ,// from  CURRENT_DET0/P12V_CPU1_FLTB                   to  CPLD_M                                       default 1  // 12V CPU1输入电源滤波信号输入                   新增
input  i_PAL_P12V_CPU1_VIN_PG                 /* synthesis LOC = "P1"*/ ,// from  CURRENT_DET0/P12V_CPU1_VIN                    to  CPLD_M                                       default 1  // 12V CPU1输入电源良好信号输入                      // 新增
// 12V PGD压降信号输入
input  i_PAL_PGD_P12V_DROOP                   /* synthesis LOC = "B14"*/,// from  P12V_DROOP                                     to  CPLD_M                                       default 1  // 12V PGD压降信号输入
// 12V 待机PGD压降信号输入
input  i_PAL_PGD_P12V_STBY_DROOP              /* synthesis LOC = "D8"*/ ,// from  P12V_DROOP                                     to  CPLD_M                                       default 1  // 12V待机PGD压降信号输入

// 12V 风扇供电模块 电源良好信号
input  i_PAL_P12V_FAN0_PG                     /* synthesis LOC = "F4"*/ ,// from  FAN_PWR/PAL_P12V_FAN0_PG                       to  CPLD_M                                       default 1  // 12V风扇0电源良好信号输入                          // 新增
input  i_PAL_P12V_FAN0_FLTB                   /* synthesis LOC = "F3"*/ ,// from  FAN_PWR/PAL_P12V_FAN0_FLTB                     to  CPLD_M                                       default 1  // 12V风扇0故障信号输入                             // 新增
input  i_PAL_P12V_FAN1_PG                     /* synthesis LOC = "H6"*/ ,// from  FAN_PWR/PAL_P12V_FAN1_PG                       to  CPLD_M                                       default 1  // 12V风扇1电源良好信号输入                          // 新增
input  i_PAL_P12V_FAN1_FLTB                   /* synthesis LOC = "H7"*/ ,// from  FAN_PWR/PAL_P12V_FAN1_FLTB                     to  CPLD_M                                       default 1  // 12V风扇1故障信号输入                             // 新增
input  i_PAL_P12V_FAN2_PG                     /* synthesis LOC = "E2"*/ ,// from  FAN_PWR/PAL_P12V_FAN2_PG                       to  CPLD_M                                       default 1  // 12V风扇2电源良好信号输入                         // 新增
input  i_PAL_P12V_FAN2_FLTB                   /* synthesis LOC = "E1"*/ ,// from  FAN_PWR/PAL_P12V_FAN2_FLTB                     to  CPLD_M                                       default 1  // 12V风扇2故障信号输入                             // 新增
input  i_PAL_P12V_FAN3_PG                     /* synthesis LOC = "F2"*/ ,// from  FAN_PWR/PAL_P12V_FAN3_PG                       to  CPLD_M                                       default 1  // 12V风扇3电源良好信号输入                         // 新增
input  i_PAL_P12V_FAN3_FLTB                   /* synthesis LOC = "F1"*/ ,// from  FAN_PWR/PAL_P12V_FAN3_FLTB                     to  CPLD_M                                       default 1  // 12V风扇3故障信号输入                             // 新增

// 3.3V 主供电模块 电源良好信号
input  i_PAL_P3V3_STBY_PGD                    /* synthesis LOC = "L16"*/,// from  PWR_P3V3_STBY/PAL_P3V3_STBY_PGD               to  CPLD_M                                       default 1  // 3v3待机电源良好信号输入

// 5.0V 主供电模块 电源良好信号
input  i_PAL_P5V_STBY_PGD                     /* synthesis LOC = "B11"*/,// from  PWR_P5V_STBY                                   to  CPLD_M                                       default 1  // 5V待机PGD信号输入

// 1.8V CPLD供电模块 电源良好信号
input  i_P1V8_STBY_CPLD_PG                    /* synthesis LOC = "K16"*/,// from  PSU/RS31386/RS53317/3.3STBY/TPL910ADJ         to  CPLD_M                                       default 1  // CPLD_M的1V8_STBY_PG信号输入

// 1.8V 88SE9230 PCIE转SATA芯片 电源良好信号
input  i_PAL_PGD_88SE9230_P1V8_R              /* synthesis LOC = "B16"*/,// from  PEX_88SE9230/U93_XSAT2204LACGR                 to  CPLD_M                                       default 1  // 88SE9230 1.8V PGD信号输入                    新增

// 1.1V 88SE9230 PCIE转SATA芯片 电源良好信号
input  i_PAL_PGD_88SE9230_VDD1V0              /* synthesis LOC = "D19"*/,// from  3V3M2/SMG61030_3V3to1v1                       to  CPLD_M                                       default 1  // 88SE9230 VDD1V0电源良好信号输入

// 1.1V 主供电模块 电源良好信号
input  i_PAL_VCC_1V1_PG                       /* synthesis LOC = "G16"*/,// from  WX1860_POL_SGM61030_3V3to1V1/PAL_VCC_1V1_PG   to  CPLD_M                                       default 1  // 1v1电源良好信号输入

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


// CPU0 GPIO/VT_AVDDH/EFUSE 模块 1.8V 电源良好信号
input  i_PAL_CPU0_P1V8_PG                     /* synthesis LOC = "M7"*/ ,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU0 GPIO/VT_AVDDH/EFUSE 模块 1.8V 电源良好信号输入
// CPU0 PLL 区域 1.8V 电源良好信号
input  i_PAL_CPU0_PLL_P1V8_PG                 /* synthesis LOC = "U2"*/ ,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU0 PLL区域                  1.8V 电源良好信号输入    
// CPU0 DIMM 3.3V 电源良好信号
input  i_PAL_CPU0_DIMM_PWRGD_F                /* synthesis LOC = "M16"*/,// from  CPU0_DIMM0_WHITE/J1001/CPU0_DDR0_PWRGD         to  CPLD_M                                       default 1  // CPU0 DIMM槽位                 3.3V 电源良好信号输入
// CPU0 D0和D1区域 1.8V VPH 低速相关辅助电路链路 电源良好信号
input  i_PAL_CPU0_D0_VPH_1V8_PG               /* synthesis LOC = "T5"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU0 D0 区域 VPH              1.8V 电源良好信号输入       新增
input  i_PAL_CPU0_D1_VPH_1V8_PG               /* synthesis LOC = "R5"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU0 D1 区域 VPH              1.8V 电源良好信号输入       新增
// CPU0 D0和D1区域 0.9V VP 高速相关辅助电路链路 电源良好信号
input  i_PAL_CPU0_D0_VP_0V9_PG                /* synthesis LOC = "V2"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/.._PG        to  CPLD_M                                       default 1  // CPU0 D0 区域 VP               0.9V 电源良好信号输入       新增
input  i_PAL_CPU0_D1_VP_0V9_PG                /* synthesis LOC = "N6"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/.._PG        to  CPLD_M                                       default 1  // CPU0 D1 区域 VP               0.9V 电源良好信号输入       新增
// CPU0 DDR内存控制器总线 1.1V 电源良好信号
input  i_PAL_CPU0_VDDQ_P1V1_PG                /* synthesis LOC = "B1"*/ ,// from  CPU_VR8_Controler/.._PG                        to  CPLD_M                                       default 1  // CPU0 DDR内存控制器总线         1.1V 电源良好信号输入       新增
// CPU0 DDR内存颗粒核心 0.8V 电源良好信号
input  i_PAL_CPU0_DDR_VDD_PG                  /* synthesis LOC = "L7"*/ ,// from  CPU_DDR_HM_PLL_VDDA_P0V8/.._PG                 to  CPLD_M                                       default 1  // CPU0 DDR内存颗粒核心           0.8V 电源良好信号输入
// CPU0 CPU运算核心 0.8V 电源良好信号
input  i_PAL_CPU0_VDD_VCORE_P0V8_PG           /* synthesis LOC = "M18"*/,// from  CPU_VR8_Controler/.._PG                        to  CPLD_M                                       default 1  // CPU0 CPU运算核心、缓存         0.8V 电源良好信号输入       新增


// CPU1 GPIO/VT_AVDDH/EFUSE 模块 1.8V 电源良好信号
input  i_PAL_CPU1_P1V8_PG                     /* synthesis LOC = "C15"*/,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU1 PLL 1.8V电源良好信号输入
// CPU1 PLL 区域 1.8V 电源良好信号
input  i_PAL_CPU1_PLL_P1V8_PG                 /* synthesis LOC = "B18"*/,// from  CPU_PLL_P1V8/.._PG                             to  CPLD_M                                       default 1  // CPU1 PLL 1.8V电源良好信号输入
// CPU1 DIMM 3.3V 电源良好信号
input  i_PAL_CPU1_DIMM_PWRGD_F                /* synthesis LOC = "D15"*/,// from  CPU1_DIMM3_WHITE/J1001/CPU0_DDR0_PWRGD         to  CPLD_M                                       default 1  // CPU1 DIMM槽位                 3.3V 电源良好信号输入
// CPU1 D0和D1区域 1.8V VPH 低速相关辅助电路链路 电源良好信号
input  i_PAL_CPU1_D0_VPH_1V8_PG               /* synthesis LOC = "P5"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU1 D0 区域 VPH              1.8V 电源良好信号输入       新增
input  i_PAL_CPU1_D1_VPH_1V8_PG               /* synthesis LOC = "V4"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU1 D1 区域 VPH              1.8V 电源良好信号输入       新增
// CPU1 D0和D1区域 0.9V VP 高速相关辅助电路链路 电源良好信号
input  i_PAL_CPU1_D0_VP_0V9_PG                /* synthesis LOC = "M6"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53319/.._PG        to  CPLD_M                                       default 1  // CPU1 D0 区域 VP               0.9V 电源良好信号输入       新增
input  i_PAL_CPU1_D1_VP_0V9_PG                /* synthesis LOC = "N4"*/ ,// from  CPU_PCIE_C2C_VP_VPH/8633B&RS53318/.._PG        to  CPLD_M                                       default 1  // CPU1 D1 区域 VP               0.9V 电源良好信号输入       新增
// input  i_PAL_CPU1_PCIE_P0V9_PG             /* synthesis LOC = "D5"*/,
// CPU1 DDR内存控制器总线 1.1V 电源良好信号
input  i_PAL_CPU1_VDDQ_P1V1_PG                /* synthesis LOC = "G10"*/,// from  CPU_VR8_Controler                              to  CPLD_M                                       default 1  // CPU1 DDR VDDQ 1.1V电源良好信号输入            新增 
// CPU1 DDR内存颗粒核心 0.8V 电源良好信号
input  i_PAL_CPU1_DDR_VDD_PG                  /* synthesis LOC = "A5"*/ ,// from  CPU_DDR_HM_PLL_VDDA_P0V8/.._PG                 to  CPLD_M                                       default 1  // CPU1 DDR内存颗粒核心           0.8V 电源良好信号输入
// CPU1 CPU运算核心 0.8V 电源良好信号
input  i_PAL_CPU1_VDD_VCORE_P0V8_PG           /* synthesis LOC = "A10"*/,// from  CPU_VR8_Controler                              to  CPLD_M                                       default 1  // CPU1 PCIe 0.9V电源良好信号输入
/* end:电源上下电管理信号 */


/* begin: DEBUG 信号 */
// 机箱后部面向背板的辅助供电模块 电源良好信号
input  i_PAL_BP1_CPU_1P2P                     /* synthesis LOC = "B3"*/ ,// from  BP_AUX_PWR/J84                                 to  CPLD_M                                       default 1  // BP1 CPU 配置检测与模式控制, 告知 CPLD 当前系统处于 1P（单 CPU）或 2P（双 CPU）配置，并据此切换平台的供电、内存映射与 I/O 拓扑规则
input  i_PAL_BP2_CPU_1P2P                     /* synthesis LOC = "A4"*/ ,// from  BP_AUX_PWR/J86                                 to  CPLD_M                                       default 1  // BP1 CPU 配置检测与模式控制, 告知 CPLD 当前系统处于 1P（单 CPU）或 2P（双 CPU）配置，并据此切换平台的供电、内存映射与 I/O 拓扑规则
input  i_PAL_BP1_PRSNT_N                      /* synthesis LOC = "A9"*/ ,// from  BP_AUX_PER/J84                                 to  CPLD_M                                       default 1  // BP1 存在信号输入（低电平有效）                  新增
input  i_PAL_BP2_PRSNT_N                      /* synthesis LOC = "C6"*/ ,// from  BP_AUX_PWR/J86                                 to  CPLD_M                                       default 1  // BP2 存在信号输入（低电平有效）                  新增
input  i_PAL_REAT_BP_EFUSE_OC                 /* synthesis LOC = "L3"*/ ,// from  CURRENT_DET1/P12V_REAR_BP_VIN                  to  CPLD_M                                       default 1  // REAT BP eFUSE过流信号输入                     // 新增
input  i_PAL_REAT_BP_EFUSE_PG                 /* synthesis LOC = "M2"*/ ,// from  CURRENT_DET1/P12V_REAR_BP_VIN                  to  CPLD_M                                       default 1  // REAT BP eFUSE电源良好信号输入                 // 新增

input  i_PAL_DB_GPIO0_R                       /* synthesis LOC = "G4"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO0           to  CPLD_M                                       default 1  // DEBUG GPIO0信号输入                              // 新增
input  i_PAL_DB_GPIO1_R                       /* synthesis LOC = "G3"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO1           to  CPLD_M                                       default 1  // DEBUG GPIO1信号输入                              // 新增
input  i_PAL_DB_GPIO2_R                       /* synthesis LOC = "H3"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO2           to  CPLD_M                                       default 1  // DEBUG GPIO2信号输入                              // 新增
input  i_PAL_DB_GPIO3_R                       /* synthesis LOC = "H4"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO2           to  CPLD_M                                       default 1  // DEBUG GPIO2信号输入                              // 新增
input  i_PAL_DB_GPIO4_R                       /* synthesis LOC = "G2"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO4           to  CPLD_M                                       default 1  // DEBUG GPIO4信号输入                              // 新增
input  i_PAL_DB_GPIO5_R                       /* synthesis LOC = "J5"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/DB_GPIO5           to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增
input  i_PAL_DB_INT_N_R                       /* synthesis LOC = "H2"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/PAL_DB_INIT_N      to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增
input  i_PAL_DB_ON_N_R                        /* synthesis LOC = "G1"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/PAL_DB_ON_N        to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增
input  i_PAL_DB_PRSNT_N_R                     /* synthesis LOC = "J6"*/ ,// from  DB_MODULE/J33_1338_201_8Q_N/PAL_DB_PRSNT_N     to  CPLD_M                                       default 0  // DEBUG 信号输入                                   // 新增

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
/* end: DEBUG 信号 */


);


