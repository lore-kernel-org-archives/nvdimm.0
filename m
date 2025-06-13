Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B4E1FE477
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749830778; cv=none; b=ngCsMYePpdCYbFXoHnetseuzWqWESTtpOqwthidX8f0LDrDhO/ZCGAw60B51IVsP1TCNbWWvuvKEWbH318OVvNqG5bufyCBfatwtRmQhFgXRx2A8RUHI6vqDIkHDeG3VumxPlWwGWf6Ao0lA9B/TYBkstLSR/gEpvqou7dLnpCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749830778; c=relaxed/simple;
	bh=mWQ4k6zmVSdHGYS5h1mw8uGV3kLo/0jKlYkTPNaXty8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZRfi6cmbTS1hJ/uwbL+14DaptS4nBZElZbV4e1jFeE3mu7Wz1LWKIWQkq8ihHylP5gZ7En07If8QMmtaKnEaafGBkLlQSMHjgAVHqcxpumiAH1/7827W+o9x9Xaow1WkSiqXEXUoTFEzXXVxzen2j9ZjupEVrJDDnHCMqIzL6Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=in3ln5LO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="in3ln5LO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749830774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5N8ym7BOqBZIrhAbASMNB8gRxjZ3JD2Kuq7uCLK3/1Y=;
	b=in3ln5LOSy/P7FpE2+FaZT9pF33OCo0E97GbEiYogwWbmFW9hZrDDDmQaPehTlIOPtMRB9
	iA+ne5WX5cBBCUvsQuBM8X3tJtQ23qtLojBddZbqduWdYFUC5Xe4tPmDFPx9c8L9zOCN30
	MJ8hhUC9chBF1ijowsKef358XQ1zfOE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-hBWGOALKPsCMz1Ve0TaYyA-1; Fri, 13 Jun 2025 12:06:11 -0400
X-MC-Unique: hBWGOALKPsCMz1Ve0TaYyA-1
X-Mimecast-MFC-AGG-ID: hBWGOALKPsCMz1Ve0TaYyA_1749830770
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f8fd1856so1300482f8f.2
        for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 09:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749830770; x=1750435570;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5N8ym7BOqBZIrhAbASMNB8gRxjZ3JD2Kuq7uCLK3/1Y=;
        b=VvgZbbnjGjqoaYAG9TDX39Swd73kIAhUBwVGBvwyZIy4/ecfPlnjQrmwp5/nphGlWC
         Itk63BU3a2fpntPD18gRFA4zSNRLECNH4GoXguF28as2n1o4ywI3497JZSI0u6bZBRkT
         4pI0BqT8kbln3WitT2M2fqEZb1QI5hcjEzlf9MbkkxkBZEVFA3sCvjrfu/JxgISs7Uj3
         QiAPfIl04nDunGHAqBfg82d1w/VmdH+IrB13wexhGOzZshTrvlXJPaj1GB5z04ZAQF9U
         KT31mcyZPD+Ummg4oQ4YQhJ/6UVJlH9U15CCAcuRqjlovnZ+aMPXYs/ju/jEhQsBhANe
         sUVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeHV/LjVsY+tvYrTk1nwJUIKxHUHyJM/WjqacmxNDciTyquHiyO9kceze1VfW+ov5F3ov3z2Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsFp46RglFgfxtDjwJEb2Kww7Stfr/WmieDQ1RzU8EnmCi09Zs
	unSdaovS4JhUTxMRozczdQTeV6YHXronilyGm+SzhHiYdvSo1BIVbBZ1rfmeNf75OQ2vxm7fszk
	IZ+I8i2IiVRuxe/zuIMTmjPS1HwGxRMmHLrWgxcdDG7s153SQijEcJ1hHUw==
X-Gm-Gg: ASbGncsoQg96ASzB0CzEJFkzQ52/fLpg9g1muss9jl4QslRQ7qI/7nciSF8ZQINpBLO
	RkpoZsFTGERlxaSZMDXp7Oc0eO5VCAo45iamhQYIIiajZbBn2/MPFi57shi9zldOXbSb6IuFjeE
	3x7wG+4V7jFfho/TJJNSC11PDOGE+Mv//mEu5maYyuFouzIJQHBgz+5pEebNrL2SL2RfK3l7YT8
	jtKeKaoLNDn0eJoorXht3CMCHjCnKQoTsgXJF3gG1gyvzFMSZGbAVfDly8bXLXbx90/zZxLzxs/
	EQFCVmq7jI5jc9b6J2sKndbQVMfeWbLWU00MpWgPG+TqXi/uECYB
X-Received: by 2002:a05:6000:2010:b0:3a4:f70d:8673 with SMTP id ffacd0b85a97d-3a57237dc6cmr359529f8f.25.1749830770229;
        Fri, 13 Jun 2025 09:06:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfYXkzkQkAcTvSULfyfCbASOU+hWVQdvFvTPfVCMVGu/s4JrzJeqV9M6p3tgK1zfO5d52NZg==
X-Received: by 2002:a05:6000:2010:b0:3a4:f70d:8673 with SMTP id ffacd0b85a97d-3a57237dc6cmr359461f8f.25.1749830769654;
        Fri, 13 Jun 2025 09:06:09 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a50c.dip0.t-ipconnect.de. [87.161.165.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a54d7fsm2807541f8f.18.2025.06.13.09.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 09:06:08 -0700 (PDT)
Message-ID: <85b998c1-b9b7-4a8f-b2f0-f5c6d4ada9c8@redhat.com>
Date: Fri, 13 Jun 2025 18:06:07 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20250613092702.1943533-1-david@redhat.com>
 <20250613092702.1943533-3-david@redhat.com>
 <aEwseqmFrpNO5NJC@localhost.localdomain>
 <4acaa46f-f856-4116-917e-08e7c1f3156a@redhat.com>
 <fec14df9-da28-4717-8e4c-e5997a4c32cb@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <fec14df9-da28-4717-8e4c-e5997a4c32cb@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4jatqmnWGKf4Iyi4j2tSK_GGxTbcOdiFWBSm9dWi-Kk_1749830770
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.06.25 16:00, Lorenzo Stoakes wrote:
> On Fri, Jun 13, 2025 at 03:53:58PM +0200, David Hildenbrand wrote:
>> On 13.06.25 15:49, Oscar Salvador wrote:
>>> On Fri, Jun 13, 2025 at 11:27:01AM +0200, David Hildenbrand wrote:
>>>> Marking PMDs that map a "normal" refcounted folios as special is
>>>> against our rules documented for vm_normal_page(): normal (refcounted)
>>>> folios shall never have the page table mapping marked as special.
>>>>
>>>> Fortunately, there are not that many pmd_special() check that can be
>>>> mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
>>>> would get this wrong right now are rather harmless: e.g., none so far
>>>> bases decisions whether to grab a folio reference on that decision.
>>>>
>>>> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
>>>> implications as it seems.
>>>>
>>>> Getting this right will get more important as we use
>>>> folio_normal_page_pmd() in more places.
>>>>
>>>> Fix it by teaching insert_pfn_pmd() to properly handle folios and
>>>> pfns -- moving refcount/mapcount/etc handling in there, renaming it to
>>>> insert_pmd(), and distinguishing between both cases using a new simple
>>>> "struct folio_or_pfn" structure.
>>>>
>>>> Use folio_mk_pmd() to create a pmd for a folio cleanly.
>>>>
>>>> Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>>>> Tested-by: Dan Williams <dan.j.williams@intel.com>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>
>>> Altough we have it quite well explained here in the changelog, maybe
>>> having a little comment in insert_pmd() noting why pmds mapping normal
>>> folios cannot be marked special would be nice.
>>
>> Well, I don't think we should be replicating that all over the place. The
>> big comment above vm_normal_page() is currently our source of truth (which I
>> will teak soon further).
> 
> Suggestion:
> 
> "Kinda self-explanatory (special means don't touch) unless you use museum piece
> hardware OR IF YOU ARE XEN!"
> 
> ;)

I looked into the XEN stuff and it is *extremely* nasty.

No, it doesn't do a pte_mkspecial(). It updates the PTE using ...

	!!! A HYPERCALL !!!

WTF, why did we ever allow that.

It's documented to require GUP to work because ... QEMU AIO. Otherwise 
we could easily convert it to a proper PFNMAP.

-- 
Cheers,

David / dhildenb

