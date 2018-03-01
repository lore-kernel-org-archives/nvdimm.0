Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24E09224E693F
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 09:43:36 -0800 (PST)
Date: Thu, 1 Mar 2018 11:49:41 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Add PCI p2pmem dma mappings to
 adjust the bus offset
Message-ID: <20180301174941.GG13722@bhelgaas-glaptop.roam.corp.google.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-4-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180228234006.21093-4-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 28, 2018 at 04:39:59PM -0700, Logan Gunthorpe wrote:
> The DMA address used when mapping PCI P2P memory must be the PCI bus
> address. Thus, introduce pci_p2pmem_[un]map_sg() to map the correct
> addresses when using P2P memory.
> 
> For this, we assume that an SGL passed to these functions contain all
> p2p memory or no p2p memory.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/pci/p2pdma.c       | 51 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/memremap.h   |  1 +
>  include/linux/pci-p2pdma.h | 13 ++++++++++++
>  3 files changed, 65 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index a57df78f6a32..4e1c81f64b29 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -188,6 +188,8 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	pgmap->res.flags = pci_resource_flags(pdev, bar);
>  	pgmap->ref = &pdev->p2pdma->devmap_ref;
>  	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
> +	pgmap->pci_p2pdma_bus_offset = pci_bus_address(pdev, bar) -
> +		pci_resource_start(pdev, bar);
>  
>  	addr = devm_memremap_pages(&pdev->dev, pgmap);
>  	if (IS_ERR(addr))
> @@ -616,3 +618,52 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
>  	pdev->p2pdma->published = publish;
>  }
>  EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
> +
> +/*
> + * pci_p2pdma_map_sg - map a PCI peer-to-peer sg for DMA
> + * @dev:        device doing the DMA request
> + * @sg:		scatter list to map
> + * @nents:	elements in the scatterlist
> + * @dir:        DMA direction

Can you fix these so the descriptions all have a single space after
the "@dev:", which seems to be the existing convention in this file?
The indentation looks pretty random now.

> + *
> + * Returns the number of SG entries mapped
> + */
> +int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> +		      enum dma_data_direction dir)

Same question as before about why the mixture of "pci_*" interfaces
that take "struct device *" parameters.

> +{
> +	struct dev_pagemap *pgmap;
> +	struct scatterlist *s;
> +	phys_addr_t paddr;
> +	int i;
> +
> +	/*
> +	 * p2pdma mappings are not compatible with devices that use
> +	 * dma_virt_ops.
> +	 */
> +	if (IS_ENABLED(CONFIG_DMA_VIRT_OPS) && dev->dma_ops == &dma_virt_ops)
> +		return 0;
> +
> +	for_each_sg(sg, s, nents, i) {
> +		pgmap = sg_page(s)->pgmap;
> +		paddr = sg_phys(s);
> +
> +		s->dma_address = paddr - pgmap->pci_p2pdma_bus_offset;
> +		sg_dma_len(s) = s->length;
> +	}
> +
> +	return nents;
> +}
> +EXPORT_SYMBOL_GPL(pci_p2pdma_map_sg);
> +
> +/**
> + * pci_p2pdma_unmap_sg - unmap a PCI peer-to-peer sg for DMA
> + * @dev:        device doing the DMA request
> + * @sg:		scatter list to map
> + * @nents:	elements in the scatterlist
> + * @dir:        DMA direction

Same whitespace comment as above.

> + */
> +void pci_p2pdma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
> +			 enum dma_data_direction dir)
> +{
> +}
> +EXPORT_SYMBOL_GPL(pci_p2pdma_unmap_sg);
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 9e907c338a44..1660f64ce96f 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -125,6 +125,7 @@ struct dev_pagemap {
>  	struct device *dev;
>  	void *data;
>  	enum memory_type type;
> +	u64 pci_p2pdma_bus_offset;
>  };
>  
>  #ifdef CONFIG_ZONE_DEVICE
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index c0dde3d3aac4..126eca697ab3 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -36,6 +36,10 @@ int pci_p2pmem_alloc_sgl(struct pci_dev *pdev, struct scatterlist **sgl,
>  void pci_p2pmem_free_sgl(struct pci_dev *pdev, struct scatterlist *sgl,
>  		unsigned int nents);
>  void pci_p2pmem_publish(struct pci_dev *pdev, bool publish);
> +int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> +		      enum dma_data_direction dir);
> +void pci_p2pdma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
> +			 enum dma_data_direction dir);
>  #else /* CONFIG_PCI_P2PDMA */
>  static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
>  		size_t size, u64 offset)
> @@ -83,5 +87,14 @@ static inline void pci_p2pmem_free_sgl(struct pci_dev *pdev,
>  static inline void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
>  {
>  }
> +static inline int pci_p2pdma_map_sg(struct device *dev,
> +	struct scatterlist *sg, int nents, enum dma_data_direction dir)
> +{
> +	return 0;
> +}
> +static inline void pci_p2pdma_unmap_sg(struct device *dev,
> +	struct scatterlist *sg, int nents, enum dma_data_direction dir)
> +{
> +}
>  #endif /* CONFIG_PCI_P2PDMA */
>  #endif /* _LINUX_PCI_P2P_H */
> -- 
> 2.11.0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
