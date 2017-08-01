Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x22a.google.com (mail-ua0-x22a.google.com
 [IPv6:2607:f8b0:400c:c08::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0FB921CF9513
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 19:12:02 -0700 (PDT)
Received: by mail-ua0-x22a.google.com with SMTP id q25so1365358uah.1
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 19:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150153986963.49768.7407643931348757530.stgit@djiang5-desk3.ch.intel.com>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153986963.49768.7407643931348757530.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jul 2017 19:14:10 -0700
Message-ID: <CAPcyv4h7ZbKATEMHs-SpOXoVk8qY3KU-21VR042BeB-ovV2hKg@mail.gmail.com>
Subject: Re: [PATCH 2/5] dmaengine: ioatdma: dma_prep_memcpy_to/from_sg support
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 3:24 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding ioatdma support to copy from a physically contiguos buffer to a
> provided scatterlist and vice versa. This is used to support
> reading/writing persistent memory in the pmem driver.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dma/ioat/dma.h    |    8 +++
>  drivers/dma/ioat/init.c   |    3 +
>  drivers/dma/ioat/prep.c   |  105 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dmaengine.h |   10 ++++
>  4 files changed, 126 insertions(+)
>
> diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
> index 56200ee..b9a8d82 100644
> --- a/drivers/dma/ioat/dma.h
> +++ b/drivers/dma/ioat/dma.h
> @@ -370,6 +370,14 @@ struct dma_async_tx_descriptor *
>  ioat_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
>                            dma_addr_t dma_src, size_t len, unsigned long flags);
>  struct dma_async_tx_descriptor *
> +ioat_dma_prep_memcpy_to_sg_lock(struct dma_chan *c,
> +               struct scatterlist *dst_sg, unsigned int dst_nents,
> +               dma_addr_t src, unsigned long flags);
> +struct dma_async_tx_descriptor *
> +ioat_dma_prep_memcpy_from_sg_lock(struct dma_chan *c, dma_addr_t dst,
> +               struct scatterlist *dst_sg, unsigned int dst_nents,
> +               unsigned long flags);
> +struct dma_async_tx_descriptor *
>  ioat_prep_interrupt_lock(struct dma_chan *c, unsigned long flags);
>  struct dma_async_tx_descriptor *
>  ioat_prep_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
> diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
> index e437112..1e03f3e 100644
> --- a/drivers/dma/ioat/init.c
> +++ b/drivers/dma/ioat/init.c
> @@ -1091,6 +1091,9 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
>
>         dma = &ioat_dma->dma_dev;
>         dma->device_prep_dma_memcpy = ioat_dma_prep_memcpy_lock;
> +       dma->device_prep_dma_memcpy_to_sg = ioat_dma_prep_memcpy_to_sg_lock;
> +       dma->device_prep_dma_memcpy_from_sg =
> +               ioat_dma_prep_memcpy_from_sg_lock;
>         dma->device_issue_pending = ioat_issue_pending;
>         dma->device_alloc_chan_resources = ioat_alloc_chan_resources;
>         dma->device_free_chan_resources = ioat_free_chan_resources;
> diff --git a/drivers/dma/ioat/prep.c b/drivers/dma/ioat/prep.c
> index 243421a..49e220c 100644
> --- a/drivers/dma/ioat/prep.c
> +++ b/drivers/dma/ioat/prep.c
> @@ -159,6 +159,111 @@ ioat_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
>         return &desc->txd;
>  }
>
> +struct dma_async_tx_descriptor *
> +ioat_dma_prep_memcpy_to_sg_lock(struct dma_chan *c,
> +               struct scatterlist *dst_sg, unsigned int dst_nents,
> +               dma_addr_t dma_src, unsigned long flags)
> +{
> +       struct ioatdma_chan *ioat_chan = to_ioat_chan(c);
> +       struct ioat_dma_descriptor *hw = NULL;
> +       struct ioat_ring_ent *desc = NULL;
> +       dma_addr_t src = dma_src;
> +       int num_descs, idx, i;
> +       struct scatterlist *s;
> +       size_t total_len = 0, len;
> +
> +
> +       if (test_bit(IOAT_CHAN_DOWN, &ioat_chan->state))
> +               return NULL;
> +
> +       /*
> +        * The upper layer will garantee that each entry does not exceed
> +        * xfercap.
> +        */
> +       num_descs = dst_nents;
> +
> +       if (likely(num_descs) &&
> +           ioat_check_space_lock(ioat_chan, num_descs) == 0)
> +               idx = ioat_chan->head;
> +       else
> +               return NULL;
> +
> +       for_each_sg(dst_sg, s, dst_nents, i) {
> +               desc = ioat_get_ring_ent(ioat_chan, idx + i);
> +               hw = desc->hw;
> +               len = sg_dma_len(s);
> +               hw->size = len;
> +               hw->ctl = 0;
> +               hw->src_addr = src;
> +               hw->dst_addr = sg_dma_address(s);
> +               src += len;
> +               total_len += len;
> +               dump_desc_dbg(ioat_chan, desc);
> +       }
> +
> +       desc->txd.flags = flags;
> +       desc->len = total_len;
> +       hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
> +       hw->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
> +       hw->ctl_f.compl_write = 1;
> +       dump_desc_dbg(ioat_chan, desc);
> +       /* we leave the channel locked to ensure in order submission */
> +
> +       return &desc->txd;
> +}
> +
> +struct dma_async_tx_descriptor *
> +ioat_dma_prep_memcpy_from_sg_lock(struct dma_chan *c, dma_addr_t dma_dst,
> +               struct scatterlist *src_sg, unsigned int src_nents,
> +               unsigned long flags)
> +{
> +       struct ioatdma_chan *ioat_chan = to_ioat_chan(c);
> +       struct ioat_dma_descriptor *hw = NULL;
> +       struct ioat_ring_ent *desc = NULL;
> +       dma_addr_t dst = dma_dst;
> +       int num_descs, idx, i;
> +       struct scatterlist *s;
> +       size_t total_len = 0, len;
> +
> +
> +       if (test_bit(IOAT_CHAN_DOWN, &ioat_chan->state))
> +               return NULL;
> +
> +       /*
> +        * The upper layer will garantee that each entry does not exceed
> +        * xfercap.
> +        */
> +       num_descs = src_nents;
> +
> +       if (likely(num_descs) &&
> +           ioat_check_space_lock(ioat_chan, num_descs) == 0)
> +               idx = ioat_chan->head;
> +       else
> +               return NULL;
> +
> +       for_each_sg(src_sg, s, src_nents, i) {
> +               desc = ioat_get_ring_ent(ioat_chan, idx + i);
> +               hw = desc->hw;
> +               len = sg_dma_len(s);
> +               hw->size = len;
> +               hw->ctl = 0;
> +               hw->src_addr = sg_dma_address(s);
> +               hw->dst_addr = dst;
> +               dst += len;
> +               total_len += len;
> +               dump_desc_dbg(ioat_chan, desc);
> +       }
> +
> +       desc->txd.flags = flags;
> +       desc->len = total_len;
> +       hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
> +       hw->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
> +       hw->ctl_f.compl_write = 1;
> +       dump_desc_dbg(ioat_chan, desc);
> +       /* we leave the channel locked to ensure in order submission */
> +
> +       return &desc->txd;
> +}
>
>  static struct dma_async_tx_descriptor *
>  __ioat_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 5336808..6202e7c 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -694,6 +694,8 @@ struct dma_filter {
>   * @device_prep_dma_memset: prepares a memset operation
>   * @device_prep_dma_memset_sg: prepares a memset operation over a scatter list
>   * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
> + * @device_prep_dma_memcpy_to_sg: prepares memcpy from buffer to scatterlist
> + * @device_prep_dma_memcpy_from_sg: prepares memcpy from scatterlist to buffer
>   * @device_prep_slave_sg: prepares a slave dma operation
>   * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
>   *     The function takes a buffer of size buf_len. The callback function will
> @@ -776,6 +778,14 @@ struct dma_device {
>                 struct scatterlist *dst_sg, unsigned int dst_nents,
>                 struct scatterlist *src_sg, unsigned int src_nents,
>                 unsigned long flags);
> +       struct dma_async_tx_descriptor *(*device_prep_dma_memcpy_to_sg)(
> +               struct dma_chan *chan,
> +               struct scatterlist *dst_sg, unsigned int dst_nents,
> +               dma_addr_t src, unsigned long flags);
> +       struct dma_async_tx_descriptor *(*device_prep_dma_memcpy_from_sg)(
> +               struct dma_chan *chan, dma_addr_t dst,
> +               struct scatterlist *dst_sg, unsigned int dst_nents,
> +               unsigned long flags);
>
>         struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
>                 struct dma_chan *chan, struct scatterlist *sgl,
>

Can we get away with just adding one new operation with a flag to
indicate whether it is the 'to' or' 'from' sg case?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
