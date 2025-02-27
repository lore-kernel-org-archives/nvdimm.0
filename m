Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBAB374F1
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 11:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740656901; cv=none; b=N2HK4zyESDtyoP8O5fhVQIl5m8BVW3T2P+PLVUf68SdZZfJJN/Mu2itt+sEByuuPRZ3yBxJ4b+yJ8sVHmjEk71dmD6XatDQnEzyBGig2JyCarnQ3I1ZYAk6tDSf3W2cmML9cGxw/YJ2b1LxmgEAuVicnEl33ieANjxm4GDhFgSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740656901; c=relaxed/simple;
	bh=mbwARO7SYwI4j7mnR1JVJpy9jpdNB2B3SO+uovp03XA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QHW+ZS2vgDR6sMD4UqlDbTlOgFlVMR7sb+BN8fNpZDqYMie/1LCokBLK5K4ClIZjebnrHcRdu9klStKJbbxpXh4zhcSaqNHxlUD7szlBp5I7BpIb2MRe7Wuey/GL1BSSWUBKYC+wUXyaBP+6ilrnOxSOmTj0vItXARJPBdo2js4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3V2W6VxQz4f3lDN
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 19:47:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3BF731A058E
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 19:48:11 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl_4UMBnlVUwFA--.34292S3;
	Thu, 27 Feb 2025 19:48:10 +0800 (CST)
Subject: Re: [PATCH V2 11/12] md: improve return types of badblocks handling
 functions
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, ira.weiny@intel.com, dlemoal@kernel.org,
 kch@nvidia.com, yanjun.zhu@linux.dev, hare@suse.de, zhengqixing@huawei.com,
 colyli@kernel.org, geliang@kernel.org, xni@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
 <20250227075507.151331-12-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <25cce813-7e4e-b82b-48fa-b0ff0b3f3bb2@huaweicloud.com>
Date: Thu, 27 Feb 2025 19:48:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250227075507.151331-12-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl_4UMBnlVUwFA--.34292S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Aw15uw4DZrW7GFyUXFy3XFb_yoW7Aryrp3
	yUJFyfJ3y0g34Fg3WUXrWDC3WF9w1fKFWIyrW3W34Ik3s7Kr95KF18XryYvFyvkF9xuF12
	q3W5WF4Duw1kWrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU92b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07jIksgUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/02/27 15:55, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> rdev_set_badblocks() only indicates success/failure, so convert its return
> type from int to boolean for better semantic clarity.
> 
> rdev_clear_badblocks() return value is never used by any caller, convert it
> to void. This removes unnecessary value returns.
> 
> Also update narrow_write_error() in both raid1 and raid10 to use boolean
> return type to match rdev_set_badblocks().
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c     | 19 +++++++++----------
>   drivers/md/md.h     |  8 ++++----
>   drivers/md/raid1.c  |  6 +++---
>   drivers/md/raid10.c |  6 +++---
>   4 files changed, 19 insertions(+), 20 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 49d826e475cb..9b9b2b4131d0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9841,9 +9841,9 @@ EXPORT_SYMBOL(md_finish_reshape);
>   
>   /* Bad block management */
>   
> -/* Returns 1 on success, 0 on failure */
> -int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> -		       int is_new)
> +/* Returns true on success, false on failure */
> +bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> +			int is_new)
>   {
>   	struct mddev *mddev = rdev->mddev;
>   
> @@ -9855,7 +9855,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>   	 * avoid it.
>   	 */
>   	if (test_bit(Faulty, &rdev->flags))
> -		return 1;
> +		return true;
>   
>   	if (is_new)
>   		s += rdev->new_data_offset;
> @@ -9863,7 +9863,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>   		s += rdev->data_offset;
>   
>   	if (!badblocks_set(&rdev->badblocks, s, sectors, 0))
> -		return 0;
> +		return false;
>   
>   	/* Make sure they get written out promptly */
>   	if (test_bit(ExternalBbl, &rdev->flags))
> @@ -9872,12 +9872,12 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>   	set_mask_bits(&mddev->sb_flags, 0,
>   		      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
>   	md_wakeup_thread(rdev->mddev->thread);
> -	return 1;
> +	return true;
>   }
>   EXPORT_SYMBOL_GPL(rdev_set_badblocks);
>   
> -int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> -			 int is_new)
> +void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> +			  int is_new)
>   {
>   	if (is_new)
>   		s += rdev->new_data_offset;
> @@ -9885,11 +9885,10 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>   		s += rdev->data_offset;
>   
>   	if (!badblocks_clear(&rdev->badblocks, s, sectors))
> -		return 0;
> +		return;
>   
>   	if (test_bit(ExternalBbl, &rdev->flags))
>   		sysfs_notify_dirent_safe(rdev->sysfs_badblocks);
> -	return 1;
>   }
>   EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>   
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index def808064ad8..923a0ef51efe 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -289,10 +289,10 @@ static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
>   	return is_badblock(rdev, s, sectors, &first_bad, &bad_sectors);
>   }
>   
> -extern int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> -			      int is_new);
> -extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> -				int is_new);
> +extern bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> +			       int is_new);
> +extern void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> +				 int is_new);
>   struct md_cluster_info;
>   
>   /**
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 10ea3af40991..8e9f303c5603 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2486,7 +2486,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   	}
>   }
>   
> -static int narrow_write_error(struct r1bio *r1_bio, int i)
> +static bool narrow_write_error(struct r1bio *r1_bio, int i)
>   {
>   	struct mddev *mddev = r1_bio->mddev;
>   	struct r1conf *conf = mddev->private;
> @@ -2507,10 +2507,10 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
>   	sector_t sector;
>   	int sectors;
>   	int sect_to_write = r1_bio->sectors;
> -	int ok = 1;
> +	bool ok = true;
>   
>   	if (rdev->badblocks.shift < 0)
> -		return 0;
> +		return false;
>   
>   	block_sectors = roundup(1 << rdev->badblocks.shift,
>   				bdev_logical_block_size(rdev->bdev) >> 9);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 15b9ae5bf84d..45faa34f0be8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2786,7 +2786,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>   	}
>   }
>   
> -static int narrow_write_error(struct r10bio *r10_bio, int i)
> +static bool narrow_write_error(struct r10bio *r10_bio, int i)
>   {
>   	struct bio *bio = r10_bio->master_bio;
>   	struct mddev *mddev = r10_bio->mddev;
> @@ -2807,10 +2807,10 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
>   	sector_t sector;
>   	int sectors;
>   	int sect_to_write = r10_bio->sectors;
> -	int ok = 1;
> +	bool ok = true;
>   
>   	if (rdev->badblocks.shift < 0)
> -		return 0;
> +		return false;
>   
>   	block_sectors = roundup(1 << rdev->badblocks.shift,
>   				bdev_logical_block_size(rdev->bdev) >> 9);
> 

