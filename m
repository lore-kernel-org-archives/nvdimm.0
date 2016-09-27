Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 257221A1E15
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:08:34 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/20] mm: Use pass vm_fault structure for in wp_pfn_shared()
Date: Tue, 27 Sep 2016 18:08:10 +0200
Message-Id: <1474992504-20133-7-git-send-email-jack@suse.cz>
In-Reply-To: <1474992504-20133-1-git-send-email-jack@suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Instead of creating another vm_fault structure, use the one passed to
wp_pfn_shared() for passing arguments into pfn_mkwrite handler.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ba7760fb7db2..48de8187d7b2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2273,16 +2273,11 @@ static int wp_pfn_shared(struct vm_fault *vmf, pte_t orig_pte)
 	struct vm_area_struct *vma = vmf->vma;
 
 	if (vma->vm_ops && vma->vm_ops->pfn_mkwrite) {
-		struct vm_fault vmf2 = {
-			.page = NULL,
-			.pgoff = vmf->pgoff,
-			.virtual_address = vmf->address & PAGE_MASK,
-			.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE,
-		};
 		int ret;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		ret = vma->vm_ops->pfn_mkwrite(vma, &vmf2);
+		vmf->flags |= FAULT_FLAG_MKWRITE;
+		ret = vma->vm_ops->pfn_mkwrite(vma, vmf);
 		if (ret & VM_FAULT_ERROR)
 			return ret;
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
