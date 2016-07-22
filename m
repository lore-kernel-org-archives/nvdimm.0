Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F0E281A1E21
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jul 2016 05:20:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/15] dax: Make cache flushing protected by entry lock
Date: Fri, 22 Jul 2016 14:19:33 +0200
Message-Id: <1469189981-19000-8-git-send-email-jack@suse.cz>
In-Reply-To: <1469189981-19000-1-git-send-email-jack@suse.cz>
References: <1469189981-19000-1-git-send-email-jack@suse.cz>
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
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently, flushing of caches for DAX mappings was ignoring entry lock.
So far this was ok (modulo a bug that a difference in entry lock could
cause cache flushing to be mistakenly skipped) but in the following
patches we will write-protect PTEs on cache flushing and clear dirty
tags. For that we will need more exclusion. So do cache flushing under
an entry lock. This allows us to remove one lock-unlock pair of
mapping->tree_lock as a bonus.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 66 +++++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 24 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ec875683c17d..513881431be6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -674,43 +674,63 @@ static int dax_writeback_one(struct block_device *bdev,
 		struct address_space *mapping, pgoff_t index, void *entry)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
-	int type = RADIX_DAX_TYPE(entry);
-	struct radix_tree_node *node;
 	struct blk_dax_ctl dax;
-	void **slot;
+	void *entry2, **slot;
 	int ret = 0;
+	int type;
 
-	spin_lock_irq(&mapping->tree_lock);
 	/*
-	 * Regular page slots are stabilized by the page lock even
-	 * without the tree itself locked.  These unlocked entries
-	 * need verification under the tree lock.
+	 * A page got tagged dirty in DAX mapping? Something is seriously
+	 * wrong.
 	 */
-	if (!__radix_tree_lookup(page_tree, index, &node, &slot))
-		goto unlock;
-	if (*slot != entry)
-		goto unlock;
-
-	/* another fsync thread may have already written back this entry */
-	if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
-		goto unlock;
+	if (WARN_ON(!radix_tree_exceptional_entry(entry)))
+		return -EIO;
 
+	spin_lock_irq(&mapping->tree_lock);
+	entry2 = get_unlocked_mapping_entry(mapping, index, &slot);
+	/* Entry got punched out / reallocated? */
+	if (!entry2 || !radix_tree_exceptional_entry(entry2))
+		goto put_unlock;
+	/*
+	 * Entry got reallocated elsewhere? No need to writeback. We have to
+	 * compare sectors as we must not bail out due to difference in lockbit
+	 * or entry type.
+	 */
+	if (RADIX_DAX_SECTOR(entry2) != RADIX_DAX_SECTOR(entry))
+		goto put_unlock;
+	type = RADIX_DAX_TYPE(entry2);
 	if (WARN_ON_ONCE(type != RADIX_DAX_PTE && type != RADIX_DAX_PMD)) {
 		ret = -EIO;
-		goto unlock;
+		goto put_unlock;
 	}
 
+	/* Another fsync thread may have already written back this entry */
+	if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
+		goto put_unlock;
+	/* Lock the entry to serialize with page faults */
+	entry = lock_slot(mapping, slot);
+	/*
+	 * We can clear the tag now but we have to be careful so that concurrent
+	 * dax_writeback_one() calls for the same index cannot finish before we
+	 * actually flush the caches. This is achieved as the calls will look
+	 * at the entry only under tree_lock and once they do that they will
+	 * see the entry locked and wait for it to unlock.
+	 */
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
+	spin_unlock_irq(&mapping->tree_lock);
+
 	dax.sector = RADIX_DAX_SECTOR(entry);
 	dax.size = (type == RADIX_DAX_PMD ? PMD_SIZE : PAGE_SIZE);
-	spin_unlock_irq(&mapping->tree_lock);
 
 	/*
 	 * We cannot hold tree_lock while calling dax_map_atomic() because it
 	 * eventually calls cond_resched().
 	 */
 	ret = dax_map_atomic(bdev, &dax);
-	if (ret < 0)
+	if (ret < 0) {
+		put_locked_mapping_entry(mapping, index, entry);
 		return ret;
+	}
 
 	if (WARN_ON_ONCE(ret < dax.size)) {
 		ret = -EIO;
@@ -718,15 +738,13 @@ static int dax_writeback_one(struct block_device *bdev,
 	}
 
 	wb_cache_pmem(dax.addr, dax.size);
-
-	spin_lock_irq(&mapping->tree_lock);
-	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
-	spin_unlock_irq(&mapping->tree_lock);
- unmap:
+unmap:
 	dax_unmap_atomic(bdev, &dax);
+	put_locked_mapping_entry(mapping, index, entry);
 	return ret;
 
- unlock:
+put_unlock:
+	put_unlocked_mapping_entry(mapping, index, entry2);
 	spin_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
