Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF0ED21250479
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 06:12:30 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4MCw7Xl145212
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 09:12:28 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2sn5qekywg-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 09:12:28 -0400
Received: from localhost
 by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Wed, 22 May 2019 14:12:26 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [RFC PATCH] mm/nvdimm: Fix kernel crash on
 devm_mremap_pages_release
In-Reply-To: <b775d65b-30e3-aceb-f2f8-f2413b129f52@linux.ibm.com>
References: <20190514025354.9108-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hsTvyRnLGr3y4JB6zPzdxb7WGQgaWs=5vRqf=L1DYynQ@mail.gmail.com>
 <b775d65b-30e3-aceb-f2f8-f2413b129f52@linux.ibm.com>
Date: Wed, 22 May 2019 18:42:19 +0530
MIME-Version: 1.0
Message-Id: <875zq2k4zw.fsf@linux.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> On 5/14/19 9:45 AM, Dan Williams wrote:
>> [ add Keith who was looking at something similar ]
>> 

...

>>
>> If it's reserved then we should not be accessing, even if the above
>> works in practice. Isn't the fix something more like this to fix up
>> the assumptions at release time?
>> 
>> diff --git a/kernel/memremap.c b/kernel/memremap.c
>> index a856cb5ff192..9074ba14572c 100644
>> --- a/kernel/memremap.c
>> +++ b/kernel/memremap.c
>> @@ -90,6 +90,7 @@ static void devm_memremap_pages_release(void *data)
>>    struct device *dev = pgmap->dev;
>>    struct resource *res = &pgmap->res;
>>    resource_size_t align_start, align_size;
>> + struct vmem_altmap *altmap = pgmap->altmap_valid ? &pgmap->altmap : NULL;
>>    unsigned long pfn;
>>    int nid;
>> 
>> @@ -102,7 +103,10 @@ static void devm_memremap_pages_release(void *data)
>>    align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
>>    - align_start;
>> 
>> - nid = page_to_nid(pfn_to_page(align_start >> PAGE_SHIFT));
>> + pfn = align_start >> PAGE_SHIFT;
>> + if (altmap)
>> + pfn += vmem_altmap_offset(altmap);
>> + nid = page_to_nid(pfn_to_page(pfn));
>> 
>>    mem_hotplug_begin();
>>    if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
>> @@ -110,8 +114,7 @@ static void devm_memremap_pages_release(void *data)
>>    __remove_pages(page_zone(pfn_to_page(pfn)), pfn,
>>    align_size >> PAGE_SHIFT, NULL);
>>    } else {
>> - arch_remove_memory(nid, align_start, align_size,
>> - pgmap->altmap_valid ? &pgmap->altmap : NULL);
>> + arch_remove_memory(nid, align_start, align_size, altmap);
>>    kasan_remove_zero_shadow(__va(align_start), align_size);
>>    }
>>    mem_hotplug_done();
>> 
> I did try that first. I was not sure about that. From the memory add vs 
> remove perspective.
>
> devm_memremap_pages:
>
> align_start = res->start & ~(SECTION_SIZE - 1);
> align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
> 		- align_start;
> align_end = align_start + align_size - 1;
>
> error = arch_add_memory(nid, align_start, align_size, altmap,
> 				false);
>
>
> devm_memremap_pages_release:
>
> /* pages are dead and unused, undo the arch mapping */
> align_start = res->start & ~(SECTION_SIZE - 1);
> align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
> 		- align_start;
>
> arch_remove_memory(nid, align_start, align_size,
> 		pgmap->altmap_valid ? &pgmap->altmap : NULL);
>
>
> Now if we are fixing the memremap_pages_release, shouldn't we adjust 
> alig_start w.r.t memremap_pages too? and I was not sure what that means 
> w.r.t add/remove alignment requirements.
>
> What is the intended usage of reserve area? I guess we want that part to 
> be added? if so shouldn't we remove them?

We need to intialize the struct page backing the reserve area too right?
Where should we do that?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
