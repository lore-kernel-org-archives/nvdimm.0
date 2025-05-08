Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCD1286D51
	for <nvdimm@lists.linux.dev>; Thu,  8 May 2025 17:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746726900; cv=none; b=qcTbZ0LS37CUDgrPTffdsiap1hKZ0QC/0OYtefzR87XVxqjXIKcui6F/HxxnzCEzkrbDNS2d2OQ9qzzFmrlNAV0tSLcJgl1Zc9yVNUbPgWc0CsIzwv9v+G6trbIntu3I4mXabPKFJx9Akeu9NHP9DS6BWmHoMtDxy+n1BjhgQw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746726900; c=relaxed/simple;
	bh=mUehegcnR6Cjr242r+o7mAXidrZ2seC2Nvz5kNS3XDg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXTR99bMYQVKwY++GxSyPWAFn/UtLfOPl1A2FmwcywwXP7SCWJWA8vBPWIxcHgxJcDZVYHdV/BaCFTW9JgHQWb2RQKQJ/Trtxs/vRg/tstg9adk9HO/Gotv7rrmUwFbEQZgOwirrmdMSCf5dhtKuf6po6yqXDs6OgZc4iNUMAmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgcmJEjl; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgcmJEjl"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-30828fc17adso1358351a91.1
        for <nvdimm@lists.linux.dev>; Thu, 08 May 2025 10:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746726898; x=1747331698; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ReHxT5TMLmMG+C/FCKWD+QZnymtzCCWKx03I9dwE0ZU=;
        b=JgcmJEjl5VVBg97QkK4X/41WXPTqk5E/uB+vZDWQ/EEp7TYLSVsseBe/+73pM/BRtO
         Bq/P/ZQqZoPaBgQBAf+2KvDtAp/8h7g5+7F/JXerapEUEpX9lQPJLHngrHLdSsWihYEP
         T5RHp3EZ/80DHNNuMGDu0hESMZElfEr7Bc1kUz9ZYlhAidQQrsMZzevR/61xk/8X1TnP
         I5e14kcXe/lE1tpAINRk1mQI9Xt7SnDys8oH21/5Lkuugqtsm/472xYU0nqeBW1wHEmL
         HrbCfAr25WvjU8Cam/BgA58tyvOiNfwWRQ9VjNhCt9bA60fywiJXXlcpH0o0L415kpUV
         yn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746726898; x=1747331698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ReHxT5TMLmMG+C/FCKWD+QZnymtzCCWKx03I9dwE0ZU=;
        b=Ka9kpqKzToHucmQuP45jxsI0cXRbUvevgHK/bm+W4TLTyHXCVonYZlU3NBPoBwKhKg
         RL/Cv0JfaH+TzynJpDnrhQQkp0fu5M8zNBHkQ7d6hDOv6b3l8p3ZvI6mQh1sryHqPqgo
         HJn6OHsGoRBrSyZHcwZsTf0uHwc5Cho9i9Pde9Ne9T86YqlEIX6I+oWyPBd6y5tTe8+s
         6nzy8qMsoEQJwhjyyBHzjscWDmYqsHWtwUDXkLdYDYHyvukV8eDi769EjR0WzckZFIxc
         a1mCrWyIN6jypmsfy44OVUJDGGYJLyAQmwbqMkHwkJBzfWZTNNZMRcwKisY/7xr4lgn2
         SlhA==
X-Forwarded-Encrypted: i=1; AJvYcCXBsy2KKsnRx1tX9CykqpKuarSPN/37nYGf95lvdV0jaRhx3h9jDHZcOa6mQcKO4h9dXcnVyls=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRTVN0MSrGlL5oND8zYkEpdwGGl8s5dToJxBWnvotANwTFaH6w
	xFkphVbJ+FVfVu3A1XRC1CSbH5h+OguR2iiytwE7XMXC8VVtRW9I
X-Gm-Gg: ASbGncuX9XSqbYT/s1JhSk4McBuSfR7FlVWS/rhzsBUEdDs2COyaSyhE/lWqk12qNQJ
	JNihjln8oa1adVY1pz2J9xyAWlxlhKo7b9IWAlO5rJRCV+F3gyLB2CRcjznFC0za3pgot+SfTB+
	gxsnhfWco+PCPKkiZlD6N1rrQeKgAZYu3Pa0KyOvyEyK/uRsH0AwB4e+5hi+kyh1pZSUsLRF7hE
	Jww7Yi10fMxRWc8jvrwqHgvzSa7rjaWoaa3n0rnaw1XKXLbJXb0x/WZGstQsgagGIdS8u8sP4Hn
	UmIyDULeNmvRV/YGz2pSL1dnexJYbxyXsw3rzO76e5fd
X-Google-Smtp-Source: AGHT+IFbQR7a6wiK5DSx5qOvZmi9JmrE1ZzqP3veXpYqpS/3TaDp3E0Opk94zrA2WMIIaQlRDJpnjg==
X-Received: by 2002:a17:90b:164f:b0:2ff:5357:1c7e with SMTP id 98e67ed59e1d1-30c3d3eb495mr643757a91.20.1746726897560;
        Thu, 08 May 2025 10:54:57 -0700 (PDT)
Received: from smc-140338-bm01 ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30c39e61056sm262703a91.39.2025.05.08.10.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 10:54:57 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 8 May 2025 17:54:54 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 07/19] cxl/region: Add sparse DAX region support
Message-ID: <aBzv7kDIRkvgTsFG@smc-140338-bm01>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-7-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-7-1d4911a0b365@intel.com>

On Sun, Apr 13, 2025 at 05:52:15PM -0500, Ira Weiny wrote:
> Dynamic Capacity CXL regions must allow memory to be added or removed
> dynamically.  In addition to the quantity of memory available the
> location of the memory within a DC partition is dynamic based on the
> extents offered by a device.  CXL DAX regions must accommodate the
> sparseness of this memory in the management of DAX regions and devices.
> 
> Introduce the concept of a sparse DAX region.  Introduce
> create_dynamic_ram_a_region() sysfs entry to create such regions.
> Special case dynamic capable regions to create a 0 sized seed DAX device
> to maintain compatibility which requires a default DAX device to hold a
> region reference.
> 
> Indicate 0 byte available capacity until such time that capacity is
> added.
> 
> Sparse regions complicate the range mapping of dax devices.  There is no
> known use case for range mapping on sparse regions.  Avoid the
> complication by preventing range mapping of dax devices on sparse
> regions.
> 
> Interleaving is deferred for now.  Add checks.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: adjust to new partition mode and new singular dynamic ram
>          partition]
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 22 +++++++++----------
>  drivers/cxl/core/core.h                 | 11 ++++++++++
>  drivers/cxl/core/port.c                 |  1 +
>  drivers/cxl/core/region.c               | 38 +++++++++++++++++++++++++++++++--
>  drivers/dax/bus.c                       | 10 +++++++++
>  drivers/dax/bus.h                       |  1 +
>  drivers/dax/cxl.c                       | 16 ++++++++++++--
>  7 files changed, 84 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index b2754e6047ca..2e26d95ac66f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -434,20 +434,20 @@ Description:
>  		interleave_granularity).
>  
>  
> -What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram}_region
> -Date:		May, 2022, January, 2023
> -KernelVersion:	v6.0 (pmem), v6.3 (ram)
> +What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram,dynamic_ram_a}_region
> +Date:		May, 2022, January, 2023, May 2025
> +KernelVersion:	v6.0 (pmem), v6.3 (ram), v6.16 (dynamic_ram_a)
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
>  		(RW) Write a string in the form 'regionZ' to start the process
> -		of defining a new persistent, or volatile memory region
> -		(interleave-set) within the decode range bounded by root decoder
> -		'decoderX.Y'. The value written must match the current value
> -		returned from reading this attribute. An atomic compare exchange
> -		operation is done on write to assign the requested id to a
> -		region and allocate the region-id for the next creation attempt.
> -		EBUSY is returned if the region name written does not match the
> -		current cached value.
> +		of defining a new persistent, volatile, or dynamic RAM memory
> +		region (interleave-set) within the decode range bounded by root
> +		decoder 'decoderX.Y'. The value written must match the current
> +		value returned from reading this attribute.  An atomic compare
> +		exchange operation is done on write to assign the requested id
> +		to a region and allocate the region-id for the next creation
> +		attempt.  EBUSY is returned if the region name written does not
> +		match the current cached value.
>  
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 15699299dc11..08facbc2d270 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -5,6 +5,7 @@
>  #define __CXL_CORE_H__
>  
>  #include <cxl/mailbox.h>
> +#include <cxlmem.h>
>  
>  extern const struct device_type cxl_nvdimm_bridge_type;
>  extern const struct device_type cxl_nvdimm_type;
> @@ -12,9 +13,19 @@ extern const struct device_type cxl_pmu_type;
>  
>  extern struct attribute_group cxl_base_attribute_group;
>  
> +static inline struct cxl_memdev_state *
> +cxled_to_mds(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +
> +	return container_of(cxlds, struct cxl_memdev_state, cxlds);
> +}
> +
>  #ifdef CONFIG_CXL_REGION
>  extern struct device_attribute dev_attr_create_pmem_region;
>  extern struct device_attribute dev_attr_create_ram_region;
> +extern struct device_attribute dev_attr_create_dynamic_ram_a_region;
>  extern struct device_attribute dev_attr_delete_region;
>  extern struct device_attribute dev_attr_region;
>  extern const struct device_type cxl_pmem_region_type;
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index e98605bd39b4..b2bd24437484 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -334,6 +334,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
>  	&dev_attr_qos_class.attr,
>  	SET_CXL_REGION_ATTR(create_pmem_region)
>  	SET_CXL_REGION_ATTR(create_ram_region)
> +	SET_CXL_REGION_ATTR(create_dynamic_ram_a_region)
>  	SET_CXL_REGION_ATTR(delete_region)
>  	NULL,
>  };
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index c3f4dc244df7..716d33140ee8 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -480,6 +480,11 @@ static ssize_t interleave_ways_store(struct device *dev,
>  	if (rc)
>  		return rc;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A && val != 1) {
> +		dev_err(dev, "Interleaving and DCD not supported\n");
> +		return -EINVAL;
> +	}
> +
>  	rc = ways_to_eiw(val, &iw);
>  	if (rc)
>  		return rc;
> @@ -2198,6 +2203,7 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>  	if (sysfs_streq(buf, "\n"))
>  		rc = detach_target(cxlr, pos);
>  	else {
> +		struct cxl_endpoint_decoder *cxled;
>  		struct device *dev;
>  
>  		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
> @@ -2209,8 +2215,13 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>  			goto out;
>  		}
>  
> -		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
> -				   TASK_INTERRUPTIBLE);
> +		cxled = to_cxl_endpoint_decoder(dev);
> +		if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
> +		    !cxl_dcd_supported(cxled_to_mds(cxled))) {
> +			dev_dbg(dev, "DCD unsupported\n");
> +			return -EINVAL;
Should be ...?

+           rc = -EINVAL;
+           goto out;

Fan

> +		}
> +		rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
>  out:
>  		put_device(dev);
>  	}
> @@ -2555,6 +2566,7 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  	switch (mode) {
>  	case CXL_PARTMODE_RAM:
>  	case CXL_PARTMODE_PMEM:
> +	case CXL_PARTMODE_DYNAMIC_RAM_A:
>  		break;
>  	default:
>  		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
> @@ -2607,6 +2619,21 @@ static ssize_t create_ram_region_store(struct device *dev,
>  }
>  DEVICE_ATTR_RW(create_ram_region);
>  
> +static ssize_t create_dynamic_ram_a_region_show(struct device *dev,
> +						struct device_attribute *attr,
> +						char *buf)
> +{
> +	return __create_region_show(to_cxl_root_decoder(dev), buf);
> +}
> +
> +static ssize_t create_dynamic_ram_a_region_store(struct device *dev,
> +						 struct device_attribute *attr,
> +						 const char *buf, size_t len)
> +{
> +	return create_region_store(dev, buf, len, CXL_PARTMODE_DYNAMIC_RAM_A);
> +}
> +DEVICE_ATTR_RW(create_dynamic_ram_a_region);
> +
>  static ssize_t region_show(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
> @@ -3173,6 +3200,12 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
>  	struct device *dev;
>  	int rc;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
> +	    cxlr->params.interleave_ways != 1) {
> +		dev_err(&cxlr->dev, "Interleaving DC not supported\n");
> +		return -EINVAL;
> +	}
> +
>  	cxlr_dax = cxl_dax_region_alloc(cxlr);
>  	if (IS_ERR(cxlr_dax))
>  		return PTR_ERR(cxlr_dax);
> @@ -3539,6 +3572,7 @@ static int cxl_region_probe(struct device *dev)
>  	case CXL_PARTMODE_PMEM:
>  		return devm_cxl_add_pmem_region(cxlr);
>  	case CXL_PARTMODE_RAM:
> +	case CXL_PARTMODE_DYNAMIC_RAM_A:
>  		/*
>  		 * The region can not be manged by CXL if any portion of
>  		 * it is already online as 'System RAM'
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index fde29e0ad68b..d8cb5195a227 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -178,6 +178,11 @@ static bool is_static(struct dax_region *dax_region)
>  	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
>  }
>  
> +static bool is_sparse(struct dax_region *dax_region)
> +{
> +	return (dax_region->res.flags & IORESOURCE_DAX_SPARSE_CAP) != 0;
> +}
> +
>  bool static_dev_dax(struct dev_dax *dev_dax)
>  {
>  	return is_static(dev_dax->region);
> @@ -301,6 +306,9 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
>  
>  	lockdep_assert_held(&dax_region_rwsem);
>  
> +	if (is_sparse(dax_region))
> +		return 0;
> +
>  	for_each_dax_region_resource(dax_region, res)
>  		size -= resource_size(res);
>  	return size;
> @@ -1373,6 +1381,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  		return 0;
>  	if (a == &dev_attr_mapping.attr && is_static(dax_region))
>  		return 0;
> +	if (a == &dev_attr_mapping.attr && is_sparse(dax_region))
> +		return 0;
>  	if ((a == &dev_attr_align.attr ||
>  	     a == &dev_attr_size.attr) && is_static(dax_region))
>  		return 0444;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index cbbf64443098..783bfeef42cc 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -13,6 +13,7 @@ struct dax_region;
>  /* dax bus specific ioresource flags */
>  #define IORESOURCE_DAX_STATIC BIT(0)
>  #define IORESOURCE_DAX_KMEM BIT(1)
> +#define IORESOURCE_DAX_SPARSE_CAP BIT(2)
>  
>  struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		struct range *range, int target_node, unsigned int align,
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 13cd94d32ff7..88b051cea755 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -13,19 +13,31 @@ static int cxl_dax_region_probe(struct device *dev)
>  	struct cxl_region *cxlr = cxlr_dax->cxlr;
>  	struct dax_region *dax_region;
>  	struct dev_dax_data data;
> +	resource_size_t dev_size;
> +	unsigned long flags;
>  
>  	if (nid == NUMA_NO_NODE)
>  		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
>  
> +	flags = IORESOURCE_DAX_KMEM;
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
> +		flags |= IORESOURCE_DAX_SPARSE_CAP;
> +
>  	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
> -				      PMD_SIZE, IORESOURCE_DAX_KMEM);
> +				      PMD_SIZE, flags);
>  	if (!dax_region)
>  		return -ENOMEM;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
> +		/* Add empty seed dax device */
> +		dev_size = 0;
> +	else
> +		dev_size = range_len(&cxlr_dax->hpa_range);
> +
>  	data = (struct dev_dax_data) {
>  		.dax_region = dax_region,
>  		.id = -1,
> -		.size = range_len(&cxlr_dax->hpa_range),
> +		.size = dev_size,
>  		.memmap_on_memory = true,
>  	};
>  
> 
> -- 
> 2.49.0
> 

-- 
Fan Ni (From gmail)
