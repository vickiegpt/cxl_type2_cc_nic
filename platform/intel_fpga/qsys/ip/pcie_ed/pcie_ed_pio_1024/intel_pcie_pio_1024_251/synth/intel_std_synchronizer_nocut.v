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


//-----------------------------------------------------------------------------
//
// File: intel_std_synchronizer_nocut.v
//
// Abstract: Single bit clock domain crossing synchronizer. Exactly the same
//           as altera_std_synchronizer.v, except that the embedded false
//           path constraint is removed in this module. If you use this
//           module, you will have to apply the appropriate timing
//           constraints.
//
//           We expect to make this a standard Quartus atom eventually.
//
//           Composed of two or more flip flops connected in series.
//           Random metastable condition is simulated when the 
//           __ALTERA_STD__METASTABLE_SIM macro is defined.
//           Use +define+__ALTERA_STD__METASTABLE_SIM argument 
//           on the Verilog simulator compiler command line to 
//           enable this mode. In addition, define the macro
//           __ALTERA_STD__METASTABLE_SIM_VERBOSE to get console output 
//           with every metastable event generated in the synchronizer.
//
// Copyright (C) Altera Corporation 2009, All Rights Reserved
//-----------------------------------------------------------------------------

`timescale 1ns / 1ns

module intel_std_synchronizer_nocut (
                                clk, 
                                reset_n, 
                                din, 
                                dout
                                );

   parameter depth = 3; // This value must be >= 2 !
   parameter rst_value = 0;     
     
   input   clk;
   input   reset_n;    
   input   din;
   output  dout;
   
   // QuartusII synthesis directives:
   //     1. Preserve all registers ie. do not touch them.
   //     2. Do not merge other flip-flops with synchronizer flip-flops.
   // QuartusII TimeQuest directives:
   //     1. Identify all flip-flops in this module as members of the synchronizer 
   //        to enable automatic metastability MTBF analysis.

   (* altera_attribute = {"-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name SYNCHRONIZER_IDENTIFICATION FORCED; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON  "} *) reg din_s1;

   (* altera_attribute = {"-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg [depth-2:0] dreg;    
   
   //synthesis translate_off
   initial begin
      if (depth <2) begin
         $display("%m: Error: synchronizer length: %0d less than 2.", depth);
      end
   end

   // the first synchronizer register is either a simple D flop for synthesis
   // and non-metastable simulation or a D flop with a method to inject random
   // metastable events resulting in random delay of [0,1] cycles
   
`ifdef __ALTERA_STD__METASTABLE_SIM

   reg[31:0]  RANDOM_SEED = 123456;      
   wire  next_din_s1;
   wire  dout;
   reg   din_last;
   reg          random;
   event metastable_event; // hook for debug monitoring

   initial begin
      $display("%m: Info: Metastable event injection simulation mode enabled");
   end
   
   always @(posedge clk) begin
      if (reset_n == 0)
        random <= $random(RANDOM_SEED);
      else
        random <= $random;
   end

   assign next_din_s1 = (din_last ^ din) ? random : din;   

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
         din_last <= (rst_value == 0)? 1'b0 : 1'b1;
       else
         din_last <= din;
   end

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
         din_s1 <= (rst_value == 0)? 1'b0 : 1'b1;
       else
         din_s1 <= next_din_s1;
   end
   
`else 

   //synthesis translate_on   
   generate if (rst_value == 0)
       always @(posedge clk or negedge reset_n) begin
           if (reset_n == 0) 
             din_s1 <= 1'b0;
           else
             din_s1 <= din;
       end
   endgenerate
   
   generate if (rst_value == 1)
       always @(posedge clk or negedge reset_n) begin
           if (reset_n == 0) 
             din_s1 <= 1'b1;
           else
             din_s1 <= din;
       end
   endgenerate
   //synthesis translate_off      

`endif

`ifdef __ALTERA_STD__METASTABLE_SIM_VERBOSE
   always @(*) begin
      if (reset_n && (din_last != din) && (random != din)) begin
         $display("%m: Verbose Info: metastable event @ time %t", $time);
         ->metastable_event;
      end
   end      
`endif

   //synthesis translate_on

   // the remaining synchronizer registers form a simple shift register
   // of length depth-1
   generate if (rst_value == 0)
      if (depth < 3) begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b0}};            
            else
              dreg <= din_s1;
         end         
      end else begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b0}};
            else
              dreg <= {dreg[depth-3:0], din_s1};
         end
      end
   endgenerate
   
   generate if (rst_value == 1)
      if (depth < 3) begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b1}};            
            else
              dreg <= din_s1;
         end         
      end else begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b1}};
            else
              dreg <= {dreg[depth-3:0], din_s1};
         end
      end
   endgenerate

   assign dout = dreg[depth-2];
   
endmodule 


                        
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "Ct7RU5a/p+bqNMEu7Q8vVGkxrD9sml63wG3pH4RTYVLEkGP54+ko4S6h4izCOGh2sb1MtzKT4NgdJp4xN+yn2JGIZmbeOFlk7RGH2eFw9e3st+RwkxWCxS7KD1tPqriXtOc8UJty5UDKXbnNqnBAVeHZ6nPhWp1yOkMMqFi8IxMQBLtdbH85F6ety+Cx+QHBoe8B/SyEjMHeHo/WVdxxY872sbe9f+B4kDnQPeiLXt4ONL7+NREZHEX0/2somZpUZQdtwHNrqggdNXm9iEajl84OhBdxhy6QXxyQCqsaUo2vpjp5CAG9uBvtqPWGifhz2fmhF57U67ezFprl7Tv2eGs7mvkDnSvN6czFC6c51lM7NAKHQWru7pCjnY3vRy02SB/abgpJ/5pGIrCvDNoIOR+rCM3XleQ3nEs2nR0EDjDWaum++n+ngHj8ndnfpk+slxbXzdadO9K9RWCLloj/2ltWag/T18JZGKoGI99cyhcYDHACMzwiBGYnh8OGYwY/4DyJlu7HpHjYdw8lMLrzHCqElZXOhkqyAIkXyhLN8Tvu4InLbkm2nrfeg+um1zUs1I1A6f9QhrGT7p29QfzZWp28MEMvXGCes904s0Qo/AvaQYCXh0S+6sL2DjtnzY4Uo6axfj6CdHC995fRVGlg6Q/NHZz0UnV9DwXlrARppiOyQu94I6awxvcgCz7HKMfDyaumKEjN9cMVbNOEYl6aYq6Z63od2qq79DvdxiUOwufHLFYGg/ie3u9TtY7tvQOp4sjdcBBhNufIlfMuh5iaNkOqeHY9P5RivKGL//7Q3RWF8AaSKdRUFpGpVbq9LpBgYX/a5nhI1DAGswL6Tz8VjKmDgUatiuQF6RJ8OdMtXrV9K0x4l9eScAmsHk8cSsfRfDOf3FRuyeFXEy+SSKb/XOBM536CiM9+IwlLW+hRFLGfxWXNcZJHFSXzvKjWwSsYiursZCGBKWcGuDf8+AptbJxHxZHQTSNX+DA8g+0PmTdvt7O8S+2ZueJR1C3alU9J"
`endif