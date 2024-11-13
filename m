Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED56200123
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731517708; cv=none; b=EPvlXrwpmG3t7TLFaxPHLn/dt2svY3PWbzJw7FsmCcTab3QS7OvF3hCS8hC9lntnRTc2EgDRVSF+duDsk+0EzWlLDGRUHrGMdc0UlF4VglpYvzu/n7KIXBufOJ/aeE7S6KPrJLquAJNI0TSe6QK7+MhOuOxdHtj5+N0yG+Vrlc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731517708; c=relaxed/simple;
	bh=u2Y4lmxmRD3XKjq1cRSM+Df3A3Arm/B1BpyCuMjDeEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m4KpXOpRPmGR9Y0wdiu+M3LGQ2jkDuGfW8bEaKO8A3ofLdijoOxrGwJXfRy4ZYszxaaoIFB+qcjJsEkxUxcomfjPAAwL/bDcX2+sT/7NM0NAVXFSD2EGAUXLzDOYfhNyYAEVdwu2ZUNLrrGEMgnAuum6uY/eLUbpwRqLp1Km7RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FqJLfZ8x; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FqJLfZ8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731517707; x=1763053707;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u2Y4lmxmRD3XKjq1cRSM+Df3A3Arm/B1BpyCuMjDeEg=;
  b=FqJLfZ8xklLGJHmYRAxj0g54W1adF2gFncdG2kjITOe+PU/db0fSkMsb
   PWNce/oyDP8ufxyYB0hl69J/GjYGgFu0jg/cu6xMo1LzoOdKNuq+OuULT
   47MBra7zg7kaS2hTKZ+Tiv26rFgMbcWxE6Uq9+Yb03MKATzvOd0fW5N2P
   rFJhx8ffwvkjAZ9uyeny+udN6oMwBwLYRDcpedhhL8bg3967rmh4ECKgn
   9+WBoKSpA4CIGfIBEe26DZEbkVWAHrYPwqnZshZQuAd8MT5DUe0IzInaV
   hLT24cf8p3TDSm+LBU6t6/n0mfcCJxf9ZjZ0bHZzGHXusFT4KxDDbvyjq
   g==;
X-CSE-ConnectionGUID: q2eBuaCdR9+P6KzNUGmXRQ==
X-CSE-MsgGUID: 5puJqrKxThGYPppFzYmoAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31189378"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31189378"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 09:08:26 -0800
X-CSE-ConnectionGUID: m5iBqzG5R9ee3+RheE1+cA==
X-CSE-MsgGUID: pBXOY0a4QlGiK1g5ChbcPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="118744977"
Received: from spandruv-desk1.amr.corp.intel.com (HELO [10.125.111.237]) ([10.125.111.237])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 09:08:19 -0800
Message-ID: <e938bd59-3cb4-46f5-a703-8a1c1d6ed1fe@intel.com>
Date: Wed, 13 Nov 2024 10:08:09 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: rectify the illogical code within nd_dax_probe()
To: Yi Yang <yiyang13@huawei.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev
References: <671fbb33ee9ef_bc69d29447@dwillia2-xfh.jf.intel.com.notmuch>
 <20241108085526.527957-1-yiyang13@huawei.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241108085526.527957-1-yiyang13@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/8/24 1:55 AM, Yi Yang wrote:
> When nd_dax is NULL, nd_pfn is consequently NULL as well. Nevertheless,
> it is inadvisable to perform pointer arithmetic or address-taking on a
> NULL pointer.
> Introduce the nd_dax_devinit() function to enhance the code's logic and
> improve its readability.
> 
> Signed-off-by: Yi Yang <yiyang13@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
but a few comments for future patches: 

Is this v2 of the patch? Please label patch subject prefix as so. 
> ---

Please include change history here from previous versions. 

>  drivers/nvdimm/dax_devs.c | 4 ++--
>  drivers/nvdimm/nd.h       | 7 +++++++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index 6b4922de3047..37b743acbb7b 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -106,12 +106,12 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>  
>  	nvdimm_bus_lock(&ndns->dev);
>  	nd_dax = nd_dax_alloc(nd_region);
> -	nd_pfn = &nd_dax->nd_pfn;
> -	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
> +	dax_dev = nd_dax_devinit(nd_dax, ndns);
>  	nvdimm_bus_unlock(&ndns->dev);
>  	if (!dax_dev)
>  		return -ENOMEM;
>  	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	nd_pfn = &nd_dax->nd_pfn;
>  	nd_pfn->pfn_sb = pfn_sb;
>  	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
>  	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 2dbb1dca17b5..5ca06e9a2d29 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -600,6 +600,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
>  int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
>  bool is_nd_dax(const struct device *dev);
>  struct device *nd_dax_create(struct nd_region *nd_region);
> +static inline struct device *nd_dax_devinit(struct nd_dax *nd_dax,
> +					    struct nd_namespace_common *ndns)
> +{
> +	if (!nd_dax)
> +		return NULL;
> +	return nd_pfn_devinit(&nd_dax->nd_pfn, ndns);
> +}
>  #else
>  static inline int nd_dax_probe(struct device *dev,
>  		struct nd_namespace_common *ndns)

