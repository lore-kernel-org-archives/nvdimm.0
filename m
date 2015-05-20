Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A917E18@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182450.35812.82316.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A917E18@G9W0745.americas.hpqcorp.net>
Date: Wed, 20 May 2015 10:02:35 -0700
Message-ID: <CAPcyv4isLDa8fe4tgZJ2oG_bi97uRO1B1=DYijGzZDtK4ogEMA@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 07/20] libnd, nd_dimm: dimm driver and
 base libnd device-driver infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 20, 2015 at 9:59 AM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
> > Of Dan Williams
> > Sent: Tuesday, April 28, 2015 1:25 PM
> > To: linux-nvdimm@lists.01.org
> > Cc: Neil Brown; Greg KH; linux-kernel@vger.kernel.org
> > Subject: [Linux-nvdimm] [PATCH v2 07/20] libnd, nd_dimm: dimm driver and
> > base libnd device-driver infrastructure
> >
> ...
> > diff --git a/drivers/block/nd/dimm.c b/drivers/block/nd/dimm.c
> > new file mode 100644
> > index 000000000000..a4c8e3ffe97c
> > --- /dev/null
> > +++ b/drivers/block/nd/dimm.c
> > @@ -0,0 +1,93 @@
> > +/*
> > + * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of version 2 of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + */
> > +#include <linux/vmalloc.h>
> > +#include <linux/module.h>
> > +#include <linux/device.h>
> > +#include <linux/sizes.h>
> > +#include <linux/ndctl.h>
> > +#include <linux/slab.h>
> > +#include <linux/mm.h>
> > +#include <linux/nd.h>
> > +#include "nd.h"
> > +
> > +static void free_data(struct nd_dimm_drvdata *ndd)
> > +{
> > +     if (!ndd)
> > +             return;
> > +
> > +     if (ndd->data && is_vmalloc_addr(ndd->data))
> > +             vfree(ndd->data);
> > +     else
> > +             kfree(ndd->data);
> > +     kfree(ndd);
> > +}
> > +
> > +static int nd_dimm_probe(struct device *dev)
> > +{
> > +     struct nd_dimm_drvdata *ndd;
> > +     int rc;
> > +
> > +     ndd = kzalloc(sizeof(*ndd), GFP_KERNEL);
> > +     if (!ndd)
> > +             return -ENOMEM;
> > +
> > +     dev_set_drvdata(dev, ndd);
> > +        ndd->dev = dev;
> > +
> > +     rc = nd_dimm_init_nsarea(ndd);
> > +     if (rc)
> > +             goto err;
> > +
> > +     rc = nd_dimm_init_config_data(ndd);
> > +     if (rc)
> > +             goto err;
> > +
> > +     dev_dbg(dev, "config data size: %d\n", ndd->nsarea.config_size);
> > +
> > +     return 0;
> > +
> > + err:
> > +     free_data(ndd);
> > +     return rc;
> > +
> > +}
> > +
> > +static int nd_dimm_remove(struct device *dev)
> > +{
> > +     struct nd_dimm_drvdata *ndd = dev_get_drvdata(dev);
> > +
> > +     free_data(ndd);
> > +
> > +     return 0;
> > +}
>
> It would reduce the slight window for stale pointer usage if you add:
>         dev_set_drvdata(dev, NULL);
>
> before
>         free_data(ndd);
>
> in both nd_dimm_remove and the err exit for nd_dimm_probe.
>
> The same comment applies to all the drivers that store pointers
> with dev_set_drvdata - btt, pmem, etc.
>

That is automatically handled by disabling a driver.  If some other
code may race with this it needs to hold device_lock(), which we do in
places.
