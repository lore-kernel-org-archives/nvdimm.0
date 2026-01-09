Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D38C28B7DB
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 22:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767997062; cv=none; b=c3MRI5Y22FSE5quY0cYg3GMc2FjHh3nTpiMWabDCGZfQnwJkdI+poKki5pU0bNoJu1zZQ02C5MPMvFSM027Ug9Zorripk+z0U4/eEVOIzQMlpfmLssxv30ERA51USfcZ6/o4vejHvsYngLNw6WZ5fs82mKgyYo2b6y4QSC1GsS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767997062; c=relaxed/simple;
	bh=6VoXtoQduRd+abxsbtZjdaJ+dUjgmSvuvslWtEz4/c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U7KmK7QGyPVXmQfMR7wWJurKsm2rrNB69J0CUtGtwugjSFOLaWgz+1Z/GVeU/aLPgbSn/gpQXo/mbOlwU5oZ8JHoOGn7Lsrd0u8FqeXz7g6D4YgiwbLBPLu2HdzIM1MF0milHItnuJyR9vcbb5CvUapGepVafoyAP8Mqf6CcnNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nIgfNBzc; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nIgfNBzc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767997061; x=1799533061;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6VoXtoQduRd+abxsbtZjdaJ+dUjgmSvuvslWtEz4/c0=;
  b=nIgfNBzcIR2ePin2Kr9BHOnZD9c+Vnx7ySn1E8b/lf3Htkqujw8slJSp
   zux7XWY8YdzpdKahzHvy5WGomSxLjexM+tXl8HHNXmBSxdk56aj/DHEMC
   W2a0gVyHxi/XqI9+rNYfiyzSpFRo1lRZ5UB2AoRu6Fx5PEejlpptkwpfQ
   9YfG3qIBxX0utesrgolP0yvQILqY+/7P0+deXnDgXy2mRD7WUhSOeJvgP
   bMyM4ZmF4BFQpzI161UxpsRemuwS9iWRogbfTxhL6/Lx77HsjmHqprTrK
   WLb6kRd4JNwUB5YrealBYXi7kP1cwvBleLLa9uofqrDS9U8JYV6I116wH
   g==;
X-CSE-ConnectionGUID: oJry1BuWRVexBcm4tQQrhQ==
X-CSE-MsgGUID: WuOImpMESkezOGGOjxYGQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69280964"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="69280964"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:17:40 -0800
X-CSE-ConnectionGUID: +Fv5CZ4XR/+hR+Banx/4Zg==
X-CSE-MsgGUID: bKHzX1gETMu/+ZQfndBivQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="241075725"
Received: from agladkov-desk.ger.corp.intel.com (HELO [10.125.110.37]) ([10.125.110.37])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:17:16 -0800
Message-ID: <c9925f29-85b4-4d7a-8fab-c8c5829d6a27@intel.com>
Date: Fri, 9 Jan 2026 15:17:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] cxl/list: Add injectable errors in output
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev,
 alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-7-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260109160720.1823-7-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 9:07 AM, Ben Cheatham wrote:
> Add injectable error information for CXL memory devices and busses.
> This information is only shown when the CXL debugfs is accessible
> (normally mounted at /sys/kernel/debug/cxl).
> 
> For CXL memory devices and dports this reports whether the device
> supports poison injection. The "--media-errors"/"-L" option shows
> injected poison for memory devices.
> 
> For CXL busses this shows injectable CXL protocol error types. The
> information will be the same across busses because the error types are
> system-wide. The information is presented under the bus for easier
> filtering.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  cxl/json.c         | 38 ++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.c   | 34 +++++++++++++++++++++++++---------
>  cxl/lib/libcxl.sym |  2 ++
>  cxl/libcxl.h       |  2 ++
>  4 files changed, 67 insertions(+), 9 deletions(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index e9cb88a..6cdf513 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -663,6 +663,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  			json_object_object_add(jdev, "state", jobj);
>  	}
>  
> +	if (cxl_debugfs_exists(cxl_memdev_get_ctx(memdev))) {
> +		jobj = json_object_new_boolean(cxl_memdev_has_poison_injection(memdev));
> +		if (jobj)
> +			json_object_object_add(jdev, "poison_injectable", jobj);
> +	}
> +
>  	if (flags & UTIL_JSON_PARTITION) {
>  		jobj = util_cxl_memdev_partition_to_json(memdev, flags);
>  		if (jobj)
> @@ -691,6 +697,7 @@ void util_cxl_dports_append_json(struct json_object *jport,
>  {
>  	struct json_object *jobj, *jdports;
>  	struct cxl_dport *dport;
> +	char *einj_path;
>  	int val;
>  
>  	val = cxl_port_get_nr_dports(port);
> @@ -739,6 +746,13 @@ void util_cxl_dports_append_json(struct json_object *jport,
>  		if (jobj)
>  			json_object_object_add(jdport, "id", jobj);
>  
> +		einj_path = cxl_dport_get_einj_path(dport);
> +		jobj = json_object_new_boolean(einj_path != NULL);
> +		if (jobj)
> +			json_object_object_add(jdport, "protocol_injectable",
> +					       jobj);
> +		free(einj_path);
> +
>  		json_object_array_add(jdports, jdport);
>  		json_object_set_userdata(jdport, dport, NULL);
>  	}
> @@ -750,6 +764,8 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
>  					 unsigned long flags)
>  {
>  	const char *devname = cxl_bus_get_devname(bus);
> +	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
> +	struct cxl_protocol_error *perror;
>  	struct json_object *jbus, *jobj;
>  
>  	jbus = json_object_new_object();
> @@ -765,6 +781,28 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
>  		json_object_object_add(jbus, "provider", jobj);
>  
>  	json_object_set_userdata(jbus, bus, NULL);
> +
> +	if (cxl_debugfs_exists(ctx)) {
> +		jobj = json_object_new_array();
> +		if (!jobj)
> +			return jbus;
> +
> +		cxl_protocol_error_foreach(ctx, perror)
> +		{
> +			struct json_object *jerr_str;
> +			const char *perror_str;
> +
> +			perror_str = cxl_protocol_error_get_str(perror);
> +
> +			jerr_str = json_object_new_string(perror_str);
> +			if (jerr_str)
> +				json_object_array_add(jobj, jerr_str);
> +		}
> +
> +		json_object_object_add(jbus, "injectable_protocol_errors",
> +				       jobj);
> +	}
> +
>  	return jbus;
>  }
>  
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index deebf7f..f824701 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -285,6 +285,11 @@ static char* get_cxl_debugfs_dir(void)
>  	return debugfs_dir;
>  }
>  
> +CXL_EXPORT bool cxl_debugfs_exists(struct cxl_ctx *ctx)
> +{
> +	return ctx->cxl_debugfs != NULL;
> +}
> +
>  /**
>   * cxl_new - instantiate a new library context
>   * @ctx: context to establish
> @@ -3567,38 +3572,49 @@ cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
>  	return perror->string;
>  }
>  
> -CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
> -					       unsigned int error)
> +CXL_EXPORT char *cxl_dport_get_einj_path(struct cxl_dport *dport)
>  {
>  	struct cxl_ctx *ctx = dport->port->ctx;
> -	char buf[32] = { 0 };
>  	size_t path_len, len;
>  	char *path;
>  	int rc;
>  
> -	if (!ctx->cxl_debugfs)
> -		return -ENOENT;
> -
>  	path_len = strlen(ctx->cxl_debugfs) + 100;
>  	path = calloc(path_len, sizeof(char));
>  	if (!path)
> -		return -ENOMEM;
> +		return NULL;
>  
>  	len = snprintf(path, path_len, "%s/%s/einj_inject", ctx->cxl_debugfs,
>  		      cxl_dport_get_devname(dport));
>  	if (len >= path_len) {
>  		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
>  		free(path);
> -		return -ENOMEM;
> +		return NULL;
>  	}
>  
>  	rc = access(path, F_OK);
>  	if (rc) {
>  		err(ctx, "failed to access %s: %s\n", path, strerror(errno));
>  		free(path);
> -		return -errno;
> +		return NULL;
>  	}
>  
> +	return path;
> +}
> +
> +CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
> +					       unsigned int error)
> +{
> +	struct cxl_ctx *ctx = dport->port->ctx;
> +	char buf[32] = { 0 };
> +	char *path;
> +	size_t len;
> +	int rc;
> +
> +	path = cxl_dport_get_einj_path(dport);
> +	if (!path)
> +		return -ENOENT;
> +
>  	len = snprintf(buf, sizeof(buf), "0x%x\n", error);
>  	if (len >= sizeof(buf)) {
>  		err(ctx, "%s: buffer too small\n", cxl_dport_get_devname(dport));
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index c636edb..ebca543 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -308,8 +308,10 @@ global:
>  	cxl_protocol_error_get_next;
>  	cxl_protocol_error_get_num;
>  	cxl_protocol_error_get_str;
> +	cxl_dport_get_einj_path;
>  	cxl_dport_protocol_error_inject;
>  	cxl_memdev_has_poison_injection;
>  	cxl_memdev_inject_poison;
>  	cxl_memdev_clear_poison;
> +	cxl_debugfs_exists;
>  } LIBCXL_10;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 4d035f0..e390aca 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -32,6 +32,7 @@ void cxl_set_userdata(struct cxl_ctx *ctx, void *userdata);
>  void *cxl_get_userdata(struct cxl_ctx *ctx);
>  void cxl_set_private_data(struct cxl_ctx *ctx, void *data);
>  void *cxl_get_private_data(struct cxl_ctx *ctx);
> +bool cxl_debugfs_exists(struct cxl_ctx *ctx);
>  
>  enum cxl_fwl_status {
>  	CXL_FWL_STATUS_UNKNOWN,
> @@ -507,6 +508,7 @@ struct cxl_protocol_error *
>  cxl_protocol_error_get_next(struct cxl_protocol_error *perror);
>  unsigned int cxl_protocol_error_get_num(struct cxl_protocol_error *perror);
>  const char *cxl_protocol_error_get_str(struct cxl_protocol_error *perror);
> +char *cxl_dport_get_einj_path(struct cxl_dport *dport);
>  int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
>  				    unsigned int error);
>  

