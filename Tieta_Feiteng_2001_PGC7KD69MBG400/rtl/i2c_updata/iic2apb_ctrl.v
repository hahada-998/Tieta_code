/**********************************************************************************************************************************/
// Copyright(c) 2020, Hangzhou CNIT Technologies Co., Ltd, All right reserved
// Project      :   
// Filename     :   iic2apb_ctrl.v
// Author       :   w00641
// Email        :   wanglin@cloudnineinfo.com
// Date         :   2025-05-19
// Description  :   
// Device       :   
// Modification History:
/**************************************************************版本记录************************************************************/
// 2025-05-19   wanglin        1.0           1、文件创建；2、按照CPLD开发checklist2.0版本check修改

module iic2apb_ctrl (
input		 	clk			,
input		 	rst_n		,
output [4:0] 	apb_addr	,
output          apb_sel		,
output       	apb_en		,
output       	apb_wr		,
output [7:0] 	apb_wdata	,
input  [7:0] 	apb_rdata	,
input        	apb_rdy		,
input        	apb_irq		,		
//i2c
output [7:0]    i2c_tx_data	,
input           i2c_tx_req	,
output          i2c_tx_vld	,
input  [7:0]	i2c_rx_data	,
input           i2c_rx_vld	,
output reg      i2c_rx_rdy	,

input           i2c_lost_arb,
//for test
output          apb_bus_status
//output [3:0]  c_i2c_state ,
//output [3:0]  c_state     ,
//input  [7:0]  i2c_command 
);

//---------------------------------------------------------------------------------
//i2c command define
//---------------------------------------------------------------------------------
//no data from i2c,RD command
localparam	RDID 			= 'hA1;		//read IDCODE reg 0~3
localparam	RDUSER 			= 'hA2;		//read USERCODE reg 0~3
localparam	RDSR 			= 'hA3;		//read  config sys status reg 0~3
localparam	RDUID 			= 'hA4;		//read UID reg 0~7
//no data from i2c,WR command
localparam	WREN 			= 'h51;		//wr enable
localparam	WRDIS 			= 'h52;		//wr disable
localparam	RESET 			= 'h60;		//reset	CPLD
localparam	ERASE 			= 'h10;		//erase bulk
localparam	EFLASH_SLEEP 	= 'h70;		//embedded flash sleep
localparam	EFLASH_WAKEUP 	= 'h71;		//embedded flash wake up
//program flash
localparam	PROGRAM 		= 'h20;		//program page
//read flash	
localparam	READ 			= 'h30;		
//no data from i2c,WR data reg
localparam	PROGRAM_CTL 	= 'h22;		//program feature control bit
localparam	PROGRAM_LOCK 	= 'h40;		//lock	embedded flash
//no data from i2c,RD data reg
localparam	READ_CTL 		= 'h31;		//read feature control

//---------------------------------------------------------------------------------
//APB reg addr define
//---------------------------------------------------------------------------------
//R only
localparam	IDCODER0		= 'b0_0000;
localparam	IDCODER1		= 'b0_0001;
localparam	IDCODER2		= 'b0_0010;
localparam	IDCODER3		= 'b0_0011;
//--------->RDUSER
localparam	USERCODER0		= 'b0_0100;
localparam	USERCODER1		= 'b0_0101;
localparam	USERCODER2		= 'b0_0110;
localparam	USERCODER3		= 'b0_0111;
//--------->RDUID
localparam	UIDR0			= 'b0_1000;
localparam	UIDR1			= 'b0_1001;
localparam	UIDR2			= 'b0_1010;
localparam	UIDR3			= 'b0_1011;
localparam	UIDR4			= 'b0_1100;
localparam	UIDR5			= 'b0_1101;
localparam	UIDR6			= 'b0_1110;
localparam	UIDR7			= 'b0_1111;
//--------->RDSR
localparam	STATUSR0		= 'b1_0000;
localparam	STATUSR1		= 'b1_0001;
localparam	STATUSR2		= 'b1_0010;
localparam	STATUSR3		= 'b1_0011;
//R/W
localparam	IRQCTLR			= 'b1_0100;
localparam	CMDR			= 'b1_0101;
localparam	ADR0			= 'b1_0110;//16
localparam	ADR1			= 'b1_0111;//17
localparam	ADR2			= 'b1_1000;//18
//W only
localparam	DATATR			= 'b1_1001;
//R only
localparam	DATARR			= 'b1_1010;//1a
localparam	STATUSR			= 'b1_1011;//1b
localparam	IRQSTATUSR		= 'b1_1100;
localparam	IRQR			= 'b1_1101;
localparam	LOCKRAR0		= 'b1_1110;
localparam	LOCKRAR1		= 'b1_1111;

//command
localparam	NOP 		    = 'hff  ; // no operation
//---------------------------------------------------------------------------------
localparam	PAGE_CNT        = 'hff  ;
localparam	DATA_CNT        = 'h100 ;

reg [7:0]    tx_data                ;
reg          tx_vld	                ;
reg [7:0]    rx_data                ; 
reg          rx_vld                 ;  
reg          rx_vld_nxt1            ;
wire         rx_vld_pos             ;
reg			 rdy		            ;
reg			 sel		            ;
reg	[7:0]	 wdata	                ;
reg	[7:0]	 rdata      	        ;
reg          data_vld               ;
reg	[4:0]	 addr	                ;
reg	[3:0]	 c_state	            ;
reg	[3:0]	 n_state                ;
reg	[3:0]  	 c_i2c_state	        ;
reg	[3:0]	 n_i2c_state            ;
reg	[7:0]	 i2c_command            ;
reg [8:0]    apb_cnt                ;
reg          apb_flag               ;
reg          rx_rdy_nxt             ;

//state
localparam   s0			    = 4'b0000;
localparam   s1             = 4'b0001;
localparam   s2             = 4'b0010;
localparam   s3             = 4'b0011;
localparam   s4             = 4'b0100;
localparam   s5             = 4'b0101;
localparam   s6             = 4'b0110;
localparam   s7             = 4'b0111;
localparam   s8             = 4'b1000;
localparam   s9             = 4'b1001;
localparam   s10            = 4'b1010;
localparam   s11            = 4'b1011;
localparam   s12            = 4'b1100;

localparam   I2C_IDLE		= 4'b0000;
localparam   I2C_S1         = 4'b0001;
localparam   I2C_S2         = 4'b0010;
localparam   I2C_S3         = 4'b0011;
localparam   I2C_S4         = 4'b0100;
localparam   I2C_S5         = 4'b0101;
localparam   I2C_S6         = 4'b0110;
localparam   I2C_S7         = 4'b0111;

//---------------------------------------------------------------------------------
//i2c interface deal
//---------------------------------------------------------------------------------
always @ (posedge clk or negedge rst_n) begin
  if(!rst_n) 
	c_i2c_state <= I2C_IDLE;
  else          
    c_i2c_state <= n_i2c_state;
end

always @ (*) begin
n_i2c_state = c_i2c_state;
 case(c_i2c_state) 
    I2C_IDLE : 
                if(i2c_rx_vld)begin 
                    n_i2c_state=I2C_S1;
                end
    I2C_S1   :
        case(i2c_command)
            RDID:           n_i2c_state=I2C_S2;        
            RDUSER:         n_i2c_state=I2C_S2;
            RDSR:           n_i2c_state=I2C_S2;
            RDUID:          n_i2c_state=I2C_S2;


            WREN:           if(c_state==s2&&apb_rdy)n_i2c_state=I2C_IDLE;//wait apb wr last cmd
            WRDIS:          if(c_state==s2&&apb_rdy)n_i2c_state=I2C_IDLE;//wait apb wr last cmd
            RESET:          if(c_state==s2&&apb_rdy)n_i2c_state=I2C_IDLE;
            ERASE:          if(c_state==s2&&apb_rdy)n_i2c_state=I2C_IDLE;
            EFLASH_SLEEP:   if(c_state==s2&&apb_rdy)n_i2c_state=I2C_IDLE;
            EFLASH_WAKEUP:  if(c_state==s2&&apb_rdy)n_i2c_state=I2C_IDLE;
//add NOP
//            NOP:            if(c_state==s2&&apb_rdy)n_i2c_state=I2C_IDLE;

            PROGRAM:        n_i2c_state=I2C_S3;
            READ:           n_i2c_state=I2C_S4;
            PROGRAM_CTL:    n_i2c_state=I2C_S5;
            PROGRAM_LOCK:   n_i2c_state=I2C_S6;
            READ_CTL:       n_i2c_state=I2C_S7;
            default:;       
        endcase
    I2C_S2   : 
            if(c_state==s4&&tx_vld&&i2c_command!=RDUID||c_state==s8&&tx_vld)begin
                n_i2c_state=I2C_IDLE;
            end
            else n_i2c_state = c_i2c_state;
    I2C_S3   :
            if(apb_rdy&&c_state==s10)begin//one page rv done
                n_i2c_state=I2C_IDLE;
            end
    I2C_S4   :
            if(apb_rdy&&c_state==s11)begin
                n_i2c_state=I2C_IDLE;
            end 
    I2C_S5   :
            if(apb_rdy&&c_state==s9)begin
                n_i2c_state=I2C_IDLE;
            end 
    I2C_S7   :
            if(apb_rdy&&c_state==s7)begin
                n_i2c_state=I2C_IDLE;
            end                       				
	default : ;
 endcase
end

always @ (posedge clk or negedge rst_n)
 if(!rst_n) begin
   tx_vld<=0;
   tx_data<=0;
   rx_vld<=0;  
   rx_data<=0;
   i2c_command <= 'h0;
 end
 else if(n_i2c_state==I2C_S1&&i2c_rx_vld)begin
    i2c_command <= i2c_rx_data;   
 end
 else if(n_i2c_state==I2C_S2||n_i2c_state==I2C_S3||n_i2c_state==I2C_S4||n_i2c_state==I2C_S5||n_i2c_state==I2C_S7)begin
    rx_data<=i2c_rx_vld?i2c_rx_data:rx_data;
//  rx_vld<=i2c_rx_vld?1'b1:apb_rdy?1'b0:rx_vld;
    rx_vld<=i2c_rx_vld;
    tx_vld<=i2c_tx_req&&data_vld;
    tx_data<=i2c_tx_req&&data_vld?rdata:'d0;      
 end
 else begin
    tx_vld<=0;
    tx_data<=0;
    rx_vld<=0;  
    rx_data<=0;
    i2c_command <= 'h0;
 end

always @ (posedge clk) begin
   rx_vld_nxt1<=rx_vld;
end

assign    rx_vld_pos = rx_vld&~rx_vld_nxt1;
//---------------------------------------------------------------------------------
//APB interface deal
//---------------------------------------------------------------------------------   
always @ (posedge clk) begin
   rdy   <= apb_rdy;
   sel   <= apb_sel;
end

always @ (posedge clk or negedge rst_n)
  if(!rst_n)begin 
	c_state <= s0;
  end else begin          
    c_state <= n_state;
end

always @ (*) begin
 n_state = c_state;
 case(i2c_command) 
	RDID:
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy&&tx_vld) n_state = s2;//after tx current data,then next state
			s2:	if(apb_rdy&&tx_vld) n_state = s3;
			s3:	if(apb_rdy&&tx_vld) n_state = s4;
			s4:	if(apb_rdy&&tx_vld) n_state = s0;						
			default:n_state = s0;
		endcase
	RDUSER:
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy&&tx_vld) n_state = s2;//after tx current data,then next state
			s2:	if(apb_rdy&&tx_vld) n_state = s3;
			s3:	if(apb_rdy&&tx_vld) n_state = s4;
			s4:	if(apb_rdy&&tx_vld) n_state = s0;						
			default:n_state = s0;
		endcase
	RDSR:
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy&&tx_vld) n_state = s2;//after tx current data,then next state
			s2:	if(apb_rdy&&tx_vld) n_state = s3;
			s3:	if(apb_rdy&&tx_vld) n_state = s4;
			s4:	if(apb_rdy&&tx_vld) n_state = s0;						
			default:n_state = s0;
		endcase
	RDUID:
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy&&tx_vld) n_state = s2;//after tx current data,then next state
			s2:	if(apb_rdy&&tx_vld) n_state = s3;
			s3:	if(apb_rdy&&tx_vld) n_state = s4;
			s4:	if(apb_rdy&&tx_vld) n_state = s5;	
			s5:	if(apb_rdy&&tx_vld) n_state = s6;
			s6:	if(apb_rdy&&tx_vld) n_state = s7;
			s7:	if(apb_rdy&&tx_vld) n_state = s8;
			s8:	if(apb_rdy&&tx_vld) n_state = s0;						
			default:n_state = s0;
		endcase
	WREN:
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy) n_state = s2;
			s2:	if(apb_rdy) n_state = s0;					
			default:n_state = s0;
		endcase	
	WRDIS:begin
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy) n_state = s2;
			s2:	if(apb_rdy) n_state = s0;					
			default:n_state = s0;
		endcase
        end	
	RESET:begin
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy) n_state = s2;	            
			s2:	if(apb_rdy) n_state = s0;					
			default:n_state = s0;
		endcase
        end	
	ERASE:begin
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy) n_state = s2;	            
			s2:	if(apb_rdy) n_state = s0;					
			default:n_state = s0;
		endcase
        end	
	EFLASH_SLEEP:begin
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy) n_state = s2;	            
			s2:	if(apb_rdy) n_state = s0;					
			default:n_state = s0;
		endcase
        end	
	EFLASH_WAKEUP:begin
		case(c_state)
            s0: n_state = s1;
			s1:	if(apb_rdy) n_state = s2;	            
			s2:	if(apb_rdy) n_state = s0;					
			default:n_state = s0;
		endcase
        end	
//add NOP
//	NOP:begin
//		case(c_state)
//            s0: n_state = s1;
//			s1:	if(apb_rdy) n_state = s2;	            
//			s2:	if(apb_rdy) n_state = s0;					
//			default:n_state = s0;
//		endcase
//        end		
	PROGRAM:begin
		case(c_state)
            s0: if(rx_vld)n_state = s1;//program cmd from i2c
            s1: if(~rx_vld)n_state = s2;//program cmd from i2c
            s2: if(rx_vld&&apb_rdy&&apb_cnt==1'b0)n_state = s3;//wait valid data from i2c
                else if(rx_vld&&apb_rdy&&apb_cnt==1)n_state = s4;
                else if(rx_vld&&apb_rdy&&apb_cnt==2)n_state = s5;
			s3:	if(apb_rdy) n_state = s2;//wr addr0 to apb
			s4:	if(apb_rdy) n_state = s2;//wr addr1 to apb
			s5:	if(apb_rdy) n_state = s6;//wr addr2 to apb
			s6:	if(apb_rdy) n_state = s7;//wr program cmd to apb
            s7: if(rx_vld_pos)  n_state = s8;//wait valid data from i2c
                else if(apb_cnt==DATA_CNT)n_state = s9;
			s8:	if(apb_rdy&&apb_cnt==DATA_CNT) n_state = s9;//wr data to apb
                else if(apb_rdy) n_state = s7;
			s9:	if(apb_rdy) n_state = s10;
			s10:if(apb_rdy) n_state = s0;//rd status reg	
//
//			s10:if(apb_rdy) n_state = s11;//wr nop
//			s11:if(apb_rdy) n_state = s6;//wr wren			
			default:n_state = s0;
		endcase	
        end
	READ:begin
		case(c_state)
            s0: if(rx_vld)n_state = s1;//program cmd from i2c
            s1: if(~rx_vld)n_state = s2;//program cmd from i2c
            s2: if(rx_vld&&apb_rdy&&apb_cnt==1'b0)n_state = s3;//wait valid data from i2c
                else if(rx_vld&&apb_rdy&&apb_cnt==1)n_state = s4;
                else if(rx_vld&&apb_rdy&&apb_cnt==2)n_state = s5;
			s3:	if(apb_rdy) n_state = s2;//wr addr0 to apb
			s4:	if(apb_rdy) n_state = s2;//wr addr1 to apb
			s5:	if(apb_rdy) n_state = s6;//wr addr2 to apb
			s6:	if(apb_rdy) n_state = s7;//wr read cmd to apb
			s7:	if(apb_rdy&&i2c_tx_req) n_state = s8;//wait request from i2c
			s8:	if(apb_rdy) n_state = s9;//read data from apb
			s9:	if(apb_rdy&&apb_cnt==DATA_CNT) n_state = s10;//read data from apb
                else if(apb_rdy)n_state = s7;	
			s10:	if(apb_rdy) n_state = s11;	
			s11:if(apb_rdy) n_state = s0;							
			default:n_state = s0;
		endcase	
        end
	PROGRAM_CTL:begin
		case(c_state)
            s0: if(rx_vld)n_state = s1;//program cmd from i2c
            s1: if(~rx_vld&&apb_rdy)n_state = s2;//program cmd from i2c
            s2: if(apb_rdy)n_state = s3;////wr PROGRAM_CTL cmd to apb
            s3: if(apb_rdy&&apb_cnt==3)n_state = s5;////0~3dummy
                else if(rx_vld_pos)n_state = s4;
            s4: n_state = s3;////0~3dummy
            s5: if(apb_rdy)n_state = s6;
            s6: if(rx_vld_pos)  n_state = s7;//wait valid data from i2c
                else if(apb_cnt==4)n_state = s8;
//			s7:	if(apb_rdy&&apb_cnt==3) n_state = s8;//wr data to apb
//                else if(apb_rdy) n_state = s6;
			s7:	if(apb_rdy) n_state = s6;//wr data to apb
			s8:	if(apb_rdy) n_state = s9;//wr ctl4 to apb
			s9: if(apb_rdy) n_state = s0;//rd status reg			
			default:n_state = s0;
		endcase	
        end
	READ_CTL:begin
		case(c_state)
            s0: if(rx_vld)n_state = s1;//program cmd from i2c
            s1: if(~rx_vld)n_state = s2;//program cmd from i2c
			s2:	if(apb_rdy) n_state = s3;//wr READ_CTL cmd to apb
			s3:	if(apb_rdy&&i2c_tx_req) n_state = s4;//wait request from i2c	
			s4:	if(apb_rdy) n_state = s5;//read data from apb
			s5:	if(apb_rdy&&apb_cnt==4) n_state = s6;//read data from apb
                else if(apb_rdy)n_state = s3;	
			s6:	if(apb_rdy) n_state = s7;	//wr NOP cmd to apb
			s7: if(apb_rdy) n_state = s0;							
			default:n_state = s0;
		endcase	
        end
	default : n_state = s0;
 endcase
end

always @ (posedge clk or negedge rst_n) begin
 if(!rst_n) begin
   rdata <= 8'b0000_0000;
   data_vld<=0; 
   wdata <= 8'b0000_0000;
   addr  <= 5'b1_1111;
   apb_cnt<=0;
   apb_flag<=0;
 end
 else begin
	case(i2c_command)
	s0: begin
           data_vld<=i2c_tx_req; 
           rdata <= 'd0;
           wdata <= 'd0;
           addr  <= 5'b1_1111;
           apb_cnt<=0;
           apb_flag<=0;
		end
	RDID:			begin
					    wdata <= 8'b0000_0000;
                    if(apb_rdy&&i2c_tx_req)begin
                        rdata<=apb_rdata;                    
                        data_vld<=1;                        
                    end
                    else
                        data_vld <=0; 
					case(n_state)
					s1  : addr  <= IDCODER0;	
					s2  : addr  <= IDCODER1; 
					s3  : addr  <= IDCODER2; 
					s4  : addr  <= IDCODER3;			
					default:;
					endcase
					end
	RDUSER:			begin
					    wdata <= 8'b0000_0000;
                    if(apb_rdy&&i2c_tx_req)begin
                        rdata<=apb_rdata;                    
                        data_vld<=1;                        
                    end
                    else
                        data_vld <=0; 
					case(n_state)
					s1  : addr  <= USERCODER0;	
					s2  : addr  <= USERCODER1; 
					s3  : addr  <= USERCODER2; 
					s4  : addr  <= USERCODER3;			
					default:;
					endcase
					end
	RDSR:			begin
					    wdata <= 8'b0000_0000;
                    if(apb_rdy&&i2c_tx_req)begin//wait i2c tx request
                        rdata<=apb_rdata;                    
                        data_vld<=1;                        
                    end
                    else 
                        data_vld <=0;
					case(n_state)
						s1  : addr  <= STATUSR0; 	
						s2  : addr  <= STATUSR1; 
						s3  : addr  <= STATUSR2; 
						s4  : addr  <= STATUSR3;
					default:;
					endcase
					end
	RDUID:			begin
					    wdata <= 8'b0000_0000;
                    if(apb_rdy&&i2c_tx_req)begin//wait i2c tx request
                        rdata<=apb_rdata;                    
                        data_vld<=1;                        
                    end
                    else 
                        data_vld <=0;
					case(n_state)
						s1  : addr  <= UIDR0; 	
						s2  : addr  <= UIDR1; 
						s3  : addr  <= UIDR2; 
						s4  : addr  <= UIDR3;
						s5  : addr  <= UIDR4; 	
						s6  : addr  <= UIDR5; 
						s7  : addr  <= UIDR6; 
						s8  : addr  <= UIDR7;
					default:;
					endcase
					end
	WREN:			begin		
					addr  <= CMDR;
					case(n_state)
						s1  :  wdata <= NOP;	
						s2  :  wdata <= WREN; 
						default:;
					endcase
					end	
	WRDIS:			begin		
					addr  <= CMDR;
					case(n_state)
						s1  : wdata <= WRDIS;	
						s2  : wdata <= NOP; 
						default:;
					endcase
					end
	RESET:			if(n_state==s2)begin
						addr  <= CMDR;
						wdata <= RESET;
					end
	ERASE:			if(n_state==s2)begin
						addr  <= CMDR;
						wdata <= ERASE;
					end
	EFLASH_SLEEP:	if(n_state==s2)begin
						addr  <= CMDR;
						wdata <= EFLASH_SLEEP;
					end
	EFLASH_WAKEUP:	if(n_state==s2)begin
						addr  <= CMDR;
						wdata <= EFLASH_WAKEUP;
					end
//	NOP:	        if(n_state==s2)begin
//						addr  <= CMDR;
//						wdata <= NOP;
//					end
	PROGRAM:		begin                    
					case(n_state)
//                    s1  : apb_flag<=1;
//                    s2  : apb_flag<=1;
					s3  : begin
                            apb_flag<=0;
                            addr  <= ADR2; wdata <= rx_data; 
                            if(apb_rdy) apb_cnt<=apb_cnt+1;
                          end	
					s4  : begin
                            apb_flag<=0;
                            addr  <= ADR1; wdata <= rx_data; 
                            if(apb_rdy) apb_cnt<=apb_cnt+1;
                          end	 
					s5  : begin addr  <= ADR0; wdata <= rx_data;apb_flag<=0; end	 
					s6  : begin addr  <= CMDR; wdata <= PROGRAM; apb_cnt<=0;end
//					s7  : begin addr  <= DATATR;wdata <= rx_data;apb_flag<=1;end  
					s7  : begin addr  <= STATUSR;apb_flag<=1;if(apb_rdy&&rx_vld)apb_cnt<=apb_cnt+1;end                                                         
					s8  : begin
                            addr  <= DATATR;wdata <= rx_data;apb_flag<=0;
                          end                                                     
					s9  : begin addr  <= CMDR; wdata <= NOP; apb_cnt <= 0; apb_flag<=0;end//RD
//					s10  : begin addr  <= CMDR;wdata <= NOP;end 
//					s11  : begin addr  <= CMDR;wdata <= WREN;end 
					default:;
					endcase
					end
	READ:		    begin                    
					case(n_state)
					s3  : begin
                            addr  <= ADR2; wdata <= rx_data; 
                            if(apb_rdy) apb_cnt<=apb_cnt+1;
                          end	
					s4  : begin
                            addr  <= ADR1; wdata <= rx_data; 
                            if(apb_rdy) apb_cnt<=apb_cnt+1;
                          end	 
					s5  : begin addr  <= ADR0; wdata <= rx_data; end		 
					s6  : begin addr  <= CMDR; wdata <= READ; apb_cnt<=0;end 
                    s7  : apb_flag<=1;                                                                                                                                                                                 
                    s8  : begin
                                addr <=DATARR;
                                data_vld<=0;
                                apb_flag<=0;
                          end
                    s9  : begin 
                          apb_flag<=1;
                          addr <=STATUSR;
                          if(apb_rdy)begin
                                data_vld<=1;
                                rdata<={apb_rdata[0],apb_rdata[1],apb_rdata[2],apb_rdata[3],apb_rdata[4],apb_rdata[5],apb_rdata[6],apb_rdata[7]};
                                apb_cnt<=apb_cnt+1;
                          end
                          else begin                                
                                data_vld<=0;
                          end
                          end
					s10  : begin addr  <= CMDR; wdata <= NOP;apb_cnt <= 0; end//RD
					s11 : begin addr  <= STATUSR;end//RD
					default:;
					endcase
					end	
	PROGRAM_CTL:	begin                    
					case(n_state)
                    s0  : begin apb_flag<=1;end
                    s2  : begin addr  <= CMDR; wdata <= 8'h21;apb_cnt <= 0;apb_flag<=0;end
                    s3  : begin apb_flag<=1;end
                    s4  : begin apb_cnt<=apb_cnt+1;end
                    s5  : begin apb_cnt <= 0;end
                    s6  : begin apb_flag<=1;addr  <= STATUSR;if(apb_rdy&&rx_vld)apb_cnt<=apb_cnt+1;end   
					s7  : begin
                            addr  <= DATATR; wdata <= {rx_data[0],rx_data[1],rx_data[2],rx_data[3],rx_data[4],rx_data[5],rx_data[6],rx_data[7]};apb_flag<=0; 
                          end		 
//					s8  : begin addr  <= DATATR; wdata <= rx_data;apb_flag<=0; end	  
					s8  : begin apb_flag<=0; end	  
					s9  : begin addr  <= CMDR; wdata <= NOP; apb_cnt <= 0; apb_flag<=0;end                                              
//					s9  : begin addr  <= STATUSR; apb_cnt <= 0; apb_flag<=0;end//RD
					default:;
					endcase
					end	
	READ_CTL:		begin                    
					case(n_state)	 
					s2  : begin addr  <= CMDR; wdata <= READ_CTL; apb_cnt<=0;end 
                    s3  : apb_flag<=1;                                                                                                                                                                                 
                    s4  : begin
                                addr <=DATARR;
                                data_vld<=0;
                                apb_flag<=0;
                          end
                    s5  : begin 
                          apb_flag<=1;
                          addr <=STATUSR;
                          if(apb_rdy)begin
                                data_vld<=1;
                                rdata<=apb_rdata;
                                apb_cnt<=apb_cnt+1;
                          end
                          else begin                                
                                data_vld<=0;
                          end
                          end
					s6  : begin addr  <= CMDR; wdata <= NOP;apb_cnt <= 0;apb_flag<=0; end//RD
					s7 :  begin addr  <= STATUSR;end//RD
				    default:;
					endcase
					end			
		default : begin	wdata <= 8'b0000_0000;end  
	endcase
 end
end

assign apb_addr  = addr;
assign apb_sel   = (c_state==0||(i2c_command==PROGRAM&&c_state==s7)||(i2c_command==PROGRAM_CTL&&c_state==s6)) ? 1'b0 : 1'b1;
//assign apb_sel   = 1'b1;
assign apb_en    = ((apb_sel && !sel) || rdy || !apb_sel || !c_state||apb_flag) ? 1'b0 : 1'b1;
assign apb_wr    = (i2c_command==RDID||i2c_command==RDSR||i2c_command==RDUSER||i2c_command==RDUID||
                    (i2c_command==PROGRAM&&(c_state==s7||c_state==s2))||
                    (i2c_command==PROGRAM_CTL&&(c_state==s6||c_state==s3||c_state==s4||c_state==s5||c_state==s1||c_state==s0))||
                    (i2c_command==READ&&(c_state==s8||c_state==s11||c_state==s2))||
                    (i2c_command==READ_CTL&&(c_state==s4||c_state==s7))               
                   ) ? 1'b0 : 1'b1;
assign apb_wdata = wdata;

//for test 
assign apb_bus_status = (i2c_command==PROGRAM&&c_state==s10)?apb_rdata[2]:0;

always @ (posedge clk or negedge rst_n) begin
  if(!rst_n) 
	i2c_rx_rdy <= 0;
  else if(i2c_rx_vld&&apb_rdy)          
    i2c_rx_rdy <= 1;
  else
    i2c_rx_rdy <= 0;
end

always @ (posedge clk or negedge rst_n) begin
  if(!rst_n) 
	rx_rdy_nxt <= 0;
  else
    rx_rdy_nxt <= i2c_rx_rdy;
end

assign   i2c_tx_data =  {tx_data[0],tx_data[1],tx_data[2],tx_data[3],tx_data[4],tx_data[5],tx_data[6],tx_data[7]};
//assign   i2c_tx_data =  tx_data;
assign   i2c_tx_vld =   tx_vld&i2c_tx_req;

endmodule
