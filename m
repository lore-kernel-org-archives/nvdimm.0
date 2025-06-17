Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A1A2EA14C
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175059; cv=none; b=Bf5VnYlKNwKj6JCRxNyBbdvpAo8RXOls2e0weXvjrZzEdIa1fTSM7pnK4Zy1UNlBHXYCoAEto61M4JogDOCuZfvkfAEi+Hhu0lDaJzJeigZSij+JTSatJ3Pl2KEJ4YI5reuW3nq6IxW3SOrjwGq0aTtjDR0yikKQMhbxHXfHyPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175059; c=relaxed/simple;
	bh=CpTPvCWCiY6s8YcaOvOWvnzj3sq5tS5GAvvZ9Q2kmdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=K5wdaL6AXq+aREGay4pIK2KFDb8fXNkiIA1H11pPSoxGG9YBx51IjUjjI1RvNj6m6598bEId8kW3NJrC0m9nktzUfwRCF7XywJ9dMjjA4pf5Yy6O1/5vxYaInp/p4c94PZsOqeeRHGGluikzloeVXFyvKBdUcA3hQnka74oGy44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wmf9imyO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wmf9imyO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8nQwds7Yyk6JA3H6HqbSBsBU+gjLOchhVzRWSpa3UwQ=;
	b=Wmf9imyOGlDiYlmvT86N5sesJUeXU0CMi9trbplXJ3FdVeHf9fyFEWQq0OJylMy4WwqXzy
	PMGGjSl3GpsDQ3b0edxCVspvzaRvA3GThV7p56x3ZoZ/UJf2UlZNhB/fEQ5+oRGg5IkkOL
	jpdLW4ezUHH1bIA21htOewi7svspRpw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-YDul1KhmNkeSlA3rHqHQbg-1; Tue, 17 Jun 2025 11:44:12 -0400
X-MC-Unique: YDul1KhmNkeSlA3rHqHQbg-1
X-Mimecast-MFC-AGG-ID: YDul1KhmNkeSlA3rHqHQbg_1750175051
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4e713e05bso2687279f8f.3
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175051; x=1750779851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8nQwds7Yyk6JA3H6HqbSBsBU+gjLOchhVzRWSpa3UwQ=;
        b=tJYFoBPxEcjwX5HIZZ6zG4+wT5nWv//GJX74DjTWLiiSggHQ/ouHWA2ifcmTjbFUQU
         45jVokZMZ8Q5HFJz9FP/p8B7lLiJ1hHIns3uVzDtXZRyfsQpOy/bTDQ9dCg/rmA0FUiV
         c5HRhQZtv00q8QGygrlO0mEOq5V1ywZTGWs4z9twOPaJ05VwX1slgRbz2loIFgUUdkw3
         4F7j96GPYCeaCxZ/ClNlm/5zOiz0JDej2NM1M54ICQjRgKp+dizShCd1dnW5fJ8HtLdv
         EfrG95nnHUJs5FuMnBHBOE9eYG8iHWFZCYED6pi5uYdr5i7rujsJpCtqb6HaaBKA+wco
         /MPg==
X-Forwarded-Encrypted: i=1; AJvYcCWYGqLdXn2vXzASo+uSIMLGSCiQe9fWSdfOIOgr0ycx5plCw6JWDOh9Um5sTcjjWgaETG4SLA8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBEG70G17wUtWrpRKEWPDmbC7BuCgjWwnBy5PEPwQ0VZfCo3dT
	RVDQkf9oFnA4jWoh1ayemOSpOG73Wz7kR9GdAz488kryV1/3Thd/AqB6tA1CmjShjWsPM6urfUH
	gO/i5DcNUowwblcZy+V0q7LVUsuK3mLI7JzBa8v5oQv8CQhDtmA5QRgZF7A==
X-Gm-Gg: ASbGncu3yqsPPNRAkmw+YiID7PHrWrp9kliEjHVl2hw6poTYKSvbgMiqg1R6mmCcf0a
	ThJ0X50tgrvKVcI4sf1LmmqkCmzCtYve/Z7w6yRorLb6jx7e/qzOKhWSWEuul8Ve5ri52bgJPSW
	PuYKYVeLCsfuufX3bH+9E3DzTqTQ9eZk265c2kg4Lqx5dLoc2SWejMqrooWfpZlKLUcQ+cDjIc4
	SngjThhkGHxIHg+nj+eLBeGIV+41gZidetp0pI+3nBO6omFKYKMQViRfRpwTcIYB67D4BAUOtmI
	qcXLhxIDeoeJgw0hSfhGGk0Hu8zJttYw/WHXKpFHevuVvA07Eptz3n+Obs5vxT5UBp3Jt8xvN/Y
	p4/Zviw==
X-Received: by 2002:a05:6000:4282:b0:3a4:fefb:c8d3 with SMTP id ffacd0b85a97d-3a5723af0aamr11566039f8f.40.1750175051237;
        Tue, 17 Jun 2025 08:44:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/V6oFuqHOfr5zNP3xy/su55zH7TFZMZO7NjqgYAqVSSsBW8t2gqFSXD3CPoL3K9BbxYOdvQ==
X-Received: by 2002:a05:6000:4282:b0:3a4:fefb:c8d3 with SMTP id ffacd0b85a97d-3a5723af0aamr11566020f8f.40.1750175050826;
        Tue, 17 Jun 2025 08:44:10 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a568b087f8sm14566243f8f.53.2025.06.17.08.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:44:10 -0700 (PDT)
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
Subject: [PATCH RFC 10/14] mm/memory: factor out common code from vm_normal_page_*()
Date: Tue, 17 Jun 2025 17:43:41 +0200
Message-ID: <20250617154345.2494405-11-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: ZewAe3Q6j05qBj1dGJLfgpZq_7OQsM-3rg1sT4FN8QI_1750175051
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's reduce the code duplication and factor out the non-pte/pmd related
magic into vm_normal_page_pfn().

To keep it simpler, check the pfn against both zero folios. We could
optimize this, but as it's only for the !CONFIG_ARCH_HAS_PTE_SPECIAL
case, it's not a compelling micro-optimization.

With CONFIG_ARCH_HAS_PTE_SPECIAL we don't have to check anything else,
really.

It's a good question if we can even hit the !CONFIG_ARCH_HAS_PTE_SPECIAL
scenario in the PMD case in practice: but doesn't really matter, as
it's now all unified in vm_normal_page_pfn().

While at it, add a check that pmd_special() is really only set where we
would expect it.

No functional change intended.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 104 +++++++++++++++++++++++-----------------------------
 1 file changed, 46 insertions(+), 58 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b6c069f4ad11f..3d3fa01cd217e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -536,6 +536,46 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
+/* Called only if the page table entry is not marked special. */
+static inline struct page *vm_normal_page_pfn(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn)
+{
+	/*
+	 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table mappings
+	 * (incl. shared zero folios) are marked accordingly.
+	 */
+	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL))
+		goto normal_page;
+
+	if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {
+		if (vma->vm_flags & VM_MIXEDMAP) {
+			/* If it has a "struct page", it's "normal". */
+			if (!pfn_valid(pfn))
+				return NULL;
+		} else {
+			unsigned long off = (addr - vma->vm_start) >> PAGE_SHIFT;
+
+			/* Only CoW'ed anon folios are "normal". */
+			if (pfn == vma->vm_pgoff + off)
+				return NULL;
+			if (!is_cow_mapping(vma->vm_flags))
+				return NULL;
+		}
+	}
+
+	if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
+		return NULL;
+
+normal_page:
+	/*
+	 * NOTE! We still have PageReserved() pages in the page tables.
+	 * For example, VDSO mappings can cause them to exist.
+	 */
+	VM_WARN_ON_ONCE(!pfn_valid(pfn));
+	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
+	return pfn_to_page(pfn);
+}
+
 /*
  * vm_normal_page -- This function gets the "struct page" associated with a pte.
  *
@@ -591,9 +631,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 {
 	unsigned long pfn = pte_pfn(pte);
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
-		if (likely(!pte_special(pte)))
-			goto out;
+	if (unlikely(pte_special(pte))) {
 		if (vma->vm_ops && vma->vm_ops->find_special_page)
 			return vma->vm_ops->find_special_page(vma, addr);
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
@@ -604,34 +642,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
-
-	/* !CONFIG_ARCH_HAS_PTE_SPECIAL case follows: */
-
-	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
-		if (vma->vm_flags & VM_MIXEDMAP) {
-			if (!pfn_valid(pfn))
-				return NULL;
-		} else {
-			unsigned long off;
-			off = (addr - vma->vm_start) >> PAGE_SHIFT;
-			if (pfn == vma->vm_pgoff + off)
-				return NULL;
-			if (!is_cow_mapping(vma->vm_flags))
-				return NULL;
-		}
-	}
-
-	if (is_zero_pfn(pfn))
-		return NULL;
-
-	/*
-	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
-	 */
-out:
-	VM_WARN_ON_ONCE(!pfn_valid(pfn));
-	VM_WARN_ON_ONCE(is_zero_pfn(pfn));
-	return pfn_to_page(pfn);
+	return vm_normal_page_pfn(vma, addr, pfn);
 }
 
 struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
@@ -650,35 +661,12 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
-	/* Currently it's only used for huge pfnmaps */
-	if (unlikely(pmd_special(pmd)))
+	if (unlikely(pmd_special(pmd))) {
+		VM_WARN_ON_ONCE(!(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)) &&
+				!is_huge_zero_pfn(pfn));
 		return NULL;
-
-	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
-		if (vma->vm_flags & VM_MIXEDMAP) {
-			if (!pfn_valid(pfn))
-				return NULL;
-			goto out;
-		} else {
-			unsigned long off;
-			off = (addr - vma->vm_start) >> PAGE_SHIFT;
-			if (pfn == vma->vm_pgoff + off)
-				return NULL;
-			if (!is_cow_mapping(vma->vm_flags))
-				return NULL;
-		}
 	}
-
-	if (is_huge_zero_pfn(pfn))
-		return NULL;
-
-	/*
-	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
-	 */
-out:
-	VM_WARN_ON_ONCE(!pfn_valid(pfn));
-	return pfn_to_page(pfn);
+	return vm_normal_page_pfn(vma, addr, pfn);
 }
 
 struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
-- 
2.49.0

