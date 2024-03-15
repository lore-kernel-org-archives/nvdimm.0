Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEB81EA7A
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 16:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710520889; cv=none; b=bRD+CURmfYICaCuXMNb/KosPr9LDFGY+n6sGsspPU2puLJZj0N4voC2oNTL34rd96KWd+2tjDWP5cglDpnxag+TQu0juhQ3pm8FqRY/vNly8aRm13kP0WO/ClVzQlu/LyEsVZKmcUYxscIb1C3fl+rJX9G5y+ZbaEZlwOLjMOXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710520889; c=relaxed/simple;
	bh=JOgfJ3deDkMV1JdNjU6zW6ficQ6Eb4NB4SW3o1Ov5BQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPJETg9AFdESriFAYVadqAn7Oyk2CvDC6z2g2r2OB3ZtV0BE9JXdm2ql2W+eu6IYnZm4IqW6XqBE3j87V6bvOwVg1tZJkqYPFWy0qZoUODAN8cCDL5wE6u0y8ZvmebmtjIxBcZolOiByX/Wi0Ngkm4MrQ6xlK/wI2XAU9dlBJ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Txn3wstr; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Txn3wstr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710520886; x=1742056886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JOgfJ3deDkMV1JdNjU6zW6ficQ6Eb4NB4SW3o1Ov5BQ=;
  b=Txn3wstrKpOxrB4fBloaHYE6ZxHM3EYwU3fJhd7Tg/MCX8hOmo1UFDtg
   6ayK/S///pY7aZ6W/mVYflzMCl1vK2oaRsDDVoWAZf1Xjzp/gOe5kWVDi
   Nv2VIdiygeoM+f9AA5TCC3MERyYU1CL2qEpAq0VN4CSkH/N1dlZaCj/H7
   CyAOliidmG9WjjQkE0dLGvLEsqa7k4rWMjklqbceiwOAs+RrzrqqnGeLO
   zoI9AJ0ZF71gFixy5GOhU3PNmp2cI/1K1qdKyWd2/SRm7K5YDrEwZkXPW
   ZV9afgSC7cLjhXUaLypp8CSmCC5CNkAgQPsS9RhZ38gDmyEDPm2qB3T4Z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5261512"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="5261512"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 09:41:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="13132264"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.163.132]) ([10.213.163.132])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 09:41:25 -0700
Message-ID: <f961eff1-ee32-49c0-ba5e-0e6806aae338@intel.com>
Date: Fri, 15 Mar 2024 09:41:24 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to cxl
 list
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1710386468.git.alison.schofield@intel.com>
 <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/24 9:05 PM, alison.schofield@intel.com wrote:
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
>  Documentation/cxl/cxl-list.txt | 62 +++++++++++++++++++++++++++++++++-
>  cxl/filter.h                   |  3 ++
>  cxl/list.c                     |  3 ++
>  3 files changed, 67 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 838de4086678..6d3ef92c29e8 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -415,6 +415,66 @@ OPTIONS
>  --region::
>  	Specify CXL region device name(s), or device id(s), to filter the listing.
>  
> +-L::
> +--media-errors::
> +	Include media-error information. The poison list is retrieved from the
> +	device(s) and media_error records are added to the listing. Apply this
> +	option to memdevs and regions where devices support the poison list
> +	capability. "offset:" is relative to the region resource when listing
> +	by region and is the absolute device DPA when listing by memdev.
> +	"source:" is one of: External, Internal, Injected, Vendor Specific,
> +	or Unknown, as defined in CXL Specification v3.1 Table 8-140.
> +
> +----
> +# cxl list -m mem9 --media-errors -u
> +{
> +  "memdev":"mem9",
> +  "pmem_size":"1024.00 MiB (1073.74 MB)",
> +  "pmem_qos_class":42,
> +  "ram_size":"1024.00 MiB (1073.74 MB)",
> +  "ram_qos_class":42,
> +  "serial":"0x5",
> +  "numa_node":1,
> +  "host":"cxl_mem.5",
> +  "media_errors":[
> +    {
> +      "offset":"0x40000000",
> +      "length":64,
> +      "source":"Injected"
> +    }
> +  ]
> +}
> +----
> +In the above example, region mappings can be found using:
> +"cxl list -p mem9 --decoders"
> +----
> +# cxl list -r region5 --media-errors -u
> +{
> +  "region":"region5",
> +  "resource":"0xf110000000",
> +  "size":"2.00 GiB (2.15 GB)",
> +  "type":"pmem",
> +  "interleave_ways":2,
> +  "interleave_granularity":4096,
> +  "decode_state":"commit",
> +  "media_errors":[
> +    {
> +      "offset":"0x1000",
> +      "length":64,
> +      "source":"Injected"
> +    },
> +    {
> +      "offset":"0x2000",
> +      "length":64,
> +      "source":"Injected"
> +    }
> +  ]
> +}
> +----
> +In the above example, memdev mappings can be found using:
> +"cxl list -r region5 --targets" and "cxl list -d <decoder_name>"
> +
> +
>  -v::
>  --verbose::
>  	Increase verbosity of the output. This can be specified
> @@ -431,7 +491,7 @@ OPTIONS
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
