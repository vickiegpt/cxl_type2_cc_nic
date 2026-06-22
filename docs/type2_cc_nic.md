# Type-2 CC NIC Register Model

This document describes the generic Type-2 CC NIC core in
`rtl/type2_nic/type2_nic_top.sv`. All offsets are relative to the Type-2 window
base selected by the surrounding endpoint shell.

## Integration Boundary

The core expects a platform shell to provide:

- `clk` and active-low `rst_n`
- a `link_up` status input from the packet-side link layer
- one 32-bit CSR write path with byte enables
- optional host-memory DMA read/write request channels
- a 512-bit streaming TX/RX packet interface

The core provides:

- BAR-backed descriptor and packet-slot queues for MMIO bring-up
- optional host-DMA descriptor queue logic
- packet stream outputs and inputs
- IRQ status bits
- a flattened debug CSR window

The repository also carries a generic Intel FPGA platform payload under
`platform/intel_fpga/`. That payload supplies PCIe/MAC IP sources and a Quartus
filelist boundary, while board-level device and pin constraints remain outside
the reusable core.

## Control Registers

| Offset | Name | Description |
| --- | --- | --- |
| `0x000` | MMIO write address or DMA TX descriptor base low | Mode-dependent low register |
| `0x004` | MMIO write data or DMA TX descriptor base high | Mode-dependent low register |
| `0x008` | DMA TX descriptor count | Active in DMA mode |
| `0x00c` | DMA TX tail doorbell | Active in DMA mode |
| `0x010` | DMA RX fill descriptor base low | Active in DMA mode |
| `0x014` | DMA RX fill descriptor base high | Active in DMA mode |
| `0x018` | DMA RX fill descriptor count | Active in DMA mode |
| `0x01c` | DMA RX fill tail doorbell | Active in DMA mode |
| `0x020` | DMA RX completion base low | Active in DMA mode |
| `0x024` | DMA RX completion base high | Active in DMA mode |
| `0x028` | DMA RX completion count | Active in DMA mode |
| `0x02c` | Control | Enable, IRQ enable, DMA mode request, DMA backend capability |
| `0x030` | MAC low | Low 32 bits of software-programmed MAC address |
| `0x034` | MAC high | High 16 bits of software-programmed MAC address |
| `0x038` | MTU | Software-programmed MTU |
| `0x03c` | Link policy | Integration-defined link policy field |

`0x02c` control bits:

| Bit | Name | Description |
| --- | --- | --- |
| `0` | enable | Enables the Type-2 packet path |
| `1` | irq_enable | Allows IRQ status reporting |
| `2` | dma_mode | Requests host-DMA descriptor mode |
| `31` | dma_backend_present | Read-only capability from `DMA_BACKEND_PRESENT` |

Software must treat MMIO slot mode and host-DMA mode as mutually exclusive.
When bit `31` reads as `0`, software should keep bit `2` clear and use MMIO
slot mode.

## MMIO Queue Registers

| Offset | Name | Description |
| --- | --- | --- |
| `0x040` | TX ring head host | Host-owned TX producer pointer |
| `0x044` | TX ring tail device | Device-owned TX consumer pointer |
| `0x048` | TX ring capacity | Read-only descriptor count |
| `0x04c` | TX ring initialized | Write `0xcafecafe` during setup |
| `0x050` | TX slot count | Read-only packet slot count |
| `0x054` | TX slot stride | Read-only slot stride in 32-bit words |
| `0x058` | IRQ status or acknowledge | Read current status, write ones to clear |
| `0x05c` | TX packet count | Completed TX packet counter |
| `0x060` | RX completion head device | Device-owned RX producer pointer |
| `0x064` | RX completion tail host | Host-owned RX consumer pointer |
| `0x068` | RX completion capacity | Read-only completion count |
| `0x06c` | RX completion initialized | Write `0xcafecafe` during setup |
| `0x070` | RX slot count | Read-only packet slot count |
| `0x074` | RX slot stride | Read-only slot stride in 32-bit words |
| `0x078` | RX packet count | Completed RX packet counter |
| `0x07c` | MMIO read selector/data | Write relative address, then read selected word |

## Slot Memory

| Region | Base | Shape |
| --- | --- | --- |
| TX descriptor ring | `0x080` | 8 entries, 16 bytes each |
| TX packet slots | `0x100` | 16 slots, 35 words each |
| RX completion ring | after TX slots | 8 entries, 16 bytes each |
| RX packet slots | after RX completions | 16 slots, 35 words each |

TX descriptor word layout:

- word 0 bits `[7:0]`: first TX slot index
- word 1 bits `[7:0]`: slot count
- words 2 and 3: software-owned metadata

Each packet slot stores 32 data words followed by three control words:

- data words `0..31`: 1024-bit payload
- word `32`: in-frame and low error bits
- word `33`: low end-of-packet empty mask
- word `34`: high end-of-packet empty mask and skip-CRC metadata

## Host-DMA Descriptor Mode

DMA descriptors are 16 bytes:

- bits `[63:0]`: host physical address
- bits `[79:64]`: byte length
- bits `[95:80]`: metadata
- bits `[127:96]`: reserved

RX completions use a 64-byte stride. The low 16 bytes contain:

- bits `[15:0]`: packet length
- bits `[31:16]`: status
- bits `[47:32]`: metadata
- bits `[63:48]`: queue id
- bits `[127:64]`: opaque value

The wider completion stride avoids read-modify-write hazards in simple DMA
write interfaces.

## Bring-Up Flow

MMIO TX:

1. Program packet slots through `0x000/0x004`.
2. Program one TX descriptor.
3. Set control bit `0`.
4. Write `0xcafecafe` to `0x04c`.
5. Advance `0x040`.

MMIO RX:

1. Set control bit `0`.
2. Write `0xcafecafe` to `0x06c`.
3. Poll `0x060` and `0x064`.
4. Read completions and packet slots through `0x07c`.
5. Advance `0x064` after consuming completions.

## Non-Goals

This core does not provide:

- a host DMA requester implementation
- interrupt transport integration
- production queue scaling, RSS, checksum offload, or zero-copy RX policy

The Intel FPGA platform payload is a reference integration boundary, not a
board-complete project. It does not include board-management logic, board pin
assignments, or a validated host DMA requester.
