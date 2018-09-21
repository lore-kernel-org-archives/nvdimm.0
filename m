Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23D9221143988
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 13:03:45 -0700 (PDT)
Subject: Re: [PATCH v4 3/5] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
References: <20180920215824.19464.8884.stgit@localhost.localdomain>
 <20180920222758.19464.83992.stgit@localhost.localdomain>
 <2254cfe1-5cd3-eedc-1f24-8e011dcf3575@microsoft.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <f4d5ace6-9657-746b-9448-064a4b7cfb8d@linux.intel.com>
Date: Fri, 21 Sep 2018 13:03:44 -0700
MIME-Version: 1.0
In-Reply-To: <2254cfe1-5cd3-eedc-1f24-8e011dcf3575@microsoft.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Pasha Tatashin <Pavel.Tatashin@microsoft.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "mhocko@suse.com" <mhocko@suse.com>, "dave.hansen@intel.com" <dave.hansen@intel.com>, "jglisse@redhat.com" <jglisse@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mingo@kernel.org" <mingo@kernel.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On 9/21/2018 12:50 PM, Pasha Tatashin wrote:
> 
> 
> On 9/20/18 6:29 PM, Alexander Duyck wrote:
>> The ZONE_DEVICE pages were being initialized in two locations. One was with
>> the memory_hotplug lock held and another was outside of that lock. The
>> problem with this is that it was nearly doubling the memory initialization
>> time. Instead of doing this twice, once while holding a global lock and
>> once without, I am opting to defer the initialization to the one outside of
>> the lock. This allows us to avoid serializing the overhead for memory init
>> and we can instead focus on per-node init times.
>>
>> One issue I encountered is that devm_memremap_pages and
>> hmm_devmmem_pages_create were initializing only the pgmap field the same
>> way. One wasn't initializing hmm_data, and the other was initializing it to
>> a poison value. Since this is something that is exposed to the driver in
>> the case of hmm I am opting for a third option and just initializing
>> hmm_data to 0 since this is going to be exposed to unknown third party
>> drivers.
>>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
>> +void __ref memmap_init_zone_device(struct zone *zone,
>> +				   unsigned long start_pfn,
>> +				   unsigned long size,
>> +				   struct dev_pagemap *pgmap)
>> +{
>> +	unsigned long pfn, end_pfn = start_pfn + size;
>> +	struct pglist_data *pgdat = zone->zone_pgdat;
>> +	unsigned long zone_idx = zone_idx(zone);
>> +	unsigned long start = jiffies;
>> +	int nid = pgdat->node_id;
>> +
>> +	if (WARN_ON_ONCE(!pgmap || !is_dev_zone(zone)))
>> +		return;
>> +
>> +	/*
>> +	 * The call to memmap_init_zone should have already taken care
>> +	 * of the pages reserved for the memmap, so we can just jump to
>> +	 * the end of that region and start processing the device pages.
>> +	 */
>> +	if (pgmap->altmap_valid) {
>> +		struct vmem_altmap *altmap = &pgmap->altmap;
>> +
>> +		start_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
>> +		size = end_pfn - start_pfn;
>> +	}
>> +
>> +	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>> +		struct page *page = pfn_to_page(pfn);
>> +
>> +		__init_single_page(page, pfn, zone_idx, nid);
>> +
>> +		/*
>> +		 * Mark page reserved as it will need to wait for onlining
>> +		 * phase for it to be fully associated with a zone.
>> +		 *
>> +		 * We can use the non-atomic __set_bit operation for setting
>> +		 * the flag as we are still initializing the pages.
>> +		 */
>> +		__SetPageReserved(page);
>> +
>> +		/*
>> +		 * ZONE_DEVICE pages union ->lru with a ->pgmap back
>> +		 * pointer and hmm_data.  It is a bug if a ZONE_DEVICE
>> +		 * page is ever freed or placed on a driver-private list.
>> +		 */
>> +		page->pgmap = pgmap;
>> +		page->hmm_data = 0;
> 
> __init_single_page()
>    mm_zero_struct_page()
> 
> Takes care of zeroing, no need to do another store here.

The problem is __init_singe_page also calls INIT_LIST_HEAD which I 
believe sets the prev pointer which overlaps with hmm_data.

> 
> Looks good otherwise.
> 
> Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
> 

Thanks for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
