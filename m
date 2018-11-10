Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 9 Nov 2018 21:07:50 -0500
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [mm PATCH v5 5/7] mm: Move hot-plug specific memory init into
 separate functions and optimize
Message-ID: <20181110020750.fsvvzl6hgfvk4qx4@xakep.localdomain>
References: <154145268025.30046.11742652345962594283.stgit@ahduyck-desk1.jf.intel.com>
 <154145279094.30046.504725873397414096.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154145279094.30046.504725873397414096.stgit@ahduyck-desk1.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, davem@davemloft.net, pavel.tatashin@microsoft.com, mhocko@suse.com, mingo@kernel.org, kirill.shutemov@linux.intel.com, dan.j.williams@intel.com, dave.jiang@intel.com, rppt@linux.vnet.ibm.com, willy@infradead.org, vbabka@suse.cz, khalid.aziz@oracle.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, yi.z.zhang@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 18-11-05 13:19:50, Alexander Duyck wrote:
> This patch is going through and combining the bits in memmap_init_zone and
> memmap_init_zone_device that are related to hotplug into a single function
> called __memmap_init_hotplug.
> 
> I also took the opportunity to integrate __init_single_page's functionality
> into this function. In doing so I can get rid of some of the redundancy
> such as the LRU pointers versus the pgmap.

Please don't do it, __init_single_page() is hard function to optimize,
do not copy its code. Instead could you you split __init_single_page()
in two parts, something like this:

static inline init_single_page_nolru(struct page *page, unsigned long pfn,
                                       unsigned long zone, int nid) {
        mm_zero_struct_page(page);
        set_page_links(page, zone, nid, pfn);
        init_page_count(page);
        page_mapcount_reset(page);
        page_cpupid_reset_last(page);
#ifdef WANT_PAGE_VIRTUAL
        /* The shift won't overflow because ZONE_NORMAL is below 4G. */
        if (!is_highmem_idx(zone))
                set_page_address(page, __va(pfn << PAGE_SHIFT));
#endif
}


static void __meminit init_single_page(struct page *page, unsigned long pfn, 
                                unsigned long zone, int nid) 
{
        init_single_page_nolru(page, pfn, zone, nid);
        INIT_LIST_HEAD(&page->lru);
}

And call init_single_page_nolru() from __init_pageblock() ? Also, remove
WANT_PAGE_VIRTUAL optimization, I do not think it worse it.

The rest looks very good, please do the above change.

Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>

> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
