Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <CANMBJr6xkh1Ciqb_9JF33aPapavxLLZte1BH+rQpdRpwvLO+dA@mail.gmail.com>
References: <20150826010220.8851.18077.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150826012735.8851.49787.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CANMBJr6xkh1Ciqb_9JF33aPapavxLLZte1BH+rQpdRpwvLO+dA@mail.gmail.com>
Date: Fri, 18 Sep 2015 16:59:08 -0700
Message-ID: <CAPcyv4hm1TfKNbhy+EncWedgZa=LifCnrbuopHyfB9LGPvSAsQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] mm: move __phys_to_pfn and __pfn_to_phys to asm/generic/memory_model.h
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Tyler Baker <tyler.baker@linaro.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin's boot bot <khilman@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 18, 2015 at 4:42 PM, Tyler Baker <tyler.baker@linaro.org> wrote:
> Hi,
>
> On 25 August 2015 at 18:27, Dan Williams <dan.j.williams@intel.com> wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> Three architectures already define these, and we'll need them genericly
>> soon.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/arm/include/asm/memory.h       |    6 ------
>>  arch/arm64/include/asm/memory.h     |    6 ------
>>  arch/unicore32/include/asm/memory.h |    6 ------
>>  include/asm-generic/memory_model.h  |    6 ++++++
>>  4 files changed, 6 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
>> index b7f6fb462ea0..98d58bb04ac5 100644
>> --- a/arch/arm/include/asm/memory.h
>> +++ b/arch/arm/include/asm/memory.h
>> @@ -119,12 +119,6 @@
>>  #endif
>>
>>  /*
>> - * Convert a physical address to a Page Frame Number and back
>> - */
>> -#define        __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))
>> -#define        __pfn_to_phys(pfn)      ((phys_addr_t)(pfn) << PAGE_SHIFT)
>> -
>> -/*
>>   * Convert a page to/from a physical address
>>   */
>>  #define page_to_phys(page)     (__pfn_to_phys(page_to_pfn(page)))
>> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
>> index f800d45ea226..d808bb688751 100644
>> --- a/arch/arm64/include/asm/memory.h
>> +++ b/arch/arm64/include/asm/memory.h
>> @@ -81,12 +81,6 @@
>>  #define __phys_to_virt(x)      ((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
>>
>>  /*
>> - * Convert a physical address to a Page Frame Number and back
>> - */
>> -#define        __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))
>> -#define        __pfn_to_phys(pfn)      ((phys_addr_t)(pfn) << PAGE_SHIFT)
>> -
>> -/*
>>   * Convert a page to/from a physical address
>>   */
>>  #define page_to_phys(page)     (__pfn_to_phys(page_to_pfn(page)))
>> diff --git a/arch/unicore32/include/asm/memory.h b/arch/unicore32/include/asm/memory.h
>> index debafc40200a..3bb0a29fd2d7 100644
>> --- a/arch/unicore32/include/asm/memory.h
>> +++ b/arch/unicore32/include/asm/memory.h
>> @@ -61,12 +61,6 @@
>>  #endif
>>
>>  /*
>> - * Convert a physical address to a Page Frame Number and back
>> - */
>> -#define        __phys_to_pfn(paddr)    ((paddr) >> PAGE_SHIFT)
>> -#define        __pfn_to_phys(pfn)      ((pfn) << PAGE_SHIFT)
>> -
>> -/*
>>   * Convert a page to/from a physical address
>>   */
>>  #define page_to_phys(page)     (__pfn_to_phys(page_to_pfn(page)))
>> diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
>> index 14909b0b9cae..f20f407ce45d 100644
>> --- a/include/asm-generic/memory_model.h
>> +++ b/include/asm-generic/memory_model.h
>> @@ -69,6 +69,12 @@
>>  })
>>  #endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
>>
>> +/*
>> + * Convert a physical address to a Page Frame Number and back
>> + */
>> +#define        __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))
>> +#define        __pfn_to_phys(pfn)      ((pfn) << PAGE_SHIFT)
>
> The kernelci.org bot has been reporting complete boot failures[1] on
> ARM platforms with more than 4GB of memory and LPAE enabled. I've
> bisected[2] the failures down to this commit, and reverting it on top
> of the latest mainline resolves the boot issue. I took a closer look
> at this patch and noticed the cast to phys_addr_t was dropped in the
> generic function. Adding this to the new generic function solves the
> boot issue I'm reporting.
>
> diff --git a/include/asm-generic/memory_model.h
> b/include/asm-generic/memory_model.h
> index f20f407..db9f5c7 100644
> --- a/include/asm-generic/memory_model.h
> +++ b/include/asm-generic/memory_model.h
> @@ -73,7 +73,7 @@
>   * Convert a physical address to a Page Frame Number and back
>   */
>  #define        __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))
> -#define        __pfn_to_phys(pfn)      ((pfn) << PAGE_SHIFT)
> +#define        __pfn_to_phys(pfn)      ((phys_addr_t)(pfn) << PAGE_SHIFT)
>
>  #define page_to_pfn __page_to_pfn
>  #define pfn_to_page __pfn_to_page
>
> If this fix is valid, I can send a formal patch or it can be squashed
> into the original commit.

This fix is valid, but I wonder if it should just use the existing
PFN_PHYS() definition in include/linux/pfn.h?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
