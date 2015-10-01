Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs: DAX does not use IO completion callbacks
Date: Thu,  1 Oct 2015 17:46:38 +1000
Message-Id: <1443685599-4843-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1443685599-4843-1-git-send-email-david@fromorbit.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dave Chinner <dchinner@redhat.com>

For DAX, we are now doing block zeroing and
we are updating the file size during allocation. This means we no
longer need an IO completion callback to do these things, so remove
the completion callbacks from the __dax_fault and __dax_mkwrite
calls.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 39 ---------------------------------------
 fs/xfs/xfs_aops.h |  1 -
 fs/xfs/xfs_file.c |  5 ++---
 3 files changed, 2 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index df3dabd..69c2dbc 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1657,45 +1657,6 @@ xfs_end_io_direct_write(
 	__xfs_end_io_direct_write(inode, ioend, offset, size);
 }
 
-/*
- * For DAX we need a mapping buffer callback for unwritten extent conversion
- * when page faults allocate blocks and then zero them. Note that in this
- * case the mapping indicated by the ioend may extend beyond EOF. We most
- * definitely do not want to extend EOF here, so we trim back the ioend size to
- * EOF.
- */
-#ifdef CONFIG_FS_DAX
-void
-xfs_end_io_dax_write(
-	struct buffer_head	*bh,
-	int			uptodate)
-{
-	struct xfs_ioend	*ioend = bh->b_private;
-	struct inode		*inode = ioend->io_inode;
-	ssize_t			size = ioend->io_size;
-
-	ASSERT(IS_DAX(ioend->io_inode));
-
-	/* if there was an error zeroing, then don't convert it */
-	if (!uptodate)
-		ioend->io_error = -EIO;
-
-	/*
-	 * Trim update to EOF, so we don't extend EOF during unwritten extent
-	 * conversion of partial EOF blocks.
-	 */
-	spin_lock(&XFS_I(inode)->i_flags_lock);
-	if (ioend->io_offset + size > i_size_read(inode))
-		size = i_size_read(inode) - ioend->io_offset;
-	spin_unlock(&XFS_I(inode)->i_flags_lock);
-
-	__xfs_end_io_direct_write(inode, ioend, ioend->io_offset, size);
-
-}
-#else
-void xfs_end_io_dax_write(struct buffer_head *bh, int uptodate) { }
-#endif
-
 static inline ssize_t
 xfs_vm_do_dio(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index d39ba25..f6ffc9a 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -60,7 +60,6 @@ int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
 			      struct buffer_head *map_bh, int create);
 int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
 			         struct buffer_head *map_bh, int create);
-void	xfs_end_io_dax_write(struct buffer_head *bh, int uptodate);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 27abe1c..9c8eef7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1503,8 +1503,7 @@ xfs_filemap_page_mkwrite(
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault,
-				    xfs_end_io_dax_write);
+		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL);
 	} else {
 		ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
 		ret = block_page_mkwrite_return(ret);
@@ -1566,7 +1565,7 @@ xfs_filemap_pmd_fault(
 	file_update_time(vma->vm_file);
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
-				    xfs_end_io_dax_write);
+			      NULL);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 
-- 
2.5.0

