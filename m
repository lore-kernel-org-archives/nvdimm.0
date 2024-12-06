Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D99E1E4AD
	for <nvdimm@lists.linux.dev>; Fri,  6 Dec 2024 01:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447410; cv=none; b=Mi71AD7HH9OzjoqDdR6vsDY5Keidfel0hwVuHBQqoZyGazkKu6Jb8soLmGNxiDTXUu+o1/z6yXejHNc2BevOIG8zhNHUtykP32Lg8txDPh5bywVCF8u7qxyM//leA4OfuD+QCRbUXmZ+gPDmtqHElPXq/ljjkx43VuVIQCU1CuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447410; c=relaxed/simple;
	bh=x+0+vxSpvq26U//iLZovhmZYpLZlWGUox0b9H3KLNbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/P7timcel3jV99XfjLI88KDsQyGyFvSU5CkJ14JQXZ4dQOfReBfEjBqSXQZqFSiitRh4/f8GHlt/5UvqkGObUK5o5P25My0fw06bQ752/QceJjeq/mRGWhxfjisBURvJ5aczZFnNBwQpD8ZKhqO66HgOTqrRvvR1c/JpHGMx+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QDbO7yUG; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QDbO7yUG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733447409; x=1764983409;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x+0+vxSpvq26U//iLZovhmZYpLZlWGUox0b9H3KLNbU=;
  b=QDbO7yUGlrerAcGMbj/lE37uPRDaUcZOx/rMXVK7wiCeMmXZsHUs27IQ
   FYS6Qi5SKVTyvjNlHT7y/egzo45+gfb+nBmnX+QJ53fyU4hD8YPIBFuUY
   raiD9HEfjGmkqZNvkzQ18BwsMWxpGOkH4QScZLM+YaHVRA9Lq86W2K/2q
   SkxRUNOo848liFpy1aH20WT8HswzMKDJUfFDhrXLF+yaEs30Fxn6fQVpI
   0/ivE3F/4cdfCsDkoJ8h7Eiv5Bi36UIJwFqYEFtJMcFlSCnoc9UYyIkO9
   Jd7m70jRz2Tf6G1t6gixxY/y9fCwHAvhOKB53ETSzplhcKnSNjAyc1az3
   A==;
X-CSE-ConnectionGUID: elyUAW2GQG+EnPFgsVGlnw==
X-CSE-MsgGUID: ekdObx1pTgeCdUWuqDNDAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="33844858"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="33844858"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 17:10:08 -0800
X-CSE-ConnectionGUID: ypLy/z/7T2uMPwDksutmPw==
X-CSE-MsgGUID: 0U6Gm2P+RrSQgyW5CRM7QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="94620553"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.192])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 17:10:07 -0800
Date: Thu, 5 Dec 2024 17:10:05 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Li Ming <ming.li@zohomail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/1] daxctl: Output more information if memblock is
 unremovable
Message-ID: <Z1JO7WUKwTcBVIYA@aschofie-mobl2.lan>
References: <20241204161457.1113419-1-ming.li@zohomail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204161457.1113419-1-ming.li@zohomail.com>

On Thu, Dec 05, 2024 at 12:14:56AM +0800, Li Ming wrote:
> If CONFIG_MEMORY_HOTREMOVE is disabled by kernel, memblocks will not be
> removed, so 'dax offline-memory all' will output below error logs:
> 
>   libdaxctl: offline_one_memblock: dax0.0: Failed to offline /sys/devices/system/node/node6/memory371/state: Invalid argument
>   dax0.0: failed to offline memory: Invalid argument
>   error offlining memory: Invalid argument
>   offlined memory for 0 devices
> 
> The log does not clearly show why the command failed. So checking if the
> target memblock is removable before offlining it by querying
> '/sys/devices/system/node/nodeX/memoryY/removable', then output specific
> logs if the memblock is unremovable, output will be:
> 
>   libdaxctl: offline_one_memblock: dax0.0: memory371 is unremovable
>   dax0.0: failed to offline memory: Operation not supported
>   error offlining memory: Operation not supported
>   offlined memory for 0 devices
>

Hi Ming,

This led me to catch up on movable and removable in DAX context.
Not all 'Movable' DAX memory is 'Removable' right?

Would it be useful to add 'removable' to the daxctl list json:

# daxctl list
[
  {
    "chardev":"dax0.0",
    "size":536870912,
    "target_node":0,
    "align":2097152,
    "mode":"system-ram",
    "online_memblocks":4,
    "total_memblocks":4,
    "movable":true
    "removable":false  <----
  }
]

You've already added the helper to discover removable.

Otherwise, LGTM,
Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> Besides, delay to set up string 'path' for offlining memblock operation,
> because string 'path' is stored in 'mem->mem_buf' which is a shared
> buffer, it will be used in memblock_is_removable().
> 
> Signed-off-by: Li Ming <ming.li@zohomail.com>
> ---
>  daxctl/lib/libdaxctl.c | 52 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 9fbefe2e8329..b7fa0de0b73d 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -1310,6 +1310,37 @@ static int memblock_is_online(struct daxctl_memory *mem, char *memblock)
>  	return 0;
>  }
>  
> +static int memblock_is_removable(struct daxctl_memory *mem, char *memblock)
> +{
> +	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
> +	const char *devname = daxctl_dev_get_devname(dev);
> +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> +	int len = mem->buf_len, rc;
> +	char buf[SYSFS_ATTR_SIZE];
> +	char *path = mem->mem_buf;
> +	const char *node_path;
> +
> +	node_path = daxctl_memory_get_node_path(mem);
> +	if (!node_path)
> +		return -ENXIO;
> +
> +	rc = snprintf(path, len, "%s/%s/removable", node_path, memblock);
> +	if (rc < 0)
> +		return -ENOMEM;
> +
> +	rc = sysfs_read_attr(ctx, path, buf);
> +	if (rc) {
> +		err(ctx, "%s: Failed to read %s: %s\n",
> +			devname, path, strerror(-rc));
> +		return rc;
> +	}
> +
> +	if (strtoul(buf, NULL, 0) == 0)
> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}
> +
>  static int online_one_memblock(struct daxctl_memory *mem, char *memblock,
>  		enum memory_zones zone, int *status)
>  {
> @@ -1362,6 +1393,20 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>  	char *path = mem->mem_buf;
>  	const char *node_path;
>  
> +	/* if already offline, there is nothing to do */
> +	rc = memblock_is_online(mem, memblock);
> +	if (rc < 0)
> +		return rc;
> +	if (!rc)
> +		return 1;
> +
> +	rc = memblock_is_removable(mem, memblock);
> +	if (rc) {
> +		if (rc == -EOPNOTSUPP)
> +			err(ctx, "%s: %s is unremovable\n", devname, memblock);
> +		return rc;
> +	}
> +
>  	node_path = daxctl_memory_get_node_path(mem);
>  	if (!node_path)
>  		return -ENXIO;
> @@ -1370,13 +1415,6 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>  	if (rc < 0)
>  		return -ENOMEM;
>  
> -	/* if already offline, there is nothing to do */
> -	rc = memblock_is_online(mem, memblock);
> -	if (rc < 0)
> -		return rc;
> -	if (!rc)
> -		return 1;
> -
>  	rc = sysfs_write_attr_quiet(ctx, path, mode);
>  	if (rc) {
>  		/* check if something raced us to offline (unlikely) */
> -- 
> 2.34.1
> 
> 
