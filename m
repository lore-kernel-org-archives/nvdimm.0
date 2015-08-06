Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1438883000-9011-7-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
	<1438883000-9011-7-git-send-email-ross.zwisler@linux.intel.com>
Date: Thu, 6 Aug 2015 14:26:01 -0700
Message-ID: <CAPcyv4iaeB1q0fttoXcBzYfwkx-ezzOKjK2QrpGieqLr7rrdiQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] dax: update I/O path to do proper PMEM flushing
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 6, 2015 at 10:43 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Update the DAX I/O path so that all operations that store data (I/O
> writes, zeroing blocks, punching holes, etc.) properly synchronize the
> stores to media using the PMEM API.  This ensures that the data DAX is
> writing is durable on media before the operation completes.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/dax.c | 55 ++++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 44 insertions(+), 11 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 47c3323..e7595db 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -17,12 +17,14 @@
>  #include <linux/atomic.h>
>  #include <linux/blkdev.h>
>  #include <linux/buffer_head.h>
> +#include <linux/dax.h>
>  #include <linux/fs.h>
>  #include <linux/genhd.h>
>  #include <linux/highmem.h>
>  #include <linux/memcontrol.h>
>  #include <linux/mm.h>
>  #include <linux/mutex.h>
> +#include <linux/pmem.h>
>  #include <linux/sched.h>
>  #include <linux/uio.h>
>  #include <linux/vmstat.h>
> @@ -46,10 +48,13 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>                         unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
>                         if (pgsz > count)
>                                 pgsz = count;
> -                       if (pgsz < PAGE_SIZE)
> +               if (pgsz < PAGE_SIZE) {
>                                 memset(addr, 0, pgsz);
> -                       else
> +                               wb_cache_pmem((void __pmem *)addr, pgsz);
> +                       } else {
>                                 clear_page(addr);
> +                               wb_cache_pmem((void __pmem *)addr, PAGE_SIZE);
> +                       }
>                         addr += pgsz;
>                         size -= pgsz;
>                         count -= pgsz;
> @@ -59,6 +64,7 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>                 }
>         } while (size);
>
> +       wmb_pmem();
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(dax_clear_blocks);
> @@ -70,15 +76,24 @@ static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
>         return bdev_direct_access(bh->b_bdev, sector, addr, &pfn, bh->b_size);
>  }
>
> +/*
> + * This function's stores and flushes need to be synced to media by a
> + * wmb_pmem() in the caller. We flush the data instead of writing it back
> + * because we don't expect to read this newly zeroed data in the near future.
> + */
>  static void dax_new_buf(void *addr, unsigned size, unsigned first, loff_t pos,
>                         loff_t end)
>  {
>         loff_t final = end - pos + first; /* The final byte of the buffer */
>
> -       if (first > 0)
> +       if (first > 0) {
>                 memset(addr, 0, first);
> -       if (final < size)
> +               flush_cache_pmem((void __pmem *)addr, first);

Why are we invalidating vs just writing back?  Isn't there a
possibility that the cpu will read these zeroes, in which case why
force it go to memory?  Let the cpu figure out when these writes are
evicted from the cache hierarchy or otherwise include some performance
numbers showing it is a win to force the eviction early.
