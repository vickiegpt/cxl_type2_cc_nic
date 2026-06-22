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


`timescale 1ps/1ps

module eth_f_counter_based_cadence_gen 
#(
	parameter num = 32,
	parameter denom = 33
)
( 
	input wire i_clk, 
	input wire i_rst_n,
	output wire o_cadence
);

logic [7:0] accum, accum1;
logic custom_cadence;

assign accum1 = (accum >= denom)? accum-denom : accum;
assign o_cadence = custom_cadence;


always @ (posedge i_clk) begin
   if(!i_rst_n) begin
    accum <= 8'h00;
    custom_cadence <= 1'b0;
   end
   else begin
    accum <= accum1 + num;

    if(accum >= denom)
        custom_cadence <= 1'b1;
        else 
        custom_cadence <= 1'b0;
   end
end

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q470/irdPggIH5rwIVle8sJvMAyQgbRUsYaXFAAl6J75pYfgL266jhrOti/WKp6EKUlK8O7GRxnjAdrn9jnqvnKUcQuOZev6rW/0jyCXXDi+9VA9go1E3ZEV6qbW7xTcYcjhw9p68+Cfl8aAAcwTXvk1UKGahpfYtd+mvfjyqErdT75tnqN3Idf8qYc8N3h/jPpUMGh9Oa9CDr1/3w+uO7ezgBY5ds/2fWot6SMWyRNgcXKF1gElhzwo9wOTcD5we68CeEijOyTzqxbxKIbL6FI9wwcBYqcvnBi03ifze1DhC1TOWB7B2BDoYcB+Y2JEZIr00YKb897+D9iWtEkMJWhBZqOKBdLyaGXyeXOVB9zJPZLqCtCzfuO8j0M5dmIpRuZjHSt7L/PvVlmceijqx3PJo02czixUVICvg335qgOCjSHpZuxRcxvQJ2QlCHPfZfSAvokJ3Q1g5BCx+udDu0QzMt8gwKiY6nmijC95asTnWU0ewyQ7npNNgG6t1M6o7NiMd5PHsUtvrahYgUAaAZA3PPClNkPEqswjTzQOPCEhZcN6Pa0dxdMNU7wU/kOJ2iKCHG4S6LwdddFFSZWOdSeicb6rjegPb52lIfQpHTb653PV6ViajznD0qeDEvrHqZowKb4QVRmIMevG2LvqvxXHyRNw1CtHFbxXfUs23w6q3H4VSdgWFDaoDgwNIrBlbj+2U7/cAMT7n4HpqNsQ7uQWSiwv9bBRRYJRNiy6iIkCvFVrkTWi6g1Q0298Q++w9qaFi9eooQpf+uRmhmlNXNbx"
`endif