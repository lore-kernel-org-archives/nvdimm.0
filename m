Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E426D33
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:07 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIawq0007633;
	Thu, 17 Jun 2021 18:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=5/EPvxLoSzQ6jqxssx/JQu9Lz9ChgjF1ZDvVmPGJq5g=;
 b=UwWbrL60mZ4XbySCxIpJ80KUZIluJ61g0HT+J51XG0WbxtOSnyH263gpTk1y3smgF9+X
 DBd2WNoHkbi0EA4TpjvBe+f2bZrcbOw7yiTuofhzrPSPv8JEhDVF7Nzhg5Lh4DbAUekv
 meyB//xwxB6bG5KNXSiSpK0otiua10qZ+bsQ2yl41XwfIEuqQp/VJ2MJaT4hD4ndAusp
 Tn46QT+EayXF2fDDQxwhieBcEomy+SSLBzUe4jJiv8LzmQFkD8nQBTSiXN2CZ1hw2/Tl
 /L8EDgMgLK+xj9urhEeyY1JO/cyLdbLGjrKjjSbPZjlIYefvkmwZ6pXD/0yECCnQmjC4 MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 397w1y1r6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjNxx165547;
	Thu, 17 Jun 2021 18:45:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
	by aserp3030.oracle.com with ESMTP id 396wavvr85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZU6Kf3xaMVtPpfHdWtPAfeI7lQSRwxw16Fm4DppWaj0QiXrduknA4DX557UPgVfN0q0GlSKZ6KtQfjG81iyTe4yDjg0EzsHcu55eROiOLL70dc5kfFIiRDNfx8vnI0WePWLssg8noHh25y38QA3UKQQLscNNamzKFS1g8CnZP0GdNF/sUey7Edy0seBC69MEph+oQ/onhUb7gmXTVv716oTwERgOpkTPAWypNCbNnTGsaDOdIbq3asybtLFqvlI2WO+YZnqDY02Y//blTuhGXEFQhjPThgcUGhphEUM85CF4M9N3u/QbxaRriAYDdG0sHEz5b2L1jI3mYsuEgYDQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/EPvxLoSzQ6jqxssx/JQu9Lz9ChgjF1ZDvVmPGJq5g=;
 b=BHp71CfFHVC7hU0pR5ycICEPvGatYPTZA4/MGeV8O/h8n65USEmQz9YvdHXnY9sUdIOj2yWedeK7V6pHoyGLDnqoSxVksQU89JHfX6/sBI1GKKurNwDLSUsAOsZ2Gr/UXxmLFpPAaml5X5tERaTTjm8PESrFgiTemhLtzfw0Lu7jQW5UJ3Foyl9CfbNh8dX+3jT415q0nrny1jomQgTh+L/Hr5DT5likOzd/6NvlqK/5s4JJrovWPGgYYZRyLNklrufoCe14+I0mpr5m5VtMGppu+lFvRxniMmog9jnaddI3ymArs+KZc0+AYOTICb1qJTThsmseYGQ9hnIRuYtZVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/EPvxLoSzQ6jqxssx/JQu9Lz9ChgjF1ZDvVmPGJq5g=;
 b=Zj09Qt9mWVGprLGGNpktlsFWD26uFyrS+Dkur24ljfNeJBDF88OAvE9J4BxHzSX0ahHekMauRLIZWdkY2WmakPavURQqKnLl0ERPYOXe5zIrniMOpO8NhGC5Gu1XU/mJJ7iRst4HDP6iFUXpm8U2HvN5GgdB+NSCxgKa7hSGAlg=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3983.namprd10.prod.outlook.com (2603:10b6:208:1bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Thu, 17 Jun
 2021 18:45:45 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:45 +0000
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
Subject: [PATCH v2 08/14] mm/sparse-vmemmap: populate compound pagemaps
Date: Thu, 17 Jun 2021 19:45:01 +0100
Message-Id: <20210617184507.3662-9-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210617184507.3662-1-joao.m.martins@oracle.com>
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 053bc3fe-8d08-47ae-8ec8-08d931c01de9
X-MS-TrafficTypeDiagnostic: MN2PR10MB3983:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3983D0F405312120959035D9BB0E9@MN2PR10MB3983.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	sL3Wo6XHpaO79N2IMi+2VrDungi4QtockDK3NAnOKuKPq1874/mXmsoEJYepPEYts/zR+SRwfB24l4835V4bVMiPslgBG6v+VM94q4zImT8svFT8ED77ubgMv65IbbUBHgkYJGrer3GzcTRlpzPUum+gLQFZG7uHZi36FGAQAcPxJ5W1I39omHQCpL/sOrbCtPzrFeofvNCbhOsgxCkH5Jkh6HekB9o9bYvLCYjjWya1NT9B+pc0TJRVqVZZz+rFkSnRMbo+rLOBE45SCZlpzBqr516yvd2pTXEHhEvm6+8MQfobs0YRa08urac0wpqJdSVOsvOMean678HI8/VV9KuMlP6UtXht40T4RIRV62vTKeriHnRZ6xf/FKftfhe8e6PGJ4d2X5kRKIK+n7O611fj5FgYM6TWD1bL2Orm8iinE5LvJRvXd6NRq6x+P1WUKcV/3DQTqK8W/ggYK8W12GhgU6nNQIx9ycnQcPZ3fPaDBD23j6Fj6iZ5qUQwXXO3XsPwMwik+Fy0vqy+sM6IqvsSgLD5Vo1zUBNIuJSPX/TEri91WQMF4YIDh1Lwyu4kCoBN5D1pYG7hLAtI7W39xEz7IomXNQplBvq7q9sHFDPaIQBjMtHxRNLhJCK9avJMm+DQ1U8eRolVZA2gJ251MDJ7g/a641CyQGQnXKWXzZw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(346002)(376002)(26005)(36756003)(16526019)(86362001)(7696005)(52116002)(4326008)(38350700002)(7416002)(1076003)(83380400001)(186003)(38100700002)(8936002)(54906003)(478600001)(2616005)(316002)(66476007)(5660300002)(6916009)(66556008)(66946007)(956004)(6486002)(6666004)(103116003)(107886003)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Hz/EDZM/Hi7VjRGjdigHm4vXI4v3Xj0cYS6OY2ZnGu37SatAXTFVBz6QOMxb?=
 =?us-ascii?Q?f2gMtwCLvRQJRWPACw/OzmWsHcjGx1a2rDnmK27X1+A8WwEa5PcKmXr0gnOf?=
 =?us-ascii?Q?ui6CXGUzGKBo/6pLajlSkPJLkd9M2xJMTbhIBYhf4yzZrPkyOpIdnUI876ra?=
 =?us-ascii?Q?ydPcu/RkJjDbR/KGHxi6GekO+LZ5q0brwhIfCWboPOIzr0Qeca+O0xPGPKLm?=
 =?us-ascii?Q?GwRABS7up+UxqENyh9s9vLybykUlTZA/E7lkn90q640cdpuxBssGVcgFSKTr?=
 =?us-ascii?Q?l48MZhW9ZEykmPtlA91CgIU+x5wswlNbma0SAIpY0NUtI6OFHcB41x7Ru+/T?=
 =?us-ascii?Q?8v4DRGh4376GYIeIEVf6TNqRDVsiZwjcjN2Eg974vWxS5KVQSbxXf1O4nBFb?=
 =?us-ascii?Q?1nHhhI0dLq4iOfXHJLHq4muPfDocfVXSKtpVoEyMA3ZqDQf5MmY+PHUjbS8c?=
 =?us-ascii?Q?+/eghHT3ntolFI+l6A45CppAPImtm1bvNtRnvEPLNcZkNdrugvQbDUuMnNli?=
 =?us-ascii?Q?FoZr2ArTFyUS0fA9sqso0348RqGlQXPrOdHDzl6MA0JDdmxEgOgMNU8/fXXX?=
 =?us-ascii?Q?h4zCnSOx3i8Lz3nNIJIYgKR36BqVslQzNF3BvQRW09KfHqOKVSfZE65tQL94?=
 =?us-ascii?Q?HR9rxDlpm+bGV6FXztq/3o5eGvuAAaVjEtPEadsFJWcbmTwiN31MZSeprDB/?=
 =?us-ascii?Q?IXmB+urqvmxFnsZFcml5jLWdIen0Ma37oaHs+k9popczlCEfSuEoi1ORKpNt?=
 =?us-ascii?Q?z8lkS09/q+EsnAio58bj3wp5h9oe6fACgZq7quGrfZ4n+XKHXNs1MZZ3+wX8?=
 =?us-ascii?Q?zznIHw4P9sA3gr/+cR0F1gsuCrhyVKUN97+2zW7w+qiBvb8CMytDD2c23d+U?=
 =?us-ascii?Q?XQ/kc9lUyO70d3bsTlCKtvHKwmwXYLSa1KS4qyZasOV1QbkhV6TgCHuqjdpu?=
 =?us-ascii?Q?TCS40TFU/EKZJePeQSKby/Hyl16GAXrExyHbyVf0oTgvgSp5LwHe5tdl88QB?=
 =?us-ascii?Q?aHoZF0R91ZTwbVtOk55YJghdxsp9anMYyBe7vDB19PWb8QO5a8YOg9njvl+s?=
 =?us-ascii?Q?uasXTJ5HaxbUNsAG7BipVm8Rg/oKT7OeG/NSOOdQn/qSz0lwFr11jwd1wfcI?=
 =?us-ascii?Q?0UnCDgDGMxm1vZvmAYCHbQVBVAds+ZcjhHK5nqnT+pRu1j0lRsBxm3SRElI+?=
 =?us-ascii?Q?Ril/IgCIKamwArQATTeGPg6+A1Bp1yOlALNRvLeflzhHHJDmL/qCCmmEjGVb?=
 =?us-ascii?Q?QlyFoUL4ZQxxOWT4QiY1l4HKDpGy78tw3JneR2QoxkSrpBPBYAwHWKnNxgsj?=
 =?us-ascii?Q?fM0mlfvKC/OdIMI+JeDNiab+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 053bc3fe-8d08-47ae-8ec8-08d931c01de9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:45.6636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9yaj5hzazF1xn2p0OATHa8o0z2Q83H3lj0+dPJldCuw7M65ovSbGD3FXYR78V44aO57dd4TqLd24kA9dfBIlVkGEPRgOAJpmedgvM869M4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3983
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: WanCUzMmarJPVCx2-eXlyREwxQx7x4ia
X-Proofpoint-GUID: WanCUzMmarJPVCx2-eXlyREwxQx7x4ia

A compound pagemap is a dev_pagemap with @align > PAGE_SIZE and it
means that pages are mapped at a given huge page alignment and utilize
uses compound pages as opposed to order-0 pages.

Take advantage of the fact that most tail pages look the same (except
the first two) to minimize struct page overhead. Allocate a separate
page for the vmemmap area which contains the head page and separate for
the next 64 pages. The rest of the subsections then reuse this tail
vmemmap page to initialize the rest of the tail pages.

Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
when initializing compound pagemap with big enough @align (e.g. 1G
PUD) it will cross various sections. To be able to reuse tail pages
across sections belonging to the same gigantic page, fetch the
@range being mapped (nr_ranges + 1).  If the section being mapped is
not offset 0 of the @align, then lookup the PFN of the struct page
address that precedes it and use that to populate the entire
section.

On compound pagemaps with 2M align, this mechanism lets 6 pages be
saved out of the 8 necessary PFNs necessary to set the subsection's
512 struct pages being mapped. On a 1G compound pagemap it saves
4094 pages.

Altmap isn't supported yet, given various restrictions in altmap pfn
allocator, thus fallback to the already in use vmemmap_populate().  It
is worth noting that altmap for devmap mappings was there to relieve the
pressure of inordinate amounts of memmap space to map terabytes of pmem.
With compound pages the motivation for altmaps for pmem gets reduced.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 Documentation/vm/compound_pagemaps.rst |  27 ++++-
 include/linux/mm.h                     |   2 +-
 mm/memremap.c                          |   1 +
 mm/sparse-vmemmap.c                    | 133 +++++++++++++++++++++++--
 4 files changed, 151 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/compound_pagemaps.rst b/Documentation/vm/compound_pagemaps.rst
index 6b1af50e8201..c81123327eea 100644
--- a/Documentation/vm/compound_pagemaps.rst
+++ b/Documentation/vm/compound_pagemaps.rst
@@ -2,9 +2,12 @@
 
 .. _commpound_pagemaps:
 
-==================================
-Free some vmemmap pages of HugeTLB
-==================================
+=================================================
+Free some vmemmap pages of HugeTLB and Device DAX
+=================================================
+
+HugeTLB
+=======
 
 The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
@@ -168,3 +171,21 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
 (last) level. So this type of HugeTLB page can be optimized only when its
 size of the struct page structs is greater than 2 pages.
 
+Device DAX
+==========
+
+The device-dax interface uses the same tail deduplication technique explained
+in the previous chapter, except when used with the vmemmap in the device (altmap).
+
+The differences with HugeTLB are relatively minor.
+
+The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
+PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
+
+There's no remapping of vmemmap given that device-dax memory is not part of
+System RAM ranges initialized at boot, hence the tail deduplication happens
+at a later stage when we populate the sections.
+
+It only use 3 page structs for storing all information as opposed
+to 4 on HugeTLB pages. This does not affect memory savings between both.
+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bb3b814e1860..f1454525f4a8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3090,7 +3090,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *block);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memremap.c b/mm/memremap.c
index ffcb924eb6a5..9198fdace903 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -345,6 +345,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 76f4158f6301..aacc6148aec3 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -495,16 +495,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap)
+				       struct vmem_altmap *altmap,
+				       struct page *block)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
 		void *p;
 
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-		if (!p)
-			return NULL;
+		if (!block) {
+			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			if (!p)
+				return NULL;
+		} else {
+			/*
+			 * When a PTE/PMD entry is freed from the init_mm
+			 * there's a a free_pages() call to this page allocated
+			 * above. Thus this get_page() is paired with the
+			 * put_page_testzero() on the freeing path.
+			 * This can only called by certain ZONE_DEVICE path,
+			 * and through vmemmap_populate_compound_pages() when
+			 * slab is available.
+			 */
+			get_page(block);
+			p = page_to_virt(block);
+		}
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -571,7 +586,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static int __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse, struct page **page)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -591,10 +607,14 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return -ENOMEM;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return -ENOMEM;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
+
+	if (page)
+		*page = pte_page(*pte);
+	return 0;
 }
 
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
@@ -603,7 +623,97 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	unsigned long addr = start;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		if (vmemmap_populate_address(addr, node, altmap))
+		if (vmemmap_populate_address(addr, node, altmap, NULL, NULL))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int __meminit vmemmap_populate_range(unsigned long start,
+					    unsigned long end,
+					    int node, struct page *page)
+{
+	unsigned long addr = start;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		if (vmemmap_populate_address(addr, node, NULL, page, NULL))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
+						  struct page **page)
+{
+	return vmemmap_populate_address(addr, node, NULL, NULL, page);
+}
+
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
+{
+	unsigned long offset, size, addr;
+
+	/*
+	 * For compound pages bigger than section size (e.g. x86 1G compound
+	 * pages with 2M subsection size) fill the rest of sections as tail
+	 * pages.
+	 *
+	 * Note that memremap_pages() resets @nr_range value and will increment
+	 * it after each range successful onlining. Thus the value or @nr_range
+	 * at section memmap populate corresponds to the in-progress range
+	 * being onlined here.
+	 */
+	offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
+	if (!IS_ALIGNED(offset, pgmap_geometry(pgmap)) &&
+	    pgmap_geometry(pgmap) > SUBSECTION_SIZE) {
+		pte_t *ptep;
+
+		addr = start - PAGE_SIZE;
+
+		/*
+		 * Sections are populated sequently and in sucession meaning
+		 * this section being populated wouldn't start if the
+		 * preceding one wasn't successful. So there is a guarantee that
+		 * the previous struct pages are mapped when trying to lookup
+		 * the last tail page.
+		 */
+		ptep = pte_offset_kernel(pmd_off_k(addr), addr);
+		if (!ptep)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the page that was populated in the prior iteration
+		 * with just tail struct pages.
+		 */
+		return vmemmap_populate_range(start, end, node,
+					      pte_page(*ptep));
+	}
+
+	size = min(end - start, pgmap_pfn_geometry(pgmap) * sizeof(struct page));
+	for (addr = start; addr < end; addr += size) {
+		unsigned long next = addr, last = addr + size;
+		struct page *block;
+
+		/* Populate the head page vmemmap page */
+		if (vmemmap_populate_page(addr, node, NULL))
+			return -ENOMEM;
+
+		/* Populate the tail pages vmemmap page */
+		block = NULL;
+		next = addr + PAGE_SIZE;
+		if (vmemmap_populate_page(next, node, &block))
+			return -ENOMEM;
+
+		/*
+		 * Reuse the previous page for the rest of tail pages
+		 * See layout diagram in Documentation/vm/compound_pagemaps.rst
+		 */
+		next += PAGE_SIZE;
+		if (vmemmap_populate_range(next, last, node, block))
 			return -ENOMEM;
 	}
 
@@ -616,12 +726,19 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	unsigned int geometry = pgmap_geometry(pgmap);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (geometry > PAGE_SIZE && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.17.1

