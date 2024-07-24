Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B95C13A268
	for <nvdimm@lists.linux.dev>; Wed, 24 Jul 2024 20:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721854243; cv=none; b=inwon3ElDLijWdyQ3quWxVrG/r5CY1SzMHZsHIEmeWuzRS56tO/brfGxozg5O9VNXn16QnI46dG0BZm64VgDYFvo9jkcU3Caf3yKgtCmgVsMpRoZreB5BQYM6DNE2EYNRGnilvVb79Vp2DGx9Jqfcz4oX5cWMTORJdAmVATUxmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721854243; c=relaxed/simple;
	bh=gTlVP5kxfwsy5bDuSCzkOtNXwSnU7XBdO9ythG+0WaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y+6PTFAzo3UyYtfMrjSCwuKd3ISwd4O80Lj+cooxwbH1VHdliUO76Hxi5DDKz95udQKIcs5HoOsCsrC+3Q610SEdM/SAsLWGnEG+xLmkJlK8rD+fR/9FZ2J2MhiDjF0rRZ2VnULscXOlXnycLvQIbktNseeyy3iHIOO0JRakiUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=auu3hJCI; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="auu3hJCI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721854242; x=1753390242;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=gTlVP5kxfwsy5bDuSCzkOtNXwSnU7XBdO9ythG+0WaU=;
  b=auu3hJCI5bWxCNDhVPIErpGK2HyO7MynK3+xnn4BAELuUV2GStrHOyjT
   cVd1D4mqfFN4kRw2/pSYvWWeMkzJdVME0obYi3s5PxaANHQGm6xZTFYG/
   6s6FZahbOvjaPxObo+fbmSL2/nDwChcYAgCqlgm8+YAm1MH3DLYoFe6+V
   Dn8kyrtepZiy0SSaKAOQZkMHZPgUpZV8pYKcSDL4Y89+7UQ8EEetfwymo
   gwbc03KjSsUTsiVUCIOStvQJBnYZwpjbwC70a2oK+BoTfLEi+L3w6y+QQ
   YL7cMZ/KP1dLv3lq7R3iGJI9qHZ/9cRwg1lnlmXgyavzt57AT2DSYJjgj
   g==;
X-CSE-ConnectionGUID: Sl36tdxjRQOamG36gAMg8g==
X-CSE-MsgGUID: /U13wq7CTI6hggInrRQ8Mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="19521408"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="19521408"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 13:50:41 -0700
X-CSE-ConnectionGUID: wWVUhU1YQeavsCXN557VDg==
X-CSE-MsgGUID: 5ubJDRfeSwSBecAhri7wZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="83710383"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.110.208]) ([10.125.110.208])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 13:50:41 -0700
Message-ID: <4b9d1b30-e23b-41eb-a6b5-16a97d0f08c4@intel.com>
Date: Wed, 24 Jul 2024 13:50:39 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v13 1/8] util/trace: move trace helpers from
 ndctl/cxl/ to ndctl/util/
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <cover.1720241079.git.alison.schofield@intel.com>
 <d1d60f8f475684e398fd0c415358c48105b42b45.1720241079.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <d1d60f8f475684e398fd0c415358c48105b42b45.1720241079.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/5/24 11:24 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A set of helpers used to parse kernel trace events were introduced
> in ndctl/cxl/ in support of the CXL monitor command. The work these
> helpers perform may be useful beyond CXL.
> 
> Move them to the ndctl/util/ where other generic helpers reside.
> Replace cxl-ish naming with generic names and update the single
> user, cxl/monitor.c, to match.
> 
> This move is in preparation for extending the helpers in support
> of cxl_poison trace events.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/meson.build             |  2 +-
>  cxl/monitor.c               | 11 +++++------
>  {cxl => util}/event_trace.c | 21 ++++++++++-----------
>  {cxl => util}/event_trace.h | 12 ++++++------
>  4 files changed, 22 insertions(+), 24 deletions(-)
>  rename {cxl => util}/event_trace.c (88%)
>  rename {cxl => util}/event_trace.h (61%)
> 
> diff --git a/cxl/meson.build b/cxl/meson.build
> index 61b4d8762b42..e4d1683ce8c6 100644
> --- a/cxl/meson.build
> +++ b/cxl/meson.build
> @@ -27,7 +27,7 @@ deps = [
>  
>  if get_option('libtracefs').enabled()
>    cxl_src += [
> -    'event_trace.c',
> +    '../util/event_trace.c',
>      'monitor.c',
>    ]
>    deps += [
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index a85452a4dc82..2066f984668d 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -28,8 +28,7 @@
>  #define ENABLE_DEBUG
>  #endif
>  #include <util/log.h>
> -
> -#include "event_trace.h"
> +#include <util/event_trace.h>
>  
>  static const char *cxl_system = "cxl";
>  const char *default_log = "/var/log/cxl-monitor.log";
> @@ -87,9 +86,9 @@ static int monitor_event(struct cxl_ctx *ctx)
>  		goto epoll_ctl_err;
>  	}
>  
> -	rc = cxl_event_tracing_enable(inst, cxl_system, NULL);
> +	rc = trace_event_enable(inst, cxl_system, NULL);
>  	if (rc < 0) {
> -		err(&monitor, "cxl_trace_event_enable() failed: %d\n", rc);
> +		err(&monitor, "trace_event_enable() failed: %d\n", rc);
>  		goto event_en_err;
>  	}
>  
> @@ -112,7 +111,7 @@ static int monitor_event(struct cxl_ctx *ctx)
>  		}
>  
>  		list_head_init(&ectx.jlist_head);
> -		rc = cxl_parse_events(inst, &ectx);
> +		rc = trace_event_parse(inst, &ectx);
>  		if (rc < 0)
>  			goto parse_err;
>  
> @@ -129,7 +128,7 @@ static int monitor_event(struct cxl_ctx *ctx)
>  	}
>  
>  parse_err:
> -	if (cxl_event_tracing_disable(inst) < 0)
> +	if (trace_event_disable(inst) < 0)
>  		err(&monitor, "failed to disable tracing\n");
>  event_en_err:
>  epoll_ctl_err:
> diff --git a/cxl/event_trace.c b/util/event_trace.c
> similarity index 88%
> rename from cxl/event_trace.c
> rename to util/event_trace.c
> index 1b5aa09de8b2..16013412bc06 100644
> --- a/cxl/event_trace.c
> +++ b/util/event_trace.c
> @@ -59,8 +59,8 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
>  	return json_object_new_int64(val);
>  }
>  
> -static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
> -			     struct list_head *jlist_head)
> +static int event_to_json(struct tep_event *event, struct tep_record *record,
> +			 struct list_head *jlist_head)
>  {
>  	struct json_object *jevent, *jobj, *jarray;
>  	struct tep_format_field **fields;
> @@ -200,8 +200,8 @@ err_jnode:
>  	return rc;
>  }
>  
> -static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
> -			   int cpu, void *ctx)
> +static int event_parse(struct tep_event *event, struct tep_record *record,
> +		       int cpu, void *ctx)
>  {
>  	struct event_ctx *event_ctx = (struct event_ctx *)ctx;
>  
> @@ -218,10 +218,10 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
>  		return event_ctx->parse_event(event, record,
>  					      &event_ctx->jlist_head);
>  
> -	return cxl_event_to_json(event, record, &event_ctx->jlist_head);
> +	return event_to_json(event, record, &event_ctx->jlist_head);
>  }
>  
> -int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
> +int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx)
>  {
>  	struct tep_handle *tep;
>  	int rc;
> @@ -230,14 +230,13 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
>  	if (!tep)
>  		return -ENOMEM;
>  
> -	rc = tracefs_iterate_raw_events(tep, inst, NULL, 0, cxl_event_parse,
> -					ectx);
> +	rc = tracefs_iterate_raw_events(tep, inst, NULL, 0, event_parse, ectx);
>  	tep_free(tep);
>  	return rc;
>  }
>  
> -int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
> -		const char *event)
> +int trace_event_enable(struct tracefs_instance *inst, const char *system,
> +		       const char *event)
>  {
>  	int rc;
>  
> @@ -252,7 +251,7 @@ int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
>  	return 0;
>  }
>  
> -int cxl_event_tracing_disable(struct tracefs_instance *inst)
> +int trace_event_disable(struct tracefs_instance *inst)
>  {
>  	return tracefs_trace_off(inst);
>  }
> diff --git a/cxl/event_trace.h b/util/event_trace.h
> similarity index 61%
> rename from cxl/event_trace.h
> rename to util/event_trace.h
> index ec6267202c8b..37c39aded871 100644
> --- a/cxl/event_trace.h
> +++ b/util/event_trace.h
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /* Copyright (C) 2022 Intel Corporation. All rights reserved. */
> -#ifndef __CXL_EVENT_TRACE_H__
> -#define __CXL_EVENT_TRACE_H__
> +#ifndef __UTIL_EVENT_TRACE_H__
> +#define __UTIL_EVENT_TRACE_H__
>  
>  #include <json-c/json.h>
>  #include <ccan/list/list.h>
> @@ -19,9 +19,9 @@ struct event_ctx {
>  			   struct list_head *jlist_head); /* optional */
>  };
>  
> -int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
> -int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
> -		const char *event);
> -int cxl_event_tracing_disable(struct tracefs_instance *inst);
> +int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx);
> +int trace_event_enable(struct tracefs_instance *inst, const char *system,
> +		       const char *event);
> +int trace_event_disable(struct tracefs_instance *inst);
>  
>  #endif
