# CXL Type-2 CC NIC

This repository contains a generic Type-2 CC NIC bring-up core:

- `rtl/type2_nic/`: reusable SystemVerilog queue, MMIO, and optional host-DMA NIC logic
- `driver/`: out-of-tree Linux netdev driver for the Type-2 CC NIC register model
- `scripts/type2_mmio_eth_test.py`: host-side BAR/MMIO packet-path bring-up tool
- `docs/type2_cc_nic.md`: register map, queue layout, and integration notes

The repo intentionally does not include a complete FPGA shell, endpoint wrapper,
MAC/PCS wrapper, clock/reset tree, or host DMA requester. Integrators wire the
core into their own CXL or PCIe endpoint design and provide the packet and DMA
interfaces required by `type2_nic_top.sv`.

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
