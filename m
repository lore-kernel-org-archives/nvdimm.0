Return-Path: <owner-linux-mm@kvack.org>
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 3/6] dax: Use vmf->pgoff in fault handlers
Date: Sun, 31 Jan 2016 23:19:52 +1100
Message-Id: <1454242795-18038-4-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1454242795-18038-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1454242795-18038-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, willy@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Now that the PMD and PUD fault handlers are passed pgoff, there's no
need to calculate it themselves.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/dax.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 696ff90..d0e1334 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -709,7 +709,7 @@ static int dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	unsigned long pmd_addr = address & PMD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
-	pgoff_t size, pgoff;
+	pgoff_t size;
 	sector_t block;
 	int error, result = 0;
 	bool alloc = false;
@@ -734,12 +734,11 @@ static int dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		return VM_FAULT_FALLBACK;
 	}
 
-	pgoff = linear_page_index(vma, pmd_addr);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size)
+	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PMD would cover blocks out of the file */
-	if ((pgoff | PG_PMD_COLOUR) >= size) {
+	if ((vmf->pgoff | PG_PMD_COLOUR) >= size) {
 		dax_pmd_dbg(NULL, address,
 				"offset + huge page size > file size");
 		return VM_FAULT_FALLBACK;
@@ -747,7 +746,7 @@ static int dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
 
@@ -777,7 +776,7 @@ static int dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
 		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
 
 		truncate_pagecache_range(inode, lstart, lend);
@@ -863,8 +862,8 @@ static int dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		 * the write to insert a dirty entry.
 		 */
 		if (write) {
-			error = dax_radix_entry(mapping, pgoff, dax.sector,
-					true, true);
+			error = dax_radix_entry(mapping, vmf->pgoff,
+						dax.sector, true, true);
 			if (error) {
 				dax_pmd_dbg(&bh, address,
 						"PMD radix insertion failed");
@@ -921,7 +920,7 @@ static int dax_pud_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	unsigned long pud_addr = address & PUD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
-	pgoff_t size, pgoff;
+	pgoff_t size;
 	sector_t block;
 	int result = 0;
 	bool alloc = false;
@@ -946,12 +945,11 @@ static int dax_pud_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		return VM_FAULT_FALLBACK;
 	}
 
-	pgoff = linear_page_index(vma, pud_addr);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size)
+	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PUD would cover blocks out of the file */
-	if ((pgoff | PG_PUD_COLOUR) >= size) {
+	if ((vmf->pgoff | PG_PUD_COLOUR) >= size) {
 		dax_pud_dbg(NULL, address,
 				"offset + huge page size > file size");
 		return VM_FAULT_FALLBACK;
@@ -959,7 +957,7 @@ static int dax_pud_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PUD_SIZE;
 
@@ -989,7 +987,7 @@ static int dax_pud_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	 * zero pages covering this hole
 	 */
 	if (alloc) {
-		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lstart = vmf->pgoff << PAGE_SHIFT;
 		loff_t lend = lstart + PUD_SIZE - 1; /* inclusive */
 
 		truncate_pagecache_range(inode, lstart, lend);
-- 
2.7.0.rc3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
