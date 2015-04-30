Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 02/20] libnd, nd_acpi: initial libnd infrastructure and NFIT support
Date: Fri, 01 May 2015 01:23:15 +0200
Message-ID: <5532780.fyo4CQJEJz@vostro.rjw.lan>
In-Reply-To: <20150428182423.35812.20930.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com> <20150428182423.35812.20930.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, David Box <david.e.box@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tuesday, April 28, 2015 02:24:23 PM Dan Williams wrote:
> 1/ Autodetect an NFIT table for the ACPI namespace device with _HID of
>    "ACPI0012"
> 
> 2/ libnd bus registration
> 
> The NFIT provided by ACPI is one possible method by which platforms will
> discover NVDIMM resources.  However, the intent of the nd_bus_descriptor
> abstraction is to abstract "provider" specific details, leaving libnd
> to be independent of the specific NVDIMM resource discovery mechanism.
> This flexibility is later exploited later to implement custom-defined nd
> buses.
> 
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/block/Kconfig         |    2 
>  drivers/block/Makefile        |    1 
>  drivers/block/nd/Kconfig      |   40 +++
>  drivers/block/nd/Makefile     |    6 +
>  drivers/block/nd/acpi.c       |  475 +++++++++++++++++++++++++++++++++++++++++
>  drivers/block/nd/acpi_nfit.h  |  254 ++++++++++++++++++++++
>  drivers/block/nd/core.c       |   67 ++++++
>  drivers/block/nd/libnd.h      |   33 +++
>  drivers/block/nd/nd-private.h |   23 ++
>  9 files changed, 901 insertions(+)
>  create mode 100644 drivers/block/nd/Kconfig
>  create mode 100644 drivers/block/nd/Makefile
>  create mode 100644 drivers/block/nd/acpi.c
>  create mode 100644 drivers/block/nd/acpi_nfit.h
>  create mode 100644 drivers/block/nd/core.c
>  create mode 100644 drivers/block/nd/libnd.h
>  create mode 100644 drivers/block/nd/nd-private.h
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index eb1fed5bd516..dfe40e5ca9bd 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -321,6 +321,8 @@ config BLK_DEV_NVME
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called nvme.
>  
> +source "drivers/block/nd/Kconfig"
> +
>  config BLK_DEV_SKD
>  	tristate "STEC S1120 Block Driver"
>  	depends on PCI
> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
> index 9cc6c18a1c7e..07a6acecf4d8 100644
> --- a/drivers/block/Makefile
> +++ b/drivers/block/Makefile
> @@ -24,6 +24,7 @@ obj-$(CONFIG_CDROM_PKTCDVD)	+= pktcdvd.o
>  obj-$(CONFIG_MG_DISK)		+= mg_disk.o
>  obj-$(CONFIG_SUNVDC)		+= sunvdc.o
>  obj-$(CONFIG_BLK_DEV_NVME)	+= nvme.o
> +obj-$(CONFIG_ND_DEVICES)	+= nd/
>  obj-$(CONFIG_BLK_DEV_SKD)	+= skd.o
>  obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
>  
> diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
> new file mode 100644
> index 000000000000..6d5d6b732f82
> --- /dev/null
> +++ b/drivers/block/nd/Kconfig
> @@ -0,0 +1,40 @@
> +menuconfig ND_DEVICES
> +	bool "NVDIMM Support"
> +	depends on PHYS_ADDR_T_64BIT
> +	help
> +	  Generic support for non-volatile memory devices including
> +	  ACPI-6-NFIT defined resources.  On platforms that define an
> +	  NFIT, or otherwise can discover NVDIMM resources, a libnd
> +	  bus is registered to advertise PMEM (persistent memory)
> +	  namespaces (/dev/pmemX) and BLK (sliding mmio window(s))
> +	  namespaces (/dev/ndX). A PMEM namespace refers to a memory
> +	  resource that may span multiple DIMMs and support DAX (see
> +	  CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
> +	  region which exposes an mmio register set for windowed
> +	  access mode to non-volatile memory.
> +
> +if ND_DEVICES
> +
> +config LIBND
> +	tristate "LIBND: libnd device driver support"
> +	help
> +	  Platform agnostic device model for a libnd bus.  Publishes
> +	  resources for a PMEM (persistent-memory) driver and/or BLK
> +	  (sliding mmio window(s)) driver to attach.  Exposes a device
> +	  topology under a "ndX" bus device, a "/dev/ndctlX" bus-ioctl
> +	  message passing interface, and a "/dev/nmemX" dimm-ioctl
> +	  message interface for each memory device registered on the
> +	  bus.  instance.  A userspace library "ndctl" provides an API
> +	  to enumerate/manage this subsystem.
> +
> +config ND_ACPI
> +	tristate "ACPI: NFIT to libnd bus support"
> +	select LIBND
> +	depends on ACPI
> +	help
> +	  Infrastructure to probe ACPI 6 compliant platforms for
> +	  NVDIMMs (NFIT) and register a libnd device tree.  In
> +	  addition to storage devices this also enables libnd craft
> +	  ACPI._DSM messages for platform/dimm configuration.

I'm wondering if the two CONFIG options above really need to be user-selectable?

For example, what reason people (who've already selected ND_DEVICES) may have
for not selecting ND_ACPI if ACPI is set?

> +
> +endif
> diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
> new file mode 100644
> index 000000000000..944b5947c0cb
> --- /dev/null
> +++ b/drivers/block/nd/Makefile
> @@ -0,0 +1,6 @@
> +obj-$(CONFIG_LIBND) += libnd.o
> +obj-$(CONFIG_ND_ACPI) += nd_acpi.o
> +
> +nd_acpi-y := acpi.o
> +
> +libnd-y := core.o

OK, so it looks like no modules, just built-in code, right?

> diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
> new file mode 100644
> index 000000000000..9f0b24390d1b
> --- /dev/null
> +++ b/drivers/block/nd/acpi.c
> @@ -0,0 +1,475 @@
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
> +#include <linux/list_sort.h>
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/acpi.h>
> +#include "acpi_nfit.h"
> +#include "libnd.h"
> +
> +static bool warn_checksum;
> +module_param(warn_checksum, bool, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(warn_checksum, "Turn checksum errors into warnings");
> +
> +enum {
> +	NFIT_ACPI_NOTIFY_TABLE = 0x80,
> +};
> +
> +static int nd_acpi_ctl(struct nd_bus_descriptor *nd_desc,
> +		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
> +		unsigned int buf_len)
> +{
> +	return -ENOTTY;
> +}

Why -ENOTTY?  And why not to leave a NULL entry for this instead and
make the library fail it in that case?

> +
> +static const char *spa_type_name(u16 type)
> +{
> +	switch (type) {
> +	case NFIT_SPA_VOLATILE: return "volatile";
> +	case NFIT_SPA_PM: return "pmem";
> +	case NFIT_SPA_DCR: return "dimm-control-region";
> +	case NFIT_SPA_BDW: return "block-data-window";
> +	default: return "unknown";
> +	}
> +}
> +
> +static int nfit_spa_type(struct acpi_nfit_spa *spa)
> +{
> +	if (memcmp(&nfit_spa_uuid_volatile, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_VOLATILE;
> +
> +	if (memcmp(&nfit_spa_uuid_pm, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_PM;
> +
> +	if (memcmp(&nfit_spa_uuid_dcr, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_DCR;
> +
> +	if (memcmp(&nfit_spa_uuid_bdw, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_BDW;
> +
> +	if (memcmp(&nfit_spa_uuid_vdisk, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_VDISK;
> +
> +	if (memcmp(&nfit_spa_uuid_vcd, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_VCD;
> +
> +	if (memcmp(&nfit_spa_uuid_pdisk, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_PDISK;
> +
> +	if (memcmp(&nfit_spa_uuid_pcd, spa->type_uuid, 16) == 0)
> +		return NFIT_SPA_PCD;
> +
> +	return -1;
> +}
> +
> +struct nfit_table_header {
> +	__le16 type;
> +	__le16 length;
> +};

That you'll be able to get from ACPICA I suppose?

> +
> +static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table, const void *end)
> +{
> +	struct device *dev = acpi_desc->dev;
> +	struct nfit_table_header *hdr;
> +	void *err = ERR_PTR(-ENOMEM);
> +
> +	if (table >= end)
> +		return NULL;
> +
> +	hdr = (struct nfit_table_header *) table;
> +	switch (hdr->type) {
> +	case NFIT_TABLE_SPA: {
> +		struct nfit_spa *nfit_spa = devm_kzalloc(dev, sizeof(*nfit_spa),
> +				GFP_KERNEL);
> +		struct acpi_nfit_spa *spa = table;
> +
> +		if (!nfit_spa)
> +			return err;
> +		INIT_LIST_HEAD(&nfit_spa->list);
> +		nfit_spa->spa = spa;
> +		list_add_tail(&nfit_spa->list, &acpi_desc->spas);
> +		dev_dbg(dev, "%s: spa index: %d type: %s\n", __func__,
> +				spa->spa_index,
> +				spa_type_name(nfit_spa_type(spa)));
> +		break;
> +	}
> +	case NFIT_TABLE_MEM: {
> +		struct nfit_memdev *nfit_memdev = devm_kzalloc(dev,
> +				sizeof(*nfit_memdev), GFP_KERNEL);
> +		struct acpi_nfit_memdev *memdev = table;
> +
> +		if (!nfit_memdev)
> +			return err;
> +		INIT_LIST_HEAD(&nfit_memdev->list);
> +		nfit_memdev->memdev = memdev;
> +		list_add_tail(&nfit_memdev->list, &acpi_desc->memdevs);
> +		dev_dbg(dev, "%s: memdev handle: %#x spa: %d dcr: %d\n",
> +				__func__, memdev->nfit_handle, memdev->spa_index,
> +				memdev->dcr_index);
> +		break;
> +	}
> +	case NFIT_TABLE_DCR: {
> +		struct nfit_dcr *nfit_dcr = devm_kzalloc(dev, sizeof(*nfit_dcr),
> +				GFP_KERNEL);
> +		struct acpi_nfit_dcr *dcr = table;
> +
> +		if (!nfit_dcr)
> +			return err;
> +		INIT_LIST_HEAD(&nfit_dcr->list);
> +		nfit_dcr->dcr = dcr;
> +		list_add_tail(&nfit_dcr->list, &acpi_desc->dcrs);
> +		dev_dbg(dev, "%s: dcr index: %d num_bcw: %d\n", __func__,
> +				dcr->dcr_index, dcr->num_bcw);
> +		break;
> +	}
> +	case NFIT_TABLE_BDW: {
> +		struct nfit_bdw *nfit_bdw = devm_kzalloc(dev, sizeof(*nfit_bdw),
> +				GFP_KERNEL);
> +		struct acpi_nfit_bdw *bdw = table;
> +
> +		if (!nfit_bdw)
> +			return err;
> +		INIT_LIST_HEAD(&nfit_bdw->list);
> +		nfit_bdw->bdw = bdw;
> +		list_add_tail(&nfit_bdw->list, &acpi_desc->bdws);
> +		dev_dbg(dev, "%s: bdw dcr: %d num_bdw: %d\n", __func__,
> +				bdw->dcr_index, bdw->num_bdw);
> +		break;
> +	}
> +	/* TODO */
> +	case NFIT_TABLE_IDT:
> +		dev_dbg(dev, "%s: idt\n", __func__);
> +		break;
> +	case NFIT_TABLE_FLUSH:
> +		dev_dbg(dev, "%s: flush\n", __func__);
> +		break;
> +	case NFIT_TABLE_SMBIOS:
> +		dev_dbg(dev, "%s: smbios\n", __func__);
> +		break;
> +	default:
> +		dev_err(dev, "unknown table '%d' parsing nfit\n", hdr->type);
> +		return ERR_PTR(-ENXIO);
> +	}
> +
> +	return table + hdr->length;
> +}
> +
> +static void nfit_mem_find_spa_bdw(struct acpi_nfit_desc *acpi_desc,
> +		struct nfit_mem *nfit_mem)
> +{
> +	u32 nfit_handle = __to_nfit_memdev(nfit_mem)->nfit_handle;
> +	u16 dcr_index = nfit_mem->dcr->dcr_index;
> +	struct nfit_spa *nfit_spa;
> +
> +	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> +		u16 spa_index = nfit_spa->spa->spa_index;
> +		int type = nfit_spa_type(nfit_spa->spa);
> +		struct nfit_memdev *nfit_memdev;
> +
> +		if (type != NFIT_SPA_BDW)
> +			continue;
> +
> +		list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
> +			if (nfit_memdev->memdev->spa_index != spa_index)
> +				continue;
> +			if (nfit_memdev->memdev->nfit_handle != nfit_handle)
> +				continue;
> +			if (nfit_memdev->memdev->dcr_index != dcr_index)
> +				continue;
> +
> +			nfit_mem->spa_bdw = nfit_spa->spa;
> +			return;
> +		}
> +	}
> +
> +	dev_dbg(acpi_desc->dev, "SPA-BDW not found for SPA-DCR %d\n",
> +			nfit_mem->spa_dcr->spa_index);
> +	nfit_mem->bdw = NULL;
> +}
> +
> +static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
> +		struct nfit_mem *nfit_mem, struct acpi_nfit_spa *spa)
> +{
> +	u16 dcr_index = __to_nfit_memdev(nfit_mem)->dcr_index;
> +	struct nfit_dcr *nfit_dcr;
> +	struct nfit_bdw *nfit_bdw;
> +
> +	list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
> +		if (nfit_dcr->dcr->dcr_index != dcr_index)
> +			continue;
> +		nfit_mem->dcr = nfit_dcr->dcr;
> +		break;
> +	}
> +
> +	if (!nfit_mem->dcr) {
> +		dev_dbg(acpi_desc->dev, "SPA %d missing:%s%s\n", spa->spa_index,
> +				__to_nfit_memdev(nfit_mem) ? "" : " MEMDEV",
> +				nfit_mem->dcr ? "" : " DCR");
> +		return -ENODEV;
> +	}
> +
> +	/*
> +	 * We've found enough to create an nd_dimm, optionally
> +	 * find an associated BDW
> +	 */
> +	list_add(&nfit_mem->list, &acpi_desc->dimms);
> +
> +	list_for_each_entry(nfit_bdw, &acpi_desc->bdws, list) {
> +		if (nfit_bdw->bdw->dcr_index != dcr_index)
> +			continue;
> +		nfit_mem->bdw = nfit_bdw->bdw;
> +		break;
> +	}
> +
> +	if (!nfit_mem->bdw)
> +		return 0;
> +
> +	nfit_mem_find_spa_bdw(acpi_desc, nfit_mem);
> +	return 0;
> +}
> +
> +static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
> +		struct acpi_nfit_spa *spa)
> +{
> +	struct nfit_mem *nfit_mem, *found;
> +	struct nfit_memdev *nfit_memdev;
> +	int type = nfit_spa_type(spa);
> +	u16 dcr_index;
> +
> +	switch (type) {
> +	case NFIT_SPA_DCR:
> +	case NFIT_SPA_PM:
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
> +		int rc;
> +
> +		if (nfit_memdev->memdev->spa_index != spa->spa_index)
> +			continue;
> +		found = NULL;
> +		dcr_index = nfit_memdev->memdev->dcr_index;
> +		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list)
> +			if (__to_nfit_memdev(nfit_mem)->dcr_index == dcr_index) {
> +				found = nfit_mem;
> +				break;
> +			}
> +
> +		if (found)
> +			nfit_mem = found;
> +		else {
> +			nfit_mem = devm_kzalloc(acpi_desc->dev,
> +					sizeof(*nfit_mem), GFP_KERNEL);
> +			if (!nfit_mem)
> +				return -ENOMEM;
> +			INIT_LIST_HEAD(&nfit_mem->list);
> +		}
> +
> +		if (type == NFIT_SPA_DCR) {
> +			/* multiple dimms may share a SPA when interleaved */
> +			nfit_mem->spa_dcr = spa;
> +			nfit_mem->memdev_dcr = nfit_memdev->memdev;
> +		} else {
> +			/*
> +			 * A single dimm may belong to multiple SPA-PM
> +			 * ranges, record at least one in addition to
> +			 * any SPA-DCR range.
> +			 */
> +			nfit_mem->memdev_pmem = nfit_memdev->memdev;
> +		}
> +
> +		if (found)
> +			continue;
> +
> +		rc = nfit_mem_add(acpi_desc, nfit_mem, spa);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nfit_mem_cmp(void *priv, struct list_head *__a, struct list_head *__b)
> +{
> +	struct nfit_mem *a = container_of(__a, typeof(*a), list);
> +	struct nfit_mem *b = container_of(__b, typeof(*b), list);
> +	u32 handleA, handleB;
> +
> +	handleA = __to_nfit_memdev(a)->nfit_handle;
> +	handleB = __to_nfit_memdev(b)->nfit_handle;
> +	if (handleA < handleB)
> +		return -1;
> +	else if (handleA > handleB)
> +		return 1;
> +	return 0;
> +}
> +
> +static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
> +{
> +	struct nfit_spa *nfit_spa;
> +
> +	/*
> +	 * For each SPA-DCR or SPA-PMEM address range find its
> +	 * corresponding MEMDEV(s).  From each MEMDEV find the
> +	 * corresponding DCR.  Then, if we're operating on a SPA-DCR,
> +	 * try to find a SPA-BDW and a corresponding BDW that references
> +	 * the DCR.  Throw it all into an nfit_mem object.  Note, that
> +	 * BDWs are optional.
> +	 */
> +	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> +		int rc;
> +
> +		rc = nfit_mem_dcr_init(acpi_desc, nfit_spa->spa);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	list_sort(NULL, &acpi_desc->dimms, nfit_mem_cmp);
> +
> +	return 0;
> +}
> +
> +static int nd_acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
> +{
> +	struct device *dev = acpi_desc->dev;
> +	const void *end;
> +	u8 *data, sum;
> +	acpi_size i;
> +
> +	INIT_LIST_HEAD(&acpi_desc->spas);
> +	INIT_LIST_HEAD(&acpi_desc->dcrs);
> +	INIT_LIST_HEAD(&acpi_desc->bdws);
> +	INIT_LIST_HEAD(&acpi_desc->memdevs);
> +	INIT_LIST_HEAD(&acpi_desc->dimms);
> +
> +	data = (u8 *) acpi_desc->nfit;
> +	for (i = 0, sum = 0; i < sz; i++)
> +		sum += readb(data + i);
> +	if (sum != 0 && !warn_checksum) {
> +		dev_dbg(dev, "%s: nfit checksum failure\n", __func__);
> +		return -ENXIO;
> +	}
> +	WARN_TAINT_ONCE(sum != 0, TAINT_FIRMWARE_WORKAROUND,
> +			"nfit checksum failure, continuing...\n");
> +
> +	end = data + sz;
> +	data += sizeof(struct acpi_nfit);
> +	while (!IS_ERR_OR_NULL(data))
> +		data = add_table(acpi_desc, data, end);

This looks like we are expecting a series of tables here and we're going to
fail the whole discovery if just one of them in invalid.

I wonder if it would be practical to skip just the invalid ones instead?

> +
> +	if (IS_ERR(data)) {
> +		dev_dbg(dev, "%s: nfit table parsing error: %ld\n", __func__,
> +				PTR_ERR(data));
> +		return PTR_ERR(data);
> +	}
> +
> +	if (nfit_mem_init(acpi_desc) != 0)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static int nd_acpi_add(struct acpi_device *adev)
> +{
> +	struct nd_bus_descriptor *nd_desc;
> +	struct acpi_nfit_desc *acpi_desc;
> +	struct device *dev = &adev->dev;
> +	struct acpi_table_header *tbl;
> +	acpi_status status = AE_OK;
> +	acpi_size sz;
> +	int rc;
> +
> +	status = acpi_get_table_with_size("NFIT", 0, &tbl, &sz);
> +	if (ACPI_FAILURE(status)) {
> +		dev_err(dev, "failed to find NFIT\n");
> +		return -ENXIO;
> +	}
> +
> +	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
> +	if (!acpi_desc)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, acpi_desc);
> +	acpi_desc->dev = dev;
> +	acpi_desc->nfit = (struct acpi_nfit *) tbl;
> +	nd_desc = &acpi_desc->nd_desc;
> +	nd_desc->provider_name = "ACPI.NFIT";
> +	nd_desc->ndctl = nd_acpi_ctl;
> +
> +	acpi_desc->nd_bus = nd_bus_register(dev, nd_desc);
> +	if (!acpi_desc->nd_bus)
> +		return -ENXIO;
> +
> +	rc = nd_acpi_nfit_init(acpi_desc, sz);
> +	if (rc) {
> +		nd_bus_unregister(acpi_desc->nd_bus);
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +static int nd_acpi_remove(struct acpi_device *adev)
> +{
> +	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
> +
> +	nd_bus_unregister(acpi_desc->nd_bus);
> +	return 0;
> +}
> +
> +static void nd_acpi_notify(struct acpi_device *adev, u32 event)
> +{
> +	/* TODO: handle ACPI_NOTIFY_BUS_CHECK notification */
> +	dev_dbg(&adev->dev, "%s: event: %d\n", __func__, event);
> +}
> +
> +static const struct acpi_device_id nd_acpi_ids[] = {
> +	{ "ACPI0012", 0 },
> +	{ "", 0 },
> +};
> +MODULE_DEVICE_TABLE(acpi, nd_acpi_ids);
> +
> +static struct acpi_driver nd_acpi_driver = {
> +	.name = KBUILD_MODNAME,
> +	.ids = nd_acpi_ids,
> +	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
> +	.ops = {
> +		.add = nd_acpi_add,
> +		.remove = nd_acpi_remove,
> +		.notify = nd_acpi_notify
> +	},
> +};

Since this is going to be non-modular built-in code, please use an ACPI
scan handler instead of using a driver here.  acpi_memhotplug.c does that,
you can use it as an example, but I guess you don't need to enable hotplug
for it to start with.

> +
> +static __init int nd_acpi_init(void)
> +{
> +	BUILD_BUG_ON(sizeof(struct acpi_nfit) != 40);
> +	BUILD_BUG_ON(sizeof(struct acpi_nfit_spa) != 56);
> +	BUILD_BUG_ON(sizeof(struct acpi_nfit_memdev) != 48);
> +	BUILD_BUG_ON(sizeof(struct acpi_nfit_idt) != 16);
> +	BUILD_BUG_ON(sizeof(struct acpi_nfit_smbios) != 8);
> +	BUILD_BUG_ON(sizeof(struct acpi_nfit_dcr) != 80);
> +	BUILD_BUG_ON(sizeof(struct acpi_nfit_bdw) != 40);
> +
> +	return acpi_bus_register_driver(&nd_acpi_driver);
> +}
> +
> +static __exit void nd_acpi_exit(void)
> +{
> +	acpi_bus_unregister_driver(&nd_acpi_driver);
> +}
> +
> +module_init(nd_acpi_init);
> +module_exit(nd_acpi_exit);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Intel Corporation");
> diff --git a/drivers/block/nd/acpi_nfit.h b/drivers/block/nd/acpi_nfit.h
> new file mode 100644
> index 000000000000..e0b0f12736bf
> --- /dev/null
> +++ b/drivers/block/nd/acpi_nfit.h

I'm assuming that the below is coordinated with Bob and David and will be
changed to use ACPICA-provided definitions going forward.

Is that correct?

> @@ -0,0 +1,254 @@
> +/*
> + * NVDIMM Firmware Interface Table - NFIT
> + *
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
> +#ifndef __NFIT_H__
> +#define __NFIT_H__
> +#include <linux/types.h>
> +#include <linux/uuid.h>
> +#include <linux/acpi.h>
> +#include "libnd.h"
> +
> +static const uuid_le nfit_spa_uuid_volatile __maybe_unused = UUID_LE(0x7305944f,
> +		0xfdda, 0x44e3, 0xb1, 0x6c, 0x3f, 0x22, 0xd2, 0x52, 0xe5, 0xd0);
> +
> +static const uuid_le nfit_spa_uuid_pm __maybe_unused = UUID_LE(0x66f0d379,
> +		0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33, 0x18, 0xb7, 0x8c, 0xdb);
> +
> +static const uuid_le nfit_spa_uuid_dcr __maybe_unused = UUID_LE(0x92f701f6,
> +		0x13b4, 0x405d, 0x91, 0x0b, 0x29, 0x93, 0x67, 0xe8, 0x23, 0x4c);
> +
> +static const uuid_le nfit_spa_uuid_bdw __maybe_unused = UUID_LE(0x91af0530,
> +		0x5d86, 0x470e, 0xa6, 0xb0, 0x0a, 0x2d, 0xb9, 0x40, 0x82, 0x49);
> +
> +static const uuid_le nfit_spa_uuid_vdisk __maybe_unused = UUID_LE(0x77ab535a,
> +		0x45fc, 0x624b, 0x55, 0x60, 0xf7, 0xb2, 0x81, 0xd1, 0xf9, 0x6e);
> +
> +static const uuid_le nfit_spa_uuid_vcd __maybe_unused = UUID_LE(0x3d5abd30,
> +		0x4175, 0x87ce, 0x6d, 0x64, 0xd2, 0xad, 0xe5, 0x23, 0xc4, 0xbb);
> +
> +static const uuid_le nfit_spa_uuid_pdisk __maybe_unused = UUID_LE(0x5cea02c9,
> +		0x4d07, 0x69d3, 0x26, 0x9f, 0x44, 0x96, 0xfb, 0xe0, 0x96, 0xf9);
> +
> +static const uuid_le nfit_spa_uuid_pcd __maybe_unused = UUID_LE(0x08018188,
> +		0x42cd, 0xbb48, 0x10, 0x0f, 0x53, 0x87, 0xd5, 0x3d, 0xed, 0x3d);
> +
> +enum {
> +	NFIT_TABLE_SPA = 0,
> +	NFIT_TABLE_MEM = 1,
> +	NFIT_TABLE_IDT = 2,
> +	NFIT_TABLE_SMBIOS = 3,
> +	NFIT_TABLE_DCR = 4,
> +	NFIT_TABLE_BDW = 5,
> +	NFIT_TABLE_FLUSH = 6,
> +	NFIT_SPA_VOLATILE = 0,
> +	NFIT_SPA_PM = 1,
> +	NFIT_SPA_DCR = 2,
> +	NFIT_SPA_BDW = 3,
> +	NFIT_SPA_VDISK = 4,
> +	NFIT_SPA_VCD = 5,
> +	NFIT_SPA_PDISK = 6,
> +	NFIT_SPA_PCD = 7,
> +	NFIT_SPAF_DCR_HOT_ADD = 1 << 0,
> +	NFIT_SPAF_PDVALID = 1 << 1,
> +	NFIT_MEMF_SAVE_FAIL = 1 << 0,
> +	NFIT_MEMF_RESTORE_FAIL = 1 << 1,
> +	NFIT_MEMF_FLUSH_FAIL = 1 << 2,
> +	NFIT_MEMF_UNARMED = 1 << 3,
> +	NFIT_MEMF_NOTIFY_SMART = 1 << 4,
> +	NFIT_MEMF_SMART_READY = 1 << 5,
> +	NFIT_DCRF_BUFFERED = 1 << 0,
> +};
> +
> +/**
> + * struct acpi_nfit - Nvdimm Firmware Interface Table
> + * @signature: "NFIT"
> + * @length: sum of size of this table plus all appended subtables
> + */
> +struct acpi_nfit {
> +	u8 signature[4];
> +	u32 length;
> +	u8 revision;
> +	u8 checksum;
> +	u8 oemid[6];
> +	u64 oem_tbl_id;
> +	u32 oem_revision;
> +	u32 creator_id;
> +	u32 creator_revision;
> +	u32 reserved;
> +};
> +
> +/**
> + * struct acpi_nfit_spa - System Physical Address Range Descriptor Table
> + */
> +struct acpi_nfit_spa {
> +	u16 type;
> +	u16 length;
> +	u16 spa_index;
> +	u16 flags;
> +	u32 reserved;
> +	u32 proximity_domain;
> +	u8 type_uuid[16];
> +	u64 spa_base;
> +	u64 spa_length;
> +	u64 mem_attr;
> +};
> +
> +/**
> + * struct acpi_nfit_mem - Memory Device to SPA Mapping Table
> + */
> +struct acpi_nfit_memdev {
> +	u16 type;
> +	u16 length;
> +	u32 nfit_handle;
> +	u16 phys_id;
> +	u16 region_id;
> +	u16 spa_index;
> +	u16 dcr_index;
> +	u64 region_len;
> +	u64 region_spa_offset;
> +	u64 region_dpa;
> +	u16 idt_index;
> +	u16 interleave_ways;
> +	u16 flags;
> +	u16 reserved;
> +};
> +
> +/**
> + * struct acpi_nfit_idt - Interleave description Table
> + */
> +struct acpi_nfit_idt {
> +	u16 type;
> +	u16 length;
> +	u16 idt_index;
> +	u16 reserved;
> +	u32 num_lines;
> +	u32 line_size;
> +	u32 line_offset[0];
> +};
> +
> +/**
> + * struct acpi_nfit_smbios - SMBIOS Management Information Table
> + */
> +struct acpi_nfit_smbios {
> +	u16 type;
> +	u16 length;
> +	u32 reserved;
> +	u8 data[0];
> +};
> +
> +/**
> + * struct acpi_nfit_dcr - NVDIMM Control Region Table
> + * @fic: Format Interface Code
> + * @cmd_offset: command registers relative to block control window
> + * @status_offset: status registers relative to block control window
> + */
> +struct acpi_nfit_dcr {
> +	u16 type;
> +	u16 length;
> +	u16 dcr_index;
> +	u16 vendor_id;
> +	u16 device_id;
> +	u16 revision_id;
> +	u16 sub_vendor_id;
> +	u16 sub_device_id;
> +	u16 sub_revision_id;
> +	u8 reserved[6];
> +	u32 serial_number;
> +	u16 fic;
> +	u16 num_bcw;
> +	u64 bcw_size;
> +	u64 cmd_offset;
> +	u64 cmd_size;
> +	u64 status_offset;
> +	u64 status_size;
> +	u16 flags;
> +	u8 reserved2[6];
> +};
> +
> +/**
> + * struct acpi_nfit_bdw - NVDIMM Block Data Window Region Table
> + */
> +struct acpi_nfit_bdw {
> +	u16 type;
> +	u16 length;
> +	u16 dcr_index;
> +	u16 num_bdw;
> +	u64 bdw_offset;
> +	u64 bdw_size;
> +	u64 blk_capacity;
> +	u64 blk_offset;
> +};
> +
> +/**
> + * struct acpi_nfit_flush - Flush Hint Address Structure
> + */
> +struct acpi_nfit_flush {
> +	u16 type;
> +	u16 length;
> +	u32 nfit_handle;
> +	u16 num_hints;
> +	u8 reserved[6];
> +	u64 hint_addr[0];
> +};
> +
> +struct nfit_spa {
> +	struct acpi_nfit_spa *spa;
> +	struct list_head list;
> +};
> +
> +struct nfit_dcr {
> +	struct acpi_nfit_dcr *dcr;
> +	struct list_head list;
> +};
> +
> +struct nfit_bdw {
> +	struct acpi_nfit_bdw *bdw;
> +	struct list_head list;
> +};
> +
> +struct nfit_memdev {
> +	struct acpi_nfit_memdev *memdev;
> +	struct list_head list;
> +};
> +
> +/* assembled tables for a given dimm/memory-device */
> +struct nfit_mem {
> +	struct acpi_nfit_memdev *memdev_dcr;
> +	struct acpi_nfit_memdev *memdev_pmem;
> +	struct acpi_nfit_dcr *dcr;
> +	struct acpi_nfit_bdw *bdw;
> +	struct acpi_nfit_spa *spa_dcr;
> +	struct acpi_nfit_spa *spa_bdw;
> +	struct list_head list;
> +};
> +
> +struct acpi_nfit_desc {
> +	struct nd_bus_descriptor nd_desc;
> +	struct acpi_nfit *nfit;
> +	struct list_head memdevs;
> +	struct list_head dimms;
> +	struct list_head spas;
> +	struct list_head dcrs;
> +	struct list_head bdws;
> +	struct nd_bus *nd_bus;
> +	struct device *dev;
> +};
> +
> +static inline struct acpi_nfit_memdev *__to_nfit_memdev(struct nfit_mem *nfit_mem)
> +{
> +	if (nfit_mem->memdev_dcr)
> +		return nfit_mem->memdev_dcr;
> +	return nfit_mem->memdev_pmem;
> +}
> +#endif /* __NFIT_H__ */
> diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
> new file mode 100644
> index 000000000000..3cccdbc0f3b7
> --- /dev/null
> +++ b/drivers/block/nd/core.c
> @@ -0,0 +1,67 @@
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
> +#include <linux/export.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include "nd-private.h"
> +#include "libnd.h"
> +
> +static DEFINE_IDA(nd_ida);
> +
> +static void nd_bus_release(struct device *dev)
> +{
> +	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
> +
> +	ida_simple_remove(&nd_ida, nd_bus->id);
> +	kfree(nd_bus);
> +}
> +
> +struct nd_bus *nd_bus_register(struct device *parent,
> +		struct nd_bus_descriptor *nd_desc)
> +{
> +	struct nd_bus *nd_bus = kzalloc(sizeof(*nd_bus), GFP_KERNEL);
> +	int rc;
> +
> +	if (!nd_bus)
> +		return NULL;
> +	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
> +	if (nd_bus->id < 0) {
> +		kfree(nd_bus);
> +		return NULL;
> +	}
> +	nd_bus->nd_desc = nd_desc;
> +	nd_bus->dev.parent = parent;
> +	nd_bus->dev.release = nd_bus_release;
> +	dev_set_name(&nd_bus->dev, "ndbus%d", nd_bus->id);
> +	rc = device_register(&nd_bus->dev);
> +	if (rc) {
> +		dev_dbg(&nd_bus->dev, "device registration failed: %d\n", rc);
> +		put_device(&nd_bus->dev);
> +		return NULL;
> +	}
> +
> +	return nd_bus;
> +}
> +EXPORT_SYMBOL_GPL(nd_bus_register);
> +
> +void nd_bus_unregister(struct nd_bus *nd_bus)
> +{
> +	if (!nd_bus)
> +		return;
> +	device_unregister(&nd_bus->dev);
> +}
> +EXPORT_SYMBOL_GPL(nd_bus_unregister);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Intel Corporation");
> diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
> new file mode 100644
> index 000000000000..163832937e9c
> --- /dev/null
> +++ b/drivers/block/nd/libnd.h
> @@ -0,0 +1,33 @@
> +/*
> + * libnd - Non-volatile-memory Devices Subsystem
> + *
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
> +#ifndef __LIBND_H__
> +#define __LIBND_H__
> +struct nd_dimm;
> +struct nd_bus_descriptor;
> +typedef int (*ndctl_fn)(struct nd_bus_descriptor *nd_desc,
> +		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
> +		unsigned int buf_len);
> +
> +struct nd_bus_descriptor {
> +	unsigned long dsm_mask;
> +	char *provider_name;
> +	ndctl_fn ndctl;
> +};
> +
> +struct nd_bus;
> +struct nd_bus *nd_bus_register(struct device *parent,
> +		struct nd_bus_descriptor *nfit_desc);
> +void nd_bus_unregister(struct nd_bus *nd_bus);
> +#endif /* __LIBND_H__ */
> diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
> new file mode 100644
> index 000000000000..3dbab29fa0f9
> --- /dev/null
> +++ b/drivers/block/nd/nd-private.h
> @@ -0,0 +1,23 @@
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
> +#ifndef __ND_PRIVATE_H__
> +#define __ND_PRIVATE_H__
> +#include <linux/device.h>
> +#include "libnd.h"
> +
> +struct nd_bus {
> +	struct nd_bus_descriptor *nd_desc;
> +	struct device dev;
> +	int id;
> +};
> +#endif /* __ND_PRIVATE_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
