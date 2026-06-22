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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module eth_f_sl_adapter_rx #(
    parameter WORD_WIDTH    = 64,
    parameter EMPTY_BITS    = 3,
    parameter PTP_WIDTH     = 1,
    parameter NUM_CHANNELS  = 1
) (
    input   [NUM_CHANNELS-1:0]                    i_clk,
    input   [NUM_CHANNELS-1:0]                    i_reset,

    // Client interface
    output  [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]    o_data,
    output  [NUM_CHANNELS-1:0]                    o_valid,
    output  [NUM_CHANNELS-1:0]                    o_sop,
    output  [NUM_CHANNELS-1:0]                    o_eop,
    output  [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]    o_empty,
    output  [NUM_CHANNELS-1:0][5:0]               o_error,
    output  [NUM_CHANNELS-1:0][39:0]              o_status,
    output  [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]     o_ptp,

    input   [NUM_CHANNELS-1:0]                    i_valid,
    input   [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]    i_data,
    input   [NUM_CHANNELS-1:0]                    i_inframe,
    input   [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]    i_empty,
    input   [NUM_CHANNELS-1:0][1:0]               i_error,
    input   [NUM_CHANNELS-1:0]                    i_fcs_error,
    input   [NUM_CHANNELS-1:0][2:0]               i_status,
    input   [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]     i_ptp
);

    genvar i;
    generate
      for (i=0; i<NUM_CHANNELS; i++) begin: gen_fav
        // Convert to soft IP interface (EOP, SOP, valid)
        eth_f_sl_if_to_avalon #(
          .WORD_WIDTH (WORD_WIDTH),
          .EMPTY_BITS (EMPTY_BITS),
          .PTP_WIDTH  (PTP_WIDTH)
        ) i_ehip_if_to_avalon (
          .i_clk        (i_clk),
          .i_reset      (i_reset),
          .i_data       (i_data[i]),
          .i_empty      (i_empty[i]),
          .i_error      (i_error[i]),
          .i_fcs_error  (i_fcs_error[i]),
          .i_status     (i_status[i]),
          .i_valid      (i_valid[i]),
          .i_inframe    (i_inframe[i]),
          .i_ptp        (i_ptp[i]),

          .o_data       (o_data[i]),
          .o_valid      (o_valid[i]),
          .o_sop        (o_sop[i]),
          .o_eop        (o_eop[i]),
          .o_empty      (o_empty[i]),
          .o_status     (o_status[i]),
          .o_error      (o_error[i]),
          .o_ptp        (o_ptp[i])
        );
      end: gen_fav
    endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapXMudhhQyJGluGtDoi0qyivaruFug72p3SAZJqb6TjpL/JpIpPzGwPcgRNUW23EtGBn13+t8lrZ8UaFnmJBPbFCeZUfBo59c1rBWqELPmHrEWUwIZSJD7IxU+DruTLqTQUrsRM0I/Vuv64qdODP5buOAxsNxaac+DuX9dvn3trs7aulZ05bulHCYNg1Yv22gobrf1nAw6AHbpEtWXzC+NndmG6czIm6QSoks91TdQdA6RkHZ0+QAiacCoyRS7+QyvwkceGpCCB/9mxW/zKYqHf8HPkyoNv1yK7MksjUy0gQzeDGAzTcuUW1hVJVNC7P81n82dmQWO0LROtWabHDwpYYGlbD5R7OjdhzxZcSsXQGhKLMpJYFKZQnq0nWDix+X1blnCtMob3txBLT5q4a/z/OHxote2yH9Uc/3tacslMT0dVUTQ4y6TKnS08gJB5l171kRWnoXg3I9hlIBRavcgOWuZ+CHu9I6Yl8WNYnGXrVX8+E/DlP30ws5gVvHSi3/YKo8A0TH57DjgnT6uMMtKLawr+PuHehdss3bjlgb4EohkAOK2vq/LDjof5ESOEaJXmXgVJ+zcRmUL8kfziITS+YqFb18ABqmp+0I8EsyIpphbBocQeQkLw/E/1Tq84M6IIHmhB7aOBcMvdg+cozDZcO85V6ERa3YcJbs7+i+bZ8cXkj7ylCLLFUzdVIQCwdCLkb+8oHJ81MX31iU20f+VU+mNURS3nd8jW5uSflKu7urCRcHLESz2+1Bga/0AWYbqYpJPKd6O40bOSPy7Mo3VAr"
`endif