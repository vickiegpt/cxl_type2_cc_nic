# CXL Type-2 CC NIC

This repository contains a generic Type-2 CC NIC bring-up stack:

- `rtl/type2_nic/`: reusable SystemVerilog queue, MMIO, and optional host-DMA NIC logic
- `platform/intel_fpga/`: Intel FPGA PCIe/MAC platform IP payload and generic filelist
- `driver/`: out-of-tree Linux netdev driver for the Type-2 CC NIC register model
- `scripts/type2_mmio_eth_test.py`: host-side BAR/MMIO packet-path bring-up tool
- `docs/type2_cc_nic.md`: register map, queue layout, and integration notes

The Intel FPGA platform directory keeps the PCIe and Ethernet IP source payload
needed for a generic Agilex/F-Tile style integration. Board-management IP,
board pin constraints, generated reports, local absolute paths, and old
board-specific project files are intentionally excluded.

## RTL Integration

The reusable top-level module is:

```systemverilog
rtl/type2_nic/type2_nic_top.sv
```

It exposes:

- a 32-bit CSR interface with byte enables
- BAR-backed descriptor and packet-slot storage for MMIO bring-up
- optional host DMA descriptor, read, and write hooks
- a 512-bit streaming packet TX/RX interface
- a 1024-bit slot-oriented debug/bring-up packet path
- IRQ status and a flattened CSR debug window

Set `DMA_BACKEND_PRESENT` to `1'b1` only after the surrounding shell connects a
real host-memory requester. With the default `1'b0`, the core reports that DMA
mode is unavailable and software should use the BAR/MMIO path.

## Intel FPGA Platform

The generic Intel FPGA payload lives under:

```text
platform/intel_fpga/
```

It includes:

- F-Tile 400G Ethernet MAC/PCS IP and example-design packet helpers
- R-Tile PCIe endpoint constituent IP and BAR/reconfig bridges
- clock/reset IP used by the platform shell
- a generic `type2_cc_nic_intel_files.tcl` filelist for Quartus projects
- a synthesizable Type-2 boundary module for wiring PCIe BAR, MAC stream, and
  optional DMA requester logic around `type2_nic_top`

The old board-management path is not part of this repo. A board adapter should
provide only the device part, pin assignments, refclk/reset mapping, and any
site-specific PCIe/MAC constraints.

## Driver

Build the out-of-tree module:

```bash
make -C driver
```

Load it by passing the endpoint BDF explicitly:

```bash
sudo insmod driver/type2_cc_nic.ko bdf=0000:00:00.0
ip link show type2cc0
sudo ip link set type2cc0 up
```

The driver is a bring-up/control datapath. It validates the Type-2 register
block, programs the MMIO slot queues, and can use DMA rings only when the
hardware capability bit reports that a requester backend is present.

## MMIO Bring-Up

Run the script against an endpoint BAR:

```bash
sudo scripts/type2_mmio_eth_test.py --bdf 0000:00:00.0
```

Useful integration options:

```bash
sudo scripts/type2_mmio_eth_test.py \
  --bdf 0000:00:00.0 \
  --bar-size 1048576 \
  --type2-base 0x880
```

The defaults match the generic register layout documented in
`docs/type2_cc_nic.md`; override them if your shell maps the Type-2 window at a
different BAR offset.

## Development Checks

Run the repository hygiene checks:

```bash
python3 -m pytest tests/test_generic_repo.py -q
```

These checks keep generated build products, board-specific artifacts, local
paths, and old platform names out of the generic repo.
