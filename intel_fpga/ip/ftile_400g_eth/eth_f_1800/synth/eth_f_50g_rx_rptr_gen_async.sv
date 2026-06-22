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


module eth_f_50g_rx_rptr_gen_async (
    input   logic               i_clk,
    input   logic   [5:0]       i_ptr,
    output  logic   [0:1][4:0]  o_ptr
);

    always_ff @(posedge i_clk) begin
        case (i_ptr[0])
            1'd0 : o_ptr <= {i_ptr[5:1], i_ptr[5:1]};
            1'd1 : o_ptr <= {i_ptr[5:1] + 1'd1, i_ptr[5:1]};
        endcase
    end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "6HxB0MsBzh8bJi+o1Wq3XLbN3GDVA6Vwbrom9In7H9qPKaf8Su2+43KzP+wXWmluBzTlu9262+K/vvHYtBaJbVRfboq1nN414AuKoMkJkNddXs4ba9JEVA8IS1cTv7IJLIgiBsrOuUHCD16Fwhsk6uJT6rS17cHH5Nq20dagE6aD2UGYWM7OZzb+BU/UP4s4sclbc0QExULWSIKJdOotCJ5HqokL4z5ocq/AIip3Q45SCzuesOheg5BulGBnK5GocFWbDBQFXGxwM7DZPODOPZE/BFWH/lr9Yv9GUaPBMrv7CDEN4Z+GdDLP1wL1YaNAKEb1eC/F10FWYCD+8opN7JoSQFOjhDLvLhIfvWGR2vQ8ZD7zfPmoRz1KZsSl02F0Qf1zIn5h4bnxxIalv8iBj42NLzTxavfWuv3W5fJmhGBPuebZtzMHVOeyF2BT0K9Qr2PA+gC4w00GCl9wkY99OxfO3Qidk50NO/TZZVv69eT4EB1u2eJ1848JpkcQb0QzxDlif+WRPEZL4VKNw3bXjhNBhyfGc51SasWDkCSnWeiZyihj+6YLvsXE7RzY4JTU1dM++J5EPuFlxMXkvYwTAC/Cs8Yv/DmVa+5vDDUqiL3giy1xbW6Cl/W5LkafBlIvJ7XQSZXzC4gbyfs5bDkVF7a1V9t2VFaRvpBp1zkv7+8IOgZ2uwL5uOIbQ00beZybY8Nn5EtQ5rm/rMLpAI1YVnnJkVTm4UAGSoxCjDlsXEjWyr3p4SE0t4wQpm4t34Egj+6zi9DverruUU8zGHlsA0UREu9VGVxEw6GtJYMKnOpz5fcsLH7S45/JtN7BN9ETO59E7kAPV4mFWsKbNTfY51wBrz+neBpESKBmXBWkhARI6dsNUywrzn08z2Jf2ikbtM03asrhkoEnstZB195kAZZ3hfMwQ6vHFGkghXRSGICNdLoOHrrANQR95+ha7xknmUuc9hgA+vCd+SmQDoF4Kj71fLTVf2ootIpRkbB2RaYLoM2EiONKCzvIfACTdGMX"
`endif