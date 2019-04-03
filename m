Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 06889211F1E0E
 for <linux-nvdimm@lists.01.org>; Wed,  3 Apr 2019 03:41:50 -0700 (PDT)
From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH v4 3/5] libnvdimm: add dax_dev sync flag
Date: Wed,  3 Apr 2019 16:10:16 +0530
Message-Id: <20190403104018.23947-4-pagupta@redhat.com>
In-Reply-To: <20190403104018.23947-1-pagupta@redhat.com>
References: <20190403104018.23947-1-pagupta@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: jack@suse.cz, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, lcapitulino@redhat.com, adilger.kernel@dilger.ca, zwisler@kernel.org, aarcange@redhat.com, darrick.wong@oracle.com, david@redhat.com, willy@infradead.org, hch@infradead.org, nilal@redhat.com, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, kwolf@redhat.com, tytso@mit.edu, xiaoguangrong.eric@gmail.com, cohuck@redhat.com, rjw@rjwysocki.net, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

This patch adds 'DAXDEV_SYNC' flag which is set
for nd_region doing synchronous flush. This later 
is used to disable MAP_SYNC functionality for 
ext4 & xfs filesystem for devices don't support
synchronous flush.

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 drivers/dax/bus.c            |  2 +-
 drivers/dax/super.c          | 13 ++++++++++++-
 drivers/md/dm.c              |  2 +-
 drivers/nvdimm/pmem.c        |  3 ++-
 drivers/nvdimm/region_devs.c |  7 +++++++
 include/linux/dax.h          |  9 +++++++--
 include/linux/libnvdimm.h    |  1 +
 7 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 2109cfe80219..431bf7d2a7f9 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -388,7 +388,7 @@ struct dev_dax *__devm_create_dev_dax(struct dax_region *dax_region, int id,
 	 * No 'host' or dax_operations since there is no access to this
 	 * device outside of mmap of the resulting character device.
 	 */
-	dax_dev = alloc_dax(dev_dax, NULL, NULL);
+	dax_dev = alloc_dax(dev_dax, NULL, NULL, true);
 	if (!dax_dev)
 		goto err;
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0a339b85133e..bd6509308d05 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -186,6 +186,8 @@ enum dax_device_flags {
 	DAXDEV_ALIVE,
 	/* gate whether dax_flush() calls the low level flush routine */
 	DAXDEV_WRITE_CACHE,
+	/* flag to check if device supports synchronous flush */
+	DAXDEV_SYNC,
 };
 
 /**
@@ -354,6 +356,12 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
 
+bool dax_synchronous(struct dax_device *dax_dev)
+{
+	return test_bit(DAXDEV_SYNC, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(dax_synchronous);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
@@ -511,7 +519,7 @@ static void dax_add_host(struct dax_device *dax_dev, const char *host)
 }
 
 struct dax_device *alloc_dax(void *private, const char *__host,
-		const struct dax_operations *ops)
+		const struct dax_operations *ops, bool sync)
 {
 	struct dax_device *dax_dev;
 	const char *host;
@@ -534,6 +542,9 @@ struct dax_device *alloc_dax(void *private, const char *__host,
 	dax_add_host(dax_dev, host);
 	dax_dev->ops = ops;
 	dax_dev->private = private;
+	if (sync)
+		set_bit(DAXDEV_SYNC, &dax_dev->flags);
+
 	return dax_dev;
 
  err_dev:
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 68d24056d0b1..534e12ca6329 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1965,7 +1965,7 @@ static struct mapped_device *alloc_dev(int minor)
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
-		dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
+		dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops, true);
 		if (!dax_dev)
 			goto bad;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5a5b3ea4d073..78f71ba0e7cf 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -466,7 +466,8 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_res);
 	disk->bb = &pmem->bb;
 
-	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops);
+	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops,
+					is_nvdimm_sync(nd_region));
 
 	if (!dax_dev) {
 		put_disk(disk);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index fb1041ab32a6..8c7aa047fe2b 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1231,6 +1231,13 @@ int nvdimm_has_cache(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL_GPL(nvdimm_has_cache);
 
+bool is_nvdimm_sync(struct nd_region *nd_region)
+{
+	return is_nd_pmem(&nd_region->dev) &&
+		!test_bit(ND_REGION_ASYNC, &nd_region->flags);
+}
+EXPORT_SYMBOL_GPL(is_nvdimm_sync);
+
 struct conflict_context {
 	struct nd_region *nd_region;
 	resource_size_t start, size;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0dd316a74a29..9bdd50d06ef6 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -32,18 +32,19 @@ extern struct attribute_group dax_attribute_group;
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *dax_get_by_host(const char *host);
 struct dax_device *alloc_dax(void *private, const char *host,
-		const struct dax_operations *ops);
+		const struct dax_operations *ops, bool sync);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
+bool dax_synchronous(struct dax_device *dax_dev);
 #else
 static inline struct dax_device *dax_get_by_host(const char *host)
 {
 	return NULL;
 }
 static inline struct dax_device *alloc_dax(void *private, const char *host,
-		const struct dax_operations *ops)
+		const struct dax_operations *ops, bool sync)
 {
 	/*
 	 * Callers should check IS_ENABLED(CONFIG_DAX) to know if this
@@ -64,6 +65,10 @@ static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
 {
 	return false;
 }
+static inline bool dax_synchronous(struct dax_device *dax_dev)
+{
+	return false;
+}
 #endif
 
 struct writeback_control;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index d9d2ab8a6e64..9a8aea370cbc 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -270,6 +270,7 @@ int generic_nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
+bool is_nvdimm_sync(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
