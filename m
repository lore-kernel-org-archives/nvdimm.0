Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1429648353.17259.40.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH 04/21] nd: create an 'nd_bus' from an
 'nfit_desc'
From: Toshi Kani <toshi.kani@hp.com>
Date: Tue, 21 Apr 2015 14:32:33 -0600
In-Reply-To: <CAPcyv4gx7f90Kf+4h4drSSz+q54+ezJPtGRH7TwYcAudhvjmHw@mail.gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150418013535.25237.4770.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1429644912.17259.31.camel@misato.fc.hp.com>
	 <CAPcyv4iHHRUg4q2cT0MHQGx1VV=F8qh3bbBvU_CXr7wuO0Ccww@mail.gmail.com>
	 <1429646156.17259.39.camel@misato.fc.hp.com>
	 <CAPcyv4gx7f90Kf+4h4drSSz+q54+ezJPtGRH7TwYcAudhvjmHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-04-21 at 13:35 -0700, Dan Williams wrote:
> On Tue, Apr 21, 2015 at 12:55 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Tue, 2015-04-21 at 12:58 -0700, Dan Williams wrote:
> >> On Tue, Apr 21, 2015 at 12:35 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> >> > On Fri, 2015-04-17 at 21:35 -0400, Dan Williams wrote:
> >> >  :
> >> >> +
> >> >> +static int nd_mem_init(struct nd_bus *nd_bus)
> >> >> +{
> >> >> +     struct nd_spa *nd_spa;
> >> >> +
> >> >> +     /*
> >> >> +      * For each SPA-DCR address range find its corresponding
> >> >> +      * MEMDEV(s).  From each MEMDEV find the corresponding DCR.
> >> >> +      * Then, try to find a SPA-BDW and a corresponding BDW that
> >> >> +      * references the DCR.  Throw it all into an nd_mem object.
> >> >> +      * Note, that BDWs are optional.
> >> >> +      */
> >> >> +     list_for_each_entry(nd_spa, &nd_bus->spas, list) {
> >> >> +             u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
> >> >> +             int type = nfit_spa_type(nd_spa->nfit_spa);
> >> >> +             struct nd_mem *nd_mem, *found;
> >> >> +             struct nd_memdev *nd_memdev;
> >> >> +             u16 dcr_index;
> >> >> +
> >> >> +             if (type != NFIT_SPA_DCR)
> >> >> +                     continue;
> >> >
> >> > This function requires NFIT_SPA_DCR, SPA Range Structure with NVDIMM
> >> > Control Region GUID, for initializing an nd_mem object.  However,
> >> > battery-backed DIMMs do not have such control region SPA.  IIUC, the
> >> > NFIT spec does not require NFIT_SPA_DCR.
> >> >
> >> > Can you change this function to work with NFIT_SPA_PM as well?
> >>
> >> NFIT_SPA_PM ranges are handled separately from nd_mem_init().  See
> >> nd_region_create() in patch 10.
> >
> > If nd_mem_init() does not initialize nd_mem objects, nd_bus_probe() in
> > core.c fails in nd_bus_init_interleave_sets() and skips all subsequent
> > nd_bus_xxx() calls.  So, nd_region_create() won't be called.
> >
> > nd_bus_init_interleave_sets() fails because init_interleave_set()
> > returns -ENODEV if (!nd_mem).
> 
> Ah, ok  your test case is specifying PMEM backed by memory device
> info.  We have a test case for simple ranges (nfit_test1_setup()), but
> it doesn't hit this bug because it does not specify any memory-device
> tables.
> 
> Thanks, will fix this in v2 of the patch set.
> 
> > BTW, there are two nd_bus_probe() in bus.c and core.c, which is
> > confusing.
> 
> Ok, will fix this as well in the v2 posting.

Cool!  Thanks Dan!
-Toshi

