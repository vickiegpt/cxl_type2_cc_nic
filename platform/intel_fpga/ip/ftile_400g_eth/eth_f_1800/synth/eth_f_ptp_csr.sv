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
//
// Filename         : eth_f_ptp_csr.sv
//
//==============================================================================
//
// Description         : process and map csr signals between eth_f_ptp and
//                       CSR interface
//
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module eth_f_ptp_csr #(
    parameter PL = 1
    )(

    // User Interface
    input  logic                      clk,
    input  logic                      reset,
    input  logic          [31:0]      writedata,
    input  logic                      read,
    input  logic                      write,
    input  logic           [3:0]      byteenable,
    output logic          [31:0]      readdata,
    output logic                      readdatavalid,
    input  logic          [11:0]      address,
    // DR
    input wire                        i_tx_ehip_preamble_passthru_gui,
    output wire                       o_tx_ehip_preamble_passthru_dr,
    // HW interface: clock and reset
    input wire                        i_ptp_clk,
    input wire                        i_tx_tod_clk,
    input wire                        i_rx_tod_clk,
    input wire                        i_samp_clk,
    input wire                        i_tx_srst_n,  // o_tx_lanes_stable at ptp_clk
    input wire                        i_rx_srst_n,  // o_rx_pcs_ready at ptp_clk
    input wire                        i_tx_tod_srst_n,
    input wire                        i_rx_tod_srst_n,
    input wire                        i_tx_samp_srst_n,
    input wire                        i_rx_samp_srst_n,
    input  logic                      i_tx_lanes_stable_status,     // reconfig_clk
    input  logic                      i_rx_pcs_fully_aligned,       // ptp_clk
    // HW interface: reference lane [ptp_clk]
    input  logic                      i_tx_apulse_wdly_valid,           // sample_clk
    input  logic                      i_tx_apulse_offset_valid,         // sample_clk
    input  logic                      i_tx_apulse_time_valid,           // ptp_clk
    input  wire  [PL-1:0][19:0]       i_tx_apulse_wdly,                 // sample_clk
    input  wire  [PL-1:0][27:0]       i_tx_apulse_time,                 // ptp_clk
    input  wire  [PL-1:0][31:0]       i_tx_apulse_offset,               // sample_clk
    input  logic                      i_rx_apulse_wdly_valid,           // sample_clk
    input  logic                      i_rx_apulse_offset_valid,         // sample_clk
    input  logic                      i_rx_apulse_time_valid,           // ptp_clk
    input  wire  [PL-1:0][19:0]       i_rx_apulse_wdly,                 // sample_clk
    input  wire  [PL-1:0][31:0]       i_rx_apulse_offset,               // sample_clk
    input  wire  [PL-1:0][27:0]       i_rx_apulse_time,                 // ptp_clk
    input  logic         [31:0]       i_tx_const_adjust,                // combi
    input  logic         [31:0]       i_rx_const_adjust,                // combi
    // HW interface: Reference lane [ptp_clk]
    output logic         [2:0]        o_tx_ref_lane,                    // tod_clk
    output logic         [2:0]        o_rx_lal,                         // tod_clk
    // HW interface: TAM adjust [ptp_clk]       
    output logic         [31:0]       o_tx_calc_adjust,                 // ptp_clk
    output logic         [31:0]       o_rx_calc_adjust,                 // ptp_clk
    // HW interface: User Configuration Done [ptp_clk]    
    output logic                      o_tx_ptp_user_cfg_done,           // ptp_clk
    output logic                      o_rx_ptp_user_cfg_done,           // ptp_clk
    input  logic                      i_tx_ptp_user_cfg_done_clrn,       // ptp_clk
    input  logic                      i_rx_ptp_user_cfg_done_clrn,       // ptp_clk
    // HW interface: Multilane nonFEC RX virtual lane offset [ptp_clk]
    input  logic                      i_rx_ptp_vl_snapshot,             // ptp_clk
    // HW interface: FEC-only RX codeword position configuration done
    output logic                      o_rx_fec_cw_pos_user_cfg_done,    // ptp_clk
    // HW interface: UI measurement [ptp_clk]
    input logic                      i_tx_tam_valid,                    // ptp_clk
    input logic          [15:0]      i_tx_tam_cnt,                      // ptp_clk
    input logic          [47:0]      i_tx_tam_ui,                       // ptp_clk
    input logic                      i_rx_tam_valid,                    // ptp_clk
    input logic          [15:0]      i_rx_tam_cnt,                      // ptp_clk
    input logic          [47:0]      i_rx_tam_ui,                       // ptp_clk
    // HW interface: PTP Status [ptp_clk]
    input logic                      i_tx_ptp_offset_data_valid,        // ptp_clk
    input logic                      i_rx_ptp_offset_data_valid,        // ptp_clk
    input logic                      i_tx_ptp_ready,                    // ptp_clk
    input logic                      i_rx_ptp_ready                     // ptp_clk
    
);
  
  // hardware interface mapping
  wire        ptp_tx_tam_adjust_tam_adjust_modTrig;
  wire        ptp_rx_tam_adjust_tam_adjust_modTrig;
  wire        ptp_tx_tam_adjust_tam_adjust_hwclr;
  wire        ptp_rx_tam_adjust_tam_adjust_hwclr;
  wire [31:0] ptp_tx_tam_adjust_tam_adjust;
  wire [31:0] ptp_rx_tam_adjust_tam_adjust;
  wire        ptp_tx_user_cfg_done;
  wire        ptp_tx_user_cfg_done_hwclr;
  wire        ptp_rx_user_cfg_done;
  wire        ptp_rx_user_cfg_done_hwclr;
  wire        ptp_rx_fec_cw_pos_cfg_done;
  wire        ptp_rx_fec_cw_pos_cfg_done_hwclr;
  wire        ptp_ref_lane_tx_ref_lane_modTrig;
  wire        ptp_ref_lane_rx_ref_lane_modTrig;
  wire        ptp_ref_lane_tx_ref_lane_hwclr;
  wire        ptp_ref_lane_rx_ref_lane_hwclr;
  wire [2:0]  ptp_ref_lane_tx_ref_lane;
  wire [2:0]  ptp_ref_lane_rx_ref_lane;
  //
  wire         ptp_uim_tam_snapshot_tx_tam_snapshot;
  wire         ptp_uim_tam_snapshot_rx_tam_snapshot;
  wire [31:0]  ptp_tx_uim_tam_info0_tam_31_0_i;
  wire [15:0]  ptp_tx_uim_tam_info1_tam_47_32_i;
  wire [14:0]  ptp_tx_uim_tam_info1_tam_cnt_i;
  wire         ptp_tx_uim_tam_info1_tam_valid_i;
  wire [31:0]  ptp_rx_uim_tam_info0_tam_31_0_i;
  wire [15:0]  ptp_rx_uim_tam_info1_tam_47_32_i;
  wire [14:0]  ptp_rx_uim_tam_info1_tam_cnt_i;
  wire         ptp_rx_uim_tam_info1_tam_valid_i;
  //
  wire          ptp_status_tx_ptp_offset_data_valid_i;
  wire          ptp_status_rx_ptp_offset_data_valid_i;
  wire          ptp_status_tx_ptp_ready_i;
  wire          ptp_status_rx_ptp_ready_i;
  wire          ptp_status2_tx_calc_data_offset_valid_i;
  wire          ptp_status2_tx_calc_data_time_valid_i;
  wire          ptp_status2_tx_calc_data_wiredelay_valid_i;
  wire          ptp_status2_rx_calc_data_offset_valid_i;
  wire          ptp_status2_rx_calc_data_time_valid_i;
  wire          ptp_status2_rx_calc_data_wiredelay_valid_i;
  wire          ptp_status2_rx_vl_offset_data_ready_i;
  //
  wire  [31:0]  ptp_tx_lane_calc_data_constdelay_data_constdelay_i;
  wire  [31:0]  ptp_rx_lane_calc_data_constdelay_data_constdelay_i;
  wire  [7:0][31:0]  ptp_tx_lane_calc_data_offset_data_offset_i;
  wire  [7:0][31:0]  ptp_rx_lane_calc_data_offset_data_offset_i;
  wire  [7:0][27:0]  ptp_tx_lane_calc_data_time_data_time_i;
  wire  [7:0][27:0]  ptp_rx_lane_calc_data_time_data_time_i;
  wire  [7:0][19:0]  ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i;
  wire  [7:0][19:0]  ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i;
  wire          tx_lanes_stable_csr;
  wire          rx_pcs_fully_aligned_csr;
  wire          rx_pcs_fully_aligned_ptp;
  // wire          rx_pcs_fully_aligned_tod;
  wire          tx_ptp_user_cfg_done_clrn_csr;
  wire          rx_ptp_user_cfg_done_clrn_csr;
  //
  wire          ptp_dr_cfg_tx_ehip_preamble_passthrough_reset_value;
  wire          ptp_dr_cfg_tx_ehip_preamble_passthrough;
  
  eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (2),
    .INIT_VALUE         (0)
  ) user_cfg_done_clrn_csr_sync (
    .clk    (clk),
    .reset  (1'b0),
    .d      ({i_tx_ptp_user_cfg_done_clrn, i_rx_ptp_user_cfg_done_clrn}),
    .q      ({tx_ptp_user_cfg_done_clrn_csr, rx_ptp_user_cfg_done_clrn_csr})
  );
  eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
  ) rx_pcs_fully_aligned_csr_sync (
    .clk    (clk),
    .reset  (1'b0),
    .d      (i_rx_pcs_fully_aligned),
    .q      (rx_pcs_fully_aligned_csr)
  );
  eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
  ) rx_pcs_fully_aligned_ptp_sync (
    .clk    (i_ptp_clk),
    .reset  (1'b0),
    .d      (i_rx_pcs_fully_aligned),
    .q      (rx_pcs_fully_aligned_ptp)
  );
  assign tx_lanes_stable_csr = i_tx_lanes_stable_status;
  
  // eth_f_ptp_xcvr_resync_std #(
    // .SYNC_CHAIN_LENGTH  (3),
    // .WIDTH              (1),
    // .INIT_VALUE         (0)
  // ) rx_pcs_fully_aligned_tod_sync (
    // .clk    (i_rx_tod_clk),
    // .reset  (~i_rx_tod_srst_n),
    // .d      (i_rx_pcs_fully_aligned),
    // .q      (rx_pcs_fully_aligned_tod)
  // );
  
  // ------------------------------------------------------------------------------------------
  // hip user config status, // long pulse, // avmm_clk (100-250) to ptp_clk (402-450)
  assign ptp_tx_user_cfg_done_hwclr = ~tx_lanes_stable_csr | ~tx_ptp_user_cfg_done_clrn_csr;
  assign ptp_rx_user_cfg_done_hwclr = ~rx_pcs_fully_aligned_csr | ~rx_ptp_user_cfg_done_clrn_csr;
  assign ptp_rx_fec_cw_pos_cfg_done_hwclr = ~rx_pcs_fully_aligned_csr;
  
  eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (2),
    .INIT_VALUE         (0)
  ) rx_user_cfg_done_sync (
    .clk    (i_ptp_clk),
    .reset  (1'b0),
    .d      ({ptp_rx_fec_cw_pos_cfg_done, ptp_rx_user_cfg_done}),
    .q      ({o_rx_fec_cw_pos_user_cfg_done, o_rx_ptp_user_cfg_done})
  );  
  
  eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
  ) tx_user_cfg_done_sync (
    .clk    (i_ptp_clk),
    .reset  (1'b0),
    .d      (ptp_tx_user_cfg_done),
    .q      (o_tx_ptp_user_cfg_done)
  );
  
  // ------------------------------------------------------------------------------------------
  // Reference lane, // valid is single pulse, // avmm_clk (100-250) to tod_clk (390). ref_lane is NA for 10g_adv (156.25)
  
  // hwclr avmm_clk reg
  assign ptp_ref_lane_tx_ref_lane_hwclr = ~tx_lanes_stable_csr;
  assign ptp_ref_lane_rx_ref_lane_hwclr = ~rx_pcs_fully_aligned_csr;
  
  // widen single pulse
  logic [1:0] tx_rl_in_valid_r, rx_rl_in_valid_r;
  logic tx_ref_lane_in_valid, rx_ref_lane_in_valid;
  always @ (posedge clk) begin
    if (reset) begin
        tx_rl_in_valid_r[1:0]   <= 2'b00;
        rx_rl_in_valid_r[1:0]   <= 2'b00;
        tx_ref_lane_in_valid    <= 1'b0;
        rx_ref_lane_in_valid    <= 1'b0;
    end
    else begin
        tx_rl_in_valid_r[1:0]   <= {tx_rl_in_valid_r[0], ptp_ref_lane_tx_ref_lane_modTrig};
        rx_rl_in_valid_r[1:0]   <= {rx_rl_in_valid_r[0], ptp_ref_lane_rx_ref_lane_modTrig};
        tx_ref_lane_in_valid    <= (|tx_rl_in_valid_r[1:0]) | ptp_ref_lane_tx_ref_lane_modTrig;
        rx_ref_lane_in_valid    <= (|rx_rl_in_valid_r[1:0]) | ptp_ref_lane_rx_ref_lane_modTrig;
    end
  end
  
  eth_f_ptp_csr_clock_crosser #(
    .SYNC_DEPTH     (3),
    .DATA_WIDTH     (3),
  .DATA_BUFFER_MODE (1)
  ) tx_ref_lane_sync (
    .i_in_clk      (clk),
    .i_in_rst_n    (~reset),
    .i_in_valid    (tx_ref_lane_in_valid),
    .i_in_data     (ptp_ref_lane_tx_ref_lane),
    .i_out_clk     (i_tx_tod_clk),
    .i_out_rst_n   (i_tx_tod_srst_n),
    .o_out_valid   (),
    .o_out_data    (o_tx_ref_lane)
  );
  eth_f_ptp_csr_clock_crosser #(
    .SYNC_DEPTH     (3),
    .DATA_WIDTH     (3),
  .DATA_BUFFER_MODE (1)
  ) rx_ref_lane_sync (
    .i_in_clk      (clk),
    .i_in_rst_n    (~reset),
    .i_in_valid    (rx_ref_lane_in_valid),
    .i_in_data     (ptp_ref_lane_rx_ref_lane),
    .i_out_clk     (i_rx_tod_clk),
    .i_out_rst_n   (i_rx_tod_srst_n),
    .o_out_valid   (),
    .o_out_data    (o_rx_lal)
  );
  
  
  // ------------------------------------------------------------------------------------------
  // TAM adjust // valid is single pulse, // avmm_clk (100-250) to ptp_clk (402-450)
  logic rx_tam_adjust_rst_n;

  // hwclr avmm_clk reg
  assign ptp_tx_tam_adjust_tam_adjust_hwclr = ~tx_lanes_stable_csr; // 1'b0;
  assign ptp_rx_tam_adjust_tam_adjust_hwclr = ~rx_pcs_fully_aligned_csr;
  // outclk ptp_clk reg reset
  assign rx_tam_adjust_rst_n = (i_rx_srst_n && rx_pcs_fully_aligned_ptp);
  
  // widen single pulse
  logic [1:0] tx_ta_in_valid_r, rx_ta_in_valid_r;
  logic tx_tam_adjust_in_valid, rx_tam_adjust_in_valid;
  always @ (posedge clk) begin
    if (reset) begin
        tx_ta_in_valid_r[1:0]   <= 2'b00;
        rx_ta_in_valid_r[1:0]   <= 2'b00;
        tx_tam_adjust_in_valid  <= 1'b0;
        rx_tam_adjust_in_valid  <= 1'b0;
    end
    else begin
        tx_ta_in_valid_r[1:0] <= {tx_ta_in_valid_r[0], ptp_tx_tam_adjust_tam_adjust_modTrig};
        rx_ta_in_valid_r[1:0] <= {rx_ta_in_valid_r[0], ptp_rx_tam_adjust_tam_adjust_modTrig};
        tx_tam_adjust_in_valid  <= (|tx_ta_in_valid_r[1:0]) | ptp_tx_tam_adjust_tam_adjust_modTrig;
        rx_tam_adjust_in_valid  <= (|rx_ta_in_valid_r[1:0]) | ptp_rx_tam_adjust_tam_adjust_modTrig;
    end
  end
  
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (32),
  .DATA_BUFFER_MODE (1)
  ) tx_tam_adjust_sync (
    .i_in_clk      (clk),
    .i_in_rst_n    (~reset),
    .i_in_valid    (tx_tam_adjust_in_valid),
    .i_in_data     (ptp_tx_tam_adjust_tam_adjust),
    .i_out_clk     (i_ptp_clk),
    .i_out_rst_n   (i_tx_srst_n),
    .o_out_valid   (),
    .o_out_data    (o_tx_calc_adjust)
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (32),
  .DATA_BUFFER_MODE (1)
  ) rx_tam_adjust_sync (
    .i_in_clk      (clk),
    .i_in_rst_n    (~reset),
    .i_in_valid    (rx_tam_adjust_in_valid),
    .i_in_data     (ptp_rx_tam_adjust_tam_adjust),
    .i_out_clk     (i_ptp_clk),
    .i_out_rst_n   (rx_tam_adjust_rst_n),
    .o_out_valid   (),
    .o_out_data    (o_rx_calc_adjust)
  );

  // ---------------------------------------------------------------------
  // UIM TAM & CNT // valid is single pulse, // ptp_clk (402-450) to avmm_clk (100-250)
  logic [15:0] tx_tam_cnt_sync, tx_tam_cnt_sync_r;
  logic [47:0] tx_tam_sync, tx_tam_sync_r;
  logic [15:0] rx_tam_cnt_sync, rx_tam_cnt_sync_r;
  logic [47:0] rx_tam_sync, rx_tam_sync_r;
  logic [7:0]  tx_tam_valid_r;
  logic [7:0]  rx_tam_valid_r;
  logic tx_tam_in_valid;
  logic rx_tam_in_valid;
  
  always @ (posedge i_ptp_clk) begin
    if (!i_tx_srst_n) begin
        tx_tam_valid_r[7:0] <= 8'h00;
    end
    else begin
        tx_tam_valid_r[7:0] <= {tx_tam_valid_r[6:0], i_tx_tam_valid};
    end
  end
  assign tx_tam_in_valid = (|tx_tam_valid_r) | (i_tx_tam_valid);
  
  always @ (posedge i_ptp_clk) begin
    if (!i_rx_srst_n) begin
        rx_tam_valid_r[7:0] <= 8'h00;
    end
    else begin
        rx_tam_valid_r[7:0] <= {rx_tam_valid_r[6:0], i_rx_tam_valid};
    end
  end
  assign rx_tam_in_valid = (|rx_tam_valid_r) | (i_rx_tam_valid);
  
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH   (3),
  .DATA_WIDTH   (64),
  .DATA_BUFFER_MODE (1)
  ) tx_uim_sync (
    .i_in_clk      (i_ptp_clk),
    .i_in_rst_n    (i_tx_srst_n),
    .i_in_valid    (tx_tam_in_valid),
    .i_in_data     ({i_tx_tam_cnt[15:0], i_tx_tam_ui[47:0]}), // {1b valid, 15b cnt, 48b tam}
    .i_out_clk     (clk),
    .i_out_rst_n   (~reset),
    .o_out_valid   (),
    .o_out_data    ({tx_tam_cnt_sync, tx_tam_sync})
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH   (3),
  .DATA_WIDTH   (64),
  .DATA_BUFFER_MODE (1)
  ) rx_uim_sync (
    .i_in_clk      (i_ptp_clk),
    .i_in_rst_n    (i_rx_srst_n),
    .i_in_valid    (rx_tam_in_valid),
    .i_in_data     ({i_rx_tam_cnt[15:0], i_rx_tam_ui[47:0]}), // {1b valid, 15b cnt, 48b tam}
    .i_out_clk     (clk),
    .i_out_rst_n   (~reset),
    .o_out_valid   (),
    .o_out_data    ({rx_tam_cnt_sync, rx_tam_sync})
  );
  
  always @ (posedge clk) begin
    if (reset) begin
        tx_tam_cnt_sync_r   <= {16{1'b0}};
        tx_tam_sync_r       <= {48{1'b0}};
        rx_tam_cnt_sync_r   <= {16{1'b0}};
        rx_tam_sync_r       <= {48{1'b0}};
    end
    else begin
        if (ptp_uim_tam_snapshot_tx_tam_snapshot) begin
            tx_tam_cnt_sync_r   <= tx_tam_cnt_sync;
            tx_tam_sync_r       <= tx_tam_sync;
        end
        if (ptp_uim_tam_snapshot_rx_tam_snapshot) begin
            rx_tam_cnt_sync_r   <= rx_tam_cnt_sync;
            rx_tam_sync_r       <= rx_tam_sync;
        end
    end
  end
  
  assign ptp_tx_uim_tam_info1_tam_valid_i   = tx_tam_cnt_sync_r[15];
  assign ptp_tx_uim_tam_info1_tam_cnt_i     = tx_tam_cnt_sync_r[14:0];
  assign ptp_tx_uim_tam_info1_tam_47_32_i   = tx_tam_sync_r[47:32];
  assign ptp_tx_uim_tam_info0_tam_31_0_i    = tx_tam_sync_r[31:0];
  assign ptp_rx_uim_tam_info1_tam_valid_i   = rx_tam_cnt_sync_r[15];
  assign ptp_rx_uim_tam_info1_tam_cnt_i     = rx_tam_cnt_sync_r[14:0];
  assign ptp_rx_uim_tam_info1_tam_47_32_i   = rx_tam_sync_r[47:32];
  assign ptp_rx_uim_tam_info0_tam_31_0_i    = rx_tam_sync_r[31:0];
  
  // ---------------------------------------------------------------------
  // Status: long pulse, no sync issue
  eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (3),
    .INIT_VALUE         (0)
  ) rx_status_sync (
    .clk    (clk),
    .reset  (1'b0),
    .d      ({i_rx_ptp_vl_snapshot,i_rx_ptp_offset_data_valid,i_rx_ptp_ready}),
    .q      ({ptp_status2_rx_vl_offset_data_ready_i,ptp_status_rx_ptp_offset_data_valid_i,ptp_status_rx_ptp_ready_i})
  );
  eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (2),
    .INIT_VALUE         (0)
  ) tx_status_sync (
    .clk    (clk),
    .reset  (1'b0),
    .d      ({i_tx_ptp_offset_data_valid,i_tx_ptp_ready}),
    .q      ({ptp_status_tx_ptp_offset_data_valid_i,ptp_status_tx_ptp_ready_i})
  );
  
  // ---------------------------------------------------------------------
  // Calculation Data // valid is long pulse, // ptp_clk (402-450), samp_clk {114) to avmm_clk (100-250)
  genvar i;
  logic [PL*32-1:0] agg_in_tx_apulse_offset, agg_out_tx_apulse_offset;
  logic [PL*28-1:0] agg_in_tx_apulse_time,   agg_out_tx_apulse_time;
  logic [PL*20-1:0] agg_in_tx_apulse_wdly,   agg_out_tx_apulse_wdly;
  logic [PL*32-1:0] agg_in_rx_apulse_offset, agg_out_rx_apulse_offset;
  logic [PL*28-1:0] agg_in_rx_apulse_time,   agg_out_rx_apulse_time;
  logic [PL*20-1:0] agg_in_rx_apulse_wdly,   agg_out_rx_apulse_wdly;
  
  generate for (i=1; i<=PL; i++) begin: apulse_in_blk
      assign agg_in_tx_apulse_offset[i*32-1 -: 32]            = i_tx_apulse_offset  [i-1];
      assign agg_in_tx_apulse_time  [i*28-1 -: 28]            = i_tx_apulse_time    [i-1];
      assign agg_in_tx_apulse_wdly  [i*20-1 -: 20]            = i_tx_apulse_wdly    [i-1];
      assign agg_in_rx_apulse_offset[i*32-1 -: 32]            = i_rx_apulse_offset  [i-1];
      assign agg_in_rx_apulse_time  [i*28-1 -: 28]            = i_rx_apulse_time    [i-1];
      assign agg_in_rx_apulse_wdly  [i*20-1 -: 20]            = i_rx_apulse_wdly    [i-1];
  end
  endgenerate
  
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (64),
  .DATA_BUFFER_MODE (0)
  ) tx_calc_data_const_sync (
    .i_in_clk      (i_ptp_clk),
    .i_in_rst_n    (i_tx_srst_n),
    .i_in_valid    (1'b1),
    .i_in_data     ({i_tx_const_adjust, i_rx_const_adjust}), // pure combi from soft_ptp
    .i_out_clk      (clk),
    .i_out_rst_n    (~reset),
    .o_out_valid    (),
    .o_out_data     ({ptp_tx_lane_calc_data_constdelay_data_constdelay_i, ptp_rx_lane_calc_data_constdelay_data_constdelay_i})
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (PL*32),
  .DATA_BUFFER_MODE (0)
  ) tx_calc_data_offset_sync (
    .i_in_clk      (i_samp_clk),
    .i_in_rst_n    (i_tx_samp_srst_n),
    .i_in_valid    (i_tx_apulse_offset_valid),
    .i_in_data     (agg_in_tx_apulse_offset),
    .i_out_clk      (clk),
    .i_out_rst_n    (~reset),
    .o_out_valid    (ptp_status2_tx_calc_data_offset_valid_i),
    .o_out_data     (agg_out_tx_apulse_offset)
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (PL*28),
  .DATA_BUFFER_MODE (0)
  ) tx_calc_data_time_sync (
    .i_in_clk      (i_ptp_clk),
    .i_in_rst_n    (i_tx_srst_n),
    .i_in_valid    (i_tx_apulse_time_valid),
    .i_in_data     (agg_in_tx_apulse_time),
    .i_out_clk      (clk),
    .i_out_rst_n    (~reset),
    .o_out_valid    (ptp_status2_tx_calc_data_time_valid_i),
    .o_out_data     (agg_out_tx_apulse_time)
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (PL*20),
  .DATA_BUFFER_MODE (0)
  ) tx_calc_data_wdly_sync (
    .i_in_clk      (i_samp_clk),
    .i_in_rst_n    (i_tx_samp_srst_n),
    .i_in_valid    (i_tx_apulse_wdly_valid),
    .i_in_data     (agg_in_tx_apulse_wdly),
    .i_out_clk      (clk),
    .i_out_rst_n    (~reset),
    .o_out_valid    (ptp_status2_tx_calc_data_wiredelay_valid_i),
    .o_out_data     (agg_out_tx_apulse_wdly)
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (PL*32),
  .DATA_BUFFER_MODE (0)
  ) rx_calc_data_offset_sync (
    .i_in_clk      (i_samp_clk),
    .i_in_rst_n    (i_rx_samp_srst_n),
    .i_in_valid    (i_rx_apulse_offset_valid),
    .i_in_data     (agg_in_rx_apulse_offset),
    .i_out_clk      (clk),
    .i_out_rst_n    (~reset),
    .o_out_valid    (ptp_status2_rx_calc_data_offset_valid_i),
    .o_out_data     (agg_out_rx_apulse_offset)
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (PL*28),
  .DATA_BUFFER_MODE (0)
  ) rx_calc_data_time_sync (
    .i_in_clk      (i_ptp_clk),
    .i_in_rst_n    (i_rx_srst_n),
    .i_in_valid    (i_rx_apulse_time_valid),
    .i_in_data     (agg_in_rx_apulse_time),
    .i_out_clk      (clk),
    .i_out_rst_n    (~reset),
    .o_out_valid    (ptp_status2_rx_calc_data_time_valid_i),
    .o_out_data     (agg_out_rx_apulse_time)
  );
  eth_f_ptp_csr_clock_crosser #(
  .SYNC_DEPTH       (3),
  .DATA_WIDTH       (PL*20),
  .DATA_BUFFER_MODE (0)
  ) rx_calc_data_wdly_sync (
    .i_in_clk      (i_samp_clk),
    .i_in_rst_n    (i_rx_samp_srst_n),
    .i_in_valid    (i_rx_apulse_wdly_valid),
    .i_in_data     (agg_in_rx_apulse_wdly),
    .i_out_clk      (clk),
    .i_out_rst_n    (~reset),
    .o_out_valid    (ptp_status2_rx_calc_data_wiredelay_valid_i),
    .o_out_data     (agg_out_rx_apulse_wdly)
  );
  
  generate
  for (i=1; i<=PL; i++) begin: apulse_out_blk
    assign ptp_tx_lane_calc_data_offset_data_offset_i        [i-1]    = agg_out_tx_apulse_offset[i*32-1 -: 32];
    assign ptp_tx_lane_calc_data_time_data_time_i            [i-1]    = agg_out_tx_apulse_time  [i*28-1 -: 28];
    assign ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i  [i-1]    = agg_out_tx_apulse_wdly  [i*20-1 -: 20];
    assign ptp_rx_lane_calc_data_offset_data_offset_i        [i-1]    = agg_out_rx_apulse_offset[i*32-1 -: 32];
    assign ptp_rx_lane_calc_data_time_data_time_i            [i-1]    = agg_out_rx_apulse_time  [i*28-1 -: 28];
    assign ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i  [i-1]    = agg_out_rx_apulse_wdly  [i*20-1 -: 20];
  end
  for (i=PL+1; i<=8; i++) begin: apulse_out_tieoff_blk
    assign ptp_tx_lane_calc_data_offset_data_offset_i        [i-1]    = {32{1'b0}};
    assign ptp_tx_lane_calc_data_time_data_time_i            [i-1]    = {28{1'b0}};
    assign ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i  [i-1]    = {20{1'b0}};
    assign ptp_rx_lane_calc_data_offset_data_offset_i        [i-1]    = {32{1'b0}};
    assign ptp_rx_lane_calc_data_time_data_time_i            [i-1]    = {28{1'b0}};
    assign ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i  [i-1]    = {20{1'b0}};
  end
  endgenerate
  
  // ------------------------------------------------------------------------------------------
  // DR
  // constant parameter value, no sync required
  assign ptp_dr_cfg_tx_ehip_preamble_passthrough_reset_value = i_tx_ehip_preamble_passthru_gui;
  
    eth_f_ptp_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
  ) tx_ehip_pp_dr_sync (
    .clk    (i_ptp_clk),
    .reset  (1'b0), // sync only
    .d      (ptp_dr_cfg_tx_ehip_preamble_passthrough),
    .q      (o_tx_ehip_preamble_passthru_dr)
  );
  
  // ------------------------------------------------------------------------------------------
  // Register
  eth_f_ptp_csr_reg ptp_reg (
      .clk                                                          (clk                         ),
      .reset                                                        (reset                       ),
      .writedata                                                    (writedata                   ),
      .read                                                         (read                        ),
      .write                                                        (write                       ),
      .byteenable                                                   (byteenable                  ),
      .readdata                                                     (readdata                    ),
      .readdatavalid                                                (readdatavalid               ),
      .address                                                      (address                     ),
      .ptp_tx_tam_adjust_tam_adjust_modTrig                         (ptp_tx_tam_adjust_tam_adjust_modTrig       ),
      .ptp_tx_tam_adjust_tam_adjust_hwclr                           (ptp_tx_tam_adjust_tam_adjust_hwclr         ),
      .ptp_tx_tam_adjust_tam_adjust                                 (ptp_tx_tam_adjust_tam_adjust               ),
      .ptp_rx_tam_adjust_tam_adjust_modTrig                         (ptp_rx_tam_adjust_tam_adjust_modTrig       ),
      .ptp_rx_tam_adjust_tam_adjust_hwclr                           (ptp_rx_tam_adjust_tam_adjust_hwclr         ),
      .ptp_rx_tam_adjust_tam_adjust                                 (ptp_rx_tam_adjust_tam_adjust               ),
      .ptp_dr_cfg_tx_ehip_preamble_passthrough_reset_value          (ptp_dr_cfg_tx_ehip_preamble_passthrough_reset_value),
      .ptp_dr_cfg_tx_ehip_preamble_passthrough                      (ptp_dr_cfg_tx_ehip_preamble_passthrough),
      .ptp_tx_user_cfg_status_tx_user_cfg_done                      (ptp_tx_user_cfg_done                  ),
      .ptp_tx_user_cfg_status_tx_user_cfg_done_hwclr                (ptp_tx_user_cfg_done_hwclr            ),
      .ptp_rx_user_cfg_status_rx_user_cfg_done                      (ptp_rx_user_cfg_done                  ),
      .ptp_rx_user_cfg_status_rx_user_cfg_done_hwclr                (ptp_rx_user_cfg_done_hwclr            ),
      .ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done               (ptp_rx_fec_cw_pos_cfg_done                 ),
      .ptp_rx_user_cfg_status_rx_fec_cw_pos_cfg_done_hwclr         (ptp_rx_fec_cw_pos_cfg_done_hwclr           ),
      .ptp_ref_lane_tx_ref_lane_modTrig                               (ptp_ref_lane_tx_ref_lane_modTrig             ),
      .ptp_ref_lane_rx_ref_lane_modTrig                               (ptp_ref_lane_rx_ref_lane_modTrig             ),
      .ptp_ref_lane_tx_ref_lane_hwclr                               (ptp_ref_lane_tx_ref_lane_hwclr             ),
      .ptp_ref_lane_rx_ref_lane_hwclr                               (ptp_ref_lane_rx_ref_lane_hwclr             ),
      .ptp_ref_lane_tx_ref_lane                                     (ptp_ref_lane_tx_ref_lane                   ),
      .ptp_ref_lane_rx_ref_lane                                     (ptp_ref_lane_rx_ref_lane                   ),
      .ptp_uim_tam_snapshot_tx_tam_snapshot                         (ptp_uim_tam_snapshot_tx_tam_snapshot       ),
      .ptp_uim_tam_snapshot_rx_tam_snapshot                         (ptp_uim_tam_snapshot_rx_tam_snapshot       ),
      .ptp_tx_uim_tam_info0_tam_31_0_i                              (ptp_tx_uim_tam_info0_tam_31_0_i            ),
      .ptp_tx_uim_tam_info1_tam_47_32_i                             (ptp_tx_uim_tam_info1_tam_47_32_i           ),
      .ptp_tx_uim_tam_info1_tam_cnt_i                               (ptp_tx_uim_tam_info1_tam_cnt_i             ),
      .ptp_tx_uim_tam_info1_tam_valid_i                             (ptp_tx_uim_tam_info1_tam_valid_i            ),
      .ptp_rx_uim_tam_info0_tam_31_0_i                              (ptp_rx_uim_tam_info0_tam_31_0_i            ),
      .ptp_rx_uim_tam_info1_tam_47_32_i                             (ptp_rx_uim_tam_info1_tam_47_32_i           ),
      .ptp_rx_uim_tam_info1_tam_cnt_i                               (ptp_rx_uim_tam_info1_tam_cnt_i             ),
      .ptp_rx_uim_tam_info1_tam_valid_i                             (ptp_rx_uim_tam_info1_tam_valid_i            ),
      .ptp_status_tx_ptp_offset_data_valid_i                        (ptp_status_tx_ptp_offset_data_valid_i      ),
      .ptp_status_rx_ptp_offset_data_valid_i                        (ptp_status_rx_ptp_offset_data_valid_i      ),
      .ptp_status_tx_ptp_ready_i                                    (ptp_status_tx_ptp_ready_i                  ),
      .ptp_status_rx_ptp_ready_i                                    (ptp_status_rx_ptp_ready_i                  ),
      .ptp_status2_tx_calc_data_offset_valid_i                      (ptp_status2_tx_calc_data_offset_valid_i    ),
      .ptp_status2_tx_calc_data_time_valid_i                        (ptp_status2_tx_calc_data_time_valid_i      ),
      .ptp_status2_tx_calc_data_wiredelay_valid_i                   (ptp_status2_tx_calc_data_wiredelay_valid_i ),
      .ptp_status2_rx_calc_data_offset_valid_i                      (ptp_status2_rx_calc_data_offset_valid_i    ),
      .ptp_status2_rx_calc_data_time_valid_i                        (ptp_status2_rx_calc_data_time_valid_i      ),
      .ptp_status2_rx_calc_data_wiredelay_valid_i                   (ptp_status2_rx_calc_data_wiredelay_valid_i ),
      .ptp_status2_rx_vl_offset_data_ready_i                        (ptp_status2_rx_vl_offset_data_ready_i      ),
      .ptp_tx_lane_calc_data_constdelay_data_constdelay_i           (ptp_tx_lane_calc_data_constdelay_data_constdelay_i        ),
      .ptp_rx_lane_calc_data_constdelay_data_constdelay_i           (ptp_rx_lane_calc_data_constdelay_data_constdelay_i        ),
      .ptp_tx_lane0_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [0]         ),
      .ptp_rx_lane0_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [0]         ),
      .ptp_tx_lane0_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [0]         ),
      .ptp_rx_lane0_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [0]         ),
      .ptp_tx_lane0_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [0]         ),
      .ptp_rx_lane0_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [0]         ),
      .ptp_tx_lane1_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [1]         ),
      .ptp_rx_lane1_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [1]         ),
      .ptp_tx_lane1_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [1]         ),
      .ptp_rx_lane1_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [1]         ),
      .ptp_tx_lane1_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [1]         ),
      .ptp_rx_lane1_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [1]         ),
      .ptp_tx_lane2_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [2]         ),
      .ptp_rx_lane2_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [2]         ),
      .ptp_tx_lane2_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [2]         ),
      .ptp_rx_lane2_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [2]         ),
      .ptp_tx_lane2_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [2]         ),
      .ptp_rx_lane2_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [2]         ),
      .ptp_tx_lane3_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [3]         ),
      .ptp_rx_lane3_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [3]         ),
      .ptp_tx_lane3_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [3]         ),
      .ptp_rx_lane3_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [3]         ),
      .ptp_tx_lane3_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [3]         ),
      .ptp_rx_lane3_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [3]         ),
      .ptp_tx_lane4_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [4]         ),
      .ptp_rx_lane4_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [4]         ),
      .ptp_tx_lane4_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [4]         ),
      .ptp_rx_lane4_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [4]         ),
      .ptp_tx_lane4_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [4]         ),
      .ptp_rx_lane4_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [4]         ),
      .ptp_tx_lane5_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [5]         ),
      .ptp_rx_lane5_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [5]         ),
      .ptp_tx_lane5_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [5]         ),
      .ptp_rx_lane5_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [5]         ),
      .ptp_tx_lane5_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [5]         ),
      .ptp_rx_lane5_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [5]         ),
      .ptp_tx_lane6_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [6]         ),
      .ptp_rx_lane6_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [6]         ),
      .ptp_tx_lane6_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [6]         ),
      .ptp_rx_lane6_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [6]         ),
      .ptp_tx_lane6_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [6]         ),
      .ptp_rx_lane6_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [6]         ),
      .ptp_tx_lane7_calc_data_offset_data_offset_i                  (ptp_tx_lane_calc_data_offset_data_offset_i       [7]         ),
      .ptp_rx_lane7_calc_data_offset_data_offset_i                  (ptp_rx_lane_calc_data_offset_data_offset_i       [7]         ),
      .ptp_tx_lane7_calc_data_time_data_time_i                      (ptp_tx_lane_calc_data_time_data_time_i           [7]         ),
      .ptp_rx_lane7_calc_data_time_data_time_i                      (ptp_rx_lane_calc_data_time_data_time_i           [7]         ),
      .ptp_tx_lane7_calc_data_wiredelay_data_wiredelay_i            (ptp_tx_lane_calc_data_wiredelay_data_wiredelay_i [7]         ),
      .ptp_rx_lane7_calc_data_wiredelay_data_wiredelay_i            (ptp_rx_lane_calc_data_wiredelay_data_wiredelay_i [7]         )
    );
    
endmodule : eth_f_ptp_csr

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvf7HFDaKESPWnCzuLF5OzmgQnL8HBFdS8pJLfhVyVPUSnrI7IWRGcz/C7a6LuNYNzwbvDluxw3hqDou//0wCoU1KawP/NJXacrcnLsg33nqCExpniQgFypp7IjAp2viiBucmhAykpEK4I+YjjEndnkzoMfYTbYz3xC0eTffHMEbSEc5u4nOJIEeP7CTUMpf22U+linJY06Hev/7fJgAJ/7mKAHEyOGXBORwba6MGp11TouTfP9ezm+g4L3CObHDJQOWE7Mth+iwjWBg5Zvl5WR+LGDtyfQ54tkk1TCAcDe/PIIbk2IDFa/s2pcpcOQhL/WABkrfX6OedfahneGt7HBWNlxZVbL3xUaBKkiWa6LUlhVyQ3lemCKMLco6sCYjKgksosfpM+W9C3Lk4Zxm7A4CdgzTAGv04WmNTdCxI1b6K1ShqPs+zB0xut7n5zs64DinUwXdSc3iF5oEEIIkhUxjvsyRYZlkUCN/F0lBUgOT1cnJ5T3w7vXITbKOWZqyqgETqAfz4QpXjqBvFIWE+1PrDe9DCOfKUYTm1twv4GAywn+6jp4JGY+ESTpJojbVFWF+MylkWm0yXPArfTyY7eQjE+4ykAv1G07bcPleytD5W7aFZlVFPPfoRv4795ktkh/J/pj6EgfeXGSZZu6ueVpWmKp+sZlgv2UlmAIHOZ0zCNNM/khetTDZb3P74VtjosyQPae82KkWelCD+iEwzCE2K3SHiWv0wn6BekX5d/VOmF+U0kYeybJItQDNfTU8KQps/yJEnnoF9uMdK/wRnXD7"
`endif