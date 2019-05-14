Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15292212746D8
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 21:40:16 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4E4VjDS027902
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 00:40:16 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2sfpq789fq-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 00:40:16 -0400
Received: from localhost
 by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Tue, 14 May 2019 05:40:15 +0100
Subject: Re: [RFC PATCH] mm/nvdimm: Fix kernel crash on
 devm_mremap_pages_release
References: <20190514025354.9108-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hsTvyRnLGr3y4JB6zPzdxb7WGQgaWs=5vRqf=L1DYynQ@mail.gmail.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Tue, 14 May 2019 10:10:07 +0530
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hsTvyRnLGr3y4JB6zPzdxb7WGQgaWs=5vRqf=L1DYynQ@mail.gmail.com>
Content-Language: en-US
Message-Id: <b775d65b-30e3-aceb-f2f8-f2413b129f52@linux.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 5/14/19 9:45 AM, Dan Williams wrote:
> [ add Keith who was looking at something similar ]
> 
> On Mon, May 13, 2019 at 7:54 PM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:
>>
>> When we initialize the namespace, if we support altmap, we don't initialize all the
>> backing struct page where as while releasing the namespace we look at some of
>> these uninitilized struct page. This results in a kernel crash as below.
>>
>> kernel BUG at include/linux/mm.h:1034!
>> cpu 0x2: Vector: 700 (Program Check) at [c00000024146b870]
>>      pc: c0000000003788f8: devm_memremap_pages_release+0x258/0x3a0
>>      lr: c0000000003788f4: devm_memremap_pages_release+0x254/0x3a0
>>      sp: c00000024146bb00
>>     msr: 800000000282b033
>>    current = 0xc000000241382f00
>>    paca    = 0xc00000003fffd680   irqmask: 0x03   irq_happened: 0x01
>>      pid   = 4114, comm = ndctl
>>   c0000000009bf8c0 devm_action_release+0x30/0x50
>>   c0000000009c0938 release_nodes+0x268/0x2d0
>>   c0000000009b95b4 device_release_driver_internal+0x164/0x230
>>   c0000000009b638c unbind_store+0x13c/0x190
>>   c0000000009b4f44 drv_attr_store+0x44/0x60
>>   c00000000058ccc0 sysfs_kf_write+0x70/0xa0
>>   c00000000058b52c kernfs_fop_write+0x1ac/0x290
>>   c0000000004a415c __vfs_write+0x3c/0x70
>>   c0000000004a85ac vfs_write+0xec/0x200
>>   c0000000004a8920 ksys_write+0x80/0x130
>>   c00000000000bee4 system_call+0x5c/0x70
>>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>   mm/page_alloc.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 59661106da16..892eabe1ec13 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5740,8 +5740,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>>
>>   #ifdef CONFIG_ZONE_DEVICE
>>          /*
>> -        * Honor reservation requested by the driver for this ZONE_DEVICE
>> -        * memory. We limit the total number of pages to initialize to just
>> +        * We limit the total number of pages to initialize to just
>>           * those that might contain the memory mapping. We will defer the
>>           * ZONE_DEVICE page initialization until after we have released
>>           * the hotplug lock.
>> @@ -5750,8 +5749,6 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>>                  if (!altmap)
>>                          return;
>>
>> -               if (start_pfn == altmap->base_pfn)
>> -                       start_pfn += altmap->reserve;
> 
> If it's reserved then we should not be accessing, even if the above
> works in practice. Isn't the fix something more like this to fix up
> the assumptions at release time?
> 
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index a856cb5ff192..9074ba14572c 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -90,6 +90,7 @@ static void devm_memremap_pages_release(void *data)
>    struct device *dev = pgmap->dev;
>    struct resource *res = &pgmap->res;
>    resource_size_t align_start, align_size;
> + struct vmem_altmap *altmap = pgmap->altmap_valid ? &pgmap->altmap : NULL;
>    unsigned long pfn;
>    int nid;
> 
> @@ -102,7 +103,10 @@ static void devm_memremap_pages_release(void *data)
>    align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
>    - align_start;
> 
> - nid = page_to_nid(pfn_to_page(align_start >> PAGE_SHIFT));
> + pfn = align_start >> PAGE_SHIFT;
> + if (altmap)
> + pfn += vmem_altmap_offset(altmap);
> + nid = page_to_nid(pfn_to_page(pfn));
> 
>    mem_hotplug_begin();
>    if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
> @@ -110,8 +114,7 @@ static void devm_memremap_pages_release(void *data)
>    __remove_pages(page_zone(pfn_to_page(pfn)), pfn,
>    align_size >> PAGE_SHIFT, NULL);
>    } else {
> - arch_remove_memory(nid, align_start, align_size,
> - pgmap->altmap_valid ? &pgmap->altmap : NULL);
> + arch_remove_memory(nid, align_start, align_size, altmap);
>    kasan_remove_zero_shadow(__va(align_start), align_size);
>    }
>    mem_hotplug_done();
> 
I did try that first. I was not sure about that. From the memory add vs 
remove perspective.

devm_memremap_pages:

align_start = res->start & ~(SECTION_SIZE - 1);
align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
		- align_start;
align_end = align_start + align_size - 1;

error = arch_add_memory(nid, align_start, align_size, altmap,
				false);


devm_memremap_pages_release:

/* pages are dead and unused, undo the arch mapping */
align_start = res->start & ~(SECTION_SIZE - 1);
align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
		- align_start;

arch_remove_memory(nid, align_start, align_size,
		pgmap->altmap_valid ? &pgmap->altmap : NULL);


Now if we are fixing the memremap_pages_release, shouldn't we adjust 
alig_start w.r.t memremap_pages too? and I was not sure what that means 
w.r.t add/remove alignment requirements.

What is the intended usage of reserve area? I guess we want that part to 
be added? if so shouldn't we remove them?


-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
