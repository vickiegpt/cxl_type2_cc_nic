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

module eth_f_pointer_synchronizer #(
    parameter WIDTH = 16,
parameter SIM_EMULATE = 1'b0
) (
    input   logic             clk_in,
    input   logic [WIDTH-1:0] ptr_in,

    input   logic             clk_out,
    output  logic [WIDTH-1:0] ptr_out
);

    logic [WIDTH-1:0] ptr_gray;
    logic [WIDTH-1:0] ptr_gray_reg;

    logic [WIDTH-1:0] ptr_gray_s1;
    logic [WIDTH-1:0] ptr_gray_s2;
    logic [WIDTH-1:0] ptr_gray_sync;

    logic [WIDTH-1:0] ptr_out_wire;

    eth_f_bin_to_gray #(
        .WIDTH      (WIDTH)
    ) b2g (
        .bin_value  (ptr_in),
        .gray_value (ptr_gray)
    );




//`ifdef ALTERA_RESERVED_QIS
//localparam SIM_EMULATE = 1'b0;
//`else
//localparam SIM_EMULATE = 1'b1;
//`endif
 
  

intc_sync6_m #(
	.SIM_EMULATE(SIM_EMULATE) 
 ) mlab_sync (
			   .din_clk(clk_in),
			   .din(ptr_gray),
			   .dout_clk(clk_out),
			   .dout(ptr_gray_sync)
		   );
			   

/* -----\/----- EXCLUDED -----\/-----
    always_ff @(posedge clk_in) begin
        ptr_gray_reg    <= ptr_gray;
    end

    always_ff @(posedge clk_out) begin
        ptr_gray_s1     <= ptr_gray_reg;
        ptr_gray_s2     <= ptr_gray_s1;
        ptr_gray_sync   <= ptr_gray_s2;
    end
 -----/\----- EXCLUDED -----/\----- */

    eth_f_gray_to_bin #(
        .WIDTH      (WIDTH)
    ) g2b_read (
        .gray_value (ptr_gray_sync),
        .bin_value  (ptr_out_wire)
    );

    always_ff @(posedge clk_out) begin
        ptr_out <= ptr_out_wire;
    end
endmodule

module eth_f_gray_to_bin #(
    parameter WIDTH = 8
) (
    input   logic   [WIDTH-1:0] gray_value,
    output  logic   [WIDTH-1:0] bin_value
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i=i+1) begin : bit_loop
            assign bin_value[i] = ^gray_value[(WIDTH-1):i];
        end
    endgenerate
endmodule

module eth_f_bin_to_gray #(
    parameter WIDTH = 8
) (
    input   logic   [WIDTH-1:0] bin_value,
    output  logic   [WIDTH-1:0] gray_value
);

    genvar i;
    generate
        for (i = 0; i < (WIDTH-1); i=i+1) begin : bit_loop
            assign gray_value[i] = bin_value[i] ^ bin_value[i+1];
        end
        assign gray_value[WIDTH-1] = bin_value[WIDTH-1];
    endgenerate
endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ0R4motYtDhX3pS+1eH2Yp6j36EL0TxZKFQESweOUOxp/JzgwY9IB3wluaAqUh/TTVWh8uxwnwu+ZqfhlCLJAi2NF4kwJW6KVE6WLNr8K0whwv8MI2bMLtvRckBRwCQaYxeGKaRXJFJMcC56k3E9rMVi30uC6/lNgSPlVx7F7N6e+3ZixJ2tEQ1d99PHmON3CkWqvSCqpyyC4yQWDrOsD7kh0LcMMzQ3I+yTgqCjZa0RwtcowxwWeBidYyn680+AisebVKqSIjGMRcABfeSmNDFEkYJWBzHRJZ2ZsqLnA3ypuDPeqN0FSpKXTixcE8CI2Xd7iEusx8SldzRVE+uTsYKLsqqEk/1Zk4eB6VwSOANLaetbLFyJChiJSLvWnwxRF2vPMb1dQeAzhfiW6DWRpOEF0VCBD2guZjtILRzsxkcKfx8wElOiXvY+vVCWhZPsgQnvGWNzJXt/QFbXXb+ZubU5IGRNl7ZxgIoWG0WrJ/r3xvjtu/H2B5ZlJc6M1XzeW15xZiFfbDuNQrQnsv9tVHgPbRXQYKF3Hy1hDbNPgrkF3fJp6CTeiGRanCPHb/AmO1p47QNpVWyzg/IHeDQzg1zOWw/IFm5pul7kMED8kYA44b7ddkISGHcI/B8GAPySrXcANfuqs+ZkFKfVQJ2cRNIic5e+VcJLtVT8SfTaXqQBi/DSyfe6ZdDKqcZbdr8y8KNx8o2aEh8I7Tw8Yta55JJjqPzWuq9ELNvZkFU1/Ay9aJxf+hzIgLuvD0zDCZf03+fS88k9pShE0dcuwyH8mVB"
`endif