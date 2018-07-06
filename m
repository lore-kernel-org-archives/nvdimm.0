Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CAD572096FAAE
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 18:48:27 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id w126-v6so20542033oie.7
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 18:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hVO38=7fxegS0BY2ePr4NPtajsQyyAYt=8=u5si_9r3g@mail.gmail.com>
References: <20180705201726.512-1-keith.busch@intel.com>
 <CAPcyv4hVO38=7fxegS0BY2ePr4NPtajsQyyAYt=8=u5si_9r3g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Jul 2018 18:48:25 -0700
Message-ID: <CAPcyv4hcfdr+8HUs9gsxYH7vZgtPCLwF6fvbC8-Z7YDC1GqXMQ@mail.gmail.com>
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

On Thu, Jul 5, 2018 at 6:25 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Jul 5, 2018 at 1:17 PM, Keith Busch <keith.busch@intel.com> wrote:
>> This patch will find the max contiguous area to determine the largest
>> namespace size that can be created. If the requested size exceeds the
>> largest available, ENOSPC error will be returned.
>>
>> This fixes the allocation underrun error and wrong error return code
>> that have otherwise been observed as the following kernel warning:
>>
>>   WARNING: CPU: <CPU> PID: <PID> at drivers/nvdimm/namespace_devs.c:913 size_store
>>
>> Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update nd_region_available_dpa() for multi-pmem support")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Keith Busch <keith.busch@intel.com>
>> ---
>> v1 -> v2:
>>
>>   Updated changelog to indicate the warning this patch fixes and copy
>>   stable.
>>
>>   Fixed code comments with the correct name of a function
>>
>>  drivers/nvdimm/dimm_devs.c      | 29 +++++++++++++++++++++++++++++
>>  drivers/nvdimm/namespace_devs.c |  2 +-
>>  drivers/nvdimm/nd-core.h        |  3 +++
>>  drivers/nvdimm/region_devs.c    | 23 +++++++++++++++++++++++
>>  4 files changed, 56 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
>> index 8d348b22ba45..791a93cd8eb1 100644
>> --- a/drivers/nvdimm/dimm_devs.c
>> +++ b/drivers/nvdimm/dimm_devs.c
>> @@ -536,6 +536,35 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
>>         return info.available;
>>  }
>>
>> +/**
>>x + * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
>> + *                             contiguous unallocated dpa range.
>> + * @nd_region: constrain available space check to this reference region
>> + * @nd_mapping: container of dpa-resource-root + labels
>> + */
>> +resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
>> +                                          struct nd_mapping *nd_mapping)
>> +{
>> +       struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +       resource_size_t start, end, max = 0;
>> +       struct resource *res;
>> +
>> +       if (!ndd)
>> +               return 0;
>> +
>> +       start = nd_mapping->start;
>> +       end = start + nd_mapping->size;
>> +
>> +       for_each_dpa_resource(ndd, res) {
>> +               if ((res->start - start) > max)
>> +                       max = res->start - start;
>> +               start = res->start + resource_size(res);
>> +       }
>> +       if (start < end && end - start > max)
>> +               max = end - start;
>> +       return max;
>> +}
>
> So, I liked how simple and straightforward this was, but the unit test
> reminded me how complicated the free space allocation could be given
> that we still might need to account for aliased BLK capacity.
>
> A few things I now notice:
>
> * It is possible for a dpa resource to start before nd_mapping->start
> and/or end after nd_mapping->size. See the diagram in
> tools/testing/nvdimm/test/nfit.c
>
> * We need to be summing the max extents across all DIMMs in the set
> while also accounting for this BLK overlap problem that
> nd_pmem_available_dpa() handles.
>
> The original bug arose from the fact that the
> nd_region_available_dpa() accounts for total busy capacity and the
> allocation path looks for extents. It would be nice to unify those two
> functions... or maybe standardize on scan_allocate() everywhere.

I think you can redo this using reserve_free_pmem() and then find the
largest free space reservation after accounting for blk_max_overlap as
calculated by nd_region_available_dpa().

reserve_free_pmem() inserts resources into the dpa resource tree with
the name "pmem-reserve" then you need to filter those against
blk_max_overlap to find which ones might appear free, but shadowed by
a BLK allocation on one of the DIMMs in the set. Yes, it allocates
memory and is heavy handed, but I'm having a hard time thinking of
something better at the moment.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
