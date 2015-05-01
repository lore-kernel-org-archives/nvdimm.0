Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2235175.7DaGPJD1E4@vostro.rjw.lan>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<5532780.fyo4CQJEJz@vostro.rjw.lan>
	<CAPcyv4hVvZdM0DUk5GhJE5C6QSkKjetRh2JVR5eh+JaJgYMrNA@mail.gmail.com>
	<2235175.7DaGPJD1E4@vostro.rjw.lan>
Date: Fri, 1 May 2015 09:23:38 -0700
Message-ID: <CAPcyv4iuPy+KR1YgE+jc91XoHSueR_k0zry-8umJWBjXzcUasg@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] libnd, nd_acpi: initial libnd infrastructure and
 NFIT support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Box <david.e.box@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 30, 2015 at 6:21 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, April 30, 2015 05:39:06 PM Dan Williams wrote:
>> On Thu, Apr 30, 2015 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
[..]
>> >> +if ND_DEVICES
>> >> +
>> >> +config LIBND
>> >> +     tristate "LIBND: libnd device driver support"
>> >> +     help
>> >> +       Platform agnostic device model for a libnd bus.  Publishes
>> >> +       resources for a PMEM (persistent-memory) driver and/or BLK
>> >> +       (sliding mmio window(s)) driver to attach.  Exposes a device
>> >> +       topology under a "ndX" bus device, a "/dev/ndctlX" bus-ioctl
>> >> +       message passing interface, and a "/dev/nmemX" dimm-ioctl
>> >> +       message interface for each memory device registered on the
>> >> +       bus.  instance.  A userspace library "ndctl" provides an API
>> >> +       to enumerate/manage this subsystem.
>> >> +
>> >> +config ND_ACPI
>> >> +     tristate "ACPI: NFIT to libnd bus support"
>> >> +     select LIBND
>> >> +     depends on ACPI
>> >> +     help
>> >> +       Infrastructure to probe ACPI 6 compliant platforms for
>> >> +       NVDIMMs (NFIT) and register a libnd device tree.  In
>> >> +       addition to storage devices this also enables libnd craft
>> >> +       ACPI._DSM messages for platform/dimm configuration.
>> >
>> > I'm wondering if the two CONFIG options above really need to be user-selectable?
>> >
>> > For example, what reason people (who've already selected ND_DEVICES) may have
>> > for not selecting ND_ACPI if ACPI is set?
>>
>>
>> Later on in the series we introduce ND_E820 which supports creating a
>> libnd-bus from e820-type-12 memory ranges on pre-NFIT systems.  I'm
>> also considering a configfs defined libnd-bus because e820 types are
>> not nearly enough information to safely define nvdimm resources
>> outside of NFIT.
>
> I hope these are not mutually exclusive with ND_ACPI?  Otherwise distros
> will have problems with supporting them in one kernel.

You can have ND_E820 support and ND_ACPI support in the same system.
Likely an NFIT enabled system will never have e820-type-12 ranges, but
if a user messes up and uses the new memmap=ss!nn command line to
overlap NFIT-defined memory then the request_mem_region() calls in the
driver will collide.  First to load wins in that scenario.

> If ND_E820 and ND_ACPI aren't mutually exclusive, I still don't see a good
> enough reason for asking users about ND_ACPI.  Why would I ever say "No"
> here if I said "Yes" or "Module" to ND_DEVICES?

I agree that if the user selects ND_DEVICES then ND_ACPI should
probably default on, but otherwise turning it off is a useful option.
If you know your system is pre-ACPI-6 then why bother including
support?

>> >> +
>> >> +endif
>> >> diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
>> >> new file mode 100644
>> >> index 000000000000..944b5947c0cb
>> >> --- /dev/null
>> >> +++ b/drivers/block/nd/Makefile
>> >> @@ -0,0 +1,6 @@
>> >> +obj-$(CONFIG_LIBND) += libnd.o
>> >> +obj-$(CONFIG_ND_ACPI) += nd_acpi.o
>> >> +
>> >> +nd_acpi-y := acpi.o
>> >> +
>> >> +libnd-y := core.o
>> >
>> > OK, so it looks like no modules, just built-in code, right?
>> >
>>
>> Um, no, both CONFIG_ND_ACPI and CONFIG_LIBND can be =m.
>
> OK
>
> [cut]
>
>> >> +static int nd_acpi_remove(struct acpi_device *adev)
>> >> +{
>> >> +     struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
>> >> +
>> >> +     nd_bus_unregister(acpi_desc->nd_bus);
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +static void nd_acpi_notify(struct acpi_device *adev, u32 event)
>> >> +{
>> >> +     /* TODO: handle ACPI_NOTIFY_BUS_CHECK notification */
>> >> +     dev_dbg(&adev->dev, "%s: event: %d\n", __func__, event);
>> >> +}
>> >> +
>> >> +static const struct acpi_device_id nd_acpi_ids[] = {
>> >> +     { "ACPI0012", 0 },
>> >> +     { "", 0 },
>> >> +};
>> >> +MODULE_DEVICE_TABLE(acpi, nd_acpi_ids);
>> >> +
>> >> +static struct acpi_driver nd_acpi_driver = {
>> >> +     .name = KBUILD_MODNAME,
>> >> +     .ids = nd_acpi_ids,
>> >> +     .flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
>> >> +     .ops = {
>> >> +             .add = nd_acpi_add,
>> >> +             .remove = nd_acpi_remove,
>> >> +             .notify = nd_acpi_notify
>> >> +     },
>> >> +};
>> >
>> > Since this is going to be non-modular built-in code, please use an ACPI
>> > scan handler instead of using a driver here.  acpi_memhotplug.c does that,
>> > you can use it as an example, but I guess you don't need to enable hotplug
>> > for it to start with.
>>
>>
>> No, you misunderstood, this will certainly be modular and loaded on-demand.
>
> OK
>
> So please drop the .notify thing at least for now.  It most likely doesn't do
> what you need anyway.

The .notify handler will eventually be filled in to handle hot-add of
NFIT structures, but yes I'll drop it for now.
