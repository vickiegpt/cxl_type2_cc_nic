# Generic Intel FPGA Platform Payload

This directory contains the Intel FPGA side of the generic Type-2 CC NIC
integration. It keeps the reusable PCIe and MAC IP payload without board
management logic or board-specific pin constraints.

## Contents

- `ip/`: F-Tile 400G Ethernet, F-Tile system PLL, user PLL, and reset-release IP
- `qsys/ip/pcie_ed/`: non-management PCIe endpoint constituent IP and BAR/reconfig bridges
- `rtl/from_ed/`: Intel Ethernet example-design packet client helpers
- `rtl/intel_type2_cc_nic_shell.sv`: generic boundary around `rtl/type2_nic/type2_nic_top.sv`
- `build/type2_cc_nic_intel_files.tcl`: Quartus filelist for the generic payload

The inherited Platform Designer system included management-controller
components and board services. Those components are deliberately absent here.
Regenerate a board-local Platform Designer top from the included PCIe and MAC
IP if the final target needs a monolithic generated system.

## Build Boundary

Use the filelist from a board-specific Quartus project:

```tcl
source ../platform/intel_fpga/build/type2_cc_nic_intel_files.tcl
```

The board project should provide:

- `DEVICE`, family, speed grade, and tile placement settings
- PCIe serial lane and reference-clock pin assignments
- Ethernet serial lane and reference-clock pin assignments
- reset sequencing and any site-specific timing constraints
- the host DMA requester, if `DMA_BACKEND_PRESENT` is enabled

This repo does not carry board-management pins, management SPI interfaces,
board telemetry blocks, or old local build reports.
