Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A079778F2B
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767981294; cv=none; b=ZGYe4tyQ9t+UB6/ZpxGOlvbUGw1ODQul720H1X3NZbb4cJoKPUES+w7vCKZwmPP/7DeJfYdGf2bR4rTIoJJPki18ASpQzowTifGkR60amz2aU5XEM1m57FO605Iky3i6bOSIu9KK/IAanPf7qLcN1AGOk7PDzThuv0SnP4SFXH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767981294; c=relaxed/simple;
	bh=1CtmTXVe2fbpcir7mByF6JiYHYQtpB1b1dFfaqmwA/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N0pika6p4Pkoo132kgzoz0zWMiSEtrVHZx4OsHmabXCnlBs5nf1GNOh618uAG7Y91U6+0zTw54JkRTTaAcs0NJaPKErHQOJNqjWIJbj7G9ay7JuPp3eP/lVeICV5QpPqMhIjXBg0me2fjx8TJ0mt1UaE4HgY4xtNlltMyHZpDUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0m5wGaL; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0m5wGaL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767981292; x=1799517292;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1CtmTXVe2fbpcir7mByF6JiYHYQtpB1b1dFfaqmwA/s=;
  b=M0m5wGaLarJyCf0cAVu8GJ2TpLWyc7jbbusp15DO679EDaZg9Kj2a20h
   2o6oSzYD5fg8NH22rhBGSPS8wzNgozFPHceH+1J/wQVNhv+34DM9sBd+J
   joQ71ACm4VVw7QqmFCx33UA8TYVDNpqhMmkYzX9gL8ewMq+yGJBzdYIeh
   NdaXeme6pGdrRGw+9u+ZUX/ERh+tcv/ERW7lisx8aF0aT4B+jx3Mxg8Um
   1cWKsYcm+Fcg4eA9rRTkUI247RC92HmyWHlpEZ9K7DinYPcPwCOJsVGEd
   22FJq91yYO+BakuJAnyoQqr56KMghE+MecAbLryUvV9IDOeo36u/gRif5
   A==;
X-CSE-ConnectionGUID: W4sRZXovTSmDvOH1vPARFg==
X-CSE-MsgGUID: CdPY/SV5TpihKs2vXZdSKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="92027739"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="92027739"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 09:54:52 -0800
X-CSE-ConnectionGUID: dN4hZ0aIRNKb6YZ4bkrEUA==
X-CSE-MsgGUID: oebWsVAjRgil8LebSo8Wbw==
X-ExtLoop1: 1
Received: from agladkov-desk.ger.corp.intel.com (HELO [10.125.110.37]) ([10.125.110.37])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 09:54:52 -0800
Message-ID: <c6f4f05b-b1b8-4b2b-b9d8-27be52b3e549@intel.com>
Date: Fri, 9 Jan 2026 10:54:50 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] libcxl: Add CXL protocol errors
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev,
 alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-3-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260109160720.1823-3-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 9:07 AM, Ben Cheatham wrote:
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

Just a nit below. otherwise

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/lib/libcxl.c   | 194 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |   5 ++
>  cxl/lib/private.h  |  14 ++++
>  cxl/libcxl.h       |  13 +++
>  4 files changed, 226 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 6b7e92c..27ff037 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -48,11 +48,13 @@ struct cxl_ctx {
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
> @@ -207,6 +209,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
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
> @@ -325,6 +335,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
>  	*ctx = c;
>  	list_head_init(&c->memdevs);
>  	list_head_init(&c->buses);
> +	list_head_init(&c->perrors);
>  	c->kmod_ctx = kmod_ctx;
>  	c->daxctl_ctx = daxctl_ctx;
>  	c->udev = udev;
> @@ -366,6 +377,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
>   */
>  CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>  {
> +	struct cxl_protocol_error *perror, *_p;
>  	struct cxl_memdev *memdev, *_d;
>  	struct cxl_bus *bus, *_b;
>  
> @@ -381,6 +393,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>  	list_for_each_safe(&ctx->buses, bus, _b, port.list)
>  		free_bus(bus, &ctx->buses);
>  
> +	list_for_each_safe(&ctx->perrors, perror, _p, list)
> +		free_protocol_error(perror, &ctx->perrors);
> +
>  	udev_queue_unref(ctx->udev_queue);
>  	udev_unref(ctx->udev);
>  	kmod_unref(ctx->kmod_ctx);
> @@ -3423,6 +3438,185 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
>  	return port->decoders_committed;
>  }
>  
> +const struct cxl_protocol_error cxl_protocol_errors[] = {
> +	CXL_PROTOCOL_ERROR(0x1000, "cache-correctable"),
> +	CXL_PROTOCOL_ERROR(0x2000, "cache-uncorrectable"),
> +	CXL_PROTOCOL_ERROR(0x4000, "cache-fatal"),
> +	CXL_PROTOCOL_ERROR(0x8000, "mem-correctable"),
> +	CXL_PROTOCOL_ERROR(0x10000, "mem-uncorrectable"),
> +	CXL_PROTOCOL_ERROR(0x20000, "mem-fatal")
> +};
> +
> +static struct cxl_protocol_error *create_cxl_protocol_error(struct cxl_ctx *ctx,
> +							    unsigned int n)
> +{
> +	struct cxl_protocol_error *perror;
> +
> +	for (unsigned long i = 0; i < ARRAY_SIZE(cxl_protocol_errors); i++) {
> +		if (n != cxl_protocol_errors[i].num)
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
> +	if (!ctx->cxl_debugfs)
> +		return;
> +
> +	path_len = strlen(ctx->cxl_debugfs) + 100;
> +	path = calloc(1, path_len);

Maybe just use PATH_MAX from <linux/limits.h>.

DJ

> +	if (!path)
> +		return;
> +
> +	len = snprintf(path, path_len, "%s/einj_types", ctx->cxl_debugfs);
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
> +		err(ctx, "failed to read %s: %s\n", path, strerror(-rc));
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
> +			list_add_tail(&ctx->perrors, &perror->list);
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
> +	if (!ctx->cxl_debugfs)
> +		return -ENOENT;
> +
> +	path_len = strlen(ctx->cxl_debugfs) + 100;
> +	path = calloc(path_len, sizeof(char));
> +	if (!path)
> +		return -ENOMEM;
> +
> +	len = snprintf(path, path_len, "%s/%s/einj_inject", ctx->cxl_debugfs,
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
> +	len = snprintf(buf, sizeof(buf), "0x%x\n", error);
> +	if (len >= sizeof(buf)) {
> +		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
> +		free(path);
> +		return -ENOMEM;
> +	}
> +
> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc) {
> +		err(ctx, "failed to write %s: %s\n", path, strerror(-rc));
> +		free(path);
> +		return -errno;
> +	}
> +
> +	free(path);
> +	return 0;
> +}
> +
>  static void *add_cxl_bus(void *parent, int id, const char *cxlbus_base)
>  {
>  	const char *devname = devpath_to_devname(cxlbus_base);
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 36a93c3..c683b83 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -304,4 +304,9 @@ global:
>  LIBCXL_11 {
>  global:
>  	cxl_region_get_extended_linear_cache_size;
> +	cxl_protocol_error_get_first;
> +	cxl_protocol_error_get_next;
> +	cxl_protocol_error_get_num;
> +	cxl_protocol_error_get_str;
> +	cxl_dport_protocol_error_inject;
>  } LIBCXL_10;
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 542cdb7..582eebf 100644
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
> index 9371aac..faef62e 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -498,6 +498,19 @@ int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
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

