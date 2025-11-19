Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD681E1E04
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763589649; cv=none; b=nGlf09VehAqxUljJcb8KoszohhmlHPAGeasMGox9SreCfEuvc5Urf+RBXQtfArWrrpeU8031chv7c6zkgN5yY8GMYAvqTWPzDD7iTMShZDplKS4b9zcnWQFvbScANFeU9H4n5jwNpnziFBbPmMTPF6oie0j7FNcpr2QlPD2ImcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763589649; c=relaxed/simple;
	bh=9L4lMj9JKByFmhd6DRWE+iDITyQYaZf/fpUwVFt4/ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3kmFMboWWMCwZAsWIIlIZ3KkfWFxGN5xDjxfyhphSXkQubhghtcgSlDbY8j06pMU6jL6FWrlizgO3Tyuyx1q1dX2+o9z0ElPcwy0nx79OiTv6dIsBzASIsYgGE18NqqQ8mav07QbUWmdlnoed4oGvpBZ8qdCnEEZAGy/HCJDmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gKiCxrA0; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gKiCxrA0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763589648; x=1795125648;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9L4lMj9JKByFmhd6DRWE+iDITyQYaZf/fpUwVFt4/ao=;
  b=gKiCxrA0E9+abQj1K0K1Xx3KzM4ORmAK68CYHf4LBFXgdVguD0olUdXx
   EHHNTOi0JXh54wfZr1hHfOwUpYV39C5pPRYvGH6Y5dfW6sY7NNMQUd1TN
   7B+MBna7AISIRrafjekwtFwwKDfXVJmU3o95/mtmpiLeqOdUx/6RdxFHQ
   dltwd/cWd4Gh0IlGeelMU2VGY58IoOOXqHAVxoGhvZQlf80O+Q2yU5s+B
   5i8ASVEkQW4SkxzO3E9EZUN+cnG3Xv7EQ8WUAHWA7bGLaSIa5WN+EC2b3
   0dLdggCuRUs8YBCKNqBfv16/2HpdOfCvEkr+GHZSw/mkOAYdFAc9tZHAf
   A==;
X-CSE-ConnectionGUID: atVMLsvhQduUj5VjHQirjw==
X-CSE-MsgGUID: 5ac9kig1Sd+DTzxZf2iStw==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65349378"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="65349378"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 14:00:47 -0800
X-CSE-ConnectionGUID: BOklLU2dQDCON/OqZWfcbA==
X-CSE-MsgGUID: eMkJDA4oSxa7/HDi+duBFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="221829410"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 14:00:47 -0800
Message-ID: <727222a0-6b16-46a9-854f-61fd00f729f9@intel.com>
Date: Wed, 19 Nov 2025 15:00:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 12/17] cxl/pmem: Preserve region information into
 nd_set
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075329epcas5p2e59df029313007c9adcf3a09ef0185cf@epcas5p2.samsung.com>
 <20251119075255.2637388-13-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-13-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> Save region information stored in cxlr to nd_set during
> cxl_pmem_region_probe in nd_set. This saved region information is being
> stored into LSA, which will be used for cxl region persistence
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/pmem.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index e197883690ef..a6eba3572090 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -377,6 +377,7 @@ static int cxl_pmem_region_probe(struct device *dev)
>  	struct nd_mapping_desc mappings[CXL_DECODER_MAX_INTERLEAVE];
>  	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
>  	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	struct cxl_region_params *p = &cxlr->params;
>  	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
>  	struct cxl_pmem_region_info *info = NULL;
>  	struct nd_interleave_set *nd_set;
> @@ -465,12 +466,12 @@ static int cxl_pmem_region_probe(struct device *dev)
>  	ndr_desc.num_mappings = cxlr_pmem->nr_mappings;
>  	ndr_desc.mapping = mappings;
>  
> -	/*
> -	 * TODO enable CXL labels which skip the need for 'interleave-set cookie'
> -	 */
> -	nd_set->cookie1 =
> -		nd_fletcher64(info, sizeof(*info) * cxlr_pmem->nr_mappings, 0);
> -	nd_set->cookie2 = nd_set->cookie1;
> +	nd_set->uuid = p->uuid;
> +	nd_set->interleave_ways = p->interleave_ways;
> +	nd_set->interleave_granularity = p->interleave_granularity;
> +	nd_set->res = p->res;
> +	nd_set->nr_targets = p->nr_targets;
> +
>  	ndr_desc.nd_set = nd_set;
>  
>  	cxlr_pmem->nd_region =

