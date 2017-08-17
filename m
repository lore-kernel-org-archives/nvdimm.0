Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F68421E1452F
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:02 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 12/13] dax: Implement dax_insert_pfn_mkwrite()
Date: Thu, 17 Aug 2017 18:08:14 +0200
Message-Id: <20170817160815.30466-13-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Implement a function that inserts a writeable page table entry (PTE or
PMD) and takes care of marking it dirty in the radix tree. This function
will be used to finish synchronous page fault.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c                      | 52 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h           |  2 ++
 include/trace/events/fs_dax.h |  2 ++
 3 files changed, 56 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index ca88fc356786..ca81084f6608 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1467,3 +1467,55 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 	}
 }
 EXPORT_SYMBOL_GPL(dax_iomap_fault);
+
+/**
+ * dax_insert_pfn_mkwrite - insert PTE or PMD entry into page tables
+ * @vmf: The description of the fault
+ * @pe_size: Size of entry to be inserted
+ * @pfn: PFN to insert
+ *
+ * This function inserts writeable PTE or PMD entry into page tables for mmaped
+ * DAX file.  It takes care of marking corresponding radix tree entry as dirty
+ * as well.
+ */
+int dax_insert_pfn_mkwrite(struct vm_fault *vmf, enum page_entry_size pe_size,
+			   pfn_t pfn)
+{
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	void *entry, **slot;
+	pgoff_t index = vmf->pgoff;
+	int vmf_ret, error;
+
+	spin_lock_irq(&mapping->tree_lock);
+	entry = get_unlocked_mapping_entry(mapping, index, &slot);
+	/* Did we race with someone splitting entry or so? */
+	if (!entry || (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
+	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
+		put_unlocked_mapping_entry(mapping, index, entry);
+		spin_unlock_irq(&mapping->tree_lock);
+		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
+						      VM_FAULT_NOPAGE);
+		return VM_FAULT_NOPAGE;
+	}
+	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
+	entry = lock_slot(mapping, slot);
+	spin_unlock_irq(&mapping->tree_lock);
+	switch (pe_size) {
+	case PE_SIZE_PTE:
+		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
+		vmf_ret = dax_fault_return(error);
+		break;
+#ifdef CONFIG_FS_DAX_PMD
+	case PE_SIZE_PMD:
+		vmf_ret = vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
+			pfn, true);
+		break;
+#endif
+	default:
+		vmf_ret = VM_FAULT_FALLBACK;
+	}
+	put_locked_mapping_entry(mapping, index);
+	trace_dax_insert_pfn_mkwrite(mapping->host, vmf, vmf_ret);
+	return vmf_ret;
+}
+EXPORT_SYMBOL_GPL(dax_insert_pfn_mkwrite);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 8f493d9879f7..d8e67995a958 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -92,6 +92,8 @@ ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 		    const struct iomap_ops *ops, pfn_t *pfnp);
+int dax_insert_pfn_mkwrite(struct vm_fault *vmf, enum page_entry_size pe_size,
+			   pfn_t pfn);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 88a9d19b8ff8..7725459fafef 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -190,6 +190,8 @@ DEFINE_EVENT(dax_pte_fault_class, name, \
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault);
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault_done);
 DEFINE_PTE_FAULT_EVENT(dax_load_hole);
+DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite_no_entry);
+DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite);
 
 TRACE_EVENT(dax_insert_mapping,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, void *radix_entry),
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
