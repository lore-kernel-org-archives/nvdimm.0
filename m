Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772672E4993
	for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585847; cv=none; b=ukiMTkf10u0WymY4kNXEh2nqvx9GTS75prlJIfCz0b6Ww3wB0PgpLXjwtyYH5tGsQ95RQCf+9HvSw3WWn4uZvZt4bCTAQYhM+Rv+55cSD3RqIBg4YJdJRh6xcVmNtPODa9PKZ8VcSv5if7LcsgGgDSbc3BN4D0D8ljVZOH3TOho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585847; c=relaxed/simple;
	bh=ne3nE0vrAY5S0hOjuSZuCjXi2ceWjqlUEku8gXbVmoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cWZLmLkKAy0fp33gDZymC+rucQleSE5nfoESLhFpQCz7rZ8Dwp4VryUnSVISBgvjthRmB783qhMJMVhvHEVKYLJfa+mxMvmtfGANTqRkB0oRYTrnRhavl8d/AcNV0AUIBsau7AtLlCsI6vTuRQnz9f5A3m7It/FIAUw5GPbdz+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NEmYD34H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NEmYD34H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752585844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oD0dyDm8lg70iaRDQ2YlIByz/7M92Pfar0orAStmNLA=;
	b=NEmYD34HIfBpw3KO0J1mrqy6SxNEgToVJ2tdkCXU6gBdqF7Ex7XtMawzDThtCckJSVPMfc
	wsQROSq+i9Dp+YITz/xIW6fJxiRlIl43g7qqfagRVR54Kw/LJ3bRg/zhYKfQXnzbPL7H0A
	KXIW3KGxzJPOP2Yr9ccJzu/efUVcGDg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-FXaQeO2iPFu6kwV-nYquxQ-1; Tue, 15 Jul 2025 09:23:58 -0400
X-MC-Unique: FXaQeO2iPFu6kwV-nYquxQ-1
X-Mimecast-MFC-AGG-ID: FXaQeO2iPFu6kwV-nYquxQ_1752585837
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4edf5bb4dso3979232f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 06:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585837; x=1753190637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oD0dyDm8lg70iaRDQ2YlIByz/7M92Pfar0orAStmNLA=;
        b=KGc3JEe6BXt6/BDj91hviwizW4bJWm/T7jUfxU5NGngHQPx1M1eE0Q2J1NN53mtoUJ
         i27GD7YGDmBnAdZOevebu82BKE9XbBF5fk/dm9jzVeFgTo9/DOwMfh6lxi/lwBabXE6q
         KSN/xVz7GJW4JfTjnZLUVGDV42T/e7ROIlQspsdLyciHxdgz1DI94/8+4Y0MZW41w/BX
         dm1CjM/pThoqF6kggZPSW1sokzcTcZ28s8hoe/vZCkXLFUk13U0cSZunWPOvkgv9AIkd
         Mxwy8UfAewp+CotycMmDygi603vzLSBHvLPOHLjOIAPT8/8VZykAydY7h5B1vwSvFVhW
         7Tmg==
X-Forwarded-Encrypted: i=1; AJvYcCVAMMt4zABAgHQ6OW2WUmLEYnKIeFcXLkyd1St6OGkZj1vyIV3Ce9BEzFzhLndtLfXQKgO3zOg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKAm+cp+SXIRcYJTNsPanQU4Qa9SaK4Cpzc7OUeZuVw/+eMnft
	H6fUYKoa2VZCWkyYFq2uZUB8h7AoYfVBxeZvZpBQPKMzHN0/nfXI68gzQd8XMdt8WN5rJ61y06b
	KNgdZxtuDHPv9jIP0FjzmAuBZr+zQRYeqThOx2T3wh4lwCELsuY5cADlKmQ==
X-Gm-Gg: ASbGncsBzNpl9MG8nJp34XA4x6xxZRro/JhnM/I/wqLEXrKLXL5i7CHq8rrz4DATcB7
	QpKPraQxNtl3GfxNkcK1UXK/JFCVrhUqSTlf/UUuuUPwtM7EgFfPWNoug8pDEVRHPiE13ZX4T7G
	BL0YoWFkZh3et3hnLv7g7C55oxWrmPW5vBNjXW6DeayTU0+r/8Gg3OmpgIcymSlLoX8Gr69y7ik
	gjLukTrRLC0Sg2s0+g9yMl3frHxfR+Q6M/xPnm5UaN6svExSehl7KESpzQwoj7QoxEpAuL4Bc4n
	JskuE2QZTH2uLxGGUF0Yzr8LCrVUErs3K8N7rQuHcnnKzKGlh+mU5+KlqWbAaVK8cAH+pAZ/hQm
	YvjU3F2mv6UYEmhQ6yysHV7RV
X-Received: by 2002:a5d:6f1c:0:b0:3a5:527b:64c6 with SMTP id ffacd0b85a97d-3b60a144d0emr2333561f8f.1.1752585837438;
        Tue, 15 Jul 2025 06:23:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFp1q78RzrsyhD1CJX8BXKE4JqnpAS3jXZChO9oe8FS+N0ne3lTOJKZGuzSFKSesdJ2HD0wXw==
X-Received: by 2002:a5d:6f1c:0:b0:3a5:527b:64c6 with SMTP id ffacd0b85a97d-3b60a144d0emr2333512f8f.1.1752585836975;
        Tue, 15 Jul 2025 06:23:56 -0700 (PDT)
Received: from localhost (p200300d82f2849002c244e201f219fbd.dip0.t-ipconnect.de. [2003:d8:2f28:4900:2c24:4e20:1f21:9fbd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-454d5037fa0sm200348205e9.7.2025.07.15.06.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:23:56 -0700 (PDT)
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
Subject: [PATCH v1 2/9] mm/huge_memory: move more common code into insert_pud()
Date: Tue, 15 Jul 2025 15:23:43 +0200
Message-ID: <20250715132350.2448901-3-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: n5CbjHkQLk8ogpkDXvGWBVoM9Z-cPYKK_qo2JuldkEo_1752585837
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's clean it all further up.

No functional change intended.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 154cafec58dcf..1c4a42413042a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1518,25 +1518,30 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
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
 
 		if (write) {
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
@@ -1555,6 +1560,9 @@ static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	}
 	set_pud_at(mm, addr, pud, entry);
 	update_mmu_cache_pud(vma, addr, pud);
+out_unlock:
+	spin_unlock(ptl);
+	return VM_FAULT_NOPAGE;
 }
 
 /**
@@ -1576,7 +1584,6 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 	struct folio_or_pfn fop = {
 		.pfn = pfn,
 	};
-	spinlock_t *ptl;
 
 	/*
 	 * If we had pud_special, we could avoid all these restrictions,
@@ -1588,16 +1595,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
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
 
@@ -1614,25 +1614,15 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
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
2.50.1

