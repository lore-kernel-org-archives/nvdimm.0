Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5E32BCF70
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753150; cv=none; b=BsLnc75RaoY5bivpwApiUrtBw/tK2T8WPi+ufsrtiDYSNZbGW9+ljHpt6rdaO3W0y3rnejYpIx3X/WCOBtB13QUThThPlBJKOY++cMcN46pYMK42V2xQk8+RDHjdvtBvdubMVmSPZ+rtmQAFzhHicLzV30VjQc+1kM0napNY9c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753150; c=relaxed/simple;
	bh=NrAlEw03z2qiGco0Xa1ZOehtWb1pLnxzif8JiZozP3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gZYdkPRoxkW5w3BlKZJkWaBLa4u4H06vVxvXDmHNqKigyljZ7sxv1E+JXm+u0pXI8jFKObe1johRQJgkWjk1QfgSbrH5S/dwuNyEupcfL4KFyUm44SfYaAJpLleSpGBC8B6hf0ON6h5eQUwqFotqexfRlEOed+Wu4vzaXt5PiMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hovra43i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hovra43i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WawR8xzOLp+WGO3JwZK8yJOVf+K8h9KX2DcE6xt9pRU=;
	b=hovra43iMTyf0y8y9ueFmfIlzTlKFSW85ZKj24pk26m2sk/zCuGwdFc1b9n+0nwL1LGXPv
	YRqpIjXYYzNu5384WCA3GLgRoiuY3IEAiPQTcJLRu0Y+C0krfTbk7RHKcjCApe9uh/Hk/a
	GbduXrK3iB9/sGKyvP/BdRv1AkNAEqU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-JomlQSmpO6SWXE6Jf62pFA-1; Thu, 17 Jul 2025 07:52:26 -0400
X-MC-Unique: JomlQSmpO6SWXE6Jf62pFA-1
X-Mimecast-MFC-AGG-ID: JomlQSmpO6SWXE6Jf62pFA_1752753145
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4538f375e86so8436265e9.3
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753145; x=1753357945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WawR8xzOLp+WGO3JwZK8yJOVf+K8h9KX2DcE6xt9pRU=;
        b=LsWDTiqpaYh9WpqsOeKvy1wT0poUS5x6CtIUWpqWvv3yub0eyDmUZNZLVxTJ6tVpxt
         8TdyIsno8OyUR0RIGerYhwaV3wt4e0iFsiTMwBkB6P98rIFtBs2p209KDyVZPMUlarcQ
         4vOMU0TCZn1k6StqnzQgKBEw73mItZmEf9IigCS9BcU28XRSTYG9jLFbuwnI6jitefJy
         5c1L2HCZLsIvNQZN3OWYjUAhth7Yby891/OS7vmnNl0+d1n+C7L30f4V6HBE5MGmYzwr
         Oxen+21S56EnHloEH5ly/cR6ZK33Lx9sCo7Bzx7iTo/91g9JSepMdA/Qo5Ma2G7z1KxB
         FEqA==
X-Forwarded-Encrypted: i=1; AJvYcCUoUBGhzyu9mNDbEMEV947IL8vz9QHTDisZZouEfIzidytQaECOoEgNQTY9Rsp3RqnU+Z+4vYE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1XDclwJVAUJz9qdz9wBJB78btcjK9GzGSRrzSqmqhe17vVGqQ
	cqTYjdl4AqmYmsdiL9ywFv+10NpQAVeAqDpw5nATdGu/0vro+3UERh1IkJgvcJM2Ou96g2siEh6
	p7Fid8hkAHr8uhw9TTJ7W0QqomRKht8EK2YxGnFBy3FBofz5hlaqO66/lMA==
X-Gm-Gg: ASbGnct0v6mxWqNDcrysCiBxQCGjRuDF90CRJ0CHjFJDIQxHzkOwd/IgrimxR+tiJaO
	g34QEuBNJKPNv7Ig9I27INxv9LYzKNDT5KNeGrJq5Fe77mcxL9R9nwjD9ubG4Qfx2VIp/9Q8d84
	2x0eofDmBBdR3f3KoWFeD6FPJtMJf5ZvDNMlGv0ZEC8j0cvETeql4H1hd6UYgmLYHUkipBCEWhH
	z0wksHJhyZ36SOGWSLGg5FTTv5Y89smJCMgiuemNWqi7WGAjF+jSB46E4sTqPkyh1uv9iQL78eN
	CLjmsxDdrKHqFSO8bN+6WFjufpBsnHOmSdL7sgrL9eLa0o4vXS/e9m0LYD0ltQ2LkllDVzg2mnP
	9nc7qbYJik+H3OHj+BShesvA=
X-Received: by 2002:a05:6000:4b02:b0:3a5:52d4:5b39 with SMTP id ffacd0b85a97d-3b60dd4ab27mr4713908f8f.8.1752753145111;
        Thu, 17 Jul 2025 04:52:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDhmg9Ls7QQA6yWIIBzDvc6abI92P/fYxcVRDFmyoxlxNBqWLFwcd4nrVInyOX88jAc9Q7DA==
X-Received: by 2002:a05:6000:4b02:b0:3a5:52d4:5b39 with SMTP id ffacd0b85a97d-3b60dd4ab27mr4713858f8f.8.1752753144606;
        Thu, 17 Jul 2025 04:52:24 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45634f9d599sm19697745e9.33.2025.07.17.04.52.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:24 -0700 (PDT)
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
Subject: [PATCH v2 4/9] fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
Date: Thu, 17 Jul 2025 13:52:07 +0200
Message-ID: <20250717115212.1825089-5-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 1Zr61FR2xOHsXBqL5-5q3uFLrjHHnG65dZvArFghQAQ_1752753145
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's convert to vmf_insert_folio_pmd().

There is a theoretical change in behavior: in the unlikely case there is
already something mapped, we'll now still call trace_dax_pmd_load_hole()
and return VM_FAULT_NOPAGE.

Previously, we would have returned VM_FAULT_FALLBACK, and the caller
would have zapped the PMD to try a PTE fault.

However, that behavior was different to other PTE+PMD faults, when there
would already be something mapped, and it's not even clear if it could
be triggered.

Assuming the huge zero folio is already mapped, all good, no need to
fallback to PTEs.

Assuming there is already a leaf page table ... the behavior would be
just like when trying to insert a PMD mapping a folio through
dax_fault_iter()->vmf_insert_folio_pmd().

Assuming there is already something else mapped as PMD? It sounds like
a BUG, and the behavior would be just like when trying to insert a PMD
mapping a folio through dax_fault_iter()->vmf_insert_folio_pmd().

So, it sounds reasonable to not handle huge zero folios differently
to inserting PMDs mapping folios when there already is something mapped.

Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/dax.c | 47 ++++++++++-------------------------------------
 1 file changed, 10 insertions(+), 37 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4229513806bea..ae90706674a3f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1375,51 +1375,24 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 		const struct iomap_iter *iter, void **entry)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
-	unsigned long pmd_addr = vmf->address & PMD_MASK;
-	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = mapping->host;
-	pgtable_t pgtable = NULL;
 	struct folio *zero_folio;
-	spinlock_t *ptl;
-	pmd_t pmd_entry;
-	unsigned long pfn;
+	vm_fault_t ret;
 
 	zero_folio = mm_get_huge_zero_folio(vmf->vma->vm_mm);
 
-	if (unlikely(!zero_folio))
-		goto fallback;
-
-	pfn = page_to_pfn(&zero_folio->page);
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn,
-				  DAX_PMD | DAX_ZERO_PAGE);
-
-	if (arch_needs_pgtable_deposit()) {
-		pgtable = pte_alloc_one(vma->vm_mm);
-		if (!pgtable)
-			return VM_FAULT_OOM;
-	}
-
-	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
-	if (!pmd_none(*(vmf->pmd))) {
-		spin_unlock(ptl);
-		goto fallback;
+	if (unlikely(!zero_folio)) {
+		trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
+		return VM_FAULT_FALLBACK;
 	}
 
-	if (pgtable) {
-		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		mm_inc_nr_ptes(vma->vm_mm);
-	}
-	pmd_entry = folio_mk_pmd(zero_folio, vmf->vma->vm_page_prot);
-	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
-	spin_unlock(ptl);
-	trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
-	return VM_FAULT_NOPAGE;
+	*entry = dax_insert_entry(xas, vmf, iter, *entry, folio_pfn(zero_folio),
+				  DAX_PMD | DAX_ZERO_PAGE);
 
-fallback:
-	if (pgtable)
-		pte_free(vma->vm_mm, pgtable);
-	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
-	return VM_FAULT_FALLBACK;
+	ret = vmf_insert_folio_pmd(vmf, zero_folio, false);
+	if (ret == VM_FAULT_NOPAGE)
+		trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
+	return ret;
 }
 #else
 static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
-- 
2.50.1

