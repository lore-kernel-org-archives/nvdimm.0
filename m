Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0779321E1DAE1
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 11:02:24 -0700 (PDT)
Subject: [PATCH v3 2/2] dm: allow device-mapper to operate without dax support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 02 Aug 2017 10:58:10 -0700
Message-ID: <150169668989.39569.8174620146135008137.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Rather than have device-mapper directly 'select DAX', let the fact that
BLK_DEV_PMEM selects dax act as a gate for the device-mapper dax
support. We arrange for all the dax core routines to compile to nops
when CONFIG_DAX=n. With that in place we can simply handle the
alloc_dax() error as expected and ifdef out the other device-mapper-dax
support code.

Now, if dax is provided by a leaf driver that driver may only arrange to
compile the dax core as a module. Since device-mapper dax support is
consumed by the always-built-in portion of the device-mapper
implementation we need to upgrade from DAX=m to DAX=y.

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
index 4a249ee86364..8ebf09e99006 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -195,12 +195,12 @@ config MD_CLUSTER
 source "drivers/md/bcache/Kconfig"
 
 config BLK_DEV_DM_BUILTIN
+	select DAX if DAX_DRIVER
 	bool
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
 	select BLK_DEV_DM_BUILTIN
-	select DAX
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 41971a090e34..8804e278e834 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -154,6 +154,7 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+#if IS_ENABLED(CONFIG_DAX)
 static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
@@ -197,6 +198,11 @@ static void linear_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
 		return;
 	dax_flush(dax_dev, pgoff, addr, size);
 }
+#else
+#define linear_dax_direct_access NULL
+#define linear_dax_copy_from_iter NULL
+#define linear_dax_flush NULL
+#endif
 
 static struct target_type linear_target = {
 	.name   = "linear",
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a0375530b07f..eeb6c784dc4f 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -311,6 +311,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
+#if IS_ENABLED(CONFIG_DAX)
 static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
@@ -369,6 +370,11 @@ static void stripe_dax_flush(struct dm_target *ti, pgoff_t pgoff, void *addr,
 		return;
 	dax_flush(dax_dev, pgoff, addr, size);
 }
+#else
+#define stripe_dax_direct_access NULL
+#define stripe_dax_copy_from_iter NULL
+#define stripe_dax_flush NULL
+#endif
 
 /*
  * Stripe status:
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2edbcc2d7d3f..70fa48f4d3a3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1713,7 +1713,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
 static struct mapped_device *alloc_dev(int minor)
 {
 	int r, numa_node_id = dm_get_numa_node();
-	struct dax_device *dax_dev;
+	struct dax_device *dax_dev = NULL;
 	struct mapped_device *md;
 	void *old_md;
 
@@ -1779,9 +1779,11 @@ static struct mapped_device *alloc_dev(int minor)
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
index eb0bff6f1eab..59575b8e638e 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -27,16 +27,39 @@ extern struct attribute_group dax_attribute_group;
 
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
@@ -75,10 +98,7 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 
 int dax_read_lock(void);
 void dax_read_unlock(int id);
-struct dax_device *alloc_dax(void *private, const char *host,
-		const struct dax_operations *ops);
 bool dax_alive(struct dax_device *dax_dev);
-void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);
@@ -86,8 +106,6 @@ size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
 void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t size);
-void dax_write_cache(struct dax_device *dax_dev, bool wc);
-bool dax_write_cache_enabled(struct dax_device *dax_dev);
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
