Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35FE2A1CF
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 01:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740187669; cv=none; b=UwvTqdoLDI/1eWBblOGAJIYGqEmC3BB8uChoLNr2AA8VJG3Vhd/KN+6qCI2yzWW6x+1k1MGup6QdbIwK112boHp2LNmTHb/jNLIV+Jkg09mF33onx+zC6EFwrtsgKyJJiBwhw+qb5tratHR56EZeggZiCKYOgvnrbxo9EusYPj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740187669; c=relaxed/simple;
	bh=ttX/OPTgmD9G/v/vzUV6LnCCU7BnFqI8g6nJVVBV6P8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FwJGXWsh8qQTrOMU2+gMBarVc1p4uANwz8m4utvJpP+8dgFedAMiejcoFVLQq3ZLGny5oUgrRE3+UpnZd8ffHe5pa6xgTmj5bo88AOpcAGi+3uYYqtoUvt6uy8YnxXYJ5QH9QOVC5qvVr4r6BFcuW3wi6lIZWNyTLEFpomilDvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z08Vy1hpkz4f3jM1
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:27:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E136A1A06DC
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:27:43 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2AOKLlnwQQjEg--.18037S3;
	Sat, 22 Feb 2025 09:27:43 +0800 (CST)
Subject: Re: [PATCH 11/12] md: improve return types of badblocks handling
 functions
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
 <20250221081109.734170-12-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <946b8ac3-cb35-89ef-e1b9-d5305d6e1ada@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:27:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-12-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2AOKLlnwQQjEg--.18037S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtw48XFy8Ww15JryxZw4ktFb_yoW7Aryxp3
	yUJFyfJw4jg34Fg3WUXrWDC3WF9w1fKFW2krW3Wa42k3s7Kr97KF48XryYvFyvkF9xuF12
	q3W5WF4Duw1vgrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9qb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F
	4UJbIYCTnIWIevJa73UjIFyTuYvjxUIoGQDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, one nit below

ÔÚ 2025/02/21 16:11, Zheng Qixing Ð´µÀ:
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
>   drivers/md/md.c     | 20 +++++++++-----------
>   drivers/md/md.h     |  8 ++++----
>   drivers/md/raid1.c  |  6 +++---
>   drivers/md/raid10.c |  6 +++---
>   4 files changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 49d826e475cb..76c437376542 100644
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
> @@ -9872,24 +9872,22 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
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
>   	else
>   		s += rdev->data_offset;
>   
> -	if (!badblocks_clear(&rdev->badblocks, s, sectors))
> -		return 0;
> +	badblocks_clear(&rdev->badblocks, s, sectors);

Plese don't make functional change, and this dones not make sense
to me.

Thanks,
Kuai

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
> index 9d57a88dbd26..8beb8cccc6af 100644
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
> index efe93b979167..7ed933181712 100644
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

