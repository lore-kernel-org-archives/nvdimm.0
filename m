Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CB0522402E19
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 09:56:50 -0800 (PST)
Date: Thu, 1 Mar 2018 12:02:57 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 04/10] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180301180257.GH13722@bhelgaas-glaptop.roam.corp.google.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-5-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180228234006.21093-5-logang@deltatee.com>
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

On Wed, Feb 28, 2018 at 04:40:00PM -0700, Logan Gunthorpe wrote:
> For peer-to-peer transactions to work the downstream ports in each
> switch must not have the ACS flags set. At this time there is no way
> to dynamically change the flags and update the corresponding IOMMU
> groups so this is done at enumeration time before the the groups are
> assigned.

s/the the/the/

> This effectively means that if CONFIG_PCI_P2PDMA is selected then
> all devices behind any switch will be in the same IOMMU group.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/pci/Kconfig        |  4 ++++
>  drivers/pci/p2pdma.c       | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.c          |  4 ++++
>  include/linux/pci-p2pdma.h |  5 +++++
>  4 files changed, 57 insertions(+)
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 840831418cbd..a430672f0ad4 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -138,6 +138,10 @@ config PCI_P2PDMA
>  	  it's hard to tell which support it with good performance, so
>  	  at this time you will need a PCIe switch.
>  
> +	  Enabling this option will also disable ACS on all ports behind
> +	  any PCIe switch. This effictively puts all devices behind any
> +	  switch into the same IOMMU group.

s/effictively/effectively/

Does this really mean "all devices behind the same Root Port"?

What does this mean in terms of device security?  I assume it means,
at least, that individual devices can't be assigned to separate VMs.

I don't mind admitting that this patch makes me pretty nervous, and I
don't have a clear idea of what the implications of this are, or how
to communicate those to end users.  "The same IOMMU group" is a pretty
abstract idea.

>  	  If unsure, say N.
>  
>  config PCI_LABEL
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 4e1c81f64b29..61af07acd21a 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -255,6 +255,50 @@ static struct pci_dev *get_upstream_bridge_port(struct pci_dev *pdev)
>  	return up2;
>  }
>  
> +/*
> + * pci_p2pdma_disable_acs - disable ACS flags for ports in PCI
> + *	bridges/switches
> + * @pdev: device to disable ACS flags for
> + *
> + * The ACS flags for P2P Request Redirect and P2P Completion Redirect need
> + * to be disabled on any downstream port in any switch in order for
> + * the TLPs to not be forwarded up to the RC which is not what we want
> + * for P2P.
> + *
> + * This function is called when the devices are first enumerated and
> + * will result in all devices behind any switch to be in the same IOMMU
> + * group. At this time there is no way to "hotplug" IOMMU groups so we rely
> + * on this largish hammer. If you need the devices to be in separate groups
> + * don't enable CONFIG_PCI_P2PDMA.
> + *
> + * Returns 1 if the ACS bits for this device were cleared, otherwise 0.
> + */
> +int pci_p2pdma_disable_acs(struct pci_dev *pdev)
> +{
> +	struct pci_dev *up;
> +	int pos;
> +	u16 ctrl;
> +
> +	up = get_upstream_bridge_port(pdev);
> +	if (!up)
> +		return 0;
> +	pci_dev_put(up);
> +
> +	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> +	if (!pos)
> +		return 0;
> +
> +	dev_info(&pdev->dev, "disabling ACS flags for peer-to-peer DMA\n");
> +
> +	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> +
> +	ctrl &= ~(PCI_ACS_RR | PCI_ACS_CR);
> +
> +	pci_write_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
> +
> +	return 1;
> +}
> +
>  static bool __upstream_bridges_match(struct pci_dev *upstream,
>  				     struct pci_dev *client)
>  {
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index f6a4dd10d9b0..95ad3cf288c8 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -16,6 +16,7 @@
>  #include <linux/of.h>
>  #include <linux/of_pci.h>
>  #include <linux/pci.h>
> +#include <linux/pci-p2pdma.h>
>  #include <linux/pm.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> @@ -2826,6 +2827,9 @@ static void pci_std_enable_acs(struct pci_dev *dev)
>   */
>  void pci_enable_acs(struct pci_dev *dev)
>  {
> +	if (pci_p2pdma_disable_acs(dev))
> +		return;

This doesn't read naturally to me.  I do see that when
CONFIG_PCI_P2PDMA is not set, pci_p2pdma_disable_acs() does nothing
and returns 0, so we'll go ahead and try to enable ACS as before.

But I think it would be clearer to have an #ifdef CONFIG_PCI_P2PDMA
right here so it's more obvious that we only disable ACS when it's
selected.

>  	if (!pci_acs_enable)
>  		return;
>  
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index 126eca697ab3..f537f521f60c 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -22,6 +22,7 @@ struct block_device;
>  struct scatterlist;
>  
>  #ifdef CONFIG_PCI_P2PDMA
> +int pci_p2pdma_disable_acs(struct pci_dev *pdev);
>  int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  		u64 offset);
>  int pci_p2pdma_add_client(struct list_head *head, struct device *dev);
> @@ -41,6 +42,10 @@ int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  void pci_p2pdma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
>  			 enum dma_data_direction dir);
>  #else /* CONFIG_PCI_P2PDMA */
> +static inline int pci_p2pdma_disable_acs(struct pci_dev *pdev)
> +{
> +	return 0;
> +}
>  static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
>  		size_t size, u64 offset)
>  {
> -- 
> 2.11.0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
