Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 11/15] libnvdimm: pmem, blk, and btt make_request cleanups
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:55:46 -0400
Message-ID: <20150617235546.12943.2374.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Various cleanups:

1/ kill the BUG_ONs since we've already told the block layer we don't
   support DISCARD on all these drivers.

2/ Fix up use of 'rw'.  No need to cache it in the pmem driver and for
   btt using bio_data_dir() saves a check for READA.

3/ Kill the local 'sector' variables.  bio_for_each_segment() is already
   advancing the iterator's sector number by the bio_vec length.

Reviewed-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c  |   14 ++++----------
 drivers/nvdimm/btt.c  |   18 +++++-------------
 drivers/nvdimm/pmem.c |   20 ++++++--------------
 3 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 8a6345797a71..9d609ef95266 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -170,18 +170,12 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	struct bvec_iter iter;
 	struct bio_vec bvec;
 	int err = 0, rw;
-	sector_t sector;
 
-	sector = bio->bi_iter.bi_sector;
-	if (bio_end_sector(bio) > get_capacity(disk)) {
+	if (unlikely(bio_end_sector(bio) > get_capacity(disk))) {
 		err = -EIO;
 		goto out;
 	}
 
-	BUG_ON(bio->bi_rw & REQ_DISCARD);
-
-	rw = bio_data_dir(bio);
-
 	/*
 	 * bio_integrity_enabled also checks if the bio already has an
 	 * integrity payload attached. If it does, we *don't* do a
@@ -196,20 +190,20 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	bip = bio_integrity(bio);
 	blk_dev = disk->private_data;
 
+	rw = bio_data_dir(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
 		BUG_ON(len > PAGE_SIZE);
 		err = nd_blk_do_bvec(blk_dev, bip, bvec.bv_page, len,
-					bvec.bv_offset, rw, sector);
+					bvec.bv_offset, rw, iter.bi_sector);
 		if (err) {
 			dev_info(&blk_dev->nsblk->dev,
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
-					(unsigned long long) sector, len);
+					(unsigned long long) iter.bi_sector, len);
 			goto out;
 		}
-		sector += len >> SECTOR_SHIFT;
 	}
 
  out:
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 380e01cedd24..83b798dd2e68 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1177,23 +1177,16 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct block_device *bdev = bio->bi_bdev;
 	struct btt *btt = q->queuedata;
-	int rw;
-	struct bio_vec bvec;
-	sector_t sector;
 	struct bvec_iter iter;
-	int err = 0;
+	struct bio_vec bvec;
+	int err = 0, rw;
 
-	sector = bio->bi_iter.bi_sector;
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
 		err = -EIO;
 		goto out;
 	}
 
-	BUG_ON(bio->bi_rw & REQ_DISCARD);
-
-	rw = bio_rw(bio);
-	if (rw == READA)
-		rw = READ;
+	rw = bio_data_dir(bio);
 
 	/*
 	 * bio_integrity_enabled also checks if the bio already has an
@@ -1216,15 +1209,14 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 		BUG_ON(len % btt->sector_size);
 
 		err = btt_do_bvec(btt, bip, bvec.bv_page, len, bvec.bv_offset,
-				rw, sector);
+				rw, iter.bi_sector);
 		if (err) {
 			dev_info(&btt->nd_btt->dev,
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
-					(unsigned long long) sector, len);
+					(unsigned long long) iter.bi_sector, len);
 			goto out;
 		}
-		sector += len >> SECTOR_SHIFT;
 	}
 
 out:
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b825a2201aa8..0337b00f5409 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -58,28 +58,20 @@ static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 
 static void pmem_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct block_device *bdev = bio->bi_bdev;
-	struct pmem_device *pmem = bdev->bd_disk->private_data;
-	int rw;
+	int err = 0;
 	struct bio_vec bvec;
-	sector_t sector;
 	struct bvec_iter iter;
-	int err = 0;
+	struct block_device *bdev = bio->bi_bdev;
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
 
-	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
+	if (unlikely(bio_end_sector(bio) > get_capacity(bdev->bd_disk))) {
 		err = -EIO;
 		goto out;
 	}
 
-	BUG_ON(bio->bi_rw & REQ_DISCARD);
-
-	rw = bio_data_dir(bio);
-	sector = bio->bi_iter.bi_sector;
-	bio_for_each_segment(bvec, bio, iter) {
+	bio_for_each_segment(bvec, bio, iter)
 		pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len, bvec.bv_offset,
-			     rw, sector);
-		sector += bvec.bv_len >> 9;
-	}
+				bio_data_dir(bio), iter.bi_sector);
 
 out:
 	bio_endio(bio, err);

