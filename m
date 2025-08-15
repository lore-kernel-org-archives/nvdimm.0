Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF5E17A2FC
	for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 21:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755291742; cv=none; b=rSbsq9i82IXOHtp3JDzaXHjhODb2uH19DzX8KyVkIsm3AREj3y4aSy9QJ6Lpu19AMrY3hEG4z+LAyiFphwpBoKDsZIxvcGyibh4+KiYKfUQfbaSyqXdbyMk8VBbN5aJZ4Jmq/ROSLjzPa3cjkZFp6O4YumuiKU9H/eFnHK1X+lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755291742; c=relaxed/simple;
	bh=1YF5sy8dldm5R8DgrzVScACFRpxgR2SPXO69iZ65HFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ANx7LpqDerPoEC7Qsm0LJifsXPQfy2GPGj/ej4WxHIaaHD3OfHy+wTCTPpCnay1XH1iNAsVZk3zSuCv0RnZSO/Gmk+FCPcVJ7j7DXGKJRx8YMYwG/JMhyhG80YYpQAGCuLj5Z3+15V3F7g7ACeHvgpYgLBBT9+ScdzVVnjGb6VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j4YvPAqK; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j4YvPAqK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755291741; x=1786827741;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1YF5sy8dldm5R8DgrzVScACFRpxgR2SPXO69iZ65HFw=;
  b=j4YvPAqK22tCXLIUl4niL3K+RcxNvLpHjduwL8gFRY+UAdyNC23/wxjL
   PM2MVjt53zgLmeEQWzkFxwOP3z7G5s9VLbxWJGmTeKNz7WSkNJ0S2bbQy
   iuUgloeGkB12Ezye35lf/oPAqzwcVyDIeP2m+Qu3Wy3pY2ILZkAXSKvEE
   S5/Ezaxq8rbiI06eh4D86xt678nhcS/6tutT9gX3tK07DaBJQdEKGod/o
   mpxwf3k1sV62jx1b7tjpP+hVfJ1i483KjLF5LdUCgl2byB+B1eG26RskF
   FV3OPVzpyksep1EU+oepCdXuZ5BiaE7+b08upSrIqCfrwOJppq0aqaqmr
   A==;
X-CSE-ConnectionGUID: NGIzEOKeRb+50hBIMd/BiQ==
X-CSE-MsgGUID: JhCN1VyNTIumz39QqfZvqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="57720361"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57720361"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 14:02:20 -0700
X-CSE-ConnectionGUID: efQmceHTQlOOS6SP7fmfgw==
X-CSE-MsgGUID: AguZBKEmRu6XOj2/yvIUFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167439454"
Received: from anmitta2-mobl4.gar.corp.intel.com (HELO [10.247.119.183]) ([10.247.119.183])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 14:02:16 -0700
Message-ID: <a05bbfe7-dec6-4858-8f9f-9f80deda48ae@intel.com>
Date: Fri, 15 Aug 2025 14:02:10 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 04/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e@epcas5p4.samsung.com>
 <20250730121209.303202-5-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250730121209.303202-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/25 5:11 AM, Neeraj Kumar wrote:
> CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
> set configuration instead of interleave-set cookie used in previous LSA
> versions. As interleave-set cookie is not required for CXL LSA v2.1 format
> so skip its usage for CXL LSA 2.1 format
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 3 ++-
>  drivers/nvdimm/region_devs.c    | 5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index bdf1ed6f23d8..5b73119dc8fd 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1692,7 +1692,8 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  	int rc = 0;
>  	u16 i;
>  
> -	if (cookie == 0) {
> +	/* CXL labels skip the need for 'interleave-set cookie' */

This comment doesn't make sense to me. If it's a CXL label, we continue to execute. There's no skipping. Or are you trying to say if it's CXL label, then checking of cookie value is unnecessary? But the cookie value still is being used later on. Maybe a bit more comments on what's going on here would be helpful.

DJ

> +	if (!ndd->cxl && cookie == 0) {
>  		dev_dbg(&nd_region->dev, "invalid interleave-set-cookie\n");
>  		return ERR_PTR(-ENXIO);
>  	}
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index de1ee5ebc851..2debe60f8bf0 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -858,6 +858,11 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
>  	if (!nd_set)
>  		return 0;
>  
> +	/* CXL labels skip the need for 'interleave-set cookie' */
> +	if (nsindex && __le16_to_cpu(nsindex->major) == 2
> +			&& __le16_to_cpu(nsindex->minor) == 1)
> +		return 0;
> +
>  	if (nsindex && __le16_to_cpu(nsindex->major) == 1
>  			&& __le16_to_cpu(nsindex->minor) == 1)
>  		return nd_set->cookie1;

