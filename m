Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53021DFDA1
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188634; cv=none; b=GBkvw13ucpiNPtFW8MC9zNNzdWUeg5h0AUhZZiP1tLScB6e1EINfJEktEwuL8fCanv0mqMj/gu/i5Ww7KMi6JIyIi6BAiUQm9Xv5IXZ31Wk+9qJf+hkNqZYaPcNDIu4HpI1csDxuFtvOFdU++NrnqgdLJPCe15gVq4E6P7FTdOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188634; c=relaxed/simple;
	bh=VWc+giNU0hRQ4gfPjhz8oaNz8blMvEj95HURSnl/VTg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=u8NYxDxJFOM5TA/6Ayp4nHcaY2AJkGLdJ7+D4iu2TsWsufInPKVBKnIJCGa789MH0qYpSeHnt5cGgq4xYkTy2Io7p6AUCf/swW+WCt19cZ5YewSQPsOv4WPewKNqoHV7VUN2vmTB3Tl+mUZoPO/rRzhf/8quzQmRpM6MMzvoCJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z08sT0XgLz4f3js7
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:43:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C1CB11A1020
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:43:46 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH61_QK7lnBhkkEg--.14192S3;
	Sat, 22 Feb 2025 09:43:46 +0800 (CST)
Subject: Re: [PATCH 12/12] badblocks: use sector_t instead of int to avoid
 truncation of badblocks length
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
 <20250221081109.734170-13-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f013c2e1-adc0-9a09-67b3-e07f89f936e7@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:43:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-13-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH61_QK7lnBhkkEg--.14192S3
X-Coremail-Antispam: 1UD129KBjvJXoWfJr1Uur1ftFy8Gr48JFyDGFg_yoWkuw1Upa
	1DJa4ftryUWF1rW3WUZayq9r1F934ftFWUKrWUW345WF97K3s7tF1kXFyYqFyq9F13Grn0
	va1Y9rW3ua4kKrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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

ÔÚ 2025/02/21 16:11, Zheng Qixing Ð´µÀ:
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
> ---
>   block/badblocks.c             | 20 ++++++++------------
>   drivers/block/null_blk/main.c |  2 +-
>   drivers/md/md.h               |  6 +++---
>   drivers/md/raid1-10.c         |  2 +-
>   drivers/md/raid1.c            |  4 ++--
>   drivers/md/raid10.c           |  8 ++++----
>   drivers/nvdimm/nd.h           |  2 +-
>   drivers/nvdimm/pfn_devs.c     |  7 ++++---
>   drivers/nvdimm/pmem.c         |  2 +-
>   include/linux/badblocks.h     |  8 ++++----
>   10 files changed, 29 insertions(+), 32 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 8f057563488a..14e3be47d22d 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -836,7 +836,7 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
>   }
>   
>   /* Do exact work to set bad block range into the bad block table */
> -static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +static bool _badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
>   			   int acknowledged)
>   {
>   	int len = 0, added = 0;
> @@ -956,8 +956,6 @@ static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   	if (sectors > 0)
>   		goto re_insert;
>   
> -	WARN_ON(sectors < 0);
> -
>   	/*
>   	 * Check whether the following already set range can be
>   	 * merged. (prev < 0) condition is not handled here,
> @@ -1048,7 +1046,7 @@ static int front_splitting_clear(struct badblocks *bb, int prev,
>   }
>   
>   /* Do the exact work to clear bad block range from the bad block table */
> -static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +static bool _badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors)
>   {
>   	struct badblocks_context bad;
>   	int prev = -1, hint = -1;
> @@ -1171,8 +1169,6 @@ static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>   	if (sectors > 0)
>   		goto re_clear;
>   
> -	WARN_ON(sectors < 0);
> -
>   	if (cleared) {
>   		badblocks_update_acked(bb);
>   		set_changed(bb);
> @@ -1187,8 +1183,8 @@ static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>   }
>   
>   /* Do the exact work to check bad blocks range from the bad block table */
> -static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
> -			    sector_t *first_bad, int *bad_sectors)
> +static int _badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
> +			    sector_t *first_bad, sector_t *bad_sectors)
>   {
>   	int prev = -1, hint = -1, set = 0;
>   	struct badblocks_context bad;
> @@ -1298,8 +1294,8 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>    * -1: there are bad blocks which have not yet been acknowledged in metadata.
>    * plus the start/length of the first bad section we overlap.
>    */
> -int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
> -			sector_t *first_bad, int *bad_sectors)
> +int badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
> +			sector_t *first_bad, sector_t *bad_sectors)
>   {
>   	unsigned int seq;
>   	int rv;
> @@ -1340,7 +1336,7 @@ EXPORT_SYMBOL_GPL(badblocks_check);
>    *  true: success
>    *  false: failed to set badblocks (out of space)
>    */
> -bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +bool badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
>   		   int acknowledged)
>   {
>   	return _badblocks_set(bb, s, sectors, acknowledged);
> @@ -1361,7 +1357,7 @@ EXPORT_SYMBOL_GPL(badblocks_set);
>    *  true: success
>    *  false: failed to clear badblocks
>    */
> -bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +bool badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors)
>   {
>   	return _badblocks_clear(bb, s, sectors);
>   }
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index 623db72ad66b..6e7d80b6e92b 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1302,7 +1302,7 @@ static inline blk_status_t null_handle_badblocks(struct nullb_cmd *cmd,
>   {
>   	struct badblocks *bb = &cmd->nq->dev->badblocks;
>   	sector_t first_bad;
> -	int bad_sectors;
> +	sector_t bad_sectors;
>   
>   	if (badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
>   		return BLK_STS_IOERR;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 923a0ef51efe..6edc0f71b7d4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -266,8 +266,8 @@ enum flag_bits {
>   	Nonrot,			/* non-rotational device (SSD) */
>   };
>   
> -static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
> -			      sector_t *first_bad, int *bad_sectors)
> +static inline int is_badblock(struct md_rdev *rdev, sector_t s, sector_t sectors,
> +			      sector_t *first_bad, sector_t *bad_sectors)
>   {
>   	if (unlikely(rdev->badblocks.count)) {
>   		int rv = badblocks_check(&rdev->badblocks, rdev->data_offset + s,
> @@ -284,7 +284,7 @@ static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
>   				    int sectors)
>   {
>   	sector_t first_bad;
> -	int bad_sectors;
> +	sector_t bad_sectors;
>   
>   	return is_badblock(rdev, s, sectors, &first_bad, &bad_sectors);
>   }
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 4378d3250bd7..62b980b12f93 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -247,7 +247,7 @@ static inline int raid1_check_read_range(struct md_rdev *rdev,
>   					 sector_t this_sector, int *len)
>   {
>   	sector_t first_bad;
> -	int bad_sectors;
> +	sector_t bad_sectors;
>   
>   	/* no bad block overlap */
>   	if (!is_badblock(rdev, this_sector, *len, &first_bad, &bad_sectors))
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8beb8cccc6af..0b2839105857 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1537,7 +1537,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		atomic_inc(&rdev->nr_pending);
>   		if (test_bit(WriteErrorSeen, &rdev->flags)) {
>   			sector_t first_bad;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>   			int is_bad;
>   
>   			is_bad = is_badblock(rdev, r1_bio->sector, max_sectors,
> @@ -2886,7 +2886,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   		} else {
>   			/* may need to read from here */
>   			sector_t first_bad = MaxSector;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>   
>   			if (is_badblock(rdev, sector_nr, good_sectors,
>   					&first_bad, &bad_sectors)) {
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 7ed933181712..a8664e29aada 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -747,7 +747,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
>   
>   	for (slot = 0; slot < conf->copies ; slot++) {
>   		sector_t first_bad;
> -		int bad_sectors;
> +		sector_t bad_sectors;
>   		sector_t dev_sector;
>   		unsigned int pending;
>   		bool nonrot;
> @@ -1438,7 +1438,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
>   			sector_t first_bad;
>   			sector_t dev_sector = r10_bio->devs[i].addr;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>   			int is_bad;
>   
>   			is_bad = is_badblock(rdev, dev_sector, max_sectors,
> @@ -3413,7 +3413,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>   				sector_t from_addr, to_addr;
>   				struct md_rdev *rdev = conf->mirrors[d].rdev;
>   				sector_t sector, first_bad;
> -				int bad_sectors;
> +				sector_t bad_sectors;
>   				if (!rdev ||
>   				    !test_bit(In_sync, &rdev->flags))
>   					continue;
> @@ -3609,7 +3609,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>   		for (i = 0; i < conf->copies; i++) {
>   			int d = r10_bio->devs[i].devnum;
>   			sector_t first_bad, sector;
> -			int bad_sectors;
> +			sector_t bad_sectors;
>   			struct md_rdev *rdev;
>   
>   			if (r10_bio->devs[i].repl_bio)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 5ca06e9a2d29..cc5c8f3f81e8 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -673,7 +673,7 @@ static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
>   {
>   	if (bb->count) {
>   		sector_t first_bad;
> -		int num_bad;
> +		sector_t num_bad;
>   
>   		return !!badblocks_check(bb, sector, len / 512, &first_bad,
>   				&num_bad);
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index cfdfe0eaa512..8f3e816e805d 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -367,9 +367,10 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
>   	struct nd_namespace_common *ndns = nd_pfn->ndns;
>   	void *zero_page = page_address(ZERO_PAGE(0));
>   	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
> -	int num_bad, meta_num, rc, bb_present;
> +	int meta_num, rc, bb_present;
>   	sector_t first_bad, meta_start;
>   	struct nd_namespace_io *nsio;
> +	sector_t num_bad;
>   
>   	if (nd_pfn->mode != PFN_MODE_PMEM)
>   		return 0;
> @@ -394,7 +395,7 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
>   		bb_present = badblocks_check(&nd_region->bb, meta_start,
>   				meta_num, &first_bad, &num_bad);
>   		if (bb_present) {
> -			dev_dbg(&nd_pfn->dev, "meta: %x badblocks at %llx\n",
> +			dev_dbg(&nd_pfn->dev, "meta: %llx badblocks at %llx\n",
>   					num_bad, first_bad);
>   			nsoff = ALIGN_DOWN((nd_region->ndr_start
>   					+ (first_bad << 9)) - nsio->res.start,
> @@ -413,7 +414,7 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
>   			}
>   			if (rc) {
>   				dev_err(&nd_pfn->dev,
> -					"error clearing %x badblocks at %llx\n",
> +					"error clearing %llx badblocks at %llx\n",
>   					num_bad, first_bad);
>   				return rc;
>   			}
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index d81faa9d89c9..43156e1576c9 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -249,7 +249,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>   	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
>   	struct badblocks *bb = &pmem->bb;
>   	sector_t first_bad;
> -	int num_bad;
> +	sector_t num_bad;
>   
>   	if (kaddr)
>   		*kaddr = pmem->virt_addr + offset;
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 8764bed9ff16..996493917f36 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -48,11 +48,11 @@ struct badblocks_context {
>   	int		ack;
>   };
>   
> -int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
> -		   sector_t *first_bad, int *bad_sectors);
> -bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +int badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
> +		    sector_t *first_bad, sector_t *bad_sectors);
> +bool badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
>   		   int acknowledged);
> -bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
> +bool badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors);
>   void ack_all_badblocks(struct badblocks *bb);
>   ssize_t badblocks_show(struct badblocks *bb, char *page, int unack);
>   ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
> 

