Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC3532AAAB
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 23:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780012444; cv=none; b=UwhJnHCs4cdjGI4jAWF3n7IYLH5kfUx/nhbXmrw1uDyRv+i+V1kyHdNVdFXE/fWIP3xpHfD69elI1V7Xwm86r5Ofxv/pk+dXM1aJlmdWGBDu83SxPbUFDgH/KQdru4Q3j1SVX8SeJt3rgZI/+MLR/R964HAdfIdYYDyhIcBbfl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780012444; c=relaxed/simple;
	bh=mYKqwkkUkQJLp87q4Qq6ZTxIFL18Ov7wXlF6oVqW39g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QIsAZ/M2N2SaTzsmNtyxI7IKO0WXxn+jRY5iegTOWBruoKAZACrclu0Nn/pg9n6EpLXhl9jkRo2FlkFJL6ONLzhYizgS0ypv1pq5DpDJANcD3v6BZzID8va36VBPYXzxsAFAwS1oRuc4D3ZMd2yOiFpA5DDEtUWG3Ua3tzawtj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jp6dLdvO; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jp6dLdvO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780012442; x=1811548442;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mYKqwkkUkQJLp87q4Qq6ZTxIFL18Ov7wXlF6oVqW39g=;
  b=Jp6dLdvOYMhBfiKTyEiZk8Smdhuv7tH7gAEzi5ekP07sB7OKRYrpdhyX
   igZKhlRKsLKSfMnPPpydD07OrOJ4jx9+bS9ZsBhgX4USUnzs8BtBenWu4
   +t9uttABZa+2EMGORrjLGtw+C5hBhdfZgrzTQrEkHlQQUG1+tRgfpFXqm
   NhcoVoUSNzL1Kh+CW2Qw90C+N7krng5MBVcXeuqkfNMUihMgM26e/obWP
   lCeoPbBlyQT/cg24/fPrPni6Hb+TathIkqygJtNiUOQ+CmNgBPtyJZHUw
   gMv7AkdXv8Xcgv7L/bDdR94/I0oTEGiG0qESxZSOwwEW/Wz0BF8XxrmyV
   Q==;
X-CSE-ConnectionGUID: BwPCsvYgSnimFNtCnlfQHw==
X-CSE-MsgGUID: +a/DS3c1RXuAHzHwSKlZAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="84722740"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="84722740"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 16:53:46 -0700
X-CSE-ConnectionGUID: BDCcJaIWRj2UhBj6q8Kd+A==
X-CSE-MsgGUID: L59EcbWQTPOMPCsrGjqmfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="238505693"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 16:53:44 -0700
Message-ID: <e5bd578c-15dc-4b69-9cd2-2eb3c3aa516a@intel.com>
Date: Thu, 28 May 2026 16:53:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 22/31] cxl + dax: Release dax_resources on DCD Release
 Capacity events
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>, Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <e6cea279dcb208684c08b756f6de65438529ad65.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <e6cea279dcb208684c08b756f6de65438529ad65.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> Implement the release path that mirrors the add path: when the
> device asks for capacity back, the dax layer tears down the
> per-extent resources for the whole tag group atomically.
> 
> If any extent in the group is still mapped by a dev_dax, the release
> is refused with -EBUSY and no state changes; the cxl side then leaves
> the tag group intact and the device retries.
> 
> Also add a rollback to the add path: if any per-extent registration
> fails midway through a group, undo the ones already added so a
> partial group never leaks into the dax region.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Just a nit below

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> 
> ---
> Changes:
> [anisa: split out from the original "Surface dc_extents" commit;
>  fills in the RELEASE half of the bridge, moves the cxl-side RELEASE
>  notify into this commit, and adds the rollback path to ADD.]
> ---
>  drivers/cxl/core/extent.c | 13 +++++++++
>  drivers/dax/bus.c         | 59 +++++++++++++++++++++++++++++++++++++++
>  drivers/dax/cxl.c         | 54 +++++++++++++++++++++++++++--------
>  drivers/dax/dax-private.h |  8 ++++--
>  4 files changed, 120 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 3fc4b7292664..2c8edfe53c0a 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -532,6 +532,7 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
>  	struct range dpa_range;
>  	unsigned long idx;
>  	uuid_t tag;
> +	int rc;
>  
>  	dpa_range = (struct range) {
>  		.start = start_dpa,
> @@ -588,6 +589,18 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
>  		return -EINVAL;
>  	}
>  
> +	rc = cxlr_notify_extent(cxlr, DCD_RELEASE_CAPACITY, group);
> +	if (rc) {
> +		/*
> +		 * dax layer refused (-EBUSY) or failed (-ENOMEM, etc.).  Do
> +		 * not proceed to tear down the tag group — leave its
> +		 * dax_resources alive so we do not free them out from under
> +		 * live dev_dax ranges.  The device will retry the release.
> +		 */
> +		return 0;
> +	}
> +
> +	/* Release the entire tag group */
>  	rm_tag_group(group);
>  	return 0;
>  }
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index a6ee59f2d8a1..6368bdfdf93a 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -253,6 +253,65 @@ int dax_region_add_resource(struct dax_region *dax_region,
>  }
>  EXPORT_SYMBOL_GPL(dax_region_add_resource);
>  
> +int dax_region_rm_resource(struct dax_region *dax_region,
> +			   struct device *dev)
> +{
> +	struct dax_resource *dax_resource;
> +
> +	guard(rwsem_write)(&dax_region_rwsem);
> +
> +	dax_resource = dev_get_drvdata(dev);
> +	if (!dax_resource)
> +		return 0;
> +
> +	if (dax_resource->use_cnt)
> +		return -EBUSY;
> +
> +	/*
> +	 * release the resource under dax_region_rwsem to avoid races with
> +	 * users trying to use the extent
> +	 */
> +	__dax_release_resource(dax_resource);
> +	dev_set_drvdata(dev, NULL);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_region_rm_resource);

No reason to export. Seems only used within DAX.

DJ

> +
> +/**
> + * dax_region_rm_resources - atomically remove a set of dax_resources.
> + *
> + * Walk @devs twice under dax_region_rwsem.  First pass refuses the
> + * operation if any member's use_cnt is non-zero; second pass releases
> + * each.  This gives refuse-all-or-none semantics across the set, which
> + * a tag group's atomic release relies on.  Devices with no
> + * dax_resource attached are silently skipped.
> + */
> +int dax_region_rm_resources(struct dax_region *dax_region,
> +			    struct device * const *devs, unsigned int n)
> +{
> +	unsigned int i;
> +
> +	guard(rwsem_write)(&dax_region_rwsem);
> +
> +	for (i = 0; i < n; i++) {
> +		struct dax_resource *r = dev_get_drvdata(devs[i]);
> +
> +		if (r && r->use_cnt)
> +			return -EBUSY;
> +	}
> +
> +	for (i = 0; i < n; i++) {
> +		struct dax_resource *r = dev_get_drvdata(devs[i]);
> +
> +		if (!r)
> +			continue;
> +		__dax_release_resource(r);
> +		dev_set_drvdata(devs[i], NULL);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_region_rm_resources);
> +
>  bool static_dev_dax(struct dev_dax *dev_dax)
>  {
>  	return is_static(dev_dax->region);
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 690cf625e052..04b73315a8f2 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -44,19 +44,52 @@ static int cxl_dax_group_add(struct dax_region *dax_region,
>  
>  	xa_for_each(&group->dc_extents, index, dc_extent) {
>  		rc = __cxl_dax_add_resource(dax_region, dc_extent);
> -		if (rc)
> +		if (rc) {
> +			/*
> +			 * Unwind every dax_resource already added for this
> +			 * group; one rm per owner suffices.
> +			 */
> +			struct dc_extent *u;
> +			unsigned long uidx;
> +
> +			xa_for_each(&group->dc_extents, uidx, u) {
> +				if (u == dc_extent)
> +					break;
> +				dax_region_rm_resource(dax_region, &u->dev);
> +			}
>  			return rc;
> +		}
>  	}
>  	return 0;
>  }
>  
> -/*
> - * RELEASE is still a stub here — the atomic dax_region_rm_resources API
> - * and its wire-up land in the next commit.  An incoming RELEASE returns
> - * success and the cxl side proceeds to rm_tag_group(), which device-
> - * unregisters each dc_extent; the devm action armed by
> - * dax_region_add_resource() then tears down each dax_resource.
> - */
> +static int cxl_dax_group_rm(struct dax_region *dax_region,
> +			    struct cxl_dc_tag_group *group)
> +{
> +	struct dc_extent *dc_extent;
> +	struct device **devs;
> +	unsigned long index;
> +	unsigned int n = 0;
> +	int rc;
> +
> +	if (!group->nr_extents)
> +		return 0;
> +
> +	devs = kmalloc_array(group->nr_extents, sizeof(*devs), GFP_KERNEL);
> +	if (!devs)
> +		return -ENOMEM;
> +
> +	xa_for_each(&group->dc_extents, index, dc_extent) {
> +		if (n == group->nr_extents)
> +			break;
> +		devs[n++] = &dc_extent->dev;
> +	}
> +
> +	rc = dax_region_rm_resources(dax_region, devs, n);
> +	kfree(devs);
> +	return rc;
> +}
> +
>  static int cxl_dax_region_notify(struct device *dev,
>  				 struct cxl_notify_data *notify_data)
>  {
> @@ -68,10 +101,7 @@ static int cxl_dax_region_notify(struct device *dev,
>  	case DCD_ADD_CAPACITY:
>  		return cxl_dax_group_add(dax_region, group);
>  	case DCD_RELEASE_CAPACITY:
> -		dev_dbg(&cxlr_dax->dev,
> -			"DCD RELEASE notify (tag %pUb): no-op (stub)\n",
> -			&group->uuid);
> -		return 0;
> +		return cxl_dax_group_rm(dax_region, group);
>  	case DCD_FORCED_CAPACITY_RELEASE:
>  	default:
>  		dev_err(&cxlr_dax->dev, "Unknown DC event %d\n",
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index f2ae5918f94d..414813a6137f 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -146,13 +146,17 @@ struct dax_resource {
>  };
>  
>  /*
> - * Similar to run_dax() dax_region_add_resource() is exported but is not
> - * intended to be a generic operation outside the dax subsystem.  It is only
> + * Similar to run_dax() dax_region_{add,rm}_resource() are exported but are not
> + * intended to be generic operations outside the dax subsystem.  They are only
>   * generic between the dax layer and the dax drivers.
>   */
>  int dax_region_add_resource(struct dax_region *dax_region, struct device *dev,
>  			    resource_size_t start, resource_size_t length,
>  			    const uuid_t *tag, u16 seq_num);
> +int dax_region_rm_resource(struct dax_region *dax_region,
> +			   struct device *dev);
> +int dax_region_rm_resources(struct dax_region *dax_region,
> +			    struct device * const *devs, unsigned int n);
>  
>  static inline struct dev_dax *to_dev_dax(struct device *dev)
>  {

