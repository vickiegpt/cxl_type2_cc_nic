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


//=============================================================================
//Description
//custom cadence controller implemented using efifo_f
//=============================================================================
//Declaration
 
//synthesis translate_off
`timescale 1ns / 1ps
//synthesis translate_on
 
module eth_f_custom_cadence_controller #(
    parameter EHIP_RATE 			= "40G",
    parameter SIM_EMULATE = 1'b0 
)(

    //input clocks and resets
    input   logic            i_tx_rd_clk,   //o_clk_pll
	 input   logic            i_tx_wr_clk,   //clk_tx_div
	 input   logic            i_reset,       //tx_pll_locked
    // output
    output  logic      o_custom_cadence
	 
);

wire tx_wr_en;
wire xcvr_if_data_valid_w;

generate
if(EHIP_RATE == "40G")begin
wire reset_sync;

  eth_f_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH(3),
    .WIDTH(1),
    .INIT_VALUE(0)
) tx_pll_locked_synchro (

    .clk        (i_tx_wr_clk),
    .reset  (1'b0),
    .d        (i_reset), 
    .q       (reset_sync)
  );
  
logic tx_wr_clk_2;
always_ff @(posedge i_tx_wr_clk) begin
	if (reset_sync) begin
		tx_wr_clk_2 <= 1'b0;
	end else begin
		tx_wr_clk_2 <= ~tx_wr_clk_2;
	end
end
			
assign tx_wr_en = tx_wr_clk_2;

end else begin
assign tx_wr_en= 1'b1;
end
endgenerate
		  		
localparam CCC_DWIDTH = 65; //64 +dv on MSB

//custom cadence controller with it's ram disabled
        eth_f_ccc_w_fifo # (
            .WIDTH       (((CCC_DWIDTH/20) + 1) * 20),
            .DISABLE_RAM (1),
	    .SIM_EMULATE(SIM_EMULATE) 
        ) ccc (
            .aclr   (i_reset),    
            .wclk   (i_tx_wr_clk),
            .wreq   (tx_wr_en),  
            .rclk   (i_tx_rd_clk),
            .rreq   (1'b1),
            .rempty (),
            .data_valid (xcvr_if_data_valid_w)
        );

always_ff @(posedge i_tx_rd_clk) begin
o_custom_cadence <= xcvr_if_data_valid_w;
end

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapXeOTb3etIf3rLwC4Lj6VyPILxQWwxQsWLbh0tDmkxrwKae3PlADMTXhIQyZWUG5leF8nk7eQHZuOXxTvrOq24XcH3lJgUIZnoUyhwgQx/uQlKEBHpw0SqqRB2Bk0HuEH/nl1upDYBiNDyumtI2oJd/ptJPIaX2sTgSXqz/ZyuM6oo+rYIe7Fi9cah8G3D27XNBfTJhFwKeNiiKYbTjcH0Cn5eOYkQI8KlZAE4fxa8LOMBry5job9WbFgWgj/f0joNe22CE4Tbh2oMX8gK3ok5lrBvCz8baYT4HzeLquns9RFYZnYpy8EFO6iIZWfGPmrZBLulg/9/GVeNHke8U5VGta4gt7iqbrrD78TGTwUKcI8r0/sj6Nf+o01zwGj3kEBW8a4gZU+HuRLq9JXWjdhoTXSToQGvkfJa6WZlo+JSLrxOis0tUiAlDW5F/ypowCkvqgkpzT7Xney9ndPpJ+L3N2bXmVk1pv9mre8MGPRLjfRquQkfO4CrCnhBQjlYaHTXTx4gf+qZZ6oqZ0e3MJmtOSeDUVSiWBZwFeImahttVceC8WoBUC7b3H8wk0dklRErVoY5q2IkwvRbBwVFPtqSQ5SNIFOh62HKCXqB3E1p2BXiuBFW7S+wldpCod9kBs7227bnaA+nos9vG9HUtHajgIwzIFgtBWPnSMIKbN2zIx3hxKYUrCNfQLZCYxRi2pVGMVBZdXdSye8UCfZDN9eVT0kqFhbnHPUeQyrzcecNu/ohBurJHoK/f6cMNztLgBYfVfQRgWMadEWWZHlRPAXqx"
`endif