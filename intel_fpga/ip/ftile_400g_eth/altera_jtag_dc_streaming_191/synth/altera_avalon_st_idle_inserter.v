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
//| Avalon ST Idle Inserter 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_inserter (

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
         if (in_valid & out_ready) begin
            if ((idle_char | escape_char) & ~received_esc & out_ready) begin
                 received_esc <= 1;
            end else begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      //we are always valid
      out_valid = 1'b1;
      in_ready = out_ready & (~in_valid | ((~idle_char & ~escape_char) | received_esc));
      out_data = (~in_valid) ? 8'h4a :    //if input is not valid, insert idle
                 (received_esc) ? in_data ^ 8'h20 : //escaped once, send data XOR'd
                 (idle_char | escape_char) ? 8'h4d : //input needs escaping, send escape_char
                 in_data; //send data
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "SFf2DuiD7DvcEuC7rgGW/CdpEqYHwfxImek22u+n+pFjetMy2z8Log4TqKB4U52wh2V2qr0NdcAm6JyxYirlboiS3XWLVGXKqmi2JML3Wyy3gQ7NJeL8uuzU7eI8UAI5z+RnwgkpFO9iolKjX/TN6M2VYafMvtKkhuT5Am/PMJeXXJJltndTpFWBS6P/y59HBzBvpLKi4o+PWG+7P18GuUOrhsTa14eol4Lv3hkdKeejLNaa1Hpd86z+Q3HDylREbpisB2FUGjgebuZtVW/QdZV4Cik/zHRoziiBXPGDiYAUslcdEro/Z6OXAtBsFGQ0olmFWeWpAmFlQmITL8zM4mnJ09XH6AH9yakJ1d6LPfXImbLG3S8ffulC1cBFk1ccyq0sWd9gC2D3wssUA5NUIACqUAcN5gK5EvUrl+rI/xbWNDi/TGrDGVlH2bkG4tIVe9v47VdddXqFTKy1tRsS5ES0sBayh/EZKghmL3jQyq1FzVWAxhyda5wZhWqvFKerf9rogbDEmeIxzK7sdshRDx/siGdDu6WJ8HiZYfSXrXumqqoweBWiQO7dFf21s+2itkyj8xoqIrgbrkFSIXApVIBD8rCvWW5aVpYLcwXqoUlDcq0NiqZb8Vcg9ROfPPDwX9lTn1s32pKYhZ1u7H/gn6F0iJV4QxMyVVa6od2M8s7Ig1FlKT8VDrflEt6H0DKUl1GqwYCzpEFjJpEKxr3/ZMKRPtvRV6DmdDGGanCyzZmx0PYU8HmNgSCnel1ZFaEifXPf37xz007ggUT982wBL0h7SUpvCcDwppWQAyn+BRbHwfrRMFqq/liAAuZ/WTJMH86qaJLFyjt4ehCyqgq4/9ivBshmqoTXdTYuw4JPmsw/4t8NK+fe1iWu9Otm6OllQ2rud4CZ5tp4tFO10MSf2az6gMT9KYEY0k5WvcNsOSwOVMg/lTHabL1VlxPWmTXuPD3e5T57WYK2iqriiX+eJwy78Sj5po3twwWiSt1UyzH8MjGdcWPa1uoM0V35p4VQ"
`endif