Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1F733A9FF
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 22:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782859764; cv=none; b=PnqRskMheD4wbw9Cj4bs/7S4E2Dv6xk4PgCs9+NfAzRmonJDeCrGLb8FA1QGrhuJjR0hRy+Po1MBllbJNZYKVK1gt5v+yNkdFKWL2V5/BGMcIbzNTiWfQUUGFGT3GsbB4wbigVaSCr2MKyQpoRFOITOzwd4fwmAHeIIA5SJ+BR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782859764; c=relaxed/simple;
	bh=x+twdIo50q5ruYrtRoxqoi6Wz4inSHPDLfyzNBN+8Bs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FWjHbsPaC38H6LslpTnDDIaykz6apCf/hF6BoPeVbuD+JxK0zkaeaExp0mnnI1UsTfUYB9PbV6A7LoCxfLUZpMt9RN/85U/2JauGnWxPkVVRYfoeeRfbpqoR+v0eEr0AhLZqgHJeRExgsDHRzYdlxuqfYbEIBZCytJ/OYZCavcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gSzqvdth; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gSzqvdth"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782859763; x=1814395763;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x+twdIo50q5ruYrtRoxqoi6Wz4inSHPDLfyzNBN+8Bs=;
  b=gSzqvdthMe5YXGgWOmv7OL/cRQAx+WRUSNMRENi1m1MH4u8goV0R2Q41
   1ndoujgCg66qtynza4BUR4+xNdJ9mZuCvTJbkuhefsXC8n5RYjUf5M0jF
   RcHoEQXXXgqTTOtukcIl8bpayL3AEXx8H5yhrIc+iTsHqW6SsOwdm8xeH
   1wKIqHYSpS7euKAnhiluVuGLe7nkCjLG0YXEWNh39lihxUrz61oqDQuqM
   tzrMUClQra3g8qszRL4Iz6JriONRpblgk3HziSbN2rDT+6lI5UwaIhUYF
   Ts+foT0cIJH3cOWp6pWTX0cxi9XuBcsSt8rK+16Xz9UsD5EmKe09bnYaz
   g==;
X-CSE-ConnectionGUID: /faUrMtWTRWlMAlrdzaogw==
X-CSE-MsgGUID: 6oLG3uH2RAKekCagE5eFEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="101125806"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="101125806"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 15:49:19 -0700
X-CSE-ConnectionGUID: MotLqO2WSKS+BXh8YhYwAA==
X-CSE-MsgGUID: /N6907OAQLmEPdJ+SFKhXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="255971383"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.110.30]) ([10.125.110.30])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 15:49:18 -0700
Message-ID: <cac25102-258c-4081-b32f-4f33181f8c65@intel.com>
Date: Tue, 30 Jun 2026 15:49:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 16/31] cxl/extent: Validate DC extent partition
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-17-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-17-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/25/26 4:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Extend cxl_validate_extent() — the per-extent check of the add pipeline
> to check partition membership.
> 
> Resolves an extent's DPA to its containing DC partition.  Sharability is
> a property of the partition (part->shareable), taken from its CDAT DSMAS
> entry.
> 
> An extent from a sharable partition must carry a non-null tag, since hosts
> sharing the allocation key on that tag.  A null tag there is a device
> firmware bug; reject the extent.
> 
> shared_extn_seq validation is checked in cxl_check_group_seq() once the
> whole tag group is collected.
> 
> Based on patches by John Groves.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: John Groves <John@Groves.net>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> 
> ---
> Changes:
> 1. cxl_extent_dc_partition() declared static — it is only called
>  from extent.c at this point.  A subsequent commit ("cxl/mem: Enforce
>  tag-group semantics") drops static and adds the declaration to core.h
>  when mbox.c starts calling it.
> 2. In cxl_validate_extent(), declare the local uuid as a struct
>  (uuid_t uuid) and fill it via import_uuid(&uuid, extent->uuid) instead
>  of casting (uuid_t *)extent->uuid.
> ---
>  drivers/cxl/core/extent.c | 85 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 82 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 6e67e787d14d..2e770c5279c2 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -76,11 +76,67 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
>  	return no_free_ptr(group);
>  }
>  
> +/*
> + * Find the DC (Dynamic Capacity) partition that fully contains @ext_range,
> + * or NULL if the extent falls outside every DC partition on this memdev.
> + * The returned pointer is owned by mds->cxlds.part[] and lives for the
> + * lifetime of the memdev.
> + */
> +static const struct cxl_dpa_partition *
> +cxl_extent_dc_partition(struct cxl_memdev_state *mds,
> +			struct cxl_extent *extent,
> +			struct range *ext_range)
> +{
> +	struct cxl_dev_state *cxlds = &mds->cxlds;
> +	struct device *dev = mds->cxlds.dev;
> +
> +	/*
> +	 * A device-side error could cause end < start, which range_contains()
> +	 * would treat as contained in any partition.
> +	 */
> +	if (ext_range->end < ext_range->start) {
> +		dev_err_ratelimited(dev,
> +				    "DC extent DPA %pra (%pU) has invalid length (firmware bug)\n",
> +				    ext_range, extent->uuid);
> +		return NULL;
> +	}
> +
> +	for (int i = 0; i < cxlds->nr_partitions; i++) {
> +		struct cxl_dpa_partition *part = &cxlds->part[i];
> +		struct range partition_range = {
> +			.start = part->res.start,
> +			.end = part->res.end,
> +		};
> +
> +		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM_1)
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
> + *   - Sharability is a property of the partition (part->shareable), not of
> + *     the shared_extn_seq value: a sharable-partition extent must carry a
> + *     non-null tag, and a non-sharable-partition extent must leave
> + *     shared_extn_seq reserved (zero).  The dense 0..n-1 numbering within a
> + *     sharable tag group is validated separately (cxl_check_group_seq()).
> + *   - DPA resolves to an endpoint decoder attached to a region.
> + *   - The extent's range is fully contained in that ED's DPA resource.
>   *
>   * Caller must hold cxl_rwsem.region for read (cxl_dpa_to_region()).
>   * On success, @out_cxled / @out_cxlr_dax / @out_ext_range carry the
> @@ -94,6 +150,8 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
>  {
>  	u64 start_dpa = le64_to_cpu(extent->start_dpa);
>  	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> +	struct device *dev = mds->cxlds.dev;
> +	const struct cxl_dpa_partition *part;
>  	struct cxl_endpoint_decoder *cxled;
>  	struct cxl_region *cxlr;
>  	struct range ext_range = (struct range) {
> @@ -101,6 +159,27 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
>  		.end = start_dpa + le64_to_cpu(extent->length) - 1,
>  	};
>  	struct range ed_range;
> +	uuid_t uuid;
> +
> +	import_uuid(&uuid, extent->uuid);
> +
> +	part = cxl_extent_dc_partition(mds, extent, &ext_range);
> +	if (!part)
> +		return -ENXIO;
> +
> +	if (part->shareable) {
> +		if (uuid_is_null(&uuid)) {
> +			dev_err_ratelimited(dev,
> +				"DC extent DPA %pra: sharable-partition extent has null tag (firmware bug)\n",
> +				&ext_range);
> +			return -ENXIO;
> +		}
> +	} else if (le16_to_cpu(extent->shared_extn_seq)) {
> +		dev_err_ratelimited(dev,
> +			"DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=%u (firmware bug)\n",
> +			&ext_range, &uuid, le16_to_cpu(extent->shared_extn_seq));
> +		return -ENXIO;
> +	}
>  
>  	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
>  	if (!cxlr || !cxlr->cxlr_dax)

