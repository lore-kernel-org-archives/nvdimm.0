Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F141E51EF
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751894385; cv=none; b=haJWs4N5UgteXpsLCdBUpUhe1tnbqOv0Nxz9cugSzxR4SdwJ5C63rvrxJ2i1v+OD02NKwA6tccH0PzFKtlbJf/jq4wvmg+lyuYKFCqyhac3WI2IB8vqkFxEdDbdSf2yobyWIMiwML7eA7x9YY14hzTb2k8aevKKbsObUaQNPyk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751894385; c=relaxed/simple;
	bh=rtct0nDU+j5TyrJZ+m4PVNBMC7iyuPfgezwKp+Qwn8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HKEGRlxHlBMkqjnP+QtuDrZsp66Y8p+IPYIMSRQKk9JLX6J3HP0wbJVNvFxe3lJDNwR3w4Yzr3drHIU7Nzl7ReouwfmnCF/nEHhExrXjAmU2OwybHd4JW4m3LBewE/eBgmDJ3OVLdbMRxrtxucpsID/rMMWJWJVtTW0ynaDpZCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfdNoCgb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfdNoCgb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751894382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nXmXDjuLCVo5wU4ylvvDNkZan/QGMn2o2rEiwIbCGFU=;
	b=IfdNoCgb85epdZI7jINw3ORUby7uqUneZ90mHgDt6FPba6bszyfGFVYjjXvP+ASopX2wnu
	PS39C4CgJ1bnNE2PGGOcjKuGGzHFGodU1gvRqXoQPJjMqRbIzZCBYVZmProevOzT770Nvg
	2ZadXx/IXqTBzmipVQg9yXzLGxiEs5Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-wB9SO7VVM3yuBp-GW2JE6Q-1; Mon, 07 Jul 2025 09:19:41 -0400
X-MC-Unique: wB9SO7VVM3yuBp-GW2JE6Q-1
X-Mimecast-MFC-AGG-ID: wB9SO7VVM3yuBp-GW2JE6Q_1751894380
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45359bfe631so16116505e9.0
        for <nvdimm@lists.linux.dev>; Mon, 07 Jul 2025 06:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751894380; x=1752499180;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nXmXDjuLCVo5wU4ylvvDNkZan/QGMn2o2rEiwIbCGFU=;
        b=gDH8qbepyDGbhuGefoDMvajSdG6OrGdvYPDqKbvputP+nz9MdzRoguRVwV3oilyBY8
         uq7z5FUgfACNR8mrZxfgoXDhIiEzdaYefhxpZ+7RMxg2FCAxhI+TCdELq1Pfp+BhsEHE
         4XbbnZC5pRS8rdt8ABRGfaiYd6kRd2bWyPn0hMpC4t0VzvJBro1etNBnTFKCpZxI42n4
         yOZwZnbOmWNRRtMLY2Dn8pQE3/s4DD6ERXgDC0KqkrITw4I58FuXMl/6lQJN+W0xMK9p
         E3hrAuta4ye+9U9tnHO7cfWouMG6FgOXJgQTjv07RctZrM1u647FIh+fcHgsKmlGzVvR
         5R+g==
X-Forwarded-Encrypted: i=1; AJvYcCXEtNEElHQ0Gatb2D7zOtmtg2ifBnVjXGtv/gSeXAifP2lqQsA4q2ZOE5LsaXVYZBBe+ERwefI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8QKLxrDRsbOVAUsEYeeF6OqYUiEID6ZIC8oQIp4DH0dI2SH9u
	0xwmxvozsfYoDCJbbRXlVy/g/Dezlc8y0Lhu1Toz/nOJJLOnHCw8I2eJCuzMYVvRlhHIo+ns1t/
	HJYp/8BXdABZtAJtLapBkGPSkGU4M2+G54ZRi7R8BdpZmr4q6LSU+m6yP+g==
X-Gm-Gg: ASbGncvHxAVfLlHfg/xyK7e9BKUqEiFSQiSVec5lrUpkiwWyHwHAaA35b3CAD7mLgga
	rKOD5P1vH2/j6KjRN74lBKr/Pb7GRzZwUWla54vG7tdI2AUgKHze7LHteZywy5XdkdqJ5wL05/b
	Ak/dmeP+AHhZbUXxdyNe/5EW4VvdHl/UcpO/lSCNsJ38ZDJEYSRrD335cq2oGY9KsHqWKyrUzwf
	P3rXaNXA/+Qf/CoW4V3amCtyjeEa48wlTbPfCgTeml9HwRc1bDynAAJM+IytSfzk7YwzeJCJqs+
	IvinjTQv+cu0dDn1E8UrCw8crDU9Mbn9pqs/voXU/3DTzHnW852SmZZGh+xIEh7d+m72DW6WS7P
	l4Mv4h/JmCJ2qe1L2MQo/4eR8WOWGhk3S+JiLqv4LoA3uR/Me/g==
X-Received: by 2002:a05:600c:3e86:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-454c476aea4mr40553195e9.7.1751894380096;
        Mon, 07 Jul 2025 06:19:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBfyFuBcaLgbZfGzjnsuMh9lvvAvuC5DlcIKIEAKGMTIqV5yEm9tkEm1VZ5eMoCw4nja+MJw==
X-Received: by 2002:a05:600c:3e86:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-454c476aea4mr40552695e9.7.1751894379602;
        Mon, 07 Jul 2025 06:19:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f38:1d00:657c:2aac:ecf5:5df8? (p200300d82f381d00657c2aacecf55df8.dip0.t-ipconnect.de. [2003:d8:2f38:1d00:657c:2aac:ecf5:5df8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9beb22asm141802825e9.36.2025.07.07.06.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jul 2025 06:19:39 -0700 (PDT)
Message-ID: <36dd6b12-f683-48a2-8b9c-c8cd0949dfdc@redhat.com>
Date: Mon, 7 Jul 2025 15:19:37 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <b0984e6e-eabd-ed71-63c3-4c4d362553e8@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FMfbLCuoxC9ZBuQirUBaVr2NnvBl0_r1vlPzJaPb6kw_1751894380
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 07.07.25 08:31, Hugh Dickins wrote:
> On Fri, 4 Jul 2025, David Hildenbrand wrote:
>> On 03.07.25 16:44, Lance Yang wrote:
>>> On 2025/7/3 20:39, David Hildenbrand wrote:
>>>> On 03.07.25 14:34, Lance Yang wrote:
>>>>> On Mon, Jun 23, 2025 at 10:04 PM David Hildenbrand <david@redhat.com>
>>>>> wrote:
>>>>>>
>>>>>> On 20.06.25 14:50, Oscar Salvador wrote:
>>>>>>> On Tue, Jun 17, 2025 at 05:43:32PM +0200, David Hildenbrand wrote:
>>>>>>>> In 2009, we converted a VM_BUG_ON(!pfn_valid(pfn)) to the current
>>>>>>>> highest_memmap_pfn sanity check in commit 22b31eec63e5 ("badpage:
>>>>>>>> vm_normal_page use print_bad_pte"), because highest_memmap_pfn was
>>>>>>>> readily available.
>>>>>>>>
>>>>>>>> Nowadays, this is the last remaining highest_memmap_pfn user, and this
>>>>>>>> sanity check is not really triggering ... frequently.
>>>>>>>>
>>>>>>>> Let's convert it to VM_WARN_ON_ONCE(!pfn_valid(pfn)), so we can
>>>>>>>> simplify and get rid of highest_memmap_pfn. Checking for
>>>>>>>> pfn_to_online_page() might be even better, but it would not handle
>>>>>>>> ZONE_DEVICE properly.
>>>>>>>>
>>>>>>>> Do the same in vm_normal_page_pmd(), where we don't even report a
>>>>>>>> problem at all ...
>>>>>>>>
>>>>>>>> What might be better in the future is having a runtime option like
>>>>>>>> page-table-check to enable such checks dynamically on-demand.
>>>>>>>> Something
>>>>>>>> for the future.
>>>>>>>>
>>>>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> The author of 22b31eec63e5 thinks this is not at all an improvement.
> Of course the condition is not triggering frequently, of course it
> should not happen: but it does happen, and it still seems worthwhile
> to catch it in production with a "Bad page map" than to let it run on
> to whatever kind of crash it hits instead.

Well, obviously I don't agree and was waiting for having this discussion :)

We catch corruption in a handful of PTE bits, and that's about it. You 
neither detect corruption of flags nor of PFN bits that result in 
another valid PFN.

Corruption of the "special" bit might be fun.

When I was able to trigger this during development once, the whole 
machine went down shortly after -- mostly because of use-after-free of 
something that is now a page table, which is just bad for both users of 
such a page!

E.g., quit that process and we will happily clear the PTE, corrupting 
data of the other user. Fun.

I'm sure I could find a way to unify the code while printing some 
comparable message, but this check as it stands is just not worth it 
IMHO: trying to handle something gracefully that shouldn't happen, when 
really we cannot handle it gracefully.

-- 
Cheers,

David / dhildenb

