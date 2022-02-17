Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D54463A
	for <nvdimm@lists.linux.dev>; Thu, 17 Feb 2022 23:32:55 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id h125so6328989pgc.3
        for <nvdimm@lists.linux.dev>; Thu, 17 Feb 2022 15:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u4jK6zM/dGsbBGtsbu+DwrbOk29KN2o86uMbiSzfAK0=;
        b=az7hZKDGRAkoXQBEkYUWpj0gH0gHol0LQpBS5h8fK7OCa8iMwXhiDL6Z23Q34GHwkT
         P05dl6MAjq6cFUvwju3EGm5VtVtBGuYPtbvB9AGuvIPfnL4UWJZXU+CQ6VgffIgFY3Qo
         DYKSu07MMz6BNzbRis8o4MTmnL09N1j3s/YJt5MCubbJ6DWeD5RZsP5dBcdOQL3dM3rS
         a4F4u3wFv/XQr7+zy9JjoUuBa96p/i+ix2LggTC2gPdLJ9zwgj5y0UxDYO2xNlqdT+jw
         5N/8Jmn2p1LhtH2C7uCcp84Q6GFLve7QfuP7k/CStbxEAMM7qC7WU++SrkV0htgoI6CK
         z2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u4jK6zM/dGsbBGtsbu+DwrbOk29KN2o86uMbiSzfAK0=;
        b=oMPaClMtUTUx4fDSJdUGmbihViszVigTRC/EYzhXPESJeYTwXcDPXEHYcC0cHWmAtk
         piTykv8vfdEveccDGPWhu/fJXlLpzgK4pkUQD+aF1R+iNKdkaPCmk4R3Px3W+f5o206Z
         eUEOEWjhegoy+9hpLYlF2osBg+KPoAb0190ecpvUNzVilenz95bgqd9/apj3mEvst4HO
         4TJAyW0zG2QahCh9Vi1/MyLex6yLV/eqeROl53nOU8S7DkGe9CAdyTo1STF+P2Qnnp+1
         Q1tOyrilc7YAmqs2I1fSB913qSbH98oZoRqPnwIMYgsb0mNqDoenieRzg4U9SIDQTWyE
         Ir5A==
X-Gm-Message-State: AOAM532DsFfqsVh2ByEdyw+6HBVn+JJgrLTZvkZulLXQLwNFyVUsEXRF
	u0iGI6qw0iLW6P9QXZ4+KoxTigutjf7nCW6jQ5qvww==
X-Google-Smtp-Source: ABdhPJwE+OIl8dV3jNoTmCdOxGcrp8lf33cuW1poct8jXzYwVoRqBZaGpYL+5c/kdmQjFLr7LKt61ymLRq1nG0nNp+I=
X-Received: by 2002:a63:2354:0:b0:372:c945:bfd1 with SMTP id
 u20-20020a632354000000b00372c945bfd1mr4110168pgm.437.1645140775197; Thu, 17
 Feb 2022 15:32:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220217171057.685705-1-ben.widawsky@intel.com>
 <20220217171931.740926-1-ben.widawsky@intel.com> <CAPcyv4i83TxCN_-Y3a5CuM2ng9bCAyLm53=wcHWutASd434gkg@mail.gmail.com>
 <20220217222208.f5krwchjljrzjieg@intel.com>
In-Reply-To: <20220217222208.f5krwchjljrzjieg@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 Feb 2022 15:32:44 -0800
Message-ID: <CAPcyv4jURh0DbJpDjEwTn-_9WtkSokJN5R3PG5tuwJSMMu_Xcw@mail.gmail.com>
Subject: Re: [PATCH v5 01/15] cxl/region: Add region creation ABI
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 17, 2022 at 2:22 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-02-17 09:58:04, Dan Williams wrote:
> > On Thu, Feb 17, 2022 at 9:19 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > Regions are created as a child of the decoder that encompasses an
> > > address space with constraints. Regions have a number of attributes that
> > > must be configured before the region can be activated.
> > >
> > > The ABI is not meant to be secure, but is meant to avoid accidental
> > > races. As a result, a buggy process may create a region by name that was
> > > allocated by a different process. However, multiple processes which are
> > > trying not to race with each other shouldn't need special
> > > synchronization to do so.
> > >
> > > // Allocate a new region name
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_region)
> > >
> > > // Create a new region by name
> > > while
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_region)
> > > ! echo $region > /sys/bus/cxl/devices/decoder0.0/create_region
> > > do true; done
> > >
> > > // Region now exists in sysfs
> > > stat -t /sys/bus/cxl/devices/decoder0.0/$region
> > >
> > > // Delete the region, and name
> > > echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region
> > >
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> >
> > Looking good, a few more fixes and cleanups identified below.
> >
> > >
> > > ---
> > > Changes since v4:
> > > - Add the missed base attributes addition
> > >
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-cxl       |  23 ++
> > >  .../driver-api/cxl/memory-devices.rst         |  11 +
> > >  drivers/cxl/core/Makefile                     |   1 +
> > >  drivers/cxl/core/core.h                       |   3 +
> > >  drivers/cxl/core/port.c                       |  11 +
> > >  drivers/cxl/core/region.c                     | 213 ++++++++++++++++++
> > >  drivers/cxl/cxl.h                             |   5 +
> > >  drivers/cxl/region.h                          |  23 ++
> > >  tools/testing/cxl/Kbuild                      |   1 +
> > >  9 files changed, 291 insertions(+)
> > >  create mode 100644 drivers/cxl/core/region.c
> > >  create mode 100644 drivers/cxl/region.h
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > > index 7c2b846521f3..e5db45ea70ad 100644
> > > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > > @@ -163,3 +163,26 @@ Description:
> > >                 memory (type-3). The 'target_type' attribute indicates the
> > >                 current setting which may dynamically change based on what
> > >                 memory regions are activated in this decode hierarchy.
> > > +
> > > +What:          /sys/bus/cxl/devices/decoderX.Y/create_region
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               Write a value of the form 'regionX.Y:Z' to instantiate a new
> > > +               region within the decode range bounded by decoderX.Y. The value
> > > +               written must match the current value returned from reading this
> > > +               attribute. This behavior lets the kernel arbitrate racing
> > > +               attempts to create a region. The thread that fails to write
> > > +               loops and tries the next value. Regions must be created for root
> > > +               decoders, and must subsequently configured and bound to a region
> > > +               driver before they can be used.
> > > +
> > > +What:          /sys/bus/cxl/devices/decoderX.Y/delete_region
> > > +Date:          January, 2022
> > > +KernelVersion: v5.18
> > > +Contact:       linux-cxl@vger.kernel.org
> > > +Description:
> > > +               Deletes the named region.  The attribute expects a region in the
> > > +               form "regionX.Y:Z". The region's name, allocated by reading
> > > +               create_region, will also be released.
> > > diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
> > > index db476bb170b6..66ddc58a21b1 100644
> > > --- a/Documentation/driver-api/cxl/memory-devices.rst
> > > +++ b/Documentation/driver-api/cxl/memory-devices.rst
> > > @@ -362,6 +362,17 @@ CXL Core
> > >  .. kernel-doc:: drivers/cxl/core/mbox.c
> > >     :doc: cxl mbox
> > >
> > > +CXL Regions
> > > +-----------
> > > +.. kernel-doc:: drivers/cxl/region.h
> > > +   :identifiers:
> > > +
> > > +.. kernel-doc:: drivers/cxl/core/region.c
> > > +   :doc: cxl core region
> > > +
> > > +.. kernel-doc:: drivers/cxl/core/region.c
> > > +   :identifiers:
> > > +
> > >  External Interfaces
> > >  ===================
> > >
> > > diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
> > > index 6d37cd78b151..39ce8f2f2373 100644
> > > --- a/drivers/cxl/core/Makefile
> > > +++ b/drivers/cxl/core/Makefile
> > > @@ -4,6 +4,7 @@ obj-$(CONFIG_CXL_BUS) += cxl_core.o
> > >  ccflags-y += -I$(srctree)/drivers/cxl
> > >  cxl_core-y := port.o
> > >  cxl_core-y += pmem.o
> > > +cxl_core-y += region.o
> > >  cxl_core-y += regs.o
> > >  cxl_core-y += memdev.o
> > >  cxl_core-y += mbox.o
> > > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > > index 1a50c0fc399c..adfd42370b28 100644
> > > --- a/drivers/cxl/core/core.h
> > > +++ b/drivers/cxl/core/core.h
> > > @@ -9,6 +9,9 @@ extern const struct device_type cxl_nvdimm_type;
> > >
> > >  extern struct attribute_group cxl_base_attribute_group;
> > >
> > > +extern struct device_attribute dev_attr_create_region;
> > > +extern struct device_attribute dev_attr_delete_region;
> > > +
> > >  struct cxl_send_command;
> > >  struct cxl_mem_query_commands;
> > >  int cxl_query_cmd(struct cxl_memdev *cxlmd,
> > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > index 1e785a3affaa..860e91cae29b 100644
> > > --- a/drivers/cxl/core/port.c
> > > +++ b/drivers/cxl/core/port.c
> > > @@ -213,6 +213,8 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
> > >  };
> > >
> > >  static struct attribute *cxl_decoder_root_attrs[] = {
> > > +       &dev_attr_create_region.attr,
> > > +       &dev_attr_delete_region.attr,
> > >         &dev_attr_cap_pmem.attr,
> > >         &dev_attr_cap_ram.attr,
> > >         &dev_attr_cap_type2.attr,
> > > @@ -270,6 +272,8 @@ static void cxl_decoder_release(struct device *dev)
> > >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > >         struct cxl_port *port = to_cxl_port(dev->parent);
> > >
> > > +       ida_free(&cxld->region_ida, cxld->next_region_id);
> > > +       ida_destroy(&cxld->region_ida);
> > >         ida_free(&port->decoder_ida, cxld->id);
> > >         kfree(cxld);
> > >  }
> > > @@ -1244,6 +1248,13 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
> > >         cxld->target_type = CXL_DECODER_EXPANDER;
> > >         cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
> > >
> > > +       mutex_init(&cxld->id_lock);
> > > +       ida_init(&cxld->region_ida);
> > > +       rc = ida_alloc(&cxld->region_ida, GFP_KERNEL);
> > > +       if (rc < 0)
> > > +               goto err;
> > > +
> > > +       cxld->next_region_id = rc;
> > >         return cxld;
> > >  err:
> > >         kfree(cxld);
> > > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > > new file mode 100644
> > > index 000000000000..5576952e4aa1
> > > --- /dev/null
> > > +++ b/drivers/cxl/core/region.c
> > > @@ -0,0 +1,213 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
> > > +#include <linux/device.h>
> > > +#include <linux/module.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/idr.h>
> > > +#include <region.h>
> > > +#include <cxl.h>
> > > +#include "core.h"
> > > +
> > > +/**
> > > + * DOC: cxl core region
> > > + *
> > > + * CXL Regions represent mapped memory capacity in system physical address
> > > + * space. Whereas the CXL Root Decoders identify the bounds of potential CXL
> > > + * Memory ranges, Regions represent the active mapped capacity by the HDM
> > > + * Decoder Capability structures throughout the Host Bridges, Switches, and
> > > + * Endpoints in the topology.
> > > + */
> > > +
> > > +static void cxl_region_release(struct device *dev);
> >
> > Why forward declare this versus move cxl_region_type after the definition?
> >
> > No other CXL object release functions are forward declared.
> >
> > > +
> > > +static const struct device_type cxl_region_type = {
> > > +       .name = "cxl_region",
> > > +       .release = cxl_region_release,
> > > +};
> > > +
> > > +static struct cxl_region *to_cxl_region(struct device *dev)
> > > +{
> > > +       if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
> > > +                         "not a cxl_region device\n"))
> > > +               return NULL;
> > > +
> > > +       return container_of(dev, struct cxl_region, dev);
> > > +}
> > > +
> > > +static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
> > > +{
> > > +       struct cxl_region *cxlr;
> > > +       struct device *dev;
> > > +
> > > +       cxlr = kzalloc(sizeof(*cxlr), GFP_KERNEL);
> > > +       if (!cxlr)
> > > +               return ERR_PTR(-ENOMEM);
> > > +
> > > +       dev = &cxlr->dev;
> > > +       device_initialize(dev);
> > > +       dev->parent = &cxld->dev;
> > > +       device_set_pm_not_required(dev);
> > > +       dev->bus = &cxl_bus_type;
> > > +       dev->type = &cxl_region_type;
> > > +
> > > +       return cxlr;
> > > +}
> > > +
> > > +static void unregister_region(void *_cxlr)
> > > +{
> > > +       struct cxl_region *cxlr = _cxlr;
> > > +
> > > +       if (!test_and_set_bit(REGION_DEAD, &cxlr->flags))
> > > +               device_unregister(&cxlr->dev);
> >
> > I thought REGION_DEAD was needed to prevent double
> > devm_release_action(), not double unregister?
> >
> > > +}
> > > +
> > > +/**
> > > + * devm_cxl_add_region - Adds a region to a decoder
> > > + * @cxld: Parent decoder.
> > > + * @cxlr: Region to be added to the decoder.
> > > + *
> > > + * This is the second step of region initialization. Regions exist within an
> > > + * address space which is mapped by a @cxld. That @cxld must be a root decoder,
> > > + * and it enforces constraints upon the region as it is configured.
> > > + *
> > > + * Return: 0 if the region was added to the @cxld, else returns negative error
> > > + * code. The region will be named "regionX.Y.Z" where X is the port, Y is the
> > > + * decoder id, and Z is the region number.
> > > + */
> > > +static struct cxl_region *devm_cxl_add_region(struct cxl_decoder *cxld)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(cxld->dev.parent);
> > > +       struct cxl_region *cxlr;
> > > +       struct device *dev;
> > > +       int rc;
> > > +
> > > +       cxlr = cxl_region_alloc(cxld);
> > > +       if (IS_ERR(cxlr))
> > > +               return cxlr;
> > > +
> > > +       dev = &cxlr->dev;
> > > +
> > > +       cxlr->id = cxld->next_region_id;
> > > +       rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
> > > +       if (rc)
> > > +               goto err_out;
> > > +
> > > +       /* affirm that release will have access to the decoder's region ida  */
> > > +       get_device(&cxld->dev);
> > > +
> > > +       rc = device_add(dev);
> > > +       if (!rc)
> > > +               rc = devm_add_action_or_reset(port->uport, unregister_region,
> > > +                                             cxlr);
> > > +       if (rc)
> > > +               goto err_out;
> >
> > All the other usages in device_add() in the subsystem follow the style of:
> >
> > rc = device_add(dev);
> > if (rc)
> >     goto err;
> >
> > ...any reason to be unique here and indent the success case?
> >
> >
> > > +
> > > +       return cxlr;
> > > +
> > > +err_out:
> > > +       put_device(dev);
> > > +       kfree(cxlr);
> >
> > This is a double-free of cxlr;
> >
> > > +       return ERR_PTR(rc);
> > > +}
> > > +
> > > +static ssize_t create_region_show(struct device *dev,
> > > +                                 struct device_attribute *attr, char *buf)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(dev->parent);
> > > +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +
> > > +       return sysfs_emit(buf, "region%d.%d:%d\n", port->id, cxld->id,
> > > +                         cxld->next_region_id);
> > > +}
> > > +
> > > +static ssize_t create_region_store(struct device *dev,
> > > +                                  struct device_attribute *attr,
> > > +                                  const char *buf, size_t len)
> > > +{
> > > +       struct cxl_port *port = to_cxl_port(dev->parent);
> > > +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > > +       struct cxl_region *cxlr;
> > > +       int d, p, r, rc = 0;
> > > +
> > > +       if (sscanf(buf, "region%d.%d:%d", &p, &d, &r) != 3)
> > > +               return -EINVAL;
> > > +
> > > +       if (port->id != p || cxld->id != d)
> > > +               return -EINVAL;
> > > +
> > > +       rc = mutex_lock_interruptible(&cxld->id_lock);
> > > +       if (rc)
> > > +               return rc;
> > > +
> > > +       if (cxld->next_region_id != r) {
> > > +               rc = -EINVAL;
> > > +               goto out;
> > > +       }
> > > +
> > > +       rc = ida_alloc(&cxld->region_ida, GFP_KERNEL);
> > > +       if (rc < 0) {
> > > +               dev_dbg(dev, "Failed to get next cached id (%d)\n", rc);
> > > +               goto out;
> > > +       }
> > > +
> > > +       cxlr = devm_cxl_add_region(cxld);
> > > +       if (IS_ERR(cxlr)) {
> > > +               rc = PTR_ERR(cxlr);
> > > +               goto out;
> > > +       }
> > > +
> > > +       cxld->next_region_id = rc;
> >
> > This looks like a leak in the case when devm_cxl_add_region() fails,
> > so just move it above that call.
> >
>
> It's not super simple with the current pre-caching. If you move this above
> devm_cxl_add_region(), then you lose the previously pre-cached region. I think
> the cleaner solution is to just free the ida on failure. Pretty sure no matter
> what method you go, you need an ida_free in there somewhere. Do you see another
> way?

As soon as one thread has successfully acquired the next_region_id
then it is safe to advance and assume that the devm_cxl_add_region()
owns releasing that id.

In fact, just make that implicit. Move the ida_alloc() and the
next_region_id advancement internal to cxl_region_alloc() with a
device_lock_assert() for the id_lock. Then the recovery of the
allocated id happens naturally like all the other ids in the subsystem
i.e. at release time.
