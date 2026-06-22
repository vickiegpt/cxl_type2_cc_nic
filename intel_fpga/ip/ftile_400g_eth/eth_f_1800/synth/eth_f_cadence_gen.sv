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


module eth_f_cadence_gen #(
parameter SIM_EMULATE = 1'b0
) (
		    input i_rst_n, 	//Reset input, active low
                    input i_clk_tx_div, //TX PMA Div66 Clock (390M/312M/156M)
                    input i_clk_pll,    //GDR System PLL Clock(403M/415M or Custom Clock)
                    output o_cadence    //Cadence output @ i_clk_pll
                    );

//custom cadence - efifo implementation
localparam AW=4;
localparam THRS=7;

logic [AW-1:0] wptr=1<<(AW-1), rptr=0;
logic [AW-1:0] wptr_sync;
logic [AW:0] ptrdiff;
logic [AW-1:0] ptrdiff2;
logic pempty;
logic i_rst_n_sync;

// synchronize i_rst_n with div66 clock
eth_f_altera_std_synchronizer_nocut rst_n_sync_inst (
    .clk        (i_clk_tx_div),
    .reset_n    (1'b1),
    .din        (i_rst_n), 
    .dout       (i_rst_n_sync)
  );




always @ (posedge i_clk_tx_div or negedge i_rst_n_sync)
begin
    if(~i_rst_n_sync)
        wptr <= 0;
    else
        wptr <= wptr + 1;
end

eth_f_pointer_synchronizer #(
	.WIDTH      (AW+1),
	.SIM_EMULATE (SIM_EMULATE)
) u_wptr_sync (
		.clk_in     (i_clk_tx_div),
		.ptr_in     (wptr),
		.clk_out    (i_clk_pll),
		.ptr_out    (wptr_sync)
);

assign ptrdiff = wptr_sync - rptr;
assign pempty = ptrdiff2 < THRS;

always @ (posedge i_clk_pll or negedge i_rst_n)
begin
    if(~i_rst_n)
        rptr <= (1<<(AW-1));
    else
    if(wptr_sync[AW-1:2] == rptr[AW-1:2])
        rptr <= rptr + (1<<(AW-1));
    else if(pempty)
        rptr <= rptr;
    else
        rptr <= rptr + 1;
end

assign ptrdiff2 = ptrdiff[AW-1:0];

assign o_cadence = ~pempty;

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapXiQOZ0pGGvGSPzbOsrGjf0hzv1LECfyA1VrlhiiFck7ktrc20KmK+MiGHatJqNyNolbLSyjvL6idimn1sR9cqv9KizHZ9aMEzjJI2RUZGLzSO0HvxyUJZq/lzkqY/lbuwHY0/9U/rzD6ol8/3xvY5tANHN/ChjM3mZ3Wfr2ODMy2Ek5S9EuimsXdk/YutMMkau9MSDOe8ZNVIurt9DeBYuyBRAumJCt+dRWpxmpR0JvL4TzmlrYv8yr1QUBd87q6sq47xrCRIKjwZGdG63Lu/74xQaygFgs+wgyP9WZaLaAVz/2mwzT3eoDwBR1daxvkTUnrQEgT9DoSZeEmxaTlVmRBkQiC36GdeN615vgGYoHd+Yog6wZcdQeL0+cp9Etryw8SeeiZvHvJvmwChsHDL1svpKkzBJ/jAVDwnV9khLdQH1/DDG2N6qh0XnIIyH0hpRRcCVWYt8a2H49N9NScQlKH/bdmm54UE0BLkXlZgm7n9Ic+3jz4WIpGWNaNvZsOpunLgpVwp+UPdOxG2NJapxH+NgZ79SQ6MZ4NE2DotilbYr1sSyycBnO6+y3FTE/VE5IfERxiYcxvhu7dD/Wqlldc/r+h/EqScL+ytS+l4Io4BHBT/IAZ+iGvasrovQRwN3yAOkmRYjGrK+RyM6W5SFiBRACtGN+UdfEthexdY2CmLN1zWUVk7ONq8whipopjPPvMba/Ju1YKqMWBK5iRMLdBf9+YVVg3G5d7Y8KtE5Ee3puIzSJeI7WEVt5w88P/ryScdG2+AJt4lqRDMi/B7T"
`endif