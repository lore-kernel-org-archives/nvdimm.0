Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18BBE211958EF
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 08:12:42 -0800 (PST)
Date: Mon, 26 Nov 2018 08:12:40 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: dax_lock_mapping_entry was never safe
Message-ID: <20181126161240.GH3065@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


I noticed this path while I was doing the 4.19 backport of
dax: Avoid losing wakeup in dax_lock_mapping_entry

                xa_unlock_irq(&mapping->i_pages);
                revalidate = wait_fn();
                finish_wait(wq, &ewait.wait);
                xa_lock_irq(&mapping->i_pages);

It's not safe to call xa_lock_irq() if mapping can have been freed while
we slept.  We'll probably get away with it; most filesystems use a unique
slab for their inodes, so you'll likely get either a freed inode or an
inode which is now the wrong inode.  But if that page has been freed back
to the page allocator, that pointer could now be pointing at anything.

Fixing this in the current codebase is no easier than fixing it in the
4.19 codebase.  This is the best I've come up with.  Could we do better
by not using the _exclusive form of prepare_to_wait()?  I'm not familiar
with all the things that need to be considered when using this family
of interfaces.

diff --git a/fs/dax.c b/fs/dax.c
index 9bcce89ea18e..154b592b18eb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -232,6 +232,24 @@ static void *get_unlocked_entry(struct xa_state *xas)
 	}
 }
 
+static void wait_unlocked_entry(struct xa_state *xas, void *entry)
+{
+	struct wait_exceptional_entry_queue ewait;
+	wait_queue_head_t *wq;
+
+	init_wait(&ewait.wait);
+	ewait.wait.func = wake_exceptional_entry_func;
+
+	wq = dax_entry_waitqueue(xas, entry, &ewait.key);
+	prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
+	xas_unlock_irq(xas);
+	/* We can no longer look at xas */
+	schedule();
+	finish_wait(wq, &ewait.wait);
+	if (waitqueue_active(wq))
+		__wake_up(wq, TASK_NORMAL, 1, &ewait.key);
+}
+
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
@@ -389,9 +407,7 @@ bool dax_lock_mapping_entry(struct page *page)
 		entry = xas_load(&xas);
 		if (dax_is_locked(entry)) {
 			rcu_read_unlock();
-			entry = get_unlocked_entry(&xas);
-			xas_unlock_irq(&xas);
-			put_unlocked_entry(&xas, entry);
+			wait_unlocked_entry(&xas, entry);
 			rcu_read_lock();
 			continue;
 		}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
