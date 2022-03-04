Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F53C62
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 12:24:41 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224AMivk019607;
	Fri, 4 Mar 2022 12:24:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=21FHX/RC3w5Y+vHbWPBEM+B78U3WV5harCh8hQyEgK4=;
 b=0s8LO+1XdspIyPQPvMcE5aIq21Kq9TdzbKr4aYjg8tBZyzuMqhTJUPRcou5gL52ophLM
 e7OycUUj5njlMEJBEJAdEv6xqBla6g54YVpsfAwdAAKPSlQ6gb3zzUrruSqikpO/gVqY
 ITJG48Efmo15IvPGGPBqLpH5nKo4/nf1oWzbX4bnb1ivMPv0tn+09dYVOnax3TTyP0r5
 2dyxVaW8Fpf34ycgECWMjD74S/VOtTTmFFEFPqtw22PlAYYDnvZYqgYBTQl20Akd/7Nq
 U+g1xIA94Vry5DDEvCRcUej2yNvOGnBR6atg/0wl08tM5YAUkswB+Xwq+IZ1FfXzmNLO 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hrsnnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Mar 2022 12:24:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 224CFOTL133106;
	Fri, 4 Mar 2022 12:24:28 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
	by aserp3030.oracle.com with ESMTP id 3ek4jgsbsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Mar 2022 12:24:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wuki0vVg5EznYMPq1dR2NiDv8sHG4XpaIs76UgvtRDbN0NYS7W2qoKHF9wI7YE7sOCNnhrSUsfi+8vFRyZ7mG94i4ZpFCXn6Alx/ridUcxu9av1AI9gNMF+duaW4K+PUkUuoyPcpA7Rr9vuFrAV/e+nxmXgk2ol6ZY9cH85VG/YgFbIuHzIXIGZiFpJbWHhh3z5glu3oz0zyShIyVO1N0akYefL69XxlS0kWUCpJi7vPaaqCna72wy68OjcBDEyZFdkb/Ih7kUTCwQIu0/YyQ7uU/e42sOgY8fLv79jIW3fXAzCS3aaPGMLS4YALkUO7LFlIgVIywEx/OtueRXYn3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21FHX/RC3w5Y+vHbWPBEM+B78U3WV5harCh8hQyEgK4=;
 b=jTCDGMflCSIPYsYIuxaSibhw9mzNCuIOKehnprGHFhgHHc9RsD9SCG5pA0/h+9lSGesqiwsHQkJbkPzDi6kTLVA8OzEiO56PZauhQhoezAbXUqft8Jzas/dp3hMLZl4p+Ufrp3Ba4bJoJXX9zgBXLIBRRNg492bdnLvArNXWJuAy+g8ysFgdnK4KAHXoyEH1BVhQz7Vp3hFKZBDlWmLMnX4jOGeW6lStNkSkbW74xbNa677JCaR8leK56quqHBlqqOyNf599lA2LZ3fgfac7/YlZMpmaLVwY55R7ZTGef2cJZAlzlPdWrjEW/ltw4U7B0OGp0fMf6a/p0cW19zbLqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21FHX/RC3w5Y+vHbWPBEM+B78U3WV5harCh8hQyEgK4=;
 b=mDktltXvThK8WkXscYptklPDAtJ70uXPrEujij25y0FVXVKMRsKF4+JV8FXTsLo34A/jFXn1axAtQKJs5QQlndlQ5ot3x5JIafkNAwVxmn49R6984ZFxzXllkZkVdlj9cTCbZWD0Btc15/coUqu1HFDK0SOuoRpfH1VaGYdX7es=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR1001MB2370.namprd10.prod.outlook.com (2603:10b6:405:31::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 12:24:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 12:24:26 +0000
Message-ID: <06b708d9-87c9-2d70-ccf2-3ba858435208@oracle.com>
Date: Fri, 4 Mar 2022 12:24:19 +0000
Subject: Re: [PATCH v7 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
Content-Language: en-US
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
 <20220303213252.28593-6-joao.m.martins@oracle.com>
 <CAMZfGtV2-NKPDxvOjCnCzAJCwG_3D3F_CO44iNfOJuwTy3Nirw@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtV2-NKPDxvOjCnCzAJCwG_3D3F_CO44iNfOJuwTy3Nirw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0451.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff08a017-66f8-4a02-d640-08d9fdd9ec2b
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2370:EE_
X-Microsoft-Antispam-PRVS: 
	<BN6PR1001MB23706C85C7333D80437A3FA4BB059@BN6PR1001MB2370.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	X1Pfh/z+BBoCA7QLrAr/J1CwXrAAUQ0R1agx+O56vYTCo65jek722ZlQq5+zR3tsF6zXGLyf8q3PWtzR67rikZCPB7vA6ETKG39l9epRk0C9FT86JsYTYzM4iwTZlpL/sE4L/IRd06zxDkEHPi4pfRlS4As90wVWhCl8nnR+S9n6dEx3HRBKfMNU+npgxz7jGXkHk7/Gydm+DCDSKwiULZqCAPv95gzNMny0/sEZxiT7lj6f0q7csASboUCD5vQfuH85jzcu7OFSEpQIUEJ0cHq0pjU109aYTIrCV4I+eHOmt+01I4mkXwHdYZ5egabTIZd0xS4KNqD10qR98KMcQlSHM3r2GcyWdRLQFOIpmXj+GnsgiKLUCugyAV4JRhxSZx2KpWKsI2yE6oywRy2aq/KhD9xkPQbkPqgAmyE60SGOdFoasFN3XyrIq5wSWdkaT9XDzj3/MRdhEkMyI+TdKRcVqkXGmLEi9q88DWxrWNG0nIprFl9y4YjmM8Qr/Z6KpiXQe+U+tRRnXmndaCi9SIFUPZUj+uaLHbClXDWOdRM7W+riG60rU+B0hvB4X9ocIlqQ6+87yiEuwBb2NB3kMqzCjdLKDggSLJVZSbYtISEMaViaQYrZ8hbdinRAlJH58loBc6LxFqrgj2Y91wfDPlAfWtT/tBzhW0u4VQNfgwiS3Pk2BQbm4yGsyi+OiQPzYU4dbE8fvd6nHvH8ax3UFA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(31686004)(66946007)(6666004)(66556008)(5660300002)(66476007)(7416002)(31696002)(316002)(6916009)(36756003)(38100700002)(53546011)(6512007)(6506007)(2616005)(8936002)(86362001)(26005)(83380400001)(186003)(8676002)(508600001)(2906002)(4326008)(6486002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Ym9GQmo4T2I1bnpybUhvUzVncmo4UTZjVmRCNXVuWnhmN1cyeUpSSFhaOE1a?=
 =?utf-8?B?WGRsTUpUZE96NWNKMDlDd1A5WEJYZlBQUjBtYVpaRXppN0ZReVZrYXNRMExm?=
 =?utf-8?B?RUYrelppNTZZUnZuYjBTR2VsRXBmOE05S3dFTGY4RUtnNDlncDhvU3pqbnYw?=
 =?utf-8?B?UDZRUkcxQ0UzYzVpUGptRVA2Ym5xZEwyc2hnbnEyOUdyb0tzaGkwc3FmdkFq?=
 =?utf-8?B?ZHc2dDAvWkZHaitZTExkSTAydzVZdGRqKzlhVmRmVk5VY0pYWkt1Sm45S283?=
 =?utf-8?B?UXlZVjg4T3N0VDlRQjZydGVuRmRPbkdWREdaWFhZZXViemlwTTlSN0RrQWZi?=
 =?utf-8?B?UmlmampyRUhSdnBRVVFWK3BhOEM5TXBocnhqZUdkNlpBYjQrWVh6OTRCSDBo?=
 =?utf-8?B?ZFNLU1ZVQXZub1IvczRESkNMN3FhbTJhUStlZlhSMjNNMFpLZDZScGh6d0ZV?=
 =?utf-8?B?ZDhiU3FvdURxV1Y4V1hlV0dzcUpKeEwyaENTZ3ZWS1RES252VFMycVVTV0xz?=
 =?utf-8?B?WXdwNDVnd1dVajlPOHNGdEVnSWZ2MVhPOHV0UE0yeExPNWhsZXppK0E1QkRU?=
 =?utf-8?B?OHBKL3NVZnhnQ1B5bnp4Q0xQK0tQczAxZm9oN3laaFB3V2RBYkdjZHpCZjFK?=
 =?utf-8?B?TGlKSzZLaXZGa0h2dVVxTnY1SVNIcUo0Rzh6YkYzaDRmM0xNeVAxbmUyak5i?=
 =?utf-8?B?b05ESTVPYTBNZy9EWitpVlRwR3M4VmR2aVpNMGRRYjNHTUdwN29WWDdkMXdx?=
 =?utf-8?B?U3JPamwzMVNXdjR0SGVlSlZxZzV6VEtMS2J3WXZHbGR3ME9mUXVkSEJoakEx?=
 =?utf-8?B?TzJLdHpFSlZiTUdqVE5hbWF2UnpGZWpnR0V4aG0yRzdPZ3lISEh1UUkybDU0?=
 =?utf-8?B?eGd4UjJIODhUaUtJdnZjVm83djJGU3U4bW13SVhNLzZ2UUIwSW9LbXFZelZ1?=
 =?utf-8?B?V0crKzhuT2szTjJsanh4SUhQUDBKZlFSTnZXdlBRejRmcjU3VEMyVEllTmpu?=
 =?utf-8?B?ZUdSeTZkZy8vUWYreTNZUG9UbnJqQnBTRkswZmRZODlRbFlOQkVxK0d5cDlJ?=
 =?utf-8?B?Ry9Oc3l6eDNKbjJSV2xFUCtHUnEybnViM2RXSlJJTUYwWHlDdGZOT20vTTRs?=
 =?utf-8?B?c3RudHEvYU1TdVhWOHVuTGlBK3YzS01LRmk3WXRCRXBCNlpESy91L0JFZFFD?=
 =?utf-8?B?OFFELzZESzJ5T0REeGl4a25lT2xBakl6NDA5cXNlQXpWQTN0a2JCaU5OUUZD?=
 =?utf-8?B?MHRpckgwOUxHWERYWXU0NkViR2UyRTh4YWN6Qng0aFErMUtST21EVlN5NnVY?=
 =?utf-8?B?OGdkTFF0cWZZb1RwUkdGVGlGV1FLYWUzcEViYnRLZUdqWG05TDhPRHFQM2RM?=
 =?utf-8?B?TVNFUm5jRnE3dTYrR05qWS80TVl0c01vMVVzTVZXa21lci9GODVPenVpdjJM?=
 =?utf-8?B?OWNSYXRnS1JoOFg3cFQ2dDNHY2xGS0N3QVlSczNQdUhVOTBkcHVDb3p1Qnh4?=
 =?utf-8?B?TEVmWEd4RFpNYXgxS1hYdVY0MlZWTTZqbkNLYnpDSE5FMjVGUDg2NXBBOGEr?=
 =?utf-8?B?KzNjVG1kdm5HWVZ0QTVYb2l5VWE3QkNCcUFjNmtMeDRoTDJqSzFPQ05TYUJV?=
 =?utf-8?B?dTBRYW40ZDJNK05OKzZxa0tBLzFuUmdpNS9IUEZvUGVZMmxrNjRObDhyQ3VR?=
 =?utf-8?B?UTFwNlVVRUFxL0xDeHdsZkh5VFlEcTdpNVNjYm1xdHZCYWRKSkkrT1FET1NR?=
 =?utf-8?B?bC83cFVEdnQrbTAvWnJsWVltcUI5UUliMWtnZ3R2VzE2QklrWENQcUlMWWNy?=
 =?utf-8?B?NkI3WG9HdHhkMExRODFTRy9iMUtlcVhCZ3FSSmFLTEt3R1hwT2Rqd0Z5WWdi?=
 =?utf-8?B?cGNGWUszYXpSU28zL0hTd3d2VkdDVklweUcvMEhRNURFSXBvNEhLZVdsQmF4?=
 =?utf-8?B?V0N5a0lZNFN4NmtoanBvVnhRbWt3SnhGMTN0LzVsTllNTUpmR2VxWFRBN09z?=
 =?utf-8?B?SitzNHFTUjA2RmI2Z0p0aFR0Z0x2MDZ5R0I0K2ZrOW9VM29KWlc3WDd3by9s?=
 =?utf-8?B?TmVIMmhyVit4NGluYjJPU1hneEc3aWNiRSt5dXUzM2htZVpSdzdpRFBTOG1k?=
 =?utf-8?B?TUxsV2NXZjA4dWpUQXNCOXIyZmVsOWxwT2Q3WTVjSjJRMlhwcEw0NU1iZjVj?=
 =?utf-8?B?ZVgvY1g3WHFoTzN3bktuOC9pc0RuVzBjSG4rZjBpWlBFNGlLcUpGclJQSlA4?=
 =?utf-8?Q?kAfqWfNxpq5jRyaCGrhFUQrGE/wByRlFfdD/exzye0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff08a017-66f8-4a02-d640-08d9fdd9ec2b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 12:24:26.4474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XeIUY9NpqurMTVFVmZAcDVaaJxFPL7qJDiNsN4mGmcBCbN4tFv7VgOcfsLjyQ9Az2Vi+A5uL5XyqPCqnWQW8fYcVJOTJvRR1lOuxyQlmlBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2370
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040067
X-Proofpoint-GUID: z8NCskoro7SIQxlFd1brB1ZSjPOA7P33
X-Proofpoint-ORIG-GUID: z8NCskoro7SIQxlFd1brB1ZSjPOA7P33

On 3/4/22 03:27, Muchun Song wrote:
> On Fri, Mar 4, 2022 at 5:33 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Currently memmap_init_zone_device() ends up initializing 32768 pages
>> when it only needs to initialize 128 given tail page reuse. That
>> number is worse with 1GB compound pages, 262144 instead of 128. Update
>> memmap_init_zone_device() to skip redundant initialization, detailed
>> below.
>>
>> When a pgmap @vmemmap_shift is set, all pages are mapped at a given
>> huge page alignment and use compound pages to describe them as opposed
>> to a struct per 4K.
>>
>> With @vmemmap_shift > 0 and when struct pages are stored in ram
>> (!altmap) most tail pages are reused. Consequently, the amount of
>> unique struct pages is a lot smaller than the total amount of struct
>> pages being mapped.
>>
>> The altmap path is left alone since it does not support memory savings
>> based on compound pages devmap.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> 
Thanks!

> But a nit below.
> 
>> ---
>>  mm/page_alloc.c | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index e0c1e6bb09dd..e9282d043cca 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6653,6 +6653,21 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>         }
>>  }
>>
>> +/*
>> + * With compound page geometry and when struct pages are stored in ram most
>> + * tail pages are reused. Consequently, the amount of unique struct pages to
>> + * initialize is a lot smaller that the total amount of struct pages being
>> + * mapped. This is a paired / mild layering violation with explicit knowledge
>> + * of how the sparse_vmemmap internals handle compound pages in the lack
>> + * of an altmap. See vmemmap_populate_compound_pages().
>> + */
>> +static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
>> +                                             unsigned long nr_pages)
>> +{
>> +       return is_power_of_2(sizeof(struct page)) &&
>> +               !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
> 
> It is better to add spaces around that '/'.

/me nods
