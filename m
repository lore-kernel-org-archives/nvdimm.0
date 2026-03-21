Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBC019046E
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 00:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774053917; cv=none; b=Gr3vceFfAPoOWT+Fo3sK0kRNYOcyZSYvv/YKCe8np2TAG2jYLWhbZvOw9tIUGLFdKUXCoJbSVaqpDK1TylKX9Ki/zuRabwjp25M7gFxL7jrB/ItjErxFt4SEqYbDCgoL7UWv7p0H61tma/IFgMLTlnvKG8TDgz2/oD7hqe01tsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774053917; c=relaxed/simple;
	bh=wRg7rsaeRuAQSS/qCm0lX3GbzJ1kz5rh+jVQ/ORSHdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLbOlyv0jsoAasNx7qnivUoxgqv16rwIfnLM91kK5YHaIr+e/yjRTiype22brvCLgM58mNtQba2l40tY1iuZtq3mG9R/VUcsThZ7hhkTh/6QBdkTVWj5lYGOq7Ctp2TrpMponwNuIzh/yLhTu5+aVXBMhtTpFzpR9CrcX9c3ucQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43630B8D4A;
	Sat, 21 Mar 2026 00:45:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf01.hostedemail.com (Postfix) with ESMTPA id 052D36001F;
	Sat, 21 Mar 2026 00:44:57 +0000 (UTC)
Date: Fri, 20 Mar 2026 19:44:56 -0500
From: John Groves <john@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V8 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <ab3nFoKxirEgoS_v@groves.net>
References: <20260318202737.4344.dax@groves.net>
 <20260319012837.4443-1-john@groves.net>
 <20260319122057.00004503@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319122057.00004503@huawei.com>
X-Stat-Signature: shg1e48hyfycmiemhtwsrtiegqfhpwma
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 052D36001F
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+FqMoIr7feGjW7aclNJbDLBdE0GR9Ig9k=
X-HE-Tag: 1774053897-27139
X-HE-Meta: U2FsdGVkX1887YkisgdyGegKjqhVxo4pESgLdaZIC/5VCKoyMRIrSwmRs8Jbqk6QJT7dVIDxA7uLOsfFAaOcIA0PhtbikBH1DvPAK2GJDIrcAzV5BANyv2c8Zhml0bXlVaeKpgrobXDiIlA+/K/Lm4YmGMz9Asj/N0Zgk3U9QwI/osODb056YwaE2ez5vVuaYKLczXTAHcR2KvQZzjzDFvOk1hRy97XMryUfNQ8R22dKJWZD6bOh4i0LueMvAYfE0/WSe9SlkwfwgQQ7wx+F3cYVc/mH6xrsaNxU1XNUGIn7HnpMo/gOGefbh8B+K7Y0oyC47qHrUVzgijvql7pURRuXWfH7X6Mqz8qUJOzCyM3wJS0Nws9C/yaLmkTXZl0l0C865ZXGtz04FMZ8x9hNDGaDPGkZM5J3mmwg4PnyfENbYsmFhJhWTOUKyQL1KPaKD5Tte8q34Kmm8u0dAMpw8yY6Gfd9wgqf0AuZdRD7PMhX+sfYDAFLUg03q9IFC5heNyBl8wpnKpE8GR4Fwq/LVnzs1nBqjRzWt7ij2O8MFg9Ohr4Jbq0sTvhYGrEqYeWs

On 26/03/19 12:20PM, Jonathan Cameron wrote:
> On Wed, 18 Mar 2026 20:28:37 -0500
> John Groves <john@groves.net> wrote:
> 
> > The new fsdev driver provides pages/folios initialized compatibly with
> > fsdax - normal rather than devdax-style refcounting, and starting out
> > with order-0 folios.
> > 
> > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > devdax mode (device.c), which pre-initializes compound folios according
> > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > folios into a fsdax-compatible state.
> > 
> > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > mmap capability.
> > 
> > In this commit is just the framework, which remaps pages/folios compatibly
> > with fsdax.
> > 
> > Enabling dax changes:
> > 
> > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > - dax.h: prototype inode_dax(), which fsdev needs
> > 
> > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > Suggested-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: John Groves <john@groves.net>
> 
> A few comments inline.  I think some of the code here could be moved
> to a helper library used by both this and device.c
> 
> > ---
> >  MAINTAINERS          |   8 ++
> >  drivers/dax/Makefile |   6 +
> >  drivers/dax/bus.c    |   4 +
> >  drivers/dax/bus.h    |   1 +
> >  drivers/dax/fsdev.c  | 253 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/dax.c             |   1 +
> >  include/linux/dax.h  |   3 +
> >  7 files changed, 276 insertions(+)
> >  create mode 100644 drivers/dax/fsdev.c
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 96ea84948d76..e83cfcf7e932 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7298,6 +7298,14 @@ L:	linux-cxl@vger.kernel.org
> >  S:	Supported
> >  F:	drivers/dax/
> >  
> > +DEVICE DIRECT ACCESS (DAX) [fsdev_dax]
> > +M:	John Groves <jgroves@micron.com>
> > +M:	John Groves <John@Groves.net>
> > +L:	nvdimm@lists.linux.dev
> > +L:	linux-cxl@vger.kernel.org
> > +S:	Supported
> > +F:	drivers/dax/fsdev.c
> > +
> >  DEVICE FREQUENCY (DEVFREQ)
> >  M:	MyungJoo Ham <myungjoo.ham@samsung.com>
> >  M:	Kyungmin Park <kyungmin.park@samsung.com>
> > diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
> > index 5ed5c39857c8..3bae252fd1bf 100644
> > --- a/drivers/dax/Makefile
> > +++ b/drivers/dax/Makefile
> > @@ -5,10 +5,16 @@ obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
> >  obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
> >  obj-$(CONFIG_DEV_DAX_CXL) += dax_cxl.o
> >  
> > +# fsdev_dax: fs-dax compatible devdax driver (needs DEV_DAX and FS_DAX)
> > +ifeq ($(CONFIG_FS_DAX),y)
> > +obj-$(CONFIG_DEV_DAX) += fsdev_dax.o
> > +endif
> 
> Why not throw in a new CONFIG_FSDAX_DEV and handle the dependencies
> in Kconfig?  

At one point I had another config parameter, but I'm trying not to
gratuitously add them. The fsdev driver is pretty small, and including it
whenever FS_DAX is enabled felt reasonable to me. I'm willing to change it
if there's a consensus that way.

> 
> > +
> >  dax-y := super.o
> >  dax-y += bus.o
> >  device_dax-y := device.o
> >  dax_pmem-y := pmem.o
> >  dax_cxl-y := cxl.o
> > +fsdev_dax-y := fsdev.o
> >  
> >  obj-y += hmem/
> 
> > diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> > new file mode 100644
> > index 000000000000..e5b4396ce401
> > --- /dev/null
> > +++ b/drivers/dax/fsdev.c
> 
> > +static int fsdev_dax_probe(struct dev_dax *dev_dax)
> > +{
> > +	struct dax_device *dax_dev = dev_dax->dax_dev;
> > +	struct device *dev = &dev_dax->dev;
> > +	struct dev_pagemap *pgmap;
> > +	u64 data_offset = 0;
> 
> See below. I think you can useful reduce scope of this one.

As of now, I've reduced the scope, but in the very next commit it needs to
move back here. So meh...not sure that's worth it for one commit

> 
> > +	struct inode *inode;
> > +	struct cdev *cdev;
> > +	void *addr;
> > +	int rc, i;
> > +
> 
> There is a lot of duplication in here with dax/device.c
> Is any of it suitable for shared helpers?

I haven't addressed factoring out more duplicated code yet. Ideally I'd like
to do that after the initial merge, but I'm paying attention to whether 
there's pressure to do it.

> 
> > +	if (static_dev_dax(dev_dax))  {
> > +		if (dev_dax->nr_range > 1) {
> > +			dev_warn(dev, "static pgmap / multi-range device conflict\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		pgmap = dev_dax->pgmap;
> > +	} else {
> > +		size_t pgmap_size;
> > +
> > +		if (dev_dax->pgmap) {
> > +			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
> > +		pgmap = devm_kzalloc(dev, pgmap_size,  GFP_KERNEL);
> 
> Bonus space before GFP_KERNEL.

Excised, thanks

> 
> 
> > +		if (!pgmap)
> > +			return -ENOMEM;
> > +
> > +		pgmap->nr_range = dev_dax->nr_range;
> > +		dev_dax->pgmap = pgmap;
> > +
> > +		for (i = 0; i < dev_dax->nr_range; i++) {
> > +			struct range *range = &dev_dax->ranges[i].range;
> > +
> > +			pgmap->ranges[i] = *range;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < dev_dax->nr_range; i++) {
> > +		struct range *range = &dev_dax->ranges[i].range;
> > +
> > +		if (!devm_request_mem_region(dev, range->start,
> > +					range_len(range), dev_name(dev))) {
> > +			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
> > +				 i, range->start, range->end);
> > +			return -EBUSY;
> > +		}
> > +	}
> 
> Everything above here is shared.  Some sort of _init() or similar library function
> seems in order.

Taken under advisement. Will look at this soon.

> 
> > +
> > +	/*
> > +	 * FS-DAX compatible mode: Use MEMORY_DEVICE_FS_DAX type and
> > +	 * do NOT set vmemmap_shift. This leaves folios at order-0,
> > +	 * allowing fs-dax to dynamically create compound folios as needed
> > +	 * (similar to pmem behavior).
> > +	 */
> > +	pgmap->type = MEMORY_DEVICE_FS_DAX;
> > +	pgmap->ops = &fsdev_pagemap_ops;
> > +	pgmap->owner = dev_dax;
> > +
> > +	/*
> > +	 * CRITICAL DIFFERENCE from device.c:
> > +	 * We do NOT set vmemmap_shift here, even if align > PAGE_SIZE.
> > +	 * This ensures folios remain order-0 and are compatible with
> > +	 * fs-dax's folio management.
> > +	 */
> > +
> > +	addr = devm_memremap_pages(dev, pgmap);
> > +	if (IS_ERR(addr))
> > +		return PTR_ERR(addr);
> > +
> > +	/*
> > +	 * Clear any stale compound folio state left over from a previous
> > +	 * driver (e.g., device_dax with vmemmap_shift). Also register this
> > +	 * as a devm action so folio state is cleared on unbind, ensuring
> > +	 * clean pages for subsequent drivers (e.g., kmem for system-ram).
> > +	 */
> > +	fsdev_clear_folio_state(dev_dax);
> > +	rc = devm_add_action_or_reset(dev, fsdev_clear_folio_state_action,
> > +				      dev_dax);
> > +	if (rc)
> > +		return rc;
> > +
> > +	/* Detect whether the data is at a non-zero offset into the memory */
> > +	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
> > +		u64 phys = dev_dax->ranges[0].range.start;
> > +		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
> > +
> > +		if (!WARN_ON(pgmap_phys > phys))
> > +			data_offset = phys - pgmap_phys;
> > +
> > +		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
> > +		       __func__, phys, pgmap_phys, data_offset);
> 
> Might change later, but at least at this point you could pull declaration of data_offset
> into this scope.

done as of now, but it's used right after the closing brace of this block
in the very next commit.

> 
> > +	}
> > +
> > +	inode = dax_inode(dax_dev);
> > +	cdev = inode->i_cdev;
> > +	cdev_init(cdev, &fsdev_fops);
> > +	cdev->owner = dev->driver->owner;
> > +	cdev_set_parent(cdev, &dev->kobj);
> > +	rc = cdev_add(cdev, dev->devt, 1);
> > +	if (rc)
> > +		return rc;
> > +
> > +	rc = devm_add_action_or_reset(dev, fsdev_cdev_del, cdev);
> > +	if (rc)
> > +		return rc;
> > +
> > +	run_dax(dax_dev);
> > +	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> > +}
> 
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index bf103f317cac..996493f5c538 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -51,6 +51,7 @@ struct dax_holder_operations {
> >  
> >  #if IS_ENABLED(CONFIG_DAX)
> >  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
> > +
> 
> Unrelated change.  Tidy this up for v9.

Spurious blank line dropped - thanks

> 
> 
> >  void *dax_holder(struct dax_device *dax_dev);
> >  void put_dax(struct dax_device *dax_dev);
> >  void kill_dax(struct dax_device *dax_dev);
> > @@ -151,8 +152,10 @@ static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
> >  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> >  
> >  #if IS_ENABLED(CONFIG_FS_DAX)
> > +struct dax_device *inode_dax(struct inode *inode);
> 
> Already in dax_private.h so why does it want to be here?

Indeed, thanks!

Regards,
John

