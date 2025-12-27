

//`define MAX_BYTE_TPM  4
//`define N             (`MAX_BYTE_TPM * 8)

  `define FSM_SPI_MOSI_BIT0 8'h00
  `define FSM_SPI_MOSI_BIT1 8'h01
  `define FSM_SPI_MOSI_BIT2 8'h02
  `define FSM_SPI_MOSI_BIT3 8'h03
  `define FSM_SPI_MOSI_BIT4 8'h04
  `define FSM_SPI_MOSI_BIT5 8'h05
  `define FSM_SPI_MOSI_BIT6 8'h06
  `define FSM_SPI_MOSI_BIT7 8'h07

  `define FSM_SPI_MISO_BIT0 8'h00
  `define FSM_SPI_MISO_BIT1 8'h01
  `define FSM_SPI_MISO_BIT2 8'h02
  `define FSM_SPI_MISO_BIT3 8'h03
  `define FSM_SPI_MISO_BIT4 8'h04
  `define FSM_SPI_MISO_BIT5 8'h05
  `define FSM_SPI_MISO_BIT6 8'h06
  `define FSM_SPI_MISO_BIT7 8'h07

//defintions for SPI/BUFF/LPC state machine
  `define FSM_SPI_IDLE             8'h00
  `define FSM_SPI                  8'h01
  `define FSM_SPI_COMMAND          8'h02
  `define FSM_SPI_ADDRESS2         8'h03
  `define FSM_SPI_ADDRESS1         8'h04
  `define FSM_SPI_ADDRESS0         8'h05
  `define FSM_SPI_WDATA0           8'h06
  `define FSM_SPI_WDATA1           8'h07
  `define FSM_SPI_WDATA2           8'h08
  `define FSM_SPI_WDATA3           8'h09
  `define FSM_SPI_WDATA_DONE       8'h0A
  `define FSM_SPI_WAIT             8'h0B
  `define FSM_SPI_WAIT_RDY         8'h0C
  `define FSM_SPI_WAIT_END         8'h0D
  `define FSM_SPI_WAIT_DONE        8'h0E
  `define FSM_SPI_RDATA0           8'h0F
  `define FSM_SPI_RDATA1           8'h10
  `define FSM_SPI_RDATA2           8'h11
  `define FSM_SPI_RDATA3           8'h12
  `define FSM_SPI_RDATA_DONE       8'h13
  `define FSM_SPI_FAULT            8'h14
  `define FSM_SPI_DONE             8'h15

  `define FSM_BUF_IDLE             8'h00
  `define FSM_BUF_SPI_WDATA_DONE   8'h01
  `define FSM_BUF_SPI_TX_LPC_TX    8'h02
  `define FSM_BUF_LPC_TX_BUFFER    8'h03
  `define FSM_BUF_LPC_TX           8'h04
  `define FSM_BUF_LPC_DONE_TX      8'h05
  `define FSM_BUF_SPI_WAIT         8'h06
  `define FSM_BUF_SPI_RX_LPC_RX    8'h07
  `define FSM_BUF_LPC_RX_BUFFER    8'h08
  `define FSM_BUF_LPC_RX           8'h09
  `define FSM_BUF_LPC_DONE_RX      8'h0A
  `define FSM_BUF_LPC_RX_SPI_RX    8'h0B
  `define FSM_BUF_SPI_RDATA_BUFFER 8'h0C
  `define FSM_BUF_SPI_RDATA0       8'h0D
  `define FSM_BUF_SPI_WAIT_DONE    8'h0E
  `define FSM_BUF_DONE             8'h0F

  `define FSM_LPC_IDLE             8'h00
  `define FSM_LPC                  8'h01
  `define FSM_LPC_START0           8'h02
  `define FSM_LPC_START            8'h03
  `define FSM_LPC_CTDIR            8'h04
  `define FSM_LPC_ADDR_3           8'h05
  `define FSM_LPC_ADDR_2           8'h06
  `define FSM_LPC_ADDR_1           8'h07
  `define FSM_LPC_ADDR_0           8'h08
  `define FSM_LPC_WDATA_0          8'h09
  `define FSM_LPC_WDATA_1          8'h0A
  `define FSM_LPC_WTAR_0           8'h0B
  `define FSM_LPC_WTAR_1           8'h0C
  `define FSM_LPC_WSYNC            8'h0D
  `define FSM_LPC_RDATA_0          8'h0E
  `define FSM_LPC_RDATA_1          8'h0F
  `define FSM_LPC_RTAR_0           8'h10
  `define FSM_LPC_RTAR_1           8'h11
  `define FSM_LPC_RSYNC            8'h12
  `define FSM_LPC_TAR2_0           8'h13
  `define FSM_LPC_TAR2_1           8'h14
  `define FSM_LPC_FAULT            8'h15
  `define FSM_LPC_DONE             8'h16


//`define TPM_TIMEOUT_A  //[0]  750ms
//`define TPM_TIMEOUT_B  //[1] 2000ms
//`define TPM_TIMEOUT_C  //[2]  750ms
//`define TPM_TIMEOUT_D  //[3]   30ms

//`define TPM_DID_NATIONZ 16'h4E1B
//`define TPM_VID_NATIONZ 16'h0102
//`define TPM_VID_NATIONZ 16'h1B4E

//`define TPM_ADDR_LOCALITY0 20'hFED4_0  //Locality 0
//`define TPM_ADDR_LOCALITY1 20'hFED4_1  //Locality 1
//`define TPM_ADDR_LOCALITY2 20'hFED4_2  //Locality 2
//`define TPM_ADDR_LOCALITY3 20'hFED4_3  //Locality 3
//`define TPM_ADDR_LOCALITY4 20'hFED4_4  //Locality 4

//                                      Address    Locality -Locality 0                       -Locality 1          -Locality 2           -Locality 3         -Locality 4
//`define TPM_ADDR_REG_ACCESS_0         12'h000  //0 1 2 3 4 TCM_ACCESS_0                      TCM_ACCESS_1         TCM_ACCESS_2         TCM_ACCESS_3         TCM_ACCESS_4
//`define TPM_ADDR_REG_INT_ENABLE_0     12'h008  //0 1 2 3 4 TCM_INT_ENABLE_0                  TCM_INT_ENABLE_1     TCM_INT_ENABLE_2     TCM_INT_ENABLE_3     TCM_INT_ENABLE_4
//`define TPM_ADDR_REG_INT_ENABLE_1     12'h009  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_ENABLE_2     12'h00A  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_ENABLE_3     12'h00B  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_VECTOR_0     12'h00C  //0 1 2 3 4 TCM_INT_VECTOR_0                  TCM_INT_VECTOR_1     TCM_INT_VECTOR_2     TCM_INT_VECTOR_3     TCM_INT_VECTOR_4
//`define TPM_ADDR_REG_INT_STATUS_0     12'h010  //0 1 2 3 4 TCM_INT_STATUS_0                  TCM_INT_STATUS_1     TCM_INT_STATUS_2     TCM_INT_STATUS_3     TCM_INT_STATUS_4
//`define TPM_ADDR_REG_INT_STATUS_1     12'h011  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_STATUS_2     12'h012  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_STATUS_3     12'h013  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_CAPABILITY_0 12'h014  //0 1 2 3 4 TCM_INT_CAPABILITY_0              TCM_INT_CAPABILITY_1 TCM_INT_CAPABILITY_2 TCM_INT_CAPABILITY_3 TCM_INT_CAPABILITY_4
//`define TPM_ADDR_REG_INT_CAPABILITY_1 12'h015  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_CAPABILITY_2 12'h016  //0 1 2 3 4
//`define TPM_ADDR_REG_INT_CAPABILITY_3 12'h017  //0 1 2 3 4
//`define TPM_ADDR_REG_STS_0            12'h018  //0 1 2 3 4 TCM_STS_0                         TCM_STS_1            TCM_STS_2            TCM_STS_3            TCM_STS_4
//`define TPM_ADDR_REG_STS_1            12'h019  //0 1 2 3 4
//`define TPM_ADDR_REG_STS_2            12'h01A  //0 1 2 3 4
//`define TPM_ADDR_REG_STS_3            12'h01B  //0 1 2 3 4
//`define TPM_ADDR_REG_HASH_END         12'h020  //- - - - 4                                                                                                  TCM_HASH_END
//`define TPM_ADDR_REG_DATA_FIFO_0      12'h024  //0 1 2 3 4 TCM_DATA_FIFO_0                   TCM_DATA_FIFO_1      TCM_DATA_FIFO_2      TCM_DATA_FIFO_3      TCM_HASH_DATA/TCM_DATA_FIFO_4
//`define TPM_ADDR_REG_DATA_FIFO_1      12'h025  //0 1 2 3 4
//`define TPM_ADDR_REG_DATA_FIFO_2      12'h026  //0 1 2 3 4
//`define TPM_ADDR_REG_DATA_FIFO_3      12'h027  //0 1 2 3 4
//`define TPM_ADDR_REG_HASH_START       12'h028  //- - - - 4                                                                                                  TCM_HASH_START
//`define TPM_ADDR_REG_DID_VID_0        12'hF00  //0 1 2 3 4 TCM_DID_VID_0                     TCM_DID_VID_1        TCM_DID_VID_2        TCM_DID_VID_3        TCM_DID_VID_4
//`define TPM_ADDR_REG_DID_VID_1        12'hF01  //0 1 2 3 4
//`define TPM_ADDR_REG_DID_VID_2        12'hF02  //0 1 2 3 4
//`define TPM_ADDR_REG_DID_VID_3        12'hF03  //0 1 2 3 4
//`define TPM_ADDR_REG_RID_0            12'hF04  //0 1 2 3 4 TCM_RID_0                         TCM_RID_1            TCM_RID_2            TCM_RID_3            TCM_RID_4
//`define TPM_ADDR_REG_1ST_LEGACY_0     12'hF80  //0 - - - - FIRST_LEGACY_ADDRESS_0            -                    -                    -                    -
//`define TPM_ADDR_REG_1ST_LEGACY_EXT_0 12'hF84  //0 - - - - FIRST_LEGACY_ADDRESS_EXTENSION_0  -                    -                    -                    -
//`define TPM_ADDR_REG_2ND_LEGACY_0     12'hF88  //0 - - - - SECOND_LEGACY_ADDRESS_0           -                    -                    -                    -
//`define TPM_ADDR_REG_2ND_LEGACY_EXT_0 12'hF8C  //0 - - - - SECOND_LEGACY_ADDRESS_EXTENSION_0 -                    -                    -                    -

//                                         Cycle Type               Size           Host Peripheral
//`define LPC_CYCLE_TYPE_RSVD      4'h0  //                                        Y    Y
//`define LPC_CYCLE_TYPE_MEM_RD    4'h1  //Memory Read              1Byte          Y    Y
//`define LPC_CYCLE_TYPE_MEM_WR    4'h2  //Memory Write             1Byte          n    Y
//`define LPC_CYCLE_TYPE_IO_RD     4'h3  //I/O Read                 1Byte          n    Y
//`define LPC_CYCLE_TYPE_IO_WR     4'h4  //I/O Write                1Byte          n    Y
//`define LPC_CYCLE_TYPE_DMA_RD    4'h5  //DMA Read                 1/2/4Byte      n    Y
//`define LPC_CYCLE_TYPE_DMA_WR    4'h6  //DMA Write                1/2/4Byte      Y    Y
//`define LPC_CYCLE_TYPE_BMMEM_RD  4'h7  //Bus Master Memory Read   1/2/4Byte      Y*   Y
//`define LPC_CYCLE_TYPE_BMMEM_WR  4'h8  //Bus Master Memory Write  1/2/4Byte      Y*   Y
//`define LPC_CYCLE_TYPE_BMIO_RD   4'h9  //Bus Master I/O Read      1/2/4Byte      Y    Y
//`define LPC_CYCLE_TYPE_BMIO_WR   4'hA  //Bus Master I/O Write     1/2/4Byte      Y    Y
//`define LPC_CYCLE_TYPE_FWMEM_RD  4'hB  //Firmware Memory Read     1/2/4/128Byte  Y    Y
//`define LPC_CYCLE_TYPE_FWMEM_WR  4'hC  //Firmware Memory Write    1/2/4Byte      Y    Y

//Start field, [3:0]
//`define LPC_START_FIELD_START    4'b0000  //Start of cycle for a target.Used for Memory, I/O, and DMA cycles.
//`define LPC_START_FIELD_GBM0     4'b0010  //Grant for bus master 0.
//`define LPC_START_FIELD_GBM1     4'b0011  //Grant for bus master 1.
//`define LPC_START_FIELD_FMMEM_RD 4'b1101  //Start of Cycle for Firmware Memory Read cycle.
//`define LPC_START_FIELD_FMMEM_WR 4'b1110  //Start of Cycle for Firmware Memory Write cycle.
//`define LPC_START_FIELD_STOP     4'b1111  //Stop/Abort: End of a cycle for a target.

//Cycle Type, [3:2]
  `define LPC_CYCTYPE_IO   2'b00
//`define LPC_CYCTYPE_MEM  2'b01
//`define LPC_CYCTYPE_DMA  2'b10
//`define LPC_CYCTYPE_RSVD 2'b11

//Direction, [1]
  `define LPC_DIRECTION_RD 1'b0
  `define LPC_DIRECTION_WR 1'b1

//Size, [1:0]
//`define LPC_SIZE_8BIT  2'b00
//`define LPC_SIZE_16BIT 2'b01
//`define LPC_SIZE_RSVD  2'b10
//`define LPC_SIZE_32BIT 2'b11

//SYNC, [3:0]
  `define LPC_SYNC_RDY        4'b0000
//`define LPC_SYNC_WAIT_SHORT 4'b0101
//`define LPC_SYNC_WAIT_LONG  4'b0110
//`define LPC_SYNC_RDY_MORE   4'b1001
//`define LPC_SYNC_ERROR      4'b1010

//VID
//`define TPM_VID_NATIONZ




