Received: from mail87.out.titan.email (mail87.out.titan.email [209.209.25.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB802080E4
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740136388; cv=none; b=JoR0UUqCpERWrlvUm0bcz6/n95ciZcBt5N9CKh8f8PJyzBh+WyOlT1SYXD4KncA3+huApJyyd8yO109MiIeBsCOtlp5RZ4KITrxktkvWRuvFILaOzhC01nUN043eBKpG7xowJ6AtvWINo0fcctxEGzGvf2oOBPKqfyo47Fx4gYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740136388; c=relaxed/simple;
	bh=h+QNlcvzViK8K5cAukfP4Zs7Gtz/aUhcVmZFanumUIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hM5JcliSfkZXUR+1XbMHmeHF3DQBkXUDm/CEWCYD0zSTK8qaqQIjDfdWsYwQlPyV0qJXqA9Z4svmfBsB/1lQ3TISzLP8KWbATbHemKxon3A3/UYGNrOH1qUjl50cJsrITX1Kmrf59FjlqZAiO4ueO6Kul4Cqpb4SBfKsai2rojc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=cv37/sX0; arc=none smtp.client-ip=209.209.25.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="cv37/sX0"
DKIM-Signature: a=rsa-sha256; bh=gl4dDbOYoZlZrKikvXfyyn1o/IWgBwKN4Igl8P+rNwA=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:subject:date:from:cc:message-id:in-reply-to:to:references:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1740134239; v=1;
	b=cv37/sX0g6tB4EFFSkuqj8uLyP4JogmXRz7gRfu426rRlAJKgMiaPL+gO0uu86ioiTqsmO9O
	pywXTAR0vmvhfy0hkyG4dQTpP8QSZtyLS/zHDCkRiE7w24Bb2i0IGUsWXniuXtrsQxtl/rpFfxO
	H9xqenUvticRn5+mfVyvUQqs=
Received: from studio.local (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 31BA4E01AE;
	Fri, 21 Feb 2025 10:37:09 +0000 (UTC)
Date: Fri, 21 Feb 2025 18:37:07 +0800
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, colyli@kernel.org, 
	yukuai3@huawei.com, dan.j.williams@intel.com, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, ira.weiny@intel.com, dlemoal@kernel.org, yanjun.zhu@linux.dev, 
	kch@nvidia.com, hare@suse.de, zhengqixing@huawei.com, john.g.garry@oracle.com, 
	geliang@kernel.org, xni@redhat.com, colyli@suse.de, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 12/12] badblocks: use sector_t instead of int to avoid
 truncation of badblocks length
Message-ID: <z6pwiqalhwvp5ov56folmxg3fv6ut2sxblwx5qwvvltgphop3a@bu7arwtc3rat>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-13-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221081109.734170-13-zhengqixing@huaweicloud.com>
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1740134239764907271.19601.5898338928718616590@prod-use1-smtp-out1004.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=bq22BFai c=1 sm=1 tr=0 ts=67b8575f
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
	a=j8_hKfAro-a2qkMN4hQA:9 a=QEXdDO2ut3YA:10

On Fri, Feb 21, 2025 at 04:11:09PM +0800, Zheng Qixing wrote:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> There is a truncation of badblocks length issue when set badblocks as
> follow:
> 
> echo "2055 4294967299" > bad_blocks
> cat bad_blocks
> 2055 3
> 
> Change 'sectors' argument type from 'int' to 'sector_t'.
> 
> This change avoids truncation of badblocks length for large sectors by
> replacing 'int' with 'sector_t' (u64), enabling proper handling of larger
> disk sizes and ensuring compatibility with 64-bit sector addressing.
> 
> Fixes: 9e0e252a048b ("badblocks: Add core badblock management code")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>

Looks good to me.

Acked-by: Coly Li <colyli@kernel.org>

Thanks.

> ---
>  block/badblocks.c             | 20 ++++++++------------
>  drivers/block/null_blk/main.c |  2 +-
>  drivers/md/md.h               |  6 +++---
>  drivers/md/raid1-10.c         |  2 +-
>  drivers/md/raid1.c            |  4 ++--
>  drivers/md/raid10.c           |  8 ++++----
>  drivers/nvdimm/nd.h           |  2 +-
>  drivers/nvdimm/pfn_devs.c     |  7 ++++---
>  drivers/nvdimm/pmem.c         |  2 +-
>  include/linux/badblocks.h     |  8 ++++----
>  10 files changed, 29 insertions(+), 32 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 8f057563488a..14e3be47d22d 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -836,7 +836,7 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
>  }
>  
>  /* Do exact work to set bad block range into the bad block table */
> -static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +static bool _badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
>  			   int acknowledged)
>  {
>  	int len = 0, added = 0;
> @@ -956,8 +956,6 @@ static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  	if (sectors > 0)
>  		goto re_insert;
>  
> -	WARN_ON(sectors < 0);
> -
>  	/*
>  	 * Check whether the following already set range can be
>  	 * merged. (prev < 0) condition is not handled here,
> @@ -1048,7 +1046,7 @@ static int front_splitting_clear(struct badblocks *bb, int prev,
>  }
>  
>  /* Do the exact work to clear bad block range from the bad block table */
> -static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +static bool _badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors)
>  {
>  	struct badblocks_context bad;
>  	int prev = -1, hint = -1;
> @@ -1171,8 +1169,6 @@ static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  	if (sectors > 0)
>  		goto re_clear;
>  
> -	WARN_ON(sectors < 0);
> -
>  	if (cleared) {
>  		badblocks_update_acked(bb);
>  		set_changed(bb);
> @@ -1187,8 +1183,8 @@ static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  }
>  
>  /* Do the exact work to check bad blocks range from the bad block table */
> -static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
> -			    sector_t *first_bad, int *bad_sectors)
> +static int _badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
> +			    sector_t *first_bad, sector_t *bad_sectors)
>  {
>  	int prev = -1, hint = -1, set = 0;
>  	struct badblocks_context bad;
> @@ -1298,8 +1294,8 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>   * -1: there are bad blocks which have not yet been acknowledged in metadata.
>   * plus the start/length of the first bad section we overlap.
>   */
> -int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
> -			sector_t *first_bad, int *bad_sectors)
> +int badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
> +			sector_t *first_bad, sector_t *bad_sectors)
>  {
>  	unsigned int seq;
>  	int rv;
> @@ -1340,7 +1336,7 @@ EXPORT_SYMBOL_GPL(badblocks_check);
>   *  true: success
>   *  false: failed to set badblocks (out of space)
>   */
> -bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +bool badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
>  		   int acknowledged)
>  {
>  	return _badblocks_set(bb, s, sectors, acknowledged);
> @@ -1361,7 +1357,7 @@ EXPORT_SYMBOL_GPL(badblocks_set);
>   *  true: success
>   *  false: failed to clear badblocks
>   */
> -bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +bool badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors)
>  {
>  	return _badblocks_clear(bb, s, sectors);
>  }
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index 623db72ad66b..6e7d80b6e92b 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1302,7 +1302,7 @@ static inline blk_status_t null_handle_badblocks(struct nullb_cmd *cmd,
>  {
>  	struct badblocks *bb = &cmd->nq->dev->badblocks;
>  	sector_t first_bad;
> -	int bad_sectors;
> +	sector_t bad_sectors;
>  
>  	if (badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
>  		return BLK_STS_IOERR;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 923a0ef51efe..6edc0f71b7d4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -266,8 +266,8 @@ enum flag_bits {
>  	Nonrot,			/* non-rotational device (SSD) */
>  };
>  
> -static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
> -			      sector_t *first_bad, int *bad_sectors)
> +static inline int is_badblock(struct md_rdev *rdev, sector_t s, sector_t sectors,
> +			      sector_t *first_bad, sector_t *bad_sectors)
>  {
>  	if (unlikely(rdev->badblocks.count)) {
>  		int rv = badblocks_check(&rdev->badblocks, rdev->data_offset + s,
> @@ -284,7 +284,7 @@ static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
>  				    int sectors)
>  {
>  	sector_t first_bad;
> -	int bad_sectors;
> +	sector_t bad_sectors;
>  
>  	return is_badblock(rdev, s, sectors, &first_bad, &bad_sectors);
>  }
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 4378d3250bd7..62b980b12f93 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -247,7 +247,7 @@ static inline int raid1_check_read_range(struct md_rdev *rdev,
>  					 sector_t this_sector, int *len)
>  {
>  	sector_t first_bad;
> -	int bad_sectors;
> +	sector_t bad_sectors;
>  
>  	/* no bad block overlap */
>  	if (!is_badblock(rdev, this_sector, *len, &first_bad, &bad_sectors))
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8beb8cccc6af..0b2839105857 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1537,7 +1537,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>  		atomic_inc(&rdev->nr_pending);
>  		if (test_bit(WriteErrorSeen, &rdev->flags)) {
>  			sector_t first_bad;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>  			int is_bad;
>  
>  			is_bad = is_badblock(rdev, r1_bio->sector, max_sectors,
> @@ -2886,7 +2886,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>  		} else {
>  			/* may need to read from here */
>  			sector_t first_bad = MaxSector;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>  
>  			if (is_badblock(rdev, sector_nr, good_sectors,
>  					&first_bad, &bad_sectors)) {
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 7ed933181712..a8664e29aada 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -747,7 +747,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
>  
>  	for (slot = 0; slot < conf->copies ; slot++) {
>  		sector_t first_bad;
> -		int bad_sectors;
> +		sector_t bad_sectors;
>  		sector_t dev_sector;
>  		unsigned int pending;
>  		bool nonrot;
> @@ -1438,7 +1438,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>  		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
>  			sector_t first_bad;
>  			sector_t dev_sector = r10_bio->devs[i].addr;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>  			int is_bad;
>  
>  			is_bad = is_badblock(rdev, dev_sector, max_sectors,
> @@ -3413,7 +3413,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>  				sector_t from_addr, to_addr;
>  				struct md_rdev *rdev = conf->mirrors[d].rdev;
>  				sector_t sector, first_bad;
> -				int bad_sectors;
> +				sector_t bad_sectors;
>  				if (!rdev ||
>  				    !test_bit(In_sync, &rdev->flags))
>  					continue;
> @@ -3609,7 +3609,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>  		for (i = 0; i < conf->copies; i++) {
>  			int d = r10_bio->devs[i].devnum;
>  			sector_t first_bad, sector;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>  			struct md_rdev *rdev;
>  
>  			if (r10_bio->devs[i].repl_bio)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 5ca06e9a2d29..cc5c8f3f81e8 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -673,7 +673,7 @@ static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
>  {
>  	if (bb->count) {
>  		sector_t first_bad;
> -		int num_bad;
> +		sector_t num_bad;
>  
>  		return !!badblocks_check(bb, sector, len / 512, &first_bad,
>  				&num_bad);
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index cfdfe0eaa512..8f3e816e805d 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -367,9 +367,10 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
>  	struct nd_namespace_common *ndns = nd_pfn->ndns;
>  	void *zero_page = page_address(ZERO_PAGE(0));
>  	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
> -	int num_bad, meta_num, rc, bb_present;
> +	int meta_num, rc, bb_present;
>  	sector_t first_bad, meta_start;
>  	struct nd_namespace_io *nsio;
> +	sector_t num_bad;
>  
>  	if (nd_pfn->mode != PFN_MODE_PMEM)
>  		return 0;
> @@ -394,7 +395,7 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
>  		bb_present = badblocks_check(&nd_region->bb, meta_start,
>  				meta_num, &first_bad, &num_bad);
>  		if (bb_present) {
> -			dev_dbg(&nd_pfn->dev, "meta: %x badblocks at %llx\n",
> +			dev_dbg(&nd_pfn->dev, "meta: %llx badblocks at %llx\n",
>  					num_bad, first_bad);
>  			nsoff = ALIGN_DOWN((nd_region->ndr_start
>  					+ (first_bad << 9)) - nsio->res.start,
> @@ -413,7 +414,7 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
>  			}
>  			if (rc) {
>  				dev_err(&nd_pfn->dev,
> -					"error clearing %x badblocks at %llx\n",
> +					"error clearing %llx badblocks at %llx\n",
>  					num_bad, first_bad);
>  				return rc;
>  			}
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index d81faa9d89c9..43156e1576c9 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -249,7 +249,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
>  	struct badblocks *bb = &pmem->bb;
>  	sector_t first_bad;
> -	int num_bad;
> +	sector_t num_bad;
>  
>  	if (kaddr)
>  		*kaddr = pmem->virt_addr + offset;
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 8764bed9ff16..996493917f36 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -48,11 +48,11 @@ struct badblocks_context {
>  	int		ack;
>  };
>  
> -int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
> -		   sector_t *first_bad, int *bad_sectors);
> -bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +int badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
> +		    sector_t *first_bad, sector_t *bad_sectors);
> +bool badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
>  		   int acknowledged);
> -bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
> +bool badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors);
>  void ack_all_badblocks(struct badblocks *bb);
>  ssize_t badblocks_show(struct badblocks *bb, char *page, int unack);
>  ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
> -- 
> 2.39.2
> 

-- 
Coly Li
