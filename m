Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1429654584.17259.68.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH 08/21] nd: ndctl.h, the nd ioctl abi
From: Toshi Kani <toshi.kani@hp.com>
Date: Tue, 21 Apr 2015 16:16:24 -0600
In-Reply-To: <CAPcyv4ifYUQWBxem2w2JXxJ9YHirzuZbmcE8D8=br2sfOk53jw@mail.gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150418013557.25237.81354.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1429651258.17259.60.camel@misato.fc.hp.com>
	 <CAPcyv4ifYUQWBxem2w2JXxJ9YHirzuZbmcE8D8=br2sfOk53jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-04-21 at 15:05 -0700, Dan Williams wrote:
> On Tue, Apr 21, 2015 at 2:20 PM, Toshi Kani <toshi.kani@hp.com> wrote:
 :
> >> +static int nd_acpi_add_dimm(struct nfit_bus_descriptor *nfit_desc,
> >> +             struct nd_dimm *nd_dimm)
> >> +{
> >> +     struct acpi_nfit *nfit = to_acpi_nfit(nfit_desc);
> >> +     u32 nfit_handle = to_nfit_handle(nd_dimm);
> >> +     struct device *dev = &nfit->dev->dev;
> >> +     struct acpi_device *acpi_dimm;
> >> +     unsigned long dsm_mask = 0;
> >> +     u8 *uuid = nd_acpi_dimm_uuid();
> >> +     unsigned long long sta;
> >> +     int i, rc = -ENODEV;
> >> +     acpi_status status;
> >> +
> >> +     acpi_dimm = acpi_find_child_device(nfit->dev, nfit_handle, false);
> >> +     if (!acpi_dimm) {
> >> +             dev_err(dev, "no ACPI.NFIT device with _ADR %#x, disabling...\n",
> >> +                             nfit_handle);
> >> +             return -ENODEV;
> >> +     }
> >> +
> >> +     status = acpi_evaluate_integer(acpi_dimm->handle, "_STA", NULL, &sta);
> >> +     if (status == AE_NOT_FOUND)
> >> +             dev_err(dev, "%s missing _STA, disabling...\n",
> >> +                             dev_name(&acpi_dimm->dev));
> >
> > I do not think it is correct to set a DIMM _ADR object disabled when it
> > has no _STA.  ACPI 6.0 spec states the followings:
> >
> >  - Section 6.3.7 _STA, "If a device object describes a device that is
> > not on an enumerable bus and the device object does not have an _STA
> > object, then OSPM assumes that the device is present, enabled, shown in
> > the UI, and functioning."
> 
> Ok, I'll take a look.

Great!

> [..]
> > So, in this case, it should set the DIMM object enabled or look up the
> > NFIT table to check the presence.
> 
> At this point we've already determined that a dimm device is present
> because nd_acpi_add_dimm() is called for each dimm found in the NFIT.
> Does that count as "enumerable" and require an _STA?

I think it means that if a bus is enumerable, then it needs to enumerate
the bus to check the status, instead of assuming it present.  In other
words, _STA is required for representing non-present status on a
non-enumerable bus.

In any case, we've already enumerated the NFIT table before this point,
so there is no reason to handle the non-_STA case as disabled.

Thanks,
-Toshi


