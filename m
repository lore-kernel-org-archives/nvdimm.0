Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 517FF21198CDC
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 07:23:52 -0800 (PST)
Date: Tue, 11 Dec 2018 07:23:49 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: FAILED: patch "[PATCH] dax: Don't access a freed inode" failed
 to apply to 4.19-stable tree
Message-ID: <20181211152349.GE6830@bombadil.infradead.org>
References: <1544536809243247@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1544536809243247@kroah.com>
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
To: gregkh@linuxfoundation.org
Cc: jack@suse.cz, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 11, 2018 at 03:00:09PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I have only compile-tested this backport.  Dan, do you want to run it
through some tests before Greg applies it?

>From e01d37913b5577acaa2e8e35200081eae2795087 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 11 Dec 2018 10:16:45 -0500
Subject: [PATCH 2/2] dax: Don't access a freed inode

commit 55e56f06ed71d9441f3abd5b1d3c1a870812b3fe upstream.

After we drop the i_pages lock, the inode can be freed at any time.
The get_unlocked_entry() code has no choice but to reacquire the lock,
so it can't be used here.  Create a new wait_entry_unlocked() which takes
care not to acquire the lock or dereference the address_space in any way.

Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c | 69 ++++++++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 3a2682a6c832..415605fafaeb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -229,8 +229,8 @@ static void put_unlocked_mapping_entry(struct address_space *mapping,
  *
  * Must be called with the i_pages lock held.
  */
-static void *__get_unlocked_mapping_entry(struct address_space *mapping,
-		pgoff_t index, void ***slotp, bool (*wait_fn)(void))
+static void *get_unlocked_mapping_entry(struct address_space *mapping,
+		pgoff_t index, void ***slotp)
 {
 	void *entry, **slot;
 	struct wait_exceptional_entry_queue ewait;
@@ -240,8 +240,6 @@ static void *__get_unlocked_mapping_entry(struct address_space *mapping,
 	ewait.wait.func = wake_exceptional_entry_func;
 
 	for (;;) {
-		bool revalidate;
-
 		entry = __radix_tree_lookup(&mapping->i_pages, index, NULL,
 					  &slot);
 		if (!entry ||
@@ -256,30 +254,39 @@ static void *__get_unlocked_mapping_entry(struct address_space *mapping,
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					  TASK_UNINTERRUPTIBLE);
 		xa_unlock_irq(&mapping->i_pages);
-		revalidate = wait_fn();
+		schedule();
 		finish_wait(wq, &ewait.wait);
 		xa_lock_irq(&mapping->i_pages);
-		if (revalidate) {
-			put_unlocked_mapping_entry(mapping, index, entry);
-			return ERR_PTR(-EAGAIN);
-		}
 	}
 }
 
-static bool entry_wait(void)
+/*
+ * The only thing keeping the address space around is the i_pages lock
+ * (it's cycled in clear_inode() after removing the entries from i_pages)
+ * After we call xas_unlock_irq(), we cannot touch xas->xa.
+ */
+static void wait_entry_unlocked(struct address_space *mapping, pgoff_t index,
+		void ***slotp, void *entry)
 {
+	struct wait_exceptional_entry_queue ewait;
+	wait_queue_head_t *wq;
+
+	init_wait(&ewait.wait);
+	ewait.wait.func = wake_exceptional_entry_func;
+
+	wq = dax_entry_waitqueue(mapping, index, entry, &ewait.key);
+	prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
+	xa_unlock_irq(&mapping->i_pages);
 	schedule();
+	finish_wait(wq, &ewait.wait);
+
 	/*
-	 * Never return an ERR_PTR() from
-	 * __get_unlocked_mapping_entry(), just keep looping.
+	 * Entry lock waits are exclusive. Wake up the next waiter since
+	 * we aren't sure we will acquire the entry lock and thus wake
+	 * the next waiter up on unlock.
 	 */
-	return false;
-}
-
-static void *get_unlocked_mapping_entry(struct address_space *mapping,
-		pgoff_t index, void ***slotp)
-{
-	return __get_unlocked_mapping_entry(mapping, index, slotp, entry_wait);
+	if (waitqueue_active(wq))
+		__wake_up(wq, TASK_NORMAL, 1, &ewait.key);
 }
 
 static void unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
@@ -398,19 +405,6 @@ static struct page *dax_busy_page(void *entry)
 	return NULL;
 }
 
-static bool entry_wait_revalidate(void)
-{
-	rcu_read_unlock();
-	schedule();
-	rcu_read_lock();
-
-	/*
-	 * Tell __get_unlocked_mapping_entry() to take a break, we need
-	 * to revalidate page->mapping after dropping locks
-	 */
-	return true;
-}
-
 bool dax_lock_mapping_entry(struct page *page)
 {
 	pgoff_t index;
@@ -446,14 +440,15 @@ bool dax_lock_mapping_entry(struct page *page)
 		}
 		index = page->index;
 
-		entry = __get_unlocked_mapping_entry(mapping, index, &slot,
-				entry_wait_revalidate);
+		entry = __radix_tree_lookup(&mapping->i_pages, index,
+						NULL, &slot);
 		if (!entry) {
 			xa_unlock_irq(&mapping->i_pages);
 			break;
-		} else if (IS_ERR(entry)) {
-			xa_unlock_irq(&mapping->i_pages);
-			WARN_ON_ONCE(PTR_ERR(entry) != -EAGAIN);
+		} else if (slot_locked(mapping, slot)) {
+			rcu_read_unlock();
+			wait_entry_unlocked(mapping, index, &slot, entry);
+			rcu_read_lock();
 			continue;
 		}
 		lock_slot(mapping, slot);
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
