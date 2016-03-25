Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 7A3D01A1F26
 for <linux-nvdimm@lists.01.org>; Fri, 25 Mar 2016 15:03:49 -0700 (PDT)
Subject: [PATCH v2] libnvdimm, blk: move i/o infrastructure to nd_namespace_blk
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Mar 2016 15:02:44 -0700
Message-ID: <20160325220143.32011.74455.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324012603.21436.60864.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012603.21436.60864.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Consolidate the information for issuing i/o to a blk-namespace, and
eliminate some pointer chasing.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes in v2:
 * rebased with the "dev_info => dev_dbg" change moved to its own patch.

 drivers/nvdimm/blk.c |  137 +++++++++++++++++++++++++-------------------------
 include/linux/nd.h   |    2 +
 2 files changed, 71 insertions(+), 68 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 26d039879ba2..4c14ecdc792b 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -21,17 +21,19 @@
 #include <linux/sizes.h>
 #include "nd.h"
 
-struct nd_blk_device {
-	struct nd_namespace_blk *nsblk;
-	struct nd_blk_region *ndbr;
-	size_t disk_size;
-	u32 sector_size;
-	u32 internal_lbasize;
-};
+static u32 nsblk_meta_size(struct nd_namespace_blk *nsblk)
+{
+	return nsblk->lbasize - ((nsblk->lbasize >= 4096) ? 4096 : 512);
+}
 
-static u32 nd_blk_meta_size(struct nd_blk_device *blk_dev)
+static u32 nsblk_internal_lbasize(struct nd_namespace_blk *nsblk)
 {
-	return blk_dev->nsblk->lbasize - blk_dev->sector_size;
+	return roundup(nsblk->lbasize, INT_LBASIZE_ALIGNMENT);
+}
+
+static u32 nsblk_sector_size(struct nd_namespace_blk *nsblk)
+{
+	return nsblk->lbasize - nsblk_meta_size(nsblk);
 }
 
 static resource_size_t to_dev_offset(struct nd_namespace_blk *nsblk,
@@ -55,20 +57,29 @@ static resource_size_t to_dev_offset(struct nd_namespace_blk *nsblk,
 	return SIZE_MAX;
 }
 
+static struct nd_blk_region *to_ndbr(struct nd_namespace_blk *nsblk)
+{
+	struct nd_region *nd_region;
+	struct device *parent;
+
+	parent = nsblk->common.dev.parent;
+	nd_region = container_of(parent, struct nd_region, dev);
+	return container_of(nd_region, struct nd_blk_region, nd_region);
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
-static int nd_blk_rw_integrity(struct nd_blk_device *blk_dev,
-				struct bio_integrity_payload *bip, u64 lba,
-				int rw)
+static int nd_blk_rw_integrity(struct nd_namespace_blk *nsblk,
+		struct bio_integrity_payload *bip, u64 lba, int rw)
 {
-	unsigned int len = nd_blk_meta_size(blk_dev);
+	struct nd_blk_region *ndbr = to_ndbr(nsblk);
+	unsigned int len = nsblk_meta_size(nsblk);
 	resource_size_t	dev_offset, ns_offset;
-	struct nd_namespace_blk *nsblk;
-	struct nd_blk_region *ndbr;
+	u32 internal_lbasize, sector_size;
 	int err = 0;
 
-	nsblk = blk_dev->nsblk;
-	ndbr = blk_dev->ndbr;
-	ns_offset = lba * blk_dev->internal_lbasize + blk_dev->sector_size;
+	internal_lbasize = nsblk_internal_lbasize(nsblk);
+	sector_size = nsblk_sector_size(nsblk);
+	ns_offset = lba * internal_lbasize + sector_size;
 	dev_offset = to_dev_offset(nsblk, ns_offset, len);
 	if (dev_offset == SIZE_MAX)
 		return -EIO;
@@ -102,25 +113,26 @@ static int nd_blk_rw_integrity(struct nd_blk_device *blk_dev,
 }
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
-static int nd_blk_rw_integrity(struct nd_blk_device *blk_dev,
-				struct bio_integrity_payload *bip, u64 lba,
-				int rw)
+static int nd_blk_rw_integrity(struct nd_namespace_blk *nsblk,
+		struct bio_integrity_payload *bip, u64 lba, int rw)
 {
 	return 0;
 }
 #endif
 
-static int nd_blk_do_bvec(struct nd_blk_device *blk_dev,
-			struct bio_integrity_payload *bip, struct page *page,
-			unsigned int len, unsigned int off, int rw,
-			sector_t sector)
+static int nsblk_do_bvec(struct nd_namespace_blk *nsblk,
+		struct bio_integrity_payload *bip, struct page *page,
+		unsigned int len, unsigned int off, int rw, sector_t sector)
 {
-	struct nd_blk_region *ndbr = blk_dev->ndbr;
+	struct nd_blk_region *ndbr = to_ndbr(nsblk);
 	resource_size_t	dev_offset, ns_offset;
+	u32 internal_lbasize, sector_size;
 	int err = 0;
 	void *iobuf;
 	u64 lba;
 
+	internal_lbasize = nsblk_internal_lbasize(nsblk);
+	sector_size = nsblk_sector_size(nsblk);
 	while (len) {
 		unsigned int cur_len;
 
@@ -130,11 +142,11 @@ static int nd_blk_do_bvec(struct nd_blk_device *blk_dev,
 		 * Block Window setup/move steps. the do_io routine is capable
 		 * of handling len <= PAGE_SIZE.
 		 */
-		cur_len = bip ? min(len, blk_dev->sector_size) : len;
+		cur_len = bip ? min(len, sector_size) : len;
 
-		lba = div_u64(sector << SECTOR_SHIFT, blk_dev->sector_size);
-		ns_offset = lba * blk_dev->internal_lbasize;
-		dev_offset = to_dev_offset(blk_dev->nsblk, ns_offset, cur_len);
+		lba = div_u64(sector << SECTOR_SHIFT, sector_size);
+		ns_offset = lba * internal_lbasize;
+		dev_offset = to_dev_offset(nsblk, ns_offset, cur_len);
 		if (dev_offset == SIZE_MAX)
 			return -EIO;
 
@@ -145,13 +157,13 @@ static int nd_blk_do_bvec(struct nd_blk_device *blk_dev,
 			return err;
 
 		if (bip) {
-			err = nd_blk_rw_integrity(blk_dev, bip, lba, rw);
+			err = nd_blk_rw_integrity(nsblk, bip, lba, rw);
 			if (err)
 				return err;
 		}
 		len -= cur_len;
 		off += cur_len;
-		sector += blk_dev->sector_size >> SECTOR_SHIFT;
+		sector += sector_size >> SECTOR_SHIFT;
 	}
 
 	return err;
@@ -160,7 +172,7 @@ static int nd_blk_do_bvec(struct nd_blk_device *blk_dev,
 static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct bio_integrity_payload *bip;
-	struct nd_blk_device *blk_dev;
+	struct nd_namespace_blk *nsblk;
 	struct bvec_iter iter;
 	unsigned long start;
 	struct bio_vec bvec;
@@ -179,17 +191,17 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	bip = bio_integrity(bio);
-	blk_dev = q->queuedata;
+	nsblk = q->queuedata;
 	rw = bio_data_dir(bio);
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
 		BUG_ON(len > PAGE_SIZE);
-		err = nd_blk_do_bvec(blk_dev, bip, bvec.bv_page, len,
-					bvec.bv_offset, rw, iter.bi_sector);
+		err = nsblk_do_bvec(nsblk, bip, bvec.bv_page, len,
+				bvec.bv_offset, rw, iter.bi_sector);
 		if (err) {
-			dev_dbg(&blk_dev->nsblk->common.dev,
+			dev_dbg(&nsblk->common.dev,
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
 					(unsigned long long) iter.bi_sector, len);
@@ -205,17 +217,16 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
-static int nd_blk_rw_bytes(struct nd_namespace_common *ndns,
+static int nsblk_rw_bytes(struct nd_namespace_common *ndns,
 		resource_size_t offset, void *iobuf, size_t n, int rw)
 {
-	struct nd_blk_device *blk_dev = dev_get_drvdata(ndns->claim);
-	struct nd_namespace_blk *nsblk = blk_dev->nsblk;
-	struct nd_blk_region *ndbr = blk_dev->ndbr;
+	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(&ndns->dev);
+	struct nd_blk_region *ndbr = to_ndbr(nsblk);
 	resource_size_t	dev_offset;
 
 	dev_offset = to_dev_offset(nsblk, offset, n);
 
-	if (unlikely(offset + n > blk_dev->disk_size)) {
+	if (unlikely(offset + n > nsblk->size)) {
 		dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
 		return -EFAULT;
 	}
@@ -242,16 +253,16 @@ static void nd_blk_release_disk(void *disk)
 	put_disk(disk);
 }
 
-static int nd_blk_attach_disk(struct device *dev,
-		struct nd_namespace_common *ndns, struct nd_blk_device *blk_dev)
+static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 {
+	struct device *dev = &nsblk->common.dev;
 	resource_size_t available_disk_size;
 	struct request_queue *q;
 	struct gendisk *disk;
 	u64 internal_nlba;
 
-	internal_nlba = div_u64(blk_dev->disk_size, blk_dev->internal_lbasize);
-	available_disk_size = internal_nlba * blk_dev->sector_size;
+	internal_nlba = div_u64(nsblk->size, nsblk_internal_lbasize(nsblk));
+	available_disk_size = internal_nlba * nsblk_sector_size(nsblk);
 
 	q = blk_alloc_queue(GFP_KERNEL);
 	if (!q)
@@ -264,9 +275,9 @@ static int nd_blk_attach_disk(struct device *dev,
 	blk_queue_make_request(q, nd_blk_make_request);
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
-	blk_queue_logical_block_size(q, blk_dev->sector_size);
+	blk_queue_logical_block_size(q, nsblk_sector_size(nsblk));
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
-	q->queuedata = blk_dev;
+	q->queuedata = nsblk;
 
 	disk = alloc_disk(0);
 	if (!disk)
@@ -276,17 +287,17 @@ static int nd_blk_attach_disk(struct device *dev,
 		return -ENOMEM;
 	}
 
-	disk->driverfs_dev	= &ndns->dev;
+	disk->driverfs_dev	= dev;
 	disk->first_minor	= 0;
 	disk->fops		= &nd_blk_fops;
 	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
-	nvdimm_namespace_disk_name(ndns, disk->disk_name);
+	nvdimm_namespace_disk_name(&nsblk->common, disk->disk_name);
 	set_capacity(disk, 0);
 	add_disk(disk);
 
-	if (nd_blk_meta_size(blk_dev)) {
-		int rc = nd_integrity_init(disk, nd_blk_meta_size(blk_dev));
+	if (nsblk_meta_size(nsblk)) {
+		int rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
 
 		if (rc)
 			return rc;
@@ -301,33 +312,23 @@ static int nd_blk_probe(struct device *dev)
 {
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_blk *nsblk;
-	struct nd_blk_device *blk_dev;
 
 	ndns = nvdimm_namespace_common_probe(dev);
 	if (IS_ERR(ndns))
 		return PTR_ERR(ndns);
 
-	blk_dev = devm_kzalloc(dev, sizeof(*blk_dev), GFP_KERNEL);
-	if (!blk_dev)
-		return -ENOMEM;
-
 	nsblk = to_nd_namespace_blk(&ndns->dev);
-	blk_dev->disk_size = nvdimm_namespace_capacity(ndns);
-	blk_dev->ndbr = to_nd_blk_region(dev->parent);
-	blk_dev->nsblk = to_nd_namespace_blk(&ndns->dev);
-	blk_dev->internal_lbasize = roundup(nsblk->lbasize,
-						INT_LBASIZE_ALIGNMENT);
-	blk_dev->sector_size = ((nsblk->lbasize >= 4096) ? 4096 : 512);
-	dev_set_drvdata(dev, blk_dev);
-
-	ndns->rw_bytes = nd_blk_rw_bytes;
+	nsblk->size = nvdimm_namespace_capacity(ndns);
+	dev_set_drvdata(dev, nsblk);
+
+	ndns->rw_bytes = nsblk_rw_bytes;
 	if (is_nd_btt(dev))
 		return nvdimm_namespace_attach_btt(ndns);
-	else if (nd_btt_probe(dev, ndns, blk_dev) == 0) {
+	else if (nd_btt_probe(dev, ndns, nsblk) == 0) {
 		/* we'll come back as btt-blk */
 		return -ENXIO;
 	} else
-		return nd_blk_attach_disk(dev, ndns, blk_dev);
+		return nsblk_attach_disk(nsblk);
 }
 
 static int nd_blk_remove(struct device *dev)
diff --git a/include/linux/nd.h b/include/linux/nd.h
index 5489ab756d1a..5ea4aec7fd63 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -82,6 +82,7 @@ struct nd_namespace_pmem {
  * @uuid: namespace name supplied in the dimm label
  * @id: ida allocated id
  * @lbasize: blk namespaces have a native sector size when btt not present
+ * @size: sum of all the resource ranges allocated to this namespace
  * @num_resources: number of dpa extents to claim
  * @res: discontiguous dpa extents for given dimm
  */
@@ -91,6 +92,7 @@ struct nd_namespace_blk {
 	u8 *uuid;
 	int id;
 	unsigned long lbasize;
+	resource_size_t size;
 	int num_resources;
 	struct resource **res;
 };

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
