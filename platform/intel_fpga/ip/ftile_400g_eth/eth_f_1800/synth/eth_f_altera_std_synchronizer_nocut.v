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


//
// File: alt_e40_altera_std_synchronizer_nocut.v
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

module eth_f_altera_std_synchronizer_nocut (
                                clk, 
                                reset_n, 
                                din, 
                                dout
                                );

   parameter depth = 3; // This value must be >= 2 !
   parameter rst_value = 0;     
   parameter turn_off_meta = 0;     
   parameter turn_off_add_pipeline = 0;
     
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

   (* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION OFF" *) reg dreg_R;    
  
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

// for accuracy sensitive synchronizer to turn off metastability in meta test
generate if (turn_off_meta == 1) begin: g_meta_off
   assign next_din_s1 = din;
end
else begin: g_meta
   assign next_din_s1 = (din_last ^ din) ? random : din;
end
endgenerate

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
   generate if (rst_value == 0) begin : g_rst_to_0
       always @(posedge clk or negedge reset_n) begin
           if (reset_n == 0) 
             din_s1 <= 1'b0;
           else
             din_s1 <= din;
       end
   end
   endgenerate
   
   generate if (rst_value == 1) begin : g_rst_to_1
       always @(posedge clk or negedge reset_n) begin
           if (reset_n == 0) 
             din_s1 <= 1'b1;
           else
             din_s1 <= din;
       end
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
   generate if (rst_value == 0) begin : g_rst_to_0x
      if (depth < 3) begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b0}};            
            else
              dreg <= din_s1;
         end         
      end else begin : no_g_rst_to_0x
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b0}};
            else
              dreg <= {dreg[depth-3:0], din_s1};
         end
      end
   end
   endgenerate
   
   generate if (rst_value == 1) begin : g_rst_to_1x
      if (depth < 3) begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b1}};            
            else
              dreg <= din_s1;
         end         
      end else begin : no_g_rst_to_1x
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b1}};
            else
              dreg <= {dreg[depth-3:0], din_s1};
         end
      end
   end
   endgenerate

    // for accuracy sensitive synchronizer to turn off additional pipeline
    generate if (turn_off_add_pipeline == 1) begin: g_additional_pipeline_off
       assign dout = dreg[depth-2];
    end
    else begin: g_additional_pipeline_on
        always @(posedge clk) begin
            dreg_R <= dreg[depth-2];
        end
        assign dout = dreg_R;
    end
    endgenerate

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ2XmzM4OTTl1wDAtwpEHkOlwduuBWcxIxckR5CSMfjc5pUI+BlKKiZcNxO2RWnnHNgagFQLfVQBgCu3emMsEmIqJOm+nJE9rBLrp3S+0lnW5ttEazyyEWR2ctVTGUIgzDx9Q9vBbRL1s7qrNT8N9nmksp0g4pcUs7WjX3FRO58L5mzXBXGYoiQo2z4//Pa2ll0IfG+5JIeMaT3lMF3OW+wJOatZ+M4ikiJyC5OjCMVw4uxC7/Ngz6EU4yJkoPGEnWW3kHcYF3IpISdUilfAfRPAo3WDRs52wWZ6HlAX39VBYE8PflcEeGiS7tImtE+GLYCbeSiIfwxk9z4akcoGmKHJzS1MN1moMV4G/0WXG9cShalBULzkYD5x00E87UP0eIJzyVkX8zB+5Lwc6jzWJB/BjqXuPAl6O7ZPtCsEvvfeFwqqy97CCKtCvuYZk7b8edAeH7BdHbRy/OLBSwHaJRxMsVce3t+diH8AIBqSNgC5nK8UnTow58qXKi2JIpG3WonrKzrzTqbLjIEN0sNS+YeLwS5+gop9o8nJJHJ/VErRqwIIYSmEMERIVRf2C/4z22Wt2s8ho5Z4nbVjg7T6242N+57R7ykoP+oRMLzXbuJnocC2HuHeYTVoMUuTey9xeJTIqKCsEAUIfF0XX3rRdS07QWePiCF/D/fwqv+Ag1KQypJBen9zV4N/VEcS1jkvrmQagoqDWx2q2Dkl5R4ksq9MzpT1f2jUiKEDYcC+f0/FPHYaLlXVgUan0X4Dujdb5OeZd52dnYTvN+R3xIjSduXH"
`endif