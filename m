Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E800721A0BA90
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 13:32:21 -0700 (PDT)
Date: Mon, 8 May 2017 14:32:20 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] x86, uaccess: introduce copy_from_iter_wt for pmem /
 writethrough operations
Message-ID: <20170508203220.GA29073@linux.intel.com>
References: <20170427063054.soejyqocqqrihfdw@gmail.com>
 <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 28, 2017 at 12:39:12PM -0700, Dan Williams wrote:
> The pmem driver has a need to transfer data with a persistent memory
> destination and be able to rely on the fact that the destination writes
> are not cached. It is sufficient for the writes to be flushed to a
> cpu-store-buffer (non-temporal / "movnt" in x86 terms), as we expect
> userspace to call fsync() to ensure data-writes have reached a
> power-fail-safe zone in the platform. The fsync() triggers a REQ_FUA or
> REQ_FLUSH to the pmem driver which will turn around and fence previous
> writes with an "sfence".
> 
> Implement a __copy_from_user_inatomic_wt, memcpy_page_wt, and memcpy_wt,
> that guarantee that the destination buffer is not dirty in the cpu cache
> on completion. The new copy_from_iter_wt and sub-routines will be used
> to replace the "pmem api" (include/linux/pmem.h +
> arch/x86/include/asm/pmem.h). The availability of copy_from_iter_wt()
> and memcpy_wt() are gated by the CONFIG_ARCH_HAS_UACCESS_WT config
> symbol, and fallback to copy_from_iter_nocache() and plain memcpy()
> otherwise.
> 
> This is meant to satisfy the concern from Linus that if a driver wants
> to do something beyond the normal nocache semantics it should be
> something private to that driver [1], and Al's concern that anything
> uaccess related belongs with the rest of the uaccess code [2].
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html
> [2]: https://lists.01.org/pipermail/linux-nvdimm/2017-April/009942.html
> 
> Cc: <x86@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
<>
> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
> index c5504b9a472e..07ded30c7e89 100644
> --- a/arch/x86/include/asm/uaccess_64.h
> +++ b/arch/x86/include/asm/uaccess_64.h
> @@ -171,6 +171,10 @@ unsigned long raw_copy_in_user(void __user *dst, const void __user *src, unsigne
>  extern long __copy_user_nocache(void *dst, const void __user *src,
>  				unsigned size, int zerorest);
>  
> +extern long __copy_user_wt(void *dst, const void __user *src, unsigned size);
> +extern void memcpy_page_wt(char *to, struct page *page, size_t offset,
> +			   size_t len);
> +
>  static inline int
>  __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
>  				  unsigned size)
> @@ -179,6 +183,13 @@ __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
>  	return __copy_user_nocache(dst, src, size, 0);
>  }
>  
> +static inline int
> +__copy_from_user_inatomic_wt(void *dst, const void __user *src, unsigned size)
> +{
> +	kasan_check_write(dst, size);
> +	return __copy_user_wt(dst, src, size);
> +}
> +
>  unsigned long
>  copy_user_handle_tail(char *to, char *from, unsigned len);
>  
> diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> index 3b7c40a2e3e1..0aeff66a022f 100644
> --- a/arch/x86/lib/usercopy_64.c
> +++ b/arch/x86/lib/usercopy_64.c
> @@ -7,6 +7,7 @@
>   */
>  #include <linux/export.h>
>  #include <linux/uaccess.h>
> +#include <linux/highmem.h>
>  
>  /*
>   * Zero Userspace
> @@ -73,3 +74,130 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
>  	clac();
>  	return len;
>  }
> +
> +#ifdef CONFIG_ARCH_HAS_UACCESS_WT
> +/**
> + * clean_cache_range - write back a cache range with CLWB
> + * @vaddr:	virtual start address
> + * @size:	number of bytes to write back
> + *
> + * Write back a cache range using the CLWB (cache line write back)
> + * instruction. Note that @size is internally rounded up to be cache
> + * line size aligned.
> + */
> +static void clean_cache_range(void *addr, size_t size)
> +{
> +	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
> +	unsigned long clflush_mask = x86_clflush_size - 1;
> +	void *vend = addr + size;
> +	void *p;
> +
> +	for (p = (void *)((unsigned long)addr & ~clflush_mask);
> +	     p < vend; p += x86_clflush_size)
> +		clwb(p);
> +}
> +
> +long __copy_user_wt(void *dst, const void __user *src, unsigned size)
> +{
> +	unsigned long flushed, dest = (unsigned long) dst;
> +	long rc = __copy_user_nocache(dst, src, size, 0);
> +
> +	/*
> +	 * __copy_user_nocache() uses non-temporal stores for the bulk
> +	 * of the transfer, but we need to manually flush if the
> +	 * transfer is unaligned. A cached memory copy is used when
> +	 * destination or size is not naturally aligned. That is:
> +	 *   - Require 8-byte alignment when size is 8 bytes or larger.
> +	 *   - Require 4-byte alignment when size is 4 bytes.
> +	 */
> +	if (size < 8) {
> +		if (!IS_ALIGNED(dest, 4) || size != 4)
> +			clean_cache_range(dst, 1);
> +	} else {
> +		if (!IS_ALIGNED(dest, 8)) {
> +			dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
> +			clean_cache_range(dst, 1);
> +		}
> +
> +		flushed = dest - (unsigned long) dst;
> +		if (size > flushed && !IS_ALIGNED(size - flushed, 8))
> +			clean_cache_range(dst + size - 1, 1);
> +	}
> +
> +	return rc;
> +}
> +
> +void memcpy_wt(void *_dst, const void *_src, size_t size)
> +{
> +	unsigned long dest = (unsigned long) _dst;
> +	unsigned long source = (unsigned long) _src;
> +
> +	/* cache copy and flush to align dest */
> +	if (!IS_ALIGNED(dest, 8)) {
> +		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
> +
> +		memcpy((void *) dest, (void *) source, len);
> +		clean_cache_range((void *) dest, len);
> +		dest += len;
> +		source += len;
> +		size -= len;
> +		if (!size)
> +			return;
> +	}
> +
> +	/* 4x8 movnti loop */
> +	while (size >= 32) {
> +		asm("movq    (%0), %%r8\n"
> +		    "movq   8(%0), %%r9\n"
> +		    "movq  16(%0), %%r10\n"
> +		    "movq  24(%0), %%r11\n"
> +		    "movnti  %%r8,   (%1)\n"
> +		    "movnti  %%r9,  8(%1)\n"
> +		    "movnti %%r10, 16(%1)\n"
> +		    "movnti %%r11, 24(%1)\n"
> +		    :: "r" (source), "r" (dest)
> +		    : "memory", "r8", "r9", "r10", "r11");
> +		dest += 32;
> +		source += 32;
> +		size -= 32;
> +	}
> +
> +	/* 1x8 movnti loop */
> +	while (size >= 8) {
> +		asm("movq    (%0), %%r8\n"
> +		    "movnti  %%r8,   (%1)\n"
> +		    :: "r" (source), "r" (dest)
> +		    : "memory", "r8");
> +		dest += 8;
> +		source += 8;
> +		size -= 8;
> +	}
> +
> +	/* 1x4 movnti loop */
> +	while (size >= 4) {
> +		asm("movl    (%0), %%r8d\n"
> +		    "movnti  %%r8d,   (%1)\n"
> +		    :: "r" (source), "r" (dest)
> +		    : "memory", "r8");
> +		dest += 4;
> +		source += 4;
> +		size -= 4;
> +	}
> +
> +	/* cache copy for remaining bytes */
> +	if (size) {
> +		memcpy((void *) dest, (void *) source, size);
> +		clean_cache_range((void *) dest, size);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(memcpy_wt);

I took a pretty hard look at the changes in arch/x86/lib/usercopy_64.c, and
they look correct to me.  The inline assembly for non-temporal copies mixed
with C for loop control is IMHO much easier to follow than the pure assembly
of __copy_user_nocache().

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
