Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDF04350
	for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 07:48:11 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso9801659pjb.0
        for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 00:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CiqL2201i/r2h3p8KI/NBkw6WGqzhDfT//6vVp9Lies=;
        b=bXFvZFfrI9C/L+NvtlIM0LtbMc9OI6fpHgmIV5gvdFRnQP6DfETLgq8COcZHL9qIFx
         5bzIBwfZrjgZShT0Nv6dg54gHhhnaS+mQfdF2z26zWuGr24FPRLmgQBRSiE0LFYz4OhI
         z1C9H8HtntVzRG07BglBrccoNz4ssJmAHMPjGfWDGQ35UoQhAlnZMSDwyGW2Ku/yFday
         2pQYFWEWfQKrVCP9HKKBqVxFgdWYlk4mjpKHgnJTbiluPaEdXtrU+2B9lJCccSPLEgEG
         NnoeI7zIaBwYpcQe+ULKS1L4X7Ikmta5Nes7W+xQB3j8evY6Uj7EXtFPq9iaiwoqA4Oh
         AVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CiqL2201i/r2h3p8KI/NBkw6WGqzhDfT//6vVp9Lies=;
        b=cV8pYsUT9zz2f5YEh2N8BJ/BzPyvIz9PpcI6LDL9FetA9Cvs1J7q4iYB7LXjb9V7Ws
         FriPEPP8Prlrr9lkvCHinyodt0MhU3KlO1xQJEMbJ9a/1ChYbU6M0Jt2A80EAGqKEBOz
         IxVzL6XJrlXioUoONQR4G3LeHxSshAud3UpGNJlK/0G4rRmgcGsIJyadgs/SvMykI7XJ
         CUWl5xuQrAldLQHGl1rSWA0PEN/W5SR4/F5TfdIarcBpPh/5Ask3CUbUWwTRDfNSEeOr
         YCZnGldG01h0oEe2EZjLxHgK9b6MwRDdEFGep7PAzGunKuJ6DgE+02/hgu6RPKA2eqE+
         sm0w==
X-Gm-Message-State: AOAM533V0KRcKcqjyg6OYMJM+GdQ0KSC1MEc2SFJYNTAHDBWAMcsnjgE
	I/3f1qjqFE2ON78ptclEQpmNug==
X-Google-Smtp-Source: ABdhPJx6Gb2cl0kaRKMvmsLEzJyKu4bc+A6kr/eo/U8JztFBvDzyQCyUtAKxuHv1+XJWl0bol5r0fw==
X-Received: by 2002:a17:902:cf02:b0:14f:e0c2:1514 with SMTP id i2-20020a170902cf0200b0014fe0c21514mr8557186plg.90.1647589690731;
        Fri, 18 Mar 2022 00:48:10 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f72acd4dadsm8770941pfx.81.2022.03.18.00.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 00:48:10 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 6/6] mm: simplify follow_invalidate_pte()
Date: Fri, 18 Mar 2022 15:45:29 +0800
Message-Id: <20220318074529.5261-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220318074529.5261-1-songmuchun@bytedance.com>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
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

