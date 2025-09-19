Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A72523A
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758324691; cv=none; b=ZfnTVWLaA1bL9UPMK0fVNL05LrcVPsc6/oIyTaUyidMhQiO6PVPs0xQ9M8UJGGAQvaRdFJ3Vn8Gd7OAbg2Z61H4Xs2CbW0FdATW86drOKZo0+foivMSchKO9ztsab7KLqvqpeLmPbeyk2Kmt/QN97WZxp42XrQM2FuKl2szKjLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758324691; c=relaxed/simple;
	bh=bKQUk6LpxsJG4cFHoQGpCnCyQDnNHTW8RKsWh6CSCEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPSh8mGN33WYAP01hNRqbd10y4Tp2vaeRXb+i9JJgwj/snnxSd08xpyjmwA19d+zcRYp/tAMjAZ+NcScOy58z6dY43mRLhnxx8sBHHG8lt13q28/4BkjDSaA5PojZG3bQGIzFjvdx53jLN824dGotY7oPJEZ6yUwfI9sucHpOtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cf4vxuDE; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cf4vxuDE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758324689; x=1789860689;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bKQUk6LpxsJG4cFHoQGpCnCyQDnNHTW8RKsWh6CSCEg=;
  b=cf4vxuDEZiC0XpTf6w8cI0i8Y1Q+23YvE8AkGiLXOr4mMf4m9NywP6Vg
   Ys6xSzJ0K/E8zRduZYQ56TUdBRBAfqVZ9ziPfbsb1fWThcnWmVaNhTrlk
   qrrhzgSpDOUNGGpb+BGNzkE5JL7NPKJjeRzMUmjmmxvmCPMFhOr19GQxk
   GW2TbeLWGOHq13nnLQZctjc5RiyVo0kMxRBGmaS2VoBHD2UAo7F9R4kcx
   Cs9W2kmWeYctyXVTCbSDSGauE3SR+8P7e+jHH0/fP59hrRarIjmrLznTj
   c7JzxvCdQQ9PBGC9w4u0vonSCY06ADOFwUI7xHZJybhv3ttqLwscgOZ3H
   Q==;
X-CSE-ConnectionGUID: sgXXu2LaTCeZSVdjavTZuw==
X-CSE-MsgGUID: CglrQog9SqWcXlVAUZZoMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="48251910"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="48251910"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:31:29 -0700
X-CSE-ConnectionGUID: /eZfpaevTEiXr72h9BOHgQ==
X-CSE-MsgGUID: E0XyVVntTg+OjFKT6Tu6dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="206896901"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.58]) ([10.125.108.58])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:31:28 -0700
Message-ID: <1c9ef334-b087-4990-b1df-ec0d88fa21a7@intel.com>
Date: Fri, 19 Sep 2025 16:31:26 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 02/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com, Jonathan Cameron <jonathan.cameron@huawei.com>,
 Ira Weiny <ira.weiny@intel.com>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134132epcas5p192c031691ab4cbb905f2b2313bb79dee@epcas5p1.samsung.com>
 <1891546521.01758169682623.JavaMail.epsvc@epcpadp2new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1891546521.01758169682623.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:40 AM, Neeraj Kumar wrote:
> CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
> set configuration instead of interleave-set cookie used in previous LSA
> versions. As interleave-set cookie is not required for CXL LSA v2.1 format
> so skip its usage for CXL LSA 2.1 format
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Acked-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/namespace_devs.c |  8 +++++++-
>  drivers/nvdimm/region_devs.c    | 10 ++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 55cfbf1e0a95..3271b1c8569a 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1684,7 +1684,13 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  	int rc = 0;
>  	u16 i;
>  
> -	if (cookie == 0) {
> +	/*
> +	 * CXL LSA v2.1 utilizes the region label stored in the LSA for
> +	 * interleave set configuration. Whereas EFI LSA v1.1 & v1.2
> +	 * utilizes interleave-set cookie. i.e, CXL labels skip the
> +	 * need for 'interleave-set cookie'
> +	 */
> +	if (!ndd->cxl && cookie == 0) {
>  		dev_dbg(&nd_region->dev, "invalid interleave-set-cookie\n");
>  		return ERR_PTR(-ENXIO);
>  	}
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index de1ee5ebc851..88275f352240 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -858,6 +858,16 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
>  	if (!nd_set)
>  		return 0;
>  
> +	/*
> +	 * CXL LSA v2.1 utilizes the region label stored in the LSA for
> +	 * interleave set configuration. Whereas EFI LSA v1.1 & v1.2
> +	 * utilizes interleave-set cookie. i.e, CXL labels skip the
> +	 * need for 'interleave-set cookie'
> +	 */
> +	if (nsindex && __le16_to_cpu(nsindex->major) == 2
> +			&& __le16_to_cpu(nsindex->minor) == 1)
> +		return 0;
> +
>  	if (nsindex && __le16_to_cpu(nsindex->major) == 1
>  			&& __le16_to_cpu(nsindex->minor) == 1)
>  		return nd_set->cookie1;

