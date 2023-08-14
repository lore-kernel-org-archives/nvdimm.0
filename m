Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248755C98
	for <nvdimm@lists.linux.dev>; Mon, 14 Aug 2023 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691997616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKY0cWansTn2sEL2WxZ0Fij0kBQM026mOZKicS65Eq4=;
	b=JYYt21SkCFoWmNVj1kWjInmYAIJC3xbR5t82tArdueFfA7/u+3myeebvtG6vl6uq6UrPJm
	kO8nDRZkH+FFPprYPVW1J46iCT+7I3dMWsQFpyBGO+ft0gDw0BTReAW6FQn61yMYnmNlFF
	qMWm3xsQam8JYc1t+k19M9R6CzqpmNk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-YR590lcUPK-7gOn_ufxuJg-1; Mon, 14 Aug 2023 03:20:15 -0400
X-MC-Unique: YR590lcUPK-7gOn_ufxuJg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ba1949656bso38819491fa.0
        for <nvdimm@lists.linux.dev>; Mon, 14 Aug 2023 00:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691997613; x=1692602413;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKY0cWansTn2sEL2WxZ0Fij0kBQM026mOZKicS65Eq4=;
        b=gI88yzb9w+sgX7mPE7GbPhHNr2cJ/XbNX0AkuManJJFZ9vTk0wxm1FYgCT4lskBRWy
         EDtHIz0kCnMNn3XdV7okCtVzWiElR+5TG2VpY3+wJS8EtvM8TABC9GRRWV4rSTxvi+aQ
         gYVbMrOBJMs0BvhBux8ez9f5Ait+DfoJfImBArfW/pIcoBbc4xmeAacZ8ZTgMZxdKdxa
         bmj+q96Oh2Zjc2aax2HCVYo9xbXqKg1x20MwEFy4FE5Nm1WFCWGdfPSz6axlGRccUVIV
         bE+4ezMxnvVNXdW+rNwQyqp6qLhv2kzh3IiaodIa8c7oO7H9x3VAnK+U7D0g8e+6RicO
         F3CA==
X-Gm-Message-State: AOJu0YwA5O8dSuOjpudt7n/DJt4fZ20GQBCYlkAllD5812axreNYdXar
	E93wIKcQW4cJ9hcIcUvWloACYiX5IEH/jkVStvT4Acxvc+1Jf9REe2w4G+opJBcT24opdOk87Ha
	ji/kBpUE3xkip2c9V
X-Received: by 2002:a05:6512:3985:b0:4fd:f77d:5051 with SMTP id j5-20020a056512398500b004fdf77d5051mr7102541lfu.26.1691997613536;
        Mon, 14 Aug 2023 00:20:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxFH/xSsrS7cCDMRZUmdj0b6BcGtlavDhBDrFjlcKGEEig3zD2C6+9p5Bp+5A4BT4BRvhHWQ==
X-Received: by 2002:a05:6512:3985:b0:4fd:f77d:5051 with SMTP id j5-20020a056512398500b004fdf77d5051mr7102519lfu.26.1691997613136;
        Mon, 14 Aug 2023 00:20:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:d900:2d94:8433:b532:3418? (p200300d82f2bd9002d948433b5323418.dip0.t-ipconnect.de. [2003:d8:2f2b:d900:2d94:8433:b532:3418])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003fe2a40d287sm13602203wmk.1.2023.08.14.00.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 00:20:12 -0700 (PDT)
Message-ID: <6ce08d40-332b-217e-6203-c73dd7203e96@redhat.com>
Date: Mon, 14 Aug 2023 09:20:11 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 2/3] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
To: "Huang, Ying" <ying.huang@intel.com>,
 "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
 "jmoyer@redhat.com" <jmoyer@redhat.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mike Rapoport <rppt@kernel.org>, Bernhard Walle <bernhard.walle@gmx.de>
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
 <20230720-vv-kmem_memmap-v2-2-88bdaab34993@intel.com>
 <87wmyp26sw.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <abe41c22f72ad600541c6f2b199180b1cbcbb780.camel@intel.com>
 <87jzty9l6w.fsf@yhuang6-desk2.ccr.corp.intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <87jzty9l6w.fsf@yhuang6-desk2.ccr.corp.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.08.23 08:45, Huang, Ying wrote:
> "Verma, Vishal L" <vishal.l.verma@intel.com> writes:
> 
>> On Mon, 2023-07-24 at 13:54 +0800, Huang, Ying wrote:
>>> Vishal Verma <vishal.l.verma@intel.com> writes:
>>>
>>>>
>>>> @@ -2035,12 +2056,38 @@ void try_offline_node(int nid)
>>>>   }
>>>>   EXPORT_SYMBOL(try_offline_node);
>>>>
>>>> -static int __ref try_remove_memory(u64 start, u64 size)
>>>> +static void __ref __try_remove_memory(int nid, u64 start, u64 size,
>>>> +                                    struct vmem_altmap *altmap)
>>>>   {
>>>> -       struct vmem_altmap mhp_altmap = {};
>>>> -       struct vmem_altmap *altmap = NULL;
>>>> -       unsigned long nr_vmemmap_pages;
>>>> -       int rc = 0, nid = NUMA_NO_NODE;
>>>> +       /* remove memmap entry */
>>>> +       firmware_map_remove(start, start + size, "System RAM");
>>>
>>> If mhp_supports_memmap_on_memory(), we will call
>>> firmware_map_add_hotplug() for whole range.  But here we may call
>>> firmware_map_remove() for part of range.  Is it OK?
>>>
>>
>> Good point, this is a discrepancy in the add vs remove path. Can the
>> firmware memmap entries be moved up a bit in the add path, and is it
>> okay to create these for each memblock? Or should these be for the
>> whole range? I'm not familiar with the implications. (I've left it as
>> is for v3 for now, but depending on the direction I can update in a
>> future rev).
> 
> Cced more firmware map developers and maintainers.
> 
> Per my understanding, we should create one firmware memmap entry for
> each memblock.

Ideally we should create it for the whole range, ti limit the ranges. 
But it really only matters for DIMMs; for dax/kmem, we'll not create any 
firmware entries.

-- 
Cheers,

David / dhildenb

