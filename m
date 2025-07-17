Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD9D29CB41
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753145; cv=none; b=tbPWuBMtYSscvk3KePQ2zjdrzbAW0cK8Bq6Y6IHMV93nrxQ1IUraiQbZKIbGi24TMyAREe4V10iDDY6WiRLGqPCOAcsI9RUh8Z9glgM4DugwzWbqcvA7gf4597odWjz82hZCdGQVKfZBH3X3eQI8/7N6AzepFcAOLiRR798+TXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753145; c=relaxed/simple;
	bh=/JG9qVz09j5fWDCOiWpFGOXUQNTiI3Nxqeq+HPrp2jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=SLlkmuDDJ6iXSAT8A8Dn3R35j8egoE/JLtagaggt2IX06cv5ggdNeaaP5dfjkBk50WogEAXCUVqQr9KyZHbzG+yc3CMkvfcqhniaRh9cZnTaN0+2tgx1VrmmSwXFbI+HAL+fuX5mszvV9HH/WGb52ZnAd8qbpq2ZbuUvkmMGyN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UlkjJqD5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UlkjJqD5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8U/VSSfKctO+2Q0R03xR9syW7Y0P/UCdJOxdygVgan0=;
	b=UlkjJqD5t9TppXMMK/NQrbIs5F0nisOj1GLkph5yjwUAiHQiVxBSetBwQ98AJjhgvryvqX
	0EaxI4Akske/UgrR5PvaVOjv7GTFJzjjwFvu6i4kIMsbmUdb+JK5tpkTAB7MAC6kG/MTA1
	dAZUBdc3h9ZeH8ylwfsXJNMSdt5Hwf0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-lhmwo9VuMsKgBnf8_7sitQ-1; Thu, 17 Jul 2025 07:52:21 -0400
X-MC-Unique: lhmwo9VuMsKgBnf8_7sitQ-1
X-Mimecast-MFC-AGG-ID: lhmwo9VuMsKgBnf8_7sitQ_1752753140
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-455e918d690so12107345e9.1
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753140; x=1753357940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8U/VSSfKctO+2Q0R03xR9syW7Y0P/UCdJOxdygVgan0=;
        b=iGEE2bRwzK5AFwZA6qO/+/srliMR7k5RHvAQUOcuCDfa5vDpePLl9TGTYrf/4AzX76
         NgFAtTtK3Awl7ye3/y0bGtwpGnwqxDsiSg9NIre7CB6YS4gkYhES+I6/y4/Z0BlgBwbX
         uPRgFW2zY9cNVqAtZ0Hw3w6jK9aQuQOtEBzCyLASHMuMZ7B7Ohg/wUaaf3PkoXgW6tmy
         WtfFdyFvySt78Rkp832jsi5HOTN7ra08gCuvnQi3F+86ZPtsvIGRVVx2wMlzDENHPOKB
         fMLjN1JkSwQagOh6hxtA354aZBRZ2440fYq89S9Vu2gtSl8hJmM0wODLwZJA0HN7SXYH
         MzbA==
X-Forwarded-Encrypted: i=1; AJvYcCX06MgkwnwVldRwGmiQBIEgKqetGrub5yOLzv5FLQ3JhVynl+9yJrBkLtf3gObjbsmHFLRjfeQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDnY8BLRSV68Ou9TgSATqg1x851QJQBy7MpbVxmfWYSanzpj6L
	9Lv6qMiIzI8JC3qEKIwWlmSrdLYwGZNVgESNgCJFYOeRz6o8+1zsfkKOzDUHafNnXNaO1AXntDW
	lcmkj2iIzJWDxp4cAAt9dMTXqn5bdWlMtryxpSI2bxDR+TPsMmZX1verAmw==
X-Gm-Gg: ASbGncvGd/iREDA3Lk98MZRbR6jK7hTpxpF95cH/yIR6z6fINTYs6qZVw9A87FjzbA3
	bCeJEHCXdHghoDClG7NiWSI2qpAytLlHNLX5/n+fF3/qWsBbG7/J87tf5RWZR6g/DxxWm1LXr5A
	wXa4P5pBp6+vehJNc2ZPHZfAKVbSsvx9ONYotNg2ZjWC2qGxyyQhNzMKAP47tPlzca87O/sfiOJ
	Fzim3TK3/+s5Sa5V8GT17y9Iwb0X3IzCNmug7ElFDeXih2hv7Kx3ViUqNHXfs08YSKf18tVRuNO
	ptXHT6+rp7QzF/dT62rO83Kzuhm+H4hrvYDV1PaqVRkKn6jIaqYwjwEBJPL4k7P4xgv8H7Fwl9S
	lakuFeBVrmZ8PbIzuTvaf4Cs=
X-Received: by 2002:a05:600c:c0ce:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-456346e2767mr22598215e9.0.1752753140289;
        Thu, 17 Jul 2025 04:52:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRhI54TwDUdDBNIeRKh7AVS/hfT6FB+wtUWYU/lc2VhuDIhVT1QHk+Jezb55nN35RC/TrzYQ==
X-Received: by 2002:a05:600c:c0ce:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-456346e2767mr22597745e9.0.1752753139781;
        Thu, 17 Jul 2025 04:52:19 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45634f82f29sm20129705e9.23.2025.07.17.04.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:19 -0700 (PDT)
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
Subject: [PATCH v2 2/9] mm/huge_memory: move more common code into insert_pud()
Date: Thu, 17 Jul 2025 13:52:05 +0200
Message-ID: <20250717115212.1825089-3-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 0m3OJc_EJd9iwQiZjkSzE6PYyN6iSn0_IlR6GDeRqtE_1752753140
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
index 1178760d2eda4..849feacaf8064 100644
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

