Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 72A74208F7A59
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 08:23:34 -0700 (PDT)
Date: Fri, 4 Aug 2017 16:25:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5/6] arm64: Implement pmem API support
Message-ID: <20170804152542.7h3mbyxnhjwroddc@armageddon.cambridge.arm.com>
References: <cover.1500397441.git.robin.murphy@arm.com>
 <ba8c28bcffc3bc856163441793bb4ef0fefa0f75.1500397441.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ba8c28bcffc3bc856163441793bb4ef0fefa0f75.1500397441.git.robin.murphy@arm.com>
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
To: Robin Murphy <robin.murphy@arm.com>
Cc: mark.rutland@arm.com, linux-nvdimm@lists.01.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Two minor comments below.

On Tue, Jul 25, 2017 at 11:55:42AM +0100, Robin Murphy wrote:
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -960,6 +960,17 @@ config ARM64_UAO
>  	  regular load/store instructions if the cpu does not implement the
>  	  feature.
>  
> +config ARM64_PMEM
> +	bool "Enable support for persistent memory"
> +	select ARCH_HAS_PMEM_API
> +	help
> +	  Say Y to enable support for the persistent memory API based on the
> +	  ARMv8.2 DCPoP feature.
> +
> +	  The feature is detected at runtime, and the kernel will use DC CVAC
> +	  operations if DC CVAP is not supported (following the behaviour of
> +	  DC CVAP itself if the system does not define a point of persistence).

Any reason not to have this default y?

> --- a/arch/arm64/mm/cache.S
> +++ b/arch/arm64/mm/cache.S
> @@ -172,6 +172,20 @@ ENDPIPROC(__clean_dcache_area_poc)
>  ENDPROC(__dma_clean_area)
>  
>  /*
> + *	__clean_dcache_area_pop(kaddr, size)
> + *
> + * 	Ensure that any D-cache lines for the interval [kaddr, kaddr+size)
> + * 	are cleaned to the PoP.
> + *
> + *	- kaddr   - kernel address
> + *	- size    - size in question
> + */
> +ENTRY(__clean_dcache_area_pop)
> +	dcache_by_line_op cvap, sy, x0, x1, x2, x3
> +	ret
> +ENDPIPROC(__clean_dcache_area_pop)
> +
> +/*
>   *	__dma_flush_area(start, size)
>   *
>   *	clean & invalidate D / U line
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index a682a0a2a0fa..a461a00ceb3e 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -183,3 +183,21 @@ bool kernel_page_present(struct page *page)
>  }
>  #endif /* CONFIG_HIBERNATION */
>  #endif /* CONFIG_DEBUG_PAGEALLOC */
> +
> +#ifdef CONFIG_ARCH_HAS_PMEM_API
> +#include <asm/cacheflush.h>
> +
> +static inline void arch_wb_cache_pmem(void *addr, size_t size)
> +{
> +	/* Ensure order against any prior non-cacheable writes */
> +	dmb(sy);
> +	__clean_dcache_area_pop(addr, size);
> +}

Could we keep the dmb() in the actual __clean_dcache_area_pop()
implementation?

I can do the changes myself if you don't have any objections.

-- 
Catalin
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
