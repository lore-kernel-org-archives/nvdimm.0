Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Date: Fri, 22 Jan 2016 16:06:11 -0700
Message-Id: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

With the current DAX code the following race exists:

Process 1                	Process 2
---------			---------

__dax_fault() - read file f, index 0
  get_block() -> returns hole
                             	__dax_fault() - write file f, index 0
                                  get_block() -> allocates blocks
                                  dax_insert_mapping()
  dax_load_hole()
  *data corruption*

An analogous race exists between __dax_fault() loading a hole and
__dax_pmd_fault() allocating a PMD DAX page and trying to insert it, and
that race also ends in data corruption.

One solution to this race was proposed by Jan Kara:

  So we need some exclusion that makes sure pgoff->block mapping
  information is uptodate at the moment we insert it into page tables. The
  simplest reasonably fast thing I can see is:

  When handling a read fault, things stay as is and filesystem protects the
  fault with an equivalent of EXT4_I(inode)->i_mmap_sem held for reading.
  When handling a write fault we first grab EXT4_I(inode)->i_mmap_sem for
  reading and try a read fault. If __dax_fault() sees a hole returned from
  get_blocks() during a write fault, it bails out. Filesystem grabs
  EXT4_I(inode)->i_mmap_sem for writing and retries with different
  get_blocks() callback which will allocate blocks. That way we get proper
  exclusion for faults needing to allocate blocks.

This patch adds this logic to DAX, ext2, ext4 and XFS.  The changes for
these four components all appear in the same patch as opposed to being
spread out among multiple patches in a series because we are changing the
argument list to __dax_fault(), __dax_pmd_fault() and __dax_mkwrite().
This means we can't easily change things one component at a time and still
keep the series bisectable.

For ext4 this patch assumes that the journal entry is only needed when we
are actually allocating blocks with get_block().  An in-depth review of
this logic would be welcome.

I also fixed a bug in the ext4 implementation of ext4_dax_mkwrite().
Previously it assumed that the block allocation was already complete, so it
didn't create a journal entry.  For a read that creates a zero page to
cover a hole followed by a write that actually allocates storage, this is
incorrect.  The ext4_dax_mkwrite() -> __dax_mkwrite() -> __dax_fault() path
would call get_blocks() to allocate storage, so I'm pretty sure we need a
journal entry here.

With that fixed, I noticed that for both ext2 and ext4 the paths through
the .fault and .page_mkwrite vmops paths were exactly the same, so I
removed ext4_dax_mkwrite() and ext2_dax_mkwrite() and just use
ext4_dax_fault() and ext2_dax_fault() directly instead.

I'm still in the process of testing this patch, which is part of the reason
why it is marked as RFC.  I know of at least one deadlock that is easily
hit by doing a read of a hole followed by a write which allocates storage.
If you're using xfstests you can hit this easily with generic/075 with any
of the three filesytems.  I'll continue to track this down, but I wanted to
send out this RFC to sanity check the general approach.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c      | 19 ++++++++++--
 fs/dax.c            | 20 ++++++++++---
 fs/ext2/file.c      | 41 ++++++++++++-------------
 fs/ext4/file.c      | 86 +++++++++++++++++++++++++----------------------------
 fs/xfs/xfs_file.c   | 28 +++++++++++++----
 include/linux/dax.h |  8 +++--
 6 files changed, 121 insertions(+), 81 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 303b7cd..775f1b0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1733,13 +1733,28 @@ static const struct address_space_operations def_blk_aops = {
  */
 static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
+	int ret;
+
+	ret = __dax_fault(vma, vmf, blkdev_get_block, NULL, false);
+
+	if (WARN_ON_ONCE(ret == -EAGAIN))
+		ret = VM_FAULT_SIGBUS;
+
+	return ret;
 }
 
 static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, unsigned int flags)
 {
-	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL);
+	int ret;
+
+	ret = __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL,
+			false);
+
+	if (WARN_ON_ONCE(ret == -EAGAIN))
+		ret = VM_FAULT_SIGBUS;
+
+	return ret;
 }
 
 static void blkdev_vm_open(struct vm_area_struct *vma)
diff --git a/fs/dax.c b/fs/dax.c
index 206650f..7a927eb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -582,13 +582,19 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
  *	extent mappings from @get_block, but it is optional for reads as
  *	dax_insert_mapping() will always zero unwritten blocks. If the fs does
  *	not support unwritten extents, the it should pass NULL.
+ * @alloc_ok: True if our caller is holding a lock that isolates us from other
+ *	DAX faults on the same inode.  This allows us to allocate new storage
+ *	with get_block() and not have to worry about races with other fault
+ *	handlers.  If this is unset and we need to allocate storage we will
+ *	return -EAGAIN to ask our caller to retry with the proper locking.
  *
  * When a page fault occurs, filesystems may call this helper in their
  * fault handler for DAX files. __dax_fault() assumes the caller has done all
  * the necessary locking for the page fault to proceed successfully.
  */
 int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
-			get_block_t get_block, dax_iodone_t complete_unwritten)
+			get_block_t get_block, dax_iodone_t complete_unwritten,
+			bool alloc_ok)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
@@ -642,6 +648,9 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
+			if (!alloc_ok)
+				return -EAGAIN;
+
 			error = get_block(inode, block, &bh, 1);
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
@@ -745,7 +754,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
 	}
-	result = __dax_fault(vma, vmf, get_block, complete_unwritten);
+	result = __dax_fault(vma, vmf, get_block, complete_unwritten, false);
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(sb);
 
@@ -780,7 +789,7 @@ static void __dax_dbg(struct buffer_head *bh, unsigned long address,
 
 int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		pmd_t *pmd, unsigned int flags, get_block_t get_block,
-		dax_iodone_t complete_unwritten)
+		dax_iodone_t complete_unwritten, bool alloc_ok)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
@@ -836,6 +845,9 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		return VM_FAULT_SIGBUS;
 
 	if (!buffer_mapped(&bh) && write) {
+		if (!alloc_ok)
+			return -EAGAIN;
+
 		if (get_block(inode, block, &bh, 1) != 0)
 			return VM_FAULT_SIGBUS;
 		alloc = true;
@@ -1017,7 +1029,7 @@ int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		file_update_time(vma->vm_file);
 	}
 	result = __dax_pmd_fault(vma, address, pmd, flags, get_block,
-				complete_unwritten);
+				complete_unwritten, false);
 	if (flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(sb);
 
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 2c88d68..1106a9e 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -49,11 +49,17 @@ static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		sb_start_pagefault(inode->i_sb);
 		file_update_time(vma->vm_file);
 	}
+
 	down_read(&ei->dax_sem);
+	ret = __dax_fault(vma, vmf, ext2_get_block, NULL, false);
+	up_read(&ei->dax_sem);
 
-	ret = __dax_fault(vma, vmf, ext2_get_block, NULL);
+	if (ret == -EAGAIN) {
+		down_write(&ei->dax_sem);
+		ret = __dax_fault(vma, vmf, ext2_get_block, NULL, true);
+		up_write(&ei->dax_sem);
+	}
 
-	up_read(&ei->dax_sem);
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
@@ -70,33 +76,24 @@ static int ext2_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 		sb_start_pagefault(inode->i_sb);
 		file_update_time(vma->vm_file);
 	}
+
 	down_read(&ei->dax_sem);
+	ret = __dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block, NULL,
+			false);
+	up_read(&ei->dax_sem);
 
-	ret = __dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block, NULL);
+	if (ret == -EAGAIN) {
+		down_write(&ei->dax_sem);
+		ret = __dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block,
+				NULL, true);
+		up_write(&ei->dax_sem);
+	}
 
-	up_read(&ei->dax_sem);
 	if (flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 
-static int ext2_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct inode *inode = file_inode(vma->vm_file);
-	struct ext2_inode_info *ei = EXT2_I(inode);
-	int ret;
-
-	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
-	down_read(&ei->dax_sem);
-
-	ret = __dax_mkwrite(vma, vmf, ext2_get_block, NULL);
-
-	up_read(&ei->dax_sem);
-	sb_end_pagefault(inode->i_sb);
-	return ret;
-}
-
 static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 		struct vm_fault *vmf)
 {
@@ -124,7 +121,7 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
 	.pmd_fault	= ext2_dax_pmd_fault,
-	.page_mkwrite	= ext2_dax_mkwrite,
+	.page_mkwrite	= ext2_dax_fault,
 	.pfn_mkwrite	= ext2_dax_pfn_mkwrite,
 };
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index fa899c9..abddc8a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -204,24 +204,30 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
-		down_read(&EXT4_I(inode)->i_mmap_sem);
-		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
-						EXT4_DATA_TRANS_BLOCKS(sb));
-	} else
-		down_read(&EXT4_I(inode)->i_mmap_sem);
+	}
 
-	if (IS_ERR(handle))
-		result = VM_FAULT_SIGBUS;
-	else
-		result = __dax_fault(vma, vmf, ext4_dax_mmap_get_block, NULL);
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	result = __dax_fault(vma, vmf, ext4_dax_mmap_get_block, NULL,
+			false);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
 
-	if (write) {
-		if (!IS_ERR(handle))
+	if (result == -EAGAIN) {
+		down_write(&EXT4_I(inode)->i_mmap_sem);
+		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
+				EXT4_DATA_TRANS_BLOCKS(sb));
+
+		if (IS_ERR(handle))
+			result = VM_FAULT_SIGBUS;
+		else {
+			result = __dax_fault(vma, vmf,
+					ext4_dax_mmap_get_block, NULL, true);
 			ext4_journal_stop(handle);
-		up_read(&EXT4_I(inode)->i_mmap_sem);
+		}
+		up_write(&EXT4_I(inode)->i_mmap_sem);
+	}
+
+	if (write)
 		sb_end_pagefault(sb);
-	} else
-		up_read(&EXT4_I(inode)->i_mmap_sem);
 
 	return result;
 }
@@ -238,47 +244,37 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
-		down_read(&EXT4_I(inode)->i_mmap_sem);
+	}
+
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	result = __dax_pmd_fault(vma, addr, pmd, flags,
+			ext4_dax_mmap_get_block, NULL, false);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+
+	if (result == -EAGAIN) {
+		down_write(&EXT4_I(inode)->i_mmap_sem);
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 				ext4_chunk_trans_blocks(inode,
 							PMD_SIZE / PAGE_SIZE));
-	} else
-		down_read(&EXT4_I(inode)->i_mmap_sem);
 
-	if (IS_ERR(handle))
-		result = VM_FAULT_SIGBUS;
-	else
-		result = __dax_pmd_fault(vma, addr, pmd, flags,
-				ext4_dax_mmap_get_block, NULL);
-
-	if (write) {
-		if (!IS_ERR(handle))
+		if (IS_ERR(handle))
+			result = VM_FAULT_SIGBUS;
+		else {
+			result = __dax_pmd_fault(vma, addr, pmd, flags,
+					ext4_dax_mmap_get_block, NULL, true);
 			ext4_journal_stop(handle);
-		up_read(&EXT4_I(inode)->i_mmap_sem);
+		}
+		up_write(&EXT4_I(inode)->i_mmap_sem);
+	}
+
+	if (write)
 		sb_end_pagefault(sb);
-	} else
-		up_read(&EXT4_I(inode)->i_mmap_sem);
 
 	return result;
 }
 
-static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	int err;
-	struct inode *inode = file_inode(vma->vm_file);
-
-	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
-	down_read(&EXT4_I(inode)->i_mmap_sem);
-	err = __dax_mkwrite(vma, vmf, ext4_dax_mmap_get_block, NULL);
-	up_read(&EXT4_I(inode)->i_mmap_sem);
-	sb_end_pagefault(inode->i_sb);
-
-	return err;
-}
-
 /*
- * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_mkwrite()
+ * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_fault()
  * handler we check for races agaist truncate. Note that since we cycle through
  * i_mmap_sem, we are sure that also any hole punching that began before we
  * were called is finished by now and so if it included part of the file we
@@ -311,7 +307,7 @@ static int ext4_dax_pfn_mkwrite(struct vm_area_struct *vma,
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
 	.pmd_fault	= ext4_dax_pmd_fault,
-	.page_mkwrite	= ext4_dax_mkwrite,
+	.page_mkwrite	= ext4_dax_fault,
 	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
 };
 #else
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 55e16e2..81edbd4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1523,16 +1523,26 @@ xfs_filemap_page_mkwrite(
 
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
-	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL);
+		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL,
+				false);
+		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+
+		if (ret == -EAGAIN) {
+			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_EXCL);
+			ret = __dax_mkwrite(vma, vmf,
+					xfs_get_blocks_dax_fault, NULL, true);
+			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_EXCL);
+		}
 	} else {
+		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 		ret = block_page_mkwrite(vma, vmf, xfs_get_blocks);
 		ret = block_page_mkwrite_return(ret);
+		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	}
 
-	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 
 	return ret;
@@ -1560,7 +1570,8 @@ xfs_filemap_fault(
 		 * changes to xfs_get_blocks_direct() to map unwritten extent
 		 * ioend for conversion on read-only mappings.
 		 */
-		ret = __dax_fault(vma, vmf, xfs_get_blocks_dax_fault, NULL);
+		ret = __dax_fault(vma, vmf, xfs_get_blocks_dax_fault, NULL,
+				false);
 	} else
 		ret = filemap_fault(vma, vmf);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
@@ -1598,9 +1609,16 @@ xfs_filemap_pmd_fault(
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
-			      NULL);
+			      NULL, false);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
+	if (ret == -EAGAIN) {
+		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_EXCL);
+		ret = __dax_pmd_fault(vma, addr, pmd, flags,
+				xfs_get_blocks_dax_fault, NULL, true);
+		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_EXCL);
+	}
+
 	if (flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(inode->i_sb);
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 8204c3d..783a2b6 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -13,12 +13,13 @@ int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
 		dax_iodone_t);
 int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
-		dax_iodone_t);
+		dax_iodone_t, bool alloc_ok);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
 				unsigned int flags, get_block_t, dax_iodone_t);
 int __dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
-				unsigned int flags, get_block_t, dax_iodone_t);
+				unsigned int flags, get_block_t, dax_iodone_t,
+				bool alloc_ok);
 #else
 static inline int dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t *pmd, unsigned int flags, get_block_t gb,
@@ -30,7 +31,8 @@ static inline int dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 #endif
 int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
 #define dax_mkwrite(vma, vmf, gb, iod)		dax_fault(vma, vmf, gb, iod)
-#define __dax_mkwrite(vma, vmf, gb, iod)	__dax_fault(vma, vmf, gb, iod)
+#define __dax_mkwrite(vma, vmf, gb, iod, alloc)  \
+	__dax_fault(vma, vmf, gb, iod, alloc)
 
 static inline bool vma_is_dax(struct vm_area_struct *vma)
 {
-- 
2.5.0

