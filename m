Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C55B582004
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:41:33 -0800 (PST)
Subject: [RFC PATCH 13/17] fs: update mount_bdev() to lookup dax infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:37:14 -0800
Message-ID: <148559263442.11180.2158046423959539211.stgit@dwillia2-desk3.amr.corp.intel.com>
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

This is in preparation for removing the ->direct_access() method from
block_device_operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c     |    6 ++++--
 fs/super.c         |   32 +++++++++++++++++++++++++++++---
 include/linux/fs.h |    1 +
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index bf4b51a3a412..a73f2388c515 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -806,14 +806,16 @@ int bdev_dax_supported(struct super_block *sb, int blocksize)
 		.sector = 0,
 		.size = PAGE_SIZE,
 	};
-	int err;
+	int err, id;
 
 	if (blocksize != PAGE_SIZE) {
 		vfs_msg(sb, KERN_ERR, "error: unsupported blocksize for dax");
 		return -EINVAL;
 	}
 
-	err = bdev_direct_access(sb->s_bdev, &dax);
+	id = dax_read_lock();
+	err = bdev_dax_direct_access(sb->s_bdev, sb->s_dax, &dax);
+	dax_read_unlock(id);
 	if (err < 0) {
 		switch (err) {
 		case -EOPNOTSUPP:
diff --git a/fs/super.c b/fs/super.c
index ea662b0e5e78..5e64d11c46c1 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -26,6 +26,7 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
+#include <linux/dax.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
@@ -1038,9 +1039,17 @@ struct dentry *mount_ns(struct file_system_type *fs_type,
 EXPORT_SYMBOL(mount_ns);
 
 #ifdef CONFIG_BLOCK
+struct mount_bdev_data {
+	struct block_device *bdev;
+	struct dax_inode *dax_inode;
+};
+
 static int set_bdev_super(struct super_block *s, void *data)
 {
-	s->s_bdev = data;
+	struct mount_bdev_data *mb_data = data;
+
+	s->s_bdev = mb_data->bdev;
+	s->s_dax = mb_data->dax_inode;
 	s->s_dev = s->s_bdev->bd_dev;
 
 	/*
@@ -1053,14 +1062,18 @@ static int set_bdev_super(struct super_block *s, void *data)
 
 static int test_bdev_super(struct super_block *s, void *data)
 {
-	return (void *)s->s_bdev == data;
+	struct mount_bdev_data *mb_data = data;
+
+	return s->s_bdev == mb_data->bdev;
 }
 
 struct dentry *mount_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int))
 {
+	struct mount_bdev_data mb_data;
 	struct block_device *bdev;
+	struct dax_inode *dax_inode;
 	struct super_block *s;
 	fmode_t mode = FMODE_READ | FMODE_EXCL;
 	int error = 0;
@@ -1072,6 +1085,11 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
 
+	if (IS_ENABLED(CONFIG_FS_DAX))
+		dax_inode = dax_get_by_host(bdev->bd_disk->disk_name);
+	else
+		dax_inode = NULL;
+
 	/*
 	 * once the super is inserted into the list by sget, s_umount
 	 * will protect the lockfs code from trying to start a snapshot
@@ -1083,8 +1101,13 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		error = -EBUSY;
 		goto error_bdev;
 	}
+
+	mb_data = (struct mount_bdev_data) {
+		.bdev = bdev,
+		.dax_inode = dax_inode,
+	};
 	s = sget(fs_type, test_bdev_super, set_bdev_super, flags | MS_NOSEC,
-		 bdev);
+		 &mb_data);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s))
 		goto error_s;
@@ -1126,6 +1149,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 	error = PTR_ERR(s);
 error_bdev:
 	blkdev_put(bdev, mode);
+	put_dax_inode(dax_inode);
 error:
 	return ERR_PTR(error);
 }
@@ -1133,6 +1157,7 @@ EXPORT_SYMBOL(mount_bdev);
 
 void kill_block_super(struct super_block *sb)
 {
+	struct dax_inode *dax_inode = sb->s_dax;
 	struct block_device *bdev = sb->s_bdev;
 	fmode_t mode = sb->s_mode;
 
@@ -1141,6 +1166,7 @@ void kill_block_super(struct super_block *sb)
 	sync_blockdev(bdev);
 	WARN_ON_ONCE(!(mode & FMODE_EXCL));
 	blkdev_put(bdev, mode | FMODE_EXCL);
+	put_dax_inode(dax_inode);
 }
 
 EXPORT_SYMBOL(kill_block_super);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c930cbc19342..fdad43169146 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1313,6 +1313,7 @@ struct super_block {
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
 	struct block_device	*s_bdev;
+	struct dax_inode	*s_dax;
 	struct backing_dev_info *s_bdi;
 	struct mtd_info		*s_mtd;
 	struct hlist_node	s_instances;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
