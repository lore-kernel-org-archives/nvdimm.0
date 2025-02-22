Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B19717C219
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 01:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740187697; cv=none; b=VoncTpKgUjkkCbiduINlqjVlwRRwsQm4THETHiX7TT6+f15C/nCD2uewHMwiTe498OKpOO5CB4nv2W9YVu1JAxdVHCetYf08RLvLjMVdkJGYVYzspJ0fuLYgROWqentrriz2KZDU8ghSuVoeorgNYyZ1QIVcYmJEFYk4dBVUlBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740187697; c=relaxed/simple;
	bh=U+Yn0Nyw3mxowaK3DIXYm0z6+HnxloXRIUfmDrv7czA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hNJQZCfZBYbnr+H8A4dG0s4ilZA0KfXtjd0Xps7OmRQU/MHowiL977u/LElq0CV3VbE2yUF7MrMvBtk8426x1zN5cSIaXWnqtdWC/0A1DnID3Lmx0i4OxV/pIYXrgfg7zU4oqSDqgFestW6p1qiuMjXP5REBKw2s5L95HykGeCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z08WV2tFSz4f3js0
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:27:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 19EE21A092F
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:28:12 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH618qKLlnsgwjEg--.14050S3;
	Sat, 22 Feb 2025 09:28:11 +0800 (CST)
Subject: Re: [PATCH 09/12] badblocks: fix missing bad blocks on retry in
 _badblocks_check()
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
 <20250221081109.734170-10-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <55469db7-f93d-d174-ec8c-47e7e9b3b001@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:28:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-10-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH618qKLlnsgwjEg--.14050S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr45uryfCFy8AF48tw4Dtwb_yoW5WFWfpF
	sxG3sagryjgr10g3W5Za1qgr1F934fJF47X3yxGa4rGry8Kwn3tFykWr1rZFyj9rW3Gr1q
	va1S9rW3ur9rG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9qb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JF
	I_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F
	4UJbIYCTnIWIevJa73UjIFyTuYvjxUIoGQDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/02/21 16:11, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> The bad blocks check would miss bad blocks when retrying under contention,
> as checking parameters are not reset. These stale values from the previous
> attempt could lead to incorrect scanning in the subsequent retry.
> 
> Move seqlock to outer function and reinitialize checking state for each
> retry. This ensures a clean state for each check attempt, preventing any
> missed bad blocks.
> 
> Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   block/badblocks.c | 50 +++++++++++++++++++++++------------------------
>   1 file changed, 24 insertions(+), 26 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/block/badblocks.c b/block/badblocks.c
> index 381f9db423d6..79d91be468c4 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -1191,31 +1191,12 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>   static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>   			    sector_t *first_bad, int *bad_sectors)
>   {
> -	int unacked_badblocks, acked_badblocks;
>   	int prev = -1, hint = -1, set = 0;
>   	struct badblocks_context bad;
> -	unsigned int seq;
> +	int unacked_badblocks = 0;
> +	int acked_badblocks = 0;
> +	u64 *p = bb->page;
>   	int len, rv;
> -	u64 *p;
> -
> -	WARN_ON(bb->shift < 0 || sectors == 0);
> -
> -	if (bb->shift > 0) {
> -		sector_t target;
> -
> -		/* round the start down, and the end up */
> -		target = s + sectors;
> -		rounddown(s, 1 << bb->shift);
> -		roundup(target, 1 << bb->shift);
> -		sectors = target - s;
> -	}
> -
> -retry:
> -	seq = read_seqbegin(&bb->lock);
> -
> -	p = bb->page;
> -	unacked_badblocks = 0;
> -	acked_badblocks = 0;
>   
>   re_check:
>   	bad.start = s;
> @@ -1281,9 +1262,6 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>   	else
>   		rv = 0;
>   
> -	if (read_seqretry(&bb->lock, seq))
> -		goto retry;
> -
>   	return rv;
>   }
>   
> @@ -1324,7 +1302,27 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>   int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>   			sector_t *first_bad, int *bad_sectors)
>   {
> -	return _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
> +	unsigned int seq;
> +	int rv;
> +
> +	WARN_ON(bb->shift < 0 || sectors == 0);
> +
> +	if (bb->shift > 0) {
> +		/* round the start down, and the end up */
> +		sector_t target = s + sectors;
> +
> +		rounddown(s, 1 << bb->shift);
> +		roundup(target, 1 << bb->shift);
> +		sectors = target - s;
> +	}
> +
> +retry:
> +	seq = read_seqbegin(&bb->lock);
> +	rv = _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
> +	if (read_seqretry(&bb->lock, seq))
> +		goto retry;
> +
> +	return rv;
>   }
>   EXPORT_SYMBOL_GPL(badblocks_check);
>   
> 

