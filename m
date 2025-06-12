Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A7F142E73
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 07:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749711974; cv=none; b=eJ0KCrQTVMDB70prdNGdg/wAyVuq7XbhqAhuTfQ3lqZYbUubUlIVw9Q9Q16fUo7N3IaUfJIx6TYElFTbnU5NFFvBG7c366PisNR8urJzTmm/3WfPkyKqt9lz/zO5IC6pcgDxFR1iJ3grP1wpxh1NnZN7xxnOu10/F70/i4JW8Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749711974; c=relaxed/simple;
	bh=f8prUh6/atF+n9TdAF4v1+dLavgeVHSI2BDX3mFj3lc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rzj4Y8nqphyR2wFJPYsEYAJzy9g8okDTgJKNWMtVEhDxjwEo0xlqwCJmWbXGMX9pwEwuSDyo8V5aJvdz0mMtqYR8xYK+zB1LqHu11hxxjHzIKIsi9j9/zr6c2eXKZTfEl6iWRq9VTV4P35XVZEUeB4ID5xvBLmmU6M/LHNcBLEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M4MODApM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M4MODApM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749711970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bgI7EwmjXl77aJdJaolj+NbSd9BnE0i2KDqrsSDfOf8=;
	b=M4MODApMADTbtWqVE2IOdAHB67Xzrbc6xD0HUW8EAC6HTcx6x+iLzxCOneFmxj5SHg/WbP
	ZlyaeFdgZJK6AW3drPiy1GFUl8dI17Pa79Dn5Di7S8IjoMKixIfjf5K79o/4UDPPOODJIY
	09Mx5FYf82FVZiWCoqxAl58ieEawGDo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-RS6TDT3oPmGKpFZ8TZ8NsA-1; Thu, 12 Jun 2025 03:06:08 -0400
X-MC-Unique: RS6TDT3oPmGKpFZ8TZ8NsA-1
X-Mimecast-MFC-AGG-ID: RS6TDT3oPmGKpFZ8TZ8NsA_1749711967
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso3153415e9.0
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 00:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749711967; x=1750316767;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bgI7EwmjXl77aJdJaolj+NbSd9BnE0i2KDqrsSDfOf8=;
        b=lOReCwHPszp4Zk4ohAC2+nlV5r2Yt0R5gzX9rwT7fOEzwKGAXazzmuEFB0UB/1jJZ2
         mQ/jlAbfigMDi5MvfayAwDE4SyuocYVO7WrsvFfX2U0pqBh4t+igF/r+RfWUZR9Cnxni
         k7WTMR+dhHqmF1OCrkRgccE3Fypc6QHsZcMZbr2p7zPnrRO1knaq5lpsl0D1zeCtfxqu
         hxOzuUmi4I7dfl+1UIfahvc2edtTnP93KKQSv/o2dz8S4Q2Q/C7EenYyRY+NVodK2qIH
         yDAWnaEbLC87OVYXGdEve14BMKE3lswiPO7lzf4uL1FyoRIOpDDqSr4J9nHZADV6DUiv
         EQ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9LPKO1yJ4ilpdF4QRbiy3GrqC1EHPBve4jKlOVj4RwYJ1vvkpAe939wr/qJOBo8SNh46YMMU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrDjS+dV3LeZ6DOgX774gHd/0kaHiIpzLb7MTzJYpCD3YytAQo
	p7jrEwoVYSbpCa5PE1LmK1GlPcB/uyn6rnmXZ4hc2sgdeBuzX0LB+7wtgY3/N7dWA5li4BlCkvN
	nnqnSKLPcU6Y1XRylW4Nm5HnX5UPfChEPfPktXL6KeBD7rfR0voVYlTBEhw==
X-Gm-Gg: ASbGncsR6oMIiWgfUTnWOfLOc/GJgxc+wRyLPRv5JZsW097RQGm5IpWJp7ZCcigHD9S
	d0tRwwcKvmSFYj2EWDvCEnmwokS3GVa5R6mfsgADLGYWSvc+H0mrDqW8C4p9TlzwQDcjYHa3f6v
	sDLAUDDyVKrqbMHv0UVboyHxLD7jW/0oFAhaW2eaguKjzpkjkQsbzYVtTxVYSAG4FGXMhb9aXY5
	Mn4L0TIJGlQBsHHQy9ldsnUGGcnAIYKwpxIidy88Ik2jL0dcyuISnsX3HI12yXM6px26t2o7RMB
	Q2iMpmWI5KwoOLb5sWr+lEZFYBjPD80STlwFfKaBV+WrwONoDUSla9j0XZZAV4ItTRPmzANJfXU
	lvAioKqIDJT5XWMKAerkfGW8cWpAyjXkP/mQhN6sg+NsdTVFt2Q==
X-Received: by 2002:a05:600c:6092:b0:43e:afca:808f with SMTP id 5b1f17b1804b1-4532d328cd4mr17301925e9.31.1749711967390;
        Thu, 12 Jun 2025 00:06:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7ktzxGj9rxgF3e5K2QU/ZuZlrNO09W01BkOtOhNwjn+efDP3YWSRr1Sn0SDBCN08gcUuT0g==
X-Received: by 2002:a05:600c:6092:b0:43e:afca:808f with SMTP id 5b1f17b1804b1-4532d328cd4mr17301565e9.31.1749711966971;
        Thu, 12 Jun 2025 00:06:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:1e00:1e1e:7a32:e798:6457? (p200300d82f2c1e001e1e7a32e7986457.dip0.t-ipconnect.de. [2003:d8:2f2c:1e00:1e1e:7a32:e798:6457])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e24420csm10772795e9.20.2025.06.12.00.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 00:06:05 -0700 (PDT)
Message-ID: <0302ec30-856d-4e4b-be7b-1105966733e8@redhat.com>
Date: Thu, 12 Jun 2025 09:06:04 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Oscar Salvador <osalvador@suse.de>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-3-david@redhat.com>
 <xdkrref3md2rfc3sou6lta2vcevz6e4ckjd6q67znpipkvxbmw@gftpxkrtlqnx>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <xdkrref3md2rfc3sou6lta2vcevz6e4ckjd6q67znpipkvxbmw@gftpxkrtlqnx>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PJnYdK04OTJ39J7Lw3X0uTuRaHKBXOJDcuXzv898AN8_1749711967
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.06.25 04:17, Alistair Popple wrote:
> On Wed, Jun 11, 2025 at 02:06:53PM +0200, David Hildenbrand wrote:
>> Marking PMDs that map a "normal" refcounted folios as special is
>> against our rules documented for vm_normal_page().
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
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++++----------------
>>   1 file changed, 39 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 49b98082c5401..7e3e9028873e5 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1372,9 +1372,17 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>   	return __do_huge_pmd_anonymous_page(vmf);
>>   }
>>   
>> -static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>> -		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
>> -		pgtable_t pgtable)
>> +struct folio_or_pfn {
>> +	union {
>> +		struct folio *folio;
>> +		pfn_t pfn;
>> +	};
>> +	bool is_folio;
>> +};
> 
> I know it's simple, but I'm still not a fan particularly as these types of
> patterns tend to proliferate once introduced. See below for a suggestion.

It's much better than abusing pfn_t for folios -- and I don't 
particularly see a problem with this pattern here as long as it stays in 
this file.

> 
>> +static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>> +		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
>> +		bool write, pgtable_t pgtable)
>>   {
>>   	struct mm_struct *mm = vma->vm_mm;
>>   	pmd_t entry;
>> @@ -1382,8 +1390,11 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>>   	lockdep_assert_held(pmd_lockptr(mm, pmd));
>>   
>>   	if (!pmd_none(*pmd)) {
>> +		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>> +					  pfn_t_to_pfn(fop.pfn);
>> +
>>   		if (write) {
>> -			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
>> +			if (pmd_pfn(*pmd) != pfn) {
>>   				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
>>   				return -EEXIST;
>>   			}
>> @@ -1396,11 +1407,19 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>>   		return -EEXIST;
>>   	}
>>   
>> -	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
>> -	if (pfn_t_devmap(pfn))
>> -		entry = pmd_mkdevmap(entry);
>> -	else
>> -		entry = pmd_mkspecial(entry);
>> +	if (fop.is_folio) {
>> +		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
>> +
>> +		folio_get(fop.folio);
>> +		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
>> +		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>> +	} else {
>> +		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));
>> +		if (pfn_t_devmap(fop.pfn))
>> +			entry = pmd_mkdevmap(entry);
>> +		else
>> +			entry = pmd_mkspecial(entry);
>> +	}
> 
> Could we change insert_pfn_pmd() to insert_pmd_entry() and have callers call
> something like pfn_to_pmd_entry() or folio_to_pmd_entry() to create the pmd_t
> entry as appropriate, which is then passed to insert_pmd_entry() to do the bits
> common to both?

Yeah, I had that idea as well but discarded it, because the 
refcounting+mapcounting handling is better placed where we are actually 
inserting the pmd (not possibly only upgrading permissions of an 
existing mapping). Avoid 4-line comments as the one we are removing in 
patch #3 ...

-- 
Cheers,

David / dhildenb

