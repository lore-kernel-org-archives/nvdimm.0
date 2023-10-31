Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D06819444
	for <nvdimm@lists.linux.dev>; Tue, 31 Oct 2023 10:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bsk1NFXc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698747200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pAQbrfQoIJNOhnUYvPhPLxk1gl1ZWcaKec9dUXNoa30=;
	b=bsk1NFXc9EW4Hq6dlfMG0utL7XSso8jZm+1jA8ZD+T8E7UXaXlTJ2VArSj3spYFZTRlbLc
	G+e/ouGO61H6ZDrm85X0KAkbRxoBa5KrvPe32bAtqHweWDWJMw7I6G6zPBrmhHUjyLsGXF
	+5dUyQBBD8/F8+ED915V7adtmJZw8Vc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-_e5eTlPYNGSo9Fe6zUx4UA-1; Tue, 31 Oct 2023 06:13:18 -0400
X-MC-Unique: _e5eTlPYNGSo9Fe6zUx4UA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-408534c3ec7so38335265e9.1
        for <nvdimm@lists.linux.dev>; Tue, 31 Oct 2023 03:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698747196; x=1699351996;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAQbrfQoIJNOhnUYvPhPLxk1gl1ZWcaKec9dUXNoa30=;
        b=ng3RKGz/6OM7ZDeqmIBepAA0C//l9xG4syFP29Dj1eS7ivN6wGGN72nSKO7z7fhFea
         nrGcNN2zvEJ+74OodaeYFV9pG+6v8m6oafdKns4NyhsBvbFJv1YEf3h/KgKvwuCuVdBg
         w0pdA93mGoTf5PinXD9/F5ok6ye8MqDinQ1hgPV+LTsAsaQSa+fNCyyC0zkjqfkx57Zd
         EoZVE5NQAOoIcog5Jd+TLItVPgYxL8ZZ94XQUddKs0rUBLgE3iYzvxbnzM06uEOwYKQy
         yNYu8QFlJGpmAvDR5wBmwDgLZjtNdGumroFkpJVymonNfGhuwXft8DvdyMeiUr5+smXW
         4LQA==
X-Gm-Message-State: AOJu0YxMvDFKrvYpomOlVhdl4olN840KpDSg9fTpKM8LnG9ULWOHSWzo
	sEY8mvUUHfFiyKuzTIeAg6DP9yxAZYmPvOHfjg1nJRhSPb+iUQ6Bz9XUbmzJSiJCqeO5iPlb9h1
	5jhyk/ZwBiaXjq8uZ
X-Received: by 2002:a05:600c:4449:b0:408:4120:bab7 with SMTP id v9-20020a05600c444900b004084120bab7mr10499390wmn.15.1698747196431;
        Tue, 31 Oct 2023 03:13:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHevO5e8NbNMxyxVt2qma4vR7VuBnZ4MDfKV72pDE/YGANv/bYJg45/F0IcpscecHYnjWYxuQ==
X-Received: by 2002:a05:600c:4449:b0:408:4120:bab7 with SMTP id v9-20020a05600c444900b004084120bab7mr10499373wmn.15.1698747195965;
        Tue, 31 Oct 2023 03:13:15 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:8f00:43b0:1107:57d2:28ee? (p200300cbc7078f0043b0110757d228ee.dip0.t-ipconnect.de. [2003:cb:c707:8f00:43b0:1107:57d2:28ee])
        by smtp.gmail.com with ESMTPSA id fb12-20020a05600c520c00b00405d9a950a2sm1281801wmb.28.2023.10.31.03.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 03:13:15 -0700 (PDT)
Message-ID: <e5d9423e-5a61-4fbe-b971-52e4283c1afd@redhat.com>
Date: Tue, 31 Oct 2023 11:13:14 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "Jiang, Dave" <dave.jiang@intel.com>, "osalvador@suse.de"
 <osalvador@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "Huang, Ying" <ying.huang@intel.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "aneesh.kumar@linux.ibm.com"
 <aneesh.kumar@linux.ibm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "Hocko, Michal" <mhocko@suse.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "jmoyer@redhat.com" <jmoyer@redhat.com>,
 "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>
References: <20231025-vv-kmem_memmap-v7-0-4a76d7652df5@intel.com>
 <20231025-vv-kmem_memmap-v7-2-4a76d7652df5@intel.com>
 <4df63333-de57-4a58-a110-77b4fdfa6a9e@redhat.com>
 <cdeef06d81abb3fc4b5f4bea6b3fd5b83972249b.camel@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <cdeef06d81abb3fc4b5f4bea6b3fd5b83972249b.camel@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31.10.23 03:14, Verma, Vishal L wrote:
> On Mon, 2023-10-30 at 11:20 +0100, David Hildenbrand wrote:
>> On 26.10.23 00:44, Vishal Verma wrote:
>>>
> [..]
> 
>>> @@ -2146,11 +2186,69 @@ void try_offline_node(int nid)
>>>    }
>>>    EXPORT_SYMBOL(try_offline_node);
>>>    
>>> -static int __ref try_remove_memory(u64 start, u64 size)
>>> +static void __ref remove_memory_blocks_and_altmaps(u64 start, u64 size)
>>>    {
>>> -       struct memory_block *mem;
>>> -       int rc = 0, nid = NUMA_NO_NODE;
>>> +       unsigned long memblock_size = memory_block_size_bytes();
>>>          struct vmem_altmap *altmap = NULL;
>>> +       struct memory_block *mem;
>>> +       u64 cur_start;
>>> +       int rc;
>>> +
>>> +       /*
>>> +        * For memmap_on_memory, the altmaps could have been added on
>>> +        * a per-memblock basis. Loop through the entire range if so,
>>> +        * and remove each memblock and its altmap.
>>> +        */
>>
>> /*
>>    * altmaps where added on a per-memblock basis; we have to process
>>    * each individual memory block.
>>    */
>>
>>> +       for (cur_start = start; cur_start < start + size;
>>> +            cur_start += memblock_size) {
>>> +               rc = walk_memory_blocks(cur_start, memblock_size, &mem,
>>> +                                       test_has_altmap_cb);
>>> +               if (rc) {
>>> +                       altmap = mem->altmap;
>>> +                       /*
>>> +                        * Mark altmap NULL so that we can add a debug
>>> +                        * check on memblock free.
>>> +                        */
>>> +                       mem->altmap = NULL;
>>> +               }
>>
>> Simpler (especially, we know that there must be an altmap):
>>
>> mem = find_memory_block(pfn_to_section_nr(cur_start));
>> altmap = mem->altmap;
>> mem->altmap = NULL;
>>
>> I think we might be able to remove test_has_altmap_cb() then.
>>
>>> +
>>> +               remove_memory_block_devices(cur_start, memblock_size);
>>> +
>>> +               arch_remove_memory(cur_start, memblock_size, altmap);
>>> +
>>> +               /* Verify that all vmemmap pages have actually been freed. */
>>> +               if (altmap) {
>>
>> There must be an altmap, so this can be done unconditionally.
> 
> Hi David,

Hi!

> 
> All other comments make sense, making those changes now.
> 
> However for this one, does the WARN() below go away then?
> 
> I was wondering if maybe arch_remove_memory() is responsible for
> freeing the altmap here, and at this stage we're just checking if that
> happened. If it didn't WARN and then free it.

I think that has to stay, to make sure arch_remove_memory() did the 
right thing and we don't -- by BUG -- still have some altmap pages in 
use after they should have been completely freed.

> 
> I drilled down the path, and I don't see altmap actually getting freed
> in vmem_altmap_free(), but I wasn't sure if <something else> was meant
> to free it as altmap->alloc went down to 0.


vmem_altmap_free() does the "altmap->alloc -= nr_pfns", which is called 
when arch_remove_memory() frees the vmemmap pages and detects that they 
actually come from the altmap reserve and not from the buddy/earlyboot 
allocator.

Freeing an altmap is just unaccounting it in the altmap structure; and 
here we make sure that we are actually back down to 0 and don't have 
some weird altmap freeing BUG in arch_remove_memory().

-- 
Cheers,

David / dhildenb

