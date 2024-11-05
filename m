Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE1E1ABEBA
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730826268; cv=none; b=NagpQL34G0V0+Nihltq7U4jgxYQvCVrouo7B5deQYWOGh4eqX+kBXjNYzyRzPzEPOTVqi74/i9SJHHWaTcgi7vsNP0xsZXnpT8yklrlvO12HZIRMGzbvgJZG215k/DMAagnojJBsNjpVsGjNPO9YPL9O2A62jnpIqawwNuKMzvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730826268; c=relaxed/simple;
	bh=so2yJzkfZ5JZSlzH9wFXcCIUA7OLh2znr0SivShNUuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IGPoyKDp6FBxtGSPG+Y8SqZY72TnJFqfD20oftm4bFGekc9svU5w8vjnHcQGm/6kLMFByFpkykCSqrgrSqFhrMG+4ocmBGeNL+KBodmVQWOkRQKLngS4hCuscVs58ltNiBlM56RYAjF/39mEddb31qsjlap0gX/RTzuVZ3hztjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dAxMLu9o; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dAxMLu9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730826265; x=1762362265;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=so2yJzkfZ5JZSlzH9wFXcCIUA7OLh2znr0SivShNUuk=;
  b=dAxMLu9oqqE4ZW9OlbvQx37MCRVQL15DYBKkh8KLKqKjiNpmWQQfH2jS
   A9cqzoNvPFjDdoygSk1taC8kiJ8vWaZMpIDEhw2h4teldvWX31YURupzP
   9D54yOh8ob1BWPHqb12+eHLmnGpUKAEAtPOJfnMajzsVDddqA6ysh3dgI
   QyFUDYSGm2sweZ8fo7XEDTdeyD0NOjirPzkHrRuJXRBCRM/KHCA93FAWp
   Y6SxDcVSpTobXbjWKcf1AouiEhKpuU38bJ3b0gv5vkgkhN+6i1JN3FLlH
   18TCJjIW+KM9RDCIPbWYGtP44TOkz9WvYhbwlu5QIbDwxyJMhxI9fpHkV
   Q==;
X-CSE-ConnectionGUID: 6rFvKEnvRLWbJzk/SsZzoA==
X-CSE-MsgGUID: ds5xcQ/LRIWe4A9gZzx0QA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30361152"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30361152"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 09:04:25 -0800
X-CSE-ConnectionGUID: VYp2+L5cT66YkxDLR0MB4A==
X-CSE-MsgGUID: JrjIvy6aSYqgJgLdHhYQYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84214236"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.109.253]) ([10.125.109.253])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 09:04:21 -0800
Message-ID: <4dccf252-8827-4d5e-9417-8b52dbed132d@intel.com>
Date: Tue, 5 Nov 2024 10:04:20 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 5/6] ndctl/cxl: Add extent output to region query
To: Ira Weiny <ira.weiny@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>,
 Navneet Singh <navneet.singh@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-5-be057b479eeb@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241104-dcd-region2-v2-5-be057b479eeb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/24 7:10 PM, Ira Weiny wrote:
> DCD regions have 0 or more extents.  The ability to list those and their
> properties is useful to end users.
> 
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
>  -r::
>  --region::
>  	Specify CXL region device name(s), or device id(s), to filter the listing.
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 956a46e0c7a9f05abf696cce97a365164e95e50d..a31b80c87ccac407bd4ff98b302a23b33cbe413c 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -31,6 +31,7 @@ struct cxl_filter_params {
>  	bool alert_config;
>  	bool dax;
>  	bool media_errors;
> +	bool extents;
>  	int verbose;
>  	struct log_ctx ctx;
>  };
> @@ -91,6 +92,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
>  		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
>  	if (param->media_errors)
>  		flags |= UTIL_JSON_MEDIA_ERRORS;
> +	if (param->extents)
> +		flags |= UTIL_JSON_EXTENTS;
>  	return flags;
>  }
>  
> diff --git a/cxl/json.c b/cxl/json.c
> index 915b2716a524fa8929ed34b01a7cb6590b61d4b7..0d6644916b8dd2cdee39ac9bf7310b5e318f0e2d 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -1170,6 +1170,50 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
>  	json_object_object_add(jregion, "mappings", jmappings);
>  }
>  
> +void util_cxl_extents_append_json(struct json_object *jregion,
> +				  struct cxl_region *region,
> +				  unsigned long flags)
> +{
> +	struct json_object *jextents;
> +	struct cxl_region_extent *extent;
> +
> +	jextents = json_object_new_array();
> +	if (!jextents)
> +		return;
> +
> +	cxl_extent_foreach(region, extent) {
> +		struct json_object *jextent, *jobj;
> +		unsigned long long val;
> +		char tag_str[40];
> +		uuid_t tag;
> +
> +		jextent = json_object_new_object();
> +		if (!jextent)
> +			continue;
> +
> +		val = cxl_extent_get_offset(extent);
> +		jobj = util_json_object_hex(val, flags);
> +		if (jobj)
> +			json_object_object_add(jextent, "offset", jobj);
> +
> +		val = cxl_extent_get_length(extent);
> +		jobj = util_json_object_size(val, flags);
> +		if (jobj)
> +			json_object_object_add(jextent, "length", jobj);
> +
> +		cxl_extent_get_tag(extent, tag);
> +		uuid_unparse(tag, tag_str);
> +		jobj = json_object_new_string(tag_str);
> +		if (jobj)
> +			json_object_object_add(jextent, "tag", jobj);
> +
> +		json_object_array_add(jextents, jextent);
> +		json_object_set_userdata(jextent, extent, NULL);
> +	}
> +
> +	json_object_object_add(jregion, "extents", jextents);
> +}
> +
>  struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  					     unsigned long flags)
>  {
> @@ -1256,6 +1300,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  		}
>  	}
>  
> +	if (flags & UTIL_JSON_EXTENTS)
> +		util_cxl_extents_append_json(jregion, region, flags);
> +
>  	if (cxl_region_qos_class_mismatch(region)) {
>  		jobj = json_object_new_boolean(true);
>  		if (jobj)
> diff --git a/cxl/json.h b/cxl/json.h
> index eb7572be4106baf0469ba9243a9a767d07df8882..f9c07ab41a337838b75ffee4486f6c48ddc99863 100644
> --- a/cxl/json.h
> +++ b/cxl/json.h
> @@ -20,6 +20,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  void util_cxl_mappings_append_json(struct json_object *jregion,
>  				  struct cxl_region *region,
>  				  unsigned long flags);
> +void util_cxl_extents_append_json(struct json_object *jregion,
> +				  struct cxl_region *region,
> +				  unsigned long flags);
>  void util_cxl_targets_append_json(struct json_object *jdecoder,
>  				  struct cxl_decoder *decoder,
>  				  const char *ident, const char *serial,
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 4caa2d02313bf71960971c4eaa67fa42cea08d55..8ebb100df0c6078630bbe45fbed270709dfb4a5f 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -568,6 +568,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  	region->ctx = ctx;
>  	region->decoder = decoder;
>  	list_head_init(&region->mappings);
> +	list_head_init(&region->extents);
>  
>  	region->dev_path = strdup(cxlregion_base);
>  	if (!region->dev_path)
> @@ -1178,6 +1179,143 @@ cxl_mapping_get_next(struct cxl_memdev_mapping *mapping)
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
> +	dbg(ctx, "Checking extents: %s\n", region->dev_path);
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

Also printing the errno may be helpful

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

I think it needs to be coded like:
if (offset == ULLONG_MAX) {

Not sure why specifically checking for ERANGE, but should be checking against errno for that if needed.

DJ

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
> +> +		extent = calloc(1, sizeof(*extent));
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
> +cxl_extent_get_tag(struct cxl_region_extent *extent, uuid_t tag)
> +{
> +	memcpy(tag, extent->tag, sizeof(uuid_t));
> +}
> +
>  CXL_EXPORT struct cxl_decoder *
>  cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping)
>  {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 351da7512e05080d847fd87740488d613462dbc9..37c3531115c73cdb69b96fa47bc88bbbb901f085 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -291,4 +291,9 @@ global:
>  	cxl_memdev_trigger_poison_list;
>  	cxl_region_trigger_poison_list;
>  	cxl_region_get_region_mode;
> +	cxl_extent_get_first;
> +	cxl_extent_get_next;
> +	cxl_extent_get_offset;
> +	cxl_extent_get_length;
> +	cxl_extent_get_tag;
>  } LIBCXL_7;
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 10abfa63dfc759b1589f9f039da1b920f8eb605e..5b50b3f778a66a2266d6d5ee69e2a72cdad54a70 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -164,6 +164,7 @@ struct cxl_region {
>  	struct cxl_decoder *decoder;
>  	struct list_node list;
>  	int mappings_init;
> +	int extents_init;
>  	struct cxl_ctx *ctx;
>  	void *dev_buf;
>  	size_t buf_len;
> @@ -179,6 +180,7 @@ struct cxl_region {
>  	struct daxctl_region *dax_region;
>  	struct kmod_module *module;
>  	struct list_head mappings;
> +	struct list_head extents;
>  };
>  
>  struct cxl_memdev_mapping {
> @@ -188,6 +190,15 @@ struct cxl_memdev_mapping {
>  	struct list_node list;
>  };
>  
> +#define CXL_REGION_EXTENT_TAG 0x10
> +struct cxl_region_extent {
> +	struct cxl_region *region;
> +	u64 offset;
> +	u64 length;
> +	uuid_t tag;
> +	struct list_node list;
> +};
> +
>  enum cxl_cmd_query_status {
>  	CXL_CMD_QUERY_NOT_RUN = 0,
>  	CXL_CMD_QUERY_OK,
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 17ed682548b970d57f016942badc76dce61bdeaf..b7c85a67224c86d17a41376c147364e1f88db080 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -448,6 +448,17 @@ unsigned int cxl_mapping_get_position(struct cxl_memdev_mapping *mapping);
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
> +void cxl_extent_get_tag(struct cxl_region_extent *extent, uuid_t tag);
> +
>  struct cxl_cmd;
>  const char *cxl_cmd_get_devname(struct cxl_cmd *cmd);
>  struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);
> diff --git a/cxl/list.c b/cxl/list.c
> index 0b25d78248d5f4f529fd2c2e073e43895c722568..47d135166212b87449f960e94ee75657f7040ca9 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -59,6 +59,8 @@ static const struct option options[] = {
>  		    "include alert configuration information"),
>  	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
>  		    "include media-error information "),
> +	OPT_BOOLEAN('N', "extents", &param.extents,
> +		    "include extent information (Dynamic Capacity regions only)"),
>  	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
>  #ifdef ENABLE_DEBUG
>  	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
> @@ -135,6 +137,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.decoders = true;
>  		param.targets = true;
>  		param.regions = true;
> +		param.extents = true;
>  		/*fallthrough*/
>  	case 0:
>  		break;
> diff --git a/util/json.h b/util/json.h
> index 560f845c6753ee176f7c64b4310fe1f9b1ce6d39..79ae3240e7ce151be75f6666fcaba0ba90aba7fc 100644
> --- a/util/json.h
> +++ b/util/json.h
> @@ -21,6 +21,7 @@ enum util_json_flags {
>  	UTIL_JSON_TARGETS	= (1 << 11),
>  	UTIL_JSON_PARTITION	= (1 << 12),
>  	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
> +	UTIL_JSON_EXTENTS	= (1 << 14),
>  };
>  
>  void util_display_json_array(FILE *f_out, struct json_object *jarray,
> 

