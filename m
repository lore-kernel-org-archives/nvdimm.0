Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BF3E82004
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:58 -0800 (PST)
Subject: [RFC PATCH 09/17] block: kill bdev_dax_capable()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:52 -0800
Message-ID: <148559261248.11180.9969692627177035979.stgit@dwillia2-desk3.amr.corp.intel.com>
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

This is leftover dead code that has since been replaced by
bdev_dax_supported().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c         |   24 ------------------------
 include/linux/blkdev.h |    1 -
 2 files changed, 25 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 601b71b76d7f..edb1d2b16b8f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -807,30 +807,6 @@ int bdev_dax_supported(struct super_block *sb, int blocksize)
 }
 EXPORT_SYMBOL_GPL(bdev_dax_supported);
 
-/**
- * bdev_dax_capable() - Return if the raw device is capable for dax
- * @bdev: The device for raw block device access
- */
-bool bdev_dax_capable(struct block_device *bdev)
-{
-	struct blk_dax_ctl dax = {
-		.size = PAGE_SIZE,
-	};
-
-	if (!IS_ENABLED(CONFIG_FS_DAX))
-		return false;
-
-	dax.sector = 0;
-	if (bdev_direct_access(bdev, &dax) < 0)
-		return false;
-
-	dax.sector = bdev->bd_part->nr_sects - (PAGE_SIZE / 512);
-	if (bdev_direct_access(bdev, &dax) < 0)
-		return false;
-
-	return true;
-}
-
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3c0ff78b1219..5e7706f7d533 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1904,7 +1904,6 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 extern int bdev_dax_supported(struct super_block *, int);
-extern bool bdev_dax_capable(struct block_device *);
 #else /* CONFIG_BLOCK */
 
 struct block_device;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
