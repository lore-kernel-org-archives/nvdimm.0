Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 439FC21B06E9B
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 15:38:08 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 2/5] dax: relocate some dax functions
Date: Fri, 21 Jul 2017 16:39:52 -0600
Message-Id: <20170721223956.29485-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
References: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-doc@vger.kernel.org, David Airlie <airlied@linux.ie>, Dave Chinner <david@fromorbit.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-samsung-soc@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-ext4@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-arm-msm@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Inki Dae <inki.dae@samsung.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-xfs@vger.kernel.org, Rob Clark <robdclark@gmail.com>, Kukjin Kim <kgene@kernel.org>, linux-fsdevel@vger.kernel.org, freedreno@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

dax_load_hole() will soon need to call dax_insert_mapping_entry(), so it
needs to be moved lower in dax.c so the definition exists.

dax_wake_mapping_entry_waiter() will soon be removed from dax.h and be made
static to dax.c, so we need to move its definition above all its callers.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 138 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c844a51..779dc5e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -121,6 +121,31 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait, unsigned int mo
 }
 
 /*
+ * We do not necessarily hold the mapping->tree_lock when we call this
+ * function so it is possible that 'entry' is no longer a valid item in the
+ * radix tree.  This is okay because all we really need to do is to find the
+ * correct waitqueue where tasks might be waiting for that old 'entry' and
+ * wake them.
+ */
+void dax_wake_mapping_entry_waiter(struct address_space *mapping,
+		pgoff_t index, void *entry, bool wake_all)
+{
+	struct exceptional_entry_key key;
+	wait_queue_head_t *wq;
+
+	wq = dax_entry_waitqueue(mapping, index, entry, &key);
+
+	/*
+	 * Checking for locked entry and prepare_to_wait_exclusive() happens
+	 * under mapping->tree_lock, ditto for entry handling in our callers.
+	 * So at this point all tasks that could have seen our entry locked
+	 * must be in the waitqueue and the following check will see them.
+	 */
+	if (waitqueue_active(wq))
+		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
+}
+
+/*
  * Check whether the given slot is locked. The function must be called with
  * mapping->tree_lock held
  */
@@ -392,31 +417,6 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 	return entry;
 }
 
-/*
- * We do not necessarily hold the mapping->tree_lock when we call this
- * function so it is possible that 'entry' is no longer a valid item in the
- * radix tree.  This is okay because all we really need to do is to find the
- * correct waitqueue where tasks might be waiting for that old 'entry' and
- * wake them.
- */
-void dax_wake_mapping_entry_waiter(struct address_space *mapping,
-		pgoff_t index, void *entry, bool wake_all)
-{
-	struct exceptional_entry_key key;
-	wait_queue_head_t *wq;
-
-	wq = dax_entry_waitqueue(mapping, index, entry, &key);
-
-	/*
-	 * Checking for locked entry and prepare_to_wait_exclusive() happens
-	 * under mapping->tree_lock, ditto for entry handling in our callers.
-	 * So at this point all tasks that could have seen our entry locked
-	 * must be in the waitqueue and the following check will see them.
-	 */
-	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
-}
-
 static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
@@ -468,50 +468,6 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 	return __dax_invalidate_mapping_entry(mapping, index, false);
 }
 
-/*
- * The user has performed a load from a hole in the file.  Allocating
- * a new page in the file would cause excessive storage usage for
- * workloads with sparse files.  We allocate a page cache page instead.
- * We'll kick it out of the page cache if it's ever written to,
- * otherwise it will simply fall out of the page cache under memory
- * pressure without ever having been dirtied.
- */
-static int dax_load_hole(struct address_space *mapping, void **entry,
-			 struct vm_fault *vmf)
-{
-	struct inode *inode = mapping->host;
-	struct page *page;
-	int ret;
-
-	/* Hole page already exists? Return it...  */
-	if (!radix_tree_exceptional_entry(*entry)) {
-		page = *entry;
-		goto finish_fault;
-	}
-
-	/* This will replace locked radix tree entry with a hole page */
-	page = find_or_create_page(mapping, vmf->pgoff,
-				   vmf->gfp_mask | __GFP_ZERO);
-	if (!page) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
-
-finish_fault:
-	vmf->page = page;
-	ret = finish_fault(vmf);
-	vmf->page = NULL;
-	*entry = page;
-	if (!ret) {
-		/* Grab reference for PTE that is now referencing the page */
-		get_page(page);
-		ret = VM_FAULT_NOPAGE;
-	}
-out:
-	trace_dax_load_hole(inode, vmf, ret);
-	return ret;
-}
-
 static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		sector_t sector, size_t size, struct page *to,
 		unsigned long vaddr)
@@ -938,6 +894,50 @@ int dax_pfn_mkwrite(struct vm_fault *vmf)
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
+/*
+ * The user has performed a load from a hole in the file.  Allocating
+ * a new page in the file would cause excessive storage usage for
+ * workloads with sparse files.  We allocate a page cache page instead.
+ * We'll kick it out of the page cache if it's ever written to,
+ * otherwise it will simply fall out of the page cache under memory
+ * pressure without ever having been dirtied.
+ */
+static int dax_load_hole(struct address_space *mapping, void **entry,
+			 struct vm_fault *vmf)
+{
+	struct inode *inode = mapping->host;
+	struct page *page;
+	int ret;
+
+	/* Hole page already exists? Return it...  */
+	if (!radix_tree_exceptional_entry(*entry)) {
+		page = *entry;
+		goto finish_fault;
+	}
+
+	/* This will replace locked radix tree entry with a hole page */
+	page = find_or_create_page(mapping, vmf->pgoff,
+				   vmf->gfp_mask | __GFP_ZERO);
+	if (!page) {
+		ret = VM_FAULT_OOM;
+		goto out;
+	}
+
+finish_fault:
+	vmf->page = page;
+	ret = finish_fault(vmf);
+	vmf->page = NULL;
+	*entry = page;
+	if (!ret) {
+		/* Grab reference for PTE that is now referencing the page */
+		get_page(page);
+		ret = VM_FAULT_NOPAGE;
+	}
+out:
+	trace_dax_load_hole(inode, vmf, ret);
+	return ret;
+}
+
 static bool dax_range_is_aligned(struct block_device *bdev,
 				 unsigned int offset, unsigned int length)
 {
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
