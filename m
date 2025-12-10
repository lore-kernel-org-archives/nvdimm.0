Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B92931815D
	for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 20:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765397454; cv=none; b=Eh46iWC+3cE4P/mSkDEKxdKTODCERiopwaXGcU7cYUoR7+4cq+i4Lhi3M/d4AwPCUknMmAgwzVnjLv8HBxmmPc9M8+OBjth6PUO3lJ9zOlJSp+Sj4OZsAIvDqyGqrPJtAfpDXc4QR5fjSHyLuytOdMguG9e8H0owFy0IzzNDdAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765397454; c=relaxed/simple;
	bh=hO/T8BnxuUR+DkPRcHek//CRFk+5qZzfCXM2uRlog2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h1d8NQKeeNjU4nuvv1uGlHFxlg14pWPnOGx585FeyELeURV3za9y6syojfefTFy6wUu5c+JQITIRhY71ZkHQcz3ngPr+NyVkgC/Yma1zamcNTpOEOUPL/8fpJ1k5aTnml2kFUFL5+zs3RR6R6Sg/f1BTduk1RKYFUaepfPZXWqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/pZ0BSO; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/pZ0BSO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765397453; x=1796933453;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hO/T8BnxuUR+DkPRcHek//CRFk+5qZzfCXM2uRlog2Y=;
  b=i/pZ0BSOYgoGKQtxDbgDrcDwu7u6RjHv4BOJLaZlxYAfUuJilqVE+uZ4
   IJ0JJSvpoA6ti2lMsEPBFOtFHJfqZJG9niDGuFM5AG1nXKZxVRCkNp2/H
   Tj4nfwKQUu/oCs6Fl7SX/rh8fQ5WnVZ41FP3x0X/CK9NEdIDej1c26n6+
   WTuiVYlLdPTpwfRxHcfyys6mPLdRyIe0YYAkcmvtZKbbwu7PY7hjA1ocW
   IWAe+Msw0JS9MiwRlrF8XZ62Fn3vYPz5u0mrSazt2ocj1EDQ1mHExWxtU
   5fd9817IXBRmM7/5CJLBurz2//yxGJwld0igxlpKvv9Ak9cCiX24sjY2D
   A==;
X-CSE-ConnectionGUID: coUElxvJQLubs8rRV/edbQ==
X-CSE-MsgGUID: mp5rRdgyRIqpq7RWpELbtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67425917"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67425917"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:10:53 -0800
X-CSE-ConnectionGUID: ZiFmOEAqRlK1ZM6g9rXg5w==
X-CSE-MsgGUID: 3Q6c/VOWTE+oMXBabW35bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="219950201"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.138]) ([10.125.109.138])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:10:51 -0800
Message-ID: <eabc6abb-0bce-42c1-9664-e97de5de3c67@intel.com>
Date: Wed, 10 Dec 2025 13:10:50 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] cxl: Add inject-error command
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-5-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209171404.64412-5-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 10:14 AM, Ben Cheatham wrote:
> Add the 'cxl-inject-error' command. This command will provide CXL
> protocol error injection for CXL VH root ports and CXL RCH downstream
> ports, as well as poison injection for CXL memory devices.
> 
> Add util_cxl_dport_filter() to find downstream ports by either dport id
> or device name.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/builtin.h      |   1 +
>  cxl/cxl.c          |   1 +
>  cxl/filter.c       |  26 +++++++
>  cxl/filter.h       |   2 +
>  cxl/inject-error.c | 189 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/meson.build    |   1 +
>  6 files changed, 220 insertions(+)
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
> index 0000000..c0a9eeb
> --- /dev/null
> +++ b/cxl/inject-error.c
> @@ -0,0 +1,189 @@
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
> +	size_t addr;
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

