Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A716D10
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:20 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVU3Z022310;
	Wed, 14 Jul 2021 19:36:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9gl7ahGRX4/CQWnfgqY84S2/HDEsgBnAUIfSo+Y+DPw=;
 b=1H0i8/vxW7KuvnDPeZAGYFrol0UXYauAfWPd8uxfG5LmOWeKEr4AT3QnjxskEvM/36iF
 /a7qcIWt2XRmCaywF+plYPpnhg+vtdMRHmHKAp+PJgtv8Egv57UKkqqtfVO+Mgx/Vfel
 FVGy6X3TYUsigru96MJnvE+Wj3l6reYBaUf9MkeZUi0yj8jNSnadf+sjLm3lZdgRr+vh
 Mur5qxlG1/y2z3A48ZFjC4QqhGSTbGO3zL9MwugP2qGNKm8EILwef4SAB+Xtsfp2sCyu
 ymliNYq2oZAx0PdmolGy04RGmB+bXo9kg3xwXMrs45J2q/hk6pznvEQ5fS/vlRhE6QYH aQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9gl7ahGRX4/CQWnfgqY84S2/HDEsgBnAUIfSo+Y+DPw=;
 b=ylfLmsDO4s4M/gKtjTJQrR8YLNas/SVxU60FmID+5G8cAq1uqPnkVaxkE+V7xNECxG6U
 MuUtxAjAMys06vtGOGWDFiQyMooaUzH0GvSB5kx4v1NSmFNAQxswGnJXyQVVHpG6bWKc
 iGK3oW9Jg+RBF8j1zXYuVoa2JrCnKUkAen4CKiaczJFwf6DzLE8iPTOBcF9KpUD8oJqX
 yWOajPIaazlrRHCKEZxJ4J6i7M/uhSvkKFDxbqDTQfwaV7QU1q7ly16hE+8GsQKlDHWF
 spLDLr4U1vkbdIlwOsMzHIdjSKfbsMVmYuoET6QLiN1PLChLEh4rsIAvTKwNRG0f3H2q 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 39suk8sejf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUokv114218;
	Wed, 14 Jul 2021 19:36:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by aserp3020.oracle.com with ESMTP id 39q3cfyytm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuEi6WGxyZXcT3Ec72nxiFfd62EzIB88x1xEBXDfbW7GfjwMoG635Hajq+iAQPVbLQpgaINw95D5AiDbzZGsbWo0DDRo8rsQnKgDEKcflW2wc/QRUyoSTcgpoWtYRvTQqsPMdgqdjNU2NOrxHC7Q0y6iutr5Dk3ByXszsGqvdYfkpwNlgHmzOTzV9+ioW9aMgp8rHmQ0pUksACJ1HnnlgB41ubP1BU2h4VOwNWH+Vlq4ZKkdNrT1uqHf/sq57GcOXWQiY2TLHBlDJh7B+B34Ht2s9/ensAPgPjiRUuAYmXov0kqq88rVPGir4WXUXVefJGJFM0wQdmax7pxZMIYKBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gl7ahGRX4/CQWnfgqY84S2/HDEsgBnAUIfSo+Y+DPw=;
 b=Qs5mMWb8lyaQvsvZcRg+9gP3LXY09y4N7V3ik6tPVPJyJEeubeuoe3P8CfdJYKZcH/enVdU6/r/GQD3MsLgdbHuVHJA4s7eKiZvl2g8jMnbYfS6b869d9u7sruEUwpaXpBRcoinYDWfKnGvRVSgA7g0mUPjvjPbCNkSiZ9roJ05ws3z36x+lEI/TQAJ+KYAjdno0ugIDZs7WZrMnckjnGKiDub1twm1SM8UVTpRC1G0NVokYLX2+BejBdppnDUhO0b+tSvc+7FJvYSb8RslWFLFKGXUNYhDG4XTXwBpJa9qfXCiJto0gm3M7ZlxAYpAVh64tCjOJNwwGAWrTzgBoeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gl7ahGRX4/CQWnfgqY84S2/HDEsgBnAUIfSo+Y+DPw=;
 b=d5qn5U41ba2m/xWIqlkkaQLJPrd9cUOQw4smv+CCU4OTcIxYlOt1DoDG118OVJMp+DGnVmSX12nWZUh3MEKU3Y44X80CubQFCfPezDTVQKOE2n1di1eHQ0Cy4XEoXPx7hsmi7Dcn5vd/xu0ZVYvBngl0gNnSkGQeDEtPkt2Fzok=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4080.namprd10.prod.outlook.com (2603:10b6:208:185::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:36:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:10 +0000
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
Subject: [PATCH v3 05/14] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Wed, 14 Jul 2021 20:35:33 +0100
Message-Id: <20210714193542.21857-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210714193542.21857-1-joao.m.martins@oracle.com>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61a46144-e51a-451f-7905-08d946fea221
X-MS-TrafficTypeDiagnostic: MN2PR10MB4080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB408096B820C8509F33F1A27EBB139@MN2PR10MB4080.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xmgwBwQjObuPEQdR6B0Kyy3heMPop2zKbMk0MsWE/o+gw7yDDijOW6Qq7OG/+MFgNMFpGYAv133riloTYPsGnJK2Vb8NzwK/ACyPEJVLzOfTr2gdM29AW4mm1gfBeq+vD7B/y/ewAu+6DXNyGXMuobspLu4tszOqDKjVLNVVOZ+hHmIZc6bMIzj3loDnU0ac2hcNfynLL5FgW1uR2/rX4gj3KfMqJs7uQIm1ENBHfhDxVRXmKtTh0PrsDrq1XRTLi6tYglMaRTsqyiovWqytgg6RLotNQqE8S/U6/0d3U6HI3sw6jbZG2OU4TuDW1qjXWcAWkMfSxrazqUZZLLNXtbq93LYbnS+36UyKo8SXspk4tGXZ80s5swSg5eKKINmHTDx+ZZf4oa16Q87elYM0Ruakr6VAEGdZTKm96HfNzpTPQ88aVFOMNFfUlU9vXyIR6/XPrcBGu9FxekfF5TVf0CcjIKB62IYH0B9MDGSTKlYEiTfXUfvUChEGcgU8PMiL/29phkFvBueRWwj46C3IpwtjD0sNT19WYfXdZ0iJq3zM4rJRDD989qXpVOA74K5XNjiQEp9uMtpTItktB0Msir0NF7emz6+qScEh2EijcjHP3HRD1pa4vpj3DoIeyapkwHqePl9qx+SLTJkSE8X3iAx7AtllIbiuOvXklcFdly3fixZomz2e7c6bIHSykGrqiUAyoLw43UmretTkGes0zpenVFm66EQWRTVJ1CObpIquskyUp79QVDobrtIyKlhm3gVN4hSNQcrYq/w/aM84rtB03QdPpw3G/htv5xs/w0w=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(39860400002)(136003)(6486002)(8676002)(54906003)(86362001)(5660300002)(36756003)(478600001)(186003)(6916009)(966005)(8936002)(4326008)(316002)(83380400001)(52116002)(107886003)(7696005)(66946007)(6666004)(1076003)(2906002)(26005)(38100700002)(66556008)(103116003)(956004)(66476007)(2616005)(38350700002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0Im0LBEvm1yS38qPlYLo8zCfvgOcS5F+xWQdyzdZt80Wn4XovAIfK3PPEA1r?=
 =?us-ascii?Q?k/hNDsrDgyZSTiqdvYd5wYbmUAeAZyjD55isuv9l/3G1ZLfv2ZiBGOdd0UnM?=
 =?us-ascii?Q?h9aFvOwiIjgeY7iuz+SqVI9kQLZqovUNNOp7sg2f4oHIXAGU6Mh+LDV0Bl/b?=
 =?us-ascii?Q?XtsfESkcm8llQ1gPuhmkJLokKHhXfgEsrtknBuv4FPSGhmub9/z3VTxGguYs?=
 =?us-ascii?Q?jaiEU9n4smIFaEBeCiHbpq6vh8g0d9YU74c5FAxQz0RZvevHhCCAlBP9X8qY?=
 =?us-ascii?Q?lvwiQUNQ1Dzjf98SUaMFV59jSf6LN5H+71PT52oK1aHWmAn66PJWXm7TWMmr?=
 =?us-ascii?Q?2nVcaOi2cuwTVSE9iRSJWh6Og9PdmAJ6y0cumghpDKuC5cucRAqwCGt2/8yR?=
 =?us-ascii?Q?sSsX0DwlMiV1ZWs3ca4GE7pOkJAn9sHggGTJqxui5SykRrU+LRg8nDy4j0lm?=
 =?us-ascii?Q?WTPXF004elA3vQ1P6Oxlq/uPfG4cANobsJYZnq4BJsH/kqHUveSoj0PbkX4m?=
 =?us-ascii?Q?ZP/Tdet+rZXLFnb2b1RYCD7Okz6lnFBmstQCgjV9kLs+yuxHSVGIURqjp/js?=
 =?us-ascii?Q?1alUHbYkLMFLNUNAxztz1y9xLFuTyJrjL0N9/QPOY5aW/XcNnXoPOIGdi6ta?=
 =?us-ascii?Q?VwTnBT0Yk4SqKBlBgEM68Ojf0sKKDL6o59gDJJ5sXcCDMQFNYuPIUQlqomN5?=
 =?us-ascii?Q?ritvZ0xFbmfs36tQOj30SejKS8TTU5Lf89lAyJn2uDqoDGI46N7+X2SMjBZx?=
 =?us-ascii?Q?GwaIodmxWgZqVyODya95/Hljs3BIZIdnf0Wc8XkiIc1lZYRFRj4kAYIG6BSR?=
 =?us-ascii?Q?1fSen60uOcstVayJ0zBlnb5/8cW3l3VG04DaIgf6kpul9/n26Lyj5Qs0CtsP?=
 =?us-ascii?Q?XeZSNPDXj16QHIgs8yBr9/7LCG9Vj4qUB1oRr8KTKYmjG2avDBGeFH7x4vtx?=
 =?us-ascii?Q?j+U9ix3Si9tcLQ/hy5QJ+Xjt09Bb1wqUe2A/MQ3UmtJCHht12fBqqlfOeJs0?=
 =?us-ascii?Q?kZf9ja90iQU/DZehTHk9t2wdGffKji1m4WN26knBRSO9jPB/7UzCB0NM33LS?=
 =?us-ascii?Q?hF1EGIjumZqhYpUG+nZxl0fGBO8GOJp+Urw0/r4Az61qiskLcwsdEnZHws77?=
 =?us-ascii?Q?MPxdIu/+3awGO9Oe36lKMeEFvub0MlN0It5ErpH7pNDr+0LVfmrNfFpXW4Iv?=
 =?us-ascii?Q?gO1d7qAgQRRqADFUbdJrp6U90aPIRLHo+SfkfErIB5XkD7u1AYwsvyhPNPhh?=
 =?us-ascii?Q?mo8sOTx46tFHY1sS3fBScT10jgF39+SfxwRJLfeZmQ0QerKifpU4auq9vSjO?=
 =?us-ascii?Q?TTVRe7cXP6clBrQ8/8UQWQlb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a46144-e51a-451f-7905-08d946fea221
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:10.7237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EqN6kIli+EqIJGV4n3IhZO1tOhhYwbZemXLyVDHrpDK7yIQN+bg1GDIrQCAxGDc/KgLVN6rXLVQEngYETE2nosSLINh6uZEF9NuOWKvV+4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4080
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: vTU9N2D7tfGNEsuemFJwZ34Wx82aiyen
X-Proofpoint-GUID: vTU9N2D7tfGNEsuemFJwZ34Wx82aiyen

In support of using compound pages for devmap mappings, plumb the pgmap
down to the vmemmap_populate implementation. Note that while altmap is
retrievable from pgmap the memory hotplug code passes altmap without
pgmap[*], so both need to be independently plumbed.

So in addition to @altmap, pass @pgmap to sparse section populate
functions namely:

	sparse_add_section
	  section_activate
	    populate_section_memmap
   	      __populate_section_memmap

Passing @pgmap allows __populate_section_memmap() to both fetch the
geometry in which memmap metadata is created for and also to let
sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
whether to just reuse tail pages from past onlined sections.

[*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 include/linux/memory_hotplug.h |  5 ++++-
 include/linux/mm.h             |  3 ++-
 mm/memory_hotplug.c            |  3 ++-
 mm/sparse-vmemmap.c            |  3 ++-
 mm/sparse.c                    | 24 +++++++++++++++---------
 5 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index a7fd2c3ccb77..9b1bca80224d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -14,6 +14,7 @@ struct mem_section;
 struct memory_block;
 struct resource;
 struct vmem_altmap;
+struct dev_pagemap;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
@@ -60,6 +61,7 @@ typedef int __bitwise mhp_t;
 struct mhp_params {
 	struct vmem_altmap *altmap;
 	pgprot_t pgprot;
+	struct dev_pagemap *pgmap;
 };
 
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
@@ -333,7 +335,8 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_section(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap);
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(struct mem_section *ms,
 		unsigned long pfn, unsigned long nr_pages,
 		unsigned long map_offset, struct vmem_altmap *altmap);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7ca22e6e694a..f244a9219ce4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3083,7 +3083,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8cb75b26ea4f..c728a8ff38ad 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -268,7 +268,8 @@ int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap);
+		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
+					 params->pgmap);
 		if (err)
 			break;
 		cond_resched();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index bdce883f9286..80d3ba30d345 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -603,7 +603,8 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
diff --git a/mm/sparse.c b/mm/sparse.c
index 6326cdf36c4f..5310be6171f1 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -453,7 +453,8 @@ static unsigned long __init section_map_size(void)
 }
 
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
 	struct page *map = sparse_buffer_alloc(size);
@@ -552,7 +553,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			break;
 
 		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-				nid, NULL);
+				nid, NULL, NULL);
 		if (!map) {
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
@@ -657,9 +658,10 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap);
+	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -728,7 +730,8 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 }
 #else
 struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	return kvmalloc_node(array_size(sizeof(struct page),
 					PAGES_PER_SECTION), GFP_KERNEL, nid);
@@ -851,7 +854,8 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
@@ -883,7 +887,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
@@ -898,6 +902,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * @start_pfn: start pfn of the memory range
  * @nr_pages: number of pfns to add in the section
  * @altmap: device page map
+ * @pgmap: device page map object that owns the section
  *
  * This is only intended for hotplug.
  *
@@ -911,7 +916,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * * -ENOMEM	- Out of memory.
  */
 int __meminit sparse_add_section(int nid, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -922,7 +928,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (ret < 0)
 		return ret;
 
-	memmap = section_activate(nid, start_pfn, nr_pages, altmap);
+	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
-- 
2.17.1

