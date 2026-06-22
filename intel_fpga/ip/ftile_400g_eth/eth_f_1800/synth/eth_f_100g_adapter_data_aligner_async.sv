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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module eth_f_100g_adapter_data_aligner_async #(
    parameter WIDTH = 32
) (
    input   logic                       clk,
    input   wire    [0:7][WIDTH-1:0]    din,
    input   logic   [2:0]               index,
    output  logic   [0:7][WIDTH-1:0]    dout
);

    logic   [0:7][WIDTH-1:0]            temp;
    (* dont_merge *) reg [0:7][1:0]     index_2;

    always_ff @(posedge clk) begin
        index_2 <= {8{index[2:1]}};
        case (index[0])
            1'd0 : temp <= din;
            1'd1 : temp <= {din[1:7], din[0]};
        endcase
    end

    // always_ff @(posedge clk) begin
    //     case (index_2)
    //         2'd0 : dout <= temp;
    //         2'd1 : dout <= {temp[2:7], temp[0:1]};
    //         2'd2 : dout <= {temp[4:7], temp[0:3]};
    //         2'd3 : dout <= {temp[6:7], temp[0:5]};
    //     endcase
    // end

    always_ff @(posedge clk) begin
        case (index_2[0])
            2'd0 : dout[0] <= temp[0];
            2'd1 : dout[0] <= temp[2];
            2'd2 : dout[0] <= temp[4];
            2'd3 : dout[0] <= temp[6];
        endcase

        case (index_2[1])
            2'd0 : dout[1] <= temp[1];
            2'd1 : dout[1] <= temp[3];
            2'd2 : dout[1] <= temp[5];
            2'd3 : dout[1] <= temp[7];
        endcase

        case (index_2[2])
            2'd0 : dout[2] <= temp[2];
            2'd1 : dout[2] <= temp[4];
            2'd2 : dout[2] <= temp[6];
            2'd3 : dout[2] <= temp[0];
        endcase

        case (index_2[3])
            2'd0 : dout[3] <= temp[3];
            2'd1 : dout[3] <= temp[5];
            2'd2 : dout[3] <= temp[7];
            2'd3 : dout[3] <= temp[1];
        endcase

        case (index_2[4])
            2'd0 : dout[4] <= temp[4];
            2'd1 : dout[4] <= temp[6];
            2'd2 : dout[4] <= temp[0];
            2'd3 : dout[4] <= temp[2];
        endcase

        case (index_2[5])
            2'd0 : dout[5] <= temp[5];
            2'd1 : dout[5] <= temp[7];
            2'd2 : dout[5] <= temp[1];
            2'd3 : dout[5] <= temp[3];
        endcase

        case (index_2[6])
            2'd0 : dout[6] <= temp[6];
            2'd1 : dout[6] <= temp[0];
            2'd2 : dout[6] <= temp[2];
            2'd3 : dout[6] <= temp[4];
        endcase

        case (index_2[7])
            2'd0 : dout[7] <= temp[7];
            2'd1 : dout[7] <= temp[1];
            2'd2 : dout[7] <= temp[3];
            2'd3 : dout[7] <= temp[5];
        endcase
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ3sQ0lLSzWwpxmqAf6vC7weT4mZmB0cF+WyMU4xLoRW9jPN1JYh2Z9q3bgPuTzxYLiUb5rLOR8M7/JRUWxXMADHzCOwvMi9ItGbj/YIjMTMuStadfe1EMPhl+FTk7JIOncSIMpXb+NX158bEUU9eyQOoWBnS0RgEkpd5SGG3pE28CbwmAm6XdP4tMPzSNpl3FpJcIRDjPDR7mQ1xAYrUrQMht26nJrzBmJq0Km4hkPQUfxxxjsMs/Ch1BnQOkzcDjzldUwSJwP70qPKs0mc3wNqsoTBkPzfKNx8wZbUcfzpF1NrhT1ZaFm1DZf8nnSnbIfmg8y+qKq77qXTumYYhZxTYtMuPzxkVXDOjw805czAPUDSwFMtghLR71SkkOWvCe5TXQJacf708614X7rruOZZVZUFl9j4et3owtaryb6ZMp9AvpLA8UyJcYMZAjVgfQuUbFzrMOWvKoMx/SpWXJV2GuUOQUTyApayChriE0MsR3juy6XrKLdvNyVbuKhdAfuL1vM6Tc/puvQ3FtW+2GFnBsmXjX2p05B8TGQ47tH8r4iLN31TexP9+SnjzlnM8aw7yzo3gDebi1WU2Q+u0GFC5aJpXZ25kTt3rmxzg0lPKULu2CMNex0RZBh0PdsBRwweeRGkX3YS+Z8ho322Qtkt2SL9uLLBsZ6j+ZNnt/f8BvAcS6Z6kg7hJkXqqgwfhGXlzs9chr+s5kQDywfAQwbALMVWCcM87U9L3dz6PQ0RJifNwq2Xbl58VYiqvhPatBkruD1aCDRxfk8xCtT0mFYq"
`endif