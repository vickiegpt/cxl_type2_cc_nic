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

// DESCRIPTION
//
// This is a small register circuit for synchronizing aclr signals to produce asynchronous attack and
// synchronous release across clock domains.
//



// CONFIDENCE
// This component has significant hardware test coverage in reference designs and Altera IP cores.
//

module eth_f_reset_synchronizer (
    input   aclr, // no domain
    input   clk,
    output  aclr_sync
);

wire aclr_sync_n;

    eth_f_altera_std_synchronizer_nocut #(
                    .depth(3),
                    .rst_value(1'b0)
         )  synchronizer_nocut_inst  (
                    .clk(clk),
                    .reset_n(!aclr),
                    .din(1'b1),
                    .dout(aclr_sync_n)
    );

assign aclr_sync = ~aclr_sync_n;

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ0AfXgtjtsGW4cpyQYyYizM0HfW7q2MRzPaM3fCJioIINmqJUUHj7xbj41allse3Cm712rsv1nOJSNRr/ySXH9Fz2mUK7MJd93JyxFIJP12Jdz6J0RfXrj6nFZcD7IyV0wB98RhSFSn9jKx+SpbZIoFSM2y4F1Esi0snkquMwQfZ46nynueqnE+rxAoNU3teQ6zAKskmcEPigae3oWWUTx7KRlo2lGtD6kbd/oTeLjReoYPh9MUJCS+u85lvth5xtnUNgc9A8lZQzynf5IoT/nIPTsbrlZHso2x/DhPS3loXjkVPcS5xHO1wdq40vCTu1JNtW6wuWmlRXRzZg+OUlUNckqDg3ED7f2kooRokCXNOtPdP/ig5eEDmZKfp60RTRIVHW+DLdIZJaX9wd35zCVP6weRFsAAT5WwELCZfGv+WX6f5/HqC/drNgZrdeuauAvHvkGnuYqM97J5FRlBFwPBs+qdxBNgS5BleqPJ9iPRSwql7fxN+RBawha/qvhUfoBqDjsl21lD9xOUvYo5wgYN498hsZo/T1vZkz2zyWcGmtLKqtCSGJ/bsfnSo5a2tO+X7IBUEzxqFS3zxIBFIWrev1CjdBcANolod4y4yENkTG8JdxJnNC+dhlC8IkJ1h7DMdorwQNzTR5w5z7Ii8VlQI9a6H+o+NTMYfTpQLggAoGOq50XQjygbUpLdOH9qeXwHhjqDreVAdFKALuQ1DbonYK0AlZoofY6oTPbTEubyJJXr8CXDECL9OAOAG1bi/Ce5t6Hq6YeP1+fHuwih30Lu"
`endif