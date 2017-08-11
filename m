Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo13.lge.com (LGEAMRELO13.lge.com [156.147.23.53])
 by ml01.01.org (Postfix) with ESMTP id 72D4521D49104
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 22:15:29 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v2 5/7] mm:swap: use on-stack-bio for BDI_CAP_SYNCHRONOUS
 device
Date: Fri, 11 Aug 2017 14:17:25 +0900
Message-Id: <1502428647-28928-6-git-send-email-minchan@kernel.org>
In-Reply-To: <1502428647-28928-1-git-send-email-minchan@kernel.org>
References: <1502428647-28928-1-git-send-email-minchan@kernel.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

There is no need to use dynamic bio allocation for BDI_CAP_SYNCHRONOUS
devices. They can live with on-stack-bio without concern about
waiting bio allocation from mempool under heavy memory pressure.

It would be much better for swap devices because the bio mempool
for swap IO have been used with fs. It means super-fast swap
IO like zram don't need to depends on slow eMMC read/write
completion.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/swap.h |  3 ++-
 mm/page_io.c         | 70 +++++++++++++++++++++++++++++++++++++---------------
 mm/swapfile.c        |  3 +++
 3 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ae3da979a7b7..6ed9b6423f7d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -152,8 +152,9 @@ enum {
 	SWP_AREA_DISCARD = (1 << 8),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 10),	/* no overwrite PG_writeback pages */
+	SWP_SYNC_IO	= (1<<11),	/* synchronous IO is efficient */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 11),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 12),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff --git a/mm/page_io.c b/mm/page_io.c
index 3502a97f7c48..64330c751548 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -119,8 +119,8 @@ static void swap_slot_free_notify(struct page *page)
 
 static void end_swap_bio_read(struct bio *bio)
 {
-	struct page *page = bio->bi_io_vec[0].bv_page;
 	struct task_struct *waiter = bio->bi_private;
+	struct page *page = bio->bi_io_vec[0].bv_page;
 
 	if (bio->bi_status) {
 		SetPageError(page);
@@ -275,9 +275,12 @@ static inline void count_swpout_vm_event(struct page *page)
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct bio *bio;
 	int ret;
 	struct swap_info_struct *sis = page_swap_info(page);
+	struct bio *bio;
+	/* on-stack-bio */
+	struct bio sbio;
+	struct bio_vec sbvec;
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	if (sis->flags & SWP_FILE) {
@@ -328,29 +331,45 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc)
 	}
 
 	ret = 0;
-	bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
-	if (bio == NULL) {
-		set_page_dirty(page);
-		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
+	if (!(sis->flags & SWP_SYNC_IO)) {
+
+		bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
+		if (bio == NULL) {
+			set_page_dirty(page);
+			unlock_page(page);
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		bio = &sbio;
+		bio_get(&bio);
+
+		bio_init(&sbio, &sbvec, 1);
+		sbio.bi_bdev = sis->bdev;
+		sbio.bi_iter.bi_sector = swap_page_sector(page);
+		sbio.bi_end_io = end_swap_bio_write;
+		bio_add_page(&sbio, page, PAGE_SIZE, 0);
 	}
-	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
-	count_swpout_vm_event(page);
+
+	bio_set_op_attrs(bio, REQ_OP_WRITE, wbc_to_write_flags(wbc));
 	set_page_writeback(page);
 	unlock_page(page);
 	submit_bio(bio);
+	count_swpout_vm_event(page);
 out:
 	return ret;
 }
 
 int swap_readpage(struct page *page, bool do_poll)
 {
-	struct bio *bio;
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 	blk_qc_t qc;
 	struct block_device *bdev;
+	struct bio *bio;
+	/* on-stack-bio */
+	struct bio sbio;
+	struct bio_vec sbvec;
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
@@ -383,21 +402,33 @@ int swap_readpage(struct page *page, bool do_poll)
 	}
 
 	ret = 0;
-	bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
-	if (bio == NULL) {
-		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
+	count_vm_event(PSWPIN);
+	if (!(sis->flags & SWP_SYNC_IO)) {
+		bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
+		if (bio == NULL) {
+			unlock_page(page);
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		bio = &sbio;
+		bio_get(bio);
+
+		bio_init(&sbio, &sbvec, 1);
+		sbio.bi_bdev = sis->bdev;
+		sbio.bi_iter.bi_sector = swap_page_sector(page);
+		bio->bi_end_io = end_swap_bio_read;
+		bio_add_page(&sbio, page, PAGE_SIZE, 0);
 	}
 	bdev = bio->bi_bdev;
 	/*
-	 * Keep this task valid during swap readpage because the oom killer may
-	 * attempt to access it in the page fault retry time check.
+	 * Keep this task valid during swap readpage because
+	 * the oom killer may attempt to access it
+	 * in the page fault retry time check.
 	 */
 	get_task_struct(current);
 	bio->bi_private = current;
 	bio_set_op_attrs(bio, REQ_OP_READ, 0);
-	count_vm_event(PSWPIN);
 	bio_get(bio);
 	qc = submit_bio(bio);
 	while (do_poll) {
@@ -410,7 +441,6 @@ int swap_readpage(struct page *page, bool do_poll)
 	}
 	__set_current_state(TASK_RUNNING);
 	bio_put(bio);
-
 out:
 	return ret;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 42eff9e4e972..e916b325b0b7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3113,6 +3113,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (bdi_cap_stable_pages_required(inode_to_bdi(inode)))
 		p->flags |= SWP_STABLE_WRITES;
 
+	if (bdi_cap_synchronous_io(inode_to_bdi(inode)))
+		p->flags |= SWP_SYNC_IO;
+
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		int cpu;
 		unsigned long ci, nr_cluster;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
