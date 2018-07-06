Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D5F2211F8893
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 15:25:16 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id k81-v6so26168301oib.4
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 15:25:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180706220612.GA2803@localhost.localdomain>
References: <20180705201726.512-1-keith.busch@intel.com>
 <CAPcyv4hVO38=7fxegS0BY2ePr4NPtajsQyyAYt=8=u5si_9r3g@mail.gmail.com>
 <CAPcyv4hcfdr+8HUs9gsxYH7vZgtPCLwF6fvbC8-Z7YDC1GqXMQ@mail.gmail.com>
 <20180706220612.GA2803@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Jul 2018 15:25:15 -0700
Message-ID: <CAPcyv4if4fmaCOtCa05o72LkgR7A=YLfeNP5fqKCNBDnDjKFjA@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] libnvdimm: Use max contiguous area for namespace
 size
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
To: Keith Busch <keith.busch@intel.com>
Cc: stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 6, 2018 at 3:06 PM, Keith Busch <keith.busch@intel.com> wrote:
> On Thu, Jul 05, 2018 at 06:48:25PM -0700, Dan Williams wrote:
>> On Thu, Jul 5, 2018 at 6:25 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > So, I liked how simple and straightforward this was, but the unit test
>> > reminded me how complicated the free space allocation could be given
>> > that we still might need to account for aliased BLK capacity.
>> >
>> > A few things I now notice:
>> >
>> > * It is possible for a dpa resource to start before nd_mapping->start
>> > and/or end after nd_mapping->size. See the diagram in
>> > tools/testing/nvdimm/test/nfit.c
>> >
>> > * We need to be summing the max extents across all DIMMs in the set
>> > while also accounting for this BLK overlap problem that
>> > nd_pmem_available_dpa() handles.
>> >
>> > The original bug arose from the fact that the
>> > nd_region_available_dpa() accounts for total busy capacity and the
>> > allocation path looks for extents. It would be nice to unify those two
>> > functions... or maybe standardize on scan_allocate() everywhere.
>>
>> I think you can redo this using reserve_free_pmem() and then find the
>> largest free space reservation after accounting for blk_max_overlap as
>> calculated by nd_region_available_dpa().
>>
>> reserve_free_pmem() inserts resources into the dpa resource tree with
>> the name "pmem-reserve" then you need to filter those against
>> blk_max_overlap to find which ones might appear free, but shadowed by
>> a BLK allocation on one of the DIMMs in the set. Yes, it allocates
>> memory and is heavy handed, but I'm having a hard time thinking of
>> something better at the moment.
>
> Okay, I think I follow what you're saying, but let me just see if the
> following is what you had in mind before sending a v3:

This is going in the right direction... but still needs to account for
the blk_overlap.

So, on a given DIMM BLK capacity is allocated from the top of DPA
space going down and PMEM capacity is allocated from the bottom of the
DPA space going up.

Since BLK capacity is single DIMM, and PMEM capacity is striped you
could get into the situation where one DIMM is fully allocated for BLK
usage and that would shade / remove the possibility to use the PMEM
capacity on the other DIMMs in the PMEM set. PMEM needs all the same
DPAs in all the DIMMs to be free.

>
> ---
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 8d348b22ba45..f30e0c3b0282 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -536,6 +536,31 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
>         return info.available;
>  }
>
> +/**
> + * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
> + *                             contiguous unallocated dpa range.
> + * @nd_region: constrain available space check to this reference region
> + * @nd_mapping: container of dpa-resource-root + labels
> + */
> +resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
> +                                          struct nd_mapping *nd_mapping)
> +{
> +       struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +       resource_size_t max = 0;
> +       struct resource *res;
> +
> +       if (!ndd)
> +               return 0;
> +
> +       for_each_dpa_resource(ndd, res) {
> +               if (strcmp(res->name, "pmem-reserve") != 0)
> +                       continue;
> +               if (resource_size(res) > max)

...so instead straight resource_size() here you need trim the end of
this "pmem-reserve" resource to the start of the first BLK allocation
in any of the DIMMs in the set.

See blk_start calculation in nd_pmem_available_dpa().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
