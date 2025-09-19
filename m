Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AA117A2EA
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 23:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758326367; cv=none; b=XZWdKy3WSKZsSqha1weIeNiiMcLPZPqg1AxPCy+88zb9ljABGfoy/QcuTg37NGQUiRQS94QBxAGTRogDJhbi6NPC9Cc8iEhlGwQnotI08GGVkWW85WbNFXCo5dx/DqFtn6W8ikuBcd2i+NCJjiRcKCkWb+IzOWDfm9qEpaT3IK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758326367; c=relaxed/simple;
	bh=hmyDCoOJEg/UaY26Qcrc0Q92cnmhyVHgQ5u6VdI4acI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sd4D8xX5T91O/tGFVyJOLxZV4oD7bpxwoIm8YN1dNr9VU9ux2gNpRAqDLzYvByg1aozfXqvHBhZTZ47z2DXz39Zl23EEvTaRVVRMzdE3u/UWo5cE9W61rG0hqOEivhFpA+cJ8l4MP3CP38mB+tnq02mcng9tzq70Z8XowoAHqEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S26V8AcV; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S26V8AcV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758326365; x=1789862365;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hmyDCoOJEg/UaY26Qcrc0Q92cnmhyVHgQ5u6VdI4acI=;
  b=S26V8AcV4qdqv3z0mZDXFv9JpDJ+T5OloF5FN5TMT80HdyL5jhTBo2nl
   eD0YkMCdGK2TYLkaII9ebpe+Ndd0Jug3gDLzcPv+oMV63NMWf64TT3R8m
   tgs90/4qN8ZMNf1UgHLZYMss3/hTyGkleckbnA5jwtaj9hlk0YItuZloL
   7YYyh6m2jyln+dZglYD1klALm981KF2auENuI5u+fY6HA5c1XDJWD4YE8
   SZJc9f8DqnvynAYHBGa9kgQ5yreL73IZ3HJLtThl9RBYfhJUCm9ed0yUu
   XV1yPL3u27n6qrqiEkgLc6//cwMFSeboKFhp+cBpDCe3UPMTYNXOWvrRc
   w==;
X-CSE-ConnectionGUID: SqBUK7mqQQ+2UK0qiAH4wg==
X-CSE-MsgGUID: H72CqJOsQc+anWZ9Ww29LA==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="60792921"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="60792921"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:59:25 -0700
X-CSE-ConnectionGUID: /qPgjT/XS4i4gF8C2ZDiIg==
X-CSE-MsgGUID: uz6x6rvKRvSdKLWpFy6bzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="175203511"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.58]) ([10.125.108.58])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:59:23 -0700
Message-ID: <3bfaf4e6-739f-4998-8343-770ef3ab3791@intel.com>
Date: Fri, 19 Sep 2025 16:59:23 -0700
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

Personally would prefer something like:

if (!(ndd->cxl && ns_label))
	return;
uuid_parse(....);

Also, no space needed after casting.

> +}
> +
> +static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
> +				     struct nd_namespace_label *ns_label,
> +				     u32 align)
> +{
> +	if (ndd->cxl)
> +		ns_label->cxl.align = __cpu_to_le32(align);

same comment as above
> +}
> +
> +static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
> +				       struct nd_namespace_label *ns_label,
> +				       const uuid_t *uuid)
> +{
> +	if (ndd->cxl && uuid)
> +		export_uuid(ns_label->cxl.region_uuid, uuid);

same comment as above

> +}
> +
>  bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
>  			    struct nd_namespace_label *nd_label, guid_t *guid);
>  enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,

