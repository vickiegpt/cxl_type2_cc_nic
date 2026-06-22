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


// S10 32 deep mlab dc fifo
// Fifo synchronizes aclr
// No underflow or overflow protection
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module eth_f_dcfifo_mlab #(
    parameter WIDTH         = 32,
    parameter SYNC_ACLR_W   = "ON",
    parameter SYNC_ACLR_R   = "ON"
) (
    input   logic               aclr,

    input   logic               wclk,
    input   logic               write,
    input   logic   [WIDTH-1:0] wdata,
    output  logic               full,

    input   logic               rclk,
    input   logic               read,
    output  logic   [WIDTH-1:0] rdata,
    output  logic               empty
);

    dcfifo #(
        .enable_ecc             ("FALSE"),
        .intended_device_family ("Stratix 10"),
        .lpm_hint               ("RAM_BLOCK_TYPE=MLAB,MAXIMUM_DEPTH=32,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE"),
        .lpm_numwords           (32),
        .lpm_showahead          ("OFF"),
        .lpm_type               ("dcfifo"),
        .lpm_width              (WIDTH),
        .lpm_widthu             (5),
        .overflow_checking      ("OFF"),
        .rdsync_delaypipe       (4),
        .read_aclr_synch        (SYNC_ACLR_R),
        .underflow_checking     ("OFF"),
        .use_eab                ("ON"),
        .write_aclr_synch       (SYNC_ACLR_W),
        .wrsync_delaypipe       (4)
    ) dcfifo_component (
        .aclr       (aclr),
        .data       (wdata),
        .rdclk      (rclk),
        .rdreq      (read),
        .wrclk      (wclk),
        .wrreq      (write),
        .q          (rdata),
        .rdempty    (empty),
        .wrfull     (full),
        .eccstatus  (/* unused */),
        .rdfull     (/* unused */),
        .rdusedw    (/* unused */),
        .wrempty    (/* unused */),
        .wrusedw    (/* unused */)
    );

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q47N9rp7tDlqP/oEMlrq80k1oiNw6vBkFIUflJrPV1LXHwZqeit1VWGChe8q1+k5itBRie3VKst0qigMhNnNBWvtah/TnNS7i0UiVJyt2nlGG9hCWwr/9Gbr1FL/tnVut/rKlFQhrZOO9OnKNTKVScC1MpPlHKhY3DIYZe5VJsmpnNhJOu9w7JjIUYso9Iq0p8l18VhpTfpAfS7aC8tD80VJuZRSf1rqHwIXJToS+79rssR8QQ6U3M1RmwUfX51qBeroSIEje71/YiQ4ScsHHLH/0LNuR4JmlrN+gXju8YCIu2PeFYpdCPiXkGRaFUlb2kPwzzp79V+1gybFhsgORTH2zZUvg/2wHZwAg6tCj/ON8Rz7SSiOkoL/Pq8o1GskBOnx56hdQNmiLNmf0pTaHZ7k9Qlh9JJ2LG/Zo0hMO5jeReKbQc85otQ9IBMMJEzZQRYkEsIal5nq5II1AYrQ8rSu63UyB2VAWkULWjOEwvfVnZGR3LuEPjaWVmpj9x2yK0bg1WziAYaccGYVxFeYj0GlhPQlGMQDKmDtKBI9WlvQ3jwYsC6gcxJg4bnv6xtcQs30l4wTHTwcFwX+X+iSmAIX3RmAsBL37A3X9uy69NlqKFCbIHQ4h43jLbAyLPOha/DHztLzsOmYvBnJZO+N7Fo6wAM2Oywy8Lti3xWqoyfXPyxdg37snzNaVaB73aAzE7zhVG759kCsVFRj6cmZgONEKrZvjJmSMS6RZ6B6t3j2BvjpPxO3Euh951lK3UaSlA8nGZPY28Ckyupsu9j+6M5R"
`endif