Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 4F3F41A1DFF
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 11:23:22 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] block: remove BLK_DEV_DAX config option
Date: Fri, 29 Jul 2016 12:23:14 -0600
Message-Id: <20160729182314.6368-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The functionality for block device DAX was already removed with this
commit:

commit acc93d30d7d4 ("Revert "block: enable dax for raw block devices"")

However, we still had a config option hanging around that was always
disabled because it depended on CONFIG_BROKEN.  This config option was
introduced in this commit:

commit 03cdadb04077 ("block: disable block device DAX by default")

This change reverts that commit, removing the dead config option.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 block/Kconfig  | 13 -------------
 fs/block_dev.c |  5 +----
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 0363cd7..161491d 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -88,19 +88,6 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
-config BLK_DEV_DAX
-	bool "Block device DAX support"
-	depends on FS_DAX
-	depends on BROKEN
-	help
-	  When DAX support is available (CONFIG_FS_DAX) raw block
-	  devices can also support direct userspace access to the
-	  storage capacity via MMAP(2) similar to a file on a
-	  DAX-enabled filesystem.  However, the DAX I/O-path disables
-	  some standard I/O-statistics, and the MMAP(2) path has some
-	  operational differences due to bypassing the page
-	  cache.  If in doubt, say N.
-
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
 	depends on BLK_CGROUP=y
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 71ccab1..ab7ebee 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1287,10 +1287,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
-		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
-			bdev->bd_inode->i_flags = S_DAX;
-		else
-			bdev->bd_inode->i_flags = 0;
+		bdev->bd_inode->i_flags = 0;
 
 		if (!partno) {
 			ret = -ENXIO;
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
