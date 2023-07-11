Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF814AB5
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689088868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hR8o5w/Hx4dMIcWhqSVmnIxH5BFRWJkuE4F/mZRv5R0=;
	b=OoXI/FA3bERKpquqSi4z0CCm9rRG/8dMbhplArmjugJB3QBK61wpp3knhj5biNacIUBHe9
	jbF4XHHcMWxlAQjgaq07M1iaIjIIBFB4+Yus4P03xct0Ada3t06Xc479i4lRLe8ZY7O9Rl
	ftmb5A0u49Fqg5rZ1t0cFmLZT8o8vek=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-lqu6uc2ROKOlDQU_mNsQng-1; Tue, 11 Jul 2023 11:21:05 -0400
X-MC-Unique: lqu6uc2ROKOlDQU_mNsQng-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fbb0c01e71so35241595e9.0
        for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 08:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689088864; x=1691680864;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hR8o5w/Hx4dMIcWhqSVmnIxH5BFRWJkuE4F/mZRv5R0=;
        b=hgDYTF2n3g23tqJjVn7HVXTabPmzEXj4zQnhG1Hm8juaYRGZVrZ7eXLEAIo48d6Jil
         j0UQcGJZXtLQEpbWmofVlbOCJPEUr9vsDRJ57Q301C9rSJsxwqfHTs7AVs7ZrE5/ILwl
         kgKL0AvI+Phhn0YRzASHC/03xuU4JDidctSNif1M1lBf0MM7LN9MmOFblI0EkGcU9WSs
         NE3ZMRHpQRsaHxs3J4V1CGTepebCNy7XQh/iS5YoNtQApQk72ycjq1Su4+CS+EDHXe+x
         IdDeQ2udgQNV/6DmbLxYxE6sLHIjFHH0a80ISzlxkvMQ89rJNgjkCaDPzf25Bpg3vzIg
         v1GA==
X-Gm-Message-State: ABy/qLbBjGYIHtKzHTgk2BtZeDCg25Hx+E5dUIiV9TSgLg9KhnIiM9ZD
	zB5vGc6y5FBnSsrIcpG4+MZwfGIl4NTDZeH+ZWKVBb1sQddz9cqpGX+1sM7fVnmY7kKjm81mVpN
	pMTw76otQpBZXy10K
X-Received: by 2002:a05:600c:3659:b0:3fb:ffca:b6b8 with SMTP id y25-20020a05600c365900b003fbffcab6b8mr10769693wmq.41.1689088864171;
        Tue, 11 Jul 2023 08:21:04 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFa8FePMOcFtsaR5lyUM9Zkhx4gUcfLsSekgoJaLPVs+fd3+XRakBj3NxEJhRdLG4yh8Eojkw==
X-Received: by 2002:a05:600c:3659:b0:3fb:ffca:b6b8 with SMTP id y25-20020a05600c365900b003fbffcab6b8mr10769677wmq.41.1689088863833;
        Tue, 11 Jul 2023 08:21:03 -0700 (PDT)
Received: from ?IPV6:2003:cb:c745:4000:13ad:ed64:37e6:115d? (p200300cbc745400013aded6437e6115d.dip0.t-ipconnect.de. [2003:cb:c745:4000:13ad:ed64:37e6:115d])
        by smtp.gmail.com with ESMTPSA id k24-20020a05600c0b5800b003fc01189b0dsm2774139wmr.42.2023.07.11.08.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 08:21:03 -0700 (PDT)
Message-ID: <1df12885-9ae4-6aef-1a31-91ecd5a18d24@redhat.com>
Date: Tue, 11 Jul 2023 17:21:02 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Huang Ying <ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
 <20230613-vv-kmem_memmap-v1-3-f6de9c6af2c6@intel.com>
 <aadbedeb-424d-a146-392d-d56680263691@redhat.com>
 <87edleplkn.fsf@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 3/3] dax/kmem: Always enroll hotplugged memory for
 memmap_on_memory
In-Reply-To: <87edleplkn.fsf@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.07.23 16:30, Aneesh Kumar K.V wrote:
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 16.06.23 00:00, Vishal Verma wrote:
>>> With DAX memory regions originating from CXL memory expanders or
>>> NVDIMMs, the kmem driver may be hot-adding huge amounts of system memory
>>> on a system without enough 'regular' main memory to support the memmap
>>> for it. To avoid this, ensure that all kmem managed hotplugged memory is
>>> added with the MHP_MEMMAP_ON_MEMORY flag to place the memmap on the
>>> new memory region being hot added.
>>>
>>> To do this, call add_memory() in chunks of memory_block_size_bytes() as
>>> that is a requirement for memmap_on_memory. Additionally, Use the
>>> mhp_flag to force the memmap_on_memory checks regardless of the
>>> respective module parameter setting.
>>>
>>> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
>>> Cc: Len Brown <lenb@kernel.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>> Cc: Dave Jiang <dave.jiang@intel.com>
>>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>>> Cc: Huang Ying <ying.huang@intel.com>
>>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>>> ---
>>>    drivers/dax/kmem.c | 49 ++++++++++++++++++++++++++++++++++++-------------
>>>    1 file changed, 36 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
>>> index 7b36db6f1cbd..0751346193ef 100644
>>> --- a/drivers/dax/kmem.c
>>> +++ b/drivers/dax/kmem.c
>>> @@ -12,6 +12,7 @@
>>>    #include <linux/mm.h>
>>>    #include <linux/mman.h>
>>>    #include <linux/memory-tiers.h>
>>> +#include <linux/memory_hotplug.h>
>>>    #include "dax-private.h"
>>>    #include "bus.h"
>>>
>>> @@ -105,6 +106,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>>>    	data->mgid = rc;
>>>
>>>    	for (i = 0; i < dev_dax->nr_range; i++) {
>>> +		u64 cur_start, cur_len, remaining;
>>>    		struct resource *res;
>>>    		struct range range;
>>>
>>> @@ -137,21 +139,42 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>>>    		res->flags = IORESOURCE_SYSTEM_RAM;
>>>
>>>    		/*
>>> -		 * Ensure that future kexec'd kernels will not treat
>>> -		 * this as RAM automatically.
>>> +		 * Add memory in chunks of memory_block_size_bytes() so that
>>> +		 * it is considered for MHP_MEMMAP_ON_MEMORY
>>> +		 * @range has already been aligned to memory_block_size_bytes(),
>>> +		 * so the following loop will always break it down cleanly.
>>>    		 */
>>> -		rc = add_memory_driver_managed(data->mgid, range.start,
>>> -				range_len(&range), kmem_name, MHP_NID_IS_MGID);
>>> +		cur_start = range.start;
>>> +		cur_len = memory_block_size_bytes();
>>> +		remaining = range_len(&range);
>>> +		while (remaining) {
>>> +			mhp_t mhp_flags = MHP_NID_IS_MGID;
>>>
>>> -		if (rc) {
>>> -			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
>>> -					i, range.start, range.end);
>>> -			remove_resource(res);
>>> -			kfree(res);
>>> -			data->res[i] = NULL;
>>> -			if (mapped)
>>> -				continue;
>>> -			goto err_request_mem;
>>> +			if (mhp_supports_memmap_on_memory(cur_len,
>>> +							  MHP_MEMMAP_ON_MEMORY))
>>> +				mhp_flags |= MHP_MEMMAP_ON_MEMORY;
>>> +			/*
>>> +			 * Ensure that future kexec'd kernels will not treat
>>> +			 * this as RAM automatically.
>>> +			 */
>>> +			rc = add_memory_driver_managed(data->mgid, cur_start,
>>> +						       cur_len, kmem_name,
>>> +						       mhp_flags);
>>> +
>>> +			if (rc) {
>>> +				dev_warn(dev,
>>> +					 "mapping%d: %#llx-%#llx memory add failed\n",
>>> +					 i, cur_start, cur_start + cur_len - 1);
>>> +				remove_resource(res);
>>> +				kfree(res);
>>> +				data->res[i] = NULL;
>>> +				if (mapped)
>>> +					continue;
>>> +				goto err_request_mem;
>>> +			}
>>> +
>>> +			cur_start += cur_len;
>>> +			remaining -= cur_len;
>>>    		}
>>>    		mapped++;
>>>    	}
>>>
>>
>> Maybe the better alternative is teach
>> add_memory_resource()/try_remove_memory() to do that internally.
>>
>> In the add_memory_resource() case, it might be a loop around that
>> memmap_on_memory + arch_add_memory code path (well, and the error path
>> also needs adjustment):
>>
>> 	/*
>> 	 * Self hosted memmap array
>> 	 */
>> 	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
>> 		if (!mhp_supports_memmap_on_memory(size)) {
>> 			ret = -EINVAL;
>> 			goto error;
>> 		}
>> 		mhp_altmap.free = PHYS_PFN(size);
>> 		mhp_altmap.base_pfn = PHYS_PFN(start);
>> 		params.altmap = &mhp_altmap;
>> 	}
>>
>> 	/* call arch's memory hotadd */
>> 	ret = arch_add_memory(nid, start, size, &params);
>> 	if (ret < 0)
>> 		goto error;
>>
>>
>> Note that we want to handle that on a per memory-block basis, because we
>> don't want the vmemmap of memory block #2 to end up on memory block #1.
>> It all gets messy with memory onlining/offlining etc otherwise ...
>>
> 
> I tried to implement this inside add_memory_driver_managed() and also
> within dax/kmem. IMHO doing the error handling inside dax/kmem is
> better. Here is how it looks:
> 
> 1. If any blocks got added before (mapped > 0) we loop through all successful request_mem_regions
> 2. For each succesful request_mem_regions if any blocks got added, we
> keep the resource. If none got added, we will kfree the resource
> 

Doing this unconditional splitting outside of 
add_memory_driver_managed() is undesirable for at least two reasons

1) You end up always creating individual entries in the resource tree
    (/proc/iomem) even if MHP_MEMMAP_ON_MEMORY is not effective.
2) As we call arch_add_memory() in memory block granularity (e.g., 128
    MiB on x86), we might not make use of large PUDs (e.g., 1 GiB) in the
    identify mapping -- even if MHP_MEMMAP_ON_MEMORY is not effective.

While you could sense for support and do the split based on that, it 
will be beneficial for other users (especially DIMMs) if we do that 
internally -- where we already know if MHP_MEMMAP_ON_MEMORY can be 
effective or not.

In general, we avoid placing important kernel data-structures on slow 
memory. That's one of the reasons why PMEM decided to mostly always use 
ZONE_MOVABLE such that exactly what this patch does would not happen. So 
I'm wondering if there would be demand for an additional toggle.

Because even with memmap_on_memory enabled in general, you might not 
want to do that for dax/kmem.

IMHO, this patch should be dropped from your ppc64 series, as it's an 
independent change that might be valuable for other architectures as well.

-- 
Cheers,

David / dhildenb

