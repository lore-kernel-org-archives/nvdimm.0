Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AE772
	for <nvdimm@lists.linux.dev>; Sat, 12 Jun 2021 00:34:18 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id 69so3641974plc.5
        for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 17:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOm+zxJbVNTQI1D7uM5dXAFgZZEjw1XfcFWMdOGJLOk=;
        b=jq6pm+IhEpVGpWxpzS/xDyCKUO3FYv5GAiZeRkgeyAk47R+A28kDyVT3neB+QCLd6W
         bdEf29j55pBRSXJ/vNBqSiUXcBVqPQ1EYBrIH4tPlHnR/oHPvbizci5yNof1mIcT6SRw
         gG7Ryrl0WF2rK88VIkv7irWsa1BznuCmnE20elOAgopIYEr7OhdPNahnmEN6de/kfVpx
         AaNNUrwwSkLiB70qtbUDTGSl31h0hDnVuXDccsh5lK+97XENC4nhQp+JgM8/2a3MuaOS
         qfP9AgeoS6/EecjTVz7qUEW+j4RY6OjiOWNhXh4380utvb4ED7W07XJ1W3bdTyKEz7Jr
         sodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOm+zxJbVNTQI1D7uM5dXAFgZZEjw1XfcFWMdOGJLOk=;
        b=HVdYUoJkA1+tSQ+OOVXVSLD5Tyi6dRuuTh8vb3r1XxWVxdyxPAy2wWMNrBgdnfA1Qo
         poJ8Cud5DOGpBZHzcxaR5c6djOxKGLOAhTeFdkHR3gluSPzRcjO93o5hFINOeO6/dxpO
         Ngw/hGtpYGF4NnoMUi/NcR04/UbvgiM9fCuuvtJtbGjeBlGiTPrPLBYoB5TTcBz0vxFX
         0tjd8/jwcFGnjW1S8/gknocmEpiozt9JwDyGDStuA8e7QQa0HIS/tEO7/IMOTYWA71NL
         hRgp//+kGUFW7jpr+W3BCCsKG8PpMgdrHUoGtD72hZNLmcAngbE4rapZXeApTGpSybTz
         BjWg==
X-Gm-Message-State: AOAM533HXCxNxq9TyINKxNiot7y+ncYFUIXb6JOxCz3w5VjnezjDjqOJ
	KyaneGFAAzpFgvNhdCWaIJAKYSh/CVFfkPUHkZ4Ovw==
X-Google-Smtp-Source: ABdhPJxKOUVn1mGhY7ytJaRvc1aXKlEiMZCwivHE12W6NE9ub0CNlim5iTn/tkcsf98yxkfn1jD2GXGb3hI+rk5zl28=
X-Received: by 2002:a17:90a:fc88:: with SMTP id ci8mr11777632pjb.13.1623458057786;
 Fri, 11 Jun 2021 17:34:17 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162336398605.2462439.17422037666825492593.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210611135715.00005da1@Huawei.com>
In-Reply-To: <20210611135715.00005da1@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jun 2021 17:34:06 -0700
Message-ID: <CAPcyv4iYD7gfRjKF12QAJeR1G7p7up5MVL94sonA1XsAQ31p9w@mail.gmail.com>
Subject: Re: [PATCH 5/5] cxl/pmem: Register 'pmem' / cxl_nvdimm devices
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 11, 2021 at 5:57 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Thu, 10 Jun 2021 15:26:26 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > While a memX device on /sys/bus/cxl represents a CXL memory expander
> > control interface, a pmemX device represents the persistent memory
> > sub-functionality. It bridges the CXL subystem to the libnvdimm nmemX
> > control interface.
> >
> > With this skeleton ndctl can now see persistent memory devices on a
> > "CXL" bus. Later patches add support for translating libnvdimm native
> > commands to CXL commands.
> >
> > # ndctl list -BDiu -b CXL
> > {
> >   "provider":"CXL",
> >   "dev":"ndbus1",
> >   "dimms":[
> >     {
> >       "dev":"nmem1",
> >       "state":"disabled"
> >     },
> >     {
> >       "dev":"nmem0",
> >       "state":"disabled"
> >     }
> >   ]
> > }
> >
> > Given nvdimm_bus_unregister() removes all devices on an ndbus0 the
> > cxl_pmem infrastructure needs to arrange ->remove() to be triggered on
> > cxl_nvdimm devices to keep their enabled state synchronized with the
> > registration state of their corresponding device on the nvdimm_bus. In
> > other words, always arrange for cxl_nvdimm_driver.remove() to unregister
> > nvdimms from an nvdimm_bus ahead of the bus being unregistered.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Being my usual fussy self, I've highlighed a few header changes that
> as far as I can see are unrelated to this specific patch.
>
> Otherwise, one request for a local variable name change and
> a bit of trivial editorial stuff.
>
> Thanks,
>
> Jonathan
>
>
> > ---
> >  drivers/cxl/core.c |   86 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxl.h  |   13 ++++++
> >  drivers/cxl/mem.h  |    2 +
> >  drivers/cxl/pci.c  |   23 ++++++++---
> >  drivers/cxl/pmem.c |  111 +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  5 files changed, 217 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/cxl/core.c b/drivers/cxl/core.c
> > index f0305c9c91c8..6db660249cea 100644
> > --- a/drivers/cxl/core.c
> > +++ b/drivers/cxl/core.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/idr.h>
> >  #include "cxl.h"
> > +#include "mem.h"

Looks like this can go too...

> >
> >  /**
> >   * DOC: cxl core
> > @@ -731,6 +732,89 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
> >  }
> >  EXPORT_SYMBOL_GPL(devm_cxl_add_nvdimm_bridge);
> >
> > +static void cxl_nvdimm_release(struct device *dev)
> > +{
> > +     struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > +
> > +     kfree(cxl_nvd);
> > +}
> > +
> > +static const struct attribute_group *cxl_nvdimm_attribute_groups[] = {
> > +     &cxl_base_attribute_group,
> > +     NULL,
> > +};
> > +
> > +static const struct device_type cxl_nvdimm_type = {
> > +     .name = "cxl_nvdimm",
> > +     .release = cxl_nvdimm_release,
> > +     .groups = cxl_nvdimm_attribute_groups,
> > +};
> > +
> > +bool is_cxl_nvdimm(struct device *dev)
> > +{
> > +     return dev->type == &cxl_nvdimm_type;
> > +}
> > +EXPORT_SYMBOL_GPL(is_cxl_nvdimm);
> > +
> > +struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev)
> > +{
> > +     if (dev_WARN_ONCE(dev, !is_cxl_nvdimm(dev),
> > +                       "not a cxl_nvdimm device\n"))
> > +             return NULL;
> > +     return container_of(dev, struct cxl_nvdimm, dev);
> > +}
> > +EXPORT_SYMBOL_GPL(to_cxl_nvdimm);
> > +
> > +static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
> > +{
> > +     struct cxl_nvdimm *cxl_nvd;
> > +     struct device *dev;
> > +
> > +     cxl_nvd = kzalloc(sizeof(*cxl_nvd), GFP_KERNEL);
> > +     if (!cxl_nvd)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     dev = &cxl_nvd->dev;
> > +     cxl_nvd->cxlmd = cxlmd;
> > +     device_initialize(dev);
> > +     device_set_pm_not_required(dev);
> > +     dev->parent = &cxlmd->dev;
> > +     dev->bus = &cxl_bus_type;
> > +     dev->type = &cxl_nvdimm_type;
> > +
> > +     return cxl_nvd;
> > +}
> > +
> > +int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
> > +{
> > +     struct cxl_nvdimm *cxl_nvd;
> > +     struct device *dev;
> > +     int rc;
> > +
> > +     cxl_nvd = cxl_nvdimm_alloc(cxlmd);
> > +     if (IS_ERR(cxl_nvd))
> > +             return PTR_ERR(cxl_nvd);
> > +
> > +     dev = &cxl_nvd->dev;
> > +     rc = dev_set_name(dev, "pmem%d", cxlmd->id);
> > +     if (rc)
> > +             goto err;
> > +
> > +     rc = device_add(dev);
> > +     if (rc)
> > +             goto err;
> > +
> > +     dev_dbg(host, "%s: register %s\n", dev_name(dev->parent),
> > +             dev_name(dev));
> > +
> > +     return devm_add_action_or_reset(host, unregister_dev, dev);
> > +
> > +err:
> > +     put_device(dev);
> > +     return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(devm_cxl_add_nvdimm);
> > +
> >  /**
> >   * cxl_probe_device_regs() - Detect CXL Device register blocks
> >   * @dev: Host device of the @base mapping
> > @@ -930,6 +1014,8 @@ static int cxl_device_id(struct device *dev)
> >  {
> >       if (dev->type == &cxl_nvdimm_bridge_type)
> >               return CXL_DEVICE_NVDIMM_BRIDGE;
> > +     if (dev->type == &cxl_nvdimm_type)
> > +             return CXL_DEVICE_NVDIMM;
> >       return 0;
> >  }
> >
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 47fcb7ad5978..3f9a6f7b05db 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -213,6 +213,13 @@ struct cxl_nvdimm_bridge {
> >       enum cxl_nvdimm_brige_state state;
> >  };
> >
> > +struct cxl_mem;
>
> Above looks unrelated as you've not added any uses of cxl_mem

I think it was a refactoring leftover from an abandoned approach.

Gone now.

>
> > +struct cxl_nvdimm {
> > +     struct device dev;
> > +     struct cxl_memdev *cxlmd;
> > +     struct nvdimm *nvdimm;
> > +};
> > +
> >  /**
> >   * struct cxl_port - logical collection of upstream port devices and
> >   *                downstream port devices to construct a CXL memory
> > @@ -299,7 +306,8 @@ int __cxl_driver_register(struct cxl_driver *cxl_drv, struct module *owner,
> >  #define cxl_driver_register(x) __cxl_driver_register(x, THIS_MODULE, KBUILD_MODNAME)
> >  void cxl_driver_unregister(struct cxl_driver *cxl_drv);
> >
> > -#define CXL_DEVICE_NVDIMM_BRIDGE 1
> > +#define CXL_DEVICE_NVDIMM_BRIDGE     1
> > +#define CXL_DEVICE_NVDIMM            2
> >
> >  #define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
> >  #define CXL_MODALIAS_FMT "cxl:t%d"
> > @@ -307,4 +315,7 @@ void cxl_driver_unregister(struct cxl_driver *cxl_drv);
> >  struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev);
> >  struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
> >                                                    struct cxl_port *port);
> > +struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
> > +bool is_cxl_nvdimm(struct device *dev);
> > +int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
> >  #endif /* __CXL_H__ */
> > diff --git a/drivers/cxl/mem.h b/drivers/cxl/mem.h
> > index 13868ff7cadf..8f02d02b26b4 100644
> > --- a/drivers/cxl/mem.h
> > +++ b/drivers/cxl/mem.h
> > @@ -2,6 +2,8 @@
> >  /* Copyright(c) 2020-2021 Intel Corporation. */
> >  #ifndef __CXL_MEM_H__
> >  #define __CXL_MEM_H__
> > +#include <linux/cdev.h>
>
> Unrelated to rest of patch.  Good to add this, but not hidden in this
> patch.

Yup.

>
> > +#include "cxl.h"
> >
> >  /* CXL 2.0 8.2.8.5.1.1 Memory Device Status Register */
> >  #define CXLMDEV_STATUS_OFFSET 0x0
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 5a1705b52278..83e81b44c8f5 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -1313,7 +1313,8 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm)
> >       return ERR_PTR(rc);
> >  }
> >
> > -static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
> > +static struct cxl_memdev *devm_cxl_add_memdev(struct device *host,
> > +                                           struct cxl_mem *cxlm)
> >  {
> >       struct cxl_memdev *cxlmd;
> >       struct device *dev;
> > @@ -1322,7 +1323,7 @@ static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
> >
> >       cxlmd = cxl_memdev_alloc(cxlm);
> >       if (IS_ERR(cxlmd))
> > -             return PTR_ERR(cxlmd);
> > +             return cxlmd;
> >
> >       dev = &cxlmd->dev;
> >       rc = dev_set_name(dev, "mem%d", cxlmd->id);
> > @@ -1340,8 +1341,10 @@ static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
> >       if (rc)
> >               goto err;
> >
> > -     return devm_add_action_or_reset(dev->parent, cxl_memdev_unregister,
> > -                                     cxlmd);
> > +     rc = devm_add_action_or_reset(host, cxl_memdev_unregister, cxlmd);
> > +     if (rc)
> > +             return ERR_PTR(rc);
> > +     return cxlmd;
> >
> >  err:
> >       /*
> > @@ -1350,7 +1353,7 @@ static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
> >        */
> >       cxl_memdev_shutdown(cxlmd);
> >       put_device(dev);
> > -     return rc;
> > +     return ERR_PTR(rc);
> >  }
> >
> >  static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
> > @@ -1561,6 +1564,7 @@ static int cxl_mem_identify(struct cxl_mem *cxlm)
> >
> >  static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  {
> > +     struct cxl_memdev *cxlmd;
> >       struct cxl_mem *cxlm;
> >       int rc;
> >
> > @@ -1588,7 +1592,14 @@ static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >       if (rc)
> >               return rc;
> >
> > -     return cxl_mem_add_memdev(cxlm);
> > +     cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlm);
> > +     if (IS_ERR(cxlmd))
> > +             return PTR_ERR(cxlmd);
> > +
> > +     if (range_len(&cxlm->pmem_range) && IS_ENABLED(CONFIG_CXL_PMEM))
> > +             rc = devm_cxl_add_nvdimm(&pdev->dev, cxlmd);
> > +
> > +     return rc;
> >  }
> >
> >  static const struct pci_device_id cxl_mem_pci_tbl[] = {
> > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > index 0067bd734559..1ed19e213157 100644
> > --- a/drivers/cxl/pmem.c
> > +++ b/drivers/cxl/pmem.c
> > @@ -3,7 +3,10 @@
> >  #include <linux/libnvdimm.h>
> >  #include <linux/device.h>
> >  #include <linux/module.h>
> > +#include <linux/ndctl.h>
> > +#include <linux/async.h>
> >  #include <linux/slab.h>
> > +#include "mem.h"
> >  #include "cxl.h"
> >
> >  /*
> > @@ -13,6 +16,64 @@
> >   */
> >  static struct workqueue_struct *cxl_pmem_wq;
> >
> > +static void unregister_nvdimm(void *nvdimm)
> > +{
> > +     nvdimm_delete(nvdimm);
> > +}
> > +
> > +static int match_nvdimm_bridge(struct device *dev, const void *data)
> > +{
> > +     return strcmp(dev_name(dev), "nvdimm-bridge") == 0;
> > +}
> > +
> > +static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> > +{
> > +     struct device *dev;
> > +
> > +     dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
>
> Hmm. It's a singleton, so you could just stash the pointer somewhere
> appropriate, but I guess this avoids adding extra infrastructure around
> that, so fair enough.

Yeah, it's a singleton only by convention. If you want to have
multiple CXL nvdimm buses the core won't prevent it.

>
> > +     if (!dev)
> > +             return NULL;
> > +     return to_cxl_nvdimm_bridge(dev);
> > +}
> > +
> > +static int cxl_nvdimm_probe(struct device *dev)
> > +{
> > +     struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > +     struct cxl_nvdimm_bridge *cxl_nvb;
> > +     unsigned long flags = 0;
> > +     struct nvdimm *nvdimm;
> > +     int rc = -ENXIO;
> > +
> > +     cxl_nvb = cxl_find_nvdimm_bridge();
> > +     if (!cxl_nvb)
> > +             return -ENXIO;
> > +
> > +     device_lock(&cxl_nvb->dev);
> > +     if (!cxl_nvb->nvdimm_bus)
> > +             goto out;
> > +
> > +     set_bit(NDD_LABELING, &flags);
> > +     nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
> > +                            NULL);
> > +     if (!nvdimm)
> > +             goto out;
> > +
> > +     dev_set_drvdata(dev, nvdimm);
>
> Why?  No harm done, but I wanted to check this was only used to get the
> nvdimm, but can't find where it's used at all.

Yup, vestigial. I thought I would use it in the release action, but
now it's just passed directly to unregister_nvdimm().

>
> > +
> > +     rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
> > +out:
> > +     device_unlock(&cxl_nvb->dev);
> > +     put_device(&cxl_nvb->dev);
> > +
> > +     return rc;
> > +}
> > +
> > +static struct cxl_driver cxl_nvdimm_driver = {
> > +     .name = "cxl_nvdimm",
> > +     .probe = cxl_nvdimm_probe,
> > +     .id = CXL_DEVICE_NVDIMM,
> > +};
> > +
> >  static int cxl_pmem_ctl(struct nvdimm_bus_descriptor *nd_desc,
> >                       struct nvdimm *nvdimm, unsigned int cmd, void *buf,
> >                       unsigned int buf_len, int *cmd_rc)
> > @@ -28,19 +89,31 @@ static void online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
> >               nvdimm_bus_register(&cxl_nvb->dev, &cxl_nvb->nd_desc);
> >  }
> >
> > -static void offline_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
> > +static int cxl_nvdimm_release_driver(struct device *dev, void *data)
> >  {
> > -     if (!cxl_nvb->nvdimm_bus)
> > -             return;
> > -     nvdimm_bus_unregister(cxl_nvb->nvdimm_bus);
> > -     cxl_nvb->nvdimm_bus = NULL;
> > +     if (!is_cxl_nvdimm(dev))
> > +             return 0;
> > +     device_release_driver(dev);
> > +     return 0;
> > +}
> > +
> > +static void offline_nvdimm_bus(struct nvdimm_bus *nvdimm_bus)
> > +{
> > +     /*
> > +      * Set the state of cxl_nvdimm devices to unbound / idle before
> > +      * nvdimm_bus_unregister() rips the nvdimm objects out from
> > +      * underneath them.
> > +      */
> > +     bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_nvdimm_release_driver);
> > +     nvdimm_bus_unregister(nvdimm_bus);
> >  }
> >
> >  static void cxl_nvb_update_state(struct work_struct *work)
> >  {
> >       struct cxl_nvdimm_bridge *cxl_nvb =
> >               container_of(work, typeof(*cxl_nvb), state_work);
> > -     bool release = false;
> > +     struct nvdimm_bus *nvdimm_bus = NULL;
> > +     bool release = false, rescan = false;
> >
> >       device_lock(&cxl_nvb->dev);
> >       switch (cxl_nvb->state) {
> > @@ -50,11 +123,13 @@ static void cxl_nvb_update_state(struct work_struct *work)
> >                       dev_err(&cxl_nvb->dev,
> >                               "failed to establish nvdimm bus\n");
> >                       release = true;
> > -             }
> > +             } else
> > +                     rescan = true;
> >               break;
> >       case CXL_NVB_OFFLINE:
> >       case CXL_NVB_DEAD:
> > -             offline_nvdimm_bus(cxl_nvb);
> > +             nvdimm_bus = cxl_nvb->nvdimm_bus;
>
> Perhaps rename this to make it clear that it only exists as a means
> to offline it later?  I wondered briefly why you were offlining
> any bus that existed (e.g. in the online case)
>
> nvdimm_bus_to_offline = ...
>

Good point, although I renamed it to "victim_bus", and made
offline_nvdimm_bus() handle the NULL bus case, so now it reads with no
conditional.

offline_nvdimm_bus(victim_bus);


> > +             cxl_nvb->nvdimm_bus = NULL;
> >               break;
> >       default:
> >               break;
> > @@ -63,6 +138,13 @@ static void cxl_nvb_update_state(struct work_struct *work)
> >
> >       if (release)
> >               device_release_driver(&cxl_nvb->dev);
> > +     if (rescan) {
> > +             int rc = bus_rescan_devices(&cxl_bus_type);
> > +
> > +             dev_dbg(&cxl_nvb->dev, "rescan: %d\n", rc);
> > +     }
> > +     if (nvdimm_bus)
> > +             offline_nvdimm_bus(nvdimm_bus);
> >
> >       put_device(&cxl_nvb->dev);
> >  }
> > @@ -113,23 +195,29 @@ static __init int cxl_pmem_init(void)
> >       int rc;
> >
> >       cxl_pmem_wq = alloc_ordered_workqueue("cxl_pmem", 0);
> > -
>
> Shouldn't be here obviously. Move to earlier patch.

Yup.
