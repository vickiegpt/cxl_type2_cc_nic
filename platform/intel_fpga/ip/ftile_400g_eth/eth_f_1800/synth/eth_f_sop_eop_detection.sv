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


module eth_f_sop_eop_detection # (
parameter       INFRAME  = 0

)( 


input logic [INFRAME-1:0]      rx_mac_inframe,
input logic                    rx_mac_valid,
input logic                    clk_i,
input logic                    srst_n_i,

output logic[INFRAME-1:0]              SOP_detected,
output logic[INFRAME-1:0]              EOP_detected

);


integer i,j;
logic rx_mac_inframe_d;

always @(*) begin
  for (i=0; i<INFRAME; i=i+1)begin
    if ((rx_mac_valid == 1'b1 ))
         SOP_detected[i] = (i!=0) ? (rx_mac_inframe[i] & ~rx_mac_inframe[i-1]) : (rx_mac_inframe[0] & ~ rx_mac_inframe_d);
		else 
	      SOP_detected[i] = 'h0;	
    end
   end   

always @(posedge clk_i ) begin
  if (~srst_n_i)
   rx_mac_inframe_d <= 1'b0;
  else if(rx_mac_valid) 
   rx_mac_inframe_d <= rx_mac_inframe[INFRAME -1];
end

always @(* ) begin
for (j=0; j<INFRAME; j=j+1)begin
    if (rx_mac_valid == 1'b1 )
         EOP_detected[j] = (j!=0) ? (~rx_mac_inframe[j] & rx_mac_inframe[j-1]) : (~rx_mac_inframe[0] & rx_mac_inframe_d);
	 else
	    EOP_detected[j] = 'h0;
    end
   end   


endmodule






               
                                        
















`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "IHWHrFSUaPtjZF1LBDe+5u/fCSc0//dMeoOgG/ez60Rt84WK1OI/WsMDAOmCm2IklwNYebRgS3zVDw7MPxWxM11LRVdkLZ+X/y8WtfqnS7Duroraj/37v+2WHhkPuM7Zr5jlblPypJOlE04iTTEfu+W3Q6H2vZl2TlAJ75jp9EioCxq3Erh26V4am36iNzJ8q9nPT5rffTeZv2243MrLgLaBmit/Byil0W+B47PrapXA/tL1cqkeeBvJ6u9JTFOi2HywcY9hWQAOzp7CEh/V+kk7+/CmenCu7K072cOy1jhSp/m+bp4hZtM1/BZ/erty/YHl93diHDJvz64iD0G1DYc7vJPwq4XQfpdq8Qky5t+x1c0V2pMX27/hJ9igtkTMQ4kLXRI3mHm/6DRKllAlk+iQZQjSdExcgpg28sT7RMq53PMpwT/Zuq1dEr+XPw4i8BRO1bMsNb6yM79k8sgqPN94oXb6IkheL7sJ5lLpgfn+2EyFHV7C7Qx1TdncR9cbRj2rNxfQtjnHluOpptEBaNjWc/msNyMwNT1xFMM/IawBiMxp+Q+/hwBik4hq4ZlwRjpr1caDG0z2xCeA1uyMK8BnynMvSHsVxP6gJznpAIzNyUfBmzk4krqftrSPvggMJL+iwCl72EPLb6Ak2jGZQmEmyBHLaYj+EV7aRqeBomFYKdNXZveuB2DhoBm4tjMkvP5A7f7W9osc1henA7kdxcf807YjN5Ou4rEUX0QTZZYdyTBaUtsF4KdMKhl57gKyoscWK6qVgZ2G0VgyNHrL/r6ye1h2/c7JEI5whKf/IWeuwcIHwoOSSGB9m7nhq2bewGz+ZLaRu2CIOYu05pxw6p8D+tQC/B8CDjoDe1tdRzvx5kCTf1LhpXJ7FI0Med8NgpThkKKSKtYRAjTWgVJNaYiUifAhotNwKUSppINRKbkjWUN8N6UBxdHHWZGOlt7UoE2nvszQsz1xuoeFPZ6qW/c415CGiYosKI4fF1hRA4dkFuekQU52uVPAsYSGIOvh"
`endif