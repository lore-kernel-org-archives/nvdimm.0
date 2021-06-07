Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3397E2FB3
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 21:01:46 +0000 (UTC)
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157Kug0J188931;
	Mon, 7 Jun 2021 21:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WU0HzjcbLXXbDLU6//rpXsTUX9KxSry3F7Yaz4pLE7o=;
 b=cESlvszMrEKHeIfwDUyCXS+WjQ61NuLeOSFOZ+LF64W9/1gm4hAL1CYYQNoP+aKuBAxP
 Q9OhmGidP+5JZFfsQhMIH5/Q/9TwVRK4lNXpdGuq5708gRjGogyGcBSMQaWfe9XIdDgr
 fxe9mkoniTBL8FkKfcX+RlEAxTtw4047W8A/3t/W7Q3DyZhqNEHWYfahFJJf0KTDAU+H
 E10RVMYOysNvNPKonOaeMetYbwMQygj3YOx5dKET7dH4DNJFkdVtFN9LX1EHEE1we9CS
 QLXDqZAgUrqZCbPrULwyUySjIzQFJOoilx1Or49JxWWHouF5QmLLs9dQCjAGUMusFvbp vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 38yxscc6ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 21:01:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157KuJ6H034254;
	Mon, 7 Jun 2021 21:01:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by userp3030.oracle.com with ESMTP id 38yxcu5qhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 21:01:04 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 157KvIFY035596;
	Mon, 7 Jun 2021 21:01:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userp3030.oracle.com with ESMTP id 38yxcu5qh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 21:01:04 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 157L0vKg029165;
	Mon, 7 Jun 2021 21:00:57 GMT
Received: from [192.168.125.214] (/87.196.21.203)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Mon, 07 Jun 2021 21:00:57 +0000
Subject: Re: [PATCH v1 04/11] mm/memremap: add ZONE_DEVICE support for
 compound pages
From: Joao Martins <joao.m.martins@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-5-joao.m.martins@oracle.com>
 <CAPcyv4gs_rHL7FPqyQEb3yT4jrv8Wo_xA2ojKsppoBfmDocq8A@mail.gmail.com>
 <cd1c9849-8660-dbdc-718a-aa4ba5d48c01@oracle.com>
 <CAPcyv4jG8+S6xJyp=1S2=dpit0Hs2+HgGwpWeRROCRuJnQYAxQ@mail.gmail.com>
 <56a3e271-4ef8-ba02-639e-fd7fe7de7e36@oracle.com>
 <8c922a58-c901-1ad9-5d19-1182bd6dea1e@oracle.com>
 <CAPcyv4j_PdzytEeabe95FrUiNVNobdJRvUE9M9j0krKQ1defBg@mail.gmail.com>
 <e22ef769-5eb2-1812-497f-6d069d632cd0@oracle.com>
Message-ID: <f7cb0917-4d22-3418-f1c9-1d569647a2e2@oracle.com>
Date: Mon, 7 Jun 2021 22:00:53 +0100
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e22ef769-5eb2-1812-497f-6d069d632cd0@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: kTOIHJH2643zUyO83qAJ50Bmc_GVACkc
X-Proofpoint-GUID: kTOIHJH2643zUyO83qAJ50Bmc_GVACkc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070141



On 6/7/21 9:47 PM, Joao Martins wrote:
> On 6/7/21 9:17 PM, Dan Williams wrote:
>> On Tue, May 18, 2021 at 10:28 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>
>>> On 5/5/21 11:36 PM, Joao Martins wrote:
>>>> On 5/5/21 11:20 PM, Dan Williams wrote:
>>>>> On Wed, May 5, 2021 at 12:50 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>>> On 5/5/21 7:44 PM, Dan Williams wrote:
>>>>>>> On Thu, Mar 25, 2021 at 4:10 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>>>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>>>>>>> index b46f63dcaed3..bb28d82dda5e 100644
>>>>>>>> --- a/include/linux/memremap.h
>>>>>>>> +++ b/include/linux/memremap.h
>>>>>>>> @@ -114,6 +114,7 @@ struct dev_pagemap {
>>>>>>>>         struct completion done;
>>>>>>>>         enum memory_type type;
>>>>>>>>         unsigned int flags;
>>>>>>>> +       unsigned long align;
>>>>>>>
>>>>>>> I think this wants some kernel-doc above to indicate that non-zero
>>>>>>> means "use compound pages with tail-page dedup" and zero / PAGE_SIZE
>>>>>>> means "use non-compound base pages".
>>>
>>> [...]
>>>
>>>>>>> The non-zero value must be
>>>>>>> PAGE_SIZE, PMD_PAGE_SIZE or PUD_PAGE_SIZE.
>>>>>>> Hmm, maybe it should be an
>>>>>>> enum:
>>>>>>>
>>>>>>> enum devmap_geometry {
>>>>>>>     DEVMAP_PTE,
>>>>>>>     DEVMAP_PMD,
>>>>>>>     DEVMAP_PUD,
>>>>>>> }
>>>>>>>
>>>>>> I suppose a converter between devmap_geometry and page_size would be needed too? And maybe
>>>>>> the whole dax/nvdimm align values change meanwhile (as a followup improvement)?
>>>>>
>>>>> I think it is ok for dax/nvdimm to continue to maintain their align
>>>>> value because it should be ok to have 4MB align if the device really
>>>>> wanted. However, when it goes to map that alignment with
>>>>> memremap_pages() it can pick a mode. For example, it's already the
>>>>> case that dax->align == 1GB is mapped with DEVMAP_PTE today, so
>>>>> they're already separate concepts that can stay separate.
>>>>>
>>>> Gotcha.
>>>
>>> I am reconsidering part of the above. In general, yes, the meaning of devmap @align
>>> represents a slightly different variation of the device @align i.e. how the metadata is
>>> laid out **but** regardless of what kind of page table entries we use vmemmap.
>>>
>>> By using DEVMAP_PTE/PMD/PUD we might end up 1) duplicating what nvdimm/dax already
>>> validates in terms of allowed device @align values (i.e. PAGE_SIZE, PMD_SIZE and PUD_SIZE)
>>> 2) the geometry of metadata is very much tied to the value we pick to @align at namespace
>>> provisioning -- not the "align" we might use at mmap() perhaps that's what you referred
>>> above? -- and 3) the value of geometry actually derives from dax device @align because we
>>> will need to create compound pages representing a page size of @align value.
>>>
>>> Using your example above: you're saying that dax->align == 1G is mapped with DEVMAP_PTEs,
>>> in reality the vmemmap is populated with PMDs/PUDs page tables (depending on what archs
>>> decide to do at vmemmap_populate()) and uses base pages as its metadata regardless of what
>>> device @align. In reality what we want to convey in @geometry is not page table sizes, but
>>> just the page size used for the vmemmap of the dax device.
>>
>> Good point, the names "PTE, PMD, PUD" imply the hardware mapping size,
>> not the software compound page size.
>>
>>> Additionally, limiting its
>>> value might not be desirable... if tomorrow Linux for some arch supports dax/nvdimm
>>> devices with 4M align or 64K align, the value of @geometry will have to reflect the 4M to
>>> create compound pages of order 10 for the said vmemmap.
>>>
>>> I am going to wait until you finish reviewing the remaining four patches of this series,
>>> but maybe this is a simple misnomer (s/align/geometry/) with a comment but without
>>> DEVMAP_{PTE,PMD,PUD} enum part? Or perhaps its own struct with a value and enum a
>>> setter/getter to audit its value? Thoughts?
>>
>> I do see what you mean about the confusion DEVMAP_{PTE,PMD,PUD}
>> introduces, but I still think the device-dax align and the
>> organization of the 'struct page' metadata are distinct concepts. So
>> I'm happy with any color of the bikeshed as long as the 2 concepts are
>> distinct. How about calling it  "compound_page_order"? Open to other
>> ideas...
>>
> I actually like the name of @geometry. The only thing better would be @vmemmap_geometry
> solely because it makes it clear that its the vmemmap that we are talking about -- but
> might be unnecssarily verbose. And I still agree that is separate concept that should be
> named differently *at least*.
> 
> But naming aside, I was trying to get at was to avoid a second geometry value validation
> i.e. to be validated the value and set with a value such as DEVMAP_PTE, DEVMAP_PMD and
> DEVMAP_PUD. 

Sorry my english keeps getting broken, I meant this instead:

But naming aside, what I am trying to get at is to remove the second geometry value
validation i.e. for @geometry to not be validated a second time to be set to DEVMAP_PTE,
DEVMAP_PMD or DEVMAP_PUD.

> That to me sounds a little redundant, when the geometry value depends on what
> align is going to be used from. Here my metnion of @align refers to what's used to create
> the dax device, not the mmap() align [which can be lower than the device one]. The dax
> device align is the one used to decide whether to use PTEs, PMDs or PUDs at dax fault handler.
> 
> So separate concepts, but still its value dependent on one another. At least unless we
> want to allow geometry values different than those set by --align as Jane suggested.
> 

And I should add:

I can maintain the DEVMAP_* enum values, but then these will need to be changed in tandem
anytime a new @align value is supported. Or instead we use the name @geometry albeit with
still as an unsigned long type . Or rather than an unsigned long perhaps making another
type and its value obtained/changed with getter/setter.
