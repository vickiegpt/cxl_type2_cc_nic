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

module eth_f_lut6 #(
    parameter MASK = 64'h80000000_00000000,
    parameter SIM_EMULATE = 1'b0
) (
    input [5:0] din,
    output dout
);

generate
    if (SIM_EMULATE) begin : g_sim_emulate
        assign dout = MASK [din];
    end else begin : g_sim_10nm
        //Note: the S5 cell is 99% the same, and compatible
        //stratixv_lcell_comb a10c (
 
        tennm_lcell_comb a10c (
            .dataa (din[0]),
            .datab (din[1]),
            .datac (din[2]),
            .datad (din[3]),
            .datae (din[4]),
            .dataf (din[5]),
            .datag(1'b1),
            .cin(1'b1),
            // synthesis translate_off
            // this is for stratix 10 (fourteen) but not the others
            .datah(1'b1),
            // this does not exist in S10, but is partially there in the models right this second
            .sharein(1'b0),
            // synthesis translate_on
            
            .sumout(),.cout(),.shareout(),
            .combout(dout)
        );
        defparam a10c .lut_mask = MASK;
        defparam a10c .shared_arith = "off";
        defparam a10c .extended_lut = "off";
    end
endgenerate

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ0LN+ewd6GCSXFRJFKPGd+d75hu6Gid2W4bMnItZo5MbO9QZuT+LkFGvfgP6UfYApfPjN3eXgvKHaX3lVfcn5jkQZPYMFXiSNKXUvL9RALHS/IqCKbVC5crBDLTB95bBziuGlSeh3L9TM10qVa/0eXBwMkPSkdKV+GcmDff3YfdGDeHW7eXjrrWE1xBR3hNxkvT2+6dh+/e8Iuj08MpuXFiqwzkOVbCr9n4eZkxr5SlD3FzBYUwd/Rv679O/wJniHxhFoXr+/Xukmp381EkAGF8UQuS3oJFAswfMeH5hxyT78c2l/I4vGxHHHsbHmKzPLHN9YNQfgCve764joZndSiu4Fac8s1m0kVzPeKsAvi8WKw4fD2PqwB+v71IaGwk1kUCCb7RuLk2oK+mpaNxwnjOfAzg13jVdlliyZ9h/THAKqefsgrhrqnEL6sXLLNWnOsvqiBa1M4QMX94v108XyFnbqvujau0wkzhIITt92inTeg0lkv89l9EWWv8E2ofsA+nGQsUUpahf8lJi6VdJUJEIeSZzH8b4Q+xcUIi7pIxVfOq9gCHX762ArVG0SkuwxmEltyhIbma19H2FsuWE7ZEYO0tqa8GUH4HaRUFqOXGS0gFzqAZDuptAPBm8rgYp+pwDiC8wm5qwKstzgCN317I79fjECT6AlkhUzqybijpFwc/5bKALtaidd5D+aLCKa8NsgNO69BclHgHLj7dJwebxDrIId9xmrI/mj8q4qTFQwCTaF7mu8hiEYPlAfn6gFxU68HLNu8KeFFLKsLN6snD"
`endif