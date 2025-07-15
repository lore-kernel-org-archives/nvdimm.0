Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66A2E62AB
	for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585855; cv=none; b=QlZ8VjjAyxykVDPBCNdKUJbNiUcNhJLshlS76s4m560kYSAjhL5WHQovRl5KjgTYNKfmym0WaYdkTrff3N/dVYrwgxDR1q2+odEl/MtSzk9BaeM1kZOwHOzLHiJfI1pZo+HzaZVz8heHrUzvQp1t1wVmX9v3QE0r8GC+ccGl1E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585855; c=relaxed/simple;
	bh=a9OBY9leQX0eGtrRKrr8AgQOeHXQGP3xXcTwIxxSZ/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=chomvVv23AnNiOjLKijiiikUlztFW44u6RrI5vNbdGwWwXaQzWZLokefZ1xkr4tYIU5TnhUTk061j1ufpFtDMW9FLzziEx3a4WCZ4uKPpq1d7qGOIeqYSZzD933QVKHU/fZthg1vcIZ0+TlfbUoJnSH7XV2YgbeP5fpdcj5023E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b66qwkLF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b66qwkLF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752585852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cI2lHUCMuK2zQhlnl2y4PjQd6rkotpnK5tiH1r4owRs=;
	b=b66qwkLF/RKUaO+K2pYKUXdeLMt24iBRoY90VWUIGFc2g64h75ffkwJt9LmkbYPqmFRyh/
	AGJDpfsW+IJFz06yKqotOzQ0sDOALNcMmaMEUv6HYHtey5w9WsgTJnPma7uh/yB5twr27q
	zWITw34R5dE8nW2GY4nCEfLUX1FhUu8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-MjzUymu0PjiPaxR0xvEHNQ-1; Tue, 15 Jul 2025 09:24:11 -0400
X-MC-Unique: MjzUymu0PjiPaxR0xvEHNQ-1
X-Mimecast-MFC-AGG-ID: MjzUymu0PjiPaxR0xvEHNQ_1752585850
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561bc2f477so13652155e9.0
        for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 06:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585850; x=1753190650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cI2lHUCMuK2zQhlnl2y4PjQd6rkotpnK5tiH1r4owRs=;
        b=b4KrKc2RJxZO6tzHvjYmrPZGuQO14Yauqv69c+Z4TGXJ9vgrPAzJSZyCEH7HiM1Jtd
         VjaY+bLuI0iONRa6AO0jsxBVZvqQCpfnN2ORuPO4E9kxIi38KcRm0w30sCEuIaA+3/DU
         /zZIhwpSBfqt7GF1QXbpXfyq3LsD93dS7TZ2DKXRfqUDAKNEURx8o9PUUcoj4+0I9Rgt
         KpYia1lUWec15YriHT2q8XaOQOPzDUwDnlCwKU4rpQaArocfzJrpjBzZ70H5S6pZfQET
         CaYcOzi7PZtNbPl8caG+IXxnPX2DsY3HUJUM+iz218uYYNXB2SvhoE0QJMv557+/iaVU
         zzXA==
X-Forwarded-Encrypted: i=1; AJvYcCV2SfEYF6/1Fm/bmqriW3KI1wF+qfVG1xp+UeIz70sehErZ095VVcacu0Nnr+1y8pTHzAIAMyI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxpSP7wTuwO/NnrBHcL755MrJ3e6XmJBnU2EMvPSsGcZ36kinV
	/jDpXPjjDguyCpkvCyhiC5Wja7KIpW7XOuYdBfdXhmQ5RhGSsJx/L18QNH1inz7MybDdgHfnu8t
	RhjomUvNUV1orC2uk9uZ0jY6HzGp/q1GmXD+7G7Run2lBfT8ijiQmwbRkzg==
X-Gm-Gg: ASbGncsi45brSymtLM1hoYVrFEIiDPorS7a024M0N+0GtdIohrb5h0+lpmAdp8yjA08
	4K0aEsWdLYZVTr6weJI/GF5Ect4AJ3MqUXhEUzkmBwNWIvV4xP5UykSVI66UE/SrNx3BKFbXWmX
	du00EDmAwkgNXu1Bwl9cmW6gVtQf2hYb/mUOJCahGlPcO3+a0IBPUuuFIEFK7x+wW80RA7EUWmi
	d9N3H0DMEDstwtp7p2jOEIdlSzKUTT+zIGKv+0chz41BUwzn5oaOwrtWCWXMvJrGVc0ydce6rge
	WFJhp9IKJvvVaZTZX7gBVyFN+dZoutV99l/n18KTm/ZS5UUmLCAlM9Vl9IRBLFsjeekr3BIlwhE
	6rPzfSCgVzlTyd2jc0OZCGn1Y
X-Received: by 2002:a05:600c:3592:b0:456:173c:8a53 with SMTP id 5b1f17b1804b1-456173c8b27mr94728665e9.2.1752585849626;
        Tue, 15 Jul 2025 06:24:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkPjEhwUD11Kc7R628CsdkyUBojyPzeegGbQKL/YV/Ocaib7+IW0nyg3EFT/AEMoIuz4CMUw==
X-Received: by 2002:a05:600c:3592:b0:456:173c:8a53 with SMTP id 5b1f17b1804b1-456173c8b27mr94728115e9.2.1752585848983;
        Tue, 15 Jul 2025 06:24:08 -0700 (PDT)
Received: from localhost (p200300d82f2849002c244e201f219fbd.dip0.t-ipconnect.de. [2003:d8:2f28:4900:2c24:4e20:1f21:9fbd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b5e8e2710bsm15102268f8f.99.2025.07.15.06.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:24:08 -0700 (PDT)
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
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v1 7/9] mm/memory: factor out common code from vm_normal_page_*()
Date: Tue, 15 Jul 2025 15:23:48 +0200
Message-ID: <20250715132350.2448901-8-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715132350.2448901-1-david@redhat.com>
References: <20250715132350.2448901-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V1WAXy_SLo3es7jdIkC3vcWwBYofiuWXFt5EXhx-T-4_1752585850
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

Add kerneldoc for all involved functions.

No functional change intended.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 183 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 109 insertions(+), 74 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 00ee0df020503..d5f80419989b9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -596,8 +596,13 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-/*
- * vm_normal_page -- This function gets the "struct page" associated with a pte.
+/**
+ * vm_normal_page_pfn() - Get the "struct page" associated with a PFN in a
+ *			  non-special page table entry.
+ * @vma: The VMA mapping the @pfn.
+ * @addr: The address where the @pfn is mapped.
+ * @pfn: The PFN.
+ * @entry: The page table entry value for error reporting purposes.
  *
  * "Special" mappings do not wish to be associated with a "struct page" (either
  * it doesn't exist, or it exists but they don't want to touch it). In this
@@ -609,10 +614,10 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * (such as GUP) can still identify these mappings and work with the
  * underlying "struct page".
  *
- * There are 2 broad cases. Firstly, an architecture may define a pte_special()
- * pte bit, in which case this function is trivial. Secondly, an architecture
- * may not have a spare pte bit, which requires a more complicated scheme,
- * described below.
+ * There are 2 broad cases. Firstly, an architecture may define a "special"
+ * page table entry bit (e.g., pte_special()), in which case this function is
+ * trivial. Secondly, an architecture may not have a spare page table
+ * entry bit, which requires a more complicated scheme, described below.
  *
  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
  * special mapping (even if there are underlying and valid "struct pages").
@@ -645,15 +650,72 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * don't have to follow the strict linearity rule of PFNMAP mappings in
  * order to support COWable mappings.
  *
+ * This function is not expected to be called for obviously special mappings:
+ * when the page table entry has the "special" bit set.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
+static inline struct page *vm_normal_page_pfn(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long long entry)
+{
+	/*
+	 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table mappings
+	 * (incl. shared zero folios) are marked accordingly and are handled
+	 * by the caller.
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
+		if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {
+			if (vma->vm_flags & VM_MIXEDMAP) {
+				/* If it has a "struct page", it's "normal". */
+				if (!pfn_valid(pfn))
+					return NULL;
+			} else {
+				unsigned long off = (addr - vma->vm_start) >> PAGE_SHIFT;
+
+				/* Only CoW'ed anon folios are "normal". */
+				if (pfn == vma->vm_pgoff + off)
+					return NULL;
+				if (!is_cow_mapping(vma->vm_flags))
+					return NULL;
+			}
+		}
+
+		if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
+			return NULL;
+	}
+
+	/* Cheap check for corrupted page table entries. */
+	if (pfn > highest_memmap_pfn) {
+		print_bad_page_map(vma, addr, entry, NULL);
+		return NULL;
+	}
+	/*
+	 * NOTE! We still have PageReserved() pages in the page tables.
+	 * For example, VDSO mappings can cause them to exist.
+	 */
+	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
+	return pfn_to_page(pfn);
+}
+
+/**
+ * vm_normal_page() - Get the "struct page" associated with a PTE
+ * @vma: The VMA mapping the @pte.
+ * @addr: The address where the @pte is mapped.
+ * @pte: The PTE.
+ *
+ * Get the "struct page" associated with a PTE. See vm_normal_page_pfn()
+ * for details.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
  */
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
 	unsigned long pfn = pte_pfn(pte);
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
-		if (likely(!pte_special(pte)))
-			goto check_pfn;
+	if (unlikely(pte_special(pte))) {
 		if (vma->vm_ops && vma->vm_ops->find_special_page)
 			return vma->vm_ops->find_special_page(vma, addr);
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
@@ -664,44 +726,21 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		print_bad_page_map(vma, addr, pte_val(pte), NULL);
 		return NULL;
 	}
-
-	/* !CONFIG_ARCH_HAS_PTE_SPECIAL case follows: */
-
-	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
-		if (vma->vm_flags & VM_MIXEDMAP) {
-			if (!pfn_valid(pfn))
-				return NULL;
-			if (is_zero_pfn(pfn))
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
-	}
-
-	if (is_zero_pfn(pfn))
-		return NULL;
-
-check_pfn:
-	if (unlikely(pfn > highest_memmap_pfn)) {
-		print_bad_page_map(vma, addr, pte_val(pte), NULL);
-		return NULL;
-	}
-
-	/*
-	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
-	 */
-out:
-	VM_WARN_ON_ONCE(is_zero_pfn(pfn));
-	return pfn_to_page(pfn);
+	return vm_normal_page_pfn(vma, addr, pfn, pte_val(pte));
 }
 
+/**
+ * vm_normal_folio() - Get the "struct folio" associated with a PTE
+ * @vma: The VMA mapping the @pte.
+ * @addr: The address where the @pte is mapped.
+ * @pte: The PTE.
+ *
+ * Get the "struct folio" associated with a PTE. See vm_normal_page_pfn()
+ * for details.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
@@ -713,6 +752,18 @@ struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 }
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
+/**
+ * vm_normal_page_pmd() - Get the "struct page" associated with a PMD
+ * @vma: The VMA mapping the @pmd.
+ * @addr: The address where the @pmd is mapped.
+ * @pmd: The PMD.
+ *
+ * Get the "struct page" associated with a PMD. See vm_normal_page_pfn()
+ * for details.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
@@ -727,37 +778,21 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
 		return NULL;
 	}
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
-	}
-
-	if (is_huge_zero_pfn(pfn))
-		return NULL;
-	if (unlikely(pfn > highest_memmap_pfn)) {
-		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
-		return NULL;
-	}
-
-	/*
-	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
-	 */
-out:
-	return pfn_to_page(pfn);
+	return vm_normal_page_pfn(vma, addr, pfn, pmd_val(pmd));
 }
 
+/**
+ * vm_normal_folio_pmd() - Get the "struct folio" associated with a PMD
+ * @vma: The VMA mapping the @pmd.
+ * @addr: The address where the @pmd is mapped.
+ * @pmd: The PMD.
+ *
+ * Get the "struct folio" associated with a PMD. See vm_normal_page_pfn()
+ * for details.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd)
 {
-- 
2.50.1

