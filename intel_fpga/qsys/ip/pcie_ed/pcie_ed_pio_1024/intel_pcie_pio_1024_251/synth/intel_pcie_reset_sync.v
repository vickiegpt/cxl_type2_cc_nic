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


// (C) 2001-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporat's design                tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

//`default_nettype none

module intel_pcie_reset_sync #(
  parameter                  WIDTH_RST              = 1
) (
  input                      clk,
  input                      rst_n,
  output [WIDTH_RST-1:0]     srst_n
);

  wire                       sync_rst_n;

  reg   [WIDTH_RST-1:0]      sync_rst_n_r /* synthesis dont_merge */;
  reg   [WIDTH_RST-1:0]      sync_rst_n_rr /* synthesis dont_merge */;

  assign srst_n              = sync_rst_n_rr;

  intel_std_synchronizer_nocut sync (.clk (clk), .reset_n (rst_n), .din (1'b1), .dout (sync_rst_n) );

  always @(posedge clk) begin
    sync_rst_n_r             <= {(WIDTH_RST){sync_rst_n}};
    sync_rst_n_rr            <= {(WIDTH_RST){sync_rst_n_r}};
  end 


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "Ct7RU5a/p+bqNMEu7Q8vVGkxrD9sml63wG3pH4RTYVLEkGP54+ko4S6h4izCOGh2sb1MtzKT4NgdJp4xN+yn2JGIZmbeOFlk7RGH2eFw9e3st+RwkxWCxS7KD1tPqriXtOc8UJty5UDKXbnNqnBAVeHZ6nPhWp1yOkMMqFi8IxMQBLtdbH85F6ety+Cx+QHBoe8B/SyEjMHeHo/WVdxxY872sbe9f+B4kDnQPeiLXt5gP0fgYVpD8B5bjrO9iG+zMBawSjiTWZiza1H6zik8gMz3XxV4Auwjgz4I8iisEizcBZfT2vmiB7GV5kIZauwxulr31N6bV8ZNe/Jz6i30yLbGcuKrgwyrVuvvYiO78PYorLFP8d1c8UCELwRAPH23/3c9Sr32WQ44eE6FxBLG7pRJRt+pDG1maVm3WBHcsPHrG7FM6auS/Td7bG4ycCFWzt0bIxsZP8UdiLAIG+2jOExr54G1N5uPVJVw09Z3Hn/vD5S+OiTveZYmAqKK42J0Elqd/k/UdvaijS+KXJW4llf/2jtq//dnbEXo+xw0pxOFSnVWV53r5WQsFqSSF1GtGa3RlwZWEAnY82S7Uj8hCmK32kV7cdC9+BipSQgjbGxDuAiEDMffZVsWjDRCPGvoG/GViKIJfMjyA06G7Sf3gLDKKXoeaxMURtn0VPLcnUuS3G1dDni3lRane91gv3M+l1mIGtbyiL593iJUSfdMoA78DgjjwSW6wF4ZTdMsbmGtVmTyiKy5xws8zIJ9Z3buuKGvyyjhrdqp5yEDBCQ68zsp6N/Dp2/mQyHM+Xt5MppgiTABAFqg/0VTfkYf43HsV1J/pMCVY3ovatnHr1YO/7AkdP03cgDZ6S2KR+SVAEumnnUgqOjE9BIT27tfr8Ygpr295qOimG96Z3Bl9+w3/jja1zhhiqrdVkuSED5S6uj6aP/RXc9JI7QkJq0Aiz7eF0E6c8YEDHFkMZ76AZWy8VQ3bluZDEmbd5f7jBtUjTiSwy+IWomZhbB+6wCTj+Px"
`endif