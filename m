Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9C623496B
	for <nvdimm@lists.linux.dev>; Tue, 18 Feb 2025 11:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739878658; cv=none; b=LwKBic4rWx0p86TWENed77jqF9xDZhBHdLU7Q1FkUisxv3el5Y9diwUDSkjN40kRU+7dMoBkZpzuUGIyTqkYs6hfQiNC9Val9Kw/NVf+AocAfhaauzwcn0tlqWFNngFxdFIvPWAlgqElAY7fSl0pGbQN+cgpeJytsrzgZU4VY6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739878658; c=relaxed/simple;
	bh=rB+SbcpFCdmiOPV/BM90V5rcqs3Ru/L2xe8wSM+/qS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JHZTdP2/8Wj7UyUHwTY58yuK2PHQzQ/yH/DLQCLFYe3WUpeQtH8OvC8JP1EpENif1djKyyoeeUrLGFlKOqEfwHxRZa9U5u9r0HJkYF4h0aAlvSzZepWuPOHWht7xHQDnqOREgac+sFNKiECLFhJ+rPSR5iD4ajRATmhCSs9ytlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VsxYUHgc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VsxYUHgc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739878655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3KYEQ9uPTnjY2p/sMmDxtE88/IrnTJfnjpzPNyXQ728=;
	b=VsxYUHgcnH/907t01d1ZI8uNJZ2a29m7D6EMeYNIbE5r3L1tO7bPmzMRBlItZhkp82/4Au
	6JSSd6JOXJ5skpsJ7ZVP3k2iPJFfqCch4NjuHlbbVAnr4WAcv/vInalIv83Bmc5GW6BZzo
	zWYNsDKAKnOyB5f/dFCuaLOpF9Qe3zo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-FS9QDMafObGSTEub3_XeIA-1; Tue, 18 Feb 2025 06:37:34 -0500
X-MC-Unique: FS9QDMafObGSTEub3_XeIA-1
X-Mimecast-MFC-AGG-ID: FS9QDMafObGSTEub3_XeIA_1739878653
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43933b8d9b1so28603935e9.3
        for <nvdimm@lists.linux.dev>; Tue, 18 Feb 2025 03:37:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739878653; x=1740483453;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3KYEQ9uPTnjY2p/sMmDxtE88/IrnTJfnjpzPNyXQ728=;
        b=qnHIL1BfbI7R+OUVOC3E/nzySYqxj8g7T4gXcr0LRvH/8LskFFh3uA2BfJmD/82y+c
         JZUOdIRC76TZSpRuAILeynhPKDrgo8CR2tW7QtTmXdRFXQKGQ9jVxeGIrDyoEa5ACYhf
         40bB0WCZoX7+I2Zm5fdF0zthV8GsOrGSyjB+TNn9s+8ZyM5475p+TNGRvUUP6B6W5UUD
         0fWw5tV2ePvvlY3Zi1FEAE+n8FzVtKjqfIpu6Hnfx8BX8NB/B6oX6cmN7yFj5yh2KnzO
         dqs4tfWLKRIpbMkfCZZ6MbKzg1P8AZfJJ12WFqf3VYkcuuQB5KHlpAx4jtgY3FVqDUlh
         OMrA==
X-Forwarded-Encrypted: i=1; AJvYcCUCQf3DfzFezTzINYKpkKAnVliuXLQx83bhmZUYcEDyipJUTrw2oBbaocf+kxvgMQdXKDmAgd8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDjYiv7U+Yt+rlIJur8cvZp7Y7NiWMP/+hQ3sKCy8Ig+kaIyt5
	WzxeyMCxP5WXbu7+IIkOD2pwpXQukyfqUZufvImTk8u1CFZAMpOwMYWit3Gpy54vRirQueMWNNA
	Yf44f22Pj2s91NYmAIQo0319h9IUR1SIdVaOAUSsB1PDjXtQpk7h9OQ==
X-Gm-Gg: ASbGnctFk0n3F/YXuFtWD4BaKdZtJRf9bJfUSVP+yFIEMdUNdYb2BNn3TIBixsbqYm5
	KQQxgU7ZgNdbdxltylua+yzYfCwUx22KjSRUDHB7YC3lm2gAAuKZFlYIgeOrwbcq0vr2DYOHy4M
	0sNMZcSDYflk7vZ/SDSUyy+sZk6NiaQ67L1hR7Bnqj588wwL7AdkGyvLSyGt5q3fK2DT9mOy0A+
	tquQAjEoebJtD6cc9jrUzorikbzNQ+4EylNyWYFcANI4xb7wp4IZMSQ7jckKZXUX9odriH0Xdqy
	sLKaVyoZnS59ONin9xJN4Wt/JwQSmSi6+GWEw8KvlD1KujLBBMJ9xhkD0KqWWPVJx97JZO4cxwO
	dcViOYtqfD1OWYG2rWJK01iQnIwi/tTTB
X-Received: by 2002:a05:600c:3107:b0:439:98ca:e390 with SMTP id 5b1f17b1804b1-43998cae421mr406015e9.27.1739878653188;
        Tue, 18 Feb 2025 03:37:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbabLu7vXUCSD0KjrAUx0yqgTTkLbXo6HpuVQb6Cs/Gdy4/wAwG8GKVTrqyk1JHoNpZDyU9w==
X-Received: by 2002:a05:600c:3107:b0:439:98ca:e390 with SMTP id 5b1f17b1804b1-43998cae421mr405775e9.27.1739878652740;
        Tue, 18 Feb 2025 03:37:32 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:fb00:d3ed:5f44:1b2d:12af? (p200300cbc70dfb00d3ed5f441b2d12af.dip0.t-ipconnect.de. [2003:cb:c70d:fb00:d3ed:5f44:1b2d:12af])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439872b5a46sm47439565e9.32.2025.02.18.03.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 03:37:31 -0800 (PST)
Message-ID: <cb29f96f-f222-4c94-9c67-c2d4bffeb654@redhat.com>
Date: Tue, 18 Feb 2025 12:37:28 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 19/20] fs/dax: Properly refcount fs dax pages
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: Alison Schofield <alison.schofield@intel.com>, lina@asahilina.net,
 zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
 bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
 will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
 dave.hansen@linux.intel.com, ira.weiny@intel.com, willy@infradead.org,
 djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, peterx@redhat.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name,
 loongarch@lists.linux.dev
References: <cover.a782e309b1328f961da88abddbbc48e5b4579021.1739850794.git-series.apopple@nvidia.com>
 <b33a5b2e03ffb6dbcfade84788acdd91d10fbc51.1739850794.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <b33a5b2e03ffb6dbcfade84788acdd91d10fbc51.1739850794.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tqyPp1VPmDeblKk4n_aAOBISbZdRJFuvgwZckEuxbPo_1739878653
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.02.25 04:55, Alistair Popple wrote:
> Currently fs dax pages are considered free when the refcount drops to
> one and their refcounts are not increased when mapped via PTEs or
> decreased when unmapped. This requires special logic in mm paths to
> detect that these pages should not be properly refcounted, and to
> detect when the refcount drops to one instead of zero.
> 
> On the other hand get_user_pages(), etc. will properly refcount fs dax
> pages by taking a reference and dropping it when the page is
> unpinned.
> 
> Tracking this special behaviour requires extra PTE bits
> (eg. pte_devmap) and introduces rules that are potentially confusing
> and specific to FS DAX pages. To fix this, and to possibly allow
> removal of the special PTE bits in future, convert the fs dax page
> refcounts to be zero based and instead take a reference on the page
> each time it is mapped as is currently the case for normal pages.
> 
> This may also allow a future clean-up to remove the pgmap refcounting
> that is currently done in mm/gup.c.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

A couple of nits (sorry that I didn't manage to review the whole thing 
the last time, I am a slow reviewer ...). Likely that can all be 
adjsuted on top, no need for a full resend IMHO.

> index 6674540..cf96f3d 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -71,6 +71,11 @@ static unsigned long dax_to_pfn(void *entry)
>   	return xa_to_value(entry) >> DAX_SHIFT;
>   }
>   
> +static struct folio *dax_to_folio(void *entry)
> +{
> +	return page_folio(pfn_to_page(dax_to_pfn(entry)));

Nit: return pfn_folio(dax_to_pfn(entry));

> +}
> +

[...]

>   
> -static inline unsigned long dax_folio_share_put(struct folio *folio)
> +static inline unsigned long dax_folio_put(struct folio *folio)
>   {
> -	return --folio->page.share;
> +	unsigned long ref;
> +	int order, i;
> +
> +	if (!dax_folio_is_shared(folio))
> +		ref = 0;
> +	else
> +		ref = --folio->share;
> +

out of interest, what synchronizes access to folio->share?

> +	if (ref)
> +		return ref;
> +
> +	folio->mapping = NULL;
> +	order = folio_order(folio);
> +	if (!order)
> +		return 0;
> +
> +	for (i = 0; i < (1UL << order); i++) {
> +		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> +		struct page *page = folio_page(folio, i);
> +		struct folio *new_folio = (struct folio *)page;
> +
> +		ClearPageHead(page);
> +		clear_compound_head(page);
> +
> +		new_folio->mapping = NULL;
> +		/*
> +		 * Reset pgmap which was over-written by
> +		 * prep_compound_page().
> +		 */
> +		new_folio->pgmap = pgmap;
> +		new_folio->share = 0;
> +		WARN_ON_ONCE(folio_ref_count(new_folio));
> +	}
> +
> +	return ref;
> +}
> +
> +static void dax_folio_init(void *entry)
> +{
> +	struct folio *folio = dax_to_folio(entry);
> +	int order = dax_entry_order(entry);
> +
> +	/*
> +	 * Folio should have been split back to order-0 pages in
> +	 * dax_folio_put() when they were removed from their
> +	 * final mapping.
> +	 */
> +	WARN_ON_ONCE(folio_order(folio));
> +
> +	if (order > 0) {
> +		prep_compound_page(&folio->page, order);
> +		if (order > 1)
> +			INIT_LIST_HEAD(&folio->_deferred_list);

Nit: prep_compound_page() -> prep_compound_head() should be taking care 
of initializing all folio fields already, so this very likely can be 
dropped.

> +		WARN_ON_ONCE(folio_ref_count(folio));
> +	}
>   }


[...]


>   }
> @@ -1808,7 +1843,8 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
>   	loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
>   	bool write = iter->flags & IOMAP_WRITE;
>   	unsigned long entry_flags = pmd ? DAX_PMD : 0;
> -	int err = 0;
> +	struct folio *folio;
> +	int ret, err = 0;
>   	pfn_t pfn;
>   	void *kaddr;
>   
> @@ -1840,17 +1876,19 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
>   			return dax_fault_return(err);
>   	}
>   
> +	folio = dax_to_folio(*entry);
>   	if (dax_fault_is_synchronous(iter, vmf->vma))
>   		return dax_fault_synchronous_pfnp(pfnp, pfn);
>   
> -	/* insert PMD pfn */
> +	folio_ref_inc(folio);

Why is that not a folio_get() ? Could the refcount be 0? Might deserve a 
comment then.

>   	if (pmd)
> -		return vmf_insert_pfn_pmd(vmf, pfn, write);
> +		ret = vmf_insert_folio_pmd(vmf, pfn_folio(pfn_t_to_pfn(pfn)),
> +					write);
> +	else
> +		ret = vmf_insert_page_mkwrite(vmf, pfn_t_to_page(pfn), write);
> +	folio_put(folio);
>   
> -	/* insert PTE pfn */
> -	if (write)
> -		return vmf_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
> -	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
> +	return ret;
>   }
>   
>   static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
> @@ -2089,6 +2127,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
>   {
>   	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>   	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, order);
> +	struct folio *folio;
>   	void *entry;
>   	vm_fault_t ret;
>   
> @@ -2106,14 +2145,17 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
>   	xas_set_mark(&xas, PAGECACHE_TAG_DIRTY);
>   	dax_lock_entry(&xas, entry);
>   	xas_unlock_irq(&xas);
> +	folio = pfn_folio(pfn_t_to_pfn(pfn));
> +	folio_ref_inc(folio);

Same thought.

> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 2333c30..dcc9fcd 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -209,7 +209,7 @@ int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
>   

[...]

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d189826..1a0d6a8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2225,7 +2225,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   						tlb->fullmm);
>   	arch_check_zapped_pmd(vma, orig_pmd);
>   	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> -	if (vma_is_special_huge(vma)) {
> +	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {

I wonder if we actually want to remove the vma_is_dax() check from 
vma_is_special_huge(), and instead add it to the remaining callers of 
vma_is_special_huge() that still need it -- if any need it.

Did we sanity-check which callers of vma_is_special_huge() still need 
it? Is there still reason to have that DAX check in vma_is_special_huge()?

But vma_is_special_huge() is rather confusing from me ... the whole 
vma_is_special_huge() thing should probably be removed. That's a cleanup 
for another day, though.

-- 
Cheers,

David / dhildenb

