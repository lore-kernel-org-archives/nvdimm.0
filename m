Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795A728D83D
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090293; cv=none; b=c4VUQ/0cfhT5/BYsuCGQGhjkhnHg7gt8RG04rXCH/bTFfufkhKS/rp3TbRQmAr2iB2gIG6rnmTAKzMbLMxjiIW4TmWD5x6+zF9P4lQ/1uMHBfDk5A4KpT02SgRf7A0eCfo4nMh/YPuiDDwyr17No8hj66vbgR/0h/d0XF05qe40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090293; c=relaxed/simple;
	bh=qezin9qfpUOS7iqA5K8z5H3JR61M5maoDKMujTe1kLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HwJHOrtSRpRU/XoYdD1ZXHSHn5g1WSBeYBkC1tuetaSjZizBAC2cZu1lQWdJyjWH/kaaEys131K/YmGbk/xien5W8lawl0FcPnQNU8zYI7nDxnAUUOxvIHY8rTRITBZ3fGCcCrRxuUadpl6WZZ6x3LU3bMTbbOHKG47KytIevHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qa6/ZHUY; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qa6/ZHUY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761090292; x=1792626292;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qezin9qfpUOS7iqA5K8z5H3JR61M5maoDKMujTe1kLw=;
  b=Qa6/ZHUYa2I6docYi/VDBhR7bNxNrOZ3VFItH8Ch3H82PycHr0ZjRXVK
   h1pqAIcAYR2HpLOj6cJgEkjzXjpBeI4FQ3wJwjiDdLD7ySy/7ttwRMqSZ
   9CQk0T/m4zg2yYqfNHjou8EZkWC0mWe+C7J4Ze7XK2D9q7/bF/PSFplMg
   uQ0dAWboDqeLNUR/DAhZYnkDEZuisYc/b8OThq83jRWfejSJTkC4Ln02H
   4Zsgf/Z9Cy8eXcSjc08+q8uZrJ8Lhu6IYQcsSz1xBT55xIJFgBf6dcOAw
   mfVuJTkOthw/j8yIeVa02qliWIKbyz0bY1eaKN7Mriohx4Dpx8Nz5J+cf
   w==;
X-CSE-ConnectionGUID: JQxNx7GBQ92I7u0NUgFC1Q==
X-CSE-MsgGUID: KBT357izStS3qnOxMuRO2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="50803821"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="50803821"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 16:44:51 -0700
X-CSE-ConnectionGUID: OylGxD/rQ3GXXJWHr2IJZw==
X-CSE-MsgGUID: YVlZ3BYmSemelRPkoArJqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="188123793"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.108.169]) ([10.125.108.169])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 16:44:50 -0700
Message-ID: <4c452ff5-bcd3-4a3e-9fc1-04fb741f9e14@intel.com>
Date: Tue, 21 Oct 2025 16:44:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 3/7] libcxl: Add poison injection support
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-4-Benjamin.Cheatham@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251021183124.2311-4-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/25 11:31 AM, Ben Cheatham wrote:
> Add a library API for clearing and injecting poison into a CXL memory
> device through the CXL debugfs.
> 
> This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
> commands in later commits.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> ---
>  cxl/lib/libcxl.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  3 +++
>  cxl/libcxl.h       |  3 +++
>  3 files changed, 66 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 9486b0f..9d4bd80 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -5019,3 +5019,63 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
>  {
>  	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
>  }
> +
> +CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
> +{
> +	struct cxl_ctx *ctx = memdev->ctx;
> +	size_t path_len;
> +	bool exists;
> +	char *path;
> +
> +	if (!ctx->debugfs)
> +		return false;
> +
> +	path_len = strlen(ctx->debugfs) + 100;
> +	path = calloc(path_len, sizeof(char));
> +	if (!path)
> +		return false;
> +
> +	snprintf(path, path_len, "%s/cxl/%s/inject_poison", ctx->debugfs,
> +		 cxl_memdev_get_devname(memdev));

check return value

> +	exists = access(path, F_OK) == 0;

While this works, it is more readable this way:

	exists = true;
	...
	rc = access(path, F_OK);
	if (rc)
		exists = false;> +
> +	free(path);
> +	return exists;
> +}
> +
> +static int cxl_memdev_poison_action(struct cxl_memdev *memdev, size_t dpa,
> +				    bool clear)
> +{
> +	struct cxl_ctx *ctx = memdev->ctx;
> +	size_t path_len;
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
> +	snprintf(path, path_len, "%s/cxl/%s/%s", ctx->debugfs,
> +		 cxl_memdev_get_devname(memdev),
> +		 clear ? "clear_poison" : "inject_poison");
> +	snprintf(addr, 32, "0x%lx\n", dpa);

check return values for both snprintf()

DJ

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
> index 9026e05..3b51d61 100644
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

