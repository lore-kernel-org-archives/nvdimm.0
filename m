Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D43C187FF1
	for <nvdimm@lists.linux.dev>; Wed, 28 Aug 2024 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867089; cv=none; b=gwFSgTACtKovAUex0bqXfJivhMsQm2koSFWwPQ0zsfyST1/CqLcakDGIxt/inR0OpEum4oHmwib8TomLEofEe693dtU0naumysLl2LCQzlf8/ehkXgsjs+Lw0SoBJ4tllhjaWtfdWFUAUzD0qh3HZvkidVrUJXpWMB5aEVD5FA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867089; c=relaxed/simple;
	bh=n6+tGK2JJ8RCwnvNi5/E/EJvBaNqEMlmkczhty1OK3s=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t27vCUDaHJkz7AxxlPryxRWRmFBwMorarkW+MqlFYFA0kV/h3hNG3n5gPmL+E+51ojlOW7QeLSlvWQlxmhZKIjwvvM0ARxpC2WLk3+QkX09ao0q9t2CwzYjC7WrnQ+oKHuGsMYnwTvfqTuqjEbXoVKtfm1IvIbE01HuwjoJdjCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDZx5mOk; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDZx5mOk"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e117059666eso7088565276.3
        for <nvdimm@lists.linux.dev>; Wed, 28 Aug 2024 10:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724867086; x=1725471886; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AZJymP2DyKLe/ATRTCGOZ5XowgneKVDntoDFPr0zoY4=;
        b=MDZx5mOkwge9/IVsak1ZXKbyoaLBQepYBTmK38957FGVhs6jXOSTZSu20VFJFev6Md
         CSNgRWH3GQdnr+Mzhs1FvYAlAe/n59c+U5kqok2dZD5dG8IsagllH4BEIQe0UT1S2DLb
         Cb+zgbT0zcsTblBhFfDcgGjSgQgr9oCYgDZwHiK3iauWKnBE9Of0gWLTom6sU6KyAONm
         X6bRxD7utmYtshXqADANsa6XSCbJ5KwUUKnu9S0v+MqusfzFu+7H8qexQ0mH4RtNf9JP
         ZAOpYkAWO4bm//95DV6ofS88mZzh2izUd9IU7eFnbk+qK5syXc5E11Hf0ak1bwfrBn3I
         s58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724867086; x=1725471886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZJymP2DyKLe/ATRTCGOZ5XowgneKVDntoDFPr0zoY4=;
        b=tZZFPAewdstAMkanRh92caENLn3759pS80vSREo5LpApExpKTRrj0v4YDz7TH8Xn4d
         P92tXWoCpkeHvkiOwpolXTkMQY58FgPEUjStW2o3Sd22g36HPEnl6X2WFQlolGewKYGE
         1eNcDObhrZnO/vm4pdJv81zTr1lUCvOJ8gaLW0RI/f3JRlztc3VgYPoQcUMvrRr6l+X6
         QSsrlyi1YWYrFG1eikchNWJu0iUP+vh5iJHU3aG6Q6v/c/T9RrdL8yTMb1ASZ7oz984+
         aAQHLCgR1zWd7HjLE+sFWb+fbicgAHyYw1kzbtFDhovoJZGONv3FDMY6PkqhcXtKPNMU
         eOGg==
X-Forwarded-Encrypted: i=1; AJvYcCUYLFyedMllvxpJKNjY6ZdggLMLxYF9YnTM/Km4jO2puMRYVSkfJkRKNfrwh/PGRjCmkvZRQPg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6VeJQSpQ6BYbCtkWhn6mB5JHiib2srvRKINSvrWuQLQg29/gc
	7aVSQ5v8r4ws0aS8HtGADCGUDq+Vb6wWQ5vx6tFj7UdCJ4bmtlRW
X-Google-Smtp-Source: AGHT+IEZBfH/MZ1uEjH8JqRx5ox2ojD9ltXfCmKH+SFEHbw7DEel1NgHQaCD8h9DXgl9rOOnC7TOWQ==
X-Received: by 2002:a05:6902:1204:b0:e11:7761:7be3 with SMTP id 3f1490d57ef6-e1a5ab4f8c9mr188165276.4.1724867085780;
        Wed, 28 Aug 2024 10:44:45 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e178e5698ecsm3164488276.45.2024.08.28.10.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 10:44:45 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 28 Aug 2024 10:44:30 -0700
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 19/25] cxl/region/extent: Expose region extent
 information in sysfs
Message-ID: <Zs9h_oypqqVK05H2@fan>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-19-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816-dcd-type2-upstream-v3-19-7c9b96cba6d7@intel.com>

On Fri, Aug 16, 2024 at 09:44:27AM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> Extent information can be helpful to the user to coordinate memory usage
> with the external orchestrator and FM.
> 
> Expose the details of region extents by creating the following
> sysfs entries.
> 
>         /sys/bus/cxl/devices/dax_regionX/extentX.Y
>         /sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
>         /sys/bus/cxl/devices/dax_regionX/extentX.Y/length
>         /sys/bus/cxl/devices/dax_regionX/extentX.Y/tag
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> 
> ---
> Changes:
> [iweiny: split this out]
> [Jonathan: add documentation for extent sysfs]
> [Jonathan/djbw: s/label/tag]
> [Jonathan/djbw: treat tag as uuid]
> [djbw: use __ATTRIBUTE_GROUPS]
> [djbw: make tag invisible if it is empty]
> [djbw/iweiny: use conventional id names for extents; extentX.Y]
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 13 ++++++++
>  drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 3a5ee88e551b..e97e6a73c960 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -599,3 +599,16 @@ Description:
>  		See Documentation/ABI/stable/sysfs-devices-node. access0 provides
>  		the number to the closest initiator and access1 provides the
>  		number to the closest CPU.
> +
> +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
> +		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
> +		/sys/bus/cxl/devices/dax_regionX/extentX.Y/tag
> +Date:		October, 2024
> +KernelVersion:	v6.12
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) [For Dynamic Capacity regions only]  Extent offset and
> +		length within the region.  Users can use the extent information
> +		to create DAX devices on specific extents.  This is done by
> +		creating and destroying DAX devices in specific sequences and
> +		looking at the mappings created.
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 34456594cdc3..d7d526a51e2b 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -6,6 +6,63 @@
>  
>  #include "core.h"
>  
> +static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct region_extent *region_extent = to_region_extent(dev);
> +
> +	return sysfs_emit(buf, "%#llx\n", region_extent->hpa_range.start);
> +}
> +static DEVICE_ATTR_RO(offset);
> +
> +static ssize_t length_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct region_extent *region_extent = to_region_extent(dev);
> +	u64 length = range_len(&region_extent->hpa_range);
> +
> +	return sysfs_emit(buf, "%#llx\n", length);
> +}
> +static DEVICE_ATTR_RO(length);
> +
> +static ssize_t tag_show(struct device *dev, struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct region_extent *region_extent = to_region_extent(dev);
> +
> +	return sysfs_emit(buf, "%pUb\n", &region_extent->tag);
> +}
> +static DEVICE_ATTR_RO(tag);
> +
> +static struct attribute *region_extent_attrs[] = {
> +	&dev_attr_offset.attr,
> +	&dev_attr_length.attr,
> +	&dev_attr_tag.attr,
> +	NULL,
> +};
> +
> +static uuid_t empty_tag = { 0 };
> +
> +static umode_t region_extent_visible(struct kobject *kobj,
> +				     struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct region_extent *region_extent = to_region_extent(dev);
> +
> +	if (a == &dev_attr_tag.attr &&
> +	    uuid_equal(&region_extent->tag, &empty_tag))
> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +static const struct attribute_group region_extent_attribute_group = {
> +	.attrs = region_extent_attrs,
> +	.is_visible = region_extent_visible,
> +};
> +
> +__ATTRIBUTE_GROUPS(region_extent_attribute);
> +
>  static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
>  				 struct cxled_extent *ed_extent)
>  {
> @@ -44,6 +101,7 @@ static void region_extent_release(struct device *dev)
>  static const struct device_type region_extent_type = {
>  	.name = "extent",
>  	.release = region_extent_release,
> +	.groups = region_extent_attribute_groups,
>  };
>  
>  bool is_region_extent(struct device *dev)
> 
> -- 
> 2.45.2
> 

-- 
Fan Ni
