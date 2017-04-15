Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47EFF2194EB6A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:39:50 -0700 (PDT)
Subject: [PATCH v2 10/33] dax: introduce dax_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:34:01 -0700
Message-ID: <149222364131.32363.7662501769558653839.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Replace bdev_direct_access() with dax_direct_access() that uses
dax_device and dax_operations instead of a block_device and
block_device_operations for dax. Once all consumers of the old api have
been converted bdev_direct_access() will be deleted.

Given that block device partitioning decisions can cause dax page
alignment constraints to be violated this also introduces the
bdev_dax_pgoff() helper. It handles calculating a logical pgoff relative
to the dax_device and also checks for page alignment.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/Kconfig          |    1 +
 drivers/dax/super.c    |   39 +++++++++++++++++++++++++++++++++++++++
 fs/block_dev.c         |   14 ++++++++++++++
 include/linux/blkdev.h |    1 +
 include/linux/dax.h    |    2 ++
 5 files changed, 57 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index e9f780f815f5..93da7fc3f254 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -6,6 +6,7 @@ menuconfig BLOCK
        default y
        select SBITMAP
        select SRCU
+       select DAX
        help
 	 Provide block layer support for the kernel.
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 45ccfc043da8..23ce3ab49f10 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -65,6 +65,45 @@ struct dax_device {
 	const struct dax_operations *ops;
 };
 
+/**
+ * dax_direct_access() - translate a device pgoff to an absolute pfn
+ * @dax_dev: a dax_device instance representing the logical memory range
+ * @pgoff: offset in pages from the start of the device to translate
+ * @nr_pages: number of consecutive pages caller can handle relative to @pfn
+ * @kaddr: output parameter that returns a virtual address mapping of pfn
+ * @pfn: output parameter that returns an absolute pfn translation of @pgoff
+ *
+ * Return: negative errno if an error occurs, otherwise the number of
+ * pages accessible at the device relative @pgoff.
+ */
+long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
+		void **kaddr, pfn_t *pfn)
+{
+	long avail;
+
+	/*
+	 * The device driver is allowed to sleep, in order to make the
+	 * memory directly accessible.
+	 */
+	might_sleep();
+
+	if (!dax_dev)
+		return -EOPNOTSUPP;
+
+	if (!dax_alive(dax_dev))
+		return -ENXIO;
+
+	if (nr_pages < 0)
+		return nr_pages;
+
+	avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
+			kaddr, pfn);
+	if (!avail)
+		return -ERANGE;
+	return min(avail, nr_pages);
+}
+EXPORT_SYMBOL_GPL(dax_direct_access);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7f40ea2f0875..2f7885712575 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/blkpg.h>
 #include <linux/magic.h>
+#include <linux/dax.h>
 #include <linux/buffer_head.h>
 #include <linux/swap.h>
 #include <linux/pagevec.h>
@@ -762,6 +763,19 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
+int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
+		pgoff_t *pgoff)
+{
+	phys_addr_t phys_off = (get_start_sect(bdev) + sector) * 512;
+
+	if (pgoff)
+		*pgoff = PHYS_PFN(phys_off);
+	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL(bdev_dax_pgoff);
+
 /**
  * bdev_dax_supported() - Check if the device supports dax for filesystem
  * @sb: The superblock of the device
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f72708399b83..612c497d1461 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1958,6 +1958,7 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 extern int bdev_dax_supported(struct super_block *, int);
+int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 39a0312c45c3..7e62e280c11f 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -27,6 +27,8 @@ void put_dax(struct dax_device *dax_dev);
 bool dax_alive(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
+long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
+		void **kaddr, pfn_t *pfn);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
