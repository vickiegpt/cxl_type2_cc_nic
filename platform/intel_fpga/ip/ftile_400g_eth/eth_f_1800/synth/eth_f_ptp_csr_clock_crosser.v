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


//------------------------------------------------------------------------------
//
// Filename         : eth_f_ptp_csr_clock_crosser.v
//
//==============================================================================
//
// Description         :
// DATA_BUFFER_MODE = 0, 
//        no data buffer. sdc constraint for o_out_data to next_flop required.
// DATA_BUFFER_MODE = 1, 
//        i_in_data is flopped to out_data_buffer.
//        out_data updates value when out_valid=1;
//
//------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module eth_f_ptp_csr_clock_crosser #(
    parameter SYNC_DEPTH = 3,
    parameter DATA_WIDTH = 8,
    parameter DATA_BUFFER_MODE = 0
) (
    input                       i_in_clk,
    input                       i_in_rst_n,
    input                       i_in_valid,
    input   [DATA_WIDTH-1:0]    i_in_data,
    input                       i_out_clk,
    input                       i_out_rst_n,
    output                      o_out_valid,
    output  [DATA_WIDTH-1:0]    o_out_data
    
);

// valid
reg     in_transfer_valid;
wire    out_transfer_valid;
reg     out_valid;
// Data buffers
wire [DATA_WIDTH-1:0] in_data;
// reg  [DATA_WIDTH-1:0] in_data_buffer;
// (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg [DATA_WIDTH-1:0] out_data_buffer;
reg  [DATA_WIDTH-1:0] out_data_buffer;
reg  [DATA_WIDTH-1:0] out_data;


// -------------------------------------------
// i_in_clk
// -------------------------------------------
// flop - ensure no combi involved in clock crossing
always @(posedge i_in_clk) begin
    if (~i_in_rst_n) begin
        in_transfer_valid   <= 1'b0;
        // in_data_buffer <= {DATA_WIDTH{1'b0}};
    end
    else begin
        in_transfer_valid   <= i_in_valid;
        // in_data_buffer      <= i_in_data;
    end
end
assign in_data = i_in_data;

// -------------------------------------------
// clock crossing
// -------------------------------------------
// Clock cross the data valid (clean, no combi)
eth_f_altera_std_synchronizer_nocut #(
    .depth(SYNC_DEPTH)
) valid_sync (
    .clk        (i_out_clk),
    .reset_n    (1'b1),
    .din        (in_transfer_valid),
    .dout       (out_transfer_valid)
);

// Clock cross the multi-bit data (clean, no combi)
generate if (DATA_BUFFER_MODE == 1) begin
    always @(posedge i_out_clk) begin
        out_data_buffer <= in_data;
    end
end
else begin
    always @(*) begin
        out_data_buffer = in_data;
    end
end
endgenerate

// -------------------------------------------
// i_out_clk
// -------------------------------------------
generate if (DATA_BUFFER_MODE == 1) begin
    always @(posedge i_out_clk) begin
        if (~i_out_rst_n) begin
            out_valid   <= {1'b0};
            out_data    <= {DATA_WIDTH{1'b0}};
        end
        else begin
            out_valid   <= out_transfer_valid;
            if (out_transfer_valid) begin
                out_data    <= out_data_buffer;
            end
        end
    end
end
else begin
    always @(*) begin
        out_valid   = out_transfer_valid;
        out_data    = out_data_buffer;
    end
end
endgenerate

// Output data
assign o_out_valid  = out_valid;
assign o_out_data   = out_data ;

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvd+5qlkIkh6kPZJQKWDBkM0TJve1ljcOo7wyL7PlDF7YR7kNZO4FDAqSCPa4mpYBiLPlAOqF5Xl5uQKZBTeGg7avKSxVbtvFN4MbuiRWlNRNYBtPvhsNS7g3tQmWB06c2ux8WncTT0fpiGpWIAwtAfzP7k1YZM95X/KJ4+Y0PAgOY5xg1mtV/5uJcDPX9d2jz6MKKNyLnTLCGDQ346xkyBMqN8Ir9tTF/arbckkYsFjhpAmhtd8c/qphbT0vDUx3iqLMN5o21n7YFKjlYEpt73EJN8SVLoVYEIk5pGJcE+HNivEulW1igpftJEg4A+a/F8qh4+YoDpp0YR/aUL/ydpd2levyoOxR3mWcvXstZy4UDH33BXrffJXIsPwXER402C7wo5z77fLD3oX5kBMjVlqtQf9kqz/pgIcKFi3bvsCuck6Eq2xSohImxuaRyuseyLLCtnEJteAZY/otCpkx0+4A+RboFqfHhuvSxfkkjbpRlY7RZ1M8i1EpAEVcSn9V5iy0pEkHqAd1WYO3y2DlPcCdthhilildFJobMEEkqnBRWu5xXli8A1F7Z7bAobKjUkgfLtyjGI512EuPvsYX0VyTf/I4cYZWOOzVFQp7B5sSNA7OgM6GSamEdXPCIFRFOyDVgu3p9v0Evvwv5fgpuECwyT3cMxxuSySsUq3aYpsdNWUHIuFQgbBsFcnEz4C/Ya1C5LusymaNPBV3YknzZLfD1nIqc8dCed6h1M7tHLVBPcV6qgjhYgIrtccSgNM4XevcFlKNa0GkGA3BduHBqGR"
`endif