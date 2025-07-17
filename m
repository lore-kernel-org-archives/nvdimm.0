Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492792BE049
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753159; cv=none; b=trXJl1qBRAUarCKc8wFcYG00g1lBFapIBAy+ChQ+GA0MXyvEoU3kLhYhzktLE18Ry1AUgbi/VYqlnCc6PVhGCa95gZq5p7ifC0OD1tCgjBCejH4/kUz9qO5xxelX2WEzy+08Ik5tgIhkf0UgwbD8nP9kbqtDN+pKMngy2sjd5+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753159; c=relaxed/simple;
	bh=6/jjLRxyu6Gk21aB2ScFk9YQfi5MLdI3W8BYCgHrJ7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=kRDPHKHomjHj2NCh5+7wNjoSeOirGGqdYmVHHe7vm6hYrUajF17PkHiTteyuM8aRbVHVP+uANv07GIuH8ZJ2uzBhudrqHBWcTiKsCxf9zRsYERwf6NYqG85JkkJj6hbRNaog2Pk+W2EczjF2TU5DRtn0QODpkmwC2cWSeyshZKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R3v2dTQl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3v2dTQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y93PTvMkvM029q6ldi/06ftGqYZT07G8pbjSDy6T3hs=;
	b=R3v2dTQlfSz+DnV/cac/LtblYmupdjepB/veUESKoJSFRGzSM6dyFsPdjPe3NNce6zcTmr
	o+WRCq6JWoYMKbsfV3kThMsXG8yE20NXMe6Ch1rLYrlTcJ1CcIc+5MFhohQYgiq6+XMoij
	zcyxWXzAgPmCRsdH4OpBNR5hR5Q+tvE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-JlQd8tLhOOqIWldgjrqxbA-1; Thu, 17 Jul 2025 07:52:36 -0400
X-MC-Unique: JlQd8tLhOOqIWldgjrqxbA-1
X-Mimecast-MFC-AGG-ID: JlQd8tLhOOqIWldgjrqxbA_1752753155
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f7f1b932so563441f8f.2
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753155; x=1753357955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y93PTvMkvM029q6ldi/06ftGqYZT07G8pbjSDy6T3hs=;
        b=fSWswtECqd9Q7lOOYJhtJ4XlXBAgW0guqiPpUUm7GL/ArMuUzH4Nsz3oqnsixVXZ3V
         zOFAQcGGqSfIRYF9gt0e/FNjprKSzc+QC9vLuV/8PgCCGwZx3SydQG8UgMHlaHnKN8hY
         IPuSu7RPauyoCpxADDAR+e8+6D9ovxFpusXEjOCbYIXT5Db3Lt8ufDdFLhQTAwBByob3
         nVIpclHIKx0jTRsGzxU3jnUDa+8LDkvTh7ijGdr9+fAPkp/UShTsafXQjOBL8V9KSpaR
         rCf35IszpBdtAwEQeCZdf8eVIb3pWOf3frL7qIiwIQvrQrCaQRFoH5+7aBZhJGKe0ONw
         i6OA==
X-Forwarded-Encrypted: i=1; AJvYcCWX0/nEIRVfj5pU8heLEhd6Tw2q+QK7HS+9hi6i0YfLmAt+tmujjQz5vIq+RWXmRCUO+ctSj+Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyr7OQ5l6x0ejaGWhchSa7zKTDhD3Pdz1+QXDuGctUAwx1DKbFp
	HEvSxKKEHBQj8y1g95E3FGLntW8E3IbjFPoAZLDA9w37RU+26Vc4u3nS9mGXkYbMhh37CF7bnMK
	NpisTxGRClIeKraSaR28rRUQGW+sV7iAUmtWm/3S4sGAoflxDfsZQSABbCA==
X-Gm-Gg: ASbGnctvc5nba0gXVgPrD+OPpBDdem/VcWbQVKCEuKw/JFSies8OMe/8dFlOYpHe8VA
	9Dm4oFpmUKfeAo8B7Zrbrqb/E8i7waUBZA9N66Gl+vZPDFdZD0WUafY89K8LR6LPN2p8GJBQ+ra
	GIFAgDn5Ezbdq8mF5Eu2tLBfLHXhqRPyynhbVkXlODBrbz//WElNtUrmrCGkm4yUjphSkZpiq9X
	pnQdi/U3cs+xAoQv+tFfbP3ONesI0F0tL7rm4LE1xfWrnvWGBg+Q446eNttnlg4T7jsPEjCidLT
	p2CYAthdBS6kC9x3p3bMII384n8S1OqgOKWmStii79DDznEerDYjXVoXCEk1b7SYJl/XID+3EpZ
	iazbW9uRPUnnU8H5gwn043yo=
X-Received: by 2002:a5d:6f14:0:b0:3a4:f661:c3e0 with SMTP id ffacd0b85a97d-3b60e510baamr4180684f8f.45.1752753154939;
        Thu, 17 Jul 2025 04:52:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAqQmPlaR0MqxERo3NRLrhaU4oEs8iGAGrgiheQNLTojFB3jUgPbGxNACr3plB8i5Bf9h92A==
X-Received: by 2002:a5d:6f14:0:b0:3a4:f661:c3e0 with SMTP id ffacd0b85a97d-3b60e510baamr4180643f8f.45.1752753154425;
        Thu, 17 Jul 2025 04:52:34 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b5e8bd18ffsm20281626f8f.9.2025.07.17.04.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:33 -0700 (PDT)
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
Subject: [PATCH v2 8/9] mm: introduce and use vm_normal_page_pud()
Date: Thu, 17 Jul 2025 13:52:11 +0200
Message-ID: <20250717115212.1825089-9-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: KSXTQ7YTsyq-gav9jDdma5p5qLdqRRq9mo1faIHTRRU_1752753155
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's introduce vm_normal_page_pud(), which ends up being fairly simple
because of our new common helpers and there not being a PUD-sized zero
folio.

Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
structuring the code like the other (pmd/pte) cases. Defer
introducing vm_normal_folio_pud() until really used.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 27 +++++++++++++++++++++++++++
 mm/pagewalk.c      | 20 ++++++++++----------
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index abc47f1f307fb..0eb991262fbbf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2349,6 +2349,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
+struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
+		pud_t pud);
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
diff --git a/mm/memory.c b/mm/memory.c
index c43ae5e4d7644..00a0d7ae3ba4a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -796,6 +796,33 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 		return page_folio(page);
 	return NULL;
 }
+
+/**
+ * vm_normal_page_pud() - Get the "struct page" associated with a PUD
+ * @vma: The VMA mapping the @pud.
+ * @addr: The address where the @pud is mapped.
+ * @pud: The PUD.
+ *
+ * Get the "struct page" associated with a PUD. See vm_normal_page_pfn()
+ * for details.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
+struct page *vm_normal_page_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t pud)
+{
+	unsigned long pfn = pud_pfn(pud);
+
+	if (unlikely(pud_special(pud))) {
+		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
+			return NULL;
+
+		print_bad_page_map(vma, addr, pud_val(pud), NULL);
+		return NULL;
+	}
+	return vm_normal_page_pfn(vma, addr, pfn, pud_val(pud));
+}
 #endif
 
 /**
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 648038247a8d2..c6753d370ff4e 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -902,23 +902,23 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		fw->pudp = pudp;
 		fw->pud = pud;
 
-		/*
-		 * TODO: FW_MIGRATION support for PUD migration entries
-		 * once there are relevant users.
-		 */
-		if (!pud_present(pud) || pud_special(pud)) {
+		if (pud_none(pud)) {
 			spin_unlock(ptl);
 			goto not_found;
-		} else if (!pud_leaf(pud)) {
+		} else if (pud_present(pud) && !pud_leaf(pud)) {
 			spin_unlock(ptl);
 			goto pmd_table;
+		} else if (pud_present(pud)) {
+			page = vm_normal_page_pud(vma, addr, pud);
+			if (page)
+				goto found;
 		}
 		/*
-		 * TODO: vm_normal_page_pud() will be handy once we want to
-		 * support PUD mappings in VM_PFNMAP|VM_MIXEDMAP VMAs.
+		 * TODO: FW_MIGRATION support for PUD migration entries
+		 * once there are relevant users.
 		 */
-		page = pud_page(pud);
-		goto found;
+		spin_unlock(ptl);
+		goto not_found;
 	}
 
 pmd_table:
-- 
2.50.1

