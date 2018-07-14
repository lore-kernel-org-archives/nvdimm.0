Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 498572097FAAE
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 17:34:49 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id b15-v6so65306757oib.10
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 17:34:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180713063125.GA10034@hori1.linux.bs1.fc.nec.co.jp>
References: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153074044986.27838.16910122305490506387.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180713063125.GA10034@hori1.linux.bs1.fc.nec.co.jp>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 17:34:48 -0700
Message-ID: <CAPcyv4j2M4tSKk-mXPaj1sLGCN6qHNh2iaauKwgciRpmqU8cSw@mail.gmail.com>
Subject: Re: [PATCH v5 05/11] mm, madvise_inject_error: Let memory_failure()
 optionally take a page reference
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
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 12, 2018 at 11:31 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> Hello Dan,
>
> On Wed, Jul 04, 2018 at 02:40:49PM -0700, Dan Williams wrote:
>> The madvise_inject_error() routine uses get_user_pages() to lookup the
>> pfn and other information for injected error, but it does not release
>> that pin. The assumption is that failed pages should be taken out of
>> circulation.
>>
>> However, for dax mappings it is not possible to take pages out of
>> circulation since they are 1:1 physically mapped as filesystem blocks,
>> or device-dax capacity. They also typically represent persistent memory
>> which has an error clearing capability.
>>
>> In preparation for adding a special handler for dax mappings, shift the
>> responsibility of taking the page reference to memory_failure(). I.e.
>> drop the page reference and do not specify MF_COUNT_INCREASED to
>> memory_failure().
>>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  mm/madvise.c |   18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 4d3c922ea1a1..b731933dddae 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -631,11 +631,13 @@ static int madvise_inject_error(int behavior,
>>
>>
>>       for (; start < end; start += PAGE_SIZE << order) {
>> +             unsigned long pfn;
>>               int ret;
>>
>>               ret = get_user_pages_fast(start, 1, 0, &page);
>>               if (ret != 1)
>>                       return ret;
>> +             pfn = page_to_pfn(page);
>>
>>               /*
>>                * When soft offlining hugepages, after migrating the page
>> @@ -651,17 +653,27 @@ static int madvise_inject_error(int behavior,
>>
>>               if (behavior == MADV_SOFT_OFFLINE) {
>>                       pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
>> -                                             page_to_pfn(page), start);
>> +                                     pfn, start);
>>
>>                       ret = soft_offline_page(page, MF_COUNT_INCREASED);
>>                       if (ret)
>>                               return ret;
>>                       continue;
>>               }
>> +
>>               pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
>> -                                             page_to_pfn(page), start);
>> +                             pfn, start);
>> +
>> +             ret = memory_failure(pfn, 0);
>> +
>> +             /*
>> +              * Drop the page reference taken by get_user_pages_fast(). In
>> +              * the absence of MF_COUNT_INCREASED the memory_failure()
>> +              * routine is responsible for pinning the page to prevent it
>> +              * from being released back to the page allocator.
>> +              */
>> +             put_page(page);
>>
>> -             ret = memory_failure(page_to_pfn(page), MF_COUNT_INCREASED);
>
> MF_COUNT_INCREASED means that the page refcount for memory error handling
> is taken by the caller so you don't have to take one inside memory_failure().
> So this code don't keep with the definition, then another refcount can be
> taken in memory_failure() in normal LRU page's case for example.
> As a result the error message "Memory failure: %#lx: %s still referenced by
> %d users\n" will be dumped in page_action().
>
> So if you want to put put_page() in madvise_inject_error(), I think that
>
>                 put_page(page);
>                 ret = memory_failure(pfn, 0);
>
> can be acceptable because the purpose of get_user_pages_fast() here is
> just getting pfn, and the refcount itself is not so important.
> IOW, memory_failure() is called only with pfn which never changes depending
> on the page's status.

Ok, I'll resend with the put_page() moved before memory_failure() to
make it more clear that memory_failure() is responsible for taking its
own reference and that there is no dependency to hold the reference in
madvise_inject_error().

> In production system memory_failure() is called via machine check code
> without taking any pagecount, so I don't think the this injection interface
> is properly mocking the real thing. So I'm feeling that this flag will be
> wiped out at some point.

Ok, makes sense.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
