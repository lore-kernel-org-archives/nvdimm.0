Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17A2321E43B58
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 09:28:28 -0700 (PDT)
Subject: [PATCH v5 2/2] dm: allow device-mapper to operate without dax support
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Sep 2017 09:25:11 -0700
Message-ID: <150609751116.25862.15738804417151935191.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150609750020.25862.11458070207401120153.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150609750020.25862.11458070207401120153.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Change device-mapper's 'select DAX' dependency to be dependent on the
presence of at least one DAX_DRIVER. This allows device-mapper to be
built without bringing the DAX core along which is especially wasteful
when there are no DAX drivers, like BLK_DEV_PMEM, configured.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig     |    2 +-
 drivers/md/dm-linear.c |    6 ++++++
 drivers/md/dm-stripe.c |    6 ++++++
 drivers/md/dm.c        |   10 ++++++----
 include/linux/dax.h    |   30 ++++++++++++++++++++++++------
 5 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 4a249ee86364..baeea31dc858 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -200,7 +200,7 @@ config BLK_DEV_DM_BUILTIN
 config BLK_DEV_DM
 	tristate "Device mapper support"
 	select BLK_DEV_DM_BUILTIN
-	select DAX
+	select DAX if DAX_DRIVER
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d5f8eff7c11d..df4b6f0489aa 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -154,6 +154,7 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+#if IS_ENABLED(CONFIG_DAX)
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
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index b5e892149c54..8cb98ee2c9db 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -311,6 +311,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
+#if IS_ENABLED(CONFIG_DAX)
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
index 6e54145969c5..e364c584a676 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1685,7 +1685,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
 static struct mapped_device *alloc_dev(int minor)
 {
 	int r, numa_node_id = dm_get_numa_node();
-	struct dax_device *dax_dev;
+	struct dax_device *dax_dev = NULL;
 	struct mapped_device *md;
 	void *old_md;
 
@@ -1751,9 +1751,11 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-	dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
-	if (!dax_dev)
-		goto bad;
+	if (IS_ENABLED(CONFIG_DAX)) {
+		dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
+		if (!dax_dev)
+			goto bad;
+	}
 	md->dax_dev = dax_dev;
 
 	add_disk(md->disk);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 122197124b9d..898403da0458 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -25,16 +25,39 @@ extern struct attribute_group dax_attribute_group;
 
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
 
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
@@ -79,18 +102,13 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 
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
