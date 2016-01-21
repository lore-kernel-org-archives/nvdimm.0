Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 2/5] dax: clear TOWRITE flag after flush is complete
Date: Thu, 21 Jan 2016 10:46:01 -0700
Message-Id: <1453398364-22537-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Previously in dax_writeback_one() we cleared the PAGECACHE_TAG_TOWRITE flag
before we had actually flushed the tagged radix tree entry to media.  This
is incorrect because of the following race:

Thread 1				Thread 2
--------				--------
dax_writeback_mapping_range()
tag entry with PAGECACHE_TAG_TOWRITE
					dax_writeback_mapping_range()
					tag entry with PAGECACHE_TAG_TOWRITE
					dax_writeback_one()
					radix_tree_tag_clear(TOWRITE)
TOWRITE flag is no longer set,
  find_get_entries_tag() finds no
  entries, return
					flush entry to media

In this case thread 1 returns before the data for the dirty entry is
actually durable on media.

Fix this by only clearing the PAGECACHE_TAG_TOWRITE flag after all flushing
is complete.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index cee9e1b..d589113 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -407,8 +407,6 @@ static int dax_writeback_one(struct block_device *bdev,
 	if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
 		goto unlock;
 
-	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
-
 	if (WARN_ON_ONCE(type != RADIX_DAX_PTE && type != RADIX_DAX_PMD)) {
 		ret = -EIO;
 		goto unlock;
@@ -432,6 +430,10 @@ static int dax_writeback_one(struct block_device *bdev,
 	}
 
 	wb_cache_pmem(dax.addr, dax.size);
+
+	spin_lock_irq(&mapping->tree_lock);
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
+	spin_unlock_irq(&mapping->tree_lock);
  unmap:
 	dax_unmap_atomic(bdev, &dax);
 	return ret;
-- 
2.5.0
