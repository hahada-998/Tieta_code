
// Timescale
  `timescale 1ns / 1ns

//BOARD Selection
  `define RS35M2C16S_VA

  `ifdef RS35M2C16S_VA `define RS41M2C9S
  `endif
/*
  `ifdef RS05M2C9S_VA `define R4X00
  `endif
*/
  `ifdef RS35M2C16S_VA `define H3C_2014_RS35M2C16S_VA
  `endif


  `define SPECIFIC_POWER_P1V8_PCH_STBY //20170109, sunyanlong needed, R4900_G3.v, pwrseq_master.v



//BIOS
  `define PCH_MODE_LPC

  `define PSU_CTRL    // Set when you have a PSU


//MCIO device_type_code
  `define MCIO_DEFAULT       4'h0
  `define MCIO_NVMe          4'h1
  `define MCIO_E1_S          4'h2
  `define MCIO_SATA          4'h3
  `define MCIO_OCP           4'h4
  `define MCIO_RS36R3X16R    4'h5
  `define MCIO_RS36R3X8R     4'h6
  `define MCIO_RS46RX8R      4'h7
  `define MCIO_RS46RX8RA     4'h8
  `define MCIO_RS46RX16R     4'h9
  `define MCIO_RS46RX16RA    4'hA
  `define MCIO_M_2           4'hB
  `define MCIO_OTHER_RISER   4'hC
  `define MCIO_OCP2          4'hD
//to BMC
  `define MCIO_DEFAULT_BMC   4'h0
  `define MCIO_NVMe_BMC      4'h1
  `define MCIO_E1_S_BMC      4'h2
  `define MCIO_SATA_BMC      4'h3
  `define MCIO_OCP_BMC       4'h4
  `define MCIO_RISER1_BMC    4'h5
  `define MCIO_RISER2_BMC    4'h6
  `define MCIO_RISER3_BMC    4'h7
  `define MCIO_RISER4_BMC    4'h8
  `define MCIO_M_2_BMC       4'h9
  `define MCIO_OTHER_BMC     4'hf
  


//-----------------------------------------------------------------------------
//COMPILE DATE: 0xF0 0xF1 0xF2
//2022-06-14
  `define CPLD_DATE_YYYYMMDD  32'h20230824

//COMPILE TIME: 0XF3 0xF4 0xF5
  `define CPLD_TIME_HHMMSSXX {24'h145800, `CPLD_TIME_XX}

  `ifdef RS35M2C16S_VA `define CPLD_TIME_XX 8'hZZ
  `endif

  `ifdef RS35M2C16S_VA `define H3C_2014_RS35M2C16S_VA
  `endif

//CPLD version: 0xF1-F0
//MSB-W: 0-9, official version
//    X: 0, A-F, bootleg version; 0 when official release
//    Y: 0-9, test version (00-99)
//LSB-Z: 0-9, test version (00-99)
/*  `define CPLD_VER 16'h0400
  `define PFR_CPLD_VER 16'h0400
  `define DB_CPLD_VER 16'h0400
*/
//2022-06-14
  `define CPLD_VER 16'h01A0
  `define PFR_CPLD_VER 16'h0500
  `define DB_CPLD_VER 16'h0500

//GENERATION ID: 0x01[7:4]
  `define GEN_ID_RSVD 4'b0000      //RESERVED
  `define GEN_ID_G2   4'b0010      //R390X G2
  `define GEN_ID_G3   4'b0011      //R4900 G3
  `define GEN_ID_G5   4'b0101      //R4900 G5
`ifdef R4900_G5
  `define GEN_ID    `GEN_ID_G5
`else
  `define GEN_ID    `GEN_ID_RSVD
`endif

//BOARD ID: 0x01[3:0], strapped in board
  `define BOARD_ID_RSVD      4'b0000
  `define BOARD_ID_RS03M2C9S 4'b0100
  `define BOARD_ID_RS23M2C6S 4'b0011
  `define BOARD_ID_RS33M2C9S 4'b0100
  `define BOARD_ID_RS05M2C9S 4'b0101
  `define BOARD_ID_RS35M2C5S  4'b0011  
  `define BOARD_ID_RS35M2C16S 4'b0100
  
   `define BOARD_ID_RS41M2C9S 4'b0001


//CHASSIS ID: 0x82[7:6], strapped in board
//  `define CHASSIS_ID_RSVD    2'b00
//  `define CHASSIS_ID_1U      2'b01
//  `define CHASSIS_ID_2U      2'b11
 
  `define CHASSIS_ID_1U      3'b001
  `define CHASSIS_ID_2U      3'b010
  `define CHASSIS_ID_4U      3'b000  
  `define CHASSIS_ID_8U      3'b011   

//SERVER ID: 0x81-80
//        SERVER_ID                  BOARD_ID  CHASSIS_ID
  `define SERVER_ID_RSVD    16'h0000
  `define SERVER_ID_R4900   16'h4900 //0100      11 (default)
  `define SERVER_ID_R4700   16'h4700 //0100      01
  `define SERVER_ID_R2900   16'h2900 //0011      11 (default)
  `define SERVER_ID_R2700   16'h2700 //0011      01

  `define SERVER_ID_R6900   16'h6900 //0001      01  //YHY


//FABRIC
  `define CPU_PKG_ID_NOMCP   3'b000
  `define CPU_PKG_ID_FABRIC  3'b001
  `define CPU_PKG_ID_FPGA    3'b010
  `define CPU_PKG_ID_RSVD011 3'b011//011-111
  `define CPU_PKG_ID_RSVD100 3'b100//011-111
  `define CPU_PKG_ID_RSVD101 3'b101//011-111
  `define CPU_PKG_ID_RSVD110 3'b110//011-111
  `define CPU_PKG_ID_RSVD111 3'b111//011-111


//OCP ID
//  `define MLOM_ID_RS33NXT2M  4'b0000
//  `define MLOM_ID_RS33NXP2M  4'b0001
//  `define MLOM_ID_RS33NGT4M  4'b0010

//RAID ID
  `define AROC_TYPE_HBA      2'b00
  `define AROC_TYPE_RAID     2'b01
  `define AROC_TYPE_MEZZ     2'b10
  `define AROC_TYPE_RSVD     2'b11

//RISER ID: RISER1/0x4B[5:2], RISER2//0x4C[5:2], RISER3/0x4D[5:2]
//RISER ID        //NAME          //ID       //LOCATION
//  `define RISER_ID_RSVD0          4'b0000  //never used
//  `define RISER_ID_RSVD1          4'b1111  //never used

  `define RISER_ID_RS36R3X16R    6'b001100      //2U Riser1/2
  `define RISER_ID_RS36R3X8R     6'b001011      //2U Riser1/2
  `define RISER_ID_RS36RX16R     6'b010001      //2U Riser1/2
  `define RISER_ID_RS46RX8R      6'b111110      //2U Riser3 slot7/8
  `define RISER_ID_RS46RX8RA     6'b111111      //2U Riser4 slot9/10   
  `define RISER_ID_RS46RX16R     6'b111100      //2U Riser4 slot10
  `define RISER_ID_RS46RX16RA    6'b111101      //2U Riser4 slot9


//Slot CODE
  `define SLOT_0      7'd00 
  `define SLOT_1      7'd01
  `define SLOT_2      7'd02
  `define SLOT_3      7'd03
  `define SLOT_4      7'd04
  `define SLOT_5      7'd05
  `define SLOT_6      7'd06
  `define SLOT_7      7'd07
  `define SLOT_8      7'd08
  `define SLOT_9      7'd09
  `define SLOT_10      7'd10
  `define SLOT_11      7'd11
  `define SLOT_12      7'd12
  `define SLOT_13      7'd13
  `define SLOT_14      7'd14
  `define SLOT_15      7'd15
  `define SLOT_16      7'd16
  `define SLOT_17      7'd17
  `define SLOT_18      7'd18
  `define SLOT_19      7'd19
  `define SLOT_20      7'd20
  `define SLOT_21      7'd21
//GPU CABLE ID
  `define GPU_CABLE_ID_RSVD       2'b11

//BMC Memory Size: 0x00[3:2]
  `define BMC_MEM_SIZE_1G  2'b00
  `define BMC_MEM_SIZE_2G  2'b01
  `define BMC_MEM_SIZE_4G  2'b10
  `define BMC_MEM_SIZE_8G  2'b11

  `define BMC_MEM_SIZE `BMC_MEM_SIZE_2G //Used directly

//PCB REVISION
  `define PCB_VA 2'b00
//  `define PCB_VB 2'b01

//-----------------------------------------------------------------------------
// System Defines
//-----------------------------------------------------------------------------
  `define NUM_CPU        2
  `define NUM_CPUVR      2
  `define NUM_MEMVR      4
  `define NUM_CHN        4
  `define NUM_FAN        8
  `define NUM_NIC        4
  `define NUM_PSU        2

  `define NUM_IO         1
  `define NUM_RISER      3 
  `define port_num       3
//  `define NUM_RISER      4

  `define SYS_HAS_UID_BTN           // If system has SUV and no UID, comment out both 
//  `define NUM_BP         5
  `define NUM_BP         6      /********G5 2P**********/
//  `define NUM_S5DEV      1
  `define NUM_S5DEV      2      /********G5 2P**********/

// PLATFORM SPECIFIC: GLP DDR density. Uncomment if system is using 1Gbit density.
//`define   DDR_2GBIT

//-----------------------------------------------------------------------------
// XREG Defines (FIXME: update these defines to match specific platform
//-----------------------------------------------------------------------------
//`define NUMBER_OF_MAD_ADDRESS_LINES   8

//-----------------------------------------------------------------------------
// Server ID, ILO CPLD
//-----------------------------------------------------------------------------
//`define CHASSIS_ID 8'h39
  `define BOARD_TYPE 4'b0000
  `define OEM_TYPE   4'b0111 //H3C

//MANUFACTURE ID
  `define MFR_ID_RSVD 8'h00
  `define MFR_ID_H3C  8'h03

  `define MFR_ID `MFR_ID_H3C

//ODM ID
  `define ODM_ID_RSVD 8'h00
  `define ODM_ID_H3C  8'h03

  `define ODM_ID `ODM_ID_H3C

//PRODUCT LINE
  `define PDT_LINE_RSVD          8'h00//Low Server PDT (old)
  `define PDT_LINE_H3C_2014_LLS  8'h01//Low Server PDT, 0x01-0x7F
//`define PDT_LINE_H3C_2014_UIS  8'h10//UIS PDT0, 0x80-0xff
  `define PDT_LINE_H3C_OEM_IN  8'h63        //YHY

  `define PDT_LINE `PDT_LINE_H3C_OEM_IN

//PRODUCT GENERATION
  `define PDT_GEN_RSVD          8'h00
  `define PDT_GEN_H3C_2014_G2   8'h02//GRANTLEY
  `define PDT_GEN_H3C_2014_G3   8'h03//PURLEY
//YHY  `define PDT_GEN_H3C_2014_G5   8'h05//WHITLEY
   `define PDT_GEN_H3C_S5000C   8'h06//S5000C  
 

  `define PDT_GEN `PDT_GEN_H3C_S5000C

//PRODUCT REVISION
  `define PDT_REV_RSVD              8'h00
  `define PDT_REV_H3C_2014_V100R001 8'h11
  `define PDT_REV_H3C_2014_V200R002 8'h22
  `define PDT_REV_H3C_2014_V500R002 8'h52
  `define PDT_REV_H3C_2014_V800R001 8'h81
  `define PDT_REV_H3C_2014_V200R005 8'h25  
  
  `define PDT_REV_H3C_2014_V500R003 8'h53   
  `define PDT_REV_H3C_2014_V500R005 8'h55  
    `define PDT_REV_H3C_IT_C_RACK_V700R001 8'h71  //YHY


//  `define PDT_REV `PDT_REV_H3C_2014_V200R002   
  `define PDT_REV `PDT_REV_H3C_IT_C_RACK_V700R001

//SERVER ID
  `define SERVER_ID_H3C_2014_RSVD  8'h00
  `define SERVER_ID_H3C_2014_R2700 8'h01
  `define SERVER_ID_H3C_2014_R2900 8'h03
  `define SERVER_ID_H3C_2014_R4700 8'h11
  `define SERVER_ID_H3C_2014_R4900 8'h13
  `define SERVER_ID_H3C_2014_R6900 8'h23
  `define SERVER_ID_H3C_2014_R8900 8'h33
  
//BOARD ID: 0x01[3:0], strapped in board
  `define BOARD_ID_H3C_2014_RSVD      8'h00
  `define BOARD_ID_H3C_2014_RS03M2C9S 8'h04
  `define BOARD_ID_H3C_2014_RS23M2C6S 8'h03
  `define BOARD_ID_H3C_2014_RS33M2C9S 8'h04
  `define BOARD_ID_H3C_2014_RS35M2C5S 8'h03
  `define BOARD_ID_H3C_2014_RS35M2C16S 8'h04
 
  `define BOARD_ID_H3C_2014_RS41M2C9S      8'h11

//CHASSIS ID
  `define CHASSIS_ID_H3C_2014_RSVD 8'h00
  `define CHASSIS_ID_H3C_2014_1U   8'h01
  `define CHASSIS_ID_H3C_2014_2U   8'h02
  `define CHASSIS_ID_H3C_2014_NONE 8'h03

//PLATFORM MANUFACTURE
  `define PLT_CPU_MFR_RSVD  8'h00
  `define PLT_CPU_MFR_INTEL 8'h01
  `define PLT_CPU_MFR_AMD   8'h02
  `define PLT_CPU_MFR_FT   8'h03  //YHY

  `define PLT_CPU_MFR `PLT_CPU_MFR_FT

//PLATFORM GENERATION
  `define PLT_CPU_GEN_RSVD      8'h00
  `define PLT_CPU_GEN_BROADWELL 8'h00
  `define PLT_CPU_GEN_SKYLATE   8'h01
  `define PLT_CPU_GEN_ICELATE   8'h10
  `define PLT_CPU_GEN_FT2500   8'h05  //YHY  

  `define PLT_CPU_GEN `PLT_CPU_GEN_FT2500

//-----------------------------------------------------------------------------
// Interrupt module modes
//-----------------------------------------------------------------------------
  `define INT_MODE_RISING  2'b01
  `define INT_MODE_FALLING 2'b10
  `define INT_MODE_BOTH    2'b11

//`define LEVEL_UID_ON 1'b1

//PART NUMBER
  `define PN_RS03M2C9S {`ASCII_A, `ASCII_3, `ASCII_F, `ASCII_T} //RS03M2C9S 0302A3FT 制成板-H3C R390X G3-RS03M2C9S-2U机架式服务器双路CPU主板,支持9路PCIe扩展槽-无拼板
  `define PN_RS33M2C9S {`ASCII_A, `ASCII_3, `ASCII_F, `ASCII_Q} //RS33M2C9S 0302A3FQ 制成板-H3C R4900 G3-RS33M2C9S-2U机架式服务器双路CPU主板,支持9路PCIe扩展槽-无拼板
  `define PN_RS23M2C6S {`ASCII_A, `ASCII_3, `ASCII_F, `ASCII_R} //RS23M2C6S 0302A3FR 制成板-H3C R2900 G3-RS23M2C6S-2U机架式服务器双路CPU主板,支持6路PCIe扩展槽-无拼板
  `define PN_RS05M2C9S {`ASCII_A, `ASCII_4, `ASCII_L, `ASCII_M} //RS23M2C6S 0302A3FR 制成板-H3C R2900 G3-RS23M2C6S-2U机架式服务器双路CPU主板,支持6路PCIe扩展槽-无拼板
  `define PN_RS35M2C16S {`ASCII_A, `ASCII_5, `ASCII_B, `ASCII_8} //RS35M2C16S 0302A5B8 制成板-H3C R4900 G3-RS35M2C16S-2U机架式服务器双路CPU主板,支持16路PCIe扩展槽-无拼板  
  `define PN_RS41M2C9S {`ASCII_A, `ASCII_5, `ASCII_K, `ASCII_B} //RS41M2C9S 0302A5KB 制成板-H3C Uniserver R4970 G5-RS41M2C9S-2U机架式服务器双路CPU主板,支持8路PCIe扩展槽-无拼板    
  `define PN_RSVD      32'h0000_0000

  `ifdef RS03M2C9S  `define BOARD_PN `PN_RS03M2C9S
  `elsif RS23M2C6S  `define BOARD_PN `PN_RS23M2C6S
  `elsif RS33M2C9S  `define BOARD_PN `PN_RS33M2C9S
  `elsif RS05M2C9S  `define BOARD_PN `PN_RS05M2C9S
  `elsif RS35M2C16S `define BOARD_PN `PN_RS35M2C16S
  `elsif RS41M2C9S  `define BOARD_PN `PN_RS41M2C9S  
  `else             `define BOARD_PN `PN_RSVD
  `endif

//ASCII CODE
  `define ASCII_0 8'h30
  `define ASCII_1 8'h31
  `define ASCII_2 8'h32
  `define ASCII_3 8'h33
  `define ASCII_4 8'h34
  `define ASCII_5 8'h35
  `define ASCII_6 8'h36
  `define ASCII_7 8'h37
  `define ASCII_8 8'h38
  `define ASCII_9 8'h39
  `define ASCII_A 8'h41
  `define ASCII_B 8'h42
  `define ASCII_C 8'h43
  `define ASCII_D 8'h44
  `define ASCII_E 8'h45
  `define ASCII_F 8'h46
  `define ASCII_G 8'h47
  `define ASCII_H 8'h48
  `define ASCII_I 8'h49
  `define ASCII_J 8'h4A
  `define ASCII_K 8'h4B
  `define ASCII_L 8'h4C
  `define ASCII_M 8'h4D
  `define ASCII_N 8'h4E
  `define ASCII_O 8'h4F
  `define ASCII_P 8'h50
  `define ASCII_Q 8'h51
  `define ASCII_R 8'h52
  `define ASCII_S 8'h53
  `define ASCII_T 8'h54
  `define ASCII_U 8'h55
  `define ASCII_V 8'h56
  `define ASCII_W 8'h57
  `define ASCII_X 8'h58
  `define ASCII_Y 8'h59
  `define ASCII_Z 8'h5A

