Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 11/17] libnvdimm: enable iostat
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:37:17 -0400
Message-ID: <20150625093717.40066.87241.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

This is disabled by default as the overhead is prohibitive, but if the
user takes the action to turn it on we'll oblige.

Reviewed-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c  |    7 ++++++-
 drivers/nvdimm/btt.c  |    7 ++++++-
 drivers/nvdimm/core.c |   29 +++++++++++++++++++++++++++++
 drivers/nvdimm/nd.h   |   13 +++++++++++++
 drivers/nvdimm/pmem.c |    5 +++++
 5 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 5c44e067652f..96ef38ceeceb 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -168,8 +168,10 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	struct bio_integrity_payload *bip;
 	struct nd_blk_device *blk_dev;
 	struct bvec_iter iter;
+	unsigned long start;
 	struct bio_vec bvec;
 	int err = 0, rw;
+	bool do_acct;
 
 	/*
 	 * bio_integrity_enabled also checks if the bio already has an
@@ -185,6 +187,7 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	bip = bio_integrity(bio);
 	blk_dev = disk->private_data;
 	rw = bio_data_dir(bio);
+	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -196,9 +199,11 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
 					(unsigned long long) iter.bi_sector, len);
-			goto out;
+			break;
 		}
 	}
+	if (do_acct)
+		nd_iostat_end(bio, start);
 
  out:
 	bio_endio(bio, err);
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 18a2463c2300..c02065aed03d 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1177,8 +1177,10 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct btt *btt = q->queuedata;
 	struct bvec_iter iter;
+	unsigned long start;
 	struct bio_vec bvec;
 	int err = 0, rw;
+	bool do_acct;
 
 	/*
 	 * bio_integrity_enabled also checks if the bio already has an
@@ -1191,6 +1193,7 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 		goto out;
 	}
 
+	do_acct = nd_iostat_start(bio, &start);
 	rw = bio_data_dir(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
@@ -1208,9 +1211,11 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
 					(unsigned long long) iter.bi_sector, len);
-			goto out;
+			break;
 		}
 	}
+	if (do_acct)
+		nd_iostat_end(bio, start);
 
 out:
 	bio_endio(bio, err);
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 4288169432de..cb62ec6a12d0 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -214,6 +214,35 @@ ssize_t nd_sector_size_store(struct device *dev, const char *buf,
 	}
 }
 
+void __nd_iostat_start(struct bio *bio, unsigned long *start)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	const int rw = bio_data_dir(bio);
+	int cpu = part_stat_lock();
+
+	*start = jiffies;
+	part_round_stats(cpu, &disk->part0);
+	part_stat_inc(cpu, &disk->part0, ios[rw]);
+	part_stat_add(cpu, &disk->part0, sectors[rw], bio_sectors(bio));
+	part_inc_in_flight(&disk->part0, rw);
+	part_stat_unlock();
+}
+EXPORT_SYMBOL(__nd_iostat_start);
+
+void nd_iostat_end(struct bio *bio, unsigned long start)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	unsigned long duration = jiffies - start;
+	const int rw = bio_data_dir(bio);
+	int cpu = part_stat_lock();
+
+	part_stat_add(cpu, &disk->part0, ticks[rw], duration);
+	part_round_stats(cpu, &disk->part0);
+	part_dec_in_flight(&disk->part0, rw);
+	part_stat_unlock();
+}
+EXPORT_SYMBOL(nd_iostat_end);
+
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index e73c34dcd935..cf6849b72c4f 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -13,6 +13,7 @@
 #ifndef __ND_H__
 #define __ND_H__
 #include <linux/libnvdimm.h>
+#include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
@@ -201,5 +202,17 @@ int nvdimm_namespace_detach_btt(struct nd_namespace_common *ndns);
 const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name);
 int nd_blk_region_init(struct nd_region *nd_region);
+void __nd_iostat_start(struct bio *bio, unsigned long *start);
+static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+
+	if (!blk_queue_io_stat(disk->queue))
+		return false;
+
+	__nd_iostat_start(bio, start);
+	return true;
+}
+void nd_iostat_end(struct bio *bio, unsigned long start);
 resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
 #endif /* __ND_H__ */
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e846a627ebdf..09195e3b7453 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -58,14 +58,19 @@ static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 
 static void pmem_make_request(struct request_queue *q, struct bio *bio)
 {
+	bool do_acct;
+	unsigned long start;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	struct block_device *bdev = bio->bi_bdev;
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 
+	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter)
 		pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len, bvec.bv_offset,
 				bio_data_dir(bio), iter.bi_sector);
+	if (do_acct)
+		nd_iostat_end(bio, start);
 	bio_endio(bio, 0);
 }
 

