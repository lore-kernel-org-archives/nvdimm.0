Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C16E380FC2
	for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780074978; cv=none; b=DbUKmavok5q+PwZp4yiob0Dv2/VTLJnnuKtGd2vmbTy5lhIqpaft+3lr35TkhNJhLRdtVx3cDZTLR7X1rR6bbEXjGDzWPWGEsyFp/YebOxGcbcAtG0H4zEzMXy4jQluQPowGFfxXE4559JLNQ2EA1m6OQ5bfIOFA9rV+zBdHRcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780074978; c=relaxed/simple;
	bh=oPZqw0KciWLf4R1JxiyGNTd9Vvsqd2t6e/uTw1nf/Hw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L7WModllySNpVWLddWw1onWdLWAOyoU4uBQbo7eOhJ1x0bmMrTejV9fHjv1C39ycqI1xTrT34lnYy5ZTxHSUq9uw7/Z6++jqcrMudHY+jokinkmJrc74JRU/eTxUh4c+YEu825TSNyKgE8rItjqPEV4eQc4p3P7C2k5jjlFNeJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cnj4i0cS; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cnj4i0cS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780074977; x=1811610977;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oPZqw0KciWLf4R1JxiyGNTd9Vvsqd2t6e/uTw1nf/Hw=;
  b=Cnj4i0cSRYU6f3ae1MficpjVPZjCrWlxGl4ZieOgfL8cZ1qx/FK1v8ED
   ieFmd2jxDTCRSHLDtw720As+73K2ECgZppHpluygJE3VuvqDzejhtB5Rt
   LXd2rfRvgLudowVx+D7aYNrvoG4RfYhXhJxStWyGVf1rYBMEt2jjUkkJ1
   B48cFZi4ZTZA9MqToMZqR/cc7TqGZYRc0hMb6snaKDEP54leU7+Ymhwss
   KbjqoN8PgqVNOV6qxoHLH6AKalnSWYL00K1pjm+VkyVnjmdRHSgPe6FtV
   zNHQzakcjMwwJKHjWaAyuguNG6Psprvbv+GAeg217lrSz2cdm1+7sA5yf
   w==;
X-CSE-ConnectionGUID: 9plxWZyZSbm6jtAJadm3aA==
X-CSE-MsgGUID: JRFRo0YEQGSLkKmH7+7rkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="84819145"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="84819145"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 10:16:16 -0700
X-CSE-ConnectionGUID: IxlzC5tGQm6ruh/ReIaA0w==
X-CSE-MsgGUID: 5fGA1fj6SZW0cbNmhOIL4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="236545870"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.151]) ([10.125.111.151])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 10:16:12 -0700
Message-ID: <8de1e66c-14a2-4933-9c34-be1d1335a36c@intel.com>
Date: Fri, 29 May 2026 10:16:10 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 25/31] dax/bus: Reject resize on DC dax devices and
 enforce 0-size creation
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>, Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <9c73377182f19e86e2cc939ddf0184d5d85581f9.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <9c73377182f19e86e2cc939ddf0184d5d85581f9.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> A DC dax device's size is determined by the extents that back it, not by
> the user.  DCD extents are all-or-nothing, so partial shrink is just as
> illegal as growing.  Enforce that on the size and creation paths:
> 
>   * size_store: any non-zero resize on a DC region returns -EOPNOTSUPP.
>     The sole exception is size=0, which daxctl destroy-device writes to
>     return every claimed extent to the region's available pool before
>     the device's name is written to the region's 'delete' attribute.
>   * __devm_create_dev_dax: a DC dax device must be created at size 0.
>     Non-zero data->size on a DC region returns -EINVAL with a clear
>     message.
> 
> The resize machinery (dev_dax_shrink, adjust_ok, dev_dax_resize_static,
> dev_dax_resize) learns to walk the right parent — dax_region->res for
> static regions, the dax_resource->res for DC regions claimed via
> uuid_store — so shrink-to-0 correctly releases each extent's child
> resource rather than the region's.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Just a nit below.


> 
> ---
> Changes:
> [anisa: split out from the original "Surface dc_extents" commit;
>  DC-aware resize policy only.]
> ---
>  drivers/dax/bus.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1d6f82920be6..c030eb103ad0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1136,7 +1136,8 @@ static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
>  	int i;
>  
>  	for (i = dev_dax->nr_range - 1; i >= 0; i--) {
> -		struct range *range = &dev_dax->ranges[i].range;
> +		struct dev_dax_range *dev_range = &dev_dax->ranges[i];
> +		struct range *range = &dev_range->range;
>  		struct dax_mapping *mapping = dev_dax->ranges[i].mapping;
>  		struct resource *adjust = NULL, *res;
>  		resource_size_t shrink;
> @@ -1152,6 +1153,10 @@ static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
>  			continue;
>  		}
>  
> +		/*
> +		 * Partial shrink: forbidden on DC regions, so dev_range
> +		 * here must belong to a static device.
> +		 */
>  		for_each_dax_region_resource(dax_region, res)
>  			if (strcmp(res->name, dev_name(dev)) == 0
>  					&& res->start == range->start) {
> @@ -1195,19 +1200,21 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
>  }
>  
>  /**
> - * dev_dax_resize_static - Expand the device into the unused portion of the
> - * region. This may involve adjusting the end of an existing resource, or
> - * allocating a new resource.
> + * __dev_dax_resize - Expand the device into the unused portion of the region.
> + * This may involve adjusting the end of an existing resource, or allocating a
> + * new resource.
>   *
>   * @parent: parent resource to allocate this range in
>   * @dev_dax: DAX device to be expanded
>   * @to_alloc: amount of space to alloc; must be <= space available in @parent
> + * @dax_resource: if dc; the parent resource
>   *
>   * Return the amount of space allocated or -ERRNO on failure
>   */
> -static ssize_t dev_dax_resize_static(struct resource *parent,
> -				     struct dev_dax *dev_dax,
> -				     resource_size_t to_alloc)
> +static ssize_t __dev_dax_resize(struct resource *parent,
> +				struct dev_dax *dev_dax,
> +				resource_size_t to_alloc,
> +				struct dax_resource *dax_resource)
>  {
>  	struct resource *res, *first;
>  	int rc;
> @@ -1215,7 +1222,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
>  	first = parent->child;
>  	if (!first) {
>  		rc = alloc_dev_dax_range(parent, dev_dax,
> -					   parent->start, to_alloc, NULL);
> +					   parent->start, to_alloc,
> +					   dax_resource);
>  		if (rc)
>  			return rc;
>  		return to_alloc;
> @@ -1229,7 +1237,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
>  		if (res == first && res->start > parent->start) {
>  			alloc = min(res->start - parent->start, to_alloc);
>  			rc = alloc_dev_dax_range(parent, dev_dax,
> -						 parent->start, alloc, NULL);
> +						 parent->start, alloc,
> +						 dax_resource);
>  			if (rc)
>  				return rc;
>  			return alloc;
> @@ -1253,7 +1262,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
>  				return rc;
>  			return alloc;
>  		}
> -		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc, NULL);
> +		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc,
> +					 dax_resource);
>  		if (rc)
>  			return rc;
>  		return alloc;
> @@ -1264,6 +1274,13 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
>  	return 0;
>  }
>  
> +static ssize_t dev_dax_resize_static(struct dax_region *dax_region,
> +				     struct dev_dax *dev_dax,
> +				     resource_size_t to_alloc)
> +{
> +	return __dev_dax_resize(&dax_region->res, dev_dax, to_alloc, NULL);
> +}
> +
>  static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  		struct dev_dax *dev_dax, resource_size_t size)
>  {
> @@ -1277,6 +1294,8 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  		return -EBUSY;
>  	if (size == dev_size)
>  		return 0;
> +	if (size != 0 && is_dynamic(dax_region))
> +		return -EOPNOTSUPP;
>  	if (size > dev_size && size - dev_size > avail)
>  		return -ENOSPC;
>  	if (size < dev_size)
> @@ -1288,7 +1307,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  		return -ENXIO;
>  
>  retry:
> -	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
> +	alloc = dev_dax_resize_static(dax_region, dev_dax, to_alloc);
>  	if (alloc <= 0)
>  		return alloc;
>  	to_alloc -= alloc;
> @@ -1674,6 +1693,11 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	struct device *dev;
>  	int rc;
>  
> +	if (is_dynamic(dax_region) && data->size) {
> +		dev_err(parent, "DC DAX region devices must be created initially with 0 size");

Needs \n

> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	dev_dax = kzalloc_obj(*dev_dax);
>  	if (!dev_dax)
>  		return ERR_PTR(-ENOMEM);

