Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1447433307.21443.90.camel@hpe.com>
References: <20151112175215.2462.69420.stgit@dwillia2-desk3.jf.intel.com>
	<1447433307.21443.90.camel@hpe.com>
Date: Fri, 13 Nov 2015 09:00:40 -0800
Message-ID: <CAPcyv4iAHMA8g9dC2C5f6iqfkjGfM2vf5SSXNbfk1uUTwhRiYg@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, e820: fix numa node for e820-type-12 pmem ranges
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 13, 2015 at 8:48 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> On Thu, 2015-11-12 at 09:53 -0800, Dan Williams wrote:
>> Rather than punt on the numa node for these e820 ranges try to find a
>> better answer with memory_add_physaddr_to_nid() when it is available.
>>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Boaz Harrosh <boaz@plexistor.com>
>> Tested-by: Boaz Harrosh <boaz@plexistor.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> Only change from the original version is a compile fix for the
>> CONFIG_MEMORY_HOTPLUG=n case.
>>
>>  drivers/nvdimm/e820.c |   15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
>> index 8282db2ef99e..b0045a505dc8 100644
>> --- a/drivers/nvdimm/e820.c
>> +++ b/drivers/nvdimm/e820.c
>> @@ -3,6 +3,7 @@
>>   * Copyright (c) 2015, Intel Corporation.
>>   */
>>  #include <linux/platform_device.h>
>> +#include <linux/memory_hotplug.h>
>>  #include <linux/libnvdimm.h>
>>  #include <linux/module.h>
>>
>> @@ -25,6 +26,18 @@ static int e820_pmem_remove(struct platform_device *pdev)
>>       return 0;
>>  }
>>
>> +#ifdef CONFIG_MEMORY_HOTPLUG
>> +static int e820_range_to_nid(resource_size_t addr)
>> +{
>> +     return memory_add_physaddr_to_nid(addr);
>> +}
>> +#else
>> +static int e820_range_to_nid(resource_size_t addr)
>> +{
>> +     return NUMA_NO_NODE;
>> +}
>> +#endif
>
> "linux/memory_hotplug.h" defines as follows.
>
> #ifdef CONFIG_NUMA
> extern int memory_add_physaddr_to_nid(u64 start);
> #else
> static inline int memory_add_physaddr_to_nid(u64 start)
> {
>         return 0;
> }
> #endif
>
> So, memory_add_physaddr_to_nid() should be defined with #ifdef CONFIG_NUMA.
>
> #ifdef CONFIG_MEMORY_HOTPLUG
> int memory_add_physaddr_to_nid(u64 start)
> {
>

I thought so too, but 0day reported this:

https://lists.01.org/pipermail/kbuild-all/2015-November/014618.html
