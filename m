Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 02/20] libnd, nd_acpi: initial libnd infrastructure and NFIT support
Date: Fri, 01 May 2015 03:21:29 +0200
Message-ID: <2235175.7DaGPJD1E4@vostro.rjw.lan>
In-Reply-To: <CAPcyv4hVvZdM0DUk5GhJE5C6QSkKjetRh2JVR5eh+JaJgYMrNA@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com> <5532780.fyo4CQJEJz@vostro.rjw.lan> <CAPcyv4hVvZdM0DUk5GhJE5C6QSkKjetRh2JVR5eh+JaJgYMrNA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Box <david.e.box@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, April 30, 2015 05:39:06 PM Dan Williams wrote:
> On Thu, Apr 30, 2015 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, April 28, 2015 02:24:23 PM Dan Williams wrote:
> >> 1/ Autodetect an NFIT table for the ACPI namespace device with _HID of
> >>    "ACPI0012"
> >>
> >> 2/ libnd bus registration
> >>
> >> The NFIT provided by ACPI is one possible method by which platforms will
> >> discover NVDIMM resources.  However, the intent of the nd_bus_descriptor
> >> abstraction is to abstract "provider" specific details, leaving libnd
> >> to be independent of the specific NVDIMM resource discovery mechanism.
> >> This flexibility is later exploited later to implement custom-defined nd
> >> buses.
> >>
> >> Cc: <linux-acpi@vger.kernel.org>
> >> Cc: Robert Moore <robert.moore@intel.com>
> >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >>  drivers/block/Kconfig         |    2
> >>  drivers/block/Makefile        |    1
> >>  drivers/block/nd/Kconfig      |   40 +++
> >>  drivers/block/nd/Makefile     |    6 +
> >>  drivers/block/nd/acpi.c       |  475 +++++++++++++++++++++++++++++++++++++++++
> >>  drivers/block/nd/acpi_nfit.h  |  254 ++++++++++++++++++++++
> >>  drivers/block/nd/core.c       |   67 ++++++
> >>  drivers/block/nd/libnd.h      |   33 +++
> >>  drivers/block/nd/nd-private.h |   23 ++
> >>  9 files changed, 901 insertions(+)
> >>  create mode 100644 drivers/block/nd/Kconfig
> >>  create mode 100644 drivers/block/nd/Makefile
> >>  create mode 100644 drivers/block/nd/acpi.c
> >>  create mode 100644 drivers/block/nd/acpi_nfit.h
> >>  create mode 100644 drivers/block/nd/core.c
> >>  create mode 100644 drivers/block/nd/libnd.h
> >>  create mode 100644 drivers/block/nd/nd-private.h
> >>
> >> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> >> index eb1fed5bd516..dfe40e5ca9bd 100644
> >> --- a/drivers/block/Kconfig
> >> +++ b/drivers/block/Kconfig
> >> @@ -321,6 +321,8 @@ config BLK_DEV_NVME
> >>         To compile this driver as a module, choose M here: the
> >>         module will be called nvme.
> >>
> >> +source "drivers/block/nd/Kconfig"
> >> +
> >>  config BLK_DEV_SKD
> >>       tristate "STEC S1120 Block Driver"
> >>       depends on PCI
> >> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
> >> index 9cc6c18a1c7e..07a6acecf4d8 100644
> >> --- a/drivers/block/Makefile
> >> +++ b/drivers/block/Makefile
> >> @@ -24,6 +24,7 @@ obj-$(CONFIG_CDROM_PKTCDVD) += pktcdvd.o
> >>  obj-$(CONFIG_MG_DISK)                += mg_disk.o
> >>  obj-$(CONFIG_SUNVDC)         += sunvdc.o
> >>  obj-$(CONFIG_BLK_DEV_NVME)   += nvme.o
> >> +obj-$(CONFIG_ND_DEVICES)     += nd/
> >>  obj-$(CONFIG_BLK_DEV_SKD)    += skd.o
> >>  obj-$(CONFIG_BLK_DEV_OSD)    += osdblk.o
> >>
> >> diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
> >> new file mode 100644
> >> index 000000000000..6d5d6b732f82
> >> --- /dev/null
> >> +++ b/drivers/block/nd/Kconfig
> >> @@ -0,0 +1,40 @@
> >> +menuconfig ND_DEVICES
> >> +     bool "NVDIMM Support"
> >> +     depends on PHYS_ADDR_T_64BIT
> >> +     help
> >> +       Generic support for non-volatile memory devices including
> >> +       ACPI-6-NFIT defined resources.  On platforms that define an
> >> +       NFIT, or otherwise can discover NVDIMM resources, a libnd
> >> +       bus is registered to advertise PMEM (persistent memory)
> >> +       namespaces (/dev/pmemX) and BLK (sliding mmio window(s))
> >> +       namespaces (/dev/ndX). A PMEM namespace refers to a memory
> >> +       resource that may span multiple DIMMs and support DAX (see
> >> +       CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
> >> +       region which exposes an mmio register set for windowed
> >> +       access mode to non-volatile memory.
> >> +
> >> +if ND_DEVICES
> >> +
> >> +config LIBND
> >> +     tristate "LIBND: libnd device driver support"
> >> +     help
> >> +       Platform agnostic device model for a libnd bus.  Publishes
> >> +       resources for a PMEM (persistent-memory) driver and/or BLK
> >> +       (sliding mmio window(s)) driver to attach.  Exposes a device
> >> +       topology under a "ndX" bus device, a "/dev/ndctlX" bus-ioctl
> >> +       message passing interface, and a "/dev/nmemX" dimm-ioctl
> >> +       message interface for each memory device registered on the
> >> +       bus.  instance.  A userspace library "ndctl" provides an API
> >> +       to enumerate/manage this subsystem.
> >> +
> >> +config ND_ACPI
> >> +     tristate "ACPI: NFIT to libnd bus support"
> >> +     select LIBND
> >> +     depends on ACPI
> >> +     help
> >> +       Infrastructure to probe ACPI 6 compliant platforms for
> >> +       NVDIMMs (NFIT) and register a libnd device tree.  In
> >> +       addition to storage devices this also enables libnd craft
> >> +       ACPI._DSM messages for platform/dimm configuration.
> >
> > I'm wondering if the two CONFIG options above really need to be user-selectable?
> >
> > For example, what reason people (who've already selected ND_DEVICES) may have
> > for not selecting ND_ACPI if ACPI is set?
> 
> 
> Later on in the series we introduce ND_E820 which supports creating a
> libnd-bus from e820-type-12 memory ranges on pre-NFIT systems.  I'm
> also considering a configfs defined libnd-bus because e820 types are
> not nearly enough information to safely define nvdimm resources
> outside of NFIT.

I hope these are not mutually exclusive with ND_ACPI?  Otherwise distros
will have problems with supporting them in one kernel.

If ND_E820 and ND_ACPI aren't mutually exclusive, I still don't see a good
enough reason for asking users about ND_ACPI.  Why would I ever say "No"
here if I said "Yes" or "Module" to ND_DEVICES?


> >> +
> >> +endif
> >> diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
> >> new file mode 100644
> >> index 000000000000..944b5947c0cb
> >> --- /dev/null
> >> +++ b/drivers/block/nd/Makefile
> >> @@ -0,0 +1,6 @@
> >> +obj-$(CONFIG_LIBND) += libnd.o
> >> +obj-$(CONFIG_ND_ACPI) += nd_acpi.o
> >> +
> >> +nd_acpi-y := acpi.o
> >> +
> >> +libnd-y := core.o
> >
> > OK, so it looks like no modules, just built-in code, right?
> >
> 
> Um, no, both CONFIG_ND_ACPI and CONFIG_LIBND can be =m.

OK

[cut]

> >> +static int nd_acpi_remove(struct acpi_device *adev)
> >> +{
> >> +     struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
> >> +
> >> +     nd_bus_unregister(acpi_desc->nd_bus);
> >> +     return 0;
> >> +}
> >> +
> >> +static void nd_acpi_notify(struct acpi_device *adev, u32 event)
> >> +{
> >> +     /* TODO: handle ACPI_NOTIFY_BUS_CHECK notification */
> >> +     dev_dbg(&adev->dev, "%s: event: %d\n", __func__, event);
> >> +}
> >> +
> >> +static const struct acpi_device_id nd_acpi_ids[] = {
> >> +     { "ACPI0012", 0 },
> >> +     { "", 0 },
> >> +};
> >> +MODULE_DEVICE_TABLE(acpi, nd_acpi_ids);
> >> +
> >> +static struct acpi_driver nd_acpi_driver = {
> >> +     .name = KBUILD_MODNAME,
> >> +     .ids = nd_acpi_ids,
> >> +     .flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
> >> +     .ops = {
> >> +             .add = nd_acpi_add,
> >> +             .remove = nd_acpi_remove,
> >> +             .notify = nd_acpi_notify
> >> +     },
> >> +};
> >
> > Since this is going to be non-modular built-in code, please use an ACPI
> > scan handler instead of using a driver here.  acpi_memhotplug.c does that,
> > you can use it as an example, but I guess you don't need to enable hotplug
> > for it to start with.
> 
> 
> No, you misunderstood, this will certainly be modular and loaded on-demand.

OK

So please drop the .notify thing at least for now.  It most likely doesn't do
what you need anyway.

> >
> >> +
> >> +static __init int nd_acpi_init(void)
> >> +{
> >> +     BUILD_BUG_ON(sizeof(struct acpi_nfit) != 40);
> >> +     BUILD_BUG_ON(sizeof(struct acpi_nfit_spa) != 56);
> >> +     BUILD_BUG_ON(sizeof(struct acpi_nfit_memdev) != 48);
> >> +     BUILD_BUG_ON(sizeof(struct acpi_nfit_idt) != 16);
> >> +     BUILD_BUG_ON(sizeof(struct acpi_nfit_smbios) != 8);
> >> +     BUILD_BUG_ON(sizeof(struct acpi_nfit_dcr) != 80);
> >> +     BUILD_BUG_ON(sizeof(struct acpi_nfit_bdw) != 40);
> >> +
> >> +     return acpi_bus_register_driver(&nd_acpi_driver);
> >> +}
> >> +
> >> +static __exit void nd_acpi_exit(void)
> >> +{
> >> +     acpi_bus_unregister_driver(&nd_acpi_driver);
> >> +}
> >> +
> >> +module_init(nd_acpi_init);
> >> +module_exit(nd_acpi_exit);
> >> +MODULE_LICENSE("GPL v2");
> >> +MODULE_AUTHOR("Intel Corporation");
> >> diff --git a/drivers/block/nd/acpi_nfit.h b/drivers/block/nd/acpi_nfit.h
> >> new file mode 100644
> >> index 000000000000..e0b0f12736bf
> >> --- /dev/null
> >> +++ b/drivers/block/nd/acpi_nfit.h
> >
> > I'm assuming that the below is coordinated with Bob and David and will be
> > changed to use ACPICA-provided definitions going forward.
> >
> > Is that correct?
> 
> Yes, as soon as definitions those are available we will drop this
> header and rebase on the ACPICA implementation.
> 
> [..]

OK


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
