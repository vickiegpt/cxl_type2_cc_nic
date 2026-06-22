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
// RX SEGEMNT to AVST interface bit re-ordering
//------------------------------------------------------------------------------

`timescale 1ps/1ps

module eth_f_rx_avst_reverse #(
       parameter AIB_LANES         = 1
)(
input  [AIB_LANES*64-1:0]  i_rx_data,
input  [AIB_LANES-1:0]     i_rx_inframe,
input  [AIB_LANES*3-1:0]   i_rx_empty,
input  [AIB_LANES*2-1:0]   i_rx_error,
input  [AIB_LANES-1:0]     i_rx_fcs_error,
input  [AIB_LANES*3-1:0]   i_rx_status,
output [AIB_LANES*64-1:0]  o_rx_data_avst,
output [AIB_LANES-1:0]     o_rx_inframe_avst,
output [AIB_LANES*3-1:0]   o_rx_empty_avst,
output [AIB_LANES-1:0]     o_rx_fcs_error_avst,
output [AIB_LANES*2-1:0]   o_rx_error_avst,
output [AIB_LANES*3-1:0]   o_rx_status_avst
);
       eth_f_reverse_bytes #(
            .NUM_BYTES      (AIB_LANES*8)
       ) reverse_data_rx (
            .din(i_rx_data),
            .dout(o_rx_data_avst)
       );
       eth_f_reverse_3bits #(
            .NUM_SYMBOL     (AIB_LANES)
       ) reverse_empty_rx (
            .din(i_rx_empty),
            .dout(o_rx_empty_avst)
       );
       eth_f_reverse_bits #(
            .WIDTH      (AIB_LANES)
       ) reverse_inframe_rx (
            .din(i_rx_inframe),
            .dout(o_rx_inframe_avst)
       );
       eth_f_reverse_2bits #(
            .NUM_SYMBOL     (AIB_LANES)
       ) reverse_error_rx (
            .din(i_rx_error),
            .dout(o_rx_error_avst)
       );
       eth_f_reverse_bits #(
            .WIDTH      (AIB_LANES)
       ) reverse_fcs_rx (
            .din(i_rx_fcs_error),
            .dout(o_rx_fcs_error_avst)
       );
       eth_f_reverse_3bits #(
            .NUM_SYMBOL     (AIB_LANES)
       ) reverse_status_rx (
            .din(i_rx_status),
            .dout(o_rx_status_avst)
       );

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapViTFLEnTccFrgF0ASkeI4GGNcC8uuSo5yP9NehnhMPUdiYWlW4crtvaBS7GvOZAoFalbfEYy/TnJKPxUKOPkz6fkMI89p55DItM0SpSAbhg2YBM36omaw8W8CB8njF8EMYcWslL3me+tKSEq/vdyGOL97StftZoQDyZdKOmtlmx+gzTKRgXH/wcW9rc9c3hoUYa4hxfWcVNEMTjL8IFNjDeMRj501hPNY6+tzGejtwy2wDnU46OSWzcWafPgdeoGipLyR0pZ+RMJhvYl89Pe8HYqczXMd5VmvyCURcAgOCRolsNB/yegbJRjbCaJQUw0PgWPh/pdyT1wqXtnxG0XfZokuzcSmNMWtaSFRhr4DQXkYnJvJ52hcBVLMh/5e/NFr7x+I/qDJnck8JP47e7/vfbOYhIAnYsimjhCZWV6nVMGKQDaLrH6fe+ggF/i/05+hhVStJEkQlMbLHbNJ0wY9Vu7X2oRZxyDXk9aUWV4aIr1jhDX6qxjYxnsbLCKK4LP/uB1R/uLH7i4/kA32tIrc7bjcE7FrVjoXZ7UewHJ3j3TIqGnkzcQtxbJeML+olc7HzFEAA2tpWnbTeZkt7t5d+RKKr4RdPQTdScylxB+CPpHbY9vhRHE+n+FjHqE7vAU1igcJWZKfOcENwCBjAmobrb4xWrRAgpL8YFulklCh2269BEnwMcuGFTGHMi8kxQMnUP5Jy4GDtIkzoJCXQQyi6rFGK7IAYcli0aIGrI/8IYdjYiN19jXblY4hghTXVezc3hl52cfKVi5O/vzTtQOx3"
`endif