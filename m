Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E979927
	for <nvdimm@lists.linux.dev>; Mon,  4 Mar 2024 20:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709582646; cv=none; b=aXfVdrerCa5OPKscIBHT2jkouW9qnCfq27CnCvEfGQwBto/F4UDq0Kb+S0qyWKShlLkUMJNeoaTKG4jR6wI0sahaNo0+RhWO0oIjsmjntaq71zH0ujP+xsfCfj4U6KOHdXpkbhMR6lE13UP6loXEsbuiXf5TpKiGpwsrfGmMBv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709582646; c=relaxed/simple;
	bh=yeCbFuOd3h+1orcXY+Jp7ZnVYvQ/7l6lTX4m/X6df1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BVmd8FrgUNgpy4+Gx4A3bzJNF+YJIRhNa+pgTTcszRiJ05TS+mo/IaduziBljHyTjQ5JaCu5qJZivi4DNHDm1+vR9SzV+Y0cfncbIuxC5z7Zm6IAU221QCZe5HozLL2MKpDVthO/inPt89xRoH/JKRL59rlYSGXXD2vLgiSyyLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YoFqLDYA; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YoFqLDYA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709582644; x=1741118644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yeCbFuOd3h+1orcXY+Jp7ZnVYvQ/7l6lTX4m/X6df1M=;
  b=YoFqLDYAYvtHG2Jxc2cX1O5r5nQgicPtjf6t+UmmiFifc4kZ6XAlb6lX
   aOmTFYj19skVWZqnnNYvaBkY6EKLFzAur7S43ybSdkqat2SuqwHu1ytfw
   IIdry8iesy1cgI+Z36gfWKLQOXSBNosAko6x2UeNoqQOb3d2eO3i1v9lF
   lINviE0S6Wvx7DjJr7QYJ17CuiDEKVlSPGY5SMDr03uDs5c+lMs/RfRx1
   F33dsUe02uWRINddVpsYnfHgomXBMgNNpj+wKYuBqrChXb3FlHTF3sYiX
   codJ8Du9sDuTG7emtHaM+5vIJnUe+atoQyV1IsKWZOdwu9lnLRpAdQcIx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="15530429"
X-IronPort-AV: E=Sophos;i="6.06,204,1705392000"; 
   d="scan'208";a="15530429"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 12:04:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,204,1705392000"; 
   d="scan'208";a="13777522"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.247.118.63]) ([10.247.118.63])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 12:04:00 -0800
Message-ID: <85f2763b-6665-4f76-9175-d7c5acaf2a3d@intel.com>
Date: Mon, 4 Mar 2024 13:03:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v9 5/7] cxl/list: collect and parse media_error
 records
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1709253898.git.alison.schofield@intel.com>
 <9a6be3fd24b22661ec39ea614f75266b594026b3.1709253898.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <9a6be3fd24b22661ec39ea614f75266b594026b3.1709253898.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/29/24 6:31 PM, alison.schofield@intel.com wrote:
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
>  cxl/json.c | 271 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 271 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 7678d02020b6..c681176aa483 100644
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
> @@ -571,6 +575,261 @@ err_jobj:
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
> +static struct cxl_memdev *find_memdev(struct cxl_region *region,
> +				      const char *memdev_name)
> +{
> +	struct cxl_memdev_mapping *mapping;
> +	struct cxl_decoder *decoder;
> +	struct cxl_memdev *memdev;
> +
> +	cxl_mapping_foreach(region, mapping)
> +	{
> +		decoder = cxl_mapping_get_decoder(mapping);
> +		if (!decoder)
> +			continue;
> +
> +		memdev = cxl_decoder_get_memdev(decoder);
> +		if (strcmp(memdev_name, cxl_memdev_get_devname(memdev)) == 0)
> +			break;
> +
> +		memdev = NULL;
> +	}
> +	return memdev;
> +}
> +
> +static const char *find_decoder_name(struct poison_ctx *ctx,
> +				     const char *memdev_name, u64 addr)
> +{
> +	struct cxl_memdev *memdev = ctx->memdev;
> +	const char *decoder_name = NULL;
> +	struct cxl_endpoint *endpoint;
> +	struct cxl_decoder *decoder;
> +	struct cxl_port *port;
> +	u64 start, end;
> +
> +	if (!memdev)
> +		memdev = find_memdev(ctx->region, memdev_name);
> +
> +	if (!memdev)
> +		return NULL;
> +
> +	endpoint = cxl_memdev_get_endpoint(memdev);
> +	port = cxl_endpoint_get_port(endpoint);
> +
> +	cxl_decoder_foreach(port, decoder) {
> +		start =  cxl_decoder_get_resource(decoder);
> +		end = start + cxl_decoder_get_size(decoder) - 1;
> +		if (start <= addr && addr <= end) {
> +			decoder_name = cxl_decoder_get_devname(decoder);
> +			break;
> +		}
> +	}
> +	return decoder_name;
> +}
> +
> +static int poison_event_to_json(struct tep_event *event,
> +				struct tep_record *record, void *ctx)
> +{
> +	struct poison_ctx *p_ctx = (struct poison_ctx *)ctx;
> +	struct json_object *jobj, *jp, *jpoison = p_ctx->jpoison;
> +	unsigned long flags = p_ctx->flags;
> +	char flag_str[32] = { '\0' };
> +	bool overflow = false;
> +	u8 source, pflags;
> +	const char *name;
> +	u64 addr, ts;
> +	u32 length;
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
> +	addr = cxl_get_field_u64(event, record, "hpa");
> +	if (addr != ULLONG_MAX)
> +		name = find_decoder_name(p_ctx, name, addr);
> +	else
> +		name = NULL;

Why assign name a few lines above and then reassign here without using? Also I noticed the name gets reassigned for different purposes a few times. Can we have separate variables in order to make the code cleaner to read? I think maybe a region_name and a decoder_name.

> +
> +	if (name) {
> +		jobj = json_object_new_string(name);
> +		if (jobj)
> +			json_object_object_add(jp, "decoder", jobj);
> +
> +		jobj = util_json_object_hex(addr, flags);
> +		if (jobj)
> +			json_object_object_add(jp, "hpa", jobj);
> +	}
> +
> +	addr = cxl_get_field_u64(event, record, "dpa");
> +	jobj = util_json_object_hex(addr, flags);
> +	if (jobj)
> +		json_object_object_add(jp, "dpa", jobj);
> +
> +	length = cxl_get_field_u32(event, record, "dpa_length");
> +	jobj = util_json_object_size(length, flags);
> +	if (jobj)
> +		json_object_object_add(jp, "length", jobj);
> +
> +	source = cxl_get_field_u8(event, record, "source");
> +	switch (source) {
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

Seems like you can have a static string table here? Then you can do something like:
if (source < CXL_POISON_SOURCE_MAX)
	jobj = json_object_new_string(cxl_poison_source[source]);
else
	jobj = json_object_new_string("Reserved");

DJ
> +	if (jobj)
> +		json_object_object_add(jp, "source", jobj);
> +
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
> +
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
> @@ -649,6 +908,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
> @@ -987,6 +1252,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
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
