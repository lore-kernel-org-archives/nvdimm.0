Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 110ED2095BB80
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:45:07 -0700 (PDT)
Date: Thu, 31 Aug 2017 21:47:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dax: remove the pmem_dax_ops->flush abstraction
Message-ID: <alpine.LRH.2.02.1708312138390.32309@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The patch abebfbe2f731 ("dm: add ->flush() dax operation support") is 
buggy. A dm device may be composed of multiple underlying devices and all 
of them need to be flushed. The patch just routes the flush request to the 
first device and ignores the other devices.

It could be fixed by adding more complex logic to the device mapper. But 
there is only one implementation of the method pmem_dax_ops->flush - that 
is pmem_dax_flush() - and it calls arch_wb_cache_pmem(). Consequently, we 
don't need the pmem_dax_ops->flush abstraction at all, we can call 
arch_wb_cache_pmem() directly from dax_flush() because dax_dev->ops->flush 
couldn't ever reach anything different from arch_wb_cache_pmem().

It should be also pointed out that for some uses of persistent memory it 
is needed to flush only very small amount of data (such as 1 cacheline), 
and it would be overkill if we go through that device mapper machinery for 
a single flushed cache line.

This patch removes the abstraction pmem_dax_ops->flush and calls 
arch_wb_cache_pmem() directly from dax_flush(). It also removes device 
mapper code that forwards the flushes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/dax/super.c           |   21 ++++++++++++++-------
 drivers/md/dm-linear.c        |   15 ---------------
 drivers/md/dm-stripe.c        |   20 --------------------
 drivers/md/dm.c               |   19 -------------------
 drivers/nvdimm/pmem.c         |    7 -------
 fs/dax.c                      |    4 ++--
 include/linux/dax.h           |    5 +----
 include/linux/device-mapper.h |    3 ---
 8 files changed, 17 insertions(+), 77 deletions(-)

Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c
+++ linux-2.6/drivers/md/dm-linear.c
@@ -184,20 +184,6 @@ static size_t linear_dax_copy_from_iter(
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
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
@@ -212,7 +198,6 @@ static struct target_type linear_target
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_dax_direct_access,
 	.dax_copy_from_iter = linear_dax_copy_from_iter,
-	.dax_flush = linear_dax_flush,
 };
 
 int __init dm_linear_init(void)
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c
+++ linux-2.6/drivers/md/dm-stripe.c
@@ -351,25 +351,6 @@ static size_t stripe_dax_copy_from_iter(
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
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
@@ -491,7 +472,6 @@ static struct target_type stripe_target
 	.io_hints = stripe_io_hints,
 	.direct_access = stripe_dax_direct_access,
 	.dax_copy_from_iter = stripe_dax_copy_from_iter,
-	.dax_flush = stripe_dax_flush,
 };
 
 int __init dm_stripe_init(void)
Index: linux-2.6/drivers/nvdimm/pmem.c
===================================================================
--- linux-2.6.orig/drivers/nvdimm/pmem.c
+++ linux-2.6/drivers/nvdimm/pmem.c
@@ -243,16 +243,9 @@ static size_t pmem_copy_from_iter(struct
 	return copy_from_iter_flushcache(addr, bytes, i);
 }
 
-static void pmem_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff,
-		void *addr, size_t size)
-{
-	arch_wb_cache_pmem(addr, size);
-}
-
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_dax_direct_access,
 	.copy_from_iter = pmem_copy_from_iter,
-	.flush = pmem_dax_flush,
 };
 
 static const struct attribute_group *pmem_attribute_groups[] = {
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -134,8 +134,6 @@ typedef long (*dm_dax_direct_access_fn)
 		long nr_pages, void **kaddr, pfn_t *pfn);
 typedef size_t (*dm_dax_copy_from_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
-typedef void (*dm_dax_flush_fn)(struct dm_target *ti, pgoff_t pgoff, void *addr,
-		size_t size);
 #define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
@@ -186,7 +184,6 @@ struct target_type {
 	dm_io_hints_fn io_hints;
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_copy_from_iter_fn dax_copy_from_iter;
-	dm_dax_flush_fn dax_flush;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -997,24 +997,6 @@ static size_t dm_dax_copy_from_iter(stru
 	return ret;
 }
 
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
@@ -3002,7 +2984,6 @@ static const struct block_device_operati
 static const struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
 	.copy_from_iter = dm_dax_copy_from_iter,
-	.flush = dm_dax_flush,
 };
 
 /*
Index: linux-2.6/fs/dax.c
===================================================================
--- linux-2.6.orig/fs/dax.c
+++ linux-2.6/fs/dax.c
@@ -783,7 +783,7 @@ static int dax_writeback_one(struct bloc
 	}
 
 	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
-	dax_flush(dax_dev, pgoff, kaddr, size);
+	dax_flush(dax_dev, kaddr, size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
 	 * cannot be new dirty data in the pfn after the flush has completed as
@@ -978,7 +978,7 @@ int __dax_zero_page_range(struct block_d
 			return rc;
 		}
 		memset(kaddr + offset, 0, size);
-		dax_flush(dax_dev, pgoff, kaddr + offset, size);
+		dax_flush(dax_dev, kaddr + offset, size);
 		dax_read_unlock(id);
 	}
 	return 0;
Index: linux-2.6/drivers/dax/super.c
===================================================================
--- linux-2.6.orig/drivers/dax/super.c
+++ linux-2.6/drivers/dax/super.c
@@ -189,8 +189,10 @@ static umode_t dax_visible(struct kobjec
 	if (!dax_dev)
 		return 0;
 
-	if (a == &dev_attr_write_cache.attr && !dax_dev->ops->flush)
+#ifndef CONFIG_ARCH_HAS_PMEM_API
+	if (a == &dev_attr_write_cache.attr)
 		return 0;
+#endif
 	return a->mode;
 }
 
@@ -255,18 +257,23 @@ size_t dax_copy_from_iter(struct dax_dev
 }
 EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 
-void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
-		size_t size)
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+void arch_wb_cache_pmem(void *addr, size_t size);
+void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
 {
-	if (!dax_alive(dax_dev))
+	if (unlikely(!dax_alive(dax_dev)))
 		return;
 
-	if (!test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags))
+	if (unlikely(!test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags)))
 		return;
 
-	if (dax_dev->ops->flush)
-		dax_dev->ops->flush(dax_dev, pgoff, addr, size);
+	arch_wb_cache_pmem(addr, size);
+}
+#else
+void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
+{
 }
+#endif
 EXPORT_SYMBOL_GPL(dax_flush);
 
 void dax_write_cache(struct dax_device *dax_dev, bool wc)
Index: linux-2.6/include/linux/dax.h
===================================================================
--- linux-2.6.orig/include/linux/dax.h
+++ linux-2.6/include/linux/dax.h
@@ -19,8 +19,6 @@ struct dax_operations {
 	/* copy_from_iter: required operation for fs-dax direct-i/o */
 	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
 			struct iov_iter *);
-	/* flush: optional driver-specific cache management after writes */
-	void (*flush)(struct dax_device *, pgoff_t, void *, size_t);
 };
 
 extern struct attribute_group dax_attribute_group;
@@ -84,8 +82,7 @@ long dax_direct_access(struct dax_device
 		void **kaddr, pfn_t *pfn);
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
-void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
-		size_t size);
+void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
