Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1430771187.23761.237.camel@misato.fc.hp.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182455.35812.14950.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1430771187.23761.237.camel@misato.fc.hp.com>
Date: Sat, 9 May 2015 16:55:28 -0700
Message-ID: <CAPcyv4hx28msZ+SQ3chRKPqm3bEXBVvZhz6W3OB2CL9PKDMb0g@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 08/20] libnd, nd_acpi: regions
 (block-data-window, persistent memory, volatile memory)
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 4, 2015 at 1:26 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Tue, 2015-04-28 at 14:24 -0400, Dan Williams wrote:
>  :
>> +
>> +static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
>> +             struct nfit_spa *nfit_spa)
>> +{
>> +     static struct nd_mapping nd_mappings[ND_MAX_MAPPINGS];
>> +     struct acpi_nfit_spa *spa = nfit_spa->spa;
>> +     struct nfit_memdev *nfit_memdev;
>> +     struct nd_region_desc ndr_desc;
>> +     int spa_type, count = 0;
>> +     struct resource res;
>> +     u16 spa_index;
>> +
>> +     spa_type = nfit_spa_type(spa);
>> +     spa_index = spa->spa_index;
>> +     if (spa_index == 0) {
>> +             dev_dbg(acpi_desc->dev, "%s: detected invalid spa index\n",
>> +                             __func__);
>> +             return 0;
>> +     }
>> +
>> +     memset(&res, 0, sizeof(res));
>> +     memset(&nd_mappings, 0, sizeof(nd_mappings));
>> +     memset(&ndr_desc, 0, sizeof(ndr_desc));
>> +     res.start = spa->spa_base;
>> +     res.end = res.start + spa->spa_length - 1;
>> +     ndr_desc.res = &res;
>> +     ndr_desc.provider_data = nfit_spa;
>> +     ndr_desc.attr_groups = nd_acpi_region_attribute_groups;
>> +     list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
>> +             struct acpi_nfit_memdev *memdev = nfit_memdev->memdev;
>> +             struct nd_mapping *nd_mapping;
>> +             struct nd_dimm *nd_dimm;
>> +
>> +             if (memdev->spa_index != spa_index)
>> +                     continue;
>
> The libnd does not support memdev->flags, which contains "Memory Device
> State Flags" defined in Table 5-129 of ACPI 6.0.  In case of major
> errors, we should only allow a failed NVDIMM be accessed with read-only
> for possible data recovery (or not allow any access when the data is
> completely lost), and should not let users operate normally over the
> corrupted data until the error is dealt properly.

I agree with setting read-only access when these flags show that the
battery is not ready to persist new writes, but I don't think we
should block access in the case where the restore from flash failed.
If the data is potentially corrupted we should log that fact, but
otherwise enable access.  I.e. potentially corrupt data is better than
unavailable data.  It's up to filesystem or application to maintain
its own checksums to catch data corruption.

> Can you set memdev->flags to nd_region(_desc) so that the pmem driver
> can check the status in nd_pmem_probe()?  nd_pmem_probe() can then set
> the disk read-only or fail probing, and log errors accordingly.

Will do.
