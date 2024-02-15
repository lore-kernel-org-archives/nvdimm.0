Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E5E1386BE
	for <nvdimm@lists.linux.dev>; Thu, 15 Feb 2024 18:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708021007; cv=none; b=BVcQuWnCzN0q1SSSMNjiRGVOAaSbN4FtbS+oJBn3vpDwG8PwCQ3pUYLcvYhkjTaiCQ858Uh/Pz+A//AfjFeHF5uwT/qgxlFA5bIypjs5kKzavUrrdiLSp8A/vVua9zbbQfK68UI3656mqIo16gHcUNfYTPXVnJkJL2cJAsTQ5rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708021007; c=relaxed/simple;
	bh=aaZk5/CFK8e/X6U94sy44+Dc46NyneCUtz1mF/gusDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eq5jHaANaDZuwPaSGkobZ46vLeHgKfl7LG3k8FXuZd6X4ObRNDsYA8fetbPHuJGUfH9M0K5kL7FuVcDtreW2lqu1RJ0abdsOwSZvlZayprHHXYHscFhwgyKSUpfB+qte8GPvdAPv8z/tmudN2XPwc6o2Z7jRymL2jhcyB3D2fe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J/fzKPF8; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J/fzKPF8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708021006; x=1739557006;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aaZk5/CFK8e/X6U94sy44+Dc46NyneCUtz1mF/gusDs=;
  b=J/fzKPF8oBDR6sWrZoViQe4cmTGmrFYBQAqx7flXmkSpFu1FR53C9Zql
   zT1qrpNNyqdKp5euA60aj/EQOt8d9GbgBm7fqYrRqlFA4IZeaKuS2H5K8
   6vQZIFRRs3c0mVeDFmvUNvXQJGhZXsuxMoD3VWLr55m1V8efFJycdzHsS
   QtAU+MSPEOiKzoE4A4a3fune6rfXnYgh7tKQODxQC2bQ7hwxrakgVjf8r
   SvVqxFsL80mGf40fSxbue31iGRJxBPDtZrIKUU9DuoSCF0mhEj6Hy5pS4
   tl0B7H8CXj3RC7+d+doQe7Eqv1abi/2zowTx9QeFP7rydVtNrYweuIZ8H
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="5958634"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="5958634"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 10:16:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="8210870"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.113.87]) ([10.246.113.87])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 10:16:44 -0800
Message-ID: <a6ec8c90-3d62-418b-96de-bc262783f5e6@intel.com>
Date: Thu, 15 Feb 2024 11:16:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] btt: pass queue_limits to blk_mq_alloc_disk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Coly Li <colyli@suse.de>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 linux-m68k@lists.linux-m68k.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-block@vger.kernel.org
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-8-hch@lst.de>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240215071055.2201424-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/15/24 12:10 AM, Christoph Hellwig wrote:
> Pass the queue limits directly to blk_alloc_disk instead of setting them
> one at a time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/btt.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 9a0eae01d5986e..4d0c527e857678 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1496,9 +1496,13 @@ static int btt_blk_init(struct btt *btt)
>  {
>  	struct nd_btt *nd_btt = btt->nd_btt;
>  	struct nd_namespace_common *ndns = nd_btt->ndns;
> +	struct queue_limits lim = {
> +		.logical_block_size	= btt->sector_size,
> +		.max_hw_sectors		= UINT_MAX,
> +	};
>  	int rc;
>  
> -	btt->btt_disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
> +	btt->btt_disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
>  	if (IS_ERR(btt->btt_disk))
>  		return PTR_ERR(btt->btt_disk);
>  
> @@ -1507,8 +1511,6 @@ static int btt_blk_init(struct btt *btt)
>  	btt->btt_disk->fops = &btt_fops;
>  	btt->btt_disk->private_data = btt;
>  
> -	blk_queue_logical_block_size(btt->btt_disk->queue, btt->sector_size);
> -	blk_queue_max_hw_sectors(btt->btt_disk->queue, UINT_MAX);
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
>  	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, btt->btt_disk->queue);
>  
