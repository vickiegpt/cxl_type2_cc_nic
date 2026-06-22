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

module eth_f_scfifo_mlab #(
    parameter SIM_EMULATE       = 1'b0,
    parameter WIDTH             = 64
)(
    input                   clk,
    input                   sclr,
    input  [WIDTH-1:0]      wdata,
    input                   wreq,
    output                  full,
    output [WIDTH-1:0]      rdata,
    input                   rreq,
    output                  empty,
    output reg [4:0]	    cnt
);

    reg [4:0]   w_ptr;
    reg [4:0]   r_ptr;
    reg [30:0]  used;
    reg [4:0] cntnxt; 

    reg     [WIDTH-1:0] readdata_reg;
    wire    [WIDTH-1:0] readdata_int;

    wire    write   = wreq && !full;
    wire    read    = rreq && !empty;


    always @(*) begin
	cntnxt = (write & !read)  ? cnt + 1'b1 :
		     (!write & read)  ? cnt - 1'b1 :
                                      cnt  ;	
    end
    always @ (posedge clk) begin
        cnt <= cntnxt;
        if(sclr)
        cnt <= 5'd0;
    end // always_ff @ (posedge clk)


    assign full = used[30];
    assign empty = !used[0];
    assign rdata = readdata_reg;

    always @(posedge clk) begin
        if (sclr) begin
            readdata_reg <= {WIDTH{1'b0}};
        end else begin
            if (read) begin
                readdata_reg <= readdata_int;
            end else begin
                readdata_reg <= readdata_reg;
            end
        end
    end

    always @(posedge clk) begin
        if (sclr) begin
            used <= 31'd0;
        end else begin
            if (write) begin
                if (read) begin
                    used <= used;
                end else begin
                    used <= {used[29:0], 1'b1};
                end
            end else begin
                if (read) begin
                    used <= {1'b0, used[30:1]};
                end else begin
                    used <= used;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (sclr) begin
            w_ptr <= 5'd0;
        end else begin
            if (write) begin
                w_ptr <= w_ptr + 1'b1;
            end else begin
                w_ptr <= w_ptr;
            end
        end

    end

    always @(posedge clk) begin
        if (sclr) begin
            r_ptr <= 5'd0;
        end else begin
            if (read) begin
                r_ptr <= r_ptr + 1'b1;
            end else begin
                r_ptr <= r_ptr;
            end
        end
    end

    eth_f_mlab #(
        .WIDTH       (WIDTH),
        .ADDR_WIDTH  (5),
        .SIM_EMULATE (SIM_EMULATE)
    ) sm0 (
        .wclk       (clk),
        .wena       (write),
        .waddr_reg  (w_ptr),
        .wdata_reg  (wdata),
        .raddr      (r_ptr),
        .rdata      (readdata_int)
    );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "4AvUa/AX+twoSNmlxf8DfgbJZtLM0FTYaDfqwIVh58kyS9m523ZPwLwxNf/MAu2Ws24gvNuIWubOgwJDJF/J8SquMj7R1nNyipeKzuCa44Ouq3sVSfXA6vNne7RbKwd87qtqmEuaCdIDSUZZO8uw+CWUHgUS5S0PLelh7tY7EIuUsZeE9mUM9zh2JvtzuWMzW1qicCsSFUI1HHB6Owmf0ylz2E7BXtP0spRRZWMpnQ0E1433q93T2L1WHUlVDbveoPea/4eTV36oyjg2qccqgq24dXtlx7PITVxlD2VG7PD2wkiTZtBT9zAJJHDvbMAkRSbmIW+x1AUIVRuOpoZeRe4ULblFq03imWRO8w+QhjjYIbxbWIHMjAk7UC8CPZmUimZRgd/O5WjrrM1kl+kz0/EEf7C0qv+W0wEbbKHLcLQc5lf4nwm1Qrm04UC2kUULfKjQpeVIJdSnIdqiHOsa9+i4Ks9awycmImZBLZEPIKkYuXBw8sous6hBcHjoh0c1ut/CN2z5eMeEp5ulVDMrm4CXgW4L9KVfldprD6DJiN28mTYr296OgDyy3A94jhfOKIDykkiUBmXrM69mEQfcgkBZ4F2Q64gz8FfUwGwTmY7D5YFDwP3YIBVHnHilP9mo0ADJNRVnc4GWSphYLgWoXyGcod+ylTTK7xCoV+TGRXLP5NMBHvQw4zALaezV2OmJpaaLvfLXtX+jrHe2LptgrNosKQQKQYiTLCJzaC5uPhE46+5lvL32C5CXJ+A8nHMvNY8l+p0UDFbLFc0HMB/BVxGJLknifdH9m3H2RXVtw2cUbDTZHYotaAnH1yRaL6/jgLdPYtiYAX9DtZB3RWwNrR3znWdgtl3e1Zlmepo9HRHwoto8rF532rvChuWD1dgbRUbWYx/QPuo/fdbVaHAWcD1jQqKyQ0pfcF4e9jRXXWQIkx4TLFoV0GsNxntWU8XeOFJo35ZB9xkYTXwI45L/+0Gfiu7Lfxof65/phzLRduVPmCDwtyoMFJAT/8Ois0Ot"
`endif