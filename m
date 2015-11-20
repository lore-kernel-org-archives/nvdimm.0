Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 20 Nov 2015 13:12:28 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] block: protect rw_page against device teardown
Message-ID: <20151120181228.GE18246@linux.intel.com>
References: <201511200825.O2a2KLtg%fengguang.wu@intel.com>
 <1447980689.20885.16.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1447980689.20885.16.camel@intel.com>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>


I'd prefer bdev_read_page() and bdev_write_page() to be a bit more consistent
(eg 'rc' vs 'result'), but:

Acked-by: Matthew Wilcox <willy@linux.intel.com>

On Fri, Nov 20, 2015 at 12:51:30AM +0000, Williams, Dan J wrote:
> On Fri, 2015-11-20 at 08:32 +0800, kbuild test robot wrote:
> > Hi Dan,
> > 
> > [auto build test ERROR on: block/for-next]
> > [also build test ERROR on: v4.4-rc1 next-20151119]
> 
> Thanks kbuild robot! ;-)
> 
> I indeed had rebased this in my tree in front of another patch that
> made blk_queue_enter() public. �Given that other patch is 4.5 material,
> move that declaration change into this patch:
> 
> 8<----
> Subject: block: protect rw_page against device teardown
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Fix use after free crashes like the following:
> 
> �general protection fault: 0000 [#1] SMP
> �Call Trace:
> � [<ffffffffa0050216>] ? pmem_do_bvec.isra.12+0xa6/0xf0 [nd_pmem]
> � [<ffffffffa0050ba2>] pmem_rw_page+0x42/0x80 [nd_pmem]
> � [<ffffffff8128fd90>] bdev_read_page+0x50/0x60
> � [<ffffffff812972f0>] do_mpage_readpage+0x510/0x770
> � [<ffffffff8128fd20>] ? I_BDEV+0x20/0x20
> � [<ffffffff811d86dc>] ? lru_cache_add+0x1c/0x50
> � [<ffffffff81297657>] mpage_readpages+0x107/0x170
> � [<ffffffff8128fd20>] ? I_BDEV+0x20/0x20
> � [<ffffffff8128fd20>] ? I_BDEV+0x20/0x20
> � [<ffffffff8129058d>] blkdev_readpages+0x1d/0x20
> � [<ffffffff811d615f>] __do_page_cache_readahead+0x28f/0x310
> � [<ffffffff811d6039>] ? __do_page_cache_readahead+0x169/0x310
> � [<ffffffff811c5abd>] ? pagecache_get_page+0x2d/0x1d0
> � [<ffffffff811c76f6>] filemap_fault+0x396/0x530
> � [<ffffffff811f816e>] __do_fault+0x4e/0xf0
> � [<ffffffff811fce7d>] handle_mm_fault+0x11bd/0x1b50
> 
> Cc: <stable@vger.kernel.org>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> �block/blk.h������������|����2 --
> �fs/block_dev.c���������|���18 ++++++++++++++++--
> �include/linux/blkdev.h |����2 ++
> �3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk.h b/block/blk.h
> index da722eb786df..c43926d3d74d 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -72,8 +72,6 @@ void blk_dequeue_request(struct request *rq);
> �void __blk_queue_free_tags(struct request_queue *q);
> �bool __blk_end_bidi_request(struct request *rq, int error,
> �			����unsigned int nr_bytes, unsigned int bidi_bytes);
> -int blk_queue_enter(struct request_queue *q, gfp_t gfp);
> -void blk_queue_exit(struct request_queue *q);
> �void blk_freeze_queue(struct request_queue *q);
> �
> �static inline void blk_queue_enter_live(struct request_queue *q)
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index bb0dfb1c7af1..cc0af12acf94 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -390,9 +390,17 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
> �			struct page *page)
> �{
> �	const struct block_device_operations *ops = bdev->bd_disk->fops;
> +	int rc = -EOPNOTSUPP;
> +
> �	if (!ops->rw_page || bdev_get_integrity(bdev))
> -		return -EOPNOTSUPP;
> -	return ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
> +		return rc;
> +
> +	rc = blk_queue_enter(bdev->bd_queue, GFP_KERNEL);
> +	if (rc)
> +		return rc;
> +	rc = ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
> +	blk_queue_exit(bdev->bd_queue);
> +	return rc;
> �}
> �EXPORT_SYMBOL_GPL(bdev_read_page);
> �
> @@ -421,14 +429,20 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
> �	int result;
> �	int rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
> �	const struct block_device_operations *ops = bdev->bd_disk->fops;
> +
> �	if (!ops->rw_page || bdev_get_integrity(bdev))
> �		return -EOPNOTSUPP;
> +	result = blk_queue_enter(bdev->bd_queue, GFP_KERNEL);
> +	if (result)
> +		return result;
> +
> �	set_page_writeback(page);
> �	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, rw);
> �	if (result)
> �		end_page_writeback(page);
> �	else
> �		unlock_page(page);
> +	blk_queue_exit(bdev->bd_queue);
> �	return result;
> �}
> �EXPORT_SYMBOL_GPL(bdev_write_page);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3fe27f8d91f0..c0d2b7927c1f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -794,6 +794,8 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
> �extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
> �			�struct scsi_ioctl_command __user *);
> �
> +extern int blk_queue_enter(struct request_queue *q, gfp_t gfp);
> +extern void blk_queue_exit(struct request_queue *q);
> �extern void blk_start_queue(struct request_queue *q);
> �extern void blk_stop_queue(struct request_queue *q);
> �extern void blk_sync_queue(struct request_queue *q);
