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
module eth_f_wptr_gen_tx100a #(
	parameter INBLOCKS         = 8, 
	parameter OUTBLOCKS        = 4,
	parameter MEMBLOCKS        = 8,
    parameter MEMDEPTH         = 'd32,
	parameter EHIP_RATE        = "100G",
    parameter PHASE_VAR           = (EHIP_RATE == "100G") ? 8'd7 : 8'd3
	)
	(
    input   logic                                            i_reset,
    input   logic                                            i_clk,
    input   logic   [OUTBLOCKS-1:0]                          i_num_write,
    output  logic   [0:MEMBLOCKS-1][$clog2(MEMDEPTH)-1:0]    o_write_pointers,
    output  logic   [$clog2(MEMBLOCKS)-1:0]                  offset
);

    logic   [0:MEMBLOCKS-1][$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0]  phase;
    genvar i;
    generate
        for (i = 0; i < MEMBLOCKS; i++) begin: phase_loop
		if (EHIP_RATE == "100G") begin
            always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    phase[i]    <= PHASE_VAR - i[$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0];
                end else begin
                    phase[i]    <= 8'(phase[i] + {4'd0,i_num_write});
                end
            end
            assign o_write_pointers[i] = phase[i][$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:$clog2(MEMBLOCKS)];
		end 
		else begin
		always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    phase[i]    <= PHASE_VAR - i[$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:0];
                end else begin
                    phase[i]    <= 6'(phase[i] + {4'd0,i_num_write});
                end
            end
            assign o_write_pointers[i] = phase[i][$clog2(MEMDEPTH)+$clog2(MEMBLOCKS)-1:$clog2(MEMBLOCKS)];
		end
        end
    endgenerate

    assign offset           = phase[MEMBLOCKS-1][$clog2(MEMBLOCKS)-1:0];
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapWipn3odF2T1xj1zafZfnooXhBzjMvw2NMH+CjqdzQDODaKzjYkVtwV7chA1OGqaXlmW5HQFXjUp6XOHRJfknygTG7ljlTHnViRCMx+qnPXgm2PhOXo4O+zVJ6CUNBPOuynsvpeT9zJMRF8csmDy+5GiQiG54F+MjGp5i9/gsH8GjVvlMylUBYpQcdUdaMnfbVnaUnt+KC34Tq0+7gknqwRgx2wTs8H2/qiVAYESGPoiH9X4NfSANCHYjI5QrPBxCqAMrX3AscW2knShcC60L4i47vDjnxS8JRVHjJyRNYiF6kqs2EsszhJpDrpFJ4u4b84zzg4cL2Yt/SCu1PyRu6ZJmL+x12euP3xdJWcSj9KHcPuZJB/yr6CjMrKyUzyleUALIuMH8hvlm7T9o2SuZvY/Gz9/v8ziBCVE1EPUdJAOegT+ElhGhQAD/je4YTMwzArKf/xxvvLPsSYcvnSfSCSZechSlQUJYeRvSSED8rpuj3AqBEK5EeUg/V/ju3/pjJDPFX028xka9ODdMfVFXcLXN7J/PL8FrK4P6GQIS9a2kLSpEtb04DOPs8zCAm0QaDOAf/v79XRCPgG2hsV+t5fU24VclVUQy7UqpkdAOdF8av9vg9N6h/DPKWnG0gSj6ES8oVHXfbvPa/Ip3dS6obl00okhTBr890+a3gap+5JiGKoErj4IcPk6b0FddZo107XdmSz9w2VoGfq2SDnr3+CfW1ybvKZAk7+ytzxe+NdXas8NdOT3rueCXHsCghyaHL4FrTHLXDPUc5Tyil7+xm3"
`endif