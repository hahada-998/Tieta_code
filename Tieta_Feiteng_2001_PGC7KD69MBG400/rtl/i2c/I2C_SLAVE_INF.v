//======================================================================================
// Copyright(c) 2023, Cloudnine Technology Inc, All right reserved
//
// Filename    : I2C_SLAVE_INF.v
// Project     : 2023 R4970
// Author      : DINGXIANHUA
// Date        : 2023/09/04
// Email       : dingxianhua@cloudnineinfo.com
// Company     : Cloudnine Technology .Inc
//
//--------------------------------------------------------------------------------------
//Description :
//
//Modification History:
//Date              By              Revision                Change Description
//2023/09/04        dingxianhua     1.0                     file created

/******************************************************************************************/
  
module I2C_SLAVE_INF    #
(
parameter   I2C_ADR    =    8'h60           // The 7-bits address for our I2C slave
)
(
// system interface
input               rst_n       ,
input               sys_clk     ,

// I2C interface
input               scl         ,
inout               sda         ,

output      [7:0]   reg_addr    ,
input       [7:0]   rdata       ,
output reg          wrdata_en   ,
output      [7:0]   wrdata

);


reg     [2:0]   scl_r           ;               // scl/sda input register
reg     [2:0]   sda_r           ;               // scl/sda input register
wire            start_con       ;
wire            stop_con        ;               // START / stop condition pulse

wire            cycle_pulse     ;               // cycle positive pulse clock enalbe
wire            cycle_pulse_n   ;               // cycle negative pulse clock enalbe

reg             operation_dir   ;               // read operation ( =1 ) or write operation ( =0 )

reg     [3:0]   bit_cnt         ;               // down counter
wire            byte_done       ;

reg             sda_out         ;
reg             sda_oe          ;               // sda output enable (for tristate, low active)



reg     [7:0]   cpu_reg_addr    ;
reg     [7:0]   cpu_reg_datar   ;
wire            addr_match      ;
reg     [7:0]   shift_reg       ;


reg             rd_ack          ;
reg             rdata_en        ;

// statemachine declaration
localparam   IDLE            =   7'b0000001;
localparam   SLAVE_ADDR      =   7'b0000010;
localparam   SLAVE_ADDR_ACK  =   7'b0000100;
localparam   REG_ADDR        =   7'b0001000;
localparam   REG_ADDR_ACK    =   7'b0010000;
localparam   DATA            =   7'b0100000;
localparam   DATA_ACK        =   7'b1000000;

reg [6:0]       curr_state      ;
reg [6:0]       next_state      ;



assign reg_addr = cpu_reg_addr;
assign wrdata   = shift_reg;


//========================写数据===============================================================//
always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
        shift_reg   <=  8'd0;
    else if(cycle_pulse)
        shift_reg   <=  {shift_reg[6:0],sda_r[1]};
end


always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
        cpu_reg_addr <= 8'h0;
    end
    else if(cycle_pulse_n && (next_state == REG_ADDR_ACK))
    begin
         cpu_reg_addr <= shift_reg;
    end
    else if(cycle_pulse_n && (curr_state == DATA_ACK) && (next_state == DATA) )
    begin
         cpu_reg_addr <= cpu_reg_addr + 1'b1;
    end
end

always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
         rdata_en <= 1'b0;
    end
    else if (cycle_pulse_n && (curr_state != DATA) && (next_state == DATA))
    begin
         rdata_en <= 1'b1;
    end
    else
    begin
         rdata_en <= 1'b0;
    end
end

always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
        wrdata_en<=1'b0;
    end
    else if (cycle_pulse_n && (next_state == DATA_ACK) && (operation_dir == 1'b0))
    begin
        wrdata_en<=1'b1;
    end

    else
        wrdata_en<=1'b0;
end

always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
        cpu_reg_datar <= 8'd0;
    else if (rdata_en)
    begin
        cpu_reg_datar <= rdata;
    end
    else if (cycle_pulse_n && (curr_state == DATA) && (operation_dir == 1'b1))
   begin
        cpu_reg_datar <= {cpu_reg_datar[6:0], 1'b0};
    end
end

//============================检测i2c起始/结束条件==========================================//
always @(posedge sys_clk or negedge rst_n)
begin
     if (rst_n == 1'b0)
     begin
           scl_r    <= 3'b111;
           sda_r    <= 3'b111;
     end
     else
     begin
           scl_r    <= {scl_r[1:0],scl};
           sda_r    <= {sda_r[1:0],sda};
     end
end


assign start_con = sda_r[2] & (~sda_r[1]) & scl_r[1];
assign stop_con = (~sda_r[2]) & sda_r[1] & scl_r[1];

assign cycle_pulse = (~scl_r[2]) & scl_r[1];
assign cycle_pulse_n = scl_r[2] & (~scl_r[1]);



//==================================每计数8为一个周期=========================================//
always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
        bit_cnt <= 4'd8;
    else if (start_con)
          bit_cnt <= 4'd8;
    else if(cycle_pulse)
    begin
        if (byte_done)
            bit_cnt <= 4'd8;
        else
            bit_cnt <= bit_cnt - 1'b1;
    end
end

assign byte_done = (bit_cnt == 4'd0);


assign addr_match = (shift_reg[7:1] == I2C_ADR[7:1]);
assign sda = (sda_oe) ? sda_out : 1'bz;



//======================================================================================//
// I2C slave statemachine
//======================================================================================//
// state machine current state flip-flop

always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
        curr_state <= IDLE;
    else if (stop_con)
        curr_state <= IDLE;
    else if (start_con)
        curr_state <= SLAVE_ADDR;
    else if (cycle_pulse_n)
        curr_state <= next_state;
end

// state machine next state codec
always @(*)
begin
    case(curr_state)
        IDLE:
        begin
            if (start_con)
                next_state = SLAVE_ADDR;
            else
                next_state = IDLE;
        end
        SLAVE_ADDR:
        begin
            if (byte_done)
            begin
                if(addr_match)
                    next_state = SLAVE_ADDR_ACK;
                else
                    next_state = IDLE;
            end
            else
            begin
                next_state = SLAVE_ADDR;
            end
        end
        SLAVE_ADDR_ACK:
        begin
            if(operation_dir)
                next_state = DATA;
            else
                next_state = REG_ADDR;
        end
        REG_ADDR:
        begin
            if(byte_done)
                next_state = REG_ADDR_ACK;
            else
                next_state = REG_ADDR;
        end
        REG_ADDR_ACK:
        begin
            next_state = DATA;
        end
        DATA:
        begin
            if (byte_done)
                next_state = DATA_ACK;
            else
                next_state = DATA;
        end
        DATA_ACK:
        begin
            if (operation_dir && rd_ack)     //如果读ACK无效的话则结束操作；否则连续读或写，地址加1
                next_state = IDLE;
            else
                next_state = DATA;
        end
        default:
        begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
         operation_dir  <= 1'b0;
    end
    else if (curr_state == IDLE)
    begin
        operation_dir <= 1'b0;
    end
    else if (curr_state == SLAVE_ADDR && byte_done && addr_match)
    begin
        operation_dir <= shift_reg[0];
    end
end

always @(posedge sys_clk or negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
        rd_ack  <= 1'b0;
    end
    else if (curr_state == IDLE)
    begin
        rd_ack <= 1'b0;
    end
    else if (curr_state == DATA_ACK && operation_dir && cycle_pulse)
    begin
        rd_ack <= sda_r[1];
    end
end

// state machine output codec
always @(*)
begin
      // state machine default output
    case (curr_state)
        IDLE:
        begin
            sda_oe  = 1'b0;             // sda output disabled
            sda_out = 1'b0;
        end
        SLAVE_ADDR:
        begin
            sda_oe  = 1'b0;
            sda_out = 1'b0;
        end
        SLAVE_ADDR_ACK:
        begin
            sda_oe  = 1'b1;     // generate i2c_ack
            sda_out = 1'b0;
        end
        REG_ADDR:
        begin
            sda_oe  = 1'b0;
            sda_out = 1'b0;
        end
        REG_ADDR_ACK:
        begin
            sda_oe  = 1'b1;
            sda_out = 1'b0;
        end
        DATA:
        begin
            if(operation_dir)    // read operation
            begin
                if(next_state == DATA_ACK && ~scl_r[1]) //release as quickly as scl down
                    sda_oe = 1'b0;
                else
                    sda_oe = 1'b1;
                sda_out = cpu_reg_datar[7];
            end
            else                // write operation
            begin
                sda_oe  = 1'b0;
                sda_out = 1'b0;
            end
        end
        DATA_ACK:
        begin
            if(operation_dir)    // read operation
            begin
                sda_oe  = 1'b0;
                sda_out = 1'b0;
            end
            else                // write operation
            begin
                sda_oe  = 1'b1;
                sda_out = 1'b0;
            end
        end
        default:
        begin
            sda_oe  = 1'b0;             // sda output disabled
            sda_out = 1'b0;
        end
    endcase

end

endmodule
