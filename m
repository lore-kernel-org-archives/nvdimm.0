Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CBFE222A54DD
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jan 2018 02:03:50 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] dax: Pass detailed error code from dax_iomap_fault()
Date: Wed,  3 Jan 2018 11:08:43 +0100
Message-Id: <20180103100844.12787-2-jack@suse.cz>
In-Reply-To: <20180103100844.12787-1-jack@suse.cz>
References: <20180103100844.12787-1-jack@suse.cz>
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
To: Ted Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Ext4 needs to pass through error from its iomap handler to the page
fault handler so that it can properly detect ENOSPC and force
transaction commit and retry the fault (and block allocation). Add
argument to dax_iomap_fault() for passing such error.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 9 ++++++---
 fs/ext2/file.c      | 2 +-
 fs/ext4/file.c      | 2 +-
 fs/xfs/xfs_file.c   | 2 +-
 include/linux/dax.h | 2 +-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 95981591977a..f3afa1d6156c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1096,7 +1096,7 @@ static bool dax_fault_is_synchronous(unsigned long flags,
 }
 
 static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
-			       const struct iomap_ops *ops)
+			       int *iomap_errp, const struct iomap_ops *ops)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping = vma->vm_file->f_mapping;
@@ -1149,6 +1149,8 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * that we never have to deal with more than a single extent here.
 	 */
 	error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
+	if (iomap_errp)
+		*iomap_errp = error;
 	if (error) {
 		vmf_ret = dax_fault_return(error);
 		goto unlock_entry;
@@ -1488,6 +1490,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
  * @vmf: The description of the fault
  * @pe_size: Size of the page to fault in
  * @pfnp: PFN to insert for synchronous faults if fsync is required
+ * @iomap_errp: Storage for detailed error code in case of error
  * @ops: Iomap ops passed from the file system
  *
  * When a page fault occurs, filesystems may call this helper in
@@ -1496,11 +1499,11 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
  * successfully.
  */
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
-		    pfn_t *pfnp, const struct iomap_ops *ops)
+		    pfn_t *pfnp, int *iomap_errp, const struct iomap_ops *ops)
 {
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		return dax_iomap_pte_fault(vmf, pfnp, ops);
+		return dax_iomap_pte_fault(vmf, pfnp, iomap_errp, ops);
 	case PE_SIZE_PMD:
 		return dax_iomap_pmd_fault(vmf, pfnp, ops);
 	default:
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 2da67699dc33..09640220fda8 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -100,7 +100,7 @@ static int ext2_dax_fault(struct vm_fault *vmf)
 	}
 	down_read(&ei->dax_sem);
 
-	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &ext2_iomap_ops);
+	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, NULL, &ext2_iomap_ops);
 
 	up_read(&ei->dax_sem);
 	if (vmf->flags & FAULT_FLAG_WRITE)
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a0ae27b1bc66..1c7cd882d998 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -314,7 +314,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	} else {
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	result = dax_iomap_fault(vmf, pe_size, &pfn, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &ext4_iomap_ops);
 	if (write) {
 		ext4_journal_stop(handle);
 		/* Handling synchronous page fault? */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8601275cc5e6..9ea08326f876 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1048,7 +1048,7 @@ __xfs_filemap_fault(
 	if (IS_DAX(inode)) {
 		pfn_t pfn;
 
-		ret = dax_iomap_fault(vmf, pe_size, &pfn, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &xfs_iomap_ops);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
 	} else {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5258346c558c..0185ecdae135 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -96,7 +96,7 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev);
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
-		    pfn_t *pfnp, const struct iomap_ops *ops);
+		    pfn_t *pfnp, int *errp, const struct iomap_ops *ops);
 int dax_finish_sync_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 			  pfn_t pfn);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
