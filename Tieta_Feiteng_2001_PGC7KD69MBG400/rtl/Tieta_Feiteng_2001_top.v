module Tieta_Feiteng_1001_top(
    // 系统时钟
    input   i_CLK_C42_IN_25M                        /* synthesis LOC = "U1" */,// from  PLL                                          to  CPLD_S                                           default 1  // 25M 时钟 信号 CK440
    output  o_PAL_WX1860_NCSI_CLK_50M_R             /* synthesis LOC = "K19"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // WX1860 NCSI 时钟 50M 信号                                                    
    output  o_PAL_WX1860_NCSI_SW_EN_N_R             /* synthesis LOC = "L17"*/,// from  CPLD_S                                       to  U38 -- U20WX1869A2                               default 1  // WX1860 NCSI 开关使能 信号
                                                    
    input   i_PAL_BMC_NCSI_CLK_50M_R                /* synthesis LOC = "T9"*/ ,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S_UART_LED_SW                               default 1  // BMC NCSI 时钟 50M 信号
    
    output  o_PAL_BMC_SS_CLK                        /* synthesis LOC = "R5" */,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC 串行时钟 信号
    output	o_PAL_BMC_SS_LOAD_N	                    /* synthesis LOC = "P7"*/ ,// from  CPLD_S                                        to  GENZ_168PIN/J98_5653E5-001H1020T                 default 0  // “PCH（平台控制器中心）向 BMC（基板管理控制器）发送的串行信号加载使能信号 
    output	o_PAL_BMC_SS_DATA_OUT	                /* synthesis LOC = "R7"*/ ,// from  CPLD_S                                        to  GENZ_168PIN/J98_5653E5-001H1020T                 default 0  // “PCH（平台控制器中心）向 BMC（基板管理控制器）发送的串行数据信号”
    input   i_PAL_BMC_SS_DATA_IN                    /* synthesis LOC = "R1" */,// from  GENZ_168PIN                                  to  CPLD_S                                           default 1  // BMC 串行数据 输入 信号                                      
                                            
                                                    

    /* begin: JTAG 接口*/
    input   i_PAL_S_DONE                            /* synthesis LOC = "A19"*/,// from  S_DONE / J32                                 to  CPLD_S                                           default 1  // PAL S DONE 信号
    input   i_PAL_S_INITN                           /* synthesis LOC = "C17"*/,// from  S_INITN / J31                                to  CPLD_S                                           default 1  // PAL S INITN 信号
    input   i_PAL_S_JTAGEN                          /* synthesis LOC = "C13"*/,// from  JTAG_EN / J11                                to  CPLD_S                                            default 1  // PAL S JTAGEN 信号
    input   i_PAL_S_PROGRAM_N                       /* synthesis LOC = "D13"*/,// from  S_PROGRAM_N / J13                            to  CPLD_S                                            default 1  // PAL S PROGRAM_N 信号
    input   i_PAL_S_SN                              /* synthesis LOC = "Y20"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                           default 1  // S_SN 信号 UPD1/UPD2 序列号 信号
    /* end: JTAG 接口*/

    /* begin: I2C 接口*/
    input   i_CPU0_D0_I2C1_PE_STRAP_SCL             /* synthesis LOC = "C6"*/ ,// from  CPU_I2C_LEVEL_TRAN / U97_CA9617MMR           to  CPLD_S                                           default 1  // CPU0 D0 I2C1 PE STRAP SCL 信号
    inout   io_CPU0_D0_I2C1_PE_STRAP_SDA            /* synthesis LOC = "A6"*/ ,// from  CPU_I2C_LEVEL_TRAN / U97_CA9617MMR           to  CPLD_S                                           default 1  // CPU0 D0 I2C1 PE STRAP SDA 信号    
    input   i_CPU1_D0_I2C1_PE_STRAP_SCL             /* synthesis LOC = "R17"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C             to  CPLD_S                                           default 1  // CPU1 D0 I2C1 PE STRAP SCL 信号
    inout   io_CPU1_D0_I2C1_PE_STRAP_SDA            /* synthesis LOC = "N14"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C             to  CPLD_S                                           default 1  // CPU1 D0 I2C1 PE STRAP SDA 信号
    
    output  o_RST_I2C1_MUX_N_R                      /* synthesis LOC = "U19"*/,// from  CPLD_S                                       to  BMC_I2C_MUX1 / U69                               default 1  // I2C1 复位 多路复用器 信号
    output  o_RST_I2C2_MUX_N_R                      /* synthesis LOC = "M19"*/,// from  CPLD_S                                       to  BMC_I2C_MUX1 / U53_CA9545MTR                     default 1  // I2C2 复位 多路复用器 信号
    output  o_RST_I2C3_MUX_N_R                      /* synthesis LOC = "E15"*/,// from  CPLD_S                                       to  RST_I2C3_MUX1 / U242_CA9545MTR                   default 1  // RST I2C3 MUX N 信号
    output  o_RST_I2C4_1_MUX_N_R                    /* synthesis LOC  = "U4" */,// from  CPLD_S                                      to  BMC_I2C_MUX2 / U179                              default 1  // I2C4_1 复位 多路复用器 信号
    output  o_RST_I2C4_2_MUX_N_R                    /* synthesis LOC = "U20"*/,// from  CPLD_S                                       to  BMC_I2C_MUX2 / U179                              default 1  // I2C4_2 复位 多路复用器 信号
    output  o_RST_I2C5_MUX_N_R                      /* synthesis LOC  = "J1" */,// from  CPLD_S                                      to  BMC_I2C_MUX1 / U173                              default 1  // I2C5 复位 多路复用器 信号
    output  o_RST_I2C12_MUX_N_R                     /* synthesis LOC  = "N1" */,// from  CPLD_S                                      to  BMC_I2C_MUX2 / U10_CA9545MTR                     default 1  // I2C12 复位 多路复用器 信号                      
    output  o_RST_I2C13_MUX_N_R                     /* synthesis LOC = "B18"*/,// from  CPLD_S                                       to  RST_I2C13_MUX2 / U51                             default 1  // RST I2C13 MUX N 信号   
    output  o_RST_I2C_BMC_9548_MUX_N_R              /* synthesis LOC = "D16"*/,// from  CPLD_S                                       to  BMC_I2C_MUX2 / U258                              default 1  // RST I2C BMC 9548 MUX N 信号                                           
    /* end: I2C 接口*/


    /* begin: I3C 接口*/
    input   i_BMC_I2C3_PAL_S_SCL_R                  /* synthesis LOC = "C11"*/,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SCL 信号
    input   io_BMC_I2C3_PAL_S_SDA_R                 /* synthesis LOC = "D11"*/,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SDA 信号
    input   i_BMC_I2C3_PAL_S_SCL1_R                 /* synthesis LOC = "B4"*/ ,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SCL1 信号
    inout   io_BMC_I2C3_PAL_S_SDA1_R                /* synthesis LOC = "E7"*/ ,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SDA1 信号
    output  o_PAL_CPU0_I3C_SPD_SEL                  /* synthesis LOC = "P12"*/,// from  CPLD_S                                        to  CPU0_I3C_SPD_SEL / J14_G97V22312HR               default 1  // CPU0 I3C SPD 选择 信号
    output  o_PAL_CPU1_I3C_SPD_SEL                  /* synthesis LOC = "B16"*/,// from  CPLD                                           to  CPU0/1_I2C_I3C_SW / U13                          default 1  // PAL CPU1 I3C SPD SEL 信号
    /* begin: I3C 接口*/


    /* begin: UART 接口 */
    input   i_CPU0_D0_UART1_TX                       /* synthesis LOC = "G3"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D0 UART1 发送 信号
    output  o_CPU0_D0_UART1_RX                       /* synthesis LOC = "F2"*/,// from  CPLD_S                                         to  CPU0_GPIO1 / U1_S5000C_32_3200_C                 default 1  // CPU0 D0 UART1 接收 信号
    input   i_CPU0_D1_UART1_TX                       /* synthesis LOC = "E2"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D1 UART1 发送 信号
    output  o_CPU0_D1_UART1_RX                       /* synthesis LOC = "F3"*/,// from  CPLD_S                                         to  CPU0_GPIO1 / U1_S5000C_32_3200_C                 default 1  // CPU0 D1 UART1 接收 信号
    
    input   i_CPU1_D0_UART1_TX                       /* synthesis LOC = "G4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 UART1 发送 信号  
    output  o_CPU1_D0_UART1_RX                       /* synthesis LOC = "G5"*/,// from  CPLD_S                                         to  CPU1_GPIO1 / U2_S5000C_32_3200_C                 default 1  // CPU1 D0 UART1 接收 信号
    input   i_CPU1_D1_UART1_TX                       /* synthesis LOC = "G2"*/,// from  CPU1_GPIO2 / U3_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D1 UART1 发送 信号
    output  o_CPU1_D1_UART1_RX                       /* synthesis LOC = "F4"*/,// from  CPLD_S                                         to  CPU1_GPIO1 / U2_S5000C_32_3200_C                 default 1  // CPU1 D1 UART1 接收 信号
    
    input   i_CPU0_D0_UART_SIN                       /* synthesis LOC = "H3"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPU0_UART / J614                                 default 1  // CPU0 D0 UART 接收 信号
    output  o_CPU0_D0_UART_SOUT                      /* synthesis LOC = "G1"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D0 UART 发送 信号
    input   i_CPU1_D0_UART_SIN                       /* synthesis LOC = "H7"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPU1_UART / J613                                 default 1  // CPU1 D0 UART 接收 信号
    output  o_CPU1_D0_UART_SOUT                      /* synthesis LOC = "F5"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 UART 发送 信号
    
    input   i_DB_UART_RX_R	                         /* synthesis LOC  = "L1 "*/,// from  DB_MODULE / J33_1338_201_8Q_N                to  CPLD_S                                           default 1  // DB UART 接收 信号
    output  o_DB_UART_TX_R	                          /* synthesis LOC  = "K7 "*/,// from  CPLD_S                                      to  DB_MODULE / J33_1338_201_8Q_N                    default 1  // DB UART 发送 信号       
    
    input   i_DBG_CPU0_UART1_RX_CONN_R               /* synthesis LOC = "M15"*/,// from  J29_10317724B001                              to  CPLD_S                                           default 1  // CPU0 DEBUG UART1 接收 信号
    output  o_DBG_CPU0_UART1_TX_CONN_R               /* synthesis LOC = "M14"*/,// from  CPLD_S                                        to  J29_10317724B001                                 default 1  // CPU0 DEBUG UART1 发送 信号

    input   i_DBG_PAL_BMC_UART1_RX_CONN_R            /* synthesis LOC = "R19"*/,// from  J29_10317724B001                              to  CPLD_S                                           default 1  // BMC DEBUG UART1 接收 信号
    output  o_DBG_PAL_BMC_UART1_TX_CONN_R            /* synthesis LOC = "N16"*/,// from  CPLD_S                                        to  J29_10317724B001                                 default 1  // BMC DEBUG UART1 发送 信号
    
    input   i_JACK_CPU0_D0_UART_SIN                   /* synthesis LOC = "Y11"*/,// from  CPU0_UART / J614                             to  CPLD_S                                           default 1  // CPU0 JACK UART 接收 信号
    output  o_JACK_CPU0_D0_UART_SOUT                  /* synthesis LOC = "W12"*/,// from  CPLD_S                                       to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART 发送 信号
    
    input   i_JACK_CPU1_D0_UART_SIN                   /* synthesis LOC = "W16"*/,// from  CPU1_UART / J613                             to  CPLD_S                                           default 1  // CPU1 JACK UART 接收 信号
    output  o_JACK_CPU1_D0_UART_SOUT                  /* synthesis LOC = "P13"*/,// from  CPLD_S                                       to  CPU1_UART / J613                                 default 1  // CPU1 JACK UART 发送 信号

    input   i_JACK_CPU0_UART1_RX                      /* synthesis LOC = "T12"*/,// from  CPLD_S                                       to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART1 接收 信号
    output  o_JACK_CPU0_UART1_TX                      /* synthesis LOC = "Y12"*/,// from  CPLD_S                                       to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART 发送 信号

    input   i_JACK_CPU1_UART1_RX                      /* synthesis LOC = "T16"*/,// from  CPU1_UART / J613                             to  CPLD_S                                           default 1  // CPU1 JACK UART1 接收 信号
    output  o_JACK_CPU1_UART1_TX	                  /* synthesis LOC = "W13"*/,// from  CPLD_S                                       to  CPU1_UART / J613                                 default 1  // CPU1 JACK UART 发送 信号
 
    input   i_LEAR_CPU0_UART1_RX                      /* synthesis LOC = "U18"*/,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // CPU0 LEAR UART1 接收 信号
    output  o_LEAR_CPU0_UART1_TX                      /* synthesis LOC = "R16"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // CPU0 LEAR UART1 发送 信号

    input   i_Riser1_TOD_UART_RXD_R                   /* synthesis LOC = "W7"*/ ,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser1 TOD UART 接收 信号       
    output  o_Riser1_TOD_UART_TXD_R	                  /* synthesis LOC = "R9"*/ ,// from  CPLD_S                                       to  RISER1/J1_G64V3421MHR                            default 1  // Riser1 TOD UART 发送 信号
    
    input   i_Riser2_TOD_UART_RXD_R                   /* synthesis LOC = "V8"*/ ,// from  RISER2/J39_G64V3421MHR                       to  CPLD_S                                          default 1  // Riser1 TOD UART 接收 信号
    output  o_Riser2_TOD_UART_TXD_R	                  /* synthesis LOC = "Y7"*/ ,// from  CPLD_S                                       to  RISER2/J39_G64V3421MHR                           default 1  // Riser1 TOD UART 发送 信号
    
    input   i_DB9_TOD_UART_RX                         /* synthesis LOC = "M1"*/,// from  PPS TOD / U88_TPT75176HL1_S01R                to  CPLD_S                                           default 1  // DB9 TOD UART 接收 信号
    output  o_DB9_TOD_UART_TX                         /* synthesis LOC  = "M2" */,// from  CPLD_S                                      to  PPS TOD / U88_TPT75176HL1_S01R                  default 1  // DB9 TOD UART 发送 信号

    input   i_PAL_BMC_UART1_TX                        /* synthesis LOC = "T5" */,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // BMC UART1 发送 信号
    output	o_PAL_BMC_UART1_RX	                      /* synthesis LOC = "T6"*/ ,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC UART1 接收 信号
    
    input   i_PAL_BMC_UART4_RX                        /* synthesis LOC = "G19"*/,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // BMC UART4 接收 信号
    output  o_PAL_BMC_UART4_TX                        /* synthesis LOC = "H17"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC UART4 发送 信号    

    input   i_UART0_CPU_LOG_RX                        /* synthesis LOC = "T18"*/,// from  CPU0_UART / J614                             to  CPLD_S                                           default 1  // CPU0 UART 日志 接收 信号
    output  o_UART0_CPU_LOG_TX                        /* synthesis LOC  = "N15"*/,// from  CPLD_S                                      to  CPU0_UART / J614                                 default 1  // CPU0 UART 日志 发送 信号                                                
    /* end: UART 接口 */

    /* begin: SPI 接口 */
    output  o_PAL_SPI_SELECT_R                       /* synthesis LOC = "B6"*/,// from  CPLD_S                                         to  BIOS_FLASH1 / U222_SGM6505HYTQF24G_T             default 1  // PAL SPI 选择 信号
    output  o_PAL_SPI_SWITCH_EN_R                    /* synthesis LOC = "N20"*/,// from  CPLD_S                                        to  BIOS_FALSH0 / U37_SGM6505HYTQF24G_TR             default 1  // SPI 开关 使能 信号

    /* end: SPI 接口 */

    /* begin: CPLD_M 与 CPLD_S 之间的交换信号 */
    input   i_CPLD_M_S_EXCHANGE_S1                  /* synthesis LOC = "V19"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    output  o_CPLD_M_S_EXCHANGE_S2                  /* synthesis LOC = "A5"*/ ,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 交换 信号
    input   i_CPLD_M_S_EXCHANGE_S3                  /* synthesis LOC = "G8"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    input   i_CPLD_M_S_EXCHANGE_S4                  /* synthesis LOC = "A3"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号                                               
    input   i_CPLD_M_S_EXCHANGE_S5                  /* synthesis LOC = "D7"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    /* end: CPLD_M 与 CPLD_S 之间的交换信号 */

    /* begin: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */
    input   i_CPLD_M_S_SGPIO_CLK                    /* synthesis LOC = "A11"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO 时钟 信号
    input   i_CPLD_M_S_SGPIO_LD_N                   /* synthesis LOC = "A2"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO 加载使能 信号    
    input   i_CPLD_M_S_SGPIO_MOSI                   /* synthesis LOC = "A4"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO MOSI 信号
    output  o_CPLD_M_S_SGPIO_MISO_R                 /* synthesis LOC = "A8"*/ ,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO MISO 信号
    input   i_CPLD_M_S_SGPIO1_CLK                   /* synthesis LOC = "C8"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 时钟 信号
    input   i_CPLD_M_S_SGPIO1_LD_N                  /* synthesis LOC = "D8"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 加载使能 信号
    input   i_CPLD_M_S_SGPIO1_MOSI                  /* synthesis LOC = "F8"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 MOSI 信号
    output  o_CPLD_M_S_SGPIO1_MISO_R                /* synthesis LOC = "F9"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO1 MISO 信号
    /* end: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */

    /* begin: OCP */
    output  o_PAL_UART4_OCP_DEBUG_TX                /* synthesis LOC = "P9"*/ ,// from  CPLD_S                                        to  RISER_AUX/J16                                    default 1  // OCP 调试 UART4 发送 信号
    input   i_PAL_UART4_OCP_DEBUG_RX                /* synthesis LOC = "L15"*/,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // OCP 调试 UART4 接收 信号

    output  o_PAL_OCP_NCSI_SW_EN_N_R                /* synthesis LOC  = "M6" */,// from  CPLD_S                                       to  RISER_AUX/U89_SGM652321XTS20G/TR                 default 1  // OCP NCSI 开关使能 信号
    output  o_PAL_OCP_NCSI_CLK_50M_R                /* synthesis LOC  = "L7" */,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // OCP NCSI 时钟 50M 信号

    input   i_PAL_OCP_PRSNT_N                       /* synthesis LOC  = "P6"*/,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // OCP 设备存在 信号
    input   i_PAL_OCP_RISER_CPLD                    /* synthesis LOC  = "M7"*/,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // OCP Riser CPLD 信号
  
    input   i_UART2_PAL_OCP_RX_R                    /* synthesis LOC = "T20"*/,// from  GENZ_168PIN                                   to  CPLD_S                                           default 1  // OCP UART2 接收 信号
    output  o_UART2_PAL_OCP_TX_R                    /* synthesis LOC = "T19"*/,// from  CPLD_S                                        to  RISER_AUX/J16                                    default 1  // OCP UART2 接收 信号    
    /* end: OCP */


    /* begin: GPIO CPU0/1 D0/D1相关信号 */
    input   i_CPU1_D0_GPIO_PORT0_R                   /* synthesis LOC = "C4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口0 信号
    input   i_CPU1_D0_GPIO_PORT1_R                   /* synthesis LOC = "E1"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口1 信号
    input   i_CPU1_D0_GPIO_PORT2_R                   /* synthesis LOC = "C3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口2 信号
    input   i_CPU1_D0_GPIO_PORT4_R                   /* synthesis LOC = "F6"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口4 信号
    input   i_CPU1_D0_GPIO_PORT5_R                   /* synthesis LOC = "G6"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口5 信号
    input   i_CPU1_D0_GPIO_PORT6_R                   /* synthesis LOC = "C1"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口6 信号
    input   i_CPU1_D0_GPIO_PORT7_R                   /* synthesis LOC = "E4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口7 信号     
    input   i_CPU1_D0_GPIO_PORT9_R                   /* synthesis LOC = "E3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口9 信号
    input   i_CPU1_D0_GPIO_PORT10_R                  /* synthesis LOC = "D2"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口10 信号
    /* end: GPIO CPU0/1 D0/D1相关信号 */

    

    /* begin: CPU芯片的MCIO信号相关 */
    input   i_CPU0_MCIO0_CABLE_ID0_R                 /* synthesis LOC = "E14"*/,// from  CPU0_MCIO_0/0 / J27_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID0 信号
    input   i_CPU0_MCIO0_CABLE_ID1_R                 /* synthesis LOC = "D1 "*/,// from  CPU0_MCIO_0/1 / J28_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID1 信号
    input   i_CPU0_MCIO2_CABLE_ID0_R                 /* synthesis LOC = "C14"*/,// from  CPU0_MCIO_2/0 / J23_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO2 电缆 ID0 信号
    input   i_CPU0_MCIO2_CABLE_ID1_R                 /* synthesis LOC = "C16"*/,// from  CPU0_MCIO_2/1 / J26_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO2 电缆 ID1 信号                                                  
    input   i_CPU0_MCIO3_CABLE_ID0_R                 /* synthesis LOC = "F12"*/,// from  CPU0_MCIO_3/0 / J21_G97V22312HR                to  CPLD_S                                          default 1  // CPU0 MCIO3 电缆 ID0 信号                                                     
    input   i_CPU0_MCIO3_CABLE_ID1_R                 /* synthesis LOC = "G12"*/,// from  CPU0_MCIO_3/1 / J20_G97V22312HR                to  CPLD_S                                          default 1  // CPU0 MCIO3 电缆 ID1 信号    
    
    input   i_CPU1_MCIO0_CABLE_ID0_R                 /* synthesis LOC = "A16"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                          default 1  // CPU1 MCIO0 电缆 ID0 信号
    input   i_CPU1_MCIO0_CABLE_ID1_R                 /* synthesis LOC = "B15"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                          default 1  // CPU1 MCIO0 电缆 ID1 信号
    input   i_CPU1_MCIO2_CABLE_ID0_R                 /* synthesis LOC = "A10"*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO2 电缆 ID0 信号
    input   i_CPU1_MCIO2_CABLE_ID1_R                 /* synthesis LOC = "A9"*/ ,// from  CPU1_MCIO_2/3 / J20_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO2 电缆 ID1 信号
    input   i_CPU1_MCIO3_CABLE_ID0_R                 /* synthesis LOC = "D10"*/,// from  CPU1_MCIO_2/3 / J24_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO3 电缆 ID0 信号
    input   i_CPU1_MCIO3_CABLE_ID1_R                 /* synthesis LOC = "B10"*/,// from  CPU1_MCIO_2/3 / J24_G97V22321HR                to  CPLD_S                                          default 1  // CPU1 MCIO3 电缆 ID1 信号

    input   i_BOARD_ID1                              /* synthesis LOC = "Y4"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID1 信号
    input   i_BOARD_ID0                              /* synthesis LOC = "P8"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID0 信号
    input   i_BOARD_ID4                              /* synthesis LOC = "T8"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID4 信号
    input   i_BOARD_ID3                              /* synthesis LOC = "W6"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID3 信号
    input   i_BOARD_ID2                              /* synthesis LOC = "Y6"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID2 信号
    input   i_BOARD_ID5                              /* synthesis LOC = "U9"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID5 信号
    input   i_BOARD_ID6                              /* synthesis LOC = "Y8"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID6 信号
    input   i_BOARD_ID7                              /* synthesis LOC = "V9"*/ ,// from  CPLD_S                                         to  BMC                                              default 0  // 主板 ID7 信号

    output  o_PCA_REVISION_0                          /* synthesis LOC = "W4"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 0 信号 
    output  o_PCB_REVISION_0                          /* synthesis LOC = "R8"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCB 修订版本 0 信号
    output  o_PCB_REVISION_1                          /* synthesis LOC = "W5"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCB 修订版本 1 信号
    output  o_PCA_REVISION_2                          /* synthesis LOC = "Y5"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 2 信号
    output  o_PCA_REVISION_1                          /* synthesis LOC = "T7"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 0 信号


    input   i_CPU_NVME0_PRSNT_N                       /* synthesis LOC = "W9"*/ ,// from  CPU0_MCIO_0/1 / J18_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME0 设备存在 信号
    input   i_CPU_NVME1_PRSNT_N                       /* synthesis LOC = "Y9"*/ ,// from  CPU0_MCIO_0/1 / J18_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME1 设备存在 信号
    input   i_CPU_NVME4_PRSNT_N                       /* synthesis LOC = "P10"*/,// from  CPU1_MCIO_0/1 / J20_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME4 设备存在 信号
    input   i_CPU_NVME5_PRSNT_N                       /* synthesis LOC = "R10"*/,// from  CPU1_MCIO_0/1 / J20_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME5 设备存在 信号
    input   i_CPU_NVME6_PRSNT_N                       /* synthesis LOC = "Y10"*/,// from  CPU1_MCIO_0/1 / J19_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME6 设备存在 信号
    input   i_CPU_NVME7_PRSNT_N                       /* synthesis LOC = "W10"*/,// from  CPU1_MCIO_0/1 / J19_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME7 设备存在 信号
    input   i_CPU_NVME10_PRSNT_N                      /* synthesis LOC = "U10"*/,// from  CPU0_MCIO_0/1 / J21_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME10 设备存在 信号
    input   i_CPU_NVME11_PRSNT_N                      /* synthesis LOC = "V10"*/,// from  CPU0_MCIO_0/1 / J21_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME11 设备存在 信号
    input   i_CPU_NVME14_PRSNT_N                      /* synthesis LOC = "P11"*/,// from  CPU1_MCIO_0/1 / J23_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME14 设备存在 信号
    input   i_CPU_NVME15_PRSNT_N                      /* synthesis LOC = "R11"*/,// from  CPU1_MCIO_0/1 / J23_G97V22312HR               to  CPLD_S                                          default 1  // CPU1 NVME15 设备存在 信号
    input   i_CPU_NVME16_PRSNT_N                      /* synthesis LOC = "V12"*/,// from  CPU0_MCIO_0/1 / J24_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME16 设备存在 信号
    input   i_CPU_NVME17_PRSNT_N                      /* synthesis LOC = "R12"*/,// from  CPU0_MCIO_0/1 / J24_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 NVME17 设备存在 信号                                                                                                                                                    
    
    


    input   i_PAL_M2_0_PRSNT_N                        /* synthesis LOC = "C10"*/,// from  PAL_M2_0_PRSNT / J17                          to  CPLD_S                                           default 1  // M.2_0 设备存在 信号
    input   i_PAL_M2_1_PRSNT_N                        /* synthesis LOC = "J19"*/,// from  M2_SATA_PORT/J26_APCI0556_P003A               to  CPLD_S                                           default 1  // M.2_1 设备存在 信号
    output  o_PAL_M2_0_PERST_N_R                      /* synthesis LOC = "D14"*/,// from  CPLD_S                                        to  M2_0_SATA_PORT / J24                            default 1  // PAL M2_0 PERST_N 信号
    output  o_PAL_M2_1_PERST_N_R                      /* synthesis LOC = "C15"*/,// from  CPLD_S                                        to  M2_1_SATA_PORT / J25                            default 1  // PAL M2_1 PERST_N 信号

    
    input   i_PEX_USB1_PPON1                          /* synthesis LOC = "J5"*/,// from  PEX_USB_UPD720201_2 / U40_XUSB2104LCGR         to  CPLD_S                                           default 1  // PEX USB1 PPON1 信号 
    input   i_PEX_USB1_PPON0                          /* synthesis LOC = "H2"*/,// from  PEX_USB_UPD720201_2 / U40_XUSB2104LCGR         to  CPLD_S                                           default 1  // PEX USB1 PPON0 信号
    input   i_PEX_USB2_PPON1                          /* synthesis LOC = "H1"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR        to  CPLD_S                                           default 1  // PEX USB2 PPON1 信号
    input   i_PEX_USB2_PPON0                          /* synthesis LOC = "J4"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR        to  CPLD_S                                           default 1  // PEX USB2 PPON0 信号
    output  o_USB2_SW_SEL_R                           /* synthesis LOC = "R20"*/,// from  CPLD_S                                        to  USB2_SWITCH / U256_DIO5000QN10                   default 1  // USB2 切换 选择 信号


    output  o_PAL_GPU1_EFUSE_EN_R                     /* synthesis LOC  = "L6" */,// from  CPLD_S                                       to  GPU1_PWR                                         default 1  // GPU1 EFUSE 使能 信号                                            
    output  o_PAL_GPU2_EFUSE_EN_R                     /* synthesis LOC  = "M5" */,// from  CPLD_S                                       to  GPU2_PWR                                         default 1  // GPU2 EFUSE 使能 信号                
    output  o_PAL_GPU3_EFUSE_EN_R                     /* synthesis LOC  = "K4 "*/,// from  CPLD_S                                       to  GPU3_PWR                                         default 1  // GPU3 EFUSE 使能 信号                                     
    output  o_PAL_GPU4_EFUSE_EN_R                     /* synthesis LOC  = "K2 "*/,// from  CPLD_S                                       to  GPU4_PWR                                         default 1  // GPU4 EFUSE 使能 信号                                         
    /* end:   CPU芯片的MCIO信号相关 */

    /* begin: RISER  */
    output  o_PAL_RISER1_SS_CLK                       /* synthesis LOC = "T2" */,// from  CPLD_S                                        to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // Riser1 串行时钟 信号 
    output  o_PAL_RISER1_SS_LD_N                      /* synthesis LOC = "R2" */,// from  CPLD_S                                        to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // Riser1 串行信号加载使能 信号                                               
    input   i_PAL_RISER1_SS_DATA_IN                   // 未添加
    input   i_PAL_RISER1_PRSNT_N                      /* synthesis LOC = "N3" */,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 设备存在 信号    
    input   i_MB_CB_RISER1_PRSNT0_N                   /* synthesis LOC = "N6"*/ ,// from  RISER1/G64V3421MHR                            to  CPLD_S                                           default 1  // 主板连接器 Riser1 设备存在0 信号
    input   i_PAL_RISER1_MODE_R                       /* synthesis LOC = "J20"*/,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 模式 信号
    input   i_PAL_RISER1_WIDTH_R                      /* synthesis LOC = "H16"*/,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 宽度 信号
    input   i_PAL_RISER1_SLOT_PERST_N_R               /* synthesis LOC = "E19"*/,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 插槽复位 信号

    output  o_PAL_RISER2_SS_CLK                       /* synthesis LOC = "H20"*/,// from  CPLD_S                                        to  RISER2/U240_SGM6505HYTQF24G_TR                   default 1  // Riser2 串行时钟 信号                                              
    output  o_PAL_RISER2_SS_LD_N                      /* synthesis LOC = "G16"*/,// from  CPLD_S                                        to  RISER2/U240_SGM6505HYTQF24G_TR                   default 1  // Riser2 串行信号加载使能 信号
    input   i_PAL_RISER2_SS_DATA_IN                   // 未添加
    input   i_PAL_RISER2_PRSNT_N                      /* synthesis LOC = "P15"*/,// from  RISER2/J39_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser2 设备存在 信号
    input   i_MB_CB_RISER2_PRSNT0_N                   /* synthesis LOC = "D5"*/ ,// from  RISER2/G64V3421MHR                            to  CPLD_S                                           default 1  // 主板连接器 Riser2 设备存在0 信号   
    input   i_PAL_RISER2_MODE_R                       /* synthesis LOC = "D18"*/,// from  RISER2/J39_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser2 模式 信号
    input   i_PAL_RISER2_WIDTH_R                      /* synthesis LOC = "F16"*/,// from  RISER2/J39_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser2 宽度 信号
    output  o_PAL_RISER2_SLOT_PERST_N_R               /* synthesis LOC = "D17"*/,// from  CPLD_S                                        to  RISER2/J39_G64V3421MHR                           default 1  // Riser2 插槽复位 信号
        
    output  o_CPU0_RISER1_9548_RST_N_R                /* synthesis LOC = "J14"*/,// from  CPLD_S                                        to  RISER1/J1_G64V3421MHR                            default 1  // CPU0 Riser1 9548 复位 信号     
    output  o_MCIO11_RISER1_PERST2_N                  /* synthesis LOC = "K18"*/,// from  CPLD_S                                        to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // MCIO11 Riser1 插槽复位2 信号
    output  o_CPU1_RISER2_9548_RST_N_R                /* synthesis LOC = "E17"*/,// from  CPLD_S                                        to  RISER2/J39_G64V3421MHR                           default 1  // CPU1 Riser2 9548 复位 信号
          
    input   i_PAL_THROTTLE_RISER1_R                   /* synthesis LOC = "N2" */,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                            default 1  // Riser1 节流 信号
    input   i_PAL_THROTTLE_RISER2_R                   /* synthesis LOC = "P17"*/,// from  RISER2/J240_SGM6505HYTQF24G_TR               to  CPLD_S                                            default 1  // Riser2 节流 信号
    /* end: RISER  */

    /* begin: GPU  */
    output  o_CPU_MCIO0_GPU_THROTTLE_N_R	          /* synthesis LOC = "W1"*/ ,// from  CPLD_S                                        to  CPU0_MCIO_0/1 / J18_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output	o_CPU_MCIO2_GPU_THROTTLE_N_R	          /* synthesis LOC = "Y2"*/ ,// from  CPLD_S                                        to  TPM/ J25_323114MG4FBK00R01                       default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号                                                
    output	o_CPU_MCIO3_GPU_THROTTLE_N_R	          /* synthesis LOC = "W3"*/ ,// from  CPLD_S                                        to  CPU0_MCIO_0/1 / J18_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output  o_CPU_MCIO5_GPU_THROTTLE_N_R              /* synthesis LOC = "Y16"*/,// from  CPLD_S                                        to  CPU0_MCIO_0 / J21_G97V22312HR                    default 1  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output  o_CPU_MCIO7_GPU_THROTTLE_N_R              /* synthesis LOC = "Y13"*/,// from  CPLD_S                                        to  CPU1_MCIO_2/3 / J23_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
    output  o_CPU_MCIO8_GPU_THROTTLE_N_R              /* synthesis LOC = "P5" */,// from  CPLD_S                                        to  CPU1_MCIO_2/3 / J24_G97V22321HR                  default 1  // CPU MCIO8 GPU 节流 信号
    /* end: GPU  */

    /* begin: 电源上下电相关信号 */
    output  o_MCIO_PWR_EN0_R                          /* synthesis LOC  = "P1" */,// from  CPU1_MCIO_0/1 / J18_G97V22312HR              to  CPLD_S                                           default 1  // MCIO 电源使能0 信号
    output  o_MCIO_PWR_EN2_R                          /* synthesis LOC  = "K1 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能2 信号
    output  o_MCIO_PWR_EN3_R                          /* synthesis LOC  = "J2" */,// from  CPU1_MCIO_2/3 / J24_G97V22321HR?            to  CPLD_S                                           default 1  // MCIO 电源使能3 信号
    output  o_MCIO_PWR_EN5_R                          /* synthesis LOC  = "L4 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能5 信号
    output  o_MCIO_PWR_EN7_R                          /* synthesis LOC  = "L2 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能7 信号
    output  o_MCIO_PWR_EN8_R                          /* synthesis LOC  = "K6 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能8 信号
    
    input   i_PAL_PWR_SW_IN_N                         /* synthesis LOC  = "W8"*/ ,// from  CPLD_S_UART_LED_SW                            to  CPLD_S                                           default 1  // 电源开关 输入 信号

    input   i_P12V_STBY_EFUSE_PG                      /* synthesis LOC = "W11"*/,// from  CURRENT_DET1 / P12V_STBY                      to  CPLD_S                                           default 1  // 12V 待机 EFUSE 电源良好 信号
    input   i_PAL_P12V_STBY_EFUSE_FLTB                /* synthesis LOC = "T10"*/,// from  CURRENT_DET1 / P12V_STBY                      to  CPLD_S                                           default 1  // 12V 待机 EFUSE 故障 信号    
    output  o_PAL_P12V_STBY_EFUSE_EN_R                /* synthesis LOC = "W18"*/,// from  CPLD_S                                        to  CURRENT_DET1 / P12V_STBY                         default 1  // 12V 待机 EFUSE 使能 信号
                                                    
    input   i_P12V_STBY_SNS_ALERT                     /* synthesis LOC = "R14"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                  to  CPLD_S                                           default 1  // 12V 待机 传感器 告警 信号

    input   i_PAL_GPU1_EFUSE_OC	                      /* synthesis LOC = "R3" */,// from  GPU1_PWR                                      to  CPLD_S                                           default 1  // GPU1 EFUSE 过温保护 信号
    input   i_PAL_GPU1_EFUSE_PG	                      /* synthesis LOC = "R4" */,// from  GPU1_PWR                                      to  CPLD_S                                           default 1  // GPU1 EFUSE 电源良好 信号
    input   i_PAL_GPU2_EFUSE_OC	                      /* synthesis LOC = "T3" */,// from  GPU2_PWR                                      to  CPLD_S                                           default 1  // GPU2 EFUSE 过温保护 信号
    input   i_PAL_GPU2_EFUSE_PG	                      /* synthesis LOC = "T4" */,// from  GPU2_PWR                                      to  CPLD_S                                           default 1  // GPU2 EFUSE 电源良好 信号
    input   i_PAL_GPU3_EFUSE_OC	                      /* synthesis LOC = "V1" */,// from  GPU3_PWR                                      to  CPLD_S                                           default 1  // GPU3 EFUSE 过温保护 信号
    input   i_PAL_GPU3_EFUSE_PG	                      /* synthesis LOC = "V2" */,// from  GPU3_PWR                                      to  CPLD_S                                           default 1  // GPU3 EFUSE 电源良好 信号
    input   i_PAL_GPU4_EFUSE_OC	                      /* synthesis LOC = "V3" */,// from  GPU4_PWR                                      to  CPLD_S                                           default 1  // GPU4 EFUSE 过温保护 信号
    input   i_PAL_GPU4_EFUSE_PG	                      /* synthesis LOC = "V4" */,// from  GPU4_PWR                                      to  CPLD_S                                           default 1  // GPU4 EFUSE 电源良好 信号

    input   i_PAL_P12V_RISER1_VIN_PG                  /* synthesis LOC = "U14"*/,// from  P12V_RISER1_VIN                               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 良好 信号
    input   i_PAL_P12V_RISER1_VIN_FLTB                /* synthesis LOC = "V15"*/,// from  P12V_RISER1_VIN                               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 故障 信号
    input   i_PAL_P12V_RISER2_VIN_PG                  /* synthesis LOC = "V16"*/,// from  P12V_RISER2_VIN                               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 良好 信号
    input   i_PAL_P12V_RISER2_VIN_FLTB                /* synthesis LOC = "Y18"*/,// from  P12V_RISER2_VIN                               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 故障 信号

    input   i_PAL_PGD_USB_UPD1_P1V1                   /* synthesis LOC = "U11"*/,// from  PEX_USB_1/SGM61030_3V3to1v1                   to  CPLD_S                                           default 1  // USB_UPD1 P1V1 电源良好 信号
    input   i_PAL_PGD_USB_UPD2_P1V1                   /* synthesis LOC = "N18"*/,// from  PEX_USB_UPD720201_2 / SGM61030_3V3to1v1       to  CPLD_S                                           default 1  // USB_UPD2 P1V1 电源良好 信号
    output  o_P5V_USB2_LEFT_EAR_EN                    /* synthesis LOC = "P20"*/,// from  CPLD_S                                        to  USB2_LEFT_EAR / U14_JW7111ssoTBTRPBF             default 1  // 5V USB2 左耳 电源使能 信号
                                                      
    input   i_PAL_RISER4_PWR_PGD                      /* synthesis LOC = "N5" */,// from  RISER_AUX/J16                                 to  CPLD_S                                           default 1  // Riser4 电源良好 信号                                        
    
    output  o_PAL_M2_PWR_EN_R                         /* synthesis LOC = "G10"*/,// from  CPLD_S                                        to  PAL_M2_PWR_EN / U56                             default 1  // M.2 电源使能 信号
    output  o_PAL_P5V_BD_OC                           /* synthesis LOC = "B1"*/ ,// from  CPLD_S                                        to  DB_MODULE / U39_JW7111SSOTBTRPBF                 default 1  // P5V_BD_OC 信号    

    output  o_PAL_UPD1_P1V1_EN_R                      /* synthesis LOC = "G9"*/ ,// from  CPLD_S                                        to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 P1V1 电源使能 信号
    output  o_PAL_UPD1_P3V3_EN_R                      /* synthesis LOC = "M4"*/ ,// from  CPLD_S                                        to  PEX_USB__1 / U40_XUSB2104LCGR                   default 1  // UPD1 P3V3 电源使能 信号
    output  o_PAL_UPD1_PERST_N_R                      /* synthesis LOC = "B7"*/ ,// from  CPLD_S                                        to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 PERST_N 信号 第 1 路更新通道（UPD1）复位 信号
    output  o_PAL_UPD1_PONRST_N_R                     /* synthesis LOC = "P14"*/,// from  CPLD_S                                        to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 PONRST_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的上电复位信号

    output  o_PAL_UPD2_P1V1_EN_R                      /* synthesis LOC = "L20"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 P1V1 电源使能 信号
    output  o_PAL_UPD2_P3V3_EN_R                      /* synthesis LOC = "K15"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U63                        default 1  // UPD2 P3V3 电源使能 信号
    output  o_PAL_UPD2_PERST_N_R                      /* synthesis LOC = "N17"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 插槽复位 信号                                                   
    output  o_PAL_UPD2_PORNRST_N_R                    /* synthesis LOC = "K16"*/,// from  CPLD_S                                        to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 PORNRST_N 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的上电复位信号
    /* end: 电源上下电相关信号 */

    /* begin: LED灯 控制信号 */
    output  o_LED8_N                                  /* synthesis LOC = "Y14"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED8 灯 信号
    output  o_LED7_N                                  /* synthesis LOC = "W14"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED7 灯 信号
    output  o_LED6_N                                  /* synthesis LOC = "T11"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED6 灯 信号
    output  o_LED5_N                                  /* synthesis LOC = "Y15"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED5 灯 信号
    output  o_LED4_N                                  /* synthesis LOC = "T13"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED4 灯 信号
    output  o_LED3_N                                  /* synthesis LOC = "Y17"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED3 灯 信号
    output  o_LED2_N                                  /* synthesis LOC = "R13"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED2 灯 信号
    output  o_LED1_N                                  /* synthesis LOC = "V14"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED1 灯 信号
    
    output  o_N1_ACT                                  /* synthesis LOC = "C18"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 活动 指示灯 信号
    output  o_N1_100M                                 /* synthesis LOC = "F15"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 100M 指示灯 信号
    output  o_N1_1000M                                /* synthesis LOC = "G15"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 1000M 指示灯 信号
    output  o_N0_ACT                                  /* synthesis LOC = "H14"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 活动 指示灯 信号
    output  o_N0_100M                                 /* synthesis LOC = "H15"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 100M 指示灯 信号
    output  o_N0_1000M                                /* synthesis LOC = "D19"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 1000M 指示灯 信号
    
    output	o_PAL_LED_HEL_GR_R	                      /* synthesis LOC = "J15"*/,// from  CPLD_S                                       to  SYS STATUS LED                                   default 1  // HEL 绿色 指示灯 信号
    output  o_PAL_LED_HEL_RED_R                       /* synthesis LOC = "J18"*/,// from  CPLD_S                                       to  SYS STATUS LED                                   default 1  // HEL 红色 指示灯 信号

    output  o_PAL_LED_PWRBTN_GR_R                     /* synthesis LOC = "M16"*/,// from  CPLD_S                                       to  PWR BTN&LED                                      default 1  // 电源按钮 绿色 指示灯 信号
    output  o_PAL_LED_PWRBTN_AMBER_R                  /* synthesis LOC = "N19"*/,// from  CPLD_S                                       to  PWR BTN&LED                                      default 1  // 电源按钮 琥珀色 指示灯 信号
                                                  
    output  o_PAL_LED_UID_R                           /* synthesis LOC = "B17"*/,// from  CPLD_S                                        to  LED_UID / J22                                   default 1  // PAL LED UID 信号

    output  o_PAL_RJ45_2_1000M_LED                    /* synthesis LOC = "F17"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_2 网口 1000M 指示灯 信号
    output  o_PAL_RJ45_2_100M_LED                     /* synthesis LOC = "D20"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_1 网口 100M 指示灯 信号
    output  o_PAL_RJ45_2_ACT_LED                      /* synthesis LOC = "F18"*/,// from  CPLD_S                                       to  J32_AC7412_3557_004_H0                           default 1  // RJ45_2 网口 活动 指示灯 信号                                                    
    output  o_PAL_RJ45_1_1000M_LED                    /* synthesis LOC = "F19"*/,// from  CPLD_S                                       to  J2_AC7412_3557_004_H0                            default 1  // RJ45_1 网口 1000M 指示灯 信号
    output  o_PAL_RJ45_1_100M_LED                     /* synthesis LOC = "F20"*/,// from  CPLD_S                                       to  J2_AC7412_3557_004_H0                            default 1  // RJ45_1 网口 100M 指示灯 信号
    output  o_PAL_RJ45_1_ACT_LED                      /* synthesis LOC = "B20"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_1 网口 活动 指示灯 信号
                                                      
    /* end: LED灯 控制信号 */

    /* begin: 拨码开关 */
    output  o_SW_1                                   /* synthesis LOC = "B13"*/,// from  CPLD_S                                         to  SW_1 / J4                                        default 1  // 开关 1 信号        
    output  o_SW_2                                   /* synthesis LOC = "G11"*/,// from  CPLD_S                                         to  SW_2 / J5                                        default 1  // 开关 2 信号        
    output  o_SW_3                                   /* synthesis LOC = "F11"*/,// from  CPLD_S                                         to  SW_3 / J6                                        default 1  // 开关 3 信号        
    output  o_SW_4                                   /* synthesis LOC = "A14"*/,// from  CPLD_S                                         to  SW_4 / J7                                        default 1  // 开关 4 信号        
    output  o_SW_5                                   /* synthesis LOC = "B14"*/,// from  CPLD_S                                         to  SW_5 / J8                                        default 1  // 开关 5 信号        
    output  o_SW_6                                   /* synthesis LOC = "D12"*/,// from  CPLD_S                                         to  SW_6 / J9                                        default 1  // 开关 6 信号        
    output  o_SW_7                                   /* synthesis LOC = "C12"*/,// from  CPLD_S                                         to  SW_7 / J10                                       default 1  // 开关 7 信号        
    output  o_SW_8                                   /* synthesis LOC = "A15"*/,// from  CPLD_S                                         to  SW_8 / J12                                       default 1  // 开关 8 信号
    /* end: 拨码开关 */

    /* begin: DEBUG 信号 */
    input   i_CABLE_PRSNT_N                         /* synthesis LOC = "T17"*/,// from  J29_10217724B001                              to  CPLD_S                                           default 1  // 电缆 设备存在 信号
                                                    
    input   i_CHASSIS_ID0_N                         /* synthesis LOC = "E20"*/,// from  ?CHASSIS_ID?                                  to  CPLD_S                                           default 1  // 机箱 ID0 信号                        
    input   i_CHASSIS_ID1_N                         /* synthesis LOC = "K14"*/,// from  ?CHASSIS_ID?                                  to  CPLD_S                                           default 1  // 机箱 ID1 信号
    
    input   i_CPU0_VIN_SNS_ALERT                    /* synthesis LOC = "V13"*/,// from  CURRENT_DET0 / U57_TPA626_VR_S                to  CPLD_S                                           default 1  // CPU0 输入电压 传感器 告警 信号
    input   i_CPU1_VIN_SNS_ALERT                    /* synthesis LOC = "M17"*/,// from  CURRENT_DET0 / U60_TPA626_VR_S                to  CPLD_S                                           default 1  // CPU1 输入电压 传感器 告警 信号

    input   i_CPU0_D0_TEMP_OVER                     /* synthesis LOC = "C2"*/ ,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU0 D0 温度 过高 信号
    input   i_CPU0_D1_TEMP_OVER                     /* synthesis LOC = "J6"*/ ,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU0 D1 温度 过高 信号
    input   i_CPU1_D0_TEMP_OVER                     /* synthesis LOC = "D1"*/ ,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU1 D0 温度 过高 信号
    input   i_CPU1_D1_TEMP_OVER                     /* synthesis LOC = "H6"*/ ,// from  CPU1_GPIO2 / U3_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU1 D1 温度 过高 信号

    input   i_P5V_USB2_LEFT_EAR_OCI2B               /* synthesis LOC = "P19"*/,// from  CPLD_S                                        to  USB2_LEFT_EAR / U14_JW7111ssoTBTRPBF             default 1  // 5V USB2 左耳 OCI2B 过流告警信号
    input   i_P12V_RISER1_VIN_SNS_ALERT             /* synthesis LOC = "L16"*/,// from  P12V_RISER1_VIN/U25_TPA626_VR_S               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 传感器 告警 信号
    input   i_P12V_RISER2_VIN_SNS_ALERT             /* synthesis LOC = "M18"*/,// from  P12V_RISER2_VIN/U28_TPA626_VR_S               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 传感器 告警 信号

    output  o_PAL_DB800_1_OE_N_R                    /* synthesis LOC = "A13"*/,// from  DB800_1_CLK / U48_AU5440AQMR                  to  CPLD_S                                           default 1  // DB800_1 输出使能 信号
    output  o_PAL_DB2000_1_OE_N_R                   /* synthesis LOC = "B5" */,// from  DB2000_1_CLK / U47_AU5440AQMR                 to  CPLD_S                                           default 1  // DB2000_1 输出使能 信号
    output  o_PAL_CK440_OE_N_R                      /* synthesis LOC = "K17"*/,// from  CPLD_S                                       to  CK440_CLKER / U70_RS2CG440ZUDE                   default 1  // CK440 输出使能 信号               

    input	i_PAL_EXT_RST_N	                        /* synthesis LOC = "W15"*/,// from  CPLD_S_UART_LED_SW                            to  CPLD_S                                           default 1  // 外部 复位 信号

    input   i_PAL_LOM_FAN_ON_AUX_R                  /* synthesis LOC = "M3" */,// from  RISER_AUX / J16                              to  CPLD_S                                            default 1  // LOM 风扇 开启 辅助 信号
    input   i_FAN_SNS_ALERT                         /* synthesis LOC = "A12"*/,// from  CPLD_S                                       to  FAN_SNS_ALERT / U60                               default 1  // 风扇 传感器 警报 信号


    
    input   i_PAL_UPD1_PEWAKE_N                     /* synthesis LOC = "V20"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                            default 1  // UPD1 PEWAKE_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的电源唤醒信号
    input   i_PAL_UPD1_SMIB_N                       /* synthesis LOC = "E6"*/ ,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                           default 1  // UPD1 SMIB_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的SMIB_N信号
    
    input   i_PAL_UPD2_PEWAKE_N                     /* synthesis LOC = "R15"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR      to  CPLD_S                                           default 1  // UPD2 PEWAKE_N 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的电源唤醒信号
    input   i_PAL_UPD2_SMIB_N                       /* synthesis LOC = "W17"*/,// from  PEX_USB_UPD720201_2 / U63                    to  CPLD_S                                           default 1  // UPD2 SMIB 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的 SMI 中断请求信号

    input   i_PAL_UPD72020_1_ALART                  /* synthesis LOC = "L5" */,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                          default 1  // UPD1 警报 信号
    input   i_PAL_UPD72020_2_ALART                  /* synthesis LOC = "U12"*/,// from  PEX_USB_UPD720201_2 / U63                    to  CPLD_S                                           default 1  // UPD720201_2 告警 信号

    input   i_REAR_BP_SNS_ALERT                     /* synthesis LOC = "C19"*/,// from  CURRENT_DET1                                 to  CPLD_S                                           default 1  // 后板 传感器 告警 信号
    

    output	o_PAL_RST_TPM_N_R	                    /* synthesis LOC = "Y1"*/ ,// from  CPLD_S                                       to  TPM/ J25_323114MG4FBK00R01                       default 0  // TPM模块 复位 信号 
    output	o_PAL_TPM_DRQ1_N	                    /* synthesis LOC = "W2"*/ ,// from  CPLD_S                                       to  TPM/ J25_323114MG4FBK00R01                       default 1  // TPM模块 DRQ1 信号, TPM 模块向 PCH 发起的 DMA 请求信号                                              

    output  o_PAL_TEST_BAT_EN                       /* synthesis LOC = "U5" */,// from  CPLD_S                                       to  TRC                                              default 1  // 测试 电池 使能 信号
                                                    /* synthesis LOC = "R6"*/ // 未使用

    input   i_CPU1_D0_GPIO_PORT3_R                  /* synthesis LOC = "H4"*/ ,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C              to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口3 信号
    input   i_CPU0_MCIO0_CABLE_ID0_R                /* synthesis LOC = "E14"*/,// from  CPU0_MCIO_0/0 / J27_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID0 信号
                                                    /* synthesis LOC = "J3 "*/ // 未使用 
    output  o_PAL_DB800_1_PD_R                      /* synthesis LOC = "F13"*/,// from  CPLD_S                                        to  DB800_2_CLK / U11_AU5443A_LMR                    default 1  // PAL DB800_1 PD 信号(DB800 模块 1 的掉电控制信号)
    output  o_PAL_DB2000_1_PD_R                     /* synthesis LOC = "P16"*/,// from  CPLD_S                                        to  DB2000_1_CLK / U47_AU5440AQMR                    default 1  // DB2000_1 电源禁用 信号
    /* end: DEBUG 信号 */
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 系统时钟: input 25MHz, output 100MHz/50MHz/25MHz
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                        clk_50m                     ; // 50mHz 时钟
wire                                        sys_clk                     ; // 系统时钟
wire                                        pll_lock                    ;
wire                                        pal_p3v3_stby_pgd           ;

assign pal_p3v3_stby_pgd = CPLD_M_S_EXCHANGE_S1 ;
pll_i25M_o50M_o25M pll_inst (
    .clkin1                                 (i_CLK_C42_IN_25M           ), // input 25.0000MHz
    .rst                                    (~pal_p3v3_stby_pgd         ), // input
    .clkout0                                (clk_50m                    ), // output 50.00000000MHz
    .clkout1                                (sys_clk                    ), // output 25.00000000MHz
    .lock                                   (pll_lock                   )  // output
);
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 系统时钟: input 25MHz, output 100MHz/50MHz/25MHz
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 全局复位 
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                        pgd_aux_bmc                 ; // 不使用, BMC_PDG, 来自BMC, 默认写1
wire                                        done_booting_delayed        ; // 不使用, 系统booting_done, 来自BMC, 默认写1
wire                                        pon_reset_n                 ; // 使用  , 全局复位
wire                                        pon_reset_db_n              ; // 不使用, 复位
wire                                        pgd_aux_system              ; // 不使用, 复位
wire                                        pgd_aux_system_sasd         ; // 不使用, 复位
wire                                        cpld_ready                  ; // 不使用, 复位

assign                                      pgd_aux_bmc          = 1'b1 ; // 不使用, BMC_PDG, 来自BMC, 默认写1
assign                                      done_booting_delayed = 1'b1 ; // 不使用, 系统booting_done, 来自BMC, 默认写1

pon_reset pon_reset_inst( 
    .clk                                    (clk_50m                    ),// input:  复位/PGD 同步时钟源（50MHz）
    .pll_lock                               (pll_lock                   ),// input:  仅在 PLL 锁定后才允许释放复位
    .pgd_p3v3_stby                          (pal_p3v3_stby_pgd          ),// input:  待机 3.3V 电源良好指示（PGD）
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
end: 全局复位 
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 时钟树
------------------------------------------------------------------------------------------------------------------------------------------------*/
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
end: 时钟树
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 输入信号滤波, 去抖动
------------------------------------------------------------------------------------------------------------------------------------------------*/
PGM_DEBOUNCE_N #(.SIGCNT(4), .NBITS(2'b11), .ENABLE(1'b1)) db_inst_pwrgood (
    .clk		(clk_50m                    ),
    .rst_n		(pon_reset_n                ),
    .timer_tick	(1'b1                       ),
    .din        ({
	                PAL_OCP2_PWRGD           ,	//01
	                ~DIMM_SNS_ALERT          ,  //02
	                ~FAN_SNS_ALERT           ,  //03
	                ~P12V_STBY_SNS_ALERT        //04
	            }),             
    .dout       ({
    	            db_i_pal_ocp2_pwrgd      ,	//01
    	            db_i_dimm_sns_alert      ,  //02
    	            db_i_fan_sns_alert       ,  //03
    	            db_i_p12v_stby_sns_alert    //04
    	        }) 
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 输入信号滤波, 去抖动
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
// M CPLD ---> S CPLD 串转并
wire [511:0]        mcpld_to_scpld_s2p_data     ;
reg  [345:0]        mcpld_to_scpld_data_filter  ;
reg                 mcpld_sgpio_fail            ;

s2p_slave #(.NBIT(512)) inst_mb_to_cmu_s2p(
	.clk        (clk_50m                    ),
	.rst        (~pon_reset_n               ),
	.si         (i_CPLD_M_S_SGPIO_MOSI	    ),//SGPIO_MOSI Serial Signal input
	.po         (mcpld_to_scpld_s2p_data    ),//Parallel Signal output
	.sld_n      (i_CPLD_M_S_SGPIO_LD_N	    ),//SGPIO_LOAD
	.sclk       (i_CPLD_M_S_SGPIO_CLK		) //SGPIO_CLK
); 

// 数据滤波与有效性判断
always @(posedge clk_50m or negedge pon_reset_n)begin
	if(~pon_reset_n) begin
		mcpld_to_scpld_data_filter  <= {346{1'b0}}                   ;
		mcpld_sgpio_fail            <= 1'b0                          ;
	end
	else if((mcpld_to_scpld_s2p_data[3:0] == 4'b0101) && (mcpld_to_scpld_s2p_data[511:508] == 4'b1010))begin 
		mcpld_to_scpld_data_filter  <= mcpld_to_scpld_s2p_data[349:4];
		mcpld_sgpio_fail            <= 1'b0                          ;
	end
	else begin
		mcpld_to_scpld_data_filter  <= mcpld_to_scpld_data_filter    ;
		mcpld_sgpio_fail            <= 1'b1                          ;
	end	
end

// M CPLD ---> S CPLD 数据解析
assign test_bat_en                    = mcpld_to_scpld_data_filter[345]     ;
assign bmc_extrst_uid                 = mcpld_to_scpld_data_filter[344]     ;
assign pal_m2_0_sel_lv33_r            = mcpld_to_scpld_data_filter[343]     ;
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
assign pal_led_nic_act                = mcpld_to_scpld_data_filter[268]     ;
assign rst_i2c_riser2_pca9548_n       = mcpld_to_scpld_data_filter[267]     ;
assign rst_i2c_riser1_pca9548_n       = mcpld_to_scpld_data_filter[266]     ;
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
assign rom_mux_bios_bmc_en            = mcpld_to_scpld_data_filter[211]     ;
assign AUX_BP_type[31:0]              = mcpld_to_scpld_data_filter[210:179] ;
assign pcie_detect[127:0]             = mcpld_to_scpld_data_filter[178:51]  ;
assign o_mb_cb_prsnt_bmc[15:0]        = mcpld_to_scpld_data_filter[50:35]   ;
assign rom_mux_bios_bmc_sel           = mcpld_to_scpld_data_filter[34]      ;
//assign bmcctl_uart_sw_en            = mcpld_to_scpld_data_filter[33] ;
assign bmcctl_uart_sw[1:0]            = mcpld_to_scpld_data_filter[33:32]   ;
assign rom_bmc_bk_rst                 = mcpld_to_scpld_data_filter[31]      ;
assign rom_bmc_ma_rst                 = mcpld_to_scpld_data_filter[30]      ;
assign rst_pal_extrst_r_n             = mcpld_to_scpld_data_filter[29]      ;
assign leakage_det_do_n               = mcpld_to_scpld_data_filter[28]      ;
assign tpm_rst                        = mcpld_to_scpld_data_filter[27]      ;
assign rst_i2c13_mux_n                = mcpld_to_scpld_data_filter[26]      ;
assign rst_i2c12_mux_n                = mcpld_to_scpld_data_filter[25]      ;
assign rst_i2c11_mux_n                = mcpld_to_scpld_data_filter[24]      ;
assign rst_i2c10_mux_n                = mcpld_to_scpld_data_filter[23]      ;
assign rst_i2c8_mux_n                 = mcpld_to_scpld_data_filter[22]      ;
assign rst_i2c5_mux_n                 = mcpld_to_scpld_data_filter[21]      ;
assign rst_i2c4_2_mux_n               = mcpld_to_scpld_data_filter[20]      ;
assign rst_i2c4_1_mux_n               = mcpld_to_scpld_data_filter[19]      ;
assign rst_i2c3_mux_n                 = mcpld_to_scpld_data_filter[18]      ;
assign rst_i2c2_mux_n                 = mcpld_to_scpld_data_filter[17]      ;
assign rst_i2c1_mux_n                 = mcpld_to_scpld_data_filter[16]      ;
assign sys_hlth_red_blink_n           = mcpld_to_scpld_data_filter[15]      ;
assign sys_hlth_grn_blink_n           = mcpld_to_scpld_data_filter[14]      ;
assign led_uid                        = mcpld_to_scpld_data_filter[13]      ;
assign power_supply_on                = mcpld_to_scpld_data_filter[12]      ;
assign ocp_main_en                    = mcpld_to_scpld_data_filter[11]      ;
assign ocp_aux_en                     = mcpld_to_scpld_data_filter[10]      ;
assign pex_reset_n                    = mcpld_to_scpld_data_filter[9]       ;
assign reached_sm_wait_powerok        = mcpld_to_scpld_data_filter[8]       ;
assign usb_ponrst_r_n                 = mcpld_to_scpld_data_filter[7]       ;
assign t4hz_test_mcpld                = mcpld_to_scpld_data_filter[6]       ;
assign power_seq_sm		              = mcpld_to_scpld_data_filter[5:0]     ;

// S CPLD ---> M CPLD
wire [511:0]                    scpld_to_mcpld_p2s_data;
p2s_slave #(.NBIT(512)) inst_cmu_to_mb_p2s(
	.clk        (clk_50m					),
	.rst        (~pon_reset_n				),
	.pi         (scpld_to_mcpld_p2s_data	),//Parallel Signal input
	.so         (o_CPLD_M_S_SGPIO_MISO_R	),//SGPIO_MISO Serial Signal output
	.sld_n      (i_CPLD_M_S_SGPIO_LD_N   	),//SGPIO_LOAD
	.sclk       (i_CPLD_M_S_SGPIO_CLK	    ) //SGPIO_CLK
);

// S CPLD ---> M CPLD 数据组装
assign scpld_to_mcpld_p2s_data[511]     = 1'b1                           ; 
assign scpld_to_mcpld_p2s_data[510]     = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[509]     = 1'b1                           ; 
assign scpld_to_mcpld_p2s_data[508]     = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[507:431] = 77'b0                          ;
assign scpld_to_mcpld_p2s_data[430]     = bmc_ready_flag                 ;
assign scpld_to_mcpld_p2s_data[429]     = db_i_pal_pgd_p3v3              ;
assign scpld_to_mcpld_p2s_data[428]     = db_i_pal_pgd_p1v8              ;
assign scpld_to_mcpld_p2s_data[427]     = db_i_pal_pgd_p1v2              ;
assign scpld_to_mcpld_p2s_data[426]     = db_i_pal_pgd_p1v1              ;
assign scpld_to_mcpld_p2s_data[425]     = db_i_pal_pgd_p0v8              ;
assign scpld_to_mcpld_p2s_data[424]     = cpu1_temp_over                 ;
assign scpld_to_mcpld_p2s_data[423]     = cpu0_temp_over                 ;
assign scpld_to_mcpld_p2s_data[422]     = 1'b0                           ;//db_i_lom_prsnt_n
assign scpld_to_mcpld_p2s_data[421]     = 1'b0                           ;//lom_thermal_trip
assign scpld_to_mcpld_p2s_data[420]     = db_i_pal_ocp2_fan_prsnt_n      ;
assign scpld_to_mcpld_p2s_data[419]     = db_i_pal_ocp2_fan_foo          ;
assign scpld_to_mcpld_p2s_data[418]     = db_i_pal_lcd_card_in           ;
assign scpld_to_mcpld_p2s_data[417]     = i_pal_ifist_prsnt_n            ;
assign scpld_to_mcpld_p2s_data[416:409] = bios_post_code[7:0]           ;
assign scpld_to_mcpld_p2s_data[408:401] = bios_post_phase[7:0]          ;
assign scpld_to_mcpld_p2s_data[400:393] = bios_post_rate[7:0]           ;
assign scpld_to_mcpld_p2s_data[392]     = bios_read_flag                 ;
assign scpld_to_mcpld_p2s_data[391:384] = {pal_bp8_prsnt_n,pal_bp7_prsnt_n,pal_bp6_prsnt_n,pal_bp5_prsnt_n,pal_bp4_prsnt_n,pal_bp3_prsnt_n,pal_bp2_prsnt_n,pal_bp1_prsnt_n};//led_to_pfr[7:0];
assign scpld_to_mcpld_p2s_data[383]     = USB2_LCD_ALERT                 ;
assign scpld_to_mcpld_p2s_data[382]     = VGA2_OC_ALERT                  ;
assign scpld_to_mcpld_p2s_data[381]     = 1'b0                           ;//PAL_UPD72020_2_ALART
assign scpld_to_mcpld_p2s_data[380]     = 1'b0                           ;//PAL_UPD72020_1_ALART
assign scpld_to_mcpld_p2s_data[379]     = usb_en[1]                      ;
assign scpld_to_mcpld_p2s_data[378]     = usb_en[0]                      ;
assign scpld_to_mcpld_p2s_data[377]     = DSD_UART_PRSNT_N               ;
assign scpld_to_mcpld_p2s_data[376]     = pfr_pe_wake_n                  ;
assign scpld_to_mcpld_p2s_data[375:368] = ocp2_pvti_byte3                ;       
assign scpld_to_mcpld_p2s_data[367:360] = ocp2_pvti_byte2                ;             
assign scpld_to_mcpld_p2s_data[359:352] = ocp2_pvti_byte1                ;
assign scpld_to_mcpld_p2s_data[351:344] = ocp2_pvti_byte0                ;
assign scpld_to_mcpld_p2s_data[343:336] = ocp1_pvti_byte3                ;
assign scpld_to_mcpld_p2s_data[335:328] = ocp1_pvti_byte2                ;
assign scpld_to_mcpld_p2s_data[327:320] = ocp1_pvti_byte1                ;
assign scpld_to_mcpld_p2s_data[319:312] = ocp1_pvti_byte0                ;
assign scpld_to_mcpld_p2s_data[311:308] = board_id                       ;
assign scpld_to_mcpld_p2s_data[307:305] = pcb_version                    ;
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
assign scpld_to_mcpld_p2s_data[114]     = db_i_p12v_stby_sns_alert       ;
assign scpld_to_mcpld_p2s_data[113]     = db_i_fan_sns_alert             ;
assign scpld_to_mcpld_p2s_data[112]     = db_i_dimm_sns_alert            ;
assign scpld_to_mcpld_p2s_data[111]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_5
assign scpld_to_mcpld_p2s_data[110]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_4
assign scpld_to_mcpld_p2s_data[109]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_3
assign scpld_to_mcpld_p2s_data[108]     = pal_gpu_fan4_prsnt             ;//BOARD_ID4
assign scpld_to_mcpld_p2s_data[107]     = pal_gpu_fan3_prsnt             ;//BOARD_ID3
assign scpld_to_mcpld_p2s_data[106]     = pal_gpu_fan2_prsnt             ;//BOARD_ID2
assign scpld_to_mcpld_p2s_data[105]     = pal_gpu_fan1_prsnt             ;//BOARD_ID1
assign scpld_to_mcpld_p2s_data[104]     = pal_gpu_fan4_foo               ;//BOARD_ID0
assign scpld_to_mcpld_p2s_data[103]     = pal_gpu_fan3_foo               ;//CHASSIS_ID2_N
assign scpld_to_mcpld_p2s_data[102]     = pal_gpu_fan2_foo               ;
assign scpld_to_mcpld_p2s_data[101]     = pal_gpu_fan1_foo               ;
assign scpld_to_mcpld_p2s_data[100:85]  = bmc_cpld_version               ;
assign scpld_to_mcpld_p2s_data[84]      = pcb_revision_1                 ;//PCB_REVISION_1
assign scpld_to_mcpld_p2s_data[83]      = pcb_revision_0                 ;//PCB_REVISION_0
assign scpld_to_mcpld_p2s_data[82]      = pca_revision_2                 ;//PCA_REVISION_2
assign scpld_to_mcpld_p2s_data[81]      = pca_revision_1                 ;//PCA_REVISION_1
assign scpld_to_mcpld_p2s_data[80]      = pca_revision_0                 ;
assign scpld_to_mcpld_p2s_data[79:64]   = mb_cpld2_ver                   ;
assign scpld_to_mcpld_p2s_data[63]      = i_pal_wdt_rst_n_r              ;
assign scpld_to_mcpld_p2s_data[62]      = TPM_MODULE_PRSNT_N             ;//TPM_PRSNT_N
assign scpld_to_mcpld_p2s_data[61]      = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[60]      = 1'b0                           ;//PAL_LCD_PRSNT
assign scpld_to_mcpld_p2s_data[59]      = PAL_M2_1_SEL_R                 ;//PAL_LCD_BUSY
assign scpld_to_mcpld_p2s_data[58]      = PAL_M2_1_PRSNT_N               ;
assign scpld_to_mcpld_p2s_data[57]      = PAL_M2_0_PRSNT_N               ;
assign scpld_to_mcpld_p2s_data[56]      = PAL_RISER2_PRSNT_N             ;
assign scpld_to_mcpld_p2s_data[55]      = PAL_RISER1_PRSNT_N             ;
assign scpld_to_mcpld_p2s_data[54]      = riser2_emc_alert_n             ;
assign scpld_to_mcpld_p2s_data[53]      = riser1_emc_alert_n             ;
assign scpld_to_mcpld_p2s_data[52]      = db_pal_ext_rst_n               ;
assign scpld_to_mcpld_p2s_data[51:44]   = sw                             ;
assign scpld_to_mcpld_p2s_data[43]      = cpu_nvme17_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[42]      = cpu_nvme16_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[41]      = cpu_nvme15_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[40]      = cpu_nvme14_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[39]      = cpu_nvme13_prsnt_n             ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[38]      = cpu_nvme12_prsnt_n             ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[37]      = cpu_nvme11_prsnt_n             ;//CPU1 D2 
assign scpld_to_mcpld_p2s_data[36]      = cpu_nvme10_prsnt_n             ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[35]      = CPU_NVME19_PRSNT_N             ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[34]      = CPU_NVME18_PRSNT_N             ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[33]      = cpu_nvme23_prsnt_n             ;//CPU1 D0 
assign scpld_to_mcpld_p2s_data[32]      = CPU_NVME22_PRSNT_N             ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[31]      = cpu_nvme7_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[30]      = cpu_nvme6_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[29]      = cpu_nvme5_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[28]      = cpu_nvme4_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[27]      = cpu_nvme3_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[26]      = cpu_nvme2_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[25]      = cpu_nvme1_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[24]      = cpu_nvme0_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[23]      = CPU_NVME9_PRSNT_N              ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[22]      = CPU_NVME8_PRSNT_N              ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[21]      = cpu_nvme25_prsnt_n             ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[20]      = cpu_nvme24_prsnt_n             ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[19]      = ocp_prsent_b7_n                ;
assign scpld_to_mcpld_p2s_data[18]      = ocp_prsent_b6_n                ;
assign scpld_to_mcpld_p2s_data[17]      = ocp_prsent_b5_n                ;
assign scpld_to_mcpld_p2s_data[16]      = ocp_prsent_b4_n                ;
assign scpld_to_mcpld_p2s_data[15]      = ocp_prsent_b3_n                ;
assign scpld_to_mcpld_p2s_data[14]      = ocp_prsent_b2_n                ;
assign scpld_to_mcpld_p2s_data[13]      = ocp_prsent_b1_n                ;
assign scpld_to_mcpld_p2s_data[12]      = ocp_prsent_b0_n                ;
assign scpld_to_mcpld_p2s_data[11]      = fan8_install_n                 ;
assign scpld_to_mcpld_p2s_data[10]      = fan7_install_n                 ;
assign scpld_to_mcpld_p2s_data[9]       = fan6_install_n                 ;
assign scpld_to_mcpld_p2s_data[8]       = fan5_install_n                 ;
assign scpld_to_mcpld_p2s_data[7]       = fan4_install_n                 ;
assign scpld_to_mcpld_p2s_data[6]       = fan3_install_n                 ;
assign scpld_to_mcpld_p2s_data[5]       = fan2_install_n                 ;
assign scpld_to_mcpld_p2s_data[4]       = fan1_install_n                 ;
assign scpld_to_mcpld_p2s_data[3]       = 1'b0                           ; 
assign scpld_to_mcpld_p2s_data[2]       = 1'b1                           ;
assign scpld_to_mcpld_p2s_data[1]       = 1'b0                           ; 
assign scpld_to_mcpld_p2s_data[0]       = 1'b1                           ;
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [255:0]                            mbcpld_to_bmccpld_p2s_data      ;
wire [255:0]                            bmccpld_to_mbcpld_s2p_data      ;
wire                                    cpld_sgpio_ld_n                 ;
wire                                    cpld_sgpio_clk                  ;

// CMU CPLD ---> MB CPLD
s2p_master #(.NBIT(256)) inst_cmu_to_mb_s2p(
    .clk        (clk_50m					    ),
    .warm_rst   (~pon_reset_n                   ),
    .cold_rst   (~pon_reset_n	                ),
    .tick       (t1us_tick		                ),
    .si         (i_PAL_BMC_SS_DATA_IN		    ),//SGPIO_MISO  Serial Signal input
    .po         (bmccpld_to_mbcpld_s2p_data     ),//Parallel Signal output
    .sld_n      (cpld_sgpio_ld_n		        ),//SGPIO_LOAD
    .sclk       (cpld_sgpio_clk 			    ) //SGPIO_CLK
);

assign o_PAL_BMC_SS_LOAD_N = cpld_sgpio_ld_n    ; //SGPIO_LOAD
assign o_PAL_BMC_SS_CLK    = cpld_sgpio_clk     ; //SGPIO_CLK

// MB CPLD  ---> CMU CPLD
p2s_slave #(.NBIT(256)) inst_mb_to_cmu_p2s(
    .clk        (clk_50m					    ),
    .rst        (~pon_reset_n				    ),
    .pi         (mbcpld_to_bmccpld_p2s_data	    ),//Parallel Signal input
    .so         (o_PAL_BMC_SS_DATA_OUT 		    ),//SGPIO_MISO Serial Signal output
    .sld_n      (cpld_sgpio_ld_n		        ),//SGPIO_LOAD
    .sclk       (cpld_sgpio_clk		            ) //SGPIO_CLK
);

// CMU CPLD ---> MB CPLD
assign i_bmc_hang_flag			         = bmccpld_to_mbcpld_s2p_data[67]   ;
assign i_pal_vga_rear_vcc_oc_n	         = bmccpld_to_mbcpld_s2p_data[66]   ;
assign board_id		                     = bmccpld_to_mbcpld_s2p_data[65:62];
assign pcb_version	                     = bmccpld_to_mbcpld_s2p_data[61:59];
assign i_pal_usb_rear_up_oc_n	         = bmccpld_to_mbcpld_s2p_data[58]   ;
assign i_pal_usb_rear_down_oc_n			 = bmccpld_to_mbcpld_s2p_data[57]   ;
assign i_vr_i2c_bmc_sel		             = bmccpld_to_mbcpld_s2p_data[56]   ;
assign i_vr_i2c_bmc_oe_n		         = bmccpld_to_mbcpld_s2p_data[55]   ;
assign i_peci_master_sel	             = bmccpld_to_mbcpld_s2p_data[54]   ;
assign i_pal_program_n		             = bmccpld_to_mbcpld_s2p_data[53]   ;
assign i_pal_bmc_tmp_alert_n		     = bmccpld_to_mbcpld_s2p_data[52]   ;
assign i_pal_bmc_rst_ind_n		         = bmccpld_to_mbcpld_s2p_data[51]   ;
assign i_pal_ifist_prsnt_n	             = bmccpld_to_mbcpld_s2p_data[50]   ;
assign i_pal_health_fan_ctrl		     = bmccpld_to_mbcpld_s2p_data[49]   ;
assign reserve_port1		             = bmccpld_to_mbcpld_s2p_data[48]   ;
assign db_i_pal_pgd_p3v3		         = bmccpld_to_mbcpld_s2p_data[47]   ;
assign db_i_pal_pgd_p1v8		         = bmccpld_to_mbcpld_s2p_data[46]   ;
assign db_i_pal_pgd_p1v2	             = bmccpld_to_mbcpld_s2p_data[45]   ;
assign db_i_pal_pgd_p1v1		         = bmccpld_to_mbcpld_s2p_data[44]   ;
assign db_i_pal_pgd_p0v8		         = bmccpld_to_mbcpld_s2p_data[43]   ;
assign i_pal_wdt_rst_n_r		         = bmccpld_to_mbcpld_s2p_data[42]   ;
assign cpld_date_mmdd	                 = bmccpld_to_mbcpld_s2p_data[41:26];
assign nc_port		                     = bmccpld_to_mbcpld_s2p_data[25]   ;
assign reserve_port                      = bmccpld_to_mbcpld_s2p_data[24:21];
assign lattice_cpld	 	                 = bmccpld_to_mbcpld_s2p_data[20:17];//Cpld Manufacturer
assign bmc_cpld_version 	             = bmccpld_to_mbcpld_s2p_data[16:1] ;
assign t4hz_clk_cmu	 	                 = bmccpld_to_mbcpld_s2p_data[0]    ;

//MB CPLD ---> CMU CPLD
assign mbcpld_to_bmccpld_p2s_data[27] 	 = rst_i2c0_mux_n                   ;
assign mbcpld_to_bmccpld_p2s_data[26] 	 = 1'b1                             ;//remote_xdp_pod_prsnt_n
assign mbcpld_to_bmccpld_p2s_data[25] 	 = 1'b1                             ;//pal_usb2_ocpdbg_oc_n_r
assign mbcpld_to_bmccpld_p2s_data[24] 	 = 1'b1                             ;//en_p3v3_stby_emmc 	            
assign mbcpld_to_bmccpld_p2s_data[23] 	 = 1'b0                             ;//pal_p5v_vga_rear_en_r	        
assign mbcpld_to_bmccpld_p2s_data[22]    = usb_en[2]                        ;//pal_p5v_usb_rear_up_en_r         
assign mbcpld_to_bmccpld_p2s_data[21]    = usb_en[3]                        ;//pal_p5v_usb_rear_down_en_r
assign mbcpld_to_bmccpld_p2s_data[20]    = ~rom_bmc_bk_rst                  ;
assign mbcpld_to_bmccpld_p2s_data[19]	 = ~rom_bmc_ma_rst                  ;
assign mbcpld_to_bmccpld_p2s_data[18]    = pal_pwrgd_cpu0_lvc3_r            ;
assign mbcpld_to_bmccpld_p2s_data[17]    = 1'b1                             ;//pal_bmc_uboot_en_n_r             
assign mbcpld_to_bmccpld_p2s_data[16]    = leakage_det_do_n                 ;
assign mbcpld_to_bmccpld_p2s_data[15]    = 1'b1                             ;//pal_plt_bmc_thermtrip_n_r        
assign mbcpld_to_bmccpld_p2s_data[14]    = st_steady_pwrok                  ;//remote_xdp_syspwrok_r            
assign mbcpld_to_bmccpld_p2s_data[13:12] = uart_mux_select                  ;//weihe
assign mbcpld_to_bmccpld_p2s_data[11:4]  = sw                               ;
assign mbcpld_to_bmccpld_p2s_data[3]     = DSD_UART_PRSNT_N                 ; 
assign mbcpld_to_bmccpld_p2s_data[2]     = rst_pal_extrst_r_n               ;
assign mbcpld_to_bmccpld_p2s_data[1]     = pal_vga_sel_n                    ;
assign mbcpld_to_bmccpld_p2s_data[0]     = t4hz_clk                         ;
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: RISER1 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [5:0]                          mb1_pvti_ss_count                       ;
wire [4:0]                          riser1_pvti_ss_count                    ;
wire [7:0]                          riser1_pvti_byte3                       ;
wire [7:0]                          riser1_pvti_byte2                       ;
wire [7:0]                          riser1_pvti_byte1                       ;
wire [7:0]                          riser1_pvti_byte0                       ;

wire                                riser1_cb_prsnt_slot1_n                 ;
wire                                riser1_cb_prsnt_slot2_n                 ;
wire                                riser1_cb_prsnt_slot3_n                 ;
wire                                riser1_pwr_det0                         ;
wire                                riser1_pwr_det1                         ;
wire                                riser1_pcb_rev0                         ;
wire                                riser1_pcb_rev1                         ;
wire                                riser1_pwr_alert_n                      ;
wire                                riser1_emc_alert_n                      ;
wire                                riser1_slot1_prsnt_n                    ;
wire                                riser1_slot2_prsnt_n                    ;
wire                                riser1_slot3_prsnt_n                    ;
wire [5:0]                          riser1_id                               ;
wire                                pal_riser1_pwrgd                        ;
wire                                pal_riser1_pe_wake_n                    ;

pvt_gpi #(
    .TOTAL_BIT_COUNT                (32                                     ),
    .DEFAULT_STATE                  (32'hFF_F3_FF_01                        ),             
    .NUMBER_OF_COUNTER_BITS         (5                                      )
) pvt_gpi_riser1_inst (
    .clk                            (clk_50m),
    .reset_n                        (pon_reset_n & (~i_PAL_RISER1_PRSNT_N)  ),
    .clk_ena                        (t16us_tick                             ),
    .serclk_in                      (o_PAL_RISER1_SS_CLK                    ),
    .par_load_in_n                  (o_PAL_RISER1_SS_LD_N                   ),
    .sdi                            (i_PAL_RISER1_SS_DATA_IN                ),
    .bit_idx_in                     (riser1_pvti_ss_count                   ),
    .bit_idx_out                    (riser1_pvti_ss_count                   ),
    .serclk_out                     (i_PAL_RISER1_SS_CLK                    ),
    .par_load_out_n                 (i_PAL_RISER1_SS_LD_N                   ),
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
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: RISER1 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: RISER2 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [5:0]                          mb2_pvti_ss_count                       ;
wire [4:0]                          riser2_pvti_ss_count                    ;
wire [7:0]                          riser2_pvti_byte3                       ;
wire [7:0]                          riser2_pvti_byte2                       ;
wire [7:0]                          riser2_pvti_byte1                       ;
wire [7:0]                          riser2_pvti_byte0                       ;

wire                                riser2_cb_prsnt_slot1_n                 ;
wire                                riser2_cb_prsnt_slot2_n                 ;
wire                                riser2_cb_prsnt_slot3_n                 ;
wire                                riser2_pwr_det0                         ;
wire                                riser2_pwr_det1                         ;
wire                                riser2_pcb_rev0                         ;
wire                                riser2_pcb_rev1                         ;
wire                                riser2_pwr_alert_n                      ;
wire                                riser2_emc_alert_n                      ;
wire                                riser2_slot1_prsnt_n                    ;
wire                                riser2_slot2_prsnt_n                    ;
wire                                riser2_slot3_prsnt_n                    ;
wire [5:0]                          riser2_id                               ;
wire                                pal_riser2_pwrgd                        ;
wire                                pal_riser2_pe_wake_n                    ;

pvt_gpi #(
  .TOTAL_BIT_COUNT                  (32                                     ),
  .DEFAULT_STATE                    (32'hFF_F3_FF_01                        ), //32'hFF_F3_FF_01            
  .NUMBER_OF_COUNTER_BITS           (5                                      )
) pvt_gpi_riser2_inst (
  .clk                              (clk_50m                                ),
  .reset_n                          (pon_reset_n & (~i_PAL_RISER2_PRSNT_N)  ),
  .clk_ena                          (t16us_tick                             ),
  .serclk_in                        (o_PAL_RISER2_SS_CLK                    ),
  .par_load_in_n                    (o_PAL_RISER2_SS_LD_N                   ),
  .sdi                              (i_PAL_RISER2_SS_DATA_IN                ),
  .bit_idx_in                       (riser2_pvti_ss_count                   ),
  .bit_idx_out                      (riser2_pvti_ss_count                   ),
  .serclk_out                       (o_PAL_RISER2_SS_CLK                    ),
  .par_load_out_n                   (o_PAL_RISER2_SS_LD_N                   ),
  .par_data                         ({riser2_pvti_byte3[7:0],riser2_pvti_byte2[7:0],riser2_pvti_byte1[7:0],riser2_pvti_byte0[7:0]})	               		
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
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: RISER2 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: main board SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/
pvt_gpi #(
	.TOTAL_BIT_COUNT                (48                                     ),
	.DEFAULT_STATE                  (48'h0                                  ),
	.NUMBER_OF_COUNTER_BITS         (6                                      )
) pvt_gpi_mb1_inst (
	.clk                            (clk_50m                                ),
	.reset_n                        (pon_reset_n                            ),
	.clk_ena                        (t16us_tick                             ),
	.serclk_in                      (PVT_SS_CLK_R                           ),
	.par_load_in_n                  (PVT_SS_LD_N_R                          ),
	.sdi                            (PVT_SS_DATI                            ),
	.bit_idx_in                     (mb1_pvti_ss_count                      ),
	.bit_idx_out                    (mb1_pvti_ss_count                      ),
	.serclk_out                     (PVT_SS_CLK_R                           ),
	.par_load_out_n                 (PVT_SS_LD_N_R                          ),
	.par_data                       ({cpu_nvme0_prsnt_n ,cpu_nvme1_prsnt_n ,cpu_nvme2_prsnt_n ,cpu_nvme3_prsnt_n ,
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
	.TOTAL_BIT_COUNT                (48),
	.DEFAULT_STATE                  (48'h0),
	.NUMBER_OF_COUNTER_BITS         (6)
) pvt_gpi_mb2_inst (
	.clk                            (clk_50m),
	.reset_n                        (pon_reset_n),
	.clk_ena                        (t16us_tick),
	.serclk_in                      (PVT_SS_CLK_1_R),
	.par_load_in_n                  (PVT_SS_LD_N_1_R),
	.sdi                            (PVT_SS_DATI_1),
	.bit_idx_in                     (mb2_pvti_ss_count),
	.bit_idx_out                    (mb2_pvti_ss_count),
	.serclk_out                     (PVT_SS_CLK_1_R),
	.par_load_out_n                 (PVT_SS_LD_N_1_R),
	.par_data                       ({sw[0]           ,sw[1]           ,sw[2]           ,sw[3]           ,
	                                  sw[4]           ,sw[5]           ,sw[6]           ,sw[7]           ,  //U180 DATA
					 			 
					                  ocp_prsent_b7_n ,ocp_prsent_b6_n ,ocp_prsent_b5_n ,ocp_prsent_b4_n ,
					                  ocp_prsent_b3_n ,ocp_prsent_b2_n ,ocp_prsent_b1_n ,ocp_prsent_b0_n ,    //U181 DATA	

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
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: main board SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: OCP1 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/
pvt_gpi #(
    .TOTAL_BIT_COUNT                (32),
    .DEFAULT_STATE                  (32'h7FFF_FFFE),
    .NUMBER_OF_COUNTER_BITS         (6)
) pvt_gpi_ocp1_inst (
    .clk                            (clk_50m),
    .reset_n                        (pon_reset_n & (~ocp1_prsnt_n)),
    .clk_ena                        (t16us_tick),
    .serclk_in                      (PAL_OCP1_SS_CLK_R),
    .par_load_in_n                  (PAL_OCP1_SS_LD_N_R),
    .sdi                            (PAL_OCP1_SS_DATA_IN_R),
    .bit_idx_in                     (ocp1_pvti_ss_count),
    .bit_idx_out                    (ocp1_pvti_ss_count),
    .serclk_out                     (PAL_OCP1_SS_CLK_R),
    .par_load_out_n                 (PAL_OCP1_SS_LD_N_R),
    .par_data                       ({ocp1_pvti_byte3[7:0], ocp1_pvti_byte2[7:0],ocp1_pvti_byte1[7:0], ocp1_pvti_byte0[7:0]})
);
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: OCP1 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: OCP2 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/
pvt_gpi #(
  .TOTAL_BIT_COUNT(32),
  .DEFAULT_STATE(32'h7FFF_FFFE),
  .NUMBER_OF_COUNTER_BITS(6)
) pvt_gpi_ocp2_inst (
  .clk           (clk_50m),
  .reset_n       (pon_reset_n & (~ocp2_prsnt_n)),
  .clk_ena       (t16us_tick),
  .serclk_in     (PAL_OCP2_SS_CLK_R),
  .par_load_in_n (PAL_OCP2_SS_LD_N_R),
  .sdi           (PAL_OCP2_SS_DATA_IN_R),
  .bit_idx_in    (ocp2_pvti_ss_count),
  .bit_idx_out   (ocp2_pvti_ss_count),
  .serclk_out    (PAL_OCP2_SS_CLK_R),
  .par_load_out_n(PAL_OCP2_SS_LD_N_R),
  .par_data      ({ocp2_pvti_byte3[7:0], ocp2_pvti_byte2[7:0],ocp2_pvti_byte1[7:0], ocp2_pvti_byte0[7:0]})
);
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: OCP2 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/
endmodule


/* synthesis LOC = "T14"*/
/* synthesis LOC = "U15"*/
/* synthesis LOC = "Y19"*/
/* synthesis LOC = "W19"*/
/* synthesis LOC = "G14"*/ // 未使用 
/* synthesis LOC = "F14"*/ // 未使用 
/* synthesis LOC = "B19"*/ // 未使用 
/* synthesis LOC = "A20"*/ // 未使用 
/* synthesis LOC  = "P2 "*/ // 未使用  
/* synthesis LOC = "U2 "*/ // 未使用
/* synthesis LOC = "K20"*/ // 未使用
/* synthesis LOC = "L19"*/ // 未使用
/* synthesis LOC = "P3 "*/ // 未使用
/* synthesis LOC = "P4 "*/ // 未使用
/* synthesis LOC = "Y3"*/  // 未使用
/* synthesis LOC = "V6"*/  // 未使用
/* synthesis LOC = "U6"*/  // 未使用
/* synthesis LOC = "A18"*/ // 未使用 
/* synthesis LOC = "N4"*/ // 未使用
/* synthesis LOC = "B3"*/ // 未使用 
/* synthesis LOC = "L3"*/ // 未使用
/* synthesis LOC = "D6"*/ // 未使用 
/* synthesis LOC = "B9 "*/ // 未使用
/* synthesis LOC = "T1 "*/ // 未使用
/* synthesis LOC = "L14"*/ // 未使用
/* synthesis LOC = "M20"*/ // 未使用                    
/* synthesis LOC = "A1 "*/ // 未使用 
/* synthesis LOC = "G7 "*/ // 未使用 
/* synthesis LOC = "F7 "*/ // 未使用 
/* synthesis LOC = "B2 "*/ // 未使用                                                   
                                                      
/* synthesis LOC = "F10"*/ // 未使用 
/* synthesis LOC = "B11"*/ // 未使用 
/* synthesis LOC = "P18"*/ // 未使用
/* synthesis LOC = "F1 "*/ // 未使用

/* synthesis LOC = "G17"*/ // 未使用
/* synthesis LOC = "C20"*/ // 未使用                                        
/* synthesis LOC = "J16"*/ // 未使用                                                  
/* synthesis LOC = "H20"*/ // 未使用
/* synthesis LOC = "H18"*/ // 未使用
/* synthesis LOC = "H19"*/ // 未使用
/* synthesis LOC = "J17"*/ // 未使用

/* synthesis LOC = "U17"*/ // 未使用
/* synthesis LOC = "V17"*/ // 未使用
/* synthesis LOC = "K5 "*/ // 未使用
/* synthesis LOC = "G13"*/ // 未使用
/* synthesis LOC = "A17"*/ // 未使用 
// output  o_PAL2_TDO                            /* synthesis LOC = "E8"*/,// from  CPLD_S                                           to  CPU1_JTAG / J21_G97V22312HR                       default 1  // PAL2 TDO 信号
// input   i_PAL2_TDI                            /* synthesis LOC = "C7"*/,// from  CPU1_JTAG / J21_G97V22312HR                      to  CPLD_S                                           default 1  // PAL2 TDI 信号
                                                 /* synthesis LOC = "A7"*/ // 未使用 
// input   i_TPM_PP_R                            /* synthesis LOC = "B8"*/,// from  TPM_MODULE / U55_TPM_TCG2V1_23_4000_TR           to  CPLD_S                                           default 1  // TPM PP 信号
// input   i_PAL2_TCK                            /* synthesis LOC = "C9"*/,// from  CPU1_JTAG / J21_G97V22312HR                      to  CPLD_S                                           default 1  // PAL2 TCK 信号
// input   i_PAL2_TMS                            /* synthesis LOC = "D9"*/,// from  CPU1_JTAG / J21_G97V22312HR                      to  CPLD_S                                           default 1  // PAL2 TMS 信号
                                                 /* synthesis LOC = "B12"*/ // 未使用 