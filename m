Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 02/20] libnd, nd_acpi: initial libnd infrastructure and NFIT support
Date: Tue, 05 May 2015 01:58:15 +0200
Message-ID: <6932657.HzjR3A75KT@vostro.rjw.lan>
In-Reply-To: <CAPcyv4iuPy+KR1YgE+jc91XoHSueR_k0zry-8umJWBjXzcUasg@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com> <2235175.7DaGPJD1E4@vostro.rjw.lan> <CAPcyv4iuPy+KR1YgE+jc91XoHSueR_k0zry-8umJWBjXzcUasg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Box <david.e.box@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Friday, May 01, 2015 09:23:38 AM Dan Williams wrote:
> On Thu, Apr 30, 2015 at 6:21 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, April 30, 2015 05:39:06 PM Dan Williams wrote:
> >> On Thu, Apr 30, 2015 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> [..]
> >> >> +if ND_DEVICES
> >> >> +
> >> >> +config LIBND
> >> >> +     tristate "LIBND: libnd device driver support"
> >> >> +     help
> >> >> +       Platform agnostic device model for a libnd bus.  Publishes
> >> >> +       resources for a PMEM (persistent-memory) driver and/or BLK
> >> >> +       (sliding mmio window(s)) driver to attach.  Exposes a device
> >> >> +       topology under a "ndX" bus device, a "/dev/ndctlX" bus-ioctl
> >> >> +       message passing interface, and a "/dev/nmemX" dimm-ioctl
> >> >> +       message interface for each memory device registered on the
> >> >> +       bus.  instance.  A userspace library "ndctl" provides an API
> >> >> +       to enumerate/manage this subsystem.
> >> >> +
> >> >> +config ND_ACPI
> >> >> +     tristate "ACPI: NFIT to libnd bus support"
> >> >> +     select LIBND
> >> >> +     depends on ACPI
> >> >> +     help
> >> >> +       Infrastructure to probe ACPI 6 compliant platforms for
> >> >> +       NVDIMMs (NFIT) and register a libnd device tree.  In
> >> >> +       addition to storage devices this also enables libnd craft
> >> >> +       ACPI._DSM messages for platform/dimm configuration.
> >> >
> >> > I'm wondering if the two CONFIG options above really need to be user-selectable?
> >> >
> >> > For example, what reason people (who've already selected ND_DEVICES) may have
> >> > for not selecting ND_ACPI if ACPI is set?
> >>
> >>
> >> Later on in the series we introduce ND_E820 which supports creating a
> >> libnd-bus from e820-type-12 memory ranges on pre-NFIT systems.  I'm
> >> also considering a configfs defined libnd-bus because e820 types are
> >> not nearly enough information to safely define nvdimm resources
> >> outside of NFIT.
> >
> > I hope these are not mutually exclusive with ND_ACPI?  Otherwise distros
> > will have problems with supporting them in one kernel.
> 
> You can have ND_E820 support and ND_ACPI support in the same system.
> Likely an NFIT enabled system will never have e820-type-12 ranges, but
> if a user messes up and uses the new memmap=ss!nn command line to
> overlap NFIT-defined memory then the request_mem_region() calls in the
> driver will collide.  First to load wins in that scenario.
> 
> > If ND_E820 and ND_ACPI aren't mutually exclusive, I still don't see a good
> > enough reason for asking users about ND_ACPI.  Why would I ever say "No"
> > here if I said "Yes" or "Module" to ND_DEVICES?
> 
> I agree that if the user selects ND_DEVICES then ND_ACPI should
> probably default on, but otherwise turning it off is a useful option.
> If you know your system is pre-ACPI-6 then why bother including
> support?

If you're a distro, you don't care.  You have to support it regardless.

You might care if you're an end user building a kernel for yourself and just
for this particular specific machine.  Honestly, how many *server* users do
that?

And fewer user-selectable options means fewer combination of options to test
during development/validation.

Also unrelated, but applies to this patch.

Since your new driver will handle device ID ACPI0012 which is defined by the
spec proper, it should go into drivers/acpi/, because there's where such things
go as a rule.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
