Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sat, 18 Apr 2015 10:07:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 06/21] nd: ndctl class device, and nd bus attributes
Message-ID: <20150418080702.GB28706@kroah.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150418013546.25237.86836.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150418013546.25237.86836.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 17, 2015 at 09:35:46PM -0400, Dan Williams wrote:
> This is the position (device topology) independent method to find all
> the NFIT-defined buses in the system.  The expectation is that there
> will only ever be one "nd" bus discovered via /sys/class/nd/ndctl0.
> However, we allow for the possibility of multiple buses and they will
> listed in discovery order as ndctl0...ndctlN.  This character device
> hosts the ioctl for passing control messages (as defined by the NFIT
> spec).  The "format" and "revision" attributes of this device identify
> the format of the messages.  In the event an NFIT is registered with an
> unknown/unsupported control message format then the "format" attribute
> will not be visible.
> 
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/block/nd/Makefile     |    1 
>  drivers/block/nd/bus.c        |   84 +++++++++++++++++++++++++++++++++++++++++
>  drivers/block/nd/core.c       |   71 ++++++++++++++++++++++++++++++++++-
>  drivers/block/nd/nd-private.h |    5 ++
>  4 files changed, 160 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/block/nd/bus.c
> 
> diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
> index c6bec0c185c5..7772fb599809 100644
> --- a/drivers/block/nd/Makefile
> +++ b/drivers/block/nd/Makefile
> @@ -20,3 +20,4 @@ obj-$(CONFIG_NFIT_ACPI) += nd_acpi.o
>  nd_acpi-y := acpi.o
>  
>  nd-y := core.o
> +nd-y += bus.o
> diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
> new file mode 100644
> index 000000000000..c27db50511f2
> --- /dev/null
> +++ b/drivers/block/nd/bus.c
> @@ -0,0 +1,84 @@
> +/*
> + * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +#include <linux/uaccess.h>
> +#include <linux/fcntl.h>
> +#include <linux/slab.h>
> +#include <linux/fs.h>
> +#include <linux/io.h>
> +#include "nd-private.h"
> +#include "nfit.h"
> +
> +static int nd_major;
> +static struct class *nd_class;
> +
> +int nd_bus_create_ndctl(struct nd_bus *nd_bus)
> +{
> +	dev_t devt = MKDEV(nd_major, nd_bus->id);
> +	struct device *dev;
> +
> +	dev = device_create(nd_class, &nd_bus->dev, devt, nd_bus, "ndctl%d",
> +			nd_bus->id);
> +
> +	if (IS_ERR(dev)) {
> +		dev_dbg(&nd_bus->dev, "failed to register ndctl%d: %ld\n",
> +				nd_bus->id, PTR_ERR(dev));
> +		return PTR_ERR(dev);
> +	}
> +	return 0;
> +}
> +
> +void nd_bus_destroy_ndctl(struct nd_bus *nd_bus)
> +{
> +	device_destroy(nd_class, MKDEV(nd_major, nd_bus->id));
> +}
> +
> +static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	return -ENXIO;
> +}

There is no ioctl call here, so why even have this character device?

thanks,

greg k-h
