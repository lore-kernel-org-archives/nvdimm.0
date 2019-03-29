Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0174F211EA9EC
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 10:24:07 -0700 (PDT)
Date: Fri, 29 Mar 2019 12:24:06 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 3/6] pci/p2pdma: Fix the gen_pool_add_virt() failure path
Message-ID: <20190329172406.GE24180@google.com>
References: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155387325926.2443841.6674640070856872301.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155387325926.2443841.6674640070856872301.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 29, 2019 at 08:27:39AM -0700, Dan Williams wrote:
> The pci_p2pdma_add_resource() implementation immediately frees the pgmap
> if gen_pool_add_virt() fails. However, that means that when @dev
> triggers a devres release devm_memremap_pages_release() will crash
> trying to access the freed @pgmap.
> 
> Use the new devm_memunmap_pages() to manually free the mapping in the
> error path.
> 
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Especially if you run "git log --oneline drivers/pci/p2pdma.c" and make
yours match :),

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/p2pdma.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index c52298d76e64..595a534bd749 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -208,13 +208,15 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  			pci_bus_address(pdev, bar) + offset,
>  			resource_size(&pgmap->res), dev_to_node(&pdev->dev));
>  	if (error)
> -		goto pgmap_free;
> +		goto pages_free;
>  
>  	pci_info(pdev, "added peer-to-peer DMA memory %pR\n",
>  		 &pgmap->res);
>  
>  	return 0;
>  
> +pages_free:
> +	devm_memunmap_pages(&pdev->dev, pgmap);
>  pgmap_free:
>  	devm_kfree(&pdev->dev, pgmap);
>  	return error;
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
