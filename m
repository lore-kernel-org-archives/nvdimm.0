Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A8CA1D0@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182455.35812.14950.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A8CA1D0@G9W0745.americas.hpqcorp.net>
Date: Wed, 29 Apr 2015 08:59:03 -0700
Message-ID: <CAPcyv4ggJGus44p4f9XWZNV5r=Gbmcct_xEtfp7Ja-AMO03T2w@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 08/20] libnd, nd_acpi: regions
 (block-data-window, persistent memory, volatile memory)
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 29, 2015 at 8:53 AM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Tuesday, April 28, 2015 1:25 PM
>> Subject: [Linux-nvdimm] [PATCH v2 08/20] libnd, nd_acpi: regions (block-
>> data-window, persistent memory, volatile memory)
>>
>> A "region" device represents the maximum capacity of a BLK range (mmio
>> block-data-window(s)), or a PMEM range (DAX-capable persistent memory or
>> volatile memory), without regard for aliasing.  Aliasing, in the
>> dimm-local address space (DPA), is resolved by metadata on a dimm to
>> designate which exclusive interface will access the aliased DPA ranges.
>> Support for the per-dimm metadata/label arrvies is in a subsequent
>> patch.
>>
>> The name format of "region" devices is "regionN" where, like dimms, N is
>> a global ida index assigned at discovery time.  This id is not reliable
>> across reboots nor in the presence of hotplug.  Look to attributes of
>> the region or static id-data of the sub-namespace to generate a
>> persistent name.
> ...
>> +++ b/drivers/block/nd/region_devs.c
> ...
>> +static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
>> +             struct nd_region_desc *ndr_desc, struct device_type *dev_type)
>> +{
>> +     struct nd_region *nd_region;
>> +     struct device *dev;
>> +     u16 i;
>> +
>> +     for (i = 0; i < ndr_desc->num_mappings; i++) {
>> +             struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
>> +             struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
>> +
>> +             if ((nd_mapping->start | nd_mapping->size) % SZ_4K) {
>> +                     dev_err(&nd_bus->dev, "%pf: %s mapping%d is not 4K
>> aligned\n",
>> +                                     __builtin_return_address(0),
>
> Please use "KiB" rather than the unclear "K".

Ok.

> Same comment for a dev_dbg print in patch 14.

It's a debug statement, but ok.

[..]
>
> Could this include "nd" in the name, like "ndregion%d"?
>
> The other dev_set_name calls in this patch set use:
>         btt%d
>         ndbus%d
>         nmem%d
>         namespace%d.%d
>
> which are a bit more distinctive.

They sit on an "nd" bus and don't have global device nodes, I don't
see a need to make them anymore distinctive.
