Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F8921A1E52
 for <linux-nvdimm@lists.01.org>; Tue, 21 Jun 2016 08:45:54 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] mm: Export follow_pte()
Date: Tue, 21 Jun 2016 17:45:14 +0200
Message-Id: <1466523915-14644-3-git-send-email-jack@suse.cz>
In-Reply-To: <1466523915-14644-1-git-send-email-jack@suse.cz>
References: <1466523915-14644-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

DAX will need to implement its own version of check_page_address(). To
avoid duplicating page table walking code, export follow_pte() which
does what we need.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h | 2 ++
 mm/memory.c        | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5df5feb49575..989f5d949db3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1193,6 +1193,8 @@ int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+int follow_pte(struct mm_struct *mm, unsigned long address, pte_t **ptepp,
+	       spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
diff --git a/mm/memory.c b/mm/memory.c
index 15322b73636b..f6175d63c2e9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3647,8 +3647,8 @@ out:
 	return -EINVAL;
 }
 
-static inline int follow_pte(struct mm_struct *mm, unsigned long address,
-			     pte_t **ptepp, spinlock_t **ptlp)
+int follow_pte(struct mm_struct *mm, unsigned long address, pte_t **ptepp,
+	       spinlock_t **ptlp)
 {
 	int res;
 
@@ -3657,6 +3657,7 @@ static inline int follow_pte(struct mm_struct *mm, unsigned long address,
 			   !(res = __follow_pte(mm, address, ptepp, ptlp)));
 	return res;
 }
+EXPORT_SYMBOL(follow_pte);
 
 /**
  * follow_pfn - look up PFN at a user virtual address
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
