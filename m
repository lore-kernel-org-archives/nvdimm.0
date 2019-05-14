Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDFF6212735A2
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 21:05:29 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4E42j6a021280
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 00:05:29 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2sfj48r15r-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 00:05:29 -0400
Received: from localhost
 by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Tue, 14 May 2019 05:05:28 +0100
Subject: Re: [PATCH] mm/nvdimm: Use correct #defines instead of opencoding
References: <20190514025604.9997-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4iNgFbSq0Hqb+CStRhGWMHfXx7tL3vrDaQ95DcBBY8QCQ@mail.gmail.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Tue, 14 May 2019 09:35:21 +0530
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iNgFbSq0Hqb+CStRhGWMHfXx7tL3vrDaQ95DcBBY8QCQ@mail.gmail.com>
Content-Language: en-US
Message-Id: <f99c4f11-a43d-c2d3-ab4f-b7072d090351@linux.ibm.com>
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

On 5/14/19 9:28 AM, Dan Williams wrote:
> On Mon, May 13, 2019 at 7:56 PM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:
>>
>> The nfpn related change is needed to fix the kernel message
>>
>> "number of pfns truncated from 2617344 to 163584"
>>
>> The change makes sure the nfpns stored in the superblock is right value.
>>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>   drivers/nvdimm/pfn_devs.c    | 6 +++---
>>   drivers/nvdimm/region_devs.c | 8 ++++----
>>   2 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>> index 347cab166376..6751ff0296ef 100644
>> --- a/drivers/nvdimm/pfn_devs.c
>> +++ b/drivers/nvdimm/pfn_devs.c
>> @@ -777,8 +777,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>>                   * when populating the vmemmap. This *should* be equal to
>>                   * PMD_SIZE for most architectures.
>>                   */
>> -               offset = ALIGN(start + reserve + 64 * npfns,
>> -                               max(nd_pfn->align, PMD_SIZE)) - start;
>> +               offset = ALIGN(start + reserve + sizeof(struct page) * npfns,
>> +                              max(nd_pfn->align, PMD_SIZE)) - start;
> 
> No, I think we need to record the page-size into the superblock format
> otherwise this breaks in debug builds where the struct-page size is
> extended.
> 
>>          } else if (nd_pfn->mode == PFN_MODE_RAM)
>>                  offset = ALIGN(start + reserve, nd_pfn->align) - start;
>>          else
>> @@ -790,7 +790,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>>                  return -ENXIO;
>>          }
>>
>> -       npfns = (size - offset - start_pad - end_trunc) / SZ_4K;
>> +       npfns = (size - offset - start_pad - end_trunc) / PAGE_SIZE;
> 
> Similar comment, if the page size is variable then the superblock
> needs to explicitly account for it.
> 

PAGE_SIZE is not really variable. What we can run into is the issue you 
mentioned above. The size of struct page can change which means the 
reserved space for keeping vmemmap in device may not be sufficient for 
certain kernel builds.

I was planning to add another patch that fails namespace init if we 
don't have enough space to keep the struct page.

Why do you suggest we need to have PAGE_SIZE as part of pfn superblock?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
