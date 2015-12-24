Return-Path: <owner-linux-mm@kvack.org>
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 6/8] block_dev: Support PUD DAX mappings
Date: Thu, 24 Dec 2015 11:20:35 -0500
Message-Id: <1450974037-24775-7-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1450974037-24775-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1450974037-24775-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <willy@linux.intel.com>

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/block_dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2d9137e..ed73fdf 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1739,6 +1739,12 @@ static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL);
 }
 
+static int blkdev_dax_pud_fault(struct vm_area_struct *vma, unsigned long addr,
+		pud_t *pud, unsigned int flags)
+{
+	return __dax_pud_fault(vma, addr, pud, flags, blkdev_get_block, NULL);
+}
+
 static void blkdev_vm_open(struct vm_area_struct *vma)
 {
 	struct inode *bd_inode = bdev_file_inode(vma->vm_file);
@@ -1764,6 +1770,7 @@ static const struct vm_operations_struct blkdev_dax_vm_ops = {
 	.close		= blkdev_vm_close,
 	.fault		= blkdev_dax_fault,
 	.pmd_fault	= blkdev_dax_pmd_fault,
+	.pud_fault	= blkdev_dax_pud_fault,
 	.pfn_mkwrite	= blkdev_dax_fault,
 };
 
-- 
2.6.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
