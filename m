Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F131A230BEC
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 22:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761087305; cv=none; b=WODY3D5PmSm/6KoJAVkoVB4bdns3281LVRDT484bYkGBeoTCwcEDumP8unSQhoERqpCd7sjkn22F1okesMYv7tHA684V8HalWsmWZyVNKQ5wyUMLlJGsNYsa9upeoDVlRxTCmS4tWeb4Kd2nsd70CTfVYueEbGbUXiSN6PSYR0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761087305; c=relaxed/simple;
	bh=yl3sFk8HTYRypSnT9hnTAm8g3J2LD33iA5XdgVOEzwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NgFAwDCbtOXjJ4ZBndM7iODrzB6XPKki9R59GjqTTDR0HGudxChCsk+N0tYpFjjEeaytUX6YOuFljvAfyOd9l5Dyv6XDWEkGVsUiGBPYDsuva/7gn2nINCyneEBOxz1fjRzdtK7T3lSs12dn2VckMyozec9BkWmfAAs7YSfgxYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nihr8lZO; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nihr8lZO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761087304; x=1792623304;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yl3sFk8HTYRypSnT9hnTAm8g3J2LD33iA5XdgVOEzwM=;
  b=nihr8lZOjIkiH58g07NPAPcAcJUHqZS/v3+cNTEafNBdRxHgoB4M1rQe
   OMhpDZEyutftT0LFIuSlzgTF3j9PradNDJsQcgi7vw6lwjnQOFFjAN7w1
   X9RaICNrJOEBU4zNMUok5TjvKUyJYyQPaW4p8fMavu7TgPJ9HsNsoav7o
   VZwXHBYFrnlAXlFSVv+rMC7lYGJ9dXvGeNfRgr1qikmtQqYG4XfIfzhFe
   p0/hbbsv00n/i27o48J6xPhGbzSTqD1NdfII2bUo4o5En3CsYp8Mwns/L
   O3D7LVbV052FBM4v5cC/JGOlzO/XkrewO8CwO0WVTFLXRIBT9URkFOMRp
   g==;
X-CSE-ConnectionGUID: t26LVy+GSI+PL8Y3JYXtWg==
X-CSE-MsgGUID: +Iu1if+ZRwCvhGoCTvpA8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63129510"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63129510"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:55:04 -0700
X-CSE-ConnectionGUID: RoI2ip7nTlOqBr9HrkeA2Q==
X-CSE-MsgGUID: 3FX18rbsRVicq1sn7/e1hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="188114451"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.108.169]) ([10.125.108.169])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:55:03 -0700
Message-ID: <fe8ab195-57bc-4569-bf0f-c8c2a93bc435@intel.com>
Date: Tue, 21 Oct 2025 15:55:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 1/7] libcxl: Add debugfs path to CXL context
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-2-Benjamin.Cheatham@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251021183124.2311-2-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/25 11:31 AM, Ben Cheatham wrote:
> Find the CXL debugfs mount point and add it to the CXL library context.
> This will be used by poison and procotol error library functions to
> access the information presented by the filesystem.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> ---
>  cxl/lib/libcxl.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index cafde1c..ea5831f 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -54,6 +54,7 @@ struct cxl_ctx {
>  	struct kmod_ctx *kmod_ctx;
>  	struct daxctl_ctx *daxctl_ctx;
>  	void *private_data;
> +	const char *debugfs;
>  };
>  
>  static void free_pmem(struct cxl_pmem *pmem)
> @@ -240,6 +241,43 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
>  	return ctx->private_data;
>  }
>  
> +static char *get_debugfs_dir(void)

const char *?


Also maybe get_debugfs_dir_path()

> +{
> +	char *dev, *dir, *type, *ret = NULL;

'debugfs_dir' rather than 'ret' would be clearer to read.

DJ

> +	char line[PATH_MAX + 256 + 1];
> +	FILE *fp;
> +
> +	fp = fopen("/proc/mounts", "r");
> +	if (!fp)
> +		return ret;
> +
> +	while (fgets(line, sizeof(line), fp)) {
> +		dev = strtok(line, " \t");
> +		if (!dev)
> +			break;
> +
> +		dir = strtok(NULL, " \t");
> +		if (!dir)
> +			break;
> +
> +		type = strtok(NULL, " \t");
> +		if (!type)
> +			break;
> +
> +		if (!strcmp(type, "debugfs")) {
> +			ret = calloc(strlen(dir) + 1, 1);
> +			if (!ret)
> +				break;
> +
> +			strcpy(ret, dir);
> +			break;
> +		}
> +	}
> +
> +	fclose(fp);
> +	return ret;
> +}
> +
>  /**
>   * cxl_new - instantiate a new library context
>   * @ctx: context to establish
> @@ -295,6 +333,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
>  	c->udev = udev;
>  	c->udev_queue = udev_queue;
>  	c->timeout = 5000;
> +	c->debugfs = get_debugfs_dir();
>  
>  	return 0;
>  
> @@ -350,6 +389,7 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>  	kmod_unref(ctx->kmod_ctx);
>  	daxctl_unref(ctx->daxctl_ctx);
>  	info(ctx, "context %p released\n", ctx);
> +	free((void *)ctx->debugfs);
>  	free(ctx);
>  }
>  


