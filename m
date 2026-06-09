Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1EC17745
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 00:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780963565; cv=none; b=uial01bZXFK/lTOhbILOQLVgZtKk20P0J/mDUAxm/CiNH1QCBYQ37dej3LuTVoeOVzkpXtJeL3ToWEFDOR8WrSFnn0A54HSYA9MTkeNtVHYSpyWodd9zpd3ph4DaNcNgIIVnDBCP0ishnWsfMlrWONfEkCkSYDHKzYhoiuuRi3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780963565; c=relaxed/simple;
	bh=d7+d8aQUwxOe9X5tEP8cBT4OCK6x7JGd6aPRmm5IfUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWIOF8cQcL3F4qBogdS2kGhkbAERvPQTLeTLKyQUjggFYVeREYDSs01ymc0D53iGSRioLXTkSDTFDdWnvWStbEiwWFOLqx65UPCsdnkGjRn/38l8XIYUYcMmTjmjQHHiGgRHRX22iTRQE8pI+s+SyvGmq/n/HP36g27duWrxaAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fsvGbhF9; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fsvGbhF9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780963562; x=1812499562;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d7+d8aQUwxOe9X5tEP8cBT4OCK6x7JGd6aPRmm5IfUQ=;
  b=fsvGbhF9loN51TGQ1qnXA7NiyYd/CAEtXXRtJZOkuJ4pbX4dkLuMi1EO
   zaJSZ694zdEF79pOW4MMGRSYpnHRQJHoHjIfIpsIzLYlx3J2wRlW/Zt75
   Hvj2X7cc4FeRsmXa+f51sYTMfwTaYiadFwJXNNOzEvzCKUpvJI0ZBDCZe
   eIu8StnxeB2So5yGUF+7/GgkW4hb4nQnZhh8DHYB0E7LJZ63tfUziKL3Q
   qCdpLpvPDBA8q8H3yKu+zng3hHJaLJ7cOKwcjAamco1uMXQ6l5QXSwtxz
   a3cJ6Fc9BM6uFmfhVu22Qnq/W67beFcP3GhY9tAHBFTMDN0bDVYfDnmIy
   Q==;
X-CSE-ConnectionGUID: thL+OMu0TZG3ucNHAQybaQ==
X-CSE-MsgGUID: Cu8BvrtiRBGQyW/mXlYmqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="84285337"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="84285337"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 17:06:00 -0700
X-CSE-ConnectionGUID: 9ZMSUS3iSvuxrAfV4hKmZQ==
X-CSE-MsgGUID: Nje6FADGS/Cem875kJ4nPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="245792141"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 17:05:59 -0700
Message-ID: <7ef3859e-2140-4daf-a9d5-ca7816fe9a4e@intel.com>
Date: Mon, 8 Jun 2026 17:05:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/7] libcxl: Add extent functionality to DC regions
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Alison Schofield
 <alison.schofield@intel.com>, John Groves <John@Groves.net>,
 Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-5-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260523095043.471098-5-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:50 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> DCD regions have 0 or more extents.  The ability to list those and their
> properties is useful to end users.
> 
> Add extent scanning and reporting functionality to libcxl.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Missing Anisa sign-off


> 
> ---
> Changes:
> [alison: s/tag/uuid/ for extents]
> ---
>  Documentation/cxl/lib/libcxl.txt |  27 ++++++
>  cxl/lib/libcxl.c                 | 138 +++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym               |   5 ++
>  cxl/lib/private.h                |  11 +++
>  cxl/libcxl.h                     |  11 +++
>  5 files changed, 192 insertions(+)
> 
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index 9921ac1..0ad294c 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -635,6 +635,33 @@ where its properties can be interrogated by daxctl. The helper
>  cxl_region_get_daxctl_region() returns an 'struct daxctl_region *' that
>  can be used with other libdaxctl APIs.
>  
> +EXTENTS
> +-------
> +
> +=== EXTENT: Enumeration
> +----
> +struct cxl_region_extent;
> +struct cxl_region_extent *cxl_extent_get_first(struct cxl_region *region);
> +struct cxl_region_extent *cxl_extent_get_next(struct cxl_region_extent *extent);
> +#define cxl_extent_foreach(region, extent) \
> +        for (extent = cxl_extent_get_first(region); \
> +             extent != NULL; \
> +             extent = cxl_extent_get_next(extent))
> +
> +----
> +
> +=== EXTENT: Attributes
> +----
> +unsigned long long cxl_extent_get_offset(struct cxl_region_extent *extent);
> +unsigned long long cxl_extent_get_length(struct cxl_region_extent *extent);
> +void cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid);
> +----
> +
> +Extents represent available memory within a dynamic capacity region.  Extent
> +objects are available for informational purposes to aid in allocation of
> +memory.
> +
> +
>  include::../../copyright.txt[]
>  
>  SEE ALSO
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index be0bc03..c096666 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -635,6 +635,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  	region->ctx = ctx;
>  	region->decoder = decoder;
>  	list_head_init(&region->mappings);
> +	list_head_init(&region->extents);
>  
>  	region->dev_path = strdup(cxlregion_base);
>  	if (!region->dev_path)
> @@ -1257,6 +1258,143 @@ cxl_mapping_get_next(struct cxl_memdev_mapping *mapping)
>  	return list_next(&region->mappings, mapping, list);
>  }
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
> +		err(ctx, "no extents found (%s): %s\n",
> +			strerror(errno), dax_region_path);
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
> +		if (offset == ULLONG_MAX) {
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
> +		if (length == ULLONG_MAX) {
> +			err(ctx, "%s extent%d.%d: failed to read length\n",
> +				devname, region_id, id);
> +			continue;
> +		}
> +
> +		sprintf(extent_path, "%s/extent%d.%d/tag",
> +			dax_region_path, region_id, id);
> +		buf[0] = '\0';
> +		if (sysfs_read_attr(ctx, extent_path, buf) != 0)
> +			dbg(ctx, "%s extent%d.%d: failed to read uuid\n",
> +				devname, region_id, id);
> +
> +		extent = calloc(1, sizeof(*extent));
> +		if (!extent) {
> +			err(ctx, "%s extent%d.%d: allocation failure\n",
> +				devname, region_id, id);
> +			continue;
> +		}
> +		if (strlen(buf) && uuid_parse(buf, extent->uuid) < 0)
> +			err(ctx, "%s:%s\n", extent_path, buf);
> +		extent->region = region;
> +		extent->offset = offset;
> +		extent->length = length;
> +
> +		list_node_init(&extent->list);
> +		list_add(&region->extents, &extent->list);

free_region() never frees any of the extents allocated and added here and thus leak the memory when region is freed.


> +		dbg(ctx, "%s added extent%d.%d\n", devname, region_id, id);
> +	}
> +	free(dax_region_path);
> +	free(extent_path);
> +	closedir(dir);
> +}
> +
> +CXL_EXPORT struct cxl_region_extent *
> +cxl_extent_get_first(struct cxl_region *region)
> +{
> +	cxl_extents_init(region);
> +
> +	return list_top(&region->extents, struct cxl_region_extent, list);
> +}
> +
> +CXL_EXPORT struct cxl_region_extent *
> +cxl_extent_get_next(struct cxl_region_extent *extent)
> +{
> +	struct cxl_region *region = extent->region;
> +
> +	return list_next(&region->extents, extent, list);
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_extent_get_offset(struct cxl_region_extent *extent)
> +{
> +	return extent->offset;
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_extent_get_length(struct cxl_region_extent *extent)
> +{
> +	return extent->length;
> +}
> +
> +CXL_EXPORT void
> +cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid)
> +{
> +	memcpy(uuid, extent->uuid, sizeof(uuid_t));
> +}
> +
>  CXL_EXPORT struct cxl_decoder *
>  cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping)
>  {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 258bdd3..dcfe242 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -298,6 +298,11 @@ global:
>  	cxl_memdev_get_dynamic_ram_a_qos_class;
>  	cxl_decoder_is_dynamic_ram_a_capable;
>  	cxl_decoder_create_dynamic_ram_a_region;
> +	cxl_extent_get_first;
> +	cxl_extent_get_next;
> +	cxl_extent_get_offset;
> +	cxl_extent_get_length;
> +	cxl_extent_get_uuid;
>  } LIBECXL_8;
>  
>  LIBCXL_10 {
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 37b7b06..c5f3bed 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -183,6 +183,7 @@ struct cxl_region {
>  	struct cxl_decoder *decoder;
>  	struct list_node list;
>  	int mappings_init;
> +	int extents_init;
>  	struct cxl_ctx *ctx;
>  	void *dev_buf;
>  	size_t buf_len;
> @@ -200,6 +201,7 @@ struct cxl_region {
>  	struct daxctl_region *dax_region;
>  	struct kmod_module *module;
>  	struct list_head mappings;
> +	struct list_head extents;
>  };
>  
>  struct cxl_memdev_mapping {
> @@ -209,6 +211,15 @@ struct cxl_memdev_mapping {
>  	struct list_node list;
>  };
>  
> +#define CXL_REGION_EXTENT_TAG 0x10

defined but never used

DJ

> +struct cxl_region_extent {
> +	struct cxl_region *region;
> +	u64 offset;
> +	u64 length;
> +	uuid_t uuid;
> +	struct list_node list;
> +};
> +
>  enum cxl_cmd_query_status {
>  	CXL_CMD_QUERY_NOT_RUN = 0,
>  	CXL_CMD_QUERY_OK,
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index fd41122..a60509f 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -394,6 +394,17 @@ unsigned int cxl_mapping_get_position(struct cxl_memdev_mapping *mapping);
>               mapping != NULL; \
>               mapping = cxl_mapping_get_next(mapping))
>  
> +struct cxl_region_extent;
> +struct cxl_region_extent *cxl_extent_get_first(struct cxl_region *region);
> +struct cxl_region_extent *cxl_extent_get_next(struct cxl_region_extent *extent);
> +#define cxl_extent_foreach(region, extent) \
> +        for (extent = cxl_extent_get_first(region); \
> +             extent != NULL; \
> +             extent = cxl_extent_get_next(extent))
> +unsigned long long cxl_extent_get_offset(struct cxl_region_extent *extent);
> +unsigned long long cxl_extent_get_length(struct cxl_region_extent *extent);
> +void cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid);
> +
>  struct cxl_cmd;
>  const char *cxl_cmd_get_devname(struct cxl_cmd *cmd);
>  struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);

