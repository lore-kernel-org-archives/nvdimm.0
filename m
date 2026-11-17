Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931124;
	b=m1T2VI+82zWvZzUskbOX+O2bJT7OHf6LsGd9jvaiyVih8LR3+vuRtxi7xcXXd3sdKn05
	 xfO8UQjoDZetlg/tGF2UIfkcLlOFgbaD6lCAUzIctcj01oL2P6W3RX/REUs4ebYNzkSv6
	 Ycvs3DNw9OI/HzboGPkh8QSipRy15Agqsr4Ec/wR4gnZy3cMzwBpGbMDfLb6fP4GQGF7o
	 b6NDA8iEE8j+X7JEko3Oa/ZYEOi1J2uUSmZ1NXrjt1TTwcC5TxE9PTMlvW778lmkXfHp/
	 AiC85caJrfSlW+WAMKoG+XxqGF2PEcQ+HEwUPUFYKZ2ygpfe99t9G0pLErjp5/4ntyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931124;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=zJChRhdyIRPbnT3aRE1AL5b+XTb/DT038/sueecHEmA=;
	b=OlmJ6qvNEI9RmCD1bQBFkN3MkRq2Gqa0lpr4+OC7GxGps4SU5egtaR126gvwXhYSE0S2
	 cT6SoAwhB8Ak5jqCCdUksTWtuI+VdSmVQPE/V3N1Jogo8VEw2aPc5QA/Ontc9tYVw+TX3
	 kn/I5klzNYEFG5Ev3cinrV3tfPFq1wlD7XIFfYQAdkHAoOZmYfZ6KxXCsasjwfSinVjDX
	 9H5dte3wKrSvdZg3j8e3YobM8YbEn4xQNxkp+4EULDGACBw8OVbQJM+o+O3yo0VVYvp/E
	 OKIbhdDhS0vaS+9jkAmok+Lu8xHBGtDJ9CDkohgVjWUIaAq0e8TuaQ/xCXjfAdDbrLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IgdedSCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1725606A331;
	Tue, 17 Nov 2026 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IgdedSCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CE11F000C6;
	Tue, 17 Nov 2026 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931123;
	bh=zJChRhdyIRPbnT3aRE1AL5b+XTb/DT038/sueecHEmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IgdedSCQIFwyT6QEMQg1ZeujbhFtYtn+6n20Gx6YaDlh1frHhXoz871lHHiY44SSg
	 iUiTCRBRH7V/2bKia5VWGDlVNRIY0kwCqrF7tep3IUoeMFLxqmfn0+tUezaMEFi1nI
	 p3zOfGpF/LzTY+Zj4zPAFBB9tWSUEyReiciLjgm2CZqUg2RJ0kAELIGDdMN8acTsZ3
	 SkubIs+c4WJ5TDl3Cdneb8V9HFxuAMr+8OvAGNOIKrnpf0tMuMK8IiBUOg0Iq4fTP1
	 pn7Ug6i45H9Q4qJLHXsbzDWMYriJSVruXkzn8GlVJHW20l3Wxg+pnWU/q56X6FwZDf
	 jln7BeV6awk7Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 17:58:32 +0200
Subject: [PATCH 1/3] mm/memory: install new PTEs first in
 insert_page_into_pte_locked()
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-1-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.16.1-dev

insert_page_into_pte_locked() first handles non-empty PTEs and only then
deals with installing a new PTE.

Upcoming fixes need to handle non-empty but non-present entries, like PTE
markers, differently from present mappings and this requires restructuring
of insert_page_into_pte_locked() to avoid extra branching and nesting.

Install a new PTE first and return early, and then handle the existing
mappings.

No functional change.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c | 65 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index fe72e66c9c2e..f927f2241e40 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2453,44 +2453,43 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 	struct folio *folio = page_folio(page);
 	pte_t pteval = ptep_get(pte);
 
-	if (!pte_none(pteval)) {
-		if (!mkwrite)
-			return -EBUSY;
-
-		/*
-		 * For read faults on private mappings the PFN passed in may
-		 * not match the PFN we have mapped if the mapped PFN is a
-		 * writeable COW page.  In the mkwrite case we are creating a
-		 * writable PTE for a shared mapping and we expect the PFNs to
-		 * match. If they don't match, we are likely racing with block
-		 * allocation and mapping invalidation.
-		 */
-		if (pte_pfn(pteval) != page_to_pfn(page)) {
-			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
-			return -EFAULT;
+	if (pte_none(pteval)) {
+		pteval = mk_pte(page, prot);
+		if (unlikely(is_zero_folio(folio))) {
+			pteval = pte_mkspecial(pteval);
+		} else {
+			folio_get(folio);
+			pteval = mk_pte(page, prot);
+			if (mkwrite) {
+				pteval = pte_mkyoung(pteval);
+				pteval = maybe_mkwrite(pte_mkdirty(pteval), vma);
+			}
+			inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
+			folio_add_file_rmap_pte(folio, page, vma);
 		}
-		pteval = maybe_mkwrite(pteval, vma);
-		pteval = pte_mkyoung(pteval);
-		if (ptep_set_access_flags(vma, addr, pte, pteval, 1))
-			update_mmu_cache(vma, addr, pte);
+		set_pte_at(vma->vm_mm, addr, pte, pteval);
 		return 0;
 	}
 
-	/* Ok, finally just insert the thing.. */
-	pteval = mk_pte(page, prot);
-	if (unlikely(is_zero_folio(folio))) {
-		pteval = pte_mkspecial(pteval);
-	} else {
-		folio_get(folio);
-		pteval = mk_pte(page, prot);
-		if (mkwrite) {
-			pteval = pte_mkyoung(pteval);
-			pteval = maybe_mkwrite(pte_mkdirty(pteval), vma);
-		}
-		inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
-		folio_add_file_rmap_pte(folio, page, vma);
+	if (!mkwrite)
+		return -EBUSY;
+
+	/*
+	 * For read faults on private mappings the PFN passed in may
+	 * not match the PFN we have mapped if the mapped PFN is a
+	 * writeable COW page.  In the mkwrite case we are creating a
+	 * writable PTE for a shared mapping and we expect the PFNs to
+	 * match. If they don't match, we are likely racing with block
+	 * allocation and mapping invalidation.
+	 */
+	if (pte_pfn(pteval) != page_to_pfn(page)) {
+		WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
+		return -EFAULT;
 	}
-	set_pte_at(vma->vm_mm, addr, pte, pteval);
+	pteval = maybe_mkwrite(pteval, vma);
+	pteval = pte_mkyoung(pteval);
+	if (ptep_set_access_flags(vma, addr, pte, pteval, 1))
+		update_mmu_cache(vma, addr, pte);
 	return 0;
 }
 

-- 
2.53.0

