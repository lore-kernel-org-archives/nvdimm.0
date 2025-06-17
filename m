Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD062ED150
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175062; cv=none; b=LfrpfPRDKOGRSltlIfKZkST48/iBD4KE5GTXm4grqAu9d19RTpRZk0ayd6wOJu7erH/znNiJ04dAIbheNn0JnMuexhOlBOjcVPcUKpWGY1JcnPZYkbVwh68P7NXJysDdHT7VuwV0SbF9BC8FaffQ5svtuw0WLFbd1UhhbTlaBWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175062; c=relaxed/simple;
	bh=BsU24r5xgG+FQtB1entGNmMfL4hNbq4o2pzMYPuggy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mnIXJjsu+dKJA+fOtv7b0TpA/p8tKpVdP8q+Nl/afhN2lo4hGJdb6zpjT6M2hXCkCn0OG2WyeLGJAdqpWaZxFTjwIPsLOcHyPC1RDieAVjDhs+0snj7Y7vL9bUtSW8aj0KkiOY45aucPFglagdDgliaH2UDqa3TuNudlEUZKy34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sn1vmxwO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sn1vmxwO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lq97cexcfDQMKZRu4/MkS8aw3BkFIIdya9sxYwoOveM=;
	b=Sn1vmxwOE8Z9DeQaIHkFZDrGLFbhh7uLDpq/Ss6XMXytO2CfqgcWsLdYdBJbzxyWL1zqnE
	BgjiFMSXK/RSKWbdhnjcuGU+nc/xlXkHWVrzI1LnF5OJ8aQhRuXEEh3sqGBz51su5kwKG9
	p69ArPU5rP7kfrNHh8WYD5EMlN20HWA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-qUiy617yOsG2gakRLQE-dg-1; Tue, 17 Jun 2025 11:44:18 -0400
X-MC-Unique: qUiy617yOsG2gakRLQE-dg-1
X-Mimecast-MFC-AGG-ID: qUiy617yOsG2gakRLQE-dg_1750175057
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4535011d48eso12454305e9.3
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175057; x=1750779857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lq97cexcfDQMKZRu4/MkS8aw3BkFIIdya9sxYwoOveM=;
        b=ARptagNxjuvDBclLRtKyiFmcYfk8EwBMtfq6H2wWWS+oo7p03GDNQHgWVRDGIZeu1Q
         d8rZsMqAUOUd84bmA216CfP39RlqdvkjUIyl4CXKTHOdMHoSIu4nryH5axnXyLNPayQC
         C7SdjuAMGuhzHRWvU0Bpyw6hrK7a6OVM+JwrNWyAE4RBpVAwPofvUyhX1VTU4HH8rujn
         vqZyDGC83VnQkxruZvIZZ9+FGbnAHBZp5SKG8GrdRuZW2YPVnwgq/XxmXkobCQFmi8LX
         I5Zw1MuEMi/tYUsQkw80yGp4rx709JF6CAnhMX3fSWaBPjmPWm7jybSspENAUL/Hpilk
         2wiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHQObEPmIApbkyNPZa5XqWm7KOIOL0ONosx92YyOb5jjh8RMNbIKp17scAnO/yGhKpWxirvpQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEu1CHylUR4oHvnPRsUrTdO42+iVicV/aJXvJhy3Z8/ubJvFIo
	0nhiMZr8R1qHKHiJstOQnqvbWnY2mYTQsc5/UbYldTNCro9CBGDbvWPagcS53onr00MyXDomBom
	rNqj13DIVAdUDIU8YQU32fwlVkUqUkmGmzn5D2KD+FmnrzfI3rVr0LFsvFw==
X-Gm-Gg: ASbGncuqwxMhaVUs0SoVgULZ1TTS1aAOTmOO85mRqvI/CeW4+WWgQjWY0m40zZEQRO3
	c5TjzRGVpuaLKJ/UDIVxLDzeqIkRq4QRyYl4rsZ/EERJz/rToO9ax9HmPuaHCQmeVVNtA4wAX8/
	sDXQuB9XGYSYlUB0/+PEyzDJUKSWkEsgfQ2ObrxtVog+8rABNf/byOeQT90Zbo820Jxi9tj27aY
	VSRFkpae66Dd+CCbtwzi4iPVEf2fx67Jw5M3Ge+KZxRMjL34t3g+a+S5F3LL/DBma8YCH+c30k5
	vIwBTP8AnGMoumN51FPiiOJ9vyyjvf1arcAzy7WJURP5OdZsg79pbF5uBGtWY8fEGo3PnK7eOvr
	4iepQ3g==
X-Received: by 2002:a05:600c:1e02:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-4533c9dbbfemr142093085e9.0.1750175057513;
        Tue, 17 Jun 2025 08:44:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmLbqQvk/KforjobulOMd7Z8HmizRkZJwsjious12VlfKySMsgRFEBQ04fbeKOdJYcWkDwbQ==
X-Received: by 2002:a05:600c:1e02:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-4533c9dbbfemr142092735e9.0.1750175057156;
        Tue, 17 Jun 2025 08:44:17 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4533fc6578csm110483905e9.19.2025.06.17.08.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:44:16 -0700 (PDT)
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
Subject: [PATCH RFC 13/14] mm: introduce and use vm_normal_page_pud()
Date: Tue, 17 Jun 2025 17:43:44 +0200
Message-ID: <20250617154345.2494405-14-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: r34vZQ71L2bP-CjLYSEsXBNNrPn9gFcKzKUz38nAKEI_1750175057
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
 include/linux/mm.h |  1 +
 mm/memory.c        | 11 +++++++++++
 mm/pagewalk.c      | 20 ++++++++++----------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ef709457c7076..022e8ef2c78ef 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2361,6 +2361,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
 struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, pmd_t pmd);
+struct page *vm_normal_page_pud(struct vm_area_struct *vma, pud_t pud);
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
diff --git a/mm/memory.c b/mm/memory.c
index 34f961024e8e6..6c65f51248250 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -683,6 +683,17 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma, pmd_t pmd)
 		return page_folio(page);
 	return NULL;
 }
+
+struct page *vm_normal_page_pud(struct vm_area_struct *vma, pud_t pud)
+{
+	unsigned long pfn = pud_pfn(pud);
+
+	if (unlikely(pud_special(pud))) {
+		VM_WARN_ON_ONCE(!(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
+		return NULL;
+	}
+	return vm_normal_page_pfn(vma, pfn);
+}
 #endif
 
 /**
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 0edb7240d090c..8bd95cf326872 100644
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
+			page = vm_normal_page_pud(vma, pud);
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
2.49.0

