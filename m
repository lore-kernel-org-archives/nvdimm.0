Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D1D70
	for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 11:55:19 +0000 (UTC)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G1dtw6X5Qz6L7Gl;
	Fri, 11 Jun 2021 19:30:32 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 13:39:58 +0200
Received: from localhost (10.52.120.251) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 12:39:57 +0100
Date: Fri, 11 Jun 2021 12:39:53 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] cxl/pmem: Add initial infrastructure for pmem
 support
Message-ID: <20210611123953.000054df@Huawei.com>
In-Reply-To: <162336396844.2462439.1234951573910835450.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162336396844.2462439.1234951573910835450.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.120.251]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 10 Jun 2021 15:26:08 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Register an 'nvdimm-bridge' device to act as an anchor for a libnvdimm
> bus hierarchy. Also, flesh out the cxl_bus definition to allow a
> cxl_nvdimm_bridge_driver to attach to the bridge and trigger the
> nvdimm-bus registration.
> 
> The creation of the bridge is gated on the detection of a PMEM capable
> address space registered to the root. The bridge indirection allows the
> libnvdimm module to remain unloaded on platforms without PMEM support.
> 
> Given that the probing of ACPI0017 is asynchronous to CXL endpoint
> devices, and the expectation that CXL endpoint devices register other
> PMEM resources on the 'CXL' nvdimm bus, a workqueue is added. The
> workqueue is needed to run bus_rescan_devices() outside of the
> device_lock() of the nvdimm-bridge device to rendezvous nvdimm resources
> as they arrive. For now only the bus is taken online/offline in the
> workqueue.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I'm not that familiar with nvdimm side of things, so this is mostly
superficial review of the patch itself.

A few really minor comments inline, but otherwise looks good to me.

Jonathan

> ---
>  drivers/cxl/Kconfig  |   13 +++++
>  drivers/cxl/Makefile |    2 +
>  drivers/cxl/acpi.c   |   37 ++++++++++++-
>  drivers/cxl/core.c   |  122 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h    |   24 +++++++++
>  drivers/cxl/pmem.c   |  141 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 337 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/cxl/pmem.c
> 
> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
> index 1a44b173dcbc..e6de221cc568 100644
> --- a/drivers/cxl/Kconfig
> +++ b/drivers/cxl/Kconfig
> @@ -61,5 +61,18 @@ config CXL_ACPI
>  	  hierarchy to map regions that represent System RAM, or Persistent
>  	  Memory regions to be managed by LIBNVDIMM.
>  
> +	  If unsure say 'm'.
> +
> +config CXL_PMEM
> +	tristate "CXL PMEM: Persistent Memory Support"
> +	depends on LIBNVDIMM
> +	default CXL_BUS
> +	help
> +	  In addition to typical memory resources a platform may also advertise
> +	  support for persistent memory attached via CXL. This support is
> +	  managed via a bridge driver from CXL to the LIBNVDIMM system
> +	  subsystem. Say 'y/m' to enable support for enumerating and
> +	  provisioning the persistent memory capacity of CXL memory expanders.
> +
>  	  If unsure say 'm'.
>  endif
> diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
> index a29efb3e8ad2..32954059b37b 100644
> --- a/drivers/cxl/Makefile
> +++ b/drivers/cxl/Makefile
> @@ -2,8 +2,10 @@
>  obj-$(CONFIG_CXL_BUS) += cxl_core.o
>  obj-$(CONFIG_CXL_MEM) += cxl_pci.o
>  obj-$(CONFIG_CXL_ACPI) += cxl_acpi.o
> +obj-$(CONFIG_CXL_PMEM) += cxl_pmem.o
>  
>  ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=CXL
>  cxl_core-y := core.o
>  cxl_pci-y := pci.o
>  cxl_acpi-y := acpi.o
> +cxl_pmem-y := pmem.o
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index be357eea552c..8a723f7f3f73 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -145,6 +145,30 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  	return 0;
>  }
>  
> +static int add_root_nvdimm_bridge(struct device *match, void *data)
> +{
> +	struct cxl_decoder *cxld;
> +	struct cxl_port *root_port = data;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct device *host = root_port->dev.parent;
> +
> +	if (!is_root_decoder(match))
> +		return 0;
> +
> +	cxld = to_cxl_decoder(match);
> +	if (!(cxld->flags & CXL_DECODER_F_PMEM))
> +		return 0;
> +
> +	cxl_nvb = devm_cxl_add_nvdimm_bridge(host, root_port);
> +	if (IS_ERR(cxl_nvb)) {
> +		dev_dbg(host, "failed to register pmem\n");
> +		return PTR_ERR(cxl_nvb);
> +	}
> +	dev_dbg(host, "%s: add: %s\n", dev_name(&root_port->dev),
> +		dev_name(&cxl_nvb->dev));
> +	return 1;
> +}
> +
>  static int cxl_acpi_probe(struct platform_device *pdev)
>  {
>  	int rc;
> @@ -166,8 +190,17 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  	 * Root level scanned with host-bridge as dports, now scan host-bridges
>  	 * for their role as CXL uports to their CXL-capable PCIe Root Ports.
>  	 */
> -	return bus_for_each_dev(adev->dev.bus, NULL, root_port,
> -				add_host_bridge_uport);
> +	rc = bus_for_each_dev(adev->dev.bus, NULL, root_port,
> +			      add_host_bridge_uport);
> +	if (rc)
> +		return rc;
> +
> +	if (IS_ENABLED(CONFIG_CXL_PMEM))
> +		rc = device_for_each_child(&root_port->dev, root_port,
> +					   add_root_nvdimm_bridge);
> +	if (rc < 0)
> +		return rc;
> +	return 0;
>  }
>  
>  static const struct acpi_device_id cxl_acpi_ids[] = {
> diff --git a/drivers/cxl/core.c b/drivers/cxl/core.c
> index 959cecc1f6bf..f0305c9c91c8 100644
> --- a/drivers/cxl/core.c
> +++ b/drivers/cxl/core.c
> @@ -187,6 +187,12 @@ static const struct device_type cxl_decoder_root_type = {
>  	.groups = cxl_decoder_root_attribute_groups,
>  };
>  
> +bool is_root_decoder(struct device *dev)
> +{
> +	return dev->type == &cxl_decoder_root_type;
> +}
> +EXPORT_SYMBOL_GPL(is_root_decoder);
> +
>  struct cxl_decoder *to_cxl_decoder(struct device *dev)
>  {
>  	if (dev_WARN_ONCE(dev, dev->type->release != cxl_decoder_release,
> @@ -194,6 +200,7 @@ struct cxl_decoder *to_cxl_decoder(struct device *dev)
>  		return NULL;
>  	return container_of(dev, struct cxl_decoder, dev);
>  }
> +EXPORT_SYMBOL_GPL(to_cxl_decoder);
>  
>  static void cxl_dport_release(struct cxl_dport *dport)
>  {
> @@ -611,6 +618,119 @@ void cxl_probe_component_regs(struct device *dev, void __iomem *base,
>  }
>  EXPORT_SYMBOL_GPL(cxl_probe_component_regs);
>  
> +static void cxl_nvdimm_bridge_release(struct device *dev)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
> +
> +	kfree(cxl_nvb);
> +}
> +
> +static const struct attribute_group *cxl_nvdimm_bridge_attribute_groups[] = {
> +	&cxl_base_attribute_group,
> +	NULL,
> +};
> +
> +static const struct device_type cxl_nvdimm_bridge_type = {
> +	.name = "cxl_nvdimm_bridge",
> +	.release = cxl_nvdimm_bridge_release,
> +	.groups = cxl_nvdimm_bridge_attribute_groups,
> +};
> +
> +struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev)
> +{
> +	if (dev_WARN_ONCE(dev, dev->type != &cxl_nvdimm_bridge_type,
> +			  "not a cxl_nvdimm_bridge device\n"))
> +		return NULL;
> +	return container_of(dev, struct cxl_nvdimm_bridge, dev);
> +}
> +EXPORT_SYMBOL_GPL(to_cxl_nvdimm_bridge);
> +
> +static struct cxl_nvdimm_bridge *
> +cxl_nvdimm_bridge_alloc(struct cxl_port *port)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct device *dev;
> +
> +	cxl_nvb = kzalloc(sizeof(*cxl_nvb), GFP_KERNEL);
> +	if (!cxl_nvb)
> +		return ERR_PTR(-ENOMEM);
> +
> +	dev = &cxl_nvb->dev;
> +	cxl_nvb->port = port;
> +	cxl_nvb->state = CXL_NVB_NEW;
> +	device_initialize(dev);
> +	device_set_pm_not_required(dev);
> +	dev->parent = &port->dev;
> +	dev->bus = &cxl_bus_type;
> +	dev->type = &cxl_nvdimm_bridge_type;
> +
> +	return cxl_nvb;
> +}
> +
> +static void unregister_nvb(void *_cxl_nvb)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb = _cxl_nvb;
> +	bool flush = false;
> +
> +	/*
> +	 * If the bridge was ever activated then there might be in-flight state
> +	 * work to flush. Once the state has been changed to 'dead' then no new
> +	 * work can be queued by user-triggered bind.
> +	 */
> +	device_lock(&cxl_nvb->dev);
> +	if (cxl_nvb->state != CXL_NVB_NEW)
> +		flush = true;

flush = clx_nvb->state != CXL_NVB_NEW; 

perhaps?

> +	cxl_nvb->state = CXL_NVB_DEAD;
> +	device_unlock(&cxl_nvb->dev);
> +
> +	/*
> +	 * Even though the device core will trigger device_release_driver()
> +	 * before the unregister, it does not know about the fact that
> +	 * cxl_nvdimm_bridge_driver defers ->remove() work. So, do the driver
> +	 * release not and flush it before tearing down the nvdimm device
> +	 * hierarchy.
> +	 */
> +	device_release_driver(&cxl_nvb->dev);
> +	if (flush)
> +		flush_work(&cxl_nvb->state_work);
> +	device_unregister(&cxl_nvb->dev);
> +}
> +
> +struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
> +						     struct cxl_port *port)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct device *dev;
> +	int rc;
> +
> +	if (!IS_ENABLED(CONFIG_CXL_PMEM))
> +		return ERR_PTR(-ENXIO);
> +
> +	cxl_nvb = cxl_nvdimm_bridge_alloc(port);
> +	if (IS_ERR(cxl_nvb))
> +		return cxl_nvb;
> +
> +	dev = &cxl_nvb->dev;
> +	rc = dev_set_name(dev, "nvdimm-bridge");
> +	if (rc)
> +		goto err;
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		goto err;
> +
> +	rc = devm_add_action_or_reset(host, unregister_nvb, cxl_nvb);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	return cxl_nvb;
> +
> +err:
> +	put_device(dev);
> +	return ERR_PTR(rc);
> +}
> +EXPORT_SYMBOL_GPL(devm_cxl_add_nvdimm_bridge);
> +
>  /**
>   * cxl_probe_device_regs() - Detect CXL Device register blocks
>   * @dev: Host device of the @base mapping
> @@ -808,6 +928,8 @@ EXPORT_SYMBOL_GPL(cxl_driver_unregister);
>  
>  static int cxl_device_id(struct device *dev)
>  {
> +	if (dev->type == &cxl_nvdimm_bridge_type)
> +		return CXL_DEVICE_NVDIMM_BRIDGE;
>  	return 0;
>  }
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index af2237d1c761..47fcb7ad5978 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -4,6 +4,7 @@
>  #ifndef __CXL_H__
>  #define __CXL_H__
>  
> +#include <linux/libnvdimm.h>
>  #include <linux/bitfield.h>
>  #include <linux/bitops.h>
>  #include <linux/io.h>
> @@ -195,6 +196,23 @@ struct cxl_decoder {
>  	struct cxl_dport *target[];
>  };
>  
> +
> +enum cxl_nvdimm_brige_state {
> +	CXL_NVB_NEW,
> +	CXL_NVB_DEAD,
> +	CXL_NVB_ONLINE,
> +	CXL_NVB_OFFLINE,
> +};
> +
> +struct cxl_nvdimm_bridge {
> +	struct device dev;
> +	struct cxl_port *port;
> +	struct nvdimm_bus *nvdimm_bus;
> +	struct nvdimm_bus_descriptor nd_desc;
> +	struct work_struct state_work;
> +	enum cxl_nvdimm_brige_state state;
> +};
> +
>  /**
>   * struct cxl_port - logical collection of upstream port devices and
>   *		     downstream port devices to construct a CXL memory
> @@ -240,6 +258,7 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
>  		  resource_size_t component_reg_phys);
>  
>  struct cxl_decoder *to_cxl_decoder(struct device *dev);
> +bool is_root_decoder(struct device *dev);
>  struct cxl_decoder *
>  devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
>  		     resource_size_t base, resource_size_t len,
> @@ -280,7 +299,12 @@ int __cxl_driver_register(struct cxl_driver *cxl_drv, struct module *owner,
>  #define cxl_driver_register(x) __cxl_driver_register(x, THIS_MODULE, KBUILD_MODNAME)
>  void cxl_driver_unregister(struct cxl_driver *cxl_drv);
>  
> +#define CXL_DEVICE_NVDIMM_BRIDGE 1
> +
>  #define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
>  #define CXL_MODALIAS_FMT "cxl:t%d"
>  
> +struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev);
> +struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
> +						     struct cxl_port *port);
>  #endif /* __CXL_H__ */
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> new file mode 100644
> index 000000000000..0067bd734559
> --- /dev/null
> +++ b/drivers/cxl/pmem.c
> @@ -0,0 +1,141 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
> +#include <linux/libnvdimm.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include "cxl.h"
> +
> +/*
> + * Ordered workqueue for cxl nvdimm device arrival and departure
> + * to coordinate bus rescans when a bridge arrives and trigger remove
> + * operations when the bridge is removed.
> + */
> +static struct workqueue_struct *cxl_pmem_wq;
> +
> +static int cxl_pmem_ctl(struct nvdimm_bus_descriptor *nd_desc,
> +			struct nvdimm *nvdimm, unsigned int cmd, void *buf,
> +			unsigned int buf_len, int *cmd_rc)
> +{
> +	return -ENOTTY;
> +}
> +
> +static void online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
> +{
> +	if (cxl_nvb->nvdimm_bus)
> +		return;
> +	cxl_nvb->nvdimm_bus =
> +		nvdimm_bus_register(&cxl_nvb->dev, &cxl_nvb->nd_desc);
> +}
> +
> +static void offline_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
> +{
> +	if (!cxl_nvb->nvdimm_bus)
> +		return;
> +	nvdimm_bus_unregister(cxl_nvb->nvdimm_bus);
> +	cxl_nvb->nvdimm_bus = NULL;
> +}
> +
> +static void cxl_nvb_update_state(struct work_struct *work)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb =
> +		container_of(work, typeof(*cxl_nvb), state_work);
> +	bool release = false;
> +
> +	device_lock(&cxl_nvb->dev);
> +	switch (cxl_nvb->state) {
> +	case CXL_NVB_ONLINE:
> +		online_nvdimm_bus(cxl_nvb);
> +		if (!cxl_nvb->nvdimm_bus) {

I'd slightly prefer a simple return code from online_nvdimm_bus()
so the reviewer doesn't have to look up above to find out that
this condition corresponds to failure.

> +			dev_err(&cxl_nvb->dev,
> +				"failed to establish nvdimm bus\n");
> +			release = true;
> +		}
> +		break;
> +	case CXL_NVB_OFFLINE:
> +	case CXL_NVB_DEAD:
> +		offline_nvdimm_bus(cxl_nvb);
> +		break;
> +	default:
> +		break;
> +	}
> +	device_unlock(&cxl_nvb->dev);
> +
> +	if (release)
> +		device_release_driver(&cxl_nvb->dev);
> +
> +	put_device(&cxl_nvb->dev);
> +}
> +
> +static void cxl_nvdimm_bridge_remove(struct device *dev)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
> +
> +	if (cxl_nvb->state == CXL_NVB_ONLINE)
> +		cxl_nvb->state = CXL_NVB_OFFLINE;
> +	if (queue_work(cxl_pmem_wq, &cxl_nvb->state_work))
> +		get_device(&cxl_nvb->dev);
> +}
> +
> +static int cxl_nvdimm_bridge_probe(struct device *dev)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
> +
> +	if (cxl_nvb->state == CXL_NVB_DEAD)
> +		return -ENXIO;
> +
> +	if (cxl_nvb->state == CXL_NVB_NEW) {
> +		cxl_nvb->nd_desc = (struct nvdimm_bus_descriptor) {
> +			.provider_name = "CXL",
> +			.module = THIS_MODULE,
> +			.ndctl = cxl_pmem_ctl,
> +		};
> +
> +		INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
> +	}
> +
> +	cxl_nvb->state = CXL_NVB_ONLINE;
> +	if (queue_work(cxl_pmem_wq, &cxl_nvb->state_work))
> +		get_device(&cxl_nvb->dev);
> +
> +	return 0;
> +}
> +
> +static struct cxl_driver cxl_nvdimm_bridge_driver = {
> +	.name = "cxl_nvdimm_bridge",
> +	.probe = cxl_nvdimm_bridge_probe,
> +	.remove = cxl_nvdimm_bridge_remove,
> +	.id = CXL_DEVICE_NVDIMM_BRIDGE,
> +};
> +
> +static __init int cxl_pmem_init(void)
> +{
> +	int rc;
> +
> +	cxl_pmem_wq = alloc_ordered_workqueue("cxl_pmem", 0);
> +
> +	if (!cxl_pmem_wq)
> +		return -ENXIO;
> +
> +	rc = cxl_driver_register(&cxl_nvdimm_bridge_driver);
> +	if (rc)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	destroy_workqueue(cxl_pmem_wq);
> +	return rc;
> +}
> +
> +static __exit void cxl_pmem_exit(void)
> +{
> +	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
> +	destroy_workqueue(cxl_pmem_wq);
> +}
> +
> +MODULE_LICENSE("GPL v2");
> +module_init(cxl_pmem_init);
> +module_exit(cxl_pmem_exit);
> +MODULE_IMPORT_NS(CXL);
> +MODULE_ALIAS_CXL(CXL_DEVICE_NVDIMM_BRIDGE);
> 

