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


module eth_f_50g_rx_pp_block_shifter #(
    parameter PW = 7
    ) (
    input   logic               i_clk,
    input   logic               i_reset,
    input   logic               i_valid,
    input   logic   [0:1]       i_inframe,
    input   logic   [PW-1:0]    i_ptr,
    output  logic   [PW-1:0]    o_ptr,
    output  logic               o_valid
);

    logic   phase;  // Phase of next block [0,1]
    logic   if_last;

    logic   [1:0]   sop;

    assign sop = i_inframe & ~{if_last, i_inframe[0]};

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase   <= 1'd0;
        end else begin
            if (i_valid) begin
                case (sop) inside
                    2'b00 : phase <= phase;
                    2'b01 : phase <= 1'd1;
                    2'b1? : phase <= 1'd0;
                endcase
            end else begin
                phase <= phase;
            end
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            if_last <= 1'b0;
        end else begin
            if_last <= i_valid ? i_inframe[1] : if_last;
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            o_valid <= 1'b0;
        end else begin
            o_valid <= i_valid;
        end
    end

    always_ff @(posedge i_clk) begin
        if (phase) begin
            case (sop[1]) inside
                1'b0 : o_ptr <= i_ptr - 1'b1;
                1'b1 : o_ptr <= i_ptr;
            endcase
        end else begin
            o_ptr <= i_ptr;
        end
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45JcBpOYoUBg4OqBS0Z3nQrvApSwBnIBIlLch8C2uTZ9JCzEj3ErAuFgWp42pxQDsdCOnxK+JD3Ie13JvwE6dEj5+hyh3hgNMhWSqnoUaUKqzROE34yg3e6sYcUBQo1CpmYVgZMd/2qn2pA1piLe1I4llfa29eOd4MYlvFUgZbJNQTipd+fiWEDNNI679p3J40nWkvCmaXi4QrhyMI9uATnRORZrHzFg4jUQaWV8p0XK7rssuzavnevWUXl357YodlmHMFXMezEBhlQrlIDhVM2nYz6Tl8OU+vKDe7nH7jtQEGHZEQMIQcdCIcm5UoYEy77D7ZhkLVvsxuba7zQg1h930CJNOBo5CNpB+DgpVLtUPZYcPaAe7IFXGGcq9gsorNmtIABrVeWJD/YGela6cicYm+S8XS7XJDe9d2vBY2WcLqm1Upf4CfyHFAfBCM7gMABvNLVOJGlcfu9NkPkNNTHPJv3LhaWHndWTTLl7xAEW9c1Y2V8mBPxXdi0PzXlQsHVo/RikrcbTHn4IjeVOZIvhLb5yO9vPby0uLfrGcGUyEU3koWAxf2PDLj0b7IK6KOzpcBuHtMk+j5NGCStzpDcn4P4X2GWe8aAQhNPvfzQdSA74Cf4Bb4VjtuFrKqhaeuRyv+smJBC/HE7X1oov1gRBs5tjoee/Q54PWu+1lh4/2sN9OzhB+8e9hq/BSStF0jL4tdg8j21DF6ejFb3JNGEsmDBPoKMExrKsZNBp328H89F8oQtO23fxQNc6nFEw025tLxpu81AmxIJIMV7sNvZ"
`endif