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


//=============================================================================
//Description
//Generates RX MAC interface data from 80 bit parallel data from MAIB
//=============================================================================
//Declaration

//synthesis translate_off
`timescale 1ns / 1ps
//synthesis translate_on

module eth_f_dp_mapping_rx
import eth_f_package::*;
#(
    parameter   LANES                   =   4,
    parameter   DATA_RATE               =   "100G"
)
(
    // MAC Interface
    output  logic                          o_tx_ready,
    output  logic   [LANES-1:0][63:0]      o_rx_data,
    output  logic   [LANES-1:0][2:0]       o_rx_empty,
    output  logic   [LANES-1:0]            o_rx_fcs_error,
    output  logic   [LANES-1:0][1:0]       o_rx_error,
    output  logic   [LANES-1:0][2:0]       o_rx_status,
    output  logic   [LANES-1:0]            o_rx_inframe,
    output  logic                          o_rx_valid,
    output  logic                          o_rx_pause,
    output  logic   [7:0]                  o_rx_pfc,

    //PCS Interface
    output logic    [LANES-1:0][63:0]      o_rx_mii_d,
    output logic    [LANES-1:0][7:0]       o_rx_mii_c,
    output logic                           o_rx_mii_valid,
    output logic                           o_rx_mii_am_valid,
    output logic                           o_tx_mii_ready,

    //PCS66 Interface
    output logic    [LANES-1:0][65:0]      o_rx_pcs66_d,
    output logic                           o_rx_pcs66_valid,
    output logic                           o_rx_pcs66_am_valid,
    output logic                           o_tx_pcs66_ready,

    //Word align good
    output logic                           o_rx_word_align_good,
    // Deskew Interface
    output  logic   [LANES-1:0][77:0]      o_rx_data_to_dsk,
    output  logic   [LANES-1:0]            o_rx_aib_dsk,
    input   logic   [LANES-1:0][77:0]      i_rx_data_dsk_done,

    //80bit data from aib
    input   logic   [LANES*80-1:0]         i_rx_parallel_data
);


    logic   [LANES-1:0]                    o_rx_word_align_good_vec;
//=========================================================================
//Remap the RX output pins

//AIB decode 
genvar i;
generate
for (i=0; i<LANES; i=i+1) begin:aib_decoding
    assign o_rx_data_to_dsk[i] = {i_rx_parallel_data[((i*80)+40) +:39],i_rx_parallel_data[i*80+:39]};
    assign o_rx_aib_dsk[i]     = o_rx_data_to_dsk[i][EPRT_DESKEW]; 
end:aib_decoding
endgenerate


//Map the RX data interfaces
generate
for (i=0; i<LANES; i=i+1) begin:rx_mappings

  always_comb begin:rx_mac_client        
    o_rx_data[i]             =   {i_rx_data_dsk_done[i][EPRT_RX_DATA_1+:32],i_rx_data_dsk_done[i][EPRT_RX_DATA_0+:32]};
    o_rx_empty[i]            =   i_rx_data_dsk_done[i][EPRT_RX_EOP_EMPTY+:3];
    o_rx_inframe[i]          =   i_rx_data_dsk_done[i][EPRT_RX_INFRAME];
    if ((i % 2) == 0) 
    begin:i_zero 
      o_rx_fcs_error[i]      =   i_rx_data_dsk_done[i][EPRT_RX_FCS_ERROR];
      o_rx_error[i]          =   i_rx_data_dsk_done[i][EPRT_RX_ERROR+:2];
      o_rx_status[i]         =   i_rx_data_dsk_done[i][EPRT_RX_STATUS+:3];
    end:i_zero 
    else 
    begin 
	o_rx_fcs_error[i]      =   i_rx_data_dsk_done[i-1][EPRT_RX_FCS_ERROR];
	o_rx_error[i]          =   i_rx_data_dsk_done[i-1][EPRT_RX_ERROR+:2];
      	o_rx_status[i]         =   i_rx_data_dsk_done[i-1][EPRT_RX_STATUS+:3];



    //  o_rx_fcs_error[i]      =   1'b0;
    //  o_rx_error[i]          =   1'b0;
    //  o_rx_status[i]         =   1'b0;
    end 
  end:rx_mac_client

  always_comb begin:rx_mii
    for (int mii_bytes=0; mii_bytes<8; mii_bytes++) begin
      if (mii_bytes<4) begin
        o_rx_mii_d[i][8*mii_bytes+:8]           =   i_rx_data_dsk_done[i][9*mii_bytes+:8];
        o_rx_mii_c[i][mii_bytes]                =   i_rx_data_dsk_done[i][9*mii_bytes+8];
      end else begin
        o_rx_mii_d[i][8*mii_bytes+:8]           =   i_rx_data_dsk_done[i][3+9*mii_bytes+:8];
        o_rx_mii_c[i][mii_bytes]                =   i_rx_data_dsk_done[i][3+9*mii_bytes+8];
      end
    end
  end

  always_comb begin:rx_pcs66
    o_rx_pcs66_d[i][0+:33]                       =   i_rx_data_dsk_done[i][EPRT_TX_PCS66_DATA_0+:33];
    o_rx_pcs66_d[i][33+:33]                      =   i_rx_data_dsk_done[i][EPRT_TX_PCS66_DATA_1+:33];
  end

  always_comb begin:word_align
    o_rx_word_align_good_vec[i]                  =   i_rx_data_dsk_done[i][EPRT_RX_WORD_ALIGN_GOOD]; // There are align good signals for each lane which will be asserted/deasserted at the same time
  end
end:rx_mappings
endgenerate


always_comb begin:skip_deskew_logic
  o_tx_ready             =   o_rx_data_to_dsk[0][EPRT_TX_READY];
end:skip_deskew_logic


always_comb begin:lane_independent_mapping
  //MAC PCS
  o_rx_valid             =   i_rx_data_dsk_done[0][EPRT_RX_VALID];
  //PCS
  o_rx_mii_valid         =   i_rx_data_dsk_done[0][EPRT_RX_VALID];
  o_rx_mii_am_valid      =   i_rx_data_dsk_done[0][EPRT_RX_AM_VALID];
  o_tx_mii_ready         =   i_rx_data_dsk_done[0][EPRT_TX_READY];
  //PCS66
  o_rx_pcs66_valid       =   i_rx_data_dsk_done[0][EPRT_RX_VALID];
  o_rx_pcs66_am_valid    =   i_rx_data_dsk_done[0][EPRT_RX_AM_VALID];
  o_tx_pcs66_ready       =   i_rx_data_dsk_done[0][EPRT_TX_READY];
  // word_align_good
  o_rx_word_align_good   =   &o_rx_word_align_good_vec;
end:lane_independent_mapping

generate
  if ( LANES != 1) begin:pause_pfc_mapping
      assign o_rx_pause   =   i_rx_data_dsk_done[1][EPRT_RX_PAUSE];
      assign o_rx_pfc[0]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC0];
      assign o_rx_pfc[1]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC1];
      assign o_rx_pfc[2]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC2];
      assign o_rx_pfc[3]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC3];
      assign o_rx_pfc[4]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC4];
      assign o_rx_pfc[5]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC5];
      assign o_rx_pfc[6]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC6];
      assign o_rx_pfc[7]  =   i_rx_data_dsk_done[1][EPRT_RX_PFC7];
  end //pause_pfc_mapping
  else
  ;
endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapV6Jnl5kmr5GYX6hqx7+PRdPwHNO52tcxJhfz9n46IL7q8xEGd3DtVex0ePNA3UeUmFWufaPMj4HAMVdT0QrqwHMGVtfiQJUOhvGqHy9mL1IqEU0uVRQQtTHkqJwwuGvfasCQVAuDq+ykJEPP4Eo/ptf5OarsuHZ2w4qJxI6Fa7WpeNPiuPN1yABLBXImRrXk8WRvIe8QKPavXrSfcw1yEKGsByZeVTanvthR1oFAShqj992W6x3cieQICZv50t0rdu5+MvpPp/bouJAQljkDm5nNL1HGdkLsICFcWgrCqk/i08dR7DR2AJWtEim/Hqe/1OSjaQa1OqqvidQi5Jkh9xPdCknAuCTRxPTneYiDfYLBm2sryPELMRW3+fQDXk1wj1lz7rzCSNdUB6T9UtCablbRxQ5jaog+g0RuF75REKzJQQFSTbLtFHl56WNygE01tS5PKnauXeaOc37HpOt8kB8WYQ6OxhIeUef5to3SxQLAv2+6B8BAa1Yy95zU7TANdBO+g87VU0TyNSauEUAneKIvWkP3msapl20iKkVoTX7ldaF/gMoCMMBgmNhIzDezBeK6orIW/tLcNrIerpQDrR3uOUZ/KUcqAxEO7Lcf74OSnfOYVpmhQNhaLJOjJXIgZFqDzAyW34B5LYYKka5nM4j3qfpSBzKTK556KyMpld8VgDs0+oTTU16f/sm5mqOyMyrsv5EYdfGcoi1RILzcW8shZXabt7SK56hCsXBn9qII5KZvefpSzWMi7bMUEEH/fjcKKtnTEg5LmwMf9dqYSe"
`endif