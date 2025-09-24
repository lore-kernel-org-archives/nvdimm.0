Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6585B303CA4
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 15:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758728449; cv=none; b=UC39pjlno49AlKxjTG0a6ZR1kzxwoM2huTtUUckuDx5TndBSNpS7EZPT14w57TYS2PKOfL/UXDwrlByKdYMyGF4VJo56T+ijUL4KvM8KE/gGa4R1Sz0lL78cJqZ7DGiuF1T5m8J8OV1ZC0F6FrIB/s62+8r5J/MULyun10afHI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758728449; c=relaxed/simple;
	bh=BeE25GckMF3etOBsxhayMsUckPAlry33zyH8/MNQvmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q/ebl/pI8Uxs46hkOa7ytmaVv7FZbRF2F7nmCcE9Eq9We8a5xooL+U++r1G/oLVUVe9LrDSNap7A3zOVqc/kGhZ56Ai9wRPHbEl/s+VpmwWTnPhr+GDpvbA3DBgVoYHMtuiVPFLUzhlca8/aCeUvfb22e7LjqH404yER8tLdSNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaVK4DZq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaVK4DZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758728448; x=1790264448;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BeE25GckMF3etOBsxhayMsUckPAlry33zyH8/MNQvmY=;
  b=EaVK4DZqsesGVorfw2WL8MwIY0iV853YH5meswzpZe9yaGlDz+/ru0bf
   IrcFYsYtxxDscNUl6316GIpbX/ScSFgJk6NNdv7uCT57DsD9FaxLYprIY
   Of6qJyfw5csnY12EV4VEPWe67PLXH/3+laiPiCUhbPtQCys25Op7gERzQ
   qH5T9GJ1cQL9E0SUSlp88paCQ2Tx9AUcQJJNjpSWbcVxIQWoe2HHcNx70
   OB18B6ONPO7KiqG/nVrrFtl0o3kFVwX8/vsNq7j3/EYyRhKLplxUCbFp0
   Y+PITYdeN4x/Z0od3xqw2AA728Cy5rk3wPmUy8E/Ae+NCl/PCnqKiBx8c
   Q==;
X-CSE-ConnectionGUID: /JA+uMTKRMS1+va3CFsppg==
X-CSE-MsgGUID: zSi/HvwjSpqf8XPG9sAHkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="83632533"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="83632533"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 08:40:47 -0700
X-CSE-ConnectionGUID: 9ESTVYF/SSCiUkkSkQEeDw==
X-CSE-MsgGUID: znyRkVVhTHScBTNysxMh5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="176183371"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.218]) ([10.125.108.218])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 08:40:47 -0700
Message-ID: <3e84c6a3-f30c-4eda-adb3-97fe1c42744c@intel.com>
Date: Wed, 24 Sep 2025 08:40:45 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2] cxl/list: remove libtracefs build dependency for
 --media-errors
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: Andreas Hasenack <andreas.hasenack@canonical.com>
References: <20250924045302.90074-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250924045302.90074-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/23/25 9:52 PM, Alison Schofield wrote:
> When the --media-errors option was added to cxl list it inadvertently
> changed the optional libtracefs requirement into a mandatory one.
> Ndctl versions 80,81,82 no longer build without libtracefs.
> 
> Remove that dependency.
> 
> When libtracefs is disabled the user will see a 'Notice' level
> message, like this:
> 	$ cxl list -r region0 --media-errors --targets
> 	cxl list: cmd_list: --media-errors support disabled at build time
> 
> ...followed by the region listing including the output for any other
> valid command line options, like --targets in the example above.
> 
> When libtracefs is disabled the cxl-poison.sh unit test is omitted.
> 
> The man page gets a note:
> 	The media-error option is only available with -Dlibtracefs=enabled.
> 
> Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
> Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
> Closes: https://github.com/pmem/ndctl/issues/289
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> Changes in v2:
> - Notify and continue when --media-error info is unavailable (Dan)
> 
> 
>  Documentation/cxl/cxl-list.txt |  2 ++
>  config.h.meson                 |  2 +-
>  cxl/json.c                     | 15 ++++++++++++++-
>  cxl/list.c                     |  6 ++++++
>  test/meson.build               |  9 +++++++--
>  5 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 9a9911e7dd9b..0595638ee054 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -425,6 +425,8 @@ OPTIONS
>  	"source:" is one of: External, Internal, Injected, Vendor Specific,
>  	or Unknown, as defined in CXL Specification v3.1 Table 8-140.
>  
> +The media-errors option is only available with '-Dlibtracefs=enabled'.
> +
>  ----
>  # cxl list -m mem9 --media-errors -u
>  {
> diff --git a/config.h.meson b/config.h.meson
> index f75db3e6360f..e8539f8d04df 100644
> --- a/config.h.meson
> +++ b/config.h.meson
> @@ -19,7 +19,7 @@
>  /* ndctl test support */
>  #mesondefine ENABLE_TEST
>  
> -/* cxl monitor support */
> +/* cxl monitor and cxl list --media-errors support */
>  #mesondefine ENABLE_LIBTRACEFS
>  
>  /* Define to 1 if big-endian-arch */
> diff --git a/cxl/json.c b/cxl/json.c
> index e65bd803b706..a75928bf43ed 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -9,12 +9,15 @@
>  #include <json-c/json.h>
>  #include <json-c/printbuf.h>
>  #include <ccan/short_types/short_types.h>
> +
> +#ifdef ENABLE_LIBTRACEFS
>  #include <tracefs.h>
> +#include "../util/event_trace.h"
> +#endif
>  
>  #include "filter.h"
>  #include "json.h"
>  #include "../daxctl/json.h"
> -#include "../util/event_trace.h"
>  
>  #define CXL_FW_VERSION_STR_LEN	16
>  #define CXL_FW_MAX_SLOTS	4
> @@ -575,6 +578,7 @@ err_jobj:
>  	return NULL;
>  }
>  
> +#ifdef ENABLE_LIBTRACEFS
>  /* CXL Spec 3.1 Table 8-140 Media Error Record */
>  #define CXL_POISON_SOURCE_MAX 7
>  static const char *const poison_source[] = { "Unknown", "External", "Internal",
> @@ -753,6 +757,15 @@ err_free:
>  	tracefs_instance_free(inst);
>  	return jpoison;
>  }
> +#else
> +static struct json_object *
> +util_cxl_poison_list_to_json(struct cxl_region *region,
> +			     struct cxl_memdev *memdev,
> +			     unsigned long flags)
> +{
> +	return NULL;
> +}
> +#endif
>  
>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		unsigned long flags)
> diff --git a/cxl/list.c b/cxl/list.c
> index 0b25d78248d5..48bd1ebc3c0e 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -146,6 +146,12 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.ctx.log_priority = LOG_DEBUG;
>  	}
>  
> +#ifndef ENABLE_LIBTRACEFS
> +	if (param.media_errors) {
> +		notice(&param, "--media-errors support disabled at build time\n");
> +		param.media_errors = false;
> +	}
> +#endif
>  	if (cxl_filter_has(param.port_filter, "root") && param.ports)
>  		param.buses = true;
>  
> diff --git a/test/meson.build b/test/meson.build
> index 775542c1b787..615376ea635a 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -167,7 +167,6 @@ cxl_events = find_program('cxl-events.sh')
>  cxl_sanitize = find_program('cxl-sanitize.sh')
>  cxl_destroy_region = find_program('cxl-destroy-region.sh')
>  cxl_qos_class = find_program('cxl-qos-class.sh')
> -cxl_poison = find_program('cxl-poison.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -200,7 +199,6 @@ tests = [
>    [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
>    [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
>    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
> -  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()
> @@ -253,6 +251,13 @@ if get_option('fwctl').enabled()
>    ]
>  endif
>  
> +if get_option('libtracefs').enabled()
> +  cxl_poison = find_program('cxl-poison.sh')
> +  tests += [
> +    [ 'cxl-poison.sh', cxl_poison, 'cxl' ],
> +  ]
> +endif
> +
>  test_env = [
>      'LC_ALL=C',
>      'NDCTL=@0@'.format(ndctl_tool.full_path()),

