Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AABC72129EB8F
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 09:35:57 -0700 (PDT)
Subject: Re: [PATCH v10 08/13] mm/sparsemem: Prepare for sub-section ranges
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156092353780.979959.9713046515562743194.stgit@dwillia2-desk3.amr.corp.intel.com>
 <70f3559b-2832-67eb-0715-ed9f856f6ed9@redhat.com>
 <CAPcyv4jzELzrf-p6ujUwdXN2FRe0WCNhpTziP2-z4-8uBSSp7A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <d62e1f2f-70db-da84-5cc3-01fab779aeb7@redhat.com>
Date: Thu, 20 Jun 2019 18:35:54 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jzELzrf-p6ujUwdXN2FRe0WCNhpTziP2-z4-8uBSSp7A@mail.gmail.com>
Content-Language: en-US
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
Cc: Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On 20.06.19 18:19, Dan Williams wrote:
> On Thu, Jun 20, 2019 at 3:31 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 19.06.19 07:52, Dan Williams wrote:
>>> Prepare the memory hot-{add,remove} paths for handling sub-section
>>> ranges by plumbing the starting page frame and number of pages being
>>> handled through arch_{add,remove}_memory() to
>>> sparse_{add,remove}_one_section().
>>>
>>> This is simply plumbing, small cleanups, and some identifier renames. No
>>> intended functional changes.
>>>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: Logan Gunthorpe <logang@deltatee.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>>  include/linux/memory_hotplug.h |    5 +-
>>>  mm/memory_hotplug.c            |  114 +++++++++++++++++++++++++---------------
>>>  mm/sparse.c                    |   16 ++----
>>>  3 files changed, 81 insertions(+), 54 deletions(-)
> [..]
>>> @@ -528,31 +556,31 @@ static void __remove_section(struct zone *zone, struct mem_section *ms,
>>>   * sure that pages are marked reserved and zones are adjust properly by
>>>   * calling offline_pages().
>>>   */
>>> -void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
>>> +void __remove_pages(struct zone *zone, unsigned long pfn,
>>>                   unsigned long nr_pages, struct vmem_altmap *altmap)
>>>  {
>>> -     unsigned long i;
>>>       unsigned long map_offset = 0;
>>> -     int sections_to_remove;
>>> +     int i, start_sec, end_sec;
>>
>> As mentioned in v9, use "unsigned long" for start_sec and end_sec please.
> 
> Honestly I saw you and Andrew going back and forth about "unsigned
> long i" that I thought this would be handled by a follow on patchset
> when that debate settled.
> 

I'll send a fixup then, once this patch set is final - hoping I won't
forget about it (that's why I asked about using these types in the first
place).

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
