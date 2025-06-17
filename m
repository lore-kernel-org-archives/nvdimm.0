Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452662F3648
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175046; cv=none; b=qbWIPECgf5U/JabMZYRtOY5bBVJOifCm3xlemnniwtlaYmo63JvOgRyHsYD25ARXjLvkuXowhox5Ze/VnSXucezEns9MyjAC81IKr5nABISyaTbBvP5d1IRVC4AcNQaNRb8n/3s5Ab8lldXEyK38BXQ4e1aSB0gw1lzcdlHrE2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175046; c=relaxed/simple;
	bh=Lmnd5ZdzMmI5UAgfdf1SJgbeKDVj30wC0SI7xpkFiMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UiEpS/a3hJQMvcAMxztYAoP62YGuqaHGTcYNXBh1zFyaBypXOHxpNt0gQxWi9UIo9OgTdus+PQz2dTLaJLFiGRrEVbb0nC9lrYSREiS0HoDNQupIsHBStl9Ojv4mhXL/JS4gY/IsSHkS3K16NPXN8bUxA4YSakSj83GSDbcgFZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y8SS2iNQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8SS2iNQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5L8RMUDCiRiYUMLt7aYvOaTdy74+EjgVDuyzYaNy+k8=;
	b=Y8SS2iNQunsWUshALX3RznbRQ88wQKzgrV6BQ5QkHhG1MDIQrXU+wn8w4C+TY5WhN3RRER
	BCHxXKD80V5FV+N1JU5OEBx30Cu9vQM6wZB4yqTejKLbUuG2G9y6ZrEqcWjBCrBoo5spPD
	0JspCOQ3Kfs95zSY61WehxTIH+G8JR8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-cjONq9rDMIy47_QUDAY4XA-1; Tue, 17 Jun 2025 11:44:01 -0400
X-MC-Unique: cjONq9rDMIy47_QUDAY4XA-1
X-Mimecast-MFC-AGG-ID: cjONq9rDMIy47_QUDAY4XA_1750175040
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso36347305e9.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175040; x=1750779840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5L8RMUDCiRiYUMLt7aYvOaTdy74+EjgVDuyzYaNy+k8=;
        b=pR0IVlYe6bjHagBAzDUQnYBI4NfxWXKkqIV/KkoHbi7FTbNsM4ImgkCxJ29KI42DQT
         kzMq6UPpw/1tgAQUJ/dM4qjKGiNo7S4F4oGc7Fi3HsEOLDOyQ+DU77IM1s7zfNXa2J9m
         QkDXcw4rwmJIWRIfGwiMe1537qR4ri8Fqg+6cKvnob0gf4lY+JxOudxgItd3w4ue/HhL
         8dn4KfJS6x0X6viAJBGxwolxPXw/Fw98a9zgYwSnyhlZbl4d3VE0fy3yumn8SWlkPVnk
         nSac93leJhek0+TDjj0cEb9ux8p2puV/wckXA/yjH3mx3+XHtDpPmsBzV8Qpkk9vqGF8
         Iw0g==
X-Forwarded-Encrypted: i=1; AJvYcCVUd9nEFZ4tpX0lZfonCLT3iKMQADFP7NIXHYxkJIAXtEPkoV31MEOPKAdEvEgIHXhmZzY+o1I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwypLLh2pLWpWTjozEt5CDVskKu1J38SPTnS/DtAGTX2GnWjru/
	U02mpMR8auHM5/mY164lI2t3tAKObwglOfZiFL/UOP6lAiwR4AztCVxFjrzHep73q/m3WiNxoxl
	1P4/mmGAfsDYpOTAcOkKWnShZKesdHcHr2ttV5NzFWuDVSuhsLL7VCR0zOg==
X-Gm-Gg: ASbGncvnubOP4cM0EE3gBkZU4+adlzcIrisQtrmxIuL2h3YE37gg58r5d9hZm3oaFWm
	DMve9xUGuzikbBnhLD1qi3UwrotFdV18CJ2U9cynPgpuXEmbLj8JL/RM/4vS5P32wYlLJxkufXO
	LsAnaChlqnuv7sT4kE7xTWSh9vrfkIncoIhA70pkYmu4lr/TLqcP5j4jcSbJW0w/uAVipeQLjYe
	Shu1M9ceXw7/4Ka218nlAYa3elHJkXdm7yNQ4eMPA9FEjsbHVzfKfrW04koyJssHvTL2ibgTy6l
	ZKHHTBVR+PaeTUp+q23i/R8oNzgiz+NQo8/lEUOkJzQ3TiSRbiSiJjjUGCKj5UTgdV30pJAw7Pg
	5LcYTng==
X-Received: by 2002:a05:600c:8710:b0:44a:775d:b5e8 with SMTP id 5b1f17b1804b1-4533cadf840mr119660225e9.1.1750175039956;
        Tue, 17 Jun 2025 08:43:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6BFmn+0lN3d+8pZJ+Q6QIbSjyAC/18B9P+xMU7OTx196gniDr43GvtKhKD3/WRsO3OGi0Uw==
X-Received: by 2002:a05:600c:8710:b0:44a:775d:b5e8 with SMTP id 5b1f17b1804b1-4533cadf840mr119659825e9.1.1750175039526;
        Tue, 17 Jun 2025 08:43:59 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4532e25f207sm178703705e9.35.2025.06.17.08.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:43:59 -0700 (PDT)
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
Subject: [PATCH RFC 05/14] mm/huge_memory: move more common code into insert_pud()
Date: Tue, 17 Jun 2025 17:43:36 +0200
Message-ID: <20250617154345.2494405-6-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: mxGZ8AMfPyYNfnsDOl9yAxXOM3k4NqWxLaW_oNJTWUE_1750175040
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's clean it all further up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a85e0cd455109..1ea23900b5adb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1507,25 +1507,30 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 	return pud;
 }
 
-static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
+static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	pud_t entry;
 
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
 		if (write && pud_present(*pud)) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
-				return;
+				goto out_unlock;
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
 				update_mmu_cache_pud(vma, addr, pud);
 		}
-		return;
+		goto out_unlock;
 	}
 
 	if (fop.is_folio) {
@@ -1544,6 +1549,9 @@ static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	}
 	set_pud_at(mm, addr, pud, entry);
 	update_mmu_cache_pud(vma, addr, pud);
+out_unlock:
+	spin_unlock(ptl);
+	return VM_FAULT_NOPAGE;
 }
 
 /**
@@ -1565,7 +1573,6 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 	struct folio_or_pfn fop = {
 		.pfn = pfn,
 	};
-	spinlock_t *ptl;
 
 	/*
 	 * If we had pud_special, we could avoid all these restrictions,
@@ -1577,16 +1584,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
-
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
-	spin_unlock(ptl);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
 
@@ -1603,25 +1603,15 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PUD_MASK;
-	pud_t *pud = vmf->pud;
-	struct mm_struct *mm = vma->vm_mm;
 	struct folio_or_pfn fop = {
 		.folio = folio,
 		.is_folio = true,
 	};
-	spinlock_t *ptl;
-
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
 
 	if (WARN_ON_ONCE(folio_order(folio) != PUD_ORDER))
 		return VM_FAULT_SIGBUS;
 
-	ptl = pud_lock(mm, pud);
-	insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
-	spin_unlock(ptl);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-- 
2.49.0

