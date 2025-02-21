Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B49920409F
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 09:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740128853; cv=none; b=DKD0R1RwvmU0pyQj4zPm3o71EDVS1hAocBpFPQblvzut1uVIBNwCx3mRNHSrnrD/obQyfclB8e1d6egKaViVzEAmUOgw0nadDQC9AkU5EkemrBE5zpOILfZnipbtvxggsF4Rj7411RjzLApO+iZpEeCGoPj0jtZ8kcKnyAlj2lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740128853; c=relaxed/simple;
	bh=+neqxwX4CL/sv7YarzkigmtgjKOZDE/nFmT4qUSQKXQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=e2chaEB7t2h3XzOOY2OHisFoGcr0l59iGVbvR1lMADp+wTrs8Qoq/lVgFo74K5osfMabpEtAMxTI31s9JcaRxym5EGn6DQQbr80Y3htXHIxYR8G6ST2ac26rvAvoYYs6/d0dgIMtYgI7+AHTt79aV5yHckDs4q/FQi3f6o+1szk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yzkly67Mmz4f3jqq
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:07:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 37B481A058E
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:07:27 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9NQrhnVePhEQ--.4246S3;
	Fri, 21 Feb 2025 17:07:26 +0800 (CST)
Subject: Re: [PATCH 02/12] badblocks: factor out a helper try_adjacent_combine
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
 <20250221081109.734170-3-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cfad3954-0572-1da8-38a3-85c8b1164371@huaweicloud.com>
Date: Fri, 21 Feb 2025 17:07:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-3-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl9NQrhnVePhEQ--.4246S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWrJr4rtr43Jw1xWw4rKrg_yoW8tw47pr
	n8Aw1avryxCr1I9a13XanFyr1rCw1xJr4jyF47Jw18GFy8tw1IgF4ktw13ZF9FvrWxJFna
	qr1UuFyv9FW8t37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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

ÔÚ 2025/02/21 16:10, Zheng Qixing Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> Factor out try_adjacent_combine(), and it will be used in the later patch.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   block/badblocks.c | 40 ++++++++++++++++++++++++++--------------
>   1 file changed, 26 insertions(+), 14 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index bcee057efc47..f069c93e986d 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -855,6 +855,31 @@ static void badblocks_update_acked(struct badblocks *bb)
>   		bb->unacked_exist = 0;
>   }
>   
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly backward
> + * overlapped with the bad range (from bad table) indexed by 'behind'.
> + */
> +static bool try_adjacent_combine(struct badblocks *bb, int prev)
> +{
> +	u64 *p = bb->page;
> +
> +	if (prev >= 0 && (prev + 1) < bb->count &&
> +	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
> +	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
> +	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
> +				  BB_ACK(p[prev]));
> +
> +		if ((prev + 2) < bb->count)
> +			memmove(p + prev + 1, p + prev + 2,
> +				(bb->count -  (prev + 2)) * 8);
> +		bb->count--;
> +		return true;
> +	}
> +	return false;
> +}
> +
>   /* Do exact work to set bad block range into the bad block table */
>   static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   			  int acknowledged)
> @@ -1022,20 +1047,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   	 * merged. (prev < 0) condition is not handled here,
>   	 * because it's already complicated enough.
>   	 */
> -	if (prev >= 0 &&
> -	    (prev + 1) < bb->count &&
> -	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
> -	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
> -	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
> -		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> -				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
> -				  BB_ACK(p[prev]));
> -
> -		if ((prev + 2) < bb->count)
> -			memmove(p + prev + 1, p + prev + 2,
> -				(bb->count -  (prev + 2)) * 8);
> -		bb->count--;
> -	}
> +	try_adjacent_combine(bb, prev);
>   
>   	if (space_desired && !badblocks_full(bb)) {
>   		s = orig_start;
> 

