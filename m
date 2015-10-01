Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] Revert "dax: fix race between simultaneous faults"
Date: Thu,  1 Oct 2015 17:46:34 +1000
Message-Id: <1443685599-4843-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1443685599-4843-1-git-send-email-david@fromorbit.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This reverts commit 843172978bb92997310d2f7fbc172ece423cfc02.
---
 fs/dax.c    | 33 ++++++++++++++++-----------------
 mm/memory.c | 11 +++--------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 400fe95..3994a2b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -285,6 +285,7 @@ static int copy_user_bh(struct page *to, struct buffer_head *bh,
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct address_space *mapping = inode->i_mapping;
 	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	void __pmem *addr;
@@ -292,6 +293,8 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	pgoff_t size;
 	int error;
 
+	i_mmap_lock_read(mapping);
+
 	/*
 	 * Check truncate didn't happen while we were allocating a block.
 	 * If it did, this block may or may not be still allocated to the
@@ -321,6 +324,8 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
  out:
+	i_mmap_unlock_read(mapping);
+
 	return error;
 }
 
@@ -382,17 +387,15 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			 * from a read fault and we've raced with a truncate
 			 */
 			error = -EIO;
-			goto unlock;
+			goto unlock_page;
 		}
-	} else {
-		i_mmap_lock_write(mapping);
 	}
 
 	error = get_block(inode, block, &bh, 0);
 	if (!error && (bh.b_size < PAGE_SIZE))
 		error = -EIO;		/* fs corruption? */
 	if (error)
-		goto unlock;
+		goto unlock_page;
 
 	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
@@ -403,9 +406,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			if (!error && (bh.b_size < PAGE_SIZE))
 				error = -EIO;
 			if (error)
-				goto unlock;
+				goto unlock_page;
 		} else {
-			i_mmap_unlock_write(mapping);
 			return dax_load_hole(mapping, page, vmf);
 		}
 	}
@@ -417,15 +419,17 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		else
 			clear_user_highpage(new_page, vaddr);
 		if (error)
-			goto unlock;
+			goto unlock_page;
 		vmf->page = page;
 		if (!page) {
+			i_mmap_lock_read(mapping);
 			/* Check we didn't race with truncate */
 			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
 								PAGE_SHIFT;
 			if (vmf->pgoff >= size) {
+				i_mmap_unlock_read(mapping);
 				error = -EIO;
-				goto unlock;
+				goto out;
 			}
 		}
 		return VM_FAULT_LOCKED;
@@ -461,8 +465,6 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			WARN_ON_ONCE(!(vmf->flags & FAULT_FLAG_WRITE));
 	}
 
-	if (!page)
-		i_mmap_unlock_write(mapping);
  out:
 	if (error == -ENOMEM)
 		return VM_FAULT_OOM | major;
@@ -471,14 +473,11 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		return VM_FAULT_SIGBUS | major;
 	return VM_FAULT_NOPAGE | major;
 
- unlock:
+ unlock_page:
 	if (page) {
 		unlock_page(page);
 		page_cache_release(page);
-	} else {
-		i_mmap_unlock_write(mapping);
 	}
-
 	goto out;
 }
 EXPORT_SYMBOL(__dax_fault);
@@ -556,10 +555,10 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
-	i_mmap_lock_write(mapping);
 	length = get_block(inode, block, &bh, write);
 	if (length)
 		return VM_FAULT_SIGBUS;
+	i_mmap_lock_read(mapping);
 
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
@@ -633,11 +632,11 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
  out:
+	i_mmap_unlock_read(mapping);
+
 	if (buffer_unwritten(&bh))
 		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
 
-	i_mmap_unlock_write(mapping);
-
 	return result;
 
  fallback:
diff --git a/mm/memory.c b/mm/memory.c
index 5ec066f..deb679c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2427,16 +2427,11 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 
 
-	/*
-	 * DAX already holds i_mmap_lock to serialise file truncate vs
-	 * page fault and page fault vs page fault.
-	 */
-	if (!IS_DAX(mapping->host))
-		i_mmap_lock_write(mapping);
+	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
+	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	if (!IS_DAX(mapping->host))
-		i_mmap_unlock_write(mapping);
+	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-- 
2.5.0

