Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D280A2472AA
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 17:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153518; cv=none; b=DirkopAAoxmvxsyflx2SvCJpZUOX5dQCi+xEhpXG7WknDhWI/S4aqugaStWgmdXhul+bh01eAhaRZ+3RMOqGl+JU8jTV31i5C1vHLJXXbf4kyNcFreZ62iutqH4u1P2qSS/LqWDSumKQwt1XFmsv2iNQxFSeIhlvQtfavGQB+jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153518; c=relaxed/simple;
	bh=MvWU16vKox1u9R9ViJt9Ay/Ms5zb2ZyHucH1KFbbzo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzLXpI1UvgVbZmYctIChj+4nF1wrq1f3RJ7LLrAZ2+RbwVurhtlZhDo1QZm4kn5GPV9ydfFtTNidWCCHH/2yJ/lgBRV1erGUxvIVjn0QyTuB1/5ccrv220V4FA6PtXudQ6bBxWne3jHMCHfjDp8lRrKZUclS0756KGZmV/OjMAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CUC3lc74; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CUC3lc74"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761153516; x=1792689516;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MvWU16vKox1u9R9ViJt9Ay/Ms5zb2ZyHucH1KFbbzo4=;
  b=CUC3lc74CN2P9EkbZwfwIK+njBdAsSwpPMX+hNWH3zeEOMcMdlV0L/qH
   0U7HucEifHRmW5zIb/q2sFgQ+QGEsH3Yx0oyqptZEJiFqaXEDunHWzPLI
   pJ7Soc82AQzBiJtsAhScyHmHthTxBN6WW5X/eTtarwT1+fNEtwj34oZY+
   IxlumV2aKJZUJSvZ3fQ2sAMyovM90DVgYvssSGOmFErpZMKA50MO3Blkv
   r8ZUcJBViz3eYFzo3GdT84yP2pzUKtCZT6/R9Jv6nr4FjylUQQPFUQNgt
   fo5cfJZEqzhq0PGy1B1HUobm1we6p50imjd6i8CHTzeXGQFJK3SPqmkML
   g==;
X-CSE-ConnectionGUID: 3G+vgo7iRhq8MHc18ogNhA==
X-CSE-MsgGUID: fERa4XmqSJ6eJ931rJLCiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63206177"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="63206177"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 10:18:35 -0700
X-CSE-ConnectionGUID: bYBGWtXxS/qB95gJVTo7UQ==
X-CSE-MsgGUID: j3rdhbhNT1SARhD/kZ3B1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="183518120"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.108.213]) ([10.125.108.213])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 10:18:34 -0700
Message-ID: <d3e7142c-3b4f-40fb-9917-c1016961808f@intel.com>
Date: Wed, 22 Oct 2025 10:18:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 6/7] cxl/list: Add injectable errors in output
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-7-Benjamin.Cheatham@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251021183124.2311-7-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/25 11:31 AM, Ben Cheatham wrote:
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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
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
> index 956a46e..34f8387 100644
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
> @@ -91,6 +92,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
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

