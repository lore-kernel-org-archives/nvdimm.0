From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 10/16] bvec: massive conversion of all bv_page users
Date: Wed, 24 May 2017 15:42:21 -0600
Message-ID: <1495662147-18277-11-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1495662147-18277-1-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Convert all uses of bv_page to bvec_page and bvec_set page as introduced
in the previous patch.

This is mostly done with the following coccinelle script plus some
additional fussing by hand.

@@
expression bv;
expression x;
@@
-bv->bv_page = x;
+bvec_set_page(bv, x);

@@
expression bv;
expression x;
@@
-bv.bv_page = x;
+bvec_set_page(&bv, x);

@@
expression bv;
@@
-bv->bv_page
+bvec_page(bv)

@@
expression bv;
@@
-bv.bv_page
+bvec_page(&bv)

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 arch/powerpc/sysdev/axonram.c                      |  2 +-
 block/bio-integrity.c                              |  8 ++--
 block/bio.c                                        | 46 +++++++++++-----------
 block/blk-core.c                                   |  2 +-
 block/blk-integrity.c                              |  3 +-
 block/blk-lib.c                                    |  2 +-
 block/blk-merge.c                                  |  4 +-
 block/blk-zoned.c                                  |  6 +--
 block/bounce.c                                     | 27 +++++++------
 drivers/block/aoe/aoecmd.c                         |  4 +-
 drivers/block/brd.c                                |  3 +-
 drivers/block/drbd/drbd_bitmap.c                   |  6 +--
 drivers/block/drbd/drbd_main.c                     |  4 +-
 drivers/block/drbd/drbd_receiver.c                 |  4 +-
 drivers/block/drbd/drbd_worker.c                   |  3 +-
 drivers/block/floppy.c                             |  4 +-
 drivers/block/loop.c                               | 12 +++---
 drivers/block/ps3disk.c                            |  2 +-
 drivers/block/ps3vram.c                            |  2 +-
 drivers/block/rbd.c                                |  2 +-
 drivers/block/rsxx/dma.c                           |  3 +-
 drivers/block/umem.c                               |  2 +-
 drivers/block/zram/zram_drv.c                      | 14 +++----
 drivers/lightnvm/pblk-core.c                       |  2 +-
 drivers/lightnvm/pblk-read.c                       |  6 +--
 drivers/md/bcache/btree.c                          |  2 +-
 drivers/md/bcache/debug.c                          |  4 +-
 drivers/md/bcache/request.c                        |  4 +-
 drivers/md/bcache/super.c                          | 10 ++---
 drivers/md/bcache/util.c                           |  6 +--
 drivers/md/dm-crypt.c                              | 18 +++++----
 drivers/md/dm-integrity.c                          | 18 ++++-----
 drivers/md/dm-io.c                                 |  2 +-
 drivers/md/dm-log-writes.c                         | 12 +++---
 drivers/md/dm-verity-target.c                      |  4 +-
 drivers/md/raid5.c                                 | 10 +++--
 drivers/nvdimm/blk.c                               |  4 +-
 drivers/nvdimm/btt.c                               |  5 ++-
 drivers/nvdimm/pmem.c                              |  2 +-
 drivers/nvme/host/core.c                           |  2 +-
 drivers/nvme/host/nvme.h                           |  2 +-
 drivers/nvme/host/pci.c                            |  2 +-
 drivers/s390/block/dasd_diag.c                     |  2 +-
 drivers/s390/block/dasd_eckd.c                     | 14 +++----
 drivers/s390/block/dasd_fba.c                      |  6 +--
 drivers/s390/block/dcssblk.c                       |  2 +-
 drivers/s390/block/scm_blk.c                       |  2 +-
 drivers/s390/block/scm_blk_cluster.c               |  2 +-
 drivers/s390/block/xpram.c                         |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |  6 +--
 drivers/scsi/sd.c                                  | 16 ++++----
 drivers/scsi/sd_dif.c                              |  4 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  2 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib.c        | 10 ++---
 drivers/staging/lustre/lnet/lnet/lib-move.c        |  4 +-
 drivers/staging/lustre/lnet/lnet/router.c          |  6 +--
 drivers/staging/lustre/lnet/selftest/brw_test.c    |  4 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      | 10 ++---
 drivers/staging/lustre/lnet/selftest/framework.c   |  2 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |  4 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |  2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |  6 +--
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   |  4 +-
 drivers/target/target_core_file.c                  |  4 +-
 drivers/xen/biomerge.c                             |  4 +-
 fs/9p/vfs_addr.c                                   |  6 ++-
 fs/afs/rxrpc.c                                     |  4 +-
 fs/block_dev.c                                     |  8 ++--
 fs/btrfs/check-integrity.c                         |  4 +-
 fs/btrfs/compression.c                             | 14 +++----
 fs/btrfs/disk-io.c                                 |  4 +-
 fs/btrfs/extent_io.c                               |  8 ++--
 fs/btrfs/file-item.c                               |  8 ++--
 fs/btrfs/inode.c                                   | 14 +++----
 fs/btrfs/raid56.c                                  |  4 +-
 fs/buffer.c                                        |  2 +-
 fs/cifs/connect.c                                  |  3 +-
 fs/cifs/file.c                                     |  6 +--
 fs/cifs/misc.c                                     |  2 +-
 fs/cifs/smb2ops.c                                  |  2 +-
 fs/cifs/transport.c                                |  3 +-
 fs/crypto/bio.c                                    |  2 +-
 fs/direct-io.c                                     |  2 +-
 fs/exofs/ore.c                                     |  4 +-
 fs/exofs/ore_raid.c                                |  2 +-
 fs/ext4/page-io.c                                  |  2 +-
 fs/ext4/readpage.c                                 |  2 +-
 fs/f2fs/data.c                                     | 12 +++---
 fs/gfs2/lops.c                                     |  4 +-
 fs/gfs2/meta_io.c                                  |  2 +-
 fs/iomap.c                                         |  2 +-
 fs/mpage.c                                         |  2 +-
 fs/orangefs/inode.c                                |  3 +-
 fs/splice.c                                        |  2 +-
 fs/xfs/xfs_aops.c                                  |  2 +-
 include/linux/bio.h                                | 10 ++---
 include/linux/bvec.h                               |  2 +-
 kernel/power/swap.c                                |  2 +-
 lib/iov_iter.c                                     | 24 +++++------
 mm/page_io.c                                       |  8 ++--
 net/ceph/messenger.c                               |  6 +--
 103 files changed, 303 insertions(+), 286 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index a7fe5fe..689024b 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -126,7 +126,7 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 			return BLK_QC_T_NONE;
 		}
 
-		user_mem = page_address(vec.bv_page) + vec.bv_offset;
+		user_mem = page_address(bvec_page(&vec)) + vec.bv_offset;
 		if (bio_data_dir(bio) == READ)
 			memcpy(user_mem, (void *) phys_mem, vec.bv_len);
 		else
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5384713..5e49606 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -108,7 +108,7 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_set *bs = bio->bi_pool;
 
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
-		kfree(page_address(bip->bip_vec->bv_page) +
+		kfree(page_address(bvec_page(bip->bip_vec)) +
 		      bip->bip_vec->bv_offset);
 
 	if (bs && bs->bio_integrity_pool) {
@@ -150,7 +150,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 			     &bip->bip_vec[bip->bip_vcnt - 1], offset))
 		return 0;
 
-	iv->bv_page = page;
+	bvec_set_page(iv, page);
 	iv->bv_len = len;
 	iv->bv_offset = offset;
 	bip->bip_vcnt++;
@@ -230,7 +230,7 @@ static int bio_integrity_process(struct bio *bio,
 	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	unsigned int ret = 0;
-	void *prot_buf = page_address(bip->bip_vec->bv_page) +
+	void *prot_buf = page_address(bvec_page(bip->bip_vec)) +
 		bip->bip_vec->bv_offset;
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
@@ -239,7 +239,7 @@ static int bio_integrity_process(struct bio *bio,
 	iter.prot_buf = prot_buf;
 
 	bio_for_each_segment(bv, bio, bviter) {
-		void *kaddr = kmap_atomic(bv.bv_page);
+		void *kaddr = kmap_atomic(bvec_page(&bv));
 
 		iter.data_buf = kaddr + bv.bv_offset;
 		iter.data_size = bv.bv_len;
diff --git a/block/bio.c b/block/bio.c
index 888e780..e785f50 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -532,7 +532,7 @@ void zero_fill_bio(struct bio *bio)
 	bio_for_each_segment(bv, bio, iter) {
 		char *data = bvec_kmap_irq(&bv, &flags);
 		memset(data, 0, bv.bv_len);
-		flush_dcache_page(bv.bv_page);
+		flush_dcache_page(bvec_page(&bv));
 		bvec_kunmap_irq(data, &flags);
 	}
 }
@@ -747,7 +747,7 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == prev->bv_page &&
+		if (page == bvec_page(prev) &&
 		    offset == prev->bv_offset + prev->bv_len) {
 			prev->bv_len += len;
 			bio->bi_iter.bi_size += len;
@@ -770,7 +770,7 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 	 * cannot add the page
 	 */
 	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
+	bvec_set_page(bvec, page);
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
@@ -799,7 +799,7 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 	return len;
 
  failed:
-	bvec->bv_page = NULL;
+	bvec_set_page(bvec, NULL);
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
@@ -838,7 +838,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 	if (bio->bi_vcnt > 0) {
 		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bv->bv_page &&
+		if (page == bvec_page(bv) &&
 		    offset == bv->bv_offset + bv->bv_len) {
 			bv->bv_len += len;
 			goto done;
@@ -849,7 +849,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 		return 0;
 
 	bv		= &bio->bi_io_vec[bio->bi_vcnt];
-	bv->bv_page	= page;
+	bvec_set_page(bv, page);
 	bv->bv_len	= len;
 	bv->bv_offset	= offset;
 
@@ -894,7 +894,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 	diff = (nr_pages * PAGE_SIZE - offset) - size;
 	while (nr_pages--) {
-		bv[nr_pages].bv_page = pages[nr_pages];
+		bvec_set_page(&bv[nr_pages], pages[nr_pages]);
 		bv[nr_pages].bv_len = PAGE_SIZE;
 		bv[nr_pages].bv_offset = 0;
 	}
@@ -980,10 +980,10 @@ int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
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
@@ -1036,8 +1036,8 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 
 		bytes = min(src_bv.bv_len, dst_bv.bv_len);
 
-		src_p = kmap_atomic(src_bv.bv_page);
-		dst_p = kmap_atomic(dst_bv.bv_page);
+		src_p = kmap_atomic(bvec_page(&src_bv));
+		dst_p = kmap_atomic(bvec_page(&dst_bv));
 
 		memcpy(dst_p + dst_bv.bv_offset,
 		       src_p + src_bv.bv_offset,
@@ -1084,7 +1084,7 @@ static int bio_copy_from_iter(struct bio *bio, struct iov_iter iter)
 	bio_for_each_segment_all(bvec, bio, i) {
 		ssize_t ret;
 
-		ret = copy_page_from_iter(bvec->bv_page,
+		ret = copy_page_from_iter(bvec_page(bvec),
 					  bvec->bv_offset,
 					  bvec->bv_len,
 					  &iter);
@@ -1115,7 +1115,7 @@ static int bio_copy_to_iter(struct bio *bio, struct iov_iter iter)
 	bio_for_each_segment_all(bvec, bio, i) {
 		ssize_t ret;
 
-		ret = copy_page_to_iter(bvec->bv_page,
+		ret = copy_page_to_iter(bvec_page(bvec),
 					bvec->bv_offset,
 					bvec->bv_len,
 					&iter);
@@ -1136,7 +1136,7 @@ void bio_free_pages(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i)
-		__free_page(bvec->bv_page);
+		__free_page(bvec_page(bvec));
 }
 EXPORT_SYMBOL(bio_free_pages);
 
@@ -1432,9 +1432,9 @@ static void __bio_unmap_user(struct bio *bio)
 	 */
 	bio_for_each_segment_all(bvec, bio, i) {
 		if (bio_data_dir(bio) == READ)
-			set_page_dirty_lock(bvec->bv_page);
+			set_page_dirty_lock(bvec_page(bvec));
 
-		put_page(bvec->bv_page);
+		put_page(bvec_page(bvec));
 	}
 
 	bio_put(bio);
@@ -1524,7 +1524,7 @@ static void bio_copy_kern_endio_read(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		memcpy(p, page_address(bvec->bv_page), bvec->bv_len);
+		memcpy(p, page_address(bvec_page(bvec)), bvec->bv_len);
 		p += bvec->bv_len;
 	}
 
@@ -1634,7 +1634,7 @@ void bio_set_pages_dirty(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (page && !PageCompound(page))
 			set_page_dirty_lock(page);
@@ -1647,7 +1647,7 @@ static void bio_release_pages(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (page)
 			put_page(page);
@@ -1701,11 +1701,11 @@ void bio_check_pages_dirty(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (PageDirty(page) || PageCompound(page)) {
 			put_page(page);
-			bvec->bv_page = NULL;
+			bvec_set_page(bvec, NULL);
 		} else {
 			nr_clean_pages++;
 		}
@@ -1759,7 +1759,7 @@ void bio_flush_dcache_pages(struct bio *bi)
 	struct bvec_iter iter;
 
 	bio_for_each_segment(bvec, bi, iter)
-		flush_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec_page(&bvec));
 }
 EXPORT_SYMBOL(bio_flush_dcache_pages);
 #endif
diff --git a/block/blk-core.c b/block/blk-core.c
index c706852..2a8d89e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2935,7 +2935,7 @@ void rq_flush_dcache_pages(struct request *rq)
 	struct bio_vec bvec;
 
 	rq_for_each_segment(bvec, rq, iter)
-		flush_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec_page(&bvec));
 }
 EXPORT_SYMBOL_GPL(rq_flush_dcache_pages);
 #endif
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 0f891a9..857138a 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -114,7 +114,8 @@ int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
 				sg = sg_next(sg);
 			}
 
-			sg_set_page(sg, iv.bv_page, iv.bv_len, iv.bv_offset);
+			sg_set_page(sg, bvec_page(&iv), iv.bv_len,
+				    iv.bv_offset);
 			segments++;
 		}
 
diff --git a/block/blk-lib.c b/block/blk-lib.c
index e8caecd..cb243e3 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -170,7 +170,7 @@ static int __blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev = bdev;
 		bio->bi_vcnt = 1;
-		bio->bi_io_vec->bv_page = page;
+		bvec_set_page(bio->bi_io_vec, page);
 		bio->bi_io_vec->bv_offset = 0;
 		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
 		bio_set_op_attrs(bio, REQ_OP_WRITE_SAME, 0);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3990ae4..65dcee9 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -412,7 +412,7 @@ __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
 			*sg = sg_next(*sg);
 		}
 
-		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
+		sg_set_page(*sg, bvec_page(bvec), nbytes, bvec->bv_offset);
 		(*nsegs)++;
 	}
 	*bvprv = *bvec;
@@ -422,7 +422,7 @@ static inline int __blk_bvec_map_sg(struct request_queue *q, struct bio_vec bv,
 		struct scatterlist *sglist, struct scatterlist **sg)
 {
 	*sg = sglist;
-	sg_set_page(*sg, bv.bv_page, bv.bv_len, bv.bv_offset);
+	sg_set_page(*sg, bvec_page(&bv), bv.bv_len, bv.bv_offset);
 	return 1;
 }
 
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 3bd15d8..35315f8 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -150,10 +150,10 @@ int blkdev_report_zones(struct block_device *bdev,
 	nr_rep = 0;
 	bio_for_each_segment_all(bv, bio, i) {
 
-		if (!bv->bv_page)
+		if (!bvec_page(bv))
 			break;
 
-		addr = kmap_atomic(bv->bv_page);
+		addr = kmap_atomic(bvec_page(bv));
 
 		/* Get header in the first page */
 		ofst = 0;
@@ -182,7 +182,7 @@ int blkdev_report_zones(struct block_device *bdev,
 	*nr_zones = nz;
 out:
 	bio_for_each_segment_all(bv, bio, i)
-		__free_page(bv->bv_page);
+		__free_page(bvec_page(bv));
 	bio_put(bio);
 
 	return ret;
diff --git a/block/bounce.c b/block/bounce.c
index 1cb5dd3..3b6996f 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -56,7 +56,7 @@ static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 	unsigned char *vto;
 
 	local_irq_save(flags);
-	vto = kmap_atomic(to->bv_page);
+	vto = kmap_atomic(bvec_page(to));
 	memcpy(vto + to->bv_offset, vfrom, to->bv_len);
 	kunmap_atomic(vto);
 	local_irq_restore(flags);
@@ -65,7 +65,8 @@ static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 #else /* CONFIG_HIGHMEM */
 
 #define bounce_copy_vec(to, vfrom)	\
-	memcpy(page_address((to)->bv_page) + (to)->bv_offset, vfrom, (to)->bv_len)
+	memcpy(page_address(bvec_page((to))) + (to)->bv_offset, vfrom, \
+	       (to)->bv_len)
 
 #endif /* CONFIG_HIGHMEM */
 
@@ -106,17 +107,17 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
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
@@ -136,11 +137,11 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool)
 	bio_for_each_segment_all(bvec, bio, i) {
 		org_vec = bio_orig->bi_io_vec + i + start;
 
-		if (bvec->bv_page == org_vec->bv_page)
+		if (bvec_page(bvec) == bvec_page(org_vec))
 			continue;
 
-		dec_zone_page_state(bvec->bv_page, NR_BOUNCE);
-		mempool_free(bvec->bv_page, pool);
+		dec_zone_page_state(bvec_page(bvec), NR_BOUNCE);
+		mempool_free(bvec_page(bvec), pool);
 	}
 
 	bio_orig->bi_error = bio->bi_error;
@@ -189,7 +190,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	unsigned i;
 
 	bio_for_each_segment(from, *bio_orig, iter)
-		if (page_to_pfn(from.bv_page) > queue_bounce_pfn(q))
+		if (page_to_pfn(bvec_page(&from)) > queue_bounce_pfn(q))
 			goto bounce;
 
 	return;
@@ -197,20 +198,20 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
 
 	bio_for_each_segment_all(to, bio, i) {
-		struct page *page = to->bv_page;
+		struct page *page = bvec_page(to);
 
 		if (page_to_pfn(page) <= queue_bounce_pfn(q))
 			continue;
 
-		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
-		inc_zone_page_state(to->bv_page, NR_BOUNCE);
+		bvec_set_page(to, mempool_alloc(pool, q->bounce_gfp));
+		inc_zone_page_state(bvec_page(to), NR_BOUNCE);
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
 
 			flush_dcache_page(page);
 
-			vto = page_address(to->bv_page) + to->bv_offset;
+			vto = page_address(bvec_page(to)) + to->bv_offset;
 			vfrom = kmap_atomic(page) + to->bv_offset;
 			memcpy(vto, vfrom, to->bv_len);
 			kunmap_atomic(vfrom);
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 3c606c0..aa6773e 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -300,7 +300,7 @@ skb_fillup(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter)
 	struct bio_vec bv;
 
 	__bio_for_each_segment(bv, bio, iter, iter)
-		skb_fill_page_desc(skb, frag++, bv.bv_page,
+		skb_fill_page_desc(skb, frag++, bvec_page(&bv),
 				   bv.bv_offset, bv.bv_len);
 }
 
@@ -1052,7 +1052,7 @@ bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
 	iter.bi_size = cnt;
 
 	__bio_for_each_segment(bv, bio, iter, iter) {
-		char *p = page_address(bv.bv_page) + bv.bv_offset;
+		char *p = page_address(bvec_page(&bv)) + bv.bv_offset;
 		skb_copy_bits(skb, soff, p, bv.bv_len);
 		soff += bv.bv_len;
 	}
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 57b574f..3920436 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -306,7 +306,8 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 		unsigned int len = bvec.bv_len;
 		int err;
 
-		err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
+		err = brd_do_bvec(brd, bvec_page(&bvec), len,
+				  bvec.bv_offset,
 					op_is_write(bio_op(bio)), sector);
 		if (err)
 			goto io_error;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index a804a41..324cddc 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -947,13 +947,13 @@ static void drbd_bm_aio_ctx_destroy(struct kref *kref)
 	kfree(ctx);
 }
 
-/* bv_page may be a copy, or may be the original */
+/* bvec_page may be a copy, or may be the original */
 static void drbd_bm_endio(struct bio *bio)
 {
 	struct drbd_bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_device *device = ctx->device;
 	struct drbd_bitmap *b = device->bitmap;
-	unsigned int idx = bm_page_to_idx(bio->bi_io_vec[0].bv_page);
+	unsigned int idx = bm_page_to_idx(bvec_page(bio->bi_io_vec));
 
 	if ((ctx->flags & BM_AIO_COPY_PAGES) == 0 &&
 	    !bm_test_page_unchanged(b->bm_pages[idx]))
@@ -977,7 +977,7 @@ static void drbd_bm_endio(struct bio *bio)
 	bm_page_unlock_io(device, idx);
 
 	if (ctx->flags & BM_AIO_COPY_PAGES)
-		mempool_free(bio->bi_io_vec[0].bv_page, drbd_md_io_page_pool);
+		mempool_free(bvec_page(bio->bi_io_vec), drbd_md_io_page_pool);
 
 	bio_put(bio);
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 84455c3..407cb37 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1604,7 +1604,7 @@ static int _drbd_send_bio(struct drbd_peer_device *peer_device, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_no_send_page(peer_device, bvec.bv_page,
+		err = _drbd_no_send_page(peer_device, bvec_page(&bvec),
 					 bvec.bv_offset, bvec.bv_len,
 					 bio_iter_last(bvec, iter)
 					 ? 0 : MSG_MORE);
@@ -1626,7 +1626,7 @@ static int _drbd_send_zc_bio(struct drbd_peer_device *peer_device, struct bio *b
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_send_page(peer_device, bvec.bv_page,
+		err = _drbd_send_page(peer_device, bvec_page(&bvec),
 				      bvec.bv_offset, bvec.bv_len,
 				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1b0a2be..2323a85 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1878,10 +1878,10 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
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
index 1afcb4e..719d025 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -327,7 +327,8 @@ void drbd_csum_bio(struct crypto_ahash *tfm, struct bio *bio, void *digest)
 	crypto_ahash_init(req);
 
 	bio_for_each_segment(bvec, bio, iter) {
-		sg_set_page(&sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
+		sg_set_page(&sg, bvec_page(&bvec), bvec.bv_len,
+			    bvec.bv_offset);
 		ahash_request_set_crypt(req, &sg, NULL, sg.length);
 		crypto_ahash_update(req);
 		/* REQ_OP_WRITE_SAME has only one segment,
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 60d4c76..43f33c4 100644
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
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 28d9329..f41c91a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -315,12 +315,12 @@ static int lo_write_transfer(struct loop_device *lo, struct request *rq,
 		return -ENOMEM;
 
 	rq_for_each_segment(bvec, rq, iter) {
-		ret = lo_do_transfer(lo, WRITE, page, 0, bvec.bv_page,
+		ret = lo_do_transfer(lo, WRITE, page, 0, bvec_page(&bvec),
 			bvec.bv_offset, bvec.bv_len, pos >> 9);
 		if (unlikely(ret))
 			break;
 
-		b.bv_page = page;
+		bvec_set_page(&b, page);
 		b.bv_offset = 0;
 		b.bv_len = bvec.bv_len;
 		ret = lo_write_bvec(lo->lo_backing_file, &b, &pos);
@@ -346,7 +346,7 @@ static int lo_read_simple(struct loop_device *lo, struct request *rq,
 		if (len < 0)
 			return len;
 
-		flush_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec_page(&bvec));
 
 		if (len != bvec.bv_len) {
 			struct bio *bio;
@@ -378,7 +378,7 @@ static int lo_read_transfer(struct loop_device *lo, struct request *rq,
 	rq_for_each_segment(bvec, rq, iter) {
 		loff_t offset = pos;
 
-		b.bv_page = page;
+		bvec_set_page(&b, page);
 		b.bv_offset = 0;
 		b.bv_len = bvec.bv_len;
 
@@ -389,12 +389,12 @@ static int lo_read_transfer(struct loop_device *lo, struct request *rq,
 			goto out_free_page;
 		}
 
-		ret = lo_do_transfer(lo, READ, page, 0, bvec.bv_page,
+		ret = lo_do_transfer(lo, READ, page, 0, bvec_page(&bvec),
 			bvec.bv_offset, len, offset >> 9);
 		if (ret)
 			goto out_free_page;
 
-		flush_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec_page(&bvec));
 
 		if (len != bvec.bv_len) {
 			struct bio *bio;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index a809e3e..a0f9dd5 100644
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
index 456b4fe..51a3ab4 100644
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
index 454bf9c..f1c8884 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1310,7 +1310,7 @@ static void zero_bio_chain(struct bio *chain, int start_ofs)
 				buf = bvec_kmap_irq(&bv, &flags);
 				memset(buf + remainder, 0,
 				       bv.bv_len - remainder);
-				flush_dcache_page(bv.bv_page);
+				flush_dcache_page(bvec_page(&bv));
 				bvec_kunmap_irq(buf, &flags);
 			}
 			pos += bv.bv_len;
diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index 5a20385f8..7580b03 100644
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
index c141cc3..df2960b 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -364,7 +364,7 @@ static int add_bio(struct cardinfo *card)
 	vec = bio_iter_iovec(bio, card->current_iter);
 
 	dma_handle = pci_map_page(card->dev,
-				  vec.bv_page,
+				  bvec_page(&vec),
 				  vec.bv_offset,
 				  vec.bv_len,
 				  bio_op(bio) == REQ_OP_READ ?
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index debee95..91bba11 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -584,7 +584,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	int ret;
 	struct page *page;
 
-	page = bvec->bv_page;
+	page = bvec_page(bvec);
 	if (is_partial_io(bvec)) {
 		/* Use a temporary buffer to decompress the page */
 		page = alloc_page(GFP_NOIO|__GFP_HIGHMEM);
@@ -597,7 +597,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		goto out;
 
 	if (is_partial_io(bvec)) {
-		void *dst = kmap_atomic(bvec->bv_page);
+		void *dst = kmap_atomic(bvec_page(bvec));
 		void *src = kmap_atomic(page);
 
 		memcpy(dst + bvec->bv_offset, src + offset, bvec->bv_len);
@@ -687,7 +687,7 @@ static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 	unsigned int comp_len;
 	void *src, *dst;
 	struct zcomp_strm *zstrm;
-	struct page *page = bvec->bv_page;
+	struct page *page = bvec_page(bvec);
 
 	if (zram_same_page_write(zram, index, page))
 		return 0;
@@ -750,13 +750,13 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 		if (ret)
 			goto out;
 
-		src = kmap_atomic(bvec->bv_page);
+		src = kmap_atomic(bvec_page(bvec));
 		dst = kmap_atomic(page);
 		memcpy(dst + offset, src + bvec->bv_offset, bvec->bv_len);
 		kunmap_atomic(dst);
 		kunmap_atomic(src);
 
-		vec.bv_page = page;
+		bvec_set_page(&vec, page);
 		vec.bv_len = PAGE_SIZE;
 		vec.bv_offset = 0;
 	}
@@ -819,7 +819,7 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 	if (!is_write) {
 		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset);
-		flush_dcache_page(bvec->bv_page);
+		flush_dcache_page(bvec_page(bvec));
 	} else {
 		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset);
@@ -936,7 +936,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	index = sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = (sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
-	bv.bv_page = page;
+	bvec_set_page(&bv, page);
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
diff --git a/drivers/lightnvm/pblk-core.c b/drivers/lightnvm/pblk-core.c
index 5e44768..55fc7a7 100644
--- a/drivers/lightnvm/pblk-core.c
+++ b/drivers/lightnvm/pblk-core.c
@@ -205,7 +205,7 @@ void pblk_bio_free_pages(struct pblk *pblk, struct bio *bio, int off,
 	bio_advance(bio, off * PBLK_EXPOSED_PAGE_SIZE);
 	for (i = off; i < nr_pages + off; i++) {
 		bv = bio->bi_io_vec[i];
-		mempool_free(bv.bv_page, pblk->page_pool);
+		mempool_free(bvec_page(&bv), pblk->page_pool);
 	}
 }
 
diff --git a/drivers/lightnvm/pblk-read.c b/drivers/lightnvm/pblk-read.c
index 4a12f14..e11178c 100644
--- a/drivers/lightnvm/pblk-read.c
+++ b/drivers/lightnvm/pblk-read.c
@@ -212,8 +212,8 @@ static int pblk_fill_partial_read_bio(struct pblk *pblk, struct nvm_rq *rqd,
 		src_bv = new_bio->bi_io_vec[i++];
 		dst_bv = bio->bi_io_vec[bio_init_idx + hole];
 
-		src_p = kmap_atomic(src_bv.bv_page);
-		dst_p = kmap_atomic(dst_bv.bv_page);
+		src_p = kmap_atomic(bvec_page(&src_bv));
+		dst_p = kmap_atomic(bvec_page(&dst_bv));
 
 		memcpy(dst_p + dst_bv.bv_offset,
 			src_p + src_bv.bv_offset,
@@ -222,7 +222,7 @@ static int pblk_fill_partial_read_bio(struct pblk *pblk, struct nvm_rq *rqd,
 		kunmap_atomic(src_p);
 		kunmap_atomic(dst_p);
 
-		mempool_free(src_bv.bv_page, pblk->page_pool);
+		mempool_free(bvec_page(&src_bv), pblk->page_pool);
 
 		hole = find_next_zero_bit(read_bitmap, nr_secs, hole + 1);
 	} while (hole < nr_secs);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 450d0e8..677e1e5 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -424,7 +424,7 @@ static void do_btree_node_write(struct btree *b)
 		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
 
 		bio_for_each_segment_all(bv, b->bio, j)
-			memcpy(page_address(bv->bv_page),
+			memcpy(page_address(bvec_page(bv)),
 			       base + j * PAGE_SIZE, PAGE_SIZE);
 
 		bch_submit_bbio(b->bio, b->c, &k.key, 0);
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 06f5505..c1610ab 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -122,11 +122,11 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 
 	citer.bi_size = UINT_MAX;
 	bio_for_each_segment(bv, bio, iter) {
-		void *p1 = kmap_atomic(bv.bv_page);
+		void *p1 = kmap_atomic(bvec_page(&bv));
 		void *p2;
 
 		cbv = bio_iter_iovec(check, citer);
-		p2 = page_address(cbv.bv_page);
+		p2 = page_address(bvec_page(&cbv));
 
 		cache_set_err_on(memcmp(p1 + bv.bv_offset,
 					p2 + bv.bv_offset,
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 709c9cc..d3ec594 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -43,9 +43,9 @@ static void bio_csum(struct bio *bio, struct bkey *k)
 	uint64_t csum = 0;
 
 	bio_for_each_segment(bv, bio, iter) {
-		void *d = kmap(bv.bv_page) + bv.bv_offset;
+		void *d = kmap(bvec_page(&bv)) + bv.bv_offset;
 		csum = bch_crc64_update(csum, d, bv.bv_len);
-		kunmap(bv.bv_page);
+		kunmap(bvec_page(&bv));
 	}
 
 	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e57353e..0159cac 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -208,7 +208,7 @@ static void write_bdev_super_endio(struct bio *bio)
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
-	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page);
+	struct cache_sb *out = page_address(bvec_page(bio->bi_io_vec));
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
@@ -1152,7 +1152,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev->bd_holder = dc;
 
 	bio_init(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
-	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	bvec_set_page(dc->sb_bio.bi_io_vec, sb_page);
 	get_page(sb_page);
 
 	if (cached_dev_init(dc, sb->block_size << 9))
@@ -1795,8 +1795,8 @@ void bch_cache_release(struct kobject *kobj)
 	for (i = 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
 
-	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
+	if (bvec_page(ca->sb_bio.bi_inline_vecs))
+		put_page(bvec_page(ca->sb_bio.bi_io_vec));
 
 	if (!IS_ERR_OR_NULL(ca->bdev))
 		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -1850,7 +1850,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev->bd_holder = ca;
 
 	bio_init(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
-	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	bvec_set_page(ca->sb_bio.bi_io_vec, sb_page);
 	get_page(sb_page);
 
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 8c3a938..ceae67d 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -239,9 +239,9 @@ void bch_bio_map(struct bio *bio, void *base)
 start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
 					size);
 		if (base) {
-			bv->bv_page = is_vmalloc_addr(base)
-				? vmalloc_to_page(base)
-				: virt_to_page(base);
+			bvec_set_page(bv, is_vmalloc_addr(base) ?
+				      vmalloc_to_page(base) :
+				      virt_to_page(base));
 
 			base += bv->bv_len;
 		}
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ebf9e72..a10a9c7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1089,13 +1089,15 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	sg_init_table(dmreq->sg_in, 4);
 	sg_set_buf(&dmreq->sg_in[0], sector, sizeof(uint64_t));
 	sg_set_buf(&dmreq->sg_in[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_in[2], bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	sg_set_page(&dmreq->sg_in[2], bvec_page(&bv_in), cc->sector_size,
+		    bv_in.bv_offset);
 	sg_set_buf(&dmreq->sg_in[3], tag, cc->integrity_tag_size);
 
 	sg_init_table(dmreq->sg_out, 4);
 	sg_set_buf(&dmreq->sg_out[0], sector, sizeof(uint64_t));
 	sg_set_buf(&dmreq->sg_out[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_out[2], bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+	sg_set_page(&dmreq->sg_out[2], bvec_page(&bv_out), cc->sector_size,
+		    bv_out.bv_offset);
 	sg_set_buf(&dmreq->sg_out[3], tag, cc->integrity_tag_size);
 
 	if (cc->iv_gen_ops) {
@@ -1178,10 +1180,12 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	sg_out = &dmreq->sg_out[0];
 
 	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	sg_set_page(sg_in, bvec_page(&bv_in), cc->sector_size,
+		    bv_in.bv_offset);
 
 	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+	sg_set_page(sg_out, bvec_page(&bv_out), cc->sector_size,
+		    bv_out.bv_offset);
 
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1431,9 +1435,9 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
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
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c7f7c8d..b11694c 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1250,7 +1250,7 @@ static void integrity_metadata(struct work_struct *w)
 			char *mem, *checksums_ptr;
 
 again:
-			mem = (char *)kmap_atomic(bv.bv_page) + bv.bv_offset;
+			mem = (char *)kmap_atomic(bvec_page(&bv)) + bv.bv_offset;
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
@@ -1301,8 +1301,8 @@ static void integrity_metadata(struct work_struct *w)
 				unsigned char *tag;
 				unsigned this_len;
 
-				BUG_ON(PageHighMem(biv.bv_page));
-				tag = lowmem_page_address(biv.bv_page) + biv.bv_offset;
+				BUG_ON(PageHighMem(bvec_page(&biv)));
+				tag = lowmem_page_address(bvec_page(&biv)) + biv.bv_offset;
 				this_len = min(biv.bv_len, data_to_process);
 				r = dm_integrity_rw_tag(ic, tag, &dio->metadata_block, &dio->metadata_offset,
 							this_len, !dio->write ? TAG_READ : TAG_WRITE);
@@ -1422,9 +1422,9 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 		n_sectors -= bv.bv_len >> SECTOR_SHIFT;
 		bio_advance_iter(bio, &bio->bi_iter, bv.bv_len);
 retry_kmap:
-		mem = kmap_atomic(bv.bv_page);
+		mem = kmap_atomic(bvec_page(&bv));
 		if (likely(dio->write))
-			flush_dcache_page(bv.bv_page);
+			flush_dcache_page(bvec_page(&bv));
 
 		do {
 			struct journal_entry *je = access_journal_entry(ic, journal_section, journal_entry);
@@ -1435,7 +1435,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				unsigned s;
 
 				if (unlikely(journal_entry_is_inprogress(je))) {
-					flush_dcache_page(bv.bv_page);
+					flush_dcache_page(bvec_page(&bv));
 					kunmap_atomic(mem);
 
 					__io_wait_event(ic->copy_to_journal_wait, !journal_entry_is_inprogress(je));
@@ -1474,8 +1474,8 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 					struct bio_vec biv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
 					unsigned tag_now = min(biv.bv_len, tag_todo);
 					char *tag_addr;
-					BUG_ON(PageHighMem(biv.bv_page));
-					tag_addr = lowmem_page_address(biv.bv_page) + biv.bv_offset;
+					BUG_ON(PageHighMem(bvec_page(&biv)));
+					tag_addr = lowmem_page_address(bvec_page(&biv)) + biv.bv_offset;
 					if (likely(dio->write))
 						memcpy(tag_ptr, tag_addr, tag_now);
 					else
@@ -1526,7 +1526,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 		} while (bv.bv_len -= ic->sectors_per_block << SECTOR_SHIFT);
 
 		if (unlikely(!dio->write))
-			flush_dcache_page(bv.bv_page);
+			flush_dcache_page(bvec_page(&bv));
 		kunmap_atomic(mem);
 	} while (n_sectors);
 
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 3702e50..4d48bc2 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -210,7 +210,7 @@ static void bio_get_page(struct dpages *dp, struct page **p,
 	struct bio_vec bvec = bvec_iter_bvec((struct bio_vec *)dp->context_ptr,
 					     dp->context_bi);
 
-	*p = bvec.bv_page;
+	*p = bvec_page(&bvec);
 	*len = bvec.bv_len;
 	*offset = bvec.bv_offset;
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 4dfe386..9128e2c 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -174,8 +174,8 @@ static void free_pending_block(struct log_writes_c *lc,
 	int i;
 
 	for (i = 0; i < block->vec_cnt; i++) {
-		if (block->vecs[i].bv_page)
-			__free_page(block->vecs[i].bv_page);
+		if (bvec_page(block->vecs))
+			__free_page(bvec_page(block->vecs));
 	}
 	kfree(block->data);
 	kfree(block);
@@ -273,7 +273,7 @@ static int log_one_block(struct log_writes_c *lc,
 		 * The page offset is always 0 because we allocate a new page
 		 * for every bvec in the original bio for simplicity sake.
 		 */
-		ret = bio_add_page(bio, block->vecs[i].bv_page,
+		ret = bio_add_page(bio, bvec_page(block->vecs),
 				   block->vecs[i].bv_len, 0);
 		if (ret != block->vecs[i].bv_len) {
 			atomic_inc(&lc->io_blocks);
@@ -290,7 +290,7 @@ static int log_one_block(struct log_writes_c *lc,
 			bio->bi_private = lc;
 			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
-			ret = bio_add_page(bio, block->vecs[i].bv_page,
+			ret = bio_add_page(bio, bvec_page(block->vecs),
 					   block->vecs[i].bv_len, 0);
 			if (ret != block->vecs[i].bv_len) {
 				DMERR("Couldn't add page on new bio?");
@@ -642,12 +642,12 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 			return -ENOMEM;
 		}
 
-		src = kmap_atomic(bv.bv_page);
+		src = kmap_atomic(bvec_page(&bv));
 		dst = kmap_atomic(page);
 		memcpy(dst, src + bv.bv_offset, bv.bv_len);
 		kunmap_atomic(dst);
 		kunmap_atomic(src);
-		block->vecs[i].bv_page = page;
+		bvec_set_page(block->vecs, page);
 		block->vecs[i].bv_len = bv.bv_len;
 		block->vec_cnt++;
 		i++;
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 97de961..d444c7a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -412,7 +412,7 @@ int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
 		 * until you consider the typical block size is 4,096B.
 		 * Going through this loops twice should be very rare.
 		 */
-		sg_set_page(&sg, bv.bv_page, len, bv.bv_offset);
+		sg_set_page(&sg, bvec_page(&bv), len, bv.bv_offset);
 		ahash_request_set_crypt(req, &sg, NULL, len);
 		r = verity_complete_op(res, crypto_ahash_update(req));
 
@@ -447,7 +447,7 @@ int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 		unsigned len;
 		struct bio_vec bv = bio_iter_iovec(bio, *iter);
 
-		page = kmap_atomic(bv.bv_page);
+		page = kmap_atomic(bvec_page(&bv));
 		len = bv.bv_len;
 
 		if (likely(len >= todo))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9c4f765..6414176 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1128,9 +1128,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				 * must be preparing for prexor in rmw; read
 				 * the data into orig_page
 				 */
-				sh->dev[i].vec.bv_page = sh->dev[i].orig_page;
+				bvec_set_page(&sh->dev[i].vec,
+				              sh->dev[i].orig_page);
 			else
-				sh->dev[i].vec.bv_page = sh->dev[i].page;
+				bvec_set_page(&sh->dev[i].vec,
+				              sh->dev[i].page);
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
@@ -1181,7 +1183,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 						  + rrdev->data_offset);
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].rvec.bv_page = sh->dev[i].page;
+			bvec_set_page(&sh->dev[i].rvec, sh->dev[i].page);
 			rbi->bi_vcnt = 1;
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
@@ -1261,7 +1263,7 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 
 		if (clen > 0) {
 			b_offset += bvl.bv_offset;
-			bio_page = bvl.bv_page;
+			bio_page = bvec_page(&bvl);
 			if (frombio) {
 				if (sh->raid_conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 822198a..2506680 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -97,7 +97,7 @@ static int nd_blk_rw_integrity(struct nd_namespace_blk *nsblk,
 		 */
 
 		cur_len = min(len, bv.bv_len);
-		iobuf = kmap_atomic(bv.bv_page);
+		iobuf = kmap_atomic(bvec_page(&bv));
 		err = ndbr->do_io(ndbr, dev_offset, iobuf + bv.bv_offset,
 				cur_len, rw);
 		kunmap_atomic(iobuf);
@@ -198,7 +198,7 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 		unsigned int len = bvec.bv_len;
 
 		BUG_ON(len > PAGE_SIZE);
-		err = nsblk_do_bvec(nsblk, bip, bvec.bv_page, len,
+		err = nsblk_do_bvec(nsblk, bip, bvec_page(&bvec), len,
 				bvec.bv_offset, rw, iter.bi_sector);
 		if (err) {
 			dev_dbg(&nsblk->common.dev,
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 983718b..cb0dd13 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -969,7 +969,7 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
 		 */
 
 		cur_len = min(len, bv.bv_len);
-		mem = kmap_atomic(bv.bv_page);
+		mem = kmap_atomic(bvec_page(&bv));
 		if (rw)
 			ret = arena_write_bytes(arena, meta_nsoff,
 					mem + bv.bv_offset, cur_len,
@@ -1224,7 +1224,8 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 		BUG_ON(len < btt->sector_size);
 		BUG_ON(len % btt->sector_size);
 
-		err = btt_do_bvec(btt, bip, bvec.bv_page, len, bvec.bv_offset,
+		err = btt_do_bvec(btt, bip, bvec_page(&bvec), len,
+				  bvec.bv_offset,
 				  op_is_write(bio_op(bio)), iter.bi_sector);
 		if (err) {
 			dev_info(&btt->nd_btt->dev,
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c544d46..ad1fc10 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -162,7 +162,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
-		rc = pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
+		rc = pmem_do_bvec(pmem, bvec_page(&bvec), bvec.bv_len,
 				bvec.bv_offset, op_is_write(bio_op(bio)),
 				iter.bi_sector);
 		if (rc) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d5e0906..9ae0624 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -323,7 +323,7 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	cmnd->dsm.nr = cpu_to_le32(segments - 1);
 	cmnd->dsm.attributes = cpu_to_le32(NVME_DSMGMT_AD);
 
-	req->special_vec.bv_page = virt_to_page(range);
+	bvec_set_page(&req->special_vec, virt_to_page(range));
 	req->special_vec.bv_offset = offset_in_page(range);
 	req->special_vec.bv_len = sizeof(*range) * segments;
 	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 29c708c..bdbae9d 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -244,7 +244,7 @@ static inline u64 nvme_block_nr(struct nvme_ns *ns, sector_t sector)
 static inline void nvme_cleanup_cmd(struct request *req)
 {
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		kfree(page_address(req->special_vec.bv_page) +
+		kfree(page_address(bvec_page(&req->special_vec)) +
 		      req->special_vec.bv_offset);
 	}
 }
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4c2ff2b..adf4133 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -509,7 +509,7 @@ static void nvme_dif_remap(struct request *req,
 	if (!bip)
 		return;
 
-	pmap = kmap_atomic(bip->bip_vec->bv_page) + bip->bip_vec->bv_offset;
+	pmap = kmap_atomic(bvec_page(bip->bip_vec)) + bip->bip_vec->bv_offset;
 
 	p = pmap;
 	virt = bip_get_seed(bip);
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 5667146..9e31a3d 100644
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
index 122456e..db648a7 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3136,7 +3136,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 			/* Eckd can only do full blocks. */
 			return ERR_PTR(-EINVAL);
 		count += bv.bv_len >> (block->s2b_shift + 9);
-		if (idal_is_needed (page_address(bv.bv_page), bv.bv_len))
+		if (idal_is_needed (page_address(bvec_page(&bv)), bv.bv_len))
 			cidaw += bv.bv_len >> (block->s2b_shift + 9);
 	}
 	/* Paranoia. */
@@ -3207,7 +3207,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 			      last_rec - recid + 1, cmd, basedev, blksize);
 	}
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
@@ -3370,7 +3370,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_track(
 	idaw_dst = NULL;
 	idaw_len = 0;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		seg_len = bv.bv_len;
 		while (seg_len) {
 			if (new_track) {
@@ -3698,7 +3698,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		new_track = 1;
 		recid = first_rec;
 		rq_for_each_segment(bv, req, iter) {
-			dst = page_address(bv.bv_page) + bv.bv_offset;
+			dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 			seg_len = bv.bv_len;
 			while (seg_len) {
 				if (new_track) {
@@ -3731,7 +3731,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		}
 	} else {
 		rq_for_each_segment(bv, req, iter) {
-			dst = page_address(bv.bv_page) + bv.bv_offset;
+			dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 			last_tidaw = itcw_add_tidaw(itcw, 0x00,
 						    dst, bv.bv_len);
 			if (IS_ERR(last_tidaw)) {
@@ -3951,7 +3951,7 @@ static struct dasd_ccw_req *dasd_raw_build_cp(struct dasd_device *startdev,
 			idaws = idal_create_words(idaws, rawpadpage, PAGE_SIZE);
 	}
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		seg_len = bv.bv_len;
 		if (cmd == DASD_ECKD_CCW_READ_TRACK)
 			memset(dst, 0, seg_len);
@@ -4015,7 +4015,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	if (private->uses_cdl == 0 || recid > 2*blk_per_trk)
 		ccw++;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->uses_cdl && recid <= 2*blk_per_trk)
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 462cab5..0bf2c1e 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -283,7 +283,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 			/* Fba can only do full blocks. */
 			return ERR_PTR(-EINVAL);
 		count += bv.bv_len >> (block->s2b_shift + 9);
-		if (idal_is_needed (page_address(bv.bv_page), bv.bv_len))
+		if (idal_is_needed (page_address(bvec_page(&bv)), bv.bv_len))
 			cidaw += bv.bv_len / blksize;
 	}
 	/* Paranoia. */
@@ -320,7 +320,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 	}
 	recid = first_rec;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
@@ -392,7 +392,7 @@ dasd_fba_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	if (private->rdc_data.mode.bits.data_chain != 0)
 		ccw++;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv.bv_page) + bv.bv_offset;
+		dst = page_address(bvec_page(&bv)) + bv.bv_offset;
 		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->rdc_data.mode.bits.data_chain == 0)
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 36e5280..10121e4 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -877,7 +877,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	index = (bio->bi_iter.bi_sector >> 3);
 	bio_for_each_segment(bvec, bio, iter) {
 		page_addr = (unsigned long)
-			page_address(bvec.bv_page) + bvec.bv_offset;
+			page_address(bvec_page(&bvec)) + bvec.bv_offset;
 		source_addr = dev_info->start + (index<<12) + bytes_done;
 		if (unlikely((page_addr & 4095) != 0) || (bvec.bv_len & 4095) != 0)
 			// More paranoia.
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 152de68..45a9248 100644
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
index 7497ddde..a7e2fcb 100644
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
index b9d7e75..914bb67 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -204,7 +204,7 @@ static blk_qc_t xpram_make_request(struct request_queue *q, struct bio *bio)
 	index = (bio->bi_iter.bi_sector >> 3) + xdev->offset;
 	bio_for_each_segment(bvec, bio, iter) {
 		page_addr = (unsigned long)
-			kmap(bvec.bv_page) + bvec.bv_offset;
+			kmap(bvec_page(&bvec)) + bvec.bv_offset;
 		bytes = bvec.bv_len;
 		if ((page_addr & 4095) != 0 || (bytes & 4095) != 0)
 			/* More paranoia. */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e7a7a70..cca0d1b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1943,7 +1943,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 		bio_for_each_segment(bvec, req->bio, iter) {
 			memcpy(pci_addr_out + offset,
-			    page_address(bvec.bv_page) + bvec.bv_offset,
+			    page_address(bvec_page(&bvec)) + bvec.bv_offset,
 			    bvec.bv_len);
 			offset += bvec.bv_len;
 		}
@@ -2071,12 +2071,12 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
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
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f9d1432..ef02faa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -735,8 +735,8 @@ static int sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	unsigned int data_len = 24;
 	char *buf;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
-	if (!rq->special_vec.bv_page)
+	bvec_set_page(&rq->special_vec, alloc_page(GFP_ATOMIC | __GFP_ZERO));
+	if (!bvec_page(&rq->special_vec))
 		return BLKPREP_DEFER;
 	rq->special_vec.bv_offset = 0;
 	rq->special_vec.bv_len = data_len;
@@ -746,7 +746,7 @@ static int sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	cmd->cmnd[0] = UNMAP;
 	cmd->cmnd[8] = 24;
 
-	buf = page_address(rq->special_vec.bv_page);
+	buf = page_address(bvec_page(&rq->special_vec));
 	put_unaligned_be16(6 + 16, &buf[0]);
 	put_unaligned_be16(16, &buf[2]);
 	put_unaligned_be64(sector, &buf[8]);
@@ -768,8 +768,8 @@ static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd, bool unmap)
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
-	if (!rq->special_vec.bv_page)
+	bvec_set_page(&rq->special_vec, alloc_page(GFP_ATOMIC | __GFP_ZERO));
+	if (!bvec_page(&rq->special_vec))
 		return BLKPREP_DEFER;
 	rq->special_vec.bv_offset = 0;
 	rq->special_vec.bv_len = data_len;
@@ -798,8 +798,8 @@ static int sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd, bool unmap)
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
-	if (!rq->special_vec.bv_page)
+	bvec_set_page(&rq->special_vec, alloc_page(GFP_ATOMIC | __GFP_ZERO));
+	if (!bvec_page(&rq->special_vec))
 		return BLKPREP_DEFER;
 	rq->special_vec.bv_offset = 0;
 	rq->special_vec.bv_len = data_len;
@@ -1255,7 +1255,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 	struct request *rq = SCpnt->request;
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		__free_page(rq->special_vec.bv_page);
+		__free_page(bvec_page(&rq->special_vec));
 
 	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
 		mempool_free(SCpnt->cmnd, sd_cdb_pool);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 9035380..afaf8fc 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -139,7 +139,7 @@ void sd_dif_prepare(struct scsi_cmnd *scmd)
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
+			pi = kmap_atomic(bvec_page(&iv)) + iv.bv_offset;
 
 			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
@@ -186,7 +186,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
+			pi = kmap_atomic(bvec_page(&iv)) + iv.bv_offset;
 
 			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 0db662d..10637e0 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -724,7 +724,7 @@ kiblnd_setup_rd_kiov(struct lnet_ni *ni, struct kib_tx *tx,
 
 		fragnob = min((int)(kiov->bv_len - offset), nob);
 
-		sg_set_page(sg, kiov->bv_page, fragnob,
+		sg_set_page(sg, bvec_page(kiov), fragnob,
 			    kiov->bv_offset + offset);
 		sg = sg_next(sg);
 		if (!sg) {
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib.c
index 8a036f4..33f0d74 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib.c
@@ -109,7 +109,7 @@ ksocknal_lib_send_kiov(struct ksock_conn *conn, struct ksock_tx *tx)
 	if (tx->tx_msg.ksm_zc_cookies[0]) {
 		/* Zero copy is enabled */
 		struct sock *sk = sock->sk;
-		struct page *page = kiov->bv_page;
+		struct page *page = bvec_page(kiov);
 		int offset = kiov->bv_offset;
 		int fragsize = kiov->bv_len;
 		int msgflg = MSG_DONTWAIT;
@@ -238,7 +238,7 @@ ksocknal_lib_recv_kiov(struct ksock_conn *conn)
 		for (i = 0, sum = rc; sum > 0; i++, sum -= fragnob) {
 			LASSERT(i < niov);
 
-			base = kmap(kiov[i].bv_page) + kiov[i].bv_offset;
+			base = kmap(bvec_page(kiov)) + kiov[i].bv_offset;
 			fragnob = kiov[i].bv_len;
 			if (fragnob > sum)
 				fragnob = sum;
@@ -246,7 +246,7 @@ ksocknal_lib_recv_kiov(struct ksock_conn *conn)
 			conn->ksnc_rx_csum = ksocknal_csum(conn->ksnc_rx_csum,
 							   base, fragnob);
 
-			kunmap(kiov[i].bv_page);
+			kunmap(bvec_page(kiov));
 		}
 	}
 	return rc;
@@ -270,12 +270,12 @@ ksocknal_lib_csum_tx(struct ksock_tx *tx)
 
 	if (tx->tx_kiov) {
 		for (i = 0; i < tx->tx_nkiov; i++) {
-			base = kmap(tx->tx_kiov[i].bv_page) +
+			base = kmap(bvec_page(tx->tx_kiov)) +
 			       tx->tx_kiov[i].bv_offset;
 
 			csum = ksocknal_csum(csum, base, tx->tx_kiov[i].bv_len);
 
-			kunmap(tx->tx_kiov[i].bv_page);
+			kunmap(bvec_page(tx->tx_kiov));
 		}
 	} else {
 		for (i = 1; i < tx->tx_niov; i++)
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index a99c5c0..10e227d 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -235,7 +235,7 @@ lnet_copy_kiov2iter(struct iov_iter *to,
 
 		if (copy > nob)
 			copy = nob;
-		n = copy_page_to_iter(siov->bv_page,
+		n = copy_page_to_iter(bvec_page(siov),
 				      siov->bv_offset + soffset,
 				      copy, to);
 		if (n != copy)
@@ -340,7 +340,7 @@ lnet_extract_kiov(int dst_niov, struct bio_vec *dst,
 		LASSERT((int)niov <= dst_niov);
 
 		frag_len = src->bv_len - offset;
-		dst->bv_page = src->bv_page;
+		bvec_set_page(dst, bvec_page(src));
 		dst->bv_offset = src->bv_offset + offset;
 
 		if (len <= frag_len) {
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 12dd104..9a2779b 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -1310,7 +1310,7 @@ lnet_destroy_rtrbuf(struct lnet_rtrbuf *rb, int npages)
 	int sz = offsetof(struct lnet_rtrbuf, rb_kiov[npages]);
 
 	while (--npages >= 0)
-		__free_page(rb->rb_kiov[npages].bv_page);
+		__free_page(bvec_page(rb->rb_kiov));
 
 	LIBCFS_FREE(rb, sz);
 }
@@ -1336,7 +1336,7 @@ lnet_new_rtrbuf(struct lnet_rtrbufpool *rbp, int cpt)
 				GFP_KERNEL | __GFP_ZERO, 0);
 		if (!page) {
 			while (--i >= 0)
-				__free_page(rb->rb_kiov[i].bv_page);
+				__free_page(bvec_page(rb->rb_kiov));
 
 			LIBCFS_FREE(rb, sz);
 			return NULL;
@@ -1344,7 +1344,7 @@ lnet_new_rtrbuf(struct lnet_rtrbufpool *rbp, int cpt)
 
 		rb->rb_kiov[i].bv_len = PAGE_SIZE;
 		rb->rb_kiov[i].bv_offset = 0;
-		rb->rb_kiov[i].bv_page = page;
+		bvec_set_page(rb->rb_kiov, page);
 	}
 
 	return rb;
diff --git a/drivers/staging/lustre/lnet/selftest/brw_test.c b/drivers/staging/lustre/lnet/selftest/brw_test.c
index f8b9175..dc7aa82 100644
--- a/drivers/staging/lustre/lnet/selftest/brw_test.c
+++ b/drivers/staging/lustre/lnet/selftest/brw_test.c
@@ -237,7 +237,7 @@ brw_fill_bulk(struct srpc_bulk *bk, int pattern, __u64 magic)
 	for (i = 0; i < bk->bk_niov; i++) {
 		int off, len;
 
-		pg = bk->bk_iovs[i].bv_page;
+		pg = bvec_page(bk->bk_iovs);
 		off = bk->bk_iovs[i].bv_offset;
 		len = bk->bk_iovs[i].bv_len;
 		brw_fill_page(pg, off, len, pattern, magic);
@@ -253,7 +253,7 @@ brw_check_bulk(struct srpc_bulk *bk, int pattern, __u64 magic)
 	for (i = 0; i < bk->bk_niov; i++) {
 		int off, len;
 
-		pg = bk->bk_iovs[i].bv_page;
+		pg = bvec_page(bk->bk_iovs);
 		off = bk->bk_iovs[i].bv_offset;
 		len = bk->bk_iovs[i].bv_len;
 		if (brw_check_page(pg, off, len, pattern, magic)) {
diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index da36c55..20df9e4 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -153,10 +153,10 @@ lstcon_rpc_put(struct lstcon_rpc *crpc)
 	LASSERT(list_empty(&crpc->crp_link));
 
 	for (i = 0; i < bulk->bk_niov; i++) {
-		if (!bulk->bk_iovs[i].bv_page)
+		if (!bvec_page(bulk->bk_iovs))
 			continue;
 
-		__free_page(bulk->bk_iovs[i].bv_page);
+		__free_page(bvec_page(bulk->bk_iovs));
 	}
 
 	srpc_client_rpc_decref(crpc->crp_rpc);
@@ -708,7 +708,7 @@ lstcon_next_id(int idx, int nkiov, struct bio_vec *kiov)
 
 	LASSERT(i < nkiov);
 
-	pid = (struct lnet_process_id_packed *)page_address(kiov[i].bv_page);
+	pid = (struct lnet_process_id_packed *)page_address(bvec_page(kiov));
 
 	return &pid[idx % SFW_ID_PER_PAGE];
 }
@@ -853,9 +853,9 @@ lstcon_testrpc_prep(struct lstcon_node *nd, int transop, unsigned int feats,
 
 			bulk->bk_iovs[i].bv_offset = 0;
 			bulk->bk_iovs[i].bv_len = len;
-			bulk->bk_iovs[i].bv_page = alloc_page(GFP_KERNEL);
+			bvec_set_page(bulk->bk_iovs, alloc_page(GFP_KERNEL));
 
-			if (!bulk->bk_iovs[i].bv_page) {
+			if (!bvec_page(bulk->bk_iovs)) {
 				lstcon_rpc_put(*crpc);
 				return -ENOMEM;
 			}
diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index ef27bff..b8ecc6b 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -787,7 +787,7 @@ sfw_add_test_instance(struct sfw_batch *tsb, struct srpc_server_rpc *rpc)
 		struct lnet_process_id_packed id;
 		int j;
 
-		dests = page_address(bk->bk_iovs[i / SFW_ID_PER_PAGE].bv_page);
+		dests = page_address(bvec_page(bk->bk_iovs));
 		LASSERT(dests);  /* my pages are within KVM always */
 		id = dests[i % SFW_ID_PER_PAGE];
 		if (msg->msg_magic != SRPC_MSG_MAGIC)
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index 77c222c..1b6a016 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -91,7 +91,7 @@ srpc_add_bulk_page(struct srpc_bulk *bk, struct page *pg, int i, int off,
 	LASSERT(nob > 0 && nob <= PAGE_SIZE);
 
 	bk->bk_iovs[i].bv_offset = off;
-	bk->bk_iovs[i].bv_page = pg;
+	bvec_set_page(bk->bk_iovs, pg);
 	bk->bk_iovs[i].bv_len = nob;
 	return nob;
 }
@@ -105,7 +105,7 @@ srpc_free_bulk(struct srpc_bulk *bk)
 	LASSERT(bk);
 
 	for (i = 0; i < bk->bk_niov; i++) {
-		pg = bk->bk_iovs[i].bv_page;
+		pg = bvec_page(bk->bk_iovs);
 		if (!pg)
 			break;
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index d61b000..4571289 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -1894,7 +1894,7 @@ static inline void ptlrpc_release_bulk_page_pin(struct ptlrpc_bulk_desc *desc)
 	int i;
 
 	for (i = 0; i < desc->bd_iov_count ; i++)
-		put_page(BD_GET_KIOV(desc, i).bv_page);
+		put_page(bvec_page(&BD_GET_KIOV(desc, i)));
 }
 
 void ptlrpc_retain_replayable_request(struct ptlrpc_request *req,
diff --git a/drivers/staging/lustre/lustre/osc/osc_page.c b/drivers/staging/lustre/lustre/osc/osc_page.c
index ed8a0dc..b993e7a 100644
--- a/drivers/staging/lustre/lustre/osc/osc_page.c
+++ b/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -874,7 +874,7 @@ static inline void unstable_page_accounting(struct ptlrpc_bulk_desc *desc,
 	LASSERT(ptlrpc_is_bulk_desc_kiov(desc->bd_type));
 
 	for (i = 0; i < page_count; i++) {
-		pg_data_t *pgdat = page_pgdat(BD_GET_KIOV(desc, i).bv_page);
+		pg_data_t *pgdat = page_pgdat(bvec_page(&BD_GET_KIOV(desc, i)));
 
 		if (likely(pgdat == last)) {
 			++count;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 6466974..79beb38 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -215,7 +215,7 @@ void __ptlrpc_prep_bulk_page(struct ptlrpc_bulk_desc *desc,
 	if (pin)
 		get_page(page);
 
-	kiov->bv_page = page;
+	bvec_set_page(kiov, page);
 	kiov->bv_offset = pageoffset;
 	kiov->bv_len = len;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 128838a..c1df394 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -347,12 +347,12 @@ void sptlrpc_enc_pool_put_pages(struct ptlrpc_bulk_desc *desc)
 	LASSERT(page_pools.epp_pools[p_idx]);
 
 	for (i = 0; i < desc->bd_iov_count; i++) {
-		LASSERT(BD_GET_ENC_KIOV(desc, i).bv_page);
+		LASSERT(bvec_page(&BD_GET_ENC_KIOV(desc, i)));
 		LASSERT(g_idx != 0 || page_pools.epp_pools[p_idx]);
 		LASSERT(!page_pools.epp_pools[p_idx][g_idx]);
 
 		page_pools.epp_pools[p_idx][g_idx] =
-			BD_GET_ENC_KIOV(desc, i).bv_page;
+			bvec_page(&BD_GET_ENC_KIOV(desc, i));
 
 		if (++g_idx == PAGES_PER_POOL) {
 			p_idx++;
@@ -544,7 +544,7 @@ int sptlrpc_get_bulk_checksum(struct ptlrpc_bulk_desc *desc, __u8 alg,
 
 	for (i = 0; i < desc->bd_iov_count; i++) {
 		cfs_crypto_hash_update_page(hdesc,
-					    BD_GET_KIOV(desc, i).bv_page,
+					    bvec_page(&BD_GET_KIOV(desc, i)),
 					    BD_GET_KIOV(desc, i).bv_offset &
 					    ~PAGE_MASK,
 					    BD_GET_KIOV(desc, i).bv_len);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c b/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
index c5e7a23..4957584 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
@@ -159,10 +159,10 @@ static void corrupt_bulk_data(struct ptlrpc_bulk_desc *desc)
 		if (!BD_GET_KIOV(desc, i).bv_len)
 			continue;
 
-		ptr = kmap(BD_GET_KIOV(desc, i).bv_page);
+		ptr = kmap(bvec_page(&BD_GET_KIOV(desc, i)));
 		off = BD_GET_KIOV(desc, i).bv_offset & ~PAGE_MASK;
 		ptr[off] ^= 0x1;
-		kunmap(BD_GET_KIOV(desc, i).bv_page);
+		kunmap(bvec_page(&BD_GET_KIOV(desc, i)));
 		return;
 	}
 }
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 73b8f93..c7ce480 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -264,7 +264,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 	}
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
-		bvec[i].bv_page = sg_page(sg);
+		bvec_set_page(bvec, sg_page(sg));
 		bvec[i].bv_len = sg->length;
 		bvec[i].bv_offset = sg->offset;
 
@@ -401,7 +401,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	for (i = 0; i < nolb; i++) {
-		bvec[i].bv_page = sg_page(&cmd->t_data_sg[0]);
+		bvec_set_page(bvec, sg_page(&cmd->t_data_sg[0]));
 		bvec[i].bv_len = cmd->t_data_sg[0].length;
 		bvec[i].bv_offset = cmd->t_data_sg[0].offset;
 
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
index 4da69db..cd905ed 100644
--- a/drivers/xen/biomerge.c
+++ b/drivers/xen/biomerge.c
@@ -7,8 +7,8 @@ bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 			       const struct bio_vec *vec2)
 {
 #if XEN_PAGE_SIZE == PAGE_SIZE
-	unsigned long bfn1 = pfn_to_bfn(page_to_pfn(vec1->bv_page));
-	unsigned long bfn2 = pfn_to_bfn(page_to_pfn(vec2->bv_page));
+	unsigned long bfn1 = pfn_to_bfn(page_to_pfn(bvec_page(vec1)));
+	unsigned long bfn2 = pfn_to_bfn(page_to_pfn(bvec_page(vec2)));
 
 	return __BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
 		((bfn1 == bfn2) || ((bfn1+1) == bfn2));
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index adaf6f6..4067010 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -53,10 +53,12 @@
 static int v9fs_fid_readpage(struct p9_fid *fid, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	struct bio_vec bvec = {.bv_page = page, .bv_len = PAGE_SIZE};
+	struct bio_vec bvec = {.bv_len = PAGE_SIZE};
 	struct iov_iter to;
 	int retval, err;
 
+	bvec_set_page(&bvec, page);
+
 	p9_debug(P9_DEBUG_VFS, "\n");
 
 	BUG_ON(!PageLocked(page));
@@ -172,7 +174,7 @@ static int v9fs_vfs_writepage_locked(struct page *page)
 	else
 		len = PAGE_SIZE;
 
-	bvec.bv_page = page;
+	bvec_set_page(&bvec, page);
 	bvec.bv_offset = 0;
 	bvec.bv_len = len;
 	iov_iter_bvec(&from, ITER_BVEC | WRITE, &bvec, 1, len);
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index d5990eb..02d2698 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -282,7 +282,7 @@ static void afs_load_bvec(struct afs_call *call, struct msghdr *msg,
 			to = call->last_to;
 			msg->msg_flags &= ~MSG_MORE;
 		}
-		bv[i].bv_page = pages[i];
+		bvec_set_page(bv, pages[i]);
 		bv[i].bv_len = to - offset;
 		bv[i].bv_offset = offset;
 		bytes += to - offset;
@@ -320,7 +320,7 @@ static int afs_send_pages(struct afs_call *call, struct msghdr *msg)
 		ret = rxrpc_kernel_send_data(afs_socket, call->rxcall,
 					     msg, bytes);
 		for (loop = 0; loop < nr; loop++)
-			put_page(bv[loop].bv_page);
+			put_page(bvec_page(bv));
 		if (ret < 0)
 			break;
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 519599d..1cbc82d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -254,9 +254,9 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	__set_current_state(TASK_RUNNING);
 
 	bio_for_each_segment_all(bvec, &bio, i) {
-		if (should_dirty && !PageCompound(bvec->bv_page))
-			set_page_dirty_lock(bvec->bv_page);
-		put_page(bvec->bv_page);
+		if (should_dirty && !PageCompound(bvec_page(bvec)))
+			set_page_dirty_lock(bvec_page(bvec));
+		put_page(bvec_page(bvec));
 	}
 
 	if (vecs != inline_vecs)
@@ -317,7 +317,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 		int i;
 
 		bio_for_each_segment_all(bvec, bio, i)
-			put_page(bvec->bv_page);
+			put_page(bvec_page(bvec));
 		bio_put(bio);
 	}
 }
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index ab14c2e..7e161d1 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2846,7 +2846,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 
 		bio_for_each_segment_all(bvec, bio, i) {
 			BUG_ON(bvec->bv_len != PAGE_SIZE);
-			mapped_datav[i] = kmap(bvec->bv_page);
+			mapped_datav[i] = kmap(bvec_page(bvec));
 
 			if (dev_state->state->print_mask &
 			    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH_VERBOSE)
@@ -2859,7 +2859,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 					      bio, &bio_is_patched,
 					      NULL, bio->bi_opf);
 		bio_for_each_segment_all(bvec, bio, i)
-			kunmap(bvec->bv_page);
+			kunmap(bvec_page(bvec));
 		kfree(mapped_datav);
 	} else if (NULL != dev_state && (bio->bi_opf & REQ_PREFLUSH)) {
 		if (dev_state->state->print_mask &
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 10e6b28..7dd6f4a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -202,7 +202,7 @@ static void end_compressed_bio_read(struct bio *bio)
 		 * checked so the end_io handlers know about it
 		 */
 		bio_for_each_segment_all(bvec, cb->orig_bio, i)
-			SetPageChecked(bvec->bv_page);
+			SetPageChecked(bvec_page(bvec));
 
 		bio_endio(cb->orig_bio);
 	}
@@ -446,7 +446,7 @@ static u64 bio_end_offset(struct bio *bio)
 {
 	struct bio_vec *last = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
+	return page_offset(bvec_page(last)) + last->bv_len + last->bv_offset;
 }
 
 static noinline int add_ra_bio_pages(struct inode *inode,
@@ -596,7 +596,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	/* we need the actual starting offset of this extent in the file */
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree,
-				   page_offset(bio->bi_io_vec->bv_page),
+				   page_offset(bvec_page(bio->bi_io_vec)),
 				   PAGE_SIZE);
 	read_unlock(&em_tree->lock);
 	if (!em)
@@ -1027,7 +1027,7 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 	 * start byte is the first byte of the page we're currently
 	 * copying into relative to the start of the compressed data.
 	 */
-	start_byte = page_offset(bvec.bv_page) - disk_start;
+	start_byte = page_offset(bvec_page(&bvec)) - disk_start;
 
 	/* we haven't yet hit data corresponding to this page */
 	if (total_out <= start_byte)
@@ -1051,10 +1051,10 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 				PAGE_SIZE - buf_offset);
 		bytes = min(bytes, working_bytes);
 
-		kaddr = kmap_atomic(bvec.bv_page);
+		kaddr = kmap_atomic(bvec_page(&bvec));
 		memcpy(kaddr + bvec.bv_offset, buf + buf_offset, bytes);
 		kunmap_atomic(kaddr);
-		flush_dcache_page(bvec.bv_page);
+		flush_dcache_page(bvec_page(&bvec));
 
 		buf_offset += bytes;
 		working_bytes -= bytes;
@@ -1066,7 +1066,7 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 			return 0;
 		bvec = bio_iter_iovec(bio, bio->bi_iter);
 		prev_start_byte = start_byte;
-		start_byte = page_offset(bvec.bv_page) - disk_start;
+		start_byte = page_offset(bvec_page(&bvec)) - disk_start;
 
 		/*
 		 * We need to make sure we're only adjusting
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8685d67..376f039 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -966,8 +966,8 @@ static int btree_csum_one_bio(struct bio *bio)
 	int i, ret = 0;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
-		ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
+		root = BTRFS_I(bvec_page(bvec)->mapping->host)->root;
+		ret = csum_dirty_buffer(root->fs_info, bvec_page(bvec));
 		if (ret)
 			break;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d8da3ed..348acb5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2480,7 +2480,7 @@ static void end_bio_extent_writepage(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 		struct inode *inode = page->mapping->host;
 		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
@@ -2550,7 +2550,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 		struct inode *inode = page->mapping->host;
 		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
@@ -2745,7 +2745,7 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct page *page = bvec->bv_page;
+	struct page *page = bvec_page(bvec);
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
@@ -3701,7 +3701,7 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 	int i, done;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 64fcb31..748f8c9 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -229,7 +229,7 @@ static int __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 			goto next;
 
 		if (!dio)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec_page(bvec)) + bvec->bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       (u32 *)csum, nblocks);
 		if (count)
@@ -467,14 +467,14 @@ int btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 
 	bio_for_each_segment_all(bvec, bio, j) {
 		if (!contig)
-			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+			offset = page_offset(bvec_page(bvec)) + bvec->bv_offset;
 
 		if (!ordered) {
 			ordered = btrfs_lookup_ordered_extent(inode, offset);
 			BUG_ON(!ordered); /* Logic error */
 		}
 
-		data = kmap_atomic(bvec->bv_page);
+		data = kmap_atomic(bvec_page(bvec));
 
 		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info,
 						 bvec->bv_len + fs_info->sectorsize
@@ -504,7 +504,7 @@ int btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 					+ total_bytes;
 				index = 0;
 
-				data = kmap_atomic(bvec->bv_page);
+				data = kmap_atomic(bvec_page(bvec));
 			}
 
 			sums->sums[index] = ~(u32)0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe93..1b5bb25 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8046,7 +8046,7 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
 	done->uptodate = 1;
 	bio_for_each_segment_all(bvec, bio, i)
 		clean_io_failure(BTRFS_I(done->inode), done->start,
-				 bvec->bv_page, 0);
+				 bvec_page(bvec), 0);
 end:
 	complete(&done->done);
 	bio_put(bio);
@@ -8080,7 +8080,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
+		ret = dio_read_error(inode, &io_bio->bio, bvec_page(bvec),
 				pgoff, start, start + sectorsize - 1,
 				io_bio->mirror_num,
 				btrfs_retry_endio_nocsum, &done);
@@ -8126,11 +8126,11 @@ static void btrfs_retry_endio(struct bio *bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		ret = __readpage_endio_check(done->inode, io_bio, i,
-					bvec->bv_page, bvec->bv_offset,
+					bvec_page(bvec), bvec->bv_offset,
 					done->start, bvec->bv_len);
 		if (!ret)
 			clean_io_failure(BTRFS_I(done->inode), done->start,
-					bvec->bv_page, bvec->bv_offset);
+					bvec_page(bvec), bvec->bv_offset);
 		else
 			uptodate = 0;
 	}
@@ -8170,7 +8170,7 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 next_block:
 		csum_pos = BTRFS_BYTES_TO_BLKS(fs_info, offset);
 		ret = __readpage_endio_check(inode, io_bio, csum_pos,
-					bvec->bv_page, pgoff, start,
+					bvec_page(bvec), pgoff, start,
 					sectorsize);
 		if (likely(!ret))
 			goto next;
@@ -8179,7 +8179,7 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
+		ret = dio_read_error(inode, &io_bio->bio, bvec_page(bvec),
 				pgoff, start, start + sectorsize - 1,
 				io_bio->mirror_num,
 				btrfs_retry_endio, &done);
@@ -8501,7 +8501,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 		i = 0;
 next_block:
 		if (unlikely(map_length < submit_len + blocksize ||
-		    bio_add_page(bio, bvec->bv_page, blocksize,
+		    bio_add_page(bio, bvec_page(bvec), blocksize,
 			    bvec->bv_offset + (i * blocksize)) < blocksize)) {
 			/*
 			 * inc the count before we submit the bio so
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d8ea0eb..f790b83 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1155,7 +1155,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 		page_index = stripe_offset >> PAGE_SHIFT;
 
 		bio_for_each_segment_all(bvec, bio, i)
-			rbio->bio_pages[page_index + i] = bvec->bv_page;
+			rbio->bio_pages[page_index + i] = bvec_page(bvec);
 	}
 	spin_unlock_irq(&rbio->bio_list_lock);
 }
@@ -1433,7 +1433,7 @@ static void set_bio_pages_uptodate(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i)
-		SetPageUptodate(bvec->bv_page);
+		SetPageUptodate(bvec_page(bvec));
 }
 
 /*
diff --git a/fs/buffer.c b/fs/buffer.c
index 161be58..b16f538 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3085,7 +3085,7 @@ void guard_bio_eod(int op, struct bio *bio)
 
 	/* ..and clear the end of the buffer for reads */
 	if (op == REQ_OP_READ) {
-		zero_user(bvec->bv_page, bvec->bv_offset + bvec->bv_len,
+		zero_user(bvec_page(bvec), bvec->bv_offset + bvec->bv_len,
 				truncated_bytes);
 	}
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9365c0c..03c17b9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -588,7 +588,8 @@ cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 		      unsigned int to_read)
 {
 	struct msghdr smb_msg;
-	struct bio_vec bv = {.bv_page = page, .bv_len = to_read};
+	struct bio_vec bv = {.bv_len = to_read};
+	bvec_set_page(&bv, page);
 	iov_iter_bvec(&smb_msg.msg_iter, READ | ITER_BVEC, &bv, 1, to_read);
 	return cifs_readv_from_socket(server, &smb_msg);
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0fd081b..be19caa 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2693,7 +2693,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 	}
 
 	for (i = 0; i < ctx->npages; i++)
-		put_page(ctx->bv[i].bv_page);
+		put_page(bvec_page(ctx->bv));
 
 	cifs_stats_bytes_written(tcon, ctx->total_len);
 	set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->flags);
@@ -3214,8 +3214,8 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 
 	for (i = 0; i < ctx->npages; i++) {
 		if (ctx->should_dirty)
-			set_page_dirty(ctx->bv[i].bv_page);
-		put_page(ctx->bv[i].bv_page);
+			set_page_dirty(bvec_page(ctx->bv));
+		put_page(bvec_page(ctx->bv));
 	}
 
 	ctx->total_len = ctx->len - iov_iter_count(to);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b085319..bb906f7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -844,7 +844,7 @@ setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
 
 		for (i = 0; i < cur_npages; i++) {
 			len = rc > PAGE_SIZE ? PAGE_SIZE : rc;
-			bv[npages + i].bv_page = pages[i];
+			bvec_set_page(bv, pages[i]);
 			bv[npages + i].bv_offset = start;
 			bv[npages + i].bv_len = len - start;
 			rc -= len;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c586918..0d6462f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2018,7 +2018,7 @@ init_read_bvec(struct page **pages, unsigned int npages, unsigned int data_size,
 		return -ENOMEM;
 
 	for (i = 0; i < npages; i++) {
-		bvec[i].bv_page = pages[i];
+		bvec_set_page(bvec, pages[i]);
 		bvec[i].bv_offset = (i == 0) ? cur_off : 0;
 		bvec[i].bv_len = min_t(unsigned int, PAGE_SIZE, data_size);
 		data_size -= bvec[i].bv_len;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 47a125e..60aff9f 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -270,9 +270,10 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 				? rqst->rq_tailsz
 				: rqst->rq_pagesz;
 		struct bio_vec bvec = {
-			.bv_page = rqst->rq_pages[i],
 			.bv_len = len
 		};
+
+		bvec_set_page(&bvec, rqst->rq_pages[i]);
 		iov_iter_bvec(&smb_msg.msg_iter, WRITE | ITER_BVEC,
 			      &bvec, 1, len);
 		rc = smb_send_kvec(server, &smb_msg, &sent);
diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index a409a84..ca423e9 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -38,7 +38,7 @@ static void completion_pages(struct work_struct *work)
 	int i;
 
 	bio_for_each_segment_all(bv, bio, i) {
-		struct page *page = bv->bv_page;
+		struct page *page = bvec_page(bv);
 		int ret = fscrypt_decrypt_page(page->mapping->host, page,
 				PAGE_SIZE, 0, page->index);
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index a04ebea..26461f4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -488,7 +488,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
-			struct page *page = bvec->bv_page;
+			struct page *page = bvec_page(bvec);
 
 			if (dio->op == REQ_OP_READ && !PageCompound(page) &&
 					dio->should_dirty)
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 8bb7280..2a7c89e 100644
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
index 27cbdb6..da76728 100644
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
index 1a82138..5b1edcb 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -64,7 +64,7 @@ static void ext4_finish_bio(struct bio *bio)
 	struct bio_vec *bvec;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 		struct page *data_page = NULL;
 #endif
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index a81b829..8ebfc6f 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -81,7 +81,7 @@ static void mpage_end_io(struct bio *bio)
 		}
 	}
 	bio_for_each_segment_all(bv, bio, i) {
-		struct page *page = bv->bv_page;
+		struct page *page = bvec_page(bv);
 
 		if (!bio->bi_error) {
 			SetPageUptodate(page);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7c0f6bd..64fea08 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -56,7 +56,7 @@ static void f2fs_read_end_io(struct bio *bio)
 	int i;
 
 #ifdef CONFIG_F2FS_FAULT_INJECTION
-	if (time_to_inject(F2FS_P_SB(bio->bi_io_vec->bv_page), FAULT_IO)) {
+	if (time_to_inject(F2FS_P_SB(bvec_page(bio->bi_io_vec)), FAULT_IO)) {
 		f2fs_show_injection_info(FAULT_IO);
 		bio->bi_error = -EIO;
 	}
@@ -72,7 +72,7 @@ static void f2fs_read_end_io(struct bio *bio)
 	}
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 
 		if (!bio->bi_error) {
 			if (!PageUptodate(page))
@@ -93,7 +93,7 @@ static void f2fs_write_end_io(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 		enum count_type type = WB_DATA_TYPE(page);
 
 		if (IS_DUMMY_WRITTEN_PAGE(page)) {
@@ -261,10 +261,10 @@ static bool __has_merged_page(struct f2fs_bio_info *io,
 
 	bio_for_each_segment_all(bvec, io->bio, i) {
 
-		if (bvec->bv_page->mapping)
-			target = bvec->bv_page;
+		if (bvec_page(bvec)->mapping)
+			target = bvec_page(bvec);
 		else
-			target = fscrypt_control_page(bvec->bv_page);
+			target = fscrypt_control_page(bvec_page(bvec));
 
 		if (idx != target->index)
 			continue;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index b1f9144..6f05e15 100644
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
@@ -215,7 +215,7 @@ static void gfs2_end_log_write(struct bio *bio)
 	}
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		page = bvec->bv_page;
+		page = bvec_page(bvec);
 		if (page_has_buffers(page))
 			gfs2_end_log_write_bh(sdp, bvec, bio->bi_error);
 		else
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 663ffc1..dfdaa2e 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -192,7 +192,7 @@ static void gfs2_meta_read_endio(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec_page(bvec);
 		struct buffer_head *bh = page_buffers(page);
 		unsigned int len = bvec->bv_len;
 
diff --git a/fs/iomap.c b/fs/iomap.c
index 4b10892..5f4a2cc 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -698,7 +698,7 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 		int i;
 
 		bio_for_each_segment_all(bvec, bio, i)
-			put_page(bvec->bv_page);
+			put_page(bvec_page(bvec));
 		bio_put(bio);
 	}
 }
diff --git a/fs/mpage.c b/fs/mpage.c
index baff8f8..59f9987 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -49,7 +49,7 @@ static void mpage_end_io(struct bio *bio)
 	int i;
 
 	bio_for_each_segment_all(bv, bio, i) {
-		struct page *page = bv->bv_page;
+		struct page *page = bvec_page(bv);
 		page_endio(page, op_is_write(bio_op(bio)), bio->bi_error);
 	}
 
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 9428ea0..09a784e 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -22,8 +22,9 @@ static int read_one_page(struct page *page)
 	const __u32 blocksize = PAGE_SIZE;	/* inode->i_blksize */
 	const __u32 blockbits = PAGE_SHIFT;	/* inode->i_blkbits */
 	struct iov_iter to;
-	struct bio_vec bv = {.bv_page = page, .bv_len = PAGE_SIZE};
+	struct bio_vec bv = {.bv_len = PAGE_SIZE};
 
+	bvec_set_page(&bv, page);
 	iov_iter_bvec(&to, ITER_BVEC | READ, &bv, 1, PAGE_SIZE);
 
 	gossip_debug(GOSSIP_INODE_DEBUG,
diff --git a/fs/splice.c b/fs/splice.c
index 540c4a4..3e8fda3 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -754,7 +754,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 				goto done;
 			}
 
-			array[n].bv_page = buf->page;
+			bvec_set_page(array, buf->page);
 			array[n].bv_len = this_len;
 			array[n].bv_offset = buf->offset;
 			left -= this_len;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 09af0f7..7549388 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -107,7 +107,7 @@ xfs_finish_page_writeback(
 	ASSERT(end < PAGE_SIZE);
 	ASSERT((bvec->bv_len & (i_blocksize(inode) - 1)) == 0);
 
-	bh = head = page_buffers(bvec->bv_page);
+	bh = head = page_buffers(bvec_page(bvec));
 
 	bsize = bh->b_size;
 	do {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d1b04b0..16c0b02 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -119,7 +119,7 @@ static inline void *bio_data(struct bio *bio)
  * will die
  */
 #define bio_to_phys(bio)	(page_to_phys(bio_page((bio))) + (unsigned long) bio_offset((bio)))
-#define bvec_to_phys(bv)	(page_to_phys((bv)->bv_page) + (unsigned long) (bv)->bv_offset)
+#define bvec_to_phys(bv)	(page_to_phys(bvec_page((bv))) + (unsigned long) (bv)->bv_offset)
 
 /*
  * queues that have highmem support enabled may still need to revert to
@@ -127,8 +127,8 @@ static inline void *bio_data(struct bio *bio)
  * permanent PIO fall back, user is probably better off disabling highmem
  * I/O completely on that queue (see ide-dma for example)
  */
-#define __bio_kmap_atomic(bio, iter)				\
-	(kmap_atomic(bio_iter_iovec((bio), (iter)).bv_page) +	\
+#define __bio_kmap_atomic(bio, iter)				  \
+	(kmap_atomic(bvec_page(&bio_iter_iovec((bio), (iter)))) + \
 		bio_iter_iovec((bio), (iter)).bv_offset)
 
 #define __bio_kunmap_atomic(addr)	kunmap_atomic(addr)
@@ -502,7 +502,7 @@ static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 	 * balancing is a lot nicer this way
 	 */
 	local_irq_save(*flags);
-	addr = (unsigned long) kmap_atomic(bvec->bv_page);
+	addr = (unsigned long) kmap_atomic(bvec_page(bvec));
 
 	BUG_ON(addr & ~PAGE_MASK);
 
@@ -520,7 +520,7 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 #else
 static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 {
-	return page_address(bvec->bv_page) + bvec->bv_offset;
+	return page_address(bvec_page(bvec)) + bvec->bv_offset;
 }
 
 static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index b5369a0..b53b879 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -60,7 +60,7 @@ static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
 #define bvec_iter_page(bvec, iter)				\
-	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+	(bvec_page(__bvec_iter_bvec((bvec), (iter))))
 
 #define bvec_iter_len(bvec, iter)				\
 	min((iter).bi_size,					\
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index f80fd33..56be025 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -238,7 +238,7 @@ static void hib_init_batch(struct hib_bio_batch *hb)
 static void hib_end_io(struct bio *bio)
 {
 	struct hib_bio_batch *hb = bio->bi_private;
-	struct page *page = bio->bi_io_vec[0].bv_page;
+	struct page *page = bvec_page(bio->bi_io_vec);
 
 	if (bio->bi_error) {
 		printk(KERN_ALERT "Read-error on swap-device (%u:%u:%Lu)\n",
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f835964..ed95bb8 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -543,7 +543,7 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_to_user(v.iov_base, (from += v.iov_len) - v.iov_len,
 			       v.iov_len),
-		memcpy_to_page(v.bv_page, v.bv_offset,
+		memcpy_to_page(bvec_page(&v), v.bv_offset,
 			       (from += v.bv_len) - v.bv_len, v.bv_len),
 		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
 	)
@@ -562,7 +562,7 @@ size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user((to += v.iov_len) - v.iov_len, v.iov_base,
 				 v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -586,7 +586,7 @@ bool copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i)
 				      v.iov_base, v.iov_len))
 			return false;
 		0;}),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -606,7 +606,7 @@ size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_inatomic_nocache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -629,7 +629,7 @@ bool copy_from_iter_full_nocache(void *addr, size_t bytes, struct iov_iter *i)
 					     v.iov_base, v.iov_len))
 			return false;
 		0;}),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -701,7 +701,7 @@ size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 		return pipe_zero(bytes, i);
 	iterate_and_advance(i, bytes, v,
 		__clear_user(v.iov_base, v.iov_len),
-		memzero_page(v.bv_page, v.bv_offset, v.bv_len),
+		memzero_page(bvec_page(&v), v.bv_offset, v.bv_len),
 		memset(v.iov_base, 0, v.iov_len)
 	)
 
@@ -721,7 +721,7 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	iterate_all_kinds(i, bytes, v,
 		__copy_from_user_inatomic((p += v.iov_len) - v.iov_len,
 					  v.iov_base, v.iov_len),
-		memcpy_from_page((p += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((p += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((p += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -1018,7 +1018,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 	0;}),({
 		/* can't be more than PAGE_SIZE */
 		*start = v.bv_offset;
-		get_page(*pages = v.bv_page);
+		get_page(*pages = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -1102,7 +1102,7 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		*pages = p = get_pages_array(1);
 		if (!p)
 			return -ENOMEM;
-		get_page(*p = v.bv_page);
+		get_page(*p = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -1134,7 +1134,7 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		next = csum_partial_copy_nocheck(p + v.bv_offset,
 						 (to += v.bv_len) - v.bv_len,
 						 v.bv_len, 0);
@@ -1178,7 +1178,7 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum,
 		off += v.iov_len;
 		0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		next = csum_partial_copy_nocheck(p + v.bv_offset,
 						 (to += v.bv_len) - v.bv_len,
 						 v.bv_len, 0);
@@ -1221,7 +1221,7 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, __wsum *csum,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		next = csum_partial_copy_nocheck((from += v.bv_len) - v.bv_len,
 						 p + v.bv_offset,
 						 v.bv_len, 0);
diff --git a/mm/page_io.c b/mm/page_io.c
index 23f6d0d..b3491b4 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
- *  Swap reorganised 29.12.95, 
+ *  Swap reorganised 29.12.95,
  *  Asynchronous swapping added 30.12.95. Stephen Tweedie
  *  Removed race in async swapping. 14.4.1996. Bruno Haible
  *  Add swap of shared pages through the page cache. 20.2.1998. Stephen Tweedie
@@ -43,7 +43,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 
 void end_swap_bio_write(struct bio *bio)
 {
-	struct page *page = bio->bi_io_vec[0].bv_page;
+	struct page *page = bvec_page(bio->bi_io_vec);
 
 	if (bio->bi_error) {
 		SetPageError(page);
@@ -116,7 +116,7 @@ static void swap_slot_free_notify(struct page *page)
 
 static void end_swap_bio_read(struct bio *bio)
 {
-	struct page *page = bio->bi_io_vec[0].bv_page;
+	struct page *page = bvec_page(bio->bi_io_vec);
 
 	if (bio->bi_error) {
 		SetPageError(page);
@@ -270,12 +270,12 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 		struct bio_vec bv = {
-			.bv_page = page,
 			.bv_len  = PAGE_SIZE,
 			.bv_offset = 0
 		};
 		struct iov_iter from;
 
+		bvec_set_page(&bv, page);
 		iov_iter_bvec(&from, ITER_BVEC | WRITE, &bv, 1, PAGE_SIZE);
 		init_sync_kiocb(&kiocb, swap_file);
 		kiocb.ki_pos = page_file_offset(page);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5766a6c..ad951f4 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -537,7 +537,6 @@ static int ceph_tcp_recvpage(struct socket *sock, struct page *page,
 		     int page_offset, size_t length)
 {
 	struct bio_vec bvec = {
-		.bv_page = page,
 		.bv_offset = page_offset,
 		.bv_len = length
 	};
@@ -545,6 +544,7 @@ static int ceph_tcp_recvpage(struct socket *sock, struct page *page,
 	int r;
 
 	BUG_ON(page_offset + length > PAGE_SIZE);
+	bvec_set_page(&bvec, page);
 	iov_iter_bvec(&msg.msg_iter, READ | ITER_BVEC, &bvec, 1, length);
 	r = sock_recvmsg(sock, &msg, msg.msg_flags);
 	if (r == -EAGAIN)
@@ -598,7 +598,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
 	if (page_count(page) >= 1)
 		return __ceph_tcp_sendpage(sock, page, offset, size, more);
 
-	bvec.bv_page = page;
+	bvec_set_page(&bvec, page);
 	bvec.bv_offset = offset;
 	bvec.bv_len = size;
 
@@ -875,7 +875,7 @@ static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(*length > cursor->resid);
 	BUG_ON(*page_offset + *length > PAGE_SIZE);
 
-	return bio_vec.bv_page;
+	return bvec_page(&bio_vec);
 }
 
 static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
-- 
2.1.4
