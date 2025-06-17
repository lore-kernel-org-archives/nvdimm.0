Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A257E2BEC31
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 09:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750153753; cv=none; b=oa2DvutAf1mAsgV3fh7H8/dJV4YcmGZ1ZI4Xs9GKdU7pBNQHUviesemUGzAqbg7bd5vHRyN/rY9fmBO9Dw13XBB+JLhDwtuOJ9mVf6D0C4Bb8DQEfjxkrlw+qQ3znssy13KjP6C1mtWZgjTKJ4h0rE7D31BzlqRbWCCwoFJvdvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750153753; c=relaxed/simple;
	bh=qrU05cowUTxmPXZdvmuKlx038Y+ePF+BdxzSPeNoiuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gsx430cn8f5dBybegvhmLdgeLD24hxL75/yzYAEDlHvmMzYz519OuCXnJiLcobTK8dtWrVzS4QDFQeNqzSZpD8MK/n6lAoWQ3zkmepRhF+u+iRQkNKD3ccO0qkr2Lh5OV4tHbsRDep/WN0COKtTpetk9BowbIPuEMuTc4uPuR+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aw0oJ5IM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aw0oJ5IM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750153750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wo4mg5uf2kBxyfACTDHeiWOzvexFDUIWO7u3W357C7Y=;
	b=Aw0oJ5IMUf/8VXu43MmPXDJWCYADeyfej+HaSj3b3LHRJxn1cXjneWpwMevsaN29FsYv0O
	mt5rlwCJahFToKtONnpwaXLy5giHEeMRtwBe21dzZOJqm4vOsnBFbWuvHIpfNedxMMkz+F
	B/tF868qKk44WhvaAiZL6jLvxso2vbc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-04HrBhfKMBGw1F_OXE-sdA-1; Tue, 17 Jun 2025 05:49:07 -0400
X-MC-Unique: 04HrBhfKMBGw1F_OXE-sdA-1
X-Mimecast-MFC-AGG-ID: 04HrBhfKMBGw1F_OXE-sdA_1750153746
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451ecc3be97so27221905e9.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 02:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750153746; x=1750758546;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wo4mg5uf2kBxyfACTDHeiWOzvexFDUIWO7u3W357C7Y=;
        b=uXOVO+c1ZMwrgc5No+FlW+wGwXk2kK5tskOBWU+KdYBW2iZ+1U8WTRh7tHz1UiYIzz
         5wxSNjqQNHNzccnDPpDFd92C3vD9t5bUo5Vto5C/a0+6eS2NPH9bsW6gcuw3vC36l19L
         /PfIeC0l6I0PR4WveTdRDQxZNl3odJ30Ddgx/JJZb03zmRJlS8qvPAaD5tR9yDbFyEXc
         8SOJAsTSjFwgh/rnYp1N1MF65nQ/4AUE56nqgekV3rd4L4GTy4UXNj5uW5R9SVbBxTkj
         1A/v/rDZIaaJLt0XbvsM1xMN2IVLY6hmhbqZRkq5ZlPFXToLcafmGsz25HsJe6gc+4Jt
         HpOw==
X-Forwarded-Encrypted: i=1; AJvYcCWWytPDjzW9dDUAlJzkcg5bJDDMPkJ8AX/AsRVNbSvQ46fcp70VRhCRQNOdVvsLmbR0RxxrFCw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVeqAqE+69ecJUMOkgkZFEjUQb1FWtKNTSEICH7rCqrL7DM7GS
	i9Y+wDX60QhSV/23F497Vz+Y1HdVyyKSGRbqWQF2z5yI5L3FDw/IA+CyJ/KQG2aL3OJ4Xea5xmQ
	ip8VtxsiUMYpNUu5wJX3I+3NHwIDKYgH/OQsMRDSQZkGBYr/PtQ08+vgD2Q==
X-Gm-Gg: ASbGncsf+s/RPBood01HTbYvryc4lMZIBE+GuXTI/WA+VcfU4KzPigQXMlMuVhkfJdb
	Ib7r6IW71XQDjw+JpCHYWk8ay6gvq81Igl9TIvkF5poYsIOPpPnLpKJucLLPtPRotpS+U7gmqH5
	icL0O7dATrHBMqQp1H+qhgf7M14+ZAaCSc2VBblOh3ofhAZ3vLT848CO8QAP77E9zmCsu++lCM5
	/kreFfDIIfAB9qdbkkHO7vaOZbPzRyv0BR6bYEoab7ZL0IcDY3Hh/w/zzh4btcsgz8tNW5olaNk
	2Oqi6Lw3Ot3+BtlZ9KWrX6Fd1T4QrBcXohbGDrEFFXn7TXtuxHbR2Md7z8D0ZtsOila8XSO5zGf
	ArLugh0A//HBU79vUiptElM++vY700EwhB4pFRhFMZGep7Q0=
X-Received: by 2002:a05:600c:35cc:b0:43c:fe90:1282 with SMTP id 5b1f17b1804b1-4533ca43db6mr106722125e9.7.1750153746168;
        Tue, 17 Jun 2025 02:49:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHE+D/FkOgiBhmxEbiFOFBAH4xfqIHPd1NQKrE2y3oU4SHrJ3VSm38IyeaGpYOf5l0zRgg59A==
X-Received: by 2002:a05:600c:35cc:b0:43c:fe90:1282 with SMTP id 5b1f17b1804b1-4533ca43db6mr106721675e9.7.1750153745732;
        Tue, 17 Jun 2025 02:49:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e13d014sm171119765e9.24.2025.06.17.02.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:49:05 -0700 (PDT)
Message-ID: <1709a271-273b-4668-b813-648e5785e4e8@redhat.com>
Date: Tue, 17 Jun 2025 11:49:03 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/14] mm: Convert vmf_insert_mixed() from using
 pte_devmap to pte_special
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
 dan.j.williams@intel.com, jgg@ziepe.ca, willy@infradead.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net,
 m.szyprowski@samsung.com, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.8d04615eb17b9e46fc0ae7402ca54b69e04b1043.1750075065.git-series.apopple@nvidia.com>
 <5c03174d2ea76f579e4675f5fab6277f5dd91be2.1750075065.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <5c03174d2ea76f579e4675f5fab6277f5dd91be2.1750075065.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dkkrlGvRH-IjeSe5hlEeFyAnhpavz99FHdysAA64R-M_1750153746
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 13:58, Alistair Popple wrote:
> DAX no longer requires device PTEs as it always has a ZONE_DEVICE page
> associated with the PTE that can be reference counted normally. Other users
> of pte_devmap are drivers that set PFN_DEV when calling vmf_insert_mixed()
> which ensures vm_normal_page() returns NULL for these entries.
> 
> There is no reason to distinguish these pte_devmap users so in order to
> free up a PTE bit use pte_special instead for entries created with
> vmf_insert_mixed(). This will ensure vm_normal_page() will continue to
> return NULL for these pages.
> 
> Architectures that don't support pte_special also don't support pte_devmap
> so those will continue to rely on pfn_valid() to determine if the page can
> be mapped.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   mm/hmm.c    |  3 ---
>   mm/memory.c | 20 ++------------------
>   mm/vmscan.c |  2 +-
>   3 files changed, 3 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 5311753..1a3489f 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -302,13 +302,10 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>   		goto fault;
>   
>   	/*
> -	 * Bypass devmap pte such as DAX page when all pfn requested
> -	 * flags(pfn_req_flags) are fulfilled.
>   	 * Since each architecture defines a struct page for the zero page, just
>   	 * fall through and treat it like a normal page.
>   	 */
>   	if (!vm_normal_page(walk->vma, addr, pte) &&
> -	    !pte_devmap(pte) &&
>   	    !is_zero_pfn(pte_pfn(pte))) {
>   		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
>   			pte_unmap(ptep);
> diff --git a/mm/memory.c b/mm/memory.c
> index b0cda5a..2c6eda1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -598,16 +598,6 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>   			return NULL;
>   		if (is_zero_pfn(pfn))
>   			return NULL;
> -		if (pte_devmap(pte))
> -		/*
> -		 * NOTE: New users of ZONE_DEVICE will not set pte_devmap()
> -		 * and will have refcounts incremented on their struct pages
> -		 * when they are inserted into PTEs, thus they are safe to
> -		 * return here. Legacy ZONE_DEVICE pages that set pte_devmap()
> -		 * do not have refcounts. Example of legacy ZONE_DEVICE is
> -		 * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
> -		 */
> -			return NULL;
>   
>   		print_bad_pte(vma, addr, pte, NULL);
>   		return NULL;
> @@ -2483,10 +2473,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>   	}
>   
>   	/* Ok, finally just insert the thing.. */
> -	if (pfn_t_devmap(pfn))
> -		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
> -	else
> -		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
> +	entry = pte_mkspecial(pfn_t_pte(pfn, prot));
>   
>   	if (mkwrite) {
>   		entry = pte_mkyoung(entry);
> @@ -2597,8 +2584,6 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn, bool mkwrite)
>   	/* these checks mirror the abort conditions in vm_normal_page */
>   	if (vma->vm_flags & VM_MIXEDMAP)
>   		return true;
> -	if (pfn_t_devmap(pfn))
> -		return true;
>   	if (pfn_t_special(pfn))
>   		return true;
>   	if (is_zero_pfn(pfn_t_to_pfn(pfn)))
> @@ -2630,8 +2615,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>   	 * than insert_pfn).  If a zero_pfn were inserted into a VM_MIXEDMAP
>   	 * without pte special, it would there be refcounted as a normal page.
>   	 */
> -	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL) &&
> -	    !pfn_t_devmap(pfn) && pfn_t_valid(pfn)) {
> +	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL) && pfn_t_valid(pfn)) {
>   		struct page *page;
>   
>   		/*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a93a1ba..85bf782 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3424,7 +3424,7 @@ static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned
>   	if (!pte_present(pte) || is_zero_pfn(pfn))
>   		return -1;
>   
> -	if (WARN_ON_ONCE(pte_devmap(pte) || pte_special(pte)))
> +	if (WARN_ON_ONCE(pte_special(pte)))
>   		return -1;
>   
>   	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))


-- 
Cheers,

David / dhildenb

