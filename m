Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [Linux-nvdimm] [PATCH v2 08/20] libnd, nd_acpi: regions
 (block-data-window, persistent memory, volatile memory)
Date: Wed, 29 Apr 2015 15:53:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A8CA1D0@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150428182455.35812.14950.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428182455.35812.14950.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dan Williams
> Sent: Tuesday, April 28, 2015 1:25 PM
> Subject: [Linux-nvdimm] [PATCH v2 08/20] libnd, nd_acpi: regions (block-
> data-window, persistent memory, volatile memory)
> 
> A "region" device represents the maximum capacity of a BLK range (mmio
> block-data-window(s)), or a PMEM range (DAX-capable persistent memory or
> volatile memory), without regard for aliasing.  Aliasing, in the
> dimm-local address space (DPA), is resolved by metadata on a dimm to
> designate which exclusive interface will access the aliased DPA ranges.
> Support for the per-dimm metadata/label arrvies is in a subsequent
> patch.
> 
> The name format of "region" devices is "regionN" where, like dimms, N is
> a global ida index assigned at discovery time.  This id is not reliable
> across reboots nor in the presence of hotplug.  Look to attributes of
> the region or static id-data of the sub-namespace to generate a
> persistent name.
...
> +++ b/drivers/block/nd/region_devs.c
...
> +static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
> +		struct nd_region_desc *ndr_desc, struct device_type *dev_type)
> +{
> +	struct nd_region *nd_region;
> +	struct device *dev;
> +	u16 i;
> +
> +	for (i = 0; i < ndr_desc->num_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
> +		struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
> +
> +		if ((nd_mapping->start | nd_mapping->size) % SZ_4K) {
> +			dev_err(&nd_bus->dev, "%pf: %s mapping%d is not 4K
> aligned\n",
> +					__builtin_return_address(0),

Please use "KiB" rather than the unclear "K".

Same comment for a dev_dbg print in patch 14.

> +					dev_name(&nd_dimm->dev), i);
> +
> +			return NULL;
> +		}
> +	}
> +
> +	nd_region = kzalloc(sizeof(struct nd_region)
> +			+ sizeof(struct nd_mapping) * ndr_desc->num_mappings,
> +			GFP_KERNEL);
> +	if (!nd_region)
> +		return NULL;
> +	nd_region->id = ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
> +	if (nd_region->id < 0) {
> +		kfree(nd_region);
> +		return NULL;
> +	}
> +
> +	memcpy(nd_region->mapping, ndr_desc->nd_mapping,
> +			sizeof(struct nd_mapping) * ndr_desc->num_mappings);
> +	for (i = 0; i < ndr_desc->num_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
> +		struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
> +
> +		get_device(&nd_dimm->dev);
> +	}
> +	nd_region->ndr_mappings = ndr_desc->num_mappings;
> +	nd_region->provider_data = ndr_desc->provider_data;
> +	dev = &nd_region->dev;
> +	dev_set_name(dev, "region%d", nd_region->id);

Could this include "nd" in the name, like "ndregion%d"?

The other dev_set_name calls in this patch set use:
	btt%d
	ndbus%d
	nmem%d
	namespace%d.%d

which are a bit more distinctive.

---
Robert Elliott, HP Server Storage
