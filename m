Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38C002095BB86
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 12:50:13 -0700 (PDT)
Subject: [PATCH v3 1/4] dax: introduce a fs_dax_get_by_bdev() helper
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 12:43:52 -0700
Message-ID: <150412223265.10177.11004612169458058274.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a helper that can replace the following common pattern:

	if (blk_queue_dax(bdev->bd_queue))
		fs_dax_get_by_host(bdev->bd_disk->disk_name);

This will be used to move dax_device lookup from iomap-operation time to
fs-mount time.

Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |   10 ++++++++++
 include/linux/dax.h |    6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 938eb4868f7f..b699aac268a6 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -46,6 +46,8 @@ void dax_read_unlock(int id)
 EXPORT_SYMBOL_GPL(dax_read_unlock);
 
 #ifdef CONFIG_BLOCK
+#include <linux/blkdev.h>
+
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 		pgoff_t *pgoff)
 {
@@ -59,6 +61,14 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 }
 EXPORT_SYMBOL(bdev_dax_pgoff);
 
+struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
+{
+	if (!blk_queue_dax(bdev->bd_queue))
+		return NULL;
+	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
+}
+EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
+
 /**
  * __bdev_dax_supported() - Check if the device supports dax for filesystem
  * @sb: The superblock of the device
diff --git a/include/linux/dax.h b/include/linux/dax.h
index df97b7af7e2c..ac8afa18f707 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -57,6 +57,7 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 	put_dax(dax_dev);
 }
 
+struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -71,6 +72,11 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
 static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 }
+
+static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
+{
+	return NULL;
+}
 #endif
 
 int dax_read_lock(void);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
