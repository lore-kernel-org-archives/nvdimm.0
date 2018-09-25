Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D7A821157439
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 10:33:28 -0700 (PDT)
Received: by mail-pf1-f193.google.com with SMTP id d8-v6so4750894pfo.13
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 10:33:28 -0700 (PDT)
Message-ID: <1537896805.11137.25.camel@acm.org>
Subject: Re: [PATCH v7 03/13] PCI/P2PDMA: Add PCI p2pmem DMA mappings to
 adjust the bus offset
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 25 Sep 2018 10:33:25 -0700
In-Reply-To: <20180925162231.4354-4-logang@deltatee.com>
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-4-logang@deltatee.com>
Mime-Version: 1.0
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-09-25 at 10:22 -0600, Logan Gunthorpe wrote:
> +int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> +		      enum dma_data_direction dir)
> +{
> +	struct dev_pagemap *pgmap;
> +	struct scatterlist *s;
> +	phys_addr_t paddr;
> +	int i;
> +
> +	/*
> +	 * p2pdma mappings are not compatible with devices that use
> +	 * dma_virt_ops. If the upper layers do the right thing
> +	 * this should never happen because it will be prevented
> +	 * by the check in pci_p2pdma_add_client()
> +	 */
> +	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_DMA_VIRT_OPS) &&
> +			 dev->dma_ops == &dma_virt_ops))
> +		return 0;

Are you assuming that the compiler will optimize out the dev->dma_ops
== &dma_virt_ops test if CONFIG_DMA_VIRT_OPS=n such that no reference to the
dma_virt_ops symbol appears in the object file? Are you sure all compilers
and compiler versions that are used to build the Linux kernel will do that?

Thanks,

Bart.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
