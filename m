Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B997A15099D
	for <nvdimm@lists.linux.dev>; Thu,  8 Aug 2024 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145298; cv=none; b=rqUjOH63iIA04wOiAHk9bPGTP0ZlnwBzYh9VnXDfwSNgTpiiyqXAxHKzyyZYO9rq9tKBgkMcVNdn9q/JdaF8LxuohqKJZ/oS04FThO/IX1t4l5AYl2fIt9kI41G4SOy1XF8GNYeh/IZql3wJ6t4roaDzQOJ5ASHcIW754md+PUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145298; c=relaxed/simple;
	bh=n4jJYHx42+ihYMKvptonitRjvq/fNqpGn+fZGhpyzgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svqQLtQlZ8Me+tyMuq6daohalHeMAjrO+QkuPbQZo2LRWrr+9jns6AfmPxNZQfP8SEYweoYOpjVd8XrlF6iWFD+EDtF7KMWEumDzByP2HQ2A0Gz94m3M4f+kvxOdRxY5jsjWHHSlJeDsB8gBVTDPd5jHndHYfnOogufx0hRKwe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MqaTnSNw; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MqaTnSNw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723145296; x=1754681296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n4jJYHx42+ihYMKvptonitRjvq/fNqpGn+fZGhpyzgk=;
  b=MqaTnSNw0E3GlWGyWF43AzH2FRJKUWyQSm3+w51NjHl0RgFjvPwxahmB
   AqLnuZ3EeW9t/3PZR66w9zQ1nacgMNVLWmzWXw3avtAA7g0DIYUvREHWv
   mrQc4n1IoRmTviI5ul6IUDagrCjk2rfgOKm4PXV3KfrAowXgmwucjuFcx
   eELpP/wjaZec0ZqfNPdKvFMlxp+vdANoEQjKQD1mn7XmCD6mRWyGJ61Cz
   6ewdq6nyi500LCssflhLVZSUb06pOInp1n60KwvKQckfiVbTTWybHJYW0
   yhqDBlp5t5a0NacW0ophUiiHcHfCp/Toz0VVGLpiAvJQrvHvKbSqrUGcF
   w==;
X-CSE-ConnectionGUID: qBYw+bLQQcCvP+1LJyipKA==
X-CSE-MsgGUID: qjPucffHTj+IKCURz7XD8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="31969525"
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="31969525"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 12:28:15 -0700
X-CSE-ConnectionGUID: BRNVP7mMQx2AZg9NEfyX1w==
X-CSE-MsgGUID: 0RDtKjrPQuW2OSiKxd9Dyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="62281684"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.12.215])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 12:28:14 -0700
Date: Thu, 8 Aug 2024 12:28:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, hch@lst.de, ira.weiny@intel.com,
	dlemoal@kernel.org, hare@suse.de, axboe@kernel.dk,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases
Message-ID: <ZrUcSihtUWO2FrI3@aschofie-mobl2>
References: <20240731122530.3334451-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731122530.3334451-1-chengzhihao1@huawei.com>

On Wed, Jul 31, 2024 at 08:25:30PM +0800, Zhihao Cheng wrote:
> The dax is only supportted on pfn type pmem devices since commit
> f467fee48da4 ("block: move the dax flag to queue_limits"), fix it
> by adding dax flag setting for the missed case.

s/supportted/supported

How about adding failure messages like this:

Trying to mount DAX filesystem fails with this error:
mount: : wrong fs type, bad option, bad superblock on /dev/pmem7, missing codepage or helper program, or other error.
       dmesg(1) may have more information after failed mount system call.

dmesg: EXT4-fs (pmem7): DAX unsupported by block device.


Tested-by: Alison Schofield <alison.schofield@intel.com>

> 
> Fixes: f467fee48da4 ("block: move the dax flag to queue_limits")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
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
> -- 
> 2.39.2
> 
