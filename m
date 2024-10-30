Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5EB1BD9D9
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730310671; cv=none; b=e/Tr0Ewbnmo5LiKg1aO66HSvffgXkm658RIgHF2JIkSlre8Qj5KAyeIr+PZ9CtaEt5kHvsV3wRN7XxL9dsIhp4FG1xQrSs292EQ9+LvkG69qTm3Nu/pyz+2vGSiPZM4avjNTdYe3+UogXfWRUySJWzhQvVGfhJN+zOdQyALcuuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730310671; c=relaxed/simple;
	bh=POS7B+2UmGCT58tmhcQ34TAhYGQICIh64jfrggu4bCw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBqZvLksdEPaCQ04D4CGRt0P2rHTegiSfW0eApCwA2DQr0BCb4ixhLanbM4qsUDVNIITofXmirWfDR6KWPMrfKOjZOL4L4qfvfEtqYoliEQ7RlAiCETnYRXbngRTrpl01kp940FEe6F4rwHVqEeFLtsjFpsqSsGMZEkb3L/h7z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCTKur5k; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCTKur5k"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e29327636f3so54088276.2
        for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 10:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730310668; x=1730915468; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vjd1UA4VGq0MmOBEsoo5W+9ryin2yV9rE8tVjf4h6xE=;
        b=GCTKur5kvRC1GzVyfEjqiyLODSf4zYrihp+/iddNAdAJcfB1dK7P3H+Afx1JLdzKDc
         5OnUqK3tE+rhJzveC8Ofizvfp0G/2WzDvkTspRfDUk5h3jwgJUY/LkddIYy2gHPugpCx
         5rhtTTJ3XME7ZUfBqygKm11Bsg34Oe68PsXsMymv0qLT8ccXJa4GqlJdn90qsTS497qN
         Skjc3LmEh39AGIDVhc+oQvi5yqqCmmHchbKu7pkSYUZynvROzrvB8J9K4nP6hWjL8LbH
         YEAW9kIoYnphTHI6l3lpvivs6APbviYYy1BC/onfkOSthlbE6q08mRx05cRZFoiaiahv
         dtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730310668; x=1730915468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjd1UA4VGq0MmOBEsoo5W+9ryin2yV9rE8tVjf4h6xE=;
        b=GN/dMAv+TT8wLC6lk0aeoIbWKoPzMPpLOM7cszxOtp2Aye1iWPvNVtEgTiXZ8f0Nun
         jGNhLnyH3bBcVNob08e1JZcOxSqQk93H4Wa3ZFaqODlOerJhsYDuIlBZ0MyhRp8GFSQT
         7cS/xEKLNrGaJU/WteaTpI+lALSHVFkeLmCzaTnHG2cUvC7fel05CQK+/FGTm3c8psk9
         KV6n0G1V3xHoGLWTEeW0sGiUP3+F+0F0DjFQ9tpnccpm4Wl9Vy7hj/ZMCs4temKheY5I
         VF6BJsOEj0bo9hAnPWHolABUxLTkNKjc1v/VgBg0h5aHDlPsPYVJi/lY46ZKozcZE0Im
         7k6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVo7B5JiiVzjUE6oinbDwSo9neLmKl90rvfqv5COrTOINaDcXDHdYln1HDQ2B/GzFF1dFJjNu0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz59PKACEhh56nCzLE+LLJQkz4emH8og0Tigadp5helRSy/acD8
	ZYRv49dCxt3xCpO7sSWUNCNx8gc+qz7fj0dLEGF11FCRAm7mz0Ex
X-Google-Smtp-Source: AGHT+IF49viZLlNmCGZYukwrxpU5CVcPPngvvPYQ6NEcV7cP0EzmVdHDeL6AvsXCVVF7yCJOZDBNgQ==
X-Received: by 2002:a05:6902:c13:b0:e28:6b10:51b4 with SMTP id 3f1490d57ef6-e3087bfd66fmr16472157276.46.1730310667694;
        Wed, 30 Oct 2024 10:51:07 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e307a01fae9sm2427251276.42.2024.10.30.10.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 10:51:07 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 30 Oct 2024 10:50:40 -0700
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 13/27] cxl/mem: Expose DCD partition capabilities in
 sysfs
Message-ID: <ZyJx8FNXpy5SWaP2@fan>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-13-8739cb67c374@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029-dcd-type2-upstream-v5-13-8739cb67c374@intel.com>

On Tue, Oct 29, 2024 at 03:34:48PM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> To properly configure CXL regions on Dynamic Capacity Devices (DCD),
> user space will need to know the details of the DC partitions available.
> 
> Expose dynamic capacity capabilities through sysfs.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
> Changes:
> [Fan: Use proper str_false_true() call]

Reviewed-by: Fan Ni <fan.ni@samsung.com>

Fan
> [Jonathan: minor cleanups]
> [Bagas: Clean up documentation language]
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |  45 ++++++++++++
>  drivers/cxl/core/memdev.c               | 124 ++++++++++++++++++++++++++++++++
>  2 files changed, 169 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 3f5627a1210a16aca7c18d17131a56491048a0c2..ff3ae83477f0876c0ee2d3955d27a11fa9d16d83 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -54,6 +54,51 @@ Description:
>  		identically named field in the Identify Memory Device Output
>  		Payload in the CXL-2.0 specification.
>  
> +What:		/sys/bus/cxl/devices/memX/dcY/size
> +Date:		December, 2024
> +KernelVersion:	v6.13
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) Dynamic Capacity (DC) region information.  Devices only
> +		export dcY if DCD partition Y is supported.
> +		dcY/size is the size of each of those partitions.
> +
> +What:		/sys/bus/cxl/devices/memX/dcY/read_only
> +Date:		December, 2024
> +KernelVersion:	v6.13
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) Dynamic Capacity (DC) region information.  Devices only
> +		export dcY if DCD partition Y is supported.
> +		dcY/read_only indicates true if the region is exported
> +		read_only from the device.
> +
> +What:		/sys/bus/cxl/devices/memX/dcY/shareable
> +Date:		December, 2024
> +KernelVersion:	v6.13
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) Dynamic Capacity (DC) region information.  Devices only
> +		export dcY if DCD partition Y is supported.
> +		dcY/shareable indicates true if the region is exported
> +		shareable from the device.
> +
> +What:		/sys/bus/cxl/devices/memX/dcY/qos_class
> +Date:		December, 2024
> +KernelVersion:	v6.13
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) Dynamic Capacity (DC) region information.  Devices only
> +		export dcY if DCD partition Y is supported.  For CXL host
> +		platforms that support "QoS Telemmetry" this attribute conveys
> +		a comma delimited list of platform specific cookies that
> +		identifies a QoS performance class for the persistent partition
> +		of the CXL mem device. These class-ids can be compared against
> +		a similar "qos_class" published for a root decoder. While it is
> +		not required that the endpoints map their local memory-class to
> +		a matching platform class, mismatches are not recommended as
> +		there are platform specific performance related side-effects
> +		that may result. First class-id is displayed.
>  
>  What:		/sys/bus/cxl/devices/memX/pmem/qos_class
>  Date:		May, 2023
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 84fefb76dafabc22e6e1a12397381b3f18eea7c5..857a9dd88b20291116d20b9c0bbe9e7961f4491f 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2020 Intel Corporation. */
>  
>  #include <linux/io-64-nonatomic-lo-hi.h>
> +#include <linux/string_choices.h>
>  #include <linux/firmware.h>
>  #include <linux/device.h>
>  #include <linux/slab.h>
> @@ -449,6 +450,121 @@ static struct attribute *cxl_memdev_security_attributes[] = {
>  	NULL,
>  };
>  
> +static ssize_t show_size_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	return sysfs_emit(buf, "%#llx\n", mds->dc_region[pos].decode_len);
> +}
> +
> +static ssize_t show_read_only_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	return sysfs_emit(buf, "%s\n",
> +			  str_true_false(mds->dc_region[pos].read_only));
> +}
> +
> +static ssize_t show_shareable_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	return sysfs_emit(buf, "%s\n",
> +			  str_true_false(mds->dc_region[pos].shareable));
> +}
> +
> +static ssize_t show_qos_class_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	return sysfs_emit(buf, "%d\n", mds->dc_perf[pos].qos_class);
> +}
> +
> +#define CXL_MEMDEV_DC_ATTR_GROUP(n)						\
> +static ssize_t dc##n##_size_show(struct device *dev,				\
> +				 struct device_attribute *attr,			\
> +				 char *buf)					\
> +{										\
> +	return show_size_dcN(to_cxl_memdev(dev), buf, (n));			\
> +}										\
> +struct device_attribute dc##n##_size = {					\
> +	.attr	= { .name = "size", .mode = 0444 },				\
> +	.show	= dc##n##_size_show,						\
> +};										\
> +static ssize_t dc##n##_read_only_show(struct device *dev,			\
> +				      struct device_attribute *attr,		\
> +				      char *buf)				\
> +{										\
> +	return show_read_only_dcN(to_cxl_memdev(dev), buf, (n));		\
> +}										\
> +struct device_attribute dc##n##_read_only = {					\
> +	.attr	= { .name = "read_only", .mode = 0444 },			\
> +	.show	= dc##n##_read_only_show,					\
> +};										\
> +static ssize_t dc##n##_shareable_show(struct device *dev,			\
> +				     struct device_attribute *attr,		\
> +				     char *buf)					\
> +{										\
> +	return show_shareable_dcN(to_cxl_memdev(dev), buf, (n));		\
> +}										\
> +struct device_attribute dc##n##_shareable = {					\
> +	.attr	= { .name = "shareable", .mode = 0444 },			\
> +	.show	= dc##n##_shareable_show,					\
> +};										\
> +static ssize_t dc##n##_qos_class_show(struct device *dev,			\
> +				      struct device_attribute *attr,		\
> +				      char *buf)				\
> +{										\
> +	return show_qos_class_dcN(to_cxl_memdev(dev), buf, (n));		\
> +}										\
> +struct device_attribute dc##n##_qos_class = {					\
> +	.attr	= { .name = "qos_class", .mode = 0444 },			\
> +	.show	= dc##n##_qos_class_show,					\
> +};										\
> +static struct attribute *cxl_memdev_dc##n##_attributes[] = {			\
> +	&dc##n##_size.attr,							\
> +	&dc##n##_read_only.attr,						\
> +	&dc##n##_shareable.attr,						\
> +	&dc##n##_qos_class.attr,						\
> +	NULL									\
> +};										\
> +static umode_t cxl_memdev_dc##n##_attr_visible(struct kobject *kobj,		\
> +					       struct attribute *a,		\
> +					       int pos)				\
> +{										\
> +	struct device *dev = kobj_to_dev(kobj);					\
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);				\
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);	\
> +										\
> +	/* Not a memory device */						\
> +	if (!mds)								\
> +		return 0;							\
> +	return a->mode;								\
> +}										\
> +static umode_t cxl_memdev_dc##n##_group_visible(struct kobject *kobj)		\
> +{										\
> +	struct device *dev = kobj_to_dev(kobj);					\
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);				\
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);	\
> +										\
> +	/* Not a memory device or partition not supported */			\
> +	return mds && n < mds->nr_dc_region;					\
> +}										\
> +DEFINE_SYSFS_GROUP_VISIBLE(cxl_memdev_dc##n);					\
> +static struct attribute_group cxl_memdev_dc##n##_group = {			\
> +	.name = "dc"#n,								\
> +	.attrs = cxl_memdev_dc##n##_attributes,					\
> +	.is_visible = SYSFS_GROUP_VISIBLE(cxl_memdev_dc##n),			\
> +}
> +CXL_MEMDEV_DC_ATTR_GROUP(0);
> +CXL_MEMDEV_DC_ATTR_GROUP(1);
> +CXL_MEMDEV_DC_ATTR_GROUP(2);
> +CXL_MEMDEV_DC_ATTR_GROUP(3);
> +CXL_MEMDEV_DC_ATTR_GROUP(4);
> +CXL_MEMDEV_DC_ATTR_GROUP(5);
> +CXL_MEMDEV_DC_ATTR_GROUP(6);
> +CXL_MEMDEV_DC_ATTR_GROUP(7);
> +
>  static umode_t cxl_memdev_visible(struct kobject *kobj, struct attribute *a,
>  				  int n)
>  {
> @@ -525,6 +641,14 @@ static struct attribute_group cxl_memdev_security_attribute_group = {
>  };
>  
>  static const struct attribute_group *cxl_memdev_attribute_groups[] = {
> +	&cxl_memdev_dc0_group,
> +	&cxl_memdev_dc1_group,
> +	&cxl_memdev_dc2_group,
> +	&cxl_memdev_dc3_group,
> +	&cxl_memdev_dc4_group,
> +	&cxl_memdev_dc5_group,
> +	&cxl_memdev_dc6_group,
> +	&cxl_memdev_dc7_group,
>  	&cxl_memdev_attribute_group,
>  	&cxl_memdev_ram_attribute_group,
>  	&cxl_memdev_pmem_attribute_group,
> 
> -- 
> 2.47.0
> 

-- 
Fan Ni
