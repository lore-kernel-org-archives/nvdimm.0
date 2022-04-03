Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6841FBD
	for <nvdimm@lists.linux.dev>; Sun,  3 Apr 2022 05:41:53 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id o13so5657380pgc.12
        for <nvdimm@lists.linux.dev>; Sat, 02 Apr 2022 22:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pquxx3qH2nuqmnC96VcgoZZu7sN0crimqByO4QYpxLI=;
        b=GHXKTG43kCR2umCkJhnnOQOd88LUpFg6cViEu00MVxJOQ2rWmTplbsf/IitrWYgSHd
         rZxvN/NrO90+8edNTpRLUynQfaGmARDAqr7zPpmiFS11Zrt4utAean69PdTj48CP2KO0
         C5qyBBPUy5KOw8921uFQf2iytsaH6zuZ3pyqapbrDeq88E4SSxXCc7EyvkNl5vo54R1l
         fCVL47Tl6nwHugt2GPYTiUmBUhoaThzL8bnjc4/Z2pj3JDrHgH71JOIbTI+YZfc35Oa3
         KcBQBW6V5LTYIJwGJ+N5eQgB5TKPUw42FBmGGibFyKJz3RR6hG8pbyWZyxD5D0pLvbQX
         D4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pquxx3qH2nuqmnC96VcgoZZu7sN0crimqByO4QYpxLI=;
        b=erGFUPobrEwm0rUMrMPkYzCgGGoLbkAwxsQZ4m3DuKySyWqgwd3Rh6uUeaqjBOjQ1b
         XkMaaOW2pcNWE6Uyh8U+LopQ4Yn7eNSwSjykF4IOB2I8tzvizsKycLNUDm+XNMdGO/lW
         s/4ef9Osrz9kOVhKVuiAEaPVnZUANz7+eY9wsnLwNc1iXNjUbMgLhAcUoqNunpnfLEV3
         C2lOnCLq0cflK6mWWKNuzicmFEzS8ZcQFela13ID1dCpitizymvR9ZQko2vIqsela0xa
         B0F2tgwbwamYbmVpj3pGat5e0sk3c8m425abB2WR2a0ypKqK9I489LnQhHIKLn9zGrk+
         ng3w==
X-Gm-Message-State: AOAM532k2cpjaf8lFt47IAnMvuITMwIhHb0eVM6lYZD/y7izxsqv7y8X
	jfYy77rZYkYArNl7jeeNndkCOQ==
X-Google-Smtp-Source: ABdhPJx2ieH8dT2jPBxFH/WIhN69bGTVTj3Q7+m7G0MbpiKUgbWZgnzMYMsn0NXOrADeD3t2AWF1qA==
X-Received: by 2002:a62:e215:0:b0:4fa:87f1:dc16 with SMTP id a21-20020a62e215000000b004fa87f1dc16mr18414877pfi.19.1648964513366;
        Sat, 02 Apr 2022 22:41:53 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm8262479pfx.34.2022.04.02.22.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 22:41:53 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	shy828301@gmail.com,
	rcampbell@nvidia.com,
	hughd@google.com,
	xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com,
	zwisler@kernel.org,
	hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	duanxiongchun@bytedance.com,
	smuchun@gmail.com,
	Muchun Song <songmuchun@bytedance.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 6/6] mm: simplify follow_invalidate_pte()
Date: Sun,  3 Apr 2022 13:39:57 +0800
Message-Id: <20220403053957.10770-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220403053957.10770-1-songmuchun@bytedance.com>
References: <20220403053957.10770-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only user (DAX) of range and pmdpp parameters of follow_invalidate_pte()
is gone, it is safe to remove them and make it static to simlify the code.
This is revertant of the following commits:

  097963959594 ("mm: add follow_pte_pmd()")
  a4d1a8852513 ("dax: update to new mmu_notifier semantic")

There is only one caller of the follow_invalidate_pte().  So just fold it
into follow_pte() and remove it.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mm.h |  3 --
 mm/memory.c        | 81 ++++++++++++++++--------------------------------------
 2 files changed, 23 insertions(+), 61 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c9bada4096ac..be7ec4c37ebe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1871,9 +1871,6 @@ void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
diff --git a/mm/memory.c b/mm/memory.c
index cc6968dc8e4e..84f7250e6cd1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4964,9 +4964,29 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp)
+/**
+ * follow_pte - look up PTE at a user virtual address
+ * @mm: the mm_struct of the target address space
+ * @address: user virtual address
+ * @ptepp: location to store found PTE
+ * @ptlp: location to store the lock for the PTE
+ *
+ * On a successful return, the pointer to the PTE is stored in @ptepp;
+ * the corresponding lock is taken and its location is stored in @ptlp.
+ * The contents of the PTE are only stable until @ptlp is released;
+ * any further use, if any, must be protected against invalidation
+ * with MMU notifiers.
+ *
+ * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
+ * should be taken for read.
+ *
+ * KVM uses this function.  While it is arguably less bad than ``follow_pfn``,
+ * it is not a good general-purpose API.
+ *
+ * Return: zero on success, -ve otherwise.
+ */
+int follow_pte(struct mm_struct *mm, unsigned long address,
+	       pte_t **ptepp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4989,35 +5009,9 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
 	pmd = pmd_offset(pud, address);
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 
-	if (pmd_huge(*pmd)) {
-		if (!pmdpp)
-			goto out;
-
-		if (range) {
-			mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0,
-						NULL, mm, address & PMD_MASK,
-						(address & PMD_MASK) + PMD_SIZE);
-			mmu_notifier_invalidate_range_start(range);
-		}
-		*ptlp = pmd_lock(mm, pmd);
-		if (pmd_huge(*pmd)) {
-			*pmdpp = pmd;
-			return 0;
-		}
-		spin_unlock(*ptlp);
-		if (range)
-			mmu_notifier_invalidate_range_end(range);
-	}
-
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto out;
 
-	if (range) {
-		mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
-					address & PAGE_MASK,
-					(address & PAGE_MASK) + PAGE_SIZE);
-		mmu_notifier_invalidate_range_start(range);
-	}
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
 	if (!pte_present(*ptep))
 		goto unlock;
@@ -5025,38 +5019,9 @@ int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, *ptlp);
-	if (range)
-		mmu_notifier_invalidate_range_end(range);
 out:
 	return -EINVAL;
 }
-
-/**
- * follow_pte - look up PTE at a user virtual address
- * @mm: the mm_struct of the target address space
- * @address: user virtual address
- * @ptepp: location to store found PTE
- * @ptlp: location to store the lock for the PTE
- *
- * On a successful return, the pointer to the PTE is stored in @ptepp;
- * the corresponding lock is taken and its location is stored in @ptlp.
- * The contents of the PTE are only stable until @ptlp is released;
- * any further use, if any, must be protected against invalidation
- * with MMU notifiers.
- *
- * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
- * should be taken for read.
- *
- * KVM uses this function.  While it is arguably less bad than ``follow_pfn``,
- * it is not a good general-purpose API.
- *
- * Return: zero on success, -ve otherwise.
- */
-int follow_pte(struct mm_struct *mm, unsigned long address,
-	       pte_t **ptepp, spinlock_t **ptlp)
-{
-	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
-}
 EXPORT_SYMBOL_GPL(follow_pte);
 
 /**
-- 
2.11.0

