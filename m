Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19715212746D8
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 21:41:55 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4E4VrEL020401
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 00:41:54 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2sfhxushrd-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 00:41:54 -0400
Received: from localhost
 by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Tue, 14 May 2019 05:41:53 +0100
Subject: Re: [PATCH] mm/nvdimm: Use correct alignment when looking at first
 pfn from a region
References: <20190514025512.9670-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hgNUDxjgYNkxOXJ9hfLb6z2+E1yasNoZNDKFUxkCzWLA@mail.gmail.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Tue, 14 May 2019 10:11:47 +0530
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hgNUDxjgYNkxOXJ9hfLb6z2+E1yasNoZNDKFUxkCzWLA@mail.gmail.com>
Content-Language: en-US
Message-Id: <925e41ad-cc57-bc03-a2b6-6913c9e98abf@linux.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 5/14/19 9:59 AM, Dan Williams wrote:
> On Mon, May 13, 2019 at 7:55 PM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:
>>
>> We already add the start_pad to the resource->start but fails to section
>> align the start. This make sure with altmap we compute the right first
>> pfn when start_pad is zero and we are doing an align down of start address.
>>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>   kernel/memremap.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/memremap.c b/kernel/memremap.c
>> index a856cb5ff192..23d77b60e728 100644
>> --- a/kernel/memremap.c
>> +++ b/kernel/memremap.c
>> @@ -59,9 +59,9 @@ static unsigned long pfn_first(struct dev_pagemap *pgmap)
>>   {
>>          const struct resource *res = &pgmap->res;
>>          struct vmem_altmap *altmap = &pgmap->altmap;
>> -       unsigned long pfn;
>> +       unsigned long pfn = PHYS_PFN(res->start);
>>
>> -       pfn = res->start >> PAGE_SHIFT;
>> +       pfn = SECTION_ALIGN_DOWN(pfn);
> 
> This does not seem right to me it breaks the assumptions of where the
> first expected valid pfn occurs in the passed in range.
> 

How do we define the first valid pfn? Isn't that at pfn_sb->dataoff ?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
