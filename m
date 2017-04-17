Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64ECE2194EB6E
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:15:38 -0700 (PDT)
Subject: [resend PATCH v2 12/33] dm: teach dm-targets to use a dax_device +
 dax_operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:09:54 -0700
Message-ID: <149245619411.10206.663478007606647587.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Arrange for dm to lookup the dax services available from member devices.
Update the dax-capable targets, linear and stripe, to route dax
operations to the underlying device. Changes the target-internal
->direct_access() method to more closely align with the dax_operations
->direct_access() calling convention.

Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/dm-linear.c        |   27 +++++++++++++--------------
 drivers/md/dm-snap.c          |    6 +++---
 drivers/md/dm-stripe.c        |   29 ++++++++++++++---------------
 drivers/md/dm-target.c        |    6 +++---
 drivers/md/dm.c               |   16 ++++++----------
 include/linux/device-mapper.h |    7 ++++---
 6 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 4788b0b989a9..c5a52f4dae81 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
+#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/device-mapper.h>
 
@@ -141,22 +142,20 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
-static long linear_direct_access(struct dm_target *ti, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
+static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
 {
+	long ret;
 	struct linear_c *lc = ti->private;
 	struct block_device *bdev = lc->dev->bdev;
-	struct blk_dax_ctl dax = {
-		.sector = linear_map_sector(ti, sector),
-		.size = size,
-	};
-	long ret;
-
-	ret = bdev_direct_access(bdev, &dax);
-	*kaddr = dax.addr;
-	*pfn = dax.pfn;
-
-	return ret;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = linear_map_sector(ti, sector);
+	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
+	if (ret)
+		return ret;
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
 static struct target_type linear_target = {
@@ -169,7 +168,7 @@ static struct target_type linear_target = {
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
-	.direct_access = linear_direct_access,
+	.direct_access = linear_dax_direct_access,
 };
 
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c65feeada864..e152d9817c81 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2302,8 +2302,8 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 	return do_origin(o->dev, bio);
 }
 
-static long origin_direct_access(struct dm_target *ti, sector_t sector,
-		void **kaddr, pfn_t *pfn, long size)
+static long origin_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
 {
 	DMWARN("device does not support dax.");
 	return -EIO;
@@ -2368,7 +2368,7 @@ static struct target_type origin_target = {
 	.postsuspend = origin_postsuspend,
 	.status  = origin_status,
 	.iterate_devices = origin_iterate_devices,
-	.direct_access = origin_direct_access,
+	.direct_access = origin_dax_direct_access,
 };
 
 static struct target_type snapshot_target = {
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 28193a57bf47..cb4b1e9e16ab 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
+#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
 
@@ -308,27 +309,25 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static long stripe_direct_access(struct dm_target *ti, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
+static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
 {
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
 	struct stripe_c *sc = ti->private;
-	uint32_t stripe;
+	struct dax_device *dax_dev;
 	struct block_device *bdev;
-	struct blk_dax_ctl dax = {
-		.size = size,
-	};
+	uint32_t stripe;
 	long ret;
 
-	stripe_map_sector(sc, sector, &stripe, &dax.sector);
-
-	dax.sector += sc->stripe[stripe].physical_start;
+	stripe_map_sector(sc, sector, &stripe, &dev_sector);
+	dev_sector += sc->stripe[stripe].physical_start;
+	dax_dev = sc->stripe[stripe].dev->dax_dev;
 	bdev = sc->stripe[stripe].dev->bdev;
 
-	ret = bdev_direct_access(bdev, &dax);
-	*kaddr = dax.addr;
-	*pfn = dax.pfn;
-
-	return ret;
+	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
+	if (ret)
+		return ret;
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
 /*
@@ -448,7 +447,7 @@ static struct target_type stripe_target = {
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
-	.direct_access = stripe_direct_access,
+	.direct_access = stripe_dax_direct_access,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 43d3445b121d..6a7968f93f3c 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -142,8 +142,8 @@ static void io_err_release_clone_rq(struct request *clone)
 {
 }
 
-static long io_err_direct_access(struct dm_target *ti, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
+static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
 {
 	return -EIO;
 }
@@ -157,7 +157,7 @@ static struct target_type error_target = {
 	.map  = io_err_map,
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
-	.direct_access = io_err_direct_access,
+	.direct_access = io_err_dax_direct_access,
 };
 
 int __init dm_target_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index bd56dfe43a99..ef4c6f8cad47 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -630,6 +630,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
 	}
 
 	td->dm_dev.bdev = bdev;
+	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	return 0;
 }
 
@@ -643,7 +644,9 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
+	put_dax(td->dm_dev.dax_dev);
 	td->dm_dev.bdev = NULL;
+	td->dm_dev.dax_dev = NULL;
 }
 
 static struct table_device *find_table_device(struct list_head *l, dev_t dev,
@@ -945,16 +948,9 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (len < 1)
 		goto out;
 	nr_pages = min(len, nr_pages);
-	if (ti->type->direct_access) {
-		ret = ti->type->direct_access(ti, sector, kaddr, pfn,
-				nr_pages * PAGE_SIZE);
-		/*
-		 * FIXME: convert ti->type->direct_access to return
-		 * nr_pages directly.
-		 */
-		if (ret >= 0)
-			ret /= PAGE_SIZE;
-	}
+	if (ti->type->direct_access)
+		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
+
  out:
 	dm_put_live_table(md, srcu_idx);
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index bcba4d89089c..df830d167892 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -128,14 +128,15 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
  *  < 0 : error
  * >= 0 : the number of bytes accessible at the address
  */
-typedef long (*dm_direct_access_fn) (struct dm_target *ti, sector_t sector,
-				     void **kaddr, pfn_t *pfn, long size);
+typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
 #define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
 
 struct dm_dev {
 	struct block_device *bdev;
+	struct dax_device *dax_dev;
 	fmode_t mode;
 	char name[16];
 };
@@ -177,7 +178,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
-	dm_direct_access_fn direct_access;
+	dm_dax_direct_access_fn direct_access;
 
 	/* For internal device-mapper use. */
 	struct list_head list;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
