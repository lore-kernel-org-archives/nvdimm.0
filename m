Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FC1E21A143E3
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 03:54:29 -0700 (PDT)
Date: Wed, 14 Jun 2017 12:55:42 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 07/14] x86, dax: replace clear_pmem() with open coded
 memset + dax_ops->flush
Message-ID: <20170614105542.GE21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986417.20620.16200765147913100718.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703986417.20620.16200765147913100718.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri 09-06-17 13:24:24, Dan Williams wrote:
> The clear_pmem() helper simply combines a memset() plus a cache flush.
> Now that the flush routine is optionally provided by the dax device
> driver we can avoid unnecessary cache management on dax devices fronting
> volatile memory.
> 
> With clear_pmem() gone we can follow on with a patch to make pmem cache
> management completely defined within the pmem driver.
> 
> Cc: <x86@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  arch/x86/include/asm/pmem.h |   13 -------------
>  fs/dax.c                    |    3 ++-
>  include/linux/pmem.h        |   21 ---------------------
>  3 files changed, 2 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
> index 60e8edbe0205..f4c119d253f3 100644
> --- a/arch/x86/include/asm/pmem.h
> +++ b/arch/x86/include/asm/pmem.h
> @@ -65,19 +65,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  		clwb(p);
>  }
>  
> -/**
> - * arch_clear_pmem - zero a PMEM memory range
> - * @addr:	virtual start address
> - * @size:	number of bytes to zero
> - *
> - * Write zeros into the memory range starting at 'addr' for 'size' bytes.
> - */
> -static inline void arch_clear_pmem(void *addr, size_t size)
> -{
> -	memset(addr, 0, size);
> -	arch_wb_cache_pmem(addr, size);
> -}
> -
>  static inline void arch_invalidate_pmem(void *addr, size_t size)
>  {
>  	clflush_cache_range(addr, size);
> diff --git a/fs/dax.c b/fs/dax.c
> index 0933fc460ada..554b8e7d921c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -975,7 +975,8 @@ int __dax_zero_page_range(struct block_device *bdev,
>  			dax_read_unlock(id);
>  			return rc;
>  		}
> -		clear_pmem(kaddr + offset, size);
> +		memset(kaddr + offset, 0, size);
> +		dax_flush(dax_dev, pgoff, kaddr + offset, size);
>  		dax_read_unlock(id);
>  	}
>  	return 0;
> diff --git a/include/linux/pmem.h b/include/linux/pmem.h
> index 9d542a5600e4..772bd02a5b52 100644
> --- a/include/linux/pmem.h
> +++ b/include/linux/pmem.h
> @@ -31,11 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
>  	BUG();
>  }
>  
> -static inline void arch_clear_pmem(void *addr, size_t size)
> -{
> -	BUG();
> -}
> -
>  static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  {
>  	BUG();
> @@ -73,22 +68,6 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
>  }
>  
>  /**
> - * clear_pmem - zero a PMEM memory range
> - * @addr:	virtual start address
> - * @size:	number of bytes to zero
> - *
> - * Write zeros into the memory range starting at 'addr' for 'size' bytes.
> - * See blkdev_issue_flush() note for memcpy_to_pmem().
> - */
> -static inline void clear_pmem(void *addr, size_t size)
> -{
> -	if (arch_has_pmem_api())
> -		arch_clear_pmem(addr, size);
> -	else
> -		memset(addr, 0, size);
> -}
> -
> -/**
>   * invalidate_pmem - flush a pmem range from the cache hierarchy
>   * @addr:	virtual start address
>   * @size:	bytes to invalidate (internally aligned to cache line size)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
