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
// TX AVST to SEGMENT interface bit re-ordering
//------------------------------------------------------------------------------

`timescale 1ps/1ps

module eth_f_tx_avst_reverse #(
       parameter AIB_LANES         = 1
)(
input  [AIB_LANES*64-1:0]  i_tx_data_avst,
input  [AIB_LANES-1:0]     i_tx_inframe_avst,
input  [AIB_LANES*3-1:0]   i_tx_empty_avst,
input  [AIB_LANES-1:0]     i_tx_error_avst,
input  [AIB_LANES-1:0]     i_tx_skip_crc_avst,
output [AIB_LANES*64-1:0]  o_tx_data,
output [AIB_LANES-1:0]     o_tx_inframe,
output [AIB_LANES*3-1:0]   o_tx_empty,
output [AIB_LANES-1:0]     o_tx_skip_crc,
output [AIB_LANES-1:0]     o_tx_error
);

       eth_f_reverse_bytes #(
            .NUM_BYTES      (AIB_LANES*8)
       ) reverse_data_tx (
            .din(i_tx_data_avst),
            .dout(o_tx_data)
       );
       eth_f_reverse_3bits #(
            .NUM_SYMBOL     (AIB_LANES)
       ) reverse_empty_tx (
            .din(i_tx_empty_avst),
            .dout(o_tx_empty)
       );
       eth_f_reverse_bits #(
            .WIDTH      (AIB_LANES)
       ) reverse_inframe_tx (
            .din(i_tx_inframe_avst),
            .dout(o_tx_inframe)
       );
       eth_f_reverse_bits #(
            .WIDTH      (AIB_LANES)
       ) reverse_error_tx (
            .din(i_tx_error_avst),
            .dout(o_tx_error)
       );
       eth_f_reverse_bits #(
            .WIDTH      (AIB_LANES)
       ) reverse_skip_crc_tx (
            .din(i_tx_skip_crc_avst),
            .dout(o_tx_skip_crc)
       );

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapVsZdQMmmzKhRejhvuNJOHapzNP8otS+FAoW83qt/afSGhpdl7lvdkxlJqOXEiP0oXzMZnglc1CJFwXDx40Z41+9Q+CCyQ6XQ3gf0Rp8QFTdxUmqMX3AKz17GLA9JT+B+DzZqLF362ptX0JcWRiI6VbaJOf1MH9t+7SIEO3nSlZJKfo7jDJztCuV9JoC8fPZXK+OjHgpw4J8pNoumWKHccWpQ/Lx8pDy/BDLsRurqp6tTlMBNEfWAQ7x75v3cuom+Vc6YYF+UvbFOvwNwy8dLzlYaIqCPlDS+fh+nmdcbGef8Gk92driyWQSIEl9Vd1IHiHqYI/bf+YDop1lxPPzf5Nm9hriPNNP5nYsLdCc+SiCMGbxApMMevCTdqiPW5kmIv21oBy624YdsLNVPd+s0tVDjQ+ZCJ4c6fxL1vYrYU07/mFmf/BNMpAoRPQi/ItwTlQ1y9gLQq3On5M4mmZLfrkhMPROpsgcuIeTc4hUXKS2imIkZLqRDUudBw2k0YVMgfP0LEd6QPKBBFkzVr/hUCPnD5TOqD1qcFImMbtvF7NPAx2mXeoYHhxhwcjQujOURGhAI6P/2mWKtdkYL0b1/KXg8f+1hT4KZ3UvjwrDmzeoI9OQEOvXL8hHigDWM6WHDaao+JbVJu5ImuDfFF/GPRRHaWdMH8ai4XhN9O7fBMVuljTDx/CRUE6FGaG+X6uBU8uzzIwDWBW0r3s/ow46jjdEohB8z7gyOUjnQp+CQgoIqBqK9GxtjCNJPXAZM2uOPco0ZrZqidAX3hMNgqSv+hr"
`endif