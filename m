Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E561D690
	for <nvdimm@lists.linux.dev>; Fri,  6 Oct 2023 12:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgoGF5E0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696595628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kp2picVzpjCiZ5thzoNnS4NIffKCsvdoirWsfiXrjmU=;
	b=HgoGF5E0EROBMo3P9BpKEIJYxLHWveBimoNcl5r7N4VjkdSd37cP49cAeHZM0gYUfdUY2R
	0fyWD3i4o8sArVT+bMYY0tdbr2JVzKiFg+F6jypORh4WNa0HbcupnI8aUN7jLnfA4PJJ94
	7Go9lsUSs0YYm4xIxErIBS2v9sxendk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-yCxJdKn5OHySGjm2uMQAEw-1; Fri, 06 Oct 2023 08:33:30 -0400
X-MC-Unique: yCxJdKn5OHySGjm2uMQAEw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4068bf75d0dso14601895e9.3
        for <nvdimm@lists.linux.dev>; Fri, 06 Oct 2023 05:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696595609; x=1697200409;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kp2picVzpjCiZ5thzoNnS4NIffKCsvdoirWsfiXrjmU=;
        b=YCRdk+dhrvoPWjzY1uO9QTDe/DsasO1/TagcBhavUGJLox/F7ouLjKpV25R4MIGegq
         /R7sHkXe7txD59P2aINZPeQIdBdJftH+/U7wGCofleckCY25qZktW7WnakwjFcFT19ij
         TsZALhJBcW7/TApk22reXvNT9qYd47EjlxNb891n+W7o6KzDBkd+CNOGuIKgKzCczpry
         1ZB+LiFNnPdOeNfYG2M2tyTWbaX06Gbke2ed41sOuthNvKvHYfzQ+kNBKspTsqnxeagv
         /OvfQlz5seqAKIkMuooQWz6Wo0yx5YzMyTE+lrpR0Y+cXJwUk3ELSWkkfWFfsU1255T8
         g4UA==
X-Gm-Message-State: AOJu0YyNjjBdFgm8Eet4VKen+TA/vDqbBltj0c2TFEHXT0Akgw7LYEV6
	vCsUn20UbzWNZvmDXybXEWHSeRKSHZag0TKUgMseXzRHRCN76co02KHILMi6OrHVHjB6W4lk9cN
	0p/zjqkz5xKlkDG+7
X-Received: by 2002:a7b:c84d:0:b0:3fa:934c:8356 with SMTP id c13-20020a7bc84d000000b003fa934c8356mr7567182wml.10.1696595609210;
        Fri, 06 Oct 2023 05:33:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+qbujoqL35rM+01e93eyEax/eUnX6DN6O6MIW9k5Yq00U138jBSP0b8qR2JxHr3nONKt2Og==
X-Received: by 2002:a7b:c84d:0:b0:3fa:934c:8356 with SMTP id c13-20020a7bc84d000000b003fa934c8356mr7567153wml.10.1696595608689;
        Fri, 06 Oct 2023 05:33:28 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:ee00:4e24:cf8e:3de0:8819? (p200300cbc715ee004e24cf8e3de08819.dip0.t-ipconnect.de. [2003:cb:c715:ee00:4e24:cf8e:3de0:8819])
        by smtp.gmail.com with ESMTPSA id y4-20020a05600c364400b0040472ad9a3dsm3666144wmq.14.2023.10.06.05.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 05:33:28 -0700 (PDT)
Message-ID: <1d606139-9fff-a00e-c09b-587a8b6736f2@redhat.com>
Date: Fri, 6 Oct 2023 14:33:27 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: split memmap_on_memory requests
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
References: <20230928-vv-kmem_memmap-v4-0-6ff73fec519a@intel.com>
 <20230928-vv-kmem_memmap-v4-1-6ff73fec519a@intel.com>
 <efe2acfd-f22f-f856-cd2a-32374af2053a@redhat.com>
 <7893b6a37a429e2f06f2b65009f044208f904b32.camel@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <7893b6a37a429e2f06f2b65009f044208f904b32.camel@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03.10.23 22:03, Verma, Vishal L wrote:
> On Mon, 2023-10-02 at 11:28 +0200, David Hildenbrand wrote:
>>
>>> +
>>> +static int __ref try_remove_memory(u64 start, u64 size)
>>> +{
>>> +       int rc, nid = NUMA_NO_NODE;
>>> +
>>> +       BUG_ON(check_hotplug_memory_range(start, size));
>>> +
>>> +       /*
>>> +        * All memory blocks must be offlined before removing memory.  Check
>>> +        * whether all memory blocks in question are offline and return error
>>> +        * if this is not the case.
>>> +        *
>>> +        * While at it, determine the nid. Note that if we'd have mixed nodes,
>>> +        * we'd only try to offline the last determined one -- which is good
>>> +        * enough for the cases we care about.
>>> +        */
>>> +       rc = walk_memory_blocks(start, size, &nid, check_memblock_offlined_cb);
>>> +       if (rc)
>>> +               return rc;
>>> +
>>> +       /*
>>> +        * For memmap_on_memory, the altmaps could have been added on
>>> +        * a per-memblock basis. Loop through the entire range if so,
>>> +        * and remove each memblock and its altmap.
>>> +        */
>>> +       if (mhp_memmap_on_memory()) {
>>> +               unsigned long memblock_size = memory_block_size_bytes();
>>> +               u64 cur_start;
>>> +
>>> +               for (cur_start = start; cur_start < start + size;
>>> +                    cur_start += memblock_size)
>>> +                       __try_remove_memory(nid, cur_start, memblock_size);
>>> +       } else {
>>> +               __try_remove_memory(nid, start, size);
>>> +       }
>>> +
>>>          return 0;
>>>    }
>>
>> Why is the firmware, memblock and nid handling not kept in this outer
>> function?
>>
>> We really shouldn't be doing per memory block what needs to be done per
>> memblock: remove_memory_block_devices() and arch_remove_memory().
> 
> 
> Ah yes makes sense since we only do create_memory_block_devices() and
> arch_add_memory() in the per memory block inner loop during addition.
> 
> How should the locking work in this case though?

Sorry, I had to process a family NMI the last couple of days.

> 
> The original code holds the mem_hotplug_begin() lock over
> arch_remove_memory() and all of the nid and memblock stuff. Should I
> just hold the lock and release it in the inner loop for each memory
> block, and then also acquire and release it separately for the memblock
> and nid stuff in the outer function?

I think we have to hold it over the whole operation.

I saw that you sent a v5, I'll comment there.


-- 
Cheers,

David / dhildenb

