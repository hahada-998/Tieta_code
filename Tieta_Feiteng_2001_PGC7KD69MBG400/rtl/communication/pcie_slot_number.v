//=================================================================================================--
// Copyright(c) 2021, CLOUDNINEINFO.CO, Ltd, All right reserved
// Filename   : AIS03MB03.v
// Project    : CLOUDNINEINFO common code
// Author     : DINGXIANHUA
// Date       : 2023-09-06
// Email      : dingxianhua@cloudnineinfo.com
// Company    : CLOUDNINEINFO.CO., Ltd
//
//--------------------------------------------------------------------------------------
//Description :
//
//Modification History:
//Date              By              Revision                Change Description
//2023/09/06        dingxianhua     1.0                     file created

/******************************************************************************************/
module pcie_slot_number(
  input            clk         ,
  input            rst         ,
  input      [1:0] chassis_id  ,
  input    [127:0] pcie_detect ,
  input    [31:0]  BP_TYPE     ,
  
  output   [99:0]  nvme_slot_number  
  
);

//BP_TYPE
/*
localparam 12LUF      = 4'b0001;
localparam 12LU08ULF  = 4'b0010;  
localparam 25S        = 4'b0011;
localparam 8SUF       = 4'b0100;
localparam E3S        = 4'b0101;
localparam 8SUFA      = 4'b0110;
localparam E1S_16     = 4'b0111;
localparam E1S_8      = 4'b1000;
*/

reg [99:0] slot_number_nvme;
assign nvme_slot_number = ~slot_number_nvme;

always@(posedge clk or negedge rst) begin
    if (!rst) begin
      slot_number_nvme <= 100'b0;
	end
    else if(chassis_id == 2'b01) begin        /*1U R4700*/
	  case(BP_TYPE[3:0])
	    4'b0111:begin                                  /*1U E1S_16*/
		  slot_number_nvme[49:0] <= {18'b0,pcie_detect[31:16],pcie_detect[15:0]};      //front NVME slot_number
		end
		default:begin
		  slot_number_nvme[49:0] <= {40'b0,pcie_detect[7],pcie_detect[18],pcie_detect[6],pcie_detect[16],pcie_detect[5:0]}; //front NVME slot_number
        end
	  endcase
	   slot_number_nvme[79:50] <= {27'b0,pcie_detect[66],pcie_detect[64],1'b0};   //rear NVME slot_number
       slot_number_nvme[99:80] <= {20'b0};	   //middle NVME slot_number
	  end
	else if((chassis_id == 2'b10) || (chassis_id == 2'b11)) begin    /*2U R4900*/
      case(BP_TYPE[3:0])
	    4'b0001:begin                       /*2U 12LUF*/
		  slot_number_nvme[49:0] <= {38'b0,pcie_detect[11:0]};
		  if(BP_TYPE[19:16] == 4'b1000)begin   /*if R4900 G6 rear_BOX5_BP is E1S_8*/
		    slot_number_nvme[79:50] <= {22'b0,pcie_detect[71:64]};   //rear NVME slot_number
          end
		  else begin
		    slot_number_nvme[79:50] <= {26'b0,pcie_detect[67:64]};   //rear NVME slot_number
          end
	   end
	   4'b0010:begin                       /*2U 12L08ULF*/
          slot_number_nvme[49:0] <= {38'b0,pcie_detect[7:0],4'b0};  //front NVME slot_number
          if(BP_TYPE[19:16] == 4'b1000)begin   /*if R4900 G6 rear_BOX5_BP is E1S_8*/
            slot_number_nvme[79:50] <= {22'b0,pcie_detect[71:64]};   //rear NVME slot_number
          end
          else begin
		    slot_number_nvme[79:50] <= {26'b0,pcie_detect[67:64]};   //rear NVME slot_number
          end
	   end
       4'b0011:begin                       /*2U 25S*/
          slot_number_nvme[49:0] <= {25'b0,pcie_detect[7:0],17'b0};  //front NVME slot_number
          if(BP_TYPE[19:16] == 4'b1000)begin   /*if R4900 G6 rear_BOX5_BP is E1S_8*/
            slot_number_nvme[79:50] <= {22'b0,pcie_detect[71:64]};   //rear NVME slot_number
          end
          else begin
		    slot_number_nvme[79:50] <= {26'b0,pcie_detect[67:64]};   //rear NVME slot_number
          end
	   end
       4'b0111:begin                       /*2U E1.S 16*/
          slot_number_nvme[49:0] <= {18'b0,pcie_detect[31:16],pcie_detect[15:0]};  //front NVME slot_number
          if(BP_TYPE[19:16] == 4'b1000)begin   /*if R4900 G6 rear_BOX5_BP is E1S_8*/
            slot_number_nvme[79:50] <= {22'b0,pcie_detect[71:64]};   //rear NVME slot_number
          end
          else begin
		    slot_number_nvme[79:50] <= {26'b0,pcie_detect[67:64]};   //rear NVME slot_number
          end
	   end
	   default: begin
	      slot_number_nvme[49:0] <= {26'b0,pcie_detect[39:32],pcie_detect[23:16],pcie_detect[7:0]};  //front NVME slot_number
          if(BP_TYPE[19:16] == 4'b1000)begin   /*if R4900 G6 rear_BOX5_BP is E1S_8*/
            slot_number_nvme[79:50] <= {22'b0,pcie_detect[71:64]};   //rear NVME slot_number
          end
          else begin
		    slot_number_nvme[79:50] <= {26'b0,pcie_detect[67:64]};   //rear NVME slot_number
          end
	   end
	  endcase
	    slot_number_nvme[99:80] <= 20'b0;//middle NVME slot_number
    end
	else begin
	    slot_number_nvme <= 100'b0;
    end
  end

endmodule



