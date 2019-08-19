Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C864C20214B39
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 00:13:28 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7J78P58144417
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 03:11:59 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2ufm44xdqh-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 03:11:59 -0400
Received: from localhost
 by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Mon, 19 Aug 2019 08:11:57 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v5 3/4] mm/nvdimm: Use correct #defines instead of open
 coding
In-Reply-To: <CAPcyv4hc_-oGMp6jGVknnYs+rmj4W1A_gFCbmAX2LFw0hsfL5g@mail.gmail.com>
References: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com>
 <20190809074520.27115-4-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hc_-oGMp6jGVknnYs+rmj4W1A_gFCbmAX2LFw0hsfL5g@mail.gmail.com>
Date: Mon, 19 Aug 2019 12:41:52 +0530
MIME-Version: 1.0
Message-Id: <87v9ut1vev.fsf@linux.ibm.com>
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
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Aug 9, 2019 at 12:45 AM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:
>>
>> Use PAGE_SIZE instead of SZ_4K and sizeof(struct page) instead of 64.
>> If we have a kernel built with different struct page size the previous
>> patch should handle marking the namespace disabled.
>
> Each of these changes carry independent non-overlapping regression
> risk, so lets split them into separate patches. Others might
>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>  drivers/nvdimm/label.c          | 2 +-
>>  drivers/nvdimm/namespace_devs.c | 6 +++---
>>  drivers/nvdimm/pfn_devs.c       | 3 ++-
>>  drivers/nvdimm/region_devs.c    | 8 ++++----
>>  4 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 73e197babc2f..7ee037063be7 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -355,7 +355,7 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
>>
>>         /* check that DPA allocations are page aligned */
>>         if ((__le64_to_cpu(nd_label->dpa)
>> -                               | __le64_to_cpu(nd_label->rawsize)) % SZ_4K)
>> +                               | __le64_to_cpu(nd_label->rawsize)) % PAGE_SIZE)
>
> The UEFI label specification has no concept of PAGE_SIZE, so this
> check is a pure Linux-ism. There's no strict requirement why
> slot_valid() needs to check for page alignment and it would seem to
> actively hurt cross-page-size compatibility, so let's delete the check
> and rely on checksum validation.


Will do a separate patch to drop that check.

>
>>                 return false;
>>
>>         /* check checksum */
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index a16e52251a30..a9c76df12cb9 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -1006,10 +1006,10 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
>>                 return -ENXIO;
>>         }
>>
>> -       div_u64_rem(val, SZ_4K * nd_region->ndr_mappings, &remainder);
>> +       div_u64_rem(val, PAGE_SIZE * nd_region->ndr_mappings, &remainder);
>>         if (remainder) {
>> -               dev_dbg(dev, "%llu is not %dK aligned\n", val,
>> -                               (SZ_4K * nd_region->ndr_mappings) / SZ_1K);
>> +               dev_dbg(dev, "%llu is not %ldK aligned\n", val,
>> +                               (PAGE_SIZE * nd_region->ndr_mappings) / SZ_1K);
>>                 return -EINVAL;
>
> Yes, looks good, but this deserves its own independent patch.
>
>>         }
>>
>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>> index 37e96811c2fc..c1d9be609322 100644
>> --- a/drivers/nvdimm/pfn_devs.c
>> +++ b/drivers/nvdimm/pfn_devs.c
>> @@ -725,7 +725,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>>                  * when populating the vmemmap. This *should* be equal to
>>                  * PMD_SIZE for most architectures.
>>                  */
>> -               offset = ALIGN(start + SZ_8K + 64 * npfns, align) - start;
>> +               offset = ALIGN(start + SZ_8K + sizeof(struct page) * npfns,
>
> I'd prefer if this was not dynamic and was instead set to the maximum
> size of 'struct page' across all archs just to enhance cross-arch
> compatibility. I think that answer is '64'.


That still doesn't take care of the case where we add new elements to
struct page later. If we have struct page size changing across
architectures, we should still be ok as long as new size is less than what is
stored in pfn superblock? I understand the desire to keep it
non-dynamic. But we also need to make sure we don't reserve less space
when creating a new namespace on a config that got struct page size >
64? 


>> +                              align) - start;
>>         } else if (nd_pfn->mode == PFN_MODE_RAM)
>>                 offset = ALIGN(start + SZ_8K, align) - start;
>>         else
>> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
>> index af30cbe7a8ea..20e265a534f8 100644
>> --- a/drivers/nvdimm/region_devs.c
>> +++ b/drivers/nvdimm/region_devs.c
>> @@ -992,10 +992,10 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>>                 struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
>>                 struct nvdimm *nvdimm = mapping->nvdimm;
>>
>> -               if ((mapping->start | mapping->size) % SZ_4K) {
>> -                       dev_err(&nvdimm_bus->dev, "%s: %s mapping%d is not 4K aligned\n",
>> -                                       caller, dev_name(&nvdimm->dev), i);
>> -
>> +               if ((mapping->start | mapping->size) % PAGE_SIZE) {
>> +                       dev_err(&nvdimm_bus->dev,
>> +                               "%s: %s mapping%d is not %ld aligned\n",
>> +                               caller, dev_name(&nvdimm->dev), i, PAGE_SIZE);
>>                         return NULL;
>>                 }
>>
>> --
>> 2.21.0
>>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
