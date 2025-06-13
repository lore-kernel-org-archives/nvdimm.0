Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EE822DA13
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 09:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749806831; cv=none; b=lzLxclX6MPF/tBuqPSPRBjYiwJp3VHR8kyiR6cBdiKdCMcwL/BSCn4G+qxmio+85dqccBp34JkXE1pQeM1h3TMsPjsmeew/ectIs+44aO1uKQedaq81rBNovzoo5KDAF8IuvEC4TH0e7fTop+vvmr80tYuLN4Z9ueUsG44C6RQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749806831; c=relaxed/simple;
	bh=j64RqC0yW0IWSRsztwobsHrNoaRlkxqGA0a2OxsS0xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=GFOue5D8TQ6WgC6Sj6aLKRVaQRbZHTlLNF7n/BMsGaCHHH13xE6jtzV5EzKtQ1uXsuksCiR3VsgxddwvZJ4KA9PrAKQLFPP4QXIu8RCxsMip+d2PIEM0eoaWKbLEkpzCHsKlnC7HCOqs0A5VLrkSgwtQNslDZ9I2hKy7LYHy0xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hY+SXQSU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hY+SXQSU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749806829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BuuwdyX0QESH0B5VKvKy/eQpha6SfRiQdyfEZdmDLAI=;
	b=hY+SXQSU8qmO72FwZZyzbqIjOgC9rqUg+sWMY+wf0Q+WgF1hhp8r0yqxmitppCRX5FYWYi
	D5rIb6ls5ItixFcPfD14j51oyc4+NxbAvX1Yjkb/LNyMenFeufUmx0i/RF4KFjd/pc8BdD
	iDMJCh6Nl7SQMqZVYFzAyNwxEHVZLKs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-M23vZpCuM160DyaIN8rllw-1; Fri, 13 Jun 2025 05:27:07 -0400
X-MC-Unique: M23vZpCuM160DyaIN8rllw-1
X-Mimecast-MFC-AGG-ID: M23vZpCuM160DyaIN8rllw_1749806826
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso13337945e9.0
        for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 02:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749806826; x=1750411626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuuwdyX0QESH0B5VKvKy/eQpha6SfRiQdyfEZdmDLAI=;
        b=vww7qodqy2qB6pWdhjNeaz4dNKWcmqcEFOTzxQuZLE8cMcInl9dgvZlKtzVUV2CX4J
         otgL37GWdiHp5rhdzWTvNvWbAPDoZe+VEg25HYoHL48OSYYqetgAAFltOLfYq6IVBhEX
         U3fCYJmqsFiqFT+GdlIxGaABzGPgbQlnGhzt9q4sQGn362xUDnCSXVydzzOriMPJAtCJ
         HDYcVde1YlynJ59qQI7TCE3jimPNAF4d22VCDkoNlgNTD0SPBMCfxvlpr+U7ffpVEQuB
         y3Lg/brMQMgNEX1YGcfn1hM9wV/Nx6y5xU+hYFWiDTG4VZEkwCHMceXpmWqwUSgEM9fn
         UN3g==
X-Forwarded-Encrypted: i=1; AJvYcCVZluZE5oLzbUqsJ/IR6IZF/R1irMSlCosEW6XIJq5Q0IW/vk/L92kIHopp+GoAZerqGiZSE2o=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEap+Huu52vLASEruk9PVFRywpT7PgRPsSRr8igNwrDTX6f3jn
	ZveiA5q38NpjRnBu/SSpychMZ8uSAjLhXD5ZLZpGax9HoNJ+E76VO4AgFrhZCyc5CRZcTQJTLyh
	m7U6U8L+7PEn1R7JRlo1K0IAhu6AbtuvEN8g3HFgMFYT+RY+8rgjBO4HPDQ==
X-Gm-Gg: ASbGncsqrj42zt/POzXopi+QOMqv3Qou8Q86hUkAD3vJAl1HREAXgqdhMD/nqjL6dTV
	ytmGVfO6U4YE+DNrN1zBdk3jpopxLNzbFsLAjG9GCRON48k2wspK5RnbBiD/eQpzCpUm3Z3v2Xk
	4VDKdvNkddIMSavP2NmMxMop646YiGd7nSpvn0BjEryr55HzTFpnZTuH7A6DwiVa3UwbDH5fpmV
	1lh/bnP2htOu+qJKyyYSg3oBS8ngshpXULmoBeOz++xZbhhU7jlwhP2vNVlypBO1tu1MW+krKX/
	aUBuDoPCjVuS0t5SbKmgPYYKREUWj2vORCDPozxl70fI6ZvYAaFn2Wki/y3t52oQK2vhFe4oPMF
	pPM3eWwM=
X-Received: by 2002:a05:600c:8b44:b0:440:61eb:2ce5 with SMTP id 5b1f17b1804b1-45334ad836amr23540685e9.17.1749806826444;
        Fri, 13 Jun 2025 02:27:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFP4hRMlxC0kkYbbJprcfwWEfFpKdqbkbnkLg58Cogqr6OsnbV5xlaTNzlLDv0FGfkKMNYSyQ==
X-Received: by 2002:a05:600c:8b44:b0:440:61eb:2ce5 with SMTP id 5b1f17b1804b1-45334ad836amr23540385e9.17.1749806826108;
        Fri, 13 Jun 2025 02:27:06 -0700 (PDT)
Received: from localhost (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4532e24420csm45559825e9.20.2025.06.13.02.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 02:27:05 -0700 (PDT)
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
	Jason Gunthorpe <jgg@nvidia.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/3] mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
Date: Fri, 13 Jun 2025 11:27:00 +0200
Message-ID: <20250613092702.1943533-2-david@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613092702.1943533-1-david@redhat.com>
References: <20250613092702.1943533-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kMegVrNr-4H4tLARUhlph139RcBWKt6YzIm_cj0j-HE_1749806826
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We setup the cache mode but ... don't forward the updated pgprot to
insert_pfn_pud().

Only a problem on x86-64 PAT when mapping PFNs using PUDs that
require a special cachemode.

Fix it by using the proper pgprot where the cachemode was setup.

It is unclear in which configurations we would get the cachemode wrong:
through vfio seems possible. Getting cachemodes wrong is usually ... bad.
As the fix is easy, let's backport it to stable.

Identified by code inspection.

Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
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

