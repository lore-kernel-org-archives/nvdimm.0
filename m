Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344958002E
	for <nvdimm@lists.linux.dev>; Thu,  8 Feb 2024 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707411099; cv=none; b=ZuWkEe8u8wlpsvB3QA6id9JBzPyLGmMnFReFZMEnvp6sW2hCrWmC1vm3W5ZMePmI8mzJWfP7t/VdOOaCtq1U96P+UDBmnICi+jmT8Rcb9qE0DphgGYPEp115d9BIWjVVPeHXrrEkW4k5T65s9paaUO2Wyu1yrZweGGhWh81RZRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707411099; c=relaxed/simple;
	bh=kguWRe/VA76+9JQRyZ8+LqOT6fNitZvB5PcAcUQDbW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uui1VrxdbZnbwchgjSayP+K7SYHYJzloT5nBpPdKgTSroI7nOaIps0be/NDxQeXdWQNgqQmOgqfSDxbe7tEfBNflqSfPDWkmwyHklvU8gKSogSEjC57rPLg3VGAzJB3NRQVN4YQFaE36ab5aMO99nY9gaII6KUIrpbiArqTTAE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KsTRok5I; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KsTRok5I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707411098; x=1738947098;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kguWRe/VA76+9JQRyZ8+LqOT6fNitZvB5PcAcUQDbW8=;
  b=KsTRok5IyFcUigsH7Zs3lM3U/Tr3o9tbL8buHxFPm8MtswZhILp4INZj
   FvOP03bHVeYOGyCS3wvfNcvqiUHCCFvK0BTDCCgLCYr/Nmn0CTTy9rUmT
   1UrqkN4SvA/vCptYDwyF/Gz+JgYWHFlh5qFwKIlaVV5QS2pFmuyuokjzZ
   bPpIv6CX3noE1/aoL1LCsGSCxRtBXg+IW5T3YizopFoem8kCj1JItb9CA
   zElGCeyqy2h59df03LnWzAohevJiY62CYcesl3YNWkI8pv9rv7hv49eNc
   6mUlhKfZdb1IhgosQyD9391bJ2bZnQs9n0FhTjfQoonDR26ZSSXjCbIRK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="1555869"
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="1555869"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 08:51:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="934181048"
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="934181048"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.113.125]) ([10.246.113.125])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 08:51:36 -0800
Message-ID: <59f801c7-184e-4594-8f18-52438096d235@intel.com>
Date: Thu, 8 Feb 2024 09:51:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v7 6/7] cxl/list: add --media-errors option to cxl
 list
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1707351560.git.alison.schofield@intel.com>
 <6f03d2d26d17beb33d28c7471a4fbfc1ec8a8e21.1707351560.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <6f03d2d26d17beb33d28c7471a4fbfc1ec8a8e21.1707351560.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/7/24 6:01 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The --media-errors option to 'cxl list' retrieves poison lists from
> memory devices supporting the capability and displays the returned
> media_error records in the cxl list json. This option can apply to
> memdevs or regions.
> 
> Include media-errors in the -vvv verbose option.
> 
> Example usage in the Documentation/cxl/cxl-list.txt update.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt | 79 +++++++++++++++++++++++++++++++++-
>  cxl/filter.h                   |  3 ++
>  cxl/list.c                     |  3 ++
>  3 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 838de4086678..5c20614ef579 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -415,6 +415,83 @@ OPTIONS
>  --region::
>  	Specify CXL region device name(s), or device id(s), to filter the listing.
>  
> +-L::
> +--media-errors::
> +	Include media-error information. The poison list is retrieved from the
> +	device(s) and media_error records are added to the listing. Apply this
> +	option to memdevs and regions where devices support the poison list
> +	capability.
> +
> +	"decoder" and "hpa" are included when the media-error is in a mapped
> +        address.
> +
> +	"source" will be one of: External, Internal, Injected, Vendor Specific,
> +        or Unknown, as defined in CXL Specification v3.1 Table 8-140.
> +
> +----
> +# cxl list -m mem1 --media-errors
> +[
> +  {
> +    "memdev":"mem1",
> +    "pmem_size":1073741824,
> +    "ram_size":1073741824,
> +    "serial":1,
> +    "numa_node":1,
> +    "host":"cxl_mem.1",
> +    "media_errors":[
> +      {
> +        "dpa":0,
> +        "length":64,
> +        "source":"Internal"
> +      },
> +      {
> +        "decoder":"decoder10.0",
> +        "hpa":1035355557888,
> +        "dpa":1073741824,
> +        "length":64,
> +        "source":"External"
> +      },
> +      {
> +        "decoder":"decoder10.0",
> +        "hpa":1035355566080,
> +        "dpa":1073745920,
> +        "length":64,
> +        "source":"Injected"
> +      }
> +    ]
> +  }
> +]
> +
> +# cxl list -r region5 --media-errors
> +[
> +  {
> +    "region":"region5",
> +    "resource":1035355553792,
> +    "size":2147483648,
> +    "type":"pmem",
> +    "interleave_ways":2,
> +    "interleave_granularity":4096,
> +    "decode_state":"commit",
> +    "media_errors":[
> +      {
> +        "decoder":"decoder10.0",
> +        "hpa":1035355557888,
> +        "dpa":1073741824,
> +        "length":64,
> +        "source":"External"
> +      },
> +      {
> +        "decoder":"decoder8.1",
> +        "hpa":1035355553792,
> +        "dpa":1073741824,
> +        "length":64,
> +        "source":"Internal"
> +      }
> +    ]
> +  }
> +]
> +----
> +
>  -v::
>  --verbose::
>  	Increase verbosity of the output. This can be specified
> @@ -431,7 +508,7 @@ OPTIONS
>  	  devices with --idle.
>  	- *-vvv*
>  	  Everything *-vv* provides, plus enable
> -	  --health and --partition.
> +	  --health, --partition, --media-errors.
>  
>  --debug::
>  	If the cxl tool was built with debug enabled, turn on debug
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 3f65990f835a..956a46e0c7a9 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -30,6 +30,7 @@ struct cxl_filter_params {
>  	bool fw;
>  	bool alert_config;
>  	bool dax;
> +	bool media_errors;
>  	int verbose;
>  	struct log_ctx ctx;
>  };
> @@ -88,6 +89,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
>  		flags |= UTIL_JSON_ALERT_CONFIG;
>  	if (param->dax)
>  		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
> +	if (param->media_errors)
> +		flags |= UTIL_JSON_MEDIA_ERRORS;
>  	return flags;
>  }
>  
> diff --git a/cxl/list.c b/cxl/list.c
> index 93ba51ef895c..0b25d78248d5 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -57,6 +57,8 @@ static const struct option options[] = {
>  		    "include memory device firmware information"),
>  	OPT_BOOLEAN('A', "alert-config", &param.alert_config,
>  		    "include alert configuration information"),
> +	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
> +		    "include media-error information "),
>  	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
>  #ifdef ENABLE_DEBUG
>  	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
> @@ -121,6 +123,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.fw = true;
>  		param.alert_config = true;
>  		param.dax = true;
> +		param.media_errors = true;
>  		/* fallthrough */
>  	case 2:
>  		param.idle = true;
