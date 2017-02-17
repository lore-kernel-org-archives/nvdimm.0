Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B847882129
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 19:52:34 -0800 (PST)
Date: Thu, 16 Feb 2017 20:52:33 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 03/13] x86, dax, pmem: introduce 'copy_from_iter' dax
 operation
Message-ID: <20170217035233.GB27382@linux.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148488422955.37913.7723740119156814265.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148488422955.37913.7723740119156814265.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 19, 2017 at 07:50:29PM -0800, Dan Williams wrote:
> The direct-I/O write path for a pmem device must ensure that data is flushed
> to a power-fail safe zone when the operation is complete. However, other
> dax capable block devices, like brd, do not have this requirement.
> Introduce a 'copy_from_iter' dax operation so that pmem can inject
> cache management without imposing this overhead on other dax capable
> block_device drivers.
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
>  arch/x86/include/asm/pmem.h |   31 -------------------------------
>  drivers/nvdimm/pmem.c       |   10 ++++++++++
>  fs/dax.c                    |   11 ++++++++++-
>  include/linux/blkdev.h      |    1 +
>  include/linux/pmem.h        |   24 ------------------------
>  5 files changed, 21 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
> index f26ba430d853..0ca5e693f4a2 100644
> --- a/arch/x86/include/asm/pmem.h
> +++ b/arch/x86/include/asm/pmem.h
> @@ -64,37 +64,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  		clwb(p);
>  }
>  
> -/*
> - * copy_from_iter_nocache() on x86 only uses non-temporal stores for iovec
> - * iterators, so for other types (bvec & kvec) we must do a cache write-back.
> - */
> -static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
> -{
> -	return iter_is_iovec(i) == false;
> -}
> -
> -/**
> - * arch_copy_from_iter_pmem - copy data from an iterator to PMEM
> - * @addr:	PMEM destination address
> - * @bytes:	number of bytes to copy
> - * @i:		iterator with source data
> - *
> - * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
> - */
> -static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
> -		struct iov_iter *i)
> -{
> -	size_t len;
> -
> -	/* TODO: skip the write-back by always using non-temporal stores */
> -	len = copy_from_iter_nocache(addr, bytes, i);
> -
> -	if (__iter_needs_pmem_wb(i))
> -		arch_wb_cache_pmem(addr, bytes);

This writeback is no longer conditional in the pmem_copy_from_iter() version,
which means that for iovec iterators you do a non-temporal store and then
afterwards take the time to loop through and flush the cachelines?  This seems
incorrect, and I wonder if this could be the cause of the performance
regression reported by 0-day?

> -
> -	return len;
> -}
> -
>  /**
>   * arch_clear_pmem - zero a PMEM memory range
>   * @addr:	virtual start address
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 6e5442174245..71e5e365d3fc 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -217,8 +217,18 @@ __weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
>  	return pmem->size - pmem->pfn_pad - offset;
>  }
>  
> +static size_t pmem_copy_from_iter(void *addr, size_t bytes,
> +		struct iov_iter *i)
> +{
> +	size_t rc = copy_from_iter_nocache(addr, bytes, i);
> +
> +	wb_cache_pmem(addr, bytes);
> +	return rc;
> +}
> +
>  static const struct dax_operations pmem_dax_ops = {
>  	.direct_access = pmem_direct_access,
> +	.copy_from_iter = pmem_copy_from_iter,
>  };
>  
>  static const struct block_device_operations pmem_fops = {
> diff --git a/fs/dax.c b/fs/dax.c
> index 81a77c070344..22cd57424a55 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1006,6 +1006,10 @@ static loff_t
>  dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		struct iomap *iomap)
>  {
> +	struct block_device *bdev = iomap->bdev;
> +	size_t (*dax_copy_from_iter)(void *, size_t, struct iov_iter *);
> +	const struct block_device_operations *ops = bdev->bd_disk->fops;
> +	const struct dax_operations *dax_ops = ops->dax_ops;
>  	struct iov_iter *iter = data;
>  	loff_t end = pos + length, done = 0;
>  	ssize_t ret = 0;
> @@ -1033,6 +1037,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  					      (end - 1) >> PAGE_SHIFT);
>  	}
>  
> +	if (dax_ops->copy_from_iter)
> +		dax_copy_from_iter = dax_ops->copy_from_iter;
> +	else
> +		dax_copy_from_iter = copy_from_iter_nocache;
> +
>  	while (pos < end) {
>  		unsigned offset = pos & (PAGE_SIZE - 1);
>  		struct blk_dax_ctl dax = { 0 };
> @@ -1052,7 +1061,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			map_len = end - pos;
>  
>  		if (iov_iter_rw(iter) == WRITE)
> -			map_len = copy_from_iter_pmem(dax.addr, map_len, iter);
> +			map_len = dax_copy_from_iter(dax.addr, map_len, iter);
>  		else
>  			map_len = copy_to_iter(dax.addr, map_len, iter);
>  		dax_unmap_atomic(iomap->bdev, &dax);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8afce34823f5..7ca559d124a3 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1866,6 +1866,7 @@ struct blk_dax_ctl {
>  struct dax_operations {
>  	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
>  			long);
> +	size_t (*copy_from_iter)(void *, size_t, struct iov_iter *);
>  };
>  
>  struct block_device_operations {
> diff --git a/include/linux/pmem.h b/include/linux/pmem.h
> index 71ecf3d46aac..9d542a5600e4 100644
> --- a/include/linux/pmem.h
> +++ b/include/linux/pmem.h
> @@ -31,13 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
>  	BUG();
>  }
>  
> -static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
> -		struct iov_iter *i)
> -{
> -	BUG();
> -	return 0;
> -}
> -
>  static inline void arch_clear_pmem(void *addr, size_t size)
>  {
>  	BUG();
> @@ -80,23 +73,6 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
>  }
>  
>  /**
> - * copy_from_iter_pmem - copy data from an iterator to PMEM
> - * @addr:	PMEM destination address
> - * @bytes:	number of bytes to copy
> - * @i:		iterator with source data
> - *
> - * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
> - * See blkdev_issue_flush() note for memcpy_to_pmem().
> - */
> -static inline size_t copy_from_iter_pmem(void *addr, size_t bytes,
> -		struct iov_iter *i)
> -{
> -	if (arch_has_pmem_api())
> -		return arch_copy_from_iter_pmem(addr, bytes, i);
> -	return copy_from_iter_nocache(addr, bytes, i);
> -}
> -
> -/**
>   * clear_pmem - zero a PMEM memory range
>   * @addr:	virtual start address
>   * @size:	number of bytes to zero
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
