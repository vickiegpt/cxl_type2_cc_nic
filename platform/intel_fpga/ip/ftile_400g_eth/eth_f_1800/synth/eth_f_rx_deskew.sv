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


module eth_f_rx_deskew #(
    parameter WIDTH         = 64,
    parameter LANES         = 2,
    parameter SIM_EMULATE   = 0
) (
    input   logic                           i_clk,
    input   logic                           i_reset,
    input   logic [0:LANES-1][WIDTH-1:0]    i_data,
    input   logic [0:LANES-1]               i_sync_pulse,
    output  logic [0:LANES-1][WIDTH-1:0]    o_data,
    output  logic [0:LANES-1]               o_sync_pulse,
    output  logic                           o_deskew_done
);
    logic   [0:LANES-1] deskew_pulse_arrive;
    logic   initial_sync_received;
    logic   [15:0]  startup_timer;
    logic           ready;

    logic   [15:0]              gap_timer;
    logic   [0:LANES-1]         incr_delay;
    logic   [0:LANES-1]         incr_delay_masked;
    logic   [0:LANES-1][2:0]    delay;
    logic   [0:LANES-1]         sync_pulses_delay;


   wire r_reset;
   assign r_reset = i_reset;
   assign initial_sync_received =  &deskew_pulse_arrive;

    always_ff @(posedge i_clk) begin
        //if (r_reset) begin
        //    initial_sync_received   <= 1'b0;
        //end else begin
        //    initial_sync_received   <= initial_sync_received | (|i_sync_pulse);
        //end
         if (r_reset) begin
             deskew_pulse_arrive    <=  {LANES{1'b0}};
         end else begin
             deskew_pulse_arrive    <= deskew_pulse_arrive | i_sync_pulse; // bit-OR: detect first pulse of each lane
         end

        if (r_reset) begin
            startup_timer           <= 16'b0;
        end else begin
            startup_timer           <= {initial_sync_received, startup_timer[14:1]};
        end

        if (r_reset) begin
            gap_timer           <= 16'b0;
        end else begin
            if (sync_pulses_delay) begin
                gap_timer           <= 16'b0;
            end else begin
                gap_timer           <= {1'b1, gap_timer[14:1]};
            end
        end

        if (r_reset) begin
            incr_delay  <= {LANES{1'b0}};
        end else begin
            if (gap_timer[0]) begin
                case (sync_pulses_delay)
                    {LANES{1'b0}}   : incr_delay    <= {LANES{1'b0}};
                    {LANES{1'b1}}   : incr_delay    <= {LANES{1'b0}};
                    default         : incr_delay    <= sync_pulses_delay;
                endcase
            end else begin
                incr_delay    <= {LANES{1'b0}};
            end
        end

        if (r_reset) begin
            incr_delay_masked   <= {LANES{1'b0}};
        end else begin
            if (ready) begin
                incr_delay_masked    <= incr_delay;
            end else begin
                incr_delay_masked   <= {LANES{1'b0}};
            end
        end

        if (r_reset) begin
            o_deskew_done   <= 1'b0;
        end else begin
            o_deskew_done   <= o_deskew_done || &sync_pulses_delay;
        end

    end

    assign ready = startup_timer[0]; // only count up when all deskew pulse already arrive

    genvar i;
    generate
        for (i = 0; i < LANES; i++) begin : lane_loop

            eth_f_word_delay_mlab #(
                .WIDTH       (WIDTH+1),
                .SIM_EMULATE (SIM_EMULATE)
            ) lane_delay (
                .i_clk      (i_clk),
		.i_rst      (r_reset),
                .i_delay    (delay[i]),
                .i_data     ({i_sync_pulse[i], i_data[i]}),
                .o_data     ({sync_pulses_delay[i], o_data[i]})
            );

            always_ff @(posedge i_clk) begin
                if (r_reset) begin
                    delay[i]    <= 3'd2;  // 2 is minimum delay
                end else begin
                        delay[i]    <= 3'(delay[i] + incr_delay_masked[i]);
                end
            end
        end
    endgenerate

    assign o_sync_pulse = sync_pulses_delay;

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "o2ONPYJ6JWO2K/lQHkyApXo6DVczB8sUyJtLpEiYtF7LL07s93qi8rQ7d2s1AdTOt/BNVdBoSTLCdACDT58BR3umvYuucV6Cbb36lNsOsJegwtedOJsDvTnB14ZLU41EvDEX+uxr7iJUYiTmn7hunq22K1+T/Nc7+FaTNr6AMH3CCuiZmo/CmXjVXLRPwF034Kg1mVvlsNTpZhm0ORjPpNI8tuMP0bMp6HLhHMKVKvc4S/MDm37VUThGspMTF5JPJ1Qg9tVWpBhhw5Qy7baf67ZqakL2QbktXJcGCTXeji5xgUL8QT21LxfVdYaEOJPJ+HlYj4ecWeyGOs0LRYT6qtOKrGtQbPX+t7yEsW8iXxgH21il9N/bFtvohMRDYsXggLna0WhHojKz2ZI1SjpSkCs2r4t8KHIzZk8fDswuJtBGPpLZeNbycNTyUzhIOFmU0wnlx931r5IXjT4RRkkK4Ynpe7rbqNLhb6yfSifopBMqTbWXfyreunJzQIjR7rr1gl+2nWm55FuifFAAf7kAURBkZIKCK4e3y0WZaTqBL9V0se68OfkEE3Tj7gnvk8gAvHlol5SrJ8Ylh4ysGAQsMmSwCE/rJrznpIM+zVJSo+qf1M+ec6wBpnT1ob2wYvu5o/JwOW/3EGu64/grwLN+4IWQPmtSwPlde+js2qVJSby7Gl0xr/Dqn+EYtfH0sTC/TiV0BnwhefEZlfayc0+zWQIglkBEfdRVqY7O39L9uEUtLXYfvEgqy5q8njL1PHsZ5GGzKEPJbEtGranwmQGO4NFzdZuYsmLVSizmD6jO+EnEi+DlLChsYjAtySdCinjlrY8WGt2Oqn2w5Z5yhu+IQeB4g4p7YIE3CWWapBqXknyz/rlCNZlbJRpUwSjnhBDepGoMN6i1e2P8zMYxUmza87HsrIKVO/awktPq02r2YbLT57Z/ProyCoyLUNV7puCfgDhpms4Wp4/986u3PPPQ3yvro0HpcVTR+ibLqKazGgNED7x/n9lj+gayJL7UqZoU"
`endif