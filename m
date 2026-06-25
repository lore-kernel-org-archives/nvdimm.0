Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F87C331ECC;
	Thu, 25 Jun 2026 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782399451; cv=none; b=KD5uDSnfR8734zyc9xXvkKl34oVVtn8W+a5UO/HC5CKOPvK/DEZsEJAbYOY0MpYAoo9hvqPP6qKfx1fLXuFQuMY2Zx24JV+pke8CH3t0GF0veR+RIWWX9RSmTHi6o+Yq3SpjJGapVI1CJVY6pKq8fA/3ibLDBzxknW6r2L5X2Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782399451; c=relaxed/simple;
	bh=30zBPsJzeKdzDn+/lVWB6w0298dmMH2KV5iosn8rXac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nmjfYfHuQrrSu4SnrgWZ/AV6wQPQzeKwvQgN4IF24tawdT3f343n4kUkGsP4PmkzZm+fiHXswB5wkgsOGH+suNAvvfKot+ScsiQ89MksFFfUIkMVsAhCYCG32R67XMubDggzJ1hxTuHX3k20mOBgkZnFsoQaV62s8qVd0vi3v34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DL1K+Jv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DL1K+Jv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2BF1F00A3A;
	Thu, 25 Jun 2026 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782399450;
	bh=tqUUrJWMlnTxsZAmuCi7Oz0YuD8ibL81XGHYLTsNdR8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DL1K+Jv96MT0STD98/+fBEA4SYv29IHhKaFiC+RmpwELEsqKNGQsv/zck1jcHqfcM
	 oJ97ezN5ImmlSNchaHCpXwWHJ6nx17ovfOWdak1r1eVacHbGY6Keg8yhKxOxWkOmo8
	 tRan2Dat0DRFm3421OF/ccb7ARrVS4UHX9JS9vKCvpOwLpbbnsPdAtaXp3aEzdgsm0
	 mQx0LitzsrW/V6CAMqNf8oZzCP4BNDZVWA4m6N/rR7UkMUCxm1aCc2p30p1KVCecR0
	 jNa23zu3G5AD+mZb2srrlLMfTJAqz3xx9JuNIJ/IVTU2w//K1JmVKXcQA+ZCz0Eyuy
	 PzUJXnJ/D2q2Q==
Message-ID: <b5063ea6-b40b-4b02-9cf5-daf07874a257@kernel.org>
Date: Thu, 25 Jun 2026 16:57:21 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] mm/memory_hotplug:
 offline_and_remove_memory_ranges()
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, alison.schofield@intel.com,
 Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
 apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-6-gourry@gourry.net>
 <d48feca1-0203-43ff-bd66-6243291a51ba@kernel.org>
 <aj0ybgV7n0pqXF0b@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aj0ybgV7n0pqXF0b@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/26 15:51, Gregory Price wrote:
> On Thu, Jun 25, 2026 at 09:22:01AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/24/26 16:57, Gregory Price wrote:
>>>  extern int offline_and_remove_memory(u64 start, u64 size);
>>> +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges);
>>>  
>>>  #else
>>>  static inline void try_offline_node(int nid) {}
>>> @@ -283,6 +284,12 @@ static inline int remove_memory(u64 start, u64 size)
>>>  }
>>>  
>>>  static inline void __remove_memory(u64 start, u64 size) {}
>>> +
>>> +static inline int offline_and_remove_memory_ranges(const struct range *ranges,
>>> +						   int nr_ranges)
>>
>> Best to use "unsigned int" right from the start and use two tabs to indent.
>>
> 
> ack, ack.  need to reprogram my brain to two-indent style, i keep doing
> this reflexively.
> 
>>> +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
>>> +{
>>> +	unsigned long mb_total = 0;
>>>  	uint8_t *online_types, *tmp;
>>> -	int rc;
>>> +	int i, rc = 0;
>>>  
>>> -	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
>>> -	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
>>> +	if (!ranges || nr_ranges <= 0)
>>
>> With "unsigned int" this will be !nr_ranges.
>>
>> Wondering whether we would WARN_ON_ONCE() here.
>>
> 
> Seems reasonable.  Do we normally WARN when callers send dumb arguments?
> Seems like sending -EINVAL is sufficient?

We do it when we really expect no sane user to do that and doing it would
indicate an actual problem.

Like passing a nid to add_memory_resource() that doesn't even exist.

But yeah, no strong opinion here, we can just keep it as is.

-- 
Cheers,

David
