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


(* altera_attribute = "-name DESIGN_ASSISTANT_EXCLUDE \"RES-10204\" -to \"*GEN_PAUSE\.u0\|eth_f_por\"" *)
module eth_f_csr   #(
    parameter LANE_NUM          = 1,
	 parameter EHIP_RATE          = "10G", // Ethernet rate - "10G" "25G" "40G" 50G" "100G" "200G" "400G"
    parameter CLIENT_INT        = 0,
    parameter ENABLE_PTP        = 0
  ) (
    input wire                          i_reconfig_clk, 
    input wire                          i_reconfig_reset,
    input wire                          i_cfg_reset_new,
    input wire [13:0]                   i_reconfig_eth_addr,
    input wire                          i_reconfig_eth_read,
    input wire                          i_reconfig_eth_write,
    input wire [31:0]                   i_reconfig_eth_writedata,
    input wire [3:0]                    i_reconfig_eth_byteenable,
    input wire [2:0]                    eth_rate, // [2:0]
    input wire                          sel_25g_10g_reg,
    input wire                          anlt_enable, // [0]
    input wire                          modulation_type, // [0]
    input wire [2:0]                    rsfec_type, // [2:0]
    input wire [2:0]                    flow_control_mode, // [2:0]
    input wire [2:0]                    client_intf, // [2:0]
    input wire                          xcvr_type, // [0]
    input wire [3:0]                    num_lanes, // [3:0]
    input wire				dis_pause_control,
    input wire                          sec_enable,
	input wire             mac_forward_rx_pause_requests,
	input wire             mac_rx_en_pp,
	input wire             mac_rx_en_pp_dr,
	input wire        mac_flow_control,
	input wire        mac_tx_xof,
	
	
      // DR
    input wire                          i_tx_ehip_preamble_passthru_gui,
    output wire                         o_tx_ehip_preamble_passthru_dr,
    // PTP begin
    input wire                          i_ptp_clk,
    input wire                          i_tx_tod_clk,
    input wire                          i_rx_tod_clk,
    input wire                          i_samp_clk,
    input wire                          i_tx_srst_n,
    input wire                          i_rx_srst_n,
    input wire                          i_tx_tod_srst_n,
    input wire                          i_rx_tod_srst_n,
    input wire                          i_tx_samp_srst_n,
    input wire                          i_rx_samp_srst_n,
    input wire                          i_tx_apulse_wdly_valid       ,
    input wire                          i_tx_apulse_offset_valid     ,
    input wire                          i_tx_apulse_time_valid       ,
    input wire                          i_rx_apulse_wdly_valid       ,
    input wire                          i_rx_apulse_offset_valid     ,
    input wire                          i_rx_apulse_time_valid       ,
    input wire [LANE_NUM-1:0][19:0]     i_tx_apulse_wdly             ,
    input wire [LANE_NUM-1:0][31:0]     i_tx_apulse_offset           ,
    input wire [LANE_NUM-1:0][27:0]     i_tx_apulse_time             ,
    input wire [LANE_NUM-1:0][19:0]     i_rx_apulse_wdly             ,
    input wire [LANE_NUM-1:0][31:0]     i_rx_apulse_offset           ,
    input wire [LANE_NUM-1:0][27:0]     i_rx_apulse_time             ,
    input wire               [31:0]     i_tx_const_adjust            ,
    input wire               [31:0]     i_rx_const_adjust            ,
    input wire                          i_rx_pcs_fully_aligned       ,
    input wire                          i_rx_ptp_vl_snapshot         ,
    input wire                          i_tx_tam_valid               ,
    input wire [47:0]                   i_tx_tam_ui                  ,
    input wire [15:0]                   i_tx_tam_cnt                 ,
    input wire                          i_rx_tam_valid               ,
    input wire [47:0]                   i_rx_tam_ui                  ,
    input wire [15:0]                   i_rx_tam_cnt                 ,
    input wire                          i_tx_ptp_offset_data_valid   ,
    input wire                          i_rx_ptp_offset_data_valid   ,
    input wire                          i_tx_ptp_ready               ,
    input wire                          i_rx_ptp_ready               ,
    output wire               [2:0]     o_tx_ref_lane                ,
    output wire               [2:0]     o_rx_lal                     ,
    output wire              [31:0]     o_tx_calc_adjust             ,
    output wire              [31:0]     o_rx_calc_adjust             ,
    output wire                         o_rx_fec_cw_pos_user_cfg_done,
    output wire                         o_tx_ptp_user_cfg_done       ,
    output wire                         o_rx_ptp_user_cfg_done       ,
    input wire                          i_tx_ptp_user_cfg_done_clrn  ,
    input wire                          i_rx_ptp_user_cfg_done_clrn  ,
    // PTP end
    output reg [31:0]                   o_reconfig_eth_readdata,
    output reg                          o_reconfig_eth_readdata_valid,
    output reg                          o_reconfig_eth_waitrequest,
    input wire                          tx_rst_ack_n, // Acknowledge signal for i_tx_rst_n.
    input wire                          rx_rst_ack_n, // Acknowledge signal for i_rx_rst_n.
    input wire                          rst_ack_n, // Acknowledge signal for i_rst_n.
    input wire                          tx_lanes_stable_status,
    input wire                          ehip_remote_fault_status,
    input wire                          ehip_local_fault_status,
    input wire [15:0]                   rxaib_transfer_ready_ehip,
    input wire [1:0]                    rxaib_transfer_ready_ptp,
    input wire [15:0]                   txaib_transfer_ready_ehip,
    input wire [31:0]                   clk_tx_khz,
    input wire [31:0]                   clk_rx_khz,
    input wire [31:0]                   clk_pll_khz,
    input wire [31:0]                   clk_tx_div_khz,
    input wire [31:0]                   clk_rec_div64_khz,
    input wire [31:0]                   clk_rec_div_khz,
    input wire [63:0]                   dropped_frame_cnt,
    output wire                         dropped_clear,
    output wire                         dropped_frame_snapshot,
    output wire                         eth_reset_eio_sys_rst,
    output wire                         eth_reset_soft_tx_rst,
    output wire                         eth_reset_soft_rx_rst,

    output reg  [7:0]                   eth_reset_tx_clear_alarm,
    output reg  [7:0]                   eth_reset_rx_clear_alarm,
    input  wire [2:0]                   eth_reset_status_tx_lane_current_state_i,
    input  wire [2:0]                   eth_reset_status_rx_lane_current_state_i,
    input  wire [7:0]                   eth_reset_status_tx_alarm_i,
    input  wire [7:0]                   eth_reset_status_rx_alarm_i,
    input  wire [7:0]                   phy_tx_pll_locked_tx_pll_locked_i,
    input  wire [7:0]                   phy_eiofreq_locked_eio_freq_lock_i,
    input  wire                         pcs_status_dskew_status_i,
    input  wire                         pcs_status_dskew_chng_i,
    input  wire                         pcs_status_rx_pcs_ready_i,
    input  wire                         pcs_status_kr_mode_i,
    input  wire                         pcs_status_kr_fec_mode_i,
    output reg                          pcs_control_clr_dskew_chng,
    input  wire [7:0][31:0]    tx_sync_counter_i,
    input  wire [7:0][31:0]    tx_async_counter_i,
    input  [7:0][31:0]         rx_sync_counter_i,
    input  [7:0][31:0]         rx_async_counter_i,
    input  [7:0]               rx_measure_valid_i,
    input   [7:0]              tx_measure_valid_i,
    output  reg [7:0]          rx_dl_restart,
    output  reg [7:0]          tx_dl_restart,
    input  [7:0][31:0]         tx_dl_delay_i,
    input  [7:0][31:0]         rx_dl_delay_i,
    input  [7:0]               rx_async_valid_i,
    input  [7:0]               rx_sync_valid_i,
    input  [7:0]               tx_async_valid_i,
    input  [7:0]               tx_sync_valid_i,
	 
	 output 										reset_swcwbin,
	 input  [31:0] 							cwbin0_stat_block_A_i,
	 input  [31:0] 							cwbin1_stat_block_A_i,
	 input  [31:0] 							cwbin2_stat_block_A_i,
	 input  [31:0] 							cwbin3_stat_block_A_i,
	 input  [31:0] 							cwbin0_stat_block_B_i,
	 input  [31:0] 							cwbin1_stat_block_B_i,
	 input  [31:0] 							cwbin2_stat_block_B_i,
	 input  [31:0] 							cwbin3_stat_block_B_i,
	 output [31:0] 								cwbin_timer_timeout,
         
         output       tx_pkt_sts_clr,
  	 output       rx_pkt_sts_clr,
	 output       rx_lf_rf_pcs_clr,
	 input [31:0] tx_pkr_sop_cnt_lo,
	 input [15:0] tx_pkr_sop_cnt_hi,
	 input [31:0] tx_pkr_eop_cnt_lo,
	 input [15:0] tx_pkr_eop_cnt_hi,
	 input [31:0] tx_pkr_byte_cnt_lo,
	 input [31:0] tx_pkr_byte_cnt_hi,
	 input [31:0] tx_mac_sop_cnt_lo,
	 input [15:0] tx_mac_sop_cnt_hi,
	 input [31:0] tx_mac_eop_cnt_lo,
 	 input [15:0] tx_mac_eop_cnt_hi,
	 input [31:0] tx_mac_byte_cnt_lo,
	 input [31:0] tx_mac_byte_cnt_hi,
 	 input [31:0] rx_mac_sop_cnt_lo,
	 input [15:0] rx_mac_sop_cnt_hi,
	 input [31:0] rx_mac_eop_cnt_lo,
	 input [15:0] rx_mac_eop_cnt_hi,
	 input [31:0] rx_mac_byte_cnt_lo,
	 input [31:0] rx_mac_byte_cnt_hi,
	 input [05:0] tx_pkr_max_fifo_level,
	 input [05:0] tx_pkr_min_fifo_level,
	 input [03:0] tx_pkr_fifo_empty_cnt,         
         input [23:0] local_remote_pcs_cntr,
         input [63:0] pack_da_mismatch_cnt_in     ,
	 input [63:0] pack_da_mismatch_cnt_out    ,
	 input [63:0] pack_da_match_cnt_in        ,
	 input [63:0] pack_da_match_cnt_out       ,
	 input [63:0] tx_pause_da_mismatch_cnt_in ,
	 input [63:0] tx_pause_da_mismatch_cnt_out,
	 input [63:0] tx_pause_da_match_cnt_in    ,
	 input [63:0] tx_pause_da_match_cnt_out   ,
	 
	 input wire 				f_tx_operational_reconfigsync,
	 input wire 				f_rx_operational_reconfigsync,
	 input wire             src_avmm1_req,
	 output reg            src_avmm1_ack,
	 
	 //RX PAUSE signals
	 output logic 		tx_flow_control,
	 output logic		forward_user_rxpause,
	 output logic            en_sfc,
         output logic  [47:0]    rxpause_daddr,
	 output logic            rx_en_pp,
         input logic             single_multi_rate_pp, 
         input [1:0]                 eth_link_fault,
         output logic 		link_fault_config_unidir_10g,
         output reg             o_rf_in_progress,
         output wire [31:0]            config_ehip_rst_count,

//  for AVMM1 bb ports
    input   wire                        pld_avmm1_busy,
    output  wire                        pld_avmm1_clk_rowclk,
    input   wire                        pld_avmm1_cmdfifo_wr_full,
    input   wire                        pld_avmm1_cmdfifo_wr_pfull,
    output  wire                        pld_avmm1_read,
    input   wire  [7:0]                 pld_avmm1_readdata,
    input   wire                        pld_avmm1_readdatavalid,
    output  wire  [9:0]                 pld_avmm1_reg_addr,
    output  wire                        pld_avmm1_request,
    output  wire  [8:0]                 pld_avmm1_reserved_in,
    input   wire  [2:0]                 pld_avmm1_reserved_out,
    output  wire                        pld_avmm1_write,
    output  wire  [7:0]                 pld_avmm1_writedata,
    input   wire                        pld_chnl_cal_done,
    input   wire                        pld_hssi_osc_transfer_en
);

logic                  		reconfig_eth_write;
logic    [3:0]         		reconfig_eth_byteenable;
logic        					reconfig_eth_read;
logic    [13:0]            reconfig_eth_addr;
logic    [31:0]           	reconfig_eth_writedata,reconfig_eth_writedata_f;
logic    [31:0]           	reconfig_eth_readdata;
logic                  		reconfig_eth_readdata_valid;
logic                  		reconfig_eth_waitrequest;

// MAC statistics Bug fix logic
logic [LANE_NUM-1:0] reset_ini_tx,reset_ini_rx;
logic [LANE_NUM-1:0] reset_rel_tx,reset_rel_rx;
logic reset_ini, reset_rel;
logic rst_in_prog_reg, rst_in_prog;
logic skip_ehip_req,skip_ehip_req_a;
logic [15:0] ehip_addr_txmac_st  ;
logic [15:0] ehip_addr_txmac_end ;
logic [15:0] ehip_addr_rxmac_st  ;
logic [15:0] ehip_addr_rxmac_end ;

logic [15:0] ehip_addr_pcs_st  ;
logic [15:0] ehip_addr_pcs_end ;
logic ehip_sel_excl_txmacaddr;
logic ehip_sel_excl_rxmacaddr;
logic ehip_sel_excl_pcsaddr;
logic avmm_in_progress;

logic addr_en_tx_xof_en, r_addr_en_tx_xof_en; 			
logic addr_en_rx_pause_fwd, r_addr_en_rx_pause_fwd ;		
logic addr_en_rx_pause_daddrl ;	
logic addr_en_rx_pause_daddrh	;
logic addr_en_rxsfc_ehip_cfg, r_addr_en_rxsfc_ehip_cfg;
logic addr_ehip_rx_en_pp;

  
  // Read data
  wire [31:0]  ehip_readdata;
  logic [2:0] ehip_readdata_mask,ehip_wrdata_mask;
  wire [31:0]  soft_csr_base_readdata;
  wire [31:0]  soft_csr_ptp_readdata;
  logic [31:0] readdata;
  wire         ehip_readdata_valid;
  wire         soft_csr_base_readdata_valid;
  logic        soft_csr_ptp_readdata_valid;
  logic        sip_readdata_valid;
  
   
  wire [17:0] avmm_m8_addr;
  wire [7:0]  avmm_m8_wdata;
  wire [7:0]  avmm_m8_readdata;

  logic soft_csr_base_sel, r_soft_csr_base_sel, soft_csr_base_sel_a;   // Base registers implemented in soft logic
  logic soft_csr_ptp_sel, r_soft_csr_ptp_sel, soft_csr_ptp_sel_a;   // PTP registers implemented in soft logic
  logic ehip_sel;           // Hard EHIP regisers
  logic is_maib;            // MAIB adapter registers
  logic invalid_soft_csr_sel,invalid_soft_csr_sel_a; 
  
    // 32to8 
  wire [31:0] ehip_sladdress;
  wire        ehip_slread;
  wire        ehip_slwrite;
  wire [7:0]  ehip_slwrite_data;
  wire [7:0]  ehip_slread_data;
  wire        ehip_slwait_request;


  wire [1:0]  device_name;
  wire [2:0]  tile_name;
  
    
  // Wait
  reg r_reconfig_eth_read;
  logic sip_waitrequest;
  wire ehip_waitrequest;
  
//----------------------------------
reg	write_d1;
reg     read_d1;
reg	waitreq_wr, waitreq_rd;
reg	valid_wreq_d1;
reg	valid_rreq_d1;
logic src_avmm1_req_reg,src_avmm1_req_pulse;

logic [2:0] eth_rate_int;

assign eth_rate_int = (eth_rate == 3'b001) ? ((sel_25g_10g_reg == 1'b1) ? 3'b000 : 3'b001) : eth_rate;

always @(  posedge i_reconfig_clk)
 begin
	r_addr_en_tx_xof_en <= addr_en_tx_xof_en;
	r_addr_en_rx_pause_fwd <= addr_en_rx_pause_fwd;
	r_addr_en_rxsfc_ehip_cfg <= addr_en_rxsfc_ehip_cfg; 
 end

 // eth_rate 10G/25G = 1; 40G = 2; 50G = 3; 100G = 4; 200G = 5; 400G = 6;

always @(*) begin
if (eth_rate_int == 3'b110 ) begin: E400G_SKIP_GEN

  ehip_addr_txmac_st = 'h5800 ;
  ehip_addr_txmac_end = 'h5930 ;
  
  ehip_addr_rxmac_st = 'h5934 ;
  ehip_addr_rxmac_end = 'h5D24 ;

  ehip_addr_pcs_st = 'h5080 ;
  ehip_addr_pcs_end = 'h51C4 ;
  
  ehip_sel_excl_txmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_txmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_txmac_end));
  ehip_sel_excl_rxmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_rxmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_rxmac_end));
  ehip_sel_excl_pcsaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_pcs_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_pcs_end));
end

else if (eth_rate_int == 3'b101) begin: E200G_SKIP_GEN
 ehip_addr_txmac_st = 'h4800 ;
 ehip_addr_txmac_end = 'h4930 ;

 ehip_addr_rxmac_st = 'h4934 ;
 ehip_addr_rxmac_end = 'h4D24 ;

 ehip_addr_pcs_st = 'h4080 ;
 ehip_addr_pcs_end = 'h41C4 ;

  ehip_sel_excl_txmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_txmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_txmac_end));
  ehip_sel_excl_rxmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_rxmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_rxmac_end));

  ehip_sel_excl_pcsaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_pcs_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_pcs_end));
end
else if (eth_rate_int == 3'b100 || eth_rate_int == 3'b010) begin: E100G_40G_SKIP_GEN

 ehip_addr_txmac_st = 'h3800 ;
 ehip_addr_txmac_end = 'h3930 ;

 ehip_addr_rxmac_st = 'h3934 ;
 ehip_addr_rxmac_end = 'h3D24 ;

 ehip_addr_pcs_st = 'h3080 ;
 ehip_addr_pcs_end = 'h31C4 ;

  ehip_sel_excl_txmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_txmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_txmac_end));
  ehip_sel_excl_rxmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_rxmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_rxmac_end));

  ehip_sel_excl_pcsaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_pcs_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_pcs_end));
end

else if (eth_rate_int == 3'b011) begin: E50G_SKIP_GEN

 ehip_addr_txmac_st = 'h2800 ;
 ehip_addr_txmac_end = 'h2930 ;

 ehip_addr_rxmac_st = 'h2934 ;
 ehip_addr_rxmac_end = 'h2D24 ;

 ehip_addr_pcs_st = 'h2080 ;
 ehip_addr_pcs_end = 'h21C4 ;

  ehip_sel_excl_txmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_txmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_txmac_end));
  ehip_sel_excl_rxmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_rxmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_rxmac_end));

  ehip_sel_excl_pcsaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_pcs_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_pcs_end));
end
 
else begin: E25G_SKIP

 ehip_addr_txmac_st = 'h1800 ;
 ehip_addr_txmac_end = 'h1930 ;

 ehip_addr_rxmac_st = 'h1934 ;
 ehip_addr_rxmac_end = 'h1D24 ;

 ehip_addr_pcs_st = 'h1080 ;
 ehip_addr_pcs_end = 'h11C4 ;

  ehip_sel_excl_txmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_txmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_txmac_end));
  ehip_sel_excl_rxmacaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_rxmac_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_rxmac_end));

  ehip_sel_excl_pcsaddr = (({reconfig_eth_addr[13:0],2'b00} >= ehip_addr_pcs_st) & ({reconfig_eth_addr[13:0],2'b00} <= ehip_addr_pcs_end));

end
end
  


  always_comb begin
      soft_csr_base_sel   = 1'b0;
      soft_csr_ptp_sel    = 1'b0;
      ehip_sel            = 1'b0;
      case ({reconfig_eth_addr[13:0],2'b00}) inside
          [16'h0100:16'h07ff] : soft_csr_base_sel  = 1'b1;
          [16'h0800:16'h0aff] : soft_csr_ptp_sel   = 1'b1;
          default             : ehip_sel           = 1'b1;
      endcase
  end 

  always_comb begin
      case ({reconfig_eth_addr[13:0],2'b00}) inside
          [16'h0000:16'h00ff] : is_maib           = 1'b1;
          [16'h0b00:16'h0fff] : is_maib           = 1'b1;
          default             : is_maib           = 1'b0;
      endcase
  end 

 

  //Read Write
  
  wire soft_csr_base_read  = reconfig_eth_read && soft_csr_base_sel;
  wire soft_csr_ptp_read   = reconfig_eth_read && soft_csr_ptp_sel;
  wire ehip_read           = reconfig_eth_read && ehip_sel &&  ~skip_ehip_req && ~addr_en_tx_xof_en && ~addr_en_rx_pause_fwd;
  
  wire soft_csr_base_write = reconfig_eth_write && soft_csr_base_sel;
  wire soft_csr_ptp_write  = reconfig_eth_write && soft_csr_ptp_sel;
  wire ehip_write          = reconfig_eth_write && ehip_sel && ~skip_ehip_req && ~addr_en_tx_xof_en && ~addr_en_rx_pause_fwd;


  always @(posedge i_reconfig_clk)
    if (i_reconfig_reset) begin
		r_reconfig_eth_read <= 1'b0;
		r_soft_csr_base_sel <= 1'b0;
		r_soft_csr_ptp_sel  <= 1'b0;
		invalid_soft_csr_sel  <= 1'b0;
		skip_ehip_req_a <= 1'b0;
    end
    else begin
		r_reconfig_eth_read <= reconfig_eth_read;
                if (reconfig_eth_read || reconfig_eth_write) begin
		   r_soft_csr_base_sel <= soft_csr_base_sel;
		   r_soft_csr_ptp_sel  <= soft_csr_ptp_sel;
			invalid_soft_csr_sel <= is_maib;
			skip_ehip_req_a <= skip_ehip_req;
                end
    end

  assign soft_csr_base_sel_a = soft_csr_base_sel | r_soft_csr_base_sel;
  assign soft_csr_ptp_sel_a  = soft_csr_ptp_sel  | r_soft_csr_ptp_sel;
  assign invalid_soft_csr_sel_a = is_maib | invalid_soft_csr_sel;

  always_comb begin
      case (1'b1)
          soft_csr_base_sel_a   		: reconfig_eth_waitrequest = sip_waitrequest;
          soft_csr_ptp_sel_a    		: reconfig_eth_waitrequest = sip_waitrequest;
          invalid_soft_csr_sel  		: reconfig_eth_waitrequest = sip_waitrequest;
          skip_ehip_req_a       		: reconfig_eth_waitrequest = sip_waitrequest;
			 r_addr_en_tx_xof_en   		: reconfig_eth_waitrequest = sip_waitrequest;
			 r_addr_en_rx_pause_fwd 	: reconfig_eth_waitrequest = sip_waitrequest;
			 r_addr_en_rxsfc_ehip_cfg 	: reconfig_eth_waitrequest = ehip_waitrequest;
          default               		: reconfig_eth_waitrequest = ehip_waitrequest;
      endcase
  end // always_comb


  always_comb begin
      case (1'b1)
          r_soft_csr_base_sel 		: reconfig_eth_readdata = soft_csr_base_readdata;
          r_soft_csr_ptp_sel  		: reconfig_eth_readdata = soft_csr_ptp_readdata;
	       invalid_soft_csr_sel		: reconfig_eth_readdata = 32'hdeadc0de ;
	       skip_ehip_req_a     		: reconfig_eth_readdata = 32'hdeadc0de;
			 r_addr_en_tx_xof_en 		: reconfig_eth_readdata = {29'h00000000, ehip_readdata_mask[2:0]};
			 r_addr_en_rx_pause_fwd 	: reconfig_eth_readdata = {31'h00000000, ehip_readdata_mask[0]};
			 r_addr_en_rxsfc_ehip_cfg 	: reconfig_eth_readdata = {ehip_readdata[31:1],ehip_readdata_mask[0]};
          default             		: reconfig_eth_readdata = ehip_readdata;
      endcase
  end

  always_comb begin
      case (1'b1)
				r_soft_csr_base_sel 			: reconfig_eth_readdata_valid = sip_readdata_valid;
				r_soft_csr_ptp_sel  			: reconfig_eth_readdata_valid = sip_readdata_valid;
				invalid_soft_csr_sel			: reconfig_eth_readdata_valid = sip_readdata_valid;
				skip_ehip_req_a     			: reconfig_eth_readdata_valid = sip_readdata_valid;
				r_addr_en_tx_xof_en 			: reconfig_eth_readdata_valid = sip_readdata_valid;
				r_addr_en_rx_pause_fwd 		: reconfig_eth_readdata_valid = sip_readdata_valid;
				r_addr_en_rxsfc_ehip_cfg 	: reconfig_eth_readdata_valid = ehip_readdata_valid;
          default             			: reconfig_eth_readdata_valid = ehip_readdata_valid;
      endcase
  end

  always_ff @(posedge i_reconfig_clk) begin
    // Registered because valid must come at least one cycle after wait goes low
    sip_readdata_valid <= !sip_waitrequest && reconfig_eth_read;
  end


assign  valid_rreq = (reconfig_eth_read & ~read_d1);
wire    valid_wreq = (reconfig_eth_write & ~write_d1);

always @(posedge i_reconfig_clk) begin
  write_d1      <=  reconfig_eth_write; 
  read_d1       <=  reconfig_eth_read; 
  valid_wreq_d1 <= valid_wreq;
  valid_rreq_d1 <= valid_rreq;
end

always @(posedge i_reconfig_clk) begin
  if (i_reconfig_reset)		waitreq_wr <= 1'b0;
  else if (valid_wreq)		waitreq_wr <= 1'b1;
  else if (valid_wreq_d1)	waitreq_wr <= 1'b0;
  if (i_reconfig_reset)		waitreq_rd <= 1'b0;
  else if (valid_rreq)		waitreq_rd <= 1'b1;
  else if (valid_rreq_d1)	waitreq_rd <= 1'b0;
end

assign  sip_waitrequest = i_reconfig_reset | (valid_wreq | waitreq_wr) | (valid_rreq | waitreq_rd);


  // MAC statistics Bug fix logic


always_comb begin
      if (link_fault_config_unidir_10g == 1'b1) begin
        if ((~f_rx_operational_reconfigsync) && rst_in_prog && ehip_sel_excl_rxmacaddr )	 skip_ehip_req = 1'b1;
	else if (rst_in_prog && ehip_sel_excl_pcsaddr)	skip_ehip_req = 1'b1;
	else skip_ehip_req = 1'b0;
      end else begin
        if (rst_in_prog && (ehip_sel_excl_rxmacaddr || ehip_sel_excl_txmacaddr) ) skip_ehip_req = 1'b1;
	     else if (rst_in_prog && ehip_sel_excl_pcsaddr)	skip_ehip_req = 1'b1;
	     else skip_ehip_req = 1'b0;
      end 
end

////check if Write in progress OR read in progress
always @(posedge i_reconfig_clk) begin
  if (i_reconfig_reset)		avmm_in_progress <= 1'b0;
  else if ((reconfig_eth_write || reconfig_eth_read) && ehip_sel && src_avmm1_req_pulse)  avmm_in_progress <= 1'b1; 
else if (!reconfig_eth_waitrequest) avmm_in_progress <= 1'b0;
end

always @(posedge i_reconfig_clk) begin
  src_avmm1_req_reg <= src_avmm1_req;
end

assign src_avmm1_req_pulse = src_avmm1_req & ~src_avmm1_req_reg;

always @(posedge i_reconfig_clk) begin
  src_avmm1_ack <= src_avmm1_req_reg & ~avmm_in_progress;
end


always @(posedge i_reconfig_clk) begin
  if (i_reconfig_reset)		rst_in_prog_reg <= 1'b0;
  else if (src_avmm1_ack || (~f_tx_operational_reconfigsync) || (~f_rx_operational_reconfigsync))  rst_in_prog_reg <= 1'b1;
  else if (f_tx_operational_reconfigsync && f_rx_operational_reconfigsync) rst_in_prog_reg <= 1'b0;
end

assign rst_in_prog = src_avmm1_ack || rst_in_prog_reg ;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


  eth_f_base_sip_csr soft_csr (
     // .gui_option_device_name                                      (device_name[1:0]), // 0:Stratix 10, 1:Falcon Mesa
     // .gui_option_tile_name                                        (tile_name[2:0]), // 0:H-tile,1:L-tile,2:E-tile,3:F-tile, 4-7:reserved
      .gui_option_eth_rate_i                                       (eth_rate_int[2:0]),
      .gui_option_anlt_enable_i                                    (anlt_enable),
      .gui_option_modulation_type_i                                (modulation_type),
      .gui_option_rsfec_type_i                                     (rsfec_type[2:0]),
      .gui_option_ptp_enable_i                                     (ENABLE_PTP ? 1'b1: 1'b0),
      .gui_option_flow_control_mode_i                              (flow_control_mode[2:0]),
      .gui_option_client_intf_i                                    (client_intf[2:0]),
      .gui_option_xcvr_type_i                                      (xcvr_type),
      .gui_option_num_lanes_i                                      (num_lanes[3:0]),
      .eth_reset_eio_sys_rst                                       (eth_reset_eio_sys_rst),
      .eth_reset_soft_tx_rst                                       (eth_reset_soft_tx_rst),
      .eth_reset_soft_rx_rst                                       (eth_reset_soft_rx_rst),
      .eth_reset_tx_clear_alarm(eth_reset_tx_clear_alarm[7:0]),
      .eth_reset_rx_clear_alarm(eth_reset_rx_clear_alarm[7:0]),
      .eth_reset_status_rst_ack_n_i                                (rst_ack_n),
      .eth_reset_status_tx_rst_ack_n_i                             (tx_rst_ack_n),
      .eth_reset_status_rx_rst_ack_n_i                             (rx_rst_ack_n),
      .eth_reset_status_tx_lane_current_state_i(eth_reset_status_tx_lane_current_state_i[2:0]),
      .eth_reset_status_rx_lane_current_state_i(eth_reset_status_rx_lane_current_state_i[2:0]),
      .eth_reset_status_tx_alarm_i(eth_reset_status_tx_alarm_i[7:0]),
      .eth_reset_status_rx_alarm_i(eth_reset_status_rx_alarm_i[7:0]),
      .phy_tx_pll_locked_tx_pll_locked_i(phy_tx_pll_locked_tx_pll_locked_i[7:0]),
      .phy_eiofreq_locked_eio_freq_lock_i(phy_eiofreq_locked_eio_freq_lock_i[7:0]),
      .pcs_status_dskew_status_i(pcs_status_dskew_status_i),
      .pcs_status_dskew_chng_i(pcs_status_dskew_chng_i),
      .pcs_status_tx_lanes_stable_i(tx_lanes_stable_status), 
      .pcs_status_rx_pcs_ready_i(pcs_status_rx_pcs_ready_i),
      .pcs_status_kr_mode_i(pcs_status_kr_mode_i),
      .pcs_status_kr_fec_mode_i(pcs_status_kr_fec_mode_i),
      .pcs_control_clr_dskew_chng(pcs_control_clr_dskew_chng),
      .link_fault_status_lfault_i(ehip_local_fault_status),
      .link_fault_status_rfault_i(ehip_remote_fault_status),
      .aib_transfer_ready_status_ehip_rx_transfer_ready_i(rxaib_transfer_ready_ehip),
      .aib_transfer_ready_status_ehip_tx_transfer_ready_i(txaib_transfer_ready_ehip),
      .clk_tx_khz_clk_tx_khz_i                                     (clk_tx_khz),
      .clk_rx_khz_clk_rx_khz_i                                     (clk_rx_khz),
      .clk_pll_khz_clk_pll_khz_i                                   (clk_pll_khz),
      .clk_tx_div_khz_clk_tx_div_khz_i                             (clk_tx_div_khz),
      .clk_rec_div64_khz_clk_rec_div64_khz_i                       (clk_rec_div64_khz),
      .clk_rec_div_khz_clk_rec_div_khz_i                           (clk_rec_div_khz),
      .rxmac_adapt_dropped_31_0_rxmac_adapt_dropped_31_0_i         (dropped_frame_cnt[31:0]),
      .rxmac_adapt_dropped_63_32_rxmac_adapt_dropped_63_32_i       (dropped_frame_cnt[63:32]),
      .rxmac_adapt_dropped_control_rxmac_adapt_dropped_clear       (dropped_clear),
      .rxmac_adapt_dropped_control_rxmac_adapt_dropped_snapshot    (dropped_frame_snapshot),
      .cwbin_control_register_cwbin_control_register					 (reset_swcwbin),
	.cwbin0_A_cwbin0_A_i					  (cwbin0_stat_block_A_i),
	.cwbin1_A_cwbin1_A_i					  (cwbin1_stat_block_A_i),
	.cwbin2_A_cwbin2_A_i					  (cwbin2_stat_block_A_i),
	.cwbin3_A_cwbin3_A_i					  (cwbin3_stat_block_A_i),
	.cwbin0_B_cwbin0_B_i					  (cwbin0_stat_block_B_i),
	.cwbin1_B_cwbin1_B_i					  (cwbin1_stat_block_B_i),
	.cwbin2_B_cwbin2_B_i					  (cwbin2_stat_block_B_i),
	.cwbin3_B_cwbin3_B_i					  (cwbin3_stat_block_B_i),
        .cwbin_timer_cwbin_timer				(cwbin_timer_timeout),
	.tx_pkt_sts_clr    (tx_pkt_sts_clr      ),
        .rx_pkt_sts_clr    (rx_pkt_sts_clr      ),
	.rx_lf_rf_pcs_clr  (rx_lf_rf_pcs_clr    ),
	.tx_pkr_sop_cnt_lo (tx_pkr_sop_cnt_lo   ),
	.tx_pkr_sop_cnt_hi (tx_pkr_sop_cnt_hi   ),
	.tx_pkr_eop_cnt_lo (tx_pkr_eop_cnt_lo   ),
	.tx_pkr_eop_cnt_hi (tx_pkr_eop_cnt_hi   ),
	.tx_pkr_byte_cnt_lo(tx_pkr_byte_cnt_lo  ),
	.tx_pkr_byte_cnt_hi(tx_pkr_byte_cnt_hi  ),
	.tx_mac_sop_cnt_lo (tx_mac_sop_cnt_lo   ),
	.tx_mac_sop_cnt_hi (tx_mac_sop_cnt_hi   ),
	.tx_mac_eop_cnt_lo (tx_mac_eop_cnt_lo   ),
	.tx_mac_eop_cnt_hi (tx_mac_eop_cnt_hi   ),
	.tx_mac_byte_cnt_lo(tx_mac_byte_cnt_lo  ),
	.tx_mac_byte_cnt_hi(tx_mac_byte_cnt_hi  ),
	.rx_mac_sop_cnt_lo (rx_mac_sop_cnt_lo   ),
	.rx_mac_sop_cnt_hi (rx_mac_sop_cnt_hi   ),
	.rx_mac_eop_cnt_lo (rx_mac_eop_cnt_lo   ),
	.rx_mac_eop_cnt_hi (rx_mac_eop_cnt_hi   ),
	.rx_mac_byte_cnt_lo(rx_mac_byte_cnt_lo  ),
	.rx_mac_byte_cnt_hi(rx_mac_byte_cnt_hi  ),
	.tx_pkr_max_fifo_level(tx_pkr_max_fifo_level  ),
	.tx_pkr_min_fifo_level(tx_pkr_min_fifo_level  ),
	.tx_pkr_fifo_empty_cnt(tx_pkr_fifo_empty_cnt  ),
	.local_remote_pcs_cntr(local_remote_pcs_cntr),
.tx_sync_counter_1L_tx_sync_counter_1L_i     (tx_sync_counter_i[0][31:0]),
.tx_async_counter_1L_tx_async_counter_1L_i   (tx_async_counter_i[0][31:0]),
.rx_sync_counter_1L_rx_sync_counter_1L_i     (rx_sync_counter_i[0][31:0]),
.rx_async_counter_1L_rx_async_counter_1L_i   (rx_async_counter_i[0][31:0]),
.dl_cfg_1L_rx_measure_valid_i                (rx_measure_valid_i[0]),
.dl_cfg_1L_tx_measure_valid_i                (tx_measure_valid_i[0]),
.dl_cfg_1L_rx_dl_restart                     (rx_dl_restart[0]),
.dl_cfg_1L_tx_dl_restart                     (tx_dl_restart[0]),
.tx_dl_delay_1L_tx_dl_delay_1L_i             (tx_dl_delay_i[0][31:0]),
.rx_dl_delay_1L_rx_dl_delay_1L_i             (rx_dl_delay_i[0][31:0]),
.dl_status_1L_rx_async_valid_i               (rx_async_valid_i[0]),
.dl_status_1L_rx_sync_valid_i                (rx_sync_valid_i[0]),
.dl_status_1L_tx_async_valid_i               (tx_async_valid_i[0]),
.dl_status_1L_tx_sync_valid_i                (tx_sync_valid_i[0]),
.tx_sync_counter_2L_tx_sync_counter_2L_i     (tx_sync_counter_i[1][31:0]),
.tx_async_counter_2L_tx_async_counter_2L_i   (tx_async_counter_i[1][31:0]),
.rx_sync_counter_2L_rx_sync_counter_2L_i     (rx_sync_counter_i[1][31:0]),
.rx_async_counter_2L_rx_async_counter_2L_i   (rx_async_counter_i[1][31:0]),
.dl_cfg_2L_rx_measure_valid_i                (rx_measure_valid_i[1]),
.dl_cfg_2L_tx_measure_valid_i                (tx_measure_valid_i[1]),
.dl_cfg_2L_rx_dl_restart                     (rx_dl_restart[1]),
.dl_cfg_2L_tx_dl_restart                     (tx_dl_restart[1]),
.tx_dl_delay_2L_tx_dl_delay_2L_i             (tx_dl_delay_i[1]),
.rx_dl_delay_2L_rx_dl_delay_2L_i             (rx_dl_delay_i[1]),
.dl_status_2L_rx_async_valid_i               (rx_async_valid_i[1]),
.dl_status_2L_rx_sync_valid_i                (rx_sync_valid_i[1]),
.dl_status_2L_tx_async_valid_i               (tx_async_valid_i[1]),
.dl_status_2L_tx_sync_valid_i                (tx_sync_valid_i[1]),
.tx_sync_counter_3L_tx_sync_counter_3L_i     (tx_sync_counter_i[2]),
.tx_async_counter_3L_tx_async_counter_3L_i   (tx_async_counter_i[2]),
.rx_sync_counter_3L_rx_sync_counter_3L_i     (rx_sync_counter_i[2]),
.rx_async_counter_3L_rx_async_counter_3L_i   (rx_async_counter_i[2]),
.dl_cfg_3L_rx_measure_valid_i                (rx_measure_valid_i[2]),
.dl_cfg_3L_tx_measure_valid_i                (tx_measure_valid_i[2]),
.dl_cfg_3L_rx_dl_restart                     (rx_dl_restart[2]),
.dl_cfg_3L_tx_dl_restart                     (tx_dl_restart[2]),
.tx_dl_delay_3L_tx_dl_delay_3L_i             (tx_dl_delay_i[2]),
.rx_dl_delay_3L_rx_dl_delay_3L_i             (rx_dl_delay_i[2]),
.dl_status_3L_rx_async_valid_i               (rx_async_valid_i[2]),
.dl_status_3L_rx_sync_valid_i                (rx_sync_valid_i[2]),
.dl_status_3L_tx_async_valid_i               (tx_async_valid_i[2]),
.dl_status_3L_tx_sync_valid_i                (tx_sync_valid_i[2]),
.tx_sync_counter_4L_tx_sync_counter_4L_i     (tx_sync_counter_i[3]),
.tx_async_counter_4L_tx_async_counter_4L_i   (tx_async_counter_i[3]),
.rx_sync_counter_4L_rx_sync_counter_4L_i     (rx_sync_counter_i[3]),
.rx_async_counter_4L_rx_async_counter_4L_i   (rx_async_counter_i[3]),
.dl_cfg_4L_rx_measure_valid_i                (rx_measure_valid_i[3]),
.dl_cfg_4L_tx_measure_valid_i                (tx_measure_valid_i[3]),
.dl_cfg_4L_rx_dl_restart                     (rx_dl_restart[3]),
.dl_cfg_4L_tx_dl_restart                     (tx_dl_restart[3]),
.tx_dl_delay_4L_tx_dl_delay_4L_i             (tx_dl_delay_i[3]),
.rx_dl_delay_4L_rx_dl_delay_4L_i             (rx_dl_delay_i[3]),
.dl_status_4L_rx_async_valid_i               (rx_async_valid_i[3]),
.dl_status_4L_rx_sync_valid_i                (rx_sync_valid_i[3]),
.dl_status_4L_tx_async_valid_i               (tx_async_valid_i[3]),
.dl_status_4L_tx_sync_valid_i                (tx_sync_valid_i[3]),
.tx_sync_counter_5L_tx_sync_counter_5L_i     (tx_sync_counter_i[4]),
.tx_async_counter_5L_tx_async_counter_5L_i   (tx_async_counter_i[4]),
.rx_sync_counter_5L_rx_sync_counter_5L_i     (rx_sync_counter_i[4]),
.rx_async_counter_5L_rx_async_counter_5L_i   (rx_async_counter_i[4]),
.dl_cfg_5L_rx_measure_valid_i                (rx_measure_valid_i[4]),
.dl_cfg_5L_tx_measure_valid_i                (tx_measure_valid_i[4]),
.dl_cfg_5L_rx_dl_restart                     (rx_dl_restart[4]),
.dl_cfg_5L_tx_dl_restart                     (tx_dl_restart[4]),
.tx_dl_delay_5L_tx_dl_delay_5L_i             (tx_dl_delay_i[4]),
.rx_dl_delay_5L_rx_dl_delay_5L_i             (rx_dl_delay_i[4]),
.dl_status_5L_rx_async_valid_i               (rx_async_valid_i[4]),
.dl_status_5L_rx_sync_valid_i                (rx_sync_valid_i[4]),
.dl_status_5L_tx_async_valid_i               (tx_async_valid_i[4]),
.dl_status_5L_tx_sync_valid_i                (tx_sync_valid_i[4]),
.tx_sync_counter_6L_tx_sync_counter_6L_i     (tx_sync_counter_i[5]),
.tx_async_counter_6L_tx_async_counter_6L_i   (tx_async_counter_i[5]),
.rx_sync_counter_6L_rx_sync_counter_6L_i     (rx_sync_counter_i[5]),
.rx_async_counter_6L_rx_async_counter_6L_i   (rx_async_counter_i[5]),
.dl_cfg_6L_rx_measure_valid_i                (rx_measure_valid_i[5]),
.dl_cfg_6L_tx_measure_valid_i                (tx_measure_valid_i[5]),
.dl_cfg_6L_rx_dl_restart                     (rx_dl_restart[5]),
.dl_cfg_6L_tx_dl_restart                     (tx_dl_restart[5]),
.tx_dl_delay_6L_tx_dl_delay_6L_i             (tx_dl_delay_i[5]),
.rx_dl_delay_6L_rx_dl_delay_6L_i             (rx_dl_delay_i[5]),
.dl_status_6L_rx_async_valid_i               (rx_async_valid_i[5]),
.dl_status_6L_rx_sync_valid_i                (rx_sync_valid_i[5]),
.dl_status_6L_tx_async_valid_i               (tx_async_valid_i[5]),
.dl_status_6L_tx_sync_valid_i                (tx_sync_valid_i[5]),
.tx_sync_counter_7L_tx_sync_counter_7L_i     (tx_sync_counter_i[6]),
.tx_async_counter_7L_tx_async_counter_7L_i   (tx_async_counter_i[6]),
.rx_sync_counter_7L_rx_sync_counter_7L_i     (rx_sync_counter_i[6]),
.rx_async_counter_7L_rx_async_counter_7L_i   (rx_async_counter_i[6]),
.dl_cfg_7L_rx_measure_valid_i                (rx_measure_valid_i[6]),
.dl_cfg_7L_tx_measure_valid_i                (tx_measure_valid_i[6]),
.dl_cfg_7L_rx_dl_restart                     (rx_dl_restart[6]),
.dl_cfg_7L_tx_dl_restart                     (tx_dl_restart[6]),
.tx_dl_delay_7L_tx_dl_delay_7L_i             (tx_dl_delay_i[6]),
.rx_dl_delay_7L_rx_dl_delay_7L_i             (rx_dl_delay_i[6]),
.dl_status_7L_rx_async_valid_i               (rx_async_valid_i[6]),
.dl_status_7L_rx_sync_valid_i                (rx_sync_valid_i[6]),
.dl_status_7L_tx_async_valid_i               (tx_async_valid_i[6]),
.dl_status_7L_tx_sync_valid_i                (tx_sync_valid_i[6]),
.tx_sync_counter_8L_tx_sync_counter_8L_i     (tx_sync_counter_i[7]),
.tx_async_counter_8L_tx_async_counter_8L_i   (tx_async_counter_i[7]),
.rx_sync_counter_8L_rx_sync_counter_8L_i     (rx_sync_counter_i[7]),
.rx_async_counter_8L_rx_async_counter_8L_i   (rx_async_counter_i[7]),
.dl_cfg_8L_rx_measure_valid_i                (rx_measure_valid_i[7]),
.dl_cfg_8L_tx_measure_valid_i                (tx_measure_valid_i[7]),
.dl_cfg_8L_rx_dl_restart                     (rx_dl_restart[7]),
.dl_cfg_8L_tx_dl_restart                     (tx_dl_restart[7]),
.tx_dl_delay_8L_tx_dl_delay_8L_i             (tx_dl_delay_i[7]),
.rx_dl_delay_8L_rx_dl_delay_8L_i             (rx_dl_delay_i[7]),
.dl_status_8L_rx_async_valid_i               (rx_async_valid_i[7]),
.dl_status_8L_rx_sync_valid_i                (rx_sync_valid_i[7]),
.dl_status_8L_tx_async_valid_i               (tx_async_valid_i[7]),
.dl_status_8L_tx_sync_valid_i                (tx_sync_valid_i[7]),
.packer_da_mismatch_cnt_in_lo    (pack_da_mismatch_cnt_in[31:0]),
.packer_da_mismatch_cnt_in_hi    (pack_da_mismatch_cnt_in[63:32]),
.packer_da_mismatch_cnt_out_lo   (pack_da_mismatch_cnt_out[31:0]),
.packer_da_mismatch_cnt_out_hi   (pack_da_mismatch_cnt_out[63:32]),
.packer_da_match_cnt_in_lo       (pack_da_match_cnt_in[31:0]),
.packer_da_match_cnt_in_hi       (pack_da_match_cnt_in[63:32]),
.packer_da_match_cnt_out_lo      (pack_da_match_cnt_out[31:0]),
.packer_da_match_cnt_out_hi      (pack_da_match_cnt_out[63:32]),
.tx_pause_da_mismatch_cnt_in_lo  (tx_pause_da_mismatch_cnt_in[31:0] ),
.tx_pause_da_mismatch_cnt_in_hi  (tx_pause_da_mismatch_cnt_in[63:32] ),
.tx_pause_da_mismatch_cnt_out_lo (tx_pause_da_mismatch_cnt_out[31:0]),
.tx_pause_da_mismatch_cnt_out_hi (tx_pause_da_mismatch_cnt_out[63:32]),
.tx_pause_da_match_cnt_in_lo     (tx_pause_da_match_cnt_in[31:0]),
.tx_pause_da_match_cnt_in_hi     (tx_pause_da_match_cnt_in[63:32]),
.tx_pause_da_match_cnt_out_lo    (tx_pause_da_match_cnt_out[31:0]),
.tx_pause_da_match_cnt_out_hi    (tx_pause_da_match_cnt_out[63:32]),
.config_ehip_rst_count               		(config_ehip_rst_count),
      .clk                                                         (i_reconfig_clk),
      .reset                                                       (i_reconfig_reset),
      .writedata                                                   (reconfig_eth_writedata_f),
      .read                                                        (soft_csr_base_read),
      .write                                                       (soft_csr_base_write),
      .byteenable                                                  (reconfig_eth_byteenable),
      .readdata                                                    (soft_csr_base_readdata),
      .readdatavalid                                               (soft_csr_base_readdata_valid),
      .address                                                     ({reconfig_eth_addr[8:0],2'b00})
);

  generate if (ENABLE_PTP == 1) begin : g_ptp
    eth_f_ptp_csr #(
      .PL (LANE_NUM)
    ) soft_ptp_csr (
      .clk                            (i_reconfig_clk             ),
      .reset                          (i_reconfig_reset           ),
      .writedata                      (reconfig_eth_writedata_f   ),
      .read                           (soft_csr_ptp_read          ),
      .write                          (soft_csr_ptp_write         ),
      .byteenable                     (reconfig_eth_byteenable  ),
      .readdata                       (soft_csr_ptp_readdata      ),
      .readdatavalid                  (soft_csr_ptp_readdata_valid),
      .address                        ({reconfig_eth_addr[9:0],2'b00}  ),
      // Input
      .i_tx_ehip_preamble_passthru_gui (i_tx_ehip_preamble_passthru_gui),
      .o_tx_ehip_preamble_passthru_dr  (o_tx_ehip_preamble_passthru_dr),
      // Input
      .i_ptp_clk                      (i_ptp_clk          ),
      .i_tx_tod_clk                   (i_tx_tod_clk       ),
      .i_rx_tod_clk                   (i_rx_tod_clk       ),
      .i_samp_clk                     (i_samp_clk         ),
      .i_tx_srst_n                    (i_tx_srst_n        ),
      .i_rx_srst_n                    (i_rx_srst_n        ),
      .i_tx_tod_srst_n                (i_tx_tod_srst_n    ),
      .i_rx_tod_srst_n                (i_rx_tod_srst_n    ),
      .i_tx_samp_srst_n               (i_tx_samp_srst_n   ),
      .i_rx_samp_srst_n               (i_rx_samp_srst_n   ),
      .i_tx_lanes_stable_status       (tx_lanes_stable_status),
      .i_rx_pcs_fully_aligned         (i_rx_pcs_fully_aligned),
      .i_tx_apulse_wdly_valid         (i_tx_apulse_wdly_valid         ),
      .i_tx_apulse_offset_valid       (i_tx_apulse_offset_valid       ),
      .i_tx_apulse_time_valid         (i_tx_apulse_time_valid         ),
      .i_rx_apulse_wdly_valid         (i_rx_apulse_wdly_valid         ),
      .i_rx_apulse_offset_valid       (i_rx_apulse_offset_valid       ),
      .i_rx_apulse_time_valid         (i_rx_apulse_time_valid         ),
      .i_tx_apulse_wdly               (i_tx_apulse_wdly               ),
      .i_tx_apulse_offset             (i_tx_apulse_offset             ),
      .i_tx_apulse_time               (i_tx_apulse_time               ),
      .i_rx_apulse_wdly               (i_rx_apulse_wdly               ),
      .i_rx_apulse_offset             (i_rx_apulse_offset             ),
      .i_rx_apulse_time               (i_rx_apulse_time               ),
      .i_tx_const_adjust              (i_tx_const_adjust              ),
      .i_rx_const_adjust              (i_rx_const_adjust              ),
      .i_rx_ptp_vl_snapshot           (i_rx_ptp_vl_snapshot           ),
      .i_tx_tam_valid                 (i_tx_tam_valid                 ),
      .i_tx_tam_cnt                   (i_tx_tam_cnt                   ),
      .i_tx_tam_ui                    (i_tx_tam_ui                    ),
      .i_rx_tam_valid                 (i_rx_tam_valid                 ),
      .i_rx_tam_cnt                   (i_rx_tam_cnt                   ),
      .i_rx_tam_ui                    (i_rx_tam_ui                    ),
      .i_tx_ptp_offset_data_valid     (i_tx_ptp_offset_data_valid     ),
      .i_rx_ptp_offset_data_valid     (i_rx_ptp_offset_data_valid     ),
      .i_tx_ptp_ready                 (i_tx_ptp_ready                 ),
      .i_rx_ptp_ready                 (i_rx_ptp_ready                 ),
      .i_tx_ptp_user_cfg_done_clrn    (i_tx_ptp_user_cfg_done_clrn    ),
      .i_rx_ptp_user_cfg_done_clrn    (i_rx_ptp_user_cfg_done_clrn    ),
      // Output
      .o_rx_lal                       (o_rx_lal                       ),
      .o_tx_ref_lane                  (o_tx_ref_lane                  ),
      .o_tx_calc_adjust               (o_tx_calc_adjust               ),
      .o_rx_calc_adjust               (o_rx_calc_adjust               ),
      .o_rx_fec_cw_pos_user_cfg_done  (o_rx_fec_cw_pos_user_cfg_done  ),
      .o_tx_ptp_user_cfg_done         (o_tx_ptp_user_cfg_done         ),
      .o_rx_ptp_user_cfg_done         (o_rx_ptp_user_cfg_done         )
    );
  end
  else begin : no_g_ptp
    // read data is always returned on the next cycle
    always @(posedge i_reconfig_clk)
        if (i_reconfig_reset) soft_csr_ptp_readdata_valid <= 1'b0; else soft_csr_ptp_readdata_valid <= soft_csr_ptp_read;
        
    assign soft_csr_ptp_readdata            = 32'b0;
    assign o_rx_lal                         = 3'b000;
    assign o_tx_ref_lane                    = 3'b000;
    assign o_tx_calc_adjust_valid           = 1'b0;
    assign o_tx_calc_adjust                 = 32'd0;
    assign o_rx_calc_adjust_valid           = 1'b0;
    assign o_rx_calc_adjust                 = 32'd0;
    assign o_rx_vl_offset_user_cfg_done     = 1'b0;
    assign o_rx_fec_cw_pos_user_cfg_done    = 1'b0;
    assign o_tx_ptp_user_cfg_done           = 1'b0;
    assign o_rx_ptp_user_cfg_done           = 1'b0;
    assign o_tx_ehip_preamble_passthru_dr   = 1'b0;
  end
  endgenerate



  // TODO: make connection between bridge and avmm1 BB signals
  //
  
  eth_f_ft_avmm_32to8_bridge #(
      .READ_PIPELINE_ENABLE (1),
      .ADDR_WIDTH           (17)
  ) avmm_32b_to_8b (

      // AVMM slave port  
      .i_clk                    (i_reconfig_clk),
      .i_rst                    (i_reconfig_reset),
 
      .i_avmm_s32_addr          ({1'b0,reconfig_eth_addr[13:0],2'b00}),
      .i_avmm_s32_wdata         (reconfig_eth_writedata_f[31:0]),
      .i_avmm_s32_write         (ehip_write),
      .i_avmm_s32_read          (ehip_read),
      .i_avmm_s32_byte_enable   (reconfig_eth_byteenable[3:0]),
      .o_avmm_s32_readdata      (ehip_readdata[31:0]),
      .o_avmm_s32_waitrequest   (ehip_waitrequest),
      .o_avmm_s32_readdatavalid (ehip_readdata_valid),

      // AVMM Master Port
      .o_avmm_m8_addr           (avmm_m8_addr[17:0]), //[17]: DW access
      .o_avmm_m8_wdata          (avmm_m8_wdata[7:0]),
      .o_avmm_m8_write          (avmm_m8_write),
      .o_avmm_m8_read           (avmm_m8_read),
      .i_avmm_m8_readdata       (avmm_m8_readdata[7:0]),
      .i_avmm_m8_waitrequest    (avmm_m8_waitrequest)
  );

 wire [1:0] addr_b9_b8 = is_maib ? 2'b11: {1'b0, avmm_m8_addr[17]};

 eth_f_ctfb_avmm1_soft_logic 
 #(
    .avmm_interfaces (1),  //Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGkjkB
    .rcfg_enable     (1)   //Enable/disable reconfig interface in the Native PHY or PLL IP
 )  ctfb_avmm1_soft_logic_inst (
  //PORT_LIST_START
  // AVMM slave interface signals (user)
    .avmm_clk                   (i_reconfig_clk),
    .avmm_reset                 (i_reconfig_reset),
    .avmm_writedata             (avmm_m8_wdata[7:0]),
    .avmm_address               ({addr_b9_b8, avmm_m8_addr[7:0]}), //10 bits. addr[9:8]:2'b11 for MAIB, rest for F-tile, addr[8] is Dword Access
    .avmm_reservedin            (avmm_m8_addr[16:8]), //9 bits
    .avmm_write                 (avmm_m8_write),
    .avmm_read                  (avmm_m8_read),
    .avmm_readdata              (avmm_m8_readdata[7:0]),
    .avmm_waitrequest           (avmm_m8_waitrequest),
  // Signals from AVMM1 building block
    .pld_avmm1_busy_real        (pld_avmm1_busy),
    .pld_avmm1_cmdfifo_wr_full_real (pld_avmm1_cmdfifo_wr_full),
    .pld_avmm1_cmdfifo_wr_pfull_real(pld_avmm1_cmdfifo_wr_pfull),
    .pld_avmm1_readdata_real    (pld_avmm1_readdata[7:0]), // 8 bits
    .pld_avmm1_readdatavalid_real(pld_avmm1_readdatavalid),
    .pld_avmm1_reserved_out_real (pld_avmm1_reserved_out), // 3 bits
    .pld_chnl_cal_done_real      (pld_chnl_cal_done), 
    .pld_hssi_osc_transfer_en_real (pld_hssi_osc_transfer_en),
  // Signals to AVMM1 building block
    .pld_avmm1_clk_rowclk_real    (pld_avmm1_clk_rowclk),
    .pld_avmm1_read_real          (pld_avmm1_read),
    .pld_avmm1_reg_addr_real      (pld_avmm1_reg_addr[9:0]), // 10 bits
    .pld_avmm1_request_real       (pld_avmm1_request),
    .pld_avmm1_reserved_in_real   (pld_avmm1_reserved_in[8:0]), // 9 bits
    .pld_avmm1_write_real         (pld_avmm1_write),
    .pld_avmm1_writedata_real     (pld_avmm1_writedata[7:0]) // 8 bits
  //PORT_LIST_END
);

generate
 
if (CLIENT_INT < 2)begin: GEN_LF_RF

  eth_f_rf_lf_logic soft_lf_rf_logic (
.i_reconfig_clk  					(i_reconfig_clk),
.i_reconfig_reset					(i_reconfig_reset),
.i_ehip_rate 						(eth_rate_int),
.i_local_fault						(~f_rx_operational_reconfigsync),
.o_rf_in_progress					(o_rf_in_progress),
.i_reconfig_write					(i_reconfig_eth_write),
.i_reconfig_byteenable			(i_reconfig_eth_byteenable),		
.i_reconfig_read					(i_reconfig_eth_read),	
.i_reconfig_addr					(i_reconfig_eth_addr),
.i_reconfig_writedata			(i_reconfig_eth_writedata),
.o_reconfig_readdata				(o_reconfig_eth_readdata),
.o_reconfig_readdata_valid		(o_reconfig_eth_readdata_valid),
.o_reconfig_waitrequest		   (o_reconfig_eth_waitrequest),
.o_rcfg_write					   (reconfig_eth_write),
.o_rcfg_byteenable				(reconfig_eth_byteenable),
.o_rcfg_read						(reconfig_eth_read),
.o_rcfg_addr						(reconfig_eth_addr),
.o_rcfg_writedata					(reconfig_eth_writedata),
.i_rcfg_readdata					(reconfig_eth_readdata),
.i_rcfg_readdata_valid			(reconfig_eth_readdata_valid),	
.i_rcfg_waitrequest				(reconfig_eth_waitrequest)	

);
end
  else 
   begin: NO_LF_RF
                assign  reconfig_eth_addr                 =   i_reconfig_eth_addr;
                assign  reconfig_eth_byteenable           =   i_reconfig_eth_byteenable;
                assign  reconfig_eth_read                 =   i_reconfig_eth_read;
                assign  reconfig_eth_write                =   i_reconfig_eth_write;
                assign  reconfig_eth_writedata            =   i_reconfig_eth_writedata;
                assign  o_reconfig_eth_readdata_valid     =    reconfig_eth_readdata_valid ;
                assign  o_reconfig_eth_readdata           =   reconfig_eth_readdata ;
                assign  o_reconfig_eth_waitrequest        =   reconfig_eth_waitrequest ;
                assign  o_rf_in_progress                  =  1'b0;   //Non MAC need to change accordingly
    end	

    endgenerate
	 
	 
generate
 
if (CLIENT_INT < 2)begin: GEN_PAUSE 

logic ninit_done, reset;

	eth_f_por u0 (
		.ninit_done (ninit_done)  //  output,  width = 1, ninit_done.ninit_done
	);

eth_f_reset_synchronizer ninit_done_rst_sync (
        .clk            (i_reconfig_clk),
        .aclr           (ninit_done),
        .aclr_sync      (reset)
    );	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////RX PAUSE snooping logic    ///////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// rx_pause_fwd - 0x264 - bit 0 - rx_pause_fwd
//  rx_pause_daddrl - 0x268 - bit 31:0
// rx_pause_daddrh - 0x26C - bit 15:0 - high address
//rxsfc_ehip_cfg - 0x270 - bit0 -en_sfc, 
//tx_xof_en_tx_pause_qnumber - 0x240 - bit2:0 -en_xoff_qnum_sel

logic [11:0] ehip_addr_tx_xof_en_tx_pause_qnumber;
logic [11:0] ehip_addr_rx_pause_fwd;
logic [11:0] ehip_addr_rx_pause_daddrl;
logic [11:0] ehip_addr_rx_pause_daddrh;
logic [11:0] ehip_addr_rxsfc_ehip_cfg;
logic [11:0] ehip_addr_rxmac_ehip_cfg;

logic [2:0] ehip_tx_xof_en_tx_pause_qnumber;
logic  		ehip_rx_pause_fwd;
logic [31:0] ehip_rx_pause_daddrl;
logic [15:0] ehip_rx_pause_daddrh;
logic ehip_rxsfc_ehip_cfg_en_sfc;
logic sip_en;
logic ehip_rx_en_pp;

logic addr_en_tx_xof_en1; 			
logic addr_en_rx_pause_fwd1 ;		
logic addr_en_rxsfc_ehip_cfg1;
logic [31:0] reconfig_eth_writedata_f1;
	 logic tx_flow_control1;
	 logic forward_user_rxpause1;
	 logic    en_sfc1;
logic ehip_reg_access;
logic [3:0] ehip_addr_mask;
logic [2:0] ehip_readdata_mask1;
//logic [2:0] ehip_wrdata_mask1;

assign ehip_addr_rxmac_ehip_cfg     				=  'h228;
assign ehip_addr_tx_xof_en_tx_pause_qnumber 			=  'h240;
assign ehip_addr_rx_pause_fwd    				=  'h264;
assign ehip_addr_rx_pause_daddrl 				=  'h268;
assign ehip_addr_rx_pause_daddrh 				=  'h26C;
assign ehip_addr_rxsfc_ehip_cfg  				=  'h270;
//400G-6, 200G-5, 100G-4, 50G-3, 40G-2, 25G-1, 10G-0
assign ehip_addr_mask =  (eth_rate_int[2:0] == 3'b110) ? 4'h5 :  (eth_rate_int[2:0] == 3'b101) ? 4'h4 : (eth_rate_int[2:0] == 3'b100 || eth_rate_int[2:0] == 3'b010) ? 4'h3 :(eth_rate_int[2:0] == 3'b011) ? 4'h2 :  4'h1  ;


//////////////////Local copy of the EHIP PAUSE registers
assign ehip_reg_access = (ehip_addr_mask == reconfig_eth_addr[13:10])? 1'b1:1'b0;
//12bit comparators
assign addr_en_tx_xof_en1 		= (ehip_addr_tx_xof_en_tx_pause_qnumber == {reconfig_eth_addr[9:0],2'b00} && ehip_reg_access ==1 )? 1'b1:1'b0;
assign addr_en_rx_pause_fwd1 		= (ehip_addr_rx_pause_fwd == {reconfig_eth_addr[9:0],2'b00} && ehip_reg_access ==1  )? 1'b1:1'b0;
assign addr_en_rx_pause_daddrl 	= (ehip_addr_rx_pause_daddrl == {reconfig_eth_addr[9:0],2'b00} && ehip_reg_access ==1  )? 1'b1:1'b0;
assign addr_en_rx_pause_daddrh	= (ehip_addr_rx_pause_daddrh == {reconfig_eth_addr[9:0],2'b00} && ehip_reg_access ==1)? 1'b1:1'b0;
assign addr_en_rxsfc_ehip_cfg1 	= (ehip_addr_rxsfc_ehip_cfg == {reconfig_eth_addr[9:0],2'b00} && ehip_reg_access ==1)? 1'b1:1'b0;
assign addr_ehip_rx_en_pp   = (ehip_addr_rxmac_ehip_cfg == {reconfig_eth_addr[9:0],2'b00} && ehip_reg_access ==1)? 1'b1:1'b0;

localparam local_mac_rxpause_daddr = 48'h0180C2000001;
wire local_link_fault_config = (eth_link_fault==2'b01) ? 1'b1 :1'b0;
wire [3:0] byteen = (reconfig_eth_byteenable==4'h0)? 4'hF : reconfig_eth_byteenable;

wire	       we_tx_xof_en          = (reconfig_eth_write  & addr_en_tx_xof_en)		?	byteen[0]	:	{1'b0};
wire	       we_rx_pause_fwd       = (reconfig_eth_write  & addr_en_rx_pause_fwd)		?	byteen[0]	:	{1'b0};
wire	[3:0]  we_rx_pause_daddrl    = (reconfig_eth_write  & addr_en_rx_pause_daddrl)	?	byteen[3:0]	:	{4{1'b0}};
wire	[1:0]  we_rx_pause_daddrh    = (reconfig_eth_write  & addr_en_rx_pause_daddrh)	?	byteen[1:0]	:	{4{1'b0}};
wire	       we_ehip_cfg_en_sfc    = (reconfig_eth_write  & addr_en_rxsfc_ehip_cfg)	?	byteen[0]	:	{1'b0};
wire           we_addr_ehip_rx_en_pp = (reconfig_eth_write  & addr_ehip_rx_en_pp)	    ?	byteen[0]	:	{1'b0};
wire	       re_tx_xof_en          = (reconfig_eth_read  & addr_en_tx_xof_en)			?	byteen[0]	:	{1'b0};
wire	       re_rx_pause_fwd       = (reconfig_eth_read  & addr_en_rx_pause_fwd)		?	byteen[0]	:	{1'b0};
wire	       re_ehip_cfg_en_sfc    = (reconfig_eth_read  & addr_en_rxsfc_ehip_cfg)	?	byteen[0]	:	{1'b0};

logic re_tx_xof_en_r;
logic re_rx_pause_fwd_r;
logic re_ehip_cfg_en_sfc_r;

always @(  posedge i_reconfig_clk)
 begin
re_ehip_cfg_en_sfc_r   <= re_ehip_cfg_en_sfc;
re_rx_pause_fwd_r  <= re_rx_pause_fwd;
re_tx_xof_en_r   <= re_tx_xof_en;
end

always @(  posedge i_reconfig_clk)
 begin
if (reset | i_cfg_reset_new) begin
ehip_tx_xof_en_tx_pause_qnumber   <= mac_tx_xof;
end 
else if (we_tx_xof_en) begin 
      ehip_tx_xof_en_tx_pause_qnumber   <=  reconfig_eth_writedata[2:0];  //
   end
end

always @(  posedge i_reconfig_clk)
 begin
if (reset | i_cfg_reset_new) begin
ehip_rx_pause_fwd   <= mac_forward_rx_pause_requests; 
end else if (we_rx_pause_fwd) begin 
ehip_rx_pause_fwd   <=  reconfig_eth_writedata[0];  //
end
end

always @(  posedge i_reconfig_clk)
 begin
  if (reset | i_cfg_reset_new) begin
ehip_rx_pause_daddrl   <= local_mac_rxpause_daddr[31:0];
end 
   else begin
   if (we_rx_pause_daddrl[0]) begin 
      ehip_rx_pause_daddrl[7:0]   <=  reconfig_eth_writedata[7:0];  //
   end
   if (we_rx_pause_daddrl[1]) begin 
      ehip_rx_pause_daddrl[15:8]   <=  reconfig_eth_writedata[15:8];  //
   end
   if (we_rx_pause_daddrl[2]) begin 
      ehip_rx_pause_daddrl[23:16]   <=  reconfig_eth_writedata[23:16];  //
   end
   if (we_rx_pause_daddrl[3]) begin 
      ehip_rx_pause_daddrl[31:24]   <=  reconfig_eth_writedata[31:24];  //
   end
end
end

always @(  posedge i_reconfig_clk)
 begin
 if (reset | i_cfg_reset_new) begin
ehip_rx_pause_daddrh   <= local_mac_rxpause_daddr[47:32];
end
else begin
   if (we_rx_pause_daddrh[0]) begin 
      ehip_rx_pause_daddrh[7:0]   <=  reconfig_eth_writedata[7:0];  //
   end
   if (we_rx_pause_daddrh[1]) begin 
      ehip_rx_pause_daddrh[15:8]   <=  reconfig_eth_writedata[15:8];  //
   end
end 
end

always @(  posedge i_reconfig_clk)
 begin
if (reset | i_cfg_reset_new) begin
ehip_rxsfc_ehip_cfg_en_sfc   <= mac_flow_control;
end 
else if (we_ehip_cfg_en_sfc) begin 
      ehip_rxsfc_ehip_cfg_en_sfc   <=  reconfig_eth_writedata[0];  //
   end
end

always @(  posedge i_reconfig_clk)
 begin
  if (reset | i_cfg_reset_new) begin
ehip_rx_en_pp   <= mac_rx_en_pp;
end
else if (we_addr_ehip_rx_en_pp) begin 
      ehip_rx_en_pp   <=  reconfig_eth_writedata[0];  //
   end
end
///// read process
always @ (*)
begin
ehip_readdata_mask1 = 3'b000;
   if(re_tx_xof_en | re_tx_xof_en_r) 
	  ehip_readdata_mask1 [2:0]	= ehip_tx_xof_en_tx_pause_qnumber ; 
	else if (re_rx_pause_fwd | re_rx_pause_fwd_r)
	  ehip_readdata_mask1 [0]	= ehip_rx_pause_fwd ;
	else if (re_ehip_cfg_en_sfc | re_ehip_cfg_en_sfc_r)
	  ehip_readdata_mask1 [0]	= ehip_rxsfc_ehip_cfg_en_sfc  ;
	else
	  ehip_readdata_mask1 = 3'b000;
end

///// write process
//always @ (*)
//begin
//ehip_wrdata_mask1 = 3'b000;
//   if(reconfig_eth_write & (addr_en_tx_xof_en | r_addr_en_tx_xof_en)) 
//	  ehip_wrdata_mask1 [2:0]	= ehip_tx_xof_en_tx_pause_qnumber ; 
//	else if (reconfig_eth_write & (addr_en_rx_pause_fwd | r_addr_en_rx_pause_fwd))
//	  ehip_wrdata_mask1 [0]	= ehip_rx_pause_fwd ;
//	else if (reconfig_eth_write & (addr_en_rxsfc_ehip_cfg | r_addr_en_rxsfc_ehip_cfg))
//	  ehip_wrdata_mask1 [0]	= ehip_rxsfc_ehip_cfg_en_sfc  ;
//	else
//	  ehip_wrdata_mask1 = 3'b000;
//end

always @ (*)
begin
   if((addr_en_tx_xof_en )) 
	  reconfig_eth_writedata_f1 	= {reconfig_eth_writedata[31:3],3'b000} ; ////If disabled, TX MAC will not repond to XOFF request and will continue TX traffic flow
	else if ((addr_en_rx_pause_fwd ))
	  reconfig_eth_writedata_f1	= {reconfig_eth_writedata[31:1],1'b1} ; // always rx pause frames always enabled from HIP
	else if ((addr_en_rxsfc_ehip_cfg ))
	  reconfig_eth_writedata_f1	= {reconfig_eth_writedata[31:1],1'b0} ; //always keep the "enable SFC" on the EHIP to disabled
	else
	  reconfig_eth_writedata_f1 = reconfig_eth_writedata;
end

	 assign tx_flow_control1 = ehip_tx_xof_en_tx_pause_qnumber[0];
	 assign forward_user_rxpause1 = ehip_rx_pause_fwd;
	  assign en_sfc1 = ehip_rxsfc_ehip_cfg_en_sfc;
	 
assign sip_en = addr_en_tx_xof_en | addr_en_rx_pause_fwd | addr_en_rxsfc_ehip_cfg;

 assign  reconfig_eth_writedata_f      	=   	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? reconfig_eth_writedata 	: reconfig_eth_writedata_f1 ;
 assign  ehip_readdata_mask            	= 	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? ehip_readdata[2:0] 		:ehip_readdata_mask1 ;
 assign  addr_en_tx_xof_en             	= 	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 1'b0 			: addr_en_tx_xof_en1;
 assign  addr_en_rx_pause_fwd          	= 	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 1'b0 			: addr_en_rx_pause_fwd1;
 assign  addr_en_rxsfc_ehip_cfg         = 	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 1'b0 			: addr_en_rxsfc_ehip_cfg1;

always @(  posedge i_reconfig_clk)
 begin
  tx_flow_control 		<= 	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 1'b0 			: tx_flow_control1;
  forward_user_rxpause 		<= 	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 1'b0 			: forward_user_rxpause1;
  en_sfc 			<= 	(eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 1'b0 			: en_sfc1 ;
  rxpause_daddr                 <=       (eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 48'd0 			: {ehip_rx_pause_daddrh,ehip_rx_pause_daddrl} ;
rx_en_pp			<=     single_multi_rate_pp ? ((CLIENT_INT == 1 && (eth_rate == 3'd2 ||eth_rate == 3'd3)) ? 1'b1: (eth_rate_int[2:0] == 3'b110 || dis_pause_control == 1'b1) ? 1'b0  : (ehip_rx_en_pp || mac_rx_en_pp_dr)) : ehip_rx_en_pp ;
end

// This is for unidirectional 10g
logic [15:0] ehip_addr_link_fault_config;
logic link_fault_config_unidir;

assign ehip_addr_link_fault_config =  'h1200;
assign addr_en_link_fault_config = (ehip_addr_link_fault_config == {reconfig_eth_addr[13:0],2'b00})? 1'b1:1'b0;

wire we_link_fault_config = (reconfig_eth_write  & addr_en_link_fault_config) ? byteen[0] : {1'b0};

always @(posedge i_reconfig_clk)
begin
    if (reset | i_cfg_reset_new) begin
	link_fault_config_unidir  <= local_link_fault_config;
    end 
    else if (we_link_fault_config) begin 
        link_fault_config_unidir  <=  reconfig_eth_writedata[1];  //
    end
end

//always @ (*) begin
//   if (sec_enable == 1'b1) begin
//      link_fault_config_unidir_10g = ((sel_25g_10g_reg == 1'b1) && (link_fault_config_unidir == 1'b1)) ? 1'b1 : 1'b0; 
//  end else begin
//      link_fault_config_unidir_10g = ((eth_rate_int[2:0] == 3'b000) && (link_fault_config_unidir == 1'b1)) ? 1'b1 : 1'b0;
//   end
//end
assign link_fault_config_unidir_10g = link_fault_config_unidir;

//------------------------------------

end
  else 
   begin: NO_PAUSE

                assign  reconfig_eth_writedata_f      	=   reconfig_eth_writedata;
		assign  ehip_readdata_mask            	= ehip_readdata[2:0];
		assign  addr_en_tx_xof_en             	= 1'b0;
		assign  addr_en_rx_pause_fwd          	= 1'b0;
		assign  addr_en_rxsfc_ehip_cfg         	=1'b0;
		assign  tx_flow_control 		= 1'b0;
		assign  forward_user_rxpause 		= 1'b0;
		assign  en_sfc 				= 1'b0;
                 assign rxpause_daddr			= 48'd0;
		 assign rx_en_pp 			= 1'b0;
		 assign link_fault_config_unidir	= 1'b0;					 
		 assign link_fault_config_unidir_10g	= 1'b0;					 
    end	

    endgenerate
	
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvdnCqjZQYER+yrSMAR1iSy2SImHZOmkEr+BlgpLFEG8K1WKEiAsNlczzlQ7pnuKV6bLpkbeW0as3D3oRwTcgzalJmT7gQrl+waSb8V0AdSixFE/vYiJANg3Rd5QTEdaA4uCYk3kBlr6+wx3N73+popseczYWbq5t6EgcvsQOqLA/ziBiWnN8RFM51y8/l2qoJ9uW4z3CDsJyAc8WAg58XBX+QOvONxRz6dGV/hq0dj8Xl8rEEhkOQlgq4+WuAYmQG/eyYybIL7jZJGPqzt/x/JGZdgU5Cmh7uhaGPueFScTuAGeT2vpEIAy6gb94ZchneM1NACLu0+kGbxP+ayEOFrgVBPJT29uHoRVQbOky8sSFPUNt4UDUSO3cLqOYPw8xOb8x+MaGxSzRG5D6IilURD+XPxHn1spygO9v/kBqeCdbhUHADL1dn4AGVmujLp7GCZvYaiCjZChNj4cdxulJogaSoyxEoAKCur4lUszpy2jGiJVYMPW3IukVZ2VnfE5US5QkLTMNNWOSTt1JLQBx/rhJFoAXAWMM1qnDEh0TagAqJCyqGZxGUsnYXhTStLgl26CuQjOoriRp5czdl7dFO5hj/aaq7GZ6ax+seBPd0uJPNV0LrYmrGBStMV/Os9hod4cnSst9LKjF69kex/r7AXmB2KxM2Iq09F2jux27B9SJ1Ly4Qo16RwKuiiFrAH8w4EEV9BYXdaL6imCFwxdfQBMqmr4hWQiOzvxqZnxdTcuAUM9M3HWi54E0X6cjMryt3FRLMJ9ChIzJwoX/Rf8v5Ff"
`endif