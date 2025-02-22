Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50F513C3F2;
	Sat, 22 Feb 2025 06:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740205245; cv=none; b=QjqiabJ7U1CWHr/FDb/3vSMRpRx9ycnUEZEnjzXiYcWJ324rJY6PKU2///4PQm85ueDXby05KCz3jKS1splCc4MVn0IUg2ZpUGpw1ywXA6lniYHfcXY9jkj6Fm/ZBKRiatWIkfcjIdCRTFppauTROoxBeSySknZ+KkThDLsQujE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740205245; c=relaxed/simple;
	bh=tPJoDWNJBIfjfz7qX2Ip9zxoOCbsFLTROfXKiRHuhlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQteooqOSxDuh1df0yRiz1eapqgjfbog+Mf7zvRefGnceVEdMCHN4IPu6GpR1cTiY0oXC0sFgVCPiM3Bxd0tmJ+haEBaffCE8H7hZFOpxA7bAR8vnTqmwMdYQE/qJmjxnHjeNcv0h2vNZKDgZnYzJiO7XhnjpyOrTTHBNWGf1ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWrJk+9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWrJk+9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2956C4CED1;
	Sat, 22 Feb 2025 06:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740205244;
	bh=tPJoDWNJBIfjfz7qX2Ip9zxoOCbsFLTROfXKiRHuhlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rWrJk+9Vuq8K/so9Tc8dR4CWgd6e/Cfj29a+ul5DslVa20UqAYZZ/P6lZ+1sOvij9
	 +BIIfzz8/jPoZNQa5xWmLMc3x4X5wUQsYZorMAFnOq0wSy7P0HzxoLROcfYRGMVL8a
	 UdbZcyYGbOMD5oqz4gaIZiZM3JDOwr1E1ijmSc/FwCZJ3X/r5QwcseWL9pgtJOnvA+
	 XEL/s/VgpwZTIMSkG5NiVyCWNH1icz2aI/ky+Rw+TlY4BfpAMi711xB8w1h6r/Cdgu
	 LE18eGD0/ZMWFgFkIZ0oIk5rwbkPKS+FGjqf1pdpbbX2PSw4ylzDE2b+xoYNXGgGfy
	 ojswzXJ2qyMgQ==
Date: Sat, 22 Feb 2025 14:20:35 +0800
From: Coly Li <colyli@kernel.org>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, 
	dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	ira.weiny@intel.com, dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, 
	hare@suse.de, zhengqixing@huawei.com, john.g.garry@oracle.com, 
	geliang@kernel.org, xni@redhat.com, colyli@suse.de, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 10/12] badblocks: return boolen from badblocks_set() and
 badblocks_clear()
Message-ID: <iqljnntndlnyyn6ghxts3nlyhgsq4jbxe7cnbqxofcvm6tjoib@zfznzosucen3>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-11-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221081109.734170-11-zhengqixing@huaweicloud.com>

On Fri, Feb 21, 2025 at 04:11:07PM +0800, Zheng Qixing wrote:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Change the return type of badblocks_set() and badblocks_clear()
> from int to bool, indicating success or failure. Specifically:
> 
> - _badblocks_set() and _badblocks_clear() functions now return
> true for success and false for failure.
> - All calls to these functions have been updated to handle the
> new boolean return type.
> - This change improves code clarity and ensures a more consistent
> handling of success and failure states.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>

For block/badblocks.c and include/linux/badblocks.h it is fine to me,

Acked-by: Coly Li <colyli@kernel.org>

Thanks.

> ---
>  block/badblocks.c             | 37 +++++++++++++++++------------------
>  drivers/block/null_blk/main.c | 17 ++++++++--------
>  drivers/md/md.c               | 35 +++++++++++++++++----------------
>  drivers/nvdimm/badrange.c     |  2 +-
>  include/linux/badblocks.h     |  6 +++---
>  5 files changed, 49 insertions(+), 48 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 79d91be468c4..8f057563488a 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -836,8 +836,8 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
>  }
>  
>  /* Do exact work to set bad block range into the bad block table */
> -static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> -			  int acknowledged)
> +static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +			   int acknowledged)
>  {
>  	int len = 0, added = 0;
>  	struct badblocks_context bad;
> @@ -847,11 +847,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  
>  	if (bb->shift < 0)
>  		/* badblocks are disabled */
> -		return 1;
> +		return false;
>  
>  	if (sectors == 0)
>  		/* Invalid sectors number */
> -		return 1;
> +		return false;
>  
>  	if (bb->shift) {
>  		/* round the start down, and the end up */
> @@ -977,7 +977,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  
>  	write_sequnlock_irqrestore(&bb->lock, flags);
>  
> -	return sectors;
> +	return sectors == 0;
>  }
>  
>  /*
> @@ -1048,21 +1048,20 @@ static int front_splitting_clear(struct badblocks *bb, int prev,
>  }
>  
>  /* Do the exact work to clear bad block range from the bad block table */
> -static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  {
>  	struct badblocks_context bad;
>  	int prev = -1, hint = -1;
>  	int len = 0, cleared = 0;
> -	int rv = 0;
>  	u64 *p;
>  
>  	if (bb->shift < 0)
>  		/* badblocks are disabled */
> -		return 1;
> +		return false;
>  
>  	if (sectors == 0)
>  		/* Invalid sectors number */
> -		return 1;
> +		return false;
>  
>  	if (bb->shift) {
>  		sector_t target;
> @@ -1182,9 +1181,9 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  	write_sequnlock_irq(&bb->lock);
>  
>  	if (!cleared)
> -		rv = 1;
> +		return false;
>  
> -	return rv;
> +	return true;
>  }
>  
>  /* Do the exact work to check bad blocks range from the bad block table */
> @@ -1338,11 +1337,11 @@ EXPORT_SYMBOL_GPL(badblocks_check);
>   * decide how best to handle it.
>   *
>   * Return:
> - *  0: success
> - *  other: failed to set badblocks (out of space)
> + *  true: success
> + *  false: failed to set badblocks (out of space)
>   */
> -int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> -			int acknowledged)
> +bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +		   int acknowledged)
>  {
>  	return _badblocks_set(bb, s, sectors, acknowledged);
>  }
> @@ -1359,10 +1358,10 @@ EXPORT_SYMBOL_GPL(badblocks_set);
>   * drop the remove request.
>   *
>   * Return:
> - *  0: success
> - *  1: failed to clear badblocks
> + *  true: success
> + *  false: failed to clear badblocks
>   */
> -int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  {
>  	return _badblocks_clear(bb, s, sectors);
>  }
> @@ -1484,7 +1483,7 @@ ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
>  		return -EINVAL;
>  	}
>  
> -	if (badblocks_set(bb, sector, length, !unack))
> +	if (!badblocks_set(bb, sector, length, !unack))
>  		return -ENOSPC;
>  	else
>  		return len;
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index d94ef37480bd..623db72ad66b 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -559,14 +559,15 @@ static ssize_t nullb_device_badblocks_store(struct config_item *item,
>  		goto out;
>  	/* enable badblocks */
>  	cmpxchg(&t_dev->badblocks.shift, -1, 0);
> -	if (buf[0] == '+')
> -		ret = badblocks_set(&t_dev->badblocks, start,
> -			end - start + 1, 1);
> -	else
> -		ret = badblocks_clear(&t_dev->badblocks, start,
> -			end - start + 1);
> -	if (ret == 0)
> -		ret = count;
> +	if (buf[0] == '+') {
> +		if (badblocks_set(&t_dev->badblocks, start,
> +				  end - start + 1, 1))
> +			ret = count;
> +	} else {
> +		if (badblocks_clear(&t_dev->badblocks, start,
> +				    end - start + 1))
> +			ret = count;
> +	}
>  out:
>  	kfree(orig);
>  	return ret;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 30b3dbbce2d2..49d826e475cb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1748,7 +1748,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>  			count <<= sb->bblog_shift;
>  			if (bb + 1 == 0)
>  				break;
> -			if (badblocks_set(&rdev->badblocks, sector, count, 1))
> +			if (!badblocks_set(&rdev->badblocks, sector, count, 1))
>  				return -EINVAL;
>  		}
>  	} else if (sb->bblog_offset != 0)
> @@ -9846,7 +9846,6 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>  		       int is_new)
>  {
>  	struct mddev *mddev = rdev->mddev;
> -	int rv;
>  
>  	/*
>  	 * Recording new badblocks for faulty rdev will force unnecessary
> @@ -9862,33 +9861,35 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>  		s += rdev->new_data_offset;
>  	else
>  		s += rdev->data_offset;
> -	rv = badblocks_set(&rdev->badblocks, s, sectors, 0);
> -	if (rv == 0) {
> -		/* Make sure they get written out promptly */
> -		if (test_bit(ExternalBbl, &rdev->flags))
> -			sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
> -		sysfs_notify_dirent_safe(rdev->sysfs_state);
> -		set_mask_bits(&mddev->sb_flags, 0,
> -			      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
> -		md_wakeup_thread(rdev->mddev->thread);
> -		return 1;
> -	} else
> +
> +	if (!badblocks_set(&rdev->badblocks, s, sectors, 0))
>  		return 0;
> +
> +	/* Make sure they get written out promptly */
> +	if (test_bit(ExternalBbl, &rdev->flags))
> +		sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
> +	sysfs_notify_dirent_safe(rdev->sysfs_state);
> +	set_mask_bits(&mddev->sb_flags, 0,
> +		      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
> +	md_wakeup_thread(rdev->mddev->thread);
> +	return 1;
>  }
>  EXPORT_SYMBOL_GPL(rdev_set_badblocks);
>  
>  int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>  			 int is_new)
>  {
> -	int rv;
>  	if (is_new)
>  		s += rdev->new_data_offset;
>  	else
>  		s += rdev->data_offset;
> -	rv = badblocks_clear(&rdev->badblocks, s, sectors);
> -	if ((rv == 0) && test_bit(ExternalBbl, &rdev->flags))
> +
> +	if (!badblocks_clear(&rdev->badblocks, s, sectors))
> +		return 0;
> +
> +	if (test_bit(ExternalBbl, &rdev->flags))
>  		sysfs_notify_dirent_safe(rdev->sysfs_badblocks);
> -	return rv;
> +	return 1;
>  }
>  EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>  
> diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
> index a002ea6fdd84..ee478ccde7c6 100644
> --- a/drivers/nvdimm/badrange.c
> +++ b/drivers/nvdimm/badrange.c
> @@ -167,7 +167,7 @@ static void set_badblock(struct badblocks *bb, sector_t s, int num)
>  	dev_dbg(bb->dev, "Found a bad range (0x%llx, 0x%llx)\n",
>  			(u64) s * 512, (u64) num * 512);
>  	/* this isn't an error as the hardware will still throw an exception */
> -	if (badblocks_set(bb, s, num, 1))
> +	if (!badblocks_set(bb, s, num, 1))
>  		dev_info_once(bb->dev, "%s: failed for sector %llx\n",
>  				__func__, (u64) s);
>  }
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 670f2dae692f..8764bed9ff16 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -50,9 +50,9 @@ struct badblocks_context {
>  
>  int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>  		   sector_t *first_bad, int *bad_sectors);
> -int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> -			int acknowledged);
> -int badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
> +bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +		   int acknowledged);
> +bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
>  void ack_all_badblocks(struct badblocks *bb);
>  ssize_t badblocks_show(struct badblocks *bb, char *page, int unack);
>  ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
> -- 
> 2.39.2
> 

-- 
Coly Li
