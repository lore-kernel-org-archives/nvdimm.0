Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3FD2C80
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 17:57:14 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EHZopi001739;
	Thu, 14 Oct 2021 17:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7jLr7k51p5vDQ+Jg3NdsI2psrk3FqtFMfken0QA9woE=;
 b=rWErEo4dyNkVMG1/EYVp1sV52EkVRfefQrN2ibBIodnRlHKRFuiGKb+yn98vm50YFRYZ
 tkfodS6OFdYBZUVtWNBbh9Nw6RySdI4KVd1tr7wF+y/Yn/jXczAamZBpcqt4VAmUBXOZ
 vaJdTkYnvAvE76raKPzsaQ9mW02gru52pHLO0HuTT0UB23RjgCW+q1EjTuCHR1Tjl6j7
 mzzyqeuOMwPNVJmKlNDzZsWsHW4KpLq/e9f1LoZ6smqWac3R1ponHyHbyd1Xm5OvquBE
 qpmk9OeDXk81UZSApk0ntQx8SkhlaJRCv9xIYQfcsFp2RFpJbUkRT+nMigDwi+sRr26X DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bpfy64ath-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Oct 2021 17:57:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19EHtW8s003159;
	Thu, 14 Oct 2021 17:57:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by userp3020.oracle.com with ESMTP id 3bkyveersa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Oct 2021 17:57:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgQowd+PnJPqHlx6miq1344Ga+A1ToqMmYFVC+uZ0qbRlc4ksqzXH2zcjzcroEL6uTEzo6BNeC4+/3pPBdYplcu8E5RgU+1VMBxBfCUM8vP08MEKW3MOMi1nyBhxiqhDAUmKNqakSXd7n+fcP+FIRT8vvE26gqdeW4TCXHVt0BEBXv+DYuzT3qEcek3EEpQnF7p7w0L/bjtAFvPL/ADzSHTFptifvyB8IdefuTC4f79F4j7LnyvLPi0V2V6lwuI5P3pwlB8SR4GJd3Vb1Qqdn30qzNQdt9x+fQfXsuXadk3VyaBYGgCJFcwbm3pF4rr9hMruBBRlGG8+YIachI4kAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jLr7k51p5vDQ+Jg3NdsI2psrk3FqtFMfken0QA9woE=;
 b=ldpESHaEtezcReDw6EesiBRQwIRekTwy9x2zaDQ7+4Jtpv1IYRzr+6hayUEZUj0pg27SC+IsEuJEVkGDjPFgLKN93eWBb4TzHCf8eJwMD66kEPV676n7xaSYgp4dgbhML4TBPtNq7hg7b82VlLhFBcugv9Punw08C5Q7O1sb+Z4WyHl8e32xDyUAwIZFPLfPLnCLxLEN3erdflZL6Zt5a0lAQ88i0BbEn1lFYieIsJzYGDX8VbsuI1lJC5cbigAr6Z5M9bmxGKkblK/vgZrHmOck8UYpCOQzMaQEk+OASECtwZOI9JXBqzIG1Gxp52dU4SVl/D3KW3y3QUL0SF0sDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jLr7k51p5vDQ+Jg3NdsI2psrk3FqtFMfken0QA9woE=;
 b=n/sGyYwBQgRTRCt5DEdU+MSfBthJBKohxE3rXjEdNkCfMGtvKaa3iQ2rKORkEm1yP/HzdzUVJ0Xjlwmh/Xy381NZHy1KfRWFEC0i70mZA/c+4quto5lN/tjP6I9Io3GhSOBo4U2jj2OUAloMddQZ1ysf2ukIeM3h88VRVk8hReM=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 17:56:59 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 17:56:59 +0000
Message-ID: <9a9dccc8-81b0-f3dd-60ea-130406791e64@oracle.com>
Date: Thu, 14 Oct 2021 18:56:51 +0100
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
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
 <20211008115448.GA2976530@nvidia.com>
 <01bf81a4-04f0-2ca3-0391-fceb1e557174@oracle.com>
 <20211013174140.GJ2744544@nvidia.com>
 <20e2472f-736a-be3a-6f3a-5dfcb85f4cfb@oracle.com>
 <20211013194345.GO2744544@nvidia.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211013194345.GO2744544@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0103.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.202.116] (138.3.204.52) by LO4P123CA0103.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:191::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Thu, 14 Oct 2021 17:56:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b922a022-4aa7-45c0-1732-08d98f3c0502
X-MS-TrafficTypeDiagnostic: MN2PR10MB4303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4303DD49B3F3133C598CBC6CBBB89@MN2PR10MB4303.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/uAUL5g0IUhQADyKm4w/Ry0oQOdk1KErYzB7+1CAxinsSJFvT6BzqojYYXZFjfLCYdn2xCNCMghbSLDITpSVpVaI6sbnwBNLVMsDCwheGjgnbjFn8FgfxScRmKsx42yzIvXWksKK8l/fk/Hk0yjX0LLAZNOXqLHj+174l0PXnYBLUgKfAM7Qy9U3A0FtYrWtYPAcfGwFeYBQd3nvhEynlZNL1jvB7nLaxDuROS+hVnbK3aDsiwmGi7oPyZFwFsyvT+P6Si7QWaU6EuROrxe5ylvTpGEhpzrlefGlt9ephEIrQCsx3TEgMvaxIOEPjSsAyOJEinwDs5qe9H/GcYgqb07M5qGiaMhxXaiJr4s4YfCvum9j7DOLujR1bezFJuot8cgGxnUkE8tsa1bZ4ywM0Av5BvMzSjqlRC+rq/UNSJJY98aCFMv+08CuL7Ir7RcgKvvl3+Cng0uqi04H89/I8KGbM3NQN4fxg53sMYP2O1FY8W5dN3tLj44K/Tg/5/8U1wEVXXIrRAZMXZchlAg6AoJZihe7BBKHVegiUQRJYevmIDpqJLiShGjkE1pL1Y3xqyDZYex6v8S6hKPsxKa7GUkGqtu/ch35xwnBMzl8RropS5ENAviy8cT6ighmJb4m22OVSJava5WBWoRErwh9r+ivUl2Hz60T9sHMcYUJ0WY19iI2KlhrK/DEJBp11rtvjrHo3XWExumPd+icHAi2LA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(4326008)(66556008)(66476007)(54906003)(8936002)(31696002)(66946007)(16576012)(316002)(508600001)(31686004)(36756003)(86362001)(2906002)(7416002)(6916009)(2616005)(83380400001)(5660300002)(38100700002)(6666004)(956004)(26005)(53546011)(6486002)(186003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cUgzMElqbWd1YlNrY1BTdmdzMjk2MTRCNDJsLzVPa3VMcUZ5ZVVldjNnVi82?=
 =?utf-8?B?Rk03QmxrNko5SVUzM1BaWjR1TWZUUjNnTkNNemh4Z0NLQkxaejdsQTM5MU9M?=
 =?utf-8?B?Um1FS2tubG1RK05sMEF6enR2K2pJZ1ZWekFkZDY0Z3ZJb2kxOElha09MTFJV?=
 =?utf-8?B?RzFiMllBUEsyN2JjRnRNcm1vK004VzZ3M1pvZm9BMXhVbDMxSW9Lcm9pdnlZ?=
 =?utf-8?B?V2VZUzBmRTBVeloyUktiVko5NkMrV3ljdVZpcExzTzB1cHFxY1N1WHpZRGEz?=
 =?utf-8?B?bVlneEtVWWw0c0Era1huRnR4SXo5dGVwcVMxaHh4WEd1Uk00OXVkRU9HdUtl?=
 =?utf-8?B?TGlyOXBNMkgzd2hnbHRTb1VETXY0VXZvL0dabTNmZ1greDBmTlBFT05RMjVG?=
 =?utf-8?B?TWhpUlBMSStNUnhzZWJVSkx4K0NiTGlhTG1jVGZ2aEV6R25ZV2dHQjVaSzBJ?=
 =?utf-8?B?cmpxQVVxL0l4VFVvTkFLWlRuWXFWd0JERUJ2Z1ZJVE1QdTUwOHlzMnBmelhL?=
 =?utf-8?B?MnJydCtYWWlSL1Y5d3o5SksrazJWWGJ2enUzVWFhVDNrUUpybzJJR0dtQTBz?=
 =?utf-8?B?c3ZUMVdQQThMeWNYT3p3TXVBY1Z2WlduRmdXVjgzd0lHbm9FdHBFSWM0MGZF?=
 =?utf-8?B?VytseEFCdC9HYnJYSWVtam9YdDBoSUxVWG9IOTNWSkdLd0x4MnJXanovWkpP?=
 =?utf-8?B?MGhiUDJFUng1K01ONFZ3cVVmaHpvUExMU2ZOSUJoNURhQi9SM0F3SFJsQmpr?=
 =?utf-8?B?aS9wQjIvVVFIdHRjS1hJY01DeGVYWW1JcUtFM0M3L3FVT3BhaXh5U1Z0cFlE?=
 =?utf-8?B?Ync2dlBRb2h2M0RvUjFuRzJScmpZc3pFbW42cXhxZ3FTT2FtRkhGOWJkQWtL?=
 =?utf-8?B?cWp0Rk55RldtL252cmtzYXVydWJ0NTFMdTZpNzQyWS94RzFaeld0SGhGQnEw?=
 =?utf-8?B?Uk5VZk9iNnhBUG93K2JTQ2Q1U0EyMEttQUxVRmxjUUpRM1dESDEyQmJiOUYy?=
 =?utf-8?B?RGFWRy94SFdRRC9vWHVoVnFTZTV2d2UvWGU5UWpTai83KzVnOC90ejZkSkhG?=
 =?utf-8?B?NGRpcGJ4eFFxU24wWkQyN0Vpc1dVOUxlL0s5enlYZFRLQU9sb3R2ak9EMDNt?=
 =?utf-8?B?S2pKS0FyMndIZEZsbU1mVDNHRFhMRzBJWFQ2aUw5MVRqd1ZiNjYxSDc3SDZJ?=
 =?utf-8?B?YUY5NXNoa1pzY3pNTFBlNWpCNTVBSzlRT2NGcGJ2ckc0Q2VqUUF1c1JhOHJ5?=
 =?utf-8?B?cS8vR2JsR2d5RW9jR0pnNThjZmpENjdzVk56U0JmaXFXaU9nZnZxcnJWL3Zj?=
 =?utf-8?B?V0ZNaUxZZisrdlhXUjhkam56ZzV1VVpNL08rU3JQOTlYb0pMemxVL0RqUTVt?=
 =?utf-8?B?bGZHSFZPa2tkV3NUcWVpM3lFNHJYQkVKTkE2UGQ5ZUxlVk5vaWp1b0NjbldZ?=
 =?utf-8?B?YWQ3amZaN1FkQi9TdktyTjI5RTY2cHZPWVl1Q1pIUGxodGp5MHhWTlBEOTVX?=
 =?utf-8?B?dTFmQWhrU3JnWUZDK0xxZ09tVUZ0eVVueTNicXBOYlF4UkJJbFFFaUwwbVpj?=
 =?utf-8?B?cXU2MU94RDFobzRiTFlwNlpPODBKTWZ4cnZTekd1OFZZdm1reW03NTZTMHdt?=
 =?utf-8?B?aS9mM1ZiOXhqVW45QWFia0pydEx5U096WnV6Zi83UkQ3ZzROVXFDbUhKYW1o?=
 =?utf-8?B?cTU2bFBKL0tYUXpvQnM3K21weWZMa1JkVUxnSEdFbDVmRGp6SGpFcGp6MHJa?=
 =?utf-8?Q?6Tff83qsnfEbQfLGgFIi8mIcpfTCAUrlSPrIdWQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b922a022-4aa7-45c0-1732-08d98f3c0502
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:56:59.7714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHF6idFBQRNPr9ddnpLhCP9IL5cDtHGDsN8aruQCPjHR04tPBGTqwjfg71/0TUC1E5Q3UvC0P2WJ2qwXyi0fff14Qrx89zTRrfWaRkBalx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10137 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140100
X-Proofpoint-GUID: qoMq48vPTXcuqz7k7sOXliSxxmy0d72q
X-Proofpoint-ORIG-GUID: qoMq48vPTXcuqz7k7sOXliSxxmy0d72q

On 10/13/21 20:43, Jason Gunthorpe wrote:
> On Wed, Oct 13, 2021 at 08:18:08PM +0100, Joao Martins wrote:
>> On 10/13/21 18:41, Jason Gunthorpe wrote:
>>> On Mon, Oct 11, 2021 at 04:53:29PM +0100, Joao Martins wrote:
>>>> On 10/8/21 12:54, Jason Gunthorpe wrote:
>>>
>>>>> The only optimization that might work here is to grab the head, then
>>>>> compute the extent of tail pages and amalgamate them. Holding a ref on
>>>>> the head also secures the tails.
>>>>
>>>> How about pmd_page(orig) / pud_page(orig) like what the rest of hugetlb/thp
>>>> checks do? i.e. we would pass pmd_page(orig)/pud_page(orig) to __gup_device_huge()
>>>> as an added @head argument. While keeping the same structure of counting tail pages
>>>> between @addr .. @end if we have a head page.
>>>
>>> The right logic is what everything else does:
>>>
>>> 	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>>> 	refs = record_subpages(page, addr, end, pages + *nr);
>>> 	head = try_grab_compound_head(pud_page(orig), refs, flags);
>>>
>>> If you can use this, or not, depends entirely on answering the
>>> question of why does  __gup_device_huge() exist at all.
>>>
>> So for device-dax it seems to be an untackled oversight[*], probably
>> inherited from when fsdax devmap was introduced. What I don't know
>> is the other devmap users :(
> 
> devmap generic infrastructure waits until all page refcounts go to
> zero, and it should wait until any fast GUP is serialized as part of
> the TLB shootdown - otherwise it is leaking access to the memory it
> controls beyond it's shutdown
> 
> So, I don't think the different devmap users can break this?
> 
maybe fsdax may not honor that after removing the pgmap ref count
as we talked earlier in the thread without the memory failures stuff.

But my point earlier on "oversight" was about the fact that we describe
PMD/PUDs with base pages. And hence why we can't do this:

 	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	refs = record_subpages(page, addr, end, pages + *nr);
 	head = try_grab_compound_head(pud_page(orig), refs, flags);

... For devmap.

>>> This I don't fully know:
>>>
>>> 1) As discussed quite a few times now, the entire get_dev_pagemap
>>>    stuff looks usless and should just be deleted. If you care about
>>>    optimizing this I would persue doing that as it will give the
>>>    biggest single win.
>>
>> I am not questioning the well-deserved improvement -- but from a pure
>> optimization perspective the get_dev_pagemap() cost is not
>> visible and quite negligeble.
> 
> You are doing large enough GUPs then that the expensive xarray seach
> is small compared to the rest?
> 

The tests I showed are on 16G and 128G (I usually test with > 1Tb).
But we are comparing 1 pgmap lookup, and 512 refcount atomic updates for
a PMD sized pin (2M).

It depends on what you think small is. Maybe for a 4K-16K of memory pinned,
probably the pgmap lookup is more expensive.

A couple months ago I remember measuring xarray lookups and that would be
around ~150ns per lookup with few entries excluding the ref update. I can
be pedantic and give you a more concrete measurement for get_dev_pagemap()
but quite honestly don't think that it will be close with we pin a hugepage.

But this is orthogonal to the pgmap ref existence, I was merely commenting on
the performance aspect.

>>> 2) It breaks up the PUD/PMD into tail pages and scans them all
>>>    Why? Can devmap combine multiple compound_head's into the same PTE?
>>
>> I am not aware of any other usage of compound pages for devmap struct pages
>> than this series. At least I haven't seen device-dax or fsdax using
>> this.
> 
> Let me ask this question differently, is this assertion OK?
> 
I understood the question. I was more trying to learn from you  on HMM/P2PDMA
use-cases as you sounded like compound pages exist elsewhere in devmap :)

> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -808,8 +808,13 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>         }
>  
>         entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
> -       if (pfn_t_devmap(pfn))
> +       if (pfn_t_devmap(pfn)) {
> +               struct page *pfn_to_page(pfn);
> +
> +               WARN_ON(compound_head(page) != page);
> +               WARN_ON(compound_order(page) != PMD_SHIFT);
>                 entry = pmd_mkdevmap(entry);
> +       }
>         if (write) {
>                 entry = pmd_mkyoung(pmd_mkdirty(entry));
>                 entry = maybe_pmd_mkwrite(entry, vma);
> 
> (and same for insert_pfn_pud)
> 
> You said it is OK for device/dax/device.c?
> 
Yes, correct. (I also verified with similar snippet above to be
extra-pedantic)

I would like to emphasize that it is only OK *after this series*.

Without this series there is neither compound order or head, nor any
compound page whatsoever.

> And not for fs/dax.c?
> 
IIUC, Correct. fs/dax code is a little fuzzy on the sector to PFN
translation but still:

There's no compound pages in fsdax (neither do I add them). So
compound_order() doesn't exist (hence order 0) and there's no head
which also means that compound_head(@page) returns @page (which is
a tad misleading on being a head definition as a PMD subpage would
not return @page).

> 
>> Unless HMM does this stuff, or some sort of devmap page migration? P2PDMA
>> doesn't seem to be (yet?) caught by any of the GUP path at least before
>> Logan's series lands. Or am I misunderstanding things here?
> 
> Of the places that call the insert_pfn_pmd/pud call chains I only see
> device/dax/device.c and fs/dax.c as being linked to devmap. So other
> devmap users don't use this stuff.
> 
>> I was changing __gup_device_huge() with similar to the above, but yeah
>> it follows that algorithm as inside your do { } while() (thanks!). I can
>> turn __gup_device_huge() into another (renamed to like try_grab_pages())
>> helper and replace the callsites of gup_huge_{pud,pmd} for the THP/hugetlbfs
>> equivalent handling.
> 
> I suppose it should be some #define because the (pmd_val != orig) logic
> is not sharable
> 
I wasn't going to have that pmd_val() in there. Just this refcount part:

 	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	refs = record_subpages(page, addr, end, pages + *nr);
 	head = try_grab_compound_head(pud_page(orig), refs, flags);

and __gup_device_huge() melded in.

> But, yes, a general call that the walker should make at any level to
> record a pfn -> npages range efficiently.
> 
>> I think the right answer is "depends on the devmap" type. device-dax with
>> PMD/PUDs (i.e. 2m pagesize PMEM or 1G pagesize pmem) works with the same
>> rules as hugetlbfs. fsdax not so much (as you say above) but it would
>> follow up changes to perhaps adhere to similar scheme (not exactly sure
>> how do deal with holes). HMM I am not sure what the rules are there.
>> P2PDMA seems not applicable?
> 
> I would say, not "depends on the devmap", but what are the rules for
> calling insert_pfn_pmd in the first place.
> 
I am gonna translate that into HMM and P2PDMA so far aren't affected as you
also said earlier above. Even after Logan's P2PDMA NVME series it appears is
always PTEs. So fsdax and device-dax are the only pmd_devmap users we
should care, and for pud_devmap() only device-dax.

> If users are allowed the create pmds that span many compound_head's
> then we need logic as I showed. Otherwise we do not.
> 
/me nods.

> And I would document this relationship in the GUP side "This do/while
> is required because insert_pfn_pmd/pud() is used with compound pages
> smaller than the PUD/PMD size" so it isn't so confused with just
> "devmap"

Also, it's not that PMDs span compound heads, it's that PMDs/PUDs use
just base pages. Compound pages/head in devmap are only introduced by
series and for device-dax only.
