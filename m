Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21642C6BB
	for <nvdimm@lists.linux.dev>; Wed,  7 Aug 2024 18:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723055329; cv=none; b=BVy6a+NErogqfruffrkoUKkV2rMMz229emu78XOERCTHQoxmzQGTHovkWIoXiBpAVsMurgGyJof4ut2oNIxGQZiEaVEd+EvBRkn+1Y32td9Qq4soAOdwiRmBp30ChsIrcmLgTeOwQT4367bBMEoqOZ+l7Ws/sAUAX1yEE+zHP6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723055329; c=relaxed/simple;
	bh=fjI/gs2azgUibYueaXrvSCZ2MSif5xm+KK8XD9aWQq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HilcFlsUcqUf+DOicnyQN97NTp3WCAjoGjfU7KenlMivqCcjyBTQb97UgGad8QtyS51WexMU7/D0ZOcfTLSoSAGGZDRdSKsUoUIb+1HKlORnklgrEL415Zq6jDzU/6aw4xoAQQA7T/a5Qh0+4wu4VHboL3ajF907hRB430S6ZBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lkS7KrEa; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lkS7KrEa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723055328; x=1754591328;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fjI/gs2azgUibYueaXrvSCZ2MSif5xm+KK8XD9aWQq8=;
  b=lkS7KrEatIVJWXjD9OA3PXdRRw3ACCjGaVfTbzjHCiUBRY7oMf4epOm3
   owd7B0fJJAmFLgndtr3a4FXgSFYYRivSUPYzAD0WgfjSLhEVbT5CJ1gc+
   +Y2NO7wN/6e28+9uFKisZvEoYuj4eaHao3Fnwm0BuKWvVl5xR14mhEyiY
   Vl5ukOQkSXsRdnr6S9qE6NodQxE/lmTa3H//xW1kzA6mOoBMZk+o7I4gq
   2yV5v7KGlmcpZDi9X1aSI41L/r1xka/7jkLXQ3Go48FYhV2ucTJuxmFZe
   0SDmbOtyYDz+vuOW3ozxuFoXhzq4di3+Fc41Mh/Zl+FQ+3zGzI7PKTsoo
   g==;
X-CSE-ConnectionGUID: 73s38jHKQfabK3SwUvju6g==
X-CSE-MsgGUID: 2p+Q6mqtThOG4+7WhXMDUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="12906891"
X-IronPort-AV: E=Sophos;i="6.09,270,1716274800"; 
   d="scan'208";a="12906891"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 11:28:47 -0700
X-CSE-ConnectionGUID: V0jK5j45RwC/oUH+NMR8YA==
X-CSE-MsgGUID: 1m4DjI9xQOOO/HZkwVY0BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,270,1716274800"; 
   d="scan'208";a="94513854"
Received: from eamartin-mobl1.amr.corp.intel.com (HELO [10.125.111.208]) ([10.125.111.208])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 11:28:46 -0700
Message-ID: <1b045ed5-b661-4d59-b43e-8d25cb1235ec@intel.com>
Date: Wed, 7 Aug 2024 11:28:45 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: Use of_property_present() and
 of_property_read_bool()
To: "Rob Herring (Arm)" <robh@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Oliver O'Halloran <oohall@gmail.com>,
 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240731191312.1710417-26-robh@kernel.org>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240731191312.1710417-26-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/31/24 12:13 PM, Rob Herring (Arm) wrote:
> Use of_property_present() and of_property_read_bool() to test
> property presence and read boolean properties rather than
> of_(find|get)_property(). This is part of a larger effort to remove
> callers of of_find_property() and similar functions.
> of_(find|get)_property() leak the DT struct property and data pointers
> which is a problem for dynamically allocated nodes which may be freed.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/of_pmem.c | 2 +-
>  drivers/nvmem/layouts.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index 403384f25ce3..b4a1cf70e8b7 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -47,7 +47,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>  	}
>  	platform_set_drvdata(pdev, priv);
>  
> -	is_volatile = !!of_find_property(np, "volatile", NULL);
> +	is_volatile = of_property_read_bool(np, "volatile");
>  	dev_dbg(&pdev->dev, "Registering %s regions from %pOF\n",
>  			is_volatile ? "volatile" : "non-volatile",  np);
>  
> diff --git a/drivers/nvmem/layouts.c b/drivers/nvmem/layouts.c
> index 77a4119efea8..65d39e19f6ec 100644
> --- a/drivers/nvmem/layouts.c
> +++ b/drivers/nvmem/layouts.c
> @@ -123,7 +123,7 @@ static int nvmem_layout_bus_populate(struct nvmem_device *nvmem,
>  	int ret;
>  
>  	/* Make sure it has a compatible property */
> -	if (!of_get_property(layout_dn, "compatible", NULL)) {
> +	if (!of_property_present(layout_dn, "compatible")) {
>  		pr_debug("%s() - skipping %pOF, no compatible prop\n",
>  			 __func__, layout_dn);
>  		return 0;
