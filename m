Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1430507711.23761.182.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 05/20] libnd, nd_acpi:
 dimm/memory-devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Fri, 01 May 2015 13:15:11 -0600
In-Reply-To: <CAPcyv4hZsnFvZhdAAo4_oHGWbWCjVDQUwj8pDXHHW+wpYCiwgg@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150428182439.35812.81191.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1430502493.23761.145.camel@misato.fc.hp.com>
	 <CAPcyv4hUeWzBgOv4q7UHN1+nDVGV2QzNg0dojZvs04YObok3SQ@mail.gmail.com>
	 <1430504355.23761.153.camel@misato.fc.hp.com>
	 <CAPcyv4hZsnFvZhdAAo4_oHGWbWCjVDQUwj8pDXHHW+wpYCiwgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-05-01 at 11:43 -0700, Dan Williams wrote:
> On Fri, May 1, 2015 at 11:19 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Fri, 2015-05-01 at 11:22 -0700, Dan Williams wrote:
> >> On Fri, May 1, 2015 at 10:48 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> >> > On Tue, 2015-04-28 at 14:24 -0400, Dan Williams wrote:
> >> >> Register the memory devices described in the nfit as libnd 'dimm'
> >> >> devices on an nd bus.  The kernel assigned device id for dimms is
> >> >> dynamic.  If userspace needs a more static identifier it should consult
> >> >> a provider-specific attribute.  In the case where NFIT is the provider,
> >> >> the 'nmemX/nfit/handle' or 'nmemX/nfit/serial' attributes may be used
> >> >> for this purpose.
> >> >  :
> >> >> +
> >> >> +static int nd_acpi_register_dimms(struct acpi_nfit_desc *acpi_desc)
> >> >> +{
> >> >> +     struct nfit_mem *nfit_mem;
> >> >> +
> >> >> +     list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
> >> >> +             struct nd_dimm *nd_dimm;
> >> >> +             unsigned long flags = 0;
> >> >> +             u32 nfit_handle;
> >> >> +
> >> >> +             nfit_handle = __to_nfit_memdev(nfit_mem)->nfit_handle;
> >> >> +             nd_dimm = nd_acpi_dimm_by_handle(acpi_desc, nfit_handle);
> >> >> +             if (nd_dimm) {
> >> >> +                     /*
> >> >> +                      * If for some reason we find multiple DCRs the
> >> >> +                      * first one wins
> >> >> +                      */
> >> >> +                     dev_err(acpi_desc->dev, "duplicate DCR detected: %s\n",
> >> >> +                                     nd_dimm_name(nd_dimm));
> >> >> +                     continue;
> >> >> +             }
> >> >> +
> >> >> +             if (nfit_mem->bdw && nfit_mem->memdev_pmem)
> >> >> +                     flags |= NDD_ALIASING;
> >> >
> >> > Does this check work for a NVDIMM card which has multiple pmem regions
> >> > with label info, but does not have any bdw region configured?
> >>
> >> If you have multiple pmem regions then you don't have aliasing and
> >> don't need a label.  You'll get an nd_namespace_io per region.
> >>
> >> > The code assumes that namespace_pmem (NDD_ALIASING) and namespace_blk
> >> > have label info.  There may be an NVDIMM card with a single blk region
> >> > without label info.
> >>
> >> I'd really like to suggest that labels are only for resolving aliasing
> >> and that if you have a BLK-only NVDIMM you'll get an automatic
> >> namespace created the same as a PMEM-only.  Partitioning is always
> >> there to provide sub-divisions of a namespace.  The only reason to
> >> support multiple BLK-namespaces per-region is to give each a different
> >> sector size.  I may eventually need to relent on this position, but
> >> I'd really like to understand the use case for requiring labels when
> >> aliasing is not present as it seems like a waste to me.
> >
> > By looking at the callers of is_namespace_pmem() and is_namespace_blk(),
> > such as nd_namespace_label_update(), I am concerned that the namespace
> > types are also used for indicating the presence a label.  Is it OK for
> > nd_namespace_label_update() to do nothing when there is no aliasing?

Did you forget to answer this question?  I am not asking to have a
label.  I am asking if the namespace types can handle it correctly.
Restating the nd_namespace_label_update() example:
 - namespace_io case: Skip, but a label may still exist. Correct?
 - namespace_blk case: Proceed, but blk does not require a label.

> >> > Instead of using the namespace types to assume the label info, how about
> >> > adding a flag to indicate the presence of the label info?  This avoids
> >> > the separation of namespace_io and namespace_pmem for the same pmem
> >> > driver.
> >>
> >> To what benefit?
> >
> > Why do they need to be separated? Having alias or not should not make
> > the pmem namespace different.
> 
> The intent is to maximize the number of devices that can be
> immediately attached to nd_pmem and nd_blk without user intervention.

I agree with your intention.  Again, I am not asking to have a label.

> nd_namespace_io is a pmem namespace where the boundaries are 100%
> described by the NFIT / parent-region.

Thanks,
-Toshi

