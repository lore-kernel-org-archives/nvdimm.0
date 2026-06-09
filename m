Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3B73AC00
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 00:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780963983; cv=none; b=S93IwrAb+V0rnqxCjPJAyWOFUSLrPGRw9toCaESPW4grn9sP677v5QEoChf3SflPR+5bGSZbvLeGmZP+PfDzwAPTIGLVvxPn4CrAVM3+I1xkOR8r50EK9Ka3iB6qatylE08wvSc34OZS6oXKmAN6vG5CfCvPE3XzyC7pqrVDhbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780963983; c=relaxed/simple;
	bh=gEU91nAT1kE1ELSuDkenOA+7nwztaXOrYivOp0SCGPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ohZNc5NeGGnLswxOEPLzXMdF2HmuPIMhvtVYcy6YY2vPY308uyly6AjeVJYW627KWZ8xFLsdaF0/e1fDgRyNDlah7y++kFKI1jcc1ZVGYXi7ZyZW8MPOEJwr62ORQ34lysWE8aiYTcMzWDND2kJJSIefyixAN6Kr7kMSpIe+KA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R+N9qBVE; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R+N9qBVE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780963982; x=1812499982;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gEU91nAT1kE1ELSuDkenOA+7nwztaXOrYivOp0SCGPM=;
  b=R+N9qBVE5wYN1Q7KquASr/U592RaQORFDIk/Y21RpA2mrCspbBSVp/E5
   5XgIbuC47+QqtcPqgLr5JgIfn1MUM5tqwBc1lVjQSHbo0SgdxHL3erLVd
   6EQM8swkpdKyUx5eJV++n2qdJwRUkHvFp7l/8odycG0I/Hyb+cD31EhZz
   a6pT7pjOLNCngDQgX5RamCw8A5Mz3I+fQfPmndfXtZ3xb1GbN+t0KOAu5
   q0M9xs0Sfjs+HKWdOxQodhZ9Ba12wC6D9IKrqJ8ZCTHVBaBW+aABZMh9u
   +ohdV1ZZ1LUt/82WcQsH64u38MxBK6GBtWQR1CMKrCEiIlCOPG0WGZ3vn
   Q==;
X-CSE-ConnectionGUID: hUbAL1vSRc+mFuKRyJMi3w==
X-CSE-MsgGUID: lrO096EpQMOdF2l7bgYmGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="84285996"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="84285996"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 17:13:01 -0700
X-CSE-ConnectionGUID: ojGgkG+HTHCcgZ88+wqZIg==
X-CSE-MsgGUID: CTwzPpJ2RpyuXKAKJpU+hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="250621952"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 17:13:00 -0700
Message-ID: <f1bf4df1-7ff2-4e13-8632-0d0c680f3629@intel.com>
Date: Mon, 8 Jun 2026 17:12:59 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/7] daxctl: Add --uuid option to create-device for
 sparse regions
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Alison Schofield
 <alison.schofield@intel.com>, John Groves <John@Groves.net>,
 Gregory Price <gourry@gourry.net>, Anisa Su <anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-7-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260523095043.471098-7-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:50 AM, Anisa Su wrote:
> Add a --uuid option to 'daxctl create-device' that writes the given
> uuid to the new dax device's sysfs 'uuid' attribute.  On sparse (DCD)
> regions this claims dax_resources whose tag matches and populates the
> seed device with their capacity; size is determined by the claim, so
> --uuid is mutually exclusive with --size.
> 
> Pass "0" to claim a single untagged dax_resource.  A claim that
> matches no dax_resource leaves the device at size 0; the kernel
> returns ENOENT.
> 
> Plumb the write through a new daxctl_dev_set_uuid() libdaxctl helper
> (LIBDAXCTL_11) and document the option in the man page.
> 
> Signed-off-by: Anisa Su <anisa.su887@gmail.com>
> ---
>  Documentation/daxctl/daxctl-create-device.txt | 12 ++++
>  daxctl/device.c                               | 72 +++++++++++++------
>  daxctl/lib/libdaxctl.c                        | 44 ++++++++++++
>  daxctl/lib/libdaxctl.sym                      |  5 ++
>  daxctl/libdaxctl.h                            |  1 +
>  5 files changed, 114 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/daxctl/daxctl-create-device.txt b/Documentation/daxctl/daxctl-create-device.txt
> index b774b86..27b87d0 100644
> --- a/Documentation/daxctl/daxctl-create-device.txt
> +++ b/Documentation/daxctl/daxctl-create-device.txt
> @@ -82,6 +82,18 @@ include::region-option.txt[]
>  
>  	The size must be a multiple of the region alignment.
>  
> +	Mutually exclusive with --uuid.
> +
> +--uuid=::
> +	For dax devices on sparse (DCD) regions, claim dax_resource(s) whose
> +	tag matches the given UUID.  The device's size is determined by the
> +	claimed capacity, so --uuid cannot be combined with --size.
> +
> +	A non-null UUID claims every matching dax_resource in the parent
> +	region.  The value "0" is shorthand for the null UUID and claims a
> +	single untagged dax_resource.  A write that matches no dax_resource
> +	fails with ENOENT and the device is left at size 0.
> +
>  -a::
>  --align::
>  	Applications that want to establish dax memory mappings with
> diff --git a/daxctl/device.c b/daxctl/device.c
> index a4e36b1..21a941e 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -30,6 +30,7 @@ static struct {
>  	const char *size;
>  	const char *align;
>  	const char *input;
> +	const char *uuid;
>  	bool check_config;
>  	bool no_online;
>  	bool no_movable;
> @@ -85,7 +86,9 @@ OPT_BOOLEAN('C', "check-config", &param.check_config, \
>  #define CREATE_OPTIONS() \
>  OPT_STRING('s', "size", &param.size, "size", "size to switch the device to"), \
>  OPT_STRING('a', "align", &param.align, "align", "alignment to switch the device to"), \
> -OPT_STRING('\0', "input", &param.input, "input", "input device JSON file")
> +OPT_STRING('\0', "input", &param.input, "input", "input device JSON file"), \
> +OPT_STRING('\0', "uuid", &param.uuid, "uuid", \
> +	"claim sparse dax_resource(s) matching this uuid (\"0\" for untagged)")
>  
>  #define DESTROY_OPTIONS() \
>  OPT_BOOLEAN('f', "force", &param.force, \
> @@ -808,6 +811,22 @@ static int do_create(struct daxctl_region *region, long long val,
>  	struct daxctl_dev *dev;
>  	int i, rc = 0;
>  	long long alloc = 0;
> +	uuid_t uuid;
> +
> +	if (param.uuid) {
> +		if (param.size) {
> +			fprintf(stderr,
> +				"--uuid and --size are mutually exclusive\n");
> +			return -EINVAL;
> +		}
> +		if (strcmp(param.uuid, "0") == 0) {
> +			uuid_clear(uuid);
> +		} else if (uuid_parse(param.uuid, uuid) < 0) {
> +			fprintf(stderr, "failed to parse uuid '%s'\n",
> +				param.uuid);
> +			return -EINVAL;
> +		}
> +	}
>  
>  	if (daxctl_region_create_dev(region))
>  		return -ENOSPC;
> @@ -816,33 +835,46 @@ static int do_create(struct daxctl_region *region, long long val,
>  	if (!dev)
>  		return -ENOSPC;
>  
> -	if (val == -1)
> -		val = daxctl_region_get_available_size(region);
> -
> -	if (val <= 0)
> -		return -ENOSPC;
> -
>  	if (align > 0) {
>  		rc = daxctl_dev_set_align(dev, align);
>  		if (rc < 0)
>  			return rc;
>  	}
>  
> -	/* @maps is ordered by page_offset */
> -	for (i = 0; i < nmaps; i++) {
> -		rc = daxctl_dev_set_mapping(dev, maps[i].start, maps[i].end);
> -		if (rc < 0)
> +	if (param.uuid) {
> +		rc = daxctl_dev_set_uuid(dev, uuid);
> +		if (rc < 0) {
> +			fprintf(stderr,
> +				"%s: failed to claim uuid '%s': %s\n",
> +				daxctl_dev_get_devname(dev), param.uuid,
> +				strerror(-rc));
>  			return rc;
> -		alloc += (maps[i].end - maps[i].start + 1);
> -	}
> -
> -	if (nmaps > 0 && val > 0 && alloc != val) {
> -		fprintf(stderr, "%s: allocated %lld but specified size %lld\n",
> -			daxctl_dev_get_devname(dev), alloc, val);
> +		}
>  	} else {
> -		rc = daxctl_dev_set_size(dev, val);
> -		if (rc < 0)
> -			return rc;
> +		if (val == -1)
> +			val = daxctl_region_get_available_size(region);
> +
> +		if (val <= 0)
> +			return -ENOSPC;
> +
> +		/* @maps is ordered by page_offset */
> +		for (i = 0; i < nmaps; i++) {
> +			rc = daxctl_dev_set_mapping(dev, maps[i].start,
> +						    maps[i].end);
> +			if (rc < 0)
> +				return rc;
> +			alloc += (maps[i].end - maps[i].start + 1);
> +		}
> +
> +		if (nmaps > 0 && val > 0 && alloc != val) {
> +			fprintf(stderr,
> +				"%s: allocated %lld but specified size %lld\n",
> +				daxctl_dev_get_devname(dev), alloc, val);
> +		} else {
> +			rc = daxctl_dev_set_size(dev, val);
> +			if (rc < 0)
> +				return rc;
> +		}
>  	}
>  
>  	rc = daxctl_dev_enable_devdax(dev);
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 02ae7e5..fe07939 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -1107,6 +1107,50 @@ DAXCTL_EXPORT int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long
>  	return 0;
>  }
>  
> +DAXCTL_EXPORT int daxctl_dev_set_uuid(struct daxctl_dev *dev, uuid_t uuid)
> +{
> +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> +	char buf[SYSFS_ATTR_SIZE];
> +	char *path = dev->dev_buf;
> +	int len = dev->buf_len;
> +
> +	if (snprintf(path, len, "%s/uuid", dev->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n",
> +				daxctl_dev_get_devname(dev));
> +		return -ENXIO;

snprintf() returns negative errno, propogate

> +	}
> +
> +	if (uuid_is_null(uuid))
> +		sprintf(buf, "0\n");
> +	else
> +		uuid_unparse(uuid, buf);
> +
> +	if (sysfs_write_attr(ctx, path, buf) < 0) {
> +		err(ctx, "%s: failed to set uuid\n",
> +				daxctl_dev_get_devname(dev));
> +		return -ENXIO;

propogate the errno from sysfs_write_attr()

> +	}
> +
> +	/*
> +	 * On a sparse region the kernel populates the device size as a
> +	 * side effect of claiming the matching dax_resource(s); refresh
> +	 * the cached size so callers see the post-claim value.
> +	 */
> +	if (snprintf(path, len, "%s/size", dev->dev_path) >= len) {
> +		err(ctx, "%s: buffer too small!\n",
> +				daxctl_dev_get_devname(dev));
> +		return -ENXIO;

propogate negative return value from snprintf()

> +	}
> +	if (sysfs_read_attr(ctx, path, buf) < 0) {
> +		err(ctx, "%s: failed to read back size\n",
> +				daxctl_dev_get_devname(dev));
> +		return -ENXIO;

propgate negative errno from sysfs_read_attr()

> +	}
> +	dev->size = strtoull(buf, NULL, 0);
> +
> +	return 0;
> +}
> +
>  DAXCTL_EXPORT unsigned long daxctl_dev_get_align(struct daxctl_dev *dev)
>  {
>  	return dev->align;
> diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
> index 3098811..16792eb 100644
> --- a/daxctl/lib/libdaxctl.sym
> +++ b/daxctl/lib/libdaxctl.sym
> @@ -104,3 +104,8 @@ LIBDAXCTL_10 {
>  global:
>  	daxctl_dev_is_system_ram_capable;
>  } LIBDAXCTL_9;
> +
> +LIBDAXCTL_11 {
> +global:
> +	daxctl_dev_set_uuid;
> +} LIBDAXCTL_10;
> diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
> index 53c6bbd..cdd5995 100644
> --- a/daxctl/libdaxctl.h
> +++ b/daxctl/libdaxctl.h
> @@ -63,6 +63,7 @@ int daxctl_dev_get_minor(struct daxctl_dev *dev);
>  unsigned long long daxctl_dev_get_resource(struct daxctl_dev *dev);
>  unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev);
>  int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long size);
> +int daxctl_dev_set_uuid(struct daxctl_dev *dev, uuid_t uuid);
>  unsigned long daxctl_dev_get_align(struct daxctl_dev *dev);
>  int daxctl_dev_set_align(struct daxctl_dev *dev, unsigned long align);
>  int daxctl_dev_set_mapping(struct daxctl_dev *dev, unsigned long long start,

