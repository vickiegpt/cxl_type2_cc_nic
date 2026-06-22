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


module eth_f_word_delay_mlab #(
    parameter WIDTH         = 32,
    parameter SIM_EMULATE   = 0
) (
    input 	       i_clk,
    input              i_rst,
    input [2:0]        i_delay,
    input [WIDTH-1:0]  i_data,
    output [WIDTH-1:0] o_data
);

    wire    [WIDTH-1:0] o_data_int;
    reg     [WIDTH-1:0] o_data_reg;

    reg [2:0]   write_ptr;
    reg [2:0]   read_ptr ;

    always @(posedge i_clk) begin
       if (i_rst) begin
	  write_ptr <= 3'd0;
	  read_ptr  <= 3'd0;
       end
       else
	 begin
            write_ptr <= 3'(read_ptr + i_delay);
            read_ptr <= 3'(read_ptr + 1'b1);
	 end
    end

    eth_f_mlab #(
        .WIDTH       (WIDTH),
        .ADDR_WIDTH  (5),
        .SIM_EMULATE (SIM_EMULATE)
    ) sm0 (
        .wclk       (i_clk),
        .wena       (1'b1),
        .waddr_reg  ({2'b00, write_ptr}),
        .wdata_reg  (i_data),
        .raddr      ({2'b00, read_ptr}),
        .rdata      (o_data_int)
    );

    always @(posedge i_clk) begin
        if (i_rst)
            o_data_reg <= '0;
        else
            o_data_reg <= o_data_int;
    end

    assign o_data = o_data_reg;
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvezaLj+hn85VZajCCOU3WEZ5QfnJRKP1Zzh0wcB4q0tnjXLUBGibXu52M+22HrClxgsWELgzkueMuKp4yzxEUKHm1dDw0mE/H8bGl+LuHRzAGrR91LNpPnDQyLGmYM4ZQpnA8C0oMmN4n1xlhlnLtExLjSb9Icz+vxZcj1Vvun9vjuunSe6uYhybcXit5iqB9JuBM9hWD8PWQt4e5oAIkyl/4t7TJlexgPFlrSc1HIUwDsJM0K0vR+FBlWG+NA8ZxO+GugfoJibg+eQOMPbbM4oPadUVHUJDT7FPC/yrZ+3SEdgspNxDQksTUTX20k+3B4A0tv5lVjt+s8TvkEpXWtRI91Peh0kxDYsf8QNUvAgmiPcrVpNmzSoh+KT92o4ca9hJ4CIRnlO4O3J18SXOokQbVZX9q94jwFp3aeylLoqeUWW9StI3imCHOMJoETiLZRYehe1FHu2dUefKvz/BrimorYvYU/PYClhpF53MCLsSYCH+47mOv6N2ysTUofBTD1AirxJ6d/RxO7jLya47uk6b+p1XkCNCfSIcH+mc21Agl+4T0jyGG57ki2W2tuyDVPH2gDi5Au/OGL4CAfTVmqOxi9UAeb/oNaaUNv6oTfO1z76U6lmFxTMZcvZJTUZ2draOzVFTkBONT1bFN/SLvPWSXwaIv486H3u9tPeLKuGwwvYmLQ+ubEP3rMcApTASLtpsuUrEirAwPwwyeEenrVuLTYwp9mKqa4piyCRmYMy+SBJrNJT8IQvwA2dm4Hd5JA4OUrM+YOonsa5Cn7ekvnP"
`endif