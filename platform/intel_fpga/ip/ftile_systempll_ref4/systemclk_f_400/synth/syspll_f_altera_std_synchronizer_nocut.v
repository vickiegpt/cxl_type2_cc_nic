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
 
 
module syspll_f_altera_std_synchronizer_nocut (
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
`pragma questa_oem_00 "WfFVdyql8MX8mXVyk/o4uVHSVnI9UjJRGwwb336nmAdX9+mpbJ6mSUQss63YcuDLPsviS3zV3x4H9/ufzDWJhiMsMk5su3c3a5t6emal0wmMuzlCaBg8nX2HnASXWZFYdD2lZ2f9WQiT7YBk8pWHWPxL53F3O5UwUiGEgA9T6isaFpMPrEoSO+HPNTvZNfnymv7c7T92tiM6OA3+qWyhLObaJSiFnbSgEzJeHEkIUwqKv8/nALfro5xPqwxK4XzY+sazxWqZPSUByyzYYtSHMXJwvhzZeadZXYD5fS98BSC8Yovc4DwCu8O9IUimjv4ST6JzZZjvspd7LobkrO9344Fy1P6a74LvPOB9TtKZK+o9VWGAg3EINT/DNV7eYjbGrrpIS89wMB+KbrnZoKdtMpFHyaK8pJ5e4FWNl55UsGhY/Ia/huCWEN9itsBdmAqUPgfQB49uUFShfEaIHVe7NCfMAC1JMSI0sEZK14MXUU380rZRffFQP0ZLFdXul2EhhM+DAR96JArv2VuqmFNjeyQB0JOvqBtMYwdh6le9jqUNeBq3RLymzhlmjdneO4kVcnd++IaC7sLBbfTNwkUYzTdrTPSavKP8aaU6NkoHemnt6eAhWnSO1K1hE1tIQH1Xnfms0dTr7oBpj4QctZj11HRUmtdxXh7R/Zfb+OZ6uYWQu6E51YQOzaMT9TGlHeETcBNBjvIg5VkNK0rk9U6RcR+tWkcvmO7DpuhN/oY/U6Xu35oy8hRnPzvsLWOOtT+jqUqiInE7mSX7sFFtOPF51Ftc/VJ56HGuDeSnVOroS6KbnNj4U0Iy8rcv6OU0M9iM09OUv+RX0AevofCk1UNlvW6YYYNUaZO8Jn/NzUFV81vvicynAPYe89dyTwZ6CZorSkEiAFBBgHm89mzm4IruRs/u4J8Z891EByRF9CgNzsIktco+firPAygkM0fiKIoVdC809RNplp9l/CljrZzEF5D0gXtl0o3kD+mxe1rMAPhstkhFxbo/JNjsb5yPmbEe"
`endif