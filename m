Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CED34C124
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 09:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782379851; cv=none; b=j/GjZHU3qiCxIIH5sw4vISMBx8autioUtjyze9uXDhRGI/1g2bI9lZ2jmr3+i6mGTQm8dr7rNdygFkJWicMVri1W2fN/ZisQb9M632wPpzb3/ouKrTfs07ZURG+LdgeHokeVShD1E4CXLqC2olJOyTLYiq7SdLUd9wDj6ryXD3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782379851; c=relaxed/simple;
	bh=JPvU71dSQPrc3LjzVKlNQDOFQK9UkA8QChKAHgibbGU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9FRRcqb8t4FFAI++bHtJMo86omNgpdZDk8FCup8lwY/EnAWR6CHUwr8PX5IpsDVjVEmN8V+3uY5ie5kE+mS2dqk+TUJcRkG+y2xrSDGbweBTo+txcrHO6/ErJjzoWSJuG2I/Gl0dd3SbkylaDu1spuEUNyCB0ve2V8pUKudBYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZ43bRws; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZ43bRws"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-304f590dd91so2420851eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 02:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782379849; x=1782984649; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ztwSylUoS9b5uLjuim9h0kX2PYWgiPXtMGVWqf0gTOY=;
        b=jZ43bRwsE9NPmw6juBhUWCZ9ruIO4HOLf/vk7n9Hmt0vBtCsYpkatRDE9GQKxZ6jFZ
         cZInI9auHMMGVIiiTpa3LMzj0WMpNvW34ci1JQ9B4GPAPQDsWzZxfDc3ltpP17fq8i26
         A6H8M2A3CAcUgOOLZKjx80yH9gv/Ogx+wTlZBlQIAm3CwDoUGTpGG1N9bS4AnzoM0txo
         vi7dPbYEbTwkOIDEVGI8bJ3dekrEqAaqC3GkHK4+qasPEXxg3dPIaBxgSDv232K2gVOT
         wWkjllbPtON1ArxBzQQPn80PM0IVRzLHlEoZOVDVt0C/BmzNy6SZ3awB1vqJxTvqoBim
         /32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782379849; x=1782984649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztwSylUoS9b5uLjuim9h0kX2PYWgiPXtMGVWqf0gTOY=;
        b=FlsLGjZZspodqdaQ0qS8oERFLn570Ff2be861TNwn0jwKvuk37iboRh5kliRhK30eV
         EjmOUjDpR0DW3OxEhPF50uxCa4WXypJkUY4FJnB9/+JD5zE8RKagyej0e2LV0hunu/BB
         jeCIgtXuvxfw9lZBtxU6SxbDm3EF9MSrhVk+qM9AFIAQlgHE6IXivsTFIE31kpvWMmY1
         /vtX71StgrvJ91ILCA6+spGMo7heuLLUVZfT5x08t40hwxVyHx/5F3/JfsG8bOhDuEwG
         lUDXbpeC7krRL/dGsCK6zBAb0IhIZFGmb5+OBhx0VwPgt1oFtHUWPe5NYXxAhFnBXmEq
         SVQQ==
X-Forwarded-Encrypted: i=1; AHgh+RqQlFbPdhos34OvSL2GB90GJD9XlWSzVqJTm63VxAguqivm5YbLoFOs8jJNLGywC7FJebE8Bbk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPxvB2B1SWvk+0DUgaRIjV7uixu6SEH7S95GNAXg0HqrGbpGXq
	pK3bOE5DijmKqB+esG/QK7Czan+8H2WD54xLE0Y92D/z1t2oTKMn1w+5
X-Gm-Gg: AfdE7ckdGlXl3582Lq4OxK4HuOAhmamJKtTRTum+QYRte/ifkFL3QZ0TintTlOrKe91
	1/ePQPV3VjE7VRP9Yg5SoWSej68Qt4L6rqqDvqc6YGG10OL0xtfKke7IkK7oxawt5X5d8X8ZCOp
	l33ctnNya5QdlF8dHUXyILBz0dMrWcuG9tfOMEdhnz9lphdtz4/ZY6SllyjQYFZiiX+r1PpV1Ph
	rMzYlpTvv4QGkxruXTI0UoXe8t51HzLX6s0O13GxA1/EAVuraIUsmcAX81cjTc+9P5OqrUgqZx9
	3erHWWQ9uPUa3frl8t4F9lGVoYI4jw2t+Byxj4GJLiznatpyvrxLHN5BYBLRku+Oh1riAGYZBrY
	Nk2KK/lh3v4pVwfKgGQluXwpH6zZhcUt/1JrzXH4eygaiYS6EGAftxGy7gS5tOLO/sISUc6f6hK
	Nhl9RWw8e5FjsEwayMvtk5QEDKo9O2o0rZ/dYC3zvrNGDjxQ8f6VntT56V/J1pFAQEEM44
X-Received: by 2002:a05:7300:3245:b0:30c:3da7:39b with SMTP id 5a478bee46e88-30c84fb35bfmr2402447eec.30.1782379849137;
        Thu, 25 Jun 2026 02:30:49 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm7242308eec.13.2026.06.25.02.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:30:48 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 25 Jun 2026 02:30:48 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v6 6/7] daxctl: Add --uuid option to create-device for
 sparse regions
Message-ID: <ajz1SIDV0JmPVLJI@AnisaLaptop.localdomain>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-7-anisa.su@samsung.com>
 <f1bf4df1-7ff2-4e13-8632-0d0c680f3629@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1bf4df1-7ff2-4e13-8632-0d0c680f3629@intel.com>

On Mon, Jun 08, 2026 at 05:12:59PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:50 AM, Anisa Su wrote:
> > Add a --uuid option to 'daxctl create-device' that writes the given
> > uuid to the new dax device's sysfs 'uuid' attribute.  On sparse (DCD)
> > regions this claims dax_resources whose tag matches and populates the
> > seed device with their capacity; size is determined by the claim, so
> > --uuid is mutually exclusive with --size.
> > 
> > Pass "0" to claim a single untagged dax_resource.  A claim that
> > matches no dax_resource leaves the device at size 0; the kernel
> > returns ENOENT.
> > 
> > Plumb the write through a new daxctl_dev_set_uuid() libdaxctl helper
> > (LIBDAXCTL_11) and document the option in the man page.
> > 
> > Signed-off-by: Anisa Su <anisa.su887@gmail.com>
> > ---
> >  Documentation/daxctl/daxctl-create-device.txt | 12 ++++
> >  daxctl/device.c                               | 72 +++++++++++++------
> >  daxctl/lib/libdaxctl.c                        | 44 ++++++++++++
> >  daxctl/lib/libdaxctl.sym                      |  5 ++
> >  daxctl/libdaxctl.h                            |  1 +
> >  5 files changed, 114 insertions(+), 20 deletions(-)
> > 
> > diff --git a/Documentation/daxctl/daxctl-create-device.txt b/Documentation/daxctl/daxctl-create-device.txt
> > index b774b86..27b87d0 100644
> > --- a/Documentation/daxctl/daxctl-create-device.txt
> > +++ b/Documentation/daxctl/daxctl-create-device.txt
> > @@ -82,6 +82,18 @@ include::region-option.txt[]
> >  
> >  	The size must be a multiple of the region alignment.
> >  
> > +	Mutually exclusive with --uuid.
> > +
> > +--uuid=::
> > +	For dax devices on sparse (DCD) regions, claim dax_resource(s) whose
> > +	tag matches the given UUID.  The device's size is determined by the
> > +	claimed capacity, so --uuid cannot be combined with --size.
> > +
> > +	A non-null UUID claims every matching dax_resource in the parent
> > +	region.  The value "0" is shorthand for the null UUID and claims a
> > +	single untagged dax_resource.  A write that matches no dax_resource
> > +	fails with ENOENT and the device is left at size 0.
> > +
> >  -a::
> >  --align::
> >  	Applications that want to establish dax memory mappings with
> > diff --git a/daxctl/device.c b/daxctl/device.c
> > index a4e36b1..21a941e 100644
> > --- a/daxctl/device.c
> > +++ b/daxctl/device.c
> > @@ -30,6 +30,7 @@ static struct {
> >  	const char *size;
> >  	const char *align;
> >  	const char *input;
> > +	const char *uuid;
> >  	bool check_config;
> >  	bool no_online;
> >  	bool no_movable;
> > @@ -85,7 +86,9 @@ OPT_BOOLEAN('C', "check-config", &param.check_config, \
> >  #define CREATE_OPTIONS() \
> >  OPT_STRING('s', "size", &param.size, "size", "size to switch the device to"), \
> >  OPT_STRING('a', "align", &param.align, "align", "alignment to switch the device to"), \
> > -OPT_STRING('\0', "input", &param.input, "input", "input device JSON file")
> > +OPT_STRING('\0', "input", &param.input, "input", "input device JSON file"), \
> > +OPT_STRING('\0', "uuid", &param.uuid, "uuid", \
> > +	"claim sparse dax_resource(s) matching this uuid (\"0\" for untagged)")
> >  
> >  #define DESTROY_OPTIONS() \
> >  OPT_BOOLEAN('f', "force", &param.force, \
> > @@ -808,6 +811,22 @@ static int do_create(struct daxctl_region *region, long long val,
> >  	struct daxctl_dev *dev;
> >  	int i, rc = 0;
> >  	long long alloc = 0;
> > +	uuid_t uuid;
> > +
> > +	if (param.uuid) {
> > +		if (param.size) {
> > +			fprintf(stderr,
> > +				"--uuid and --size are mutually exclusive\n");
> > +			return -EINVAL;
> > +		}
> > +		if (strcmp(param.uuid, "0") == 0) {
> > +			uuid_clear(uuid);
> > +		} else if (uuid_parse(param.uuid, uuid) < 0) {
> > +			fprintf(stderr, "failed to parse uuid '%s'\n",
> > +				param.uuid);
> > +			return -EINVAL;
> > +		}
> > +	}
> >  
> >  	if (daxctl_region_create_dev(region))
> >  		return -ENOSPC;
> > @@ -816,33 +835,46 @@ static int do_create(struct daxctl_region *region, long long val,
> >  	if (!dev)
> >  		return -ENOSPC;
> >  
> > -	if (val == -1)
> > -		val = daxctl_region_get_available_size(region);
> > -
> > -	if (val <= 0)
> > -		return -ENOSPC;
> > -
> >  	if (align > 0) {
> >  		rc = daxctl_dev_set_align(dev, align);
> >  		if (rc < 0)
> >  			return rc;
> >  	}
> >  
> > -	/* @maps is ordered by page_offset */
> > -	for (i = 0; i < nmaps; i++) {
> > -		rc = daxctl_dev_set_mapping(dev, maps[i].start, maps[i].end);
> > -		if (rc < 0)
> > +	if (param.uuid) {
> > +		rc = daxctl_dev_set_uuid(dev, uuid);
> > +		if (rc < 0) {
> > +			fprintf(stderr,
> > +				"%s: failed to claim uuid '%s': %s\n",
> > +				daxctl_dev_get_devname(dev), param.uuid,
> > +				strerror(-rc));
> >  			return rc;
> > -		alloc += (maps[i].end - maps[i].start + 1);
> > -	}
> > -
> > -	if (nmaps > 0 && val > 0 && alloc != val) {
> > -		fprintf(stderr, "%s: allocated %lld but specified size %lld\n",
> > -			daxctl_dev_get_devname(dev), alloc, val);
> > +		}
> >  	} else {
> > -		rc = daxctl_dev_set_size(dev, val);
> > -		if (rc < 0)
> > -			return rc;
> > +		if (val == -1)
> > +			val = daxctl_region_get_available_size(region);
> > +
> > +		if (val <= 0)
> > +			return -ENOSPC;
> > +
> > +		/* @maps is ordered by page_offset */
> > +		for (i = 0; i < nmaps; i++) {
> > +			rc = daxctl_dev_set_mapping(dev, maps[i].start,
> > +						    maps[i].end);
> > +			if (rc < 0)
> > +				return rc;
> > +			alloc += (maps[i].end - maps[i].start + 1);
> > +		}
> > +
> > +		if (nmaps > 0 && val > 0 && alloc != val) {
> > +			fprintf(stderr,
> > +				"%s: allocated %lld but specified size %lld\n",
> > +				daxctl_dev_get_devname(dev), alloc, val);
> > +		} else {
> > +			rc = daxctl_dev_set_size(dev, val);
> > +			if (rc < 0)
> > +				return rc;
> > +		}
> >  	}
> >  
> >  	rc = daxctl_dev_enable_devdax(dev);
> > diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> > index 02ae7e5..fe07939 100644
> > --- a/daxctl/lib/libdaxctl.c
> > +++ b/daxctl/lib/libdaxctl.c
> > @@ -1107,6 +1107,50 @@ DAXCTL_EXPORT int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long
> >  	return 0;
> >  }
> >  
> > +DAXCTL_EXPORT int daxctl_dev_set_uuid(struct daxctl_dev *dev, uuid_t uuid)
> > +{
> > +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> > +	char buf[SYSFS_ATTR_SIZE];
> > +	char *path = dev->dev_buf;
> > +	int len = dev->buf_len;
> > +
> > +	if (snprintf(path, len, "%s/uuid", dev->dev_path) >= len) {
> > +		err(ctx, "%s: buffer too small!\n",
> > +				daxctl_dev_get_devname(dev));
> > +		return -ENXIO;
> 
> snprintf() returns negative errno, propogate
> 
> > +	}
> > +
> > +	if (uuid_is_null(uuid))
> > +		sprintf(buf, "0\n");
> > +	else
> > +		uuid_unparse(uuid, buf);
> > +
> > +	if (sysfs_write_attr(ctx, path, buf) < 0) {
> > +		err(ctx, "%s: failed to set uuid\n",
> > +				daxctl_dev_get_devname(dev));
> > +		return -ENXIO;
> 
> propogate the errno from sysfs_write_attr()
> 
> > +	}
> > +
> > +	/*
> > +	 * On a sparse region the kernel populates the device size as a
> > +	 * side effect of claiming the matching dax_resource(s); refresh
> > +	 * the cached size so callers see the post-claim value.
> > +	 */
> > +	if (snprintf(path, len, "%s/size", dev->dev_path) >= len) {
> > +		err(ctx, "%s: buffer too small!\n",
> > +				daxctl_dev_get_devname(dev));
> > +		return -ENXIO;
> 
> propogate negative return value from snprintf()
> 
> > +	}
> > +	if (sysfs_read_attr(ctx, path, buf) < 0) {
> > +		err(ctx, "%s: failed to read back size\n",
> > +				daxctl_dev_get_devname(dev));
> > +		return -ENXIO;
> 
> propgate negative errno from sysfs_read_attr()
> 
errno propagated. For snprintf, since it returns pos rc if output was
truncated:

rc = snprintf(path, len, "%s/uuid", dev->dev_path);
if (rc < 0)
	return rc;
if (rc >= len) {
	err(ctx, "%s: buffer too small!\n",
			daxctl_dev_get_devname(dev));
	return -ENXIO;
}

> > +	}
> > +	dev->size = strtoull(buf, NULL, 0);
> > +
> > +	return 0;
> > +}
> > +
> >  DAXCTL_EXPORT unsigned long daxctl_dev_get_align(struct daxctl_dev *dev)
> >  {
> >  	return dev->align;
> > diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
> > index 3098811..16792eb 100644
> > --- a/daxctl/lib/libdaxctl.sym
> > +++ b/daxctl/lib/libdaxctl.sym
> > @@ -104,3 +104,8 @@ LIBDAXCTL_10 {
> >  global:
> >  	daxctl_dev_is_system_ram_capable;
> >  } LIBDAXCTL_9;
> > +
> > +LIBDAXCTL_11 {
> > +global:
> > +	daxctl_dev_set_uuid;
> > +} LIBDAXCTL_10;
> > diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
> > index 53c6bbd..cdd5995 100644
> > --- a/daxctl/libdaxctl.h
> > +++ b/daxctl/libdaxctl.h
> > @@ -63,6 +63,7 @@ int daxctl_dev_get_minor(struct daxctl_dev *dev);
> >  unsigned long long daxctl_dev_get_resource(struct daxctl_dev *dev);
> >  unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev);
> >  int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long size);
> > +int daxctl_dev_set_uuid(struct daxctl_dev *dev, uuid_t uuid);
> >  unsigned long daxctl_dev_get_align(struct daxctl_dev *dev);
> >  int daxctl_dev_set_align(struct daxctl_dev *dev, unsigned long align);
> >  int daxctl_dev_set_mapping(struct daxctl_dev *dev, unsigned long long start,
> 
