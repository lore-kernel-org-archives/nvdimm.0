Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: add ->pfn_mkwrite support for DAX
Date: Thu,  1 Oct 2015 17:46:39 +1000
Message-Id: <1443685599-4843-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1443685599-4843-1-git-send-email-david@fromorbit.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dave Chinner <dchinner@redhat.com>

->pfn_mkwrite support is needed so that when a page with allocated
backing store takes a write fault we can check that the fault has
not raced with a truncate and is pointing to a region beyond the
current end of file.

This also allows us to update the timestamp on the inode, too, which
fixes a generic/080 failure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 35 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 36 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9c8eef7..f429662 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1572,11 +1572,46 @@ xfs_filemap_pmd_fault(
 	return ret;
 }
 
+/*
+ * pfn_mkwrite was originally inteneded to ensure we capture time stamp
+ * updates on write faults. In reality, it's need to serialise against
+ * truncate similar to page_mkwrite. Hence we open-code dax_pfn_mkwrite()
+ * here and cycle the XFS_MMAPLOCK_SHARED to ensure we serialise the fault
+ * barrier in place.
+ */
+static int
+xfs_filemap_pfn_mkwrite(
+	struct vm_area_struct	*vma,
+	struct vm_fault		*vmf)
+{
+
+	struct inode		*inode = file_inode(vma->vm_file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			ret = VM_FAULT_NOPAGE;
+	loff_t			size;
+
+	trace_xfs_filemap_pfn_mkwrite(ip);
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
+
+	/* check if the faulting page hasn't raced with truncate */
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		ret = VM_FAULT_SIGBUS;
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+	sb_end_pagefault(inode->i_sb);
+	return ret;
+
+}
+
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.pmd_fault	= xfs_filemap_pmd_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
+	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
 };
 
 STATIC int
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5ed36b1..c53beda 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -689,6 +689,7 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 DEFINE_INODE_EVENT(xfs_filemap_fault);
 DEFINE_INODE_EVENT(xfs_filemap_pmd_fault);
 DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
+DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
-- 
2.5.0

