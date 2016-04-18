Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 18/18] dax: Remove i_mmap_lock protection
Date: Mon, 18 Apr 2016 23:35:41 +0200
Message-Id: <1461015341-20153-19-git-send-email-jack@suse.cz>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Currently faults are protected against truncate by filesystem specific
i_mmap_sem and page lock in case of hole page. Cow faults are protected
DAX radix tree entry locking. So there's no need for i_mmap_lock in DAX
code. Remove it.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c    | 24 +++++-------------------
 mm/memory.c |  2 --
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d907bf8b07a0..5a34f086b4ca 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -826,29 +826,19 @@ static int dax_insert_mapping(struct address_space *mapping,
 		.sector = to_sector(bh, mapping->host),
 		.size = bh->b_size,
 	};
-	int error;
 	void *ret;
 	void *entry = *entryp;
 
-	i_mmap_lock_read(mapping);
-
-	if (dax_map_atomic(bdev, &dax) < 0) {
-		error = PTR_ERR(dax.addr);
-		goto out;
-	}
+	if (dax_map_atomic(bdev, &dax) < 0)
+		return PTR_ERR(dax.addr);
 	dax_unmap_atomic(bdev, &dax);
 
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, dax.sector);
-	if (IS_ERR(ret)) {
-		error = PTR_ERR(ret);
-		goto out;
-	}
+	if (IS_ERR(ret))
+		return PTR_ERR(ret);
 	*entryp = ret;
 
-	error = vm_insert_mixed(vma, vaddr, dax.pfn);
- out:
-	i_mmap_unlock_read(mapping);
-	return error;
+	return vm_insert_mixed(vma, vaddr, dax.pfn);
 }
 
 /**
@@ -1086,8 +1076,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	i_mmap_lock_read(mapping);
-
 	if (!write && !buffer_mapped(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
@@ -1179,8 +1167,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	return result;
 
  fallback:
diff --git a/mm/memory.c b/mm/memory.c
index f09cdb8d48fa..06f552504e79 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2453,8 +2453,6 @@ void unmap_mapping_range(struct address_space *mapping,
 	if (details.last_index < details.first_index)
 		details.last_index = ULONG_MAX;
 
-
-	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-- 
2.6.6

