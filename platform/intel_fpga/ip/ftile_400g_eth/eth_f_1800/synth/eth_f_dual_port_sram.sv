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


// Dual port RAM module designed to
// infer a RAM block
module eth_f_dual_port_sram #(
    parameter WIDTH     = 8,
    parameter DEPTH     = 16,
    parameter ADDR_BITS = $clog2(DEPTH)
) (
    input                   read_clk,
    input  [ADDR_BITS-1:0]  read_addr,
    input                   read,
    output reg [WIDTH-1:0]  read_data,

    input                   write_clk,
    input  [ADDR_BITS-1:0]  write_addr,
    input                   write,
    input  [WIDTH-1:0]      write_data
);

wire rdenA,wrenB,clocken2,clocken3;
wire [WIDTH-1:0] dataB;
assign rdenA = 1'b1;
assign wrenB = 1'b0;
assign clocken2 = 1'b1;
assign clocken3 = 1'b1;
assign dataB = {WIDTH{1'b1}};
altsyncram fifo_altsyncram
    (
// Read 
        .clock0          (write_clk),
        .clocken0        (1'b1),
        .aclr0           (1'b0),
        .address_a       (write_addr),
        .byteena_a       (1'b1),
        .wren_a          (write),
        .rden_a          (rdenA),
        .data_a          (write_data),
        .q_a             (),
        .addressstall_a  (1'b0),
// Write
        .clock1          (read_clk),
        .clocken1        (1'b1),
        .aclr1           (1'b0),
        .address_b       (read_addr),
        .byteena_b       (1'b1),
        .wren_b          (wrenB),
        .rden_b          (read),
        .data_b          (dataB),
        .q_b             (read_data),
        .addressstall_b  (1'b0),
        .eccstatus       (),
        .clocken2        (clocken2),
        .clocken3        (clocken3)
    );
 
  defparam fifo_altsyncram.width_a         = WIDTH,
           fifo_altsyncram.widthad_a       = ADDR_BITS,
           fifo_altsyncram.width_byteena_a = 1,
           fifo_altsyncram.numwords_a      = 1 << ADDR_BITS,
			  fifo_altsyncram.width_b         = WIDTH,
           fifo_altsyncram.widthad_b       = ADDR_BITS,
           fifo_altsyncram.width_byteena_b = 1,
           fifo_altsyncram.numwords_b      = 1 << ADDR_BITS,
           fifo_altsyncram.maximum_depth   = DEPTH,
           fifo_altsyncram.lpm_type        = "altsyncram",
           fifo_altsyncram.operation_mode  = "DUAL_PORT",
           fifo_altsyncram.outdata_reg_b   = "UNREGISTERED",
           fifo_altsyncram.ram_block_type  = "M20K",
           fifo_altsyncram.intended_device_family = "Agilex";

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ3ff8bWuN3ypGd4mdODPKp/2B/zT9mqiwzJ3scvBSBDg/401ZHl0yInZXcdos1MovW+WRqCPvBfRy/fBZpkdZnx7fZ2t2OBVvLPo7fQtZS9WhZidrjJdsmApU3WMOb+3DBQyARv6Nl6Oh1zkgnVo0Wj2mSNO97d1ZOoxiShvqgDlGxdu9JFXWU/RynVsz88MiQ0DfbRJQosL8UL9JlCY5f/6fVPnOykj74zYns9W47iFo02+kmdYuQvn3ClGiSWPYeoQc97VED1ck39zhcfPA6moK3TKU6gYSI13nitUzGmiqBVMBGX7xNDODu9ggn3wiay48sLQMOuSoENDjJj7G+gAGMFRt0auxuuPPR5rfecyaAMd/iKT2jSZZwYxo5JGinV0baBXxjPf1e0DS3YD58JoFnwiqnn2gXWbvS3bgsWDqsgbiAAfMuBMeFxVrBqPD+HKOk0nsZo52JcRLVshKKmk+lN60cG6zEfnjh/yNeVJPRKlbZ79Oj2rEQRehsWJcm/hItaq/PvOoppuA3MynLvD5rxqkzTGgqg6ijZGTVPwi/u4w9SH8tu/IgRUjpDKrmy98T0CRSMcCd6/4r7M4x6eP9l+mjnj1fnoFfQQITT8+eaJfhc6ls+fzPOvrclb6T0mPrO6i6WwIyFBBGXqCrD/UsKBzzSZNlzSbnux4LG/9qANpWFO1vdkOOFtJMqG62MqN2VSU2F2D1Ws3ts1WozFyfEpTpEEuCB5yxjtglJmBkG7IvQX/GQjgWQ4yELPgtV+CdH6qjqdz3VYXWczgMu"
`endif