#include <linux/unaligned.h>
#include <linux/dma-mapping.h>
#include <linux/etherdevice.h>
#include <linux/ethtool.h>
#include <linux/io.h>
#include <linux/log2.h>
#include <linux/module.h>
#include <linux/netdevice.h>
#include <linux/pci.h>
#include <linux/workqueue.h>

#define DRV_NAME "type2_cc_nic"

#define TYPE2CC_BAR                  0
#define TYPE2CC_POLL_MS              5
#define TYPE2CC_POLL_FAULT_MIN_MS    100
#define TYPE2CC_POLL_FAULT_MAX_MS    1000
#define TYPE2CC_RX_BUDGET            64
#define TYPE2CC_DMA_RING_SIZE        256
#define TYPE2CC_DMA_RX_BUF_SIZE      16384
#define TYPE2CC_DMA_CPL_STRIDE       64

#define TYPE2_BASE                  0x00880
#define TYPE2_MMIO_WR_ADDR          0x000
#define TYPE2_MMIO_WR_DATA          0x004
#define TYPE2_DMA_TX_DESC_LO        0x000
#define TYPE2_DMA_TX_DESC_HI        0x004
#define TYPE2_DMA_TX_DESC_COUNT     0x008
#define TYPE2_DMA_TX_TAIL_DB        0x00c
#define TYPE2_DMA_RX_FILL_LO        0x010
#define TYPE2_DMA_RX_FILL_HI        0x014
#define TYPE2_DMA_RX_FILL_COUNT     0x018
#define TYPE2_DMA_RX_FILL_TAIL_DB   0x01c
#define TYPE2_DMA_RX_CPL_LO         0x020
#define TYPE2_DMA_RX_CPL_HI         0x024
#define TYPE2_DMA_RX_CPL_COUNT      0x028
#define TYPE2_CTRL                  0x02c
#define TYPE2_MAC_LO                0x030
#define TYPE2_MAC_HI                0x034
#define TYPE2_MTU                   0x038
#define TYPE2_FEC                   0x03c
#define TYPE2_TX_RING_HEAD          0x040
#define TYPE2_TX_RING_TAIL          0x044
#define TYPE2_TX_RING_CAP           0x048
#define TYPE2_TX_RING_INIT          0x04c
#define TYPE2_TX_SLOT_COUNT         0x050
#define TYPE2_TX_SLOT_STRIDE        0x054
#define TYPE2_IRQ_STATUS            0x058
#define TYPE2_TX_PKT_CNT            0x05c
#define TYPE2_RX_CPL_HEAD           0x060
#define TYPE2_RX_CPL_TAIL           0x064
#define TYPE2_RX_CPL_CAP            0x068
#define TYPE2_RX_CPL_INIT           0x06c
#define TYPE2_RX_SLOT_COUNT         0x070
#define TYPE2_RX_SLOT_STRIDE        0x074
#define TYPE2_RX_PKT_CNT            0x078
#define TYPE2_MMIO_RD_ADDR          0x07c

#define TYPE2_TX_DESC_BASE          0x080
#define TYPE2_TX_SLOT_BASE          0x100
#define TYPE2_DESC_STRIDE           16
#define TYPE2_DESC_WORDS            4
#define TYPE2_SLOT_DATA_BYTES       128
#define TYPE2_SLOT_DATA_WORDS       32
#define TYPE2_SLOT_CTRL_WORDS       3
#define TYPE2_SLOT_FINAL_BYTES      128
#define TYPE2_RING_INIT_MAGIC       0xcafecafe

#define TYPE2_CTRL_ENABLE           BIT(0)
#define TYPE2_CTRL_IRQ_ENABLE       BIT(1)
#define TYPE2_CTRL_DMA_MODE         BIT(2)
#define TYPE2_CTRL_DMA_BACKEND_PRESENT BIT(31)

static char *bdf = "";
module_param(bdf, charp, 0444);
MODULE_PARM_DESC(bdf, "PCI BDF of the Type-2 CC NIC endpoint");

static bool dma_mode;
module_param(dma_mode, bool, 0444);
MODULE_PARM_DESC(dma_mode, "Use host DMA descriptor rings instead of BAR MMIO slots");

static struct pci_dev *type2cc_bound_pdev;

struct type2cc_rx_cpl {
	u8 slot_idx;
	u8 slot_count;
	u16 byte_count;
	u16 error_bits;
	u32 error_mask;
};

struct type2cc_dma_desc {
	__le64 addr;
	__le16 len;
	__le16 meta;
	__le32 rsvd;
} __packed;

struct type2cc_dma_cpl {
	__le16 pkt_len;
	__le16 status;
	__le16 meta;
	__le16 qid;
	__le64 opaque;
	u8 pad[48];
} __packed;

struct type2cc_dma_tx_map {
	struct sk_buff *skb;
	dma_addr_t dma;
	u16 len;
};

struct type2cc_priv {
	struct pci_dev *pdev;
	struct net_device *ndev;
	void __iomem *bar0;
	struct delayed_work poll_work;
	spinlock_t state_lock;
	struct rtnl_link_stats64 stats;
	u32 slot_count;
	u32 desc_capacity;
	u32 slot_stride_words;
	u32 slot_stride_bytes;
	u32 max_frame_bytes;
	u32 max_mtu;
	u32 rx_cpl_base;
	u32 rx_slot_base;
	u32 tx_head;
	u32 tx_tail;
	u32 rx_tail;
	u32 tx_pending_len;
	u32 poll_delay_ms;
	bool type2_present;
	bool tx_busy;
	bool bar_fault;
	bool bar_fault_reported;
	bool warned_len_drop;
	bool use_dma;
	u32 tx_debug_logs;
	struct type2cc_dma_desc *dma_tx_desc;
	dma_addr_t dma_tx_desc_dma;
	struct type2cc_dma_desc *dma_rx_fill_desc;
	dma_addr_t dma_rx_fill_desc_dma;
	struct type2cc_dma_cpl *dma_rx_cpl;
	dma_addr_t dma_rx_cpl_dma;
	void *dma_rx_buf[TYPE2CC_DMA_RING_SIZE];
	dma_addr_t dma_rx_buf_dma[TYPE2CC_DMA_RING_SIZE];
	struct type2cc_dma_tx_map dma_tx_map[TYPE2CC_DMA_RING_SIZE];
	u16 dma_tx_head;
	u16 dma_tx_tail;
	u16 dma_rx_cpl_head;
	u16 dma_rx_fill_tail;
};

static u32 type2cc_rd32(struct type2cc_priv *priv, u32 reg)
{
	return ioread32(priv->bar0 + reg);
}

static void type2cc_wr32(struct type2cc_priv *priv, u32 reg, u32 val)
{
	iowrite32(val, priv->bar0 + reg);
}

static u32 type2cc_type2_rd32(struct type2cc_priv *priv, u32 rel)
{
	return type2cc_rd32(priv, TYPE2_BASE + rel);
}

static void type2cc_type2_wr32(struct type2cc_priv *priv, u32 rel, u32 val)
{
	type2cc_wr32(priv, TYPE2_BASE + rel, val);
}

static void type2cc_type2_wr_seq_locked(struct type2cc_priv *priv, u32 rel,
					 const u32 *words, unsigned int count)
{
	unsigned int i;

	for (i = 0; i < count; i++) {
		type2cc_type2_wr32(priv, TYPE2_MMIO_WR_ADDR, rel + i * sizeof(u32));
		/* Flush posted writes so the indirect address is latched before data. */
		type2cc_type2_rd32(priv, TYPE2_MMIO_WR_ADDR);
		type2cc_type2_wr32(priv, TYPE2_MMIO_WR_DATA, words[i]);
	}
}

static u32 type2cc_type2_indirect_rd32_locked(struct type2cc_priv *priv, u32 rel)
{
	type2cc_type2_wr32(priv, TYPE2_MMIO_RD_ADDR, rel);
	/* The BAR read selector updates in the FPGA CSR domain; discard the first read. */
	type2cc_type2_rd32(priv, TYPE2_MMIO_RD_ADDR);
	return type2cc_type2_rd32(priv, TYPE2_MMIO_RD_ADDR);
}

static bool type2cc_bad_bar_read(u32 val)
{
	return val == U32_MAX || (val & 0xffff0000) == 0xbadf0000;
}

static void type2cc_note_bar_fault_locked(struct type2cc_priv *priv,
					 const char *where, u32 val)
{
	if (!priv->bar_fault) {
		priv->poll_delay_ms = TYPE2CC_POLL_FAULT_MIN_MS;
		priv->stats.rx_errors++;
	} else {
		priv->poll_delay_ms = min_t(u32, priv->poll_delay_ms * 2,
					    TYPE2CC_POLL_FAULT_MAX_MS);
	}

	priv->bar_fault = true;
	if (priv->tx_busy) {
		priv->tx_busy = false;
		priv->tx_pending_len = 0;
		priv->stats.tx_errors++;
	}

	netif_stop_queue(priv->ndev);
	netif_carrier_off(priv->ndev);

	if (!priv->bar_fault_reported) {
		netdev_warn(priv->ndev,
			    "bad BAR read at %s: 0x%08x; backing poll off to %u ms\n",
			    where, val, priv->poll_delay_ms);
		priv->bar_fault_reported = true;
	}
}

static void type2cc_clear_bar_fault_locked(struct type2cc_priv *priv)
{
	if (priv->bar_fault)
		netdev_info(priv->ndev, "BAR reads recovered; restoring %u ms poll\n",
			    TYPE2CC_POLL_MS);

	priv->bar_fault = false;
	priv->bar_fault_reported = false;
	priv->poll_delay_ms = TYPE2CC_POLL_MS;
}

static u32 type2cc_max_frame_bytes(u32 slot_count)
{
	if (slot_count < 1)
		return 0;

	return (slot_count - 1) * TYPE2_SLOT_DATA_BYTES + TYPE2_SLOT_FINAL_BYTES;
}

static bool type2cc_len_supported(struct type2cc_priv *priv, unsigned int len)
{
	unsigned int last_chunk;
	unsigned int slots;

	if (!len || len > priv->max_frame_bytes)
		return false;

	slots = DIV_ROUND_UP(len, TYPE2_SLOT_DATA_BYTES);
	last_chunk = len - ((slots - 1) * TYPE2_SLOT_DATA_BYTES);

	return last_chunk >= 1 && last_chunk <= TYPE2_SLOT_FINAL_BYTES;
}

static u16 type2cc_dma_next(u16 idx)
{
	return (idx + 1 == TYPE2CC_DMA_RING_SIZE) ? 0 : idx + 1;
}

static bool type2cc_dma_tx_full(struct type2cc_priv *priv)
{
	return type2cc_dma_next(priv->dma_tx_tail) == priv->dma_tx_head;
}

static void type2cc_dma_write_desc(struct type2cc_dma_desc *desc,
				  dma_addr_t addr, u16 len)
{
	desc->addr = cpu_to_le64(addr);
	desc->len = cpu_to_le16(len);
	desc->meta = 0;
	desc->rsvd = 0;
}

static void type2cc_dma_post_rx_one_locked(struct type2cc_priv *priv)
{
	u16 idx = priv->dma_rx_fill_tail;

	type2cc_dma_write_desc(&priv->dma_rx_fill_desc[idx],
			      priv->dma_rx_buf_dma[idx],
			      TYPE2CC_DMA_RX_BUF_SIZE);
	dma_wmb();
	priv->dma_rx_fill_tail = type2cc_dma_next(idx);
	type2cc_type2_wr32(priv, TYPE2_DMA_RX_FILL_TAIL_DB,
			  priv->dma_rx_fill_tail);
}

static void type2cc_dma_discard_tx_locked(struct type2cc_priv *priv)
{
	unsigned int i;

	for (i = 0; i < TYPE2CC_DMA_RING_SIZE; i++) {
		if (!priv->dma_tx_map[i].skb)
			continue;

		dma_unmap_single(&priv->pdev->dev, priv->dma_tx_map[i].dma,
				 priv->dma_tx_map[i].len, DMA_TO_DEVICE);
		dev_kfree_skb_any(priv->dma_tx_map[i].skb);
		priv->dma_tx_map[i].skb = NULL;
		priv->dma_tx_map[i].dma = 0;
		priv->dma_tx_map[i].len = 0;
	}

	priv->dma_tx_head = priv->dma_tx_tail;
	priv->tx_busy = false;
	priv->tx_pending_len = 0;
}

static bool type2cc_dma_reclaim_tx_locked(struct type2cc_priv *priv)
{
	u32 hw_head32 = type2cc_type2_rd32(priv, TYPE2_TX_RING_TAIL);
	u16 hw_head;

	if (type2cc_bad_bar_read(hw_head32)) {
		type2cc_note_bar_fault_locked(priv, "dma tx_head", hw_head32);
		return false;
	}

	hw_head = hw_head32 & 0xffff;
	if (hw_head >= TYPE2CC_DMA_RING_SIZE) {
		type2cc_note_bar_fault_locked(priv, "dma tx_head range", hw_head32);
		return false;
	}

	while (priv->dma_tx_head != hw_head) {
		u16 idx = priv->dma_tx_head;

		if (priv->dma_tx_map[idx].skb) {
			dma_unmap_single(&priv->pdev->dev, priv->dma_tx_map[idx].dma,
					 priv->dma_tx_map[idx].len, DMA_TO_DEVICE);
			priv->stats.tx_packets++;
			priv->stats.tx_bytes += priv->dma_tx_map[idx].len;
			dev_kfree_skb_any(priv->dma_tx_map[idx].skb);
			priv->dma_tx_map[idx].skb = NULL;
			priv->dma_tx_map[idx].dma = 0;
			priv->dma_tx_map[idx].len = 0;
		}

		priv->dma_tx_head = type2cc_dma_next(priv->dma_tx_head);
	}

	priv->tx_busy = type2cc_dma_tx_full(priv);
	if (!priv->tx_busy && netif_carrier_ok(priv->ndev))
		netif_wake_queue(priv->ndev);

	return true;
}

static bool type2cc_dma_reset_rings_locked(struct type2cc_priv *priv)
{
	u32 tx_head32;
	u32 rx_cpl_head32;
	u32 rx_fill_head32;
	unsigned int i;

	type2cc_type2_wr32(priv, TYPE2_CTRL, TYPE2_CTRL_DMA_MODE);
	tx_head32 = type2cc_type2_rd32(priv, TYPE2_TX_RING_TAIL);
	rx_cpl_head32 = type2cc_type2_rd32(priv, TYPE2_RX_CPL_HEAD);
	rx_fill_head32 = type2cc_type2_rd32(priv, TYPE2_RX_CPL_TAIL);
	if (type2cc_bad_bar_read(tx_head32) ||
	    type2cc_bad_bar_read(rx_cpl_head32) ||
	    type2cc_bad_bar_read(rx_fill_head32)) {
		type2cc_note_bar_fault_locked(priv, "dma reset rings", tx_head32);
		return false;
	}
	if ((tx_head32 & 0xffff) >= TYPE2CC_DMA_RING_SIZE ||
	    (rx_cpl_head32 & 0xffff) >= TYPE2CC_DMA_RING_SIZE ||
	    (rx_fill_head32 & 0xffff) >= TYPE2CC_DMA_RING_SIZE) {
		type2cc_note_bar_fault_locked(priv, "dma reset ring range", tx_head32);
		return false;
	}

	type2cc_dma_discard_tx_locked(priv);
	memset(priv->dma_tx_desc, 0,
	       sizeof(*priv->dma_tx_desc) * TYPE2CC_DMA_RING_SIZE);
	memset(priv->dma_rx_fill_desc, 0,
	       sizeof(*priv->dma_rx_fill_desc) * TYPE2CC_DMA_RING_SIZE);
	memset(priv->dma_rx_cpl, 0,
	       sizeof(*priv->dma_rx_cpl) * TYPE2CC_DMA_RING_SIZE);

	priv->dma_tx_head = tx_head32 & 0xffff;
	priv->dma_tx_tail = priv->dma_tx_head;
	priv->dma_rx_cpl_head = rx_cpl_head32 & 0xffff;
	priv->dma_rx_fill_tail = rx_fill_head32 & 0xffff;
	priv->tx_tail = priv->dma_tx_head;
	priv->tx_head = priv->dma_tx_tail;
	priv->rx_tail = priv->dma_rx_cpl_head;

	type2cc_type2_wr32(priv, TYPE2_DMA_TX_DESC_LO,
			  lower_32_bits(priv->dma_tx_desc_dma));
	type2cc_type2_wr32(priv, TYPE2_DMA_TX_DESC_HI,
			  upper_32_bits(priv->dma_tx_desc_dma));
	type2cc_type2_wr32(priv, TYPE2_DMA_TX_DESC_COUNT,
			  TYPE2CC_DMA_RING_SIZE);
	type2cc_type2_wr32(priv, TYPE2_DMA_TX_TAIL_DB, priv->dma_tx_tail);
	type2cc_type2_wr32(priv, TYPE2_DMA_RX_FILL_LO,
			  lower_32_bits(priv->dma_rx_fill_desc_dma));
	type2cc_type2_wr32(priv, TYPE2_DMA_RX_FILL_HI,
			  upper_32_bits(priv->dma_rx_fill_desc_dma));
	type2cc_type2_wr32(priv, TYPE2_DMA_RX_FILL_COUNT,
			  TYPE2CC_DMA_RING_SIZE);
	type2cc_type2_wr32(priv, TYPE2_DMA_RX_CPL_LO,
			  lower_32_bits(priv->dma_rx_cpl_dma));
	type2cc_type2_wr32(priv, TYPE2_DMA_RX_CPL_HI,
			  upper_32_bits(priv->dma_rx_cpl_dma));
	type2cc_type2_wr32(priv, TYPE2_DMA_RX_CPL_COUNT,
			  TYPE2CC_DMA_RING_SIZE);

	for (i = 0; i < TYPE2CC_DMA_RING_SIZE - 1; i++)
		type2cc_dma_post_rx_one_locked(priv);

	type2cc_type2_wr32(priv, TYPE2_IRQ_STATUS, U32_MAX);
	priv->tx_busy = false;
	priv->tx_pending_len = 0;

	return true;
}

static void type2cc_sync_type2_cfg(struct type2cc_priv *priv, bool enable)
{
	const unsigned char *addr = priv->ndev->dev_addr;
	u32 ctrl = 0;

	if (!priv->type2_present)
		return;

	type2cc_type2_wr32(priv, TYPE2_MAC_LO,
			  addr[0] | (addr[1] << 8) | (addr[2] << 16) |
			  (addr[3] << 24));
	type2cc_type2_wr32(priv, TYPE2_MAC_HI, addr[4] | (addr[5] << 8));
	type2cc_type2_wr32(priv, TYPE2_MTU, priv->ndev->mtu);
	type2cc_type2_wr32(priv, TYPE2_FEC, 1);

	if (enable)
		ctrl = TYPE2_CTRL_ENABLE | TYPE2_CTRL_IRQ_ENABLE;
	if (enable && priv->use_dma)
		ctrl |= TYPE2_CTRL_DMA_MODE;

	type2cc_type2_wr32(priv, TYPE2_CTRL, ctrl);
}

static bool type2cc_reclaim_tx_locked(struct type2cc_priv *priv)
{
	u32 hw_tail;

	if (priv->use_dma)
		return type2cc_dma_reclaim_tx_locked(priv);

	hw_tail = type2cc_type2_rd32(priv, TYPE2_TX_RING_TAIL);
	if (type2cc_bad_bar_read(hw_tail)) {
		type2cc_note_bar_fault_locked(priv, "tx_tail", hw_tail);
		return false;
	}

	if (hw_tail == priv->tx_tail &&
	    !(priv->tx_busy && hw_tail == priv->tx_head))
		return true;

	priv->tx_tail = hw_tail;
	if (priv->tx_busy && hw_tail == priv->tx_head) {
		priv->stats.tx_packets++;
		priv->stats.tx_bytes += priv->tx_pending_len;
		priv->tx_busy = false;
		priv->tx_pending_len = 0;
		if (netif_carrier_ok(priv->ndev))
			netif_wake_queue(priv->ndev);
	}

	return true;
}

static bool type2cc_reset_rings_locked(struct type2cc_priv *priv)
{
	if (priv->use_dma)
		return type2cc_dma_reset_rings_locked(priv);

	priv->tx_tail = type2cc_type2_rd32(priv, TYPE2_TX_RING_TAIL);
	if (type2cc_bad_bar_read(priv->tx_tail)) {
		type2cc_note_bar_fault_locked(priv, "reset tx_tail", priv->tx_tail);
		return false;
	}
	priv->tx_head = priv->tx_tail;
	priv->rx_tail = type2cc_type2_rd32(priv, TYPE2_RX_CPL_HEAD);
	if (type2cc_bad_bar_read(priv->rx_tail)) {
		type2cc_note_bar_fault_locked(priv, "reset rx_head", priv->rx_tail);
		return false;
	}
	priv->tx_busy = false;
	priv->tx_pending_len = 0;

	type2cc_type2_wr32(priv, TYPE2_TX_RING_INIT, TYPE2_RING_INIT_MAGIC);
	type2cc_type2_wr32(priv, TYPE2_TX_RING_HEAD, priv->tx_head);
	type2cc_type2_wr32(priv, TYPE2_RX_CPL_INIT, TYPE2_RING_INIT_MAGIC);
	type2cc_type2_wr32(priv, TYPE2_RX_CPL_TAIL, priv->rx_tail);
	type2cc_type2_wr32(priv, TYPE2_IRQ_STATUS, U32_MAX);

	return true;
}

static bool type2cc_update_link(struct type2cc_priv *priv)
{
	unsigned long flags;
	u32 ctrl = type2cc_type2_rd32(priv, TYPE2_CTRL);

	spin_lock_irqsave(&priv->state_lock, flags);
	if (type2cc_bad_bar_read(ctrl)) {
		type2cc_note_bar_fault_locked(priv, "type2_ctrl", ctrl);
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return false;
	}

	type2cc_clear_bar_fault_locked(priv);
	spin_unlock_irqrestore(&priv->state_lock, flags);

	netif_carrier_on(priv->ndev);
	if (!priv->tx_busy)
		netif_wake_queue(priv->ndev);

	return true;
}

static void type2cc_encode_slot(struct type2cc_priv *priv, u32 slot_idx,
				const u8 *data, unsigned int len, bool final)
{
	u32 words[TYPE2_SLOT_DATA_WORDS + TYPE2_SLOT_CTRL_WORDS];
	u8 padded[TYPE2_SLOT_DATA_BYTES] = { 0 };
	u16 inframe = 0xffff;
	u64 eop_empty = 0;
	unsigned int eop_segment;
	unsigned int empty_bytes;
	unsigned int word;
	u32 base;

	memcpy(padded, data, len);
	for (word = 0; word < TYPE2_SLOT_DATA_WORDS; word++)
		words[word] = get_unaligned_le32(&padded[word * 4]);

	if (final) {
		eop_segment = (len - 1) / 8;
		empty_bytes = ((eop_segment + 1) * 8) - len;
		inframe = eop_segment ? ((1u << eop_segment) - 1) : 0;
		eop_empty = (u64)(empty_bytes & 0x7) << (eop_segment * 3);
	}

	words[TYPE2_SLOT_DATA_WORDS + 0] = inframe;
	words[TYPE2_SLOT_DATA_WORDS + 1] = lower_32_bits(eop_empty);
	words[TYPE2_SLOT_DATA_WORDS + 2] = upper_32_bits(eop_empty) & 0xffff;

	base = TYPE2_TX_SLOT_BASE + slot_idx * priv->slot_stride_bytes;
	type2cc_type2_wr_seq_locked(priv, base, words, ARRAY_SIZE(words));
}

static bool type2cc_read_rx_cpl_locked(struct type2cc_priv *priv,
					struct type2cc_rx_cpl *cpl)
{
	u32 head = type2cc_type2_rd32(priv, TYPE2_RX_CPL_HEAD);
	u32 word0, word1, word2;

	if (type2cc_bad_bar_read(head)) {
		type2cc_note_bar_fault_locked(priv, "rx_head", head);
		return false;
	}

	if (head == priv->rx_tail)
		return false;

	word0 = type2cc_type2_indirect_rd32_locked(priv, priv->rx_cpl_base +
						 (priv->rx_tail & (priv->desc_capacity - 1)) *
						 TYPE2_DESC_STRIDE);
	word1 = type2cc_type2_indirect_rd32_locked(priv, priv->rx_cpl_base +
						 (priv->rx_tail & (priv->desc_capacity - 1)) *
						 TYPE2_DESC_STRIDE + 4);
	word2 = type2cc_type2_indirect_rd32_locked(priv, priv->rx_cpl_base +
						 (priv->rx_tail & (priv->desc_capacity - 1)) *
						 TYPE2_DESC_STRIDE + 8);
	cpl->error_mask = type2cc_type2_indirect_rd32_locked(priv, priv->rx_cpl_base +
							(priv->rx_tail & (priv->desc_capacity - 1)) *
							TYPE2_DESC_STRIDE + 12);
	if (type2cc_bad_bar_read(word0) || type2cc_bad_bar_read(word1) ||
	    type2cc_bad_bar_read(word2) || type2cc_bad_bar_read(cpl->error_mask)) {
		type2cc_note_bar_fault_locked(priv, "rx_cpl", word0);
		return false;
	}

	cpl->slot_idx = word0 & 0xff;
	cpl->slot_count = (word0 >> 8) & 0xff;
	cpl->byte_count = word1 & 0xffff;
	cpl->error_bits = (word1 >> 16) & 0xffff;

	return true;
}

static bool type2cc_read_rx_payload_locked(struct type2cc_priv *priv,
					  const struct type2cc_rx_cpl *cpl,
					  u8 *buf)
{
	unsigned int remaining = cpl->byte_count;
	unsigned int copied = 0;
	unsigned int slot_off;
	unsigned int word;

	for (slot_off = 0; slot_off < cpl->slot_count && remaining; slot_off++) {
		u32 slot_idx = (cpl->slot_idx + slot_off) & (priv->slot_count - 1);
		u32 base = priv->rx_slot_base + slot_idx * priv->slot_stride_bytes;

		for (word = 0; word < TYPE2_SLOT_DATA_WORDS && remaining; word++) {
			u32 val = type2cc_type2_indirect_rd32_locked(priv,
								      base + word * 4);
			unsigned int take = min_t(unsigned int, remaining, 4);

			memcpy(buf + copied, &val, take);
			copied += take;
			remaining -= take;
		}
	}

	return true;
}

static bool type2cc_dma_process_one_rx(struct type2cc_priv *priv)
{
	struct type2cc_dma_cpl *cpl;
	struct sk_buff *skb = NULL;
	unsigned long flags;
	u32 hw_tail32;
	u16 hw_tail;
	u16 idx;
	u16 len;
	u16 status;
	bool drop;

	spin_lock_irqsave(&priv->state_lock, flags);
	hw_tail32 = type2cc_type2_rd32(priv, TYPE2_RX_CPL_HEAD);
	if (type2cc_bad_bar_read(hw_tail32)) {
		type2cc_note_bar_fault_locked(priv, "dma rx_cpl_tail", hw_tail32);
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return false;
	}

	hw_tail = hw_tail32 & 0xffff;
	if (hw_tail >= TYPE2CC_DMA_RING_SIZE) {
		type2cc_note_bar_fault_locked(priv, "dma rx_cpl_tail range",
					     hw_tail32);
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return false;
	}

	if (hw_tail == priv->dma_rx_cpl_head) {
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return false;
	}

	dma_rmb();
	idx = priv->dma_rx_cpl_head;
	cpl = &priv->dma_rx_cpl[idx];
	len = le16_to_cpu(cpl->pkt_len);
	status = le16_to_cpu(cpl->status);
	drop = !len || len > TYPE2CC_DMA_RX_BUF_SIZE || (status & ~0x0001);
	if (!priv->dma_rx_buf[idx])
		drop = true;

	if (!drop) {
		skb = netdev_alloc_skb_ip_align(priv->ndev, len);
		if (!skb) {
			drop = true;
		} else {
			memcpy(skb_put(skb, len), priv->dma_rx_buf[idx], len);
		}
	}

	if (drop) {
		if (skb)
			dev_kfree_skb_any(skb);
		priv->stats.rx_dropped++;
		if (!len || len > TYPE2CC_DMA_RX_BUF_SIZE || (status & ~0x0001))
			priv->stats.rx_errors++;
	} else {
		priv->stats.rx_packets++;
		priv->stats.rx_bytes += len;
	}

	memset(cpl, 0, sizeof(*cpl));
	priv->dma_rx_cpl_head = type2cc_dma_next(priv->dma_rx_cpl_head);
	priv->rx_tail = priv->dma_rx_cpl_head;
	type2cc_type2_wr32(priv, TYPE2_RX_CPL_TAIL, priv->dma_rx_cpl_head);
	type2cc_dma_post_rx_one_locked(priv);
	spin_unlock_irqrestore(&priv->state_lock, flags);

	if (!drop) {
		skb->protocol = eth_type_trans(skb, priv->ndev);
		netif_rx(skb);
	}

	return true;
}

static bool type2cc_process_one_rx(struct type2cc_priv *priv)
{
	struct type2cc_rx_cpl cpl;
	struct sk_buff *skb;
	unsigned long flags;
	u8 *data;
	bool drop = false;

	spin_lock_irqsave(&priv->state_lock, flags);
	if (!type2cc_read_rx_cpl_locked(priv, &cpl)) {
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return false;
	}

	if (!cpl.slot_count || cpl.slot_count > priv->slot_count ||
	    !cpl.byte_count || cpl.byte_count > priv->max_frame_bytes)
		drop = true;
	if (cpl.error_bits || cpl.error_mask)
		drop = true;
	spin_unlock_irqrestore(&priv->state_lock, flags);

	if (drop) {
		spin_lock_irqsave(&priv->state_lock, flags);
		priv->stats.rx_dropped++;
		if (cpl.error_bits || cpl.error_mask)
			priv->stats.rx_errors++;
		priv->rx_tail++;
		type2cc_type2_wr32(priv, TYPE2_RX_CPL_TAIL, priv->rx_tail);
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return true;
	}

	skb = netdev_alloc_skb_ip_align(priv->ndev, cpl.byte_count);
	if (!skb) {
		spin_lock_irqsave(&priv->state_lock, flags);
		priv->stats.rx_dropped++;
		priv->rx_tail++;
		type2cc_type2_wr32(priv, TYPE2_RX_CPL_TAIL, priv->rx_tail);
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return true;
	}

	data = skb_put(skb, cpl.byte_count);

	spin_lock_irqsave(&priv->state_lock, flags);
	if (!type2cc_read_rx_payload_locked(priv, &cpl, data)) {
		priv->stats.rx_errors++;
		priv->stats.rx_dropped++;
		priv->rx_tail++;
		type2cc_type2_wr32(priv, TYPE2_RX_CPL_TAIL, priv->rx_tail);
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return true;
	}
	priv->stats.rx_packets++;
	priv->stats.rx_bytes += cpl.byte_count;
	priv->rx_tail++;
	type2cc_type2_wr32(priv, TYPE2_RX_CPL_TAIL, priv->rx_tail);
	spin_unlock_irqrestore(&priv->state_lock, flags);

	skb->protocol = eth_type_trans(skb, priv->ndev);
	netif_rx(skb);

	return true;
}

static void type2cc_poll_workfn(struct work_struct *work)
{
	struct type2cc_priv *priv =
		container_of(to_delayed_work(work), struct type2cc_priv, poll_work);
	unsigned long flags;
	u32 delay_ms;
	unsigned int i;

	if (!netif_running(priv->ndev))
		return;

	if (!type2cc_update_link(priv))
		goto reschedule;

	spin_lock_irqsave(&priv->state_lock, flags);
	if (!type2cc_reclaim_tx_locked(priv)) {
		spin_unlock_irqrestore(&priv->state_lock, flags);
		goto reschedule;
	}
	spin_unlock_irqrestore(&priv->state_lock, flags);

	for (i = 0; i < TYPE2CC_RX_BUDGET; i++) {
		if (priv->use_dma) {
			if (!type2cc_dma_process_one_rx(priv))
				break;
		} else if (!type2cc_process_one_rx(priv)) {
			break;
		}

		spin_lock_irqsave(&priv->state_lock, flags);
		if (priv->bar_fault) {
			spin_unlock_irqrestore(&priv->state_lock, flags);
			goto reschedule;
		}
		spin_unlock_irqrestore(&priv->state_lock, flags);
	}

	if (netif_carrier_ok(priv->ndev) && !priv->tx_busy)
		netif_wake_queue(priv->ndev);

reschedule:
	spin_lock_irqsave(&priv->state_lock, flags);
	delay_ms = priv->poll_delay_ms ?: TYPE2CC_POLL_MS;
	spin_unlock_irqrestore(&priv->state_lock, flags);
	schedule_delayed_work(&priv->poll_work,
			      msecs_to_jiffies(delay_ms));
}

static int type2cc_open(struct net_device *ndev)
{
	struct type2cc_priv *priv = netdev_priv(ndev);
	unsigned long flags;
	u32 first_delay_ms;
	bool bar_ok;
	bool rings_ok;

	spin_lock_irqsave(&priv->state_lock, flags);
	rings_ok = type2cc_reset_rings_locked(priv);
	bar_ok = rings_ok;
	first_delay_ms = bar_ok ? 0 : priv->poll_delay_ms;
	spin_unlock_irqrestore(&priv->state_lock, flags);

	if (bar_ok)
		type2cc_sync_type2_cfg(priv, true);
	if (bar_ok) {
		netif_carrier_on(ndev);
		netif_start_queue(ndev);
	} else {
		netif_stop_queue(ndev);
		netif_carrier_off(ndev);
	}
	schedule_delayed_work(&priv->poll_work,
			      msecs_to_jiffies(first_delay_ms));

	return 0;
}

static int type2cc_stop(struct net_device *ndev)
{
	struct type2cc_priv *priv = netdev_priv(ndev);
	unsigned long flags;

	cancel_delayed_work_sync(&priv->poll_work);
	type2cc_sync_type2_cfg(priv, false);
	if (priv->use_dma) {
		spin_lock_irqsave(&priv->state_lock, flags);
		type2cc_dma_discard_tx_locked(priv);
		spin_unlock_irqrestore(&priv->state_lock, flags);
	}
	netif_stop_queue(ndev);
	netif_carrier_off(ndev);

	return 0;
}

static netdev_tx_t type2cc_dma_start_xmit(struct sk_buff *skb,
					 struct net_device *ndev)
{
	struct type2cc_priv *priv = netdev_priv(ndev);
	unsigned long flags;
	dma_addr_t dma;
	unsigned int len = skb->len;
	u16 idx;
	u16 next_tail;

	if (len > U16_MAX) {
		spin_lock_irqsave(&priv->state_lock, flags);
		priv->stats.tx_dropped++;
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	spin_lock_irqsave(&priv->state_lock, flags);
	if (!netif_carrier_ok(ndev)) {
		priv->stats.tx_dropped++;
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	if (!type2cc_dma_reclaim_tx_locked(priv)) {
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	if (type2cc_dma_tx_full(priv)) {
		priv->tx_busy = true;
		netif_stop_queue(ndev);
		spin_unlock_irqrestore(&priv->state_lock, flags);
		return NETDEV_TX_BUSY;
	}

	dma = dma_map_single(&priv->pdev->dev, skb->data, len, DMA_TO_DEVICE);
	if (dma_mapping_error(&priv->pdev->dev, dma)) {
		priv->stats.tx_dropped++;
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	idx = priv->dma_tx_tail;
	next_tail = type2cc_dma_next(idx);
	type2cc_dma_write_desc(&priv->dma_tx_desc[idx], dma, len);
	priv->dma_tx_map[idx].skb = skb;
	priv->dma_tx_map[idx].dma = dma;
	priv->dma_tx_map[idx].len = len;
	dma_wmb();
	priv->dma_tx_tail = next_tail;
	priv->tx_head = priv->dma_tx_tail;
	type2cc_type2_wr32(priv, TYPE2_DMA_TX_TAIL_DB, priv->dma_tx_tail);

	if (priv->tx_debug_logs < 8) {
		netdev_info(ndev,
			    "dma tx submit len=%u desc_idx=%u sw_tail=%u sw_head=%u dma=%pad\n",
			    len, idx, priv->dma_tx_tail, priv->dma_tx_head, &dma);
		priv->tx_debug_logs++;
	}

	priv->tx_busy = type2cc_dma_tx_full(priv);
	if (priv->tx_busy)
		netif_stop_queue(ndev);
	spin_unlock_irqrestore(&priv->state_lock, flags);

	return NETDEV_TX_OK;
}

static netdev_tx_t type2cc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
{
	struct type2cc_priv *priv = netdev_priv(ndev);
	unsigned long flags;
	unsigned int len;
	unsigned int slots;
	unsigned int slot;
	unsigned int chunk_len;
	u32 desc[TYPE2_DESC_WORDS];
	u32 desc_idx;

	if (skb_put_padto(skb, ETH_ZLEN))
		return NETDEV_TX_OK;

	if (skb_is_nonlinear(skb) && skb_linearize(skb)) {
		spin_lock_irqsave(&priv->state_lock, flags);
		priv->stats.tx_dropped++;
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	len = skb->len;

	if (priv->use_dma)
		return type2cc_dma_start_xmit(skb, ndev);

	spin_lock_irqsave(&priv->state_lock, flags);
	if (!netif_carrier_ok(ndev)) {
		priv->stats.tx_dropped++;
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	if (!type2cc_reclaim_tx_locked(priv)) {
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}
	if (priv->tx_busy) {
		priv->stats.tx_dropped++;
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	if (!type2cc_len_supported(priv, len)) {
		if (!priv->warned_len_drop) {
			netdev_warn(ndev,
				    "dropping unsupported frame length %u; current Type-2 beat format only supports lengths ending in 1..128 bytes modulo 128\n",
				    len);
			priv->warned_len_drop = true;
		}
		priv->stats.tx_dropped++;
		spin_unlock_irqrestore(&priv->state_lock, flags);
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}

	slots = DIV_ROUND_UP(len, TYPE2_SLOT_DATA_BYTES);
	desc_idx = priv->tx_head & (priv->desc_capacity - 1);
	for (slot = 0; slot < slots; slot++) {
		unsigned int offset = slot * TYPE2_SLOT_DATA_BYTES;
		bool final = slot == slots - 1;

		chunk_len = min_t(unsigned int, len - offset, TYPE2_SLOT_DATA_BYTES);
		type2cc_encode_slot(priv, slot, skb->data + offset, chunk_len, final);
	}

	desc[0] = 0;
	desc[1] = slots;
	desc[2] = len;
	desc[3] = 0;
	type2cc_type2_wr_seq_locked(priv,
				   TYPE2_TX_DESC_BASE + desc_idx * TYPE2_DESC_STRIDE,
				   desc, ARRAY_SIZE(desc));
	wmb();
	priv->tx_head++;
	type2cc_type2_wr32(priv, TYPE2_TX_RING_INIT, TYPE2_RING_INIT_MAGIC);
	type2cc_type2_wr32(priv, TYPE2_TX_RING_HEAD, priv->tx_head);
	if (priv->tx_debug_logs < 8) {
		netdev_info(ndev,
			    "tx submit len=%u slots=%u desc_idx=%u sw_head=%u sw_tail=%u desc=[%u,%u,%u,%u]\n",
			    len, slots, desc_idx, priv->tx_head, priv->tx_tail,
			    desc[0], desc[1], desc[2], desc[3]);
		priv->tx_debug_logs++;
	}
	priv->tx_busy = true;
	priv->tx_pending_len = len;
	netif_stop_queue(ndev);
	spin_unlock_irqrestore(&priv->state_lock, flags);

	dev_kfree_skb_any(skb);
	return NETDEV_TX_OK;
}

static int type2cc_set_mac_address(struct net_device *ndev, void *addr)
{
	struct sockaddr *sa = addr;
	struct type2cc_priv *priv = netdev_priv(ndev);

	if (!is_valid_ether_addr(sa->sa_data))
		return -EADDRNOTAVAIL;

	eth_hw_addr_set(ndev, sa->sa_data);
	type2cc_sync_type2_cfg(priv, netif_running(ndev));

	return 0;
}

static int type2cc_change_mtu(struct net_device *ndev, int new_mtu)
{
	struct type2cc_priv *priv = netdev_priv(ndev);

	if (new_mtu < ETH_MIN_MTU || new_mtu > priv->max_mtu)
		return -EINVAL;

	ndev->mtu = new_mtu;
	type2cc_sync_type2_cfg(priv, netif_running(ndev));

	return 0;
}

static void type2cc_get_stats64(struct net_device *ndev,
			       struct rtnl_link_stats64 *stats)
{
	struct type2cc_priv *priv = netdev_priv(ndev);
	unsigned long flags;

	spin_lock_irqsave(&priv->state_lock, flags);
	*stats = priv->stats;
	spin_unlock_irqrestore(&priv->state_lock, flags);
}

static int type2cc_get_link_ksettings(struct net_device *ndev,
				     struct ethtool_link_ksettings *cmd)
{
	cmd->base.speed = SPEED_UNKNOWN;
	cmd->base.duplex = DUPLEX_FULL;
	cmd->base.autoneg = AUTONEG_DISABLE;
	cmd->base.port = PORT_OTHER;
	cmd->base.phy_address = 0;

	return 0;
}

static u32 type2cc_ethtool_get_link(struct net_device *ndev)
{
	return netif_carrier_ok(ndev);
}

static void type2cc_get_drvinfo(struct net_device *ndev,
			       struct ethtool_drvinfo *info)
{
	struct type2cc_priv *priv = netdev_priv(ndev);

	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
	strscpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
}

static const struct ethtool_ops type2cc_ethtool_ops = {
	.get_drvinfo = type2cc_get_drvinfo,
	.get_link = type2cc_ethtool_get_link,
	.get_link_ksettings = type2cc_get_link_ksettings,
};

static const struct net_device_ops type2cc_netdev_ops = {
	.ndo_open = type2cc_open,
	.ndo_stop = type2cc_stop,
	.ndo_start_xmit = type2cc_start_xmit,
	.ndo_set_mac_address = type2cc_set_mac_address,
	.ndo_change_mtu = type2cc_change_mtu,
	.ndo_get_stats64 = type2cc_get_stats64,
};

static void type2cc_dma_free(struct type2cc_priv *priv)
{
	unsigned int i;

	if (!priv->use_dma)
		return;

	for (i = 0; i < TYPE2CC_DMA_RING_SIZE; i++) {
		if (priv->dma_tx_map[i].skb) {
			dma_unmap_single(&priv->pdev->dev, priv->dma_tx_map[i].dma,
					 priv->dma_tx_map[i].len, DMA_TO_DEVICE);
			dev_kfree_skb_any(priv->dma_tx_map[i].skb);
			priv->dma_tx_map[i].skb = NULL;
		}
		if (priv->dma_rx_buf[i]) {
			dma_free_coherent(&priv->pdev->dev,
					  TYPE2CC_DMA_RX_BUF_SIZE,
					  priv->dma_rx_buf[i],
					  priv->dma_rx_buf_dma[i]);
			priv->dma_rx_buf[i] = NULL;
			priv->dma_rx_buf_dma[i] = 0;
		}
	}

	if (priv->dma_rx_cpl) {
		dma_free_coherent(&priv->pdev->dev,
				  sizeof(*priv->dma_rx_cpl) * TYPE2CC_DMA_RING_SIZE,
				  priv->dma_rx_cpl, priv->dma_rx_cpl_dma);
		priv->dma_rx_cpl = NULL;
	}
	if (priv->dma_rx_fill_desc) {
		dma_free_coherent(&priv->pdev->dev,
				  sizeof(*priv->dma_rx_fill_desc) *
				  TYPE2CC_DMA_RING_SIZE,
				  priv->dma_rx_fill_desc,
				  priv->dma_rx_fill_desc_dma);
		priv->dma_rx_fill_desc = NULL;
	}
	if (priv->dma_tx_desc) {
		dma_free_coherent(&priv->pdev->dev,
				  sizeof(*priv->dma_tx_desc) *
				  TYPE2CC_DMA_RING_SIZE,
				  priv->dma_tx_desc, priv->dma_tx_desc_dma);
		priv->dma_tx_desc = NULL;
	}
}

static int type2cc_dma_alloc(struct type2cc_priv *priv)
{
	unsigned int i;
	int err;

	if (!priv->use_dma)
		return 0;

	err = dma_set_mask_and_coherent(&priv->pdev->dev, DMA_BIT_MASK(64));
	if (err)
		return err;

	priv->dma_tx_desc = dma_alloc_coherent(&priv->pdev->dev,
					       sizeof(*priv->dma_tx_desc) *
					       TYPE2CC_DMA_RING_SIZE,
					       &priv->dma_tx_desc_dma,
					       GFP_KERNEL);
	if (!priv->dma_tx_desc)
		return -ENOMEM;

	priv->dma_rx_fill_desc = dma_alloc_coherent(&priv->pdev->dev,
						    sizeof(*priv->dma_rx_fill_desc) *
						    TYPE2CC_DMA_RING_SIZE,
						    &priv->dma_rx_fill_desc_dma,
						    GFP_KERNEL);
	if (!priv->dma_rx_fill_desc) {
		err = -ENOMEM;
		goto err_free;
	}

	priv->dma_rx_cpl = dma_alloc_coherent(&priv->pdev->dev,
					      sizeof(*priv->dma_rx_cpl) *
					      TYPE2CC_DMA_RING_SIZE,
					      &priv->dma_rx_cpl_dma,
					      GFP_KERNEL);
	if (!priv->dma_rx_cpl) {
		err = -ENOMEM;
		goto err_free;
	}

	for (i = 0; i < TYPE2CC_DMA_RING_SIZE; i++) {
		priv->dma_rx_buf[i] = dma_alloc_coherent(&priv->pdev->dev,
							 TYPE2CC_DMA_RX_BUF_SIZE,
							 &priv->dma_rx_buf_dma[i],
							 GFP_KERNEL);
		if (!priv->dma_rx_buf[i]) {
			err = -ENOMEM;
			goto err_free;
		}
	}

	return 0;

err_free:
	type2cc_dma_free(priv);
	return err;
}

static int type2cc_validate_bar0(struct type2cc_priv *priv)
{
	u32 desc_capacity = type2cc_type2_rd32(priv, TYPE2_TX_RING_CAP);
	u32 slot_count = type2cc_type2_rd32(priv, TYPE2_TX_SLOT_COUNT);
	u32 slot_stride_words = type2cc_type2_rd32(priv, TYPE2_TX_SLOT_STRIDE);
	u32 ctrl = type2cc_type2_rd32(priv, TYPE2_CTRL);

	if (type2cc_bad_bar_read(desc_capacity) ||
	    type2cc_bad_bar_read(slot_count) ||
	    type2cc_bad_bar_read(slot_stride_words) ||
	    type2cc_bad_bar_read(ctrl))
		return -ENODEV;

	if (desc_capacity < 2 || slot_count < 4 || slot_stride_words < 35)
		return -ENODEV;

	return 0;
}

static int type2cc_bind(struct pci_dev *pdev)
{
	struct net_device *ndev;
	struct type2cc_priv *priv;
	u32 mac_lo, mac_hi;
	u32 type2_ctrl_caps;
	u8 addr[ETH_ALEN];
	int err;

	err = pci_enable_device_mem(pdev);
	if (err)
		return err;

	pci_set_master(pdev);

	err = pci_request_region(pdev, TYPE2CC_BAR, DRV_NAME);
	if (err)
		goto err_disable;

	ndev = alloc_etherdev(sizeof(*priv));
	if (!ndev) {
		err = -ENOMEM;
		goto err_release_region;
	}

	SET_NETDEV_DEV(ndev, &pdev->dev);
	strscpy(ndev->name, "type2cc%d", sizeof(ndev->name));
	ndev->netdev_ops = &type2cc_netdev_ops;
	ndev->ethtool_ops = &type2cc_ethtool_ops;
	ndev->watchdog_timeo = 0;

	priv = netdev_priv(ndev);
	priv->pdev = pdev;
	priv->ndev = ndev;
	priv->use_dma = dma_mode;
	spin_lock_init(&priv->state_lock);
	INIT_DELAYED_WORK(&priv->poll_work, type2cc_poll_workfn);
	priv->poll_delay_ms = TYPE2CC_POLL_MS;

	priv->bar0 = ioremap_uc(pci_resource_start(pdev, TYPE2CC_BAR),
				pci_resource_len(pdev, TYPE2CC_BAR));
	if (!priv->bar0) {
		err = -ENOMEM;
		goto err_free_netdev;
	}

	err = type2cc_validate_bar0(priv);
	if (err)
		goto err_iounmap;

	type2cc_type2_wr32(priv, TYPE2_CTRL, 0);
	priv->desc_capacity = type2cc_type2_rd32(priv, TYPE2_TX_RING_CAP);
	priv->slot_count = type2cc_type2_rd32(priv, TYPE2_TX_SLOT_COUNT);
	priv->slot_stride_words = type2cc_type2_rd32(priv, TYPE2_TX_SLOT_STRIDE);
	if (type2cc_bad_bar_read(priv->desc_capacity) ||
	    type2cc_bad_bar_read(priv->slot_count) ||
	    type2cc_bad_bar_read(priv->slot_stride_words)) {
		err = -ENODEV;
		goto err_iounmap;
	}
	priv->slot_stride_bytes = priv->slot_stride_words * sizeof(u32);
	priv->type2_present = priv->desc_capacity >= 2 &&
			      is_power_of_2(priv->desc_capacity) &&
			      is_power_of_2(priv->slot_count) &&
			      priv->slot_count >= 4 &&
			      priv->slot_stride_words >= 35;
	if (!priv->type2_present) {
		err = -ENODEV;
		goto err_iounmap;
	}

	type2_ctrl_caps = type2cc_type2_rd32(priv, TYPE2_CTRL);
	if (type2cc_bad_bar_read(type2_ctrl_caps)) {
		err = -ENODEV;
		goto err_iounmap;
	}
	if (priv->use_dma &&
	    !(type2_ctrl_caps & TYPE2_CTRL_DMA_BACKEND_PRESENT)) {
		dev_warn(&pdev->dev,
			 "dma_mode requested but RTL has no host DMA backend; using MMIO mode\n");
		priv->use_dma = false;
	}

	priv->rx_cpl_base = TYPE2_TX_SLOT_BASE +
			    priv->slot_count * priv->slot_stride_bytes;
	priv->rx_slot_base = priv->rx_cpl_base +
			     priv->desc_capacity * TYPE2_DESC_STRIDE;
	priv->max_frame_bytes = type2cc_max_frame_bytes(priv->slot_count);
	if (priv->use_dma)
		priv->max_frame_bytes = min_t(u32, priv->max_frame_bytes,
					      TYPE2CC_DMA_RX_BUF_SIZE);
	priv->max_mtu = priv->max_frame_bytes - ETH_HLEN;

	err = type2cc_dma_alloc(priv);
	if (err)
		goto err_iounmap;

	ndev->min_mtu = ETH_MIN_MTU;
	ndev->max_mtu = priv->max_mtu;
	ndev->mtu = min_t(unsigned int, ETH_DATA_LEN, priv->max_mtu);

	mac_lo = type2cc_type2_rd32(priv, TYPE2_MAC_LO);
	mac_hi = type2cc_type2_rd32(priv, TYPE2_MAC_HI);
	addr[0] = mac_lo & 0xff;
	addr[1] = (mac_lo >> 8) & 0xff;
	addr[2] = (mac_lo >> 16) & 0xff;
	addr[3] = (mac_lo >> 24) & 0xff;
	addr[4] = mac_hi & 0xff;
	addr[5] = (mac_hi >> 8) & 0xff;
	if (is_valid_ether_addr(addr))
		eth_hw_addr_set(ndev, addr);
	else
		eth_hw_addr_random(ndev);

	pci_set_drvdata(pdev, ndev);

	err = register_netdev(ndev);
	if (err)
		goto err_dma_free;

	type2cc_update_link(priv);
	dev_info(&pdev->dev,
		 "registered %s with %u Type-2 slots (%u-byte beat, max frame %u bytes, max MTU %u, %s mode)\n",
		 ndev->name, priv->slot_count, TYPE2_SLOT_DATA_BYTES,
		 priv->max_frame_bytes, priv->max_mtu,
		 priv->use_dma ? "DMA" : "MMIO");

	return 0;

err_dma_free:
	type2cc_dma_free(priv);
err_iounmap:
	iounmap(priv->bar0);
err_free_netdev:
	free_netdev(ndev);
err_release_region:
	pci_release_region(pdev, TYPE2CC_BAR);
err_disable:
	pci_disable_device(pdev);
	return err;
}

static void type2cc_unbind(struct pci_dev *pdev)
{
	struct net_device *ndev = pci_get_drvdata(pdev);
	struct type2cc_priv *priv;

	if (!ndev)
		return;

	priv = netdev_priv(ndev);
	unregister_netdev(ndev);
	cancel_delayed_work_sync(&priv->poll_work);
	type2cc_dma_free(priv);
	iounmap(priv->bar0);
	free_netdev(ndev);
	pci_release_region(pdev, TYPE2CC_BAR);
	pci_disable_device(pdev);
	pci_set_drvdata(pdev, NULL);
}

static int __init type2cc_init(void)
{
	struct pci_dev *pdev;
	int domain, bus, slot, func;
	int ret;

	if (!bdf || !bdf[0]) {
		pr_err(DRV_NAME ": bdf parameter is required\n");
		return -EINVAL;
	}

	ret = sscanf(bdf, "%x:%x:%x.%x", &domain, &bus, &slot, &func);
	if (ret != 4)
		return -EINVAL;

	if (type2cc_bound_pdev)
		return -EBUSY;

	pdev = pci_get_domain_bus_and_slot(domain, bus, PCI_DEVFN(slot, func));
	if (!pdev)
		return -ENODEV;

	ret = type2cc_bind(pdev);
	if (ret)
		pci_dev_put(pdev);
	else
		type2cc_bound_pdev = pdev;

	return ret;
}

static void __exit type2cc_exit(void)
{
	if (!type2cc_bound_pdev)
		return;

	type2cc_unbind(type2cc_bound_pdev);
	pci_dev_put(type2cc_bound_pdev);
	type2cc_bound_pdev = NULL;
}

module_init(type2cc_init);
module_exit(type2cc_exit);

MODULE_AUTHOR("OpenAI");
MODULE_DESCRIPTION("Generic Type-2 CC NIC Ethernet netdev");
MODULE_LICENSE("GPL");
