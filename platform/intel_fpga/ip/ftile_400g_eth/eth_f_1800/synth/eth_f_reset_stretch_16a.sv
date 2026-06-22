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
module eth_f_reset_stretch_16a #(
	parameter EHIP_RATE             = "100G",
	parameter COUNT_VAR       = (EHIP_RATE == "100G") ? 1'd1 : 4'd1
) (
    input   logic   i_reset,
    input   logic   i_clk,
    output  logic   o_reset
);
    logic   [3:0]   timer;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            timer   <= 4'hF;
            o_reset <= 1'b1;
        end else begin
            if (timer == 4'd0) begin
                timer   <= timer;
                o_reset <= 1'b0;
            end else begin
                timer   <= timer - COUNT_VAR;
                o_reset <= 1'b1;
            end
        end
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q46IaE9OTGo8oF+DPFTw7g450VM+voQCGuT1rR6V8qwFjVWOHGQpRvJ4okAYgGFS/iLlBJ3S8kI2L3aROYNf57cIJY9Te9j985Rfic6x0zRFWlWF5eNQZd5pBujL/xgmPMIOMSeQIloPuD7uUUqQ0ZBxAH9XzsXciD2SaCIWP/fS/CyAwj9po3nDFNZNx8k0qNT41VWeiJGu3RDkAuW4A6xEB1V9g4QYyBJPpV44TtwuTdwMUHgsDqGrRlHBhYZr6Mjp9zVui7zs334yK4Ub3f/mbXPJgQaZ4F6XyZkH6xyI5IaA/NyZjP5RWTghm+WH+yOxwogBa5fEvNBQJTK7RBJDCsy5sqEXvMwuDcUBqJa8FVUBRGlp9P9WRh5KMRBBU7JpNa+P3oCAulBLgAWzAgUKBa7zmITTmafa921savg4Q4POr4ZqJ8SwDozAU308onYmO02Ac3Ewk7JheqxFspFojDWxZGXMT8P1C/aOl02lnHv8d2QxjArrduVBv9xe5lV3ilJTLCZQCjchcZ8uNmoeA0iHif7GnhNgxEihYl6E23CPqzDJd35Cm0SHgl1uIAzPls2pTYzixmkdqgBwYaVXAioBH0ZAGpNBHDRl+XbbLPjwxru/k+5r/Bg7+QSykBDoMtZwn+5dhqg0y6xNQJ8y2dM1OtSMNlCoIOEtoEzLypnjD9soRGKdnYiJJWizKBLKHEktomOVvdavzF11DWpd34+YSRlgVA6g73JWS2POV23L9zBOIy6eyXu+v6iHdMRPhnvjJtLrwwQrXecpjYoE"
`endif