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

module eth_f_100g_adapter_rptr_addgen (
    input   logic               clk,
    input   logic   [7:0]       i_ptr,
    output  logic   [0:7][4:0]  o_ptr
);

    genvar i;
    generate
    for (i = 0; i < 8; i++) begin : lane_loop
            always_ff @(posedge clk) o_ptr[i]   <= (i_ptr[2:0] <= i[2:0]) ? i_ptr[7:3] : i_ptr[7:3] + 1'b1;
        end
    endgenerate
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ3augXGtnbWA69yY9vDfwCBptQoXdR412nOa3+rfhghwFC5Lh/6rkLkH/MG1VkXn7XUYVba7Xq14aIv3ba7TrkfJ+0B3ECdWO1309XyhzncdXJDGTSny++E0iXR8I6VP8fclkkCgrjcvY7WgvGQW49N2vsjxqtkE5y+S5wkvi2IduHD5EWxhnvaBnV4npXYVoJ0jf0pS1EXKtzSa529kiKFU2IEzsY5SNEjzDWUb3G6j6gJtI58nXwSIMRiCCE49lisISxSMyztVG4X4ZrXnPSyT3tA5PIY3F2J5a2walqmPK1aI4+5Tw8EKISN3Q5n1ukXfBS9EzAvFKpK14XDdtmNvyuqap1XkAyYZ0o4T+cNwY4mlc0O5JsKeIeSCuBS+2YmKFH6TUhCS2V5+Ioj1BH+cgdqK8yiuzFoofG5P+g2ADQJAYNypLXfG/TsIc29+//L62Y1G+zRq1zpnLiFC98btpPn3COZBpDZWQZduxMu3Y9loiKm7AidP0573G/fJUmiHUjbGCBks3rUWpxr/oEUq5WoE/BH1DVhNIV7GlwNdF8J+eeOUCpihZQYDI+pyrNdpD9kfwbzbfyrjjeNwi3BmE8IhTJGGn7rDBYG+/ri/P3wRB5flC1CSN7lyuFGt6K7exMd7qlQka4qgJhT+W2hvKVACDtSNYq119F9nr80p7d6NXs/4evXmcva8yK3oPfuI3z/jFB4OQRxcd8Wz2GHm3yow8RiJFL8Y5MOGBOUdzwGYyv/TlWqANH55gvIhwE9wJBM+5IrhFYUy52J3A4g"
`endif