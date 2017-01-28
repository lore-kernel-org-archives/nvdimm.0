Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F117A81FF4
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:41:14 -0800 (PST)
Subject: [RFC PATCH 12/17] dm: add dax_operations support (consumer)
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:37:08 -0800
Message-ID: <148559262885.11180.15866050277537726376.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Arrange for dm to lookup the dax services available from member
devices. Update the dax-capable targets, linear and stripe, to route dax
operations to the underlying device.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/dm-linear.c        |   24 ++++++++++++++++++++++++
 drivers/md/dm-snap.c          |   12 ++++++++++++
 drivers/md/dm-stripe.c        |   30 ++++++++++++++++++++++++++++++
 drivers/md/dm-target.c        |   11 +++++++++++
 drivers/md/dm.c               |   16 ++++++++++++----
 include/linux/device-mapper.h |    7 +++++++
 6 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 4788b0b989a9..e91ca8089333 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -159,6 +159,29 @@ static long linear_direct_access(struct dm_target *ti, sector_t sector,
 	return ret;
 }
 
+static long linear_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
+				     void **kaddr, pfn_t *pfn, long size)
+{
+	struct linear_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_inode *dax_inode = lc->dev->dax_inode;
+	struct blk_dax_ctl dax = {
+		.sector = linear_map_sector(ti, dev_addr >> SECTOR_SHIFT),
+		.size = size,
+	};
+	long ret;
+
+	ret = bdev_dax_direct_access(bdev, dax_inode, &dax);
+	*kaddr = dax.addr;
+	*pfn = dax.pfn;
+
+	return ret;
+}
+
+static const struct dm_dax_operations linear_dax_ops = {
+	.dm_direct_access = linear_dax_direct_access,
+};
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 3, 0},
@@ -170,6 +193,7 @@ static struct target_type linear_target = {
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_direct_access,
+	.dax_ops = &linear_dax_ops,
 };
 
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c65feeada864..1990e3bd6958 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2309,6 +2309,13 @@ static long origin_direct_access(struct dm_target *ti, sector_t sector,
 	return -EIO;
 }
 
+static long origin_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
+		void **kaddr, pfn_t *pfn, long size)
+{
+	DMWARN("device does not support dax.");
+	return -EIO;
+}
+
 /*
  * Set the target "max_io_len" field to the minimum of all the snapshots'
  * chunk sizes.
@@ -2357,6 +2364,10 @@ static int origin_iterate_devices(struct dm_target *ti,
 	return fn(ti, o->dev, 0, ti->len, data);
 }
 
+static const struct dm_dax_operations origin_dax_ops = {
+	.dm_direct_access = origin_dax_direct_access,
+};
+
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
 	.version = {1, 9, 0},
@@ -2369,6 +2380,7 @@ static struct target_type origin_target = {
 	.status  = origin_status,
 	.iterate_devices = origin_iterate_devices,
 	.direct_access = origin_direct_access,
+	.dax_ops = &origin_dax_ops,
 };
 
 static struct target_type snapshot_target = {
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 28193a57bf47..47fb56a6184a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -331,6 +331,31 @@ static long stripe_direct_access(struct dm_target *ti, sector_t sector,
 	return ret;
 }
 
+static long stripe_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
+		void **kaddr, pfn_t *pfn, long size)
+{
+	struct stripe_c *sc = ti->private;
+	uint32_t stripe;
+	struct block_device *bdev;
+	struct dax_inode *dax_inode;
+	struct blk_dax_ctl dax = {
+		.size = size,
+	};
+	long ret;
+
+	stripe_map_sector(sc, dev_addr >> SECTOR_SHIFT, &stripe, &dax.sector);
+
+	dax.sector += sc->stripe[stripe].physical_start;
+	bdev = sc->stripe[stripe].dev->bdev;
+	dax_inode = sc->stripe[stripe].dev->dax_inode;
+
+	ret = bdev_dax_direct_access(bdev, dax_inode, &dax);
+	*kaddr = dax.addr;
+	*pfn = dax.pfn;
+
+	return ret;
+}
+
 /*
  * Stripe status:
  *
@@ -437,6 +462,10 @@ static void stripe_io_hints(struct dm_target *ti,
 	blk_limits_io_opt(limits, chunk_size * sc->stripes);
 }
 
+static const struct dm_dax_operations stripe_dax_ops = {
+	.dm_direct_access = stripe_dax_direct_access,
+};
+
 static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 6, 0},
@@ -449,6 +478,7 @@ static struct target_type stripe_target = {
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
 	.direct_access = stripe_direct_access,
+	.dax_ops = &stripe_dax_ops,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 710ae28fd618..ab072f53cf24 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -154,6 +154,16 @@ static long io_err_direct_access(struct dm_target *ti, sector_t sector,
 	return -EIO;
 }
 
+static long io_err_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
+				     void **kaddr, pfn_t *pfn, long size)
+{
+	return -EIO;
+}
+
+static const struct dm_dax_operations err_dax_ops = {
+	.dm_direct_access = io_err_dax_direct_access,
+};
+
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 5, 0},
@@ -165,6 +175,7 @@ static struct target_type error_target = {
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
 	.direct_access = io_err_direct_access,
+	.dax_ops = &err_dax_ops,
 };
 
 int __init dm_target_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b3d9253e92c..5c5eeda0eb0a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -627,6 +627,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
 	}
 
 	td->dm_dev.bdev = bdev;
+	td->dm_dev.dax_inode = dax_get_by_host(bdev->bd_disk->disk_name);
 	return 0;
 }
 
@@ -640,7 +641,9 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
+	put_dax_inode(td->dm_dev.dax_inode);
 	td->dm_dev.bdev = NULL;
+	td->dm_dev.dax_inode = NULL;
 }
 
 static struct table_device *find_table_device(struct list_head *l, dev_t dev,
@@ -907,7 +910,7 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
 static long __dm_direct_access(struct mapped_device *md, phys_addr_t dev_addr,
-			       void **kaddr, pfn_t *pfn, long size)
+			       void **kaddr, pfn_t *pfn, long size, bool blk)
 {
 	sector_t sector = dev_addr >> SECTOR_SHIFT;
 	struct dm_table *map;
@@ -926,8 +929,11 @@ static long __dm_direct_access(struct mapped_device *md, phys_addr_t dev_addr,
 	len = max_io_len(sector, ti) << SECTOR_SHIFT;
 	size = min(len, size);
 
-	if (ti->type->direct_access)
+	if (blk && ti->type->direct_access)
 		ret = ti->type->direct_access(ti, sector, kaddr, pfn, size);
+	else if (ti->type->dax_ops)
+		ret = ti->type->dax_ops->dm_direct_access(ti, dev_addr, kaddr,
+				pfn, size);
 out:
 	dm_put_live_table(md, srcu_idx);
 	return min(ret, size);
@@ -938,7 +944,8 @@ static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 
-	return __dm_direct_access(md, sector << SECTOR_SHIFT, kaddr, pfn, size);
+	return __dm_direct_access(md, sector << SECTOR_SHIFT, kaddr, pfn, size,
+			true);
 }
 
 static long dm_dax_direct_access(struct dax_inode *dax_inode,
@@ -947,7 +954,8 @@ static long dm_dax_direct_access(struct dax_inode *dax_inode,
 {
 	struct mapped_device *md = dax_inode_get_private(dax_inode);
 
-	return __dm_direct_access(md, dev_addr, kaddr, pfn, size);
+	return __dm_direct_access(md, dev_addr, kaddr, pfn, size,
+			false);
 }
 
 /*
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ef7962e84444..1b64f412bb45 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -137,12 +137,18 @@ void dm_error(const char *message);
 
 struct dm_dev {
 	struct block_device *bdev;
+	struct dax_inode *dax_inode;
 	fmode_t mode;
 	char name[16];
 };
 
 dev_t dm_get_dev_t(const char *path);
 
+struct dm_dax_operations {
+	long (*dm_direct_access)(struct dm_target *ti, phys_addr_t dev_addr,
+			void **kaddr, pfn_t *pfn, long size);
+};
+
 /*
  * Constructors should call these functions to ensure destination devices
  * are opened/closed correctly.
@@ -180,6 +186,7 @@ struct target_type {
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
 	dm_direct_access_fn direct_access;
+	const struct dm_dax_operations *dax_ops;
 
 	/* For internal device-mapper use. */
 	struct list_head list;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
