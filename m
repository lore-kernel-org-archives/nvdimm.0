Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 719F92095B9E7
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 08:19:45 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: consolidate the various page fault handlers
Date: Thu, 24 Aug 2017 17:22:06 +0200
Message-Id: <20170824152207.30729-3-hch@lst.de>
In-Reply-To: <20170824152207.30729-1-hch@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a new __xfs_filemap_fault helper that implements all four page fault
callouts, and make these methods themselves small stubs that set the
correct write_fault flag, and exit early for the non-DAX case for the
hugepage related ones.

Life would be so much simpler if we only had one method for all this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 120 +++++++++++++++--------------------------------------
 fs/xfs/xfs_trace.h |  24 +++++++++--
 2 files changed, 54 insertions(+), 90 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4213f02325a2..460ca9639e66 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1012,34 +1012,36 @@ xfs_file_llseek(
  *         i_lock (XFS - extent map serialisation)
  */
 
-/*
- * mmap()d file has taken write protection fault and is being made writable. We
- * can set the page state up correctly for a writable page, which means we can
- * do correct delalloc accounting (ENOSPC checking!) and unwritten extent
- * mapping.
- */
 STATIC int
-xfs_filemap_page_mkwrite(
-	struct vm_fault		*vmf)
+__xfs_filemap_fault(
+	struct vm_fault		*vmf,
+	enum page_entry_size	pe_size,
+	bool			write_fault)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
+	struct xfs_inode	*ip = XFS_I(inode);
 	int			ret;
 
-	trace_xfs_filemap_page_mkwrite(XFS_I(inode));
+	trace_xfs_filemap_fault(ip, pe_size, write_fault);
 
-	sb_start_pagefault(inode->i_sb);
-	file_update_time(vmf->vma->vm_file);
-	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	if (write_fault) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vmf->vma->vm_file);
+	}
 
+	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	if (IS_DAX(inode)) {
-		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, pe_size, NULL, &xfs_iomap_ops);
 	} else {
-		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
+		if (write_fault)
+			ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
+		else
+			ret = filemap_fault(vmf);
 	}
-
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	sb_end_pagefault(inode->i_sb);
 
+	if (write_fault)
+		sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 
@@ -1047,93 +1049,39 @@ STATIC int
 xfs_filemap_fault(
 	struct vm_fault		*vmf)
 {
-	struct inode		*inode = file_inode(vmf->vma->vm_file);
-	int			ret;
-
-	trace_xfs_filemap_fault(XFS_I(inode));
-
 	/* DAX can shortcut the normal fault path on write faults! */
-	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
-		return xfs_filemap_page_mkwrite(vmf);
-
-	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	if (IS_DAX(inode))
-		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &xfs_iomap_ops);
-	else
-		ret = filemap_fault(vmf);
-	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-
-	return ret;
+	return __xfs_filemap_fault(vmf, PE_SIZE_PTE,
+			IS_DAX(file_inode(vmf->vma->vm_file)) &&
+			(vmf->flags & FAULT_FLAG_WRITE));
 }
 
-/*
- * Similar to xfs_filemap_fault(), the DAX fault path can call into here on
- * both read and write faults. Hence we need to handle both cases. There is no
- * ->huge_mkwrite callout for huge pages, so we have a single function here to
- * handle both cases here. @flags carries the information on the type of fault
- * occuring.
- */
 STATIC int
 xfs_filemap_huge_fault(
 	struct vm_fault		*vmf,
 	enum page_entry_size	pe_size)
 {
-	struct inode		*inode = file_inode(vmf->vma->vm_file);
-	struct xfs_inode	*ip = XFS_I(inode);
-	int			ret;
-
-	if (!IS_DAX(inode))
+	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
 		return VM_FAULT_FALLBACK;
 
-	trace_xfs_filemap_huge_fault(ip);
-
-	if (vmf->flags & FAULT_FLAG_WRITE) {
-		sb_start_pagefault(inode->i_sb);
-		file_update_time(vmf->vma->vm_file);
-	}
-
-	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = dax_iomap_fault(vmf, pe_size, NULL, &xfs_iomap_ops);
-	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-
-	if (vmf->flags & FAULT_FLAG_WRITE)
-		sb_end_pagefault(inode->i_sb);
+	/* DAX can shortcut the normal fault path on write faults! */
+	return __xfs_filemap_fault(vmf, pe_size,
+			(vmf->flags & FAULT_FLAG_WRITE));
+}
 
-	return ret;
+STATIC int
+xfs_filemap_page_mkwrite(
+	struct vm_fault		*vmf)
+{
+	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
 }
 
-/*
- * pfn_mkwrite was originally inteneded to ensure we capture time stamp
- * updates on write faults. In reality, it's need to serialise against
- * truncate similar to page_mkwrite. Hence we cycle the XFS_MMAPLOCK_SHARED
- * to ensure we serialise the fault barrier in place.
- */
 static int
 xfs_filemap_pfn_mkwrite(
 	struct vm_fault		*vmf)
 {
-
-	struct inode		*inode = file_inode(vmf->vma->vm_file);
-	struct xfs_inode	*ip = XFS_I(inode);
-	int			ret = VM_FAULT_NOPAGE;
-	loff_t			size;
-
-	trace_xfs_filemap_pfn_mkwrite(ip);
-
-	sb_start_pagefault(inode->i_sb);
-	file_update_time(vmf->vma->vm_file);
-
-	/* check if the faulting page hasn't raced with truncate */
-	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (vmf->pgoff >= size)
-		ret = VM_FAULT_SIGBUS;
-	else if (IS_DAX(inode))
-		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &xfs_iomap_ops);
-	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
-	sb_end_pagefault(inode->i_sb);
-	return ret;
-
+	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
+		return VM_FAULT_NOPAGE;
+	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
 }
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bcc3cdf8e1c5..3f41d5340eb8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -689,10 +689,26 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
 
-DEFINE_INODE_EVENT(xfs_filemap_fault);
-DEFINE_INODE_EVENT(xfs_filemap_huge_fault);
-DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
-DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
+TRACE_EVENT(xfs_filemap_fault,
+	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
+		 bool write_fault),
+	TP_ARGS(ip, pe_size, write_fault),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(enum page_entry_size, pe_size)
+		__field(bool, write_fault)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->pe_size = pe_size;
+		__entry->write_fault = write_fault;
+	),
+	TP_printk("dev %d:%d ino 0x%llx pe_size %d write_fault %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->pe_size, __entry->write_fault)
+)
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
