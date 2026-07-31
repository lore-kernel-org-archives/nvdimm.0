Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4DE386C22
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 15:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512427; cv=none; b=CmOPCKgUCVqeNr8hA4LIjJvEr03QqKNR+BdJ2p12pr40OUoQcwStMAwGU8mnz/kbxp9VjvbxPBdk8Hgv/SyaIXoV7Do23Px0XbGdxekNeWpYc2/qoWVmG8S4pwCjIXwpIilfmGwk3HyXRwV1GsmWAI9SUsRcR7TENaTpsTwt7NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512427; c=relaxed/simple;
	bh=A+QEp2r/K0FdI2uRck9YHpzvhJ8NJ4by5P6mXUd7UrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mstNvy5r2GNPoLbb1INpQu7uK6YmnlzVMpSfiVBKfg811P1DrmjYySwMJ5zMVs2H13kTbfQRu763iIifus/T5wac7FU1x/nYjFRsyIRJNcrRfmdXqcBSkVHzguV85DncIDotUxyBhaIPRDK0uXVPWXTvlKYubXYHqV04XaevjyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BX9SsVcn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BX9SsVcn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785512426; x=1817048426;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A+QEp2r/K0FdI2uRck9YHpzvhJ8NJ4by5P6mXUd7UrY=;
  b=BX9SsVcnceUxWEURCLUimVgkwcdKKydWzMxGTBYdPnkc4CB47Q8AGdXn
   B84099yCdofLMKVz07LCGXFhpW3C7NO2JulqQAGo/FNqdazjw3fy/f2UP
   gGqzDzkDONnXemG7GDmgiM5GjrvjEDX4GKng9epxKS1BFS7hwakM1Cpph
   tnyTOp5oPHklrxug7q6jY5xM2mbUZs/8NOdBPhFc0SmXk13/8KDh7F7FL
   347PnN6EUmnHe1O+BP5Y7XiG0+gxBUylYYD/bUlUJ0OXCCN56K+4RtzKJ
   dcTKm/c5G0j7Pql8L5mLseaLLimvOL7+TIGf7zAH2esOPag8kiN9dV7Yh
   w==;
X-CSE-ConnectionGUID: ZDyA25wnSdi53+Mh1W7S1w==
X-CSE-MsgGUID: xKN7N/uZQPyz2zEzsZiO5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="103679037"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="103679037"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 08:40:25 -0700
X-CSE-ConnectionGUID: JZjL85qXSxW/MD2FH/d8kg==
X-CSE-MsgGUID: fKioiUcPROuIkDqHsFO2AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="256700329"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.108.75]) ([10.125.108.75])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 08:40:25 -0700
Message-ID: <af3d9c4b-749a-4146-be80-210e6a1c0643@intel.com>
Date: Fri, 31 Jul 2026 08:40:24 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 2/2] cxl/list: list locked zero-sized decoders
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 Richard Cheng <icheng@nvidia.com>
Cc: linux-cxl@vger.kernel.org
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
 <018112d2f7890f3a3f38cc96aee5cf98cf5f3a9d.1785462417.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <018112d2f7890f3a3f38cc96aee5cf98cf5f3a9d.1785462417.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/26 6:55 PM, Alison Schofield wrote:
> 'cxl list' hides zero-sized decoders unless --idle is given, assuming
> they are unconfigured idle slots. That assumption does not hold for
> locked HDM decoders, which may legitimately report size 0 while being
> committed by firmware.
> 
> Do not suppress locked zero-sized decoders from the default listing.
> Combined with the "locked" field in the decoder JSON, they are visible
> and distinguishable from idle, unlocked slots that remain hidden
> without --idle.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/filter.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 5d634d3b2512..e6d45ac7b9e6 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -847,7 +847,8 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
>  		if (!util_cxl_decoder_filter_by_region(decoder,
>  						       p->region_filter))
>  			goto walk_children;
> -		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
> +		if (!p->idle && cxl_decoder_get_size(decoder) == 0 &&
> +		    !cxl_decoder_is_locked(decoder))
>  			continue;
>  		jdecoder = util_cxl_decoder_to_json(decoder, flags);
>  		if (!decoder) {

