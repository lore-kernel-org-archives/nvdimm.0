Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED13C405AD9
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365571; cv=none; b=NhBjGxEDTvh3BZv/bjqShtKWiigfSQ0cKOeioAzazwLH58K9LajP5+9uQuTNvFmrttxBY3vvKRROYIRTcs4/JsOUtkDBfN1hoNeb3LrTDMSXVYNmTBlc52yEH+iAR3kC/sZyI7h2YdNJipzasi3CAP0nRvea88Pxt9sbRUFjrSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365571; c=relaxed/simple;
	bh=YxSGHiccFqwqHkpmlagAjHZxXU6vBsNrt5TpNkPeOEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ubfEHiKgD1rkh+paS+DlMrIrjT478sET+cGB1Tr9GMUwKqYaeqO03hW1eDXEDriEhuTjJW5oV8mcznqutKcjGacdYxZJls/f80NKifQ6jnWdQ/UhKD8CC32Ra9Z3DFhGdD0QGQHdnesWEbLjmjFK7+x4OLM3v26m+C4pGKIFcfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tmal0wcu; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tmal0wcu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774365569; x=1805901569;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YxSGHiccFqwqHkpmlagAjHZxXU6vBsNrt5TpNkPeOEs=;
  b=Tmal0wcuErisDbH1+0J1uL4I+cl+uGX2mCDrqh2GzzMbCm09Pc1/6CP2
   2wZJ7+nQgcVGVjpz2EYxgT1UHa0gFCBJ/Dg8cnYAoptim7z1a4BmmFheV
   RilTwK7Spg05IMvdxlNQJxqbAB7AyS5ZZxH1aOaEbb9Zq/egJf+JTIa94
   Vswhoi/U5jl3A0zhn+3KheiygDm/VzSZURjDzvh27ack90EtTQLoqZ4Mz
   nyxhnQof5kG2r8jeu32eWhQ2RiA4jCG6Ae5Z627tRXP+2y0SOM4xgh3iY
   FVOLQm74UgkgCdhYt/YBvdYSagLU/+KL3cUNSnpilnau/2NC/vzfb1aM/
   g==;
X-CSE-ConnectionGUID: 7MOiqGHPRFagBUT5Kv+D1Q==
X-CSE-MsgGUID: l7JVpr3QSMWQiUglfefGLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75576178"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75576178"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 08:19:29 -0700
X-CSE-ConnectionGUID: 97WDGWzmTw6lVNc5Pb7sbw==
X-CSE-MsgGUID: seot7xnnRvCfoxo98gpMEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="224628868"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.110.6]) ([10.125.110.6])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 08:19:25 -0700
Message-ID: <e0421e4f-0436-47f5-9d45-11adfbecdc3c@intel.com>
Date: Tue, 24 Mar 2026 08:19:24 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>,
 Bernd Schubert <bschubert@ddn.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>,
 Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>,
 Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>,
 Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/23/26 5:38 PM, John Groves wrote:
> From: John Groves <john@groves.net>
> 
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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  MAINTAINERS          |   8 ++
>  drivers/dax/Kconfig  |  11 ++
>  drivers/dax/Makefile |   2 +
>  drivers/dax/bus.c    |   4 +
>  drivers/dax/bus.h    |   1 +
>  drivers/dax/fsdev.c  | 245 +++++++++++++++++++++++++++++++++++++++++++
>  fs/dax.c             |   1 +
>  7 files changed, 272 insertions(+)
>  create mode 100644 drivers/dax/fsdev.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7d10988cbc62..eedf4cce56ed 100644
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
> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index d656e4c0eb84..7051b70980d5 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
>  	depends on DEV_DAX_HMEM && DAX
>  	def_bool y
>  
> +config DEV_DAX_FSDEV
> +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> +	depends on DEV_DAX && FS_DAX
> +	help
> +	  Support fs-dax access to DAX devices via a character device
> +	  interface. Unlike device_dax (which pre-initializes compound folios
> +	  based on device alignment), this driver leaves folios at order-0 so
> +	  that fs-dax filesystems can manage folio order dynamically.
> +
> +	  Say M if unsure.
> +
>  config DEV_DAX_KMEM
>  	tristate "KMEM DAX: map dax-devices as System-RAM"
>  	default DEV_DAX
> diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
> index 5ed5c39857c8..ba35bda7abef 100644
> --- a/drivers/dax/Makefile
> +++ b/drivers/dax/Makefile
> @@ -4,11 +4,13 @@ obj-$(CONFIG_DEV_DAX) += device_dax.o
>  obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
>  obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
>  obj-$(CONFIG_DEV_DAX_CXL) += dax_cxl.o
> +obj-$(CONFIG_DEV_DAX_FSDEV) += fsdev_dax.o
>  
>  dax-y := super.o
>  dax-y += bus.o
>  device_dax-y := device.o
>  dax_pmem-y := pmem.o
>  dax_cxl-y := cxl.o
> +fsdev_dax-y := fsdev.o
>  
>  obj-y += hmem/
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index e4bd5c9f006c..562e2b06f61a 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -81,6 +81,10 @@ static int dax_match_type(const struct dax_device_driver *dax_drv, struct device
>  	    !IS_ENABLED(CONFIG_DEV_DAX_KMEM))
>  		return 1;
>  
> +	/* fsdev driver can also bind to device-type dax devices */
> +	if (dax_drv->type == DAXDRV_FSDEV_TYPE && type == DAXDRV_DEVICE_TYPE)
> +		return 1;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index cbbf64443098..880bdf7e72d7 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -31,6 +31,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
>  enum dax_driver_type {
>  	DAXDRV_KMEM_TYPE,
>  	DAXDRV_DEVICE_TYPE,
> +	DAXDRV_FSDEV_TYPE,
>  };
>  
>  struct dax_device_driver {
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> new file mode 100644
> index 000000000000..8b5c6976ad17
> --- /dev/null
> +++ b/drivers/dax/fsdev.c
> @@ -0,0 +1,245 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2026 Micron Technology, Inc. */
> +#include <linux/memremap.h>
> +#include <linux/pagemap.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/cdev.h>
> +#include <linux/slab.h>
> +#include <linux/dax.h>
> +#include <linux/uio.h>
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +#include "dax-private.h"
> +#include "bus.h"
> +
> +/*
> + * FS-DAX compatible devdax driver
> + *
> + * Unlike drivers/dax/device.c which pre-initializes compound folios based
> + * on device alignment (via vmemmap_shift), this driver leaves folios
> + * uninitialized similar to pmem. This allows fs-dax filesystems like famfs
> + * to work without needing special handling for pre-initialized folios.
> + *
> + * Key differences from device.c:
> + * - pgmap type is MEMORY_DEVICE_FS_DAX (not MEMORY_DEVICE_GENERIC)
> + * - vmemmap_shift is NOT set (folios remain order-0)
> + * - fs-dax can dynamically create compound folios as needed
> + * - No mmap support - all access is through fs-dax/iomap
> + */
> +
> +static void fsdev_cdev_del(void *cdev)
> +{
> +	cdev_del(cdev);
> +}
> +
> +static void fsdev_kill(void *dev_dax)
> +{
> +	kill_dev_dax(dev_dax);
> +}
> +
> +/*
> + * Page map operations for FS-DAX mode
> + * Similar to fsdax_pagemap_ops in drivers/nvdimm/pmem.c
> + *
> + * Note: folio_free callback is not needed for MEMORY_DEVICE_FS_DAX.
> + * The core mm code in free_zone_device_folio() handles the wake_up_var()
> + * directly for this memory type.
> + */
> +static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
> +		unsigned long pfn, unsigned long nr_pages, int mf_flags)
> +{
> +	struct dev_dax *dev_dax = pgmap->owner;
> +	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
> +	u64 len = nr_pages << PAGE_SHIFT;
> +
> +	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
> +					 len, mf_flags);
> +}
> +
> +static const struct dev_pagemap_ops fsdev_pagemap_ops = {
> +	.memory_failure		= fsdev_pagemap_memory_failure,
> +};
> +
> +/*
> + * Clear any stale folio state from pages in the given range.
> + * This is necessary because device_dax pre-initializes compound folios
> + * based on vmemmap_shift, and that state may persist after driver unbind.
> + * Since fsdev_dax uses MEMORY_DEVICE_FS_DAX without vmemmap_shift, fs-dax
> + * expects to find clean order-0 folios that it can build into compound
> + * folios on demand.
> + *
> + * At probe time, no filesystem should be mounted yet, so all mappings
> + * are stale and must be cleared along with compound state.
> + */
> +static void fsdev_clear_folio_state(struct dev_dax *dev_dax)
> +{
> +	for (int i = 0; i < dev_dax->nr_range; i++) {
> +		struct range *range = &dev_dax->ranges[i].range;
> +		unsigned long pfn = PHYS_PFN(range->start);
> +		unsigned long end_pfn = PHYS_PFN(range->end) + 1;
> +
> +		while (pfn < end_pfn) {
> +			struct folio *folio = pfn_folio(pfn);
> +			int order = dax_folio_reset_order(folio);
> +
> +			pfn += 1UL << order;
> +		}
> +	}
> +}
> +
> +static void fsdev_clear_folio_state_action(void *data)
> +{
> +	fsdev_clear_folio_state(data);
> +}
> +
> +static int fsdev_open(struct inode *inode, struct file *filp)
> +{
> +	struct dax_device *dax_dev = inode_dax(inode);
> +	struct dev_dax *dev_dax = dax_get_private(dax_dev);
> +
> +	filp->private_data = dev_dax;
> +
> +	return 0;
> +}
> +
> +static int fsdev_release(struct inode *inode, struct file *filp)
> +{
> +	return 0;
> +}
> +
> +static const struct file_operations fsdev_fops = {
> +	.llseek = noop_llseek,
> +	.owner = THIS_MODULE,
> +	.open = fsdev_open,
> +	.release = fsdev_release,
> +};
> +
> +static int fsdev_dax_probe(struct dev_dax *dev_dax)
> +{
> +	struct dax_device *dax_dev = dev_dax->dax_dev;
> +	struct device *dev = &dev_dax->dev;
> +	struct dev_pagemap *pgmap;
> +	struct inode *inode;
> +	struct cdev *cdev;
> +	void *addr;
> +	int rc, i;
> +
> +	if (static_dev_dax(dev_dax)) {
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
> +		pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
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
> +
> +	/*
> +	 * Use MEMORY_DEVICE_FS_DAX without setting vmemmap_shift, leaving
> +	 * folios at order-0. Unlike device.c (MEMORY_DEVICE_GENERIC), this
> +	 * lets fs-dax dynamically build compound folios as needed, similar
> +	 * to pmem behavior.
> +	 */
> +	pgmap->type = MEMORY_DEVICE_FS_DAX;
> +	pgmap->ops = &fsdev_pagemap_ops;
> +	pgmap->owner = dev_dax;
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
> +		u64 data_offset = 0;
> +
> +		if (!WARN_ON(pgmap_phys > phys))
> +			data_offset = phys - pgmap_phys;
> +
> +		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
> +		       __func__, phys, pgmap_phys, data_offset);
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
> +
> +static struct dax_device_driver fsdev_dax_driver = {
> +	.probe = fsdev_dax_probe,
> +	.type = DAXDRV_FSDEV_TYPE,
> +};
> +
> +static int __init dax_init(void)
> +{
> +	return dax_driver_register(&fsdev_dax_driver);
> +}
> +
> +static void __exit dax_exit(void)
> +{
> +	dax_driver_unregister(&fsdev_dax_driver);
> +}
> +
> +MODULE_AUTHOR("John Groves");
> +MODULE_DESCRIPTION("FS-DAX Device: fs-dax compatible devdax driver");
> +MODULE_LICENSE("GPL");
> +module_init(dax_init);
> +module_exit(dax_exit);
> +MODULE_ALIAS_DAX_DEVICE(0);
> diff --git a/fs/dax.c b/fs/dax.c
> index eba86802a7a7..b91a2535149a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -430,6 +430,7 @@ int dax_folio_reset_order(struct folio *folio)
>  
>  	return order;
>  }
> +EXPORT_SYMBOL_GPL(dax_folio_reset_order);
>  
>  static inline unsigned long dax_folio_put(struct folio *folio)
>  {

