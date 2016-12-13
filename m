Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD25781F8A
 for <linux-nvdimm@lists.01.org>; Mon, 12 Dec 2016 16:15:06 -0800 (PST)
Subject: [PATCH 3/3] dev-dax: add fallocate support to clear poison
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 12 Dec 2016 17:15:03 -0700
Message-ID: <148158810339.159590.9709505860734074382.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
References: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding fallocate support to device-dax. This implements FALLOC_FL_PUNCH_HOLE
in order to allow clearing of badblocks/poison list.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/dax-private.h |    1 +
 drivers/dax/dax.c         |   28 +++++++++++++++++--
 drivers/dax/dax.h         |    4 ++-
 drivers/dax/pmem.c        |   68 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/open.c                 |    2 +
 5 files changed, 97 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 56f80d2..42ab18d 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -38,6 +38,7 @@ struct dax_dev {
 	int num_resources;
 	struct resource **res;
 	void *private;
+	const struct file_operations *fops;
 };
 
 #endif
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 32c9a7f..cc02ea3 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/falloc.h>
 #include "dax.h"
 #include "dax-private.h"
 
@@ -394,6 +395,12 @@ void *dax_dev_get_private(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dax_dev_get_private);
 
+struct device *dax_dev_get_device(struct dax_dev *dax_dev)
+{
+	return &dax_dev->dev;
+}
+EXPORT_SYMBOL_GPL(dax_dev_get_device);
+
 void dax_dev_set_private(struct dax_dev *dax_dev, void *priv)
 {
 	dax_dev->private = priv;
@@ -797,7 +804,7 @@ static ssize_t dax_dev_resize(struct dax_region *dax_region,
 			&& &dax_dev->dev == dax_region->seed) {
 		struct dax_dev *seed;
 
-		seed = devm_create_dax_dev(dax_region, NULL, 0, NULL);
+		seed = devm_create_dax_dev(dax_region, NULL, 0, NULL, NULL);
 		if (IS_ERR(seed))
 			dev_warn(dax_region->dev,
 					"failed to create new region seed\n");
@@ -1114,6 +1121,17 @@ static int dax_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static long dax_fallocate(struct file *file, int mode,
+		loff_t offset, loff_t len)
+{
+	struct dax_dev *dax_dev = file->private_data;
+
+	if (dax_dev->fops)
+		return dax_dev->fops->fallocate(file, mode, offset, len);
+
+	return -EOPNOTSUPP;
+}
+
 static const struct file_operations dax_fops = {
 	.llseek = noop_llseek,
 	.owner = THIS_MODULE,
@@ -1121,6 +1139,7 @@ static const struct file_operations dax_fops = {
 	.release = dax_release,
 	.get_unmapped_area = dax_get_unmapped_area,
 	.mmap = dax_mmap,
+	.fallocate = dax_fallocate,
 };
 
 static void dax_dev_release(struct device *dev)
@@ -1138,7 +1157,8 @@ static void dax_dev_release(struct device *dev)
 
 struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		struct resource *res, int count,
-		const struct attribute_group **groups)
+		const struct attribute_group **groups,
+		const struct file_operations *fops)
 {
 	struct device *parent = dax_region->dev;
 	struct dax_dev *dax_dev;
@@ -1260,10 +1280,12 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	if (rc)
 		return ERR_PTR(rc);
 
+	dax_dev->fops = fops;
+
 	if (atomic_inc_return(&dax_region->child_count) == 1) {
 		struct dax_dev *seed;
 
-		seed = devm_create_dax_dev(dax_region, NULL, 0, NULL);
+		seed = devm_create_dax_dev(dax_region, NULL, 0, NULL, fops);
 		if (IS_ERR(seed))
 			dev_warn(parent, "failed to create region seed\n");
 		else
diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index c23c7ac..6a31a74 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -24,8 +24,10 @@ struct dax_region *alloc_dax_region(struct device *parent,
 		void *addr, unsigned long flags);
 struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		struct resource *res, int count,
-		const struct attribute_group **groups);
+		const struct attribute_group **groups,
+		const struct file_operations *fops);
 void *dax_dev_get_private(struct device *dev);
 void dax_dev_set_private(struct dax_dev *dax_dev, void *priv);
+struct device *dax_dev_get_device(struct dax_dev *dax_dev);
 
 #endif /* __DAX_H__ */
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 808d3bb..ccf72b4 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/pfn_t.h>
 #include <linux/badblocks.h>
+#include <linux/falloc.h>
 #include "../nvdimm/pfn.h"
 #include "../nvdimm/nd.h"
 #include "dax.h"
@@ -24,6 +25,69 @@ struct dax_pmem {
 	struct percpu_ref ref;
 	struct completion cmp;
 	struct badblocks bb;
+	resource_size_t start;
+	resource_size_t end;
+};
+
+static void dax_pmem_clear_poison(struct dax_pmem *dax_pmem,
+		loff_t offset, loff_t len)
+{
+	sector_t sector;
+	long cleared;
+
+	sector = offset >> 9;
+	cleared = nvdimm_clear_poison(dax_pmem->dev,
+			dax_pmem->start + offset, len);
+
+	if ((cleared > 0) && (cleared >> 9)) {
+		dev_dbg(dax_pmem->dev, "%s: %#llx clear %ld sector%s\n",
+				__func__, (unsigned long long)sector,
+				cleared >> 9, cleared >> 9 > 1 ? "s" : "");
+		badblocks_clear(&dax_pmem->bb, sector, cleared >> 9);
+	}
+}
+
+static long dax_pmem_fallocate(struct file *file, int mode,
+		loff_t start, loff_t len)
+{
+	struct dax_dev *dax_dev = file->private_data;
+	struct device *dev;
+	struct dax_pmem *dax_pmem;
+	loff_t end = start + len - 1;
+	loff_t res_size;
+
+	dev = dax_dev_get_device(dax_dev);
+	dax_pmem = dax_dev_get_private(dev);
+	res_size = dax_pmem->end - dax_pmem->start + 1;
+
+	dev_dbg(dev, "fallocate mode: %#x, start: %#llx, len: %llu\n",
+			mode, start, len);
+	dev_dbg(dev, "res start: %#llx end: %#llx size: %llu\n",
+			dax_pmem->start, dax_pmem->end, res_size);
+
+	/* check size boundares */
+	if (start >= dax_pmem->end)
+		return -EINVAL;
+	if (end >= res_size) {
+		if (mode & FALLOC_FL_KEEP_SIZE)
+			len = res_size - start;
+		else
+			return -EINVAL;
+	}
+
+	switch (mode) {
+	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
+		dax_pmem_clear_poison(dax_pmem, start, len);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static const struct file_operations pmem_fops = {
+	.fallocate = dax_pmem_fallocate,
 };
 
 static ssize_t dax_pmem_badblocks_show(struct device *dev,
@@ -158,8 +222,10 @@ static int dax_pmem_probe(struct device *dev)
 
 	/* TODO: support for subdividing a dax region... */
 	dax_dev = devm_create_dax_dev(dax_region, &res, 1,
-			dax_pmem_attribute_groups);
+			dax_pmem_attribute_groups, &pmem_fops);
 	dax_dev_set_private(dax_dev, dax_pmem);
+	dax_pmem->start = res.start;
+	dax_pmem->end = res.end;
 
 	rc = devm_init_badblocks(dev, &dax_pmem->bb);
 	if (rc)
diff --git a/fs/open.c b/fs/open.c
index d3ed817..15325fd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -306,7 +306,7 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 * for directories or not.
 	 */
 	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
-	    !S_ISBLK(inode->i_mode))
+	    !S_ISBLK(inode->i_mode) && !S_ISCHR(inode->i_mode))
 		return -ENODEV;
 
 	/* Check for wrap through zero too */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
