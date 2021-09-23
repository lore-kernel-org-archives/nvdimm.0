Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007613FC8
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 16:51:51 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NG0CYc010863;
	Thu, 23 Sep 2021 16:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DxwB2DvyAYdqth4oW7OJj0hXB32ZuSeEhuZmD7tWdUc=;
 b=ePE7ytUm2VaGe8g0htaqzQmCtJvlOuHpq+1zcX5QSmeBou9Dt4HHPHPpJKyVpJv3ECL7
 bfgloXQH9JbAasHXKjUqL7swbEKI8cKiR+HAXjr6s29SBS7LYY/DJsgYZYXCz6ntAygg
 WdHqL/MQhbGKH+C3r/PN3TRIWDelEm37d+VJUrDm9e7KZ6WymIBPFwTZHmAeMirTX8Cn
 qZOh3ehVCceTLgn9VrFvqd6VwiV4SjZK6AFEG9R1yOc0bmwaF9UtGpReNWDki7NixUnW
 xOD1KywEMKprBd5fUnE779QcFBtrQWNUR2/U0xbzXBCCCRoXJUeVy14tUE8eJTbM3utR Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b8mdbkvgs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Sep 2021 16:51:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18NGitYx157282;
	Thu, 23 Sep 2021 16:51:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
	by aserp3020.oracle.com with ESMTP id 3b7q5cgvf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Sep 2021 16:51:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpEOE4i9TxxoQ2awteBaq/ePHKE+KZ6gWsc/a7kxI22es1pBD6Ska7WHWGJP0pS1fq84FNPy/xqrRCWCpqY3r/bkgiRoCqPA4ViVNY23WXS755AFhgB8Cwf/4fxwOD8xA2jYLRnSFVQ0hYisrDATnxwK5lWk8SYpMJKzClF0L+ojIpg7Geg2hYXdvlBd51M6te6/SBd2C1GF1fWgjJosyj5R6ZbLbvjolwtMgrqq0reH2NwFwWf4Uwz1nBHWmfWZa67NudxX58U38Big2ajMHokdFKTA16/V++JfgnfEqvCX4Zio1thvx18w/0c8dknViQRjSAS4aJIgrjd0QCaFRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DxwB2DvyAYdqth4oW7OJj0hXB32ZuSeEhuZmD7tWdUc=;
 b=MkOKMIf+8UZb7C1PPqgvLy6NWEcSoJleyfOI7NBVAm/47f3BkGYdfrpMzYRVD1we0M532KoK+Vbxl0kSmV2YTDwXkA8eJRnhIKih9p2ZDtKP+Civ819YWBtUJBvQyK1YkOTpz0KOJZVqfiHerGChzam0EKGRwUIoL2rL7cqgnRRBDUbWtMyyt9Kaa+iCm1/efpPgHihZnp6jF7Um9UVR093EfVnE50aZjbpwWOGYLjG9pFRQQY83M8tnC0lsyGzZkZymQccjbI+h1cy0FzfRALq1ROYfefEaczWPaqvVsNzbCJj6GIzT8R6/H1vGHFKnSN3+vjRr01JisDJMO9nytQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxwB2DvyAYdqth4oW7OJj0hXB32ZuSeEhuZmD7tWdUc=;
 b=jPQBitykUroy1VkfOeWgUZN8z4ggX2s0Kphm5fp5sDB1t86ogkYyWlpUsSe1GGzGLRk+o+n9TRnZhHocfd1vWvHZxFq6AVK3CwYgP2npPoDSP+jJEVB/V51DYhSTlDsvLMg2KXR0wCFKGdJ9HdTeRADG0S2JfCOMuAnqJVy7hP0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4368.namprd10.prod.outlook.com (2603:10b6:208:1d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 16:51:13 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::bd25:67f1:655a:a615]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::bd25:67f1:655a:a615%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 16:51:13 +0000
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
To: Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20210827162552.GK1200268@ziepe.ca>
 <da90638d-d97f-bacb-f0fa-01f5fd9f2504@oracle.com>
 <20210830130741.GO1200268@ziepe.ca>
 <cda6d8fb-bd48-a3de-9d4e-96e4a43ebe58@oracle.com>
 <20210831170526.GP1200268@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <8c23586a-eb3b-11a6-e72a-dcc3faad4e96@oracle.com>
Date: Thu, 23 Sep 2021 17:51:04 +0100
In-Reply-To: <20210831170526.GP1200268@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0271.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.173.247] (138.3.204.55) by LO2P265CA0271.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 16:51:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d177857-bdc0-4802-98e4-08d97eb25a03
X-MS-TrafficTypeDiagnostic: MN2PR10MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4368EDD4BF6A154F76882F46BBA39@MN2PR10MB4368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gw5o/I/KNyvVxP7XvPiBwlCN6vYMH82BdJCv6Lkw8QWafrB55fz9qM4EUfofN62Uoqqz2BBc7tVt9KhyuT9dzozHL2iXCre7/5C0x/l/+j9IB48htDAGIf2KSOp4V8c1JDBTnu+xDdONjFCY6Y4CVMBZmLvwQoAcqCc2QTelFTuk6v23d8JeBeq6ElYvbvAOb4tMHQ1CKRstCgb7kKzVq1ACDoyRa5G1ZRW57BuKJOmp5iJSMUfaouot7ov3x9ue8E3xjF3BYFWR1zpzhqfKdjJjBrXFs1kOz0SqJ2zvdlMgwRjgQQMPteMtzqCy04KdKy67s+Wq2O+iqeoCIhTBmSeIA/Ewl+8XeXFRKTQ4wkk5hTX5irguao7vzPilz3oc46dCHZL6HNgn/4zPVafcA2CK0usaIE00kHNEIzncLFDzKonmijp3atr5aq/cQ8QLFqu6Ye+55e/amdOUr/PyDcB6aPVk/IogD8tmultmJJuAweKg0txzOscYpgG4SXgaMdxsGMtQCpZm4ihaj0Is0RCgdOQg1cLX4xzuE8ovlmWQVcte8E0BmwuVPGYY1nybI/dj/5q1oaMGyhNKIVDoIlMzTpNbMMUyTPp1lsZZmXQPJgUYmWW0U0NZxGaULUGKJ26G7pUmmdU0BvxjCMXAzdO9hQV0IMU8PgqMNjVtzeH2i7SSntiRHC/VxSimS1az07cgNxQ2iahn4Q0wkfBV2yR6LjDQ4qbNzRHZ5SZIUcpftFmql94FM8DtUXEFKXbxKwW6UCZAYVKGkXQWFBXJ3g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(7416002)(4326008)(2906002)(316002)(966005)(31696002)(66556008)(26005)(83380400001)(508600001)(6666004)(66476007)(8676002)(66946007)(6486002)(36756003)(8936002)(956004)(2616005)(110136005)(31686004)(186003)(53546011)(38100700002)(54906003)(5660300002)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SThmc05qSzIvN0hEblNvd1NaUFhtbFhSQjJ4d2lCV2lVeThrdytvSTVOdEYr?=
 =?utf-8?B?dWxMeis4SmQ2Y1l4TWU0ZGkzSVdvdjhiVms1SDNrK2FZdjZ1bjZZNkhURHRG?=
 =?utf-8?B?MjZOMy9kT0psVkdUUE8rY3pscVd3YVB0SGZtcnBGaU9pTEt5bGNrME9LdjdJ?=
 =?utf-8?B?SUJxS25BOTFvR1ZJWDVOcmFreDZlb2c2b0sxRVhSK3QyZkpnRWpNaGdyU1Ez?=
 =?utf-8?B?THg1NitoOWpYN2FoMnllYjl4YVE2ZFMrUUQ1NTRpUngxZ2RoWUFhRzBMV0Qw?=
 =?utf-8?B?RkUyaUZZZzhPQXc3OStvNXFiVW5MMzB2MU85aWEwazhad2drYTlDT0dCRkdS?=
 =?utf-8?B?a0FTRkk5UTIvMFhPdDBlQlorbnUrcWRaWlhqeTJwWlRQdGIvM0VVVXNCNkZS?=
 =?utf-8?B?UkppYmNxWDhSV202S1lBeFd0QVoyV0lqUE5tcFJLdnN4ZUVYMUxWYldOODR3?=
 =?utf-8?B?dFQybjBiWW16RzFud2lubkkvWXdWNW1KR3pnRlg0WllZemw2dlZDeEs1aWQ5?=
 =?utf-8?B?aUlYS1JsWU8zZ2l5WnNwUDhjdDcwTjREenhPWHBhQ2NYZS9DbUZqczd5b3M4?=
 =?utf-8?B?RXN1aGVpVW1NQURURVVaY3hNZWZSM1o0NnZRQXVVVGZZOEJuYWhJT1FpbDVa?=
 =?utf-8?B?MFNVZU9sSENkZEdPd01sU3c3SW81bVo1ajhtc3c2Uk5GZUNwazhhNHVzT2pz?=
 =?utf-8?B?UHR0TTFXdjg0UTBhS3d4VGJJcUs5Sk1kNURFNThNRU9NdzFrWFJkektPTGgy?=
 =?utf-8?B?cTdYbC9JUDdzRGZ5ZkFPeUlmMVZKS3RYVVN6U0JzLzhLU0o2SkpnQW9mbGRM?=
 =?utf-8?B?UW1wMHRCb1FTQWZmZDB4M2pHaUl5SWtsbTd3ZVIxbHM2TVlBbzM4bzk4cnNV?=
 =?utf-8?B?enFzL0FmTVJ2SkcyZVg4Q1h5TGQ0eXdnSjJQc0sxNEJXSWFLeXpwSE9JVVVz?=
 =?utf-8?B?RzUrM1Z2S2t5ZS9DcUxndkdWTXg3V1ZZbjZXblZLTnVyL2NuUnA1U0xyWlNt?=
 =?utf-8?B?czE1NExEUjA0YmRiN3JjdEc0eWxTenAxcEFZMXBCRkpCbWpBbzVQZ3h0VHVL?=
 =?utf-8?B?YXNXTC9UczBSaldISlNIR1IwMVVkUDEwaURqSVdpL3I5cnRTZ2Z0bXJSL2JM?=
 =?utf-8?B?bkRDQ2VhczRjM2hPVHN4R1dSeExuSFZWRThuK2lmSTcxRS9hb2lNTDQzVks2?=
 =?utf-8?B?TEE0aTR3TVE0VTlBWkRHT3MwQkRTOXJYSkJEL3p5OHpUQnRib2NiQVJiUmlX?=
 =?utf-8?B?VFllSWdVMi9nMzE4NFlQVzY1d0UvZERxTHVwWnBKYzdjRlJqbXNTajJaOVFW?=
 =?utf-8?B?QUVTMXB2QnUyWVNKdDBMaDJJanczSDRwUTBOck9VVG1TYlVocDJZSWNqWDVV?=
 =?utf-8?B?aWk1R2FVUy9GTDY0RjBOeEc3bmJYT0ZXQ2cwWVpuMXhRa05Wd2txTFVSbiti?=
 =?utf-8?B?UTFXc00rcDlpSFIrZW5QSnVtUlcyVXZZUnpJMGQwRDFWNlBwelZ0bWtYWFlH?=
 =?utf-8?B?TTIyV2hYeDV1OUI3bit2Y0tGVExTZHpxQTN5b2hpZWZVcEkxYXVhbC91bEZz?=
 =?utf-8?B?MHNnRDZTZGs4Ykw4Vm9CUlZNdmdiK1IvNUM3ME80NXg3N1pJNFJXQm4rakZF?=
 =?utf-8?B?bS81RjRxMmlURTl6NUFLdmtXT1duSFhSQVRQUWJFcDZ0Z1A2a3lTV0lmT29E?=
 =?utf-8?B?aDViRzNaVzcrOHFSRVVxZjdzZEJyNkR6Vkh0SVRNYllpbnkrZ2VMbnBKRlJG?=
 =?utf-8?Q?ijsemSowqqp3gb2cjyQYD87xDbH3Kvvy1S3hno+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d177857-bdc0-4802-98e4-08d97eb25a03
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 16:51:13.0553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dd7Ffst1MkgQTg9P02Xx0bgN0Lo0a9hVvZf99/wekkiAKjDQfVziIe6AeGCPMh7izmcpC3ecGJcLWNhMicFgMS1OM8yJpWE79MgcI6AHahg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4368
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109230103
X-Proofpoint-ORIG-GUID: oPl6L-HUGR9yOnikpT04dp9ZVrzE--qJ
X-Proofpoint-GUID: oPl6L-HUGR9yOnikpT04dp9ZVrzE--qJ

On 8/31/21 6:05 PM, Jason Gunthorpe wrote:
> On Tue, Aug 31, 2021 at 01:34:04PM +0100, Joao Martins wrote:
>> On 8/30/21 2:07 PM, Jason Gunthorpe wrote:
>>> On Fri, Aug 27, 2021 at 07:34:54PM +0100, Joao Martins wrote:
>>>> On 8/27/21 5:25 PM, Jason Gunthorpe wrote:
>>>>> On Fri, Aug 27, 2021 at 03:58:13PM +0100, Joao Martins wrote:
>>>>>
>>>>>>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>>>>>>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>>>>>  			     unsigned long end, unsigned int flags,
>>>>>>  			     struct page **pages, int *nr)
>>>>>>  {
>>>>>> -	int nr_start = *nr;
>>>>>> +	int refs, nr_start = *nr;
>>>>>>  	struct dev_pagemap *pgmap = NULL;
>>>>>>  	int ret = 1;
>>>>>>  
>>>>>>  	do {
>>>>>> -		struct page *page = pfn_to_page(pfn);
>>>>>> +		struct page *head, *page = pfn_to_page(pfn);
>>>>>> +		unsigned long next = addr + PAGE_SIZE;
>>>>>>  
>>>>>>  		pgmap = get_dev_pagemap(pfn, pgmap);
>>>>>>  		if (unlikely(!pgmap)) {
>>>>>> @@ -2252,16 +2265,25 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>>>>>  			ret = 0;
>>>>>>  			break;
>>>>>>  		}
>>>>>> -		SetPageReferenced(page);
>>>>>> -		pages[*nr] = page;
>>>>>> -		if (unlikely(!try_grab_page(page, flags))) {
>>>>>> -			undo_dev_pagemap(nr, nr_start, flags, pages);
>>>>>> +
>>>>>> +		head = compound_head(page);
>>>>>> +		/* @end is assumed to be limited at most one compound page */
>>>>>> +		if (PageHead(head))
>>>>>> +			next = end;
>>>>>> +		refs = record_subpages(page, addr, next, pages + *nr);
>>>>>> +
>>>>>> +		SetPageReferenced(head);
>>>>>> +		if (unlikely(!try_grab_compound_head(head, refs, flags))) {
>>>>>> +			if (PageHead(head))
>>>>>> +				ClearPageReferenced(head);
>>>>>> +			else
>>>>>> +				undo_dev_pagemap(nr, nr_start, flags, pages);
>>>>>>  			ret = 0;
>>>>>>  			break;
>>>>>
>>>>> Why is this special cased for devmap?
>>>>>
>>>>> Shouldn't everything processing pud/pmds/etc use the same basic loop
>>>>> that is similar in idea to the 'for_each_compound_head' scheme in
>>>>> unpin_user_pages_dirty_lock()?
>>>>>
>>>>> Doesn't that work for all the special page type cases here?
>>>>
>>>> We are iterating over PFNs to create an array of base pages (regardless of page table
>>>> type), rather than iterating over an array of pages to work on. 
>>>
>>> That is part of it, yes, but the slow bit here is to minimally find
>>> the head pages and do the atomics on them, much like the
>>> unpin_user_pages_dirty_lock()
>>>
>>> I would think this should be designed similar to how things work on
>>> the unpin side.
>>>
>> I don't think it's the same thing. The bit you say 'minimally find the
>> head pages' carries a visible overhead in unpin_user_pages() as we are
>> checking each of the pages belongs to the same head page -- because you
>> can pass an arbritary set of pages. This does have a cost which is not
>> in gup-fast right now AIUI. Whereas in our gup-fast 'handler' you
>> already know that you are processing a contiguous chunk of pages.
>> If anything, we are closer to unpin_user_page_range*()
>> than unpin_user_pages().
> 
> Yes, that is what I mean, it is very similar to the range case as we
> don't even know that a single compound spans a pud/pmd. So you end up
> doing the same loop to find the compound boundaries.
> 
> Under GUP slow we can also aggregate multiple page table entires, eg a
> split huge page could be procesed as a single 2M range operation even
> if it is broken to 4K PTEs.

/me nods

FWIW, I have a follow-up patch pursuing similar optimization (to fix
gup-slow case) that I need to put in better shape -- I probably won't wait
until this series is done contrary to what the cover letter says.

>> Switching to similar iteration logic to unpin would look something like
>> this (still untested):
>>
>>         for_each_compound_range(index, &page, npages, head, refs) {
>>                 pgmap = get_dev_pagemap(pfn + *nr, pgmap);
> 
> I recall talking to DanW about this and we agreed it was unnecessary
> here to hold the pgmap and should be deleted.

Yeap, I remember that conversation[0]. It was a long time ago, and I am
not sure what progress was made there since the last posting? Dan, any
thoughts there?

[0]
https://lore.kernel.org/linux-mm/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com/

So ... if pgmap accounting was removed from gup-fast then this patch
would be a lot simpler and we could perhaps just fallback to the regular
hugepage case (THP, HugeTLB) like your suggestion at the top. See at the
end below scissors mark as the ballpark of changes.

So far my options seem to be: 1) this patch which leverages the existing
iteration logic or 2) switching to for_each_compound_range() -- see my previous
reply 3) waiting for Dan to remove @pgmap accounting in gup-fast and use
something similar to below scissors mark.

What do you think would be the best course of action?

--->8---

++static int __gup_device_compound(unsigned long addr, unsigned long pfn,
++                               unsigned long mask)
++{
++      pfn += ((addr & ~mask) >> PAGE_SHIFT);
++
++      return PageCompound(pfn_to_page(pfn));
++}
++
  static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
                                 unsigned long end, unsigned int flags,
                                 struct page **pages, int *nr)
@@@ -2428,8 -2428,8 +2433,10 @@@ static int gup_huge_pmd(pmd_t orig, pmd
        if (pmd_devmap(orig)) {
                if (unlikely(flags & FOLL_LONGTERM))
                        return 0;
--              return __gup_device_huge_pmd(orig, pmdp, addr, end, flags,
--                                           pages, nr);
++
++              if (!__gup_device_compound(addr, pmd_pfn(orig), PMD_MASK))
++                      return __gup_device_huge_pmd(orig, pmdp, addr, end,
++                                                   flags, pages, nr);
        }

        page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
@@@ -2462,8 -2462,8 +2469,10 @@@ static int gup_huge_pud(pud_t orig, pud
        if (pud_devmap(orig)) {
                if (unlikely(flags & FOLL_LONGTERM))
                        return 0;
--              return __gup_device_huge_pud(orig, pudp, addr, end, flags,
--                                           pages, nr);
++
++              if (!__gup_device_compound(addr, pud_pfn(orig), PUD_MASK))
++                      return __gup_device_huge_pud(orig, pudp, addr, end,
++                                                   flags, pages, nr);
        }

        page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
