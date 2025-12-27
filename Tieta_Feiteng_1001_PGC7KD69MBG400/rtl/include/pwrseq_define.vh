`define SM_RESET_STATE                  6'h00;
`define SM_IDLE                         6'h00;//IMPORTANT

`define SM_EN_P3V3_VCC                  6'h03;
`define SM_INIT                         6'h03;//IMPORTANT

// `define SM_EN_PCH_DSW_PWROK      6'h09;
// `define SM_EN_PCH_P1V8           6'h07;
// `define SM_EN_PCH_PVNN           6'h08;
// `define SM_EN_PCH_P1V05          6'h1A;
// `define SM_PCH_RSMRST_RELEASE    6'h1B;
`define SM_OFF_STANDBY                  6'h05;//**
`define SM_PS_ON                        6'h0E;
`define SM_EN_5V_STBY                   6'h0F;

`define SM_EN_TELEM                     6'h1C;
`define SM_EN_MAIN_EFUSE                6'h06;
`define SM_EN_5V                        6'h0B;
`define SM_EN_3V3                       6'h19;    

`define SM_EN_P1V8                      6'h21;   //YHY 
`define SM_EN_P2V5_VPP                  6'h22;
`define SM_EN_VP                        6'h23;
`define SM_EN_P0V8                      6'h24;
`define SM_EN_VDD                       6'h26; 

`define SM_CPU_RESET                    6'h28; 
`define PEX_RESET                       6'h30; 

//YHY `define SM_EN_P0V6_VTT        6'h15;
`define SM_EN_VCCIO                     6'h1F;
//YHY  
//YHY  `define SM_EN_VCC1V8           6'h17;   //pwr
//YHY  `define SM_EN_VCCANA           6'h18;   //pwr
//YHY  
//YHY  `define SM_EN_VCCIN            6'h16;
`define SM_EN_VCCSA                     6'h27;
//YHY  `define SM_EN_1V0                6'h28;
`define SM_EN_VMCP                      6'h2B;
`define SM_WAIT_POWEROK                 6'h13;
`define SM_STEADY_PWROK                 6'h11;//**

`define SM_CRITICAL_FAIL                6'h10;



`define SM_DISABLE_VDD                  6'h2D;
`define SM_DISABLE_P0V8                 6'h2E;
`define SM_DISABLE_VP                   6'h3B;
`define SM_DISABLE_P2V5_VPP             6'h31;
`define SM_DISABLE_P1V8                 6'h33;


`define SM_DISABLE_VMCP                 6'h2D;
//yhy `define SM_DISABLE_1V0         6'h2E;
`define SM_DISABLE_VCCSA                6'h3B;
//YHY  `define SM_DISABLE_VCCIN      6'h31;
//YHY  
//YHY  `define SM_DISABLE_VCCANA     6'h30;   //pwr
//YHY  `define SM_DISABLE_VCC1V8     6'h33;   //pwr
//YHY  
`define SM_DISABLE_VCCIO                6'h34;
//YHY  `define SM_DISABLE_P0V6_VTT      6'h32;
//YHY  `define SM_DISABLE_P2V5_VPP      6'h23;

`define SM_DISABLE_3V3                  6'h3E;
`define SM_DISABLE_5V                   6'h38;
`define SM_DISABLE_MAIN_EFUSE           6'h25;
`define SM_DISABLE_TELEM                6'h37;
`define SM_DISABLE_PS_ON                6'h29;
`define SM_AUX_FAIL_RECOVERY            6'h2C;
`define SM_HALT_POWER_CYCLE             6'h2A;//**

`define SM_ENABLE_S5_DEVICES            6'h0C;
`define SM_DISABLE_S5_DEVICES           6'h2F;


// Unused encoding
`ifdef UNUSED_STATE
    `define UNUSED_01              6'h01;
    `define UNUSED_02              6'h02;
    `define UNUSED_04              6'h04;
    `define UNUSED_0A              6'h0A;
//  `define UNUSED_0F              6'h0F;
    `define UNUSED_14              6'h14;
//  `define UNUSED_17              6'h17;
//  `define UNUSED_18              6'h18;
    `define UNUSED_1D              6'h1D;
    `define UNUSED_1E              6'h1E;
//YHY  `define UNUSED_22             6'h22;
//YHY  `define UNUSED_24             6'h24;
//YHY  `define UNUSED_26             6'h26;
//  `define UNUSED_30                6'h30;
//  `define UNUSED_33                6'h33;
    `define UNUSED_35              6'h35;
    `define UNUSED_36              6'h36;
    `define UNUSED_39              6'h39;
    `define UNUSED_3A              6'h3A;
    `define UNUSED_3C              6'h3C;
    `define UNUSED_3D              6'h3D;
    `define UNUSED_3F              6'h3F;
  
    `define SM_MEZZ_SHORT_DETECT   6'h0D;
    `define SM_MISS_TURNON         6'h12;
    `define SM_SYSTEM_LOCKOUT      6'h20;
`endif



/*
localparam [5:0] SM_RESET_STATE         = 6'h00;
localparam [5:0] SM_IDLE                = 6'h00;//IMPORTANT

localparam [5:0] SM_EN_P3V3_VCC         = 6'h03;
localparam [5:0] SM_INIT                = 6'h03;//IMPORTANT

// localparam [5:0] SM_EN_PCH_DSW_PWROK    = 6'h09;
// localparam [5:0] SM_EN_PCH_P1V8         = 6'h07;
// localparam [5:0] SM_EN_PCH_PVNN         = 6'h08;
// localparam [5:0] SM_EN_PCH_P1V05        = 6'h1A;
// localparam [5:0] SM_PCH_RSMRST_RELEASE  = 6'h1B;
localparam [5:0] SM_OFF_STANDBY         = 6'h05;//**
localparam [5:0] SM_PS_ON               = 6'h0E;
localparam [5:0] SM_EN_5V_STBY               = 6'h0F;

localparam [5:0] SM_EN_TELEM            = 6'h1C;
localparam [5:0] SM_EN_MAIN_EFUSE       = 6'h06;
localparam [5:0] SM_EN_5V               = 6'h0B;
localparam [5:0] SM_EN_3V3              = 6'h19;    

localparam [5:0] SM_EN_P1V8             = 6'h21;   //YHY 
localparam [5:0] SM_EN_P2V5_VPP         = 6'h22;
localparam [5:0] SM_EN_VP               = 6'h23;
localparam [5:0] SM_EN_P0V8             = 6'h24;
localparam [5:0] SM_EN_VDD              = 6'h26; 

localparam [5:0] SM_CPU_RESET           = 6'h28; 
localparam [5:0] PEX_RESET              = 6'h30; 


//YHY localparam [5:0] SM_EN_P0V6_VTT         = 6'h15;
  localparam [5:0] SM_EN_VCCIO            = 6'h1F;
//YHY  
//YHY  localparam [5:0] SM_EN_VCC1V8           = 6'h17;   //pwr
//YHY  localparam [5:0] SM_EN_VCCANA           = 6'h18;   //pwr
//YHY  
//YHY  localparam [5:0] SM_EN_VCCIN            = 6'h16;
  localparam [5:0] SM_EN_VCCSA            = 6'h27;
//YHY  localparam [5:0] SM_EN_1V0              = 6'h28;
  localparam [5:0] SM_EN_VMCP             = 6'h2B;
localparam [5:0] SM_WAIT_POWEROK        = 6'h13;
localparam [5:0] SM_STEADY_PWROK        = 6'h11;//**

localparam [5:0] SM_CRITICAL_FAIL       = 6'h10;



localparam [5:0] SM_DISABLE_VDD        = 6'h2D;
localparam [5:0] SM_DISABLE_P0V8         = 6'h2E;
localparam [5:0] SM_DISABLE_VP       = 6'h3B;
localparam [5:0] SM_DISABLE_P2V5_VPP       = 6'h31;
localparam [5:0] SM_DISABLE_P1V8       = 6'h33;


  localparam [5:0] SM_DISABLE_VMCP        = 6'h2D;
//yhy localparam [5:0] SM_DISABLE_1V0         = 6'h2E;
  localparam [5:0] SM_DISABLE_VCCSA       = 6'h3B;
//YHY  localparam [5:0] SM_DISABLE_VCCIN       = 6'h31;
//YHY  
//YHY  localparam [5:0] SM_DISABLE_VCCANA      = 6'h30;   //pwr
//YHY  localparam [5:0] SM_DISABLE_VCC1V8      = 6'h33;   //pwr
//YHY  
  localparam [5:0] SM_DISABLE_VCCIO       = 6'h34;
//YHY  localparam [5:0] SM_DISABLE_P0V6_VTT    = 6'h32;
//YHY  localparam [5:0] SM_DISABLE_P2V5_VPP    = 6'h23;

localparam [5:0] SM_DISABLE_3V3         = 6'h3E;
localparam [5:0] SM_DISABLE_5V          = 6'h38;
localparam [5:0] SM_DISABLE_MAIN_EFUSE  = 6'h25;
localparam [5:0] SM_DISABLE_TELEM       = 6'h37;
localparam [5:0] SM_DISABLE_PS_ON       = 6'h29;
localparam [5:0] SM_AUX_FAIL_RECOVERY   = 6'h2C;
localparam [5:0] SM_HALT_POWER_CYCLE    = 6'h2A;//**

localparam [5:0] SM_ENABLE_S5_DEVICES   = 6'h0C;
localparam [5:0] SM_DISABLE_S5_DEVICES  = 6'h2F;


// Unused encoding
`ifdef UNUSED_STATE
  localparam [5:0] UNUSED_01              = 6'h01;
  localparam [5:0] UNUSED_02              = 6'h02;
  localparam [5:0] UNUSED_04              = 6'h04;
  localparam [5:0] UNUSED_0A              = 6'h0A;
//  localparam [5:0] UNUSED_0F              = 6'h0F;
  localparam [5:0] UNUSED_14              = 6'h14;
//  localparam [5:0] UNUSED_17              = 6'h17;
//  localparam [5:0] UNUSED_18              = 6'h18;
  localparam [5:0] UNUSED_1D              = 6'h1D;
  localparam [5:0] UNUSED_1E              = 6'h1E;
//YHY  localparam [5:0] UNUSED_22              = 6'h22;
//YHY  localparam [5:0] UNUSED_24              = 6'h24;
//YHY  localparam [5:0] UNUSED_26              = 6'h26;
//  localparam [5:0] UNUSED_30              = 6'h30;
//  localparam [5:0] UNUSED_33              = 6'h33;
  localparam [5:0] UNUSED_35              = 6'h35;
  localparam [5:0] UNUSED_36              = 6'h36;
  localparam [5:0] UNUSED_39              = 6'h39;
  localparam [5:0] UNUSED_3A              = 6'h3A;
  localparam [5:0] UNUSED_3C              = 6'h3C;
  localparam [5:0] UNUSED_3D              = 6'h3D;
  localparam [5:0] UNUSED_3F              = 6'h3F;
  
  localparam [5:0] SM_MEZZ_SHORT_DETECT   = 6'h0D;
  localparam [5:0] SM_MISS_TURNON         = 6'h12;
  localparam [5:0] SM_SYSTEM_LOCKOUT      = 6'h20;
`endif
*/

