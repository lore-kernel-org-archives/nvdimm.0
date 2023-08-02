Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469017488
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 14:21:08 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RGDZT4Q37z67GZK;
	Wed,  2 Aug 2023 22:17:21 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 2 Aug
 2023 15:20:59 +0100
Date: Wed, 2 Aug 2023 15:20:58 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Huang Ying
	<ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Aneesh
 Kumar K.V <aneesh.kumar@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, Jeff
 Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3 1/2] mm/memory_hotplug: split memmap_on_memory
 requests across memblocks
Message-ID: <20230802152058.000030ed@Huawei.com>
In-Reply-To: <20230801-vv-kmem_memmap-v3-1-406e9aaf5689@intel.com>
References: <20230801-vv-kmem_memmap-v3-0-406e9aaf5689@intel.com>
	<20230801-vv-kmem_memmap-v3-1-406e9aaf5689@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 01 Aug 2023 23:55:37 -0600
Vishal Verma <vishal.l.verma@intel.com> wrote:

> The MHP_MEMMAP_ON_MEMORY flag for hotplugged memory is restricted to
> 'memblock_size' chunks of memory being added. Adding a larger span of
> memory precludes memmap_on_memory semantics.
> 
> For users of hotplug such as kmem, large amounts of memory might get
> added from the CXL subsystem. In some cases, this amount may exceed the
> available 'main memory' to store the memmap for the memory being added.
> In this case, it is useful to have a way to place the memmap on the
> memory being added, even if it means splitting the addition into
> memblock-sized chunks.
> 
> Change add_memory_resource() to loop over memblock-sized chunks of
> memory if caller requested memmap_on_memory, and if other conditions for
> it are met. Teach try_remove_memory() to also expect that a memory
> range being removed might have been split up into memblock sized chunks,
> and to loop through those as needed.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

A couple of trivial comments inline.

> ---
>  mm/memory_hotplug.c | 150 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 93 insertions(+), 57 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index d282664f558e..cae03c8d4bbf 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1383,6 +1383,44 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
>  	return arch_supports_memmap_on_memory(vmemmap_size);
>  }
>  
> +static int add_memory_create_devices(int nid, struct memory_group *group,
> +				     u64 start, u64 size, mhp_t mhp_flags)
> +{
> +	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> +	struct vmem_altmap mhp_altmap = {
> +		.base_pfn =  PHYS_PFN(start),
> +		.end_pfn  =  PHYS_PFN(start + size - 1),
> +	};
> +	int ret;
> +
> +	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY)) {
> +		mhp_altmap.free = memory_block_memmap_on_memory_pages();
> +		params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
> +		if (!params.altmap)
> +			return -ENOMEM;
> +
> +		memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
> +	}
> +
> +	/* call arch's memory hotadd */
> +	ret = arch_add_memory(nid, start, size, &params);
> +	if (ret < 0)
> +		goto error;
> +
> +	/* create memory block devices after memory was added */
> +	ret = create_memory_block_devices(start, size, params.altmap, group);
> +	if (ret) {
> +		arch_remove_memory(start, size, NULL);

Maybe push this down to a second label?

> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	kfree(params.altmap);
> +	return ret;
> +}
> +
>  /*
>   * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
>   * and online/offline operations (triggered e.g. by sysfs).
> @@ -1391,14 +1429,10 @@ static bool mhp_supports_memmap_on_memory(unsigned long size)
>   */
>  int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  {
> -	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> +	unsigned long memblock_size = memory_block_size_bytes();
>  	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
> -	struct vmem_altmap mhp_altmap = {
> -		.base_pfn =  PHYS_PFN(res->start),
> -		.end_pfn  =  PHYS_PFN(res->end),
> -	};
>  	struct memory_group *group = NULL;
> -	u64 start, size;
> +	u64 start, size, cur_start;
>  	bool new_node = false;
>  	int ret;
>  
> @@ -1439,28 +1473,21 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	/*
>  	 * Self hosted memmap array
>  	 */
> -	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
> -		if (mhp_supports_memmap_on_memory(size)) {
> -			mhp_altmap.free = memory_block_memmap_on_memory_pages();
> -			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
> -			if (!params.altmap)
> +	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
> +	    mhp_supports_memmap_on_memory(memblock_size)) {
> +		for (cur_start = start; cur_start < start + size;
> +		     cur_start += memblock_size) {
> +			ret = add_memory_create_devices(nid, group, cur_start,
> +							memblock_size,
> +							mhp_flags);
> +			if (ret)
>  				goto error;
> -
> -			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
>  		}
> -		/* fallback to not using altmap  */
> -	}
> -
> -	/* call arch's memory hotadd */
> -	ret = arch_add_memory(nid, start, size, &params);
> -	if (ret < 0)
> -		goto error_free;
> -
> -	/* create memory block devices after memory was added */
> -	ret = create_memory_block_devices(start, size, params.altmap, group);
> -	if (ret) {
> -		arch_remove_memory(start, size, NULL);
> -		goto error_free;
> +	} else {
> +		ret = add_memory_create_devices(nid, group, start, size,
> +						mhp_flags);
> +		if (ret)
> +			goto error;
>  	}
>  
>  	if (new_node) {
> @@ -1497,8 +1524,6 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  		walk_memory_blocks(start, size, NULL, online_memory_block);
>  
>  	return ret;
> -error_free:
> -	kfree(params.altmap);
>  error:
>  	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
>  		memblock_remove(start, size);
> @@ -2149,40 +2174,14 @@ void try_offline_node(int nid)
>  }
>  EXPORT_SYMBOL(try_offline_node);
>  
> -static int __ref try_remove_memory(u64 start, u64 size)
> +static void __ref __try_remove_memory(int nid, u64 start, u64 size)
>  {
> -	int ret;
> -	struct memory_block *mem;
> -	int rc = 0, nid = NUMA_NO_NODE;
>  	struct vmem_altmap *altmap = NULL;
> +	struct memory_block *mem;
> +	int ret;
>  
> -	BUG_ON(check_hotplug_memory_range(start, size));
> -
> -	/*
> -	 * All memory blocks must be offlined before removing memory.  Check
> -	 * whether all memory blocks in question are offline and return error
> -	 * if this is not the case.
> -	 *
> -	 * While at it, determine the nid. Note that if we'd have mixed nodes,
> -	 * we'd only try to offline the last determined one -- which is good
> -	 * enough for the cases we care about.
> -	 */
> -	rc = walk_memory_blocks(start, size, &nid, check_memblock_offlined_cb);
> -	if (rc)
> -		return rc;
> -
> -	/*
> -	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
> -	 * the same granularity it was added - a single memory block.
> -	 */
>  	ret = walk_memory_blocks(start, size, &mem, test_has_altmap_cb);
>  	if (ret) {
> -		if (size != memory_block_size_bytes()) {
> -			pr_warn("Refuse to remove %#llx - %#llx,"
> -				"wrong granularity\n",
> -				start, start + size);
> -			return -EINVAL;
> -		}
>  		altmap = mem->altmap;
>  		/*
>  		 * Mark altmap NULL so that we can add a debug
> @@ -2221,6 +2220,43 @@ static int __ref try_remove_memory(u64 start, u64 size)
>  		try_offline_node(nid);
>  
>  	mem_hotplug_done();
> +}
> +
> +static int __ref try_remove_memory(u64 start, u64 size)
> +{
> +	int ret, nid = NUMA_NO_NODE;

I'm not overly keen to see the trivial rename of rc -> ret in here.
Just makes it ever so slightly harder to compare old code and new code.

> +
> +	BUG_ON(check_hotplug_memory_range(start, size));
> +
> +	/*
> +	 * All memory blocks must be offlined before removing memory.  Check
> +	 * whether all memory blocks in question are offline and return error
> +	 * if this is not the case.
> +	 *
> +	 * While at it, determine the nid. Note that if we'd have mixed nodes,
> +	 * we'd only try to offline the last determined one -- which is good
> +	 * enough for the cases we care about.
> +	 */
> +	ret = walk_memory_blocks(start, size, &nid, check_memblock_offlined_cb);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * For memmap_on_memory, the altmaps could have been added on
> +	 * a per-memblock basis. Loop through the entire range if so,
> +	 * and remove each memblock and its altmap.
> +	 */
> +	if (mhp_memmap_on_memory()) {
> +		unsigned long memblock_size = memory_block_size_bytes();
> +		u64 cur_start;
> +
> +		for (cur_start = start; cur_start < start + size;
> +		     cur_start += memblock_size)
> +			__try_remove_memory(nid, cur_start, memblock_size);
> +	} else {
> +		__try_remove_memory(nid, start, size);
> +	}
> +
>  	return 0;
>  }
>  
> 

