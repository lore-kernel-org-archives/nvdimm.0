Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A0A202F65;
	Fri, 21 Feb 2025 11:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740138765; cv=none; b=tRC9IpV/eDWwOF2J+7WU88uXZCjZLT1MF/wn1sdkEql8YMuOqIFpG1IPrscGGCXDgPOTBW56DPpldtHipHPn5EeiOaIIjF66+svYgx1h15b4RrlnSBQAdRq1u3lF2OiofViTjY4cG6CviPC00j0C9xQaPTcRRGRnf1DSB2Ft18k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740138765; c=relaxed/simple;
	bh=/6fIUBQi+/OelTiYn4ClAboYMnQrntESGhAezaUZ2Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIoN/02u3UNWKRsaz5uJ4cHMUo5e5Mlq/LdlDZYuxzP19wPLynS+5ve5tB7MNPOEikMJw6djmFhgsp26AI7xUgt20Y3H1LPXlxQeC3vQjl2lRmvWA8thehp/EvL/5Yo9uyy63v3mJiwjB8OaH411oH8faZLlTtJEuXdyi/tl5XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ucrW+O6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ucrW+O6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB44C4CED6;
	Fri, 21 Feb 2025 11:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740138764;
	bh=/6fIUBQi+/OelTiYn4ClAboYMnQrntESGhAezaUZ2Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ucrW+O6x9JmPxBoikDUFM1U6wJ3TzgfP6wExxZaAw1uoKhs5/fF61psO8Sf5rYUKs
	 j/6MZVHyGLhONiKM1S04QEVt9htttiH/Tw7VQDWwgIVkMj5mz3/umNNBVBu7fNQ1q8
	 ncVe8MTYXmGubJ4lvTxzdO/h29YZ4gYrWhOy7zdXTz0Wj+A0ZENnDEa/hYrt6WGD36
	 ZQxVWeBWEb1o5XIIHVHgKS1ipE1jbm34Os5w/c+oytbjgg0GcRH+r1C6EpRj/PMSpC
	 /F8aLHkVrg0MwPMxToGhBJZiw/Uub5jnbikgKI/BfKy8ibcfVqtLJ6GmB6XuWvc+WQ
	 V0kSl6lJgnrXA==
Date: Fri, 21 Feb 2025 19:52:16 +0800
From: Coly Li <colyli@kernel.org>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, 
	dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	ira.weiny@intel.com, dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, 
	hare@suse.de, zhengqixing@huawei.com, john.g.garry@oracle.com, 
	geliang@kernel.org, xni@redhat.com, colyli@suse.de, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 00/12] badblocks: bugfix and cleanup for badblocks
Message-ID: <t6fbzky7xgffr7ftst747jsircm2uhucbhpbhnn56ewwq2j2gj@a7ctlr2gigyj>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221081109.734170-1-zhengqixing@huaweicloud.com>

On Fri, Feb 21, 2025 at 04:10:57PM +0800, Zheng Qixing wrote:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> During RAID feature implementation testing, we found several bugs
> in badblocks.
> 
> This series contains bugfixes and cleanups for MD RAID badblocks
> handling code.
> 
> Li Nan (8):
>   badblocks: Fix error shitf ops
>   badblocks: factor out a helper try_adjacent_combine
>   badblocks: attempt to merge adjacent badblocks during
>     ack_all_badblocks
>   badblocks: return error directly when setting badblocks exceeds 512
>   badblocks: return error if any badblock set fails
>   badblocks: fix the using of MAX_BADBLOCKS
>   badblocks: try can_merge_front before overlap_front
>   badblocks: fix merge issue when new badblocks align with pre+1
> 
> Zheng Qixing (4):
>   badblocks: fix missing bad blocks on retry in _badblocks_check()
>   badblocks: return boolen from badblocks_set() and badblocks_clear()
>   md: improve return types of badblocks handling functions
>   badblocks: use sector_t instead of int to avoid truncation of
>     badblocks length
>

Thank you all for the testing and fix up!

Coly Li

 
>  block/badblocks.c             | 317 +++++++++++++---------------------
>  drivers/block/null_blk/main.c |  19 +-
>  drivers/md/md.c               |  47 +++--
>  drivers/md/md.h               |  14 +-
>  drivers/md/raid1-10.c         |   2 +-
>  drivers/md/raid1.c            |  10 +-
>  drivers/md/raid10.c           |  14 +-
>  drivers/nvdimm/badrange.c     |   2 +-
>  drivers/nvdimm/nd.h           |   2 +-
>  drivers/nvdimm/pfn_devs.c     |   7 +-
>  drivers/nvdimm/pmem.c         |   2 +-
>  include/linux/badblocks.h     |  10 +-
>  12 files changed, 181 insertions(+), 265 deletions(-)
> 
> -- 
> 2.39.2
> 
