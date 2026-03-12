/**********************************************************************************************************************************/
// Copyright(c) 2020, Hangzhou CNIT Technologies Co., Ltd, All right reserved
// Project      :   
// Filename     :   global_constant_mac1.v
// Author       :   
// Email        :   
// Date         :   2025-12-16
// Description  :   
// Device       :   
// Modification History:
/**************************************************************版本记录************************************************************/
// 2025-09-02   wangguowei          1.0           1、文件创建；2、按照CPLD开发checklist2.0版本check修改

`ifndef GLOBAL_CONSTANT_H
`define GLOBAL_CONSTANT_H

// 0000：CPU板
// 0001：主控板
// 0010：上端口板
// 0011：交换板1
// 0100：下端口板
// 0101：交换板2
// 0110：上风扇板
// 0111：下风扇板
// 1000：交换板3
// 1111: 空值，禁止使用
`define CPU_BOARD                   4'b0000
`define MB_BOARD                    4'b0001
`define UP_PORT_BOARD               4'b0010
`define SW1_BOARD                   4'b0011
`define DOWN_PORT_BOARD             4'b0100
`define SW2_BOARD                   4'b0101
`define UP_FAN_BOARD                4'b0110
`define DOWN_FAN_BOARD              4'b0111
`define SW3_BOARD                   4'b1000
`define NONE				        4'b1111
`define MAIN                        2'b01
`define BACKUP                      2'b10

// `define IS_BACKUP                               // 需要根据主备区版本需求对应修改

//逻辑日期补充，不对外发布，内部检查使用
`define year	                    8'h26       // 每编译一次代码需要修改日期！！！
`define month	                    8'h03	    // 每编译一次代码需要修改日期！！！
`define day 	                    8'h09	    // 每编译一次代码需要修改日期！！！
`define number	                    8'h00	    // 每编译一次代码需要修改日期！！！,A,B,C

`define DEBUG_VERSION               4'b0000     // CPLD version to debug    ----high 4 bit
`define RELEASE_VERSION             4'b0001     // CPLD version to release  ----low 4 bit

`define OEM_TYPE                    4'b1000     // 0000：白盒，0001：字节，0010：快手，0011：百度，0100：腾讯，0101：美团，0110：华三通用白盒，0111：京东，1000:自研项目

`define	IIC_ADDR_BYTE               1'd0        //BMC I2C data: 1 byte


`endif
