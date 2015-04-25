Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1429922126.23761.42.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH 08/21] nd: ndctl.h, the nd ioctl abi
From: Toshi Kani <toshi.kani@hp.com>
Date: Fri, 24 Apr 2015 18:35:26 -0600
In-Reply-To: <CAPcyv4hZ-V3qyb6krz1y0hKH5bU3q5aN=4+ZMfZU5mk2PTu-0Q@mail.gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150418013557.25237.81354.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1429890991.16996.55.camel@misato.fc.hp.com>
	 <CAPcyv4gCk-5yi0iF5O2+ydFsTnpoZ-JNadHbzaGn7Vg02tWNWA@mail.gmail.com>
	 <1429895881.23761.16.camel@misato.fc.hp.com>
	 <CAPcyv4hZ-V3qyb6krz1y0hKH5bU3q5aN=4+ZMfZU5mk2PTu-0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-04-24 at 10:45 -0700, Dan Williams wrote:
> On Fri, Apr 24, 2015 at 10:18 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Fri, 2015-04-24 at 09:25 -0700, Dan Williams wrote:
> >> On Fri, Apr 24, 2015 at 8:56 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> >> > On Fri, 2015-04-17 at 21:35 -0400, Dan Williams wrote:
> >> >> Most configuration of the nd-subsystem is done via nd-sysfs.  However,
> >> >> the NFIT specification defines a small set of messages that can be
> >> >> passed to the subsystem via platform-firmware-defined methods.  The
> >> >> command set (as of the current version of the NFIT-DSM spec) is:
> >> >>
> >> >>     NFIT_CMD_SMART: media health and diagnostics
> >> >>     NFIT_CMD_GET_CONFIG_SIZE: size of the label space
> >> >>     NFIT_CMD_GET_CONFIG_DATA: read label
> >> >>     NFIT_CMD_SET_CONFIG_DATA: write label
> >> >>     NFIT_CMD_VENDOR: vendor-specific command passthrough
> >> >>     NFIT_CMD_ARS_CAP: report address-range-scrubbing capabilities
> >> >>     NFIT_CMD_START_ARS: initiate scrubbing
> >> >>     NFIT_CMD_QUERY_ARS: report on scrubbing state
> >> >>     NFIT_CMD_SMART_THRESHOLD: configure alarm thresholds for smart events
> >> >
> >> > "nd/bus.c" provides two features, 1) the top level ND bus driver which
> >> > is the central part of the ND, and 2) the ioctl interface specific to
> >> > the example-DSM-interface.  I think the example-DSM-specific part should
> >> > be put into an example-DSM-support module, so that the ND can support
> >> > other _DSMs as necessary.  Also, _DSM needs to be handled as optional.
> >>
> >> I don't think it needs to be separated, they'll both end up using the
> >> same infrastructure just with different UUIDs on the ACPI device
> >> interface or different format-interface-codes.  A firmware
> >> implementation is also free to disable individual DSMs (see
> >> nd_acpi_add_dimm).
> >
> > Well, ioctl cmd# is essentially func# of the _DSM, and each cmd
> > structure needs to match with its _DSM output data structure.  So, I do
> > not think these cmds will work for other _DSMs.  That said, the ND is
> > complex enough already, and we should not make it more complicated for
> > the initial version...  So, how about changing the name of /dev/ndctl0
> > to indicate RFIC 0x0201, ex. /dev/nd0201ctl0?  That should allow
> > separate ioctl()s for other RFICs.  The code can be updated when other
> > _DSM actually needs to be supported by the ND.
> 
> No, all you need is unique command names (see libndctl
> ndctl_{bus|dimm}_is_cmd_supported()) and then translate the ND cmd
> number to the firmware function number in the "provider".  It just so
> happens that for these first set of commands the ND cmd number matches
> the ACPI device function number in the DSM-interface-example, but
> there is no reason that need always be the case.

I misread the code -- /dev/ndctlN is for a bus, and /dev/nmemN is for a
DIMM.  RFIC 0x0201 matches to DIMMs, not the bus.  Since the _DSM under
ACPI0013 is generic, we are probably OK with ndctl.

The DIMM driver is fully integrated with the example-DSM.  Separating
nd/acpi.c alone would not solve it...  In your fix that will make the
DIMM _DSM optional, do you plan to make the DIMM driver more independent
from the example-DIMM _DSM?

Thanks,
-Toshi

