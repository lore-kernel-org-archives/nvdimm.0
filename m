Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] Revert "mm: take i_mmap_lock in unmap_mapping_range() for DAX"
Date: Thu,  1 Oct 2015 17:46:33 +1000
Message-Id: <1443685599-4843-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1443685599-4843-1-git-send-email-david@fromorbit.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This reverts commit 46c043ede4711e8d598b9d63c5616c1fedb0605e.
---
 fs/dax.c    | 36 ++++++++++++++++--------------------
 mm/memory.c | 11 +++++++++--
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7ae6df7..400fe95 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -569,26 +569,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
 		goto fallback;
 
-	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-		int i;
-		for (i = 0; i < PTRS_PER_PMD; i++)
-			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
-		wmb_pmem();
-		count_vm_event(PGMAJFAULT);
-		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-		result |= VM_FAULT_MAJOR;
-	}
-
-	/*
-	 * If we allocated new storage, make sure no process has any
-	 * zero pages covering this hole
-	 */
-	if (buffer_new(&bh)) {
-		i_mmap_unlock_write(mapping);
-		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
-		i_mmap_lock_write(mapping);
-	}
-
 	/*
 	 * If a truncate happened while we were allocating blocks, we may
 	 * leave blocks allocated to the file that are beyond EOF.  We can't
@@ -603,6 +583,13 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	if ((pgoff | PG_PMD_COLOUR) >= size)
 		goto fallback;
 
+	/*
+	 * If we allocated new storage, make sure no process has any
+	 * zero pages covering this hole
+	 */
+	if (buffer_new(&bh))
+		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
+
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
@@ -633,6 +620,15 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
 			goto fallback;
 
+		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
+			int i;
+			for (i = 0; i < PTRS_PER_PMD; i++)
+				clear_page(kaddr + i * PAGE_SIZE);
+			count_vm_event(PGMAJFAULT);
+			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+			result |= VM_FAULT_MAJOR;
+		}
+
 		result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index 9cb2747..5ec066f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2426,10 +2426,17 @@ void unmap_mapping_range(struct address_space *mapping,
 	if (details.last_index < details.first_index)
 		details.last_index = ULONG_MAX;
 
-	i_mmap_lock_write(mapping);
+
+	/*
+	 * DAX already holds i_mmap_lock to serialise file truncate vs
+	 * page fault and page fault vs page fault.
+	 */
+	if (!IS_DAX(mapping->host))
+		i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	i_mmap_unlock_write(mapping);
+	if (!IS_DAX(mapping->host))
+		i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-- 
2.5.0

