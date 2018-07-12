Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C2C82097E27C
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 08:31:37 -0700 (PDT)
Date: Thu, 12 Jul 2018 09:31:12 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv2 1/2] libnvdimm: Use max contiguous area for namespace
 size
Message-ID: <20180712153111.GA16325@localhost.localdomain>
References: <20180705201726.512-1-keith.busch@intel.com>
 <CAPcyv4hVO38=7fxegS0BY2ePr4NPtajsQyyAYt=8=u5si_9r3g@mail.gmail.com>
 <CAPcyv4hcfdr+8HUs9gsxYH7vZgtPCLwF6fvbC8-Z7YDC1GqXMQ@mail.gmail.com>
 <20180706220612.GA2803@localhost.localdomain>
 <CAPcyv4if4fmaCOtCa05o72LkgR7A=YLfeNP5fqKCNBDnDjKFjA@mail.gmail.com>
 <20180709154442.GA3534@localhost.localdomain>
 <CAPcyv4jQNRTt=81bUzs1amoWytQdQx3TjG=FAQzT=6HhEk0NBA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jQNRTt=81bUzs1amoWytQdQx3TjG=FAQzT=6HhEk0NBA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 09, 2018 at 02:49:54PM -0700, Dan Williams wrote:
> On Mon, Jul 9, 2018 at 8:44 AM, Keith Busch <keith.busch@intel.com> wrote:
> > On Fri, Jul 06, 2018 at 03:25:15PM -0700, Dan Williams wrote:
> >> This is going in the right direction... but still needs to account for
> >> the blk_overlap.
> >>
> >> So, on a given DIMM BLK capacity is allocated from the top of DPA
> >> space going down and PMEM capacity is allocated from the bottom of the
> >> DPA space going up.
> >>
> >> Since BLK capacity is single DIMM, and PMEM capacity is striped you
> >> could get into the situation where one DIMM is fully allocated for BLK
> >> usage and that would shade / remove the possibility to use the PMEM
> >> capacity on the other DIMMs in the PMEM set. PMEM needs all the same
> >> DPAs in all the DIMMs to be free.
> >>
> >> >
> >> > ---
> >> > diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> >> > index 8d348b22ba45..f30e0c3b0282 100644
> >> > --- a/drivers/nvdimm/dimm_devs.c
> >> > +++ b/drivers/nvdimm/dimm_devs.c
> >> > @@ -536,6 +536,31 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
> >> >         return info.available;
> >> >  }
> >> >
> >> > +/**
> >> > + * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
> >> > + *                             contiguous unallocated dpa range.
> >> > + * @nd_region: constrain available space check to this reference region
> >> > + * @nd_mapping: container of dpa-resource-root + labels
> >> > + */
> >> > +resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
> >> > +                                          struct nd_mapping *nd_mapping)
> >> > +{
> >> > +       struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> >> > +       resource_size_t max = 0;
> >> > +       struct resource *res;
> >> > +
> >> > +       if (!ndd)
> >> > +               return 0;
> >> > +
> >> > +       for_each_dpa_resource(ndd, res) {
> >> > +               if (strcmp(res->name, "pmem-reserve") != 0)
> >> > +                       continue;
> >> > +               if (resource_size(res) > max)
> >>
> >> ...so instead straight resource_size() here you need trim the end of
> >> this "pmem-reserve" resource to the start of the first BLK allocation
> >> in any of the DIMMs in the set.
> >>
> >> See blk_start calculation in nd_pmem_available_dpa().

Okay, I think I've got it this time. __reserve_free_pmem won't reserve a
resource above the first blk resource, so we can't get some fragmented
alternating mix of blk and pmem within a dimm. With that in mind, if
we reserve pmem across all dimms in a region, take the largest reserved
pmem within each dimm, then take the smallest of those across all dimms,
that should be the largest allocatable pmem extent.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
