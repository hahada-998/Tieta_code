/* =================================================================================================
模块功能：电源上下电时序控制、状态监控
1. 上电时序如下: GR1->GR2->GR3->GR4->PCIE_RESET->CPU_POR_N->PWROK, 各组电源之间上电延时2ms
2. 下电时序如下: PWROK->CPU_POR_N->PCIE_RESET->GR4->GR3->GR2->GR1, 各组电源之间下电延时2ms
3. 各组电源上电后, 需等待PGood信号有效后, 再进入下一组电源上电, 否则进入错误处理状态
4. 各组电源下电时, 直接关闭对应电源EN信号, 不等待PGood信号失效
5. 各组电源上电、下电均有看门狗计时器, 超时则进入错误处理状态
6. 错误处理状态: 依次关闭各组电源, 直至全部关闭后, 若无任何电源故障信号, 则重新开始上电序列
7. 监控到电源故障, 输出Fault信号, 组寄存器写入日志
===================================================================================================*/
`include "pwrseq_define.v"
module pwrseq_slave #(
    parameter SHARED_P5V_STBY_HPMOS       = 1'b0,
    parameter S5DEV_STUCKON_FAULT_CHK     = 1'b0,
    parameter BOUND_SYS_PWROK             = 1'b1,
    parameter NUM_CPU                     = 2,
    parameter NUM_OPT_AUX                 = 0,
    parameter NUM_S5DEV                   = 0,
    parameter NUM_SAS                     = 0,
    parameter NUM_HD_BP                   = 0,
    parameter NUM_M2_BP                   = 0,
    parameter NUM_RISER                   = 0,

    parameter FAULT_VEC_SIZE              = 40,
    parameter [FAULT_VEC_SIZE-1:0] RECOV_FAULT_MASK     = 40'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111,
    parameter [FAULT_VEC_SIZE-1:0] LIM_RECOV_FAULT_MASK = 40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000,
    parameter [FAULT_VEC_SIZE-1:0] NON_RECOV_FAULT_MASK = 40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000) (

    input                                       clk                             ,                       
    input                                       reset                           ,                       
    input                                       t1us                            ,                       
    input                                       t512us                          ,                       
    input                                       t1ms                            ,                       
    input                                       t2ms                            ,                       
    input                                       t64ms                           ,                       
    input                                       t1s                             ,                       

    input                                       keep_alive_on_fault             ,   
 
    // PGOOD 输入信号
    // stby电不受状态机控制
    input                                       p3v3_stby_bp_pg                 ,
    input                                       p3v3_stby_pg                    ,
    // 2. `SM_EN_5V_STBY 状态上电使能
    input                                       p5v_stby_pgd		                ,
    // 4. SM_EN_MAIN_EFUSE 状态上电使能
    input                                       dimm_efuse_pg		                , // 不使用, 写死1
    input                                       fan_efuse_pg		                , // 不使用, 写死1
    input                                       pgd_main_efuse                  , // 不使用, 写死1
    input                                       pgd_p12v                        ,
    input                                       pgd_p12v_stby_droop             ,
    input                                       reat_bp_efuse_pg                ,
    input                                       front_bp_efuse_pg               , // 不使用, 写死1
    input                                       p12v_cpu1_vin_pg                ,
    input                                       p12v_cpu0_vin_pg                ,
    // 5. SM_EN_5V 状态上电使能
    input                                       p5v_pgd                         ,
    // 6. SM_EN_3V3 状态上电使能
    input                                       p3v3_pgd                        , // 不使用, 写死1
    // 7. SM_EN_1V1 状态上电使能
    input                                       p1v1_pgd                        ,
    // 主电源使能信号
    // 1. SM_EN_VDD 状态上电使能
    input                                       cpu1_vdd_core_pg	              ,
    input                                       cpu0_vdd_core_pg	              ,
    // 2. SM_EN_P1V8 状态上电使能
    input                                       cpu1_p1v8_pg		                ,
    input                                       cpu0_p1v8_pg		                ,
    // 3. SM_EN_P2V5_VPP 状态上电使能
    input                                       cpu1_pll_p1v8_pg	              ,
    input                                       cpu0_pll_p1v8_pg	              ,
    input                                       cpu1_vddq_pg		                ,
    input                                       cpu0_vddq_pg		                ,
    input                                       cpu1_ddr_vdd_pg	                ,
    input                                       cpu0_ddr_vdd_pg                 ,
    // 4. SM_EN_P0V8 状态上电使能
    input                                       cpu0_pcie_p1v8_pg	              ,
    input                                       cpu1_pcie_p1v8_pg	              ,
    input                                       cpu0_pcie_p0v9_pg	              ,
    input                                       cpu1_pcie_p0v9_pg	              ,
    input                                       cpu0_d0_vp_0v9_pg               ,
    input                                       cpu0_d1_vp_0v9_pg               ,
    input                                       cpu0_d0_vph_1v8_pg              ,
    input                                       cpu0_d1_vph_1v8_pg              ,
    input                                       cpu1_d0_vp_0v9_pg               ,
    input                                       cpu1_d1_vp_0v9_pg               ,
    input                                       cpu1_d0_vph_1v8_pg              ,
    input                                       cpu1_d1_vph_1v8_pg              ,

    // 上电使能信号
    // 1. `SM_OFF_STANDBY/`SM_PS_ON 状态上电使能
    output reg                                  ocp_aux_en		                  ,		                
    output reg                                  cpu_bios_en                     ,                        
    // 2. `SM_EN_5V_STBY 状态上电使能
    output                                      p5v_stby_en_r                   ,             
    // 3. `SM_EN_TELEM 状态上电使能
    output                                      pvcc_hpmos_cpu_en_r             ,             
    // 4. SM_EN_MAIN_EFUSE 状态上电使能
    output                                      power_supply_on                 ,                    
    output reg                                  ocp_main_en				              ,           
    output                                      pal_main_efuse_en               ,                    
    output                                      p12v_bp_front_en                ,                    
    output                                      p12v_bp_rear_en                 ,                    
    // 5. SM_EN_5V 状态上电使能
    output                                      p5v_en_r                        ,                          
    // 6. SM_EN_3V3 状态上电使能
    output                                      p3v3_en_r                       ,      
    // 7. SM_EN_1V1 状态上电使能
    output                                      p1v1_en_r                       ,           
    // 主电源使能信号
    // 1. SM_EN_VDD 状态上电使能
    output                                      cpu0_vdd_core_en_r              ,                
    output                                      cpu1_vdd_core_en_r              ,                
    // 2. SM_EN_P1V8 状态上电使能
    output                                      cpu0_p1v8_en_r                  ,                 
    output                                      cpu1_p1v8_en_r                  ,                 
    // 3. SM_EN_P2V5_VPP 状态上电使能
    output                                      cpu0_vddq_en_r                  ,                 
    output                                      cpu1_vddq_en_r                  ,                 
    output                                      cpu0_ddr_vdd_en_r               ,                 
    output                                      cpu1_ddr_vdd_en_r               ,                 
    output                                      cpu0_pll_p1v8_en_r              ,                 
    output                                      cpu1_pll_p1v8_en_r              ,                 
    // 4. SM_EN_P0V8 状态上电使能
    output                                      cpu0_d0_vp_p0v9_en_r            ,
    output                                      cpu0_d1_vp_p0v9_en_r            ,
    output                                      cpu0_d0_vph_p1v8_en_r           ,
    output                                      cpu0_d1_vph_p1v8_en_r           ,
    output                                      cpu1_d0_vp_p0v9_en_r            ,
    output                                      cpu1_d1_vp_p0v9_en_r            ,
    output                                      cpu1_d0_vph_p1v8_en_r           ,
    output                                      cpu1_d1_vph_p1v8_en_r           ,
    
    // 复位信号输出
    input                                       cpu_peu_prest_n_r               ,               
    output                                      cpu_por_n                       ,                    
    output  reg                                 usb_ponrst_r_n                  ,                    
    output                                      pex_reset_r_n                   ,                    
    
    // 故障检测信号
    output                                      p5v_stby_fault_det		           ,     
    output                                      p3v3_stby_bp_fault_det           ,      
    output                                      main_efuse_fault_det             ,      
    output                                      p3v3_stby_fault_det              ,      
    
    output                                      p12v_front_bp_efuse_fault_det   ,       
    output                                      p12v_reat_bp_efuse_fault_det	  ,      
    output                                      p12v_fan_efuse_fault_det		    ,    
    output                                      p12v_dimm_efuse_fault_det       , 
    output                                      p12v_cpu1_vin_fault_det         ,
    output                                      p12v_cpu0_vin_fault_det         ,  
    output                                      p12v_fault_det                  ,       
    output                                      p12v_stby_droop_fault_det       ,    

    output                                      p5v_fault_det		                ,    
    output                                      p3v3_fault_det                  ,
    output                                      vcc_1v1_fault_det               ,

    output                                      cpu0_vdd_core_fault_det	        ,    
    output                                      cpu1_vdd_core_fault_det	        , 

    output                                      cpu0_p1v8_fault_det		          ,  
    output                                      cpu1_p1v8_fault_det		          ,  

    output                                      cpu0_vddq_fault_det		          ,  
    output                                      cpu1_vddq_fault_det		          ,  
    output                                      cpu0_ddr_vdd_fault_det	        ,        
    output                                      cpu1_ddr_vdd_fault_det	        ,        
    output                                      cpu0_pll_p1v8_fault_det	        ,    
    output                                      cpu1_pll_p1v8_fault_det	        ,    
          
    output                                      cpu1_pcie_p1v8_fault_det        ,       
    output                                      cpu0_pcie_p1v8_fault_det        ,       
    output                                      cpu1_pcie_p0v9_fault_det        ,       
    output                                      cpu0_pcie_p0v9_fault_det        ,   
        
    output                                      cpu0_d0_vp_p0v9_fault_det        ,       
    output                                      cpu0_d1_vp_p0v9_fault_det        ,       
    output                                      cpu0_d0_vph_p1v8_fault_det       ,       
    output                                      cpu0_d1_vph_p1v8_fault_det       ,       
    output                                      cpu1_d0_vp_p0v9_fault_det        ,       
    output                                      cpu1_d1_vp_p0v9_fault_det        ,       
    output                                      cpu1_d0_vph_p1v8_fault_det       ,       
    output                                      cpu1_d1_vph_p1v8_fault_det       ,     

    output reg         [5:0]                    pwrseq_sm_fault_det			        ,  
    output             [NUM_CPU-1:0]            cpu_thermtrip_fault_det         ,       
    
    // CPU 热保护输入及故障输出
    input  [NUM_CPU-1:0]                        i_cpu_thermtrip                 , 
    output [NUM_CPU-1:0]                        o_cpu_thermtrip_fault           ,

    output                                      pal_efuse_pcycle                , 

    // HDD backplane
    input  [(NUM_HD_BP ? NUM_HD_BP:1)-1:0]      hd_bp_prsnt_n                   ,          
    input  [(NUM_HD_BP ? NUM_HD_BP:1)-1:0]      hd_bp_pgd                       ,          
    output [(NUM_HD_BP ? NUM_HD_BP:1)-1:0]      hd_bp_fault_det                 ,           
    // Riser card
    input  [(NUM_RISER ? NUM_RISER:1)-1:0]      riser_prsnt_n                   ,          
    input  [(NUM_RISER ? NUM_RISER:1)-1:0]      riser_pgd                       ,          
    output [(NUM_RISER ? NUM_RISER:1)-1:0]      riser_fault_det                 ,          
    output [(NUM_RISER ? NUM_RISER:1)-1:0]      pal_riser_en                    ,          

    output [5:0]                                power_seq_sm                    , 
    output reg                                  reached_sm_wait_powerok         , 

    output reg                                  pgd_so_far                      ,   
    output reg                                  any_pwr_fault_det               , 
    output                                      any_aux_vrm_fault               , 
    output reg                                  any_recov_fault                 , 
    output reg                                  any_lim_recov_fault             , 
    output reg                                  any_non_recov_fault             , 
    output                                      dc_on_wait_complete             , 
    output                                      rt_critical_fail_store          , 
    input                                       fault_clear                     ,         

    input                                       aux_pcycle                   
);

wire    st_reset_state                         ;
wire    st_off_standby                         ;
wire    st_steady_pwrok                        ;
wire    st_halt_power_cycle                    ;
wire    st_aux_fail_recovery                   ;
wire    st_critical_fail                       ;
wire    st_en_5v                               ;
wire    st_disable_main_efuse                  ;
wire    p12v_main_fault                        ;

// Aux rails
wire    opt_aux_fault                          ;

wire    any_pex_fault_det                      ;
// Riser
wire    reg_riser_chk_en                       ;
wire    riser_pgd_so_far                       ;
wire    riser_mod_fault                        ;


reg     reg_p5v_stby_en_r		                   ;

reg     reg_pvcc_hpmos_cpu_en_r		             ;

reg     reg_power_supply_on	                   ;
reg     reg_p12v_en                            ;

// main e-fuse
reg     reg_main_efuse_en                      ;

reg     reg_p5v_en_r		                       ;

reg     reg_p3v3_en_r		                       ;

reg     reg_p1v1_en_r		                       ;

reg     reg_cpu0_vdd_core_en_r		             ;
reg     reg_cpu1_vdd_core_en_r		             ;

reg     reg_cpu0_p1v8_en_r			               ;
reg     reg_cpu1_p1v8_en_r                     ; 

reg     reg_cpu0_pll_p1v8_en_r		             ;
reg     reg_cpu1_pll_p1v8_en_r		             ;
reg     reg_cpu0_ddr_vdd_en_r		               ;  
reg     reg_cpu1_ddr_vdd_en_r		               ;
reg     reg_cpu0_vddq_en_r	                   ;
reg     reg_cpu1_vddq_en_r	                   ;

reg     reg_cpu0_pcie_p0v9_en_r	               ;
reg     reg_cpu1_pcie_p0v9_en_r		             ;
reg     reg_cpu0_pcie_p1v8_en_r		             ;
reg     reg_cpu1_pcie_p1v8_en_r                ;


reg     reg_cpu0_d0_vp_p0v9_en_r               ;
reg     reg_cpu0_d1_vp_p0v9_en_r               ;
reg     reg_cpu0_d0_vph_p1v8_en_r              ;
reg     reg_cpu0_d1_vph_p1v8_en_r              ;
reg     reg_cpu1_d0_vp_p0v9_en_r               ;
reg     reg_cpu1_d1_vp_p0v9_en_r               ;
reg     reg_cpu1_d0_vph_p1v8_en_r              ;
reg     reg_cpu1_d1_vph_p1v8_en_r              ;

reg     reg_pex_reset_r_n                      ;
reg     reg_cpu_por_n	                         ;


assign p5v_stby_en_r	       =  reg_p5v_stby_en_r & ( ~p5v_stby_fault_det | keep_alive_on_fault );

assign pvcc_hpmos_cpu_en_r   =  reg_pvcc_hpmos_cpu_en_r ;

assign power_supply_on	     =  reg_power_supply_on ;  
assign p12v_bp_front_en      =  reg_p12v_en & ( ~p12v_front_bp_efuse_fault_det  | keep_alive_on_fault);
assign p12v_bp_rear_en       =  reg_p12v_en & ( ~p12v_reat_bp_efuse_fault_det   | keep_alive_on_fault);

assign p5v_en_r            	 =  reg_p5v_en_r            & ( ~p5v_fault_det            | keep_alive_on_fault );

assign p3v3_en_r             =  reg_p3v3_en_r           & ( ~p3v3_fault_det           | keep_alive_on_fault );		                  

assign p1v1_en_r             =  reg_p1v1_en_r           & ( ~vcc_1v1_fault_det        | keep_alive_on_fault );

assign cpu0_vdd_core_en_r    =  reg_cpu0_vdd_core_en_r  & ( ~cpu0_vdd_core_fault_det  | keep_alive_on_fault );
assign cpu1_vdd_core_en_r    =  reg_cpu1_vdd_core_en_r  & ( ~cpu1_vdd_core_fault_det  | keep_alive_on_fault );

assign cpu0_p1v8_en_r	       =  reg_cpu0_p1v8_en_r      & ( ~cpu0_p1v8_fault_det      | keep_alive_on_fault );
assign cpu1_p1v8_en_r	       =  reg_cpu1_p1v8_en_r      & ( ~cpu1_p1v8_fault_det      | keep_alive_on_fault );

assign cpu0_pll_p1v8_en_r	   =  reg_cpu0_pll_p1v8_en_r  & ( ~cpu0_pll_p1v8_fault_det  | keep_alive_on_fault );
assign cpu1_pll_p1v8_en_r	   =  reg_cpu1_pll_p1v8_en_r  & ( ~cpu1_pll_p1v8_fault_det  | keep_alive_on_fault );
assign cpu0_ddr_vdd_en_r	   =  reg_cpu0_ddr_vdd_en_r   & ( ~cpu0_ddr_vdd_fault_det   | keep_alive_on_fault );
assign cpu1_ddr_vdd_en_r	   =  reg_cpu1_ddr_vdd_en_r   & ( ~cpu1_ddr_vdd_fault_det   | keep_alive_on_fault );
assign cpu0_vddq_en_r	       =  reg_cpu0_vddq_en_r      & ( ~cpu0_vddq_fault_det      | keep_alive_on_fault );
assign cpu1_vddq_en_r	       =  reg_cpu1_vddq_en_r      & ( ~cpu1_vddq_fault_det      | keep_alive_on_fault );

assign cpu0_pcie_p0v9_en_r	 =  reg_cpu0_pcie_p0v9_en_r   & ( ~cpu0_pcie_p0v9_fault_det | keep_alive_on_fault );
assign cpu1_pcie_p0v9_en_r	 =  reg_cpu1_pcie_p0v9_en_r   & ( ~cpu1_pcie_p0v9_fault_det | keep_alive_on_fault );
assign cpu0_pcie_p1v8_en_r	 =  reg_cpu0_pcie_p1v8_en_r   & ( ~cpu0_pcie_p1v8_fault_det | keep_alive_on_fault );
assign cpu1_pcie_p1v8_en_r	 =  reg_cpu1_pcie_p1v8_en_r   & ( ~cpu1_pcie_p1v8_fault_det | keep_alive_on_fault );
assign cpu0_d0_vp_p0v9_en_r  =  reg_cpu0_d0_vp_p0v9_en_r  & (~cpu0_d0_vp_p0v9_fault_det  | keep_alive_on_fault);
assign cpu0_d1_vp_p0v9_en_r  =  reg_cpu0_d1_vp_p0v9_en_r  & (~cpu0_d1_vp_p0v9_fault_det  | keep_alive_on_fault);
assign cpu0_d0_vph_p1v8_en_r =  reg_cpu0_d0_vph_p1v8_en_r & (~cpu0_d0_vph_p1v8_fault_det| keep_alive_on_fault);
assign cpu0_d1_vph_p1v8_en_r =  reg_cpu0_d1_vph_p1v8_en_r & (~cpu0_d1_vph_p1v8_fault_det| keep_alive_on_fault);
assign cpu1_d0_vp_p0v9_en_r  =  reg_cpu1_d0_vp_p0v9_en_r  & (~cpu1_d0_vp_p0v9_fault_det | keep_alive_on_fault);
assign cpu1_d1_vp_p0v9_en_r  =  reg_cpu1_d1_vp_p0v9_en_r  & (~cpu1_d1_vp_p0v9_fault_det | keep_alive_on_fault);
assign cpu1_d0_vph_p1v8_en_r =  reg_cpu1_d0_vph_p1v8_en_r & (~cpu1_d0_vph_p1v8_fault_det| keep_alive_on_fault);
assign cpu1_d1_vph_p1v8_en_r =  reg_cpu1_d1_vph_p1v8_en_r & (~cpu1_d1_vph_p1v8_fault_det| keep_alive_on_fault);

assign pex_reset_r_n	       =  reg_pex_reset_r_n       ;
assign cpu_por_n	           =  reg_cpu_por_n           ;


//------------------------------------------------------------------------------
// Reset and SM states
// - The st_* stuff are just convenience variable that can be used throughout.
//------------------------------------------------------------------------------
assign st_reset_state       = (power_seq_sm == `SM_RESET_STATE       );
assign st_off_standby       = (power_seq_sm == `SM_OFF_STANDBY       );
assign st_steady_pwrok      = (power_seq_sm == `SM_STEADY_PWROK      );
assign st_critical_fail     = (power_seq_sm == `SM_CRITICAL_FAIL     );
assign st_halt_power_cycle  = (power_seq_sm == `SM_HALT_POWER_CYCLE  );
assign st_aux_fail_recovery = (power_seq_sm == `SM_AUX_FAIL_RECOVERY );
assign st_en_5v             = (power_seq_sm == `SM_EN_5V             );
assign st_disable_main_efuse= (power_seq_sm == `SM_DISABLE_MAIN_EFUSE);
// Shortcut to select whether the next state is VTT or VPP
//YHY assign vpp_or_vtt_next = (no_vppen) ? st_en_p0v6_vtt : st_en_p2v5_vpp;

//------------------------------------------------------------------------------
// Slave VRM enable/disable registers
// - These registers do not control the VRMs directly. These registers indicate
//   that a VRM has an opportunity to turn on. Additional combinational terms
//   are required to protect the system from VRM faults and ensures that proper
//   voltage sequencing is maintained.
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ocp_aux_en                 <= 1'b0;
        cpu_bios_en                <= 1'b0;

        reg_p5v_stby_en_r          <= 1'b0;  

        reg_pvcc_hpmos_cpu_en_r    <= 1'b0;

        reg_power_supply_on        <= 1'b0;
        reg_main_efuse_en          <= 1'b0;
        ocp_main_en                <= 1'b0;
        reg_p12v_en                <= 1'b0;

        reg_p5v_en_r               <= 1'b0;   

        reg_p3v3_en_r              <= 1'b0;

        reg_p1v1_en_r              <= 1'b0;

        reg_cpu0_vdd_core_en_r     <= 1'b0;
        reg_cpu1_vdd_core_en_r     <= 1'b0;

        reg_cpu0_p1v8_en_r         <= 1'b0;
        reg_cpu1_p1v8_en_r         <= 1'b0;

        reg_cpu0_pll_p1v8_en_r     <= 1'b0;
        reg_cpu1_pll_p1v8_en_r     <= 1'b0;
        reg_cpu0_ddr_vdd_en_r      <= 1'b0;
        reg_cpu1_ddr_vdd_en_r      <= 1'b0;
        reg_cpu0_vddq_en_r         <= 1'b0;
        reg_cpu1_vddq_en_r         <= 1'b0;


        reg_cpu0_pcie_p0v9_en_r    <= 1'b0;
        reg_cpu1_pcie_p0v9_en_r    <= 1'b0;
        reg_cpu0_pcie_p1v8_en_r    <= 1'b0;
        reg_cpu1_pcie_p1v8_en_r    <= 1'b0;
        reg_cpu0_d0_vp_p0v9_en_r   <= 1'b0;
        reg_cpu0_d1_vp_p0v9_en_r   <= 1'b0;
        reg_cpu0_d0_vph_p1v8_en_r  <= 1'b0;
        reg_cpu0_d1_vph_p1v8_en_r  <= 1'b0;
        reg_cpu1_d0_vp_p0v9_en_r   <= 1'b0;
        reg_cpu1_d1_vp_p0v9_en_r   <= 1'b0;
        reg_cpu1_d0_vph_p1v8_en_r  <= 1'b0;
        reg_cpu1_d1_vph_p1v8_en_r  <= 1'b0;

        
	      reg_cpu_por_n              <= 1'b0;      
        usb_ponrst_r_n             <= 1'b0;
	      reg_pex_reset_r_n          <= 1'b0;
	      
        reached_sm_wait_powerok    <= 1'b0;   
    end
    else if (t1us) begin
        case (power_seq_sm)
            `SM_RESET_STATE : begin
                ocp_aux_en                 <= 1'b0;
                cpu_bios_en                <= 1'b0;

                reg_p5v_stby_en_r          <= 1'b0; 

                reg_pvcc_hpmos_cpu_en_r    <= 1'b0;

                reg_power_supply_on        <= 1'b0;
                reg_main_efuse_en          <= 1'b0;
                ocp_main_en                <= 1'b0;
                reg_p12v_en                <= 1'b0;

                reg_p5v_en_r               <= 1'b0; 

                reg_p3v3_en_r              <= 1'b0;

                reg_p1v1_en_r              <= 1'b0;

                reg_cpu0_vdd_core_en_r     <= 1'b0;
                reg_cpu1_vdd_core_en_r     <= 1'b0;

                reg_cpu0_p1v8_en_r         <= 1'b0;
                reg_cpu1_p1v8_en_r         <= 1'b0;
 
                reg_cpu0_pll_p1v8_en_r     <= 1'b0;
                reg_cpu1_pll_p1v8_en_r     <= 1'b0;
                reg_cpu0_ddr_vdd_en_r      <= 1'b0;
                reg_cpu1_ddr_vdd_en_r      <= 1'b0;
                reg_cpu0_vddq_en_r         <= 1'b0;
                reg_cpu1_vddq_en_r         <= 1'b0;

                reg_cpu0_pcie_p0v9_en_r    <= 1'b0;
                reg_cpu1_pcie_p0v9_en_r    <= 1'b0;
                reg_cpu0_pcie_p1v8_en_r    <= 1'b0;
                reg_cpu1_pcie_p1v8_en_r    <= 1'b0;
                reg_cpu0_d0_vp_p0v9_en_r   <= 1'b0;
                reg_cpu0_d1_vp_p0v9_en_r   <= 1'b0;
                reg_cpu0_d0_vph_p1v8_en_r  <= 1'b0;
                reg_cpu0_d1_vph_p1v8_en_r  <= 1'b0;
                reg_cpu1_d0_vp_p0v9_en_r   <= 1'b0;
                reg_cpu1_d1_vp_p0v9_en_r   <= 1'b0;
                reg_cpu1_d0_vph_p1v8_en_r  <= 1'b0;
                reg_cpu1_d1_vph_p1v8_en_r  <= 1'b0;

                reg_pex_reset_r_n          <= 1'b0;
	              usb_ponrst_r_n             <= 1'b0;

                reg_cpu_por_n              <= 1'b0;
	              
                reached_sm_wait_powerok    <= 1'b0; 
            end

            `SM_OFF_STANDBY : begin
	              ocp_aux_en                 <= 1'b1;  
            end

            `SM_PS_ON : begin
                cpu_bios_en                <= 1'b1;
            end

            `SM_EN_5V_STBY: begin
                reg_p5v_stby_en_r          <= 1'b1;
            end

            `SM_EN_TELEM : begin
                reg_pvcc_hpmos_cpu_en_r    <= 1'b1;
            end

            `SM_EN_MAIN_EFUSE : begin
                reg_power_supply_on        <= 1'b1;
		            ocp_main_en                <= 1'b1;
		            reg_main_efuse_en          <= 1'b1;
		            reg_p12v_en                <= 1'b1;
            end

            `SM_EN_5V : begin
                reg_p5v_en_r <= 1'b1;
            end

            `SM_EN_3V3 : begin
                reg_p3v3_en_r              <= 1'b1;
	          end

            `SM_EN_1V1 : begin
                reg_p1v1_en_r              <= 1'b1;
	          end

            `SM_EN_CPU_CORE: begin
                reg_cpu0_vdd_core_en_r     <= 1'b1;
                reg_cpu1_vdd_core_en_r     <= 1'b1;
            end 

            `SM_EN_CPU_P1V8 : begin
                reg_cpu0_p1v8_en_r         <= 1'b1;
                reg_cpu1_p1v8_en_r         <= 1'b1;
            end

            `SM_EN_CPU_DDR : begin
                reg_cpu0_ddr_vdd_en_r      <= 1'b1;
                reg_cpu1_ddr_vdd_en_r      <= 1'b1;
                reg_cpu0_pll_p1v8_en_r     <= 1'b1;
                reg_cpu1_pll_p1v8_en_r     <= 1'b1;
		            reg_cpu0_vddq_en_r         <= 1'b1;
                reg_cpu1_vddq_en_r         <= 1'b1;
            end

            `SM_EN_CPU_VP : begin          
                reg_cpu0_pcie_p0v9_en_r    <= 1'b1; // 实际不使用
                reg_cpu1_pcie_p0v9_en_r    <= 1'b1; // 实际不使用
                reg_cpu0_pcie_p1v8_en_r    <= 1'b1; // 实际不使用
                reg_cpu1_pcie_p1v8_en_r    <= 1'b1; // 实际不使用

                reg_cpu0_d0_vp_p0v9_en_r   <= 1'b1;
                reg_cpu0_d1_vp_p0v9_en_r   <= 1'b1;
                reg_cpu0_d0_vph_p1v8_en_r  <= 1'b1;
                reg_cpu0_d1_vph_p1v8_en_r  <= 1'b1;
                reg_cpu1_d0_vp_p0v9_en_r   <= 1'b1;
                reg_cpu1_d1_vp_p0v9_en_r   <= 1'b1;
                reg_cpu1_d0_vph_p1v8_en_r  <= 1'b1;
                reg_cpu1_d1_vph_p1v8_en_r  <= 1'b1;
            end  
         
            `PEX_RESET : begin  
                // 此信号不使用, 此状态实际是等待PUE复位释放        
                reg_pex_reset_r_n          <= 1'b1; 
            end 
     
            `SM_CPU_RESET : begin          
                reg_cpu_por_n              <= 1'b1;
		            usb_ponrst_r_n             <= 1'b1;
             end      
           
            `SM_WAIT_POWEROK : begin
                reached_sm_wait_powerok    <= 1'b1;      
            end

            `SM_CRITICAL_FAIL : begin
            	  reg_main_efuse_en          <= 1'b0;       
            end
	  
            `SM_DISABLE_CPU_VP : begin
                reg_cpu0_pcie_p0v9_en_r    <= 1'b0; // 实际不使用
                reg_cpu1_pcie_p0v9_en_r    <= 1'b0; // 实际不使用
                reg_cpu0_pcie_p1v8_en_r    <= 1'b0; // 实际不使用
                reg_cpu1_pcie_p1v8_en_r    <= 1'b0; // 实际不使用

                reg_cpu0_d0_vp_p0v9_en_r   <= 1'b0;
                reg_cpu0_d1_vp_p0v9_en_r   <= 1'b0;
                reg_cpu0_d0_vph_p1v8_en_r  <= 1'b0;
                reg_cpu0_d1_vph_p1v8_en_r  <= 1'b0;
                reg_cpu1_d0_vp_p0v9_en_r   <= 1'b0;
                reg_cpu1_d1_vp_p0v9_en_r   <= 1'b0;
                reg_cpu1_d0_vph_p1v8_en_r  <= 1'b0;
                reg_cpu1_d1_vph_p1v8_en_r  <= 1'b0;
            end  

            `SM_DISABLE_CPU_DDR : begin
                reg_cpu0_ddr_vdd_en_r      <= 1'b0;
                reg_cpu1_ddr_vdd_en_r      <= 1'b0;
                reg_cpu0_pll_p1v8_en_r     <= 1'b0;
                reg_cpu1_pll_p1v8_en_r     <= 1'b0;
		            reg_cpu0_vddq_en_r         <= 1'b0;
                reg_cpu1_vddq_en_r         <= 1'b0;
            end

            `SM_DISABLE_CPU_P1V8 : begin
                reg_cpu0_p1v8_en_r         <= 1'b0;
                reg_cpu1_p1v8_en_r         <= 1'b0;
            end

            `SM_DISABLE_CPU_CORE : begin
                reg_cpu0_vdd_core_en_r     <= 1'b0;
                reg_cpu1_vdd_core_en_r     <= 1'b0;
            end

            `SM_DISABLE_1V1 : begin
                reg_p1v1_en_r              <= 1'b0;
	          end

            `SM_DISABLE_3V3 : begin
                reg_p3v3_en_r              <= 1'b0;
	          end

            `SM_DISABLE_5V : begin
                reg_p5v_en_r               <= 1'b1;
            end

            `SM_DISABLE_MAIN_EFUSE : begin
                reg_power_supply_on        <= 1'b0;
                ocp_main_en                <= 1'b0;
                reg_main_efuse_en          <= 1'b0;
                reg_p12v_en                <= 1'b0;
            end

            `SM_DISABLE_TELEM : begin
                reg_pvcc_hpmos_cpu_en_r    <= 1'b0;
            end

            `SM_DISABLE_PS_ON : begin
                cpu_bios_en                 <= 1'b0; 
            end 
    endcase
  end
end


//------------------------------------------------------------------------------
// ok_to_reset_aux
// - Asserts when in state where AUX power can be cycled
//------------------------------------------------------------------------------
reg     ok_to_reset_aux                       ;
always @(posedge clk or posedge reset) begin
    if (reset)
        ok_to_reset_aux <= 1'b0;
    else
        ok_to_reset_aux <=  st_reset_state      |
                            st_off_standby      |
                            st_halt_power_cycle |
                            st_aux_fail_recovery;
end


//------------------------------------------------------------------------------
// VRM enable logic
// - Unless keep_alive_on_fault is set, a fault on a particular rail will disable
//   the corresponding EN signal immediately.
//------------------------------------------------------------------------------
// Main e-fuse
assign pal_main_efuse_en = reg_main_efuse_en & (~main_efuse_fault_det | keep_alive_on_fault);


//------------------------------------------------------------------------------
// Aux e-fuse control
//------------------------------------------------------------------------------
// Asserts when FPGA is alive. If not asserted within 375ms, AUX e-fuse turns off.
// For BL, qualify with pgd_aux_system (same as reset) to keep it up only if iLO
// rails are up.
assign pal_efuse_pcycle = aux_pcycle & ok_to_reset_aux;

//------------------------------------------------------------------------------
// Aux (P5V_STBY) fault detect
// - P5V_STBY can be enabled while system in standby so need to check if it
//   comes up. It takes time to ramp so we'll give it ~120ms to do it.
//------------------------------------------------------------------------------                       
    
    
//------------------------------------------------------------------------------
// P5V_STBY Fault detect 
//------------------------------------------------------------------------------
wire p5v_stby_en_r_check;

edge_delay #(.CNTR_NBITS(2)) p5v_stby_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p5v_stby_en_r),
  .delay_output  (p5v_stby_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p5v_stby_fault_detect_inst (
  .clk              (clk),
  .reset            (reset),
  .vrm_enable       (p5v_stby_en_r & p5v_stby_en_r_check),
  .vrm_pgood        (p5v_stby_pgd),
  .vrm_chklive_en   (p5v_stby_en_r_check),
  .vrm_chklive_dis  (~p5v_stby_en_r_check),
  .critical_fail    (st_critical_fail),
  .fault_clear      (fault_clear),
  .lock             (any_pwr_fault_det),
  .any_vrm_fault    (),
  .vrm_fault        (p5v_stby_fault_det)
);

//------------------------------------------------------------------------------
// P3V3_STBY Fault detect 
//------------------------------------------------------------------------------
wire   p3v3_stby_en;
wire   p3v3_stby_en_check;
assign p3v3_stby_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) p3v3_stby_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p3v3_stby_en),
  .delay_output  (p3v3_stby_en_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p3v3_stby_fault_detect_inst (
  .clk              (clk  ),							 //in
  .reset            (reset),							 //in
  .vrm_enable       (p3v3_stby_en && p3v3_stby_en_check),//in
  .vrm_pgood        (p3v3_stby_pg                      ),//in
  .vrm_chklive_en   (p3v3_stby_en_check                ),//in
  .vrm_chklive_dis  (~p3v3_stby_en_check               ),//in
  .critical_fail    (st_critical_fail                  ),//in
  .fault_clear      (fault_clear                       ),//in
  .lock             (any_pwr_fault_det                 ),//in
  .any_vrm_fault    (),								     //out
  .vrm_fault        (p3v3_stby_fault_det               ) //out
);


//------------------------------------------------------------------------------
// P3V3_STBY_BP Fault detect 
//------------------------------------------------------------------------------
wire   p3v3_stby_bp_en;
wire   p3v3_stby_bp_en_check;
assign p3v3_stby_bp_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) p3v3_stby_bp_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p3v3_stby_bp_en),
  .delay_output  (p3v3_stby_bp_en_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p3v3_stby_bp_fault_detect_inst (
  .clk              (clk  ),							 //in
  .reset            (reset),							 //in
  .vrm_enable       (p3v3_stby_bp_en && p3v3_stby_bp_en_check),//in
  .vrm_pgood        (p3v3_stby_bp_pg                         ),//in
  .vrm_chklive_en   (p3v3_stby_bp_en_check                   ),//in
  .vrm_chklive_dis  (~p3v3_stby_bp_en_check                  ),//in
  .critical_fail    (st_critical_fail                        ),//in
  .fault_clear      (fault_clear                             ),//in
  .lock             (any_pwr_fault_det                       ),//in
  .any_vrm_fault    (),								           //out
  .vrm_fault        (p3v3_stby_bp_fault_det                  ) //out
);
//------------------------------------------------------------------------------
// Main 12V fault detect
// - Efuse (all platform)
// - PSU (non-BL/BT)
// - Brownout fault (non-BL/BT)
// - If there's a brownout warning, a drop in pgd_p12v_stby_droop will cause
//   a brownout fault. No need to set p12v_stby_droop_fault_det.
//------------------------------------------------------------------------------
wire   p12v_stby_en;
wire   p12v_stby_en_check;
assign p12v_stby_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) p12v_stby_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p12v_stby_en),
  .delay_output  (p12v_stby_en_check)
);

generate begin : _P12V_FAULT_DETECT_
fault_detectB_chklive #(.NUMBER_OF_VRM(3)) p12_fault_detect_inst (
 .clk              (clk),
 .reset            (reset),
 .vrm_enable       ({pal_main_efuse_en,
                     pal_main_efuse_en,
                    (p12v_stby_en && p12v_stby_en_check)}),
 .vrm_pgood        ({pgd_main_efuse,
                     pgd_p12v,
                     pgd_p12v_stby_droop}),
 .vrm_chklive_en   ({st_en_5v,
                     st_en_5v,
                     p12v_stby_en_check}),
 .vrm_chklive_dis  ({st_disable_main_efuse,
                     st_disable_main_efuse,  
                     ~p12v_stby_en_check}),   
 .critical_fail    (st_critical_fail),
 .fault_clear      (fault_clear),
 .lock             (any_pwr_fault_det),
 .any_vrm_fault    (p12v_main_fault),
 .vrm_fault        ({main_efuse_fault_det,
                     p12v_fault_det,
                     p12v_stby_droop_fault_det})
);
end
endgenerate


//------------------------------------------------------------------------------
// P12V_EFFUSE Fault detect 
//------------------------------------------------------------------------------
wire power_supply_on_check;

edge_delay #(.CNTR_NBITS(2)) power_supply_on_check_inst (
  .clk              (clk                      ),
  .reset            (reset                    ),
  .cnt_size         (2'b10                    ),
  .cnt_step         (t64ms                    ),
  .signal_in        (power_supply_on          ),
  .delay_output     (power_supply_on_check    )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_fan_efuse_fault_detect_inst (
  .clk              (clk                      ), //in
  .reset            (reset                    ), //in
  .vrm_enable       (power_supply_on && power_supply_on_check), //in
  .vrm_pgood        (fan_efuse_pg             ), //in
  .vrm_chklive_en   (power_supply_on_check    ), //in
  .vrm_chklive_dis  (~power_supply_on_check   ), //in
  .critical_fail    (st_critical_fail         ), //in
  .fault_clear      (fault_clear              ), //in
  .lock             (any_pwr_fault_det        ), //in
  .any_vrm_fault    (                         ), //out
  .vrm_fault        (p12v_fan_efuse_fault_det )	 //out
); 
  
fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_dimm_efuse_fault_detect_inst (
  .clk              (clk                      ), //in
  .reset            (reset                    ), //in
  .vrm_enable       (power_supply_on && power_supply_on_check), //in
  .vrm_pgood        (dimm_efuse_pg            ), //in
  .vrm_chklive_en   (power_supply_on_check    ), //in
  .vrm_chklive_dis  (~power_supply_on_check   ), //in
  .critical_fail    (st_critical_fail         ), //in
  .fault_clear      (fault_clear              ), //in
  .lock             (any_pwr_fault_det        ), //in
  .any_vrm_fault    (                         ), //out
  .vrm_fault        (p12v_dimm_efuse_fault_det)	 //out
);   

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_cpu1_vin_fault_detect_inst (
  .clk              (clk                      ), //in
  .reset            (reset                    ), //in
  .vrm_enable       (power_supply_on && power_supply_on_check), //in
  .vrm_pgood        (p12v_cpu1_vin_pg         ), //in
  .vrm_chklive_en   (power_supply_on_check    ), //in
  .vrm_chklive_dis  (~power_supply_on_check   ), //in
  .critical_fail    (st_critical_fail         ), //in
  .fault_clear      (fault_clear              ), //in
  .lock             (any_pwr_fault_det        ), //in
  .any_vrm_fault    (                         ), //out
  .vrm_fault        (p12v_cpu1_vin_fault_det  )	 //out
);  

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_cpu0_vin_fault_fault_detect_inst (
  .clk              (clk                      ), //in
  .reset            (reset                    ), //in
  .vrm_enable       (power_supply_on && power_supply_on_check),	//in
  .vrm_pgood        (p12v_cpu0_vin_pg         ), //in
  .vrm_chklive_en   (power_supply_on_check    ), //in
  .vrm_chklive_dis  (~power_supply_on_check   ), //in
  .critical_fail    (st_critical_fail         ), //in
  .fault_clear      (fault_clear              ), //in
  .lock             (any_pwr_fault_det        ), //in
  .any_vrm_fault    (                         ), //out
  .vrm_fault        (p12v_cpu0_vin_fault_det  )	 //out
);  

//------------------------------------------------------------------------------
// P12V_BP_FRONT Fault detect 
//------------------------------------------------------------------------------  
wire p12v_bp_front_en_check;

edge_delay #(.CNTR_NBITS(2)) p12v_bp_front_en_check_inst (
  .clk              (clk                      ),
  .reset            (reset                    ),
  .cnt_size         (2'b10                    ),
  .cnt_step         (t64ms                    ),
  .signal_in        (p12v_bp_front_en         ),
  .delay_output     (p12v_bp_front_en_check   )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_front_bp_efuse_fault_detect_inst (
  .clk              (clk                      ),								//in
  .reset            (reset                    ),							//in
  .vrm_enable       (p12v_bp_front_en & p12v_bp_front_en_check),//in
  .vrm_pgood        (front_bp_efuse_pg                        ),//in
  .vrm_chklive_en   (p12v_bp_front_en_check                   ),//in
  .vrm_chklive_dis  (~p12v_bp_front_en_check                  ),//in
  .critical_fail    (st_critical_fail                         ),//in
  .fault_clear      (fault_clear                              ),//in
  .lock             (any_pwr_fault_det                        ),//in
  .any_vrm_fault    (),									        //out
  .vrm_fault        (p12v_front_bp_efuse_fault_det            )	//out
);   

//------------------------------------------------------------------------------
// P12V_BP_REAR Fault detect 
//------------------------------------------------------------------------------
wire p12v_bp_rear_en_check;  

edge_delay #(.CNTR_NBITS(2)) p12v_bp_rear_en_check_inst (
  .clk           (clk   ),
  .reset         (reset ),
  .cnt_size      (2'b10 ),
  .cnt_step      (t64ms ),
  .signal_in     (p12v_bp_rear_en            ),
  .delay_output  (p12v_bp_rear_en_check      )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p12v_reat_bp_efuse_fault_detect_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (p12v_bp_rear_en & p12v_bp_rear_en_check),			//in
  .vrm_pgood        (reat_bp_efuse_pg),							//in
  .vrm_chklive_en   (p12v_bp_rear_en_check),					//in
  .vrm_chklive_dis  (~p12v_bp_rear_en_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (p12v_reat_bp_efuse_fault_det)					//out
);

//------------------------------------------------------------------------------
// P5V Fault detect 
//------------------------------------------------------------------------------
wire p5v_en_r_check;

edge_delay #(.CNTR_NBITS(2)) p5v_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p5v_en_r),
  .delay_output  (p5v_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p5v_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (p5v_en_r & p5v_en_r_check),	    //in
  .vrm_pgood        (p5v_pgd),							//in
  .vrm_chklive_en   (p5v_en_r_check),					//in
  .vrm_chklive_dis  (~p5v_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (p5v_fault_det)					    //out
); 


//------------------------------------------------------------------------------
// P3V3 Fault detect 
//------------------------------------------------------------------------------
wire p3v3_en_r_check;

edge_delay #(.CNTR_NBITS(2)) p3v3_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p3v3_en_r),
  .delay_output  (p3v3_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p3v3_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (p3v3_en_r & p3v3_en_r_check),	    //in
  .vrm_pgood        (p3v3_pgd),							//in
  .vrm_chklive_en   (p3v3_en_r_check),					//in
  .vrm_chklive_dis  (~p3v3_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (p3v3_fault_det)					    //out
); 


//------------------------------------------------------------------------------
// P1V1 Fault detect 
//------------------------------------------------------------------------------
wire p1v1_en_r_check;

edge_delay #(.CNTR_NBITS(2)) p1v1_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (p1v1_en_r),
  .delay_output  (p1v1_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) p1v1_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (p1v1_en_r & p1v1_en_r_check),	    //in
  .vrm_pgood        (p1v1_pgd),							//in
  .vrm_chklive_en   (p1v1_en_r_check),					//in
  .vrm_chklive_dis  (~p1v1_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (vcc_1v1_fault_det)					    //out
); 


//------------------------------------------------------------------------------
// CPU0_VDD_CORE & CPU1_VDD_CORE Fault detect 
//------------------------------------------------------------------------------
wire cpu0_vdd_core_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_vdd_core_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_vdd_core_en_r),
  .delay_output  (cpu0_vdd_core_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_vdd_core_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_vdd_core_en_r && cpu0_vdd_core_en_r_check),	//in
  .vrm_pgood        (cpu0_vdd_core_pg),						//in
  .vrm_chklive_en   (cpu0_vdd_core_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_vdd_core_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_vdd_core_fault_det)			//out
);

wire cpu1_vdd_core_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_vdd_core_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_vdd_core_en_r),
  .delay_output  (cpu1_vdd_core_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_vdd_core_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_vdd_core_en_r && cpu1_vdd_core_en_r_check),	//in
  .vrm_pgood        (cpu1_vdd_core_pg),						//in
  .vrm_chklive_en   (cpu1_vdd_core_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_vdd_core_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_vdd_core_fault_det)			    //out
);

//------------------------------------------------------------------------------
// CPU0_P1V8 & CPU1_P1V8 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_p1v8_en_r),
  .delay_output  (cpu0_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_p1v8_en_r & cpu0_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu0_p1v8_pg),						//in
  .vrm_chklive_en   (cpu0_p1v8_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_p1v8_fault_det)			//out
);

wire cpu1_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_p1v8_en_r),
  .delay_output  (cpu1_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_p1v8_en_r && cpu1_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu1_p1v8_pg),						//in
  .vrm_chklive_en   (cpu1_p1v8_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_p1v8_fault_det)			//out
);

//------------------------------------------------------------------------------
// CPU0_VDDQ & CPU1_VDDQ Fault detect 
//------------------------------------------------------------------------------
wire cpu0_vddq_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_vddq_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_vddq_en_r),
  .delay_output  (cpu0_vddq_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_vddq_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_vddq_en_r && cpu0_vddq_en_r_check),	//in
  .vrm_pgood        (cpu0_vddq_pg),						//in
  .vrm_chklive_en   (cpu0_vddq_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_vddq_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_vddq_fault_det)			//out
);

wire cpu1_vddq_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_vddq_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_vddq_en_r),
  .delay_output  (cpu1_vddq_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_vddq_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_vddq_en_r && cpu1_vddq_en_r_check),	//in
  .vrm_pgood        (cpu1_vddq_pg),						//in
  .vrm_chklive_en   (cpu1_vddq_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_vddq_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_vddq_fault_det)			    //out
);



//------------------------------------------------------------------------------
// CPU0_DDR_VDD & CPU1_DDR_VDD Fault detect 
//------------------------------------------------------------------------------
wire cpu0_ddr_vdd_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_ddr_vdd_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_ddr_vdd_en_r),
  .delay_output  (cpu0_ddr_vdd_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_ddr_vdd_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_ddr_vdd_en_r && cpu0_ddr_vdd_en_r_check),	//in
  .vrm_pgood        (cpu0_ddr_vdd_pg),						//in
  .vrm_chklive_en   (cpu0_ddr_vdd_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_ddr_vdd_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_ddr_vdd_fault_det)			//out
);

wire cpu1_ddr_vdd_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_ddr_vdd_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_ddr_vdd_en_r),
  .delay_output  (cpu1_ddr_vdd_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_ddr_vdd_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_ddr_vdd_en_r && cpu1_ddr_vdd_en_r_check),	//in
  .vrm_pgood        (cpu1_ddr_vdd_pg),						//in
  .vrm_chklive_en   (cpu1_ddr_vdd_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_ddr_vdd_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_ddr_vdd_fault_det)			//out
);

//------------------------------------------------------------------------------
// CPU0_PLL_P1V8 & CPU1_PLL_P1V8 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_pll_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_pll_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_pll_p1v8_en_r),
  .delay_output  (cpu0_pll_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_pll_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_pll_p1v8_en_r & cpu0_pll_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu0_pll_p1v8_pg),						//in
  .vrm_chklive_en   (cpu0_pll_p1v8_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_pll_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_pll_p1v8_fault_det)			//out
);

wire cpu1_pll_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_pll_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_pll_p1v8_en_r),
  .delay_output  (cpu1_pll_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_pll_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_pll_p1v8_en_r && cpu1_pll_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu1_pll_p1v8_pg),						//in
  .vrm_chklive_en   (cpu1_pll_p1v8_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_pll_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_pll_p1v8_fault_det)			//out
);

//------------------------------------------------------------------------------
// CPU_VP_P0v9/CPU_VPH_1V8 Fault detect 
//------------------------------------------------------------------------------
wire  cpu0_d0_vp_p0v9_en_r_check  ; 
wire  cpu0_d1_vp_p0v9_en_r_check  ; 
wire  cpu0_d0_vph_p1v8_en_r_check ;
wire  cpu0_d1_vph_p1v8_en_r_check ;
wire  cpu1_d0_vp_p0v9_en_r_check  ; 
wire  cpu1_d1_vp_p0v9_en_r_check  ; 
wire  cpu1_d0_vph_p1v8_en_r_check ;
wire  cpu1_d1_vph_p1v8_en_r_check ;
// cpu0_d0_vp_p0v9_en
edge_delay #(.CNTR_NBITS(2)) cpu0_d0_vp_p0v9_en_r_inst (
  .clk              (clk                        ),
  .reset            (reset                      ),
  .cnt_size         (2'b10                      ),
  .cnt_step         (t64ms                      ),
  .signal_in        (cpu0_d0_vp_p0v9_en_r       ),
  .delay_output     (cpu0_d0_vp_p0v9_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_d0_vp_p0v9_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu0_d0_vp_p0v9_en_r & cpu0_d0_vp_p0v9_en_r_check  ), // in
  .vrm_pgood        (cpu0_d0_vp_0v9_pg                                  ), // in
  .vrm_chklive_en   (cpu0_d0_vp_p0v9_en_r_check                         ), // in
  .vrm_chklive_dis  (~cpu0_d0_vp_p0v9_en_r_check                        ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu0_d0_vp_p0v9_fault_det                           )  // out
);

// cpu0_d1_vp_p0v9_en
edge_delay #(.CNTR_NBITS(2)) cpu0_d1_vp_p0v9_en_r_inst (
  .clk              (clk                        ),
  .reset            (reset                      ),
  .cnt_size         (2'b10                      ),
  .cnt_step         (t64ms                      ),
  .signal_in        (cpu0_d1_vp_p0v9_en_r       ),
  .delay_output     (cpu0_d1_vp_p0v9_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_d1_vp_p0v9_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu0_d1_vp_p0v9_en_r & cpu0_d1_vp_p0v9_en_r_check  ), // in
  .vrm_pgood        (cpu0_d1_vp_0v9_pg                                  ), // in
  .vrm_chklive_en   (cpu0_d1_vp_p0v9_en_r_check                         ), // in
  .vrm_chklive_dis  (~cpu0_d1_vp_p0v9_en_r_check                        ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu0_d1_vp_p0v9_fault_det                         )  // out
);

// cpu0_d0_vph_p1v8_en
edge_delay #(.CNTR_NBITS(2)) cpu0_d0_vph_p1v8_en_r_inst (
  .clk              (clk                         ),
  .reset            (reset                       ),
  .cnt_size         (2'b10                       ),
  .cnt_step         (t64ms                       ),
  .signal_in        (cpu0_d0_vph_p1v8_en_r       ),
  .delay_output     (cpu0_d0_vph_p1v8_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_d0_vph_p1v8_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu0_d0_vph_p1v8_en_r & cpu0_d0_vph_p1v8_en_r_check), // in
  .vrm_pgood        (cpu0_d0_vph_1v8_pg                                 ), // in
  .vrm_chklive_en   (cpu0_d0_vph_p1v8_en_r_check                        ), // in
  .vrm_chklive_dis  (~cpu0_d0_vph_p1v8_en_r_check                       ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu0_d0_vph_p1v8_fault_det                         )  // out
);

// cpu0_d1_vph_p1v8_en
edge_delay #(.CNTR_NBITS(2)) cpu0_d1_vph_p1v8_en_r_inst (
  .clk              (clk                         ),
  .reset            (reset                       ),
  .cnt_size         (2'b10                       ),
  .cnt_step         (t64ms                       ),
  .signal_in        (cpu0_d1_vph_p1v8_en_r       ),
  .delay_output     (cpu0_d1_vph_p1v8_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_d1_vph_p1v8_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu0_d1_vph_p1v8_en_r & cpu0_d1_vph_p1v8_en_r_check), // in
  .vrm_pgood        (cpu0_d1_vph_1v8_pg                                 ), // in
  .vrm_chklive_en   (cpu0_d1_vph_p1v8_en_r_check                        ), // in
  .vrm_chklive_dis  (~cpu0_d1_vph_p1v8_en_r_check                       ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu0_d1_vph_p1v8_fault_det                         )  // out
);

// cpu1_d0_vp_p0v9_en
edge_delay #(.CNTR_NBITS(2)) cpu1_d0_vp_p0v9_en_r_inst (
  .clk              (clk                        ),
  .reset            (reset                      ),
  .cnt_size         (2'b10                      ),
  .cnt_step         (t64ms                      ),
  .signal_in        (cpu1_d0_vp_p0v9_en_r       ),
  .delay_output     (cpu1_d0_vp_p0v9_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_d0_vp_p0v9_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu1_d0_vp_p0v9_en_r & cpu1_d0_vp_p0v9_en_r_check  ), // in
  .vrm_pgood        (cpu1_d0_vp_0v9_pg                                  ), // in
  .vrm_chklive_en   (cpu1_d0_vp_p0v9_en_r_check                         ), // in
  .vrm_chklive_dis  (~cpu1_d0_vp_p0v9_en_r_check                        ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu1_d0_vp_p0v9_fault_det                           )  // out
);

// cpu1_d1_vp_p0v9_en
edge_delay #(.CNTR_NBITS(2)) cpu1_d1_vp_p0v9_en_r_inst (
  .clk              (clk                        ),
  .reset            (reset                      ),
  .cnt_size         (2'b10                      ),
  .cnt_step         (t64ms                      ),
  .signal_in        (cpu1_d1_vp_p0v9_en_r       ),
  .delay_output     (cpu1_d1_vp_p0v9_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_d1_vp_p0v9_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu1_d1_vp_p0v9_en_r & cpu1_d1_vp_p0v9_en_r_check  ), // in
  .vrm_pgood        (cpu1_d1_vp_0v9_pg                                  ), // in
  .vrm_chklive_en   (cpu1_d1_vp_p0v9_en_r_check                         ), // in
  .vrm_chklive_dis  (~cpu1_d1_vp_p0v9_en_r_check                        ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu1_d1_vp_p0v9_fault_det                           )  // out
);

// cpu1_d0_vph_p1v8_en
edge_delay #(.CNTR_NBITS(2)) cpu1_d0_vph_p1v8_en_r_inst (
  .clk              (clk                         ),
  .reset            (reset                       ),
  .cnt_size         (2'b10                       ),
  .cnt_step         (t64ms                       ),
  .signal_in        (cpu1_d0_vph_p1v8_en_r       ),
  .delay_output     (cpu1_d0_vph_p1v8_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_d0_vph_p1v8_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu1_d0_vph_p1v8_en_r & cpu1_d0_vph_p1v8_en_r_check), // in
  .vrm_pgood        (cpu1_d0_vph_1v8_pg                                 ), // in
  .vrm_chklive_en   (cpu1_d0_vph_p1v8_en_r_check                        ), // in
  .vrm_chklive_dis  (~cpu1_d0_vph_p1v8_en_r_check                       ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu1_d0_vph_p1v8_fault_det                         )  // out
);

// cpu1_d1_vph_p1v8_en
edge_delay #(.CNTR_NBITS(2)) cpu1_d1_vph_p1v8_en_r_inst (
  .clk              (clk                         ),
  .reset            (reset                       ),
  .cnt_size         (2'b10                       ),
  .cnt_step         (t64ms                       ),
  .signal_in        (cpu1_d1_vph_p1v8_en_r       ),
  .delay_output     (cpu1_d1_vph_p1v8_en_r_check )
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_d1_vph_p1v8_fault_detect_inst (
  .clk              (clk                                                ), // in
  .reset            (reset                                              ), // in
  .vrm_enable       (cpu1_d1_vph_p1v8_en_r & cpu1_d1_vph_p1v8_en_r_check), // in
  .vrm_pgood        (cpu1_d1_vph_1v8_pg                                 ), // in
  .vrm_chklive_en   (cpu1_d1_vph_p1v8_en_r_check                        ), // in
  .vrm_chklive_dis  (~cpu1_d1_vph_p1v8_en_r_check                       ), // in
  .critical_fail    (st_critical_fail                                   ), // in
  .fault_clear      (fault_clear                                        ), // in
  .lock             (any_pwr_fault_det                                  ), // in
  .any_vrm_fault    (),
  .vrm_fault        (cpu1_d1_vph_p1v8_fault_det                         )  // out
);

//------------------------------------------------------------------------------
// CPU0_PCIE_P0V9 & CPU1_PCIE_P0V9 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_pcie_p0v9_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_pcie_p0v9_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_pcie_p0v9_en_r),
  .delay_output  (cpu0_pcie_p0v9_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_pcie_p0v9_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_pcie_p0v9_en_r && cpu0_pcie_p0v9_en_r_check),	//in
  .vrm_pgood        (cpu0_pcie_p0v9_pg),						//in
  .vrm_chklive_en   (cpu0_pcie_p0v9_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_pcie_p0v9_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_pcie_p0v9_fault_det)			//out
);

wire cpu1_pcie_p0v9_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_pcie_p0v9_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_pcie_p0v9_en_r),
  .delay_output  (cpu1_pcie_p0v9_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_pcie_p0v9_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_pcie_p0v9_en_r && cpu1_pcie_p0v9_en_r_check),	//in
  .vrm_pgood        (cpu1_pcie_p0v9_pg),						//in
  .vrm_chklive_en   (cpu1_pcie_p0v9_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_pcie_p0v9_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_pcie_p0v9_fault_det)			//out
);


//------------------------------------------------------------------------------
// CPU0_PCIE_P1V8 & CPU1_PCIE_P1V8 Fault detect 
//------------------------------------------------------------------------------
wire cpu0_pcie_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu0_pcie_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu0_pcie_p1v8_en_r),
  .delay_output  (cpu0_pcie_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu0_pcie_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu0_pcie_p1v8_en_r && cpu0_pcie_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu0_pcie_p1v8_pg),						//in
  .vrm_chklive_en   (cpu0_pcie_p1v8_en_r_check),					//in
  .vrm_chklive_dis  (~cpu0_pcie_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu0_pcie_p1v8_fault_det)			//out
);

wire cpu1_pcie_p1v8_en_r_check;

edge_delay #(.CNTR_NBITS(2)) cpu1_pcie_p1v8_en_r_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpu1_pcie_p1v8_en_r),
  .delay_output  (cpu1_pcie_p1v8_en_r_check)
);

fault_detectB_chklive #(.NUMBER_OF_VRM(1)) cpu1_pcie_p1v8_fault_det_inst (
  .clk              (clk),								//in
  .reset            (reset),							//in
  .vrm_enable       (cpu1_pcie_p1v8_en_r && cpu1_pcie_p1v8_en_r_check),	//in
  .vrm_pgood        (cpu1_pcie_p1v8_pg),						//in
  .vrm_chklive_en   (cpu1_pcie_p1v8_en_r_check),						//in
  .vrm_chklive_dis  (~cpu1_pcie_p1v8_en_r_check),					//in
  .critical_fail    (st_critical_fail),					//in
  .fault_clear      (fault_clear),						//in
  .lock             (any_pwr_fault_det),				//in
  .any_vrm_fault    (),									//out
  .vrm_fault        (cpu1_pcie_p1v8_fault_det)			//out
);


//------------------------------------------------------------------------------
// THERMTRIP_DETECT
//------------------------------------------------------------------------------
wire   cpupwrok_en;
wire   cpupwrok_en_check;
assign cpupwrok_en = 1'b1;
edge_delay #(.CNTR_NBITS(2)) cpupwrok_en_check_inst (
  .clk           (clk),
  .reset         (reset),
  .cnt_size      (2'b10),
  .cnt_step      (t64ms),
  .signal_in     (cpupwrok_en),
  .delay_output  (cpupwrok_en_check)
);

genvar i;
generate for (i = 0; i < NUM_CPU; i = i + 1) begin : _CPU_THERMTRIP_DETECT_BLOCK_
  fault_detectB_chklive #(.NUMBER_OF_VRM(1)) inst_cpu_thermtrip_fault_det (
    .clk              (clk),
    .reset            (reset),
    .vrm_enable       (cpupwrok_en & cpupwrok_en_check),
    .vrm_pgood        (~i_cpu_thermtrip[i]),
    .vrm_chklive_en   (st_steady_pwrok),
    .vrm_chklive_dis  (st_off_standby),
    .critical_fail    (st_critical_fail),
    .fault_clear      (fault_clear),
    .lock             (any_pwr_fault_det),
    .any_vrm_fault    (o_cpu_thermtrip_fault[i]),
    .vrm_fault        (cpu_thermtrip_fault_det[i])
  );
end
endgenerate

//------------------------------------------------------------------------------
// HD backplane subsystem
// - Handles hard drive backplane related power monitoring and fault detection
//------------------------------------------------------------------------------
wire hd_bp_pwr_en_check;//p5v_bp_en dealy 128+128ms is hd_bp_pwr_en_check(dected bp pgd)--//V001 z25168 20221024 bp pwr_en check; IDMS:202210110152
edge_delay #(.CNTR_NBITS(3)) bp_en_check_inst (
  .clk           (clk   ),
  .reset         (reset ),
  .cnt_size      (3'b100 ),
  .cnt_step      (t64ms ),
  .signal_in     (reg_p12v_en            ),
  .delay_output  (hd_bp_pwr_en_check      )
);

generate for (i = 0; i < NUM_HD_BP; i = i + 1) begin : _HD_BP_PWR_DETECT_BLOCK_
  fault_detectB_chklive #(.NUMBER_OF_VRM(1)) inst_hd_bp_pwr_fault_det (
    .clk              (clk),
    .reset            (reset),
    .vrm_enable       (~hd_bp_prsnt_n[i] & hd_bp_pwr_en_check),
    .vrm_pgood        (hd_bp_pgd[i]       ),
    .vrm_chklive_en   (hd_bp_pwr_en_check ),
    .vrm_chklive_dis  (~hd_bp_pwr_en_check  ),
    .critical_fail    (st_critical_fail   ),
    .fault_clear      (fault_clear      ),
    .lock             (any_pwr_fault_det  ),
    .any_vrm_fault    (            ),
    .vrm_fault        (hd_bp_fault_det[i] )
  );
end
endgenerate

//------------------------------------------------------------------------------
// Riser card subsystem
// - Handles riser card card related power monitoring and fault detection
//------------------------------------------------------------------------------

edge_delay #(.CNTR_NBITS(2)) riser_pwr_en_check_inst (
  .clk           (clk   ),
  .reset         (reset ),
  .cnt_size      (2'b10 ),
  .cnt_step      (t64ms ),
  .signal_in     (reg_p12v_en            ),
  .delay_output  (reg_riser_chk_en      )
);

generate if (NUM_RISER > 0) begin : _RISER_PWR_CNTLR_BLOCK_
  pwrseq_slave_dev #(.NUM_DEV(NUM_RISER)) pwrseq_slave_riser_inst (
    .reset                  (reset),
    .clk                    (clk),
    .t1us                   (t1us),
    .gate_en                (reg_p12v_en),
    .keep_alive_on_fault    (keep_alive_on_fault),//1'b0
    .chklive_en             ( reg_riser_chk_en),
    .chklive_dis            (~reg_riser_chk_en),
    .pwrdis_en              (1'b0),
    .sm_critical_fail       (st_critical_fail),
    .fault_clear            (fault_clear),
    .any_pwr_fault_det      (any_pwr_fault_det),
    .pgd_so_far             (riser_pgd_so_far),
    .prsnt_n                (riser_prsnt_n),
    .pal_en                 (pal_riser_en),
    .pgd_pwr                (riser_pgd),
    .mod_fault              (riser_mod_fault),
    .fault_det              (riser_fault_det),
    .fault_pwrdis           ()
  );
end
else begin
  assign riser_pgd_so_far = 1'b1;
  assign pal_riser_en     = 1'b0;
  assign riser_mod_fault  = 1'b0;
  assign riser_fault_det  = 1'b0;
end
endgenerate

//------------------------------------------------------------------------------
// Aux rails to check
// - check enabled when NUM_OPT_AUX is > 0
//------------------------------------------------------------------------------
//Fault Flag
wire  [FAULT_VEC_SIZE-1:0]                fault_vec                   ;
wire  [FAULT_VEC_SIZE-1:0]                any_recov_fault_vec         ;
wire  [FAULT_VEC_SIZE-1:0]                any_lim_recov_fault_vec     ;
wire  [FAULT_VEC_SIZE-1:0]                any_non_recov_fault_vec     ;
wire                                      any_recov_fault_c           ;
wire                                      any_lim_recov_fault_c       ;
wire                                      any_non_recov_fault_c       ;

wire                                      aux_fault                   ;

assign any_aux_vrm_fault = aux_fault;

// fault_vec_mapping
assign fault_vec[0]  = p5v_stby_fault_det            ;  
assign fault_vec[1]  = p3v3_stby_bp_fault_det        ;  
assign fault_vec[2]  = main_efuse_fault_det          ; // 未使用 
assign fault_vec[3]  = p3v3_stby_fault_det           ;  

assign fault_vec[4]  = p12v_front_bp_efuse_fault_det ;  
assign fault_vec[5]  = p12v_reat_bp_efuse_fault_det  ;
assign fault_vec[6]  = p12v_fan_efuse_fault_det      ; // 未使用
assign fault_vec[7]  = p12v_dimm_efuse_fault_det     ;
assign fault_vec[8]  = p12v_cpu1_vin_fault_det       ;
assign fault_vec[9]  = p12v_cpu0_vin_fault_det       ;
assign fault_vec[10] = p12v_fault_det                ;  
assign fault_vec[11] = p12v_stby_droop_fault_det     ;

assign fault_vec[12] = p5v_fault_det                 ;
assign fault_vec[13] = p3v3_fault_det                ;
assign fault_vec[14] = vcc_1v1_fault_det             ;

assign fault_vec[15] = cpu0_vdd_core_fault_det       ;  
assign fault_vec[16] = cpu1_vdd_core_fault_det       ;

assign fault_vec[17] = cpu0_p1v8_fault_det           ;  
assign fault_vec[18] = cpu1_p1v8_fault_det           ;

assign fault_vec[19] = cpu0_vddq_fault_det           ;  
assign fault_vec[20] = cpu1_vddq_fault_det           ;
assign fault_vec[21] = cpu0_ddr_vdd_fault_det        ;  
assign fault_vec[22] = cpu1_ddr_vdd_fault_det        ;
assign fault_vec[23] = cpu0_pll_p1v8_fault_det       ;  
assign fault_vec[24] = cpu1_pll_p1v8_fault_det       ;

assign fault_vec[25] =  cpu1_pcie_p1v8_fault_det     ;  
assign fault_vec[26] =  cpu0_pcie_p1v8_fault_det     ;
assign fault_vec[27] =  cpu1_pcie_p0v9_fault_det     ;  
assign fault_vec[28] =  cpu0_pcie_p0v9_fault_det     ;

assign fault_vec[29] =  cpu0_d0_vp_p0v9_fault_det     ;  
assign fault_vec[30] =  cpu0_d1_vp_p0v9_fault_det     ;
assign fault_vec[31] =  cpu0_d0_vph_p1v8_fault_det    ;  
assign fault_vec[32] =  cpu0_d1_vph_p1v8_fault_det    ;
assign fault_vec[33] =  cpu1_d0_vp_p0v9_fault_det     ;  
assign fault_vec[34] =  cpu1_d1_vp_p0v9_fault_det     ;
assign fault_vec[35] =  cpu1_d0_vph_p1v8_fault_det    ;  
assign fault_vec[36] =  cpu1_d1_vph_p1v8_fault_det    ;

assign fault_vec[37] = 1'b0;  // RSVD
assign fault_vec[38] = 1'b0;  // RSVD
assign fault_vec[39] = 1'b0;  // RSVD


// Mask each fault with the corresponding bits
generate for (i = 0; i < FAULT_VEC_SIZE; i = i + 1) begin : _fault_vec_block_
  assign any_recov_fault_vec[i]     = fault_vec[i] & RECOV_FAULT_MASK[i];
  assign any_lim_recov_fault_vec[i] = fault_vec[i] & LIM_RECOV_FAULT_MASK[i];
  assign any_non_recov_fault_vec[i] = fault_vec[i] & NON_RECOV_FAULT_MASK[i];
end
endgenerate

assign any_recov_fault_c     = |any_recov_fault_vec;
assign any_lim_recov_fault_c = |any_lim_recov_fault_vec;
assign any_non_recov_fault_c = |any_non_recov_fault_vec;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    any_pwr_fault_det   <= 1'b0;
    any_recov_fault     <= 1'b0;
    any_lim_recov_fault <= 1'b0;
    any_non_recov_fault <= 1'b0;
  end
  else begin
    any_pwr_fault_det   <= any_recov_fault_c | any_lim_recov_fault_c | any_non_recov_fault_c;
    any_recov_fault     <= any_recov_fault_c;
    any_lim_recov_fault <= any_lim_recov_fault_c;
    any_non_recov_fault <= any_non_recov_fault_c;
  end
end
/*******************************************************************************
//------------------------------------------------------------------------------
// Fault Detect End
//------------------------------------------------------------------------------
********************************************************************************/


//------------------------------------------------------------------------------
// pwrseq_sm_fault_det
// - Stores the power sequencer state where a power fault was detected.
//------------------------------------------------------------------------------
reg  fault_save_en;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fault_save_en       <= 1'b1;
        pwrseq_sm_fault_det <= 6'b0;
    end
    else if (t1us && fault_clear) begin
        fault_save_en       <= 1'b1;
        pwrseq_sm_fault_det <= 6'b0;
    end
    else if (t1us && st_critical_fail)
        fault_save_en       <= 1'b0;
    else if (t1us && fault_save_en)
        pwrseq_sm_fault_det <= power_seq_sm;
end


//------------------------------------------------------------------------------
// pgd_so_far
// - Reflects current status of power rail pgood signal qualified by their
//   respective enable signal. This signal is used by pwrseq_master.
//20170526 QIURONGLIN, PWM_CTRL_VDD/P5V_STBY is forced on once BMC AUX power is OK,
//which is independent of the normal power sequence, and whose pwr_ok detection would
//cause the sequence abnormally.
//------------------------------------------------------------------------------
always @(posedge clk or posedge reset) begin
  if (reset)
    pgd_so_far <= 1'b0;
  else
    pgd_so_far <= 1'b1;
end

endmodule