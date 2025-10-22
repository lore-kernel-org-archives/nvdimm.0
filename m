Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D56278E41
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152786; cv=none; b=ZFpUvYyYDEZmlYxBixwLQZcVn4CoGdEUVRIQHKIPZJpXLTO1Yk7P2IA2WDCUDBv0RtiqGyZw64xjavXJWTo/l/VUY0QxMHdFMSgbs11WTf3/J5UyWtdWVKvVQme/V1mXEJt6pPtgR55SfkyCzNdQ2VRmFIj67mEfbX6qlkVCAuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152786; c=relaxed/simple;
	bh=6JSoq6bxbTv+6CetE5GjSFVUs3mYo557bkdnOKpdFNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U9K5EBxrwWOtBc51T0+nGJ9lMiEzd53YjKlGP3qOzttUvTvMH8BDveKjZ4/qLjj0ox8mvvY/bQkn9CalfJPFbRHHGwbaR7QY5t+STE3M6USA9TR9W0QMgc6kUqfxq6VgJ1vhLBJyWi+C3ZVdo4Sk6PZcCt19ix2YZ07GIaGRk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgVzhF53; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgVzhF53"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761152784; x=1792688784;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6JSoq6bxbTv+6CetE5GjSFVUs3mYo557bkdnOKpdFNA=;
  b=PgVzhF53zDKjoZ5/d5HedY4G0gBXi+3+SPXBiOUrypFKkHdC73pt7PlD
   SyUI4S00axTN6wgMXGNAouQ45xvUBlvUvpCh9YG60ocaOyWtgxr2gRLWD
   ahW4y5bSE9U+8euEC7nnHf1QX1/MDaOaxjZ4EWkAEUGEA2+oIV9JBG3Gt
   fTupak8znO3jBTqtFfqQcAjfZMUKT4q+8nBwm5hnZiJGBfJspISz723Pv
   FbvrmbXmPVPq3QqCmV9SOL7t4885lRGa6Etcjh4oqSX9IfZL/MbRv9bgd
   zLUtrPbOfoAzPqGo3zrEMe1EddMjspaT1tCqmBEHKzcbL2xvF3E7olfT6
   Q==;
X-CSE-ConnectionGUID: a5mdlznNTGefkDJjJhadTA==
X-CSE-MsgGUID: kSrH6jIeQLWmNztIaOTDDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63211500"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63211500"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 10:06:24 -0700
X-CSE-ConnectionGUID: LeDrX2CYQViACVITFieabA==
X-CSE-MsgGUID: 9793ziO3TGaBrkWGVCT57g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="183514596"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.108.213]) ([10.125.108.213])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 10:06:25 -0700
Message-ID: <5d3337cd-94c4-4d5e-beb6-219058af11a5@intel.com>
Date: Wed, 22 Oct 2025 10:06:23 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 4/7] cxl: Add inject-error command
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-5-Benjamin.Cheatham@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251021183124.2311-5-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/25 11:31 AM, Ben Cheatham wrote:
> Add the 'cxl-inject-error' command. This command will provide CXL
> protocol error injection for CXL VH root ports and CXL RCH downstream
> ports, as well as poison injection for CXL memory devices.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> ---
>  cxl/builtin.h      |   1 +
>  cxl/cxl.c          |   1 +
>  cxl/inject-error.c | 195 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/meson.build    |   1 +
>  4 files changed, 198 insertions(+)
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
> diff --git a/cxl/inject-error.c b/cxl/inject-error.c
> new file mode 100644
> index 0000000..c48ea69
> --- /dev/null
> +++ b/cxl/inject-error.c
> @@ -0,0 +1,195 @@
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
> +#define EINJ_TYPES_BUF_SIZE 512
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
> +	struct cxl_port *port, *top;
> +	struct cxl_dport *dport;
> +	struct cxl_bus *bus;
> +
> +	cxl_bus_foreach(ctx, bus) {
> +		top = cxl_bus_get_port(bus);
> +
> +		cxl_port_foreach_all(top, port)
> +			cxl_dport_foreach(port, dport)
> +				if (!strcmp(devname,
> +					    cxl_dport_get_devname(dport)))
> +					return dport;

Would it be worthwhile to create a util_cxl_dport_filter()?

> +	}
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
> +	printf("injected %s protocol error.\n",
> +	       cxl_protocol_error_get_str(perror));

log_info() maybe?

> +	return 0;
> +}
> +
> +static int poison_action(struct cxl_ctx *ctx, const char *filter,
> +			 const char *addr)
> +{
> +	struct cxl_memdev *memdev;
> +	size_t a;

Maybe rename 'addr' to 'addr_str' and rename 'a' to 'addr'

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
> +	if (!addr) {
> +		log_err(&iel, "no address provided\n");
> +		return -EINVAL;
> +	}
> +
> +	a = strtoull(addr, NULL, 0);
> +	if (a == ULLONG_MAX && errno == ERANGE) {
> +		log_err(&iel, "invalid address %s", addr);
> +		return -EINVAL;
> +	}
> +
> +	rc = cxl_memdev_inject_poison(memdev, a);
> +

unnecessary blank line> +	if (rc)
> +		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
> +			cxl_memdev_get_devname(memdev), addr, strerror(-rc));
> +	else
> +		printf("poison injected at %s:%s\n",
> +		       cxl_memdev_get_devname(memdev), addr);

log_info() maybe?

DJ

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
> +	if (argc != 1) {
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
> +	log_err(&iel, "Invalid error type %s", inj_param.type);
> +	return rc;
> +}
> +
> +int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +	int rc = inject_action(argc, argv, ctx, inject_options,
> +			       "inject-error <device> [<options>]");
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


