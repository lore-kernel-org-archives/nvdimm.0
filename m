Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0FA29CA
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:45 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOIFNRr000722;
	Wed, 24 Nov 2021 19:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=h5SstNmQ1cr0H/SJe72geipxNFA/PXVszrLlkqHDrcM=;
 b=uPXyPTNhrBx5sTZTnLJoPTRLbQqubXsRp4aCPRE8NMkMNALZ2mlwEo7zYInf95RQMSvF
 9rzl69qJhuDRzQyw9bmy++LKy5RVdvw8MtokKxT7N8ET7ofnu2iBx769DckVNqn4QXX/
 LXWBY/JH/81zUNjY+glB1rDrrFoLLnJsVkf9DsXJFLCPKinhc85refGBFqHuSho+RaXC
 JZBIs8Jhqi5kAyubXzZn8EWnn1uGxGXY+mxqinf+C5FLDr7ja+fl/nPRuy7d2UAO2+ti
 VerJN+88SwMwI97lZu25E9ZfHzYWv8fYKNGau6ep/wsGGCMMxlq2EqoX1xh/T/ePaQBs cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chkfkb0cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ0rqf192929;
	Wed, 24 Nov 2021 19:10:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
	by userp3030.oracle.com with ESMTP id 3cep526txw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N78WciR/tOaublq+e+1K165/jLijI71vq+jiPSIsbj2CJrUm62OmwYCgoF7Vk8WmcDJKvrBExX4lAsbZny8mkyJULwGxD5If00fowI0HUD06PaCWP78jC+Q173w8hFv4Dr+H2uLkFEuik2irLqdfe7N2KfPe5/6VJXGMGqI4XVKBRZM1MKebwYQu0yYovuTNVT+OTksBe+vxZP/gtoyZoCxDJSrYsMz9tdmij9jPhkIi747PNzGeMJIhOoGyMolLMbCvzbQUHiOeNhyfqMVoI9cReSTWc5xM/OWgeEcDPwTI8phAgCJANZn0f9MjRtzDVk2ozcbKTMzpo4Ddyu8KGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5SstNmQ1cr0H/SJe72geipxNFA/PXVszrLlkqHDrcM=;
 b=Xm6T2Y1FGOl+5e1x+V7ZiNYmqLbj4ixYjNj+5+kAq1vFVF1uRtoJywVjktGg02CjSD5mr2ccF8i98B18Tqq/s9xLMlf97Fj7AuYLxrb8O7dBkZCx6XCFbOwD8dwBFoMChEJTsnNAuCDVDEpQDe/kQdEuKJy4cN0QvBopWwSRsYrIovJ3KwFXgCg0JB6lwtwooINMjXRcyUK9egS5z0c1iQRFLlPyD2iHWIz3JJb45DsIY0PN+l4GzaYxk9fgt2tphaHF5dSZU6xq7Wxy6WtobkwxQk79k14RNtTdhOZTtmKmAPIIkr6DTQFu3RhZsr7FEmxF+jCnH+2N7TECJ/4RTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5SstNmQ1cr0H/SJe72geipxNFA/PXVszrLlkqHDrcM=;
 b=H0BzGav34mQhIpj+bAxy7ufT2pclwp5uaIJ92QCgqbhw/mp7Cq8736gZM5F4Rjrd0hNv/2glPGkoufRH8bBQvufB4+oamK7laVphH6xNibsAB3NSy/naCfFLQPhuboFiUzEp5bWdb+Lurv/V5B+ar2yhl/CN9xWpVZFimhkqjrA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 19:10:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:34 +0000
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
Subject: [PATCH v6 04/10] mm/memremap: add ZONE_DEVICE support for compound pages
Date: Wed, 24 Nov 2021 19:09:59 +0000
Message-Id: <20211124191005.20783-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211124191005.20783-1-joao.m.martins@oracle.com>
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0093.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce8aa112-9e71-401b-5976-08d9af7e171e
X-MS-TrafficTypeDiagnostic: BLAPR10MB5234:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5234C2F90367EA79918BD2A5BB619@BLAPR10MB5234.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ENdAy9XkSlT1QNWTD0Cibg1WH6Wn9ob0q7Z0Z5B8KluRDOPqAumgq+xmxnBQ05DyGvcPnbUKLz7i6zZJHi+ODS0hr6eSy5+dyyKOftbzFO+r8YtrDz5HQaCthBGckp53CUtPGSbHWsmCVMm4Ll9LpEYB5D0VZmP12mKM3LY5nKzSoWn/rLVi4VIeZpTjlLLfibAAOoKrg8Geh0GzVO7Lz+BCIlnn7WHQoYrzwkmVyAUikqOVm2Bl/VXHDMZ36eaKXs2sH9is+CfqhxuvqNj/iiTSvUFqVphkT0j59jzdXUlu7nakvxH3N/B7MKS+Ey8QNRr4n/wUmsA7H6I+81Q1bOfe2iJT0F9QoaDSKkvL9ZLiOQZrCrXENvlOac+oWru24wwpLLMULXBA98StH3sgYVjioj2F5kbYPwigra2FDYKO+dw1AXedvbyPJDvTX+anWpuEd63seJ5h3l4p/kKIL7lxSIe+MS9ZjLYtTwPjfIPrOkNz64oMSUz4TpHaPJoSpTkVEhOdqyFZZ8VFKKRniKBjyDXVADpE+aT1rLFdKNZ4c+UNfUtckoFHbUIphaRcnasngqi+jaJBM5pEdnlQMggNWChmSzK5iSD0M7DOw8FBNssM/UoNXvbZjDaPCXeKPhUlONoH/nvqRJTt9lXKwscOJtksdTZcaeaWCq0Y4IFVKYexE/NRVVAFA6Ak/9GMfg1ZN0a0gP4UQxHY6odPBA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(26005)(7696005)(83380400001)(186003)(6916009)(103116003)(316002)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(107886003)(7416002)(54906003)(4326008)(86362001)(2906002)(6486002)(66476007)(8936002)(8676002)(66946007)(2616005)(66556008)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?QnjuwekRjKPL6dgexDUFr4UoA8eGDQOhRQprdD77bGioEnGv0rhdS8WLVUdH?=
 =?us-ascii?Q?ROSkuXsn6Hk0Gn6LV2HK9j8XhmsJ+NFfZz5u+huVYFP8dfCvUzDKyXZw/X0h?=
 =?us-ascii?Q?YJxK0gmsEOkyvr86GaUM3reXH1HaYf5WD0ou9kiG7TGQhalD2ba7i2HjEcuH?=
 =?us-ascii?Q?YDsQo6btb7i8I97icid3/898ekV37wN4D3Vj59j9e997BZKvDLd7b86XYbM6?=
 =?us-ascii?Q?WN21x8a/SX3gzFoKNPJ28Fh8uGU2yewiIZ4SQr/3harDhB6wH1WrZ4NgZ2kZ?=
 =?us-ascii?Q?VK2qPgr/ULUoXI83V2DnoOii5/z6CV9j9QX3vRuaaJcyWY/XaTyAkFdQIMMp?=
 =?us-ascii?Q?CVr8Zh09vxt7DFv2UONyKEPMAtq9xDDap6MSNDylUCq42/yxv728srxjIuJr?=
 =?us-ascii?Q?iElWhfe7tlVlkzyhe5QgmVS68LgfAuZucTJ4E8tBcfkkpm1MeRka0CyUTMFz?=
 =?us-ascii?Q?5ZpqwORh9g9pTnYA1lfoUXGYM89zLQELgHmgwipzgWXoh6BFnx65YAJPiZFC?=
 =?us-ascii?Q?1uQtAd0OFD2VnC/V6RCviz34N7I7ik125Gd0gMkCk9KeZNPOwp7D4w9pYlwl?=
 =?us-ascii?Q?rQjk1/g+7SPO/nO1/U+c+VTABhkn21jIztq4OhrH/pUJES3gF/n4UD6eYi68?=
 =?us-ascii?Q?QF1BxZECS5RIIBz7u2kyXr6aOrEmGqkvrpQtmObSqB9jxluDvXb44MGpLgBg?=
 =?us-ascii?Q?MwWv+PehzqZPvdt2xvDVJnJsOD/EAYZlODWepaWxEqpP3agtiqJRqj1k8dmD?=
 =?us-ascii?Q?EicV8k08FnHcSum2VutLEg5SR0YRMFbcL6eH2w/SlbbrCO05T7oJffOD6pP5?=
 =?us-ascii?Q?ZPAhaRDpnRuXVtX30DxTjYBPGozPQa/Rz0lZmm9snH3PZsT7MHKe8vKiBR54?=
 =?us-ascii?Q?MlbWPjXF3sdar8VSH2QvFWvbL5SAgprElPP8BPD5CKQhEzJgWRc+wIg0Yevo?=
 =?us-ascii?Q?7REqn4RKS6ViWdx5/G7XzpAIQqjZWs4GN79u9tDdF0OU9FP2uLQ1FeWM+O6D?=
 =?us-ascii?Q?NuSHmMBTSwFeStlttJcyeQDUHlPxHf3MOxgPp2wovQDGrLBwmctuFYs25Ph7?=
 =?us-ascii?Q?mnsIPY3KsPqSk6GPuaRp55fA1hfb5xw3Ts6zMGCDJtno91ILE6rGeN8nHS3k?=
 =?us-ascii?Q?lNxmPOwayzqAG43BM+QIg2uCDH3aM0VBK+m+Hg1tfSTqIAEZ6Dsc7P+1iivO?=
 =?us-ascii?Q?M2XQXVxgPtLZsoxfJphxRHfdlM5kNJOpXRhy8GITR4rRCwwvC2nJ+Go44zCu?=
 =?us-ascii?Q?doBV4TMnd6fEzXDu+BLq7+0NbZJbGXa1sMDdJ/JuOkKhlXkT9Ubuq1lx1+NW?=
 =?us-ascii?Q?8MljuVETgZHHT2NezsTOW4s8IARHCRCaqWVY01XMMZ444knNKOES/W5Qqwf8?=
 =?us-ascii?Q?pw+EHaFiEq8bAgDnvyiy6QMLxmarvzzPBJGdYd7q0MpLiV/yOI4XMn7CLb/+?=
 =?us-ascii?Q?W6aZ2/jMo6Rc56vD1/OXsPHo60K0W75xmhcbSIaUOCHhMaFwdkKF6IOYHNUn?=
 =?us-ascii?Q?HVXJf85ugEm864XWY6J8BoD5LdhXttOd9mWzM932GQmmfMzTRJYtTvj3PKJO?=
 =?us-ascii?Q?YUBdPVDdigNN1Qmg8Yzuz1cUo4PHSTxw/KJCIWdUMBkNhVy5hkYeQpriAQOt?=
 =?us-ascii?Q?F9hHbCkF8A0y8byi17Wu7egRhACDfwFmOt0oBclwbMMl0b3WqoWr91Qb3eQP?=
 =?us-ascii?Q?xgeirA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8aa112-9e71-401b-5976-08d9af7e171e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:34.0799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqwTcVaqrQ2Ve3/R+0LGpnXU/IH/V3K9b1yDwBN3H8OovPzLxKLIef4ixMqucX1kqFXk7lwYIV5XgoFnLPQOo766de+1igYSAxkvGOggsCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-GUID: Y5OQM9nowO6W1z7h3QoH-8Fhehkn-Wah
X-Proofpoint-ORIG-GUID: Y5OQM9nowO6W1z7h3QoH-8Fhehkn-Wah

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
index f7f33c83222f..ea537839816e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6605,6 +6605,35 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
@@ -6613,6 +6642,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
@@ -6630,10 +6660,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
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

