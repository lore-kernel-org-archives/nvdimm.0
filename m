Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4107821295B25
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jun 2019 01:39:50 -0700 (PDT)
Subject: Re: [PATCH v9 07/12] mm/sparsemem: Prepare for sub-section ranges
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155977191770.2443951.1506588644989416699.stgit@dwillia2-desk3.amr.corp.intel.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <cb4b20ce-cd07-b274-7033-b2b7ca6df1dd@redhat.com>
Date: Fri, 14 Jun 2019 10:39:40 +0200
MIME-Version: 1.0
In-Reply-To: <155977191770.2443951.1506588644989416699.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On 05.06.19 23:58, Dan Williams wrote:
> Prepare the memory hot-{add,remove} paths for handling sub-section
> ranges by plumbing the starting page frame and number of pages being
> handled through arch_{add,remove}_memory() to
> sparse_{add,remove}_one_section().
> 
> This is simply plumbing, small cleanups, and some identifier renames. No
> intended functional changes.
> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/linux/memory_hotplug.h |    5 +-
>  mm/memory_hotplug.c            |  114 +++++++++++++++++++++++++---------------
>  mm/sparse.c                    |   15 ++---
>  3 files changed, 81 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 79e0add6a597..3ab0282b4fe5 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -348,9 +348,10 @@ extern int add_memory_resource(int nid, struct resource *resource);
>  extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  		unsigned long nr_pages, struct vmem_altmap *altmap);
>  extern bool is_memblock_offlined(struct memory_block *mem);
> -extern int sparse_add_one_section(int nid, unsigned long start_pfn,
> -				  struct vmem_altmap *altmap);
> +extern int sparse_add_section(int nid, unsigned long pfn,
> +		unsigned long nr_pages, struct vmem_altmap *altmap);
>  extern void sparse_remove_one_section(struct mem_section *ms,
> +		unsigned long pfn, unsigned long nr_pages,
>  		unsigned long map_offset, struct vmem_altmap *altmap);
>  extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
>  					  unsigned long pnum);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 4b882c57781a..399bf78bccc5 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -252,51 +252,84 @@ void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
>  }
>  #endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
>  
> -static int __meminit __add_section(int nid, unsigned long phys_start_pfn,
> -				   struct vmem_altmap *altmap)
> +static int __meminit __add_section(int nid, unsigned long pfn,
> +		unsigned long nr_pages,	struct vmem_altmap *altmap)
>  {
>  	int ret;
>  
> -	if (pfn_valid(phys_start_pfn))
> +	if (pfn_valid(pfn))
>  		return -EEXIST;
>  
> -	ret = sparse_add_one_section(nid, phys_start_pfn, altmap);
> +	ret = sparse_add_section(nid, pfn, nr_pages, altmap);
>  	return ret < 0 ? ret : 0;
>  }
>  
> +static int check_pfn_span(unsigned long pfn, unsigned long nr_pages,
> +		const char *reason)
> +{
> +	/*
> +	 * Disallow all operations smaller than a sub-section and only
> +	 * allow operations smaller than a section for
> +	 * SPARSEMEM_VMEMMAP. Note that check_hotplug_memory_range()
> +	 * enforces a larger memory_block_size_bytes() granularity for
> +	 * memory that will be marked online, so this check should only
> +	 * fire for direct arch_{add,remove}_memory() users outside of
> +	 * add_memory_resource().
> +	 */
> +	unsigned long min_align;
> +
> +	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
> +		min_align = PAGES_PER_SUBSECTION;
> +	else
> +		min_align = PAGES_PER_SECTION;
> +	if (!IS_ALIGNED(pfn, min_align)
> +			|| !IS_ALIGNED(nr_pages, min_align)) {
> +		WARN(1, "Misaligned __%s_pages start: %#lx end: #%lx\n",
> +				reason, pfn, pfn + nr_pages - 1);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Reasonably generic function for adding memory.  It is
>   * expected that archs that support memory hotplug will
>   * call this function after deciding the zone to which to
>   * add the new pages.
>   */
> -int __ref __add_pages(int nid, unsigned long phys_start_pfn,
> -		unsigned long nr_pages, struct mhp_restrictions *restrictions)
> +int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
> +		struct mhp_restrictions *restrictions)
>  {
>  	unsigned long i;
> -	int err = 0;
> -	int start_sec, end_sec;
> +	int start_sec, end_sec, err;
>  	struct vmem_altmap *altmap = restrictions->altmap;
>  
> -	/* during initialize mem_map, align hot-added range to section */
> -	start_sec = pfn_to_section_nr(phys_start_pfn);
> -	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
> -
>  	if (altmap) {
>  		/*
>  		 * Validate altmap is within bounds of the total request
>  		 */
> -		if (altmap->base_pfn != phys_start_pfn
> +		if (altmap->base_pfn != pfn
>  				|| vmem_altmap_offset(altmap) > nr_pages) {
>  			pr_warn_once("memory add fail, invalid altmap\n");
> -			err = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>  		}
>  		altmap->alloc = 0;
>  	}
>  
> +	err = check_pfn_span(pfn, nr_pages, "add");
> +	if (err)
> +		return err;
> +
> +	start_sec = pfn_to_section_nr(pfn);
> +	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
>  	for (i = start_sec; i <= end_sec; i++) {
> -		err = __add_section(nid, section_nr_to_pfn(i), altmap);
> +		unsigned long pfns;
> +
> +		pfns = min(nr_pages, PAGES_PER_SECTION
> +				- (pfn & ~PAGE_SECTION_MASK));
> +		err = __add_section(nid, pfn, pfns, altmap);
> +		pfn += pfns;
> +		nr_pages -= pfns;
>  
>  		/*
>  		 * EEXIST is finally dealt with by ioresource collision
> @@ -309,7 +342,6 @@ int __ref __add_pages(int nid, unsigned long phys_start_pfn,
>  		cond_resched();
>  	}
>  	vmemmap_populate_print_last();
> -out:
>  	return err;
>  }
>  
> @@ -487,10 +519,10 @@ static void shrink_pgdat_span(struct pglist_data *pgdat,
>  	pgdat->node_spanned_pages = 0;
>  }
>  
> -static void __remove_zone(struct zone *zone, unsigned long start_pfn)
> +static void __remove_zone(struct zone *zone, unsigned long start_pfn,
> +		unsigned long nr_pages)
>  {
>  	struct pglist_data *pgdat = zone->zone_pgdat;
> -	int nr_pages = PAGES_PER_SECTION;
>  	unsigned long flags;
>  
>  	pgdat_resize_lock(zone->zone_pgdat, &flags);
> @@ -499,27 +531,23 @@ static void __remove_zone(struct zone *zone, unsigned long start_pfn)
>  	pgdat_resize_unlock(zone->zone_pgdat, &flags);
>  }
>  
> -static void __remove_section(struct zone *zone, struct mem_section *ms,
> -			     unsigned long map_offset,
> -			     struct vmem_altmap *altmap)
> +static void __remove_section(struct zone *zone, unsigned long pfn,
> +		unsigned long nr_pages, unsigned long map_offset,
> +		struct vmem_altmap *altmap)
>  {
> -	unsigned long start_pfn;
> -	int scn_nr;
> +	struct mem_section *ms = __nr_to_section(pfn_to_section_nr(pfn));
>  
>  	if (WARN_ON_ONCE(!valid_section(ms)))
>  		return;
>  
> -	scn_nr = __section_nr(ms);
> -	start_pfn = section_nr_to_pfn((unsigned long)scn_nr);
> -	__remove_zone(zone, start_pfn);
> -
> -	sparse_remove_one_section(ms, map_offset, altmap);
> +	__remove_zone(zone, pfn, nr_pages);
> +	sparse_remove_one_section(ms, pfn, nr_pages, map_offset, altmap);
>  }
>  
>  /**
>   * __remove_pages() - remove sections of pages from a zone
>   * @zone: zone from which pages need to be removed
> - * @phys_start_pfn: starting pageframe (must be aligned to start of a section)
> + * @pfn: starting pageframe (must be aligned to start of a section)
>   * @nr_pages: number of pages to remove (must be multiple of section size)
>   * @altmap: alternative device page map or %NULL if default memmap is used
>   *
> @@ -528,31 +556,31 @@ static void __remove_section(struct zone *zone, struct mem_section *ms,
>   * sure that pages are marked reserved and zones are adjust properly by
>   * calling offline_pages().
>   */
> -void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
> +void __remove_pages(struct zone *zone, unsigned long pfn,
>  		    unsigned long nr_pages, struct vmem_altmap *altmap)
>  {
> -	unsigned long i;
>  	unsigned long map_offset = 0;
> -	int sections_to_remove;
> +	int i, start_sec, end_sec;

Can you convert these to unsigned longs? I'll be sending a clenup that
will make this consistent tree-wide soon. Just making sure we won't miss
this.

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
