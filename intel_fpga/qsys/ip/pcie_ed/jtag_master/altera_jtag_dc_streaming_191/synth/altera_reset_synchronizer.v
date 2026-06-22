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


// $Id: //acds/rel/25.1/ip/iconnect/merlin/altera_reset_controller/altera_reset_synchronizer.v#1 $
// $Revision: #1 $
// $Date: 2025/02/06 $

// -----------------------------------------------
// Reset Synchronizer
// -----------------------------------------------
`timescale 1 ns / 1 ns

module altera_reset_synchronizer
#(
    parameter ASYNC_RESET = 1,
    parameter DEPTH       = 2
)
(
    input   reset_in /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */,

    input   clk,
    output  reset_out
);

    // -----------------------------------------------
    // Synchronizer register chain. We cannot reuse the
    // standard synchronizer in this implementation 
    // because our timing constraints are different.
    //
    // Instead of cutting the timing path to the d-input 
    // on the first flop we need to cut the aclr input.
    // 
    // We omit the "preserve" attribute on the final
    // output register, so that the synthesis tool can
    // duplicate it where needed.
    // -----------------------------------------------
    (*preserve*) reg [DEPTH-1:0] altera_reset_synchronizer_int_chain;
    reg altera_reset_synchronizer_int_chain_out;

    generate if (ASYNC_RESET) begin

        // -----------------------------------------------
        // Assert asynchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk or posedge reset_in) begin
            if (reset_in) begin
                altera_reset_synchronizer_int_chain <= {DEPTH{1'b1}};
                altera_reset_synchronizer_int_chain_out <= 1'b1;
            end
            else begin
                altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
                altera_reset_synchronizer_int_chain[DEPTH-1] <= 0;
                altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
            end
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
     
    end else begin

        // -----------------------------------------------
        // Assert synchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk) begin
            altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
            altera_reset_synchronizer_int_chain[DEPTH-1] <= reset_in;
            altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
 
    end
    endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "SFf2DuiD7DvcEuC7rgGW/CdpEqYHwfxImek22u+n+pFjetMy2z8Log4TqKB4U52wh2V2qr0NdcAm6JyxYirlboiS3XWLVGXKqmi2JML3Wyy3gQ7NJeL8uuzU7eI8UAI5z+RnwgkpFO9iolKjX/TN6M2VYafMvtKkhuT5Am/PMJeXXJJltndTpFWBS6P/y59HBzBvpLKi4o+PWG+7P18GuUOrhsTa14eol4Lv3hkdKefd146RDhXuuoTU04vd/f5f9YlY0u2qakF+vk0g1R24g+Qns3apuRPSGfyD8ewfHBQRxKOOvjkOgxxge775gNqlRIhmwE/DZKiypmXtWmL95XM/WpRbWt59erLjtaxnle20R/WkYYRzEKzRu81NcjJqkDB303r9f3SPJgtQfKgi+IqGmEK3WgDeXiU9vyOBXAfaVB0UJr904CJ0fD0H1BPLxL3x6esGTq6wQmlTSnYo6WxK8EgrRTcu1sGtKOszx6mYfI7QIzUtPhUPQIeYbBLzInBQhirXhEK5bJGA61a2wc1/08u4lCP11PI0zbkk1PVMZv43s5s8EZfvtdwyu/mxUtz7UcnM3Q5asPPEDTGtuM8xJbGfrhn38NU25a/dH5zHgMbwOW389H/NPBN8aLUvMjZ0IC/6PpOyeL3z+ZeqXgqkPyaYLKLdRA2C9fbcQpUeEFmrqJnm0Io38QJ3YJHu/FrrSF9gaaINrW+Lk6/9y3NHXu/Fm8Nb2j18VhqO8D3grIeGH/XIqXUoIP6nrkbqMp2LIa/j4GD4L/zqc6N0Z8BXmcw/ygoDZJ9kEJSt2410+c9vsP9w6XncVU8Xb3GGMYic/PiScHr+Z0NttRiTtHShn4PXPvRLBYYfAZzC/SiovaJcvR4UZ+U7nfX+YxNSXc2LR+d23iU+GDsCx9m2wPe+ipMoGlf4DbhTYHIkpC1nAMosi+8Vc0Dm0kQXTTGacZhwjiaxAxxg2ccq8VhsS/XV8y+JaLkRFpM1aGTwR9RCA87YF1YYRudWhJsd1Oeu"
`endif