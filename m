Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29072FCBF0
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 20:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763583198; cv=none; b=HIce7TyCh8gnEg1qfHKURCq4NV4BaqL2DcgVLN3FAEoVLQbMYNLvzjZXDwsRCx3Y5wYf9PRs8iRo2zne1VuKMuzWM6zAKmkAnS+ap15iVJbm2AzCsZ5zZshVPx87wPoOiH3tenJNzK5pjrS8YaoAe6pw2PNQZbe7HP1HReBYgXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763583198; c=relaxed/simple;
	bh=DB3q5vu6iHeaG9V9s6f38dJUrnXZYnJDTX5xSYJnTl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VWX68e/3QwlY/8Lupi7PUoI6CJSZnM6OPDYewTZ/Qp0afN+ed/B7I1fENxRrizV8twbVWFxIPEV0DPKvoQ55YY8EuXm/Y0jP36Hn6ODUh2sOYc2M6kMtRxLawuXqYhyeK7uoipX3ZKVfzR0yaoGbkENbIvUqgKY41bHkLObLF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bnbRNnb4; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bnbRNnb4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763583195; x=1795119195;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DB3q5vu6iHeaG9V9s6f38dJUrnXZYnJDTX5xSYJnTl0=;
  b=bnbRNnb4UBq+o/SETGp5wB9VvpnaaP2YZxn1jFDMWbkxD9BktwP6p3dZ
   QDwGxn7yd3CtXsDox0SKVPX0tBHlEzKtxHC5dekh0Zk1WBWwMUsf3hpd0
   vjYaTEA/zBJcDfasb0005+0i0zEF1IJH08o0K95M1y0+pnxBchaP4lZxe
   cTWZXMrXXzjDgkOzoK29N1DmQm6KG7WiEh/b9mhE9bWD7LeUsezYYoVeX
   AxQSOG4+Llg88PeIQ49Megg9sTr8JtRuyUbKKJ72Ri1dEX5xq/LX6Sc0e
   y+Q24cDSjpyqei2f43xfJbs6XaSTY0pum2Y5CTXsfkhKScqZ+2QbJUpfI
   w==;
X-CSE-ConnectionGUID: HyEwx8LAQcKGk+O+Ni0DYQ==
X-CSE-MsgGUID: TUED6BElQUSdqJI5d6Na0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="75966393"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="75966393"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 12:13:15 -0800
X-CSE-ConnectionGUID: jxX7HUU6SIWZj0jnUlb1+Q==
X-CSE-MsgGUID: KZXNsdMSQP2SI1gd2qedDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="190945830"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 12:13:15 -0800
Message-ID: <f161f011-e4f3-47f4-aa09-6266da1cd423@intel.com>
Date: Wed, 19 Nov 2025 13:13:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 08/17] nvdimm/label: Preserve cxl region information
 from region label
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7@epcas5p1.samsung.com>
 <20251119075255.2637388-9-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-9-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> Preserve region information from region label during nvdimm_probe. This
> preserved region information is used for creating cxl region to achieve
> region persistency across reboot.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Assume there's a plan to add >1 region labels preservation in the next step?

> ---
>  drivers/nvdimm/dimm.c     |  4 ++++
>  drivers/nvdimm/label.c    | 40 +++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h  |  2 ++
>  drivers/nvdimm/nd.h       |  1 +
>  include/linux/libnvdimm.h | 14 ++++++++++++++
>  5 files changed, 61 insertions(+)
> 
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 07f5c5d5e537..590ec883903d 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -107,6 +107,10 @@ static int nvdimm_probe(struct device *dev)
>  	if (rc)
>  		goto err;
>  
> +	/* Preserve cxl region info if available */
> +	if (ndd->cxl)
> +		nvdimm_cxl_region_preserve(ndd);
> +
>  	return 0;
>  
>   err:
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index da55ecd95e2f..0f8aea61b504 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -490,6 +490,46 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  	return 0;
>  }
>  
> +int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
> +	struct cxl_pmem_region_params *p = &nvdimm->cxl_region_params;
> +	struct nd_namespace_index *nsindex;
> +	unsigned long *free;
> +	u32 nslot, slot;
> +
> +	if (!preamble_current(ndd, &nsindex, &free, &nslot))
> +		return 0; /* no label, nothing to preserve */
> +
> +	for_each_clear_bit_le(slot, free, nslot) {
> +		union nd_lsa_label *lsa_label;
> +		struct cxl_region_label *region_label;
> +		uuid_t *region_uuid;
> +
> +		lsa_label = to_lsa_label(ndd, slot);
> +		region_label = &lsa_label->region_label;
> +		region_uuid = (uuid_t *) &region_label->type;
> +
> +		/* TODO: Currently preserving only one region */
> +		if (uuid_equal(&cxl_region_uuid, region_uuid)) {
> +			nvdimm->is_region_label = true;
> +			import_uuid(&p->uuid, region_label->uuid);
> +			p->flags = __le32_to_cpu(region_label->flags);
> +			p->nlabel = __le16_to_cpu(region_label->nlabel);
> +			p->position = __le16_to_cpu(region_label->position);
> +			p->dpa = __le64_to_cpu(region_label->dpa);
> +			p->rawsize = __le64_to_cpu(region_label->rawsize);
> +			p->hpa = __le64_to_cpu(region_label->hpa);
> +			p->slot = __le32_to_cpu(region_label->slot);
> +			p->ig = __le32_to_cpu(region_label->ig);
> +			p->align = __le32_to_cpu(region_label->align);
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int nd_label_data_init(struct nvdimm_drvdata *ndd)
>  {
>  	size_t config_size, read_size, max_xfer, offset;
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index bfc6bfeb6e24..a73fac81531e 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -46,6 +46,8 @@ struct nvdimm {
>  	} sec;
>  	struct delayed_work dwork;
>  	const struct nvdimm_fw_ops *fw_ops;
> +	bool is_region_label;
> +	struct cxl_pmem_region_params cxl_region_params;
>  };
>  
>  static inline unsigned long nvdimm_security_flags(
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index b241a0b2e314..281d30dd9ba0 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -600,6 +600,7 @@ void nvdimm_set_locked(struct device *dev);
>  void nvdimm_clear_locked(struct device *dev);
>  int nvdimm_security_setup_events(struct device *dev);
>  bool nvdimm_region_label_supported(struct device *dev);
> +int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd);
>  #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
>  int nvdimm_security_unlock(struct device *dev);
>  #else
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index bbf14a260c93..07ea2e3f821a 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -108,6 +108,20 @@ struct nd_cmd_desc {
>  	int out_sizes[ND_CMD_MAX_ELEM];
>  };
>  
> +struct cxl_pmem_region_params {
> +	uuid_t uuid;
> +	u32 flags;
> +	u16 nlabel;
> +	u16 position;
> +	u64 dpa;
> +	u64 rawsize;
> +	u64 hpa;
> +	u32 slot;
> +	u32 ig;
> +	u32 align;
> +	int nr_targets;
> +};
> +
>  struct nd_interleave_set {
>  	/* v1.1 definition of the interleave-set-cookie algorithm */
>  	u64 cookie1;

