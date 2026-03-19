Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2323C4568
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 12:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773922866; cv=none; b=ihBORiwCd2qRQM9Sp2E53hbUydGfY6jKO7yx6I4PXzHUJ3ZOvwbn9PjBwMcmDSZgR4+V6+6qaZmPHeOV3Aa5ub8Ej9+LlkNAva6Y5WtbRpPXDEKorTGE9lRQVcXFWIgmFD/Fq6V3CisMBsDAV9ojkCPHnG75blwVrdbuZrlr+Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773922866; c=relaxed/simple;
	bh=51qDref+96vLVVzgxex3Lz/aTp6JsO1HJFiooq62O/k=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jSpt4xxsI8kJdxSy5d+PSmXd0YdVO+SxYEuZtA+urfjrL94PC9A6/x+S1hU1ruSaUC0bkSsLn0yJllGL2AmdCGsKrGhG3EqcdhV/v5b8K4VTZz8WHE4HCwDbFf3WcPD8gutJrxuv3BkqrS76KJ/ie0FUV1Ml64UZzlqselIuHBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc4X074MjzJ46Cq;
	Thu, 19 Mar 2026 20:20:00 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 51D4740584;
	Thu, 19 Mar 2026 20:21:00 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 12:20:58 +0000
Date: Thu, 19 Mar 2026 12:20:57 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@groves.net>
CC: Miklos Szeredi <miklos@szeredi.hu>, Dan Williams
	<dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, "Alison
 Schofield" <alison.schofield@intel.com>, John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong"
	<djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Jeff Layton
	<jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, <venkataravis@micron.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V8 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <20260319122057.00004503@huawei.com>
In-Reply-To: <20260319012837.4443-1-john@groves.net>
References: <20260318202737.4344.dax@groves.net>
	<20260319012837.4443-1-john@groves.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Wed, 18 Mar 2026 20:28:37 -0500
John Groves <john@groves.net> wrote:

> The new fsdev driver provides pages/folios initialized compatibly with
> fsdax - normal rather than devdax-style refcounting, and starting out
> with order-0 folios.
> 
> When fsdev binds to a daxdev, it is usually (always?) switching from the
> devdax mode (device.c), which pre-initializes compound folios according
> to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> folios into a fsdax-compatible state.
> 
> A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> mmap capability.
> 
> In this commit is just the framework, which remaps pages/folios compatibly
> with fsdax.
> 
> Enabling dax changes:
> 
> - bus.h: add DAXDRV_FSDEV_TYPE driver type
> - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> - dax.h: prototype inode_dax(), which fsdev needs
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: John Groves <john@groves.net>

A few comments inline.  I think some of the code here could be moved
to a helper library used by both this and device.c

> ---
>  MAINTAINERS          |   8 ++
>  drivers/dax/Makefile |   6 +
>  drivers/dax/bus.c    |   4 +
>  drivers/dax/bus.h    |   1 +
>  drivers/dax/fsdev.c  | 253 +++++++++++++++++++++++++++++++++++++++++++
>  fs/dax.c             |   1 +
>  include/linux/dax.h  |   3 +
>  7 files changed, 276 insertions(+)
>  create mode 100644 drivers/dax/fsdev.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 96ea84948d76..e83cfcf7e932 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7298,6 +7298,14 @@ L:	linux-cxl@vger.kernel.org
>  S:	Supported
>  F:	drivers/dax/
>  
> +DEVICE DIRECT ACCESS (DAX) [fsdev_dax]
> +M:	John Groves <jgroves@micron.com>
> +M:	John Groves <John@Groves.net>
> +L:	nvdimm@lists.linux.dev
> +L:	linux-cxl@vger.kernel.org
> +S:	Supported
> +F:	drivers/dax/fsdev.c
> +
>  DEVICE FREQUENCY (DEVFREQ)
>  M:	MyungJoo Ham <myungjoo.ham@samsung.com>
>  M:	Kyungmin Park <kyungmin.park@samsung.com>
> diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
> index 5ed5c39857c8..3bae252fd1bf 100644
> --- a/drivers/dax/Makefile
> +++ b/drivers/dax/Makefile
> @@ -5,10 +5,16 @@ obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
>  obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
>  obj-$(CONFIG_DEV_DAX_CXL) += dax_cxl.o
>  
> +# fsdev_dax: fs-dax compatible devdax driver (needs DEV_DAX and FS_DAX)
> +ifeq ($(CONFIG_FS_DAX),y)
> +obj-$(CONFIG_DEV_DAX) += fsdev_dax.o
> +endif

Why not throw in a new CONFIG_FSDAX_DEV and handle the dependencies
in Kconfig?  

> +
>  dax-y := super.o
>  dax-y += bus.o
>  device_dax-y := device.o
>  dax_pmem-y := pmem.o
>  dax_cxl-y := cxl.o
> +fsdev_dax-y := fsdev.o
>  
>  obj-y += hmem/

> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> new file mode 100644
> index 000000000000..e5b4396ce401
> --- /dev/null
> +++ b/drivers/dax/fsdev.c

> +static int fsdev_dax_probe(struct dev_dax *dev_dax)
> +{
> +	struct dax_device *dax_dev = dev_dax->dax_dev;
> +	struct device *dev = &dev_dax->dev;
> +	struct dev_pagemap *pgmap;
> +	u64 data_offset = 0;

See below. I think you can useful reduce scope of this one.

> +	struct inode *inode;
> +	struct cdev *cdev;
> +	void *addr;
> +	int rc, i;
> +

There is a lot of duplication in here with dax/device.c
Is any of it suitable for shared helpers?

> +	if (static_dev_dax(dev_dax))  {
> +		if (dev_dax->nr_range > 1) {
> +			dev_warn(dev, "static pgmap / multi-range device conflict\n");
> +			return -EINVAL;
> +		}
> +
> +		pgmap = dev_dax->pgmap;
> +	} else {
> +		size_t pgmap_size;
> +
> +		if (dev_dax->pgmap) {
> +			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
> +			return -EINVAL;
> +		}
> +
> +		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
> +		pgmap = devm_kzalloc(dev, pgmap_size,  GFP_KERNEL);

Bonus space before GFP_KERNEL.


> +		if (!pgmap)
> +			return -ENOMEM;
> +
> +		pgmap->nr_range = dev_dax->nr_range;
> +		dev_dax->pgmap = pgmap;
> +
> +		for (i = 0; i < dev_dax->nr_range; i++) {
> +			struct range *range = &dev_dax->ranges[i].range;
> +
> +			pgmap->ranges[i] = *range;
> +		}
> +	}
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct range *range = &dev_dax->ranges[i].range;
> +
> +		if (!devm_request_mem_region(dev, range->start,
> +					range_len(range), dev_name(dev))) {
> +			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
> +				 i, range->start, range->end);
> +			return -EBUSY;
> +		}
> +	}

Everything above here is shared.  Some sort of _init() or similar library function
seems in order.

> +
> +	/*
> +	 * FS-DAX compatible mode: Use MEMORY_DEVICE_FS_DAX type and
> +	 * do NOT set vmemmap_shift. This leaves folios at order-0,
> +	 * allowing fs-dax to dynamically create compound folios as needed
> +	 * (similar to pmem behavior).
> +	 */
> +	pgmap->type = MEMORY_DEVICE_FS_DAX;
> +	pgmap->ops = &fsdev_pagemap_ops;
> +	pgmap->owner = dev_dax;
> +
> +	/*
> +	 * CRITICAL DIFFERENCE from device.c:
> +	 * We do NOT set vmemmap_shift here, even if align > PAGE_SIZE.
> +	 * This ensures folios remain order-0 and are compatible with
> +	 * fs-dax's folio management.
> +	 */
> +
> +	addr = devm_memremap_pages(dev, pgmap);
> +	if (IS_ERR(addr))
> +		return PTR_ERR(addr);
> +
> +	/*
> +	 * Clear any stale compound folio state left over from a previous
> +	 * driver (e.g., device_dax with vmemmap_shift). Also register this
> +	 * as a devm action so folio state is cleared on unbind, ensuring
> +	 * clean pages for subsequent drivers (e.g., kmem for system-ram).
> +	 */
> +	fsdev_clear_folio_state(dev_dax);
> +	rc = devm_add_action_or_reset(dev, fsdev_clear_folio_state_action,
> +				      dev_dax);
> +	if (rc)
> +		return rc;
> +
> +	/* Detect whether the data is at a non-zero offset into the memory */
> +	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
> +		u64 phys = dev_dax->ranges[0].range.start;
> +		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
> +
> +		if (!WARN_ON(pgmap_phys > phys))
> +			data_offset = phys - pgmap_phys;
> +
> +		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
> +		       __func__, phys, pgmap_phys, data_offset);

Might change later, but at least at this point you could pull declaration of data_offset
into this scope.

> +	}
> +
> +	inode = dax_inode(dax_dev);
> +	cdev = inode->i_cdev;
> +	cdev_init(cdev, &fsdev_fops);
> +	cdev->owner = dev->driver->owner;
> +	cdev_set_parent(cdev, &dev->kobj);
> +	rc = cdev_add(cdev, dev->devt, 1);
> +	if (rc)
> +		return rc;
> +
> +	rc = devm_add_action_or_reset(dev, fsdev_cdev_del, cdev);
> +	if (rc)
> +		return rc;
> +
> +	run_dax(dax_dev);
> +	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
> +}

> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index bf103f317cac..996493f5c538 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -51,6 +51,7 @@ struct dax_holder_operations {
>  
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
> +

Unrelated change.  Tidy this up for v9.


>  void *dax_holder(struct dax_device *dax_dev);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
> @@ -151,8 +152,10 @@ static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
>  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
>  
>  #if IS_ENABLED(CONFIG_FS_DAX)
> +struct dax_device *inode_dax(struct inode *inode);

Already in dax_private.h so why does it want to be here?


>  int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct dax_device *dax_dev, struct writeback_control *wbc);
> +int dax_folio_reset_order(struct folio *folio);
>  
>  struct page *dax_layout_busy_page(struct address_space *mapping);
>  struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);

