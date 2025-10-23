Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D6B2BB1D
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 22:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761259825; cv=none; b=NE/PkUMdTAcLmMLbKvo0HitInlb+XLO8JQHeS0pFYmYJ1jpwsum+E4DtBQnQWtiP6kg4/RCw/e79yvj9C1VNTKSlcgxk707wU1s2IRbGWzMPKKGBXO4UbEP6kY7DHorGeuZggCXU9ILDqz4pSk3+28rY7x/wRZpTB0QDj0iwz1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761259825; c=relaxed/simple;
	bh=yFUtCBh/KAEp6Qo5mys9/vY41/Tf8ItbONl180fI+Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aiwMt5rtBt9FQdgmC9JY2pDLCe3B5UpKua9bvs/je4wPolzJeSUKyyPM01FJQRI+eKecJ79BfhqwdcamVDwZcmghKvEF4V50y/aJDmasEXOxLHkRKRCbTUSl47SHtfxuRmbZQ68rdGFys0A4A5LAOFlEpsZ8YChqcqO87xoTiqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BHlRPBWO; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BHlRPBWO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761259824; x=1792795824;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yFUtCBh/KAEp6Qo5mys9/vY41/Tf8ItbONl180fI+Sk=;
  b=BHlRPBWOGFrdDtk/xfcmVXt90PokHPn+6ysY2mspPK9XmJZEiaxRAzqa
   Nk89iZS4e9wUeWct3SOwcMerUxzt9JqbBseuv4JfCUnL/hNTf8crUz8fr
   nmFN3lI5v1JGyKgVtHPh605b5PE0D+YR+8mHy0XikcFmwShwGmIEPswtI
   FmYyk+G+5gWML/LnbAxYfybHlCuFAIaoLuFdYQRZ4KB1abwC4nq/GlJHo
   1csevCkLeVX/EoHIJuIj6NiXbruWckHh6R5TNhIu5wJ+jdugHl3W8J4K4
   P85xpce7RH8bYmNnBxtIUwLu4XaI5kP4iduhLq00WZr3YYq2SUDAopOz4
   w==;
X-CSE-ConnectionGUID: LBBpiZreRk+kDlAEcU5kfw==
X-CSE-MsgGUID: 5/PEnjQWTpa6HI7C/MnbLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81069038"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="81069038"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:50:23 -0700
X-CSE-ConnectionGUID: l7rauWHASX6rD6nc4jT3RA==
X-CSE-MsgGUID: H0GpdOYXQjuTbMz67IdnDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="183457405"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.4]) ([10.125.109.4])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:50:23 -0700
Message-ID: <3613eee7-d570-45b5-8ba3-82119d63568a@intel.com>
Date: Thu, 23 Oct 2025 15:50:22 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 2/7] libcxl: Add CXL protocol errors
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-3-Benjamin.Cheatham@amd.com>
 <bd50a175-0e4b-4c65-910d-df2d1ae52be8@intel.com>
 <d89d9d02-6b9a-4818-9f27-58f565237fe6@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <d89d9d02-6b9a-4818-9f27-58f565237fe6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/23/25 1:15 PM, Cheatham, Benjamin wrote:
> On 10/21/2025 6:15 PM, Dave Jiang wrote:
>>
>>
>> On 10/21/25 11:31 AM, Ben Cheatham wrote:
>>> The v6.11 Linux kernel adds CXL protocl (CXL.cache & CXL.mem) error
>>> injection for platforms that implement the error types as according to
>>> the v6.5+ ACPI specification. The interface for injecting these errors
>>> are provided by the kernel under the CXL debugfs. The relevant files in
>>> the interface are the einj_types file, which provides the available CXL
>>> error types for injection, and the einj_inject file, which injects the
>>> error into a CXL VH root port or CXL RCH downstream port.
>>>
>>> Add a library API to retrieve the CXL error types and inject them. This
>>> API will be used in a later commit by the 'cxl-inject-error' and
>>> 'cxl-list' commands.
>>>
>>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>>> ---
>>>  cxl/lib/libcxl.c   | 174 +++++++++++++++++++++++++++++++++++++++++++++
>>>  cxl/lib/libcxl.sym |   5 ++
>>>  cxl/lib/private.h  |  14 ++++
>>>  cxl/libcxl.h       |  13 ++++
>>>  4 files changed, 206 insertions(+)
>>>
>>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>>> index ea5831f..9486b0f 100644
>>> --- a/cxl/lib/libcxl.c
>>> +++ b/cxl/lib/libcxl.c
>>> @@ -46,11 +46,13 @@ struct cxl_ctx {
>>>  	void *userdata;
>>>  	int memdevs_init;
>>>  	int buses_init;
>>> +	int perrors_init;
>>>  	unsigned long timeout;
>>>  	struct udev *udev;
>>>  	struct udev_queue *udev_queue;
>>>  	struct list_head memdevs;
>>>  	struct list_head buses;
>>> +	struct list_head perrors;
>>>  	struct kmod_ctx *kmod_ctx;
>>>  	struct daxctl_ctx *daxctl_ctx;
>>>  	void *private_data;
>>> @@ -205,6 +207,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
>>>  	free(bus);
>>>  }
>>>  
>>> +static void free_protocol_error(struct cxl_protocol_error *perror,
>>> +				struct list_head *head)
>>> +{
>>> +	if (head)
>>> +		list_del_from(head, &perror->list);
>>
>> I would go if (!head) return;
>>
> 
> Would that work? I think I would still need to free perror below.

Ah right you need to free that. nm

DJ> 
>>> +	free(perror);
>>> +}
>>> +
>>>  /**
>>>   * cxl_get_userdata - retrieve stored data pointer from library context
>>>   * @ctx: cxl library context
>>> @@ -328,6 +338,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
>>>  	*ctx = c;
>>>  	list_head_init(&c->memdevs);
>>>  	list_head_init(&c->buses);
>>> +	list_head_init(&c->perrors);
>>>  	c->kmod_ctx = kmod_ctx;
>>>  	c->daxctl_ctx = daxctl_ctx;
>>>  	c->udev = udev;
>>> @@ -369,6 +380,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
>>>   */
>>>  CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>>>  {
>>> +	struct cxl_protocol_error *perror, *_p;
>>>  	struct cxl_memdev *memdev, *_d;
>>>  	struct cxl_bus *bus, *_b;
>>>  
>>> @@ -384,6 +396,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>>>  	list_for_each_safe(&ctx->buses, bus, _b, port.list)
>>>  		free_bus(bus, &ctx->buses);
>>>  
>>> +	list_for_each_safe(&ctx->perrors, perror, _p, list)
>>> +		free_protocol_error(perror, &ctx->perrors);
>>> +
>>>  	udev_queue_unref(ctx->udev_queue);
>>>  	udev_unref(ctx->udev);
>>>  	kmod_unref(ctx->kmod_ctx);
>>> @@ -3416,6 +3431,165 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
>>>  	return port->decoders_committed;
>>>  }
>>>  
>>> +const struct cxl_protocol_error cxl_protocol_errors[] = {
>>> +	CXL_PROTOCOL_ERROR(12, "cache-correctable"),
>>> +	CXL_PROTOCOL_ERROR(13, "cache-uncorrectable"),
>>> +	CXL_PROTOCOL_ERROR(14, "cache-fatal"),
>>> +	CXL_PROTOCOL_ERROR(15, "mem-correctable"),
>>> +	CXL_PROTOCOL_ERROR(16, "mem-uncorrectable"),
>>> +	CXL_PROTOCOL_ERROR(17, "mem-fatal")
>>> +};
>>> +
>>> +static struct cxl_protocol_error *create_cxl_protocol_error(struct cxl_ctx *ctx,
>>> +							    unsigned long n)
>>
>> why unsigned long instead of int? are there that many errors?
>>
> 
> No there aren't. I'll change it over to unsigned int instead.
> 
>>> +{
>>> +	struct cxl_protocol_error *perror;
>>> +
>>> +	for (unsigned long i = 0; i < ARRAY_SIZE(cxl_protocol_errors); i++) {
>>> +		if (n != BIT(cxl_protocol_errors[i].num))
>>> +			continue;
>>> +
>>> +		perror = calloc(1, sizeof(*perror));
>>> +		if (!perror)
>>> +			return NULL;
>>> +
>>> +		*perror = cxl_protocol_errors[i];
>>> +		perror->ctx = ctx;
>>> +		return perror;
>>> +	}
>>> +
>>> +	return NULL;
>>> +}
>>> +
>>> +static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
>>> +{
>>> +	struct cxl_protocol_error *perror;
>>> +	char *path, *num, *save;
>>> +	unsigned long n;
>>> +	size_t path_len;
>>> +	char buf[512];
>>
>> Use SYSFS_ATTR_SIZE rather than 512
> 
> Wasn't aware of that, will do!
> 
>>
>>> +	int rc = 0;
>>> +
>>> +	if (!ctx->debugfs)
>>> +		return;
>>> +
>>> +	path_len = strlen(ctx->debugfs) + 100;
>>> +	path = calloc(1, path_len);
>>> +	if (!path)
>>> +		return;
>>> +
>>> +	snprintf(path, path_len, "%s/cxl/einj_types", ctx->debugfs);
>>> +	rc = access(path, F_OK);
>>> +	if (rc) {
>>> +		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
>> strerror(errno)? access() returns -1 and the actual error is in errno.
> 
> My bad, will update it (and elsewhere).
> 
>>> +		goto err;
>>> +	}
>>> +
>>> +	rc = sysfs_read_attr(ctx, path, buf);
>>> +	if (rc) {
>>> +		err(ctx, "failed to read %s: %s\n", path, strerror(-rc));
>>> +		goto err;
>>> +	}
>>> +
>>> +	/*
>>> +	 * The format of the output of the einj_types attr is:
>>> +	 * <Error number in hex 1> <Error name 1>
>>> +	 * <Error number in hex 2> <Error name 2>
>>> +	 * ...
>>> +	 *
>>> +	 * We only need the number, so parse that and skip the rest of
>>> +	 * the line.
>>> +	 */
>>> +	num = strtok_r(buf, " \n", &save);
>>> +	while (num) {
>>> +		n = strtoul(num, NULL, 16);
>>> +		perror = create_cxl_protocol_error(ctx, n);
>>> +		if (perror)
>>> +			list_add(&ctx->perrors, &perror->list);
>>> +
>>> +		num = strtok_r(NULL, "\n", &save);
>>> +		if (!num)
>>> +			break;
>>> +
>>> +		num = strtok_r(NULL, " \n", &save);
>>> +	}
>>> +
>>> +err:
>>> +	free(path);
>>> +}
>>> +
>>> +static void cxl_protocol_errors_init(struct cxl_ctx *ctx)
>>> +{
>>> +	if (ctx->perrors_init)
>>> +		return;
>>> +
>>> +	ctx->perrors_init = 1;
>>> +	cxl_add_protocol_errors(ctx);
>>> +}
>>> +
>>> +CXL_EXPORT struct cxl_protocol_error *
>>> +cxl_protocol_error_get_first(struct cxl_ctx *ctx)
>>> +{
>>> +	cxl_protocol_errors_init(ctx);
>>> +
>>> +	return list_top(&ctx->perrors, struct cxl_protocol_error, list);
>>> +}
>>> +
>>> +CXL_EXPORT struct cxl_protocol_error *
>>> +cxl_protocol_error_get_next(struct cxl_protocol_error *perror)
>>> +{
>>> +	struct cxl_ctx *ctx = perror->ctx;
>>> +
>>> +	return list_next(&ctx->perrors, perror, list);
>>> +}
>>> +
>>> +CXL_EXPORT unsigned long
>>> +cxl_protocol_error_get_num(struct cxl_protocol_error *perror)
>>> +{
>>> +	return perror->num;
>>> +}
>>> +
>>> +CXL_EXPORT const char *
>>> +cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
>>> +{
>>> +	return perror->string;
>>> +}
>>> +
>>> +CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
>>> +					       unsigned long error)
>>> +{
>>> +	struct cxl_ctx *ctx = dport->port->ctx;
>>> +	unsigned long path_len;
>>> +	char buf[32] = { 0 };
>>> +	char *path;
>>> +	int rc;
>>> +
>>> +	if (!ctx->debugfs)
>>> +		return -ENOENT;
>>> +
>>> +	path_len = strlen(ctx->debugfs) + 100;
>>> +	path = calloc(path_len, sizeof(char));
>>> +	if (!path)
>>> +		return -ENOMEM;
>>> +
>>> +	snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
>>> +		 cxl_dport_get_devname(dport));
>>
>> check return value
> 
> Yep, will do (elsewhere as well).
> 
>>
>>> +	rc = access(path, F_OK);
>>> +	if (rc) {
>>> +		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
>>
>> errno
>>
>>> +		free(path);
>>> +		return rc;
>> -errno instead of rc
>>
>>> +	}
>>> +
>>> +	snprintf(buf, sizeof(buf), "0x%lx\n", error);
>>
>> check return value?
>>
>> DJ
>>

