Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E1DE2122B990
 for <linux-nvdimm@lists.01.org>; Fri, 26 Apr 2019 05:57:46 -0700 (PDT)
Date: Fri, 26 Apr 2019 14:57:41 +0200
From: Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v6 03/12] mm/sparsemem: Add helpers track active portions
 of a section at boot
Message-ID: <20190426125741.GB28583@linux>
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552635098.2015392.5460028594173939000.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155552635098.2015392.5460028594173939000.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 17, 2019 at 11:39:11AM -0700, Dan Williams wrote:
> Prepare for hot{plug,remove} of sub-ranges of a section by tracking a
> section active bitmask, each bit representing 2MB (SECTION_SIZE (128M) /
> map_active bitmask length (64)). If it turns out that 2MB is too large
> of an active tracking granularity it is trivial to increase the size of
> the map_active bitmap.
> 
> The implications of a partially populated section is that pfn_valid()
> needs to go beyond a valid_section() check and read the sub-section
> active ranges from the bitmask.
> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[...]  
> +static unsigned long section_active_mask(unsigned long pfn,
> +		unsigned long nr_pages)
> +{
> +	int idx_start, idx_size;
> +	phys_addr_t start, size;
> +
> +	if (!nr_pages)
> +		return 0;
> +
> +	start = PFN_PHYS(pfn);
> +	size = PFN_PHYS(min(nr_pages, PAGES_PER_SECTION
> +				- (pfn & ~PAGE_SECTION_MASK)));
> +	size = ALIGN(size, SECTION_ACTIVE_SIZE);

I am probably missing something, and this is more a question than anything else, but:
is there a reason for shifting pfn and pages to get the size and the address?
Could not we operate on pfn/pages, so we do not have to shift every time?
(even for pfn_section_valid() calls)

Something like:

#define SUB_SECTION_ACTIVE_PAGES        (SECTION_ACTIVE_SIZE / PAGE_SIZE)

static inline int section_active_index(unsigned long pfn)
{
	return (pfn & ~(PAGE_SECTION_MASK)) / SUB_SECTION_ACTIVE_PAGES;
}

> +
> +	idx_start = section_active_index(start);
> +	idx_size = section_active_index(size);
> +
> +	if (idx_size == 0)
> +		return -1;

What about turning that into something more intuitive?
Since -1 represents here a full section, we could define something like:

#define FULL_SECTION	(-1UL)

Or a better name, it is just that I find "-1" not really easy to interpret.

> +	return ((1UL << idx_size) - 1) << idx_start;
> +}
> +
> +void section_active_init(unsigned long pfn, unsigned long nr_pages)
> +{
> +	int end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
> +	int i, start_sec = pfn_to_section_nr(pfn);
> +
> +	if (!nr_pages)
> +		return;
> +
> +	for (i = start_sec; i <= end_sec; i++) {
> +		struct mem_section *ms;
> +		unsigned long mask;
> +		unsigned long pfns;
> +
> +		pfns = min(nr_pages, PAGES_PER_SECTION
> +				- (pfn & ~PAGE_SECTION_MASK));
> +		mask = section_active_mask(pfn, pfns);
> +
> +		ms = __nr_to_section(i);
> +		pr_debug("%s: sec: %d mask: %#018lx\n", __func__, i, mask);
> +		ms->usage->map_active = mask;
> +
> +		pfn += pfns;
> +		nr_pages -= pfns;
> +	}
> +}
> +
>  /* Record a memory area against a node. */
>  void __init memory_present(int nid, unsigned long start, unsigned long end)
>  {
> 

-- 
Oscar Salvador
SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
