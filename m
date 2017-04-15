Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E057421939249
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:40:53 -0700 (PDT)
Subject: [PATCH v2 23/33] dm: add ->flush() dax operation support
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:35:09 -0700
Message-ID: <149222370972.32363.15258857121040366681.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Allow device-mapper to route flush operations to the
per-target implementation. In order for the device stacking to work we
need a dax_dev and a pgoff relative to that device. This gives each
layer of the stack the information it needs to look up the operation
pointer for the next level.

This conceptually allows for an array of mixed device drivers with
varying flush implementations.

Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c           |   11 +++++++++++
 drivers/md/dm-linear.c        |   15 +++++++++++++++
 drivers/md/dm-stripe.c        |   20 ++++++++++++++++++++
 drivers/md/dm.c               |   19 +++++++++++++++++++
 include/linux/dax.h           |    2 ++
 include/linux/device-mapper.h |    3 +++
 6 files changed, 70 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 73f0da8e5d27..1253c05a2e53 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -117,6 +117,17 @@ size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 }
 EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 
+void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t size)
+{
+	if (!dax_alive(dax_dev))
+		return;
+
+	if (dax_dev->ops->flush)
+		dax_dev->ops->flush(dax_dev, pgoff, addr, size);
+}
+EXPORT_SYMBOL_GPL(dax_flush);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 5fe44a0ddfab..70d8439a1b63 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -172,6 +172,20 @@ static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
+static void linear_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
+		size_t size)
+{
+	struct linear_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = linear_map_sector(ti, sector);
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(size, PAGE_SIZE), &pgoff))
+		return;
+	dax_flush(dax_dev, pgoff, addr, size);
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 3, 0},
@@ -184,6 +198,7 @@ static struct target_type linear_target = {
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_dax_direct_access,
 	.dax_copy_from_iter = linear_dax_copy_from_iter,
+	.dax_flush = linear_dax_flush,
 };
 
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 4f45d23249b2..829fd438318d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -349,6 +349,25 @@ static size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
+static void stripe_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
+		size_t size)
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
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(size, PAGE_SIZE), &pgoff))
+		return;
+	dax_flush(dax_dev, pgoff, addr, size);
+}
+
 /*
  * Stripe status:
  *
@@ -468,6 +487,7 @@ static struct target_type stripe_target = {
 	.io_hints = stripe_io_hints,
 	.direct_access = stripe_dax_direct_access,
 	.dax_copy_from_iter = stripe_dax_copy_from_iter,
+	.dax_flush = stripe_dax_flush,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8c8579efcba2..6a97711cdbdf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -982,6 +982,24 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
+static void dm_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t size)
+{
+	struct mapped_device *md = dax_get_private(dax_dev);
+	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dm_target *ti;
+	int srcu_idx;
+
+	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
+
+	if (!ti)
+		goto out;
+	if (ti->type->dax_flush)
+		ti->type->dax_flush(ti, pgoff, addr, size);
+ out:
+	dm_put_live_table(md, srcu_idx);
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -2844,6 +2862,7 @@ static const struct block_device_operations dm_blk_dops = {
 static const struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
 	.copy_from_iter = dm_dax_copy_from_iter,
+	.flush = dm_dax_flush,
 };
 
 /*
diff --git a/include/linux/dax.h b/include/linux/dax.h
index c88bbcba26d9..2a4f533ef5e7 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -36,6 +36,8 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
+void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t size);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e18e4277d09d..3c5eab2d2a75 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -132,6 +132,8 @@ typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
 typedef size_t (*dm_dax_copy_from_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
+typedef void (*dm_dax_flush_fn)(struct dm_target *ti, pgoff_t pgoff, void *addr,
+		size_t size);
 #define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
@@ -182,6 +184,7 @@ struct target_type {
 	dm_io_hints_fn io_hints;
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_copy_from_iter_fn dax_copy_from_iter;
+	dm_dax_flush_fn dax_flush;
 
 	/* For internal device-mapper use. */
 	struct list_head list;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
