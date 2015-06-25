Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1435269103.11808.349.camel@misato.fc.hp.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	<20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
	<1435254317.11808.327.camel@misato.fc.hp.com>
	<1435257283.13411.4.camel@intel.com>
	<CAPcyv4jhDc1+TGyo4J6vC7bRBaGbfAXyLP2qB9X5DAJRBhCRyQ@mail.gmail.com>
	<1435269103.11808.349.camel@misato.fc.hp.com>
Date: Thu, 25 Jun 2015 15:00:56 -0700
Message-ID: <CAPcyv4gqgbEVWDKR4e8=Uaz1As4FxY4-8VHWKZfQ-vtc2wOs3g@mail.gmail.com>
Subject: Re: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 25, 2015 at 2:51 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2015-06-25 at 14:31 -0700, Dan Williams wrote:
>> On Thu, Jun 25, 2015 at 11:34 AM, Williams, Dan J
>> <dan.j.williams@intel.com> wrote:
>> > On Thu, 2015-06-25 at 11:45 -0600, Toshi Kani wrote:
>> >> On Thu, 2015-06-25 at 05:37 -0400, Dan Williams wrote:
>> >> > From: Toshi Kani <toshi.kani@hp.com>
>> >> >
>> >> > ACPI NFIT table has System Physical Address Range Structure entries that
>> >> > describe a proximity ID of each range when ACPI_NFIT_PROXIMITY_VALID is
>> >> > set in the flags.
>> >> >
>> >> > Change acpi_nfit_register_region() to map a proximity ID to its node ID,
>> >> > and set it to a new numa_node field of nd_region_desc, which is then
>> >> > conveyed to the nd_region device.
>> >> >
>> >> > The device core arranges for btt and namespace devices to inherit their
>> >> > node from their parent region.
>> >> >
>> >> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>> >> > [djbw: move set_dev_node() from region 'probe' to 'create']
>> >>
>> >> Sorry, I failed to mention other issue, which led me call set_dev_node()
>> >> in probe.  nd_async_device_register() calls device_add(), which does:
>> >>
>> >>         /* use parent numa_node */
>> >>         if (parent)
>> >>                 set_dev_node(dev, dev_to_node(parent));
>> >>
>> >> and overwrites numa_node to -1.  Since region's parent is ndbusN, we
>> >> cannot set numa_node to the parent.  So, I had to set it in probe.
>> >
>> > In general, I still don't like leaving it up to ->probe() which is
>> > within its rights to fail and not set the node.  How about the following
>> > that moves it to the bus uevent code?  Should get triggered before probe
>> > so the numa_node is valid before userspace is ever notified about the
>> > device.
>> >
>> > device_add() does:
>> >
>> >         kobject_uevent(&dev->kobj, KOBJ_ADD);
>> >         bus_probe_device(dev);
>> >
>> > ...so I think we're good, agree?  I also added a missing init of
>> > ndr_desc.numa_node in arch/x86/kernel/pmem.c, see below.
>>
>> This looks good in a quick manual test.  It's interesting/illustrative
>> that I inadvertently broke the one bit of the libnvdimm sysfs
>> interface that did not have unit test coverage.
>
> Sorry I had some interrupt.  Yes, this works fine for region &
> namespace.  I'd like to check with you for btt since the attach logic
> has changed in v2.
>
> Previously, as described in patch 16/17, bttN bound to pmem had a valid
> numa_node value, and seeding btt0 had -1.
>
>   /sys/bus/nd/devices
>   |-- btt0/numa_node:-1
>   |-- btt1/numa_node:0
>
> In this version, there are unbound (seeding?) btt0-3 for every region
> (there are 4 regions) and btt4 & 5 bound to pmem0 & 3 on my system.
>
> btt0/numa_node:0
> btt1/numa_node:0
> btt2/numa_node:1
> btt3/numa_node:1
> btt4/numa_node:0
> btt5/numa_node:1
>
> btt0
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/btt0
> btt1
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region1/btt1
> btt2
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region2/btt2
> btt3
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region3/btt3
> btt4
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/btt4
> btt5
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region3/btt5
>
> And unbound bttNs attach to different regions across a reboot.
>
> btt0/numa_node:0
> btt1/numa_node:1
> btt2/numa_node:1
> btt3/numa_node:0
> btt4/numa_node:0
> btt5/numa_node:1
>
> btt0
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/btt0
> btt1
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region3/btt1
> btt2
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region2/btt2
> btt3
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region1/btt3
> btt4
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/btt4
> btt5
> -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region3/btt5
>
> Is this how you'd expect btt to work in this version?  (I have not
> looked at the btt changes yet)

Yes, this looks fine.

As requested by Christoph, in the latest version BTTs are child
devices of regions rather than busses.  They automatically inherit the
numa_node of the parent region.  In your dump above the numa_nodes are
not changing from boot-to-boot, instead the BTTs are registered
asynchronously so get different ids from boot-to-boot.  Userspace
should not care what the btt id is and the same naming trick we use to
give block devices static names would not work for BTTs.  The child
block device of the BTT will still have the static name as we
discussed earlier (/dev/pmemXs or /dev/ndblkX.Ys) because the scan
order of those is deterministic.
