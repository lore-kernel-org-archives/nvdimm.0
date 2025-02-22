Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757EB13C3F2;
	Sat, 22 Feb 2025 06:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740205121; cv=none; b=C4/joXyKRMVqgwvuP23H3aW3R9MzhQSQ3+hrODTkkjap2OIjpLAVxvA3WiHSB74SI5TwRPQhWtGLXyW+QfntHGND3Xw7dl8X5vBlZFQ8VPqGdgm9BM6Utt5XYJP/Tk2zpJ93CLRJoJ/JsMb4MTYL/OrXBQvYSMMxMq+x+1UTlH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740205121; c=relaxed/simple;
	bh=9pNOHUueNR5qB5NFqRVnoHXuEU2rqpO9TBNV6b1KuBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NeAJ8ntr8PEmRXTz1HR10DFL5BVtD1BrgP2axeGnAHxwAFjAxzYYLtTbCHHTc8253nhyJI4kAqUETrOKH9uHP0rPeadH1oaKa+8PTBQiOUXzMUwIpt8I5geUx0Y05/cEJXGIU4xVLZNeanWTl5gPUog+WJDnlKM8RtgdvQ5VCHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDK7D6d+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDK7D6d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72833C4CED1;
	Sat, 22 Feb 2025 06:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740205120;
	bh=9pNOHUueNR5qB5NFqRVnoHXuEU2rqpO9TBNV6b1KuBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EDK7D6d+fteD1qGi51D8S9BAAP8azKnr6xuOwo22FEb9nrxxF2tS5KMuOq1Z4zih2
	 vsWU+XVdCfqrVidIKh9H4x4zc5B0GuCuF7ZkohnTBn7Rh8OU4kYuYRyZo/d/Vmr7NE
	 MMo58Imgrgyv0B2juWwsxWqvjIAbzsnmeJZiu48QKxGnVQEMMkY83hx/YBEi4zTZz4
	 ASoFUm1uZq5bq5xTtvQy3XKUQkV/poMWbqRqL+cc5ELYNiMavM1LyPNWcU9nhiSHf2
	 WsX+Wp567uxb81FZ9ZwooWX4vTkBvQULCTWgYpM27gT592zz252WE0YhgqxLoAB+Vc
	 Qq/YZVfNGrdTA==
Date: Sat, 22 Feb 2025 14:18:30 +0800
From: Coly Li <colyli@kernel.org>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, 
	dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	ira.weiny@intel.com, dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, 
	hare@suse.de, zhengqixing@huawei.com, john.g.garry@oracle.com, 
	geliang@kernel.org, xni@redhat.com, colyli@suse.de, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 05/12] badblocks: return error if any badblock set fails
Message-ID: <jqynkjjt3gtdyh7k4sgxr6nhirkpn465w5nena77uq4ql6ujn4@5p2y42hiptyg>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-6-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250221081109.734170-6-zhengqixing@huaweicloud.com>

On Fri, Feb 21, 2025 at 04:11:02PM +0800, Zheng Qixing wrote:
> From: Li Nan <linan122@huawei.com>
> 
> _badblocks_set() returns success if at least one badblock is set
> successfully, even if others fail. This can lead to data inconsistencies
> in raid, where a failed badblock set should trigger the disk to be kicked
> out to prevent future reads from failed write areas.
> 
> _badblocks_set() should return error if any badblock set fails. Instead
> of relying on 'rv', directly returning 'sectors' for clearer logic. If all
> badblocks are successfully set, 'sectors' will be 0, otherwise it
> indicates the number of badblocks that have not been set yet, thus
> signaling failure.
> 
> By the way, it can also fix an issue: when a newly set unack badblock is
> included in an existing ack badblock, the setting will return an error.
> ···
>   echo "0 100" /sys/block/md0/md/dev-loop1/bad_blocks
>   echo "0 100" /sys/block/md0/md/dev-loop1/unacknowledged_bad_blocks
>   -bash: echo: write error: No space left on device
> ```
> After fix, it will return success.
> 
> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
> Signed-off-by: Li Nan <linan122@huawei.com>

Based on Kuai's reply that we dont handle partial set and treat it as failure,
I am fine with this patch.

It will be good to add comment to explain that the parital set condition will be
treated as failure.

Acked-by: Coly Li <colyli@kernel.org>

Thanks.


> ---
>  block/badblocks.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 1c8b8f65f6df..a953d2e9417f 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -843,7 +843,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  	struct badblocks_context bad;
>  	int prev = -1, hint = -1;
>  	unsigned long flags;
> -	int rv = 0;
>  	u64 *p;
>  
>  	if (bb->shift < 0)
> @@ -873,10 +872,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  	bad.len = sectors;
>  	len = 0;
>  
> -	if (badblocks_full(bb)) {
> -		rv = 1;
> +	if (badblocks_full(bb))
>  		goto out;
> -	}
>  
>  	if (badblocks_empty(bb)) {
>  		len = insert_at(bb, 0, &bad);
> @@ -916,10 +913,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  			int extra = 0;
>  
>  			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
> -				if (extra > 0) {
> -					rv = 1;
> +				if (extra > 0)
>  					goto out;
> -				}
>  
>  				len = min_t(sector_t,
>  					    BB_END(p[prev]) - s, sectors);
> @@ -986,10 +981,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  
>  	write_sequnlock_irqrestore(&bb->lock, flags);
>  
> -	if (!added)
> -		rv = 1;
> -
> -	return rv;
> +	return sectors;
>  }
>  
>  /*
> @@ -1353,7 +1345,7 @@ EXPORT_SYMBOL_GPL(badblocks_check);
>   *
>   * Return:
>   *  0: success
> - *  1: failed to set badblocks (out of space)
> + *  other: failed to set badblocks (out of space)
>   */
>  int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  			int acknowledged)
> -- 
> 2.39.2
> 

-- 
Coly Li
