Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E854C85
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749750114; cv=none; b=FNL3raTHX3kDlWteq6TJKNR8Nd/RM8Q5l9RDaCbVP7uX1rfTTq5kmr42gXtc4/PmnKO0PAfp298PEYVZa3OHFJR7u2LF6xX4Z9B5PrOIeFwhsEaJhaDHux2tzXusnx1FPkj+RPQeXRA1Ya1eMmaB4YmtgADF5B3jaCmuk4g6wZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749750114; c=relaxed/simple;
	bh=B8VpAHwfvI8i7kBnmQPWL24V95l1cq9qu0i03mzZkrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RM2stS6yBGVjyoXaQFkrM/KPL+SBXnqqxHr9laZMOLIglWldoEKwKAKOWF6tS9GPkCxMG0FTejF+k6dr9Biy6hWL/2VEp9boEuHBDD7MXJi5eRGCtt/nC8rBPQLb/t5uZedEEkhxqRBxL73yD5WVYWSOTiRC2psiFpJAmX7XRwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SGGVLkK7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGGVLkK7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749750111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nd1EHOKRplIldRLyZRvXL96+1haDOUsvq+XwVjIOUoA=;
	b=SGGVLkK7yrXO0cK+tMzfMK30yg03kQ00AlVEe+CfcvAzbd079yIbJSd7v5txx5gOfY0o1u
	j64f+hYvRrE6pY2xqKzM3eQNb5nigKNFSF8jgW9tUsEG2l/Ng/DOk1xoYFFWNvGSMFMyGK
	jdJp69qzafAAUqkL6uQh6J2CPWFegjY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-6-dJLaDfNrGQibTYsTBK7w-1; Thu, 12 Jun 2025 13:41:50 -0400
X-MC-Unique: 6-dJLaDfNrGQibTYsTBK7w-1
X-Mimecast-MFC-AGG-ID: 6-dJLaDfNrGQibTYsTBK7w_1749750110
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4edf5bb4dso1021260f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 10:41:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749750109; x=1750354909;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nd1EHOKRplIldRLyZRvXL96+1haDOUsvq+XwVjIOUoA=;
        b=AuBvy+0G6dd29KrfqFHV92yhcDivIwZi0kZ4QDXtIAnLK+aFk6ZB9oLyf81zJw62DN
         sEFOBASb3teQg3larHGjIT9wP5pmugpQd9uqE8QsHx3jnV+Db1RTs9C95K1i90JMpTKp
         FEDlRRnxCj8yLdDT94PglToovQRNpLYbWRDBZCl9+yL2F9Hu98XOY54HtIXvN2aNZlq6
         4Z6np0LLGtJ5/wucGVns1+DXc0LEOKkAJQuIAZ8SNXGCFaUaOf2sn9QdOd5YSWCVgiOF
         FiOvh+0gwTQx60zLmoZXBsH2T7H1yHeQ0oPebN9b+NI0neJ5HG5F5feeNfkHdieS16t7
         DG/A==
X-Forwarded-Encrypted: i=1; AJvYcCX5Tai7a6wtujgkZtEqeAQU/UOy8XGQ0gJkKDrJu/ePItlcRuSrxu2geTasN3tIo+dWOAtINXM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoE1KLhQW27PgRQIfWRL23MVvVXORe3/QSbIncBrNVYXKhStCt
	2CJpGy9Y5ZSYjDFO4Ql4eJ+vW676CpH8FPYBqYeGlcBEla1pT13Eo/zUHAWhZ2Qj1Sbl7d6LTxl
	XgSnaBarE0ubo8a0ZMi7dv9L6NBJYrlxYM5PENcdVM/49SYf73EQUvrIYKw==
X-Gm-Gg: ASbGncuEdQc8oTsfb7+RGEzt4e9uuSaXmgoBeDFvVPpaHzm8XQjfi51LnGk8AVkqPZT
	ClAWS0oFevXqRrHksvSks8g9agb6tt+PWkhYPpiE/C0OdY+PoM7+7Ij4JSwgDvGcIunaGBdz9EH
	/SZ0ofohVdvmu4awAQhD9Jg2Qhd8q4+xL3veeabyZe5yz4hZIY8U66lNEeVbKgn6iuln5NpIDRZ
	CWlkzpdm7X0PwrTY4Ur4OH4PEM4AA3EpYLXM9fK3ZDJDmaBSIsVyjdxqXpfP0a2leBgFZ3lgUkY
	MXxGuH/3QAxB+GV9npdOul2radOdz407He8WrroW78MoChwCnCpsTsCIQbqe4ZhzqB4chrcA1io
	J/xZsyo4cm2CCWKemGUG9z1hnPOF2v/s7Ify4TcdQhc1DYRoWeA==
X-Received: by 2002:a05:6000:288b:b0:3a4:fe9d:1b10 with SMTP id ffacd0b85a97d-3a56873d3a8mr158700f8f.45.1749750109586;
        Thu, 12 Jun 2025 10:41:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfpBKp7WSfATvU5HWRVC3xGg1b8tBhRVQX2JrvbDdW+mk61yVjqSa2K+6CTbQGfcAM+wsqmg==
X-Received: by 2002:a05:6000:288b:b0:3a4:fe9d:1b10 with SMTP id ffacd0b85a97d-3a56873d3a8mr158669f8f.45.1749750109173;
        Thu, 12 Jun 2025 10:41:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:1e00:1e1e:7a32:e798:6457? (p200300d82f2c1e001e1e7a32e7986457.dip0.t-ipconnect.de. [2003:d8:2f2c:1e00:1e1e:7a32:e798:6457])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a56199aa52sm2613251f8f.36.2025.06.12.10.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 10:41:48 -0700 (PDT)
Message-ID: <a4c900e1-76ad-4d25-88c2-2c86f7ca2055@redhat.com>
Date: Thu, 12 Jun 2025 19:41:47 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pud()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Oscar Salvador <osalvador@suse.de>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-4-david@redhat.com>
 <177cb5d1-4fde-4fa0-adbc-8e295fba403b@lucifer.local>
 <11d1ff4d-3f75-42a5-968e-8f4bad84ab78@redhat.com>
 <43e2b05f-c499-48c3-b8e4-a23ef5efc818@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <43e2b05f-c499-48c3-b8e4-a23ef5efc818@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vc0p1Kb2p7TSNQyq_t7o10GPLkzTFFfjvbKsNehgugE_1749750110
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.06.25 19:08, Lorenzo Stoakes wrote:
> On Thu, Jun 12, 2025 at 07:00:01PM +0200, David Hildenbrand wrote:
>> On 12.06.25 18:49, Lorenzo Stoakes wrote:
>>> On Wed, Jun 11, 2025 at 02:06:54PM +0200, David Hildenbrand wrote:
>>>> Marking PUDs that map a "normal" refcounted folios as special is
>>>> against our rules documented for vm_normal_page().
>>>
>>> Might be worth referring to specifically which rule. I'm guessing it's the
>>> general one of special == don't touch (from vm_normal_page() comment):
>>>
>>> /*
>>>    * vm_normal_page -- This function gets the "struct page" associated with a pte.
>>>    *
>>>    * "Special" mappings do not wish to be associated with a "struct page" (either
>>>    * it doesn't exist, or it exists but they don't want to touch it). In this
>>>    * case, NULL is returned here. "Normal" mappings do have a struct page.
>>>    *
>>>    * ...
>>>    *
>>>    */
>>
>> Well, yes, the one vm_normal_page() is all about ... ? :)
> 
> Lol yes to be fair that is pretty obvious...
> 
>>
>>>
>>> But don't we already violate this E.g.:
>>>
>>> 		if (vma->vm_ops && vma->vm_ops->find_special_page)
>>> 			return vma->vm_ops->find_special_page(vma, addr);
>>>> I mean this in itself perhaps means we should update this comment to say
>> 'except
>>> when file-backed and there is a find_special_page() hook'.
>>
>> I rather hope we severely break this case such that we can remove that hack.
>>
>> Read as in: I couldn't care less about this XEN hack, in particular, not
>> documenting it.
>>
>> I was already wondering about hiding it behind a XEN config so not each and
>> every sane user of this function has to perform this crappy-hack check.
> 
> Yeah, I'm not a fan of generalised hooks if they can be avoided, especially ones
> where you pass critical data structures like VMAs.
> 
> It means you can, in theory, make no assumptions about what the caller does and
> yeah.
> 
> To do this for such a stupid edge case is ridiculous.

Also, I am not sure if this works at all as intended. I want to look 
into cleaning that up ...

When we inserted the page, we sure must have taken a reference, but when 
we inserted it we set pte_special() and ... didn't take a reference? Hmmmm

> 
>>
>> [...]
>>
>>>>    	}
>>>>
>>>> -	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
>>>> -	if (pfn_t_devmap(pfn))
>>>> -		entry = pud_mkdevmap(entry);
>>>> -	else
>>>> -		entry = pud_mkspecial(entry);
>>>> +	if (fop.is_folio) {
>>>> +		entry = folio_mk_pud(fop.folio, vma->vm_page_prot);
>>>> +
>>>> +		folio_get(fop.folio);
>>>> +		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
>>>> +		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
>>>
>>> Nit, but might be nice to abstract for PMD/PUD.
>>
>> Which part exactly? Likely a follow-up if it should be abstracted.
> 
> Ah on second thoughts it doesn't matter, because you're using pud variants of
> everything such that it wouldn't be worth it.
> 
> Disregard this ;)

Ah, I was already suspecting that you might have missed the sneaky _pud :)

-- 
Cheers,

David / dhildenb

