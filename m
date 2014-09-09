Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1410301783.8366.1.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 1/9] SQUASHME: pmem: Remove unused #include headers
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Tue, 09 Sep 2014 16:29:43 -0600
In-Reply-To: <540F1F6F.7090905@plexistor.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	 <540F1EC6.4000504@plexistor.com> <540F1F6F.7090905@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2014-09-09 at 18:40 +0300, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> Removed:
> -#include <linux/bio.h>
> -#include <linux/fs.h>
> 
> These two are included in linux/blkdev.h
> 
> -#include <linux/highmem.h>
I think this was present in the BRD code for flush_dcache_page(), but we
should probably be direct and include <asm/cacheflush.h> instead.

> -#include <linux/major.h>
Yep, not needed.

> -#include <linux/uaccess.h>
Yep, not needed.

> These 3 are not used anymore

I was under the impression that the philosophy regarding includes was that you
should directly include header files for the things that you use, and not rely
on headers that include other headers?  That way a change to a header file
where you remove an unneeded #include doesn't cascade into a bunch of changes
in .c files for now undefined symbols?

If this isn't the case, I think we can actually pare things down to just these
three include files:

#include <linux/blkdev.h>
#include <linux/hdreg.h>
#include <linux/module.h>


Here are the other include files that you left:
>  #include <linux/init.h>
Included from include/linux/printk.h:5:0,
	 from include/linux/kernel.h:13,
	 from include/linux/sched.h:17,
	 from include/linux/blkdev.h:4

>  #include <linux/moduleparam.h>
Included by <linux/module.h>

>  #include <linux/slab.h>
Included from include/linux/genhd.h:15:0,
	 from include/linux/blkdev.h:9


If we *should* directly include the header files for anything that we use, we
can probably pare it down to this:

#include <asm/cacheflush.h>
#include <linux/bio.h>
#include <linux/blkdev.h>
#include <linux/fs.h>
#include <linux/hdreg.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/slab.h>


> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/pmem.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
> index d63bc96..8b0b9b0 100644
> --- a/drivers/block/pmem.c
> +++ b/drivers/block/pmem.c
> @@ -16,17 +16,12 @@
>   * Copyright (C) 2007 Novell Inc.
>   */
>  
> -#include <linux/bio.h>
>  #include <linux/blkdev.h>
> -#include <linux/fs.h>
>  #include <linux/hdreg.h>
> -#include <linux/highmem.h>
>  #include <linux/init.h>
> -#include <linux/major.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/slab.h>
> -#include <linux/uaccess.h>
>  
>  #define SECTOR_SHIFT		9
>  #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)


