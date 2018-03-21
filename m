Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A897D2214674E
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 16:00:22 -0700 (PDT)
Subject: [PATCH v7 07/14] fs,
 dax: use page->mapping to warn if truncate collides with a busy page
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Mar 2018 15:57:48 -0700
Message-ID: <152167306807.5268.8483232024444414342.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Catch cases where extent unmap operations encounter pages that are
pinned / busy. Typically this is pinned pages that are under active dma.
This warning is a canary for potential data corruption as truncated
blocks could be allocated to a new file while the device is still
performing i/o.

Here is an example of a collision that this implementation catches:

 WARNING: CPU: 2 PID: 1286 at fs/dax.c:343 dax_disassociate_entry+0x55/0x80
 [..]
 Call Trace:
  __dax_invalidate_mapping_entry+0x6c/0xf0
  dax_delete_mapping_entry+0xf/0x20
  truncate_exceptional_pvec_entries.part.12+0x1af/0x200
  truncate_inode_pages_range+0x268/0x970
  ? tlb_gather_mmu+0x10/0x20
  ? up_write+0x1c/0x40
  ? unmap_mapping_range+0x73/0x140
  xfs_free_file_space+0x1b6/0x5b0 [xfs]
  ? xfs_file_fallocate+0x7f/0x320 [xfs]
  ? down_write_nested+0x40/0x70
  ? xfs_ilock+0x21d/0x2f0 [xfs]
  xfs_file_fallocate+0x162/0x320 [xfs]
  ? rcu_read_lock_sched_held+0x3f/0x70
  ? rcu_sync_lockdep_assert+0x2a/0x50
  ? __sb_start_write+0xd0/0x1b0
  ? vfs_fallocate+0x20c/0x270
  vfs_fallocate+0x154/0x270
  SyS_fallocate+0x43/0x80
  entry_SYSCALL_64_fastpath+0x1f/0x96

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index b646a46e4d12..f21a8e7e47f6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -298,6 +298,56 @@ static void put_unlocked_mapping_entry(struct address_space *mapping,
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
+static unsigned long dax_entry_size(void *entry)
+{
+	if (dax_is_zero_entry(entry))
+		return 0;
+	else if (dax_is_empty_entry(entry))
+		return 0;
+	else if (dax_is_pmd_entry(entry))
+		return PMD_SIZE;
+	else
+		return PAGE_SIZE;
+}
+
+#define for_each_entry_pfn(entry, pfn, end_pfn) \
+	for (pfn = dax_radix_pfn(entry), \
+			end_pfn = pfn + dax_entry_size(entry) / PAGE_SIZE; \
+			pfn < end_pfn; \
+			pfn++)
+
+static void dax_associate_entry(void *entry, struct address_space *mapping)
+{
+	unsigned long pfn, end_pfn;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return;
+
+	for_each_entry_pfn(entry, pfn, end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		WARN_ON_ONCE(page->mapping);
+		page->mapping = mapping;
+	}
+}
+
+static void dax_disassociate_entry(void *entry, struct address_space *mapping,
+		bool trunc)
+{
+	unsigned long pfn, end_pfn;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return;
+
+	for_each_entry_pfn(entry, pfn, end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
+		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
+		page->mapping = NULL;
+	}
+}
+
 /*
  * Find radix tree entry at given index. If it points to an exceptional entry,
  * return it with the radix tree entry locked. If the radix tree doesn't
@@ -404,6 +454,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		}
 
 		if (pmd_downgrade) {
+			dax_disassociate_entry(entry, mapping, false);
 			radix_tree_delete(&mapping->page_tree, index);
 			mapping->nrexceptional--;
 			dax_wake_mapping_entry_waiter(mapping, index, entry,
@@ -453,6 +504,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	    (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
 	     radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE)))
 		goto out;
+	dax_disassociate_entry(entry, mapping, trunc);
 	radix_tree_delete(page_tree, index);
 	mapping->nrexceptional--;
 	ret = 1;
@@ -547,6 +599,10 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 
 	spin_lock_irq(&mapping->tree_lock);
 	new_entry = dax_radix_locked_entry(pfn, flags);
+	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+		dax_disassociate_entry(entry, mapping, false);
+		dax_associate_entry(new_entry, mapping);
+	}
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
