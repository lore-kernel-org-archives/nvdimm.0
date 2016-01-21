Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 5/5] dax: fix clearing of holes in __dax_pmd_fault()
Date: Thu, 21 Jan 2016 10:46:04 -0700
Message-Id: <1453398364-22537-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When the user reads from a DAX hole via a mmap we service page faults using
zero-filled page cache pages.  These zero pages are also placed into the
address_space radix tree.  When we get our first write for that space, we
can allocate a PMD page worth of DAX storage to replace that hole.

When this happens we need to unmap the zero pages and remove them from the
radix tree.  Prior to this patch we were unmapping *all* storage in our
PMD's range, which is incorrect because it removed DAX entries as well on
non-allocating page faults.

Instead, keep track of when get_block() actually gives us storage so that
we can be sure to only remove zero pages that were covering holes.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index afacc30..263aed1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -790,9 +790,9 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	bool write = flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
 	pgoff_t size, pgoff;
-	loff_t lstart, lend;
 	sector_t block;
 	int error, result = 0;
+	bool alloc = false;
 
 	/* dax pmd mappings require pfn_t_devmap() */
 	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
@@ -830,10 +830,17 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
-	if (get_block(inode, block, &bh, write) != 0)
+
+	if (get_block(inode, block, &bh, 0) != 0)
 		return VM_FAULT_SIGBUS;
+
+	if (!buffer_mapped(&bh) && write) {
+		if (get_block(inode, block, &bh, 1) != 0)
+			return VM_FAULT_SIGBUS;
+		alloc = true;
+	}
+
 	bdev = bh.b_bdev;
-	i_mmap_lock_read(mapping);
 
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
@@ -842,15 +849,20 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	 */
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
 		dax_pmd_dbg(&bh, address, "allocated block too small");
-		goto fallback;
+		return VM_FAULT_FALLBACK;
+	}
+
+	/*
+	 * If we allocated new storage, make sure no process has any
+	 * zero pages covering this hole
+	 */
+	if (alloc) {
+		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
+
+		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	/* make sure no process has any zero pages covering this hole */
-	lstart = pgoff << PAGE_SHIFT;
-	lend = lstart + PMD_SIZE - 1; /* inclusive */
-	i_mmap_unlock_read(mapping);
-	unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
-	truncate_inode_pages_range(mapping, lstart, lend);
 	i_mmap_lock_read(mapping);
 
 	/*
-- 
2.5.0
