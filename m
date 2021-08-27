Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D903FD0
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:23 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RDWLfq010418;
	Fri, 27 Aug 2021 14:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gsbLElqDH1Mq88nZFfRxU9ecTofm1cuNy6qL+/DvlDo=;
 b=d81ENQTgXJMbcBdP1KcP+6apovx5FheFcureFUdVRlLS1qcBjUFeDFDQY6d4UI0hMDUl
 0bJ5Io5WnMEAw0eRJ/zEw8+Gt3zILfCB0iBY0mqv2IR8SPQ7HewaRxW9jYDoNx01kwqu
 yYlU3iM9PvoGlZKEkmdlB5A1P5Wv0ZwojppnDWkqpq2PqnHwP4KUuBTA62mICzcNadRj
 MKaNybxY+Q3GiZABSPFJIScdRdofalhB4tc37vLLUOeXSAtqafqG01Ivx9wF8KKLFoeA
 N4jCVx4+hlif5PP4oDhlLpUSlMzLKTJEiNBHO2TyaeFJcrswwP3WNOmEqcameUrNk3CD WQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gsbLElqDH1Mq88nZFfRxU9ecTofm1cuNy6qL+/DvlDo=;
 b=E8Qwbsd388014N3Td824hMaRGy14ZkXAuy+g4/rq+rkCqT0TVxH+lrIl2bsridyC1Jcc
 eOMGPlE7RY31/kGYv93WX6IJld0nfxH9T1jQRceUDVAiQW2MiqBDh5lTVLdrNM6iSfQz
 KjAc5lxhpE4GzxlBXG9V/hCM/xU+tO+SH0+LyCuUPonM8kDxDnyTrPd+ZsxZAmxuvDXx
 mj3EjBryp3t+GYRKApIoVNUVJAQPZaewC8SMh8ha7MtxlBPv6NNPDKMsF73tNh7FcrxV
 SFaMQbAGHURZrdlAVtrGyxwr/wQlq0/FByWjwvN0C6nx0isz48wEjw8FtV8TSOhr1Qi4 Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap3eauykt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpaoN152736;
	Fri, 27 Aug 2021 14:58:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by aserp3030.oracle.com with ESMTP id 3ajqhmq1bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxqR57BPnY9W20Utfgm+Uhp4uuiEqO+1nKjWULMBnhQVGf9XrKehfDSCM/X1YjX4X+SN2kv8eX75TOj1i71qFfEph1gNSm3G9c6k4uuW5eHb8F3MKCS7yM78WwD7RSXiNni8NFuJn8zf58WNtr1gB6oC7HwtC4V5GijljNeM77taKJvykKBXFt2c4le5ku+zw0a7DcHA9VLQ0gWJf1QpaXdLOvnu/i9EzLqdUp5gRRPmm/Is4tfipnIwg4hUdLy++ZZgKP3zrDRRGtz7cqxVL9mEvYYjFq+5uarEniVG8IC4SAFCV10uudYQp7ifwh8OPv4uwPGhCsnSs7tejkkVXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsbLElqDH1Mq88nZFfRxU9ecTofm1cuNy6qL+/DvlDo=;
 b=inVfC5dmYkcV0vFg2i/oSyk5+xBLh+8S8jcakkhjlNkDSZ+oMAMYcGdxwVhL+vWv1c6a1QLgO4E9mwHc49J88I6AK8VpSxbUJJ1zrneSUITHrfl9yS2FN2/C2VzTc0EJuf3BwFcEtCVbG+tRD3qU5zTKs8+Py4nHfB/3jjhQaNE3J2veERbnjuYAiwRPkD0/nvPBlWUQkERV2TQBchgeVEQE+McyUJmwOqDKnoCM7SFCtpuQr8SBZNgrdKnpRzD3XSBc72S1riHfYIySw+dF6+Z2eeu1EdGWMJY77+lbeuo8M4Sg3eFAd9Ld+mpAwXlVNJJp74DVoPReP08mf4sKwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsbLElqDH1Mq88nZFfRxU9ecTofm1cuNy6qL+/DvlDo=;
 b=e1SRY0AcPxeZ5yz1jvUAhxzQlxt7wXVMI9YN+CP3F3vLbABuU33ejeEW1ks/DuDwaedPqOg68oRewVkTT5Y68/YlR6aUQDpsrASTi4SO8h/0qjmOq3ejA0f/W7LPo2P5t+rxHKVUEMona3PZc3IuUepfi48ai2URCHZEcrLrj9k=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 14:58:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:58:50 +0000
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
Subject: [PATCH v4 04/14] mm/memremap: add ZONE_DEVICE support for compound pages
Date: Fri, 27 Aug 2021 15:58:09 +0100
Message-Id: <20210827145819.16471-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210827145819.16471-1-joao.m.martins@oracle.com>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a344fdc-cf6f-4d15-8741-08d9696b2e0a
X-MS-TrafficTypeDiagnostic: BLAPR10MB5025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5025DED90905E75618BDFF55BBC89@BLAPR10MB5025.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	BO1NxLPrI6wbk+5lu8F8ZN3CtnAw1nykh3A+R1PxmbHtIBVU13fgxFuDkosJ8CKSzh6LSW9aoi+k29p9v3g07+y5KeawFdna1X8UemWzoQRWa0Vq/cSHObuYT5hPopjNmBbNjt5qfwxcDzStormgdCgTKsZAWlODR03kLoxnGV6DxjsiX7hRAeON+IeRVoE3Af2/GJAVrZKQ3pMe3u4zfr5Wk6nfS6J/4wbCVSm95kAx7JwrGsbPYZRYPV94VaNLA9Iogj4ZaFV5G4sJDQZMKEqJ+1YlbwVQZl/UeuslqcUhXv3N9aKg8D9LiSf85LQVHZWY5OkiIfnhH6UfhsWWlbiu3pBvEBRABT5zjczbBlvTpTbGUOnXxK0TULrxqnDmiQGJ3+L44t1jKPhupicAfJNV1zmLTDiai/KUb6HW5SDFqDH7rxHhYStP5DNB78iiq3N6KAe5N9lnMliCAEcKSIt7yE8b4AobY+whTADg3+KT62IVTIuN39pbdgesLV8RpsxSt9goFtaxzSay4zVeuh1kAefIZhggICG/HEXsyOisqTEU8HWMNPo0a/T5wWNBQhkTX+Er7Lcjp9qlop9yQcOXs5ylb528EozBSYz7mgzJQ40C2bbutKINkxOoppBW0sJjl+GFp2ZwdnHlMYEP+nJP/ma4pgT0gtdZzMo72XW+GRcPBgHDdLnouP3KkQAFGU9zLv7A3DU2WNbJebJWjg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(103116003)(66946007)(83380400001)(66476007)(86362001)(54906003)(6916009)(6666004)(6486002)(2906002)(1076003)(107886003)(8676002)(186003)(4326008)(38350700002)(5660300002)(956004)(26005)(66556008)(52116002)(7696005)(8936002)(36756003)(2616005)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?r7aGzBJSB6fqOKRoUxdQTVDEJG2XK1HJXpU8PN6HkGaxzRQo2vAMdh0Wz7C4?=
 =?us-ascii?Q?0QoSr/zas23U4Ca2mdqbv4DfWdVMAQGchZ2WkZ9cujriKyLpM/wY/bgTxcs2?=
 =?us-ascii?Q?zAIK+KFu3vPZXY78RXiHkPf7enufDUvfLa56FGrcaN5CFyorHrqffkmnhoUr?=
 =?us-ascii?Q?iUgxqdTbho5lK++055GCStQzcYaeTG3gCjkPVXHYUw9TcLiRfBVdpL79MCvd?=
 =?us-ascii?Q?jcBs2+TBvvwLqDG7+NClwWgNmFMl/Hwv4z73PRVAT3CpoRMT2xXdu0CYIbI1?=
 =?us-ascii?Q?yJE0zYC1kBnxT3c1Q5Cjd7PUXCCUl07KOFDy/ReZIg51t6pc0K6FN/aaoCvH?=
 =?us-ascii?Q?oJtbJlYWfv5MN5ql3I+dPyDs5SKS5ZGErxT8+lStlRe1VXAppUcl3UTYud7f?=
 =?us-ascii?Q?qIN9W/f/+Qpo+zun3hyQdDTlLvFyIWjLP+l4ibzojox4WyKXEupI1ZsWmri2?=
 =?us-ascii?Q?YGWSMCAx2O320Mk7+LTbJ8HTBcrsDg1FejlT/DFFX/JhT3j1AxQLujN5i6Eo?=
 =?us-ascii?Q?U8aElQmRKnqjlL8TnOaMaZlAdome7b/SZPxPfsHlXtUl+21YGIYMnxnQRulj?=
 =?us-ascii?Q?dQCmJkjasl/194LPtqcpdPxDfVrwLt5c6pERU1kL65AcHaiMmr7M7ywBvoPr?=
 =?us-ascii?Q?uia1vZ8x+olGOI2PGr641udc4/OUf54Nmp6bz27dNdQ2HDQqRzKB6712SY8O?=
 =?us-ascii?Q?bWvKYnROkpGxgm42vCE+AQcqATTTiC1tPTYE6tYzNM7BoG++UblHU/3aNGHZ?=
 =?us-ascii?Q?o8oKrCtEV842OsvZQQMzJVxrX8ObtXrFT8Vj+B+2d4xcP9DcDc8Z50mgk4Vw?=
 =?us-ascii?Q?qkJW5FVwI1PCeYELXalg3kuOxQV+/ufqzUOyjV1T+Bbz/ZZ7JC8oiGW1MKFm?=
 =?us-ascii?Q?PFZcHzmQo+RBUYnGMEtJyyNLGZMeJ2AFrLCpyNYz/UlEKLG9A2AgZS3FPUlb?=
 =?us-ascii?Q?BkFGiA2BxlfIiWnqswTtMtg7VpUbD8HcORKzf94ONoZEL04ysiM5sQahSRAc?=
 =?us-ascii?Q?ALZ6s+h5ijd6MjIuv1vqvRvHIZ9t5U7RUttU3/e8hQt8OVTsr7fHoGL+vX/K?=
 =?us-ascii?Q?F8eTjeIYbowTSe+DnmxmqgxmxcrYpqN6nAFCA88aLZvIBtyWTmN0kDiAdXDF?=
 =?us-ascii?Q?+X2CEbHmwQ5arTAHUXLtClpobUOTYCvae84FOa9RYrisoQln0Phvx5bLVYUw?=
 =?us-ascii?Q?YGXlwNVvKsZZJZO0JYlwA5R95xw0hlBhmAAiBk3y1hrVy59S353G+0NGdWDp?=
 =?us-ascii?Q?QDVAPgw0H+tMUaVxSa593XLoYqskTAVP+dAuB0fbCz69R3+nHWvSv1tmX1yG?=
 =?us-ascii?Q?soCbYu3A2kM5vnvAUF9Ow3H8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a344fdc-cf6f-4d15-8741-08d9696b2e0a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:58:50.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PCf+jcxrmw6WvyngflYSyKv1eN0RZEOcYIcjoiTbShYOMpY+DFBOPtGS3Yw9bXsX1Q5k2VKvXotVnxV2dJ0gdUJAGXNWKgHcG7Yi6dXGPlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-ORIG-GUID: bysrfJRBWvgo6bNC7pJn1f-wY10uHaRm
X-Proofpoint-GUID: bysrfJRBWvgo6bNC7pJn1f-wY10uHaRm

Add a new @geometry property for struct dev_pagemap which specifies that a
devmap is composed of a set of compound pages of size @geometry, instead of
base pages. When a compound page geometry is requested, all but the first
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
 include/linux/memremap.h | 17 +++++++++++++++++
 mm/memremap.c            | 12 ++++++------
 mm/page_alloc.c          | 37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 119f130ef8f1..4b78d30c3987 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -99,6 +99,10 @@ struct dev_pagemap_ops {
  * @done: completion for @internal_ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
+ * @geometry: structural definition of how the vmemmap metadata is populated.
+ *	A zero or 1 defaults to using base pages as the memmap metadata
+ *	representation. A bigger value will set up compound struct pages
+ *	representative of the requested geometry size.
  * @ops: method table
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
@@ -114,6 +118,7 @@ struct dev_pagemap {
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
+	unsigned long geometry;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
 	int nr_range;
@@ -130,6 +135,18 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 	return NULL;
 }
 
+static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
+{
+	if (pgmap && pgmap->geometry)
+		return pgmap->geometry;
+	return 1;
+}
+
+static inline unsigned long pgmap_geometry_order(struct dev_pagemap *pgmap)
+{
+	return order_base_2(pgmap_geometry(pgmap));
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 bool pfn_zone_device_reserved(unsigned long pfn);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
diff --git a/mm/memremap.c b/mm/memremap.c
index 84de22c14567..99646082436f 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -102,11 +102,11 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
 	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
 
-static unsigned long pfn_next(unsigned long pfn)
+static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
 {
-	if (pfn % 1024 == 0)
+	if (pfn % (1024 << pgmap_geometry_order(pgmap)))
 		cond_resched();
-	return pfn + 1;
+	return pfn + pgmap_geometry(pgmap);
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
+			- pfn_first(pgmap, range_id)) / pgmap_geometry(pgmap));
 	return 0;
 
 err_add_memory:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 57ef05800c06..c1497a928005 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6610,6 +6610,34 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+static void __ref memmap_init_compound(struct page *head, unsigned long head_pfn,
+				       unsigned long zone_idx, int nid,
+				       struct dev_pagemap *pgmap,
+				       unsigned long nr_pages)
+{
+	unsigned long pfn, end_pfn = head_pfn + nr_pages;
+	unsigned int order = pgmap_geometry_order(pgmap);
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
@@ -6618,6 +6646,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned int pfns_per_compound = pgmap_geometry(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
@@ -6635,10 +6664,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
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
2.17.1

