Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D31651A1E34
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 13:48:17 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 04/11] ext2: remove support for DAX PMD faults
Date: Tue, 27 Sep 2016 14:47:55 -0600
Message-Id: <1475009282-9818-5-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

DAX PMD support was added via the following commit:

commit e7b1ea2ad658 ("ext2: huge page fault support")

I believe this path to be untested as ext2 doesn't reliably provide block
allocations that are aligned to 2MiB.  In my testing I've been unable to
get ext2 to actually fault in a PMD.  It always fails with a "pfn
unaligned" message because the sector returned by ext2_get_block() isn't
aligned.

I've tried various settings for the "stride" and "stripe_width" extended
options to mkfs.ext2, without any luck.

Since we can't reliably get PMDs, remove support so that we don't have an
untested code path that we may someday traverse when we happen to get an
aligned block allocation.  This should also make 4k DAX faults in ext2 a
bit faster since they will no longer have to call the PMD fault handler
only to get a response of VM_FAULT_FALLBACK.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext2/file.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 0ca363d..d5af6d2 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -107,27 +107,6 @@ static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return ret;
 }
 
-static int ext2_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
-						pmd_t *pmd, unsigned int flags)
-{
-	struct inode *inode = file_inode(vma->vm_file);
-	struct ext2_inode_info *ei = EXT2_I(inode);
-	int ret;
-
-	if (flags & FAULT_FLAG_WRITE) {
-		sb_start_pagefault(inode->i_sb);
-		file_update_time(vma->vm_file);
-	}
-	down_read(&ei->dax_sem);
-
-	ret = dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block);
-
-	up_read(&ei->dax_sem);
-	if (flags & FAULT_FLAG_WRITE)
-		sb_end_pagefault(inode->i_sb);
-	return ret;
-}
-
 static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 		struct vm_fault *vmf)
 {
@@ -154,7 +133,6 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
-	.pmd_fault	= ext2_dax_pmd_fault,
 	.page_mkwrite	= ext2_dax_fault,
 	.pfn_mkwrite	= ext2_dax_pfn_mkwrite,
 };
@@ -166,7 +144,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &ext2_dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_MIXEDMAP;
 	return 0;
 }
 #else
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
