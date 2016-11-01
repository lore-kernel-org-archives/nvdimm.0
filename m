Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DFB581D47
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 15:37:36 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 20/21] dax: Protect PTE modification on WP fault by radix tree
 entry lock
Date: Tue,  1 Nov 2016 23:36:33 +0100
Message-Id: <1478039794-20253-28-git-send-email-jack@suse.cz>
In-Reply-To: <1478039794-20253-1-git-send-email-jack@suse.cz>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently PTE gets updated in wp_pfn_shared() after dax_pfn_mkwrite()
has released corresponding radix tree entry lock. When we want to
writeprotect PTE on cache flush, we need PTE modification to happen
under radix tree entry lock to ensure consistent updates of PTE and radix
tree (standard faults use page lock to ensure this consistency). So move
update of PTE bit into dax_pfn_mkwrite().

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c    | 22 ++++++++++++++++------
 mm/memory.c |  2 +-
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 857117b6db6b..63b4cebe3f20 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -784,17 +784,27 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
-	void *entry;
+	void *entry, **slot;
 	pgoff_t index = vmf->pgoff;
 
 	spin_lock_irq(&mapping->tree_lock);
-	entry = get_unlocked_mapping_entry(mapping, index, NULL);
-	if (!entry || !radix_tree_exceptional_entry(entry))
-		goto out;
+	entry = get_unlocked_mapping_entry(mapping, index, &slot);
+	if (!entry || !radix_tree_exceptional_entry(entry)) {
+		if (entry)
+			put_unlocked_mapping_entry(mapping, index, entry);
+		spin_unlock_irq(&mapping->tree_lock);
+		return VM_FAULT_NOPAGE;
+	}
 	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
-	put_unlocked_mapping_entry(mapping, index, entry);
-out:
+	entry = lock_slot(mapping, slot);
 	spin_unlock_irq(&mapping->tree_lock);
+	/*
+	 * If we race with somebody updating the PTE and finish_mkwrite_fault()
+	 * fails, we don't care. We need to return VM_FAULT_NOPAGE and retry
+	 * the fault in either case.
+	 */
+	finish_mkwrite_fault(vmf);
+	put_locked_mapping_entry(mapping, index, entry);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
diff --git a/mm/memory.c b/mm/memory.c
index 7660f6169bee..2683e18d6d55 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2316,7 +2316,7 @@ static int wp_pfn_shared(struct vm_fault *vmf)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		vmf->flags |= FAULT_FLAG_MKWRITE;
 		ret = vma->vm_ops->pfn_mkwrite(vma, vmf);
-		if (ret & VM_FAULT_ERROR)
+		if (ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))
 			return ret;
 		return finish_mkwrite_fault(vmf);
 	}
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
