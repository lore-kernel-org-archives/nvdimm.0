Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3562321A0BAB0
 for <linux-nvdimm@lists.01.org>; Sat, 13 May 2017 17:58:56 -0700 (PDT)
Subject: [PATCH] dax, xfs,
 ext4: compile out iomap-dax paths in the FS_DAX=n case
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 May 2017 17:53:04 -0700
Message-ID: <149472318419.18012.5702423859819830972.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Tetsuo reports:

  fs/built-in.o: In function `xfs_file_iomap_end':
  xfs_iomap.c:(.text+0xe0ef9): undefined reference to `put_dax'
  fs/built-in.o: In function `xfs_file_iomap_begin':
  xfs_iomap.c:(.text+0xe1a7f): undefined reference to `dax_get_by_host'
  make: *** [vmlinux] Error 1
  $ grep DAX .config
  CONFIG_DAX=m
  # CONFIG_DEV_DAX is not set
  # CONFIG_FS_DAX is not set

When FS_DAX=n we can/must throw away the dax code in filesystems.
Implement 'fs_' versions of dax_get_by_host() and put_dax() that are
nops in the FS_DAX=n case.

Cc: <linux-xfs@vger.kernel.org>
Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@suse.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: ef51042472f5 ("block, dax: move 'select DAX' from BLOCK to FS_DAX")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/inode.c     |    4 ++--
 fs/ext4/inode.c     |    4 ++--
 fs/xfs/xfs_iomap.c  |    4 ++--
 include/linux/dax.h |   34 +++++++++++++++++++++++++++-------
 4 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 26d77f9f8c12..2dcbd5698884 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -817,7 +817,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	iomap->bdev = bdev;
 	iomap->offset = (u64)first_block << blkbits;
 	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
 	else
 		iomap->dax_dev = NULL;
 
@@ -841,7 +841,7 @@ static int
 ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap)
 {
-	put_dax(iomap->dax_dev);
+	fs_put_dax(iomap->dax_dev);
 	if (iomap->type == IOMAP_MAPPED &&
 	    written < length &&
 	    (flags & IOMAP_WRITE))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5834c4d76be8..1bd0bfa547f6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3412,7 +3412,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	bdev = inode->i_sb->s_bdev;
 	iomap->bdev = bdev;
 	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
 	else
 		iomap->dax_dev = NULL;
 	iomap->offset = first_block << blkbits;
@@ -3447,7 +3447,7 @@ static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	int blkbits = inode->i_blkbits;
 	bool truncate = false;
 
-	put_dax(iomap->dax_dev);
+	fs_put_dax(iomap->dax_dev);
 	if (!(flags & IOMAP_WRITE) || (flags & IOMAP_FAULT))
 		return 0;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a63f61c256bd..94e5bdf7304c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1068,7 +1068,7 @@ xfs_file_iomap_begin(
 	/* optionally associate a dax device with the iomap bdev */
 	bdev = iomap->bdev;
 	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
 	else
 		iomap->dax_dev = NULL;
 
@@ -1149,7 +1149,7 @@ xfs_file_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	put_dax(iomap->dax_dev);
+	fs_put_dax(iomap->dax_dev);
 	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
 		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
 				length, written, iomap);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 00ebac854bb7..5ec1f6c47716 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -18,6 +18,20 @@ struct dax_operations {
 			void **, pfn_t *);
 };
 
+#if IS_ENABLED(CONFIG_DAX)
+struct dax_device *dax_get_by_host(const char *host);
+void put_dax(struct dax_device *dax_dev);
+#else
+static inline struct dax_device *dax_get_by_host(const char *host)
+{
+	return NULL;
+}
+
+static inline void put_dax(struct dax_device *dax_dev)
+{
+}
+#endif
+
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
 int __bdev_dax_supported(struct super_block *sb, int blocksize);
@@ -25,23 +39,29 @@ static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
 	return __bdev_dax_supported(sb, blocksize);
 }
+
+static inline struct dax_device *fs_dax_get_by_host(const char *host)
+{
+	return dax_get_by_host(host);
+}
+
+static inline void fs_put_dax(struct dax_device *dax_dev)
+{
+	put_dax(dax_dev);
+}
+
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
 	return -EOPNOTSUPP;
 }
-#endif
 
-#if IS_ENABLED(CONFIG_DAX)
-struct dax_device *dax_get_by_host(const char *host);
-void put_dax(struct dax_device *dax_dev);
-#else
-static inline struct dax_device *dax_get_by_host(const char *host)
+static inline struct dax_device *fs_dax_get_by_host(const char *host)
 {
 	return NULL;
 }
 
-static inline void put_dax(struct dax_device *dax_dev)
+static inline void fs_put_dax(struct dax_device *dax_dev)
 {
 }
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
