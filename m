Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94EA216A32
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731003206; cv=none; b=pl85vQ/OFMzUJyfQtCpgRffXtqvMFUrdtO2AfT2fn3c7LYVVMOLByR3oaC2GQVUzVlm9UTpkncrcb1v+JqRaJLhxevfU++Nq7BJ6jkcCZkeJ5VsqP+Jo3vVLlAlXM6Ng15Q4gt/l5MYrcFe4OpkRqFjBCYMw4lXJQdpja7RNNpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731003206; c=relaxed/simple;
	bh=aPtEu9k3m/4zpImRkS7CYgAoKe3PrpC0FeeN3I+IYC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LV614yCNEMD2muKippumUPDcfzmH7GYD3fdiZsaEhWmAo6xbXRsnls04FK4F8HwVev1xZ/yQEM1Pf7Ln0o08AyvqvZVHeDrI3QL8iAsdRsWbfs01mt4GUda9PikmewElE75HNSX8MXjtZStfH++ILCynhdHBSvVW9tZ7euYOy+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SpV2imv6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SpV2imv6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731003203; x=1762539203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aPtEu9k3m/4zpImRkS7CYgAoKe3PrpC0FeeN3I+IYC4=;
  b=SpV2imv6tziyPVkGma4Fp437C8Cdshita+MuyyUXQCRSHiSkZe1YwonX
   bYynjyZrjbGEC5LBPiG2LMX0l0TRkdZSUf3Cp2SGqX/A7iB1jBxLuwnL9
   Q1X3nVuJjWhawXyL4A6Eh3qrmnwx2DwrGNkXC1Cp2sNlvGt2yXGD8/LYj
   GZz5AInBSABcSd99FhxieAlf2/5PVl4rzh7z5fIr4fmfzwdX6BzjLhXbZ
   UB2wUND80Z8p/qIonf+0EavPPayzk4HqnxBawON4NLVu4ip36vqVDmZke
   o4zXD2KXNcWdObQkhzKcp+WwHSOMDHctLxUGof8kaL0k8aVFPfs6Ypyus
   A==;
X-CSE-ConnectionGUID: FBMaXFwzRUeZcLNDwz0AFA==
X-CSE-MsgGUID: iPvXYt4ITZyuLlKGnAVkiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="41464307"
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="41464307"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 10:13:23 -0800
X-CSE-ConnectionGUID: bRoHKoorR2iVD6ywPcK/pA==
X-CSE-MsgGUID: IX9kzJbYQHSTbBFamFg/OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="122702562"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.171])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 10:13:22 -0800
Date: Thu, 7 Nov 2024 10:13:20 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 5/6] ndctl/cxl: Add extent output to region query
Message-ID: <Zy0DQJK8opX4K16p@aschofie-mobl2.lan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-5-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-5-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:49PM -0600, Ira Weiny wrote:
> DCD regions have 0 or more extents.  The ability to list those and their
> properties is useful to end users.
> 

Should we describe those new useful properties in the man page...see
below...

> Add extent output to region queries.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |   4 ++
>  cxl/filter.h                   |   3 +
>  cxl/json.c                     |  47 ++++++++++++++
>  cxl/json.h                     |   3 +
>  cxl/lib/libcxl.c               | 138 +++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym             |   5 ++
>  cxl/lib/private.h              |  11 ++++
>  cxl/libcxl.h                   |  11 ++++
>  cxl/list.c                     |   3 +
>  util/json.h                    |   1 +
>  10 files changed, 226 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 9a9911e7dd9bba561c6202784017db1bb4b9f4bd..71fd313cfec2509c79f8ad1e0f64857d0d804c13 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -411,6 +411,10 @@ OPTIONS
>  }
>  ----
>  
> +-N::
> +--extents::
> +	Extend Dynamic Capacity region listings extent information.
> +

a sample perhaps?  or some verbage on  what to expect.


snip

>  
> +static void cxl_extents_init(struct cxl_region *region)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	char *extent_path, *dax_region_path;
> +	struct dirent *de;
> +	DIR *dir = NULL;
> +
> +	if (region->extents_init)
> +		return;
> +	region->extents_init = 1;
> +
> +	dbg(ctx, "Checking extents: %s\n", region->dev_path);

Rather than emit the above which makes me assume success if
no err message follows, how about emitting the success debug
msg when all is done below.

> +
> +	dax_region_path = calloc(1, strlen(region->dev_path) + 64);
> +	if (!dax_region_path) {
> +		err(ctx, "%s: allocation failure\n", devname);
> +		return;
> +	}
> +
> +	extent_path = calloc(1, strlen(region->dev_path) + 100);
> +	if (!extent_path) {
> +		err(ctx, "%s: allocation failure\n", devname);
> +		free(dax_region_path);
> +		return;
> +	}
> +
> +	sprintf(dax_region_path, "%s/dax_region%d",
> +		region->dev_path, region->id);
> +	dir = opendir(dax_region_path);
> +	if (!dir) {
> +		err(ctx, "no extents found: %s\n", dax_region_path);
> +		free(extent_path);
> +		free(dax_region_path);
> +		return;
> +	}
> +
> +	while ((de = readdir(dir)) != NULL) {
> +		struct cxl_region_extent *extent;
> +		char buf[SYSFS_ATTR_SIZE];
> +		u64 offset, length;
> +		int id, region_id;
> +
> +		if (sscanf(de->d_name, "extent%d.%d", &region_id, &id) != 2)
> +			continue;
> +
> +		sprintf(extent_path, "%s/extent%d.%d/offset",
> +			dax_region_path, region_id, id);
> +		if (sysfs_read_attr(ctx, extent_path, buf) < 0) {
> +			err(ctx, "%s: failed to read extent%d.%d/offset\n",
> +				devname, region_id, id);
> +			continue;
> +		}
> +
> +		offset = strtoull(buf, NULL, 0);
> +		if (offset == ERANGE) {
> +			err(ctx, "%s extent%d.%d: failed to read offset\n",
> +				devname, region_id, id);
> +			continue;
> +		}
> +
> +		sprintf(extent_path, "%s/extent%d.%d/length",
> +			dax_region_path, region_id, id);
> +		if (sysfs_read_attr(ctx, extent_path, buf) < 0) {
> +			err(ctx, "%s: failed to read extent%d.%d/length\n",
> +				devname, region_id, id);
> +			continue;
> +		}
> +
> +		length = strtoull(buf, NULL, 0);
> +		if (length == ERANGE) {
> +			err(ctx, "%s extent%d.%d: failed to read length\n",
> +				devname, region_id, id);
> +			continue;
> +		}
> +
> +		sprintf(extent_path, "%s/extent%d.%d/tag",
> +			dax_region_path, region_id, id);
> +		buf[0] = '\0';
> +		if (sysfs_read_attr(ctx, extent_path, buf) != 0)
> +			dbg(ctx, "%s extent%d.%d: failed to read tag\n",
> +				devname, region_id, id);
> +
> +		extent = calloc(1, sizeof(*extent));
> +		if (!extent) {
> +			err(ctx, "%s extent%d.%d: allocation failure\n",
> +				devname, region_id, id);
> +			continue;
> +		}
> +		if (strlen(buf) && uuid_parse(buf, extent->tag) < 0)
> +			err(ctx, "%s:%s\n", extent_path, buf);
> +		extent->region = region;
> +		extent->offset = offset;
> +		extent->length = length;
> +
> +		list_node_init(&extent->list);
> +		list_add(&region->extents, &extent->list);
> +	}

	Here - dbg the success message

> +	free(dax_region_path);
> +	free(extent_path);
> +	closedir(dir);
> +}
> 
