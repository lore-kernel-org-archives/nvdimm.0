Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD6B30CB20
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 21:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758664144; cv=none; b=nuGnuF/B9swLSQE+frS5npis+IPtPOdABMe34NTu1AKlUfQi2ED/vQ61gJ3uv91sJkoRaZ9JG/g0E4+iiiePcAmbZZLlKxsioIq2Y4MyjVc509j07xy/XfVbLsszMdjeL8AvQ/553UpNjngZeGgZ4Gf4R7st4NYigQiQ6hvRKv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758664144; c=relaxed/simple;
	bh=ron+huWXYzX1vYHaRXTbyHyxCQgMZVHBaiigSqFwUto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HN37w3VOrGwqzu0rVxBW/mnTCNLTCIJEjfS41W7gA0Utkeoi2RBUreVPlJ71ToytRO9pBgttOGsHvpiwWYyut7ZGYwR6+hOBkzc82T5eBZwq3uQgbqYbQQ7ODJOFDbzX167fXFSUMagniBoIWczXyFluf6FTEfSQoE5uvrDN06I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YgpRBauf; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YgpRBauf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758664143; x=1790200143;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ron+huWXYzX1vYHaRXTbyHyxCQgMZVHBaiigSqFwUto=;
  b=YgpRBaufa0V1dITVBSNV/GbTYD8McB6H5nJp8WzJf0RIOAKxRE/2Bsgk
   xaM7OXHwqejY3e8JSyUTD/I++6Ileunb4G8bPc5DqTPiFelo6+tYMaXwY
   FKK+LnqCUoZ1Yw9JmTl2jSts09WrmtzKekc73+1nlRHM/iQ2pvqjQ4NNV
   fUHli9waLahCBBQ5MAo6ADxqW/XklAX6dF2Lt7Vr49cmI4olP4bOEimXv
   d4F36U6uNOSHsQZz+qwLqclH+vQ5s/MpZwvQIQI+GPnXEwBFufbmunfye
   I7Og+xxosid1jtCORKBbCOS6ib0TK7XZFafpMWy9IbHvSFdorf6o46IrL
   g==;
X-CSE-ConnectionGUID: lTUDZuGATCajQk2bo8o69g==
X-CSE-MsgGUID: +IU3N+afTj674/jQSWehlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60658727"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="60658727"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 14:49:02 -0700
X-CSE-ConnectionGUID: J4TYWRXxS8O0A4D8ApBYDg==
X-CSE-MsgGUID: eXNUm2ziT6Sn2SSD/RBbyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="182137916"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.108.174]) ([10.125.108.174])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 14:49:01 -0700
Message-ID: <aaccf5c7-b9e8-4b27-8464-09ef3732c0c1@intel.com>
Date: Tue, 23 Sep 2025 14:48:59 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 05/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8@epcas5p2.samsung.com>
 <20250917134116.1623730-6-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-6-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update function using setter functions to update
> namespace label as per CXL LSA 2.1
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c |  3 +++
>  drivers/nvdimm/nd.h    | 23 +++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 3235562d0e1c..182f8c9a01bf 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -924,6 +924,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  
>  	nd_label = to_label(ndd, slot);
>  	memset(nd_label, 0, sizeof_namespace_label(ndd));
> +	nsl_set_type(ndd, nd_label);
>  	nsl_set_uuid(ndd, nd_label, nspm->uuid);
>  	nsl_set_name(ndd, nd_label, nspm->alt_name);
>  	nsl_set_flags(ndd, nd_label, flags);
> @@ -935,7 +936,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
>  	nsl_set_dpa(ndd, nd_label, res->start);
>  	nsl_set_slot(ndd, nd_label, slot);
> +	nsl_set_alignment(ndd, nd_label, 0);
>  	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
> +	nsl_set_region_uuid(ndd, nd_label, NULL);
>  	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
>  	nsl_calculate_checksum(ndd, nd_label);
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 158809c2be9e..e362611d82cc 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -295,6 +295,29 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
>  	return nd_label->efi.uuid;
>  }
>  
> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
> +				struct nd_namespace_label *ns_label)
> +{
> +	if (ndd->cxl && ns_label)
> +		uuid_parse(CXL_NAMESPACE_UUID, (uuid_t *) ns_label->cxl.type);

You can do:
uuid_copy(ns_label->cxl.type, cxl_namespace_uuid);

All the constant UUIDs are preparsed by nd_label_init(). For the entire series you can use those pre-parsed uuid_t and just use uuid_copy() instead of having to do string to uuid_t conversions.

DJ

> +}
> +
> +static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
> +				     struct nd_namespace_label *ns_label,
> +				     u32 align)
> +{
> +	if (ndd->cxl)
> +		ns_label->cxl.align = __cpu_to_le32(align);
> +}
> +
> +static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
> +				       struct nd_namespace_label *ns_label,
> +				       const uuid_t *uuid)
> +{
> +	if (ndd->cxl && uuid)
> +		export_uuid(ns_label->cxl.region_uuid, uuid);
> +}
> +
>  bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
>  			    struct nd_namespace_label *nd_label, guid_t *guid);
>  enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,

