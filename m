Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0472045B7
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740131763; cv=none; b=r/1rAII2+7GKbIcRXawRNqFaeeDMIaxTgt1ICMOlxVPmonsLk3rw7oLPBShTQVbJWads4N4ZT/UJZ0Z544fAvE057HKWd7ec5EbcssmcywChtsuFHTErBrbkuDnIXEax46HtaBBOMDDSBvJfkAkgUgxqZ4oP+doxf0KZ374bIyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740131763; c=relaxed/simple;
	bh=iMhTZM9RD7dkASydbaapy9xytkW9I6XoB+H6TTA7/WM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AOGX4/3BLUu7RkZXlHwmyp49cm8m/Ej4NapIdJDV9su3UzXQHAGBCkRKXypsaN6xyU+uXoaHm+mPXaIkgdIikFPCFbk5ZaTd/wSbn0oveyxr0xzAXTU+msg8ceHADkxUhGASqcVnMdpqWfzu0nxi8tLhfaEQhiZVjw2qr+1QzTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yzlqp4yc7z4f3jYC
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:55:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5AF741A0F08
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:55:56 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl+pTbhn_CrlEQ--.5088S3;
	Fri, 21 Feb 2025 17:55:56 +0800 (CST)
Subject: Re: [PATCH 04/12] badblocks: return error directly when setting
 badblocks exceeds 512
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, Li Nan <linan122@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-5-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bec8776a-f0d4-2ec3-4455-9976ad87775e@huaweicloud.com>
Date: Fri, 21 Feb 2025 17:55:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-5-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3Gl+pTbhn_CrlEQ--.5088S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtw4UAr1DWFWkGFWDuw45KFg_yoW7Kw1kpF
	sxWwsa9FyDtr1rW3WDZa1DtryF934ftF4UC3y5Xw1FkFy0kwn2gF18Xr4SvFyj9rW3GrsY
	qa18uFyruFZ2g3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJr
	UvcSsGvfC2KfnxnUUI43ZEXa7IU0s2-5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

+CC Linan

在 2025/02/21 16:11, Zheng Qixing 写道:
> From: Li Nan <linan122@huawei.com>
> 
> In the current handling of badblocks settings, a lot of processing has
> been done for scenarios where the number of badblocks exceeds 512.
> This makes the code look quite complex and also introduces some issues,

It's better to add explanations about these issues here.
> 
> Fixing those issues wouldn’t be too complicated, but it wouldn’t
> simplify the code. In fact, a disk shouldn’t have too many badblocks,
> and for disks with 512 badblocks, attempting to set more bad blocks
> doesn’t make much sense. At that point, the more appropriate action
> would be to replace the disk. Therefore, to resolve these issues and
> simplify the code somewhat, return error directly when setting badblocks
> exceeds 512.
> 
> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   block/badblocks.c | 121 ++++++++--------------------------------------
>   1 file changed, 19 insertions(+), 102 deletions(-)
> 

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index ad8652fbe1c8..1c8b8f65f6df 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -527,51 +527,6 @@ static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
>   	return ret;
>   }
>   
> -/*
> - * Return 'true' if the range indicated by 'bad' can be backward merged
> - * with the bad range (from the bad table) index by 'behind'.
> - */
> -static bool can_merge_behind(struct badblocks *bb,
> -			     struct badblocks_context *bad, int behind)
> -{
> -	sector_t sectors = bad->len;
> -	sector_t s = bad->start;
> -	u64 *p = bb->page;
> -
> -	if ((s < BB_OFFSET(p[behind])) &&
> -	    ((s + sectors) >= BB_OFFSET(p[behind])) &&
> -	    ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
> -	    BB_ACK(p[behind]) == bad->ack)
> -		return true;
> -	return false;
> -}
> -
> -/*
> - * Do backward merge for range indicated by 'bad' and the bad range
> - * (from the bad table) indexed by 'behind'. The return value is merged
> - * sectors from bad->len.
> - */
> -static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
> -			int behind)
> -{
> -	sector_t sectors = bad->len;
> -	sector_t s = bad->start;
> -	u64 *p = bb->page;
> -	int merged = 0;
> -
> -	WARN_ON(s >= BB_OFFSET(p[behind]));
> -	WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
> -
> -	if (s < BB_OFFSET(p[behind])) {
> -		merged = BB_OFFSET(p[behind]) - s;
> -		p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad->ack);
> -
> -		WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
> -	}
> -
> -	return merged;
> -}
> -
>   /*
>    * Return 'true' if the range indicated by 'bad' can be forward
>    * merged with the bad range (from the bad table) indexed by 'prev'.
> @@ -884,11 +839,9 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
>   static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   			  int acknowledged)
>   {
> -	int retried = 0, space_desired = 0;
> -	int orig_len, len = 0, added = 0;
> +	int len = 0, added = 0;
>   	struct badblocks_context bad;
>   	int prev = -1, hint = -1;
> -	sector_t orig_start;
>   	unsigned long flags;
>   	int rv = 0;
>   	u64 *p;
> @@ -912,8 +865,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   
>   	write_seqlock_irqsave(&bb->lock, flags);
>   
> -	orig_start = s;
> -	orig_len = sectors;
>   	bad.ack = acknowledged;
>   	p = bb->page;
>   
> @@ -922,6 +873,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   	bad.len = sectors;
>   	len = 0;
>   
> +	if (badblocks_full(bb)) {
> +		rv = 1;
> +		goto out;
> +	}
> +
>   	if (badblocks_empty(bb)) {
>   		len = insert_at(bb, 0, &bad);
>   		bb->count++;
> @@ -933,32 +889,14 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   
>   	/* start before all badblocks */
>   	if (prev < 0) {
> -		if (!badblocks_full(bb)) {
> -			/* insert on the first */
> -			if (bad.len > (BB_OFFSET(p[0]) - bad.start))
> -				bad.len = BB_OFFSET(p[0]) - bad.start;
> -			len = insert_at(bb, 0, &bad);
> -			bb->count++;
> -			added++;
> -			hint = 0;
> -			goto update_sectors;
> -		}
> -
> -		/* No sapce, try to merge */
> -		if (overlap_behind(bb, &bad, 0)) {
> -			if (can_merge_behind(bb, &bad, 0)) {
> -				len = behind_merge(bb, &bad, 0);
> -				added++;
> -			} else {
> -				len = BB_OFFSET(p[0]) - s;
> -				space_desired = 1;
> -			}
> -			hint = 0;
> -			goto update_sectors;
> -		}
> -
> -		/* no table space and give up */
> -		goto out;
> +		/* insert on the first */
> +		if (bad.len > (BB_OFFSET(p[0]) - bad.start))
> +			bad.len = BB_OFFSET(p[0]) - bad.start;
> +		len = insert_at(bb, 0, &bad);
> +		bb->count++;
> +		added++;
> +		hint = 0;
> +		goto update_sectors;
>   	}
>   
>   	/* in case p[prev-1] can be merged with p[prev] */
> @@ -978,6 +916,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   			int extra = 0;
>   
>   			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
> +				if (extra > 0) {
> +					rv = 1;
> +					goto out;
> +				}
> +
>   				len = min_t(sector_t,
>   					    BB_END(p[prev]) - s, sectors);
>   				hint = prev;
> @@ -1004,24 +947,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   		goto update_sectors;
>   	}
>   
> -	/* if no space in table, still try to merge in the covered range */
> -	if (badblocks_full(bb)) {
> -		/* skip the cannot-merge range */
> -		if (((prev + 1) < bb->count) &&
> -		    overlap_behind(bb, &bad, prev + 1) &&
> -		    ((s + sectors) >= BB_END(p[prev + 1]))) {
> -			len = BB_END(p[prev + 1]) - s;
> -			hint = prev + 1;
> -			goto update_sectors;
> -		}
> -
> -		/* no retry any more */
> -		len = sectors;
> -		space_desired = 1;
> -		hint = -1;
> -		goto update_sectors;
> -	}
> -
>   	/* cannot merge and there is space in bad table */
>   	if ((prev + 1) < bb->count &&
>   	    overlap_behind(bb, &bad, prev + 1))
> @@ -1049,14 +974,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   	 */
>   	try_adjacent_combine(bb, prev);
>   
> -	if (space_desired && !badblocks_full(bb)) {
> -		s = orig_start;
> -		sectors = orig_len;
> -		space_desired = 0;
> -		if (retried++ < 3)
> -			goto re_insert;
> -	}
> -
>   out:
>   	if (added) {
>   		set_changed(bb);
> 

