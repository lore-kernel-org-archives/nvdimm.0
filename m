Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id A34CA1A1EFA
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:56:06 -0800 (PST)
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: [PATCH 05/12] dax: Remove synchronization using i_mmap_lock
Date: Thu, 10 Mar 2016 19:55:21 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE0422079E9@FMSMSX114.amr.corp.intel.com>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-6-git-send-email-jack@suse.cz>
In-Reply-To: <1457637535-21633-6-git-send-email-jack@suse.cz>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: NeilBrown <neilb@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

This locking's still necessary.  i_mmap_sem has already been released by the time we're back in do_cow_fault(), so it doesn't protect that page, and truncate can have whizzed past and thinks there's nothing to unmap.  So a task can have a MAP_PRIVATE page still in its address space after it's supposed to have been unmapped.

We need a test suite for this ;-)

-----Original Message-----
From: Jan Kara [mailto:jack@suse.cz] 
Sent: Thursday, March 10, 2016 11:19 AM
To: linux-fsdevel@vger.kernel.org
Cc: Wilcox, Matthew R; Ross Zwisler; Williams, Dan J; linux-nvdimm@lists.01.org; NeilBrown; Jan Kara
Subject: [PATCH 05/12] dax: Remove synchronization using i_mmap_lock

At one point DAX used i_mmap_lock so synchronize page faults with page
table invalidation during truncate. However these days DAX uses
filesystem specific RW semaphores to protect against these races
(i_mmap_sem in ext2 & ext4 cases, XFS_MMAPLOCK in xfs case). So remove
the unnecessary locking.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c    | 19 -------------------
 mm/memory.c | 14 --------------
 2 files changed, 33 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9c4d697fb6fc..e409e8fc13b7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -563,8 +563,6 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	pgoff_t size;
 	int error;
 
-	i_mmap_lock_read(mapping);
-
 	/*
 	 * Check truncate didn't happen while we were allocating a block.
 	 * If it did, this block may or may not be still allocated to the
@@ -597,8 +595,6 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	error = vm_insert_mixed(vma, vaddr, dax.pfn);
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	return error;
 }
 
@@ -695,17 +691,6 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		if (error)
 			goto unlock_page;
 		vmf->page = page;
-		if (!page) {
-			i_mmap_lock_read(mapping);
-			/* Check we didn't race with truncate */
-			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
-								PAGE_SHIFT;
-			if (vmf->pgoff >= size) {
-				i_mmap_unlock_read(mapping);
-				error = -EIO;
-				goto out;
-			}
-		}
 		return VM_FAULT_LOCKED;
 	}
 
@@ -895,8 +880,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	i_mmap_lock_read(mapping);
-
 	/*
 	 * If a truncate happened while we were allocating blocks, we may
 	 * leave blocks allocated to the file that are beyond EOF.  We can't
@@ -1013,8 +996,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	if (buffer_unwritten(&bh))
 		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
 
diff --git a/mm/memory.c b/mm/memory.c
index 8132787ae4d5..13f76eb08f33 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2430,8 +2430,6 @@ void unmap_mapping_range(struct address_space *mapping,
 	if (details.last_index < details.first_index)
 		details.last_index = ULONG_MAX;
 
-
-	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
@@ -3019,12 +3017,6 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (fault_page) {
 			unlock_page(fault_page);
 			page_cache_release(fault_page);
-		} else {
-			/*
-			 * The fault handler has no page to lock, so it holds
-			 * i_mmap_lock for read to protect against truncate.
-			 */
-			i_mmap_unlock_read(vma->vm_file->f_mapping);
 		}
 		goto uncharge_out;
 	}
@@ -3035,12 +3027,6 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (fault_page) {
 		unlock_page(fault_page);
 		page_cache_release(fault_page);
-	} else {
-		/*
-		 * The fault handler has no page to lock, so it holds
-		 * i_mmap_lock for read to protect against truncate.
-		 */
-		i_mmap_unlock_read(vma->vm_file->f_mapping);
 	}
 	return ret;
 uncharge_out:
-- 
2.6.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
