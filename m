Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <55095FC9.8060906@plexistor.com>
Date: Wed, 18 Mar 2015 13:21:45 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [RFC PATCH 3/7] dma-mapping: allow archs to optionally
 specify a ->map_pfn() operation
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150316202543.33102.12409.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150316202543.33102.12409.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, riel@redhat.com, linux-nvdimm@lists.01.org, hch@infradead.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/16/2015 10:25 PM, Dan Williams wrote:
> This is in support of enabling block device drivers to perform DMA
> to/from persistent memory which may not have a backing struct page
> entry.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/Kconfig                             |    3 +++
>  include/asm-generic/dma-mapping-common.h |   30 ++++++++++++++++++++++++++++++
>  include/linux/dma-debug.h                |   23 +++++++++++++++++++----
>  include/linux/dma-mapping.h              |    8 +++++++-
>  lib/dma-debug.c                          |    4 ++--
>  5 files changed, 61 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 05d7a8a458d5..80ea3e124494 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -203,6 +203,9 @@ config HAVE_DMA_ATTRS
>  config HAVE_DMA_CONTIGUOUS
>  	bool
>  
> +config HAVE_DMA_PFN
> +	bool
> +
>  config GENERIC_SMP_IDLE_THREAD
>         bool
>  
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> index 3378dcf4c31e..58fad817e51a 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -17,9 +17,15 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
>  
>  	kmemcheck_mark_initialized(ptr, size);
>  	BUG_ON(!valid_dma_direction(dir));
> +#ifdef CONFIG_HAVE_DMA_PFN
> +	addr = ops->map_pfn(dev, page_to_pfn_typed(virt_to_page(ptr)),
> +			     (unsigned long)ptr & ~PAGE_MASK, size,
> +			     dir, attrs);
> +#else

Yes our beloved Kernel is full of #ifdef(s) in the middle of the code

Very beautiful

>  	addr = ops->map_page(dev, virt_to_page(ptr),
>  			     (unsigned long)ptr & ~PAGE_MASK, size,
>  			     dir, attrs);
> +#endif
>  	debug_dma_map_page(dev, virt_to_page(ptr),
>  			   (unsigned long)ptr & ~PAGE_MASK, size,
>  			   dir, addr, true);
> @@ -68,6 +74,29 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
>  		ops->unmap_sg(dev, sg, nents, dir, attrs);
>  }
>  
> +#ifdef CONFIG_HAVE_DMA_PFN
> +static inline dma_addr_t dma_map_pfn(struct device *dev, __pfn_t pfn,
> +				      size_t offset, size_t size,
> +				      enum dma_data_direction dir)
> +{
> +	struct dma_map_ops *ops = get_dma_ops(dev);
> +	dma_addr_t addr;
> +
> +	BUG_ON(!valid_dma_direction(dir));
> +	addr = ops->map_pfn(dev, pfn, offset, size, dir, NULL);
> +	debug_dma_map_pfn(dev, pfn, offset, size, dir, addr, false);
> +
> +	return addr;
> +}
> +
> +static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
> +				      size_t offset, size_t size,
> +				      enum dma_data_direction dir)
> +{
> +	kmemcheck_mark_initialized(page_address(page) + offset, size);
> +	return dma_map_pfn(dev, page_to_pfn_typed(page), offset, size, dir);
> +}
> +#else

And in the middle of source code files

>  static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
>  				      size_t offset, size_t size,
>  				      enum dma_data_direction dir)
> @@ -82,6 +111,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
>  
>  	return addr;
>  }
> +#endif /* CONFIG_HAVE_DMA_PFN */
>  
>  static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
>  				  size_t size, enum dma_data_direction dir)
> diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
> index fe8cb610deac..eb3e69c61e5e 100644
> --- a/include/linux/dma-debug.h
> +++ b/include/linux/dma-debug.h
> @@ -34,10 +34,18 @@ extern void dma_debug_init(u32 num_entries);
>  
>  extern int dma_debug_resize_entries(u32 num_entries);
>  
> -extern void debug_dma_map_page(struct device *dev, struct page *page,
> -			       size_t offset, size_t size,
> -			       int direction, dma_addr_t dma_addr,
> -			       bool map_single);
> +extern void debug_dma_map_pfn(struct device *dev, __pfn_t pfn, size_t offset,
> +			      size_t size, int direction, dma_addr_t dma_addr,
> +			      bool map_single);
> +
> +static inline void debug_dma_map_page(struct device *dev, struct page *page,
> +				      size_t offset, size_t size,
> +				      int direction, dma_addr_t dma_addr,
> +				      bool map_single)
> +{
> +	return debug_dma_map_pfn(dev, page_to_pfn_typed(page), offset, size,
> +			direction, dma_addr, map_single);
> +}
>  
>  extern void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
>  
> @@ -109,6 +117,13 @@ static inline void debug_dma_map_page(struct device *dev, struct page *page,
>  {
>  }
>  
> +static inline void debug_dma_map_pfn(struct device *dev, __pfn_t pfn,
> +				     size_t offset, size_t size,
> +				     int direction, dma_addr_t dma_addr,
> +				     bool map_single)
> +{
> +}
> +
>  static inline void debug_dma_mapping_error(struct device *dev,
>  					  dma_addr_t dma_addr)
>  {
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index c3007cb4bfa6..6411621e4179 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -26,11 +26,17 @@ struct dma_map_ops {
>  
>  	int (*get_sgtable)(struct device *dev, struct sg_table *sgt, void *,
>  			   dma_addr_t, size_t, struct dma_attrs *attrs);
> -
> +#ifdef CONFIG_HAVE_DMA_PFN
> +	dma_addr_t (*map_pfn)(struct device *dev, __pfn_t pfn,
> +			      unsigned long offset, size_t size,
> +			      enum dma_data_direction dir,
> +			      struct dma_attrs *attrs);
> +#else

And in the middle of structures

>  	dma_addr_t (*map_page)(struct device *dev, struct page *page,
>  			       unsigned long offset, size_t size,
>  			       enum dma_data_direction dir,
>  			       struct dma_attrs *attrs);
> +#endif
>  	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
>  			   size_t size, enum dma_data_direction dir,
>  			   struct dma_attrs *attrs);
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 9722bd2dbc9b..a447730fff97 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -1250,7 +1250,7 @@ out:
>  	put_hash_bucket(bucket, &flags);
>  }
>  
> -void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
> +void debug_dma_map_pfn(struct device *dev, __pfn_t pfn, size_t offset,
>  			size_t size, int direction, dma_addr_t dma_addr,
>  			bool map_single)
>  {
> @@ -1268,7 +1268,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  
>  	entry->dev       = dev;
>  	entry->type      = dma_debug_page;
> -	entry->pfn	 = page_to_pfn(page);
> +	entry->pfn	 = pfn.pfn;
>  	entry->offset	 = offset,
>  	entry->dev_addr  = dma_addr;
>  	entry->size      = size;
> 

This is exactly what I meant. It is not only two different code paths it is
two different compilation paths. This is a maintenance nightmare. And a sure
bit rot.

Real nice for nothing
Thanks, but no thanks
Boaz

