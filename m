Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793178934;
	b=XflFE189bVWuytG7/byEhOcgJo8fLNSVYBGWjrAyRTzIlot1MJqEcOk0CyKqtKdrBzse
	 1dhKCk6CctMFEc7Cdqe54a1I0nkW9aUm5+ia4IZa0nZlzbgiAgrMggzeR5k37XQGhImsN
	 ly2fvW0WbtMqwrgDU5GiCz4vrR2vPWsDYGUczXMFP43t31hiihfJ+c5E9h0/gxd3eJyhw
	 fu8cBVNt9ZbaEO9YrPnn04yz7da+9gP6EhsvwP8MswREJFNUD/SBfB8Dpl244bL/Fudwv
	 8ov/X87s9Cw6Vfd46wfV9F6hN1Ags6W2UuoGhR4v1K9fb+mQFW0QXg7KXP8/+vlszkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793178934;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=I1C7i6DuYb7E6K3Eqi0DOqtEEo5Hk8J4ZA/IyWGExvo=;
	b=gwcK4MHsDuIbWuB4HYHKRjLbmHJAacWezE5dfzVB0m/XIPuWkDk669/cjpN/qhAwTieI
	 DrtZdum++gSmVj1V14V7WmZmjYELtlSMLBFmYUXGneYaPlUyUqalK4xvaKdHK/qW54ISc
	 tgho+94WBtrJLMtenNxCW0pjhNoSC4CI+bVi0NQHES/U7cjrClVcDQFKV5Kqgn7rYbGm9
	 zgZsl40bq3Ux2cqAR3awUFpxz5h4hMnEu67gqR7iTZTCN+A1Z68LX8RHchYSY9RA+OYUa
	 4B6hegb1kcGWm8IhhzWF9LIz4hOOi8Cvn0VKCapofbG+tvS0XqZLOAFXsHDoMfz1x5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=svKQGSw1;
	arc=none smtp.remote-ip=91.218.175.21
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C99606A324
	for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 09:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46C99606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=svKQGSw1
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=m2ZmEY3hXzZpQIXkrfFsWiW7gYoWc6I8jskd+uCIP7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793178931; v=1; x=1793783731;
 b=svKQGSw1i7Qj6EedIgpZVtziaqSOU2AwsfqaZxihuT92z77DNHhcJQ1Sdcw3fIu9LJlA/M+k
 AP+PRAoy27bvOTHpB/aIkrD83STXJ+z9D+7V2raiLWWYOTWjRJlE3Vd3ixIASxThDKKlXYowxY1
 63i0HEM72vuhB5GiUZkGjnq0=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f93630efbef79496;
	Wed, 28 Oct 2026 09:15:19 +0000
X-Mizu-Trace-ID: f93630efbef79496
X-Migadu-Flow: FLOW_OUT
Message-ID: <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
Date: Wed, 28 Oct 2026 17:15:11 +0800
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
To: Yilei Zheng <trilith.zheng@gmail.com>,
 Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams
 <djbw@kernel.org>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Pankaj Gupta <pankaj.gupta@amd.com>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <20261027065723.66564-1-trilith.zheng@gmail.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027065723.66564-1-trilith.zheng@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/10/27 14:57, Yilei Zheng wrote:
> Hi Muchun,

Hi,

>
> I have been testing this series for microVMs that mount a read-only
> rootfs over virtio-pmem with FS-DAX. In this setup, most file data is
> accessed through read/write rather than mmap, so most PFNs never need
> private writable metadata. This optimization is very useful for
> reducing guest memory overhead and running more VMs on a host.

Thank you very much for the test, so in your scenario, this is also
the behavior of your real workload (mainly read/write-based, rather
than mmap), right?

>
> While testing, I ran into two issues, both in patch 3, including a
> crash when initializing the shared template page during probe, and the
> 128 MiB alignment check preventing our 2 MiB-aligned rootfs images from
> using the optimization, even though the check can be relaxed without
> changing the registration or teardown paths. I have included a patch
> for both at the end of this email.
>
>
> First, regarding the shared template initialization in
> memmap_init_zone_device():
>
>> @@ -1133,6 +1134,15 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>   	if (!nr_pages)
>>   		return;
>>   
>> +	if (pgmap_vmemmap_optimizable(pgmap)) {
>> +		struct page *page = page_address(pgmap->vmemmap_shared_page);
>> +
>> +		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
>> +			__init_zone_device_page(page + i, start_pfn + i,
>> +						ZONE_DEVICE, nid, pgmap);
>> +		goto pageblock_init;
>> +	}
> pgmap->vmemmap_shared_page is allocated from normal kernel memory
> (direct map). It is just a template buffer, not a real struct page
> inside the vmemmap space, so passing it to __init_zone_device_page()
> causes page_to_pfn(page) to compute an invalid, out-of-bounds PFN.

Yes, when I first wrote this code, I felt it wasn't very elegant.
But I wanted to share my ideas as early as possible.

>
> I first hit this when backporting the series to a 6.6.117 guest kernel,
> where set_pageblock_migratetype() uses that invalid PFN and crashes
> during device probe.
>
> On your base commit (next-20260902), a normal boot does not crash
> because pageblock init was moved to the end of the function. However,
> set_page_count() still calls page_to_pfn(page) inside the page_ref_set
> tracepoint. Booting with CONFIG_DEBUG_PAGE_REF=y and
> trace_event=page_ref:page_ref_set triggers the same NULL pointer
> dereference during probe:
>
>    BUG: kernel NULL pointer dereference, address: 0000000000000008
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    Call Trace:
>     trace_event_raw_event_page_ref_set+0x4e/0xa0
>     __init_zone_device_page+0x98/0xd0
>     memmap_init_zone_device+0x1c3/0x2e0

Very detailed analysis. I hadn't considered the potential issues
with set_page_count() before.

>
> To fix this, I added init_fsdax_page_template() to initialize the
> template fields (ZONE_DEVICE links, Reserved flag, pgmap, and refcount/
> mapcount via atomic_set()) directly without calling page_to_pfn(). It
> also preserves the WANT_PAGE_VIRTUAL handling from __init_single_page(),
> since patch 1 enables this optimization on LoongArch where KFENCE
> selects WANT_PAGE_VIRTUAL. I only have x86-64 to test on, so please let
> me know if that part looks right to you.

To be fair, it does fix the issue, but it's not very clean.
I might do some code cleanup first to solve this more gracefully.
I want to move the initialization to where the template page is
allocated, similar to what section-based vmemmap optimization
does.

>
>
> Second, regarding the alignment check in
> pgmap_vmemmap_shared_page_alloc():
>
>> The initial implementation is deliberately limited to a single
>> memory-block-aligned range. That is not a fundamental requirement, but keeps
>> the registration and teardown paths simple; support for multiple ranges or
>> less strict alignment can be added later.
> ...
>> +	if (pgmap->nr_range != 1 ||
>> +	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
>> +		return 0;
> After fixing the crash above, the optimization still did not take
> effect for my 130 MiB test rootfs image. Because MIN_MEMORY_BLOCK_SIZE
> is 128 MiB on x86-64, the 130 MiB device failed this check and fell
> back to allocating all 520 vmemmap pages.

Right. It is a deliberate decision in v1. It can be improved.

>
> In our microVM setup, rootfs images are sized to fit the filesystem and
> aligned to 2 MiB rather than 128 MiB. In fact, 2 MiB (SUBSECTION_SIZE)
> is already the native alignment for FS-DAX (via memremap_compat_align())
> and for ZONE_DEVICE vmemmap population and teardown. To keep those paths
> simple, we only need to make sure a shared vmemmap page never crosses a
> pgmap boundary, which 2 MiB alignment already guarantees on 4K-page
> kernels.
>
> So I relaxed the check from MIN_MEMORY_BLOCK_SIZE to SUBSECTION_SIZE.
> I also added an alignment check on (PAGE_SIZE / sizeof(struct page))
> PFNs, so the same boundary guarantee holds on large page kernels,
> where one vmemmap page covers more than 2 MiB of device memory (such
> as 16K/64K pages on LoongArch).
>
>
> With both changes applied on next-20260902 (QEMU x86-64), probing with
> CONFIG_DEBUG_PAGE_REF=y and trace_event=page_ref:page_ref_set works
> cleanly. The 130 MiB test device now uses one shared vmemmap backing
> page instead of 520 private pages, and DAX faults materialize private
> metadata on demand as expected. Mounting two 2 MiB-aligned virtio-pmem
> devices side by side also works properly, and unbinding/rebinding either
> device does not affect the other.
>
> If these changes look good to you, could you fold them into patch 3 for
> v2? (Note that the patch is against v1 and still uses the
> PGMAP_VMEMMAP_OPTIMIZATION flag.)

Thanks for the analysis and suggestions. However, the reason I
haven't sent out v2 yet is that I've been trying to refactor the
vmemmap optimization logic to make FS_DAX support cleaner. I think
I'll probably do some code refactoring first.

>
> I also noticed that next-20261023 has refactored
> memmap_init_zone_device() to use zone_device_page_init_from_template().

Yeah, this is another case that makes page initialization look less
elegant.

> The mm/mm_init.c change will need to be adapted when rebasing the
> series, while the mm/memremap.c change should remain applicable. I am
> happy to help retest v2.

I'cc you next time if you'd like to help me test.

Thanks,
Muchun

>
> Signed-off-by: Yilei Zheng <trilith.zheng@gmail.com>
> ---
>   mm/memremap.c |   10 +++++++++-
>   mm/mm_init.c  |   29 +++++++++++++++++++++++++++--
>   2 files changed, 36 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index a53d09b..34d8d89 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -93,8 +93,16 @@ static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap *pgmap, int nid)
>   	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
>   		return 0;
>   
> +	/*
> +	 * Subsections can be populated and removed independently, but a
> +	 * shared vmemmap page must never span across different pgmaps
> +	 * (which can exceed a subsection on large-page kernels). Check
> +	 * both boundaries instead of requiring a full memory block.
> +	 */
>   	if (pgmap->nr_range != 1 ||
> -	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
> +	    !IS_ALIGNED(range->start | range_len(range), SUBSECTION_SIZE) ||
> +	    !IS_ALIGNED(PHYS_PFN(range->start | range_len(range)),
> +			PAGE_SIZE / sizeof(struct page)))
>   		return 0;
>   
>   	pgmap->vmemmap_shared_page = alloc_pages_node(nid, GFP_KERNEL, 0);
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7dd03b8..1c3e269 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1030,6 +1030,31 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>   	}
>   }
>   
> +/*
> + * Initialize struct page slots in the shared backing page. Because this
> + * page is a direct-map template buffer rather than a real vmemmap entry,
> + * set_page_count() must not be used here as its tracepoint calls
> + * page_to_pfn(). Keep the initialized state in sync with
> + * __init_single_page() and __init_zone_device_page().
> + */
> +static void __ref init_fsdax_page_template(struct page *page,
> +					   unsigned long pfn, int nid,
> +					   struct dev_pagemap *pgmap)
> +{
> +	mm_zero_struct_page(page);
> +	set_page_links(page, ZONE_DEVICE, nid, pfn);
> +#ifdef WANT_PAGE_VIRTUAL
> +	if (!is_highmem_idx(ZONE_DEVICE))
> +		set_page_address(page, __va(pfn << PAGE_SHIFT));
> +#endif
> +	atomic_set(&page->_refcount, 0);
> +	atomic_set(&page->_mapcount, -1);
> +	page_cpupid_reset_last(page);
> +	page_kasan_tag_reset(page);
> +	__SetPageReserved(page);
> +	page_folio(page)->pgmap = pgmap;
> +}
> +
>   static void zone_device_page_init_from_template(struct page *page,
>   		unsigned long pfn, struct page *template)
>   {
> @@ -1138,7 +1163,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>   		struct page *page = page_address(pgmap->vmemmap_shared_page);
>   
>   		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> -			__init_zone_device_page(page + i, start_pfn + i,
> -						ZONE_DEVICE, nid, pgmap);
> +			init_fsdax_page_template(page + i, start_pfn + i,
> +						 nid, pgmap);
>   		goto pageblock_init;
>   	}

