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


// --------------------------------------------------------------------------------
//| Avalon ST Idle Remover 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_remover (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data,

      // Interface: ST out 
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  received_esc;
   wire escape_char, idle_char;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign idle_char = (in_data == 8'h4a);
   assign escape_char = (in_data == 8'h4d);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc <= 0; 
      end else begin
         if (in_valid & in_ready) begin
            if (escape_char & ~received_esc) begin
                 received_esc <= 1;
            end else if (out_valid) begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      in_ready = out_ready;
      //out valid when in_valid.  Except when we get idle or escape
      //however, if we have received an escape character, then we are valid
      out_valid = in_valid & ~idle_char & (received_esc | ~escape_char);
      out_data = received_esc ? (in_data ^ 8'h20) : in_data;
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "SFf2DuiD7DvcEuC7rgGW/CdpEqYHwfxImek22u+n+pFjetMy2z8Log4TqKB4U52wh2V2qr0NdcAm6JyxYirlboiS3XWLVGXKqmi2JML3Wyy3gQ7NJeL8uuzU7eI8UAI5z+RnwgkpFO9iolKjX/TN6M2VYafMvtKkhuT5Am/PMJeXXJJltndTpFWBS6P/y59HBzBvpLKi4o+PWG+7P18GuUOrhsTa14eol4Lv3hkdKeeKLh06u2fAm27fAzoA12zwgc/MFwL0PRh+xhw7IgzqRcCRvktNEUaOuj/vOmEE2pofYHecbu3b+ogHVd156I5iaos6vqu4FlS2VZyuAs8ZxYJVSvpDc1YuZJcZbghr+vpAKRbwONkhD7tSuulRECYksxjB1eQZ9XpbdI4oWcZupruxhByUoaG7dH6wC2Y/XwbpCk5Txg/4JJtHYCREmz0NoSsdX1R8xkfItyvKcF81NE3upY7ABmySMCzrGn22rwM9+Nc/7JtNLtUgjHEAIHcy26vSs0y4WvTTXneUzRqKx7oeOTri0vbj5cxtYofKxk9QqNG5n6m2a8LmVrWalWy6OvBPPKAMdcXyKerfsnw5vWsUiYv6A09uGI0DNSQFbaj+JdHtvMxVfxRqyBT8JUDXySmpA5tKYaJrxJZMhj9jeGPGRK13pCUddh6rnL9vaFiq/veqizwfWMxea+HL3r9Fx/QCBZLS+F02Lyz3WvC5TwuBBnvGtb+zSwFkI1jjOq9gNYtRH8zl3BCvBRxBLrZNIeOq5Ok8OVImYk+4fFy6CXVvjtoxybBk061F9SF1Sglec7TR0bAz63tnapub2i7+e5OBVeRz8ewDhhyHKZOR8O0j5Ibnas4iR6MkF+8ZXryTy7t/6epO4qnYK1l+yNwIMani/XPoG+C9b1Q3RK9tc7w/Hy6X4yrOrHfjSJMau712LZMjJReaza6sSEjOjjyz+Iqjf9sd2L5yF1mf4HgsshG6sBQkfQLvqC73lgeAJN6AKPNQNOVFyuzkv4TE0m6W"
`endif