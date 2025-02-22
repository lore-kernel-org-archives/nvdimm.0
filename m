Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752F915853B
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 01:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186889; cv=none; b=FjZnqWpp70QdXlKJwi6J8mdwZJU+OsAZCHmGEFaw7cQbATA3m08ueMXUM6QNUFqt6dLCQFgIREaYo4oxKVRGgAF+wioH4J23VJMmZdV50C7HRp5jPTv7lTqVuzVrLwUyHe3A/UdG1b+uW7ERNks/TytCI0rNbnyeHb9dCKYIDL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186889; c=relaxed/simple;
	bh=eqPZ6056mpqgDCSmql5Bp0AsHGxhknXM6sqwdsk5ouc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PTMTFnYC54SetP7mlk4ipbFmqbv8fo8pE/ayxkJoM0auQWU67Bjq4pwXvEobuCYTmftiFAWnQSqYLLeBHoD1SlmGuQq8KD9Fquyv1p1JDOYjos2r+DoRGgEKCKx+xRMQcUKgy5wgfQdTslazqwJ0i8cKcI2uJtXC5WYQHJllnpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z08Cw10Q0z4f3kw2
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:14:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4085D1A06DC
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:14:43 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXe18BJblnfCciEg--.14485S3;
	Sat, 22 Feb 2025 09:14:43 +0800 (CST)
Subject: Re: [PATCH 07/12] badblocks: try can_merge_front before overlap_front
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-8-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d5dd72dd-41b4-ce66-6208-38ac6066acef@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:14:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-8-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe18BJblnfCciEg--.14485S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr1xXw4UXw4kJr13GFW5GFg_yoW8ur1rpr
	nFvF1akFZ7tw1xuwnxZ3ZFgryagr48GFsru3W7Jr1FkryIv3s3KFyIq3WftFyUXFZxAF4q
	qw1UuFyF9Fy8trJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8Jr
	UvcSsGvfC2KfnxnUUI43ZEXa7IU07PEDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/02/21 16:11, Zheng Qixing Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> Regardless of whether overlap_front() returns true or false,
> can_merge_front() will be executed first. Therefore, move
> can_merge_front() in front of can_merge_front() to simplify code.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   block/badblocks.c | 48 ++++++++++++++++++++++-------------------------
>   1 file changed, 22 insertions(+), 26 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/block/badblocks.c b/block/badblocks.c
> index 87267bae6836..bb46bab7e99f 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -905,39 +905,35 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   		goto update_sectors;
>   	}
>   
> +	if (can_merge_front(bb, prev, &bad)) {
> +		len = front_merge(bb, prev, &bad);
> +		added++;
> +		hint = prev;
> +		goto update_sectors;
> +	}
> +
>   	if (overlap_front(bb, prev, &bad)) {
> -		if (can_merge_front(bb, prev, &bad)) {
> -			len = front_merge(bb, prev, &bad);
> -			added++;
> -		} else {
> -			int extra = 0;
> +		int extra = 0;
>   
> -			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
> -				if (extra > 0)
> -					goto out;
> +		if (!can_front_overwrite(bb, prev, &bad, &extra)) {
> +			if (extra > 0)
> +				goto out;
>   
> -				len = min_t(sector_t,
> -					    BB_END(p[prev]) - s, sectors);
> -				hint = prev;
> -				goto update_sectors;
> -			}
> +			len = min_t(sector_t,
> +				    BB_END(p[prev]) - s, sectors);
> +			hint = prev;
> +			goto update_sectors;
> +		}
>   
> -			len = front_overwrite(bb, prev, &bad, extra);
> -			added++;
> -			bb->count += extra;
> +		len = front_overwrite(bb, prev, &bad, extra);
> +		added++;
> +		bb->count += extra;
>   
> -			if (can_combine_front(bb, prev, &bad)) {
> -				front_combine(bb, prev);
> -				bb->count--;
> -			}
> +		if (can_combine_front(bb, prev, &bad)) {
> +			front_combine(bb, prev);
> +			bb->count--;
>   		}
> -		hint = prev;
> -		goto update_sectors;
> -	}
>   
> -	if (can_merge_front(bb, prev, &bad)) {
> -		len = front_merge(bb, prev, &bad);
> -		added++;
>   		hint = prev;
>   		goto update_sectors;
>   	}
> 

