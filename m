Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139F61C6FF5
	for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 20:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765397488; cv=none; b=TIR+qzlOncWxWuUMvsRCfhJU8Mz/9QTvRjVnekH6Ms/EBgtOOUYGEbISglEpEbAtPe6r5p52lMDwVFGs6SAK2yGphpxWwR3IgGuMWHhqfoaCgodb/tupR5e7qAiJGyTlezbQg3kze1/7QKhyI6KXHRxLxLxrbZMmE/6MFE49Ngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765397488; c=relaxed/simple;
	bh=ugmiUSKeBwB3U7U8HE3Tjw/mFOjUyyYKsSg86ukCw1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ILIXyI+k9jx6op0q3ub90FdmnYxpJGAYK8FVSfmqpFwiPFIFb7c4Gcn6GzmBdni9e4Ol6Ph/Jr6kRgp4G8OuYon99pZU94yVRo7+LvEyN7YHW5me9vBj7py2EUoTIg1cohfi2l1w/fJdisl8SJQAk7xxepIBkdBsOc3JT4CY9Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VgTHoRUJ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VgTHoRUJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765397487; x=1796933487;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ugmiUSKeBwB3U7U8HE3Tjw/mFOjUyyYKsSg86ukCw1Q=;
  b=VgTHoRUJeOW7k30/KWqQTl/UCe/2Mg6eS3SdNCMGkKY9328EmsgWFzr+
   TpdQfforRMj5PdqDK+n9iIPvQQLGxYQL+LcjoLDdeOQHYbCjYudXVgGC4
   0LDsk/rGVmtlbGYd83IMd6dgwx4xi9nIEkcoSAZXi6quG4gLoSEzVb5Xj
   fdpPkerpxZ2UCtcOaX74FH66jhkbNKzkBPBdHpkaFQbFY478ke6aPlvRn
   wTacoS7Ksencfs1d1yyp/B6ww2QF8wGYqzU7MSSg4YCJcObDJAY9iuNQ+
   zzoMl0VwZNjS5cDsR6i6lq4bnaVHlzr+KA+YClHBwF3ynev7amZoQcXux
   A==;
X-CSE-ConnectionGUID: DJRI1INYRV+mbRK0r+gdYQ==
X-CSE-MsgGUID: AiQuSHSnSTuaiJi401OG+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67263802"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67263802"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:11:26 -0800
X-CSE-ConnectionGUID: udSJzB0bRXmhZc2LBkKrCg==
X-CSE-MsgGUID: BikeeAMjQVSVRehv1p0x+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="196664796"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.138]) ([10.125.109.138])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:11:26 -0800
Message-ID: <68a1cf22-fd8f-4645-9717-f52cfaff5c3a@intel.com>
Date: Wed, 10 Dec 2025 13:11:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] cxl: Add clear-error command
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-6-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209171404.64412-6-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 10:14 AM, Ben Cheatham wrote:
> Add the 'cxl-clear-error' command. This command allows the user to clear
> device poison from CXL memory devices.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/builtin.h      |  1 +
>  cxl/cxl.c          |  1 +
>  cxl/inject-error.c | 70 ++++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 67 insertions(+), 5 deletions(-)
> 
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index e82fcb5..68ed1de 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -26,6 +26,7 @@ int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_clear_error(int argc, const char **argv, struct cxl_ctx *ctx);
>  #ifdef ENABLE_LIBTRACEFS
>  int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
>  #else
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index a98bd6b..e1740b5 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -81,6 +81,7 @@ static struct cmd_struct commands[] = {
>  	{ "destroy-region", .c_fn = cmd_destroy_region },
>  	{ "monitor", .c_fn = cmd_monitor },
>  	{ "inject-error", .c_fn = cmd_inject_error },
> +	{ "clear-error", .c_fn = cmd_clear_error },
>  };
>  
>  int main(int argc, const char **argv)
> diff --git a/cxl/inject-error.c b/cxl/inject-error.c
> index c0a9eeb..4ba3de0 100644
> --- a/cxl/inject-error.c
> +++ b/cxl/inject-error.c
> @@ -19,6 +19,10 @@ static struct inject_params {
>  	const char *address;
>  } inj_param;
>  
> +static struct clear_params {
> +	const char *address;
> +} clear_param;
> +
>  static const struct option inject_options[] = {
>  	OPT_STRING('t', "type", &inj_param.type, "Error type",
>  		   "Error type to inject into <device>"),
> @@ -30,6 +34,15 @@ static const struct option inject_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option clear_options[] = {
> +	OPT_STRING('a', "address", &clear_param.address, "Address for poison clearing",
> +		   "Device physical address to clear poison from in hex or decimal"),
> +#ifdef ENABLE_DEBUG
> +	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
> +#endif
> +	OPT_END(),
> +};
> +
>  static struct log_ctx iel;
>  
>  static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
> @@ -102,7 +115,7 @@ static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
>  }
>  
>  static int poison_action(struct cxl_ctx *ctx, const char *filter,
> -			 const char *addr_str)
> +			 const char *addr_str, bool clear)
>  {
>  	struct cxl_memdev *memdev;
>  	size_t addr;
> @@ -129,12 +142,18 @@ static int poison_action(struct cxl_ctx *ctx, const char *filter,
>  		return -EINVAL;
>  	}
>  
> -	rc = cxl_memdev_inject_poison(memdev, addr);
> +	if (clear)
> +		rc = cxl_memdev_clear_poison(memdev, addr);
> +	else
> +		rc = cxl_memdev_inject_poison(memdev, addr);
> +
>  	if (rc)
> -		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
> +		log_err(&iel, "failed to %s %s:%s: %s\n",
> +			clear ? "clear poison at" : "inject point at",
>  			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));
>  	else
> -		log_info(&iel, "poison injected at %s:%s\n",
> +		log_info(&iel,
> +			 "poison %s at %s:%s\n", clear ? "cleared" : "injected",
>  			 cxl_memdev_get_devname(memdev), addr_str);
>  
>  	return rc;
> @@ -166,7 +185,7 @@ static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  	}
>  
>  	if (strcmp(inj_param.type, "poison") == 0) {
> -		rc = poison_action(ctx, argv[0], inj_param.address);
> +		rc = poison_action(ctx, argv[0], inj_param.address, false);
>  		return rc;
>  	}
>  
> @@ -187,3 +206,44 @@ int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
>  
>  	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
>  }
> +
> +static int clear_action(int argc, const char **argv, struct cxl_ctx *ctx,
> +			const struct option *options, const char *usage)
> +{
> +	const char * const u[] = {
> +		usage,
> +		NULL
> +	};
> +	int rc = -EINVAL;
> +
> +	log_init(&iel, "cxl clear-error", "CXL_CLEAR_LOG");
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
> +	rc = poison_action(ctx, argv[0], clear_param.address, true);
> +	if (rc) {
> +		log_err(&iel, "Failed to inject poison into %s: %s\n",
> +			argv[0], strerror(-rc));
> +		return rc;
> +	}
> +
> +	return rc;
> +}
> +
> +int cmd_clear_error(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +	int rc = clear_action(argc, argv, ctx, clear_options,
> +			      "clear-error <device> [<options>]");
> +	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
> +}

