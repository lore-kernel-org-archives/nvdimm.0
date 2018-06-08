Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A99421123E09
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 17:01:11 -0700 (PDT)
Subject: [PATCH v4 10/12] filesystem-dax: Introduce dax_lock_page()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Jun 2018 16:51:14 -0700
Message-ID: <152850187437.38390.2257981090761438811.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152850182079.38390.8280340535691965744.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152850182079.38390.8280340535691965744.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for implementing support for memory poison (media error)
handling via dax mappings, implement a lock_page() equivalent. Poison
error handling requires rmap and needs guarantees that the page->mapping
association is maintained / valid (inode not freed) for the duration of
the lookup.

In the device-dax case it is sufficient to simply hold a dev_pagemap
reference. In the filesystem-dax case we need to use the entry lock.

Export the entry lock via dax_lock_page() that uses rcu_read_lock() to
protect against the inode being freed, and revalidates the page->mapping
association under xa_lock().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |   15 ++++++++++
 2 files changed, 91 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index cccf6cad1a7a..b7e71b108fcf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -361,6 +361,82 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 	}
 }
 
+struct page *dax_lock_page(unsigned long pfn)
+{
+	pgoff_t index;
+	struct inode *inode;
+	wait_queue_head_t *wq;
+	void *entry = NULL, **slot;
+	struct address_space *mapping;
+	struct wait_exceptional_entry_queue ewait;
+	struct page *ret = NULL, *page = pfn_to_page(pfn);
+
+	rcu_read_lock();
+	for (;;) {
+		mapping = READ_ONCE(page->mapping);
+
+		if (!mapping || !IS_DAX(mapping->host))
+			break;
+
+		/*
+		 * In the device-dax case there's no need to lock, a
+		 * struct dev_pagemap pin is sufficient to keep the
+		 * inode alive.
+		 */
+		inode = mapping->host;
+		if (S_ISCHR(inode->i_mode)) {
+			ret = page;
+			break;
+		}
+
+		xa_lock_irq(&mapping->i_pages);
+		if (mapping != page->mapping) {
+			xa_unlock_irq(&mapping->i_pages);
+			continue;
+		}
+		index = page->index;
+
+		init_wait(&ewait.wait);
+		ewait.wait.func = wake_exceptional_entry_func;
+
+		entry = __radix_tree_lookup(&mapping->i_pages, index, NULL,
+				&slot);
+		if (!entry ||
+		    WARN_ON_ONCE(!radix_tree_exceptional_entry(entry))) {
+			xa_unlock_irq(&mapping->i_pages);
+			break;
+		} else if (!slot_locked(mapping, slot)) {
+			lock_slot(mapping, slot);
+			ret = page;
+			xa_unlock_irq(&mapping->i_pages);
+			break;
+		}
+
+		wq = dax_entry_waitqueue(mapping, index, entry, &ewait.key);
+		prepare_to_wait_exclusive(wq, &ewait.wait,
+				TASK_UNINTERRUPTIBLE);
+		xa_unlock_irq(&mapping->i_pages);
+		rcu_read_unlock();
+		schedule();
+		finish_wait(wq, &ewait.wait);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+
+	return page;
+}
+
+void dax_unlock_page(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+
+	if (S_ISCHR(inode->i_mode))
+		return;
+
+	dax_unlock_mapping_entry(mapping, page->index);
+}
+
 /*
  * Find radix tree entry at given index. If it points to an exceptional entry,
  * return it with the radix tree entry locked. If the radix tree doesn't
diff --git a/include/linux/dax.h b/include/linux/dax.h
index f9eb22ad341e..641cab7e1fa7 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -83,6 +83,8 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc);
+struct page *dax_lock_page(unsigned long pfn);
+void dax_unlock_page(struct page *page);
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -108,6 +110,19 @@ static inline int dax_writeback_mapping_range(struct address_space *mapping,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline struct page *dax_lock_page(unsigned long pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	if (IS_DAX(page->mapping->host))
+		return page;
+	return NULL;
+}
+
+static inline void dax_unlock_page(struct page *page)
+{
+}
 #endif
 
 int dax_read_lock(void);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
