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


//------------------------------------------------------------------------------
// Ethernet SIP top level
//------------------------------------------------------------------------------
`timescale 1ps/1ps
(* tile_ip_sip *)
  module eth_f_sip_23upnva
  #(
    parameter NUMPORTS                  = 1,   // This is required for multi-rate ETH IPs, each port will have its own kr_stat, kr_ctrl
    parameter KR_STAT_WIDTH             = 8,
    parameter KR_CTRL_WIDTH             = 8,
    parameter AIB_LANES                 = 1, // 25G or 10G = 1, 50G = 2, 100G = 4, 200G = 8, 400G = 16
    parameter DATA_WIDTH                = 1, // Valid values are { 1, 2, 4, 8, 16}
    parameter EMPTY_BITS                = 5, // Changes depending on AVST or MAC segmented interface. Refer FS
    parameter LANE_NUM                  = 1, // Number of transciver lanes. Valid values are { 1, 2, 4, 8, 16}
    parameter EHIP_RATE                 = "10G", // Ethernet rate - "10G" "25G" "40G" 50G" "100G" "200G" "400G"
    parameter PACKING_EN                = "0", // Enabling Packer for Ethernet rate - "40G" 50G" "100G" "200G" "400G"
    parameter PREAMBLE_PASSTHROUGH      = 0, // 
    parameter TX_EHIP_PP_EN             = "DISABLE",
    parameter KEEP_RX_CRC               = 0, // 
    parameter INFRAME                   = 0, // 
    parameter SEG_ERROR                 = 0, // 
    parameter SEG_EOP_EMPTY             = 0, // 
    parameter SEG_STATUS                = 0, // 
    parameter PCS_CONTROL               = 0, // 
    parameter FCS_ERROR                 = 0, // 
    parameter ENABLE_ANLT               = 0,
    parameter XCVR_TYPE_SIP             = 0,
    parameter CLIENT_INT                = 0,
    parameter RSFEC_TYPE                = 0,
    parameter BLOCK_TYPE                = 0,    
    parameter MODULATION                = 0,
    parameter FLOW_CONTROL              = 0,
    parameter ENABLE_ADME               = 0,
    parameter ENABLE_ETK		= 0,
    parameter bb_f_ehip_mac_forward_rx_pause_requests = "DISABLE",
    parameter bb_f_ehip_mac_flow_control_sip   = "NO",
    parameter bb_f_ehip_mac_rx_en_pp   = "DISABLE",
    parameter AVMM2_ADDR_WIDTH		=18,
    parameter CWBIN_TIMEOUT_COUNT       = 1399, //14us timer, 1400 for 100MHZ reconfig clock, 3500 for 250MHz clock
    parameter ENABLE_SOFT_CWBIN         = 0,
    parameter BASE_SEC_ENABLE		= 0,
    parameter bb_f_ehip_mac_link_fault_mode = "MAC_LF_OFF",

    // PTP parameters
    parameter ENABLE_PTP                = 0, //
    parameter PKT_CYL                   = 1, // "1" for 10G to 200G, "2" for 400G
    parameter PTP_FP_WIDTH              = 8,
    parameter ENABLE_PTP_DEBUG          = 0, //
    parameter PTP_ACC_MODE              = 0, //TBD, may be hidden.. "Basic", "Advanced"
    parameter PTP_TX_WIDTH              = 10,
    parameter PTP_RX_WIDTH              = 12,
    
    // Adapter paremeter
    parameter ENABLE_ASYNC_ADAPTERS     = 0,
    parameter READY_LATENCY             = 0 // 0, 1, 2 or 3
    
  )
  (
    // Clocks
    input wire                          i_clk_tx,               // TX Avalon-ST interface clock, connect o_clk_pll to this.
    input wire                          i_clk_rx,               // RX Avalon-ST interface clock, connect o_clk_pll to this.
    output wire                         o_clk_pll,              // this is /64 clock (402.83 MHz) EHIP system clock
    output wire                         o_clk_tx_div,           // this is /66 or /68 clock (390.625 MHz) EHIP system clock times 64/66
    output wire                         o_clk_rec_div64,        // this is /64 clock (402.83 MHz), receovered clock
    output wire                         o_clk_rec_div,          // this is /66 or /68 clock (390.625 MHz), receovered clock
    input wire                          int_clk_tx,             // ENABLE_ASYNC_ADAPTERS==1 ? o_clk_pll : i_clk_tx (selection done in top file)
                                                                // In AvST Sync/MAC Seg case - i_clk_tx is used for all SIP logic;
                                                                // MAIB Phase Comp FIFO's write clock will be i_clk_tx which is same as
                                                                // o_clk_pll but may have different phase
    input wire                          int_clk_rx,             // ENABLE_ASYNC_ADAPTERS==1 ? o_clk_pll : i_clk_rx (selection done in top file)
                                                                // In AvST Sync/MAC Seg case - i_clk_rx is used for all SIP logic;
                                                                // MAIB Phase Comp FIFO's read clock will be i_clk_rx which is same as
    
    //RESET SIGNALS
    input  wire                         i_tx_rst_n, //Resets the digital path (Ethernet MAC and Ethernet PCS).
    input  wire                         i_rx_rst_n, // Resets the RX digital path (Ethernet MAC, PCS).
    input  wire                         i_rst_n, // Resets TX/RX datapaths (MAC, PCS) and TX/RX transceiver & AIB.
    output wire                         o_rst_ack_n, // Acknowledge signal for i_rst_n.
    output wire                         o_tx_rst_ack_n, // Acknowledge signal for i_tx_rst_n.
    output wire                         o_rx_rst_ack_n, // Acknowledge signal for i_rx_rst_n.

    //TX Segmented Interface
    input wire  [64*DATA_WIDTH-1:0]     i_tx_mac_data,
    input wire                          i_tx_mac_valid,
    input wire  [1*INFRAME-1:0]         i_tx_mac_inframe,
    input wire  [SEG_EOP_EMPTY-1:0]     i_tx_mac_eop_empty,
    output wire                         o_tx_mac_ready,
    input wire  [1*SEG_ERROR-1:0]       i_tx_mac_error,
    input wire  [DATA_WIDTH-1:0]         i_tx_mac_skip_crc, // TODO: need to add mac?

    //RX Segmented Interface
    output wire  [64*DATA_WIDTH-1:0]    o_rx_mac_data,
    output wire                         o_rx_mac_valid,
    output wire  [1*INFRAME-1:0]        o_rx_mac_inframe,
    output wire  [SEG_EOP_EMPTY-1:0]    o_rx_mac_eop_empty,
    output wire  [2*SEG_ERROR-1:0]      o_rx_mac_error,
    output wire [1*FCS_ERROR-1:0]       o_rx_mac_fcs_error,
    output wire [SEG_STATUS-1:0]        o_rx_mac_status,
    // TX AVST INTERFACE    
    input wire [64*DATA_WIDTH-1:0]      i_tx_data, //Input data to the MAC. Bits 0 is the LSB.
    input wire                          i_tx_valid, //Indicates data TX data is valid. Must remain high throughout transmission of packet.
    input wire                          i_tx_startofpacket, //Start of packet (SOP). Asserted for one cycle at the beginning of frame.
    input wire                          i_tx_endofpacket, //End of packet (EOP). Asserted for one cycle on the last cycle of the frame.
    output wire                         o_tx_ready, // Indicates that the MAC is ready to accept new data.
    input wire [EMPTY_BITS-1:0]         i_tx_empty, // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
    input wire                          i_tx_error, // A valid high on this signal aligned with an eop will cause the tx frame to be treated as an error.
    input wire                          i_tx_skip_crc, //If skip CRC, MAC will not add CRC i.e. no PAD and no source address insertion else TX MAC will add CRC.
    input wire [64-1:0]                 i_tx_preamble, //To pass in the preamble data to the 50G MAC when its rate is set to 50G.

    // RX AVST INTERFACE
    output wire [64*DATA_WIDTH-1:0]     o_rx_data, // output data from the MAC, Bit 0 is LSB.
    output wire                         o_rx_valid, // Indicates data RX data, EOP, and SOP are valid.
    output wire                         o_rx_startofpacket, // Start of packet (SOP). Asserted for one cycle at the beginning of frame.
    output wire                         o_rx_endofpacket, // End of packet (EOP). Asserted for one cycle on the last cycle of the frame.
    output wire [EMPTY_BITS-1:0]        o_rx_empty, // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
    output wire [6-1:0]                 o_rx_error, // RX error bits asserted on the EOP cycle.[0] : malformed block, [1] : crc error, [2] : reserved, [3] : reserved, [4] : length error, [5] : reserved
    output wire [64-1:0]                o_rx_preamble, //To receive preamble data from MAC when its rate is set to 50G.  
    output wire [40-1:0]                o_rxstatus_data, //RX frame status information. Valid on EOP cycle.[0:31] : reserved, [32] : stacked vlan frame ,[33] : vlan frame ,[34] : control frame, [35] : pause frame, [36:38] : reserved, [39] : pfc frame
    output wire                         o_rxstatus_valid, //asserted to indicate that bits on o_rxstatus_data are valid.

    //TX PCS Interface
    input wire  [AIB_LANES-1:0][63:0]   i_tx_mii_d,
    input wire   [AIB_LANES-1:0][7:0]   i_tx_mii_c,
    input wire                          i_tx_mii_valid,
    output wire                         o_tx_mii_ready,
    input wire                          i_tx_mii_am,
    //RX PCS Interface
    output wire  [AIB_LANES-1:0][63:0]  o_rx_mii_d,
    output wire   [AIB_LANES-1:0][7:0]  o_rx_mii_c,
    output wire                         o_rx_mii_valid,
    output wire                         o_rx_mii_am_valid,

    //TX PCS66 Interface
    input wire [AIB_LANES-1:0][65:0]    i_tx_pcs66_d,
    input wire                          i_tx_pcs66_valid,
    output wire                         o_tx_pcs66_ready,
    input wire                          i_tx_pcs66_am,
    //RX PCS66 Interface
    output wire [AIB_LANES-1:0][65:0]   o_rx_pcs66_d,
    output wire                         o_rx_pcs66_valid,
    output wire                         o_rx_pcs66_am_valid,
  
    // ---------- PTP interface -------------------------
    (* intfc_name="ptp_mux", intfc_type_key="slot", intfc_subtype_key="ptp_mux_link_spoke" *)
    input  wire  [AIB_LANES-1:0]                    ptp_placement_virtual,
    (* intfc_name="ptp_mux", intfc_type_key="slot", intfc_subtype_key="spoke" *)
    output wire  [AIB_LANES-1:0][PTP_TX_WIDTH-1:0]  tx_ptp,
    (* intfc_name="ptp_mux", intfc_type_key="slot", intfc_subtype_key="spoke" *)
    input  wire  [AIB_LANES-1:0][PTP_RX_WIDTH-1:0]  rx_ptp,
    // PTP clocks
    input wire                           i_clk_tx_tod,
    input wire                           i_clk_rx_tod,
    input wire                           i_clk_ptp_sample,
    // PTP TOD
    input wire                           i_ptp_tx_tod_valid,
    input wire [95:0]                    i_ptp_tx_tod,
    input wire                           i_ptp_rx_tod_valid,
    input wire [95:0]                    i_ptp_rx_tod,
    // 1-step Timestamp
    input  wire [PKT_CYL*1 -1:0]         i_ptp_ins_ets,
    input  wire [PKT_CYL*1 -1:0]         i_ptp_ins_cf,
    input  wire [PKT_CYL*1 -1:0]         i_ptp_zero_csum,
    input  wire [PKT_CYL*1 -1:0]         i_ptp_update_eb,
    input  wire [PKT_CYL*1 -1:0]         i_ptp_p2p,
    input  wire [PKT_CYL*1 -1:0]         i_ptp_asym,
    input  wire [PKT_CYL*1 -1:0]         i_ptp_asym_sign,
    input  wire [PKT_CYL*7 -1:0]         i_ptp_asym_p2p_idx,
    input  wire [PKT_CYL*1 -1:0]         i_ptp_ts_format,
    input  wire [PKT_CYL*16-1:0]         i_ptp_ts_offset,
    input  wire [PKT_CYL*16-1:0]         i_ptp_cf_offset,
    input  wire [PKT_CYL*16-1:0]         i_ptp_csum_offset,
    input  wire [PKT_CYL*96-1:0]         i_ptp_tx_its,
    input  wire [PKT_CYL*1-1:0]          i_ptp_ts_req,
    input  wire [PKT_CYL*PTP_FP_WIDTH-1:0]  i_ptp_fp,
    // 2-step Timestamp
    output wire [PKT_CYL*1 -1:0]         o_ptp_ets_valid,
    output wire [PKT_CYL*96-1:0]         o_ptp_ets,
    output wire [PKT_CYL*PTP_FP_WIDTH -1:0] o_ptp_ets_fp,
    output wire [PKT_CYL*5 -1:0]         o_ptp_ets_vl,
    // RX Timestamp
    output wire [PKT_CYL-1:0]            o_ptp_rx_its_valid,
    output wire [PKT_CYL*96-1:0]         o_ptp_rx_its,
    output wire [PKT_CYL*5-1:0]          o_ptp_rx_its_vl,
    // EHIP Interface: Reference Time (i/o_ptp_xcvrif)
    output wire [LANE_NUM-1:0]           o_tx_ptp_async_cal_sel,
    output wire [LANE_NUM-1:0]           o_rx_ptp_async_cal_sel,
    output wire [LANE_NUM-1:0]           o_ptp_async_cal_pulse,
    input wire [LANE_NUM-1:0]            i_tx_ptp_async_pulse,
    input wire [LANE_NUM-1:0]            i_rx_ptp_async_pulse,
    // EHIP Interface: Status signals
    // PTP status
    output wire                          o_tx_ptp_offset_data_valid,
    output wire                          o_rx_ptp_offset_data_valid,
    output wire                          o_tx_ptp_ready,
    output wire                          o_rx_ptp_ready,

    // FLOW CONTROL SIGNALS
    input wire                          i_tx_pause, //Only available if pause flow control is enabled. Asserted to send a pause frame.
    input wire [8-1:0]                  i_tx_pfc, //Only available if priority flow control is enabled. Used to send a pfc frameinput wire.
    output wire                         o_rx_pause, //Indicates that a pause frame was received.
    output wire [8-1:0]                 o_rx_pfc, //Indicates that a pfc frame was received for priority queue n, where n is the bit number that was asserted.

    //KR
    (* intfc_name="anlt", intfc_type_key="slot", intfc_subtype_key="spoke" *)
     output [NUMPORTS-1:0][KR_STAT_WIDTH-1:0]  kr_stat,
    (* intfc_name="anlt", intfc_type_key="slot", intfc_subtype_key="spoke" *)
     input  [NUMPORTS-1:0][KR_CTRL_WIDTH-1:0]  kr_ctrl,

    //TODO: need to group this as o_aib and i_aib
    output reg  [AIB_LANES-1:0][79:0]     tx_parallel_data,
    input  wire [AIB_LANES-1:0][79:0]     rx_parallel_data,
    input  wire [AIB_LANES-1:0][31:0]     hdpldadapt_out_link,
    output reg  [AIB_LANES-1:0][39:0]     hdpldadapt_in_link,

    // STATUS SIGNALS
    output wire                         o_rx_block_lock, //Asserted when 66b block alignment is finished on all PCS lanes.
    output wire                         o_rx_am_lock, // Asserted when RX PCS has found detected alignment markers and deskewed PCS lanes.
    output wire                         o_local_fault_status, //The RX PCS has detected a problem that prevents it from being able to receive data.
    output wire                         o_remote_fault_status, // The remote link partner has sent remote fault ordered sets indicating that it is unable to receive data.
    output wire                         o_rx_hi_ber, //Signal to indicate that the PMA has locked to data.
    input wire                          i_stats_snapshot, // Record snapshot of current state of statistics registers.      
    output reg                         o_rx_pcs_fully_aligned,

    output wire                         o_cdr_lock, //Signal to indicate that the PMA has locked to data. // TODO : 1 bit? source?
    output reg                         o_tx_lanes_stable, //Asserted when TX MAC is ready to send data.
    output reg                         o_rx_pcs_ready, //Asserted when RX PCS is ready to receive data.
    output wire                         o_tx_pll_locked, //Signal to indicate that the TX PLL has locked. // TODO : 1 bit? Source?
    output wire				o_sys_pll_locked, //Do not use o_clk_pll untill this signal is high 
    input wire [15:0]                   i_txaib_transfer_ready,  
    input wire [15:0]                   i_rxaib_transfer_ready, 
    input wire [LANE_NUM-1:0]           xcvr_txpll_locked,
    input wire [LANE_NUM-1:0]           xcvr_rxcdr_locked, 
    // RECONFIG INTERFACE
    input wire                          i_reconfig_clk, 
    input wire                          i_reconfig_reset, // Resets i_reconfig_clk domain including soft CSR 
    input wire [13:0]                   i_reconfig_eth_addr,
    input wire                          i_reconfig_eth_read,
    input wire                          i_reconfig_eth_write,
    input wire [31:0]                   i_reconfig_eth_writedata,
    input wire [3:0]                    i_reconfig_eth_byteenable,
    output wire [31:0]                  o_reconfig_eth_readdata,
    output wire                         o_reconfig_eth_readdata_valid,
    output wire                         o_reconfig_eth_waitrequest,
    
    //XCVR RECONFIG INTERFACE
    input wire [LANE_NUM-1:0]          i_reconfig_xcvr_write,
    input wire [LANE_NUM-1:0]          i_reconfig_xcvr_read,
    input wire [LANE_NUM*18-1:0]       i_reconfig_xcvr_addr,
    input wire [LANE_NUM*32-1:0]       i_reconfig_xcvr_writedata,
    input wire [LANE_NUM*4-1:0]        i_reconfig_xcvr_byteenable,
    output wire [LANE_NUM*32-1:0]      o_reconfig_xcvr_readdata,
    output wire [LANE_NUM-1:0]         o_reconfig_xcvr_readdata_valid,
    output wire [LANE_NUM-1:0]         o_reconfig_xcvr_waitrequest,

    input wire                         i_custom_cadence, // custom dtqa valid cadence port

//  for AVMM1 bb ports
    input   wire                       pld_avmm1_busy,
    output  wire                       pld_avmm1_clk_rowclk,
    input   wire                       pld_avmm1_cmdfifo_wr_full,
    input   wire                       pld_avmm1_cmdfifo_wr_pfull,
    output  wire                       pld_avmm1_read,
    input   wire  [7:0]                pld_avmm1_readdata,
    input   wire                       pld_avmm1_readdatavalid,
    output  wire  [9:0]                pld_avmm1_reg_addr,
    output  wire                       pld_avmm1_request,
    output  wire  [8:0]                pld_avmm1_reserved_in,
    input   wire  [2:0]                pld_avmm1_reserved_out,
    output  wire                       pld_avmm1_write,
    output  wire  [7:0]                pld_avmm1_writedata,
    input   wire                       pld_chnl_cal_done,
    input   wire                       pld_hssi_osc_transfer_en, 

// SRC ports
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [7:0]        tx_clear_alarm, 
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [7:0]        rx_clear_alarm,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    input   wire [LANE_NUM-1:0][2:0]   tx_lane_current_state,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    input   wire [LANE_NUM-1:0][2:0]   rx_lane_current_state,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [LANE_NUM-1:0]        tx_lane_desired_state,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [LANE_NUM-1:0]        rx_lane_desired_state,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    input   wire [LANE_NUM-1:0]        tx_alarm,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    input   wire [LANE_NUM-1:0]        rx_alarm,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [LANE_NUM-1:0]        sip_freeze_tx_src,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [LANE_NUM-1:0]        sip_freeze_rx_src,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    input   wire [LANE_NUM-1:0]        sip_freeze_tx_src_ack,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    input   wire [LANE_NUM-1:0]        sip_freeze_rx_src_ack,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [LANE_NUM-1:0]        sip_ehip_signal_ok,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *)    output  wire [LANE_NUM-1:0]        sip_10g_clause66_en,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="soft_reset_ctlr_link" *)    input   wire [LANE_NUM-1:0] src_placement_virtual,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *) input wire [LANE_NUM-1:0]   sip_lavmm1_block_req,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *) output wire [LANE_NUM-1:0]  sip_lavmm1_block_ack,

(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *) output wire [LANE_NUM-1:0] i_sip_hack_tx_ehiprst_control,
(* intfc_name="soft_reset_ctlr", intfc_type_key="slot", intfc_subtype_key="spoke" *) output wire [LANE_NUM-1:0] i_sip_hack_tx_ehiprst_value, 
//  for AVMM2 bb ports 
    output   wire  [LANE_NUM-1:0]       hip_avmm_read,
    input    wire  [8*LANE_NUM-1:0]     hip_avmm_readdata,
    input    wire  [LANE_NUM-1:0]       hip_avmm_readdatavalid,
    output   wire  [21*LANE_NUM-1:0]    hip_avmm_reg_addr,
    input    wire  [5*LANE_NUM-1:0]     hip_avmm_reserved_out,
    output   wire  [LANE_NUM-1:0]       hip_avmm_write,
    output   wire  [8*LANE_NUM-1:0]     hip_avmm_writedata,
    input    wire  [LANE_NUM-1:0]       hip_avmm_writedone,
    input    wire  [LANE_NUM-1:0]       pld_avmm2_busy,
    output   wire  [LANE_NUM-1:0]       pld_avmm2_clk_rowclk,
    input    wire  [LANE_NUM-1:0]       pld_avmm2_cmdfifo_wr_full,
    input    wire  [LANE_NUM-1:0]       pld_avmm2_cmdfifo_wr_pfull,
    output   wire  [LANE_NUM-1:0]       pld_avmm2_request,
    // input    wire  [LANE_NUM-1:0]       pld_pll_cal_done,
    output   wire  [LANE_NUM-1:0]       pld_avmm2_write,
    output   wire  [LANE_NUM-1:0]       pld_avmm2_read,
    output   wire  [9*LANE_NUM-1:0]     pld_avmm2_reg_addr,
    input    wire  [8*LANE_NUM-1:0]     pld_avmm2_readdata,
    output   wire  [8*LANE_NUM-1:0]     pld_avmm2_writedata,
    input    wire  [LANE_NUM-1:0]       pld_avmm2_readdatavalid,
    output   wire  [6*LANE_NUM-1:0]     pld_avmm2_reserved_in, 
    input    wire  [LANE_NUM-1:0]       pld_avmm2_reserved_out

  );
  
  //Reset signals
  wire tx_dp_rst;
  wire rx_dp_rst;
  wire reconfig_reset_sync;
  //wire tx_dp_rst_sync, rx_dp_rst_sync;
  wire tx_dp_rst_sync;
  reg rx_dp_rst_sync = '0;
  wire rx_dp_rst_sync_1;

  //Soft reset signals
  
  reg soft_tx_rst;
  reg soft_rx_rst;
  reg eio_sys_rst;

logic f_tx_operational_reconfigsync='0, f_rx_operational_reconfigsync='0;
logic src_avmm1_req;
logic src_avmm1_ack;
logic [LANE_NUM-1:0] src_avmm1_req_sync;

 wire custom_cadence;
   



  wire o_pcs_rx_sf;
  wire o_fec_not_align_aib;
  wire [AIB_LANES-1:0] o_fec_not_locked_aib;
  wire o_fec_not_locked;

 wire o_rx_block_lock_aib;
 wire o_rx_am_lock_aib;
 wire o_rx_pcs_fully_aligned_aib;
 
 logic o_stats_snapshot;
 logic o_stats_snapshot_sync;
logic cwbin_rst;
logic [31:0] cwbin0A_out;
logic [31:0] cwbin1A_out;
logic [31:0] cwbin2A_out;
logic [31:0] cwbin3A_out;
logic [31:0] cwbin0B_out;
logic [31:0] cwbin1B_out;
logic [31:0] cwbin2B_out;
logic [31:0] cwbin3B_out;
logic [31:0] cwbin_timer_timeout;

   
logic [7:0][31:0] dl_tx_delay_sclk, dl_rx_delay_sclk;
logic [7:0][31:0] dl_tx_sync_count, dl_tx_async_count,dl_rx_sync_count,dl_rx_async_count; 
logic [7:0]  dl_tx_measure_valid, dl_rx_measure_valid,dl_tx_sync_valid,dl_tx_async_valid,dl_rx_sync_valid,dl_rx_async_valid ;
logic [7:0]  dl_tx_restart, dl_rx_restart ;


 
    // PTP autoconnect
    wire [1:0][51:0]            ptp_rx_aib67_data;
    wire [AIB_LANES*3-1:0]      tx_ptp_ins_type;
    wire [AIB_LANES*5-1:0]      tx_ptp_ts;
    wire [AIB_LANES*1-1:0]      tx_ptp_fp;
    wire                        rx_ptp_vl_snapshot;
    wire                        tx_dsk_pulse;

    wire [AIB_LANES-1:0]        hi_rx_ptp_its;
    wire [PKT_CYL-1:0][3:0]     hi_rx_ptp_its_vl;
    wire [AIB_LANES-1:0]        int_hi_rx_ptp_its;
    wire [PKT_CYL-1:0][3:0]     int_hi_rx_ptp_its_vl;

////////////////////////////////// debug registers ///////////////////////////////////

(* preserve_syn_only *)   logic [63:0] pack_da_mismatch_cnt_in;
(* preserve_syn_only *)   logic [63:0] pack_da_mismatch_cnt_out;
(* preserve_syn_only *)   logic [63:0] pack_da_match_cnt_in;
(* preserve_syn_only *)   logic [63:0] pack_da_match_cnt_out;

(* preserve_syn_only *)   logic [63:0] tx_pause_da_mismatch_cnt_in;
(* preserve_syn_only *)   logic [63:0] tx_pause_da_mismatch_cnt_out;
(* preserve_syn_only *)   logic [63:0] tx_pause_da_match_cnt_in;
(* preserve_syn_only *)   logic [63:0] tx_pause_da_match_cnt_out;

logic        tx_pkt_sts_clr     ;
logic        rx_pkt_sts_clr     ;
logic        rx_lf_rf_pcs_clr   ;
logic [31:0] tx_pkr_sop_cnt_lo;
logic [15:0] tx_pkr_sop_cnt_hi;
logic [31:0] tx_pkr_eop_cnt_lo;
logic [15:0] tx_pkr_eop_cnt_hi;
logic [31:0] tx_pkr_byte_cnt_lo;
logic [31:0] tx_pkr_byte_cnt_hi;
logic [31:0] tx_mac_sop_cnt_lo;
logic [15:0] tx_mac_sop_cnt_hi;
logic [31:0] tx_mac_eop_cnt_lo;
logic [15:0] tx_mac_eop_cnt_hi;
logic [31:0] tx_mac_byte_cnt_lo;
logic [31:0] tx_mac_byte_cnt_hi;
logic [31:0] rx_mac_sop_cnt_lo;
logic [15:0] rx_mac_sop_cnt_hi;
logic [31:0] rx_mac_eop_cnt_lo;
logic [15:0] rx_mac_eop_cnt_hi;
logic [31:0] rx_mac_byte_cnt_lo;
logic [31:0] rx_mac_byte_cnt_hi;
logic [05:0] tx_pkr_max_fifo_level;
logic [05:0] tx_pkr_min_fifo_level;
logic [03:0] tx_pkr_fifo_empty_cnt;
logic [7:0] local_fault_cntr;
logic [7:0] remote_fault_cntr;
logic [7:0] pcs_ready_cntr;

//////////////////////////////////////////////////////////////////////////////////

  //----------------------------------------------------------------------
  //-------------------------CLOCK MONITOR--------------------------------
  //----------------------------------------------------------------------
  
  wire [31:0]  clk_tx_khz;
  wire [31:0]  clk_rx_khz;
  wire [31:0]  clk_pll_khz;
  wire [31:0]  clk_tx_div_khz;
  wire [31:0]  clk_rec_div64_khz;
  wire [31:0]  clk_rec_div_khz;

`ifdef ALTERA_RESERVED_QIS
localparam SIM_EMULATE = 1'b0;
localparam SIM_HURRY = 1'b0;
`else
localparam SIM_EMULATE = 1'b1;
localparam SIM_HURRY = 1'b1;
`endif


  eth_f_clock_mon #(
      .SIM_HURRY         (SIM_HURRY),
      .SIM_EMULATE       (SIM_EMULATE)
  ) clk_mon_inst (
      .csr_clk           (i_reconfig_clk),
      // Inputs
      .clk_tx            (i_clk_tx),
      .clk_rx            (i_clk_rx),
      .clk_pll           (o_clk_pll),
      .clk_tx_div        (o_clk_tx_div),
      .clk_rec_div64     (o_clk_rec_div64),
      .clk_rec_div       (o_clk_rec_div),
      // outputs
      .clk_tx_khz        (clk_tx_khz),
      .clk_rx_khz        (clk_rx_khz),
      .clk_pll_khz       (clk_pll_khz),
      .clk_tx_div_khz    (clk_tx_div_khz),
      .clk_rec_div64_khz (clk_rec_div64_khz),
      .clk_rec_div_khz   (clk_rec_div_khz)
  );
  
  generate if (ENABLE_PTP == 1) begin: PTP_AIB67_GEN
  //----------------------------------------------------------------------
    // PTP autoconnect
  //----------------------------------------------------------------------
    assign tx_dsk_pulse   = rx_ptp[0][11];

    eth_f_ptp_aib67_tx_mapping #(
        .WORDS          (AIB_LANES)
    ) ptp_aib67_tx_mapping_inst (
        .i_snapshot_ptp_vl_data (rx_ptp_vl_snapshot),
        .i_tx_ptp_ts            (tx_ptp_ts),
        .i_tx_ptp_fp            (tx_ptp_fp),
        .i_tx_ptp_ins_type      (tx_ptp_ins_type),
        .o_tx_data              (tx_ptp)
    );
    eth_f_ptp_aib67_rx_mapping #(
        .WORDS          (AIB_LANES),
        .EHIP_RATE      (EHIP_RATE)
    ) ptp_aib67_rx_mapping_inst (
        .i_clk                  (int_clk_rx),
        .i_rx_data              (rx_ptp),
        .o_rx_ptp               (ptp_rx_aib67_data)
    );
    
  end
  else begin: NO_PTP_AIB67_GEN
    assign tx_ptp_ins_type      = {(AIB_LANES*3){1'b0}};
    assign tx_ptp_ts            = {(AIB_LANES*5){1'b0}};
    assign tx_ptp_fp            = {(AIB_LANES*1){1'b0}};
    assign tx_ptp               = {(AIB_LANES*PTP_TX_WIDTH){1'b0}};
    assign ptp_rx_aib67_data    = {(2*51){1'b0}};
    assign rx_ptp_vl_snapshot   = 1'b0;
    assign tx_dsk_pulse         = 1'b0;
  end
  endgenerate
    
  //----------------------------------------------------------------------
  //-------------------------CLOCK MONITOR--------------------------------
  //----------------------------------------------------------------------  
  
  //----------------------------------------------------------------------
  //--------------------------CLOCK & RST---------------------------------
  //----------------------------------------------------------------------
  // reset synchronizer
  logic tx_lanes_stable_sync_clk_tx;
  logic rx_pcs_ready_sync_clk_rx;
  
  // Synchronize tx_lanes_stable/rx_pcs_ready to user clk
    eth_f_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_lanes_stable_sync1 (
        .clk                (i_clk_tx),
        .reset              (1'b0),
        .d                  (o_tx_lanes_stable),
        .q                  (tx_lanes_stable_sync_clk_tx)
    ); 
    eth_f_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_pcs_ready_sync1 (
        .clk                (i_clk_rx),
        .reset              (1'b0),
        .d                  (o_rx_pcs_ready),
        .q                  (rx_pcs_ready_sync_clk_rx)
    );
    
  logic ptp_clk;
  logic tx_tod_clk;
  logic rx_tod_clk;
  logic tx_ptp_rst_n;
  logic rx_ptp_rst_n;
  logic tx_tod_rst_n;
  logic rx_tod_rst_n;
  logic tx_samp_rst_n;
  logic rx_samp_rst_n;
  
  generate if (ENABLE_PTP == 1) begin: PTP_CLK_GEN
    assign ptp_clk = int_clk_tx; // int_clk_rx always = int_clk_tx
    assign tx_tod_clk = i_clk_tx_tod;
    assign rx_tod_clk = i_clk_rx_tod; 
    
    // relax reset timing. ptp_rst fanout to csr, adapter, soft_ptp. soft_ptp internally duplicate fanout to all lanes.
    logic tx_lanes_stable_r0, tx_lanes_stable_r1;
    logic rx_pcs_ready_r0, rx_pcs_ready_r1;
    always @ (posedge ptp_clk) begin 
        {tx_ptp_rst_n, tx_lanes_stable_r1, tx_lanes_stable_r0} <= {tx_lanes_stable_r1, tx_lanes_stable_r0, o_tx_lanes_stable}    ;
        {rx_ptp_rst_n, rx_pcs_ready_r1,    rx_pcs_ready_r0   } <= {rx_pcs_ready_r1,    rx_pcs_ready_r0,    o_rx_pcs_ready   }    ;
    end
    
    // reset synchronizer
    eth_f_ptp_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_tod_rst_sync (
        .clk                (tx_tod_clk),
        .reset              (1'b0),
        .d                  (o_tx_lanes_stable),
        .q                  (tx_tod_rst_n)
    ); 
    eth_f_ptp_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_tod_rst_sync (
        .clk                (rx_tod_clk),
        .reset              (1'b0),
        .d                  (o_rx_pcs_ready),
        .q                  (rx_tod_rst_n)
    ); 
    eth_f_ptp_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_samp_rst_sync (
        .clk                (i_clk_ptp_sample),
        .reset              (1'b0),
        .d                  (o_tx_lanes_stable),
        .q                  (tx_samp_rst_n)
    ); 
    eth_f_ptp_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_samp_rst_sync (
        .clk                (i_clk_ptp_sample),
        .reset              (1'b0),
        .d                  (o_rx_pcs_ready),
        .q                  (rx_samp_rst_n)
    );
  end
  else begin: NO_PTP_CLK_GEN
    assign ptp_clk = 0;
    assign tx_tod_clk = 0;
    assign rx_tod_clk = 0;
    assign tx_ptp_rst_n = 0;
    assign rx_ptp_rst_n = 0;
    assign tx_tod_rst_n = 0;
    assign rx_tod_rst_n = 0;
    assign tx_samp_rst_n = 0;
    assign rx_samp_rst_n = 0;
    
  end
  endgenerate
    
  //----------------------------------------------------------------------
  //--------------------------CLOCK & RST---------------------------------
  //----------------------------------------------------------------------
   
  //----------------------------------------------------------------------
  //----------------------- JTAG AVMM BRIDGE -----------------------------
  //----------------------------------------------------------------------
  
  //JTAG AVMM ETH RECONFIG COMBINED
    wire [13:0]                             reconfig_eth_addr_cw;
    wire [3:0]                              reconfig_eth_byteenable_cw;
    wire                                    reconfig_eth_read_cw;
    wire                                    reconfig_eth_write_cw;
    wire [31:0]                             reconfig_eth_writedata_cw;
    wire [31:0]                             reconfig_eth_readdata_cw;//reg
    wire                                    reconfig_eth_readdata_valid_cw;//wire
    wire                                    reconfig_eth_waitrequest_cw;//reg

 /////TTK CONNECTIONS
 //JTAG AVMM ETH RECONFIG COMBINED
    wire [13:0]                             reconfig_eth_addr_ttk;
    wire [3:0]                              reconfig_eth_byteenable_ttk;
    wire                                    reconfig_eth_read_ttk;
    wire                                    reconfig_eth_write_ttk;
    wire [31:0]                             reconfig_eth_writedata_ttk;
    wire [31:0]                             reconfig_eth_readdata_ttk;//reg
    wire                                    reconfig_eth_readdata_valid_ttk;//wire
    wire                                    reconfig_eth_waitrequest_ttk;//reg
	
	
	//JTAG AVMM XCVR NTIVE PHY DEBUG MODULE
    wire [AVMM2_ADDR_WIDTH-1:0]             reconfig_xcvr_addr;
    wire [3:0]                   			reconfig_xcvr_byteenable;
    wire                     				reconfig_xcvr_read;
    wire                      				reconfig_xcvr_write;
    wire [31:0]                  			reconfig_xcvr_writedata;
    wire [31:0]                  			reconfig_xcvr_readdata;//reg
    wire                      				reconfig_xcvr_readdata_valid;//reg
    wire                      				reconfig_xcvr_waitrequest;//reg
    
    //JTAG AVMM XCVR RECONFIG COMBINED
    wire [LANE_NUM*18-1:0]                  reconfig_xcvr_addr_ttk;
    wire [LANE_NUM*4-1:0]                   reconfig_xcvr_byteenable_ttk;
    wire [LANE_NUM-1:0]                     reconfig_xcvr_read_ttk;
    wire [LANE_NUM-1:0]                     reconfig_xcvr_write_ttk;
    wire [LANE_NUM*32-1:0]                  reconfig_xcvr_writedata_ttk;
    wire [LANE_NUM*32-1:0]                  reconfig_xcvr_readdata_ttk;//reg
    wire [LANE_NUM-1:0]                     reconfig_xcvr_readdata_valid_ttk;//reg
    wire [LANE_NUM-1:0]                     reconfig_xcvr_waitrequest_ttk;//reg
	
 //  JTAG_AVMM wire connections	
    //JTAG AVMM ETH RECONFIG COMBINED
    wire [13:0]                             i_reconfig_eth_addr_jtag_arb;
    wire [3:0]                              i_reconfig_eth_byteenable_jtag_arb;
    wire                                    i_reconfig_eth_read_jtag_arb;
    wire                                    i_reconfig_eth_write_jtag_arb;
    wire [31:0]                             i_reconfig_eth_writedata_jtag_arb;
    wire [31:0]                             o_reconfig_eth_readdata_jtag_arb;//reg
    wire                                    o_reconfig_eth_readdata_valid_jtag_arb;//wire
    wire                                    o_reconfig_eth_waitrequest_jtag_arb;//reg
    
    //JTAG AVMM XCVR RECONFIG COMBINED
    wire [LANE_NUM*18-1:0]                  i_reconfig_xcvr_addr_jtag_arb;
    wire [LANE_NUM*4-1:0]                   i_reconfig_xcvr_byteenable_jtag_arb;
    wire [LANE_NUM-1:0]                     i_reconfig_xcvr_read_jtag_arb;
    wire [LANE_NUM-1:0]                     i_reconfig_xcvr_write_jtag_arb;
    wire [LANE_NUM*32-1:0]                  i_reconfig_xcvr_writedata_jtag_arb;
    wire [LANE_NUM*32-1:0]                  o_reconfig_xcvr_readdata_jtag_arb;//reg
    wire [LANE_NUM-1:0]                     o_reconfig_xcvr_readdata_valid_jtag_arb;//reg
    wire [LANE_NUM-1:0]                     o_reconfig_xcvr_waitrequest_jtag_arb;//reg

    generate
`ifdef ALTERA_RESERVED_QIS
    if (ENABLE_ETK) begin: GEN_JTAG_AVMM
            eth_f_jtag_avmm_23upnva #(
                .LANE_NUM (LANE_NUM)
            ) eth_f_jtag_inst (

                // Clock and Reset
                .i_reconfig_clk                         (i_reconfig_clk),
                .i_reconfig_reset                       (i_reconfig_reset),

                // EHIP Reconfig Interface
                .i_reconfig_eth_addr                    (reconfig_eth_addr_ttk),
                .i_reconfig_eth_byteenable              (reconfig_eth_byteenable_ttk),
                .i_reconfig_eth_read                    (reconfig_eth_read_ttk),
                .i_reconfig_eth_write                   (reconfig_eth_write_ttk),
                .i_reconfig_eth_writedata               (reconfig_eth_writedata_ttk),
                .o_reconfig_eth_readdata                (reconfig_eth_readdata_ttk),
                .o_reconfig_eth_readdata_valid          (reconfig_eth_readdata_valid_ttk),
                .o_reconfig_eth_waitrequest             (reconfig_eth_waitrequest_ttk),
 
                // EHIP Combined Reconfig Interface
                .i_reconfig_eth_addr_jtag_arb           (i_reconfig_eth_addr_jtag_arb),
                .i_reconfig_eth_byteenable_jtag_arb     (i_reconfig_eth_byteenable_jtag_arb),
                .i_reconfig_eth_read_jtag_arb           (i_reconfig_eth_read_jtag_arb),
                .i_reconfig_eth_write_jtag_arb          (i_reconfig_eth_write_jtag_arb),
                .i_reconfig_eth_writedata_jtag_arb      (i_reconfig_eth_writedata_jtag_arb),
                .o_reconfig_eth_readdata_jtag_arb       (o_reconfig_eth_readdata_jtag_arb),
                .o_reconfig_eth_readdata_valid_jtag_arb (o_reconfig_eth_readdata_valid_jtag_arb),
                .o_reconfig_eth_waitrequest_jtag_arb    (o_reconfig_eth_waitrequest_jtag_arb),


                // XCVR Reconfig Interface
                .i_reconfig_xcvr_addr                   (reconfig_xcvr_addr_ttk),
                .i_reconfig_xcvr_byteenable             (reconfig_xcvr_byteenable_ttk),
                .i_reconfig_xcvr_read                   (reconfig_xcvr_read_ttk),
                .i_reconfig_xcvr_write                  (reconfig_xcvr_write_ttk),
                .i_reconfig_xcvr_writedata              (reconfig_xcvr_writedata_ttk),
                .o_reconfig_xcvr_readdata               (reconfig_xcvr_readdata_ttk),
                .o_reconfig_xcvr_readdata_valid         (reconfig_xcvr_readdata_valid_ttk),
                .o_reconfig_xcvr_waitrequest            (reconfig_xcvr_waitrequest_ttk),
 
                // XCVR Combined Reconfig Interface
                .i_reconfig_xcvr_addr_jtag_arb          (i_reconfig_xcvr_addr_jtag_arb),
                .i_reconfig_xcvr_byteenable_jtag_arb    (i_reconfig_xcvr_byteenable_jtag_arb),
                .i_reconfig_xcvr_read_jtag_arb          (i_reconfig_xcvr_read_jtag_arb),
                .i_reconfig_xcvr_write_jtag_arb         (i_reconfig_xcvr_write_jtag_arb),
                .i_reconfig_xcvr_writedata_jtag_arb     (i_reconfig_xcvr_writedata_jtag_arb),
                .o_reconfig_xcvr_readdata_jtag_arb      (o_reconfig_xcvr_readdata_jtag_arb),
                .o_reconfig_xcvr_readdata_valid_jtag_arb(o_reconfig_xcvr_readdata_valid_jtag_arb),
                .o_reconfig_xcvr_waitrequest_jtag_arb   (o_reconfig_xcvr_waitrequest_jtag_arb)
            );
    end

    else 
`endif
    begin: NO_JTAG_AVMM
                assign  i_reconfig_eth_addr_jtag_arb            =   reconfig_eth_addr_ttk;
                assign  i_reconfig_eth_byteenable_jtag_arb      =   reconfig_eth_byteenable_ttk;
                assign  i_reconfig_eth_read_jtag_arb            =   reconfig_eth_read_ttk;
                assign  i_reconfig_eth_write_jtag_arb           =   reconfig_eth_write_ttk;
                assign  i_reconfig_eth_writedata_jtag_arb       =   reconfig_eth_writedata_ttk;
                assign  reconfig_eth_readdata_valid_ttk         =   o_reconfig_eth_readdata_valid_jtag_arb;
                assign  reconfig_eth_readdata_ttk               =   o_reconfig_eth_readdata_jtag_arb;
                assign  reconfig_eth_waitrequest_ttk            =   o_reconfig_eth_waitrequest_jtag_arb;

					 
                assign  i_reconfig_xcvr_addr_jtag_arb           =   reconfig_xcvr_addr_ttk;
                assign  i_reconfig_xcvr_byteenable_jtag_arb     =   reconfig_xcvr_byteenable_ttk;
                assign  i_reconfig_xcvr_read_jtag_arb           =   reconfig_xcvr_read_ttk;
                assign  i_reconfig_xcvr_write_jtag_arb          =   reconfig_xcvr_write_ttk;
                assign  i_reconfig_xcvr_writedata_jtag_arb      =   reconfig_xcvr_writedata_ttk;
                assign  reconfig_xcvr_readdata_ttk                =   o_reconfig_xcvr_readdata_jtag_arb;
                assign  reconfig_xcvr_readdata_valid_ttk          =   o_reconfig_xcvr_readdata_valid_jtag_arb;
                assign  reconfig_xcvr_waitrequest_ttk             =   o_reconfig_xcvr_waitrequest_jtag_arb;
    end

genvar ch; 
`ifdef ALTERA_RESERVED_QIS
if (ENABLE_ADME) begin: GEN_FTILE_ADME_AVMM
ftile_400g_eth_eth_f_ftile_adme_1800_35erdpq eth_f_adme_inst (
           .avmm1_clk_user                ( i_reconfig_clk ),
           .avmm1_reset_user              ( i_reconfig_reset ),
           .avmm1_address_user            ( reconfig_eth_addr_cw ),
           .avmm1_byte_enable_user        ( reconfig_eth_byteenable_cw ),     
           .avmm1_write_user              ( reconfig_eth_write_cw ),           
           .avmm1_read_user               ( reconfig_eth_read_cw ),            
           .avmm1_write_data_user         ( reconfig_eth_writedata_cw ),      
           .avmm1_read_data_user          ( reconfig_eth_readdata_cw ),       
           .avmm1_waitrequest_user        ( reconfig_eth_waitrequest_cw ),     
           .avmm1_read_data_valid_user    ( reconfig_eth_readdata_valid_cw), 

           .avmm1_clk_tile                (  ),
           .avmm1_reset_tile              (  ),
           .avmm1_address_tile            ( reconfig_eth_addr_ttk ),
           .avmm1_byte_enable_tile        ( reconfig_eth_byteenable_ttk  ),    
           .avmm1_write_tile              ( reconfig_eth_write_ttk  ),         
           .avmm1_read_tile               ( reconfig_eth_read_ttk  ),          
           .avmm1_write_data_tile         ( reconfig_eth_writedata_ttk  ),     
           .avmm1_read_data_tile          ( reconfig_eth_readdata_ttk  ),      
           .avmm1_waitrequest_tile        ( reconfig_eth_waitrequest_ttk  ),   
           .avmm1_read_data_valid_tile    ( reconfig_eth_readdata_valid_ttk ), 

           .avmm2_clk_user                ( i_reconfig_clk ),
           .avmm2_reset_user              ( i_reconfig_reset ),
           .avmm2_address_user            (  ),
           .avmm2_byte_enable_user        (  ),     
           .avmm2_write_user              (  ),           
           .avmm2_read_user               (  ),            
           .avmm2_write_data_user         (  ),      
           .avmm2_read_data_user          (  ),       
           .avmm2_waitrequest_user        (  ),     
           .avmm2_read_data_valid_user    (  ), 

           .avmm2_clk_tile                (  ),
           .avmm2_reset_tile              (  ),
           .avmm2_address_tile            ( reconfig_xcvr_addr ),
           .avmm2_byte_enable_tile        ( reconfig_xcvr_byteenable ),     
           .avmm2_write_tile              ( reconfig_xcvr_write),           
           .avmm2_read_tile               ( reconfig_xcvr_read ),            
           .avmm2_write_data_tile         ( reconfig_xcvr_writedata),      
           .avmm2_read_data_tile          ( reconfig_xcvr_readdata ),       
           .avmm2_waitrequest_tile        ( reconfig_xcvr_waitrequest ),     
           .avmm2_read_data_valid_tile    ( reconfig_xcvr_readdata_valid )
	);

            eth_f_xcvr_debug #(
                .LANE_NUM (LANE_NUM),
				.ADDR_WIDTH(AVMM2_ADDR_WIDTH)
            ) eth_f_adme_arb_inst (
 
                // Clock and Reset
                .i_reconfig_clk                         (i_reconfig_clk),
                .i_reconfig_reset                       (i_reconfig_reset),
				
	// XCVR Reconfig Interface - from FTILE ADME MODULE
				.i_reconfig_ttk_addr                   (reconfig_xcvr_addr),
                .i_reconfig_ttk_byteenable             (reconfig_xcvr_byteenable),
                .i_reconfig_ttk_read                   (reconfig_xcvr_read),
                .i_reconfig_ttk_write                  (reconfig_xcvr_write),
                .i_reconfig_ttk_writedata              (reconfig_xcvr_writedata),
                .o_reconfig_ttk_readdata               (reconfig_xcvr_readdata),
                .o_reconfig_ttk_readdata_valid         (reconfig_xcvr_readdata_valid),
                .o_reconfig_ttk_waitrequest            (reconfig_xcvr_waitrequest),
 
    // XCVR Reconfig Interface - USER AVMM MASTER can be Example Design JTAG Master
				.i_reconfig_xcvr_write 					( i_reconfig_xcvr_write ), 
				.i_reconfig_xcvr_byteenable				( i_reconfig_xcvr_byteenable ),     
				.i_reconfig_xcvr_read					( i_reconfig_xcvr_read ),
				.i_reconfig_xcvr_addr					( i_reconfig_xcvr_addr ),
				.i_reconfig_xcvr_writedata				( i_reconfig_xcvr_writedata ), 
				.o_reconfig_xcvr_readdata				( o_reconfig_xcvr_readdata ),
				.o_reconfig_xcvr_readdata_valid			( o_reconfig_xcvr_readdata_valid ), 
				.o_reconfig_xcvr_waitrequest			( o_reconfig_xcvr_waitrequest ), 
 
    // XCVR Combined Reconfig Interface AVMM SLAVE from Transceiver 0 trhough 7
			 .i_reconfig_xcvr_write_jtag_arb			( reconfig_xcvr_write_ttk),
			 .i_reconfig_xcvr_byteenable_jtag_arb		( reconfig_xcvr_byteenable_ttk),
			 .i_reconfig_xcvr_read_jtag_arb				( reconfig_xcvr_read_ttk),
			 .i_reconfig_xcvr_addr_jtag_arb				( reconfig_xcvr_addr_ttk),
			 .i_reconfig_xcvr_writedata_jtag_arb		( reconfig_xcvr_writedata_ttk),
			 .o_reconfig_xcvr_readdata_jtag_arb			( reconfig_xcvr_readdata_ttk),
			 .o_reconfig_xcvr_readdata_valid_jtag_arb	( reconfig_xcvr_readdata_valid_ttk),
			 .o_reconfig_xcvr_waitrequest_jtag_arb 		( reconfig_xcvr_waitrequest_ttk) 

            );		
	end
    else 
`endif    
    begin: NO_FILE_ADME_AVMM
                assign  reconfig_eth_addr_ttk             =   reconfig_eth_addr_cw;
                assign  reconfig_eth_byteenable_ttk       =   reconfig_eth_byteenable_cw;
                assign  reconfig_eth_read_ttk             =   reconfig_eth_read_cw;
                assign  reconfig_eth_write_ttk            =   reconfig_eth_write_cw;
                assign  reconfig_eth_writedata_ttk        =   reconfig_eth_writedata_cw;
                assign  reconfig_eth_readdata_valid_cw     =    reconfig_eth_readdata_valid_ttk ;
                assign  reconfig_eth_readdata_cw           =   reconfig_eth_readdata_ttk ;
                assign  reconfig_eth_waitrequest_cw        =   reconfig_eth_waitrequest_ttk ;
					 
				assign  reconfig_xcvr_addr_ttk       =   i_reconfig_xcvr_addr;
                assign  reconfig_xcvr_byteenable_ttk    =   i_reconfig_xcvr_byteenable;
                assign  reconfig_xcvr_read_ttk          =   i_reconfig_xcvr_read;
                assign  reconfig_xcvr_write_ttk         =   i_reconfig_xcvr_write;
                assign  reconfig_xcvr_writedata_ttk     =   i_reconfig_xcvr_writedata;
                assign  o_reconfig_xcvr_readdata               =   reconfig_xcvr_readdata_ttk;
                assign  o_reconfig_xcvr_readdata_valid          =   reconfig_xcvr_readdata_valid_ttk;
                assign  o_reconfig_xcvr_waitrequest             =   reconfig_xcvr_waitrequest_ttk;

    end	
	
    endgenerate
  wire [LANE_NUM*20-1:0]       i_reconfig_xcvr_byte_addr_jtag_arb;

    assign i_reconfig_xcvr_byte_addr_jtag_arb[0*20 +: 20] = { i_reconfig_xcvr_addr_jtag_arb[0*18 +: 18], 2'b0 }; // padding 2'b0 for every 18 bits addr
    assign i_reconfig_xcvr_byte_addr_jtag_arb[1*20 +: 20] = { i_reconfig_xcvr_addr_jtag_arb[1*18 +: 18], 2'b0 }; // padding 2'b0 for every 18 bits addr
    assign i_reconfig_xcvr_byte_addr_jtag_arb[2*20 +: 20] = { i_reconfig_xcvr_addr_jtag_arb[2*18 +: 18], 2'b0 }; // padding 2'b0 for every 18 bits addr
    assign i_reconfig_xcvr_byte_addr_jtag_arb[3*20 +: 20] = { i_reconfig_xcvr_addr_jtag_arb[3*18 +: 18], 2'b0 }; // padding 2'b0 for every 18 bits addr
  //----------------------------------------------------------------------
  //----------------------- JTAG AVMM BRIDGE -----------------------------
  //----------------------------------------------------------------------
  
  //----------------------------------------------------------------------
  //--------------------------- SOFT CSR ---------------------------------
  //----------------------------------------------------------------------
  // TODO: need to add generated CSR module
  
  wire         device_name = 1'b1;
  wire  [2:0]  tile_name   = 3'd3;
  wire  [2:0]  eth_rate;
  wire         modulation_type;
  wire  [2:0]  flow_control_mode;
  wire         eth_block;
  // PTP CSR
  wire               [31:0]   wi_tx_calc_adjust        ;
  wire               [31:0]   wi_rx_calc_adjust        ;
  wire                        wi_tx_ptp_user_cfg_done  ;
  wire                        wi_rx_ptp_user_cfg_done  ;
  wire                        wo_tx_ptp_user_cfg_done_clrn  ;
  wire                        wo_rx_ptp_user_cfg_done_clrn  ;
  wire               [2:0]    wi_tx_ref_lane           ;
  wire               [2:0]    wi_rx_lal                ;
  wire                        wi_rx_fec_cw_pos_user_cfg_done ;
  wire                        wo_tx_apulse_wdly_valid  ;
  wire                        wo_tx_apulse_offset_valid;
  wire                        wo_tx_apulse_time_valid  ;
  wire                        wo_rx_apulse_wdly_valid  ;
  wire                        wo_rx_apulse_offset_valid;
  wire                        wo_rx_apulse_time_valid  ;
  wire [LANE_NUM-1:0][19:0]   wo_tx_apulse_wdly        ;
  wire [LANE_NUM-1:0][31:0]   wo_tx_apulse_offset      ;
  wire [LANE_NUM-1:0][27:0]   wo_tx_apulse_time        ;
  wire [LANE_NUM-1:0][19:0]   wo_rx_apulse_wdly        ;
  wire [LANE_NUM-1:0][31:0]   wo_rx_apulse_offset      ;
  wire [LANE_NUM-1:0][27:0]   wo_rx_apulse_time        ;
  wire               [31:0]   wo_tx_const_adjust       ;
  wire               [31:0]   wo_rx_const_adjust       ;
  wire                        wo_tx_tam_valid;
  wire [47:0]                 wo_tx_tam_ui ;
  wire [15:0]                 wo_tx_tam_cnt;
  wire                        wo_rx_tam_valid;
  wire [47:0]                 wo_rx_tam_ui ;
  wire [15:0]                 wo_rx_tam_cnt;
  wire tx_ehip_preamble_passthru_gui = (TX_EHIP_PP_EN == "ENABLE") ? 1'b1 : 1'b0;
  wire tx_ehip_preamble_passthru_dr;
  logic link_fault_config_unidir_10g;
  logic rf_in_progress;
  
  localparam EHIP_RATE_CSR = (EHIP_RATE == "10G")  ? 3'd0 : (EHIP_RATE == "25G")  ? 3'd1 : (EHIP_RATE == "40G")  ? 3'd2 : (EHIP_RATE == "50G")  ? 3'd3 : (EHIP_RATE == "100G") ? 3'd4 : (EHIP_RATE == "200G") ? 3'd5 : 3'd6;

localparam DIS_PAUSE = 1'b0;
localparam param_rx_pause_requests = (bb_f_ehip_mac_forward_rx_pause_requests=="ENABLE")? 1'b1 : 1'b0;
localparam param_rx_en_pp = (bb_f_ehip_mac_rx_en_pp == "ENABLE")? 1'b1 : 1'b0;
localparam param_flow_control  = (bb_f_ehip_mac_flow_control_sip=="YES" || bb_f_ehip_mac_flow_control_sip=="NO" )? 1'b1 : 1'b0;
localparam param_mac_tx_xof  = (bb_f_ehip_mac_flow_control_sip=="YES" )? 1'b1 : 1'b0;

  localparam SEC_ENABLE = (BASE_SEC_ENABLE == 1) ? 1'b1 : 1'b0;
  localparam SEL_25G_10G_REG = 1'b0;
  
  // 0-"MAC_LF_OFF", 1-"MAC_LF_UNIDIR", 2-"MAC_LF_BIDIR" 
  localparam eth_link_fault = (bb_f_ehip_mac_link_fault_mode == "MAC_LF_OFF") ? 2'd0 : (bb_f_ehip_mac_link_fault_mode == "MAC_LF_UNIDIR") ? 2'd1 : 2'd2;
  
  assign sip_10g_clause66_en = (link_fault_config_unidir_10g==1'b1)  ? '1 : '0;

   // sync reconfig_reset as in module eth_f_csr.sv, it is used as a synchronous reset 
       eth_f_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(1) 
       ) sync_reconfig_reset (
           .clk    (i_reconfig_clk),
           .reset  (1'b0),
           .d  (i_reconfig_reset),
           .q  (reconfig_reset_sync)
       );

  wire kr_mode = ENABLE_ANLT ? kr_ctrl[0][1] : 1'b0; 
  wire kr_fec_mode = ENABLE_ANLT ? kr_ctrl[0][2] : 1'b0; // TODO : for future to support dynamic FEC from AN result

logic o_rx_pcs_fully_aligned_sync;
logic kr_mode_sync;
logic kr_fec_mode_sync;
logic rx_pcs_ready_sync;
logic local_fault_status_sync;
logic local_fault_status_sip;
logic local_fault_status_hip;
logic remote_fault_status_sync;
logic tx_lanes_stable_sync;
logic dropped_clear_sync;

	 //RX PAUSE signals
	 logic 				tx_flow_control;
	 logic				forward_user_rxpause;
	 logic            en_sfc;
          logic    [47:0]   mac_rxpause_daddr;
         logic rx_en_pp;

  eth_f_multibit_sync #(
      .WIDTH (6)
  ) msync (
      .clk     (i_reconfig_clk),
      .reset_n (1'b1),
      .din     ({kr_mode,                   kr_fec_mode,              	  o_rx_pcs_ready,     o_rx_pcs_fully_aligned,                   
                 o_local_fault_status,      o_remote_fault_status}),
      .dout    ({kr_mode_sync,              kr_fec_mode_sync,             rx_pcs_ready_sync,  o_rx_pcs_fully_aligned_sync,             
                 local_fault_status_sync,   remote_fault_status_sync})
  );
    
  eth_f_altera_std_synchronizer_nocut lanes_stable_sync_inst (
    .clk        (i_reconfig_clk),
    .reset_n    (1'b1),
    .din        (o_tx_lanes_stable), // TODO : o_tx_lanes_stable form Reset controller?
    .dout       (tx_lanes_stable_sync)
  );

  eth_f_altera_std_synchronizer_nocut dropped_clear_sync_inst (
    .clk        (int_clk_rx),
    .reset_n    (1'b1),
    .din        (dropped_clear),
    .dout       (dropped_clear_sync)
  );

  wire [63:0] rx_adapt_dropped_frames_sync;
  wire [63:0] rx_adapt_dropped_frames;
  wire        dropped_frame_snapshot;
  logic [63:0] rx_adapt_dropped_frames_shadow;
  logic cdr_lock_sync;
  logic cdr_lock_reg = '0;

always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
  cdr_lock_reg <= o_cdr_lock;
    end

eth_f_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0) 
       ) sync_cdr_lock_reset (
           .clk    (int_clk_rx),
           .reset  (1'b0),
           .d  (cdr_lock_reg),
           .q  (cdr_lock_sync)
       );

	assign rx_adapt_dropped_frames_sync = 0;
	assign rx_adapt_dropped_frames_shadow = 0;

  wire  [LANE_NUM-1:0][2:0] tx_lane_current_state_sync;
  wire  [LANE_NUM-1:0][2:0] rx_lane_current_state_sync;
  wire  [2:0] tx_lane_current_state_sync_autosrc;
  wire  [2:0] rx_lane_current_state_sync_autosrc;
  wire  [LANE_NUM-1:0] tx_alarm_sync;
  wire  [LANE_NUM-1:0] rx_alarm_sync;
  wire  [7:0] tx_alarm_csr;
  wire  [7:0] rx_alarm_csr;
  logic r_rx_rst_ack_n = '0;
    
genvar st;
generate
for (st=0; st<LANE_NUM; st=st+1) begin: CURRENT_STATE

  eth_f_multibit_sync #(
      .WIDTH (3)
  ) tx_lane_current_sync (
      .clk     (i_reconfig_clk),
      .reset_n (1'b1),
      .din     (tx_lane_current_state[st][2:0]),
      .dout    (tx_lane_current_state_sync[st][2:0])
  ); 

  eth_f_multibit_sync #(
      .WIDTH (3)
  ) rx_lane_current_sync (
      .clk     (i_reconfig_clk),
      .reset_n (1'b1),
      .din     (rx_lane_current_state[st][2:0]),
      .dout    (rx_lane_current_state_sync[st][2:0])
  );
end

assign tx_lane_current_state_sync_autosrc[2:0] = tx_lane_current_state_sync[0][2:0];
assign rx_lane_current_state_sync_autosrc[2:0] = rx_lane_current_state_sync[0][2:0];
endgenerate

  eth_f_multibit_sync #(
      .WIDTH (LANE_NUM)
  ) tx_alarm_s (
      .clk     (i_reconfig_clk),
      .reset_n (1'b1),
      .din     (tx_alarm),
      .dout    (tx_alarm_sync)
  );
  
  assign tx_alarm_csr = {{(8-LANE_NUM){1'b0}}, tx_alarm_sync};

  eth_f_multibit_sync #(
      .WIDTH (LANE_NUM)
  ) rx_alarm_s (
      .clk     (i_reconfig_clk),
      .reset_n (1'b1),
      .din     (rx_alarm),
      .dout    (rx_alarm_sync)
  );
  
  assign rx_alarm_csr = {{(8-LANE_NUM){1'b0}}, rx_alarm_sync};

  wire  [LANE_NUM-1:0] tx_pll_locked_sync;
  wire  [7:0] tx_pll_locked_csr;

  eth_f_multibit_sync #(
      .WIDTH (LANE_NUM)
  ) tx_pll_locked_s (
      .clk     (i_reconfig_clk),
      .reset_n (1'b1),
      .din     (xcvr_txpll_locked),
      .dout    (tx_pll_locked_sync)
  );
  
  assign tx_pll_locked_csr = {{(8-LANE_NUM){1'b0}}, tx_pll_locked_sync};
  assign o_tx_pll_locked = (LANE_NUM == 1)? xcvr_txpll_locked : &xcvr_txpll_locked; 

  wire  [LANE_NUM-1:0] eiofreq_lock_sync;
  wire  [7:0] eiofreq_lock_csr;

  eth_f_multibit_sync #(
      .WIDTH (LANE_NUM)
  ) eiofreq_locked_s (
      .clk     (i_reconfig_clk),
      .reset_n (1'b1),
      .din     (xcvr_rxcdr_locked), 
      .dout    (eiofreq_lock_sync)
  );

assign eiofreq_lock_csr = {{(8-LANE_NUM){1'b0}}, eiofreq_lock_sync};
assign o_cdr_lock = (LANE_NUM == 1)? eiofreq_lock_sync : &eiofreq_lock_sync; 
    // -----------------------------
    // EHIP RX PCS deskew status
    // -----------------------------
    logic           ehip_rx_dsk_done_sync;
    logic           ehip_rx_dsk_done_sync_last = '0;
    logic           ehip_rx_dsk_done_chng = '0;
    logic           ehip_rx_dsk_done_chng_sticky;
    logic           phy_clear_dsk_chng_sticky;

    eth_f_altera_std_synchronizer_nocut rx_dsk_sync_inst (
        .clk        (i_reconfig_clk),
        .reset_n    (1'b1),
        .din        (ehip_rx_dsk_done),
        .dout       (ehip_rx_dsk_done_sync)
    );

    always @(posedge i_reconfig_clk) begin  //All registers are initialized to 0.
        ehip_rx_dsk_done_sync_last  <= ehip_rx_dsk_done_sync;
        ehip_rx_dsk_done_chng       <= ehip_rx_dsk_done_sync_last ^ ehip_rx_dsk_done_sync;

        if (reconfig_reset_sync) begin
            ehip_rx_dsk_done_chng_sticky    <= 1'b0;
        end else begin
            if (phy_clear_dsk_chng_sticky) begin
                ehip_rx_dsk_done_chng_sticky    <= 1'b0;
            end else begin
                ehip_rx_dsk_done_chng_sticky    <= ehip_rx_dsk_done_chng_sticky || ehip_rx_dsk_done_chng;
            end
        end
    end

    // -----------------------------
    // EHIP PCS deskew status end
    // -----------------------------
logic [15:0] txaib_transfer_ready,rxaib_transfer_ready;
(* preserve_syn_only *) logic [31:0] config_ehip_rst_count;


  eth_f_csr #(
      .LANE_NUM     (LANE_NUM),
      .EHIP_RATE     (EHIP_RATE),
      .CLIENT_INT (CLIENT_INT),
     .ENABLE_PTP   (ENABLE_PTP)
  ) csr_inst(

      .i_reconfig_clk                                         (i_reconfig_clk),
      .i_reconfig_reset                                       (reconfig_reset_sync),
      .i_cfg_reset_new                                        (1'b0), 
      .i_reconfig_eth_addr                                    (i_reconfig_eth_addr_jtag_arb),
      .i_reconfig_eth_read                                    (i_reconfig_eth_read_jtag_arb),
      .i_reconfig_eth_write                                   (i_reconfig_eth_write_jtag_arb),
      .i_reconfig_eth_writedata                               (i_reconfig_eth_writedata_jtag_arb),
      .i_reconfig_eth_byteenable                              (i_reconfig_eth_byteenable_jtag_arb),
      .eth_rate                                               (EHIP_RATE_CSR[2:0]),
      .sel_25g_10g_reg                                        (SEL_25G_10G_REG),
      .eth_link_fault                                         (eth_link_fault[1:0]),
      .anlt_enable                                            (ENABLE_ANLT[0]),
      .modulation_type                                        (MODULATION[0]),
      .rsfec_type                                             (RSFEC_TYPE[2:0]),
      .flow_control_mode                                      (FLOW_CONTROL[2:0]),
      .client_intf                                            (CLIENT_INT[2:0]),
      .xcvr_type                                              (XCVR_TYPE_SIP[0]),
      .num_lanes                                              (LANE_NUM[3:0]),
      .dis_pause_control 				      (DIS_PAUSE),
      .sec_enable                                             (SEC_ENABLE),
      // DR
      .i_tx_ehip_preamble_passthru_gui (tx_ehip_preamble_passthru_gui),
      .o_tx_ehip_preamble_passthru_dr  (tx_ehip_preamble_passthru_dr),
      // PTP
      .i_ptp_clk                      (ptp_clk            ),
      .i_tx_tod_clk                   (tx_tod_clk         ),
      .i_rx_tod_clk                   (rx_tod_clk         ),
      .i_samp_clk                     (i_clk_ptp_sample   ),
      .i_tx_srst_n                    (tx_ptp_rst_n       ),
      .i_rx_srst_n                    (rx_ptp_rst_n       ),
      .i_tx_tod_srst_n                (tx_tod_rst_n       ),
      .i_rx_tod_srst_n                (rx_tod_rst_n       ),
      .i_tx_samp_srst_n               (tx_samp_rst_n      ),
      .i_rx_samp_srst_n               (rx_samp_rst_n      ),
      .i_tx_apulse_wdly_valid         (wo_tx_apulse_wdly_valid         ),
      .i_tx_apulse_offset_valid       (wo_tx_apulse_offset_valid       ),
      .i_tx_apulse_time_valid         (wo_tx_apulse_time_valid         ),
      .i_rx_apulse_wdly_valid         (wo_rx_apulse_wdly_valid         ),
      .i_rx_apulse_offset_valid       (wo_rx_apulse_offset_valid       ),
      .i_rx_apulse_time_valid         (wo_rx_apulse_time_valid         ),
      .i_tx_apulse_wdly               (wo_tx_apulse_wdly               ),
      .i_tx_apulse_offset             (wo_tx_apulse_offset             ),
      .i_tx_apulse_time               (wo_tx_apulse_time               ),
      .i_rx_apulse_wdly               (wo_rx_apulse_wdly               ),
      .i_rx_apulse_offset             (wo_rx_apulse_offset             ),
      .i_rx_apulse_time               (wo_rx_apulse_time               ),
      .o_tx_ref_lane                  (wi_tx_ref_lane                  ),
      .o_rx_lal                       (wi_rx_lal                       ),
      .i_tx_const_adjust              (wo_tx_const_adjust              ),
      .i_rx_const_adjust              (wo_rx_const_adjust              ),
      .o_tx_calc_adjust               (wi_tx_calc_adjust               ),
      .o_rx_calc_adjust               (wi_rx_calc_adjust               ),
      .o_rx_fec_cw_pos_user_cfg_done  (wi_rx_fec_cw_pos_user_cfg_done  ),
      .o_tx_ptp_user_cfg_done         (wi_tx_ptp_user_cfg_done         ),
      .o_rx_ptp_user_cfg_done         (wi_rx_ptp_user_cfg_done         ),
      .i_tx_ptp_user_cfg_done_clrn    (wo_tx_ptp_user_cfg_done_clrn    ),
      .i_rx_ptp_user_cfg_done_clrn    (wo_rx_ptp_user_cfg_done_clrn    ),
      .i_rx_pcs_fully_aligned         (o_rx_pcs_fully_aligned_sync     ),
      .i_rx_ptp_vl_snapshot           (rx_ptp_vl_snapshot              ),
      .i_tx_tam_valid                 (wo_tx_tam_valid                 ),
      .i_tx_tam_cnt                   (wo_tx_tam_cnt                   ),
      .i_tx_tam_ui                    (wo_tx_tam_ui                    ),
      .i_rx_tam_valid                 (wo_rx_tam_valid                 ),
      .i_rx_tam_cnt                   (wo_rx_tam_cnt                   ),
      .i_rx_tam_ui                    (wo_rx_tam_ui                    ),
      .i_tx_ptp_offset_data_valid     (o_tx_ptp_offset_data_valid      ),
      .i_rx_ptp_offset_data_valid     (o_rx_ptp_offset_data_valid      ),
      .i_tx_ptp_ready                 (o_tx_ptp_ready                  ),
      .i_rx_ptp_ready                 (o_rx_ptp_ready                  ),
      // Output
      .o_reconfig_eth_readdata                                (o_reconfig_eth_readdata_jtag_arb),
      .o_reconfig_eth_readdata_valid                          (o_reconfig_eth_readdata_valid_jtag_arb),
      .o_reconfig_eth_waitrequest                             (o_reconfig_eth_waitrequest_jtag_arb),
      .tx_rst_ack_n                                           (o_tx_rst_ack_n),
      .rx_rst_ack_n                                           (o_rx_rst_ack_n),
      .rst_ack_n                                              (o_rst_ack_n),
      .tx_lanes_stable_status                                 (tx_lanes_stable_sync), 
      .ehip_local_fault_status                                (local_fault_status_sync), 
      .ehip_remote_fault_status                               (remote_fault_status_sync),
 
      .rxaib_transfer_ready_ehip                              (rxaib_transfer_ready), 
      .rxaib_transfer_ready_ptp                               (2'b0), // TODO 1:0
      .txaib_transfer_ready_ehip                              (txaib_transfer_ready), 
      .clk_tx_khz                                             (clk_tx_khz), 
      .clk_rx_khz                                             (clk_rx_khz),
      .clk_pll_khz                                            (clk_pll_khz),
      .clk_tx_div_khz                                         (clk_tx_div_khz),
      .clk_rec_div64_khz                                      (clk_rec_div64_khz),
      .clk_rec_div_khz                                        (clk_rec_div_khz),
      .dropped_frame_cnt                                      (rx_adapt_dropped_frames_shadow), 
      .dropped_clear                                          (dropped_clear),
      .dropped_frame_snapshot                                 (dropped_frame_snapshot),
      .eth_reset_eio_sys_rst                                  (eio_sys_rst),
      .eth_reset_soft_tx_rst                                  (soft_tx_rst),
      .eth_reset_soft_rx_rst                                  (soft_rx_rst),
//
      .eth_reset_tx_clear_alarm                               (tx_clear_alarm),
      .eth_reset_rx_clear_alarm                               (rx_clear_alarm),
      .eth_reset_status_tx_lane_current_state_i               (tx_lane_current_state_sync_autosrc[2:0]), 
      .eth_reset_status_rx_lane_current_state_i               (rx_lane_current_state_sync_autosrc[2:0]),

      .eth_reset_status_tx_alarm_i                            (tx_alarm_csr), 
      .eth_reset_status_rx_alarm_i                            (rx_alarm_csr),
      .phy_tx_pll_locked_tx_pll_locked_i                      (tx_pll_locked_csr),
      .phy_eiofreq_locked_eio_freq_lock_i                     (eiofreq_lock_csr), 
      .pcs_status_dskew_status_i                              (ehip_rx_dsk_done_sync), 
      .pcs_status_dskew_chng_i                                (ehip_rx_dsk_done_chng),
      .pcs_status_rx_pcs_ready_i                              (rx_pcs_ready_sync),
      .pcs_status_kr_mode_i                                   (kr_mode_sync),
      .pcs_status_kr_fec_mode_i                               (kr_fec_mode_sync),
      .pcs_control_clr_dskew_chng                             (phy_clear_dsk_chng_sticky),
	
	.reset_swcwbin 						(cwbin_rst),
	.cwbin0_stat_block_A_i					(cwbin0A_out),
	.cwbin1_stat_block_A_i					(cwbin1A_out),
	.cwbin2_stat_block_A_i					(cwbin2A_out),
	.cwbin3_stat_block_A_i					(cwbin3A_out),
	.cwbin0_stat_block_B_i					(cwbin0B_out),
	.cwbin1_stat_block_B_i					(cwbin1B_out),
	.cwbin2_stat_block_B_i					(cwbin2B_out),
	.cwbin3_stat_block_B_i					(cwbin3B_out),
        .cwbin_timer_timeout					(cwbin_timer_timeout),
        
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
        .local_remote_pcs_cntr({pcs_ready_cntr,remote_fault_cntr,local_fault_cntr}),
		  
         .tx_sync_counter_i         (dl_tx_sync_count),
	 .tx_async_counter_i        (dl_tx_async_count), 
	 .rx_sync_counter_i         (dl_rx_sync_count), 
	 .rx_async_counter_i        (dl_rx_async_count), 
	 .rx_measure_valid_i        (dl_rx_measure_valid), 
	 .tx_measure_valid_i        (dl_tx_measure_valid),
	 .rx_dl_restart           (dl_rx_restart),
	 .tx_dl_restart           (dl_tx_restart),
	 .tx_dl_delay_i             (dl_tx_delay_sclk),
	 .rx_dl_delay_i             (dl_rx_delay_sclk),
	 .tx_sync_valid_i        (dl_tx_sync_valid),
	 .tx_async_valid_i       (dl_tx_async_valid),
	 .rx_sync_valid_i        (dl_rx_sync_valid),
	 .rx_async_valid_i       (dl_rx_async_valid),

         .pack_da_mismatch_cnt_in      (pack_da_mismatch_cnt_in     ),
         .pack_da_mismatch_cnt_out     (pack_da_mismatch_cnt_out    ),
         .pack_da_match_cnt_in         (pack_da_match_cnt_in        ),
         .pack_da_match_cnt_out        (pack_da_match_cnt_out       ),
         .tx_pause_da_mismatch_cnt_in  (tx_pause_da_mismatch_cnt_in ),
         .tx_pause_da_mismatch_cnt_out (tx_pause_da_mismatch_cnt_out),
         .tx_pause_da_match_cnt_in     (tx_pause_da_match_cnt_in    ),
         .tx_pause_da_match_cnt_out    (tx_pause_da_match_cnt_out   ),

	 .f_tx_operational_reconfigsync	(f_tx_operational_reconfigsync),
	 .f_rx_operational_reconfigsync	(f_rx_operational_reconfigsync),
	  .src_avmm1_req                  (src_avmm1_req),
	  .src_avmm1_ack                 (src_avmm1_ack),
	 //RX PAUSE signals
	 .tx_flow_control(tx_flow_control),
	 .forward_user_rxpause(forward_user_rxpause),
	 .en_sfc(en_sfc),	 
         .rxpause_daddr(mac_rxpause_daddr),
         .rx_en_pp    (rx_en_pp),
         .mac_forward_rx_pause_requests(param_rx_pause_requests),
	 .mac_rx_en_pp(param_rx_en_pp),
	 .mac_rx_en_pp_dr(1'b0),
         .single_multi_rate_pp (1'b0),
         .mac_flow_control(param_flow_control),
	 .mac_tx_xof (param_mac_tx_xof),
         .link_fault_config_unidir_10g (link_fault_config_unidir_10g),
         .o_rf_in_progress (rf_in_progress),
	  .config_ehip_rst_count (config_ehip_rst_count),
  // Signals from AVMM1 building block
      .pld_avmm1_busy                                         (pld_avmm1_busy),
      .pld_avmm1_cmdfifo_wr_full                              (pld_avmm1_cmdfifo_wr_full),
      .pld_avmm1_cmdfifo_wr_pfull                             (pld_avmm1_cmdfifo_wr_pfull),
      .pld_avmm1_readdata                                     (pld_avmm1_readdata[7:0]), // 8 bits
      .pld_avmm1_readdatavalid                                (pld_avmm1_readdatavalid),
      .pld_avmm1_reserved_out                                 (pld_avmm1_reserved_out), // 3 bits
      .pld_chnl_cal_done                                      (pld_chnl_cal_done), 
      .pld_hssi_osc_transfer_en                               (pld_hssi_osc_transfer_en),
  // Signals to AVMM1 building block
      .pld_avmm1_clk_rowclk                                   (pld_avmm1_clk_rowclk),
      .pld_avmm1_read                                         (pld_avmm1_read),
      .pld_avmm1_reg_addr                                     (pld_avmm1_reg_addr[9:0]), // 10 bits
      .pld_avmm1_request                                      (pld_avmm1_request),
      .pld_avmm1_reserved_in                                  (pld_avmm1_reserved_in[8:0]), // 9 bits
      .pld_avmm1_write                                        (pld_avmm1_write),
      .pld_avmm1_writedata                                    (pld_avmm1_writedata[7:0]) // 8 bits
  // TODO ports for AVMM2 building block
  //PORT_LIST_END
  ); 

  //----------------------------------------------------------------------
  //--------------------------- SOFT CSR ---------------------------------
  //----------------------------------------------------------------------
  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (16),
      .INIT_VALUE         (0)
  ) txaib_transfer_ready_sync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (i_txaib_transfer_ready),
      .q                  (txaib_transfer_ready)
  );
   
  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (16),
      .INIT_VALUE         (0)
  ) rxaib_transfer_ready_sync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (i_rxaib_transfer_ready),
      .q                  (rxaib_transfer_ready)
  );

  //----------------------------------------------------------------------
  //--------------------------- AVMM2 logic-------------------------------
  //----------------------------------------------------------------------
  eth_f_avmm2 #(
    .num_sys_cop                               (1),
    .num_xcvr                                  (LANE_NUM),
    .l_num_aib                                 (AIB_LANES),
    .l_sys_xcvrs                               (LANE_NUM),
    .l_tx_enable                               (0),// need confirm
    .l_rx_enable                               (0),// need confirm
    .avmm2_split                               (1),
    .avmm2_jtag_enable                         (0), //disable the ADME instances as commonIP is used
    .l_av2_enable                              (1),
    .l_num_avmm2                               (LANE_NUM),
    .l_av2_ifaces                              (LANE_NUM),
    .l_av2_addr_bits                           (20),
    .l_soft_csr_enable                         (0)
  ) eth_f_avmm2_inst (
    .reconfig_clk                              ({LANE_NUM{i_reconfig_clk}}),
    .reconfig_reset                            ({LANE_NUM{reconfig_reset_sync}}),
    .reconfig_write                            (i_reconfig_xcvr_write_jtag_arb),
    .reconfig_read                             (i_reconfig_xcvr_read_jtag_arb),
    .reconfig_address                          (i_reconfig_xcvr_byte_addr_jtag_arb),
    .reconfig_byteenable                       (i_reconfig_xcvr_byteenable_jtag_arb),
    .reconfig_writedata                        (i_reconfig_xcvr_writedata_jtag_arb),
    .reconfig_readdata                         (o_reconfig_xcvr_readdata_jtag_arb),
    .reconfig_waitrequest                      (o_reconfig_xcvr_waitrequest_jtag_arb),
    .reconfig_readdata_valid                   (o_reconfig_xcvr_readdata_valid_jtag_arb), // temp workaround
  //  for AVMM2 bb ports
    .hip_avmm_read                             ( hip_avmm_read              ),
    .hip_avmm_readdata                         ( hip_avmm_readdata          ),
    .hip_avmm_readdatavalid                    ( hip_avmm_readdatavalid     ),
    .hip_avmm_reg_addr                         ( hip_avmm_reg_addr          ),
    .hip_avmm_reserved_out                     ( hip_avmm_reserved_out      ),
    .hip_avmm_write                            ( hip_avmm_write             ),
    .hip_avmm_writedata                        ( hip_avmm_writedata         ),
    .hip_avmm_writedone                        ( hip_avmm_writedone         ),
    .pld_avmm2_busy                            ( pld_avmm2_busy             ),
    .pld_avmm2_clk_rowclk                      ( pld_avmm2_clk_rowclk       ),
    .pld_avmm2_cmdfifo_wr_full                 ( pld_avmm2_cmdfifo_wr_full  ),
    .pld_avmm2_cmdfifo_wr_pfull                ( pld_avmm2_cmdfifo_wr_pfull ),
    .pld_avmm2_request                         ( pld_avmm2_request          ),
    .pld_pll_cal_done                          ( 		            ),
    .pld_avmm2_write                           ( pld_avmm2_write            ),
    .pld_avmm2_read                            ( pld_avmm2_read             ),
    .pld_avmm2_reg_addr                        ( pld_avmm2_reg_addr         ),
    .pld_avmm2_readdata                        ( pld_avmm2_readdata         ),
    .pld_avmm2_writedata                       ( pld_avmm2_writedata        ),
    .pld_avmm2_readdatavalid                   ( pld_avmm2_readdatavalid    ),
    .pld_avmm2_reserved_in                     ( pld_avmm2_reserved_in      ),
    .pld_avmm2_reserved_out                    ( pld_avmm2_reserved_out     )
    
  );

  //----------------------------------------------------------------------
  //---------------------------- DESKEW ----------------------------------
  //----------------------------------------------------------------------
  
  // TX DESKEW
  wire [AIB_LANES-1:0] int_tx_aib_dsk;
  wire [AIB_LANES-1:0] int_tx_aib_dsk_2;
  logic                 ehip_tx_rst_ack_n = '0;
  wire                 ehip_tx_rst_ack_n_sync;

//--------------------------------------------------------------
//----- sync tx deskew reset with int_clk_tx --------------------
//--------------------------------------------------------------
    eth_f_altera_std_synchronizer_nocut tx_dsk_rst_sync_inst (
        .clk        (int_clk_tx),
        .reset_n    (1'b1),
        .din        (ehip_tx_rst_ack_n),
        .dout       (ehip_tx_rst_ack_n_sync)
    );
  
  eth_f_tx_deskew #(
      .LANES      (AIB_LANES)
  ) tx_dsk_inst (
      .i_clk      (int_clk_tx), 
      .i_resetn   (ehip_tx_rst_ack_n_sync), 
      .o_dsk      (int_tx_aib_dsk_2)
  );

  assign int_tx_aib_dsk = (ENABLE_PTP == 1) ? {AIB_LANES{tx_dsk_pulse}} : int_tx_aib_dsk_2;
  
  // RX DESKEW
  localparam RX_DATA_WIDTH= 78; 
  wire [AIB_LANES-1:0][RX_DATA_WIDTH-1:0]  rx_deskew_din;
  wire [AIB_LANES-1:0][RX_DATA_WIDTH-1:0]  rx_deskew_dout;
  wire [AIB_LANES-1:0]                     rx_aib_dsk;
  wire                                     rx_deskew_done;
  logic                                     ehip_rx_rst_ack_n = '0;
  wire                                     ehip_rx_rst_ack_n_sync_w;
  reg                                      ehip_rx_rst_ack_n_sync = '0, ehip_rx_rst_ack_n_sync_r1 = '0, ehip_rx_rst_ack_n_sync_r0 = '0;

//--------------------------------------------------------------
//----- sync rx deskew reset with int_clk_rx --------------------
//--------------------------------------------------------------
    eth_f_altera_std_synchronizer_nocut rx_dsk_rst_sync_inst (
        .clk        (int_clk_rx),
        .reset_n    (1'b1),
        .din        (ehip_rx_rst_ack_n),
        .dout       (ehip_rx_rst_ack_n_sync_w)
    );
    // relax rx_dsk_ptp_s2_inst reset timing
    always @ (posedge int_clk_rx) begin //All registers are initialized to 0.
        {ehip_rx_rst_ack_n_sync, ehip_rx_rst_ack_n_sync_r1, ehip_rx_rst_ack_n_sync_r0} <= {ehip_rx_rst_ack_n_sync_r1, ehip_rx_rst_ack_n_sync_r0, ehip_rx_rst_ack_n_sync_w}    ;
    end


  // PTP RX DESKEW
  wire           ptp_rx_deskew_bit_07 , ptp_rx_deskew_bit_815;
  wire [77:0]    ptp_rx_deskew_din_07 , ptp_rx_deskew_din_815;
  wire [77:0]    ptp_rx_deskew_dout_07, ptp_rx_deskew_dout_815;
  wire [77:0]    ptp_rx_deskew_dummy0 , ptp_rx_deskew_dummy1;
  // deskew_out to soft_ptp
  wire [79:0]    ptp_rx_data_aib_dsk; 
  wire [1:0]     ptp_rx_tx_ts_vld_aib_dsk;
  wire [7:0]     ptp_tx_dbg_aib_dsk;
  wire [7:0]     ptp_rx_dbg_aib_dsk;
  wire           hi_tx_ptp_sync_am;
  wire           hi_rx_ptp_sync_am;
  
  generate if (ENABLE_PTP == 1) begin : RX_DESKEW_PTP
    // deskew_in
    assign ptp_rx_deskew_din_07   = {26'h000_0000,ptp_rx_aib67_data[0]};
    assign ptp_rx_deskew_bit_07   = ptp_rx_deskew_din_07[51];
    assign ptp_rx_deskew_din_815  = 78'h0; // dummy content
    assign ptp_rx_deskew_bit_815  = ptp_rx_deskew_din_07[51]; // fake pulse
    // deskew_out to soft_ptp
    assign ptp_rx_data_aib_dsk      = {ptp_rx_deskew_dout_815[39:0] ,ptp_rx_deskew_dout_07[39:0]};
    assign ptp_rx_tx_ts_vld_aib_dsk = {ptp_rx_deskew_dout_815[40]   ,ptp_rx_deskew_dout_07[40]};
    assign ptp_tx_dbg_aib_dsk       = {ptp_rx_deskew_dout_815[46:43],ptp_rx_deskew_dout_07[46:43]};
    assign ptp_rx_dbg_aib_dsk       = {ptp_rx_deskew_dout_815[50:47],ptp_rx_deskew_dout_07[50:47]};
    assign hi_tx_ptp_sync_am        = ptp_rx_deskew_dout_07[41];
    assign hi_rx_ptp_sync_am        = ptp_rx_deskew_dout_07[42];
  end
  else begin
    assign ptp_rx_deskew_bit_07     = 0;
    assign ptp_rx_deskew_din_07     = 0;
    assign ptp_rx_deskew_bit_815    = 0;
    assign ptp_rx_deskew_din_815    = 0;
    assign ptp_rx_deskew_dout_07    = 0;
    assign ptp_rx_deskew_dout_815   = 0;
    assign ptp_rx_deskew_dummy0     = 0;
    assign ptp_rx_deskew_dummy1     = 0;
    assign ptp_rx_data_aib_dsk      = 0;
    assign ptp_rx_tx_ts_vld_aib_dsk = 0;
    assign ptp_tx_dbg_aib_dsk       = 0;
    assign ptp_rx_dbg_aib_dsk       = 0;
    assign hi_tx_ptp_sync_am        = 0;
    assign hi_rx_ptp_sync_am        = 0;
  end
  endgenerate
  
  generate if (EHIP_RATE == "400G" || EHIP_RATE == "200G") begin : RX_DESKEW_200G_400G
    logic [AIB_LANES*RX_DATA_WIDTH-1:0]  rx_deskew_din_r = '0;
    logic [AIB_LANES-1:0]                rx_aib_dsk_r = '0;
    always @(posedge int_clk_rx) begin  //All registers are initialized to 0.
      rx_deskew_din_r <= rx_deskew_din;
      rx_aib_dsk_r    <= rx_aib_dsk;
    end
    
    // Stage 1
    wire [AIB_LANES/4-1:0] [4*RX_DATA_WIDTH-1:0]  rx_deskew_dout_s1;
    wire [AIB_LANES/4-1:0] rx_deskew_done_s1;
    wire [AIB_LANES-1:0]   rx_deskew_pulse_s1;
    wire [AIB_LANES/4-1:0] rx_deskew_pulse_out_s1;

    genvar i;
    for (i=0;i<AIB_LANES/4;i=i+1) begin : RX_DSK_S1_LP
      eth_f_rx_deskew #(
        .LANES         (4),
        .WIDTH         (RX_DATA_WIDTH), // Per lane width
        .SIM_EMULATE   (SIM_EMULATE)
      ) rx_dsk_s1_inst (
        .i_clk          (int_clk_rx),
        .i_reset        (~ehip_rx_rst_ack_n_sync), 
        .i_data         (rx_deskew_din_r[4*RX_DATA_WIDTH*(i+1)-1:4*RX_DATA_WIDTH*i]),
        .i_sync_pulse   (rx_aib_dsk_r[4*(i+1)-1:4*i]),
        .o_data         (rx_deskew_dout_s1[i]),
        .o_sync_pulse   (rx_deskew_pulse_s1[4*(i+1)-1:4*i]), //case 16011958592; need sync outputs for Stage 2 Deskew logic
        .o_deskew_done  (rx_deskew_done_s1[i])
      );
    assign rx_deskew_pulse_out_s1[i] = rx_deskew_pulse_s1[4*i];
    end
    
    logic [2*RX_DATA_WIDTH-1:0]  ptp_rx_deskew_din_s1_r;
    logic [2-1:0]                ptp_rx_deskew_bit_s1_r;
    logic [2*RX_DATA_WIDTH-1:0]  ptp_rx_deskew_dout_s1;
    logic                        ptp_rx_deskew_done_s1;
    logic [2-1:0]                ptp_rx_deskew_pulse_s1;
    
    if (ENABLE_PTP == 1) begin: RX_DESKEW_200G_400G_PTP
        always @(posedge int_clk_rx) begin
          ptp_rx_deskew_din_s1_r    <= {ptp_rx_deskew_din_815     , ptp_rx_deskew_din_07};
          ptp_rx_deskew_bit_s1_r    <= {ptp_rx_deskew_bit_815     , ptp_rx_deskew_bit_07};
        end
          // Stage 1
          eth_f_rx_deskew #(
            .LANES         (2),
            .WIDTH         (RX_DATA_WIDTH), // Per lane width
            .SIM_EMULATE   (SIM_EMULATE)
          ) rx_dsk_ptp_s1_inst (
            .i_clk          (int_clk_rx),
            .i_reset        (~ehip_rx_rst_ack_n_sync),
            .i_data         (ptp_rx_deskew_din_s1_r),
            .i_sync_pulse   (ptp_rx_deskew_bit_s1_r),
            .o_data         (ptp_rx_deskew_dout_s1),
            .o_sync_pulse   (ptp_rx_deskew_pulse_s1),
            .o_deskew_done  (ptp_rx_deskew_done_s1)
          );
         // Stage 2
          eth_f_rx_deskew #(
              .LANES         (1+AIB_LANES/4),
              .WIDTH         (RX_DATA_WIDTH*4),
              .SIM_EMULATE   (SIM_EMULATE)
          ) rx_dsk_ptp_s2_inst (
              .i_clk          (int_clk_rx),
              .i_reset        (~ehip_rx_rst_ack_n_sync), 
              .i_data         ({rx_deskew_dout_s1, ptp_rx_deskew_dout_s1, {2*RX_DATA_WIDTH{1'b0}}}),
              .i_sync_pulse   ({rx_deskew_pulse_out_s1, ptp_rx_deskew_pulse_s1[0]} & {(1+AIB_LANES/4){(&rx_deskew_done_s1 & ptp_rx_deskew_done_s1)}}), //case 16011958592; wait until all Stage 1 Deskew dones are high
              .o_data         ({rx_deskew_dout   , ptp_rx_deskew_dout_815, ptp_rx_deskew_dout_07, ptp_rx_deskew_dummy1, ptp_rx_deskew_dummy0}), // last 2 data are not connected
              .o_deskew_done  (rx_deskew_done)
          );
    end
    else begin: RX_DESKEW_200G_400G_S2
      assign ptp_rx_deskew_din_s1_r = 0;
      assign ptp_rx_deskew_bit_s1_r = 0;
      assign ptp_rx_deskew_dout_s1 = 0;
      assign ptp_rx_deskew_done_s1 = 0;
      
      // Stage 2
      eth_f_rx_deskew #(
        .LANES         (AIB_LANES/4),
        .WIDTH         (RX_DATA_WIDTH*4), // Per lane width
        .SIM_EMULATE   (SIM_EMULATE)
      ) rx_dsk_s2_inst (
        .i_clk          (int_clk_rx),
        .i_reset        (~ehip_rx_rst_ack_n_sync),
        .i_data         (rx_deskew_dout_s1),
        .i_sync_pulse   (rx_deskew_pulse_out_s1 & {AIB_LANES/4{&rx_deskew_done_s1}}), //case 16011958592; wait until all Stage 1 Deskew dones are high
        .o_data         (rx_deskew_dout),
        .o_deskew_done  (rx_deskew_done)
      );
    end
  end
  else if ((EHIP_RATE == "100G" || EHIP_RATE == "50G" || EHIP_RATE == "25G" || EHIP_RATE == "10G") && ENABLE_PTP) begin : RX_DESKEW_100Gto10G_PTP
        eth_f_rx_deskew #(
            .LANES         (2+AIB_LANES),
            .WIDTH         (RX_DATA_WIDTH),
            .SIM_EMULATE   (SIM_EMULATE)
        ) rx_dsk_inst (
            .i_clk          (int_clk_rx),
            .i_reset        (~ehip_rx_rst_ack_n_sync),
            .i_data         ({rx_deskew_din , ptp_rx_deskew_din_815     , ptp_rx_deskew_din_07}),
            .i_sync_pulse   ({rx_aib_dsk    , ptp_rx_deskew_bit_815     , ptp_rx_deskew_bit_07}),
            .o_data         ({rx_deskew_dout, ptp_rx_deskew_dout_815    , ptp_rx_deskew_dout_07}),
            .o_deskew_done  (rx_deskew_done)
        );
  end
  else if (EHIP_RATE != "25G" && EHIP_RATE != "10G") begin : RX_DESKEW_n25G
    eth_f_rx_deskew #(
        .LANES         (AIB_LANES),
        .WIDTH         (RX_DATA_WIDTH), // Per lane width
        .SIM_EMULATE   (SIM_EMULATE)
    ) rx_dsk_inst (
        .i_clk          (int_clk_rx),
        .i_reset        (~ehip_rx_rst_ack_n_sync), 
        .i_data         (rx_deskew_din),
        .i_sync_pulse   (rx_aib_dsk),
        .o_data         (rx_deskew_dout),
        .o_deskew_done  (rx_deskew_done)
    );
  end
  else begin : NO_RX_DESKEW
      assign rx_deskew_done = 1'b1;
      assign rx_deskew_dout = rx_deskew_din;
  end
  endgenerate


  //---------------------------------------------------------------------
  //-----------------------------PACKER-----------------------------------
 //-----------------------------------------------------------------------

  localparam DWIDTH_MAC = 64;
 
  logic                     pack_tx_mac_ready;
  logic [64*DATA_WIDTH-1:0] pack_tx_mac_data;
  logic [1*INFRAME-1:0]     pack_tx_mac_inframe;
  logic [1*SEG_ERROR-1:0]   pack_tx_mac_error;
  logic [SEG_EOP_EMPTY-1:0] pack_tx_mac_eop_empty;
  logic                     pack_tx_mac_valid;
  logic [DATA_WIDTH-1:0]    pack_tx_mac_skip_crc;


 if (PACKING_EN == 1) begin: PACKER_40G_400G
eth_f_packing_tx 
#(
    .DWIDTH        (DWIDTH_MAC),
    .NUM_SEG       (DATA_WIDTH),
    .SIM_EMULATE   (SIM_EMULATE)
) packer_inst (
    .i_clk (i_clk_tx),
    .i_reset (~o_tx_lanes_stable),
    .i_clr_stats(tx_pkt_sts_clr),
    .o_max_fifo_level(tx_pkr_max_fifo_level),
    .o_min_fifo_level(tx_pkr_min_fifo_level),
    .o_fifo_empty_cnt(tx_pkr_fifo_empty_cnt),

    .i_data (i_tx_mac_data),
    .i_inframe (i_tx_mac_inframe),
    .i_error (i_tx_mac_error),
    .i_empty (i_tx_mac_eop_empty),
    .i_valid (i_tx_mac_valid),
    .i_skip_crc (i_tx_mac_skip_crc),
    .o_ready (o_tx_mac_ready),

    .o_data (pack_tx_mac_data),
    //.o_data (o_mac_data),
    .o_inframe (pack_tx_mac_inframe),
    .o_error (pack_tx_mac_error),
    .o_empty (pack_tx_mac_eop_empty),
    .o_valid (pack_tx_mac_valid),
    .o_skip_crc (pack_tx_mac_skip_crc),
    .i_ready (pack_tx_mac_ready)
);

 end
 else begin: PACKER_NOT_EN
  assign o_tx_mac_ready        = pack_tx_mac_ready;
  assign pack_tx_mac_data      = i_tx_mac_data;
  assign pack_tx_mac_valid     = i_tx_mac_valid;
  assign pack_tx_mac_inframe   = i_tx_mac_inframe;
  assign pack_tx_mac_eop_empty = i_tx_mac_eop_empty;
  assign pack_tx_mac_error     = i_tx_mac_error;
  assign pack_tx_mac_skip_crc  = i_tx_mac_skip_crc;
  assign tx_pkr_max_fifo_level = 6'd0;
  assign tx_pkr_min_fifo_level = 6'd0;
  assign tx_pkr_fifo_empty_cnt = 4'd0;
 end

 assign	pack_da_mismatch_cnt_in  = 64'd0;
 assign	pack_da_mismatch_cnt_out = 64'd0;
 assign	pack_da_match_cnt_in     = 64'd0;
 assign	pack_da_match_cnt_out    = 64'd0;
 assign tx_mac_sop_cnt_lo        = 32'd0;
 assign	tx_mac_sop_cnt_hi        = 15'd0;
 assign	tx_mac_eop_cnt_lo        = 32'd0;
 assign	tx_mac_eop_cnt_hi        = 15'd0;
 assign	tx_mac_byte_cnt_lo       = 32'd0;
 assign	tx_mac_byte_cnt_hi       = 15'd0;


	assign local_fault_cntr   = 8'd0;
	assign remote_fault_cntr  = 8'd0;
	assign pcs_ready_cntr     = 8'd0;
	assign rx_mac_sop_cnt_lo  = 32'd0;
	assign rx_mac_sop_cnt_hi  = 15'd0;
	assign rx_mac_eop_cnt_lo  = 32'd0;
	assign rx_mac_eop_cnt_hi  = 15'd0;
	assign rx_mac_byte_cnt_lo = 32'd0;
	assign rx_mac_byte_cnt_hi = 15'd0;
	assign tx_pkr_sop_cnt_lo  = 32'd0;
	assign tx_pkr_sop_cnt_hi  = 15'd0;
	assign tx_pkr_eop_cnt_lo  = 32'd0;
	assign tx_pkr_eop_cnt_hi  = 15'd0;
	assign tx_pkr_byte_cnt_lo = 32'd0;
	assign tx_pkr_byte_cnt_hi = 15'd0;

 
  //----------------------------------------------------------------------
  //---------------------------- DESKEW ----------------------------------
  //----------------------------------------------------------------------
      
  //----------------------------------------------------------------------
  //---------------------------- ADAPTER ---------------------------------
  //----------------------------------------------------------------------

  //----------------------------------------------------------------------
  // TX Direction: from User i/f towards EHIP  
  // Adapter    - Converts Avalon-ST interface into MAC Segmented
  // Reverse    - Reverse data bytes required for Adapter
  // 40G Bridge - For 40G only. Converts 2x Lanes from user i/f to 4x AIB Lanes 
  //             
  //        ___________      ______________          _____________       
  // AvST  |           |    |              |        |             | EHIP      
  //   --->| eth_f_    |--->| eth_f_tx     |--X---->| eth_f_40g   |---->
  //       | adapter_tx|    | _avst_reverse|  |  |  | bridge_tx   |  |    
  //       |___________|    |______________|  |  |  |_____________|  |     
  // MAC Seg                                  |  |                   |    
  //   --->-----------------------------------    --------->---------                    
  //                 CLIENT_INT==0                   EHIP_RATE!=40G
  //   
  //----------------------------------------------------------------------
  // RX Direction: from EHIP towards User i/f  
  // 40G Bridge - For 40G only. Converts 4x AIB Lanes to 2x Lanes of user i/f
  // Reverse    - Reverse data bytes required for Adapter
  // Adapter    - Converts Avalon-ST interface into MAC Segmented
  //             
  //        ___________      ______________          _____________       
  // AvST  |           |    |              |        |             | EHIP      
  //   <---| eth_f_    |<---| eth_f_rx     |<----X--| eth_f_40g   |<----
  //       | adapter_rx|    | _avst_reverse|  |  |  | bridge_rx   |  |    
  //       |___________|    |______________|  |  |  |_____________|  |     
  // MAC Seg                                  |  |                   |    
  //   <--------------------------------------    ---------<---------                    
  //                 CLIENT_INT==0                   EHIP_RATE!=40G
  //   
  //----------------------------------------------------------------------


  localparam AIB_LANES_ADP = (EHIP_RATE== "40G")? 2 : AIB_LANES;
  
  // TX ADAPTER
  wire [AIB_LANES-1:0] [64-1:0] int_tx_data;
  wire                          int_tx_valid;
  wire                          int_tx_ready;
  logic                         int_tx_ready_r1 = '0, int_tx_ready_r2 = '0;
  wire 				int_tx_ready_sync,int_tx_ready_sync1;
  wire [AIB_LANES-1:0]          int_tx_inframe;
  wire [AIB_LANES-1:0][2:0]     int_tx_empty ; 
  wire [AIB_LANES-1:0]          int_tx_error;
  wire [AIB_LANES-1:0]          int_tx_skip_crc;  
  wire [AIB_LANES-1:0] [64-1:0] int2_tx_data;
  wire                          int2_tx_valid;
  wire                          int2_tx_ready;
  wire [AIB_LANES-1:0]          int2_tx_inframe;
  wire [AIB_LANES-1:0][2:0]     int2_tx_empty ;   
  wire [AIB_LANES-1:0]          int2_tx_error;
  wire [AIB_LANES-1:0]          int2_tx_skip_crc;
  
  wire [AIB_LANES-1:0] [64-1:0] int3_tx_data;
  wire                          int3_tx_valid;
  wire                          int3_tx_ready;
  wire [AIB_LANES-1:0]          int3_tx_inframe;
  wire [AIB_LANES-1:0][2:0]     int3_tx_empty ;   
  wire [AIB_LANES-1:0]          int3_tx_error;
  wire [AIB_LANES-1:0]          int3_tx_skip_crc;
  
  wire [AIB_LANES-1:0] [64-1:0] int4_tx_data;
  wire                          int4_tx_valid;
  wire                          int4_tx_ready;
  wire [AIB_LANES-1:0]          int4_tx_inframe;
  wire [AIB_LANES-1:0][2:0]     int4_tx_empty ;   
  wire [AIB_LANES-1:0]          int4_tx_error;
  wire [AIB_LANES-1:0]          int4_tx_skip_crc;

  wire [AIB_LANES_ADP-1:0] [64-1:0] int_adp_tx_data;
  wire                              int_adp_tx_valid;
  wire [AIB_LANES_ADP-1:0]          int_adp_tx_inframe;
  wire [AIB_LANES_ADP-1:0][2:0]     int_adp_tx_empty ;   
  wire [AIB_LANES_ADP-1:0]          int_adp_tx_error;
  wire [AIB_LANES_ADP-1:0]          int_adp_tx_skip_crc;   

  // Bridge signals
  
    wire [AIB_LANES_ADP-1:0] [63:0]   int_bridge_tx_data; 
    wire [AIB_LANES_ADP-1:0]          int_bridge_tx_inframe; 
    wire [AIB_LANES_ADP-1:0] [2:0]    int_bridge_tx_empty; 
    wire [AIB_LANES_ADP-1:0]          int_bridge_tx_error; 
    wire [AIB_LANES_ADP-1:0]          int_bridge_tx_skip_crc; 
    wire                              int_bridge_tx_valid; 
    wire                              int_bridge_tx_ready;

    wire [AIB_LANES_ADP-1:0] [63:0]   int_bridge_rx_data; 
    wire [AIB_LANES_ADP-1:0]          int_bridge_rx_inframe; 
    wire [AIB_LANES_ADP-1:0] [2:0]    int_bridge_rx_empty; 
    wire [AIB_LANES_ADP-1:0] [1:0]    int_bridge_rx_error; 
    wire [AIB_LANES_ADP-1:0]          int_bridge_rx_fcs_error; 
    wire                              int_bridge_rx_valid; 
    wire [AIB_LANES_ADP-1:0][2:0]     int_bridge_rx_status;
 //OTN 40G Bridge signals
  wire [AIB_LANES-1:0][65:0]    i2_tx_pcs66_d;
  wire                          i2_tx_pcs66_valid;
  wire                          i2_tx_pcs66_am;
  wire [AIB_LANES-1:0][65:0]    o2_rx_pcs66_d;
  wire                          o2_rx_pcs66_valid;
  wire                          o2_rx_pcs66_am_valid;
  wire                          int_bridge_tx_pcs66_ready;
  //Generate TX Adapter
  logic   [31:0]  tx_starts_in        /* synthesis noprune */;
  logic   [31:0]  tx_starts_out       /* synthesis noprune */;
  logic   [31:0]  tx_ends_in          /* synthesis noprune */;
  logic   [31:0]  tx_ends_out         /* synthesis noprune */;
  logic   [0:7]   tx_mem_underflow    /* synthesis noprune */;

generate
wire tx_ready_sync_fifo_empty;
reg  [2:0] rdy_fifo_rd_addr; 
reg  [2:0] rdy_fifo_wr_addr; 


  always @(posedge int_clk_rx or negedge o_tx_lanes_stable)
  begin
    if(~o_tx_lanes_stable)
      rdy_fifo_wr_addr <= 3'd2;
    else
      rdy_fifo_wr_addr <= rdy_fifo_wr_addr + 3'd1;
  end

  always @(posedge int_clk_tx or negedge o_tx_lanes_stable)
  begin
    if(~o_tx_lanes_stable)
      rdy_fifo_rd_addr <= 3'd0;
    else
      rdy_fifo_rd_addr <= rdy_fifo_rd_addr + 3'd1;
  end


    eth_f_mlab #(
        .WIDTH       (1),
        .ADDR_WIDTH  (5),
        .SIM_EMULATE (SIM_EMULATE)
    ) rd_ptr_sync (
        .wclk       (int_clk_rx),
        .wena       (1'b1),
        .waddr_reg  ({2'd0, rdy_fifo_wr_addr}),
        .wdata_reg  (int_tx_ready),
        .raddr      ({2'd0, rdy_fifo_rd_addr}),
        .rdata      (int_tx_ready_sync)
    );
    
//			eth_f_dcfifo_mlab #(
//				.WIDTH          (1), 
//				.SYNC_ACLR_W    ("OFF"),
//				.SYNC_ACLR_R    ("ON")
//			) rd_ptr_sync (
//				.aclr   (~o_tx_lanes_stable),
//				.wclk   (int_clk_rx),
//				.write  (1'b1),
//				.wdata  (int_tx_ready_r2), 
//				.full   (/* unused */),
//				.rclk   (int_clk_tx),
//				.read   (~tx_ready_sync_fifo_empty),
//				.rdata  (int_tx_ready_sync),
//				.empty  (tx_ready_sync_fifo_empty)
//			);
 

			
     if (CLIENT_INT == 1 ) begin : TX_ADAPT_100G_50G_25G_ASYNC_SYNC

        eth_f_adapter_tx #(
             .READY_LATENCY         (READY_LATENCY),
             .ENABLE_ASYNC_ADAPTERS (ENABLE_ASYNC_ADAPTERS),
             .EHIP_RATE             (EHIP_RATE),
             //.PREAMBLE_PASSTHROUGH  (PREAMBLE_PASSTHROUGH),
	     .SIM_EMULATE           (SIM_EMULATE)
             ) adater_tx_inst (
             .i_preamble_passthrough_reg  (PREAMBLE_PASSTHROUGH[0]),
             .i_reset            (~o_tx_lanes_stable),
             // User ports
             .i_clk_w           (i_clk_tx),
             .i_valid           (i_tx_valid),   
             .i_data            (i_tx_data),        
             .i_sop             (i_tx_startofpacket),
             .i_eop             (i_tx_endofpacket),    
             .i_empty           (i_tx_empty),     
             .i_error           (i_tx_error),
             .i_preamble        (i_tx_preamble),
             .i_skip_crc        (i_tx_skip_crc),
             .o_ready           (o_tx_ready),   

             // To reverse byte logic
             .i_clk_r           (int_clk_tx),
             .i_ready           (int_bridge_tx_ready),
             .o_data            (int_adp_tx_data),
             .o_valid           (int_adp_tx_valid),
             .o_inframe         (int_adp_tx_inframe),
             .o_empty           (int_adp_tx_empty),
             .o_error           (int_adp_tx_error),
             .o_skip_crc        (int_adp_tx_skip_crc),
             .o_starts_in       (tx_starts_in),
             .o_starts_out      (tx_starts_out),
             .o_ends_in         (tx_ends_in),
             .o_ends_out        (tx_ends_out),
             .o_mem_underflow   (tx_mem_underflow)
             );

       eth_f_tx_avst_reverse #(
            .AIB_LANES      (AIB_LANES_ADP)
       ) tx_avst_reverse (
            .i_tx_data_avst     (int_adp_tx_data),    
            .i_tx_inframe_avst  (int_adp_tx_inframe),
            .i_tx_empty_avst    (int_adp_tx_empty),
            .i_tx_error_avst    (int_adp_tx_error),
            .i_tx_skip_crc_avst (int_adp_tx_skip_crc),

            .o_tx_data          (int_bridge_tx_data),
            .o_tx_inframe       (int_bridge_tx_inframe),
            .o_tx_empty         (int_bridge_tx_empty),
            .o_tx_skip_crc      (int_bridge_tx_skip_crc),
            .o_tx_error         (int_bridge_tx_error)
       );

       assign int_bridge_tx_valid      = int_adp_tx_valid;

       assign pack_tx_mac_ready           = 'b0;

     end
     else if (CLIENT_INT == 0) begin : TX_MAC_SEG

///registering for timing for macseg only, tx ptp input is pipelined accordingly
logic [64*DATA_WIDTH-1:0]     int_tx_mac_data = '0;
logic                        int_tx_mac_valid = '0;
logic  [1*INFRAME-1:0]         int_tx_mac_inframe = '0;
logic [SEG_EOP_EMPTY-1:0]     int_tx_mac_eop_empty = '0;
logic  [1*SEG_ERROR-1:0]       int_tx_mac_error = '0;
logic  [DATA_WIDTH-1:0]         int_tx_mac_skip_crc = '0;

always @ (posedge int_clk_tx) begin //All registers are initialized to 0.
    int_tx_mac_data <= pack_tx_mac_data;
    int_tx_mac_valid <= pack_tx_mac_valid;
    int_tx_mac_inframe <= pack_tx_mac_inframe;
    int_tx_mac_eop_empty <= pack_tx_mac_eop_empty;
    int_tx_mac_error <= pack_tx_mac_error;
    int_tx_mac_skip_crc <= pack_tx_mac_skip_crc;
end 

/// Ready pipelining for macseg only
logic int_bridge_tx_ready_s1 = '0;
logic int_bridge_tx_ready_s2 = '0;
logic int_bridge_tx_ready_s3 = '0;

always @ (posedge int_clk_tx) begin //All registers are initialized to 0.
	int_bridge_tx_ready_s1 <= int_bridge_tx_ready;
	int_bridge_tx_ready_s2 <= int_bridge_tx_ready_s1;
	int_bridge_tx_ready_s3 <= int_bridge_tx_ready_s2; 
end    


         assign int_bridge_tx_data      = int_tx_mac_data;
         assign int_bridge_tx_valid     = int_tx_mac_valid;
         assign int_bridge_tx_inframe   = int_tx_mac_inframe;
         assign int_bridge_tx_empty     = int_tx_mac_eop_empty;
         assign int_bridge_tx_error     = int_tx_mac_error;
         assign int_bridge_tx_skip_crc  = int_tx_mac_skip_crc;
         assign pack_tx_mac_ready          = int_bridge_tx_ready_s1;
         assign o_tx_ready       = 'b0;
     end
     else begin : TX_MAC_DISABLED
        assign int_tx_ready       = 'b0;
        assign o_tx_ready       = 'b0;
        assign pack_tx_mac_ready   = 'b0;
	assign int_bridge_tx_inframe = 'b0;
        assign int_bridge_tx_data = 'b0;
	assign int_bridge_tx_empty ='b0;
	assign int_bridge_tx_error = 'b0;
	assign int_bridge_tx_skip_crc = 'b0;
	assign int_bridge_tx_valid = 'b0;
     end // TX_MAC_DISABLED      
  endgenerate
  
  // RX ADAPTER
  
  wire [AIB_LANES-1:0]        int_rx_inframe;
  wire [AIB_LANES-1:0][63:0]  int_rx_data;
  wire                        int_rx_valid;
  wire [AIB_LANES-1:0][2:0]   int_rx_empty;
  wire [AIB_LANES-1:0][1:0]   int_rx_error;
  wire [AIB_LANES-1:0]        int_rx_fcs_error;
  wire [AIB_LANES-1:0][2:0]   int_rx_status;
  wire [AIB_LANES-1:0]        int2_rx_inframe;
  wire [AIB_LANES-1:0][63:0]  int2_rx_data;
  wire                        int2_rx_valid;
  wire [AIB_LANES-1:0][2:0]   int2_rx_empty;
  wire [AIB_LANES-1:0][1:0]   int2_rx_error;
  wire [AIB_LANES-1:0]        int2_rx_fcs_error;
  wire [AIB_LANES-1:0][2:0]   int2_rx_status;
  wire [AIB_LANES_ADP-1:0]        int_adp_rx_inframe; 
  wire [AIB_LANES_ADP-1:0][63:0]  int_adp_rx_data;
  wire                            int_adp_rx_valid;
  wire [AIB_LANES_ADP-1:0]        int_adp_filtered_if; 
  wire                            int_adp_filtered_if_valid; 
  wire [AIB_LANES_ADP-1:0][2:0]   int_adp_rx_empty;
  wire [AIB_LANES_ADP*2-1:0]        int_adp_rx_error;
  wire [AIB_LANES_ADP-1:0]          int_adp_rx_fcs_error;
  wire [AIB_LANES_ADP*3-1:0]        int_adp_rx_status;
  
    logic [AIB_LANES-1:0]        int_rx_inframe_fc;
  logic [AIB_LANES-1:0][63:0]  int_rx_data_fc;
  logic                        int_rx_valid_fc;
  logic [AIB_LANES-1:0][2:0]   int_rx_empty_fc;
  logic [AIB_LANES-1:0][1:0]   int_rx_error_fc;
  logic [AIB_LANES-1:0]        int_rx_fcs_error_fc;
  logic [AIB_LANES-1:0][2:0]   int_rx_status_fc;

  localparam AIB_LANES_RX = (EHIP_RATE== "100G")? 4 : 1;
  
  wire [0:AIB_LANES_RX-1][1:0]       rx_error_temp;
  wire [0:AIB_LANES_RX-1]            rx_fcs_error_temp;
  wire [0:AIB_LANES_RX-1][2:0]       rx_status_temp;

  wire [15:0] min_mac_octets = PREAMBLE_PASSTHROUGH ? (KEEP_RX_CRC ? 16'd72 : 16'd68) : 
                                                      (KEEP_RX_CRC ? 16'd64: 16'd60);  
generate
  if (CLIENT_INT == 1 )   begin : RX_ADPT_100G_50G_10G  
   
    eth_f_rx_avst_reverse #(
            .AIB_LANES      (AIB_LANES_ADP)
       ) rx_avst_reverse (
            .i_rx_data           (int_bridge_rx_data),
            .i_rx_inframe        (int_bridge_rx_inframe),
            .i_rx_empty          (int_bridge_rx_empty),
            .i_rx_error          (int_bridge_rx_error),
            .i_rx_fcs_error      (int_bridge_rx_fcs_error),
            .i_rx_status         (int_bridge_rx_status),

            .o_rx_data_avst      (int_adp_rx_data),
            .o_rx_inframe_avst   (int_adp_rx_inframe),
            .o_rx_empty_avst     (int_adp_rx_empty),
            .o_rx_error_avst     (int_adp_rx_error),
            .o_rx_fcs_error_avst (int_adp_rx_fcs_error),
            .o_rx_status_avst    (int_adp_rx_status)
       );

    assign int_adp_rx_valid     = int_bridge_rx_valid;

    if (EHIP_RATE == "100G") begin

         assign rx_error_temp     ={int_adp_rx_error[5:4],int_adp_rx_error[5:4],int_adp_rx_error[1:0],int_adp_rx_error[1:0]}; 
         assign rx_fcs_error_temp ={int_adp_rx_fcs_error[2],int_adp_rx_fcs_error[2],int_adp_rx_fcs_error[0],int_adp_rx_fcs_error[0]};
         assign rx_status_temp    ={int_adp_rx_status[8:6],int_adp_rx_status[8:6],int_adp_rx_status[2:0],int_adp_rx_status[2:0]};
    end 
    else if (EHIP_RATE == "50G" || EHIP_RATE == "40G" ) begin

         assign rx_error_temp     =int_adp_rx_error[1:0];  
         assign rx_fcs_error_temp =int_adp_rx_fcs_error[0];
         assign rx_status_temp    =int_adp_rx_status[2:0];
    end
    else begin
         assign rx_error_temp     =int_adp_rx_error;
         assign rx_fcs_error_temp =int_adp_rx_fcs_error;
         assign rx_status_temp    =int_adp_rx_status;
    end

    eth_f_adapter_rx #(
          .EHIP_RATE             (EHIP_RATE),
          .ENABLE_ASYNC_ADAPTERS (ENABLE_ASYNC_ADAPTERS),
          .PREAMBLE_PASSTHROUGH  (PREAMBLE_PASSTHROUGH)
      )adater_rx_inst(
         .i_arst             (~o_rx_pcs_ready),

         // User Interface
         .i_clk_r            (i_clk_rx),
         .o_data             (o_rx_data),
         .o_valid            (o_rx_valid),
         .o_sop              (o_rx_startofpacket),
         .o_eop              (o_rx_endofpacket),
         .o_empty            (o_rx_empty),
         .o_error            (o_rx_error),
         .o_status           (o_rxstatus_data),
         .o_status_valid     (o_rxstatus_valid),
         .o_preamble         (o_rx_preamble),

         // EHIP Interface
         .i_clk_w            (int_clk_rx),
         .i_valid            (int_adp_rx_valid),
         .i_data             (int_adp_rx_data),
         .i_inframe          (int_adp_rx_inframe),
         .i_empty            (int_adp_rx_empty),
         .i_error            (rx_error_temp),
         .i_fcs_error        (rx_fcs_error_temp),
         .i_status           (rx_status_temp),  

         .i_clear_counters   (dropped_clear_sync),
         .i_min_frame_octets (min_mac_octets),
         .o_dropped_frames   (rx_adapt_dropped_frames),
         
         // Wire to ptp_adapter_rx
         .o_dbg_filtered_if        (int_adp_filtered_if),
         .o_dbg_filtered_if_valid  (int_adp_filtered_if_valid)
     ); 
    end
   else begin : RX_DISABLE_AVST
     assign o_rx_data               = 'b0;
     assign o_rx_startofpacket      = 'b0;
     assign o_rx_endofpacket      = 'b0;
     assign o_rx_empty              = 'b0;
     assign o_rx_error              = 'b0;
     assign o_rxstatus_data         = 'b0;
     assign o_rx_valid              = 'b0;
     assign o_rxstatus_valid        = 'b0;
     assign rx_adapt_dropped_frames = 64'b0;
     assign o_rx_preamble 	    = 'b0;
   end // DISABLE_AVST
  endgenerate

  generate
    if (CLIENT_INT == 0) begin : RX_MAC_SEG   
       assign o_rx_mac_data           = int_bridge_rx_data;
       assign o_rx_mac_valid          = int_bridge_rx_valid;
       assign o_rx_mac_inframe        = int_bridge_rx_inframe;
       assign o_rx_mac_eop_empty      = int_bridge_rx_empty;
       assign o_rx_mac_fcs_error      = int_bridge_rx_fcs_error;
       assign o_rx_mac_error          = int_bridge_rx_error;
       assign o_rx_mac_status         = int_bridge_rx_status;
    end // RX_MAC_SEG
    else begin : RX_MAC_SEG_DISABLED
       assign o_rx_mac_data           = 'b0; 
       assign o_rx_mac_valid          = 'b0; 
       assign o_rx_mac_inframe        = 'b0; 
       assign o_rx_mac_eop_empty      = 'b0; 
       assign o_rx_mac_fcs_error      = 'b0; 
       assign o_rx_mac_error          = 'b0; 
       assign o_rx_mac_status         = 'b0; 
    end // RX_MAC_SEG_DISABLED

  endgenerate
  //----------------------------------------------------------------------
  //---------------------------- ADAPTER ---------------------------------
  //----------------------------------------------------------------------

  //----------------------------------------------------------------------
  //---------------------------- 40G BRIDGE ------------------------------
  //----------------------------------------------------------------------
 

  generate 
	 assign int_tx_data         = int_bridge_tx_data;      
         assign int_tx_valid        = int_bridge_tx_valid;      
         assign int_tx_inframe      = int_bridge_tx_inframe;   
         assign int_tx_empty        = int_bridge_tx_empty;     
         assign int_tx_error        = int_bridge_tx_error;      
         assign int_tx_skip_crc     = int_bridge_tx_skip_crc; 
         //assign int_bridge_tx_ready = int_tx_ready_sync; 
	 assign int_bridge_tx_ready = int_tx_ready_sync1;
         assign  int_bridge_rx_data      = int2_rx_data;
         assign  int_bridge_rx_valid     = int2_rx_valid;
         assign  int_bridge_rx_inframe   = int2_rx_inframe;
         assign  int_bridge_rx_empty     = int2_rx_empty;
         assign  int_bridge_rx_fcs_error = int2_rx_fcs_error;
         assign  int_bridge_rx_error     = int2_rx_error;
         assign  int_bridge_rx_status    = int2_rx_status;

         assign i2_tx_pcs66_valid         = i_tx_pcs66_valid;      
         assign i2_tx_pcs66_d             = i_tx_pcs66_d;      
         assign i2_tx_pcs66_am            = i_tx_pcs66_am;   
         assign o_rx_pcs66_valid        = o2_rx_pcs66_valid;     
         assign o_rx_pcs66_d            = o2_rx_pcs66_d;      
         assign o_rx_pcs66_am_valid     = o2_rx_pcs66_am_valid;    

  endgenerate
  //----------------------------------------------------------------------
  //---------------------------- BRIDGE ----------------------------------
  //----------------------------------------------------------------------
  //----------------------------------------------------------------------
  //---------------------------- PTP adapter -----------------------------
  //----------------------------------------------------------------------
  // PTP TX Adapter
  logic [PKT_CYL*(160+PTP_FP_WIDTH)-1:0] ptp_adapt_txi_data;
  logic [PKT_CYL*(160+PTP_FP_WIDTH)-1:0] ptp_adapt_txo_data;
  logic [PKT_CYL*1 -1:0]                 int_ptp_ins_ets;
  logic [PKT_CYL*1 -1:0]                 int_ptp_ins_cf;
  logic [PKT_CYL*1 -1:0]                 int_ptp_zero_csum;
  logic [PKT_CYL*1 -1:0]                 int_ptp_update_eb;
  logic [PKT_CYL*1 -1:0]                 int_ptp_p2p;
  logic [PKT_CYL*1 -1:0]                 int_ptp_asym;
  logic [PKT_CYL*1 -1:0]                 int_ptp_asym_sign;
  logic [PKT_CYL*7 -1:0]                 int_ptp_asym_p2p_idx;
  logic [PKT_CYL*1 -1:0]                 int_ptp_ts_format;
  logic [PKT_CYL*16-1:0]                 int_ptp_ts_offset;
  logic [PKT_CYL*16-1:0]                 int_ptp_cf_offset;
  logic [PKT_CYL*16-1:0]                 int_ptp_csum_offset;
  logic [PKT_CYL*96-1:0]                 int_ptp_tx_its;
  logic [PKT_CYL*1-1:0]                  int_ptp_ts_req;
  logic [PKT_CYL*PTP_FP_WIDTH-1:0]       int_ptp_fp;

  logic [PKT_CYL*(160+PTP_FP_WIDTH)-1:0] ptp_txi_data_pause;
  logic [PKT_CYL*(160+PTP_FP_WIDTH)-1:0] ptp_txo_data_pause;

  logic [AIB_LANES+(PKT_CYL*4)-1:0]      ptp_rxi_data_pause;
  logic [AIB_LANES+(PKT_CYL*4)-1:0]      ptp_rxo_data_pause;

  // PTP TX Packer for Segmented
  logic [PKT_CYL-1:0][(160+PTP_FP_WIDTH)-1:0] ptp_pack_txi_data;
  logic [PKT_CYL-1:0][(160+PTP_FP_WIDTH)-1:0] ptp_pack_txo_data;
  logic [PKT_CYL-1:0][(160+PTP_FP_WIDTH)-1:0] ptp_pack_txi_data_pause;
  logic [PKT_CYL-1:0][(160+PTP_FP_WIDTH)-1:0] ptp_pack_txo_data_pause;

  logic [AIB_LANES+(PKT_CYL*4)-1:0]           ptp_pack_rxi_data_pause;
  logic [AIB_LANES+(PKT_CYL*4)-1:0]           ptp_pack_rxo_data_pause;

  assign ptp_adapt_txi_data   = {i_ptp_ins_ets,
                                   i_ptp_ins_cf,
                                   i_ptp_zero_csum,
                                   i_ptp_update_eb,
                                   i_ptp_p2p,
                                   i_ptp_asym,
                                   i_ptp_asym_sign,
                                   i_ptp_asym_p2p_idx,
                                   i_ptp_ts_format,
                                   i_ptp_ts_offset,
                                   i_ptp_cf_offset,
                                   i_ptp_csum_offset,
                                   i_ptp_tx_its,
                                   i_ptp_ts_req,
                                   i_ptp_fp};
  
  generate
  if (ENABLE_PTP == 1 && CLIENT_INT == 0 && PACKING_EN == 1) begin : PTP_TX_SEG_PACK_OUT_GEN
        genvar i;
        for (i=0; i<PKT_CYL; i=i+1) begin: gen_ptp_packer_data
            assign {int_ptp_ins_ets       [i],
                    int_ptp_ins_cf        [i],
                    int_ptp_zero_csum     [i],
                    int_ptp_update_eb     [i],
                    int_ptp_p2p           [i],
                    int_ptp_asym          [i],
                    int_ptp_asym_sign     [i],
                    int_ptp_asym_p2p_idx  [(i*7)+:7],
                    int_ptp_ts_format     [i],
                    int_ptp_ts_offset     [(i*16)+:16],
                    int_ptp_cf_offset     [(i*16)+:16],
                    int_ptp_csum_offset   [(i*16)+:16],
                    int_ptp_tx_its        [(i*96)+:96],
                    int_ptp_ts_req        [i],
                    int_ptp_fp            [(i*PTP_FP_WIDTH)+:PTP_FP_WIDTH]} = ptp_pack_txo_data_pause[i];
                    
            assign ptp_pack_txi_data_pause[i]                               = ptp_pack_txo_data[i];
        end
    assign ptp_pack_rxi_data_pause           = {int_hi_rx_ptp_its, int_hi_rx_ptp_its_vl};
    assign {hi_rx_ptp_its, hi_rx_ptp_its_vl} = ptp_pack_rxo_data_pause[AIB_LANES+4-1:0];
  end else begin : PTP_TX_ADPT_PACK_OUT_GEN
    assign {int_ptp_ins_ets,
            int_ptp_ins_cf,
            int_ptp_zero_csum,
            int_ptp_update_eb,
            int_ptp_p2p,
            int_ptp_asym,
            int_ptp_asym_sign,
            int_ptp_asym_p2p_idx,
            int_ptp_ts_format,
            int_ptp_ts_offset,
            int_ptp_cf_offset,
            int_ptp_csum_offset,
            int_ptp_tx_its,
            int_ptp_ts_req,
            int_ptp_fp}             = ptp_txo_data_pause;
                
    assign ptp_txi_data_pause       = ptp_adapt_txo_data;

    assign ptp_rxi_data_pause                = {int_hi_rx_ptp_its, int_hi_rx_ptp_its_vl};
    assign {hi_rx_ptp_its, hi_rx_ptp_its_vl} = ptp_rxo_data_pause[AIB_LANES+4-1:0];
  end
endgenerate

  // PTP TX ETS Adapter
  logic [PKT_CYL*(1+96+5+PTP_FP_WIDTH)-1:0] ptp_adapt_txi_ets_data;
  logic [PKT_CYL*(1+96+5+PTP_FP_WIDTH)-1:0] ptp_adapt_txo_ets_data;

  wire [PKT_CYL-1:0]                    int_wo_tx_ptp_ets_valid;
  wire [PKT_CYL-1:0][95:0]              int_wo_tx_ptp_ets;
  wire [PKT_CYL-1:0][PTP_FP_WIDTH-1:0]  int_wo_tx_ptp_ets_fp;
  wire [PKT_CYL-1:0][4:0]               int_wo_tx_ptp_ets_vl;
  wire [PKT_CYL-1:0]                    wo_tx_ptp_ets_valid;
  wire [PKT_CYL-1:0][95:0]              wo_tx_ptp_ets;
  wire [PKT_CYL-1:0][PTP_FP_WIDTH-1:0]  wo_tx_ptp_ets_fp;
  wire [PKT_CYL-1:0][4:0]               wo_tx_ptp_ets_vl;

  assign ptp_adapt_txi_ets_data = {int_wo_tx_ptp_ets_valid,
                                    int_wo_tx_ptp_ets,
                                    int_wo_tx_ptp_ets_fp,
                                    int_wo_tx_ptp_ets_vl};

  assign {wo_tx_ptp_ets_valid,
          wo_tx_ptp_ets,
          wo_tx_ptp_ets_fp,
          wo_tx_ptp_ets_vl}      = ptp_adapt_txo_ets_data;

  generate
  if (ENABLE_PTP == 1 && CLIENT_INT == 1 && ENABLE_ASYNC_ADAPTERS == 0) begin : PTP_TX_ADPT_SYNC_GEN
    eth_f_ptp_adapter_tx #(
        .SIM      (0),
        .READY_LATENCY (READY_LATENCY),
        .WORDS    (AIB_LANES),
        .DWIDTH   (PKT_CYL*(160+PTP_FP_WIDTH))
    ) ptp_adapter_tx (
        .i_clk              (i_clk_tx),
        .i_reset            (~tx_lanes_stable_sync_clk_tx),
        .i_avst_tx_valid    (i_tx_valid),
        .i_avst_tx_ready    (o_tx_ready),
        .i_avst_tx_sop      (i_tx_startofpacket),
        .i_data             (ptp_adapt_txi_data),
        
        .i_seg_tx_valid     (int_tx_valid),
        .i_seg_tx_inframe   (int_tx_inframe),
        .o_data             (ptp_adapt_txo_data)
    );
    // Sync case, returned TX ETS can be sourced directly from soft PTP
    assign ptp_adapt_txo_ets_data = ptp_adapt_txi_ets_data;
  end
  else if (ENABLE_PTP == 1 && CLIENT_INT == 1 && ENABLE_ASYNC_ADAPTERS == 1) begin : PTP_TX_ADPT_ASYNC_GEN
    eth_f_ptp_adapter_tx_async #(
        .READY_LATENCY (READY_LATENCY),
        .WORDS    (AIB_LANES),
        .DWIDTH   (PKT_CYL*(160+PTP_FP_WIDTH))
    ) ptp_adapter_tx_async (
        .i_wrclk            (i_clk_tx),
        .i_avst_tx_valid    (i_tx_valid),
        .i_avst_tx_sop      (i_tx_startofpacket),
        .i_avst_tx_ready    (o_tx_ready),
        .i_data             (ptp_adapt_txi_data),
        
        .i_rdclk            (ptp_clk),
        .i_rdrst            (~tx_ptp_rst_n),
        .i_seg_tx_valid     (int_tx_valid),
        .i_seg_tx_inframe   (int_tx_inframe),
        .o_data             (ptp_adapt_txo_data)
    );

    // Convert TX ETS from ptp_clk to client's tx_clk
    eth_f_ptp_adapter_tx_ets_async #(
        .WORDS    (AIB_LANES),
        .DWIDTH   (PKT_CYL*(1+96+5+PTP_FP_WIDTH)) // valid + 96 bits TS + Virtual Lane + fingerprint width
    ) ptp_adapter_tx_ets_async (
        .i_wrclk            (ptp_clk),
        .i_wrrst            (~tx_ptp_rst_n),
        .i_valid            (|int_wo_tx_ptp_ets_valid),
        .i_data             (ptp_adapt_txi_ets_data),
        
        .i_rdclk            (i_clk_tx),
        .o_data             (ptp_adapt_txo_ets_data)
    );

  end
  else if (ENABLE_PTP == 1 && CLIENT_INT == 0 && PACKING_EN == 0) begin : PTP_TX_SEG_GEN
    // TX Seg packet is pipelined, align PTP to packet
    always @ (posedge ptp_clk) begin
        ptp_adapt_txo_data <= ptp_adapt_txi_data;
    end
    // returned TX ETS from soft PTP
    assign ptp_adapt_txo_ets_data = ptp_adapt_txi_ets_data;
  end
  else if (ENABLE_PTP == 1 && CLIENT_INT == 0 && PACKING_EN == 1) begin : PTP_TX_SEG_PACK_GEN
    // returned TX ETS from soft PTP
    assign ptp_adapt_txo_ets_data = ptp_adapt_txi_ets_data;
  end
  else begin : NO_TX_PTP_ADPT_GEN
    // PTP is not supported for CLIENT_INT > 1, will be synthesized away
    assign ptp_adapt_txo_data = ptp_adapt_txi_data;
    assign ptp_adapt_txo_ets_data = ptp_adapt_txi_ets_data;
  end
  endgenerate
  
  // PTP RX Adapter
  logic [PKT_CYL*(1+96+5)-1:0] ptp_adapt_rxi_data;
  logic [PKT_CYL*(1+96+5)-1:0] ptp_adapt_rxo_data;
  logic [PKT_CYL-1:0]          int2_ptp_rx_its_valid;
  logic [PKT_CYL*96-1:0]       int2_ptp_rx_its;
  logic [PKT_CYL*5-1:0]        int2_ptp_rx_its_vl;
  
  assign ptp_adapt_rxi_data = {int2_ptp_rx_its_valid, int2_ptp_rx_its_vl, int2_ptp_rx_its};
  assign {o_ptp_rx_its_valid,
          o_ptp_rx_its_vl,
          o_ptp_rx_its}  = (ENABLE_PTP == 1)? ptp_adapt_rxo_data : {(PKT_CYL*(1+96+5)){1'b0}};
  
  generate
  if (ENABLE_PTP == 1 && CLIENT_INT == 1) begin : PTP_RX_ADPT_GEN
    logic seg_clk, avst_clk;
    logic seg_rst, avst_rst;
    
    assign seg_clk  = ptp_clk; // int_clk_tx
    assign seg_rst  = ~rx_ptp_rst_n; // o_rx_pcs_ready
    assign avst_clk = i_clk_rx;
    assign avst_rst = ~rx_pcs_ready_sync_clk_rx;
  
    eth_f_ptp_adapter_rx #(
        .ENABLE_ASYNC_ADAPTERS  (ENABLE_ASYNC_ADAPTERS),
        .WORDS    (AIB_LANES),
        .DWIDTH   (PKT_CYL*(1+96+5))
    ) ptp_adapter_rx (
        // EHIP interface
        .i_seg_clk          (seg_clk),
        .i_seg_rst          (seg_rst),
        .i_seg_rx_valid     (int2_rx_valid),
        .i_seg_rx_inframe   (int2_rx_inframe),
        .i_data             (ptp_adapt_rxi_data),
        .i_seg_filtered_if        (int_adp_filtered_if),       // Wire from eth_f_adapter_rx
        .i_seg_filtered_if_valid  (int_adp_filtered_if_valid), // Wire from eth_f_adapter_rx
         // AVST interface
        .i_avst_clk         (avst_clk),
        .i_avst_rst         (avst_rst),
        .i_avst_rx_valid    (o_rx_valid),
        .i_avst_rx_sop      (o_rx_startofpacket),
        .o_data             (ptp_adapt_rxo_data)
    );
  end
  else begin : NO_RX_PTP_ADPT_GEN
    assign ptp_adapt_rxo_data = ptp_adapt_rxi_data;
  end
  endgenerate
  //----------------------------------------------------------------------
  //---------------------------- PTP adapter -----------------------------
  //----------------------------------------------------------------------      
 
  //----------------------------------------------------------------------
  //---------------------------- PTP TX packing --------------------------
  //----------------------------------------------------------------------
generate
    if (ENABLE_PTP == 1 && CLIENT_INT == 0 && PACKING_EN == 1) begin : PTP_TX_SEG_PACKER_GEN
        genvar i;
        for (i=0; i<PKT_CYL; i=i+1) begin: gen_ptp_packer_data
            assign ptp_pack_txi_data[i] = { i_ptp_ins_ets       [i],
                                            i_ptp_ins_cf        [i],
                                            i_ptp_zero_csum     [i],
                                            i_ptp_update_eb     [i],
                                            i_ptp_p2p           [i],
                                            i_ptp_asym          [i],
                                            i_ptp_asym_sign     [i],
                                            i_ptp_asym_p2p_idx  [(i*7)+:7],
                                            i_ptp_ts_format     [i],
                                            i_ptp_ts_offset     [(i*16)+:16],
                                            i_ptp_cf_offset     [(i*16)+:16],
                                            i_ptp_csum_offset   [(i*16)+:16],
                                            i_ptp_tx_its        [(i*96)+:96],
                                            i_ptp_ts_req        [i],
                                            i_ptp_fp            [(i*PTP_FP_WIDTH)+:PTP_FP_WIDTH]};
        end
        eth_f_ptp_packing_tx #(
            .SIM            (0),
            .WORDS          (AIB_LANES),
            .PKT_CYL        (PKT_CYL),
            .PTP_FP_WIDTH   (PTP_FP_WIDTH),
            .DWIDTH         (160+PTP_FP_WIDTH)
        ) ptp_packing_tx (
            .i_clk              (i_clk_tx),
            .i_reset            (~tx_lanes_stable_sync_clk_tx),
            .i_seg_tx_valid     (i_tx_mac_valid),
            .i_seg_tx_inframe   (i_tx_mac_inframe),
            .i_data             (ptp_pack_txi_data),
            
            .i_pack_tx_valid    (pack_tx_mac_valid),
            .i_pack_tx_inframe  (pack_tx_mac_inframe),
            .o_data             (ptp_pack_txo_data)
        );
    end else begin : NO_PTP_TX_SEG_PACKER_GEN
        assign ptp_pack_txi_data = {(PKT_CYL*160+PTP_FP_WIDTH){1'b0}};
        assign ptp_pack_txo_data = {(PKT_CYL*160+PTP_FP_WIDTH){1'b0}};
    end
endgenerate

 //----------------------------------------------------------------------
  //-----------------------------   PTP  ---------------------------------
  //----------------------------------------------------------------------
  localparam BCMSIM_EN = 0;

  // acknowledgement that sclk has been generated by soft PTP. This signal is always 1 when ENABLE PTP == 0
  wire                          sclk_sent_sync;

  genvar j;

generate if (ENABLE_PTP == 1) begin : PTP_SOFT_GEN
    // User Interface: 2d to 1d mapping
    wire [PKT_CYL-1:0]            wi_tx_ptp_ins_ets;
    wire [PKT_CYL-1:0]            wi_tx_ptp_ins_cf;
    wire [PKT_CYL-1:0]            wi_tx_ptp_ins_cs;
    wire [PKT_CYL-1:0]            wi_tx_ptp_ins_eb;
    wire [PKT_CYL-1:0]            wi_tx_ptp_ets_format;
    wire [PKT_CYL-1:0]            wi_tx_ptp_ins_p2p;
    wire [PKT_CYL-1:0]            wi_tx_ptp_ins_asm;
    wire [PKT_CYL-1:0]            wi_tx_ptp_asm_sign;
    wire [PKT_CYL-1:0][6:0]       wi_tx_ptp_asm_p2p_idx;
    wire [PKT_CYL-1:0][15:0]      wi_tx_ptp_offset_ts;
    wire [PKT_CYL-1:0][15:0]      wi_tx_ptp_offset_cf;
    wire [PKT_CYL-1:0][15:0]      wi_tx_ptp_offset_cs;
    wire [PKT_CYL-1:0][95:0]      wi_tx_ptp_rt_its;
    wire [PKT_CYL-1:0]            wi_tx_ptp_req_ets;
    wire [PKT_CYL-1:0][PTP_FP_WIDTH-1:0]       wi_tx_ptp_req_fp;
    wire [PKT_CYL-1:0]            wo_rx_ptp_its_valid;
    wire [PKT_CYL-1:0][95:0]      wo_rx_ptp_its;
    wire [PKT_CYL-1:0][4:0]       wo_rx_ptp_its_vl;
    // EHIP Interface: 2d to 1d mapping
    wire [AIB_LANES-1:0][2:0]     ho_tx_ptp_ins_type;
    wire [AIB_LANES-1:0][4:0]     ho_tx_ptp_ts;
    wire [AIB_LANES-1:0]          ho_tx_ptp_fp;
    wire [PKT_CYL-1:0]            hi_tx_ptp_ets_valid;
    wire [AIB_LANES-1:0][2:0]     hi_tx_ptp_ets;
    wire [AIB_LANES-1:0]          hi_tx_ptp_ets_fp;
    wire [PKT_CYL-1:0][3:0]       hi_tx_ptp_ets_vl;

    // reset signal for SCLK generation
    reg  [LANE_NUM-1:0][2:0]      rx_lane_current_state_sync_r1 = '0;
    reg  [LANE_NUM-1:0]           rx_lane_curr_state_110 = '0;
    reg  [LANE_NUM-1:0]           rx_lane_curr_state_110_r1 = '0;
    wire                          sclk_sent;

    reg                           rx_ptp_ready_tx_rst_gated;
    wire                          rx_ptp_ready_core;

  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (1),
      .INIT_VALUE         (0)
  ) sclk_sent_sync_inst (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (sclk_sent),
      .q                  (sclk_sent_sync)
  );

    // curr_state_110 indicates oflux_srds_rdy=1 for flux variant and cdrlock2data=1 for non-flux variant. 
    // All UX variants have flux enabled.
    always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
        // if (reconfig_reset_sync) begin
        //     rx_lane_current_state_sync_r1 <= {LANE_NUM*3{1'b0}};
        //     rx_lane_curr_state_110_r1 <= {LANE_NUM{1'b0}};
        // end else begin
            rx_lane_current_state_sync_r1 <= rx_lane_current_state_sync;
            rx_lane_curr_state_110_r1 <= rx_lane_curr_state_110;
        // end
    end

    for (j=0; j<LANE_NUM; j++) begin: CHK_RX_CUR_STATE
        always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
            // if (reconfig_reset_sync) begin
            //     rx_lane_curr_state_110[j] <= 1'b0;
            // end else begin
                rx_lane_curr_state_110[j] <= (rx_lane_current_state_sync_r1[j] == 3'b110);
            // end
        end
    end

    for (j=1; j<=PKT_CYL; j++) begin: USR_BUS
        // user interface
        assign wi_tx_ptp_ins_ets       [j-1]        = int_ptp_ins_ets     [j*1-1];
        assign wi_tx_ptp_ins_cf        [j-1]        = int_ptp_ins_cf      [j*1-1];
        assign wi_tx_ptp_ins_cs        [j-1]        = int_ptp_zero_csum   [j*1-1];
        assign wi_tx_ptp_ins_eb        [j-1]        = int_ptp_update_eb   [j*1-1];
        assign wi_tx_ptp_ins_p2p       [j-1]        = int_ptp_p2p         [j*1-1];
        assign wi_tx_ptp_ins_asm      [j-1]         = int_ptp_asym        [j*1-1];
        assign wi_tx_ptp_asm_sign     [j-1]         = int_ptp_asym_sign   [j*1-1];
        assign wi_tx_ptp_asm_p2p_idx  [j-1][6:0]    = int_ptp_asym_p2p_idx[j*7-1 -:7];
        assign wi_tx_ptp_ets_format    [j-1]        = int_ptp_ts_format   [j*1-1];
        assign wi_tx_ptp_offset_ts     [j-1][15:0]  = int_ptp_ts_offset   [j*16-1 -:16];
        assign wi_tx_ptp_offset_cf     [j-1][15:0]  = int_ptp_cf_offset   [j*16-1 -:16];
        assign wi_tx_ptp_offset_cs     [j-1][15:0]  = int_ptp_csum_offset [j*16-1 -:16];
        assign wi_tx_ptp_rt_its        [j-1][95:0]  = int_ptp_tx_its      [j*96-1 -:96];
        assign wi_tx_ptp_req_ets       [j-1]        = int_ptp_ts_req      [j*1-1];
        assign wi_tx_ptp_req_fp        [j-1][PTP_FP_WIDTH-1:0]  = int_ptp_fp          [j*PTP_FP_WIDTH-1 -:PTP_FP_WIDTH];
        assign o_ptp_ets_valid         [j*1-1]       = wo_tx_ptp_ets_valid[j-1];
        assign o_ptp_ets               [j*96-1 -:96] = wo_tx_ptp_ets      [j-1][95:0];
        assign o_ptp_ets_fp            [j*PTP_FP_WIDTH-1  -:PTP_FP_WIDTH]  = wo_tx_ptp_ets_fp   [j-1][PTP_FP_WIDTH-1:0];
        assign o_ptp_ets_vl            [j*5-1  -:5]  = wo_tx_ptp_ets_vl   [j-1][4:0];
        assign int2_ptp_rx_its_valid   [j*1-1]       = wo_rx_ptp_its_valid[j-1];
        assign int2_ptp_rx_its         [j*96-1 -:96] = wo_rx_ptp_its      [j-1][95:0];
        assign int2_ptp_rx_its_vl      [j*5-1 -:5]   = wo_rx_ptp_its_vl   [j-1][4:0];
        // ehip interface
        assign hi_tx_ptp_ets_valid     [j-1]         = ptp_rx_tx_ts_vld_aib_dsk [j*1-1];
        assign hi_tx_ptp_ets_vl        [j-1][3:0]    = ptp_tx_dbg_aib_dsk    [j*4-1 -:4];
        assign int_hi_rx_ptp_its_vl    [j-1][3:0]    = ptp_rx_dbg_aib_dsk    [j*4-1 -:4];
    end
    for (j=1; j<=AIB_LANES; j++) begin: HIP_BUS
        // ehip interface
        assign tx_ptp_ins_type         [j*3-1 -:3]   = ho_tx_ptp_ins_type [j-1][2:0];
        assign tx_ptp_ts               [j*5-1 -:5]   = ho_tx_ptp_ts       [j-1][4:0];
        assign tx_ptp_fp               [j*1-1]       = ho_tx_ptp_fp       [j-1];
        assign hi_tx_ptp_ets           [j-1][2:0]    = ptp_rx_data_aib_dsk  [(j-1)*5+2 -:3];
        assign hi_tx_ptp_ets_fp        [j-1]         = ptp_rx_data_aib_dsk  [(j-1)*5+3];
        assign int_hi_rx_ptp_its       [j-1]         = ptp_rx_data_aib_dsk  [(j-1)*5+4];
    end

    eth_f_ptp #(
        .APUL_MEAS          (PTP_ACC_MODE       ),
        .PL                 (LANE_NUM           ), 
        .WORDS              (AIB_LANES          ),
        .PKT_CYL            (PKT_CYL            ),
        .PTP_FP_WIDTH       (PTP_FP_WIDTH       ),
        .XCVR_TYPE          (XCVR_TYPE_SIP      ),
        .BCMSIM_EN          (BCMSIM_EN          ),
        .DEBUG              (ENABLE_PTP_DEBUG   )
    ) soft_ptp (
        // --- Configuration ---
        .i_cfg_speed                    (EHIP_RATE_CSR[2:0]),  // user to make different instance and mux
        .i_cfg_rsfec                    (RSFEC_TYPE[2:0]),     // MAC to support DRing
        .i_cfg_pl                       ({1'b0,LANE_NUM[3:0]}),// user to make different instance and mux
        .i_cfg_tx_pp                    (tx_ehip_preamble_passthru_dr),
        // --- Clock and Reset ---
        //.i_avmm_clk                     (i_avmm_clk),   
        .i_ptp_clk                      (ptp_clk            ),
        .i_tx_tod_clk                   (tx_tod_clk         ),
        .i_rx_tod_clk                   (rx_tod_clk         ),
        .i_ptp_sample_clk               (i_clk_ptp_sample   ),
        .i_tx_srst_n                    (tx_ptp_rst_n       ),
        .i_rx_srst_n                    (rx_ptp_rst_n       ),
        .i_tx_tod_srst_n                (tx_tod_rst_n       ),
        .i_rx_tod_srst_n                (rx_tod_rst_n       ),
        .i_tx_samp_srst_n               (tx_samp_rst_n      ),
        .i_rx_samp_srst_n               (rx_samp_rst_n      ),
        // --- CSR ---
        .o_tx_apulse_wdly_valid         (wo_tx_apulse_wdly_valid         ),
        .o_tx_apulse_offset_valid       (wo_tx_apulse_offset_valid       ),
        .o_tx_apulse_time_valid         (wo_tx_apulse_time_valid         ),
        .o_rx_apulse_wdly_valid         (wo_rx_apulse_wdly_valid         ),
        .o_rx_apulse_offset_valid       (wo_rx_apulse_offset_valid       ),
        .o_rx_apulse_time_valid         (wo_rx_apulse_time_valid         ),
        .o_tx_apulse_wdly               (wo_tx_apulse_wdly               ),
        .o_tx_apulse_offset             (wo_tx_apulse_offset             ),
        .o_tx_apulse_time               (wo_tx_apulse_time               ),
        .o_rx_apulse_wdly               (wo_rx_apulse_wdly               ),
        .o_rx_apulse_offset             (wo_rx_apulse_offset             ),
        .o_rx_apulse_time               (wo_rx_apulse_time               ),
        .i_tx_ref_lane                  (wi_tx_ref_lane                  ),
        .i_rx_lal                       (wi_rx_lal                       ),
        .o_tx_const_adjust              (wo_tx_const_adjust              ),
        .o_rx_const_adjust              (wo_rx_const_adjust              ),
        .i_tx_calc_adjust               (wi_tx_calc_adjust               ),
        .i_rx_calc_adjust               (wi_rx_calc_adjust               ),
        .i_tx_ptp_user_cfg_done         (wi_tx_ptp_user_cfg_done         ),
        .i_rx_ptp_user_cfg_done         (wi_rx_ptp_user_cfg_done         ),
        .o_tx_ptp_user_cfg_done_clrn    (wo_tx_ptp_user_cfg_done_clrn    ),
        .o_rx_ptp_user_cfg_done_clrn    (wo_rx_ptp_user_cfg_done_clrn    ),
        .i_rx_fec_cw_pos_user_cfg_done  (wi_rx_fec_cw_pos_user_cfg_done  ),
        .o_rx_ptp_vl_snapshot           (rx_ptp_vl_snapshot              ),
        .o_tx_tam_valid                 (wo_tx_tam_valid                 ),
        .o_tx_tam_cnt                   (wo_tx_tam_cnt                   ),
        .o_tx_tam_ui                    (wo_tx_tam_ui                    ),
        .o_rx_tam_valid                 (wo_rx_tam_valid                 ),
        .o_rx_tam_cnt                   (wo_rx_tam_cnt                   ),
        .o_rx_tam_ui                    (wo_rx_tam_ui                    ),
        // --- Data Path ---
        .i_tx_pkt_valid                 (int3_tx_valid   ),
        .i_tx_pkt_inframe               (int3_tx_inframe ),
        .i_tx_pkt_data                  (int3_tx_data    ),
        .i_tx_pkt_empty                 (int3_tx_empty   ),
        .i_tx_pkt_error                 (int3_tx_error   ),
        .i_tx_pkt_skip_crc              (int3_tx_skip_crc),
        .o_tx_pkt_valid                 (int4_tx_valid   ),
        .o_tx_pkt_inframe               (int4_tx_inframe ),
        .o_tx_pkt_data                  (int4_tx_data    ),
        .o_tx_pkt_empty                 (int4_tx_empty   ),
        .o_tx_pkt_error                 (int4_tx_error   ),
        .o_tx_pkt_skip_crc              (int4_tx_skip_crc),
        // --- Data Path ---
        .i_rx_pkt_valid                 (int_rx_valid    ),
        .i_rx_pkt_inframe               (int_rx_inframe  ),
        .i_rx_pkt_data                  (int_rx_data     ),
        .i_rx_pkt_empty                 (int_rx_empty    ),
        .i_rx_pkt_error                 (int_rx_error    ),
        .i_rx_pkt_fcs_error             (int_rx_fcs_error),
        .i_rx_pkt_status                (int_rx_status   ),
        .o_rx_pkt_valid                 (int2_rx_valid    ),
        .o_rx_pkt_inframe               (int2_rx_inframe  ),
        .o_rx_pkt_data                  (int2_rx_data     ),
        .o_rx_pkt_empty                 (int2_rx_empty    ),
        .o_rx_pkt_error                 (int2_rx_error    ),
        .o_rx_pkt_fcs_error             (int2_rx_fcs_error),
        .o_rx_pkt_status                (int2_rx_status   ),
        // --- TOD ---
        .i_tx_ptp_tod_valid             (i_ptp_tx_tod_valid),
        .i_tx_ptp_tod                   (i_ptp_tx_tod),
        .i_rx_ptp_tod_valid             (i_ptp_rx_tod_valid),
        .i_rx_ptp_tod                   (i_ptp_rx_tod),
        // --- 1-step Timestamp ---
        .i_tx_ptp_ins_ets               (wi_tx_ptp_ins_ets     ), // user interface
        .i_tx_ptp_ins_cf                (wi_tx_ptp_ins_cf      ), // user interface
        .i_tx_ptp_ins_cs                (wi_tx_ptp_ins_cs      ), // user interface
        .i_tx_ptp_ins_eb                (wi_tx_ptp_ins_eb      ), // user interface
        .i_tx_ptp_ets_format            (wi_tx_ptp_ets_format  ), // user interface
        .i_tx_ptp_ins_p2p               (wi_tx_ptp_ins_p2p     ), // user interface
        .i_tx_ptp_ins_asm               (wi_tx_ptp_ins_asm     ), // user interface
        .i_tx_ptp_asm_sign              (wi_tx_ptp_asm_sign    ), // user interface
        .i_tx_ptp_asm_p2p_idx           (wi_tx_ptp_asm_p2p_idx ), // user interface
        .i_tx_ptp_offset_ts             (wi_tx_ptp_offset_ts   ), // user interface
        .i_tx_ptp_offset_cf             (wi_tx_ptp_offset_cf   ), // user interface
        .i_tx_ptp_offset_cs             (wi_tx_ptp_offset_cs   ), // user interface
        .i_tx_ptp_rt_its                (wi_tx_ptp_rt_its      ), // user interface
        .i_tx_ptp_req_ets               (wi_tx_ptp_req_ets     ), // user interface
        .i_tx_ptp_req_fp                (wi_tx_ptp_req_fp      ), // user interface
        .o_tx_ptp_ins_type              (ho_tx_ptp_ins_type    ), // to hip via ptp mapping
        .o_tx_ptp_ts                    (ho_tx_ptp_ts          ), // to hip via ptp mapping
        .o_tx_ptp_fp                    (ho_tx_ptp_fp          ), // to hip via ptp mapping
        // --- 2-step Timestamp ---
        .i_tx_ptp_ets_valid             (hi_tx_ptp_ets_valid   ), // from hip via ptp mapping
        .i_tx_ptp_ets                   (hi_tx_ptp_ets         ), // from hip via ptp mapping
        .i_tx_ptp_ets_fp                (hi_tx_ptp_ets_fp      ), // from hip via ptp mapping
        .i_tx_ptp_ets_vl                (hi_tx_ptp_ets_vl      ), // from hip via ptp mapping
        .o_tx_ptp_ets_valid             (int_wo_tx_ptp_ets_valid), // user interface
        .o_tx_ptp_ets                   (int_wo_tx_ptp_ets      ), // user interface
        .o_tx_ptp_ets_fp                (int_wo_tx_ptp_ets_fp   ), // user interface
        .o_tx_ptp_ets_vl                (int_wo_tx_ptp_ets_vl   ), // user interface
        // --- RX Timestamp ---
        .i_rx_ptp_its_vl                (hi_rx_ptp_its_vl      ), // from hip - ptp mapping
        .i_rx_ptp_its                   (hi_rx_ptp_its         ), // from hip - ptp mapping
        .o_rx_ptp_its                   (wo_rx_ptp_its         ), // user interface
        .o_rx_ptp_its_vl                (wo_rx_ptp_its_vl      ), // user interface
        .o_rx_ptp_its_valid             (wo_rx_ptp_its_valid   ), // user interface
        // --- Reference Time ---
        .o_tx_ptp_async_cal_sel         (o_tx_ptp_async_cal_sel), // to hip - ptp mapping
        .o_rx_ptp_async_cal_sel         (o_rx_ptp_async_cal_sel), // to hip - ptp mapping
        .o_ptp_async_cal_pulse          (o_ptp_async_cal_pulse ), // to hip - ptp mapping
        .i_tx_ptp_async_pulse           (i_tx_ptp_async_pulse  ), // from hip - ptp mapping
        .i_rx_ptp_async_pulse           (i_rx_ptp_async_pulse  ), // from hip - ptp mapping
        .i_tx_ptp_sync_am               (hi_tx_ptp_sync_am     ), // from hip - ptp mapping
        .i_rx_ptp_sync_am               (hi_rx_ptp_sync_am     ), // from hip - ptp mapping
        // Status
        .i_stat_rxpll_lock              (rx_lane_curr_state_110_r1),
        .i_rx_rst_ack_n                 (r_rx_rst_ack_n),
        .o_sclk_sent                    (sclk_sent),
        .o_tx_ptp_offset_data_valid     (o_tx_ptp_offset_data_valid),   // user interface
        .o_rx_ptp_offset_data_valid     (o_rx_ptp_offset_data_valid),   // user interface
        .o_tx_ptp_ready                 (o_tx_ptp_ready),   // user interface
        .o_rx_ptp_ready                 (rx_ptp_ready_core) // user interface
    );

    always @(posedge int_clk_tx) begin
        if (tx_dp_rst_sync) begin
          rx_ptp_ready_tx_rst_gated  <= 1'b0;
        end else begin
          rx_ptp_ready_tx_rst_gated  <= rx_ptp_ready_core;
        end
    end
    assign o_rx_ptp_ready  = rx_ptp_ready_tx_rst_gated;

end
else begin : NO_PTP_SOFT_GEN
    // data path by pass PTP
    assign int2_tx_valid     = int_tx_valid    ;
    assign int2_tx_inframe   = int_tx_inframe  ;
    assign int2_tx_data      = int_tx_data     ;
    assign int2_tx_empty     = int_tx_empty    ;
    assign int2_tx_error     = int_tx_error    ;
    assign int2_tx_skip_crc  = int_tx_skip_crc ;
    assign int2_rx_valid     = int_rx_valid    ;
    assign int2_rx_inframe   = int_rx_inframe  ;
    assign int2_rx_data      = int_rx_data     ;
    assign int2_rx_empty     = int_rx_empty    ;
    assign int2_rx_error     = int_rx_error    ;
    assign int2_rx_fcs_error = int_rx_fcs_error;
    assign int2_rx_status    = int_rx_status   ;

    assign wo_tx_ptp_user_cfg_done_clrn = 1'b0;
    assign wo_rx_ptp_user_cfg_done_clrn = 1'b0;
    assign wo_tx_apulse_wdly_valid      = 1'b0;
    assign wo_tx_apulse_offset_valid    = 1'b0;
    assign wo_tx_apulse_time_valid      = 1'b0;
    assign wo_rx_apulse_wdly_valid      = 1'b0;
    assign wo_rx_apulse_offset_valid    = 1'b0;
    assign wo_rx_apulse_time_valid      = 1'b0;
    assign wo_tx_apulse_wdly            = {LANE_NUM{20'h0}};
    assign wo_tx_apulse_offset          = {LANE_NUM{32'h0}};
    assign wo_tx_apulse_time            = {LANE_NUM{28'h0}};
    assign wo_rx_apulse_wdly            = {LANE_NUM{20'h0}};
    assign wo_rx_apulse_offset          = {LANE_NUM{32'h0}};
    assign wo_rx_apulse_time            = {LANE_NUM{28'h0}};
    assign wo_tx_const_adjust           = 32'h0;
    assign wo_rx_const_adjust           = 32'h0;
    assign wo_tx_tam_valid              = 1'b0;
    assign wo_tx_tam_cnt                = 16'h0;
    assign wo_tx_tam_ui                 = 48'h0;
    assign wo_rx_tam_valid              = 1'b0;
    assign wo_rx_tam_cnt                = 16'h0;
    assign wo_rx_tam_ui                 = 48'h0;

    assign int2_ptp_rx_its_valid        = {PKT_CYL{1'b0}};
    assign int2_ptp_rx_its              = {PKT_CYL{96'h0}};
    assign int2_ptp_rx_its_vl           = {PKT_CYL{5'h0}};

    assign int_wo_tx_ptp_ets_valid      = {PKT_CYL{1'b0}};
    assign int_wo_tx_ptp_ets            = {PKT_CYL{96'h0}};
    assign int_wo_tx_ptp_ets_fp         = {PKT_CYL*PTP_FP_WIDTH{1'b0}};
    assign int_wo_tx_ptp_ets_vl         = {PKT_CYL{5'h0}};
    
    assign o_ptp_ets_valid              = {PKT_CYL{1'b0}};
    assign o_ptp_ets                    = {PKT_CYL{96'h0}};
    assign o_ptp_ets_fp                 = {PKT_CYL*PTP_FP_WIDTH{1'b0}};
    assign o_ptp_ets_vl                 = {PKT_CYL{5'h0}};

    assign o_tx_ptp_async_cal_sel       = {LANE_NUM{1'b0}};
    assign o_rx_ptp_async_cal_sel       = {LANE_NUM{1'b0}};
    assign o_ptp_async_cal_pulse        = {LANE_NUM{1'b0}};

    assign sclk_sent_sync               = 1'b1;
    assign o_tx_ptp_offset_data_valid   = 1'b0;
    assign o_rx_ptp_offset_data_valid   = 1'b0;
    assign o_tx_ptp_ready               = 1'b0;
    assign o_rx_ptp_ready               = 1'b0;

    assign int_hi_rx_ptp_its            = {AIB_LANES{1'b0}};
    assign int_hi_rx_ptp_its_vl         = {PKT_CYL{4'h0}};
end
endgenerate
  
  //----------------------------------------------------------------------
  //-----------------------------   PTP  ---------------------------------
  //----------------------------------------------------------------------
  
  //----------------------------------------------------------------------
  //----------------------------- TileIP ---------------------------------
  //----------------------------------------------------------------------
  // ssr and fsr for 25G  
  wire       ssr_rx_pause;
  wire [7:0] ssr_rx_pfc;
wire                      int_rx_pause;
  

  //  input -> ssr_in_to_aib
  //  output -> ssr_out_from_aib
  
  //----------------------------------------------------------------------
  //----------------------------- TileIP ---------------------------------
  //----------------------------------------------------------------------


generate
if (CLIENT_INT < 2 ) begin: GEN_PAUSE 

if (EHIP_RATE_CSR[2:0] == 6) begin

assign  int_rx_inframe      =   int_rx_inframe_fc;
assign  int_rx_valid            = int_rx_valid_fc;
assign  int_rx_status             = int_rx_status_fc;
assign  int_rx_fcs_error          = int_rx_fcs_error_fc;
assign  int_rx_data         =int_rx_data_fc;
assign  int_rx_empty = int_rx_empty_fc;
assign   int_rx_error = int_rx_error_fc;

assign   int_tx_ready_sync1 = int_tx_ready_sync;
assign    int3_tx_skip_crc  = int2_tx_skip_crc;
assign    int3_tx_valid  = int2_tx_valid;
assign    int3_tx_empty   = int2_tx_empty;
assign    int3_tx_error    = int2_tx_error;
assign   int3_tx_inframe  =  int2_tx_inframe;
assign    int3_tx_data = int2_tx_data;
assign    o_rx_pause = (EHIP_RATE == "25G" || EHIP_RATE == "10G") ? ssr_rx_pause : int_rx_pause;

assign tx_pause_da_mismatch_cnt_in  = 64'd0;
assign tx_pause_da_mismatch_cnt_out = 64'd0;
assign tx_pause_da_match_cnt_in     = 64'd0;
assign tx_pause_da_match_cnt_out    = 64'd0;	



end else
begin

  (* dont_touch = "yes" *)  wire [15:0]SFC_quanta;
  (* dont_touch = "yes" *) wire SFC_valid ;
    logic                             qvalid_sync;
    logic    [15:0]              	  quanta_sync;

  
   eth_f_pause #(
      .DWIDTH        (DWIDTH_MAC),
      .NUM_SEG   (DATA_WIDTH),
      .AIB_LANES (AIB_LANES), 
      .EHIP_RATE (EHIP_RATE_CSR[2:0] ),  
      .SIM_EMULATE    (SIM_EMULATE)
  ) tx_pause_fifo (
  
      //Inputs
.i_clk				(int_clk_tx),
.i_reset				(~o_tx_lanes_stable),
.enable_sfc			(en_sfc),
.i_data				(int2_tx_data),
.i_inframe			(int2_tx_inframe),
.i_error				(int2_tx_error),
.i_empty				(int2_tx_empty),
.i_valid				(int2_tx_valid),
.i_skip_crc			(int2_tx_skip_crc),
.o_ready_sip		(int_tx_ready_sync1),
.i_qvalid			(qvalid_sync),
.i_quanta			(quanta_sync),
.o_rx_pause			(o_rx_pause),
.tx_flow_control	(tx_flow_control), //YES - 1, NO - 0
.o_data				(int3_tx_data),
.o_inframe			(int3_tx_inframe),
.o_error				(int3_tx_error),
.o_empty				(int3_tx_empty),
.o_valid				(int3_tx_valid),
.o_skip_crc			(int3_tx_skip_crc),
.i_ready				(int_tx_ready_sync)

 );

  eth_f_multibit_sync #(
     .WIDTH (16)
 ) quantasync (
     .clk     (int_clk_tx),
     .reset_n (1'b1),
     .din     (SFC_quanta),
     .dout    (quanta_sync)
 );

eth_f_xcvr_resync_std #(
          .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0) 
      ) sync_iqvalid (
          .clk    (int_clk_tx),
          .reset  (1'b0),
          .d  (SFC_valid),
          .q  (qvalid_sync)
      );


  logic [AIB_LANES-1:0]        int_rx_inframe_fc_r = '0;
  logic [AIB_LANES-1:0][63:0]  int_rx_data_fc_r = '0;
  logic                        int_rx_valid_fc_r = '0;
  logic [AIB_LANES-1:0][2:0]   int_rx_empty_fc_r = '0;
  logic [AIB_LANES-1:0][1:0]   int_rx_error_fc_r = '0;
  logic [AIB_LANES-1:0]        int_rx_fcs_error_fc_r = '0;
  logic [AIB_LANES-1:0][2:0]   int_rx_status_fc_r = '0;

always @(posedge int_clk_rx) //All registers are initialized to 0.
begin
	if (~o_rx_pcs_ready)begin
		int_rx_inframe_fc_r					<= 'h0;
		int_rx_data_fc_r					<= 'h0;
                int_rx_valid_fc_r                                       <= 'h0;
		int_rx_empty_fc_r                                       <= 'h0;
		int_rx_error_fc_r                                       <= 'h0;
  		int_rx_fcs_error_fc_r                                   <= 'h0;
		int_rx_status_fc_r                                       <= 'h0;
	end
	else begin
		int_rx_inframe_fc_r					<= int_rx_inframe_fc; 
		int_rx_data_fc_r					<= int_rx_data_fc;
		int_rx_valid_fc_r                                       <= int_rx_valid_fc;
		int_rx_empty_fc_r                                       <= int_rx_empty_fc;
		int_rx_error_fc_r                                       <= int_rx_error_fc;
  		int_rx_fcs_error_fc_r                                   <= int_rx_fcs_error_fc;
		int_rx_status_fc_r                                       <= int_rx_status_fc;
	end
end

	eth_f_rx_pause	# (
          .AIB_LANES  (AIB_LANES)     
 
	) rx_pause_dut ( 
	    
   //     .clk_i                    ( int_clk_rx ),        
     //  .srst_n_i                  (o_rx_pcs_ready),

       .clk_i                     ( int_clk_rx ),        
       .srst_n_i                  (o_rx_pcs_ready),
       .rx_mac_inframe            (int_rx_inframe_fc_r),
       .rx_mac_valid              (int_rx_valid_fc_r),
       .rx_mac_status             (int_rx_status_fc_r),
       .rx_mac_fcs_error          (int_rx_fcs_error_fc_r),  
       .rx_data_in                (int_rx_data_fc_r),
       .rx_mac_empty              (int_rx_empty_fc_r),
       .rx_mac_error              (int_rx_error_fc_r),
       .forward_user_rx_pause     (forward_user_rxpause),
       .mac_rxpause_daddr         (mac_rxpause_daddr), 
       .preamble_enable           (rx_en_pp),      
       .o_rx_mac_inframe          (int_rx_inframe),
       .o_rx_mac_valid            (int_rx_valid),
       .o_rx_mac_status           (int_rx_status),
       .o_rx_mac_fcs_error        (int_rx_fcs_error),  
       .o_rx_data_out             (int_rx_data),
       .o_rx_mac_empty            (int_rx_empty),
       .o_rx_mac_error            (int_rx_error),      
       
       .SFC_quanta                (SFC_quanta),
       .SFC_valid                 (SFC_valid)
); 

    assign tx_pause_da_mismatch_cnt_in  = 64'd0;
    assign tx_pause_da_mismatch_cnt_out = 64'd0;
    assign tx_pause_da_match_cnt_in     = 64'd0;
    assign tx_pause_da_match_cnt_out    = 64'd0;	
   
        
        
end
end
else
begin
assign  int_rx_inframe      =   int_rx_inframe_fc;
assign  int_rx_valid            = int_rx_valid_fc;
assign  int_rx_status             = int_rx_status_fc;
assign  int_rx_fcs_error          = int_rx_fcs_error_fc;
assign  int_rx_data         =int_rx_data_fc;
assign  int_rx_empty = int_rx_empty_fc;
assign   int_rx_error = int_rx_error_fc;

assign   int_tx_ready_sync1 = int_tx_ready_sync;
assign    int3_tx_skip_crc  = int2_tx_skip_crc;
assign    int3_tx_valid  = int2_tx_valid;
assign    int3_tx_empty   = int2_tx_empty;
assign    int3_tx_error    = int2_tx_error;
assign   int3_tx_inframe  =  int2_tx_inframe;
assign    int3_tx_data = int2_tx_data;
assign    o_rx_pause = (EHIP_RATE == "25G" || EHIP_RATE == "10G") ? ssr_rx_pause : int_rx_pause;

assign tx_pause_da_mismatch_cnt_in  = 64'd0;
assign tx_pause_da_mismatch_cnt_out = 64'd0;
assign tx_pause_da_match_cnt_in     = 64'd0;
assign tx_pause_da_match_cnt_out    = 64'd0;	
					 
end


endgenerate  


  //----------------------------------------------------------------------
  //------------------------ Datapath Mapping ----------------------------
  //----------------------------------------------------------------------
  
  assign  int4_tx_data      = int3_tx_data;
  assign  int4_tx_error     = int3_tx_error;
  assign  int4_tx_empty     = int3_tx_empty;
  assign  int4_tx_skip_crc  = int3_tx_skip_crc;
  assign  int4_tx_valid     = int3_tx_valid;
  assign  int4_tx_inframe   = int3_tx_inframe;
  
  if (PACKING_EN == 0) begin: ASSIGN_PTP_PAUSE_CMD
    assign ptp_txo_data_pause = ptp_txi_data_pause;
    assign ptp_rxo_data_pause = ptp_rxi_data_pause;
  end else begin: ASSIGN_PTP_PACK_PAUSE_CMD
    assign ptp_pack_txo_data_pause = ptp_pack_txi_data_pause;
    assign ptp_pack_rxo_data_pause = ptp_pack_rxi_data_pause;
  end

  wire [7:0]                int_rx_pfc;
  //RX word align good
  wire                      o_rx_word_align_good;

  eth_f_dp_mapping_tx #(
      .LANES        (AIB_LANES),
      .CLIENT_INT   (CLIENT_INT),     
      .DATA_RATE    (EHIP_RATE)
  ) tx_dp_mapping (
  
      //MAC Inputs
     	.i_stats_snapshot     (o_stats_snapshot_sync),
      .i_custom_cadence     (custom_cadence),
      .i_tx_aib_dsk         (int_tx_aib_dsk),
      .i_tx_data            (int4_tx_data),
      .i_tx_error           (int4_tx_error),
      .i_tx_empty           (int4_tx_empty),
      .i_tx_skip_crc        (int4_tx_skip_crc),
      .i_tx_valid           (int4_tx_valid),
      .i_tx_inframe         (int4_tx_inframe),		
      .i_tx_pause           (i_tx_pause),
      .i_tx_pfc             (i_tx_pfc),
       
      //PCS inputs
      .i_tx_mii_c           (i_tx_mii_c    ),
      .i_tx_mii_d           (i_tx_mii_d    ),
      .i_tx_mii_valid       (i_tx_mii_valid),
      .i_tx_mii_am          (i_tx_mii_am   ),

      // PCS66 inputs
      .i_tx_pcs66_d         (i2_tx_pcs66_d    ),
      .i_tx_pcs66_valid     (i2_tx_pcs66_valid),
      .i_tx_pcs66_am        (i2_tx_pcs66_am   ),

      //Output
      .o_tx_parallel_data   (tx_parallel_data)
  );
  
  eth_f_dp_mapping_rx #(
      .LANES        (AIB_LANES),
      .DATA_RATE    (EHIP_RATE)
  ) rx_dp_mapping (
  
      //From TileIP
      .i_rx_parallel_data       (rx_parallel_data),
  
      //Deskew Interface
      .o_rx_data_to_dsk         (rx_deskew_din),
      .o_rx_aib_dsk             (rx_aib_dsk),
      .i_rx_data_dsk_done       (rx_deskew_dout),
  
      //MAC Interface
      .o_tx_ready               (int_tx_ready),
      .o_rx_data                (int_rx_data_fc),
      .o_rx_empty               (int_rx_empty_fc),
      .o_rx_fcs_error           (int_rx_fcs_error_fc),
      .o_rx_error               (int_rx_error_fc),
      .o_rx_status              (int_rx_status_fc),
      .o_rx_inframe             (int_rx_inframe_fc),
      .o_rx_valid               (int_rx_valid_fc),
      .o_rx_pause               (int_rx_pause),
      .o_rx_pfc                 (int_rx_pfc),

  
      //PCS inputs
      .o_rx_mii_c               (o_rx_mii_c       ), 
      .o_rx_mii_d               (o_rx_mii_d       ), 
      .o_rx_mii_valid           (o_rx_mii_valid   ),
      .o_rx_mii_am_valid        (o_rx_mii_am_valid),
      .o_tx_mii_ready           (                 ),

      // Word align good
      .o_rx_word_align_good     (o_rx_word_align_good),
      // PCS66 inputs
      .o_rx_pcs66_d             (o2_rx_pcs66_d       ),
      .o_rx_pcs66_valid         (o2_rx_pcs66_valid   ),
      .o_rx_pcs66_am_valid      (o2_rx_pcs66_am_valid),
      .o_tx_pcs66_ready         (   )

  );

   


// mac seg and mac avst
// generate custom_cadence for all NRZ variants with None/FC/KR-FEC and SYSPLL=830M
 

                assign custom_cadence = 1'b0;


// pcs, otn, flexe
// generate custom_cadence based on rate/syspll settings & forward ready to user
// for custome pll, user supplies cadence thru i_custom_cadence
	assign o_tx_mii_ready = 1'b0;
	assign o_tx_pcs66_ready = 1'b0;


  
  assign o_rx_pfc = (EHIP_RATE == "25G" || EHIP_RATE == "10G") ? ssr_rx_pfc : int_rx_pfc;
  //----------------------------------------------------------------------
  //------------------------ Datapath Mapping ----------------------------
  //----------------------------------------------------------------------
  
  //----------------------------------------------------------------------
  //---------------------------- SSR / FSR -------------------------------
  //----------------------------------------------------------------------
  // EHIP
  // TODO: No o_rst_n signal ? i_rx_reset_n i_tx_reset_n and i_rst_n?
  
  assign i_ehip_clear_internal_err = 1'b0;
  assign i_ehip_pld_ready = 1'b0;

  wire o_pcs_rx_sf_sync;
  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (1),
      .INIT_VALUE         (0)
  ) pcs_rx_sf_sync_inst (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (o_pcs_rx_sf),
      .q                  (o_pcs_rx_sf_sync)
  );
  //-----------------------------------------------------------------------
  //------- sip_ehip_signal_ok implementation pass from SIP to SRC-----------
  //-----------------------------------------------------------------------

  reg [LANE_NUM-1:0] sip_ehip_signal_ok_r = '0;

  assign sip_ehip_signal_ok = sip_ehip_signal_ok_r;
      genvar l;
      generate 
        for(l=0;l<LANE_NUM;l=l+1) begin: EHIP_SIGNAL_FEC
          always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
            //if (reconfig_reset_sync) begin
            //  sip_ehip_signal_ok_r[l] <= 1'b0;
            //end else begin
              sip_ehip_signal_ok_r[l] <= rx_lane_current_state_sync[l][1] & ~o_pcs_rx_sf_sync & sclk_sent_sync;
            //end
          end
        end
      endgenerate 


 
  eth_f_aib_mapping #(
      .EHIP_BLOCK               (0),  // 0 for E400G , 1 for E200G
      .LANES                    (AIB_LANES) 
  ) ehip_aib (
      .i_pld_ready              (i_ehip_pld_ready),
      .i_clear_internal         (i_ehip_clear_internal_err), // TODO
      .i_tx_pause               (i_tx_pause),
      .i_tx_pfc                 (i_tx_pfc),
      .o_link_in_to_aib         (hdpldadapt_in_link),
      .o_fec_not_locked         (o_fec_not_locked_aib),
      .o_fec_not_align          (o_fec_not_align_aib),
      .o_pcs_rx_sf              (o_pcs_rx_sf),  
  
      .o_rx_rst_n               ( ), 
      .o_tx_rst_n               ( ), 
      .o_rx_block_lock          (o_rx_block_lock_aib),
      .o_rx_dsk_done            (ehip_rx_dsk_done), // TODO: connect to the right signal
      .o_rx_am_lock             (o_rx_am_lock_aib),
      .o_rx_pcs_fully_aligned   (o_rx_pcs_fully_aligned_aib),
      .o_hi_ber                 (o_rx_hi_ber),
      .o_rx_pcs_internal_err    (o_rx_pcs_internal_err), //TODO signal not used
      .o_local_fault            (local_fault_status_hip), // TODO: connect to the right signal
      .o_remote_fault           (o_remote_fault_status),
      .o_rx_pause               (ssr_rx_pause),  
      .o_rx_pfc                 (ssr_rx_pfc),
      .i_link_out_from_aib      (hdpldadapt_out_link[0]),
      .o_clk_pll                (o_clk_pll),      
      .o_clk_tx_div             (o_clk_tx_div),    
      .o_clk_rec_div64          (o_clk_rec_div64),
      .o_clk_rec_div            (o_clk_rec_div)
//      .o_txfifo_pfull           (), //TODO: Used only when 200G block is used 
  );
  
 
  //----------------------------------------------------------------------
  //---------------------------- SSR / FSR -------------------------------
  //----------------------------------------------------------------------
  

  //----------------------------------------------------------------------
  //--------------------------- Reset Logic ------------------------------
  //----------------------------------------------------------------------  

  eth_f_reset_logic #(
      .NUM_CHANNELS      (4),
      .SIM_EMULATE       (SIM_EMULATE)
  ) reset_logic (
     // User hard Reset signals
    .i_rst               (~i_rst_n), 
    .i_tx_rst            (~i_tx_rst_n),     
    .i_rx_rst            (~i_rx_rst_n),     
    
    .i_soft_tx_rst       (soft_tx_rst), //TODO
    .i_soft_rx_rst       (soft_rx_rst), //TODO
    .i_soft_sys_rst      (eio_sys_rst), //TODO

    .o_tx_dp_rst         (tx_dp_rst), // Reset TX datapath 
    .o_rx_dp_rst         (rx_dp_rst) // Reset RX datapath    
  );



  //----------------------------------------------------------------------
  //--------------------------- Deskew Reset Logic -----------------------
  //----------------------------------------------------------------------
logic rx_dp_rst_reconfig_sync;
logic tx_dp_rst_reconfig_sync;
 
     always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
		ehip_rx_rst_ack_n <= ~rx_dp_rst_reconfig_sync & rx_lane_current_state_sync[LANE_NUM-1][1];
		ehip_tx_rst_ack_n <= ~tx_dp_rst_reconfig_sync & tx_lane_current_state_sync[LANE_NUM-1][2];
	  end
  
  //----------------------------------------------------------------------
  //---------------------------- SRC Resets ------------------------------
  //----------------------------------------------------------------------
    wire [LANE_NUM-1:0] tx_rst_ack_n;
    wire [LANE_NUM-1:0] rx_rst_ack_n;
    wire [LANE_NUM-1:0] tx_operational;
    wire [LANE_NUM-1:0] rx_operational;
    wire [LANE_NUM-1:0] tx_sys_clk_stable;
    wire [LANE_NUM-1:0] rx_sys_clk_stable;

    wire  f_tx_rst_ack_n;
    wire  f_rx_rst_ack_n;
    wire [LANE_NUM-1:0]  f_tx_operational;
    wire [LANE_NUM-1:0]  f_rx_operational;
    wire [LANE_NUM-1:0]  tx_operational_reconfig;
    wire [LANE_NUM-1:0]  rx_operational_reconfig;
    reg [LANE_NUM-1:0] rx_lane_desired_state_reg = '0;
    reg [LANE_NUM-1:0] tx_lane_desired_state_reg = '0;
    reg [LANE_NUM-1:0] sip_freeze_tx_src_reg = '0;
    reg [LANE_NUM-1:0] sip_freeze_rx_src_reg = '0;
    logic rx_dp_rst_s = '0 ,tx_dp_rst_s = '0;
    (* preserve_syn_only *) logic rf_in_progress_edge;
    (* preserve_syn_only *) logic rf_in_progress_reg;
	
	wire [0:0][KR_CTRL_WIDTH-1:0] kr_ctrl_rsync;

eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (KR_CTRL_WIDTH),
      .INIT_VALUE         (0)
  ) kr_ctrl_sync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (kr_ctrl[0]),
      .q                  ({kr_ctrl_rsync})
  );
  
eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (2),
      .INIT_VALUE         (0)
  ) tx_dp_rst_rclk_sync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  ({rx_dp_rst_s,tx_dp_rst_s}),
      .q                  ({rx_dp_rst_reconfig_sync,tx_dp_rst_reconfig_sync})
  );
  

genvar i;
  generate

     for (i=0; i<LANE_NUM; i=i+1) begin: AUTO_SRC_BUS
       always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
		   tx_lane_desired_state_reg[i] <= kr_mode_sync ? kr_ctrl_rsync[0][0] : tx_dp_rst;
	       rx_lane_desired_state_reg[i] <= kr_mode_sync ? kr_ctrl_rsync[0][0] : rx_dp_rst;
	end



     always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
          sip_freeze_tx_src_reg[i] <= kr_mode ? kr_ctrl[0][3] : '0;
          sip_freeze_rx_src_reg[i] <= kr_mode ? kr_ctrl[0][3] : '0;
     end

    // taking bit-0 for acks as per SRC HAS
    assign tx_rst_ack_n[i] =  ~tx_lane_current_state_sync[i][0];
    assign rx_rst_ack_n[i] =  ~rx_lane_current_state_sync[i][0]; 

    // taking bit-1 for operational state (Full out of reset)
    assign tx_operational[i] = tx_lane_current_state[i][1];
    assign rx_operational[i] = rx_lane_current_state[i][1];

    // taking bit-2 for sysclk_stable as per SRC HAS
    assign tx_sys_clk_stable[i] =  tx_lane_current_state[i][2];
    assign rx_sys_clk_stable[i] =  rx_lane_current_state[i][2];

  
  end

endgenerate

  assign sip_freeze_tx_src = sip_freeze_tx_src_reg;
  assign sip_freeze_rx_src = sip_freeze_rx_src_reg;

  assign tx_lane_desired_state = tx_lane_desired_state_reg;
  assign rx_lane_desired_state = rx_lane_desired_state_reg;

// anding respective rst_acks bits
  assign f_tx_rst_ack_n = &tx_rst_ack_n;
  assign f_rx_rst_ack_n = &rx_rst_ack_n;

// anding respective operational bits 
  //assign f_tx_operational = &tx_operational;
 // assign f_rx_operational = &rx_operational;

  assign o_rst_ack_n = (~i_rst_n | eio_sys_rst) ? (f_tx_rst_ack_n | f_rx_rst_ack_n) : 1 ;
  assign o_tx_rst_ack_n = f_tx_rst_ack_n;
  assign o_rx_rst_ack_n = f_rx_rst_ack_n;
  always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
     r_rx_rst_ack_n    <= f_rx_rst_ack_n; // f_rx_rst_ack_n is combi
  end

  assign kr_stat[0][0]   = tx_lane_current_state[0][2] && ( kr_ctrl[0][0]? tx_lane_current_state[0][0] && rx_lane_current_state[0][0] : ~tx_lane_current_state[0][1]);          // kr_rst_ack 
  assign kr_stat[0][3]   = &sip_freeze_tx_src_ack && &sip_freeze_rx_src_ack;

  assign kr_stat[0][1]   = o_rx_pcs_fully_aligned; // link_sts 
  assign kr_stat[0][2]   = o_rx_hi_ber;            // hi_ber 
  assign kr_stat[0][7:4] = 4'b0;                   // reserved 

  //---------------------------------------------------------------------
  //------------------------- SRC STATUS signals----------------------------
  //---------------------------------------------------------------------
  // ---- tx_lanes_stable / rx_pcs_ready recovery/removal slack fix BEGIN
  wire f_tx_operational_sync,kr_mode_sync_int_tx;
  //wire f_rx_operational_sync, pcs_rx_sf_sync, rx_pcs_fully_aligned_aib_sync,kr_mode_sync_int_rx,o_rx_word_align_good_sync;
  logic rx_pcs_fully_aligned_sync_int_rx = '0;
  wire f_rx_operational_sync,kr_mode_sync_int_rx,o_rx_word_align_good_sync;

  reg rx_pcs_fully_aligned_aib_sync = '0 ,pcs_rx_sf_sync = '0;
  wire rx_pcs_fully_aligned_aib_sync_1;
  wire pcs_rx_sf_sync_1;

  logic f_tx_operational_sync_clktx = '0, f_rx_operational_sync_clkrx = '0;
  wire tx_operational_rcfgsync, rx_operational_rcfgsync;
     
  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (LANE_NUM),
      .INIT_VALUE         (0)
  ) tx_operational_sync (
      .clk                (int_clk_tx),
      .reset              (1'b0),
      .d                  (tx_operational ),
      .q                  (f_tx_operational)
  ); 
  
 assign f_tx_operational_sync = &f_tx_operational;

  always @ (posedge int_clk_tx) begin //All registers are initialized to 0.
      f_tx_operational_sync_clktx <= f_tx_operational_sync;
  end
  
  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (2),
      .INIT_VALUE         (0)
  ) tx_status_sync0 (
      .clk                (int_clk_tx),
      .reset              (1'b0),
      .d                  ({kr_mode,tx_dp_rst_s} ),
      .q                  ({kr_mode_sync_int_tx,tx_dp_rst_sync})
  );
 
  logic o_tx_lanes_stable_r = '0;

  always @ (posedge int_clk_tx) begin //All registers are initialized to 0.
    o_tx_lanes_stable_r      <= kr_mode_sync_int_tx ? 1'b0 : (f_tx_operational_sync && !tx_dp_rst_sync);
  end

 assign o_tx_lanes_stable = o_tx_lanes_stable_r;

  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (LANE_NUM),
      .INIT_VALUE         (0)
  ) rx_operational_sync (
      .clk                (int_clk_rx),
      .reset              (1'b0),
      .d                  (rx_operational ),
      .q                  (f_rx_operational)
  ); 
  
  assign f_rx_operational_sync = &f_rx_operational;

  always @ (posedge int_clk_rx) begin //All registers are initialized to 0.
      f_rx_operational_sync_clkrx <= f_rx_operational_sync;
  end  

eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (LANE_NUM),
      .INIT_VALUE         (0)
  ) tx_operational_reconfigsync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (tx_operational),
      .q                  (tx_operational_reconfig)
  );

  assign tx_operational_rcfgsync = &tx_operational_reconfig;

  always @ (posedge i_reconfig_clk) begin
      f_tx_operational_reconfigsync <= tx_operational_rcfgsync;
  end 
  
eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (LANE_NUM),
      .INIT_VALUE         (0)
  ) 
  rx_operational_reconfigsync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (rx_operational),
      .q                  (rx_operational_reconfig)
  );

  assign rx_operational_rcfgsync = &rx_operational_reconfig;

  always @ (posedge i_reconfig_clk) begin
      f_rx_operational_reconfigsync <= rx_operational_rcfgsync;
  end 

// SRC REQ synchronising before sending to CSR module
eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (LANE_NUM),
      .INIT_VALUE         (0)
  ) 
  src_avmm1_reqsync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (sip_lavmm1_block_req),
      .q                  (src_avmm1_req_sync)
  );

  // SRC REQ passed to CSR module
assign src_avmm1_req = &src_avmm1_req_sync; 


assign sip_lavmm1_block_ack = {LANE_NUM{src_avmm1_ack}} ; 

  
   always @(posedge i_reconfig_clk) begin //All registers are initialized to 0.
		   rx_dp_rst_s <= rx_dp_rst;
			tx_dp_rst_s <= tx_dp_rst;
	end
  
    eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (5),
      .INIT_VALUE         (0)
  ) rx_status_sync0 (
      .clk                (int_clk_rx),
      .reset              (1'b0),
      .d                  ({o_pcs_rx_sf, o_rx_pcs_fully_aligned_aib,kr_mode,rx_dp_rst_s,o_rx_word_align_good}),
     //.q                  ({pcs_rx_sf_sync, rx_pcs_fully_aligned_aib_sync,kr_mode_sync_int_rx,rx_dp_rst_sync,o_rx_word_align_good_sync})
      .q                  ({pcs_rx_sf_sync_1, rx_pcs_fully_aligned_aib_sync_1,kr_mode_sync_int_rx,rx_dp_rst_sync_1,o_rx_word_align_good_sync})
  );

  always @ (posedge int_clk_rx) begin //All registers are initialized to 0.
    rx_dp_rst_sync <= rx_dp_rst_sync_1;
    rx_pcs_fully_aligned_aib_sync <= rx_pcs_fully_aligned_aib_sync_1;
    pcs_rx_sf_sync <= pcs_rx_sf_sync_1;
  end
 
 logic o_rx_pcs_fully_aligned_r ='0;
 logic o_rx_pcs_ready_r ='0;

    always @ (posedge int_clk_rx) begin //All registers are initialized to 0.
    rx_pcs_fully_aligned_sync_int_rx   <= o_rx_pcs_fully_aligned;
	o_rx_pcs_ready_r         <= kr_mode_sync_int_rx ? 1'b0 : (f_rx_operational_sync && rx_pcs_fully_aligned_sync_int_rx && rx_deskew_done && !rx_dp_rst_sync);
  end
  
 assign o_rx_pcs_ready = o_rx_pcs_ready_r;

      // MAC interface or SINGLE lane
  //assign o_rx_pcs_fully_aligned = ~pcs_rx_sf_sync && rx_pcs_fully_aligned_aib_sync && !rx_dp_rst_sync;
  always @ (posedge int_clk_rx) begin //All registers are initialized to 0.
    o_rx_pcs_fully_aligned_r <= ~pcs_rx_sf_sync && rx_pcs_fully_aligned_aib_sync && !rx_dp_rst_sync;
  end
  
 assign o_rx_pcs_fully_aligned = o_rx_pcs_fully_aligned_r;

  assign o_fec_not_locked       = &o_fec_not_locked_aib;
  assign o_rx_am_lock           = ~o_fec_not_align_aib && o_rx_am_lock_aib && !rx_dp_rst_sync;
  assign o_rx_block_lock        = ~o_fec_not_locked && o_rx_block_lock_aib && !rx_dp_rst_sync;

logic [LANE_NUM-1:0] f_rx_operational_reconfig;
logic f_rx_operational_reconfig_sync;

  eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (LANE_NUM),
      .INIT_VALUE         (0)
  ) rx_operational_reconfig_sync (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (rx_operational ),
      .q                  (f_rx_operational_reconfig)
  ); 
  
  assign f_rx_operational_reconfig_sync = &f_rx_operational_reconfig; 


  assign local_fault_status_sip = (!f_rx_operational_reconfig_sync) ? 1'b1 : local_fault_status_hip;   
  assign o_local_fault_status = local_fault_status_sip;


///////LFS BIDIR  
     always @(posedge i_reconfig_clk) begin
          rf_in_progress_reg <= rf_in_progress;
     end

///F-edge
assign rf_in_progress_edge = rf_in_progress_reg & (~rf_in_progress);


(* preserve_syn_only *) logic [31:0] config_ehip_rst_counter;
(* preserve_syn_only *) logic ehip_rst;
(* preserve_syn_only *) logic counter_expired;

assign counter_expired = (config_ehip_rst_counter == config_ehip_rst_count) ? 1'b1 : 1'b0;


//ehip reset
     always @(posedge i_reconfig_clk) begin
     if (reconfig_reset_sync || counter_expired ) begin
		  ehip_rst    <= 1'b0;
     end else if(rf_in_progress_edge) begin
		  ehip_rst   <= 1'b1;
     end
     end

 ////ehip counter
 always_ff @(posedge i_reconfig_clk) begin
	 if (reconfig_reset_sync || counter_expired ) begin
		  config_ehip_rst_counter    <= {32{1'b0}};
	 end else if(ehip_rst == 1'b1 ) begin
	 	  config_ehip_rst_counter   <= config_ehip_rst_counter + 1'b1;
	 end
end


assign i_sip_hack_tx_ehiprst_control = (ENABLE_ANLT)?{LANE_NUM{1'b0}}:{LANE_NUM{ehip_rst}};
assign i_sip_hack_tx_ehiprst_value = (ENABLE_ANLT)?{LANE_NUM{1'b1}}:{LANE_NUM{~ehip_rst}};



//--------- Implement o_sys_pll_lock signal ------
//------------------------------------------------
assign o_sys_pll_locked = &tx_sys_clk_stable; 



  //// experiment for IP SDC ////

wire dummy_in_for_timing /* synthesis syn_noprune syn_preserve = 1 */;
reg  dummy_out_for_timing /* synthesis syn_noprune syn_preserve = 1 */;

assign dummy_in_for_timing = 1'b0;

wire dummy_in_for_tx_div_clk_timing /* synthesis syn_noprune syn_preserve = 1 */;
reg  dummy_out_for_tx_div_clk_timing /* synthesis syn_noprune syn_preserve = 1 */;
assign dummy_in_for_tx_div_clk_timing = 1'b0;


   generate
     
              always @ (posedge o_clk_rec_div) begin //All registers are initialized to 0.
                   dummy_out_for_timing<= dummy_in_for_timing;
              end

	      always @ (posedge o_clk_tx_div) begin //All registers are initialized to 0.
                   dummy_out_for_tx_div_clk_timing <= dummy_in_for_tx_div_clk_timing;
              end
    
   endgenerate
	
////////CWBIN COUNTER IMPLEMENTATION

	 
generate
	 if (ENABLE_SOFT_CWBIN) begin: GEN_SOFT_CWBIN_AVMM

logic stats_snapshot_sync;
	 
 eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (1),
      .INIT_VALUE         (0)
  ) stats_snapshot_sync_inst (
      .clk                (i_reconfig_clk),
      .reset              (1'b0),
      .d                  (i_stats_snapshot),
      .q                  (stats_snapshot_sync)
  );

 logic o_stats_snapshot_1 = '0; 

 always @ (posedge i_reconfig_clk) begin //All registers are initialized to 0.
 o_stats_snapshot_1 <= o_stats_snapshot;
 end
 
 eth_f_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH  (3),
      .WIDTH              (1),
      .INIT_VALUE         (0)
  ) o_stats_snapshot_sync_inst (
      .clk                (int_clk_tx),
      .reset              (1'b0),
      .d                  (o_stats_snapshot_1),
      .q                  (o_stats_snapshot_sync)
  ); 
  
  

eth_f_soft_cwbin_counter
#(
    .TIMEOUT_COUNT (CWBIN_TIMEOUT_COUNT), //14us timer, 1400 for 100MHZ reconfig clock, 3500 for 250MHz clock
    .ADDR_WIDTH  (14)
) soft32bit_cwbin0_3
(
    .i_reconfig_clk					(i_reconfig_clk),
    .i_reset						(~f_rx_operational_reconfigsync), 
    .i_reconfig_reset				(reconfig_reset_sync),
    .i_stats_snapshot				(stats_snapshot_sync),
    .i_ehip_rate                   (EHIP_RATE_CSR[2:0]),
    .i_fec_enable                   (1'b1), // fixed to 1 for baseIP and used for MRIP
    .i_reconfig_write					(i_reconfig_eth_write),
    .i_reconfig_byteenable			(i_reconfig_eth_byteenable),	
    .i_reconfig_read					(i_reconfig_eth_read),
    .i_reconfig_addr					(i_reconfig_eth_addr),
    .i_reconfig_writedata			(i_reconfig_eth_writedata),
    .o_reconfig_readdata				(o_reconfig_eth_readdata),		
    .o_reconfig_readdata_valid		(o_reconfig_eth_readdata_valid),
    .o_reconfig_waitrequest			(o_reconfig_eth_waitrequest),
    .o_stats_snapshot            (o_stats_snapshot),
    .o_rcfg_write						(reconfig_eth_write_cw),
    .o_rcfg_byteenable				(reconfig_eth_byteenable_cw),
    .o_rcfg_read						(reconfig_eth_read_cw),
    .o_rcfg_addr						(reconfig_eth_addr_cw),
    .o_rcfg_writedata					(reconfig_eth_writedata_cw),
    .i_rcfg_readdata					(reconfig_eth_readdata_cw),
    .i_rcfg_readdata_valid			(reconfig_eth_readdata_valid_cw),
    .i_rcfg_waitrequest				(reconfig_eth_waitrequest_cw),
 .cwbin_rst							(cwbin_rst),
 .cwbin0A_out						(cwbin0A_out),
    .cwbin1A_out						(cwbin1A_out),
	 .cwbin2A_out						(cwbin2A_out),
	 .cwbin3A_out						(cwbin3A_out),
	 .cwbin0B_out						(cwbin0B_out),
    .cwbin1B_out						(cwbin1B_out),
	 .cwbin2B_out						(cwbin2B_out),
	 .cwbin3B_out						(cwbin3B_out),
	 .cwbin_timer_timeout					(cwbin_timer_timeout)
 
); 

	end
    else 
    begin: NO_SOFT_CWBIN_AVMM
	             assign  reconfig_eth_addr_cw            =   i_reconfig_eth_addr;
                assign  reconfig_eth_byteenable_cw       =   i_reconfig_eth_byteenable;
                assign  reconfig_eth_read_cw             =   i_reconfig_eth_read;
                assign  reconfig_eth_write_cw            =   i_reconfig_eth_write;
                assign  reconfig_eth_writedata_cw        =   i_reconfig_eth_writedata;
                assign  o_reconfig_eth_readdata_valid     =    reconfig_eth_readdata_valid_cw ;
                assign  o_reconfig_eth_readdata           =   reconfig_eth_readdata_cw;
                assign  o_reconfig_eth_waitrequest        =   reconfig_eth_waitrequest_cw ; 
					 
					 assign o_stats_snapshot = 1'b0;
					 assign o_stats_snapshot_sync = i_stats_snapshot;
					 assign cwbin0A_out = 32'h0;
					 assign cwbin1A_out = 32'h0;
					 assign cwbin2A_out = 32'h0;
					 assign cwbin3A_out = 32'h0;
					 assign cwbin0B_out = 32'h0;
					 assign cwbin1B_out = 32'h0;
					 assign cwbin2B_out = 32'h0;
					 assign cwbin3B_out = 32'h0;
					 
					 
					 
	 
    end		
    endgenerate
	 
assign dl_tx_delay_sclk = {8{32'b0}};
assign dl_rx_delay_sclk = {8{32'b0}};
assign dl_tx_sync_count={8{32'b0}};
assign dl_tx_async_count={8{32'b0}};
assign dl_rx_sync_count={8{32'b0}};
assign dl_rx_async_count={8{32'b0}};

assign dl_tx_measure_valid={8{1'b0}};
assign dl_rx_measure_valid={{1'b0}};
assign dl_tx_sync_valid={8{1'b0}};
assign dl_tx_async_valid={8{1'b0}};
assign dl_rx_sync_valid={8{1'b0}};
assign dl_rx_async_valid={8{1'b0}};

//assign dl_tx_restart={8{1'b0}};
//assign dl_rx_restart={8{1'b0}};
endmodule


