Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59A3C81D66
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 15:37:36 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 17/21] mm: Change return values of finish_mkwrite_fault()
Date: Tue,  1 Nov 2016 23:36:26 +0100
Message-Id: <1478039794-20253-21-git-send-email-jack@suse.cz>
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

Currently finish_mkwrite_fault() returns 0 when PTE got changed before
we acquired PTE lock and VM_FAULT_WRITE when we succeeded in modifying
the PTE. This is somewhat confusing since 0 generally means success, it
is also inconsistent with finish_fault() which returns 0 on success.
Change finish_mkwrite_fault() to return 0 on success and VM_FAULT_NOPAGE
when PTE changed. Practically, there should be no behavioral difference
since we bail out from the fault the same way regardless whether we
return 0, VM_FAULT_NOPAGE, or VM_FAULT_WRITE. Also note that
VM_FAULT_WRITE has no effect for shared mappings since the only two
places that check it - KSM and GUP - care about private mappings only.
Generally the meaning of VM_FAULT_WRITE for shared mappings is not well
defined and we should probably clean that up.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1517ff91c743..b3bd6b6c6472 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2296,10 +2296,10 @@ int finish_mkwrite_fault(struct vm_fault *vmf)
 	 */
 	if (!pte_same(*vmf->pte, vmf->orig_pte)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
+		return VM_FAULT_NOPAGE;
 	}
 	wp_page_reuse(vmf);
-	return VM_FAULT_WRITE;
+	return 0;
 }
 
 /*
@@ -2342,8 +2342,7 @@ static int wp_page_shared(struct vm_fault *vmf)
 			return tmp;
 		}
 		tmp = finish_mkwrite_fault(vmf);
-		if (unlikely(!tmp || (tmp &
-				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
+		if (unlikely(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
 			unlock_page(vmf->page);
 			put_page(vmf->page);
 			return tmp;
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
