Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812AA2D9EED
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 12:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751633689; cv=none; b=RHa0uyBCQrR1mjaXwL6mIFYUmdZJf0xZG3LRcYhoVqcFg0ksqLh/DW/4mnL9YP3O9ZtkytSqqt5ADcJhDjNxAfVpzrrxEBWnkGqqc7+T9BruVefTj5CFlY2PLcA6ulzU8enBnAdREZXjFlQ8CqeOwpejwGy81NKpje4PIKRRZEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751633689; c=relaxed/simple;
	bh=WFTveO6q4/9I10ER4OzIRFRhszAcOJqSl6IAE70OKT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0hRbmQpL+XwkLlDl7I/brJJwOXbgV8dB0TSpEY8PMmk3f9g1vwHXQwg1jzcJnwctxD26TMGEPhsIoRw5g/xsVtKgD55Fp0y7cZW3FbmAHsf45bueT/esGG34hMVLGz6ztW3wFmAWU96BH85US0/gJ3I71/i5TELvUYDP28CF7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWtIluUc; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWtIluUc"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-610db3f3f90so524058eaf.2
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 05:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751633686; x=1752238486; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fWEiBexGknF9z9JpON4CDuydmvoVyHEn0sWhDagRzsw=;
        b=jWtIluUcOoW2ZHXfnF9jFBKsmZfmOVbzyksa50AkVZDHmaOmFwKOsQuBp5sVY8CKmh
         zGO2vyIAnc9LUOp8FXGeDNSZ86ZgIUraCnaDtkkVlpUm10wCpGjQwEL8pgLQI/LwiL0F
         r/5PelBrpgoMn6LRq3hlmYfj/l2iUR8rsYSZubs0ppJeAprkqG6HyITaLjN3kQtHf/h8
         zMKOWke85bB0MNKqWWgZsjZ8KDT9nsnqfHOykQ+tq0MPnJMzesCPtJBLE5lh2OmU2CEc
         Cg5ay1lNxIKNcdDCLepO/EL4cnWLhE26MZnx8zBZgG84g0MfkkfgypwonNOSKrZAAT1h
         OJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751633686; x=1752238486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWEiBexGknF9z9JpON4CDuydmvoVyHEn0sWhDagRzsw=;
        b=K4nCEjC4sxg4+A+MiNqCRkM/xlTIQKWafT9LXacZtM4kZg7eFEYwkT77iOeTDJzFu4
         pH5KBTjzVevg/RF+UDxJCJSDchDzqI4Bzr6zrRn4nbi6CeReu8dfWogLlHWtLLzG3+Xm
         6oMpPEZdYvN+Z8AgBXoXTNNVqAZyMO3MjG+siUx93cpM0QfmIoTaT/jmN4T/oD8DA6I8
         5WmUBl2zJixWKIvYdObjdrL8WKEDns33wTRxVkJPjs4se1cx27+X/gU4J+IGafxvrClH
         g3nG+LQmb/DFbIkj+rAbr183zY8ezFkh1D673JKH+LKBM7HtCo1fXBYBqQ8w/m6iVH4n
         wapA==
X-Forwarded-Encrypted: i=1; AJvYcCUQUTmIHH5sVMUiMw9DXsW71QZxakOwXzksaMJwbP6Fz4mPY6gDMxuz002pCW6IV9nv2e+bIsA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWZjWT+ToKNk8D31gmJ5nMMW89JkgS1R48xMq1t4ohmPLo1T5s
	eDofgiWyFfTC5+9hr/nMpdM545izAcVTZlxi4/2IOBsO+mUb7h0tZeYA
X-Gm-Gg: ASbGncsbVhDNGRQp+U1+43FWQtPxhRA7xz7V0bsHH38qJZdmK99//OLVVmx62R6onkN
	vsk/BLex0uf1iXD9R8+F0hVmkr2FKN56Hsw57WZ0pKlTUOijgXzvX1unttS9btofc7VDKD8IO9e
	9t3bCUHCMvGPLJO+Lki993vcsXih/rtyUtG07e0UBVq99W693Md0mqP6hse5VDJxx2SXrKNTg44
	pxzmH98lEM02BgQ9c1Mtn5ZEZF+W65rUcXO7uOFspfCMTLeWOxs+2NLDIJqqprPU5/f56t76xwX
	Q/0fXHFE/b4X5wtExn1d0RaR9gYBic1tlt9fIh/ehn2BeLZPOUwnZ4WlF6OUksxHAYh4GOrzI4U
	=
X-Google-Smtp-Source: AGHT+IEQCt6EzoQ1S/rGkyJCcVERY+DBQiFOXPfhObXBAnuO2Eb6V1GMOP7z4zut5KZK3JQFhWGgIg==
X-Received: by 2002:a05:6820:1986:b0:611:b85f:b159 with SMTP id 006d021491bc7-6138ffa3919mr1751955eaf.1.1751633686279;
        Fri, 04 Jul 2025 05:54:46 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:2db1:5c0d:1659:a3c])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6138e5c1db3sm304526eaf.35.2025.07.04.05.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 05:54:43 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 4 Jul 2025 07:54:38 -0500
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 02/18] dev_dax_iomap: Add fs_dax_get() func to prepare
 dax for fs-dax usage
Message-ID: <or7rm2n4syer4uxaubtotarjtmmilhedih4odgiwvqb4cfkvsl@5w66of2xms5l>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-3-john@groves.net>
 <20250704113935.000028cf@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704113935.000028cf@huawei.com>

On 25/07/04 11:39AM, Jonathan Cameron wrote:
> On Thu,  3 Jul 2025 13:50:16 -0500
> John Groves <John@Groves.net> wrote:
> 
> > This function should be called by fs-dax file systems after opening the
> > devdax device. This adds holder_operations, which effects exclusivity
> > between callers of fs_dax_get().
> > 
> > This function serves the same role as fs_dax_get_by_bdev(), which dax
> > file systems call after opening the pmem block device.
> > 
> > This also adds the CONFIG_DEV_DAX_IOMAP Kconfig parameter
> > 
> > Signed-off-by: John Groves <john@groves.net>
> Trivial stuff inline.
> 
> 
> > ---
> >  drivers/dax/Kconfig |  6 ++++++
> >  drivers/dax/super.c | 30 ++++++++++++++++++++++++++++++
> >  include/linux/dax.h |  5 +++++
> >  3 files changed, 41 insertions(+)
> > 
> > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > index d656e4c0eb84..ad19fa966b8b 100644
> > --- a/drivers/dax/Kconfig
> > +++ b/drivers/dax/Kconfig
> > @@ -78,4 +78,10 @@ config DEV_DAX_KMEM
> >  
> >  	  Say N if unsure.
> >  
> > +config DEV_DAX_IOMAP
> > +       depends on DEV_DAX && DAX
> > +       def_bool y
> > +       help
> > +         Support iomap mapping of devdax devices (for FS-DAX file
> > +         systems that reside on character /dev/dax devices)
> >  endif
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index e16d1d40d773..48bab9b5f341 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -122,6 +122,36 @@ void fs_put_dax(struct dax_device *dax_dev, void *holder)
> >  EXPORT_SYMBOL_GPL(fs_put_dax);
> >  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> >  
> > +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> > +/**
> > + * fs_dax_get()
> 
> Trivial but from what I recall kernel-doc isn't going to like this.
> Needs a short description.

Right you are. I thought I'd checked all those, but missed this one.
Queued to -next.

> 
> > + *
> > + * fs-dax file systems call this function to prepare to use a devdax device for
> > + * fsdax. This is like fs_dax_get_by_bdev(), but the caller already has struct
> > + * dev_dax (and there  * is no bdev). The holder makes this exclusive.
> 
> there is no *bdev?  So * in wrong place.

I think that's a line-break-refactor malfunction on my part. Aueued to -next.

Thanks,
John

