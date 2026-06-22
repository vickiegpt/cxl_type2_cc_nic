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


// $Id: //acds/main/ip/pgm/altera_nd_mailbox_avst_adap/altera_nd_mailbox_avst_adap.sv#2 $
// $Revision: #2 $
// $Date: 2015/10/19 $
// $Author: tgngo $


`timescale 1 ps / 1 ps

module  altera_s10_configuration_clock
    ( 
    clkout
    );

    parameter DEVICE_FAMILY   = " Stratix 10";
    
    output   clkout;
    
    wire  wire_clkout;
    
    assign clkout = wire_clkout;
        
    // -------------------------------------------------------------------
    // Instantiate clock source end point
    // -------------------------------------------------------------------  
    altera_config_clock_source_endpoint s10_config_clk_inst (
        .clk        (wire_clkout)
    );

    
endmodule //altera_int_osc
//VALID FILE
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "xSvs1hurHuCzoptkBuKl8Eg91An0kmwAWuXnG7CXkJHtFCSWhhMUzNF6ROiyJrH5/GqMiyyJsBJdsO8Uo3SNWvN64TFW3PHbl+mXxCU+WS3GKnRxHplsxH6C6awdJrFZmpKVBft1DqdJaUWMSZq4s0y90YbG8pnp1qnwRKN7dh3kf8/S8dkygjua23pvDRHlcgZwDTaDtjvub+M4LGEEtTdQqTYgFvlJ574wUVnFC3OrLkc+WPCmwCRdNZ7fWMJ+U5xUyFfG0OALvpqCqNEt6IsIaMXluNOHAjI2g/VjM+EO1cp7Pxcg8sbgx1EIy4nxqsTgyGggRDNlmtVgKzYjNfHFxDhJZ96AMUyznLSRMbeHOviuRDIfpWvaDIT4VGjqaU8DNvJUQtAHuenQUaJ7PL5ZBxIyZ2kOa35DBW935eWzpj/4RFFVGV3pmLDbuyUr2AjtR/8VSMk+KR4DLYeLUB3lYl05o5GzQpTtb2g3rVSFdFdiUZdgCJrd+qhetEIyKuNebYPSH/wQidUsDRb5Cgyo6Wca9Y6ez2AWU+JFIQTjTN1vlvtHmBKTSSURe4KDhSZrkcOy6WV5Cq032YuLZuB/l0GNhh9tgV7RkGvkqz9zAwj4F8bWsp8Z4s1OoJZHcOE0WIP+m3u9W1npv6Py0sIOjyPjXU6uhJ24r2YLfju6aXhASdmejoiGvRpxy2OEOk53VcS2JOs2v2Ac3723WdVk2fFfViNKC8GIw9ZZtgq/FIwC9v4k0/bxRF8EKfg5XFomxmib8+KwValJSuU6uu26MGTjur9yvLjSl7j9pTD1EJIgyvLC286HBGOPfDOSH0QyNlKDUVuUs4/0sVH5ZoA6ClOJK5fNCQom8lzG64PDzRvmP3R31+lEAizwGf5hcSpFCVRk0I3GE/gcs94xJ6fBBK5jDSaNwcIF1s+lMBrwXwVvAgfrDPVmFD2g+yGzzsYXgs8pAi3fmgd6YOQ1PDlLJy7eUtSOpD3234T//YoMTmyDuBZ8ar4//Udhzs5n"
`endif