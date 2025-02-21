Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1851F4299
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740132588; cv=none; b=i2FPFBr8CGJMSelCUletX4KtMIfeUXwpn7r0s5xcELpGKI9fTSTDRRbP9ofS9+Y5LLPrYz/WYCG7bb9zaiDv5tFIcMO/67kXC3BdUuKPY/aGUv7rNf0HCh83bPDriYNcueXnCCuvA9ujJW2FTL+gn24CIxn42inae4PtHpYl6wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740132588; c=relaxed/simple;
	bh=R/MZ4BsEw9dwVYkG+8C466V/eObA8Si/8ee+G0kyi2U=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=R0ZCA1lJu7UdiXtOCWzidl3JGdk/J1y8PwiV/K2e9AKv1WRXDC+GVskPQVNxNOyEUX9RDPTo04EWJFEzHjOZpYTuB5ocPsQ6fOU29bwcxct1MPLgayp0Er8ANiKkjBbJO+bvjGjgTXF9LQw5yNHmQDNeZUJoBkm8UuySwbW0uwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yzm7m6Cy2z4f3jqP
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 18:09:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 395AA1A06DC
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 18:09:41 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu1_iULhnYxfmEQ--.9089S3;
	Fri, 21 Feb 2025 18:09:40 +0800 (CST)
Subject: Re: [PATCH 05/12] badblocks: return error if any badblock set fails
To: Coly Li <i@coly.li>, Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, colyli@kernel.org,
 dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, dlemoal@kernel.org, yanjun.zhu@linux.dev,
 kch@nvidia.com, hare@suse.de, zhengqixing@huawei.com,
 john.g.garry@oracle.com, geliang@kernel.org, xni@redhat.com, colyli@suse.de,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-6-zhengqixing@huaweicloud.com>
 <4qo5qliidycbjmauq22tqgv6nbw2dus2xlhg2qvfss7nawdr27@arztxmrwdhzb>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <272e37ea-886c-8a44-fd6b-96940a268906@huaweicloud.com>
Date: Fri, 21 Feb 2025 18:09:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <4qo5qliidycbjmauq22tqgv6nbw2dus2xlhg2qvfss7nawdr27@arztxmrwdhzb>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu1_iULhnYxfmEQ--.9089S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZrWkCF1rCw4kWw43ArWkJFb_yoWrGrW8pr
	ZxCasIkrWjgr13WF1UZ3WIqF1Fg34fJr4UG3yrJ340kryqgas3JF4kXw4YgFyjqr13C3Wv
	va15uFWrua4DCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJr
	UvcSsGvfC2KfnxnUUI43ZEXa7IU0bAw3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/21 17:52, Coly Li 写道:
> On Fri, Feb 21, 2025 at 04:11:02PM +0800, Zheng Qixing wrote:
>> From: Li Nan <linan122@huawei.com>
>>
>> _badblocks_set() returns success if at least one badblock is set
>> successfully, even if others fail. This can lead to data inconsistencies
>> in raid, where a failed badblock set should trigger the disk to be kicked
>> out to prevent future reads from failed write areas.
>>
>> _badblocks_set() should return error if any badblock set fails. Instead
>> of relying on 'rv', directly returning 'sectors' for clearer logic. If all
>> badblocks are successfully set, 'sectors' will be 0, otherwise it
>> indicates the number of badblocks that have not been set yet, thus
>> signaling failure.
>>
>> By the way, it can also fix an issue: when a newly set unack badblock is
>> included in an existing ack badblock, the setting will return an error.
>> ···
>>    echo "0 100" /sys/block/md0/md/dev-loop1/bad_blocks
>>    echo "0 100" /sys/block/md0/md/dev-loop1/unacknowledged_bad_blocks
>>    -bash: echo: write error: No space left on device
>> ```
>> After fix, it will return success.
>>
>> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   block/badblocks.c | 16 ++++------------
>>   1 file changed, 4 insertions(+), 12 deletions(-)
>>
> 
> NACK.   Such modification will break current API.

Take a look at current APIs:
- for raid, error should be returned, otherwise data may be corrupted.
- for nvdimm, there is only error message if fail, and it make sense as
well if any badblocks set failed:
         if (badblocks_set(bb, s, num, 1))
                 dev_info_once(bb->dev, "%s: failed for sector %llx\n",
                                 __func__, (u64) s);
- for null_blk, I think it's fine as well.

Hence I think it's fine to return error if any badblocks set failed.
There is no need to invent a new API and switch all callers to a new
API.

Thanks,
Kuai

> 
> Current API doesn’t handle partial success/fail condition, if any bad block range is set it should return true.
> 
> It is not about correct or wrong, just current fragile design. A new API is necessary to handle such thing. This is why I leave the return value as int other than bool.
> 
> Thanks.
> 
> Coly Li
> 
> 
>   
>> diff --git a/block/badblocks.c b/block/badblocks.c
>> index 1c8b8f65f6df..a953d2e9417f 100644
>> --- a/block/badblocks.c
>> +++ b/block/badblocks.c
>> @@ -843,7 +843,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>>   	struct badblocks_context bad;
>>   	int prev = -1, hint = -1;
>>   	unsigned long flags;
>> -	int rv = 0;
>>   	u64 *p;
>>   
>>   	if (bb->shift < 0)
>> @@ -873,10 +872,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>>   	bad.len = sectors;
>>   	len = 0;
>>   
>> -	if (badblocks_full(bb)) {
>> -		rv = 1;
>> +	if (badblocks_full(bb))
>>   		goto out;
>> -	}
>>   
>>   	if (badblocks_empty(bb)) {
>>   		len = insert_at(bb, 0, &bad);
>> @@ -916,10 +913,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>>   			int extra = 0;
>>   
>>   			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
>> -				if (extra > 0) {
>> -					rv = 1;
>> +				if (extra > 0)
>>   					goto out;
>> -				}
>>   
>>   				len = min_t(sector_t,
>>   					    BB_END(p[prev]) - s, sectors);
>> @@ -986,10 +981,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>>   
>>   	write_sequnlock_irqrestore(&bb->lock, flags);
>>   
>> -	if (!added)
>> -		rv = 1;
>> -
>> -	return rv;
>> +	return sectors;
>>   }
>>   
>>   /*
>> @@ -1353,7 +1345,7 @@ EXPORT_SYMBOL_GPL(badblocks_check);
>>    *
>>    * Return:
>>    *  0: success
>> - *  1: failed to set badblocks (out of space)
>> + *  other: failed to set badblocks (out of space)
>>    */
>>   int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>>   			int acknowledged)
>> -- 
>> 2.39.2
>>
> 

