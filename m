Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C600C28001E
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749643629; cv=none; b=cZkL9JFlVdF6D4OUManlIXa7DLYLwyumx0nHfeDEfKrpP82xFEHx1gpaxmQzbnR2QIS2IpVj5z+CwAwMtKbNv6O4xOvRkNFF/EQHvHCX1XeKPvyYzj4FZAmEV6UBmpnAZwLAym6F2574GahMEFAAxdHGAJV6ARyqvpwIduIHegw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749643629; c=relaxed/simple;
	bh=zKTs78RTRTqS5HP35DRDL4Y0b0mNW3Gu1tDXt0akX1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QXOnOew5J4buvJyW/vEhlS8SjACQENluTcVSNHbGvV0Evh9ghqVRmhANIp2yZHAvPaIQNSF69TiruWyb4JWVMqhBjLFdDslPcoLTxY/00+UvkpzcdNj33zRTDtisrTARb48fwCLbSGlJW6K0dGWwQuUxJvyK2kJye1nwoMQ2WZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KZXq0gS7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZXq0gS7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749643626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+PENtkLUfBH1Z8n7k4h6Ysph6sI1iUW3ZV5Hjz4OJ3o=;
	b=KZXq0gS7TdaUyOv3WFvBKtUDimBcKP4O0kLE2PWQUFLrrwvOtZkAFd+fY6XGgq3YjkOet5
	hRJXngcDKSghVwA4HY1Zc56q6K8dKcHvg/h8a/ThD6NIlTdmLH73BKkGY7rMArixhnPitc
	7DcG5X3raSEaCqE5NI2q3tqTFL3fplM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-zXtiT6WZPxCnMnU5XbV0lw-1; Wed, 11 Jun 2025 08:07:05 -0400
X-MC-Unique: zXtiT6WZPxCnMnU5XbV0lw-1
X-Mimecast-MFC-AGG-ID: zXtiT6WZPxCnMnU5XbV0lw_1749643625
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5cd0f8961so1195556285a.1
        for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 05:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749643625; x=1750248425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+PENtkLUfBH1Z8n7k4h6Ysph6sI1iUW3ZV5Hjz4OJ3o=;
        b=Jd/tkLUTX5KrVM9KAQlUuJOTYWxxIRBg7eAuA7FhCVuk943FWVDK4dtWjZZ73tJBwM
         7M22UZNV1clU0h5xWoGMfswoyfagR4BkwAaEY9ZWcID0me5FxTv3ePHJTNiWtUHNQ830
         IyJlgNEQMf7Qk4R4j5Hh9hmTLJvnEn1suCtLHsWJ//D2jb7tjUaidoQuW65t3JKFO6sB
         5tFwssm1E/csRElywnmicJeugqG3haPNhJRFtqZM5o8aUndBbm2V4RQt6yNdARUMzVo9
         VNChffl9eFRUem1Eggxr7YCZ3Z8bv8NgKQn4MLZdcJ+QkZNjookQoeuZtAMXCqh7bgMn
         GIuw==
X-Forwarded-Encrypted: i=1; AJvYcCVHjvaB0SKIsG5tZLIV17Z46zBewhSQLZISpAZBcoU9c0xfnHgUimTsI7tWWIGMfvkZG37qTnM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxlEBMxFpoWDMUXauL7NeZId7ZEcG2b2LNV6Wpe/4cPuqPyZh0m
	SdlG+zCleqtitK/tWvdz7rm8SgfCUYpzlXnfS2N8WPOKFg7H4QzjgbAZcRmCI5lAfgleKLWok1L
	tsE5+M531rxObm5GPoneFwbGCKvhhFV0/VMxkw59xYwt+SOs/6udEzJIeGUeDp6T0Xqrt
X-Gm-Gg: ASbGncu3TkV9dEdE3EfJXldaWU8XEft/kl9pJo4SNts+CxKD/UNbryWEYL2pMWODH3R
	zaCocgSy+U6UfLLZ5fSKJnbR3t1PQlRMUgRpNbiSJWcR0EJCXK4j1FIB6znC5hBFJbrsJKWxVOY
	mrKz87ZfEp08h3tQUrJFg/6teOjzzuzKZsE7LCNjtD613+L3UfeQ5dvIxoxsw4KDYXtdeoroxWW
	cpGmKgHDdEWOmuEEqy6EyW6JyDEDuk1C3nzbCwi63IF7bMLP6dePfIQRPK3rlOd5Et0bWbfEMcG
	JssR8My/ZtN/n90XOpbq3kbYizSU+FBLxBTwPrf66g==
X-Received: by 2002:a05:620a:3194:b0:7d0:9ffd:422f with SMTP id af79cd13be357-7d3a89b1b3bmr505262485a.54.1749643625073;
        Wed, 11 Jun 2025 05:07:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJLjpZ1uY3+YpiReTBDNjkNaFYo7+UKPSqXzU9BVywxK8ty0bHeAi1vwl8x6v5Oh4c1OLQSA==
X-Received: by 2002:a05:620a:3194:b0:7d0:9ffd:422f with SMTP id af79cd13be357-7d3a89b1b3bmr505257485a.54.1749643624636;
        Wed, 11 Jun 2025 05:07:04 -0700 (PDT)
Received: from localhost (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7d25a60c183sm847676485a.58.2025.06.11.05.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 05:07:04 -0700 (PDT)
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
	Dan Williams <dan.j.williams@intel.com>,
	Oscar Salvador <osalvador@suse.de>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
Date: Wed, 11 Jun 2025 14:06:52 +0200
Message-ID: <20250611120654.545963-2-david@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250611120654.545963-1-david@redhat.com>
References: <20250611120654.545963-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WHY1XOXvmRNyau9ubiBb2VKPmeuzDVqTuMsYdAXwQdI_1749643625
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We setup the cache mode but ... don't forward the updated pgprot to
insert_pfn_pud().

Only a problem on x86-64 PAT when mapping PFNs using PUDs that
require a special cachemode.

Fix it by using the proper pgprot where the cachemode was setup.

Identified by code inspection.

Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d3e66136e41a3..49b98082c5401 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1516,10 +1516,9 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 }
 
 static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, pfn_t pfn, bool write)
+		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgprot_t prot = vma->vm_page_prot;
 	pud_t entry;
 
 	if (!pud_none(*pud)) {
@@ -1581,7 +1580,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
+	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
@@ -1625,7 +1624,7 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
 	}
 	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
-		write);
+		       vma->vm_page_prot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
-- 
2.49.0

