Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A956A23DEAD
	for <nvdimm@lists.linux.dev>; Thu, 10 Jul 2025 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752145205; cv=none; b=Owxy0aiJab9wYZBDc0CdpikOFewyFC+tpj5KaBMF8alT4K7CjdFfoyLhOpG/Bz5KhlnAuktRVhEI1hvT2Z/E0NUFfegjwgE/kKs0gySDU5soRDhAAIpK3i478MD7STGeoZIWGmdcjUIzHsxyi/crAfFfC9Npv3zwg6OBg88iZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752145205; c=relaxed/simple;
	bh=4DFOJCCsvI24QKbrJDm/aFnyarYSoJI2WT5J2wb9AVM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ku/c9axVObPaQeMXuW0X3pf13khOeMBq+kdpUSRZ4Qt/WRYUjYSR8exyE1fAF7C9UU/5Dbp0stTfWCAt6tYt2rP3VoMcpqL5bqvVR8iVslJ3UR1sHFcKXTAsVuqUnt+Y1l/BtM0dMCv3sfysrnQjq0yhsR8JECzJvHLH5rbWpZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JTkO1R1x; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JTkO1R1x"
Message-ID: <41d1245c-8a7f-4c5a-ba84-8e7e33b896b2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752145191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtJpoUInX8ucjkyFAiUJkj/ubfAu8PdaUF9qEnnOSvU=;
	b=JTkO1R1xjDfTuBgYIJDFm3myKaXQxfj7KA99JQhTwFwRfJfdlMfVqNb/32AJd5hVEQc+/y
	ikDzG1CMPk+cf8GKLXp/oLnpGKCdp7YDNo5FxvVniKBGn3a8Zm+sh5S0I4Llam3Gk8JIy6
	rXWG6A9C3kEzH2Wcxqp1WgkQkckbLIs=
Date: Thu, 10 Jul 2025 18:59:40 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v2_00/11=5D_dm-pcache_=E2=80=93_persistent?=
 =?UTF-8?Q?-memory_cache_for_block_devices?=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250707065809.437589-1-dongsheng.yang@linux.dev>
 <85b5cb31-b272-305f-8910-c31152485ecf@redhat.com>
 <e50ef45e-4c1a-4874-8d5f-9ca86f9a532c@linux.dev>
In-Reply-To: <e50ef45e-4c1a-4874-8d5f-9ca86f9a532c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 7/9/2025 5:45 PM, Dongsheng Yang 写道:
>
> 在 7/8/2025 4:16 AM, Mikulas Patocka 写道:
>>
>> On Mon, 7 Jul 2025, Dongsheng Yang wrote:
>>
>>> Hi Mikulas,
>>>     This is V2 for dm-pcache, please take a look.
>>>
>>> Code:
>>>      https://github.com/DataTravelGuide/linux tags/pcache_v2
>>>
>>> Changelogs
>>>
>>> V2 from V1:
>>>     - introduce req_alloc() and req_init() in backing_dev.c, then we
>>>       can do req_alloc() before holding spinlock and do req_init()
>>>       in subtree_walk().
>>>     - introduce pre_alloc_key and pre_alloc_req in walk_ctx, that
>>>       means we can pre-allocate cache_key or backing_dev_request
>>>       before subtree walking.
>>>     - use mempool_alloc() with NOIO for the allocation of cache_key
>>>       and backing_dev_req.
>>>     - some coding style changes from comments of Jonathan.
>> Hi
>>
>> mempool_alloc with GFP_NOIO never fails - so you don't have to check the
>> returned value for NULL and propagate the error upwards.
>
>
> Hi Mikulas:
>
>    I noticed that the implementation of mempool_alloc—it waits for 5 
> seconds and retries when allocation fails.
>
> With this in mind, I propose that we handle -ENOMEM inside defer_req() 
> using a similar mechanism. something like this commit:
>
>
> https://github.com/DataTravelGuide/linux/commit/e6fc2e5012b1fe2312ed7dd02d6fbc2d038962c0 
>
>
>
> Here are two key reasons why:
>
> (1) If we manage -ENOMEM in defer_req(), we don’t need to modify every 
> lower-level allocation to use mempool to avoid failures—for example,
>
> cache_key, backing_req, and the kmem.bvecs you mentioned. More 
> importantly, there’s no easy way to prevent allocation failure in some 
> places—for instance, bio_init_clone() could still return -ENOMEM.
>
> (2) If we use a mempool, it will block and wait indefinitely when 
> memory is unavailable, preventing the process from exiting.
>
> But with defer_req(), the user can still manually stop the pcache 
> device using dmsetup remove, releasing some memory if user want.
>
>
> What do you think?


BTW, I added a test case for NOMEM scenario by using failslab:


https://github.com/DataTravelGuide/dtg-tests/blob/main/pcache.py.data/pcache_failslab.sh

>
> Thanx
>
> Dongsheng
>
>>
>> "backing_req->kmem.bvecs = kmalloc_array(n_vecs, sizeof(struct bio_vec),
>> GFP_NOIO)" - this call may fail and you should handle the error 
>> gracefully
>> (i.e. don't end the bio with an error). Would it be possible to trim the
>> request to BACKING_DEV_REQ_INLINE_BVECS vectors and retry it?
>> Alternativelly, you can create a mempool for the largest possible n_vecs
>> and allocate from this mempool if kmalloc_array fails.
>>
>> I'm sending two patches for dm-pcache - the first patch adds the include
>> file linux/bitfield.h - it is needed in my config. The second patch 
>> makes
>> slab caches per-module rather than per-device, if you have them
>> per-device, there are warnings about duplicate cache names.
>>
>>
>> BTW. What kind of persistent memory do you use? (afaik Intel killed the
>> Optane products and I don't know of any replacement)
>>
>> Some times ago I created a filesystem for persistent memory - see
>> git://leontynka.twibright.com/nvfs.git - I'd be interested if you can 
>> test
>> it on your persistent memory implementation.
>>
>> Mikulas
>>
>
