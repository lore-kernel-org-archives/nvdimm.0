Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF691C3306
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822847; cv=none; b=fESxI5uPwKzpvtVbDxSblUskJhIb+b2TJHHw4SnGdnGY140EeJh7kPvu1bOCOWbol2dIM/3KDUuvsvVRUTt2RB2F7hcg1PppaAbyJku3bSsiEm3jJW5g02x0Lunq4DmDYQC0xyw0S41fKppWRe2gOmShlZnXBJe24brQFDLZErs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822847; c=relaxed/simple;
	bh=ORYavnhAPu0E8N1JgBTyHx4ZyOnhxOZgHMZuYqgAjk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cbb+EA12O1SrN+lWjLeMsWNPP8VY4L+fxFHuEuzaLXSf8GktXHldQk5FE83rfk+PklL/dIeAfBZYB97pNrS1dGBpsJJmpMeYpuowGfb30OBtLxam0Fmpr2v4ThEsfz/zk/b8nKdXLsf/FJr+ylj20TEIctMiuZWRklcZ5vxLtHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A1FHkI3E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1FHkI3E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749822843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BU5JyOHWosQhM/6S0NPkSCkvdLM9aueb+w9hBh6xwnE=;
	b=A1FHkI3EJuN5fP0W6hU0kP0xbru3j4b1VBHTeeknkr+hqtZPrubfy1312hWw5/6QL0Ofnj
	1QvEt7TLn487qaOR4ADciNFQc+htLCR+TiBym791E9BedGHvHU/kEf8LLc+bjChI3CTCpy
	yLiSqxxcI6MSkccbbzxkkPTujJBtlsI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-yG2mP8vrPwu3l_b4ZAlMiQ-1; Fri, 13 Jun 2025 09:54:02 -0400
X-MC-Unique: yG2mP8vrPwu3l_b4ZAlMiQ-1
X-Mimecast-MFC-AGG-ID: yG2mP8vrPwu3l_b4ZAlMiQ_1749822841
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a5058f9ef4so693946f8f.2
        for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 06:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749822841; x=1750427641;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BU5JyOHWosQhM/6S0NPkSCkvdLM9aueb+w9hBh6xwnE=;
        b=bNVLya/Daqo+UbidtQaqS8MwBLUHgABppf6uPFf+MiLLsNFDHQ+wVsUJYFFtEXYzyT
         LG4BQjh6dsDqONlUzL9tqXOCsHA75GgbU0uZVwAflv0r2VZ0M0cav7T6Gw3g8ah7Z2lI
         ivT/5s68yVI86X484RYdJg574mkkn1Fco+FjUmocwpQP0gLwiZDcbOprFjMoisRHEcB5
         OvQyGE5GQUI582K6gPpZamWxeUZzEQXLMjQovIs4a95DTUUK0J5sZXBV2Ip6uPkIoB2L
         dOhU0Hn4X3gFWXU2yHS4E8PwpbtVLWP9ZkvX+mkw760vECtRAif0bDlVAQiwJb3KS6Tm
         traQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrPgDyB/K9WdOrfBHGR0bxT/pyb07YEO/zdYGTyB1xD4fv4DpWgGheAE0oL+Zae9h5VSJhujU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzroXqUJEnHRJhvYRk2ex9TVFqIUMXtzVkeYOyyye6T4vB4KaXu
	MohCRA4k9j/Pr0TrsUg7xkzHYXdHUHpU0f0SfAh1tXTIzwRPc/BPQWCFeb1sJKvM3+hGW8+sX2z
	HhU1WQdj9RKonRf/RJGb9QispOFkoTQJV2uBs91k0jdvBB1Rl/QkGjORSSw==
X-Gm-Gg: ASbGncuJpetteQFWH8XrwFMapBRUq3F+rVUTNG2E+Zu9mN0nNLytmNv/QqDV1mfMVHx
	ZDbhwb+JZagmOsHKYGq2bMuKHZHvtHHJ4Vwyrr5eHEXHUCqeY2RI6XRQKxzmYBR6TjVwNVzRQRB
	eqSVrh4vehZltVZuZod3vJP8QFMv7+G7METNeZn/EFdxJhvRD+EywxEdHq8JGI51YVE3nMUAAbp
	yPpG3Lr4Clnux7qU3m3IGElhjmTqOgkGNPDhRWvsW3nMqZ6rTMCLjnZzP2HjB6mT7HJBWsPtJTc
	dZmWeuLrhe9jvt1PdGtaelFeUGuQ2TAPG9jz20xQjpfeG5bpGIVg8RdCLrDT4+b5Zc25QSc4C5r
	WgLAwsRjIGFChTOONjrutLmHx29ruzUe6f9cHBmgV9/JDpwy0fw==
X-Received: by 2002:a5d:5c84:0:b0:3a4:ee40:6c85 with SMTP id ffacd0b85a97d-3a568782a9dmr2754770f8f.54.1749822840863;
        Fri, 13 Jun 2025 06:54:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IET2fbn9FBBIkd7aBt+1E8zNBbPyT+ISzzLAkF7LjOk3Wnlvm3OEjK8bvUbn25abxKjOlKU0w==
X-Received: by 2002:a5d:5c84:0:b0:3a4:ee40:6c85 with SMTP id ffacd0b85a97d-3a568782a9dmr2754728f8f.54.1749822840315;
        Fri, 13 Jun 2025 06:54:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4? (p200300d82f1a37002982b5f7a04e4cb4.dip0.t-ipconnect.de. [2003:d8:2f1a:3700:2982:b5f7:a04e:4cb4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b6debasm2463786f8f.93.2025.06.13.06.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 06:53:59 -0700 (PDT)
Message-ID: <4acaa46f-f856-4116-917e-08e7c1f3156a@redhat.com>
Date: Fri, 13 Jun 2025 15:53:58 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
To: Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aEwseqmFrpNO5NJC@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oDzDHGFcd-fRBg3GnoG7S_ypq5zLpQCKjJK5-poIgOo_1749822841
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.06.25 15:49, Oscar Salvador wrote:
> On Fri, Jun 13, 2025 at 11:27:01AM +0200, David Hildenbrand wrote:
>> Marking PMDs that map a "normal" refcounted folios as special is
>> against our rules documented for vm_normal_page(): normal (refcounted)
>> folios shall never have the page table mapping marked as special.
>>
>> Fortunately, there are not that many pmd_special() check that can be
>> mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
>> would get this wrong right now are rather harmless: e.g., none so far
>> bases decisions whether to grab a folio reference on that decision.
>>
>> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
>> implications as it seems.
>>
>> Getting this right will get more important as we use
>> folio_normal_page_pmd() in more places.
>>
>> Fix it by teaching insert_pfn_pmd() to properly handle folios and
>> pfns -- moving refcount/mapcount/etc handling in there, renaming it to
>> insert_pmd(), and distinguishing between both cases using a new simple
>> "struct folio_or_pfn" structure.
>>
>> Use folio_mk_pmd() to create a pmd for a folio cleanly.
>>
>> Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>> Tested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Altough we have it quite well explained here in the changelog, maybe
> having a little comment in insert_pmd() noting why pmds mapping normal
> folios cannot be marked special would be nice.

Well, I don't think we should be replicating that all over the place. 
The big comment above vm_normal_page() is currently our source of truth 
(which I will teak soon further).

Thanks!

-- 
Cheers,

David / dhildenb

