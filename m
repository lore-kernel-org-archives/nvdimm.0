Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E141CD34
	for <nvdimm@lists.linux.dev>; Fri, 26 Jan 2024 21:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706305660; cv=none; b=IMQJirfpt4LXG9R59amJin3NX7/uMyaNHra9UFV2a+KoglzXokehUwuH/6zm2B/p2zlDVOubJy6t6AXGqszrOXjPFzgnwkFVS2hkc/IQ0xpGiqZ3iqXmGUuWANceKCU5eInHlgDpL9BhWFl23VCWVWP1QlHVO0tdF3elmsB4pOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706305660; c=relaxed/simple;
	bh=HBRJuss6imMsmywzzQhl+fxjAMwyma+dwoGqsOpW5Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVuRhEcwdTIDyiZsl9gL3YlBBGldnDtFTuFBSGcOsO9rhmG0xFDcaJ9AKpyyRqLIGUY9tTgRvfwWuv22x38FYBTXALGFHoQWm591oz4Xev+mxBWr2YsSZwdYnOt6pql4orIZ/oRjdslJoozLKwDjr3drlX5gdM9Mv7HJGxE8kaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PS/nlWKm; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PS/nlWKm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706305659; x=1737841659;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HBRJuss6imMsmywzzQhl+fxjAMwyma+dwoGqsOpW5Jg=;
  b=PS/nlWKmhoHD2Jqj7xGosbLDoUfcXfHwLXi5GL5WvMqbtL3HVWID3WdT
   CzNteB75Zd3Dr0zpyLHigTjkOpgb01et99dd87LQmuZwjn+IcG980Dd9t
   pK6e/FDWy+OVWjhAEtaIqh1FGyDsYyIfaCwxP5JoP7YTCkY/iOqQUuTL/
   ssbEDqDIt4pAL0XBI4zX6r3U2/DEmJ/fSXF8vVMyF56CwxQ/lXgsAHQlJ
   ZlBVSpEEk24cDHabOXSbviViOh0aq5U82B5M9fPTiUAGXRAbvUjJTfoZH
   nTOqnjpGGhUs1g33b6DYDpyoAYFchinU4vLPKkakOKh7PQ9y6GUJpxciy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="433738088"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="433738088"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 13:47:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="736813590"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="736813590"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.37.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 13:47:37 -0800
Date: Fri, 26 Jan 2024 13:47:36 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Quanquan Cao <caoqq@fujitsu.com>
Cc: dave.jiang@intel.com, vishal.l.verma@intel.com,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] =?utf-8?B?Y3hsL3JlZ2lvbu+8mkZp?= =?utf-8?Q?x?= overflow
 issue in alloc_hpa()
Message-ID: <ZbQoeIrWzzTPdqqF@aschofie-mobl2>
References: <20240124091527.8469-1-caoqq@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124091527.8469-1-caoqq@fujitsu.com>

On Wed, Jan 24, 2024 at 05:15:26PM +0800, Quanquan Cao wrote:
> Creating a region with 16 memory devices caused a problem. The div_u64_rem
> function, used for dividing an unsigned 64-bit number by a 32-bit one,
> faced an issue when SZ_256M * p->interleave_ways. The result surpassed
> the maximum limit of the 32-bit divisor (4G), leading to an overflow
> and a remainder of 0.
> note: At this point, p->interleave_ways is 16, meaning 16 * 256M = 4G
> 
> To fix this issue, I replaced the div_u64_rem function with div64_u64_rem
> and adjusted the type of the remainder.

Good find!  Should this have a Fixes Tag?

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> 
> Signed-off-by: Quanquan Cao <caoqq@fujitsu.com>
> ---
>  drivers/cxl/core/region.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 0f05692bfec3..ce0e2d82bb2b 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -525,7 +525,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>  	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
>  	struct cxl_region_params *p = &cxlr->params;
>  	struct resource *res;
> -	u32 remainder = 0;
> +	u64 remainder = 0;
>  
>  	lockdep_assert_held_write(&cxl_region_rwsem);
>  
> @@ -545,7 +545,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>  	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
>  		return -ENXIO;
>  
> -	div_u64_rem(size, SZ_256M * p->interleave_ways, &remainder);
> +	div64_u64_rem(size, (u64)SZ_256M * p->interleave_ways, &remainder);
>  	if (remainder)
>  		return -EINVAL;
>  
> -- 
> 2.43.0
> 
> 
