Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB66329CA
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 13:59:52 +0000 (UTC)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157Ds6p6142241;
	Mon, 7 Jun 2021 13:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eeN/3oi7ZtVs7wgXSHdn7Al6EvA/b6rm5GzUHyw4KfA=;
 b=iwpqSW18wtI5Gloy6Br9lF8usluyZFUSLIjLy9FbqQn0b/DK0JF5JOyFOUcI/klUFvdY
 wjvfYdPdK89wsvR/WVJDb7gOC1zuSH6Rk78ktyNGxy5TuDvCcpB/at4Vb8pBffgf8IcW
 RAvFr8Fs1s7C7hwP7QbomCW22EtofGo36yt35YM64p5Yhna1ZWp36ZrJU4ZHieJZtYFg
 6ufPTWL2XT+e9MG+KVL0tD8VchdyzOXOhDgVyeMFY8crltnHf3OjI3zbRmHw7W6yuDSz
 GX+xWFd51FWSKS72JKCYBBcCa/0oVLJkhjAth6Qo42nX8Eiw8GZOze/tq0el4EM8RRu2 zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 3914quhn2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 13:59:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157DuINV022436;
	Mon, 7 Jun 2021 13:59:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
	by userp3030.oracle.com with ESMTP id 38yxctvdt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 13:59:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cp0Pe5KxFqQKbMDmQocAFC4wTIShKLVhGsV9FAHxltL4iKFnATamqX0HZbVLWmR5V9WMjxg7NmiZGU9cD1yzKMLqV7QSHd3WpqMG0ia1Z6q4EGkN06vEciIXVtphF7jsAd803SmhkILFXXnFdKdIYO5tYg+I7lzfHXcxCcPSFKqEMLLAUV2ltajRJtTahwnDk2EzvOhK5VorvEekfCu8YkDFzMFuUYRgd7hs+JBwU4Iae4SRNbw0qK8c1s5Lhlh9rw93i8kFhd6nLyJebYROBrPQcyhcR4JIE794AmKOOr5v+j/UdayipOVJHJKR2e+IngZct+NuQpJ+cLAFpePqMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeN/3oi7ZtVs7wgXSHdn7Al6EvA/b6rm5GzUHyw4KfA=;
 b=DXYD4HG+z8Uij6xNckHb9G9qvBvR3WLPZ5XqX8i7C9Z+Tai++jhFkY4jBQPQZ57vAB/T/RVf6V2RE0IAlk85xgXxP7WuXX7tPxa4groA2WlVkdV8OZcNVB0rOt5UJ7lPA0rmvSsd7hi524y48zheHnMHf6p9D9RTS1oeI3HCfdZdMn57haSeq6rWn/MGnM5t9OL7MTyKYYtV6BIWRUZ8lWRM7jOtwmHP7HLW6VFVQBmJ3okERm1zedXzrsmEWp2DaypTgF4XIAY0qq4JytojAzUFPA4cSlLwLlrwmZisWuIdG2A3Vsyw+1DTR05P9wskhm19Lq7zXjVxNqOOqgRu4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeN/3oi7ZtVs7wgXSHdn7Al6EvA/b6rm5GzUHyw4KfA=;
 b=MI9a95GHhVc2UkRfesW+LQIEE/bixlfR58KiJjfVuW9XDU5aTrU+yFLjcBDsxirUAbYeG8HDbC99rmYiqA9BnCEKCT2oWrUkQSy8CPd3JJcomSZELGN7a5xfzVUQc2toBxL/Dmo9KASzC5Vn46/9t7dvhOOVyRkP1IAvXSluEXY=
Authentication-Results: lists.linux.dev; dkim=none (message not signed)
 header.d=none;lists.linux.dev; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5060.namprd10.prod.outlook.com (2603:10b6:208:333::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 13:59:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8cb1:7649:3a52:236a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8cb1:7649:3a52:236a%7]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 13:59:41 +0000
Subject: Re: [PATCH v1 10/11] device-dax: compound pagemap support
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-11-joao.m.martins@oracle.com>
 <CAPcyv4jeY0K7ciWeCLjxXmiWs7NNeM-_zEdZ2XAdYnyZc9PvWA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <9191a120-2728-51f7-a57e-e16644f33bc1@oracle.com>
Date: Mon, 7 Jun 2021 14:59:35 +0100
In-Reply-To: <CAPcyv4jeY0K7ciWeCLjxXmiWs7NNeM-_zEdZ2XAdYnyZc9PvWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.196.21.203]
X-ClientProxiedBy: LO2P123CA0003.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.125.214] (87.196.21.203) by LO2P123CA0003.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:a6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 13:59:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f13e468-b7bd-433b-8fcb-08d929bc7f13
X-MS-TrafficTypeDiagnostic: BLAPR10MB5060:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5060FCB463D058014502C924BB389@BLAPR10MB5060.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3ej3XZBMB2zUREHS6x8L0FWPbgIH6FRlMn1S/tORUsNv4o2aCh6/CI/zRDMRstKmnI8ILzlrQkBnmCguyR7/gnWGNwq6ptsoGnfAK5M7Tb2AOyOA0lsjDypVew33HWBxgYfuO990By9gQ+rm4dVJKlrPSFa/Aw6hr1HnoMTCdSfu9Qo7ZdAB8Hjb7jfIDUBpSQHs6jYQlH69+W/YaOOFewAsT8ue4SoL1EWanmk0MJPH+HoQQ13ZHwKtfz7y6DOOetfTVf31lrxdrh/PBKPjJA9ftGBsNqS2ukjPfVIwJh888WpB8cpp9qLJXGwyDAvX1guePGz7EZbzYUI4KwkMMEMUwYbs3yfkV4YtAF207vZ98gSpW9OxSzP9+Q2hGQkawclutG4/yF/mpdJ/UjGDuV20otI71f4Y8ZomP03n+sJyleaTZ0i1wUaHf+stZzYNtjTJiVG+w84dkkhtf2mR0aOg7LfHYXRWNNIBUwNdjUR9YIznEvk7MVXiVbJH8dPjvOJDwHDfKIvsffi4krzyojjujRi255Z50tXLd7BstcnuZ1NEQQVChSopyK2vPZCJPvsdulr19+bYezXsc2SYp2ODR4ChxYDmU5BmbylmegBjgolKVWlfCLQb//C35EGQU7VRJLRliqTzi8H30C2OBS/IFG5oYp4IELCafl09kuM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(346002)(376002)(136003)(6916009)(53546011)(8676002)(8936002)(66476007)(478600001)(31696002)(2906002)(31686004)(26005)(38100700002)(186003)(16526019)(4326008)(16576012)(6666004)(316002)(83380400001)(956004)(2616005)(36756003)(54906003)(66946007)(86362001)(66556008)(6486002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 
	=?utf-8?B?RGpUbFAzd0xIRGM2UDZDUzVtek92ZW1aanlwM0ZyRkc4THRtcXM3OThtcDdr?=
 =?utf-8?B?dWlmQmd6eW9lNGZXWFJKdW51TzloNTdIVVd3cWpJb1pOdzhuQTdEZzBpTldQ?=
 =?utf-8?B?VkNvWmxhU01XRUlESFBqejBLWU9qc0xHQ2d1cUVTQnFWeVhQam5veFBqdU1M?=
 =?utf-8?B?ekM2eW9DRXVxcDhDL2o1cXZ6dkFqZVZ2c0xHamFRQytRVDdZanQwODhVOG9H?=
 =?utf-8?B?cS9VYnJYSFZ3OHVtWjFMYUZ1ek5zakxRU3VsYk1oZGRSanF6TVB5M0dackpw?=
 =?utf-8?B?SVR4S09xQmZSL0tJdXBXd2RsTWtYV0ZZVGxUM1N1ZGh3TzBEUlA4U0dHQ3Np?=
 =?utf-8?B?YmZxQUk4Y21yRjZCakJxSDZmUERhVjBZcVJHMVJkZXQ5Vk1LTEhUYnpJM3FW?=
 =?utf-8?B?bjU3djBEdTBFenNza3lKKzRvcDBqcmxtL0w5SmwxSEoySlI0TFFEUGdyNlEz?=
 =?utf-8?B?QkFIRGQxNllQc0tZTitIdnhHTktqU3B1eU1PQlN5bXhybU5NNlFUaVJSUmtv?=
 =?utf-8?B?U096Q2YxQWxydlFPZ3ZXZ0RXK1lvTGMwL3NLbGR2M0t0ZGEvUU85dVpjSkcz?=
 =?utf-8?B?a01QUVNKTWJDd0V1M0lWTFZCQzZGa21pRDFHVGphRDFqaWEzY0Z0dE0xcEZK?=
 =?utf-8?B?bmtxK2dHQTQ4WWdLS3E3L01VZVNKb1EvWWU5NzFvRU1VMWZYTjUwcmlzQUQr?=
 =?utf-8?B?SHhmYnpvR2NZOUk5ak1BNVcvVmJma3VGaWFneVlQcktJbFpBUVE5ckJtUnhD?=
 =?utf-8?B?YnkyRzJ4WFVkaGNBTmlXM0poYjNlaG9TcytRY3J5Z2hNK1dLUkpabHBuN20v?=
 =?utf-8?B?cVZIbGZtQ3BDbW1aMHZuWVZsQWJ5NXBhSit6SlFCL3RiZ0Q5c0xaZGRjc2RR?=
 =?utf-8?B?U1NjcmJrOVJmc3pZcEVyWE9ZbjBKVkJEbnZIdFFENVZIUTg4ajc3RlJMUUNU?=
 =?utf-8?B?VFZuWmNHcWMxNENML3pENHNVemlQT3Y2NmxBTXBvN1c4NDM0WkdpbitZTS8z?=
 =?utf-8?B?dkprNnNPUlIxd1l3KzFPVW5ZZjZWTG5iNFExelBsMFdFTGNacnNwWEU2bFFI?=
 =?utf-8?B?Szl0QWxoOG1hSVIrbys2UlptZXpJVmF4UEIrNWN5dGNXaFBXVjhQSWxMN1g5?=
 =?utf-8?B?dmYxeTJDUVI2ZjcwL1BDYWF4eXRrWVNlSEJsWjV4S1JuUjlNWXpXZG9BZkRk?=
 =?utf-8?B?MkZFVlg4Qmd1Rm9UZDV6QUEwT1dxOHFiaEpxbTBzTkNEN2VwaXg3bndCVkZD?=
 =?utf-8?B?c1ZmM3hmSTJZYkdrdVUyVmNuYmFia0ZsNHk5ZWIwdFJ6d1pYRzlVRWNaSlIz?=
 =?utf-8?B?cktsSWhVRjhBMDFueVJSeDA4Mlc2VVN0czl1MFFnMzcwbmpQV3c4WldPZXll?=
 =?utf-8?B?RW9qcmp3MVRobDJwZ3dDWTlKdmdIT2ZTSU1hczh5U2Q2UGM4TUhzcXJuZUJL?=
 =?utf-8?B?Q0w0QmJUMmFLaUh2bTNJK256NHlxbUpoNDk2S29jN2diOEpLcXhNTnlyNFc2?=
 =?utf-8?B?SUxjRlZ2c1JLQ09jbUF1eXk2YlRyazVZekdBTksvczh3VmdZSTVZNmZOR2J4?=
 =?utf-8?B?MTREeHdKY3JyWXIzRkJIbGUwUFJHMXU1V2ZDeGZDd1I1UDVUMFpYQ0hJdWJW?=
 =?utf-8?B?TnIxVy9YbVpETENOcG1zNHJnOFowMjdURG40ZU84NXF2UVJoZG4xTzFVcWpq?=
 =?utf-8?B?d21lZk9rYVplMTZrd29MdnJKcVYvQ2c0RkQySFhoYStZL2NVNlE5MWcxNTJQ?=
 =?utf-8?Q?8JqXQ9LYSRkriFPldGIUahM61A3CXELNhMionmc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f13e468-b7bd-433b-8fcb-08d929bc7f13
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 13:59:41.3618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BegjKm29aw0/Sn4oKpkoFHCjpb4RNViRgRDySQek4wsZJBTHbA/aUtQ263RugxfRMuP4U5ZqyL2GH6UcZtls7UYfsLS6w4PMYIbsP+sREOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5060
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070103
X-Proofpoint-ORIG-GUID: xct0jbjr8zvsyrwlOu1MjxoaBAr_f9v7
X-Proofpoint-GUID: xct0jbjr8zvsyrwlOu1MjxoaBAr_f9v7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070103



On 6/2/21 1:36 AM, Dan Williams wrote:
> On Thu, Mar 25, 2021 at 4:10 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> dax devices are created with a fixed @align (huge page size) which
>> is enforced through as well at mmap() of the device. Faults,
>> consequently happen too at the specified @align specified at the
>> creation, and those don't change through out dax device lifetime.
>> MCEs poisons a whole dax huge page, as well as splits occurring at
>> at the configured page size.
> 
> This paragraph last...
> 
/me nods

>>
>> Use the newly added compound pagemap facility which maps the
>> assigned dax ranges as compound pages at a page size of @align.
>> Currently, this means, that region/namespace bootstrap would take
>> considerably less, given that you would initialize considerably less
>> pages.
> 
> This paragraph should go first...
> 
/me nods

>>
>> On setups with 128G NVDIMMs the initialization with DRAM stored struct pages
>> improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less than
>> a 1msec with 1G pages.
> 
> This paragraph second...
> 
/me nods

> 
> The reason for this ordering is to have increasingly more detail as
> the changelog is read so that people that don't care about the details
> can get the main theme immediately, and others that wonder why
> device-dax is able to support this can read deeper.
> 
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/dax/device.c | 58 ++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 45 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index db92573c94e8..e3dcc4ad1727 100644
>> --- a/drivers/dax/device.c
>> +++ b/drivers/dax/device.c
>> @@ -192,6 +192,43 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>>  }
>>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>
>> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
>> +                            unsigned long fault_size,
>> +                            struct address_space *f_mapping)
>> +{
>> +       unsigned long i;
>> +       pgoff_t pgoff;
>> +
>> +       pgoff = linear_page_index(vmf->vma, vmf->address
>> +                       & ~(fault_size - 1));
> 
> I know you are just copying this style from whomever wrote it this way
> originally, but that person (me) was wrong this should be:
> 
> pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
> 
> ...you might do a lead-in cleanup patch before this one.
> 
Yeap, will do.

> 
>> +
>> +       for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>> +               struct page *page;
>> +
>> +               page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
>> +               if (page->mapping)
>> +                       continue;
>> +               page->mapping = f_mapping;
>> +               page->index = pgoff + i;
>> +       }
>> +}
>> +
>> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
>> +                                unsigned long fault_size,
>> +                                struct address_space *f_mapping)
>> +{
>> +       struct page *head;
>> +
>> +       head = pfn_to_page(pfn_t_to_pfn(pfn));
>> +       head = compound_head(head);
>> +       if (head->mapping)
>> +               return;
>> +
>> +       head->mapping = f_mapping;
>> +       head->index = linear_page_index(vmf->vma, vmf->address
>> +                       & ~(fault_size - 1));
>> +}
>> +
>>  static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>>                 enum page_entry_size pe_size)
>>  {
>> @@ -225,8 +262,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>>         }
>>
>>         if (rc == VM_FAULT_NOPAGE) {
>> -               unsigned long i;
>> -               pgoff_t pgoff;
>> +               struct dev_pagemap *pgmap = pfn_t_to_page(pfn)->pgmap;
> 
> The device should already know its pagemap...
> 
> There is a distinction in dev_dax_probe() for "static" vs "dynamic"
> pgmap, but once the pgmap is allocated it should be fine to assign it
> back to dev_dax->pgmap in the "dynamic" case. That could be a lead-in
> patch to make dev_dax->pgmap always valid.
> 
I suppose you mean to always set dev_dax->pgmap at the end of the
'if (!pgmap)' in dev_dax_probe() after we allocate the pgmap.

I will make this a separate cleanup patch as you suggested.

>>
>>                 /*
>>                  * In the device-dax case the only possibility for a
>> @@ -234,17 +270,10 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>>                  * mapped. No need to consider the zero page, or racing
>>                  * conflicting mappings.
>>                  */
>> -               pgoff = linear_page_index(vmf->vma, vmf->address
>> -                               & ~(fault_size - 1));
>> -               for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>> -                       struct page *page;
>> -
>> -                       page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
>> -                       if (page->mapping)
>> -                               continue;
>> -                       page->mapping = filp->f_mapping;
>> -                       page->index = pgoff + i;
>> -               }
>> +               if (pgmap->align > PAGE_SIZE)
>> +                       set_compound_mapping(vmf, pfn, fault_size, filp->f_mapping);
>> +               else
>> +                       set_page_mapping(vmf, pfn, fault_size, filp->f_mapping);
>>         }
>>         dax_read_unlock(id);
>>
>> @@ -426,6 +455,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>>         }
>>
>>         pgmap->type = MEMORY_DEVICE_GENERIC;
>> +       if (dev_dax->align > PAGE_SIZE)
>> +               pgmap->align = dev_dax->align;
> 
> Just needs updates for whatever renames you do for the "compound
> geometry" terminology rather than subtle side effects of "align".
> 
> Other than that, looks good to me.
> 
OK, will do.

Thanks!
