Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE712ED860
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175037; cv=none; b=lhXYl8jjatl0tOU3qTzgivL4l2kBtHgwS1hTNDHcIdH8lfBQxzEiG34mksKdMmHwoZBmSqtJ15oAtl5hL2YhJDZ3+UauZYJ3GACKxIRyhk1bSeQeYZu55neoNKXovrficXqXlnewvDz5LdQhlCoZW+2byL+4d0ayuqPMzqqTTyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175037; c=relaxed/simple;
	bh=gfOK1w8At4LCO+SEz2YxE1sL/b3knNVAuIBGQzCExJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=de0ps81fjlF7FHhjxcXPied2ijyklFc1GTUTGFnx712Gtxb7DYVyfTkbAIxy/Gv4OwH7pOqFAEPgbk7VHLtogYk3KWJpo6ZPKJbewlmMrepS7cqKZS9w3fwFPOb+keZhAeuG1+HGTKpTQbjbXpnQdoTUDxhjT0ebVWHAndNW5BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMIC99Uz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMIC99Uz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t4hXdfl2BxaEs0JquHL/H5jXrrSdl8LRqFfGRUF6aUs=;
	b=FMIC99UzEzufAvhQpIMe2mLTti9TX7Uk8bS25j+TikevIgFG9p6JSWwOdw45D6Wrbep94r
	N+Pj0rZD5mL14uvx8SDn1OQ4BU3GvPIB8J/Fr7a3ccuJdFwNSK8zq+/SK7QYzPe+/23xBH
	054GJlfgQO9Afh6oe0kucPKqMDpTHQo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-QWMQDosZMlKXldkbQ0VYLA-1; Tue, 17 Jun 2025 11:43:51 -0400
X-MC-Unique: QWMQDosZMlKXldkbQ0VYLA-1
X-Mimecast-MFC-AGG-ID: QWMQDosZMlKXldkbQ0VYLA_1750175030
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a56b3dee17so2219147f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175030; x=1750779830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4hXdfl2BxaEs0JquHL/H5jXrrSdl8LRqFfGRUF6aUs=;
        b=qbIi5a92DlF4/FHuXtrFmgMmVTjYPsPH2DG33uM67AEHEf9u/PYXcfvcaar7XtEm1r
         cg3hP+cBbG7vl2HXSI/+KxbkWYp7stmHT/qw3yuu35WLKnqpNDTTvr5KrdgyEt0BcqFo
         zXYQe1LfAljmE+vM4IZuBdPqWeA5b//HQBAcIbqFjBGVRnd7OaCuNaP4p0cnsYTKJh+d
         PVicl+y73UmZh9oalfy2jTfFv8PsTalXqUlTTqKiudviPC6ESSRV8DUY8mp4w8zkbbQ/
         bUTBQbaWD/yOTV0FL09Bg9gvhUKr2rn42FyAuLAHAAZDJO+QT2W4SS4CQ7VnlibluIZB
         xZtw==
X-Forwarded-Encrypted: i=1; AJvYcCX5X/5qmsBfS9XqSZ/XR3gtqS+X1z8602P16MaJyd/go0yK8qU9I2/matcdbtuWNmegpV0Bb/I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyoBSPhulzhCFZugC15PcoWGSrZABFYJNwjf8s5aHkpwdhzh4l1
	qgWvzmXha9RSmIkw/vRVLyO+HUDml8lBk5xEuFz2UDXSdbgiHneYYOKj3day9ij9ef9u3EWc+Cx
	CYZDpVYlbaqbS/UITVgvjT8VRAzvgXfK51DM55yAv/mo9v3NiPmDdegcZnA==
X-Gm-Gg: ASbGncsDuj79SrCSE2lfesh5ZARgM3RCOaiQbfqQlh+2v1o/pW44wAnhLGCcxoscdNx
	Tqpvkp/2IcfIdgX5g6lbfZ5cCKj8n8v9tH6FyIQAUEAk1oCd52B72s0Xu/YhkTcwCGLHCLX7qMH
	Pd65ymZBOY407qlU9CeqcvNge7DTnzDFC7ZUlvQv1wvBYwRRaSpEQjBMl2ca7hSN74pwmi4WuJf
	8WSNwxwuzXZGfx04EtMp4623C3KSqA8lw9Id1BRqnSXgP75jIzB3KI+vhbMx6L1ulikBkYFRpFv
	ocq6LxW4rIw5LLdCS+LPAJQeSL59/Tcbxo78ntYE7lrjeMTHt1impM32le3NkJafJXH+Uj9cJWi
	mZ4vnkA==
X-Received: by 2002:a05:6000:1884:b0:3a4:eb7a:2ccb with SMTP id ffacd0b85a97d-3a56d821e4dmr12961326f8f.16.1750175029941;
        Tue, 17 Jun 2025 08:43:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcoD8JqLOB4EjbN+k5qD0zJS7SAB63dB1ZbzMQjH6b78ztWbJgN3nPYj9/mZ7cyKIKJjAtyA==
X-Received: by 2002:a05:6000:1884:b0:3a4:eb7a:2ccb with SMTP id ffacd0b85a97d-3a56d821e4dmr12961278f8f.16.1750175029492;
        Tue, 17 Jun 2025 08:43:49 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a568a54a36sm14542075f8f.15.2025.06.17.08.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:43:49 -0700 (PDT)
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
Subject: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity check in vm_normal_page()
Date: Tue, 17 Jun 2025 17:43:32 +0200
Message-ID: <20250617154345.2494405-2-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: GoNmDajC02YpUbcws4RsxxuOsu5-rH6L8AGwopNjg0Y_1750175030
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In 2009, we converted a VM_BUG_ON(!pfn_valid(pfn)) to the current
highest_memmap_pfn sanity check in commit 22b31eec63e5 ("badpage:
vm_normal_page use print_bad_pte"), because highest_memmap_pfn was
readily available.

Nowadays, this is the last remaining highest_memmap_pfn user, and this
sanity check is not really triggering ... frequently.

Let's convert it to VM_WARN_ON_ONCE(!pfn_valid(pfn)), so we can
simplify and get rid of highest_memmap_pfn. Checking for
pfn_to_online_page() might be even better, but it would not handle
ZONE_DEVICE properly.

Do the same in vm_normal_page_pmd(), where we don't even report a
problem at all ...

What might be better in the future is having a runtime option like
page-table-check to enable such checks dynamically on-demand. Something
for the future.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0163d127cece9..188b84ebf479a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -590,7 +590,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 
 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
 		if (likely(!pte_special(pte)))
-			goto check_pfn;
+			goto out;
 		if (vma->vm_ops && vma->vm_ops->find_special_page)
 			return vma->vm_ops->find_special_page(vma, addr);
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
@@ -608,9 +608,6 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		if (vma->vm_flags & VM_MIXEDMAP) {
 			if (!pfn_valid(pfn))
 				return NULL;
-			if (is_zero_pfn(pfn))
-				return NULL;
-			goto out;
 		} else {
 			unsigned long off;
 			off = (addr - vma->vm_start) >> PAGE_SHIFT;
@@ -624,17 +621,12 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 	if (is_zero_pfn(pfn))
 		return NULL;
 
-check_pfn:
-	if (unlikely(pfn > highest_memmap_pfn)) {
-		print_bad_pte(vma, addr, pte, NULL);
-		return NULL;
-	}
-
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
 	 * eg. VDSO mappings can cause them to exist.
 	 */
 out:
+	VM_WARN_ON_ONCE(!pfn_valid(pfn));
 	VM_WARN_ON_ONCE(is_zero_pfn(pfn));
 	return pfn_to_page(pfn);
 }
@@ -676,14 +668,13 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 	if (is_huge_zero_pmd(pmd))
 		return NULL;
-	if (unlikely(pfn > highest_memmap_pfn))
-		return NULL;
 
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
 	 * eg. VDSO mappings can cause them to exist.
 	 */
 out:
+	VM_WARN_ON_ONCE(!pfn_valid(pfn));
 	return pfn_to_page(pfn);
 }
 
-- 
2.49.0

