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

module eth_f_data_sync #(
    parameter WIDTH = 32
) (
    input   logic               aclr,

    input   logic               clk_in,
    input   logic   [WIDTH-1:0] data_in,
    input   logic               clk_out,
    output  logic   [WIDTH-1:0] data_out
);

    logic   reset_in;
    logic   valid;
    logic   valid_last;
    logic   valid_sync;

    logic   ack;
    logic   ack_last;
    logic   ack_sync;

    logic   [WIDTH-1:0] din_reg;

    always_ff @(posedge clk_in or posedge aclr) begin
        if (aclr) begin
		valid <= 1'b0;
        end else begin
            valid   <= ~ack_sync;
        end
    end

    always_ff @(posedge clk_in) begin
	    valid_last <= valid;
        if (valid && !valid_last) begin
            din_reg <= data_in;
        end else begin
            din_reg <= din_reg;
        end
    end

    always_ff @(posedge clk_out) begin
        ack         <= valid_sync;
        ack_last    <= ack;

        if (ack && !ack_last) begin
            data_out <= din_reg;
        end
    end

//    eth_f_reset_synchronizer rst_sync_0 (
//        .aclr       (aclr),
//        .clk        (clk_in),
//        .aclr_sync  (reset_in)
//    );

    eth_f_altera_std_synchronizer_nocut rst_sync_0 (
        .clk     (clk_in),
        .reset_n (1'b1),
        .din     (aclr),
        .dout    (reset_in)
    );

    eth_f_altera_std_synchronizer_nocut valid_sync_0 (
        .clk     (clk_out),
        .reset_n (1'b1),
        .din     (valid),
        .dout    (valid_sync)
    );

    eth_f_altera_std_synchronizer_nocut ack_sync_0 (
        .clk     (clk_in),
        .reset_n (1'b1),
        .din     (ack),
        .dout    (ack_sync)
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ18U2YIjT2nWPPcBPnF6HNBmbFog0EfbQ0dtWvmCVxsITtStY3IwT2gQXDYmVESSHiIxuaBcU4ZVVOWU8/ytHc3duziZ1Dv+cPCPIsBSB3u7dCq2+9yWQwMMUjiAJfGvIWcIl75u6xuVJeW0cieoVNwzfD8rNba2VjQzYsx8GndZsb9UcS2Kid3NJuXxDVsgBt2jEzCxD/4m2sP4dLV1UwkxkwEGVIEK641+9MnXMhi915Qbol43weBbV6QnxGF/sEnTfPMOSp76I9UpfT2j2i89pJfOZ03N8GXbRoS3PitUntPU4WVIpzxIQfvcE610GN9A58F2s6f7JlTAzlBVAzV/79UnzPvcTYHyEf+47ltPwNdu53/yBn/PTw+7UPHEGqkuBpYjgPqWAMtPgp/1IaQvrs0hVfbFdSTsTTiFk01bhLXUOed9BoQMuGm+nRmWf0g+Ykroegj4D1JKOyMs3M6QKwsJ/3rqv2SA0kmLRgT7zyNsHyrA48r7hbRjVv5rhyuCeuA5LC2obvSq50MMSN2gGkelxnfafoTkwYAvJguV1UpZwT+RAnpu49q4LOGoBzmrGhRdBQ+9qB8E2SFZ9fCsOTQcVmy0PbT/CgXKXRoKYEYEXEjsQq9j2xpubyKIZxpRSKwzoRAGGKlgXi8R6RJt4yIbG8ATu/VBYrRMLyc5UDYeVl7AXUCr70SUBRdMNrfz4rC+gKNeYF9QwoqjcGa/1Ii9In/1d98X1qCNgVGuWztCy0KccvI0VLqdVUx9lxIeucyaZPY7LSGb0xq/LFG"
`endif