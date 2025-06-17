Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF5F28FFFB
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 09:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750153769; cv=none; b=UC6xqKSMShoXUue5NlzkhiIDEH3HBcHYqO12oix6i0MFMkncqXFjHWJgrQ1DgiivJrwFkFFeBJ0jxEsxONjb2ZHEAcL7JGNkhsy797lKsGaKwghNOvmjUDzFY+Vg+K4f+X1ZWqAUK1izC1V8JbLsCyLfLT5zRfbgjE9ykhY5YEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750153769; c=relaxed/simple;
	bh=y9PWU5GUxhjJggeZ2t0v/qrg4XfMxZpcGntNLDW1ll0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uL7PXIs6FannzRVh3ZKN2l5KwcYDgNhVYaQ88JvjuFwLqg/unh0ikSapwMAOWq88Hg6A4SS7MqYz2bmrP1E6pyyC6yZko30qCHmxVtYIeeTxVd7R9fEtEG6wXAD5GJmPOBqijldd4FtmicYVareNRUI2FLxJfEmRRTPpiiaogt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iBErrbNK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iBErrbNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750153766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lg0mFUm80r9X0igLB1pMrSxygF5fgmEE/5oZN4jlRBc=;
	b=iBErrbNKlmtjetKK+iFsXDU57pjKmN8U3pGYIv4v288qM9jnzGlUBJj4X1I0g91iyNUjsV
	auikdCYW7W9It5DVCkwPMPKKlXy3nQusvu5Ox+M71OL+521oFtUommxGp1QlFOUlm5Lm9Z
	TZ4MXgXDAldQiIstu/jB37+vjTcprs0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-bxIfLkLMPgqNHl9JBFdCKA-1; Tue, 17 Jun 2025 05:49:24 -0400
X-MC-Unique: bxIfLkLMPgqNHl9JBFdCKA-1
X-Mimecast-MFC-AGG-ID: bxIfLkLMPgqNHl9JBFdCKA_1750153763
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450df53d461so45170755e9.1
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 02:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750153763; x=1750758563;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lg0mFUm80r9X0igLB1pMrSxygF5fgmEE/5oZN4jlRBc=;
        b=hBrbbYY5LsSiAeL7KEi/CxNmEUcE2sUCszl+SK46N7rBzhhdqMBkOdCSL+xkpJge+n
         2RGlL5ft5ewAESJNurluV2pNHXDXeUZVIQlAByGclmPK+WRenTbniohR9AsWdf2ImGl6
         9jRxlF18SZJO2fuTbEd45nhlBopU1lFvmx16RL3qnP/Hd1Rxe3tcVLNaP3mShEAsTjJH
         vQ50QW4ZEgF/EZcc+higf6anjxtGCjdjfMy03k9Pr2TSc9Sdtwaqvq4ytqA2TTDrKry1
         kLWUPQlWSY57k7Pe8cBNSEW5z6rEhs0E7YMTSh+JYMEJjdTnt5oty8XxIzGdkOpNyPbH
         afzA==
X-Forwarded-Encrypted: i=1; AJvYcCWksWXDPo/e2kaqKEcLwA3P17h+nfrqihZRyfUq8kb15lyyT1aqVsYVjnq1Bjr0FNzICsN9NxQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzj9+5FjQ8xYYlKKP/GRbkrt4ZDkHIBGa2r5E44qqOvLOqubfad
	0rUGPi79fFiLq2d/dVF3FccULZT5o60kZBMyxDffU3dixrpNUpDD/rr5PYxAJU7ocekca6p5nrY
	n3a3cdHflt5S9Tqyo5hm59W1tgmFBYRGy2fh8RpXo8woECkdMQaxs8D7ssg==
X-Gm-Gg: ASbGncsXWQnc7wt5V59tcV4M+PPulvinmd+2XMJOO03Ywjfn3Szs/u3pm0Md8nW4Hc7
	N8sGDNcTE4D8yQugwBdCy8oPP6IJFIAujBokuX1XwvZlzF6shogppX92ObasGCXyspyGR9UDF1w
	oTHat+A3UartAFeQKxveB/NsoG1Pc9qN23RKxP82+tfMMmVoKYDit+SSwkYR56LVegMcGmn9Voz
	LCbpmrfViTzz1C+h3RB6ex/FaM039bauA2eiHeeIbjoFOIvF6NCdvDahkkFBG4FpQDLpzBJU5dq
	CV3yIdYLoChezhIHTSAmSkRIMCLCloaG2ZCeaFYbYqt9xmuQ3sk5Mbctb8EPP3kfI7y2MrBkzb7
	01KbN35QVF82tjSOB0hSHQ6QPiX1Ffi17Y2CuGRzEqjtl43g=
X-Received: by 2002:a05:600c:8b66:b0:43d:1b74:e89a with SMTP id 5b1f17b1804b1-4533ca71c4cmr120176265e9.9.1750153763448;
        Tue, 17 Jun 2025 02:49:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXZNQ8PD9qufR5L3UGiEianFrRGislf+YnSmpb1KcTqInns51iN3qzkWWM7hMwKXRBlIkEGg==
X-Received: by 2002:a05:600c:8b66:b0:43d:1b74:e89a with SMTP id 5b1f17b1804b1-4533ca71c4cmr120175955e9.9.1750153763021;
        Tue, 17 Jun 2025 02:49:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a578510edcsm9430995f8f.8.2025.06.17.02.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:49:22 -0700 (PDT)
Message-ID: <6bb233ef-5e56-4546-b571-6a5f052d8b45@redhat.com>
Date: Tue, 17 Jun 2025 11:49:20 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/14] mm/huge_memory: Remove pXd_devmap usage from
 insert_pXd_pfn()
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
 m.szyprowski@samsung.com
References: <cover.8d04615eb17b9e46fc0ae7402ca54b69e04b1043.1750075065.git-series.apopple@nvidia.com>
 <67bc382c49ed8b165cfbd927886372272c35f508.1750075065.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <67bc382c49ed8b165cfbd927886372272c35f508.1750075065.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S-e4HpMPcYWe_t4T907NlrIGxJDa7TN9_SvLs0-hYwI_1750153763
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 13:58, Alistair Popple wrote:
> Nothing uses PFN_DEV anymore so no need to create devmap pXd's when
> mapping a PFN. Instead special mappings will be created which ensures
> vm_normal_page_pXd() will not return pages which don't have an
> associated page. This could change behaviour slightly on architectures
> where pXd_devmap() does not imply pXd_special() as the normal page
> checks would have fallen through to checking VM_PFNMAP/MIXEDMAP instead,
> which in theory at least could have returned a page.
> 
> However vm_normal_page_pXd() should never have been returning pages for
> pXd_devmap() entries anyway, so anything relying on that would have been
> a bug.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---
> 
> Changes since v1:
> 
>   - New for v2
> ---
>   mm/huge_memory.c | 12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b096240..6514e25 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1415,11 +1415,7 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>   		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>   	} else {
>   		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));
> -
> -		if (pfn_t_devmap(fop.pfn))
> -			entry = pmd_mkdevmap(entry);
> -		else
> -			entry = pmd_mkspecial(entry);
> +		entry = pmd_mkspecial(entry);
>   	}
>   	if (write) {
>   		entry = pmd_mkyoung(pmd_mkdirty(entry));
> @@ -1565,11 +1561,7 @@ static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
>   		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
>   	} else {
>   		entry = pud_mkhuge(pfn_t_pud(fop.pfn, prot));
> -
> -		if (pfn_t_devmap(fop.pfn))
> -			entry = pud_mkdevmap(entry);
> -		else
> -			entry = pud_mkspecial(entry);
> +		entry = pud_mkspecial(entry);
>   	}
>   	if (write) {
>   		entry = pud_mkyoung(pud_mkdirty(entry));


Why not squash this patch into #3, and remove the pmd_special() check 
from vm_normal_page_pmd() in the same go? Seems wrong to handle the 
PMD/PUD case separately.

But now I am confused why some pte_devmap() checks are removed in patch 
#3, while others are removed in #7.

Why not split it up into (a) stop setting p*_devmap() and (b) remove 
p*_devmap().

Logically makes more sense to me ... :)

-- 
Cheers,

David / dhildenb

