Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C823E156644
	for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867020; cv=none; b=Mc+4GruKi3fkHVBDVdLFlJ1/Bn1LAm5Rv81NUP32la6hE4J9Nkc9lW1Kn2JPXaGfgHtdHkXFmxMU2lM9uhIFbQJb/HqoYFKCeFOf0hwojQnkp31SDH7l7UVHegYZfcqYRb7KcFxkaaSwuHkvWqAGSjQiM5bKmZZla636TAe4JQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867020; c=relaxed/simple;
	bh=PkEVrbM1cp8L+UAv6tCljnykZ3h70Hb9k6ZyDysp8t0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aUgkbkDv4/0bENzke5oRnlndsDJrxBBR8cKJa329ILGZAiY7/RPd74GhWRPfnXEn/tdR+IcMTtDo/xgT470DfrT9BATOONQze4lv/sbaRZ+xDG9jOJM6brinBqyJJeUa4m8OlFQqyn/sD8gj3iEsmcvpi9+WsXol120KMkxKAZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzyHnM5O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzyHnM5O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736867017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EVcF0mu+oOpfopIC/ZRaz1f1Q3v6efqkEhKRWk3onBA=;
	b=WzyHnM5OmgzZoYMTGaimQd6F956nnnhkXemAbZDw3r5em9gy4hbQRV4Lf6W6oOXKLMBYRe
	x5KYrVNIb6OzUjKIwcYk13A2I4xeHWBTEMzr6XbYXMp4lkERAXxEuzeLwCvFYHsaACKbSb
	LeghWLrj91rZWqyD32Z/z0GklWBLcp8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-pidPFQ3yPKuLGkiqlJSErg-1; Tue, 14 Jan 2025 10:03:36 -0500
X-MC-Unique: pidPFQ3yPKuLGkiqlJSErg-1
X-Mimecast-MFC-AGG-ID: pidPFQ3yPKuLGkiqlJSErg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385d7611ad3so3163767f8f.2
        for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 07:03:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736867014; x=1737471814;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EVcF0mu+oOpfopIC/ZRaz1f1Q3v6efqkEhKRWk3onBA=;
        b=LeOyFQZzBF8LKCDKxFcTJlgpsJasE2RFkfYR17prZsipxO0i7/5gNoqkDkQcTfM1Mc
         nal2UJNJBp8CEXi+w2ghpMMUfToyAKiH20aNHBNaj+obzkbF8Qf2AQYirEPB2w8Oo+ST
         HMFn7Cx3Vfss4+6kRv3h3mu4pbGlmG9yQytA9BPbwUH+e8Jw/FVyZ8T+Lsy018fr8DoP
         EsV9TG0DRQVYx5EkXNqyGIOSm91e7cSCLWulok0kAmMEpHAv8d8bxqf+CxRqDP6IcoWc
         RU9tr4/0BHHtWL1EUQWiFiivEfzmV9uF4VUwh/Y4Nw/LmYbpZC42QtrqQPc+qcl1X8PD
         jfaw==
X-Forwarded-Encrypted: i=1; AJvYcCVh/06bXunaWoCvkq5fHtg3bQvH5vXUTSrCwdGb1ZSTRoeZedoTSvBT/g804xU9TYpaucFJ9DM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+b5bm5pkj2F9duNHn4F40a05XoTD62Cj8QpN674Al18h3Gori
	6dHNmszHCbayNzgjX+AEzQ/fg2IsVC3jNvk8TLaKrGTUWdbOUSi8LpqQO6SV9YveHouXzCH5J1s
	6E22gJXzSjZoBO7sc7IugKm5eWq/+es52Jsjq+3MzCHOSkn9XGq2Aug==
X-Gm-Gg: ASbGnctQkY05suPCOPYoWBtjeTX/OIld+rC2O6lD2tzhvjEXorm/UrwyXU/qBseI22Y
	zypxWe0ro2ETC9hNmPpsOs83Ew62zVVDoz3MUfVpKcQYFkxhufHN2MknxseLFjJHGccxNZc/8D+
	JQam8G3szmiSpFH3//PWPwpdd40NWN7VlWxKYsog/JKfid9h1OSN6NfcNoWLV2og2+qop96N6JG
	msTHofw/nnwDgcdk7gefL3GawAc2u54JsLIuV8sAx6xjXuC2FDX4wuqJMUQZxio1w0xbsvmn+eZ
	V2V3FW0yXYxmakW23GAw4rMTqrF86FammmCXydgUp8qazFXjJxctuCI2v1uYRL2dbJ54Ogca4GO
	u8htHH9bU
X-Received: by 2002:adf:c08d:0:b0:38a:87cc:fb42 with SMTP id ffacd0b85a97d-38a87ccfc9cmr18854404f8f.21.1736867012186;
        Tue, 14 Jan 2025 07:03:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHM3HjhBhsAPB1JfMTMphs8VamtwcWCRs8AeFhEVZ770be4gDgdSn1pqkoBasZXrNwqQMUsQg==
X-Received: by 2002:adf:c08d:0:b0:38a:87cc:fb42 with SMTP id ffacd0b85a97d-38a87ccfc9cmr18854332f8f.21.1736867011446;
        Tue, 14 Jan 2025 07:03:31 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9d8fc51sm180089645e9.7.2025.01.14.07.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 07:03:31 -0800 (PST)
Message-ID: <c3df67b5-47f5-4a2c-ba50-cc0de2b937f5@redhat.com>
Date: Tue, 14 Jan 2025 16:03:29 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/26] mm/memory: Enhance insert_page_into_pte_locked()
 to create writable mappings
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: alison.schofield@intel.com, lina@asahilina.net, zhang.lyra@gmail.com,
 gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
 jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
 mpe@ellerman.id.au, npiggin@gmail.com, dave.hansen@linux.intel.com,
 ira.weiny@intel.com, willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
 linmiaohe@huawei.com, peterx@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com,
 hch@lst.de, david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name,
 loongarch@lists.linux.dev
References: <cover.11189864684e31260d1408779fac9db80122047b.1736488799.git-series.apopple@nvidia.com>
 <68974d46091eea460f404f8ced3c6de5964c9ec4.1736488799.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <68974d46091eea460f404f8ced3c6de5964c9ec4.1736488799.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iSHVvcceR3p0e8MdhT0PF8u6p_9ICL7hykjVAzXCrcE_1736867014
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 07:00, Alistair Popple wrote:
> In preparation for using insert_page() for DAX, enhance
> insert_page_into_pte_locked() to handle establishing writable
> mappings.  Recall that DAX returns VM_FAULT_NOPAGE after installing a
> PTE which bypasses the typical set_pte_range() in finish_fault.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> 
> ---
> 
> Changes for v5:
>   - Minor comment/formatting fixes suggested by David Hildenbrand
> 
> Changes since v2:
> 
>   - New patch split out from "mm/memory: Add dax_insert_pfn"
> ---
>   mm/memory.c | 37 +++++++++++++++++++++++++++++--------
>   1 file changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 06bb29e..8531acb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2126,19 +2126,40 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
>   }
>   
>   static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
> -			unsigned long addr, struct page *page, pgprot_t prot)
> +				unsigned long addr, struct page *page,
> +				pgprot_t prot, bool mkwrite)
>   {
>   	struct folio *folio = page_folio(page);
> +	pte_t entry = ptep_get(pte);
>   	pte_t pteval;
 >

Just drop "entry" and reuse "pteval"; even saves you from one bug below :)

pte_t pteval = ptep_get(pte);

> -	if (!pte_none(ptep_get(pte)))
> -		return -EBUSY;
> +	if (!pte_none(entry)) {
> +		if (!mkwrite)
> +			return -EBUSY;
> +
> +		/* see insert_pfn(). */
> +		if (pte_pfn(entry) != page_to_pfn(page)) {
> +			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
> +			return -EFAULT;
> +		}
> +		entry = maybe_mkwrite(entry, vma);
> +		entry = pte_mkyoung(entry);
> +		if (ptep_set_access_flags(vma, addr, pte, entry, 1))
> +			update_mmu_cache(vma, addr, pte);
> +		return 0;
> +	}
> +
>   	/* Ok, finally just insert the thing.. */
>   	pteval = mk_pte(page, prot);
>   	if (unlikely(is_zero_folio(folio))) {
>   		pteval = pte_mkspecial(pteval);
>   	} else {
>   		folio_get(folio);
> +		entry = mk_pte(page, prot);

we already do "pteval = mk_pte(page, prot);" above?

And I think your change here does not do what you want, because you
modify the new "entry" but we do

	set_pte_at(vma->vm_mm, addr, pte, pteval);

below ...

> +		if (mkwrite) {
> +			entry = pte_mkyoung(entry);
> +			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> +		}

So again, better just reuse pteval :)

-- 
Cheers,

David / dhildenb

