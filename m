Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id A783C1A1E12
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jul 2016 07:35:04 -0700 (PDT)
Date: Mon, 11 Jul 2016 15:34:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2] pmem: add pmem support codes on ARM64
Message-ID: <20160711143402.GA7691@leverpostej>
References: <1467964298-29241-1-git-send-email-kwangwoo.lee@sk.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1467964298-29241-1-git-send-email-kwangwoo.lee@sk.com>
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
Cc: linux-nvdimm@lists.01.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Woosuk Chung <woosuk.chung@sk.com>, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

On Fri, Jul 08, 2016 at 04:51:38PM +0900, Kwangwoo Lee wrote:
> +/**
> + * arch_memcpy_to_pmem - copy data to persistent memory
> + * @dst: destination buffer for the copy
> + * @src: source buffer for the copy
> + * @n: length of the copy in bytes
> + *
> + * Copy data to persistent memory media. if ARCH_HAS_PMEM_API is defined,
> + * then MEMREMAP_WB is used to memremap() during probe. A subsequent
> + * arch_wmb_pmem() need to guarantee durability.
> + */
> +static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
> +		size_t n)
> +{
> +	int unwritten;
> +
> +	unwritten = __copy_from_user_inatomic((void __force *) dst,
> +			(void __user *) src, n);
> +	if (WARN(unwritten, "%s: fault copying %p <- %p unwritten: %d\n",
> +				__func__, dst, src, unwritten))
> +		BUG();
> +
> +	__flush_dcache_area(dst, n);
> +}

I still don't understand why we use a access helper here.

I see that default_memcpy_from_pmem is just a memcpy, and no surrounding
framework seems to set_fs first. So this looks very suspicious.

Why are we trying to handle faults on kernel memory here? Especially as
we're going to BUG() if that happens anyway?

> +static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
> +		size_t n)
> +{
> +	memcpy(dst, (void __force *) src, n);
> +	return 0;
> +}

Similarly, I still don't understand why this isn't a mirror image of
arch_memcpy_to_pmem().

> +
> +/**
> + * arch_wmb_pmem - synchronize writes to persistent memory
> + *
> + * After a series of arch_memcpy_to_pmem() operations this need to be called to
> + * ensure that written data is durable on persistent memory media.
> + */
> +static inline void arch_wmb_pmem(void)
> +{
> +	/*
> +	 * We've already arranged for pmem writes to avoid the cache in
> +	 * arch_memcpy_to_pmem()
> +	 */

This comment is not true. We first copied, potentially hitting and/or
allocating in cache(s), then subsequently cleaned (and invalidated)
those.

> +	wmb();
> +
> +	/*
> +	 * pcommit_sfence() on X86 has been removed and will be replaced with
> +	 * a function after ARMv8.2 which will support DC CVAP to ensure
> +	 * Point-of-Persistency. Until then, mark here with a comment to keep
> +	 * the point for __clean_dcache_area_pop().
> +	 */
> +}

This comment is confusing. There's no need to mention x86 here.

As I mentioned on v1, in the absence of the ARMv8.2 extensions for
persistent memory, I am not sure whether the above is sufficient. There
could be caches after the PoC which data sits in, such that even after a
call to __flush_dcache_area() said data has not been written back to
persistent memory.

> +/**
> + * arch_invalidate_pmem - invalidate a PMEM memory range
> + * @addr:	virtual start address
> + * @size:	number of bytes to zero
> + *
> + * After finishing ARS(Address Range Scrubbing), clean and invalidate the
> + * address range.
> + */
> +static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
> +{
> +	__flush_dcache_area(addr, size);
> +}

As with my prior concern, I'm not sure that this is guaranteed to make
persistent data visible to the CPU, if there are caches after the PoC.

It looks like this is used to clear poison on x86, and I don't know
whether the ARM behaviour is comparable.

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

This looks correct per my understanding of the errata that use this
capability.

Thanks,
Mark.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
