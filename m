Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7066C2C87
	for <nvdimm@lists.linux.dev>; Wed, 13 Oct 2021 19:19:22 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DIVDX8008142;
	Wed, 13 Oct 2021 19:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jFlbDCcnhmjGmYDhErhJcd68YiSg7nt1fcygxBiprTA=;
 b=K9Gk3TwqQbggRhqwTo7UDfpcXHy6AKqh+a71YC7nAg2Ffp948+OX2bovKB23ArSbl8TC
 ciobso4TES8twM7y6+vwV6M+ReX03P2qh7xvxCJoGpyZE6yEEThPGRu/56hSndTWqV8n
 1fl8UbAr2KW0b+Uf8t9e/PAD7qN5X8HsTeSGEZktarMXIVfmdUIR4jGyAZkxDQuA5eik
 Dx4msjJb1nskDwVkif+zuh5zDFWX/DQQJHpf9W+NocKjb/CvLy/pN0RB8qiuAy/A83cH
 tDArIVnybaCM1NVsV54YPSm+FkmcLFfJtxAu74LR6pKJgrs8nYuIM4J2LIN4uGGHWbE9 zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbj6wqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 19:18:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DItCrR132830;
	Wed, 13 Oct 2021 19:18:18 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
	by userp3020.oracle.com with ESMTP id 3bkyvcnp3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Oct 2021 19:18:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcEL0AwDeMmvsDePxzQwaTtL2BdJzEGkBxaSYuAxcHBQgi344ZTIUEwuZB9oLPJPFzY4CM+KlgRLfTqGD23H6r9KVMQucdaKiIvpHaH/R7hn+nkC4bBaFYY+ZdIubC3kKxhELi87F8YXbSFeanSLwMjLPFNIAuxDctCwgjMYVYuj2VpDkW+40P7dwwqZi3FfJO5eduCIF1f+CpomuPzAi7ERBdQBpWX48wPTC/bj9uVMeVFrypVsF6D/eqTQXtYUPaGxa/UaEiZiJjZ4mn4J4Akk2Zx/DWL2VfNuVRNuLCmoDZg9DoK0bYN1hl3cueOhXiZK2pN0TA9JjvOTvCK9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFlbDCcnhmjGmYDhErhJcd68YiSg7nt1fcygxBiprTA=;
 b=QFhfcdEWJBA5X2vkOkhnWk9Vip84sw3KuiBGrUyyVdcznIfhXXLK8d4yhCl1cVXzPtS7EMA7BLzA2DSPfjrFwAtTQsHxb74RFtp/I5ZT6tCFcgEFSmPjleWKUxUOlIdDAtGSnl+1ojrx63x4g3NwEi8TbEJQ6eAlVcnRFydsvdKDN6g1CD7tUVZtXJH7IsHE+ScHqD4evgy9uH1CHKvb7EGoCvZutGlVMg+pUguuhWRJsRKlOGLTfN0h2/HarkZUroF1ZYLbT7C7GeYeihNb2mzWDKcF0S1mePIh6VN2NdA9rnwOIHneJ0TXgGMGHhZ3PicoZHxVnX8LDDEnZ4hruw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFlbDCcnhmjGmYDhErhJcd68YiSg7nt1fcygxBiprTA=;
 b=WwCvY67/SKElrEjHEJiVO2MC2B6NBpE8LJcNiISLWYFkd16oDZGpQ4Ts6ih8LvV0hKgGlQdiJZjCy1jI8X3w9rmp+pG85bFTQNNe+mrx+hOQsJ5Oc5LCmnDEpZMvH/Gvid1ooSSoGL/8Zu0f5Pz6+XdkiaQPclAuUgdavgqkbww=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5124.namprd10.prod.outlook.com (2603:10b6:208:325::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 19:18:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 19:18:16 +0000
Message-ID: <20e2472f-736a-be3a-6f3a-5dfcb85f4cfb@oracle.com>
Date: Wed, 13 Oct 2021 20:18:08 +0100
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
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211013174140.GJ2744544@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0202CA0007.eurprd02.prod.outlook.com
 (2603:10a6:200:89::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.197.177] (138.3.204.49) by AM4PR0202CA0007.eurprd02.prod.outlook.com (2603:10a6:200:89::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 19:18:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af99738a-1921-40dd-7e3b-08d98e7e3593
X-MS-TrafficTypeDiagnostic: BLAPR10MB5124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB512497B6CC121BB0639D53ECBBB79@BLAPR10MB5124.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uNkMohyNZzpB02GMP1GXskoIOXk9aXwAUvNJ00+cpSpt9yIlIAscbVq6cnfEvwkzpqaw1Zsx04pvIKUK8o/jGuNjxuEhnsAxgpNUNlblyVaN+pUslBBsg4A5LakZ0mAsmA6eE2XriGdihKxqoWicEIYt7pBpNl0RpynfDgUDB16oU3sy+4kwhsrskdXsgQmAiU2Ohcwwg/rhnRdCeVxoWsQAb4sJBm02DkvgBDXDaIZ94x8RIsWbBfZ8RnYcAVVtK2OvwgFDFRgG48x7he11Y7UgN9A+8d+Qwv9/aWJtKPLbA5R7N59WWBqv2n9ypy39Wn5/SCYWAny3OscJSj6n91wAQJTDCFUaF0JlyxnCd+zwdmL9FKdY+JATzbU3ZnFV4pEyDwLZ1skxS9RMjUWTtym4C2eMNG3XIxyLYeuBvqWLv5IErP5El7Cb9AQGs3O3o3K+DkfftiOeJwfg14vXPohx041DfvxA2t+hroXgj0fp3w8mZEuv5YRTeDBbfkSC+9ULa/B6RPL7SfG08cMwfONX76gboUAa32SCMQrQ13/8I30zyjc0r2TDhL/yhBzT87qnIvp5USw6LPbAKn0SyQqigm2HpyXzJGza1w7Z8kMLLF7ov9/zyEZVmPR/6H56xIUFhUxqjSyjNBjWGiStHb98jFIujjbo5tWLlw4+QkHt1HkZUImF82ze503uipyBiRH4VoGaotsICtFg9/YFig==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(6666004)(8936002)(956004)(2616005)(66946007)(66476007)(66556008)(86362001)(4326008)(31696002)(508600001)(316002)(5660300002)(16576012)(7416002)(53546011)(2906002)(6916009)(54906003)(83380400001)(26005)(186003)(31686004)(36756003)(38100700002)(6486002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WHR6M05nNWdmWnV4blphVG04YWdQNnNzUkRMM2x0VTM4OFRKcStxN1MrQVpI?=
 =?utf-8?B?YWNBazBJU1JpMEc1amFDcXh5MHlzb1k4T2psa0xlbEc3SFM3UWhaMU5wYWFi?=
 =?utf-8?B?aUxBUlVUNGFBeXp1WTBrMmlWcFR0SjR5YWNmcEl6ZldIeVVmRlZzY1N3VkJG?=
 =?utf-8?B?MWJWSWYyN0hqaHBOUHpiQW96NHF5WkZRaTRHUXJxZHNEdUVmTWxuM0ZKekwv?=
 =?utf-8?B?UlBQVldOb2MyOC8zVG56OHVrbEg5YkdSQ0FROTRzYzV4VGtaOGl1bGVuTGE5?=
 =?utf-8?B?ck9LMytwYkduUXgzV2lzNTN1dFhQVFAxTzJ0WFBWY3FmSHM1SGpRYUtRTEp0?=
 =?utf-8?B?dSt1V2l1TzE0NU9MbGp5eW9BYzhQWDVkUUxUR3BUWlByNVJMeW1QVTN4NTdM?=
 =?utf-8?B?K2hDeVZJcU9FekZ1ZG5pNTFSbXBoaytmMmRnLzE5S1JDTDROVFY2b01wR3Jk?=
 =?utf-8?B?eUdHNFNWN1VJRkRuR21kVmxRUHE2dGpEZzBUL1RlWnZPZ3NDeUZOV0duQjhL?=
 =?utf-8?B?SmowK0haN2ozZUNJNFd3YW1wL2NlZzkxcXNyNEpPY3k0MTl6RzVDd0NIQVha?=
 =?utf-8?B?M3ZxMEE0b2JMZC9odXMrbFpQVU8vR0pKRGxwOVd0MXFBRzIzQkxtN0M2bytM?=
 =?utf-8?B?WTdDUWdic3ZWZnU1NUd3eFNaODlMSXBBaE1uWUNMd1EvUk1KSDloZWJJYit6?=
 =?utf-8?B?aDYxMkVCaThvcjBpM0o1cUFENkpoQUd3WHJudDU1TUkvNVFwZnNNUWNiQ05s?=
 =?utf-8?B?eURGcmFnMkpDalFyUlBWVlM1dFN3N2lndHRkRVlhM3hReUgxTDhMZ3drV3Zq?=
 =?utf-8?B?djZVMlNkN2Fqa21TRm5jRzcwWWVXR1RJWVNBWllLUU9iSVNjNGtRbmU4RlBh?=
 =?utf-8?B?YzlqOG1CUzNVOHdoa2dDZFpoaDV0eGNNNkxQUWp4NDlTaUZOVWxtL1F1YnFw?=
 =?utf-8?B?cjVHZ3o0SmtOaHpTMzR6N29rTWRhV2o2V3JXcVhFOXJGb2xRN29mV3ZRWU1P?=
 =?utf-8?B?YmgrQXRudVZlZXJkS0pCYVVoRzJpZnFXR1RPbjBCY2NzNnk0TnJYWVlOMnNZ?=
 =?utf-8?B?dDJkV2cvMTlLSXNUWEpTblZtY2VtcTRoV21oVm4yZVlpNm8zVjFMTFdiU0t6?=
 =?utf-8?B?eVBWVnJrQVBxcS9DVTZRWEhXT3E2UkxKbFMwZFd3T3RySkd0NjhoeThRV2NW?=
 =?utf-8?B?YURSd09acUJiWDRyOGc0R2g5aWRFNU92RTMxWHlGd3JMdW8vUDc4Y08yNWFC?=
 =?utf-8?B?SGxscFNQQzVRTUtGVVhYVXZwZld3QjFFT1Fzd2JOaUs4ditrUzFoRWFsZHM5?=
 =?utf-8?B?OEZJeVFCOEFJMzJtN2JwUEdYQ3VDbCs0cHo5QnZNT3g4bHBPRzJIakkvZHZ1?=
 =?utf-8?B?KzQ4NFdHbG5oYkttYVY2bEJFOFNSL0VCUEJNRmpWMUtZV2FlUFhSL0pJSHNY?=
 =?utf-8?B?T2dvRzJydlk5VmJKaHQ5THQvZWgwNFJYTFZmTkE3UGlocUgvSWtISjRLUVM3?=
 =?utf-8?B?ODVLYkN4TzVBWkRoQlJneXNzM2Yvc1cvbjROeVhacEllc2RFcitBalVxanhq?=
 =?utf-8?B?NjBrN1NjNWZWMHZSUDJCVFBhR2RLQ3FzRlRhSVk3Vis3emdWaEZGU01oWk5j?=
 =?utf-8?B?OXE5WjNZNlkvVkdnWDBpWDFXZjkzdGV4UWZ6Yyt4TEZYZ2syQlBXL3ZpRGt1?=
 =?utf-8?B?cGRLMDFRUTJPQVF0dm5LanE1ZFUzZVlRdERWaytiVTRjTUdZNXplb1NBaElo?=
 =?utf-8?Q?RNUp97wjwIfjeBYbrtWQ4dihRgFj4UyCBJ6WsCf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af99738a-1921-40dd-7e3b-08d98e7e3593
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 19:18:16.7957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7xZhVocZzc6340uNjttXW1RyhUb7bk1WxVkI80th1kMiscFDeUK45qn5v79ZMklysDRTcICmlRnl+yA1HVWj4LrFv9y4WOe8+mAQN0EoVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5124
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130114
X-Proofpoint-ORIG-GUID: xYU6BowaVGYmaO1do7hiN0CWuJDM9dwb
X-Proofpoint-GUID: xYU6BowaVGYmaO1do7hiN0CWuJDM9dwb

On 10/13/21 18:41, Jason Gunthorpe wrote:
> On Mon, Oct 11, 2021 at 04:53:29PM +0100, Joao Martins wrote:
>> On 10/8/21 12:54, Jason Gunthorpe wrote:
> 
>>> The only optimization that might work here is to grab the head, then
>>> compute the extent of tail pages and amalgamate them. Holding a ref on
>>> the head also secures the tails.
>>
>> How about pmd_page(orig) / pud_page(orig) like what the rest of hugetlb/thp
>> checks do? i.e. we would pass pmd_page(orig)/pud_page(orig) to __gup_device_huge()
>> as an added @head argument. While keeping the same structure of counting tail pages
>> between @addr .. @end if we have a head page.
> 
> The right logic is what everything else does:
> 
> 	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> 	refs = record_subpages(page, addr, end, pages + *nr);
> 	head = try_grab_compound_head(pud_page(orig), refs, flags);
> 
> If you can use this, or not, depends entirely on answering the
> question of why does  __gup_device_huge() exist at all.
> 
So for device-dax it seems to be an untackled oversight[*], probably
inherited from when fsdax devmap was introduced. What I don't know
is the other devmap users :(

[*] it has all the same properties as hugetlbfs AFAIU (after this series)

Certainly if any devmap PMD/PUD was represented in a single compound
page like THP/hugetlbfs then this patch would be a matter of removing
pgmap ref grab (and nuke the __gup_device_huge function existence as I
suggested earlier).

> This I don't fully know:
> 
> 1) As discussed quite a few times now, the entire get_dev_pagemap
>    stuff looks usless and should just be deleted. If you care about
>    optimizing this I would persue doing that as it will give the
>    biggest single win.
> 
I am not questioning the well-deserved improvement -- but from a pure
optimization perspective the get_dev_pagemap() cost is not
visible and quite negligeble. It is done once and only once and
subsequent calls to get_dev_pagemap with a non-NULL pgmap don't alter
the refcount and just return the pgmap object. And the xarray storing
the ranges -> pgmap won't be that big ... perhaps maybe 12 pgmaps on
a large >1T pmem system depending on your DIMM size.

The refcount update of the individual 4K page is what introduces
a seriously prohibite cost: I am seeing 10x the cost with DRAM
located struct pages (pmem located struct pages is even more ludicrous).

> 2) It breaks up the PUD/PMD into tail pages and scans them all
>    Why? Can devmap combine multiple compound_head's into the same PTE?


I am not aware of any other usage of compound pages for devmap struct pages
than this series. At least I haven't seen device-dax or fsdax using this.
Unless HMM does this stuff, or some sort of devmap page migration? P2PDMA
doesn't seem to be (yet?) caught by any of the GUP path at least before
Logan's series lands. Or am I misunderstanding things here?

>    Does devmap guarentee that the PUD/PMD points to the head page? (I
>    assume no)
> 
For device-dax yes.


> But I'm looking at this some more and I see try_get_compound_head() is
> reading the compound_head with no locking, just READ_ONCE, so that
> must be OK under GUP.
> 
I suppose one other way to get around the double atomic op would be to fail
the try_get_compound_head() by comparing the first tail page compound_head()
after grabbing the head with @refs. That is instead of comparing against
grabbed head page and the passed page argument.

> It still seems to me the same generic algorithm should work
> everywhere, once we get rid of the get_dev_pagemap
> 
>   start_pfn = pud/pmd_pfn() + pud/pmd_page_offset(addr)
>   end_pfn = start_pfn + (end - addr) // fixme
>   if (THP)
>      refs = end_pfn - start_pfn
>   if (devmap)
>      refs = 1
> 
>   do {
>      page = pfn_to_page(start_pfn)
>      head_page = try_grab_compound_head(page, refs, flags)
>      if (pud/pmd_val() != orig)
>         err
> 
>      npages = 1 << compound_order(head_page)
>      npages = min(npages, end_pfn - start_pfn)
>      for (i = 0, iter = page; i != npages) {
>      	 *pages++ = iter;
>          mem_map_next(iter, page, i)
>      }
> 
>      if (devmap && npages > 2)
>          grab_compound_head(head_page, npages - 1, flags)
>      start_pfn += npages;
>   } while (start_pfn != end_pfn)
> 
> Above needs to be cleaned up quite a bit, but is the general idea.
> 
> There is an further optimization we can put in where we can know that
> 'page' is still in a currently grab'd compound (eg last_page+1 = page,
> not past compound_order) and defer the refcount work.
> 
I was changing __gup_device_huge() with similar to the above, but yeah
it follows that algorithm as inside your do { } while() (thanks!). I can
turn __gup_device_huge() into another (renamed to like try_grab_pages())
helper and replace the callsites of gup_huge_{pud,pmd} for the THP/hugetlbfs
equivalent handling.

>> It's interesting how THP (in gup_huge_pmd()) unilaterally computes
>> tails assuming pmd_page(orig) is the head page.
> 
> I think this is an integral property of THP, probably not devmap/dax
> though?

I think the right answer is "depends on the devmap" type. device-dax with
PMD/PUDs (i.e. 2m pagesize PMEM or 1G pagesize pmem) works with the same
rules as hugetlbfs. fsdax not so much (as you say above) but it would
follow up changes to perhaps adhere to similar scheme (not exactly sure
how do deal with holes). HMM I am not sure what the rules are there.
P2PDMA seems not applicable?
