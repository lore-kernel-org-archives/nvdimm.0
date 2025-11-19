Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CEB30C366
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 23:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763595470; cv=none; b=tvA4jm3IuwwbC0quJ8sDl0f1GkOlnHyDJiYYC6kl53alQsACxo9la2RERvqx+5g9jHspzBHzolzesIivarK1DHkD/nBodnfJNQVAH621fXO12MRq/z9dhAYgENVq42GrS6ZWek3OCtRMB3ap0RE9auPEixP+BvrheI3pLGtDZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763595470; c=relaxed/simple;
	bh=2XIewdj09S03gQHRuGuQsn1H9XTaN+n76gCQSsKRxWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=abm722hc1RQtIIapjC1H+HgQ+mRH6I/Eti/70flAz3faluwG0tZc4fjjrZ2YMou+QZe4UsRjwVhaWkHNmLTsvHXAuPvGJ99hcPaBuj2H4EDOepIm1ukE8C6FVeHZK/yJB9lVcopxJ9NqAh1WzBQJ47rN2njnitaP6QG3olCOGgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WKU3mns3; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WKU3mns3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763595469; x=1795131469;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2XIewdj09S03gQHRuGuQsn1H9XTaN+n76gCQSsKRxWU=;
  b=WKU3mns3hUspPPOUr+Q0jChBLF8QKVQyQr1ReCE6hQCFBuPFxgUecZB3
   A4o84Hw9p35tt1ErokRB5SpLP/ZXV2Pp6APPc3M0wz0IpoWA9uwD8SY6n
   SWWb5hal9REUgJ7FU3dkKy4e82af+tJk2iCOpZOb8HNBCj881FtUapYAU
   BtgFKwNW5S5Bl2WJwGPVg4WYKHrJH9BSdT5ZJexyE2nk++pEIWPy6kyGt
   4IFWOdCl7jEdtHaNBi69WY9BmkQc1jxI3EPzZQq2lXfJUYAcgFWsVJJxn
   uv4c7Q5JSl3ApHGiO5+iBnyPFscFQpOFi9KezY+TyUl/e3tFlbvciJrOG
   g==;
X-CSE-ConnectionGUID: 17c2b+qpTbKx0pdH5WgV9g==
X-CSE-MsgGUID: DQSUjMDsT1u4oQLxHl7SCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="83041692"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="83041692"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:37:49 -0800
X-CSE-ConnectionGUID: sulBbjipTbq5clXifbiXfw==
X-CSE-MsgGUID: 3aDI58PORyCwq/FVIFa54w==
X-ExtLoop1: 1
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:37:48 -0800
Message-ID: <3c7daa78-7eb6-4fef-b68f-2bda9c489958@intel.com>
Date: Wed, 19 Nov 2025 16:37:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 17/17] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075340epcas5p42d0fa80388af654dff0da088fb3e978c@epcas5p4.samsung.com>
 <20251119075255.2637388-18-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-18-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> Add support of CXL LSA 2.1 using NDD_REGION_LABELING flag. It creates
> cxl region based on region information parsed from LSA
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/pmem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index a6eba3572090..5970d1792be8 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -135,6 +135,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return rc;
>  
>  	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_REGION_LABELING, &flags);
>  	set_bit(NDD_REGISTER_SYNC, &flags);
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> @@ -155,6 +156,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return -ENOMEM;
>  
>  	dev_set_drvdata(dev, nvdimm);
> +	create_pmem_region(nvdimm);
>  	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
>  }
>  

