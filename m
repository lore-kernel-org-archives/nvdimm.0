Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1429731538.16996.32.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH 04/21] nd: create an 'nd_bus' from an
 'nfit_desc'
From: Toshi Kani <toshi.kani@hp.com>
Date: Wed, 22 Apr 2015 13:38:58 -0600
In-Reply-To: <CAPcyv4jArCHBaBri=rH_-gXNr3CookzKLhEQ8XM33kW1bueU=Q@mail.gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150418013535.25237.4770.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1429644912.17259.31.camel@misato.fc.hp.com>
	 <CAPcyv4iHHRUg4q2cT0MHQGx1VV=F8qh3bbBvU_CXr7wuO0Ccww@mail.gmail.com>
	 <1429646156.17259.39.camel@misato.fc.hp.com>
	 <CAPcyv4gx7f90Kf+4h4drSSz+q54+ezJPtGRH7TwYcAudhvjmHw@mail.gmail.com>
	 <1429720742.15952.30.camel@misato.fc.hp.com>
	 <CAPcyv4h1kYH7-ia8J8bBpmRY89LXe3TnvQPGc2SuxqyEF9MQEw@mail.gmail.com>
	 <5537E1D9.6010609@hp.com>
	 <CAPcyv4jNL-R_zHt2=O-sD+hqsL-a7mP7Tmi0t9H0StKxaFsgUg@mail.gmail.com>
	 <1429727038.16996.16.camel@misato.fc.hp.com>
	 <CAPcyv4jArCHBaBri=rH_-gXNr3CookzKLhEQ8XM33kW1bueU=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linda Knippers <linda.knippers@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-04-22 at 12:28 -0700, Dan Williams wrote:
> On Wed, Apr 22, 2015 at 11:23 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Wed, 2015-04-22 at 11:20 -0700, Dan Williams wrote:
> >> On Wed, Apr 22, 2015 at 11:00 AM, Linda Knippers <linda.knippers@hp.com> wrote:
> >> Wait, point of clarification, DCRs (dimm-control-regions) have RFICs,
> >> not MEMDEVs (memory-device-to-spa-mapping).  Toshi's original report
> >> was that an NFIT with a SPA+MEMDEV was failing to enable a PMEM
> >> device.  That specific problem can be fixed by either deleting the
> >> MEMDEV, or adding a DCR.
> >
> > By a DCR, do you mean a DCR structure or SPA with Control Region GUID?
> 
> Hmm, I meant a DCR as defined below.  I agree you would not need a "SPA-DCR".
> 
> > Adding a DCR structure does not solve this issue since it requires SPA
> > with Control Region GUID, which battery-backed DIMMs do not have.
> 
> I would not go that far, half of a DCR entry is relevant for any
> NVDIMM, and half is only relevant if a DIMM offers BLK access:
> 
> struct acpi_nfit_dcr {
>         u16 type;
>         u16 length;
>         u16 dcr_index;
>         u16 vendor_id;
>         u16 device_id;
>         u16 revision_id;
>         u16 sub_vendor_id;
>         u16 sub_device_id;
>         u16 sub_revision_id;
>         u8 reserved[6];
>         u32 serial_number;
>         u16 fic;
> <<<<< BLK relevant fields start here <<<<<
>         u16 num_bcw;
>         u64 bcw_size;
>         u64 cmd_offset;
>         u64 cmd_size;
>         u64 status_offset;
>         u64 status_size;
>         u16 flags;
>         u8 reserved2[6];
> };

Yes, we do have a DCR entry.  But we do not have a SPA-DCR.

The previous issue I reported to nd_mem_init() was caused by the fact
that there was no "SPA-DCR".  nd_mem_init() requires SPA-DCR to
initialize nd_mem objects.

> >> Of course, if you add a DCR with a different intended DSM layout than
> >> the DSM-example-interface the driver will need to add support for
> >> handling that case.
> >
> > Yes, we consider to add different _DSMs for management.  We do not need
> > the nd_acpi driver to support it now, but we need this framework to work
> > without the DSM-example-interface present.
> >
> 
> One possible workaround is that I could ignore MEMDEV entries that do
> not have a corresponding DCR.  This would enable nd_namespace_io
> devices to be surfaced for your use case.  Would that work for you?
> I.e. do you need the nfit_handle exposed?

We have MEMDEV entries and their corresponding DCR entries.  ACPI 6.0
states that NVDIMM control region structure index must contain a
non-zero value in a MEMDEV entry, so I think they must correspond.

Yes, we need this framework to enumerate all entries.

Thanks,
-Toshi



