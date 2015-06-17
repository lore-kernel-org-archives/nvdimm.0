Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 09/15] libnvdimm, blk: add support for blk integrity
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:55:35 -0400
Message-ID: <20150617235535.12943.9582.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@linux.intel.com>

Support multiple block sizes (sector + metadata) for nd_blk in the
same way as done for the BTT. Add the idea of an 'internal' lbasize,
which is properly aligned and padded, and store metadata in this space.

Signed-off-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c            |  168 ++++++++++++++++++++++++++++++++++-----
 drivers/nvdimm/btt.h            |    1 
 drivers/nvdimm/bus.c            |   28 +++++--
 drivers/nvdimm/core.c           |    3 +
 drivers/nvdimm/namespace_devs.c |    3 -
 drivers/nvdimm/nd.h             |    3 +
 6 files changed, 174 insertions(+), 32 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index a2749b5e43d7..feddad325f97 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -27,10 +27,17 @@ struct nd_blk_device {
 	struct nd_namespace_blk *nsblk;
 	struct nd_blk_region *ndbr;
 	size_t disk_size;
+	u32 sector_size;
+	u32 internal_lbasize;
 };
 
 static int nd_blk_major;
 
+static u32 nd_blk_meta_size(struct nd_blk_device *blk_dev)
+{
+	return blk_dev->nsblk->lbasize - blk_dev->sector_size;
+}
+
 static resource_size_t to_dev_offset(struct nd_namespace_blk *nsblk,
 				resource_size_t ns_offset, unsigned int len)
 {
@@ -52,13 +59,114 @@ static resource_size_t to_dev_offset(struct nd_namespace_blk *nsblk,
 	return SIZE_MAX;
 }
 
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+static int nd_blk_rw_integrity(struct nd_blk_device *blk_dev,
+				struct bio_integrity_payload *bip, u64 lba,
+				int rw)
+{
+	unsigned int len = nd_blk_meta_size(blk_dev);
+	resource_size_t	dev_offset, ns_offset;
+	struct nd_namespace_blk *nsblk;
+	struct nd_blk_region *ndbr;
+	int err = 0;
+
+	nsblk = blk_dev->nsblk;
+	ndbr = blk_dev->ndbr;
+	ns_offset = lba * blk_dev->internal_lbasize + blk_dev->sector_size;
+	dev_offset = to_dev_offset(nsblk, ns_offset, len);
+	if (dev_offset == SIZE_MAX)
+		return -EIO;
+
+	while (len) {
+		unsigned int cur_len;
+		struct bio_vec bv;
+		void *iobuf;
+
+		bv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
+		/*
+		 * The 'bv' obtained from bvec_iter_bvec has its .bv_len and
+		 * .bv_offset already adjusted for iter->bi_bvec_done, and we
+		 * can use those directly
+		 */
+
+		cur_len = min(len, bv.bv_len);
+		iobuf = kmap_atomic(bv.bv_page);
+		err = ndbr->do_io(ndbr, dev_offset, iobuf + bv.bv_offset,
+				cur_len, rw);
+		kunmap_atomic(iobuf);
+		if (err)
+			return err;
+
+		len -= cur_len;
+		dev_offset += cur_len;
+		bvec_iter_advance(bip->bip_vec, &bip->bip_iter, cur_len);
+	}
+
+	return err;
+}
+
+#else /* CONFIG_BLK_DEV_INTEGRITY */
+static int nd_blk_rw_integrity(struct nd_blk_device *blk_dev,
+				struct bio_integrity_payload *bip, u64 lba,
+				int rw)
+{
+	return 0;
+}
+#endif
+
+static int nd_blk_do_bvec(struct nd_blk_device *blk_dev,
+			struct bio_integrity_payload *bip, struct page *page,
+			unsigned int len, unsigned int off, int rw,
+			sector_t sector)
+{
+	struct nd_blk_region *ndbr = blk_dev->ndbr;
+	resource_size_t	dev_offset, ns_offset;
+	int err = 0;
+	void *iobuf;
+	u64 lba;
+
+	while (len) {
+		unsigned int cur_len;
+
+		/*
+		 * If we don't have an integrity payload, we don't have to
+		 * split the bvec into sectors, as this would cause unnecessary
+		 * Block Window setup/move steps. the do_io routine is capable
+		 * of handling len <= PAGE_SIZE.
+		 */
+		cur_len = bip ? min(len, blk_dev->sector_size) : len;
+
+		lba = div_u64(sector << SECTOR_SHIFT, blk_dev->sector_size);
+		ns_offset = lba * blk_dev->internal_lbasize;
+		dev_offset = to_dev_offset(blk_dev->nsblk, ns_offset, cur_len);
+		if (dev_offset == SIZE_MAX)
+			return -EIO;
+
+		iobuf = kmap_atomic(page);
+		err = ndbr->do_io(ndbr, dev_offset, iobuf + off, cur_len, rw);
+		kunmap_atomic(iobuf);
+		if (err)
+			return err;
+
+		if (bip) {
+			err = nd_blk_rw_integrity(blk_dev, bip, lba, rw);
+			if (err)
+				return err;
+		}
+		len -= cur_len;
+		off += cur_len;
+		sector += blk_dev->sector_size >> SECTOR_SHIFT;
+	}
+
+	return err;
+}
+
 static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct block_device *bdev = bio->bi_bdev;
 	struct gendisk *disk = bdev->bd_disk;
-	struct nd_namespace_blk *nsblk;
+	struct bio_integrity_payload *bip;
 	struct nd_blk_device *blk_dev;
-	struct nd_blk_region *ndbr;
 	struct bvec_iter iter;
 	struct bio_vec bvec;
 	int err = 0, rw;
@@ -74,29 +182,33 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 
 	rw = bio_data_dir(bio);
 
+	/*
+	 * bio_integrity_enabled also checks if the bio already has an
+	 * integrity payload attached. If it does, we *don't* do a
+	 * bio_integrity_prep here - the payload has been generated by
+	 * another kernel subsystem, and we just pass it through.
+	 */
+	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
+		err = -EIO;
+		goto out;
+	}
+
+	bip = bio_integrity(bio);
 	blk_dev = disk->private_data;
-	nsblk = blk_dev->nsblk;
-	ndbr = blk_dev->ndbr;
+
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
-		resource_size_t	dev_offset;
-		void *iobuf;
 
 		BUG_ON(len > PAGE_SIZE);
-
-		dev_offset = to_dev_offset(nsblk, sector << SECTOR_SHIFT, len);
-		if (dev_offset == SIZE_MAX) {
-			err = -EIO;
+		err = nd_blk_do_bvec(blk_dev, bip, bvec.bv_page, len,
+					bvec.bv_offset, rw, sector);
+		if (err) {
+			dev_info(&blk_dev->nsblk->dev,
+					"io error in %s sector %lld, len %d,\n",
+					(rw == READ) ? "READ" : "WRITE",
+					(unsigned long long) sector, len);
 			goto out;
 		}
-
-		iobuf = kmap_atomic(bvec.bv_page);
-		err = ndbr->do_io(ndbr, dev_offset, iobuf + bvec.bv_offset,
-				len, rw);
-		kunmap_atomic(iobuf);
-		if (err)
-			goto out;
-
 		sector += len >> SECTOR_SHIFT;
 	}
 
@@ -135,7 +247,8 @@ static int nd_blk_probe(struct device *dev)
 	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct nd_blk_device *blk_dev;
-	resource_size_t disk_size;
+	resource_size_t disk_size, available_disk_size;
+	u64 internal_nlba;
 	struct gendisk *disk;
 	int err;
 
@@ -148,6 +261,9 @@ static int nd_blk_probe(struct device *dev)
 		return -ENOMEM;
 
 	blk_dev->disk_size	= disk_size;
+	blk_dev->sector_size = ((nsblk->lbasize >= 4096) ? 4096 : 512);
+	blk_dev->internal_lbasize = roundup(nsblk->lbasize,
+						INT_LBASIZE_ALIGNMENT);
 
 	blk_dev->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!blk_dev->queue) {
@@ -158,7 +274,7 @@ static int nd_blk_probe(struct device *dev)
 	blk_queue_make_request(blk_dev->queue, nd_blk_make_request);
 	blk_queue_max_hw_sectors(blk_dev->queue, 1024);
 	blk_queue_bounce_limit(blk_dev->queue, BLK_BOUNCE_ANY);
-	blk_queue_logical_block_size(blk_dev->queue, nsblk->lbasize);
+	blk_queue_logical_block_size(blk_dev->queue, blk_dev->sector_size);
 
 	disk = blk_dev->disk = alloc_disk(0);
 	if (!disk) {
@@ -177,13 +293,21 @@ static int nd_blk_probe(struct device *dev)
 	disk->queue		= blk_dev->queue;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	sprintf(disk->disk_name, "ndblk%d.%d", nd_region->id, nsblk->id);
-	set_capacity(disk, disk_size >> SECTOR_SHIFT);
+	set_capacity(disk, 0);
 
+	internal_nlba = div_u64(disk_size, blk_dev->internal_lbasize);
+	available_disk_size = internal_nlba * blk_dev->sector_size;
 	dev_set_drvdata(dev, blk_dev);
-	nvdimm_bus_add_disk(disk);
+	err = nvdimm_bus_add_integrity_disk(disk, nd_blk_meta_size(blk_dev),
+			available_disk_size >> SECTOR_SHIFT);
+	if (err)
+		goto err_add_disk;
 
 	return 0;
 
+ err_add_disk:
+	del_gendisk(disk);
+	put_disk(disk);
  err_alloc_disk:
 	blk_cleanup_queue(blk_dev->queue);
  err_alloc_queue:
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index 2caa0ef7e67a..75b0d80a6bd9 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -31,7 +31,6 @@
 #define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
 #define RTT_VALID (1UL << 31)
 #define RTT_INVALID 0
-#define INT_LBASIZE_ALIGNMENT 64
 #define BTT_PG_SIZE 4096
 #define BTT_DEFAULT_NFREE ND_MAX_LANES
 #define LOG_SEQ_INIT 1
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 3c14fee5aff4..d4fbc48f5643 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -243,17 +243,13 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 }
 EXPORT_SYMBOL(__nd_driver_register);
 
-/**
- * nvdimm_bus_add_disk() - attach and run actions on an nvdimm block device
- * @disk: disk device being registered
- *
- * Note, that @disk must be a descendant of an nvdimm_bus
- */
-int nvdimm_bus_add_disk(struct gendisk *disk)
+int nvdimm_bus_add_integrity_disk(struct gendisk *disk, u32 lbasize,
+		sector_t size)
 {
 	const struct block_device_operations *ops = disk->fops;
 	struct device *dev = disk->driverfs_dev;
 	struct nvdimm_bus *nvdimm_bus;
+	int rc;
 
 	nvdimm_bus = walk_to_nvdimm_bus(dev);
 	if (!nvdimm_bus || !ops->rw_bytes)
@@ -266,10 +262,25 @@ int nvdimm_bus_add_disk(struct gendisk *disk)
 	 */
 	nvdimm_bus_lock(&nvdimm_bus->dev);
 	add_disk(disk);
+	rc = nd_integrity_init(disk, lbasize);
+	if (size)
+		set_capacity(disk, size);
 	nd_btt_add_disk(nvdimm_bus, disk);
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 
-	return 0;
+	return rc;
+}
+EXPORT_SYMBOL(nvdimm_bus_add_integrity_disk);
+
+/**
+ * nvdimm_bus_add_disk() - attach and run actions on an nvdimm block device
+ * @disk: disk device being registered
+ *
+ * Note, that @disk must be a descendant of an nvdimm_bus
+ */
+int nvdimm_bus_add_disk(struct gendisk *disk)
+{
+	return nvdimm_bus_add_integrity_disk(disk, 0, 0);
 }
 EXPORT_SYMBOL(nvdimm_bus_add_disk);
 
@@ -292,6 +303,7 @@ void nvdimm_bus_remove_disk(struct gendisk *disk)
 	 */
 	nd_synchronize();
 
+	blk_integrity_unregister(disk);
 	del_gendisk(disk);
 	put_disk(disk);
 }
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 36f112995c0c..8f466c384b30 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -399,6 +399,9 @@ int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
 	};
 	int ret;
 
+	if (meta_size == 0)
+		return 0;
+
 	ret = blk_integrity_register(disk, &integrity);
 	if (ret)
 		return ret;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 68780d768e7b..0fe541a1df49 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1013,7 +1013,8 @@ static ssize_t resource_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(resource);
 
-static const unsigned long ns_lbasize_supported[] = { 512, 0 };
+static const unsigned long ns_lbasize_supported[] = { 512, 520, 528,
+	4096, 4104, 4160, 4224, 0 };
 
 static ssize_t sector_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 1cea3f191a83..9b5fdb2215b1 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -29,6 +29,7 @@ enum {
 	 */
 	ND_MAX_LANES = 256,
 	SECTOR_SHIFT = 9,
+	INT_LBASIZE_ALIGNMENT = 64,
 };
 
 struct nvdimm_drvdata {
@@ -159,6 +160,8 @@ void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
 bool is_nvdimm_bus_locked(struct device *dev);
 int nvdimm_bus_add_disk(struct gendisk *disk);
+int nvdimm_bus_add_integrity_disk(struct gendisk *disk, u32 lbasize,
+		sector_t size);
 void nvdimm_bus_remove_disk(struct gendisk *disk);
 void nvdimm_drvdata_release(struct kref *kref);
 void put_ndd(struct nvdimm_drvdata *ndd);

