Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AED324C06A
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 21:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748985407; cv=none; b=KAUzWMv6qGJ+fRvpb6bcXtReMLbZrGeJmyf4FmWwNG94YVaVPwToP8tTVpO78+p8f1gTmdtmQ+vnkvQFrAgOPcsTWg0ZKVexAly6ox9jtp7lBJlXiu8KCGeKKUqqf1jTIppk80Blx3C5pcgPtmoCR9ELyfsk+9064A9XwXExrZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748985407; c=relaxed/simple;
	bh=YiuIbH1YicSvYtWptE6HogEJ1VuNCKkLtGqFeSs9x1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VcmpKAkKsGLGqxo6GVN/OGsuFwj2EmpwcVBGek1VMnrsqPtjkw+MX4b+w99adi5n1TjCcMWw+/73T/xJq2dJKrc96XVFqMBv0siQBBiVm0oqj/tBnK0jnOeXe13V9Ok69ql6u4arxZzmC9/iffUnzt1ZLSYVoPirJGh/rWehazI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jD7XB/hW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jD7XB/hW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748985404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=odfwWYBsPrR2NiRATGhjsNB6SzvCCkIpMqMTiNvN67g=;
	b=jD7XB/hWESOIxFHs815ywPythz7p+PHJtWcNWD5qvmWF3k01Fgrxg/iqUKB6YWgrsy+lo4
	qvekFQh2R09zEvQUBTU63tSs+Ut7ZSeRk4p3EHXVXNQGKf7onYSLgzjgmNcP4HC/Ri6uPP
	PWXQJuNL6hFZU61t9DuVOpdivQ1aLro=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-x7YvO4ObMluHpdOZgXGtZA-1; Tue, 03 Jun 2025 17:16:42 -0400
X-MC-Unique: x7YvO4ObMluHpdOZgXGtZA-1
X-Mimecast-MFC-AGG-ID: x7YvO4ObMluHpdOZgXGtZA_1748985401
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-450d021b9b1so25248885e9.0
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 14:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748985401; x=1749590201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=odfwWYBsPrR2NiRATGhjsNB6SzvCCkIpMqMTiNvN67g=;
        b=iPUmxWuydhaNOp5cA7tFfDxFwjEwg+3PG1rILt1TrKa2wyxAJ/lkCvTNYqqKQVDpvE
         /NOV9yyV3ed5NbDlVMaUpuMzHA9AWLHI+L8I6par54utyr55eHSGiNEbW6dp3zv8ivm0
         V7T/U550BSsHliX+770LaCpOWbWaZ2OBxUHmsiTuECjFqmZlExdgEQWdV1+zSX8JT54O
         Vtx+A/LKxrB1oV99c8ZMvvHn7IGuKmTB3NYMC0nzHnBDTpasXku6HelBlAc3T/RzFwEh
         hlDAzb6dGKh5n9YeAW4krmct/Xt3cXr6Oiuh0k9SzLFHVQINrfrmxao+TW8ANdzif8Aw
         fbuA==
X-Forwarded-Encrypted: i=1; AJvYcCXRNsEgMAOISDQvL/NfkaktM2DquEwtrm91eXA4C+Ojigd8WTzjA2RkL9qSHxEyAwS3+ljFbOE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRmipESYZeOKZcyGS4NtoqHZclIGbbQL8K7jHmfT/+PDRXpJ2o
	TAW0jl1OiaR+Sl0S6F+C/7M7ObtMCGDksTYf+1NWzhod2P11Xc/ANr8wG5/7BWXx2sxrZ/5OlpN
	MErK3dq10+tYWkEQ8gSvBldD0lD8HrPEvs85LqFAPPi1S79GsebPpPwYrgw==
X-Gm-Gg: ASbGncsqY2v3FOdo0F/Pt6/1rdAGaVTuh3gm35b//N+MqEgiWNs5/iV29PuW82G4/xh
	9GqTqJXVP/f8yao1ogeGQMmeXeH87IvnsmPdC7+8U4c6X5dIDUp7EGwfuH83ttJob9ZM/oxuTSA
	cFegL6MUyLDJ9vKh1JtU0W6EHGL4nIYrJEG4dypbDzL/0ecbZ+HQCkd1ruVSV5gujUhUVyLD/j7
	PFLfGBlDVbUS7I+y0Ntk58iyCDl70Z3pf3Yji6WAKfEXCs6r391bmil/4BRwqHOiNAxXec/LAFR
	CUWg2zedc3QehqNj3uEFteKJR85ZSVq/MtkEgEkXG4a0cIN7VniR3/h4fhE8Zbb0wnLMuFDP
X-Received: by 2002:a05:600c:8b53:b0:450:d386:1afb with SMTP id 5b1f17b1804b1-451f0a77343mr1734655e9.9.1748985400740;
        Tue, 03 Jun 2025 14:16:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGU0uCWB4mipEA75Rgm+06vlkE4Cg+21PNhH9TeTgvc29mcVV+kilTSDzcCPjrD9lEWlpu3Rw==
X-Received: by 2002:a05:600c:8b53:b0:450:d386:1afb with SMTP id 5b1f17b1804b1-451f0a77343mr1734345e9.9.1748985400273;
        Tue, 03 Jun 2025 14:16:40 -0700 (PDT)
Received: from localhost (p200300d82f0df000eec92b8d4913f32a.dip0.t-ipconnect.de. [2003:d8:2f0d:f000:eec9:2b8d:4913:f32a])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a4efe5b96fsm19175970f8f.8.2025.06.03.14.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 14:16:39 -0700 (PDT)
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
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 2/2] mm/huge_memory: don't mark refcounted pages special in vmf_insert_folio_pud()
Date: Tue,  3 Jun 2025 23:16:34 +0200
Message-ID: <20250603211634.2925015-3-david@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250603211634.2925015-1-david@redhat.com>
References: <20250603211634.2925015-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0tWdesN8J5tlT0bT7HjPsqQmOwKjgNtBWRHoFMwhh1g_1748985401
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Marking PUDs that map a "normal" refcounted folios as special is
against our rules documented for vm_normal_page().

Fortunately, there are not that many pud_special() check that can be
mislead and are right now rather harmless: e.g., none so far
bases decisions whether to grab a folio reference on that decision.

Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
implications as it seems.

Getting this right will get more important as we introduce
folio_normal_page_pud() and start using it in more place where we
currently special-case based on other VMA flags.

Fix it by just inlining the relevant code, making the whole
pud_none() handling cleaner.

Add folio_mk_pud() to mimic what we do with folio_mk_pmd().

While at it, make sure that the pud that is non-none is actually present
before comparing PFNs.

Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 15 +++++++++++++++
 mm/huge_memory.c   | 33 +++++++++++++++++++++++----------
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0ef2ba0c667af..047c8261d4002 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1816,6 +1816,21 @@ static inline pmd_t folio_mk_pmd(struct folio *folio, pgprot_t pgprot)
 {
 	return pmd_mkhuge(pfn_pmd(folio_pfn(folio), pgprot));
 }
+
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
 #endif
 #endif /* CONFIG_MMU */
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f9e23dfea76f8..7b66a23089381 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1629,6 +1629,7 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 	pud_t *pud = vmf->pud;
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
+	pud_t entry;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
@@ -1637,20 +1638,32 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
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
+	if (pud_none(*pud)) {
 		folio_get(folio);
 		folio_add_file_rmap_pud(folio, &folio->page, vma);
 		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
+
+		entry = folio_mk_pud(folio, vma->vm_page_prot);
+		if (write) {
+			entry = pud_mkyoung(pud_mkdirty(entry));
+			entry = maybe_pud_mkwrite(entry, vma);
+		}
+		set_pud_at(mm, addr, pud, entry);
+		update_mmu_cache_pud(vma, addr, pud);
+	} else if (pud_present(*pud) && write) {
+		/*
+		 * We only allow for upgrading write permissions if the
+		 * same folio is already mapped.
+		 */
+		if (pud_pfn(*pud) == folio_pfn(folio)) {
+			entry = pud_mkyoung(*pud);
+			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
+			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
+				update_mmu_cache_pud(vma, addr, pud);
+		} else {
+			WARN_ON_ONCE(1);
+		}
 	}
-	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
-		write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
-- 
2.49.0

