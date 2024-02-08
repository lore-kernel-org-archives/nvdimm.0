Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3C7CF3C
	for <nvdimm@lists.linux.dev>; Thu,  8 Feb 2024 16:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707411031; cv=none; b=kJbFhSsCNgTRL0CyYhgYUjrWac0sjPDWQH8SOsWmkav0ICYFzXQS2Z8mzglumzFhWv2e2Wio6xDzjKey6FzLvn5bET9ZDHquGckfZ3aIx8qEE6+QeAWIX+LO1KsucDE8weu+XCa8J0kg/wyixONzRNfjIkHWu2iQ1rFYO5PCv0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707411031; c=relaxed/simple;
	bh=DSoHk/ZgItTz6A+D1+e4Y2fkXPRZNVOETY4IKo2hbL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n0bnB2NX/h+aLaFXyiQ4boxhDXVc18SiLIAEBCn0zy0no0XEbDDOKH6ZHrrSHaFSPDLbpYHPIar3HyV92D4+h0AwMsjiiNN/x7HnRdh/t+XQHBwM3gjaDfFrWkr8EDB++W6m+U9fzK9hApWbzIx5onL+CfO8bIUOP7z4afsmA7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K81cj1av; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K81cj1av"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707411030; x=1738947030;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DSoHk/ZgItTz6A+D1+e4Y2fkXPRZNVOETY4IKo2hbL0=;
  b=K81cj1avm62SDP/wV0eSgKF61T79D8f7xeIZ7U1plU0SChFD4A+PIKW6
   0F7m4f12T4ReDf3Rafn5Q+6ofSUunVAFjb/d9KlwlQve4InrFQh7K95+5
   5/QgVNSFovQoHxvMoK6SAwGpWm2djji9T5tkOarY4lkYfyb/G6SgPmJnx
   GqXNg+TW8y4AWXuksUMuBUiJveBbbjDyv0JVHOqPdFSiAYC3dOJJEiwkV
   n/d4WdYQntyUvtUuWZwaWVLOjKfeIE0l5wiL5F0c4HuP84jF+KEpuggPc
   bUZktfbDrJR/hRsqzaRYvkYJTYspJ9sCVLIjOl7gWdERx0Jr70BfT7DZE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="1555746"
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="1555746"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 08:50:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="934180770"
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="934180770"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.113.125]) ([10.246.113.125])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 08:50:28 -0800
Message-ID: <b3f23b92-99f6-404e-aed2-19a8f5ceb43f@intel.com>
Date: Thu, 8 Feb 2024 09:50:27 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v7 5/7] cxl/list: collect and parse media_error
 records
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1707351560.git.alison.schofield@intel.com>
 <566a2acff6a3f32a1d6af9d81fb0da8808e5b4ff.1707351560.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <566a2acff6a3f32a1d6af9d81fb0da8808e5b4ff.1707351560.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/7/24 6:01 PM, alison.schofield@intel.com wrote:
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
> ---
>  cxl/json.c | 261 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 261 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 7678d02020b6..bc104dd877a9 100644
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
> @@ -571,6 +575,251 @@ err_jobj:
>  	return NULL;
>  }
>  
> +/* CXL Spec 3.1 Table 8-140 Media Error Record */
> +#define CXL_POISON_SOURCE_UNKNOWN 0
> +#define CXL_POISON_SOURCE_EXTERNAL 1
> +#define CXL_POISON_SOURCE_INTERNAL 2
> +#define CXL_POISON_SOURCE_INJECTED 3
> +#define CXL_POISON_SOURCE_VENDOR 7
> +
> +/* CXL Spec 3.1 Table 8-139 Get Poison List Output Payload */
> +#define CXL_POISON_FLAG_MORE BIT(0)
> +#define CXL_POISON_FLAG_OVERFLOW BIT(1)
> +#define CXL_POISON_FLAG_SCANNING BIT(2)
> +
> +struct poison_ctx {
> +	struct json_object *jpoison;
> +	struct cxl_region *region;
> +	struct cxl_memdev *memdev;
> +	unsigned long flags;
> +};
> +
> +static const char *
> +find_decoder_name(struct poison_ctx *ctx, const char *name, u64 addr)
> +{
> +	struct cxl_memdev *memdev = ctx->memdev;
> +	struct cxl_memdev_mapping *mapping;
> +	struct cxl_endpoint *endpoint;
> +	struct cxl_decoder *decoder;
> +	struct cxl_port *port;
> +	u64 start, end;
> +
> +	if (memdev)
> +		goto find_decoder;
> +
> +	cxl_mapping_foreach(ctx->region, mapping) {
> +		decoder = cxl_mapping_get_decoder(mapping);
> +		if (!decoder)
> +			continue;
> +
> +		memdev = cxl_decoder_get_memdev(decoder);
> +		if (strcmp(name, cxl_memdev_get_devname(memdev)) == 0)
> +			break;
> +
> +		memdev = NULL;
> +	}
> +
> +find_decoder:

Would it be cleaner to move this block into a helper function? Don't really care for goto blocks that are not error handling paths.

> +	if (!memdev)
> +		return NULL;
> +
> +	endpoint = cxl_memdev_get_endpoint(memdev);
> +	port = cxl_endpoint_get_port(endpoint);
> +
> +	cxl_decoder_foreach(port, decoder) {
> +		start =  cxl_decoder_get_resource(decoder);
> +		end = start + cxl_decoder_get_size(decoder) - 1;
> +		if (start <= addr && addr <= end)
> +			return cxl_decoder_get_devname(decoder);
> +	}
> +
> +	return NULL;
> +}
> +
> +int poison_event_to_json(struct tep_event *event, struct tep_record *record,
> +			 void *ctx)
> +{
> +	struct poison_ctx *p_ctx = (struct poison_ctx *)ctx;
> +	struct json_object *jobj, *jp, *jpoison = p_ctx->jpoison;
> +	unsigned long flags = p_ctx->flags;
> +	bool overflow = false;
> +	unsigned char *data;
> +	const char *name;
> +	int pflags;
> +	char *str;
> +
> +	jp = json_object_new_object();
> +	if (!jp)
> +		return -ENOMEM;
> +
> +	/* Skip records not in this region when listing by region */
> +	name = p_ctx->region ? cxl_region_get_devname(p_ctx->region) : NULL;
> +	if (name)
> +		str = cxl_get_field_string(event, record, "region");
> +
> +	if ((name) && (strcmp(name, str) != 0)) {
> +		json_object_put(jp);
> +		return 0;
> +	}
> +
> +	/* Include endpoint decoder name with hpa, when present */
> +	name = cxl_get_field_string(event, record, "memdev");
> +	data = cxl_get_field_data(event, record, "hpa");
> +	if (*(uint64_t *)data != ULLONG_MAX)
> +		name = find_decoder_name(p_ctx, name, *(uint64_t *)data);
> +	else
> +		name = NULL;
> +
> +	if (name) {
> +		jobj = json_object_new_string(name);
> +		if (jobj)
> +			json_object_object_add(jp, "decoder", jobj);
> +
> +		jobj = util_json_object_hex(*(uint64_t *)data, flags);
> +		if (jobj)
> +			json_object_object_add(jp, "hpa", jobj);
> +	}
> +
> +	data = cxl_get_field_data(event, record, "dpa");
> +	jobj = util_json_object_hex(*(uint64_t *)data, flags);
> +	if (jobj)
> +		json_object_object_add(jp, "dpa", jobj);
> +
> +	data = cxl_get_field_data(event, record, "dpa_length");
> +	jobj = util_json_object_size(*(uint32_t *)data, flags);
> +	if (jobj)
> +		json_object_object_add(jp, "length", jobj);
> +
> +	str = cxl_get_field_string(event, record, "source");
> +	switch (*(uint8_t *)str) {

This causes reading confusion when it looks like the code is retrieving a string and then compare as an integer. Should this be done through cxl_get_field_data()?

> +	case CXL_POISON_SOURCE_UNKNOWN:
> +		jobj = json_object_new_string("Unknown");
> +		break;
> +	case CXL_POISON_SOURCE_EXTERNAL:
> +		jobj = json_object_new_string("External");
> +		break;
> +	case CXL_POISON_SOURCE_INTERNAL:
> +		jobj = json_object_new_string("Internal");
> +		break;
> +	case CXL_POISON_SOURCE_INJECTED:
> +		jobj = json_object_new_string("Injected");
> +		break;
> +	case CXL_POISON_SOURCE_VENDOR:
> +		jobj = json_object_new_string("Vendor");
> +		break;
> +	default:
> +		jobj = json_object_new_string("Reserved");
> +	}
> +	if (jobj)
> +		json_object_object_add(jp, "source", jobj);
> +
> +	str = cxl_get_field_string(event, record, "flags");
> +	pflags = *(uint8_t *)str;

Same as above comment here
> +	if (pflags) {
> +		char flag_str[32] = { '\0' };
> +
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
> +		data = cxl_get_field_data(event, record, "overflow_ts");
> +		jobj = util_json_object_hex(*(uint64_t *)data, flags);
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
> +		.private_ctx = p_ctx,
> +		.parse_event = poison_event_to_json,
> +	};
> +	int rc = 0;
> +
> +	p_ctx->jpoison = json_object_new_array();
> +	if (!p_ctx->jpoison)
> +		return NULL;
> +
> +	rc = cxl_parse_events(inst, &ectx);
> +	if (rc < 0) {
> +		fprintf(stderr, "Failed to parse events: %d\n", rc);
> +		json_object_put(p_ctx->jpoison);
> +		return NULL;

Maybe a goto err here and the next error path may now be warranted?
> +	}
> +
> +	if (json_object_array_length(p_ctx->jpoison) == 0) {
> +		json_object_put(p_ctx->jpoison);
> +		return NULL;
> +	}
> +
> +	return p_ctx->jpoison;
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
> @@ -649,6 +898,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
> @@ -987,6 +1242,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
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
