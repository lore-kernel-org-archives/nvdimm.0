Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0942A209589FF
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 15:51:56 -0700 (PDT)
Subject: [PATCH v2] dm: allow device-mapper to operate without dax support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 Aug 2017 15:47:41 -0700
Message-ID: <150162766102.27319.10043964535977848237.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Rather than 'select dax', let the fact that BLK_DEV_PMEM selects dax act
as a gate for the device-mapper dax support. Given that all the dax core
routines compile to nops when CONFIG_DAX=n, we can simply handle the
alloc_dax() error as expected and ifdef out the other dax support code.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig     |    1 -
 drivers/md/dm-linear.c |    6 ++++++
 drivers/md/dm-stripe.c |    6 ++++++
 drivers/md/dm.c        |   10 ++++++----
 include/linux/dax.h    |   19 +++++++++++++++----
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 4a249ee86364..8ed48ff351cc 100644
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
index 794811875732..5d51c5ef678b 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -27,16 +27,30 @@ extern struct attribute_group dax_attribute_group;
 
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *dax_get_by_host(const char *host);
+struct dax_device *alloc_dax(void *private, const char *host,
+		const struct dax_operations *ops);
 void put_dax(struct dax_device *dax_dev);
+void kill_dax(struct dax_device *dax_dev);
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
 #endif
 
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
@@ -75,10 +89,7 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 
 int dax_read_lock(void);
 void dax_read_unlock(int id);
-struct dax_device *alloc_dax(void *private, const char *host,
-		const struct dax_operations *ops);
 bool dax_alive(struct dax_device *dax_dev);
-void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
