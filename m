Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2842E49AB
	for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585847; cv=none; b=qO86yRPeV5hBmIf8mCZ+MV0rT92gQtMFBvltpvOsDzxFtqzmBxjHthOIboi3icp65oCVuCGiXx9BvQSEeufNe8pKeNZu5By3U4YgaYwBsmGfeHy3MmXTNxxR/4wxqb0sy0RC11hUAyc+3RwZpJJvd6spRUr3woF458d04n3AD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585847; c=relaxed/simple;
	bh=yZaVydwJy2K+pkk0zyqpHMa7aAU8xrX/gvDj6EOoSgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DjDAErbrBC5B8EeZTCvBqVVI9XpBjzTq8NgD5qA58iUAH2920BVp/FnE4aifo/JEbzpawdJJIthsuEf2QlYFdvXMwfzyOSqPstNeFbEYdSq+6WDGwWayU/rwKdiOqthMHquiQl/xnxYgPHRZTtXPWzVg2OPzfYAEvxxpZ+NXwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGqOZEo+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGqOZEo+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752585845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=80PJLXORrw3H7rwjCmXyFxVPsu/BFZ5pBpUGrZ/8JVA=;
	b=JGqOZEo+oTLb9+6P/0Om5vIyePNysJU41M+u0s5NJxTpa4rTA4HgxgL9JjTniOWyz1yLQI
	9MApVInTIQ0r3jU1tZhn3QCL4Vkosdf7RrvBIfsx9kS+2gKGB+4sV3SlnqwMAxr04OpTmu
	uIHEKUxsCbI7ZpddttgEm+WjAiMltrI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-jQ3p9jkcNoSkpUk6T4JbvA-1; Tue, 15 Jul 2025 09:24:03 -0400
X-MC-Unique: jQ3p9jkcNoSkpUk6T4JbvA-1
X-Mimecast-MFC-AGG-ID: jQ3p9jkcNoSkpUk6T4JbvA_1752585843
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso4181569f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 06:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585842; x=1753190642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80PJLXORrw3H7rwjCmXyFxVPsu/BFZ5pBpUGrZ/8JVA=;
        b=ctd9fHfW8Ivj8+ekr46iIgPvNYOt0woGktwfF39O5JemEJ4RlId0HX5/3lzWXyd075
         r5NBEy6A5+nEBSO667/8XeP/JrVmq50WdgOtqMGObncDYUWKwPFdP6BksXoEsZWLsh/3
         6qNj8sTwiQfNUyObczA3WSQktImynLIC3/dwhb6WSAAUwicOSCff7x78NzNe2I1ucmD9
         cOYEca1kpEJRzxhAhCwOqL3X+TcesK2cD4dNzxbDU7xz9usJ9q20tX7KDODEof9RwwVv
         jBpNUNRMIhlL68cRwimTfuyG9kzdF+ZMoldOzLpiVgF1slG9dPwq8KNUtMhbj5c8IxZo
         P94g==
X-Forwarded-Encrypted: i=1; AJvYcCVPQ5VbpMgsbzQ9CQYEiOd+TbOaJQVr4CnX4r+80lOeSDhPZaafuPvQyFFKVU0u2qipbZ1QO64=@lists.linux.dev
X-Gm-Message-State: AOJu0YwztL//PlRBUfKtQtGYZryfVmtwFUQbmvbA9Jap3IrgSbDntAjK
	n3kKvfF9pIvL7XMVxyk/Et7LhMBTI0Sh9Lu/CDSeOZq6YTRy8dZjr88DeIAicWA6/rcDOSVVl1L
	wL9odTleIYdy9xKYDAhrFOX5FWvlf+X1cuuU0tvb6po0Y4tmwz+81uUN3lw==
X-Gm-Gg: ASbGncuwFEw6p9momch+lv6T1AlDMk+4ZV89SGZk6c+cmwl4U/CSIWknqUqGg0hwsSe
	VVWdm3ikk7Nc4XtC2sdrzoOczsbT3UZmVUfkUjcw2oSZa4VxqPlxesG1aMKLcv5kP8sjLAn7lqg
	gY7/h1zO0Yw1D831sk5vXtkTszcG8P+OKxo3WgE6hMHg7ZBLbVvYtHy6+APgDmIZTBf8XfPpJo1
	WSX5rJMNBjd7CSp0SxwzaifE7JMccZFQ2bfI6n7SVhlTfjF25J0Jml5YDqzGjqHiEq0G89bwdRw
	7+vy+cABAWPYxklH93D4c1fVuXDO5LpqK3Sjv2lkZjm6OA44LFvl+H/a+fQQf2sA+OVE0SvIfYh
	lLFlDe01+ALweb1Zh4vgOxxVw
X-Received: by 2002:a05:6000:230e:b0:3b5:e6f2:9117 with SMTP id ffacd0b85a97d-3b5f2e3083dmr13500618f8f.39.1752585842425;
        Tue, 15 Jul 2025 06:24:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4Mv4tTd5MMu5ncCf3BOQ9JFfOJXwaxaOdtEK+d74QRgh71f+xeQhxUGyEq6hfTSErOkM9rA==
X-Received: by 2002:a05:6000:230e:b0:3b5:e6f2:9117 with SMTP id ffacd0b85a97d-3b5f2e3083dmr13500595f8f.39.1752585841971;
        Tue, 15 Jul 2025 06:24:01 -0700 (PDT)
Received: from localhost (p200300d82f2849002c244e201f219fbd.dip0.t-ipconnect.de. [2003:d8:2f28:4900:2c24:4e20:1f21:9fbd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b5e8e0d719sm15297274f8f.54.2025.07.15.06.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:24:01 -0700 (PDT)
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
Subject: [PATCH v1 4/9] fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
Date: Tue, 15 Jul 2025 15:23:45 +0200
Message-ID: <20250715132350.2448901-5-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: zCOihO8b4_s1782Ywjx0BX9EXGQPYbMM98B96He0sI0_1752585843
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

