Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316362;
	b=z8EiotHIeAKpWMXpfZe8QHBEg8XyXmVu/TMIb3k3GviM4FztNCanhj5rIzAFeerdgeI3
	 pZqslN/Rej4KuWB3UcsHBx1Heu8gfZw+ib8aOPxkPjnHeeRt91Eyra2ExLNLqi/rJbOhh
	 cuY8cQ1kjMRXkyVjGIy1tQ4VsPInmgjuF6+g9CSS+G+F76MfkheeOSCBeFtsm6Mm6biql
	 kcEqfexGkCOS7ohZt/yybscScNfjhTabOCOtJ7w7YMEzSRIWskVas/iwN2w1lj9J1odnm
	 rtdJn1DVoSTcSRCa3mko3V+mm4//ChvImmH8L4N0PQNSFXbbdMQw9yqZ9hB9nRTTo5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316362;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2GKDMvDpti7ogQfsUpI0XQxRzogq/+Pxx/2i1iX462o=;
	b=YqhpqXkzz3lxST1MiWkLSdEMR4s6cbnNP2z7P9zsGCy+eZ0DzSR8V4zqZWI+hCa/k3qy
	 VEp4PPW0wc6QZUj0GvQdCf9KUNXSObF2jNsIYfdv2/hZZJLKMtPl1d3bjVNKp6hHsHerL
	 Rwt55UqBW3zFaOXDglshhMde7y67gI8uFRx4W6CssWbGjFFzuvHDTGpvd5POSmmZwfR4p
	 O8MtgwKQqzFVEUu3y3zjien3Ws1SLWJf95sPzHMOzORNFzfZA4BIqZt1pbrZM40igaVdJ
	 3mXHGgxReNrYFmpfgEhJ2LJ2X+QFmREG8pB/oSJ13YmEDP3UTadtI6j5569ZuOd2Hlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lxKKeLZd;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F5C606A31F
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 23:26:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65F5C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lxKKeLZd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793316360; x=1824852360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f2c86y7tCUpdmzIoFBpj69OPF7ons05hRkX2eBJ7NVE=;
  b=lxKKeLZdW409Wyb4VIY5l0a99EtRMn2Q+a/uml1l0A8fi/wKqt6HFmdL
   O9yyXPqLCndrRVN2DCKjwQfM6bbzw2yhoWKLvmPSRAasHK3EYKFA1ZX3w
   KAQS8+668to+vmXIb6FRbdppsEPLB3vw+maNp3WBhC2sRChC0+1kIwcAb
   rVqoQfDnWKzSAzbVEYc7KOEm4OZX5xdhIEH5FPvYRHhfL5/qEXghcC8ea
   JTIx58vUagprduOsJ3cixGSD1k1O+lqVq7A5LNqG58BslmL79OhndXSVJ
   g3dZGmEp+p7S3A+Fyq8jXRQIC6H+I/S/WQqhJs8cdJwYM0W301yukYkRT
   g==;
X-CSE-ConnectionGUID: Z3cxJgkIRJOhVn0LLY9nGw==
X-CSE-MsgGUID: WMY3d1WATh6LrH6YEvMyFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2106365"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2106365"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:25:59 -0700
X-CSE-ConnectionGUID: /vqEK+TrQKiHqgYIwlxvRg==
X-CSE-MsgGUID: n+UVvOhNSv+hJKtvSKLR2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5159688"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.28]) ([10.125.109.28])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:26:00 -0700
Message-ID: <99118f65-9ce8-4423-a926-ec9935176b36@intel.com>
Date: Thu, 29 Oct 2026 16:25:58 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/4] libdaxctl: handle mapping initialization
 failures
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 Gregory Price <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org
References: <cover.1792695259.git.alison.schofield@intel.com>
 <7737e1406eb60677979d3b6b090d52ee124ebaa7.1792695259.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <7737e1406eb60677979d3b6b090d52ee124ebaa7.1792695259.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/26 12:56 PM, Alison Schofield wrote:
> A failed sysfs read can silently truncate a device's mapping list, leaving
> callers with incomplete range information and potentially incorrect memory
> block accounting. An allocation failure also causes an infinite loop,
> hanging the caller.
> 
> Distinguish the end of the mapping list from read failures, reject
> incomplete lists, and discard partial results on error. The mappings
> describe the device's constituent ranges, so validate that their combined
> size matches the device size. Return -ENOMEM on allocation failure.
> 
> Fixes: 5a31bf710399 ("libdaxctl: add mapping iterator APIs")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  daxctl/lib/libdaxctl.c | 70 ++++++++++++++++++++++++++++++++++--------
>  1 file changed, 58 insertions(+), 12 deletions(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 5b47c770bd15..f630f4791f59 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -222,6 +222,17 @@ static void free_mem(struct daxctl_dev *dev)
>  	}
>  }
>  
> +static void free_mappings(struct daxctl_dev *dev)
> +{
> +	struct daxctl_mapping *mapping, *_m;
> +
> +	list_for_each_safe(&dev->mappings, mapping, _m, list) {
> +		list_del_from(&dev->mappings, &mapping->list);
> +		free(mapping);
> +	}
> +	dev->num_mappings = -1;
> +}
> +
>  static void free_dev(struct daxctl_dev *dev, struct list_head *head)
>  {
>  	if (head)
> @@ -1269,15 +1280,17 @@ DAXCTL_EXPORT unsigned long daxctl_memory_get_block_size(struct daxctl_memory *m
>  	return mem->block_size;
>  }
>  
> -static void mappings_init(struct daxctl_dev *dev)
> +static int mappings_init(struct daxctl_dev *dev)
>  {
> +	const char *devname = daxctl_dev_get_devname(dev);
>  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> +	unsigned long long size = 0;
>  	char buf[SYSFS_ATTR_SIZE];
>  	char *path = dev->dev_buf;
> -	int i;
> +	int i, rc;
>  
>  	if (dev->num_mappings != -1)
> -		return;
> +		return 0;
>  
>  	dev->num_mappings = 0;
>  	for (;;) {
> @@ -1285,31 +1298,43 @@ static void mappings_init(struct daxctl_dev *dev)
>  		unsigned long long pgoff, start, end;
>  
>  		i = dev->num_mappings;
> +		sprintf(path, "%s/mapping%d", dev->dev_path, i);
> +		if (access(path, F_OK) < 0) {
> +			if (errno == ENOENT)
> +				break;
> +			rc = -errno;
> +			err(ctx, "%s: Unable to access mapping%d: %s\n",
> +				devname, i, strerror(-rc));
> +			goto out;
> +		}
> +
>  		mapping = calloc(1, sizeof(*mapping));
>  		if (!mapping) {
> -			err(ctx, "%s: mapping%u allocation failure\n",
> -				daxctl_dev_get_devname(dev), i);
> -			continue;
> +			rc = -ENOMEM;
> +			goto err;
>  		}
>  
>  		sprintf(path, "%s/mapping%d/start", dev->dev_path, i);
> -		if (sysfs_read_attr(ctx, path, buf) < 0) {
> +		rc = sysfs_read_attr(ctx, path, buf);
> +		if (rc < 0) {
>  			free(mapping);
> -			break;
> +			goto err;
>  		}
>  		start = strtoull(buf, NULL, 0);
>  
>  		sprintf(path, "%s/mapping%d/end", dev->dev_path, i);
> -		if (sysfs_read_attr(ctx, path, buf) < 0) {
> +		rc = sysfs_read_attr(ctx, path, buf);
> +		if (rc < 0) {
>  			free(mapping);
> -			break;
> +			goto err;
>  		}
>  		end = strtoull(buf, NULL, 0);
>  
>  		sprintf(path, "%s/mapping%d/page_offset", dev->dev_path, i);
> -		if (sysfs_read_attr(ctx, path, buf) < 0) {
> +		rc = sysfs_read_attr(ctx, path, buf);
> +		if (rc < 0) {
>  			free(mapping);
> -			break;
> +			goto err;
>  		}
>  		pgoff = strtoull(buf, NULL, 0);
>  
> @@ -1320,9 +1345,30 @@ static void mappings_init(struct daxctl_dev *dev)
>  
>  		dev->num_mappings++;
>  		list_add(&dev->mappings, &mapping->list);
> +		size += end - start + 1;
>  	}
> +
> +	/* each of the device's ranges has a mappingN */
> +	if (dev->num_mappings && size != dev->size) {
> +		err(ctx, "%s: mappings total %#llx, device size %#llx\n",
> +			devname, size, dev->size);
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	return 0;
> +
> +err:
> +	/* sysfs_read_attr() already logged these */
> +	if (rc != -EACCES && rc != -EPERM)
> +		err(ctx, "%s: Unable to read mapping%d: %s\n", devname, i,
> +			strerror(-rc));
> +out:
> +	free_mappings(dev);
> +	return rc;
>  }
>  
> +/* NULL means either no mappings or a failure to read them */
>  DAXCTL_EXPORT struct daxctl_mapping *daxctl_mapping_get_first(struct daxctl_dev *dev)
>  {
>  	mappings_init(dev);

