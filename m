Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393568249B
	for <nvdimm@lists.linux.dev>; Mon, 15 Apr 2024 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713197835; cv=none; b=SQbzhPX9LO+cniVTZqfCeIuHMkHYUjhanpBpUJyX4lSPYmu+4wYw0fAxo7Jhyx1FGwyVSoktLGdcRRdutjZfLunR+x3ReNPaGlIWfNReXGocoCxJgj9sxwjXhEJLp5C0QXPz6ZIb+uo8KYo+c00Hb9QXFgCBoTNVh4bZPL95oio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713197835; c=relaxed/simple;
	bh=8hoFeujVd3Tdq+czm95H3yJuF1paGoOF85xTWnY9Xds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TaKYes0e0mcXrmgOFUAToRn/sRGW4khofbms492u5L4ybgMZpKV/j+2I3nQJQlZ3lercJmjd7iXyeRAYaoTl+eGX3sxmresePl+XZKmISsZCqmjyUP/XB0dwTfjjftg4QuFlHedQEExqVPYQ4WHp/13zaXG33Sb5RuFj9e4F7uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aIlDR55E; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aIlDR55E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713197830; x=1744733830;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8hoFeujVd3Tdq+czm95H3yJuF1paGoOF85xTWnY9Xds=;
  b=aIlDR55EfKkTKnTRfXJQ6ONJhumCvmitDewWqENIiKBtS6o+gSiFXhEt
   +cF/UzKAA0nH+fjc2hASOfeRFapRlmYM6y7Rvdsm+cWGxTxnEQ9A6wTFJ
   8Xu7barVtiETVDXlcfOuuGYWMFpmFD3fUzyJxJpFkoRrePoO1Kfyul3zh
   DwkUMWXcqCp377sKm+Ao6p/y/0coemw4DoVvdOX6vk5zOO/oYadb7Eyd4
   joNTNMVcL1Up91HP7/ID7bR8gBCsJP9/1d+qzL3+bEdehLvLPRQeGn2R/
   Kn6EaDmvbBo1KZElzPX9pT2GNc8Oqk5s9PqyrqQegm/qrekNOKCyGVwxt
   A==;
X-CSE-ConnectionGUID: hh9GcNwwRvK88pq/KtE/sQ==
X-CSE-MsgGUID: c4tlOCPOT8GUE4uA8ejjYg==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="12446898"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="12446898"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 09:17:10 -0700
X-CSE-ConnectionGUID: hNvy9VkORdylCcrpDFVraQ==
X-CSE-MsgGUID: re2Ny30YQqCTH7LFlnetAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="59403325"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.61.52]) ([10.212.61.52])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 09:17:09 -0700
Message-ID: <308450ff-00ad-4884-a62e-22d69a4727db@intel.com>
Date: Mon, 15 Apr 2024 09:17:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ndctl 1/2] daxctl/device.c: Handle special case of
 destroying daxX.0
To: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <ira.weiny@intel.com>
References: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
 <20240412-vv-daxctl-fixes-v1-1-6e808174e24f@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240412-vv-daxctl-fixes-v1-1-6e808174e24f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/24 2:05 PM, Vishal Verma wrote:
> The kernel has special handling for destroying the 0th dax device under
> any given DAX region (daxX.0). It ensures the size is set to 0, but
> doesn't actually remove the device, instead it returns an EBUSY,
> indicating that this device cannot be removed.
> 
> Add an expectation in daxctl's dev_destroy() helper to handle this case
> instead of returning the error - as far as the user is concerned, the
> size has been set to zero, and the destroy operation has been completed,
> even if the kernel indicated an EBUSY.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Reported-by: Ira Weiny <ira.weiny@intel.com>
> Reported-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  daxctl/device.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index 83913430..83c61389 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -675,6 +675,13 @@ static int dev_destroy(struct daxctl_dev *dev)
>  		return rc;
>  
>  	rc = daxctl_region_destroy_dev(daxctl_dev_get_region(dev), dev);
> +	/*
> +	 * The kernel treats daxX.0 specially. It can't be deleted to ensure
> +	 * there is always a /sys/bus/dax/ present. If this happens, an
> +	 * EBUSY is returned. Expect it and don't treat it as an error.
> +	 */
> +	if (daxctl_dev_get_id(dev) == 0 && rc == -EBUSY)
> +		return 0;
>  	if (rc < 0)
>  		return rc;
>  
> 
