Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 4A6071A1E4A
 for <linux-nvdimm@lists.01.org>; Thu, 21 Jul 2016 09:12:29 -0700 (PDT)
Date: Thu, 21 Jul 2016 17:11:37 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/3] arm64: mm: add __clean_dcache_area()
Message-ID: <20160721161137.GG21616@arm.com>
References: <1468550782-14454-1-git-send-email-kwangwoo.lee@sk.com>
 <1468550782-14454-2-git-send-email-kwangwoo.lee@sk.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1468550782-14454-2-git-send-email-kwangwoo.lee@sk.com>
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
To: Kwangwoo Lee <kwangwoo.lee@sk.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-nvdimm@lists.01.org, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Woosuk Chung <woosuk.chung@sk.com>, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 15, 2016 at 11:46:20AM +0900, Kwangwoo Lee wrote:
> Ensure D-cache lines are cleaned to the PoC(Point of Coherency).
> 
> This function is called by arch_wb_cache_pmem() to clean the cache lines
> and remain the data in cache for the next access.
> 
> Signed-off-by: Kwangwoo Lee <kwangwoo.lee@sk.com>
> ---
>  arch/arm64/include/asm/cacheflush.h |  1 +
>  arch/arm64/mm/cache.S               | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
> index c64268d..903a94f 100644
> --- a/arch/arm64/include/asm/cacheflush.h
> +++ b/arch/arm64/include/asm/cacheflush.h
> @@ -68,6 +68,7 @@
>  extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end);
>  extern void flush_icache_range(unsigned long start, unsigned long end);
>  extern void __flush_dcache_area(void *addr, size_t len);
> +extern void __clean_dcache_area(void *addr, size_t len);
>  extern void __clean_dcache_area_pou(void *addr, size_t len);
>  extern long __flush_cache_user_range(unsigned long start, unsigned long end);
>  
> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> index 6df0706..5a350e4 100644
> --- a/arch/arm64/mm/cache.S
> +++ b/arch/arm64/mm/cache.S
> @@ -93,6 +93,24 @@ ENTRY(__flush_dcache_area)
>  ENDPIPROC(__flush_dcache_area)
>  
>  /*
> + *	__clean_dcache_area(kaddr, size)
> + *
> + * 	Ensure that any D-cache lines for the interval [kaddr, kaddr+size)
> + * 	are cleaned to the PoC.
> + *
> + *	- kaddr   - kernel address
> + *	- size    - size in question
> + */
> +ENTRY(__clean_dcache_area)
> +alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
> +	dcache_by_line_op cvac, sy, x0, x1, x2, x3
> +alternative_else
> +	dcache_by_line_op civac, sy, x0, x1, x2, x3
> +alternative_endif
> +	ret
> +ENDPROC(__clean_dcache_area)

This looks functionally equivalent to __dma_clean_range. How about we:

  1. Convert the __dma_* routines to use dcache_by_line
  2. Introduce __clean_dcache_area_poc as a fallthrough to __dma_clean_range
  3. Use __clean_dcache_area_poc for the pmem stuff (with some parameter
     marshalling in the macro).

Will
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
