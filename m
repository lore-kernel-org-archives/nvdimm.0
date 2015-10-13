Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 2/2] ext2: Add locking for DAX faults
Date: Tue, 13 Oct 2015 16:25:37 -0600
Message-Id: <1444775137-23685-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
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
 fs/ext2/ext2.h  | 11 ++++++++
 fs/ext2/file.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ext2/inode.c | 10 +++++++
 fs/ext2/super.c |  3 +++
 4 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 8d15feb..4c69c94 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -684,6 +684,9 @@ struct ext2_inode_info {
 	struct rw_semaphore xattr_sem;
 #endif
 	rwlock_t i_meta_lock;
+#ifdef CONFIG_FS_DAX
+	struct rw_semaphore dax_sem;
+#endif
 
 	/*
 	 * truncate_mutex is for serialising ext2_truncate() against
@@ -699,6 +702,14 @@ struct ext2_inode_info {
 #endif
 };
 
+#ifdef CONFIG_FS_DAX
+#define dax_sem_down_write(ext2_inode)	down_write(&(ext2_inode)->dax_sem)
+#define dax_sem_up_write(ext2_inode)	up_write(&(ext2_inode)->dax_sem)
+#else
+#define dax_sem_down_write(ext2_inode)
+#define dax_sem_up_write(ext2_inode)
+#endif
+
 /*
  * Inode dynamic state flags
  */
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 1982c3f..11a42c5 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -27,27 +27,103 @@
 #include "acl.h"
 
 #ifdef CONFIG_FS_DAX
+/*
+ * The lock ordering for ext2 DAX fault paths is:
+ *
+ * mmap_sem (MM)
+ *   sb_start_pagefault (vfs, freeze)
+ *     ext2_inode_info->dax_sem
+ *       address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)
+ *         ext2_inode_info->truncate_mutex
+ *
+ * The default page_lock and i_size verification done by non-DAX fault paths
+ * is sufficient because ext2 doesn't support hole punching.
+ */
 static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext2_get_block, NULL);
+	struct inode *inode = file_inode(vma->vm_file);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	int ret;
+
+	if (vmf->flags & FAULT_FLAG_WRITE) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vma->vm_file);
+	}
+	down_read(&ei->dax_sem);
+
+	ret = __dax_fault(vma, vmf, ext2_get_block, NULL);
+
+	up_read(&ei->dax_sem);
+	if (vmf->flags & FAULT_FLAG_WRITE)
+		sb_end_pagefault(inode->i_sb);
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
+	if (flags & FAULT_FLAG_WRITE) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vma->vm_file);
+	}
+	down_read(&ei->dax_sem);
+
+	ret = __dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block, NULL);
+
+	up_read(&ei->dax_sem);
+	if (flags & FAULT_FLAG_WRITE)
+		sb_end_pagefault(inode->i_sb);
+	return ret;
 }
 
 static int ext2_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext2_get_block, NULL);
+	struct inode *inode = file_inode(vma->vm_file);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	int ret;
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
+	down_read(&ei->dax_sem);
+
+	ret = __dax_mkwrite(vma, vmf, ext2_get_block, NULL);
+
+	up_read(&ei->dax_sem);
+	sb_end_pagefault(inode->i_sb);
+	return ret;
+}
+
+static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
+		struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	int ret = VM_FAULT_NOPAGE;
+	loff_t size;
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
+	down_read(&ei->dax_sem);
+
+	/* check that the faulting page hasn't raced with truncate */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		ret = VM_FAULT_SIGBUS;
+
+	up_read(&ei->dax_sem);
+	sb_end_pagefault(inode->i_sb);
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
index c60a248..0aa9bf6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1085,6 +1085,7 @@ static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int de
 		ext2_free_data(inode, p, q);
 }
 
+/* dax_sem must be held when calling this function */
 static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 {
 	__le32 *i_data = EXT2_I(inode)->i_data;
@@ -1100,6 +1101,10 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 	blocksize = inode->i_sb->s_blocksize;
 	iblock = (offset + blocksize-1) >> EXT2_BLOCK_SIZE_BITS(inode->i_sb);
 
+#ifdef CONFIG_FS_DAX
+	WARN_ON(!rwsem_is_locked(&ei->dax_sem));
+#endif
+
 	n = ext2_block_to_path(inode, iblock, offsets, NULL);
 	if (n == 0)
 		return;
@@ -1185,7 +1190,10 @@ static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
 		return;
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
+
+	dax_sem_down_write(EXT2_I(inode));
 	__ext2_truncate_blocks(inode, offset);
+	dax_sem_up_write(EXT2_I(inode));
 }
 
 static int ext2_setsize(struct inode *inode, loff_t newsize)
@@ -1213,8 +1221,10 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	if (error)
 		return error;
 
+	dax_sem_down_write(EXT2_I(inode));
 	truncate_setsize(inode, newsize);
 	__ext2_truncate_blocks(inode, newsize);
+	dax_sem_up_write(EXT2_I(inode));
 
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	if (inode_needs_sync(inode)) {
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 900e19c..3a71cea 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -192,6 +192,9 @@ static void init_once(void *foo)
 	init_rwsem(&ei->xattr_sem);
 #endif
 	mutex_init(&ei->truncate_mutex);
+#ifdef CONFIG_FS_DAX
+	init_rwsem(&ei->dax_sem);
+#endif
 	inode_init_once(&ei->vfs_inode);
 }
 
-- 
2.1.0

