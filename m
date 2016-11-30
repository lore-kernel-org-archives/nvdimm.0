Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D22D81EFA
 for <linux-nvdimm@lists.01.org>; Wed, 30 Nov 2016 15:45:55 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 2/6] dax: remove leading space from labels
Date: Wed, 30 Nov 2016 16:45:29 -0700
Message-Id: <1480549533-29038-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

No functional change.

As of this commit:

commit 218dd85887da (".gitattributes: set git diff driver for C source code
files")

git-diff and git-format-patch both generate diffs whose hunks are correctly
prefixed by function names instead of labels, even if those labels aren't
indented with spaces.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index be39633..b14335c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -422,7 +422,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		return page;
 	}
 	entry = lock_slot(mapping, slot);
- out_unlock:
+out_unlock:
 	spin_unlock_irq(&mapping->tree_lock);
 	return entry;
 }
@@ -557,7 +557,7 @@ static int dax_load_hole(struct address_space *mapping, void **entry,
 				   vmf->gfp_mask | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
- out:
+out:
 	vmf->page = page;
 	ret = finish_fault(vmf);
 	vmf->page = NULL;
@@ -659,7 +659,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 	}
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
- unlock:
+unlock:
 	spin_unlock_irq(&mapping->tree_lock);
 	if (hole_fill) {
 		radix_tree_preload_end();
@@ -812,12 +812,12 @@ static int dax_writeback_one(struct block_device *bdev,
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
 	spin_unlock_irq(&mapping->tree_lock);
- unmap:
+unmap:
 	dax_unmap_atomic(bdev, &dax);
 	put_locked_mapping_entry(mapping, index, entry);
 	return ret;
 
- put_unlocked:
+put_unlocked:
 	put_unlocked_mapping_entry(mapping, index, entry2);
 	spin_unlock_irq(&mapping->tree_lock);
 	return ret;
@@ -1194,11 +1194,11 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		break;
 	}
 
- error_unlock_entry:
+error_unlock_entry:
 	vmf_ret = dax_fault_return(error) | major;
- unlock_entry:
+unlock_entry:
 	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
- finish_iomap:
+finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PAGE_SIZE;
 
@@ -1255,7 +1255,7 @@ static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
 
 	return vmf_insert_pfn_pmd(vma, address, pmd, dax.pfn, write);
 
- unmap_fallback:
+unmap_fallback:
 	dax_unmap_atomic(bdev, &dax);
 	return VM_FAULT_FALLBACK;
 }
@@ -1379,9 +1379,9 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		break;
 	}
 
- unlock_entry:
+unlock_entry:
 	put_locked_mapping_entry(mapping, pgoff, entry);
- finish_iomap:
+finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PMD_SIZE;
 
@@ -1396,7 +1396,7 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		ops->iomap_end(inode, pos, PMD_SIZE, copied, iomap_flags,
 				&iomap);
 	}
- fallback:
+fallback:
 	if (result == VM_FAULT_FALLBACK) {
 		split_huge_pmd(vma, pmd, address);
 		count_vm_event(THP_FAULT_FALLBACK);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
