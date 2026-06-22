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


// Clock Monitors

module eth_f_clock_mon
  #(
    parameter SIM_HURRY   = 1'b0,
    parameter SIM_EMULATE = 1'b0
    )
   
   (
    input wire 	      csr_clk,
    input wire 	      clk_tx,
    input wire 	      clk_rx,
    input wire 	      clk_pll,
    input wire 	      clk_tx_div,
    input wire 	      clk_rec_div64,
    input wire 	      clk_rec_div,

    output reg [31:0] clk_tx_khz,
    output reg [31:0] clk_rx_khz,
    output reg [31:0] clk_pll_khz,
    output reg [31:0] clk_tx_div_khz,
    output reg [31:0] clk_rec_div64_khz,
    output reg [31:0] clk_rec_div_khz          
    
    );
   
//// output mapping is as follows - 000		, 101			,100		,011	,010	,001	   
wire [7:0] mon_clocks = {2'b00, clk_rec_div, clk_rec_div64, clk_tx_div, clk_pll, clk_rx, clk_tx};  
reg [2:0] mon_clock_sel = 3'b000;
wire mon_clock_rate_fresh;
wire [15:0] mon_clock_rate;
eth_f_fmon8 fm0 (
    .clk        (csr_clk),
    .din        (mon_clocks),
    .din_sel    (mon_clock_sel),
    .dout       (mon_clock_rate),
    .dout_fresh (mon_clock_rate_fresh)
);
defparam fm0 .SIM_HURRY   = SIM_HURRY;
defparam fm0 .SIM_EMULATE = SIM_EMULATE;

always @(posedge csr_clk) begin
    if (mon_clock_rate_fresh) begin
        if (mon_clock_sel == 3'b101)
            mon_clock_sel   <=  3'b000;
        else
            mon_clock_sel   <=  mon_clock_sel + 1'b1;
    end
end

reg [31:0]  clk_unused_khz;

//moving the 5th input to 0th mapping of the mux as the previous value is latched for the new mux value inside eth_f_fmon8
always @(posedge csr_clk) begin
    if (mon_clock_rate_fresh) begin
        case (mon_clock_sel)
            3'b000:  clk_rec_div_khz          <=  {16'b0, mon_clock_rate};
            3'b001:  clk_tx_khz          <=  {16'b0, mon_clock_rate};
            3'b010:  clk_rx_khz         <=  {16'b0, mon_clock_rate};
            3'b011:  clk_pll_khz      <=  {16'b0, mon_clock_rate};
            3'b100:  clk_tx_div_khz     <=  {16'b0, mon_clock_rate};
            3'b101:  clk_rec_div64_khz   <=  {16'b0, mon_clock_rate};
            default: clk_unused_khz      <=  {16'b0, mon_clock_rate};
        endcase
    end
end

endmodule // eth_f_clock_mon
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapUNxhtXNfxClrGT97IBLtVf1P2xK/tcYse7SsK1TyIZJ4foKaQPJiF6Ad47NavrGqotMfrwOST0/cK0sey7E6+sOgYat3hnGU/pT0Zk85P0HUjXkaYHBg6qj3yK0RwSwdJ6EwgTJir/W1+saGO+Qb8rHEj4UdDMb6HvQTevLYX+ViOfrs7U12qNH/NSV4/jJHqszvxQCqJdwi7oBwelUfmxpEJfKKOCfnitc7NyYizgF6o33kFwRgyjb3eCrsRc1YKYFBWVDAfoPh75ep/tXKBGdXCA/zWbZ/D2pUvEgUZN9/8S0fP4GMhw5IR0LiLe7Qlt6WkF5A8QkY2Iy6CXlpMAI8XPII370UInSbTUq6CZ20he2FABkQCoxQ4FFkgPBZlgtgPH3vPHmHOOLBLE7VtpoxtzAkJz7Ld6M+P8O4cR1TqAHzj1eu3JIR7gom9JPRcpI+VUQ9p9b2ayyaoIJcmvaXNeH5W4kBbqnK/uPBsdPWx/OhWguC0hwyLl/+iWu5tcg6f4vtBN5BZwyMXlkfOOK+0ndUtM3K9HUXB6lkQo7GVlAoSD2l1VhcelDQmkODRKySihDgljgsjhcWUQxXKOFhrnWq1hQ+94Ce+o3pSIIiesnM33UynH2wMICg5MZCc4Ts/XfWeBu3ky8YniaKCxcKC0EkHmfFtyePICNB+KFoXySjle/40UfNqS4ucfJASKQcDFT6lUGU0QSGJNUbmAZMuZ3ZSVJYVBh+qqQ9mWCtLu5R+BNJ9WF1fk4KVS/f+lWbyR1MUmA8vjwjIamP6i"
`endif