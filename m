Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 3 Jun 2015 16:57:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 02/21] libnvdimm, nfit: initial libnvdimm
	infrastructure and NFIT support
Message-ID: <20150603145704.GA22311@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001419.4506.41953.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150602001419.4506.41953.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 01, 2015 at 08:14:19PM -0400, Dan Williams wrote:
> A libnvdimm bus is the anchor device for registering nvdimm resources and
> interfaces, for example, a character control device, nvdimm devices,
> and I/O region devices.  The ACPI NFIT (NVDIMM Firmware Interface Table)
> is one possible platform description for such non-volatile memory
> resources in a system.  The nfit.ko driver attaches to the "ACPI0012"
> device that indicates the presence of the NFIT and parses the table to
> register a libnvdimm bus instance.

Havin lib in a name of a bus seems odd.  Why not simply the nvdimm bus?

Also this seems to both have the generic nvdimm infrastructure as well
as the acpi wiring.  Might make sense to split this into two patches?

> +config ACPI_NFIT
> +	tristate "ACPI NVDIMM Firmware Interface Table (NFIT)"
> +	depends on PHYS_ADDR_T_64BIT
> +	depends on BLK_DEV
> +	select NVDIMM_DEVICES
> +	select LIBNVDIMM

Is this the right way for the user to chose it?  It seems like enabling
the NVMDIMM subsystem would be the obvious choice, and ACPI would
simply enable the table parsing in that case.

> +static u8 nfit_uuid[NFIT_UUID_MAX][16];

Should this use the uuid_le type?

> +static const char *spa_type_name(u16 type)
> +{
> +	switch (type) {
> +	case NFIT_SPA_VOLATILE: return "volatile";
> +	case NFIT_SPA_PM: return "pmem";
> +	case NFIT_SPA_DCR: return "dimm-control-region";
> +	case NFIT_SPA_BDW: return "block-data-window";
> +	default: return "unknown";

Please never put code on the same line as a switch (or goto) label.

> +static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table, const void *end)
> +{
> +	struct device *dev = acpi_desc->dev;
> +	struct acpi_nfit_header *hdr;
> +	void *err = ERR_PTR(-ENOMEM);
> +
> +	if (table >= end)
> +		return NULL;
> +
> +	hdr = (struct acpi_nfit_header *) table;

No need to case from void * to another pointer type.

> +	switch (hdr->type) {
> +	case ACPI_NFIT_TYPE_SYSTEM_ADDRESS: {
> +		struct nfit_spa *nfit_spa = devm_kzalloc(dev, sizeof(*nfit_spa),
> +				GFP_KERNEL);
> +		struct acpi_nfit_system_address *spa = table;
> +
> +		if (!nfit_spa)
> +			return err;
> +		INIT_LIST_HEAD(&nfit_spa->list);
> +		nfit_spa->spa = spa;
> +		list_add_tail(&nfit_spa->list, &acpi_desc->spas);
> +		dev_dbg(dev, "%s: spa index: %d type: %s\n", __func__,
> +				spa->range_index,
> +				spa_type_name(nfit_spa_type(spa)));

If you need local variables inside a switch statement you probably
want to split each case into a separate helper function.

> +static inline struct acpi_nfit_memory_map *__to_nfit_memdev(struct nfit_mem *nfit_mem)

This line is over 80 characters.

Also why the odd __-prefix?

> new file mode 100644
> index 000000000000..24b51dbc8215
> --- /dev/null
> +++ b/drivers/nvdimm/Kconfig
> @@ -0,0 +1,20 @@
> +menuconfig NVDIMM_DEVICES
> +	bool "NVDIMM (Non-Volatile Memory Device) Support"
> +	help
> +	  Generic support for non-volatile memory devices including
> +	  ACPI-6-NFIT defined resources.  On platforms that define an
> +	  NFIT, or otherwise can discover NVDIMM resources, a libnvdimm
> +	  bus is registered to advertise PMEM (persistent memory)
> +	  namespaces (/dev/pmemX) and BLK (sliding mmio window(s))
> +	  namespaces (/dev/ndX). A PMEM namespace refers to a memory
> +	  resource that may span multiple DIMMs and support DAX (see
> +	  CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
> +	  region which exposes an mmio register set for windowed
> +	  access mode to non-volatile memory.
> +
> +if NVDIMM_DEVICES
> +
> +config LIBNVDIMM
> +	tristate
> +
> +endif

What different meanings will CONFIG_NVDIMM_DEVICES and CONFIG_LIBNVDIMM
have?

> diff --git a/drivers/nvdimm/nd-private.h b/drivers/nvdimm/nd-private.h
> new file mode 100644
> index 000000000000..e7c4e99a22a4
> --- /dev/null
> +++ b/drivers/nvdimm/nd-private.h

No need for -private if you're already under drivers/nvdimm..

> +#ifndef __ND_PRIVATE_H__
> +#define __ND_PRIVATE_H__
> +#include <linux/libnvdimm.h>
> +#include <linux/device.h>
> +
> +struct nvdimm_bus {
> +	struct nvdimm_bus_descriptor *nd_desc;
> +	struct device dev;
> +	int id;
> +};
> +#endif /* __ND_PRIVATE_H__ */

At least so far this header doesn't need libnvdimm.h

> +#ifndef __LIBNVDIMM_H__
> +#define __LIBNVDIMM_H__
> +struct nvdimm;
> +struct nvdimm_bus_descriptor;
> +typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
> +		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
> +		unsigned int buf_len);
> +
> +struct nvdimm_bus_descriptor {
> +	unsigned long dsm_mask;
> +	char *provider_name;
> +	ndctl_fn ndctl;
> +};

Please provide proper methods that do one thing properly instead of
ioctl-like multiplexers.
