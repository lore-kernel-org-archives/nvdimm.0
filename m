Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 4/5] dax: fix PMD handling for fsync/msync
Date: Wed, 20 Jan 2016 20:36:47 -0700
Message-Id: <1453347408-22830-5-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1453347408-22830-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1453347408-22830-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fix the way that DAX PMD radix tree entries are handled.  With this patch
we now check to see if a PMD entry exists in the radix tree on write, even
if we are just trying to insert a PTE.  If it exists, we dirty that instead
of inserting our own PTE entry.

Fix a bug in the PMD path in dax_writeback_mapping_range() where we were
previously passing a loff_t into radix_tree_lookup instead of a pgoff_t.

Account for the fact that multiple fsync/msync operations may be happening
at the same time and don't flush entries that are beyond end_index.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 55ae394..3b03580 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -327,19 +327,27 @@ static int copy_user_bh(struct page *to, struct inode *inode,
 }
 
 #define NO_SECTOR -1
+#define PMD_INDEX(page_index) (page_index & (PMD_MASK >> PAGE_CACHE_SHIFT))
 
 static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
 		sector_t sector, bool pmd_entry, bool dirty)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
+	pgoff_t pmd_index = PMD_INDEX(index);
 	int type, error = 0;
 	void *entry;
 
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
 	spin_lock_irq(&mapping->tree_lock);
-	entry = radix_tree_lookup(page_tree, index);
 
+	entry = radix_tree_lookup(page_tree, pmd_index);
+	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD) {
+		index = pmd_index;
+		goto dirty;
+	}
+
+	entry = radix_tree_lookup(page_tree, index);
 	if (entry) {
 		type = RADIX_DAX_TYPE(entry);
 		if (WARN_ON_ONCE(type != RADIX_DAX_PTE &&
@@ -460,31 +468,33 @@ int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
 {
 	struct inode *inode = mapping->host;
 	struct block_device *bdev = inode->i_sb->s_bdev;
+	pgoff_t start_index, end_index, pmd_index;
 	pgoff_t indices[PAGEVEC_SIZE];
-	pgoff_t start_page, end_page;
 	struct pagevec pvec;
-	void *entry;
+	bool done = false;
 	int i, ret = 0;
+	void *entry;
 
 	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
 		return -EIO;
 
+	start_index = start >> PAGE_CACHE_SHIFT;
+	end_index = end >> PAGE_CACHE_SHIFT;
+	pmd_index = PMD_INDEX(start_index);
+
 	rcu_read_lock();
-	entry = radix_tree_lookup(&mapping->page_tree, start & PMD_MASK);
+	entry = radix_tree_lookup(&mapping->page_tree, pmd_index);
 	rcu_read_unlock();
 
 	/* see if the start of our range is covered by a PMD entry */
-	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
-		start &= PMD_MASK;
-
-	start_page = start >> PAGE_CACHE_SHIFT;
-	end_page = end >> PAGE_CACHE_SHIFT;
+	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
+		start_index = pmd_index;
 
-	tag_pages_for_writeback(mapping, start_page, end_page);
+	tag_pages_for_writeback(mapping, start_index, end_index);
 
 	pagevec_init(&pvec, 0);
-	while (1) {
-		pvec.nr = find_get_entries_tag(mapping, start_page,
+	while (!done) {
+		pvec.nr = find_get_entries_tag(mapping, start_index,
 				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
 				pvec.pages, indices);
 
@@ -492,6 +502,11 @@ int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
 			break;
 
 		for (i = 0; i < pvec.nr; i++) {
+			if (indices[i] > end_index) {
+				done = true;
+				break;
+			}
+
 			ret = dax_writeback_one(bdev, mapping, indices[i],
 					pvec.pages[i]);
 			if (ret < 0)
-- 
2.5.0

