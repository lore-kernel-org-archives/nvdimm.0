Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F7870
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 01:11:33 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1BJTO013881;
	Tue, 13 Jul 2021 01:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TRZrMH6MD6mVZ6bZzKNhdtYuEvuzDzlEjC70CM2KTg0=;
 b=PcxHvxwWhxa7pgtbVxyLeOEkbdXx/DIzdbwbUtlLXYZ7ps3qHNTLpGOSgI+ARAcYXbKc
 xAJYvr7ISAP6OaBM3iH0JEj6nE4lLTIwh9ojN+PwTJIJsR8QA32mWluZQsZX6I2EFIuW
 xpTYaWiZjgOwFnB+qk+eeMeYT8xa+LWYKJhjMqoLhOOS0YrVVGZU2+4D0Lh9t8C2x8CO
 1AjT1yJN986hg5ITf6OyNRw6mWk0HRDkwrRstL2pvCeO8hsdTFWudJODf0Epog20JNj6
 8LgJPANlXsBhjlSbA60krW0gq1myA+/p9eOZ5MWfKMMDCCdmzFl2TF9qfmjkFj/IbsOX GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rpxr98c8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 01:11:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D16SFs178694;
	Tue, 13 Jul 2021 01:11:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
	by userp3030.oracle.com with ESMTP id 39q0p26yu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 01:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IA73xCI8bD1VI8XYwyG43KHpPrmU2ZNs6dCRrEOIppkz/m5jID34SSMq0FNxhTXJJtlXKxXBSJ/oN6EnzrLfr8/VYYZJkfSjIwQnacOFKjR5haniyRexugSt8kRY2f5XbqrJWwPwN/SKakaMD4OHY7mHsipg0A3ZxNAKpfLWJxtr6+OxQybVqpuCOe+VQNgXZoX46pqVxJSKJ2Rtd7lD9hfHuWEFGaXCFFmoa0MSdf/6YeI2QsgLupiXrqnZuPZINXggD08qI+sYzztI5FqeFN6SC4rgKluik/aa12Uje316f3xnhl2LtPpdRAJVR2nuXeiyLtgCqLMgQaBykJycig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRZrMH6MD6mVZ6bZzKNhdtYuEvuzDzlEjC70CM2KTg0=;
 b=npUnirRpaemDKwbKuREEcsBSkm5pTFWir7oRZV1sRvxXDyhVS4nITJ96D172qEVR5FIjfTY6wqo0aSJYC/opA6G6ZSOO2AUAeqgVG0UM5XLSfSJuadPHmv3Nc/+rvQ1L+iqT8zFDbeKDurECbGcamEYFhGjpVPZZapl4hvC2igprddmgbVcxGDiuiY1RLToCGN1g4PWtG9ZbpWwiU9VmqpXUVYyltGB+AyohYZqNWSRFut24GuxDjD3vI/62UE6Zw9l+Q3Nd/ITDgBMTvYlc+amsajM3xvk8oaasMg5OwfaX8vtPoYpu23KHC7d0mcKOUPEeZJCUiA1fxRb8ZrJ4fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRZrMH6MD6mVZ6bZzKNhdtYuEvuzDzlEjC70CM2KTg0=;
 b=G0pBx793t5dRhf4CzEokhb8JpiNlBd9VWoh1JbTp73Jh/i+D7NCtdcSiWpvnPh0eYfoZLhYLjVqI78CgJxjTnT7cGPTm8hFUIyvIIocn3C2Vycukj4x7VqSRXjPgTzzJkt+C/4MrpWG8g2YZInvyR+elzItECjZMLyUnWF/HY3w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4013.namprd10.prod.outlook.com (2603:10b6:208:185::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 01:11:14 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:11:14 +0000
Subject: Re: [PATCH v2 02/14] mm/page_alloc: split prep_compound_page into
 head and tail subparts
To: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
 <20210617184507.3662-3-joao.m.martins@oracle.com>
 <caa531ab-3a87-fdb2-6498-34349f66e475@oracle.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <eade29c5-14df-3afd-7dfe-fe17c512a6e3@oracle.com>
Date: Tue, 13 Jul 2021 02:11:08 +0100
In-Reply-To: <caa531ab-3a87-fdb2-6498-34349f66e475@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::11) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO3P265CA0006.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 13 Jul 2021 01:11:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea22d2cc-4300-482e-da5e-08d9459b1bee
X-MS-TrafficTypeDiagnostic: MN2PR10MB4013:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB401322C9ED050C06E3C752DABB149@MN2PR10MB4013.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	f6y72t3/aWIqglNaMZvp2W4rTOdzVTi566nSJdK2B9MDV9MqFHo157oixtK6UoN1l8U+p1wThY6onECt0nNnr1CAmlCYDL1KXcBcFpKUbyA8/RnvZITIyWVLK62k0lDwU60FXJbrwScX6O0hWH+bnxKfv1ryUDHhTqnxk4TBbCUlghYq+Ubd2u0QFYz/2CxxBr2k2A2GdUBqOYqtw2F7RQrWQsvNYASvutRqitA6xVvhAvdwtMO/yFjM1TYPnlpP2SZRaGUJiYBPqi5dicH1A83ys1aN8k+mTfHFA/8yXUFqfeQG54r6iXeqODbTX2v1OJiRUK56DDjdUxKwSfsYTUCud02G0jXbAl4inp5AVxMLqv8S6V2QlwH6grwgSZSMxGpFyMXNYy1YEnXXcFrcJWv4F0D6W0yT3D8IvqticxrKjxhk1Hp5vLXuFbqZpmACqJLPGrO3sIrVVjyzE+uonPDdmzxvwPY+s0yTelxpgmS5Qjur3gd4VnjE+SS2Qcz8/pebjZzMtlQU+3p7gGzJifhG4G0YfHK2UJF+zVg+etVNDWJMUJFRBsMDQAgQ/uX9EHZuBzuy/zpG9cj4Cg5z2+nSjvQZS9I4GlOjzFO8Kbtw05qVLuJ89UQKwpTY0olizrfLmIMAjqjY0/2vGIc7DJXRsJRL0UzoBkNAeNCRwZnG8JXb0r/TriFzC9ryjzhUAVUsl4lhBW03ZZpuF58b5w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(346002)(396003)(83380400001)(31686004)(8936002)(66476007)(66556008)(38100700002)(6486002)(2616005)(36756003)(66946007)(956004)(8676002)(4326008)(54906003)(478600001)(53546011)(26005)(186003)(16576012)(316002)(7416002)(31696002)(2906002)(6666004)(86362001)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V1N3NmFJMWdOWU5Bd3lDNWw2Q2FQZ3R4MDNDVzdxV3VPTjZMUm1BRFNkdWVV?=
 =?utf-8?B?UzAvbmtSaXJ0TTVsWXVONDNBbkowNDd5S05RZEUwY3RvYzVKMkxKY1JrY1J0?=
 =?utf-8?B?Q2hSU1h4MzJyMEg0L1M0KzcxbGxteE4zaDZRRUJ3dHU5bCs2ai9iRW9haDlr?=
 =?utf-8?B?eUFlbGI1WUhTbDJ3SkZpcGJxK3gvWU1iSXVNWVoyelBQUlZPS2IvSThScEdB?=
 =?utf-8?B?eHNXRVBzeTREL3VEVTZqZjBNM1hUZWxPU3hKNytkbWwvdjlYT2QrbGpNeWZP?=
 =?utf-8?B?TE1JWloxMjgxSmxqUTB3R2VuMFZiYkMrSDdZTUEvTDhiVmJrbE9OQ0pkdUNh?=
 =?utf-8?B?V1JhQ0g5clROMUpFNjJHMk5BekVrdHUwdHllN3VSMGZKMWh2RE1ONDNqZ1Jy?=
 =?utf-8?B?WTBUSVA2TW1DMDJoRlRuaHU4T1J5SjZmUUJhYklTOFpQL0Y5ZEFaYld0N0d0?=
 =?utf-8?B?K1UxS2tidGVWa0RNU3BJSXRya0IrMzVIOEdNL3lKalB0Y3FIMDMwZFo3bm02?=
 =?utf-8?B?NlgzT0hBSTMzUy81c2p5RDRSZXExalBoQ1haTk8weHUrbGw4VzBwbmlQem8z?=
 =?utf-8?B?VVdIeUVzOVNJZ2p4MHBHdDM0cCtSSDRPUTZjbXY5R0tucm1na3lDem9QRWhm?=
 =?utf-8?B?UlhhWHB5SUpXZnllL3BKTWxqWEcvVnl3Y3R5dlBxV2U0ck9QLzhIbU43bWJY?=
 =?utf-8?B?ZUhJZUNvNUZUelphaENGNFdXZU5EYWxYMnZZc3VwUmh5VU1GYTRvblk1Wlc0?=
 =?utf-8?B?WGFXckZ6NUxCdE9jVTFtc3k4c1I0MEgvR09NOWl0d1lqOHhLTGN6ak1QRjNz?=
 =?utf-8?B?blg4aTBDTXdGdlRRVk9qcVgvQUdXU0RnaUREdHVIVG9KS0tTUXlsQmxVZEZj?=
 =?utf-8?B?VENEdWR3ZHJJc2FpUzJHTmRoMnhLc3BIM0JTc2Q5c05Kd2Z4ZlB3ZnNYWGhF?=
 =?utf-8?B?QUZCZjNPeVI5OVVFQjVDRjVoZ0RqZ3c1MTRGUTVOOE9CS1lHUTBVTEowYmdq?=
 =?utf-8?B?cE5jcmVxbWhvd3VIL1ZHcU9NNldNWTFTM2QvV29JNnppaHkybWFNZTN1NDFu?=
 =?utf-8?B?dUZXT3NraFFnRS9YZW1qSEs2ZElGUkQ0cGw3QUIzY0xBQWJTdFlTL014dVdZ?=
 =?utf-8?B?eUFnYkhSekV4QXBxUDJndVdsUE1vT0pQbitwTndYUmh4NmUxY3hKM1kxU2FZ?=
 =?utf-8?B?T0NQMlhvNWFzVGpTcG5KZWt2K21WOW93YmlQaVlBcys0NW9TNkg5QVltaDFC?=
 =?utf-8?B?VlpFMkErSDBGd0lnM0h4QmRiTEhuME16Nmd3YlRjUkYrZmJDRTdQVFQ1RXNR?=
 =?utf-8?B?bjI0R0F5T3VrVXlzRWI4Um5rNmY5cTlqdTJTN1loSVlTQ2gyZlBldVZjeWZo?=
 =?utf-8?B?b1FVVHd0NVM1Z09NUXgxTnI1VktQU2NXTnVyU0RnM2F5L2tzbjk5bXZXYWEw?=
 =?utf-8?B?QXRwRnJMR3pMb3N1bXdGdjdnQ29LdG55SGRaeDU3dVlYck5GWVJhK1JwSkJS?=
 =?utf-8?B?MU40aXREM2VmaUthb3J0bFVCNXIzOXF2YjJnNHlQbzVPMytNVFJWRHpJZmt2?=
 =?utf-8?B?M0ZCaTVoR2hjKzFYTmNsb1BNZStSWGdjQmQrVVRWWGJUN0NNeVp0b3R4d3Uw?=
 =?utf-8?B?bTRuZm82a2RHRkpJeFYyMFltRGw3NTNxcnpqTWo4QmZ3bllRWW1OZTU3dUVJ?=
 =?utf-8?B?TkJMLzdhOWlEZEdna3BxaEI2QkFzMkRKMUlyb2Z0WFFydSsrSTZGalVrWitG?=
 =?utf-8?Q?iTk9lmox1Sgjrshq+1XOj+40eQC8BJnxlUZZCkD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea22d2cc-4300-482e-da5e-08d9459b1bee
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:11:14.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y8S0YV5r/giRKfxCj3TX3OzCG4IiL9YpTEN90fFIFJUFpfZp/roAQdjYvPS5T/4oLfYEsLlMIk0h+wHEpipVOD8PtmPQppJehVYHE8rVI0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4013
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130005
X-Proofpoint-GUID: dGeGPzW1AVua2OfXKlJBAm47CDZTlna-
X-Proofpoint-ORIG-GUID: dGeGPzW1AVua2OfXKlJBAm47CDZTlna-



On 7/13/21 1:02 AM, Mike Kravetz wrote:
> On 6/17/21 11:44 AM, Joao Martins wrote:
>> Split the utility function prep_compound_page() into head and tail
>> counterparts, and use them accordingly.
>>
>> This is in preparation for sharing the storage for / deduplicating
>> compound page metadata.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  mm/page_alloc.c | 32 +++++++++++++++++++++-----------
>>  1 file changed, 21 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 8836e54721ae..95967ce55829 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -741,24 +741,34 @@ void free_compound_page(struct page *page)
>>  	free_the_page(page, compound_order(page));
>>  }
>>  
>> +static void prep_compound_head(struct page *page, unsigned int order)
>> +{
>> +	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
>> +	set_compound_order(page, order);
>> +	atomic_set(compound_mapcount_ptr(page), -1);
>> +	if (hpage_pincount_available(page))
>> +		atomic_set(compound_pincount_ptr(page), 0);
>> +}
>> +
>> +static void prep_compound_tail(struct page *head, int tail_idx)
>> +{
>> +	struct page *p = head + tail_idx;
>> +
>> +	set_page_count(p, 0);
> 
> When you rebase, you should notice this has been removed from
> prep_compound_page as all tail pages should have zero ref count.
> 
/me nods

>> +	p->mapping = TAIL_MAPPING;
>> +	set_compound_head(p, head);
>> +}
>> +
>>  void prep_compound_page(struct page *page, unsigned int order)
>>  {
>>  	int i;
>>  	int nr_pages = 1 << order;
>>  
>>  	__SetPageHead(page);
>> -	for (i = 1; i < nr_pages; i++) {
>> -		struct page *p = page + i;
>> -		set_page_count(p, 0);
>> -		p->mapping = TAIL_MAPPING;
>> -		set_compound_head(p, page);
>> -	}
>> +	for (i = 1; i < nr_pages; i++)
>> +		prep_compound_tail(page, i);
>>  
>> -	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
>> -	set_compound_order(page, order);
>> -	atomic_set(compound_mapcount_ptr(page), -1);
>> -	if (hpage_pincount_available(page))
>> -		atomic_set(compound_pincount_ptr(page), 0);
>> +	prep_compound_head(page, order);
>>  }
>>  
>>  #ifdef CONFIG_DEBUG_PAGEALLOC
>>
> 
> I'll need something like this for demote hugetlb page fuinctionality
> when the pages being demoted have been optimized for minimal vmemmap
> usage.
> 
> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
> 
Thanks!
