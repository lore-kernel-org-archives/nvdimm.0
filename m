Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4AC4F5E0
	for <nvdimm@lists.linux.dev>; Mon, 30 Jun 2025 13:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751290846; cv=none; b=R8Gcs/e8W+urKx7DaJ0E1eNXYchGl4JKf6nrNRPgXkZEMKTsygzoSLevJv0d4ZqwDH5aOaC7Chprq2ATk2hD9oPhOxhK8SOejWO/Ov/UIYfgjvQZWnXRgC0qT+XlwlLIFrX9uADc2xiwD/eoq/JrO8qkFlZZTzsLL1qyBGsZmLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751290846; c=relaxed/simple;
	bh=vSa4jRfkd5Fa1HqN56wto+cRhg9EBqreeTK3FR+cxdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JM+LfxhyY3VGPXG1PwsrvWiHBO2lESNe69ykEPxAH27RH57XFwU5zbJ6G1h7M8hr2kkpCUp9Z76ZH/oS8cO5Qsnn720DlDH4pZvwCOi1p+OD4ghVlpko2TTfjnGM0NrQ7lNFYQmU1hF45NwHKOOB/BqmI45OlnAizmCxCbxwQUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YbHLXzf+; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YbHLXzf+"
Message-ID: <7ff7c4fc-d830-41c9-ab94-a198d3d9a3b5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751290841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rNJsyXEVGNn49x3NYJKu0xplp8QGZnCZzJiyec2M590=;
	b=YbHLXzf+LJ3P74xrV/Dljtoc+77NUBVCapf1zwEUG2fx9Me3m/EiJjSvoxowdDaHbTiTV+
	aKTTyMeNLFJ+nN8H3rYw7x51Nzwgq7L0BdsOE/ULQST6rvQhS46i7RVlHHSiQsJORqTWb/
	5EzosU2iG/VrNqTkReP/gVAl7fxpx0E=
Date: Mon, 30 Jun 2025 21:40:34 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v1_00/11=5D_dm-pcache_=E2=80=93_persistent?=
 =?UTF-8?Q?-memory_cache_for_block_devices?=
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
 <8d383dc6-819b-2c7f-bab5-2cd113ed9ece@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <8d383dc6-819b-2c7f-bab5-2cd113ed9ece@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 6/30/2025 9:30 PM, Mikulas Patocka 写道:
>
> On Tue, 24 Jun 2025, Dongsheng Yang wrote:
>
>> Hi Mikulas,
>> 	This is V1 for dm-pcache, please take a look.
>>
>> Code:
>>      https://github.com/DataTravelGuide/linux tags/pcache_v1
>>
>> Changelogs from RFC-V2:
>> 	- use crc32c to replace crc32
>> 	- only retry pcache_req when cache full, add pcache_req into defer_list,
>> 	  and wait cache invalidation happen.
>> 	- new format for pcache table, it is more easily extended with
>> 	  new parameters later.
>> 	- remove __packed.
>> 	- use spin_lock_irq in req_complete_fn to replace
>> 	  spin_lock_irqsave.
>> 	- fix bug in backing_dev_bio_end with spin_lock_irqsave.
>> 	- queue_work() inside spinlock.
>> 	- introduce inline_bvecs in backing_dev_req.
>> 	- use kmalloc_array for bvecs allocation.
>> 	- calculate ->off with dm_target_offset() before use it.
> Hi
>
> The out-of-memory handling still doesn't seem right.
>
> If the GFP_NOWAIT allocation doesn't succeed (which may happen anytime,
> for example it happens when the machine is receiving network packets
> faster than the swapper is able to swap out data), create_cache_miss_req
> returns NULL, the caller changes it to -ENOMEM, cache_read returns
> -ENOMEM, -ENOMEM is propagated up to end_req and end_req will set the
> status to BLK_STS_RESOURCE. So, it may randomly fail I/Os with an error.
>
> Properly, you should use mempools. The mempool allocation will wait until
> some other process frees data into the mempool.
>
> If you need to allocate memory inside a spinlock, you can't do it reliably
> (because you can't sleep inside a spinlock and non-sleepng memory
> allocation may fail anytime). So, in this case, you should drop the
> spinlock, allocate the memory from a mempool with GFP_NOIO and jump back
> to grab the spinlock - and now you holding the allocated object, so you
> can use it while you hold the spinlock.


Hi Mikulas,

     Thanx for your suggestion, I will cook a GFP_NOIO version for the 
memory allocation for pcache data path.

>
>
> Another comment:
> set_bit/clear_bit use atomic instructions which are slow. As you already
> hold a spinlock when calling them, you don't need the atomicity, so you
> can replace them with __set_bit and __clear_bit.


Good idea.


Thanx

Dongsheng

>
> Mikulas
>
