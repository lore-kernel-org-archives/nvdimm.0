Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7FD31B131
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767995637; cv=none; b=S9T58zx8rPsTItGxHWIWg+ZgCHlnoKr3PhczDnQWY3LEtiVEwtv/Yg1QtRM3LpEwgWPknbd7DJweVWI+VGG5LVuOT6tOhn3iPHJBkueDu3vtodEMieS+wPvs66ao6DtA5ULzQNq43WsHm64X/SSk1P8HP7zdDqDpTAFsC4uMscs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767995637; c=relaxed/simple;
	bh=LN82vIXOr1cbyLtPN0+Z/SmbM7es1M8jcl4TFn+YXbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HDD2Cyso+iElKWCfnIH66Wc0KMeQ0aMlmXvFtCYGc2DyKKysbBM+W1Wev1z5ImDsMnJJa6zl5LuP60GsT7XVAthSXWKIxsAAU9Y6GOeK51ASFeUXWeHBduHwemI+PPOZeZI0aIvkYmpNCO/qASMOhPOzqGeAdEgBfUsKK6Yfp9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cuu7TO6o; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cuu7TO6o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767995634; x=1799531634;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LN82vIXOr1cbyLtPN0+Z/SmbM7es1M8jcl4TFn+YXbs=;
  b=Cuu7TO6ojnVffi6iDkNs8VM+DjoaKiYbiWAqMNhOqieTZi7iBWMVSq8L
   2RyMuYH2us8TtFl/6nwBski0QbFYsgVzkMR+5MoMDd+uvESJIhVYhaDHl
   i3q7DaVmVJUvfuhpB95qwaiHW9TnEWKCwnMDZPynxDyc1mgsAQPgEG+D2
   nxKUuRFrZbWj+eegRhXfycA/dMJWQUzN+csBThjQG78LQZFoCkd9eSqFQ
   t8+LFVcyZABK2wqoXyPFb+Q/CoCFjDjK9DeZyanojn5GoIe5gvTnleuld
   yfpb0DPkWhx6I6FHBJhE12RA9xwiBWGuGdf9kJrn6yegyid8+NwevH3j3
   w==;
X-CSE-ConnectionGUID: YD/JZHA0Tey9y1Vsoj2Drw==
X-CSE-MsgGUID: NCpMq8g5QwK7YlKf3Rs3Mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69537380"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="69537380"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 13:53:53 -0800
X-CSE-ConnectionGUID: Ouj0rFhNTN+5o6rMhlqlqA==
X-CSE-MsgGUID: EIMJmzOTSraMRHtxpEpjkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="202698340"
Received: from agladkov-desk.ger.corp.intel.com (HELO [10.125.110.37]) ([10.125.110.37])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 13:53:54 -0800
Message-ID: <1160bfba-eb39-4b77-b7ed-8409009f42e1@intel.com>
Date: Fri, 9 Jan 2026 14:53:52 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] cxl: Add inject-error command
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev,
 alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-5-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260109160720.1823-5-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 9:07 AM, Ben Cheatham wrote:
> Add the 'cxl-inject-error' command. This command will provide CXL
> protocol error injection for CXL VH root ports and CXL RCH downstream
> ports, as well as poison injection for CXL memory devices.
> 
> Add util_cxl_dport_filter() to find downstream ports by device name.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> ---
>  cxl/builtin.h      |   1 +
>  cxl/cxl.c          |   1 +
>  cxl/filter.c       |  26 +++++++
>  cxl/filter.h       |   2 +
>  cxl/inject-error.c | 188 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/meson.build    |   1 +
>  6 files changed, 219 insertions(+)
>  create mode 100644 cxl/inject-error.c
> 
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index c483f30..e82fcb5 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
>  #ifdef ENABLE_LIBTRACEFS
>  int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
>  #else
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index 1643667..a98bd6b 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
>  	{ "disable-region", .c_fn = cmd_disable_region },
>  	{ "destroy-region", .c_fn = cmd_destroy_region },
>  	{ "monitor", .c_fn = cmd_monitor },
> +	{ "inject-error", .c_fn = cmd_inject_error },
>  };
>  
>  int main(int argc, const char **argv)
> diff --git a/cxl/filter.c b/cxl/filter.c
> index b135c04..8c7dc6e 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -171,6 +171,32 @@ util_cxl_endpoint_filter_by_port(struct cxl_endpoint *endpoint,
>  	return NULL;
>  }
>  
> +struct cxl_dport *util_cxl_dport_filter(struct cxl_dport *dport,
> +					const char *__ident)
> +{
> +
> +	char *ident, *save;
> +	const char *arg;
> +
> +	if (!__ident)
> +		return dport;
> +
> +	ident = strdup(__ident);
> +	if (!ident)
> +		return NULL;
> +
> +	for (arg = strtok_r(ident, which_sep(__ident), &save); arg;
> +	     arg = strtok_r(NULL, which_sep(__ident), &save)) {
> +		if (strcmp(arg, cxl_dport_get_devname(dport)) == 0)
> +			break;
> +	}
> +
> +	free(ident);
> +	if (arg)
> +		return dport;
> +	return NULL;
> +}
> +
>  static struct cxl_decoder *
>  util_cxl_decoder_filter_by_port(struct cxl_decoder *decoder, const char *ident,
>  				enum cxl_port_filter_mode mode)
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 956a46e..70463c4 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -55,6 +55,8 @@ enum cxl_port_filter_mode {
>  
>  struct cxl_port *util_cxl_port_filter(struct cxl_port *port, const char *ident,
>  				      enum cxl_port_filter_mode mode);
> +struct cxl_dport *util_cxl_dport_filter(struct cxl_dport *dport,
> +					const char *__ident);
>  struct cxl_bus *util_cxl_bus_filter(struct cxl_bus *bus, const char *__ident);
>  struct cxl_endpoint *util_cxl_endpoint_filter(struct cxl_endpoint *endpoint,
>  					      const char *__ident);
> diff --git a/cxl/inject-error.c b/cxl/inject-error.c
> new file mode 100644
> index 0000000..0ca2e6b
> --- /dev/null
> +++ b/cxl/inject-error.c
> @@ -0,0 +1,188 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2025 AMD. All rights reserved. */
> +#include <util/parse-options.h>
> +#include <cxl/libcxl.h>
> +#include <cxl/filter.h>
> +#include <util/log.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <limits.h>
> +
> +static bool debug;
> +
> +static struct inject_params {
> +	const char *type;
> +	const char *address;
> +} inj_param;
> +
> +static const struct option inject_options[] = {
> +	OPT_STRING('t', "type", &inj_param.type, "Error type",
> +		   "Error type to inject into <device>"),
> +	OPT_STRING('a', "address", &inj_param.address, "Address for poison injection",
> +		   "Device physical address for poison injection in hex or decimal"),
> +#ifdef ENABLE_DEBUG
> +	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
> +#endif
> +	OPT_END(),
> +};
> +
> +static struct log_ctx iel;
> +
> +static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
> +						     const char *type)
> +{
> +	struct cxl_protocol_error *perror;
> +
> +	cxl_protocol_error_foreach(ctx, perror) {
> +		if (strcmp(type, cxl_protocol_error_get_str(perror)) == 0)
> +			return perror;
> +	}
> +
> +	log_err(&iel, "Invalid CXL protocol error type: %s\n", type);
> +	return NULL;
> +}
> +
> +static struct cxl_dport *find_cxl_dport(struct cxl_ctx *ctx, const char *devname)
> +{
> +	struct cxl_dport *dport;
> +	struct cxl_port *port;
> +	struct cxl_bus *bus;
> +
> +	cxl_bus_foreach(ctx, bus)
> +		cxl_port_foreach_all(cxl_bus_get_port(bus), port)
> +			cxl_dport_foreach(port, dport)
> +				if (util_cxl_dport_filter(dport, devname))
> +					return dport;
> +
> +	log_err(&iel, "Downstream port \"%s\" not found\n", devname);
> +	return NULL;
> +}
> +
> +static struct cxl_memdev *find_cxl_memdev(struct cxl_ctx *ctx,
> +					  const char *filter)
> +{
> +	struct cxl_memdev *memdev;
> +
> +	cxl_memdev_foreach(ctx, memdev) {
> +		if (util_cxl_memdev_filter(memdev, filter, NULL))
> +			return memdev;
> +	}
> +
> +	log_err(&iel, "Memdev \"%s\" not found\n", filter);
> +	return NULL;
> +}
> +
> +static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
> +			    struct cxl_protocol_error *perror)
> +{
> +	struct cxl_dport *dport;
> +	int rc;
> +
> +	if (!devname) {
> +		log_err(&iel, "No downstream port specified for injection\n");
> +		return -EINVAL;
> +	}
> +
> +	dport = find_cxl_dport(ctx, devname);
> +	if (!dport)
> +		return -ENODEV;
> +
> +	rc = cxl_dport_protocol_error_inject(dport,
> +					     cxl_protocol_error_get_num(perror));
> +	if (rc)
> +		return rc;
> +
> +	log_info(&iel, "injected %s protocol error.\n",
> +		 cxl_protocol_error_get_str(perror));
> +	return 0;
> +}
> +
> +static int poison_action(struct cxl_ctx *ctx, const char *filter,
> +			 const char *addr_str)
> +{
> +	struct cxl_memdev *memdev;
> +	unsigned long long addr;
> +	int rc;
> +
> +	memdev = find_cxl_memdev(ctx, filter);
> +	if (!memdev)
> +		return -ENODEV;
> +
> +	if (!cxl_memdev_has_poison_injection(memdev)) {
> +		log_err(&iel, "%s does not support error injection\n",
> +			cxl_memdev_get_devname(memdev));
> +		return -EINVAL;
> +	}
> +
> +	if (!addr_str) {
> +		log_err(&iel, "no address provided\n");
> +		return -EINVAL;
> +	}
> +
> +	errno = 0;

Why does errno needs to be set here?

> +	addr = strtoull(addr_str, NULL, 0);
> +	if (addr == ULLONG_MAX && errno == ERANGE) {
> +		log_err(&iel, "invalid address %s", addr_str);
> +		return -EINVAL;
> +	}
> +
> +	rc = cxl_memdev_inject_poison(memdev, addr);
> +	if (rc)
> +		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
> +			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));

We don't error if poison fails to inject?

DJ

> +	else
> +		log_info(&iel, "poison injected at %s:%s\n",
> +			 cxl_memdev_get_devname(memdev), addr_str);
> +
> +	return rc;
> +}
> +
> +static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
> +			 const struct option *options, const char *usage)
> +{
> +	struct cxl_protocol_error *perr;
> +	const char * const u[] = {
> +		usage,
> +		NULL
> +	};
> +	int rc = -EINVAL;
> +
> +	log_init(&iel, "cxl inject-error", "CXL_INJECT_LOG");
> +	argc = parse_options(argc, argv, options, u, 0);
> +
> +	if (debug) {
> +		cxl_set_log_priority(ctx, LOG_DEBUG);
> +		iel.log_priority = LOG_DEBUG;
> +	} else {
> +		iel.log_priority = LOG_INFO;
> +	}
> +
> +	if (argc != 1 || inj_param.type == NULL) {
> +		usage_with_options(u, options);
> +		return rc;
> +	}
> +
> +	if (strcmp(inj_param.type, "poison") == 0) {
> +		rc = poison_action(ctx, argv[0], inj_param.address);
> +		return rc;
> +	}
> +
> +	perr = find_cxl_proto_err(ctx, inj_param.type);
> +	if (perr) {
> +		rc = inject_proto_err(ctx, argv[0], perr);
> +		if (rc)
> +			log_err(&iel, "Failed to inject error: %d\n", rc);
> +	}
> +
> +	return rc;
> +}
> +
> +int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +	int rc = inject_action(argc, argv, ctx, inject_options,
> +			       "inject-error <device> -t <type> [<options>]");
> +
> +	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
> +}
> diff --git a/cxl/meson.build b/cxl/meson.build
> index b9924ae..92031b5 100644
> --- a/cxl/meson.build
> +++ b/cxl/meson.build
> @@ -7,6 +7,7 @@ cxl_src = [
>    'memdev.c',
>    'json.c',
>    'filter.c',
> +  'inject-error.c',
>    '../daxctl/json.c',
>    '../daxctl/filter.c',
>  ]

