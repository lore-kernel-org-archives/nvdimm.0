Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2CA881FF6
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:41:03 -0800 (PST)
Subject: [RFC PATCH 10/17] block: introduce bdev_dax_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:58 -0800
Message-ID: <148559261791.11180.12085685820239925499.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Provide a replacement for bdev_direct_access() that uses
dax_operations.direct_access() instead of
block_device_operations.direct_access(). Once all consumers of the old
api have been converted bdev_direct_access() will be deleted.

Given that block device partitioning decisions can cause dax page
alignment constraints to be violated we still need to validate the
block_device before calling the dax ->direct_access method.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/Kconfig          |    1 +
 drivers/dax/super.c    |   33 +++++++++++++++++++++++++++++++++
 fs/block_dev.c         |   28 ++++++++++++++++++++++++++++
 include/linux/blkdev.h |    3 +++
 include/linux/dax.h    |    2 ++
 5 files changed, 67 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index 8bf114a3858a..9be785173280 100644
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
index eb844ffea3cf..ab5b082df5dd 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -65,6 +65,39 @@ struct dax_inode {
 	const struct dax_operations *ops;
 };
 
+long dax_direct_access(struct dax_inode *dax_inode, phys_addr_t dev_addr,
+		void **kaddr, pfn_t *pfn, long size)
+{
+	long avail;
+
+	/*
+	 * The device driver is allowed to sleep, in order to make the
+	 * memory directly accessible.
+	 */
+	might_sleep();
+
+	if (!dax_inode)
+		return -EOPNOTSUPP;
+
+	if (!dax_inode_alive(dax_inode))
+		return -ENXIO;
+
+	if (size < 0)
+		return size;
+
+	if (dev_addr % PAGE_SIZE)
+		return -EINVAL;
+
+	avail = dax_inode->ops->direct_access(dax_inode, dev_addr, kaddr, pfn,
+			size);
+	if (!avail)
+		return -ERANGE;
+	if (avail > 0 && avail & ~PAGE_MASK)
+		return -ENXIO;
+	return min(avail, size);
+}
+EXPORT_SYMBOL_GPL(dax_direct_access);
+
 bool dax_inode_alive(struct dax_inode *dax_inode)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index edb1d2b16b8f..bf4b51a3a412 100644
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
@@ -763,6 +764,33 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
 /**
+ * bdev_dax_direct_access() - bdev-sector to pfn_t and kernel virtual address
+ * @bdev: host block device for @dax_inode
+ * @dax_inode: interface data and operations for a memory device
+ * @dax: control and output parameters for ->direct_access
+ *
+ * Return: negative errno if an error occurs, otherwise the number of bytes
+ * accessible at this address.
+ *
+ * Locking: must be called with dax_read_lock() held
+ */
+long bdev_dax_direct_access(struct block_device *bdev,
+		struct dax_inode *dax_inode, struct blk_dax_ctl *dax)
+{
+	sector_t sector = dax->sector;
+
+	if (!blk_queue_dax(bdev->bd_queue))
+		return -EOPNOTSUPP;
+	if ((sector + DIV_ROUND_UP(dax->size, 512))
+			> part_nr_sects_read(bdev->bd_part))
+		return -ERANGE;
+	sector += get_start_sect(bdev);
+	return dax_direct_access(dax_inode, sector * 512, &dax->addr,
+			&dax->pfn, dax->size);
+}
+EXPORT_SYMBOL_GPL(bdev_dax_direct_access);
+
+/**
  * bdev_dax_supported() - Check if the device supports dax for filesystem
  * @sb: The superblock of the device
  * @blocksize: The block size of the device
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5e7706f7d533..3b3c5ce376fd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1903,6 +1903,9 @@ extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
+struct dax_inode;
+extern long bdev_dax_direct_access(struct block_device *bdev,
+		struct dax_inode *dax_inode, struct blk_dax_ctl *dax);
 extern int bdev_dax_supported(struct super_block *, int);
 #else /* CONFIG_BLOCK */
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5aa620e8e5a2..2ef8e18e2587 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -22,6 +22,8 @@ void *dax_inode_get_private(struct dax_inode *dax_inode);
 void put_dax_inode(struct dax_inode *dax_inode);
 bool dax_inode_alive(struct dax_inode *dax_inode);
 void kill_dax_inode(struct dax_inode *dax_inode);
+long dax_direct_access(struct dax_inode *dax_inode, phys_addr_t dev_addr,
+		void **kaddr, pfn_t *pfn, long size);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
