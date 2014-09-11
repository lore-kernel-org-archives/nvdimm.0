Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1410460745.2424.1.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 2/9] SQUASHME: pmem: Request from fdisk 4k alignment
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 11 Sep 2014 12:39:05 -0600
In-Reply-To: <540F1FBB.2000706@plexistor.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	 <540F1EC6.4000504@plexistor.com> <540F1FBB.2000706@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2014-09-09 at 18:41 +0300, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> Because of the direct_access() API which returns a PFN. partitions
> better start on 4K boundary, else offset ZERO of a partition will
> not be aligned and blk_direct_access() will fail the call.
> 
> By setting blk_queue_physical_block_size(PAGE_SIZE) we can communicate
> this to fdisk and friends.
> Note that blk_queue_physical_block_size() also trashes io_min, but
> we can leave this one to be 512.
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/pmem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
> index 8b0b9b0..499536c 100644
> --- a/drivers/block/pmem.c
> +++ b/drivers/block/pmem.c
> @@ -258,6 +258,12 @@ static struct pmem_device *pmem_alloc(int i)
>  	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
>  	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
>  
> +	/* This is so fdisk will align partitions on 4k, because of
> +	 * direct_access API needing 4k alignment, returning a PFN
> +	 */
> +	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
> +	pmem->pmem_queue->limits.io_min = 512; /* Don't use the accessor */
> +
>  	disk = pmem->pmem_disk = alloc_disk(0);
>  	if (!disk)
>  		goto out_free_queue;

I've tested this a bit using the version of fdisk found in Fedora (fdisk from
util-linux 2.24.2), which I believe is what you are using.

So far I can't come up with a case where fdisk does the wrong thing without
this patch and the right thing with it.  Can you please provide me more
details on the use case that you are trying to fix?

- Ross


