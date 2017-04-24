Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BEC621954066
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 08:04:38 -0700 (PDT)
Date: Mon, 24 Apr 2017 17:04:34 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 29/33] uio, libnvdimm, pmem: implement cache bypass
 for all copy_from_iter() operations
Message-ID: <20170424150434.GA32751@quack2.suse.cz>
References: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149222374186.32363.2497484556318146779.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149222374186.32363.2497484556318146779.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 14-04-17 19:35:41, Dan Williams wrote:
> Introduce copy_from_iter_ops() to enable passing custom sub-routines to
> iterate_and_advance(). Define pmem operations that guarantee cache
> bypass to supplement the existing usage of __copy_from_iter_nocache()
> backed by arch_wb_cache_pmem().
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

...

> +static int pmem_from_user(void *dst, const void __user *src, unsigned size)
> +{
> +	unsigned long flushed, dest = (unsigned long) dest;
						      ^^^ dst here?

Otherwise the patch looks good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

after fixing this.

								Honza


> +	int rc = __copy_from_user_nocache(dst, src, size);
> +
> +	/*
> +	 * On x86_64 __copy_from_user_nocache() uses non-temporal stores
> +	 * for the bulk of the transfer, but we need to manually flush
> +	 * if the transfer is unaligned. A cached memory copy is used
> +	 * when destination or size is not naturally aligned. That is:
> +	 *   - Require 8-byte alignment when size is 8 bytes or larger.
> +	 *   - Require 4-byte alignment when size is 4 bytes.
> +	 */
> +	if (size < 8) {
> +		if (!IS_ALIGNED(dest, 4) || size != 4)
> +			arch_wb_cache_pmem(dst, 1);
> +	} else {
> +		if (!IS_ALIGNED(dest, 8)) {
> +			dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
> +			arch_wb_cache_pmem(dst, 1);
> +		}
> +
> +		flushed = dest - (unsigned long) dst;
> +		if (size > flushed && !IS_ALIGNED(size - flushed, 8))
> +			arch_wb_cache_pmem(dst + size - 1, 1);
> +	}
> +
> +	return rc;
> +}
> +
> +static void pmem_from_page(char *to, struct page *page, size_t offset, size_t len)
> +{
> +	char *from = kmap_atomic(page);
> +
> +	arch_memcpy_to_pmem(to, from + offset, len);
> +	kunmap_atomic(from);
> +}
> +
> +size_t arch_copy_from_iter_pmem(void *addr, size_t bytes, struct iov_iter *i)
> +{
> +	return copy_from_iter_ops(addr, bytes, i, pmem_from_user, pmem_from_page,
> +			arch_memcpy_to_pmem);
> +}
> +EXPORT_SYMBOL_GPL(arch_copy_from_iter_pmem);
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 804e34c6f981..edb78f3fe2c8 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -91,6 +91,10 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
>  size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
>  bool copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
>  size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
> +size_t copy_from_iter_ops(void *addr, size_t bytes, struct iov_iter *i,
> +		int (*user)(void *, const void __user *, unsigned),
> +		void (*page)(char *, struct page *, size_t, size_t),
> +		void (*copy)(void *, void *, unsigned));
>  bool copy_from_iter_full_nocache(void *addr, size_t bytes, struct iov_iter *i);
>  size_t iov_iter_zero(size_t bytes, struct iov_iter *);
>  unsigned long iov_iter_alignment(const struct iov_iter *i);
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 0c4aac6ef394..4d8f575e65b3 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -404,6 +404,9 @@ config DMA_VIRT_OPS
>  	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
>  	default n
>  
> +config COPY_FROM_ITER_OPS
> +	bool
> +
>  config CHECK_SIGNATURE
>  	bool
>  
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index e68604ae3ced..85f8021504e3 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -571,6 +571,31 @@ size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
>  }
>  EXPORT_SYMBOL(copy_from_iter);
>  
> +#ifdef CONFIG_COPY_FROM_ITER_OPS
> +size_t copy_from_iter_ops(void *addr, size_t bytes, struct iov_iter *i,
> +		int (*user)(void *, const void __user *, unsigned),
> +		void (*page)(char *, struct page *, size_t, size_t),
> +		void (*copy)(void *, void *, unsigned))
> +{
> +	char *to = addr;
> +
> +	if (unlikely(i->type & ITER_PIPE)) {
> +		WARN_ON(1);
> +		return 0;
> +	}
> +	iterate_and_advance(i, bytes, v,
> +		user((to += v.iov_len) - v.iov_len, v.iov_base,
> +				 v.iov_len),
> +		page((to += v.bv_len) - v.bv_len, v.bv_page, v.bv_offset,
> +				v.bv_len),
> +		copy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
> +	)
> +
> +	return bytes;
> +}
> +EXPORT_SYMBOL_GPL(copy_from_iter_ops);
> +#endif
> +
>  bool copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i)
>  {
>  	char *to = addr;
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
