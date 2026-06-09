Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4626A15E8B
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 00:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780963703; cv=none; b=fNlcYDh0FWXm3fd+sRC8uqBz8I7pL2+Fq43L2I1ow9IOZ54O9qd7GPeEojci3lywIBEqxugjrHegm6JRbrwJCVk0L8SNf2eTRL2/y+dpnQeCjy+QLAbzpe2bFfVWTaMqw7mSkZgAnuQtPGDqLZHESJ93DFJA7SCQst80jyrZEbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780963703; c=relaxed/simple;
	bh=yyHA3Gxmjm153UN8ZtHkWgLZnMIMW5++QuzDMn6jDmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TLIrkQkFKs1LsftsFL/2+rqkbZMBfSk9sNhoV8FuDMTUfbkPjey9qVul2Z9oKZcjpb9ZMo1GHOftb3npky79yWigHZcQDEw5LQWO3ixqrN9gBswmtHxHjZQZYZ9mDmDpzyB24R0KdEcsSvKBMTF989X5bSvOzvhsnG7+H7xbXD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JF0mddCF; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JF0mddCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780963701; x=1812499701;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yyHA3Gxmjm153UN8ZtHkWgLZnMIMW5++QuzDMn6jDmw=;
  b=JF0mddCFA4F7aEoZWR+YtMhUmZAcHd6cHTWGWP4oQhQQ0NMR9FLbR7O0
   5LKxI6i2CAlJy6gfz5zi4tu3Z0jolrZVcSdzkKSQZbJRwO4BR+aUQD4Rw
   StbNBBM+5GMb5ZqptBHLpoTUFHRGVCq1CoVMsqa96yVGjAIVx52atK7iL
   69njkJlc0Kw2ZWeHLhhI4DdadSP/tjPiG6FSP7LU+lm+yHYd162/dExzK
   P5SY11xZZ2U//i0dEx8GNEIY6jAcQCTpdAJyZSNmBSQjFO/Z2g+0dTJeh
   DoLZ6mI7F4N+FTIb22fNL2HiVpSDUQ9K+ierjQFAeLtX2xmglYleeBPTe
   A==;
X-CSE-ConnectionGUID: 7hq+B93jR0CMdat3wwWi+A==
X-CSE-MsgGUID: e18O2gt+Tqe+1MR4TkBSWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="81715898"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="81715898"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 17:08:20 -0700
X-CSE-ConnectionGUID: Zs2nbYkKT4i987hQufalBQ==
X-CSE-MsgGUID: vnVbXQp1T7ys8Qm0lihhFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="275881636"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 17:08:20 -0700
Message-ID: <ad25c4ad-b967-46c5-a983-a0c0ceb7d825@intel.com>
Date: Mon, 8 Jun 2026 17:08:19 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/7] cxl/region: Add extent output to region query
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Alison Schofield
 <alison.schofield@intel.com>, John Groves <John@Groves.net>,
 Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-6-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260523095043.471098-6-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:50 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> DCD regions have 0 or more extents.  The ability to list those and their
> properties is useful to end users.
> 
> Add an option for extent output to region queries.  An example of this
> is:
> 
> 	$ ./build/cxl/cxl list -r 8 -Nu
> 	{
> 	  "region":"region8",
> 	  ...
> 	  "type":"dc",
> 	  ...
> 	  "extents":[
> 	    {
> 	      "offset":"0x10000000",
> 	      "length":"64.00 MiB (67.11 MB)",
> 	      "tag":"00000000-0000-0000-0000-000000000000"

I think the code emits "uuid". Update commit log.
> 	    },
> 	    {
> 	      "offset":"0x8000000",
> 	      "length":"64.00 MiB (67.11 MB)",
> 	      "tag":"00000000-0000-0000-0000-000000000000"

same here

DJ

> 	    }
> 	  ]
> 	}
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: s/tag/uuid/]
> ---
>  Documentation/cxl/cxl-list.txt | 29 +++++++++++++++++++++
>  cxl/filter.h                   |  3 +++
>  cxl/json.c                     | 47 ++++++++++++++++++++++++++++++++++
>  cxl/json.h                     |  3 +++
>  cxl/list.c                     |  3 +++
>  util/json.h                    |  1 +
>  6 files changed, 86 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 193860b..7512687 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -426,6 +426,35 @@ OPTIONS
>  }
>  ----
>  
> +-N::
> +--extents::
> +	Append Dynamic Capacity extent information.
> +----
> +13:34:28 > ./build/cxl/cxl list -r 8 -Nu
> +{
> +  "region":"region8",
> +  "resource":"0xf030000000",
> +  "size":"512.00 MiB (536.87 MB)",
> +  "type":"dc",
> +  "interleave_ways":1,
> +  "interleave_granularity":256,
> +  "decode_state":"commit",
> +  "extents":[
> +    {
> +      "offset":"0x10000000",
> +      "length":"64.00 MiB (67.11 MB)",
> +      "uuid":"00000000-0000-0000-0000-000000000000"
> +    },
> +    {
> +      "offset":"0x8000000",
> +      "length":"64.00 MiB (67.11 MB)",
> +      "uuid":"00000000-0000-0000-0000-000000000000"
> +    }
> +  ]
> +}
> +----
> +
> +
>  -r::
>  --region::
>  	Specify CXL region device name(s), or device id(s), to filter the listing.
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 70463c4..30e7fe2 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -31,6 +31,7 @@ struct cxl_filter_params {
>  	bool alert_config;
>  	bool dax;
>  	bool media_errors;
> +	bool extents;
>  	int verbose;
>  	struct log_ctx ctx;
>  };
> @@ -93,6 +94,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
>  		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
>  	if (param->media_errors)
>  		flags |= UTIL_JSON_MEDIA_ERRORS;
> +	if (param->extents)
> +		flags |= UTIL_JSON_EXTENTS;
>  	return flags;
>  }
>  
> diff --git a/cxl/json.c b/cxl/json.c
> index e94c809..7922b32 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -1022,6 +1022,50 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
>  	json_object_object_add(jregion, "mappings", jmappings);
>  }
>  
> +void util_cxl_extents_append_json(struct json_object *jregion,
> +				  struct cxl_region *region,
> +				  unsigned long flags)
> +{
> +	struct json_object *jextents;
> +	struct cxl_region_extent *extent;
> +
> +	jextents = json_object_new_array();
> +	if (!jextents)
> +		return;
> +
> +	cxl_extent_foreach(region, extent) {
> +		struct json_object *jextent, *jobj;
> +		unsigned long long val;
> +		char uuid_str[40];
> +		uuid_t uuid;
> +
> +		jextent = json_object_new_object();
> +		if (!jextent)
> +			continue;
> +
> +		val = cxl_extent_get_offset(extent);
> +		jobj = util_json_object_hex(val, flags);
> +		if (jobj)
> +			json_object_object_add(jextent, "offset", jobj);
> +
> +		val = cxl_extent_get_length(extent);
> +		jobj = util_json_object_size(val, flags);
> +		if (jobj)
> +			json_object_object_add(jextent, "length", jobj);
> +
> +		cxl_extent_get_uuid(extent, uuid);
> +		uuid_unparse(uuid, uuid_str);
> +		jobj = json_object_new_string(uuid_str);
> +		if (jobj)
> +			json_object_object_add(jextent, "uuid", jobj);
> +
> +		json_object_array_add(jextents, jextent);
> +		json_object_set_userdata(jextent, extent, NULL);
> +	}
> +
> +	json_object_object_add(jregion, "extents", jextents);
> +}
> +
>  struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  					     unsigned long flags)
>  {
> @@ -1126,6 +1170,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  		}
>  	}
>  
> +	if (flags & UTIL_JSON_EXTENTS)
> +		util_cxl_extents_append_json(jregion, region, flags);
> +
>  	if (cxl_region_qos_class_mismatch(region)) {
>  		jobj = json_object_new_boolean(true);
>  		if (jobj)
> diff --git a/cxl/json.h b/cxl/json.h
> index eb7572b..f9c07ab 100644
> --- a/cxl/json.h
> +++ b/cxl/json.h
> @@ -20,6 +20,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  void util_cxl_mappings_append_json(struct json_object *jregion,
>  				  struct cxl_region *region,
>  				  unsigned long flags);
> +void util_cxl_extents_append_json(struct json_object *jregion,
> +				  struct cxl_region *region,
> +				  unsigned long flags);
>  void util_cxl_targets_append_json(struct json_object *jdecoder,
>  				  struct cxl_decoder *decoder,
>  				  const char *ident, const char *serial,
> diff --git a/cxl/list.c b/cxl/list.c
> index 0b25d78..47d1351 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -59,6 +59,8 @@ static const struct option options[] = {
>  		    "include alert configuration information"),
>  	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
>  		    "include media-error information "),
> +	OPT_BOOLEAN('N', "extents", &param.extents,
> +		    "include extent information (Dynamic Capacity regions only)"),
>  	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
>  #ifdef ENABLE_DEBUG
>  	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
> @@ -135,6 +137,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.decoders = true;
>  		param.targets = true;
>  		param.regions = true;
> +		param.extents = true;
>  		/*fallthrough*/
>  	case 0:
>  		break;
> diff --git a/util/json.h b/util/json.h
> index 560f845..79ae324 100644
> --- a/util/json.h
> +++ b/util/json.h
> @@ -21,6 +21,7 @@ enum util_json_flags {
>  	UTIL_JSON_TARGETS	= (1 << 11),
>  	UTIL_JSON_PARTITION	= (1 << 12),
>  	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
> +	UTIL_JSON_EXTENTS	= (1 << 14),
>  };
>  
>  void util_display_json_array(FILE *f_out, struct json_object *jarray,

