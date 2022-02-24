Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCB2185D
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 11:48:05 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OB0J80014608;
	Thu, 24 Feb 2022 11:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ag1Oiso1im/P7XcPfMrppspEQoKY6S5wykL6JtKE6/Q=;
 b=WuYfsi0nbpIXrme5vMbihkLmMAkHmYU70t3aEU94+5i2d9rc5AdCFr5zBxza0UiKSiOK
 AOmGHsz5ZVztb6l0iokHf0RQC8WxQKeS5wxlyjxSZrThbbaQ/eyZnNzk2YNzRpWIQYdb
 bYYIbUJHIk+3yJ0YUC0vNw/xBiwGeD+BUC1qiCdF6mEbNvbUkf3GZ/0KQiNUsVOaQwKJ
 5FO0z7BcfpZmxXggIdIuMSYisKP7ZcUDjrGu5HnOURncV570qNMkLuphCGJaT0Mvfq8L
 CZBvqOakOJYQO9z+xkCBFuh8rk21QBmPBr9xv8+fNFjPwrB8DywResT0TI9zsdA4lea1 NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecvar6rur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 11:47:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OBeX00159264;
	Thu, 24 Feb 2022 11:47:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by aserp3020.oracle.com with ESMTP id 3eb483gptc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 11:47:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id3alDrRRmSltzRxtGYpAsD8eusLSTDgDzx4AoVjuKAUMbNd5MvLV01LOeA/iQf/BEXFvq4nzwjgG7lq94b5AjqxlYzpJUNg4hRrOE7db+r+WYP2GHf+vQy22LH2T3UcrMLDXxssq0UGNyco9AX4HxgiC9ULPCfH9i3D7mwLTSYcl546flFqyLQ8XmREYezL/71zbk5leKIehQ9FdV59815KU/nh8IRMYzSJYTMfJX/lpcUyn2xOVsh9vGKboF2gGISQbj1XcYxjbNX2wfw0Ok3d/A2oFAW3KogQ3p3Qygf1XXtaOcEtSzbwg6teZb+8qzqnZt8+4vTP8zA/8oXcVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ag1Oiso1im/P7XcPfMrppspEQoKY6S5wykL6JtKE6/Q=;
 b=eErdq3AytUvCPIj8lOg+91HPbwt2gXQljtvsXHACuNfUQWUFr4+f6gj1wOBUbg8vJPP3zlMC9UdJLBH25qO5hfeDJ28hzOfElKKP47JE7xElMgVGsUdX8O3IxMH/Ro+Qnu+nUm8qTstVhT+fCDeLjBmx2TW75Hb+eNaGHcq9FBeabg+pSgHuMa+JW9MSA1zgu1n7zl1W0WdO/la3pFtP6XZ1NESHK+rKTd4FlDN0lqehgxN7XK7HsmNIWmJh8rBjLZi1cFnfXwzopYm7NkE/Rqu9cO6zroPNmIaBRkt6e/Cppdg65dnOBUDjWvx97Vjl0AhnYyjxUys7MK7knOUQOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag1Oiso1im/P7XcPfMrppspEQoKY6S5wykL6JtKE6/Q=;
 b=C3VdVB9az0RknrLqX2KWrhJrpygtbPIH/PUCZHdvc1V/maKLbPdK+E7uiBx70sMbo8ufnc2Oi/hxctjMD3yVhmC4SKtogcw5yCTWfhs09DWDYfrkshc4MWwiyRhqxd4Q04aq57QzAYRR2jv09UU5xNHZw6P3noG9RVOHveB00Fg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1839.namprd10.prod.outlook.com (2603:10b6:300:10c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 11:47:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 11:47:52 +0000
Message-ID: <2c43fed1-96d7-50b9-40cb-09927983d66a@oracle.com>
Date: Thu, 24 Feb 2022 11:47:45 +0000
Subject: Re: [PATCH v6 5/5] mm/page_alloc: reuse tail struct pages for
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
 <20220223194807.12070-6-joao.m.martins@oracle.com>
 <CAMZfGtWBtoygDbU+qdUswdz1K5=86+eCt11Ffeyvw2e0z+xrzw@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtWBtoygDbU+qdUswdz1K5=86+eCt11Ffeyvw2e0z+xrzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0092.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 621d26cd-4f79-4df0-60f8-08d9f78b7cf5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1839:EE_
X-Microsoft-Antispam-PRVS: 
	<MWHPR10MB1839C1C362A80751F97F68BEBB3D9@MWHPR10MB1839.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/4sy2l1sC40vDrvwS2m8mB8tzpm+hMrcDpGkDt1ibLU6LlVoVnd3c3os8o6E7AgIGTAai4DLsU9x3ctG+Dq0O5N/NVPUpvtupbyYDZ9uu3Mo2AHFh5Cob4Zx6RMcOrWdOm+KpNaKVFGwZYXGhfpbIcjGftU3IwIb8JTJgF1KzlrvbiZ2qSemDMBn4czLsNK98V4KVmdb34qGelUMFtHesw1w/RTT6CwCUWTiodSeahBZt1LBg2+w+l8/vklHMfQXjaUkopC/ITIgbrBPmE6x6tFOGAmOGFAYo5nPV0XStQymqP0M8AZRUUtf/1/hd5vG8Uri+ZvotFyLOHoV1rNcpKC7mzhsP+odeDmO9/kkphTIMbhAyLEpOD28ysFuf9qGWYysyTtwhQBxxi3L37tKRoQao11DQ5v6HS8KxQPd7ebAAHJctzNhUCooNymCyl72gmxmJkdlA/Rvyq4u3BvlHwHmth/uvDtE6rmISbOksqTHNCNGeiMjwJ5f/1K5/a+wg5bhyiaP0ennYwz21Aunbb+n5GzRBHqvt+1RFJwTjOScLVuNSJU3+fzzNQrZI7OzJM3X0Tx1TNAUKeSRfYs8odzMqkX3bhaffKnP/tZapZVM+wFWhQ6lMCLEE4wkOPP6Ixoqv+DxlW/KjsuN/6YOEepC6mphcu/kfcYWuJkH1cjmjuyboakiVoGm9YVaHShH6F1m0aDe9qsqfR58fEiR0g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(31686004)(6666004)(6486002)(53546011)(508600001)(6506007)(2616005)(2906002)(6512007)(38100700002)(4326008)(26005)(5660300002)(54906003)(7416002)(86362001)(8936002)(6916009)(31696002)(8676002)(66946007)(316002)(66556008)(66476007)(186003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QXNad3Z1R1lEUmFtbWVDdkhkRUI1S085ZEdkTnp1V3lxanpzbzJFdFpJRllh?=
 =?utf-8?B?K3FWSmNkUEFjR0t6YUR5ZVhYTytWUEwxejhUQ2gvUDR4MEQ0MFJvTHBHZHpn?=
 =?utf-8?B?QlIyNGRidU83Z1BDSUlyTGRvU2IrN1dEUE9WZTZzRFRqL3Vib212R2Q2MmZE?=
 =?utf-8?B?Q2xUUy9ma0JYaEtZOFNOaEI0MHNPWHFpaW54ZmEvMHdyd0xHRGs1djNVRUlj?=
 =?utf-8?B?bUF6Njd0OEFibWduR0x1QkQ4Z0dOcnlZc080YTFvRThtQnBKUk1HaUcvQTBq?=
 =?utf-8?B?SVhBN2paUWlEMGQ3MEUwK091dVF2Mmk2TU55Yk05Ti90M2RsSFNIcVBuS0kz?=
 =?utf-8?B?ZXpIWkR5S05MQ0x5RE81K3BmNkx2U2FsdHQ5Vndmb2VGeUZ0UGgvd2EzZFV6?=
 =?utf-8?B?Rlk4c0IyNjlreG9wSXpIMEVsTW4veGVlM0F5L1RJYUV0SktWREM4eC9waEI4?=
 =?utf-8?B?RnFtQ1BOUUtPWjQvTkZGWUtyYkZYbkV1QXZOZW44aDRlTEg5a0hwbFlWZjc4?=
 =?utf-8?B?dnVkMjBtYkQzbVk5eVVzY0w5M3Axem9OY2UzTXozV3RsdkdyOGViNWloVm15?=
 =?utf-8?B?Y3VSMDQxcjZWd3JoWEpaT0hEQzN1SDkwdHVwZ0pNV0RhWVJBUThSM0lwejZm?=
 =?utf-8?B?N24yL0xPaUNQZEd6bUFvQWpWQldiMVBRbk44c3hscU5NOWFMci9SNmoxa2h0?=
 =?utf-8?B?bC90ZFlxTnJyRmR1T0RvS1o2RXVTUVl0NldUWjN3SDB6RDNmbTBWQ2d6UHFG?=
 =?utf-8?B?RUFnV1ZQRjhtemhtZjU2aGxYZFJSSjMya0hMR0hoL2xURW5iaC81MExndTI4?=
 =?utf-8?B?NjdoMThvbm5YRThZR3k0SGsreFNvZkdrek5xc0pvZ2VMNWhOeGY3MFU2Qk4x?=
 =?utf-8?B?WU9XdFNNL3ZoQmlvaFkrZ21IV290K1Y0TDBveFJmcUZqb0hJMUNycVBEMU9v?=
 =?utf-8?B?VytERkt6TGNMdVUxTVllUjRRcnV2TzV1dTdNNHpLSXRGazNTQVIvMTNZS29s?=
 =?utf-8?B?b3VZMVlNSHZXVGdiZ1VMMUFFUmo5TXo5NU1mK0F5Y0FrS1lvd1FWWVRnbFI1?=
 =?utf-8?B?YitvSzlRN1VLdE1wWm1FQVU5VTNkVEppanlzMnBYMk5ia2Z5K3Z5M3Aza1Y2?=
 =?utf-8?B?T1ZaaTdoRWdGZUNvam1SUkY1STIveFZqbTU4VkY4WnNpV2xYdW5VTDNmMzJs?=
 =?utf-8?B?MVIvd3Rta0ZmYUUwZUFQblVLUEpycEpDc29BOVRaQVlHdkdnTmozSG1EY2xl?=
 =?utf-8?B?Tk9OL0VuY2t6eXZKeTNVYWU1SEU3dG9WRWtSZGw1ampZTzkzNlpHaFgzQVJL?=
 =?utf-8?B?RVVsUnVlWEdYNW12eHNHTk9EOW5RUWU4UGZCUnQ4cVM0Wm9JSjN2d3JjNC9Z?=
 =?utf-8?B?NW11czdhWForZWNndGlxWFBkSG8xTlE4ZTZJMnczNG9BeVA1U0ErMFNsTitx?=
 =?utf-8?B?a2hzbXpVdlNyT052YzMvVGRDeXlsVGlZQndJTWNEazA3M0ZuQ2YzZTZ4SW9u?=
 =?utf-8?B?VVVhcGNuYkVQakx0MnJTOXZKYzVOT3BFMEcwMlJ2M0g3OFc4VEZ0aXBsNm5P?=
 =?utf-8?B?cHJRYlZnb3ZhTUN3ZU9hQ3QvNEJreENjOFkzQmlQb3ZvaEpJTlZRTVJpWXdI?=
 =?utf-8?B?TlQ4NkVpN0FSdEdWZ3dPV3R6NC9PaUJ1KzBwVVJ2b1dyZGo3dWtRTjRkZjZ3?=
 =?utf-8?B?aHdUTlVBY0NrZ1VrclZIYXlwM1E5UzNyd2Zxa2l1ZUpyTUM5RGRpQVVxa3NJ?=
 =?utf-8?B?SFpXNHJZMmhWWitUZk9rRHpOQWdBQ24zMUhaYVJ6TzFDckRrZ1g0VWkvRmMx?=
 =?utf-8?B?TzJhZmVCU0w3elBVcFNDd3BGdndIWE5aK056cEQvYVdESGdhQ0Q0eVlFd0dE?=
 =?utf-8?B?T3Z1YXFXd3ZzYlZNOXBlL3FZMzgxc091bEc4cGkvdGFNeG0vdDd4ZnYvYUNt?=
 =?utf-8?B?WVhWcU9lRmxYaEFSVUhSOHlUaU9USUVsUEd4eFdmcWtRbGlhQkhYSm81T3JY?=
 =?utf-8?B?cVRMYVVSMk9YQkZ5ZzZTOGNtNU5KYzFSTkNDbkFEMkdyaUsxaVhCNCtZL1Na?=
 =?utf-8?B?QkkvQlh6aU9vdXpYMkM2UXYzakpQYmdpZStWQTA1ZFBDWU04Q1c3SUJlUklJ?=
 =?utf-8?B?Qnd3bytqZDhWR0lOSmJLaGtkWTRyM01aeElnVXRmbnZWd0M3WUQrOGsrT0Y5?=
 =?utf-8?B?OXNScExndHNnYU42blNEWnRCaW1RaEwzSkJrbldPdTBscWNwV1B4czJPU1NB?=
 =?utf-8?Q?T26BtzASIpbBJ1GQ6vIrrzY9ENrhFLkbl6Tlb1FaxA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 621d26cd-4f79-4df0-60f8-08d9f78b7cf5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 11:47:52.0637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIc44pee5e4b/MynKVBnSWEuITfkGB9TAeJU3NcVo859xj/rIlFvREhLS40OGbqhpKlTnYySok1+vRvJ4g1c0tuZubKwpfV5TjlX3McOZNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1839
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240069
X-Proofpoint-GUID: zQZ4-KES0DWwj3iksq6tpQgPjKE8tSfb
X-Proofpoint-ORIG-GUID: zQZ4-KES0DWwj3iksq6tpQgPjKE8tSfb

On 2/24/22 05:57, Muchun Song wrote:
> On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6653,6 +6653,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
>> +       return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
>> +}
>> +
> 
> Should be:
> 
> return is_power_of_2(sizeof(struct page)) &&
>        !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
> 
I only half-address your previous comment.

I've fixed it now.
