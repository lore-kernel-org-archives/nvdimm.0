Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 12/15] libnvdimm: enable iostat
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:55:51 -0400
Message-ID: <20150617235551.12943.76656.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This is disabled by default as the overhead is prohibitive, but if the
user takes the action to turn it on we'll oblige.

Reviewed-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig |   14 ++++++++++++++
 drivers/nvdimm/blk.c   |    7 ++++++-
 drivers/nvdimm/btt.c   |    7 ++++++-
 drivers/nvdimm/core.c  |   31 +++++++++++++++++++++++++++++++
 drivers/nvdimm/nd.h    |   13 +++++++++++++
 drivers/nvdimm/pmem.c  |    5 +++++
 6 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 912cb36b8435..9d72085a67c9 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -73,4 +73,18 @@ config ND_MAX_REGIONS
 
 	  Leave the default of 64 if you are unsure.
 
+config ND_IOSTAT
+	bool "Enable iostat by default"
+	default n
+	---help---
+	  Persistent memory i/o has very low latency to the point
+	  where the overhead to measure statistics can dramatically
+	  impact the relative performance of the driver.  Say y here
+	  to trade off performance for statistics gathering that is
+	  enabled by default.  These statistics can always be
+	  enabled/disabled at run time via the 'iostat' attribute of
+	  the block device's queue in sysfs.
+
+	  If unsure, say N
+
 endif
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 9d609ef95266..8a65e5a500d8 100644
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
 
 	if (unlikely(bio_end_sector(bio) > get_capacity(disk))) {
 		err = -EIO;
@@ -191,6 +193,7 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	blk_dev = disk->private_data;
 
 	rw = bio_data_dir(bio);
+	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -202,9 +205,11 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
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
index 83b798dd2e68..67484633c322 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1178,8 +1178,10 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 	struct block_device *bdev = bio->bi_bdev;
 	struct btt *btt = q->queuedata;
 	struct bvec_iter iter;
+	unsigned long start;
 	struct bio_vec bvec;
 	int err = 0, rw;
+	bool do_acct;
 
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
 		err = -EIO;
@@ -1199,6 +1201,7 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 		goto out;
 	}
 
+	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -1215,9 +1218,11 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
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
index d27b13357873..99cf95af5f24 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -218,9 +218,40 @@ void nd_blk_queue_init(struct request_queue *q)
 {
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
+	if (IS_ENABLED(CONFIG_ND_IOSTAT))
+		queue_flag_set_unlocked(QUEUE_FLAG_IO_STAT, q);
 }
 EXPORT_SYMBOL(nd_blk_queue_init);
 
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
index 2f20d5dca028..3c4c8b6c64ec 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -13,6 +13,7 @@
 #ifndef __ND_H__
 #define __ND_H__
 #include <linux/libnvdimm.h>
+#include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/genhd.h>
 #include <linux/mutex.h>
@@ -172,5 +173,17 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 		resource_size_t n);
 int nd_blk_region_init(struct nd_region *nd_region);
 void nd_blk_queue_init(struct request_queue *q);
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
index 0337b00f5409..3fd854a78f09 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -59,6 +59,8 @@ static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 static void pmem_make_request(struct request_queue *q, struct bio *bio)
 {
 	int err = 0;
+	bool do_acct;
+	unsigned long start;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	struct block_device *bdev = bio->bi_bdev;
@@ -69,9 +71,12 @@ static void pmem_make_request(struct request_queue *q, struct bio *bio)
 		goto out;
 	}
 
+	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter)
 		pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len, bvec.bv_offset,
 				bio_data_dir(bio), iter.bi_sector);
+	if (do_acct)
+		nd_iostat_end(bio, start);
 
 out:
 	bio_endio(bio, err);

