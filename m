Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA669202E5484
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 20:44:00 -0700 (PDT)
Subject: [PATCH v6] filesystem-dax: Introduce dax_lock_mapping_entry()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 20:33:52 -0700
Message-ID: <153076161392.9314.16967170107658011515.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153074046078.27838.5465590228767136915.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153074046078.27838.5465590228767136915.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for implementing support for memory poison (media error)
handling via dax mappings, implement a lock_page() equivalent. Poison
error handling requires rmap and needs guarantees that the page->mapping
association is maintained / valid (inode not freed) for the duration of
the lookup.

In the device-dax case it is sufficient to simply hold a dev_pagemap
reference. In the filesystem-dax case we need to use the entry lock.

Export the entry lock via dax_lock_mapping_entry() that uses
rcu_read_lock() to protect against the inode being freed, and
revalidates the page->mapping association under xa_lock().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v5, fixup kbuild robot reports.

 fs/dax.c            |  109 ++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/dax.h |   13 ++++++
 2 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4de11ed463ce..57ec272038da 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -226,8 +226,8 @@ static inline void *unlock_slot(struct address_space *mapping, void **slot)
  *
  * Must be called with the i_pages lock held.
  */
-static void *get_unlocked_mapping_entry(struct address_space *mapping,
-					pgoff_t index, void ***slotp)
+static void *__get_unlocked_mapping_entry(struct address_space *mapping,
+		pgoff_t index, void ***slotp, bool (*wait_fn)(void))
 {
 	void *entry, **slot;
 	struct wait_exceptional_entry_queue ewait;
@@ -237,6 +237,8 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 	ewait.wait.func = wake_exceptional_entry_func;
 
 	for (;;) {
+		bool revalidate;
+
 		entry = __radix_tree_lookup(&mapping->i_pages, index, NULL,
 					  &slot);
 		if (!entry ||
@@ -251,14 +253,31 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					  TASK_UNINTERRUPTIBLE);
 		xa_unlock_irq(&mapping->i_pages);
-		schedule();
+		revalidate = wait_fn();
 		finish_wait(wq, &ewait.wait);
 		xa_lock_irq(&mapping->i_pages);
+		if (revalidate)
+			return ERR_PTR(-EAGAIN);
 	}
 }
 
-static void dax_unlock_mapping_entry(struct address_space *mapping,
-				     pgoff_t index)
+static bool entry_wait(void)
+{
+	schedule();
+	/*
+	 * Never return an ERR_PTR() from
+	 * __get_unlocked_mapping_entry(), just keep looping.
+	 */
+	return false;
+}
+
+static void *get_unlocked_mapping_entry(struct address_space *mapping,
+		pgoff_t index, void ***slotp)
+{
+	return __get_unlocked_mapping_entry(mapping, index, slotp, entry_wait);
+}
+
+static void unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
 {
 	void *entry, **slot;
 
@@ -277,7 +296,7 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
 static void put_locked_mapping_entry(struct address_space *mapping,
 		pgoff_t index)
 {
-	dax_unlock_mapping_entry(mapping, index);
+	unlock_mapping_entry(mapping, index);
 }
 
 /*
@@ -374,6 +393,84 @@ static struct page *dax_busy_page(void *entry)
 	return NULL;
 }
 
+static bool entry_wait_revalidate(void)
+{
+	rcu_read_unlock();
+	schedule();
+	rcu_read_lock();
+
+	/*
+	 * Tell __get_unlocked_mapping_entry() to take a break, we need
+	 * to revalidate page->mapping after dropping locks
+	 */
+	return true;
+}
+
+bool dax_lock_mapping_entry(struct page *page)
+{
+	pgoff_t index;
+	struct inode *inode;
+	bool did_lock = false;
+	void *entry = NULL, **slot;
+	struct address_space *mapping;
+
+	rcu_read_lock();
+	for (;;) {
+		mapping = READ_ONCE(page->mapping);
+
+		if (!dax_mapping(mapping))
+			break;
+
+		/*
+		 * In the device-dax case there's no need to lock, a
+		 * struct dev_pagemap pin is sufficient to keep the
+		 * inode alive, and we assume we have dev_pagemap pin
+		 * otherwise we would not have a valid pfn_to_page()
+		 * translation.
+		 */
+		inode = mapping->host;
+		if (S_ISCHR(inode->i_mode)) {
+			did_lock = true;
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
+		entry = __get_unlocked_mapping_entry(mapping, index, &slot,
+				entry_wait_revalidate);
+		if (!entry) {
+			xa_unlock_irq(&mapping->i_pages);
+			break;
+		} else if (IS_ERR(entry)) {
+			WARN_ON_ONCE(PTR_ERR(entry) != -EAGAIN);
+			continue;
+		}
+		lock_slot(mapping, slot);
+		did_lock = true;
+		xa_unlock_irq(&mapping->i_pages);
+		break;
+	}
+	rcu_read_unlock();
+
+	return did_lock;
+}
+
+void dax_unlock_mapping_entry(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+
+	if (S_ISCHR(inode->i_mode))
+		return;
+
+	unlock_mapping_entry(mapping, page->index);
+}
+
 /*
  * Find radix tree entry at given index. If it points to an exceptional entry,
  * return it with the radix tree entry locked. If the radix tree doesn't
diff --git a/include/linux/dax.h b/include/linux/dax.h
index deb0f663252f..450b28db9533 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -88,6 +88,8 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc);
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
+bool dax_lock_mapping_entry(struct page *page);
+void dax_unlock_mapping_entry(struct page *page);
 #else
 static inline bool bdev_dax_supported(struct block_device *bdev,
 		int blocksize)
@@ -119,6 +121,17 @@ static inline int dax_writeback_mapping_range(struct address_space *mapping,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline bool dax_lock_mapping_entry(struct page *page)
+{
+	if (IS_DAX(page->mapping->host))
+		return true;
+	return false;
+}
+
+static inline void dax_unlock_mapping_entry(struct page *page)
+{
+}
 #endif
 
 int dax_read_lock(void);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
