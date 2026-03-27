

module bmc_cpld_i2c_ram #( 
    parameter DLY_LEN       = 3   //24.18MHz,330ns
)(
    input               i_rst_n                 , 
    input               i_clk                   ,
    input               t1s                     , 
    input               t1us                    ,
    input               t125ms                  ,
    input               pgoodaux                , 
    input               pon_reset_sasd          ,
    input               i_1ms_clk               ,	
    input               i_rst_i2c_n             ,

    input               i_scl                   , 
    inout               io_sda                  ,
    /*CLK Control Register*/

    input   [15:0]      mb_cpld2_ver              //addr 0x00FC-0x00FD[7:0
);
	
///////////////////////////////////////////////////////////////////////
//parameter VAL_FAN_WDT = 6'd5;


wire [31:0] mb_cpld1_date = 32'h20240813;//`CPLD_DATE_YYYYMMDD;
wire [31:0] mb_cpld1_time = 32'h11200000;//`CPLD_TIME_HHMMSSXX;

////////////////////////////////////////////////////////////////////////
//CPLD TOP --> CPLD RAM , BMC read
///////////////////////////////////////////////////////////////////////
wire w_i2c_start;
wire w_WR       ;
wire w_data_vld_pos;
wire [15:0]w_i2c_command ;
wire [7:0] w_i2c_data_out;

reg [7:0] r_i2c_data_in;

assign w_ram_00FC = mb_cpld2_ver[7:0];
assign w_ram_00FD = mb_cpld2_ver[15:8];
							
always@(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
	begin
	    r_i2c_data_in  <= 8'h00;
	end
	else 
	begin
	case(w_i2c_command)
	    16'h00FC: r_i2c_data_in  <= w_ram_00FC;
	    16'h00FD: r_i2c_data_in  <= w_ram_00FD;
	    default: r_i2c_data_in <= 8'h00;
	endcase
	end
end
 
///////////////////////////////////////////////////////////////////////
//write data to cpld
///////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////
//i2c slave
///////////////////////////////////////////////////////////////////////
i2c_slave_bmc  #(
.DLY_LEN                 (DLY_LEN)      //3   //24.18MHz,330ns
)i2c_slave_bmc_u1(
.i_rst_n                 (i_rst_n    ), 
.i_clk                   (i_clk      ),
.i_1ms_clk               (i_1ms_clk  ),
.i_rst_i2c_n             (i_rst_i2c_n),

.i_scl                   (i_scl         ),
.io_sda                  (io_sda        ),

.i_i2c_address           (7'h10         ),
.o_i2c_start             (w_i2c_start   ),
.o_WR                    (w_WR          ),
.o_data_vld_pos          (w_data_vld_pos),
.o_i2c_command           (w_i2c_command ),
.i_i2c_data_in           (r_i2c_data_in),
.o_i2c_data_out          (w_i2c_data_out)
); 
	
endmodule 