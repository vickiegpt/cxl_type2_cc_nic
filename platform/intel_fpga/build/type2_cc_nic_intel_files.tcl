set TYPE2_PLATFORM_ROOT [file normalize [file join [file dirname [info script]] ..]]
set TYPE2_REPO_ROOT [file normalize [file join $TYPE2_PLATFORM_ROOT .. ..]]

proc add_platform_ip {relpath} {
    global TYPE2_PLATFORM_ROOT
    set_global_assignment -name IP_FILE [file join $TYPE2_PLATFORM_ROOT $relpath]
}

proc add_platform_sv {relpath} {
    global TYPE2_PLATFORM_ROOT
    set_global_assignment -name SYSTEMVERILOG_FILE [file join $TYPE2_PLATFORM_ROOT $relpath]
}

proc add_platform_v {relpath} {
    global TYPE2_PLATFORM_ROOT
    set_global_assignment -name VERILOG_FILE [file join $TYPE2_PLATFORM_ROOT $relpath]
}

proc add_repo_sv {relpath} {
    global TYPE2_REPO_ROOT
    set_global_assignment -name SYSTEMVERILOG_FILE [file join $TYPE2_REPO_ROOT $relpath]
}

set_global_assignment -name IP_SEARCH_PATHS [join [list \
    [file join $TYPE2_PLATFORM_ROOT ip] \
    [file join $TYPE2_PLATFORM_ROOT qsys ip pcie_ed] \
] ";"]

add_platform_ip ip/ftile_systempll_ref4.ip
add_platform_ip ip/ftile_400g_eth.ip
add_platform_ip ip/reset_release.ip
add_platform_ip ip/user_clk_pll.ip

add_platform_ip qsys/ip/pcie_ed/pcie_ast.ip
add_platform_ip qsys/ip/pcie_ed/pcie_ed_pio_1024.ip
add_platform_ip qsys/ip/pcie_ed/mm_ccb_0.ip
add_platform_ip qsys/ip/pcie_ed/bar_pipeline.ip
add_platform_ip qsys/ip/pcie_ed/bar_pipeline_post_cc.ip
add_platform_ip qsys/ip/pcie_ed/bar_pipeline_width_change.ip
add_platform_ip qsys/ip/pcie_ed/bar_pipeline_post_wc.ip
add_platform_ip qsys/ip/pcie_ed/bar_pipeline_bar2.ip
add_platform_ip qsys/ip/pcie_ed/sys_clk_bridge.ip
add_platform_ip qsys/ip/pcie_ed/sys_rst_bridge.ip
add_platform_ip qsys/ip/pcie_ed/pcieclk_bridge.ip
add_platform_ip qsys/ip/pcie_ed/pcierstn_bridge.ip
add_platform_ip qsys/ip/pcie_ed/jtag_master.ip
add_platform_ip qsys/ip/pcie_ed/jtag_mm_bridge.ip
add_platform_ip qsys/ip/pcie_ed/host_sdm_mm_bridge.ip
add_platform_ip qsys/ip/pcie_ed/sdm_mailbox.ip
add_platform_ip qsys/ip/pcie_ed/sdm_reset_bridge.ip
add_platform_ip qsys/ip/pcie_ed/ftile_main_mm_bridge_0.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_mm_bridge.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_eth_mm_bridge_0.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_0.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_1.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_2.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_3.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_4.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_5.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_6.ip
add_platform_ip qsys/ip/pcie_ed/ftile_qsfpdd0_xcvr_mm_bridge_7.ip

add_repo_sv rtl/type2_nic/type2_nic_pkg.sv
add_repo_sv rtl/type2_nic/type2_tx_dma_engine.sv
add_repo_sv rtl/type2_nic/type2_rx_dma_engine.sv
add_repo_sv rtl/type2_nic/type2_nic_queue_regs.sv
add_repo_sv rtl/type2_nic/type2_nic_top.sv

add_platform_sv rtl/intel_type2_cc_nic_shell.sv
add_platform_sv rtl/from_ed/eth_f_hw_dual_clock_fifo.sv
add_platform_sv rtl/from_ed/eth_f_hw_dual_port_sram.sv
add_platform_sv rtl/from_ed/eth_f_hw_pointer_synchronizer.sv
add_platform_sv rtl/from_ed/eth_f_latency_measure.sv
add_platform_sv rtl/from_ed/eth_f_loopback_client.sv
add_platform_sv rtl/from_ed/eth_f_loopback_fifo.sv
add_platform_v  rtl/from_ed/eth_f_multibit_sync.v
add_platform_sv rtl/from_ed/eth_f_packet_client_csr.sv
add_platform_sv rtl/from_ed/eth_f_packet_client_csr_pkt_cnt.sv
add_platform_sv rtl/from_ed/eth_f_packet_client_top.sv
add_platform_sv rtl/from_ed/eth_f_packet_client_tx_interface.sv
add_platform_sv rtl/from_ed/eth_f_packet_client_tx_mux.sv
add_platform_sv rtl/from_ed/eth_f_pkt_gen_pingpong_bf.sv
add_platform_sv rtl/from_ed/eth_f_pkt_gen_rom.sv
add_platform_sv rtl/from_ed/eth_f_pkt_gen_top.sv
add_platform_sv rtl/from_ed/eth_f_pkt_stat_counter.sv
add_platform_sv rtl/from_ed/eth_f_seg_crc_da_tx_cal.sv
add_platform_sv rtl/from_ed/eth_f_seg_crc_rx_chk.sv
