Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B866914A4DC
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730822211; cv=none; b=eshYke3XU/hToJGNRgnrbMfpYGx331vcl8i/TVprLNwGDELP2/acKE6ZXEK7MXVt7tmkNkdbuSVGDtNVpeLddQd9ZgMWjNbQOcEA+G3osozRU0mxZGwItPldW6S6PV7IjXQh+NKDNRYyJ2dIiNk3NKu+2GGw6cuBvZNuRMHty1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730822211; c=relaxed/simple;
	bh=6zfAk9AC7DpYxfsUiZc6dqT1szs4KlvGAh2Wgs7F72k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GXeak+CppwibJkq82lZ6wfqNTHaiLWOQbtYMz37qbj4LD7XUpN6OgcGu2xIu2epMufmuSU8m1YEu+Av2hFlO9eA+ypYIJESIEXFicTas1Y7gN44couoCA5apLnLdY++3e92nIsvfEgmd3r4suKlayzXYnalCKByFoo3KTe8zA6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gNcUOpv6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gNcUOpv6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730822210; x=1762358210;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6zfAk9AC7DpYxfsUiZc6dqT1szs4KlvGAh2Wgs7F72k=;
  b=gNcUOpv6IS0x7XnNMAS0lsg709o2poUZzTjwUj4gqS/xKTy1vVxuqo5G
   gHpmaxAqca/mw/Ls/t/5L/P8P9Mz02BkzzJj43urmSVvUaKDkyZuHe0Gu
   /RjY46+HHSKj3j7I1PG9CREr4MRPe+50QH/f60iV2O2olDpStgCRKbOWF
   lINwnSn9Hv1ELiqijzXq5fBP4XCTMOdcovgVUuX6iFPfXNFWUBw+TGc+f
   O3IG7ckKmu1zvBrgz5as2LSemqHaMRLHo9KQyEYvcEy8sxthm4gkN5gZP
   ldloRf48jJDBkK74jK5nARkXGyPDXV4eqw5aJyV0L41l8tc+N3n1cOe2u
   w==;
X-CSE-ConnectionGUID: wTd2uIurQReAZadMzS6WYw==
X-CSE-MsgGUID: 2xbbqZXDQTC8SIQ34aan2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="41172796"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="41172796"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 07:56:49 -0800
X-CSE-ConnectionGUID: +8wNaFRzSFafcZZrEMFcdw==
X-CSE-MsgGUID: JkGAWsEkQTKXq6BEm/+1ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84153176"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.109.253]) ([10.125.109.253])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 07:56:48 -0800
Message-ID: <0fbce862-3629-464e-8244-b4648ba26f84@intel.com>
Date: Tue, 5 Nov 2024 08:56:47 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 3/6] ndctl: Separate region mode from decoder
 mode
To: Ira Weiny <ira.weiny@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>,
 Navneet Singh <navneet.singh@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-3-be057b479eeb@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241104-dcd-region2-v2-3-be057b479eeb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/24 7:10 PM, Ira Weiny wrote:
> With the introduction of DCD, region mode and decoder mode no longer
> remain a 1:1 relation.  An interleaved region may be made up of Dynamic
> Capacity partitions with different indexes on each of the target
> devices.
> 
> Introduce a new region mode enumeration and access function.
> 
> To maintain compatibility with existing software the region mode values
> are defined the same as the current decoder mode.  In addition
> cxl_region_get_mode() is retained.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/json.c         |  6 +++---
>  cxl/lib/libcxl.c   | 15 ++++++++++-----
>  cxl/lib/libcxl.sym |  1 +
>  cxl/lib/private.h  |  2 +-
>  cxl/libcxl.h       | 35 +++++++++++++++++++++++++++++++++++
>  5 files changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 5066d3bed13f8fcc36ab8f0ea127685c246d94d7..dcd3cc28393faf7e8adf299a857531ecdeaac50a 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -1147,7 +1147,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
>  struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  					     unsigned long flags)
>  {
> -	enum cxl_decoder_mode mode = cxl_region_get_mode(region);
> +	enum cxl_region_mode mode = cxl_region_get_region_mode(region);
>  	const char *devname = cxl_region_get_devname(region);
>  	struct json_object *jregion, *jobj;
>  	u64 val;
> @@ -1174,8 +1174,8 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  			json_object_object_add(jregion, "size", jobj);
>  	}
>  
> -	if (mode != CXL_DECODER_MODE_NONE) {
> -		jobj = json_object_new_string(cxl_decoder_mode_name(mode));
> +	if (mode != CXL_REGION_MODE_NONE) {
> +		jobj = json_object_new_string(cxl_region_mode_name(mode));
>  		if (jobj)
>  			json_object_object_add(jregion, "type", jobj);
>  	}
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 63aa4ef3acdc2fb3c4ec6c13be5feb802e817d0d..5cbfb3e7d466b491ef87ea285f7e50d3bac230db 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -431,10 +431,10 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
>  		if (!memdev)
>  			continue;
>  
> -		if (region->mode == CXL_DECODER_MODE_RAM) {
> +		if (region->mode == CXL_REGION_MODE_RAM) {
>  			if (root_decoder->qos_class != memdev->ram_qos_class)
>  				return true;
> -		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
> +		} else if (region->mode == CXL_REGION_MODE_PMEM) {
>  			if (root_decoder->qos_class != memdev->pmem_qos_class)
>  				return true;
>  		}
> @@ -619,9 +619,9 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>  
>  	sprintf(path, "%s/mode", cxlregion_base);
>  	if (sysfs_read_attr(ctx, path, buf) < 0)
> -		region->mode = CXL_DECODER_MODE_NONE;
> +		region->mode = CXL_REGION_MODE_NONE;
>  	else
> -		region->mode = cxl_decoder_mode_from_ident(buf);
> +		region->mode = cxl_region_mode_from_ident(buf);
>  
>  	sprintf(path, "%s/modalias", cxlregion_base);
>  	if (sysfs_read_attr(ctx, path, buf) == 0)
> @@ -748,11 +748,16 @@ CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
>  	return region->start;
>  }
>  
> -CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
> +CXL_EXPORT enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region)
>  {
>  	return region->mode;
>  }
>  
> +CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
> +{
> +	return (enum cxl_decoder_mode)cxl_region_get_region_mode(region);
> +}
> +
>  CXL_EXPORT unsigned int
>  cxl_region_get_interleave_ways(struct cxl_region *region)
>  {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 0c155a40ad4765106f0eab1745281d462af782fe..b5d9bdcc38e09812f26afc1cb0e804f86784b8e6 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -287,4 +287,5 @@ LIBECXL_8 {
>  global:
>  	cxl_memdev_trigger_poison_list;
>  	cxl_region_trigger_poison_list;
> +	cxl_region_get_region_mode;
>  } LIBCXL_7;
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index b6cd910e93359b53cac34427acfe84c7abcb78b0..0f45be89b6a00477d13fb6d7f1906213a3073c48 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -171,7 +171,7 @@ struct cxl_region {
>  	unsigned int interleave_ways;
>  	unsigned int interleave_granularity;
>  	enum cxl_decode_state decode_state;
> -	enum cxl_decoder_mode mode;
> +	enum cxl_region_mode mode;
>  	struct daxctl_region *dax_region;
>  	struct kmod_module *module;
>  	struct list_head mappings;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 0a5fd0e13cc24e0032d4a83d780278fbe0038d32..06b87a0924faafec6c80eca83ea7551d4e117256 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -303,6 +303,39 @@ int cxl_memdev_is_enabled(struct cxl_memdev *memdev);
>  	for (endpoint = cxl_endpoint_get_first(port); endpoint != NULL;        \
>  	     endpoint = cxl_endpoint_get_next(endpoint))
>  
> +enum cxl_region_mode {
> +	CXL_REGION_MODE_NONE = CXL_DECODER_MODE_NONE,
> +	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
> +	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
> +	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
> +};
> +
> +static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
> +{
> +	static const char *names[] = {
> +		[CXL_REGION_MODE_NONE] = "none",
> +		[CXL_REGION_MODE_MIXED] = "mixed",
> +		[CXL_REGION_MODE_PMEM] = "pmem",
> +		[CXL_REGION_MODE_RAM] = "ram",
> +	};
> +
> +	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_RAM)
> +		mode = CXL_REGION_MODE_NONE;
> +	return names[mode];
> +}
> +
> +static inline enum cxl_region_mode
> +cxl_region_mode_from_ident(const char *ident)
> +{
> +	if (strcmp(ident, "ram") == 0)
> +		return CXL_REGION_MODE_RAM;
> +	else if (strcmp(ident, "volatile") == 0)
> +		return CXL_REGION_MODE_RAM;
> +	else if (strcmp(ident, "pmem") == 0)
> +		return CXL_REGION_MODE_PMEM;
> +	return CXL_REGION_MODE_NONE;
> +}
> +
>  struct cxl_region;
>  struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_region_get_next(struct cxl_region *region);
> @@ -318,6 +351,8 @@ const char *cxl_region_get_devname(struct cxl_region *region);
>  void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
>  unsigned long long cxl_region_get_size(struct cxl_region *region);
>  unsigned long long cxl_region_get_resource(struct cxl_region *region);
> +enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region);
> +/* Deprecated: use cxl_region_get_region_mode() */
>  enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
>  unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
> 

