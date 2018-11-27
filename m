Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 533B421A00AE6
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 13:16:48 -0800 (PST)
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 2/2] dax: Don't access a freed inode
Date: Tue, 27 Nov 2018 13:16:34 -0800
Message-Id: <20181127211634.4995-3-willy@infradead.org>
In-Reply-To: <20181127211634.4995-1-willy@infradead.org>
References: <20181127211634.4995-1-willy@infradead.org>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

After we drop the i_pages lock, the inode can be freed at any time.
The get_unlocked_entry() code has no choice but to reacquire the lock,
so it can't be used here.  Create a new wait_entry_unlocked() which takes
care not to acquire the lock or dereference the address_space in any way.

Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/dax.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e69fc231833b..cf1805645d18 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -232,6 +232,28 @@ static void *get_unlocked_entry(struct xa_state *xas)
 	}
 }
 
+/*
+ * The only thing keeping the address space around is the i_pages lock
+ * (it's cycled in clear_inode() after removing the entries from i_pages)
+ * After we call xas_unlock_irq(), we cannot touch xas->xa.
+ */
+static void wait_entry_unlocked(struct xa_state *xas, void *entry)
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
+	schedule();
+	finish_wait(wq, &ewait.wait);
+	if (waitqueue_active(wq))
+		__wake_up(wq, TASK_NORMAL, 1, &ewait.key);
+}
+
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
@@ -389,9 +411,7 @@ bool dax_lock_mapping_entry(struct page *page)
 		entry = xas_load(&xas);
 		if (dax_is_locked(entry)) {
 			rcu_read_unlock();
-			entry = get_unlocked_entry(&xas);
-			xas_unlock_irq(&xas);
-			put_unlocked_entry(&xas, entry);
+			wait_entry_unlocked(&xas, entry);
 			rcu_read_lock();
 			continue;
 		}
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
