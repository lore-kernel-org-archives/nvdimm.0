Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7F645941
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710519392; cv=none; b=qE8JL4zE+3IwauCXPPfR8W0FpXhpkWoP5wSmbuTfHrS8W/QaW7EG9rPZlwA3HI51O0n8xRmtjmG6qqH+o3YOFNsEr+UjDl27JySsZM4A2QBAI4LKHAXHruv/xzcoFWJbDU7F0TCBCRlQh+p9uTTpdTeC5xN5CWgw1PU8w5uGhhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710519392; c=relaxed/simple;
	bh=MVRfTHbbAGRNhQ7OcE5/A6XrCb0vumbOCX2S4WQUQN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gnPd9RVIEowYIxnEJ7ROKKJQVOMJbJmLBNBE1TnJvCYDfnVLNpGDquJ7WPm4uK4SckPBd9MyWvADiGP2kwa21MPYGLwwXyuTx0ONm+tyrAaeQ8o12Vtz2SijRdklvKH6LCPQs5k1CksIRc37zjRLJDRtV+43f8Zrep5YFFmiaHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DOR62qrz; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DOR62qrz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710519389; x=1742055389;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MVRfTHbbAGRNhQ7OcE5/A6XrCb0vumbOCX2S4WQUQN0=;
  b=DOR62qrzHmZ+MjDwHQEiQfwK7RYle8tFxu5UGHzkyu70VHMuas+okHid
   zyyXpjk8PxR6SrKvOHSwU9xpCJ1yhIWTyRgxviZapDZl6isaj/aPfMGiS
   lkaGOjmI1FkpOPfAti1HiefecZQrpu/RqPEaiml+VeGHd7kKX+2d/xO8J
   byktawhyB4Y81R70u3FUXt2mHjf5h+Q0MwD7KxVuBjqAqZDPRuHpPNu0f
   jBXIvZZJ1aESllEDgfxpDG7DSQkbYpV3Qjj13wAuDa+fcSv5uqyFvuFpS
   u2SKBIoC0/BWeaS5GLm037+VCz2N43WrBbOt3fcYBjx1bukWJ3Bll1q5w
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5583698"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="5583698"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 09:16:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="13169984"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.163.132]) ([10.213.163.132])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 09:16:28 -0700
Message-ID: <ac942888-d774-4e0a-8734-7321a558fb07@intel.com>
Date: Fri, 15 Mar 2024 09:16:27 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v11 5/7] cxl/list: collect and parse media_error
 records
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1710386468.git.alison.schofield@intel.com>
 <20c83daf14ac45542e9b6ed4cddfaf659e0ce7b0.1710386468.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20c83daf14ac45542e9b6ed4cddfaf659e0ce7b0.1710386468.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/24 9:05 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Media_error records are logged as events in the kernel tracing
> subsystem. To prepare the media_error records for cxl list, enable
> tracing, trigger the poison list read, and parse the generated
> cxl_poison events into a json representation.
> 
> Use the event_trace private parsing option to customize the json
> representation based on cxl-list calling options and event field
> settings.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Minor nit below.
> ---
>  cxl/json.c | 194 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 194 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index fbe41c78e82a..974e98f13cec 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -1,16 +1,20 @@
>  // SPDX-License-Identifier: GPL-2.0
>  // Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
>  #include <limits.h>
> +#include <errno.h>
>  #include <util/json.h>
> +#include <util/bitmap.h>
>  #include <uuid/uuid.h>
>  #include <cxl/libcxl.h>
>  #include <json-c/json.h>
>  #include <json-c/printbuf.h>
>  #include <ccan/short_types/short_types.h>
> +#include <tracefs/tracefs.h>
>  
>  #include "filter.h"
>  #include "json.h"
>  #include "../daxctl/json.h"
> +#include "event_trace.h"
>  
>  #define CXL_FW_VERSION_STR_LEN	16
>  #define CXL_FW_MAX_SLOTS	4
> @@ -571,6 +575,184 @@ err_jobj:
>  	return NULL;
>  }
>  
> +/* CXL Spec 3.1 Table 8-140 Media Error Record */
> +#define CXL_POISON_SOURCE_MAX 7
> +static const char *poison_source[] = { "Unknown",  "External", "Internal",
> +				       "Injected", "Reserved", "Reserved",
> +				       "Reserved", "Vendor" };
> +
> +/* CXL Spec 3.1 Table 8-139 Get Poison List Output Payload */
> +#define CXL_POISON_FLAG_MORE BIT(0)
> +#define CXL_POISON_FLAG_OVERFLOW BIT(1)
> +#define CXL_POISON_FLAG_SCANNING BIT(2)
> +
> +static int poison_event_to_json(struct tep_event *event,
> +				struct tep_record *record,
> +				struct event_ctx *e_ctx)
> +{
> +	struct poison_ctx *p_ctx = e_ctx->poison_ctx;
> +	struct json_object *jp, *jobj, *jpoison = p_ctx->jpoison;
> +	struct cxl_memdev *memdev = p_ctx->memdev;
> +	struct cxl_region *region = p_ctx->region;
> +	unsigned long flags = p_ctx->flags;
> +	const char *region_name = NULL;
> +	char flag_str[32] = { '\0' };
> +	bool overflow = false;
> +	u8 source, pflags;
> +	u64 offset, ts;
> +	u32 length;
> +	char *str;
> +	int len;
> +
> +	jp = json_object_new_object();
> +	if (!jp)
> +		return -ENOMEM;
> +
> +	/* Skip records not in this region when listing by region */
> +	if (region)
> +		region_name = cxl_region_get_devname(region);
> +	if (region_name)
> +		str = tep_get_field_raw(NULL, event, "region", record, &len, 0);
> +	if ((region_name) && (strcmp(region_name, str) != 0)) {
> +		json_object_put(jp);
> +		return 0;
> +	}
> +	/* Include offset,length by region (hpa) or by memdev (dpa) */
> +	if (region) {
> +		offset = cxl_get_field_u64(event, record, "hpa");
> +		if (offset != ULLONG_MAX) {
> +			offset = offset - cxl_region_get_resource(region);
> +			jobj = util_json_object_hex(offset, flags);
> +			if (jobj)
> +				json_object_object_add(jp, "offset", jobj);
> +		}
> +	} else if (memdev) {
> +		offset = cxl_get_field_u64(event, record, "dpa");
> +		if (offset != ULLONG_MAX) {
> +			jobj = util_json_object_hex(offset, flags);
> +			if (jobj)
> +				json_object_object_add(jp, "offset", jobj);
> +		}
> +	}
> +	length = cxl_get_field_u32(event, record, "dpa_length");
> +	jobj = util_json_object_size(length, flags);
> +	if (jobj)
> +		json_object_object_add(jp, "length", jobj);
> +
> +	/* Always include the poison source */
> +	source = cxl_get_field_u8(event, record, "source");
> +	if (source <= CXL_POISON_SOURCE_MAX)
> +		jobj = json_object_new_string(poison_source[source]);
> +	else
> +		jobj = json_object_new_string("Reserved");
> +	if (jobj)
> +		json_object_object_add(jp, "source", jobj);
> +
> +	/* Include flags and overflow time if present */
> +	pflags = cxl_get_field_u8(event, record, "flags");
> +	if (pflags && pflags < UCHAR_MAX) {
> +		if (pflags & CXL_POISON_FLAG_MORE)
> +			strcat(flag_str, "More,");
> +		if (pflags & CXL_POISON_FLAG_SCANNING)
> +			strcat(flag_str, "Scanning,");
> +		if (pflags & CXL_POISON_FLAG_OVERFLOW) {
> +			strcat(flag_str, "Overflow,");
> +			overflow = true;
> +		}
> +		jobj = json_object_new_string(flag_str);
> +		if (jobj)
> +			json_object_object_add(jp, "flags", jobj);
> +	}
> +	if (overflow) {
> +		ts = cxl_get_field_u64(event, record, "overflow_ts");
> +		jobj = util_json_object_hex(ts, flags);
> +		if (jobj)
> +			json_object_object_add(jp, "overflow_t", jobj);
> +	}
> +	json_object_array_add(jpoison, jp);
> +
> +	return 0;
> +}
> +
> +static struct json_object *
> +util_cxl_poison_events_to_json(struct tracefs_instance *inst,
> +			       struct poison_ctx *p_ctx)
> +{
> +	struct event_ctx ectx = {
> +		.event_name = "cxl_poison",
> +		.event_pid = getpid(),
> +		.system = "cxl",
> +		.poison_ctx = p_ctx,
> +		.parse_event = poison_event_to_json,
> +	};
> +	int rc = 0;

No need to init rc here. 

DJ

> +
> +	p_ctx->jpoison = json_object_new_array();
> +	if (!p_ctx->jpoison)
> +		return NULL;
> +
> +	rc = cxl_parse_events(inst, &ectx);
> +	if (rc < 0) {
> +		fprintf(stderr, "Failed to parse events: %d\n", rc);
> +		goto put_jobj;
> +	}
> +	if (json_object_array_length(p_ctx->jpoison) == 0)
> +		goto put_jobj;
> +
> +	return p_ctx->jpoison;
> +
> +put_jobj:
> +	json_object_put(p_ctx->jpoison);
> +	return NULL;
> +}
> +
> +static struct json_object *
> +util_cxl_poison_list_to_json(struct cxl_region *region,
> +			     struct cxl_memdev *memdev,
> +			     unsigned long flags)
> +{
> +	struct json_object *jpoison = NULL;
> +	struct poison_ctx p_ctx;
> +	struct tracefs_instance *inst;
> +	int rc;
> +
> +	inst = tracefs_instance_create("cxl list");
> +	if (!inst) {
> +		fprintf(stderr, "tracefs_instance_create() failed\n");
> +		return NULL;
> +	}
> +
> +	rc = cxl_event_tracing_enable(inst, "cxl", "cxl_poison");
> +	if (rc < 0) {
> +		fprintf(stderr, "Failed to enable trace: %d\n", rc);
> +		goto err_free;
> +	}
> +
> +	if (region)
> +		rc = cxl_region_trigger_poison_list(region);
> +	else
> +		rc = cxl_memdev_trigger_poison_list(memdev);
> +	if (rc)
> +		goto err_free;
> +
> +	rc = cxl_event_tracing_disable(inst);
> +	if (rc < 0) {
> +		fprintf(stderr, "Failed to disable trace: %d\n", rc);
> +		goto err_free;
> +	}
> +
> +	p_ctx = (struct poison_ctx) {
> +		.region = region,
> +		.memdev = memdev,
> +		.flags = flags,
> +	};
> +	jpoison = util_cxl_poison_events_to_json(inst, &p_ctx);
> +
> +err_free:
> +	tracefs_instance_free(inst);
> +	return jpoison;
> +}
> +
>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		unsigned long flags)
>  {
> @@ -664,6 +846,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  			json_object_object_add(jdev, "firmware", jobj);
>  	}
>  
> +	if (flags & UTIL_JSON_MEDIA_ERRORS) {
> +		jobj = util_cxl_poison_list_to_json(NULL, memdev, flags);
> +		if (jobj)
> +			json_object_object_add(jdev, "media_errors", jobj);
> +	}
> +
>  	json_object_set_userdata(jdev, memdev, NULL);
>  	return jdev;
>  }
> @@ -1012,6 +1200,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  			json_object_object_add(jregion, "state", jobj);
>  	}
>  
> +	if (flags & UTIL_JSON_MEDIA_ERRORS) {
> +		jobj = util_cxl_poison_list_to_json(region, NULL, flags);
> +		if (jobj)
> +			json_object_object_add(jregion, "media_errors", jobj);
> +	}
> +
>  	util_cxl_mappings_append_json(jregion, region, flags);
>  
>  	if (flags & UTIL_JSON_DAX) {
