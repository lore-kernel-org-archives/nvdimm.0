Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832E878283
	for <nvdimm@lists.linux.dev>; Mon,  3 Jun 2024 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435740; cv=none; b=OZldw19/ZAPmOerXulL5apL/YAWxcnxoyZ45ATX+JXhZNnmPpqT8mw6H6NmBputhS5MJceh9zTlENLQ/wAE14xnpU28kOinj00TS/UPt3/WwAej27lt5wirY8f74vqwRaOIw7h/tWwBe7jWPWepat1KWAqDnwuSlSyAkm4XskZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435740; c=relaxed/simple;
	bh=+tB52iHPbmCXMHOeWlpQnCHMtEmXi/u7YpuslWqxPqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5jFvk8FbLlLblVcgrECOFRVqzgUVW0EJpZMxo+Zxa0U3QzQIrrna/h/Bjz5PAskvMTqZkClc+dczPxjWvEKScJ9JXrTvCg7x7LoeJtaZIcyebBVSSCfQoyJ1NwcO6gLNnKcrvZ6U8gXQvSqWFWTHAOBWIfgsK4VKW9/Ymuq8rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1A151042;
	Mon,  3 Jun 2024 10:29:21 -0700 (PDT)
Received: from [10.1.196.28] (eglon.cambridge.arm.com [10.1.196.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B2A83F792;
	Mon,  3 Jun 2024 10:28:56 -0700 (PDT)
Message-ID: <3c7c9b07-78b2-4b8d-968e-0c395c8f22b3@arm.com>
Date: Mon, 3 Jun 2024 18:28:51 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Content-Language: en-GB
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Dan Williams <dan.j.williams@intel.com>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>,
 Gregory Price <gregory.price@memverge.com>, John Groves <John@groves.net>,
 axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 Mark Rutland <mark.rutland@arm.com>
References: <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
 <20240508164417.00006c69@Huawei.com>
 <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
 <20240509132134.00000ae9@Huawei.com>
 <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
 <664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
 <ZldIzp0ncsRX5BZE@memverge.com>
 <5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
 <20240530143813.00006def@Huawei.com>
 <665a9402445ee_166872941d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <20240603134819.00001c5f@Huawei.com>
From: James Morse <james.morse@arm.com>
In-Reply-To: <20240603134819.00001c5f@Huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi guys,

On 03/06/2024 13:48, Jonathan Cameron wrote:
> On Fri, 31 May 2024 20:22:42 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>> Jonathan Cameron wrote:
>>> On Thu, 30 May 2024 14:59:38 +0800
>>> Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:
>>>> 在 2024/5/29 星期三 下午 11:25, Gregory Price 写道:  
>>>>> It's not just a CXL spec issue, though that is part of it. I think the
>>>>> CXL spec would have to expose some form of puncturing flush, and this
>>>>> makes the assumption that such a flush doesn't cause some kind of
>>>>> race/deadlock issue.  Certainly this needs to be discussed.
>>>>>
>>>>> However, consider that the upstream processor actually has to generate
>>>>> this flush.  This means adding the flush to existing coherence protocols,
>>>>> or at the very least a new instruction to generate the flush explicitly.
>>>>> The latter seems more likely than the former.
>>>>>
>>>>> This flush would need to ensure the data is forced out of the local WPQ
>>>>> AND all WPQs south of the PCIE complex - because what you really want to
>>>>> know is that the data has actually made it back to a place where remote
>>>>> viewers are capable of percieving the change.
>>>>>
>>>>> So this means:
>>>>> 1) Spec revision with puncturing flush
>>>>> 2) Buy-in from CPU vendors to generate such a flush
>>>>> 3) A new instruction added to the architecture.
>>>>>
>>>>> Call me in a decade or so.
>>>>>
>>>>>
>>>>> But really, I think it likely we see hardware-coherence well before this.
>>>>> For this reason, I have become skeptical of all but a few memory sharing
>>>>> use cases that depend on software-controlled cache-coherency.    
>>>>
>>>> Hi Gregory,
>>>>
>>>> 	From my understanding, we actually has the same idea here. What I am 
>>>> saying is that we need SPEC to consider this issue, meaning we need to 
>>>> describe how the entire software-coherency mechanism operates, which 
>>>> includes the necessary hardware support. Additionally, I agree that if 
>>>> software-coherency also requires hardware support, it seems that 
>>>> hardware-coherency is the better path.  
>>>>>
>>>>> There are some (FAMFS, for example). The coherence state of these
>>>>> systems tend to be less volatile (e.g. mappings are read-only), or
>>>>> they have inherent design limitations (cacheline-sized message passing
>>>>> via write-ahead logging only).    
>>>>
>>>> Can you explain more about this? I understand that if the reader in the 
>>>> writer-reader model is using a readonly mapping, the interaction will be 
>>>> much simpler. However, after the writer writes data, if we don't have a 
>>>> mechanism to flush and invalidate puncturing all caches, how can the 
>>>> readonly reader access the new data?  
>>>
>>> There is a mechanism for doing coarse grained flushing that is known to
>>> work on some architectures. Look at cpu_cache_invalidate_memregion().
>>> On intel/x86 it's wbinvd_on_all_cpu_cpus()  
>>
>> There is no guarantee on x86 that after cpu_cache_invalidate_memregion()
>> that a remote shared memory consumer can be assured to see the writes
>> from that event.
> 
> I was wondering about that after I wrote this...  I guess it guarantees
> we won't get a late landing write or is that not even true?
> 
> So if we remove memory, then added fresh memory again quickly enough
> can we get a left over write showing up?  I guess that doesn't matter as
> the kernel will chase it with a memset(0) anyway and that will be ordered
> as to the same address.
> 
> However we won't be able to elide that zeroing even if we know the device
> did it which is makes some operations the device might support rather
> pointless :(

>>> on arm64 it's a PSCI firmware call CLEAN_INV_MEMREGION (there is a
>>> public alpha specification for PSCI 1.3 with that defined but we
>>> don't yet have kernel code.)  

I have an RFC for that - but I haven't had time to update and re-test it.

If you need this, and have a platform where it can be implemented, please get in touch
with the people that look after the specs to move it along from alpha.


>> That punches visibility through CXL shared memory devices?

> It's a draft spec and Mark + James in +CC can hopefully confirm.
> It does say
> "Cleans and invalidates all caches, including system caches".
> which I'd read as meaning it should but good to confirm.

It's intended to remove any cached entries - including lines in what the arm-arm calls
"invisible" system caches, which typically only platform firmware can touch. The next
access should have to go all the way to the media. (I don't know enough about CXL to say
what a remote shared memory consumer observes)

Without it, all we have are the by-VA operations which are painfully slow for large
regions, and insufficient for system caches.

As with all those firmware interfaces - its for the platform implementer to wire up
whatever is necessary to remove cached content for the specified range. Just because there
is an (alpha!) spec doesn't mean it can be supported efficiently by a particular platform.


>>> These are very big hammers and so unsuited for anything fine grained.

You forgot really ugly too!


>>> In the extreme end of possible implementations they briefly stop all
>>> CPUs and clean and invalidate all caches of all types. So not suited
>>> to anything fine grained, but may be acceptable for a rare setup event,
>>> particularly if the main job of the writing host is to fill that memory
>>> for lots of other hosts to use.
>>>
>>> At least the ARM one takes a range so allows for a less painful
>>> implementation. 

That is to allow some ranges to fail. (e.g. you can do this to the CXL windows, but not
the regular DRAM).

On the less painful implementation, arm's interconnect has a gadget that does "Address
based flush" which could be used here. I'd hope platforms with that don't need to
interrupt all CPUs - but it depends on what else needs to be done.


>>> I'm assuming we'll see new architecture over time
>>> but this is a different (and potentially easier) problem space
>>> to what you need.  
>>
>> cpu_cache_invalidate_memregion() is only about making sure local CPU
>> sees new contents after an DPA:HPA remap event. I hope CPUs are able to
>> get away from that responsibility long term when / if future memory
>> expanders just issue back-invalidate automatically when the HDM decoder
>> configuration changes.
> 
> I would love that to be the way things go, but I fear the overheads of
> doing that on the protocol means people will want the option of the painful
> approach.



Thanks,

James
