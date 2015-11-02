Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 15/15] pmem: blkdev_issue_flush support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:31:04 -0500
Message-ID: <20151102043104.6610.37259.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

For the normal (make_request) I/O path writes are always synchronously
flushed through to media.  However, when DAX is in use it is possible
that userspace leaves dirty data in the cache.  Ideally userspace uses
cache-writeback and persistent-commit instructions directly to flush
writes to media.  If instead userspace uses fsync()/msync() for
consistency guarantees then the driver needs to flush the cpu cache
manually.

Ideally an architecture would provide a single instruction to write-back
all dirty lines in the cache.  In the absence of that the driver resorts
to flushing line by line.

Introduce mmio_wb_range() as the non-invalidating version of
mmio_flush_range() and arrange for a small number of flusher threads to
parallelize the work.

The flush is a nop until a userspace mapping, BLKDAX_F_DIRTY request,
arrives and we reduce the amount of work per-flush by tracking open
active dax extents.  Finer granularity 'dax_active' tracking and
clearing mapped extents will be a subject of future experiments.  For
now this enables moderately cheap fsync/msync without per-fs and mm
enabling.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/cacheflush.h |    4 +
 block/blk-core.c                  |    1 
 block/blk.h                       |   11 ---
 drivers/nvdimm/pmem.c             |  139 +++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h            |   11 +++
 5 files changed, 154 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index e63aa38e85fb..3eafa8088489 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -89,6 +89,10 @@ int set_pages_rw(struct page *page, int numpages);
 
 void clflush_cache_range(void *addr, unsigned int size);
 
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+#define mmio_wb_range(addr, size) __arch_wb_cache_pmem(addr, size)
+#endif
+
 #define mmio_flush_range(addr, size) clflush_cache_range(addr, size)
 
 #ifdef CONFIG_DEBUG_RODATA
diff --git a/block/blk-core.c b/block/blk-core.c
index 5159946a2b41..43e402f9c06e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -661,6 +661,7 @@ void blk_queue_exit(struct request_queue *q)
 {
 	percpu_ref_put(&q->q_usage_counter);
 }
+EXPORT_SYMBOL(blk_queue_exit);
 
 static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 {
diff --git a/block/blk.h b/block/blk.h
index dc7d9411fa45..a83f14f07921 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -74,17 +74,6 @@ bool __blk_end_bidi_request(struct request *rq, int error,
 			    unsigned int nr_bytes, unsigned int bidi_bytes);
 void blk_freeze_queue(struct request_queue *q);
 
-static inline void blk_queue_enter_live(struct request_queue *q)
-{
-	/*
-	 * Given that running in generic_make_request() context
-	 * guarantees that a live reference against q_usage_counter has
-	 * been established, further references under that same context
-	 * need not check that the queue has been frozen (marked dead).
-	 */
-	percpu_ref_get(&q->q_usage_counter);
-}
-
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 #else
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3d83f3079602..6f39d0017399 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -33,6 +33,9 @@
 
 static ASYNC_DOMAIN_EXCLUSIVE(async_pmem);
 
+#define NUM_FLUSH_THREADS 4
+#define DAX_EXTENT_SHIFT 8
+#define NUM_DAX_EXTENTS (1ULL << DAX_EXTENT_SHIFT)
 struct pmem_device {
 	struct request_queue	*pmem_queue;
 	struct gendisk		*pmem_disk;
@@ -45,6 +48,10 @@ struct pmem_device {
 	unsigned long		pfn_flags;
 	void __pmem		*virt_addr;
 	size_t			size;
+	unsigned long		size_shift;
+	struct bio		*flush_bio;
+	spinlock_t		lock;
+	DECLARE_BITMAP(dax_active, NUM_DAX_EXTENTS);
 };
 
 static int pmem_major;
@@ -68,6 +75,105 @@ static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 	kunmap_atomic(mem);
 }
 
+struct pmem_flush_ctx {
+	struct pmem_device *pmem;
+	struct block_device *bdev;
+	int id;
+};
+
+static resource_size_t dax_extent_shift(struct pmem_device *pmem)
+{
+	return pmem->size_shift - DAX_EXTENT_SHIFT;
+}
+
+static resource_size_t dax_extent_size(struct pmem_device *pmem)
+{
+	return 1ULL << dax_extent_shift(pmem);
+}
+
+static void pmem_flush(void *data, async_cookie_t cookie)
+{
+	unsigned int i;
+	resource_size_t offset;
+	struct pmem_flush_ctx *ctx = data;
+	struct pmem_device *pmem = ctx->pmem;
+	struct device *dev = part_to_dev(ctx->bdev->bd_part);
+	unsigned long extent = dax_extent_size(pmem) / NUM_FLUSH_THREADS;
+
+	for_each_set_bit(i, pmem->dax_active, NUM_DAX_EXTENTS) {
+		unsigned long flush_len;
+		void *addr;
+
+		offset = dax_extent_size(pmem) * i + extent * ctx->id;
+		if (offset > pmem->size)
+			break;
+		flush_len = min_t(resource_size_t, extent, pmem->size - offset);
+		addr = (void __force *) pmem->virt_addr + offset;
+		dev_dbg(dev, "%s: %p %#lx\n", __func__, addr, flush_len);
+		while (flush_len) {
+			unsigned long len = min_t(unsigned long, flush_len, SZ_1M);
+
+#if defined(mmio_wb_range)
+			mmio_wb_range(addr, len);
+#elif defined(mmio_flush_range)
+			mmio_flush_range(addr, len);
+#else
+			dev_err_once(dev, "%s: failed, no flush method\n",
+					__func__);
+			return;
+#endif
+			flush_len -= len;
+			addr += len;
+			cond_resched();
+		}
+	}
+}
+
+static void __pmem_flush_request(void *data, async_cookie_t cookie)
+{
+	struct pmem_flush_ctx ctx[NUM_FLUSH_THREADS];
+	struct pmem_device *pmem = data;
+	struct bio *bio;
+	int i;
+
+	spin_lock(&pmem->lock);
+	bio = pmem->flush_bio;
+	pmem->flush_bio = bio->bi_next;
+	bio->bi_next = NULL;
+	spin_unlock(&pmem->lock);
+
+	for (i = 0; i < NUM_FLUSH_THREADS; i++) {
+		ctx[i].bdev = bio->bi_bdev;
+		ctx[i].pmem = pmem;
+		ctx[i].id = i;
+		cookie = async_schedule_domain(pmem_flush, &ctx[i], &async_pmem);
+	}
+	async_synchronize_cookie_domain(cookie, &async_pmem);
+	wmb_pmem();
+	bio_endio(bio);
+	blk_queue_exit(pmem->pmem_queue);
+}
+
+static void pmem_flush_request(struct pmem_device *pmem, struct bio *bio)
+{
+	int do_flush = 1;
+
+	spin_lock(&pmem->lock);
+	if (bitmap_weight(pmem->dax_active, NUM_DAX_EXTENTS) == 0) {
+		do_flush = 0;
+	} else {
+		bio->bi_next = pmem->flush_bio;
+		pmem->flush_bio = bio;
+	}
+	spin_unlock(&pmem->lock);
+
+	if (do_flush) {
+		blk_queue_enter_live(pmem->pmem_queue);
+		async_schedule(__pmem_flush_request, pmem);
+	} else
+		bio_endio(bio);
+}
+
 static void pmem_make_request(struct request_queue *q, struct bio *bio)
 {
 	bool do_acct;
@@ -87,7 +193,11 @@ static void pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (bio_data_dir(bio))
 		wmb_pmem();
 
-	bio_endio(bio);
+	/* we're always durable unless/until dax is activated */
+	if (bio->bi_rw & REQ_FLUSH)
+		pmem_flush_request(pmem, bio);
+	else
+		bio_endio(bio);
 }
 
 static int pmem_rw_page(struct block_device *bdev, sector_t sector,
@@ -112,6 +222,27 @@ static long pmem_direct_access(struct block_device *bdev,
 	dax->addr = pmem->virt_addr + offset;
 	dax->pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
+	if (dax->flags & BLKDAX_F_DIRTY) {
+		unsigned long start = offset >> dax_extent_shift(pmem);
+		unsigned long len;
+		size_t size;
+
+		size = min_t(size_t, pmem->size - offset, dax->size);
+		size = ALIGN(size, dax_extent_size(pmem));
+		len = max_t(unsigned long, 1, size >> dax_extent_shift(pmem));
+
+		/*
+		 * Any flush initiated after the lock is dropped observes new
+		 * dirty state
+		 */
+		spin_lock(&pmem->lock);
+		bitmap_set(pmem->dax_active, start, len);
+		spin_unlock(&pmem->lock);
+
+		dev_dbg(part_to_dev(bdev->bd_part), "dax active %lx +%lx\n",
+				start, len);
+	}
+
 	return pmem->size - offset;
 }
 
@@ -132,8 +263,12 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
+	spin_lock_init(&pmem->lock);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
+	pmem->size_shift = ilog2(pmem->size);
+	if (1ULL << pmem->size_shift < pmem->size)
+		pmem->size_shift++;
 	if (!arch_has_wmb_pmem())
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
@@ -217,6 +352,8 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);
+	/* every write via pmem_make_request has FUA semantics by default */
+	blk_queue_flush(pmem->pmem_queue, REQ_FLUSH | REQ_FUA);
 
 	disk = alloc_disk_node(0, nid);
 	if (!disk) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 663e9974820f..de8a3d58f071 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -793,6 +793,17 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
+static inline void blk_queue_enter_live(struct request_queue *q)
+{
+	/*
+	 * Given that running in generic_make_request() context
+	 * guarantees that a live reference against q_usage_counter has
+	 * been established, further references under that same context
+	 * need not check that the queue has been frozen (marked dead).
+	 */
+	percpu_ref_get(&q->q_usage_counter);
+}
+
 extern int blk_queue_enter(struct request_queue *q, gfp_t gfp);
 extern void blk_queue_exit(struct request_queue *q);
 extern void blk_start_queue(struct request_queue *q);

