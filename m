Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1682425CE7
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807419; cv=none; b=O2j/LXhXVawJa9E3gg3ZF5iJftIcvaKCpoPau8mR+KTQOW2mxO+Nu4cEzVUy7obXnyBXmjJ0HB/ImzE3UeTYZs3FOt9jECIizMFct68lcO408wwWssbMUiD678WE7TGWT3LTr3978FHFzSRSNVatCx8o/Hm5wR212ebSGkCur0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807419; c=relaxed/simple;
	bh=DKtt+0baJLc6dnYRZLami0ExHeJiSMln5C3zBvTnCuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PRagw5n6z1876SpyP05UmGYf5qveP4MPadCpvZwIOIRX/mJzFzbb7VaH8zbl01ewqcqyF/oBwtIQO7DgS+xrbE/bnNwy4GPBPvh0mSTQU/nGPFEy8000v/B1bV5TTTuuq27KMk8ACRTk+N8t56gZ4LtMkilA39Acia0FlPwyNZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FdkcCFdt; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FdkcCFdt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779807418; x=1811343418;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DKtt+0baJLc6dnYRZLami0ExHeJiSMln5C3zBvTnCuU=;
  b=FdkcCFdtCXBxyurYlU9U8HYQrOyvSJxce4ABxPN3HsQ8A3PYWbAAFLh7
   u/dpOsXFXQ9pqg4Uh7AbIBhbafWpMDPtNYvA6WVj1/A5K/YjGkhoEWPcL
   exYyPUcfxp3i5hr5qwTIYCgJ+YJkLn5UHwo2Hai8IxLHZ0SgW3zCRqJDS
   0asbSACh66HTOAzePR7cRttfT45iMpQWjYmYWB+EivgCiWRpcriSp6AkM
   U/R/EmWI9KBhEaXLt0b2wqXcGSFa8RXjEKHDpd+EYP1Yl6ngyVRkMf2As
   i9qS2ycPP0l08/AyeVSk2JRSfmBdMj3NY8LaI4cNJBLpqVgjn5zYfFoyg
   w==;
X-CSE-ConnectionGUID: 9kdxCjeaRyW8650AdvPsWg==
X-CSE-MsgGUID: hG87tvAVQ/eLCgW3ab/SZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11797"; a="80470886"
X-IronPort-AV: E=Sophos;i="6.24,169,1774335600"; 
   d="scan'208";a="80470886"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 07:56:57 -0700
X-CSE-ConnectionGUID: p6h+xDvlR8GmyXIEAsNpWA==
X-CSE-MsgGUID: J/lIfe19Rp+VpcGQMKy5Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,169,1774335600"; 
   d="scan'208";a="247025148"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 07:56:56 -0700
Message-ID: <7eca46c6-e8b2-4555-8ae6-0a423f16d5e5@intel.com>
Date: Tue, 26 May 2026 07:56:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 2/2] daxctl, util/sysfs: skip module probe-insert
 when driver is builtin or live
To: Chen Pei <cp0613@linux.alibaba.com>, alison.schofield@intel.com,
 jic23@kernel.org, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, guoren@kernel.org
References: <20260526132251.254476-1-cp0613@linux.alibaba.com>
 <20260526132251.254476-3-cp0613@linux.alibaba.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260526132251.254476-3-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/26 6:22 AM, Chen Pei wrote:
> kmod_module_probe_insert_module() is supposed to return 0 for builtin
> modules, but only when libkmod can locate the modules.builtin index. If
> the index is missing (e.g. a kernel built with the driver as builtin
> but installed without running modules_install), libkmod falls through
> to the real init_module() syscall and returns an error such as -ENOENT,
> producing a spurious "insert failure" even though the driver is already
> part of the running kernel.
> 
> Add a helper util_kmod_skip_probe_insert() that returns true when the
> module state is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE. As an
> additional heuristic, treat KMOD_MODULE_COMING as builtin when
> /sys/module/<name>/ exists but the initstate file does not - this is
> the exact pattern libkmod's sysfs fallback emits for builtin drivers
> when the modules.builtin index is unavailable. The pattern mirrors the
> KMOD_MODULE_LIVE / KMOD_MODULE_BUILTIN check already used by ndctl's
> own test/core.c (see test/core.c:218-236).
> 
> The helper also returns the observed libkmod state via an out parameter
> so daxctl_insert_kmod_for_mode() can distinguish LIVE (retain the kmod
> reference in dev->module) from BUILTIN (drop it, since builtin drivers
> cannot be unloaded) without re-reading /sys/module/<name>/initstate.
> __util_bind() passes NULL since it does not need the state.
> 
> Reported-by: Jonathan Cameron <jic23@kernel.org>
> Suggested-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  daxctl/lib/libdaxctl.c | 22 +++++++++++++++++++--
>  util/sysfs.c           | 44 +++++++++++++++++++++++++++++++++++++++++-
>  util/sysfs.h           | 16 +++++++++++++++
>  3 files changed, 79 insertions(+), 3 deletions(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index ffc81eb..1596dc0 100644
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
> @@ -919,7 +919,25 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
>  		return rc;
>  	}
>  
> -	/* if the driver is builtin, this Just Works */
> +	/*
> +	 * If the driver is builtin or already live, skip probe-insert.
> +	 * For live modules retain the local reference in dev->module so
> +	 * the module can be unreffed alongside the device; for builtin
> +	 * drivers drop it because builtin modules cannot be unloaded.
> +	 */
> +	if (util_kmod_skip_probe_insert(kmod, ctx, &state)) {
> +		if (state == KMOD_MODULE_LIVE) {
> +			dbg(ctx, "%s: module %s already loaded\n", devname,
> +				kmod_module_get_name(kmod));
> +			dev->module = kmod;
> +		} else {
> +			dbg(ctx, "%s: module %s is builtin\n", devname,
> +				kmod_module_get_name(kmod));
> +			kmod_module_unref(kmod);
> +		}
> +		return 0;
> +	}
> +
>  	dbg(ctx, "%s inserting module: %s\n", devname,
>  		kmod_module_get_name(kmod));
>  	rc = kmod_module_probe_insert_module(kmod,
> diff --git a/util/sysfs.c b/util/sysfs.c
> index e027e38..eaf4b60 100644
> --- a/util/sysfs.c
> +++ b/util/sysfs.c
> @@ -6,6 +6,7 @@
>  #include <stdarg.h>
>  #include <unistd.h>
>  #include <errno.h>
> +#include <limits.h>
>  #include <string.h>
>  #include <ctype.h>
>  #include <fcntl.h>
> @@ -168,6 +169,47 @@ struct kmod_module *__util_modalias_to_module(struct kmod_ctx *kmod_ctx,
>  	return mod;
>  }
>  
> +bool __util_kmod_skip_probe_insert(struct kmod_module *module,
> +				   struct log_ctx *ctx, int *state_out)
> +{
> +	const char *name = kmod_module_get_name(module);
> +	int state = kmod_module_get_initstate(module);
> +	char path[PATH_MAX];
> +	struct stat st;
> +
> +	if (state_out)
> +		*state_out = state;
> +
> +	if (state == KMOD_MODULE_BUILTIN || state == KMOD_MODULE_LIVE)
> +		return true;
> +
> +	/*
> +	 * When modules.builtin is missing (e.g. a kernel installed
> +	 * without modules_install), libkmod's sysfs fallback returns
> +	 * KMOD_MODULE_COMING for builtin drivers because /sys/module/<name>/
> +	 * exists but the initstate file does not. Treat that pattern as
> +	 * builtin to avoid a spurious "insert failure" message.
> +	 */
> +	if (state != KMOD_MODULE_COMING)
> +		return false;
> +
> +	if (snprintf(path, sizeof(path), "/sys/module/%s/initstate", name)
> +			>= (int)sizeof(path))
> +		return false;
> +	if (stat(path, &st) == 0 || errno != ENOENT)
> +		return false;
> +
> +	if (snprintf(path, sizeof(path), "/sys/module/%s", name)
> +			>= (int)sizeof(path))
> +		return false;
> +	if (stat(path, &st) != 0 || !S_ISDIR(st.st_mode))
> +		return false;
> +
> +	log_dbg(ctx, "module %s appears builtin (no modules.builtin index)\n",
> +			name);
> +	return true;
> +}
> +
>  int __util_bind(const char *devname, struct kmod_module *module,
>  		const char *bus, struct log_ctx *ctx)
>  {
> @@ -182,7 +224,7 @@ int __util_bind(const char *devname, struct kmod_module *module,
>  		return -EINVAL;
>  	}
>  
> -	if (module) {
> +	if (module && !__util_kmod_skip_probe_insert(module, ctx, NULL)) {
>  		rc = kmod_module_probe_insert_module(module,
>  						     KMOD_PROBE_APPLY_BLACKLIST,
>  						     NULL, NULL, NULL, NULL);
> diff --git a/util/sysfs.h b/util/sysfs.h
> index 4c95c70..e4f6115 100644
> --- a/util/sysfs.h
> +++ b/util/sysfs.h
> @@ -3,6 +3,7 @@
>  #ifndef __UTIL_SYSFS_H__
>  #define __UTIL_SYSFS_H__
>  
> +#include <stdbool.h>
>  #include <string.h>
>  
>  typedef void *(*add_dev_fn)(void *parent, int id, const char *dev_path);
> @@ -36,6 +37,21 @@ struct kmod_module *__util_modalias_to_module(struct kmod_ctx *kmod_ctx,
>  #define util_modalias_to_module(ctx, buf)                                      \
>  	__util_modalias_to_module((ctx)->kmod_ctx, buf, &(ctx)->ctx)
>  
> +/*
> + * __util_kmod_skip_probe_insert - true when kmod_module_probe_insert_module()
> + * should be skipped because @module is already part of the running kernel:
> + * KMOD_MODULE_BUILTIN, KMOD_MODULE_LIVE, or KMOD_MODULE_COMING with
> + * /sys/module/<name>/ existing but no initstate file (the fingerprint
> + * libkmod's sysfs fallback emits for builtin drivers when the
> + * modules.builtin index is missing). If @state_out is non-NULL, the
> + * libkmod state actually observed is stored there so callers can avoid
> + * an extra kmod_module_get_initstate() call.
> + */
> +bool __util_kmod_skip_probe_insert(struct kmod_module *module,
> +				   struct log_ctx *ctx, int *state_out);
> +#define util_kmod_skip_probe_insert(m, c, s)                                   \
> +	__util_kmod_skip_probe_insert((m), &(c)->ctx, (s))
> +
>  int __util_bind(const char *devname, struct kmod_module *module, const char *bus,
>  	      struct log_ctx *ctx);
>  #define util_bind(n, m, b, c) __util_bind(n, m, b, &(c)->ctx)

