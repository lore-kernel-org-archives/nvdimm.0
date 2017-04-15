Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 651262194EB6A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:40:38 -0700 (PDT)
Subject: [PATCH v2 20/33] dm: add ->copy_from_iter() dax operation support
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:34:53 -0700
Message-ID: <149222369379.32363.16175786503111000386.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Allow device-mapper to route copy_from_iter operations to the
per-target implementation. In order for the device stacking to work we
need a dax_dev and a pgoff relative to that device. This gives each
layer of the stack the information it needs to look up the operation
pointer for the next level.

This conceptually allows for an array of mixed device drivers with
varying copy_from_iter implementations.

Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c           |   13 +++++++++++++
 drivers/md/dm-linear.c        |   15 +++++++++++++++
 drivers/md/dm-stripe.c        |   20 ++++++++++++++++++++
 drivers/md/dm.c               |   26 ++++++++++++++++++++++++++
 include/linux/dax.h           |    2 ++
 include/linux/device-mapper.h |    3 +++
 6 files changed, 79 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 23ce3ab49f10..73f0da8e5d27 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -17,6 +17,7 @@
 #include <linux/cdev.h>
 #include <linux/hash.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
 
@@ -104,6 +105,18 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 }
 EXPORT_SYMBOL_GPL(dax_direct_access);
 
+size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t bytes, struct iov_iter *i)
+{
+	if (!dax_alive(dax_dev))
+		return 0;
+
+	if (!dax_dev->ops->copy_from_iter)
+		return copy_from_iter(addr, bytes, i);
+	return dax_dev->ops->copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+EXPORT_SYMBOL_GPL(dax_copy_from_iter);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index c5a52f4dae81..5fe44a0ddfab 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -158,6 +158,20 @@ static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
+static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	struct linear_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = linear_map_sector(ti, sector);
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 3, 0},
@@ -169,6 +183,7 @@ static struct target_type linear_target = {
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_dax_direct_access,
+	.dax_copy_from_iter = linear_dax_copy_from_iter,
 };
 
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index cb4b1e9e16ab..4f45d23249b2 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -330,6 +330,25 @@ static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
+static size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+	struct stripe_c *sc = ti->private;
+	struct dax_device *dax_dev;
+	struct block_device *bdev;
+	uint32_t stripe;
+
+	stripe_map_sector(sc, sector, &stripe, &dev_sector);
+	dev_sector += sc->stripe[stripe].physical_start;
+	dax_dev = sc->stripe[stripe].dev->dax_dev;
+	bdev = sc->stripe[stripe].dev->bdev;
+
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+
 /*
  * Stripe status:
  *
@@ -448,6 +467,7 @@ static struct target_type stripe_target = {
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
 	.direct_access = stripe_dax_direct_access,
+	.dax_copy_from_iter = stripe_dax_copy_from_iter,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 79d5f5fd823e..8c8579efcba2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,6 +19,7 @@
 #include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
+#include <linux/uio.h>
 #include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
@@ -957,6 +958,30 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
+static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	struct mapped_device *md = dax_get_private(dax_dev);
+	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dm_target *ti;
+	long ret = 0;
+	int srcu_idx;
+
+	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
+
+	if (!ti)
+		goto out;
+	if (!ti->type->dax_copy_from_iter) {
+		ret = copy_from_iter(addr, bytes, i);
+		goto out;
+	}
+	ret = ti->type->dax_copy_from_iter(ti, pgoff, addr, bytes, i);
+ out:
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -2818,6 +2843,7 @@ static const struct block_device_operations dm_blk_dops = {
 
 static const struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
+	.copy_from_iter = dm_dax_copy_from_iter,
 };
 
 /*
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 156f067d4db5..cd8561bb21f3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -32,6 +32,8 @@ void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);
+size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t bytes, struct iov_iter *i);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index df830d167892..e18e4277d09d 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -130,6 +130,8 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
  */
 typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
+typedef size_t (*dm_dax_copy_from_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i);
 #define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
@@ -179,6 +181,7 @@ struct target_type {
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
 	dm_dax_direct_access_fn direct_access;
+	dm_dax_copy_from_iter_fn dax_copy_from_iter;
 
 	/* For internal device-mapper use. */
 	struct list_head list;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
