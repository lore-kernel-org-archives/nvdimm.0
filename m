Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 17 Aug 2015 21:10:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 5/7] pmem: add copy_from_iter_pmem() and clear_pmem()
Message-ID: <20150817191016.GC6752@lst.de>
References: <1439836211-4719-1-git-send-email-ross.zwisler@linux.intel.com> <1439836211-4719-6-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1439836211-4719-6-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

>  #include <linux/uaccess.h>
> +#include <linux/uio.h>
> +

Can we keep this in linux/pmem.h?  I'm pretty sure the stubs would need
it as well, and even if they don't it'll keep the includes consistent.

> +{
> +	size_t len;
> +
> +	len = copy_from_iter_nocache((void __force *)addr, bytes, i);
> +
> +	/*
> +	 * copy_from_iter_nocache() on x86 only uses non-temporal stores for
> +	 * iovec iterators, so for other types (bvec & kvec) we must do a
> +	 * cache write-back.

Shouldn't we fi that?

> +	 */
> +	if (iter_is_iovec(i) == false)
> +		__arch_wb_cache_pmem(addr, bytes);

And if not and iter_needs_pmem_wb helper to encode this knowledge would
be useful.

> +static inline void arch_clear_pmem(void __pmem *addr, size_t size)
> +{
> +	/* TODO: implement the zeroing via non-temporal writes */
> +	if (size == PAGE_SIZE && ((unsigned long)addr & ~PAGE_MASK) == 0)
> +		clear_page((void __force *)addr);
> +	else
> +		memset((void __force *)addr, 0, size);
> +
> +	__arch_wb_cache_pmem(addr, size);

Please add a local vaiable so that the __force casting is only needed
once.  Same for other functions with this pattern.
