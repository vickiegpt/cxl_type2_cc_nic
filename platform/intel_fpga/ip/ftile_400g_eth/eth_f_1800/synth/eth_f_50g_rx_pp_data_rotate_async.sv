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
module eth_f_50g_rx_pp_data_rotate_async #(
    parameter WIDTH = 8,
    parameter PREAMBLE_PASSTHROUGH = 0
) (
    input   logic                       i_clk,
    input   logic   [1:0]               i_index,
    input   wire    [0:3][WIDTH-1:0]    i_data,
    output  logic   [0:1][WIDTH-1:0]    o_data,
    output  logic        [WIDTH-1:0]    o_preamble
);

generate
if(PREAMBLE_PASSTHROUGH == 1) begin
    always_ff @(posedge i_clk) begin
        case (i_index)
            2'd0 : o_data   <= {i_data[0], i_data[1]};
            2'd1 : o_data   <= {i_data[1], i_data[2]};
            2'd2 : o_data   <= {i_data[2], i_data[3]};
            2'd3 : o_data   <= {i_data[3], i_data[0]};
        endcase
        case (i_index)
            2'd0 : o_preamble <= i_data[3];
            2'd1 : o_preamble <= i_data[0];
            2'd2 : o_preamble <= i_data[1];
            2'd3 : o_preamble <= i_data[2];
        endcase
    end
end    
else begin
    always_ff @(posedge i_clk) begin
        case (i_index[0])
            1'd0 : o_data <= {i_data[0], i_data[1]};
            1'd1 : o_data <= {i_data[1], i_data[0]};
        endcase
    end
	 assign o_preamble = 64'b0;
end    
endgenerate 

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q472uMAzhtbYINRe+Wn9rDpXE2AGoudeNfAar/8HGeiPJm0asAQH5s0YX99AC9ScZPxZfg5Im8TRZwWEDFyr5AjrRpcyfDzgl6l2JK3mBvmCMcdyqvKEiPhKP9Zm4a9O3a+zXEVNZIP7SYsLLq3p3n9F69NMB9eMta+SzKYT+z/vyUDUKijxz3stsW/XqgFi+368be2bYaOYxXax06v3tO+RLQmtKK/aTVQcUY/1foKtNkO8d1JPsJK3eCOzUjuEYhlDYJdhaEZOcngobkt0uxE1DcaTUg2Viic57ab+CqsLxPmgMG4QXIpV3bPQkKCiSa6tvNM6bjzYhIqfO9S2+64mfITwlDKlsOhn0I4sO+3OYMqdSTgUk0fCWLL9kDGuyVjufntbCaO+OjjWIqYostdGq3nDnaAgNgznKhX7TxXeZN+11EJXIIJxGbLTVVJ8qYok3jgxyMZuWdefkdpwQMrfK2fBubYAb7neLeyUsB++UhsjTj/6giqZ58OUHmqG5Nzmj0K+MPcB3SzsyuYUtsTyKyQAsXJNeXm+W/rcUL+20nYIQZDoKjgzZEtHrlLxLv2V/fQLuREcA6vOsWdVQswIPEZU9MC9R9hwws2QjAvdOD3anfByBLCqrWPWG/t7xmEnWYE2eIeVUmDJCONTYl9pBcBrYpkf8ehB4mD90dyZJAIqWTCC7SquUN9VBGg+T5M8+DyH68VbcQi89KWfmJr9wXYsrPk+2h6MnkHHYZbNCOOhavUb9m+FuHn9oAMv0bKgyMaKaRZDCDfsJesTPocB"
`endif