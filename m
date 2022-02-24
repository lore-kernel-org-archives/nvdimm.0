Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269FFA3D
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 10:38:51 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21O7iKVT025428;
	Thu, 24 Feb 2022 10:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=AmUKurYKjXRX0nI2zTMb1GW48Y3FD9Sf8aNVSaXTjvw=;
 b=Qi6cAAQ8GLx6Al/ebhbawf0x24axxNlZuJ5UlSW9m//4p1Bf4gXCtRQgZT3cpPPzFlp+
 q1c41JYzyr6nCYrqXiOuxuPW6lms8JaFZfSNtxj6MB9b+d/QpfA4KrVXWKiNa+o6kZyb
 QhAwPg03hsnQMSqany2voNqozTfB5/Zx4TqcD7gJg4iUW6KER0zUmqFAo6SO+hhLzwl6
 vuIRhxHDTvr9Co1mo1tjZoezJ2SHwjTa+B8ZxpJIOHlkKVd9CRuRcDQl1W4Rh+ft/AzI
 BrVZ/+MHoH28nS7tK96PINqDtFCpBDwYtq+Aki280ldsRLDpl2H7GDJgyN7qaQ1bPNzy 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx71a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 10:38:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OAb5Eb048169;
	Thu, 24 Feb 2022 10:38:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by aserp3020.oracle.com with ESMTP id 3eb483e76d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 10:38:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drkiJycIZR/ZcmzlaCgXQb+FWNdKK1bGOiCtwFpbK/sykkTLQs4iflEdzuuD2SiOH6IMOSKlJ21ddmsnY7um8fKKLbDBqYTLZ5PJlk5AKNfyC3YtCKpUJp3aH43Z6ZdVxHxtMQyA/W2PRY7fktUlRu2Nvl2kRdY3AEcqiQ0uiEk2V0+WJ4r7rIA7FRKRh/5kljP6WCTH0T0xYX8XW21mXwGqlTT1AHkmxh38KUfBisGNy3GKbgOZD87Xx+xiz7tc1+c84zRDsafZtXvjsaKanrF3meLMuIpABXNafjVj30qP1WVZ4gmuDv9P2t8YnwN3QYVuNoDLmGqoFxK2zJixsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmUKurYKjXRX0nI2zTMb1GW48Y3FD9Sf8aNVSaXTjvw=;
 b=jg1YoU1PwbIfXlIuKkxR6WoB0fUvBnw0IsPtiHXW++Wb73GNxDVNKigy8ci8J8RehLNOtrChXwIx3fOkdHpzMjv+T1XE85G1oB0wbrLtsaBN/S8dYXDEEEVuPp1dvjCFYbmNeXOEoC9xUoMmkFhMSWXI/cxyEtQ8xbKpr2IMxN6xCJuQVdOOtzsbHeJhJ0B19OZRpdvY4QPGSrRpXrPcMPLJF+S0bUog1F8Ru2omtfjAfQ4rurigvLjZSZS7SKowtd4q+ASyI53AlE/tYTDlTgssboyum2D9r7dmO/jPADAVEINHpW+9SnDHnQIewBy3fnYKK5B0cFjn/Koh+VGuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmUKurYKjXRX0nI2zTMb1GW48Y3FD9Sf8aNVSaXTjvw=;
 b=idEBbmzF775IaEC1v+zEZnkNlC3etIISjBN5l6CokfbKEw6joGhm38rPOjcZiG59VUAbIIe94lDFytsvXXR/YntkkfXQCmmBt0wHQ8nHrWpyMwe7MHD1HbyPxmJHqY8+Q5Q93l5rLBFwosWfRHxerC1vJ1qFktp0mYMmdE0H0v8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BYAPR10MB3125.namprd10.prod.outlook.com (2603:10b6:a03:14c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Thu, 24 Feb
 2022 10:38:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 10:38:41 +0000
Message-ID: <50eb28ff-6b8e-7366-f3a8-661ded73a26c@oracle.com>
Date: Thu, 24 Feb 2022 10:38:33 +0000
Subject: Re: [PATCH v6 1/5] mm/sparse-vmemmap: add a pgmap argument to section
 activation
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
 <20220223194807.12070-2-joao.m.martins@oracle.com>
 <CAMZfGtXejFZhfs8hUB9MM-oozPhG-TO1PK4p8Z9o4QzmGtWp5Q@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtXejFZhfs8hUB9MM-oozPhG-TO1PK4p8Z9o4QzmGtWp5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0117.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da4d2a5d-279b-450a-1f5e-08d9f781d323
X-MS-TrafficTypeDiagnostic: BYAPR10MB3125:EE_
X-Microsoft-Antispam-PRVS: 
	<BYAPR10MB3125F41CD3033E12E103E950BB3D9@BYAPR10MB3125.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lR9BzZA1c2Uzp8kPcDt0sD5TZQQDm8R3wpDQFOX2ap+y0Q+LmWzJVST6yfalUgihfA50rjjqfcOJ3ufiN0y/vqdjTfulbOKJKOmSrlxurR2OazgooX02UCSsyrCNV2pSpLiKC5mq85ZGIjdRycIZZVutHXPu8WnaRHFknlv3eHRUeCcDq+CPop8o/yKdckJppmMcxYeaLQFwLmG0aNje32vhMYfzu2repoZP4TiOjI6v1JifFBVm+3O8+OAv5zAWq61mgysN70mmk/uUJEdb7p9Ffgfg1eeG5AFH8l4rjavnu8MH6VUIpEa49XWhr7DyvcprBK8AZl2qtmLS1cOLvM6mIyWh9Vd1uN5chKfyUL6PcgTJD8LQWLB3r/mCQtViYUNWIcTm56pPOE+Wo/a8akbd/6pQbycNcR9PfvFaLfzOzG18L6+deL2uEgf0quovguVPBqeVzl22vVsvlQ3karTyVurpNS8kRYloLE//RRF/QzVa8kE7O2IZBjhhB8H2lLBa8D7pFOB6s9jUlZDjzeetW2kpf30nUUfLhn+Oza4RoMbewcEixLoCi7LY0x0YKKqSSQcoZ6ewSJSH8gPNS00fIqf3NSIF2nBaW9gW5k7eWkS/ZsyGUHJBdoAXyjU9flnNekU4I0w+GmdRpRYO8LThIwjkW5QZYvnpze3VFEqvvv3r10TKXWvQPPQ8A7LfHTjz99dbbSCQrMHhgAE8IT+RqDkx3mGU8u7XOREeX0ktNC5rw3AWdGuwoR03ve/HwBw4Nooo+KH/WOLQrt01WqyUsY3pzZdHzW5932wDkM4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(36756003)(38100700002)(31696002)(316002)(66946007)(86362001)(8676002)(66476007)(4326008)(66556008)(2616005)(6512007)(53546011)(6506007)(6666004)(7416002)(31686004)(508600001)(26005)(186003)(966005)(5660300002)(6486002)(2906002)(6916009)(54906003)(8936002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y3psS09GMFFadEcvbWplTEJQY2xxTTVKeTVGS3F1YzJJU04waGpjMnZvQjJH?=
 =?utf-8?B?ZlRnOGhBcDg4ZW80eWxUM09WVlU3ZHUydGJyRmVIOEhYT2FwY2dya1hVdlpt?=
 =?utf-8?B?c2ptL3BvU2Z6M3RVSTJzNDY2aU5vRVZrOTA0VnVBYmszL2tJODRyem1XNytt?=
 =?utf-8?B?M1ZsVnkzZkRVUzF4WVg2bUE2eXY3d0ZqU3pEVDU4SEhma2d2K2xnSFlISGtz?=
 =?utf-8?B?bnd0bEJ0VUozekpzQXNhMEtrSzhFVVNvYy9EWWttaUIxbUhDSG5zTWJvYmJR?=
 =?utf-8?B?aWxXRkE1L082dCtqWUxtblFOdkJqL2srU2FOUlhJbkRud1FkZzlYbXByRHpG?=
 =?utf-8?B?UTlXREdDVGJNeVRGZ0o0OGQ1VDFVbVJhenhwZ2JHQVJuRXArbWlmY3ZUdDMx?=
 =?utf-8?B?dURXeGl0QnFIZ2xtY3dMaXArYVpVUkxsNWtJcjkyS3BKUk9xTWlvK3ZBVUpq?=
 =?utf-8?B?Zk1yQnVGVFBPUEtLNEhzV3FnMlFuTERUaVNmREZucDVwenYvL3JFMEQ1dTcw?=
 =?utf-8?B?SktNTjRlTHRMOEpXa2p2ZHJ6VUtWRE9sRkYwQWtZWlZ1WE5kUzk3LytzYldM?=
 =?utf-8?B?Z01RVzNKTnVheUhwdmdsV3dZQnRIMDc5NWg1SHFXY1Bnbk83RkRDSTAwdWts?=
 =?utf-8?B?TFYxYTFFZ2pPY2p4ZE91akJhc1ZjcS9kTURSUFVCMjR6OWh6MTNkc0xxeWFS?=
 =?utf-8?B?dC8vN2RDVkNkK2RSOWhYSDkxMXlYd1Jhd3ZQYkxBZXBIMjI0azRHZVBoeC9L?=
 =?utf-8?B?NzluaVZSK2tkVzArbXlYc0N6aFJLSEg4L1NMaExlNERNSXpDeTdPdFpqR2hi?=
 =?utf-8?B?Ymo5T0Z6VTVtNHNJY3cwSCtZejFMRFhiQ2RIZ1ZvdXdEdW5SMTZBUVJYd2RO?=
 =?utf-8?B?cHV2NUVtZkdNc2FPYjd6QmxSdkw5dk1LYnk5NWdFZ1NDcHhvMUNQNVBwNEFY?=
 =?utf-8?B?aVdSSmREdGFSVGM3cFlsRXFEUjMyWU90a0dScm1GbGoxRVNaY01iWm0yMkdP?=
 =?utf-8?B?dmFEdm14aWZ3NDRPaitLbEtnellja3pLQnNUendlclFZVmN5V3B5c2tEei9T?=
 =?utf-8?B?endVbkVxTjdKYU5Vc3JmNEJqeWJEbXJVU2lNdFZjVDlkRFdXZFBPdTI0bXR6?=
 =?utf-8?B?Ky85VmMwTzhXUHVRL3ZBcCtDZ1MrVm5VY3JDd1FFVWNUUGhPSkFmZ0l6ZFNJ?=
 =?utf-8?B?ZGtNaTVvMVQ5eklxbXVHbk9qNWp1eGsvZTlSUWgxNDdYeWd6eDFxRlQ5NzFm?=
 =?utf-8?B?OUlIbmd0L3FJWWxpMmJpT0VJeHVubSthNkhyaFJWWnk1UUM1dDA2U1NwSm0r?=
 =?utf-8?B?NitBWWhoRnEvb0xsUXpWTitqYVhuenVHOTlabnhkSzAyK3ZsNmt1TjFWVyty?=
 =?utf-8?B?MUNYRGxqN1dLUzZkQVczUU9YdDR1YXdDZnlqQnJTcTVBekpaMEtMd1NIVXhD?=
 =?utf-8?B?WTBiMGxVZkdqQWN3Mm8zV0hVOHpQYjM5eWE1MFQ2UXNlRGU4cERyUkhseHZs?=
 =?utf-8?B?d0JTa3Z4Z2tKRDNPZm9laC9KU0g4N0F1ZUVXUG1jQUQxb21veUxiMkY5bzFu?=
 =?utf-8?B?TjdheHUwRGZaU1lUUUFLRzRSSW9zU2JkQnN2aVoyVnlaK3pSWHk3blhzNmRD?=
 =?utf-8?B?VVVGWXFOdkdJaWlBclVJd2UwWU9jY3pJM3hGS1U3ZW9ZUTAzNDF3SmxSY0ND?=
 =?utf-8?B?bVZQYkZVaUUyZDdBMjFJc3hLdnAzTlg2aVFmVjdCZHA4MHZreUhCTDQyaFlC?=
 =?utf-8?B?SkxxOWFTWm5nRG8rUGNmVXVRNVVVMjBWQjdwZ2czUDRCVzViK3JXTWlCQXYv?=
 =?utf-8?B?dU1lb0Zkem05THV4bUx5eFdGVUN0TTlIRjRlbmFBbUtNc0xiY3VBYTdhT25F?=
 =?utf-8?B?M1FZcFY2RGFtbjM0T0pwazQ4MkNtZzZhYjVuMWhZVVRSczRsak1pbHdPRkti?=
 =?utf-8?B?QnlDa1UyZVVYd3ZOd0dRQXFubmZ2M1lqNEpQRUFaSjRLOUtKZGFvMFNmdzFO?=
 =?utf-8?B?R0hpM3FuYTIzOUM1UThhVmNObXlscnhtVHEzcTRzVWhuNkFzKytLeWtTNWNN?=
 =?utf-8?B?dFFKejQvL0piUnVBUmd0K3UxTkNFOWFDZmpvY2w4Qk9pZlFsVTdFWSsvNzBJ?=
 =?utf-8?B?aFRaNGZTc0c3L2R3UHVKMHhLYWRtbHAreWR5enA1TUtodzd3a2dpNTRRMUhT?=
 =?utf-8?B?LzBOUVRNTG91OWp0ZE1SS01wMzNkcDNXT1o3OWFtS1RDbkJYRUt4a1RKb2JV?=
 =?utf-8?Q?vP8yFFTDonYV+t3Uup8aLDxMXZCz9olxldFzosI8ic=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4d2a5d-279b-450a-1f5e-08d9f781d323
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 10:38:41.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPoAm0uX3UiOnEXB52AJ3nLjg3I1yGdMJhwkn8whVEJNuBuUKELKU+BCjybrtCBgVMXHmry9TPoFI0dsdNdLh6gv2u31cG42LnFZ60qt9kE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3125
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240062
X-Proofpoint-ORIG-GUID: IVRi-GDurwK2EHs4TuQPZ3hgtfqsbENB
X-Proofpoint-GUID: IVRi-GDurwK2EHs4TuQPZ3hgtfqsbENB



On 2/24/22 03:02, Muchun Song wrote:
> On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> In support of using compound pages for devmap mappings, plumb the pgmap
>> down to the vmemmap_populate implementation. Note that while altmap is
>> retrievable from pgmap the memory hotplug code passes altmap without
>> pgmap[*], so both need to be independently plumbed.
>>
>> So in addition to @altmap, pass @pgmap to sparse section populate
>> functions namely:
>>
>>         sparse_add_section
>>           section_activate
>>             populate_section_memmap
>>               __populate_section_memmap
>>
>> Passing @pgmap allows __populate_section_memmap() to both fetch the
>> vmemmap_shift in which memmap metadata is created for and also to let
>> sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
>> whether to just reuse tail pages from past onlined sections.
>>
>> While at it, fix the kdoc for @altmap for sparse_add_section().
>>
>> [*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> Missed my Reviewed-by from previous version.

Sorry my distration, I was sure I had that added in.

Anyways, I've fixed now for real.

	Joao
