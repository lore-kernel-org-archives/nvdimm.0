Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5681E22F5
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728506799; cv=none; b=Rree5TEMmjTocB0togZjqb5UC1SQtz821eCYxG3qtSbb84gHWHHZY0ttWiozvS2Zh7Iw21GZn4sbrwmzhtcF6SSo4OqImcz+hjqKPhUA4uYoQE5p+Rlj18sDDnPAzE1ryCbsHRCELbkLzWsSBZJcmK5oWgdm1TjpUcqQlStizYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728506799; c=relaxed/simple;
	bh=Qz2j/PP1lOLYfkIT8rGz6zxJ0SpWVcP9cqhxdmqDxdU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+yQf1odwK6BJJsmcaLNZqXloDYoUBOdZwZz/O3zlHb+QGjIPkmrr8F7LtutFz1p9xoJ8SPILjYwuxRTAhv+1WHpRq+6qQWm4C0wgClTURp4dp5EOLx/0e0Di48qc/3jAzjRlR0RrJr0Ix8v3OzHCW7DGSd8WL3lejEMURVylAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXMilpbW; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXMilpbW"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6e2fef23839so2642667b3.2
        for <nvdimm@lists.linux.dev>; Wed, 09 Oct 2024 13:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728506795; x=1729111595; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vLyjlujieScv3UgYNOTdCR9B2JU1g3jTaSo//GoTfjk=;
        b=CXMilpbWn1Xdk2u3G1PgXBziKRgzQKrsB/TF0xd/BTSqKzOQl7Xc54fSKtUAKEZvNr
         jv3wr5jPP985JEzcJFGGZV/1nIc2m31SOtGuQGX0NKYyFVe+fzIu42fz7WjcbX/XkrYZ
         4IpHDMtHfU258XaJiGjXITWSxn6cqa02Q7l08JNwtjp5owW5azf/OC8Ir+XEeCo/ZJT9
         OGeDR6YN/SS58jqZxUK3j6O2MUmoO2xKwzqGhtc4YYVAqDd/6sL4FGvMsKC1iGGNxXkc
         4nySgOUe/vg09c6+i6IdSGgaLNGEirNTB9ynbIt7Su+4f9vZYLLnlCTod+4Osbrqxrlk
         5IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728506795; x=1729111595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLyjlujieScv3UgYNOTdCR9B2JU1g3jTaSo//GoTfjk=;
        b=tPs7XwGf0MwLynqNxJDL0CLOJdspnm8UpfsEF7YRSauA3+s/cNMN2dNVymZA+8M/A3
         V1o0HdPhaKCYapnB/SpXfu26oBw9xJcBq+4n+ddYXFDzFq90n/yflR3CRNEdXPmSwPjY
         AUBX77ZrGahWaBxwwA26T35sRllFbkFTU27u8IZr3X5zaqylaXaSOpHBbsO7UBIp7OVx
         YZHJYXvpGZzpPhsDPhnQORxhvJ5YZC0Z0AMr0uOm+709PbqfBl4hYhrrIXebho05zV0G
         MziZSjMoEpXg4MyYWTWZFM888KZjUwb6oZqqAFgxi9S+X8L3lC/66xzsVtasKadoIRMg
         mghw==
X-Forwarded-Encrypted: i=1; AJvYcCXVfTUfNlILNFZ0vsLL0LFn/59fIEClLcA41Y5Ms8d4vzc+MeMNn1QmAS1sAHphGX+de7ua14s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPkSzLqMZPQWA8tZUNGmloDNLtTlRViWp5slP6SDhrB0WnwvHf
	EQKBQg1/gXEY2F3O4Yws3vbmHnbKAJ2OtVMktnCBVw4mreXB3Fff
X-Google-Smtp-Source: AGHT+IFf4sz0TRbyD8Yi6n4r3mk7Izok61UXQMKHBV9h+m6UNoJBfctWfVmJRgfhGF7zrm5BJMEVaQ==
X-Received: by 2002:a05:690c:640d:b0:6e3:2e20:a03c with SMTP id 00721157ae682-6e32e20a24cmr20593397b3.26.1728506795085;
        Wed, 09 Oct 2024 13:46:35 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e2d93d40c8sm20479477b3.83.2024.10.09.13.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 13:46:34 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 9 Oct 2024 13:46:19 -0700
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 13/28] cxl/mem: Expose DCD partition capabilities in
 sysfs
Message-ID: <Zwbrm690XW_8ImRW@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-13-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-13-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:19PM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> To properly configure CXL regions on Dynamic Capacity Devices (DCD),
> user space will need to know the details of the DC partitions available.
> 
> Expose dynamic capacity capabilities through sysfs.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: Change .../memX/dc/* to .../memX/dcY/*]
> [iweiny: add read only and shareable attributes from DSMAS]
> [djiang: Split sysfs docs]
> [iweiny: Adjust sysfs doc dates]
> [iweiny: Add qos details]
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |  45 ++++++++++++
>  drivers/cxl/core/memdev.c               | 126 ++++++++++++++++++++++++++++++++
>  2 files changed, 171 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 3f5627a1210a..b865eefdb74c 100644
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
> +		a matching platform class, mismatches are not recommended and
> +		there are platform specific performance related side-effects
> +		that may result. First class-id is displayed.
>  
>  What:		/sys/bus/cxl/devices/memX/pmem/qos_class
>  Date:		May, 2023
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 84fefb76dafa..2565b10a769c 100644
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
> @@ -449,6 +450,123 @@ static struct attribute *cxl_memdev_security_attributes[] = {
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
> +			  str_false_true(mds->dc_region[pos].read_only));

For this function and below, why str_false_true instead of
str_true_false??

Fan
> +}
> +
> +static ssize_t show_shareable_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	return sysfs_emit(buf, "%s\n",
> +			  str_false_true(mds->dc_region[pos].shareable));
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
> +	NULL,									\
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
> +	if (!mds || n >= mds->nr_dc_region)					\
> +		return false;							\
> +	return true;								\
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
> @@ -525,6 +643,14 @@ static struct attribute_group cxl_memdev_security_attribute_group = {
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
> 2.46.0
> 

-- 
Fan Ni
