Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 775AA20961854
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 08:46:31 -0700 (PDT)
Date: Mon, 9 Jul 2018 09:44:42 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv2 1/2] libnvdimm: Use max contiguous area for namespace
 size
Message-ID: <20180709154442.GA3534@localhost.localdomain>
References: <20180705201726.512-1-keith.busch@intel.com>
 <CAPcyv4hVO38=7fxegS0BY2ePr4NPtajsQyyAYt=8=u5si_9r3g@mail.gmail.com>
 <CAPcyv4hcfdr+8HUs9gsxYH7vZgtPCLwF6fvbC8-Z7YDC1GqXMQ@mail.gmail.com>
 <20180706220612.GA2803@localhost.localdomain>
 <CAPcyv4if4fmaCOtCa05o72LkgR7A=YLfeNP5fqKCNBDnDjKFjA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4if4fmaCOtCa05o72LkgR7A=YLfeNP5fqKCNBDnDjKFjA@mail.gmail.com>
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

On Fri, Jul 06, 2018 at 03:25:15PM -0700, Dan Williams wrote:
> This is going in the right direction... but still needs to account for
> the blk_overlap.
> 
> So, on a given DIMM BLK capacity is allocated from the top of DPA
> space going down and PMEM capacity is allocated from the bottom of the
> DPA space going up.
> 
> Since BLK capacity is single DIMM, and PMEM capacity is striped you
> could get into the situation where one DIMM is fully allocated for BLK
> usage and that would shade / remove the possibility to use the PMEM
> capacity on the other DIMMs in the PMEM set. PMEM needs all the same
> DPAs in all the DIMMs to be free.
> 
> >
> > ---
> > diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> > index 8d348b22ba45..f30e0c3b0282 100644
> > --- a/drivers/nvdimm/dimm_devs.c
> > +++ b/drivers/nvdimm/dimm_devs.c
> > @@ -536,6 +536,31 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
> >         return info.available;
> >  }
> >
> > +/**
> > + * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
> > + *                             contiguous unallocated dpa range.
> > + * @nd_region: constrain available space check to this reference region
> > + * @nd_mapping: container of dpa-resource-root + labels
> > + */
> > +resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
> > +                                          struct nd_mapping *nd_mapping)
> > +{
> > +       struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> > +       resource_size_t max = 0;
> > +       struct resource *res;
> > +
> > +       if (!ndd)
> > +               return 0;
> > +
> > +       for_each_dpa_resource(ndd, res) {
> > +               if (strcmp(res->name, "pmem-reserve") != 0)
> > +                       continue;
> > +               if (resource_size(res) > max)
> 
> ...so instead straight resource_size() here you need trim the end of
> this "pmem-reserve" resource to the start of the first BLK allocation
> in any of the DIMMs in the set.
> 
> See blk_start calculation in nd_pmem_available_dpa().

Hmm, the resources defining this are a bit inconvenient given these
constraints. If an unallocated portion of a DIMM may only be used for
BLK because an overlapping range in another DIMM is allocated that way,
would it make since to insert something like a "blk-reserve" resource
in all the other DIMMs so we don't need multiple iterations to calculate
which DPAs can be used for PMEM?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
