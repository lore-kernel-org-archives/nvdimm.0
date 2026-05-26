Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BD63BD646
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 23:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779837727; cv=none; b=FkImIK5/9JRPTsAmJfJ64fojVIAL3CB0TBzIZbD5UM2xbU+u3ak79pi03D5EMqIr2rWG3RbICSo6qGUY323J5eRH27xJXGLBwpASy2DyxjsbRHKB9M+gYulm1Yz1uiJBQeEzdsiyoDA4sjsZ1Vh3ve5jEVacDxgEI+f6t/zf6zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779837727; c=relaxed/simple;
	bh=SRzFIBtNXr2IZxxyqZvaMrgjGl+IynndLC6+Ry28wLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t9AAG02FNkTGkClQ0kNwd9bQtyCiBQuh6EVs8O1bCaw6mPzk2sITuWgR2yIrmMfr1jjH4yoU/93BMaxnBx3cmYKTFX0lNTpvQrcLDsGirgL1fgGxhOmCbt0trx6NVAsnVfId6/YurzfppdI18sTrtKSEbeQi+qo+aTMSgKJRS7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hE+o+Arw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hE+o+Arw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779837726; x=1811373726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SRzFIBtNXr2IZxxyqZvaMrgjGl+IynndLC6+Ry28wLE=;
  b=hE+o+ArwXoJ+ST9U1jDbWRtTqHUYQf/lKFZWq5Hm8xlQ9G9JWRgD53PX
   7vH4tQt/EqOn8K4KNmmGAk3CQae2ZzFyoUcFqlqFNgS6wKDMH9kfxYNOV
   qnNGZ1Kc8wJZkxzGu6ZKm8IEEJIE+47VH801tBOhCN7KF8VUjVOJgzGrG
   GCFBXuD//tcsjSeJTkbSHMPpgVRs/K4/yWjHaBSr0OOenQSqP8hZOc8vK
   DtJn6nnZsAbPkTBEcSOrwqfYSW8F06CNnuY1ZakRDbn8FfPDaKamGCeXn
   Omo1MrIggXBl7DA94R2Y3uaMAv4iY0BUaFLuq/QS5jt/K27EnGtSMJbuv
   w==;
X-CSE-ConnectionGUID: 1TwrOy7iTgKyw/Wf4BZFkg==
X-CSE-MsgGUID: FDb0xNMbQD6uz3nMw6CBtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="98089298"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="98089298"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 16:22:05 -0700
X-CSE-ConnectionGUID: 4BykZTCJSUifHT7CYZJrZw==
X-CSE-MsgGUID: eLGrKQxvQpCtnY1cWJ57tw==
X-ExtLoop1: 1
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 16:22:03 -0700
Message-ID: <0e68254a-b57a-4210-a2c2-7dce2a3e5256@intel.com>
Date: Tue, 26 May 2026 16:22:02 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/7] dax/fsdev: fix multi-range offset, vmemmap_shift
 leak, and probe error cleanup
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191851.79150-1-john@jagalactic.com>
 <0100019e51205fc2-9b729b27-3485-44a0-98b2-ea56189c192e-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e51205fc2-9b729b27-3485-44a0-98b2-ea56189c192e-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/22/26 12:18 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Three fixes for fsdev.c:
> 
> 1. Fix memory_failure offset calculation for multi-range devices.
>    The old code subtracted ranges[0].range.start from the faulting PFN's
>    physical address, which produces an incorrect (inflated) logical offset
>    when the PFN falls in ranges[1] or beyond due to physical gaps between
>    ranges. Add fsdev_pfn_to_offset() to walk the range list and compute
>    the correct device-linear byte offset.
> 
> 2. Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a
>    static device from device_dax (which may set vmemmap_shift based on
>    alignment) to fsdev_dax, the stale vmemmap_shift persists on the
>    shared pgmap. Explicitly zero it before devm_memremap_pages() so the
>    vmemmap is built for order-0 folios as fsdev requires.
> 
> 3. Clear dev_dax->pgmap on probe failure for dynamic devices. After the
>    dynamic path sets dev_dax->pgmap, if a later probe step fails, devres
>    frees the devm_kzalloc'd pgmap but leaves dev_dax->pgmap dangling.
>    Subsequent probe attempts would hit the "dynamic-dax with pre-populated
>    page map" check and fail permanently. Use a goto cleanup to NULL
>    dev_dax->pgmap on error.

3 fixes, 3 separate patches?

DJ

> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c | 50 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 40 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 188b2526bee45..42aac7e952516 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
>   * The core mm code in free_zone_device_folio() handles the wake_up_var()
>   * directly for this memory type.
>   */
> +static u64 fsdev_pfn_to_offset(struct dev_dax *dev_dax, unsigned long pfn)
> +{
> +	phys_addr_t phys = PFN_PHYS(pfn);
> +	u64 offset = 0;
> +
> +	for (int i = 0; i < dev_dax->nr_range; i++) {
> +		struct range *range = &dev_dax->ranges[i].range;
> +
> +		if (phys >= range->start && phys <= range->end)
> +			return offset + (phys - range->start);
> +		offset += range_len(range);
> +	}
> +	return -1ULL;
> +}
> +
>  static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
>  		unsigned long pfn, unsigned long nr_pages, int mf_flags)
>  {
>  	struct dev_dax *dev_dax = pgmap->owner;
> -	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
> +	u64 offset = fsdev_pfn_to_offset(dev_dax, pfn);
>  	u64 len = nr_pages << PAGE_SHIFT;
>  
>  	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
> @@ -208,6 +223,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  {
>  	struct dax_device *dax_dev = dev_dax->dax_dev;
>  	struct device *dev = &dev_dax->dev;
> +	bool pgmap_allocated = false;
>  	struct dev_pagemap *pgmap;
>  	struct inode *inode;
>  	u64 data_offset = 0;
> @@ -222,6 +238,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		}
>  
>  		pgmap = dev_dax->pgmap;
> +		pgmap->vmemmap_shift = 0;
>  	} else {
>  		size_t pgmap_size;
>  
> @@ -237,6 +254,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  
>  		pgmap->nr_range = dev_dax->nr_range;
>  		dev_dax->pgmap = pgmap;
> +		pgmap_allocated = true;
>  
>  		for (i = 0; i < dev_dax->nr_range; i++) {
>  			struct range *range = &dev_dax->ranges[i].range;
> @@ -252,7 +270,8 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  					range_len(range), dev_name(dev))) {
>  			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
>  				 i, range->start, range->end);
> -			return -EBUSY;
> +			rc = -EBUSY;
> +			goto err_pgmap;
>  		}
>  	}
>  
> @@ -272,8 +291,10 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	pgmap->owner = dev_dax;
>  
>  	addr = devm_memremap_pages(dev, pgmap);
> -	if (IS_ERR(addr))
> -		return PTR_ERR(addr);
> +	if (IS_ERR(addr)) {
> +		rc = PTR_ERR(addr);
> +		goto err_pgmap;
> +	}
>  
>  	/*
>  	 * Clear any stale compound folio state left over from a previous
> @@ -285,7 +306,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	rc = devm_add_action_or_reset(dev, fsdev_clear_folio_state_action,
>  				      dev_dax);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	/* Detect whether the data is at a non-zero offset into the memory */
>  	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
> @@ -307,23 +328,32 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	cdev_set_parent(cdev, &dev->kobj);
>  	rc = cdev_add(cdev, dev->devt, 1);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	rc = devm_add_action_or_reset(dev, fsdev_cdev_del, cdev);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	/* Set the dax operations for fs-dax access path */
>  	rc = dax_set_ops(dax_dev, &dev_dax_ops);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	rc = devm_add_action_or_reset(dev, fsdev_clear_ops, dev_dax);
>  	if (rc)
> -		return rc;
> +		goto err_pgmap;
>  
>  	run_dax(dax_dev);
> -	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> +	rc = devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> +	if (rc)
> +		goto err_pgmap;
> +
> +	return 0;
> +
> +err_pgmap:
> +	if (pgmap_allocated)
> +		dev_dax->pgmap = NULL;
> +	return rc;
>  }
>  
>  static struct dax_device_driver fsdev_dax_driver = {

