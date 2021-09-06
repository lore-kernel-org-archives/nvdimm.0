Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8393FC1
	for <nvdimm@lists.linux.dev>; Mon,  6 Sep 2021 08:57:18 +0000 (UTC)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H32Kf5SbYz67cq6;
	Mon,  6 Sep 2021 16:55:18 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 6 Sep 2021 10:57:15 +0200
Received: from localhost (10.52.120.86) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 6 Sep 2021
 09:57:14 +0100
Date: Mon, 6 Sep 2021 09:57:15 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>, kernel
 test robot <lkp@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	"Schofield, Alison" <alison.schofield@intel.com>, Linux NVDIMM
	<nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH v3 27/28] tools/testing/cxl: Introduce a mock memory
 device + driver
Message-ID: <20210906095715.00005dbe@Huawei.com>
In-Reply-To: <CAPcyv4hjCQ8dNieUTKw52LSe+N-Vrr8q7UDqHWGx8NnB7+g=GQ@mail.gmail.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982126962.1124374.4032057539749435582.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20210903142118.00003ef3@Huawei.com>
	<CAPcyv4hjCQ8dNieUTKw52LSe+N-Vrr8q7UDqHWGx8NnB7+g=GQ@mail.gmail.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.120.86]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Fri, 3 Sep 2021 16:33:11 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Fri, Sep 3, 2021 at 6:21 AM Jonathan Cameron
> <Jonathan.Cameron@huawei.com> wrote:
> >
> > On Tue, 24 Aug 2021 09:07:49 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >  
> > > Introduce an emulated device-set plus driver to register CXL memory
> > > devices, 'struct cxl_memdev' instances, in the mock cxl_test topology.
> > > This enables the development of HDM Decoder (Host-managed Device Memory
> > > Decoder) programming flow (region provisioning) in an environment that
> > > can be updated alongside the kernel as it gains more functionality.
> > >
> > > Whereas the cxl_pci module looks for CXL memory expanders on the 'pci'
> > > bus, the cxl_mock_mem module attaches to CXL expanders on the platform
> > > bus emitted by cxl_test.
> > >
> > > Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> > > Reported-by: kernel test robot <lkp@intel.com>  
> >
> > Perhaps say what was reported?  
> 
> I don't think so. That would be like documenting all patch review
> comments in the changelog. At some point the mailing list archives and
> cover letters are there to recall precise comments on patches.

Your choice. I guess it's clear here that the need for this patch
wasn't a reported-by.

I think this fits in the same category as when people give
a per driver Ack on patches that affect numerous drivers.  Where possible
I try to keep that information.

> 
> >  
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>  
> >
> > one query inline, otherwise I think this looks fine.
> >
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >  
> > > ---
> > >  drivers/cxl/core/pmem.c       |    6 -
> > >  drivers/cxl/cxl.h             |    2
> > >  drivers/cxl/pmem.c            |    2
> > >  tools/testing/cxl/Kbuild      |    2
> > >  tools/testing/cxl/mock_pmem.c |   24 ++++
> > >  tools/testing/cxl/test/Kbuild |    4 +
> > >  tools/testing/cxl/test/cxl.c  |   73 ++++++++++++
> > >  tools/testing/cxl/test/mem.c  |  255 +++++++++++++++++++++++++++++++++++++++++
> > >  8 files changed, 362 insertions(+), 6 deletions(-)
> > >  create mode 100644 tools/testing/cxl/mock_pmem.c
> > >  create mode 100644 tools/testing/cxl/test/mem.c
> > >
> > > diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> > > index ec3e4c642fca..68046b6a22b5 100644
> > > --- a/drivers/cxl/core/pmem.c
> > > +++ b/drivers/cxl/core/pmem.c
> > > @@ -39,16 +39,16 @@ struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev)
> > >  }
> > >  EXPORT_SYMBOL_GPL(to_cxl_nvdimm_bridge);
> > >
> > > -static int match_nvdimm_bridge(struct device *dev, const void *data)
> > > +__mock int match_nvdimm_bridge(struct device *dev, const void *data)
> > >  {
> > >       return dev->type == &cxl_nvdimm_bridge_type;
> > >  }
> > >
> > > -struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> > > +struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd)
> > >  {
> > >       struct device *dev;
> > >
> > > -     dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
> > > +     dev = bus_find_device(&cxl_bus_type, NULL, cxl_nvd, match_nvdimm_bridge);
> > >       if (!dev)
> > >               return NULL;
> > >       return to_cxl_nvdimm_bridge(dev);
> > > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > > index 1064427e3eb5..13e02528ddd3 100644
> > > --- a/drivers/cxl/cxl.h
> > > +++ b/drivers/cxl/cxl.h
> > > @@ -327,7 +327,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
> > >  struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
> > >  bool is_cxl_nvdimm(struct device *dev);
> > >  int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
> > > -struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void);
> > > +struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
> > >
> > >  /* unit test build overrides this to __weak */
> > >  #ifndef __mock
> > > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > > index a6be72a68960..5737abe1ff05 100644
> > > --- a/drivers/cxl/pmem.c
> > > +++ b/drivers/cxl/pmem.c
> > > @@ -43,7 +43,7 @@ static int cxl_nvdimm_probe(struct device *dev)
> > >       struct nvdimm *nvdimm = NULL;
> > >       int rc = -ENXIO;
> > >
> > > -     cxl_nvb = cxl_find_nvdimm_bridge();
> > > +     cxl_nvb = cxl_find_nvdimm_bridge(cxl_nvd);
> > >       if (!cxl_nvb)
> > >               return -ENXIO;
> > >
> > > diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> > > index 63a4a07e71c4..86deba8308a1 100644
> > > --- a/tools/testing/cxl/Kbuild
> > > +++ b/tools/testing/cxl/Kbuild
> > > @@ -33,4 +33,6 @@ cxl_core-y += $(CXL_CORE_SRC)/memdev.o
> > >  cxl_core-y += $(CXL_CORE_SRC)/mbox.o
> > >  cxl_core-y += config_check.o
> > >
> > > +cxl_core-y += mock_pmem.o
> > > +
> > >  obj-m += test/
> > > diff --git a/tools/testing/cxl/mock_pmem.c b/tools/testing/cxl/mock_pmem.c
> > > new file mode 100644
> > > index 000000000000..f7315e6f52c0
> > > --- /dev/null
> > > +++ b/tools/testing/cxl/mock_pmem.c
> > > @@ -0,0 +1,24 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
> > > +#include <cxl.h>
> > > +#include "test/mock.h"
> > > +#include <core/core.h>
> > > +
> > > +int match_nvdimm_bridge(struct device *dev, const void *data)
> > > +{
> > > +     int index, rc = 0;
> > > +     struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> > > +     const struct cxl_nvdimm *cxl_nvd = data;
> > > +
> > > +     if (ops) {
> > > +             if (dev->type == &cxl_nvdimm_bridge_type &&
> > > +                 (ops->is_mock_dev(dev->parent->parent) ==
> > > +                  ops->is_mock_dev(cxl_nvd->dev.parent->parent)))
> > > +                     rc = 1;
> > > +     } else
> > > +             rc = dev->type == &cxl_nvdimm_bridge_type;
> > > +
> > > +     put_cxl_mock_ops(index);
> > > +
> > > +     return rc;
> > > +}
> > > diff --git a/tools/testing/cxl/test/Kbuild b/tools/testing/cxl/test/Kbuild
> > > index 7de4ddecfd21..4e59e2c911f6 100644
> > > --- a/tools/testing/cxl/test/Kbuild
> > > +++ b/tools/testing/cxl/test/Kbuild
> > > @@ -1,6 +1,10 @@
> > >  # SPDX-License-Identifier: GPL-2.0
> > > +ccflags-y := -I$(srctree)/drivers/cxl/
> > > +
> > >  obj-m += cxl_test.o
> > >  obj-m += cxl_mock.o
> > > +obj-m += cxl_mock_mem.o
> > >
> > >  cxl_test-y := cxl.o
> > >  cxl_mock-y := mock.o
> > > +cxl_mock_mem-y := mem.o
> > > diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> > > index 0710e0062e58..314b09d40333 100644
> > > --- a/tools/testing/cxl/test/cxl.c
> > > +++ b/tools/testing/cxl/test/cxl.c
> > > @@ -17,6 +17,7 @@ static struct platform_device *cxl_acpi;
> > >  static struct platform_device *cxl_host_bridge[NR_CXL_HOST_BRIDGES];
> > >  static struct platform_device
> > >       *cxl_root_port[NR_CXL_HOST_BRIDGES * NR_CXL_ROOT_PORTS];
> > > +struct platform_device *cxl_mem[NR_CXL_HOST_BRIDGES * NR_CXL_ROOT_PORTS];
> > >
> > >  static struct acpi_device acpi0017_mock;
> > >  static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES] = {
> > > @@ -36,6 +37,11 @@ static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES] = {
> > >
> > >  static bool is_mock_dev(struct device *dev)
> > >  {
> > > +     int i;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(cxl_mem); i++)
> > > +             if (dev == &cxl_mem[i]->dev)
> > > +                     return true;
> > >       if (dev == &cxl_acpi->dev)
> > >               return true;
> > >       return false;
> > > @@ -403,6 +409,44 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
> > >  #define SZ_512G (SZ_64G * 8)
> > >  #endif
> > >
> > > +static struct platform_device *alloc_memdev(int id)
> > > +{
> > > +     struct resource res[] = {
> > > +             [0] = {
> > > +                     .flags = IORESOURCE_MEM,
> > > +             },
> > > +             [1] = {
> > > +                     .flags = IORESOURCE_MEM,
> > > +                     .desc = IORES_DESC_PERSISTENT_MEMORY,
> > > +             },
> > > +     };
> > > +     struct platform_device *pdev;
> > > +     int i, rc;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(res); i++) {
> > > +             struct cxl_mock_res *r = alloc_mock_res(SZ_256M);
> > > +
> > > +             if (!r)
> > > +                     return NULL;
> > > +             res[i].start = r->range.start;
> > > +             res[i].end = r->range.end;
> > > +     }
> > > +
> > > +     pdev = platform_device_alloc("cxl_mem", id);
> > > +     if (!pdev)
> > > +             return NULL;
> > > +
> > > +     rc = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> > > +     if (rc)
> > > +             goto err;
> > > +
> > > +     return pdev;
> > > +
> > > +err:
> > > +     platform_device_put(pdev);
> > > +     return NULL;
> > > +}
> > > +
> > >  static __init int cxl_test_init(void)
> > >  {
> > >       int rc, i;
> > > @@ -458,9 +502,27 @@ static __init int cxl_test_init(void)
> > >               cxl_root_port[i] = pdev;
> > >       }
> > >
> > > +     BUILD_BUG_ON(ARRAY_SIZE(cxl_mem) != ARRAY_SIZE(cxl_root_port));
> > > +     for (i = 0; i < ARRAY_SIZE(cxl_mem); i++) {
> > > +             struct platform_device *port = cxl_root_port[i];
> > > +             struct platform_device *pdev;
> > > +
> > > +             pdev = alloc_memdev(i);
> > > +             if (!pdev)
> > > +                     goto err_mem;
> > > +             pdev->dev.parent = &port->dev;
> > > +
> > > +             rc = platform_device_add(pdev);
> > > +             if (rc) {
> > > +                     platform_device_put(pdev);
> > > +                     goto err_mem;
> > > +             }
> > > +             cxl_mem[i] = pdev;
> > > +     }
> > > +
> > >       cxl_acpi = platform_device_alloc("cxl_acpi", 0);
> > >       if (!cxl_acpi)
> > > -             goto err_port;
> > > +             goto err_mem;
> > >
> > >       mock_companion(&acpi0017_mock, &cxl_acpi->dev);
> > >       acpi0017_mock.dev.bus = &platform_bus_type;
> > > @@ -473,6 +535,11 @@ static __init int cxl_test_init(void)
> > >
> > >  err_add:
> > >       platform_device_put(cxl_acpi);
> > > +err_mem:
> > > +     for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--) {
> > > +             platform_device_del(cxl_mem[i]);
> > > +             platform_device_put(cxl_mem[i]);
> > > +     }
> > >  err_port:
> > >       for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--) {
> > >               platform_device_del(cxl_root_port[i]);
> > > @@ -498,6 +565,10 @@ static __exit void cxl_test_exit(void)
> > >
> > >       platform_device_del(cxl_acpi);
> > >       platform_device_put(cxl_acpi);
> > > +     for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--) {
> > > +             platform_device_del(cxl_mem[i]);
> > > +             platform_device_put(cxl_mem[i]);
> > > +     }
> > >       for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--) {
> > >               platform_device_del(cxl_root_port[i]);
> > >               platform_device_put(cxl_root_port[i]);
> > > diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> > > new file mode 100644
> > > index 000000000000..3ce02c2783d5
> > > --- /dev/null
> > > +++ b/tools/testing/cxl/test/mem.c
> > > @@ -0,0 +1,255 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +// Copyright(c) 2021 Intel Corporation. All rights reserved.
> > > +
> > > +#include <linux/platform_device.h>
> > > +#include <linux/mod_devicetable.h>
> > > +#include <linux/module.h>
> > > +#include <linux/sizes.h>
> > > +#include <linux/bits.h>
> > > +#include <cxlmem.h>
> > > +
> > > +#define LSA_SIZE SZ_128K
> > > +#define EFFECT(x) (1U << x)
> > > +
> > > +static struct cxl_cel_entry mock_cel[] = {
> > > +     {
> > > +             .opcode = cpu_to_le16(CXL_MBOX_OP_GET_SUPPORTED_LOGS),
> > > +             .effect = cpu_to_le16(0),
> > > +     },
> > > +     {
> > > +             .opcode = cpu_to_le16(CXL_MBOX_OP_IDENTIFY),
> > > +             .effect = cpu_to_le16(0),
> > > +     },
> > > +     {
> > > +             .opcode = cpu_to_le16(CXL_MBOX_OP_GET_LSA),
> > > +             .effect = cpu_to_le16(0),
> > > +     },
> > > +     {
> > > +             .opcode = cpu_to_le16(CXL_MBOX_OP_SET_LSA),
> > > +             .effect = cpu_to_le16(EFFECT(1) | EFFECT(2)),
> > > +     },
> > > +};
> > > +
> > > +static struct {
> > > +     struct cxl_mbox_get_supported_logs gsl;
> > > +     struct cxl_gsl_entry entry;
> > > +} mock_gsl_payload = {
> > > +     .gsl = {
> > > +             .entries = cpu_to_le16(1),
> > > +     },
> > > +     .entry = {
> > > +             .uuid = DEFINE_CXL_CEL_UUID,
> > > +             .size = cpu_to_le32(sizeof(mock_cel)),
> > > +     },
> > > +};
> > > +
> > > +static int mock_gsl(struct cxl_mbox_cmd *cmd)
> > > +{
> > > +     if (cmd->size_out < sizeof(mock_gsl_payload))
> > > +             return -EINVAL;
> > > +
> > > +     memcpy(cmd->payload_out, &mock_gsl_payload, sizeof(mock_gsl_payload));
> > > +     cmd->size_out = sizeof(mock_gsl_payload);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static int mock_get_log(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
> > > +{
> > > +     struct cxl_mbox_get_log *gl = cmd->payload_in;
> > > +     u32 offset = le32_to_cpu(gl->offset);
> > > +     u32 length = le32_to_cpu(gl->length);
> > > +     uuid_t uuid = DEFINE_CXL_CEL_UUID;
> > > +     void *data = &mock_cel;
> > > +
> > > +     if (cmd->size_in < sizeof(*gl))
> > > +             return -EINVAL;
> > > +     if (offset + length >
> > > +         (min_t(size_t, cxlm->payload_size, sizeof(mock_cel))))  
> >
> > I assume aim here is to check we don't read from beyond end of mock_cel?
> > If so why does the cxlm->payload_size matter? Say read as 4 bytes at 1.5M
> > then that should be fine.  
> 
> Ah true, CEL can be larger than payload size, will fix.
> 
> > Should we have a separate test of (length < cxlm->payload_size)?  
> 
> Should be ok to request less than a full payload size.
Agreed. I was expressing that backwards.  It's length > clxm->payload_size
that I meant to suggest we might want to check.

I think the calling code checks that though so I guess it depends on
how hard you want to armor this mocking driver?  This might be a step
too far.

Jonathan


