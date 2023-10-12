Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0691F5FD
	for <nvdimm@lists.linux.dev>; Thu, 12 Oct 2023 08:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f87LYifP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697100055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUu9gspJCKmtseGxPT5e7VM//lOrd9x+RY45RlgrqZo=;
	b=f87LYifP/I8G1HGoS34o1xbxH5IL+LIZ/IDI//za907i7yePj2T53OaVVJjhk3q4PtgTZr
	YJL5U6thpu0tZWX3KaogvHl6JNZd/YYYGVXYOzjd1dIC27hWFIvca4i3XB2b7fMxQaVWqD
	Iu6ibEqEtc3qH8WdhenVLDQcPiCtj44=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-HQ-yFM7iNSyllTcqcDk6fg-1; Thu, 12 Oct 2023 04:40:53 -0400
X-MC-Unique: HQ-yFM7iNSyllTcqcDk6fg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-317d5b38194so300283f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 12 Oct 2023 01:40:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697100052; x=1697704852;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oUu9gspJCKmtseGxPT5e7VM//lOrd9x+RY45RlgrqZo=;
        b=ZT9uuRN0WbIh5iA87cfoebmUBGdm8Cg0EbyzitF+Q3ddhGYOvdAAEMYIPQI7oqgpgG
         ovnul63Eo8XwQ3AYf+dyVu6dH3i+fOehHbUr8CfhYMnKfH5GisuUbqXr1r4nEDb2KxWi
         2QNdpRQYVJfh8BpphozToL9MxVqN1H1dzzHdJP9CCAA/hfHZbEOFhCCRUgMi23QNEfu+
         ellliy+j9vCkNkdnwjVsVlbI3yHAOfttyjIHGxB3tvYZAT1Go6twNdhby+lF0wKKH+hG
         bdJS229G33UorTybFq/90fDsZt/fv4aEDiJ5Gx40iTdpFbdT/heXIWJvyIu9lRbrOuhZ
         ccLg==
X-Gm-Message-State: AOJu0YwK8BRSeHqn/khCgf/hMsNu5mrN67rQPcXAGv8+CzkmWM0ukbh6
	G4dOcAYgOFex8oBvVJAtKQwDgG0A1wFtJk7pdyCRSu1+wzbDPNqrywpjrmOnD9TXAP5nGLVL6vT
	qy+p6klzVRKF8NKKa
X-Received: by 2002:adf:fd0d:0:b0:32d:92fc:a625 with SMTP id e13-20020adffd0d000000b0032d92fca625mr724706wrr.24.1697100052408;
        Thu, 12 Oct 2023 01:40:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnsVLUc9SJqZHyOsUziQY+Ca/ePvrWEabXeptfmw7K7cVLyJaUKLY9iF+clfj3wVEPiBqd5w==
X-Received: by 2002:adf:fd0d:0:b0:32d:92fc:a625 with SMTP id e13-20020adffd0d000000b0032d92fca625mr724682wrr.24.1697100051973;
        Thu, 12 Oct 2023 01:40:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:ee00:b271:fb6c:a931:4769? (p200300cbc70dee00b271fb6ca9314769.dip0.t-ipconnect.de. [2003:cb:c70d:ee00:b271:fb6c:a931:4769])
        by smtp.gmail.com with ESMTPSA id g8-20020a5d5408000000b0031c5b380291sm17680891wrv.110.2023.10.12.01.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 01:40:51 -0700 (PDT)
Message-ID: <748d40cb-35f4-98d6-a940-055de88bbc8b@redhat.com>
Date: Thu, 12 Oct 2023 10:40:50 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "Huang, Ying" <ying.huang@intel.com>
Cc: "Hocko, Michal" <mhocko@suse.com>, "Jiang, Dave" <dave.jiang@intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "jmoyer@redhat.com" <jmoyer@redhat.com>,
 "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>
References: <20231005-vv-kmem_memmap-v5-0-a54d1981f0a3@intel.com>
 <20231005-vv-kmem_memmap-v5-1-a54d1981f0a3@intel.com>
 <87jzrylslk.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <831b9b12-08fe-f5dc-f21d-83284b0aee8a@redhat.com>
 <f0d385f1c1961a17499e5acccf3ae7cdadb942cb.camel@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5 1/2] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
In-Reply-To: <f0d385f1c1961a17499e5acccf3ae7cdadb942cb.camel@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12.10.23 07:53, Verma, Vishal L wrote:
> On Mon, 2023-10-09 at 17:04 +0200, David Hildenbrand wrote:
>> On 07.10.23 10:55, Huang, Ying wrote:
>>> Vishal Verma <vishal.l.verma@intel.com> writes:
>>>
>>>> @@ -2167,47 +2221,28 @@ static int __ref try_remove_memory(u64 start, u64 size)
>>>>          if (rc)
>>>>                  return rc;
>>>>    
>>>> +       mem_hotplug_begin();
>>>> +
>>>>          /*
>>>> -        * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
>>>> -        * the same granularity it was added - a single memory block.
>>>> +        * For memmap_on_memory, the altmaps could have been added on
>>>> +        * a per-memblock basis. Loop through the entire range if so,
>>>> +        * and remove each memblock and its altmap.
>>>>           */
>>>>          if (mhp_memmap_on_memory()) {
>>>
>>> IIUC, even if mhp_memmap_on_memory() returns true, it's still possible
>>> that the memmap is put in DRAM after [2/2].  So that,
>>> arch_remove_memory() are called for each memory block unnecessarily.  Can
>>> we detect this (via altmap?) and call remove_memory_block_and_altmap()
>>> for the whole range?
>>
>> Good point. We should handle memblock-per-memblock onny if we have to
>> handle the altmap. Otherwise, just call a separate function that doesn't
>> care about -- e.g., called remove_memory_blocks_no_altmap().
>>
>> We could simply walk all memory blocks and make sure either all have an
>> altmap or none has an altmap. If there is a mix, we should bail out with
>> WARN_ON_ONCE().
>>
> Ok I think I follow - based on both of these threads, here's my
> understanding in an incremental diff from the original patches (may not
> apply directly as I've already committed changes from the other bits of
> feedback - but this should provide an idea of the direction) -
> 
> ---
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 507291e44c0b..30addcb063b4 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -2201,6 +2201,40 @@ static void __ref remove_memory_block_and_altmap(u64 start, u64 size)
>   	}
>   }
>   
> +static bool memblocks_have_altmaps(u64 start, u64 size)
> +{
> +	unsigned long memblock_size = memory_block_size_bytes();
> +	u64 num_altmaps = 0, num_no_altmaps = 0;
> +	struct memory_block *mem;
> +	u64 cur_start;
> +	int rc = 0;
> +
> +	if (!mhp_memmap_on_memory())
> +		return false;

Probably can remove that, checked by the caller. (or drop the one in the 
caller)

> +
> +	for (cur_start = start; cur_start < start + size;
> +	     cur_start += memblock_size) {
> +		if (walk_memory_blocks(cur_start, memblock_size, &mem,
> +				       test_has_altmap_cb))
> +			num_altmaps++;
> +		else
> +			num_no_altmaps++;
> +	}

You should do that without the outer loop, by doing the counting in the 
callback function instead.	

> +
> +	if (!num_altmaps && num_no_altmaps > 0)
> +		return false;
> +
> +	if (!num_no_altmaps && num_altmaps > 0)
> +		return true;
> +
> +	/*
> +	 * If there is a mix of memblocks with and without altmaps,
> +	 * something has gone very wrong. WARN and bail.
> +	 */
> +	WARN_ONCE(1, "memblocks have a mix of missing and present altmaps");

It would be better if we could even make try_remove_memory() fail in 
this case.

> +	return false;
> +}
> +
>   static int __ref try_remove_memory(u64 start, u64 size)
>   {
>   	int rc, nid = NUMA_NO_NODE;
> @@ -2230,7 +2264,7 @@ static int __ref try_remove_memory(u64 start, u64 size)
>   	 * a per-memblock basis. Loop through the entire range if so,
>   	 * and remove each memblock and its altmap.
>   	 */
> -	if (mhp_memmap_on_memory()) {
> +	if (mhp_memmap_on_memory() && memblocks_have_altmaps(start, size)) {
>   		unsigned long memblock_size = memory_block_size_bytes();
>   		u64 cur_start;
>   
> @@ -2239,7 +2273,8 @@ static int __ref try_remove_memory(u64 start, u64 size)
>   			remove_memory_block_and_altmap(cur_start,
>   						       memblock_size);

^ probably cleaner move the loop into remove_memory_block_and_altmap() 
and call it remove_memory_blocks_and_altmaps(start, size) instead.

>   	} else {
> -		remove_memory_block_and_altmap(start, size);
> +		remove_memory_block_devices(start, size);
> +		arch_remove_memory(start, size, NULL);
>   	}
>   
>   	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
> 

-- 
Cheers,

David / dhildenb

