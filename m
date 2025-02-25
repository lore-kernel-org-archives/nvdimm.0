Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0A5260A35
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740474904; cv=none; b=FlnEoqPEFEeBwQCqG5X0Nx7BaqCgIumPsnZkA4bUDKnx6GCTjJK+lpub6TZHDL1/LuM9BfBsqTUzdYMlnXyqwULcFvCJRYw8sTOh21e8TxCHdF8GoWfV3RCTef93scU0y8j323iyd5hD+IlQZGKU48C1MNz1ZMxWyMgtgvEIuPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740474904; c=relaxed/simple;
	bh=VweTxZD+mpHaLGE+OHVC/Csqi8x0/lUXXIvTXvC+g4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VRe/LRPImQ6qQy/IQM+Bwv8aU0JUoetSYpcJ90dbwkiMqN8vOlVZpPgRWpl5xZesAxkAsAk4Wbx9lM7goPgelNHa+gv5N4qkzSzrJnN0Caq7jxZUC9P/sSKxtZs+FYAOJIVM+wsV2Lzo8NEsgRSmP9XBSWUlR2oNj61M03Lw1Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z2Bkm616zz4f3jt4
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 17:14:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 523311A0E55
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 17:14:57 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP3 (Coremail) with SMTP id _Ch0CgAne8UQir1naVwhEw--.30950S3;
	Tue, 25 Feb 2025 17:14:57 +0800 (CST)
Message-ID: <e352650c-93b7-4f0e-ae40-3988644da39d@huaweicloud.com>
Date: Tue, 25 Feb 2025 17:14:56 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 06/12] badblocks: fix the using of MAX_BADBLOCKS
To: Zhu Yanjun <yanjun.zhu@linux.dev>,
 Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, yukuai3@huawei.com,
 dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, dlemoal@kernel.org, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-7-zhengqixing@huaweicloud.com>
 <f8ad5677-5fc9-468e-a888-8cd55c3a37d7@linux.dev>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <f8ad5677-5fc9-468e-a888-8cd55c3a37d7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAne8UQir1naVwhEw--.30950S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZryfKr47Wr47Jr48tr48tFb_yoW8CryxpF
	sYq3W5GrWUGr18Xa1UZF1Yqry8Ww1xJay8Wa1rXa4UCry5Jwn2qrZ7Xw4YgryUXr4xWF1v
	qF1Y9345Z34xCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBqb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E
	8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82
	IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
	0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMI
	IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI
	42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
	80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0xcTPUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/2/21 18:09, Zhu Yanjun 写道:
> 
> On 21.02.25 09:11, Zheng Qixing wrote:
>> From: Li Nan <linan122@huawei.com>
>>
>> The number of badblocks cannot exceed MAX_BADBLOCKS, but it should be
>> allowed to equal MAX_BADBLOCKS.
>>
>> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling 
>> code")
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   block/badblocks.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/badblocks.c b/block/badblocks.c
>> index a953d2e9417f..87267bae6836 100644
>> --- a/block/badblocks.c
>> +++ b/block/badblocks.c
>> @@ -700,7 +700,7 @@ static bool can_front_overwrite(struct badblocks *bb, 
>> int prev,
>>               *extra = 2;
>>       }
>> -    if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
>> +    if ((bb->count + (*extra)) > MAX_BADBLOCKS)
>>           return false;
> 
> 
> In this commit,
> 
> commit c3c6a86e9efc5da5964260c322fe07feca6df782
> Author: Coly Li <colyli@suse.de>
> Date:   Sat Aug 12 01:05:08 2023 +0800
> 
>      badblocks: add helper routines for badblock ranges handling
> 
>      This patch adds several helper routines to improve badblock ranges
>      handling. These helper routines will be used later in the improved
>      version of badblocks_set()/badblocks_clear()/badblocks_check().
> 
>      - Helpers prev_by_hint() and prev_badblocks() are used to find the bad
>        range from bad table which the searching range starts at or after.
> 
> The above is changed to MAX_BADBLOCKS. Thus, perhaps, the Fixes tag should 
> include the above commit?
> 
> Except that, I am fine with this commit.
> 
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> Zhu Yanjun
> 

Thank! I will bring this fix tag in v2.

-- 
Thanks,
Nan

