Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B972F4334
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175048; cv=none; b=mPtBvFGmU2/eBkXj26XMj9/u4W5nSP7we/d/inbvvvFrEifjCTW8JLwuo/h2oLJfCySS8L+SxLVHf3NfJ7xZjo+DrLtpCqrN1gSS5hkHCxK+mwfppqybnXieQ09q+xFU/5hep53QwUk7wbyHdpzWrB4qMJ2fwJKFm+u095xPQ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175048; c=relaxed/simple;
	bh=AaLRVPcfUejWvJOHKekM/3Bd9o1DBMGCz5AGg2IT7Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Dul/yehDHrJAW4ZXq7tnEyn4S6pgJhW2ZbR7MWz4qOF54rCGZlrNR6QIKZtfP0sZBFCi7X2ePbqliMf21f30eatYT3bW6pLp7aANWTA4LeCl4DJr9UE6BFddnkDnAr0Bl7XOckxvwQ0tsU3pAPOIIL6dBl3PZYh+3MFueVrZtCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JoMMugcU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JoMMugcU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZKss+ViQ3XsGRfMnfUZIAkjKJYTTy4h8nMBjUoSR6g=;
	b=JoMMugcUPSwdX4lalsTZnQBfPRGaq8eEzITm/F+Vkma8uqDmPrR9TDGcseR5Bj1PdtUPvB
	IUHSfQBa5TuwKADx7UzhTj4oLP2yXupMQkohA4nZNPyGcMb97edRWI09OZtIevhudH2yUa
	Y5ILWt+TR2Vlsj3YhGd4rG3LBJG45vg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-LUM_Y47pMUGCqZlZK8S0zA-1; Tue, 17 Jun 2025 11:44:03 -0400
X-MC-Unique: LUM_Y47pMUGCqZlZK8S0zA-1
X-Mimecast-MFC-AGG-ID: LUM_Y47pMUGCqZlZK8S0zA_1750175042
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4530c186394so25788525e9.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175042; x=1750779842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZKss+ViQ3XsGRfMnfUZIAkjKJYTTy4h8nMBjUoSR6g=;
        b=cx+S6MZjQ+WrjhRFeSLLGTsROjsU4wTzG51mypmuEH7EUYNryJfBzDO+pfK7zBR7+f
         +AfgOUrQPfN2ZiTjR4yJGuTwl7WXu+U0aU7mPBId89oC79RIMWgUl5k5aIHecllkUupE
         IQdFzWIqamvPQK8sTxx1GiVubh22iCtQHXHwzQqhbzi1Im2o8bw2wOgGK1nV9Q2AHWqM
         d1OK868p7HSF8MNavcD8t2m/O1ZPTzKnWBgl07m4y9wK89aWfsQkjXaztH1xFu1d4qJt
         +A76TncfeGT6ZLhHRVQl8Z0+uycMEKkmhJXQaOpPMuMOGwdyLzk8dZTllx9JN1I/tog7
         xl0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXz2mxEgpVwXCzeCcTnba1NrwX5KLKyuZpJer0ievmTfd3219OWq6ZkANEFRzl1oXglv7kK4bg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4dTtn+mitKFNSWk7MGDcDfL4o3FmZn8JPsXkXXFV6rGr9o3/r
	nmr9pfeFJ245/zRDFodVVFu1NUf+r8zBPXKsjbrlb+UrLrepJxSDQrCyfHJebzAeDC2OC/MZrhm
	LxhETENvJNNrnipLy3ibQuAhOSepFPPjyOE3qBFe04Q7oWvoNHic3ViCN7A==
X-Gm-Gg: ASbGncsDug4lsNRZHSozfb4aECBQ9Ot2t/iPCMG0g4s87Wbo6SaI/+QlA8OrDIoPjiP
	eojpXaxpdCkNwuSU8rJCcJXrdd5JjlnLcuxWxad2ccCl5yBP4d00ONpX/O+ayHwPloOz44CQkbE
	KL1kHBLy1HOhwcVKPmi2jse6LBBgjrk0WDP87vNR+fA+jQ74tiy5d4O3AVtauZ60xgYzT7RSlFN
	tiT/qo4lWTPu41XudmqXz9T3r8bwCHhDuYDCPyZQsMK+gZJVUQIWrrXSyPcBRH19SHsn+4cNM6B
	m8sgLIrCkthb7iupj34RLsx7yLteJRDxJ8o274VJbZ94fvXm3gBKRnVdW4d1SfNbC7tu0cuW4Ae
	tftRZcQ==
X-Received: by 2002:a05:6000:40ca:b0:3a4:eb80:762d with SMTP id ffacd0b85a97d-3a572e9e7bfmr10544467f8f.56.1750175042142;
        Tue, 17 Jun 2025 08:44:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEizYNw7dc5qMU4ZYxHKAQ+J5Vp2J4wukFj23PAnuBxSQs+o+0P3zEnBC8W1ti7paRppqlPmw==
X-Received: by 2002:a05:6000:40ca:b0:3a4:eb80:762d with SMTP id ffacd0b85a97d-3a572e9e7bfmr10544452f8f.56.1750175041775;
        Tue, 17 Jun 2025 08:44:01 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4532e25ec9fsm175719105e9.34.2025.06.17.08.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:44:01 -0700 (PDT)
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
Subject: [PATCH RFC 06/14] mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
Date: Tue, 17 Jun 2025 17:43:37 +0200
Message-ID: <20250617154345.2494405-7-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: eCi_3_ImQqz6JTIzqvhhsPfe6lZH5sk_pGUqkdyPwzI_1750175042
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Just like we do for vmf_insert_page_mkwrite() -> ... ->
insert_page_into_pte_locked(), support the huge zero folio.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1ea23900b5adb..92400f3baa9ff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1418,9 +1418,11 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (fop.is_folio) {
 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
 
-		folio_get(fop.folio);
-		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		if (!is_huge_zero_folio(fop.folio)) {
+			folio_get(fop.folio);
+			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
+			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		}
 	} else {
 		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
 		entry = pmd_mkspecial(entry);
-- 
2.49.0

