Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 344E51A1FEF
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 09:40:39 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id k142so34143538oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 09:40:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160517085200.GH17154@c203.arch.suse.de>
References: <146329357870.17948.14240958684074905846.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146329358394.17948.9595519335631675126.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160517085200.GH17154@c203.arch.suse.de>
Date: Tue, 17 May 2016 09:40:33 -0700
Message-ID: <CAPcyv4j8UPpC0z3mpekZ_Gu2Cwf=5Z+UL4UQSQcTABbR_1VNyg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] /dev/dax, pmem: direct access to persistent memory
From: Dan Williams <dan.j.williams@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 17, 2016 at 1:52 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Sat, May 14, 2016 at 11:26:24PM -0700, Dan Williams wrote:
>> Device DAX is the device-centric analogue of Filesystem DAX
>> (CONFIG_FS_DAX).  It allows memory ranges to be allocated and mapped
>> without need of an intervening file system.  Device DAX is strict,
>> precise and predictable.  Specifically this interface:
>>
>> 1/ Guarantees fault granularity with respect to a given page size (pte,
>> pmd, or pud) set at configuration time.
>>
>> 2/ Enforces deterministic behavior by being strict about what fault
>> scenarios are supported.
>>
>> For example, by forcing MADV_DONTFORK semantics and omitting MAP_PRIVATE
>> support device-dax guarantees that a mapping always behaves/performs the
>> same once established.  It is the "what you see is what you get" access
>> mechanism to differentiated memory vs filesystem DAX which has
>> filesystem specific implementation semantics.
>>
>> Persistent memory is the first target, but the mechanism is also
>> targeted for exclusive allocations of performance differentiated memory
>> ranges.
>>
>> This commit is limited to the base device driver infrastructure to
>> associate a dax device with pmem range.
>>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/Kconfig                     |    2
>>  drivers/Makefile                    |    1
>>  drivers/dax/Kconfig                 |   25 +++
>>  drivers/dax/Makefile                |    4 +
>>  drivers/dax/dax.c                   |  252 +++++++++++++++++++++++++++++++++++
>>  drivers/dax/dax.h                   |   24 +++
>>  drivers/dax/pmem.c                  |  168 +++++++++++++++++++++++
>
> Is a DAX device always a NVDIMM device, or can it be something else (like the
> S390 dcssblk)? If it's NVDIMM only I'd suggest it to go under the
> drivers/nvdimm directory.

The plan is that it can be something else, like high bandwidth memory
for example.

>>  tools/testing/nvdimm/Kbuild         |    9 +
>>  tools/testing/nvdimm/config_check.c |    2
>>  9 files changed, 487 insertions(+)
>>  create mode 100644 drivers/dax/Kconfig
>>  create mode 100644 drivers/dax/Makefile
>>  create mode 100644 drivers/dax/dax.c
>>  create mode 100644 drivers/dax/dax.h
>>  create mode 100644 drivers/dax/pmem.c
>>
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index d2ac339de85f..8298eab84a6f 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -190,6 +190,8 @@ source "drivers/android/Kconfig"
>>
>>  source "drivers/nvdimm/Kconfig"
>>
>> +source "drivers/dax/Kconfig"
>> +
>>  source "drivers/nvmem/Kconfig"
>>
>>  source "drivers/hwtracing/stm/Kconfig"
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 8f5d076baeb0..0b6f3d60193d 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -66,6 +66,7 @@ obj-$(CONFIG_PARPORT)               += parport/
>>  obj-$(CONFIG_NVM)            += lightnvm/
>>  obj-y                                += base/ block/ misc/ mfd/ nfc/
>>  obj-$(CONFIG_LIBNVDIMM)              += nvdimm/
>> +obj-$(CONFIG_DEV_DAX)                += dax/
>>  obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf/
>>  obj-$(CONFIG_NUBUS)          += nubus/
>>  obj-y                                += macintosh/
>> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
>> new file mode 100644
>> index 000000000000..86ffbaa891ad
>> --- /dev/null
>> +++ b/drivers/dax/Kconfig
>> @@ -0,0 +1,25 @@
>> +menuconfig DEV_DAX
>> +     tristate "DAX: direct access to differentiated memory"
>> +     default m if NVDIMM_DAX
>> +     help
>> +       Support raw access to differentiated (persistence, bandwidth,
>> +       latency...) memory via an mmap(2) capable character
>> +       device.  Platform firmware or a device driver may identify a
>> +       platform memory resource that is differentiated from the
>> +       baseline memory pool.  Mappings of a /dev/daxX.Y device impose
>> +       restrictions that make the mapping behavior deterministic.
>> +
>> +if DEV_DAX
>> +
>> +config DEV_DAX_PMEM
>> +     tristate "PMEM DAX: direct access to persistent memory"
>> +     depends on NVDIMM_DAX
>> +     default DEV_DAX
>> +     help
>> +       Support raw access to persistent memory.  Note that this
>> +       driver consumes memory ranges allocated and exported by the
>> +       libnvdimm sub-system.
>> +
>> +       Say Y if unsure
>> +
>> +endif
>> diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
>> new file mode 100644
>> index 000000000000..27c54e38478a
>> --- /dev/null
>> +++ b/drivers/dax/Makefile
>> @@ -0,0 +1,4 @@
>> +obj-$(CONFIG_DEV_DAX) += dax.o
>> +obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
>> +
>> +dax_pmem-y := pmem.o
>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>> new file mode 100644
>> index 000000000000..8207fb33a992
>> --- /dev/null
>> +++ b/drivers/dax/dax.c
[..]
>> +void dax_region_put(struct dax_region *dax_region)
>> +{
>> +     kref_put(&dax_region->kref, dax_region_free);
>> +}
>> +EXPORT_SYMBOL_GPL(dax_region_put);
>
> dax_region_get() ??

There's currently no public (outside of dax.c) usage for taking a
reference against a region.  This export is really only there to keep
dax_region_free() private.

>> +
>> +static void dax_dev_free(struct kref *kref)
>> +{
>> +     struct dax_dev *dax_dev;
>> +
>> +     dax_dev = container_of(kref, struct dax_dev, kref);
>> +     dax_region_put(dax_dev->region);
>> +     kfree(dax_dev);
>> +}
>> +
>> +static void dax_dev_put(struct dax_dev *dax_dev)
>> +{
>> +     kref_put(&dax_dev->kref, dax_dev_free);
>> +}
>> +
>> +struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>> +             struct resource *res, unsigned int align, void *addr,
>> +             unsigned long pfn_flags)
>> +{
>> +     struct dax_region *dax_region;
>> +
>> +     dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
>> +
>> +     if (!dax_region)
>> +             return NULL;
>> +
>> +     memcpy(&dax_region->res, res, sizeof(*res));
>> +     dax_region->pfn_flags = pfn_flags;
>> +     kref_init(&dax_region->kref);
>> +     dax_region->id = region_id;
>> +     ida_init(&dax_region->ida);
>> +     dax_region->align = align;
>> +     dax_region->dev = parent;
>> +     dax_region->base = addr;
>> +
>> +     return dax_region;
>> +}
>> +EXPORT_SYMBOL_GPL(alloc_dax_region);
>> +
>> +static ssize_t size_show(struct device *dev,
>> +             struct device_attribute *attr, char *buf)
>> +{
>> +     struct dax_dev *dax_dev = dev_get_drvdata(dev);
>> +     unsigned long long size = 0;
>> +     int i;
>> +
>> +     for (i = 0; i < dax_dev->num_resources; i++)
>> +             size += resource_size(&dax_dev->res[i]);
>> +
>> +     return sprintf(buf, "%llu\n", size);
>> +}
>> +static DEVICE_ATTR_RO(size);
>> +
>> +static struct attribute *dax_device_attributes[] = {
>> +     &dev_attr_size.attr,
>> +     NULL,
>> +};
>> +
>> +static const struct attribute_group dax_device_attribute_group = {
>> +     .attrs = dax_device_attributes,
>> +};
>> +
>> +static const struct attribute_group *dax_attribute_groups[] = {
>> +     &dax_device_attribute_group,
>> +     NULL,
>> +};
>> +
>> +static void destroy_dax_dev(void *_dev)
>> +{
>> +     struct device *dev = _dev;
>> +     struct dax_dev *dax_dev = dev_get_drvdata(dev);
>> +     struct dax_region *dax_region = dax_dev->region;
>> +
>> +     dev_dbg(dev, "%s\n", __func__);
>
> This dev_dbg() could be replaced by function graph tracing.

Not without an explicit trace point to re-add the dev_printk details.
What I really want, and has been on the back burner for a long time,
is to enhance dynamic debug to turn all individual dev_dbg()
statements optionally into trace points.

>
>> +
>> +     get_device(dev);
>> +     device_unregister(dev);
>> +     ida_simple_remove(&dax_region->ida, dax_dev->id);
>> +     ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
>> +     put_device(dev);
>> +     dax_dev_put(dax_dev);
>> +}
>> +
>> +int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
>> +             int count)
>> +{
>> +     struct device *parent = dax_region->dev;
>> +     struct dax_dev *dax_dev;
>> +     struct device *dev;
>> +     int rc, minor;
>> +     dev_t dev_t;
>> +
>> +     dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
>> +     if (!dax_dev)
>> +             return -ENOMEM;
>> +     memcpy(dax_dev->res, res, sizeof(*res) * count);
>> +     dax_dev->num_resources = count;
>> +     kref_init(&dax_dev->kref);
>> +     dax_dev->region = dax_region;
>> +     kref_get(&dax_region->kref);
>
> dax_region_get() ?

I'm not sure that trivial wrapper is worth it.

>> +
>> +     dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
>> +     if (dax_dev->id < 0) {
>> +             rc = dax_dev->id;
>> +             goto err_id;
>> +     }
>> +
>> +     minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
>> +     if (minor < 0) {
>> +             rc = minor;
>> +             goto err_minor;
>> +     }
>> +
>> +     dev_t = MKDEV(dax_major, minor);
>> +     dev = device_create_with_groups(dax_class, parent, dev_t, dax_dev,
>> +                     dax_attribute_groups, "dax%d.%d", dax_region->id,
>> +                     dax_dev->id);
>> +     if (IS_ERR(dev)) {
>> +             rc = PTR_ERR(dev);
>> +             goto err_create;
>> +     }
>> +     dax_dev->dev = dev;
>> +
>> +     rc = devm_add_action(dax_region->dev, destroy_dax_dev, dev);
>> +     if (rc) {
>> +             destroy_dax_dev(dev);
>> +             return rc;
>> +     }
>> +
>> +     return 0;
>> +
>> + err_create:
>> +     ida_simple_remove(&dax_minor_ida, minor);
>> + err_minor:
>> +     ida_simple_remove(&dax_region->ida, dax_dev->id);
>> + err_id:
>> +     dax_dev_put(dax_dev);
>> +
>> +     return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(devm_create_dax_dev);
>> +
>> +static const struct file_operations dax_fops = {
>> +     .llseek = noop_llseek,
>> +     .owner = THIS_MODULE,
>> +};
>> +
>> +static int __init dax_init(void)
>> +{
>> +     int rc;
>> +
>> +     rc = register_chrdev(0, "dax", &dax_fops);
>> +     if (rc < 0)
>> +             return rc;
>> +     dax_major = rc;
>> +
>> +     dax_class = class_create(THIS_MODULE, "dax");
>> +     if (IS_ERR(dax_class)) {
>> +             unregister_chrdev(dax_major, "dax");
>> +             return PTR_ERR(dax_class);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void __exit dax_exit(void)
>> +{
>> +     class_destroy(dax_class);
>> +     unregister_chrdev(dax_major, "dax");
>
> AFAICT you're missing a call to ida_destroy(&dax_minor_ida); here.

Indeed, you're right.  That same bug is also present in multiple
places in drivers/nvdimm/.

[..]
>> diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
>> new file mode 100644
>> index 000000000000..d8b8f1f25054
>> --- /dev/null
>> +++ b/drivers/dax/dax.h
>> @@ -0,0 +1,24 @@
>> +/*
>> + * Copyright(c) 2016 Intel Corporation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +#ifndef __DAX_H__
>> +#define __DAX_H__
>> +struct device;
>> +struct resource;
>> +struct dax_region;
>> +void dax_region_put(struct dax_region *dax_region);
>> +struct dax_region *alloc_dax_region(struct device *parent,
>> +             int region_id, struct resource *res, unsigned int align,
>> +             void *addr, unsigned long flags);
>> +int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
>> +             int count);
>> +#endif /* __DAX_H__ */
>> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
>> new file mode 100644
>> index 000000000000..4e97555e1cab
>> --- /dev/null
>> +++ b/drivers/dax/pmem.c
>> @@ -0,0 +1,168 @@
>> +/*
>> + * Copyright(c) 2016 Intel Corporation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +#include <linux/percpu-refcount.h>
>> +#include <linux/memremap.h>
>> +#include <linux/module.h>
>> +#include <linux/pfn_t.h>
>> +#include "../nvdimm/pfn.h"
>> +#include "../nvdimm/nd.h"
>> +#include "dax.h"
>> +
>> +struct dax_pmem {
>> +     struct device *dev;
>> +     struct percpu_ref ref;
>> +     struct completion cmp;
>> +};
>> +
>> +struct dax_pmem *to_dax_pmem(struct percpu_ref *ref)
>> +{
>> +     return container_of(ref, struct dax_pmem, ref);
>> +}
>> +
>> +static void dax_pmem_percpu_release(struct percpu_ref *ref)
>> +{
>> +     struct dax_pmem *dax_pmem = to_dax_pmem(ref);
>> +
>> +     dev_dbg(dax_pmem->dev, "%s\n", __func__);
>
> This dev_dbg() could be replaced by function graph tracing.

[..]
>> +     dev_dbg(dax_pmem->dev, "%s\n", __func__);
>
> Same as above.
>
[..]
>> +     dev_dbg(dax_pmem->dev, "%s\n", __func__);
>
> Same as above.

Same reply as before to these...

>
>> +     percpu_ref_kill(ref);
>> +}
>> +
>> +static int dax_pmem_probe(struct device *dev)
>> +{
>> +     int rc;
>> +     void *addr;
>> +     struct resource res;
>> +     struct nd_pfn_sb *pfn_sb;
>> +     struct dax_pmem *dax_pmem;
>> +     struct nd_region *nd_region;
>> +     struct nd_namespace_io *nsio;
>> +     struct dax_region *dax_region;
>> +     struct nd_namespace_common *ndns;
>> +     struct nd_dax *nd_dax = to_nd_dax(dev);
>> +     struct nd_pfn *nd_pfn = &nd_dax->nd_pfn;
>> +     struct vmem_altmap __altmap, *altmap = NULL;
>> +
>> +     ndns = nvdimm_namespace_common_probe(dev);
>> +     if (IS_ERR(ndns))
>> +             return PTR_ERR(ndns);
>> +     nsio = to_nd_namespace_io(&ndns->dev);
>> +
>> +     /* parse the 'pfn' info block via ->rw_bytes */
>> +     devm_nsio_enable(dev, nsio);
>> +     altmap = nvdimm_setup_pfn(nd_pfn, &res, &__altmap);
>> +     if (IS_ERR(altmap))
>> +             return PTR_ERR(altmap);
>> +     devm_nsio_disable(dev, nsio);
>> +
>> +     pfn_sb = nd_pfn->pfn_sb;
>> +
>> +     if (!devm_request_mem_region(dev, nsio->res.start,
>> +                             resource_size(&nsio->res), dev_name(dev))) {
>> +             dev_warn(dev, "could not reserve region %pR\n", &nsio->res);
>> +             return -EBUSY;
>> +     }
>> +
>> +     dax_pmem = devm_kzalloc(dev, sizeof(*dax_pmem), GFP_KERNEL);
>> +     if (!dax_pmem)
>> +             return -ENOMEM;
>> +
>> +     dax_pmem->dev = dev;
>> +     init_completion(&dax_pmem->cmp);
>> +     rc = percpu_ref_init(&dax_pmem->ref, dax_pmem_percpu_release, 0,
>> +                     GFP_KERNEL);
>> +     if (rc)
>> +             return rc;
>> +
>> +     rc = devm_add_action(dev, dax_pmem_percpu_exit, &dax_pmem->ref);
>> +     if (rc) {
>> +             dax_pmem_percpu_exit(&dax_pmem->ref);
>> +             return rc;
>> +     }
>> +
>> +     addr = devm_memremap_pages(dev, &res, &dax_pmem->ref, altmap);
>> +     if (IS_ERR(addr))
>> +             return PTR_ERR(addr);
>> +
>> +     rc = devm_add_action(dev, dax_pmem_percpu_kill, &dax_pmem->ref);
>> +     if (rc) {
>> +             dax_pmem_percpu_kill(&dax_pmem->ref);
>> +             return rc;
>> +     }
>> +
>> +     nd_region = to_nd_region(dev->parent);
>> +     dax_region = alloc_dax_region(dev, nd_region->id, &res,
>> +                     le32_to_cpu(pfn_sb->align), addr, PFN_DEV|PFN_MAP);
>> +     if (!dax_region)
>> +             return -ENOMEM;
>> +
>> +     /* TODO: support for subdividing a dax region... */
>> +     rc = devm_create_dax_dev(dax_region, &res, 1);
>> +
>> +     /* child dax_dev instances now own the lifetime of the dax_region */
>> +     dax_region_put(dax_region);
>> +
>> +     return rc;
>> +}
>> +
>> +static int dax_pmem_remove(struct device *dev)
>> +{
>> +     /*
>> +      * The init path is fully devm-enabled, or child devices
>> +      * otherwise hold references on parent resources.
>> +      */
>
> So remove is completely pointless here. Why are you depending on it in
> __nd_driver_register()? __device_release_driver() does not depend on a remove
> callback to be present.

Good point, I'll just remove the need for it.

[..]

Thanks, Johannes!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
