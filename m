Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate16.nvidia.com (hqemgate16.nvidia.com [216.228.121.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDFA02129604C
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 17:54:08 -0700 (PDT)
Subject: Re: [Nouveau] [PATCH 03/22] mm: remove hmm_devmem_add_resource
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-4-hch@lst.de>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <b0136e6b-2262-ae4e-67ba-3d0b3895873b@nvidia.com>
Date: Thu, 13 Jun 2019 17:54:05 -0700
MIME-Version: 1.0
In-Reply-To: <20190613094326.24093-4-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/13/19 2:43 AM, Christoph Hellwig wrote:
> This function has never been used since it was first added to the kernel
> more than a year and a half ago, and if we ever grow a consumer of the
> MEMORY_DEVICE_PUBLIC infrastructure it can easily use devm_memremap_pages
> directly now that we've simplified the API for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/hmm.h |  3 ---
>  mm/hmm.c            | 54 ---------------------------------------------
>  2 files changed, 57 deletions(-)
> 

No objections here, good cleanup.

Reviewed-by: John Hubbard <jhubbard@nvidia.com> 

thanks,
-- 
John Hubbard
NVIDIA

> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index 4867b9da1b6c..5761a39221a6 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -688,9 +688,6 @@ struct hmm_devmem {
>  struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
>  				  struct device *device,
>  				  unsigned long size);
> -struct hmm_devmem *hmm_devmem_add_resource(const struct hmm_devmem_ops *ops,
> -					   struct device *device,
> -					   struct resource *res);
>  
>  /*
>   * hmm_devmem_page_set_drvdata - set per-page driver data field
> diff --git a/mm/hmm.c b/mm/hmm.c
> index ff2598eb7377..0c62426d1257 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -1445,58 +1445,4 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
>  	return devmem;
>  }
>  EXPORT_SYMBOL_GPL(hmm_devmem_add);
> -
> -struct hmm_devmem *hmm_devmem_add_resource(const struct hmm_devmem_ops *ops,
> -					   struct device *device,
> -					   struct resource *res)
> -{
> -	struct hmm_devmem *devmem;
> -	void *result;
> -	int ret;
> -
> -	if (res->desc != IORES_DESC_DEVICE_PUBLIC_MEMORY)
> -		return ERR_PTR(-EINVAL);
> -
> -	dev_pagemap_get_ops();
> -
> -	devmem = devm_kzalloc(device, sizeof(*devmem), GFP_KERNEL);
> -	if (!devmem)
> -		return ERR_PTR(-ENOMEM);
> -
> -	init_completion(&devmem->completion);
> -	devmem->pfn_first = -1UL;
> -	devmem->pfn_last = -1UL;
> -	devmem->resource = res;
> -	devmem->device = device;
> -	devmem->ops = ops;
> -
> -	ret = percpu_ref_init(&devmem->ref, &hmm_devmem_ref_release,
> -			      0, GFP_KERNEL);
> -	if (ret)
> -		return ERR_PTR(ret);
> -
> -	ret = devm_add_action_or_reset(device, hmm_devmem_ref_exit,
> -			&devmem->ref);
> -	if (ret)
> -		return ERR_PTR(ret);
> -
> -	devmem->pfn_first = devmem->resource->start >> PAGE_SHIFT;
> -	devmem->pfn_last = devmem->pfn_first +
> -			   (resource_size(devmem->resource) >> PAGE_SHIFT);
> -	devmem->page_fault = hmm_devmem_fault;
> -
> -	devmem->pagemap.type = MEMORY_DEVICE_PUBLIC;
> -	devmem->pagemap.res = *devmem->resource;
> -	devmem->pagemap.page_free = hmm_devmem_free;
> -	devmem->pagemap.altmap_valid = false;
> -	devmem->pagemap.ref = &devmem->ref;
> -	devmem->pagemap.data = devmem;
> -	devmem->pagemap.kill = hmm_devmem_ref_kill;
> -
> -	result = devm_memremap_pages(devmem->device, &devmem->pagemap);
> -	if (IS_ERR(result))
> -		return result;
> -	return devmem;
> -}
> -EXPORT_SYMBOL_GPL(hmm_devmem_add_resource);
>  #endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
