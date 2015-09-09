Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: update PMD fault handler with PMEM API
Date: Wed,  9 Sep 2015 10:29:40 -0600
Message-Id: <1441816180-30008-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, "Kirill A. Shutemov" <kirill@shutemov.name>
List-ID: <linux-nvdimm@lists.01.org>

As part of the v4.3 merge window the DAX code was updated by Matthew and
Kirill to handle PMD pages.  Also as part of the v4.3 merge window we
updated the DAX code to do proper PMEM flushing:

2765cfbb342c ("dax: update I/O path to do proper PMEM flushing")

The additional code added by the DAX PMD patches also needs to be
updated to properly use the PMEM API.  This ensures that after a PMD
fault is handled the zeros written to the newly allocated pages are
durable on the DIMMs.

linux/dax.h is included to get rid of a bunch of sparse warnings.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
Linus, would you consider applying this to the v4.3 merge tree?
---
 fs/dax.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e43389c..93bf2f9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -17,6 +17,7 @@
 #include <linux/atomic.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/highmem.h>
@@ -527,7 +528,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	unsigned long pmd_addr = address & PMD_MASK;
 	bool write = flags & FAULT_FLAG_WRITE;
 	long length;
-	void *kaddr;
+	void __pmem *kaddr;
 	pgoff_t size, pgoff;
 	sector_t block, sector;
 	unsigned long pfn;
@@ -570,7 +571,8 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
 		int i;
 		for (i = 0; i < PTRS_PER_PMD; i++)
-			clear_page(kaddr + i * PAGE_SIZE);
+			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
+		wmb_pmem();
 		count_vm_event(PGMAJFAULT);
 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 		result |= VM_FAULT_MAJOR;
-- 
2.1.0

