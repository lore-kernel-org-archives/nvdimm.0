Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3601E3002D8
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 22:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767996778; cv=none; b=Ic+eso1KCE6Ay5JC+RAuJF5WTG1ZqGA81ZzYhwVhY75gBB77UuppXnn5sOw81Xgx0R6Csf9iUQ4Ib2+jgIt8omwAFld9bPsGPbgjMUxoWJ/l6wjlCdd/gemrxqSb2Y6gpM1d9tpIQMZFol3pXH485u3oK89570IFL2C+8lKcRwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767996778; c=relaxed/simple;
	bh=Hj1sr74OfKnz3wfCACyd/Kfh01zHzBvmk7Fc1z9GDS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XnVMofWHTlKkokxKgtVKJFU9wHScPhX30+Rnmr6n7RX58NNluOaR9YYYtjSpOnkCEHlIllKrs1HBCCTSRnTk5dG3EmopQB/gKCOqqpiOjzlVOtZgbjLVcf6EbXeS3U2c1EL76wjOBmaxvL8cXYMKgBWTU50LOwpszBsi0Azw6A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W/Hmc1UJ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W/Hmc1UJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767996777; x=1799532777;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Hj1sr74OfKnz3wfCACyd/Kfh01zHzBvmk7Fc1z9GDS8=;
  b=W/Hmc1UJj1jY5FfTbrxqiFqhRjO21BUyGrei0rQpXlGbhNOFuEmq69KS
   FRwrIMP7VuPpwtqaZ9aoTwL87gsFQIRYikoNyPnmdN7qKjEdlD6BuMnvO
   seJTNGRZiK+9zJOKM4VsCdppLv9riXpYP2YzllWi138pIKxpQDH8KXj3N
   9S86WqjMfpLiliojDQPPgs4+VP2ezRpxPhhnt2AxbbaCPBBHQ6eyKvBVF
   OR4ZtDIt8aJyO+AmvhDSlqHqnDHIOj3Uz2OpTf72C5vQUl+fnd3q3WU6C
   FwY+9lzUtXN8Efokl5IY/zhbfqjZwbDM3zL/2f6iofNgODe9zP4mzrawg
   A==;
X-CSE-ConnectionGUID: FjveFaKLQ3yiQottuP3ByA==
X-CSE-MsgGUID: xboNRtzRRNeQdU2qrQ1Xuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69280624"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="69280624"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:12:57 -0800
X-CSE-ConnectionGUID: t2wBEM8HSfeMBymOxAT0Xg==
X-CSE-MsgGUID: oaV+gcFqRHGFAt8BRjoS5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="241074527"
Received: from agladkov-desk.ger.corp.intel.com (HELO [10.125.110.37]) ([10.125.110.37])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:12:56 -0800
Message-ID: <04a8ac94-d100-4417-a347-5a0dfb6e6de2@intel.com>
Date: Fri, 9 Jan 2026 15:12:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] cxl: Add clear-error command
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev,
 alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-6-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260109160720.1823-6-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 9:07 AM, Ben Cheatham wrote:
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
> index 0ca2e6b..76f9fa9 100644
> --- a/cxl/inject-error.c
> +++ b/cxl/inject-error.c
> @@ -17,6 +17,10 @@ static struct inject_params {
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
> @@ -28,6 +32,15 @@ static const struct option inject_options[] = {
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
> @@ -100,7 +113,7 @@ static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
>  }
>  
>  static int poison_action(struct cxl_ctx *ctx, const char *filter,
> -			 const char *addr_str)
> +			 const char *addr_str, bool clear)
>  {
>  	struct cxl_memdev *memdev;
>  	unsigned long long addr;
> @@ -128,12 +141,18 @@ static int poison_action(struct cxl_ctx *ctx, const char *filter,
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
> +			clear ? "clear poison at" : "inject poison at",
>  			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));
>  	else
> -		log_info(&iel, "poison injected at %s:%s\n",
> +		log_info(&iel,
> +			 "poison %s at %s:%s\n", clear ? "cleared" : "injected",
>  			 cxl_memdev_get_devname(memdev), addr_str);
>  
>  	return rc;
> @@ -165,7 +184,7 @@ static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  	}
>  
>  	if (strcmp(inj_param.type, "poison") == 0) {
> -		rc = poison_action(ctx, argv[0], inj_param.address);
> +		rc = poison_action(ctx, argv[0], inj_param.address, false);
>  		return rc;
>  	}
>  
> @@ -186,3 +205,44 @@ int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
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
> +		log_err(&iel, "Failed to clear poison on %s at: %s\n",
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

