Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F102E7622
	for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585859; cv=none; b=VRY75VgLEfvF42xy+P7VeiwYeB5s7Vm979IP+ZzBLA3F7M5mYSu3nr8rxrxqBrb62MunpKxLAeY7XhFW486l904TVBw/HN90jFRtP/O5jhvsAsXH3bG25NaNgLXydI3f+8q2LoAhWOLIaoOJMhMrFWFrikEOKp5tkfWpVokb4G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585859; c=relaxed/simple;
	bh=TBptezEvoZbA/+QIqs5Pl7513sIN/gOoRGF1IIIkC9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=fcCUPvMy6/8D/owye1y9AkMDXUma3LDbc8NEo6YxK7PoeVjfmScOrfHrzlMBA8QTfhp5ltU3pPBXu0El29Qg6gs7eDjnxszvUcUVDu8ewSES/57eq7sS55I8fKm/j9XFYBb90UhF9E/ZljrQLXwxKjUhJIYYDfF42QkEYEixpFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VgxHMDhd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VgxHMDhd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752585856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ipu1K94ir7ZDGEwTFYIjfG52vTt/Yk6xgTkmlb9d9g0=;
	b=VgxHMDhduKlw9V1lDJWKQvQluhidIxaQ3rAdOHNqBmFHqqkXUe5+9qF6L5aR7QAQNpuMw0
	s3rTyxFBBho2Gm/BLvxRdPz5JfGy305E8cYu0vgpG22fv4tcI7XqstdUn36SLSIxYkiKTi
	3UflNktZN5c9QpnW0fdp2Ja9Q6vMM2s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-d4u-8MoHN2WqF0sJnwcJTg-1; Tue, 15 Jul 2025 09:24:13 -0400
X-MC-Unique: d4u-8MoHN2WqF0sJnwcJTg-1
X-Mimecast-MFC-AGG-ID: d4u-8MoHN2WqF0sJnwcJTg_1752585852
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4560b81ff9eso19992345e9.1
        for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 06:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585852; x=1753190652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipu1K94ir7ZDGEwTFYIjfG52vTt/Yk6xgTkmlb9d9g0=;
        b=ImG8ofEgSsoh7/UqUg83OLNF5187pHBmnQgNWzekXpWkAVIz6XwobUAplf+m/VFTZF
         El+DrpLRPI9VdwUrQMbgvpQlUvI0GvgYJvmdiGoBHkYKYqnzzpuMwp7bWTRMpEkWwcH5
         kB7LbSR2AMyeEDWCco1UytlzRpaJVfvKJkDUiZqlOYW0Cxi2Fz/85yQhxw8AWcDVMLad
         Z1LDarWZrn+xWqauklm2Rcz6thhMlOIebxZJTxBC5rTmvoLJs8X+FwJrWiLyiiFmOJaU
         RGaiaTEPJBSnbyHOesg1aAYTZdfFNpjtRdSX5f9WWP+M7kx3OEjAZ1yqtqktktcyU+GN
         OwnA==
X-Forwarded-Encrypted: i=1; AJvYcCWJrdYz13/7wLr1MwdPPGIZuYps3n1DHN+Utp68CPsqtcvwE9lULSmmcnr8plASwVlnWBC9Mds=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8zAbkkJwAEjMaVsRb0U5BicJHW8xiYZnT81j1/+ipYzvHFXPK
	PwsYvkQr7l+eMqgDvBqk/gFO29vZqPhWIng+FPHWnGNOOGl9rxdUXlFmbnPMcB/wyf2CWMFI/b8
	PaZUD1lSuaUgNCfkur0Yi1Lo/IUMGlKPMljcTQzIMpV9FwvD+o+voUFGXig==
X-Gm-Gg: ASbGncumrxPnfbrWLRAyjXaJjCg45zUT2s9j02WpjlkdJqECTcxcY7Aof4mKTznHZLf
	XaDoGhFAaU7lbOeBeQ3TCMkI0Hv+4sjjni4maQotp15w/ssk8L17T7YI0biniILfw21g6WgUk+2
	Zgdw9gQ3zt3Z2LhLUzHH1qSndY814H3h2t5pVkYWRuqdbbBovdmUEXsn14PPSNex+wUH9IZnFSX
	GskEE4Ho+s2B/XX1BeKIH0remtwdv+xuX5ZdlOOyzawMnr/pej7LGZIjxWXlG9MKTMs6xQbp2y2
	LE3pAMymrKP/dPvMZ9dx/6qjsDJwsAPvJByGQ1uOlSm8rK5bXvu/L8pFaecbBDd0I5ytpjoHVGl
	41/xdnZfcQmlWtngSb0xKk7CD
X-Received: by 2002:a05:600c:8b21:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-454f427c7a3mr171862465e9.8.1752585851894;
        Tue, 15 Jul 2025 06:24:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaYqvO7Z17qzgP+gQiOIR1ioSQdxI9NA77sZCIReClJxyu/a9rC4GbIDSj1kdPYM9bqwFuHQ==
X-Received: by 2002:a05:600c:8b21:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-454f427c7a3mr171861965e9.8.1752585851440;
        Tue, 15 Jul 2025 06:24:11 -0700 (PDT)
Received: from localhost (p200300d82f2849002c244e201f219fbd.dip0.t-ipconnect.de. [2003:d8:2f28:4900:2c24:4e20:1f21:9fbd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-454dd537c6fsm163863975e9.21.2025.07.15.06.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:24:10 -0700 (PDT)
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
Subject: [PATCH v1 8/9] mm: introduce and use vm_normal_page_pud()
Date: Tue, 15 Jul 2025 15:23:49 +0200
Message-ID: <20250715132350.2448901-9-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: NFyT1udtIm6KI_LfU2Kr90F2NUGOPsz_tF3s7scu6qo_1752585852
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's introduce vm_normal_page_pud(), which ends up being fairly simple
because of our new common helpers and there not being a PUD-sized zero
folio.

Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
structuring the code like the other (pmd/pte) cases. Defer
introducing vm_normal_folio_pud() until really used.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 27 +++++++++++++++++++++++++++
 mm/pagewalk.c      | 20 ++++++++++----------
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 611f337cc36c9..6877c894fe526 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2347,6 +2347,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
+struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
+		pud_t pud);
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
diff --git a/mm/memory.c b/mm/memory.c
index d5f80419989b9..f1834a19a2f1e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -802,6 +802,33 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
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

