Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717D62F2C6B
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175044; cv=none; b=PoGmzWlvjNYeDUe0bgG3ZkfR6KD47fdX20mYyZW8qH7KNSLJIJ5Px9bfMyHTfc4+mRAn+sfIT/YQ5y0GeZle8tJaery5Xp98ts+bOf5Xj5tM3/hwUieQ0zBmz5MwUIJcU8FZpWSKZovDSLSQ3cBvTtWS/Vr6ApsBysOn1J3UxmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175044; c=relaxed/simple;
	bh=iM0Xdm4e3e5wygmWbk96k2XyIm1O0G4shrhlooh7yec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=KlRQdJytzqDid+RlDd4V1ag83PGUIJReV/qsNLI2Y+NDga6mYz5GYisz0o3PyKWYVbfVX8NiX4kWotn5VuK6B5fLJdo3zPnLKotJXSmzgSkz+4imyixasyB1JuNBR3dxB7j4vdMCCxiNKJ6qOQsYB9wNthEQL77USTlBWzZP0mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RohVPAnh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RohVPAnh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5t+2oURhuR4fay2j7MSZreHj5RBEUrxIhgwh9uqVL44=;
	b=RohVPAnhl2TTGFAVrIh/akW/JrX8YrTIIW2sYUUrxT8heJnwh+Sgr52bHmoHt+b97Uf53u
	br2J3xWykApFcd/34LFVS/R3p8p19FSSkoDQomb/isEHnGOwMngRNjCrQineu56g1IHlj4
	EFD2oMhSEZzGJlly8XHS98DzTQN2pos=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-0lTLmDhoPgSPYWdZ_4OhyA-1; Tue, 17 Jun 2025 11:43:58 -0400
X-MC-Unique: 0lTLmDhoPgSPYWdZ_4OhyA-1
X-Mimecast-MFC-AGG-ID: 0lTLmDhoPgSPYWdZ_4OhyA_1750175037
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450cf229025so20945185e9.1
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175037; x=1750779837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5t+2oURhuR4fay2j7MSZreHj5RBEUrxIhgwh9uqVL44=;
        b=ONR4PPtSFGoh4avrwzRJGQkeyVDhwAwTSc5a42W782VqnwF1jwPOwsbSvJpaPbqiN9
         sARfedpJrLbhww09B2j+QJxgcBwkCUjc0dcP/QMfWv1bbMhcJTpftqAUOT+XwA/UMCbB
         NC7i+6H9kSgNYP/LwSuvxF9REpR8QV5Bp2KLHIXSNRN9e4cPKVJSZs2FJ+c0WBrgTnBc
         ZGVYK0kgYW+YmuciPfEdfeTA3BAvRHkz2UAVNkLC5eShy5Tqe/EfiVEl6E/E6er3RGfE
         0Z6SwoQCO/UkmzaQRatBJbPRK9sGDdS5jL4zwGXdR5EqDNC8jixZ9EFPIi82ujIGrqdh
         7g6w==
X-Forwarded-Encrypted: i=1; AJvYcCVAtyI6Z8xVgdzNMiSpLhAZBkNdh+0fBAYx+J3SBt639Ji+Og88ht3nywKrzclBOuWCbIsOUH8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnOQbwmD+KGZ3iPBxEKwTxjs57QCtqIGG+X9/8tcLdvYzzdMio
	310A7coiyDyTyuKuYGj85e6y3RVt52KbVKlD7cp1KF1ayrxJvlVElieir+S0I1bxNfUkPDohZV8
	la1BHVBXRVbDSJEfnB2diu4qdiZVfFS131B4Gzm8UaFSeVf205ELVBotPGw==
X-Gm-Gg: ASbGncslP+SUKuuSlt3EJ19U+dTLkaZxIR3K/GOt7HVO6LYhfhe5rCPQ2j3T1FnSlBY
	O1NUdXaubrwGKKZo4RVY0AgkzIJtGAfQeLXXh+mDxjJdQIAn0dMiDi/oAJmWCLIhZCKn0LcXism
	VU6sxbj3NG8wy8We6frex1nQGqqoooFWmDBhJ1EMhzcrCtiFP3y0Zpf1F3jv+BSsnXYsbB1vuTE
	a1y4Iya3zxCrDrIn054tOK+Y/IkE1Jm9lAYJzie4crMmBWDzwlUPI18YY1MkGNZ1DyK3SWHQ5qf
	VXe1+/RdlKGkIGL0z3U0pki9XWdWcbBiPabXo4W7PVAJ4XG5ow==
X-Received: by 2002:a05:600c:8509:b0:441:b19c:96fe with SMTP id 5b1f17b1804b1-4533caa3d54mr172176385e9.10.1750175037014;
        Tue, 17 Jun 2025 08:43:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKe6joB8XUUUHr9L6o0Yf1elMxRlblx8Zso9tX4QaAEAaXQGULg7L379TE9a6MvFpj5CfDTQ==
X-Received: by 2002:a05:600c:8509:b0:441:b19c:96fe with SMTP id 5b1f17b1804b1-4533caa3d54mr172175925e9.10.1750175036588;
        Tue, 17 Jun 2025 08:43:56 -0700 (PDT)
Received: from localhost (p57a1a266.dip0.t-ipconnect.de. [87.161.162.102])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4534226aa44sm108387495e9.13.2025.06.17.08.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:43:56 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH RFC 04/14] mm/huge_memory: move more common code into insert_pmd()
Date: Tue, 17 Jun 2025 17:43:35 +0200
Message-ID: <20250617154345.2494405-5-david@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617154345.2494405-1-david@redhat.com>
References: <20250617154345.2494405-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xs6-5ySeP4-hHLsASZvxc09lvesrsIBuEaFJM_4nSOk_1750175037
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's clean it all further up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 72 ++++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e52360df87d15..a85e0cd455109 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1379,15 +1379,25 @@ struct folio_or_pfn {
 	bool is_folio;
 };
 
-static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
+static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
-		bool write, pgtable_t pgtable)
+		bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	pgtable_t pgtable = NULL;
+	spinlock_t *ptl;
 	pmd_t entry;
 
-	lockdep_assert_held(pmd_lockptr(mm, pmd));
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
 
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (!pgtable)
+			return VM_FAULT_OOM;
+	}
+
+	ptl = pmd_lock(mm, pmd);
 	if (!pmd_none(*pmd)) {
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
@@ -1395,15 +1405,14 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		if (write && pmd_present(*pmd)) {
 			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
-				return -EEXIST;
+				goto out_unlock;
 			}
 			entry = pmd_mkyoung(*pmd);
 			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
 				update_mmu_cache_pmd(vma, addr, pmd);
 		}
-
-		return -EEXIST;
+		goto out_unlock;
 	}
 
 	if (fop.is_folio) {
@@ -1424,11 +1433,17 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (pgtable) {
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		mm_inc_nr_ptes(mm);
+		pgtable = NULL;
 	}
 
 	set_pmd_at(mm, addr, pmd, entry);
 	update_mmu_cache_pmd(vma, addr, pmd);
-	return 0;
+
+out_unlock:
+	spin_unlock(ptl);
+	if (pgtable)
+		pte_free(mm, pgtable);
+	return VM_FAULT_NOPAGE;
 }
 
 /**
@@ -1450,9 +1465,6 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 	struct folio_or_pfn fop = {
 		.pfn = pfn,
 	};
-	pgtable_t pgtable = NULL;
-	spinlock_t *ptl;
-	int error;
 
 	/*
 	 * If we had pmd_special, we could avoid all these restrictions,
@@ -1464,25 +1476,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
-
-	if (arch_needs_pgtable_deposit()) {
-		pgtable = pte_alloc_one(vma->vm_mm);
-		if (!pgtable)
-			return VM_FAULT_OOM;
-	}
-
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	error = insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write,
-			   pgtable);
-	spin_unlock(ptl);
-	if (error && pgtable)
-		pte_free(vma->vm_mm, pgtable);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
 
@@ -1491,35 +1487,15 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PMD_MASK;
-	struct mm_struct *mm = vma->vm_mm;
 	struct folio_or_pfn fop = {
 		.folio = folio,
 		.is_folio = true,
 	};
-	spinlock_t *ptl;
-	pgtable_t pgtable = NULL;
-	int error;
-
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
 
 	if (WARN_ON_ONCE(folio_order(folio) != PMD_ORDER))
 		return VM_FAULT_SIGBUS;
 
-	if (arch_needs_pgtable_deposit()) {
-		pgtable = pte_alloc_one(vma->vm_mm);
-		if (!pgtable)
-			return VM_FAULT_OOM;
-	}
-
-	ptl = pmd_lock(mm, vmf->pmd);
-	error = insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot,
-			   write, pgtable);
-	spin_unlock(ptl);
-	if (error && pgtable)
-		pte_free(mm, pgtable);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
 
-- 
2.49.0

