Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate16.nvidia.com (hqemgate16.nvidia.com [216.228.121.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBFCC2129EBA4
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jun 2019 19:21:56 -0700 (PDT)
Subject: Re: [PATCH 06/22] mm: factor out a devm_request_free_mem_region helper
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-7-hch@lst.de>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <56c130b1-5ed9-7e75-41d9-c61e73874cb8@nvidia.com>
Date: Fri, 14 Jun 2019 19:21:54 -0700
MIME-Version: 1.0
In-Reply-To: <20190613094326.24093-7-hch@lst.de>
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
> Keep the physical address allocation that hmm_add_device does with the
> rest of the resource code, and allow future reuse of it without the hmm
> wrapper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/ioport.h |  2 ++
>  kernel/resource.c      | 39 +++++++++++++++++++++++++++++++++++++++
>  mm/hmm.c               | 33 ++++-----------------------------
>  3 files changed, 45 insertions(+), 29 deletions(-)

Some trivial typos noted below, but this accurately moves the code
into a helper routine, looks good.

Reviewed-by: John Hubbard <jhubbard@nvidia.com> 


> 
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index da0ebaec25f0..76a33ae3bf6c 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -286,6 +286,8 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
>         return (r1->start <= r2->end && r1->end >= r2->start);
>  }
>  
> +struct resource *devm_request_free_mem_region(struct device *dev,
> +		struct resource *base, unsigned long size);
>  
>  #endif /* __ASSEMBLY__ */
>  #endif	/* _LINUX_IOPORT_H */
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 158f04ec1d4f..99c58134ed1c 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1628,6 +1628,45 @@ void resource_list_free(struct list_head *head)
>  }
>  EXPORT_SYMBOL(resource_list_free);
>  
> +#ifdef CONFIG_DEVICE_PRIVATE
> +/**
> + * devm_request_free_mem_region - find free region for device private memory
> + *
> + * @dev: device struct to bind the resource too

                                               "to"

> + * @size: size in bytes of the device memory to add
> + * @base: resource tree to look in
> + *
> + * This function tries to find an empty range of physical address big enough to
> + * contain the new resource, so that it can later be hotpluged as ZONE_DEVICE

                                                        "hotplugged"

> + * memory, which in turn allocates struct pages.
> + */
> +struct resource *devm_request_free_mem_region(struct device *dev,
> +		struct resource *base, unsigned long size)
> +{
> +	resource_size_t end, addr;
> +	struct resource *res;
> +
> +	size = ALIGN(size, 1UL << PA_SECTION_SHIFT);
> +	end = min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);
> +	addr = end - size + 1UL;
> +
> +	for (; addr > size && addr >= base->start; addr -= size) {
> +		if (region_intersects(addr, size, 0, IORES_DESC_NONE) !=
> +				REGION_DISJOINT)
> +			continue;
> +
> +		res = devm_request_mem_region(dev, addr, size, dev_name(dev));
> +		if (!res)
> +			return ERR_PTR(-ENOMEM);
> +		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
> +		return res;
> +	}
> +
> +	return ERR_PTR(-ERANGE);
> +}
> +EXPORT_SYMBOL_GPL(devm_request_free_mem_region);
> +#endif /* CONFIG_DEVICE_PRIVATE */
> +
>  static int __init strict_iomem(char *str)
>  {
>  	if (strstr(str, "relaxed"))
> diff --git a/mm/hmm.c b/mm/hmm.c
> index e1dc98407e7b..13a16faf0a77 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -26,8 +26,6 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/memory_hotplug.h>
>  
> -#define PA_SECTION_SIZE (1UL << PA_SECTION_SHIFT)
> -
>  #if IS_ENABLED(CONFIG_HMM_MIRROR)
>  static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
>  
> @@ -1372,7 +1370,6 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
>  				  unsigned long size)
>  {
>  	struct hmm_devmem *devmem;
> -	resource_size_t addr;
>  	void *result;
>  	int ret;
>  
> @@ -1398,32 +1395,10 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> -	size = ALIGN(size, PA_SECTION_SIZE);
> -	addr = min((unsigned long)iomem_resource.end,
> -		   (1UL << MAX_PHYSMEM_BITS) - 1);
> -	addr = addr - size + 1UL;
> -
> -	/*
> -	 * FIXME add a new helper to quickly walk resource tree and find free
> -	 * range
> -	 *
> -	 * FIXME what about ioport_resource resource ?
> -	 */
> -	for (; addr > size && addr >= iomem_resource.start; addr -= size) {
> -		ret = region_intersects(addr, size, 0, IORES_DESC_NONE);
> -		if (ret != REGION_DISJOINT)
> -			continue;
> -
> -		devmem->resource = devm_request_mem_region(device, addr, size,
> -							   dev_name(device));
> -		if (!devmem->resource)
> -			return ERR_PTR(-ENOMEM);
> -		break;
> -	}
> -	if (!devmem->resource)
> -		return ERR_PTR(-ERANGE);
> -
> -	devmem->resource->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
> +	devmem->resource = devm_request_free_mem_region(device, &iomem_resource,
> +			size);
> +	if (IS_ERR(devmem->resource))
> +		return ERR_CAST(devmem->resource);
>  	devmem->pfn_first = devmem->resource->start >> PAGE_SHIFT;
>  	devmem->pfn_last = devmem->pfn_first +
>  			   (resource_size(devmem->resource) >> PAGE_SHIFT);
> 


thanks,
-- 
John Hubbard
NVIDIA
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
