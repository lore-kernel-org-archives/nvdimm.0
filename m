Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C86F1AD3F6
	for <nvdimm@lists.linux.dev>; Mon, 14 Oct 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728924981; cv=none; b=WKL3ajuZd/If5hKNlFrGhTCAAP835eD8gKjt5m6caTxNKbF1jLO40DThbJ6dwnJ53AglUDh/M/GtKdMavpfIjmFMf5lahctTjbym52wEkv7Ua5IF6Q2c0YqVC3HvCmZhoCiLiLsQn4PHJ675QjYbFAGenVyRohWnStfuwGrUZ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728924981; c=relaxed/simple;
	bh=nD3fGeBFvL+EJJPI5lGj7pAV+MixQ67qEsOh2VTNyKI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wq5bQOEzb2qjsEMdAxwMhgdVrQ9p1hj5BfMVTsEWB+jJKmPx4DU7s2y6rkU2Vn25xgMem7PDa11v6EEMdfZBL0LNNKgQ+r3Q6X3cW7tir/Xf3fP4694/sB/niZdiK5BWVdKqB0E1MtlrYwlkIE4oYxlQVEQGw0F4bMyrdzKKGZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUdOsnvL; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUdOsnvL"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e290e857d56so3642423276.1
        for <nvdimm@lists.linux.dev>; Mon, 14 Oct 2024 09:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728924978; x=1729529778; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ddsXQQbU8MvXf6QmdcSJ6JsFBx6hSo9OkjFj+kLPcxo=;
        b=hUdOsnvLF4ldNOCFJ5uX2cU1Y+zZ0ZjVbPsuKw11Qyevb5pfG53wWEPS+RfXjNQw2Q
         3ISad4mHL7U/wm4Gd/cVDkUPYOXp5mduNg7kvWxIDFYqKc0JQBlGF5SFdhYkWravjB+Z
         U9OpNkx8u7C4VA8/vjx/ltlPbAZLb55lHwXIFpVeBI0ZIAYWESlxhqH+2xE3Z8QNxG26
         sacoDkoChBwAeARnE840/8bR68l9ji74eR//fJG/ST3eIGcu6ftXF5FAi2KJ9tQi9tJZ
         kBRA64L1wkZNJlKOsLDq1ZFWmCf6z2Wudlyl07s1zvNOLxFUzJixZeTzTzKBNRH5Jxw5
         rsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728924978; x=1729529778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddsXQQbU8MvXf6QmdcSJ6JsFBx6hSo9OkjFj+kLPcxo=;
        b=WfnV5jXLp2OCSt4Lridd7CqRv9DXcoFLGgjrfoW2Tk4xIapGv3QiIsEW18MdK+2XGy
         Xjh4yYIgcqBJWlYjVfsnqnm7pyM9KTnGgKjXKup6OpLR4JbXoBwObZ85FR9FSkOY+FeY
         AkLaoRPo2nqFJDNSvN4BfllLe+1LIvy9Uq0I1Z0UHjtB+5dnJrFrzYW2kDyiElZc5S8E
         ou1P/dpugkI/6AE6+SOrHxz8GJ9aQ+8/PwfsE1R1NB7ovkvI7+j1YdPvJngvDd6hUim4
         hx9slpfxJ0XfQie8QUrijvaJAIWjOzB6RIOA9ss7YBl74xVxLcczFJfRB8u1rxWl62RP
         wBpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV64F1LpVbzgeLkU8BDdQ7Cg0xCfDbJ+jRiTuo+FWLLIIHufJ7XQ6Ia4xlRvGYLyQI+TZxuOTE=@lists.linux.dev
X-Gm-Message-State: AOJu0YymT41KaO1nqvcejEuKEltBbop9Be1oc9NVlTt0bW81FQVcenyG
	xsBrzKiNPMtODWcMJyQNJnZTaXRbreBE/E9T7H1rFUZjfISUIx5s
X-Google-Smtp-Source: AGHT+IGRxIooMyF8x4PKhiot8G3u2vhGn1BfEG0sXBKicJWPXR5jgNPa1nRNB1dgAoe7W2WUWzlBuw==
X-Received: by 2002:a05:690c:2843:b0:6dd:b920:6e61 with SMTP id 00721157ae682-6e347c840a2mr71270877b3.40.1728924978243;
        Mon, 14 Oct 2024 09:56:18 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e332b611acsm15759257b3.24.2024.10.14.09.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 09:56:18 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Mon, 14 Oct 2024 09:56:15 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 23/28] dax/bus: Factor out dev dax resize logic
Message-ID: <Zw1NL3_otWVTUF4c@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-23-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-23-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:29PM -0500, Ira Weiny wrote:
> Dynamic Capacity regions must limit dev dax resources to those areas
> which have extents backing real memory.  Such DAX regions are dubbed
> 'sparse' regions.  In order to manage where memory is available four
> alternatives were considered:
> 
> 1) Create a single region resource child on region creation which
>    reserves the entire region.  Then as extents are added punch holes in
>    this reservation.  This requires new resource manipulation to punch
>    the holes and still requires an additional iteration over the extent
>    areas which may already have existing dev dax resources used.
> 
> 2) Maintain an ordered xarray of extents which can be queried while
>    processing the resize logic.  The issue is that existing region->res
>    children may artificially limit the allocation size sent to
>    alloc_dev_dax_range().  IE the resource children can't be directly
>    used in the resize logic to find where space in the region is.  This
>    also poses a problem of managing the available size in 2 places.
> 
> 3) Maintain a separate resource tree with extents.  This option is the
>    same as 2) but with the different data structure.  Most ideally there
>    should be a unified representation of the resource tree not two places
>    to look for space.
> 
> 4) Create region resource children for each extent.  Manage the dax dev
>    resize logic in the same way as before but use a region child
>    (extent) resource as the parents to find space within each extent.
> 
> Option 4 can leverage the existing resize algorithm to find space within
> the extents.  It manages the available space in a singular resource tree
> which is less complicated for finding space.
> 
> In preparation for this change, factor out the dev_dax_resize logic.
> For static regions use dax_region->res as the parent to find space for
> the dax ranges.  Future patches will use the same algorithm with
> individual extent resources as the parent.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

LGTM based on the code logic, but not familiar with dax resource management.

Fan

> ---
> Changes:
> [Jonathan: Fix handling of alloc]
> ---
>  drivers/dax/bus.c | 129 +++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 79 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index d8cb5195a227..f0e3f8c787df 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -844,11 +844,9 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
>  	return 0;
>  }
>  
> -static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
> -		resource_size_t size)
> +static int alloc_dev_dax_range(struct resource *parent, struct dev_dax *dev_dax,
> +			       u64 start, resource_size_t size)
>  {
> -	struct dax_region *dax_region = dev_dax->region;
> -	struct resource *res = &dax_region->res;
>  	struct device *dev = &dev_dax->dev;
>  	struct dev_dax_range *ranges;
>  	unsigned long pgoff = 0;
> @@ -866,14 +864,14 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
>  		return 0;
>  	}
>  
> -	alloc = __request_region(res, start, size, dev_name(dev), 0);
> +	alloc = __request_region(parent, start, size, dev_name(dev), 0);
>  	if (!alloc)
>  		return -ENOMEM;
>  
>  	ranges = krealloc(dev_dax->ranges, sizeof(*ranges)
>  			* (dev_dax->nr_range + 1), GFP_KERNEL);
>  	if (!ranges) {
> -		__release_region(res, alloc->start, resource_size(alloc));
> +		__release_region(parent, alloc->start, resource_size(alloc));
>  		return -ENOMEM;
>  	}
>  
> @@ -1026,50 +1024,45 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
>  	return true;
>  }
>  
> -static ssize_t dev_dax_resize(struct dax_region *dax_region,
> -		struct dev_dax *dev_dax, resource_size_t size)
> +/**
> + * dev_dax_resize_static - Expand the device into the unused portion of the
> + * region. This may involve adjusting the end of an existing resource, or
> + * allocating a new resource.
> + *
> + * @parent: parent resource to allocate this range in
> + * @dev_dax: DAX device to be expanded
> + * @to_alloc: amount of space to alloc; must be <= space available in @parent
> + *
> + * Return the amount of space allocated or -ERRNO on failure
> + */
> +static ssize_t dev_dax_resize_static(struct resource *parent,
> +				     struct dev_dax *dev_dax,
> +				     resource_size_t to_alloc)
>  {
> -	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
> -	resource_size_t dev_size = dev_dax_size(dev_dax);
> -	struct resource *region_res = &dax_region->res;
> -	struct device *dev = &dev_dax->dev;
>  	struct resource *res, *first;
> -	resource_size_t alloc = 0;
>  	int rc;
>  
> -	if (dev->driver)
> -		return -EBUSY;
> -	if (size == dev_size)
> -		return 0;
> -	if (size > dev_size && size - dev_size > avail)
> -		return -ENOSPC;
> -	if (size < dev_size)
> -		return dev_dax_shrink(dev_dax, size);
> -
> -	to_alloc = size - dev_size;
> -	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
> -			"resize of %pa misaligned\n", &to_alloc))
> -		return -ENXIO;
> -
> -	/*
> -	 * Expand the device into the unused portion of the region. This
> -	 * may involve adjusting the end of an existing resource, or
> -	 * allocating a new resource.
> -	 */
> -retry:
> -	first = region_res->child;
> -	if (!first)
> -		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
> +	first = parent->child;
> +	if (!first) {
> +		rc = alloc_dev_dax_range(parent, dev_dax,
> +					   parent->start, to_alloc);
> +		if (rc)
> +			return rc;
> +		return to_alloc;
> +	}
>  
> -	rc = -ENOSPC;
>  	for (res = first; res; res = res->sibling) {
>  		struct resource *next = res->sibling;
> +		resource_size_t alloc;
>  
>  		/* space at the beginning of the region */
> -		if (res == first && res->start > dax_region->res.start) {
> -			alloc = min(res->start - dax_region->res.start, to_alloc);
> -			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
> -			break;
> +		if (res == first && res->start > parent->start) {
> +			alloc = min(res->start - parent->start, to_alloc);
> +			rc = alloc_dev_dax_range(parent, dev_dax,
> +						 parent->start, alloc);
> +			if (rc)
> +				return rc;
> +			return alloc;
>  		}
>  
>  		alloc = 0;
> @@ -1078,21 +1071,55 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  			alloc = min(next->start - (res->end + 1), to_alloc);
>  
>  		/* space at the end of the region */
> -		if (!alloc && !next && res->end < region_res->end)
> -			alloc = min(region_res->end - res->end, to_alloc);
> +		if (!alloc && !next && res->end < parent->end)
> +			alloc = min(parent->end - res->end, to_alloc);
>  
>  		if (!alloc)
>  			continue;
>  
>  		if (adjust_ok(dev_dax, res)) {
>  			rc = adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
> -			break;
> +			if (rc)
> +				return rc;
> +			return alloc;
>  		}
> -		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc);
> -		break;
> +		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc);
> +		if (rc)
> +			return rc;
> +		return alloc;
>  	}
> -	if (rc)
> -		return rc;
> +
> +	/* available was already calculated and should never be an issue */
> +	dev_WARN_ONCE(&dev_dax->dev, 1, "space not found?");
> +	return 0;
> +}
> +
> +static ssize_t dev_dax_resize(struct dax_region *dax_region,
> +		struct dev_dax *dev_dax, resource_size_t size)
> +{
> +	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
> +	resource_size_t dev_size = dev_dax_size(dev_dax);
> +	struct device *dev = &dev_dax->dev;
> +	resource_size_t alloc;
> +
> +	if (dev->driver)
> +		return -EBUSY;
> +	if (size == dev_size)
> +		return 0;
> +	if (size > dev_size && size - dev_size > avail)
> +		return -ENOSPC;
> +	if (size < dev_size)
> +		return dev_dax_shrink(dev_dax, size);
> +
> +	to_alloc = size - dev_size;
> +	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
> +			"resize of %pa misaligned\n", &to_alloc))
> +		return -ENXIO;
> +
> +retry:
> +	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
> +	if (alloc <= 0)
> +		return alloc;
>  	to_alloc -= alloc;
>  	if (to_alloc)
>  		goto retry;
> @@ -1198,7 +1225,8 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  
>  	to_alloc = range_len(&r);
>  	if (alloc_is_aligned(dev_dax, to_alloc))
> -		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
> +		rc = alloc_dev_dax_range(&dax_region->res, dev_dax, r.start,
> +					 to_alloc);
>  	up_write(&dax_dev_rwsem);
>  	up_write(&dax_region_rwsem);
>  
> @@ -1466,7 +1494,8 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	device_initialize(dev);
>  	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
>  
> -	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
> +	rc = alloc_dev_dax_range(&dax_region->res, dev_dax, dax_region->res.start,
> +				 data->size);
>  	if (rc)
>  		goto err_range;
>  
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
