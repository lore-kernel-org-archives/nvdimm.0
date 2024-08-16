Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE45F143C72
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 22:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846504; cv=none; b=ttDoskAvT4/5y2P2GqFAbRqZgCq2i79EDFXb+0guJjyje36CLcx/r0v9amc/udyafCnzOEVMpcYk0q7Oyc/APH83kl8wS7uVSugSEG8481ZkK3V/z7Sv2DQOpjyDFq6O50PfZ1wmi/EkwHWKlkSgO+nPwWZ2VZobH4+pNJNeUV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846504; c=relaxed/simple;
	bh=5J1GuYUnbG2FOnw0lH0OF0aLsKFIEl0BmHGJA/QgCPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fy0BjX9DSRgaPN/5MexNw26tn2aI/AtvCTKCukmmiwgGodN0rpoXaSgW2IXcEUEC+/q+eWDdoLr/DD9Z0u+boBzgxY1tssOGVTgjurFfPsItccy4dy9SxfhHKWsGBoqKDptofH864PxQNTy4tKFlulSYLyf7VflQCj5GmzPOyW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JPYo0ft+; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JPYo0ft+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723846500; x=1755382500;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5J1GuYUnbG2FOnw0lH0OF0aLsKFIEl0BmHGJA/QgCPA=;
  b=JPYo0ft+A4jV8mXz1XYAQUBPogR2Dj7pZgvLQvab0C95isylHsG5AK/l
   wxKZfp0wkJXV7Wwr67f7LjjiwB1Clc1cZULVZv71WOlgaUapONvgeoXTW
   wH6f3V49s83Nc6mXRYSMVKlYzQhmsd6OBjtEhAGztF7SQANSmfMoEoPK4
   4MsQZQTovIFV5CvrDhSmigBa56LFmWn8TrxS2z1iqf766yMWeA55RoHEo
   3PXYBTDyci+TGgOnmn91mAKlXxRyhVxwoP/VNQAByVFYHIkMS9ZpEWsLd
   /8oLhr+xJmEA9aWwxB4JQhwNslZ+bLXUwWI4Jr3BbbGQqyr3QOR1UzRpc
   Q==;
X-CSE-ConnectionGUID: vzzFuho7TTWuL7PpoCBMLg==
X-CSE-MsgGUID: mWqkyIgdRf2ELAiiN1BN/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="25951007"
X-IronPort-AV: E=Sophos;i="6.10,153,1719903600"; 
   d="scan'208";a="25951007"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 15:14:59 -0700
X-CSE-ConnectionGUID: QmtEyer7QfW6tcMUMNur7A==
X-CSE-MsgGUID: J0cnrZfCQ/OktFaxHpW/0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,153,1719903600"; 
   d="scan'208";a="90527847"
Received: from unknown (HELO [10.125.111.71]) ([10.125.111.71])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 15:14:57 -0700
Message-ID: <fe15b551-d22f-4d46-88e0-162cacc507a7@intel.com>
Date: Fri, 16 Aug 2024 15:14:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/25] cxl/region: Add dynamic capacity decoder and
 region modes
To: ira.weiny@intel.com, Fan Ni <fan.ni@samsung.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-btrfs@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-8-7c9b96cba6d7@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240816-dcd-type2-upstream-v3-8-7c9b96cba6d7@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/16/24 7:44 AM, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> One or more decoders each pointing to a Dynamic Capacity (DC) partition
> form a CXL software region.  The region mode reflects composition of
> that entire software region.  Decoder mode reflects a specific DC
> partition.  DC partitions are also known as DC regions per CXL
> specification r3.1.
> 
> Define the new modes and helper functions required to make the
> association between these new modes.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Fan Ni <fan.ni@samsung.com>
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> ---
> Changes:
> [iweiny: keep tags on simple patch]
> [Fan: s/partitions/partition/]
> [djiang: New wording for the commit message]
> [iweiny: reword commit message more]
> ---
>  drivers/cxl/core/region.c |  4 ++++
>  drivers/cxl/cxl.h         | 23 +++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 796e5a791e44..650fe33f2ed4 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1870,6 +1870,8 @@ static bool cxl_modes_compatible(enum cxl_region_mode rmode,
>  		return true;
>  	if (rmode == CXL_REGION_PMEM && dmode == CXL_DECODER_PMEM)
>  		return true;
> +	if (rmode == CXL_REGION_DC && cxl_decoder_mode_is_dc(dmode))
> +		return true;
>  
>  	return false;
>  }
> @@ -3239,6 +3241,8 @@ cxl_decoder_to_region_mode(enum cxl_decoder_mode mode)
>  		return CXL_REGION_RAM;
>  	case CXL_DECODER_PMEM:
>  		return CXL_REGION_PMEM;
> +	case CXL_DECODER_DC0 ... CXL_DECODER_DC7:
> +		return CXL_REGION_DC;
>  	case CXL_DECODER_MIXED:
>  	default:
>  		return CXL_REGION_MIXED;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index f766b2a8bf53..d2674ab46f35 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -370,6 +370,14 @@ enum cxl_decoder_mode {
>  	CXL_DECODER_NONE,
>  	CXL_DECODER_RAM,
>  	CXL_DECODER_PMEM,
> +	CXL_DECODER_DC0,
> +	CXL_DECODER_DC1,
> +	CXL_DECODER_DC2,
> +	CXL_DECODER_DC3,
> +	CXL_DECODER_DC4,
> +	CXL_DECODER_DC5,
> +	CXL_DECODER_DC6,
> +	CXL_DECODER_DC7,
>  	CXL_DECODER_MIXED,
>  	CXL_DECODER_DEAD,
>  };
> @@ -380,6 +388,14 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
>  		[CXL_DECODER_NONE] = "none",
>  		[CXL_DECODER_RAM] = "ram",
>  		[CXL_DECODER_PMEM] = "pmem",
> +		[CXL_DECODER_DC0] = "dc0",
> +		[CXL_DECODER_DC1] = "dc1",
> +		[CXL_DECODER_DC2] = "dc2",
> +		[CXL_DECODER_DC3] = "dc3",
> +		[CXL_DECODER_DC4] = "dc4",
> +		[CXL_DECODER_DC5] = "dc5",
> +		[CXL_DECODER_DC6] = "dc6",
> +		[CXL_DECODER_DC7] = "dc7",
>  		[CXL_DECODER_MIXED] = "mixed",
>  	};
>  
> @@ -388,10 +404,16 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
>  	return "mixed";
>  }
>  
> +static inline bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode)
> +{
> +	return (mode >= CXL_DECODER_DC0 && mode <= CXL_DECODER_DC7);
> +}
> +
>  enum cxl_region_mode {
>  	CXL_REGION_NONE,
>  	CXL_REGION_RAM,
>  	CXL_REGION_PMEM,
> +	CXL_REGION_DC,
>  	CXL_REGION_MIXED,
>  };
>  
> @@ -401,6 +423,7 @@ static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
>  		[CXL_REGION_NONE] = "none",
>  		[CXL_REGION_RAM] = "ram",
>  		[CXL_REGION_PMEM] = "pmem",
> +		[CXL_REGION_DC] = "dc",
>  		[CXL_REGION_MIXED] = "mixed",
>  	};
>  
> 
