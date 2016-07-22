Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9DF31A1E11
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jul 2016 05:20:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 14/15] dax: Protect PTE modification on WP fault by radix tree
 entry lock
Date: Fri, 22 Jul 2016 14:19:40 +0200
Message-Id: <1469189981-19000-15-git-send-email-jack@suse.cz>
In-Reply-To: <1469189981-19000-1-git-send-email-jack@suse.cz>
References: <1469189981-19000-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently PTE gets updated in wp_pfn_shared() after dax_pfn_mkwrite()
has released corresponding radix tree entry lock. When we want to
writeprotect PTE on cache flush, we need PTE modification to happen
under radix tree entry lock to ensure consisten updates of PTE and radix
tree (standard faults use page lock to ensure this consistency). So move
update of PTE bit into dax_pfn_mkwrite().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c    | 6 ++++++
 mm/memory.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 513881431be6..e8d61ac3d148 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1218,6 +1218,12 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (!entry || !radix_tree_exceptional_entry(entry))
 		goto out;
 	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
+	/*
+	 * If we race with somebody updating the PTE and finish_mkwrite_fault()
+	 * fails, we don't care. We need to return VM_FAULT_NOPAGE and retry
+	 * the fault in either case.
+	 */
+	finish_mkwrite_fault(vma, vmf);
 	put_unlocked_mapping_entry(mapping, index, entry);
 out:
 	spin_unlock_irq(&mapping->tree_lock);
diff --git a/mm/memory.c b/mm/memory.c
index 30cf7b36df48..47241c2f6178 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2315,7 +2315,7 @@ static int wp_pfn_shared(struct mm_struct *mm,
 			 linear_page_index(vma, address),
 			 FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE, orig_pte);
 		ret = vma->vm_ops->pfn_mkwrite(vma, &vmf);
-		if (ret & VM_FAULT_ERROR)
+		if (ret & VM_FAULT_ERROR || ret & VM_FAULT_NOPAGE)
 			return ret;
 		if (finish_mkwrite_fault(vma, &vmf) < 0)
 			return 0;
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
