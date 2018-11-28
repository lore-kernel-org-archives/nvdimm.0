Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD9D52118F366
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 11:56:35 -0800 (PST)
Subject: [PATCH v2] dax: Don't access a freed inode
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Nov 2018 11:44:07 -0800
Message-ID: <154343424782.982643.12596428619928518745.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20181127211634.4995-3-willy@infradead.org>
References: <20181127211634.4995-3-willy@infradead.org>
MIME-Version: 1.0
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <willy@infradead.org>

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
 fs/dax.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e69fc231833b..3f592dc18d67 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -232,6 +232,34 @@ static void *get_unlocked_entry(struct xa_state *xas)
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
+
+	/*
+	 * Entry lock waits are exclusive. Wake up the next waiter since
+	 * we aren't sure we will acquire the entry lock and thus wake
+	 * the next waiter up on unlock.
+	 */
+	if (waitqueue_active(wq))
+		__wake_up(wq, TASK_NORMAL, 1, &ewait.key);
+}
+
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
@@ -389,9 +417,7 @@ bool dax_lock_mapping_entry(struct page *page)
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
