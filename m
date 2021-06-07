Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A92670
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 15:21:58 +0000 (UTC)
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157F9S26106057;
	Mon, 7 Jun 2021 15:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8vzByRTYF34xMWKKyQzKmPJyzFqabDz6vTPM5O68FzU=;
 b=EQRwacC5dQEIZ+BaHZfDStv3aw8aprtIx1cm4565z7faWAn4iq2cR+BGmmpXZyYrbRAz
 jt3zzEKoj9o6sz7Rv2SZZ0wikir23Hooo673FOouJ+l52FlyHzWT9c/P93O5AsPxC0Kj
 ukuNH/KA3h2eKPJy7yehN3+I6ePHhu84ha5HpqlkZYBHF+4usLZQCLaW4bjiU890kYwe
 EKW0FS08ivY4cDw9iAndV237wiqRbTaE5GSt2O0KGpfBtuF1IARbjIU10r+wyqWqP3+A
 Zt89ceSkIuOoI3n6bmOrkQ38ubW71gV9riuIzQgDjNXXaZpakthwa7LsuxUPksJv1T/G 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by aserp2130.oracle.com with ESMTP id 38yxscbf09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 15:21:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157FAmFX064858;
	Mon, 7 Jun 2021 15:21:44 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
	by aserp3030.oracle.com with ESMTP id 38yyaa61em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jun 2021 15:21:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyQ6VZOFvnlTkkKsdJ4TvPYBTdavn0eQksTFIYef50ONBq4inUf5CeV3aEafWMgpD1L/stWmSV6rwF9avAYsjbOI5/2BAj+IKwOnkNSnk6KsQEphwuHmhoMHzJBbMg3NXKXIOLqTXY1jaN15GvWn+XIK2dXFwPaTsyyrIj2TOgu7Wgc9p5Jc4TPZrnhAK2s9+S/rTz05BDE67dDVxsrurR8avBZtJ+hA28UGreR4k1ylEPT04tDE7ds66YLVSxxJclKeXAbNRW4JTCHKExHoxAb0Lq5IFCulOu4eBdHjBa9CoPownKXJjX+pTTD4EUU5BdYkktNtvatNzqGCYCaaRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vzByRTYF34xMWKKyQzKmPJyzFqabDz6vTPM5O68FzU=;
 b=dL4CGEXqdurtnPjySmCFZo7V9j8zg4ZJdrjHU70IpCitfJWtfjiLJN2KQXWX+gvDreV+dSjNyBk8r9BA9MVOHsoMlXpoqcSKHm4b+gPNrmz82lurR0tnBvvrV9b8+gbPlSL5dGltHo+ZE3b7KqbFKCmw9bEyk+aFoXPhLrd54sIPi8xVt5TFPvst5CmddcWVWN76EHMU3PGbGBCdsy1PynTKLZ5dHa59XIB+uzY92FJhbsbTAsA+Sgwd5+fSaf6SUB5KjShlav3A6HQn//40hqI1SpLochEY8dkBIVDkmytAkFeT6McbMDsqhh914WQXrD41XVrxSX8K6rF+MdZdfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vzByRTYF34xMWKKyQzKmPJyzFqabDz6vTPM5O68FzU=;
 b=ZPpKhA+hhYulpfQzcCdFjhRRbCHv0Ff3zUb1nqR7LWxAJoS1aoeUY82TguiKYL5StOUz88/CI72KkxSLfKs9RrufhnZchNtw/mOMP+0ayTySqYpA/mlGC/ID8vJNGba7oH6geT4N5alt7Vr1QdR/GoRptvQy0r6V7H2hzg0UagI=
Authentication-Results: lists.linux.dev; dkim=none (message not signed)
 header.d=none;lists.linux.dev; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4930.namprd10.prod.outlook.com (2603:10b6:208:323::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Mon, 7 Jun
 2021 15:21:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8cb1:7649:3a52:236a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8cb1:7649:3a52:236a%7]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 15:21:41 +0000
Subject: Re: [PATCH v1 11/11] mm/gup: grab head page refcount once for group
 of subpages
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-12-joao.m.martins@oracle.com>
 <CAPcyv4gYkBZ2x_=rOEDD+FsP0vdn4=JF-VrcYmR=TsrADDcb1A@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <fdf0cf7e-086e-ba12-0aba-84d4819df6e5@oracle.com>
Date: Mon, 7 Jun 2021 16:21:36 +0100
In-Reply-To: <CAPcyv4gYkBZ2x_=rOEDD+FsP0vdn4=JF-VrcYmR=TsrADDcb1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.196.21.203]
X-ClientProxiedBy: LO2P265CA0306.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::30) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.125.214] (87.196.21.203) by LO2P265CA0306.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a5::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 15:21:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 500c9948-3597-4139-b537-08d929c7f3ec
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB493046F693C69DBD9447BCFCBB389@BLAPR10MB4930.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/Y72GP2ytZhE1FYwQHeXdYW3IpaUqDsXeFpZ7rUGqCcGThIOcQj1v3UFZVA2HoovIiYF2MBHq3nKdFDI+mIVPRUsS68J6Gd/V0O9S/qEStkk8tMOgHYTo8gePHlwjmov5UOlLQWqsvomDYj1SPyxpTrh4+p/VrFZZJmeAsYQPOEjKFohB/4KVTZIV2jKWaAcfRA+b7tYZsrblL9Z8wn6FTWrbGyD2NeLyVjDqnHAQXH9ByayHsq3UV/zhHie/5rOvoGfLUh/Q30O8VUwYxplfQtMe1Cea5N241hdulWDXbx9MBYDU3EL1YswoYHd3p7cdd9fLA887v9l3zaEqZhPiovcUTFr18r2ID0L87uaYLkf4QQjZ3WixNuqfi6e6eyPYFr1Bto7jIjeFdNQmgrFXqCh9Itfsfk18Bhd2MzYqtrS5sbchJHtnfcpd/RR0y2LCsQphUCcxBII1W2BPQnB5V98VwMB0KbwM2Ip9U1It+2WtgLPphFyI2tVB2+rEB1ceXe9tUTwOYSwojbWEqzBkyIQ9HP2PQMIZs328FvN68dNzGD7E+mxUSaH2vdHp51/Cav3zsJmXXU0+NZSZjNZZrax9xv5OIS1aIJZ2QZE7uUEWbWAX8R9pKg6ye/cN7WLBX3hH8PwuqSRrjb8DBaPoKFoTVMLK1omz076p5uIVpI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(66946007)(66476007)(83380400001)(5660300002)(31696002)(66556008)(54906003)(38100700002)(2616005)(956004)(6486002)(8676002)(4326008)(6666004)(86362001)(16576012)(31686004)(316002)(8936002)(186003)(478600001)(36756003)(2906002)(53546011)(16526019)(6916009)(26005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 
	=?utf-8?B?MWU3R2xZL3p5TmhrR1BKK2JxNU9ERU05Q2grcVEyTXBOY3hWYkl3Y0Jja1I2?=
 =?utf-8?B?bnQxL0pGZjVtOEprYU1ucDVyN3ZMUzE2MXJGcktOOGJjZU81cy9WNmRlTTYv?=
 =?utf-8?B?Ti83SW5iLzFqWXFORGQ3RW5uYXJ4VHN0bkZ6clpIYlhBWUd1TDd4SDdoZTNt?=
 =?utf-8?B?NkxUVUtZSHlBU3h5dHBkVFJHWFhuRFlyNzdveW5odnR4ZkR6NklsQ29UWnZn?=
 =?utf-8?B?bU1Zc3FMUHhxQkxHWExDM1ZnaWNpSWcvbHlndDFKTGovNnFETDliZWlvTWxw?=
 =?utf-8?B?NGRyclZON0ZvaldaN2ZNSTdYNWdJSVpnNUVOb1ZxOHpudHVlRk5saDRRSzlU?=
 =?utf-8?B?aHFVdnZMakYxNUcvNEdvV29BWjhDa0QrWWxOWEI2NVdzcjhOeXhneVcycUpr?=
 =?utf-8?B?M1ZJVkVHc01aUHc2dStHUTRnaWJCSWJhcDFWaXRhaHFTeklmekVhRXc1ZXpI?=
 =?utf-8?B?UEQxTkNIK0c3K1hmU1VBMVA0am9GejZUczd5ZEppbUpWZmg0Zkg4alhMN1Jq?=
 =?utf-8?B?M2swekw1VUp1NTEyNkx6aVkvYzZTL0RyN3NNNkwwdXJrZ2N2UnZ5Z2RKM3ZB?=
 =?utf-8?B?VmlaVU9rZjd6Q0FncXlWNktQNElpZ3QrTHYybUVuVlMrNXplMGUrek94a2Rx?=
 =?utf-8?B?eW1hWlNmUWs3R2ppZk1vRHVLK0F1T3N5RlFKb2ZEbTZDanZNbnR0aENQTlEw?=
 =?utf-8?B?dExPYTNVNnJnaTQ1R1FSSkwxNFJ6blk2NkRFKzk5d1kwWWtGb29rYVpxT1lN?=
 =?utf-8?B?Tk4xc1dEb0txKzE3ZUtWdEo3NlZGOFI0TXBoUTRxRUpWeU9kU2hubU1nVEJC?=
 =?utf-8?B?K0J5YVErWlpnOFd5UjhXNzViclVoZDVoZFdGcDJmZTQ2TG1XcDBuWlZvcjAz?=
 =?utf-8?B?Z2pIRllGeUlvalhlb29oL3RIeDZWdlM4aEYwNWowNHN1azIzUGRUSXJHanhv?=
 =?utf-8?B?S3JHS2ZZTkNra21iWTFBOXdycmN3N0JwWXBORTVrT0ZrWG1QSFgwTEFIM2RF?=
 =?utf-8?B?eVp5ZFRqbU9zVmdObUJPbWZaNWU3VTBSWHBRTVpCdmxRYlVPaU5vMEVUdDdj?=
 =?utf-8?B?Q3N5MU5BL3l6NHZaWmw2dW5pcGFOcXlSM0JzaWNqZFREdi9lQ25oR3ZvS2pl?=
 =?utf-8?B?eDRRYWVid3B6V3AwNlNLTDFPRC9JaDRTcHFCeHFKblFsMkVmYStmcjdhM0dM?=
 =?utf-8?B?OXE0a1Q0UXlxdm93dVdJUE1RNkxZWlltaXhya2FwK0xWUzZTdXpkb2lOS3Rn?=
 =?utf-8?B?elg0Y3ZzcmJRZHNLVFNYZVlLQTdkcERacWRsZHFva04xU1lFcjhPZit5VDRu?=
 =?utf-8?B?QjZTd0Q1b1dNbGpnekJFTjRZdTRjMU1la2RzbEpvUWplaEpMTmgyazgrZTk3?=
 =?utf-8?B?L25TMEpiS2NxdDNENys0dFVjam0raUhEU1dxV3g2SHFzSUhyZmJQY1hZOUdN?=
 =?utf-8?B?eXU3a3NjdzNtaU5FVktNbERub09NUEFHMDg4QWQzbFlJSmRNNjhFQTEyQUZV?=
 =?utf-8?B?V2RNdGxpNGl5MllIM0NONmJSMC9DczArVm5PTk0vVnZMYTZ1UG1zOVQ4VVpF?=
 =?utf-8?B?VHJOTk1DM1Z0emtXNkFTaG9EWERCTVMwNDR5N0VqSWx1V2NuWHNlOEQyOXU4?=
 =?utf-8?B?UFcycmxpam5EdW5BRmNSWFI5MFRMSzd3WEhVNUJ6SXpId0pFVi9sM25TRzNi?=
 =?utf-8?B?TWk1LzU2K2loZVp6Zmx5WGpLemZzQnZtdHZRSStEOVdqMk9PK3NlcFF3eG5Z?=
 =?utf-8?Q?sWl1AQQlDe3HcgstpE57q6wB8nsmjanLt5mecDy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500c9948-3597-4139-b537-08d929c7f3ec
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 15:21:41.8557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACJBP378rNvQfv2SkgKivZsHuiBdL/QbE2BmQlXWXtZJuhCCwvLr3Gy3xUjW9jFsx2w7JVZV5BMqAspFBpG3KfEH3WJsbEuEysiXUtQ9f+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070110
X-Proofpoint-ORIG-GUID: yELOb5NkPCN7Bf5WP3aKXo2j2HboGQpy
X-Proofpoint-GUID: yELOb5NkPCN7Bf5WP3aKXo2j2HboGQpy
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070110

On 6/2/21 2:05 AM, Dan Williams wrote:
> On Thu, Mar 25, 2021 at 4:10 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Much like hugetlbfs or THPs, treat device pagemaps with
>> compound pages like the rest of GUP handling of compound pages.
>>
> 
> How about:
> 
> "Use try_grab_compound_head() for device-dax GUP when configured with
> a compound pagemap."
> 
Yeap, a bit clearer indeed.

>> Rather than incrementing the refcount every 4K, we record
>> all sub pages and increment by @refs amount *once*.
> 
> "Rather than incrementing the refcount for each page, do one atomic
> addition for all the pages to be pinned."
> 
ACK.

>>
>> Performance measured by gup_benchmark improves considerably
>> get_user_pages_fast() and pin_user_pages_fast() with NVDIMMs:
>>
>>  $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S [-u,-a] -n 512 -w
>> (get_user_pages_fast 2M pages) ~59 ms -> ~6.1 ms
>> (pin_user_pages_fast 2M pages) ~87 ms -> ~6.2 ms
>> [altmap]
>> (get_user_pages_fast 2M pages) ~494 ms -> ~9 ms
>> (pin_user_pages_fast 2M pages) ~494 ms -> ~10 ms
> 
> Hmm what is altmap representing here? The altmap case does not support
> compound geometry, 

It does support compound geometry and so we use compound pages with altmap case.
What altmap doesn't support is the memory savings in the vmemmap that can be
done when using compound pages. That's what is represented here.

> so this last test is comparing pinning this amount
> of memory without compound pages where the memmap is in PMEM to the
> speed *with* compound pages and the memmap in DRAM?
> 
The test compares pinning this amount of memory with compound pages placed
in PMEM and in DRAM. It just exposes just how ineficient this can get if huge pages aren't
represented with compound pages.

>>
>>  $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S [-u,-a] -n 512 -w
>> (get_user_pages_fast 2M pages) ~492 ms -> ~49 ms
>> (pin_user_pages_fast 2M pages) ~493 ms -> ~50 ms
>> [altmap with -m 127004]
>> (get_user_pages_fast 2M pages) ~3.91 sec -> ~70 ms
>> (pin_user_pages_fast 2M pages) ~3.97 sec -> ~74 ms
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  mm/gup.c | 52 ++++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 32 insertions(+), 20 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index b3e647c8b7ee..514f12157a0f 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2159,31 +2159,54 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>>  }
>>  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
>>
>> +
>> +static int record_subpages(struct page *page, unsigned long addr,
>> +                          unsigned long end, struct page **pages)
>> +{
>> +       int nr;
>> +
>> +       for (nr = 0; addr != end; addr += PAGE_SIZE)
>> +               pages[nr++] = page++;
>> +
>> +       return nr;
>> +}
>> +
>>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>                              unsigned long end, unsigned int flags,
>>                              struct page **pages, int *nr)
>>  {
>> -       int nr_start = *nr;
>> +       int refs, nr_start = *nr;
>>         struct dev_pagemap *pgmap = NULL;
>>
>>         do {
>> -               struct page *page = pfn_to_page(pfn);
>> +               struct page *head, *page = pfn_to_page(pfn);
>> +               unsigned long next;
>>
>>                 pgmap = get_dev_pagemap(pfn, pgmap);
>>                 if (unlikely(!pgmap)) {
>>                         undo_dev_pagemap(nr, nr_start, flags, pages);
>>                         return 0;
>>                 }
>> -               SetPageReferenced(page);
>> -               pages[*nr] = page;
>> -               if (unlikely(!try_grab_page(page, flags))) {
>> -                       undo_dev_pagemap(nr, nr_start, flags, pages);
>> +
>> +               head = compound_head(page);
>> +               next = PageCompound(head) ? end : addr + PAGE_SIZE;
> 
> This looks a tad messy, and makes assumptions that upper layers are
> not sending this routine multiple huge pages to map. next should be
> set to the next compound page, not end.

Although for devmap (and same could be said for hugetlbfs), __gup_device_huge() (as called
by __gup_device_huge_{pud,pmd}) would only ever be called on a compound page which
represents the same level, as opposed to many compound pages i.e. @end already represents
the next compound page of the PMD or PUD level.

But of course, should we represent devmap pages in geometries other than the values of
hpagesize/align other than PMD or PUD size then it's true that relying on @end value being
next compound page is fragile. But so as the rest of the surrounding code.

> 
>> +               refs = record_subpages(page, addr, next, pages + *nr);
>> +
>> +               SetPageReferenced(head);
>> +               head = try_grab_compound_head(head, refs, flags);
>> +               if (!head) {
>> +                       if (PageCompound(head)) {
> 
> @head is NULL here, I think you wanted to rename the result of
> try_grab_compound_head() to something like pinned_head so that you
> don't undo the work you did above. 

Yes. pinned_head is what I actually should have written. Let me fix that.

> However I feel like there's one too
> PageCompund() checks.
> 

I agree, but I am not fully sure how I can remove them :(

The previous approach was to separate the logic into two distinct helpers namely
__gup_device_huge() and __gup_device_compound_huge(). But that sort of special casing
wasn't a good idea, so I tried merging both cases in __gup_device_huge() solely
differentiating on PageCompound().

I could make this slightly less bad by moving the error case PageCompound checks to
undo_dev_pagemap() and record_subpages().

But we still have the pagemap refcount to be taken until your other series removes the
need for it. So perhaps I should place the remaining PageCompound based check inside
record_subpages to accomodate the PAGE_SIZE geometry case (similarly hinted by Jason in
the previous version but that I didn't fully address).

How does the above sound?

longterm once we stop having devmap use non compound struct pages on PMDs/PUDs and the
pgmap refcount on gup is removed then perhaps we can move to existing regular huge page
path that is not devmap specific.

> 
>> +                               ClearPageReferenced(head);
>> +                               put_dev_pagemap(pgmap);
>> +                       } else {
>> +                               undo_dev_pagemap(nr, nr_start, flags, pages);
>> +                       }
>>                         return 0;
>>                 }
>> -               (*nr)++;
>> -               pfn++;
>> -       } while (addr += PAGE_SIZE, addr != end);
>> +               *nr += refs;
>> +               pfn += refs;
>> +       } while (addr += (refs << PAGE_SHIFT), addr != end);
>>
>>         if (pgmap)
>>                 put_dev_pagemap(pgmap);
>> @@ -2243,17 +2266,6 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
>>  }
>>  #endif
>>
>> -static int record_subpages(struct page *page, unsigned long addr,
>> -                          unsigned long end, struct page **pages)
>> -{
>> -       int nr;
>> -
>> -       for (nr = 0; addr != end; addr += PAGE_SIZE)
>> -               pages[nr++] = page++;
>> -
>> -       return nr;
>> -}
>> -
>>  #ifdef CONFIG_ARCH_HAS_HUGEPD
>>  static unsigned long hugepte_addr_end(unsigned long addr, unsigned long end,
>>                                       unsigned long sz)
>> --
>> 2.17.1
>>
