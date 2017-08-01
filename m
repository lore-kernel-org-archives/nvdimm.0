Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D84302095DB8E
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 11:16:29 -0700 (PDT)
Subject: [PATCH] dm: enable opt-out of device-mapper dax support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 Aug 2017 11:12:14 -0700
Message-ID: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: snitzer@redhat.com
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Now that dax is no longer a default property of a block-device, i.e.
->direct_access() is not a block-device operation, we optionally enable
device-mapper dax support with a new CONFIG_DM_DAX option.

All the dax operations helpers are moved to a new file,
drivers/md/dm-dax.c, that is optionally compiled when CONFIG_DM_DAX=y.
Otherwise, we stub out all the operations with NULL function pointers
and nop wrappers for the core dax routines.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig     |   14 +++
 drivers/md/Makefile    |    1 
 drivers/md/dm-dax.c    |  227 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-dax.h    |   73 +++++++++++++++
 drivers/md/dm-linear.c |   56 ------------
 drivers/md/dm-snap.c   |    9 --
 drivers/md/dm-stripe.c |   89 -------------------
 drivers/md/dm-target.c |    7 -
 drivers/md/dm.c        |  105 ++--------------------
 drivers/md/dm.h        |   34 +++++++
 10 files changed, 363 insertions(+), 252 deletions(-)
 create mode 100644 drivers/md/dm-dax.c
 create mode 100644 drivers/md/dm-dax.h

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 4a249ee86364..bf27b435f7cd 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -200,7 +200,6 @@ config BLK_DEV_DM_BUILTIN
 config BLK_DEV_DM
 	tristate "Device mapper support"
 	select BLK_DEV_DM_BUILTIN
-	select DAX
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
@@ -214,6 +213,19 @@ config BLK_DEV_DM
 
 	  If unsure, say N.
 
+config DM_DAX
+	bool "Direct access (DAX) support"
+	depends on BLK_DEV_DM
+	default BLK_DEV_PMEM
+	select DAX
+	---help---
+	  Enable DAX support for the device-mapper linear and stripe
+	  targets for use with DAX capable block devices like /dev/pmemN.
+	  If you have a DAX capable block device and have enabled
+	  filesystem DAX support (CONFIG_FS_DAX), then say Y.
+
+	  If unsure, say N.
+
 config DM_MQ_DEFAULT
 	bool "request-based DM: use blk-mq I/O path by default"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 786ec9e86d65..4a2fd958a3d9 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -5,6 +5,7 @@
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o \
 		   dm-rq.o
+dm-mod-$(CONFIG_DM_DAX) += dm-dax.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
diff --git a/drivers/md/dm-dax.c b/drivers/md/dm-dax.c
new file mode 100644
index 000000000000..d48386fe2578
--- /dev/null
+++ b/drivers/md/dm-dax.c
@@ -0,0 +1,227 @@
+/*
+ * Copyright(c) 2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/device-mapper.h>
+#include <linux/dax.h>
+#include <linux/uio.h>
+
+#include "dm.h"
+
+extern sector_t linear_map_sector(struct dm_target *ti, sector_t bi_sector);
+extern sector_t max_io_len(sector_t sector, struct dm_target *ti);
+
+long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	long ret;
+	struct linear_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = linear_map_sector(ti, sector);
+	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
+	if (ret)
+		return ret;
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+}
+
+size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
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
+void linear_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
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
+long origin_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+#define DM_MSG_PREFIX "snapshots"
+	DMWARN("device does not support dax.");
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(origin_dax_direct_access);
+
+extern void stripe_map_sector(struct stripe_c *sc, sector_t sector,
+			      uint32_t *stripe, sector_t *result);
+long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+	struct stripe_c *sc = ti->private;
+	struct dax_device *dax_dev;
+	struct block_device *bdev;
+	uint32_t stripe;
+	long ret;
+
+	stripe_map_sector(sc, sector, &stripe, &dev_sector);
+	dev_sector += sc->stripe[stripe].physical_start;
+	dax_dev = sc->stripe[stripe].dev->dax_dev;
+	bdev = sc->stripe[stripe].dev->bdev;
+
+	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
+	if (ret)
+		return ret;
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+}
+
+size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
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
+void stripe_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
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
+long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	return -EIO;
+}
+
+static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
+		sector_t sector, int *srcu_idx)
+{
+	struct dm_table *map;
+	struct dm_target *ti;
+
+	map = dm_get_live_table(md, srcu_idx);
+	if (!map)
+		return NULL;
+
+	ti = dm_table_find_target(map, sector);
+	if (!dm_target_is_valid(ti))
+		return NULL;
+
+	return ti;
+}
+
+long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	struct mapped_device *md = dax_get_private(dax_dev);
+	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dm_target *ti;
+	long len, ret = -EIO;
+	int srcu_idx;
+
+	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
+
+	if (!ti)
+		goto out;
+	if (!ti->type->direct_access)
+		goto out;
+	len = max_io_len(sector, ti) / PAGE_SECTORS;
+	if (len < 1)
+		goto out;
+	nr_pages = min(len, nr_pages);
+	if (ti->type->direct_access)
+		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
+
+ out:
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
+size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
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
+void dm_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
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
diff --git a/drivers/md/dm-dax.h b/drivers/md/dm-dax.h
new file mode 100644
index 000000000000..02cd4589d05a
--- /dev/null
+++ b/drivers/md/dm-dax.h
@@ -0,0 +1,73 @@
+#ifndef __DM_DAX_H__
+#define __DM_DAX_H__
+#include <linux/dax.h>
+#if IS_ENABLED(CONFIG_DM_DAX)
+/* dax helpers to allow compiling out dax support */
+long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
+size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i);
+void linear_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
+		size_t size);
+long origin_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
+long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
+size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i);
+void stripe_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
+		size_t size);
+long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
+static inline struct dax_device *dm_dax_get_by_host(const char *host)
+{
+	return dax_get_by_host(host);
+}
+static inline void dm_put_dax(struct dax_device *dax_dev)
+{
+	put_dax(dax_dev);
+}
+static inline struct dax_device *dm_alloc_dax(void *p, const char *host,
+		const struct dax_operations *ops)
+{
+	return alloc_dax(p, host, ops);
+}
+static inline void dm_kill_dax(struct dax_device *dax_dev)
+{
+	kill_dax(dax_dev);
+}
+long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
+size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i);
+void dm_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t size);
+#else
+#define linear_dax_direct_access NULL
+#define linear_dax_copy_from_iter NULL
+#define linear_dax_flush NULL
+#define origin_dax_direct_access NULL
+#define stripe_dax_direct_access NULL
+#define stripe_dax_copy_from_iter NULL
+#define stripe_dax_flush NULL
+#define io_err_dax_direct_access NULL
+static inline struct dax_device *dm_dax_get_by_host(const char *host)
+{
+	return NULL;
+}
+static inline void dm_put_dax(struct dax_device *dax_dev)
+{
+}
+static inline struct dax_device *dm_alloc_dax(void *private, const char *__host,
+		const struct dax_operations *ops)
+{
+	return NULL;
+}
+static inline void dm_kill_dax(struct dax_device *dax_dev)
+{
+}
+#define dm_dax_direct_access NULL
+#define dm_dax_copy_from_iter NULL
+#define dm_dax_flush NULL
+#endif
+#endif /* __DM_DAX_H__ */
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 41971a090e34..184ae6e76ac4 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -5,25 +5,17 @@
  */
 
 #include "dm.h"
+#include "dm-dax.h"
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
-#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "linear"
 
 /*
- * Linear: maps a linear range of a device.
- */
-struct linear_c {
-	struct dm_dev *dev;
-	sector_t start;
-};
-
-/*
  * Construct a linear mapping: <dev_path> <offset>
  */
 static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
@@ -77,7 +69,7 @@ static void linear_dtr(struct dm_target *ti)
 	kfree(lc);
 }
 
-static sector_t linear_map_sector(struct dm_target *ti, sector_t bi_sector)
+sector_t linear_map_sector(struct dm_target *ti, sector_t bi_sector)
 {
 	struct linear_c *lc = ti->private;
 
@@ -154,50 +146,6 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
-static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
-{
-	long ret;
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-
-	dev_sector = linear_map_sector(ti, sector);
-	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
-	if (ret)
-		return ret;
-	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
-}
-
-static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-
-	dev_sector = linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
-	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
-static void linear_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
-		size_t size)
-{
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-
-	dev_sector = linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(size, PAGE_SIZE), &pgoff))
-		return;
-	dax_flush(dax_dev, pgoff, addr, size);
-}
-
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 4, 0},
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1ba41048b438..fa31d9f5642d 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -21,7 +21,7 @@
 #include <linux/dm-kcopyd.h>
 
 #include "dm.h"
-
+#include "dm-dax.h"
 #include "dm-exception-store.h"
 
 #define DM_MSG_PREFIX "snapshots"
@@ -2303,13 +2303,6 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 	return do_origin(o->dev, bio);
 }
 
-static long origin_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
-{
-	DMWARN("device does not support dax.");
-	return -EIO;
-}
-
 /*
  * Set the target "max_io_len" field to the minimum of all the snapshots'
  * chunk sizes.
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a0375530b07f..a4720abac523 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -5,45 +5,19 @@
  */
 
 #include "dm.h"
+#include "dm-dax.h"
 #include <linux/device-mapper.h>
 
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
-#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
 
 #define DM_MSG_PREFIX "striped"
 #define DM_IO_ERROR_THRESHOLD 15
 
-struct stripe {
-	struct dm_dev *dev;
-	sector_t physical_start;
-
-	atomic_t error_count;
-};
-
-struct stripe_c {
-	uint32_t stripes;
-	int stripes_shift;
-
-	/* The size of this target / num. stripes */
-	sector_t stripe_width;
-
-	uint32_t chunk_size;
-	int chunk_size_shift;
-
-	/* Needed for handling events */
-	struct dm_target *ti;
-
-	/* Work struct used for triggering events*/
-	struct work_struct trigger_event;
-
-	struct stripe stripe[0];
-};
-
 /*
  * An event is triggered whenever a drive
  * drops out of a stripe volume.
@@ -212,7 +186,7 @@ static void stripe_dtr(struct dm_target *ti)
 	kfree(sc);
 }
 
-static void stripe_map_sector(struct stripe_c *sc, sector_t sector,
+void stripe_map_sector(struct stripe_c *sc, sector_t sector,
 			      uint32_t *stripe, sector_t *result)
 {
 	sector_t chunk = dm_target_offset(sc->ti, sector);
@@ -311,65 +285,6 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
-{
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-	struct stripe_c *sc = ti->private;
-	struct dax_device *dax_dev;
-	struct block_device *bdev;
-	uint32_t stripe;
-	long ret;
-
-	stripe_map_sector(sc, sector, &stripe, &dev_sector);
-	dev_sector += sc->stripe[stripe].physical_start;
-	dax_dev = sc->stripe[stripe].dev->dax_dev;
-	bdev = sc->stripe[stripe].dev->bdev;
-
-	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
-	if (ret)
-		return ret;
-	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
-}
-
-static size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-	struct stripe_c *sc = ti->private;
-	struct dax_device *dax_dev;
-	struct block_device *bdev;
-	uint32_t stripe;
-
-	stripe_map_sector(sc, sector, &stripe, &dev_sector);
-	dev_sector += sc->stripe[stripe].physical_start;
-	dax_dev = sc->stripe[stripe].dev->dax_dev;
-	bdev = sc->stripe[stripe].dev->bdev;
-
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
-	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
-static void stripe_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
-		size_t size)
-{
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-	struct stripe_c *sc = ti->private;
-	struct dax_device *dax_dev;
-	struct block_device *bdev;
-	uint32_t stripe;
-
-	stripe_map_sector(sc, sector, &stripe, &dev_sector);
-	dev_sector += sc->stripe[stripe].physical_start;
-	dax_dev = sc->stripe[stripe].dev->dax_dev;
-	bdev = sc->stripe[stripe].dev->bdev;
-
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(size, PAGE_SIZE), &pgoff))
-		return;
-	dax_flush(dax_dev, pgoff, addr, size);
-}
-
 /*
  * Stripe status:
  *
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index c0d7e60820c4..3d4130e2e1e9 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -5,6 +5,7 @@
  */
 
 #include "dm-core.h"
+#include "dm-dax.h"
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -142,12 +143,6 @@ static void io_err_release_clone_rq(struct request *clone)
 {
 }
 
-static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
-{
-	return -EIO;
-}
-
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 5, 0},
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2edbcc2d7d3f..73aca9ce5581 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -8,6 +8,7 @@
 #include "dm-core.h"
 #include "dm-rq.h"
 #include "dm-uevent.h"
+#include "dm-dax.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -16,7 +17,6 @@
 #include <linux/blkpg.h>
 #include <linux/bio.h>
 #include <linux/mempool.h>
-#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/uio.h>
@@ -634,7 +634,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
 	}
 
 	td->dm_dev.bdev = bdev;
-	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	td->dm_dev.dax_dev = dm_dax_get_by_host(bdev->bd_disk->disk_name);
 	return 0;
 }
 
@@ -648,7 +648,7 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
-	put_dax(td->dm_dev.dax_dev);
+	dm_put_dax(td->dm_dev.dax_dev);
 	td->dm_dev.bdev = NULL;
 	td->dm_dev.dax_dev = NULL;
 }
@@ -890,7 +890,7 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
 	return ti->len - target_offset;
 }
 
-static sector_t max_io_len(sector_t sector, struct dm_target *ti)
+sector_t max_io_len(sector_t sector, struct dm_target *ti)
 {
 	sector_t len = max_io_len_target_boundary(sector, ti);
 	sector_t offset, max_len;
@@ -928,93 +928,6 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
-static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
-		sector_t sector, int *srcu_idx)
-{
-	struct dm_table *map;
-	struct dm_target *ti;
-
-	map = dm_get_live_table(md, srcu_idx);
-	if (!map)
-		return NULL;
-
-	ti = dm_table_find_target(map, sector);
-	if (!dm_target_is_valid(ti))
-		return NULL;
-
-	return ti;
-}
-
-static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
-{
-	struct mapped_device *md = dax_get_private(dax_dev);
-	sector_t sector = pgoff * PAGE_SECTORS;
-	struct dm_target *ti;
-	long len, ret = -EIO;
-	int srcu_idx;
-
-	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
-
-	if (!ti)
-		goto out;
-	if (!ti->type->direct_access)
-		goto out;
-	len = max_io_len(sector, ti) / PAGE_SECTORS;
-	if (len < 1)
-		goto out;
-	nr_pages = min(len, nr_pages);
-	if (ti->type->direct_access)
-		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
-
- out:
-	dm_put_live_table(md, srcu_idx);
-
-	return ret;
-}
-
-static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct mapped_device *md = dax_get_private(dax_dev);
-	sector_t sector = pgoff * PAGE_SECTORS;
-	struct dm_target *ti;
-	long ret = 0;
-	int srcu_idx;
-
-	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
-
-	if (!ti)
-		goto out;
-	if (!ti->type->dax_copy_from_iter) {
-		ret = copy_from_iter(addr, bytes, i);
-		goto out;
-	}
-	ret = ti->type->dax_copy_from_iter(ti, pgoff, addr, bytes, i);
- out:
-	dm_put_live_table(md, srcu_idx);
-
-	return ret;
-}
-
-static void dm_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
-		size_t size)
-{
-	struct mapped_device *md = dax_get_private(dax_dev);
-	sector_t sector = pgoff * PAGE_SECTORS;
-	struct dm_target *ti;
-	int srcu_idx;
-
-	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
-
-	if (!ti)
-		goto out;
-	if (ti->type->dax_flush)
-		ti->type->dax_flush(ti, pgoff, addr, size);
- out:
-	dm_put_live_table(md, srcu_idx);
-}
-
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -1681,8 +1594,8 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		bioset_free(md->bs);
 
 	if (md->dax_dev) {
-		kill_dax(md->dax_dev);
-		put_dax(md->dax_dev);
+		dm_kill_dax(md->dax_dev);
+		dm_put_dax(md->dax_dev);
 		md->dax_dev = NULL;
 	}
 
@@ -1779,8 +1692,8 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-	dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
-	if (!dax_dev)
+	dax_dev = dm_alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
+	if (!dax_dev && IS_ENABLED(CONFIG_DM_DAX))
 		goto bad;
 	md->dax_dev = dax_dev;
 
@@ -2999,7 +2912,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.owner = THIS_MODULE
 };
 
-static const struct dax_operations dm_dax_ops = {
+static const __maybe_unused struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
 	.copy_from_iter = dm_dax_copy_from_iter,
 	.flush = dm_dax_flush,
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 38c84c0a35d4..2c9d94ec2391 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -174,6 +174,40 @@ int dm_stripe_init(void);
 void dm_stripe_exit(void);
 
 /*
+ * Linear: maps a linear range of a device.
+ */
+struct linear_c {
+	struct dm_dev *dev;
+	sector_t start;
+};
+
+struct stripe {
+	struct dm_dev *dev;
+	sector_t physical_start;
+
+	atomic_t error_count;
+};
+
+struct stripe_c {
+	uint32_t stripes;
+	int stripes_shift;
+
+	/* The size of this target / num. stripes */
+	sector_t stripe_width;
+
+	uint32_t chunk_size;
+	int chunk_size_shift;
+
+	/* Needed for handling events */
+	struct dm_target *ti;
+
+	/* Work struct used for triggering events*/
+	struct work_struct trigger_event;
+
+	struct stripe stripe[0];
+};
+
+/*
  * mapped_device operations
  */
 void dm_destroy(struct mapped_device *md);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
