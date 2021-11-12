Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F112C80
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:28 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACESmWC007211;
	Fri, 12 Nov 2021 15:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BI6yNaHxxMrzht4ixewrCrLdJzu85PxHJWx8g0dNNIA=;
 b=yG76r1pyDAlbLLT5VOBbQYeA0Wg+ImhAMfyGLosQvfczN3G/w7BVE52ROQ03w4GBi+0W
 //rWbjj7vOxfJRoOnU2mJPY8UaMyeKIsUUn4FAWHfROJyvindzo5PkcrUxi3EKAsT0X0
 h5NprzQKTNSAEo8ffm5ubVdbnB8ZlG4iovUHY2fctVqd6CXS1j428HDVFBJakvkn7kvh
 6L0dOZd/GrdWQSwH5mwxlaJzfMNJCR9lZRxB8GoNie2YzrQJItvY2hpot6V3RXske7qy
 mo1QkhKGDwDdqbUOiXkdoIttmRACCRFXUmOhkHUfV6eSBQbBH3SV3wqs+J5Vf8YUcA6b VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9gvs2fcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF5xBM196462;
	Fri, 12 Nov 2021 15:09:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by userp3030.oracle.com with ESMTP id 3c842f8xgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TF2mZRVJeM/5yQNw0yThxA1Mbo3DyO6S9/xrn4L77Lf3OXmEisdQZoFT5nS1VCXvWnSvfb8rWzzSe1ydiJbvXvWblFMj5QwY1HfdkX9saGEKVZGQyHROqY7fzdgNvZ6u+Qjm00uR75WigVvKiixNoYSWKAaQhrjChpiO2yPIh8WLAZ9n6O3rj7IqUx8g4CTYrCCEcWtMBYqgaaXQhtgdeGuv7tpCrgyz1UFd71CSndxM0moJ/yfgVwt1QgKSebGBlMflYW80FEKsc0JivwDPqiQv8Qqi2mGR5LFFfffO/xGlYq0HtSpDnpTM7b/ziThMlrP6WVQ4CiUpyZBFfAFeqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BI6yNaHxxMrzht4ixewrCrLdJzu85PxHJWx8g0dNNIA=;
 b=Ek3vb2dFQJFUNpavI2h5XBDqWJPiwszio9KCS3Q5W0zThEj4bAMCnzE3MAyuIvVJG4NeuecgKSBKc4mwG7Jr46KomNjAtxQsXw+ahIQr9D5wH2M+kPPAcgBI7srHA1nkI/o831xJO3ERoq0w3eF4usP/DcA5icLkwYbldt5uvG3jp6s8TbVVnszQ7s4VhpFMxfHJ7aDM1JC63k0M6qlS2xcNCmhKZtih6Sw3fU7FrclP2ik0uyaCiXvWUjIaqzik3DWmLUfnrFPMbot0An/qs9Ua6jOuvn+fd9cJ8dSez5LJHihWbWr4K1eb7khaD1Bz2+aiyX2YIkr+APLRDmtrkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BI6yNaHxxMrzht4ixewrCrLdJzu85PxHJWx8g0dNNIA=;
 b=Y94sOvoMggCi/8cQjKUi2GvBrQmscI2jjz7Ums3axUzukde0w5Gu4ofRDE8sxZ1Y3fJ6ngbnvPFDNX7iiOD7U4BDxHozEoa3KzukQAWWU1JsKpeZw+O9JH67r63/dTsK+EOgCVcFOQnEp2MTzE8VHYSDiZbdyD08MpIBfDQOOKw=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.17; Fri, 12 Nov
 2021 15:09:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:09:12 +0000
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
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v5 4/8] mm/memremap: add ZONE_DEVICE support for compound pages
Date: Fri, 12 Nov 2021 16:08:20 +0100
Message-Id: <20211112150824.11028-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211112150824.11028-1-joao.m.martins@oracle.com>
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0134.eurprd07.prod.outlook.com
 (2603:10a6:207:8::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:09:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff84066d-01e4-4a77-8af5-08d9a5ee622e
X-MS-TrafficTypeDiagnostic: MN2PR10MB4223:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB42231FDF5D31AC04CD4CD3D8BB959@MN2PR10MB4223.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	MMySkFnFbRiiL3kgXJVrpHfRZz189gmjNKPjLixi1cWGWD5rzdODmerqSG0DFv6bnv2n+bfu5KnAe95JCvP6pkALQQWxXQkWbfhWA4MgD117YJ0DuM4K5oH8P4sS+/5mRSKZkPoS6THLJwPVXs7eawS2UP9Ex7ftpUXcL4NVkBPdCP691bBEpstgqMzw1y9LZxzAgxIjME+CahC24YQZbdgGyGdHy5DUyvOvrXvGzComHN3cKbhD4n5NMTZKG41Y2aJylhC+BPLopEihi1u5cLxO5KsYlQELGUUcHOsX3XrXEDwOb7PCG9ANyjFRtpVpxhaQsk4omcaNSbMEs8aFip46aXR4yCdKIOVZ9zbD6C00KN7BIk6a3FeI7JoV856qsziE5Bim8JkuFD4qJYJ3G1rVzRuyBvrfXXKibDfm2xXkZDqcvWoZZT6tAxnTL21j6GbtCYY6VulzJk/eE080gK4+6XpKrVYgs8luEntlptYMxoJqNVCkm41g3BiiS1crs0i5wbW8g1agLhK/2R0BVzNDqyDU8kqXDRXFiIxD16OikxLdUbHWB+Tm8iWu7YwL3eYSUYduP9Cfwm2fF6YQ4j9LCLvNyq7n5q094R1w0G0D4cRoq6D+73v9D70dPiseW6l6eCbJtkEyboznZtodR+eCKSwe7GZ1S4kyAYWkm9AvFkp2BwlSMMA/aI+uS9Z+5yRRF6tcZ0Wr9OwnydkWWA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(5660300002)(2616005)(107886003)(2906002)(38350700002)(38100700002)(66946007)(6916009)(6486002)(66476007)(54906003)(1076003)(66556008)(6666004)(52116002)(4326008)(8936002)(86362001)(36756003)(103116003)(186003)(316002)(26005)(956004)(83380400001)(508600001)(8676002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?/4oUOK/DIL8tMBSoAnVIEGmcQ/sSkFqNPbLbjJUrvKFMJ4rjQ4z+Nk3q5D9V?=
 =?us-ascii?Q?leHJX0s7x/Fh9FvYHyxUrns0s87JBneP+u8usdOssGfsaX4PWJHzPIBntqrK?=
 =?us-ascii?Q?zIowz11EmXDus3D8LigCK42Wm2HFPB+PD9SXT0gV2iqNdM+lsAdtnShA7eKD?=
 =?us-ascii?Q?I1EsI08Prs/96Xwy49tkiwFkBnHPmFN+qZ4bxgNaETGoFRktcOzih/0ih9QC?=
 =?us-ascii?Q?4KN7adG3Aib5qQBpch7nMa3p94pJuMtKINtJyemd+lOFNyeBLBe8U/1Nt9Nz?=
 =?us-ascii?Q?en2fOLU6KFrKZo9Wv5IR8VyUG+GVR8ktUkk8prfKps69EeBFsW/o52EGjVwx?=
 =?us-ascii?Q?9chbmItXdBQyJzLR9mWYSPQKDFvoezzqS41GEuVRe9nRE2jvODcujIOCJGN/?=
 =?us-ascii?Q?Bx+l9Il/lnFCVUc/OkVrMMRGpz/F7v2n3MBvk4Bh8+A6hYTV+YuaRZimFE1E?=
 =?us-ascii?Q?Vp5oeugZUs05vjiU/8w/jc7iU8SX236S9zyigpY0QmN3BM9WFvRVc7p0FMvj?=
 =?us-ascii?Q?8GEdHnoR20DCUZqNAvcamPQekkYjk7cSm7ik5TwppIm23KKlLmzZZ4NIouRx?=
 =?us-ascii?Q?OFtDXDSKl+VQG8GcZyRCK+/Jgun/0vI2+JKNCbQhf/BKL+AeYot4z0AiSVG1?=
 =?us-ascii?Q?2oHXnrLwwzGOXs59d077vtuTuyoiGuBqghxdDrtReFjtLIFiHJlyQ7173nyd?=
 =?us-ascii?Q?aTC5ha3YxYGvHcsu6c1KAQ3BsiDnGfhIac2eR9X8G2DlGkuLMNqp+qltTfoo?=
 =?us-ascii?Q?PZ/S29KUynS7wT+uZs/x8yqJZl79NxA3bCMXMHSeXCp9LsDoRiC7Bn+fweSq?=
 =?us-ascii?Q?wuWJzfjc8VdPWl+qLdKHAUH6p7GYBc9C/fEDsOGA/zMEzHFPVeDBXdzU4J+p?=
 =?us-ascii?Q?uRtK7LOP/pgNfOQlV63/SgjbroTL+xDYdQApXtQBBzd8FLAYwxhDsTuGWtBo?=
 =?us-ascii?Q?mWSTpZy6I1rJNW61iQxvpgkbycmiA081bGhfBNevQVzVFaEIsotY2WzNH5ct?=
 =?us-ascii?Q?dVnJp1+K/4gevABG0WbCO3Xgjac/ITuz98Pgsl56wAdV0O0PfjmV+Cyua8rD?=
 =?us-ascii?Q?E268FbCa5jW/RsHQIwqjsv3ACDrLCMmqV8lByr1cFTeLgv1Dhxv7A48A4oO0?=
 =?us-ascii?Q?WMNwMGxidJNGJogg/97mAUNRAWfGVGJu7U1nxfxCO9wl59+N4Ky9djI6Zhup?=
 =?us-ascii?Q?kE0n1OlYxscYWFeNod7B2bybLzn4fMz1qqC2skE7FGAOAWdM3xvCiGgdie0X?=
 =?us-ascii?Q?RUZa4rsk6cD2KW/R5rds4o6rzy0Ok6SenFyWoUyteIRhC9+lRdHvjJhFUvDx?=
 =?us-ascii?Q?LUIHr82fy8+RscCPJqQ8e7PxxjE/cd9okCBJ4wWyqd41b3nbPGPlQvFlZNXU?=
 =?us-ascii?Q?+Y8MTaQKeDVzpzJMsIMflhF7OEkAQKcH6VvM9bGCNwbIvfzz+item1xOquoC?=
 =?us-ascii?Q?AacUr8rKIbBWVYpva3uvSOcxN15R09jFyyr9K4FyZfKxigZj1Xo5LLsvkQ1d?=
 =?us-ascii?Q?hGns9ZwNBNIYEPpylJsFoz2yoLxsilAkJxhSatZC35OMRRf6xRBgip+2ivD6?=
 =?us-ascii?Q?TdDR4BM4ukztJT9c9IQHJqX1vg2NYbAobsPSlidBhAZSvYCtP6Fn1XJUD5bU?=
 =?us-ascii?Q?oHa0xqDdTXH8/yp5FWh5KvgTcNDKVXYt7o+qH+aGU8HssDbrxdQB5xnXVFsc?=
 =?us-ascii?Q?bgO7gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff84066d-01e4-4a77-8af5-08d9a5ee622e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:09:11.9833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZVEjsN6yn3JO+2qO+KUl87tpgFD2bLSckBriUkfCe65gung9UDIXPLfaZCiKN2x3uhCNYTJ9QDqapxQSVvboss98HtzS1JFwQYUas/QSO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120087
X-Proofpoint-GUID: RpdZ555mqTT4iYSxr_C90VYnkrZ-6N6a
X-Proofpoint-ORIG-GUID: RpdZ555mqTT4iYSxr_C90VYnkrZ-6N6a

Add a new @vmemmap_shift property for struct dev_pagemap which specifies that a
devmap is composed of a set of compound pages of order @vmemmap_shift, instead of
base pages. When a compound page devmap is requested, all but the first
page are initialised as tail pages instead of order-0 pages.

For certain ZONE_DEVICE users like device-dax which have a fixed page size,
this creates an opportunity to optimize GUP and GUP-fast walkers, treating
it the same way as THP or hugetlb pages.

Additionally, commit 7118fc2906e2 ("hugetlb: address ref count racing in
prep_compound_gigantic_page") removed set_page_count() because the
setting of page ref count to zero was redundant. devmap pages don't come
from page allocator though and only head page refcount is used for
compound pages, hence initialize tail page count to zero.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memremap.h | 11 +++++++++++
 mm/memremap.c            | 12 ++++++------
 mm/page_alloc.c          | 38 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 119f130ef8f1..aaf85bda093b 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -99,6 +99,11 @@ struct dev_pagemap_ops {
  * @done: completion for @internal_ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
+ * @vmemmap_shift: structural definition of how the vmemmap page metadata
+ *      is populated, specifically the metadata page order.
+ *	A zero value (default) uses base pages as the vmemmap metadata
+ *	representation. A bigger value will set up compound struct pages
+ *	of the requested order value.
  * @ops: method table
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
@@ -114,6 +119,7 @@ struct dev_pagemap {
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
+	unsigned long vmemmap_shift;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
 	int nr_range;
@@ -130,6 +136,11 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 	return NULL;
 }
 
+static inline unsigned long pgmap_vmemmap_nr(struct dev_pagemap *pgmap)
+{
+	return 1 << pgmap->vmemmap_shift;
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 bool pfn_zone_device_reserved(unsigned long pfn);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
diff --git a/mm/memremap.c b/mm/memremap.c
index 84de22c14567..3afa246eb1ab 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -102,11 +102,11 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
 	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
 
-static unsigned long pfn_next(unsigned long pfn)
+static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
 {
-	if (pfn % 1024 == 0)
+	if (pfn % (1024 << pgmap->vmemmap_shift))
 		cond_resched();
-	return pfn + 1;
+	return pfn + pgmap_vmemmap_nr(pgmap);
 }
 
 /*
@@ -130,7 +130,7 @@ bool pfn_zone_device_reserved(unsigned long pfn)
 }
 
 #define for_each_device_pfn(pfn, map, i) \
-	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
+	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))
 
 static void dev_pagemap_kill(struct dev_pagemap *pgmap)
 {
@@ -315,8 +315,8 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
-			- pfn_first(pgmap, range_id));
+	percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
+			- pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift);
 	return 0;
 
 err_add_memory:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23045a2a1339..d59023a676ed 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6612,6 +6612,35 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+static void __ref memmap_init_compound(struct page *head,
+				       unsigned long head_pfn,
+				       unsigned long zone_idx, int nid,
+				       struct dev_pagemap *pgmap,
+				       unsigned long nr_pages)
+{
+	unsigned long pfn, end_pfn = head_pfn + nr_pages;
+	unsigned int order = pgmap->vmemmap_shift;
+
+	__SetPageHead(head);
+	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		prep_compound_tail(head, pfn - head_pfn);
+		set_page_count(page, 0);
+
+		/*
+		 * The first tail page stores compound_mapcount_ptr() and
+		 * compound_order() and the second tail page stores
+		 * compound_pincount_ptr(). Call prep_compound_head() after
+		 * the first and second tail pages have been initialized to
+		 * not have the data overwritten.
+		 */
+		if (pfn == head_pfn + 2)
+			prep_compound_head(head, order);
+	}
+}
+
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -6620,6 +6649,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
@@ -6637,10 +6667,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+
+		if (pfns_per_compound == 1)
+			continue;
+
+		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+				     pfns_per_compound);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

