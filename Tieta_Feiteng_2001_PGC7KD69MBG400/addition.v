/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 系统时钟: input 25MHz, output 100MHz/50MHz/25MHz
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                        clk_50m                     ; // 50mHz 时钟
wire                                        sys_clk                     ; // 系统时钟
wire                                        pll_lock                    ;
wire                                        pal_p3v3_stby_pgd           ;

assign pal_p3v3_stby_pgd = CPLD_M_S_EXCHANGE_S1 ;
pll_i25M_o50M_o25M pll_inst (
    .clkin1                                 (i_CLK_C42_IN_25M           ), // input 25.0000MHz
    .rst                                    (~pal_p3v3_stby_pgd         ), // input
    .clkout0                                (clk_50m                    ), // output 50.00000000MHz
    .clkout1                                (sys_clk                    ), // output 25.00000000MHz
    .lock                                   (pll_lock                   )  // output
);
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 系统时钟: input 25MHz, output 100MHz/50MHz/25MHz
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 全局复位 
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                        pgd_aux_bmc                 ; // 不使用, BMC_PDG, 来自BMC, 默认写1
wire                                        done_booting_delayed        ; // 不使用, 系统booting_done, 来自BMC, 默认写1
wire                                        pon_reset_n                 ; // 使用  , 全局复位
wire                                        pon_reset_db_n              ; // 不使用, 复位
wire                                        pgd_aux_system              ; // 不使用, 复位
wire                                        pgd_aux_system_sasd         ; // 不使用, 复位
wire                                        cpld_ready                  ; // 不使用, 复位

assign                                      pgd_aux_bmc          = 1'b1 ; // 不使用, BMC_PDG, 来自BMC, 默认写1
assign                                      done_booting_delayed = 1'b1 ; // 不使用, 系统booting_done, 来自BMC, 默认写1

pon_reset pon_reset_inst( 
    .clk                                    (clk_50m                    ),// input:  复位/PGD 同步时钟源（50MHz）
    .pll_lock                               (pll_lock                   ),// input:  仅在 PLL 锁定后才允许释放复位
    .pgd_p3v3_stby                          (pal_p3v3_stby_pgd          ),// input:  待机 3.3V 电源良好指示（PGD）
    .pgd_aux_gmt                            (pgd_aux_bmc                ),// input:  来自 BMC 的 AUX PGD 原始输入
    .done_booting                           (1'b1                       ),// input:  系统就绪输入：此处常置 1，表示无需等待外部就绪
    .done_booting_delayed                   (done_booting_delayed       ),// output: 系统就绪延迟版，供时序控制/监控
    .pon_reset_n                            (pon_reset_n                ),// output: 全局复位（低有效，不考虑pdg_aux_bmc）
    .pon_reset_db_n                         (pon_reset_db_n             ),// output: 全局复位（低有效, 考虑pdg_aux_bmc）
    .pgd_aux_system                         (pgd_aux_system             ),// output: 系统域 AUX PGD（稳定）
    .pgd_aux_system_sasd                    (pgd_aux_system_sasd        ),// output: 系统域 AUX PGD（稳定）
    .cpld_ready                             (cpld_ready                 ) // output：CPLD 就绪指示（低有效）
);
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 全局复位 
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 时钟树
------------------------------------------------------------------------------------------------------------------------------------------------*/
// tick 定时脉冲; clk 频率时钟
wire                                        t40ns_tick                  ;
wire                                        t80ns_tick                  ;
wire                                        t160ns_tick                 ;
wire                                        t1us_tick                   ;
wire                                        t2us_tick                   ;  
wire                                        t8us_tick                   ;
wire                                        t16us_tick                  ;
wire                                        t32us_tick                  ;
wire                                        t128us_tick                 ;
wire                                        t512us_tick                 ;
wire                                        t1ms_tick                   ;
wire                                        t2ms_tick                   ;
wire                                        t16ms_tick                  ;
wire                                        t32ms_tick                  ;
wire                                        t64ms_tick                  ;
wire                                        t128ms_tick                 ;
wire                                        t256ms_tick                 ;
wire                                        t512ms_tick                 ;
wire                                        t1s_tick                    ;
wire                                        t8s_tick                    ;
wire                                        t0p5hz_clk                  ;
wire                                        t1hz_clk                    ;
wire                                        t2p5hz_clk                  ;
wire                                        t4hz_clk                    ;
wire                                        t16khz_clk                  ;
wire                                        t6m25_clk                   ;

timer_gen timer_gen_inst(
    .clk                                    (clk_50m                    ),
    .reset                                  (~pon_reset_n               ),
    .t40ns                                  (t40ns_tick                 ),
    .t80ns                                  (t80ns_tick                 ),
    .t160ns                                 (t160ns_tick                ),
    .t1us                                   (t1us_tick                  ),
    .t2us                                   (t2us_tick                  ),
    .t8us                                   (t8us_tick                  ),
    .t16us                                  (t16us_tick                 ),
    .t32us                                  (t32us_tick                 ),
    .t128us                                 (t128us_tick                ),
    .t512us                                 (t512us_tick                ),
    .t1ms                                   (t1ms_tick                  ),
    .t2ms                                   (t2ms_tick                  ),
    .t16ms                                  (t16ms_tick                 ),
    .t32ms                                  (t32ms_tick                 ),
    .t64ms                                  (t64ms_tick                 ),
    .t128ms                                 (t128ms_tick                ),
    .t256ms                                 (t256ms_tick                ),
    .t512ms                                 (t512ms_tick                ),
    .t1s                                    (t1s_tick                   ),
    .t8s                                    (t8s_tick                   ),
    .clk_0p5hz                              (t0p5hz_clk	                ),
    .clk_1hz                                (t1hz_clk                   ),
    .clk_2p5hz                              (t2p5hz_clk                 ),
    .clk_4hz                                (t4hz_clk                   ),
    .clk_16khz                              (t16khz_clk                 ),
    .clk_6m25                               (t6m25_clk                  )
);
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 时钟树
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 输入信号滤波, 去抖动
------------------------------------------------------------------------------------------------------------------------------------------------*/
PGM_DEBOUNCE_N #(.SIGCNT(4), .NBITS(2'b11), .ENABLE(1'b1)) db_inst_pwrgood (
    .clk		(clk_50m                    ),
    .rst_n		(pon_reset_n                ),
    .timer_tick	(1'b1                       ),
    .din        ({
	                PAL_OCP2_PWRGD           ,	//01
	                ~DIMM_SNS_ALERT          ,  //02
	                ~FAN_SNS_ALERT           ,  //03
	                ~P12V_STBY_SNS_ALERT        //04
	            }),             
    .dout       ({
    	            db_i_pal_ocp2_pwrgd      ,	//01
    	            db_i_dimm_sns_alert      ,  //02
    	            db_i_fan_sns_alert       ,  //03
    	            db_i_p12v_stby_sns_alert    //04
    	        }) 
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 输入信号滤波, 去抖动
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
// M CPLD ---> S CPLD 串转并
wire [511:0]        mcpld_to_scpld_s2p_data     ;
reg  [345:0]        mcpld_to_scpld_data_filter  ;
reg                 mcpld_sgpio_fail            ;

s2p_slave #(.NBIT(512)) inst_mb_to_cmu_s2p(
	.clk        (clk_50m                    ),
	.rst        (~pon_reset_n               ),
	.si         (i_CPLD_M_S_SGPIO_MOSI	    ),//SGPIO_MOSI Serial Signal input
	.po         (mcpld_to_scpld_s2p_data    ),//Parallel Signal output
	.sld_n      (i_CPLD_M_S_SGPIO_LD_N	    ),//SGPIO_LOAD
	.sclk       (i_CPLD_M_S_SGPIO_CLK		) //SGPIO_CLK
); 

// 数据滤波与有效性判断
always @(posedge clk_50m or negedge pon_reset_n)begin
	if(~pon_reset_n) begin
		mcpld_to_scpld_data_filter  <= {346{1'b0}}                   ;
		mcpld_sgpio_fail            <= 1'b0                          ;
	end
	else if((mcpld_to_scpld_s2p_data[3:0] == 4'b0101) && (mcpld_to_scpld_s2p_data[511:508] == 4'b1010))begin 
		mcpld_to_scpld_data_filter  <= mcpld_to_scpld_s2p_data[349:4];
		mcpld_sgpio_fail            <= 1'b0                          ;
	end
	else begin
		mcpld_to_scpld_data_filter  <= mcpld_to_scpld_data_filter    ;
		mcpld_sgpio_fail            <= 1'b1                          ;
	end	
end

// M CPLD ---> S CPLD 数据解析
wire                                    test_bat_en                         ;
wire                                    bmc_extrst_uid                      ;
wire                                    pal_m2_0_sel_lv33_r                 ;

wire [7:0]                              i2c_ram_1058                        ;
wire [7:0]                              i2c_ram_1057                        ;
wire [7:0]                              i2c_ram_1056                        ;
wire [7:0]                              i2c_ram_1055                        ;
wire [7:0]                              i2c_ram_1054                        ;
wire [7:0]                              i2c_ram_1053                        ;
wire [7:0]                              i2c_ram_1052                        ;
wire [7:0]                              i2c_ram_1051                        ;
wire [7:0]                              i2c_ram_1050                        ;

wire                                    pal_bp_efuse_pg                     ;
wire                                    rst_i2c0_mux_n                      ;
wire                                    pal_led_nic_act                     ;
wire                                    rst_i2c_riser2_pca9548_n            ;
wire                                    rst_i2c_riser1_pca9548_n            ;
wire                                    cpu0_d0_bios_over                   ;
wire                                    bmc_read_flag                       ;
wire                                    vga2_dis                            ;

wire [39:0]                             pfr_to_led                          ;
wire                                    pgd_p1v8_stby_dly32ms               ;
wire                                    pgd_p1v8_stby_dly30ms               ;
wire                                    bios_security_bypass                ;
wire                                    pal_rtc_intb                        ;
wire                                    pal_ocp_ncsi_sw_en                  ;
wire                                    pal_ocp2_ncsi_en                    ;
wire                                    pal_ocp1_ncsi_en                    ;
wire                                    pal_pe_wake_n                       ;
wire                                    smb_pehp_cpu1_3v3_alert_n           ;

wire [1:0]                              debug_reg_15                        ; 
wire                                    rom_mux_bios_bmc_en                 ;      
wire [31:0]                             AUX_BP_type                         ;
wire [127:0]                            pcie_detect                         ;
wire [15:0]                             o_mb_cb_prsnt_bmc                   ;
wire                                    rom_mux_bios_bmc_sel                ; 

wire [1:0]                              bmcctl_uart_sw                      ;
wire                                    rom_bmc_bk_rst                      ;
wire                                    rom_bmc_ma_rst                      ;
wire                                    rst_pal_extrst_r_n                  ;
wire                                    leakage_det_do_n                    ;
wire                                    tpm_rst                             ;
wire                                    rst_i2c13_mux_n                     ;
wire                                    rst_i2c12_mux_n                     ;
wire                                    rst_i2c11_mux_n                     ;
wire                                    rst_i2c10_mux_n                     ;
wire                                    rst_i2c8_mux_n                      ;
wire                                    rst_i2c5_mux_n                      ;
wire                                    rst_i2c4_2_mux_n                    ;
wire                                    rst_i2c4_1_mux_n                    ;
wire                                    rst_i2c3_mux_n                      ;
wire                                    rst_i2c2_mux_n                      ;
wire                                    rst_i2c1_mux_n                      ;
wire                                    sys_hlth_red_blink_n                ;
wire                                    sys_hlth_grn_blink_n                ;
wire                                    led_uid                             ;
wire                                    power_supply_on                     ;
wire                                    ocp_main_en                         ;
wire                                    ocp_aux_en                          ;
wire                                    pex_reset_n                         ;
wire                                    reached_sm_wait_powerok             ;
wire                                    usb_ponrst_r_n                      ;
wire                                    t4hz_test_mcpld                     ;
wire [5:0]                              power_seq_sm		                ;   

assign test_bat_en                    = mcpld_to_scpld_data_filter[345]     ;
assign bmc_extrst_uid                 = mcpld_to_scpld_data_filter[344]     ;
assign pal_m2_0_sel_lv33_r            = mcpld_to_scpld_data_filter[343]     ;
assign i2c_ram_1058                   = mcpld_to_scpld_data_filter[342:335] ;
assign i2c_ram_1057                   = mcpld_to_scpld_data_filter[334:327] ;
assign i2c_ram_1056                   = mcpld_to_scpld_data_filter[326:319] ;
assign i2c_ram_1055                   = mcpld_to_scpld_data_filter[318:311] ;
assign i2c_ram_1054                   = mcpld_to_scpld_data_filter[310:303] ;
assign i2c_ram_1053                   = mcpld_to_scpld_data_filter[302:295] ;
assign i2c_ram_1052                   = mcpld_to_scpld_data_filter[294:287] ;
assign i2c_ram_1051                   = mcpld_to_scpld_data_filter[286:279] ;
assign i2c_ram_1050                   = mcpld_to_scpld_data_filter[278:271] ;
assign pal_bp_efuse_pg                = mcpld_to_scpld_data_filter[270]     ;
assign rst_i2c0_mux_n                 = mcpld_to_scpld_data_filter[269]     ;
assign pal_led_nic_act                = mcpld_to_scpld_data_filter[268]     ;
assign rst_i2c_riser2_pca9548_n       = mcpld_to_scpld_data_filter[267]     ;
assign rst_i2c_riser1_pca9548_n       = mcpld_to_scpld_data_filter[266]     ;
assign cpu0_d0_bios_over              = mcpld_to_scpld_data_filter[265]     ;
assign bmc_read_flag                  = mcpld_to_scpld_data_filter[264]     ;
assign vga2_dis                       = mcpld_to_scpld_data_filter[263]     ;
assign pfr_to_led                     = mcpld_to_scpld_data_filter[262:223] ;
assign pgd_p1v8_stby_dly32ms          = mcpld_to_scpld_data_filter[222]     ;
assign pgd_p1v8_stby_dly30ms          = mcpld_to_scpld_data_filter[221]     ;
assign bios_security_bypass           = mcpld_to_scpld_data_filter[220]     ;
assign pal_rtc_intb                   = mcpld_to_scpld_data_filter[219]     ;
assign pal_ocp_ncsi_sw_en             = mcpld_to_scpld_data_filter[218]     ;
assign pal_ocp2_ncsi_en               = mcpld_to_scpld_data_filter[217]     ;
assign pal_ocp1_ncsi_en               = mcpld_to_scpld_data_filter[216]     ;
assign pal_pe_wake_n                  = mcpld_to_scpld_data_filter[215]     ;
assign smb_pehp_cpu1_3v3_alert_n      = mcpld_to_scpld_data_filter[214]     ;
assign debug_reg_15[1:0]              = mcpld_to_scpld_data_filter[213:212] ;
assign rom_mux_bios_bmc_en            = mcpld_to_scpld_data_filter[211]     ;
assign AUX_BP_type[31:0]              = mcpld_to_scpld_data_filter[210:179] ;
assign pcie_detect[127:0]             = mcpld_to_scpld_data_filter[178:51]  ;
assign o_mb_cb_prsnt_bmc[15:0]        = mcpld_to_scpld_data_filter[50:35]   ;
assign rom_mux_bios_bmc_sel           = mcpld_to_scpld_data_filter[34]      ;
//assign bmcctl_uart_sw_en            = mcpld_to_scpld_data_filter[33] ;
assign bmcctl_uart_sw[1:0]            = mcpld_to_scpld_data_filter[33:32]   ;
assign rom_bmc_bk_rst                 = mcpld_to_scpld_data_filter[31]      ;
assign rom_bmc_ma_rst                 = mcpld_to_scpld_data_filter[30]      ;
assign rst_pal_extrst_r_n             = mcpld_to_scpld_data_filter[29]      ;
assign leakage_det_do_n               = mcpld_to_scpld_data_filter[28]      ;
assign tpm_rst                        = mcpld_to_scpld_data_filter[27]      ;
assign rst_i2c13_mux_n                = mcpld_to_scpld_data_filter[26]      ;
assign rst_i2c12_mux_n                = mcpld_to_scpld_data_filter[25]      ;
assign rst_i2c11_mux_n                = mcpld_to_scpld_data_filter[24]      ;
assign rst_i2c10_mux_n                = mcpld_to_scpld_data_filter[23]      ;
assign rst_i2c8_mux_n                 = mcpld_to_scpld_data_filter[22]      ;
assign rst_i2c5_mux_n                 = mcpld_to_scpld_data_filter[21]      ;
assign rst_i2c4_2_mux_n               = mcpld_to_scpld_data_filter[20]      ;
assign rst_i2c4_1_mux_n               = mcpld_to_scpld_data_filter[19]      ;
assign rst_i2c3_mux_n                 = mcpld_to_scpld_data_filter[18]      ;
assign rst_i2c2_mux_n                 = mcpld_to_scpld_data_filter[17]      ;
assign rst_i2c1_mux_n                 = mcpld_to_scpld_data_filter[16]      ;
assign sys_hlth_red_blink_n           = mcpld_to_scpld_data_filter[15]      ;
assign sys_hlth_grn_blink_n           = mcpld_to_scpld_data_filter[14]      ;
assign led_uid                        = mcpld_to_scpld_data_filter[13]      ;
assign power_supply_on                = mcpld_to_scpld_data_filter[12]      ;
assign ocp_main_en                    = mcpld_to_scpld_data_filter[11]      ;
assign ocp_aux_en                     = mcpld_to_scpld_data_filter[10]      ;
assign pex_reset_n                    = mcpld_to_scpld_data_filter[9]       ;
assign reached_sm_wait_powerok        = mcpld_to_scpld_data_filter[8]       ;
assign usb_ponrst_r_n                 = mcpld_to_scpld_data_filter[7]       ;
assign t4hz_test_mcpld                = mcpld_to_scpld_data_filter[6]       ;
assign power_seq_sm		              = mcpld_to_scpld_data_filter[5:0]     ;

// S CPLD ---> M CPLD
wire [511:0]                          scpld_to_mcpld_p2s_data           ;
p2s_slave #(.NBIT(512)) inst_cmu_to_mb_p2s(
	.clk        (clk_50m					),
	.rst        (~pon_reset_n				),
	.pi         (scpld_to_mcpld_p2s_data	),//Parallel Signal input
	.so         (o_CPLD_M_S_SGPIO_MISO_R	),//SGPIO_MISO Serial Signal output
	.sld_n      (i_CPLD_M_S_SGPIO_LD_N   	),//SGPIO_LOAD
	.sclk       (i_CPLD_M_S_SGPIO_CLK	    ) //SGPIO_CLK
);

// S CPLD ---> M CPLD 数据组装
assign scpld_to_mcpld_p2s_data[511]     = 1'b1                           ; 
assign scpld_to_mcpld_p2s_data[510]     = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[509]     = 1'b1                           ; 
assign scpld_to_mcpld_p2s_data[508]     = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[507:431] = 77'b0                          ;
assign scpld_to_mcpld_p2s_data[430]     = bmc_ready_flag                 ;
assign scpld_to_mcpld_p2s_data[429]     = db_i_pal_pgd_p3v3              ;
assign scpld_to_mcpld_p2s_data[428]     = db_i_pal_pgd_p1v8              ;
assign scpld_to_mcpld_p2s_data[427]     = db_i_pal_pgd_p1v2              ;
assign scpld_to_mcpld_p2s_data[426]     = db_i_pal_pgd_p1v1              ;
assign scpld_to_mcpld_p2s_data[425]     = db_i_pal_pgd_p0v8              ;
assign scpld_to_mcpld_p2s_data[424]     = cpu1_temp_over                 ;
assign scpld_to_mcpld_p2s_data[423]     = cpu0_temp_over                 ;
assign scpld_to_mcpld_p2s_data[422]     = 1'b0                           ;//db_i_lom_prsnt_n
assign scpld_to_mcpld_p2s_data[421]     = 1'b0                           ;//lom_thermal_trip
assign scpld_to_mcpld_p2s_data[420]     = db_i_pal_ocp2_fan_prsnt_n      ;
assign scpld_to_mcpld_p2s_data[419]     = db_i_pal_ocp2_fan_foo          ;
assign scpld_to_mcpld_p2s_data[418]     = db_i_pal_lcd_card_in           ;
assign scpld_to_mcpld_p2s_data[417]     = i_pal_ifist_prsnt_n            ;
assign scpld_to_mcpld_p2s_data[416:409] = bios_post_code[7:0]           ;
assign scpld_to_mcpld_p2s_data[408:401] = bios_post_phase[7:0]          ;
assign scpld_to_mcpld_p2s_data[400:393] = bios_post_rate[7:0]           ;
assign scpld_to_mcpld_p2s_data[392]     = bios_read_flag                 ;
assign scpld_to_mcpld_p2s_data[391:384] = {pal_bp8_prsnt_n,pal_bp7_prsnt_n,pal_bp6_prsnt_n,pal_bp5_prsnt_n,pal_bp4_prsnt_n,pal_bp3_prsnt_n,pal_bp2_prsnt_n,pal_bp1_prsnt_n};//led_to_pfr[7:0];
assign scpld_to_mcpld_p2s_data[383]     = USB2_LCD_ALERT                 ;
assign scpld_to_mcpld_p2s_data[382]     = VGA2_OC_ALERT                  ;
assign scpld_to_mcpld_p2s_data[381]     = 1'b0                           ;//PAL_UPD72020_2_ALART
assign scpld_to_mcpld_p2s_data[380]     = 1'b0                           ;//PAL_UPD72020_1_ALART
assign scpld_to_mcpld_p2s_data[379]     = usb_en[1]                      ;
assign scpld_to_mcpld_p2s_data[378]     = usb_en[0]                      ;
assign scpld_to_mcpld_p2s_data[377]     = DSD_UART_PRSNT_N               ;
assign scpld_to_mcpld_p2s_data[376]     = pfr_pe_wake_n                  ;
assign scpld_to_mcpld_p2s_data[375:368] = ocp2_pvti_byte3                ;       
assign scpld_to_mcpld_p2s_data[367:360] = ocp2_pvti_byte2                ;             
assign scpld_to_mcpld_p2s_data[359:352] = ocp2_pvti_byte1                ;
assign scpld_to_mcpld_p2s_data[351:344] = ocp2_pvti_byte0                ;
assign scpld_to_mcpld_p2s_data[343:336] = ocp1_pvti_byte3                ;
assign scpld_to_mcpld_p2s_data[335:328] = ocp1_pvti_byte2                ;
assign scpld_to_mcpld_p2s_data[327:320] = ocp1_pvti_byte1                ;
assign scpld_to_mcpld_p2s_data[319:312] = ocp1_pvti_byte0                ;
assign scpld_to_mcpld_p2s_data[311:308] = board_id                       ;
assign scpld_to_mcpld_p2s_data[307:305] = pcb_version                    ;
assign scpld_to_mcpld_p2s_data[304:299] = riser4_slot10_id               ;
assign scpld_to_mcpld_p2s_data[298:293] = riser4_slot9_id                ;
assign scpld_to_mcpld_p2s_data[292:287] = riser3_slot8_id                ;
assign scpld_to_mcpld_p2s_data[286:281] = riser3_slot7_id                ;
assign scpld_to_mcpld_p2s_data[280]     = riser4_2_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[279]     = riser4_1_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[278]     = riser3_2_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[277]     = riser3_1_prsnt_n               ;
assign scpld_to_mcpld_p2s_data[276]     = riser4_slot10_prsnt_n          ;
assign scpld_to_mcpld_p2s_data[275]     = riser4_slot9_prsnt_n           ;
assign scpld_to_mcpld_p2s_data[274]     = riser3_slot8_prsnt_n           ;
assign scpld_to_mcpld_p2s_data[273]     = riser3_slot7_prsnt_n           ;
assign scpld_to_mcpld_p2s_data[272]     = w4GpuRiser2Flag                ;
assign scpld_to_mcpld_p2s_data[271]     = w4GpuRiser1Flag                ;
assign scpld_to_mcpld_p2s_data[270:263] = riser2_pvti_byte3              ;
assign scpld_to_mcpld_p2s_data[262:255] = riser2_pvti_byte2              ;
assign scpld_to_mcpld_p2s_data[254:247] = riser2_pvti_byte1              ;
assign scpld_to_mcpld_p2s_data[246:239] = riser2_pvti_byte0              ;
assign scpld_to_mcpld_p2s_data[238:231] = riser1_pvti_byte3              ;
assign scpld_to_mcpld_p2s_data[230:223] = riser1_pvti_byte2              ;
assign scpld_to_mcpld_p2s_data[222:215] = riser1_pvti_byte1              ;
assign scpld_to_mcpld_p2s_data[214:207] = riser1_pvti_byte0              ;
assign scpld_to_mcpld_p2s_data[206:191] = mb_cb_prsnt[15:0]              ;
assign scpld_to_mcpld_p2s_data[190]     = db_riser_prsnt_det_2           ;
assign scpld_to_mcpld_p2s_data[189]     = db_riser_prsnt_det_3           ;
assign scpld_to_mcpld_p2s_data[188]     = db_riser_prsnt_det_0           ;
assign scpld_to_mcpld_p2s_data[187]     = db_riser_prsnt_det_1           ;
assign scpld_to_mcpld_p2s_data[186]     = db_i_riser_prsnt_det_9         ;
assign scpld_to_mcpld_p2s_data[185]     = db_i_riser_prsnt_det_8         ;
assign scpld_to_mcpld_p2s_data[184]     = db_riser_prsnt_det_6           ;
assign scpld_to_mcpld_p2s_data[183]     = db_riser_prsnt_det_7           ;
assign scpld_to_mcpld_p2s_data[182]     = db_riser_prsnt_det_4           ;
assign scpld_to_mcpld_p2s_data[181]     = db_riser_prsnt_det_5           ;
assign scpld_to_mcpld_p2s_data[180]     = db_i_riser_prsnt_det_11        ;
assign scpld_to_mcpld_p2s_data[179]     = db_i_riser_prsnt_det_10        ;
assign scpld_to_mcpld_p2s_data[178:135] = nvme_slot_number[43:0]         ;
assign scpld_to_mcpld_p2s_data[134:115] = riser_ocp_m2_slot_number[19:0] ;
assign scpld_to_mcpld_p2s_data[114]     = db_i_p12v_stby_sns_alert       ;
assign scpld_to_mcpld_p2s_data[113]     = db_i_fan_sns_alert             ;
assign scpld_to_mcpld_p2s_data[112]     = db_i_dimm_sns_alert            ;
assign scpld_to_mcpld_p2s_data[111]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_5
assign scpld_to_mcpld_p2s_data[110]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_4
assign scpld_to_mcpld_p2s_data[109]     = 1'b0                           ;//20231221 d00412 VB PCA_REVISION_3
assign scpld_to_mcpld_p2s_data[108]     = pal_gpu_fan4_prsnt             ;//BOARD_ID4
assign scpld_to_mcpld_p2s_data[107]     = pal_gpu_fan3_prsnt             ;//BOARD_ID3
assign scpld_to_mcpld_p2s_data[106]     = pal_gpu_fan2_prsnt             ;//BOARD_ID2
assign scpld_to_mcpld_p2s_data[105]     = pal_gpu_fan1_prsnt             ;//BOARD_ID1
assign scpld_to_mcpld_p2s_data[104]     = pal_gpu_fan4_foo               ;//BOARD_ID0
assign scpld_to_mcpld_p2s_data[103]     = pal_gpu_fan3_foo               ;//CHASSIS_ID2_N
assign scpld_to_mcpld_p2s_data[102]     = pal_gpu_fan2_foo               ;
assign scpld_to_mcpld_p2s_data[101]     = pal_gpu_fan1_foo               ;
assign scpld_to_mcpld_p2s_data[100:85]  = bmc_cpld_version               ;
assign scpld_to_mcpld_p2s_data[84]      = pcb_revision_1                 ;//PCB_REVISION_1
assign scpld_to_mcpld_p2s_data[83]      = pcb_revision_0                 ;//PCB_REVISION_0
assign scpld_to_mcpld_p2s_data[82]      = pca_revision_2                 ;//PCA_REVISION_2
assign scpld_to_mcpld_p2s_data[81]      = pca_revision_1                 ;//PCA_REVISION_1
assign scpld_to_mcpld_p2s_data[80]      = pca_revision_0                 ;
assign scpld_to_mcpld_p2s_data[79:64]   = mb_cpld2_ver                   ;
assign scpld_to_mcpld_p2s_data[63]      = i_pal_wdt_rst_n_r              ;
assign scpld_to_mcpld_p2s_data[62]      = TPM_MODULE_PRSNT_N             ;//TPM_PRSNT_N
assign scpld_to_mcpld_p2s_data[61]      = 1'b0                           ;
assign scpld_to_mcpld_p2s_data[60]      = 1'b0                           ;//PAL_LCD_PRSNT
assign scpld_to_mcpld_p2s_data[59]      = PAL_M2_1_SEL_R                 ;//PAL_LCD_BUSY
assign scpld_to_mcpld_p2s_data[58]      = PAL_M2_1_PRSNT_N               ;
assign scpld_to_mcpld_p2s_data[57]      = PAL_M2_0_PRSNT_N               ;
assign scpld_to_mcpld_p2s_data[56]      = PAL_RISER2_PRSNT_N             ;
assign scpld_to_mcpld_p2s_data[55]      = PAL_RISER1_PRSNT_N             ;
assign scpld_to_mcpld_p2s_data[54]      = riser2_emc_alert_n             ;
assign scpld_to_mcpld_p2s_data[53]      = riser1_emc_alert_n             ;
assign scpld_to_mcpld_p2s_data[52]      = db_pal_ext_rst_n               ;
assign scpld_to_mcpld_p2s_data[51:44]   = sw                             ;
assign scpld_to_mcpld_p2s_data[43]      = cpu_nvme17_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[42]      = cpu_nvme16_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[41]      = cpu_nvme15_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[40]      = cpu_nvme14_prsnt_n             ;//CPU1 D3
assign scpld_to_mcpld_p2s_data[39]      = cpu_nvme13_prsnt_n             ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[38]      = cpu_nvme12_prsnt_n             ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[37]      = cpu_nvme11_prsnt_n             ;//CPU1 D2 
assign scpld_to_mcpld_p2s_data[36]      = cpu_nvme10_prsnt_n             ;//CPU1 D2
assign scpld_to_mcpld_p2s_data[35]      = CPU_NVME19_PRSNT_N             ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[34]      = CPU_NVME18_PRSNT_N             ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[33]      = cpu_nvme23_prsnt_n             ;//CPU1 D0 
assign scpld_to_mcpld_p2s_data[32]      = CPU_NVME22_PRSNT_N             ;//CPU1 D0
assign scpld_to_mcpld_p2s_data[31]      = cpu_nvme7_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[30]      = cpu_nvme6_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[29]      = cpu_nvme5_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[28]      = cpu_nvme4_prsnt_n              ;//CPU0 D3
assign scpld_to_mcpld_p2s_data[27]      = cpu_nvme3_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[26]      = cpu_nvme2_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[25]      = cpu_nvme1_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[24]      = cpu_nvme0_prsnt_n              ;//CPU0 D2
assign scpld_to_mcpld_p2s_data[23]      = CPU_NVME9_PRSNT_N              ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[22]      = CPU_NVME8_PRSNT_N              ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[21]      = cpu_nvme25_prsnt_n             ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[20]      = cpu_nvme24_prsnt_n             ;//CPU0 D1
assign scpld_to_mcpld_p2s_data[19]      = ocp_prsent_b7_n                ;
assign scpld_to_mcpld_p2s_data[18]      = ocp_prsent_b6_n                ;
assign scpld_to_mcpld_p2s_data[17]      = ocp_prsent_b5_n                ;
assign scpld_to_mcpld_p2s_data[16]      = ocp_prsent_b4_n                ;
assign scpld_to_mcpld_p2s_data[15]      = ocp_prsent_b3_n                ;
assign scpld_to_mcpld_p2s_data[14]      = ocp_prsent_b2_n                ;
assign scpld_to_mcpld_p2s_data[13]      = ocp_prsent_b1_n                ;
assign scpld_to_mcpld_p2s_data[12]      = ocp_prsent_b0_n                ;
assign scpld_to_mcpld_p2s_data[11]      = fan8_install_n                 ;
assign scpld_to_mcpld_p2s_data[10]      = fan7_install_n                 ;
assign scpld_to_mcpld_p2s_data[9]       = fan6_install_n                 ;
assign scpld_to_mcpld_p2s_data[8]       = fan5_install_n                 ;
assign scpld_to_mcpld_p2s_data[7]       = fan4_install_n                 ;
assign scpld_to_mcpld_p2s_data[6]       = fan3_install_n                 ;
assign scpld_to_mcpld_p2s_data[5]       = fan2_install_n                 ;
assign scpld_to_mcpld_p2s_data[4]       = fan1_install_n                 ;
assign scpld_to_mcpld_p2s_data[3]       = 1'b0                           ; 
assign scpld_to_mcpld_p2s_data[2]       = 1'b1                           ;
assign scpld_to_mcpld_p2s_data[1]       = 1'b0                           ; 
assign scpld_to_mcpld_p2s_data[0]       = 1'b1                           ;
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [255:0]                            mbcpld_to_bmccpld_p2s_data      ;
wire [255:0]                            bmccpld_to_mbcpld_s2p_data      ;
wire                                    cpld_sgpio_ld_n                 ;
wire                                    cpld_sgpio_clk                  ;

// CMU CPLD ---> MB CPLD
s2p_master #(.NBIT(256)) inst_cmu_to_mb_s2p(
    .clk        (clk_50m					    ),
    .warm_rst   (~pon_reset_n                   ),
    .cold_rst   (~pon_reset_n	                ),
    .tick       (t1us_tick		                ),
    .si         (i_PAL_BMC_SS_DATA_IN		    ),//SGPIO_MISO  Serial Signal input
    .po         (bmccpld_to_mbcpld_s2p_data     ),//Parallel Signal output
    .sld_n      (cpld_sgpio_ld_n		        ),//SGPIO_LOAD
    .sclk       (cpld_sgpio_clk 			    ) //SGPIO_CLK
);

assign o_PAL_BMC_SS_LOAD_N = cpld_sgpio_ld_n    ; //SGPIO_LOAD
assign o_PAL_BMC_SS_CLK    = cpld_sgpio_clk     ; //SGPIO_CLK

// MB CPLD  ---> CMU CPLD
p2s_slave #(.NBIT(256)) inst_mb_to_cmu_p2s(
    .clk        (clk_50m					    ),
    .rst        (~pon_reset_n				    ),
    .pi         (mbcpld_to_bmccpld_p2s_data	    ),//Parallel Signal input
    .so         (o_PAL_BMC_SS_DATA_OUT 		    ),//SGPIO_MISO Serial Signal output
    .sld_n      (cpld_sgpio_ld_n		        ),//SGPIO_LOAD
    .sclk       (cpld_sgpio_clk		            ) //SGPIO_CLK
);

// CMU CPLD ---> MB CPLD
assign i_bmc_hang_flag			         = bmccpld_to_mbcpld_s2p_data[67]   ;
assign i_pal_vga_rear_vcc_oc_n	         = bmccpld_to_mbcpld_s2p_data[66]   ;
assign board_id		                     = bmccpld_to_mbcpld_s2p_data[65:62];
assign pcb_version	                     = bmccpld_to_mbcpld_s2p_data[61:59];
assign i_pal_usb_rear_up_oc_n	         = bmccpld_to_mbcpld_s2p_data[58]   ;
assign i_pal_usb_rear_down_oc_n			 = bmccpld_to_mbcpld_s2p_data[57]   ;
assign i_vr_i2c_bmc_sel		             = bmccpld_to_mbcpld_s2p_data[56]   ;
assign i_vr_i2c_bmc_oe_n		         = bmccpld_to_mbcpld_s2p_data[55]   ;
assign i_peci_master_sel	             = bmccpld_to_mbcpld_s2p_data[54]   ;
assign i_pal_program_n		             = bmccpld_to_mbcpld_s2p_data[53]   ;
assign i_pal_bmc_tmp_alert_n		     = bmccpld_to_mbcpld_s2p_data[52]   ;
assign i_pal_bmc_rst_ind_n		         = bmccpld_to_mbcpld_s2p_data[51]   ;
assign i_pal_ifist_prsnt_n	             = bmccpld_to_mbcpld_s2p_data[50]   ;
assign i_pal_health_fan_ctrl		     = bmccpld_to_mbcpld_s2p_data[49]   ;
assign reserve_port1		             = bmccpld_to_mbcpld_s2p_data[48]   ;
assign db_i_pal_pgd_p3v3		         = bmccpld_to_mbcpld_s2p_data[47]   ;
assign db_i_pal_pgd_p1v8		         = bmccpld_to_mbcpld_s2p_data[46]   ;
assign db_i_pal_pgd_p1v2	             = bmccpld_to_mbcpld_s2p_data[45]   ;
assign db_i_pal_pgd_p1v1		         = bmccpld_to_mbcpld_s2p_data[44]   ;
assign db_i_pal_pgd_p0v8		         = bmccpld_to_mbcpld_s2p_data[43]   ;
assign i_pal_wdt_rst_n_r		         = bmccpld_to_mbcpld_s2p_data[42]   ;
assign cpld_date_mmdd	                 = bmccpld_to_mbcpld_s2p_data[41:26];
assign nc_port		                     = bmccpld_to_mbcpld_s2p_data[25]   ;
assign reserve_port                      = bmccpld_to_mbcpld_s2p_data[24:21];
assign lattice_cpld	 	                 = bmccpld_to_mbcpld_s2p_data[20:17];//Cpld Manufacturer
assign bmc_cpld_version 	             = bmccpld_to_mbcpld_s2p_data[16:1] ;
assign t4hz_clk_cmu	 	                 = bmccpld_to_mbcpld_s2p_data[0]    ;

//MB CPLD ---> CMU CPLD
assign mbcpld_to_bmccpld_p2s_data[27] 	 = rst_i2c0_mux_n                   ;
assign mbcpld_to_bmccpld_p2s_data[26] 	 = 1'b1                             ;//remote_xdp_pod_prsnt_n
assign mbcpld_to_bmccpld_p2s_data[25] 	 = 1'b1                             ;//pal_usb2_ocpdbg_oc_n_r
assign mbcpld_to_bmccpld_p2s_data[24] 	 = 1'b1                             ;//en_p3v3_stby_emmc 	            
assign mbcpld_to_bmccpld_p2s_data[23] 	 = 1'b0                             ;//pal_p5v_vga_rear_en_r	        
assign mbcpld_to_bmccpld_p2s_data[22]    = usb_en[2]                        ;//pal_p5v_usb_rear_up_en_r         
assign mbcpld_to_bmccpld_p2s_data[21]    = usb_en[3]                        ;//pal_p5v_usb_rear_down_en_r
assign mbcpld_to_bmccpld_p2s_data[20]    = ~rom_bmc_bk_rst                  ;
assign mbcpld_to_bmccpld_p2s_data[19]	 = ~rom_bmc_ma_rst                  ;
assign mbcpld_to_bmccpld_p2s_data[18]    = pal_pwrgd_cpu0_lvc3_r            ;
assign mbcpld_to_bmccpld_p2s_data[17]    = 1'b1                             ;//pal_bmc_uboot_en_n_r             
assign mbcpld_to_bmccpld_p2s_data[16]    = leakage_det_do_n                 ;
assign mbcpld_to_bmccpld_p2s_data[15]    = 1'b1                             ;//pal_plt_bmc_thermtrip_n_r        
assign mbcpld_to_bmccpld_p2s_data[14]    = st_steady_pwrok                  ;//remote_xdp_syspwrok_r            
assign mbcpld_to_bmccpld_p2s_data[13:12] = uart_mux_select                  ;//weihe
assign mbcpld_to_bmccpld_p2s_data[11:4]  = sw                               ;
assign mbcpld_to_bmccpld_p2s_data[3]     = DSD_UART_PRSNT_N                 ; 
assign mbcpld_to_bmccpld_p2s_data[2]     = rst_pal_extrst_r_n               ;
assign mbcpld_to_bmccpld_p2s_data[1]     = pal_vga_sel_n                    ;
assign mbcpld_to_bmccpld_p2s_data[0]     = t4hz_clk                         ;
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 主板 CPLD SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: RISER1 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [5:0]                          mb1_pvti_ss_count                       ;
wire [4:0]                          riser1_pvti_ss_count                    ;
wire [7:0]                          riser1_pvti_byte3                       ;
wire [7:0]                          riser1_pvti_byte2                       ;
wire [7:0]                          riser1_pvti_byte1                       ;
wire [7:0]                          riser1_pvti_byte0                       ;

wire                                riser1_cb_prsnt_slot1_n                 ;
wire                                riser1_cb_prsnt_slot2_n                 ;
wire                                riser1_cb_prsnt_slot3_n                 ;
wire                                riser1_pwr_det0                         ;
wire                                riser1_pwr_det1                         ;
wire                                riser1_pcb_rev0                         ;
wire                                riser1_pcb_rev1                         ;
wire                                riser1_pwr_alert_n                      ;
wire                                riser1_emc_alert_n                      ;
wire                                riser1_slot1_prsnt_n                    ;
wire                                riser1_slot2_prsnt_n                    ;
wire                                riser1_slot3_prsnt_n                    ;
wire [5:0]                          riser1_id                               ;
wire                                pal_riser1_pwrgd                        ;
wire                                pal_riser1_pe_wake_n                    ;

pvt_gpi #(
    .TOTAL_BIT_COUNT                (32                                     ),
    .DEFAULT_STATE                  (32'hFF_F3_FF_01                        ),             
    .NUMBER_OF_COUNTER_BITS         (5                                      )
) pvt_gpi_riser1_inst (
    .clk                            (clk_50m),
    .reset_n                        (pon_reset_n & (~i_PAL_RISER1_PRSNT_N)  ),
    .clk_ena                        (t16us_tick                             ),
    .serclk_in                      (i_PAL_RISER1_SS_CLK                    ),
    .par_load_in_n                  (i_PAL_RISER1_SS_LD_N                   ),
    .sdi                            (i_PAL_RISER1_SS_DATA_IN                ),
    .bit_idx_in                     (riser1_pvti_ss_count                   ),
    .bit_idx_out                    (riser1_pvti_ss_count                   ),
    .serclk_out                     (i_PAL_RISER1_SS_CLK                    ),
    .par_load_out_n                 (i_PAL_RISER1_SS_LD_N                   ),
    .par_data                       ({riser1_pvti_byte3[7:0],riser1_pvti_byte2[7:0],riser1_pvti_byte1[7:0],riser1_pvti_byte0[7:0]})   			
);

assign riser1_cb_prsnt_slot1_n     = riser1_pvti_byte3[7];
assign riser1_cb_prsnt_slot2_n     = riser1_pvti_byte3[6];
assign riser1_cb_prsnt_slot3_n     = riser1_pvti_byte3[5];

assign riser1_pwr_det0             = riser1_pvti_byte2[5];
assign riser1_pwr_det1             = riser1_pvti_byte2[4];
assign riser1_pcb_rev0             = riser1_pvti_byte2[3];
assign riser1_pcb_rev1             = riser1_pvti_byte2[2];
assign riser1_pwr_alert_n          = riser1_pvti_byte2[1];
assign riser1_emc_alert_n          = riser1_pvti_byte2[0];

assign riser1_slot1_prsnt_n        = riser1_pvti_byte1[7];
assign riser1_slot2_prsnt_n        = riser1_pvti_byte1[6];
assign riser1_slot3_prsnt_n        = riser1_pvti_byte1[5];

assign riser1_id[0]                = riser1_pvti_byte0[7];
assign riser1_id[1]                = riser1_pvti_byte0[6];
assign riser1_id[2]                = riser1_pvti_byte0[5];
assign riser1_id[3]                = riser1_pvti_byte0[4];
assign riser1_id[4]                = riser1_pvti_byte0[3];
assign riser1_id[5]                = riser1_pvti_byte0[2];
assign pal_riser1_pwrgd            = riser1_pvti_byte0[1];
assign pal_riser1_pe_wake_n        = riser1_pvti_byte0[0];
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: RISER1 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: RISER2 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [5:0]                          mb2_pvti_ss_count                       ;
wire [4:0]                          riser2_pvti_ss_count                    ;
wire [7:0]                          riser2_pvti_byte3                       ;
wire [7:0]                          riser2_pvti_byte2                       ;
wire [7:0]                          riser2_pvti_byte1                       ;
wire [7:0]                          riser2_pvti_byte0                       ;

wire                                riser2_cb_prsnt_slot1_n                 ;
wire                                riser2_cb_prsnt_slot2_n                 ;
wire                                riser2_cb_prsnt_slot3_n                 ;
wire                                riser2_pwr_det0                         ;
wire                                riser2_pwr_det1                         ;
wire                                riser2_pcb_rev0                         ;
wire                                riser2_pcb_rev1                         ;
wire                                riser2_pwr_alert_n                      ;
wire                                riser2_emc_alert_n                      ;
wire                                riser2_slot1_prsnt_n                    ;
wire                                riser2_slot2_prsnt_n                    ;
wire                                riser2_slot3_prsnt_n                    ;
wire [5:0]                          riser2_id                               ;
wire                                pal_riser2_pwrgd                        ;
wire                                pal_riser2_pe_wake_n                    ;

pvt_gpi #(
  .TOTAL_BIT_COUNT                  (32                                     ),
  .DEFAULT_STATE                    (32'hFF_F3_FF_01                        ), //32'hFF_F3_FF_01            
  .NUMBER_OF_COUNTER_BITS           (5                                      )
) pvt_gpi_riser2_inst (
  .clk                              (clk_50m                                ),
  .reset_n                          (pon_reset_n & (~i_PAL_RISER2_PRSNT_N)  ),
  .clk_ena                          (t16us_tick                             ),
  .serclk_in                        (i_PAL_RISER2_SS_CLK                    ),
  .par_load_in_n                    (i_PAL_RISER2_SS_LD_N                   ),
  .sdi                              (i_PAL_RISER2_SS_DATA_IN                ),
  .bit_idx_in                       (riser2_pvti_ss_count                   ),
  .bit_idx_out                      (riser2_pvti_ss_count                   ),
  .serclk_out                       (i_PAL_RISER2_SS_CLK                    ),
  .par_load_out_n                   (i_PAL_RISER2_SS_LD_N                   ),
  .par_data                         ({riser2_pvti_byte3[7:0],riser2_pvti_byte2[7:0],riser2_pvti_byte1[7:0],riser2_pvti_byte0[7:0]})	               		
);

assign riser2_cb_prsnt_slot1_n     = riser2_pvti_byte3[7];
assign riser2_cb_prsnt_slot2_n     = riser2_pvti_byte3[6];
assign riser2_cb_prsnt_slot3_n     = riser2_pvti_byte3[5];

assign riser2_pwr_det0             = riser2_pvti_byte2[5];
assign riser2_pwr_det1             = riser2_pvti_byte2[4];
assign riser2_pcb_rev0             = riser2_pvti_byte2[3];
assign riser2_pcb_rev1             = riser2_pvti_byte2[2];
assign riser2_pwr_alert_n          = riser2_pvti_byte2[1];
assign riser2_emc_alert_n          = riser2_pvti_byte2[0];

assign riser2_slot1_prsnt_n        = riser2_pvti_byte1[7];
assign riser2_slot2_prsnt_n        = riser2_pvti_byte1[6];
assign riser2_slot3_prsnt_n        = riser2_pvti_byte1[5];

assign riser2_id[0]                = riser2_pvti_byte0[7];
assign riser2_id[1]                = riser2_pvti_byte0[6];
assign riser2_id[2]                = riser2_pvti_byte0[5];
assign riser2_id[3]                = riser2_pvti_byte0[4];
assign riser2_id[4]                = riser2_pvti_byte0[3];
assign riser2_id[5]                = riser2_pvti_byte0[2];
assign pal_riser2_pwrgd            = riser2_pvti_byte0[1];
assign pal_riser2_pe_wake_n        = riser2_pvti_byte0[0];
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: RISER2 SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: main board SGPIO 模块 (接口保留，数据暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [5:0]                          mb1_pvti_ss_count                       ;

wire                                cpu_nvme0_prsnt_n                       ;
wire                                cpu_nvme1_prsnt_n                       ;
wire                                cpu_nvme2_prsnt_n                       ;
wire                                cpu_nvme3_prsnt_n                       ;
wire                                cpu_nvme4_prsnt_n                       ;
wire                                cpu_nvme5_prsnt_n                       ;
wire                                cpu_nvme6_prsnt_n                       ;
wire                                cpu_nvme7_prsnt_n                       ;
wire                                cpu_nvme10_prsnt_n                      ;
wire                                cpu_nvme11_prsnt_n                      ;
wire                                cpu_nvme12_prsnt_n                      ;
wire                                cpu_nvme13_prsnt_n                      ;
wire                                cpu_nvme14_prsnt_n                      ;
wire                                cpu_nvme15_prsnt_n                      ;
wire                                cpu_nvme16_prsnt_n                      ;
wire                                cpu_nvme17_prsnt_n                      ;

wire                                cpu0_mcio0_cable_id0                    ;
wire                                cpu0_mcio0_cable_id1                    ;
wire                                cpu0_mcio1_cable_id0                    ;
wire                                cpu0_mcio1_cable_id1                    ;
wire                                cpu0_mcio2_cable_id0                    ;
wire                                cpu0_mcio2_cable_id1                    ;
wire                                cpu0_mcio3_cable_id0                    ;
wire                                cpu0_mcio3_cable_id1                    ;
wire                                cpu0_mcio4_cable_id0                    ;
wire                                cpu0_mcio4_cable_id1                    ;
wire                                cpu0_mcio5_cable_id0                    ;
wire                                cpu0_mcio5_cable_id1                    ;
wire                                cpu1_mcio0_cable_id0                    ;
wire                                cpu1_mcio0_cable_id1                    ;
wire                                cpu1_mcio1_cable_id0                    ;
wire                                cpu1_mcio2_cable_id0                    ;
wire                                cpu1_mcio2_cable_id1                    ;
wire                                cpu1_mcio3_cable_id0                    ;
wire                                cpu1_mcio3_cable_id1                    ;
wire                                cpu1_mcio4_cable_id0                    ;
wire                                cpu1_mcio4_cable_id1                    ;
wire                                cpu1_mcio6_cable_id0                    ;
wire                                cpu1_mcio1_cable_id1                    ;
wire                                cpu1_mcio6_cable_id1                    ;

wire                                pal_bp1_prsnt_n                         ;
wire                                pal_bp2_prsnt_n                         ;
wire                                pal_bp3_prsnt_n                         ;
wire                                pal_bp4_prsnt_n                         ;
wire                                pal_bp5_prsnt_n                         ;
wire                                pal_bp6_prsnt_n                         ;
wire                                pal_bp7_prsnt_n                         ;
wire                                pal_bp8_prsnt_n                         ;

pvt_gpi #(
	.TOTAL_BIT_COUNT                (48                                     ),
	.DEFAULT_STATE                  (48'h0                                  ),
	.NUMBER_OF_COUNTER_BITS         (6                                      )
) pvt_gpi_mb1_inst (
	.clk                            (clk_50m                                ),
	.reset_n                        (pon_reset_n                            ),
	.clk_ena                        (t16us_tick                             ),
	.serclk_in                      (i_PVT_SS_CLK_R                         ),
	.par_load_in_n                  (i_PVT_SS_LD_N_R                        ),
	.sdi                            (i_PVT_SS_DATI                          ),
	.bit_idx_in                     (mb1_pvti_ss_count                      ),
	.bit_idx_out                    (mb1_pvti_ss_count                      ),
	.serclk_out                     (i_PVT_SS_CLK_R                         ),
	.par_load_out_n                 (i_PVT_SS_LD_N_R                        ),
	.par_data                       ({cpu_nvme0_prsnt_n ,cpu_nvme1_prsnt_n ,cpu_nvme2_prsnt_n ,cpu_nvme3_prsnt_n ,
	                                  cpu_nvme4_prsnt_n ,cpu_nvme5_prsnt_n ,cpu_nvme6_prsnt_n ,cpu_nvme7_prsnt_n ,          //U10 DATA
					 
					                cpu_nvme10_prsnt_n,cpu_nvme11_prsnt_n,cpu_nvme12_prsnt_n,cpu_nvme13_prsnt_n,
					                cpu_nvme14_prsnt_n,cpu_nvme15_prsnt_n,cpu_nvme16_prsnt_n,cpu_nvme17_prsnt_n,          //U22 DATA
					 
					                cpu0_mcio0_cable_id0,cpu0_mcio0_cable_id1,cpu0_mcio1_cable_id0,cpu0_mcio1_cable_id1,
					                cpu0_mcio2_cable_id0,cpu0_mcio2_cable_id1,cpu0_mcio3_cable_id0,cpu0_mcio3_cable_id1,  //U157 DATA
					 
					                cpu0_mcio4_cable_id0,cpu0_mcio4_cable_id1,cpu0_mcio5_cable_id0,cpu0_mcio5_cable_id1,
					                cpu1_mcio0_cable_id0,cpu1_mcio0_cable_id1,cpu1_mcio1_cable_id0,cpu1_mcio1_cable_id1,  //U212 DATA
					 
					                cpu1_mcio2_cable_id0,cpu1_mcio2_cable_id1,cpu1_mcio3_cable_id0,cpu1_mcio3_cable_id1,
					                cpu1_mcio4_cable_id0,cpu1_mcio4_cable_id1,cpu1_mcio6_cable_id0,cpu1_mcio6_cable_id1,  //U213 DATA
					 					 					 
					                pal_bp1_prsnt_n     ,pal_bp2_prsnt_n     ,pal_bp3_prsnt_n     ,pal_bp4_prsnt_n     ,
					                pal_bp5_prsnt_n     ,pal_bp6_prsnt_n     ,pal_bp7_prsnt_n     ,pal_bp8_prsnt_n       //U217 DATA
					                })					 
);

wire [5:0]                          mb2_pvti_ss_count                       ;

wire                                ocp_prsent_b7_n                         ;
wire                                ocp_prsent_b6_n                         ;
wire                                ocp_prsent_b5_n                         ;
wire                                ocp_prsent_b4_n                         ;
wire                                ocp_prsent_b3_n                         ;
wire                                ocp_prsent_b2_n                         ;
wire                                ocp_prsent_b1_n                         ;
wire                                ocp_prsent_b0_n                         ;

wire                                fan8_install_n                          ;
wire                                fan7_install_n                          ;
wire                                fan6_install_n                          ;
wire                                fan5_install_n                          ;
wire                                fan4_install_n                          ;
wire                                fan3_install_n                          ;
wire                                fan2_install_n                          ;
wire                                fan1_install_n                          ;

wire                                pal_gpu_fan4_prsnt                      ;
wire                                pal_gpu_fan3_prsnt                      ;
wire                                pal_gpu_fan2_prsnt                      ;
wire                                pal_gpu_fan1_prsnt                      ;
wire                                pal_gpu_fan4_foo                        ;
wire                                pal_gpu_fan3_foo                        ;
wire                                pal_gpu_fan2_foo                        ;
wire                                pal_gpu_fan1_foo                        ;

wire                                board_id7                               ;
wire                                board_id6                               ;
wire                                board_id5                               ;
wire                                board_id4                               ;
wire                                board_id3                               ;
wire                                board_id2                               ;
wire                                board_id1                               ;
wire                                board_id0                               ;

wire                                pca_revision_2                          ;
wire                                pca_revision_1                          ;
wire                                pca_revision_0                          ;
wire                                pcb_revision_1                          ;
wire                                pcb_revision_0                          ;
wire                                cpu_nvme25_prsnt_n                      ;
wire                                cpu_nvme24_prsnt_n                      ;
wire                                cpu_nvme23_prsnt_n                      ;

pvt_gpi #(
	.TOTAL_BIT_COUNT                (48                                     ),
	.DEFAULT_STATE                  (48'h0                                  ),
	.NUMBER_OF_COUNTER_BITS         (6                                      )
) pvt_gpi_mb2_inst (
	.clk                            (clk_50m                                ),
	.reset_n                        (pon_reset_n                            ),
	.clk_ena                        (t16us_tick                             ),
	.serclk_in                      (i_PVT_SS_CLK_1_R                       ),
	.par_load_in_n                  (i_PVT_SS_LD_N_1_R                      ),
	.sdi                            (i_PVT_SS_DATI_1                        ),
	.bit_idx_in                     (mb2_pvti_ss_count                      ),
	.bit_idx_out                    (mb2_pvti_ss_count                      ),
	.serclk_out                     (i_PVT_SS_CLK_1_R                       ),
	.par_load_out_n                 (i_PVT_SS_LD_N_1_R                      ),
	.par_data                       ({sw[0]           ,sw[1]           ,sw[2]           ,sw[3]           ,
	                                  sw[4]           ,sw[5]           ,sw[6]           ,sw[7]           ,  //U180 DATA
					 			 
					                ocp_prsent_b7_n ,ocp_prsent_b6_n ,ocp_prsent_b5_n ,ocp_prsent_b4_n ,
					                ocp_prsent_b3_n ,ocp_prsent_b2_n ,ocp_prsent_b1_n ,ocp_prsent_b0_n,    //U181 DATA	

                                    fan8_install_n,fan7_install_n,fan6_install_n,fan5_install_n,
					                fan4_install_n,fan3_install_n,fan2_install_n,fan1_install_n,          //U275 DATA
					 
					                pal_gpu_fan4_prsnt,pal_gpu_fan3_prsnt,pal_gpu_fan2_prsnt,pal_gpu_fan1_prsnt,
					                pal_gpu_fan4_foo,pal_gpu_fan3_foo,pal_gpu_fan2_foo,pal_gpu_fan1_foo,  //U276 DATA
					 
					                board_id7,board_id6,board_id5,board_id4,
					                board_id3,board_id2,board_id1,board_id0,                              //U277 DATA
					 					 					 
					                pca_revision_2,pca_revision_1,pca_revision_0,pcb_revision_1,
					                pcb_revision_0,cpu_nvme25_prsnt_n,cpu_nvme24_prsnt_n,cpu_nvme23_prsnt_n //U278 DATA                 				     
				                    })					 
);  
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: main board SGPIO 模块
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: OCP1 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [5:0]                          ocp1_pvti_ss_count                      ;
wire [7:0]                          ocp1_pvti_byte3                         ;
wire [7:0]                          ocp1_pvti_byte2                         ;
wire [7:0]                          ocp1_pvti_byte1                         ;
wire [7:0]                          ocp1_pvti_byte0                         ;

assign ocp1_prsnt_n = ocp_prsent_b3_n & ocp_prsent_b2_n & ocp_prsent_b1_n & ocp_prsent_b0_n;

pvt_gpi #(
    .TOTAL_BIT_COUNT                (32                                     ),
    .DEFAULT_STATE                  (32'h7FFF_FFFE                          ),
    .NUMBER_OF_COUNTER_BITS         (6                                      )
) pvt_gpi_ocp1_inst (
    .clk                            (clk_50m                                ),
    .reset_n                        (pon_reset_n & (~ocp1_prsnt_n)          ),
    .clk_ena                        (t16us_tick                             ),
    .serclk_in                      (i_PAL_OCP1_SS_CLK_R                    ),
    .par_load_in_n                  (i_PAL_OCP1_SS_LD_N_R                   ),
    .sdi                            (i_PAL_OCP1_SS_DATA_IN_R                ),
    .bit_idx_in                     (ocp1_pvti_ss_count                     ),
    .bit_idx_out                    (ocp1_pvti_ss_count                     ),
    .serclk_out                     (i_PAL_OCP1_SS_CLK_R                    ),
    .par_load_out_n                 (i_PAL_OCP1_SS_LD_N_R                   ),
    .par_data                       ({ocp1_pvti_byte3[7:0], ocp1_pvti_byte2[7:0],ocp1_pvti_byte1[7:0], ocp1_pvti_byte0[7:0]})
);

/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: OCP1 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: OCP2 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [5:0]                          ocp2_pvti_ss_count                      ;
wire [7:0]                          ocp2_pvti_byte3                         ;
wire [7:0]                          ocp2_pvti_byte2                         ;
wire [7:0]                          ocp2_pvti_byte1                         ;
wire [7:0]                          ocp2_pvti_byte0                         ;

assign ocp2_prsnt_n = ocp_prsent_b4_n & ocp_prsent_b5_n & ocp_prsent_b6_n & ocp_prsent_b7_n;

pvt_gpi #(
    .TOTAL_BIT_COUNT                (32                                     ),
    .DEFAULT_STATE                  (32'h7FFF_FFFE                          ),
    .NUMBER_OF_COUNTER_BITS         (6                                      )
) pvt_gpi_ocp2_inst (
    .clk                            (clk_50m                                ),
    .reset_n                        (pon_reset_n & (~ocp2_prsnt_n)          ),
    .clk_ena                        (t16us_tick                             ),
    .serclk_in                      (i_PAL_OCP2_SS_CLK_R                    ),
    .par_load_in_n                  (i_PAL_OCP2_SS_LD_N_R                   ),
    .sdi                            (i_PAL_OCP2_SS_DATA_IN_R                ),
    .bit_idx_in                     (ocp2_pvti_ss_count                     ),
    .bit_idx_out                    (ocp2_pvti_ss_count                     ),
    .serclk_out                     (i_PAL_OCP2_SS_CLK_R                    ),
    .par_load_out_n                 (i_PAL_OCP2_SS_LD_N_R                   ),
    .par_data                       ({ocp2_pvti_byte3[7:0], ocp2_pvti_byte2[7:0],ocp2_pvti_byte1[7:0], ocp2_pvti_byte0[7:0]})
);

assign w_pal_ocp1_prsnt_n = {ocp_prsent_b3_n,ocp_prsent_b2_n,ocp_prsent_b1_n,ocp_prsent_b0_n};
assign w_ocp1_x16_prsnt   = ((w_pal_ocp1_prsnt_n == 4'b0100)|(w_pal_ocp1_prsnt_n == 4'b0101)|(w_pal_ocp1_prsnt_n == 4'b0111)|(w_pal_ocp1_prsnt_n == 4'b1100)) ? 1'b1 : 1'b0;
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: OCP2 SGPIO 模块 (暂不使用)
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: I2C Update 模块, 此IP核使用紫光的替换
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                wb_clk                                  ;
defparam                            inst_osch.NOM_FREQ = "4.29"             ;
OSCH inst_osch(
    .STDBY		                    (1'b0		                            ),
    .OSC		                    (wb_clk		                            ),
    .SEDSTDBY	                    (			                            )
);
I2C_UPDATE inst_i2c_update_flash_config(
    .wb_clk_i	                    (wb_clk	                                ),
    .wb_rst_i	                    (		                                ),
    .wb_cyc_i	                    (		                                ),
    .wb_stb_i	                    (		                                ),
    .wb_we_i	                    (		                                ),
    .wb_adr_i	                    (		                                ),
    .wb_dat_i	                    (		                                ),
    .wb_dat_o	                    (		                                ),
    .wb_ack_o	                    (		                                ),
    .i2c1_irqo	                    (						                ),
    .i2c1_scl	                    (BMC_I2C3_PAL_S_SCL_R	                ),
    .i2c1_sda	                    (BMC_I2C3_PAL_S_SDA_R                   )
); 
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: I2C Update 模块, 此IP核使用紫光的替换
------------------------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: 未使用模块
------------------------------------------------------------------------------------------------------------------------------------------------*/
wire                                 w_bmc_active1_n                        ;

FanControl #(
    .FANNUMBER                      (1                                      ),
    .TIME_OUT0                      (240                                    ),// common is 240s
    .TIME_OUT1                      (10                                     )  // common is 10s
) FanControl_m (
    .i_clk                          (clk_50m                                ),//50MHz
    .i_rst_n                        (pon_reset_n                            ),
    .i_1uSCE                        (t1us_tick                              ),
    .i_1000mSCE                     (t1s_tick                               ),                  
    .i_heartbeat                    (i_pal_wdt_rst_n_r                      ),
    .i_max_speed_ctrl               (8'd60                                  ),//can be decimal 60/65/70/75/80/85/90/95/100
    .i_low_speed_pwr_on             (8'd10                                  ),//can be decimal 10/15/20/25/30/35/40/45/50/55/60
    .i_fan_en_when_s5               (1'b1                                   ),      
    .i_bmc_ctrl_when_s5             (1'b1                                   ),      
    .i_pwr_on_st                    (1'b1                                   ),      
    .i_fan_speed_when_s5            (8'd10                                  ),//can be decimal 10/15/20/25/30/35/40/45/50/55/60
    .i_rst_bmc_n                    (1'b1                                   ),      
    .o_bmc_active0_n                (                                       ),//defaulte 0; bmc die:1; bmc actiev:0 ; related TIME_OUT0 
    .o_bmc_active0_rst_n            (                                       ),//defaulte 0; bmc die:1; bmc actiev:0 ; related TIME_OUT0 ; can be reset by i_rst_bmc_n
    .o_wdt_override_pld_sel         (                                       ),//defaulte 0; bmc die:0; bmc actiev:1 ; related TIME_OUT1 
    .o_bmc_active1_n                (w_bmc_active1_n                        ),//defaulte 1; bmc die:1; bmc actiev:0 ; related TIME_OUT1 
    .i_BMC_pwm                      (1'b1                                   ),
    .o_CPLD_pwm                     (                                       )
);

assign bmc_ready_flag = ~w_bmc_active1_n;
/*-----------------------------------------------------------------------------------------------------------------------------------------------
end: 未使用模块
------------------------------------------------------------------------------------------------------------------------------------------------*/






/*-----------------------------------------------------------------------------------------------------------------------------------------------
begin: MB CPLD <--> BP CPLD 信号交互
------------------------------------------------------------------------------------------------------------------------------------------------*/
// PE WAKE（CPU唤醒使用）
assign pfr_pe_wake_n = pal_pe_wake_n; //& PAL_RISER1_WAKE_N_R ;

// VGA
assign pal_vga_sel_n = vga2_dis ? 1'b1 : (db_front_vga_cable_prsnt_n);

// USB
assign o_PAL_UPD1_PERST_N_R   = reached_sm_wait_powerok ;
assign o_PAL_UPD2_PERST_N_R   = reached_sm_wait_powerok ;
assign o_PAL_UPD1_PONRST_N_R  = usb_ponrst_r_n          ;
assign o_PAL_UPD2_PONRST_N_R  = usb_ponrst_r_n          ;
assign o_CPLD_M_S_EXCHANGE_S2 = i_PAL_PWR_SW_IN_N       ; 

//OCPm LOM
//assign lom_thermal_trip     = ~db_i_lom_prsnt_n ? db_i_lom_fan_on_aux : 1'b0;//1:thermal trip;0:normal

//NCSI 
assign o_PAL_OCP1_NCSI_EN_N_R   = ~pal_ocp1_ncsi_en  ; //J69
assign o_PAL_OCP2_NCSI_EN_N_R   = ~pal_ocp2_ncsi_en  ; //J3 
assign o_PAL_OCP_NCSI_SW_EN_N_R = ~pal_ocp_ncsi_sw_en; //J53 

// LED
assign o_LED1_N                 = ~power_seq_sm[0]   ;
assign o_LED2_N                 = ~power_seq_sm[1]   ;
assign o_LED3_N                 = ~power_seq_sm[2]   ;
assign o_LED4_N                 = ~power_seq_sm[3]   ;
assign o_LED5_N                 = ~power_seq_sm[4]   ;
assign o_LED6_N                 = ~power_seq_sm[5]   ;
assign o_LED7_N                 = bmc_extrst_uid     ;
assign o_LED8_N                 = t4hz_clk_cmu       ;  

assign o_PAL_LED_HEL_GR_R   = sys_hlth_grn_blink_n       ;
assign o_PAL_LED_HEL_RED_R  = sys_hlth_red_blink_n       ;
assign o_PAL_LED_NIC_ACT_R  = pal_led_nic_act            ;

// UART 
assign o_CPU1_D0_UART_SIN       = i_JACK_CPU1_D0_UART_SIN;
assign o_JACK_CPU1_D0_UART_SOUT = i_CPU1_D0_UART_SOUT    ;

assign o_JACK_CPU1_UART1_TX     = i_CPU1_D0_UART1_TX     ;
assign o_CPU1_D0_UART1_RX       = i_JACK_CPU1_UART1_RX   ;

assign o_JACK_CPU0_D0_UART_SOUT   = i_CPU0_D0_UART_SOUT    ;
assign o_CPU0_D0_UART_SIN         = i_JACK_CPU0_D0_UART_SIN;