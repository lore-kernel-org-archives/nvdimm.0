Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EC2227E97
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 21:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748985403; cv=none; b=GDKd+ZYUpO0MxMNOWKa2845G1nGK9FrSiEo7R8POpDk35PIooV1pzkBoLlWXv3yj3lS0/7HXdP0ZMqe2lWgB5PWErATTdvclXUtqOz3tWXsNN6MY9u6QaUaAYsIoucBpHcl6vYLAnSbtghGS5A5Ba4uS6cDSC2xbQQRSrAZ31rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748985403; c=relaxed/simple;
	bh=8rYDS4TO8ABtj37UFmxpQriDVqi32huOFvyDHq7Vzio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cwRn1myLOgEusEoipTnV5Ky1D840CdbBE3rxmmBmG2d3XTJopyWDb2JX/w02PlNkdUDW5Bdgq2oPU4oXjpoRh0Lqge1hjUdqZassxUdGQlYOAJ0Pq77mTiALRQYjPVDtoqLTowSAJnIGsZCZCa2EuMCm5jwqZIJwWvVW586QMFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwaZYonj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwaZYonj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748985401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mm1BYtQxm3N2Ps8LPBW/KCN7FYFGa741SkgBjReTkwo=;
	b=YwaZYonjyRqfQg207Ag0ayv9fFCPAj+ie0ZjsHGoYmPYNKWUxmCp2MLLFtznnIG1+Y1eeq
	yM68rI1sZf1tTeN4MZkvwzY4kJSpJBUZaaVBSnAB+WeoXaCO9tKFIzCArf9uneeP37L7SE
	JSJ30WjxAoQuOcTKJENKEk3GclmbRBE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-QbAAxhKzP4GRsB4lp45mLQ-1; Tue, 03 Jun 2025 17:16:40 -0400
X-MC-Unique: QbAAxhKzP4GRsB4lp45mLQ-1
X-Mimecast-MFC-AGG-ID: QbAAxhKzP4GRsB4lp45mLQ_1748985399
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450d57a0641so41073435e9.3
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 14:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748985399; x=1749590199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mm1BYtQxm3N2Ps8LPBW/KCN7FYFGa741SkgBjReTkwo=;
        b=lyOsgaowC9ocfDfW71WD2uvRnMw3MThlpuwGq/NPJ+R9phwGTXOfAsQY/DQ+RVn5h9
         X5CLK+iKxJx+TH9RpdBuQ8T3HwnmZBzVXXdlOFivvvZyDpyZ66EnLghrz+3PurECQfId
         TUlPwJVqI17/Y5/XDoCfOvRjl5Fsv7N8M8RMOedVGW1kGU+j6w6NCIxLYLyK2NOQaR9v
         PdVPkemL/Celn4htlKLR65d2Zi0HYEPgk6mg/Gg4oQWUI74J5vpCUALYCwhIvGUAKrbI
         WvTs7mIXpytoU+YKlWX3fUumimWY9cTmzOS2b6dF/6W6zM/M/XkQqR75Lyn+FufEJf7r
         ugFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBgkUnmvflou0YDJVOzN1hNLQtUYO2L6J6H768IsI2aMBpxkjJ+/JOC0gekv3L9qkrrZlavIA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJddX96Xybm03zu+DEcYS7SCqR+0i0xnQ3IhKN8LvdhAF2DBio
	rH+QUHrUmNdn4NrryDOublpdGoeeKzS9DfcPfJxv0sR8Ay8JFBebKHQccn5jdSbycoGfM+MI5RN
	54M5O6Xz4J7vP+oK1kwkx1oClnSRwzlvUZfRh/0SHoxW1NhTzCYuK55YKgQ==
X-Gm-Gg: ASbGnct5nmahp+7T7zR7BFMys28/KH6EtPKCTMZzDgIPi5TlWw3hyvaY3Z9z0rWHtHx
	gB3vMz0hwy5bKBkUuHhi6amcIbVTZMi0tuKgqnLyLKMTpC2ylKKqupVIqwMnS4H4SSlUkoWNrA4
	WHd18wWnqIKDsoH2ysJptBm5AHZMsVKV+Y2IMPsT1G+HfGk9PgwycuVwLWR1r7R/b/BsVb6CsI9
	DCQRDPeqxdslwAedTSnnhhdc0k6jWCopvC/fq1YVcd6ax0QYy+b7AuPIcTvUUL3n8ZUiGkmUjOh
	LjNqkFvWZzoysfGcVmVqwyjPNizPGHQYCM0Ut+KHtp0w9zGzklnqlbHqkdQHYSsXZwmffdrI
X-Received: by 2002:a05:600c:1987:b0:442:ccf0:41e6 with SMTP id 5b1f17b1804b1-451f0a729d0mr2203685e9.3.1748985398859;
        Tue, 03 Jun 2025 14:16:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkS98RFt7+3OnGuaG+p0pWOXJwdXIjQziuSpjs39IDB1rfs5Wk39SoikwZ5SKry/PJpnQWlQ==
X-Received: by 2002:a05:600c:1987:b0:442:ccf0:41e6 with SMTP id 5b1f17b1804b1-451f0a729d0mr2203405e9.3.1748985398434;
        Tue, 03 Jun 2025 14:16:38 -0700 (PDT)
Received: from localhost (p200300d82f0df000eec92b8d4913f32a.dip0.t-ipconnect.de. [2003:d8:2f0d:f000:eec9:2b8d:4913:f32a])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-450d7fa21e4sm180154785e9.11.2025.06.03.14.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 14:16:38 -0700 (PDT)
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
Subject: [PATCH v1 1/2] mm/huge_memory: don't mark refcounted pages special in vmf_insert_folio_pmd()
Date: Tue,  3 Jun 2025 23:16:33 +0200
Message-ID: <20250603211634.2925015-2-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 42EoTkH2Y2oHcN1opTqCVkpuKzGD4-SyN8Up6UUx95s_1748985399
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Marking PMDs that map a "normal" refcounted folios as special is
against our rules documented for vm_normal_page().

Fortunately, there are not that many pmd_special() check that can be
mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
would get this wrong right now are rather harmless: e.g., none so far
bases decisions whether to grab a folio reference on that decision.

Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
implications as it seems.

Getting this right will get more important as we use
folio_normal_page_pmd() in more places.

Fix it by just inlining the relevant code, making the whole
pmd_none() handling cleaner. We can now use folio_mk_pmd().

While at it, make sure that a pmd that is not-none is actually present
before comparing PFNs.

Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d3e66136e41a3..f9e23dfea76f8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1474,9 +1474,10 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PMD_MASK;
 	struct mm_struct *mm = vma->vm_mm;
+	pmd_t *pmd = vmf->pmd;
 	spinlock_t *ptl;
 	pgtable_t pgtable = NULL;
-	int error;
+	pmd_t entry;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
@@ -1490,17 +1491,41 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 			return VM_FAULT_OOM;
 	}
 
-	ptl = pmd_lock(mm, vmf->pmd);
-	if (pmd_none(*vmf->pmd)) {
+	ptl = pmd_lock(mm, pmd);
+	if (pmd_none(*pmd)) {
 		folio_get(folio);
 		folio_add_file_rmap_pmd(folio, &folio->page, vma);
 		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
+
+		entry = folio_mk_pmd(folio, vma->vm_page_prot);
+		if (write) {
+			entry = pmd_mkyoung(pmd_mkdirty(entry));
+			entry = maybe_pmd_mkwrite(entry, vma);
+		}
+		set_pmd_at(mm, addr, pmd, entry);
+		update_mmu_cache_pmd(vma, addr, pmd);
+
+		if (pgtable) {
+			pgtable_trans_huge_deposit(mm, pmd, pgtable);
+			mm_inc_nr_ptes(mm);
+			pgtable = NULL;
+		}
+	} else if (pmd_present(*pmd) && write) {
+		/*
+		 * We only allow for upgrading write permissions if the
+		 * same folio is already mapped.
+		 */
+		if (pmd_pfn(*pmd) == folio_pfn(folio)) {
+			entry = pmd_mkyoung(*pmd);
+			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
+				update_mmu_cache_pmd(vma, addr, pmd);
+		} else {
+			WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
+		}
 	}
-	error = insert_pfn_pmd(vma, addr, vmf->pmd,
-			pfn_to_pfn_t(folio_pfn(folio)), vma->vm_page_prot,
-			write, pgtable);
 	spin_unlock(ptl);
-	if (error && pgtable)
+	if (pgtable)
 		pte_free(mm, pgtable);
 
 	return VM_FAULT_NOPAGE;
-- 
2.49.0

