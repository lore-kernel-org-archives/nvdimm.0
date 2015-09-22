Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2] dax: fix NULL pointer in __dax_pmd_fault()
Date: Tue, 22 Sep 2015 13:36:22 -0600
Message-Id: <1442950582-10140-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

The following commit:

commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for
	DAX")

moved some code in __dax_pmd_fault() that was responsible for zeroing
newly allocated PMD pages.  The new location didn't properly set up
'kaddr', though, so when run this code resulted in a NULL pointer BUG.

Fix this by getting the correct 'kaddr' via bdev_direct_access().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7ae6df7..bcfb14b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -569,8 +569,20 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
 		goto fallback;
 
+	sector = bh.b_blocknr << (blkbits - 9);
+
 	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
 		int i;
+
+		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
+						bh.b_size);
+		if (length < 0) {
+			result = VM_FAULT_SIGBUS;
+			goto out;
+		}
+		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
+			goto fallback;
+
 		for (i = 0; i < PTRS_PER_PMD; i++)
 			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
 		wmb_pmem();
@@ -623,7 +635,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		result = VM_FAULT_NOPAGE;
 		spin_unlock(ptl);
 	} else {
-		sector = bh.b_blocknr << (blkbits - 9);
 		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
 						bh.b_size);
 		if (length < 0) {
-- 
2.1.0

