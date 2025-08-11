Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB5D2D5420
	for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911623; cv=none; b=twN7sJ5QvCiEkUaWL8aao9xM0vMv1xgPHiWfbLqjpInPGwAtmsznvp7d7e7bNmIoqi94atVofZhr9nNeasLEVTiiqnY19H35LBy4KIkBSBNu+vM7VgxLFyT6JZ5u/oKOAXkcvYM55aYvL9VDW9ipALF8y0u4BWJGKCtBUdqLUIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911623; c=relaxed/simple;
	bh=hSU2ad9vxzv7v5RkeXoUXONBx2LpYICFUhMEWROUn5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=rFMzs+0ueuGPn0RlU4oKuXT4ugyJoq6qEfNjnFZjjg4w3/30FYZXY/3TjBeKaOAhys9flqxTwrJwmGb42sEmRNhbN+HaQRT2FG/4/g33mudGAgYcBC61PR86sufaVOuMf5sq0jawxwM2pxM/lb0SqFkZB7QL3rSyXC6NlDCWmWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hVVP4aue; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVVP4aue"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+EOzLE+RTai94Qoe+vHWeyxEes26RRi+ewlRPXeNOJQ=;
	b=hVVP4aueCoOS7lXCo5xbS+v7oP0xgL8ED/uuvs96r2r+XPEQFC+n58IffKorap5T7fHJrL
	yT7LMfceSSk69jDWhWbdXbLbhvjy37KEvsHbOpt9Rf07tU/+ZjPVpgjxc4Jzbn3oJs0EP/
	IeZOU8sHJGj5IluQtLXwWiamM+NW5UA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-1r-Ffs7CNjy5Kt95DW__5Q-1; Mon, 11 Aug 2025 07:27:00 -0400
X-MC-Unique: 1r-Ffs7CNjy5Kt95DW__5Q-1
X-Mimecast-MFC-AGG-ID: 1r-Ffs7CNjy5Kt95DW__5Q_1754911618
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b90ab438b9so469404f8f.2
        for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 04:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911618; x=1755516418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+EOzLE+RTai94Qoe+vHWeyxEes26RRi+ewlRPXeNOJQ=;
        b=V0bA9dMIgDLMhNNXWuYN+75YpvMstaB35y5Emfg67vKkfC5v10xBe9wVMpmzoSx6IU
         c50NKcKp1ger4igrqPPv8bWz1YQABt9WWhcZKHzKCoLXdl+mmgeg70NOiyISICh/bZA3
         zHBjVULCfUHK5KGxJaU5dMkpV4GXh3v9qL8CmLUKAEnMtBn2/OYuWFjId5Lb8m6b9jD+
         qq40sHIn+cqqCT4g8UzfPmY+7vbPGvCSGFOkW7U3J/+VpV2imc8MY3VNPoWPumXsK1RI
         uilfVJ41TsIsQoPCrLsJd9qMJsHoqa5BYqFiShlfAHRDS40vK6mK8cmt+ylz68G3DUWo
         71Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXKE6C4I/9+swCn3t9mFvzgl6cj7cRPsjCwjqZLmUXc1UO2tu01lzm6S1WsJdgZAKj0cCnU3Y0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyrz4xbtl5Hypy9TIibUOW3e3S7lYUioEQzA4bEdNajXJWq+zkA
	IQfTJu7DxuHKh65xu6QVZKdLyWNhpemSGzAu9wpmmAL3lBqIAk07p2bIc1+P4B9VN/tmVtyjFD9
	DWwFXsCtweXju1OmCc3u8t5hJMv72kzwKXxxo5WgcxgJGfk3+zHn/BWOkQEktC/sKlA==
X-Gm-Gg: ASbGnctvWG4iCAVe1ngHQm3ZGvhXWTWsoUcUyIPdZ777Er4VAWca7LJ9KQNwy64eOBH
	KbkHDUbzpkhsXMdIUMQcIkXgEmqSMSONSrdrNhMvcj99/uxRFLIeiNfYma6ZWmvVrb5biAP/qka
	4KIXo3TZUUZH4wey07sJs+Qa5bALcqJFFt0UIJW6hK32QEVsMminqGHsErvb56l/cVhJTzpht1t
	bDFq3KB+CNR4aR9/2+nxZchL1gPT013ZyWMiDhUpxZ/Wx2qRb87rFCY6UlLoxBCAhhRNlw4uNda
	Kl/GNnJaXduBLOQrLbFyYLLDZTVm6Jw6oRaYdqq6YIcRg+T08RXkSbCOCVw1n/mu6KbUnqBEi+v
	gUst6XfnkJP857klsf4NhRZNI
X-Received: by 2002:a05:6000:40da:b0:3b7:9d87:97c6 with SMTP id ffacd0b85a97d-3b900b552ccmr11182491f8f.44.1754911617666;
        Mon, 11 Aug 2025 04:26:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgzaZVe/bWq5ilsSm3I+nGmnBoU4tOWHlsDn35ubDMQPCamCfdsJ8Ebz2VnZDz+OwT7Da1fQ==
X-Received: by 2002:a05:6000:40da:b0:3b7:9d87:97c6 with SMTP id ffacd0b85a97d-3b900b552ccmr11182439f8f.44.1754911617130;
        Mon, 11 Aug 2025 04:26:57 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c453d6esm40173200f8f.37.2025.08.11.04.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:56 -0700 (PDT)
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
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 09/11] mm/memory: factor out common code from vm_normal_page_*()
Date: Mon, 11 Aug 2025 13:26:29 +0200
Message-ID: <20250811112631.759341-10-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: t-YkaaUEW1CJLIQbhVwfrFXqKutCGKT2WUHd8DbLRjw_1754911618
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's reduce the code duplication and factor out the non-pte/pmd related
magic into __vm_normal_page().

To keep it simpler, check the pfn against both zero folios, which
shouldn't really make a difference.

It's a good question if we can even hit the !CONFIG_ARCH_HAS_PTE_SPECIAL
scenario in the PMD case in practice: but doesn't really matter, as
it's now all unified in vm_normal_page_pfn().

Add kerneldoc for all involved functions.

Note that, as a side product, we now:
* Support the find_special_page special thingy also for PMD
* Don't check for is_huge_zero_pfn() anymore if we have
  CONFIG_ARCH_HAS_PTE_SPECIAL and the PMD is not special. The
  VM_WARN_ON_ONCE would catch any abuse

No functional change intended.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 186 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 109 insertions(+), 77 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index dc0107354d37b..78af3f243cee7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -614,8 +614,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 #define print_bad_pte(vma, addr, pte, page) \
 	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
-/*
- * vm_normal_page -- This function gets the "struct page" associated with a pte.
+/**
+ * __vm_normal_page() - Get the "struct page" associated with a page table entry.
+ * @vma: The VMA mapping the page table entry.
+ * @addr: The address where the page table entry is mapped.
+ * @pfn: The PFN stored in the page table entry.
+ * @special: Whether the page table entry is marked "special".
+ * @level: The page table level for error reporting purposes only.
+ * @entry: The page table entry value for error reporting purposes only.
  *
  * "Special" mappings do not wish to be associated with a "struct page" (either
  * it doesn't exist, or it exists but they don't want to touch it). In this
@@ -628,10 +634,10 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * Selected page table walkers (such as GUP) can still identify mappings of the
  * shared zero folios and work with the underlying "struct page".
  *
- * There are 2 broad cases. Firstly, an architecture may define a pte_special()
- * pte bit, in which case this function is trivial. Secondly, an architecture
- * may not have a spare pte bit, which requires a more complicated scheme,
- * described below.
+ * There are 2 broad cases. Firstly, an architecture may define a "special"
+ * page table entry bit, such as pte_special(), in which case this function is
+ * trivial. Secondly, an architecture may not have a spare page table
+ * entry bit, which requires a more complicated scheme, described below.
  *
  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
  * special mapping (even if there are underlying and valid "struct pages").
@@ -664,63 +670,94 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * don't have to follow the strict linearity rule of PFNMAP mappings in
  * order to support COWable mappings.
  *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
  */
-struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
-			    pte_t pte)
+static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, bool special,
+		unsigned long long entry, enum pgtable_level level)
 {
-	unsigned long pfn = pte_pfn(pte);
-
 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
-		if (likely(!pte_special(pte)))
-			goto check_pfn;
-		if (vma->vm_ops && vma->vm_ops->find_special_page)
-			return vma->vm_ops->find_special_page(vma, addr);
-		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
-			return NULL;
-		if (is_zero_pfn(pfn))
-			return NULL;
-
-		print_bad_pte(vma, addr, pte, NULL);
-		return NULL;
-	}
-
-	/* !CONFIG_ARCH_HAS_PTE_SPECIAL case follows: */
-
-	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
-		if (vma->vm_flags & VM_MIXEDMAP) {
-			if (!pfn_valid(pfn))
+		if (unlikely(special)) {
+			if (vma->vm_ops && vma->vm_ops->find_special_page)
+				return vma->vm_ops->find_special_page(vma, addr);
+			if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 				return NULL;
-			if (is_zero_pfn(pfn))
-				return NULL;
-			goto out;
-		} else {
-			unsigned long off;
-			off = (addr - vma->vm_start) >> PAGE_SHIFT;
-			if (pfn == vma->vm_pgoff + off)
-				return NULL;
-			if (!is_cow_mapping(vma->vm_flags))
+			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 				return NULL;
+
+			print_bad_page_map(vma, addr, entry, NULL, level);
+			return NULL;
 		}
-	}
+		/*
+		 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table
+		 * mappings (incl. shared zero folios) are marked accordingly.
+		 */
+	} else {
+		if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {
+			if (vma->vm_flags & VM_MIXEDMAP) {
+				/* If it has a "struct page", it's "normal". */
+				if (!pfn_valid(pfn))
+					return NULL;
+			} else {
+				unsigned long off = (addr - vma->vm_start) >> PAGE_SHIFT;
 
-	if (is_zero_pfn(pfn))
-		return NULL;
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
 
-check_pfn:
 	if (unlikely(pfn > highest_memmap_pfn)) {
-		print_bad_pte(vma, addr, pte, NULL);
+		/* Corrupted page table entry. */
+		print_bad_page_map(vma, addr, entry, NULL, level);
 		return NULL;
 	}
-
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
+	 * For example, VDSO mappings can cause them to exist.
 	 */
-out:
-	VM_WARN_ON_ONCE(is_zero_pfn(pfn));
+	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
 	return pfn_to_page(pfn);
 }
 
+/**
+ * vm_normal_page() - Get the "struct page" associated with a PTE
+ * @vma: The VMA mapping the @pte.
+ * @addr: The address where the @pte is mapped.
+ * @pte: The PTE.
+ *
+ * Get the "struct page" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
+struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
+			    pte_t pte)
+{
+	return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
+				pte_val(pte), PGTABLE_LEVEL_PTE);
+}
+
+/**
+ * vm_normal_folio() - Get the "struct folio" associated with a PTE
+ * @vma: The VMA mapping the @pte.
+ * @addr: The address where the @pte is mapped.
+ * @pte: The PTE.
+ *
+ * Get the "struct folio" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
@@ -732,42 +769,37 @@ struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
 }
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
+/**
+ * vm_normal_page_pmd() - Get the "struct page" associated with a PMD
+ * @vma: The VMA mapping the @pmd.
+ * @addr: The address where the @pmd is mapped.
+ * @pmd: The PMD.
+ *
+ * Get the "struct page" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
-	unsigned long pfn = pmd_pfn(pmd);
-
-	if (unlikely(pmd_special(pmd)))
-		return NULL;
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
-	if (unlikely(pfn > highest_memmap_pfn))
-		return NULL;
-
-	/*
-	 * NOTE! We still have PageReserved() pages in the page tables.
-	 * eg. VDSO mappings can cause them to exist.
-	 */
-out:
-	return pfn_to_page(pfn);
+	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
+				pmd_val(pmd), PGTABLE_LEVEL_PMD);
 }
 
+/**
+ * vm_normal_folio_pmd() - Get the "struct folio" associated with a PMD
+ * @vma: The VMA mapping the @pmd.
+ * @addr: The address where the @pmd is mapped.
+ * @pmd: The PMD.
+ *
+ * Get the "struct folio" associated with a PTE. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
 struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd)
 {
-- 
2.50.1

