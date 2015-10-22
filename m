Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 22 Oct 2015 11:26:14 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] dax: increase granularity of dax_clear_blocks()
 operations
Message-ID: <20151022092614.GD14445@quack.suse.cz>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022064154.12700.90545.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151022064154.12700.90545.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thu 22-10-15 02:41:54, Dan Williams wrote:
> dax_clear_blocks is currently performing a cond_resched() after every
> PAGE_SIZE memset.  We need not check so frequently, for example md-raid
> only calls cond_resched() at stripe granularity.  Also, in preparation
> for introducing a dax_map_atomic() operation that temporarily pins a dax
> mapping move the call to cond_resched() to the outer loop.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.com>

								Honza
> ---
>  fs/dax.c |   27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5dc33d788d50..f8e543839e5c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -28,6 +28,7 @@
>  #include <linux/sched.h>
>  #include <linux/uio.h>
>  #include <linux/vmstat.h>
> +#include <linux/sizes.h>
>  
>  int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>  {
> @@ -38,24 +39,20 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>  	do {
>  		void __pmem *addr;
>  		unsigned long pfn;
> -		long count;
> +		long count, sz;
>  
> -		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
> +		sz = min_t(long, size, SZ_1M);
> +		count = bdev_direct_access(bdev, sector, &addr, &pfn, sz);
>  		if (count < 0)
>  			return count;
> -		BUG_ON(size < count);
> -		while (count > 0) {
> -			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
> -			if (pgsz > count)
> -				pgsz = count;
> -			clear_pmem(addr, pgsz);
> -			addr += pgsz;
> -			size -= pgsz;
> -			count -= pgsz;
> -			BUG_ON(pgsz & 511);
> -			sector += pgsz / 512;
> -			cond_resched();
> -		}
> +		if (count < sz)
> +			sz = count;
> +		clear_pmem(addr, sz);
> +		addr += sz;
> +		size -= sz;
> +		BUG_ON(sz & 511);
> +		sector += sz / 512;
> +		cond_resched();
>  	} while (size);
>  
>  	wmb_pmem();
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
