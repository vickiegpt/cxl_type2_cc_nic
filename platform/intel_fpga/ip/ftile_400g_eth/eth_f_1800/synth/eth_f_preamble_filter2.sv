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

module eth_f_preamble_filter2 (
    input   logic           i_clk,
    input   logic           i_reset,
    input   logic           i_valid,
    input   logic   [0:1]   i_inframe,
    output  logic           o_valid,
    output  logic   [0:1]   o_inframe
);

    logic if_last;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            if_last <= 1'b0;
        end else begin
            if_last <= i_valid ? i_inframe[1] : if_last;
        end
    end

    always_ff @(posedge i_clk) begin
        o_valid         <= i_valid;
        o_inframe[0]    <= if_last      & i_inframe[0];
        o_inframe[1]    <= i_inframe[0] & i_inframe[1];
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q46DpTvGvp9FWc8yVcB/6Z4+tTBf6hjrreNUR7EVaPO+c89/1wH7Nb/jSwTpOqGllYFbpyvj2emyHw1ROTW5Ht06QKaYfdc0r8XTOJW1RcoEaT7h55beINf7ee6on0Jn5xLzU5eWM8mu8XyO6CzQopV9DrO9/7zhiSEjNimmyRofGfu/W/URTCtNwTkWl/UsVGIi+J3KRfr4sMF9IAF23XfqBA/4GvEexQw1w541hQOZahv2GEUu+VJfACixQ9oKj5MPfQdvUscZL6NO3pK4VvihR8QAXcYvaJN6wri6TEcVmgvwgZiWhcvrdiJ36hZZKN1bbAs5Lxx8k4YpZHehM71X3DuCl8kmWFBVFZ+BFioHcp8qg38kFs3fUWoyW30tgFoMrn4/QgNk/2wKKX3pe3s8i6cg4xFVsNYZd+ybVmSbKaFrpeYEZQMBFPYUwm/s++ucAaDkUcsIMguuBdV22pIbjdvAAD5nHXU0djIt/jdh2921tTcoqti45PR+czgFO/8eIrpznSTfCKozBI4ygVEIuRPWZeRxDzJ8Qw2rLD2q/kOS/XiJdYlr8qXl6+Ytw6482S6pOJErmukxlfpdqSrHai7g4iFl/i51+BV/PYDK8ZsNlIcNnerMeazlXUcr29W7sPEfQgFezrbgN940MMnhh+XdYojhl3BoZxHt3MeTRJH7IU/cjwouj6KRS0hOCIr+ln6e/OLh3W6KgV+RCYQFkdjnFkIxWXvAhxj0TBI2waQz7ZNbQmlkBy+i58v8TZfHdAla8TgunBN9NnbRfvUc"
`endif