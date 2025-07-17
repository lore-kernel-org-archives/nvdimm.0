Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F6B29B77B
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753142; cv=none; b=mWdUJu0z0NpmD9y472kUnc9l7PPXGRyn2NP//5I3I7lcqIXhP+NTFKEmd/bJ2RfYwx66NUDcg349xBWywMKUeQ5NCl0qNJMYg7JVCe37WVVQBadguQZ+U3hVYrYAL6BOKE4zRLnzOl0zUpfiToACFvXqOOvCxTf2czSXGrFUW74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753142; c=relaxed/simple;
	bh=IDYUE1mlBZ4qeAnXwwqLmIQJkJvDRguy41kJWq4WCn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=L8ymFMNVRfeMCYUZPRK2gO7b5k7x2LiWz1KE9QhjLG00PRZldu2flAV1Y9yeb00P8dLsApjdLVsJeZ/djM4Dfc7TsBC+4RKiYrznL9k90BX71+YIycxH8y799l0ynTiDDA8sffXbW84BCX+sQfJ7H0MJLZ7jv4sxLQ5kmirMpFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VC8Yj1n3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VC8Yj1n3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIbOZw1x2GVZdwaR5iaeVsCQGMgTtSbEtHQ5YhAco0w=;
	b=VC8Yj1n3/Go+9z1CzVsNtaR+4LPZsJzQl8V7yrDX62sXKGX7GSxO9Zlh7B5ayjVYp/920X
	aY/MRFOVSzCKSIGAl/bgf0+5BecZsmCAPzz8V5rgUfoAsNFEgqC9lUz/Zudec3N9m+oIyG
	svFuYeHKDJINkC+Zv5PPwDAGS4nq7xc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-U5qcvbldMfK0fIn8jIMqpA-1; Thu, 17 Jul 2025 07:52:19 -0400
X-MC-Unique: U5qcvbldMfK0fIn8jIMqpA-1
X-Mimecast-MFC-AGG-ID: U5qcvbldMfK0fIn8jIMqpA_1752753138
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso5224595e9.0
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753138; x=1753357938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zIbOZw1x2GVZdwaR5iaeVsCQGMgTtSbEtHQ5YhAco0w=;
        b=IBX6iGJCyOaY2PAG/F1ok+HgIYRqc6a0rRwrRaQF+TESKqZDpORu8T2xR1LpJMfkER
         zuGdXXbu7IQqLeJThU7+h60PmscE+G/WPsNqK6BVvmN40mlFJs9WxAxkXnHB/4Cag9tI
         F4WTms8QnrRdd2ymW20n15EskyAArqFDrDiKghb71XBl2zNK4nhtv4kqesO1I2vjTJDk
         M8oSvrpIAuarFogp3QTR2CxT/UDoxC9JnVfI5uRTPh7AKSWEGyBSj+qx2P5kaEDavE1f
         U5vsE8037nR8H1BSWM5OIBjyowDB0til+bv3bzO3EReEm//P95t/gzlkqJe24LV+/sCY
         kwoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE5GhpG7J1k4uuTxZF85MF6192WNaSi8shAUDlCPaU/WM0Mgo5qkPcJwe8BhDTLapb3CzQnD4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9QUqqJWBhnuL0vEXc6ICZPPvaRgzFxutPEEoMD67cKjctbYbZ
	I06iAc/6rtszKyqOC7SvPk/jdcuV32hz2ttHQFTMHneetvLd/EINYPns+oOwxsV0abFGb6MsIH4
	VkuCN0wI1wG0uTAtNc/oThj64j0nVt+X1cGiyPectSgrzhW3ThEQ4tnP+Ig==
X-Gm-Gg: ASbGncswod6rzCqbTIQ3L6X+xdFBoDcmTgGQbJ8g3j2Qp8syzFqwqjB5R9eZzxzFUgy
	GLgaodo0n+3N3csSNOUlFR6BAlmnqZG5i/unk8P51PIapYSUkvPvX7YXdZ2aTmoY0h6ghNNtnlM
	XCoWPaolNAGWHYqChO2T2qb38NwHelOUkX63ZVZaoppZWx4z/F/oCtxc35vXDwDFmb22pHbnVu9
	EjdtTPy1Tm+C287wAdduKQYIUGpOeUd698VuXVUgm+mkNF/PDKKvbBclRvXSYW7lw/ZDDPD6Ww/
	6bJJu50LCRciyMxW4dCXj0xkS4S3Cbd0V1LNh+BCqivI3xgH1CZUFaxI7cBO4jqmZE/YjiPE/U+
	DApBmnwnSfYuHo0skPuVGBXc=
X-Received: by 2002:a05:600c:3e15:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-4562e39865dmr69601955e9.30.1752753137821;
        Thu, 17 Jul 2025 04:52:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExNej71yyxo4EvVsey/pvqYl543s0okqsAtiv/nbzqOk+Nei3ADHbojZnjuyE7SwluE3g0Pw==
X-Received: by 2002:a05:600c:3e15:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-4562e39865dmr69601365e9.30.1752753137339;
        Thu, 17 Jul 2025 04:52:17 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45634f8cc6esm20532295e9.26.2025.07.17.04.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:16 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 1/9] mm/huge_memory: move more common code into insert_pmd()
Date: Thu, 17 Jul 2025 13:52:04 +0200
Message-ID: <20250717115212.1825089-2-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250717115212.1825089-1-david@redhat.com>
References: <20250717115212.1825089-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: We1GVEV6prU0SV9DQ_b8MHP2iMctkZZx8-6zcvWqlxI_1752753138
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's clean it all further up.

No functional change intended.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 72 ++++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fe17b0a157cda..1178760d2eda4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1390,15 +1390,25 @@ struct folio_or_pfn {
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
@@ -1406,15 +1416,14 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
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
@@ -1435,11 +1444,17 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
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
@@ -1461,9 +1476,6 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 	struct folio_or_pfn fop = {
 		.pfn = pfn,
 	};
-	pgtable_t pgtable = NULL;
-	spinlock_t *ptl;
-	int error;
 
 	/*
 	 * If we had pmd_special, we could avoid all these restrictions,
@@ -1475,25 +1487,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
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
 
@@ -1502,35 +1498,15 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
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

