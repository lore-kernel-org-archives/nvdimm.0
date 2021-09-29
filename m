Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E454E2FAF
	for <nvdimm@lists.linux.dev>; Wed, 29 Sep 2021 11:50:54 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TAT0OL007736;
	Wed, 29 Sep 2021 11:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UaAYKb5IxZkbBXjrtM7ebsiebY989QySwkecMKUkb50=;
 b=pNLCuGhufdb0WxUVQf9dMyozFvcXjFQv6axkhSJIab+uKqBZMYaxANJf8fPSNFvSJG+D
 mrPWsVzEiXkdoCyr+z3RLQfcHUD5n29rZ7ZyK7KPb6kIH4qBnRzyePepXoKw7Sl9hkS0
 VV+GtJz/NOmjgs2t/q6SoSPEMX+v8PRz+RTlnXf+28Ek9OJTyaFPvgIj86lAgsCo5N1H
 uUphwT/P3fqlKcojsZnSOcr0Y6mgZ/baRQ0QhdQSh3jN2wToUoWHKS7x//l+/fZ9Be/a
 QA1afzA+IhE5g8/uzcd90yu+/AjqLQpuOoyaJDe3StvpymuUpqEsIwiL0QiMJ7G5GmPk 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcvu47r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 11:50:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TBj2oG040324;
	Wed, 29 Sep 2021 11:50:27 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
	by aserp3030.oracle.com with ESMTP id 3bc4k952qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 11:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I23O1WYXDt+KE9r7acuglBuMrI+eGrybEhHSWD4mVf34WHQB/P+53aeQPqCptDwaFf208tKg3i4sb5n6KcLaeHwgqC2HFHxd7ET8Y7W6qVJ+S32EF3KWO/pucIguElyL5gegCpJNdUc/vwtXSPhfrwgnmRv/HbVhpdNn4Lrr4GSGf+7h0sHpt17sodo/hMxNI9OC1hugpFXwV2pNFaCelOCp0DqpIJ9zJzbtirclioOOgoLwAUaAAmHQriX3SSxi8bRClL+N6qTGmHJSHknLAYwl98SFtH1TT3xYTVxDiaOHV2KQjXW/MSROV4uxU1sp9NnmBtcP4+Zn22BQsKUfyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UaAYKb5IxZkbBXjrtM7ebsiebY989QySwkecMKUkb50=;
 b=NW7OzVT4c74lUweDAg2osen/xBY2VA7/64nZl3zJx6Lq4BbAdiYwO//z4ZOiVoYZG/ybV8nbZ/kpcHTT6TiJzHw8/sQbtZirAs0mAurB4yZwq5r1ltB3QLYRzFDI7+dbvvr9nRWi6p6/Een60NFbalLjAYccHBoNsqT/yx7nWElkaV4KnoXXAzcPiJwHuAqmWsRFgz8b2Au1YgOMJkK4Hng78u6fl8REa4lUk+29TEA0HExPatcVymVhdHr3ajJBTnvJTnAKfqtC2x3tfWIXF8Yu+NdnrQ9xRRXSJ2/SKWiVxpMTvn2eOAELJIGuVjKGANGrx6ad4RUNnH9I63XEog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaAYKb5IxZkbBXjrtM7ebsiebY989QySwkecMKUkb50=;
 b=gC/liGZg0nR+0tBs8fuNhInzJvf30nwpxAOXfQAmrN29oU/z83LFamaGe8md2sGnKHKECfVDuAfn8yZdXZUcfOYBXctYSkqtRag33LVhySl+OhXY6EyonPJmq2s8PEBu/ecjZH7pyHOfYbRbOK7vReEn/W72RWnG8pD1Amgu6M4=
Authentication-Results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=oracle.com;
Received: from DS7PR10MB4846.namprd10.prod.outlook.com (2603:10b6:5:38c::24)
 by DM6PR10MB2891.namprd10.prod.outlook.com (2603:10b6:5:61::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.22; Wed, 29 Sep
 2021 11:50:25 +0000
Received: from DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::6026:4ded:66a9:cbd6]) by DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::6026:4ded:66a9:cbd6%7]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 11:50:25 +0000
Message-ID: <3f35cc33-7012-5230-a771-432275e6a21e@oracle.com>
Date: Wed, 29 Sep 2021 12:50:15 +0100
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org,
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
 <cda6d8fb-bd48-a3de-9d4e-96e4a43ebe58@oracle.com>
 <20210831170526.GP1200268@ziepe.ca>
 <8c23586a-eb3b-11a6-e72a-dcc3faad4e96@oracle.com>
 <20210928180150.GI3544071@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20210928180150.GI3544071@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0061.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::25) To DS7PR10MB4846.namprd10.prod.outlook.com
 (2603:10b6:5:38c::24)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.165.148] (138.3.204.20) by LO2P265CA0061.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:60::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 11:50:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c7df32b-5590-4b91-9ab0-08d9833f52d7
X-MS-TrafficTypeDiagnostic: DM6PR10MB2891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB289179741EC47AEE7A2D0C34BBA99@DM6PR10MB2891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	SFaEjuly0Qy+bTpuBl9I8kDOuyL3bFnWs2UG7Zw9dYAAi/7V0ncjVK+RjUwLJFHjM9a4j4tFAOK1h8l7pKr41gAndfyx+pL4azXah0lsd9sGPg9TmXNQsSCRveoD59/WExyKCkmlSqcW0UT/9ooEys9Ibo2bzqFr9p3G83mPp3nBljOhBhyNfToiziroEFbwpHv5ZdnXJ9V4jR/6VbuWVHqv2wPvYqkFItVdk8jNEUOYfVAy46ZRdd93Sfdzw96wV0PFlyBvaEAufY+yxSy41Z/u5Zn26qlCr25T4yD2n1/Zv/BGtnTPGlGsEe2Q9afhKQr4JnUtSDEcf0i6z/FHow5b9B65E4C7uWsi6x8cNNg+WpQoyd6180HkV3d0LLgLwtVsNpVEsRBOYes4TCHdIFzXQPYuP6eHqXCcobX0EJ9V+/4r9wOZujyuqO1y8ZG7AIehlrHbCemVEK5+I06ljMkkJ+2KelTYewh64cWcUiqq5nZg8LFkY1S2Irw3CK27AzL7My/dnSbTeAprLtulVW+SI/fjOK66MjKr7C4xjosl4FDN/Q1OeW6/A/WySU4UhmM+Wk80IjmKpoRt4OQ3mNStEz6o7AaOuKa/F+1kozWQ0H9BL/BkVyQCqt2p0puaCnJxdArC4ReXMGt6gKYlVnuJGmbcvFVWqM3fUqRwNQIErzWuicqWUfeCKYphY2qsgsA7u2ykOBs6iPra1E1zlj1juGY69s454ia0Vtdhaf1QH+x1k+bMyigDA8ld1HHNvuzSHQUUiu+bNOpf2GwFsph+M6ekrHORFqa526uoesI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4846.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(7416002)(966005)(31696002)(86362001)(6486002)(31686004)(36756003)(6666004)(4326008)(2906002)(26005)(66476007)(5660300002)(66556008)(316002)(54906003)(8676002)(83380400001)(38100700002)(66946007)(2616005)(6916009)(956004)(8936002)(186003)(16576012)(53546011)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d2dIVUhtUXFrOFZCcUVuMElXNW12MEdPVlBQZHF3bWJpTmx0TkJxR3pBZkY4?=
 =?utf-8?B?YlBXVnNvVHRSSjI0VENTSi9TNWlWenlNUU1wd0F1c1NRK1BFcUdKaFlNNWk0?=
 =?utf-8?B?L1lSWXlKZ25PZHlFUE5QYjJZSDVsUmRUU2c3cmpUVkRnOHBSS3E4a0VrOHFt?=
 =?utf-8?B?dVpteUE2L3kvVnY2OWZ0UEhZSlhrSHcyeURlR2REdS9rYzZPVEljVzd4dUJt?=
 =?utf-8?B?NDJpQXNuVzZUQUdLbmd2TXRkOVJ5cUx1TDlDaUVFV0JUQzV1RzNIaW8yM3Jz?=
 =?utf-8?B?dThKdWYxMmw4M2JqMXBHWHN1YlBjSlhRQmNZYUN2b0o1b0Z5QUxhQWJuVzVE?=
 =?utf-8?B?NEs5L0d3aGM4SkdmcEdxUW5od2hDUmFoUFo5MTRTRHU3Y25RZWxpOS85NVh0?=
 =?utf-8?B?bGduMGM2TkhZemtlUG4rTG82YXh2cE5qVWI5NEtNSjJwYnV1UkM2bE5aSkFV?=
 =?utf-8?B?WmdJcTZJSC9GU0VCY0NlTkswQTdyei8rWTA4YTJpRkpGM0VLaVk5cE1Xand1?=
 =?utf-8?B?aEw2b3ArR3NtU0NuaFZaeTA0R1Bxc1BQRnJzbjF2SytFR09Zc1JuYkpuVUg3?=
 =?utf-8?B?bmJMa29PeDhXVDl3RjdrSHM4RkZ6c3NYWTduYnA2SUF0WjREbTE5Wm1Nb0xh?=
 =?utf-8?B?YkduYUFCd1NZd0k1SkFYUjVFVzVuODA0Q2JWYmFrWmt5Qm9CWEpuT0E2bDJi?=
 =?utf-8?B?bmI0WlJrUFhpL25WSU9YTG1mWEhVeUxiSUhSOEE3L0F5QWkyTmtTUUxIL2lj?=
 =?utf-8?B?V1djanJ1MVV4MFdoSFB1ZHFwekpJUVZxSnMrNG9rcWVmNG5OZG1uSWZ4ZjAv?=
 =?utf-8?B?TnNZWS9LamZLTTlFZ1dOeDlRY1FGenp6N0FXWmlwaVlpRDQ2L0E2aXI2VDVH?=
 =?utf-8?B?RkgvcnNmNStKVU45ckRJMlBjV1ZEUTJzU3B3aXE4R283L0liVXB5Zm00RnRK?=
 =?utf-8?B?Y0l1QkpBODVWQndNczJmaS94YmpLeS9TMG1wdlFBZ3d6NlVXY0pIeUR4SFU4?=
 =?utf-8?B?dmYrc3d3TWd0QTlOS1gzMlh4RVdTWEtHekZhSGNkdWhkS2dRS3pwd0VaNGpy?=
 =?utf-8?B?cGZ3QmNuM0gzYnc5M0cwei81clRXellOYWhDdkZkWEJxWW1aZm9aYU5uU3Qw?=
 =?utf-8?B?UGpNRlpKMXgzbnQ5ekROazdSemZ2WVRLaTFVTWFBTk1DMTM5RDhZN2gzYWdG?=
 =?utf-8?B?MXB6MnBWaFQyTFpNU2MyaXZtRFJYdWZkOWRORDZBWnBHRnJoT0pHdVRaOExt?=
 =?utf-8?B?TU5yUjZpNFR2TkJuazc3MXJyS01JcVZnRk5BdFZGWDBFSUN3amZJc2srOEJa?=
 =?utf-8?B?ZC84U2NtQStGeER6NDNOalpvbW9zdGNMeE1SWGtLeFo2MzZWcm9GUURKZ2hB?=
 =?utf-8?B?T2hwTDhtZzNVSHlXbnhKOTNKOG56ZjhFbkZKSTVzUXJTUnFTUDlWYzZqeEc2?=
 =?utf-8?B?Z2JTOGdYMmZ6S2VmZGxZRHpmcmhDVjNJMVpRUFV0SU5iaWhpTURFZDBMUUUx?=
 =?utf-8?B?d0hIcTJSK3V3VkxGUUNDNmhoUmh4c1RUMWQ0bGsxV1pZclZGTVA3NWpNVWhm?=
 =?utf-8?B?TjgxaDN1dm9zOXN3YkJnR1IzVjF5eTI4QXRpSUNCUzV6Q0g1SzhjdVNJNzBL?=
 =?utf-8?B?Und4ZUQyT05PSnpLR0tUcGFqamFQSkpvWE1NRmZobnpoWkVKVXo2aG1IYVA4?=
 =?utf-8?B?RUY5RUpZS3hWMVBWNHZ0MkZlakplQXRDWjlXZ3g3cDhEUGJEUDYzM0MxMVJK?=
 =?utf-8?Q?KCvO6V1QiGA3RSaXksFCHeNG8oS8WS0PO6hfgBJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7df32b-5590-4b91-9ab0-08d9833f52d7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4846.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 11:50:25.0882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZHfcXbup+RRBxPJhASIhuY92nv03jO/1/hb8hJKuLM6muGZIrPl5Y+ECQaH1CrXNr9elF2ng4/yz1tvHC05URrxPFikzzfvTht1B4c5Lfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2891
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290072
X-Proofpoint-GUID: 8n4dNnBT-Cv681cr8crqFi55Hhon0Rb4
X-Proofpoint-ORIG-GUID: 8n4dNnBT-Cv681cr8crqFi55Hhon0Rb4

On 9/28/21 19:01, Jason Gunthorpe wrote:
> On Thu, Sep 23, 2021 at 05:51:04PM +0100, Joao Martins wrote:
>> So ... if pgmap accounting was removed from gup-fast then this patch
>> would be a lot simpler and we could perhaps just fallback to the regular
>> hugepage case (THP, HugeTLB) like your suggestion at the top. See at the
>> end below scissors mark as the ballpark of changes.
>>
>> So far my options seem to be: 1) this patch which leverages the existing
>> iteration logic or 2) switching to for_each_compound_range() -- see my previous
>> reply 3) waiting for Dan to remove @pgmap accounting in gup-fast and use
>> something similar to below scissors mark.
>>
>> What do you think would be the best course of action?
> 
> I still think the basic algorithm should be to accumulate physicaly
> contiguous addresses when walking the page table and then flush them
> back to struct pages once we can't accumulate any more.
> 
> That works for both the walkers and all the page types?
> 

The logic already handles all page types -- I was trying to avoid the extra
complexity in regular hugetlb/THP path by not merging the handling of the
oddball case that is devmap (or fundamentally devmap
non-compound case in the future).

In the context of this patch I am think your suggestion that you  wrote
above to ... instead of changing __gup_device_huge() we uplevel/merge it
all in gup_huge_{pud,pmd}() to cover the devmap?

static int __gup_huge_range(orig_head, ...)
{
	...
	page = orig_head + ((addr & ~mask) >> PAGE_SHIFT);
	refs = record_subpages(page, addr, end, pages + *nr);

	head = try_grab_compound_head(orig_head, refs, flags);
	if (!head)
		return 0;

	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
		put_compound_head(head, refs, flags);
		return 0;
	}

	SetPageReferenced(head);
	return 1;
}

static int gup_huge_pmd(...)
{
	...
	for_each_compound_range(index, page, npages, head, refs) {
		if (pud_devmap(orig))
			pgmap = get_dev_pagemap(pmd_pfn(orig), pgmap);
	
	
		if (!__gup_huge_page_range(pmd_page(orig), refs)) {
			undo_dev_pagemap(...);	
			return 0;
		}
	}

	put_dev_pagemap(pgmap);
}

But all this gup_huge_{pmd,pud}() rework is all just for the trouble of
trying to merge the basepage-on-PMD/PUD case of devmap. It feels more
complex (and affecting other page types) compared to leave the devmap
odity siloed like option 1. If the pgmap refcount wasn't there and
there was no users of basepages-on-PMD/PUD but just compound pages
on PMDs/PUDs ... then we would be talking about code removal rather
than added complexity. But I don't know how realistic that is for
other devmap users (beside device-dax).

> If the get_dev_pagemap has to remain then it just means we have to
> flush before changing pagemap pointers
Right -- I don't think we should need it as that discussion on the other
thread goes.

OTOH, using @pgmap might be useful to unblock gup-fast FOLL_LONGTERM
for certain devmap types[0] (like MEMORY_DEVICE_GENERIC [device-dax]
can support it but not MEMORY_DEVICE_FSDAX [fsdax]).

[0] https://lore.kernel.org/linux-mm/6a18179e-65f7-367d-89a9-d5162f10fef0@oracle.com/
