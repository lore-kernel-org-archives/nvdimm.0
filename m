Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C91D29617F
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880095; cv=none; b=IVrPDS1qd8ihwDK8J471iFDmNwQzO+xkSq0G1X4enfYhr17baRpmyzvjDSrclEuKaXs2vtL1scoeeNCr0d9krBReNs0oOPiQSesHpgkabTWPsCYy42pqN/O6xy8FOsZ3G4uzp2aw3zO+B9XMe390Yd3Ph6Rc/a5e2z4cWM82u6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880095; c=relaxed/simple;
	bh=h2pnXCiFQfh+UIMY8btFsX0vGWBH6xogfAM+U9ukJsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNha14ibKZlJ6ObHmT2QCG4rZqMQaTeKdlBW73VPxDG7SDbDKHHpJwAgAg6oe2K/AcBdWkaZLXaFXRBy5LLm+CdwjWtGTHLB74YjreLPfm9Gkh/dREB73+2uIUMWgD1ia2V3BdPuxWqStrwSzdLKHpOlwqrAFejfLjvTUKKVFXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b2duf+/o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2duf+/o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753880093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BNOLyc6SmRVRa78hSGFNA3yRycOhT7aevX9lnAuVkng=;
	b=b2duf+/ow8Bnki0BWa8hQNxbJeBAAb8bsdKgFbHC/nHDxcQTv1jMYRsvhwJvroo/ZYEd1v
	LwQw0ptT61dcFjaRu9jsnKcXKnNN4JY4gtmKIj5Zb0bWKD3c8aEk5xd7GchoiFm03it6Vo
	cOJCGUvukEPdMmChC4WLwM7Oya48j7w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-POV85JS4O6af07W9aewJtw-1; Wed, 30 Jul 2025 08:54:49 -0400
X-MC-Unique: POV85JS4O6af07W9aewJtw-1
X-Mimecast-MFC-AGG-ID: POV85JS4O6af07W9aewJtw_1753880089
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6159136f755so675564a12.0
        for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 05:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753880088; x=1754484888;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BNOLyc6SmRVRa78hSGFNA3yRycOhT7aevX9lnAuVkng=;
        b=VdKLLrT6XxAJhFEwzY2Z7rsHz9ivS38SNx+O3tNfxQXKLe3cvVke22y5jVjMEH1BOf
         8B2BYsVhS6C4RO7ZxlAcJdrBVBEaOyXQL4L+XisTRWOtBjhaFoXNYHhrmr64wT/3hDmW
         uuHFDbr2gUJ6zYtW8SItECdXY1xvBFwDaleP+QYT7rxcSWdGN9FXZqF0H5eoqggRt7j7
         HmNHU+HXlpVFpjSmob9Uz7VL7ZM7J5PBYupPMUtcPYHAS671ySS3RqavW2cGbbAKumYf
         BMqynZI1sJRu/e+Wr2Loisg2Z4t1g1F/Xp5VtOVMqe3zuXhl3wgSuHzVFIYLO8p15S+y
         2XxA==
X-Forwarded-Encrypted: i=1; AJvYcCWKlMYOqd0al5LC/om5CQ1dYxzvXok64ryQYTlq3o+NC0XCa8rcRQTha0qxbM1KejbNppmnm28=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHVBwMAU1I7A4qnCWyNa8u3SFLYkXpxFX1RuOO5nuQK2y/ayvG
	KyMPj9APeSnCYwxC7Zrjz1xeIDIhGVHRFLWHfaQeizl1xtz7/39R/2iwGqlNdslBn9C6gBkORV/
	29QOQXoA6LeLJwTzbjFSoIFhHEoLpo+DJAjgyGPsBIL2aE7cSLxaOOh0Vzg==
X-Gm-Gg: ASbGncsnWUG1jUd7S6vW/CD9JVxB3DYWhGe3aeTDnxB+6Qk1YFshUPU2iQhT1hOGrU+
	lLN8bMiZUh+g7e9jsdJF5OyzNmBOwvU70Tu63lzawZnq3/ymYiDJ6HpD/rG3iPQ58W41go8R5cP
	RQ9Pct2p6vIWCG/o/BJ5Qz+KFGPexqikDoOl7cWEVstRPYA6XHmyhn70uB7IJzvfw55yfVTh3zc
	U6gs0vOfTzZ6HGdkhyzi0Ll9bpTgOtCAzrurI1bEShvOeTAMFm8YBc+p3CPfBcoN/Iwgg9j+V6T
	w6acQYMKCsWgJRZGSwQcG7HH4xMvhjaUcO8dD0odbMQjrW6onDZXbCNZKhReig==
X-Received: by 2002:a50:cd92:0:b0:615:7e88:ef95 with SMTP id 4fb4d7f45d1cf-6157e88f679mr3494325a12.11.1753880088564;
        Wed, 30 Jul 2025 05:54:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjKq5bY0KudoprYalsB0y2Cl4cMah/r660xfqVfVg64zh4dhPtr+6C+EPKKEUf1j0BUA07jQ==
X-Received: by 2002:a50:cd92:0:b0:615:7e88:ef95 with SMTP id 4fb4d7f45d1cf-6157e88f679mr3494267a12.11.1753880088043;
        Wed, 30 Jul 2025 05:54:48 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6158b7504f3sm993939a12.27.2025.07.30.05.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 05:54:47 -0700 (PDT)
Message-ID: <ee6ff4d7-8e48-487b-9685-ce5363f6b615@redhat.com>
Date: Wed, 30 Jul 2025 14:54:46 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] mm/memory: factor out common code from
 vm_normal_page_*()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
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
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-8-david@redhat.com>
 <1aef6483-18e6-463b-a197-34dd32dd6fbd@lucifer.local>
 <50190a14-78fb-4a4a-82fa-d7b887aa4754@lucifer.local>
 <b7457b96-2b78-4202-8380-4c7cd70767b9@redhat.com>
 <eab1eb16-b99b-4d6b-9539-545d62ed1d5d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <eab1eb16-b99b-4d6b-9539-545d62ed1d5d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vpkw83EyHGXTBBDlkucWYS7xLkTUrrpzWwvPGqwNtFg_1753880089
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.07.25 14:43, Lorenzo Stoakes wrote:
> On Thu, Jul 17, 2025 at 10:03:44PM +0200, David Hildenbrand wrote:
>> On 17.07.25 21:55, Lorenzo Stoakes wrote:
>>> On Thu, Jul 17, 2025 at 08:51:51PM +0100, Lorenzo Stoakes wrote:
>>>>> @@ -721,37 +772,21 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>>>    		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
>>>>>    		return NULL;
>>>>>    	}
>>>>> -
>>>>> -	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>>>>> -		if (vma->vm_flags & VM_MIXEDMAP) {
>>>>> -			if (!pfn_valid(pfn))
>>>>> -				return NULL;
>>>>> -			goto out;
>>>>> -		} else {
>>>>> -			unsigned long off;
>>>>> -			off = (addr - vma->vm_start) >> PAGE_SHIFT;
>>>>> -			if (pfn == vma->vm_pgoff + off)
>>>>> -				return NULL;
>>>>> -			if (!is_cow_mapping(vma->vm_flags))
>>>>> -				return NULL;
>>>>> -		}
>>>>> -	}
>>>>> -
>>>>> -	if (is_huge_zero_pfn(pfn))
>>>>> -		return NULL;
>>>>> -	if (unlikely(pfn > highest_memmap_pfn)) {
>>>>> -		print_bad_page_map(vma, addr, pmd_val(pmd), NULL);
>>>>> -		return NULL;
>>>>> -	}
>>>>> -
>>>>> -	/*
>>>>> -	 * NOTE! We still have PageReserved() pages in the page tables.
>>>>> -	 * eg. VDSO mappings can cause them to exist.
>>>>> -	 */
>>>>> -out:
>>>>> -	return pfn_to_page(pfn);
>>>>> +	return vm_normal_page_pfn(vma, addr, pfn, pmd_val(pmd));
>>>>
>>>> Hmm this seems broken, because you're now making these special on arches with
>>>> pte_special() right? But then you're invoking the not-special function?
>>>>
>>>> Also for non-pte_special() arches you're kind of implying they _maybe_ could be
>>>> special.
>>>
>>> OK sorry the diff caught me out here, you explicitly handle the pmd_special()
>>> case here, duplicatively (yuck).
>>>
>>> Maybe you fix this up in a later patch :)
>>
>> I had that, but the conditions depend on the level, meaning: unnecessary
>> checks for pte/pmd/pud level.
>>
>> I had a variant where I would pass "bool special" into vm_normal_page_pfn(),
>> but I didn't like it.
>>
>> To optimize out, I would have to provide a "level" argument, and did not
>> convince myself yet that that is a good idea at this point.
> 
> Yeah fair enough. That probably isn't worth it or might end up making things
> even more ugly.

So, I decided to add the level arguments, but not use them to optimize the checks,
only to forward it to the new print_bad_pte().

So the new helper will be

/**
   * __vm_normal_page() - Get the "struct page" associated with a page table entry.
   * @vma: The VMA mapping the page table entry.
   * @addr: The address where the page table entry is mapped.
   * @pfn: The PFN stored in the page table entry.
   * @special: Whether the page table entry is marked "special".
   * @level: The page table level for error reporting purposes only.
   * @entry: The page table entry value for error reporting purposes only.
...
   */
static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
                unsigned long addr, unsigned long pfn, bool special,
                unsigned long long entry, enum pgtable_level level)
...


And vm_nomal_page() will for example be

/**
  * vm_normal_page() - Get the "struct page" associated with a PTE
  * @vma: The VMA mapping the @pte.
  * @addr: The address where the @pte is mapped.
  * @pte: The PTE.
  *
  * Get the "struct page" associated with a PTE. See __vm_normal_page()
  * for details on "normal" and "special" mappings.
  *
  * Return: Returns the "struct page" if this is a "normal" mapping. Returns
  *        NULL if this is a "special" mapping.
  */
struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
                             pte_t pte)
{
        return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
                                pte_val(pte), PGTABLE_LEVEL_PTE);
}



-- 
Cheers,

David / dhildenb

