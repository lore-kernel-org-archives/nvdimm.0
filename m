Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24C52C3278
	for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 19:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765396486; cv=none; b=YQVBhxQVnWHvvAxyNnQ2Tvwqr53IwJOQm//ba0ISvN/TSaTzfunkphgyxwZmXBT8JvfStFYGrdsdXtopJhKB40Ue0uLQgiuDt2dBZtwZSC7MkdibYQPcOcrDozaiiqFkkghPjXk3qAgP7z5XAD3W5kpYprdJCJaNbWzHQLqKPpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765396486; c=relaxed/simple;
	bh=LFXK/EmjZkHLjoR54/gC+pGVhl4fvOqMaDi5rGOYwmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cBUy7lwmdAowu6M9KNkfA8FCBFcHJuG6FIx/QgNY1/iaR76Rhys1H5nxjxajtfepw3HeyodnQDm2xDAPvGy0yLH6ZEjZ/ZXEuCIwOYkYdarUDOFoJooKeX4+qnRvgQWBqrNMkRAmvvPWmT6nbgd0ramrtAOLwR4TXmAI84t8BBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mX9WHJ6D; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mX9WHJ6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765396485; x=1796932485;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LFXK/EmjZkHLjoR54/gC+pGVhl4fvOqMaDi5rGOYwmI=;
  b=mX9WHJ6DBgCw9w7U/AvOlStyqzasgupEub2e2zC+eAdRFxQNXvddWN+f
   0yXLBtY6lsHZnoNU2n3XPU185XOMu5g9x1m6aKWq+rELn9sPKnUlfWdLk
   lSJHBnkVPCHY0LF8wzKFVefWV0Usjz+uCe1bUBEk4aNH3i7SEQj/RyC0Z
   mO5U32o8jmkbf2cCVXPbLxfWeklV2fA2L+/wnmT2YA916NAy+2XegOINJ
   nmx8h2v8+ifxgI04QO29OwMEklV5iLo687iFKfqa9Yju5UtFyuZwdcHzs
   TJXSFQOHGGrB2um8Rc6SQLo3qAuVFPJ2vIMHOhpd4yxi+eWmDCa/SRT1v
   w==;
X-CSE-ConnectionGUID: yMs4PS7SRVe83sV4tR2ROw==
X-CSE-MsgGUID: 2biCq+7lT9WiPW1mnKXfFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67261898"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67261898"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 11:54:45 -0800
X-CSE-ConnectionGUID: nTWPGDJqQzevADZYI5usRA==
X-CSE-MsgGUID: M5o57gzpQSihX64+96M/xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="196661406"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.138]) ([10.125.109.138])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 11:54:45 -0800
Message-ID: <1a82d5be-3126-4b04-a5ac-da651c33a21b@intel.com>
Date: Wed, 10 Dec 2025 12:54:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] libcxl: Add CXL protocol errors
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-3-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209171404.64412-3-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 10:13 AM, Ben Cheatham wrote:
> The v6.11 Linux kernel adds CXL protocl (CXL.cache & CXL.mem) error
> injection for platforms that implement the error types as according to
> the v6.5+ ACPI specification. The interface for injecting these errors
> are provided by the kernel under the CXL debugfs. The relevant files in
> the interface are the einj_types file, which provides the available CXL
> error types for injection, and the einj_inject file, which injects the
> error into a CXL VH root port or CXL RCH downstream port.
> 
> Add a library API to retrieve the CXL error types and inject them. This
> API will be used in a later commit by the 'cxl-inject-error' and
> 'cxl-list' commands.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

just couple minor comments below, otherwise looks ok

> ---
>  cxl/lib/libcxl.c   | 193 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |   5 ++
>  cxl/lib/private.h  |  14 ++++
>  cxl/libcxl.h       |  13 +++
>  4 files changed, 225 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 3718b76..44d5ce2 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -46,11 +46,13 @@ struct cxl_ctx {
>  	void *userdata;
>  	int memdevs_init;
>  	int buses_init;
> +	int perrors_init;
>  	unsigned long timeout;
>  	struct udev *udev;
>  	struct udev_queue *udev_queue;
>  	struct list_head memdevs;
>  	struct list_head buses;
> +	struct list_head perrors;
>  	struct kmod_ctx *kmod_ctx;
>  	struct daxctl_ctx *daxctl_ctx;
>  	void *private_data;
> @@ -205,6 +207,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
>  	free(bus);
>  }
>  
> +static void free_protocol_error(struct cxl_protocol_error *perror,
> +				struct list_head *head)
> +{
> +	if (head)
> +		list_del_from(head, &perror->list);
> +	free(perror);
> +}
> +
>  /**
>   * cxl_get_userdata - retrieve stored data pointer from library context
>   * @ctx: cxl library context
> @@ -328,6 +338,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
>  	*ctx = c;
>  	list_head_init(&c->memdevs);
>  	list_head_init(&c->buses);
> +	list_head_init(&c->perrors);
>  	c->kmod_ctx = kmod_ctx;
>  	c->daxctl_ctx = daxctl_ctx;
>  	c->udev = udev;
> @@ -369,6 +380,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
>   */
>  CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>  {
> +	struct cxl_protocol_error *perror, *_p;
>  	struct cxl_memdev *memdev, *_d;
>  	struct cxl_bus *bus, *_b;
>  
> @@ -384,6 +396,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>  	list_for_each_safe(&ctx->buses, bus, _b, port.list)
>  		free_bus(bus, &ctx->buses);
>  
> +	list_for_each_safe(&ctx->perrors, perror, _p, list)
> +		free_protocol_error(perror, &ctx->perrors);
> +
>  	udev_queue_unref(ctx->udev_queue);
>  	udev_unref(ctx->udev);
>  	kmod_unref(ctx->kmod_ctx);
> @@ -3416,6 +3431,184 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
>  	return port->decoders_committed;
>  }
>  
> +const struct cxl_protocol_error cxl_protocol_errors[] = {
> +	CXL_PROTOCOL_ERROR(12, "cache-correctable"),
> +	CXL_PROTOCOL_ERROR(13, "cache-uncorrectable"),
> +	CXL_PROTOCOL_ERROR(14, "cache-fatal"),
> +	CXL_PROTOCOL_ERROR(15, "mem-correctable"),
> +	CXL_PROTOCOL_ERROR(16, "mem-uncorrectable"),
> +	CXL_PROTOCOL_ERROR(17, "mem-fatal")
> +};
> +
> +static struct cxl_protocol_error *create_cxl_protocol_error(struct cxl_ctx *ctx,
> +							    unsigned int n)
> +{
> +	struct cxl_protocol_error *perror;
> +
> +	for (unsigned long i = 0; i < ARRAY_SIZE(cxl_protocol_errors); i++) {
> +		if (n != BIT(cxl_protocol_errors[i].num))
> +			continue;
> +
> +		perror = calloc(1, sizeof(*perror));
> +		if (!perror)
> +			return NULL;
> +
> +		*perror = cxl_protocol_errors[i];
> +		perror->ctx = ctx;
> +		return perror;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
> +{
> +	struct cxl_protocol_error *perror;
> +	char buf[SYSFS_ATTR_SIZE];
> +	char *path, *num, *save;
> +	size_t path_len, len;
> +	unsigned long n;
> +	int rc = 0;
> +
> +	if (!ctx->debugfs)
> +		return;
> +
> +	path_len = strlen(ctx->debugfs) + 100;
> +	path = calloc(1, path_len);
> +	if (!path)
> +		return;
> +
> +	len = snprintf(path, path_len, "%s/cxl/einj_types", ctx->debugfs);
> +	if (len >= path_len) {
> +		err(ctx, "Buffer too small\n");
> +		goto err;
> +	}
> +
> +	rc = access(path, F_OK);
> +	if (rc) {
> +		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
> +		goto err;
> +	}
> +
> +	rc = sysfs_read_attr(ctx, path, buf);
> +	if (rc) {
> +		err(ctx, "failed to read %s: %s\n", path, strerror(errno));

sysfs_read_attr() is a local lib function and not glibc. It returns -errno and does not set errno. See util/sysfs.c.

> +		goto err;
> +	}
> +
> +	/*
> +	 * The format of the output of the einj_types attr is:
> +	 * <Error number in hex 1> <Error name 1>
> +	 * <Error number in hex 2> <Error name 2>
> +	 * ...
> +	 *
> +	 * We only need the number, so parse that and skip the rest of
> +	 * the line.
> +	 */
> +	num = strtok_r(buf, " \n", &save);
> +	while (num) {
> +		n = strtoul(num, NULL, 16);
> +		perror = create_cxl_protocol_error(ctx, n);
> +		if (perror)
> +			list_add(&ctx->perrors, &perror->list);
> +
> +		num = strtok_r(NULL, "\n", &save);
> +		if (!num)
> +			break;
> +
> +		num = strtok_r(NULL, " \n", &save);
> +	}
> +
> +err:
> +	free(path);
> +}
> +
> +static void cxl_protocol_errors_init(struct cxl_ctx *ctx)
> +{
> +	if (ctx->perrors_init)
> +		return;
> +
> +	ctx->perrors_init = 1;
> +	cxl_add_protocol_errors(ctx);
> +}
> +
> +CXL_EXPORT struct cxl_protocol_error *
> +cxl_protocol_error_get_first(struct cxl_ctx *ctx)
> +{
> +	cxl_protocol_errors_init(ctx);
> +
> +	return list_top(&ctx->perrors, struct cxl_protocol_error, list);
> +}
> +
> +CXL_EXPORT struct cxl_protocol_error *
> +cxl_protocol_error_get_next(struct cxl_protocol_error *perror)
> +{
> +	struct cxl_ctx *ctx = perror->ctx;
> +
> +	return list_next(&ctx->perrors, perror, list);
> +}
> +
> +CXL_EXPORT unsigned int
> +cxl_protocol_error_get_num(struct cxl_protocol_error *perror)
> +{
> +	return perror->num;
> +}
> +
> +CXL_EXPORT const char *
> +cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
> +{
> +	return perror->string;
> +}
> +
> +CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
> +					       unsigned int error)
> +{
> +	struct cxl_ctx *ctx = dport->port->ctx;
> +	char buf[32] = { 0 };
> +	size_t path_len, len;
> +	char *path;
> +	int rc;
> +
> +	if (!ctx->debugfs)
> +		return -ENOENT;
> +
> +	path_len = strlen(ctx->debugfs) + 100;
> +	path = calloc(path_len, sizeof(char));
> +	if (!path)
> +		return -ENOMEM;
> +
> +	len = snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
> +		      cxl_dport_get_devname(dport));
> +	if (len >= path_len) {
> +		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
> +		free(path);
> +		return -ENOMEM;
> +	}
> +
> +	rc = access(path, F_OK);
> +	if (rc) {
> +		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
> +		free(path);
> +		return -errno;
> +	}
> +
> +	len = snprintf(buf, sizeof(buf), "0x%lx\n", BIT(error));
> +	if (len >= sizeof(buf)) {
> +		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
> +		free(path);
> +		return -ENOMEM;
> +	}
> +
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc) {

Same comment as above

DJ
> +		err(ctx, "failed to write %s: %s\n", path, strerror(errno));
> +		free(path);
> +		return -errno;
> +	}
> +
> +	return 0;
> +}
> +
>  static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
>  {
>  	const char *devname = devpath_to_devname(cxlbus_base);
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index e01a676..02d5119 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -299,4 +299,9 @@ global:
>  LIBCXL_10 {
>  global:
>  	cxl_memdev_is_port_ancestor;
> +	cxl_protocol_error_get_first;
> +	cxl_protocol_error_get_next;
> +	cxl_protocol_error_get_num;
> +	cxl_protocol_error_get_str;
> +	cxl_dport_protocol_error_inject;
>  } LIBCXL_9;
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 7d5a1bc..8860669 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -108,6 +108,20 @@ struct cxl_port {
>  	struct list_head dports;
>  };
>  
> +struct cxl_protocol_error {
> +	unsigned int num;
> +	const char *string;
> +	struct cxl_ctx *ctx;
> +	struct list_node list;
> +};
> +
> +#define CXL_PROTOCOL_ERROR(n, str)	\
> +	((struct cxl_protocol_error){	\
> +		.num = (n),		\
> +		.string = (str),	\
> +		.ctx = NULL,		\
> +	})
> +
>  struct cxl_bus {
>  	struct cxl_port port;
>  };
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 54bc025..adb5716 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -496,6 +496,19 @@ int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
>  						  int enable);
>  struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memdev);
>  
> +struct cxl_protocol_error;
> +struct cxl_protocol_error *cxl_protocol_error_get_first(struct cxl_ctx *ctx);
> +struct cxl_protocol_error *
> +cxl_protocol_error_get_next(struct cxl_protocol_error *perror);
> +unsigned int cxl_protocol_error_get_num(struct cxl_protocol_error *perror);
> +const char *cxl_protocol_error_get_str(struct cxl_protocol_error *perror);
> +int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
> +				    unsigned int error);
> +
> +#define cxl_protocol_error_foreach(ctx, perror)				       \
> +	for (perror = cxl_protocol_error_get_first(ctx); perror != NULL;       \
> +	     perror = cxl_protocol_error_get_next(perror))
> +
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif

