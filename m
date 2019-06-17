Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26F4321959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 13:08:18 -0700 (PDT)
References: <20190617122733.22432-1-hch@lst.de>
 <20190617122733.22432-9-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d68c5e4c-b2de-95c3-0b75-1f2391b25a34@deltatee.com>
Date: Mon, 17 Jun 2019 14:08:14 -0600
MIME-Version: 1.0
In-Reply-To: <20190617122733.22432-9-hch@lst.de>
Content-Language: en-CA
Subject: Re: [PATCH 08/25] memremap: move dev_pagemap callbacks into a
 separate structure
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>



On 2019-06-17 6:27 a.m., Christoph Hellwig wrote:
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index a98126ad9c3a..e083567d26ef 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -100,7 +100,7 @@ static void pci_p2pdma_percpu_cleanup(struct percpu_ref *ref)
>  	struct p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(ref);
>  
>  	wait_for_completion(&p2p_pgmap->ref_done);
> -	percpu_ref_exit(&p2p_pgmap->ref);
> +	percpu_ref_exit(ref);
>  }
>  
>  static void pci_p2pdma_release(void *data)
> @@ -152,6 +152,11 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
>  	return error;
>  }
>  
> +static const struct dev_pagemap_ops pci_p2pdma_pagemap_ops = {
> +	.kill		= pci_p2pdma_percpu_kill,
> +	.cleanup	= pci_p2pdma_percpu_cleanup,
> +};
> +
>  /**
>   * pci_p2pdma_add_resource - add memory for use as p2p memory
>   * @pdev: the device to add the memory to
> @@ -207,8 +212,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
>  	pgmap->pci_p2pdma_bus_offset = pci_bus_address(pdev, bar) -
>  		pci_resource_start(pdev, bar);
> -	pgmap->kill = pci_p2pdma_percpu_kill;
> -	pgmap->cleanup = pci_p2pdma_percpu_cleanup;

I just noticed this is missing a line to set pgmap->ops to
pci_p2pdma_pagemap_ops. I must have gotten confused by the other users
in my original review. Though I'm not sure how this compiles as the new
struct is static and unused. However, it is rendered moot in Patch 16
when this is all removed.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
