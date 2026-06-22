#!/usr/bin/env python3
"""
MMIO bring-up test for a generic Type-2 CC NIC window.

The current Type-2 path uses:
- direct MMIO for control/status at TYPE2_BASE + 0x000..0x07c
- indirect write for descriptor/slot memory via 0x000/0x004
- indirect read for descriptor/slot memory via 0x07c
"""

import argparse
import mmap
import os
import struct
import sys
import time
from dataclasses import dataclass
from pathlib import Path


DEFAULT_BAR_SIZE = 1 * 1024 * 1024
DEFAULT_TYPE2_BASE = 0x0880
TYPE2_MMIO_WR_ADDR = 0x000
TYPE2_MMIO_WR_DATA = 0x004
TYPE2_CTRL = 0x02C
TYPE2_CTRL_ENABLE = 0x1
TYPE2_CTRL_IRQ_ENABLE = 0x2

TX_RING_HEAD = 0x040
TX_RING_TAIL_DEV = 0x044
TX_RING_CAP = 0x048
TX_RING_INIT = 0x04C
TX_SLOT_COUNT = 0x050
TX_SLOT_STRIDE = 0x054
IRQ_ACK = 0x058
IRQ_TX_DESC_DONE = 0x00000001
IRQ_TX_FIFO_STALL = 0x00000002
IRQ_TX_BAD_DESC = 0x00000004
IRQ_RX_CPL_DONE = 0x00000010
IRQ_RX_RING_FULL = 0x00000020
IRQ_LINK_DOWN = 0x00000100
TX_PKT_CNT = 0x05C

RX_CPL_HEAD = 0x060
RX_CPL_TAIL = 0x064
RX_CPL_CAP = 0x068
RX_CPL_INIT = 0x06C
RX_SLOT_COUNT = 0x070
RX_SLOT_STRIDE = 0x074
RX_PKT_CNT = 0x078
MMIO_RD_ADDR = 0x07C

TX_DESC_BASE = 0x080
TX_SLOT_BASE = 0x100
DESC_STRIDE = 16
SLOT_DATA_WORDS = 32
SLOT_DATA_BYTES = 128
SLOT_FINAL_BYTES = 128
RING_INIT_MAGIC = 0xCAFECAFE


@dataclass
class Layout:
    desc_capacity: int
    slot_count: int
    slot_stride_words: int
    slot_stride_bytes: int
    rx_cpl_base: int
    rx_slot_base: int
    max_frame_bytes: int


def enable_pci_command(bdf: str) -> None:
    cfg = Path(f"/sys/bus/pci/devices/{bdf}/config")
    with cfg.open("r+b", buffering=0) as f:
        f.seek(0x04)
        cmd = struct.unpack("<H", f.read(2))[0]
        new_cmd = cmd | 0x0006
        if new_cmd != cmd:
            f.seek(0x04)
            f.write(struct.pack("<H", new_cmd))
            print(f"PCI COMMAND: 0x{cmd:04x} -> 0x{new_cmd:04x}")
        else:
            print(f"PCI COMMAND: 0x{cmd:04x}")


class Bar0:
    def __init__(self, bdf: str, size: int, type2_base: int):
        self.bdf = bdf
        self.size = size
        self.type2_base = type2_base
        self.fd = None
        self.mm = None

    def __enter__(self):
        enable_pci_command(self.bdf)
        path = f"/sys/bus/pci/devices/{self.bdf}/resource0"
        self.fd = os.open(path, os.O_RDWR | os.O_SYNC)
        self.mm = mmap.mmap(
            self.fd,
            self.size,
            mmap.MAP_SHARED,
            mmap.PROT_READ | mmap.PROT_WRITE,
        )
        return self

    def __exit__(self, exc_type, exc, tb):
        if self.mm is not None:
            self.mm.close()
        if self.fd is not None:
            os.close(self.fd)

    def rd32_abs(self, off: int) -> int:
        self.mm.seek(off)
        return struct.unpack("<I", self.mm.read(4))[0]

    def wr32_abs(self, off: int, val: int) -> None:
        self.mm.seek(off)
        self.mm.write(struct.pack("<I", val & 0xFFFFFFFF))

    def rd32(self, rel: int) -> int:
        return self.rd32_abs(self.type2_base + rel)

    def wr32(self, rel: int, val: int) -> None:
        self.wr32_abs(self.type2_base + rel, val)

    def indirect_rd32(self, rel: int) -> int:
        self.wr32(MMIO_RD_ADDR, rel)
        return self.rd32(MMIO_RD_ADDR)

    def indirect_wr_seq(self, rel: int, words: list[int]) -> None:
        for idx, word in enumerate(words):
            self.wr32(TYPE2_MMIO_WR_ADDR, rel + idx * 4)
            self.rd32(TYPE2_MMIO_WR_ADDR)
            self.wr32(TYPE2_MMIO_WR_DATA, word)


def read_layout(bar: Bar0) -> Layout:
    desc_capacity = bar.rd32(TX_RING_CAP)
    slot_count = bar.rd32(TX_SLOT_COUNT)
    slot_stride_words = bar.rd32(TX_SLOT_STRIDE)
    slot_stride_bytes = slot_stride_words * 4
    rx_cpl_base = TX_SLOT_BASE + slot_count * slot_stride_bytes
    rx_slot_base = rx_cpl_base + desc_capacity * DESC_STRIDE
    max_frame_bytes = (slot_count - 1) * SLOT_DATA_BYTES + SLOT_FINAL_BYTES
    return Layout(
        desc_capacity=desc_capacity,
        slot_count=slot_count,
        slot_stride_words=slot_stride_words,
        slot_stride_bytes=slot_stride_bytes,
        rx_cpl_base=rx_cpl_base,
        rx_slot_base=rx_slot_base,
        max_frame_bytes=max_frame_bytes,
    )


def make_default_payload() -> bytes:
    dst = bytes.fromhex("ff ff ff ff ff ff")
    src = bytes.fromhex("02 00 00 00 00 01")
    eth_type = bytes.fromhex("88 b5")
    body = bytes((i & 0xFF for i in range(46)))
    return dst + src + eth_type + body


def payload_from_arg(payload_hex: str | None) -> bytes:
    if not payload_hex:
        return make_default_payload()
    clean = payload_hex.replace(":", "").replace(" ", "")
    return bytes.fromhex(clean)


def frame_supported(layout: Layout, length: int) -> bool:
    if length < 1 or length > layout.max_frame_bytes:
        return False
    slots = (length + SLOT_DATA_BYTES - 1) // SLOT_DATA_BYTES
    last_chunk = length - ((slots - 1) * SLOT_DATA_BYTES)
    return 1 <= last_chunk <= SLOT_FINAL_BYTES


def write_tx_slot(bar: Bar0, layout: Layout, slot: int, payload: bytes, final: bool) -> None:
    padded = payload.ljust(SLOT_DATA_BYTES, b"\x00")
    words = [struct.unpack_from("<I", padded, word * 4)[0] for word in range(SLOT_DATA_WORDS)]

    if final:
        eop_segment = (len(payload) - 1) // 8
        inframe = (1 << eop_segment) - 1 if eop_segment else 0
        empty_bytes = ((eop_segment + 1) * 8) - len(payload)
        eop_empty = (empty_bytes & 0x7) << (eop_segment * 3)
    else:
        inframe = 0xFFFF
        eop_empty = 0

    words.extend([
        inframe,
        eop_empty & 0xFFFFFFFF,
        (eop_empty >> 32) & 0xFFFF,
    ])
    base = TX_SLOT_BASE + slot * layout.slot_stride_bytes
    bar.indirect_wr_seq(base, words)


def post_tx_packet(bar: Bar0, layout: Layout, payload: bytes, verbose: bool = True) -> None:
    if not frame_supported(layout, len(payload)):
        raise ValueError(
            f"frame length {len(payload)} is unsupported; "
            f"the current Type-2 beat format only supports 1..128 bytes modulo 128"
        )

    head = bar.rd32(TX_RING_HEAD)
    desc_idx = head & (layout.desc_capacity - 1)
    slots = (len(payload) + SLOT_DATA_BYTES - 1) // SLOT_DATA_BYTES
    desc = TX_DESC_BASE + desc_idx * DESC_STRIDE

    for slot in range(slots):
        off = slot * SLOT_DATA_BYTES
        chunk = payload[off:off + SLOT_DATA_BYTES]
        write_tx_slot(bar, layout, slot, chunk, slot == slots - 1)

    bar.indirect_wr_seq(desc, [0, slots, len(payload), 0])
    bar.wr32(TX_RING_INIT, RING_INIT_MAGIC)
    bar.wr32(TX_RING_HEAD, head + 1)
    if verbose:
        print(
            f"TX posted: desc={desc_idx} slots={slots} bytes={len(payload)} "
            f"head {head}->{head + 1}"
        )


def read_rx_completion(bar: Bar0, layout: Layout, tail: int):
    idx = tail & (layout.desc_capacity - 1)
    base = layout.rx_cpl_base + idx * DESC_STRIDE
    words = [bar.indirect_rd32(base + i * 4) for i in range(4)]
    slot = words[0] & 0xFF
    slot_count = (words[0] >> 8) & 0xFF
    byte_count = words[1] & 0xFFFF
    error_bits = (words[1] >> 16) & 0xFFFF
    return idx, words, slot, slot_count, byte_count, error_bits


def read_rx_payload(bar: Bar0, layout: Layout, slot: int, slot_count: int, byte_count: int) -> bytes:
    data = bytearray()
    for slot_off in range(slot_count):
        slot_idx = (slot + slot_off) & (layout.slot_count - 1)
        base = layout.rx_slot_base + slot_idx * layout.slot_stride_bytes
        words = [bar.indirect_rd32(base + i * 4) for i in range(SLOT_DATA_WORDS)]
        data.extend(b"".join(struct.pack("<I", w) for w in words))
        if len(data) >= byte_count:
            break
    return bytes(data[:byte_count])


def poll_rx(bar: Bar0, layout: Layout, timeout: float) -> bool:
    start = time.monotonic()
    tail = bar.rd32(RX_CPL_TAIL)
    print(f"RX poll: head={bar.rd32(RX_CPL_HEAD)} tail={tail}")
    while time.monotonic() - start < timeout:
        head = bar.rd32(RX_CPL_HEAD)
        if head != tail:
            idx, words, slot, slot_count, byte_count, error_bits = read_rx_completion(bar, layout, tail)
            payload = read_rx_payload(bar, layout, slot, slot_count, byte_count)
            print(f"RX completion[{idx}]: words={[f'0x{w:08x}' for w in words]}")
            print(
                f"RX packet: slot={slot} slot_count={slot_count} "
                f"bytes={byte_count} errors=0x{error_bits:04x}"
            )
            print(f"RX payload: {payload.hex(' ')}")
            bar.wr32(RX_CPL_TAIL, tail + 1)
            return True
        time.sleep(0.01)
    print(f"RX timeout after {timeout:.3f}s")
    return False


def dump_status(bar: Bar0, layout: Layout) -> None:
    print(
        f"Layout: desc_cap={layout.desc_capacity} slot_count={layout.slot_count} "
        f"slot_stride_words={layout.slot_stride_words} rx_cpl_base=0x{layout.rx_cpl_base:03x} "
        f"rx_slot_base=0x{layout.rx_slot_base:03x} max_frame={layout.max_frame_bytes}"
    )
    for rel, name in [
        (TYPE2_CTRL, "ctrl"),
        (TX_RING_HEAD, "tx_head_host"),
        (TX_RING_TAIL_DEV, "tx_tail_dev"),
        (TX_RING_CAP, "tx_capacity"),
        (TX_RING_INIT, "tx_init"),
        (TX_SLOT_COUNT, "tx_slot_count"),
        (TX_SLOT_STRIDE, "tx_slot_stride_words"),
        (IRQ_ACK, "irq_status/ack"),
        (TX_PKT_CNT, "tx_pkt_cnt"),
        (RX_CPL_HEAD, "rx_cpl_head_dev"),
        (RX_CPL_TAIL, "rx_cpl_tail_host"),
        (RX_CPL_CAP, "rx_cpl_capacity"),
        (RX_CPL_INIT, "rx_cpl_init"),
        (RX_SLOT_COUNT, "rx_slot_count"),
        (RX_SLOT_STRIDE, "rx_slot_stride_words"),
        (RX_PKT_CNT, "rx_pkt_cnt"),
    ]:
        print(f"TYPE2+0x{rel:03x} {name:<22} 0x{bar.rd32(rel):08x}")

    irq = bar.rd32(IRQ_ACK)
    flags = [
        ("tx_desc_done", IRQ_TX_DESC_DONE),
        ("tx_fifo_stall", IRQ_TX_FIFO_STALL),
        ("tx_bad_desc", IRQ_TX_BAD_DESC),
        ("rx_cpl_done", IRQ_RX_CPL_DONE),
        ("rx_ring_full", IRQ_RX_RING_FULL),
        ("link_down", IRQ_LINK_DOWN),
    ]
    active = [name for name, mask in flags if irq & mask]
    print(f"IRQ flags: {', '.join(active) if active else 'none'}")

    tx_tail = bar.rd32(TX_RING_TAIL_DEV)
    tx_head = bar.rd32(TX_RING_HEAD)
    desc_idx = tx_tail & (layout.desc_capacity - 1)
    prev_idx = (tx_tail - 1) & (layout.desc_capacity - 1)
    for idx_name, idx in [("tail", desc_idx), ("prev", prev_idx)]:
        base = TX_DESC_BASE + idx * DESC_STRIDE
        words = [bar.indirect_rd32(base + i * 4) for i in range(4)]
        print(f"TX desc {idx_name}[{idx}] @0x{base:03x}: {[f'0x{w:08x}' for w in words]}")
    if tx_head != tx_tail:
        base = TX_DESC_BASE + (tx_tail & (layout.desc_capacity - 1)) * DESC_STRIDE
        words = [bar.indirect_rd32(base + i * 4) for i in range(4)]
        print(f"TX pending desc @0x{base:03x}: {[f'0x{w:08x}' for w in words]}")

    slot0 = TX_SLOT_BASE
    ctrl_words = [bar.indirect_rd32(slot0 + i * 4) for i in range(32, 35)]
    first_words = [bar.indirect_rd32(slot0 + i * 4) for i in range(4)]
    print(f"TX slot0 data[0:4]: {[f'0x{w:08x}' for w in first_words]}")
    print(f"TX slot0 ctrl[32:35]: {[f'0x{w:08x}' for w in ctrl_words]}")


def run(args) -> int:
    payload = payload_from_arg(args.payload_hex)
    print(f"Using BDF {args.bdf}, BAR0 Type-2 base 0x{args.type2_base:x}")

    with Bar0(args.bdf, args.bar_size, args.type2_base) as bar:
        layout = read_layout(bar)
        if args.clear_irq:
            bar.wr32(IRQ_ACK, 0xFFFFFFFF)
        if args.mode == "dump":
            dump_status(bar, layout)
            return 0

        bar.wr32(RX_CPL_INIT, RING_INIT_MAGIC)
        bar.wr32(TYPE2_CTRL, TYPE2_CTRL_ENABLE | (TYPE2_CTRL_IRQ_ENABLE if args.irq else 0))
        dump_status(bar, layout)

        if args.mode in ("tx", "tx-rx"):
            before = bar.rd32(TX_PKT_CNT)
            completed = 0
            last_count = before
            for seq in range(args.count):
                verbose = (
                    args.count == 1
                    or seq == 0
                    or seq + 1 == args.count
                    or ((seq + 1) % args.progress_every == 0)
                )
                post_tx_packet(bar, layout, payload, verbose=verbose)
                deadline = time.monotonic() + args.timeout
                while time.monotonic() < deadline:
                    after = bar.rd32(TX_PKT_CNT)
                    if after != last_count:
                        prev_count = last_count
                        completed += (after - prev_count) & 0xFFFFFFFF
                        last_count = after
                        if verbose:
                            print(f"TX completed count: {prev_count}->{after}")
                        break
                    time.sleep(0.01)
                else:
                    print(f"TX completion count unchanged at {last_count} after packet {seq + 1}")
                    break
            print(f"TX stress: completed {completed}/{args.count} packets, counter {before}->{last_count}")

        if args.mode in ("rx", "tx-rx"):
            poll_rx(bar, layout, args.timeout)

        print("Final status:")
        dump_status(bar, layout)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bdf", default=os.environ.get("PCI_BDF"), help="PCI BDF; may also be set with PCI_BDF")
    parser.add_argument("--bar-size", type=lambda s: int(s, 0), default=DEFAULT_BAR_SIZE)
    parser.add_argument("--type2-base", type=lambda s: int(s, 0), default=DEFAULT_TYPE2_BASE)
    parser.add_argument("--mode", choices=("dump", "tx", "rx", "tx-rx"), default="tx-rx")
    parser.add_argument("--payload-hex", default=None, help="full Ethernet frame in hex")
    parser.add_argument("--count", type=int, default=1, help="number of Tx packets to post")
    parser.add_argument("--progress-every", type=int, default=64, help="print Tx progress every N packets")
    parser.add_argument("--timeout", type=float, default=2.0)
    parser.add_argument("--irq", action="store_true", help="enable Type-2 IRQ bit")
    parser.add_argument("--clear-irq", action="store_true", help="write-one-clear IRQ status first")
    args = parser.parse_args()

    if not args.bdf:
        parser.error("--bdf is required unless PCI_BDF is set")
    if args.mode == "dump":
        args.timeout = 0.0
    if args.count < 1:
        parser.error("--count must be >= 1")
    if args.progress_every < 1:
        parser.error("--progress-every must be >= 1")
    return run(args)


if __name__ == "__main__":
    sys.exit(main())
