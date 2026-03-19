Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D42A3DE437
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773933129; cv=none; b=E+4watTbPHBbmo9woSW4M5LWXscvqihjVneBEwWmbzNDE1KOHlMzJ2dAFkw50+aaAnqNgLeO8ez+6tLu6hpkaxhQWCcH3lbsAB0Y+XH1QN6Hspsr9ec0vNBRChq9/2NYBj0QP+38ccvYni12n1fuWm/4pYX+PCTtdhhIOeX7i6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773933129; c=relaxed/simple;
	bh=CQDG8hpAyrt4e8pfDENGAaTuq0OjnAQaqEiQYCI+bOs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ds1TEIrG6QjMpAx0oM9NjDQctUkWUpYJvbZToA6115qNWrUpZnpfOw0wDhwlfc+DUa9tWd7Jngg2k7SlykYmbkj+E6bhQRaJ4+iXGN155asOGpkAuYYxJLNgV3H77MP9TYJnlOPMjdWRYpkavalHd1opGVpQZ7Q/Sp+Eo764CoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc8KL2nJ7zJ46BM;
	Thu, 19 Mar 2026 23:11:02 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id E2A9D4056A;
	Thu, 19 Mar 2026 23:12:01 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 15:12:00 +0000
Date: Thu, 19 Mar 2026 15:11:58 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <John@groves.net>
CC: Ira Weiny <ira.weiny@intel.com>, John Groves <john@jagalactic.com>, Miklos
 Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, Bernd
 Schubert <bschubert@ddn.com>, "Alison Schofield"
	<alison.schofield@intel.com>, John Groves <jgroves@micron.com>, John Groves
	<jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, "Alexander Viro"
	<viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, Christian
 Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Randy
 Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, Amir
 Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, Joanne
 Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Bagas
 Sanjaya <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V7 03/19] dax: add fsdev.c driver for fs-dax on
 character dax
Message-ID: <20260319151158.00003e37@huawei.com>
In-Reply-To: <aZSoCIjbxKIqRZF4@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
	<20260118223123.92341-1-john@jagalactic.com>
	<0100019bd33c310f-1b4a8555-bc81-4ec3-b45f-27abc01dff05-000000@email.amazonses.com>
	<698f922296bd0_bcb8910059@iweiny-mobl.notmuch>
	<aZSoCIjbxKIqRZF4@groves.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 17 Feb 2026 11:56:20 -0600
John Groves <John@groves.net> wrote:

> On 26/02/13 03:05PM, Ira Weiny wrote:
> > John Groves wrote:  
> > > From: John Groves <john@groves.net>
> > > 
> > > The new fsdev driver provides pages/folios initialized compatibly with
> > > fsdax - normal rather than devdax-style refcounting, and starting out
> > > with order-0 folios.
> > > 
> > > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > > devdax mode (device.c), which pre-initializes compound folios according
> > > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > > folios into a fsdax-compatible state.
> > > 
> > > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > > mmap capability.
> > > 
> > > In this commit is just the framework, which remaps pages/folios compatibly
> > > with fsdax.
> > > 
> > > Enabling dax changes:
> > > 
> > > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > > - dax.h: prototype inode_dax(), which fsdev needs
> > > 
> > > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > > Suggested-by: Gregory Price <gourry@gourry.net>
> > > Signed-off-by: John Groves <john@groves.net>
> > > ---
> > >  MAINTAINERS          |   8 ++
> > >  drivers/dax/Makefile |   6 ++
> > >  drivers/dax/bus.c    |   4 +
> > >  drivers/dax/bus.h    |   1 +
> > >  drivers/dax/fsdev.c  | 242 +++++++++++++++++++++++++++++++++++++++++++
> > >  fs/dax.c             |   1 +
> > >  include/linux/dax.h  |   5 +
> > >  7 files changed, 267 insertions(+)
> > >  create mode 100644 drivers/dax/fsdev.c
> > >   
> > 
> > [snip]
> >   
> > > +
> > > +static int fsdev_dax_probe(struct dev_dax *dev_dax)
> > > +{
> > > +	struct dax_device *dax_dev = dev_dax->dax_dev;
> > > +	struct device *dev = &dev_dax->dev;
> > > +	struct dev_pagemap *pgmap;
> > > +	u64 data_offset = 0;
> > > +	struct inode *inode;
> > > +	struct cdev *cdev;
> > > +	void *addr;
> > > +	int rc, i;
> > > +
> > > +	if (static_dev_dax(dev_dax))  {
> > > +		if (dev_dax->nr_range > 1) {
> > > +			dev_warn(dev, "static pgmap / multi-range device conflict\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > > +		pgmap = dev_dax->pgmap;
> > > +	} else {
> > > +		size_t pgmap_size;
> > > +
> > > +		if (dev_dax->pgmap) {
> > > +			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > > +		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
> > > +		pgmap = devm_kzalloc(dev, pgmap_size,  GFP_KERNEL);
> > > +		if (!pgmap)
> > > +			return -ENOMEM;
> > > +
> > > +		pgmap->nr_range = dev_dax->nr_range;
> > > +		dev_dax->pgmap = pgmap;
> > > +
> > > +		for (i = 0; i < dev_dax->nr_range; i++) {
> > > +			struct range *range = &dev_dax->ranges[i].range;
> > > +
> > > +			pgmap->ranges[i] = *range;
> > > +		}
> > > +	}
> > > +
> > > +	for (i = 0; i < dev_dax->nr_range; i++) {
> > > +		struct range *range = &dev_dax->ranges[i].range;
> > > +
> > > +		if (!devm_request_mem_region(dev, range->start,
> > > +					range_len(range), dev_name(dev))) {
> > > +			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
> > > +				 i, range->start, range->end);
> > > +			return -EBUSY;
> > > +		}
> > > +	}  
> > 
> > All of the above code is AFAICT exactly the same as the dev_dax driver.
> > Isn't there a way to make this common?
> > 
> > The rest of the common code is simple enough.  
> 
> dev_dax_probe() and fsdev_dax_probe() do indeed have some "same code" - 
> range validity checking and pgmap setup, from the top of probe through 
> the for loop above. After that they're different. Also, I just did a scan 
> and the probe function seems like the only remaining common code between 
> device.c and fsdev.c.
> 
> These are separate kmods; that code could certainly be factored out and 
> shared, but it would need to go somewhere common (maybe bus.c)?

Given I made a similar comment on new version. I'll reply here.
Could move it to core code, or if you want to keep stuff kmod, it's common
enough to have helper / library modules.  They are non userselectable
Kconfig options that are selected by the visible parts that need them.
Then dependency management ensures the helper gets loaded first.

> 
> So both device.c and fsdev.c would call bus.c:dax_prepare_pgmap() or
> some such.
> 
> I feel like this might not be worth factoring out, but I'm happy to do it
> if you and/or the dax team prefer it factored out and shared.

I think I'd like to see what it looks like. Maybe as a series on top.
But not my area so over to Dax folk ;)

Jonathan


> 

