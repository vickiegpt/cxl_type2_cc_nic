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


`timescale 1 ps / 1 ps
// baeckler - 07-12-2014
// DESCRIPTION
// Wrapper for MLAB hardware cells in typical arrangement

module eth_f_mlab #(
	parameter WIDTH = 20,
	parameter ADDR_WIDTH = 5,
	parameter SIM_EMULATE = 1'b0   // this may not be exactly the same at the fine grain timing level 
)
(
	input wclk,
	input wena,
	input [ADDR_WIDTH-1:0] waddr_reg,
	input [WIDTH-1:0] wdata_reg,
	input [ADDR_WIDTH-1:0] raddr,
	output [WIDTH-1:0] rdata		
);

genvar i;
generate
	if (!SIM_EMULATE) begin
        /////////////////////////////////////////////
        // hardware cells

        // the fourteen nm only (the Stratix 10) needs another data register
        reg [WIDTH-1:0] wdata_reg_2 /* synthesis preserve */;
        always @(posedge wclk) wdata_reg_2 <= wdata_reg;


		for (i=0; i<WIDTH; i=i+1)  begin : ml
			wire wclk_w = wclk;  // workaround strange modelsim warning due to cell model tristate
            // Note: the stratix 5 cell is the same other than timing
			//stratixv_mlab_cell lrm (
                        tennm_mlab_cell lrm (
				.clk0(wclk_w),
				.ena0(wena),
				
				// synthesis translate_off
				.clk1(1'b0),
				.ena1(1'b1),
				//.ena2(1'b1),
				.clr(1'b0),
				.devclrn(1'b1),
				.devpor(1'b1),
				// synthesis translate_on			

				.portabyteenamasks(1'b1),
				.portadatain(wdata_reg[i]),
				.portaaddr(waddr_reg),
				.portbaddr(raddr),
				.portbdataout(rdata[i])			
				
			);

			defparam lrm .mixed_port_feed_through_mode = "dont_care";
			defparam lrm .logical_ram_name = "lrm";
			defparam lrm .logical_ram_depth = 1 << ADDR_WIDTH;
			defparam lrm .logical_ram_width = WIDTH;
			defparam lrm .first_address = 0;
			defparam lrm .last_address = (1 << ADDR_WIDTH)-1;
			defparam lrm .first_bit_number = i;
			defparam lrm .data_width = 1;
			defparam lrm .address_width = ADDR_WIDTH;
		end
	end
	else begin
		/////////////////////////////////////////////
		// sim equivalent

		localparam NUM_WORDS = (1 << ADDR_WIDTH);
		reg [WIDTH-1:0] storage [0:NUM_WORDS-1];
		integer k = 0;
		initial begin
			for (k=0; k<NUM_WORDS; k=k+1) begin
				storage[k] = 0;
			end
		end

		always @(posedge wclk) begin
			if (wena) storage [waddr_reg] <= wdata_reg;	
		end

		reg [WIDTH-1:0] rdata_b = 0;
		always @(*) begin
			rdata_b = storage[raddr];
		end
		
		assign rdata = rdata_b;
	end
	
endgenerate

endmodule	

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q477eBFJUqKzUrApofCDFCJkxTaDTyWejkzOfvV8hRf5y4S8rv28MBNIjCz+JdPwLvcUBPAYPAE+LAFli0aC0QLCCExa7OqHLM7FyffbzAps/ccd9ajNB0q4E2woatDfOcnAYDor4GxbLTF1mSbqT8DnSBAfdXkx5k4+hmY77STQfsotjP6ydwO0qd3ns17KWGVI1mbjDNeEMWaOKFX0URcdzeOPrpINJAD+LQLlfEsz2qi6qo8fl3/qDj50MyqIwPD82AvxhOSyPZOCuP2nRCXLKVmKQMFhpsO2nhhM+jkz+CabcTnr2YlzRkA8csqUIHznVwmEBvaieZfkGiAEOx4h9t4ZIRzm8iJNgkuQHmb4cY2RdwNzLvHdKw2faWsAOzFJRuK+SHQmwx7UdlgXPL0MLKHsJwbsJLI6gGB1Y/TWCeHThOKISoPI2yiVXooRe4mFcIRDz8EymeyxTCiTJwI8MXLqZRmjI/sue11oO9Q6JR0iomTu/Vsqy9A/RNKHt03SE2Bw0t9Hq6rXxL/gFyELdIfhZwGQ2RbIW0d1s38BE63QXqqeZyejzjBE2dxpKI3WmuBN8kGrLpZim9uq3FgnZRRXkw1pLjjiyO4liqpFqyssCG9QnL9uWwUS/4DoIlYSs3noaN/W2xevlWJqkNBisp0evtA9xXry2QB2R2U0XisQMEsFhmlUZGnJ2uKFGtD61e4RkxuTJWPy/x3FqiQXTlZP1lXuTyWhAthFZ/NfT083i2/vHzLN37/kGxlYUbGtlL+4upS0ugQjDqIrkwLh"
`endif