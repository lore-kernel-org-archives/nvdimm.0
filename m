Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF4B185D
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 11:47:11 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OB2fKa024819;
	Thu, 24 Feb 2022 11:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2WEUDeqzkZi5CPxPxPdgC+e3wX9QTswhDjxOKWsXiPI=;
 b=q3pU4MinqQBgPm2TToODuLAQN/V77A6UfQLNMyV4lilFf0IxlOO6px1M1rF2bCtdYmBp
 ZQ5xCwn3ghumvt1Wd9gJXwr+IAmiicjENL4mgNS+vbF0IGsuv+spys79Q1z+AT3R1x2e
 7In4o0X2Okj3cJ/+ZZNFpz3AXEUA6trcRvgdVrrJUvyUrxYjT+v6hj3tgwqXK52pcLYw
 R2fMeTqa7PxvM47O0ezXYHKbvC/8sjageR8OtV0gHQth+JPQkHHnEgeF1zhLHf0vn45I
 MXu0jS8p1sM5m4BmV7lhGSDVoAVz/aR1MPIwapu+t3lTGApDVpsOOkWklQpanbSarWli 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxf6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 11:47:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OBf0xf177871;
	Thu, 24 Feb 2022 11:46:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by aserp3030.oracle.com with ESMTP id 3eapkk0j29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 11:46:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fo8iDoPLcTanqrVit4pJyfa6eVUcDroeuhAe0ZuXk4NpB21EX06Nn6NlVl0OPFt8aLLS4V+5DevZ/jXxWr6pOXp/fqIN18RAMxatTVN+lgviJvtF/5gfJlBIIUQKvwiT5lQ292cbd6mNKyHM5CpBWV3962WyEpikUz096Uh9TA/PnvX+8kHMoLR9O4ZXYTG4FJv3vZ6kCtRrxD+CI/R1XSgP1L/WRGKmZaxinbN22Mgcn21kVuowdFe45bT7vsgf0ukcFSYNWb809tTnCRVKkZ8lTXXbGCHSeTM+mCGdoR/wpCWx5eF+wAdyqsygpEAWbKsYZkFKIuNOa7O8UZxULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WEUDeqzkZi5CPxPxPdgC+e3wX9QTswhDjxOKWsXiPI=;
 b=c0/nrkKjJhTcHeY48i4dZdFaFb4Nbu4u1JGgWex7RgJyiJN6dCyykjZcjFUyvXSlKC8tWVi+vlp1cX/wAgfsjk9qrWzdchjJET6GPc0YbH6oUn9VAQk4URFTnI+Ffy9TRtFzvanQ9Ho9UGodJnKDEH2loaECjAw3oOhFbTOGnunfN9GI35fuWRJXdP/fdun6FpmpsDLpz67pNBHBIZ8U8WEJhZT4h//APliVOv1/4gdrvFKXQN128CwPc2n/SDLuPWY+AKc5lgrMQaCpQiBma6XCldJ+tyg6BRb7XXfPL71d980QCK5L032iK2WAbw0vBY+9u0fPriuNLHz7OrVogw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WEUDeqzkZi5CPxPxPdgC+e3wX9QTswhDjxOKWsXiPI=;
 b=DCCdsS4YidIc7BJ2muwFF5Z3eEfzyLGJ4sodkDRj0X8r9Yvnfh5/xYtUWRFLmCrOIB9XML+NdV9zhUvaOE2yweEP20GtPudSbSQ7HngZnC1r93iV/OVtXH+rOWF2r51eb2GQna/+zP8UkyqwyW/63FBSQm99mibbBGKI8dNF6Po=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1839.namprd10.prod.outlook.com (2603:10b6:300:10c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 11:46:57 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 11:46:57 +0000
Message-ID: <25983812-c876-ae82-0125-515500959696@oracle.com>
Date: Thu, 24 Feb 2022 11:46:49 +0000
Subject: Re: [PATCH v6 4/5] mm/sparse-vmemmap: improve memory savings for
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
References: <20220223194807.12070-1-joao.m.martins@oracle.com>
 <20220223194807.12070-5-joao.m.martins@oracle.com>
 <CAMZfGtXm5pLbTnzMCrWPg8Vm3gykB8XEg5DHFm0z1p1x2fhySQ@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtXm5pLbTnzMCrWPg8Vm3gykB8XEg5DHFm0z1p1x2fhySQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0096.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::11) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a0ab941-4a1f-4583-43fa-08d9f78b5c2f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1839:EE_
X-Microsoft-Antispam-PRVS: 
	<MWHPR10MB183998AF0FD217938384F01EBB3D9@MWHPR10MB1839.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0vAHZELBGJCCgIBMjYLHM2Q2gBx3i0K4H25MvDMkim5ROfItwTa1DYYEMVf9B7V56mYm4of1Dstk+0cqnI8W6CVpgTbg3LPDbfTireKFDVgEqmHGJLqci7MJpIkLbzIzSk5T1nNHU6Ppal/ud7Y77pFylzPK18qIF/+xQxM3WAEUjBZsouRw+fTtlxvTsY9DKgYC5PeTHKWP8J/vaD4lV8lEsKrRAyYb37UVWxzKEAEDnARycBVq1SvXz4n7e0aJv221sDsWHFDYMv5SynN5B9vWhFEeSohbnDbuDYvArgSITjqlvRIUO/loGJUryXZkTUTxPpm/d7InF/ZJamz3snhVCttPnVUyle/djXEo8JFv7z2WFC9ICcUa6Fq9U0XHa3rX4aLL2NV5cBbGIpjVPKyQn1+3rWRZD5wZxjrgzVfdX2wzzUoCIp5ZEWk5iFO7PG3QfqzQxsmgkPYCkzfhoiGTLupQv3K11yOd+dWKpZPzRf/DeVnvKvXRb6UxnZuEju7p0phnt6RajdYY87fHTUy4TZcID71IqHNZfN2w4oztwa29JF6beivk99gicQErt5f3ZrQ4T+fvV1cxDe/P+9J3iaiHRMyiiSs3V2DrnHQBV3Xt9MDK2LGKeaauqVGNy/5BQS00AbiCjVec5aUPXQUt50eA2gJTQW3afuPATqz4WRVRk+f5ex6EKnr/PYuVm9+xuejPeC35yJJQGSIs87WfOGbhaM/lFkHptXClaDlkP38UiNrNRI9r/07iQVbu
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(31686004)(6666004)(6486002)(53546011)(508600001)(6506007)(2616005)(2906002)(6512007)(38100700002)(4326008)(26005)(5660300002)(54906003)(7416002)(86362001)(8936002)(6916009)(31696002)(8676002)(66946007)(316002)(83380400001)(66556008)(66476007)(186003)(116466001)(25903002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VmdkZ1lqTnlxWVRZZ3A4RHlHQ21qU0dlZ0pJNzFFbXJtR08zSkk4azZNcWFW?=
 =?utf-8?B?NHNWbzROR2hmY2Q3QlAvNThDTjZLa0QvSjBybmVreE1uMS9EUHZMYWRrSlFo?=
 =?utf-8?B?UExjU3JBc092amtoUkNhUnNOUVJPUm5rTHRxZmQ1WHFlQ09yZ2FoMWpIU0t3?=
 =?utf-8?B?RjZ0TEdteTBhZmpMbHQ3S0FUR1lvUFNHSm5WeVRvWlZIVDdxUFlVeDV3UHVV?=
 =?utf-8?B?ZlpKMm1vejcvQXQ1TXd6QkVSSUdCR2Z5Mm5FcGo1cDY4RkdpcUF4aG5ENFBZ?=
 =?utf-8?B?Ry9lTWRLL3V6S3ZmTnRRekJaalBNUnRhUnRjQTVJck9uVHpOVlZZdjdYUVBG?=
 =?utf-8?B?cHM4NURLaTMxclB5T0ZqRjhUL2pGdlVmRWRRR2lyU0EzSzg1eTk3czZOcWJM?=
 =?utf-8?B?ekk0NGFtbWhMQTAvOEJXSzJ5TWFPejlEQml6V3Y5TkwxRFJwYUtuU0Z0RHh6?=
 =?utf-8?B?UVpVVytpUE9JVFdPN3VXK3ZLVllMZ1h0alMzWXpkT0t1dVVIUVVGVG45eWM1?=
 =?utf-8?B?cWphTEhkNTdxeVpTTzFYR1RDVGIxZjB1Rmlya1gvR0FYZmc4NHNnSVVMWlJk?=
 =?utf-8?B?Z01FZnl2aWZyN3NwWkM3cmZocUNITlBlMG9KaW9weUZLMkNkcWtWbG9JYzF6?=
 =?utf-8?B?Z251RFg0WU0yeXduUEdhQy9xTWpTUGtSUTNGbnZxbUtqcWlaSHAyb2pDRjlR?=
 =?utf-8?B?ZEdLWCs1YWVVMzE5NDBaaktXakxVaUhsMkFXTGl3dkJxd1F3blM0cjhoOUFQ?=
 =?utf-8?B?dkVrY1dKamlLVWs4QUtISDBTdEx6eHBFWERETUJmTFlBb3dsTFZVUW1aK3RB?=
 =?utf-8?B?dDM4L1g5S2FTUFRBVGI5dTA4RG1jWDF2c0l6QmdjSW1WSmVUdDVnTUFudkhE?=
 =?utf-8?B?ZG1WU00yeHBMYW93eXFCTmZLc0NzdnZmbjVEdTBzTzRGRlltVDhwN1NsYm5E?=
 =?utf-8?B?QWRReXRGS2NmMGREQ3Zkc0hKR2gzUnpuU0VLRlVPNTRDTmhzaCtOUlNjYVQv?=
 =?utf-8?B?NUd1d0VNTllsQ0R4NHF1dGhOQ0R4d1NXQ2tqOVBSRGRETCt4aC9zSm5YWXBL?=
 =?utf-8?B?WDNmSG45UzM1eU56MTdQWkhESEg5aGhSNlZRZ3d6L3FwcDI2OTR1UGJxL1R0?=
 =?utf-8?B?WGVnTHBZQmQ1aGQzQUNGVHZuVUE0akNuZmt6M1pJZTA1blV3aGdaZnk1bitp?=
 =?utf-8?B?Y0RmUVlpK0t4UG1uWjBmT3QyM1NjZzhlOGkxcEk5L1RHYUpFSEtyQnBjUlV1?=
 =?utf-8?B?Q3B4OUZPTSs2bmVkcEZEdm9aQTZDS0grc3BXTGtML3U0a3o1enJMVXpYQllh?=
 =?utf-8?B?QXF6cWU0dUZoditDcmFBeDMvNFFGY3laR01QSi8rZ29uRlNuSHg3RHlReS8z?=
 =?utf-8?B?VEpLb2RodHV4dDF6cmgvQmFNRjU1M0pjcnllaFNHdjNQQk53QmR4dHRCZHcz?=
 =?utf-8?B?L0o4dy9oK2Q5blk5WUpVOXpBK3JQZ1pyWkRPancyRVIyUWFMUXhUZFlnYmR1?=
 =?utf-8?B?TStJMlFtOG1vVkp0ZWlVZlVHT3V0SFJ5cXNPY2hNT1N5TnVYM2hVTC9EeENX?=
 =?utf-8?B?ZEE1VHpLRzJ1MnZRVHJCM1E1WURza1A0WVhZb3QrNkVBUkVWbGxlQ09JUXMx?=
 =?utf-8?B?NXEzVlQyejloRGVmSGRrVlRDU1k4ZXRqaGR3QUd6a2cyUkRkREJmczFKZlBm?=
 =?utf-8?B?M2YrR3NzODBSYmZ5S1VNbXBLeVA0eWQxcjgyUjhGK2FjZmUweTBYQjM3djdX?=
 =?utf-8?B?MEJzZFBSbFk5U3lxL3VzOEl3MXFna2k3clZ4RHFoVGYrVVlTaUh2aHd5blh2?=
 =?utf-8?B?MVh6KzVVRDh3ZCtwNG8rV1pST2tUMjdSejVmU0J4aGtCaDJUMUZoL3gzR2w2?=
 =?utf-8?B?by9abzlWTFh3V0hDbHoyd1NKK3d1TjJGdndMRlNkN202S1krLzVVSTdydmlY?=
 =?utf-8?B?MFE1N3FxV3A3cmc1aXhaT1F1YytwREdZZHY2MDlnYVZEejNlWll5bitPS3Uv?=
 =?utf-8?B?bFJIL0FwK1lSTFRmL1dZOFRQajRma0YwL2lEWWhvcXRvaVJGS2JDWGJkS1RQ?=
 =?utf-8?B?NTR0S25qeTNCUmlQOVdWU0R4WkNpMmF4TVRXTUdtTXZsZU9OSWJ1TXA3VE9N?=
 =?utf-8?B?S0tIcFFaTjk5MldUMTAyRGZaSDhTZEx5ZjhaZHNBZS9FMHB5NWk0Wll5MWtR?=
 =?utf-8?B?VnJXaHVrTlFEVS90MDNlMVg1eUdJL1ZxZlNHLzB1c3RxWXZ0aG1WMDF0NGQ1?=
 =?utf-8?B?WjgzZzdoelNKMEJPVkszZjduTXpBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0ab941-4a1f-4583-43fa-08d9f78b5c2f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 11:46:57.2189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: feNvRL+XqNyHjz0geiYdv0TB/sPZLUjNL6VsMgtX/PMjZaJVGOot3sSMH0GTBNu02xZqptzBSPFoYwn1alV6Xwtp3ynNmgawZ1y6bC7fBV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1839
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240069
X-Proofpoint-GUID: SjjRZtU08hfuJebD_1L7k55MIKRmgOwC
X-Proofpoint-ORIG-GUID: SjjRZtU08hfuJebD_1L7k55MIKRmgOwC

On 2/24/22 05:54, Muchun Song wrote:
> On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 5f549cf6a4e8..b0798b9c6a6a 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3118,7 +3118,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
>>  pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
>>  pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>> -                           struct vmem_altmap *altmap);
>> +                           struct vmem_altmap *altmap, struct page *block);
> 
> Have forgotten to update @block to @reuse here.
> 

Fixed.

> [...]
>> +
>> +static int __meminit vmemmap_populate_range(unsigned long start,
>> +                                           unsigned long end,
>> +                                           int node, struct page *page)
> 
> All of the users are passing a valid parameter of @page. This function
> will populate the vmemmap with the @page 

Yeap.

> and without memory
> allocations. So the @node parameter seems to be unnecessary.
> 
I am a little bit afraid of making this logic more fragile by removing node.
When we populate the the tail vmemmap pages, we *may need* to populate a new PMD page
. And we need the @node for those or anything preceeding that (even though it's highly
unlikely). It's just the PTE reuse that doesn't need node :(

> If you want to make this function more generic like
> vmemmap_populate_address() to handle memory allocations
> (the case of @page == NULL). I think vmemmap_populate_range()
> should add another parameter of `struct vmem_altmap *altmap`.

Oh, that's a nice cleanup/suggestion. I've moved vmemmap_populate_range() to be
used by vmemmap_populate_basepages(), and delete the duplication. I'll
adjust the second patch for this cleanup, to avoid moving the same code
over again between the two patches. I'll keep your Rb in the second patch, this is
the diff to this version:

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 44cb77523003..1b30a82f285e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -637,8 +637,9 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr,
int node,
        return pte;
 }

-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-                                        int node, struct vmem_altmap *altmap)
+static int __meminit vmemmap_populate_range(unsigned long start,
+                                           unsigned long end, int node,
+                                           struct vmem_altmap *altmap)
 {
        unsigned long addr = start;
        pte_t *pte;
@@ -652,6 +653,12 @@ int __meminit vmemmap_populate_basepages(unsigned long start,
unsigned long end,
        return 0;
 }

+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+                                        int node, struct vmem_altmap *altmap)
+{
+       return vmemmap_populate_range(start, end, node, altmap);
+}
+
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
                unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
                struct dev_pagemap *pgmap)

Meanwhile I'll adjust the other callers of vmemmap_populate_range() in this patch.

> Otherwise, is it better to remove @node and rename @page to @reuse?

I've kept the @node for now, due to the concern explained earlier, but
renamed vmemmap_populate_range() to have its new argument be named @reuse.
Let me know if you disagree otherwise.

Thanks again for the comments, appreciate it!
