Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [RFC PATCH 1/7] block: add helpers for accessing a bio_vec page
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Mar 2015 16:25:32 -0400
Message-ID: <20150316202532.33102.65362.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, riel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In prepartion for converting struct bio_vec to carry a pfn instead of a
struct page.  This change is prompted by the desire to add in-kernel DMA
support for persistent memory which lacks struct page coverage.

Generated with the following semantic patch:

// bv_page.cocci: convert usage of ->bv_page to use set/get helpers
// usage: make coccicheck COCCI=bv_page.cocci MODE=patch

virtual patch
virtual report
virtual org

@@
struct bio_vec bvec;
expression E;
type T;
@@

- bvec.bv_page = (T)E
+ bvec_set_page(&bvec, E)

@@
struct bio_vec *bvec;
expression E;
type T;
@@

- bvec->bv_page = (T)E
+ bvec_set_page(bvec, E)

@@
struct bio_vec bvec;
type T;
@@

- (T)bvec.bv_page
+ bvec_page(&bvec)

@@
struct bio_vec *bvec;
type T;
@@

- (T)bvec->bv_page
+ bvec_page(bvec)

@@
struct bio *bio;
expression E;
expression F;
type T;
@@

- bio->bi_io_vec[F].bv_page = (T)E
+ bvec_set_page(&bio->bi_io_vec[F], E)

@@
struct bio *bio;
expression E;
type T;
@@

- bio->bi_io_vec->bv_page = (T)E
+ bvec_set_page(bio->bi_io_vec, E)

@@
struct cached_dev *dc;
expression E;
type T;
@@

- dc->sb_bio.bi_io_vec->bv_page = (T)E
+ bvec_set_page(dc->sb_bio.bi_io_vec, E)

@@
struct cache *ca;
expression E;
expression F;
type T;
@@

- ca->sb_bio.bi_io_vec[F].bv_page = (T)E
+ bvec_set_page(&ca->sb_bio.bi_io_vec[F], E)

@@
struct cache *ca;
expression F;
@@

- ca->sb_bio.bi_io_vec[F].bv_page
+ bvec_page(&ca->sb_bio.bi_io_vec[F])

@@
struct cache *ca;
expression E;
expression F;
type T;
@@

- ca->sb_bio.bi_inline_vecs[F].bv_page = (T)E
+ bvec_set_page(&ca->sb_bio.bi_inline_vecs[F], E)

@@
struct cache *ca;
expression F;
@@

- ca->sb_bio.bi_inline_vecs[F].bv_page
+ bvec_page(&ca->sb_bio.bi_inline_vecs[F])


@@
struct cache *ca;
expression E;
type T;
@@

- ca->sb_bio.bi_io_vec->bv_page = (T)E
+ bvec_set_page(ca->sb_bio.bi_io_vec, E)

@@
struct bio *bio;
expression F;
@@

- bio->bi_io_vec[F].bv_page
+ bvec_page(&bio->bi_io_vec[F])

@@
struct bio bio;
expression F;
@@

- bio.bi_io_vec[F].bv_page
+ bvec_page(&bio.bi_io_vec[F])

@@
struct bio *bio;
@@

- bio->bi_io_vec->bv_page
+ bvec_page(bio->bi_io_vec)

@@
struct cached_dev *dc;
@@

- dc->sb_bio.bi_io_vec->bv_page
+ bvec_page(&dc->sb_bio->bi_io_vec)


@@
struct bio bio;
@@

- bio.bi_io_vec->bv_page
+ bvec_page(bio.bi_io_vec)

@@
struct bio_integrity_payload *bip;
expression E;
type T;
@@

- bip->bip_vec->bv_page = (T)E
+ bvec_set_page(bip->bip_vec, E)

@@
struct bio_integrity_payload *bip;
@@

- bip->bip_vec->bv_page
+ bvec_page(bip->bip_vec)

@@
struct bio_integrity_payload bip;
@@

- bip.bip_vec->bv_page
+ bvec_page(bip.bip_vec)

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c               |    2 +
 block/bio-integrity.c                       |    8 ++--
 block/bio.c                                 |   40 +++++++++++-----------
 block/blk-core.c                            |    4 +-
 block/blk-integrity.c                       |    3 +-
 block/blk-lib.c                             |    2 +
 block/blk-merge.c                           |    7 ++--
 block/bounce.c                              |   24 ++++++-------
 drivers/block/aoe/aoecmd.c                  |    8 ++--
 drivers/block/brd.c                         |    2 +
 drivers/block/drbd/drbd_bitmap.c            |    5 ++-
 drivers/block/drbd/drbd_main.c              |    4 +-
 drivers/block/drbd/drbd_receiver.c          |    4 +-
 drivers/block/drbd/drbd_worker.c            |    3 +-
 drivers/block/floppy.c                      |    6 ++-
 drivers/block/loop.c                        |    8 ++--
 drivers/block/nbd.c                         |    8 ++--
 drivers/block/nvme-core.c                   |    2 +
 drivers/block/pktcdvd.c                     |   11 +++---
 drivers/block/ps3disk.c                     |    2 +
 drivers/block/ps3vram.c                     |    2 +
 drivers/block/rbd.c                         |    2 +
 drivers/block/rsxx/dma.c                    |    3 +-
 drivers/block/umem.c                        |    2 +
 drivers/block/zram/zram_drv.c               |   10 +++--
 drivers/md/bcache/btree.c                   |    2 +
 drivers/md/bcache/debug.c                   |    6 ++-
 drivers/md/bcache/movinggc.c                |    2 +
 drivers/md/bcache/request.c                 |    6 ++-
 drivers/md/bcache/super.c                   |   10 +++--
 drivers/md/bcache/util.c                    |    5 +--
 drivers/md/bcache/writeback.c               |    2 +
 drivers/md/dm-crypt.c                       |   12 +++---
 drivers/md/dm-io.c                          |    2 +
 drivers/md/dm-verity.c                      |    2 +
 drivers/md/raid1.c                          |   50 ++++++++++++++-------------
 drivers/md/raid10.c                         |   38 ++++++++++-----------
 drivers/md/raid5.c                          |    6 ++-
 drivers/s390/block/dasd_diag.c              |    2 +
 drivers/s390/block/dasd_eckd.c              |   14 ++++----
 drivers/s390/block/dasd_fba.c               |    6 ++-
 drivers/s390/block/dcssblk.c                |    2 +
 drivers/s390/block/scm_blk.c                |    2 +
 drivers/s390/block/scm_blk_cluster.c        |    2 +
 drivers/s390/block/xpram.c                  |    2 +
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |    6 ++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |    6 ++-
 drivers/scsi/sd_dif.c                       |    4 +-
 drivers/staging/lustre/lustre/llite/lloop.c |    2 +
 drivers/xen/biomerge.c                      |    4 +-
 fs/btrfs/check-integrity.c                  |    6 ++-
 fs/btrfs/compression.c                      |   12 +++---
 fs/btrfs/disk-io.c                          |    4 +-
 fs/btrfs/extent_io.c                        |    8 ++--
 fs/btrfs/file-item.c                        |    8 ++--
 fs/btrfs/inode.c                            |   18 ++++++----
 fs/btrfs/raid56.c                           |    4 +-
 fs/btrfs/volumes.c                          |    2 +
 fs/buffer.c                                 |    4 +-
 fs/direct-io.c                              |    2 +
 fs/exofs/ore.c                              |    4 +-
 fs/exofs/ore_raid.c                         |    2 +
 fs/ext4/page-io.c                           |    2 +
 fs/f2fs/data.c                              |    4 +-
 fs/f2fs/segment.c                           |    2 +
 fs/gfs2/lops.c                              |    4 +-
 fs/jfs/jfs_logmgr.c                         |    4 +-
 fs/logfs/dev_bdev.c                         |   10 +++--
 fs/mpage.c                                  |    2 +
 fs/splice.c                                 |    2 +
 include/linux/bio.h                         |    4 +-
 include/linux/blk_types.h                   |   10 +++++
 kernel/power/block_io.c                     |    2 +
 mm/page_io.c                                |    6 ++-
 net/ceph/messenger.c                        |    2 +
 75 files changed, 258 insertions(+), 237 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ee90db17b097..9bb5da7f2c0c 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -123,7 +123,7 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 			return;
 		}
 
-		user_mem = page_address(vec.bv_page) + vec.bv_offset;
+		user_mem = page_address(bvec_page(&vec)) + vec.bv_offset;
 		if (bio_data_dir(bio) == READ)
 			memcpy(user_mem, (void *) phys_mem, vec.bv_len);
 		else
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5cbd5d9ea61d..3add34cba048 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -101,7 +101,7 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_set *bs = bio->bi_pool;
 
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
-		kfree(page_address(bip->bip_vec->bv_page) +
+		kfree(page_address(bvec_page(bip->bip_vec)) +
 		      bip->bip_vec->bv_offset);
 
 	if (bs) {
@@ -140,7 +140,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 
 	iv = bip->bip_vec + bip->bip_vcnt;
 
-	iv->bv_page = page;
+	bvec_set_page(iv, page);
 	iv->bv_len = len;
 	iv->bv_offset = offset;
 	bip->bip_vcnt++;
@@ -220,7 +220,7 @@ static int bio_integrity_process(struct bio *bio,
 	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	unsigned int ret = 0;
-	void *prot_buf = page_address(bip->bip_vec->bv_page) +
+	void *prot_buf = page_address(bvec_page(bip->bip_vec)) +
 		bip->bip_vec->bv_offset;
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
@@ -229,7 +229,7 @@ static int bio_integrity_process(struct bio *bio,
 	iter.prot_buf = prot_buf;
 
 	bio_for_each_segment(bv, bio, bviter) {
-		void *kaddr = kmap_atomic(bv.bv_page);
+		void *kaddr = kmap_atomic(bvec_page(&bv));
 
 		iter.data_buf = kaddr + bv.bv_offset;
 		iter.data_size = bv.bv_len;
diff --git a/block/bio.c b/block/bio.c
index f66a4eae16ee..7100fd6d5898 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -508,7 +508,7 @@ void zero_fill_bio(struct bio *bio)
 	bio_for_each_segment(bv, bio, iter) {
 		char *data = bvec_kmap_irq(&bv, &flags);
 		memset(data, 0, bv.bv_len);
-		flush_dcache_page(bv.bv_page);
+		flush_dcache_page(bvec_page(&bv));
 		bvec_kunmap_irq(data, &flags);
 	}
 }
@@ -723,7 +723,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == prev->bv_page &&
+		if (page == bvec_page(prev) &&
 		    offset == prev->bv_offset + prev->bv_len) {
 			unsigned int prev_bv_len = prev->bv_len;
 			prev->bv_len += len;
@@ -768,7 +768,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	 * cannot add the page
 	 */
 	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
+	bvec_set_page(bvec, page);
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
@@ -818,7 +818,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	return len;
 
  failed:
-	bvec->bv_page = NULL;
+	bvec_set_page(bvec, NULL);
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
@@ -948,10 +948,10 @@ int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
 	struct bio_vec *bv;
 
 	bio_for_each_segment_all(bv, bio, i) {
-		bv->bv_page = alloc_page(gfp_mask);
-		if (!bv->bv_page) {
+		bvec_set_page(bv, alloc_page(gfp_mask));
+		if (!bvec_page(bv)) {
 			while (--bv >= bio->bi_io_vec)
-				__free_page(bv->bv_page);
+				__free_page(bvec_page(bv));
 			return -ENOMEM;
 		}
 	}
@@ -1004,8 +1004,8 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 
 		bytes = min(src_bv.bv_len, dst_bv.bv_len);
 
-		src_p = kmap_atomic(src_bv.bv_page);
-		dst_p = kmap_atomic(dst_bv.bv_page);
+		src_p = kmap_atomic(bvec_page(&src_bv));
+		dst_p = kmap_atomic(bvec_page(&dst_bv));
 
 		memcpy(dst_p + dst_bv.bv_offset,
 		       src_p + src_bv.bv_offset,
@@ -1052,7 +1052,7 @@ static int bio_copy_from_iter(struct bio *bio, struct iov_iter iter)
 	bio_for_each_segment_all(bvec, bio, i) {
 		ssize_t ret;
 
-		ret = copy_page_from_iter(bvec->bv_page,
+		ret = copy_page_from_iter(bvec_page(bvec),
 					  bvec->bv_offset,
 					  bvec->bv_len,
 					  &iter);
@@ -1083,7 +1083,7 @@ static int bio_copy_to_iter(struct bio *bio, struct iov_iter iter)
 	bio_for_each_segment_all(bvec, bio, i) {
 		ssize_t ret;
 
-		ret = copy_page_to_iter(bvec->bv_page,
+		ret = copy_page_to_iter(bvec_page(bvec),
 					bvec->bv_offset,
 					bvec->bv_len,
 					&iter);
@@ -1104,7 +1104,7 @@ static void bio_free_pages(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i)
-		__free_page(bvec->bv_page);
+		__free_page(bvec_page(bvec));
 }
 
 /**
@@ -1406,9 +1406,9 @@ static void __bio_unmap_user(struct bio *bio)
 	 */
 	bio_for_each_segment_all(bvec, bio, i) {
 		if (bio_data_dir(bio) == READ)
-			set_page_dirty_lock(bvec->bv_page);
+			set_page_dirty_lock(bvec_page(bvec));
 
-		page_cache_release(bvec->bv_page);
+		page_cache_release(bvec_page(bvec));
 	}
 
 	bio_put(bio);
@@ -1499,7 +1499,7 @@ static void bio_copy_kern_endio_read(struct bio *bio, int err)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		memcpy(p, page_address(bvec->bv_page), bvec->bv_len);
+		memcpy(p, page_address(bvec_page(bvec)), bvec->bv_len);
 		p += bvec->bv_len;
 	}
 
@@ -1611,7 +1611,7 @@ void bio_set_pages_dirty(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (page && !PageCompound(page))
 			set_page_dirty_lock(page);
@@ -1624,7 +1624,7 @@ static void bio_release_pages(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (page)
 			put_page(page);
@@ -1678,11 +1678,11 @@ void bio_check_pages_dirty(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (PageDirty(page) || PageCompound(page)) {
 			page_cache_release(page);
-			bvec->bv_page = NULL;
+			bvec_set_page(bvec, NULL);
 		} else {
 			nr_clean_pages++;
 		}
@@ -1736,7 +1736,7 @@ void bio_flush_dcache_pages(struct bio *bi)
 	struct bvec_iter iter;
 
 	bio_for_each_segment(bvec, bi, iter)
-		flush_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec_page(&bvec));
 }
 EXPORT_SYMBOL(bio_flush_dcache_pages);
 #endif
diff --git a/block/blk-core.c b/block/blk-core.c
index 794c3e7f01cf..7830ce00cbf5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1429,7 +1429,7 @@ void blk_add_request_payload(struct request *rq, struct page *page,
 {
 	struct bio *bio = rq->bio;
 
-	bio->bi_io_vec->bv_page = page;
+	bvec_set_page(bio->bi_io_vec, page);
 	bio->bi_io_vec->bv_offset = 0;
 	bio->bi_io_vec->bv_len = len;
 
@@ -2855,7 +2855,7 @@ void rq_flush_dcache_pages(struct request *rq)
 	struct bio_vec bvec;
 
 	rq_for_each_segment(bvec, rq, iter)
-		flush_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec_page(&bvec));
 }
 EXPORT_SYMBOL_GPL(rq_flush_dcache_pages);
 #endif
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 79ffb4855af0..6c8b1d63e90b 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -117,7 +117,8 @@ new_segment:
 				sg = sg_next(sg);
 			}
 
-			sg_set_page(sg, iv.bv_page, iv.bv_len, iv.bv_offset);
+			sg_set_page(sg, bvec_page(&iv), iv.bv_len,
+				    iv.bv_offset);
 			segments++;
 		}
 
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 7688ee3f5d72..7931a09f86d6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -187,7 +187,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		bio->bi_bdev = bdev;
 		bio->bi_private = &bb;
 		bio->bi_vcnt = 1;
-		bio->bi_io_vec->bv_page = page;
+		bvec_set_page(bio->bi_io_vec, page);
 		bio->bi_io_vec->bv_offset = 0;
 		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index fc1ff3b1ea1f..39bd9925c057 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -51,7 +51,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 			 * never considered part of another segment, since
 			 * that might change with the bounce page.
 			 */
-			high = page_to_pfn(bv.bv_page) > queue_bounce_pfn(q);
+			high = page_to_pfn(bvec_page(&bv)) > queue_bounce_pfn(q);
 			if (!high && !highprv && cluster) {
 				if (seg_size + bv.bv_len
 				    > queue_max_segment_size(q))
@@ -192,7 +192,7 @@ new_segment:
 			*sg = sg_next(*sg);
 		}
 
-		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
+		sg_set_page(*sg, bvec_page(bvec), nbytes, bvec->bv_offset);
 		(*nsegs)++;
 	}
 	*bvprv = *bvec;
@@ -228,7 +228,8 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 single_segment:
 		*sg = sglist;
 		bvec = bio_iovec(bio);
-		sg_set_page(*sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
+		sg_set_page(*sg, bvec_page(&bvec), bvec.bv_len,
+			    bvec.bv_offset);
 		return 1;
 	}
 
diff --git a/block/bounce.c b/block/bounce.c
index ab21ba203d5c..0390e44d6e1b 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -55,7 +55,7 @@ static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 	unsigned char *vto;
 
 	local_irq_save(flags);
-	vto = kmap_atomic(to->bv_page);
+	vto = kmap_atomic(bvec_page(to));
 	memcpy(vto + to->bv_offset, vfrom, to->bv_len);
 	kunmap_atomic(vto);
 	local_irq_restore(flags);
@@ -105,17 +105,17 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 	struct bvec_iter iter;
 
 	bio_for_each_segment(tovec, to, iter) {
-		if (tovec.bv_page != fromvec->bv_page) {
+		if (bvec_page(&tovec) != bvec_page(fromvec)) {
 			/*
 			 * fromvec->bv_offset and fromvec->bv_len might have
 			 * been modified by the block layer, so use the original
 			 * copy, bounce_copy_vec already uses tovec->bv_len
 			 */
-			vfrom = page_address(fromvec->bv_page) +
+			vfrom = page_address(bvec_page(fromvec)) +
 				tovec.bv_offset;
 
 			bounce_copy_vec(&tovec, vfrom);
-			flush_dcache_page(tovec.bv_page);
+			flush_dcache_page(bvec_page(&tovec));
 		}
 
 		fromvec++;
@@ -136,11 +136,11 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 	 */
 	bio_for_each_segment_all(bvec, bio, i) {
 		org_vec = bio_orig->bi_io_vec + i;
-		if (bvec->bv_page == org_vec->bv_page)
+		if (bvec_page(bvec) == bvec_page(org_vec))
 			continue;
 
-		dec_zone_page_state(bvec->bv_page, NR_BOUNCE);
-		mempool_free(bvec->bv_page, pool);
+		dec_zone_page_state(bvec_page(bvec), NR_BOUNCE);
+		mempool_free(bvec_page(bvec), pool);
 	}
 
 	bio_endio(bio_orig, err);
@@ -208,7 +208,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	if (force)
 		goto bounce;
 	bio_for_each_segment(from, *bio_orig, iter)
-		if (page_to_pfn(from.bv_page) > queue_bounce_pfn(q))
+		if (page_to_pfn(bvec_page(&from)) > queue_bounce_pfn(q))
 			goto bounce;
 
 	return;
@@ -216,20 +216,20 @@ bounce:
 	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
 
 	bio_for_each_segment_all(to, bio, i) {
-		struct page *page = to->bv_page;
+		struct page *page = bvec_page(to);
 
 		if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
 			continue;
 
-		inc_zone_page_state(to->bv_page, NR_BOUNCE);
-		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
+		inc_zone_page_state(bvec_page(to), NR_BOUNCE);
+		bvec_set_page(to, mempool_alloc(pool, q->bounce_gfp));
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
 
 			flush_dcache_page(page);
 
-			vto = page_address(to->bv_page) + to->bv_offset;
+			vto = page_address(bvec_page(to)) + to->bv_offset;
 			vfrom = kmap_atomic(page) + to->bv_offset;
 			memcpy(vto, vfrom, to->bv_len);
 			kunmap_atomic(vfrom);
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 422b7d84f686..f0cbfe8c4bd8 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -300,7 +300,7 @@ skb_fillup(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter)
 	struct bio_vec bv;
 
 	__bio_for_each_segment(bv, bio, iter, iter)
-		skb_fill_page_desc(skb, frag++, bv.bv_page,
+		skb_fill_page_desc(skb, frag++, bvec_page(&bv),
 				   bv.bv_offset, bv.bv_len);
 }
 
@@ -874,7 +874,7 @@ bio_pageinc(struct bio *bio)
 		/* Non-zero page count for non-head members of
 		 * compound pages is no longer allowed by the kernel.
 		 */
-		page = compound_head(bv.bv_page);
+		page = compound_head(bvec_page(&bv));
 		atomic_inc(&page->_count);
 	}
 }
@@ -887,7 +887,7 @@ bio_pagedec(struct bio *bio)
 	struct bvec_iter iter;
 
 	bio_for_each_segment(bv, bio, iter) {
-		page = compound_head(bv.bv_page);
+		page = compound_head(bvec_page(&bv));
 		atomic_dec(&page->_count);
 	}
 }
@@ -1092,7 +1092,7 @@ bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
 	iter.bi_size = cnt;
 
 	__bio_for_each_segment(bv, bio, iter, iter) {
-		char *p = page_address(bv.bv_page) + bv.bv_offset;
+		char *p = page_address(bvec_page(&bv)) + bv.bv_offset;
 		skb_copy_bits(skb, soff, p, bv.bv_len);
 		soff += bv.bv_len;
 	}
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 64ab4951e9d6..115c6cf9cb43 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -349,7 +349,7 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
-		err = brd_do_bvec(brd, bvec.bv_page, len,
+		err = brd_do_bvec(brd, bvec_page(&bvec), len,
 					bvec.bv_offset, rw, sector);
 		if (err)
 			break;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 434c77dcc99e..37ba0f533e4b 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -946,7 +946,7 @@ static void drbd_bm_endio(struct bio *bio, int error)
 	struct drbd_bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_device *device = ctx->device;
 	struct drbd_bitmap *b = device->bitmap;
-	unsigned int idx = bm_page_to_idx(bio->bi_io_vec[0].bv_page);
+	unsigned int idx = bm_page_to_idx(bvec_page(&bio->bi_io_vec[0]));
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 
 
@@ -979,7 +979,8 @@ static void drbd_bm_endio(struct bio *bio, int error)
 	bm_page_unlock_io(device, idx);
 
 	if (ctx->flags & BM_AIO_COPY_PAGES)
-		mempool_free(bio->bi_io_vec[0].bv_page, drbd_md_io_page_pool);
+		mempool_free(bvec_page(&bio->bi_io_vec[0]),
+			     drbd_md_io_page_pool);
 
 	bio_put(bio);
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1fc83427199c..3df534a88572 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1554,7 +1554,7 @@ static int _drbd_send_bio(struct drbd_peer_device *peer_device, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_no_send_page(peer_device, bvec.bv_page,
+		err = _drbd_no_send_page(peer_device, bvec_page(&bvec),
 					 bvec.bv_offset, bvec.bv_len,
 					 bio_iter_last(bvec, iter)
 					 ? 0 : MSG_MORE);
@@ -1573,7 +1573,7 @@ static int _drbd_send_zc_bio(struct drbd_peer_device *peer_device, struct bio *b
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_send_page(peer_device, bvec.bv_page,
+		err = _drbd_send_page(peer_device, bvec_page(&bvec),
 				      bvec.bv_offset, bvec.bv_len,
 				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cee20354ac37..b4f16c6a0d73 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1729,10 +1729,10 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
 	D_ASSERT(peer_device->device, sector == bio->bi_iter.bi_sector);
 
 	bio_for_each_segment(bvec, bio, iter) {
-		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
+		void *mapped = kmap(bvec_page(&bvec)) + bvec.bv_offset;
 		expect = min_t(int, data_size, bvec.bv_len);
 		err = drbd_recv_all_warn(peer_device->connection, mapped, expect);
-		kunmap(bvec.bv_page);
+		kunmap(bvec_page(&bvec));
 		if (err)
 			return err;
 		data_size -= expect;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d0fae55d871d..d633c13d8ebe 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -332,7 +332,8 @@ void drbd_csum_bio(struct crypto_hash *tfm, struct bio *bio, void *digest)
 	crypto_hash_init(&desc);
 
 	bio_for_each_segment(bvec, bio, iter) {
-		sg_set_page(&sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
+		sg_set_page(&sg, bvec_page(&bvec), bvec.bv_len,
+			    bvec.bv_offset);
 		crypto_hash_update(&desc, &sg, sg.length);
 	}
 	crypto_hash_final(&desc, digest);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a08cda955285..6eae02e31731 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2374,7 +2374,7 @@ static int buffer_chain_size(void)
 	size = 0;
 
 	rq_for_each_segment(bv, current_req, iter) {
-		if (page_address(bv.bv_page) + bv.bv_offset != base + size)
+		if (page_address(bvec_page(&bv)) + bv.bv_offset != base + size)
 			break;
 
 		size += bv.bv_len;
@@ -2444,7 +2444,7 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		size = bv.bv_len;
 		SUPBOUND(size, remaining);
 
-		buffer = page_address(bv.bv_page) + bv.bv_offset;
+		buffer = page_address(bvec_page(&bv)) + bv.bv_offset;
 		if (dma_buffer + size >
 		    floppy_track_buffer + (max_buffer_sectors << 10) ||
 		    dma_buffer < floppy_track_buffer) {
@@ -3805,7 +3805,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 
 	bio_init(&bio);
 	bio.bi_io_vec = &bio_vec;
-	bio_vec.bv_page = page;
+	bvec_set_page(&bio_vec, page);
 	bio_vec.bv_len = size;
 	bio_vec.bv_offset = 0;
 	bio.bi_vcnt = 1;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d1f168b73634..2c3dd26bafdb 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -256,9 +256,9 @@ static int do_lo_send_direct_write(struct loop_device *lo,
 		struct bio_vec *bvec, loff_t pos, struct page *page)
 {
 	ssize_t bw = __do_lo_send_write(lo->lo_backing_file,
-			kmap(bvec->bv_page) + bvec->bv_offset,
+			kmap(bvec_page(bvec)) + bvec->bv_offset,
 			bvec->bv_len, pos);
-	kunmap(bvec->bv_page);
+	kunmap(bvec_page(bvec));
 	cond_resched();
 	return bw;
 }
@@ -273,7 +273,7 @@ static int do_lo_send_direct_write(struct loop_device *lo,
 static int do_lo_send_write(struct loop_device *lo, struct bio_vec *bvec,
 		loff_t pos, struct page *page)
 {
-	int ret = lo_do_transfer(lo, WRITE, page, 0, bvec->bv_page,
+	int ret = lo_do_transfer(lo, WRITE, page, 0, bvec_page(bvec),
 			bvec->bv_offset, bvec->bv_len, pos >> 9);
 	if (likely(!ret))
 		return __do_lo_send_write(lo->lo_backing_file,
@@ -376,7 +376,7 @@ do_lo_receive(struct loop_device *lo,
 	ssize_t retval;
 
 	cookie.lo = lo;
-	cookie.page = bvec->bv_page;
+	cookie.page = bvec_page(bvec);
 	cookie.offset = bvec->bv_offset;
 	cookie.bsize = bsize;
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4bc2a5cb9935..fb89faa00e48 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -229,10 +229,10 @@ static inline int sock_send_bvec(struct nbd_device *nbd, struct bio_vec *bvec,
 		int flags)
 {
 	int result;
-	void *kaddr = kmap(bvec->bv_page);
+	void *kaddr = kmap(bvec_page(bvec));
 	result = sock_xmit(nbd, 1, kaddr + bvec->bv_offset,
 			   bvec->bv_len, flags);
-	kunmap(bvec->bv_page);
+	kunmap(bvec_page(bvec));
 	return result;
 }
 
@@ -323,10 +323,10 @@ out:
 static inline int sock_recv_bvec(struct nbd_device *nbd, struct bio_vec *bvec)
 {
 	int result;
-	void *kaddr = kmap(bvec->bv_page);
+	void *kaddr = kmap(bvec_page(bvec));
 	result = sock_xmit(nbd, 0, kaddr + bvec->bv_offset, bvec->bv_len,
 			MSG_WAITALL);
-	kunmap(bvec->bv_page);
+	kunmap(bvec_page(bvec));
 	return result;
 }
 
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index ceb32dd52a6c..39068a196cc9 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -521,7 +521,7 @@ static void nvme_dif_remap(struct request *req,
 	if (!bip)
 		return;
 
-	pmap = kmap_atomic(bip->bip_vec->bv_page) + bip->bip_vec->bv_offset;
+	pmap = kmap_atomic(bvec_page(bip->bip_vec)) + bip->bip_vec->bv_offset;
 	if (!pmap)
 		return;
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09e628dafd9d..c873290bd8bb 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -958,12 +958,12 @@ static void pkt_make_local_copy(struct packet_data *pkt, struct bio_vec *bvec)
 	p = 0;
 	offs = 0;
 	for (f = 0; f < pkt->frames; f++) {
-		if (bvec[f].bv_page != pkt->pages[p]) {
-			void *vfrom = kmap_atomic(bvec[f].bv_page) + bvec[f].bv_offset;
+		if (bvec_page(&bvec[f]) != pkt->pages[p]) {
+			void *vfrom = kmap_atomic(bvec_page(&bvec[f])) + bvec[f].bv_offset;
 			void *vto = page_address(pkt->pages[p]) + offs;
 			memcpy(vto, vfrom, CD_FRAMESIZE);
 			kunmap_atomic(vfrom);
-			bvec[f].bv_page = pkt->pages[p];
+			bvec_set_page(&bvec[f], pkt->pages[p]);
 			bvec[f].bv_offset = offs;
 		} else {
 			BUG_ON(bvec[f].bv_offset != offs);
@@ -1307,9 +1307,10 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 	/* XXX: locking? */
 	for (f = 0; f < pkt->frames; f++) {
-		bvec[f].bv_page = pkt->pages[(f * CD_FRAMESIZE) / PAGE_SIZE];
+		bvec_set_page(&bvec[f],
+			      pkt->pages[(f * CD_FRAMESIZE) / PAGE_SIZE]);
 		bvec[f].bv_offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
-		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
+		if (!bio_add_page(pkt->w_bio, bvec_page(&bvec[f]), CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
 	}
 	pkt_dbg(2, pd, "vcnt=%d\n", pkt->w_bio->bi_vcnt);
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index c120d70d3fb3..07ad0d9d9480 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -112,7 +112,7 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 		else
 			memcpy(buf, dev->bounce_buf+offset, size);
 		offset += size;
-		flush_kernel_dcache_page(bvec.bv_page);
+		flush_kernel_dcache_page(bvec_page(&bvec));
 		bvec_kunmap_irq(buf, &flags);
 		i++;
 	}
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index ef45cfb98fd2..5db3311c2865 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -561,7 +561,7 @@ static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
 
 	bio_for_each_segment(bvec, bio, iter) {
 		/* PS3 is ppc64, so we don't handle highmem */
-		char *ptr = page_address(bvec.bv_page) + bvec.bv_offset;
+		char *ptr = page_address(bvec_page(&bvec)) + bvec.bv_offset;
 		size_t len = bvec.bv_len, retlen;
 
 		dev_dbg(&dev->core, "    %s %zu bytes at offset %llu\n", op,
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b40af3203089..812c1ffd7742 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1257,7 +1257,7 @@ static void zero_bio_chain(struct bio *chain, int start_ofs)
 				buf = bvec_kmap_irq(&bv, &flags);
 				memset(buf + remainder, 0,
 				       bv.bv_len - remainder);
-				flush_dcache_page(bv.bv_page);
+				flush_dcache_page(bvec_page(&bv));
 				bvec_kunmap_irq(buf, &flags);
 			}
 			pos += bv.bv_len;
diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index cf8cd293abb5..262ffdd017ae 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -737,7 +737,8 @@ int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 				st = rsxx_queue_dma(card, &dma_list[tgt],
 							bio_data_dir(bio),
 							dma_off, dma_len,
-							laddr, bvec.bv_page,
+							laddr,
+						    bvec_page(&bvec),
 							bv_off, cb, cb_data);
 				if (st)
 					goto bvec_err;
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 4cf81b5bf0f7..c7f65e4ec874 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -366,7 +366,7 @@ static int add_bio(struct cardinfo *card)
 	vec = bio_iter_iovec(bio, card->current_iter);
 
 	dma_handle = pci_map_page(card->dev,
-				  vec.bv_page,
+				  bvec_page(&vec),
 				  vec.bv_offset,
 				  vec.bv_len,
 				  (rw == READ) ?
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 871bd3550cb0..584fb16d8ca3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -394,7 +394,7 @@ static int page_zero_filled(void *ptr)
 
 static void handle_zero_page(struct bio_vec *bvec)
 {
-	struct page *page = bvec->bv_page;
+	struct page *page = bvec_page(bvec);
 	void *user_mem;
 
 	user_mem = kmap_atomic(page);
@@ -482,7 +482,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	struct page *page;
 	unsigned char *user_mem, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
-	page = bvec->bv_page;
+	page = bvec_page(bvec);
 
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	if (unlikely(!meta->table[index].handle) ||
@@ -553,7 +553,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	bool locked = false;
 	unsigned long alloced_pages;
 
-	page = bvec->bv_page;
+	page = bvec_page(bvec);
 	if (is_partial_io(bvec)) {
 		/*
 		 * This is a partial IO. We need to read the full page
@@ -903,7 +903,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 			 */
 			struct bio_vec bv;
 
-			bv.bv_page = bvec.bv_page;
+			bvec_set_page(&bv, bvec_page(&bvec));
 			bv.bv_len = max_transfer_size;
 			bv.bv_offset = bvec.bv_offset;
 
@@ -990,7 +990,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	index = sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = sector & (SECTORS_PER_PAGE - 1) << SECTOR_SHIFT;
 
-	bv.bv_page = page;
+	bvec_set_page(&bv, page);
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 00cde40db572..2e76e8b62902 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -366,7 +366,7 @@ static void btree_node_write_done(struct closure *cl)
 	int n;
 
 	bio_for_each_segment_all(bv, b->bio, n)
-		__free_page(bv->bv_page);
+		__free_page(bvec_page(bv));
 
 	__btree_node_write_done(cl);
 }
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b1f1d5c1819..c355a02b94dd 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -120,8 +120,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	submit_bio_wait(READ_SYNC, check);
 
 	bio_for_each_segment(bv, bio, iter) {
-		void *p1 = kmap_atomic(bv.bv_page);
-		void *p2 = page_address(check->bi_io_vec[iter.bi_idx].bv_page);
+		void *p1 = kmap_atomic(bvec_page(&bv));
+		void *p2 = page_address(bvec_page(&check->bi_io_vec[iter.bi_idx]));
 
 		cache_set_err_on(memcmp(p1 + bv.bv_offset,
 					p2 + bv.bv_offset,
@@ -135,7 +135,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	}
 
 	bio_for_each_segment_all(bv2, check, i)
-		__free_page(bv2->bv_page);
+		__free_page(bvec_page(bv2));
 out_put:
 	bio_put(check);
 }
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index cd7490311e51..744e7af4b160 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -48,7 +48,7 @@ static void write_moving_finish(struct closure *cl)
 	int i;
 
 	bio_for_each_segment_all(bv, bio, i)
-		__free_page(bv->bv_page);
+		__free_page(bvec_page(bv));
 
 	if (io->op.replace_collision)
 		trace_bcache_gc_copy_collision(&io->w->key);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index ab43faddb447..e6378a998618 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -42,9 +42,9 @@ static void bio_csum(struct bio *bio, struct bkey *k)
 	uint64_t csum = 0;
 
 	bio_for_each_segment(bv, bio, iter) {
-		void *d = kmap(bv.bv_page) + bv.bv_offset;
+		void *d = kmap(bvec_page(&bv)) + bv.bv_offset;
 		csum = bch_crc64_update(csum, d, bv.bv_len);
-		kunmap(bv.bv_page);
+		kunmap(bvec_page(&bv));
 	}
 
 	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
@@ -690,7 +690,7 @@ static void cached_dev_cache_miss_done(struct closure *cl)
 		struct bio_vec *bv;
 
 		bio_for_each_segment_all(bv, s->iop.bio, i)
-			__free_page(bv->bv_page);
+			__free_page(bvec_page(bv));
 	}
 
 	cached_dev_bio_complete(cl);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4dd2bb7167f0..8d7cbba7ff7e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -231,7 +231,7 @@ static void write_bdev_super_endio(struct bio *bio, int error)
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
-	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page);
+	struct cache_sb *out = page_address(bvec_page(&bio->bi_io_vec[0]));
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
@@ -1172,7 +1172,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	bio_init(&dc->sb_bio);
 	dc->sb_bio.bi_max_vecs	= 1;
 	dc->sb_bio.bi_io_vec	= dc->sb_bio.bi_inline_vecs;
-	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	bvec_set_page(dc->sb_bio.bi_io_vec, sb_page);
 	get_page(sb_page);
 
 	if (cached_dev_init(dc, sb->block_size << 9))
@@ -1811,8 +1811,8 @@ void bch_cache_release(struct kobject *kobj)
 	for (i = 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
 
-	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
+	if (bvec_page(&ca->sb_bio.bi_inline_vecs[0]))
+		put_page(bvec_page(&ca->sb_bio.bi_io_vec[0]));
 
 	if (!IS_ERR_OR_NULL(ca->bdev))
 		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -1870,7 +1870,7 @@ static void register_cache(struct cache_sb *sb, struct page *sb_page,
 	bio_init(&ca->sb_bio);
 	ca->sb_bio.bi_max_vecs	= 1;
 	ca->sb_bio.bi_io_vec	= ca->sb_bio.bi_inline_vecs;
-	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	bvec_set_page(&ca->sb_bio.bi_io_vec[0], sb_page);
 	get_page(sb_page);
 
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index db3ae4c2b223..d02f6d626529 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -238,9 +238,8 @@ void bch_bio_map(struct bio *bio, void *base)
 start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
 					size);
 		if (base) {
-			bv->bv_page = is_vmalloc_addr(base)
-				? vmalloc_to_page(base)
-				: virt_to_page(base);
+			bvec_set_page(bv,
+				      is_vmalloc_addr(base) ? vmalloc_to_page(base) : virt_to_page(base));
 
 			base += bv->bv_len;
 		}
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index f1986bcd1bf0..6e9901c5dd66 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -133,7 +133,7 @@ static void write_dirty_finish(struct closure *cl)
 	int i;
 
 	bio_for_each_segment_all(bv, &io->bio, i)
-		__free_page(bv->bv_page);
+		__free_page(bvec_page(bv));
 
 	/* This is kind of a dumb way of signalling errors. */
 	if (KEY_DIRTY(&w->key)) {
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 713a96237a80..9990a3c966f3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -849,11 +849,11 @@ static int crypt_convert_block(struct crypt_config *cc,
 	dmreq->iv_sector = ctx->cc_sector;
 	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
-	sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
+	sg_set_page(&dmreq->sg_in, bvec_page(&bv_in), 1 << SECTOR_SHIFT,
 		    bv_in.bv_offset);
 
 	sg_init_table(&dmreq->sg_out, 1);
-	sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
+	sg_set_page(&dmreq->sg_out, bvec_page(&bv_out), 1 << SECTOR_SHIFT,
 		    bv_out.bv_offset);
 
 	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
@@ -1003,7 +1003,7 @@ retry:
 		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
 
 		bvec = &clone->bi_io_vec[clone->bi_vcnt++];
-		bvec->bv_page = page;
+		bvec_set_page(bvec, page);
 		bvec->bv_len = len;
 		bvec->bv_offset = 0;
 
@@ -1025,9 +1025,9 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 	struct bio_vec *bv;
 
 	bio_for_each_segment_all(bv, clone, i) {
-		BUG_ON(!bv->bv_page);
-		mempool_free(bv->bv_page, cc->page_pool);
-		bv->bv_page = NULL;
+		BUG_ON(!bvec_page(bv));
+		mempool_free(bvec_page(bv), cc->page_pool);
+		bvec_set_page(bv, NULL);
 	}
 }
 
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 37de0173b6d2..0bf4bed512fe 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -204,7 +204,7 @@ static void bio_get_page(struct dpages *dp, struct page **p,
 			 unsigned long *len, unsigned *offset)
 {
 	struct bio_vec *bvec = dp->context_ptr;
-	*p = bvec->bv_page;
+	*p = bvec_page(bvec);
 	*len = bvec->bv_len - dp->context_u;
 	*offset = bvec->bv_offset + dp->context_u;
 }
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 7a7bab8947ae..5b5c8684f61f 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -336,7 +336,7 @@ test_block_hash:
 			unsigned len;
 			struct bio_vec bv = bio_iter_iovec(bio, io->iter);
 
-			page = kmap_atomic(bv.bv_page);
+			page = kmap_atomic(bvec_page(&bv));
 			len = bv.bv_len;
 			if (likely(len >= todo))
 				len = todo;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d34e238afa54..79db06bd32ae 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -134,8 +134,8 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
 		for (i=0; i<RESYNC_PAGES ; i++)
 			for (j=1; j<pi->raid_disks; j++)
-				r1_bio->bios[j]->bi_io_vec[i].bv_page =
-					r1_bio->bios[0]->bi_io_vec[i].bv_page;
+				bvec_set_page(&r1_bio->bios[j]->bi_io_vec[i],
+					      bvec_page(&r1_bio->bios[0]->bi_io_vec[i]));
 	}
 
 	r1_bio->master_bio = NULL;
@@ -147,7 +147,7 @@ out_free_pages:
 		struct bio_vec *bv;
 
 		bio_for_each_segment_all(bv, r1_bio->bios[j], i)
-			__free_page(bv->bv_page);
+			__free_page(bvec_page(bv));
 	}
 
 out_free_bio:
@@ -166,9 +166,9 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 	for (i = 0; i < RESYNC_PAGES; i++)
 		for (j = pi->raid_disks; j-- ;) {
 			if (j == 0 ||
-			    r1bio->bios[j]->bi_io_vec[i].bv_page !=
-			    r1bio->bios[0]->bi_io_vec[i].bv_page)
-				safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
+			    bvec_page(&r1bio->bios[j]->bi_io_vec[i]) !=
+			    bvec_page(&r1bio->bios[0]->bi_io_vec[i]))
+				safe_put_page(bvec_page(&r1bio->bios[j]->bi_io_vec[i]));
 		}
 	for (i=0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
@@ -369,7 +369,7 @@ static void close_write(struct r1bio *r1_bio)
 		/* free extra copy of the data pages */
 		int i = r1_bio->behind_page_count;
 		while (i--)
-			safe_put_page(r1_bio->behind_bvecs[i].bv_page);
+			safe_put_page(bvec_page(&r1_bio->behind_bvecs[i]));
 		kfree(r1_bio->behind_bvecs);
 		r1_bio->behind_bvecs = NULL;
 	}
@@ -1004,13 +1004,13 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		bvecs[i] = *bvec;
-		bvecs[i].bv_page = alloc_page(GFP_NOIO);
-		if (unlikely(!bvecs[i].bv_page))
+		bvec_set_page(&bvecs[i], alloc_page(GFP_NOIO));
+		if (unlikely(!bvec_page(&bvecs[i])))
 			goto do_sync_io;
-		memcpy(kmap(bvecs[i].bv_page) + bvec->bv_offset,
-		       kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
-		kunmap(bvecs[i].bv_page);
-		kunmap(bvec->bv_page);
+		memcpy(kmap(bvec_page(&bvecs[i])) + bvec->bv_offset,
+		       kmap(bvec_page(bvec)) + bvec->bv_offset, bvec->bv_len);
+		kunmap(bvec_page(&bvecs[i]));
+		kunmap(bvec_page(bvec));
 	}
 	r1_bio->behind_bvecs = bvecs;
 	r1_bio->behind_page_count = bio->bi_vcnt;
@@ -1019,8 +1019,8 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
 
 do_sync_io:
 	for (i = 0; i < bio->bi_vcnt; i++)
-		if (bvecs[i].bv_page)
-			put_page(bvecs[i].bv_page);
+		if (bvec_page(&bvecs[i]))
+			put_page(bvec_page(&bvecs[i]));
 	kfree(bvecs);
 	pr_debug("%dB behind alloc failed, doing sync I/O\n",
 		 bio->bi_iter.bi_size);
@@ -1386,7 +1386,8 @@ read_again:
 			 * We trimmed the bio, so _all is legit
 			 */
 			bio_for_each_segment_all(bvec, mbio, j)
-				bvec->bv_page = r1_bio->behind_bvecs[j].bv_page;
+				bvec_set_page(bvec,
+					      bvec_page(&r1_bio->behind_bvecs[j]));
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
 		}
@@ -1849,7 +1850,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				 */
 				rdev = conf->mirrors[d].rdev;
 				if (sync_page_io(rdev, sect, s<<9,
-						 bio->bi_io_vec[idx].bv_page,
+						 bvec_page(&bio->bi_io_vec[idx]),
 						 READ, false)) {
 					success = 1;
 					break;
@@ -1905,7 +1906,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				continue;
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
-					    bio->bi_io_vec[idx].bv_page,
+					    bvec_page(&bio->bi_io_vec[idx]),
 					    WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
@@ -1920,7 +1921,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				continue;
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
-					    bio->bi_io_vec[idx].bv_page,
+					    bvec_page(&bio->bi_io_vec[idx]),
 					    READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
@@ -2004,8 +2005,8 @@ static void process_checks(struct r1bio *r1_bio)
 		if (uptodate) {
 			for (j = vcnt; j-- ; ) {
 				struct page *p, *s;
-				p = pbio->bi_io_vec[j].bv_page;
-				s = sbio->bi_io_vec[j].bv_page;
+				p = bvec_page(&pbio->bi_io_vec[j]);
+				s = bvec_page(&sbio->bi_io_vec[j]);
 				if (memcmp(page_address(p),
 					   page_address(s),
 					   sbio->bi_io_vec[j].bv_len))
@@ -2214,7 +2215,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 			unsigned vcnt = r1_bio->behind_page_count;
 			struct bio_vec *vec = r1_bio->behind_bvecs;
 
-			while (!vec->bv_page) {
+			while (!bvec_page(vec)) {
 				vec++;
 				vcnt--;
 			}
@@ -2695,10 +2696,11 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
-				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
+				page = bvec_page(&bio->bi_io_vec[bio->bi_vcnt]);
 				if (bio_add_page(bio, page, len, 0) == 0) {
 					/* stop here */
-					bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
+					bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt],
+						      page);
 					while (i > 0) {
 						i--;
 						bio = r1_bio->bios[i];
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a7196c49d15d..da9033e3bc64 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -181,16 +181,16 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 				/* we can share bv_page's during recovery
 				 * and reshape */
 				struct bio *rbio = r10_bio->devs[0].bio;
-				page = rbio->bi_io_vec[i].bv_page;
+				page = bvec_page(&rbio->bi_io_vec[i]);
 				get_page(page);
 			} else
 				page = alloc_page(gfp_flags);
 			if (unlikely(!page))
 				goto out_free_pages;
 
-			bio->bi_io_vec[i].bv_page = page;
+			bvec_set_page(&bio->bi_io_vec[i], page);
 			if (rbio)
-				rbio->bi_io_vec[i].bv_page = page;
+				bvec_set_page(&rbio->bi_io_vec[i], page);
 		}
 	}
 
@@ -198,10 +198,10 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 out_free_pages:
 	for ( ; i > 0 ; i--)
-		safe_put_page(bio->bi_io_vec[i-1].bv_page);
+		safe_put_page(bvec_page(&bio->bi_io_vec[i - 1]));
 	while (j--)
 		for (i = 0; i < RESYNC_PAGES ; i++)
-			safe_put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
+			safe_put_page(bvec_page(&r10_bio->devs[j].bio->bi_io_vec[i]));
 	j = 0;
 out_free_bio:
 	for ( ; j < nalloc; j++) {
@@ -225,8 +225,8 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 		struct bio *bio = r10bio->devs[j].bio;
 		if (bio) {
 			for (i = 0; i < RESYNC_PAGES; i++) {
-				safe_put_page(bio->bi_io_vec[i].bv_page);
-				bio->bi_io_vec[i].bv_page = NULL;
+				safe_put_page(bvec_page(&bio->bi_io_vec[i]));
+				bvec_set_page(&bio->bi_io_vec[i], NULL);
 			}
 			bio_put(bio);
 		}
@@ -2074,8 +2074,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 				int len = PAGE_SIZE;
 				if (sectors < (len / 512))
 					len = sectors * 512;
-				if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
-					   page_address(tbio->bi_io_vec[j].bv_page),
+				if (memcmp(page_address(bvec_page(&fbio->bi_io_vec[j])),
+					   page_address(bvec_page(&tbio->bi_io_vec[j])),
 					   len))
 					break;
 				sectors -= len/512;
@@ -2104,8 +2104,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			tbio->bi_io_vec[j].bv_offset = 0;
 			tbio->bi_io_vec[j].bv_len = PAGE_SIZE;
 
-			memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-			       page_address(fbio->bi_io_vec[j].bv_page),
+			memcpy(page_address(bvec_page(&tbio->bi_io_vec[j])),
+			       page_address(bvec_page(&fbio->bi_io_vec[j])),
 			       PAGE_SIZE);
 		}
 		tbio->bi_end_io = end_sync_write;
@@ -2132,8 +2132,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
 		    && r10_bio->devs[i].bio != fbio)
 			for (j = 0; j < vcnt; j++)
-				memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-				       page_address(fbio->bi_io_vec[j].bv_page),
+				memcpy(page_address(bvec_page(&tbio->bi_io_vec[j])),
+				       page_address(bvec_page(&fbio->bi_io_vec[j])),
 				       PAGE_SIZE);
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
@@ -2191,7 +2191,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 		ok = sync_page_io(rdev,
 				  addr,
 				  s << 9,
-				  bio->bi_io_vec[idx].bv_page,
+				  bvec_page(&bio->bi_io_vec[idx]),
 				  READ, false);
 		if (ok) {
 			rdev = conf->mirrors[dw].rdev;
@@ -2199,7 +2199,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 			ok = sync_page_io(rdev,
 					  addr,
 					  s << 9,
-					  bio->bi_io_vec[idx].bv_page,
+					  bvec_page(&bio->bi_io_vec[idx]),
 					  WRITE, false);
 			if (!ok) {
 				set_bit(WriteErrorSeen, &rdev->flags);
@@ -3361,12 +3361,12 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
 			struct bio *bio2;
-			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
+			page = bvec_page(&bio->bi_io_vec[bio->bi_vcnt]);
 			if (bio_add_page(bio, page, len, 0))
 				continue;
 
 			/* stop here */
-			bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
+			bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page);
 			for (bio2 = biolist;
 			     bio2 && bio2 != bio;
 			     bio2 = bio2->bi_next) {
@@ -4436,7 +4436,7 @@ read_more:
 
 	nr_sectors = 0;
 	for (s = 0 ; s < max_sectors; s += PAGE_SIZE >> 9) {
-		struct page *page = r10_bio->devs[0].bio->bi_io_vec[s/(PAGE_SIZE>>9)].bv_page;
+		struct page *page = bvec_page(&r10_bio->devs[0].bio->bi_io_vec[s / (PAGE_SIZE >> 9)]);
 		int len = (max_sectors - s) << 9;
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
@@ -4593,7 +4593,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			success = sync_page_io(rdev,
 					       addr,
 					       s << 9,
-					       bvec[idx].bv_page,
+					       bvec_page(&bvec[idx]),
 					       READ, false);
 			if (success)
 				break;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cd2f96b2c572..0f450a166cd1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -864,7 +864,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].vec.bv_page = sh->dev[i].page;
+			bvec_set_page(&sh->dev[i].vec, sh->dev[i].page);
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
@@ -911,7 +911,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 						  + rrdev->data_offset);
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].rvec.bv_page = sh->dev[i].page;
+			bvec_set_page(&sh->dev[i].rvec, sh->dev[i].page);
 			rbi->bi_vcnt = 1;
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
@@ -978,7 +978,7 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 
 		if (clen > 0) {
 			b_offset += bvl.bv_offset;
-			bio_page = bvl.bv_page;
+			bio_page = bvec_page(&bvl);
 			if (frombio) {
 				if (sh->raid_conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index c062f1620c58..89f39d00077d 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -545,7 +545,7 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 	dbio = dreq->bio;
 	recid = first_rec;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		for (off = 0; off < bv.bv_len; off += blksize) {
 			memset(dbio, 0, sizeof (struct dasd_diag_bio));
 			dbio->type = rw_cmd;
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index d47f5b99623a..cd78c3483192 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2616,7 +2616,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 			return ERR_PTR(-EINVAL);
 		count += bv.bv_len >> (block->s2b_shift + 9);
 #if defined(CONFIG_64BIT)
-		if (idal_is_needed (page_address(bv.bv_page), bv.bv_len))
+		if (idal_is_needed (page_address(bvec_page(&bv)), bv.bv_len))
 			cidaw += bv.bv_len >> (block->s2b_shift + 9);
 #endif
 	}
@@ -2688,7 +2688,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 			      last_rec - recid + 1, cmd, basedev, blksize);
 	}
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
@@ -2851,7 +2851,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_track(
 	idaw_dst = NULL;
 	idaw_len = 0;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		seg_len = bv.bv_len;
 		while (seg_len) {
 			if (new_track) {
@@ -3163,7 +3163,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		new_track = 1;
 		recid = first_rec;
 		rq_for_each_segment(bv, req, iter) {
-			dst = page_address(bv.bv_page) + bv.bv_offset;
+			dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 			seg_len = bv.bv_len;
 			while (seg_len) {
 				if (new_track) {
@@ -3196,7 +3196,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		}
 	} else {
 		rq_for_each_segment(bv, req, iter) {
-			dst = page_address(bv.bv_page) + bv.bv_offset;
+			dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 			last_tidaw = itcw_add_tidaw(itcw, 0x00,
 						    dst, bv.bv_len);
 			if (IS_ERR(last_tidaw)) {
@@ -3416,7 +3416,7 @@ static struct dasd_ccw_req *dasd_raw_build_cp(struct dasd_device *startdev,
 			idaws = idal_create_words(idaws, rawpadpage, PAGE_SIZE);
 	}
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		seg_len = bv.bv_len;
 		if (cmd == DASD_ECKD_CCW_READ_TRACK)
 			memset(dst, 0, seg_len);
@@ -3480,7 +3480,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	if (private->uses_cdl == 0 || recid > 2*blk_per_trk)
 		ccw++;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->uses_cdl && recid <= 2*blk_per_trk)
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 2c8e68bf9a1c..e405051d829b 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -288,7 +288,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 			return ERR_PTR(-EINVAL);
 		count += bv.bv_len >> (block->s2b_shift + 9);
 #if defined(CONFIG_64BIT)
-		if (idal_is_needed (page_address(bv.bv_page), bv.bv_len))
+		if (idal_is_needed (page_address(bvec_page(&bv)), bv.bv_len))
 			cidaw += bv.bv_len / blksize;
 #endif
 	}
@@ -326,7 +326,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 	}
 	recid = first_rec;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
@@ -399,7 +399,7 @@ dasd_fba_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	if (private->rdc_data.mode.bits.data_chain != 0)
 		ccw++;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->rdc_data.mode.bits.data_chain == 0)
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 96128cb009f3..13eee10fedc8 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -857,7 +857,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	index = (bio->bi_iter.bi_sector >> 3);
 	bio_for_each_segment(bvec, bio, iter) {
 		page_addr = (unsigned long)
-			page_address(bvec.bv_page) + bvec.bv_offset;
+			page_address(bvec_page(&bvec)) + bvec.bv_offset;
 		source_addr = dev_info->start + (index<<12) + bytes_done;
 		if (unlikely((page_addr & 4095) != 0) || (bvec.bv_len & 4095) != 0)
 			// More paranoia.
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 75d9896deccb..9bf2d42c1946 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -203,7 +203,7 @@ static int scm_request_prepare(struct scm_request *scmrq)
 	rq_for_each_segment(bv, req, iter) {
 		WARN_ON(bv.bv_offset);
 		msb->blk_count += bv.bv_len >> 12;
-		aidaw->data_addr = (u64) page_address(bv.bv_page);
+		aidaw->data_addr = (u64) page_address(bvec_page(&bv));
 		aidaw++;
 	}
 
diff --git a/drivers/s390/block/scm_blk_cluster.c b/drivers/s390/block/scm_blk_cluster.c
index 09db45296eed..a302a79e1cb3 100644
--- a/drivers/s390/block/scm_blk_cluster.c
+++ b/drivers/s390/block/scm_blk_cluster.c
@@ -181,7 +181,7 @@ static int scm_prepare_cluster_request(struct scm_request *scmrq)
 			i++;
 		}
 		rq_for_each_segment(bv, req, iter) {
-			aidaw->data_addr = (u64) page_address(bv.bv_page);
+			aidaw->data_addr = (u64) page_address(bvec_page(&bv));
 			aidaw++;
 			i++;
 		}
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 7d4e9397ac31..44e80e13b643 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -202,7 +202,7 @@ static void xpram_make_request(struct request_queue *q, struct bio *bio)
 	index = (bio->bi_iter.bi_sector >> 3) + xdev->offset;
 	bio_for_each_segment(bvec, bio, iter) {
 		page_addr = (unsigned long)
-			kmap(bvec.bv_page) + bvec.bv_offset;
+			kmap(bvec_page(&bvec)) + bvec.bv_offset;
 		bytes = bvec.bv_len;
 		if ((page_addr & 4095) != 0 || (bytes & 4095) != 0)
 			/* More paranoia. */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index ff2500ab9ba4..788de1c250a3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1956,7 +1956,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 		bio_for_each_segment(bvec, req->bio, iter) {
 			memcpy(pci_addr_out + offset,
-			    page_address(bvec.bv_page) + bvec.bv_offset,
+			    page_address(bvec_page(&bvec)) + bvec.bv_offset,
 			    bvec.bv_len);
 			offset += bvec.bv_len;
 		}
@@ -2107,12 +2107,12 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			    le16_to_cpu(mpi_reply->ResponseDataLength);
 			bio_for_each_segment(bvec, rsp->bio, iter) {
 				if (bytes_to_copy <= bvec.bv_len) {
-					memcpy(page_address(bvec.bv_page) +
+					memcpy(page_address(bvec_page(&bvec)) +
 					    bvec.bv_offset, pci_addr_in +
 					    offset, bytes_to_copy);
 					break;
 				} else {
-					memcpy(page_address(bvec.bv_page) +
+					memcpy(page_address(bvec_page(&bvec)) +
 					    bvec.bv_offset, pci_addr_in +
 					    offset, bvec.bv_len);
 					bytes_to_copy -= bvec.bv_len;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index efb98afc46e0..f187a1a05b9b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1939,7 +1939,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 		bio_for_each_segment(bvec, req->bio, iter) {
 			memcpy(pci_addr_out + offset,
-			    page_address(bvec.bv_page) + bvec.bv_offset,
+			    page_address(bvec_page(&bvec)) + bvec.bv_offset,
 			    bvec.bv_len);
 			offset += bvec.bv_len;
 		}
@@ -2068,12 +2068,12 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			    le16_to_cpu(mpi_reply->ResponseDataLength);
 			bio_for_each_segment(bvec, rsp->bio, iter) {
 				if (bytes_to_copy <= bvec.bv_len) {
-					memcpy(page_address(bvec.bv_page) +
+					memcpy(page_address(bvec_page(&bvec)) +
 					    bvec.bv_offset, pci_addr_in +
 					    offset, bytes_to_copy);
 					break;
 				} else {
-					memcpy(page_address(bvec.bv_page) +
+					memcpy(page_address(bvec_page(&bvec)) +
 					    bvec.bv_offset, pci_addr_in +
 					    offset, bvec.bv_len);
 					bytes_to_copy -= bvec.bv_len;
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 14c7d42a11c2..0534050c9cba 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -134,7 +134,7 @@ void sd_dif_prepare(struct scsi_cmnd *scmd)
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
+			pi = kmap_atomic(bvec_page(&iv)) + iv.bv_offset;
 
 			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
@@ -181,7 +181,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
+			pi = kmap_atomic(bvec_page(&iv)) + iv.bv_offset;
 
 			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 031248840642..2a68e4ab93ca 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -222,7 +222,7 @@ static int do_bio_lustrebacked(struct lloop_device *lo, struct bio *head)
 			BUG_ON(bvec.bv_offset != 0);
 			BUG_ON(bvec.bv_len != PAGE_CACHE_SIZE);
 
-			pages[page_count] = bvec.bv_page;
+			pages[page_count] = bvec_page(&bvec);
 			offsets[page_count] = offset;
 			page_count++;
 			offset += bvec.bv_len;
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
index 0edb91c0de6b..7fcdcb2265f1 100644
--- a/drivers/xen/biomerge.c
+++ b/drivers/xen/biomerge.c
@@ -6,8 +6,8 @@
 bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 			       const struct bio_vec *vec2)
 {
-	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(vec1->bv_page));
-	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(vec2->bv_page));
+	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(bvec_page(vec1)));
+	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(bvec_page(vec2)));
 
 	return __BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
 		((mfn1 == mfn2) || ((mfn1+1) == mfn2));
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index d897ef803b3b..8297d6792ac0 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2997,11 +2997,11 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 		cur_bytenr = dev_bytenr;
 		for (i = 0; i < bio->bi_vcnt; i++) {
 			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_CACHE_SIZE);
-			mapped_datav[i] = kmap(bio->bi_io_vec[i].bv_page);
+			mapped_datav[i] = kmap(bvec_page(&bio->bi_io_vec[i]));
 			if (!mapped_datav[i]) {
 				while (i > 0) {
 					i--;
-					kunmap(bio->bi_io_vec[i].bv_page);
+					kunmap(bvec_page(&bio->bi_io_vec[i]));
 				}
 				kfree(mapped_datav);
 				goto leave;
@@ -3020,7 +3020,7 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 					      NULL, rw);
 		while (i > 0) {
 			i--;
-			kunmap(bio->bi_io_vec[i].bv_page);
+			kunmap(bvec_page(&bio->bi_io_vec[i]));
 		}
 		kfree(mapped_datav);
 	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e9df8862012c..f654bb5554dc 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -208,7 +208,7 @@ csum_failed:
 		 * checked so the end_io handlers know about it
 		 */
 		bio_for_each_segment_all(bvec, cb->orig_bio, i)
-			SetPageChecked(bvec->bv_page);
+			SetPageChecked(bvec_page(bvec));
 
 		bio_endio(cb->orig_bio, 0);
 	}
@@ -459,7 +459,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	u64 end;
 	int misses = 0;
 
-	page = cb->orig_bio->bi_io_vec[cb->orig_bio->bi_vcnt - 1].bv_page;
+	page = bvec_page(&cb->orig_bio->bi_io_vec[cb->orig_bio->bi_vcnt - 1]);
 	last_offset = (page_offset(page) + PAGE_CACHE_SIZE);
 	em_tree = &BTRFS_I(inode)->extent_tree;
 	tree = &BTRFS_I(inode)->io_tree;
@@ -592,7 +592,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	/* we need the actual starting offset of this extent in the file */
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree,
-				   page_offset(bio->bi_io_vec->bv_page),
+				   page_offset(bvec_page(bio->bi_io_vec)),
 				   PAGE_CACHE_SIZE);
 	read_unlock(&em_tree->lock);
 	if (!em)
@@ -986,7 +986,7 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 	unsigned long working_bytes = total_out - buf_start;
 	unsigned long bytes;
 	char *kaddr;
-	struct page *page_out = bvec[*pg_index].bv_page;
+	struct page *page_out = bvec_page(&bvec[*pg_index]);
 
 	/*
 	 * start byte is the first byte of the page we're currently
@@ -1031,7 +1031,7 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 			if (*pg_index >= vcnt)
 				return 0;
 
-			page_out = bvec[*pg_index].bv_page;
+			page_out = bvec_page(&bvec[*pg_index]);
 			*pg_offset = 0;
 			start_byte = page_offset(page_out) - disk_start;
 
@@ -1071,7 +1071,7 @@ void btrfs_clear_biovec_end(struct bio_vec *bvec, int vcnt,
 				   unsigned long pg_offset)
 {
 	while (pg_index < vcnt) {
-		struct page *page = bvec[pg_index].bv_page;
+		struct page *page = bvec_page(&bvec[pg_index]);
 		unsigned long off = bvec[pg_index].bv_offset;
 		unsigned long len = bvec[pg_index].bv_len;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f79f38542a73..6b600278f7da 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -881,8 +881,8 @@ static int btree_csum_one_bio(struct bio *bio)
 	int i, ret = 0;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
-		ret = csum_dirty_buffer(root, bvec->bv_page);
+		root = BTRFS_I(bvec_page(bvec)->mapping->host)->root;
+		ret = csum_dirty_buffer(root, bvec_page(bvec));
 		if (ret)
 			break;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c7233ff1d533..76186ab4c5ae 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2489,7 +2489,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		/* We always issue full-page reads, but if some block
 		 * in a page fails to read, blk_update_request() will
@@ -2563,7 +2563,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		uptodate = 0;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
@@ -2751,7 +2751,7 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct page *page = bvec->bv_page;
+	struct page *page = bvec_page(bvec);
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
@@ -3700,7 +3700,7 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 	int i, done;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 84a2d1868271..f7e2c497b0a2 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -222,7 +222,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
 		if (!dio)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec_page(bvec)) + bvec->bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -448,7 +448,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	if (contig)
 		offset = file_start;
 	else
-		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+		offset = page_offset(bvec_page(bvec)) + bvec->bv_offset;
 
 	ordered = btrfs_lookup_ordered_extent(inode, offset);
 	BUG_ON(!ordered); /* Logic error */
@@ -457,7 +457,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 
 	while (bio_index < bio->bi_vcnt) {
 		if (!contig)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec_page(bvec)) + bvec->bv_offset;
 
 		if (offset >= ordered->file_offset + ordered->len ||
 		    offset < ordered->file_offset) {
@@ -480,7 +480,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 			index = 0;
 		}
 
-		data = kmap_atomic(bvec->bv_page);
+		data = kmap_atomic(bvec_page(bvec));
 		sums->sums[index] = ~(u32)0;
 		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
 						    sums->sums[index],
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index da828cf5e8f8..6efe9fd5c07d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7504,7 +7504,8 @@ static void btrfs_retry_endio_nocsum(struct bio *bio, int err)
 
 	done->uptodate = 1;
 	bio_for_each_segment_all(bvec, bio, i)
-		clean_io_failure(done->inode, done->start, bvec->bv_page, 0);
+		clean_io_failure(done->inode, done->start, bvec_page(bvec),
+				 0);
 end:
 	complete(&done->done);
 	bio_put(bio);
@@ -7528,7 +7529,8 @@ try_again:
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
+		ret = dio_read_error(inode, &io_bio->bio, bvec_page(bvec),
+				     start,
 				     start + bvec->bv_len - 1,
 				     io_bio->mirror_num,
 				     btrfs_retry_endio_nocsum, &done);
@@ -7563,11 +7565,11 @@ static void btrfs_retry_endio(struct bio *bio, int err)
 	uptodate = 1;
 	bio_for_each_segment_all(bvec, bio, i) {
 		ret = __readpage_endio_check(done->inode, io_bio, i,
-					     bvec->bv_page, 0,
+					     bvec_page(bvec), 0,
 					     done->start, bvec->bv_len);
 		if (!ret)
 			clean_io_failure(done->inode, done->start,
-					 bvec->bv_page, 0);
+					 bvec_page(bvec), 0);
 		else
 			uptodate = 0;
 	}
@@ -7593,7 +7595,8 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 	done.inode = inode;
 
 	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
-		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
+		ret = __readpage_endio_check(inode, io_bio, i,
+					     bvec_page(bvec),
 					     0, start, bvec->bv_len);
 		if (likely(!ret))
 			goto next;
@@ -7602,7 +7605,8 @@ try_again:
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
+		ret = dio_read_error(inode, &io_bio->bio, bvec_page(bvec),
+				     start,
 				     start + bvec->bv_len - 1,
 				     io_bio->mirror_num,
 				     btrfs_retry_endio, &done);
@@ -7898,7 +7902,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
 		if (map_length < submit_len + bvec->bv_len ||
-		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
+		    bio_add_page(bio, bvec_page(bvec), bvec->bv_len,
 				 bvec->bv_offset) < bvec->bv_len) {
 			/*
 			 * inc the count before we submit the bio so
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5264858ed768..4c81b2297435 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1154,7 +1154,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 		page_index = stripe_offset >> PAGE_CACHE_SHIFT;
 
 		for (i = 0; i < bio->bi_vcnt; i++) {
-			p = bio->bi_io_vec[i].bv_page;
+			p = bvec_page(&bio->bi_io_vec[i]);
 			rbio->bio_pages[page_index + i] = p;
 		}
 	}
@@ -1435,7 +1435,7 @@ static void set_bio_pages_uptodate(struct bio *bio)
 	struct page *p;
 
 	for (i = 0; i < bio->bi_vcnt; i++) {
-		p = bio->bi_io_vec[i].bv_page;
+		p = bvec_page(&bio->bi_io_vec[i]);
 		SetPageUptodate(p);
 	}
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8222f6f74147..a9e8ea439792 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5793,7 +5793,7 @@ again:
 		return -ENOMEM;
 
 	while (bvec <= (first_bio->bi_io_vec + first_bio->bi_vcnt - 1)) {
-		if (bio_add_page(bio, bvec->bv_page, bvec->bv_len,
+		if (bio_add_page(bio, bvec_page(bvec), bvec->bv_len,
 				 bvec->bv_offset) < bvec->bv_len) {
 			u64 len = bio->bi_iter.bi_size;
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 20805db2c987..43a785533ac6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2992,7 +2992,7 @@ void guard_bio_eod(int rw, struct bio *bio)
 
 	/* ..and clear the end of the buffer for reads */
 	if ((rw & RW_MASK) == READ) {
-		zero_user(bvec->bv_page, bvec->bv_offset + bvec->bv_len,
+		zero_user(bvec_page(bvec), bvec->bv_offset + bvec->bv_len,
 				truncated_bytes);
 	}
 }
@@ -3022,7 +3022,7 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
-	bio->bi_io_vec[0].bv_page = bh->b_page;
+	bvec_set_page(&bio->bi_io_vec[0], bh->b_page);
 	bio->bi_io_vec[0].bv_len = bh->b_size;
 	bio->bi_io_vec[0].bv_offset = bh_offset(bh);
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index e181b6b2e297..5b90390481b0 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -467,7 +467,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
-			struct page *page = bvec->bv_page;
+			struct page *page = bvec_page(bvec);
 
 			if (dio->rw == READ && !PageCompound(page))
 				set_page_dirty_lock(page);
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 7bd8ac8dfb28..4bd44bfed847 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -411,9 +411,9 @@ static void _clear_bio(struct bio *bio)
 		unsigned this_count = bv->bv_len;
 
 		if (likely(PAGE_SIZE == this_count))
-			clear_highpage(bv->bv_page);
+			clear_highpage(bvec_page(bv));
 		else
-			zero_user(bv->bv_page, bv->bv_offset, this_count);
+			zero_user(bvec_page(bv), bv->bv_offset, this_count);
 	}
 }
 
diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
index 27cbdb697649..da76728824e6 100644
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -438,7 +438,7 @@ static void _mark_read4write_pages_uptodate(struct ore_io_state *ios, int ret)
 			continue;
 
 		bio_for_each_segment_all(bv, bio, i) {
-			struct page *page = bv->bv_page;
+			struct page *page = bvec_page(bv);
 
 			SetPageUptodate(page);
 			if (PageError(page))
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b24a2541a9ba..289564c6aeec 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -68,7 +68,7 @@ static void ext4_finish_bio(struct bio *bio)
 	struct bio_vec *bvec;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 		struct buffer_head *bh, *head;
 		unsigned bio_start = bvec->bv_offset;
 		unsigned bio_end = bio_start + bvec->bv_len;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 985ed023a750..b8e2d8a1a0d3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -31,7 +31,7 @@ static void f2fs_read_end_io(struct bio *bio, int err)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (!err) {
 			SetPageUptodate(page);
@@ -51,7 +51,7 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (unlikely(err)) {
 			set_page_dirty(page);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index daee4ab913da..7fd8f1555e32 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1307,7 +1307,7 @@ static inline bool is_merged_page(struct f2fs_sb_info *sbi,
 		goto out;
 
 	bio_for_each_segment_all(bvec, io->bio, i) {
-		if (page == bvec->bv_page) {
+		if (page == bvec_page(bvec)) {
 			up_read(&io->io_rwsem);
 			return true;
 		}
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 2c1ae861dc94..2c1e14ca5971 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -173,7 +173,7 @@ static void gfs2_end_log_write_bh(struct gfs2_sbd *sdp, struct bio_vec *bvec,
 				  int error)
 {
 	struct buffer_head *bh, *next;
-	struct page *page = bvec->bv_page;
+	struct page *page = bvec_page(bvec);
 	unsigned size;
 
 	bh = page_buffers(page);
@@ -215,7 +215,7 @@ static void gfs2_end_log_write(struct bio *bio, int error)
 	}
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		page = bvec->bv_page;
+		page = bvec_page(bvec);
 		if (page_has_buffers(page))
 			gfs2_end_log_write_bh(sdp, bvec, error);
 		else
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index bc462dcd7a40..4effe870b5aa 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1999,7 +1999,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
-	bio->bi_io_vec[0].bv_page = bp->l_page;
+	bvec_set_page(&bio->bi_io_vec[0], bp->l_page);
 	bio->bi_io_vec[0].bv_len = LOGPSIZE;
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
@@ -2145,7 +2145,7 @@ static void lbmStartIO(struct lbuf * bp)
 	bio = bio_alloc(GFP_NOFS, 1);
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
-	bio->bi_io_vec[0].bv_page = bp->l_page;
+	bvec_set_page(&bio->bi_io_vec[0], bp->l_page);
 	bio->bi_io_vec[0].bv_len = LOGPSIZE;
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 76279e11982d..7daa0e336fdf 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -22,7 +22,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio_init(&bio);
 	bio.bi_max_vecs = 1;
 	bio.bi_io_vec = &bio_vec;
-	bio_vec.bv_page = page;
+	bvec_set_page(&bio_vec, page);
 	bio_vec.bv_len = PAGE_SIZE;
 	bio_vec.bv_offset = 0;
 	bio.bi_vcnt = 1;
@@ -65,8 +65,8 @@ static void writeseg_end_io(struct bio *bio, int err)
 	BUG_ON(err);
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		end_page_writeback(bvec->bv_page);
-		page_cache_release(bvec->bv_page);
+		end_page_writeback(bvec_page(bvec));
+		page_cache_release(bvec_page(bvec));
 	}
 	bio_put(bio);
 	if (atomic_dec_and_test(&super->s_pending_writes))
@@ -110,7 +110,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 		}
 		page = find_lock_page(mapping, index + i);
 		BUG_ON(!page);
-		bio->bi_io_vec[i].bv_page = page;
+		bvec_set_page(&bio->bi_io_vec[i], page);
 		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
 		bio->bi_io_vec[i].bv_offset = 0;
 
@@ -200,7 +200,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio = bio_alloc(GFP_NOFS, max_pages);
 			BUG_ON(!bio);
 		}
-		bio->bi_io_vec[i].bv_page = super->s_erase_page;
+		bvec_set_page(&bio->bi_io_vec[i], super->s_erase_page);
 		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
 		bio->bi_io_vec[i].bv_offset = 0;
 	}
diff --git a/fs/mpage.c b/fs/mpage.c
index 3e79220babac..c570a63e0913 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -48,7 +48,7 @@ static void mpage_end_io(struct bio *bio, int err)
 	int i;
 
 	bio_for_each_segment_all(bv, bio, i) {
-		struct page *page = bv->bv_page;
+		struct page *page = bvec_page(bv);
 		page_endio(page, bio_data_dir(bio), err);
 	}
 
diff --git a/fs/splice.c b/fs/splice.c
index 7968da96bebb..14a4e67c9d26 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -998,7 +998,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 				goto done;
 			}
 
-			array[n].bv_page = buf->page;
+			bvec_set_page(&array[n], buf->page);
 			array[n].bv_len = this_len;
 			array[n].bv_offset = buf->offset;
 			left -= this_len;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index da3a127c9958..f6a2427980f3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -490,7 +490,7 @@ static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 	 * balancing is a lot nicer this way
 	 */
 	local_irq_save(*flags);
-	addr = (unsigned long) kmap_atomic(bvec->bv_page);
+	addr = (unsigned long) kmap_atomic(bvec_page(bvec));
 
 	BUG_ON(addr & ~PAGE_MASK);
 
@@ -508,7 +508,7 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 #else
 static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 {
-	return page_address(bvec->bv_page) + bvec->bv_offset;
+	return page_address(bvec_page(bvec)) + bvec->bv_offset;
 }
 
 static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c294e3e25e37..3193a0b7051f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -26,6 +26,16 @@ struct bio_vec {
 	unsigned int	bv_offset;
 };
 
+static inline struct page *bvec_page(const struct bio_vec *bvec)
+{
+	return bvec->bv_page;
+}
+
+static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
+{
+	bvec->bv_page = page;
+}
+
 #ifdef CONFIG_BLOCK
 
 struct bvec_iter {
diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 9a58bc258810..f2824bacb84d 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -90,7 +90,7 @@ int hib_wait_on_bio_chain(struct bio **bio_chain)
 		struct page *page;
 
 		next_bio = bio->bi_private;
-		page = bio->bi_io_vec[0].bv_page;
+		page = bvec_page(&bio->bi_io_vec[0]);
 		wait_on_page_locked(page);
 		if (!PageUptodate(page) || PageError(page))
 			ret = -EIO;
diff --git a/mm/page_io.c b/mm/page_io.c
index e6045804c8d8..c540dbc6a9e5 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -33,7 +33,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 	if (bio) {
 		bio->bi_iter.bi_sector = map_swap_page(page, &bio->bi_bdev);
 		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
-		bio->bi_io_vec[0].bv_page = page;
+		bvec_set_page(&bio->bi_io_vec[0], page);
 		bio->bi_io_vec[0].bv_len = PAGE_SIZE;
 		bio->bi_io_vec[0].bv_offset = 0;
 		bio->bi_vcnt = 1;
@@ -46,7 +46,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 void end_swap_bio_write(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct page *page = bio->bi_io_vec[0].bv_page;
+	struct page *page = bvec_page(&bio->bi_io_vec[0]);
 
 	if (!uptodate) {
 		SetPageError(page);
@@ -72,7 +72,7 @@ void end_swap_bio_write(struct bio *bio, int err)
 void end_swap_bio_read(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct page *page = bio->bi_io_vec[0].bv_page;
+	struct page *page = bvec_page(&bio->bi_io_vec[0]);
 
 	if (!uptodate) {
 		SetPageError(page);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 6b3f54ed65ba..6babe3b8dd98 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -846,7 +846,7 @@ static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(*length > cursor->resid);
 	BUG_ON(*page_offset + *length > PAGE_SIZE);
 
-	return bio_vec.bv_page;
+	return bvec_page(&bio_vec);
 }
 
 static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,

