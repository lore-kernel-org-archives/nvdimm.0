Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E29AC22423856
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 02:26:41 -0800 (PST)
Received: by mail-wr0-f193.google.com with SMTP id z12so5539682wrg.4
 for <linux-nvdimm@lists.01.org>; Thu, 01 Mar 2018 02:32:50 -0800 (PST)
Subject: Re: [PATCH v2 06/10] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-7-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <72e90cc2-c05a-3ed8-42c7-e4d7a0d535d8@grimberg.me>
Date: Thu, 1 Mar 2018 12:32:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180228234006.21093-7-logang@deltatee.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 03/01/2018 01:40 AM, Logan Gunthorpe wrote:
> In order to use PCI P2P memory pci_p2pmem_[un]map_sg() functions must be
> called to map the correct DMA address. To do this, we add a flags
> variable and the RDMA_RW_CTX_FLAG_PCI_P2P flag. When the flag is
> specified use the appropriate map function.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>   drivers/infiniband/core/rw.c            | 21 +++++++++++++++++----
>   drivers/infiniband/ulp/isert/ib_isert.c |  5 +++--
>   drivers/infiniband/ulp/srpt/ib_srpt.c   |  7 ++++---
>   drivers/nvme/target/rdma.c              |  6 +++---
>   include/rdma/rw.h                       |  7 +++++--
>   net/sunrpc/xprtrdma/svc_rdma_rw.c       |  6 +++---
>   6 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index c8963e91f92a..775a9f8b15a6 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -12,6 +12,7 @@
>    */
>   #include <linux/moduleparam.h>
>   #include <linux/slab.h>
> +#include <linux/pci-p2pdma.h>
>   #include <rdma/mr_pool.h>
>   #include <rdma/rw.h>
>   
> @@ -269,18 +270,24 @@ static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
>    * @remote_addr:remote address to read/write (relative to @rkey)
>    * @rkey:	remote key to operate on
>    * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
> + * @flags:      any of the RDMA_RW_CTX_FLAG_* flags
>    *
>    * Returns the number of WQEs that will be needed on the workqueue if
>    * successful, or a negative error code.
>    */
>   int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
>   		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
> -		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
> +		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
> +		unsigned int flags)
>   {
>   	struct ib_device *dev = qp->pd->device;
>   	int ret;
>   
> -	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
> +	if (flags & RDMA_RW_CTX_FLAG_PCI_P2PDMA)
> +		ret = pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
> +	else
> +		ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
> +

Why not use is_pci_p2pdma_page(sg) instead of a flag? It would be so
much cleaner...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
