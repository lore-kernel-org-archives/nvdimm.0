Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4436378825
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 05:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781243895; cv=none; b=QGu0N92ZegWOzxc/tA4xETrTbu8W4Cgv7TNXM2exsKZPz0856tNoevC98ACWDAwnvv00oQiug0asZ9mFgKysOL7Bu4YhsAXB5Hgerb7VOQwvKL/DaWnpe4IlOiGFLG4eD38hhk91sRNn1O87Lj9DRGmmOtdzqkpqKSVGvsu8CL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781243895; c=relaxed/simple;
	bh=2fXynrJ0y2VtFuh+yhOsjBs9aaoCu4OUI3rXHh9kyvg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X30ZYYKCLUK0ryjbUJs0zlgPsaUsZ77jQNZzycXuiAGqzJQ5XfPFlEVk4GeXtMOOb+FgJoIZqFo0aONA8g8zdXmn6tIWiCZmpCLG+JWPvVmjr1GckQwZr2NQY9kGt37PRJGZ4KFBfLYBEFeKb39j7Lr9U+dyPKavsOvUSlxm5wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pmA3gINm; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pmA3gINm"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-137dd523634so927299c88.1
        for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 22:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781243893; x=1781848693; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fwbrydugeAdaiQhvmDZSq+wpz/V9WJz4F5NXtcyhmdI=;
        b=pmA3gINmq2Yv5cIyycDybXZhqyY4RlivTQk5U/ans3hgZqfgXYxldtIymNkywRCfvS
         29BGD/YsYcZiJ9LLAZ3VITeyIHZ9nEc9aRYwAu+Jxw/ei/8+OV7zdKjqIKgLuFZbOfK9
         K3Pnzo1+KcEuvp3YkTlaJGx9fxeMoUui+/bnLOqZH+OVUT3foh4IZpjES4klWiALOpvE
         ubP+r73DgsuwVo2FyibTqwRCZ+bdBt9b/vdmNxRxOOV5bIXbN1ykvEnVSFdJRU9a1zY1
         bRMrO4S/2upszko8YfjYlGYSy/nGcrAPmQgIaJVtsg458aZtCYbniY7i7uRBQNNZECih
         JeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781243893; x=1781848693;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fwbrydugeAdaiQhvmDZSq+wpz/V9WJz4F5NXtcyhmdI=;
        b=MnkkBnZE9rfTVjZ4xgCyGjzjvOIGe0SxTiEeIP7nCcmCyEsTIIe8qroAYJJSTrrL1+
         iB0vWTu7xQlSHAD8qpQ0uZbB6+Q6bm5RQCQXEu02SD6zbefFWbKNDRX6htpclY5JBpsW
         2Q1MeHTY0YAxoi2gHyXwJjqpvwdswnmFpEFADGYKiJ9qqoA31Y7ItSe3XurxSpeGN8xi
         mlh0My+b1EK7VM2O8GteSbY/OT4Onbr4pdFZTczh5D1hhbxU1Cdx33OM7UH/IbEbiLNr
         zualgegpz12mHb72mI7v/qDKkvvSlHBkoZoLB/W9YMAKZWESh7xyvxzjqpMwynPWYssk
         wAFw==
X-Forwarded-Encrypted: i=1; AFNElJ9Q5zM3Yv5FyTn3PWZn5uCPgIUnv5X8Zl6UqYY84Gx7WGhbIrhLhrC90HT6pyPiMbl0KGuTI04=@lists.linux.dev
X-Gm-Message-State: AOJu0YwADS5cOtZFD28vbmpOe3xc69kq2NwLupS2n3zmzsrd74htox4s
	1656V9FCJseYY0Gs4oXwk6RBd96KDW2y+w1TAiV+mjLl1JXg3U1Ogfb7
X-Gm-Gg: Acq92OFjz5lrhi35jlRXJsbM7lMVh3SnYnQZvf9hzSK7sw8wTd1IHN9hvY//eCNa0Vc
	txGiZZWGltZoUhMKNDDQCvJlSB+asYAlHuDMZi8cb14I9Tn1veuf+tM8JSJrCcnJbDKtImIxhb9
	ZA0EREyvTGaGpKX3yJK9O37JH9Yn7gNIKp3ojnpieQeMP/pgQmHe2Iqrs3JHeN6Uf8x7XngoW4H
	KSSPdJ7Ec/kDmTsW9dr32P2Q3Z79yHuu6K+/7tIrjqoH45XvC5BRrCUqPzPuVBtRADcStkXohXn
	igYur8ddcDrZ/x9xrRObDzPy5RtCIjGWAbQIRNSAHgYI0nkORQjLaipT1A4yrTmIUCMyvAZ/bH2
	fysFIE/HdwF6UwUi5EqKVLXNj5PpU1PuRclJnxYsXg7i0XjGLk9Q37GVoL/vwZJFKZ+17z7ngWf
	7M7sSO5C4f90OYCgx/u4Wo+rwK1Q/2lJ8k2Ma398IOBIk2PnXQzvf4Oh40j7lBsM4E/rxw0aQy6
	xzMd7E=
X-Received: by 2002:a05:7022:607:b0:132:5d42:55ba with SMTP id a92af1059eb24-1384bb00787mr539158c88.16.1781243892677;
        Thu, 11 Jun 2026 22:58:12 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b916b2bsm1150858c88.6.2026.06.11.22.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 22:58:11 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 11 Jun 2026 22:58:09 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: Re: [PATCH v10 20/31] cxl/region/extent: Expose dc_extent
 information in sysfs
Message-ID: <aiuf8QDN_MvUf_WI@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <52f5a9ba175424c0f0a181e32ed6c04f26993d96.1779528761.git.anisa.su@samsung.com>
 <e29c7d64-4ea1-4fe6-b47b-2141a832f5a8@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e29c7d64-4ea1-4fe6-b47b-2141a832f5a8@intel.com>

On Thu, May 28, 2026 at 03:54:34PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Extent information can be helpful to the user to coordinate memory
> > usage with the external orchestrator and FM.
> > 
> > Expose the details of each dc_extent by creating the following sysfs
> > entries.
> > 
> > 	/sys/bus/cxl/devices/dax_regionX/extentX.Y
> > 	/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
> > 	/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
> > 	/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid
> > 
> > Each dc_extent surfaces as its own extentX.Y device under the parent
> > dax_region.  offset and length describe that dc_extent's HPA range,
> > not an aggregate bounding box across the containing tagged
> > allocation — so when a tagged allocation has multiple
> > DPA-discontiguous extents, each is reported with its own offset and
> > length.  uuid is the tag identifying the containing allocation; it
> > is shared across dc_extents that belong to the same tagged
> > allocation and is hidden for untagged extents.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Reviewed-by: Fan Ni <fan.ni@samsung.com>
> > Tested-by: Fan Ni <fan.ni@samsung.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> Missing Anisa sign off
> 
added
> > ---
> >  Documentation/ABI/testing/sysfs-bus-cxl | 36 +++++++++++++++
> >  drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++
> >  2 files changed, 94 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > index 3080aef9ad67..38cf0a2894b9 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > @@ -661,3 +661,39 @@ Description:
> >  		The count is persistent across power loss and wraps back to 0
> >  		upon overflow. If this file is not present, the device does not
> >  		have the necessary support for dirty tracking.
> > +
> > +
> > +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
> > +Date:		May, 2025
> > +KernelVersion:	v6.16
> 
> Update date and kernel version for all
> 
updated
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) [For Dynamic Capacity regions only] Users can use the
> > +		extent information to create DAX devices on specific extents.
> > +		This is done by creating and destroying DAX devices in specific
> > +		sequences and looking at the mappings created.  Extent offset
> > +		within the region.
> > +
> > +
> > +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
> > +Date:		May, 2025
> > +KernelVersion:	v6.16
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) [For Dynamic Capacity regions only] Users can use the
> > +		extent information to create DAX devices on specific extents.
> > +		This is done by creating and destroying DAX devices in specific
> > +		sequences and looking at the mappings created.  Extent length
> > +		within the region.
> > +
> > +
> > +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid
> > +Date:		May, 2025
> > +KernelVersion:	v6.16
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) [For Dynamic Capacity regions only] Users can use the
> > +		extent information to create DAX devices on specific extents.
> > +		This is done by creating and destroying DAX devices in specific
> > +		sequences and looking at the mappings created.  UUID of this
> > +		extent.
> > diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> > index f66fa8c600c5..34babfe032d1 100644
> > --- a/drivers/cxl/core/extent.c
> > +++ b/drivers/cxl/core/extent.c
> > @@ -6,6 +6,63 @@
> >  
> >  #include "core.h"
> >  
> > +static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
> > +			   char *buf)
> > +{
> > +	struct dc_extent *dc_extent = to_dc_extent(dev);
> > +
> > +	return sysfs_emit(buf, "%#llx\n", dc_extent->hpa_range.start);
> > +}
> > +static DEVICE_ATTR_RO(offset);
> > +
> > +static ssize_t length_show(struct device *dev, struct device_attribute *attr,
> > +			   char *buf)
> > +{
> > +	struct dc_extent *dc_extent = to_dc_extent(dev);
> > +	u64 length = range_len(&dc_extent->hpa_range);
> > +
> > +	return sysfs_emit(buf, "%#llx\n", length);
> > +}
> > +static DEVICE_ATTR_RO(length);
> > +
> > +static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
> > +			 char *buf)
> > +{
> > +	struct dc_extent *dc_extent = to_dc_extent(dev);
> > +
> > +	return sysfs_emit(buf, "%pUb\n", &dc_extent->group->uuid);
> > +}
> > +static DEVICE_ATTR_RO(uuid);
> > +
> > +static struct attribute *dc_extent_attrs[] = {
> > +	&dev_attr_offset.attr,
> > +	&dev_attr_length.attr,
> > +	&dev_attr_uuid.attr,
> > +	NULL
> > +};
> > +
> > +static uuid_t empty_uuid = { 0 };
> > +
> > +static umode_t dc_extent_visible(struct kobject *kobj,
> > +				 struct attribute *a, int n)
> > +{
> > +	struct device *dev = kobj_to_dev(kobj);
> > +	struct dc_extent *dc_extent = to_dc_extent(dev);
> > +
> > +	if (a == &dev_attr_uuid.attr &&
> > +	    uuid_equal(&dc_extent->group->uuid, &empty_uuid))'
> 
> uuid_is_null() can be used?
> 
oh yeah oops... replaced w/uuid_is_null()

> DJ
> 
Thanks,
Anisa
> > +		return 0;
> > +
> > +	return a->mode;
> > +}
> > +
> > +static const struct attribute_group dc_extent_attribute_group = {
> > +	.attrs = dc_extent_attrs,
> > +	.is_visible = dc_extent_visible,
> > +};
> > +
> > +__ATTRIBUTE_GROUPS(dc_extent_attribute);
> > +
> >  
> >  static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
> >  				 struct dc_extent *dc_extent)
> > @@ -93,6 +150,7 @@ static void dc_extent_release(struct device *dev)
> >  static const struct device_type dc_extent_type = {
> >  	.name = "extent",
> >  	.release = dc_extent_release,
> > +	.groups = dc_extent_attribute_groups,
> >  };
> >  
> >  bool is_dc_extent(struct device *dev)
> 
