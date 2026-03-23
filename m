Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4830A3BD632
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 17:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286097; cv=none; b=nX0eAsWoebD6tUDiaxZQhDH487d4qRnLYcYaJjy5EiciskulVrB4CdZPnxw+wgRtyr5jtrCBkgjUQoZ48Cuvm2T2wQZCZZeTXE1SBugfbcnSrl9TxQlijcTUYjhh3b/hZaQNpAjX49OkoDsuq+mbhV6uGPuFzj6EDUgcAIp12xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286097; c=relaxed/simple;
	bh=Pywn2oFcwft0vBnQp/98LvBTMyGYLc+1nw2xhJHXC9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dJk3RRXeN316npkNJ1OGD5YPh7SW93/97/HNhginUmpQmI/g5OJlodWMIjOnEDbqjZTfisudf9rrJOZGZlGN9qsQ+xiOJcBVb6XNURWI37keSbH/CrXN8872R0DJQLk5vaBvieJmMgLdObGRcag5NRFbDoJ+Jo7z53z7ErutFmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WMOcd9HZ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WMOcd9HZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774286094; x=1805822094;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pywn2oFcwft0vBnQp/98LvBTMyGYLc+1nw2xhJHXC9c=;
  b=WMOcd9HZBHWnxJIDhK8HWmpFO/7QP+121+yyb3Fqp9YjMfV6Xhn/VYEk
   dCY/bcKoWXDItUJscB1IosCH/PK6GyBvlwLxYZuD3QC19swTawosfrFED
   fjuYYVg4H6wgMup3dnrBAAxVKU8BwhIDAlHefZiTQsH6dLaSGtiP70hji
   ALbujjTMsKefcVG+wsknn63Z9BRm6plTEJ1B9ObJsY7zw8TnzpeeWvTHa
   qaYE9EhCw2UgET04pCTUs9z1ti58UmTzjfAYEDQyCVsH3/mcLaBRXxuoH
   3vcStq7t+9RA0Z3LJNtCYxA83sDpgoRLyRL/HvkKSl5eG6X23sUilXYTm
   g==;
X-CSE-ConnectionGUID: bOzp16jES761yzk3eWsj8g==
X-CSE-MsgGUID: Tm5JNBkSRIuAJ+iMFVndBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="62849313"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="62849313"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 10:14:53 -0700
X-CSE-ConnectionGUID: RmXqzBsDTN+qkaDGSV7/MA==
X-CSE-MsgGUID: 02uuQAASRgiHmfogFtiHZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="224097691"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.109.216]) ([10.125.109.216])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 10:14:51 -0700
Message-ID: <8edb1f80-de1e-4fa7-9eb8-80def1cb111d@intel.com>
Date: Mon, 23 Mar 2026 10:14:50 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/9] dax/hmem: Factor HMEM registration into
 __hmem_register_device()
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-3-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260322195343.206900-3-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/22/26 12:53 PM, Smita Koralahalli wrote:
> Separate the CXL overlap check from the HMEM registration path and keep
> the platform-device setup in a dedicated __hmem_register_device().
> 
> This makes hmem_register_device() the policy entry point for deciding
> whether a range should be deferred to CXL, while __hmem_register_device()
> handles the HMEM registration flow.
> 
> No functional changes.
> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/hmem/hmem.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 1cf7c2a0ee1c..a3d45032355c 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -58,21 +58,14 @@ static void release_hmem(void *pdev)
>  	platform_device_unregister(pdev);
>  }
>  
> -static int hmem_register_device(struct device *host, int target_nid,
> -				const struct resource *res)
> +static int __hmem_register_device(struct device *host, int target_nid,
> +				  const struct resource *res)
>  {
>  	struct platform_device *pdev;
>  	struct memregion_info info;
>  	long id;
>  	int rc;
>  
> -	if (IS_ENABLED(CONFIG_CXL_REGION) &&
> -	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> -			      IORES_DESC_CXL) != REGION_DISJOINT) {
> -		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> -		return 0;
> -	}
> -
>  	rc = region_intersects_soft_reserve(res->start, resource_size(res));
>  	if (rc != REGION_INTERSECTS)
>  		return 0;
> @@ -123,6 +116,19 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	return rc;
>  }
>  
> +static int hmem_register_device(struct device *host, int target_nid,
> +				const struct resource *res)
> +{
> +	if (IS_ENABLED(CONFIG_CXL_REGION) &&
> +	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> +			      IORES_DESC_CXL) != REGION_DISJOINT) {
> +		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> +		return 0;
> +	}
> +
> +	return __hmem_register_device(host, target_nid, res);
> +}
> +
>  static int dax_hmem_platform_probe(struct platform_device *pdev)
>  {
>  	return walk_hmem_resources(&pdev->dev, hmem_register_device);

