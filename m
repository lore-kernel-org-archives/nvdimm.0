Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161BD279DDA
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751869499; cv=none; b=TEFNl2dklq3WLEcSP8BRlYe4ez5zSHgm5MsvbHL4CGqv8HI/woEgUW/n0Z7AKW1XdTPMPFbVisjJ65Y/2xmptibS+GdfZZVzLhqtuZOsPWFEYzRhAZbnHq/tUOnG7knYWlWOe8if+PMWh/IVDrxXYIFyoVRiOqPEosn0/Eo76yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751869499; c=relaxed/simple;
	bh=EUFWpjjgob4OiYmbKUmmapgj93Caed5bakQMEntVN/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rUZBXI5LF4wZgRiQNXN0Q6k7ghJA9p6N09ISZKlt0KA5S4LZkT195WNLtZLdW6u8lqWm13P1Ju1vZAE8mofvZeLysKJpDtme+BdJzBTcWOeByU739ViiMsHTMKHGbyZeFTgBCwqNVLYk3tFKl6z58UIsh5rF78HM+5Ag6046gVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hndAcuIb; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hndAcuIb"
Message-ID: <09b2de99-8b59-4755-9296-a016d2670801@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751869486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9dvlNAmk8KWeQmipSdqfopqJzuRBxJc8Xg/DGYpMYo=;
	b=hndAcuIb30RPLT1NMvsqWnX44keJGJ2QejWt6O3zZIV9NEqrgAgTDpsKWsV+auqpaFBMNo
	yUNQNOQocFRK833+6JrN84EcZHvlzs/YeBL3ATsgY8KnMn5GKP/Xl7nW6HeU3ABQGqtnCb
	1reUbqC123XIXhY4TzKi5MI+Wxs62b4=
Date: Mon, 7 Jul 2025 14:24:27 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v1 05/11] dm-pcache: add cache_segment
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: mpatocka@redhat.com, agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 hch@lst.de, dan.j.williams@intel.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
 <20250624073359.2041340-6-dongsheng.yang@linux.dev>
 <20250701155928.0000160a@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20250701155928.0000160a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 7/1/2025 10:59 PM, Jonathan Cameron 写道:
> On Tue, 24 Jun 2025 07:33:52 +0000
> Dongsheng Yang <dongsheng.yang@linux.dev> wrote:
>
>> Introduce *cache_segment.c*, the in-memory/on-disk glue that lets a
>> `struct pcache_cache` manage its array of data segments.
>>
>> * Metadata handling
>>    - Loads the most-recent replica of both the segment-info block
>>      (`struct pcache_segment_info`) and per-segment generation counter
>>      (`struct pcache_cache_seg_gen`) using `pcache_meta_find_latest()`.
>>    - Updates those structures atomically with CRC + sequence rollover,
>>      writing alternately to the two metadata slots inside each segment.
>>
>> * Segment initialisation (`cache_seg_init`)
>>    - Builds a `struct pcache_segment` pointing to the segment’s data
>>      area, sets up locks, generation counters, and, when formatting a new
>>      cache, zeroes the on-segment kset header.
>>
>>
>> +
>> +	cache = cache_seg->cache;
>> +	cache_seg_gen_increase(cache_seg);
>> +
>> +	spin_lock(&cache->seg_map_lock);
>> +	if (cache->cache_full)
>> +		cache->cache_full = false;
> Perhaps just write cache->cache_full = false unconditionally?
> If there is a reason to not do the write, then add a comment here.
Hi Jonathan,

When the cache->cache_full is already false, we don't need to write 
cache->cache_full with false.


Thanx

Dongsheng


>
>> +	clear_bit(cache_seg->cache_seg_id, cache->seg_map);
>> +	spin_unlock(&cache->seg_map_lock);
>> +
>> +	pcache_defer_reqs_kick(CACHE_TO_PCACHE(cache));
>> +	/* clean_work will clean the bad key in key_tree*/
>> +	queue_work(cache_get_wq(cache), &cache->clean_work);
>> +}
