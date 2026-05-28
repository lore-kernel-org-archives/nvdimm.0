Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7A6340405
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 22:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780006414; cv=none; b=aIMuYTGHZ1rWWULt9VwKOue/AvhNLX/ypHUjCsbz1nMrvoYU8jlZ9e8e0+LJirRkRiAbYVrtoN1p174B7HZh63rSkfK6ZafKw3ODLFcEX1BTk1QrFWh/6hW6LVQaYUh0jmZgyWQ3jdiynFx1FLSa2BV7S3cGz+Xq1fDWAOsmKCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780006414; c=relaxed/simple;
	bh=pZWUi5egFh6lJP70BlWMbk5xNe8ubke/1JPPEpPlGf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dzzTfZiTMMoFewrdh7iDOx6rjuNUy7nw1388b8tXPUkuLCV9gl/uYrz1/JvXdiyI/qHRWTa3AqG18YBeW7BfCO/w+0eoM+5pzoDAnnS+XrOV9qScOjXxFhv153n7uHGSDbCytu1SHx5q08CqrPzy8G24g7A2ngVtPrRMNfGC9Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKeCPdDG; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKeCPdDG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780006412; x=1811542412;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pZWUi5egFh6lJP70BlWMbk5xNe8ubke/1JPPEpPlGf8=;
  b=CKeCPdDGo8lZd1/iabQ2B+j+mv0hHBzyeSL/GuYDIoo9J3CImAlvpV1D
   PrrBdAV6h93/kW0Lp8jsZULozoHvlj4d0ZaecvyQ/mfeDt3cL3rOZO7tC
   7565X6e1QhF0UxqkFvpriZ5KsLsbws6sN7i4PI2u1m0xb6LkqFpdDeAO5
   cbDc7WhLJkj/SoZ9EUSN6vwG/s30CtpjzlBZaFGzo1EKPb/bWiratTEgt
   3LuZn2qViDqtL9McQSTUmjy9+4aIyD71cWVvJmfp4DAKZ7ZweVd7QZOYF
   QGG1YrouDubX4wpsqpA37xa6SusXuxAZKXKTvW4+BjUqKzh9wnwH7zzrf
   Q==;
X-CSE-ConnectionGUID: /qaGk43cRHyQ562OUVFEsA==
X-CSE-MsgGUID: 0sxb28gGR76gE2d1C8OYJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="81042568"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="81042568"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:13:31 -0700
X-CSE-ConnectionGUID: 0jKmS4V4QfS4JzRU03b4Wg==
X-CSE-MsgGUID: OXEcv4WhTDmfUUf94sakBg==
X-ExtLoop1: 1
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:13:30 -0700
Message-ID: <de6c7708-64cc-4ada-94cb-4916022b706d@intel.com>
Date: Thu, 28 May 2026 15:13:29 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 18/31] cxl/extent: Handle DC Release Capacity events
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>, Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <b6069cc18b77f9eb7b2f1655721c8206fc447733.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <b6069cc18b77f9eb7b2f1655721c8206fc447733.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> Replace the no-op ack stub for cxl_rm_extent() with the real teardown:
> resolve the released DPA range to its region and endpoint decoder,
> locate the matching dc_extent in cxlr_dax->dc_extents (filtering by
> cxled, range containment, and tag), and tear down the entire containing
> tag group atomically through rm_tag_group().  Partial release is not
> supported.
> 
> rm_tag_group() invalidates caches once for the whole group (no mappings
> exist at this point — partial release is not supported, so all members
> are leaving together), then walks the group's dc_extents and releases
> each via its devm action installed at online_tag_group() time.
> 
> cxl_region_invalidate_memregion() becomes non-static and is declared
> in core.h so rm_tag_group() can flush caches before tearing the group down.
> 
> When the released range maps to no region (host crashed before
> persisting acceptance, region destruction raced device release, or the
> device is confused) the host has nothing to drop, so reply via
> memdev_release_extent() to keep the device's view consistent.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> [anisa: restructured from the original "Process dynamic partition
>  events" monolith; this commit replaces the stubbed release with the
>  real walk-and-tear-down of the matching tag group.]
> ---
>  drivers/cxl/core/core.h   |   8 +++
>  drivers/cxl/core/extent.c | 101 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/mbox.c   |  19 -------
>  drivers/cxl/core/region.c |   2 +-
>  4 files changed, 110 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 30b6b05b155b..65daaaadf68e 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -28,6 +28,8 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
>  	return container_of(cxlds, struct cxl_memdev_state, cxlds);
>  }
>  
> +int cxl_region_invalidate_memregion(struct cxl_region *cxlr);

Doesn't this need to go within CONFIG_CXL_REGION?

> +
>  #ifdef CONFIG_CXL_REGION
>  
>  struct cxl_region_context {
> @@ -67,6 +69,7 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
>  
>  int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
>  		   u16 seq_num);
> +int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
>  int online_tag_group(struct cxl_dc_tag_group *group);
>  #else
>  static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
> @@ -79,6 +82,11 @@ static inline int cxl_add_extent(struct cxl_memdev_state *mds,
>  {
>  	return 0;
>  }
> +static inline int cxl_rm_extent(struct cxl_memdev_state *mds,
> +				struct cxl_extent *extent)
> +{
> +	return 0;
> +}
>  static inline int online_tag_group(struct cxl_dc_tag_group *group)
>  {
>  	return 0;
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index b01507022cff..51116c8139ed 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -344,6 +344,107 @@ static void dc_extent_unregister(void *ext)
>  	device_unregister(&dc_extent->dev);
>  }
>  
> +static void rm_tag_group(struct cxl_dc_tag_group *group)
> +{
> +	struct device *region_dev = &group->cxlr_dax->dev;
> +	struct dc_extent *dc_extent;
> +	unsigned long index;
> +
> +	/*
> +	 * Tagged allocations release atomically.  Invalidate caches once
> +	 * for the whole group (no mappings exist at this point — partial
> +	 * release is not supported, so all members are leaving use
> +	 * together) before tearing down each dc_extent device.
> +	 *
> +	 * Pin @group across the walk: each devm_release_action runs the
> +	 * dc_extent_unregister action synchronously, which drops the last
> +	 * reference on the dc_extent device and fires dc_extent_release.
> +	 * The release decrements group->nr_extents and, on the final
> +	 * decrement, frees @group.  Without the pin the next iteration's
> +	 * xa_find_after() dereferences a freed xarray.
> +	 */
> +	cxl_region_invalidate_memregion(group->cxlr_dax->cxlr);

check return value?

> +
> +	group->nr_extents++;
> +	xa_for_each(&group->dc_extents, index, dc_extent)
> +		devm_release_action(region_dev, dc_extent_unregister, dc_extent);
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);
> +}
> +
> +int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
> +{
> +	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> +	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_dax_region *cxlr_dax;
> +	struct cxl_dc_tag_group *group;
> +	struct dc_extent *dc_extent;
> +	struct cxl_region *cxlr;
> +	struct range dpa_range;
> +	unsigned long idx;
> +	uuid_t tag;
> +
> +	dpa_range = (struct range) {
> +		.start = start_dpa,
> +		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> +	};
> +
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> +	if (!cxlr) {
> +		/*
> +		 * No region can happen here for a few reasons:
> +		 *
> +		 * 1) Extents were accepted and the host crashed/rebooted
> +		 *    leaving them in an accepted state.  On reboot the host
> +		 *    has not yet created a region to own them.
> +		 *
> +		 * 2) Region destruction won the race with the device releasing
> +		 *    all the extents.  Here the release will be a duplicate of
> +		 *    the one sent via region destruction.
> +		 *
> +		 * 3) The device is confused and releasing extents for which no
> +		 *    region ever existed.
> +		 *
> +		 * In all these cases make sure the device knows we are not
> +		 * using this extent.
> +		 */
> +		memdev_release_extent(mds, &dpa_range);
> +		return -ENXIO;
> +	}
> +
> +	cxlr_dax = cxlr->cxlr_dax;

Does it need to check if cxlr_dax is NULL?

DJ

> +	import_uuid(&tag, extent->uuid);
> +
> +	/*
> +	 * Find the dc_extent whose DPA range covers the released range and
> +	 * whose tag matches.  The release targets the entire containing
> +	 * tag group atomically; partial release is not supported.
> +	 */
> +	group = NULL;
> +	xa_for_each(&cxlr_dax->dc_extents, idx, dc_extent) {
> +		if (dc_extent->cxled != cxled)
> +			continue;
> +		if (!range_contains(&dc_extent->dpa_range, &dpa_range))
> +			continue;
> +		if (!uuid_equal(&dc_extent->group->uuid, &tag))
> +			continue;
> +		group = dc_extent->group;
> +		break;
> +	}
> +	if (!group) {
> +		dev_err(&cxlr_dax->dev,
> +			"release DPA %pra (%pU) matches no dc_extent\n",
> +			&dpa_range, &tag);
> +		return -EINVAL;
> +	}
> +
> +	rm_tag_group(group);
> +	return 0;
> +}
> +
>  static void cleanup_pending_dc_extent(struct dc_extent *dc_extent)
>  {
>  	struct cxl_dc_tag_group *group = dc_extent->group;
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 545c48c9c373..70e6c4c9743c 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1587,25 +1587,6 @@ static int handle_add_event(struct cxl_memdev_state *mds,
>  	return rc;
>  }
>  
> -/*
> - * Stub: ack the release back to the device so it knows we are not
> - * using the range.  A later commit replaces this with the real
> - * teardown that walks the region's tag group and tears down the
> - * member dc_extent devices.
> - */
> -static int cxl_rm_extent(struct cxl_memdev_state *mds,
> -			 struct cxl_extent *extent)
> -{
> -	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> -	struct range dpa_range = {
> -		.start = start_dpa,
> -		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> -	};
> -
> -	memdev_release_extent(mds, &dpa_range);
> -	return 0;
> -}
> -
>  static char *cxl_dcd_evt_type_str(u8 type)
>  {
>  	switch (type) {
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 733d77c07493..317630d8bf2e 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -222,7 +222,7 @@ static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
>  	return xa_load(&port->regions, (unsigned long)cxlr);
>  }
>  
> -static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
> +int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
>  {
>  	if (!cpu_cache_has_invalidate_memregion()) {
>  		if (IS_ENABLED(CONFIG_CXL_REGION_INVALIDATION_TEST)) {

