Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F00482095B9ED
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:02 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/13] dax: Allow dax_iomap_fault() to return pfn
Date: Thu, 17 Aug 2017 18:08:11 +0200
Message-Id: <20170817160815.30466-10-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For synchronous page fault dax_iomap_fault() will need to return PFN
which will then need to inserted into page tables after fsync()
completes. Add necessary parameter to dax_iomap_fault().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 13 +++++++------
 fs/ext2/file.c      |  2 +-
 fs/ext4/file.c      |  2 +-
 fs/xfs/xfs_file.c   |  8 ++++----
 include/linux/dax.h |  2 +-
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 85ea49bbbdbf..bc040e654cc9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1069,7 +1069,7 @@ static int dax_fault_return(int error)
 }
 
 static int dax_iomap_pte_fault(struct vm_fault *vmf,
-			       const struct iomap_ops *ops)
+			       const struct iomap_ops *ops, pfn_t *pfnp)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping = vma->vm_file->f_mapping;
@@ -1270,7 +1270,7 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 }
 
 static int dax_iomap_pmd_fault(struct vm_fault *vmf,
-			       const struct iomap_ops *ops)
+			       const struct iomap_ops *ops, pfn_t *pfnp)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping = vma->vm_file->f_mapping;
@@ -1405,7 +1405,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 }
 #else
 static int dax_iomap_pmd_fault(struct vm_fault *vmf,
-			       const struct iomap_ops *ops)
+			       const struct iomap_ops *ops, pfn_t *pfnp)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -1416,6 +1416,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
  * @vmf: The description of the fault
  * @pe_size: Size of the page to fault in
  * @ops: Iomap ops passed from the file system
+ * @pfnp: PFN to insert for synchronous faults if fsync is required
  *
  * When a page fault occurs, filesystems may call this helper in
  * their fault handler for DAX files. dax_iomap_fault() assumes the caller
@@ -1423,13 +1424,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
  * successfully.
  */
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
-		    const struct iomap_ops *ops)
+		    const struct iomap_ops *ops, pfn_t *pfnp)
 {
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		return dax_iomap_pte_fault(vmf, ops);
+		return dax_iomap_pte_fault(vmf, ops, pfnp);
 	case PE_SIZE_PMD:
-		return dax_iomap_pmd_fault(vmf, ops);
+		return dax_iomap_pmd_fault(vmf, ops, pfnp);
 	default:
 		return VM_FAULT_FALLBACK;
 	}
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index ff3a3636a5ca..689f17b5f444 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -99,7 +99,7 @@ static int ext2_dax_fault(struct vm_fault *vmf)
 	}
 	down_read(&ei->dax_sem);
 
-	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &ext2_iomap_ops);
+	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &ext2_iomap_ops, NULL);
 
 	up_read(&ei->dax_sem);
 	if (vmf->flags & FAULT_FLAG_WRITE)
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 9dda70edba74..f84bb29e941e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -291,7 +291,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
 	if (!IS_ERR(handle))
-		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops);
+		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, NULL);
 	else
 		result = VM_FAULT_SIGBUS;
 	if (write) {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 62db8ffa83b9..c17ca982272c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1032,7 +1032,7 @@ xfs_filemap_page_mkwrite(
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops, NULL);
 	} else {
 		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
 		ret = block_page_mkwrite_return(ret);
@@ -1059,7 +1059,7 @@ xfs_filemap_fault(
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	if (IS_DAX(inode))
-		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops, NULL);
 	else
 		ret = filemap_fault(vmf);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
@@ -1094,7 +1094,7 @@ xfs_filemap_huge_fault(
 	}
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = dax_iomap_fault(vmf, pe_size, &xfs_iomap_ops);
+	ret = dax_iomap_fault(vmf, pe_size, &xfs_iomap_ops, NULL);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (vmf->flags & FAULT_FLAG_WRITE)
@@ -1130,7 +1130,7 @@ xfs_filemap_pfn_mkwrite(
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
 	else if (IS_DAX(inode))
-		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops, NULL);
 	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d0e32729ad1e..8f493d9879f7 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -91,7 +91,7 @@ void dax_write_cache(struct dax_device *dax_dev, bool wc);
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
-		    const struct iomap_ops *ops);
+		    const struct iomap_ops *ops, pfn_t *pfnp);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
