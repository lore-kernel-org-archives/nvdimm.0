Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B30A44
	for <nvdimm@lists.linux.dev>; Mon, 24 Jul 2023 03:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690168702; x=1721704702;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=V0GFpi5NOJg6k/sL9m42TEcqn0gYNHYLljSFMHAdJ64=;
  b=SC7E33HQ2/+KnUgjyjcdYFzbK2mVine+MjrCeuVgryvIk+DVT4yOn3FM
   fWAEMy/fyoAfe5IES7lXZhukyDDz1lt6vwuVjVHzr4jluUNAVStBFoPCB
   U8WdBgxXoIb/GfhRb54dyf7FSOemVH7hsq5kvZPzew6Wk2XUespvh5iUl
   lXH6j/SjgTB7b6qDpGGttXWGX2dINVXdM+Hrzh6LUA2h5aav6oL/qQU4A
   I1jfI4nHtkzeagbWtRjM7pTACQ9vykDn3befdjHk6YDRhvxm2LxGsgOHa
   qBlVZi6Li0OX7myJkePqz0Q9adNQArBBFbjoI90yW9hOfosb7xV10yzr7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="453714645"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="453714645"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 20:18:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="790806458"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="790806458"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 20:18:17 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@redhat.com>,  Oscar
 Salvador <osalvador@suse.de>,  Dan Williams <dan.j.williams@intel.com>,
  Dave Jiang <dave.jiang@intel.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  nvdimm@lists.linux.dev,  linux-cxl@vger.kernel.org,
  Dave Hansen <dave.hansen@linux.intel.com>,  Jonathan Cameron
 <Jonathan.Cameron@Huawei.com>,  Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 2/3] mm/memory_hotplug: split memmap_on_memory
 requests across memblocks
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
	<20230720-vv-kmem_memmap-v2-2-88bdaab34993@intel.com>
	<87a5vmadcw.fsf@linux.ibm.com>
Date: Mon, 24 Jul 2023 11:16:28 +0800
In-Reply-To: <87a5vmadcw.fsf@linux.ibm.com> (Aneesh Kumar K. V.'s message of
	"Sun, 23 Jul 2023 20:23:19 +0530")
Message-ID: <87351e2e43.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> Vishal Verma <vishal.l.verma@intel.com> writes:
>
>> The MHP_MEMMAP_ON_MEMORY flag for hotplugged memory is currently
>> restricted to 'memblock_size' chunks of memory being added. Adding a
>> larger span of memory precludes memmap_on_memory semantics.
>>
>> For users of hotplug such as kmem, large amounts of memory might get
>> added from the CXL subsystem. In some cases, this amount may exceed the
>> available 'main memory' to store the memmap for the memory being added.
>> In this case, it is useful to have a way to place the memmap on the
>> memory being added, even if it means splitting the addition into
>> memblock-sized chunks.
>>
>> Change add_memory_resource() to loop over memblock-sized chunks of
>> memory if caller requested memmap_on_memory, and if other conditions for
>> it are met,. Teach try_remove_memory() to also expect that a memory
>> range being removed might have been split up into memblock sized chunks,
>> and to loop through those as needed.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Dave Jiang <dave.jiang@intel.com>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Huang Ying <ying.huang@intel.com>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> ---
>>  mm/memory_hotplug.c | 154 +++++++++++++++++++++++++++++++---------------------
>>  1 file changed, 91 insertions(+), 63 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index e9bcacbcbae2..20456f0d28e6 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1286,6 +1286,35 @@ bool mhp_supports_memmap_on_memory(unsigned long size)
>>  }
>>  EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>>  
>> +static int add_memory_create_devices(int nid, struct memory_group *group,
>> +				     u64 start, u64 size, mhp_t mhp_flags)
>> +{
>> +	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
>> +	struct vmem_altmap mhp_altmap = {};
>> +	int ret;
>> +
>> +	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY)) {
>> +		mhp_altmap.free = PHYS_PFN(size);
>> +		mhp_altmap.base_pfn = PHYS_PFN(start);
>> +		params.altmap = &mhp_altmap;
>> +	}
>> +
>> +	/* call arch's memory hotadd */
>> +	ret = arch_add_memory(nid, start, size, &params);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* create memory block devices after memory was added */
>> +	ret = create_memory_block_devices(start, size, mhp_altmap.alloc,
>> +					  group);
>> +	if (ret) {
>> +		arch_remove_memory(start, size, NULL);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  /*
>>   * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
>>   * and online/offline operations (triggered e.g. by sysfs).
>> @@ -1294,11 +1323,10 @@ EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>>   */
>>  int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>>  {
>> -	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
>> +	unsigned long memblock_size = memory_block_size_bytes();
>>  	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>> -	struct vmem_altmap mhp_altmap = {};
>>  	struct memory_group *group = NULL;
>> -	u64 start, size;
>> +	u64 start, size, cur_start;
>>  	bool new_node = false;
>>  	int ret;
>>  
>> @@ -1339,27 +1367,20 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>>  	/*
>>  	 * Self hosted memmap array
>>  	 */
>> -	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
>> -		if (!mhp_supports_memmap_on_memory(size)) {
>> -			ret = -EINVAL;
>> +	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
>> +	    mhp_supports_memmap_on_memory(memblock_size)) {
>> +		for (cur_start = start; cur_start < start + size;
>> +		     cur_start += memblock_size) {
>> +			ret = add_memory_create_devices(nid, group, cur_start,
>> +							memblock_size,
>> +							mhp_flags);
>> +			if (ret)
>> +				goto error;
>> +		}
>
> We should handle the below error details here. 
>
> 1) If we hit an error after some blocks got added, should we iterate over rest of the dev_dax->nr_range.
> 2) With some blocks added if we return a failure here, we remove the
> resource in dax_kmem. Is that ok? 
>
> IMHO error handling with partial creation of memory blocks in a resource range should be
> documented with this change.

Or, should we remove all added memory blocks upon error?

--
Best Regards,
Huang, Ying
