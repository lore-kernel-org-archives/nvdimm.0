Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E49142E9F
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730400568; cv=none; b=ey65DZlRgIXTs7MmY0e+jeu3dd94BzDTX8fldrvzBc/J5xXdzmkv/RUZD9QLWkp/ElL+dVoGRmSgdZ2VYMCvHmLFyAhu9HCRV3+ao+QFvLUh6nCRvP78voeKDh0NLLLDnyqpWhr2MNl5IoJ/XnpfK+qa357W3cvYMFkRoBSc4kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730400568; c=relaxed/simple;
	bh=eaG5/Gp7mEHyBJ437eTrTI4J7tRR21qxdhYzFrTuP1M=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFYnwjGoo2iE3F+RxCSx+znU4hC4cgs1YOhRSBvX5URvJKBHjpwQG9zngt4Om9jWCbGUDb+r9E73oLPx9O0Er1hRnOzykGUIRhHmPqgOBgFBK5DRU2UGUNoF5Lsf+DE3nD8FkIzbK+rvlD0F0FyZEE7mACBLlr+tZtRqWeqi+30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLPua00h; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLPua00h"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71e4244fdc6so1017045b3a.0
        for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 11:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730400564; x=1731005364; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v8b0sEcnrW5uY+7E6wxl3hd/Zr92MdiwfNYhu6ZlLBs=;
        b=XLPua00hwfWTunFADXszNh2Wp/Ba8xhaCFmSF7X3A6scF5eK4zsAtCFvIeC0p5sMEn
         DCPAISlu0022P157y6RWXor8ILEXvBuZ/O4h5WgIUGzWJrHbrlfQw2FNMh8IUB9VP9r6
         Tsr0E23Esj3DEzdqWnT28u7AQ5PXWMljwrDQf69tT6XqJJJB3GjXLc3iL9dFksQszZRH
         V458ri2oAtuX7bG6wZt0LlF39X94QIl2dPiC37K/PFDs2e9K8DZVNoCpAad0jC/JbI2U
         +koTuH8/x7OZJIvhza2a86xTdH4qNiDpHbqbJxQGwAd+XBGOrQ2WTEciv7lgPJLvb161
         Ezxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730400564; x=1731005364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8b0sEcnrW5uY+7E6wxl3hd/Zr92MdiwfNYhu6ZlLBs=;
        b=ielWkUWLZ+11ksAqhmKfivfsyDh7COyVWjyMcFpveaygvBRkvdho6nSNQyFnNu5Vf4
         /HGdI3JtkUUrbsf85ydr76MB0VWOWpbxRNqwV+W4z5Bxl/diFSN6iCB7eZjiV9gdmgSs
         txGvpKRn65hjgwUuI4iSDds7h3v35z9yCxf6WRT7Ez3LEeIOis95gZ1pZkGFEEju3x+s
         R3R2jhzTcdl8KPOM0h7uy+VfP38GciQO8aOFEnoPJfgvtabd4s43wPucx6sC/s/XhBYw
         hWMDW7c/xB91bXm848SMWfFJIOWwQQosDfWeBKCTfUOgrjxBbwmCaoBdTcF4J9Nl2v5o
         ShsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb4ZfDgeQvZGynam7veyG/n4wUl/11VYKaGMR451knfy8xv+sjO/5mYFHVEXW64tcN6ZCRZa0=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywde3C94QNOdYLms7mINaWK226mbYoqMiOnwx71qiG7S+D64wON
	ehkaiLXG14yQWHkf9sqUWheRBxgplbzaA+W1aGPbzhELu4udsY0FHO+JgQ==
X-Google-Smtp-Source: AGHT+IHVv9r7MKJjUSsXG/y+mCb5Wf82Y7SeUs0z/eAYp9wCqrgQe4bdoe5/bhoTRFKbfUlmM4a89g==
X-Received: by 2002:a05:6a21:1690:b0:1d9:1783:6a2d with SMTP id adf61e73a8af0-1dba5343d25mr735638637.13.1730400562748;
        Thu, 31 Oct 2024 11:49:22 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:1a14:7759:606e:c90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720c6a39a53sm742254b3a.178.2024.10.31.11.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 11:49:22 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 31 Oct 2024 11:49:19 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 5/6] ndctl/cxl: Add extent output to region query
Message-ID: <ZyPRL5kfoh6G37tw@fan>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
 <20241030-dcd-region2-v1-5-04600ba2b48e@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030-dcd-region2-v1-5-04600ba2b48e@intel.com>

On Wed, Oct 30, 2024 at 04:54:48PM -0500, Ira Weiny wrote:
> DCD regions have 0 or more extents.  The ability to list those and their
> properties is useful to end users.
> 
> Add extent output to region queries.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
The output looks good to me.

Tested-by: Fan Ni <fan.ni@samsung.com>

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
> index 4276b9678d7e03eaf2aec581a08450f2a0b857f2..9708ecd340d8c337a548909474ab2763ff3125da 100644
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
> -- 
> 2.47.0
> 

-- 
Fan Ni
