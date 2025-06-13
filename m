Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15099291C2D
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749806833; cv=none; b=jNWg2G4Cezm59Dks8Fa3X+oxE7pvbnIo7+dxmBp9w6pQ+bdTzoMxCssD9jPZA2WhjyRiC4c9HcY5hAh+9DTrNsljkd9Pxp9hOPbXKI94MhCFFshaKerJ4X+P2Hug1mkJll2XttqnsasdcNL5HdpAzZoZS+ZlGiyQE2MQ3EjqhDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749806833; c=relaxed/simple;
	bh=I6rFqh4q3G6JolUrUnqDfQkAwN4FRP8LLGB+fl8jl+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Ww7yRAr9+SYR1lQkMvvYMjj2TdYCLGumUhqF/hyuSiRnKDHNf/RiaBHhkBsNppvFbnyXhkZQ4BpWUnCLf/60TVUOXOG6TsWu85TH+WBtQXmM7Om8k4cs84PvX9ceBFdOktN0gBC6Kko7ggDtTwuahcApvfxHKyl/1kn89xh4qRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K8fMnxjQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8fMnxjQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749806831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uggfBUR9d238l1g+jci/3gzcAR2fLsDD8UO38owVDeE=;
	b=K8fMnxjQm2Y+NIKPU9JcKW397dVcdPxTbApBryFfkxu4lvmxa/Popu8O1M/HR7OFXhF07R
	U8PO25jNbQf5T/4veDZUyKJSoXuUKr1G3G+DHvZjcdGM1WOlO1ZXwBt52RTkxyXLSdQirG
	OakEKAfuOMbAxm+bb4mWLw0640y2oQQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-640OOjlfM8u5t83_DGC6oQ-1; Fri, 13 Jun 2025 05:27:09 -0400
X-MC-Unique: 640OOjlfM8u5t83_DGC6oQ-1
X-Mimecast-MFC-AGG-ID: 640OOjlfM8u5t83_DGC6oQ_1749806829
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4530623eb8fso14872225e9.0
        for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 02:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749806829; x=1750411629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uggfBUR9d238l1g+jci/3gzcAR2fLsDD8UO38owVDeE=;
        b=Pe9n45jtaO2ajGQt0KUvJWdmdUiJtNNmTQsTd9TxLQZkvzYiLK2AGBSnml3RkgK1vo
         6Kd6QPbzrCsCCNs8xMeAGQ5+vdbUaTxWATQH+/7XQFoIfWV+NiSDNQLF6xbj4CiC2eu7
         ArZan4z7vyCzgJ4gQxu66tgC8kIGZb8kBC8iR+dSSyv6TIVXzdUbQsKMhLouiNizJHLR
         uW8aivlM/I66H5oUbCB7wh2JX3Cm82Dbjg4IgPiOzVG5lOyZpRbmuV5ZDBTWGIn8ztbD
         KVreV7zrMfJXNDbGyakGhS1QJ/s3/pn4BKVlmBRE1hUN5TB1CB641wIhw3abua4hDv31
         0EuA==
X-Forwarded-Encrypted: i=1; AJvYcCUhkeqygz3uzIGAVC1t/gF+MLvtGbGoixupU5TzmsAMYnW1ik2NQfGu/pDUWfD7aua9u5sSBio=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrBXVK8Ybd8Cjzj99/mSlomLcPr0LCIBiEve0wsX5f/ZNXOLSc
	FfXawOvajhiYq5H4rEc3SK2+AY90YM3scGqU1BIG+rK7ZcGovjZZ8nskknV3DShCmz1u4itTaTn
	qgqmZdIz1qsZh/yrjhLia4Q6Ci6MjcBgdYOLos3CQo6Grb5zafBMd657zToJALfS2DsHp
X-Gm-Gg: ASbGncs5jYL7qCG506HUtJ7PbsRn6oMDBGXpYCC0nN4FQDEQeQmFMuK79/Fw6rvK460
	iBslMMomKBW5fQTXeve+eLIACaGgR8IQC8ZJPB/IjINjy1R59E7L1fQKBFq0hCUXUXa1RpksGjV
	FF6QoN3Ik9cI8Mgu3igwIOXTC5XCmXkxU9Hf9zmiVM8eTkvNGliwLyWEFwcE5CqCJDsNm6ytdBc
	emjIEFC3ovunBFCopFQQp2XozKPcls/wdF8AWRt06TRo9e7/Ijir2HRGMqI3kgHwxVOfjH2Z5GE
	G292LRcMxeudskqrFA0kF412qX5bj8+6iQvVwPXU70jfAh9LVeVAjQuUj5tlLsPyUd+hFn6WXUp
	sOYzEN1s=
X-Received: by 2002:a05:600c:3555:b0:442:ffa6:d07e with SMTP id 5b1f17b1804b1-45334ae3072mr20022095e9.1.1749806828561;
        Fri, 13 Jun 2025 02:27:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+Xfy0kGImh9fcGzc/29deoEfQtCD94y9Y0vrqw5H+9WvgHxYhYPUGGxGlHloUQMOpNTtnSw==
X-Received: by 2002:a05:600c:3555:b0:442:ffa6:d07e with SMTP id 5b1f17b1804b1-45334ae3072mr20021745e9.1.1749806828156;
        Fri, 13 Jun 2025 02:27:08 -0700 (PDT)
Received: from localhost (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a568b28240sm1774029f8f.72.2025.06.13.02.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 02:27:07 -0700 (PDT)
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
Subject: [PATCH v3 2/3] mm/huge_memory: don't mark refcounted folios special in vmf_insert_folio_pmd()
Date: Fri, 13 Jun 2025 11:27:01 +0200
Message-ID: <20250613092702.1943533-3-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: FyMsXR9xKp4g0pDhFxV4QWN1oGOjJhiNGdA4dVb65yI_1749806829
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Marking PMDs that map a "normal" refcounted folios as special is
against our rules documented for vm_normal_page(): normal (refcounted)
folios shall never have the page table mapping marked as special.

Fortunately, there are not that many pmd_special() check that can be
mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
would get this wrong right now are rather harmless: e.g., none so far
bases decisions whether to grab a folio reference on that decision.

Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
implications as it seems.

Getting this right will get more important as we use
folio_normal_page_pmd() in more places.

Fix it by teaching insert_pfn_pmd() to properly handle folios and
pfns -- moving refcount/mapcount/etc handling in there, renaming it to
insert_pmd(), and distinguishing between both cases using a new simple
"struct folio_or_pfn" structure.

Use folio_mk_pmd() to create a pmd for a folio cleanly.

Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 59 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 49b98082c5401..d1e3e253c714a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1372,9 +1372,17 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	return __do_huge_pmd_anonymous_page(vmf);
 }
 
-static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
-		pgtable_t pgtable)
+struct folio_or_pfn {
+	union {
+		struct folio *folio;
+		pfn_t pfn;
+	};
+	bool is_folio;
+};
+
+static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
+		bool write, pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
@@ -1382,8 +1390,11 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	lockdep_assert_held(pmd_lockptr(mm, pmd));
 
 	if (!pmd_none(*pmd)) {
+		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
+					  pfn_t_to_pfn(fop.pfn);
+
 		if (write) {
-			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
+			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
 				return -EEXIST;
 			}
@@ -1396,11 +1407,20 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 		return -EEXIST;
 	}
 
-	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
-	if (pfn_t_devmap(pfn))
-		entry = pmd_mkdevmap(entry);
-	else
-		entry = pmd_mkspecial(entry);
+	if (fop.is_folio) {
+		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
+
+		folio_get(fop.folio);
+		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
+		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+	} else {
+		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));
+
+		if (pfn_t_devmap(fop.pfn))
+			entry = pmd_mkdevmap(entry);
+		else
+			entry = pmd_mkspecial(entry);
+	}
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -1431,6 +1451,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
 	unsigned long addr = vmf->address & PMD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
+	struct folio_or_pfn fop = {
+		.pfn = pfn,
+	};
 	pgtable_t pgtable = NULL;
 	spinlock_t *ptl;
 	int error;
@@ -1458,8 +1481,8 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	error = insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write,
-			pgtable);
+	error = insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write,
+			   pgtable);
 	spin_unlock(ptl);
 	if (error && pgtable)
 		pte_free(vma->vm_mm, pgtable);
@@ -1474,6 +1497,10 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PMD_MASK;
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio_or_pfn fop = {
+		.folio = folio,
+		.is_folio = true,
+	};
 	spinlock_t *ptl;
 	pgtable_t pgtable = NULL;
 	int error;
@@ -1491,14 +1518,8 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 	}
 
 	ptl = pmd_lock(mm, vmf->pmd);
-	if (pmd_none(*vmf->pmd)) {
-		folio_get(folio);
-		folio_add_file_rmap_pmd(folio, &folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
-	}
-	error = insert_pfn_pmd(vma, addr, vmf->pmd,
-			pfn_to_pfn_t(folio_pfn(folio)), vma->vm_page_prot,
-			write, pgtable);
+	error = insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot,
+			   write, pgtable);
 	spin_unlock(ptl);
 	if (error && pgtable)
 		pte_free(mm, pgtable);
-- 
2.49.0

