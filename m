Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 4 Jan 2018 12:22:25 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180104192225.GS11348@ziepe.ca>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180104190137.7654-7-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 04, 2018 at 12:01:31PM -0700, Logan Gunthorpe wrote:
>  
> @@ -269,18 +270,24 @@ static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
>   * @remote_addr:remote address to read/write (relative to @rkey)
>   * @rkey:	remote key to operate on
>   * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
> + * @flags:      any of the RDMA_RW_CTX_FLAG_* flags
>   *
>   * Returns the number of WQEs that will be needed on the workqueue if
>   * successful, or a negative error code.
>   */
>  int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
>  		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
> -		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
> +		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
> +		unsigned int flags)
>  {
>  	struct ib_device *dev = qp->pd->device;
>  	int ret;
>  
> -	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
> +	if (flags & RDMA_RW_CTX_FLAG_PCI_P2P)
> +		ret = pci_p2pmem_map_sg(sg, sg_cnt);
> +	else
> +		ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);

This seems really clunky since we are going to want to do this same
logic all over the place.

I'd be much happier if dma_map_sg can tell the memory is P2P or not
from the scatterlist or dir arguments and not require the callers to
have this.

For instance adding DMA_TO_P2P_DEVICE and DMA_FROM_P2P_DEVICE, or
adding another bit to the page flags in scatterlist.

The signature of pci_p2pmem_map_sg also doesn't look very good, it
should mirror the usual dma_map_sg, otherwise it needs more revision
to extend this to do P2P through a root complex.

Jason
