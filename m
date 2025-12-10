Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA1026299
	for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 20:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765397384; cv=none; b=r/R9OBotgrGbowYeTeI46+RyH7r1B16oqPSsfwaWVgv1ysfvsw94mm/ffRk4Z7ydaREKLWlSVfJfYquui32Q+hHT1Ohfx/vlTWIqDwR6U5wkZbOQHNQJvgTYN3ycy/VTV+1sp+4Xy0GWOkASehqzJ+WmRKxnB42w2wyF59Lik3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765397384; c=relaxed/simple;
	bh=HigPWnh9EhLBgeP0UEr9WQyqbVe0ar8AgAQ0GsNh2vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOnsnH8brV/HzZcYnrU7CiMlwxmsq8GzUUbMVKjXKDGgejtc+eqTN0YyL4fi8XL9SOVG6nonVN6aT5P1xUSt9fbYfJKM5l8YOjCLZvLHmUBEM5PySFvYykFUFyT/2s0BAO6XW+UtpP/h0GDDF/1bcmAGTco3QJRcbFif9t5dneg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dpzqp4dd; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dpzqp4dd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765397383; x=1796933383;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HigPWnh9EhLBgeP0UEr9WQyqbVe0ar8AgAQ0GsNh2vc=;
  b=dpzqp4ddlkdxeJPvsdYxdrryE6tXrM3WCqoGFttBAqXXw+MJX3LbRJUu
   ppyVi933nX291L1BCF9liwLnv1BSDfzmQ26gU30yLQ5LCTV2itpjOkScD
   aPUchpd8iubAZItRVYz6waU+NvXN+bNEqdquQ3KmIS+P+dNwhJ31zj6Se
   m7za4GO7OPGHwQN/tQs2WRAs1Gz8gt0msBI6Ov1d56ehK78GU2Nk9R1y7
   LpDZap3Ol2QqYbhZZePUzPQr3FoBZ818D7TaRk8Hs50pS7SwkChiR0uPm
   PgoqTRTaec0qaBD0NQhGpH/t8wqvKmzKjvTZhLJ+/AEpRlUhy7VQRN10i
   A==;
X-CSE-ConnectionGUID: VDXy/zmpRH+t80i9lyM5iQ==
X-CSE-MsgGUID: C4h88f11QU2wmXSrnVKCVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67264491"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67264491"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:09:43 -0800
X-CSE-ConnectionGUID: ZP/loH3pSn6L1NAX5lKL8A==
X-CSE-MsgGUID: IwW5+/eKRwOZuZfpM68kWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="196365681"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.138]) ([10.125.109.138])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:09:43 -0800
Message-ID: <607c74fa-90f4-4ff6-b7c9-c3be7b0b65d6@intel.com>
Date: Wed, 10 Dec 2025 13:09:41 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] libcxl: Add poison injection support
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-4-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209171404.64412-4-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 10:14 AM, Ben Cheatham wrote:
> Add a library API for clearing and injecting poison into a CXL memory
> device through the CXL debugfs.
> 
> This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
> commands in later commits.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/lib/libcxl.c   | 83 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  3 ++
>  cxl/libcxl.h       |  3 ++
>  3 files changed, 89 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 44d5ce2..34147b9 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -5038,3 +5038,86 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
>  {
>  	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
>  }
> +
> +CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
> +{
> +	struct cxl_ctx *ctx = memdev->ctx;
> +	size_t path_len, len;
> +	bool exists = true;
> +	char *path;
> +	int rc;
> +
> +	if (!ctx->debugfs)
> +		return false;
> +
> +	path_len = strlen(ctx->debugfs) + 100;
> +	path = calloc(path_len, sizeof(char));
> +	if (!path)
> +		return false;
> +
> +	len = snprintf(path, path_len, "%s/cxl/%s/inject_poison", ctx->debugfs,
> +		       cxl_memdev_get_devname(memdev));
> +	if (len >= path_len) {
> +		err(ctx, "%s: buffer too small\n",
> +		    cxl_memdev_get_devname(memdev));
> +		free(path);
> +		return false;
> +	}
> +
> +	rc = access(path, F_OK);
> +	if (rc)
> +		exists = false;
> +
> +	free(path);
> +	return exists;
> +}
> +
> +static int cxl_memdev_poison_action(struct cxl_memdev *memdev, size_t dpa,
> +				    bool clear)
> +{
> +	struct cxl_ctx *ctx = memdev->ctx;
> +	size_t path_len, len;
> +	char addr[32];
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
> +	len = snprintf(path, path_len, "%s/cxl/%s/%s", ctx->debugfs,
> +		       cxl_memdev_get_devname(memdev),
> +		       clear ? "clear_poison" : "inject_poison");
> +	if (len >= path_len) {
> +		err(ctx, "%s: buffer too small\n",
> +		    cxl_memdev_get_devname(memdev));
> +		free(path);
> +		return -ENOMEM;
> +	}
> +
> +	len = snprintf(addr, sizeof(addr), "0x%lx\n", dpa);
> +	if (len >= sizeof(addr)) {
> +		err(ctx, "%s: buffer too small\n",
> +		    cxl_memdev_get_devname(memdev));
> +		free(path);
> +		return -ENOMEM;
> +	}
> +
> +	rc = sysfs_write_attr(ctx, path, addr);
> +	free(path);
> +	return rc;
> +}
> +
> +CXL_EXPORT int cxl_memdev_inject_poison(struct cxl_memdev *memdev, size_t addr)
> +{
> +	return cxl_memdev_poison_action(memdev, addr, false);
> +}
> +
> +CXL_EXPORT int cxl_memdev_clear_poison(struct cxl_memdev *memdev, size_t addr)
> +{
> +	return cxl_memdev_poison_action(memdev, addr, true);
> +}
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 02d5119..3bce60d 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -304,4 +304,7 @@ global:
>  	cxl_protocol_error_get_num;
>  	cxl_protocol_error_get_str;
>  	cxl_dport_protocol_error_inject;
> +	cxl_memdev_has_poison_injection;
> +	cxl_memdev_inject_poison;
> +	cxl_memdev_clear_poison;
>  } LIBCXL_9;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index adb5716..56cba8f 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -105,6 +105,9 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
>  		size_t offset);
>  int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
>  		size_t offset);
> +bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev);
> +int cxl_memdev_inject_poison(struct cxl_memdev *memdev, size_t dpa);
> +int cxl_memdev_clear_poison(struct cxl_memdev *memdev, size_t dpa);
>  struct cxl_cmd *cxl_cmd_new_get_fw_info(struct cxl_memdev *memdev);
>  unsigned int cxl_cmd_fw_info_get_num_slots(struct cxl_cmd *cmd);
>  unsigned int cxl_cmd_fw_info_get_active_slot(struct cxl_cmd *cmd);

