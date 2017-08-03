Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo13.lge.com (LGEAMRELO13.lge.com [156.147.23.53])
 by ml01.01.org (Postfix) with ESMTP id 81AD121E1DAE3
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 17:11:05 -0700 (PDT)
Date: Thu, 3 Aug 2017 09:13:15 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Message-ID: <20170803001315.GF32020@bbox>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
 <20170728173143.GE15980@bombadil.infradead.org>
 <20170802221359.GA20666@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170802221359.GA20666@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Ross,

On Wed, Aug 02, 2017 at 04:13:59PM -0600, Ross Zwisler wrote:
> On Fri, Jul 28, 2017 at 10:31:43AM -0700, Matthew Wilcox wrote:
> > On Fri, Jul 28, 2017 at 10:56:01AM -0600, Ross Zwisler wrote:
> > > Dan Williams and Christoph Hellwig have recently expressed doubt about
> > > whether the rw_page() interface made sense for synchronous memory drivers
> > > [1][2].  It's unclear whether this interface has any performance benefit
> > > for these drivers, but as we continue to fix bugs it is clear that it does
> > > have a maintenance burden.  This series removes the rw_page()
> > > implementations in brd, pmem and btt to relieve this burden.
> > 
> > Why don't you measure whether it has performance benefits?  I don't
> > understand why zram would see performance benefits and not other drivers.
> > If it's going to be removed, then the whole interface should be removed,
> > not just have the implementations removed from some drivers.
> 
> Okay, I've run a bunch of performance tests with the PMEM and with BTT entry
> points for rw_pages() in a swap workload, and in all cases I do see an
> improvement over the code when rw_pages() is removed.  Here are the results
> from my random lab box:
> 
>   Average latency of swap_writepage()
> +------+------------+---------+-------------+
> |      | no rw_page | rw_page | Improvement |
> +-------------------------------------------+
> | PMEM |  5.0 us    |  4.7 us |     6%      |
> +-------------------------------------------+
> |  BTT |  6.8 us    |  6.1 us |    10%      |
> +------+------------+---------+-------------+
> 
>   Average latency of swap_readpage()
> +------+------------+---------+-------------+
> |      | no rw_page | rw_page | Improvement |
> +-------------------------------------------+
> | PMEM |  3.3 us    |  2.9 us |    12%      |
> +-------------------------------------------+
> |  BTT |  3.7 us    |  3.4 us |     8%      |
> +------+------------+---------+-------------+
> 
> The workload was pmbench, a memory benchmark, run on a system where I had
> severely restricted the amount of memory in the system with the 'mem' kernel
> command line parameter.  The benchmark was set up to test more memory than I
> allowed the OS to have so it spilled over into swap.
> 
> The PMEM or BTT device was set up as my swap device, and during the test I got
> a few hundred thousand samples of each of swap_writepage() and
> swap_writepage().  The PMEM/BTT device was just memory reserved with the
> memmap kernel command line parameter.
> 
> Thanks, Matthew, for asking for performance data.  It looks like removing this
> code would have been a mistake.

By suggestion of Christoph Hellwig, I made a quick patch which does IO without
dynamic bio allocation for swap IO. Actually, it's not formal patch to be
worth to send mainline yet but I believe it's enough to test the improvement.

Could you test patchset on pmem and btt without rw_page?

For working the patch, block drivers need to declare it's synchronous IO
device via BDI_CAP_SYNC but if it's hard, you can just make every swap IO
comes from (sis->flags & SWP_SYNC_IO) with removing condition check

if (!(sis->flags & SWP_SYNC_IO)) in swap_[read|write]page.

Patchset is based on 4.13-rc3.


diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 856d5dc02451..b1c5e9bf3ad5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -125,9 +125,9 @@ static inline bool is_partial_io(struct bio_vec *bvec)
 static void zram_revalidate_disk(struct zram *zram)
 {
 	revalidate_disk(zram->disk);
-	/* revalidate_disk reset the BDI_CAP_STABLE_WRITES so set again */
+	/* revalidate_disk reset the BDI capability so set again */
 	zram->disk->queue->backing_dev_info->capabilities |=
-		BDI_CAP_STABLE_WRITES;
+		(BDI_CAP_STABLE_WRITES|BDI_CAP_SYNC);
 }
 
 /*
@@ -1096,7 +1096,7 @@ static int zram_open(struct block_device *bdev, fmode_t mode)
 static const struct block_device_operations zram_devops = {
 	.open = zram_open,
 	.swap_slot_free_notify = zram_slot_free_notify,
-	.rw_page = zram_rw_page,
+	// .rw_page = zram_rw_page,
 	.owner = THIS_MODULE
 };
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 854e1bdd0b2a..05eee145d964 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -130,6 +130,7 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 #define BDI_CAP_STABLE_WRITES	0x00000008
 #define BDI_CAP_STRICTLIMIT	0x00000010
 #define BDI_CAP_CGROUP_WRITEBACK 0x00000020
+#define BDI_CAP_SYNC		0x00000040
 
 #define BDI_CAP_NO_ACCT_AND_WRITEBACK \
 	(BDI_CAP_NO_WRITEBACK | BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_ACCT_WB)
@@ -177,6 +178,11 @@ long wait_iff_congested(struct pglist_data *pgdat, int sync, long timeout);
 int pdflush_proc_obsolete(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
 
+static inline bool bdi_cap_sync_io_required(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_SYNC;
+}
+
 static inline bool bdi_cap_stable_pages_required(struct backing_dev_info *bdi)
 {
 	return bdi->capabilities & BDI_CAP_STABLE_WRITES;
diff --git a/include/linux/swap.h b/include/linux/swap.h
index d83d28e53e62..86457dbfd300 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -152,8 +152,9 @@ enum {
 	SWP_AREA_DISCARD = (1 << 8),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 10),	/* no overwrite PG_writeback pages */
+	SWP_SYNC_IO	= (1 << 11),
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 11),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 12),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff --git a/mm/page_io.c b/mm/page_io.c
index b6c4ac388209..2c85e5182364 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -263,7 +263,6 @@ static sector_t swap_page_sector(struct page *page)
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		bio_end_io_t end_write_func)
 {
-	struct bio *bio;
 	int ret;
 	struct swap_info_struct *sis = page_swap_info(page);
 
@@ -316,25 +315,44 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	}
 
 	ret = 0;
-	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
-	if (bio == NULL) {
-		set_page_dirty(page);
+	count_vm_event(PSWPOUT);
+
+	if (!(sis->flags & SWP_SYNC_IO)) {
+		struct bio *bio;
+
+		bio = get_swap_bio(GFP_NOIO, page, end_write_func);
+		if (bio == NULL) {
+			set_page_dirty(page);
+			unlock_page(page);
+			ret = -ENOMEM;
+			goto out;
+		}
+		bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
+		set_page_writeback(page);
 		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
+		submit_bio(bio);
+	} else {
+		struct bio bio;
+		struct bio_vec bvec;
+
+		bio_init(&bio, &bvec, 1);
+
+		bio.bi_iter.bi_sector = map_swap_page(page, &bio.bi_bdev);
+		bio.bi_iter.bi_sector <<= PAGE_SHIFT - 9;
+		bio.bi_end_io = end_write_func;
+		bio_add_page(&bio, page, PAGE_SIZE, 0);
+		bio.bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
+		bio_get(&bio);
+		set_page_writeback(page);
+		unlock_page(page);
+		submit_bio(&bio);
 	}
-	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
-	count_vm_event(PSWPOUT);
-	set_page_writeback(page);
-	unlock_page(page);
-	submit_bio(bio);
 out:
 	return ret;
 }
 
 int swap_readpage(struct page *page, bool do_poll)
 {
-	struct bio *bio;
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 	blk_qc_t qc;
@@ -371,29 +389,49 @@ int swap_readpage(struct page *page, bool do_poll)
 	}
 
 	ret = 0;
-	bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
-	if (bio == NULL) {
-		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
-	}
-	bdev = bio->bi_bdev;
-	bio->bi_private = current;
-	bio_set_op_attrs(bio, REQ_OP_READ, 0);
-	count_vm_event(PSWPIN);
-	bio_get(bio);
-	qc = submit_bio(bio);
-	while (do_poll) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!READ_ONCE(bio->bi_private))
-			break;
-
-		if (!blk_mq_poll(bdev_get_queue(bdev), qc))
-			break;
+	if (!(sis->flags & SWP_SYNC_IO)) {
+		struct bio *bio;
+
+		bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
+		if (bio == NULL) {
+			unlock_page(page);
+			ret = -ENOMEM;
+			goto out;
+		}
+		bdev = bio->bi_bdev;
+		bio->bi_private = current;
+		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio_get(bio);
+		qc = submit_bio(bio);
+		while (do_poll) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!READ_ONCE(bio->bi_private))
+				break;
+
+			if (!blk_mq_poll(bdev_get_queue(bdev), qc))
+				break;
+		}
+		__set_current_state(TASK_RUNNING);
+		bio_put(bio);
+	} else {
+		struct bio bio;
+		struct bio_vec bvec;
+
+		bio_init(&bio, &bvec, 1);
+
+		bio.bi_iter.bi_sector = map_swap_page(page, &bio.bi_bdev);
+		bio.bi_iter.bi_sector <<= PAGE_SHIFT - 9;
+		bio.bi_end_io = end_swap_bio_read;
+		bio_add_page(&bio, page, PAGE_SIZE, 0);
+		bio.bi_private = current;
+		BUG_ON(bio.bi_iter.bi_size != PAGE_SIZE);
+		bio_set_op_attrs(&bio, REQ_OP_READ, 0);
+		/* end_swap_bio_read calls bio_put unconditionally */
+		bio_get(&bio);
+		submit_bio(&bio);
 	}
-	__set_current_state(TASK_RUNNING);
-	bio_put(bio);
 
+	count_vm_event(PSWPIN);
 out:
 	return ret;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6ba4aab2db0b..855d50eeeaf9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2931,6 +2931,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (bdi_cap_stable_pages_required(inode_to_bdi(inode)))
 		p->flags |= SWP_STABLE_WRITES;
 
+	if (bdi_cap_sync_io_required(inode_to_bdi(inode)))
+		p->flags |= SWP_SYNC_IO;
+
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		int cpu;
 		unsigned long ci, nr_cluster;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
