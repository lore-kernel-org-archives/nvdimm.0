Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C6485637
	for <nvdimm@lists.linux.dev>; Wed, 20 Mar 2024 20:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710966255; cv=none; b=ci7VjfuPBzMpWSoIxGrSZo4FLAqzwLFU5ydngPHgoVH8jT56L7fChVhoIxRjoWLZte+Rsub350Y7F7zUhSTcztSj912IqlGaiECJpQRNLgRASxkNwwgcfPh6dDi7Yt5JqvU+Ff+h9QQK7qWhi3+vo2iCAY8jDWve7PWEukrjEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710966255; c=relaxed/simple;
	bh=zPdTU4ncY8coMmcItNRH/mLOV310q68LH95EaX7JoO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZe8s9Yb38tg3R7Bp1d1XQKBxFfjjOv7RTNE11IZ7IpTNFlpXSMhbaSm6P2NW52z+/HujRKqkhRLqQfD65YkJvloEGLelOdRodgx7SRrEP/Y5b2Xtn01frebym3fFMKVF8PVjWV0wIUpVfmioBCKC5+HVlYj2s6MPhV5pcZ+uk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BrgyctEI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BrgyctEI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710966253; x=1742502253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zPdTU4ncY8coMmcItNRH/mLOV310q68LH95EaX7JoO4=;
  b=BrgyctEIIHC+sqpKsSOYA12f7CY+CTcFQqmERgtHmFGMrh2FR1kRjy03
   uF1sVg0vcdoqCuIvUB1XW+4qqq4jstifSaPfzX6AeoBIiHi7TfLtnmYrT
   EWsuirP3ddDK/5jozte3ZRJ1MmvwkNPt9GkCo6wRzzRt/YP6yy+SZl/3G
   JQNHfG7mvgwM93agwPObwkMie1gt77Eq2ActsEWi1kSEg/5tYMGsw+iBH
   lVgQbxJRGSyxXfZ5MAZyjGWerQMx4pkipaYlCJEXuqfjzERx9IFNrjUWJ
   2wGnEkPkVwKICE3zqwT2wnBhLNL4rGRacwT2/1iAWlBcaElkOYN+oMhwd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="16459824"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="16459824"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:24:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="18745799"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.72.188])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:24:12 -0700
Date: Wed, 20 Mar 2024 13:24:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v11 5/7] cxl/list: collect and parse media_error
 records
Message-ID: <ZftF6uhcBTZe/Qa5@aschofie-mobl2>
References: <cover.1710386468.git.alison.schofield@intel.com>
 <20c83daf14ac45542e9b6ed4cddfaf659e0ce7b0.1710386468.git.alison.schofield@intel.com>
 <ac942888-d774-4e0a-8734-7321a558fb07@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac942888-d774-4e0a-8734-7321a558fb07@intel.com>

On Fri, Mar 15, 2024 at 09:16:27AM -0700, Dave Jiang wrote:
> 
> 
> On 3/13/24 9:05 PM, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Media_error records are logged as events in the kernel tracing
> > subsystem. To prepare the media_error records for cxl list, enable
> > tracing, trigger the poison list read, and parse the generated
> > cxl_poison events into a json representation.
> > 
> > Use the event_trace private parsing option to customize the json
> > representation based on cxl-list calling options and event field
> > settings.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Minor nit below.

Nit removed. Thanks!

> > ---
> >  cxl/json.c | 194 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 194 insertions(+)
> > 
> > diff --git a/cxl/json.c b/cxl/json.c
> > index fbe41c78e82a..974e98f13cec 100644
> > --- a/cxl/json.c
> > +++ b/cxl/json.c
> > @@ -1,16 +1,20 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  // Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
> >  #include <limits.h>
> > +#include <errno.h>
> >  #include <util/json.h>
> > +#include <util/bitmap.h>
> >  #include <uuid/uuid.h>
> >  #include <cxl/libcxl.h>
> >  #include <json-c/json.h>
> >  #include <json-c/printbuf.h>
> >  #include <ccan/short_types/short_types.h>
> > +#include <tracefs/tracefs.h>
> >  
> >  #include "filter.h"
> >  #include "json.h"
> >  #include "../daxctl/json.h"
> > +#include "event_trace.h"
> >  
> >  #define CXL_FW_VERSION_STR_LEN	16
> >  #define CXL_FW_MAX_SLOTS	4
> > @@ -571,6 +575,184 @@ err_jobj:
> >  	return NULL;
> >  }
> >  
> > +/* CXL Spec 3.1 Table 8-140 Media Error Record */
> > +#define CXL_POISON_SOURCE_MAX 7
> > +static const char *poison_source[] = { "Unknown",  "External", "Internal",
> > +				       "Injected", "Reserved", "Reserved",
> > +				       "Reserved", "Vendor" };
> > +
> > +/* CXL Spec 3.1 Table 8-139 Get Poison List Output Payload */
> > +#define CXL_POISON_FLAG_MORE BIT(0)
> > +#define CXL_POISON_FLAG_OVERFLOW BIT(1)
> > +#define CXL_POISON_FLAG_SCANNING BIT(2)
> > +
> > +static int poison_event_to_json(struct tep_event *event,
> > +				struct tep_record *record,
> > +				struct event_ctx *e_ctx)
> > +{
> > +	struct poison_ctx *p_ctx = e_ctx->poison_ctx;
> > +	struct json_object *jp, *jobj, *jpoison = p_ctx->jpoison;
> > +	struct cxl_memdev *memdev = p_ctx->memdev;
> > +	struct cxl_region *region = p_ctx->region;
> > +	unsigned long flags = p_ctx->flags;
> > +	const char *region_name = NULL;
> > +	char flag_str[32] = { '\0' };
> > +	bool overflow = false;
> > +	u8 source, pflags;
> > +	u64 offset, ts;
> > +	u32 length;
> > +	char *str;
> > +	int len;
> > +
> > +	jp = json_object_new_object();
> > +	if (!jp)
> > +		return -ENOMEM;
> > +
> > +	/* Skip records not in this region when listing by region */
> > +	if (region)
> > +		region_name = cxl_region_get_devname(region);
> > +	if (region_name)
> > +		str = tep_get_field_raw(NULL, event, "region", record, &len, 0);
> > +	if ((region_name) && (strcmp(region_name, str) != 0)) {
> > +		json_object_put(jp);
> > +		return 0;
> > +	}
> > +	/* Include offset,length by region (hpa) or by memdev (dpa) */
> > +	if (region) {
> > +		offset = cxl_get_field_u64(event, record, "hpa");
> > +		if (offset != ULLONG_MAX) {
> > +			offset = offset - cxl_region_get_resource(region);
> > +			jobj = util_json_object_hex(offset, flags);
> > +			if (jobj)
> > +				json_object_object_add(jp, "offset", jobj);
> > +		}
> > +	} else if (memdev) {
> > +		offset = cxl_get_field_u64(event, record, "dpa");
> > +		if (offset != ULLONG_MAX) {
> > +			jobj = util_json_object_hex(offset, flags);
> > +			if (jobj)
> > +				json_object_object_add(jp, "offset", jobj);
> > +		}
> > +	}
> > +	length = cxl_get_field_u32(event, record, "dpa_length");
> > +	jobj = util_json_object_size(length, flags);
> > +	if (jobj)
> > +		json_object_object_add(jp, "length", jobj);
> > +
> > +	/* Always include the poison source */
> > +	source = cxl_get_field_u8(event, record, "source");
> > +	if (source <= CXL_POISON_SOURCE_MAX)
> > +		jobj = json_object_new_string(poison_source[source]);
> > +	else
> > +		jobj = json_object_new_string("Reserved");
> > +	if (jobj)
> > +		json_object_object_add(jp, "source", jobj);
> > +
> > +	/* Include flags and overflow time if present */
> > +	pflags = cxl_get_field_u8(event, record, "flags");
> > +	if (pflags && pflags < UCHAR_MAX) {
> > +		if (pflags & CXL_POISON_FLAG_MORE)
> > +			strcat(flag_str, "More,");
> > +		if (pflags & CXL_POISON_FLAG_SCANNING)
> > +			strcat(flag_str, "Scanning,");
> > +		if (pflags & CXL_POISON_FLAG_OVERFLOW) {
> > +			strcat(flag_str, "Overflow,");
> > +			overflow = true;
> > +		}
> > +		jobj = json_object_new_string(flag_str);
> > +		if (jobj)
> > +			json_object_object_add(jp, "flags", jobj);
> > +	}
> > +	if (overflow) {
> > +		ts = cxl_get_field_u64(event, record, "overflow_ts");
> > +		jobj = util_json_object_hex(ts, flags);
> > +		if (jobj)
> > +			json_object_object_add(jp, "overflow_t", jobj);
> > +	}
> > +	json_object_array_add(jpoison, jp);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct json_object *
> > +util_cxl_poison_events_to_json(struct tracefs_instance *inst,
> > +			       struct poison_ctx *p_ctx)
> > +{
> > +	struct event_ctx ectx = {
> > +		.event_name = "cxl_poison",
> > +		.event_pid = getpid(),
> > +		.system = "cxl",
> > +		.poison_ctx = p_ctx,
> > +		.parse_event = poison_event_to_json,
> > +	};
> > +	int rc = 0;
> 
> No need to init rc here. 
> 
> DJ
> 
> > +
> > +	p_ctx->jpoison = json_object_new_array();
> > +	if (!p_ctx->jpoison)
> > +		return NULL;
> > +
> > +	rc = cxl_parse_events(inst, &ectx);
> > +	if (rc < 0) {
> > +		fprintf(stderr, "Failed to parse events: %d\n", rc);
> > +		goto put_jobj;
> > +	}
> > +	if (json_object_array_length(p_ctx->jpoison) == 0)
> > +		goto put_jobj;
> > +
> > +	return p_ctx->jpoison;
> > +
> > +put_jobj:
> > +	json_object_put(p_ctx->jpoison);
> > +	return NULL;
> > +}
> > +
> > +static struct json_object *
> > +util_cxl_poison_list_to_json(struct cxl_region *region,
> > +			     struct cxl_memdev *memdev,
> > +			     unsigned long flags)
> > +{
> > +	struct json_object *jpoison = NULL;
> > +	struct poison_ctx p_ctx;
> > +	struct tracefs_instance *inst;
> > +	int rc;
> > +
> > +	inst = tracefs_instance_create("cxl list");
> > +	if (!inst) {
> > +		fprintf(stderr, "tracefs_instance_create() failed\n");
> > +		return NULL;
> > +	}
> > +
> > +	rc = cxl_event_tracing_enable(inst, "cxl", "cxl_poison");
> > +	if (rc < 0) {
> > +		fprintf(stderr, "Failed to enable trace: %d\n", rc);
> > +		goto err_free;
> > +	}
> > +
> > +	if (region)
> > +		rc = cxl_region_trigger_poison_list(region);
> > +	else
> > +		rc = cxl_memdev_trigger_poison_list(memdev);
> > +	if (rc)
> > +		goto err_free;
> > +
> > +	rc = cxl_event_tracing_disable(inst);
> > +	if (rc < 0) {
> > +		fprintf(stderr, "Failed to disable trace: %d\n", rc);
> > +		goto err_free;
> > +	}
> > +
> > +	p_ctx = (struct poison_ctx) {
> > +		.region = region,
> > +		.memdev = memdev,
> > +		.flags = flags,
> > +	};
> > +	jpoison = util_cxl_poison_events_to_json(inst, &p_ctx);
> > +
> > +err_free:
> > +	tracefs_instance_free(inst);
> > +	return jpoison;
> > +}
> > +
> >  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> >  		unsigned long flags)
> >  {
> > @@ -664,6 +846,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
> >  			json_object_object_add(jdev, "firmware", jobj);
> >  	}
> >  
> > +	if (flags & UTIL_JSON_MEDIA_ERRORS) {
> > +		jobj = util_cxl_poison_list_to_json(NULL, memdev, flags);
> > +		if (jobj)
> > +			json_object_object_add(jdev, "media_errors", jobj);
> > +	}
> > +
> >  	json_object_set_userdata(jdev, memdev, NULL);
> >  	return jdev;
> >  }
> > @@ -1012,6 +1200,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> >  			json_object_object_add(jregion, "state", jobj);
> >  	}
> >  
> > +	if (flags & UTIL_JSON_MEDIA_ERRORS) {
> > +		jobj = util_cxl_poison_list_to_json(region, NULL, flags);
> > +		if (jobj)
> > +			json_object_object_add(jregion, "media_errors", jobj);
> > +	}
> > +
> >  	util_cxl_mappings_append_json(jregion, region, flags);
> >  
> >  	if (flags & UTIL_JSON_DAX) {
