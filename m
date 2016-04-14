Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 8A4DA1A1DEC
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 14:04:05 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: integrate *sync code & multi-order radix tree
Date: Thu, 14 Apr 2016 15:03:24 -0600
Message-Id: <1460667804-21725-1-git-send-email-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With the new addition of the multi-order radix tree support we can simplify
the DAX *sync PMD support a bit.  Instead of manually checking to see if
our index is covered by a PMD entry we can rely on the new radix tree to
return the PMD entry if present.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 735a608..3f87fcc 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -40,6 +40,7 @@
 #define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
 #define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
 		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+#define RADIX_DAX_ORDER(pmd) (pmd ? PMD_SHIFT - PAGE_SHIFT : 0)
 
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
@@ -360,13 +361,11 @@ static int copy_user_bh(struct page *to, struct inode *inode,
 }
 
 #define NO_SECTOR -1
-#define DAX_PMD_INDEX(page_index) (page_index & (PMD_MASK >> PAGE_CACHE_SHIFT))
 
 static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
 		sector_t sector, bool pmd_entry, bool dirty)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
-	pgoff_t pmd_index = DAX_PMD_INDEX(index);
 	int type, error = 0;
 	void *entry;
 
@@ -376,12 +375,6 @@ static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
 
 	spin_lock_irq(&mapping->tree_lock);
 
-	entry = radix_tree_lookup(page_tree, pmd_index);
-	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD) {
-		index = pmd_index;
-		goto dirty;
-	}
-
 	entry = radix_tree_lookup(page_tree, index);
 	if (entry) {
 		type = RADIX_DAX_TYPE(entry);
@@ -418,7 +411,8 @@ static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
 		goto unlock;
 	}
 
-	error = radix_tree_insert(page_tree, index,
+	error = __radix_tree_insert(page_tree, index,
+			RADIX_DAX_ORDER(pmd_entry),
 			RADIX_DAX_ENTRY(sector, pmd_entry));
 	if (error)
 		goto unlock;
@@ -462,6 +456,13 @@ static int dax_writeback_one(struct block_device *bdev,
 		goto unlock;
 	}
 
+	/*
+	 * Even if dax_writeback_mapping_range() was given a wbc->range_start
+	 * in the middle of a PMD, the 'index' we are given will be aligned to
+	 * the start index of the PMD, as will the sector we pull from
+	 * 'entry'.  This allows us to flush for PMD_SIZE and not have to
+	 * worry about partial PMD writebacks.
+	 */
 	dax.sector = RADIX_DAX_SECTOR(entry);
 	dax.size = (type == RADIX_DAX_PMD ? PMD_SIZE : PAGE_SIZE);
 	spin_unlock_irq(&mapping->tree_lock);
@@ -502,12 +503,11 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	pgoff_t start_index, end_index, pmd_index;
+	pgoff_t start_index, end_index;
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
 	bool done = false;
 	int i, ret = 0;
-	void *entry;
 
 	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
 		return -EIO;
@@ -517,15 +517,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 	start_index = wbc->range_start >> PAGE_CACHE_SHIFT;
 	end_index = wbc->range_end >> PAGE_CACHE_SHIFT;
-	pmd_index = DAX_PMD_INDEX(start_index);
-
-	rcu_read_lock();
-	entry = radix_tree_lookup(&mapping->page_tree, pmd_index);
-	rcu_read_unlock();
-
-	/* see if the start of our range is covered by a PMD entry */
-	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
-		start_index = pmd_index;
 
 	tag_pages_for_writeback(mapping, start_index, end_index);
 
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
