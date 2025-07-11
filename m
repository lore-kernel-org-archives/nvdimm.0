Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1F2ED142
	for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752247835; cv=none; b=cwHuMOkj2N5ZzNP8EJqyPAsXeXHAYAy2hbi25TA36un9qX6tkoOaxwKYTC7RsQU+9K05uR+9zounCPI75eMa3ZhBDYmT9S9GcN6gfV/WLXZvRVRBwIidTaCmecv0qMql61AOfWNi0uVDKYcjWbBYfltxeEILlQDG01EaQgdDWtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752247835; c=relaxed/simple;
	bh=LwyP5RQEZvwJGkwUiKrsVQ3Rs0j9aTdx6Qt1qMEY+ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbWGzM5qG65zIMtmFSXR+3NvqmgUyGHe22a4Z4KiWud6MMLFjLqYTuKZCXahUCqCJX67NyN1hurzQ2R29uBn93SZju5x+azacbgpOtfm2tVjEBCf9AC96ZxZ/JjNXGpkItf7JX5fF6pd6lnLfiRLOWcPNStKfV0obt55zwKDVrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HHKSa9j1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HHKSa9j1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752247831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rsik21whPZOqyHBc6OLT/nSyW/8eOcGoHSMTkTuXGd0=;
	b=HHKSa9j15623whSsi4Ma0uYvwbbhfq+/0JC4b2O+XYlzrXhWfpBVlEKUL9g53pOeUn84CW
	FM1voK2wEZnJry9OUMPBqbRAV3ssaTgnPVFcO7S9I6Ci77AHuOLc58sQqqUXfvRrhJQeIU
	pSNeoJmlCgwheX6Hus0E4hv12Errayk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-9Xmde5uNNsuY8NkhNuhWXQ-1; Fri, 11 Jul 2025 11:30:30 -0400
X-MC-Unique: 9Xmde5uNNsuY8NkhNuhWXQ-1
X-Mimecast-MFC-AGG-ID: 9Xmde5uNNsuY8NkhNuhWXQ_1752247829
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f8192e2cso1398806f8f.3
        for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 08:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752247829; x=1752852629;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rsik21whPZOqyHBc6OLT/nSyW/8eOcGoHSMTkTuXGd0=;
        b=w+mt+GW7LBbT1mlDT4AeIGO6fldRwzNyz86YMVenhMewWk6Qg5FvP+9MaJduAfK/M4
         X6h25ZBLboGYsuTcmgCzy9VOTQq28miZBC8syF4ThshVGSYWyWYTTLtWyv+1t9GYV6x2
         4w4+6bHib1XnXoyiGHpqkSckUhypCgnoXGTjKf9d9nP8J4r5eIa5c7VSWt7JvsHBBL8v
         pPqjhEeCVS27jJUO5NKVvuFrHb6SMFNLLRBEil653fpFjmc0T0pz0LuzyFh+rNIm33LW
         lSW50BDnx65pLgOVptn3eokLj8RxOm1DXeDXG0yqWnJRXnLZWE2yuDIglp6LOL2AJlZZ
         1Byw==
X-Forwarded-Encrypted: i=1; AJvYcCV0MbxJ0f0FC6ZIHsRoHq9tbGKeNxJES2Zn4wfUgQIf8Eei9DPmdqqseYDB0WLBnnu6tfCfBxc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxkUaYGObw2WcnGvRxjdNqsT5KaYNyMUG1XGpx0iNqkV4XvNvh
	HiCY8VVFcMKoTXemMAE8zYEaRD2Ea1unaBQwoxUu9bm3+UDtKGept04FUKBMuS+Rtu6GHO/pk25
	JTAXFvMSJz+zEyV3NbKu66jdIv5DNAPzkjADAXiU8MICnYqyobrvq2dYL0Q==
X-Gm-Gg: ASbGncuijnpqxhK0aZCmObZ6oosc1XUTBGStvL5BE0LqHwwWpTBFsKzWbX+AWCiea5t
	2ZAFKXNIRejpHX8/emGneLAEXsJFmtxvLS0JzBCHOgNX5GhM90j9vAW7q7976nVN1ODFM9GLmWU
	2l6G6kqz8pa2JSVRk7eRqZwf92IIOGIW+/imDuTvCoLuswZnqNLP+h+UWPeEcivr1cvuN+gLEQO
	cGfrnWIbnL/C8ouobegyPj0dwYa3A+R0LbyUiwlrANeahrghb8sb+euepODzJhvfkaOFAQiNxYb
	A4YAC5Nb+Ll7tceMqkQwY2IlE/tOuqNk47AUjTZoGU9NBUhi5JE1iTkhLjRrmL9BzdWzlPCiHmx
	04ISD8VR+Y+vxeIU7Fam96827OtbN/TFjQTu087lzysZgGVnfUkelDxeIaO31jqZZAK0=
X-Received: by 2002:a05:6000:2003:b0:3a4:fc07:f453 with SMTP id ffacd0b85a97d-3b5f2db184cmr2547822f8f.8.1752247828959;
        Fri, 11 Jul 2025 08:30:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjBwRPCaPOq1srqFxwL5schSZeTVmYXsug+wnI1Ro36cTzqPp74WyM9cOGS69i0RjHYOa7HQ==
X-Received: by 2002:a05:6000:2003:b0:3a4:fc07:f453 with SMTP id ffacd0b85a97d-3b5f2db184cmr2547716f8f.8.1752247827522;
        Fri, 11 Jul 2025 08:30:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3c:3a00:5662:26b3:3e5d:438e? (p200300d82f3c3a00566226b33e5d438e.dip0.t-ipconnect.de. [2003:d8:2f3c:3a00:5662:26b3:3e5d:438e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd18ffsm4664264f8f.9.2025.07.11.08.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 08:30:26 -0700 (PDT)
Message-ID: <056787ba-eed1-4517-89cd-20c7cc9935dc@redhat.com>
Date: Fri, 11 Jul 2025 17:30:24 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity check
 in vm_normal_page()
To: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Alistair Popple
 <apopple@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Lance Yang <ioworker0@gmail.com>
References: <20250617154345.2494405-1-david@redhat.com>
 <20250617154345.2494405-2-david@redhat.com>
 <aFVZCvOpIpBGAf9w@localhost.localdomain>
 <c88c29d2-d887-4c5a-8b4e-0cf30e71d596@redhat.com>
 <CABzRoyZtxBgJUZK4p0V1sPAqbNr=6S-aE1S68u8tKo=cZ2ELSw@mail.gmail.com>
 <5e5e8d79-61b1-465d-ab5a-4fa82d401215@redhat.com>
 <aa977869-f93f-4c2b-a189-f90e2d3bc7da@linux.dev>
 <b6d79033-b887-4ce7-b8f2-564cad7ec535@redhat.com>
 <b0984e6e-eabd-ed71-63c3-4c4d362553e8@google.com>
 <36dd6b12-f683-48a2-8b9c-c8cd0949dfdc@redhat.com>
 <0b1cb496-4e50-252e-5bcf-74a89a78a8c0@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <0b1cb496-4e50-252e-5bcf-74a89a78a8c0@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SCUYlk1Kx61aBl7S9DN15oN604X07npJ84ZQ1OkeN2w_1752247829
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08.07.25 04:52, Hugh Dickins wrote:
> On Mon, 7 Jul 2025, David Hildenbrand wrote:
>> On 07.07.25 08:31, Hugh Dickins wrote:
>>> On Fri, 4 Jul 2025, David Hildenbrand wrote:
>>>> On 03.07.25 16:44, Lance Yang wrote:
>>>>> On 2025/7/3 20:39, David Hildenbrand wrote:
>>>>>> On 03.07.25 14:34, Lance Yang wrote:
>>>>>>> On Mon, Jun 23, 2025 at 10:04 PM David Hildenbrand <david@redhat.com>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>> On 20.06.25 14:50, Oscar Salvador wrote:
>>>>>>>>> On Tue, Jun 17, 2025 at 05:43:32PM +0200, David Hildenbrand wrote:
>>>>>>>>>> In 2009, we converted a VM_BUG_ON(!pfn_valid(pfn)) to the current
>>>>>>>>>> highest_memmap_pfn sanity check in commit 22b31eec63e5 ("badpage:
>>>>>>>>>> vm_normal_page use print_bad_pte"), because highest_memmap_pfn was
>>>>>>>>>> readily available.
> 
> highest_memmap_pfn was introduced by that commit for this purpose.
> 

Oh, somehow I thought it was around before that.

[...]

>> We catch corruption in a handful of PTE bits, and that's about it. You neither
>> detect corruption of flags nor of PFN bits that result in another valid PFN.
> 
> Of course it's limited in what it can catch (and won't even get called
> if the present bit was not set - a more complete patch might unify with
> those various "Bad swap" messages). Of course. But it's still useful for
> stopping pfn_to_page() veering off the end of the memmap[] (in some configs).

Right, probably in the configs we both don't care that much about 
nowadays :)

> And it's still useful for printing out a series of "Bad page map" messages
> when the page table is corrupted: from which a picture can sometimes be
> built up (isolated instance may just be a bitflip; series of them can
> sometimes show e.g. ascii text, occasionally helpful for debugging).

It's kind of a weird thing, because we do something very different 
opposed to other areas where we detect that something serious is going 
wrong (e.g., WARN).

But another thread just sparked whether we should WARN here, so I'll 
leave that discussion to the other thread.

> 
>>
>> Corruption of the "special" bit might be fun.
>>
>> When I was able to trigger this during development once, the whole machine
>> went down shortly after -- mostly because of use-after-free of something that
>> is now a page table, which is just bad for both users of such a page!
>>
>> E.g., quit that process and we will happily clear the PTE, corrupting data of
>> the other user. Fun.
>>
>> I'm sure I could find a way to unify the code while printing some comparable
>> message, but this check as it stands is just not worth it IMHO: trying to
>> handle something gracefully that shouldn't happen, when really we cannot
>> handle it gracefully.
> 
> So, you have experience of a time when it didn't help you. Okay. And we
> have had experience of other times when it has helped, if only a little.
> Like with other "Bad page"s: sometimes helpful, often not; but tending to
> build up a big picture from repeated occurrences.

Okay. I was rather curious how often we would actually hit this one 
here: from my recollection, the mapcount underflows are much more 
frequent than the ones from vm_normal_page().

> 
> We continue to disagree. I can't argue more than append the 2.6.29
> commit message, which seems to me as valid now as it was then.

Not that I agree that performing these sanity checks in each and every 
config is something reasonable, but apparently you think that they are 
still useful, 16 years after they were introduced.

So, let me try finding a way to unify the code while keeping that error 
handling for now in place.

-- 
Cheers,

David / dhildenb

