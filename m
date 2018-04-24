Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A22B72277AF0A
 for <linux-nvdimm@lists.01.org>; Mon, 23 Apr 2018 20:34:06 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <76c1bd8e-6eb4-3238-5cee-7fdeaeccc574@infradead.org>
Date: Mon, 23 Apr 2018 20:33:47 -0700
MIME-Version: 1.0
In-Reply-To: <20180423233046.21476-5-logang@deltatee.com>
Content-Language: en-US
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
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 04/23/2018 04:30 PM, Logan Gunthorpe wrote:> > Signed-off-by: Logan Gunthorpe <logang@deltatee.com>> ---
>  drivers/pci/Kconfig        |  9 +++++++++>  drivers/pci/p2pdma.c       | 45 ++++++++++++++++++++++++++++++--------------->  drivers/pci/pci.c          |  6 ++++++>  include/linux/pci-p2pdma.h |  5 +++++>  4 files changed, 50 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index b2396c22b53e..b6db41d4b708 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -139,6 +139,15 @@ config PCI_P2PDMA
>  	  transations must be between devices behind the same root port.
>  	  (Typically behind a network of PCIe switches).
>  
> +	  Enabling this option will also disable ACS on all ports behind
> +	  any PCIe switch. This effectively puts all devices behind any
> +	  switch heirarchy into the same IOMMU group. Which implies that

	         hierarchy                     group, which

and sames fixes in the commit description...

> +	  individual devices behind any switch will not be able to be
> +	  assigned to separate VMs because there is no isolation between
> +	  them. Additionally, any malicious PCIe devices will be able to
> +	  DMA to memory exposed by other EPs in the same domain as TLPs
> +	  will not be checked by the IOMMU.
> +
>  	  If unsure, say N.
>  
>  config PCI_LABEL


-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
