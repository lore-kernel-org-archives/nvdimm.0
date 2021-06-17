Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6936D38
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:07 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIZciD004688;
	Thu, 17 Jun 2021 18:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=Au0YPmJPGz40CZB361DVeVOlGNrS7V0fsnZ9TE62m9E=;
 b=0PTL/msq+QxFqGpTXiM34T8p9M70+wMmCo6G+cSB6ZG1uUXmdbjA06wXcpNOm0Q38H4O
 xJp+O9ZNtaN2nOhO4ob0i5oGDAl8W/9C4g7QsKc7k9x50MIzhtjmYqgJLccR3Qbqeqnd
 EhT6EwAO0J5RZGP0DWw57w0Fr2kCil0ChBHgeA4dwZMds40ld2Do+WzXQzmTPALMOxgW
 jBajoQJDTEn1/gVvMmNpG1Rv4iL5YeSQkN9Js0lttVv4bNAXxF2eETNVHqEpNOQP6fEw
 D186OqmrnXOIj69Ift2UDMIuLnmE3tqgT5iEtuUIkis/oBz5Y8R1fOYIeOEB4SWMuKzv bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39893qrcej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjaO4180356;
	Thu, 17 Jun 2021 18:45:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by userp3020.oracle.com with ESMTP id 396waxy5wg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlY/TDG6xg95motLjgsOO8KsobNAOGBJ9g9EzZrzlHxIhOM2WjFI7Uda372doWIQT/phAGHjE0esrsEzi+8pRGUT13q6+RqCdtYZV3fcpl407gxNKPWVaKghadsxnpvhHgWONaHyIHKekcLmJwdrF63yNHljCf03XGFAgZrJDz01ItdOSMGpOSoGJhDOuKXxvItdn7Iu2OzYkn8x+Os0XlgPVQYTsjfN8tK787gHstJUdoWUcGKsaXRPgBET0pSY+/9tf8uRCEtoI0VdyD6ubZkndvh79I96OBYBTsYLUbeIosXSacJfOmy1sAhkO+Aife72F4K1wBAB6y40RC07IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Au0YPmJPGz40CZB361DVeVOlGNrS7V0fsnZ9TE62m9E=;
 b=ZPArFAqxTqEGAcoyIQBR3JdsvLhmIgrVdBFRNYOxsI1yvgfYelu0+56MzPDRZH73DTghNCVbBSaFopzu2epKZGWvbOMO/05yo4e4Qefb94fBv8EA6YdNJcDa7wD10w7+wlj5Hvo7T1NhFXJ/lOfe0Db0Jj3KO88SfeIx8fH2IfsuHBeLCwXbkYuWcoJUVq+z4Lu+LkyXI6/J3Td4DDDB90jV2afQBIswwMl08mWUoN+UW3iM0kEMf1CUba+Py7+rl1SHRrmpf6uGZUnhGUUslaA5Iq5i7S6udLObwSRiVi2HtUJrKVMt16Ln5qKdtKx28GDdzZpU/k60xh56lkCo7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Au0YPmJPGz40CZB361DVeVOlGNrS7V0fsnZ9TE62m9E=;
 b=PxZh5g8mB8KD+hg9B9sTG3EeVi54oL+zPPyOR5G8heRB448oxlKTIyFbXhlfCaH6bttjXlH8cLWPiz1g4SJNwuAuA23fOryWrPVSY4EaflgmaPU+0rQ116SCtTkN3l61+PqPMm/7AMBmjpQlR0+ghUaxRIW3EcDfAMHNPEmd5Os=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 18:45:24 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:24 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v2 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
Date: Thu, 17 Jun 2021 19:44:53 +0100
Message-Id: <20210617184507.3662-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: defeb944-7b85-46b4-f3a0-08d931c0111a
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB48528EA737DB4F07F6FFEE24BB0E9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	YZK7TAhaszElCIIh8fb/LlbTLSn5tDa5TdmqvWqgy8SznB4ATUvjxNUl3agKq1mWGppVRKKn07WhxAYPqiqnPrKhnPlzPoKvHJaukRzvh282yZd94cFnH97aB71Z22WipPesAkfzLR5Zge5knmtOZvJttk4S8unsyR8HXUQohlclki4IY0DknbxkkOBUn5qaP+L4LryWxFpxG45y/JqwE0ivwNmtAGdC//43taxX2aQqF2p3PFj2pg2Yq2g/GkoHXa89zKorlgegRVmbDeL3156U4kC1/bXJbHYcuSnJVowp5q8AfYUObNfgAzN8DsEstO05eZN+So83U41KNEkgGmrrAJlIZuy0Mj7ZpZGF1j38Y348Z1OFdbNh5nH3/i8VTSGPQL8IKtY0XKc9DqXpAdPDbEezMzD6wFAnWyIxAco2YyD2pTjBcbgWivjZRScPJQHEDnoeFR6J0HXAgul2Ii55zMTlrpj7bAOthqgTJJey1FbnbS5klS+ffAtF1dMZZCnbxcCyij1FMBErLfaEOI9oXUn6om0W1S3AFbg51Njkv2auXJuHEvVDBQCzOwRrWQ+WMdelyWRQlwpxvIyrZ2HPx3B6btptNJsSumWMtb4WVLx9HFr4Q4nzzKeSO2i480em6fB/t1yyDtsmzP+mrInVWpAA1B5GpEsOKWuJmxb3ec1rnPyRKB9HxUZUp2m3cOtK/8YHiEyljcPRHYinHzUTOQLtdG7i+a8pVvfJuVKIVUeay6XHyvp6/U5RfYPg6juINSeDPnMjHf+tDteHnW8hw2q5icovTHNPJDQOAlGbtm9KEQkLmqs6hb41xulI
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(83380400001)(6666004)(38350700002)(4326008)(103116003)(7696005)(5660300002)(186003)(16526019)(26005)(54906003)(478600001)(38100700002)(316002)(107886003)(1076003)(52116002)(8936002)(66476007)(66946007)(66556008)(36756003)(6486002)(6916009)(966005)(2906002)(86362001)(7416002)(8676002)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?g1SquuibQpFphXNUFEaHlDNeHsSg2Vs8NaVMD4ow/0PH58TmiOdnXqGL74MS?=
 =?us-ascii?Q?qoHCrc971mZl8i2gsthRKlMBBnYs5T/8/DO7RaknDz5RV+DJw3a82v9SDo27?=
 =?us-ascii?Q?HFvD0JOqMh7E8JtByeoFpJDcvpk3ZhrdfQXwg7ofveKPkS3luEyEY3T9Wxfp?=
 =?us-ascii?Q?OXlIYHwdiEh+rvtrrqoHVjawxAlHAYtOg3+WtqkKIwmBxNbaTY41PFvMdhMT?=
 =?us-ascii?Q?cDHB1+/nmm4z/RwjR4kBs9rsk6u8c/bElU3mbcbuNHi8fiHXNGucxPqh389S?=
 =?us-ascii?Q?BmXImpa0IVJuu9o1Fa2ND2RBvBN+Ym9n412WNPqSVNHjUDzLnDC5CNrAZj8s?=
 =?us-ascii?Q?2k9H6JV2sdxs52wSk42ApzN8s3J5/MVCbE/C5iWQzKP87bS3f692JR/TuAlh?=
 =?us-ascii?Q?k4hsiRo6YvX0JRw9l9uAEkMwZ7U4r5dMpr2cSZtrEQk7TMPSVwTIwbecFIbw?=
 =?us-ascii?Q?WqdPBbU2GI7yKjQf/JFnUyEH2WdWa6GufTtg6dyXBeuMLPEb0smfI38or5Od?=
 =?us-ascii?Q?0xVIV8ym8AusqWTwLXmQZZAorLj5avXAsBvfOuF9imknNEXtsJccrG+G437Q?=
 =?us-ascii?Q?1BmwaspeVgdzAZzhK2/3o1UIydFDCN84WEl38zwQTBhlS+fiSwcFw7K9qmQe?=
 =?us-ascii?Q?fDUD1p3Kk97hQ1rjW6/UQYRDFeiKB3xltZeigofhypAv+1V6kQU7lFg7Ca2N?=
 =?us-ascii?Q?pMgq9a/58U/GGcqjOJUKbuft/WmQO7X86qHzcA8JD/+YMv9Gd9QfyJZYU+rB?=
 =?us-ascii?Q?iTjwT7JwqBj8oiqwK37wWVKcWecw0kgBiMWE3pA6ElqR15YiTIcArCH7Kfr9?=
 =?us-ascii?Q?7XlEGBaSnPeZxVXOI/SXTdbLIqeCQqB70lrq6efdcZwT84BlvK+LE0RJa4Za?=
 =?us-ascii?Q?GIIAKiJgUad/04wQrZdo4U5wZNOrZz6tBI9H1uqNGjJ+s8XnMf9DleJv4Ad4?=
 =?us-ascii?Q?bErV10tvPRJ8rSxw+pgMP0Ah6ggVbFPt8U7cp63/YHjWN2e2NZS/Oyg/02p9?=
 =?us-ascii?Q?foKbleKR3T7OMmJZsUVMqgzBJySE5Gw0gmYvsh/EMbZr7q0cf6VXI5PqNWmZ?=
 =?us-ascii?Q?E2icAMxPpBElo6URwpOlhWScuG23uc38lB9+aPYQwcgSRlNHXuvsuvjPiQwv?=
 =?us-ascii?Q?0Hvh6RxccUXswHSKDFznxGZII9RamxmH4MWalCSyBw716TFs9SCmIUtpb79j?=
 =?us-ascii?Q?ZH9S7mOUx2lL4g+lx+t79E4QMr5yo5r6iKBCnPPRZrG8TyLhFkNT2S8xP5jR?=
 =?us-ascii?Q?gNaH4oEWvQz62tuTOQUyxzDKnpSzPUMjTSlf1OoZAkfR4dA38LCA0HZ3Mk8I?=
 =?us-ascii?Q?Q8af7Fm0ga+VBhNHtjdBTzIV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defeb944-7b85-46b4-f3a0-08d931c0111a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:24.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76rscAQHpa9lhq1CdWgzYZWqH2QZ7c7SA49Ja3wHq6QhqzkAUzl/L89I+8cPzVIB5cDcyYFmkVp2rLSWttNO9zyahgnFvgG/DGFn2q9XM4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: Ei1QqSENHSOWhUv0-z1pqw_QvhNzbG9Q
X-Proofpoint-GUID: Ei1QqSENHSOWhUv0-z1pqw_QvhNzbG9Q

Changes since v1 [0]:

 (New patches 7, 10, 11)
 * Remove occurences of 'we' in the commit descriptions (now for real) [Dan]
 * Add comment on top of compound_head() for fsdax (Patch 1) [Dan]
 * Massage commit descriptions of cleanup/refactor patches to reflect [Dan]
 that it's in preparation for bigger infra in sparse-vmemmap. (Patch 2,3,5) [Dan]
 * Greatly improve all commit messages in terms of grammar/wording and clearity. [Dan]
 * Rename variable/helpers from dev_pagemap::align to @geometry, reflecting
 tht it's not the same thing as dev_dax->align, Patch 4 [Dan]
 * Move compound page init logic into separate memmap_init_compound() helper, Patch 4 [Dan]
 * Simplify patch 9 as a result of having compound initialization differently [Dan]
 * Rename @pfn_align variable in memmap_init_zone_device to @pfns_per_compound [Dan]
 * Rename Subject of patch 6 [Dan]
 * Move hugetlb_vmemmap.c comment block to Documentation/vm Patch 7 [Dan]
 * Add some type-safety to @block and use 'struct page *' rather than
 void, Patch 8 [Dan]
 * Add some comments to less obvious parts on 1G compound page case, Patch 8 [Dan]
 * Remove vmemmap lookup function in place of
 pmd_off_k() + pte_offset_kernel() given some guarantees on section onlining
 serialization, Patch 8
 * Add a comment to get_page() mentioning where/how it is, Patch 8 freed [Dan]
 * Add docs about device-dax usage of tail dedup technique in newly added
 compound_pagemaps.rst doc entry.
 * Add cleanup patch for device-dax for ensuring dev_dax::pgmap is always set [Dan]
 * Add cleanup patch for device-dax for using ALIGN() [Dan]
 * Store pinned head in separate @pinned_head variable and fix error case, patch 13 [Dan]
 * Add comment on difference of @next value for PageCompound(), patch 13 [Dan]
 * Move PUD compound page to be last patch [Dan]
 * Add vmemmap layout for PUD compound geometry in compound_pagemaps.rst doc, patch 14 [Dan]

[0] https://lore.kernel.org/linux-mm/20210325230938.30752-1-joao.m.martins@oracle.com/

Full changelog of previous versions at the bottom of cover letter.

---

This series, attempts at minimizing 'struct page' overhead by
pursuing a similar approach as Muchun Song series "Free some vmemmap
pages of hugetlb page"[0] but applied to devmap/ZONE_DEVICE which is now
in mmotm. 

[0] https://lore.kernel.org/linux-mm/20210308102807.59745-1-songmuchun@bytedance.com/

The link above describes it quite nicely, but the idea is to reuse tail
page vmemmap areas, particular the area which only describes tail pages.
So a vmemmap page describes 64 struct pages, and the first page for a given
ZONE_DEVICE vmemmap would contain the head page and 63 tail pages. The second
vmemmap page would contain only tail pages, and that's what gets reused across
the rest of the subsection/section. The bigger the page size, the bigger the
savings (2M hpage -> save 6 vmemmap pages; 1G hpage -> save 4094 vmemmap pages).

This series also takes one step further on 1GB pages and *also* reuse PMD pages
which only contain tail pages which allows to keep parity with current hugepage
based memmap. This further let us more than halve the overhead with 1GB pages
(40M -> 16M per Tb)

In terms of savings, per 1Tb of memory, the struct page cost would go down
with compound pagemap:

* with 2M pages we lose 4G instead of 16G (0.39% instead of 1.5% of total memory)
* with 1G pages we lose 16MB instead of 16G (0.0014% instead of 1.5% of total memory)

Along the way I've extended it past 'struct page' overhead *trying* to address a
few performance issues we knew about for pmem, specifically on the
{pin,get}_user_pages_fast with device-dax vmas which are really
slow even of the fast variants. THP is great on -fast variants but all except
hugetlbfs perform rather poorly on non-fast gup. Although I deferred the
__get_user_pages() improvements (in a follow up series I have stashed as its
ortogonal to device-dax as THP suffers from the same syndrome).

So to summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-4: Have memmap_init_zone_device() initialize its metadata as compound
pages. We split the current utility function of prep_compound_page() into head
and tail and use those two helpers where appropriate to take advantage of caches
being warm after __init_single_page(). Since RFC this also lets us further speed
up from 190ms down to 80ms init time.

Patches 5-12, 14: Much like Muchun series, we reuse PTE (and PMD) tail page vmemmap
areas across a given page size (namely @align was referred by remaining
memremap/dax code) and enabling of memremap to initialize the ZONE_DEVICE pages
as compound pages or a given @align order. The main difference though, is that
contrary to the hugetlbfs series, there's no vmemmap for the area, because we
are populating it as opposed to remapping it. IOW no freeing of pages of
already initialized vmemmap like the case for hugetlbfs, which simplifies the
logic (besides not being arch-specific). After these, there's quite visible
region bootstrap of pmem memmap given that we would initialize fewer struct
pages depending on the page size with DRAM backed struct pages. altmap sees no
difference in bootstrap. Patch 14 comes last as it's an improvement, not
mandated for the initial functionality. Also move the very nice docs of
hugetlb_vmemmap.c into a Documentation/vm/ entry.

    NVDIMM namespace bootstrap improves from ~268-358 ms to ~78-100/<1ms on 128G NVDIMMs
    with 2M and 1G respectivally.

Patch 13: Optimize grabbing page refcount changes given that we
are working with compound pages i.e. we do 1 increment to the head
page for a given set of N subpages compared as opposed to N individual writes.
{get,pin}_user_pages_fast() for zone_device with compound pagemap consequently
improves considerably with DRAM stored struct pages. It also *greatly*
improves pinning with altmap. Results with gup_test:

                                                   before     after
    (16G get_user_pages_fast 2M page size)         ~59 ms -> ~6.1 ms
    (16G pin_user_pages_fast 2M page size)         ~87 ms -> ~6.2 ms
    (16G get_user_pages_fast altmap 2M page size) ~494 ms -> ~9 ms
    (16G pin_user_pages_fast altmap 2M page size) ~494 ms -> ~10 ms

    altmap performance gets specially interesting when pinning a pmem dimm:

                                                   before     after
    (128G get_user_pages_fast 2M page size)         ~492 ms -> ~49 ms
    (128G pin_user_pages_fast 2M page size)         ~493 ms -> ~50 ms
    (128G get_user_pages_fast altmap 2M page size)  ~3.91 s -> ~70 ms
    (128G pin_user_pages_fast altmap 2M page size)  ~3.97 s -> ~74 ms

I have deferred the __get_user_pages() patch to outside this series
(https://lore.kernel.org/linux-mm/20201208172901.17384-11-joao.m.martins@oracle.com/),
as I found an simpler way to address it and that is also applicable to
THP. But will submit that as a follow up of this.

Patches apply on top of linux-next tag next-20210617 (commit 7d9c6b8147bd).

Comments and suggestions very much appreciated!

Older Changelog,

 RFC[1] -> v1:
 (New patches 1-3, 5-8 but the diffstat isn't that different)
 * Fix hwpoisoning of devmap pages reported by Jane (Patch 1 is new in v1)
 * Fix/Massage commit messages to be more clear and remove the 'we' occurences (Dan, John, Matthew)
 * Use pfn_align to be clear it's nr of pages for @align value (John, Dan)
 * Add two helpers pgmap_align() and pgmap_pfn_align() as accessors of pgmap->align;
 * Remove the gup_device_compound_huge special path and have the same code
   work both ways while special casing when devmap page is compound (Jason, John)
 * Avoid usage of vmemmap_populate_basepages() and introduce a first class
   loop that doesn't care about passing an altmap for memmap reuse. (Dan)
 * Completely rework the vmemmap_populate_compound() to avoid the sparse_add_section
   hack into passing block across sparse_add_section calls. It's a lot easier to
   follow and more explicit in what it does.
 * Replace the vmemmap refactoring with adding a @pgmap argument and moving
   parts of the vmemmap_populate_base_pages(). (Patch 5 and 6 are new as a result)
 * Add PMD tail page vmemmap area reuse for 1GB pages. (Patch 8 is new)
 * Improve memmap_init_zone_device() to initialize compound pages when
   struct pages are cache warm. That lead to a even further speed up further
   from RFC series from 190ms -> 80-120ms. Patches 2 and 3 are the new ones
   as a result (Dan)
 * Remove PGMAP_COMPOUND and use @align as the property to detect whether
   or not to reuse vmemmap areas (Dan)

[1] https://lore.kernel.org/linux-mm/20201208172901.17384-1-joao.m.martins@oracle.com/

Thanks,
	Joao

Joao Martins (14):
  memory-failure: fetch compound_head after pgmap_pfn_valid()
  mm/page_alloc: split prep_compound_page into head and tail subparts
  mm/page_alloc: refactor memmap_init_zone_device() page init
  mm/memremap: add ZONE_DEVICE support for compound pages
  mm/sparse-vmemmap: add a pgmap argument to section activation
  mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to
    helper
  mm/hugetlb_vmemmap: move comment block to Documentation/vm
  mm/sparse-vmemmap: populate compound pagemaps
  mm/page_alloc: reuse tail struct pages for compound pagemaps
  device-dax: use ALIGN() for determining pgoff
  device-dax: ensure dev_dax->pgmap is valid for dynamic devices
  device-dax: compound pagemap support
  mm/gup: grab head page refcount once for group of subpages
  mm/sparse-vmemmap: improve memory savings for compound pud geometry

 Documentation/vm/compound_pagemaps.rst | 300 +++++++++++++++++++++++++
 Documentation/vm/index.rst             |   1 +
 drivers/dax/device.c                   |  58 +++--
 include/linux/memory_hotplug.h         |   5 +-
 include/linux/memremap.h               |  17 ++
 include/linux/mm.h                     |   8 +-
 mm/gup.c                               |  53 +++--
 mm/hugetlb_vmemmap.c                   | 162 +------------
 mm/memory-failure.c                    |   6 +
 mm/memory_hotplug.c                    |   3 +-
 mm/memremap.c                          |   9 +-
 mm/page_alloc.c                        | 148 ++++++++----
 mm/sparse-vmemmap.c                    | 226 +++++++++++++++++--
 mm/sparse.c                            |  24 +-
 14 files changed, 743 insertions(+), 277 deletions(-)
 create mode 100644 Documentation/vm/compound_pagemaps.rst

-- 
2.17.1

