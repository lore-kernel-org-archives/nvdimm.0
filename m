Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF86631815D
	for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 20:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765397595; cv=none; b=LxeytFNgH3gbnq+c8OWIDVD4G2txvkJyT1VmnebKyJ2cRc9HkVaKKpAGDnwdTEBwlc9K4svM2H6AtzODlfT6ZvxxtEwA4fxkvJIjs2G+XmDJHBVXg+5sim/f4uSIAD4T5N6zotMrX1+J7sJZESUFBWc6NPgV10gmPUEFAR25gmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765397595; c=relaxed/simple;
	bh=Cty1Wo/Q7KF/KG8eV4ad6upNZw7Pt8CsLueUwI7MVAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UpjWA2YfWepkSLHOSZuyKSUCIqI15Gm9MFRD1LY0AJKqtBT9t5atgeoce31lqcyn+M1pHpJS7R58B2FHl/TQMOWCQcKo5O+/qtGa86mXO9wKAQz9/HuRJNpcIEzYYOpxjz7zNwlfT0pKScroaZUUMmYS2dRyCZ0AonnD1UnSGFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EpNSc1D8; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EpNSc1D8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765397594; x=1796933594;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cty1Wo/Q7KF/KG8eV4ad6upNZw7Pt8CsLueUwI7MVAw=;
  b=EpNSc1D8q5dQ3OtdiD8KuwBAovFPsTFYIvKKMNkY+uidgQd2kQlxSnpE
   po/kOMCoaZA+7cFFLZkOBq3SKEU/zuui58LBxF+eqxjJx2tXADT2uLhee
   jTADYmWtHxGM0PoJ6pFFHIR8t4zstfnwQTcU5K+Zzjz4YO/ixNFdPBDSZ
   qS60AOHCxTpOpdTmvyOnjVhr8cvSjP7sC9JAanrrwWW6wRKsR9jC7nCjK
   ErxLfPMaqi8+PIqwjbe4+UYwwt+zDObOudWQLjjALV3EjmPwmZjTIWGH8
   XpNOwiJrLtAiMAh5azykjzTp2z2NWeXNMMqdUzwEd4GwMjJnR6s5PmlJ9
   g==;
X-CSE-ConnectionGUID: 1hM5Tvr5Rly+0PbIPgMghA==
X-CSE-MsgGUID: PMmx2JZuQAS2iT+4hqfltg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67263950"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67263950"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:13:13 -0800
X-CSE-ConnectionGUID: haSZijvsTZ2U12iKheYXDg==
X-CSE-MsgGUID: IdWyOtd2S1WVs5XDy2YozQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="196665024"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.138]) ([10.125.109.138])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:13:13 -0800
Message-ID: <c3adf680-0490-47dd-aff4-ca507e0044b7@intel.com>
Date: Wed, 10 Dec 2025 13:13:12 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/7] cxl/list: Add injectable errors in output
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-7-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209171404.64412-7-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 10:14 AM, Ben Cheatham wrote:
> Add the "--injectable-errors"/"-N" option to show injectable error
> information for CXL devices. The applicable devices are CXL memory
> devices and CXL busses.
> 
> For CXL memory devices the option reports whether the device supports
> poison injection (the "--media-errors"/"-L" option shows injected
> poison).
> 
> For CXL busses the option shows injectable CXL protocol error types. The
> information will be the same across busses because the error types are
> system-wide. The information is presented under the bus for easier
> filtering.
> 
> Update the man page for 'cxl-list' to show the usage of the new option.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  Documentation/cxl/cxl-list.txt | 35 +++++++++++++++++++++++++++++++++-
>  cxl/filter.h                   |  3 +++
>  cxl/json.c                     | 30 +++++++++++++++++++++++++++++
>  cxl/list.c                     |  3 +++
>  util/json.h                    |  1 +
>  5 files changed, 71 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 0595638..35ff542 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -471,6 +471,38 @@ The media-errors option is only available with '-Dlibtracefs=enabled'.
>  }
>  ----
>  
> +-N::
> +--injectable-errors::
> +	Include injectable error information in the output. For CXL memory devices
> +	this includes whether poison is injectable through the kernel debug filesystem.
> +	The types of CXL protocol errors available for injection into downstream ports
> +	are listed as part of a CXL bus object.
> +
> +----
> +# cxl list -NB
> +[
> +  {
> +	"bus":"root0",
> +	"provider":"ACPI.CXL",
> +	"injectable_protocol_errors":[
> +	  "mem-correctable",
> +	  "mem-fatal",
> +	]
> +  }
> +]
> +
> +# cxl list -N
> +[
> +  {
> +    "memdev":"mem0",
> +    "pmem_size":268435456,
> +    "ram_size":268435456,
> +    "serial":2,
> +	"poison_injectable":true
> +  }
> +]
> +
> +----
>  -v::
>  --verbose::
>  	Increase verbosity of the output. This can be specified
> @@ -487,7 +519,8 @@ The media-errors option is only available with '-Dlibtracefs=enabled'.
>  	  devices with --idle.
>  	- *-vvv*
>  	  Everything *-vv* provides, plus enable
> -	  --health, --partition, and --media-errors.
> +	  --health, --partition, --media-errors, and
> +	  --injectable-errors.
>  
>  --debug::
>  	If the cxl tool was built with debug enabled, turn on debug
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 70463c4..6c5fe68 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -31,6 +31,7 @@ struct cxl_filter_params {
>  	bool alert_config;
>  	bool dax;
>  	bool media_errors;
> +	bool inj_errors;
>  	int verbose;
>  	struct log_ctx ctx;
>  };
> @@ -93,6 +94,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
>  		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
>  	if (param->media_errors)
>  		flags |= UTIL_JSON_MEDIA_ERRORS;
> +	if (param->inj_errors)
> +		flags |= UTIL_JSON_INJ_ERRORS;
>  	return flags;
>  }
>  
> diff --git a/cxl/json.c b/cxl/json.c
> index bde4589..2917477 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -675,6 +675,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  			json_object_object_add(jdev, "firmware", jobj);
>  	}
>  
> +	if (flags & UTIL_JSON_INJ_ERRORS) {
> +		jobj = json_object_new_boolean(cxl_memdev_has_poison_injection(memdev));
> +		if (jobj)
> +			json_object_object_add(jdev, "poison_injectable", jobj);
> +	}
> +
>  	if (flags & UTIL_JSON_MEDIA_ERRORS) {
>  		jobj = util_cxl_poison_list_to_json(NULL, memdev, flags);
>  		if (jobj)
> @@ -750,6 +756,8 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
>  					 unsigned long flags)
>  {
>  	const char *devname = cxl_bus_get_devname(bus);
> +	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
> +	struct cxl_protocol_error *perror;
>  	struct json_object *jbus, *jobj;
>  
>  	jbus = json_object_new_object();
> @@ -765,6 +773,28 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
>  		json_object_object_add(jbus, "provider", jobj);
>  
>  	json_object_set_userdata(jbus, bus, NULL);
> +
> +	if (flags & UTIL_JSON_INJ_ERRORS) {
> +		jobj = json_object_new_array();
> +		if (!jobj)
> +			return jbus;
> +
> +		cxl_protocol_error_foreach(ctx, perror)
> +		{
> +			struct json_object *jerr_str;
> +			const char *perror_str;
> +
> +			perror_str = cxl_protocol_error_get_str(perror);
> +
> +			jerr_str = json_object_new_string(perror_str);
> +			if (jerr_str)
> +				json_object_array_add(jobj, jerr_str);
> +		}
> +
> +		json_object_object_add(jbus, "injectable_protocol_errors",
> +				       jobj);
> +	}
> +
>  	return jbus;
>  }
>  
> diff --git a/cxl/list.c b/cxl/list.c
> index 0b25d78..a505ed6 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -59,6 +59,8 @@ static const struct option options[] = {
>  		    "include alert configuration information"),
>  	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
>  		    "include media-error information "),
> +	OPT_BOOLEAN('N', "injectable-errors", &param.inj_errors,
> +		    "include injectable error information"),
>  	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
>  #ifdef ENABLE_DEBUG
>  	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
> @@ -124,6 +126,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.alert_config = true;
>  		param.dax = true;
>  		param.media_errors = true;
> +		param.inj_errors = true;
>  		/* fallthrough */
>  	case 2:
>  		param.idle = true;
> diff --git a/util/json.h b/util/json.h
> index 560f845..57278cb 100644
> --- a/util/json.h
> +++ b/util/json.h
> @@ -21,6 +21,7 @@ enum util_json_flags {
>  	UTIL_JSON_TARGETS	= (1 << 11),
>  	UTIL_JSON_PARTITION	= (1 << 12),
>  	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
> +	UTIL_JSON_INJ_ERRORS	= (1 << 14),
>  };
>  
>  void util_display_json_array(FILE *f_out, struct json_object *jarray,

