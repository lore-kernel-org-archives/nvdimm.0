Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EED62F7EE9
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 21:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780004106; cv=none; b=pF6waWOdBdqSKAe0pSBpsa+ef19dDr3rcZpTtrgVWV/dmdR04/SYNwydaK1DKoLy/tzTyZte4QejfU9CZ9/kZDDxGf9dxtgm7TelVptToYuk2kN60gTsqxvzn9ZaHPjiXBgM6GphgXScWEiWXtN6JFRjYndCKaaVw5SgtXmBsuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780004106; c=relaxed/simple;
	bh=QQAyHkepO2PiZPfOVZh3FaAbLe+w7w6b05HiGhEdn+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j6Nvc9KHdJjqWBC5A2YHXj0Yc00h14hFHePHz5hcD3Vnc7fcMRpCX3FsPAh7AS5HWU10oHfMMW2ASRiuKVD1sY7ExxfhByBx8usMVSZHWSP4I77AK+in9omtTmY7q9Y/sUjWzNcUSwMe1XfAxH5nKmfPQV+z01Gv5/cuKBRnKHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0rCMY+g; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0rCMY+g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780004104; x=1811540104;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QQAyHkepO2PiZPfOVZh3FaAbLe+w7w6b05HiGhEdn+k=;
  b=M0rCMY+gPyJb5KeXBlqLdefk0ohWMJ4jfrgtBD6Ft2QTAQti5uPA/uql
   veDB+BqwHZn02ej6d+1rihUH2jqYGpBtkA8LxznxrkyTeBtAsPoEOO8bD
   uZBqeTXZ8IgIJWKnY7G7I80CzSBZMCA8jQ6W1Q5CE9ZUVx2PcpflIEVOg
   HpZOm8Ah/J0uQYRvs+e6CJVKLl9RayDxmbhFGUlpnTZwyfyOfm4uXfU2K
   5YmuTqN2Gx8+5ejArKwGsEJitleEbziSENKPzyUrjI6lPcNyivAr78RnU
   oVXD5KwpIsPU8jIfTYk2YJPU4KMOEBRSLsr9MsCRriVWqdnjNMHOcqoKZ
   g==;
X-CSE-ConnectionGUID: wcvcg3poQtKrQPWSvwXmAA==
X-CSE-MsgGUID: OEZKIZ4OSrKL5wisw6aWjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80849590"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80849590"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 14:34:51 -0700
X-CSE-ConnectionGUID: ZlO1f2NUSD+9KVp97G/Yvg==
X-CSE-MsgGUID: V+Ns9FntTkmCkvd5YhbfZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="238268385"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 14:34:50 -0700
Message-ID: <dbcfcbe8-5a4a-4b5d-b1f1-188e33eb2a4b@intel.com>
Date: Thu, 28 May 2026 14:34:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/31] cxl/extent: Validate DC extent partition
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>, Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <def526ee51b647e9256c7e777c6b7bd5cd647f89.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <def526ee51b647e9256c7e777c6b7bd5cd647f89.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> Extend cxl_validate_extent() — the per-extent check of the add pipeline
> to check partition membership.
> 
> Resolves an extent's DPA to its containing DC partition. Then based on
> if the partition is shareable:
> 
>   - Shareable: tag must be non-null and shared_extn_seq must be non-zero
>     — multiple hosts reading the same allocation rely on the device-
>     stamped 1..n sequence to assemble extents in agreed order.
>   - Non-sharable: shared_extn_seq must be zero — sequencing is
>     meaningless when only one host consumes the allocation; tag is
>     optional (null UUID permitted).
> 
> Any cross-mix is a device firmware bug; reject the extent.
> 
> Based on patches by John Groves.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Groves <John@Groves.net>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> [anisa: split out as a separate validation step]
> ---
>  drivers/cxl/core/core.h   |  4 ++
>  drivers/cxl/core/extent.c | 78 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 79 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 1bae80dbf991..30b6b05b155b 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -179,6 +179,10 @@ int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c);
>  int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
>  					struct access_coordinate *c);
>  void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range);
> +const struct cxl_dpa_partition *
> +cxl_extent_dc_partition(struct cxl_memdev_state *mds,
> +			struct cxl_extent *extent,
> +			struct range *ext_range);
>  
>  static inline struct device *port_to_host(struct cxl_port *port)
>  {
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 94128d06f4ed..b01507022cff 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -63,11 +63,55 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
>  	return no_free_ptr(group);
>  }
>  
> +/*
> + * Find the DC (Dynamic Capacity) partition that fully contains @ext_range,
> + * or NULL if the extent falls outside every DC partition on this memdev.
> + * The returned pointer is owned by mds->cxlds.part[] and lives for the
> + * lifetime of the memdev.
> + */
> +const struct cxl_dpa_partition *
> +cxl_extent_dc_partition(struct cxl_memdev_state *mds,
> +			struct cxl_extent *extent,
> +			struct range *ext_range)

This can be static, given it's only called in extent.c

> +{
> +	struct cxl_dev_state *cxlds = &mds->cxlds;
> +	struct device *dev = mds->cxlds.dev;
> +
> +	for (int i = 0; i < cxlds->nr_partitions; i++) {
> +		struct cxl_dpa_partition *part = &cxlds->part[i];
> +		struct range partition_range = {
> +			.start = part->res.start,
> +			.end = part->res.end,
> +		};
> +
> +		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM_A)
> +			continue;
> +
> +		if (range_contains(&partition_range, ext_range)) {
> +			dev_dbg(dev, "DC extent DPA %pra (DCR:%pra)(%pU)\n",
> +				ext_range, &partition_range, extent->uuid);
> +			return part;
> +		}
> +	}
> +
> +	dev_err_ratelimited(dev,
> +			    "DC extent DPA %pra (%pU) is not in a valid DC partition\n",
> +			    ext_range, extent->uuid);
> +	return NULL;
> +}
> +
>  /*
>   * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
> - * to its region/endpoint decoder and ext_range, and verify the range
> - * fits in the resolved endpoint decoder's DPA resource.  Further
> - * per-extent invariants layer into this function in subsequent commits.
> + * to its region/endpoint decoder and ext_range, and enforce every
> + * per-extent invariant the device must satisfy:
> + *
> + *   - DPA falls inside a Dynamic Capacity partition (cxl_extent_dc_partition).
> + *   - CDAT-sharability rules:
> + *       sharable:     tag must be non-null AND shared_extn_seq != 0
> + *       non-sharable: shared_extn_seq must be 0  (tag is optional)
> + *     Any cross-mixing is a device firmware bug.
> + *   - DPA resolves to an endpoint decoder attached to a region.
> + *   - The extent's range is fully contained in that ED's DPA resource.
>   *
>   * Caller must hold cxl_rwsem.region for read (cxl_dpa_to_region()).
>   * On success, @out_cxled / @out_cxlr_dax / @out_ext_range carry the
> @@ -81,6 +125,10 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
>  {
>  	u64 start_dpa = le64_to_cpu(extent->start_dpa);
>  	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> +	struct device *dev = mds->cxlds.dev;
> +	uuid_t *uuid = (uuid_t *)extent->uuid;

Consider using import_uuid() instead of direct cast.

> +	u16 seq = le16_to_cpu(extent->shared_extn_seq);
> +	const struct cxl_dpa_partition *part;
>  	struct cxl_endpoint_decoder *cxled;
>  	struct cxl_region *cxlr;
>  	struct range ext_range = (struct range) {
> @@ -89,6 +137,30 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
>  	};
>  	struct range ed_range;
>  
> +	part = cxl_extent_dc_partition(mds, extent, &ext_range);
> +	if (!part)
> +		return -ENXIO;
> +
> +	if (part->perf.shareable) {
> +		if (uuid_is_null(uuid)) {
> +			dev_err_ratelimited(dev,
> +				"DC extent DPA %pra: sharable-partition extent has null tag (firmware bug)\n",
> +				&ext_range);
> +			return -ENXIO;
> +		}
> +		if (seq == 0) {

I don't think this complies with the spec language. In r4.0 Table 8-230: "For extents describing shareable regions this field shall be within the range of 0 to n-1 where n is the number of extents, with each value appearing only once." So seq == 0 is an acceptable value.

Also, looking at cxl_add_pending() @ line ~1396, does shared seq number '0' holds special meanings? Maybe that needs to change? Also suggest adding comments to point out what's happening there if '0' is special. 

DJ


> +			dev_err_ratelimited(dev,
> +				"DC extent DPA %pra (%pU): sharable-partition extent missing shared_extn_seq (firmware bug)\n",
> +				&ext_range, uuid);
> +			return -ENXIO;
> +		}
> +	} else if (seq != 0) {
> +		dev_err_ratelimited(dev,
> +			"DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=%u (firmware bug)\n",
> +			&ext_range, uuid, seq);
> +		return -ENXIO;
> +	}
> +
>  	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
>  	if (!cxlr)
>  		return -ENXIO;

