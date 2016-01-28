Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] block: fix pfn_mkwrite() DAX fault handler
Date: Thu, 28 Jan 2016 12:35:03 -0700
Message-Id: <1454009704-25959-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Previously the pfn_mkwrite() fault handler for raw block devices called
bldev_dax_fault() -> __dax_fault() to do a full DAX page fault.  Really
what the pfn_mkwrite() fault handler needs to do is call dax_pfn_mkwrite()
to make sure that the radix tree entry for the given PTE is marked as dirty
so that a follow-up fsync or msync call will flush it durably to media.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: 5a023cdba50c ("block: enable dax for raw block devices")
---
 fs/block_dev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7b9cd49..fa0507a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1730,6 +1730,12 @@ static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
 }
 
+static int blkdev_dax_pfn_mkwrite(struct vm_area_struct *vma,
+		struct vm_fault *vmf)
+{
+	return dax_pfn_mkwrite(vma, vmf);
+}
+
 static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, unsigned int flags)
 {
@@ -1761,7 +1767,7 @@ static const struct vm_operations_struct blkdev_dax_vm_ops = {
 	.close		= blkdev_vm_close,
 	.fault		= blkdev_dax_fault,
 	.pmd_fault	= blkdev_dax_pmd_fault,
-	.pfn_mkwrite	= blkdev_dax_fault,
+	.pfn_mkwrite	= blkdev_dax_pfn_mkwrite,
 };
 
 static const struct vm_operations_struct blkdev_default_vm_ops = {
-- 
2.5.0

