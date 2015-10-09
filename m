Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] ext2: Add locking for DAX faults
Date: Fri,  9 Oct 2015 16:02:08 -0600
Message-Id: <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add locking to ensure that DAX faults are isolated from ext2 operations
that modify the data blocks allocation for an inode.  This is intended to
be analogous to the work being done in XFS by Dave Chinner:

http://www.spinics.net/lists/linux-fsdevel/msg90260.html

Compared with XFS the ext2 case is greatly simplified by the fact that ext2
already allocates and zeros new blocks before they are returned as part of
ext2_get_block(), so DAX doesn't need to worry about getting unmapped or
unwritten buffer heads.

This means that the only work we need to do in ext2 is to isolate the DAX
faults from inode block allocation changes.  I believe this just means that
we need to isolate the DAX faults from truncate operations.

The newly introduced dax_sem is intended to replicate the protection
offered by i_mmaplock in XFS.  In addition to truncate the i_mmaplock also
protects XFS operations like hole punching, fallocate down, extent
manipulation IOCTLS like xfs_ioc_space() and extent swapping.  Truncate is
the only one of these operations supported by ext2.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext2/ext2.h  |  1 +
 fs/ext2/file.c  | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext2/inode.c |  9 +++++++++
 fs/ext2/super.c |  1 +
 4 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 8d15feb..ec3cd02 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -684,6 +684,7 @@ struct ext2_inode_info {
 	struct rw_semaphore xattr_sem;
 #endif
 	rwlock_t i_meta_lock;
+	struct rw_semaphore dax_sem;
 
 	/*
 	 * truncate_mutex is for serialising ext2_truncate() against
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 1982c3f..389c5d5 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -27,27 +27,70 @@
 #include "acl.h"
 
 #ifdef CONFIG_FS_DAX
+/*
+ * The lock ordering for ext2 DAX fault paths is:
+ *
+ * mmap_sem (MM)
+ *   ext2_inode_info->dax_sem
+ *     sb_start_pagefault (vfs, freeze - taken in DAX)
+ *       address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)
+ *         ext2_inode_info->truncate_mutex
+ */
 static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext2_get_block, NULL);
+	struct inode *inode = file_inode(vma->vm_file);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	int ret;
+
+	down_read(&ei->dax_sem);
+	ret = dax_fault(vma, vmf, ext2_get_block, NULL);
+	up_read(&ei->dax_sem);
+	return ret;
 }
 
 static int ext2_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 						pmd_t *pmd, unsigned int flags)
 {
-	return dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block, NULL);
+	struct inode *inode = file_inode(vma->vm_file);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	int ret;
+
+	down_read(&ei->dax_sem);
+	ret = dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block, NULL);
+	up_read(&ei->dax_sem);
+	return ret;
 }
 
 static int ext2_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext2_get_block, NULL);
+	struct inode *inode = file_inode(vma->vm_file);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	int ret;
+
+	down_read(&ei->dax_sem);
+	ret = dax_mkwrite(vma, vmf, ext2_get_block, NULL);
+	up_read(&ei->dax_sem);
+	return ret;
+}
+
+static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
+		struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	int ret;
+
+	down_read(&ei->dax_sem);
+	ret = dax_pfn_mkwrite(vma, vmf);
+	up_read(&ei->dax_sem);
+	return ret;
 }
 
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
 	.pmd_fault	= ext2_dax_pmd_fault,
 	.page_mkwrite	= ext2_dax_mkwrite,
-	.pfn_mkwrite	= dax_pfn_mkwrite,
+	.pfn_mkwrite	= ext2_dax_pfn_mkwrite,
 };
 
 static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index c60a248..2b974fc 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1085,6 +1085,7 @@ static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int de
 		ext2_free_data(inode, p, q);
 }
 
+/* dax_sem must be held when calling this function */
 static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 {
 	__le32 *i_data = EXT2_I(inode)->i_data;
@@ -1170,6 +1171,8 @@ do_indirects:
 
 static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
 {
+	struct ext2_inode_info *ei = EXT2_I(inode);
+
 	/*
 	 * XXX: it seems like a bug here that we don't allow
 	 * IS_APPEND inode to have blocks-past-i_size trimmed off.
@@ -1185,11 +1188,15 @@ static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
 		return;
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
+
+	down_write(&ei->dax_sem);
 	__ext2_truncate_blocks(inode, offset);
+	up_write(&ei->dax_sem);
 }
 
 static int ext2_setsize(struct inode *inode, loff_t newsize)
 {
+	struct ext2_inode_info *ei = EXT2_I(inode);
 	int error;
 
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
@@ -1213,8 +1220,10 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	if (error)
 		return error;
 
+	down_write(&ei->dax_sem);
 	truncate_setsize(inode, newsize);
 	__ext2_truncate_blocks(inode, newsize);
+	up_write(&ei->dax_sem);
 
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	if (inode_needs_sync(inode)) {
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 900e19c..0f3fedc 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -192,6 +192,7 @@ static void init_once(void *foo)
 	init_rwsem(&ei->xattr_sem);
 #endif
 	mutex_init(&ei->truncate_mutex);
+	init_rwsem(&ei->dax_sem);
 	inode_init_once(&ei->vfs_inode);
 }
 
-- 
2.1.0

