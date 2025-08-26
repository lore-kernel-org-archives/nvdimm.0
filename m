Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD162F5316
	for <nvdimm@lists.linux.dev>; Tue, 26 Aug 2025 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756189048; cv=none; b=UzV3u9xhXYOBA6TKq5gCrfDMdqqQUo5S4HTothaNwENMCoQKKJrFYAacIEnDmsKx3jqNFUSptMOcyDxfww4JyajBkbPjlL1yKabmBiZo2zbMSMdIFUPC5bf2q4EIzlm5Br94+xOuZG0Y0Itr0JvIxC4ex+nnfVjsEeFPkxxz7VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756189048; c=relaxed/simple;
	bh=1PbkjVHdW2fZRMcq6rjrlyuBH+np9L5OxT64eRt41gU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s86X2mMjxNWpNDabJslOCGKTq8DHCWVa3lQCTwOsI2Y/39XTAR1R1YhH70V3Dd3v3phdXvacIzbRjHcXV3wSfzcEEtFgHRi2P2za7EAiRr65fYRkjSzjsL7Z6pVP94q18jOyyZl2BJ+2MVOBT3dn5QmVNSXjgZDp0C0IiG+vPog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YCXJTE9I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YCXJTE9I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756189046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Xk7Km5HTVMpJ1b1NXcCsWrU5BXZBqRoDajCCwh1oGmE=;
	b=YCXJTE9IguviyprEcWVfvV9RqQ+14k+IZCWR5LHahR2ucAjqrH9+NPXXW06n3sKN3YIGRm
	TVfD8JQHQuPOT1uAYiHZXqtwsl2u8foIhEqWsAcR+Tpuy2sVVMZCXgknHvoiRyEHbObJ41
	Q5V9zVXMxnH7Pu8r3ZLdGvVzkcX/t/w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-mV2pHApKMZakV1BCuK6OSQ-1; Tue, 26 Aug 2025 02:17:19 -0400
X-MC-Unique: mV2pHApKMZakV1BCuK6OSQ-1
X-Mimecast-MFC-AGG-ID: mV2pHApKMZakV1BCuK6OSQ_1756189037
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0511b3so30463425e9.1
        for <nvdimm@lists.linux.dev>; Mon, 25 Aug 2025 23:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756189037; x=1756793837;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xk7Km5HTVMpJ1b1NXcCsWrU5BXZBqRoDajCCwh1oGmE=;
        b=TkBZioHfkpLVRpMlZ0WIaXTJn+1MfbV2+hQoY8ZBBeqjcfdmAxOfIGZqY7U6Ydr+JR
         wcg/fvex+qEDEpzZauStGw2Ix89kdxhPRMKmLzfloGq7Y1AEvWL/1op/0KylO1dfAPiQ
         3QgyIPWEk2j4bdhuDDrGQD/iBwN1zjyN42WlLOiXqVUm/+DnPoLK5zvVmkxko+4kMFjZ
         cyx4QQ7OIUbYI0swqj4Tri6ppoKV6MqTD2yPjI9XbB6StkNL0SNjNs9pa2GdSKqoHg9r
         tJk1WiP4MpxGHuy605RzZTpC+ilutRZq/lB5LxfMOuHdhvuH2rnXvBArhQBtjdVC3LrI
         rRYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWpo2EsiskEuZjM/hEhbF3+F7V4XnAkzXZ3jyysZmp8KgsuZyI3rX4MLyfDkxGc1GHclMedyk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwILGP4Ek3aCpfhLIL4luljhhwKUW5w7uhIdVVetTEXJOFnpZqX
	Rc21GGPmX3QUhx53q362KO35C84FhVOIuxBYmLbiAjC3O4m2Y7dA3iuh4Sw7ZIBjbXTFKQNfhhw
	9BLYmb8qoAfBU5dqPA168oRe49p3LqHj+HI542F+Ddi6nCSeF0o/XBeCkSw==
X-Gm-Gg: ASbGncvdJZontzK+VJSf1pyXwfjozFTU+Okft6wEy3QoTnAeNNZg6mZk46uSXqtt2v4
	8qJH2OeNtBWmpw0FoAyfWAWjQO/zeh77cu91elWo0BqnF4F733ig+8qGWu1ElkQKFImxTkL0Kmk
	/kPiZrxEVLzbtgYyqC8pK89PdBuDZk/YXamEU4yZB1uXgSpacjAx2NDehINROD1gnq4KZ8dB8as
	J5kktUE7XgpBKUT1YU9bD188rLGZPVdobIKYRlmOJr4wMBJy546tjOfg31dHwnFv4PrYc4dnukM
	t4BIhcM3wKr000GVs05u/PkENYjYseFp8cq3kEib9D+3Ra+ShHRlhLNhX6wnSa2feu6zuOD+Vw=
	=
X-Received: by 2002:a05:600c:3b26:b0:456:19b2:6aa8 with SMTP id 5b1f17b1804b1-45b517caa99mr120121515e9.19.1756189037407;
        Mon, 25 Aug 2025 23:17:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5JT88KMbfYqdABB2ZNx/5fJ3ePuTbJHoO0rv18+tnNMdWIHHT7WWjXjYCyLy3ILR8WgCBpw==
X-Received: by 2002:a05:600c:3b26:b0:456:19b2:6aa8 with SMTP id 5b1f17b1804b1-45b517caa99mr120121265e9.19.1756189036964;
        Mon, 25 Aug 2025 23:17:16 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6619b53asm9727285e9.1.2025.08.25.23.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 23:17:16 -0700 (PDT)
Message-ID: <f3e626ab-9bf9-4a08-b626-e739515727eb@redhat.com>
Date: Tue, 26 Aug 2025 08:17:14 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/11] mm/memory: convert print_bad_pte() to
 print_bad_page_map()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250811112631.759341-1-david@redhat.com>
 <20250811112631.759341-9-david@redhat.com>
 <923b279c-de33-44dd-a923-2959afad8626@redhat.com>
 <9ad69d4f-69b7-4998-9639-4e8f679a2d9d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <9ad69d4f-69b7-4998-9639-4e8f679a2d9d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gIZi2ZaEHJJJ6CBACABx77dKDjnyn0MbugGhcoURglw_1756189037
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.08.25 07:25, Lorenzo Stoakes wrote:
> On Mon, Aug 25, 2025 at 02:31:00PM +0200, David Hildenbrand wrote:
>> On 11.08.25 13:26, David Hildenbrand wrote:
>>> print_bad_pte() looks like something that should actually be a WARN
>>> or similar, but historically it apparently has proven to be useful to
>>> detect corruption of page tables even on production systems -- report
>>> the issue and keep the system running to make it easier to actually detect
>>> what is going wrong (e.g., multiple such messages might shed a light).
>>>
>>> As we want to unify vm_normal_page_*() handling for PTE/PMD/PUD, we'll have
>>> to take care of print_bad_pte() as well.
>>>
>>> Let's prepare for using print_bad_pte() also for non-PTEs by adjusting the
>>> implementation and renaming the function to print_bad_page_map().
>>> Provide print_bad_pte() as a simple wrapper.
>>>
>>> Document the implicit locking requirements for the page table re-walk.
>>>
>>> To make the function a bit more readable, factor out the ratelimit check
>>> into is_bad_page_map_ratelimited() and place the printing of page
>>> table content into __print_bad_page_map_pgtable(). We'll now dump
>>> information from each level in a single line, and just stop the table
>>> walk once we hit something that is not a present page table.
>>>
>>> The report will now look something like (dumping pgd to pmd values):
>>>
>>> [   77.943408] BUG: Bad page map in process XXX  pte:80000001233f5867
>>> [   77.944077] addr:00007fd84bb1c000 vm_flags:08100071 anon_vma: ...
>>> [   77.945186] pgd:10a89f067 p4d:10a89f067 pud:10e5a2067 pmd:105327067
>>>
>>> Not using pgdp_get(), because that does not work properly on some arm
>>> configs where pgd_t is an array. Note that we are dumping all levels
>>> even when levels are folded for simplicity.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>    include/linux/pgtable.h |  19 ++++++++
>>>    mm/memory.c             | 104 ++++++++++++++++++++++++++++++++--------
>>>    2 files changed, 103 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index bff5c4241bf2e..33c84b38b7ec6 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -1966,6 +1966,25 @@ enum pgtable_level {
>>>    	PGTABLE_LEVEL_PGD,
>>>    };
>>> +static inline const char *pgtable_level_to_str(enum pgtable_level level)
>>> +{
>>> +	switch (level) {
>>> +	case PGTABLE_LEVEL_PTE:
>>> +		return "pte";
>>> +	case PGTABLE_LEVEL_PMD:
>>> +		return "pmd";
>>> +	case PGTABLE_LEVEL_PUD:
>>> +		return "pud";
>>> +	case PGTABLE_LEVEL_P4D:
>>> +		return "p4d";
>>> +	case PGTABLE_LEVEL_PGD:
>>> +		return "pgd";
>>> +	default:
>>> +		VM_WARN_ON_ONCE(1);
>>> +		return "unknown";
>>> +	}
>>> +}
>>
>> One kernel config doesn't like the VM_WARN_ON_ONCE here, and I don't think we
>> really need it. @Andrew can you squash:
> 
> Out of interest do you know why this is happening? xtensa right? Does
> xtensa not like CONFIG_DEBUG_VM?

We don't happen to include mmdebug.h in a xtensa configuration.

Briefly thought about using a BUILD_BUG_ON_INVALID(), but decided to 
just drop it completely.

-- 
Cheers

David / dhildenb

