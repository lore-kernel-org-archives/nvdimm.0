Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F9650255A
	for <nvdimm@lists.linux.dev>; Mon, 21 Sep 2026 21:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024486; cv=none; b=Sq3sdzKweCBL81HFUQbDk1GHeJdbLjpbEiBWtXVatNtMw4bJRDfaHO21tpYaD6RySqP+3NXXite4N8X6cH4z2aLVNkgldy3V/nU3h3B8Rml14VJQSuNP5MfjTiwcGmlMSKT05mhUNvSApbTA7YXo1Bb1mCUBqXmyDBw6kEew3pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024486; c=relaxed/simple;
	bh=+3cm34frUySXEiXu/xShgeitBk80UqrXwLaGcWJhGn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mNXroVIvIXDGRnULHfKUS2vGvsnXiNcUPPQkOlcjPOq+0cbjutLGjBcORR7G3/MQvJmfN4B7xvn64ef05as4pAx65oZ4Jk6vuBFd5Fs13cyLcEs9L0shjUoYxSZTku7BP5qDiox1oVkIK+JQPEpRUDQTnw1EHLfYENMzGvEqm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5BY+IL4; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5BY+IL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790024484; x=1821560484;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+3cm34frUySXEiXu/xShgeitBk80UqrXwLaGcWJhGn4=;
  b=N5BY+IL4wDwYNCCDUtoMF/WlYKLYk7qbmemZsN0ltRoZd6AZxmM4CROE
   QDZhpuSWcBc1ikUC3FR43NyjwCc0q35i6kWKy2KIPP4Q82DUvsdDHm/a7
   jWNrsqku1FqaCkKWqPSNz8bnD2zAXa14LNb2bQg/lgwehLEAxK51EJ5L/
   VsJPokD9iYY16idkcQ+PMVHReCEn6KhQALGqCQoH4d8MeAlHPBsBTuPHq
   crr3fSXVp7rgDD0h1nziiQFnJUI7qyC5TnruRY1X5cuT4iUKHkIwU0rZ5
   AQOYIain/O+MgOESJDXF20+WJuQ95Hlb2iZ+74z5y5u+8tvYiypRLaiXm
   w==;
X-CSE-ConnectionGUID: 0PFiK/QJQ+KyzTZohNBiQg==
X-CSE-MsgGUID: zZUrtVOPST64tL7274lQlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108072528"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="108072528"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 14:01:23 -0700
X-CSE-ConnectionGUID: S63vS3wwRuOZWYaeKE0W8w==
X-CSE-MsgGUID: 1NkxlgfvQEGq80hRR8+2bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="272993896"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.234]) ([10.125.109.234])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 14:01:21 -0700
Message-ID: <8a90ff33-97e4-4796-a8a6-f484760557ca@intel.com>
Date: Mon, 21 Sep 2026 14:01:20 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dax/bus: fix Device DAX range alignment validation
To: Muchun Song <songmuchun@bytedance.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
 <20260915095621.3744167-2-songmuchun@bytedance.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260915095621.3744167-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/15/26 2:56 AM, Muchun Song wrote:
> dev_dax->align describes the page size used by a Device DAX mapping.
> Both the start and size of every range must therefore be aligned to it;
> otherwise the starting PFN cannot represent a naturally aligned page of
> that size.
> 
> Only range sizes are currently validated. A dynamic device can therefore
> select a large-page alignment and allocate a range whose start is not
> naturally aligned to that page size. The device binds successfully, but a
> subsequent write to a userspace mapping may trigger a kernel panic.
> 
> The automatic resize path can also split a size-aligned request across
> arbitrary free gaps. When devices with different alignments fragment a
> region, this can extend a range by less than its alignment. A later
> allocation then fails, leaving the failed resize partially applied.
> 
> Validate both the start and size of allocated and adjusted ranges. Make
> the resize path account only for usable aligned space before changing any
> ranges, and skip gaps that cannot satisfy the device alignment. Initialize
> the device alignment before allocating its initial range so that all
> allocations use the same validation.
> 
> A mapping with an unaligned start is now rejected with -EINVAL, while a
> naturally aligned mapping still binds successfully.
> 
> Fixes: 6d82120f4156 ("device-dax: add an 'align' attribute")
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  drivers/dax/bus.c | 143 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 109 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..54e4bbc98218 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -848,6 +848,44 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
>  	return 0;
>  }
>  
> +static inline unsigned long dev_dax_min_align(struct dev_dax *dev_dax)
> +{
> +	return max_t(unsigned long, dev_dax->align, memremap_compat_align());
> +}
> +
> +static inline bool size_is_aligned(struct dev_dax *dev_dax, resource_size_t size)

Leave the name alloc_is_aligned() may generate less churn in this patch

DJ

> +{
> +	/*
> +	 * The minimum mapping granularity for a device instance is a
> +	 * single subsection, unless the arch says otherwise.
> +	 */
> +	return IS_ALIGNED(size, dev_dax_min_align(dev_dax));
> +}
> +
> +static inline bool range_is_aligned(struct dev_dax *dev_dax, u64 start,
> +				    resource_size_t size)
> +{
> +	return IS_ALIGNED(start | size, dev_dax_min_align(dev_dax));
> +}
> +
> +static resource_size_t
> +aligned_gap_size(struct dev_dax *dev_dax, resource_size_t *start,
> +		 resource_size_t end)
> +{
> +	resource_size_t aligned_start = ALIGN(*start, dev_dax_min_align(dev_dax));
> +	resource_size_t size;
> +
> +	if (aligned_start < *start || aligned_start > end)
> +		return 0;
> +
> +	size = ALIGN_DOWN(end - aligned_start + 1, dev_dax_min_align(dev_dax));
> +	if (!size)
> +		return 0;
> +
> +	*start = aligned_start;
> +	return size;
> +}
> +
>  static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
>  		resource_size_t size)
>  {
> @@ -870,6 +908,9 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
>  		return 0;
>  	}
>  
> +	if (!range_is_aligned(dev_dax, start, size))
> +		return -EINVAL;
> +
>  	alloc = __request_region(res, start, size, dev_name(dev), 0);
>  	if (!alloc)
>  		return -ENOMEM;
> @@ -923,6 +964,9 @@ static int adjust_dev_dax_range(struct dev_dax *dev_dax, struct resource *res, r
>  	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"))
>  		return -EINVAL;
>  
> +	if (!range_is_aligned(dev_dax, range->start, size))
> +		return -EINVAL;
> +
>  	rc = adjust_resource(res, range->start, size);
>  	if (rc)
>  		return rc;
> @@ -955,15 +999,6 @@ static ssize_t size_show(struct device *dev,
>  	return sysfs_emit(buf, "%llu\n", size);
>  }
>  
> -static bool alloc_is_aligned(struct dev_dax *dev_dax, resource_size_t size)
> -{
> -	/*
> -	 * The minimum mapping granularity for a device instance is a
> -	 * single subsection, unless the arch says otherwise.
> -	 */
> -	return IS_ALIGNED(size, max_t(unsigned long, dev_dax->align, memremap_compat_align()));
> -}
> -
>  static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
>  {
>  	resource_size_t to_shrink = dev_dax_size(dev_dax) - size;
> @@ -1030,30 +1065,55 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
>  	return true;
>  }
>  
> +static resource_size_t
> +dax_region_aligned_avail_size(struct dax_region *dax_region,
> +			      struct dev_dax *dev_dax)
> +{
> +	struct resource *region_res = &dax_region->res;
> +	resource_size_t start = region_res->start;
> +	resource_size_t avail = 0;
> +	struct resource *res;
> +
> +	lockdep_assert_held_write(&dax_region_rwsem);
> +
> +	for_each_dax_region_resource(dax_region, res) {
> +		if (res->start > start) {
> +			resource_size_t gap_start = start;
> +
> +			avail += aligned_gap_size(dev_dax, &gap_start,
> +					res->start - 1);
> +		}
> +		start = res->end + 1;
> +	}
> +	if (start <= region_res->end)
> +		avail += aligned_gap_size(dev_dax, &start, region_res->end);
> +
> +	return avail;
> +}
> +
>  static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  		struct dev_dax *dev_dax, resource_size_t size)
>  {
> -	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
>  	resource_size_t dev_size = dev_dax_size(dev_dax);
>  	struct resource *region_res = &dax_region->res;
>  	struct device *dev = &dev_dax->dev;
>  	struct resource *res, *first;
> -	resource_size_t alloc = 0;
> +	resource_size_t alloc, to_alloc;
>  	int rc;
>  
>  	if (dev->driver)
>  		return -EBUSY;
>  	if (size == dev_size)
>  		return 0;
> -	if (size > dev_size && size - dev_size > avail)
> -		return -ENOSPC;
>  	if (size < dev_size)
>  		return dev_dax_shrink(dev_dax, size);
>  
>  	to_alloc = size - dev_size;
> -	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
> -			"resize of %pa misaligned\n", &to_alloc))
> +	if (dev_WARN_ONCE(dev, !size_is_aligned(dev_dax, to_alloc),
> +			  "resize of %pa misaligned\n", &to_alloc))
>  		return -ENXIO;
> +	if (to_alloc > dax_region_aligned_avail_size(dax_region, dev_dax))
> +		return -ENOSPC;
>  
>  	/*
>  	 * Expand the device into the unused portion of the region. This
> @@ -1062,37 +1122,52 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  	 */
>  retry:
>  	first = region_res->child;
> -	if (!first)
> -		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
> +	if (!first) {
> +		resource_size_t start = region_res->start;
> +
> +		alloc = aligned_gap_size(dev_dax, &start, region_res->end);
> +		return alloc_dev_dax_range(dev_dax, start,
> +				min(alloc, to_alloc));
> +	}
>  
>  	rc = -ENOSPC;
>  	for (res = first; res; res = res->sibling) {
>  		struct resource *next = res->sibling;
> +		resource_size_t start, end;
>  
>  		/* space at the beginning of the region */
>  		if (res == first && res->start > dax_region->res.start) {
> -			alloc = min(res->start - dax_region->res.start, to_alloc);
> -			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
> -			break;
> +			start = dax_region->res.start;
> +			end = res->start - 1;
> +			alloc = min(aligned_gap_size(dev_dax, &start, end), to_alloc);
> +			if (alloc) {
> +				rc = alloc_dev_dax_range(dev_dax, start, alloc);
> +				break;
> +			}
>  		}
>  
> -		alloc = 0;
>  		/* space between allocations */
> -		if (next && next->start > res->end + 1)
> -			alloc = min(next->start - (res->end + 1), to_alloc);
> -
> -		/* space at the end of the region */
> -		if (!alloc && !next && res->end < region_res->end)
> -			alloc = min(region_res->end - res->end, to_alloc);
> +		if (next) {
> +			if (next->start <= res->end + 1)
> +				continue;
> +			end = next->start - 1;
> +		} else {
> +			/* space at the end of the region */
> +			if (res->end >= region_res->end)
> +				continue;
> +			end = region_res->end;
> +		}
>  
> +		start = res->end + 1;
> +		alloc = min(aligned_gap_size(dev_dax, &start, end), to_alloc);
>  		if (!alloc)
>  			continue;
>  
> -		if (adjust_ok(dev_dax, res)) {
> +		if (start == res->end + 1 && adjust_ok(dev_dax, res)) {
>  			rc = adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
>  			break;
>  		}
> -		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc);
> +		rc = alloc_dev_dax_range(dev_dax, start, alloc);
>  		break;
>  	}
>  	if (rc)
> @@ -1115,7 +1190,7 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
>  	if (rc)
>  		return rc;
>  
> -	if (!alloc_is_aligned(dev_dax, val)) {
> +	if (!size_is_aligned(dev_dax, val)) {
>  		dev_dbg(dev, "%s: size: %lld misaligned\n", __func__, val);
>  		return -EINVAL;
>  	}
> @@ -1201,7 +1276,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  	}
>  
>  	to_alloc = range_len(&r);
> -	if (alloc_is_aligned(dev_dax, to_alloc))
> +	if (size_is_aligned(dev_dax, to_alloc))
>  		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
>  	up_write(&dax_dev_rwsem);
>  	up_write(&dax_region_rwsem);
> @@ -1224,9 +1299,9 @@ static ssize_t dev_dax_validate_align(struct dev_dax *dev_dax)
>  	int i;
>  
>  	for (i = 0; i < dev_dax->nr_range; i++) {
> -		size_t len = range_len(&dev_dax->ranges[i].range);
> +		struct range *range = &dev_dax->ranges[i].range;
>  
> -		if (!alloc_is_aligned(dev_dax, len)) {
> +		if (!range_is_aligned(dev_dax, range->start, range_len(range))) {
>  			dev_dbg(dev, "%s: align %u invalid for range %d\n",
>  				__func__, dev_dax->align, i);
>  			return -EINVAL;
> @@ -1464,6 +1539,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  		return ERR_PTR(-ENOMEM);
>  
>  	dev_dax->region = dax_region;
> +	dev_dax->align = dax_region->align;
>  	if (is_static(dax_region)) {
>  		if (dev_WARN_ONCE(parent, data->id < 0,
>  				"dynamic id specified to static region\n")) {
> @@ -1522,7 +1598,6 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  
>  	dev_dax->dax_dev = dax_dev;
>  	dev_dax->target_node = dax_region->target_node;
> -	dev_dax->align = dax_region->align;
>  	ida_init(&dev_dax->ida);
>  
>  	dev_dax->memmap_on_memory = data->memmap_on_memory;

