Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74F7D21157FC2
 for <linux-nvdimm@lists.01.org>; Mon, 27 May 2019 02:35:48 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4R9TfC1017744
 for <linux-nvdimm@lists.01.org>; Mon, 27 May 2019 05:35:47 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2srbcwxj8m-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 27 May 2019 05:35:47 -0400
Received: from localhost
 by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Mon, 27 May 2019 10:35:45 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] mm/nvdimm: Use correct alignment when looking at first
 pfn from a region
In-Reply-To: <925e41ad-cc57-bc03-a2b6-6913c9e98abf@linux.ibm.com>
References: <20190514025512.9670-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hgNUDxjgYNkxOXJ9hfLb6z2+E1yasNoZNDKFUxkCzWLA@mail.gmail.com>
 <925e41ad-cc57-bc03-a2b6-6913c9e98abf@linux.ibm.com>
Date: Mon, 27 May 2019 15:05:40 +0530
MIME-Version: 1.0
Message-Id: <87k1ecutn7.fsf@linux.ibm.com>
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

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> On 5/14/19 9:59 AM, Dan Williams wrote:
>> On Mon, May 13, 2019 at 7:55 PM Aneesh Kumar K.V
>> <aneesh.kumar@linux.ibm.com> wrote:
>>>
>>> We already add the start_pad to the resource->start but fails to section
>>> align the start. This make sure with altmap we compute the right first
>>> pfn when start_pad is zero and we are doing an align down of start address.
>>>
>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>>> ---
>>>   kernel/memremap.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/memremap.c b/kernel/memremap.c
>>> index a856cb5ff192..23d77b60e728 100644
>>> --- a/kernel/memremap.c
>>> +++ b/kernel/memremap.c
>>> @@ -59,9 +59,9 @@ static unsigned long pfn_first(struct dev_pagemap *pgmap)
>>>   {
>>>          const struct resource *res = &pgmap->res;
>>>          struct vmem_altmap *altmap = &pgmap->altmap;
>>> -       unsigned long pfn;
>>> +       unsigned long pfn = PHYS_PFN(res->start);
>>>
>>> -       pfn = res->start >> PAGE_SHIFT;
>>> +       pfn = SECTION_ALIGN_DOWN(pfn);
>> 
>> This does not seem right to me it breaks the assumptions of where the
>> first expected valid pfn occurs in the passed in range.
>> 
>
> How do we define the first valid pfn? Isn't that at pfn_sb->dataoff ?

for altmap the pfn_first should be

pfn_first = altmap->base_pfn + vmem_altmap_offset(altmap);

?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
