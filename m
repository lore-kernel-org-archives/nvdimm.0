Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Nov 2015 12:16:14 -0800
Message-ID: <20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Currently dax mappings survive block_device shutdown.  While page cache
pages are permitted to be read/written after the block_device is torn
down this is not acceptable in the dax case as all media access must end
when the device is disabled.  The pfn backing a dax mapping is permitted
to be invalidated after bdev shutdown and this is indeed the case with
brd.

When a dax capable block_device driver calls del_gendisk() in its
shutdown path, or a filesystem evicts an inode it needs to ensure that
all the pfns that had been mapped via bdev_direct_access() are unmapped.
This is different than the pagecache backed case where
truncate_inode_pages() is sufficient to end I/O to pages mapped to a
dying inode.

Since dax bypasses the page cache we need to unmap in addition to
truncating pages.  Also, since dax mappings are not accounted in the
mapping radix we uncoditionally truncate all inodes with the S_DAX flag.
Likely when we add support for dynamic dax enable/disable control we'll
have infrastructure to detect if the inode is unmapped and can skip the
truncate.

Cc: <stable@vger.kernel.org>
Cc: Jan Kara <jack@suse.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/inode.c    |   27 +++++++++++++++++++++++++++
 mm/truncate.c |   13 +++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1be5f9003eb3..1029e033e991 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -579,6 +579,18 @@ static void dispose_list(struct list_head *head)
 	}
 }
 
+static void truncate_list(struct list_head *head)
+{
+	struct inode *inode, *_i;
+
+	list_for_each_entry_safe(inode, _i, head, i_lru) {
+		list_del_init(&inode->i_lru);
+		truncate_pagecache(inode, 0);
+		iput(inode);
+		cond_resched();
+	}
+}
+
 /**
  * evict_inodes	- evict all evictable inodes for a superblock
  * @sb:		superblock to operate on
@@ -642,6 +654,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	int busy = 0;
 	struct inode *inode, *next;
 	LIST_HEAD(dispose);
+	LIST_HEAD(truncate);
 
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
@@ -655,6 +668,19 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 			busy = 1;
 			continue;
 		}
+		if (IS_DAX(inode) && atomic_read(&inode->i_count)) {
+			/*
+			 * dax mappings can't live past this invalidation event
+			 * as there is no page cache present to allow the data
+			 * to remain accessiable.
+			 */
+			__iget(inode);
+			inode_lru_list_del(inode);
+			spin_unlock(&inode->i_lock);
+			list_add(&inode->i_lru, &truncate);
+			busy = 1;
+			continue;
+		}
 		if (atomic_read(&inode->i_count)) {
 			spin_unlock(&inode->i_lock);
 			busy = 1;
@@ -669,6 +695,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	spin_unlock(&sb->s_inode_list_lock);
 
 	dispose_list(&dispose);
+	truncate_list(&truncate);
 
 	return busy;
 }
diff --git a/mm/truncate.c b/mm/truncate.c
index 76e35ad97102..ff1fb3b0980e 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -402,6 +402,7 @@ EXPORT_SYMBOL(truncate_inode_pages);
  */
 void truncate_inode_pages_final(struct address_space *mapping)
 {
+	struct inode *inode = mapping->host;
 	unsigned long nrshadows;
 	unsigned long nrpages;
 
@@ -423,7 +424,7 @@ void truncate_inode_pages_final(struct address_space *mapping)
 	smp_rmb();
 	nrshadows = mapping->nrshadows;
 
-	if (nrpages || nrshadows) {
+	if (nrpages || nrshadows || IS_DAX(inode)) {
 		/*
 		 * As truncation uses a lockless tree lookup, cycle
 		 * the tree lock to make sure any ongoing tree
@@ -433,7 +434,15 @@ void truncate_inode_pages_final(struct address_space *mapping)
 		spin_lock_irq(&mapping->tree_lock);
 		spin_unlock_irq(&mapping->tree_lock);
 
-		truncate_inode_pages(mapping, 0);
+		/*
+		 * In the case of DAX we also need to unmap the inode
+		 * since the pfn backing the mapping may be invalidated
+		 * after this returns
+		 */
+		if (IS_DAX(inode))
+			truncate_pagecache(inode, 0);
+		else
+			truncate_inode_pages(mapping, 0);
 	}
 }
 EXPORT_SYMBOL(truncate_inode_pages_final);

