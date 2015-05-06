Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 10/10] block: base support for pfn i/o
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 May 2015 16:05:49 -0400
Message-ID: <20150506200549.40425.33696.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, riel@redhat.com, linux-nvdimm@lists.01.org, mingo@kernel.org, linux-fsdevel@vger.kernel.org, mgorman@suse.de, Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Allow block device drivers to opt-in to receiving bio(s) where the
bio_vec(s) point to memory that is not backed by struct page entries.
When a driver opts in it asserts that it will use the __pfn_t versions of the
dma_map/kmap/scatterlist apis in its bio submission path.

Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/bio.c               |   48 ++++++++++++++++++++++++++++++++++++++-------
 block/blk-core.c          |    9 ++++++++
 include/linux/blk_types.h |    1 +
 include/linux/blkdev.h    |    2 ++
 4 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7100fd6d5898..9c506dd6a093 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -567,6 +567,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
+	bio->bi_flags |= bio_src->bi_flags & (1 << BIO_PFN);
 }
 EXPORT_SYMBOL(__bio_clone_fast);
 
@@ -658,6 +659,8 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 		goto integrity_clone;
 	}
 
+	bio->bi_flags |= bio_src->bi_flags & (1 << BIO_PFN);
+
 	bio_for_each_segment(bv, bio_src, iter)
 		bio->bi_io_vec[bio->bi_vcnt++] = bv;
 
@@ -699,9 +702,9 @@ int bio_get_nr_vecs(struct block_device *bdev)
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 
-static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset,
-			  unsigned int max_sectors)
+static int __bio_add_pfn(struct request_queue *q, struct bio *bio,
+		__pfn_t pfn, unsigned int len, unsigned int offset,
+		unsigned int max_sectors)
 {
 	int retried_segments = 0;
 	struct bio_vec *bvec;
@@ -723,7 +726,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bvec_page(prev) &&
+		if (pfn.pfn == prev->bv_pfn.pfn &&
 		    offset == prev->bv_offset + prev->bv_len) {
 			unsigned int prev_bv_len = prev->bv_len;
 			prev->bv_len += len;
@@ -768,7 +771,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	 * cannot add the page
 	 */
 	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec_set_page(bvec, page);
+	bvec->bv_pfn = pfn;
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
@@ -818,7 +821,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	return len;
 
  failed:
-	bvec_set_page(bvec, NULL);
+	bvec->bv_pfn.pfn = 0;
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
@@ -845,7 +848,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
 		    unsigned int len, unsigned int offset)
 {
-	return __bio_add_page(q, bio, page, len, offset,
+	return __bio_add_pfn(q, bio, page_to_pfn_t(page), len, offset,
 			      queue_max_hw_sectors(q));
 }
 EXPORT_SYMBOL(bio_add_pc_page);
@@ -872,10 +875,39 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 	if ((max_sectors < (len >> 9)) && !bio->bi_iter.bi_size)
 		max_sectors = len >> 9;
 
-	return __bio_add_page(q, bio, page, len, offset, max_sectors);
+	return __bio_add_pfn(q, bio, page_to_pfn_t(page), len, offset,
+			max_sectors);
 }
 EXPORT_SYMBOL(bio_add_page);
 
+/**
+ *	bio_add_pfn -	attempt to add pfn to bio
+ *	@bio: destination bio
+ *	@pfn: pfn to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Identical to bio_add_page() except this variant flags the bio as
+ *	not have struct page backing.  A given request_queue must assert
+ *	that it is prepared to handle this constraint before bio(s)
+ *	flagged in the manner can be passed.
+ */
+int bio_add_pfn(struct bio *bio, __pfn_t pfn, unsigned int len,
+		unsigned int offset)
+{
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	unsigned int max_sectors;
+
+	if (!blk_queue_pfn(q))
+		return 0;
+	set_bit(BIO_PFN, &bio->bi_flags);
+	max_sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector);
+	if ((max_sectors < (len >> 9)) && !bio->bi_iter.bi_size)
+		max_sectors = len >> 9;
+
+	return __bio_add_pfn(q, bio, pfn, len, offset, max_sectors);
+}
+
 struct submit_bio_ret {
 	struct completion event;
 	int error;
diff --git a/block/blk-core.c b/block/blk-core.c
index 94d2c6ccf801..4eefff363986 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1856,6 +1856,15 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	if (bio_flagged(bio, BIO_PFN)) {
+		if (IS_ENABLED(CONFIG_PMEM_IO) && blk_queue_pfn(q))
+			/* pass */;
+		else {
+			err = -EOPNOTSUPP;
+			goto end_io;
+		}
+	}
+
 	/*
 	 * Various block parts want %current->io_context and lazy ioc
 	 * allocation ends up trading a lot of pain for a small amount of
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2a15c4943db6..5716c7edc4c4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -139,6 +139,7 @@ struct bio {
 #define BIO_NULL_MAPPED 8	/* contains invalid user pages */
 #define BIO_QUIET	9	/* Make BIO Quiet */
 #define BIO_SNAP_STABLE	10	/* bio data must be snapshotted during write */
+#define BIO_PFN		11	/* bio_vec references memory without struct page */
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2692d3936f5f..e6adcfeb72db 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -513,6 +513,7 @@ struct request_queue {
 #define QUEUE_FLAG_INIT_DONE   20	/* queue is initialized */
 #define QUEUE_FLAG_NO_SG_MERGE 21	/* don't attempt to merge SG segments*/
 #define QUEUE_FLAG_SG_GAPS     22	/* queue doesn't support SG gaps */
+#define QUEUE_FLAG_PFN         23	/* queue supports pfn-only bio_vec(s) */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -594,6 +595,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
+#define blk_queue_pfn(q)	test_bit(QUEUE_FLAG_PFN, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_stackable(q)	\

