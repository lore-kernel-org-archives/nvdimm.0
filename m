Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 1/2] dax: dax_pfn_mkwrite() truncate race check
Date: Tue, 13 Oct 2015 16:25:36 -0600
Message-Id: <1444775137-23685-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Update dax_pfn_mkwrite() so that it validates i_size before returning.
This is necessary to ensure that the page fault has not raced with truncate
and is now pointing to a region beyond the end of the current file.

This change is based on a similar outstanding patch for XFS from Dave
Chinner entitled "xfs: add ->pfn_mkwrite support for DAX".

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
---
 fs/dax.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 131fd35a..82be6e4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -693,12 +693,21 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
  */
 int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+	struct inode *inode = file_inode(vma->vm_file);
+	struct super_block *sb = inode->i_sb;
+	int ret = VM_FAULT_NOPAGE;
+	loff_t size;
 
 	sb_start_pagefault(sb);
 	file_update_time(vma->vm_file);
+
+	/* check that the faulting page hasn't raced with truncate */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		ret = VM_FAULT_SIGBUS;
+
 	sb_end_pagefault(sb);
-	return VM_FAULT_NOPAGE;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
-- 
2.1.0

