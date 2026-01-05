module Tieta_Feiteng_1001_top(
    // 系统时钟
    input   i_CLK_C42_IN_25M                        /* synthesis LOC  = "U1" */,// from  PLL                                          to  CPLD_S                                           default 1  // 25M 时钟 信号 CK440
                                                    /* synthesis LOC  = "U2 "*/ // 未使用

    /* begin: I2C */
    input   i_BMC_I2C3_PAL_S_SCL1_R                 /* synthesis LOC = "B4"*/ ,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SCL1 信号
    inout   io_BMC_I2C3_PAL_S_SDA1_R                /* synthesis LOC = "E7"*/ ,// from  BMC_I2C_MUX1 / U69                           to  CPLD_S                                           default 1  // BMC I2C3 PAL S SDA1 信号
    input   i_CPU0_D0_I2C1_PE_STRAP_SCL             /* synthesis LOC = "C6"*/ ,// from  CPU_I2C_LEVEL_TRAN / U97_CA9617MMR           to  CPLD_S                                           default 1  // CPU0 D0 I2C1 PE STRAP SCL 信号
    inout   io_CPU0_D0_I2C1_PE_STRAP_SDA            /* synthesis LOC = "A6"*/ ,// from  CPU_I2C_LEVEL_TRAN / U97_CA9617MMR           to  CPLD_S                                           default 1  // CPU0 D0 I2C1 PE STRAP SDA 信号    
    input   i_CPU1_D0_I2C1_PE_STRAP_SCL             /* synthesis LOC = "R17"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C             to  CPLD_S                                           default 1  // CPU1 D0 I2C1 PE STRAP SCL 信号
    inout   io_CPU1_D0_I2C1_PE_STRAP_SDA            /* synthesis LOC = "N14"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C             to  CPLD_S                                           default 1  // CPU1 D0 I2C1 PE STRAP SDA 信号
    /* end: I2C */

    /* begin: CPLD_M 与 CPLD_S 之间的交换信号 */
    input   i_CPLD_M_S_EXCHANGE_S1                  /* synthesis LOC = "V19"*/,// from  CPLD_M                                       to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    input   i_CPLD_M_S_EXCHANGE_S3                  /* synthesis LOC = "G8"*/ ,// from  CPLD_M                                       to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
    input   i_CPLD_M_S_EXCHANGE_S4                  /* synthesis LOC = "A3"*/ ,// from  CPLD_M                                       to  CPLD_S                                           default 1  // CPLD 主从 交换 信号
                                                    /* synthesis LOC = "D6"*/ // 未使用 
    input   i_CPLD_M_S_EXCHANGE_S5                  /* synthesis LOC = "D7"*/ ,// from  CPLD_M                                       to  CPLD_S                                           default 1  // CPLD 主从 交换 信号

    /* end: CPLD_M 与 CPLD_S 之间的交换信号 */

    /* begin: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */
    input   i_CPLD_M_S_SGPIO_LD_N                   /* synthesis LOC = "A2"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO 加载使能 信号    
    input   i_CPLD_M_S_SGPIO_MOSI                   /* synthesis LOC = "A4"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO MOSI 信号

    output  o_CPLD_M_S_SGPIO_MISO_R                 /* synthesis LOC = "A8"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO MISO 信号

    output  i_CPLD_M_S_SGPIO1_MISO_R                /* synthesis LOC = "F9"*/,// from  CPLD_M                                         to  CPLD_S                                           default 1  // CPLD 主从 SGPIO1 MISO 信号
    

    /* end: SGPIO 信号, CPLD_S -> CPLD_M, CPLD_M -> CPLD_S */


    /* begin: GPIO CPU0/1 D0/D1相关信号 */
    input   i_CPU0_D0_TEMP_OVER                      /* synthesis LOC = "C2"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D0 温度 过高 信号
    input   i_CPU0_D1_TEMP_OVER                      /* synthesis LOC = "J6"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D1 温度 过高 信号


    /* end: GPIO CPU0/1 D0/D1相关信号 */

    /* begin: UART相关信号 */
    input   i_CPU0_D0_UART1_TX                       /* synthesis LOC = "G3"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D0 UART1 发送 信号
    input   i_CPU0_D0_UART_SOUT                      /* synthesis LOC = "G1"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D0 UART 发送 信号
    input   i_CPU0_D1_UART1_TX                       /* synthesis LOC = "E2"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU0 D1 UART1 发送 信号

    /* end: UART相关信号 */

    /* begin: CPU芯片的MCIO信号相关 */
    input   i_CPU0_MCIO0_CABLE_ID0_R                 /* synthesis LOC = "E14"*/,// from  CPU0_MCIO_0/0 / J27_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID0 信号
    input   i_CPU0_MCIO0_CABLE_ID1_R                 /* synthesis LOC = "D1 "*/,// from  CPU0_MCIO_0/1 / J28_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID1 信号
    input   i_CPU0_MCIO2_CABLE_ID0_R                 /* synthesis LOC = "C14"*/,// from  CPU0_MCIO_2/0 / J23_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 MCIO2 电缆 ID0 信号
    input   i_CPU0_MCIO2_CABLE_ID1_R                 /* synthesis LOC = "C16"*/,// from  CPU0_MCIO_2/1 / J26_G97V22312HR               to  CPLD_S                                          default 1  // CPU0 MCIO2 电缆 ID1 信号
                                                     /* synthesis LOC = "G13"*/ // 未使用 
    input   i_CPU0_MCIO3_CABLE_ID0_R                 /* synthesis LOC = "F12"*/,// from  CPU0_MCIO_3/0 / J21_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO3 电缆 ID0 信号
                                                     /* synthesis LOC = "A17"*/ // 未使用 
    input   i_CPU0_MCIO3_CABLE_ID1_R                 /* synthesis LOC = "G12"*/,// from  CPU0_MCIO_3/1 / J20_G97V22312HR                to  CPLD_S                                           default 1  // CPU0 MCIO3 电缆 ID1 信号

    /* end:   CPU芯片的MCIO信号相关 */


    /* begin: DEBUG 信号 */
    input   i_CABLE_PRSNT_N                         /* synthesis LOC  = "T17"*/,// from  J29_10217724B001                             to  CPLD_S                                           default 1  // 电缆 设备存在 信号
                                                    /* synthesis LOC  = "U17"*/ // 未使用
                                                    /* synthesis LOC  = "V17"*/ // 未使用
    input   i_CHASSIS_ID0_N                         /* synthesis LOC = "E20"*/,// from  ?CHASSIS_ID?                                 to  CPLD_S                                           default 1  // 机箱 ID0 信号                        
    input   i_CHASSIS_ID1_N                         /* synthesis LOC = "K14"*/,// from  ?CHASSIS_ID?                                 to  CPLD_S                                           default 1  // 机箱 ID1 信号


    /* end: DEBUG 信号 */


output  o_CPU_MCIO0_GPU_THROTTLE_N_R	          /* synthesis LOC = "W1"*/ ,// from  CPLD_S                                        to  CPU0_MCIO_0/1 / J18_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
output	o_PAL_RST_TPM_N_R	                      /* synthesis LOC = "Y1"*/ ,// from  CPLD_S                                        to  TPM/ J25_323114MG4FBK00R01                       default 0  // TPM模块 复位 信号 
                                                  /* synthesis LOC = "R6"*/ // 未使用
output	o_PAL_BMC_UART1_RX	                      /* synthesis LOC = "T6"*/ ,// from  CPLD_S                                        to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC UART1 接收 信号
output	o_PAL_TPM_DRQ1_N	                      /* synthesis LOC = "W2"*/ ,// from  CPLD_S                                        to  TPM/ J25_323114MG4FBK00R01                       default 1  // TPM模块 DRQ1 信号, TPM 模块向 PCH 发起的 DMA 请求信号                                              
output	o_CPU_MCIO2_GPU_THROTTLE_N_R	          /* synthesis LOC = "Y2"*/ ,// from  CPLD_S                                        to  TPM/ J25_323114MG4FBK00R01                       default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号                                                
output	o_PAL_BMC_SS_LOAD_N	                      /* synthesis LOC = "P7"*/ ,// from  CPLD_S                                        to  GENZ_168PIN/J98_5653E5-001H1020T                 default 0  // “PCH（平台控制器中心）向 BMC（基板管理控制器）发送的串行信号加载使能信号 
output	o_PAL_BMC_SS_DATA_OUT	                  /* synthesis LOC = "R7"*/ ,// from  CPLD_S                                        to  GENZ_168PIN/J98_5653E5-001H1020T                 default 0  // “PCH（平台控制器中心）向 BMC（基板管理控制器）发送的串行数据信号”
output	o_CPU_MCIO3_GPU_THROTTLE_N_R	          /* synthesis LOC = "W3"*/ ,// from  CPLD_S                                        to  CPU0_MCIO_0/1 / J18_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
                                                  /* synthesis LOC = "Y3"*/  // 未使用
                                                  /* synthesis LOC = "V6"*/  // 未使用
                                                  /* synthesis LOC = "U6"*/  // 未使用
output  o_PCA_REVISION_0                          /* synthesis LOC = "W4"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 0 信号 
output  o_BOARD_ID1                               /* synthesis LOC = "Y4"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID1 信号
output  o_BOARD_ID0                               /* synthesis LOC = "P8"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID0 信号
output  o_PCB_REVISION_0                          /* synthesis LOC = "R8"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCB 修订版本 0 信号
output  o_PCB_REVISION_1                          /* synthesis LOC = "W5"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCB 修订版本 1 信号
output  o_PCA_REVISION_2                          /* synthesis LOC = "Y5"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 2 信号
output  o_PCA_REVISION_1                          /* synthesis LOC = "T7"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // PCA 修订版本 0 信号
output  o_BOARD_ID4                               /* synthesis LOC = "T8"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID4 信号
output  o_BOARD_ID3                               /* synthesis LOC = "W6"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID3 信号
output  o_BOARD_ID2                               /* synthesis LOC = "Y6"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID2 信号
output  o_PAL_UART4_OCP_DEBUG_TX                  /* synthesis LOC = "P9"*/ ,// from  CPLD_S                                        to  RISER_AUX/J16                                    default 1  // OCP 调试 UART4 发送 信号
output  o_Riser1_TOD_UART_TXD_R	                  /* synthesis LOC = "R9"*/ ,// from  CPLD_S                                        to  RISER1/J1_G64V3421MHR                            default 1  // Riser1 TOD UART 发送 信号
input   i_Riser1_TOD_UART_RXD_R                   /* synthesis LOC = "W7"*/ ,// from  RISER1/J1_G64V3421MHR                         to  CPLD_S                                           default 1  // Riser1 TOD UART 接收 信号
output  o_Riser2_TOD_UART_TXD_R	                  /* synthesis LOC = "Y7"*/ ,// from  CPLD_S                                        to  RISER2/J39_G64V3421MHR                           default 1  // Riser1 TOD UART 发送 信号
input   i_Riser2_TOD_UART_RXD_R                   /* synthesis LOC = "V8"*/ ,// from  RISER2/J39_G64V3421MHR                         to  CPLD_S                                          default 1  // Riser1 TOD UART 接收 信号
output  o_BOARD_ID5                               /* synthesis LOC = "U9"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID5 信号
input   i_PAL_PWR_SW_IN_N                         /* synthesis LOC = "W8"*/ ,// from  CPLD_S_UART_LED_SW                            to  CPLD_S                                           default 1  // 电源开关 输入 信号
output  o_BOARD_ID6                               /* synthesis LOC = "Y8"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID6 信号
output  o_BOARD_ID7                               /* synthesis LOC = "V9"*/ ,// from  CPLD_S                                        to  BMC                                              default 0  // 主板 ID7 信号
input   i_PAL_BMC_NCSI_CLK_50M_R                  /* synthesis LOC = "T9"*/ ,// from  GENZ_168PIN/J98_5653E5-001H1020T              to  CPLD_S_UART_LED_SW                               default 1  // BMC NCSI 时钟 50M 信号

input   i_CPU_NVME0_PRSNT_N                       /* synthesis LOC = "W9"*/ ,// from  CPU0_MCIO_0/1 / J18_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 NVME0 设备存在 信号
input   i_CPU_NVME1_PRSNT_N                       /* synthesis LOC = "Y9"*/ ,// from  CPU0_MCIO_0/1 / J18_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 NVME1 设备存在 信号
input   i_CPU_NVME4_PRSNT_N                       /* synthesis LOC = "P10"*/,// from  CPU1_MCIO_0/1 / J20_G97V22312HR               to  CPLD_S                                           default 1  // CPU1 NVME4 设备存在 信号
input   i_CPU_NVME5_PRSNT_N                       /* synthesis LOC = "R10"*/,// from  CPU1_MCIO_0/1 / J20_G97V22312HR               to  CPLD_S                                           default 1  // CPU1 NVME5 设备存在 信号
input   i_CPU_NVME6_PRSNT_N                       /* synthesis LOC = "Y10"*/,// from  CPU1_MCIO_0/1 / J19_G97V22312HR               to  CPLD_S                                           default 1  // CPU1 NVME6 设备存在 信号
input   i_CPU_NVME7_PRSNT_N                       /* synthesis LOC = "W10"*/,// from  CPU1_MCIO_0/1 / J19_G97V22312HR               to  CPLD_S                                           default 1  // CPU1 NVME7 设备存在 信号
input   i_CPU_NVME10_PRSNT_N                      /* synthesis LOC = "U10"*/,// from  CPU0_MCIO_0/1 / J21_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 NVME10 设备存在 信号
input   i_CPU_NVME11_PRSNT_N                      /* synthesis LOC = "V10"*/,// from  CPU0_MCIO_0/1 / J21_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 NVME11 设备存在 信号
input   i_JACK_CPU0_D0_UART_SIN                   /* synthesis LOC = "Y11"*/,// from  CPU0_UART / J614                              to  CPLD_S                                           default 1  // CPU0 JACK UART 接收 信号
input   i_P12V_STBY_EFUSE_PG                      /* synthesis LOC = "W11"*/,// from  CURRENT_DET1 / P12V_STBY                      to  CPLD_S                                           default 1  // 12V 待机 EFUSE 电源良好 信号
input   i_PAL_PGD_USB_UPD1_P1V1                   /* synthesis LOC = "U11"*/,// from  PEX_USB_1/SGM61030_3V3to1v1                   to  CPLD_S                                           default 1  // USB_UPD1 P1V1 电源良好 信号
input   i_PAL_P12V_STBY_EFUSE_FLTB                /* synthesis LOC = "T10"*/,// from  CURRENT_DET1 / P12V_STBY                      to  CPLD_S                                           default 1  // 12V 待机 EFUSE 故障 信号    
output  o_JACK_CPU0_UART1_TX                      /* synthesis LOC = "Y12"*/,// from  CPLD_S                                        to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART 发送 信号
output  o_JACK_CPU0_D0_UART_SOUT                  /* synthesis LOC = "W12"*/,// from  CPLD_S                                        to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART 发送 信号
input   i_CPU_NVME14_PRSNT_N                      /* synthesis LOC = "P11"*/,// from  CPU1_MCIO_0/1 / J23_G97V22312HR               to  CPLD_S                                           default 1  // CPU1 NVME14 设备存在 信号
input   i_CPU_NVME15_PRSNT_N                      /* synthesis LOC = "R11"*/,// from  CPU1_MCIO_0/1 / J23_G97V22312HR               to  CPLD_S                                           default 1  // CPU1 NVME15 设备存在 信号
output  o_CPU_MCIO7_GPU_THROTTLE_N_R              /* synthesis LOC = "Y13"*/,// from  CPLD_S                                        to  CPU1_MCIO_2/3 / J23_G97V22312HR                  default 0  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
output  o_JACK_CPU1_UART1_TX	                  /* synthesis LOC = "W13"*/,// from  CPLD_S                                        to  CPU1_UART / J613                                 default 1  // CPU1 JACK UART 发送 信号
input   i_CPU_NVME16_PRSNT_N                      /* synthesis LOC = "V12"*/,// from  CPU0_MCIO_0/1 / J24_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 NVME16 设备存在 信号
input   i_CPU0_VIN_SNS_ALERT                      /* synthesis LOC = "V13"*/,// from  CURRENT_DET0 / U57_TPA626_VR_S                to  CPLD_S                                           default 1  // CPU0 输入电压 传感器 告警 信号
output  o_LED8_N                                  /* synthesis LOC = "Y14"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED8 灯 信号
output  o_LED7_N                                  /* synthesis LOC = "W14"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED7 灯 信号
input   i_PAL_UPD72020_2_ALART                    /* synthesis LOC = "U12"*/,// from  PEX_USB_UPD720201_2 / U63                     to  CPLD_S                                           default 1  // UPD720201_2 告警 信号
output  o_LED6_N                                  /* synthesis LOC = "T11"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED6 灯 信号
output  o_LED5_N                                  /* synthesis LOC = "Y15"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED5 灯 信号
input	i_PAL_EXT_RST_N	                          /* synthesis LOC = "W15"*/,// from  CPLD_S_UART_LED_SW                            to  CPLD_S                                           default 1  // 外部 复位 信号
output  o_PAL_CPU0_I3C_SPD_SEL                    /* synthesis LOC = "P12"*/,// from  CPLD_S                                        to  CPU0_I3C_SPD_SEL / J14_G97V22312HR               default 1  // CPU0 I3C SPD 选择 信号
input   i_CPU_NVME17_PRSNT_N                      /* synthesis LOC = "R12"*/,// from  CPU0_MCIO_0/1 / J24_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 NVME17 设备存在 信号
output  o_CPU_MCIO5_GPU_THROTTLE_N_R              /* synthesis LOC = "Y16"*/,// from  CPLD_S                                        to  CPU0_MCIO_0 / J21_G97V22312HR                    default 1  // CPU 与 GPU 之间的 “热管理 功耗控制” 边带信号
input   i_JACK_CPU1_D0_UART_SIN                   /* synthesis LOC = "W16"*/,// from  CPU1_UART / J613                              to  CPLD_S                                           default 1  // CPU1 JACK UART 接收 信号
input   i_JACK_CPU0_UART1_RX                      /* synthesis LOC = "T12"*/,// from  CPLD_S                                        to  CPU0_UART / J614                                 default 1  // CPU0 JACK UART1 接收 信号
output  o_LED4_N                                  /* synthesis LOC = "T13"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED4 灯 信号
output  o_LED3_N                                  /* synthesis LOC = "Y17"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED3 灯 信号
input   i_PAL_UPD2_SMIB_N                         /* synthesis LOC = "W17"*/,// from  PEX_USB_UPD720201_2 / U63                     to  CPLD_S                                           default 1  // UPD2 SMIB 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的 SMI 中断请求信号
output  o_JACK_CPU1_D0_UART_SOUT                  /* synthesis LOC = "P13"*/,// from  CPLD_S                                        to  CPU1_UART / J613                                 default 1  // CPU1 JACK UART 发送 信号
output  o_LED2_N                                  /* synthesis LOC = "R13"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED2 灯 信号
output  o_LED1_N                                  /* synthesis LOC = "V14"*/,// from  CPLD_S                                        to  CPLD_S_UART_LED_SW                               default 1  // LED1 灯 信号
input   i_PAL_P12V_RISER1_VIN_PG                  /* synthesis LOC = "U14"*/,// from  P12V_RISER1_VIN                               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 良好 信号
input   i_PAL_P12V_RISER1_VIN_FLTB                /* synthesis LOC = "V15"*/,// from  P12V_RISER1_VIN                               to  CPLD_S                                           default 1  // 12V Riser1 输入电压 故障 信号
input   i_PAL_P12V_RISER2_VIN_PG                  /* synthesis LOC = "V16"*/,// from  P12V_RISER2_VIN                               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 良好 信号
input   i_PAL_P12V_RISER2_VIN_FLTB                /* synthesis LOC = "Y18"*/,// from  P12V_RISER2_VIN                               to  CPLD_S                                           default 1  // 12V Riser2 输入电压 故障 信号
output  o_PAL_P12V_STBY_EFUSE_EN_R                /* synthesis LOC = "W18"*/,// from  CPLD_S                                        to  CURRENT_DET1 / P12V_STBY                         default 1  // 12V 待机 EFUSE 使能 信号
                                                  /* synthesis LOC = "T14"*/
                                                  /* synthesis LOC = "U15"*/
                                                  /* synthesis LOC = "Y19"*/
                                                  /* synthesis LOC = "W19"*/
output  o_PAL_UPD1_PONRST_N_R                     /* synthesis LOC = "P14"*/,// from  CPLD_S                                       to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 PONRST_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的上电复位信号
input   i_P12V_STBY_SNS_ALERT                     /* synthesis LOC = "R14"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                           default 1  // 12V 待机 传感器 告警 信号
input   i_PAL_S_SN                                /* synthesis LOC = "Y20"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                           default 1  // S_SN 信号 UPD1/UPD2 序列号 信号
input   i_JACK_CPU1_UART1_RX                      /* synthesis LOC = "T16"*/,// from  CPU1_UART / J613                             to  CPLD_S                                           default 1  // CPU1 JACK UART1 接收 信号
input   i_PAL_UPD2_PEWAKE_N                       /* synthesis LOC = "R15"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR      to  CPLD_S                                           default 1  // UPD2 PEWAKE_N 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的电源唤醒信号


// 3.3V BANK
output  o_PAL_RISER2_SLOT_PERST_N_R               /* synthesis LOC = "D17"*/,// from  CPLD_S                                       to  RISER2/J39_G64V3421MHR                           default 1  // Riser2 插槽复位 信号
output  o_N1_ACT                                  /* synthesis LOC = "C18"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 活动 指示灯 信号
output  o_N1_100M                                 /* synthesis LOC = "F15"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 100M 指示灯 信号
output  o_N1_1000M                                /* synthesis LOC = "G15"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N1 网口 1000M 指示灯 信号
input   i_REAR_BP_SNS_ALERT                       /* synthesis LOC = "C19"*/,// from  CURRENT_DET1                                 to  CPLD_S                                           default 1  // 后板 传感器 告警 信号
output  o_CPU1_RISER2_9548_RST_N_R                /* synthesis LOC = "E17"*/,// from  CPLD_S                                       to  RISER2/J39_G64V3421MHR                           default 1  // CPU1 Riser2 9548 复位 信号
input   i_PAL_RISER2_WIDTH_R                      /* synthesis LOC = "F16"*/,// from  RISER2/J39_G64V3421MHR                       to  CPLD_S                                           default 1  // Riser2 宽度 信号
input   i_PAL_RISER2_MODE_R                       /* synthesis LOC = "D18"*/,// from  RISER2/J39_G64V3421MHR                       to  CPLD_S                                           default 1  // Riser2 模式 信号
output  o_PAL_RJ45_1_ACT_LED                      /* synthesis LOC = "B20"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_1 网口 活动 指示灯 信号
                                                  /* synthesis LOC = "C20"*/ // 未使用
output  o_N0_ACT                                  /* synthesis LOC = "H14"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 活动 指示灯 信号
output  o_N0_100M                                 /* synthesis LOC = "H15"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 100M 指示灯 信号
output  o_N0_1000M                                /* synthesis LOC = "D19"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // N0 网口 1000M 指示灯 信号
output  o_PAL_RJ45_2_1000M_LED                    /* synthesis LOC = "F17"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_2 网口 1000M 指示灯 信号
output  o_PAL_RJ45_2_100M_LED                     /* synthesis LOC = "D20"*/,// from  CPLD_S                                       to  U20_WX1860A2                                     default 1  // RJ45_1 网口 100M 指示灯 信号
input   i_PAL_RISER1_SLOT_PERST_N_R               /* synthesis LOC = "E19"*/,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser1 插槽复位 信号
output  o_PAL_RISER2_SS_LD_N                      /* synthesis LOC = "G16"*/,// from  CPLD_S                                       to  RISER2/U240_SGM6505HYTQF24G_TR                   default 1  // Riser2 串行信号加载使能 信号
output  o_PAL_RJ45_2_ACT_LED                      /* synthesis LOC = "F18"*/,// from  CPLD_S                                       to  J32_AC7412_3557_004_H0                           default 1  // RJ45_2 网口 活动 指示灯 信号
                                                  /* synthesis LOC = "G17"*/ // 未使用
output  o_PAL_RJ45_1_1000M_LED                    /* synthesis LOC = "F19"*/,// from  CPLD_S                                       to  J2_AC7412_3557_004_H0                            default 1  // RJ45_1 网口 1000M 指示灯 信号
output  o_PAL_RJ45_1_100M_LED                     /* synthesis LOC = "F20"*/,// from  CPLD_S                                       to  J2_AC7412_3557_004_H0                            default 1  // RJ45_1 网口 100M 指示灯 信号
output  o_CPU0_RISER1_9548_RST_N_R                /* synthesis LOC = "J14"*/,// from  CPLD_S                                       to  RISER1/J1_G64V3421MHR                            default 1  // CPU0 Riser1 9548 复位 信号     
output	o_PAL_LED_HEL_GR_R	                      /* synthesis LOC = "J15"*/,// from  CPLD_S                                       to  SYS STATUS LED                                   default 1  // HEL 绿色 指示灯 信号
input   i_PAL_BMC_UART4_RX                        /* synthesis LOC = "G19"*/,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // BMC UART4 接收 信号
output  o_PAL_BMC_UART4_TX                        /* synthesis LOC = "H17"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC UART4 发送 信号    
input   i_PAL_RISER1_WIDTH_R                      /* synthesis LOC = "H16"*/,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser1 宽度 信号
                                                  /* synthesis LOC = "H20"*/ // 未使用
                                                  /* synthesis LOC = "H18"*/ // 未使用
                                                  /* synthesis LOC = "H19"*/ // 未使用
                                                  /* synthesis LOC = "J17"*/ // 未使用
output  o_PAL_RISER2_SS_CLK_R                     /* synthesis LOC = "H20"*/,// from  CPLD_S                                       to  RISER2/U240_SGM6505HYTQF24G_TR                   default 1  // Riser2 串行时钟 信号                                              
output  o_PAL_LED_HEL_RED_R                       /* synthesis LOC = "J18"*/,// from  CPLD_S                                       to  SYS STATUS LED                                   default 1  // HEL 红色 指示灯 信号
                                                  /* synthesis LOC = "J16"*/ // 未使用
output  o_PAL_UPD2_P3V3_EN_R                      /* synthesis LOC = "K15"*/,// from  CPLD_S                                       to  PEX_USB_UPD720201_2 / U63                        default 1  // UPD2 P3V3 电源使能 信号
input   i_PAL_M2_1_PRSNT_N                        /* synthesis LOC = "J19"*/,// from  M2_SATA_PORT/J26_APCI0556_P003A              to  CPLD_S                                           default 1  // M.2_1 设备存在 信号
input   i_PAL_RISER1_MODE_R                       /* synthesis LOC = "J20"*/,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser1 模式 信号
output  o_PAL_CK440_OE_N_R                        /* synthesis LOC = "K17"*/,// from  CPLD_S                                       to  CK440_CLKER / U70_RS2CG440ZUDE                   default 1  // CK440 输出使能 信号               
output  o_MCIO11_RISER1_PERST2_N                  /* synthesis LOC = "K18"*/,// from  CPLD_S                                       to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // MCIO11 Riser1 插槽复位2 信号
output  o_PAL_WX1860_NCSI_CLK_50M_R               /* synthesis LOC = "K19"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // WX1860 NCSI 时钟 50M 信号
                                                  /* synthesis LOC = "K20"*/ // 未使用


output  o_PAL_UPD2_PORNRST_N_R                    /* synthesis LOC = "K16"*/,// from  CPLD_S                                       to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 PORNRST_N 信号 PCH（平台控制器中心）向第 2 路更新通道（UPD2）发送的上电复位信号
output  o_PAL_WX1860_NCSI_SW_EN_N_R               /* synthesis LOC = "L17"*/,// from  CPLD_S                                       to  U38 -- U20WX1869A2                               default 1  // WX1860 NCSI 开关使能 信号
                                                  /* synthesis LOC = "L19"*/ // 未使用
output  o_PAL_UPD2_P1V1_EN_R                      /* synthesis LOC = "L20"*/,// from  CPLD_S                                       to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 P1V1 电源使能 信号
                                                  /* synthesis LOC = "L14"*/ // 未使用
input   i_PAL_UART4_OCP_DEBUG_RX                  /* synthesis LOC = "L15"*/,// from  RISER_AUX/J16                                to  CPLD_S                                           default 1  // OCP 调试 UART4 接收 信号
                                                  /* synthesis LOC = "M20"*/ // 未使用
output  o_RST_I2C2_MUX_N_R                        /* synthesis LOC = "M19"*/,// from  CPLD_S                                       to  BMC_I2C_MUX1 / U53_CA9545MTR                     default 1  // I2C2 复位 多路复用器 信号
input   i_P12V_RISER1_VIN_SNS_ALERT               /* synthesis LOC = "L16"*/,// from  P12V_RISER1_VIN/U25_TPA626_VR_S              to  CPLD_S                                           default 1  // 12V Riser1 输入电压 传感器 告警 信号
input   i_P12V_RISER2_VIN_SNS_ALERT               /* synthesis LOC = "M18"*/,// from  P12V_RISER2_VIN/U28_TPA626_VR_S              to  CPLD_S                                           default 1  // 12V Riser2 输入电压 传感器 告警 信号
input   i_CPU1_VIN_SNS_ALERT                      /* synthesis LOC = "M17"*/,// from  CURRENT_DET0 / U60_TPA626_VR_S               to  CPLD_S                                           default 1  // CPU1 输入电压 传感器 告警 信号
output  o_PAL_SPI_SWITCH_EN_R                     /* synthesis LOC = "N20"*/,// from  CPLD_S                                       to  BIOS_FALSH0 / U37_SGM6505HYTQF24G_TR             default 1  // SPI 开关 使能 信号
output  o_PAL_LED_PWRBTN_GR_R                     /* synthesis LOC = "M16"*/,// from  CPLD_S                                       to  PWR BTN&LED                                      default 1  // 电源按钮 绿色 指示灯 信号
output  o_PAL_LED_PWRBTN_AMBER_R                  /* synthesis LOC = "N19"*/,// from  CPLD_S                                       to  PWR BTN&LED                                      default 1  // 电源按钮 琥珀色 指示灯 信号
input   i_PAL_PGD_USB_UPD2_P1V1                   /* synthesis LOC = "N18"*/,// from  PEX_USB_UPD720201_2 / SGM61030_3V3to1v1      to  CPLD_S                                           default 1  // USB_UPD2 P1V1 电源良好 信号
output  o_PAL_UPD2_PERST_N_R                      /* synthesis LOC = "N17"*/,// from  CPLD_S                                       to  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR          default 1  // UPD2 插槽复位 信号
output  o_P5V_USB2_LEFT_EAR_EN                    /* synthesis LOC = "P20"*/,// from  CPLD_S                                       to  USB2_LEFT_EAR / U14_JW7111ssoTBTRPBF             default 1  // 5V USB2 左耳 电源使能 信号
input   i_P5V_USB2_LEFT_EAR_OCI2B                 /* synthesis LOC = "P19"*/,// from  CPLD_S                                       to  USB2_LEFT_EAR / U14_JW7111ssoTBTRPBF             default 1  // 5V USB2 左耳 OCI2B 过流告警信号
                                                  /* synthesis LOC = "P18"*/ // 未使用
output  o_USB2_SW_SEL_R                           /* synthesis LOC = "R20"*/,// from  CPLD_S                                       to  USB2_SWITCH / U256_DIO5000QN10                   default 1  // USB2 切换 选择 信号
input   i_DBG_CPU0_UART1_RX_CONN_R                /* synthesis LOC = "M15"*/,// from  J29_10317724B001                             to  CPLD_S                                           default 1  // CPU0 DEBUG UART1 接收 信号
output  o_DBG_CPU0_UART1_TX_CONN_R                /* synthesis LOC = "M14"*/,// from  CPLD_S                                       to  J29_10317724B001                                 default 1  // CPU0 DEBUG UART1 发送 信号
output  o_DBG_PAL_BMC_UART1_TX_CONN_R             /* synthesis LOC = "N16"*/,// from  CPLD_S                                       to  J29_10317724B001                                 default 1  // BMC DEBUG UART1 发送 信号
input   i_DBG_PAL_BMC_UART1_RX_CONN_R             /* synthesis LOC = "R19"*/,// from  J29_10317724B001                             to  CPLD_S                                           default 1  // BMC DEBUG UART1 接收 信号
input   i_UART2_PAL_OCP_RX_R                      /* synthesis LOC = "T20"*/,// from  GENZ_168PIN                                  to  CPLD_S                                           default 1  // OCP UART2 接收 信号
output  o_UART2_PAL_OCP_TX_R                      /* synthesis LOC = "T19"*/,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // OCP UART2 接收 信号
output  o_RST_I2C4_2_MUX_N_R                      /* synthesis LOC = "U20"*/,// from  CPLD_S                                       to  BMC_I2C_MUX2 / U179                              default 1  // I2C4_2 复位 多路复用器 信号
input   i_PAL_THROTTLE_RISER2_R                   /* synthesis LOC = "P17"*/,// from  RISER2/J240_SGM6505HYTQF24G_TR               to  CPLD_S                                           default 1  // Riser2 节流 信号
input   i_UART0_CPU_LOG_RX                        /* synthesis LOC = "T18"*/,// from  CPU0_UART / J614                             to  CPLD_S                                           default 1  // CPU0 UART 日志 接收 信号
output  o_RST_I2C1_MUX_N_R                        /* synthesis LOC = "U19"*/,// from  CPLD_S                                       to  BMC_I2C_MUX1 / U69                               default 1  // I2C1 复位 多路复用器 信号
input   i_PAL_UPD1_PEWAKE_N                       /* synthesis LOC = "V20"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                           default 1  // UPD1 PEWAKE_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的电源唤醒信号
output  o_PAL_DB2000_1_PD_R                      /* synthesis LOC  = "P16"*/,// from  CPLD_S                                       to  DB2000_1_CLK / U47_AU5440AQMR                    default 1  // DB2000_1 电源禁用 信号
output  o_UART0_CPU_LOG_TX                       /* synthesis LOC  = "N15"*/,// from  CPLD_S                                       to  CPU0_UART / J614                                 default 1  // CPU0 UART 日志 发送 信号
input   i_LEAR_CPU0_UART1_RX                     /* synthesis LOC  = "U18"*/,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // CPU0 LEAR UART1 接收 信号
input   i_PAL_RISER2_PRSNT_N                     /* synthesis LOC  = "P15"*/,// from  RISER2/J39_G64V3421MHR                       to  CPLD_S                                           default 1  // Riser2 设备存在 信号
output  o_LEAR_CPU0_UART1_TX                     /* synthesis LOC  = "R16"*/,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // CPU0 LEAR UART1 发送 信号



// 3.3V BANK
input   i_PAL_RISER1_PRSNT_N                     /* synthesis LOC  = "N3" */,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser1 设备存在 信号    
                                                 /* synthesis LOC  = "N4" */ // 未使用
output  o_PAL_OCP_NCSI_SW_EN_N_R                 /* synthesis LOC  = "M6" */,// from  CPLD_S                                       to  RISER_AUX/U89_SGM652321XTS20G/TR                 default 1  // OCP NCSI 开关使能 信号
input   i_PAL_OCP_RISER_CPLD                     /* synthesis LOC  = "M7" */,// from  RISER_AUX/J16                                to  CPLD_S                                           default 1  // OCP Riser CPLD 信号
                                                 /* synthesis LOC  = "P3 "*/ // 未使用
                                                 /* synthesis LOC  = "P4 "*/ // 未使用
                                                 
input   i_PAL_BMC_SS_DATA_IN                     /* synthesis LOC  = "R1" */,// from  GENZ_168PIN                                  to  CPLD_S                                           default 1  // BMC 串行数据 输入 信号
output  o_PAL_RISER1_SS_LD_N_R                   /* synthesis LOC  = "R2" */,// from  CPLD_S                                       to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // Riser1 串行信号加载使能 信号
                                                 /* synthesis LOC  = "T1 "*/ // 未使用
output  o_PAL_RISER1_SS_CLK_R                    /* synthesis LOC  = "T2" */,// from  CPLD_S                                       to  RISER1/U239_SGM6505HYTQF25F_TR                   default 1  // Riser1 串行时钟 信号 
input   i_PAL_RISER4_PWR_PGD                     /* synthesis LOC  = "N5" */,// from  RISER_AUX/J16                                to  CPLD_S                                           default 1  // Riser4 电源良好 信号                                        

input   i_MB_CB_RISER1_PRSNT0_N                  /* synthesis LOC  = "N6" */,// from  RISER1/G64V3421MHR                           to  CPLD_S                                           default 1  // 主板连接器 Riser1 设备存在0 信号


	
input   i_PAL_GPU1_EFUSE_OC	                     /* synthesis LOC  = "R3" */,// from  GPU1_PWR                                     to  CPLD_S                                           default 1  // GPU1 EFUSE 过温保护 信号
input   i_PAL_GPU1_EFUSE_PG	                     /* synthesis LOC  = "R4" */,// from  GPU1_PWR                                     to  CPLD_S                                           default 1  // GPU1 EFUSE 电源良好 信号
input   i_PAL_GPU2_EFUSE_OC	                     /* synthesis LOC  = "T3" */,// from  GPU2_PWR                                     to  CPLD_S                                           default 1  // GPU2 EFUSE 过温保护 信号
input   i_PAL_GPU2_EFUSE_PG	                     /* synthesis LOC  = "T4" */,// from  GPU2_PWR                                     to  CPLD_S                                           default 1  // GPU2 EFUSE 电源良好 信号
input   i_PAL_GPU3_EFUSE_OC	                     /* synthesis LOC  = "V1" */,// from  GPU3_PWR                                     to  CPLD_S                                           default 1  // GPU3 EFUSE 过温保护 信号
input   i_PAL_GPU3_EFUSE_PG	                     /* synthesis LOC  = "V2" */,// from  GPU3_PWR                                     to  CPLD_S                                           default 1  // GPU3 EFUSE 电源良好 信号
input   i_PAL_GPU4_EFUSE_OC	                     /* synthesis LOC  = "V3" */,// from  GPU4_PWR                                     to  CPLD_S                                           default 1  // GPU4 EFUSE 过温保护 信号
input   i_PAL_GPU4_EFUSE_PG	                     /* synthesis LOC  = "V4" */,// from  GPU4_PWR                                     to  CPLD_S                                           default 1  // GPU4 EFUSE 电源良好 信号
output  o_CPU_MCIO8_GPU_THROTTLE_N_R             /* synthesis LOC  = "P5" */,// from  CPLD_S                                       to  CPU1_MCIO_2/3 / J24_G97V22321HR                  default 1  // CPU MCIO8 GPU 节流 信号
input   i_PAL_OCP_PRSNT_N                        /* synthesis LOC  = "P6" */,// from  RISER_AUX/J16                                to  CPLD_S                                           default 1  // OCP 设备存在 信号
input   i_PAL_BMC_UART1_TX                       /* synthesis LOC  = "T5" */,// from  GENZ_168PIN/J98_5653E5-001H1020T             to  CPLD_S                                           default 1  // BMC UART1 发送 信号
output  o_PAL_BMC_SS_CLK                         /* synthesis LOC  = "R5" */,// from  CPLD_S                                       to  GENZ_168PIN/J98_5653E5-001H1020T                 default 1  // BMC 串行时钟 信号
output  o_RST_I2C4_1_MUX_N_R                     /* synthesis LOC  = "U4" */,// from  CPLD_S                                       to  BMC_I2C_MUX2 / U179                              default 1  // I2C4_1 复位 多路复用器 信号
output  o_PAL_TEST_BAT_EN                        /* synthesis LOC  = "U5" */,// from  CPLD_S                                       to  TRC                                              default 1  // 测试 电池 使能 信号
inout   io_MCIO_PWR_EN3_R                        /* synthesis LOC  = "J2" */,// from  ?CPU1_MCIO_2/3 / J24_G97V22321HR?            to  CPLD_S                                           default 1  // MCIO 电源使能3 信号
output  o_RST_I2C5_MUX_N_R                       /* synthesis LOC  = "J1" */,// from  CPLD_S                                       to  BMC_I2C_MUX1 / U173                              default 1  // I2C5 复位 多路复用器 信号
                                                 /* synthesis LOC  = "K5 "*/ // 未使用
output  o_PAL_GPU3_EFUSE_EN_R                    /* synthesis LOC  = "K4 "*/,// from  CPLD_S                                       to  GPU3_PWR                                         default 1  // GPU3 EFUSE 使能 信号                                     
output  o_PAL_GPU4_EFUSE_EN_R                    /* synthesis LOC  = "K2 "*/,// from  CPLD_S                                       to  GPU4_PWR                                         default 1  // GPU4 EFUSE 使能 信号
inout   io_MCIO_PWR_EN2_R                        /* synthesis LOC  = "K1 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能2 信号
inout   io_MCIO_PWR_EN8_R                        /* synthesis LOC  = "K6 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能8 信号
output  o_DB_UART_TX_R	                         /* synthesis LOC  = "K7 "*/,// from  CPLD_S                                       to  DB_MODULE / J33_1338_201_8Q_N                    default 1  // DB UART 发送 信号       
input   i_DB_UART_RX_R	                         /* synthesis LOC  = "L1 "*/,// from  DB_MODULE / J33_1338_201_8Q_N                to  CPLD_S                                           default 1  // DB UART 接收 信号
inout   io_MCIO_PWR_EN7_R                        /* synthesis LOC  = "L2 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能7 信号
                                                 /* synthesis LOC  = "L3 "*/ // 未使用
inout   io_MCIO_PWR_EN5_R                        /* synthesis LOC  = "L4 "*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR              to  CPLD_S                                           default 1  // MCIO 电源使能5 信号
input   i_DB9_TOD_UART_RX                        /* synthesis LOC  = "M1" */,// from  PPS TOD / U88_TPT75176HL1_S01R               to  CPLD_S                                          default 1  // DB9 TOD UART 接收 信号
output  o_DB9_TOD_UART_TX                        /* synthesis LOC  = "M2" */,// from  CPLD_S                                       to  PPS TOD / U88_TPT75176HL1_S01R                  default 1  // DB9 TOD UART 发送 信号

input   i_PAL_LOM_FAN_ON_AUX_R                   /* synthesis LOC  = "M3" */,// from  RISER_AUX / J16                              to  CPLD_S                                          default 1  // LOM 风扇 开启 辅助 信号
output  o_PAL_UPD1_P3V3_EN_R                     /* synthesis LOC  = "M4" */,// from  CPLD_S                                       to  PEX_USB__1 / U40_XUSB2104LCGR                   default 1  // UPD1 P3V3 电源使能 信号
input   i_PAL_UPD72020_1_ALART                   /* synthesis LOC  = "L5" */,// from  PEX_USB_1 / U40_XUSB2104LCGR                 to  CPLD_S                                          default 1  // UPD1 警报 信号
output  o_PAL_GPU2_EFUSE_EN_R                    /* synthesis LOC  = "M5" */,// from  CPLD_S                                       to  GPU2_PWR                                         default 1  // GPU2 EFUSE 使能 信号                
output  o_PAL_GPU1_EFUSE_EN_R                    /* synthesis LOC  = "L6" */,// from  CPLD_S                                       to  GPU1_PWR                                         default 1  // GPU1 EFUSE 使能 信号
output  o_PAL_OCP_NCSI_CLK_50M_R                 /* synthesis LOC  = "L7" */,// from  CPLD_S                                       to  RISER_AUX/J16                                    default 1  // OCP NCSI 时钟 50M 信号

output  o_RST_I2C12_MUX_N_R                      /* synthesis LOC  = "N1" */,// from  CPLD_S                                       to  BMC_I2C_MUX2 / U10_CA9545MTR                     default 1  // I2C12 复位 多路复用器 信号                      
input   i_PAL_THROTTLE_RISER1_R                  /* synthesis LOC  = "N2" */,// from  RISER1/J1_G64V3421MHR                        to  CPLD_S                                           default 1  // Riser1 节流 信号
inout   io_MCIO_PWR_EN0_R                        /* synthesis LOC  = "P1" */,// from  CPU1_MCIO_0/1 / J18_G97V22312HR              to  CPLD_S                                           default 1  // MCIO 电源使能0 信号
                                                 /* synthesis LOC  = "P2 "*/ // 未使用                        

// 1.8V BANK
input   i_CPU1_D0_GPIO_PORT0_R                   /* synthesis LOC = "C4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口0 信号
input   i_CPU1_D0_GPIO_PORT2_R                   /* synthesis LOC = "C3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口2 信号
input   i_CPU1_D0_GPIO_PORT4_R                   /* synthesis LOC = "F6"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口4 信号
input   i_CPU1_D0_GPIO_PORT5_R                   /* synthesis LOC = "G6"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口5 信号
input   i_CPU1_D0_GPIO_PORT6_R                   /* synthesis LOC = "C1"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口6 信号
input   i_CPU1_D0_GPIO_PORT7_R                   /* synthesis LOC = "E4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口7 信号     
input   i_CPU1_D0_GPIO_PORT9_R                   /* synthesis LOC = "E3"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口9 信号
input   i_CPU1_D0_GPIO_PORT10_R                  /* synthesis LOC = "D2"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口10 信号
input   i_CPU1_D0_TEMP_OVER                      /* synthesis LOC = "D1"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 温度 过高 信号
input   i_CPU1_D0_UART_SOUT                      /* synthesis LOC = "F5"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 UART 发送 信号
output  o_CPU1_D0_UART1_RX                       /* synthesis LOC = "G5"*/,// from  CPLD_S                                         to  CPU1_GPIO1 / U2_S5000C_32_3200_C                 default 1  // CPU1 D0 UART1 接收 信号
output  o_CPU1_D1_UART1_RX                       /* synthesis LOC = "F4"*/,// from  CPLD_S                                         to  CPU1_GPIO1 / U2_S5000C_32_3200_C                 default 1  // CPU1 D1 UART1 接收 信号
output  o_CPU0_D1_UART1_RX                       /* synthesis LOC = "F3"*/,// from  CPLD_S                                         to  CPU0_GPIO1 / U1_S5000C_32_3200_C                 default 1  // CPU0 D1 UART1 接收 信号
input   i_CPU1_D1_TEMP_OVER                      /* synthesis LOC = "H6"*/,// from  CPU1_GPIO2 / U3_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D1 温度 过高 信号
output  o_CPU1_D0_UART_SIN                       /* synthesis LOC = "H7"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPU1_UART / J613                                 default 1  // CPU1 D0 UART 接收 信号
input   i_CPU1_D0_GPIO_PORT1_R                   /* synthesis LOC = "E1"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口1 信号
output  o_CPU0_D0_UART1_RX                       /* synthesis LOC = "F2"*/,// from  CPLD_S                                         to  CPU0_GPIO1 / U1_S5000C_32_3200_C                 default 1  // CPU0 D0 UART1 接收 信号
                                                 /* synthesis LOC = "F1 "*/ // 未使用  
input   i_CPU1_D0_UART1_TX                       /* synthesis LOC = "G4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 UART1 发送 信号  
output  o_CPU0_D0_UART_SIN                       /* synthesis LOC = "H3"*/,// from  CPU0_GPIO1 / U1_S5000C_32_3200_C               to  CPU0_UART / J614                                 default 1  // CPU0 D0 UART 接收 信号

input   i_CPU1_D0_GPIO_PORT3_R                   /* synthesis LOC = "H4"*/,// from  CPU1_GPIO1 / U2_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D0 GPIO 端口3 信号
input   i_CPU1_D1_UART1_TX                       /* synthesis LOC = "G2"*/,// from  CPU1_GPIO2 / U3_S5000C_32_3200_C               to  CPLD_S                                           default 1  // CPU1 D1 UART1 发送 信号
input   i_PEX_USB1_PPON1                         /* synthesis LOC = "J5"*/,// from  PEX_USB_UPD720201_2 / U40_XUSB2104LCGR         to  CPLD_S                                           default 1  // PEX USB1 PPON1 信号 
input   i_PEX_USB1_PPON0                         /* synthesis LOC = "H2"*/,// from  PEX_USB_UPD720201_2 / U40_XUSB2104LCGR         to  CPLD_S                                           default 1  // PEX USB1 PPON0 信号
input   i_PEX_USB2_PPON1                         /* synthesis LOC = "H1"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR        to  CPLD_S                                           default 1  // PEX USB2 PPON1 信号
input   i_PEX_USB2_PPON0                         /* synthesis LOC = "J4"*/,// from  PEX_USB_UPD720201_2 / U41_XUSB2104LACGR        to  CPLD_S                                           default 1  // PEX USB2 PPON0 信号
                                                 /* synthesis LOC = "J3 "*/ // 未使用 


// 3.3V BANK
output  o_PAL_P5V_BD_OC                          /* synthesis LOC = "B1"*/,// from  CPLD_S                                         to  DB_MODULE / U39_JW7111SSOTBTRPBF                 default 1  // P5V_BD_OC 信号    
                                                 /* synthesis LOC = "A1 "*/ // 未使用 
                                                 /* synthesis LOC = "G7 "*/ // 未使用 
                                                 /* synthesis LOC = "F7 "*/ // 未使用 
                                                 /* synthesis LOC = "B2 "*/ // 未使用 
input   i_PAL_UPD1_SMIB_N                        /* synthesis LOC = "E6"*/,// from  PEX_USB_1 / U40_XUSB2104LCGR                   to  CPLD_S                                           default 1  // UPD1 SMIB_N 信号 PCH（平台控制器中心）向第 1 路更新通道（UPD1）发送的SMIB_N信号
input   i_MB_CB_RISER2_PRSNT0_N                  /* synthesis LOC = "D5"*/,// from  RISER2/G64V3421MHR                             to  CPLD_S                                           default 1  // 主板连接器 Riser2 设备存在0 信号
                                                 /* synthesis LOC = "B3 "*/ // 未使用 
input   i_PAL_DB2000_1_OE_N_R                    /* synthesis LOC = "B5"*/,// from  DB2000_1_CLK / U47_AU5440AQMR                  to  CPLD_S                                           default 1  // DB2000_1 输出使能 信号
output  o_CPLD_M_S_EXCHANGE_S2                   /* synthesis LOC = "A5"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 交换 信号
output  o_CPLD_M_S_SGPIO1_MOSI                   /* synthesis LOC = "F8"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 MOSI 信号
output  o_PAL_SPI_SELECT_R                       /* synthesis LOC = "B6"*/,// from  CPLD_S                                         to  BIOS_FLASH1 / U222_SGM6505HYTQF24G_T             default 1  // PAL SPI 选择 信号
// output  o_PAL2_TDO                               /* synthesis LOC = "E8"*/,// from  CPLD_S                                         to  CPU1_JTAG / J21_G97V22312HR                       default 1  // PAL2 TDO 信号
// input   i_PAL2_TDI                               /* synthesis LOC = "C7"*/,// from  CPU1_JTAG / J21_G97V22312HR                     to  CPLD_S                                           default 1  // PAL2 TDI 信号
output  o_PAL_UPD1_PERST_N_R                     /* synthesis LOC = "B7"*/,// from  CPLD_S                                         to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 PERST_N 信号 第 1 路更新通道（UPD1）复位 信号
                                                 /* synthesis LOC = "A7 "*/ // 未使用 
output  o_PAL_UPD1_P1V1_EN_R                     /* synthesis LOC = "G9"*/,// from  CPLD_S                                         to  PEX_USB_1 / U40_XUSB2104LCGR                     default 1  // UPD1 P1V1 电源使能 信号
// input   i_TPM_PP_R                               /* synthesis LOC = "B8"*/,// from  TPM_MODULE / U55_TPM_TCG2V1_23_4000_TR         to  CPLD_S                                           default 1  // TPM PP 信号
output  o_CPLD_M_S_SGPIO1_LD_N                   /* synthesis LOC = "D8"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 加载使能 信号
output  o_CPLD_M_S_SGPIO1_CLK                    /* synthesis LOC = "C8"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO1 时钟 信号
                                                 /* synthesis LOC = "B9 "*/ // 未使用 
input   i_CPU1_MCIO2_CABLE_ID1_R                 /* synthesis LOC = "A9"*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR                to  CPLD_S                                           default 1  // CPU1 MCIO2 电缆 ID1 信号
// input   i_PAL2_TCK                               /* synthesis LOC = "C9" */,// from  CPU1_JTAG / J21_G97V22312HR                     to  CPLD_S                                           default 1  // PAL2 TCK 信号
// input   i_PAL2_TMS                               /* synthesis LOC = "D9"*/,// from  CPU1_JTAG / J21_G97V22312HR                     to  CPLD_S                                           default 1  // PAL2 TMS 信号
input   i_CPU1_MCIO3_CABLE_ID1_R                 /* synthesis LOC = "B10"*/,// from  CPU1_MCIO_2/3 / J24_G97V22321HR                to  CPLD_S                                           default 1  // CPU1 MCIO3 电缆 ID1 信号
input   i_CPU1_MCIO2_CABLE_ID0_R                 /* synthesis LOC = "A10"*/,// from  CPU1_MCIO_2/3 / J20_G97V22321HR                to  CPLD_S                                           default 1  // CPU1 MCIO2 电缆 ID0 信号
output  o_PAL_M2_PWR_EN_R                        /* synthesis LOC = "G10" */,// from  CPLD_S                                       to  PAL_M2_PWR_EN / U56                             default 1  // M.2 电源使能 信号
                                                 /* synthesis LOC = "F10"*/ // 未使用 
                                                 /* synthesis LOC = "B11"*/ // 未使用 
output  o_CPLD_M_S_SGPIO_CLK                     /* synthesis LOC = "A11"*/,// from  CPLD_S                                         to  CPLD_M                                           default 1  // CPLD 主从 SGPIO 时钟 信号


input   i_CPU1_MCIO3_CABLE_ID0_R                 /* synthesis LOC = "D10"*/,// from  CPU1_MCIO_2/3 / J24_G97V22321HR                to  CPLD_S                                           default 1  // CPU1 MCIO3 电缆 ID0 信号
input   i_PAL_M2_0_PRSNT_N                       /* synthesis LOC = "C10"*/,// from  PAL_M2_0_PRSNT / J17                           to  CPLD_S                                           default 1  // M.2_0 设备存在 信号
output  o_FAN_SNS_ALERT                          /* synthesis LOC = "A12"*/,// from  CPLD_S                                       to  FAN_SNS_ALERT / U60                             default 1  // 风扇 传感器 警报 信号
                                                 /* synthesis LOC = "B12"*/ // 未使用 
input   i_BMC_I2C3_PAL_S_SCL_R                   /* synthesis LOC = "C11"*/,// from  BMC_I2C_MUX1 / U69                             to  CPLD_S                                           default 1  // BMC I2C3 PAL S SCL 信号
input   io_BMC_I2C3_PAL_S_SDA_R                  /* synthesis LOC = "D11"*/,// from  BMC_I2C_MUX1 / U69                             to  CPLD_S                                           default 1  // BMC I2C3 PAL S SDA 信号
input   i_PAL_DB800_1_OE_N_R                     /* synthesis LOC = "A13"*/,// from  DB800_1_CLK / U48_AU5440AQMR                   to  CPLD_S                                           default 1  // DB800_1 输出使能 信号
output  o_SW_1                                   /* synthesis LOC = "B13"*/,// from  CPLD_S                                         to  SW_1 / J4                                        default 1  // 开关 1 信号        
output  o_SW_2                                   /* synthesis LOC = "G11"*/,// from  CPLD_S                                         to  SW_2 / J5                                        default 1  // 开关 2 信号        
output  o_SW_3                                   /* synthesis LOC = "F11"*/,// from  CPLD_S                                         to  SW_3 / J6                                        default 1  // 开关 3 信号        
output  o_SW_4                                   /* synthesis LOC = "A14"*/,// from  CPLD_S                                         to  SW_4 / J7                                        default 1  // 开关 4 信号        
output  o_SW_5                                   /* synthesis LOC = "B14"*/,// from  CPLD_S                                         to  SW_5 / J8                                        default 1  // 开关 5 信号        
output  o_SW_6                                   /* synthesis LOC = "D12"*/,// from  CPLD_S                                         to  SW_6 / J9                                        default 1  // 开关 6 信号        
output  o_SW_7                                   /* synthesis LOC = "C12"*/,// from  CPLD_S                                         to  SW_7 / J10                                       default 1  // 开关 7 信号        
output  o_SW_8                                   /* synthesis LOC = "A15"*/,// from  CPLD_S                                         to  SW_8 / J12                                       default 1  // 开关 8 信号
input   i_CPU1_MCIO0_CABLE_ID1_R                 /* synthesis LOC = "B15"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                           default 1  // CPU1 MCIO0 电缆 ID1 信号
input   i_PAL_S_JTAGEN                           /* synthesis LOC = "C13"*/,// from  JTAG_EN / J11                                  to  CPLD_S                                            default 1  // PAL S JTAGEN 信号
input   i_PAL_S_PROGRAM_N                        /* synthesis LOC = "D13"*/,// from  S_PROGRAM_N / J13                              to  CPLD_S                                            default 1  // PAL S PROGRAM_N 信号
input   i_CPU1_MCIO0_CABLE_ID0_R                 /* synthesis LOC = "A16"*/,// from  CPU1_MCIO_0/1 / J18_G97V22312HR                to  CPLD_S                                           default 1  // CPU1 MCIO0 电缆 ID0 信号
output  o_PAL_CPU1_I3C_SPD_SEL                   /* synthesis LOC = "B16"*/,// from  CPLD                                           to  CPU0/1_I2C_I3C_SW / U13                          default 1  // PAL CPU1 I3C SPD SEL 信号

output  o_PAL_LED_UID_R                           /* synthesis LOC = "B17"*/,// from  CPLD_S                                        to  LED_UID / J22                                   default 1  // PAL LED UID 信号
output  o_PAL_M2_0_PERST_N_R                      /* synthesis LOC = "D14"*/,// from  CPLD_S                                        to  M2_0_SATA_PORT / J24                            default 1  // PAL M2_0 PERST_N 信号
output  o_PAL_M2_1_PERST_N_R                      /* synthesis LOC = "C15"*/,// from  CPLD_S                                        to  M2_1_SATA_PORT / J25                            default 1  // PAL M2_1 PERST_N 信号
output  o_PAL_DB800_1_PD_R                        /* synthesis LOC = "F13"*/,// from  CPLD_S                                        to  DB800_2_CLK / U11_AU5443A_LMR                    default 1  // PAL DB800_1 PD 信号(DB800 模块 1 的掉电控制信号)
                                                  /* synthesis LOC = "A18"*/ // 未使用 
output  o_RST_I2C13_MUX_N_R                       /* synthesis LOC = "B18"*/,// from  CPLD_S                                        to  RST_I2C13_MUX2 / U51                             default 1  // RST I2C13 MUX N 信号   
input   i_CPU0_MCIO0_CABLE_ID0_R                  /* synthesis LOC = "E14"*/,// from  CPU0_MCIO_0/0 / J27_G97V22312HR               to  CPLD_S                                           default 1  // CPU0 MCIO0 电缆 ID0 信号
output  o_RST_I2C3_MUX_N_R                        /* synthesis LOC = "E15"*/,// from  CPLD_S                                        to  RST_I2C3_MUX1 / U242_CA9545MTR                   default 1  // RST I2C3 MUX N 信号
output  o_RST_I2C_BMC_9548_MUX_N_R                /* synthesis LOC = "D16"*/,// from  CPLD_S                                        to  BMC_I2C_MUX2 / U258                              default 1  // RST I2C BMC 9548 MUX N 信号
                                                  /* synthesis LOC = "G14"*/ // 未使用 
                                                  /* synthesis LOC = "F14"*/ // 未使用 
                                                  /* synthesis LOC = "B19"*/ // 未使用 
                                                  /* synthesis LOC = "A20"*/ // 未使用 
input   i_PAL_S_INITN                             /* synthesis LOC = "C17"*/,// from  S_INITN / J31                                 to  CPLD_S                                           default 1  // PAL S INITN 信号
input   i_PAL_S_DONE                              /* synthesis LOC = "A19"*/ // from  S_DONE / J32                                  to  CPLD_S                                           default 1  // PAL S DONE 信号
)



endmodule 