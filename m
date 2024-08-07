Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DDF1411DF
	for <nvdimm@lists.linux.dev>; Wed,  7 Aug 2024 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723055411; cv=none; b=mxNI1vG6IDZIRLeImdc5kTE0eeDqFqlYvKLo4wWnzlAWTtRZhxqh3/HJjTSJAAgUwSSxM7Xl3NJEBZ6+CL9IKHmDhz7+GYfELXApcXnX+V72yDNaFPJWo7XlCViUqoro4gGlcaX1gO/uT/FrL+dw5OQ18H+0SAeJjGq/BOXa1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723055411; c=relaxed/simple;
	bh=UaQkeTO6wPD8EaFGm6lBWsF7HeTN5QeBzb3IAPZdNQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPN4sV8K3tHFr2qOLHwsUe2UpfDEqb8XHfCQloJ0P/ETbu1dgmX3KifJqRow8X/JKVZw6OzLOHZTv18a9oH/Svmmul90u6cPf31m+1qkm2tFm+arLNTtY2rWmKNdwQTFmhfNUK2TppSYUiFqV3wzJe86tLvpRRO33HgPyH8rDsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EVqixrMR; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EVqixrMR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723055409; x=1754591409;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UaQkeTO6wPD8EaFGm6lBWsF7HeTN5QeBzb3IAPZdNQ8=;
  b=EVqixrMRsF0RtV8+4OlFVgEZQm1NTBZRLA2HRE54OdG2ZtZiCBC43P36
   Bunabp2hga7rMNTnYcC7/sQis/ge+TkQ4UtpA8r0u/mhWaTQ2bQbsiz9t
   e+eGimAUA8vNWCjCmsLTujwb1CGFmL5uGtSX1VugMbCZRLsHVKpZY1YeH
   /i1mPkU2IZg3bNQ+yDhtFGjPJ2aa9/kkJSgcIKR8SdCHqG+y3xWIWnANH
   LwCmoKUCxVOYYOHc1Y+Xuw7lxHFEYcPt2QrCq2zV5hbzdC05RkxXK/VS1
   6YlD6D5G56rqfIg/xVl+SzoKEmcmr0rJwbkp1pQ/WGWl3yF6GpCzHmo2E
   Q==;
X-CSE-ConnectionGUID: Qefnbks8SrWvBwPxYPEGbw==
X-CSE-MsgGUID: AotFwz2ARiKFA2dXwr5a4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="12906939"
X-IronPort-AV: E=Sophos;i="6.09,270,1716274800"; 
   d="scan'208";a="12906939"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 11:30:08 -0700
X-CSE-ConnectionGUID: iGCQZM3qQsGnMi7fEvLquw==
X-CSE-MsgGUID: 0VG0siAcTS+dUdaKenQJCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,270,1716274800"; 
   d="scan'208";a="94514292"
Received: from eamartin-mobl1.amr.corp.intel.com (HELO [10.125.111.208]) ([10.125.111.208])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 11:30:07 -0700
Message-ID: <cc8e898d-b0d2-4e18-a516-864ec6b9145d@intel.com>
Date: Wed, 7 Aug 2024 11:30:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases
To: Zhihao Cheng <chengzhihao1@huawei.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, hch@lst.de, ira.weiny@intel.com,
 dlemoal@kernel.org, hare@suse.de, axboe@kernel.dk
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240731122530.3334451-1-chengzhihao1@huawei.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240731122530.3334451-1-chengzhihao1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/31/24 5:25 AM, Zhihao Cheng wrote:
> The dax is only supportted on pfn type pmem devices since commit
> f467fee48da4 ("block: move the dax flag to queue_limits"), fix it
> by adding dax flag setting for the missed case.
> 
> Fixes: f467fee48da4 ("block: move the dax flag to queue_limits")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 1ae8b2351654..210fb77f51ba 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -498,7 +498,7 @@ static int pmem_attach_disk(struct device *dev,
>  	}
>  	if (fua)
>  		lim.features |= BLK_FEAT_FUA;
> -	if (is_nd_pfn(dev))
> +	if (is_nd_pfn(dev) || pmem_should_map_pages(dev))
>  		lim.features |= BLK_FEAT_DAX;
>  
>  	if (!devm_request_mem_region(dev, res->start, resource_size(res),
