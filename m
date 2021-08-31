Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28A33FC1
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 12:34:47 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VCDqVE016429;
	Tue, 31 Aug 2021 12:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HJaXF7PW6zDL7y2Io/NMWbqGKiD4OyT66KQN06MMrio=;
 b=taRWAMFSdlfzglPfBbj2IZELM5H9m3Ie513kJ4yeBJp6yMuzCcLMKyLnmsnTFrvdXswo
 jMZRKLNFWIrnVi8nesNvhn5E2k+zXG40m237HVNR99++FumamhTwEoPUq41Jt/4JnisS
 flHSCNPkM4MZbX9ZFGP3zxCyJ2Hwp1nFbOIu6kNNY98cz7vaE+3VREeLJG0Bof6/BMaE
 rSHpE9yY+kmXfrf0Z3dIKG9S4ak/oTYsl/vJo44GLT8YcqnQPtf4sLiY0yeHdTAgBcK4
 hmO1CLEy//HPYr/qxW6M9SbA0qaV8vn78EklHbSNTNv10FIcrFVKh9t3FH884aZhxsxB AA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HJaXF7PW6zDL7y2Io/NMWbqGKiD4OyT66KQN06MMrio=;
 b=Bum1tJ/ogdj0ShLw2SSOafUWnWF97RtjBUgjcBWZ49o21rm4lCYJDkJofjTvaBUH2j8h
 z64GuNBkcvdgILjdpQn4CXcKuJz2cyfLi7aY/b5LgdkDYfK57sQJDeteC4bXK6tLUjpp
 kmLdruoddiy6Rd2vTZ1WQDO+c4VvASE6yCdZqhn0tOtXusxkiAB7LrPhVhGeRZNbshoF
 Rm6LhFrPJSI4wyzB2+yKYJquVc5zBzanlMO9Bi6ncwFvMAGf1NcZu3ebASVpW5hW3Xk7
 +ZUFr+/AK9GntU5pmlHBVSG/5TYiVicQz64l4OomHq7qorEn4CwoT8u9PyqsYVcXrf6J YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3asdn1ryd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Aug 2021 12:34:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VCVdFZ169691;
	Tue, 31 Aug 2021 12:34:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by aserp3020.oracle.com with ESMTP id 3aqcy4mngc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Aug 2021 12:34:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVR47d4i/+vygDlo7dwCkFpZVQuIP4Zfg3SIk15MK6F/Ua4NB/r/261GG/qdjbP1KM935XYKwlj2I7s8JVyhsmBjjaNiWz2IxlQ62lL8OguiRkblJxREozVjpTWEx3N9N/nQvVTHL8bLmFJK8tkgdS/1A8Jv5ahlAdyT9EvWbSAKEeGDyIdpvEnQIsi9k4YuT6EYz1KjE3nuArva8OoFj0ZRy0PkMB9eLmpKsE3/NhQ5yn+6lA6k3r5fm4YTNdUKMHgdIC01MbRspFA7lXXdp10crKJIT+dSeo7IFw/NZBsl8EoquQrzGAT42qby5mRZx7u9UQxcmfLLTxbY7cmqng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HJaXF7PW6zDL7y2Io/NMWbqGKiD4OyT66KQN06MMrio=;
 b=AWnrrBkyWR4tWl0r0mfTt8kVZCOh6dGYXjUzGnzWH8GmGgb2bZoQji6pTEjpUlIpvOxhjVnHoU2X4WyzjHnda41G3oV4ZJT5gQSPkIsARbr5q3GyeM+xj9hsZoKQEHnpb2iNHEz3ge5yXa0izA495H3x8vSmMTG8jwW2aP6d+ShNk/SNW6HCWuOvVruOq/PQyQkoamXeklCBpGT7hya0l43rbeTzmUQtYtHa9dCjPGJ0S2Qk9S7F3BAzTDbG7v9Bu1BAo6vn2x+r/mKO58zmA9zLAX4Tnzbef17G1j2d+4Cz1kk+ojBeEAoZSaEcDQsm5ddvb1c6ByqPf7Wme94AgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJaXF7PW6zDL7y2Io/NMWbqGKiD4OyT66KQN06MMrio=;
 b=q3GHXhY1Sk/XUVc2L3xS8//OCAueiZC99esSvKDEcemAZGWvYbb8L9G2393hD0ivWyqWYj9J/LSreFeXVlEETJr6qtVn10SyOEPFpw0iB+mTQT2MJQ206lIATZq3qCLH7589TSzmlVE+yG3fRXh2mqWsB5ZBNWiWPSj+hmyTpdM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5217.namprd10.prod.outlook.com (2603:10b6:208:327::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Tue, 31 Aug
 2021 12:34:11 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 12:34:11 +0000
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
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
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <cda6d8fb-bd48-a3de-9d4e-96e4a43ebe58@oracle.com>
Date: Tue, 31 Aug 2021 13:34:04 +0100
In-Reply-To: <20210830130741.GO1200268@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0067.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.190.129] (138.3.204.1) by LO4P123CA0067.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:153::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.22 via Frontend Transport; Tue, 31 Aug 2021 12:34:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 489ebc4b-84b2-465c-d379-08d96c7ba2be
X-MS-TrafficTypeDiagnostic: BLAPR10MB5217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB521764337742450F1AF9D3E9BBCC9@BLAPR10MB5217.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PNkHHn9SYRTi0PIbv7d8CfTyic/kgl1SLqgsXRIQNo5gM/SBSGyxSCn4lpdxHsttx3YdG5SDD5+JNFXfe/UPrmxkQY9BoxGAQGy1jkPiLSHcqh2QyU8k886AjMHRLiaF5f0tMOAB0HU37ZL7ebDOW1hLoV9RkaAx0KkuH1elpoKjMJpnltMXW9JcJ3H20YT9XU1vMSWEptb0FW5So6G39+TyUFMMqEdQbSLt4LLnL9DvOrKnDEAqQm+GzOmKE/Pj5YweRSYL76ahgKTYUw8R7ALwZLWRtM+8g+wA7+LK2jgP7tMMHsbYoUfrLBnEDfbge9oznewX/xBK4a8re+BM2GsWe/8IiEYpLVg68tteeUQoo3WmMdBIKAJSLbLCc+r4cU8jP7rP3U+W1jtnQ5o7wm9FFnK8v++BcDm2SBPfdXKtXxZVBe4A6PA9zA2V3rxXCgluCUsjNkUZlwqGrSPMCkbVqqzkHRijcyiz0rTpEV+DaWvPVTtlNxRG8sjgNXEDoeUbTU57Ny+65P7R+ruN1wJuOgUYnvU0nQdxofylE5tB0sCbYXa2ZDiRVcx1WFMOIoYjix5Z0hK0T08ZSdZspNHneRoqDLQMznyn33qTr88I+STPn2g0MBhCgbFbGjW4H23flL4i/qVPBLXpFMVdurwtjYeTwQ4DHgxMV5fipf8ADCd6IbZsa7j3UlkLk4v4AYUbAZBpSn/VZkjtYUR33g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(2616005)(86362001)(956004)(53546011)(36756003)(5660300002)(4326008)(66556008)(66476007)(66946007)(54906003)(26005)(316002)(186003)(31686004)(6666004)(16576012)(38100700002)(8936002)(6486002)(8676002)(83380400001)(508600001)(7416002)(2906002)(6916009)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZFRuWFhubnl3T0tVTis5U0JSaGxXSVRnZm9PUG81R09CamRKMXdpWmhXUFVP?=
 =?utf-8?B?UVVuSG5wU3FYV2pPNVFCRjhJR0RJdENRb2pIYTNnK21JNFVJb09lbFNOYkF3?=
 =?utf-8?B?U1o3RldXMHhzeE5LajJZUW1HdVl0UDk2R0M2M09vakVycTZjdUVSejdtdGp0?=
 =?utf-8?B?NENxNW94cHRjK1FaSWRSSWxQK2VtNHFkVGFnNWxrRGkrRkJnQ0w5T3R6SUpZ?=
 =?utf-8?B?VHRTdFVXZ0hNOFNZWWVyM1RuYlMvdHNmdGtQMnM5RVRpYXVYMWtxLzBrNG1X?=
 =?utf-8?B?bUVrMjNlbTIrTEVRWFZ0K3pBK3hUQzZEVTFVWldUVHpaa3EvdStUQmdaaUFw?=
 =?utf-8?B?TVMvOWdCZTdpUjhXMUtxcSs1NU9hVlBWYXZscDBzNnJDNTJ6ZGo0eU1zck5X?=
 =?utf-8?B?bFZMYzJwYWVnQTZtNWhuYUR0UDg0UDlNd0J6dVBzWWZvWEVaVGNaMkpGbUZX?=
 =?utf-8?B?TVJhaWpaM2kzZW40WWZCbG5idU5HL3FBSHdSaFJYTkYzMnZ0SU16cjFBc2lI?=
 =?utf-8?B?aWtpZ3NZWDJxOFJmVmJHNTd6TlgzSTNMQUs3bEJqRDM2VjRYQlVoSUNIOUtP?=
 =?utf-8?B?UXVPZUVJMmErT2c1U1BITHpQMFBwVG4wUEE3UUJlRmFqNjZiUFhoZ0VxcGRL?=
 =?utf-8?B?ZjVtRHlvczNkbE1iSmFUY2xFNjZ1NERwU0NXYnpLTUpKR1krY2h3b0wra2tj?=
 =?utf-8?B?Uis4L0kzMTV3UDdEK3JSdTZ4Q204V1dEOVA2VFlnRnM3NDFVVC9CU0dkWEZo?=
 =?utf-8?B?WGpkemFuSGYwdWl0cDVIb2JDdllJNHloQU1UNlNSeW5CTVNPblNDdmxNeXMz?=
 =?utf-8?B?VFcrSFY4ajU1QWlmWlB2TzhVYmpGQmg5akF1ODZJc2kvTzQxcWw5cm80WTJT?=
 =?utf-8?B?QS9lUWdxK0ViNmdxYW1TRFVtMlljN25Wb1VSNnhSMjJWQjY5bXdnYStuRG04?=
 =?utf-8?B?enU1V0hzTExQaE04OUdaQzFIMTR6VWl2SmpXSi9GeWk4dSsySFJrZmFjWm43?=
 =?utf-8?B?Q2dpUWM4M25MVUJvMlp6RjcwZnVraW9qVjNUWng2Y2pxakNKRjBCMkRObXZr?=
 =?utf-8?B?NkgxSDNwbGY0ZnREZHNONkVDalFEZGhPWHdwcmRUMmpzaVhUM3ZGS0lQT3B4?=
 =?utf-8?B?ZUhOOUZTdTkxaS9MZnc4Tnd4dzRpZE9MVHBxK2MrdzBPclZFUEZOcGM0UzBF?=
 =?utf-8?B?QitHRVRvUDF4bFplcmlOM1o0eGZidXl6NHVSNUFNLzJabEZ0aW1YSVlmWlUw?=
 =?utf-8?B?OXFGRVAxVXhLR015RldmbE94OXJtM0o2U2h0UG9NTC9iNHpOYlp2djRJUGtx?=
 =?utf-8?B?K3l5VU5LRnZYOHI5NkdWNy9BSUZhNjZsYjJYemxLZkM3ZjF3eDM4a0xucGo2?=
 =?utf-8?B?R0pPUENHY013Q09nU2poY0x1OWFSSDRzWDRyY2hZSEhRaElIbHUxSUpsV3V4?=
 =?utf-8?B?NWlqZmtyTWYxUktKcjM5ZVZzMUpwZW5Ta0dlT09UamcrRjg0aVFsaGZqTW1F?=
 =?utf-8?B?SXdDV21nNDY5cktqNHlmRk9uTnZWMUtlNDRFQS9vQnB0UjQ2SndJek4xWkdH?=
 =?utf-8?B?cEVxQm9ZNEhzak5WK2ppWHdBYnM2eW5FQzFTdGVJSU5QUEw0MUNVUkxMSnhh?=
 =?utf-8?B?bTNIL21TUVNQZm5BV3VzbWhxY21ncU5XNGtkbldjUWNNVU5MQnVwekFCUmFO?=
 =?utf-8?B?eDdTQjkzd21GVTZ2cXh6c1UrOGtFMUdJTlM2V3FkdGErQklyRW1pRkI1RXNk?=
 =?utf-8?Q?o00kKdXad+itzrdVnAp+956d3oQRxQAlKHPYgta?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 489ebc4b-84b2-465c-d379-08d96c7ba2be
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 12:34:11.8500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: izLM1x0HiD/7a5E8NWyok51QQw8UMA5QAoSWaFScuVMsQ4fviGtr+YfONb7dRKnZg4rECFXOJgBaNC8KU+bv6g3/wLyxKkC9uZLowsZxkpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5217
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10092 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310070
X-Proofpoint-ORIG-GUID: qJ6v0C9CuwhVWsrKF08_uPdNR3HPSnBD
X-Proofpoint-GUID: qJ6v0C9CuwhVWsrKF08_uPdNR3HPSnBD

On 8/30/21 2:07 PM, Jason Gunthorpe wrote:
> On Fri, Aug 27, 2021 at 07:34:54PM +0100, Joao Martins wrote:
>> On 8/27/21 5:25 PM, Jason Gunthorpe wrote:
>>> On Fri, Aug 27, 2021 at 03:58:13PM +0100, Joao Martins wrote:
>>>
>>>>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>>>>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>>>  			     unsigned long end, unsigned int flags,
>>>>  			     struct page **pages, int *nr)
>>>>  {
>>>> -	int nr_start = *nr;
>>>> +	int refs, nr_start = *nr;
>>>>  	struct dev_pagemap *pgmap = NULL;
>>>>  	int ret = 1;
>>>>  
>>>>  	do {
>>>> -		struct page *page = pfn_to_page(pfn);
>>>> +		struct page *head, *page = pfn_to_page(pfn);
>>>> +		unsigned long next = addr + PAGE_SIZE;
>>>>  
>>>>  		pgmap = get_dev_pagemap(pfn, pgmap);
>>>>  		if (unlikely(!pgmap)) {
>>>> @@ -2252,16 +2265,25 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>>>  			ret = 0;
>>>>  			break;
>>>>  		}
>>>> -		SetPageReferenced(page);
>>>> -		pages[*nr] = page;
>>>> -		if (unlikely(!try_grab_page(page, flags))) {
>>>> -			undo_dev_pagemap(nr, nr_start, flags, pages);
>>>> +
>>>> +		head = compound_head(page);
>>>> +		/* @end is assumed to be limited at most one compound page */
>>>> +		if (PageHead(head))
>>>> +			next = end;
>>>> +		refs = record_subpages(page, addr, next, pages + *nr);
>>>> +
>>>> +		SetPageReferenced(head);
>>>> +		if (unlikely(!try_grab_compound_head(head, refs, flags))) {
>>>> +			if (PageHead(head))
>>>> +				ClearPageReferenced(head);
>>>> +			else
>>>> +				undo_dev_pagemap(nr, nr_start, flags, pages);
>>>>  			ret = 0;
>>>>  			break;
>>>
>>> Why is this special cased for devmap?
>>>
>>> Shouldn't everything processing pud/pmds/etc use the same basic loop
>>> that is similar in idea to the 'for_each_compound_head' scheme in
>>> unpin_user_pages_dirty_lock()?
>>>
>>> Doesn't that work for all the special page type cases here?
>>
>> We are iterating over PFNs to create an array of base pages (regardless of page table
>> type), rather than iterating over an array of pages to work on. 
> 
> That is part of it, yes, but the slow bit here is to minimally find
> the head pages and do the atomics on them, much like the
> unpin_user_pages_dirty_lock()
> 
> I would think this should be designed similar to how things work on
> the unpin side.
> 
I don't think it's the same thing. The bit you say 'minimally find the
head pages' carries a visible overhead in unpin_user_pages() as we are
checking each of the pages belongs to the same head page -- because you
can pass an arbritary set of pages. This does have a cost which is not
in gup-fast right now AIUI. Whereas in our gup-fast 'handler' you
already know that you are processing a contiguous chunk of pages.
If anything, we are closer to unpin_user_page_range*()
than unpin_user_pages().

> Sweep the page tables to find a proper start/end - eg even if a
> compound is spread across multiple pte/pmd/pud/etc we should find a
> linear range of starting PFN (ie starting page*) and npages across as
> much of the page tables as we can manage. This is the same as where
> things end up in the unpin case where all the contiguous PFNs are
> grouped togeher into a range.
> 
> Then 'assign' that range to the output array which requires walking
> over each compount_head in the range and pinning it, then writing out
> the tail pages to the output struct page array.
> 
> And this approach should apply universally no matter what is under the
> pte's - ie huge pages, THPs and devmaps should all be treated the same
> way. Currently each case is different, like above which is unique to
> device_huge.
> 
Only devmap gup-fast is different IIUC.

Switching to similar iteration logic to unpin would look something like
this (still untested):

        for_each_compound_range(index, &page, npages, head, refs) {
                pgmap = get_dev_pagemap(pfn + *nr, pgmap);
                if (unlikely(!pgmap)) {
                        undo_dev_pagemap(nr, nr_start, flags, pages);
                        ret = 0;
                        break;
                }

                SetPageReferenced(head);
                if (unlikely(!try_grab_compound_head(head, refs, flags))) {
                        if (PageHead(head))
                                ClearPageReferenced(head);
                        else
                                undo_dev_pagemap(nr, nr_start, flags, pages);
                        ret = 0;
                        break;
                }

                record_subpages(page + *nr, addr,
                                addr + (refs << PAGE_SHIFT), pages + *nr);
                *(nr) += refs;
		addr += (refs << PAGE_SHIFT);
        }


But it looks to be a tidbit more complex and not really aligning with the
rest of gup-fast.

All in all, I am dealing with the fact that 1) devmap pmds/puds may not
be represented with compound pages and 2) we temporarily grab dev_pagemap reference
prior to pinning the page. Those two items is what makes this different than THPs/HugeTLB
(which do have the same logic). And thus it's what lead me to *slightly* improve
gup_device_huge().
