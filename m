Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED73D2C159C
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 09:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749806835; cv=none; b=unmQEACCqhgApxq8EUOPDzjUy8ROCWp0MI9Mw3Sf9htAeclf0/yJR5LO0GBQ/UrfAYo7pJpYnOdDXiF6x/w3qNCNj8SJUGtt7MGUauGgHDCd8BRMjgjhea78jL4kl/OW3Opgqupqjdb8nF39YuJcAi0N987jgG4JYH+xUBAfaX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749806835; c=relaxed/simple;
	bh=6tO5VYLM2T1L+Bh5vole73WL1rOpW9UksZR14TfFrDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Epak8pBYqMjkd1Pj/WhrgI8ijsirNWlugxuaPChlD/nT7WTqimInOa429x/K/PikgW5pWixjTdyKuh25hRTmYaoKjxXEQqlgU1dohHmjT6kF2wrN7+VzHiuTmGck5pRG09shqxzCqm+lK6Dk6h30qJ1MTmARXLr0X/c/EfrL/C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ec6ENrdp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ec6ENrdp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749806833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dB/Gx1sOYTj3RBFxV3FcA/SYk77nCJNbmnFBuqoX6J8=;
	b=Ec6ENrdpBAHv8b1zk1DJYigSLETok4Yd8W7mJx/CxPIZD9qgSD6NBS+RUsVkrzNuRG3i9U
	QO/LSjcQcVe7pgqalO5fR06RLe18IMnehClZAWoZTKXwHTFYVwAkGtHSkicQeysSgC8mOr
	qI3WRPHPC8W+kDzMbpwV+gqjtbGtsSk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-G1PxWxhIPDeU7Adk09k5bg-1; Fri, 13 Jun 2025 05:27:11 -0400
X-MC-Unique: G1PxWxhIPDeU7Adk09k5bg-1
X-Mimecast-MFC-AGG-ID: G1PxWxhIPDeU7Adk09k5bg_1749806830
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4edf5bb4dso1491897f8f.0
        for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 02:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749806830; x=1750411630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dB/Gx1sOYTj3RBFxV3FcA/SYk77nCJNbmnFBuqoX6J8=;
        b=vrOV3uKOq1A0kvE2nc7IuwGtGaqsssjfyhXhKJqaFLzbja7QF3szEivfRkVzoSO1TC
         qf86tz7gow08qovTi3F5NiJlALZh2yUX52GWS1CdR4UJaK7tISKE00j/iE8rpFKwMFki
         SwdWS36VBqZUtob7sdQjN+mc5KfKx9dPXeyVoqqfGyP6kFGVhIFPI0XF1CtOnlp4RkSJ
         RGV8pvA7WXuHnEL9yhzzqNi4Br7tUlTaiLoP0fXf88Y+I4qWgUnfeD429YlG9B/ZwfxC
         TGuNtBr6EDKUj8D/u4PtvN3iCGR4UxyNIiRfMGh/Rd+WVJrv89gVx3DKBofw1/267Y8S
         YzPA==
X-Forwarded-Encrypted: i=1; AJvYcCXIl6vWU2n/lLB4+IvkmieBfUH6BgOrZ0e71NmTL4xbS60ILmBonhNKYWP30Ltpja1vzuQr374=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhfG2fxY68XWdfaMJ4fyFtbVuZdDMydz/LNT047Oq+v1tMaAIe
	jaADaGSmUU3lwcOD6fI++v9lwB8ByiF1ym4hj2DFojdxtGHz/hcwxXdT3IIFMGMVuMe40naX93A
	ExoeijzyvBcf79MIYGs1n04DaTtuGyYHRqRPunf4PQkw4fQPfC6wuSzrIjw==
X-Gm-Gg: ASbGnctU2TkY5grnj+TDyiy4AIs37LBdAwaYGhpghSPjJaOBUwOediuwGug+oGKjT6H
	+xueOuGeOCZoJrViOyqwyOSyXrHrVYFspFvpwLQDT8lGTykybGucvdwBdkst0izQk7HIf5eqygO
	2mIrZ/Pcm1a3c95v2IbMzkGjxVHqPZ3wVtrJL6eNWyMP7BLvkwNPHaQ5mmK+Rcrpi8cpYB1RJzO
	QC3eeRhQqPKh0qcOkOdqdt0q7BAGCUeQVZanD5mPCEIZkhLaHuvpqX1H369Ad7IaQ6kDZ7x4Cc4
	D+lUzATUQ1eEvN/7KjZU2gSh1vRHiWhqaajvXswozgJ6mm6oDLDskgxAjqk5DWxE11/naiDT4Aq
	7D6ZP3aw=
X-Received: by 2002:a05:6000:24c8:b0:3a4:f787:9b58 with SMTP id ffacd0b85a97d-3a56874a137mr2481374f8f.58.1749806830405;
        Fri, 13 Jun 2025 02:27:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqj6NdODj43XbLFVDeV1qD7UYHV1rn0TfwsC4tf99O0oNc/40w2gplW02JFKnmYY0c01aDOg==
X-Received: by 2002:a05:6000:24c8:b0:3a4:f787:9b58 with SMTP id ffacd0b85a97d-3a56874a137mr2481334f8f.58.1749806829879;
        Fri, 13 Jun 2025 02:27:09 -0700 (PDT)
Received: from localhost (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a5689e5f3dsm1827987f8f.0.2025.06.13.02.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 02:27:09 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 3/3] mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pud()
Date: Fri, 13 Jun 2025 11:27:02 +0200
Message-ID: <20250613092702.1943533-4-david@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613092702.1943533-1-david@redhat.com>
References: <20250613092702.1943533-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 80FM8a0AHWyfSHgxpIksBL952668DwGBMfM87QVMwrU_1749806830
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Marking PUDs that map a "normal" refcounted folios as special is
against our rules documented for vm_normal_page(). normal (refcounted)
folios shall never have the page table mapping marked as special.

Fortunately, there are not that many pud_special() check that can be
mislead and are right now rather harmless: e.g., none so far
bases decisions whether to grab a folio reference on that decision.

Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
implications as it seems.

Getting this right will get more important as we introduce
folio_normal_page_pud() and start using it in more place where we
currently special-case based on other VMA flags.

Fix it just like we fixed vmf_insert_folio_pmd().

Add folio_mk_pud() to mimic what we do with folio_mk_pmd().

Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 19 ++++++++++++++++-
 mm/huge_memory.c   | 52 ++++++++++++++++++++++++++--------------------
 2 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa538feaa8d95..912b6d40a12d6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1816,7 +1816,24 @@ static inline pmd_t folio_mk_pmd(struct folio *folio, pgprot_t pgprot)
 {
 	return pmd_mkhuge(pfn_pmd(folio_pfn(folio), pgprot));
 }
-#endif
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+/**
+ * folio_mk_pud - Create a PUD for this folio
+ * @folio: The folio to create a PUD for
+ * @pgprot: The page protection bits to use
+ *
+ * Create a page table entry for the first page of this folio.
+ * This is suitable for passing to set_pud_at().
+ *
+ * Return: A page table entry suitable for mapping this folio.
+ */
+static inline pud_t folio_mk_pud(struct folio *folio, pgprot_t pgprot)
+{
+	return pud_mkhuge(pfn_pud(folio_pfn(folio), pgprot));
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif /* CONFIG_MMU */
 
 static inline bool folio_has_pincount(const struct folio *folio)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d1e3e253c714a..bbc1dab98f2f7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1536,15 +1536,18 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 	return pud;
 }
 
-static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
+static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
+		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pud_t entry;
 
 	if (!pud_none(*pud)) {
+		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
+					  pfn_t_to_pfn(fop.pfn);
+
 		if (write) {
-			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
+			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
 				return;
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
@@ -1554,11 +1557,20 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 		return;
 	}
 
-	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
-	if (pfn_t_devmap(pfn))
-		entry = pud_mkdevmap(entry);
-	else
-		entry = pud_mkspecial(entry);
+	if (fop.is_folio) {
+		entry = folio_mk_pud(fop.folio, vma->vm_page_prot);
+
+		folio_get(fop.folio);
+		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
+		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
+	} else {
+		entry = pud_mkhuge(pfn_t_pud(fop.pfn, prot));
+
+		if (pfn_t_devmap(fop.pfn))
+			entry = pud_mkdevmap(entry);
+		else
+			entry = pud_mkspecial(entry);
+	}
 	if (write) {
 		entry = pud_mkyoung(pud_mkdirty(entry));
 		entry = maybe_pud_mkwrite(entry, vma);
@@ -1582,6 +1594,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
 	unsigned long addr = vmf->address & PUD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
+	struct folio_or_pfn fop = {
+		.pfn = pfn,
+	};
 	spinlock_t *ptl;
 
 	/*
@@ -1601,7 +1616,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
+	insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
@@ -1623,6 +1638,10 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 	unsigned long addr = vmf->address & PUD_MASK;
 	pud_t *pud = vmf->pud;
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio_or_pfn fop = {
+		.folio = folio,
+		.is_folio = true,
+	};
 	spinlock_t *ptl;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -1632,20 +1651,7 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 		return VM_FAULT_SIGBUS;
 
 	ptl = pud_lock(mm, pud);
-
-	/*
-	 * If there is already an entry present we assume the folio is
-	 * already mapped, hence no need to take another reference. We
-	 * still call insert_pfn_pud() though in case the mapping needs
-	 * upgrading to writeable.
-	 */
-	if (pud_none(*vmf->pud)) {
-		folio_get(folio);
-		folio_add_file_rmap_pud(folio, &folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
-	}
-	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
-		       vma->vm_page_prot, write);
+	insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
-- 
2.49.0

