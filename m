Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 451FF21E0818A
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 21:12:54 -0700 (PDT)
Subject: [PATCH v8 09/18] dax,
 dm: allow device-mapper to operate without dax support
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:02:58 -0700
Message-ID: <152246897808.36038.9873046364733003385.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, kbuild test robot <lkp@intel.com>, snitzer@redhat.com, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, hch@lst.de, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Change device-mapper's DAX dependency to require the presence of at
least one DAX_DRIVER. This allows device-mapper to be built without
bringing the DAX core along which is especially wasteful when there are
no DAX drivers, like BLK_DEV_PMEM, configured.

Cc: Alasdair Kergon <agk@redhat.com>
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Reported-by: kbuild test robot <lkp@intel.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig         |    1 
 drivers/md/dm-linear.c     |    6 +++
 drivers/md/dm-log-writes.c |   95 +++++++++++++++++++++++---------------------
 drivers/md/dm-stripe.c     |    6 +++
 drivers/md/dm.c            |   10 +++--
 include/linux/dax.h        |   30 +++++++++++---
 6 files changed, 92 insertions(+), 56 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2c8ac3688815..6dfc328b8f99 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -201,7 +201,6 @@ config BLK_DEV_DM_BUILTIN
 config BLK_DEV_DM
 	tristate "Device mapper support"
 	select BLK_DEV_DM_BUILTIN
-	select DAX
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d5f8eff7c11d..89443e0ededa 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -154,6 +154,7 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+#if IS_ENABLED(CONFIG_DAX_DRIVER)
 static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
@@ -184,6 +185,11 @@ static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
+#else
+#define linear_dax_direct_access NULL
+#define linear_dax_copy_from_iter NULL
+#endif
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 4, 0},
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 3362d866793b..7fcb4216973f 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -610,51 +610,6 @@ static int log_mark(struct log_writes_c *lc, char *data)
 	return 0;
 }
 
-static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
-		   struct iov_iter *i)
-{
-	struct pending_block *block;
-
-	if (!bytes)
-		return 0;
-
-	block = kzalloc(sizeof(struct pending_block), GFP_KERNEL);
-	if (!block) {
-		DMERR("Error allocating dax pending block");
-		return -ENOMEM;
-	}
-
-	block->data = kzalloc(bytes, GFP_KERNEL);
-	if (!block->data) {
-		DMERR("Error allocating dax data space");
-		kfree(block);
-		return -ENOMEM;
-	}
-
-	/* write data provided via the iterator */
-	if (!copy_from_iter(block->data, bytes, i)) {
-		DMERR("Error copying dax data");
-		kfree(block->data);
-		kfree(block);
-		return -EIO;
-	}
-
-	/* rewind the iterator so that the block driver can use it */
-	iov_iter_revert(i, bytes);
-
-	block->datalen = bytes;
-	block->sector = bio_to_dev_sectors(lc, sector);
-	block->nr_sectors = ALIGN(bytes, lc->sectorsize) >> lc->sectorshift;
-
-	atomic_inc(&lc->pending_blocks);
-	spin_lock_irq(&lc->blocks_lock);
-	list_add_tail(&block->list, &lc->unflushed_blocks);
-	spin_unlock_irq(&lc->blocks_lock);
-	wake_up_process(lc->log_kthread);
-
-	return 0;
-}
-
 static void log_writes_dtr(struct dm_target *ti)
 {
 	struct log_writes_c *lc = ti->private;
@@ -920,6 +875,52 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	limits->io_min = limits->physical_block_size;
 }
 
+#if IS_ENABLED(CONFIG_DAX_DRIVER)
+static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
+		   struct iov_iter *i)
+{
+	struct pending_block *block;
+
+	if (!bytes)
+		return 0;
+
+	block = kzalloc(sizeof(struct pending_block), GFP_KERNEL);
+	if (!block) {
+		DMERR("Error allocating dax pending block");
+		return -ENOMEM;
+	}
+
+	block->data = kzalloc(bytes, GFP_KERNEL);
+	if (!block->data) {
+		DMERR("Error allocating dax data space");
+		kfree(block);
+		return -ENOMEM;
+	}
+
+	/* write data provided via the iterator */
+	if (!copy_from_iter(block->data, bytes, i)) {
+		DMERR("Error copying dax data");
+		kfree(block->data);
+		kfree(block);
+		return -EIO;
+	}
+
+	/* rewind the iterator so that the block driver can use it */
+	iov_iter_revert(i, bytes);
+
+	block->datalen = bytes;
+	block->sector = bio_to_dev_sectors(lc, sector);
+	block->nr_sectors = ALIGN(bytes, lc->sectorsize) >> lc->sectorshift;
+
+	atomic_inc(&lc->pending_blocks);
+	spin_lock_irq(&lc->blocks_lock);
+	list_add_tail(&block->list, &lc->unflushed_blocks);
+	spin_unlock_irq(&lc->blocks_lock);
+	wake_up_process(lc->log_kthread);
+
+	return 0;
+}
+
 static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 					 long nr_pages, void **kaddr, pfn_t *pfn)
 {
@@ -956,6 +957,10 @@ static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
 dax_copy:
 	return dax_copy_from_iter(lc->dev->dax_dev, pgoff, addr, bytes, i);
 }
+#else
+#define log_writes_dax_direct_access NULL
+#define log_writes_dax_copy_from_iter NULL
+#endif
 
 static struct target_type log_writes_target = {
 	.name   = "log-writes",
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index b5e892149c54..ac2e8ee9d586 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -311,6 +311,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
+#if IS_ENABLED(CONFIG_DAX_DRIVER)
 static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
@@ -351,6 +352,11 @@ static size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
+#else
+#define stripe_dax_direct_access NULL
+#define stripe_dax_copy_from_iter NULL
+#endif
+
 /*
  * Stripe status:
  *
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 68136806d365..ffc93aecc02a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1800,7 +1800,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
 static struct mapped_device *alloc_dev(int minor)
 {
 	int r, numa_node_id = dm_get_numa_node();
-	struct dax_device *dax_dev;
+	struct dax_device *dax_dev = NULL;
 	struct mapped_device *md;
 	void *old_md;
 
@@ -1866,9 +1866,11 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-	dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
-	if (!dax_dev)
-		goto bad;
+	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
+		dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
+		if (!dax_dev)
+			goto bad;
+	}
 	md->dax_dev = dax_dev;
 
 	add_disk_no_queue_reg(md->disk);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index ae27a7efe7ab..f9eb22ad341e 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -26,16 +26,39 @@ extern struct attribute_group dax_attribute_group;
 
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *dax_get_by_host(const char *host);
+struct dax_device *alloc_dax(void *private, const char *host,
+		const struct dax_operations *ops);
 void put_dax(struct dax_device *dax_dev);
+void kill_dax(struct dax_device *dax_dev);
+void dax_write_cache(struct dax_device *dax_dev, bool wc);
+bool dax_write_cache_enabled(struct dax_device *dax_dev);
 #else
 static inline struct dax_device *dax_get_by_host(const char *host)
 {
 	return NULL;
 }
-
+static inline struct dax_device *alloc_dax(void *private, const char *host,
+		const struct dax_operations *ops)
+{
+	/*
+	 * Callers should check IS_ENABLED(CONFIG_DAX) to know if this
+	 * NULL is an error or expected.
+	 */
+	return NULL;
+}
 static inline void put_dax(struct dax_device *dax_dev)
 {
 }
+static inline void kill_dax(struct dax_device *dax_dev)
+{
+}
+static inline void dax_write_cache(struct dax_device *dax_dev, bool wc)
+{
+}
+static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
+{
+	return false;
+}
 #endif
 
 struct writeback_control;
@@ -89,18 +112,13 @@ static inline int dax_writeback_mapping_range(struct address_space *mapping,
 
 int dax_read_lock(void);
 void dax_read_unlock(int id);
-struct dax_device *alloc_dax(void *private, const char *host,
-		const struct dax_operations *ops);
 bool dax_alive(struct dax_device *dax_dev);
-void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
-void dax_write_cache(struct dax_device *dax_dev, bool wc);
-bool dax_write_cache_enabled(struct dax_device *dax_dev);
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
