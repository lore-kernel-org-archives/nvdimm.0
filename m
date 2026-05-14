Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFA133F5BF
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 17:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778779061; cv=none; b=hPgEuAvvII/F7cdf7T3kMrwxcWLLREUU+Fb4owLNCp8yHX4fIHddaZ+DnJh/XOHQEOTx0j3Sw050RNOsC+GUX9nrIqVBRDxKw18HgblXINiyXjAi/hvuFsc6K9E1a3eztlRfXze9wuokyGn2GNxlxw2IHp6g7iYW9Uz+Amu/hnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778779061; c=relaxed/simple;
	bh=8CO1iQwewkQXJns/rjcz6gE30TpmsXOilUGiO+J6az8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tdqcko/HpV3oh3TImNc2ifNax2+LWE6VQJlyFOfV42Z0imTtGn5kGQVYkr+vHuDa2Eli2DLMie8j2CkN2ZQIoihVK54/AeJBCouOKHXt0BhuUoLdbbE6QwdI6CB0RRirvGqQ+8GDLcYjfz0liURhU27v1+VMvxKjfpMEYsuXmyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A32jhpR4; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A32jhpR4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778779059; x=1810315059;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8CO1iQwewkQXJns/rjcz6gE30TpmsXOilUGiO+J6az8=;
  b=A32jhpR4ThBXjyPuEge6VOilpnCIhf7AMno9Ov1C8h8qL1QjaAVhI+un
   WXQZEP0L2cCJ0d1sUgXIneA2likG8xX02p0RquDpGgLFsLYHfaPq8Ekxk
   0eYNolG3xbl5b11A/ITdOkNxCgUocjMqaZJUuD++dV47LLkcJjA3OKyZf
   5dKWlHgrMfcJSDoY5xNsTk/pjCofEG9ZlB9v7Qms6SrTKK12eRiRCujvg
   WJjM00XzH2FlhyFebPMCIucpx+Swr9hm0faLEU6XcZtT7w5Il5Mn4Q1g2
   +FIHjJx0wIlnnnNNcnwnLRMXXd6nFSu67zJV8PcZbLItxu/KSw2Xowk55
   g==;
X-CSE-ConnectionGUID: TEM8e3XkSYyEe2Du2+S+Jw==
X-CSE-MsgGUID: thT90WXcQRCc9I0VHVrDNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="79442417"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="79442417"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 10:17:39 -0700
X-CSE-ConnectionGUID: OfS3zi3XT0uSUSeqK4Rgog==
X-CSE-MsgGUID: X7/IihoeRTKmh0LjSlg45A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="235396367"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.108.122]) ([10.125.108.122])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 10:17:38 -0700
Message-ID: <cbe4a705-9d87-44d6-9578-7c31ae891765@intel.com>
Date: Thu, 14 May 2026 10:17:37 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert
 when driver is builtin or live
To: Chen Pei <cp0613@linux.alibaba.com>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, guoren@kernel.org
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
 <20260514063234.86439-3-cp0613@linux.alibaba.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260514063234.86439-3-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/13/26 11:32 PM, Chen Pei wrote:
> kmod_module_probe_insert_module() is supposed to return 0 for builtin
> modules, but only when libkmod can locate the modules.builtin index. If
> the index is missing or out of sync, libkmod falls through to the real
> init_module() syscall and returns an error such as -ENOENT, producing a
> spurious "insert failure" even though the driver is already part of the
> running kernel.
> 
> Pre-check kmod_module_get_initstate() and short-circuit when the module
> is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE, matching the pattern used by
> ndctl's own test/core.c.
> 
> For builtin modules the local kmod reference is dropped because builtin
> drivers cannot be unloaded; for live modules the reference is retained
> in dev->module, matching the post-probe-success behavior.
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  daxctl/lib/libdaxctl.c | 18 ++++++++++++++++--
>  util/sysfs.c           | 17 +++++++++++------
>  2 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index ffc81eb..42bfc39 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -910,7 +910,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
>  	struct kmod_module *kmod;
> -	int rc;
> +	int state, rc;
>  
>  	rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
>  	if (rc < 0) {
> @@ -919,7 +919,21 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
>  		return rc;
>  	}
>  
> -	/* if the driver is builtin, this Just Works */
> +	/* If the driver is builtin or already live, skip probe-insert. */
> +	state = kmod_module_get_initstate(kmod);
> +	if (state == KMOD_MODULE_BUILTIN) {
> +		dbg(ctx, "%s: module %s is builtin\n", devname,
> +			kmod_module_get_name(kmod));
> +		kmod_module_unref(kmod);
> +		return 0;
> +	}
> +	if (state == KMOD_MODULE_LIVE) {
> +		dbg(ctx, "%s: module %s already loaded\n", devname,
> +			kmod_module_get_name(kmod));
> +		dev->module = kmod;
> +		return 0;
> +	}
> +
>  	dbg(ctx, "%s inserting module: %s\n", devname,
>  		kmod_module_get_name(kmod));
>  	rc = kmod_module_probe_insert_module(kmod,
> diff --git a/util/sysfs.c b/util/sysfs.c
> index e027e38..641b86d 100644
> --- a/util/sysfs.c
> +++ b/util/sysfs.c
> @@ -183,12 +183,17 @@ int __util_bind(const char *devname, struct kmod_module *module,
>  	}
>  
>  	if (module) {
> -		rc = kmod_module_probe_insert_module(module,
> -						     KMOD_PROBE_APPLY_BLACKLIST,
> -						     NULL, NULL, NULL, NULL);
> -		if (rc < 0) {
> -			log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> -			return rc;
> +		/* Skip probe-insert when the module is already builtin or live. */
> +		int state = kmod_module_get_initstate(module);
> +
> +		if (state != KMOD_MODULE_BUILTIN && state != KMOD_MODULE_LIVE) {
> +			rc = kmod_module_probe_insert_module(module,
> +							     KMOD_PROBE_APPLY_BLACKLIST,
> +							     NULL, NULL, NULL, NULL);
> +			if (rc < 0) {
> +				log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> +				return rc;
> +			}
>  		}
>  	}
>  

