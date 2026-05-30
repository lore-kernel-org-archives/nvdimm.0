Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42303859E3
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 07:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780124661; cv=none; b=QhDboRVPTBu1Jxq4DWRMOPqbfYD9gO8FUiAWh6RXWeClZEfqMxAUbH54nMyY83+nLLiEdTs82mq2gN3WXxAQ4OfnBYics2YpwJ9uMdARqom7GRcKTHGe+lD4Bcc+UxqnVz92vg1BYXbUcoVTkciiQAohteAR+WN0tkNlBNZv4Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780124661; c=relaxed/simple;
	bh=t0VZzDw7H4DgGExCYdf3UkUIWsxZNYgtIxH+MKoUtFg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M//SJtOsmoW5VU3DGZoVH/ZiFT4h1pcWGB6Yy1qhsNcqCYqhwY/DUW2eDvOzd5QVRox7d14ykkr1T5n8ta5bdzyYiuGqKDtjI2ZZKrUVvc40kj/ysuT8hl0o4Te2AtFfXt7ZXIQsaocbmOXLdXVKpJNUGs2tEU6F9/x1lFe7E5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HpSTtPp6; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HpSTtPp6"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-137c928ec7bso3022669c88.1
        for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 00:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780124659; x=1780729459; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rK0db2cDd0Xu5Ddz72nc/JipkvcMmAkxKIHL3Zwtu1U=;
        b=HpSTtPp644ujSIU8WcC4Xt4kcIHd4dlaEmztM8Bsue/jokI6zjEZjCGDr93F6Ms2hN
         Vu8aaayLKWe+/eb69IoqwrscJCWZCzO6hLVm2qCEavsiaTCj3d4S885+L4dp95y1YVvu
         eKjuB6W835GmVNOibosQgQ6lQXO2bqy+Tip8K0QG9PtlrB3cXsXDn2ZjuHMX5NzMwHoG
         tUBkX60EtAl+pFRgbXlMyzomBsPTHonAHIO2cIq7MDOra0aeeNjDf6RoBXq+bo6Hb/bL
         i9AHLCkMgDvy/VCabioJZQTaARzqwuDayrL/yJwMnPfZMSsBmNbMmSH7DRTMONgYHE/h
         96pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780124659; x=1780729459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rK0db2cDd0Xu5Ddz72nc/JipkvcMmAkxKIHL3Zwtu1U=;
        b=oT99X/upNmyr2XZxF/4vyHYBWNPCZTF1I6SEa7tgVGbIwy6oxlnWUO6A+iRXQ52Est
         WxjzEpW79N4Mch6rJu/z57BeVJE7K573TdXeSFAjxSJCziVfKnzkzkgaB4SLGUYdos4e
         DX5I0Tmxz0axL1CS+LIYDsn9BcmTHtsHXMcelAypp44ix19RADzKvs1WEmJqGx+a8ZdN
         eOp+E/7MGWAQJ4qSmxHhSi7RLvwtpkIMZbvYiZQ/KplZD7XTG+D64pzse0bA9IwE/1b+
         JWWxPdpUz2KBnFzjH2xiF32L+LBndW8SR3Xv3WPUgL5SUDyw2uhTzkIvekGiaFbYHSfp
         iV+A==
X-Forwarded-Encrypted: i=1; AFNElJ9HqeexV/VDNxraPKVaS1U12+PeT32L/3+VQ0/C7xGjB2FswOk+mLN1IZTmkg+osFma6wcRl1U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjwpG6B1PkbmXHUPHDMpyq4/xse4jMqcHMaX3/ce4JEZXw7QIM
	AgM35pw+8dmUv23+VMnfYR9lsMcqEFubT2AhIy+XO8hXfNu0kwDe6x7D
X-Gm-Gg: Acq92OGdirGkT7hmjS+DJKTUzIoxM3++EsN6Vf7mIdzG8pFZBoZrQ3NIptv8EsfUWWt
	t96fFULiTC/aph2jfSaDQiV9XlM1eam05j5i/cjd2AUIRAOOreqhQc7/oG2sLVbXdm2o26zVXvA
	bEYzAWf+JHpzQs2slhvGApocpPuoViiUYyCAMioiC011WzEuQTMFedvPJrgs8wW0v2JNHQZU0H0
	VENQXnKrTayH9IQNvl6/ZB9vFmhkXmF9REXyTBeGrAlcLo0mQ2QcaHdqj+y9Q62gBELXCHKcpOm
	08ZNVWuKC6kwSBnhYR03fO4ZZjkkica3Dm+p47LmatjmXDKOM37CXBH7jE07tQwSRsmnAZsqUHl
	rBMFC2RnM2mAmzjeU0+ybR6SJKtwDVFgANp6/mp+/OHbTtWjrTtK0SuKNMWNbQYnD49OHU/P5/3
	oBsD6WcAbWg6CGe8XTvHlzNWiSU2G7W2xqkS3lXiOkSo6e4z53/D3rLJy8A1+UIpx3CfxWZUjdE
	58r6lDHHJXiGtIRbw==
X-Received: by 2002:a05:7022:6182:b0:137:c122:572e with SMTP id a92af1059eb24-137d427166emr1270956c88.26.1780124658751;
        Sat, 30 May 2026 00:04:18 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3c69c0asm2823877c88.11.2026.05.30.00.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 00:04:18 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Sat, 30 May 2026 00:04:16 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 05/31] cxl/mem: Expose dynamic ram A partition in
 sysfs
Message-ID: <ahqL8GZ_5iJm39G8@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <45bc277b11c1aabf495132925c0d75c78e3b5a8a.1779528761.git.anisa.su@samsung.com>
 <df99e0c6-e571-4dba-a8c4-2a8ecbb47c34@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df99e0c6-e571-4dba-a8c4-2a8ecbb47c34@intel.com>

On Wed, May 27, 2026 at 04:56:34PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:42 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > To properly configure CXL regions user space will need to know the
> > details of the dynamic ram partition.
> > 
> > Expose the first dynamic ram partition through sysfs.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes:
> > [anisa: Update kernel version to 7.0]
> > [davidlohr: Remove "persistent" from description of
> > /sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class]
> > ---
> >  Documentation/ABI/testing/sysfs-bus-cxl | 24 +++++++++++
> >  drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > index 16a9b3d2e2c0..3d95c325f6e0 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > @@ -89,6 +89,30 @@ Description:
> >  		and there are platform specific performance related
> >  		side-effects that may result. First class-id is displayed.
> >  
> > +What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/size
> > +Date:		May, 2025
> > +KernelVersion:	v7.0
> 
> Probably should update this to 7.3 maybe?
> 
Updated
> DJ
> 
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) The first Dynamic RAM partition capacity as bytes.
> > +
> > +
> > +What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class
> > +Date:		May, 2025
> > +KernelVersion:	v7.0
Also updated

Thanks,
Anisa
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) For CXL host platforms that support "QoS Telemmetry"
> > +		this attribute conveys a comma delimited list of platform
> > +		specific cookies that identifies a QoS performance class
> > +		for the partition of the CXL mem device. These
> > +		class-ids can be compared against a similar "qos_class"
> > +		published for a root decoder. While it is not required
> > +		that the endpoints map their local memory-class to a
> > +		matching platform class, mismatches are not recommended
> > +		and there are platform specific performance related
> > +		side-effects that may result. First class-id is displayed.
> > +
> >  
> >  What:		/sys/bus/cxl/devices/memX/serial
> >  Date:		January, 2022
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index 71602820f896..064cfd628577 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> > @@ -101,6 +101,19 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
> >  static struct device_attribute dev_attr_pmem_size =
> >  	__ATTR(size, 0444, pmem_size_show, NULL);
> >  
> > +static ssize_t dynamic_ram_a_size_show(struct device *dev, struct device_attribute *attr,
> > +			      char *buf)
> > +{
> > +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
> > +
> > +	return sysfs_emit(buf, "%#llx\n", len);
> > +}
> > +
> > +static struct device_attribute dev_attr_dynamic_ram_a_size =
> > +	__ATTR(size, 0444, dynamic_ram_a_size_show, NULL);
> > +
> >  static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
> >  			   char *buf)
> >  {
> > @@ -443,6 +456,25 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
> >  	NULL,
> >  };
> >  
> > +static ssize_t dynamic_ram_a_qos_class_show(struct device *dev,
> > +				   struct device_attribute *attr, char *buf)
> > +{
> > +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > +
> > +	return sysfs_emit(buf, "%d\n",
> > +			  part_perf(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)->qos_class);
> > +}
> > +
> > +static struct device_attribute dev_attr_dynamic_ram_a_qos_class =
> > +	__ATTR(qos_class, 0444, dynamic_ram_a_qos_class_show, NULL);
> > +
> > +static struct attribute *cxl_memdev_dynamic_ram_a_attributes[] = {
> > +	&dev_attr_dynamic_ram_a_size.attr,
> > +	&dev_attr_dynamic_ram_a_qos_class.attr,
> > +	NULL,
> > +};
> > +
> >  static ssize_t ram_qos_class_show(struct device *dev,
> >  				  struct device_attribute *attr, char *buf)
> >  {
> > @@ -519,6 +551,29 @@ static struct attribute_group cxl_memdev_pmem_attribute_group = {
> >  	.is_visible = cxl_pmem_visible,
> >  };
> >  
> > +static umode_t cxl_dynamic_ram_a_visible(struct kobject *kobj, struct attribute *a, int n)
> > +{
> > +	struct device *dev = kobj_to_dev(kobj);
> > +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
> > +
> > +	if (a == &dev_attr_dynamic_ram_a_qos_class.attr &&
> > +	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> > +		return 0;
> > +
> > +	if (a == &dev_attr_dynamic_ram_a_size.attr &&
> > +	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)))
> > +		return 0;
> > +
> > +	return a->mode;
> > +}
> > +
> > +static struct attribute_group cxl_memdev_dynamic_ram_a_attribute_group = {
> > +	.name = "dynamic_ram_a",
> > +	.attrs = cxl_memdev_dynamic_ram_a_attributes,
> > +	.is_visible = cxl_dynamic_ram_a_visible,
> > +};
> > +
> >  static umode_t cxl_memdev_security_visible(struct kobject *kobj,
> >  					   struct attribute *a, int n)
> >  {
> > @@ -547,6 +602,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
> >  	&cxl_memdev_attribute_group,
> >  	&cxl_memdev_ram_attribute_group,
> >  	&cxl_memdev_pmem_attribute_group,
> > +	&cxl_memdev_dynamic_ram_a_attribute_group,
> >  	&cxl_memdev_security_attribute_group,
> >  	NULL,
> >  };
> > @@ -555,6 +611,7 @@ void cxl_memdev_update_perf(struct cxl_memdev *cxlmd)
> >  {
> >  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_ram_attribute_group);
> >  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_pmem_attribute_group);
> > +	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_dynamic_ram_a_attribute_group);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_perf, "CXL");
> >  
> 
