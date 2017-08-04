Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 2E4A2209589CC
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 10:41:17 -0700 (PDT)
Subject: Re: [PATCH 5/6] arm64: Implement pmem API support
References: <cover.1500397441.git.robin.murphy@arm.com>
 <ba8c28bcffc3bc856163441793bb4ef0fefa0f75.1500397441.git.robin.murphy@arm.com>
 <20170804152542.7h3mbyxnhjwroddc@armageddon.cambridge.arm.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <74521a9d-45fa-7e29-d9f9-960c478306ec@arm.com>
Date: Fri, 4 Aug 2017 18:43:27 +0100
MIME-Version: 1.0
In-Reply-To: <20170804152542.7h3mbyxnhjwroddc@armageddon.cambridge.arm.com>
Content-Language: en-GB
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
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: mark.rutland@arm.com, linux-nvdimm@lists.01.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/08/17 16:25, Catalin Marinas wrote:
> Two minor comments below.
> 
> On Tue, Jul 25, 2017 at 11:55:42AM +0100, Robin Murphy wrote:
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -960,6 +960,17 @@ config ARM64_UAO
>>  	  regular load/store instructions if the cpu does not implement the
>>  	  feature.
>>  
>> +config ARM64_PMEM
>> +	bool "Enable support for persistent memory"
>> +	select ARCH_HAS_PMEM_API
>> +	help
>> +	  Say Y to enable support for the persistent memory API based on the
>> +	  ARMv8.2 DCPoP feature.
>> +
>> +	  The feature is detected at runtime, and the kernel will use DC CVAC
>> +	  operations if DC CVAP is not supported (following the behaviour of
>> +	  DC CVAP itself if the system does not define a point of persistence).
> 
> Any reason not to have this default y?

Mostly because it's untested, and not actually useful without some way
of describing persistent memory regions to the kernel (I'm currently
trying to make sense of what exactly ARCH_HAS_MMIO_FLUSH is supposed to
mean in order to enable ACPI NFIT support).

There's also the potential issue that we can't disable ARCH_HAS_PMEM_API
at runtime on pre-v8.2 systems where DC CVAC may not strictly give the
guarantee of persistence that that is supposed to imply. However, I
guess that's more of an open problem, since even on a v8.2 CPU reporting
(mandatory) DC CVAP support we've still no way to actually know whether
the interconnect/memory controller/etc. of any old system is up to the
job. At this point I'm mostly hoping that people will only be sticking
NVDIMMs into systems that *are* properly designed to support them, v8.2
CPUs or not.

>> --- a/arch/arm64/mm/cache.S
>> +++ b/arch/arm64/mm/cache.S
>> @@ -172,6 +172,20 @@ ENDPIPROC(__clean_dcache_area_poc)
>>  ENDPROC(__dma_clean_area)
>>  
>>  /*
>> + *	__clean_dcache_area_pop(kaddr, size)
>> + *
>> + * 	Ensure that any D-cache lines for the interval [kaddr, kaddr+size)
>> + * 	are cleaned to the PoP.
>> + *
>> + *	- kaddr   - kernel address
>> + *	- size    - size in question
>> + */
>> +ENTRY(__clean_dcache_area_pop)
>> +	dcache_by_line_op cvap, sy, x0, x1, x2, x3
>> +	ret
>> +ENDPIPROC(__clean_dcache_area_pop)
>> +
>> +/*
>>   *	__dma_flush_area(start, size)
>>   *
>>   *	clean & invalidate D / U line
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index a682a0a2a0fa..a461a00ceb3e 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -183,3 +183,21 @@ bool kernel_page_present(struct page *page)
>>  }
>>  #endif /* CONFIG_HIBERNATION */
>>  #endif /* CONFIG_DEBUG_PAGEALLOC */
>> +
>> +#ifdef CONFIG_ARCH_HAS_PMEM_API
>> +#include <asm/cacheflush.h>
>> +
>> +static inline void arch_wb_cache_pmem(void *addr, size_t size)
>> +{
>> +	/* Ensure order against any prior non-cacheable writes */
>> +	dmb(sy);
>> +	__clean_dcache_area_pop(addr, size);
>> +}
> 
> Could we keep the dmb() in the actual __clean_dcache_area_pop()
> implementation?

Mark held the opinion that it should follow the same pattern as the
other cache maintenance primitives - e.g. we don't have such a dmb in
__inval_cache_range(), but do place them at callsites where we know it
may be necessary (head.S) - and I found it hard to disagree. The callers
in patch #6 should never need a barrier, and arguably we may not even
need this one, since it looks like pmem should currently always be
mapped as MEMREMAP_WB if ARCH_HAS_PMEM_API.

> I can do the changes myself if you don't have any objections.

If you would prefer to play safe and move it back into the assembly
that's fine by me, but note that the associated comments in patch #6
should also be removed if so.

Robin.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
