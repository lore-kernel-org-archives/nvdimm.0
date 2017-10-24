Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C3822035261C
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 08:21:47 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 16/17] ext4: Support for synchronous DAX faults
Date: Tue, 24 Oct 2017 17:24:13 +0200
Message-Id: <20171024152415.22864-17-jack@suse.cz>
In-Reply-To: <20171024152415.22864-1-jack@suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We return IOMAP_F_DIRTY flag from ext4_iomap_begin() when asked to
prepare blocks for writing and the inode has some uncommitted metadata
changes. In the fault handler ext4_dax_fault() we then detect this case
(through VM_FAULT_NEEDDSYNC return value) and call helper
dax_finish_sync_fault() to flush metadata changes and insert page table
entry. Note that this will also dirty corresponding radix tree entry
which is what we want - fsync(2) will still provide data integrity
guarantees for applications not using userspace flushing. And
applications using userspace flushing can avoid calling fsync(2) and
thus avoid the performance overhead.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c       | 15 ++++++++++++++-
 fs/ext4/inode.c      | 15 +++++++++++++++
 fs/jbd2/journal.c    | 17 +++++++++++++++++
 include/linux/jbd2.h |  1 +
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 208adfc3e673..08a1d1a33a90 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -26,6 +26,7 @@
 #include <linux/quotaops.h>
 #include <linux/pagevec.h>
 #include <linux/uio.h>
+#include <linux/mman.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -295,6 +296,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	 */
 	bool write = (vmf->flags & FAULT_FLAG_WRITE) &&
 		(vmf->vma->vm_flags & VM_SHARED);
+	pfn_t pfn;
 
 	if (write) {
 		sb_start_pagefault(sb);
@@ -310,9 +312,12 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	} else {
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	result = dax_iomap_fault(vmf, pe_size, NULL, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, pe_size, &pfn, &ext4_iomap_ops);
 	if (write) {
 		ext4_journal_stop(handle);
+		/* Handling synchronous page fault? */
+		if (result & VM_FAULT_NEEDDSYNC)
+			result = dax_finish_sync_fault(vmf, pe_size, pfn);
 		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
 	} else {
@@ -350,6 +355,13 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
+	/*
+	 * We don't support synchronous mappings for non-DAX files. At least
+	 * until someone comes with a sensible use case.
+	 */
+	if (!IS_DAX(file_inode(file)) && (vma->vm_flags & VM_SYNC))
+		return -EOPNOTSUPP;
+
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
@@ -719,6 +731,7 @@ const struct file_operations ext4_file_operations = {
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
 	.mmap		= ext4_file_mmap,
+	.mmap_supported_flags = MAP_SYNC,
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 31db875bc7a1..13a198924a0f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3394,6 +3394,19 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 }
 
 #ifdef CONFIG_FS_DAX
+static bool ext4_inode_datasync_dirty(struct inode *inode)
+{
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+
+	if (journal)
+		return !jbd2_transaction_committed(journal,
+					EXT4_I(inode)->i_datasync_tid);
+	/* Any metadata buffers to write? */
+	if (!list_empty(&inode->i_mapping->private_list))
+		return true;
+	return inode->i_state & I_DIRTY_DATASYNC;
+}
+
 static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			    unsigned flags, struct iomap *iomap)
 {
@@ -3466,6 +3479,8 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	}
 
 	iomap->flags = 0;
+	if ((flags & IOMAP_WRITE) && ext4_inode_datasync_dirty(inode))
+		iomap->flags |= IOMAP_F_DIRTY;
 	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->dax_dev = sbi->s_daxdev;
 	iomap->offset = first_block << blkbits;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7d5ef3bf3f3e..fa8cde498b4b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -738,6 +738,23 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 	return err;
 }
 
+/* Return 1 when transaction with given tid has already committed. */
+int jbd2_transaction_committed(journal_t *journal, tid_t tid)
+{
+	int ret = 1;
+
+	read_lock(&journal->j_state_lock);
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == tid)
+		ret = 0;
+	if (journal->j_committing_transaction &&
+	    journal->j_committing_transaction->t_tid == tid)
+		ret = 0;
+	read_unlock(&journal->j_state_lock);
+	return ret;
+}
+EXPORT_SYMBOL(jbd2_transaction_committed);
+
 /*
  * When this function returns the transaction corresponding to tid
  * will be completed.  If the transaction has currently running, start
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 606b6bce3a5b..296d1e0ea87b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1367,6 +1367,7 @@ int jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
+int jbd2_transaction_committed(journal_t *journal, tid_t tid);
 int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
 int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
