Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BE12B153
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708962532; cv=none; b=mnC0jBzbs2gv1OLvLxya6tMZv3thjWDCy28ld8hFlaRrhMemyy5IlLPBr5hGPl0cAy0z73smYUl00R3p5zGZKboFPpRj4SP6R/5uFcTzSBPLIG4y3JU3dukuomQLZ1/qbJhUE9iXsqbM7//mf8koh3PTj6oR/gQfFaXBJCfWsHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708962532; c=relaxed/simple;
	bh=HAFBj8+lhYpdZl1QneCB2GMGS+XvqJF/SW95VkhrC5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kH44P1Sh9dVuzG+XnVa0VBJnbD5nr0EZ4Nu88ZIuQDNcW9H8fh0NUYd4i5cK4hrTNiyuuUOv3ZfI4NXyfkwLX9vxXJpskS19rPT0GNI8Ef3r4ekbh+cH0MPHcnM+12WQLqelwg+x7TMsL6Jy3+wtISOrvTKJDvvSvkFOZRgBDJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ks/nsYr5; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ks/nsYr5"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-21ea1aae402so1677431fac.1
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 07:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708962529; x=1709567329; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g1Ef7Zrtq6omQnQLjTPEQeB7WpA4VjRn7DjZ66gvGyg=;
        b=ks/nsYr5J48piEKNFoCO61Ey2s1e57HyqSRkhgWUhRSLl9kRpjOsFDbAEUReElfu+C
         iRNCHL4akHjyPVYrruozv+8GkmUtUb6t7P4dpPx461SSgOuonqdHB74+tUXuw0lyEZLw
         lLbrUoNBaFYFN07PBtPpa6unzBmanNYDdiMcFu6kI6+PCKENyQbwO8hdOai0D2qBnlcW
         2M5iJPMotr7WGAtTzYlRdjG6Jyb1LNnmp5oQk0GLqj0oQMlABrzg9X/aWwPfv4iCiSrH
         YDXeI4tS6EBbdsbaR2gmLYZ6D71PVgJ+9qXhJSV+lHwz8dAWoB/eLxOJLlk7FS7X+ke5
         JBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708962529; x=1709567329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1Ef7Zrtq6omQnQLjTPEQeB7WpA4VjRn7DjZ66gvGyg=;
        b=f3UN/7O7FYteUHUurpNvA2bqWVHBihRjHdoIH99JQhuGoM3uZlWwBSwWQUOWoavKW7
         IbjjaDgqoKOfY3SvrKKNMXeZ4wE0OM1IcbuEjh8Y4N+0DGg/ULDoQhfNOPKZ2VUKvAuW
         tnlG5TAQLHaX/rRFJndQkOAlf5+2XAT9xKB463xcR8JCu//JDPXX8jBV6c3zqEaz8064
         Wu5hk4RMJzzry0sxXd2cRYjAUhE9zgV8/RXpzsGlGTH4PCwUyMOhi8YxAbHy2xuQptle
         qO/XDGF/DSQOOZVaEOyYbuTWcidY8UIhD81neCDSh6KNgxV36ByMJ3mnF8rNjX1lg+2B
         x2Ug==
X-Forwarded-Encrypted: i=1; AJvYcCU12uK4TJzHN4uUJczFwXsZ1c1YVCfZbFeB/BUJqqpaxx0kwQhDZcOgE990T9HnrXj/+eXDI4GMXLxTN397IRJPvG7Hzp2U
X-Gm-Message-State: AOJu0Yyaq4r+T9jMYG78lOAkpmSrzARKe3J5HdY26AlU4NCv2rhQJnAI
	7ysgVwZM9l5fFXMJ93snGr2GVYTSXhFRigA8LLa9Bn352mEPMomS
X-Google-Smtp-Source: AGHT+IHBnk/ikDk3sUqAcZtkdVfd8nz2HPMuab3RRIOBE3LZkSw4ZFujEh+N/1KdTo/PHgEe82UeRw==
X-Received: by 2002:a05:6870:709f:b0:21e:8797:95ca with SMTP id v31-20020a056870709f00b0021e879795camr9411219oae.23.1708962529545;
        Mon, 26 Feb 2024 07:48:49 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id d7-20020a9d4f07000000b006e42884bad9sm1147569otl.1.2024.02.26.07.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 07:48:48 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 09:48:46 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 04/20] dev_dax_iomap: Save the kva from memremap
Message-ID: <tngofq33j2uk7cixkiicvy73n67dkx3aqzypdrkgd6bbuusgjc@jugpgbcvgzvx>
References: <cover.1708709155.git.john@groves.net>
 <66620f69fa3f3664d955649eba7da63fdf8d65ad.1708709155.git.john@groves.net>
 <20240226122139.0000135b@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226122139.0000135b@Huawei.com>

On 24/02/26 12:21PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:48 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Save the kva from memremap because we need it for iomap rw support
> > 
> > Prior to famfs, there were no iomap users of /dev/dax - so the virtual
> > address from memremap was not needed.
> > 
> > Also: in some cases dev_dax_probe() is called with the first
> > dev_dax->range offset past pgmap[0].range. In those cases we need to
> > add the difference to virt_addr in order to have the physaddr's in
> > dev_dax->ranges match dev_dax->virt_addr.
> 
> Probably good to have info on when this happens and preferably why
> this dragon is there.

I added this paragraph:

  This happens with devdax devices that started as pmem and got converted
  to devdax. I'm not sure whether the offset is due to label storage, or
  page tables. Dan?

...which is also insufficient, but perhaps Dan or somebody else from the
dax side can correct this.

> 
> > 
> > Dragons...
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/dax-private.h |  1 +
> >  drivers/dax/device.c      | 15 +++++++++++++++
> >  2 files changed, 16 insertions(+)
> > 
> > diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> > index 446617b73aea..894eb1c66b4a 100644
> > --- a/drivers/dax/dax-private.h
> > +++ b/drivers/dax/dax-private.h
> > @@ -63,6 +63,7 @@ struct dax_mapping {
> >  struct dev_dax {
> >  	struct dax_region *region;
> >  	struct dax_device *dax_dev;
> > +	u64 virt_addr;
> 
> Why as a u64? If it's a virt address why not just void *?

Changed to void * - thanks

> 
> >  	unsigned int align;
> >  	int target_node;
> >  	bool dyn_id;
> > diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> > index 40ba660013cf..6cd79d00fe1b 100644
> > --- a/drivers/dax/device.c
> > +++ b/drivers/dax/device.c
> > @@ -372,6 +372,7 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
> >  	struct dax_device *dax_dev = dev_dax->dax_dev;
> >  	struct device *dev = &dev_dax->dev;
> >  	struct dev_pagemap *pgmap;
> > +	u64 data_offset = 0;
> >  	struct inode *inode;
> >  	struct cdev *cdev;
> >  	void *addr;
> > @@ -426,6 +427,20 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
> >  	if (IS_ERR(addr))
> >  		return PTR_ERR(addr);
> >  
> > +	/* Detect whether the data is at a non-zero offset into the memory */
> > +	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
> > +		u64 phys = (u64)dev_dax->ranges[0].range.start;
> 
> Why the cast? Ranges use u64s internally.

I've removed all the unnecessary casts in this function - thanks
for the catch

> 
> > +		u64 pgmap_phys = (u64)dev_dax->pgmap[0].range.start;
> > +		u64 vmemmap_shift = (u64)dev_dax->pgmap[0].vmemmap_shift;
> > +
> > +		if (!WARN_ON(pgmap_phys > phys))
> > +			data_offset = phys - pgmap_phys;
> > +
> > +		pr_notice("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx shift=%llx\n",
> > +		       __func__, phys, pgmap_phys, data_offset, vmemmap_shift);
> 
> pr_debug() + dynamic debug will then deal with __func__ for you.

Thanks - yeah that would be better than just taking it out...

> 
> > +	}
> > +	dev_dax->virt_addr = (u64)addr + data_offset;
> > +
> >  	inode = dax_inode(dax_dev);
> >  	cdev = inode->i_cdev;
> >  	cdev_init(cdev, &dax_fops);
> 

Thanks,
John

