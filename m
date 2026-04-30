Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451743382FC
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 16:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566034; cv=none; b=CdR+NhueVJgLli9h8aALfz5adM9wOJYL9ZDFdy01WPUu986BlM0RfKHxSd3sBVCQrb9hcT/ovaxxN8kw+yHPJ0sjWNt+LN0XzyMon02/ZN09nz79hJNo/PV4BWaGtZ+vF31SYS00UCYf8qDlsjC3bzZMKJc/1zp4y6z6ZteC9wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566034; c=relaxed/simple;
	bh=heVPE5FfsxMVMMyG3SD2jcFpLf5zLZ1lhUnxbpovDU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rVJGL5FyCRkrZJvAKDvlv5JVUNuhRMoa6FlfltoBF8ZYHqTEWaFheOY4S1RRBGNvqZ3uTCEzBsh9KJTBLgYkLCPefm5fEncWf11ukuk4BnWQdOYLvvMA8LxsY068Fah/klxq7USdvH0UAxdSdAmtS+nvPkTKK49SmU9Ny8mIhFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TN1UPGZg; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TN1UPGZg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777566034; x=1809102034;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=heVPE5FfsxMVMMyG3SD2jcFpLf5zLZ1lhUnxbpovDU0=;
  b=TN1UPGZg25CTrZbKBi1RF98wTaPNCkBiNu9RM6o7ecSkkIi5kTQciVpk
   4DYECx5BFIYg3hK5CenZUUGrCytfSmISHlkUzJhcRowKEBdhXSf3Sh17M
   aGSSVuEtZBzUuCouKWV/pe6hGYIELNvPBn6GiSNq5irbCqTU/NFFtt8ge
   PEvkAeUtvIj2TKo4zX6ecaCwsbNAByQbDe9dsWFu1X7BlqaJYmLdQWxoJ
   Z6c6Vzxsep8Qrq1RKu0JNNLPX5dpjuhRXvBkEes3t6qLitHRMnKyDqAQI
   sxOUxNAT1ldWDMm6xCDO3d60XctWvfv9Kakkin+dFH7AaGbgsGU+/2KsX
   Q==;
X-CSE-ConnectionGUID: IPaTHPTPQtuVnQnsxx4hfw==
X-CSE-MsgGUID: /D6hJl04TvOgY/1EguBCjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="78419595"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="78419595"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:20:32 -0700
X-CSE-ConnectionGUID: iDNnYqA4Q5e/IDefCenemw==
X-CSE-MsgGUID: 4l3NcFw4RyqzlRC0vCQRgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="272732800"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.99]) ([10.125.109.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:20:31 -0700
Message-ID: <b9812a61-ca8d-4522-8075-ab6bf8671a40@intel.com>
Date: Thu, 30 Apr 2026 09:20:29 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 1/2] daxctl: Add support for famfs mode
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 John Groves <jgroves@fastmail.com>, Dan Williams <djbw@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "dev.srinivasulu@gmail.com" <dev.srinivasulu@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
References: <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
 <20260430153405.84164-1-john@jagalactic.com>
 <0100019ddf06b207-eaf8cb8a-066e-4642-8947-effdb4848c20-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019ddf06b207-eaf8cb8a-066e-4642-8947-effdb4848c20-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/30/26 8:34 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
> (drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means
> it is in famfs mode.
> 
> A test for this functionality is added in the next commit.
> 
> With devdax, famfs, and system-ram modes, the previous logic that assumed
> 'not in mode X means in mode Y' needed to get slightly more complicated.
> 
> Add explicit mode detection functions:
> - daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driver
> - daxctl_dev_is_devdax_mode(): check if bound to device_dax driver
> Both delegate to a shared static helper daxctl_dev_bound_to_module() to
> avoid duplicating the driver-symlink lookup, as does the pre-existing
> daxctl_dev_is_system_ram_capable().
> 
> Update mode transition logic in device.c:
> - disable_devdax_device(): verify device is actually in devdax mode
> - disable_famfs_device(): verify device is actually in famfs mode
> - All reconfig_mode_*() functions explicitly check each mode
> - Handle unrecognized mode with an error instead of wrong assumption
> 
> Update json.c to report fsdev_dax-bound devices as 'famfs' mode.  An
> unbound device continues to be reported as 'devdax' (the legacy default
> when no driver is bound), to preserve existing behavior.
> 
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  daxctl/device.c                | 132 ++++++++++++++++++++++++++++++---
>  daxctl/json.c                  |  13 +++-
>  daxctl/lib/libdaxctl-private.h |   2 +
>  daxctl/lib/libdaxctl.c         |  39 +++++++++-
>  daxctl/lib/libdaxctl.sym       |   7 ++
>  daxctl/libdaxctl.h             |   3 +
>  6 files changed, 181 insertions(+), 15 deletions(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index a4e36b1..003609e 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -42,6 +42,7 @@ enum dev_mode {
>  	DAXCTL_DEV_MODE_UNKNOWN,
>  	DAXCTL_DEV_MODE_DEVDAX,
>  	DAXCTL_DEV_MODE_RAM,
> +	DAXCTL_DEV_MODE_FAMFS,
>  };
>  
>  struct mapping {
> @@ -471,6 +472,13 @@ static const char *parse_device_options(int argc, const char **argv,
>  					"--no-online is incompatible with --mode=devdax\n");
>  				rc =  -EINVAL;
>  			}
> +		} else if (strcmp(param.mode, "famfs") == 0) {
> +			reconfig_mode = DAXCTL_DEV_MODE_FAMFS;
> +			if (param.no_online) {
> +				fprintf(stderr,
> +					"--no-online is incompatible with --mode=famfs\n");
> +				rc =  -EINVAL;
> +			}
>  		}
>  		break;
>  	case ACTION_CREATE:
> @@ -696,8 +704,42 @@ static int disable_devdax_device(struct daxctl_dev *dev)
>  	int rc;
>  
>  	if (mem) {
> -		fprintf(stderr, "%s was already in system-ram mode\n",
> -			devname);
> +		fprintf(stderr, "%s is in system-ram mode\n", devname);
> +		return 1;
> +	}
> +	if (daxctl_dev_is_famfs_mode(dev)) {
> +		fprintf(stderr, "%s is in famfs mode\n", devname);
> +		return 1;
> +	}
> +	if (!daxctl_dev_is_devdax_mode(dev)) {
> +		fprintf(stderr, "%s is not in devdax mode\n", devname);
> +		return 1;
> +	}
> +	rc = daxctl_dev_disable(dev);
> +	if (rc) {
> +		fprintf(stderr, "%s: disable failed: %s\n",
> +			daxctl_dev_get_devname(dev), strerror(-rc));
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +static int disable_famfs_device(struct daxctl_dev *dev)
> +{
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> +	const char *devname = daxctl_dev_get_devname(dev);
> +	int rc;
> +
> +	if (mem) {
> +		fprintf(stderr, "%s is in system-ram mode\n", devname);
> +		return 1;
> +	}
> +	if (daxctl_dev_is_devdax_mode(dev)) {
> +		fprintf(stderr, "%s is in devdax mode\n", devname);
> +		return 1;
> +	}
> +	if (!daxctl_dev_is_famfs_mode(dev)) {
> +		fprintf(stderr, "%s is not in famfs mode\n", devname);
>  		return 1;
>  	}
>  	rc = daxctl_dev_disable(dev);
> @@ -711,6 +753,7 @@ static int disable_devdax_device(struct daxctl_dev *dev)
>  
>  static int reconfig_mode_system_ram(struct daxctl_dev *dev)
>  {
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	int rc, skip_enable = 0;
>  
> @@ -724,11 +767,21 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
>  	}
>  
>  	if (daxctl_dev_is_enabled(dev)) {
> -		rc = disable_devdax_device(dev);
> -		if (rc < 0)
> -			return rc;
> -		if (rc > 0)
> +		if (mem) {
> +			/* already in system-ram mode */
>  			skip_enable = 1;
> +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> +			rc = disable_famfs_device(dev);
> +			if (rc)
> +				return rc;
> +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> +			rc = disable_devdax_device(dev);
> +			if (rc)
> +				return rc;
> +		} else {
> +			fprintf(stderr, "%s: unknown mode\n", devname);
> +			return -EINVAL;
> +		}
>  	}
>  
>  	if (!skip_enable) {
> @@ -750,7 +803,7 @@ static int disable_system_ram_device(struct daxctl_dev *dev)
>  	int rc;
>  
>  	if (!mem) {
> -		fprintf(stderr, "%s was already in devdax mode\n", devname);
> +		fprintf(stderr, "%s is not in system-ram mode\n", devname);
>  		return 1;
>  	}
>  
> @@ -786,12 +839,31 @@ static int disable_system_ram_device(struct daxctl_dev *dev)
>  
>  static int reconfig_mode_devdax(struct daxctl_dev *dev)
>  {
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> +	const char *devname = daxctl_dev_get_devname(dev);
>  	int rc;
>  
>  	if (daxctl_dev_is_enabled(dev)) {
> -		rc = disable_system_ram_device(dev);
> -		if (rc)
> -			return rc;
> +		if (mem) {
> +			rc = disable_system_ram_device(dev);
> +			if (rc)
> +				return rc;
> +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> +			rc = disable_famfs_device(dev);
> +			if (rc)
> +				return rc;
> +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> +			/* already in devdax mode, just re-enable */
> +			rc = daxctl_dev_disable(dev);
> +			if (rc) {
> +				fprintf(stderr, "%s: disable failed: %s\n",
> +					devname, strerror(-rc));
> +				return rc;
> +			}
> +		} else {
> +			fprintf(stderr, "%s: unknown mode\n", devname);
> +			return -EINVAL;
> +		}
>  	}
>  
>  	rc = daxctl_dev_enable_devdax(dev);
> @@ -801,6 +873,43 @@ static int reconfig_mode_devdax(struct daxctl_dev *dev)
>  	return 0;
>  }
>  
> +static int reconfig_mode_famfs(struct daxctl_dev *dev)
> +{
> +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> +	const char *devname = daxctl_dev_get_devname(dev);
> +	int rc;
> +
> +	if (daxctl_dev_is_enabled(dev)) {
> +		if (mem) {
> +			fprintf(stderr,
> +				"%s is in system-ram mode; must be in devdax mode to convert to famfs\n",
> +				devname);
> +			return -EINVAL;
> +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> +			/* already in famfs mode, just re-enable */
> +			rc = daxctl_dev_disable(dev);
> +			if (rc) {
> +				fprintf(stderr, "%s: disable failed: %s\n",
> +					devname, strerror(-rc));
> +				return rc;
> +			}
> +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> +			rc = disable_devdax_device(dev);
> +			if (rc)
> +				return rc;
> +		} else {
> +			fprintf(stderr, "%s: unknown mode\n", devname);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	rc = daxctl_dev_enable_famfs(dev);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
>  static int do_create(struct daxctl_region *region, long long val,
>  		     struct json_object **jdevs)
>  {
> @@ -887,6 +996,9 @@ static int do_reconfig(struct daxctl_dev *dev, enum dev_mode mode,
>  	case DAXCTL_DEV_MODE_DEVDAX:
>  		rc = reconfig_mode_devdax(dev);
>  		break;
> +	case DAXCTL_DEV_MODE_FAMFS:
> +		rc = reconfig_mode_famfs(dev);
> +		break;
>  	default:
>  		fprintf(stderr, "%s: unknown mode requested: %d\n",
>  			devname, mode);
> diff --git a/daxctl/json.c b/daxctl/json.c
> index 3cbce9d..2a4b12c 100644
> --- a/daxctl/json.c
> +++ b/daxctl/json.c
> @@ -48,8 +48,19 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
>  
>  	if (mem)
>  		jobj = json_object_new_string("system-ram");
> -	else
> +	else if (daxctl_dev_is_famfs_mode(dev))
> +		jobj = json_object_new_string("famfs");
> +	else if (daxctl_dev_is_devdax_mode(dev))
>  		jobj = json_object_new_string("devdax");
> +	else {
> +		/* Legacy condition; if a daxdev is not in any "mode", that
> +		 * means no driver is bound. We report that as a disabled
> +		 * device in devdax mode. (the disabled modifier is added later
> +		 * in this function if applicable)
> +		 */
> +		jobj = json_object_new_string("devdax");
> +	}
> +
>  	if (jobj)
>  		json_object_object_add(jdev, "mode", jobj);
>  
> diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
> index ae45311..0bb73e8 100644
> --- a/daxctl/lib/libdaxctl-private.h
> +++ b/daxctl/lib/libdaxctl-private.h
> @@ -21,12 +21,14 @@ static const char *dax_subsystems[] = {
>  enum daxctl_dev_mode {
>  	DAXCTL_DEV_MODE_DEVDAX = 0,
>  	DAXCTL_DEV_MODE_RAM,
> +	DAXCTL_DEV_MODE_FAMFS,
>  	DAXCTL_DEV_MODE_END,
>  };
>  
>  static const char *dax_modules[] = {
>  	[DAXCTL_DEV_MODE_DEVDAX] = "device_dax",
>  	[DAXCTL_DEV_MODE_RAM] = "kmem",
> +	[DAXCTL_DEV_MODE_FAMFS] = "fsdev_dax",
>  };
>  
>  enum memory_op {
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 02ae7e5..33121dc 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -385,13 +385,13 @@ static bool device_model_is_dax_bus(struct daxctl_dev *dev)
>  	return false;
>  }
>  
> -DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
> +static int daxctl_dev_bound_to_module(struct daxctl_dev *dev, const char *mod_name)
>  {
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
>  	const char *mod_base;
>  	char *mod_path;
> -	char path[200];
> +	char path[PATH_MAX];
>  	const int len = sizeof(path);
>  
>  	if (!device_model_is_dax_bus(dev))
> @@ -406,11 +406,13 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
>  	}
>  
>  	mod_path = realpath(path, NULL);
> -	if (!mod_path)
> +	if (!mod_path) {
> +		dbg(ctx, "%s: realpath failed for driver link\n", devname);
>  		return false;
> +	}
>  
>  	mod_base = path_basename(mod_path);
> -	if (strcmp(mod_base, dax_modules[DAXCTL_DEV_MODE_RAM]) == 0) {
> +	if (strcmp(mod_base, mod_name) == 0) {
>  		free(mod_path);
>  		return true;
>  	}
> @@ -419,6 +421,30 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
>  	return false;
>  }
>  
> +DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_RAM]);
> +}
> +
> +/*
> + * Check if device is currently in famfs mode (bound to fsdev_dax driver).
> + * Returns false for disabled devices: the DAX bus does not retain the previous
> + * driver binding after unbind, so mode cannot be determined without a driver.
> + */
> +DAXCTL_EXPORT int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_FAMFS]);
> +}
> +
> +/*
> + * Check if device is currently in devdax mode (bound to device_dax driver).
> + * Returns false for disabled devices; see daxctl_dev_is_famfs_mode().
> + */
> +DAXCTL_EXPORT int daxctl_dev_is_devdax_mode(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_DEVDAX]);
> +}
> +
>  /*
>   * This checks for the device to be in system-ram mode, so calling
>   * daxctl_dev_get_memory() on a devdax mode device will always return NULL.
> @@ -983,6 +1009,11 @@ DAXCTL_EXPORT int daxctl_dev_enable_ram(struct daxctl_dev *dev)
>  	return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_RAM);
>  }
>  
> +DAXCTL_EXPORT int daxctl_dev_enable_famfs(struct daxctl_dev *dev)
> +{
> +	return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_FAMFS);
> +}
> +
>  DAXCTL_EXPORT int daxctl_dev_disable(struct daxctl_dev *dev)
>  {
>  	const char *devname = daxctl_dev_get_devname(dev);
> diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
> index 3098811..2a812c6 100644
> --- a/daxctl/lib/libdaxctl.sym
> +++ b/daxctl/lib/libdaxctl.sym
> @@ -104,3 +104,10 @@ LIBDAXCTL_10 {
>  global:
>  	daxctl_dev_is_system_ram_capable;
>  } LIBDAXCTL_9;
> +
> +LIBDAXCTL_11 {
> +global:
> +	daxctl_dev_enable_famfs;
> +	daxctl_dev_is_famfs_mode;
> +	daxctl_dev_is_devdax_mode;
> +} LIBDAXCTL_10;
> diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
> index 53c6bbd..84fcdb4 100644
> --- a/daxctl/libdaxctl.h
> +++ b/daxctl/libdaxctl.h
> @@ -72,12 +72,15 @@ int daxctl_dev_is_enabled(struct daxctl_dev *dev);
>  int daxctl_dev_disable(struct daxctl_dev *dev);
>  int daxctl_dev_enable_devdax(struct daxctl_dev *dev);
>  int daxctl_dev_enable_ram(struct daxctl_dev *dev);
> +int daxctl_dev_enable_famfs(struct daxctl_dev *dev);
>  int daxctl_dev_get_target_node(struct daxctl_dev *dev);
>  int daxctl_dev_will_auto_online_memory(struct daxctl_dev *dev);
>  int daxctl_dev_has_online_memory(struct daxctl_dev *dev);
>  
>  struct daxctl_memory;
>  int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev);
> +int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev);
> +int daxctl_dev_is_devdax_mode(struct daxctl_dev *dev);
>  struct daxctl_memory *daxctl_dev_get_memory(struct daxctl_dev *dev);
>  struct daxctl_dev *daxctl_memory_get_dev(struct daxctl_memory *mem);
>  const char *daxctl_memory_get_node_path(struct daxctl_memory *mem);

