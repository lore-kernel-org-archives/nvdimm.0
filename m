Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D272
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 09:36:37 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S9WmrJ007254;
	Wed, 28 Jul 2021 09:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3XisROq/l6NCSm/pLxK3eJ0II3aUhL9aIqdfBYeUy6U=;
 b=Me4gbLPGL6zIG1kVjVz1pPoDADqu8SV3c0hLIwKcDskqh4FcNALI5kWSMouVWmu558EV
 PSx8KS5aMykU912vG4tmxSjZfyehaDvUbAPJOcjTJMln3lm0UeBg3KaccTfu8xnIVQz4
 O+EaO8yhyUymWA1DJyJee3Pz/+zivyVCKZWxKh0sTqTOcYXC8d6RYAzZu/bXsX1aBH8m
 TZgko34xY8wYHAmApCZ0H5WjxroP76T+n/9fnHbRFlE3U9NU6mDhk/0EwG2miHEkHa9r
 BxoHmp4R29dksmPNtTLChZIOCy8khtLH+ODSJaL3s+YIx8jB4KZnCO62K38dHe5ERqTD 8A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3XisROq/l6NCSm/pLxK3eJ0II3aUhL9aIqdfBYeUy6U=;
 b=Dj8bfSJmApQfr+FdQDj4C/UBlflD260YWLfwAOhe91DZuMSUbfc19xkmH4qQuCRUNCqP
 0KvMLXwEqetkZ4jlNKumLhX0yqzMyw4bQGk9hdKy50wpBF4Ibb1yz5/iC/dRJdxOSDHm
 sPxffDGHUQCkIIX4bt2SfXFkk4A0/dEmNcefk9e7rUIZ8R+oI42uQ9kkorhX5q84SeZ8
 Ux5xyii6FiQmN9VLudUiiqkePXfS68NoojDcIbnp7DMROWq8/TyoiQ4xjXegJeybpyg1
 ORqkot0w/tbKgRdWQXpLPnNrtR2t+vQ7k6vDuorb1YeulGtcRxpAZwcshlml92CdFpNW oA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfa9hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 09:36:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S9YtXS075837;
	Wed, 28 Jul 2021 09:36:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by userp3030.oracle.com with ESMTP id 3a2354tat3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 09:36:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIYWaePl9MfYcgQn+jJgWRnLZkVVB0lLZ6Kmozmy8BCSVmB6oRF9BIdNlexpUSjQdKBv7aXq42ZCPldQnWJ3EGwDH6UAMl2M25pAF3JwPb7YZ/auhceU40GBczc6m3NFxdCsHYcF01BPjI7akci7Wz8oNyagZRjac6UygFgCSF53/w1iSbFxBBGJNdu7Uq8L+GoKm1lUkKYZI7XHrQe+CMwvuMSSaciqYzDQASWg2FIvbxV/3C9qCq1uIO/56/S4QmwjQMcZYAemnlXe1vzY64nUkBVkcoSXYoXW9F7Y9z53QHTNh8JhlY0rWU+BNHqdr1UMMH6CFlDkz0mBy11N5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XisROq/l6NCSm/pLxK3eJ0II3aUhL9aIqdfBYeUy6U=;
 b=ay7H0NoVvOfPKSnyrZIwscwqTtO+J37z9b4JEe5m5fltbEqev9OSyehLiEge09RkN+UHblYP/EgcVvslF23nyjwtLvstZbXRIBID1MAv8v9ZLp9X14+WUBRzOXrvIsXHIzqLjp5pSllq2gxXQeQN0adj7VBGR2mfHeVnZptQNT4GK5eTVoUPdmggnNN3O7sqUeyH8hMYfDfI4PqkqQjHu9t5MOYYCJL9KSDSzWc/nWHbjqA6fOa9JRIkxYTJXan2kELpquCiv/dbYF/jwFfjex7fsrkB6EoBYS1OLEsk5+OuJhfFmOUNr0Ikb4aowW+MJl+ijnf2TvsPfhfe2mKitg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XisROq/l6NCSm/pLxK3eJ0II3aUhL9aIqdfBYeUy6U=;
 b=uE+p4MX/QBBU4cay4ADCdJ9x6QasrdizHPNjjV3fmWqQmbCUNnrUFv56EPyCE4wiqKxwGIAG3PnrtUaBm/MwWVT7J/7kS3Rv3X6gXLUWCxe7XjXGklNJoNGzAqEUT++iDMzuzDbQoUXrFmM3SXgVn0p6j5DTiGMnEzqcOgz81J4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4208.namprd10.prod.outlook.com (2603:10b6:208:1d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 09:36:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 09:36:12 +0000
Subject: Re: [PATCH v3 12/14] device-dax: compound pagemap support
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-13-joao.m.martins@oracle.com>
 <CAPcyv4h5c9afuxXy=UhrRr_tTwHB62RODyCKWNFU5TumXHc76A@mail.gmail.com>
 <f7217b61-c845-eaed-501e-c9e7067a6b87@oracle.com>
 <CAPcyv4hRQhG+0ika-wbxSFYrpmMJHxxX456qE64PMxDoxS+Fwg@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <156c4fb8-46c5-d8ae-b953-837b86516ded@oracle.com>
Date: Wed, 28 Jul 2021 10:36:04 +0100
In-Reply-To: <CAPcyv4hRQhG+0ika-wbxSFYrpmMJHxxX456qE64PMxDoxS+Fwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0080.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0080.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Wed, 28 Jul 2021 09:36:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b527db2-3ffa-498f-c4eb-08d951ab235e
X-MS-TrafficTypeDiagnostic: MN2PR10MB4208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB420829DAB6BFB5D3C549E07ABBEA9@MN2PR10MB4208.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	OrjN2nt7KJFAcNuLCixVxFON7GbsHkPQj3jWt6wm8XcDqQ5+K+fcowZYsjzXZGk+q3ECuCHIwD7ui0ALonhvGpm5g4/DWT9E3dkEJe6Af7rpJclza0NxpLB70WzDUD+H6rN6i9raGSstArXFVNL4zjoXnY963/tGayQ6qXIzPq82c5XtY5MThHv55rassUDwcv866uCagSLcm6mDCVTAByCI29YY8DLUsk+vZDpHW5VGjg8P48TipYNNqNheYcEdLvZSWLMVln5qa7A6/jxhNaa8gGaH1wGgcOLHlUvi9TZL88YgnBT8yvfkvHuAtAQ+QmZ32LRkrOEjuf23wF96ydT7F3QYW4QhE8duM8sodJyJHt2Sb7Japc/tOWIK7sUUnSAQfWuyYOg0xyDy6skWhs5Tl7gvyYnW9UUtZpliSySKJHqCWqmv52q+WX2RraODlcNa0TJo76d6elrP1mCL6J1XGqIEhr4ZJeUqCN7eJcg4zjZcGwIaIxxDtRnubeh4FkGjR+zLYEy4eZrm9N2zPTclMYf3nJ2vFUWN+2U84inAPF0vQpKvn3okDR2lA4NvD2TLXk2MPhZcdQVNJIr6tcHRnVcSUxViPsgXtva3VVxp767bs1DHZDU8wBIjynAenYjYd7hWL75x+Y8dHrQgkignz/9v6vGmUwJ+fBi3oT0a25m7VeTCg6fEJL9fwYcWMFEPvUmovK3jdD7pmVZM5g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(31696002)(478600001)(6486002)(86362001)(8936002)(2906002)(66946007)(8676002)(38100700002)(31686004)(66556008)(6916009)(6666004)(53546011)(4326008)(316002)(16576012)(66476007)(2616005)(7416002)(36756003)(26005)(956004)(186003)(5660300002)(54906003)(83380400001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q0d4RHdueEhreDhtWDd5d0FrMXBFRjNLNHBJNVpjL3JFeGFIM0l1NEt2blZN?=
 =?utf-8?B?bVZvTkV4emZPN1VlcFJXejA0bWQ2MG1QN1pxeEZMMnV2SWZVaWdrclN6dnF2?=
 =?utf-8?B?RzgwUU5LVi91NHVLeDZZN2g1NTR3R042NzRIcVpTaUhCTTZHYk1OcG5VZVJH?=
 =?utf-8?B?T2l0SXNLelczRStKSGFhbzlvaVRmMzkwTFo2aGg0Z2l6cGdOT1RBZUlOQ3JJ?=
 =?utf-8?B?eGJaTGN3ZUt6ajdlejM1N0hPZEM2Yjd1TklST0szKzZWQkdDbU1IODhOZEpz?=
 =?utf-8?B?RjliTWJFMEcwbktzRkJWa1F0VWRXbXBiendzemlZNlozcUoxLzFZOXI5aER4?=
 =?utf-8?B?RmgyRnpWZnNaa2FXWlNwQVFLQldqdGIzeDczd0FhU2R6Ym1uRzBzdU1MOURn?=
 =?utf-8?B?WE1ob1l3WmsyeGQrU0FtYlZvUUNvNjZmemtUY2dNeGppUVRJUjAzZENxRzd0?=
 =?utf-8?B?eXBIMjUya2NPdmdTeEwyMks1M2xyRjY5WWxjS3J4T0NaVFFHL2VIVVFTREpO?=
 =?utf-8?B?U09NUWowczhsNFErYit2VE1BQVNzaUxxTGFod2o0bk9oNU9xV1oyNElsZVlU?=
 =?utf-8?B?U2pCK3JGZzNGK0lOai9xZUZGNlFKU1JSbDRxaVlGcmkyVWZReTFJZ09kL1NS?=
 =?utf-8?B?WDQ5QWoxYksvRmc5V1hZMWQrMHlzWjZhajg3N0JKczkzL0lpY1ZyeFBPblFn?=
 =?utf-8?B?OXAxaTQ4Qm5qay8xK25kMXZEZTBBa3VWbk84UzkzRUxqTWtBRG5NV21nOFBL?=
 =?utf-8?B?YmRDdkN6VFZ1ZUlVZHBKVmsyRkp4TDN5MU9LN3JNQ004SjdLQ1NjazBzMlRH?=
 =?utf-8?B?UmIwaStqSkVQWEhQSWY5NUk2M3ZaZ1JyajRYbUE5WnB4RkRHZFZDZ1VpSnBM?=
 =?utf-8?B?a0Y2dmxkbk10Tks2cE1aeFZrM21GVlBxKy8zTXNvV0dEU3pQVkdOVE8xVWJz?=
 =?utf-8?B?SktvamRYNDZYUjhVTFdidFNNU3VFbnpCdUNERWFxUjZ5RUh3WUlTUHhFK2RY?=
 =?utf-8?B?OVl2NlFwQUZQYjc4a3lrc1RCb3dPYkUvZ0tpTk9wNVB0YU4yL2t3UnVlUDA4?=
 =?utf-8?B?RklGK1p5MlR5N1ZvM3hoMUNPaFphT1FhOWI4aGIvK09mZXduRGpIbytHd0pt?=
 =?utf-8?B?MGdXZzdlUDJKdGYwWExaSVNrL3NzcFJROXNXeXJWQlpqUTkxdnZOK3g4Q0Vs?=
 =?utf-8?B?SmJlV1ZtK2VPa1BXUHNhSWZrTUJIS3J0N2tNLzg2MTZ6dEdhYkF0RDFFQkho?=
 =?utf-8?B?bkdBMkZrdk52bmlQTDVPVFVtWlR5WWJZMmdhQmZHYkMwaWNYUHl4b3Z4aUJK?=
 =?utf-8?B?amYrSGE0bk10VmZ1YmFFUFhpWldLY3cxektydDE5a2t4U2xzU2J0UVZ6QWls?=
 =?utf-8?B?ZmZKcHZSSVk1QlA0QStlWDJBMTdXS01ETmE3V1pkS0N0YXozUVpCQkxNb2dN?=
 =?utf-8?B?R0RibVdSZWNKVUNiRXdDcmF3R09kZHdLS0d1ZDh6M2g2c1J3UUlKM3d1aUsx?=
 =?utf-8?B?UDZOMFNsVk1MUnNjL2NRZ3ZTS2p5ekcyTmJBQjlGbkwrcWpCNHR5MEUrRjRT?=
 =?utf-8?B?YnVTeGR2eDdFU3QvYWxvVWtCTnZ1Z3ZaWW5WMG9CeXVpZmJNTzRBMnR3RmMw?=
 =?utf-8?B?V1pzTDV3SWtQdDUxWDFEMmIwbmpwT0VNOUI0SnlEOXdITWw1aWJJcmxkZTdz?=
 =?utf-8?B?eUpEa2h5K3dSN1o4VHZwV1VuZGJVSWlrL0w0VW9jSXdBMlhueVUyazhDazFD?=
 =?utf-8?Q?KkKycPA/TdnJAfPnhzGAfuqmhSBkRBkGQxjqxrI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b527db2-3ffa-498f-c4eb-08d951ab235e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:36:12.5352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JshuqY2JLCEk0aRy0IwHY+lsX3z7SNqM7vuNte+0DiiliG4uN4D/Pvoy9U3tyouES/CuF3fwt+/6RvWXzx4VGs/wY5Y6ZXcCvjsiZ4ckMuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4208
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280054
X-Proofpoint-GUID: BVV33lF9Fwuo9OvuuhxZnHo7SyptIthn
X-Proofpoint-ORIG-GUID: BVV33lF9Fwuo9OvuuhxZnHo7SyptIthn

On 7/28/21 12:51 AM, Dan Williams wrote:
> On Thu, Jul 15, 2021 at 5:01 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 7/15/21 12:36 AM, Dan Williams wrote:
>>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>> This patch is not the culprit, the flaw is early in the series, specifically the fourth patch.
>>
>> It needs this chunk below change on the fourth patch due to the existing elevated page ref
>> count at zone device memmap init. put_page() called here in memunmap_pages():
>>
>> for (i = 0; i < pgmap->nr_ranges; i++)
>>         for_each_device_pfn(pfn, pgmap, i)
>>                 put_page(pfn_to_page(pfn));
>>
>> ... on a zone_device compound memmap would otherwise always decrease head page refcount by
>> @geometry pfn amount (leading to the aforementioned splat you reported).
>>
>> diff --git a/mm/memremap.c b/mm/memremap.c
>> index b0e7b8cf3047..79a883af788e 100644
>> --- a/mm/memremap.c
>> +++ b/mm/memremap.c
>> @@ -102,15 +102,15 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
>>         return (range->start + range_len(range)) >> PAGE_SHIFT;
>>  }
>>
>> -static unsigned long pfn_next(unsigned long pfn)
>> +static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
>>  {
>>         if (pfn % 1024 == 0)
>>                 cond_resched();
>> -       return pfn + 1;
>> +       return pfn + pgmap_pfn_geometry(pgmap);
> 
> The cond_resched() would need to be fixed up too to something like:
> 
> if (pfn % (1024 << pgmap_geometry_order(pgmap)))
>     cond_resched();
> 
> ...because the goal is to take a break every 1024 iterations, not
> every 1024 pfns.
> 

Ah, good point.

>>  }
>>
>>  #define for_each_device_pfn(pfn, map, i) \
>> -       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
>> +       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))
>>
>>  static void dev_pagemap_kill(struct dev_pagemap *pgmap)
>>  {
>>
>> It could also get this hunk below, but it is sort of redundant provided we won't touch
>> tail page refcount through out the devmap pages lifetime. This setting of tail pages
>> refcount to zero was in pre-v5.14 series, but it got removed under the assumption it comes
>> from the page allocator (where tail pages are already zeroed in refcount).
> 
> Wait, devmap pages never see the page allocator?
> 
"where tail pages are already zeroed in refcount" this actually meant 'freshly allocated
pages' and I was referring to commit 7118fc2906e2 ("hugetlb: address ref count racing in
prep_compound_gigantic_page") that removed set_page_count() because the setting of page
ref count to zero was redundant.

Albeit devmap pages don't come from page allocator, you know separate zone and these pages
aren't part of the regular page pools (e.g. accessible via alloc_pages()), as you are
aware. Unless of course, we reassign them via dax_kmem, but then the way we map the struct
pages would be regular without any devmap stuff.

>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 96975edac0a8..469a7aa5cf38 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6623,6 +6623,7 @@ static void __ref memmap_init_compound(struct page *page, unsigned
>> long pfn,
>>                 __init_zone_device_page(page + i, pfn + i, zone_idx,
>>                                         nid, pgmap);
>>                 prep_compound_tail(page, i);
>> +               set_page_count(page + i, 0);
> 
> Looks good to me and perhaps a for elevated tail page refcount at
> teardown as a sanity check that the tail pages was never pinned
> directly?
> 
Sorry didn't follow completely.

You meant to set tail page refcount back to 1 at teardown if it was kept to 0 (e.g.
memunmap_pages() after put_page()) or that the refcount is indeed kept to zero after the
put_page() in memunmap_pages() ?
