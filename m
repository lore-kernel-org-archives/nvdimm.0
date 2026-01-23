Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70442D7813;
	Fri, 23 Jan 2026 00:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769126835; cv=none; b=nhWrBJg2WPuDJF3h6LhzJsedrH3JJQCknDolBDkhD+tH32vBpKI2eIqB1X3OBqXrfXhzhYbIOhIG0V/d0x/tIjSq6/suX9dw6qcWn9RSMk1GZBnAV2yTqllRz652mi6gpwtCEqCkITphE5CrhjKw1b9uR4M0fLpm/uK8Ut69qGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769126835; c=relaxed/simple;
	bh=IpqJGT7/Nk5YCde3rvAV4j4PPadzqrvP75iI9XeLOhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sn5qQBCWwLr3nePrIbrXRTQvPeLiq4tzN8jaQlU1c8nqIPSV/RRnAdHCRvHOSWWJGNexsb/2beLLxNb2d90Yd+7h2TlEybjVnKVrvsMTmyEyGzgtPpQTo2hN809crm7z42XvxTwTiCj4xCg0JVAvKHYmnmqQ2uJhO5V6NsDwbPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nihmBDdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nihmBDdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E68C116C6;
	Fri, 23 Jan 2026 00:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769126835;
	bh=IpqJGT7/Nk5YCde3rvAV4j4PPadzqrvP75iI9XeLOhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nihmBDdjVLeiZ+bweoGzlTvJFs9GvlqxQDXSg0qisBdyV1Mh/efDBpoj713jb9AxP
	 U9/+Dra9unlY359+UyIrGReXSGSu7hWRwPC8m6+a8qyk8th0JuB4/GKv2TV7cg0+aW
	 Y0B6KoVCnbfuKYiMVv7LWPGDjSZz5Y3cKigIf3cROgjnPyEsP10r/cGW7ABVbGiK77
	 F3/lchp6ZrEf1iKeQjUWWblVrYP/YA1Ls81dwOTb8CCCY2vZCYnWEYiRuxr1PTEj+y
	 0zAR+CUawVZUVYH+u0VJZmIn0G/vEv9+qbPN9b9PcyPKRhEOk5pNurfd1Hm7zPRHnm
	 Cy0Wel/JSzm3w==
Date: Thu, 22 Jan 2026 16:07:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/15] block: add a bdev_has_integrity_csum helper
Message-ID: <20260123000714.GH5945@frogsfrogsfrogs>
References: <20260121064339.206019-1-hch@lst.de>
 <20260121064339.206019-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121064339.206019-4-hch@lst.de>

On Wed, Jan 21, 2026 at 07:43:11AM +0100, Christoph Hellwig wrote:
> Factor out a helper to see if the block device has an integrity checksum
> from bdev_stable_writes so that it can be reused for other checks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks like a straightforward splitting of responsibilities, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/linux/blkdev.h | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 438c4946b6e5..c1f3e6bcc217 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1472,14 +1472,18 @@ static inline bool bdev_synchronous(struct block_device *bdev)
>  	return bdev->bd_disk->queue->limits.features & BLK_FEAT_SYNCHRONOUS;
>  }
>  
> -static inline bool bdev_stable_writes(struct block_device *bdev)
> +static inline bool bdev_has_integrity_csum(struct block_device *bdev)
>  {
> -	struct request_queue *q = bdev_get_queue(bdev);
> +	struct queue_limits *lim = bdev_limits(bdev);
>  
> -	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
> -	    q->limits.integrity.csum_type != BLK_INTEGRITY_CSUM_NONE)
> -		return true;
> -	return q->limits.features & BLK_FEAT_STABLE_WRITES;
> +	return IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
> +		lim->integrity.csum_type != BLK_INTEGRITY_CSUM_NONE;
> +}
> +
> +static inline bool bdev_stable_writes(struct block_device *bdev)
> +{
> +	return bdev_has_integrity_csum(bdev) ||
> +		(bdev_limits(bdev)->features & BLK_FEAT_STABLE_WRITES);
>  }
>  
>  static inline bool blk_queue_write_cache(struct request_queue *q)
> -- 
> 2.47.3
> 
> 
