Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4CC168
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 00:09:35 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CNl3hS008181;
	Tue, 13 Jul 2021 00:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oBHcBJEZh6IOIgG3A0xTMZSc4kNimTQ3pyq/jre8nwY=;
 b=ovU7LNMhNjiV2XV3U6Br1Yx4Ic8CKdlnMH77iD98Y/IbcKa9xNE4Rcr5aVyGqn85e1GC
 7gZhPC7GNLdEQzXtVt0CW03YmOa4VKBKnHUt3qwIWRNFOlYaKhSTrRV8/28yj/jPzFbl
 cbAvVsK3QUGZtjknyeP8aiig4io4rhZhmPNY1JDAqvyMFpnSZqcWRk+Iyy3u8gU4BkDQ
 wI5+WdS4RQs9YM9Ibbm4d0XdDvsZqD713yxKF22JiV2lZnuQMwFDnVjAVpuKzaMrhg8t
 C0D4U2SErZ9MBxqUdcjJqO0PAc3wKzY8U3RdWgG4jGDYNRwGT9u6KA7azDl5taXhoSsI 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb14c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 00:02:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16CNoUNr099508;
	Tue, 13 Jul 2021 00:02:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by userp3030.oracle.com with ESMTP id 39q0p22p99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 00:02:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkpYbrxPqa8Zyb9E05zBLtXvAgWeV5CfKy7oNPZc0owfYQfpAdWPCXtIOVJTLMgOKpCkBBCBznavPgm6ir6ca2Bh4qSFwdfuuCg4PfI+ggodsyjz48iV2IxZEx+kixneD/+x2hXkbqt+TJwIRjqdmC59ZvHBH5XUbbhwQ0hU1890ZTYxA1voafHDogg/kZc1Wu5AcW0AF8muwhiDqS3TNSW2woXuwaouSteJLwdYVc65N61QPsntkKo5BF0O+HK21D4MzeZ7v+0u7azRKTYvYQN20+woQR4S+sPYQIgbBxZYoi6mO5uVU8YSg8IuSZOmSAuLUsfzAyjzLq+hFP1yow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBHcBJEZh6IOIgG3A0xTMZSc4kNimTQ3pyq/jre8nwY=;
 b=Yf5DUR5ataDhE8C5KigWsyyupTAa6tsPguqky+YMecBpyeT2BGe52/CYhjy+XJNuiH/zruwMGALDsjrOrhehlRMumhowTEdoR95CXy8CpsIzf9tgbhsK5re5q988L0MbuDlrk6t0ljHotwR7kZtRG0LQRJifFdCQer/qTxOInxzvHOdSk1/J+vmNdQnO5PQK2Jim6/ns5HWtxrX1UZ/1FmUfOuEN3y8pOxTQad7lpf5I6hOzbHF5JCfEqRwrOESLWL47/UDFyqUD63qDzntBf7ip4kK2FrCGZw6FRfOxKKMGoVvH2gLi5Q86CNgLtgEj4rS0o+raC1UMu5bK38Hdqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBHcBJEZh6IOIgG3A0xTMZSc4kNimTQ3pyq/jre8nwY=;
 b=jmnG1tzb4SZZtNS4QzmDY8fVxBM0tBxGmt8e0KMhjYxAQPVG0uibKDQz32qX5aFlgVBR3/k7a83CYEO7GN1mQpkIhzRCK45/psZNhU4y4MdWhwYDFeKy9CMyP/ouRGQI6efjvs0tsHSenVXGw73uJFWbfdD5HyzcCNS9DmqUAio=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB2696.namprd10.prod.outlook.com (2603:10b6:a02:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 00:02:15 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 00:02:15 +0000
Subject: Re: [PATCH v2 02/14] mm/page_alloc: split prep_compound_page into
 head and tail subparts
To: Joao Martins <joao.m.martins@oracle.com>, linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
 <20210617184507.3662-3-joao.m.martins@oracle.com>
From: Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <caa531ab-3a87-fdb2-6498-34349f66e475@oracle.com>
Date: Mon, 12 Jul 2021 17:02:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210617184507.3662-3-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0180.namprd04.prod.outlook.com
 (2603:10b6:104:4::34) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by CO2PR04CA0180.namprd04.prod.outlook.com (2603:10b6:104:4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 00:02:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7ead2f4-3a5d-48da-45f8-08d9459178dc
X-MS-TrafficTypeDiagnostic: BYAPR10MB2696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BYAPR10MB26960564902A46869F7EB421E2149@BYAPR10MB2696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lQCvlWidGJgj9k0LbYZxy8fGaTqh1KNHHd990YASEv4dLtQRWSiRqf7vYTn22kL2qgXNA19LPvhtl61bRvlu0v3gDVrx3jPP3N3xmRLmyroksLt3Ydsl155k0/UkwuZXpKR0HqleqkbirpSpiB/gXMrlV6jFaXGoWLzcBY9GZbzcUGqQu6Y8WDzWNWBA2tyKJ3lPUxHATENgkXIQJtUE3nU/OmykNOGIHPS1brfNqdyDrTDht7kgNcwIDf8wh/io5uYm4VRjWEglpcG92x5LuQQZZMPKXTvJCRfTKqQpKnYlRgpu+zGi8Afm0ZbYAgQZ8aj+LJ8inhb5TzBe2LuHo4Ew2WnJkborWkOKgPK85g9rkwJ7n5ilvFpqXbfwTA9/jJ9XQjkFflP3DaTn4AEYBEnni1rvr8z4+TpwOE2fPykB5E5BHM3cS0cE8nEmcysrWP1hrSfkA7XOq8ggKkdZwcTFSR2yoM0c3UxUV8DjBrQc1gd0QhdVHJaimtQQ9b3jEjHFR34gRUA0fbx6Hgb1icXlja8wzYGg9mf43FlOMQdGtAiQfqx0Pk2vXIfsSWIrzo0HhQ3JLsq9CjeJakxRA/RT5bzG3WkmQBqi3ocLXZ12rDebPKMkTTxuNzja/7glYi2NL34WWqm5TLiNyuhyMH0uAdXm7bW+zi7Dz9fa55md8qa/2mNbb6OIHK/009CPmR9701+XD6LeKKhHuD65ePa9yYkBGcMgGEsX1ERo12NAGkyvheDQ+nruBVzQfzgrQ8J81x6IOGGJDh++3Ok/Xw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(346002)(136003)(366004)(376002)(478600001)(66946007)(8676002)(26005)(31696002)(956004)(2616005)(36756003)(16576012)(316002)(44832011)(38350700002)(186003)(31686004)(52116002)(8936002)(7416002)(83380400001)(5660300002)(2906002)(86362001)(38100700002)(6486002)(54906003)(66476007)(4326008)(66556008)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Tkg5TjNDT3NSclBSb1dROWJNc0hKUUVBdkV5QmpiK0ROVVQ0ckJLVmZEeXZW?=
 =?utf-8?B?cFVyQ21Gd056b21kYkRmN1NvcHFqT1d2MTBvOU03US9xb3NRdzdXNkF0SC9p?=
 =?utf-8?B?Y3MzOUxQM1BKZ3BCdjIxNjgvV28rM1UvK254d05pK0gvUjVQWSttMjZUcUJv?=
 =?utf-8?B?dVdWQnlZd1JwdVh6emNqOTNkWFBtb3AvUXdubHpFak9SRDhsRklUY3NTNCtW?=
 =?utf-8?B?UkNiS0JZN0dSZnErdlZZRVJQTlpmcTVUaXhSbzJvUWQ1L1NOYUdESlZwVXNT?=
 =?utf-8?B?L2x2Z0pxeWpQWUVhbzg3ZFdTUXFOT08vb2dQUlVjak05NGVGUmhobHc1QzMv?=
 =?utf-8?B?N2JWZE5tYVdmUW95dlpwU3dnWHpsWXdzdjdpd0NreW5sbS9hK29tTTFkQUgy?=
 =?utf-8?B?M2Y3UjROQlFRckRQbVZuWEV0VWpxck1hY0w1QXlIaTIvSzlLaGhpdlpLam5y?=
 =?utf-8?B?TzNxOEhQcGNhb3JVU0IrU0dldXhWM3BkTi9TSmtMRHl1YVc0QllpVFdEdlVL?=
 =?utf-8?B?R01FcHljenVlcThtbUZ4dUkvNGVDTEdONFM1dDRuY0M2K1RTVExPcDU2dlNE?=
 =?utf-8?B?RnNjQktoTHVLUDliaGcxaFljZVN4ZC9CQnRSYjl6R25JTDZJQnJSUTRZbWFI?=
 =?utf-8?B?Umh0ZGFMSDIzQnVBZjlrMnFVNGpDaHltV1lzQWhjOWxwY0VaRmtVL3Q4bzRq?=
 =?utf-8?B?VkEyS1l0K3Z0Qy8rMGhpNThPRnZJbzVObCtEaGdhU1lIbys2QUIxbGZ0ZzRI?=
 =?utf-8?B?UCsvT1NRaDhnQnMvUzBKVkFBYVVldnNtWE5jQ0Q0c1V2dmdVNFdSUnRPOVdD?=
 =?utf-8?B?RDc0RDMvUXJrNzdCaGZEVWcxUTVNU1ZKUkwreTJZbURURXRJOEprZU41SVQ2?=
 =?utf-8?B?MkphUEMxMXcvSThmbkk1eFVsZ1FhQzRCY09sMGlVUGRMK2hvbWJnUFZEdndu?=
 =?utf-8?B?Y0g5bHdBcS9nbWhFaTkvUWh1eU1lMEMxTVJSZ3pUeVJkNEVlZklvUmQxVjFC?=
 =?utf-8?B?N3lmQ3FPd1JocXlLUHRrUzByeFNPbHdIY0dDbTVtZDZCQUErQWhUbXVrNFhj?=
 =?utf-8?B?TXFUNGxlbUlVUmh1K0FTU2NqMWRlUkUwZzl6cFlaa0hGTyt4MDU3QTNIQWhL?=
 =?utf-8?B?ekdGaXlQV0l2SEp4c3ZJa0NTeEJYaktCN2RER3lnbTNva0s5Q2c0N1pCOWFz?=
 =?utf-8?B?U2hDL3lvNkJKM1dmRFh6RHNkTXBaakR6REJGSEZIUGM1a0kyOXowV3FHSUpR?=
 =?utf-8?B?cm5xTEltMVE5SHB1eExwa1JscWZtRC9IeWlRSkhnbGx6c2xvTmtIQnM4aEs3?=
 =?utf-8?B?M3E1WnZUREd6VW1uamp1dVpwMG5yQ1RRcWwrKzRQb1RHMHdZMndMenhQcTFE?=
 =?utf-8?B?ZWJmdFpSRkUvNUpoNE05czM4SWdVMlkvckNobzhKdndwKzRSVzIwemQrRGtF?=
 =?utf-8?B?Nm13bTJzNXRidTNQdU0vNHpUTFhyQ2VnejJ3amllU2lERGFib2tPa3pvYWxE?=
 =?utf-8?B?VjdISGFzaDNWMTd3SklkM285SVF6Yy9QVnA5WXJicm12dDlldUdxQ3FoYW04?=
 =?utf-8?B?dWhzTzFzbTBBaWZ3T1RxR3dCZU9VNmZqSXlDWDdiVm95Nkc2R2hsU0FnMHk5?=
 =?utf-8?B?ckh3aTV1SU5EMlJSM1ZJT2NWaDQzZDhTQkdrZ0N0YUEvcWpDMVBBWW5Fbm1Z?=
 =?utf-8?B?enBaYnVYWVh2UHpzTXgxZ3dUelBEbE5tdk01VFFrVlE1SGh6blRjTUpnTE11?=
 =?utf-8?Q?gFv5p3RQSpyNjRtF7ZNiw87C/PcuADhICofvao5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ead2f4-3a5d-48da-45f8-08d9459178dc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 00:02:15.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2iGqdEa2vSL6ELrywuU7meIVVv1AgOrorD0F7idK/a/GDtt5OQYioTPq24U21QBSoH4qfOj3eNXfWlRBKk+ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120162
X-Proofpoint-ORIG-GUID: u9FSAlP4-KdlwQWNKBj7P14xwwmOj01G
X-Proofpoint-GUID: u9FSAlP4-KdlwQWNKBj7P14xwwmOj01G

On 6/17/21 11:44 AM, Joao Martins wrote:
> Split the utility function prep_compound_page() into head and tail
> counterparts, and use them accordingly.
> 
> This is in preparation for sharing the storage for / deduplicating
> compound page metadata.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  mm/page_alloc.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8836e54721ae..95967ce55829 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -741,24 +741,34 @@ void free_compound_page(struct page *page)
>  	free_the_page(page, compound_order(page));
>  }
>  
> +static void prep_compound_head(struct page *page, unsigned int order)
> +{
> +	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
> +	set_compound_order(page, order);
> +	atomic_set(compound_mapcount_ptr(page), -1);
> +	if (hpage_pincount_available(page))
> +		atomic_set(compound_pincount_ptr(page), 0);
> +}
> +
> +static void prep_compound_tail(struct page *head, int tail_idx)
> +{
> +	struct page *p = head + tail_idx;
> +
> +	set_page_count(p, 0);

When you rebase, you should notice this has been removed from
prep_compound_page as all tail pages should have zero ref count.

> +	p->mapping = TAIL_MAPPING;
> +	set_compound_head(p, head);
> +}
> +
>  void prep_compound_page(struct page *page, unsigned int order)
>  {
>  	int i;
>  	int nr_pages = 1 << order;
>  
>  	__SetPageHead(page);
> -	for (i = 1; i < nr_pages; i++) {
> -		struct page *p = page + i;
> -		set_page_count(p, 0);
> -		p->mapping = TAIL_MAPPING;
> -		set_compound_head(p, page);
> -	}
> +	for (i = 1; i < nr_pages; i++)
> +		prep_compound_tail(page, i);
>  
> -	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
> -	set_compound_order(page, order);
> -	atomic_set(compound_mapcount_ptr(page), -1);
> -	if (hpage_pincount_available(page))
> -		atomic_set(compound_pincount_ptr(page), 0);
> +	prep_compound_head(page, order);
>  }
>  
>  #ifdef CONFIG_DEBUG_PAGEALLOC
> 

I'll need something like this for demote hugetlb page fuinctionality
when the pages being demoted have been optimized for minimal vmemmap
usage.

Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz
