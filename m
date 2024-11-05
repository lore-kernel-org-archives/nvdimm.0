Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84641FF02E
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 21:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843367; cv=none; b=jr3KJCy5/83ia0cck/Y8xIBpTn0KFPYEfzf8AHKaMm7DhGofley6WZgz4LvPbQGE2qie5DMXJi5uxHXt7JMKoEmuZMv7mgCcN++OsmY9dzelQvTEe02pvUvQuQL0ietrMRu0dYSdF3L7QvbKVvtetqxHOy28TXRjTk5NSw/2Whs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843367; c=relaxed/simple;
	bh=uepdADX0QISLUn1BGW/VY3KiOAVCENa4y+iSxapdvL0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfJ6uF2mM6SqU0QAcm3YQ9VRMYnzS9hw5tNeH+caISk8SuaadXZa8XInwXSTb1AwoiinuDrCQqofqIjc98TMT6tvn/VqtHxPGB2gIR6/Oj+rKfNZp69rPNmOpxuAhkI0eivmK1U0ZI2MFTCFqgjSGs3idFhGYoZwfqSao6O3NI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mqpJoP+2; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqpJoP+2"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e30d1d97d20so5205202276.2
        for <nvdimm@lists.linux.dev>; Tue, 05 Nov 2024 13:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730843365; x=1731448165; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AffoEbVg+BzQO0LmXocfvj5OZbNmBwaXuCZ0AlVuxDY=;
        b=mqpJoP+2laP+Xl1l3FpughruGPodWWXzzfLESIl03PopamzS7pQdjgLLsIcOgQyHZs
         r0YIfrolkLTRccG7AzUnhhQeCAPaQbI1Ihbtr6TnM8hWYlt0t/hDf0eGVWGjNqnYHj6z
         DSPlGReOrGe+XsgiuKGdZAbM22hoUDMHL2hosdCYdPIUGhK6uNvfpZnjIHM2qLgLLgtz
         G+ik/Kr9O5AdCVgZJu9gs+adpwsT+7lfNVHkUDcykp/cD6I0+Es8pRa85pe1OJoRU5oP
         9kWW2UxG3RQOgYN6AdamI5fdgtklo676wOsrTGhUyC4BaNMZf7T1KqwqsiFmcFOQ45hl
         +xGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730843365; x=1731448165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AffoEbVg+BzQO0LmXocfvj5OZbNmBwaXuCZ0AlVuxDY=;
        b=YHGpsvGJWocYzBJhz6SokaOVRBY4WlKHtEUp7MVAZDxBTtypOJP/783S5NndHSr4jX
         bKpl07qFfYcOIAzmz6aBErTfAFozLyC0+pnrb1HJVJ+92XMrlIWHLXXlaiDne9GnNO7Y
         q+0TOtgWKPrmnU4CLRLFCyUz4PxJ5pNj4Y8vzD4Dr7TESoe2ctAFRfGHzpozFiUrVCX2
         Ouac0nXUUeRFQW5VgrNsplBfvMIF50GI/iw1mxUVhSZv6BBvCqHSBrbFqkAaV+NgKi0o
         /PTwdlwp2jPQY/HJXIkdrS3+wdbUfYukpkMZmHxqhdjkBhAXvjBPPf77jSH9WY8L/pcS
         ognQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAgbty0Zo6AWe6NWsKHWWGQSUZjCp+QqPQHJ4h1RrOiE80E5gjvlZJTjeZ9eYgs+rFjsiX0CA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7eq5HI/8UWxkDztk/KFG/vKn990wZrzMQxgVoUThGtaNZuo1o
	6ovIFtylv80DUW8g7zde4iJXeVAX/H4BHvK++P3JjWs45tlCbj3E
X-Google-Smtp-Source: AGHT+IGSKgaC/PbMNH9m5CWQONEIt3xIERXZvYW5yeJtrOVJjG2ffJI31ErEtkacGsQ58/Y+gqOmtg==
X-Received: by 2002:a05:6902:18c2:b0:e30:e29b:c650 with SMTP id 3f1490d57ef6-e30e29bce52mr21215841276.9.1730843364578;
        Tue, 05 Nov 2024 13:49:24 -0800 (PST)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e30e8a94dbfsm2627197276.36.2024.11.05.13.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 13:49:24 -0800 (PST)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Tue, 5 Nov 2024 13:49:21 -0800
To: Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 3/6] ndctl: Separate region mode from decoder
 mode
Message-ID: <ZyqS4XaCjF1yNUnm@fan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-3-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-3-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:47PM -0600, Ira Weiny wrote:
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

Reviewed-by: Fan Ni <fan.ni@samsung.com>

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
> -- 
> 2.47.0
> 

-- 
Fan Ni
