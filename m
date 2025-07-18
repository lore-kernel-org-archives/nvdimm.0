Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAAD221FD2
	for <nvdimm@lists.linux.dev>; Fri, 18 Jul 2025 08:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752827214; cv=none; b=PnDeDuI7ADck6h3OHrS99lpDAEsIzCN9BcTlxVm3tF9Iz6ua4w/AmMZzf1Nn4ggpB6n4rOaKB7O/iGpjWVYXI3z2KU3X6vxO8OgtPU4GR/cSvOtPFXWAh1/ww2MedUGBx6OP6NDnKndvK6cBKReYL7T9IwLUq1+6SvuSivL5q9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752827214; c=relaxed/simple;
	bh=EG6vCHcXTrC5kfFClUImkl1dN/zUL2RSO66sEXh4XPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J9ikJJkiyd42lOp37MPGmWUveXbgvQttgCndKqxilh0+5Fb8rfYfCn6tnMQriKGMZMXtlfCpzgiLyE6pZdmoURHRi7Tn2r5fpAl7u1jBeWe/fzsccVtgYH4jzuVjSz0YoOhIjw4liGZD6haEGVcyQwNnKCa9r4837iUwO5u6rgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JbmVmItM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JbmVmItM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752827211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fh+hMoH6LGA/IpwYhkQC4mry4srHsI8Wk6A7cPmtJNQ=;
	b=JbmVmItMBsniauVriGJxWak12wTyVuYvRToAhNxpDFm6TsKPxvUkEUClW/8B7FxLkJqqyb
	lgq65vJfWGcSgAlh3k84d8/W6wnnrgYVdCoNKeJqT7ksyCuHPvv6EChcIlaq/YQYMAnclz
	O2KqOAQlvl031IEHtJiQDdy7GGnG3Xc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-LM1LiHfGO62oxtW_FLbgfg-1; Fri, 18 Jul 2025 04:26:49 -0400
X-MC-Unique: LM1LiHfGO62oxtW_FLbgfg-1
X-Mimecast-MFC-AGG-ID: LM1LiHfGO62oxtW_FLbgfg_1752827208
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso15947345e9.0
        for <nvdimm@lists.linux.dev>; Fri, 18 Jul 2025 01:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752827208; x=1753432008;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fh+hMoH6LGA/IpwYhkQC4mry4srHsI8Wk6A7cPmtJNQ=;
        b=m4yw9b63X0dbcKC3JwqE1nRZhnfZOGQ1ouo6ac9wSwRJ9VQAkOgwcgZMcNajNq3qsH
         1cwtskXJp99PuGvU0W3iwagGhkoM6azSc5+mpM3VF2HXZHoBLiInHAhTEdbFA9RUtstr
         3WbZ9aVu5lmeJwnyHWfsQoLusvvJfveycYNuKmQ32kV4nh6n1uPKHzxXmM47yaqgXloq
         Y8guIbsYPQHPP46ao6WGH0q4VRpP464/czQdquzEyT/r5X/pj0huRSMewp+XPrdTrd6y
         OpYKZ2lfjoVOHDIkD2UR4qp5h9+368gjNNJRqfVSQyWFx8PGf8lMH3NbpZqi1UYvSOgG
         BfWA==
X-Forwarded-Encrypted: i=1; AJvYcCWxU1y5rFX6+kkW9rWe4TV58yEKQk/Pmf4dfKkCxP66NB3fw9GzJxcsg6VduSt5uczEu/snB+o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjxEAbxApXja5/VaNs5q2JyEv0R+EWA2ydBA9U02KFoREe+HuW
	HcKLm5AGNsFaqHr8gz93YrgWXw35zbWzDW6F75kje/T8K3zLAEfhRBtAeyvqpLLSx38C2q4rCdB
	3cVoPdQXp+n1ynUC3kxXpE7AObyg9Rh1qaTxwzHaNkdW5VaOxpvWNt/LKnQ==
X-Gm-Gg: ASbGncuM4JhRpLloXhBgo0E1RFi5Ya8wK+IIPJImhTX8G8Xc6DvqYUF3Ay5QMLQBAYw
	UYOKoMtZR/QnxexomfR8eeDSf3brTgA3vCpoXRixFLpEPFyP4hE1K8gyXmUb7VkEN+A5A1e+lYW
	f3Xho3/e7de/4GYmR2mz9tAnf6MoQGJCFRmzUAK544mX46vPfpx1tExp+WWjeuQEMJm9zj57NxK
	kYhT7+t9QGoJPaov1xIPRq4I99teTGy6htqMPeqRHAQR7zbNk8n560ssRdsBctFa1ouJ0yffK1g
	0vMG5eIPxghXjZoQAGjdGhe0yeaXjc+gwj6dSi5Zm+QDj18DLrZysXNOtncA4FhZrSggyijs4Ls
	TNK8Q7UWs2ulamDISj80AmYrHZwdW/VQUA+NwtJ6sKJOeBHOU0P++rvQT6UEFkkH+46M=
X-Received: by 2002:a05:600c:a089:b0:442:e9eb:cba2 with SMTP id 5b1f17b1804b1-4562dfc0150mr115638695e9.0.1752827207864;
        Fri, 18 Jul 2025 01:26:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD/3Ne58bEKVAFm6OxA4kILsajKRFE9VzvEFYW8WykrRXvnfSb8yGYzDQJezo8A49ZYr5JNw==
X-Received: by 2002:a05:600c:a089:b0:442:e9eb:cba2 with SMTP id 5b1f17b1804b1-4562dfc0150mr115638255e9.0.1752827207273;
        Fri, 18 Jul 2025 01:26:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f43:8900:f364:1333:2a67:d49e? (p200300d82f438900f36413332a67d49e.dip0.t-ipconnect.de. [2003:d8:2f43:8900:f364:1333:2a67:d49e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75de26sm12969775e9.33.2025.07.18.01.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 01:26:46 -0700 (PDT)
Message-ID: <9001b918-a08d-4b38-9737-b5d9949668be@redhat.com>
Date: Fri, 18 Jul 2025 10:26:45 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] mm/memory: convert print_bad_pte() to
 print_bad_page_map()
To: Demi Marie Obenour <demiobenour@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <20250717115212.1825089-7-david@redhat.com>
 <30268c21-a907-43d9-ac12-f6215cd95d03@gmail.com>
 <62cc8974-ddad-44a0-9f7c-e8a75a53ff99@redhat.com>
 <b5752b40-eccb-4b8c-9ac6-922e50df026c@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <b5752b40-eccb-4b8c-9ac6-922e50df026c@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q-kwafkzVHkw_TOcmIY3aljaN-D3SozvDF0RZ6-3mEQ_1752827208
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.07.25 09:59, Demi Marie Obenour wrote:
> On 7/18/25 03:44, David Hildenbrand wrote:
>> On 18.07.25 00:06, Demi Marie Obenour wrote:
>>> On 7/17/25 07:52, David Hildenbrand wrote:
>>>> print_bad_pte() looks like something that should actually be a WARN
>>>> or similar, but historically it apparently has proven to be useful to
>>>> detect corruption of page tables even on production systems -- report
>>>> the issue and keep the system running to make it easier to actually detect
>>>> what is going wrong (e.g., multiple such messages might shed a light).
>>>>
>>>> As we want to unify vm_normal_page_*() handling for PTE/PMD/PUD, we'll have
>>>> to take care of print_bad_pte() as well.
>>>>
>>>> Let's prepare for using print_bad_pte() also for non-PTEs by adjusting the
>>>> implementation and renaming the function -- we'll rename it to what
>>>> we actually print: bad (page) mappings. Maybe it should be called
>>>> "print_bad_table_entry()"? We'll just call it "print_bad_page_map()"
>>>> because the assumption is that we are dealing with some (previously)
>>>> present page table entry that got corrupted in weird ways.
>>>>
>>>> Whether it is a PTE or something else will usually become obvious from the
>>>> page table dump or from the dumped stack. If ever required in the future,
>>>> we could pass the entry level type similar to "enum rmap_level". For now,
>>>> let's keep it simple.
>>>>
>>>> To make the function a bit more readable, factor out the ratelimit check
>>>> into is_bad_page_map_ratelimited() and place the dumping of page
>>>> table content into __dump_bad_page_map_pgtable(). We'll now dump
>>>> information from each level in a single line, and just stop the table
>>>> walk once we hit something that is not a present page table.
>>>>
>>>> Use print_bad_page_map() in vm_normal_page_pmd() similar to how we do it
>>>> for vm_normal_page(), now that we have a function that can handle it.
>>>>
>>>> The report will now look something like (dumping pgd to pmd values):
>>>>
>>>> [   77.943408] BUG: Bad page map in process XXX  entry:80000001233f5867
>>>> [   77.944077] addr:00007fd84bb1c000 vm_flags:08100071 anon_vma: ...
>>>> [   77.945186] pgd:10a89f067 p4d:10a89f067 pud:10e5a2067 pmd:105327067
>>>>
>>>> Not using pgdp_get(), because that does not work properly on some arm
>>>> configs where pgd_t is an array. Note that we are dumping all levels
>>>> even when levels are folded for simplicity.
>>>>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>
>>> Should this still use a WARN?  If the admin sets panic-on-warn they
>>> have asked for "crash if anything goes wrong" and so that is what
>>> they should get.  Otherwise the system will still stay up.
>>
>> I assume you're comment is in context of the other proposal regarding
>> panicking.
> 
> Which one?  I'm only subscribed to xen-devel and might have missed it.

This one here:

https://lkml.kernel.org/r/4e1b7d2d-ed54-4e0a-a0a4-906b14d9cd41@p183

-- 
Cheers,

David / dhildenb

