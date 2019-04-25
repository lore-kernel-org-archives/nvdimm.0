Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14BEE211F2681
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 18:37:21 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x3P1TvHL147350
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 21:37:20 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2s337krbdv-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 21:37:20 -0400
Received: from localhost
 by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Thu, 25 Apr 2019 02:37:19 +0100
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hzRj5yxVJ5-7AZgzzBxEL02xf2xwhDv-U9_osWFm9kiA@mail.gmail.com>
 <20190424173833.GE19031@bombadil.infradead.org>
 <CAPcyv4gLGUa69svQnwjvruALZ0ChqUJZHQJ1Mt_Cjr1Jh_6vbQ@mail.gmail.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Thu, 25 Apr 2019 07:07:12 +0530
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gLGUa69svQnwjvruALZ0ChqUJZHQJ1Mt_Cjr1Jh_6vbQ@mail.gmail.com>
Content-Language: en-US
Message-Id: <444ca26b-ec38-ae4b-512b-7e915c575098@linux.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Chandan Rajendra <chandan@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On 4/24/19 11:43 PM, Dan Williams wrote:
> On Wed, Apr 24, 2019 at 10:38 AM Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Wed, Apr 24, 2019 at 10:13:15AM -0700, Dan Williams wrote:
>>> I think unaligned addresses have always been passed to
>>> vmf_insert_pfn_pmd(), but nothing cared until this patch. I *think*
>>> the only change needed is the following, thoughts?
>>>
>>> diff --git a/fs/dax.c b/fs/dax.c
>>> index ca0671d55aa6..82aee9a87efa 100644
>>> --- a/fs/dax.c
>>> +++ b/fs/dax.c
>>> @@ -1560,7 +1560,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct
>>> vm_fault *vmf, pfn_t *pfnp,
>>>                  }
>>>
>>>                  trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
>>> -               result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
>>> +               result = vmf_insert_pfn_pmd(vma, pmd_addr, vmf->pmd, pfn,
>>>                                              write);
>>
>> We also call vmf_insert_pfn_pmd() in dax_insert_pfn_mkwrite() -- does
>> that need to change too?
> 
> It wasn't clear to me that it was a problem. I think that one already
> happens to be pmd-aligned.
> 

How about vmf_insert_pfn_pud()?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
