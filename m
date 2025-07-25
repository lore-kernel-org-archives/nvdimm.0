Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB858F9D6
	for <nvdimm@lists.linux.dev>; Fri, 25 Jul 2025 08:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753430870; cv=none; b=oRzFFA3gxVyuaN55IuvJXhtPhDyZKtrsLIBtZZvsTBJ0gx44tu/nCKqwgHWrcfXc4mdeIf/U5GosFEX4UTFiAolluT5hyuWQ2C+CcHfuW3lA8zCfTcjZwW+KzE6BsWV2Yy+WLtNyDdZf/qxqqvluubK9VngYFdMxXFDrtb4CEkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753430870; c=relaxed/simple;
	bh=auO+0nXXt+NuDuF3lfzVvtuDC82gdWNOHt39vvi8AnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYEdvrfAGLAw/2HGDaLStfy08LeNs7gDbZ902THMzoeLpIckovIwjd2ZN8TFhwJc+bUMnt2bQtciz+98ad1Kj1jfMzN7n1Smyi+G6yVrNFFJh5LHc+QIqDTI+omYroWvBbpqhCmvwFkeOrnaOsSXMjtN3DTYBAIVsXoO6zeZJAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kDAfd/aB; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kDAfd/aB"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae0dd7ac1f5so330307566b.2
        for <nvdimm@lists.linux.dev>; Fri, 25 Jul 2025 01:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753430867; x=1754035667; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXMaEZZATaqkCZVg69+il4b2i1RIWEG7iB7MnNkYGzI=;
        b=kDAfd/aBj2GsBzQhNYW3pXjdc2gCuwFXoeYq7oOk8///smpGDRSDzR0xtYcQi160UL
         ibgkWInBgE55TB88tu4/aDsarMEvlAUO8jKVqsW8sRd+nFNVOPRY/EUl4ugEB8KGtIPW
         B1GE0uJ+KeOFIprBavonaCVKgu4gyzAiSJncb+DzqlOE9BMfh79UGY6BVijjur/KaJ6u
         pwlPMjMqMLHaVkTL9Vm8/++uaSP4wY8/lLLXM77tPF7pH7/QIz/+toJ/fFhY9bibhB8O
         NYZpX58RaGHEx6yHwGDy8aCY7lCX8b2iyE2ZB6b7z/yaozsPorLVhvPAXf9grHdZr9pU
         2hbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753430867; x=1754035667;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lXMaEZZATaqkCZVg69+il4b2i1RIWEG7iB7MnNkYGzI=;
        b=iEDgBKKKO2rdldSoGPH78HYJRiwyuBKN08iNva2Y5eBHHLMKE9kC7luNEdCU+Gzncx
         6LwxyuayiJzYr2ienUQiyxo3l2tDAjp/yjkcSXK4yHSGH6d5oRccuqelMd0K/5bHWRcf
         PGPT6sM/k/wsfLcL2bUMC3O3l5NGmyB2ifDXRxxC7vUedzL09NCCCcLghAmHhOMhfUYg
         QWjcDZDt3Va82+LNxALnJ09Xvt8prS7jbZZWmuew1ADe1bVLNLNbG92qaYWEz4kUN1DV
         PeDkFFzsfyowK2qMh4h3n7i9HnzQ3FPuwnVrPN1jD1kCbgp+PTIFBLWtVeZOMb3yhY3m
         Sp2A==
X-Forwarded-Encrypted: i=1; AJvYcCUB3RC67HMatGujcC0NkfNdHXR1tUEuxg+gd1kdb+7Pn9O7PUh7/XRcmXrxRwPjHh8BsnzVc74=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCkCTJyBGlK7yqw1hlIhDMvRrs80lWc6jqn1pPhXMzc3jzkH0s
	jI7fVxvtiyDR0eQWipBwIJ6KXr57B7IfVOdveIwc0A6CCdg9ZTOpd2ZL
X-Gm-Gg: ASbGncut07x3DM/RKFl3xqyBL4U0I8AHB5dvK1Gk0rLqTCSlGkWxJTJtmBitf4fTCS5
	IPJIp9WRUAcqAowoXGzA/wmmkg64nwjsRfJF3lJtusG+7W4dPE9dhEVxzt6Mb5aSFAReI7tO2EC
	b53GHI3QJpz+H+ceF6YVIT2JrCiQR4z2Z2Acg9QVHSIHLYSk0pzqh9GML4nxf8TfB4MtTA0OrFn
	z/hxECtGstRReGUXjbmzssFz6YUC+d3GabOnn+9KgE66yiEDBuxa2y96Km/eZafVaeAm7L3cYw8
	cmrP0XHMIt5/RRLtskaxbP7iBlwZUReEcMeeNJ1hyrXts9Eq//AOMWENxG8FWHgvmaosDstwL09
	hwkWgvv+//tdyvRxnsp/DyQ==
X-Google-Smtp-Source: AGHT+IHl6UmUdU8B6e4xhx6Ln8Ji33PC6IYqJ94cYWNmCS+nZAA1Gam8BVTsB8iILWrkEqlErnW5Hg==
X-Received: by 2002:a17:906:7949:b0:ae8:476c:3b85 with SMTP id a640c23a62f3a-af6172034a8mr105706166b.8.1753430866719;
        Fri, 25 Jul 2025 01:07:46 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-614cd0d1f85sm1848549a12.4.2025.07.25.01.07.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jul 2025 01:07:46 -0700 (PDT)
Date: Fri, 25 Jul 2025 08:07:45 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 3/9] mm/huge_memory: support huge zero folio in
 vmf_insert_folio_pmd()
Message-ID: <20250725080745.clm4s73fqtmsnqsn@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-4-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-4-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Jul 17, 2025 at 01:52:06PM +0200, David Hildenbrand wrote:
>Just like we do for vmf_insert_page_mkwrite() -> ... ->
>insert_page_into_pte_locked() with the shared zeropage, support the
>huge zero folio in vmf_insert_folio_pmd().
>
>When (un)mapping the huge zero folio in page tables, we neither
>adjust the refcount nor the mapcount, just like for the shared zeropage.
>
>For now, the huge zero folio is not marked as special yet, although
>vm_normal_page_pmd() really wants to treat it as special. We'll change
>that next.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>
>---
> mm/huge_memory.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 849feacaf8064..db08c37b87077 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -1429,9 +1429,11 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> 	if (fop.is_folio) {
> 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
> 
>-		folio_get(fop.folio);
>-		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
>-		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>+		if (!is_huge_zero_folio(fop.folio)) {
>+			folio_get(fop.folio);
>+			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
>+			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>+		}

I think this is reasonable.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

> 	} else {
> 		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
> 		entry = pmd_mkspecial(entry);
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me
