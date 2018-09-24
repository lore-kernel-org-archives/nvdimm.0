Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF4F721A02937
 for <linux-nvdimm@lists.01.org>; Mon, 24 Sep 2018 15:39:16 -0700 (PDT)
Date: Mon, 24 Sep 2018 17:39:14 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 04/13] PCI/P2PDMA: Introduce configfs/sysfs enable
 attribute helpers
Message-ID: <20180924223914.GP224714@bhelgaas-glaptop.roam.corp.google.com>
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-5-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180913001156.4115-5-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 12, 2018 at 06:11:47PM -0600, Logan Gunthorpe wrote:
> Users of the P2PDMA infrastructure will typically need a way for
> the user to tell the kernel to use P2P resources. Typically
> this will be a simple on/off boolean operation but sometimes
> it may be desirable for the user to specify the exact device to
> use for the P2P operation.
> 
> Add new helpers for attributes which take a boolean or a PCI device.
> Any boolean, or the word 'auto' turn P2P on or off. Specifying a full
> PCI device name/BDF will select the specific device.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

I appreciate your update to drop "auto" and show 0/1/pci_name().
When you post that, include my:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/p2pdma.c       | 83 ++++++++++++++++++++++++++++++++++++++
>  include/linux/pci-p2pdma.h | 15 +++++++
>  2 files changed, 98 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 29bd40a87768..3da848f3fe72 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #define pr_fmt(fmt) "pci-p2pdma: " fmt
> +#include <linux/ctype.h>
>  #include <linux/pci-p2pdma.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> @@ -856,3 +857,85 @@ int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  	return nents;
>  }
>  EXPORT_SYMBOL_GPL(pci_p2pdma_map_sg);
> +
> +/**
> + * pci_p2pdma_enable_store - parse a configfs/sysfs attribute store
> + *		to enable p2pdma
> + * @page: contents of the value to be stored
> + * @p2p_dev: returns the PCI device that was selected to be used
> + *		(if 'auto', 'none or a boolean isn't the store value)
> + * @use_p2pdma: returns whether to enable p2pdma or not
> + *
> + * Parses an attribute value to decide whether to enable p2pdma.
> + * The value can select a PCI device (using it's full BDF device
> + * name), a boolean, or 'auto'. 'auto' and a true boolean value
> + * have the same meaning. A false value disables p2pdma and
> + * a PCI device enables it to use a specific device as the
> + * backing provider.
> + *
> + * pci_p2pdma_enable_show() should be used as the show operation for
> + * the attribute.
> + *
> + * Returns 0 on success
> + */
> +int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
> +			    bool *use_p2pdma)
> +{
> +	struct device *dev;
> +
> +	dev = bus_find_device_by_name(&pci_bus_type, NULL, page);
> +	if (dev) {
> +		*use_p2pdma = true;
> +		*p2p_dev = to_pci_dev(dev);
> +
> +		if (!pci_has_p2pmem(*p2p_dev)) {
> +			pr_err("PCI device has no peer-to-peer memory: %s\n",
> +			       page);
> +			pci_dev_put(*p2p_dev);
> +			return -ENODEV;
> +		}
> +
> +		return 0;
> +	} else if (sysfs_streq(page, "auto")) {
> +		*use_p2pdma = true;
> +		return 0;
> +	} else if ((page[0] == '0' || page[0] == '1') && !iscntrl(page[1])) {
> +		/*
> +		 * If the user enters a PCI device that  doesn't exist
> +		 * like "0000:01:00.1", we don't want strtobool to think
> +		 * it's a '0' when it's clearly not what the user wanted.
> +		 * So we require 0's and 1's to be exactly one character.
> +		 */
> +	} else if (!strtobool(page, use_p2pdma)) {
> +		return 0;
> +	}
> +
> +	pr_err("No such PCI device: %.*s\n", (int)strcspn(page, "\n"), page);
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(pci_p2pdma_enable_store);
> +
> +/**
> + * pci_p2pdma_enable_show - show a configfs/sysfs attribute indicating
> + *		whether p2pdma is enabled
> + * @page: contents of the stored value
> + * @p2p_dev: the selected p2p device (NULL if no device is selected)
> + * @use_p2pdma: whether p2pdme has been enabled
> + *
> + * Attributes that use pci_p2pdma_enable_store() should use this function
> + * to show the value of the attribute.
> + *
> + * Returns 0 on success
> + */
> +ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
> +			       bool use_p2pdma)
> +{
> +	if (!use_p2pdma)
> +		return sprintf(page, "none\n");
> +
> +	if (!p2p_dev)
> +		return sprintf(page, "auto\n");
> +
> +	return sprintf(page, "%s\n", pci_name(p2p_dev));
> +}
> +EXPORT_SYMBOL_GPL(pci_p2pdma_enable_show);
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index 2f03dbbf5af6..377de4d73767 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -38,6 +38,10 @@ void pci_p2pmem_free_sgl(struct pci_dev *pdev, struct scatterlist *sgl);
>  void pci_p2pmem_publish(struct pci_dev *pdev, bool publish);
>  int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  		      enum dma_data_direction dir);
> +int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
> +			    bool *use_p2pdma);
> +ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
> +			       bool use_p2pdma);
>  #else /* CONFIG_PCI_P2PDMA */
>  static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
>  		size_t size, u64 offset)
> @@ -105,5 +109,16 @@ static inline int pci_p2pdma_map_sg(struct device *dev,
>  {
>  	return 0;
>  }
> +static inline int pci_p2pdma_enable_store(const char *page,
> +		struct pci_dev **p2p_dev, bool *use_p2pdma)
> +{
> +	*use_p2pdma = false;
> +	return 0;
> +}
> +static inline ssize_t pci_p2pdma_enable_show(char *page,
> +		struct pci_dev *p2p_dev, bool use_p2pdma)
> +{
> +	return sprintf(page, "none\n");
> +}
>  #endif /* CONFIG_PCI_P2PDMA */
>  #endif /* _LINUX_PCI_P2P_H */
> -- 
> 2.19.0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
