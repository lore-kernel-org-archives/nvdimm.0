Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921292D23AD
	for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 11:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911602; cv=none; b=esVwqmNtznGKTvj7qiX9stnBTM8HS/Dk8if2n1kRWaahOMwhywTW4bB2fWxwVrP5YjvIdrSFxkKP4PHT2E8MZG91O3zdfOKifX9ZEGz5g+crXQgiiCOCSXVrkUwFutTytdpnuS53m3YVxwqM9I+HbIA8vDqZ3Sj6jZBodFj+Mxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911602; c=relaxed/simple;
	bh=ZGAnHpfBp1WZBWcLrOrxfVSmjre0MJHRGXddITS2PNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LeBCRTDk99w+5M+BND9ZouIq2xBmpdtw7W2YWmyohFnln5pT5SoUoI9Rnzs+ePyBAR7BenYJKJmkci7/hvhoOJ92MnYX7YE8Iok/3QUtGdot0snnarUeDzKziXhRzvv5lhlSdpzUISOFO0LXOiVzwpMgoIiS05CLRbwgb9WqAkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VBsEmtlS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VBsEmtlS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Htya8lk0ohNZGoVKNkWH4Tb4G28S+mHG9GYTekXNGbw=;
	b=VBsEmtlSVxoNUIlWfEHfBJpYwBQF0bazLiDFvFhQ1h7PEfiEP5BQA9McX5iIFSk2zkWB7/
	i7eOertHNfKc6BxufqcWYoL+cikKYGJjuTCBeGOZNgnqZ1PeTGSMK8R/8dV+8K7WDoXbHE
	L4+3YJLrgw3mEZLrHgcQQl56+EAnOjY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-86FpS1BANh6B_Pk4Vftgaw-1; Mon, 11 Aug 2025 07:26:38 -0400
X-MC-Unique: 86FpS1BANh6B_Pk4Vftgaw-1
X-Mimecast-MFC-AGG-ID: 86FpS1BANh6B_Pk4Vftgaw_1754911598
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45526e19f43so14204995e9.3
        for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 04:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911597; x=1755516397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Htya8lk0ohNZGoVKNkWH4Tb4G28S+mHG9GYTekXNGbw=;
        b=aZAhIumnGlx/Ti/f19DagFekH3JPqeMTbyH5S1LP4kT36Q5Dzbs1X9gqFqRY5pr15z
         AHPkYfDwsDKo+51dT377jXnYS187GEVs7XcwG45+BtMpJt0aJr30r8mw5+wt0IJOQ/f9
         Cf3D/IQYhb4UYsfBXb23frVINGN8F03/H75csH3QxkOaQmNd2S/Fgv3k1Oxe+B/6cEAG
         0ZTuAXt6Bg21u6R17niBmWIAAyI2vAz0wUsPVn4RUbUV9HzOLduhewi/4oeqspMnaV3Y
         GCcoDd5drt/BOGxECuKyELzyTCe4AiJi1z9sZOe6hXMsCZiDgaxXWHjryJuk/TEtE/l0
         Rygw==
X-Forwarded-Encrypted: i=1; AJvYcCV2zg7x6WLl0tbGhm9/q9LPbjE0RZd85zrYb1wC0m5YT+mndGzKKCBPLsMnC0IMsaUKCJJ+Nus=@lists.linux.dev
X-Gm-Message-State: AOJu0YzarSJwxGAud7gIzV/z+2ndpmWCEZD26o5Hu2lGGYT+LU7ZE2Jh
	MaBJisnivpcWYwUA7iB1+V7OjbRpek0XZdKk2PrQQLB7LcFfS0ZhhQOIr95n6RLZaiIwBDtnAWY
	wxSqWOkLQRe97AL1R3f1/mP/rNHXqUnSYgVqoTQzoQ+XQnWTsKDhQa7rXow==
X-Gm-Gg: ASbGnct7ASljvevn/SoQ1pN3Y41jkjOdLHyoqoQ1Ln6GMByzTCYmQqr/HsvWIz2rYl0
	WfGjfZgpKhjSsIs3VgwX2Z5smJLBMFtVk3Gn8ldC9nCrFeHlkzTLVWCnJEoTARPnjgD1F94VYp8
	bClURMvLNGyjche/fxOtSo9LBUEV2O2w4V852lD6ZJWAeDUTlb8Cq0E9eRxosr8xUzqnGYY3Uw3
	0zontVs1H3AYJ6oUnrNWUF2KTqJgMlVYoIoZfNcoeg7lEIJYWbx6AP6KA8G3zg4aPxoXo0t9c0h
	KoROJOJIVtPGObiXb98f6j/5W1RR0vd3T/x2zUhgmSjzp+MoQZziGBpxiVXPFYftQodMeNj6Okf
	fQHJwjruFWI741Tod15Z7xAlR
X-Received: by 2002:a05:600c:458b:b0:459:e3f8:92ec with SMTP id 5b1f17b1804b1-459f4eb4176mr127958075e9.10.1754911597524;
        Mon, 11 Aug 2025 04:26:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdNxb5gc4DwQKatpkXot61uX7cGVvKpORGwTw8/tHuwPs0r2lWbt+TytrRicLCoC+zeQmPIg==
X-Received: by 2002:a05:600c:458b:b0:459:e3f8:92ec with SMTP id 5b1f17b1804b1-459f4eb4176mr127957415e9.10.1754911596965;
        Mon, 11 Aug 2025 04:26:36 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3abf33sm40550137f8f.7.2025.08.11.04.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:36 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
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
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3 01/11] mm/huge_memory: move more common code into insert_pmd()
Date: Mon, 11 Aug 2025 13:26:21 +0200
Message-ID: <20250811112631.759341-2-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KiUYC81-e9X4x4c7jZrewSioI_nvMOm6zH5rHfAjhgQ_1754911598
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's clean it all further up.

No functional change intended.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 72 ++++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d2..5314a89d676f1 100644
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
 		if (write) {
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
2.50.1

