// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


(* tile_ip_hip *)
module eth_f_hip_23upnva 
  #(
    parameter          num_aib                                                  = 1,
    parameter          num_xcvr                                                 = 1,
    parameter          num_ports                                                = 1,
    parameter          bb_f_ehip_aib2_rx_st_clk_en                              = "AIB2_RX_ST_CLK_EN_PLL0_DIV2", 
    parameter          bb_f_ehip_aib2_tx_st_clk_en                              = "AIB2_TX_ST_CLK_EN_PLL0_DIV2", 
    parameter          bb_f_ehip_aib3_rx_st_clk_en                              = "AIB3_RX_ST_CLK_EN_RX_USER_CLK1",
    parameter          bb_f_ehip_aib3_tx_st_clk_en                              = "AIB3_TX_ST_CLK_EN_TX_USER_CLK1",
    parameter          bb_f_ehip_aibif_data_valid                               = "AIBIF_DATA_VALID_25G", 
    parameter          bb_f_ehip_dl_enable                                      = "DISABLE", // PTP parameters
    parameter          bb_f_ehip_e400g_ptp0_aib2_div2_clk                       = "__BB_DONT_CARE__", // PTP parameters
    parameter          bb_f_ehip_e400g_ptp1_aib2_div2_clk                       = "__BB_DONT_CARE__", // PTP parameters
    parameter          bb_f_ehip_duplex_mode                                    = "DUPLEX_MODE_FULL_DUPLEX", 
    parameter          bb_f_ehip_fec_mode                                       = "FEC_MODE_DISABLED", 
    parameter          bb_f_ehip_fec_spec                                       = "FEC_SPEC_DISABLED", 
    parameter          bb_f_ehip_frac_size                                      = "F25G", 
    parameter          bb_f_ehip_fec_clk_src                                    = "FEC_CLK_SRC_PLL0",
    parameter          bb_f_ehip_fec_error                                      = "FEC_ERROR_ON",
    parameter          bb_f_ehip_lpbk_mode                                      = "LPBK_MODE_DISABLED",
    parameter          bb_f_ehip_mac_disable_link_fault_rf                      = "DISABLE",
    parameter          bb_f_ehip_mac_flow_control                               = "MAC_NONE", 
    parameter          bb_f_ehip_mac_flow_control_holdoff_mode                  = "MAC_PER_QUEUE", 
    parameter          bb_f_ehip_mac_force_link_fault_rf                        = "DISABLE",
    parameter          bb_f_ehip_mac_enforce_max_frame_size                     = "DISABLE",
    parameter          bb_f_ehip_mac_forward_rx_pause_requests                  = "ENABLE", 
    parameter  [15:0]  bb_f_ehip_mac_holdoff_quanta                             = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_ipg_removed_per_am_period                  = 16'd8,
    parameter          bb_f_ehip_mac_keep_rx_crc                                = "ENABLE", 
    parameter          bb_f_ehip_mac_link_fault_mode                            = "MAC_LF_OFF", 
    parameter  [15:0]  bb_f_ehip_mac_pause_quanta                               = 16'd65535, 
    parameter          bb_f_ehip_mac_remove_pads                                = "DISABLE", 
    parameter          bb_f_ehip_mac_rx_length_checking                         = "ENABLE", 
    parameter          bb_f_ehip_mac_rx_preamble_passthrough                    = "DISABLE", 
    parameter          bb_f_ehip_mac_rx_vlan_detection                          = "ENABLE", 
    parameter          bb_f_ehip_mac_rxcrc_covers_preamble                      = "DISABLE", 
    parameter          bb_f_ehip_mac_source_address_insertion                   = "DISABLE", 
    parameter          bb_f_ehip_mac_strict_preamble_checking                   = "DISABLE", 
    parameter          bb_f_ehip_mac_strict_sfd_checking                        = "DISABLE", 
    parameter          bb_f_ehip_mac_tx_mac_data_flow                           = "ENABLE", 
    parameter          bb_f_ehip_mac_tx_preamble_passthrough                    = "DISABLE", 
    parameter          bb_f_ehip_mac_tx_vlan_detection                          = "ENABLE", 
    parameter          bb_f_ehip_mac_txcrc_covers_preamble                      = "DISABLE", 
    parameter          bb_f_ehip_mac_mode                                       = "MAC_MODE_IEEE", 
    parameter          bb_f_ehip_pcs_ber_mon_mode                               = "PCS_BER_MON_MODE_25G", 
    parameter          bb_f_ehip_tx_pmadirect_single_width                      = "FALSE", 
    parameter          bb_f_ehip_rx_pmadirect_single_width                      = "FALSE", 
    parameter          bb_f_ehip_ptp_mode                                       = "PTP_MODE_DISABLED",  // PTP parameters
    parameter          bb_f_ehip_mac_tx_ptp_phy_lane_num                        = "__BB_DONT_CARE__",  // PTP parameters
    parameter          bb_f_ehip_mac_rx_ptp_phy_lane_num                        = "__BB_DONT_CARE__",  // PTP parameters
    parameter          bb_f_ehip_rx_aib_if_fifo_mode                            = "RX_AIB_IF_FIFO_MODE_PHASECOMP", 
    parameter          dec_bb_f_ehip_rx_datarate                                = "2500000000", 
    parameter          bb_f_ehip_rx_en                                          = "TRUE", 
    parameter          bb_f_ehip_rx_excvr_gb_ratio_mode                         = "RX_EXCVR_GB_RATIO_MODE_32_33",
    parameter          bb_f_ehip_rx_excvr_if_fifo_mode                          = "RX_EXCVR_IF_FIFO_MODE_ELASTIC",
    parameter          bb_f_ehip_rx_fec_enable                                  = "RX_FEC_ENABLE_DISABLED", 
    parameter          bb_f_ehip_rx_pcs_mode                                    = "RX_PCS_MODE_IEEE", 
    parameter          bb_f_ehip_rx_primary_use                                 = "RX_PRIMARY_USE_ETHERNET", 
    parameter  [4:0]   bb_f_ehip_rx_total_xcvr                                  = 1, 
    parameter          bb_f_ehip_rx_xcvr_width                                  = "RX_XCVR_WIDTH_32", 
    parameter          bb_f_ehip_silicon_rev                                    = "gdra", 
    parameter          bb_f_ehip_speed_map                                      = "SPEED_MAP_MAP_25G", 
    parameter          bb_f_ehip_tx_aib_if_fifo_mode                            = "TX_AIB_IF_FIFO_MODE_PHASECOMP", 
    parameter          dec_bb_f_ehip_tx_datarate                                = "2500000000", 
    parameter          bb_f_ehip_sim_mode                                       = "ENABLE",
    parameter          bb_f_ehip_sup_mode                                       = "SUP_MODE_USER_MODE",
    parameter          bb_f_ehip_sys_clk_src                                    = "SYS_CLK_SRC_PLL0",
    parameter          bb_f_ehip_topology                                       = "UX16E400GPTP_XX_DISABLED_XX_DISABLED",
    parameter          bb_f_ehip_tx_en                                          = "TRUE", 
    parameter          bb_f_ehip_tx_excvr_gb_ratio_mode                         = "TX_EXCVR_GB_RATIO_MODE_32_33",
    parameter          bb_f_ehip_tx_excvr_if_fifo_mode                          = "TX_EXCVR_IF_FIFO_MODE_ELASTIC", 
    parameter          bb_f_ehip_tx_fec_enable                                  = "TX_FEC_ENABLE_DISABLED", 
    parameter          bb_f_ehip_tx_pcs_mode                                    = "TX_PCS_MODE_IEEE", 
    parameter          bb_f_ehip_tx_primary_use                                 = "TX_PRIMARY_USE_ETHERNET", 
    parameter  [4:0]   bb_f_ehip_tx_total_xcvr                                  = 1, 
    parameter          bb_f_ehip_tx_xcvr_width                                  = "TX_XCVR_WIDTH_32", 
    parameter          bb_f_ehip_xcvr_mode                                      = "XCVR_MODE_NRZ",
    parameter          bb_f_ehip_xcvr_type                                      = "XCVR_TYPE_UX",
    parameter          bb_f_ehip_tx_word_clk_hz                                 = 32'd805664062,
    parameter          bb_f_ehip_rx_word_clk_hz                                 = 32'd805664062,
	parameter         bb_f_ehip_mac_use_am_insert 			= "DISABLE",
	parameter         bb_f_ehip_is_ptp_part_of_reconfig 			= "DISABLE",
	parameter         bb_f_ehip_is_fec_part_of_reconfig  			= "DISABLE",
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_0                       = 16'd65535, 
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_1                       = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_2                       = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_3                       = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_4                       = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_5                       = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_6                       = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_holdoff_quanta_7                       = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_0                         = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_1                         = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_2                         = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_3                         = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_4                         = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_5                         = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_6                         = 16'd65535,
    parameter  [15:0]  bb_f_ehip_mac_pfc_pause_quanta_7                         = 16'd65535,
    parameter  [8:0]   bb_f_ehip_mac_request_tx_pause                           = 9'd0,
    parameter  [15:0]  bb_f_ehip_mac_rx_max_frame_size                          = 16'd1518,
    parameter          bb_f_ehip_mac_rx_pause_daddr                             = "1652522221569",
    parameter          bb_f_ehip_mac_tx_ipg_size                                = "MAC_IPG_12",
    parameter  [15:0]  bb_f_ehip_mac_tx_max_frame_size                          = 16'd1518,
    parameter          bb_f_ehip_mac_tx_pause_daddr                             = "1652522221569", 
    parameter          bb_f_ehip_mac_tx_pause_saddr                             = "73588229205", 
    parameter          bb_f_ehip_mac_txmac_saddr                                = "247393538562781", 
    parameter  [15:0]  bb_f_ehip_mac_uniform_holdoff_quanta                     = 16'd1518,
    parameter          bb_f_ehip_fec_802p3ck                                    = "disable",
    parameter  [17:0]  bb_f_ehip_q_dl_cfg_rxbit_rollover_attr                   = 18'd143934,
// PFE_IPSE_SYNC up changes : Commented out parameter (HIGH & MED) TBD
    parameter          bb_f_ehip_mac_rx_ptp_dbg_master_en                       = "DISABLE", 

    parameter         bb_f_ux_cdr_clkdiv_en                                  = "DISABLE"                             ,
    parameter         bb_f_ux_cdr_f_postdiv_hz                               = 36'd390625000                          , 
    parameter         bb_f_ux_cdr_postdiv_counter                            = 33                                    , 
    parameter         bb_f_ux_cdr_postdiv_fractional_en                      = "DISABLE"                             , 
    parameter         bb_f_ux_cdr_ppm_driftcount                             = 1024                                  , 
    parameter         bb_f_ux_master_pll_pair_mode                           = "FALSE"                               , 
    parameter         bb_f_ux_core_pll                                       = "CORE_PLL_DISABLED"                   , 
    parameter         bb_f_ux_dl_enable                                      = "DISABLE"                             , 
    parameter         bb_f_ux_enable_static_refclk_network                   = "FALSE"                               , 
    parameter         bb_f_ux_enable_port_control_of_cdr_ltr_ltd             = "DISABLE"                             ,
    parameter         bb_f_ux_engineered_link_mode                           = "DISABLE"                             , 
  
    parameter         bb_f_ux_flux_mode                                      = "FLUX_MODE_DISABLED"                  , 
    parameter         bb_f_ux_force_cdr_ltd                                  = "DISABLE"                             , 
    parameter         bb_f_ux_force_cdr_ltr                                  = "DISABLE"                             , 
    parameter         bb_f_ux_force_refclk_power_to_specific_value           = "FORCE_REFCLK_POWER_TO_SPECIFIC_VALUE_NONE", 
    parameter         bb_f_ux_full_quad_master_pll_mode                      = "FALSE"                               , 
    parameter         bb_f_ux_loopback_mode                                  = "LOOPBACK_MODE_DISABLED"              , 
    parameter         bb_f_ux_master_sup_mode                                = "MASTER_SUP_MODE_USER_MODE"           , 
    parameter         bb_f_ux_prbs_gen_en                                    = "DISABLE"                             , 
    parameter         bb_f_ux_prbs_mon_en                                    = "DISABLE"                             , 
    parameter         bb_f_ux_q_dl_cfg_rx_lat_bit_for_async_attr             = 0                                     , 
    parameter         bb_f_ux_q_dl_cfg_rxbit_cntr_pma_attr                   = "DISABLE"                             , 
    parameter         bb_f_ux_q_dl_cfg_rxbit_rollover_attr                   = 0                                     , 
    parameter         bb_f_ux_quad_pcie_mode                                 = "FALSE"                               , 
    parameter         bb_f_ux_rx_adapt_mode                                  = "UX0_RX_ADAPT_MODE_NO_EQ"             , 
    parameter         bb_f_ux_rx_bond_size                                   = "RX_BOND_SIZE_DISABLED"               , 
    parameter         dec_bb_f_ux_rx_line_rate_bps                           = "25781250000"                         , 
    parameter         bb_f_ux_rx_over_sample                                 = "__BB_DONT_CARE__"                    , 
    parameter         bb_f_ux_rx_pam4_graycode_en                            = "DISABLE"                             , 
    parameter         bb_f_ux_rx_pam4_precode_en                             = "DISABLE"                             , 
    parameter         bb_f_ux_rx_protocol                                    = "RX_PROTOCOL_FEC_PCS_MAC"             , 
    parameter         bb_f_ux_tx_protocol_hard_pcie_lowloss                  = "DISABLE"                             , 
    parameter         bb_f_ux_rx_protocol_hard_pcie_lowloss                  = "DISABLE"                             , 
    parameter         bb_f_ux_rx_user_clk_en                                 = "ENABLE"                              , 
    parameter         bb_f_ux_rx_width                                       = "RX_WIDTH_32"                         , 
    parameter         bb_f_ux_silicon_rev                                    = "10nm6agdra"                          , 
    parameter         bb_f_ux_squelch_detect                                 = "__BB_DONT_CARE__"                    , 
    parameter         bb_f_ux_sr_custom                                      = "DISABLE"                             , 
    parameter         bb_f_ux_sup_mode                                       = "sup_mode_user_mode"                  , 
    parameter         bb_f_ux_sim_mode                                       = "DISABLE"                  	     , 
 parameter         bb_f_ux_q_10_to_1_ckmux_0_en_attr                         = "CKMUX0_10_TO_1_EN_FALSE"             , 
 parameter         bb_f_ux_q_10_to_1_ckmux_1_en_attr                         = "CKMUX1_10_TO_1_EN_FALSE"	     , 
parameter         bb_f_ux_fec_used                                           = "FALSE"                  	     , 


    parameter         bb_f_ux_synth_lc_fast_f_rx_postdiv_hz                  = 0                                     , 
    parameter         bb_f_ux_synth_lc_fast_f_tx_postdiv_hz                  = 390625000                             , 
    parameter         bb_f_ux_synth_lc_fast_rx_postdiv_counter               = 12                                    , 
    parameter         bb_f_ux_synth_lc_fast_tx_postdiv_counter               = 14                                    , 
    parameter         bb_f_ux_synth_lc_fast_tx_postdiv_fractional_en         = "DISABLE"                             , 
    parameter         bb_f_ux_synth_lc_med_f_rx_postdiv_hz                   = 0                                     , 
    parameter         bb_f_ux_synth_lc_med_f_tx_postdiv_hz                   = 0                                     , 
    parameter         bb_f_ux_synth_lc_med_rx_postdiv_counter                = 0                                     , 
    parameter         bb_f_ux_synth_lc_med_tx_postdiv_counter                = 0                                     , 
    parameter         bb_f_ux_synth_lc_med_tx_postdiv_fractional_en          = "DISABLE"                             , 
    parameter         bb_f_ux_synth_lc_slow_f_rx_postdiv_hz                  = 0                                     , 
    parameter         bb_f_ux_synth_lc_slow_f_tx_postdiv_hz                  = 0                                     , 
    parameter         bb_f_ux_synth_lc_slow_rx_postdiv_counter               = 93                                    , 
    parameter         bb_f_ux_synth_lc_slow_tx_postdiv_counter               = 98                                    , 
    parameter         bb_f_ux_synth_lc_slow_tx_postdiv_fractional_en         = "DISABLE"                             , 
    parameter         bb_f_ux_tx_bond_size                                   = "TX_BOND_SIZE_1"                      , 
    parameter         dec_bb_f_ux_tx_line_rate_bps                           = "25781250000"                         ,  
    parameter         bb_f_ux_tx_over_sample                                 = "__BB_DONT_CARE__"                    , 
    parameter         bb_f_ux_tx_pam4_graycode_en                            = "DISABLE"                             , 
    parameter         bb_f_ux_tx_pam4_precode_en                             = "DISABLE"                             , 
    parameter         bb_f_ux_tx_protocol                                    = "TX_PROTOCOL_FEC_PCS_MAC"             , 
    parameter         bb_f_ux_tx_user_clk1_en                                = "ENABLE"                              , 
    parameter         bb_f_ux_tx_user_clk1_mux                               = "TX_USER_CLK1_MUX_FAST"               , 
    parameter         bb_f_ux_tx_user_clk2_en                                = "ENABLE"                              , 
    parameter         bb_f_ux_tx_user_clk2_mux                               = "TX_USER_CLK2_MUX_FAST"               , 
    parameter         bb_f_ux_tx_width                                       = "TX_WIDTH_32"                         , 
    parameter         bb_f_ux_txrx_channel_operation                         = "TXRX_CHANNEL_OPERATION_FULL_DUPLEX"  , 
    parameter         bb_f_ux_txrx_line_encoding_type                        = "TXRX_LINE_ENCODING_TYPE_NRZ"         , 
    parameter         bb_f_ux_txrx_xcvr_speed_bucket                         = "TXRX_XCVR_SPEED_BUCKET_25G"          ,  
    parameter         bb_f_ux_ux_q_ckmux_cpu_attr                            = "CKMUX_CPU_AVMM"                     ,
    parameter         bb_f_ux_ux_q_e_rx_dp_pipe_attr                         = "E_RX_DP_NO_PIPE"                     ,
    parameter         bb_f_ux_ux_q_e_tx_dp_pipe_attr                         = "E_TX_DP_NO_PIPE"                     ,
    parameter         bb_f_ux_ux_q_i_pll0_hz                                 = 0                                     ,
// 
    parameter         bb_f_ux_cdr_bw_sel                                     = "CDR_BW_SEL_LOW"                      , 
    parameter         bb_f_ux_cdr_f_out_hz                                   = 0                                     , 
    parameter bb_f_ux_cdr_f_vco_hz                                                                = 36'h3005753e8,
    parameter         bb_f_ux_cdr_f_ref_hz                                   = 36'd156250000                          , 
    parameter         bb_f_ux_cdr_l_counter                                  = 0                                     , 
    parameter         bb_f_ux_cdr_m_counter                                  = 0                                     ,
    parameter         bb_f_ux_cdr_n_counter                                  = 0                                     , 
    parameter         bb_f_ux_synth_lc_fast_f_out_hz                         = 0                                     ,
    parameter 	      bb_f_ux_synth_lc_fast_f_vco_hz          = "__BB_DONT_CARE__",
    parameter         bb_f_ux_synth_lc_fast_f_ref_hz                         = 0                                     , 
    parameter         bb_f_ux_synth_lc_fast_fractional_en                    = "DISABLE"                             ,  
    parameter         bb_f_ux_synth_lc_fast_k_counter                        = 0                                     ,  
    parameter         bb_f_ux_synth_lc_fast_l_counter                        = 0                                     ,  
    parameter         bb_f_ux_synth_lc_fast_m_counter                        = 0                                     ,  
    parameter         bb_f_ux_synth_lc_fast_n_counter                        = 0                                     ,  
    parameter         bb_f_ux_synth_lc_fast_primary_use                      = "SYNTH_LC_FAST_PRIMARY_USE_DISABLED"  , 
    parameter         bb_f_ux_synth_lc_med_f_out_hz                          = 0                                     ,
    parameter bb_f_ux_synth_lc_med_f_vco_hz           = "__BB_DONT_CARE__",
    parameter         bb_f_ux_synth_lc_med_f_ref_hz                          = 0                                     ,
    parameter         bb_f_ux_synth_lc_med_fractional_en                     = "DISABLE"                             ,
    parameter         bb_f_ux_synth_lc_med_k_counter                         = 0                                     ,
    parameter         bb_f_ux_synth_lc_med_l_counter                         = 0                                     ,
    parameter         bb_f_ux_synth_lc_med_m_counter                         = 0                                     ,
    parameter         bb_f_ux_synth_lc_med_n_counter                         = 0                                     ,
    parameter         bb_f_ux_synth_lc_med_primary_use                       = "SYNTH_LC_MED_PRIMARY_USE_DISABLED"   , 
    parameter         bb_f_ux_synth_lc_slow_f_out_hz                         = 0                                     ,
    parameter bb_f_ux_synth_lc_slow_f_vco_hz          = "__BB_DONT_CARE__",
    parameter         bb_f_ux_synth_lc_slow_f_ref_hz                         = 0                                     ,
    parameter         bb_f_ux_synth_lc_slow_fractional_en                    = "DISABLE"                             ,
    parameter         bb_f_ux_synth_lc_slow_k_counter                        = 0                                     ,
    parameter         bb_f_ux_synth_lc_slow_l_counter                        = 0                                     ,
    parameter         bb_f_ux_synth_lc_slow_m_counter                        = 0                                     ,
    parameter         bb_f_ux_synth_lc_slow_n_counter                        = 0                                     ,
    parameter         bb_f_ux_synth_lc_slow_primary_use                      = "SYNTH_LC_SLOW_PRIMARY_USE_DISABLED"  ,
    parameter         bb_f_ux_tx_pll                                         = "TX_PLL_DISABLED"                     , 
    parameter         bb_f_ux_tx_pll_bw_sel                                  = "TX_PLL_BW_SEL_LOW"                   ,
  	parameter          bb_f_ux_enable_an_lt_support                             =  "FALSE",
    parameter          bb_f_ux_primary_use                                      =  "PRIMARY_USE_STANDARD",
    parameter          bb_f_ux_tx_spread_spectrum_en                            =  "DISABLE",
    parameter          bb_f_ux_tx_tuning_hint                                   =  "TX_TUNING_HINT_DISABLED",
    parameter          bb_f_ux_rx_tuning_hint                                   =  "RX_TUNING_HINT_DISABLED",
    parameter          bb_f_ux_synth_lc_fb_div_n_frac_mode                     =  1                         ,
    parameter          bb_f_ux_tx_fb_div_emb_mult_counter                     =  1                         ,
// PFE_IPSE_SYNC up changes : Commented out parameter (HIGH & MED) TBD
    parameter         bb_f_ux_dpma_refclk_source                             = "DPMA_REFCLK_SOURCE_RX"               ,
    parameter          bb_f_ux_tx_invert_p_and_n                                 = "DISABLE",
    parameter          bb_f_ux_rx_invert_p_and_n                                 = "DISABLE",
    parameter          bb_f_ux_rx_fw_clearing_regsiter_attr                      = "ENABLE",
    parameter          bb_f_ux_rx_bypass_on_chip_ac_cap                          = "DISABLE",
    parameter          bb_f_ux_rx_vcm_greater_than_0p35v_with_bypass_on_chip_ac_cap = "DISABLE",

//Barak BB parameters
    parameter          bb_f_bk_package_type                                    = "HIGHEND"		   ,
    parameter          bb_f_bk_bk_pll_fullrate                                 = "FALSE"	, 
    parameter          bb_f_bk_an_mode                                          = "AN_MODE_DIS",
    parameter          bb_f_bk_bk_dl_enable                                     = "DETLAT_DIS",
    parameter          bb_f_bk_bk_en_rxdat_profile                              = "RXDAT_PROF_EN",
    parameter          bb_f_bk_bk_rx_bdst_rcon_en                               = "RX_BADST_RCON_DIS",
    parameter          bb_f_bk_bk_rx_ppmd_rcon_en                               = "RX_PPMD_BADST_RCON_DIS",
    parameter          bb_f_bk_bk_lnx_txovf_rxbdstb_inten                       = 6,
    parameter          bb_f_bk_bk_lnx_txudf_pldrstb_inten                       = 8,
    parameter          bb_f_bk_bk_rx_lat_bit_for_async                          = 0,
    parameter          bb_f_bk_bk_rxbit_cntr_pma                                = "RXBIT_CNTR_PMADIR_DIS",
    parameter          bb_f_bk_bk_rxbit_rollover                                = 0,
    parameter          bb_f_bk_bk_sel_tx_user_data                              = "TX_USRDATA_DIS",
    parameter          bb_f_bk_bk_car_tx_clk_src_sel                            = "BK_CAR_TX_CLK_SRC_SEL_DISABLE",
// Added for snap46
    parameter          bb_f_bk_fec_used                                         = "FALSE",
    parameter          bb_f_bk_bk_seq0_enable                                   = "SEQ0_EN",
    parameter          bb_f_bk_bk_seq1_enable                                   = "SEQ1_EN",
    parameter          bb_f_bk_bk_seq2_enable                                   = "SEQ2_EN",
    parameter          bb_f_bk_bk_seq3_enable                                   = "SEQ3_EN",
    parameter          bb_f_bk_bk_seq4_enable                                   = "SEQ4_EN",
    parameter          bb_f_bk_bk_seq5_enable                                   = "SEQ5_EN",
    parameter          bb_f_bk_bk_seq6_enable                                   = "SEQ6_EN",
    parameter          bb_f_bk_bk_seq7_enable                                   = "SEQ7_EN",
    parameter          bb_f_bk_bk_seq8_enable                                   = "SEQ8_EN",
    parameter          bb_f_bk_bk_seq9_enable                                   = "SEQ9_EN",
    parameter          bb_f_bk_bk_seq10_enable                                  = "SEQ10_EN",
    parameter          bb_f_bk_bk_seq42_enable                                  = "SEQ42_EN",
    parameter          bb_f_bk_bk_seq43_enable                                  = "SEQ43_EN",
    parameter          bb_f_bk_bk_seq44_enable                                  = "SEQ44_EN",
    parameter          bb_f_bk_bk_seq45_enable                                  = "SEQ45_EN",
    parameter          bb_f_bk_bk_seq46_enable                                  = "SEQ46_EN",
    parameter          bb_f_bk_bk_seq31_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq31_data                                    = 0,          
    parameter          bb_f_bk_bk_seq31_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq31_rdwrb                                   = "SEQ31_WR", 
    parameter          bb_f_bk_bk_seq32_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq32_data                                    = 0,          
    parameter          bb_f_bk_bk_seq32_enable                                  = "SEQ32_DIS",
    parameter          bb_f_bk_bk_seq32_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq32_rdwrb                                   = "SEQ32_WR", 
    parameter          bb_f_bk_bk_seq33_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq33_data                                    = 0,          
    parameter          bb_f_bk_bk_seq33_enable                                  = "SEQ33_DIS",
    parameter          bb_f_bk_bk_seq33_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq33_rdwrb                                   = "SEQ33_WR", 
    parameter          bb_f_bk_bk_seq34_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq34_data                                    = 0,          
    parameter          bb_f_bk_bk_seq34_enable                                  = "SEQ34_DIS",
    parameter          bb_f_bk_bk_seq34_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq34_rdwrb                                   = "SEQ34_WR", 
    parameter          bb_f_bk_bk_seq35_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq35_data                                    = 0,          
    parameter          bb_f_bk_bk_seq35_enable                                  = "SEQ35_DIS",
    parameter          bb_f_bk_bk_seq35_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq35_rdwrb                                   = "SEQ35_WR", 
    parameter          bb_f_bk_bk_seq36_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq36_data                                    = 0,          
    parameter          bb_f_bk_bk_seq36_enable                                  = "SEQ36_DIS",
    parameter          bb_f_bk_bk_seq36_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq36_rdwrb                                   = "SEQ36_WR", 
    parameter          bb_f_bk_bk_seq37_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq37_data                                    = 0,          
    parameter          bb_f_bk_bk_seq37_enable                                  = "SEQ37_DIS",
    parameter          bb_f_bk_bk_seq37_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq37_rdwrb                                   = "SEQ37_WR", 
    parameter          bb_f_bk_bk_seq38_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq38_data                                    = 0,          
    parameter          bb_f_bk_bk_seq38_enable                                  = "SEQ38_DIS",
    parameter          bb_f_bk_bk_seq38_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq38_rdwrb                                   = "SEQ38_WR", 
    parameter          bb_f_bk_bk_seq39_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq39_data                                    = 0,          
    parameter          bb_f_bk_bk_seq39_enable                                  = "SEQ39_DIS",
    parameter          bb_f_bk_bk_seq39_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq39_rdwrb                                   = "SEQ39_WR", 
    parameter          bb_f_bk_bk_seq40_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq40_data                                    = 0,          
    parameter          bb_f_bk_bk_seq40_enable                                  = "SEQ40_DIS",
    parameter          bb_f_bk_bk_seq40_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq40_rdwrb                                   = "SEQ40_WR", 
    parameter          bb_f_bk_bk_seq41_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq41_data                                    = 0,          
    parameter          bb_f_bk_bk_seq41_enable                                  = "SEQ41_DIS",
    parameter          bb_f_bk_bk_seq41_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq41_rdwrb                                   = "SEQ41_WR", 
    parameter          bb_f_bk_bk_seq59_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq59_data                                    = 0,          
    parameter          bb_f_bk_bk_seq59_enable                                  = "SEQ59_DIS",
    parameter          bb_f_bk_bk_seq59_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq59_rdwrb                                   = "SEQ59_WR", 
    parameter          bb_f_bk_bk_seq60_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq60_data                                    = 0,          
    parameter          bb_f_bk_bk_seq60_enable                                  = "SEQ60_DIS",
    parameter          bb_f_bk_bk_seq60_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq60_rdwrb                                   = "SEQ60_WR", 
    parameter          bb_f_bk_bk_seq61_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq61_data                                    = 0,          
    parameter          bb_f_bk_bk_seq61_enable                                  = "SEQ61_DIS",
    parameter          bb_f_bk_bk_seq61_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq61_rdwrb                                   = "SEQ61_WR", 
    parameter          bb_f_bk_bk_seq62_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq62_data                                    = 0,          
    parameter          bb_f_bk_bk_seq62_enable                                  = "SEQ62_DIS",
    parameter          bb_f_bk_bk_seq62_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq62_rdwrb                                   = "SEQ62_WR", 
    parameter          bb_f_bk_bk_seq63_addr                                    = 0,          
    parameter          bb_f_bk_bk_seq63_data                                    = 0,          
    parameter          bb_f_bk_bk_seq63_enable                                  = "SEQ63_DIS",
    parameter          bb_f_bk_bk_seq63_rdata_unmask                            = 0,          
    parameter          bb_f_bk_bk_seq63_rdwrb                                   = "SEQ63_WR",
    parameter          bb_f_bk_bk_tx_lnx_ovf_inten_dirsignal                    = 8,
    parameter          bb_f_bk_bk_tx_lnx_rxbadst_inten_dirsignal                = 5,
    parameter          bb_f_bk_bk_tx_lnx_udf_inten_dirsignal                    = 11,
    parameter          bb_f_bk_bk_tx_usr_data_0                                 = 0,
    parameter          bb_f_bk_bk_tx_usr_data_1                                 = 0,
    parameter          bb_f_bk_bk_tx_usr_data_2                                 = 0,
    parameter          bb_f_bk_bk_tx_usr_data_3                                 = 0,
    parameter          bb_f_bk_engineered_link_mode                             = "DISABLE",
    parameter          bb_f_bk_loopback_mode                                    = "LPBK_DISABLED",
    parameter          bb_f_bk_pam4_rxgrey_code                                 = "PAM4_RXGREY_IS_B4",
    parameter          bb_f_bk_pll_n_counter                                    = 3'h1,
    parameter          bb_f_bk_pll_pcs3334_ratio                                = "DIV_33_BY_2",
    parameter          bb_f_bk_pll_rx_pcs3334_ratio                             = "DIV_33_BY_2",
    parameter          bb_f_bk_refclk_source_lane_pll                           = "PLL_156_MHZ",
    parameter  [31:0]  bb_f_bk_rx_ber_cnt_limit_lsb                             = 32'h0,
    parameter  [31:0]  bb_f_bk_rx_ber_cnt_limit_msb                             = 32'h0,
    parameter  [31:0]  bb_f_bk_rx_ber_cnt_mask_0_31                             = 32'h0,
    parameter  [31:0]  bb_f_bk_rx_ber_cnt_mask_32_63                            = 32'h0,
    parameter  [31:0]  bb_f_bk_rx_ber_cnt_mask_64_95                            = 32'h0,
    parameter  [31:0]  bb_f_bk_rx_ber_cnt_mask_96_127                           = 32'h0,
    parameter          bb_f_bk_rx_prbs_common_en                                = "RX_PRBS_COMMON_EN_ENABLE",
    parameter          bb_f_bk_rx_precode_en                                    = "RX_PRECODE_DIS",
    parameter          bb_f_bk_rx_prbs_mode                                     = "RX_PRBS_23",
    parameter          bb_f_bk_sup_mode                                         = "SUP_MODE_USER_MODE",
    parameter          bb_f_bk_rx_user_clk1_en                                  = "RX_USRCLK1_EN",
    parameter          bb_f_bk_rx_user_clk1_sel                                 = "RX_USRCLK1SEL_DIV3334",
    parameter          bb_f_bk_rx_user_clk2_en                                  = "RX_USRCLK2_EN",
    parameter          bb_f_bk_rx_user_clk2_sel                                 = "RX_USRCLK2SEL_DIV3334",
    parameter          bb_f_bk_tx_bond_size                                     = "TX_BOND_SIZE_1",
    parameter          bb_f_bk_tx_line_rate                                     = "25781250000",
    parameter          bb_f_bk_tx_prbs_en                                       = "TX_PRBS_EN_DISABLE",
    parameter          bb_f_bk_tx_precode_en                                    = "TX_PRECODE_DIS",
    parameter          bb_f_bk_tx_prbs_mode                                     = "TX_PRBS_11",
    parameter          bb_f_bk_tx_protocol                                      = "TX_PROTOCOL_FEC_PCS_MAC",
    parameter          bb_f_bk_tx_user_clk1_en                                  = "TX_USRCLK1_EN",
    parameter          bb_f_bk_tx_user_clk1_sel                                 = "TX_USRCLK1SEL_DIV3334",
    parameter          bb_f_bk_tx_user_clk2_en                                  = "TX_USRCLK2_EN",
    parameter          bb_f_bk_tx_user_clk2_sel                                 = "TX_USRCLK2SEL_DIV3334",
    parameter          bb_f_bk_txrx_line_encoding_type                          = "TXRX_LINE_ENCODING_TYPE_NRZ",
    parameter          bb_f_bk_txrx_xcvr_speed_bucket                           = "TXRX_XCVR_SPEED_BUCKET_25G",
    parameter          bb_f_bk_rx_invert_p_and_n                                = "RX_INVERT_PN_DIS",
    parameter          bb_f_bk_tx_invert_p_and_n                                = "TX_INVERT_PN_DIS",
    parameter	       bb_f_bk_silicon_rev                			            = "10nm6agdra",
// PFE_IPSE_SYNC up changes : Commented out parameter (HIGH & MED) TBD
    parameter          bb_f_bk_bk_bitprog_update_cfg                            = "BK_BITPROG_NOUPDATE_CFG",
// PFE_IPSE_SYNC up changes : Updated value (HIGH & MED) TBD
    parameter          bb_f_bk_bti_protected                                    = "__BB_DONT_CARE__",
    
    parameter          bb_f_aib_aibadapt_tx_loopback_mode                       = "AIBADAPT_TX_LOOPBACK_DISABLE",
    parameter          bb_f_aib_aibadapt_tx_sup_mode                            = "AIBADAPT_TX_USER_MODE",
	parameter          bb_f_aib_aibadapt_tx_tx_user_clk_sel                     = "AIBADAPT_TX_TX_USER_CLK_EHIP",
    parameter          bb_f_aib_silicon_rev                                     = "gdra",
    parameter          bb_f_aib_tx_user_clk_hz                                  = 32'd402832031,
	parameter          bb_f_aib_rx_user_clk_hz                                  = 32'd402832031,
	parameter          bb_f_aib_hssi_tx_transfer_clk_hz                         = 32'd805664062,
	parameter          bb_f_aib_hssi_rx_transfer_clk_hz                         = 32'd805664062,
	
	parameter          bb_f_aib_aibadapt_rx_rx_datapath_tb_sel                  = "AIBADAPT_RX_PCS_CHNL_TB",
    parameter          bb_f_aib_aibadapt_rx_rx_user_clk_sel                     = "AIBADAPT_RX_RX_USER_CLK_EHIP",
// PFE_IPSE_SYNC up changes : Commented out parameter (HIGH & MED) TBD
  parameter    bb_f_aibadapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass  = "__BB_DONT_CARE__", 
  parameter    bb_f_aibadapt_rx_rx_pld_8g_wa_boundary_polling_bypass             = "__BB_DONT_CARE__",
  parameter    bb_f_aibadapt_rx_rx_pld_pma_pcie_sw_done_polling_bypass           = "__BB_DONT_CARE__",
  parameter    bb_f_aibadapt_rx_rx_pld_pma_reser_in_polling_bypass               = "__BB_DONT_CARE__",
  parameter    bb_f_aibadapt_rx_rx_pld_pma_testbus_polling_bypass                = "__BB_DONT_CARE__",
  parameter    bb_f_aibadapt_rx_rx_pld_test_data_polling_bypass                  = "__BB_DONT_CARE__",
  parameter    bb_f_aibadapt_rx_rx_user_clk_rst_sel                              = "AIBADAPT_RX_RX_USER_CLK_HARD_RST",
  parameter    bb_f_aibadapt_tx_tx_latency_src_xcvrif                            = "AIBADAPT_TX_LATENCY_PLS_E400E200",  
  parameter    bb_f_aibadapt_tx_tx_user_clk_rst_sel                              = "AIBADAPT_TX_TX_USER_CLK_HARD_RST",
 
    parameter          bb_m_aib_rx_silicon_rev                                  = "gdra",
    parameter          bb_m_aib_rx_aib_dllstr_align_st_dftmuxsel                = "AIB_DLLSTR_ALIGN_ST_DFTMUXSEL_SETTING0", 
    parameter          bb_m_aib_rx_dft_hssitestip_dll_dcc_en                    = "DISABLE_DFT",
    parameter          bb_m_aib_rx_op_mode                                      = "RX_DLL_ENABLE",
    parameter          bb_m_aib_rx_redundancy_en                                = "DISABLE",
    parameter          bb_m_aib_rx_sup_mode                                     = "ENGINEERING_MODE",  //user or engineering?
    parameter          bb_m_aib_tx_silicon_rev                                  = "gdra",
    parameter          bb_m_aib_tx_aib_tx_dcc_dft                               = "AIB_TX_DCC_DFT_DISABLE",
    parameter          bb_m_aib_tx_aib_tx_dcc_dft_sel                           = "AIB_TX_DCC_DFT_MODE1", 
    parameter          bb_m_aib_tx_aib_tx_dcc_st_dftmuxsel                      = "AIB_TX_DCC_ST_DFTMUXSEL_SETTING1",
    parameter          bb_m_aib_tx_dfd_dll_dcc_en                               = "DISABLE_DFD",
    parameter          bb_m_aib_tx_dft_hssitestip_dll_dcc_en                    = "DISABLE_DFT",
    parameter          bb_m_aib_tx_op_mode                                      = "TX_DCC_ENABLE",
    parameter          bb_m_aib_tx_redundancy_en                                = "DISABLE",
    parameter          bb_m_aib_tx_sup_mode                                     = "USER_MODE",
    parameter          bb_m_hdpldadapt_rx_silicon_rev                           = "fm6",
    parameter          bb_m_hdpldadapt_rx_fifo_mode                             = "PHASE_COMP",
    parameter          bb_m_hdpldadapt_rx_fifo_width                            = "FIFO_DOUBLE_WIDTH",
    parameter [30:0]   bb_m_hdpldadapt_rx_hdpldadapt_aib_fabric_pld_pma_hclk_hz = 31'd447381676,
    parameter [30:0]   bb_m_hdpldadapt_rx_hdpldadapt_aib_fabric_rx_sr_clk_in_hz = 31'd900000000,
    parameter [30:0]   bb_m_hdpldadapt_rx_hdpldadapt_csr_clk_hz                 = 31'd117327492,
    parameter [30:0]   bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz         = 31'd343212902,
    parameter [30:0]   bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz      = 31'd36266565, 

    parameter          bb_m_hdpldadapt_rx_hdpldadapt_speed_grade                = "HDPLDADAPT_DASH_2",
    parameter          bb_m_hdpldadapt_rx_pld_clk1_sel                          = "PLD_CLK1_DCM",
    parameter          bb_m_hdpldadapt_rx_rx_fifo_power_mode                    = "FULL_WIDTH_PS_DW",
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_tx_chnl_fifo_mode          = "HDPLDADAPT_TX_CHNL_PHASE_COMP",
    parameter          bb_m_hdpldadapt_tx_silicon_rev                           = "fm6",
    parameter          bb_m_hdpldadapt_tx_duplex_mode                           = "ENABLE",
    parameter          bb_m_hdpldadapt_tx_fifo_mode                             = "PHASE_COMP",
    parameter          bb_m_hdpldadapt_tx_fifo_width                            = "FIFO_DOUBLE_WIDTH",
    parameter [30:0]   bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz         = 31'd210928531,
    parameter [30:0]   bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz         = 31'd626545676,
    parameter          bb_m_hdpldadapt_tx_hdpldadapt_speed_grade                = "HDPLDADAPT_DASH_2",
    parameter          bb_m_hdpldadapt_tx_hip_osc_clk_scg_en                    = "DISABLE",
    parameter          bb_m_hdpldadapt_tx_pld_clk1_sel                          = "PLD_CLK1_DCM",
    parameter          bb_m_hdpldadapt_tx_tx_fifo_power_mode                    = "FULL_WIDTH_PS_DW",
    parameter          bb_m_hdpldadapt_avmm2_silicon_rev                        = "gdra",
	parameter 		bb_m_hdpldadapt_pld_avmm1_clk_rowclk_hz			= 31'd100000000,
	parameter 		bb_m_hdpldadapt_pld_avmm2_clk_rowclk_hz			= 31'd100000000,
	    parameter          bb_f_ux_refclk_silicon_rev                               = "gdra"
  )  (
   // input   wire                        chnl_pll_refclk_link,
   // output  wire                        rx_cdr_divclk_link,
   // input   wire                        rx_cdr_refclk_link,
   // input   wire                        tx_pll_refclk_link,

          //TODO: Barak RefClk
   // input   wire                        system_pll_clk_link,

    input   wire                        i_clk_ref,
    input   wire                        i_clk_sys,
    input   wire                        i_clk_rx,
    input   wire                        i_clk_tx,

    // TODO: need to remove once reset controller is added 
    input   wire                        i_rx_rst_n,
    input   wire                        i_tx_rst_n,
    input   wire                        i_rst_n,
    // End

    input   wire  [num_xcvr-1:0]        i_rx_serial,
    input   wire  [num_xcvr-1:0]        i_rx_serial_n,
    output  wire  [num_xcvr-1:0]        o_tx_serial,
    output  wire  [num_xcvr-1:0]        o_tx_serial_n,
    input   wire  [num_aib-1:0][79:0]   tx_parallel_data,
    output  wire  [num_aib-1:0][79:0]   rx_parallel_data,
    output  wire  [num_aib-1:0][31:0]   hdpldadapt_out_link,
    input   wire  [num_aib-1:0][39:0]   hdpldadapt_in_link,
    input   wire  [num_ports-1:0]       i_stats_snapshot,
    output  wire  [num_xcvr-1:0]        xcvr_txpll_locked,
    output  wire  [num_xcvr-1:0]        xcvr_pcs_txstatus,
    output  wire  [num_xcvr-1:0]        xcvr_rxcdr_locked,

//------PTP signals ------
    input   wire                        ptp_link,
    input   wire [num_xcvr-1:0]         i_tx_ptp_async_cal_sel,
    input   wire [num_xcvr-1:0]         i_rx_ptp_async_cal_sel,
    input   wire [num_xcvr-1:0]         i_ptp_async_cal_pulse,
    output  wire [num_xcvr-1:0]         o_tx_ptp_async_pulse,
    output  wire [num_xcvr-1:0]         o_rx_ptp_async_pulse,

//------SRC signals ------

    output `ifndef __TILE_IP__ tri0 `else wire `endif [num_xcvr-1:0] src_placement_virtual,
	output [23:0] pld_tx_fifo_ready,
	output [23:0] pld_fabric_tx_transfer_en,
	output [23:0] pld_rx_fifo_ready,
    output [23:0] pld_hssi_rx_transfer_en,

    output  `ifndef __TILE_IP__ tri0 `else wire `endif [num_aib-1:0] ptp_placement_virtual,
    //  for AVMM1 bb ports
    output  wire  [num_ports-1:0]                    pld_avmm1_busy,
    input   wire                          pld_avmm1_clk_rowclk,
    output  wire  [num_ports-1:0]                   pld_avmm1_cmdfifo_wr_full,
    output  wire  [num_ports-1:0]                   pld_avmm1_cmdfifo_wr_pfull,
    input   wire  [num_ports-1:0]                   pld_avmm1_read,
    output  wire  [num_ports*8-1:0]             pld_avmm1_readdata,
    output  wire  [num_ports-1:0]                  pld_avmm1_readdatavalid,
    input   wire  [num_ports*10-1:0]             pld_avmm1_reg_addr,
    input   wire  [num_ports-1:0]                  pld_avmm1_request,
    input   wire  [num_ports*9-1:0]             pld_avmm1_reserved_in,
    output  wire  [num_ports*3-1:0]             pld_avmm1_reserved_out,
    input   wire  [num_ports-1:0]                  pld_avmm1_write,
    input   wire  [num_ports*8-1:0]             pld_avmm1_writedata,
 //   output  wire                    pld_chnl_cal_done,
    output  wire  [num_ports-1:0]                  pld_hssi_osc_transfer_en,

    // for AVMM2 bb ports
    input   wire  [num_xcvr-1:0]    hip_avmm_read,
    output  wire  [8*num_xcvr-1:0]  hip_avmm_readdata,
    output  wire  [num_xcvr-1:0]    hip_avmm_readdatavalid,
    input   wire  [21*num_xcvr-1:0] hip_avmm_reg_addr,
    output  wire  [5*num_xcvr-1:0]  hip_avmm_reserved_out,
    input   wire  [num_xcvr-1:0]    hip_avmm_write,
    input   wire  [8*num_xcvr-1:0]  hip_avmm_writedata,
    output  wire  [num_xcvr-1:0]    hip_avmm_writedone,
    output  wire  [num_xcvr-1:0]    pld_avmm2_busy,
    input   wire  [num_xcvr-1:0]    pld_avmm2_clk_rowclk,
    output  wire  [num_xcvr-1:0]    pld_avmm2_cmdfifo_wr_full,
    output  wire  [num_xcvr-1:0]    pld_avmm2_cmdfifo_wr_pfull,
    input   wire  [num_xcvr-1:0]    pld_avmm2_request,
    // output  wire  [num_xcvr-1:0]    pld_pll_cal_done, // removed this signal as it is not used in avmm2 module
    input   wire  [num_xcvr-1:0]    pld_avmm2_write,
    input   wire  [num_xcvr-1:0]    pld_avmm2_read,
    input   wire  [9*num_xcvr-1:0]  pld_avmm2_reg_addr,
    output  wire  [8*num_xcvr-1:0]  pld_avmm2_readdata,
    input   wire  [8*num_xcvr-1:0]  pld_avmm2_writedata,
    output  wire  [num_xcvr-1:0]    pld_avmm2_readdatavalid,
    input   wire  [6*num_xcvr-1:0]  pld_avmm2_reserved_in,
    output  wire  [num_xcvr-1:0]    pld_avmm2_reserved_out
 );
      
    wire [15:0]                         xcvr_data_link;
    wire [15:0]                         xcvr_bond_link;
    wire [15:0]                         ip_data_link;
    wire [num_aib-1:0]                  aib_tx_data_link;
    wire [num_aib-1:0]                  aib_rx_data_link;
    wire [num_aib-1:0]                  adapt_tx_data_link;
    wire [num_aib-1:0]                  adapt_rx_data_link;

    wire [num_aib-1:0]                  avmm1_link;
    wire [num_xcvr-1:0]                 avmm2_link;
    wire [num_aib-1:0]                  i_stats_snapshot_aib;

        
    localparam  MAX_CONVERSION_SIZE_ALT_XCVR_NATIVE_S10 = 128;
    localparam  MAX_STRING_CHARS_ALT_XCVR_NATIVE_S10  = 64;
    localparam integer MAX_CHARS_ALT_XCVR_NATIVE_S10 = 86; // To accomodate LONG parameter lists.

    function automatic [MAX_CONVERSION_SIZE_ALT_XCVR_NATIVE_S10-1:0] str_2_bin_alt_xcvr_native_gdr;
      input [MAX_STRING_CHARS_ALT_XCVR_NATIVE_S10*8-1:0] instring;

      integer this_char;
      integer i;
      begin
        // Initialize accumulator
        str_2_bin_alt_xcvr_native_gdr = {MAX_CONVERSION_SIZE_ALT_XCVR_NATIVE_S10{1'b0}};
        for(i=MAX_STRING_CHARS_ALT_XCVR_NATIVE_S10-1;i>=0;i=i-1) begin
          this_char = instring[i*8+:8];
          // Add value of this digit
          if(this_char >= 48 && this_char <= 57)
            str_2_bin_alt_xcvr_native_gdr = (str_2_bin_alt_xcvr_native_gdr * 10) + (this_char - 48);
        end
      end
    endfunction    
    
    //todo: in the absence of proper documentation, all frequency and datarate related attributes assumed to be 37 bits which might be wrong
    localparam [36:0] bin_bb_f_ehip_tx_datarate                 = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ehip_tx_datarate);
    localparam [36:0] bin_bb_f_ehip_rx_datarate                 = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ehip_rx_datarate);
    localparam [35:0] bin_bb_f_ux_synth_lc_fast_f_out_hz        = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_fast_f_out_hz      );
    localparam [35:0] bin_bb_f_ux_synth_lc_fast_f_ref_hz        = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_fast_f_ref_hz      );
    localparam [35:0] bin_bb_f_ux_synth_lc_med_f_out_hz         = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_med_f_out_hz       );
//    localparam [35:0] bin_bb_f_ux_synth_lc_med_f_tx_postdiv_hz  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_med_f_tx_postdiv_hz);
    localparam [35:0] bin_bb_f_ux_synth_lc_slow_f_out_hz        = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_slow_f_out_hz       );
//    localparam [35:0] bin_bb_f_ux_synth_lc_slow_f_tx_postdiv_hz = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_slow_f_tx_postdiv_hz);
    localparam [35:0] bin_bb_f_ux_cdr_f_out_hz                  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_cdr_f_out_hz);
// New for ww444.1 snap: not being used, in case bin values have to be passed:
	localparam [35:0] bin_bb_f_ux_cdr_f_vco_hz                  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_cdr_f_vco_hz);
	localparam [35:0] bin_bb_f_ux_synth_lc_fast_f_vco_hz                  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_fast_f_vco_hz);
	localparam [35:0] bin_bb_f_ux_synth_lc_med_f_vco_hz                  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_med_f_vco_hz);
	localparam [35:0] bin_bb_f_ux_synth_lc_slow_f_vco_hz                  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_synth_lc_slow_f_vco_hz);





    localparam [35:0] bin_bb_f_ux_cdr_f_ref_hz                  = str_2_bin_alt_xcvr_native_gdr(bb_f_ux_cdr_f_ref_hz);
    localparam [36:0] bin_bb_f_ux_rx_line_rate_bps              = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ux_rx_line_rate_bps);
    localparam [36:0] bin_bb_f_ux_tx_line_rate_bps              = str_2_bin_alt_xcvr_native_gdr(dec_bb_f_ux_tx_line_rate_bps);


   assign pld_fabric_tx_transfer_en[(23-num_aib):0] = {(24-num_aib){1'b0}};
   assign pld_hssi_rx_transfer_en[(23-num_aib):0] = {(24-num_aib){1'b0}};
   assign pld_rx_fifo_ready[(23-num_aib):0] = {(24-num_aib){1'b0}};
   assign pld_tx_fifo_ready[(23-num_aib):0] = {(24-num_aib){1'b0}};


  genvar idn;
  generate
    for(idn=0;idn<num_aib;idn=idn+1) begin:per_port_snapshot
        assign i_stats_snapshot_aib[idn] = i_stats_snapshot[idn/(num_aib/num_ports)];
    end
  endgenerate


//----------------------------------------------------------------

     `ifdef __TILE_IP__
       bb_f_ehip
        #(       
	.aib2_rx_st_clk_en             (bb_f_ehip_aib2_rx_st_clk_en),             /* AUTOGEN_BB_Placeholder - BCM default="AIB2_RX_ST_CLK_EN_DISABLED" - Legal settings are {AIB2_RX_ST_CLK_EN_DISABLED,AIB2_RX_ST_CLK_EN_AIB2_RX_ST_CLK,AIB2_RX_ST_CLK_EN_RX_WORD_CLK,AIB2_RX_ST_CLK_EN_RX_BOND_CLK,AIB2_RX_ST_CLK_EN_RX_USER_CLK1,AIB2_RX_ST_CLK_EN_RX_USER_CLK2,AIB2_RX_ST_CLK_EN_PLL0_DIV1,AIB2_RX_ST_CLK_EN_PLL0_DIV2,AIB2_RX_ST_CLK_EN_PLL1_DIV1,AIB2_RX_ST_CLK_EN_PLL1_DIV2,AIB2_RX_ST_CLK_EN_PLL2_DIV1,AIB2_RX_ST_CLK_EN_PLL2_DIV2,__BB_DONT_CARE__} */
          .aib2_tx_st_clk_en             (bb_f_ehip_aib2_tx_st_clk_en),             /* AUTOGEN_BB_Placeholder - BCM default="AIB2_TX_ST_CLK_EN_DISABLED" - Legal settings are {AIB2_TX_ST_CLK_EN_DISABLED,AIB2_TX_ST_CLK_EN_AIB2_TX_ST_CLK,AIB2_TX_ST_CLK_EN_TX_WORD_CLK,AIB2_TX_ST_CLK_EN_TX_BOND_CLK,AIB2_TX_ST_CLK_EN_TX_USER_CLK1,AIB2_TX_ST_CLK_EN_TX_USER_CLK2,AIB2_TX_ST_CLK_EN_PLL0_DIV1,AIB2_TX_ST_CLK_EN_PLL0_DIV2,AIB2_TX_ST_CLK_EN_PLL1_DIV1,AIB2_TX_ST_CLK_EN_PLL1_DIV2,AIB2_TX_ST_CLK_EN_PLL2_DIV1,AIB2_TX_ST_CLK_EN_PLL2_DIV2,__BB_DONT_CARE__} */
          .aib3_rx_st_clk_en             (bb_f_ehip_aib3_rx_st_clk_en),             /* AUTOGEN_BB_Placeholder - BCM default="AIB3_RX_ST_CLK_EN_DISABLED" - Legal settings are {AIB3_RX_ST_CLK_EN_DISABLED,AIB3_RX_ST_CLK_EN_AIB3_RX_ST_CLK,AIB3_RX_ST_CLK_EN_RX_WORD_CLK,AIB3_RX_ST_CLK_EN_RX_BOND_CLK,AIB3_RX_ST_CLK_EN_RX_USER_CLK1,AIB3_RX_ST_CLK_EN_RX_USER_CLK2,AIB3_RX_ST_CLK_EN_PLL0_DIV1,AIB3_RX_ST_CLK_EN_PLL0_DIV2,AIB3_RX_ST_CLK_EN_PLL1_DIV1,AIB3_RX_ST_CLK_EN_PLL1_DIV2,AIB3_RX_ST_CLK_EN_PLL2_DIV1,AIB3_RX_ST_CLK_EN_PLL2_DIV2,__BB_DONT_CARE__} */
          .aib3_tx_st_clk_en             (bb_f_ehip_aib3_tx_st_clk_en),             /* AUTOGEN_BB_Placeholder - BCM default="AIB3_TX_ST_CLK_EN_DISABLED" - Legal settings are {AIB3_TX_ST_CLK_EN_DISABLED,AIB3_TX_ST_CLK_EN_AIB3_TX_ST_CLK,AIB3_TX_ST_CLK_EN_TX_WORD_CLK,AIB3_TX_ST_CLK_EN_TX_BOND_CLK,AIB3_TX_ST_CLK_EN_TX_USER_CLK1,AIB3_TX_ST_CLK_EN_TX_USER_CLK2,AIB3_TX_ST_CLK_EN_PLL0_DIV1,AIB3_TX_ST_CLK_EN_PLL0_DIV2,AIB3_TX_ST_CLK_EN_PLL1_DIV1,AIB3_TX_ST_CLK_EN_PLL1_DIV2,AIB3_TX_ST_CLK_EN_PLL2_DIV1,AIB3_TX_ST_CLK_EN_PLL2_DIV2,__BB_DONT_CARE__} */
          .aibif_data_valid              (bb_f_ehip_aibif_data_valid),              /* AUTOGEN_BB_Placeholder - BCM default="AIBIF_DATA_VALID_25G" - Legal settings are {AIBIF_DATA_VALID_25G,AIBIF_DATA_VALID_10G,AIBIF_DATA_VALID_40G,AIBIF_DATA_VALID_CUSTOM,__BB_DONT_CARE__} */
          .duplex_mode                   (bb_f_ehip_duplex_mode),                   /* Specify duplex mode - BCM default="DUPLEX_MODE_DISABLED" - Legal settings are {DUPLEX_MODE_DISABLED,DUPLEX_MODE_FULL_DUPLEX,DUPLEX_MODE_DIGITAL_DUPLEX,DUPLEX_MODE_SYSTEM_SIMPLEX,DUPLEX_MODE_TRUE_SIMPLEX,__BB_DONT_CARE__} */
          .fec_mode                      (bb_f_ehip_fec_mode),                      /* Specify FEC mode - BCM default="FEC_MODE_DISABLED" - Legal settings are {FEC_MODE_DISABLED,FEC_MODE_RS_528_IE_KR,FEC_MODE_RS_272_IE_LL,FEC_MODE_RS_544_IE_KP,__BB_DONT_CARE__} */
          .fec_spec                      (bb_f_ehip_fec_spec),                      /* Specify FEC spec - BCM default="FEC_SPEC_DISABLED" - Legal settings are {FEC_SPEC_DISABLED,FEC_SPEC_ETH_CONS,FEC_SPEC_IEEE,FEC_SPEC_IEEE_KR,FEC_SPEC_IEEE_C2C,FEC_SPEC_FC,FEC_SPEC_HUAWEI_BP,FEC_SPEC_NOKIA_XPL,FEC_SPEC_2_X_CPRI,FEC_SPEC_INTERLAKEN,FEC_SPEC_FLEX_O,__BB_DONT_CARE__} */
          .frac_size                     (bb_f_ehip_frac_size),                     /* ip_config_ehip frac_size - BCM default="F25G" - Legal settings are {F25G,F50G,F100G,F200G,F400G,F150G,F300G,__BB_DONT_CARE__} */
          .fec_clk_src                   (bb_f_ehip_fec_clk_src),                   /* AUTOGEN_BB_ - BCM default="FEC_CLK_SRC_DISABLED" - Legal settings are {FEC_CLK_SRC_DISABLED,FEC_CLK_SRC_PLL0,FEC_CLK_SRC_PLL1,FEC_CLK_SRC_PLL2,FEC_CLK_SRC_XCVR,__BB_DONT_CARE__} */
          .fec_error                     (bb_f_ehip_fec_error),                     /* AUTOGEN_BB_Specify e400g_25g_0_fec_error - BCM default="FEC_ERROR_OFF" - Legal settings are {FEC_ERROR_ON,FEC_ERROR_OFF,__BB_DONT_CARE__} */         
          .lpbk_mode                     (bb_f_ehip_lpbk_mode),                     /* AUTOGEN_BB_Placeholder - BCM default="LPBK_MODE_DISABLED" - Legal settings are {LPBK_MODE_DISABLED,LPBK_MODE_LPBK,LPBK_MODE_TXMAC_RXMAC,LPBK_MODE_TXAIB_RXMAC,LPBK_MODE_TXPCS_RXPCS,LPBK_MODE_TXAIB_RXPCS,LPBK_MODE_RXPCS_TXPCS,LPBK_MODE_TXMAC_RXAIB,LPBK_MODE_TXPCS_RXAIB,LPBK_MODE_XCVRIF,LPBK_MODE_FEC,__BB_DONT_CARE__} */
          .dl_enable                     (bb_f_ehip_dl_enable),                     /* AUTOGEN_BB_Placeholder - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .e400g_ptp0_aib2_div2_clk      (bb_f_ehip_e400g_ptp0_aib2_div2_clk),      /* AUTOGEN_BB_Specify whether to enable div by 2 for syspll for ptp0 - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .e400g_ptp1_aib2_div2_clk      (bb_f_ehip_e400g_ptp1_aib2_div2_clk),      /* AUTOGEN_BB_Specify whether to enable div by 2 for syspll for ptp1 - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .ptp_mode                      (bb_f_ehip_ptp_mode),                      /* Specify whether PTP is enabled - BCM default="PTP_MODE_DISABLED" - Legal settings are {PTP_MODE_DISABLED,PTP_MODE_ENABLED,__BB_DONT_CARE__} */
          .mac_tx_ptp_phy_lane_num       (bb_f_ehip_mac_tx_ptp_phy_lane_num ),      /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Transceiver phy physical link configuration - BCM default="MAC_E25G_X1_TX_LN" - Legal settings are {MAC_E10G_X1_TX_LN,MAC_E25G_X1_TX_LN,MAC_E50G_X1_TX_LN,MAC_E50G_X2_TX_LN,MAC_E100G_X1_TX_LN,MAC_E100G_X2_TX_LN,MAC_E100G_X4_TX_LN,MAC_E200G_X2_TX_LN,MAC_E200G_X4_TX_LN,MAC_E200G_X8_TX_LN,MAC_E400G_X4_TX_LN,MAC_E400G_X8_TX_LN,__BB_DONT_CARE__} */          
          .mac_rx_ptp_phy_lane_num       (bb_f_ehip_mac_rx_ptp_phy_lane_num ),      /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Transceiver phy physical link configuration - BCM default="MAC_E25G_X1_RX_LN" - Legal settings are {MAC_E10G_X1_RX_LN,MAC_E25G_X1_RX_LN,MAC_E50G_X1_RX_LN,MAC_E50G_X2_RX_LN,MAC_E100G_X1_RX_LN,MAC_E100G_X2_RX_LN,MAC_E100G_X4_RX_LN,MAC_E200G_X2_RX_LN,MAC_E200G_X4_RX_LN,MAC_E200G_X8_RX_LN,MAC_E400G_X4_RX_LN,MAC_E400G_X8_RX_LN,__BB_DONT_CARE__} */
          .mac_disable_link_fault_rf     (bb_f_ehip_mac_disable_link_fault_rf),     /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_1:Unidirectional local faults do not cause the TX to transmit Remote Faults - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_flow_control              (bb_f_ehip_mac_flow_control),              /* AUTOGEN_BB_Add flow control features to the TX and RX MAC - BCM default="MAC_NONE" - Legal settings are {MAC_NONE,MAC_SFC,MAC_SFC_NO_XOFF,MAC_PFC,MAC_PFC_NO_XOFF,MAC_BOTH,MAC_BOTH_NO_XOFF,__BB_DONT_CARE__} */
          .mac_flow_control_holdoff_mode (bb_f_ehip_mac_flow_control_holdoff_mode), /* AUTOGEN_BB_Control how XOFF requests are retramsmitted - BCM default="MAC_PER_QUEUE" - Legal settings are {MAC_PER_QUEUE,MAC_UNIFORM,MAC_NO_HOLDOFF,__BB_DONT_CARE__} */
          .mac_force_link_fault_rf       (bb_f_ehip_mac_force_link_fault_rf),       /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_1:Transmit link faults - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_enforce_max_frame_size    (bb_f_ehip_mac_enforce_max_frame_size),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Makes RX MAC end packets with error if they exceed the programmed maximum frame size - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_forward_rx_pause_requests (bb_f_ehip_mac_forward_rx_pause_requests), /* AUTOGEN_BB_Observe the PAUSE requests processed by EHIP - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_holdoff_quanta            (bb_f_ehip_mac_holdoff_quanta),            /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions - BCM default=16'hFFFF */
          .mac_ipg_removed_per_am_period (bb_f_ehip_mac_ipg_removed_per_am_period), /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Sets the total IPG removed for Ams and PPM - BCM default=16'd20 */
          .mac_keep_rx_crc               (bb_f_ehip_mac_keep_rx_crc),               /* AUTOGEN_BB_Observe the RX CRC from each RX packet - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_link_fault_mode           (bb_f_ehip_mac_link_fault_mode),           /* AUTOGEN_BB_Choose how the Link Fault SM behaves - BCM default="MAC_LF_OFF" - Legal settings are {MAC_LF_OFF,MAC_LF_UNIDIR,MAC_LF_BIDIR,__BB_DONT_CARE__} */
          .mac_mode                      (bb_f_ehip_mac_mode),                      /* Specify MAC mode - BCM default="MAC_MODE_DISABLED" - Legal settings are {MAC_MODE_DISABLED,MAC_MODE_IEEE,MAC_MODE_IEEE_OTN,MAC_MODE_CONSORTIUM,MAC_MODE_CONSORTIUM_OTN,__BB_DONT_CARE__} */
          .mac_pause_quanta              (bb_f_ehip_mac_pause_quanta),              /* AUTOGEN_BB_Control the XOFF quanta in each PAUSE request - BCM default=16'b1111111111111111 */
          .mac_remove_pads               (bb_f_ehip_mac_remove_pads),               /* AUTOGEN_BB_Makes RX MAC remove pads from incoming frame - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_rx_length_checking        (bb_f_ehip_mac_rx_length_checking),        /* AUTOGEN_BB_Make the RX MAC do length checking - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_rx_preamble_passthrough   (bb_f_ehip_mac_rx_preamble_passthrough),   /* AUTOGEN_BB_Observe the preamble from each RX packet - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_rx_ptp_dbg_master_en      (bb_f_ehip_mac_rx_ptp_dbg_master_en),      /* AUTOGEN_BB_Enable loading FP with VL info - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_rx_vlan_detection         (bb_f_ehip_mac_rx_vlan_detection),         /* AUTOGEN_BB_Make the RX MAC check for vlan frames - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_rxcrc_covers_preamble     (bb_f_ehip_mac_rxcrc_covers_preamble),     /* AUTOGEN_BB_RX CRC covers preamble as well as regular frame - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_source_address_insertion  (bb_f_ehip_mac_source_address_insertion),  /* AUTOGEN_BB_TX MAC automatically adds SADDR - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_strict_preamble_checking  (bb_f_ehip_mac_strict_preamble_checking),  /* AUTOGEN_BB_RX MAC will reject packets with preambles that do not include a standard preamble bytes before the start frame delimiter - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_strict_sfd_checking       (bb_f_ehip_mac_strict_sfd_checking),       /* AUTOGEN_BB_RX MAC will mark packets with preambles that do not include a standard start frame delimiter as errored - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_tx_mac_data_flow          (bb_f_ehip_mac_tx_mac_data_flow),          /* AUTOGEN_BB_Controls data flow through TX MAC - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_tx_preamble_passthrough   (bb_f_ehip_mac_tx_preamble_passthrough),   /* AUTOGEN_BB_Replace the standard preamble with your own - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
         // .mac_tx_ptp_extra_latency      ("__BB_DONT_CARE__"),                    /* AUTOGEN_BB_Constant latency offset used for timestamp calculation - BCM default=32'b0000000000000000000000000000000 */
         .mac_tx_vlan_detection         (bb_f_ehip_mac_tx_vlan_detection),         /* AUTOGEN_BB_Enable TX MAC vlan decodes for TX statistics - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .mac_txcrc_covers_preamble     (bb_f_ehip_mac_txcrc_covers_preamble),     /* AUTOGEN_BB_TX CRC covers preamble as well as regular frame - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .pcs_ber_mon_mode              (bb_f_ehip_pcs_ber_mon_mode),              /* AUTOGEN_BB_Placeholder - BCM default="PCS_BER_MON_MODE_25G" - Legal settings are {PCS_BER_MON_MODE_25G,PCS_BER_MON_MODE_10G,__BB_DONT_CARE__} */
          .tx_pmadirect_single_width     (bb_f_ehip_tx_pmadirect_single_width),     /* AUTOGEN_BB_Placeholder - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */
          .rx_pmadirect_single_width     (bb_f_ehip_rx_pmadirect_single_width),     /* AUTOGEN_BB_Placeholder - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */
          // .return_to_neutral             ("FALSE"),                               /* AUTOGEN_BB_Placeholder - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */
          .rx_aib_if_fifo_mode           (bb_f_ehip_rx_aib_if_fifo_mode),           /* Specify aib if fifo mode - BCM default="RX_AIB_IF_FIFO_MODE_DISABLED" - Legal settings are {RX_AIB_IF_FIFO_MODE_DISABLED,RX_AIB_IF_FIFO_MODE_PHASECOMP,RX_AIB_IF_FIFO_MODE_REGISTER,__BB_DONT_CARE__} */
          .rx_datarate                   (bin_bb_f_ehip_rx_datarate),               /* Specify datarate of link - BCM default=37'b0000000000000000000000000000000000000 */
          .rx_en                         (bb_f_ehip_rx_en),                         /* AUTOGEN_BB_e400g_25g_0_rx_en - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */
          .rx_excvr_gb_ratio_mode        (bb_f_ehip_rx_excvr_gb_ratio_mode),        /* AUTOGEN_BB_Indicate tranceiver gearbox ratio - BCM default="RX_EXCVR_GB_RATIO_MODE_DISABLED" - Legal settings are {RX_EXCVR_GB_RATIO_MODE_DISABLED,RX_EXCVR_GB_RATIO_MODE_32_33,RX_EXCVR_GB_RATIO_MODE_32_40,RX_EXCVR_GB_RATIO_MODE_32_33_X_2,RX_EXCVR_GB_RATIO_MODE_32_40_X_2,RX_EXCVR_GB_RATIO_MODE_32_33_X_4,RX_EXCVR_GB_RATIO_MODE_32_40_X_4,RX_EXCVR_GB_RATIO_MODE_32_40_X_8,RX_EXCVR_GB_RATIO_MODE_32_40_X_16,RX_EXCVR_GB_RATIO_MODE_64_80,RX_EXCVR_GB_RATIO_MODE_64_80_X_2,RX_EXCVR_GB_RATIO_MODE_64_80_X_4,RX_EXCVR_GB_RATIO_MODE_64_80_X_8,RX_EXCVR_GB_RATIO_MODE_128_160,RX_EXCVR_GB_RATIO_MODE_128_160_X_2,RX_EXCVR_GB_RATIO_MODE_128_160_X_4,__BB_DONT_CARE__} */
          .rx_excvr_if_fifo_mode         (bb_f_ehip_rx_excvr_if_fifo_mode),         /* Indicate tranceiver if fifo mode - BCM default="RX_EXCVR_IF_FIFO_MODE_DISABLED" - Legal settings are {RX_EXCVR_IF_FIFO_MODE_DISABLED,RX_EXCVR_IF_FIFO_MODE_REGISTER,RX_EXCVR_IF_FIFO_MODE_ELASTIC,RX_EXCVR_IF_FIFO_MODE_PHASECOMP,__BB_DONT_CARE__} */
          .rx_fec_enable                 (bb_f_ehip_rx_fec_enable),                 /* Indicate whether RX or TX side enabled - BCM default="RX_FEC_ENABLE_DISABLED" - Legal settings are {RX_FEC_ENABLE_DISABLED,RX_FEC_ENABLE_ENABLED,__BB_DONT_CARE__} */
          .rx_pcs_mode                   (bb_f_ehip_rx_pcs_mode),                   /* Specify PCS mode - BCM default="RX_PCS_MODE_DISABLED" - Legal settings are {RX_PCS_MODE_DISABLED,RX_PCS_MODE_IEEE,RX_PCS_MODE_IEEE_FLEXE_66,RX_PCS_MODE_IEEE_OTN,RX_PCS_MODE_CONSORTIUM,RX_PCS_MODE_CONSORTIUM_FLEXE_66,RX_PCS_MODE_CONSORTIUM_OTN,__BB_DONT_CARE__} */
          .rx_primary_use                (bb_f_ehip_rx_primary_use),                /* AUTOGEN_BB_Specify primary use - BCM default="RX_PRIMARY_USE_DISABLED" - Legal settings are {RX_PRIMARY_USE_DISABLED,RX_PRIMARY_USE_ETHERNET,RX_PRIMARY_USE_DIRECT_BUNDLE,RX_PRIMARY_USE_BUNDLE_PCS,RX_PRIMARY_USE_BUNDLE_SOFT_PIPE,__BB_DONT_CARE__} */
         // .rx_word_clk_hz                 "__BB_DONT_CARE__"                      /* AUTOGEN_BB_Specify parallel clock frequency - BCM default=37'b0000000000000000000000000000000000000 */
          .sim_mode                      (bb_f_ehip_sim_mode),                      /* AUTOGEN_BB_Placeholder - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
          .sup_mode                      (bb_f_ehip_sup_mode),                      /* AUTOGEN_BB_Specify whether we are in user or engineering modes - BCM default="SUP_MODE_USER_MODE" - Legal settings are {SUP_MODE_USER_MODE,SUP_MODE_ADVANCED_USER_MODE,SUP_MODE_ENGINEERING_MODE,__BB_DONT_CARE__} */
          .sys_clk_src                   (bb_f_ehip_sys_clk_src),                   /* AUTOGEN_BB_Specify clock source - BCM default="SYS_CLK_SRC_DISABLED" - Legal settings are {SYS_CLK_SRC_DISABLED,SYS_CLK_SRC_XCVR,SYS_CLK_SRC_PLL0,SYS_CLK_SRC_PLL1,SYS_CLK_SRC_PLL2,__BB_DONT_CARE__} */
        //  .topology                      (bb_f_ehip_topology),                      /* AUTOGEN_BB_Specify tile level topology - BCM default="DISABLED_XX_DISABLED_XX_DISABLED" - Legal settings are {DISABLED_XX_DISABLED_XX_DISABLED,DISABLED_XX_DISABLED_XX_D_D_D_G4X16,DISABLED_XX_DISABLED_XX_D_G4X8_D_G4X8,DISABLED_XX_DISABLED_XX_G4X4_G4X4_G4X4_G4X4,BARAK4E100GPTP_XX_DISABLED_XX_D_D_D_G4X16,BARAK4E400G_XX_UX8E200G_XX_DISABLED,BARAK4E400GPTP_XX_UX6E150G_XX_DISABLED,BARAK4E400GPTP_XX_DISABLED_XX_D_D_D_G4X4,BARAK4E250GPTP_XX_DISABLED_XX_D_D_D_G4X8,BARAK4E250GPTP_XX_DISABLED_XX_D_D_G4X4_G4X4,UX8E400G_XX_UX8E200G_XX_DISABLED,UX8E400GPTP_XX_UX6E150G_XX_DISABLED,UX8E275GPTP_XX_DISABLED_XX_D_D_D_G4X8,UX8E275GPTP_XX_DISABLED_XX_D_D_G4X4_G4X4,UX12E400GPTP_XX_DISABLED_XX_D_D_D_G4X4,UX16E400GPTP_XX_DISABLED_XX_DISABLED,__BB_DONT_CARE__} */
          .tx_en                         (bb_f_ehip_tx_en),                         /* AUTOGEN_BB_e400g_25g_0_tx_en - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */
          .tx_excvr_gb_ratio_mode        (bb_f_ehip_tx_excvr_gb_ratio_mode),        /* AUTOGEN_BB_Indicate tranceiver gearbox ratio - BCM default="TX_EXCVR_GB_RATIO_MODE_DISABLED" - Legal settings are {TX_EXCVR_GB_RATIO_MODE_DISABLED,TX_EXCVR_GB_RATIO_MODE_32_33,TX_EXCVR_GB_RATIO_MODE_32_40,TX_EXCVR_GB_RATIO_MODE_32_33_X_2,TX_EXCVR_GB_RATIO_MODE_32_40_X_2,TX_EXCVR_GB_RATIO_MODE_32_33_X_4,TX_EXCVR_GB_RATIO_MODE_32_40_X_4,TX_EXCVR_GB_RATIO_MODE_32_40_X_8,TX_EXCVR_GB_RATIO_MODE_32_40_X_16,TX_EXCVR_GB_RATIO_MODE_64_80,TX_EXCVR_GB_RATIO_MODE_64_80_X_2,TX_EXCVR_GB_RATIO_MODE_64_80_X_4,TX_EXCVR_GB_RATIO_MODE_64_80_X_8,TX_EXCVR_GB_RATIO_MODE_128_160,TX_EXCVR_GB_RATIO_MODE_128_160_X_2,TX_EXCVR_GB_RATIO_MODE_128_160_X_4,__BB_DONT_CARE__} */
          .tx_primary_use                (bb_f_ehip_tx_primary_use),                /* AUTOGEN_BB_Specify primary use - BCM default="TX_PRIMARY_USE_DISABLED" - Legal settings are {TX_PRIMARY_USE_DISABLED,TX_PRIMARY_USE_ETHERNET,TX_PRIMARY_USE_DIRECT_BUNDLE,TX_PRIMARY_USE_BUNDLE_PCS,TX_PRIMARY_USE_BUNDLE_SOFT_PIPE,__BB_DONT_CARE__} */
         // .tx_word_clk_hz                ("__BB_DONT_CARE__"                      /* AUTOGEN_BB_Specify parallel clock frequency - BCM default=37'b0000000000000000000000000000000000000 */
          .rx_total_xcvr                 (bb_f_ehip_rx_total_xcvr),                 /* Specify number of phsyical transceivers used - BCM default=5'b00000 */
          .rx_xcvr_width                 (bb_f_ehip_rx_xcvr_width),                 /* Indicate transceiver width - BCM default="RX_XCVR_WIDTH_DISABLED" - Legal settings are {RX_XCVR_WIDTH_DISABLED,RX_XCVR_WIDTH_8,RX_XCVR_WIDTH_10,RX_XCVR_WIDTH_16,RX_XCVR_WIDTH_20,RX_XCVR_WIDTH_32,RX_XCVR_WIDTH_40,RX_XCVR_WIDTH_64,RX_XCVR_WIDTH_128,__BB_DONT_CARE__} */
          .silicon_rev                   (bb_f_ehip_silicon_rev),                   /* BB silicon revision - BCM default="gdra" - Legal settings are {gdra} */
          .speed_map                     (bb_f_ehip_speed_map),                     /* Indicate xcvr speed map - BCM default="SPEED_MAP_DISABLED" - Legal settings are {SPEED_MAP_DISABLED,SPEED_MAP_MAP_25G,SPEED_MAP_MAP_56G,SPEED_MAP_MAP_112G,__BB_DONT_CARE__} */
          .tx_aib_if_fifo_mode           (bb_f_ehip_tx_aib_if_fifo_mode),           /* Specify aib if fifo mode - BCM default="TX_AIB_IF_FIFO_MODE_DISABLED" - Legal settings are {TX_AIB_IF_FIFO_MODE_DISABLED,TX_AIB_IF_FIFO_MODE_PHASECOMP,TX_AIB_IF_FIFO_MODE_REGISTER,__BB_DONT_CARE__} */
          .tx_datarate                   (bin_bb_f_ehip_tx_datarate),               /* Specify datarate of link - BCM default=37'b0000000000000000000000000000000000000 */
          .tx_excvr_if_fifo_mode         (bb_f_ehip_tx_excvr_if_fifo_mode),         /* Indicate tranceiver if fifo mode - BCM default="TX_EXCVR_IF_FIFO_MODE_DISABLED" - Legal settings are {TX_EXCVR_IF_FIFO_MODE_DISABLED,TX_EXCVR_IF_FIFO_MODE_REGISTER,TX_EXCVR_IF_FIFO_MODE_ELASTIC,TX_EXCVR_IF_FIFO_MODE_PHASECOMP,__BB_DONT_CARE__} */
          .tx_fec_enable                 (bb_f_ehip_tx_fec_enable),                 /* Indicate whether RX or TX side enabled - BCM default="TX_FEC_ENABLE_DISABLED" - Legal settings are {TX_FEC_ENABLE_DISABLED,TX_FEC_ENABLE_ENABLED,__BB_DONT_CARE__} */
          .tx_pcs_mode                   (bb_f_ehip_tx_pcs_mode),                   /* Specify PCS mode - BCM default="TX_PCS_MODE_DISABLED" - Legal settings are {TX_PCS_MODE_DISABLED,TX_PCS_MODE_IEEE,TX_PCS_MODE_IEEE_FLEXE_66,TX_PCS_MODE_IEEE_OTN,TX_PCS_MODE_CONSORTIUM,TX_PCS_MODE_CONSORTIUM_FLEXE_66,TX_PCS_MODE_CONSORTIUM_OTN,__BB_DONT_CARE__} */
          .tx_total_xcvr                 (bb_f_ehip_tx_total_xcvr),                 /* Specify number of phsyical transceivers used - BCM default=5'b00000 */
          .tx_xcvr_width                 (bb_f_ehip_tx_xcvr_width),                 /* Indicate transceiver width - BCM default="TX_XCVR_WIDTH_DISABLED" - Legal settings are {TX_XCVR_WIDTH_DISABLED,TX_XCVR_WIDTH_8,TX_XCVR_WIDTH_10,TX_XCVR_WIDTH_16,TX_XCVR_WIDTH_20,TX_XCVR_WIDTH_32,TX_XCVR_WIDTH_40,TX_XCVR_WIDTH_64,TX_XCVR_WIDTH_128,__BB_DONT_CARE__} */
	  .tx_word_clk_hz                (bb_f_ehip_tx_word_clk_hz),
	  .rx_word_clk_hz                (bb_f_ehip_rx_word_clk_hz),
          .xcvr_mode                     (bb_f_ehip_xcvr_mode),                     /* Indicate transceiver mode - BCM default="XCVR_MODE_DISABLED" - Legal settings are {XCVR_MODE_DISABLED,XCVR_MODE_NRZ,XCVR_MODE_PAM4,__BB_DONT_CARE__} */
          .xcvr_type                     (bb_f_ehip_xcvr_type),                     /* Indicate transceiver type - BCM default="XCVR_TYPE_DISABLED" - Legal settings are {XCVR_TYPE_DISABLED,XCVR_TYPE_UX,XCVR_TYPE_BARAK,__BB_DONT_CARE__} */ 
       //   .mac_use_am_insert	(bb_f_ehip_mac_use_am_insert) ,
			.is_ptp_part_of_reconfig		(bb_f_ehip_is_ptp_part_of_reconfig)	,
		.is_fec_part_of_reconfig		(bb_f_ehip_is_fec_part_of_reconfig)	,
		  
		  .mac_pfc_holdoff_quanta_0      (bb_f_ehip_mac_pfc_holdoff_quanta_0  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_holdoff_quanta_1      (bb_f_ehip_mac_pfc_holdoff_quanta_1  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_holdoff_quanta_2      (bb_f_ehip_mac_pfc_holdoff_quanta_2  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_holdoff_quanta_3      (bb_f_ehip_mac_pfc_holdoff_quanta_3  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_holdoff_quanta_4      (bb_f_ehip_mac_pfc_holdoff_quanta_4  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_holdoff_quanta_5      (bb_f_ehip_mac_pfc_holdoff_quanta_5  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_holdoff_quanta_6      (bb_f_ehip_mac_pfc_holdoff_quanta_6  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_holdoff_quanta_7      (bb_f_ehip_mac_pfc_holdoff_quanta_7  ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the time between XOFF retransmissions for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_0        (bb_f_ehip_mac_pfc_pause_quanta_0    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_1        (bb_f_ehip_mac_pfc_pause_quanta_1    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_2        (bb_f_ehip_mac_pfc_pause_quanta_2    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_3        (bb_f_ehip_mac_pfc_pause_quanta_3    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_4        (bb_f_ehip_mac_pfc_pause_quanta_4    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_5        (bb_f_ehip_mac_pfc_pause_quanta_5    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_6        (bb_f_ehip_mac_pfc_pause_quanta_6    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_pfc_pause_quanta_7        (bb_f_ehip_mac_pfc_pause_quanta_7    ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the XOFF quanta in each PFC request for the corresponding queue - BCM default=16'hFFFF */
          .mac_request_tx_pause          (bb_f_ehip_mac_request_tx_pause      ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Request transmission of a TX PAUSE/PFC frame - BCM default=9'b000000000 */
          .mac_rx_max_frame_size         (bb_f_ehip_mac_rx_max_frame_size     ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Set the threshold for oversize RX packets - BCM default=16'd1518 */
          .mac_rx_pause_daddr            (bb_f_ehip_mac_rx_pause_daddr        ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Set the address used to accept RX PAUSE requests - BCM default=48'h0180C2000001 */
          .mac_tx_ipg_size               (bb_f_ehip_mac_tx_ipg_size           ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Set the TX MAC's average inter-packet gap size - BCM default="MAC_IPG_12" - Legal settings are {MAC_IPG_12,MAC_IPG_10,MAC_IPG_8,MAC_IPG_MIN,__BB_DONT_CARE__} */
          .mac_tx_max_frame_size         (bb_f_ehip_mac_tx_max_frame_size     ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Set the threshold for oversize TX packets - BCM default=16'd1518 */
          .mac_tx_pause_daddr            (bb_f_ehip_mac_tx_pause_daddr        ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Set the TX PAUSE destination address - BCM default=48'h0180C2000001 */
          .mac_tx_pause_saddr            (bb_f_ehip_mac_tx_pause_saddr        ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Set the TX PAUSE source address - BCM default=48'hE100CBFC5ADD */
          .mac_txmac_saddr               (bb_f_ehip_mac_txmac_saddr           ),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Source Address used for SADDR insertion - BCM default=48'h001122334455 */
          .mac_uniform_holdoff_quanta    (bb_f_ehip_mac_uniform_holdoff_quanta),    /* AUTOGEN_BB_AUTOUP_gdr_e4hip_mac_Control the uniform mode XOFF retransmission time - BCM default=16'hFFFF */
          .fec_802p3ck                   (bb_f_ehip_fec_802p3ck                 ), 
          .q_dl_cfg_rxbit_rollover_attr  (bb_f_ehip_q_dl_cfg_rxbit_rollover_attr)                   /* AUTOGEN_BB_Transceiver phy physical link configuration - BCM default="MAC_E25G_X1_RX_LN" - Legal settings are {MAC_E25G_X1_RX_LN,MAC_E10G_X1_RX_LN,MAC_E50G_X1_RX_LN,MAC_E50G_X2_RX_LN,MAC_E100G_X1_RX_LN,MAC_E100G_X2_RX_LN,MAC_E100G_X4_RX_LN,MAC_E200G_X2_RX_LN,MAC_E200G_X4_RX_LN,MAC_E200G_X8_RX_LN,MAC_E400G_X4_RX_LN,MAC_E400G_X8_RX_LN,__BB_DONT_CARE__} */     
         
     )
   x_bb_f_ehip
     (
      .xcvr_data_link(xcvr_data_link),
      .ip_data_link(ip_data_link),
      .pll_link(i_clk_sys),
      .avmm1_link(avmm1_link[0]) 
     );

  genvar idx_ports;
  generate
    for(idx_ports=0;idx_ports<num_ports;idx_ports=idx_ports+1) begin:per_port
       bb_m_hdpldadapt_avmm1 
         #(
		.hdpldadapt_pld_avmm1_clk_rowclk_hz (bb_m_hdpldadapt_pld_avmm1_clk_rowclk_hz)
           // .aib_fabric_pld_pma_hclk_hz                         ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_Non- Moded clock shared clock - BCM default=31'd0 */
           // .aib_fabric_pma_aib_tx_clk_hz                       ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_Moded clock TX clock - BCM default=31'd0 */
           // .hdpldadapt_avmm_avmm1_avmm_clk_scg_en              ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_AVMM1 Clock Static Clock Gating Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
           // .hdpldadapt_avmm_avmm1_nfhssi_calibratio_feature_en ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_Enables PMA channel calibration feature - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
           // .hdpldadapt_avmm_hip_mode                           ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_HIP mode - BCM default="HDPLDADAPT_AVMM_DISABLE_HIP" - Legal settings are {HDPLDADAPT_AVMM_DISABLE_HIP,HDPLDADAPT_AVMM_USER_CHNL,HDPLDADAPT_AVMM_DEBUG_CHNL,__BB_DONT_CARE__} */
           // .hdpldadapt_avmm_powermode_dc                       ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_Powermode_dc - BCM default="HDPLDADAPT_AVMM_POWERDOWN" - Legal settings are {HDPLDADAPT_AVMM_POWERDOWN,HDPLDADAPT_AVMM_POWERUP,__BB_DONT_CARE__} */
           // .hdpldadapt_sr_powermode_dc                         ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_Powermode_dc - BCM default="HDPLDADAPT_SR_POWERDOWN" - Legal settings are {HDPLDADAPT_SR_POWERDOWN,HDPLDADAPT_SR_POWERUP,__BB_DONT_CARE__} */
           // .hdpldadapt_sr_sr_parity_en                         ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_SR parity Enable - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
           // .silicon_rev                                        ("__BB_DONT_CARE__"),                   /* BB silicon revision - BCM default="fm6" - Legal settings are {fm6} */
       )
       x_bb_f_avmm1 (
         .pld_avmm1_busy_real              ( pld_avmm1_busy[idx_ports]), 
         .pld_avmm1_clk_rowclk_real        ( pld_avmm1_clk_rowclk),
         .pld_avmm1_cmdfifo_wr_full_real   ( pld_avmm1_cmdfifo_wr_full[idx_ports]),
         .pld_avmm1_cmdfifo_wr_pfull_real  ( pld_avmm1_cmdfifo_wr_pfull[idx_ports]),
         .pld_avmm1_read_real              ( pld_avmm1_read[idx_ports]),
         .pld_avmm1_readdata_real          ( pld_avmm1_readdata[idx_ports*8+:8] ),
         .pld_avmm1_readdatavalid_real     ( pld_avmm1_readdatavalid[idx_ports]),
         .pld_avmm1_reg_addr_real          ( pld_avmm1_reg_addr[idx_ports*10+:10] ),
         .pld_avmm1_request_real           ( pld_avmm1_request[idx_ports]),
         .pld_avmm1_reserved_in_real       ( pld_avmm1_reserved_in[idx_ports*9+:9] ),
         .pld_avmm1_reserved_out_real      ( pld_avmm1_reserved_out[idx_ports*3+:3] ),
         .pld_avmm1_write_real             ( pld_avmm1_write[idx_ports] ),
         .pld_avmm1_writedata_real         ( pld_avmm1_writedata[idx_ports*8+:8] ),
        // .pld_chnl_cal_done_real           ( pld_chnl_cal_done ),
         .pld_hssi_osc_transfer_en_real    ( pld_hssi_osc_transfer_en[idx_ports] ),
         .avmm1_link                       ( avmm1_link[(num_aib/num_ports)*idx_ports] )
       );
  end
endgenerate
  
   genvar idx_aib;
   generate
     for(idx_aib=0;idx_aib<num_aib;idx_aib=idx_aib+1) begin:per_aib
	localparam ETH_MODE      = "200G-4";
//localparam local_aibadapt_tx_tx_user_clk_sel  = (ETH_MODE == "400G-8" || ETH_MODE == "100G-2" || ETH_MODE == "200G-4") ? "AIBADAPT_TX_TX_USER_CLK_EHIP_DIV2" : "AIBADAPT_TX_TX_USER_CLK_EHIP" ;

       bb_f_aib
       #(
         .aibadapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass (bb_f_aibadapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass ),                   /* AUTOGEN_BB_Disable capture logic polling - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
         .aibadapt_rx_rx_pld_8g_wa_boundary_polling_bypass            (bb_f_aibadapt_rx_rx_pld_8g_wa_boundary_polling_bypass            ),                   /* AUTOGEN_BB_Disable capture logic polling - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
         .aibadapt_rx_rx_pld_pma_pcie_sw_done_polling_bypass          (bb_f_aibadapt_rx_rx_pld_pma_pcie_sw_done_polling_bypass          ),                   /* AUTOGEN_BB_Disable capture logic polling - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
         .aibadapt_rx_rx_pld_pma_reser_in_polling_bypass              (bb_f_aibadapt_rx_rx_pld_pma_reser_in_polling_bypass              ),                   /* AUTOGEN_BB_Disable capture logic polling - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
         .aibadapt_rx_rx_pld_pma_testbus_polling_bypass               (bb_f_aibadapt_rx_rx_pld_pma_testbus_polling_bypass               ),                   /* AUTOGEN_BB_Disable capture logic polling - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
         .aibadapt_rx_rx_pld_test_data_polling_bypass                 (bb_f_aibadapt_rx_rx_pld_test_data_polling_bypass                 ),                   /* AUTOGEN_BB_Disable capture logic polling - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */
         .aibadapt_rx_rx_user_clk_rst_sel                             (bb_f_aibadapt_rx_rx_user_clk_rst_sel                             ),                   /* AUTOGEN_BB_rx_user_clk div2 reset select - BCM default="AIBADAPT_RX_RX_USER_CLK_HARD_RST" - Legal settings are {AIBADAPT_RX_RX_USER_CLK_HARD_RST,AIBADAPT_RX_RX_USER_CLK_ADPT_RST,__BB_DONT_CARE__} */
         //.aibadapt_rx_rx_user_clk_sel                                 ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_rx_user_clk clock select - BCM default="AIBADAPT_RX_RX_USER_CLK_E400G" - Legal settings are {AIBADAPT_RX_RX_USER_CLK_E200G,AIBADAPT_RX_RX_USER_CLK_E200G_DIV2,AIBADAPT_RX_RX_USER_CLK_E400G,AIBADAPT_RX_RX_USER_CLK_E400G_DIV2,__BB_DONT_CARE__} */
         //FOR DIV66
		 .aibadapt_rx_rx_user_clk_sel                                  (bb_f_aib_aibadapt_rx_rx_user_clk_sel),                   /* AUTOGEN_BB_rx_user_clk clock select - BCM default="AIBADAPT_RX_RX_USER_CLK_E400G" - Legal settings are {AIBADAPT_RX_RX_USER_CLK_E200G,AIBADAPT_RX_RX_USER_CLK_E200G_DIV2,AIBADAPT_RX_RX_USER_CLK_E400G,AIBADAPT_RX_RX_USER_CLK_E400G_DIV2,__BB_DONT_CARE__} */
         .aibadapt_tx_loopback_mode                                     (bb_f_aib_aibadapt_tx_loopback_mode),   /* AUTOGEN_BB_Loopback mode - BCM default="AIBADAPT_TX_LOOPBACK_DISABLE" - Legal settings are {AIBADAPT_TX_LOOPBACK_DISABLE,AIBADAPT_TX_AIB_LOOPBACK_ENABLE,AIBADAPT_TX_ADPT_FUNC_LOOPBACK_ENABLE,AIBADAPT_TX_ADPT_DFX_LOOPBACK_ENABLE,__BB_DONT_CARE__} */
         .aibadapt_tx_sup_mode                                          (bb_f_aib_aibadapt_tx_sup_mode),        /* AUTOGEN_BB_Support mode - BCM default="AIBADAPT_TX_USER_MODE" - Legal settings are {AIBADAPT_TX_USER_MODE,AIBADAPT_TX_ADVANCED_USER_MODE,AIBADAPT_TX_ENGINEERING_MODE,__BB_DONT_CARE__} */
         .aibadapt_tx_tx_latency_src_xcvrif                           (bb_f_aibadapt_tx_tx_latency_src_xcvrif),                   /* AUTOGEN_BB_TX latency pulse select - BCM default="AIBADAPT_TX_LATENCY_PLS_E400E200" - Legal settings are {AIBADAPT_TX_LATENCY_PLS_E400E200,AIBADAPT_TX_LATENCY_PLS_XCVRIF,__BB_DONT_CARE__} */
         .aibadapt_tx_tx_user_clk_rst_sel                             (bb_f_aibadapt_tx_tx_user_clk_rst_sel),                   /* AUTOGEN_BB_tx_user_clk div2 reset select - BCM default="AIBADAPT_TX_TX_USER_CLK_HARD_RST" - Legal settings are {AIBADAPT_TX_TX_USER_CLK_HARD_RST,AIBADAPT_TX_TX_USER_CLK_ADPT_RST,__BB_DONT_CARE__} */
         //FOR DIV66
		 .aibadapt_tx_tx_user_clk_sel                                 (bb_f_aib_aibadapt_tx_tx_user_clk_sel),                   /* AUTOGEN_BB_tx_user_clk clock select - BCM default="AIBADAPT_TX_TX_USER_CLK_E400G" - Legal settings are {AIBADAPT_TX_TX_USER_CLK_E200G,AIBADAPT_TX_TX_USER_CLK_E200G_DIV2,AIBADAPT_TX */
		 //.aibadapt_tx_tx_user_clk_sel                                 ("__BB_DONT_CARE__"),                   /* AUTOGEN_BB_tx_user_clk clock select - BCM default="AIBADAPT_TX_TX_USER_CLK_E400G" - Legal settings are {AIBADAPT_TX_TX_USER_CLK_E200G,AIBADAPT_TX_TX_USER_CLK_E200G_DIV2,AIBADAPT_TX */
         .silicon_rev                                                   (bb_f_aib_silicon_rev),                /* BB silicon revision - BCM default="gdra" - Legal settings are {gdra} */
         .aibadapt_rx_rx_datapath_tb_sel                                (bb_f_aib_aibadapt_rx_rx_datapath_tb_sel),
		 .aib_hssi_tx_transfer_clk_hz					(bb_f_aib_hssi_tx_transfer_clk_hz),
		 .aib_hssi_rx_transfer_clk_hz					(bb_f_aib_hssi_rx_transfer_clk_hz),
		 .aib_tx_user_clk_hz								(bb_f_aib_tx_user_clk_hz),
		 .aib_rx_user_clk_hz								(bb_f_aib_rx_user_clk_hz)
       )
       x_bb_f_aib
       (
         .ip_data_link(ip_data_link[idx_aib]),
         .aib_rx_data_link(aib_rx_data_link[idx_aib]),
         .aib_tx_data_link(aib_tx_data_link[idx_aib]),
         .avmm1_link(avmm1_link[idx_aib])
        );

        bb_m_aib_rx
        #(
           .silicon_rev                                (bb_m_aib_rx_silicon_rev)                                  /* BB silicon revision - BCM default="gdra" - Legal settings are {gdra} */
           //.aib_dllstr_align_st_dftmuxsel              (bb_m_aib_rx_aib_dllstr_align_st_dftmuxsel),
           //.dft_hssitestip_dll_dcc_en                  (bb_m_aib_rx_dft_hssitestip_dll_dcc_en    ),
           //.op_mode                                    (bb_m_aib_rx_op_mode                      ),
           //.redundancy_en                              (bb_m_aib_rx_redundancy_en                ),
           //.sup_mode                                   (bb_m_aib_rx_sup_mode                     )
        )
        x_bb_m_aib_rx
        (
          .aib_rx_data_link(aib_rx_data_link[idx_aib]),
          .adapt_rx_data_link(adapt_rx_data_link[idx_aib]),
          .avmm1_link(avmm1_link[idx_aib])
        );
 
        bb_m_aib_tx
        #(
         .silicon_rev               (bb_m_aib_tx_silicon_rev),                                /* BB silicon revision - BCM default="gdra" - Legal settings are {gdra} */
         //.aib_tx_dcc_dft            (bb_m_aib_tx_aib_tx_dcc_dft           ),
         //.aib_tx_dcc_dft_sel        (bb_m_aib_tx_aib_tx_dcc_dft_sel       ),
         //.aib_tx_dcc_st_dftmuxsel   (bb_m_aib_tx_aib_tx_dcc_st_dftmuxsel  ),
         //.dfd_dll_dcc_en            (bb_m_aib_tx_dfd_dll_dcc_en           ),
         //.dft_hssitestip_dll_dcc_en (bb_m_aib_tx_dft_hssitestip_dll_dcc_en),
         //.op_mode                   (bb_m_aib_tx_op_mode                  ),
         //.redundancy_en             (bb_m_aib_tx_redundancy_en            ),
         .sup_mode                  (bb_m_aib_tx_sup_mode                 )
        )
        x_bb_m_aib_tx
        (
          .aib_tx_data_link(aib_tx_data_link[idx_aib]),
          .adapt_tx_data_link(adapt_tx_data_link[idx_aib]),
          .avmm1_link(avmm1_link[idx_aib])
        );
  
        bb_m_hdpldadapt_rx
        #(
          .silicon_rev                                               (bb_m_hdpldadapt_rx_silicon_rev),                                               /* BB silicon revision - BCM default="fm6" - Legal settings are {fm6} */
          .fifo_mode                             (bb_m_hdpldadapt_rx_fifo_mode                            ),
          .fifo_width                            (bb_m_hdpldadapt_rx_fifo_width                           ), 
             .hdpldadapt_pld_rx_clk1_dcm_hz         (bb_m_hdpldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz        ), 
            .hdpldadapt_speed_grade                (bb_m_hdpldadapt_rx_hdpldadapt_speed_grade               ), 
          .pld_clk1_sel                          (bb_m_hdpldadapt_rx_pld_clk1_sel                      )
           )
        x_bb_m_hdpldadapt_rx
        (
     
          .ptp_master_link                                 (),                              // Left open since this is the AIB in the ETH data-path not in PTP
          .ptp_pairing_link                                (),                              // Left open since this is the AIB in the ETH data-path not in PTP
          .ptp_slave_link                                  (ptp_link),                      // Connects to the PTP AIB6 ptp_master_link
          .placement_virtual                               (ptp_placement_virtual[idx_aib]),    // Connects to the ETH SIP placement_virtual
          .pld_hssi_rx_transfer_en_real                    (pld_hssi_rx_transfer_en[23-idx_aib]),
          .pld_rx_fifo_ready_real 	                   (pld_rx_fifo_ready[23-idx_aib]),
	  .pld_10g_krfec_rx_blk_lock_real                  (),
          .pld_10g_krfec_rx_diag_data_status_real          (hdpldadapt_out_link[idx_aib][0]), // o_rx_rst_n
          .pld_10g_krfec_rx_frame_real                     (),
          .pld_10g_rx_clr_ber_count_real                   (),
          .pld_10g_rx_crc32_err_real                       (),
          .pld_10g_rx_frame_lock_real                      (),
          .pld_10g_rx_hi_ber_real                          (),
          .pld_8g_a1a2_k1k2_flag_real                      (hdpldadapt_out_link[idx_aib][4:1]), // pcs_internal_error, local_fault, remote_fault and pause,
          .pld_8g_a1a2_size_real                           (),
          .pld_8g_bitloc_rev_en_real                       (),
          .pld_8g_byte_rev_en_real                         (),
          .pld_8g_eidleinfersel_real                       (),
          .pld_8g_empty_rmf_real                           (hdpldadapt_out_link[idx_aib][5]), //o_hi_ber
          .pld_8g_encdt_real                               (),
          .pld_8g_full_rmf_real                            (hdpldadapt_out_link[idx_aib][6]), // o_rx_pcs_fully_aligned
          .pld_8g_rxelecidle_real                          (),
          .pld_8g_signal_detect_out_real                   (), 
          .pld_8g_wa_boundary_real                         (hdpldadapt_out_link[idx_aib][11:7]), // o_hip_ready, o_tx_rst_n, o_rx_block_lock, o_rx_dsk_done and o_rx_am_lock
          .pld_aib_fabric_rx_dll_lock_req_real             (),
          .pld_aib_hssi_rx_dcd_cal_req_real                (),
          .pld_bitslip_real                                (),
          .pld_fabric_asn_dll_lock_en_real                 (),
          .pld_fsr_load_real                               (),
          .pld_hssi_asn_dll_lock_en_real                   (),
          .pld_ltr_real                                    (),
          .pld_pcs_rx_clk_out1_dcm_real                    (hdpldadapt_out_link[idx_aib][13]),  //rec_clk_div66
          .pld_pcs_rx_clk_out1_hioint_real                 (),
          .pld_pcs_rx_clk_out2_dcm_real                    (hdpldadapt_out_link[idx_aib][12]),  //rec_clk_div64
          .pld_pcs_rx_clk_out2_hioint_real                 (),
          .pld_pma_adapt_done_real                         (),
          .pld_pma_adapt_start_real                        (),
          .pld_pma_coreclkin_rowclk_real                   (),
          .pld_pma_early_eios_real                         (),
          .pld_pma_eye_monitor_real                        (),
          .pld_pma_hclk_hioint_real                        (),
          .pld_pma_internal_clk1_hioint_real               (),
          .pld_pma_internal_clk2_hioint_real               (),
          .pld_pma_ltd_b_real                              (),
          .pld_pma_pcie_sw_done_real                       (),
          .pld_pma_pfdmode_lock_real                       (),
          .pld_pma_ppm_lock_real                           (i_stats_snapshot_aib[idx_aib]), //i_take_snapshot SSR input
          .pld_pma_reserved_in_real                        (hdpldadapt_out_link[idx_aib][18:14]),  //o_rx_pfc[6:2]
          .pld_pma_reserved_out_real                       (),
          .pld_pma_rs_lpbk_b_real                          (),
          .pld_pma_rx_detect_valid_real                    (),
          .pld_pma_rx_found_real                           (hdpldadapt_out_link[idx_aib][19]), // o_rx_pfc[1]
          .pld_pma_rxpll_lock_real                         (),
          .pld_pma_signal_ok_real                          (hdpldadapt_out_link[idx_aib][20]), // o_rx_pfc[0]
          .pld_pma_testbus_real                            (),
          .pld_pmaif_rxclkslip_real                        (),
          .pld_polinv_rx_real                              (),
          .pld_rx_clk1_dcm_real                            (i_clk_rx), 
          .pld_rx_clk1_rowclk_real                         (),
          .pld_rx_clk2_rowclk_real                         (),
          .pld_rx_fabric_align_done_real                   (),
          .pld_rx_fabric_data_out_real                     (rx_parallel_data[idx_aib][79:0]),
          .pld_rx_fabric_fifo_align_clr_real               (),
          .pld_rx_fabric_fifo_del_real                     (),
          .pld_rx_fabric_fifo_empty_real                   (),
          .pld_rx_fabric_fifo_full_real                    (),
          .pld_rx_fabric_fifo_insert_real                  (),
          .pld_rx_fabric_fifo_latency_pulse_real           (),
          .pld_rx_fabric_fifo_pempty_real                  (),
          .pld_rx_fabric_fifo_pfull_real                   (),
          .pld_rx_fabric_fifo_rd_en_real                   (),
          .pld_rx_fifo_latency_adj_en_real                 (),
          .pld_rx_hssi_fifo_empty_real                     (),
          .pld_rx_hssi_fifo_full_real                      (),
          .pld_rx_hssi_fifo_latency_pulse_real             (),
          .pld_rx_prbs_done_real                           (),
          .pld_rx_prbs_err_real                            (),
          .pld_rx_prbs_err_clr_real                        (),
          .pld_rx_ssr_reserved_in_real                     (),
          .pld_rx_ssr_reserved_out_real                    (),
          .pld_sclk1_rowclk_real                           (),
          .pld_sclk2_rowclk_real                           (),
          .pld_ssr_load_real                               (),
          .pld_syncsm_en_real                              (),
          .pld_test_data_real                              (),
          .adapt_rx_data_link                              (adapt_rx_data_link[idx_aib]),
          .avmm1_link                                      (avmm1_link[idx_aib])
    );

        bb_m_hdpldadapt_tx
        #(
          .silicon_rev                          (bb_m_hdpldadapt_tx_silicon_rev),                        /* BB silicon revision - BCM default="fm6" - Legal settings are {fm6} */
          .duplex_mode                           (bb_m_hdpldadapt_tx_duplex_mode                          ), 
          .fifo_mode                             (bb_m_hdpldadapt_tx_fifo_mode                            ), 
          .fifo_width                            (bb_m_hdpldadapt_tx_fifo_width                           ), 
         .hdpldadapt_pld_tx_clk1_dcm_hz         (bb_m_hdpldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz        ), 
                 .hdpldadapt_speed_grade         (bb_m_hdpldadapt_tx_hdpldadapt_speed_grade               ), 
          .pld_clk1_sel                          (bb_m_hdpldadapt_tx_pld_clk1_sel                         ) 
        	  )
        x_bb_m_hdpldadapt_tx
        (
          .pld_fabric_tx_transfer_en_real                     (pld_fabric_tx_transfer_en[23-idx_aib]),
          .pld_tx_fifo_ready_real	                      (pld_tx_fifo_ready[23-idx_aib]), 
		  .hip_aib_ssr_in_real                                (hdpldadapt_in_link[idx_aib][39:0]),
          .hip_aib_fsr_out_real                               (),
          .hip_aib_ssr_out_real                               (hdpldadapt_out_link[idx_aib][31:24]), // bit1-pcs_rx_sf, bit3-fec_not_locked, bit5-fec_not_align
          .pld_10g_krfec_tx_frame_real                        (),
          .pld_10g_tx_bitslip_real                            (),
          .pld_10g_tx_burst_en_real                           (),
          .pld_10g_tx_burst_en_exe_real                       (),
          .pld_10g_tx_diag_status_real                        (),
          .pld_10g_tx_wordslip_real                           (),
          .pld_8g_tx_boundary_sel_real                        (),
          .pld_aib_fabric_tx_dcd_cal_req_real                 (),
          .pld_aib_hssi_tx_dcd_cal_done_real                  (),
          .pld_aib_hssi_tx_dcd_cal_req_real                   (),
          .pld_aib_hssi_tx_dll_lock_req_real                  (),
          .pld_fpll_shared_direct_async_in_dcm_real           (),
          .pld_fpll_shared_direct_async_in_rowclk_real        (),
          .pld_fpll_shared_direct_async_out_real              (),
          .pld_fpll_shared_direct_async_out_dcm_real          (),
          .pld_fpll_shared_direct_async_out_hioint_real       (),
          .pld_krfec_tx_alignment_real                        (hdpldadapt_out_link[idx_aib][21]), // o_rx_pfc[7]
          .pld_pcs_tx_clk_out1_dcm_real                       (hdpldadapt_out_link[idx_aib][22]), // o_pll_clk 
          .pld_pcs_tx_clk_out1_hioint_real                    (),
          .pld_pcs_tx_clk_out2_dcm_real                       (hdpldadapt_out_link[idx_aib][23]), // o_clk_tx_div
          .pld_pcs_tx_clk_out2_hioint_real                    (),
          .pld_pma_csr_test_dis_real                          (),
          .pld_pma_fpll_clk0bad_real                          (),
          .pld_pma_fpll_clk1bad_real                          (),
          .pld_pma_fpll_clksel_real                           (),
          .pld_pma_fpll_cnt_sel_real                          (),
          .pld_pma_fpll_extswitch_real                        (),
          .pld_pma_fpll_lc_csr_test_dis_real                  (),
          .pld_pma_fpll_num_phase_shifts_real                 (),
          .pld_pma_fpll_pfden_real                            (),
          .pld_pma_fpll_phase_done_real                       (),
          .pld_pma_fpll_up_dn_lc_lf_rstn_real                 (),
          .pld_pma_nrpi_freeze_real                           (),
          .pld_pma_rx_qpi_pullup_real                         (),
          .pld_pma_tx_bitslip_real                            (),
          .pld_pma_tx_qpi_pulldn_real                         (),
          .pld_pma_tx_qpi_pullup_real                         (),
          .pld_pmaif_mask_tx_pll_real                         (),
          .pld_polinv_tx_real                                 (),
          .pld_tx_clk1_dcm_real                               (i_clk_tx),
          .pld_tx_clk1_rowclk_real                            (),
          .pld_tx_clk2_dcm_real                               (),
          .pld_tx_clk2_rowclk_real                            (),
          .pld_tx_fabric_data_in_real                         (tx_parallel_data[idx_aib][79:0]),
          .pld_tx_fabric_fifo_empty_real                      (),
          .pld_tx_fabric_fifo_full_real                       (),
          .pld_tx_fabric_fifo_latency_pulse_real              (),
          .pld_tx_fabric_fifo_pempty_real                     (),
          .pld_tx_fabric_fifo_pfull_real                      (),
          .pld_tx_fifo_latency_adj_en_real                    (),
          .pld_tx_hssi_align_done_real                        (),
          .pld_tx_hssi_fifo_empty_real                        (),
          .pld_tx_hssi_fifo_full_real                         (),
          .pld_tx_hssi_fifo_latency_pulse_real                (),
          .pld_tx_ssr_reserved_in_real                        (),
          .pld_tx_ssr_reserved_out_real                       (),
          .pld_txelecidle_real                                (),
          .adapt_tx_data_link                                 (adapt_tx_data_link[idx_aib]),
          .avmm1_link                                         (avmm1_link[idx_aib])
        );
    end
  endgenerate


wire [num_xcvr-1:0] src_rx_virtual;
wire [num_xcvr-1:0] src_tx_virtual;

	//link indexing for transceiver is in down below
	genvar idx_xcvr;
  generate

    for(idx_xcvr=0;idx_xcvr<num_xcvr;idx_xcvr=idx_xcvr+1) begin:per_xcvr
      
      if (1) begin //there needs to be a condition to check for FGT1.0 vs FGT2.0


//PTP workaround
localparam PTP_ENABLE                                            = 0;
localparam FLEXE_DL_ENABLE 					 = 0;
localparam FLEXE_DL_ML                                           = 0;
localparam local_bb_f_ux_dl_enable                               = (PTP_ENABLE == 1 || FLEXE_DL_ENABLE == 1 || FLEXE_DL_ML == 1) ? bb_f_ux_dl_enable : "DISABLE";
//div66 woraround
localparam ETH_MODE                                              = "200G-4";
//localparam local_bb_f_ux_synth_lc_fast_tx_postdiv_counter     =  (ETH_MODE == "400G-8" || ETH_MODE == "200G-4" || ETH_MODE == "100G-2" || ETH_MODE == "50G-1") ? 17: 33 ; //div 66 not working for eth13
//localparam local_bb_f_ux_synth_lc_fast_f_tx_postdiv_hz        = (ETH_MODE == "400G-8" || ETH_MODE == "200G-4" || ETH_MODE == "100G-2" || ETH_MODE == "50G-1") ? 781250000: 390625000 ;
localparam local_bb_f_ux_synth_lc_fast_rx_postdiv_counter  = (0 == 0)? "__BB_DONT_CARE__" : bb_f_ux_synth_lc_fast_rx_postdiv_counter;
localparam local_bb_f_ux_synth_lc_med_rx_postdiv_counter  = (0 == 0)? "__BB_DONT_CARE__" : bb_f_ux_synth_lc_med_rx_postdiv_counter;
localparam local_bb_f_ux_synth_lc_slow_rx_postdiv_counter  = (0 == 0)? "__BB_DONT_CARE__" : bb_f_ux_synth_lc_slow_rx_postdiv_counter;

localparam local_bb_f_ux_cdr_clkdiv_en = (idx_xcvr == 0)? bb_f_ux_cdr_clkdiv_en : "DISABLE";

      bb_f_ux
        #(
                 .cdr_bw_sel                             (bb_f_ux_cdr_bw_sel                            ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="CDR_BW_SEL_LOW" - Legal settings are {CDR_BW_SEL_LOW,CDR_BW_SEL_MEDIUM,CDR_BW_SEL_HIGH,CDR_BW_SEL_DISABLED,__BB_DONT_CARE__} */,
                 .cdr_clkdiv_en                          (local_bb_f_ux_cdr_clkdiv_en                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .cdr_f_out_hz                           (bin_bb_f_ux_cdr_f_out_hz                      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .cdr_f_vco_hz                           (bb_f_ux_cdr_f_vco_hz),
                 .tx_invert_p_and_n                      (bb_f_ux_tx_invert_p_and_n),
                 .rx_invert_p_and_n                      (bb_f_ux_rx_invert_p_and_n),
                 .fw_clearing_regsiter_attr              (bb_f_ux_rx_fw_clearing_regsiter_attr),
                 .bypass_on_chip_ac_cap                  (bb_f_ux_rx_bypass_on_chip_ac_cap),
                 .vcm_greater_than_0p35v_with_bypass_on_chip_ac_cap (bb_f_ux_rx_vcm_greater_than_0p35v_with_bypass_on_chip_ac_cap),
                 .cdr_f_postdiv_hz                       (bb_f_ux_cdr_f_postdiv_hz                      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .cdr_f_ref_hz                           (bb_f_ux_cdr_f_ref_hz                          ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .cdr_l_counter                          (bb_f_ux_cdr_l_counter                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .cdr_m_counter                          (bb_f_ux_cdr_m_counter                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .cdr_n_counter                          (bb_f_ux_cdr_n_counter                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .cdr_postdiv_counter                    (bb_f_ux_cdr_postdiv_counter                   ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .cdr_postdiv_fractional_en              (bb_f_ux_cdr_postdiv_fractional_en             ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .cdr_ppm_driftcount                     (bb_f_ux_cdr_ppm_driftcount                    ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .master_pll_pair_mode                   (bb_f_ux_master_pll_pair_mode                  ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */,
                 .core_pll                               (bb_f_ux_core_pll                              ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="CORE_PLL_DISABLED" - Legal settings are {CORE_PLL_DISABLED,CORE_PLL_SLOW,CORE_PLL_MED,CORE_PLL_FAST,__BB_DONT_CARE__} */,
                 .dl_enable                              (local_bb_f_ux_dl_enable                             ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .dpma_refclk_source                     (bb_f_ux_dpma_refclk_source                    ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DPMA_REFCLK_SOURCE_RX" - Legal settings are {DPMA_REFCLK_SOURCE_RX,DPMA_REFCLK_SOURCE_EXTERNAL,__BB_DONT_CARE__} */,
                 .enable_port_control_of_cdr_ltr_ltd     (bb_f_ux_enable_port_control_of_cdr_ltr_ltd    ),
                 .enable_static_refclk_network           (bb_f_ux_enable_static_refclk_network          ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */,
                 .engineered_link_mode                   (bb_f_ux_engineered_link_mode                  ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .flux_mode                              (bb_f_ux_flux_mode                             ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="FLUX_MODE_DISABLED" - Legal settings are {FLUX_MODE_DISABLED,FLUX_MODE_CPRI,FLUX_MODE_ANLT,FLUX_MODE_BYPASS,__BB_DONT_CARE__} */,
                 .fec_used                               (bb_f_ux_fec_used                              ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_Virtual attribute for power down mode - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */,
                 .force_cdr_ltd                          (bb_f_ux_force_cdr_ltd                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .force_cdr_ltr                          (bb_f_ux_force_cdr_ltr                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .force_refclk_power_to_specific_value   (bb_f_ux_force_refclk_power_to_specific_value  ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="FORCE_REFCLK_POWER_TO_SPECIFIC_VALUE_NONE" - Legal settings are {FORCE_REFCLK_POWER_TO_SPECIFIC_VALUE_NONE,FORCE_REFCLK_POWER_TO_SPECIFIC_VALUE_LOW_POWER,FORCE_REFCLK_POWER_TO_SPECIFIC_VALUE_HIGH_POWER,__BB_DONT_CARE__} */,
                 .full_quad_master_pll_mode              (bb_f_ux_full_quad_master_pll_mode             ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */,
                 .loopback_mode                          (bb_f_ux_loopback_mode                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="LOOPBACK_MODE_DISABLED" - Legal settings are {LOOPBACK_MODE_DISABLED,LOOPBACK_MODE_SERIAL_LOOPBACK,LOOPBACK_MODE_PARALLEL_LOOPBACK,LOOPBACK_MODE_REVERSE_PARALLEL_LOOPBACK,LOOPBACK_MODE_PAD_LOOPBACK,LOOPBACK_MODE_PARALLEL_PRE_SERDES_LOOPBACK,__BB_DONT_CARE__} */,
                 .master_sup_mode                        (bb_f_ux_master_sup_mode                       ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="MASTER_SUP_MODE_USER_MODE" - Legal settings are {MASTER_SUP_MODE_USER_MODE,MASTER_SUP_MODE_ADVANCED_USER_MODE,MASTER_SUP_MODE_ENGINEERING_MODE,__BB_DONT_CARE__} */,
                 .prbs_gen_en                            (bb_f_ux_prbs_gen_en                           ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .prbs_mon_en                            (bb_f_ux_prbs_mon_en                           ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .prbs_pattern                           (bb_f_ux_prbs_pattern                          ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .quad_pcie_mode                         (bb_f_ux_quad_pcie_mode                        ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="FALSE" - Legal settings are {FALSE,TRUE,__BB_DONT_CARE__} */,
                 .rx_adapt_mode                          (bb_f_ux_rx_adapt_mode                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="RX_ADAPT_MODE_NO_EQ" - Legal settings are {RX_ADAPT_MODE_NO_EQ,RX_ADAPT_MODE_STATIC_EQ,RX_ADAPT_MODE_UX_RX_ADAPT,RX_ADAPT_MODE_FLUX_RX_ADAPT,RX_ADAPT_MODE_DISABLED,__BB_DONT_CARE__} */,
                 .rx_bond_size                           (bb_f_ux_rx_bond_size                          ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="RX_BOND_SIZE_1" - Legal settings are {RX_BOND_SIZE_1,RX_BOND_SIZE_2,RX_BOND_SIZE_4,RX_BOND_SIZE_6,RX_BOND_SIZE_8,RX_BOND_SIZE_10,RX_BOND_SIZE_12,RX_BOND_SIZE_16,RX_BOND_SIZE_DISABLED,__BB_DONT_CARE__} */,
                 .rx_line_rate_bps                       (bin_bb_f_ux_rx_line_rate_bps                  ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
//               .rx_over_sample                         (bb_f_ux_rx_over_sample                        ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="RX_OVER_SAMPLE_1" - Legal settings are {RX_OVER_SAMPLE_1,RX_OVER_SAMPLE_2,RX_OVER_SAMPLE_4,RX_OVER_SAMPLE_8,RX_OVER_SAMPLE_DISABLED,__BB_DONT_CARE__} */,
                 .rx_pam4_graycode_en                    (bb_f_ux_rx_pam4_graycode_en                   ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .rx_pam4_precode_en                     (bb_f_ux_rx_pam4_precode_en                    ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .rx_protocol                            (bb_f_ux_rx_protocol                           ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="RX_PROTOCOL_DISABLED" - Legal settings are {RX_PROTOCOL_DISABLED,RX_PROTOCOL_HARD_PCIE,RX_PROTOCOL_SOFT_PIPE,RX_PROTOCOL_FEC_PCS_MAC,RX_PROTOCOL_PMA_DIRECT_SYS_CLK,RX_PROTOCOL_PMA_DIRECT_XCVR_CLK,__BB_DONT_CARE__} */,
                 .tx_protocol_hard_pcie_lowloss          (bb_f_ux_tx_protocol_hard_pcie_lowloss         )/* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .rx_protocol_hard_pcie_lowloss          (bb_f_ux_rx_protocol_hard_pcie_lowloss         )/* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .rx_user_clk_en                         (bb_f_ux_rx_user_clk_en                        ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .rx_which_lane_to_copy                  (bb_f_ux_rx_which_lane_to_copy                 ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="RX_WHICH_LANE_TO_COPY_SELF" - Legal settings are {RX_WHICH_LANE_TO_COPY_SELF,RX_WHICH_LANE_TO_COPY_L0,RX_WHICH_LANE_TO_COPY_L1,RX_WHICH_LANE_TO_COPY_L2,RX_WHICH_LANE_TO_COPY_DISABLED,__BB_DONT_CARE__} */,
                 .rx_width                               (bb_f_ux_rx_width                              ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="RX_WIDTH_32" - Legal settings are {RX_WIDTH_32,RX_WIDTH_8,RX_WIDTH_10,RX_WIDTH_16,RX_WIDTH_20,RX_WIDTH_64,RX_WIDTH_DISABLED,__BB_DONT_CARE__} */,
                 .silicon_rev                            (bb_f_ux_silicon_rev                           ) /* BB silicon revision - BCM default="gdra" - Legal settings are {gdra} */,
                .sim_mode                               (bb_f_ux_sim_mode                              ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
	                 .squelch_detect                         (bb_f_ux_squelch_detect                        ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .sr_custom                              (bb_f_ux_sr_custom                             ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_Virtual attribute for power down mode - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .standalone_core_clk_en                 (bb_f_ux_standalone_core_clk_en                ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_Virtual attribute for power down mode - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .standalone_core_clk_mux                (bb_f_ux_standalone_core_clk_mux               ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_Virtual attribute for power down mode - BCM default="STANDALONE_CORE_CLK_MUX_SLOW_MED" - Legal settings are {STANDALONE_CORE_CLK_MUX_SLOW_MED,STANDALONE_CORE_CLK_MUX_FAST,__BB_DONT_CARE__} */,
                 .sup_mode                               (bb_f_ux_sup_mode                              ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="SUP_MODE_USER_MODE" - Legal settings are {SUP_MODE_USER_MODE,SUP_MODE_ADVANCED_USER_MODE,SUP_MODE_ENGINEERING_MODE,__BB_DONT_CARE__} */,
//                 .sv_0_31                                (bb_f_ux_sv_0_31                               ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxovrcdrlock2dataen_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_1_1                                 (bb_f_ux_sv_1_1                                ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxterm_hiz_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_andme_en_lx_a                       (bb_f_ux_sv_andme_en_lx_a                      ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_andme_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_lfps_en_lx_nt                       (bb_f_ux_sv_lfps_en_lx_nt                      ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_lfps_en_lx_nt - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_pcie_l1d1_lx_a                      (bb_f_ux_sv_pcie_l1d1_lx_a                     ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_pcie_l1d1_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_pcie_l1d2_lx_a                      (bb_f_ux_sv_pcie_l1d2_lx_a                     ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_pcie_l1d2_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_pcs_lock                            (bb_f_ux_sv_pcs_lock                           ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_pcs_lock - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rx_lx_b_a                           (bb_f_ux_sv_rx_lx_b_a                          ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rx_lx_b_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxbist_en_lx_a                      (bb_f_ux_sv_rxbist_en_lx_a                     ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxbist_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxeiosdetectstat_lx_a               (bb_f_ux_sv_rxeiosdetectstat_lx_a              ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxeiosdetectstat_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxeq_clr_lx_a                       (bb_f_ux_sv_rxeq_clr_lx_a                      ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxeq_clr_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxeq_start_lx_a                     (bb_f_ux_sv_rxeq_start_lx_a                    ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxeq_start_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxeq_static_en_lx_a                 (bb_f_ux_sv_rxeq_static_en_lx_a                ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxeq_static_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxeyediag_start_lx_a                (bb_f_ux_sv_rxeyediag_start_lx_a               ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxeyediag_start_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxovrcdrlock2dataen_lx_a            (bb_f_ux_sv_rxovrcdrlock2dataen_lx_a           ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxovrcdrlock2dataen_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_rxterm_hiz_en_lx_a                  (bb_f_ux_sv_rxterm_hiz_en_lx_a                 ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_rxterm_hiz_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_tx_lx_b_a                           (bb_f_ux_sv_tx_lx_b_a                          ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_tx_lx_b_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_txbeacon_lx_a                       (bb_f_ux_sv_txbeacon_lx_a                      ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_txbeacon_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_txbist_en_lx_a                      (bb_f_ux_sv_txbist_en_lx_a                     ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_txbist_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .sv_txdetectrx_req_lx_a                 (bb_f_ux_sv_txdetectrx_req_lx_a                ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_sv_txdetectrx_req_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .synth_lc_fast_f_out_hz                 (bb_f_ux_synth_lc_fast_f_out_hz                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_f_ref_hz                 (bb_f_ux_synth_lc_fast_f_ref_hz                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_f_rx_postdiv_hz          (bb_f_ux_synth_lc_fast_f_rx_postdiv_hz         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_f_tx_postdiv_hz          (bb_f_ux_synth_lc_fast_f_tx_postdiv_hz         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_fractional_en            (bb_f_ux_synth_lc_fast_fractional_en           ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
		 .synth_lc_fast_f_vco_hz	(bb_f_ux_synth_lc_fast_f_vco_hz),
                 .synth_lc_fast_k_counter                (bb_f_ux_synth_lc_fast_k_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_l_counter                (bb_f_ux_synth_lc_fast_l_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_m_counter                (bb_f_ux_synth_lc_fast_m_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_n_counter                (bb_f_ux_synth_lc_fast_n_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_primary_use              (bb_f_ux_synth_lc_fast_primary_use             ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="SYNTH_LC_FAST_PRIMARY_USE_DISABLED" - Legal settings are {SYNTH_LC_FAST_PRIMARY_USE_DISABLED,SYNTH_LC_FAST_PRIMARY_USE_TX,SYNTH_LC_FAST_PRIMARY_USE_CORE,__BB_DONT_CARE__} */,
                 .synth_lc_fast_rx_postdiv_counter       (local_bb_f_ux_synth_lc_fast_rx_postdiv_counter      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_tx_postdiv_counter       (bb_f_ux_synth_lc_fast_tx_postdiv_counter      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_fast_tx_postdiv_fractional_en (bb_f_ux_synth_lc_fast_tx_postdiv_fractional_en) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .synth_lc_med_f_out_hz                  (bb_f_ux_synth_lc_med_f_out_hz                 ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_f_ref_hz                  (bb_f_ux_synth_lc_med_f_ref_hz                 ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_f_rx_postdiv_hz           (bb_f_ux_synth_lc_med_f_rx_postdiv_hz          ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_f_tx_postdiv_hz           (bb_f_ux_synth_lc_med_f_tx_postdiv_hz          ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_fractional_en             (bb_f_ux_synth_lc_med_fractional_en            ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
		  .synth_lc_med_f_vco_hz	(bb_f_ux_synth_lc_med_f_vco_hz),

                 .synth_lc_med_k_counter                 (bb_f_ux_synth_lc_med_k_counter                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_l_counter                 (bb_f_ux_synth_lc_med_l_counter                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_m_counter                 (bb_f_ux_synth_lc_med_m_counter                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_n_counter                 (bb_f_ux_synth_lc_med_n_counter                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_primary_use               (bb_f_ux_synth_lc_med_primary_use              ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="SYNTH_LC_MED_PRIMARY_USE_DISABLED" - Legal settings are {SYNTH_LC_MED_PRIMARY_USE_DISABLED,SYNTH_LC_MED_PRIMARY_USE_TX,SYNTH_LC_MED_PRIMARY_USE_CORE,__BB_DONT_CARE__} */,
                 .synth_lc_med_rx_postdiv_counter        (local_bb_f_ux_synth_lc_med_rx_postdiv_counter       ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_tx_postdiv_counter        (bb_f_ux_synth_lc_med_tx_postdiv_counter       ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_med_tx_postdiv_fractional_en  (bb_f_ux_synth_lc_med_tx_postdiv_fractional_en ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .synth_lc_slow_f_out_hz                 (bb_f_ux_synth_lc_slow_f_out_hz                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_f_ref_hz                 (bb_f_ux_synth_lc_slow_f_ref_hz                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_f_rx_postdiv_hz          (bb_f_ux_synth_lc_slow_f_rx_postdiv_hz         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_f_tx_postdiv_hz          (bb_f_ux_synth_lc_slow_f_tx_postdiv_hz         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_fractional_en            (bb_f_ux_synth_lc_slow_fractional_en           ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
		  .synth_lc_slow_f_vco_hz	(bb_f_ux_synth_lc_slow_f_vco_hz),
                 .synth_lc_slow_k_counter                (bb_f_ux_synth_lc_slow_k_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_l_counter                (bb_f_ux_synth_lc_slow_l_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_m_counter                (bb_f_ux_synth_lc_slow_m_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_n_counter                (bb_f_ux_synth_lc_slow_n_counter               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_primary_use              (bb_f_ux_synth_lc_slow_primary_use             ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="SYNTH_LC_SLOW_PRIMARY_USE_DISABLED" - Legal settings are {SYNTH_LC_SLOW_PRIMARY_USE_DISABLED,SYNTH_LC_SLOW_PRIMARY_USE_TX,SYNTH_LC_SLOW_PRIMARY_USE_CORE,__BB_DONT_CARE__} */,
                 .synth_lc_slow_rx_postdiv_counter       (local_bb_f_ux_synth_lc_slow_rx_postdiv_counter      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_tx_postdiv_counter       (bb_f_ux_synth_lc_slow_tx_postdiv_counter      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
                 .synth_lc_slow_tx_postdiv_fractional_en (bb_f_ux_synth_lc_slow_tx_postdiv_fractional_en) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .tx_bond_size                           (bb_f_ux_tx_bond_size                          ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_BOND_SIZE_1" - Legal settings are {TX_BOND_SIZE_1,TX_BOND_SIZE_2,TX_BOND_SIZE_4,TX_BOND_SIZE_6,TX_BOND_SIZE_8,TX_BOND_SIZE_10,TX_BOND_SIZE_12,TX_BOND_SIZE_16,TX_BOND_SIZE_DISABLED,__BB_DONT_CARE__} */,
                 .tx_line_rate_bps                       (bin_bb_f_ux_tx_line_rate_bps                  ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
//                 .tx_o_clk_e2_hz                         (bb_f_ux_tx_o_clk_e2_hz                        ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
//                 .tx_o_clk_e4_hz                         (bb_f_ux_tx_o_clk_e4_hz                        ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default=0 */,
//               .tx_over_sample                         (bb_f_ux_tx_over_sample                        ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_OVER_SAMPLE_1" - Legal settings are {TX_OVER_SAMPLE_1,TX_OVER_SAMPLE_2,TX_OVER_SAMPLE_4,TX_OVER_SAMPLE_8,TX_OVER_SAMPLE_DISABLED,__BB_DONT_CARE__} */,
                 .tx_pam4_graycode_en                    (bb_f_ux_tx_pam4_graycode_en                   ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .tx_pam4_precode_en                     (bb_f_ux_tx_pam4_precode_en                    ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .tx_pll                                 (bb_f_ux_tx_pll                                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_PLL_DISABLED" - Legal settings are {TX_PLL_DISABLED,TX_PLL_SLOW,TX_PLL_MED,TX_PLL_FAST,__BB_DONT_CARE__} */,
                 .tx_pll_bw_sel                          (bb_f_ux_tx_pll_bw_sel                         ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_PLL_BW_SEL_LOW" - Legal settings are {TX_PLL_BW_SEL_LOW,TX_PLL_BW_SEL_MEDIUM,TX_PLL_BW_SEL_HIGH,TX_PLL_BW_SEL_DISABLED,__BB_DONT_CARE__} */,
                 .tx_protocol                            (bb_f_ux_tx_protocol                           ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_PROTOCOL_DISABLED" - Legal settings are {TX_PROTOCOL_DISABLED,TX_PROTOCOL_HARD_PCIE,TX_PROTOCOL_SOFT_PIPE,TX_PROTOCOL_FEC_PCS_MAC,TX_PROTOCOL_PMA_DIRECT_SYS_CLK,TX_PROTOCOL_PMA_DIRECT_XCVR_CLK,__BB_DONT_CARE__} */,
                 .tx_user_clk1_en                        (bb_f_ux_tx_user_clk1_en                       ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .tx_user_clk1_mux                       (bb_f_ux_tx_user_clk1_mux                      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_USER_CLK1_MUX_SLOW_MED" - Legal settings are {TX_USER_CLK1_MUX_SLOW_MED,TX_USER_CLK1_MUX_FAST,TX_USER_CLK1_MUX_DISABLED,__BB_DONT_CARE__} */,
                 .tx_user_clk2_en                        (bb_f_ux_tx_user_clk2_en                       ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
                 .tx_user_clk2_mux                       (bb_f_ux_tx_user_clk2_mux                      ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_USER_CLK2_MUX_SLOW_MED" - Legal settings are {TX_USER_CLK2_MUX_SLOW_MED,TX_USER_CLK2_MUX_FAST,TX_USER_CLK2_MUX_DISABLED,__BB_DONT_CARE__} */,
//                 .tx_which_lane_to_copy                  (bb_f_ux_tx_which_lane_to_copy                 ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_WHICH_LANE_TO_COPY_SELF" - Legal settings are {TX_WHICH_LANE_TO_COPY_SELF,TX_WHICH_LANE_TO_COPY_L0,TX_WHICH_LANE_TO_COPY_L1,TX_WHICH_LANE_TO_COPY_L2,TX_WHICH_LANE_TO_COPY_DISABLED,__BB_DONT_CARE__} */,
                 .tx_width                               (bb_f_ux_tx_width                              ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TX_WIDTH_32" - Legal settings are {TX_WIDTH_32,TX_WIDTH_8,TX_WIDTH_10,TX_WIDTH_16,TX_WIDTH_20,TX_WIDTH_64,TX_WIDTH_DISABLED,__BB_DONT_CARE__} */,
                 .txrx_channel_operation                 (bb_f_ux_txrx_channel_operation                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TXRX_CHANNEL_OPERATION_FULL_DUPLEX" - Legal settings are {TXRX_CHANNEL_OPERATION_FULL_DUPLEX,TXRX_CHANNEL_OPERATION_DISABLED,TXRX_CHANNEL_OPERATION_DIGITAL_DUPLEX,TXRX_CHANNEL_OPERATION_DUAL_SIMPLEX,__BB_DONT_CARE__} */,
                 .txrx_line_encoding_type                (bb_f_ux_txrx_line_encoding_type               ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TXRX_LINE_ENCODING_TYPE_NRZ" - Legal settings are {TXRX_LINE_ENCODING_TYPE_NRZ,TXRX_LINE_ENCODING_TYPE_PAM4,TXRX_LINE_ENCODING_TYPE_DISABLED,__BB_DONT_CARE__} */,
                 .txrx_xcvr_speed_bucket                 (bb_f_ux_txrx_xcvr_speed_bucket                ) /* AUTOGEN_BB_AUTOUP_ip758fluxtop_ - BCM default="TXRX_XCVR_SPEED_BUCKET_25G" - Legal settings are {TXRX_XCVR_SPEED_BUCKET_25G,TXRX_XCVR_SPEED_BUCKET_50G,TXRX_XCVR_SPEED_BUCKET_DISABLED,__BB_DONT_CARE__} */,
//                 .ur_en_0_31                             (bb_f_ux_ur_en_0_31                            ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxovrcdrlock2dataen_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_1_1                              (bb_f_ux_ur_en_1_1                             ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxterm_hiz_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_andme_en_lx_a                    (bb_f_ux_ur_en_andme_en_lx_a                   ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_andme_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_lfps_en_lx_nt                    (bb_f_ux_ur_en_lfps_en_lx_nt                   ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_lfps_en_lx_nt - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_pcie_l1d1_lx_a                   (bb_f_ux_ur_en_pcie_l1d1_lx_a                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_pcie_l1d1_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_pcie_l1d2_lx_a                   (bb_f_ux_ur_en_pcie_l1d2_lx_a                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_pcie_l1d2_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_pcs_lock                         (bb_f_ux_ur_en_pcs_lock                        ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_pcs_lock - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rx_lx_b_a                        (bb_f_ux_ur_en_rx_lx_b_a                       ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rx_lx_b_a - BCM default="ENABLE" - Legal settings are {ENABLE,DISABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxbist_en_lx_a                   (bb_f_ux_ur_en_rxbist_en_lx_a                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxbist_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxeiosdetectstat_lx_a            (bb_f_ux_ur_en_rxeiosdetectstat_lx_a           ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxeiosdetectstat_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxeq_clr_lx_a                    (bb_f_ux_ur_en_rxeq_clr_lx_a                   ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxeq_clr_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxeq_start_lx_a                  (bb_f_ux_ur_en_rxeq_start_lx_a                 ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxeq_start_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxeq_static_en_lx_a              (bb_f_ux_ur_en_rxeq_static_en_lx_a             ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxeq_static_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxeyediag_start_lx_a             (bb_f_ux_ur_en_rxeyediag_start_lx_a            ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxeyediag_start_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxovrcdrlock2dataen_lx_a         (bb_f_ux_ur_en_rxovrcdrlock2dataen_lx_a        ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxovrcdrlock2dataen_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_rxterm_hiz_en_lx_a               (bb_f_ux_ur_en_rxterm_hiz_en_lx_a              ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_rxterm_hiz_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_tx_lx_b_a                        (bb_f_ux_ur_en_tx_lx_b_a                       ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_tx_lx_b_a - BCM default="ENABLE" - Legal settings are {ENABLE,DISABLE,__BB_DONT_CARE__} */,
//                 .ur_en_txbeacon_lx_a                    (bb_f_ux_ur_en_txbeacon_lx_a                   ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_txbeacon_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_txbist_en_lx_a                   (bb_f_ux_ur_en_txbist_en_lx_a                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_txbist_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_en_txdetectrx_req_lx_a              (bb_f_ux_ur_en_txdetectrx_req_lx_a             ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_en_txdetectrx_req_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_0_31                            (bb_f_ux_ur_ovr_0_31                           ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxovrcdrlock2dataen_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_1_1                             (bb_f_ux_ur_ovr_1_1                            ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxterm_hiz_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_andme_en_lx_a                   (bb_f_ux_ur_ovr_andme_en_lx_a                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_andme_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_lfps_en_lx_nt                   (bb_f_ux_ur_ovr_lfps_en_lx_nt                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_lfps_en_lx_nt - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_pcie_l1d1_lx_a                  (bb_f_ux_ur_ovr_pcie_l1d1_lx_a                 ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_pcie_l1d1_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_pcie_l1d2_lx_a                  (bb_f_ux_ur_ovr_pcie_l1d2_lx_a                 ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_pcie_l1d2_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_pcs_lock                        (bb_f_ux_ur_ovr_pcs_lock                       ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_pcs_lock - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rx_lx_b_a                       (bb_f_ux_ur_ovr_rx_lx_b_a                      ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rx_lx_b_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxbist_en_lx_a                  (bb_f_ux_ur_ovr_rxbist_en_lx_a                 ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxbist_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxeiosdetectstat_lx_a           (bb_f_ux_ur_ovr_rxeiosdetectstat_lx_a          ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxeiosdetectstat_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxeq_clr_lx_a                   (bb_f_ux_ur_ovr_rxeq_clr_lx_a                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxeq_clr_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxeq_start_lx_a                 (bb_f_ux_ur_ovr_rxeq_start_lx_a                ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxeq_start_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxeq_static_en_lx_a             (bb_f_ux_ur_ovr_rxeq_static_en_lx_a            ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxeq_static_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxeyediag_start_lx_a            (bb_f_ux_ur_ovr_rxeyediag_start_lx_a           ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxeyediag_start_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxovrcdrlock2dataen_lx_a        (bb_f_ux_ur_ovr_rxovrcdrlock2dataen_lx_a       ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxovrcdrlock2dataen_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_rxterm_hiz_en_lx_a              (bb_f_ux_ur_ovr_rxterm_hiz_en_lx_a             ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_rxterm_hiz_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_tx_lx_b_a                       (bb_f_ux_ur_ovr_tx_lx_b_a                      ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_tx_lx_b_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_txbeacon_lx_a                   (bb_f_ux_ur_ovr_txbeacon_lx_a                  ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_txbeacon_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_txbist_en_lx_a                  (bb_f_ux_ur_ovr_txbist_en_lx_a                 ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_txbist_en_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ur_ovr_txdetectrx_req_lx_a             (bb_f_ux_ur_ovr_txdetectrx_req_lx_a            ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux0_ur_ovr_txdetectrx_req_lx_a - BCM default="DISABLE" - Legal settings are {DISABLE,ENABLE,__BB_DONT_CARE__} */,
//                 .ux_q_10_to_1_ckmux_0_attr              (bb_f_ux_ux_q_10_to_1_ckmux_0_attr             ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux_q_10_to_1_ckmux_0_attr - BCM default="CKMUX0_10_TO_1_CMOSCLK0_0" - Legal settings are {CKMUX0_10_TO_1_PCSREF_L0,CKMUX0_10_TO_1_PCSREF_L1,CKMUX0_10_TO_1_PCSREF_L2,CKMUX0_10_TO_1_PCSREF_L3,CKMUX0_10_TO_1_FBCLK_L0,CKMUX0_10_TO_1_FBCLK_L1,CKMUX0_10_TO_1_FBCLK_L2,CKMUX0_10_TO_1_FBCLK_L3,CKMUX0_10_TO_1_CMOSCLK0_0,CKMUX0_10_TO_1_CMOSCLK0_1,CKMUX0_10_TO_1_CMOSCLK0_2,CKMUX0_10_TO_1_CMOSCLK0_3,CKMUX0_10_TO_1_CMOSCLK1_0,CKMUX0_10_TO_1_CMOSCLK1_1,CKMUX0_10_TO_1_CMOSCLK1_2,CKMUX0_10_TO_1_CMOSCLK1_3,__BB_DONT_CARE__} */,
                 .ux_q_10_to_1_ckmux_0_en_attr           (bb_f_ux_q_10_to_1_ckmux_0_en_attr          ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux_q_10_to_1_ckmux_0_en_attr - BCM default="CKMUX0_10_TO_1_EN_FALSE" - Legal settings are {CKMUX0_10_TO_1_EN,CKMUX0_10_TO_1_EN_FALSE,__BB_DONT_CARE__} */,
//                 .ux_q_10_to_1_ckmux_1_attr              (bb_f_ux_ux_q_10_to_1_ckmux_1_attr             ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux_q_10_to_1_ckmux_1_attr - BCM default="CKMUX1_10_TO_1_CMOSCLK0_0" - Legal settings are {CKMUX1_10_TO_1_PCSREF_L0,CKMUX1_10_TO_1_PCSREF_L1,CKMUX1_10_TO_1_PCSREF_L2,CKMUX1_10_TO_1_PCSREF_L3,CKMUX1_10_TO_1_FBCLK_L0,CKMUX1_10_TO_1_FBCLK_L1,CKMUX1_10_TO_1_FBCLK_L2,CKMUX1_10_TO_1_FBCLK_L3,CKMUX1_10_TO_1_CMOSCLK0_0,CKMUX1_10_TO_1_CMOSCLK0_1,CKMUX1_10_TO_1_CMOSCLK0_2,CKMUX1_10_TO_1_CMOSCLK0_3,CKMUX1_10_TO_1_CMOSCLK1_0,CKMUX1_10_TO_1_CMOSCLK1_1,CKMUX1_10_TO_1_CMOSCLK1_2,CKMUX1_10_TO_1_CMOSCLK1_3,__BB_DONT_CARE__} */,
                 .ux_q_10_to_1_ckmux_1_en_attr           (bb_f_ux_q_10_to_1_ckmux_1_en_attr          ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux_q_10_to_1_ckmux_1_en_attr - BCM default="CKMUX1_10_TO_1_EN_FALSE" - Legal settings are {CKMUX1_10_TO_1_EN,CKMUX1_10_TO_1_EN_FALSE,__BB_DONT_CARE__} */,
//                 .ux_q_ckmux_cpu_attr                    (bb_f_ux_ux_q_ckmux_cpu_attr                   ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_ux_q_ckmux_cpu_attr - BCM default="CKMUX_CPU_AVMM" - Legal settings are {CKMUX_CPU_PLL0,CKMUX_CPU_PLL1,CKMUX_CPU_PLL2,CKMUX_CPU_AVMM,__BB_DONT_CARE__} */,
//                 .ux_q_e_rx_dp_pipe_attr                 (bb_f_ux_ux_q_e_rx_dp_pipe_attr                ) /* ip_config_ux ux_q_e_rx_dp_pipe_attr - BCM default="E_RX_DP_NO_PIPE" - Legal settings are {E_RX_DP_NO_PIPE,E_RX_DP_PIPE,__BB_DONT_CARE__} */,
//                 .ux_q_e_tx_dp_pipe_attr                 (bb_f_ux_ux_q_e_tx_dp_pipe_attr                ) /* ip_config_ux ux_q_e_tx_dp_pipe_attr - BCM default="E_TX_DP_NO_PIPE" - Legal settings are {E_TX_DP_NO_PIPE,E_TX_DP_PIPE,__BB_DONT_CARE__} */,
            //       .ux_q_i_pll0_hz                         (bb_f_ux_ux_q_i_pll0_hz                        ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_Virtual attribute for power down mode - BCM default=0 */,
//                 .ux_q_i_pll1_hz                         (bb_f_ux_ux_q_i_pll1_hz                        ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_Virtual attribute for power down mode - BCM default=0 */,
//                 .ux_q_i_pll2_hz                         (bb_f_ux_ux_q_i_pll2_hz                        ) /* AUTOGEN_BB_AUTOUP_gdr_ux_quad_avmm_cfgcsr_Virtual attribute for power down mode - BCM default=0 */
//          .enable_an_lt_support                 (bb_f_ux_enable_an_lt_support               ),
	        .primary_use                          (bb_f_ux_primary_use                        ),
	        .tx_spread_spectrum_en                (bb_f_ux_tx_spread_spectrum_en              ),
	        .tx_tuning_hint                       (bb_f_ux_tx_tuning_hint                     ),
		  
             .synth_lc_fb_div_emb_mult_counter     (bb_f_ux_tx_fb_div_emb_mult_counter         ),
	     .synth_lc_fb_div_n_frac_mode          (bb_f_ux_synth_lc_fb_div_n_frac_mode        ), 	
    	    .rx_tuning_hint                       (bb_f_ux_rx_tuning_hint                     ) 
       )
        x_bb_f_ux
        (
          .i_xcvrrc_fsrssr_xcvr_ux_ds_0__xcvr_f2t_ssr_real (0),
	  .placement_virtual(src_placement_virtual[idx_xcvr]),
          .i_det_lat_sclk_real                    (i_ptp_async_cal_pulse[idx_xcvr]),
          .tx_lane0_async_sync_dl_path_real       (i_tx_ptp_async_cal_sel[idx_xcvr]),
          .rx_lane0_async_sync_dl_path_real       (i_rx_ptp_async_cal_sel[idx_xcvr]),
          .o_tx_sclk_return_real                  (o_tx_ptp_async_pulse[idx_xcvr]),
          .o_rx_sclk_return_real                  (o_rx_ptp_async_pulse[idx_xcvr]),
          .i_gdr_xcvr_data_rx_tx__b_rx_p_in_srds_pad_lv_lane_real(i_rx_serial[idx_xcvr]),
          .i_gdr_xcvr_data_rx_tx__b_rx_n_in_srds_pad_lv_lane_real(i_rx_serial_n[idx_xcvr]),
          .o_gdr_xcvr_data_rx_tx__b_tx_out_p_srds_pad_lv_lane_real(o_tx_serial[idx_xcvr]),
          .o_gdr_xcvr_data_rx_tx__b_tx_out_n_srds_pad_lv_lane_real(o_tx_serial_n[idx_xcvr]),
	  .octl_pcs_txstatus_lx_a_real(xcvr_pcs_txstatus[idx_xcvr]),
          .oct_pcs_all_synthlockstatus_real(xcvr_txpll_locked[idx_xcvr]),//output
          .oct_pcs_rxcdrlock2data_lx_a_real(xcvr_rxcdr_locked[idx_xcvr]),//output
          .core_pll_refclk_link(),//input, temp connection removed for snap ww38.6

	  .rx_cdr_refclk_link(i_clk_ref),//input, added for snap ww38.6
 

          .tx_pll_refclk_link(i_clk_ref),//input temp connection
      .rx_cdr_divclk_link(), //output temp connection
          .xcvr_data0_link(xcvr_data_link[(idx_xcvr*2)]),
	  .src_rx_master_virtual(src_rx_virtual[idx_xcvr]),
          .src_rx_slave_virtual ((idx_xcvr>0)? src_rx_virtual[0] : 0),
          .src_tx_master_virtual(src_tx_virtual[idx_xcvr]),
          .src_tx_slave_virtual ((idx_xcvr>0)? src_tx_virtual[0] : 0),
          .next_bonding_link (xcvr_bond_link[idx_xcvr]),
          .prev_bonding_link ((idx_xcvr>0)? xcvr_bond_link[idx_xcvr-1] : 0),

          .xcvr_data1_link(xcvr_data_link[(idx_xcvr*2)+1]),
          .avmm2_link(avmm2_link[idx_xcvr])
        );
      end else begin
        // need to instantiate FGT2.0 
      end

      //XCVR_TYPE_GUI end

        bb_m_hdpldadapt_avmm2 #(
          .silicon_rev                                       (bb_m_hdpldadapt_avmm2_silicon_rev),
		  .hdpldadapt_pld_avmm2_clk_rowclk_hz (bb_m_hdpldadapt_pld_avmm2_clk_rowclk_hz)
        ) x_bb_f_avmm2   (
          .hip_avmm_read_real                                (hip_avmm_read[idx_xcvr]                ),
          .hip_avmm_readdata_real                            (hip_avmm_readdata[8*idx_xcvr+:8]       ),
          .hip_avmm_readdatavalid_real                       (hip_avmm_readdatavalid[idx_xcvr]       ),
          .hip_avmm_reg_addr_real                            (hip_avmm_reg_addr[21*idx_xcvr+:21]     ),
          .hip_avmm_reserved_out_real                        (hip_avmm_reserved_out[5*idx_xcvr+:5]   ),
          .hip_avmm_write_real                               (hip_avmm_write[idx_xcvr]               ),
          .hip_avmm_writedata_real                           (hip_avmm_writedata[8*idx_xcvr+:8]      ),
          .hip_avmm_writedone_real                           (hip_avmm_writedone[idx_xcvr]           ),
          .pld_avmm2_busy_real                               (pld_avmm2_busy[idx_xcvr]               ),
          .pld_avmm2_clk_rowclk_real                         (pld_avmm2_clk_rowclk[idx_xcvr]         ),
          .pld_avmm2_cmdfifo_wr_full_real                    (pld_avmm2_cmdfifo_wr_full[idx_xcvr]    ),
          .pld_avmm2_cmdfifo_wr_pfull_real                   (pld_avmm2_cmdfifo_wr_pfull[idx_xcvr]   ),
          .pld_avmm2_request_real                            (pld_avmm2_request[idx_xcvr]            ),
           //                                                                                            
          //.pld_pll_cal_done_real                             (pld_pll_cal_done[idx_xcvr]             ),
          .pld_avmm2_write_real                              (pld_avmm2_write[idx_xcvr]              ),
          .pld_avmm2_read_real                               (pld_avmm2_read[idx_xcvr]               ),
          .pld_avmm2_reg_addr_real                           (pld_avmm2_reg_addr[9*idx_xcvr+:9]      ),
          .pld_avmm2_readdata_real                           (pld_avmm2_readdata[8*idx_xcvr+:8]      ),
          .pld_avmm2_writedata_real                          (pld_avmm2_writedata[8*idx_xcvr+:8]     ),
          .pld_avmm2_readdatavalid_real                      (pld_avmm2_readdatavalid[idx_xcvr]      ),
          .pld_avmm2_reserved_in_real                        (pld_avmm2_reserved_in[6*idx_xcvr+:6]   ), //TODO was 10 and changed to 6 why?
         //TODO - removing temporarily due to tile ip .pld_avmm2_reserved_out_real                       (pld_avmm2_reserved_out[3*idx_xcvr+:3]  ),
          .avmm2_link                                        (avmm2_link[idx_xcvr]                   ) 
      );
          end
  endgenerate

`endif
endmodule






