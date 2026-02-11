`include "as03mb03_define.v"
`include "pwrseq_define.v"
`include "tpm_define.v"
module Tieta_Feiteng_2001_top(
    // 系统时钟
    input   i_CLK_C42_IN_25M                        /* synthesis LOC = "U1" */,// from  PLL                                          to  CPLD_S                                           default 1  // 25M 时钟 信号 CK440
                                                        
    output  o_PAL_BMC_SS_CLK                        /* synthesis LOC = "L17" */,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC 串行时钟 信号
    output	o_PAL_BMC_SS_LOAD_N	                    /* synthesis LOC = "M16"*/ ,// from  CPLD_S                                        to  GENZ_168PIN/J98_5653E5-001H1020T                 default 0  // “PCH（平台控制器中心）向 BMC（基板管理控制器）发送的串行信号加载使能信号 
    output	o_PAL_BMC_SS_DATA_OUT	                /* synthesis LOC = "M15"*/ ,// from  CPLD_S                                        to  GENZ_168PIN/J98_5653E5-001H1020T                 default 0  // “PCH（平台控制器中心）向 BMC（基板管理控制器）发送的串行数据信号”
    input   i_PAL_BMC_SS_DATA_IN                    /* synthesis LOC = "N17" */,// from  GENZ_168PIN                                  to  CPLD_S                                           default 1  // BMC 串行数据 输入 信号                                      
                                            
    /* begin: JTAG 接口*/
    // 专用引脚暂不使用
    // input   i_PAL_S_DONE                            /* synthesis LOC = "A19"*/,// from  S_DONE / J32                                 to  CPLD_S                                           default 1  // PAL S DONE 信号
    // input   i_PAL_S_INITN                           /* synthesis LOC = "C17"*/,// from  S_INITN / J31                                to  CPLD_S                                           default 1  // PAL S INITN 信号
    // input   i_PAL_S_JTAGEN                          /* synthesis LOC = "C13"*/,// from  JTAG_EN / J11                                to  CPLD_S                                            default 1  // PAL S JTAGEN 信号
    // input   i_PAL_S_PROGRAM_N                       /* synthesis LOC = "D13"*/,// from  S_PROGRAM_N / J13                            to  CPLD_S                                            default 1  // PAL S PROGRAM_N 信号
    // input   i_PAL_S_SN                              /* synthesis LOC = "Y20"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                           default 1  // S_SN 信号 UPD1/UPD2 序列号 信号
    // output  i_PAL2_TDO                              /* synthesis LOC = "E8"*/,// from  JTAG_TDO / J12                                to  CPLD_S                                           default 1  // PAL2 TDO 信号
    // input   i_PAL2_TDI                              /* synthesis LOC = "C7"*/,// from  JTAG_TDO / J12                                to  CPLD_S                                           default 1  // PAL2 TDO 信号
    // input   i_PAL2_TCK                              /* synthesis LOC = "C9"*/,// from  JTAG_TDO / J12                                to  CPLD_S                                           default 1  // PAL2 TDO 信号
    // input   i_PAL2_TMS                              /* synthesis LOC = "D9"*/,// from  JTAG_TDO / J12                                to  CPLD_S                                           default 1  // PAL2 TDO 信号
    
    /* end: JTAG 接口*/

    /* begin: I2C 接口*/
    input   i_CPU0_D0_I2C1_PE_STRAP_SCL             /* synthesis LOC = "A4"*/ ,// from  CPU_I2C_LEVEL_TRAN / U97_CA9617MMR           to  CPLD_S                                           default 1  // CPU0 D0 I2C1 PE STRAP SCL 信号
    inout   io_CPU0_D0_I2C1_PE_STRAP_SDA            /* synthesis LOC = "A3"*/ ,// from  CPU_I2C_LEVEL_TRAN / U97_CA9617MMR           to  CPLD_S                                           default 1  // CPU0 D0 I2C1 PE STRAP SDA 信号    
    
    // 未使用
    input   i_CPU1_D0_I2C1_PE_STRAP_SCL             /* synthesis LOC = "W10"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C             to  CPLD_S                                           default 1  // CPU1 D0 I2C1 PE STRAP SCL 信号
    inout   io_CPU1_D0_I2C1_PE_STRAP_SDA            /* synthesis LOC = "V9"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C             to  CPLD_S                                           default 1  // CPU1 D0 I2C1 PE STRAP SDA 信号
    // 未使用
    output  o_RST_I2C1_MUX_N_R                      /* synthesis LOC = "R20"*/,// from  CPLD_S                                       to  BMC_I2C_MUX1 / U69                               default 1  // I2C1 复位 多路复用器 信号
    output  o_RST_I2C2_MUX_N_R                      /* synthesis LOC = "A6"*/,// from  CPLD_S                                       to  BMC_I2C_MUX1 / U53_CA9545MTR                     default 1  // I2C2 复位 多路复用器 信号
    output  o_RST_I2C3_MUX_N_R                      /* synthesis LOC = "C8"*/,// from  CPLD_S                                       to  RST_I2C3_MUX1 / U242_CA9545MTR                   default 1  // RST I2C3 MUX N 信号
    output  o_RST_I2C4_1_MUX_N_R                    /* synthesis LOC = "A9" */,// from  CPLD_S                                      to  BMC_I2C_MUX2 / U179                              default 1  // I2C4_1 复位 多路复用器 信号
    output  o_RST_I2C4_2_MUX_N_R                    /* synthesis LOC = "R5"*/,// from  CPLD_S                                       to  BMC_I2C_MUX2 / U179                              default 1  // I2C4_2 复位 多路复用器 信号
    output  o_RST_I2C5_MUX_N_R                      /* synthesis LOC  = "A5" */,// from  CPLD_S                                      to  BMC_I2C_MUX1 / U173                              default 1  // I2C5 复位 多路复用器 信号
    output  o_RST_I2C12_MUX_N_R                     /* synthesis LOC = "D10" */,// from  CPLD_S                                      to  BMC_I2C_MUX2 / U10_CA9545MTR                     default 1  // I2C12 复位 多路复用器 信号                      
    output  o_RST_I2C13_MUX_N_R                     /* synthesis LOC = "Y11"*/,// from  CPLD_S                                       to  RST_I2C13_MUX2 / U51                             default 1  // RST I2C13 MUX N 信号   
    output  o_RST_I2C_BMC_9548_MUX_N_R              /* synthesis LOC = "Y14"*/,// from  CPLD_S                                       to  BMC_I2C_MUX2 / U258                              default 1  // RST I2C BMC 9548 MUX N 信号                                           
    /* end: I2C 接口*/


    /* begin: I3C 接口*/
    // input   i_BMC_I2C3_PAL_S_SCL_R                  /* synthesis LOC = "C11"*/,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SCL 信号
    // inout   io_BMC_I2C3_PAL_S_SDA_R                 /* synthesis LOC = "D11"*/,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SDA 信号
    input   i_BMC_I2C3_PAL_S_SCL1_R                 /* synthesis LOC = "W8"*/ ,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SCL1 信号
    inout   io_BMC_I2C3_PAL_S_SDA1_R                /* synthesis LOC = "V8"*/ ,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SDA1 信号
    
    output  o_PAL_CPU0_I3C_SPD_SEL                  /* synthesis LOC = "D7"*/,// from  CPLD_S                                        to  CPU0_I3C_SPD_SEL / J14_G97V22312HR               default 1  // CPU0 I3C SPD 选择 信号
    output  o_PAL_CPU1_I3C_SPD_SEL                  /* synthesis LOC = "B7"*/,// from  CPLD                                           to  CPU0/1_I2C_I3C_SW / U13                          default 1  // PAL CPU1 I3C SPD SEL 信号
    /* begin: I3C 接口*/


    /* begin: UART 接口 */
    // 串口这里需要梳理一下
    input   i_CPU0_D0_UART1_TX                       /* synthesis LOC = "F2"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D0 UART1 发送 信号
    output  o_CPU0_D0_UART1_RX                       /* synthesis LOC = "G2"*/,// from  CPLD_S                                         to  CPU0_GPIO1 / U1_S5000C_32_3200_C                 default 1  // CPU0 D0 UART1 接收 信号
    input   i_CPU0_D1_UART1_TX                       /* synthesis LOC = "D1"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D1 UART1 发送 信号
    output  o_CPU0_D1_UART1_RX                       /* synthesis LOC = "D2"*/,// from  CPLD_S                                         to  CPU0_GPIO1 / U1_S5000C_32_3200_C                 default 1  // CPU0 D1 UART1 接收 信号
    
    input   i_CPU1_D0_UART1_TX                       /* synthesis LOC = "C4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 UART1 发送 信号  
    output  o_CPU1_D0_UART1_RX                       /* synthesis LOC = "F6"*/,// from  CPLD_S                                         to  CPU1_GPIO1 / U2_S5000C_32_3200_C                 default 1  // CPU1 D0 UART1 接收 信号
    input   i_CPU1_D1_UART1_TX                       /* synthesis LOC = "C2"*/,// from  CPU1_GPIO2 / U3_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D1 UART1 发送 信号
    output  o_CPU1_D1_UART1_RX                       /* synthesis LOC = "C1"*/,// from  CPLD_S                                         to  CPU1_GPIO1 / U2_S5000C_32_3200_C                 default 1  // CPU1 D1 UART1 接收 信号
    
    input   i_CPU0_D0_UART_SOUT                      /* synthesis LOC = "F1"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D0 UART 发送 信号
    output  o_CPU0_D0_UART_SIN                       /* synthesis LOC = "E1"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPU0_UART / J614                                 default 1  // CPU0 D0 UART 接收 信号
    input   i_CPU1_D0_UART_SOUT                      /* synthesis LOC = "G5"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 UART 发送 信号
    output  o_CPU1_D0_UART_SIN                       /* synthesis LOC = "C3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPU1_UART / J613                                 default 1  // CPU1 D0 UART 接收 信号

    input   i_JACK_CPU0_D0_UART_SIN                  /* synthesis LOC = "F9"*/,// from  CPU0_UART / J614                             to  CPLD_S                                           default 1  // CPU0 JACK UART 接收 信号
    output  o_JACK_CPU0_D0_UART_SOUT                 /* synthesis LOC = "B10"*/,// from  CPLD_S                                       to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART 发送 信号
    
    input   i_JACK_CPU1_D0_UART_SIN                  /* synthesis LOC = "F11"*/,// from  CPU1_UART / J613                             to  CPLD_S                                           default 1  // CPU1 JACK UART 接收 信号
    output  o_JACK_CPU1_D0_UART_SOUT                 /* synthesis LOC = "F12"*/,// from  CPLD_S                                       to  CPU1_UART / J613                                 default 1  // CPU1 JACK UART 发送 信号

    input   i_DB_UART_RX_R	                         /* synthesis LOC  = "Y15 "*/,// from  DB_MODULE / J33_1338_201_8Q_N                to  CPLD_S                                           default 1  // DB UART 接收 信号
    output  o_DB_UART_TX_R	                         /* synthesis LOC  = "W16 "*/,// from  CPLD_S                                      to  DB_MODULE / J33_1338_201_8Q_N                    default 1  // DB UART 发送 信号       
    
    input   i_DBG_CPU0_UART1_RX_CONN_R               /* synthesis LOC = "V19"*/,// from  J29_10317724B001                              to  CPLD_S                                           default 1  // CPU0 DEBUG UART1 接收 信号
    output  o_DBG_CPU0_UART1_TX_CONN_R               /* synthesis LOC = "W19"*/,// from  CPLD_S                                        to  J29_10317724B001                                 default 1  // CPU0 DEBUG UART1 发送 信号

    input   i_DBG_PAL_BMC_UART1_RX_CONN_R            /* synthesis LOC = "U19"*/,// from  J29_10317724B001                              to  CPLD_S                                           default 1  // BMC DEBUG UART1 接收 信号
    output  o_DBG_PAL_BMC_UART1_TX_CONN_R            /* synthesis LOC = "T19"*/,// from  CPLD_S                                        to  J29_10317724B001                                 default 1  // BMC DEBUG UART1 发送 信号
    
    input   i_JACK_CPU0_UART1_RX                      /* synthesis LOC = "K6"*/,// from  CPLD_S                                       to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART1 接收 信号
    output  o_JACK_CPU0_UART1_TX                      /* synthesis LOC = "E6"*/,// from  CPLD_S                                       to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART 发送 信号

    input   i_JACK_CPU1_UART1_RX                      /* synthesis LOC = "D5"*/,// from  CPU1_UART / J613                             to  CPLD_S                                           default 1  // CPU1 JACK UART1 接收 信号
    output  o_JACK_CPU1_UART1_TX	                  /* synthesis LOC = "B5"*/,// from  CPLD_S                                       to  CPU1_UART / J613                                 default 1  // CPU1 JACK UART 发送 信号
 
    input   i_LEAR_CPU0_UART1_RX                      /* synthesis LOC = "J17"*/,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // CPU0 LEAR UART1 接收 信号
    output  o_LEAR_CPU0_UART1_TX                      /* synthesis LOC = "K17"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // CPU0 LEAR UART1 发送 信号

    input   i_Riser1_TOD_UART_RXD_R                   /* synthesis LOC = "V1"*/ ,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser1 TOD UART 接收 信号       
    output  o_Riser1_TOD_UART_TXD_R	                  /* synthesis LOC = "W1"*/ ,// from  CPLD_S                                       to  RISER1/J1_G64V3421MHR                            default 1  // Riser1 TOD UART 发送 信号
    
    input   i_Riser2_TOD_UART_RXD_R                   /* synthesis LOC = "M19"*/ ,// from  RISER2/J39_G64V3421MHR                       to  CPLD_S                                          default 1  // Riser1 TOD UART 接收 信号
    output  o_Riser2_TOD_UART_TXD_R	                  /* synthesis LOC = "N20"*/ ,// from  CPLD_S                                       to  RISER2/J39_G64V3421MHR                           default 1  // Riser1 TOD UART 发送 信号
    
    input   i_DB9_TOD_UART_RX                         /* synthesis LOC  = "U9"*/,// from  PPS TOD / U88_TPT75176HL1_S01R                to  CPLD_S                                           default 1  // DB9 TOD UART 接收 信号
    output  o_DB9_TOD_UART_TX                         /* synthesis LOC  = "P12" */,// from  CPLD_S                                      to  PPS TOD / U88_TPT75176HL1_S01R                  default 1  // DB9 TOD UART 发送 信号

    input   i_PAL_BMC_UART1_TX                        /* synthesis LOC = "D16" */,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // BMC UART1 发送 信号
    output	o_PAL_BMC_UART1_RX	                      /* synthesis LOC = "E17"*/ ,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC UART1 接收 信号
    
    output  o_PAL_BMC_UART4_RX                        /* synthesis LOC = "H17"*/,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // BMC UART4 接收 信号
    input   i_PAL_BMC_UART4_TX                        /* synthesis LOC = "G14"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC UART4 发送 信号    

    input   i_UART0_CPU_LOG_RX                        /* synthesis LOC = "F16"*/,// from  CPU0_UART / J614                             to  CPLD_S                                           default 1  // CPU0 UART 日志 接收 信号
    output  o_UART0_CPU_LOG_TX                        /* synthesis LOC = "F14"*/,// from  CPLD_S                                      to  CPU0_UART / J614                                 default 1  // CPU0 UART 日志 发送 信号                                                
    
    input   i_RISER_AUX_TOD_UART1_RXD                 /* synthesis LOC = "V12"*/ ,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // Riser AUX TOD UART2 发送 信号
    output  o_RISER_AUX_TOD_UART1_TXD                 /* synthesis LOC = "T11"*/ ,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // Riser AUX TOD UART2 发送 信号
    input   i_RISER_AUX_TOD_UART2_RXD                 /* synthesis LOC = "U12"*/ ,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // Riser AUX TOD UART2 发送 信号
    output  o_RISER_AUX_TOD_UART2_TXD                 /* synthesis LOC = "U11"*/ ,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // Riser AUX TOD UART2 发送 信号
    

    // 串口这里需要梳理一下
    /* end: UART 接口 */

    // RISER1 开关 使能 信号
    output  o_RISER1_SWITCH_EN                       /* synthesis LOC  = "P7"*/,// from  CPLD_S                                       to  RISER1/J1_G64V3421MHR                            default 1  // Riser1 开关 使能 信号
    output  o_RISER1_SELECT                          /* synthesis LOC  = "R7"*/,// from  CPLD_S                                       to  RISER1/J1_G64V3421MHR                            default 1  // Riser1 选择 信号

    /* begin: SPI 接口 */
    output  o_PAL_SPI_SELECT_R                       /* synthesis LOC = "V10"*/,// from  CPLD_S                                         to  BIOS_FLASH1 / U222_SGM6505HYTQF24G_T             default 1  // PAL SPI 选择 信号
    output  o_PAL_SPI_SWITCH_EN_R                    /* synthesis LOC = "Y10"*/,// from  CPLD_S                                        to  BIOS_FALSH0 / U37_SGM6505HYTQF24G_TR             default 1  // SPI 开关 使能 信号
    /* end: SPI 接口 */

    /* begin: CPLD_M 与 CPLD_S 之间的交换信号 */
    input   i_CPLD_M_S_EXCHANGE_S1                  /* synthesis LOC = "D15"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    output  o_CPLD_M_S_EXCHANGE_S2                  /* synthesis LOC = "B14"*/ ,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 交换 信号
    // 未使用
    input   i_CPLD_M_S_EXCHANGE_S3                  /* synthesis LOC = "B15"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    input   i_CPLD_M_S_EXCHANGE_S4                  /* synthesis LOC = "B16"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号                                               
    input   i_CPLD_M_S_EXCHANGE_S5                  /* synthesis LOC = "C16"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    // 未使用
    /* end: CPLD_M 与 CPLD_S 之间的交换信号 */

    /* begin: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */
    input   i_CPLD_M_S_SGPIO_CLK                    /* synthesis LOC = "D17"*/ ,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO 时钟 信号
    input   i_CPLD_M_S_SGPIO_LD_N                   /* synthesis LOC = "B13"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO 加载使能 信号    
    input   i_CPLD_M_S_SGPIO_MOSI                   /* synthesis LOC = "C18"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO MOSI 信号
    output  o_CPLD_M_S_SGPIO_MISO_R                 /* synthesis LOC = "B18"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO MISO 信号
   
    input   i_CPLD_M_S_SGPIO1_CLK                   /* synthesis LOC = "C14"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 时钟 信号
    input   i_CPLD_M_S_SGPIO1_LD_N                  /* synthesis LOC = "B17"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 加载使能 信号
    input   i_CPLD_M_S_SGPIO1_MOSI                  /* synthesis LOC = "C15"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 MOSI 信号
    output  o_CPLD_M_S_SGPIO1_MISO_R                /* synthesis LOC = "F18"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO1 MISO 信号
    /* end: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */

    /* begin: OCP */
    output  o_PAL_UART4_OCP_DEBUG_TX                /* synthesis LOC = "L3"*/ ,// from  CPLD_S                                        to  RISER_AUX/J16                                    default 1  // OCP 调试 UART4 发送 信号
    input   i_PAL_UART4_OCP_DEBUG_RX                /* synthesis LOC = "L5"*/,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // OCP 调试 UART4 接收 信号

    input   i_PAL_BMC_NCSI_CLK_50M_R                /* synthesis LOC = "F17"*/ ,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S_UART_LED_SW                               default 1  // BMC NCSI 时钟 50M 信号
    output  o_PAL_WX1860_NCSI_CLK_50M_R             /* synthesis LOC = "K19"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // WX1860 NCSI 时钟 50M 信号                                                    
    output  o_PAL_WX1860_NCSI_SW_EN_N_R             /* synthesis LOC = "W18"*/,// from  CPLD_S                                       to  U38 -- U20WX1869A2                               default 1  // WX1860 NCSI 开关使能 信号

    output  o_PAL_OCP_NCSI_CLK_50M_R                /* synthesis LOC  = "C10" */,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // OCP NCSI 时钟 50M 信号
    output  o_PAL_OCP_NCSI_SW_EN_N_R                /* synthesis LOC  = "A7" */,// from  CPLD_S                                       to  RISER_AUX/U89_SGM652321XTS20G/TR                 default 1  // OCP NCSI 开关使能 信号

    // output  o_PAL_OCP1_NCSI_EN_N_R                                             , // 暂不使用
    // output  o_PAL_OCP2_NCSI_EN_N_R                                             , // 暂不使用
        
    input   i_PAL_OCP_PRSNT_N                       /* synthesis LOC  = "L6"*/,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // OCP 设备存在 信号
    input   i_PAL_OCP_RISER_CPLD                    /* synthesis LOC  = "B6"*/,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // OCP Riser CPLD 信号
  
    input   i_UART2_PAL_OCP_RX_R                    /* synthesis LOC = "E14"*/,// from  GENZ_168PIN                                   to  CPLD_S                                           default 1  // OCP UART2 接收 信号
    output  o_UART2_PAL_OCP_TX_R                    /* synthesis LOC = "D18"*/,// from  CPLD_S                                        to  RISER_AUX/J16                                    default 1  // OCP UART2 接收 信号    
    
    // output  o_PAL_OCP1_SS_CLK_R                     , // 暂不使用
    // output  o_PAL_OCP1_SS_LD_N_R                    , // 暂不使用
    // input   i_PAL_OCP1_SS_DATA_IN_R                 , // 暂不使用
    // output  o_PAL_OCP2_SS_CLK_R                     , // 暂不使用
    // output  o_PAL_OCP2_SS_LD_N_R                    , // 暂不使用
    // input   i_PAL_OCP2_SS_DATA_IN_R                 , // 暂不使用
    /* end: OCP */

    /* begin: GPIO CPU0/1 D0/D1相关信号 */
    // 信号不使用, 保留接口
    input   i_CPU1_D0_GPIO_PORT0_R                   /* synthesis LOC = "F3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口0 信号
    input   i_CPU1_D0_GPIO_PORT1_R                   /* synthesis LOC = "F4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口1 信号
    input   i_CPU1_D0_GPIO_PORT2_R                   /* synthesis LOC = "E3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口2 信号
    input   i_CPU1_D0_GPIO_PORT3_R                  /* synthesis LOC  = "J3"*/ ,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口3 信号
    input   i_CPU1_D0_GPIO_PORT4_R                   /* synthesis LOC = "H4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口4 信号
    input   i_CPU1_D0_GPIO_PORT5_R                   /* synthesis LOC = "J6"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口5 信号
    input   i_CPU1_D0_GPIO_PORT6_R                   /* synthesis LOC = "H3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口6 信号
    input   i_CPU1_D0_GPIO_PORT7_R                   /* synthesis LOC = "G4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口7 信号     
    input   i_CPU1_D0_GPIO_PORT9_R                   /* synthesis LOC = "G3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口9 信号
    input   i_CPU1_D0_GPIO_PORT10_R                  /* synthesis LOC = "J4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口10 信号
    /* end: GPIO CPU0/1 D0/D1相关信号 */

    /* begin: CPU芯片的MCIO信号相关 */
    // 原逻辑通过pvi_gt模块引入, 现直接作为CPLD_S的输入信号
    input   i_CPU0_MCIO0_CABLE_ID0_R                 /* synthesis LOC = "V2"*/,// from  CPU0_MCIO_0/0 / J27_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID0 信号
    input   i_CPU0_MCIO0_CABLE_ID1_R                 /* synthesis LOC = "R1"*/,// from  CPU0_MCIO_0/1 / J28_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID1 信号
    // input   i_CPU0_MCIO1_CABLE_ID0_R                 /* synthesis LOC = "E14"*/,// from  CPU0_MCIO_0/0 / J27_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID0 信号
    // input   i_CPU0_MCIO1_CABLE_ID1_R                 /* synthesis LOC = "D1 "*/,// from  CPU0_MCIO_0/1 / J28_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID1 信号
    input   i_CPU0_MCIO2_CABLE_ID0_R                 /* synthesis LOC = "U18"*/,// from  CPU0_MCIO_2/0 / J23_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO2 电缆 ID0 信号
    input   i_CPU0_MCIO2_CABLE_ID1_R                 /* synthesis LOC = "W13"*/,// from  CPU0_MCIO_2/1 / J26_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO2 电缆 ID1 信号                                                  
    input   i_CPU0_MCIO3_CABLE_ID0_R                 /* synthesis LOC = "Y8"*/,// from  CPU0_MCIO_3/0 / J21_G97V22312HR                to  CPLD_S                                          default 1  // CPU0 MCIO3 电缆 ID0 信号                                                     
    input   i_CPU0_MCIO3_CABLE_ID1_R                 /* synthesis LOC = "Y12"*/,// from  CPU0_MCIO_3/1 / J20_G97V22312HR                to  CPLD_S                                          default 1  // CPU0 MCIO3 电缆 ID1 信号    
    input   i_CPU1_MCIO0_CABLE_ID0_R                 /* synthesis LOC = "G19"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                          default 1  // CPU1 MCIO0 电缆 ID0 信号
    input   i_CPU1_MCIO0_CABLE_ID1_R                 /* synthesis LOC = "G20"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                          default 1  // CPU1 MCIO0 电缆 ID1 信号
    // input   i_CPU1_MCIO1_CABLE_ID0_R                 /* synthesis LOC = "A16"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                          default 1  // CPU1 MCIO0 电缆 ID0 信号
    // input   i_CPU1_MCIO1_CABLE_ID1_R                 /* synthesis LOC = "B15"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                          default 1  // CPU1 MCIO0 电缆 ID1 信号
    input   i_CPU1_MCIO2_CABLE_ID0_R                 /* synthesis LOC = "K1"*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO2 电缆 ID0 信号
    input   i_CPU1_MCIO2_CABLE_ID1_R                 /* synthesis LOC = "Y4"*/ ,// from  CPU1_MCIO_2/3 / J20_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO2 电缆 ID1 信号
    input   i_CPU1_MCIO3_CABLE_ID0_R                 /* synthesis LOC = "Y5"*/,// from  CPU1_MCIO_2/3 / J24_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO3 电缆 ID0 信号
    input   i_CPU1_MCIO3_CABLE_ID1_R                 /* synthesis LOC = "L2"*/,// from  CPU1_MCIO_2/3 / J24_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO3 电缆 ID1 信号

    input   i_BOARD_ID0                              /* synthesis LOC = "T16"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID0 信号
    input   i_BOARD_ID1                              /* synthesis LOC = "W12"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID1 信号
    // 未使用 !!! Y6, W6 引脚冲突 !!! s
    // input   i_BOARD_ID2                              /* synthesis LOC = "Y6"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID2 信号
    // input   i_BOARD_ID3                              /* synthesis LOC = "W6"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID3 信号
    input   i_BOARD_ID4                              /* synthesis LOC = "P18"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID4 信号
    input   i_BOARD_ID5                              /* synthesis LOC = "N18"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID5 信号
    input   i_BOARD_ID6                              /* synthesis LOC = "M18"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID6 信号
    input   i_BOARD_ID7                              /* synthesis LOC = "J18"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID7 信号

    input   i_PCA_REVISION_2                          /* synthesis LOC = "H16"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 2 信号
    input   i_PCA_REVISION_1                          /* synthesis LOC = "H18"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 0 信号
    input   i_PCA_REVISION_0                          /* synthesis LOC = "A8"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 0 信号 
    input   i_PCB_REVISION_1                          /* synthesis LOC = "R16"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCB 修订版本 1 信号
    input   i_PCB_REVISION_0                          /* synthesis LOC = "T18"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCB 修订版本 0 信号
    

    input   i_CPU_NVME0_PRSNT_N                       /* synthesis LOC = "L4"*/ ,// from  CPU0_MCIO_0/1 / J18_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME0 设备存在 信号
    input   i_CPU_NVME1_PRSNT_N                       /* synthesis LOC = "W9"*/ ,// from  CPU0_MCIO_0/1 / J18_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME1 设备存在 信号
    // input   i_CPU_NVME2_PRSNT_N                                                 ,
    // input   i_CPU_NVME3_PRSNT_N                                                 ,
    input   i_CPU_NVME4_PRSNT_N                       /* synthesis LOC = "R12"*/,// from  CPU1_MCIO_0/1 / J20_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME4 设备存在 信号
    input   i_CPU_NVME5_PRSNT_N                       /* synthesis LOC = "V15"*/,// from  CPU1_MCIO_0/1 / J20_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME5 设备存在 信号
    input   i_CPU_NVME6_PRSNT_N                       /* synthesis LOC = "U10"*/,// from  CPU1_MCIO_0/1 / J19_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME6 设备存在 信号
    input   i_CPU_NVME7_PRSNT_N                       /* synthesis LOC = "R8"*/,// from  CPU1_MCIO_0/1 / J19_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME7 设备存在 信号
    // input   i_CPU_NVME8_PRSNT_N                                                 ,
    // input   i_CPU_NVME9_PRSNT_N                                                 ,
    input   i_CPU_NVME10_PRSNT_N                      /* synthesis LOC = "E15"*/,// from  CPU0_MCIO_0/1 / J21_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME10 设备存在 信号
    input   i_CPU_NVME11_PRSNT_N                      /* synthesis LOC = "F13"*/,// from  CPU0_MCIO_0/1 / J21_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME11 设备存在 信号
    // input   i_CPU_NVME12_PRSNT_N                                                 ,
    // input   i_CPU_NVME13_PRSNT_N                                                 ,
    input   i_CPU_NVME14_PRSNT_N                      /* synthesis LOC = "N6"*/,// from  CPU1_MCIO_0/1 / J23_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME14 设备存在 信号
    input   i_CPU_NVME15_PRSNT_N                      /* synthesis LOC = "N4"*/,// from  CPU1_MCIO_0/1 / J23_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME15 设备存在 信号
    input   i_CPU_NVME16_PRSNT_N                      /* synthesis LOC = "U5"*/,// from  CPU0_MCIO_0/1 / J24_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME16 设备存在 信号
    input   i_CPU_NVME17_PRSNT_N                      /* synthesis LOC = "R6"*/,// from  CPU0_MCIO_0/1 / J24_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME17 设备存在 信号                                                                                                                                                    
     // 原逻辑通过pvi_gt模块引入, 现直接作为CPLD_S的输入信号

    input   i_PAL_M2_0_PRSNT_N                        /* synthesis LOC = "P11"*/,// from  PAL_M2_0_PRSNT / J17                          to  CPLD_S                                           default 1  // M.2_0 设备存在 信号
    input   i_PAL_M2_1_PRSNT_N                        /* synthesis LOC = "F15"*/,// from  M2_SATA_PORT/J26_APCI0556_P003A               to  CPLD_S                                           default 1  // M.2_1 设备存在 信号
    
    output  o_PAL_M2_0_PERST_N_R                      /* synthesis LOC = "Y17"*/,// from  CPLD_S                                        to  M2_0_SATA_PORT / J24                            default 1  // PAL M2_0 PERST_N 信号
    output  o_PAL_M2_1_PERST_N_R                      /* synthesis LOC = "H19"*/,// from  CPLD_S                                        to  M2_1_SATA_PORT / J25                            default 1  // PAL M2_1 PERST_N 信号

    // 未使用
    input   i_PEX_USB1_PPON1                          /* synthesis LOC = "B1"*/,// from  PEX_USB_UPD720201_2 / U40_XUSB2104LCGR         to  CPLD_S                                           default 1  // PEX USB1 PPON1 信号 
    input   i_PEX_USB1_PPON0                          /* synthesis LOC = "B2"*/,// from  PEX_USB_UPD720201_2 / U40_XUSB2104LCGR         to  CPLD_S                                           default 1  // PEX USB1 PPON0 信号
    input   i_PEX_USB2_PPON1                          /* synthesis LOC = "F7"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR        to  CPLD_S                                           default 1  // PEX USB2 PPON1 信号
    input   i_PEX_USB2_PPON0                          /* synthesis LOC = "G7"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR        to  CPLD_S                                           default 1  // PEX USB2 PPON0 信号
    output  o_USB2_SW_SEL_R                           /* synthesis LOC = "A18"*/,// from  CPLD_S                                        to  USB2_SWITCH / U256_DIO5000QN10                   default 1  // USB2 切换 选择 信号
    // 未使用

    output  o_PAL_GPU1_EFUSE_EN_R                     /* synthesis LOC  = "Y2" */,// from  CPLD_S                                       to  GPU1_PWR                                         default 1  // GPU1 EFUSE 使能 信号                                            
    output  o_PAL_GPU2_EFUSE_EN_R                     /* synthesis LOC  = "C20" */,// from  CPLD_S                                       to  GPU2_PWR                                         default 1  // GPU2 EFUSE 使能 信号                
    output  o_PAL_GPU3_EFUSE_EN_R                     /* synthesis LOC  = "Y3 "*/,// from  CPLD_S                                       to  GPU3_PWR                                         default 1  // GPU3 EFUSE 使能 信号                                     
    output  o_PAL_GPU4_EFUSE_EN_R                     /* synthesis LOC  = "C19 "*/,// from  CPLD_S                                       to  GPU4_PWR                                         default 1  // GPU4 EFUSE 使能 信号                                         
    /* end:   CPU芯片的MCIO信号相关 */

    /* begin: RISER  */
    output  o_PAL_RISER1_SS_CLK                       /* synthesis LOC = "P19" */,// from  CPLD_S                                        to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // Riser1 串行时钟 信号 
    output  o_PAL_RISER1_SS_LD_N                      /* synthesis LOC = "K20" */,// from  CPLD_S                                        to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // Riser1 串行信号加载使能 信号                                               
    // input   i_PAL_RISER1_SS_DATA_IN                   ,// ???未添加???
    
    output  o_PAL_RISER2_SS_CLK                       /* synthesis LOC = "F20"*/,// from  CPLD_S                                        to  RISER2/U240_SGM6505HYTQF24G_TR                   default 1  // Riser2 串行时钟 信号                                              
    output  o_PAL_RISER2_SS_LD_N                      /* synthesis LOC = "J20"*/,// from  CPLD_S                                        to  RISER2/U240_SGM6505HYTQF24G_TR                   default 1  // Riser2 串行信号加载使能 信号
    // input   i_PAL_RISER2_SS_DATA_IN                   ,// ???未添加???
    
    input   i_MB_CB_RISER1_PRSNT0_N                   /* synthesis LOC = "V4"*/ ,// from  RISER1/G64V3421MHR                            to  CPLD_S                                           default 1  // 主板连接器 Riser1 设备存在0 信号
    input   i_MB_CB_RISER2_PRSNT0_N                   /* synthesis LOC = "G16"*/ ,// from  RISER2/G64V3421MHR                            to  CPLD_S                                           default 1  // 主板连接器 Riser2 设备存在0 信号   
    
    input   i_PAL_RISER1_PRSNT_N                      /* synthesis LOC = "R4" */,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 设备存在 信号    
    input   i_PAL_RISER1_MODE_R                       /* synthesis LOC = "V14"*/,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 模式 信号
    input   i_PAL_RISER1_WIDTH_R                      /* synthesis LOC = "W11"*/,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 宽度 信号

    input   i_PAL_RISER2_PRSNT_N                      /* synthesis LOC = "J16"*/,// from  RISER2/J39_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser2 设备存在 信号
    input   i_PAL_RISER2_MODE_R                       /* synthesis LOC = "L15"*/,// from  RISER2/J39_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser2 模式 信号
    input   i_PAL_RISER2_WIDTH_R                      /* synthesis LOC = "K15"*/,// from  RISER2/J39_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser2 宽度 信号
    
    output  o_PAL_RISER1_SLOT_PERST_N_R               /* synthesis LOC = "T4"*/,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 插槽复位 信号
    output  o_PAL_RISER2_SLOT_PERST_N_R               /* synthesis LOC = "H15"*/,// from  CPLD_S                                        to  RISER2/J39_G64V3421MHR                           default 1  // Riser2 插槽复位 信号
        
    output  o_MCIO11_RISER1_PERST2_N                  /* synthesis LOC = "T13"*/,// from  CPLD_S                                        to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // MCIO11 Riser1 插槽复位2 信号
    
    output  o_CPU0_RISER1_9548_RST_N_R                /* synthesis LOC = "M4"*/,// from  CPLD_S                                        to  RISER1/J1_G64V3421MHR                            default 1  // CPU0 Riser1 9548 复位 信号     
    output  o_CPU1_RISER2_9548_RST_N_R                /* synthesis LOC = "K16"*/,// from  CPLD_S                                        to  RISER2/J39_G64V3421MHR                           default 1  // CPU1 Riser2 9548 复位 信号

    input   i_PAL_RISER1_WAKE_N                       /* synthesis LOC = "C12" */,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 唤醒 信号
    input   i_PAL_RISER2_WAKE_N                       /* synthesis LOC = "A15" */,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 唤醒 信号

    // 未使用      
    output  o_PAL_THROTTLE_RISER1_R                   /* synthesis LOC = "Y19" */,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                            default 1  // Riser1 节流 信号
    output  o_PAL_THROTTLE_RISER2_R                   /* synthesis LOC = "L20"*/,// from  RISER2/J240_SGM6505HYTQF24G_TR               to  CPLD_S                                            default 1  // Riser2 节流 信号
    // 未使用
    
    input   i_RISER_MB_PRSNT_R                        /* synthesis LOC = "M17"*/,// from  RISER_MB_PRSNT / J38                          to  CPLD_S                                           default 1  // Riser 主板存在 信号
    /* end: RISER  */

    /* begin: MB CPLD ---> BP CPLD 的 SGPIO*/
    // output  o_PVT_SS_CLK_R    , // 暂未使用
    // input   i_PVT_SS_LD_N_R   , // 暂未使用
    // input   i_PVT_SS_DATI     , // 暂未使用
    // output  o_PVT_SS_CLK_1_R  , // 暂未使用
    // input   i_PVT_SS_LD_N_1_R , // 暂未使用
    // input   i_PVT_SS_DATI_1   , // 暂未使用
    /* end: MB CPLD ---> BP CPLD 的 SGPIO*/

    /* begin: GPU  */
    output  o_CPU_MCIO0_GPU_THROTTLE_N_R	          /* synthesis LOC = "T1"*/ ,// from  CPLD_S                                        to  CPU0_MCIO_0/1 / J18_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output	o_CPU_MCIO2_GPU_THROTTLE_N_R	          /* synthesis LOC = "Y13"*/ ,// from  CPLD_S                                        to  TPM/ J25_323114MG4FBK00R01                       default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号                                                
    output	o_CPU_MCIO3_GPU_THROTTLE_N_R	          /* synthesis LOC = "V17"*/ ,// from  CPLD_S                                        to  CPU0_MCIO_0/1 / J18_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output  o_CPU_MCIO5_GPU_THROTTLE_N_R              /* synthesis LOC = "D19"*/,// from  CPLD_S                                        to  CPU0_MCIO_0 / J21_G97V22312HR                    default 1  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output  o_CPU_MCIO7_GPU_THROTTLE_N_R              /* synthesis LOC = "J1"*/,// from  CPLD_S                                        to  CPU1_MCIO_2/3 / J23_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output  o_CPU_MCIO8_GPU_THROTTLE_N_R              /* synthesis LOC = "Y1" */,// from  CPLD_S                                        to  CPU1_MCIO_2/3 / J24_G97V22321HR                  default 1  // CPU MCIO8 GPU 节流 信号
    /* end: GPU  */

   /* begin: 单线协议相关信号 */
    // !!!这里后续要调整!!!
    inout  io_MCIO_PWR_EN0_R                          /* synthesis LOC  = T5" */,// from  CPU1_MCIO_0/1 / J18_G97V22312HR              to  CPLD_S                                           default 1  // MCIO 电源使能0 信号
    // inout  io_MCIO_PWR_EN1_R                                                     ,
    inout  io_MCIO_PWR_EN2_R                          /* synthesis LOC  = "Y9 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能2 信号
    inout  io_MCIO_PWR_EN3_R                          /* synthesis LOC  = "E20" */,// from  CPU1_MCIO_2/3 / J24_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能3 信号
    // inout  io_MCIO_PWR_EN4_R                                                     ,
    inout  io_MCIO_PWR_EN5_R                          /* synthesis LOC  = "D20"*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能5 信号
    // inout  io_MCIO_PWR_EN6_R                                                     ,
    inout  io_MCIO_PWR_EN7_R                          /* synthesis LOC  = "J2"*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能7 信号
    inout  io_MCIO_PWR_EN8_R                          /* synthesis LOC  = "Y7 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能8 信号
    // inout  io_MCIO_PWR_EN9_R                                                        ,
    // inout  io_MCIO_PWR_EN10_R                                                       ,
    // inout  io_MCIO_PWR_EN11_R                                                       ,
    // !!!这里后续要调整!!!
    /* end: 单线协议相关信号 */

    /* begin: 电源上下电相关信号 还有其他的en*/
    input   i_PAL_PWR_SW_IN_N                         /* synthesis LOC  = "N5"*/ ,// from  CPLD_S_UART_LED_SW                            to  CPLD_S                                           default 1  // 电源开关 输入 信号

    // 未使用 
    input   i_PAL_P12V_STBY_EFUSE_PG                  /* synthesis LOC = "F8"*/,// from  CURRENT_DET1 / P12V_STBY                      to  CPLD_S                                           default 1  // 12V 待机 EFUSE 电源良好 信号
    input   i_PAL_P12V_STBY_EFUSE_FLTB                /* synthesis LOC = "E7"*/,// from  CURRENT_DET1 / P12V_STBY                      to  CPLD_S                                           default 1  // 12V 待机 EFUSE 故障 信号    
    output  o_PAL_P12V_STBY_EFUSE_EN_R                /* synthesis LOC = "B8"*/,// from  CPLD_S                                        to  CURRENT_DET1 / P12V_STBY                         default 1  // 12V 待机 EFUSE 使能 信号                                            
    input   i_P12V_STBY_SNS_ALERT                     /* synthesis LOC = "T8"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                  to  CPLD_S                                           default 1  // 12V 待机 传感器 告警 信号
    // 未使用 

    // 未使用 
    input   i_PAL_P12V_RISER1_VIN_PG                  /* synthesis LOC = "T10"*/,// from  P12V_RISER1_VIN                               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 良好 信号
    input   i_PAL_P12V_RISER1_VIN_FLTB                /* synthesis LOC = "P10"*/,// from  P12V_RISER1_VIN                               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 故障 信号
    input   i_PAL_P12V_RISER2_VIN_PG                  /* synthesis LOC = "L16"*/,// from  P12V_RISER2_VIN                               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 良好 信号
    input   i_PAL_P12V_RISER2_VIN_FLTB                /* synthesis LOC = "N16"*/,// from  P12V_RISER2_VIN                               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 故障 信号
    // 未使用

    // 未使用 
    input   i_PAL_GPU1_EFUSE_OC	                      /* synthesis LOC = "V3" */,// from  GPU1_PWR                                      to  CPLD_S                                           default 1  // GPU1 EFUSE 过温保护 信号
    input   i_PAL_GPU1_EFUSE_PG	                      /* synthesis LOC = "U4" */,// from  GPU1_PWR                                      to  CPLD_S                                           default 1  // GPU1 EFUSE 电源良好 信号
    input   i_PAL_GPU2_EFUSE_OC	                      /* synthesis LOC = "T17" */,// from  GPU2_PWR                                      to  CPLD_S                                           default 1  // GPU2 EFUSE 过温保护 信号
    input   i_PAL_GPU2_EFUSE_PG	                      /* synthesis LOC = "R17" */,// from  GPU2_PWR                                      to  CPLD_S                                           default 1  // GPU2 EFUSE 电源良好 信号
    input   i_PAL_GPU3_EFUSE_OC	                      /* synthesis LOC = "W4" */,// from  GPU3_PWR                                      to  CPLD_S                                           default 1  // GPU3 EFUSE 过温保护 信号
    input   i_PAL_GPU3_EFUSE_PG	                      /* synthesis LOC = "W3" */,// from  GPU3_PWR                                      to  CPLD_S                                           default 1  // GPU3 EFUSE 电源良好 信号
    input   i_PAL_GPU4_EFUSE_OC	                      /* synthesis LOC = "D12" */,// from  GPU4_PWR                                      to  CPLD_S                                           default 1  // GPU4 EFUSE 过温保护 信号
    input   i_PAL_GPU4_EFUSE_PG	                      /* synthesis LOC = "A11" */,// from  GPU4_PWR                                      to  CPLD_S                                           default 1  // GPU4 EFUSE 电源良好 信号
    // 未使用 

    // 未使用 
    input   i_PAL_PGD_USB_UPD1_P1V1                   /* synthesis LOC = "G15"*/,// from  PEX_USB_1/SGM61030_3V3to1v1                   to  CPLD_S                                           default 1  // USB_UPD1 P1V1 电源良好 信号
    input   i_PAL_PGD_USB_UPD2_P1V1                   /* synthesis LOC = "B9"*/ ,// from  PEX_USB_UPD720201_2 / SGM61030_3V3to1v1       to  CPLD_S                                           default 1  // USB_UPD2 P1V1 电源良好 信号
    // output  o_P5V_USB2_LEFT_EAR_EN                    /* synthesis LOC = "P20"*/,// from  CPLD_S                                        to  USB2_LEFT_EAR / U14_JW7111ssoTBTRPBF             default 1  // 5V USB2 左耳 电源使能 信号
    output  o_P5V_USB2_EN                             /* synthesis LOC = "M14"*/,// from  CPLD_S                                        to  USB2_POWER / U15_JW7111SSOTBTRPBF                default 1  // 5V USB2 电源使能 信号
    // 未使用 

    // 未使用     
    input   i_P5V_USB2_OCI2B                          /* synthesis LOC = "N14"*/,// from  USB2_POWER / U15_JW7111SSOTBTRPBF                to  CPLD_S                                           default 1  // 5V USB2 OCI2B 信号                              
    input   i_PAL_RISER4_PWR_PGD                      /* synthesis LOC = "D6" */,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // Riser4 电源良好 信号                                        
    // 未使用

    output  o_PAL_P1V1_STBY_EN_R                      /* synthesis LOC = "C6"*/,// from  CPLD_S                                        to  P1V1_STBY_POWER / U42_SGM61030_3V3to1v1          default 1  // P1V1 待机 电源使能 信号
    output  o_PAL_M2_PWR_EN_R                         /* synthesis LOC = "M20"*/,// from  CPLD_S                                         to  PAL_M2_PWR_EN / U56                             default 1  // M.2 电源使能 信号
    
    // 未使用
    // input   i_PAL_P5V_BD_OC                           /* synthesis LOC = "B1"*/ ,// from  CPLD_S                                        to  DB_MODULE / U39_JW7111SSOTBTRPBF                 default 1  // P5V_BD_OC 信号    
    // 未使用

    output  o_PAL_UPD1_P1V1_EN_R                      /* synthesis LOC = "J19"*/ ,// from  CPLD_S                                        to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 P1V1 电源使能 信号
    output  o_PAL_UPD1_P3V3_EN_R                      /* synthesis LOC = "H20"*/ ,// from  CPLD_S                                        to  PEX_USB__1 / U40_XUSB2104LCGR                   default 1  // UPD1 P3V3 电源使能 信号
    output  o_PAL_UPD1_PERST_N_R                      /* synthesis LOC = "V20"*/ ,// from  CPLD_S                                        to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 PERST_N 信号 第 1 路更新通道（UPD1）复位 信号
    output  o_PAL_UPD1_PONRST_N_R                     /* synthesis LOC = "Y18"*/,// from  CPLD_S                                        to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 PONRST_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的上电复位信号

    output  o_PAL_UPD2_P1V1_EN_R                      /* synthesis LOC = "A10"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 P1V1 电源使能 信号
    output  o_PAL_UPD2_P3V3_EN_R                      /* synthesis LOC = "B19"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U63                        default 1  // UPD2 P3V3 电源使能 信号
    output  o_PAL_UPD2_PERST_N_R                      /* synthesis LOC = "A13"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 插槽复位 信号                                                   
    output  o_PAL_UPD2_PONRST_N_R                     /* synthesis LOC = "A14"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 PORNRST_N 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的上电复位信号
    /* end: 电源上下电相关信号 */

    /* begin: LED灯 控制信号 */
    output  o_LED8_N                                  /* synthesis LOC = "L1"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED8 灯 信号
    output  o_LED7_N                                  /* synthesis LOC = "M1"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED7 灯 信号
    output  o_LED6_N                                  /* synthesis LOC = "N1"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED6 灯 信号
    output  o_LED5_N                                  /* synthesis LOC = "P1"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED5 灯 信号
    output  o_LED4_N                                  /* synthesis LOC = "M2"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED4 灯 信号
    output  o_LED3_N                                  /* synthesis LOC = "N2"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED3 灯 信号
    output  o_LED2_N                                  /* synthesis LOC = "P2"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED2 灯 信号
    output  o_LED1_N                                  /* synthesis LOC = "R2"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED1 灯 信号
    
    // ???未使用, 后续添加???
    output  o_N1_ACT                                  /* synthesis LOC = "W17"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 活动 指示灯 信号
    output  o_N1_100M                                 /* synthesis LOC = "T12"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 100M 指示灯 信号
    output  o_N1_1000M                                /* synthesis LOC = "V16"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 1000M 指示灯 信号
    output  o_N0_ACT                                  /* synthesis LOC = "V13"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 活动 指示灯 信号
    output  o_N0_100M                                 /* synthesis LOC = "U17"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 100M 指示灯 信号
    output  o_N0_1000M                                /* synthesis LOC = "R13"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 1000M 指示灯 信号
     // ???未使用, 后续添加???

    // 健康 指示灯 信号
    output	o_PAL_LED_HEL_GR_R	                      /* synthesis LOC = "T20"*/,// from  CPLD_S                                       to  SYS STATUS LED                                   default 1  // HEL 绿色 指示灯 信号
    output  o_PAL_LED_HEL_RED_R                       /* synthesis LOC = "R19"*/,// from  CPLD_S                                       to  SYS STATUS LED                                   default 1  // HEL 红色 指示灯 信号
    
    // NIC 网口 指示灯 信号
    // output  o_PAL_LED_NIC_ACT_R                                                 ,

    // 未使用, 后续添加
    output  o_PAL_LED_PWRBTN_GR_R                     /* synthesis LOC = "P20"*/,// from  CPLD_S                                       to  PWR BTN&LED                                      default 1  // 电源按钮 绿色 指示灯 信号
    output  o_PAL_LED_PWRBTN_AMB_R                    /* synthesis LOC = "N19"*/,// from  CPLD_S                                       to  PWR BTN&LED                                      default 1  // 电源按钮 琥珀色 指示灯 信号
    // 未使用, 后续添加

    output  o_PAL_LED_UID_R                           /* synthesis LOC = "A20"*/,// from  CPLD_S                                        to  LED_UID / J22                                   default 1  // PAL LED UID 信号
    
    // 未使用, 后续添加
    output  o_PAL_RJ45_2_1000M_LED                    /* synthesis LOC = "T14"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_2 网口 1000M 指示灯 信号
    output  o_PAL_RJ45_2_100M_LED                     /* synthesis LOC = "R14"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_1 网口 100M 指示灯 信号
    output  o_PAL_RJ45_2_ACT_LED                      /* synthesis LOC = "P14"*/,// from  CPLD_S                                       to  J32_AC7412_3557_004_H0                           default 1  // RJ45_2 网口 活动 指示灯 信号                                                    
    output  o_PAL_RJ45_1_1000M_LED                    /* synthesis LOC = "P13"*/,// from  CPLD_S                                       to  J2_AC7412_3557_004_H0                            default 1  // RJ45_1 网口 1000M 指示灯 信号
    output  o_PAL_RJ45_1_100M_LED                     /* synthesis LOC = "U14"*/,// from  CPLD_S                                       to  J2_AC7412_3557_004_H0                            default 1  // RJ45_1 网口 100M 指示灯 信号
    output  o_PAL_RJ45_1_ACT_LED                      /* synthesis LOC = "U15"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_1 网口 活动 指示灯 信号
    // 未使用, 后续添加                                             
    /* end: LED灯 控制信号 */

    /* begin: 拨码开关 */
    input   i_SW_1                                   /* synthesis LOC = "K5"*/,// from  CPLD_S                                         to  SW_1 / J4                                        default 1  // 开关 1 信号        
    input   i_SW_2                                   /* synthesis LOC = "T3"*/,// from  CPLD_S                                         to  SW_2 / J5                                        default 1  // 开关 2 信号        
    input   i_SW_3                                   /* synthesis LOC = "R3"*/,// from  CPLD_S                                         to  SW_3 / J6                                        default 1  // 开关 3 信号        
    input   i_SW_4                                   /* synthesis LOC = "P3"*/,// from  CPLD_S                                         to  SW_4 / J7                                        default 1  // 开关 4 信号        
    input   i_SW_5                                   /* synthesis LOC = "N3"*/,// from  CPLD_S                                         to  SW_5 / J8                                        default 1  // 开关 5 信号        
    input   i_SW_6                                   /* synthesis LOC = "M3"*/,// from  CPLD_S                                         to  SW_6 / J9                                        default 1  // 开关 6 信号        
    input   i_SW_7                                   /* synthesis LOC = "B3"*/,// from  CPLD_S                                         to  SW_7 / J10                                       default 1  // 开关 7 信号        
    input   i_SW_8                                   /* synthesis LOC = "B4"*/,// from  CPLD_S                                         to  SW_8 / J12                                       default 1  // 开关 8 信号
    /* end: 拨码开关 */

    /* begin: DEBUG 信号 */
    // 未使用
    input   i_CABLE_PRSNT_N                         /* synthesis LOC = "U20"*/,// from  J29_10217724B001                              to  CPLD_S                                           default 1  // 电缆 设备存在 信号
    // 未使用
                                          
    input   i_CHASSIS_ID0_N                         /* synthesis LOC = "P17"*/,// from  ?CHASSIS_ID?                                  to  CPLD_S                                           default 1  // 机箱 ID0 信号                        
    input   i_CHASSIS_ID1_N                         /* synthesis LOC = "A17"*/,// from  ?CHASSIS_ID?                                  to  CPLD_S                                           default 1  // 机箱 ID1 信号

    // 未使用, 存寄存器
    input   i_CPU0_VIN_SNS_ALERT                    /* synthesis LOC = "L7"*/,// from  CURRENT_DET0 / U57_TPA626_VR_S                to  CPLD_S                                           default 1  // CPU0 输入电压 传感器 告警 信号
    input   i_CPU1_VIN_SNS_ALERT                    /* synthesis LOC = "M5"*/,// from  CURRENT_DET0 / U60_TPA626_VR_S                to  CPLD_S                                           default 1  // CPU1 输入电压 传感器 告警 信号
    // 未使用, 存寄存器

    input   i_CPU0_D0_TEMP_OVER                     /* synthesis LOC = "G1"*/ ,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU0 D0 温度 过高 信号
    input   i_CPU0_D1_TEMP_OVER                     /* synthesis LOC = "E2"*/ ,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU0 D1 温度 过高 信号
    input   i_CPU1_D0_TEMP_OVER                     /* synthesis LOC = "E4"*/ ,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU1 D0 温度 过高 信号
    input   i_CPU1_D1_TEMP_OVER                     /* synthesis LOC = "F5"*/ ,// from  CPU1_GPIO2 / U3_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU1 D1 温度 过高 信号

    // 未使用, 存寄存器
    // input   i_P5V_USB2_LEFT_EAR_OCI2B               /* synthesis LOC = "P19"*/,// from  CPLD_S                                        to  USB2_LEFT_EAR / U14_JW7111ssoTBTRPBF             default 1  // 5V USB2 左耳 OCI2B 过流告警信号
    input   i_P12V_RISER1_VIN_SNS_ALERT             /* synthesis LOC = "W5"*/,// from  P12V_RISER1_VIN/U25_TPA626_VR_S               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 传感器 告警 信号
    input   i_P12V_RISER2_VIN_SNS_ALERT             /* synthesis LOC = "P16"*/,// from  P12V_RISER2_VIN/U28_TPA626_VR_S               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 传感器 告警 信号
    // 未使用, 存寄存器

    // ???直接赋值打开, 是否有错???
    output  o_PAL_DB800_1_OE_N_R                    /* synthesis LOC = "K2"*/,// from  DB800_1_CLK / U48_AU5440AQMR                  to  CPLD_S                                           default 1  // DB800_1 输出使能 信号
    output  o_PAL_DB2000_1_OE_N_R                   /* synthesis LOC = "K4" */,// from  DB2000_1_CLK / U47_AU5440AQMR                 to  CPLD_S                                           default 1  // DB2000_1 输出使能 信号
    output  o_PAL_CK440_OE_N_R                      /* synthesis LOC = "B20"*/,// from  CPLD_S                                       to  CK440_CLKER / U70_RS2CG440ZUDE                   default 1  // CK440 输出使能 信号               
    // ???直接赋值打开, 是否有错???

    // 传入MCPLD, 控制force_reb_in, 与复位相关, 谨慎使用
    input	i_PAL_EXT_RST_N	                        /* synthesis LOC = "P5"*/,// from  CPLD_S_UART_LED_SW                            to  CPLD_S                                           default 1  // 外部 复位 信号
    // 传入MCPLD, 控制force_reb_in, 与复位相关, 谨慎使用

    // 传入MCPLD, 缺少lom_prsnt_n, 实际未使用
    input   i_PAL_LOM_FAN_ON_AUX_R                  /* synthesis LOC = "A1" */,// from  RISER_AUX / J16                              to  CPLD_S                                            default 1  // LOM 风扇 开启 辅助 信号
    // 传入MCPLD, 缺少lom_prsnt_n, 实际未使用

    input   i_FAN_SNS_ALERT                         /* synthesis LOC = "B11"*/,// from  CPLD_S                                       to  FAN_SNS_ALERT / U60                               default 1  // 风扇 传感器 警报 信号

    // 未使用
    input   i_PAL_UPD1_PEWAKE_N                     /* synthesis LOC = "W14"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                            default 1  // UPD1 PEWAKE_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的电源唤醒信号
    input   i_PAL_UPD1_SMIB_N                       /* synthesis LOC = "W15"*/ ,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                           default 1  // UPD1 SMIB_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的SMIB_N信号
    input   i_PAL_UPD2_PEWAKE_N                     /* synthesis LOC = "F10"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR      to  CPLD_S                                           default 1  // UPD2 PEWAKE_N 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的电源唤醒信号
    input   i_PAL_UPD2_SMIB_N                       /* synthesis LOC = "G11"*/,// from  PEX_USB_UPD720201_2 / U63                    to  CPLD_S                                           default 1  // UPD2 SMIB 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的 SMI 中断请求信号
    // 未使用

    input   i_PAL_UPD72020_1_ALART                  /* synthesis LOC = "P15" */,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                          default 1  // UPD1 警报 信号
    input   i_PAL_UPD72020_2_ALART                  /* synthesis LOC = "G17"*/,// from  PEX_USB_UPD720201_2 / U63                    to  CPLD_S                                           default 1  // UPD720201_2 告警 信号

    // 未使用, 存寄存器
    input   i_REAR_BP_SNS_ALERT                     /* synthesis LOC = "T7"*/,// from  CURRENT_DET1                                 to  CPLD_S                                           default 1  // 后板 传感器 告警 信号
    // 未使用, 存寄存器

    // output	o_PAL_RST_TPM_N_R	                    /* synthesis LOC = "Y1"*/ ,// from  CPLD_S                                       to  TPM/ J25_323114MG4FBK00R01                       default 0  // TPM模块 复位 信号 
    // output	o_PAL_TPM_DRQ1_N	                    /* synthesis LOC = "W2"*/ ,// from  CPLD_S                                       to  TPM/ J25_323114MG4FBK00R01                       default 1  // TPM模块 DRQ1 信号, TPM 模块向 PCH 发起的 DMA 请求信号                                              

    output  o_PAL_TEST_BAT_EN                       /* synthesis LOC = "R10" */,// from  CPLD_S                                       to  TRC                                              default 1  // 测试 电池 使能 信号
                                                
    output  o_PAL_DB800_1_PD_R                      /* synthesis LOC = "D8"*/,// from  CPLD_S                                       to  DB800_2_CLK / U11_AU5443A_LMR                    default 1  // PAL DB800_1 PD 信号(DB800 模块 1 的掉电控制信号)
    output  o_PAL_DB2000_1_PD_R                     /* synthesis LOC = "A2"*/,// from  CPLD_S                                       to  DB2000_1_CLK / U47_AU5440AQMR                    default 1  // DB2000_1 电源禁用 信号
    
    output	o_PAL_RST_TCM_N_R	                    /* synthesis LOC = "L19"*/ // from  CPLD_S                                       to  TPM/ J25_323114MG4FBK00R01                       default 0  // TPM模块 复位 信号 
 
    /* end: DEBUG 信号 */
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//From CMU
//--------------------------------------------------------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------------------------------------------------------
//For pll_inst
//--------------------------------------------------------------------------------------------------------------------------------------------------
wire                            clk_50m                                            ;
wire                            clk_25m                                            ;
wire                            pll_lock                                           ;
 
//--------------------------------------------------------------------------------------------------------------------------------------------------
//For timer_gen_inst
//--------------------------------------------------------------------------------------------------------------------------------------------------
wire                            t40ns_tick                                         ;
wire                            t1us_tick                                          ;
wire                            t2us_tick                                          ;
wire                            t8us_tick                                          ; 
wire                            t16us_tick                                         ;
wire                            t32us_tick                                         ;
wire                            t128us_tick                                        ;
wire                            t512us_tick                                        ;
wire                            t1ms_tick                                          ;
wire                            t2ms_tick                                          ;
wire                            t16ms_tick                                         ;
wire                            t32ms_tick                                         ;
wire                            t64ms_tick                                         ;
wire                            t128ms_tick                                        ;
wire                            t256ms_tick                                        ;
wire                            t512ms_tick                                        ;
wire                            t1s_tick                                           ;
wire                            t8s_tick                                           ;
wire                            t1hz_clk                                           ;
wire                            t2p5hz_clk                                         ;
wire                            t4hz_clk                                           ;
wire                            t16khz_clk                                         ;
wire                            t6m25_clk                                          ;
wire                            t16m6_clk                                          ;

//--------------------------------------------------------------------------------------------------------------------------------------------------
//For pon_reset_inst
//--------------------------------------------------------------------------------------------------------------------------------------------------
wire                            pon_reset_n                                         ; 
wire                            pon_reset_db_n                                      ;      
wire                            pgd_aux_system                                      ; 
wire                            pgd_aux_system_sasd                                 ; 
wire                            pgd_aux_bmc                                         ; //From CMU 
wire                            done_booting_delayed = 1'b1                         ; //input; define constant 1

assign	                        pgd_aux_bmc = 1'b1                                  ; //From CMU 
					   
//--------------------------------------------------------------------------------------------------------------------------------------------------
//For db_inst_amd_cpu_prsnt
//--------------------------------------------------------------------------------------------------------------------------------------------------
wire                            reached_sm_wait_powerok                             ;
wire                            db_i_pal_ocp2_pwrgd                                 ;

wire                            power_supply_on                                     ; // 主CPLD传入, 上电控制信息
wire                            p5v_en_r                                            ; // 主CPLD传入, 上电控制信息
wire                            p3v3_en_r                                           ; // 主CPLD传入, 上电控制信息
wire                            p1v1_en_r                                           ; // 主CPLD传入, 上电控制信息


//For PVT
wire [7:0]                      riser1_pvti_byte3                                   ;
wire [7:0]                      riser1_pvti_byte2                                   ;
wire [7:0]                      riser1_pvti_byte1                                   ;
wire [7:0]                      riser1_pvti_byte0                                   ;
wire [7:0]                      riser2_pvti_byte3                                   ;
wire [7:0]                      riser2_pvti_byte2                                   ;
wire [7:0]                      riser2_pvti_byte1                                   ;
wire [7:0]                      riser2_pvti_byte0                                   ;

wire                            riser1_cb_prsnt_slot1_n                             ;
wire                            riser1_cb_prsnt_slot2_n                             ;
wire                            riser1_cb_prsnt_slot3_n                             ;
wire                            riser1_pwr_det0                                     ;
wire                            riser1_pwr_det1                                     ;
wire                            riser1_pcb_rev0                                     ;
wire                            riser1_pcb_rev1                                     ;
wire                            riser1_pwr_alert_n                                  ;
wire                            riser1_emc_alert_n                                  ;
wire                            riser1_slot1_prsnt_n                                ;
wire                            riser1_slot2_prsnt_n                                ;
wire                            riser1_slot3_prsnt_n                                ;
wire [5:0]                      riser1_id                                           ;
wire                            pal_riser1_pwrgd                                    ;
wire                            pal_riser1_pe_wake_n                                ;
wire                            pfr_pe_wake_n                                       ;

wire                            riser2_cb_prsnt_slot1_n                             ;
wire                            riser2_cb_prsnt_slot2_n                             ;
wire                            riser2_cb_prsnt_slot3_n                             ;
wire                            riser2_pwr_det0                                     ;
wire                            riser2_pwr_det1                                     ;
wire                            riser2_pcb_rev0                                     ;
wire                            riser2_pcb_rev1                                     ;
wire                            riser2_pwr_alert_n                                  ;
wire                            riser2_emc_alert_n                                  ;
wire                            riser2_slot1_prsnt_n                                ;
wire                            riser2_slot2_prsnt_n                                ;
wire                            riser2_slot3_prsnt_n                                ;
wire [5:0]                      riser2_id                                           ;
wire                            pal_riser2_pwrgd                                    ;
wire                            pal_riser2_pe_wake_n                                ;

wire                            cpu_nvme0_prsnt_n                                   ;
wire                            cpu_nvme1_prsnt_n                                   ;
wire                            cpu_nvme2_prsnt_n                                   ;
wire                            cpu_nvme3_prsnt_n                                   ;
wire                            cpu_nvme4_prsnt_n                                   ;
wire                            cpu_nvme5_prsnt_n                                   ;
wire                            cpu_nvme6_prsnt_n                                   ;
wire                            cpu_nvme7_prsnt_n                                   ;
wire                            cpu_nvme10_prsnt_n                                  ;
wire                            cpu_nvme11_prsnt_n                                  ;
wire                            cpu_nvme12_prsnt_n                                  ;
wire                            cpu_nvme13_prsnt_n                                  ;
wire                            cpu_nvme14_prsnt_n                                  ;
wire                            cpu_nvme15_prsnt_n                                  ;
wire                            cpu_nvme16_prsnt_n                                  ;
wire                            cpu_nvme17_prsnt_n                                  ;

wire                            cpu0_mcio0_cable_id0                                ;
wire                            cpu0_mcio0_cable_id1                                ;
// wire                            cpu0_mcio1_cable_id0                                ;
// wire                            cpu0_mcio1_cable_id1                                ;
wire                            cpu0_mcio2_cable_id0                                ;
wire                            cpu0_mcio2_cable_id1                                ;
wire                            cpu0_mcio3_cable_id0                                ;
wire                            cpu0_mcio3_cable_id1                                ;
wire                            cpu0_mcio4_cable_id0                                ;
wire                            cpu0_mcio4_cable_id1                                ;
wire                            cpu0_mcio5_cable_id0                                ;
wire                            cpu0_mcio5_cable_id1                                ;
wire                            cpu1_mcio0_cable_id0                                ;
wire                            cpu1_mcio0_cable_id1                                ;
// wire                            cpu1_mcio1_cable_id0                                ;
wire                            cpu1_mcio2_cable_id0                                ;
wire                            cpu1_mcio2_cable_id1                                ;
wire                            cpu1_mcio3_cable_id0                                ;
wire                            cpu1_mcio3_cable_id1                                ;
wire                            cpu1_mcio4_cable_id0                                ;
wire                            cpu1_mcio4_cable_id1                                ;
wire                            cpu1_mcio6_cable_id0                                ;
// wire                            cpu1_mcio1_cable_id1                                ;
wire                            cpu1_mcio6_cable_id1                                ;
wire                            pal_mcio11_cable_id1                                ;
wire                            pal_mcio11_cable_id0                                ;
wire                            pal_mcio12_cable_id1                                ;
wire                            pal_mcio12_cable_id0                                ;
wire                            pal_mcio13_cable_id1                                ;
wire                            pal_mcio13_cable_id0                                ;
wire                            pal_mcio14_cable_id1                                ;
wire                            pal_mcio14_cable_id0                                ;
wire                            w_ocp1_x16_prsnt                                    ;

wire [7:0]                      mcio11_slot_id                                      ;
wire [7:0]                      mcio4_slot_id                                       ;
wire [7:0]                      mcio0_slot_id                                       ;
wire [7:0]                      mcio1_slot_id                                       ;
wire [7:0]                      mcio2_slot_id                                       ;
wire [7:0]                      mcio3_slot_id                                       ;
wire [7:0]                      mcio10_slot_id                                      ;
wire [7:0]                      mcio9_slot_id                                       ;
wire [7:0]                      mcio5_slot_id                                       ;
wire [7:0]                      mcio6_slot_id                                       ;
wire [7:0]                      mcio7_slot_id                                       ;
wire [7:0]                      mcio8_slot_id                                       ;

wire [7:0]                      i2c_ram_1050                                        ;
wire [7:0]                      i2c_ram_1051                                        ;
wire [7:0]                      i2c_ram_1052                                        ;
wire [7:0]                      i2c_ram_1053                                        ;
wire [7:0]                      i2c_ram_1054                                        ;
wire [7:0]                      i2c_ram_1055                                        ;
wire [7:0]                      i2c_ram_1056                                        ;
wire [7:0]                      i2c_ram_1057                                        ;
wire [7:0]                      i2c_ram_1058                                        ;

// wire                            pal_m2_0_sel_lv33_r                                 ;
wire                            bmc_extrst_uid                                      ;

// wire                            pal_bp1_prsnt_n                                     ; // MCPLD已使用
// wire                            pal_bp2_prsnt_n                                     ; // MCPLD已使用
// wire                            pal_bp3_prsnt_n                                     ; // 未使用
// wire                            pal_bp4_prsnt_n                                     ; // 未使用
// wire                            pal_bp5_prsnt_n                                     ; // 未使用
// wire                            pal_bp6_prsnt_n                                     ; // 未使用
// wire                            pal_bp7_prsnt_n                                     ; // 未使用
// wire                            pal_bp8_prsnt_n                                     ; // 未使用

// wire                            pal_gpu_fan4_prsnt                                  ; // 未使用
// wire                            pal_gpu_fan3_prsnt                                  ; // 未使用
// wire                            pal_gpu_fan2_prsnt                                  ; // 未使用
// wire                            pal_gpu_fan1_prsnt                                  ; // 未使用
// wire                            pal_gpu_fan4_foo                                    ; // 未使用
// wire                            pal_gpu_fan3_foo                                    ; // 未使用
// wire                            pal_gpu_fan2_foo                                    ; // 未使用
// wire                            pal_gpu_fan1_foo                                    ; // 未使用

wire                            board_id7                                           ;
wire                            board_id6                                           ;
wire                            board_id5                                           ;
wire                            board_id4                                           ;
// wire                            board_id3                                           ;
// wire                            board_id2                                           ;
wire                            board_id1                                           ;
wire                            board_id0                                           ;

wire                            pca_revision_2                                      ;
wire                            pca_revision_1                                      ;
wire                            pca_revision_0                                      ;
wire                            pcb_revision_1                                      ;
wire                            pcb_revision_0                                      ;

// wire                            cpu_nvme25_prsnt_n                                  ; // 未使用
// wire                            cpu_nvme24_prsnt_n                                  ; // 未使用
// wire                            cpu_nvme23_prsnt_n                                  ; // 未使用

// wire                            fan8_install_n                                      ; // 未使用
// wire                            fan7_install_n                                      ; // 未使用
// wire                            fan6_install_n                                      ; // 未使用
// wire                            fan5_install_n                                      ; // 未使用
// wire                            fan4_install_n                                      ; // 未使用
// wire                            fan3_install_n                                      ; // 未使用
// wire                            fan2_install_n                                      ; // 未使用
// wire                            fan1_install_n                                      ; // 未使用

wire                            riser_prsnt_det_0                                   ;
wire                            riser_prsnt_det_1                                   ;
wire                            riser_prsnt_det_2                                   ;
wire                            riser_prsnt_det_3                                   ;
wire                            riser_prsnt_det_4                                   ;
wire                            riser_prsnt_det_5                                   ;
wire                            riser_prsnt_det_6                                   ;
wire                            riser_prsnt_det_7                                   ;

wire [7:0]                      sw                                                  ; // 拨码开关

wire [3:0]                      w_pal_ocp1_prsnt_n                                  ;

wire                            ocp_prsent_b7_n                                     ;
wire                            ocp_prsent_b6_n                                     ;
wire                            ocp_prsent_b5_n                                     ;
wire                            ocp_prsent_b4_n                                     ;
wire                            ocp_prsent_b3_n                                     ;
wire                            ocp_prsent_b2_n                                     ;
wire                            ocp_prsent_b1_n                                     ;
wire                            ocp_prsent_b0_n                                     ;
wire                            cpu0_pcie1_b26_1                                    ;
wire                            cpu0_pcie1_a26_1                                    ;
wire                            cpu0_pcie1_b26_2                                    ;
wire                            cpu0_pcie1_a26_2                                    ;
wire                            cpu1_pcie0_b26_1                                    ;
wire                            cpu1_pcie0_a26_1                                    ;
wire                            cpu1_pcie0_b26_2                                    ;
wire                            cpu1_pcie0_a26_2                                    ;
wire                            cpu0_pcie2_b26_1                                    ;
wire                            cpu0_pcie2_a26_1                                    ;
wire                            cpu0_pcie2_b26_2                                    ;
wire                            cpu0_pcie2_a26_2                                    ;
wire                            cpu0_pcie3_b26_1                                    ;
wire                            cpu0_pcie3_a26_1                                    ;
wire                            cpu0_pcie3_b26_2                                    ;
wire                            cpu0_pcie3_a26_2                                    ;
wire                            cpu1_pcie2_b26_1                                    ;
wire                            cpu1_pcie2_a26_1                                    ;
wire                            cpu1_pcie2_b26_2                                    ;
wire                            cpu1_pcie2_a26_2                                    ;
wire                            cpu1_pcie3_b26_1                                    ;
wire                            cpu1_pcie3_a26_1                                    ;
wire                            cpu1_pcie3_b26_2                                    ;
wire                            cpu1_pcie3_a26_2                                    ;

wire                            db_pal_ext_rst_n                                    ;

wire                            rst_i2c0_mux_n                                      ;
wire                            rst_i2c3_mux_n                                      ;
wire                            rst_i2c13_mux_n                                     ;
wire                            rst_i2c1_mux_n                                      ;
wire                            rst_i2c4_2_mux_n                                    ;
wire                            rst_i2c8_mux_n                                      ;
wire                            rst_i2c2_mux_n                                      ;
wire                            rst_i2c5_mux_n                                      ;
wire                            rst_i2c12_mux_n                                     ;
wire                            rst_i2c11_mux_n                                     ;
wire                            rst_i2c4_1_mux_n                                    ;
wire                            rst_i2c10_mux_n                                     ;

wire                            rst_i2c_riser1_pca9548_n                            ;
wire                            rst_i2c_riser2_pca9548_n                            ;
wire                            pal_led_nic_act                                     ;
wire                            st_reset_state                                      ;
wire                            st_off_standby                                      ;
wire                            st_steady_pwrok                                     ;
wire                            st_halt_power_cycle                                 ;
wire                            st_aux_fail_recovery                                ;
wire                            tpm_rst                                             ;
wire                            t4hz_clk_cmu                                        ;
wire [15:0]                     bmc_cpld_version                                    ;
wire [15:0]                     cpld_date_mmdd                                      ;

wire [3:0]                      lattice_cpld                                        ;
wire [3:0]                      reserve_port                                        ;

wire [3:0]                      board_id                                            ;
wire [2:0]                      pcb_version                                         ;

wire                            nc_port                                             ;

wire                            pal_bp_efuse_pg                                     ;
wire                            db_i_pal_pgd_p0v8                                   ;
wire                            db_i_pal_pgd_p1v1                                   ;
wire                            db_i_pal_pgd_p1v2                                   ;
wire                            db_i_pal_pgd_p1v8                                   ;
wire                            db_i_pal_pgd_p3v3                                   ;

// CMU CPLD 输入信号
wire                            reserve_port1                                       ;
wire                            i_pal_wdt_rst_n_r                                   ;
wire                            bmc_ready_flag                                      ;
wire                            i_pal_health_fan_ctrl                               ;
wire                            i_pal_ifist_prsnt_n                                 ;
wire                            i_pal_bmc_rst_ind_n                                 ;
wire                            i_pal_bmc_tmp_alert_n                               ;
wire                            i_pal_program_n                                     ;
wire                            i_peci_master_sel                                   ;
wire                            i_vr_i2c_bmc_oe_n                                   ;
wire                            i_vr_i2c_bmc_sel                                    ;
wire                            i_pal_usb_rear_down_oc_n                            ;
wire                            i_pal_usb_rear_up_oc_n                              ;
wire                            i_pal_vga_rear_vcc_oc_n                             ;
wire                            i_bmc_hang_flag                                     ;
wire                            rst_pal_extrst_r_n                                  ;

wire [1:0]                      uart_mux_select                                     ;
wire                            remote_xdp_syspwrok_r                               ; // 未使用
//wire pal_plt_bmc_thermtrip_n_r;
wire                            leakage_det_do_n                                    ;
//wire pal_bmc_uboot_en_n_r;
wire                            pal_pwrgd_cpu0_lvc3_r                               ;
wire                            pfr_bmc_fw0_rst_n                                   ; // 未使用
wire                            pfr_bmc_fw1_rst_n                                   ; // 未使用
//wire pal_p5v_usb_rear_down_en_r; // 未使用
//wire remote_xdp_pod_prsnt_n    ; // 未使用
//wire pal_usb2_ocpdbg_oc_n_r    ; // 未使用
//wire pal_emmc_en_pwr_r         ; // 未使用
//wire pal_p5v_vga_rear_en_r     ; // 未使用
//wire pal_p5v_usb_rear_up_en_r  ; // 未使用
wire                            rom_bmc_ma_rst                                      ;
wire                            rom_bmc_bk_rst                                      ;
wire [1:0]                      bmcctl_uart_sw                                      ;
wire                            bmcctl_uart_sw_en                                   ;
wire [15:0]                     mb_cpld2_ver                                        ;

// 未使用
wire                            db_i_dimm_sns_alert                                 ;
wire                            db_i_fan_sns_alert                                  ;
wire                            db_i_p12v_stby_sns_alert                            ;

wire                            db_i_pal_lcd_card_in                                ;
wire                            rom_mux_bios_bmc_sel                                ;
wire                            rom_mux_bios_bmc_en                                 ;
wire                            test_bat_en                                         ;
wire                            rst_n                                               ;

wire [7:0]                      usb_en                                              ;
wire [39:0]                     pfr_to_led                                          ;
wire                            pal_rtc_intb                                        ;
wire                            pgd_p1v8_stby_dly30ms                               ;
wire                            pgd_p1v8_stby_dly32ms                               ;
wire                            vga2_dis                                            ;
wire                            pal_vga_sel_n                                       ;
wire                            db_front_vga_cable_prsnt_n                          ;
wire                            db_i_pal_ocp2_fan_foo                               ;
wire                            db_i_pal_ocp2_fan_prsnt_n                           ;

wire [7:0]                      bios_read_rtc                                       ;
wire [7:0]                      bios_post_code                                      ;
wire [7:0]                      bios_post_rate                                      ;
wire [7:0]                      bios_post_phase                                     ;

wire                            ocp1_prsnt_n                                        ;
wire                            ocp2_prsnt_n                                        ;
wire [5:0]                      ocp1_pvti_ss_count                                  ;
wire [5:0]                      ocp2_pvti_ss_count                                  ;
wire [7:0]                      ocp1_pvti_byte3                                     ;
wire [7:0]                      ocp1_pvti_byte2                                     ;
wire [7:0]                      ocp1_pvti_byte1                                     ;
wire [7:0]                      ocp1_pvti_byte0                                     ;
wire [7:0]                      ocp2_pvti_byte3                                     ;
wire [7:0]                      ocp2_pvti_byte2                                     ;
wire [7:0]                      ocp2_pvti_byte1                                     ;
wire [7:0]                      ocp2_pvti_byte0                                     ;
wire                            pal_ocp1_ncsi_en                                    ;
wire                            pal_ocp2_ncsi_en                                    ;
wire                            pal_ocp_ncsi_sw_en                                  ;
wire                            db_i_lom_fan_on_aux                                 ;
wire                            riser3_1_prsnt_n                                    ;
wire                            riser3_2_prsnt_n                                    ;
wire                            riser4_1_prsnt_n                                    ;
wire                            riser4_2_prsnt_n                                    ;
wire [5:0]                      riser3_slot7_id                                     ;
wire [5:0]                      riser3_slot8_id                                     ;
wire [5:0]                      riser4_slot9_id                                     ;
wire [5:0]                      riser4_slot10_id                                    ;
wire                            riser3_slot7_prsnt_n                                ;
wire                            riser3_slot8_prsnt_n                                ;
wire                            riser4_slot9_prsnt_n                                ;
wire                            riser4_slot10_prsnt_n                               ;
wire                            pal_pe_wake_n                                       ;
wire                            db_pal_riser3_slot7_pe_wake_n                       ;// 未使用
wire                            db_pal_riser3_slot8_pe_wake_n                       ;// 未使用
wire                            pal_riser3_slot7_pwrgd                              ;// 未使用
wire                            pal_riser3_slot8_pwrgd                              ;// 未使用
wire                            pal_riser4_slot9_pwrgd                              ;// 未使用
wire                            pal_riser4_slot10_pwrgd                             ;// 未使用
wire                            smb_pehp_cpu1_3v3_alert_n                           ;
wire                            bios_security_bypass                                ;
wire                            bios_read_flag                                      ;
wire                            bmc_read_flag                                       ;
wire                            cpu0_d0_bios_over                                   ;
wire                            cpu0_temp_over                                      ;
wire                            cpu1_temp_over                                      ;
wire                            db_i_cpu0_d0_temp_over                              ;
wire                            db_i_cpu0_d1_temp_over                              ;
// wire                            db_i_cpu0_d2_temp_over                              ; // 不使用
// wire                            db_i_cpu0_d3_temp_over                              ; // 不使用
wire                            db_i_cpu1_d0_temp_over                              ;
wire                            db_i_cpu1_d1_temp_over                              ;
// wire                            db_i_cpu1_d2_temp_over                              ; // 不使用
// wire                            db_i_cpu1_d3_temp_over                              ; // 不使用
//VPP
wire [11:0]                     J20_CPU1_MCIO_R_vpp                                 ;
wire [11:0]                     J19_CPU1_MCIO_R_vpp                                 ;
wire [11:0]                     J18_CPU1_MCIO_R_vpp                                 ;
wire [11:0]                     J17_CPU1_MCIO_R_vpp                                 ;
wire [11:0]                     J29_CPU1_MCIO_R_vpp                                 ;
wire [11:0]                     J16_CPU1_MCIO_R_vpp                                 ;
wire [11:0]                     J23_CPU2_MCIO_R_vpp                                 ;
wire [11:0]                     J24_CPU2_MCIO_R_vpp                                 ;
wire [11:0]                     J21_CPU2_MCIO_R_vpp                                 ;
wire [11:0]                     J22_CPU2_MCIO_R_vpp                                 ;
wire [11:0]                     J74_CPU2_MCIO_R_vpp                                 ;
wire [11:0]                     J25_CPU2_MCIO_R_vpp                                 ;
wire [11:0]                     J1_CPU1_MCIO_R_vpp                                  ;
wire [11:0]                     J39_CPU2_MCIO_R_vpp                                 ;

localparam                      port_num = 14                                       ;
wire [12*port_num-1:0]          para_data_in                                        ;
wire [9*port_num-1:0]           par_data_out                                        ;
wire [port_num-1:0]             ser_data_in                                         ;
wire [port_num-1:0]             ser_data_out                                        ;
wire [port_num-1:0]             i_read_flag                                         ;

wire                            db_riser_prsnt_det_2                                ;
wire                            db_riser_prsnt_det_3                                ;
wire                            db_riser_prsnt_det_0                                ;
wire                            db_riser_prsnt_det_1                                ;
wire                            db_i_riser_prsnt_det_9                              ;
wire                            db_i_riser_prsnt_det_8                              ;
wire                            db_riser_prsnt_det_6                                ;
wire                            db_riser_prsnt_det_7                                ;
wire                            db_riser_prsnt_det_4                                ;
wire                            db_riser_prsnt_det_5                                ;
wire                            db_i_riser_prsnt_det_11                             ;
wire                            db_i_riser_prsnt_det_10                             ;
wire                            db_i_pal_riser1_prsnt_n                             ;
wire                            db_i_pal_riser2_prsnt_n                             ;
wire                            i_j21_a28_riser_id1                                 ;
wire                            i_j21_a10_riser_id0                                 ;
wire                            i_j22_a28_riser_id1                                 ;
wire                            i_j22_a10_riser_id0                                 ;
wire                            i_j74_a28_riser_id1                                 ;
wire                            i_j74_a10_riser_id0                                 ;
wire                            i_j25_a28_riser_id1                                 ;
wire                            i_j25_a10_riser_id0                                 ;
wire                            mcoi_device_ready                                   ;
wire [2:0]                      chassis_id                                          ;
wire [31:0]                     AUX_BP_type                                         ;
wire [127:0]                    pcie_detect                                         ;
wire [1:0]                      debug_reg_15                                        ;

wire [15:0]                     o_mb_cb_prsnt_bmc                                   ; //0x28,0x2A
wire [15:0]                     mb_cb_prsnt                                         ; //0x2A,0x2C
wire [19:0]                     riser_ocp_m2_slot_number                            ; //0x30[7:0],0x31[7:0],0x32[2:0]
wire [43:0]                     nvme_slot_number                                    ; //0x37[6:0],0x36[7:0],0x35[7:0],0x34[7:0],0x33[7:0],0x32[7:3]
wire [99:0]                     nvme_slot_number_R4900                              ;
wire                            w4GpuRiser1Flag                                     ;
wire                            w4GpuRiser2Flag                                     ;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Moudule Instance
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------
// sys clock
//--------------------------------------------------------------------------------------------------------------------------------------
wire pal_p3v3_stby_pgd;

pll_i25M_o50M_o25M pll_inst(
    .clkout0                        (clk_50m                    ), // output 50.00000000MHz
    .clkout1                        (clk_25m                    ), // output 25.00000000MHz
    .lock                           (pll_lock                   ), // output
    .clkin1                         (i_CLK_C42_IN_25M           ), // input 25.0000MHz
    .rst                            (~pal_p3v3_stby_pgd         )  // input
);


//------------------------------------------------------------------------------------------------------------------------------------------
// SYS RST
//------------------------------------------------------------------------------------------------------------------------------------------
pon_reset pon_reset_inst(
    .clk                            (clk_50m                    ), //in
    .pll_lock                       (pll_lock                   ), //in
    .pgd_p3v3_stby                  (pal_p3v3_stby_pgd          ), //in
    .pgd_aux_gmt                    (pgd_aux_bmc                ), //in, all BMC power ok
    .done_booting                   (1'b1                       ), //in
    .done_booting_delayed           (done_booting_delayed       ), //in;  delayed version of done_booting (if not used, set to 1'b1)
    .pon_reset_n                    (pon_reset_n                ), //out; master AUX power-on reset (based on pgd_p3v3_stby)
    .pon_reset_db_n                 (pon_reset_db_n             ), //out; when done_booting_delayed not usd;  pon_reset_db_n = pon_reset_n. 
    .pgd_aux_system                 (pgd_aux_system             ), //out; AUX pgood indicator (based on both pgd_p3v3_stby and pgd_aux_gmt) pgd_aux_gmt means BMC p2v5/ BMC p1v2/ BMC p1v1/ BMC p1v0 pgd power good.
    .pgd_aux_system_sasd            (pgd_aux_system_sasd        ), //out; SASD version of pgd_aux_system; pgd_aux_system_sasd = pgd_aux_system
    .cpld_ready                     (                           )
);


//--------------------------------------------------------------------------------------------------------------------------------------------------
// Generate timer ticks (1-clk wide pulse) and slow 50% duty cycle clock
//--------------------------------------------------------------------------------------------------------------------------------------------------
timer_gen timer_gen_inst(
  .clk                              (clk_50m                    ),
  .reset                            (~pon_reset_n               ),
  .t40ns                            (t40ns_tick                 ),
  .t80ns                            (),
  .t160ns                           (),
  .t1us                             (t1us_tick                  ),
  .t2us                             (t2us_tick                  ),
  .t8us                             (t8us_tick                  ),
  .t16us                            (t16us_tick                 ),
  .t32us                            (t32us_tick                 ),
  .t128us                           (t128us_tick                ),
  .t512us                           (t512us_tick                ),
  .t1ms                             (t1ms_tick                  ),
  .t2ms                             (t2ms_tick                  ),
  .t16ms                            (t16ms_tick                 ),
  .t32ms                            (t32ms_tick                 ),
  .t64ms                            (t64ms_tick                 ),
  .t128ms                           (t128ms_tick                ),
  .t256ms                           (t256ms_tick                ),
  .t512ms                           (t512ms_tick                ),
  .t1s                              (t1s_tick                   ),
  .t8s                              (t8s_tick                   ),//YHY 
  .clk_1hz                          (t1hz_clk                   ),
  .clk_2p5hz                        (t2p5hz_clk                 ),
  .clk_4hz                          (t4hz_clk                   ),
  .clk_16khz                        (t16khz_clk                 ),
  .clk_6m25                         (t6m25_clk                  )
);


//--------------------------------------------------------------------------------------------------------------------------------------------------
// PWRGOOD DEBOUNCE
//--------------------------------------------------------------------------------------------------------------------------------------------------
PGM_DEBOUNCE_N #(.SIGCNT(4), .NBITS(2'b11), .ENABLE(1'b1)) db_inst_pwrgood (
    .clk			                  (clk_50m),
    .rst_n		                  (pon_reset_n),
    .timer_tick	                (1'b1),
    .din                        ({
	                              i_PAL_OCP2_PWRGD          ,	//01
	                              ~i_DIMM_SNS_ALERT         , //02
	                              ~i_FAN_SNS_ALERT          , //03
	                              ~i_P12V_STBY_SNS_ALERT      //04
	                              }),             
    .dout                       ({
	                              db_i_pal_ocp2_pwrgd       ,	//01
	                              db_i_dimm_sns_alert       , //02
	                              db_i_fan_sns_alert        , //03
	                              db_i_p12v_stby_sns_alert    //04
	                              }) 
);


PGM_DEBOUNCE_N #(.SIGCNT(2), .NBITS(2'b11), .ENABLE(1'b1)) db_intruder (
    .clk			                (clk_50m),
    .rst_n		                (pon_reset_n),
    .timer_tick	              (t512us_tick),
    .din                      ({
	                            i_PAL_LCD_CARD_IN         ,  //01
	                            i_PAL_LOM_FAN_ON_AUX_R       //02
	                            }),             
    .dout                     ({
	                            db_i_pal_lcd_card_in    ,  //01
	                            db_i_lom_fan_on_aux        //02
	                            }) 
);
//------------------------------------------------------------------------------
// Input debouncers and synchronizers
//------------------------------------------------------------------------------
PGM_DEBOUNCE #(.SIGCNT(1), .NBITS(2'b10), .ENABLE(1'b1)) db_inst_button (
    .clk          (clk_50m                ),
    .rst          (~pon_reset_n           ),
    .timer_tick   (t64ms_tick             ),
    .din          ({
                  i_PAL_EXT_RST_N                //01    
                  }),                           
    .dout         ({
                  db_pal_ext_rst_n               //01     
                  })             
);

PGM_DEBOUNCE #(.SIGCNT(14), .NBITS(2'b10), .ENABLE(1'b1)) mcio_ab26 (
    .clk(clk_50m),
    .rst(~pon_reset_n),
    .timer_tick(1'b1),
    .din({
	        riser_prsnt_det_2               ,//01 J20 B28
	        riser_prsnt_det_3               ,//02 J19 B28 
            riser_prsnt_det_0               ,//03 J18 B28
			riser_prsnt_det_1               ,//04 J17 B28
			i_RISER_PRSNT_DET_9             ,//05 J29 B28
			i_RISER_PRSNT_DET_8             ,//06 J16 B28
			riser_prsnt_det_6               ,//07 J23 B28
			riser_prsnt_det_7               ,//08 J24 B28
			riser_prsnt_det_4               ,//09 J21 B28
			riser_prsnt_det_5               ,//10 J22 B28
			i_RISER_PRSNT_DET_11            ,//11 J74 B28
			i_RISER_PRSNT_DET_10            ,//12 J25 B28
			i_PAL_RISER1_PRSNT_N            ,//13
			i_PAL_RISER2_PRSNT_N             //14
        }),             
    .dout({
			db_riser_prsnt_det_2            ,//01 J20 B28
	        db_riser_prsnt_det_3            ,//02 J19 B28
            db_riser_prsnt_det_0            ,//03 J18 B28
            db_riser_prsnt_det_1            ,//04 J17 B28
            db_i_riser_prsnt_det_9          ,//05 J29 B28
            db_i_riser_prsnt_det_8          ,//06 J16 B28
            db_riser_prsnt_det_6            ,//07 J23 B28
			db_riser_prsnt_det_7            ,//08 J24 B28
			db_riser_prsnt_det_4            ,//09 J21 B28
			db_riser_prsnt_det_5            ,//10 J22 B28
			db_i_riser_prsnt_det_11         ,//11 J74 B28
			db_i_riser_prsnt_det_10         ,//12 J25 B28
			db_i_pal_riser1_prsnt_n         ,//13
			db_i_pal_riser2_prsnt_n          //14
      }) 
);

PGM_DEBOUNCE #(.SIGCNT(3), .NBITS (2'b10), .ENABLE(1'b1)) db_pe_wake_inst(
    .clk                (clk_50m),
    .timer_tick         (t512us_tick),
    .rst                (~pon_reset_n),
    .din                ({	                               
		                    i_FRONT_VGA_CABLE_PRSNT_N              ,//01
		                    i_PAL_OCP2_FAN_FOO                     ,//02
		                    i_PAL_OCP2_FAN_PRSNT_N                  //03
	                      }),                   
    .dout                 ({       
		                    db_front_vga_cable_prsnt_n            ,//01
		                    db_i_pal_ocp2_fan_foo                 ,//02
		                    db_i_pal_ocp2_fan_prsnt_n              //03
	                      })
);


SYNC_DATA_N #(.SIGCNT(8)) sync_cpu_data_low (
  .clk    (clk_50m),
  .rst_n  (pon_reset_n),          
  .din    ({
			    i_CPU0_D0_TEMP_OVER	             , //01
			    i_CPU0_D1_TEMP_OVER	             , //02
			    // i_CPU0_D2_TEMP_OVER			     , //03
			    // i_CPU0_D3_TEMP_OVER			     , //04
			    i_CPU1_D0_TEMP_OVER			     , //05
			    i_CPU1_D1_TEMP_OVER				  //06 
			    // i_CPU1_D2_TEMP_OVER			     , //07
			    // i_CPU1_D3_TEMP_OVER			       //08
		    }), 
			
  .dout   ({
			    db_i_cpu0_d0_temp_over	         , //01
			    db_i_cpu0_d1_temp_over	         , //02
			    // db_i_cpu0_d2_temp_over			 , //03
			    // db_i_cpu0_d3_temp_over			 , //04
			    db_i_cpu1_d0_temp_over			 , //05
			    db_i_cpu1_d1_temp_over	          //06 
			    // db_i_cpu1_d2_temp_over			 , //07
			    // db_i_cpu1_d3_temp_over			   //08
			})      
);


//--------------------------------------------------------------------------------------------------------------------------------------------------
// SGPIO Moudule
//--------------------------------------------------------------------------------------------------------------------------------------------------
wire sys_hlth_red_blink_n;
wire sys_hlth_grn_blink_n;
wire led_uid             ;
wire ocp_main_en         ;
wire ocp_aux_en          ;
wire pex_reset_n         ;
wire t4hz_test_mcpld     ;
wire [5:0] power_seq_sm  ;

wire [511:0] mcpld_to_scpld_s2p_data;
wire [511:0] scpld_to_mcpld_p2s_data;

reg [348:0] mcpld_to_scpld_data_filter;
reg        mcpld_sgpio_fail;

always@(posedge clk_50m or negedge pon_reset_n)
	begin
		if(~pon_reset_n)
			begin
				mcpld_to_scpld_data_filter <= {349{1'b0}};
				mcpld_sgpio_fail <=1'b0;
			end
		else if
			((mcpld_to_scpld_s2p_data[3:0] == 4'b0101)&& (mcpld_to_scpld_s2p_data[511:508] == 4'b1010))
			begin 
				mcpld_to_scpld_data_filter <= mcpld_to_scpld_s2p_data[352:4];
				mcpld_sgpio_fail <=1'b0;
			end
		else
			begin
				mcpld_to_scpld_data_filter <= mcpld_to_scpld_data_filter;
				mcpld_sgpio_fail <=1'b1;
			end
		
end


// M CPLD ---> S CPLD
s2p_slave #(.NBIT(512)) inst_mcpld_to_scpld_s2p(
	.clk    (clk_50m                      ),
	.rst    (~pon_reset_n                 ),
	.si     (i_CPLD_M_S_SGPIO_MOSI	      ),// in  SGPIO_MOSI Serial Signal input
	.po     (mcpld_to_scpld_s2p_data      ),// out Parallel Signal output
	.sld_n  (i_CPLD_M_S_SGPIO_LD_N	      ),// in  SGPIO_LOAD
	.sclk   (i_CPLD_M_S_SGPIO_CLK		  ) // in  SGPIO_CLK
); 

// S CPLD ---> M CPLD
p2s_slave #(.NBIT(512)) inst_scpld_to_mcpld_p2s(
	.clk    (clk_50m					),
	.rst    (~pon_reset_n				),
	.pi     (scpld_to_mcpld_p2s_data	),// in Parallel Signal input
	.so     (o_CPLD_M_S_SGPIO_MISO_R	),// out SGPIO_MISO Serial Signal output
	.sld_n  (i_CPLD_M_S_SGPIO_LD_N   	),// in SGPIO_LOAD
	.sclk   (i_CPLD_M_S_SGPIO_CLK	    ) // in SGPIO_CLK
);

//S CPLD ---> M CPLD
assign scpld_to_mcpld_p2s_data[511]     = 1'b1                           ; 
assign scpld_to_mcpld_p2s_data[510]     = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[509]     = 1'b1                           ; 
assign scpld_to_mcpld_p2s_data[508]     = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[507:433] = 75'b0                          ;

// 新增信号
assign scpld_to_mcpld_p2s_data[432]     = i_CHASSIS_ID0_N                ;
assign scpld_to_mcpld_p2s_data[431]     = i_CHASSIS_ID1_N                ;
// 新增信号

assign scpld_to_mcpld_p2s_data[430]     = bmc_ready_flag                 ;
assign scpld_to_mcpld_p2s_data[429]     = db_i_pal_pgd_p3v3              ;
assign scpld_to_mcpld_p2s_data[428]     = db_i_pal_pgd_p1v8              ;
assign scpld_to_mcpld_p2s_data[427]     = db_i_pal_pgd_p1v2              ;
assign scpld_to_mcpld_p2s_data[426]     = db_i_pal_pgd_p1v1              ;
assign scpld_to_mcpld_p2s_data[425]     = db_i_pal_pgd_p0v8              ;
assign scpld_to_mcpld_p2s_data[424]     = cpu1_temp_over                 ;
assign scpld_to_mcpld_p2s_data[423]     = cpu0_temp_over                 ;
assign scpld_to_mcpld_p2s_data[422]     = db_i_lom_prsnt_n               ;// 1'b0
assign scpld_to_mcpld_p2s_data[421]     = lom_thermal_trip               ;// 1'b0
assign scpld_to_mcpld_p2s_data[420]     = db_i_pal_ocp2_fan_prsnt_n      ;
assign scpld_to_mcpld_p2s_data[419]     = db_i_pal_ocp2_fan_foo          ;
assign scpld_to_mcpld_p2s_data[418]     = db_i_pal_lcd_card_in           ;
assign scpld_to_mcpld_p2s_data[417]     = i_pal_ifist_prsnt_n            ;
assign scpld_to_mcpld_p2s_data[416:409] = bios_post_code[7:0]            ;
assign scpld_to_mcpld_p2s_data[408:401] = bios_post_phase[7:0]           ;
assign scpld_to_mcpld_p2s_data[400:393] = bios_post_rate[7:0]            ;
assign scpld_to_mcpld_p2s_data[392]     = bios_read_flag                 ;
assign scpld_to_mcpld_p2s_data[391:384] = 8'b0                           ; // 信号直接传入MCPLD使用{pal_bp8_prsnt_n,pal_bp7_prsnt_n,pal_bp6_prsnt_n,pal_bp5_prsnt_n,pal_bp4_prsnt_n,pal_bp3_prsnt_n,pal_bp2_prsnt_n,pal_bp1_prsnt_n};//led_to_pfr[7:0];
assign scpld_to_mcpld_p2s_data[383]     = 1'b0 /*USB2_LCD_ALERT*/        ;
assign scpld_to_mcpld_p2s_data[382]     = 1'b0 /*VGA2_OC_ALERT */        ;
assign scpld_to_mcpld_p2s_data[381]     = i_PAL_UPD72020_2_ALART         ;//PAL_UPD72020_2_ALART 1'b0
assign scpld_to_mcpld_p2s_data[380]     = i_PAL_UPD72020_1_ALART         ;//PAL_UPD72020_1_ALART 1'b0
assign scpld_to_mcpld_p2s_data[379]     = usb_en[1]                      ;
assign scpld_to_mcpld_p2s_data[378]     = usb_en[0]                      ;
assign scpld_to_mcpld_p2s_data[377]     = 1'b0 /*DSD_UART_PRSNT_N*/      ;
assign scpld_to_mcpld_p2s_data[376]     = pfr_pe_wake_n                  ;
assign scpld_to_mcpld_p2s_data[375:368] = ocp2_pvti_byte3                ;       
assign scpld_to_mcpld_p2s_data[367:360] = ocp2_pvti_byte2                ;             
assign scpld_to_mcpld_p2s_data[359:352] = ocp2_pvti_byte1                ;
assign scpld_to_mcpld_p2s_data[351:344] = ocp2_pvti_byte0                ;
assign scpld_to_mcpld_p2s_data[343:336] = ocp1_pvti_byte3                ;
assign scpld_to_mcpld_p2s_data[335:328] = ocp1_pvti_byte2                ;
assign scpld_to_mcpld_p2s_data[327:320] = ocp1_pvti_byte1                ;
assign scpld_to_mcpld_p2s_data[319:312] = ocp1_pvti_byte0                ;

assign scpld_to_mcpld_p2s_data[311:308] = board_id                       ; // 传入MCPLD, addr 0x0070[7:4]
assign scpld_to_mcpld_p2s_data[307:305] = pcb_version                    ; // 传入MCPLD, addr 0x0070[3:1]

assign scpld_to_mcpld_p2s_data[304:299] = riser4_slot10_id               ;
assign scpld_to_mcpld_p2s_data[298:293] = riser4_slot9_id                ;
assign scpld_to_mcpld_p2s_data[292:287] = riser3_slot8_id                ;
assign scpld_to_mcpld_p2s_data[286:281] = riser3_slot7_id                ;
assign scpld_to_mcpld_p2s_data[280]     = riser4_2_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[279]     = riser4_1_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[278]     = riser3_2_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[277]     = riser3_1_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[276]     = riser4_slot10_prsnt_n          ;
assign scpld_to_mcpld_p2s_data[275]     = riser4_slot9_prsnt_n           ;
assign scpld_to_mcpld_p2s_data[274]     = riser3_slot8_prsnt_n           ;
assign scpld_to_mcpld_p2s_data[273]     = riser3_slot7_prsnt_n           ;
assign scpld_to_mcpld_p2s_data[272]     = w4GpuRiser2Flag                ;
assign scpld_to_mcpld_p2s_data[271]     = w4GpuRiser1Flag                ;
assign scpld_to_mcpld_p2s_data[270:263] = riser2_pvti_byte3              ;
assign scpld_to_mcpld_p2s_data[262:255] = riser2_pvti_byte2              ;
assign scpld_to_mcpld_p2s_data[254:247] = riser2_pvti_byte1              ;
assign scpld_to_mcpld_p2s_data[246:239] = riser2_pvti_byte0              ;
assign scpld_to_mcpld_p2s_data[238:231] = riser1_pvti_byte3              ;
assign scpld_to_mcpld_p2s_data[230:223] = riser1_pvti_byte2              ;
assign scpld_to_mcpld_p2s_data[222:215] = riser1_pvti_byte1              ;
assign scpld_to_mcpld_p2s_data[214:207] = riser1_pvti_byte0              ;
assign scpld_to_mcpld_p2s_data[206:191] = mb_cb_prsnt[15:0]              ;
assign scpld_to_mcpld_p2s_data[190]     = db_riser_prsnt_det_2           ;
assign scpld_to_mcpld_p2s_data[189]     = db_riser_prsnt_det_3           ;
assign scpld_to_mcpld_p2s_data[188]     = db_riser_prsnt_det_0           ;
assign scpld_to_mcpld_p2s_data[187]     = db_riser_prsnt_det_1           ;
assign scpld_to_mcpld_p2s_data[186]     = db_i_riser_prsnt_det_9         ;
assign scpld_to_mcpld_p2s_data[185]     = db_i_riser_prsnt_det_8         ;
assign scpld_to_mcpld_p2s_data[184]     = db_riser_prsnt_det_6           ;
assign scpld_to_mcpld_p2s_data[183]     = db_riser_prsnt_det_7           ;
assign scpld_to_mcpld_p2s_data[182]     = db_riser_prsnt_det_4           ;
assign scpld_to_mcpld_p2s_data[181]     = db_riser_prsnt_det_5           ;
assign scpld_to_mcpld_p2s_data[180]     = db_i_riser_prsnt_det_11        ;
assign scpld_to_mcpld_p2s_data[179]     = db_i_riser_prsnt_det_10        ;
assign scpld_to_mcpld_p2s_data[178:135] = nvme_slot_number[43:0]         ;
assign scpld_to_mcpld_p2s_data[134:115] = riser_ocp_m2_slot_number[19:0] ;
assign scpld_to_mcpld_p2s_data[114]     = db_i_p12v_stby_sns_alert       ; // 传入MCPLD, addr 0xA4[0]	
assign scpld_to_mcpld_p2s_data[113]     = db_i_fan_sns_alert             ; // 传入MCPLD, addr 0xA4[1]	
assign scpld_to_mcpld_p2s_data[112]     = db_i_dimm_sns_alert            ; // 传入MCPLD, addr 0xA4[2] 
assign scpld_to_mcpld_p2s_data[111]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_5
assign scpld_to_mcpld_p2s_data[110]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_4
assign scpld_to_mcpld_p2s_data[109]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_3

assign scpld_to_mcpld_p2s_data[108]     = 1'b0 /*pal_gpu_fan4_prsnt*/    ;//BOARD_ID4
assign scpld_to_mcpld_p2s_data[107]     = 1'b0 /*pal_gpu_fan3_prsnt*/    ;//BOARD_ID3
assign scpld_to_mcpld_p2s_data[106]     = 1'b0 /*pal_gpu_fan2_prsnt*/    ;//BOARD_ID2
assign scpld_to_mcpld_p2s_data[105]     = 1'b0 /*pal_gpu_fan1_prsnt*/    ;//BOARD_ID1
assign scpld_to_mcpld_p2s_data[104]     = 1'b0 /*pal_gpu_fan4_foo  */    ;//BOARD_ID0
assign scpld_to_mcpld_p2s_data[103]     = 1'b0 /*pal_gpu_fan3_foo  */    ;//CHASSIS_ID2_N
assign scpld_to_mcpld_p2s_data[102]     = 1'b0 /*pal_gpu_fan2_foo  */    ;
assign scpld_to_mcpld_p2s_data[101]     = 1'b0 /*pal_gpu_fan1_foo  */    ;

assign scpld_to_mcpld_p2s_data[100:85]  = bmc_cpld_version               ;

// PCB and PCA 版本
assign scpld_to_mcpld_p2s_data[84]      = pcb_revision_1                 ;//PCB_REVISION_1
assign scpld_to_mcpld_p2s_data[83]      = pcb_revision_0                 ;//PCB_REVISION_0
assign scpld_to_mcpld_p2s_data[82]      = pca_revision_2                 ;//PCA_REVISION_2
assign scpld_to_mcpld_p2s_data[81]      = pca_revision_1                 ;//PCA_REVISION_1
assign scpld_to_mcpld_p2s_data[80]      = pca_revision_0                 ;

assign scpld_to_mcpld_p2s_data[79:64]   = mb_cpld2_ver                   ;
assign scpld_to_mcpld_p2s_data[63]      = i_pal_wdt_rst_n_r              ;
assign scpld_to_mcpld_p2s_data[62]      = 1'b0 /*TPM_MODULE_PRSNT_N*/    ;//TPM_PRSNT_N
assign scpld_to_mcpld_p2s_data[61]      = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[60]      = 1'b0                           ;//PAL_LCD_PRSNT
// assign scpld_to_mcpld_p2s_data[59]      = i_PAL_M2_1_SEL_R                 ;//PAL_LCD_BUSY
assign scpld_to_mcpld_p2s_data[58]      = i_PAL_M2_1_PRSNT_N             ; // 传入MCPLD, addr 0x0015[0]
assign scpld_to_mcpld_p2s_data[57]      = i_PAL_M2_0_PRSNT_N             ; // 传入MCPLD, addr 0x0015[0]
assign scpld_to_mcpld_p2s_data[56]      = i_PAL_RISER2_PRSNT_N           ;
// assign scpld_to_mcpld_p2s_data[55]      = 1'b0 /*PAL_RISER1_PRSNT_N*/    ;
assign scpld_to_mcpld_p2s_data[54]      = riser2_emc_alert_n             ;
assign scpld_to_mcpld_p2s_data[53]      = riser1_emc_alert_n             ;
assign scpld_to_mcpld_p2s_data[52]      = db_pal_ext_rst_n               ;

// 拨码开关状态
assign scpld_to_mcpld_p2s_data[51:44]   = sw                             ; // 传入MCPLD, 拨码开关使用

// NVMe 网卡存在信号
assign scpld_to_mcpld_p2s_data[43]      = cpu_nvme17_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[42]      = cpu_nvme16_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[41]      = cpu_nvme15_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[40]      = cpu_nvme14_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[39]      = 1'b0/*cpu_nvme13_prsnt_n*/     ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[38]      = 1'b0/*cpu_nvme12_prsnt_n*/     ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[37]      = cpu_nvme11_prsnt_n             ;//CPU1 D2 
assign scpld_to_mcpld_p2s_data[36]      = cpu_nvme10_prsnt_n             ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[35]      = 1'b0/*cpu_nvme19_prsnt_n*/     ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[34]      = 1'b0/*cpu_nvme18_prsnt_n*/     ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[33]      = 1'b0/*cpu_nvme23_prsnt_n*/     ;//CPU1 D0 
assign scpld_to_mcpld_p2s_data[32]      = 1'b0/*cpu_nvme22_prsnt_n*/     ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[31]      = cpu_nvme7_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[30]      = cpu_nvme6_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[29]      = cpu_nvme5_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[28]      = cpu_nvme4_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[27]      = 1'b0/*cpu_nvme3_prsnt_n*/      ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[26]      = 1'b0/*cpu_nvme2_prsnt_n*/      ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[25]      = cpu_nvme1_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[24]      = cpu_nvme0_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[23]      = 1'b0/*cpu_nvme9_prsnt_n*/      ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[22]      = 1'b0/*cpu_nvme8_prsnt_n*/      ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[21]      = 1'b0/*cpu_nvme25_prsnt_n*/     ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[20]      = 1'b0/*cpu_nvme24_prsnt_n*/     ;//CPU0 D1

// OCP 网卡存在信号
assign scpld_to_mcpld_p2s_data[19]      = 1'b0 /*ocp_prsent_b7_n*/       ; // 未使用
assign scpld_to_mcpld_p2s_data[18]      = 1'b0 /*ocp_prsent_b6_n*/       ; // 未使用
assign scpld_to_mcpld_p2s_data[17]      = 1'b0 /*ocp_prsent_b5_n*/       ; // 未使用
assign scpld_to_mcpld_p2s_data[16]      = 1'b0 /*ocp_prsent_b4_n*/       ; // 未使用
assign scpld_to_mcpld_p2s_data[15]      = 1'b0 /*ocp_prsent_b3_n*/       ; // 未使用
assign scpld_to_mcpld_p2s_data[14]      = 1'b0 /*ocp_prsent_b2_n*/       ; // 未使用
assign scpld_to_mcpld_p2s_data[13]      = 1'b0 /*ocp_prsent_b1_n*/       ; // 未使用
assign scpld_to_mcpld_p2s_data[12]      = 1'b0 /*ocp_prsent_b0_n*/       ; // 未使用

// Fan 安装状态信号
assign scpld_to_mcpld_p2s_data[11]      = 1'b0 /*fan8_install_n*/        ;// 未使用
assign scpld_to_mcpld_p2s_data[10]      = 1'b0 /*fan7_install_n*/        ;// 未使用
assign scpld_to_mcpld_p2s_data[9]       = 1'b0 /*fan6_install_n*/        ;// 未使用
assign scpld_to_mcpld_p2s_data[8]       = 1'b0 /*fan5_install_n*/        ;// 未使用
assign scpld_to_mcpld_p2s_data[7]       = 1'b0 /*fan4_install_n*/        ;// 未使用
assign scpld_to_mcpld_p2s_data[6]       = 1'b0 /*fan3_install_n*/        ;// 未使用
assign scpld_to_mcpld_p2s_data[5]       = 1'b0 /*fan2_install_n*/        ;// 未使用
assign scpld_to_mcpld_p2s_data[4]       = 1'b0 /*fan1_install_n*/        ;// 未使用

// 固定标志位
assign scpld_to_mcpld_p2s_data[3]       = 1'b0                           ; 
assign scpld_to_mcpld_p2s_data[2]       = 1'b1                           ;
assign scpld_to_mcpld_p2s_data[1]       = 1'b0                           ; 
assign scpld_to_mcpld_p2s_data[0]       = 1'b1                           ;

//M CPLD ---> S CPLD

assign p5v_en_r                       = mcpld_to_scpld_data_filter[348]     ; // 主CPLD 上电控制信号
assign p3v3_en_r                      = mcpld_to_scpld_data_filter[347]     ; // 主CPLD 上电控制信号
assign p1v1_en_r                      = mcpld_to_scpld_data_filter[346]     ; // 主CPLD 上电控制信号

assign test_bat_en                    = mcpld_to_scpld_data_filter[345]     ; // 主CPLD addr 0x0008[7] 
assign bmc_extrst_uid                 = mcpld_to_scpld_data_filter[344]     ; // 从CPLD UID_FUNCTIN 模块给出
// assign pal_m2_0_sel_lv33_r            = mcpld_to_scpld_data_filter[343]    ;
assign i2c_ram_1058                   = mcpld_to_scpld_data_filter[342:335] ;
assign i2c_ram_1057                   = mcpld_to_scpld_data_filter[334:327] ;
assign i2c_ram_1056                   = mcpld_to_scpld_data_filter[326:319] ;
assign i2c_ram_1055                   = mcpld_to_scpld_data_filter[318:311] ;
assign i2c_ram_1054                   = mcpld_to_scpld_data_filter[310:303] ;
assign i2c_ram_1053                   = mcpld_to_scpld_data_filter[302:295] ;
assign i2c_ram_1052                   = mcpld_to_scpld_data_filter[294:287] ;
assign i2c_ram_1051                   = mcpld_to_scpld_data_filter[286:279] ;
assign i2c_ram_1050                   = mcpld_to_scpld_data_filter[278:271] ;
assign pal_bp_efuse_pg                = mcpld_to_scpld_data_filter[270]     ;
assign rst_i2c0_mux_n                 = mcpld_to_scpld_data_filter[269]     ;
assign pal_led_nic_act                = mcpld_to_scpld_data_filter[268]     ; // 从CPLD解析信号, 主CPLD处理, 再给从CPLD点灯
assign rst_i2c_riser2_pca9548_n       = mcpld_to_scpld_data_filter[267]     ; // 主CPLD addr 0x001A
assign rst_i2c_riser1_pca9548_n       = mcpld_to_scpld_data_filter[266]     ; // 主CPLD addr 0x001A
assign cpu0_d0_bios_over              = mcpld_to_scpld_data_filter[265]     ;
assign bmc_read_flag                  = mcpld_to_scpld_data_filter[264]     ;
assign vga2_dis                       = mcpld_to_scpld_data_filter[263]     ;
assign pfr_to_led                     = mcpld_to_scpld_data_filter[262:223] ;
assign pgd_p1v8_stby_dly32ms          = mcpld_to_scpld_data_filter[222]     ;
assign pgd_p1v8_stby_dly30ms          = mcpld_to_scpld_data_filter[221]     ;
assign bios_security_bypass           = mcpld_to_scpld_data_filter[220]     ;
assign pal_rtc_intb                   = mcpld_to_scpld_data_filter[219]     ;
assign pal_ocp_ncsi_sw_en             = mcpld_to_scpld_data_filter[218]     ;
assign pal_ocp2_ncsi_en               = mcpld_to_scpld_data_filter[217]     ;
assign pal_ocp1_ncsi_en               = mcpld_to_scpld_data_filter[216]     ;
assign pal_pe_wake_n                  = mcpld_to_scpld_data_filter[215]     ;
assign smb_pehp_cpu1_3v3_alert_n      = mcpld_to_scpld_data_filter[214]     ;
assign debug_reg_15[1:0]              = mcpld_to_scpld_data_filter[213:212] ;
assign rom_mux_bios_bmc_en            = mcpld_to_scpld_data_filter[211]     ; // 主CPLD addr 0x0007[7]
assign AUX_BP_type[31:0]              = mcpld_to_scpld_data_filter[210:179] ;
assign pcie_detect[127:0]             = mcpld_to_scpld_data_filter[178:51]  ;
assign o_mb_cb_prsnt_bmc[15:0]        = mcpld_to_scpld_data_filter[50:35]   ;
assign rom_mux_bios_bmc_sel           = mcpld_to_scpld_data_filter[34]      ; // 主CPLD addr 0x0007[6]
assign bmcctl_uart_sw_en              = mcpld_to_scpld_data_filter[33]      ;
assign bmcctl_uart_sw[1:0]            = mcpld_to_scpld_data_filter[33:32]   ;
assign rom_bmc_bk_rst                 = mcpld_to_scpld_data_filter[31]      ;
assign rom_bmc_ma_rst                 = mcpld_to_scpld_data_filter[30]      ;
assign rst_pal_extrst_r_n             = mcpld_to_scpld_data_filter[29]      ; // 主CPLD UID长按复位
assign leakage_det_do_n               = mcpld_to_scpld_data_filter[28]      ;
assign tpm_rst                        = mcpld_to_scpld_data_filter[27]      ; // 主CPLD addr 0x001D[7]

// BMC 复位信号控制
assign rst_i2c13_mux_n                = mcpld_to_scpld_data_filter[26] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c12_mux_n                = mcpld_to_scpld_data_filter[25] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c11_mux_n                = mcpld_to_scpld_data_filter[24] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c10_mux_n                = mcpld_to_scpld_data_filter[23] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c8_mux_n                 = mcpld_to_scpld_data_filter[22] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c5_mux_n                 = mcpld_to_scpld_data_filter[21] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c4_2_mux_n               = mcpld_to_scpld_data_filter[20] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c4_1_mux_n               = mcpld_to_scpld_data_filter[19] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c3_mux_n                 = mcpld_to_scpld_data_filter[18] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c2_mux_n                 = mcpld_to_scpld_data_filter[17] ; // 主CPLD addr 0x0019 0x001A 0x001B
assign rst_i2c1_mux_n                 = mcpld_to_scpld_data_filter[16] ; // 主CPLD addr 0x0019 0x001A 0x001B

assign sys_hlth_red_blink_n           = mcpld_to_scpld_data_filter[15] ; // 从CPLD addr 0x000B[1]
assign sys_hlth_grn_blink_n           = mcpld_to_scpld_data_filter[14] ; // 从CPLD addr 0x000B[0]
assign led_uid                        = mcpld_to_scpld_data_filter[13] ; // 主CPLD 控制UID点灯
assign power_supply_on                = mcpld_to_scpld_data_filter[12] ; // 主CPLD power_supply电/p12v_efuse电
assign ocp_main_en                    = mcpld_to_scpld_data_filter[11] ;
assign ocp_aux_en                     = mcpld_to_scpld_data_filter[10] ;
assign pex_reset_n                    = mcpld_to_scpld_data_filter[9]  ;
assign reached_sm_wait_powerok        = mcpld_to_scpld_data_filter[8]  ; // 主CPLD 状态机跳转
assign usb_ponrst_r_n                 = mcpld_to_scpld_data_filter[7]  ; // 主CPLD 跟随CPU_REST一起复位
assign t4hz_test_mcpld                = mcpld_to_scpld_data_filter[6]  ;
assign power_seq_sm		              = mcpld_to_scpld_data_filter[5:0];

//MB CPLD <---> BMC CPLD
wire [255:0]                            mbcpld_to_bmccpld_p2s_data  ;
wire [255:0]                            bmccpld_to_mbcpld_s2p_data  ;
wire                                    cpld_sgpio_ld_n             ;
wire                                    cpld_sgpio_clk              ;

//BMC CPLD ---> MB CPLD
s2p_master #(.NBIT(256)) inst_cmu_to_mb_s2p(
    .clk     (clk_50m					    ),
    .warm_rst(~pon_reset_n                  ),
    .cold_rst(~pon_reset_n	                ),
    .tick    (t1us_tick		                ),
    .si      (i_PAL_BMC_SS_DATA_IN          ),//SGPIO_MISO  Serial Signal input
    .po      (bmccpld_to_mbcpld_s2p_data    ),//Parallel Signal output
    .sld_n   (cpld_sgpio_ld_n		        ),//SGPIO_LOAD
    .sclk    (cpld_sgpio_clk 			    ) //SGPIO_CLK
);

assign o_PAL_BMC_SS_LOAD_N = cpld_sgpio_ld_n; //SGPIO_LOAD
assign o_PAL_BMC_SS_CLK    = cpld_sgpio_clk ; //SGPIO_CLK

//MB CPLD  ---> BMC CPLD
p2s_slave #(.NBIT(256)) inst_mb_to_cmu_p2s(
    .clk      (clk_50m					    ),
    .rst      (~pon_reset_n				    ),
    .pi       (mbcpld_to_bmccpld_p2s_data	),//Parallel Signal input
    .so       (o_PAL_BMC_SS_DATA_OUT 		),//SGPIO_MISO Serial Signal output
    .sld_n    (cpld_sgpio_ld_n		        ),//SGPIO_LOAD
    .sclk     (cpld_sgpio_clk		        ) //SGPIO_CLK
);

//BMC CPLD ---> MB CPLD
assign i_bmc_hang_flag			         = bmccpld_to_mbcpld_s2p_data[67]       ; // 未使用
assign i_pal_vga_rear_vcc_oc_n	         = bmccpld_to_mbcpld_s2p_data[66]       ; // 未使用
assign board_id		                     = bmccpld_to_mbcpld_s2p_data[65:62]    ; // 传入MCPLD 
assign pcb_version	                     = bmccpld_to_mbcpld_s2p_data[61:59]    ; // 传入MCPLD 
assign i_pal_usb_rear_up_oc_n	         = bmccpld_to_mbcpld_s2p_data[58]       ; // 未使用
assign i_pal_usb_rear_down_oc_n			 = bmccpld_to_mbcpld_s2p_data[57]       ; // 未使用
assign i_vr_i2c_bmc_sel		             = bmccpld_to_mbcpld_s2p_data[56]       ; // 未使用
assign i_vr_i2c_bmc_oe_n		         = bmccpld_to_mbcpld_s2p_data[55]       ; // 未使用
assign i_peci_master_sel	             = bmccpld_to_mbcpld_s2p_data[54]       ; // 未使用
assign i_pal_program_n		             = bmccpld_to_mbcpld_s2p_data[53]       ; // 未使用
assign i_pal_bmc_tmp_alert_n		     = bmccpld_to_mbcpld_s2p_data[52]       ; // 未使用
assign i_pal_bmc_rst_ind_n		         = bmccpld_to_mbcpld_s2p_data[51]       ; // 未使用
assign i_pal_ifist_prsnt_n	             = bmccpld_to_mbcpld_s2p_data[50]       ; // 未使用
assign i_pal_health_fan_ctrl		     = bmccpld_to_mbcpld_s2p_data[49]       ; // 未使用
assign reserve_port1		             = bmccpld_to_mbcpld_s2p_data[48]       ; // 未使用
assign db_i_pal_pgd_p3v3		         = bmccpld_to_mbcpld_s2p_data[47]       ; // 传入MCPLD 0xA5
assign db_i_pal_pgd_p1v8		         = bmccpld_to_mbcpld_s2p_data[46]       ; // 传入MCPLD 0xA5
assign db_i_pal_pgd_p1v2	             = bmccpld_to_mbcpld_s2p_data[45]       ; // 传入MCPLD 0xA5
assign db_i_pal_pgd_p1v1		         = bmccpld_to_mbcpld_s2p_data[44]       ; // 传入MCPLD 0xA5
assign db_i_pal_pgd_p0v8		         = bmccpld_to_mbcpld_s2p_data[43]       ; // 传入MCPLD 0xA5
assign i_pal_wdt_rst_n_r		         = bmccpld_to_mbcpld_s2p_data[42]       ; // 传入MCPLD 0x0002[1]
assign cpld_date_mmdd	                 = bmccpld_to_mbcpld_s2p_data[41:26]    ; // 未使用
assign nc_port		                     = bmccpld_to_mbcpld_s2p_data[25]       ; // 未使用
assign reserve_port                      = bmccpld_to_mbcpld_s2p_data[24:21]    ; // 未使用
assign lattice_cpld	 	                 = bmccpld_to_mbcpld_s2p_data[20:17]    ; // 未使用 
assign bmc_cpld_version 	             = bmccpld_to_mbcpld_s2p_data[16:1]     ; // 传入MCPLD 0x00FA-0x00FB[7:0]
assign t4hz_clk_cmu	 	                 = bmccpld_to_mbcpld_s2p_data[0]        ; // 电灯 LED8

//MB CPLD ---> BMC CPLD
//assign mbcpld_to_bmccpld_p2s_data[27]  = pal_rtc_intb
assign mbcpld_to_bmccpld_p2s_data[27] 	 = rst_i2c0_mux_n;
assign mbcpld_to_bmccpld_p2s_data[26] 	 = 1'b1;//remote_xdp_pod_prsnt_n
assign mbcpld_to_bmccpld_p2s_data[25] 	 = 1'b1;//pal_usb2_ocpdbg_oc_n_r
assign mbcpld_to_bmccpld_p2s_data[24] 	 = 1'b1;//en_p3v3_stby_emmc 	            
assign mbcpld_to_bmccpld_p2s_data[23] 	 = 1'b0;//pal_p5v_vga_rear_en_r	        
assign mbcpld_to_bmccpld_p2s_data[22]    = usb_en[2];//pal_p5v_usb_rear_up_en_r         
assign mbcpld_to_bmccpld_p2s_data[21]    = usb_en[3];//pal_p5v_usb_rear_down_en_r
assign mbcpld_to_bmccpld_p2s_data[20]    = ~rom_bmc_bk_rst;
assign mbcpld_to_bmccpld_p2s_data[19]	 = ~rom_bmc_ma_rst;
assign mbcpld_to_bmccpld_p2s_data[18]    = pal_pwrgd_cpu0_lvc3_r;
assign mbcpld_to_bmccpld_p2s_data[17]    = 1'b1;//pal_bmc_uboot_en_n_r             
assign mbcpld_to_bmccpld_p2s_data[16]    = leakage_det_do_n;
assign mbcpld_to_bmccpld_p2s_data[15]    = 1'b1;//pal_plt_bmc_thermtrip_n_r        
assign mbcpld_to_bmccpld_p2s_data[14]    = st_steady_pwrok;//remote_xdp_syspwrok_r            
assign mbcpld_to_bmccpld_p2s_data[13:12] = uart_mux_select;//weihe
assign mbcpld_to_bmccpld_p2s_data[11:4]  = sw                                   ; // 传入BMCCPLD 拨码开关使用
assign mbcpld_to_bmccpld_p2s_data[3]     = 1'b1 /*DSD_UART_PRSNT_N*/            ; 
assign mbcpld_to_bmccpld_p2s_data[2]     = rst_pal_extrst_r_n                   ; // 传入BMCCPLD 复位使用
assign mbcpld_to_bmccpld_p2s_data[1]     = pal_vga_sel_n;
assign mbcpld_to_bmccpld_p2s_data[0]     = t4hz_clk;


//--------------------------------------------------------------------------------------------------------------------------------------------------
// SGPIO Moudule End
//--------------------------------------------------------------------------------------------------------------------------------------------------
wire i_PAL_RISER1_SS_DATA_IN = 1'b1;
wire i_PAL_RISER2_SS_DATA_IN = 1'b1;

//PVT
wire [5:0] mb1_pvti_ss_count;
wire [5:0] mb2_pvti_ss_count;
// wire [4:0] riser1_pvti_ss_count;
wire [4:0] riser2_pvti_ss_count;

//------------------------------------------------------------------------------
// RISER1 SGPIO SCAN CHAIN
//------------------------------------------------------------------------------
pvt_gpi #(
    .TOTAL_BIT_COUNT                (32                                     ),
    .DEFAULT_STATE                  (32'hFF_F3_FF_01                        ),             
    .NUMBER_OF_COUNTER_BITS         (5                                      )
) pvt_gpi_riser1_inst (
    .clk                            (clk_50m                                ),
    .reset_n                        (pon_reset_n & (~PAL_RISER1_PRSNT_N)    ),
    .clk_ena                        (t16us_tick                             ),
    .serclk_in                      (o_PAL_RISER1_SS_CLK                    ),
    .par_load_in_n                  (o_PAL_RISER1_SS_LD_N                   ),
    .sdi                            (i_PAL_RISER1_SS_DATA_IN                ),
    .bit_idx_in                     (riser1_pvti_ss_count                   ),
    .bit_idx_out                    (riser1_pvti_ss_count                   ),
    .serclk_out                     (o_PAL_RISER1_SS_CLK                    ),
    .par_load_out_n                 (o_PAL_RISER1_SS_LD_N                   ),
    .par_data                       ({riser1_pvti_byte3[7:0],riser1_pvti_byte2[7:0],riser1_pvti_byte1[7:0],riser1_pvti_byte0[7:0]})   			
);

assign riser1_cb_prsnt_slot1_n     = riser1_pvti_byte3[7];
assign riser1_cb_prsnt_slot2_n     = riser1_pvti_byte3[6];
assign riser1_cb_prsnt_slot3_n     = riser1_pvti_byte3[5];

assign riser1_pwr_det0             = riser1_pvti_byte2[5];
assign riser1_pwr_det1             = riser1_pvti_byte2[4];
assign riser1_pcb_rev0             = riser1_pvti_byte2[3];
assign riser1_pcb_rev1             = riser1_pvti_byte2[2];
assign riser1_pwr_alert_n          = riser1_pvti_byte2[1];
assign riser1_emc_alert_n          = riser1_pvti_byte2[0];

assign riser1_slot1_prsnt_n        = riser1_pvti_byte1[7];
assign riser1_slot2_prsnt_n        = riser1_pvti_byte1[6];
assign riser1_slot3_prsnt_n        = riser1_pvti_byte1[5];

assign riser1_id[0]                = riser1_pvti_byte0[7];
assign riser1_id[1]                = riser1_pvti_byte0[6];
assign riser1_id[2]                = riser1_pvti_byte0[5];
assign riser1_id[3]                = riser1_pvti_byte0[4];
assign riser1_id[4]                = riser1_pvti_byte0[3];
assign riser1_id[5]                = riser1_pvti_byte0[2];
assign pal_riser1_pwrgd            = riser1_pvti_byte0[1];
assign pal_riser1_pe_wake_n        = riser1_pvti_byte0[0];

//------------------------------------------------------------------------------
// RISER2 SGPIO SCAN CHAIN
//------------------------------------------------------------------------------
pvt_gpi #(
    .TOTAL_BIT_COUNT                (32),
    .DEFAULT_STATE                  (32'hFF_F3_FF_01), //32'hFF_F3_FF_01            
    .NUMBER_OF_COUNTER_BITS         (5)
) pvt_gpi_riser2_inst (
    .clk                            (clk_50m                                ),
    .reset_n                        (pon_reset_n & (~i_PAL_RISER2_PRSNT_N)  ),
    .clk_ena                        (t16us_tick                             ),
    .serclk_in                      (o_PAL_RISER2_SS_CLK                    ),
    .par_load_in_n                  (o_PAL_RISER2_SS_LD_N                   ),
    .sdi                            (i_PAL_RISER2_SS_DATA_IN                ),
    .bit_idx_in                     (riser2_pvti_ss_count                   ),
    .bit_idx_out                    (riser2_pvti_ss_count                   ),
    .serclk_out                     (o_PAL_RISER2_SS_CLK                    ),
    .par_load_out_n                 (o_PAL_RISER2_SS_LD_N                   ),
    .par_data                       ({riser2_pvti_byte3[7:0],riser2_pvti_byte2[7:0],riser2_pvti_byte1[7:0],riser2_pvti_byte0[7:0]})	               		
);

assign riser2_cb_prsnt_slot1_n     = riser2_pvti_byte3[7];
assign riser2_cb_prsnt_slot2_n     = riser2_pvti_byte3[6];
assign riser2_cb_prsnt_slot3_n     = riser2_pvti_byte3[5];

assign riser2_pwr_det0             = riser2_pvti_byte2[5];
assign riser2_pwr_det1             = riser2_pvti_byte2[4];
assign riser2_pcb_rev0             = riser2_pvti_byte2[3];
assign riser2_pcb_rev1             = riser2_pvti_byte2[2];
assign riser2_pwr_alert_n          = riser2_pvti_byte2[1];
assign riser2_emc_alert_n          = riser2_pvti_byte2[0];

assign riser2_slot1_prsnt_n        = riser2_pvti_byte1[7];
assign riser2_slot2_prsnt_n        = riser2_pvti_byte1[6];
assign riser2_slot3_prsnt_n        = riser2_pvti_byte1[5];

assign riser2_id[0]                = riser2_pvti_byte0[7];
assign riser2_id[1]                = riser2_pvti_byte0[6];
assign riser2_id[2]                = riser2_pvti_byte0[5];
assign riser2_id[3]                = riser2_pvti_byte0[4];
assign riser2_id[4]                = riser2_pvti_byte0[3];
assign riser2_id[5]                = riser2_pvti_byte0[2];
assign pal_riser2_pwrgd            = riser2_pvti_byte0[1];
assign pal_riser2_pe_wake_n        = riser2_pvti_byte0[0];


//------------------------------------------------------------------------------
// MAIN BOARD SGPIO
//------------------------------------------------------------------------------	
// CPU NVME 
assign cpu_nvme0_prsnt_n = i_CPU_NVME0_PRSNT_N;
assign cpu_nvme1_prsnt_n = i_CPU_NVME1_PRSNT_N;
// assign cpu_nvme2_prsnt_n = i_CPU_NVME2_PRSNT_N;
// assign cpu_nvme3_prsnt_n = i_CPU_NVME3_PRSNT_N;
assign cpu_nvme4_prsnt_n = i_CPU_NVME4_PRSNT_N;
assign cpu_nvme5_prsnt_n = i_CPU_NVME5_PRSNT_N;
assign cpu_nvme6_prsnt_n = i_CPU_NVME6_PRSNT_N;
assign cpu_nvme7_prsnt_n = i_CPU_NVME7_PRSNT_N;
// assign cpu_nvme8_prsnt_n = i_CPU_NVME8_PRSNT_N;
// assign cpu_nvme9_prsnt_n = i_CPU_NVME9_PRSNT_N;
assign cpu_nvme10_prsnt_n = i_CPU_NVME10_PRSNT_N;
assign cpu_nvme11_prsnt_n = i_CPU_NVME11_PRSNT_N;
// assign cpu_nvme12_prsnt_n = i_CPU_NVME12_PRSNT_N;
// assign cpu_nvme13_prsnt_n = i_CPU_NVME13_PRSNT_N;
assign cpu_nvme14_prsnt_n = i_CPU_NVME14_PRSNT_N;
assign cpu_nvme15_prsnt_n = i_CPU_NVME15_PRSNT_N;
assign cpu_nvme16_prsnt_n = i_CPU_NVME16_PRSNT_N;
assign cpu_nvme17_prsnt_n = i_CPU_NVME17_PRSNT_N;

// MCIO CABLE ID
assign cpu0_mcio0_cable_id0 = i_CPU0_MCIO0_CABLE_ID0_R;
assign cpu0_mcio0_cable_id1 = i_CPU0_MCIO0_CABLE_ID1_R;
// assign cpu0_mcio1_cable_id0 = i_CPU0_MCIO1_CABLE_ID0_R;
// assign cpu0_mcio1_cable_id1 = i_CPU0_MCIO1_CABLE_ID1_R;
assign cpu0_mcio2_cable_id0 = i_CPU0_MCIO2_CABLE_ID0_R;
assign cpu0_mcio2_cable_id1 = i_CPU0_MCIO2_CABLE_ID1_R;
assign cpu0_mcio3_cable_id0 = i_CPU0_MCIO3_CABLE_ID0_R;
assign cpu0_mcio3_cable_id1 = i_CPU0_MCIO3_CABLE_ID1_R;
assign cpu1_mcio0_cable_id0 = i_CPU1_MCIO0_CABLE_ID0_R;
assign cpu1_mcio0_cable_id1 = i_CPU1_MCIO0_CABLE_ID1_R;
// assign cpu1_mcio1_cable_id0 = i_CPU1_MCIO1_CABLE_ID0_R;
// assign cpu1_mcio1_cable_id1 = i_CPU1_MCIO1_CABLE_ID1_R;
assign cpu1_mcio2_cable_id0 = i_CPU1_MCIO2_CABLE_ID0_R;
assign cpu1_mcio2_cable_id1 = i_CPU1_MCIO2_CABLE_ID1_R;
assign cpu1_mcio3_cable_id0 = i_CPU1_MCIO3_CABLE_ID0_R;
assign cpu1_mcio3_cable_id1 = i_CPU1_MCIO3_CABLE_ID1_R;

// BOARD ID
assign board_id0            = i_BOARD_ID0;
assign board_id1            = i_BOARD_ID1;
// assign board_id2            = i_BOARD_ID2;
// assign board_id3            = i_BOARD_ID3;
assign board_id4            = i_BOARD_ID4;
assign board_id5            = i_BOARD_ID5;
assign board_id6            = i_BOARD_ID6;
assign board_id7            = i_BOARD_ID7;

assign pca_revision_2       = i_PCA_REVISION_2;
assign pca_revision_1       = i_PCA_REVISION_1;
assign pca_revision_0       = i_PCA_REVISION_0;
assign pcb_revision_1       = i_PCB_REVISION_1;
assign pcb_revision_0       = i_PCB_REVISION_0;

assign sw[0]                = i_SW_1           ;
assign sw[1]                = i_SW_2           ;
assign sw[2]                = i_SW_3           ;
assign sw[3]                = i_SW_4           ;
assign sw[4]                = i_SW_5           ;
assign sw[5]                = i_SW_6           ;
assign sw[6]                = i_SW_7           ;
assign sw[7]                = i_SW_8           ;


/*
pvt_gpi #(
	  .TOTAL_BIT_COUNT                (48                                     ),
	  .DEFAULT_STATE                  (48'h0                                  ),
	  .NUMBER_OF_COUNTER_BITS         (6                                      )
) pvt_gpi_mb1_inst (
	  .clk                            (clk_50m                                ),
	  .reset_n                        (pon_reset_n                            ),
	  .clk_ena                        (t16us_tick                             ),
	  .serclk_in                      (o_PVT_SS_CLK_R                         ),
	  .par_load_in_n                  (i_PVT_SS_LD_N_R                        ),
	  .sdi                            (i_PVT_SS_DATI                          ),
	  .bit_idx_in                     (mb1_pvti_ss_count                      ),
	  .bit_idx_out                    (mb1_pvti_ss_count                      ),
	  .serclk_out                     (o_PVT_SS_CLK_R                         ),
	  .par_load_out_n                 (i_PVT_SS_LD_N_R                        ),
	  .par_data                       (
                                       {cpu_nvme0_prsnt_n ,cpu_nvme1_prsnt_n ,cpu_nvme2_prsnt_n ,cpu_nvme3_prsnt_n ,
	                                   cpu_nvme4_prsnt_n ,cpu_nvme5_prsnt_n ,cpu_nvme6_prsnt_n ,cpu_nvme7_prsnt_n ,          //U10 DATA
  
					                   cpu_nvme10_prsnt_n,cpu_nvme11_prsnt_n,cpu_nvme12_prsnt_n,cpu_nvme13_prsnt_n,
					                   cpu_nvme14_prsnt_n,cpu_nvme15_prsnt_n,cpu_nvme16_prsnt_n,cpu_nvme17_prsnt_n,          //U22 DATA
  
					                   cpu0_mcio0_cable_id0,cpu0_mcio0_cable_id1,cpu0_mcio1_cable_id0,cpu0_mcio1_cable_id1,
					                   cpu0_mcio2_cable_id0,cpu0_mcio2_cable_id1,cpu0_mcio3_cable_id0,cpu0_mcio3_cable_id1,  //U157 DATA
  
					                   cpu0_mcio4_cable_id0,cpu0_mcio4_cable_id1,cpu0_mcio5_cable_id0,cpu0_mcio5_cable_id1,
					                   cpu1_mcio0_cable_id0,cpu1_mcio0_cable_id1,cpu1_mcio1_cable_id0,cpu1_mcio1_cable_id1,  //U212 DATA
  
					                   cpu1_mcio2_cable_id0,cpu1_mcio2_cable_id1,cpu1_mcio3_cable_id0,cpu1_mcio3_cable_id1,
					                   cpu1_mcio4_cable_id0,cpu1_mcio4_cable_id1,cpu1_mcio6_cable_id0,cpu1_mcio6_cable_id1,  //U213 DATA
  
					                   pal_bp1_prsnt_n     ,pal_bp2_prsnt_n     ,pal_bp3_prsnt_n     ,pal_bp4_prsnt_n     ,
					                   pal_bp5_prsnt_n     ,pal_bp6_prsnt_n     ,pal_bp7_prsnt_n     ,pal_bp8_prsnt_n       //U217 DATA
					                })					 
);
                
pvt_gpi #(
	  .TOTAL_BIT_COUNT(48),
	  .DEFAULT_STATE(48'h0),
	  .NUMBER_OF_COUNTER_BITS(6)
) pvt_gpi_mb2_inst (
	  .clk           (clk_50m),
	  .reset_n       (pon_reset_n),
	  .clk_ena       (t16us_tick),
	  .serclk_in     (o_PVT_SS_CLK_1_R),
	  .par_load_in_n (i_PVT_SS_LD_N_1_R),
	  .sdi           (i_PVT_SS_DATI_1),
	  .bit_idx_in    (mb2_pvti_ss_count),
	  .bit_idx_out   (mb2_pvti_ss_count),
	  .serclk_out    (i_PVT_SS_CLK_1_R),
	  .par_load_out_n(i_PVT_SS_LD_N_1_R),
	  .par_data      ({sw[0]           ,sw[1]           ,sw[2]           ,sw[3]           ,
	                   sw[4]           ,sw[5]           ,sw[6]           ,sw[7]           ,  //U180 DATA
					 			 
					          ocp_prsent_b7_n ,ocp_prsent_b6_n ,ocp_prsent_b5_n ,ocp_prsent_b4_n ,
					          ocp_prsent_b3_n ,ocp_prsent_b2_n ,ocp_prsent_b1_n ,ocp_prsent_b0_n,    //U181 DATA	

                              fan8_install_n,fan7_install_n,fan6_install_n,fan5_install_n,
					          fan4_install_n,fan3_install_n,fan2_install_n,fan1_install_n,          //U275 DATA
					 
					          pal_gpu_fan4_prsnt,pal_gpu_fan3_prsnt,pal_gpu_fan2_prsnt,pal_gpu_fan1_prsnt,
					          pal_gpu_fan4_foo,pal_gpu_fan3_foo,pal_gpu_fan2_foo,pal_gpu_fan1_foo,  //U276 DATA
					 
					          board_id7,board_id6,board_id5,board_id4,
					          board_id3,board_id2,board_id1,board_id0,                              //U277 DATA
					 					 					 
					          pca_revision_2,pca_revision_1,pca_revision_0,pcb_revision_1,
					          pcb_revision_0,cpu_nvme25_prsnt_n,cpu_nvme24_prsnt_n,cpu_nvme23_prsnt_n //U278 DATA                 				     
				           })					 
);             
*/  

//------------------------------------------------------------------------------
// OCP1 SGPIO SCAN CHAIN
//------------------------------------------------------------------------------
pvt_gpi #(
    .TOTAL_BIT_COUNT          (32                               ),
    .DEFAULT_STATE            (32'h7FFF_FFFE                    ),
    .NUMBER_OF_COUNTER_BITS   (6                                )
) pvt_gpi_ocp1_inst (
    .clk                      (clk_50m                          ),
    .reset_n                  (pon_reset_n & (~ocp1_prsnt_n)    ),
    .clk_ena                  (t16us_tick                       ),
    .serclk_in                (o_PAL_OCP1_SS_CLK_R              ),
    .par_load_in_n            (o_PAL_OCP1_SS_LD_N_R             ),
    .sdi                      (i_PAL_OCP1_SS_DATA_IN_R          ),
    .bit_idx_in               (ocp1_pvti_ss_count               ),
    .bit_idx_out              (ocp1_pvti_ss_count               ),
    .serclk_out               (o_PAL_OCP1_SS_CLK_R              ),
    .par_load_out_n           (o_PAL_OCP1_SS_LD_N_R             ),
    .par_data                 ({ocp1_pvti_byte3[7:0], ocp1_pvti_byte2[7:0],ocp1_pvti_byte1[7:0], ocp1_pvti_byte0[7:0]})
);

//------------------------------------------------------------------------------
// OCP2 SGPIO SCAN CHAIN
//------------------------------------------------------------------------------
pvt_gpi #(
    .TOTAL_BIT_COUNT          (32                               ),
    .DEFAULT_STATE            (32'h7FFF_FFFE                    ),
    .NUMBER_OF_COUNTER_BITS   (6                                )
) pvt_gpi_ocp2_inst (
    .clk                      (clk_50m                          ),
    .reset_n                  (pon_reset_n & (~ocp2_prsnt_n)    ),
    .clk_ena                  (t16us_tick                       ),
    .serclk_in                (o_PAL_OCP2_SS_CLK_R              ),
    .par_load_in_n            (o_PAL_OCP2_SS_LD_N_R             ),
    .sdi                      (i_PAL_OCP2_SS_DATA_IN_R          ),
    .bit_idx_in               (ocp2_pvti_ss_count               ),
    .bit_idx_out              (ocp2_pvti_ss_count               ),
    .serclk_out               (o_PAL_OCP2_SS_CLK_R              ),
    .par_load_out_n           (o_PAL_OCP2_SS_LD_N_R             ),
    .par_data                 ({ocp2_pvti_byte3[7:0], ocp2_pvti_byte2[7:0],ocp2_pvti_byte1[7:0], ocp2_pvti_byte0[7:0]})
);

assign ocp1_prsnt_n = ocp_prsent_b3_n & ocp_prsent_b2_n & ocp_prsent_b1_n & ocp_prsent_b0_n;
assign ocp2_prsnt_n = ocp_prsent_b4_n & ocp_prsent_b5_n & ocp_prsent_b6_n & ocp_prsent_b7_n;

assign w_pal_ocp1_prsnt_n = {ocp_prsent_b3_n,ocp_prsent_b2_n,ocp_prsent_b1_n,ocp_prsent_b0_n};
assign w_ocp1_x16_prsnt   = ((w_pal_ocp1_prsnt_n == 4'b0100)|(w_pal_ocp1_prsnt_n == 4'b0101)|(w_pal_ocp1_prsnt_n == 4'b0111)|(w_pal_ocp1_prsnt_n == 4'b1100)) ? 1'b1 : 1'b0;


//------------------------------------------------------------------------------
// I2C Update Start
//------------------------------------------------------------------------------
/*
wire wb_clk;
defparam inst_osch.NOM_FREQ = "4.29";
OSCH inst_osch(
.STDBY		(1'b0		),
.OSC		(wb_clk		),
.SEDSTDBY	(			)
);
I2C_UPDATE inst_i2c_update_flash_config(
.wb_clk_i	(wb_clk	),
.wb_rst_i	(		),
.wb_cyc_i	(		),
.wb_stb_i	(		),
.wb_we_i	(		),
.wb_adr_i	(		),
.wb_dat_i	(		),
.wb_dat_o	(		),
.wb_ack_o	(		),
.i2c1_irqo	(						),
.i2c1_scl	(BMC_I2C3_PAL_S_SCL_R	),
.i2c1_sda	(BMC_I2C3_PAL_S_SDA_R   )

); 
*/

//------------------------------------------------------------------------------
// LED BOARD CONTROL
//------------------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////////////////
//bmc active state
///////////////////////////////////////////////////////////////////////////////////
wire w_bmc_active1_n;

FanControl#
(
.FANNUMBER(1),
.TIME_OUT0(240),// common is 240s
.TIME_OUT1(10)  // common is 10s
) FanControl_m
(
.i_clk                 (clk_50m          ),//50MHz
.i_rst_n               (pon_reset_n      ),
.i_1uSCE               (t1us_tick        ),
.i_1000mSCE            (t1s_tick         ),                  
.i_heartbeat           (i_pal_wdt_rst_n_r),
.i_max_speed_ctrl      (8'd60            ),//can be decimal 60/65/70/75/80/85/90/95/100
.i_low_speed_pwr_on    (8'd10            ),//can be decimal 10/15/20/25/30/35/40/45/50/55/60
.i_fan_en_when_s5      (1'b1             ),      
.i_bmc_ctrl_when_s5    (1'b1             ),      
.i_pwr_on_st           (1'b1             ),      
.i_fan_speed_when_s5   (8'd10            ),//can be decimal 10/15/20/25/30/35/40/45/50/55/60
.i_rst_bmc_n           (1'b1             ),      
.o_bmc_active0_n       (                 ),//defaulte 0; bmc die:1; bmc actiev:0 ; related TIME_OUT0 
.o_bmc_active0_rst_n   (                 ),//defaulte 0; bmc die:1; bmc actiev:0 ; related TIME_OUT0 ; can be reset by i_rst_bmc_n
.o_wdt_override_pld_sel(                 ),//defaulte 0; bmc die:0; bmc actiev:1 ; related TIME_OUT1 
.o_bmc_active1_n       (w_bmc_active1_n  ),//defaulte 1; bmc die:1; bmc actiev:0 ; related TIME_OUT1 
.i_BMC_pwm             (1'b1             ),
.o_CPLD_pwm            (                 )
);

assign bmc_ready_flag = ~w_bmc_active1_n;


//PE WAKE
assign pfr_pe_wake_n = pal_pe_wake_n /*& i_PAL_RISER1_WAKE_N_R*/ ; 

//VGA
assign pal_vga_sel_n = vga2_dis ? 1'b1 : (db_front_vga_cable_prsnt_n);

//USB
assign o_PAL_UPD2_PERST_N_R   = reached_sm_wait_powerok ;
assign o_PAL_UPD1_PERST_N_R   = reached_sm_wait_powerok ;
assign o_PAL_UPD1_PONRST_N_R  = usb_ponrst_r_n          ;
assign o_PAL_UPD2_PONRST_N_R  = usb_ponrst_r_n          ;

assign pal_p3v3_stby_pgd      = i_CPLD_M_S_EXCHANGE_S1  ;
assign o_CPLD_M_S_EXCHANGE_S2 = i_PAL_PWR_SW_IN_N       ; 


//OCPm LOM
wire   db_i_lom_prsnt_n ; // 未使用
assign lom_thermal_trip     = ~db_i_lom_prsnt_n ? db_i_lom_fan_on_aux : 1'b0;//1:thermal trip;0:normal


//NCSI 
// assign o_PAL_OCP1_NCSI_EN_N_R      = ~pal_ocp1_ncsi_en  ; //J69
// assign o_PAL_OCP2_NCSI_EN_N_R      = ~pal_ocp2_ncsi_en  ; //J3 
// ??? 信号如何赋值 ???
assign o_PAL_WX1860_NCSI_SW_EN_N_R = ~pal_ocp_ncsi_sw_en; //J54
// ??? 信号如何赋值 ???
assign o_PAL_OCP_NCSI_SW_EN_N_R    = ~pal_ocp_ncsi_sw_en; //J53 


//LED
assign o_LED1_N               = ~power_seq_sm[0];
assign o_LED2_N               = ~power_seq_sm[1];
assign o_LED3_N               = ~power_seq_sm[2];
assign o_LED4_N               = ~power_seq_sm[3];
assign o_LED5_N               = ~power_seq_sm[4];
assign o_LED6_N               = ~power_seq_sm[5];
assign o_LED7_N               = bmc_extrst_uid  ;//1'b1            ;
assign o_LED8_N               = t4hz_clk_cmu    ;  

assign o_PAL_LED_HEL_GR_R     = sys_hlth_grn_blink_n  ;
assign o_PAL_LED_HEL_RED_R    = sys_hlth_red_blink_n  ;

// assign o_PAL_LED_NIC_ACT_R    = pal_led_nic_act      ;

//UART
assign o_JACK_CPU1_D0_UART_SOUT = i_CPU1_D0_UART_SOUT    ;
assign o_CPU1_D0_UART_SIN       = i_JACK_CPU1_D0_UART_SIN;
assign o_JACK_CPU1_UART1_TX     = i_CPU1_D0_UART1_TX     ;
assign o_CPU1_D0_UART1_RX       = i_JACK_CPU1_UART1_RX   ;


assign o_JACK_CPU0_D0_UART_SOUT = i_CPU0_D0_UART_SOUT    ;
assign o_CPU0_D0_UART_SIN       = i_JACK_CPU0_D0_UART_SIN;
assign o_JACK_CPU0_UART1_TX     = i_CPU0_D0_UART1_TX     ;
assign o_CPU0_D0_UART1_RX       = i_JACK_CPU0_UART1_RX   ;

assign o_PAL_BMC_UART1_RX       = i_CPU0_D0_UART1_TX     ;
assign o_JACK_CPU0_UART1_TX     = i_CPU0_D0_UART1_TX     ;
assign o_PAL_UART4_OCP2_TXD     = i_CPU0_D0_UART1_TX     ;

// assign o_CPU0_D0_UART1_RX       = (bmcctl_uart_sw == 2'b01) ? i_PAL_BMC_UART1_TX : i_JACK_CPU0_UART1_RX;
                                // (bmcctl_uart_sw == 2'b01) ? i_PAL_BMC_UART1_TX   :
                                // (bmcctl_uart_sw == 2'b10) ? i_PAL_UART4_OCP2_RXD : i_JACK_CPU0_UART1_RX;

// assign CPU0_D0_UART1_RX     = sw[7] ? JACK_CPU0_UART1_RX : PAL_BMC_UART1_TX;
// assign o_PAL_BMC_UART2_RX       = i_PAL_UART2_LCD_RX      ;
// assign o_PAL_UART2_LCD_TX       = i_PAL_BMC_UART2_TX      ;

assign o_PAL_UART4_OCP_DEBUG_TX = i_PAL_BMC_UART4_TX      ;
assign o_PAL_BMC_UART4_RX       = i_PAL_UART4_OCP_DEBUG_RX;

//UID
assign o_PAL_LED_UID_R          = ~led_uid             ;

//M.2
// assign PAL_M2_PERST_N_R         = pex_reset_n          ;
// assign PAL_88SE9230_RST_N_R     = pex_reset_n          ;

//Thermal Trip*/
assign cpu0_temp_over           = db_i_cpu0_d0_temp_over | db_i_cpu0_d1_temp_over /*| db_i_cpu0_d2_temp_over | db_i_cpu0_d3_temp_over*/;
assign cpu1_temp_over           = db_i_cpu1_d0_temp_over | db_i_cpu1_d1_temp_over /*| db_i_cpu1_d2_temp_over | db_i_cpu1_d3_temp_over*/;

//DDR5 SPD
assign o_PAL_CPU0_I3C_SPD_SEL       = cpu0_d0_bios_over ? 1'b0 : 1'b1;
assign o_PAL_CPU1_I3C_SPD_SEL       = cpu0_d0_bios_over ? 1'b0 : 1'b1;

//TPM
assign o_PAL_RST_TPM_N_R            = tpm_rst ? 1'b0 : reached_sm_wait_powerok;

//I2C MUX
assign o_RST_I2C3_MUX_N_R           = rst_i2c3_mux_n          ; 
assign o_RST_I2C13_MUX_N_R          = rst_i2c13_mux_n         ; 
assign o_RST_I2C1_MUX_N_R           = rst_i2c1_mux_n          ; 
assign o_RST_I2C4_2_MUX_N_R         = rst_i2c4_2_mux_n        ; 
assign o_RST_I2C8_MUX_N_R           = rst_i2c8_mux_n          ; 
assign o_RST_I2C2_MUX_N_R           = rst_i2c2_mux_n          ; 
assign o_RST_I2C5_MUX_N_R           = rst_i2c5_mux_n          ; 
assign o_RST_I2C12_MUX_N_R          = rst_i2c12_mux_n         ; 
assign o_RST_I2C11_MUX_N_R          = rst_i2c11_mux_n         ; 
assign o_RST_I2C4_1_MUX_N_R         = rst_i2c4_1_mux_n        ; 
assign o_RST_I2C_BMC_9548_MUX_N_R   = rst_i2c10_mux_n         ; 
//assign RST_I2C_RISER1_PCA9548_N_R = rst_i2c_riser1_pca9548_n;
//assign RST_I2C_RISER2_PCA9548_N_R = rst_i2c_riser2_pca9548_n;
assign o_CPU0_RISER1_9548_RST_N_R   = rst_i2c_riser1_pca9548_n;
assign o_CPU1_RISER2_9548_RST_N_R   = rst_i2c_riser2_pca9548_n;
//CLK BUFFER
// assign PAL_DB2000_3_OE_N_R = 1'b0;//VB CHANGE
// assign PAL_DB2000_2_OE_N_R = 1'b0;//VB CHANGE
// assign PAL_DB2000_2_OE12_N_R = 1'b0;//VB CHANGE
// assign PAL_DB2000_2_OE10_N_R = 1'b0;//VB CHANGE
// assign PAL_DB2000_3_OE12_N_R = 1'b0;//VB CHANGE
// assign PAL_DB2000_3_OE11_N_R = 1'b0;//VB CHANGE
// assign PAL_DB2000_2_OE5_N_R = 1'b0;
// assign PAL_DB2000_2_OE6_N_R = 1'b0;
// assign PAL_DB2000_3_OE6_N_R = 1'b0;
// assign PAL_DB2000_3_OE8_N_R = 1'b0;
// assign PAL_UPD1_P1V0_EN_R = 1'b1;
// assign PAL_CK440_OE0_N_R = 1'b0;
// assign PAL_CK440_OE1_N_R = 1'b0;
// assign PAL_DB2000_1_OE11_N_R = 1'b0;
// assign PAL_DB2000_1_OE10_N_R = 1'b0;
// assign PAL_DB2000_3_OE10_N_R = 1'b0;
// assign PAL_DB2000_3_OE7_N_R = 1'b0;
// assign PAL_DB2000_3_OE5_N_R = 1'b0;
// assign PAL_DB2000_3_OE9_N_R = 1'b0;
// assign PAL_DB2000_1_OE5_N_R = 1'b0;
// assign PAL_DB2000_1_OE6_N_R = 1'b0;
// assign PAL_DB2000_1_OE9_N_R = 1'b0;
// assign PAL_DB2000_2_OE9_N_R = 1'b0;

assign o_PAL_P1V1_STBY_EN_R       = p1v1_en_r        ;
assign o_PAL_M2_PWR_EN_R          = p3v3_en_r        ;
// assign o_P5V_USB2_LEFT_EAR_EN     = p5v_en_r         ; 
assign o_P5V_USB2_EN              = p5v_en_r         ;
assign o_PAL_P12V_STBY_EFUSE_EN_R = power_supply_on  ; 


//assign PAL_CK440_OE4_N_R = 1'b0;
//assign PAL_DB2000_1_OE12_N_R = 1'b0;
//assign PAL_DB2000_2_OE8_N_R = 1'b0;
//assign PAL_DB2000_2_OE11_N_R = 1'b0;
//assign PAL_CK440_OE6_N_R = 1'b0;
//assign PAL_DB2000_2_OE7_N_R = 1'b0;
//assign PAL_CK440_OE5_N_R = 1'b0;
//assign PAL_DB2000_1_OE7_N_R = 1'b0;
//assign PAL_CK440_OE3_N_R = 1'b0;
//assign PAL_CK440_OE2_N_R  = 1'b0;
assign PAL_USB2_L_REDRIVER_EN_R = 1'b1;
//assign PAL_DB2000_1_OE8_N_R  = 1'b0;

assign o_PAL_RISER4_PWR_EN_R     = 1'b1       ; // ???写死???
assign o_PAL_UPD1_P3V3_EN_R      = 1'b1       ; // ???写死???
assign o_PAL_UPD2_P3V3_EN_R      = 1'b1       ; // ???写死???
assign o_PAL_UPD1_P1V1_EN_R      = 1'b1       ; // ???写死???
assign o_PAL_UPD2_P1V1_EN_R      = 1'b1       ; // ???写死???

// assign PAL_M2_SEL_R            = 1'b1         ; // 不使用
// assign PAL_GPU_PWR_EN_R        = 1'b1         ; // 不使用
// assign PAL_OCP2_MAINPWR_ON_R   = 1'b1         ; // 不使用
// assign PAL_OCP2_FAN_PWR_EN_R   = 1'b1         ; // 不使用
assign o_PAL_TEST_BAT_EN       = test_bat_en  ; // 主CPLD addr 0x0008[7] 
// assign PAL_OCP2_AUXPWR_ON_R    = 1'b1         ; // 不使用
assign o_PAL_DB2000_1_PD_R     = 1'b1         ;
assign o_PAL_DB800_1_PD_R      = 1'b1         ;
// assign o_PAL_DB2000_2_PD_R     = 1'b1; // 不使用
// assign o_PAL_DB2000_3_PD_R     = 1'b1; // 不使用
assign o_PAL_SPI_SELECT_R      = ~rom_mux_bios_bmc_sel;
assign o_PAL_SPI_SWITCH_EN_R   = rom_mux_bios_bmc_en  ;
assign o_USB2_LCD_EN_R         = 1'b1                 ;//20240517 d00412 VB CHANGE
assign o_LEAR_USB3_1_EN_R      = 1'b1                 ;//20240518 d00412 VB CHANGE

assign o_PAL_DB800_1_OE_N_R    = 1'b1 ;
assign o_PAL_DB2000_1_OE_N_R   = 1'b1 ;
assign o_PAL_CK440_OE_N_R      = 1'b0 ; // ???是否打开???

// assign LEAR_USB3_2_EN_R        = 1'b1;//20240518 d00412 VB CHANGE
// assign PAL_UPD2_P1V0_EN        = 1'b1;//20240518 d00412 VB CHANGE
// assign o_M2_2_SW_SEL_R         = pal_m2_0_sel_lv33_r ? 1'b0 : 1'b1;//sw[0];//1'b1;//20240518 d00412 VB CHANGE
// assign o_M2_1_SW_SEL_R         = i_PAL_M2_1_SEL_R      ? 1'b0 : 1'b1;//sw[0];//20240518 d00412 VB CHANGE
assign o_PAL_GPU4_EFUSE_EN_R   = power_supply_on;//20240518 d00412 VB CHANGE

assign o_MCIO11_RISER1_PERST2_N    = reached_sm_wait_powerok;//20240518 d00412 VB CHANGE
assign o_PAL_RISER1_SLOT_PERST_N_R = reached_sm_wait_powerok;//20240518 d00412 VB CHANGE
assign o_PAL_RISER2_SLOT_PERST_N_R = reached_sm_wait_powerok;//20240518 d00412 VB CHANGE
assign o_PAL_M2_0_PERST_N_R        = reached_sm_wait_powerok;//20240518 d00412 VB CHANGE
assign o_PAL_M2_1_PERST_N_R        = reached_sm_wait_powerok;//20240518 d00412 VB CHANGE
//OCP
// wire ocp_aux_50ms_pgd;
wire ocp_main_en_dly50ms;
// wire ocp_aux_pgd;

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

// assign ocp_aux_50ms_pgd = (ocp_main_en_dly50ms)  ? db_i_pal_ocp2_pwrgd : 1'b1;
// assign ocp_aux_pgd      = (ocp_main_en		)       ? ocp_aux_50ms_pgd    : db_i_pal_ocp2_pwrgd;

assign o_PAL_OCP1_NCSI_CLK_50M_R   = i_PAL_BMC_NCSI_CLK_50M_R;
assign o_PAL_OCP_NCSI_CLK_50M_R    = i_PAL_BMC_NCSI_CLK_50M_R;
assign o_PAL_WX1860_NCSI_CLK_50M_R = i_PAL_BMC_NCSI_CLK_50M_R;

// assign o_PAL_OCP2_PERST1_N_R     = reached_sm_wait_powerok ; // 不使用
// assign o_PAL_OCP2_PERST0_N_R     = reached_sm_wait_powerok ; // 不使用
// assign o_PAL_OCP2_NCSI_CLK_50M_R = i_PAL_BMC_NCSI_CLK_50M_R; // 不使用
// assign o_PAL_OCP2_STBY_PWR_EN_R  = ocp_aux_en              ; // 不使用
// assign o_PAL_OCP2_MAIN_PWR_EN_R  = ocp_main_en             ; // 不使用
// assign o_PAL_OCP2_HP_SW_EN_R     = 1'b0                    ; // 不使用



// TPM
assign o_PAL_TPM_DRQ1_N  = 1'bz;


//------------------------------------------------------------------------------
// POWER Sequence  Start
//------------------------------------------------------------------------------
assign st_reset_state       = (power_seq_sm == 6'h00);
assign st_off_standby       = (power_seq_sm == 6'h05);
assign st_steady_pwrok      = (power_seq_sm == 6'h11);
assign st_halt_power_cycle  = (power_seq_sm == 6'h2A);
assign st_aux_fail_recovery = (power_seq_sm == 6'h2C);


//BMC

assign uart_mux_select[1]      = 1'b0;//0:DSD Presnt;1:DSD not Presnt
assign uart_mux_select[0]      = bmcctl_uart_sw_en ? bmcctl_uart_sw : ((~sw[7]) ? sw[1] : 1'b1);
assign mb_cpld2_ver            = 16'h01A1;

//assign PAL_I2C_VPP_RISER1_SLOT_R = power_supply_on;
//assign PAL_I2C_VPP_RISER2_SLOT_R = power_supply_on;
//------------------------------------------------------------------------------
//BIOS Xregs Start
//------------------------------------------------------------------------------
wire [7:0]                      reg_addr            ;
wire [7:0]                      rdata               ;
wire [7:0]                      wrdata              ;
wire                            wrdata_en           ;

wire [3:0]                      mb_cb1_cable_id     ;
wire [3:0]                      mb_cb2_cable_id     ;

I2C_SLAVE_INF #(.I2C_ADR(8'h60)) inst_i2c_inf (
    .rst_n                    (pon_reset_n                  ),
    .sys_clk                  (clk_50m                      ),
    .scl                      (i_CPU0_D0_I2C1_PE_STRAP_SCL  ),
    .sda                      (io_CPU0_D0_I2C1_PE_STRAP_SDA ),
    .reg_addr                 (reg_addr                     ),
    .rdata                    (rdata                        ),
    .wrdata_en                (wrdata_en                    ),
    .wrdata                   (wrdata                       )
);

wire [15:0] o_mb_cb_prsnt_bios;
I2C_SLAVE_REG inst_i2c_bios_reg (
    //system interface
    .rc_reset_n               (pon_reset_n                  ),//in 
    //.sys_reset_n            (pon_reset_n                  ),//in 
    .clk                      (clk_50m                      ),//in
    //I2C interface  
    .reg_addr                 (reg_addr                     ),//in
    .rdata                    (rdata                        ),//output
    .wrdata_en                (wrdata_en                    ),//in
    .wrdata                   (wrdata                       ),//in
    .test_pin                 (                             ),//output
    .o_usb_en                 (usb_en                       ),//output 0x00
    .o_bios_read_rtc          (bios_read_rtc[7:0]           ),//output 0x0C
    .o_bios_post_80           (bios_post_code               ),//output  post_80
    .o_bios_post_84           (bios_post_rate               ),//output  post_84
    .o_bios_post_85           (bios_post_phase              ),//output  post_85
    .o_mb_cb_prsnt            (o_mb_cb_prsnt_bios           ),//output 0x2A,0x2C   
    .reg1_special_confi       (8'h00                        ),//in 0x29[7:0]
    .riser_ocp_m2_slot_number (riser_ocp_m2_slot_number     ),//in 0x32[2:0],0x31[7:0],0x30[7:0]
    .nvme_slot_number         (nvme_slot_number             ),//in 0x37[6:0],0x36[7:0],0x35[7:0],0x34[7:0],0x33[7:0],0x32[7:3]

    .i_i2c_ram_60             (8'hff                        ),//CPU0 DIE0-L J1
    .i_i2c_ram_61             (8'hff                        ),//CPU0 DIE0-H J1
    .i_i2c_ram_62             (mcio11_slot_id               ),//CPU0 DIE1-L J29
    .i_i2c_ram_63             (mcio4_slot_id                ),//CPU0 DIE1-H J16
    .i_i2c_ram_64             (mcio0_slot_id                ),//CPU0 DIE2-L J18
    .i_i2c_ram_65             (mcio1_slot_id                ),//CPU0 DIE2-H J17
    .i_i2c_ram_66             (mcio2_slot_id                ),//CPU0 DIE3-L J20
    .i_i2c_ram_67             (mcio3_slot_id                ),//CPU0 DIE3-H J19
    .i_i2c_ram_68             (mcio10_slot_id               ),//CPU1 DIE0-L J74
    .i_i2c_ram_69             (mcio9_slot_id                ),//CPU1 DIE0-H J25
    .i_i2c_ram_6A             (8'hff                        ),//CPU1 DIE1-L J39
    .i_i2c_ram_6B             (8'hff                        ),//CPU1 DIE1-H J39
    .i_i2c_ram_6C             (mcio5_slot_id                ),//CPU1 DIE2-L J21
    .i_i2c_ram_6D             (mcio6_slot_id                ),//CPU1 DIE2-H J22
    .i_i2c_ram_6E             (mcio7_slot_id                ),//CPU1 DIE3-L J23
    .i_i2c_ram_6F             (mcio8_slot_id                ),//CPU1 DIE3-H J24

    .i_i2c_ram_70             (i2c_ram_1050                 ),//RISER
    .i_i2c_ram_71             (i2c_ram_1051                 ),//RISER
    .i_i2c_ram_72             (i2c_ram_1052                 ),//RISER
    .i_i2c_ram_73             (i2c_ram_1053                 ),//RISER
    .i_i2c_ram_74             (i2c_ram_1054                 ),//RISER
    .i_i2c_ram_75             (i2c_ram_1055                 ),//BP
    .i_i2c_ram_76             (i2c_ram_1056                 ),//BP
    .i_i2c_ram_77             (i2c_ram_1057                 ),//BP
    .i_i2c_ram_78             (i2c_ram_1058                 ),//BP

    .cpu0_mcio0_cable_id0     (cpu0_mcio0_cable_id0         ),//CPU0 DIE2-L--J18
    .cpu0_mcio0_cable_id1     (cpu0_mcio0_cable_id1         ),
    // .cpu0_mcio1_cable_id0     (cpu0_mcio1_cable_id0         ),//CPU0 DIE2-H--J17
    // .cpu0_mcio1_cable_id1     (cpu0_mcio1_cable_id1         ),
    .cpu0_mcio2_cable_id0     (cpu0_mcio2_cable_id0         ),//CPU0 DIE3-L--J20
    .cpu0_mcio2_cable_id1     (cpu0_mcio2_cable_id1         ),
    .cpu0_mcio3_cable_id0     (cpu0_mcio3_cable_id0         ),//CPU0 DIE3-H--J19
    .cpu0_mcio3_cable_id1     (cpu0_mcio3_cable_id1         ),
    .cpu0_mcio4_cable_id0     (cpu0_mcio4_cable_id0         ),//CPU0 DIE1-H--J16
    .cpu0_mcio4_cable_id1     (cpu0_mcio4_cable_id1         ),
    .cpu0_mcio5_cable_id0     (cpu0_mcio5_cable_id0         ),//CPU0 DIE1-L--J29
    .cpu0_mcio5_cable_id1     (cpu0_mcio5_cable_id1         ),
    .cpu1_mcio0_cable_id0     (cpu1_mcio0_cable_id0         ),//CPU1 DIE2-L--J21
    .cpu1_mcio0_cable_id1     (cpu1_mcio0_cable_id1         ),
    // .cpu1_mcio1_cable_id0     (cpu1_mcio1_cable_id0         ),//CPU1 DIE2-H--J22
    // .cpu1_mcio1_cable_id1     (cpu1_mcio1_cable_id1         ),
    .cpu1_mcio2_cable_id0     (cpu1_mcio2_cable_id0         ),//CPU1 DIE3-L--J23
    .cpu1_mcio2_cable_id1     (cpu1_mcio2_cable_id1         ),
    .cpu1_mcio3_cable_id0     (cpu1_mcio3_cable_id0         ),//CPU1 DIE3-H--J24
    .cpu1_mcio3_cable_id1     (cpu1_mcio3_cable_id1         ),
    .cpu1_mcio4_cable_id0     (cpu1_mcio4_cable_id0         ),//CPU1 DIE0-H--J25
    .cpu1_mcio4_cable_id1     (cpu1_mcio4_cable_id1         ),
    .cpu1_mcio6_cable_id0     (cpu1_mcio6_cable_id0         ),//CPU1 DIE0-L--J74
    .cpu1_mcio6_cable_id1     (cpu1_mcio6_cable_id1         ),

    .pal_mcio11_cable_id1     (mb_cb1_cable_id[3]           ),//CPU0 DIE0-H--J1
    .pal_mcio11_cable_id0     (mb_cb1_cable_id[2]           ),
    .pal_mcio12_cable_id1     (mb_cb1_cable_id[1]           ),//CPU0 DIE0-L--J1
    .pal_mcio12_cable_id0     (mb_cb1_cable_id[0]           ),
    .pal_mcio15_cable_id1     (mb_cb2_cable_id[3]           ),//CPU1 DIE1-H--J39
    .pal_mcio15_cable_id0     (mb_cb2_cable_id[2]           ),
    .pal_mcio16_cable_id1     (mb_cb2_cable_id[1]           ),//CPU1 DIE1-L--J39
    .pal_mcio16_cable_id0     (mb_cb2_cable_id[0]           ),

    .i_ocp1_x16_or_x8         (w_ocp1_x16_prsnt             ),
    .ocp1_prsnt_n             (~ocp1_prsnt_n                ),
    .ocp2_prsnt_n             (~ocp2_prsnt_n                ),

    .board_id                 (5'h01                        ),//in 0xC6[4:0]    //5'b00011
    .chassis_id               (3'b010                       ),//in 0xC7[2:0]    //2U 3'b010
    .pca_rev                  ({pca_revision_2,pca_revision_1,pca_revision_0}),//in 0xF4[7:3]
    .pcb_rev                  ({pcb_revision_1,pcb_revision_0}),//in 0xF4[2:0]
    .bios_security_bypass     (bios_security_bypass         ),//in 0x10[0]
    .bmc_read_flag            (bmc_read_flag                ),//in 0x11[0]
    .sw                       (~sw[7:0]                     )//in 0x18[7:0]
);


assign bios_read_flag = bios_read_rtc[0];
assign mb_cb_prsnt = (debug_reg_15[1:0] == 2'b11) ? o_mb_cb_prsnt_bmc : o_mb_cb_prsnt_bios;

assign mb_cb1_cable_id = i_MB_CB_RISER1_PRSNT0_N ? 4'b0000 : (i_PAL_RISER1_MODE_R ? 4'b0000 : (i_PAL_RISER1_WIDTH_R ? 4'b1111:4'b0101));
assign mb_cb2_cable_id = i_MB_CB_RISER2_PRSNT0_N ? 4'b0000 : (i_PAL_RISER2_MODE_R ? 4'b0000 : (i_PAL_RISER2_WIDTH_R ? 4'b1111:4'b0101));


///------------------------------------------------/////////
//VMD_ON/OFF    VPP_ADDR    SLOT_ID    BOARD_PRSNT
///------------------------------------------------////////

wire[15:0]w_mb_to_bp_mcio0_data;
wire[15:0]w_mb_to_bp_mcio1_data;
wire[15:0]w_mb_to_bp_mcio2_data;
wire[15:0]w_mb_to_bp_mcio3_data;
wire[15:0]w_mb_to_bp_mcio4_data;
wire[15:0]w_mb_to_bp_mcio5_data;
wire[15:0]w_mb_to_bp_mcio6_data;
wire[15:0]w_mb_to_bp_mcio7_data;
wire[15:0]w_mb_to_bp_mcio8_data;
wire[15:0]w_mb_to_bp_mcio9_data;
wire[15:0]w_mb_to_bp_mcio10_data;
wire[15:0]w_mb_to_bp_mcio11_data;

wire[15:0]w_bp_to_mb_mcio0_data;
wire[15:0]w_bp_to_mb_mcio1_data;
wire[15:0]w_bp_to_mb_mcio2_data;
wire[15:0]w_bp_to_mb_mcio3_data;
wire[15:0]w_bp_to_mb_mcio4_data;
wire[15:0]w_bp_to_mb_mcio5_data;
wire[15:0]w_bp_to_mb_mcio6_data;
wire[15:0]w_bp_to_mb_mcio7_data;
wire[15:0]w_bp_to_mb_mcio8_data;
wire[15:0]w_bp_to_mb_mcio9_data;
wire[15:0]w_bp_to_mb_mcio10_data;
wire[15:0]w_bp_to_mb_mcio11_data;

wire w_pal_mcio11_pwr_en;
wire w_pal_mcio4_pwr_en;
wire w_pal_mcio0_pwr_en;
wire w_pal_mcio1_pwr_en;
wire w_pal_mcio2_pwr_en;
wire w_pal_mcio3_pwr_en;
wire w_pal_mcio9_pwr_en;
wire w_pal_mcio10_pwr_en;
wire w_pal_mcio6_pwr_en;
wire w_pal_mcio5_pwr_en;
wire w_pal_mcio8_pwr_en;
wire w_pal_mcio7_pwr_en;


wire[5:0]w_mcio_rsvd_bit15_10;
wire[2:0]w_mcio_rsvd_bit7_5;
wire[3:0]w_mcio_vpp_addr_bit4_1;

assign w_mcio_rsvd_bit15_10   = 6'b0;
assign w_mcio_rsvd_bit7_5     = 3'b100;
assign w_mcio_vpp_addr_bit4_1 = 4'b0000;

assign w_mb_to_bp_mcio0_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio0_pwr_en};
assign w_mb_to_bp_mcio1_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio1_pwr_en};
assign w_mb_to_bp_mcio2_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio2_pwr_en};
assign w_mb_to_bp_mcio3_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio3_pwr_en};
assign w_mb_to_bp_mcio4_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio4_pwr_en};
assign w_mb_to_bp_mcio5_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio5_pwr_en};
assign w_mb_to_bp_mcio6_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio6_pwr_en};
assign w_mb_to_bp_mcio7_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio7_pwr_en};
assign w_mb_to_bp_mcio8_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio8_pwr_en};
assign w_mb_to_bp_mcio9_data  = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio9_pwr_en};
assign w_mb_to_bp_mcio10_data = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio10_pwr_en};
assign w_mb_to_bp_mcio11_data = {w_mcio_rsvd_bit15_10,2'b0,w_mcio_rsvd_bit7_5,w_mcio_vpp_addr_bit4_1,w_pal_mcio11_pwr_en};

assign mcio0_slot_id  = w_bp_to_mb_mcio0_data[7:0];
assign mcio1_slot_id  = w_bp_to_mb_mcio1_data[7:0];
assign mcio2_slot_id  = w_bp_to_mb_mcio2_data[7:0];
assign mcio3_slot_id  = w_bp_to_mb_mcio3_data[7:0];
assign mcio4_slot_id  = w_bp_to_mb_mcio4_data[7:0];
assign mcio5_slot_id  = w_bp_to_mb_mcio5_data[7:0];
assign mcio6_slot_id  = w_bp_to_mb_mcio6_data[7:0];
assign mcio7_slot_id  = w_bp_to_mb_mcio7_data[7:0];
assign mcio8_slot_id  = w_bp_to_mb_mcio8_data[7:0];
assign mcio9_slot_id  = w_bp_to_mb_mcio9_data[7:0];
assign mcio10_slot_id = w_bp_to_mb_mcio10_data[7:0];
assign mcio11_slot_id = w_bp_to_mb_mcio11_data[7:0];

assign w_pal_mcio11_pwr_en = pal_bp_efuse_pg;
assign w_pal_mcio4_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio0_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio1_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio2_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio3_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio9_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio10_pwr_en = pal_bp_efuse_pg;
assign w_pal_mcio6_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio5_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio7_pwr_en  = pal_bp_efuse_pg;
assign w_pal_mcio8_pwr_en  = pal_bp_efuse_pg;
//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU0 DIE1-L --> J29    MCIO10
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u1 (
    .clk             (clk_50m               ),//input
    .rst             (~pon_reset_n          ),//input
    .tick            (t16us_tick            ),//input
    .send_enable     (1'b1                  ),//input
    .t128ms_tick     (t128ms_tick           ),//input
    .par_data_in     (w_mb_to_bp_mcio11_data),//input 
    .par_data_out    (w_bp_to_mb_mcio11_data),//output
    .ser_data        (io_MCIO_PWR_EN11_R       ),//inout
    .riser_en_out    (w_pal_mcio11_pwr_en   ),//input
    .mcio_cable_id0  (cpu0_mcio5_cable_id0  ),//input
    .mcio_cable_id1  (cpu0_mcio5_cable_id1  ),//input
    .error_flag      (                      ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU0 DIE1-H  --> J16    MCIO4
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u2 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio4_data),//input 
	.par_data_out    (w_bp_to_mb_mcio4_data),//output
	.ser_data        (io_MCIO_PWR_EN4_R       ),//inout
    .riser_en_out    (w_pal_mcio4_pwr_en   ),//input
	.mcio_cable_id0  (cpu0_mcio4_cable_id0 ),//input
	.mcio_cable_id1  (cpu0_mcio4_cable_id1 ),//input
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU0 DIE2-L  --> J18    MCIO0
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u3 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio0_data),//input 
	.par_data_out    (w_bp_to_mb_mcio0_data),//output
	.ser_data        (io_MCIO_PWR_EN0_R    ),//inout
    .riser_en_out    (w_pal_mcio0_pwr_en   ),//input
	.mcio_cable_id0  (cpu0_mcio0_cable_id0 ),//input
	.mcio_cable_id1  (cpu0_mcio0_cable_id1 ),//input
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU0 DIE2-H  --> J17    MCIO1
// -------------------------------------------------------------------------------------------------------------------------------------------------
/*
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u4 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio1_data),//input 
	.par_data_out    (w_bp_to_mb_mcio1_data),//output
	.ser_data        (io_MCIO_PWR_EN1_R       ),//inout
    .riser_en_out    (w_pal_mcio1_pwr_en   ),//input
	.mcio_cable_id0  (cpu0_mcio1_cable_id0 ),//input
	.mcio_cable_id1  (cpu0_mcio1_cable_id1 ),//input
	.error_flag      (                     ) //output
);
*/

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU0 DIE3-H  --> J19    MCIO3
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u5 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio3_data),//input 
	.par_data_out    (w_bp_to_mb_mcio3_data),//output
	.ser_data        (io_MCIO_PWR_EN3_R       ),//inout
    .riser_en_out    (w_pal_mcio3_pwr_en   ),//input
	.mcio_cable_id0  (cpu0_mcio3_cable_id0 ),//input
	.mcio_cable_id1  (cpu0_mcio3_cable_id1 ),//input
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU0 DIE3-L  --> J20    MCIO2
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u6 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio2_data),//input 
	.par_data_out    (w_bp_to_mb_mcio2_data),//output
	.ser_data        (io_MCIO_PWR_EN2_R       ),//inout
    .riser_en_out    (w_pal_mcio2_pwr_en   ),//input
	.mcio_cable_id0  (cpu0_mcio2_cable_id0 ),//input
	.mcio_cable_id1  (cpu0_mcio2_cable_id1 ),//input
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU1 DIE0-H  --> J25    MCIO9
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u7 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio9_data),//input 
	.par_data_out    (w_bp_to_mb_mcio9_data),//output
	.ser_data        (io_MCIO_PWR_EN9_R       ),//inout
    .riser_en_out    (w_pal_mcio9_pwr_en   ),//input
	.mcio_cable_id0  (cpu1_mcio4_cable_id0 ),//input
	.mcio_cable_id1  (cpu1_mcio4_cable_id1 ),//input
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU1 DIE0-L  --> J74    MCIO10
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u8 (
	.clk             (clk_50m               ),//input
	.rst             (~pon_reset_n          ),//input
	.tick            (t16us_tick            ),//input
	.send_enable     (1'b1                  ),//input
    .t128ms_tick     (t128ms_tick           ),//input
	.par_data_in     (w_mb_to_bp_mcio10_data),//input 
	.par_data_out    (w_bp_to_mb_mcio10_data),//output
	.ser_data        (io_MCIO_PWR_EN10_R       ),//inout
    .riser_en_out    (w_pal_mcio10_pwr_en   ),//input
	.mcio_cable_id0  (cpu1_mcio6_cable_id0 ),//input
	.mcio_cable_id1  (cpu1_mcio6_cable_id1 ),//input
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU1 DIE2-H  --> J22    MCIO6
// -------------------------------------------------------------------------------------------------------------------------------------------------
/*
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u9 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio6_data),//input 
	.par_data_out    (w_bp_to_mb_mcio6_data),//output
	.ser_data        (io_MCIO_PWR_EN6_R       ),//inout
    .riser_en_out    (w_pal_mcio6_pwr_en   ),//input
	.mcio_cable_id0  (cpu1_mcio1_cable_id0 ),//input
	.mcio_cable_id1  (cpu1_mcio1_cable_id1 ),//input
	.error_flag      (                     ) //output
);
*/

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU1 DIE2-L  --> J21    MCIO5
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u10 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio5_data),//input 
	.par_data_out    (w_bp_to_mb_mcio5_data),//output
	.ser_data        (io_MCIO_PWR_EN5_R       ),//inout
    .riser_en_out    (w_pal_mcio5_pwr_en   ),//input
	.mcio_cable_id0  (cpu1_mcio0_cable_id0 ),//input
	.mcio_cable_id1  (cpu1_mcio0_cable_id1 ),//input
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU1 DIE3-H  --> J24    MCIO8
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u11 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio8_data),//input 
	.par_data_out    (w_bp_to_mb_mcio8_data),//output
	.ser_data        (io_MCIO_PWR_EN8_R       ),//inout
    .riser_en_out    (w_pal_mcio8_pwr_en   ),//input
	.mcio_cable_id0  (cpu1_mcio3_cable_id0 ),//input
	.mcio_cable_id1  (cpu1_mcio3_cable_id1 ),//input 
	.error_flag      (                     ) //output
);

//--------------------------------------------------------------------------------------------------------------------------------------------------
//VMD ON_OFF FOR CPU1 DIE3-L  --> J23    MCIO7
// -------------------------------------------------------------------------------------------------------------------------------------------------
UART_MASTER #(.NBIT_IN(16), .NBIT_OUT(16), .BPS_COUNT_NUM(48), .START_COUNT_NUM(24)) uart_master_u12 (
	.clk             (clk_50m              ),//input
	.rst             (~pon_reset_n         ),//input
	.tick            (t16us_tick           ),//input
	.send_enable     (1'b1                 ),//input
    .t128ms_tick     (t128ms_tick          ),//input
	.par_data_in     (w_mb_to_bp_mcio7_data),//input 
	.par_data_out    (w_bp_to_mb_mcio7_data),//output
	.ser_data        (io_MCIO_PWR_EN7_R       ),//inout
    .riser_en_out    (w_pal_mcio7_pwr_en   ),//input
	.mcio_cable_id0  (cpu1_mcio2_cable_id0 ),//input
	.mcio_cable_id1  (cpu1_mcio2_cable_id1 ),//input 
	.error_flag      (                     ) //output
);


/*G6 4GPU RS36RX16 SLOT号分配需要特殊适配，该RISER可插在RISER1/2槽位上，但该RISER的SLOT分配�/11/12，或者是6/13/14，即不是常规�/2/3,该RISER_ID=001010*/
assign w4GpuRiser1Flag  = (riser1_id == 6'b001010) ? 1'b1 : 1'b0 ;
assign w4GpuRiser2Flag  = (riser2_id == 6'b001010) ? 1'b1 : 1'b0 ;

//配置检测结果寄存器
//Slot1-6                                                                                                                                                                               
assign riser_ocp_m2_slot_number[5:0] = (w4GpuRiser1Flag && w4GpuRiser2Flag ) ? {(~mb_cb_prsnt[11])&(~mb_cb_prsnt[10]),2'b11,(~mb_cb_prsnt[0])&(~mb_cb_prsnt[1]),2'b11                              }:
                                       (w4GpuRiser1Flag && ~w4GpuRiser2Flag) ? {riser2_cb_prsnt_slot3_n,riser2_cb_prsnt_slot2_n,riser2_cb_prsnt_slot1_n,(~mb_cb_prsnt[0])&(~mb_cb_prsnt[1]),2'b11  }:
                                       (~w4GpuRiser1Flag&& w4GpuRiser2Flag ) ? {(~mb_cb_prsnt[11])&(~mb_cb_prsnt[10]),2'b11,riser1_cb_prsnt_slot3_n,riser1_cb_prsnt_slot2_n,riser1_cb_prsnt_slot1_n}:
                                       {riser2_cb_prsnt_slot3_n,riser2_cb_prsnt_slot2_n,riser2_cb_prsnt_slot1_n,riser1_cb_prsnt_slot3_n,riser1_cb_prsnt_slot2_n,riser1_cb_prsnt_slot1_n            };

//assign riser_ocp_m2_slot_number[5:0] = {riser2_cb_prsnt_slot3_n,riser2_cb_prsnt_slot2_n,riser2_cb_prsnt_slot1_n,riser1_cb_prsnt_slot3_n,riser1_cb_prsnt_slot2_n,riser1_cb_prsnt_slot1_n};
/*
(w4GpuRiser1Flag && w4GpuRiser2Flag ) ? {(~mb_cb_prsnt[13])&(~mb_cb_prsnt[12]),2'b11,(~mb_cb_prsnt[6])&(~mb_cb_prsnt[7]),2'b11                              }:
(w4GpuRiser1Flag && ~w4GpuRiser2Flag) ? {riser2_cb_prsnt_slot3_n,riser2_cb_prsnt_slot2_n,riser2_cb_prsnt_slot1_n,(~mb_cb_prsnt[6])&(~mb_cb_prsnt[7]),2'b11  }:
(~w4GpuRiser1Flag&& w4GpuRiser2Flag ) ? {(~mb_cb_prsnt[13])&(~mb_cb_prsnt[12]),2'b11,riser1_cb_prsnt_slot3_n,riser1_cb_prsnt_slot2_n,riser1_cb_prsnt_slot1_n}:
{riser2_cb_prsnt_slot3_n,riser2_cb_prsnt_slot2_n,riser2_cb_prsnt_slot1_n,riser1_cb_prsnt_slot3_n,riser1_cb_prsnt_slot2_n,riser1_cb_prsnt_slot1_n            };
*/

//Slot7

//assign riser_ocp_m2_slot_number[6]   = mb_cb_prsnt[8] ? ~(j74_device_type == `MCIO_RS46RX8R ) : 1'b1;                                                                                          
//Slot8                                                                                        
//assign riser_ocp_m2_slot_number[7]   = mb_cb_prsnt[9] ? ~(j25_device_type == `MCIO_RS46RX8R ) : 1'b1;
//Slot9                                                                                        
//assign riser_ocp_m2_slot_number[8]   = mb_cb_prsnt[12] ? ~((j21_device_type == `MCIO_RS46RX8RA) || (j21_device_type == `MCIO_RS46RX16RA)) : 
                                       //mb_cb_prsnt[13] ? ~(j22_device_type == `MCIO_RS46RX16RA)                                           :1'b1;   
//Slot10                                                                                               
//assign riser_ocp_m2_slot_number[9]   = mb_cb_prsnt[13] ? ~(j22_device_type == `MCIO_RS46RX8RA) :
                                       //mb_cb_prsnt[8] ? ~(j74_device_type == `MCIO_RS46RX16R) :
                                       //mb_cb_prsnt[9] ? ~(j25_device_type == `MCIO_RS46RX16R) :1'b1;      
//Slot11-15
assign riser_ocp_m2_slot_number[11]  = mb_cb_prsnt[6]  ? ~w4GpuRiser1Flag :
                                       mb_cb_prsnt[7]  ? ~w4GpuRiser1Flag : 1'b1;
assign riser_ocp_m2_slot_number[10]  = mb_cb_prsnt[4]  ? ~w4GpuRiser1Flag :
                                       mb_cb_prsnt[5]  ? ~w4GpuRiser1Flag : 1'b1;                                                                                  

assign riser_ocp_m2_slot_number[13]  = mb_cb_prsnt[14]  ? ~w4GpuRiser2Flag :
                                       mb_cb_prsnt[15]  ? ~w4GpuRiser2Flag : 1'b1;
assign riser_ocp_m2_slot_number[12]  = mb_cb_prsnt[12] ? ~w4GpuRiser2Flag :
                                       mb_cb_prsnt[13] ? ~w4GpuRiser2Flag : 1'b1;    
                                                                                         
assign riser_ocp_m2_slot_number[14]  = 1'b1;
                                                                                         
//Slot16
// assign riser_ocp_m2_slot_number[15]  = mb_cb_prsnt[2]     ? ~(MB_CB_MCIO_OCP1_1 == 1'b0) :
//                                       mb_cb_prsnt[3]     ? ~(MB_CB_MCIO_OCP1_2 == 1'b0) : 1'b1;
/*
assign riser_ocp_m2_slot_number[15]  = mb_cb_prsnt[2]     ? ~(j29_device_type == `MCIO_OCP) :
                                       mb_cb_prsnt[3]     ? ~(j16_device_type == `MCIO_OCP) : 1'b1;
*/                                    
//Slot17
// assign riser_ocp_m2_slot_number[16]  = mb_cb_prsnt[9]     ? ~(MB_CB_MCIO_OCP2_N == 1'b0):
//                                        mb_cb_prsnt[2]     ? ~(MB_CB_MCIO_OCP2_N == 1'b0): 1'b1;

/*
assign riser_ocp_m2_slot_number[16]  = mb_cb_prsnt[2]     ? ~(j29_device_type == `MCIO_OCP2):
                                       mb_cb_prsnt[9]    ? ~(j25_device_type == `MCIO_OCP2): 1'b1;
*/

//Slot18-19
assign riser_ocp_m2_slot_number[18:17] = 2'b11;

//Slot20-52  front
assign nvme_slot_number[32:0] = nvme_slot_number_R4900[32:0];
//Slot54-53  nouse
assign nvme_slot_number[34:33] = 2'b11;
//Slot55-62  rear
assign nvme_slot_number[42:35] = nvme_slot_number_R4900[57:50];
//Slot63
assign nvme_slot_number[43] = 1'b1;


pcie_slot_number inst_pcie(
  .clk              (clk_50m),
  .rst              (pgd_aux_system),
  .nvme_slot_number (nvme_slot_number_R4900), //output
  .chassis_id       (2'b10),                  //in
  .pcie_detect      (pcie_detect),            //in
  .BP_TYPE          (AUX_BP_type)             //in
);


//VPP I2C_DET
assign rst_n = pon_reset_n & st_steady_pwrok;

assign J20_CPU1_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J6 
assign J19_CPU1_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J7
assign J18_CPU1_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J8
assign J17_CPU1_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J9
assign J29_CPU1_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J26
assign J16_CPU1_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J27
assign J23_CPU2_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J34 
assign J24_CPU2_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J35
assign J21_CPU2_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J36
assign J22_CPU2_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J37
assign J74_CPU2_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J38
assign J25_CPU2_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J39
assign J1_CPU1_MCIO_R_vpp  = {7'h40,1'b0,4'b0};//J28  Riser to 4unibay hotplug
assign J39_CPU2_MCIO_R_vpp = {7'h40,1'b0,4'b0};//J4   Riser to 4unibay hotplug

assign para_data_in = {J39_CPU2_MCIO_R_vpp,J1_CPU1_MCIO_R_vpp,//Riser to 4unibay hotplug
                       J25_CPU2_MCIO_R_vpp,J74_CPU2_MCIO_R_vpp,J22_CPU2_MCIO_R_vpp,J21_CPU2_MCIO_R_vpp,J24_CPU2_MCIO_R_vpp,J23_CPU2_MCIO_R_vpp,
                       J16_CPU1_MCIO_R_vpp,J29_CPU1_MCIO_R_vpp,J17_CPU1_MCIO_R_vpp,J18_CPU1_MCIO_R_vpp,J19_CPU1_MCIO_R_vpp,J20_CPU1_MCIO_R_vpp};
                                                        
generate
begin:UART_MASTER_VPP
genvar i;
    for (i=0; i< port_num; i=i+1)
        begin:UART_MASTER_VPP
            UART_MASTER_VPP#(.NBIT_IN(9),.NBIT_OUT(12),.BPS_COUNT_NUM (24) ,.START_COUNT_NUM(12)) PFR_UART_MASTER(  // BPS=9600 ,tick * BPS_COUNT_NUM = 1/9600. 
                .clk          (clk_50m                      ),//input
                .rst          (~rst_n                       ),//input,change in 20200315 by g14161
                .tick         (t8us_tick                    ),//input
                .t128ms_tick  (t16ms_tick                   ),//input,Send uart a group of signal per 128ms 
                .par_data_in  (para_data_in[12*(i+1)-1:12*i]),//in           
                .par_data_out (par_data_out[9*(i+1)-1:9*i]  ),//out           
                .ser_data_in  (ser_data_in[i]               ),//input 
                .ser_data_out (ser_data_out[i]              ),//output
                .read_flag    (i_read_flag[i]               ),//output  
                .send_enable  (1'b1                         ),
                .error_flag   (                             )
            );
        end
end
endgenerate    

//CPU1
assign CPU_MCIO2_VPP_ADDR_R  = (~i_read_flag[0]) ? ser_data_out[0] : 1'bz;//J20 J6
assign ser_data_in[0]        = CPU_MCIO2_VPP_ADDR_R;

assign CPU_MCIO3_VPP_ADDR_R  = (~i_read_flag[1]) ? ser_data_out[1] : 1'bz;//J19 J7
assign ser_data_in[1]        = CPU_MCIO3_VPP_ADDR_R;

assign CPU_MCIO0_VPP_ADDR_R  = (~i_read_flag[2]) ? ser_data_out[2] : 1'bz ;//J18 J8  
assign ser_data_in[2]        = CPU_MCIO0_VPP_ADDR_R;

assign CPU_MCIO1_VPP_ADDR_R  = (~i_read_flag[3]) ? ser_data_out[3] : 1'bz ;//J17 J9
assign ser_data_in[3]        = CPU_MCIO1_VPP_ADDR_R;

assign CPU_MCIO12_VPP_ADDR_R = (~i_read_flag[4]) ? ser_data_out[4] : 1'bz ;//J29 J26
assign ser_data_in[4]        = CPU_MCIO12_VPP_ADDR_R;

assign CPU_MCIO4_VPP_ADDR_R  = (~i_read_flag[5]) ? ser_data_out[5] : 1'bz ;//J16 J27
assign ser_data_in[5]        = CPU_MCIO4_VPP_ADDR_R;

//CPU2
assign CPU_MCIO7_VPP_ADDR_R  = (~i_read_flag[6]) ? ser_data_out[6] : 1'bz ;//J23 J34
assign ser_data_in[6]        = CPU_MCIO7_VPP_ADDR_R;

assign CPU_MCIO8_VPP_ADDR_R  = (~i_read_flag[7]) ? ser_data_out[7] : 1'bz ;//J24 J35
assign ser_data_in[7]        = CPU_MCIO8_VPP_ADDR_R;

assign CPU_MCIO5_VPP_ADDR_R  = (~i_read_flag[8]) ? ser_data_out[8] : 1'bz ;//J21 J36
assign ser_data_in[8]        = CPU_MCIO5_VPP_ADDR_R;

assign CPU_MCIO6_VPP_ADDR_R  = (~i_read_flag[9]) ? ser_data_out[9] : 1'bz ;//J22 J37
assign ser_data_in[9]        = CPU_MCIO6_VPP_ADDR_R;

assign CPU_MCIO11_VPP_ADDR_R = (~i_read_flag[10])? ser_data_out[10] : 1'bz ;//J74 J38
assign ser_data_in[10]       = CPU_MCIO11_VPP_ADDR_R;

assign CPU_MCIO9_VPP_ADDR_R  = (~i_read_flag[11])? ser_data_out[11] : 1'bz ;//J25 J39
assign ser_data_in[11]       = CPU_MCIO9_VPP_ADDR_R;

// RJ45 LED, 暂时保留高电平
assign o_PAL_RJ45_2_1000M_LED = 1'b1 ;
assign o_PAL_RJ45_2_100M_LED  = 1'b1 ;
assign o_PAL_RJ45_2_ACT_LED   = 1'b1 ;
assign o_PAL_RJ45_1_1000M_LED = 1'b1 ;
assign o_PAL_RJ45_1_100M_LED  = 1'b1 ;
assign o_PAL_RJ45_1_ACT_LED   = 1'b1 ;
// RJ45 LED, 暂时保留高电平

// ???未使用, 后续添加???
assign o_N1_ACT   = 1'bz ;
assign o_N1_100M  = 1'bz ;
assign o_N1_1000M = 1'bz ;
assign o_N0_ACT   = 1'bz ;
assign o_N0_100M  = 1'bz ;
assign o_N0_1000M = 1'bz ;
// ???未使用, 后续添加???

// GPU THROTTLE, 暂时保留高电平
assign o_CPU_MCIO0_GPU_THROTTLE_N_R = 1'b1;
assign o_CPU_MCIO2_GPU_THROTTLE_N_R = 1'b1;
assign o_CPU_MCIO3_GPU_THROTTLE_N_R = 1'b1;
assign o_CPU_MCIO5_GPU_THROTTLE_N_R = 1'b1;
assign o_CPU_MCIO7_GPU_THROTTLE_N_R = 1'b1;
assign o_CPU_MCIO8_GPU_THROTTLE_N_R = 1'b1;
// GPU THROTTLE, 暂时保留高电平

// 未使用      
assign  o_PAL_THROTTLE_RISER1_R = 1'b0;
assign  o_PAL_THROTTLE_RISER2_R = 1'b0;
// 未使用

assign  o_PAL_GPU1_EFUSE_EN_R   = power_supply_on;
assign  o_PAL_GPU2_EFUSE_EN_R   = power_supply_on;
assign  o_PAL_GPU3_EFUSE_EN_R   = power_supply_on;
assign  o_PAL_GPU4_EFUSE_EN_R   = power_supply_on;


// 未使用, ???信号作用???
assign  o_USB2_SW_SEL_R = 1'b1;
// 未使用, ???信号作用???
endmodule


