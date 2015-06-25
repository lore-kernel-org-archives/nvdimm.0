Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1435257283.13411.4.camel@intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	<20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
	<1435254317.11808.327.camel@misato.fc.hp.com>
	<1435257283.13411.4.camel@intel.com>
Date: Thu, 25 Jun 2015 14:31:21 -0700
Message-ID: <CAPcyv4jhDc1+TGyo4J6vC7bRBaGbfAXyLP2qB9X5DAJRBhCRyQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: "toshi.kani@hp.com" <toshi.kani@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 25, 2015 at 11:34 AM, Williams, Dan J
<dan.j.williams@intel.com> wrote:
> On Thu, 2015-06-25 at 11:45 -0600, Toshi Kani wrote:
>> On Thu, 2015-06-25 at 05:37 -0400, Dan Williams wrote:
>> > From: Toshi Kani <toshi.kani@hp.com>
>> >
>> > ACPI NFIT table has System Physical Address Range Structure entries that
>> > describe a proximity ID of each range when ACPI_NFIT_PROXIMITY_VALID is
>> > set in the flags.
>> >
>> > Change acpi_nfit_register_region() to map a proximity ID to its node ID,
>> > and set it to a new numa_node field of nd_region_desc, which is then
>> > conveyed to the nd_region device.
>> >
>> > The device core arranges for btt and namespace devices to inherit their
>> > node from their parent region.
>> >
>> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>> > [djbw: move set_dev_node() from region 'probe' to 'create']
>>
>> Sorry, I failed to mention other issue, which led me call set_dev_node()
>> in probe.  nd_async_device_register() calls device_add(), which does:
>>
>>         /* use parent numa_node */
>>         if (parent)
>>                 set_dev_node(dev, dev_to_node(parent));
>>
>> and overwrites numa_node to -1.  Since region's parent is ndbusN, we
>> cannot set numa_node to the parent.  So, I had to set it in probe.
>
> In general, I still don't like leaving it up to ->probe() which is
> within its rights to fail and not set the node.  How about the following
> that moves it to the bus uevent code?  Should get triggered before probe
> so the numa_node is valid before userspace is ever notified about the
> device.
>
> device_add() does:
>
>         kobject_uevent(&dev->kobj, KOBJ_ADD);
>         bus_probe_device(dev);
>
> ...so I think we're good, agree?  I also added a missing init of
> ndr_desc.numa_node in arch/x86/kernel/pmem.c, see below.

This looks good in a quick manual test.  It's interesting/illustrative
that I inadvertently broke the one bit of the libnvdimm sysfs
interface that did not have unit test coverage.
