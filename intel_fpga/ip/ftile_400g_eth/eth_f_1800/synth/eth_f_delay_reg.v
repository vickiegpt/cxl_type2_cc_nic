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

module eth_f_delay_reg #(
    parameter CYCLES = 3,
    parameter WIDTH = 1
) (
    input              clk,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i=i+1) begin : bit_loop
            eth_f_delay_reg_1b #(
                .CYCLES (CYCLES)
            ) delay_1b (
                .clk    (clk),
                .din    (din[i]),
                .dout   (dout[i])
            );
        end
    endgenerate
endmodule

module eth_f_delay_reg_1b #(
    parameter CYCLES = 1
) (
    input   clk,
    input   din,
    output  dout
);

    generate
        if (CYCLES == 0) begin : g_0_cycle
            assign dout = din;
        end else if (CYCLES == 1) begin : g_1_cycle
            reg state;
            always @(posedge clk) state <= din;
            assign dout = state;
        end else begin : g_n_cycle
            reg [CYCLES-1:0] state;
            always @(posedge clk) state <= {din, state[CYCLES-1:1]};
            assign dout = state[0];
        end
    endgenerate
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ0CHJrpEbW6k6yguEOBgVc6k+dO7VRnOb6aOcWzJ6j9VMYDzzkLnkOqiRg6839mhW4qHw4Og13RPQQwMtItv6iuz5P8H5E4NiDhidCVbC3rVuDBfW1YlFZ4DhOZULd3bKTcOtzv6A/vCsizIPyjr6UByt5hqZLAO8XJ8b/eX0IkHGKUwnmA/zSQIpurdslHjHyavXUR2rYVm82POAq0RwLrfqtT6J4Y8ME3Lzq4nnYfNkjhzYK0TEqAyrK1w4F4WPiFIxyTb1FAsnGpEfRH6/f485G0yhnQegl7OuYorcrkuUpYB/xeU/T01UAv7pC3AMU9YeHJrvpqWDiwOPBFiEaqeRNPUuorhDZOKf21JiUym9j30zm6ZwdlBfDJBAVhPnE67mX6l6zil3Egr/BpJBuUi9vXNQtd6EFAaG/56HpL+eh6s9g35KwgEi6G4oZmo9s3pWE9VaiDDUOGoSwxbGIoFZjZHoWr25qah/ieEJY6QqtgWyBgaS/iFxL+5WoPrzrkFXTqWZXtvkeCHRr88ymhr+y18OTlPayzJW9w25qANOjbX+sQR5MA9xlWnEHLt/5VjJcpUTR27JteRhJ6n/8pVGppD+z9X2x9JHaFgSFytnrI7l6oTuIz+2o5kbGQUku0ZG5Gzi9ylWf8pSg/5emi/Nb3v/lsSoVgOSWUtE8YwHbLiKe3Xd7GjuYT1u8cNOcT6h8L4vZkK8aGE9hZM2OKoGLl5Y8rM/vi3il/25OHhUJc+qCnlEi21xji4M6M2wRBsG+HhTDkJUB9Rp4IwYHo"
`endif