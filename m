Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67AF428C
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 21:33:49 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KEiiU017342;
	Thu, 3 Mar 2022 21:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4qmeluZwSkDehjJnpYTtA0DrESnXG3lMUA5AYBBy6FA=;
 b=LZ+pVjmW0wXiK5KPoVsIYRl/2XV4gJz/U329jTjKebZQ9SrVfkTMFsRbfmL00hNKqibE
 /9Dt6YGM++hA8DACb8FBBF/K5x57yZKPLQcF9ZUrWCIm/Nc5P46BXhA7L5xQdMDX5FIK
 bNylVO4V4AYQbvZHSuDjsx6bMEK7/jrTAQDumWM63p+9lQS5XlT/ZIIR9Up3SoLnc62B
 HZ625p3IYeTeAtpctlGLD0mV9Tc0A8kVF2Bl4nR0yb2U6Z2ny05Pqvpt2k/Vl+esEGhp
 ZqxzyrrYFQuErNP8PJ+JrqGd9LSkGXDcbPiNWhxXWfukSOQVXXXBo6pJGi6qnp7MSlbW xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hvg5hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223LKuep132178;
	Thu, 3 Mar 2022 21:33:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
	by aserp3020.oracle.com with ESMTP id 3ek4j7tq7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnExle2XpmyZTbsJpUm3+LtlZq6cnDdq2MlW2nNT7l9WYJ+cLo1BvUYasFw5fHE5Vkm3yBAQYiu4HUop1JmBfTXbVPUzU6lsUG4z0Dji16fUwAdsB3eyPu1R0ES/vieiI6bl2zBOm1rhAJMxG6iB8oAWGhfF8ne930pecMPtKi9TbWHAmhOHUNG8AIFP0768FxS68haAd00+1roVQqZHylHTNKvF3IC9/t5pu4SU0OrTMTGU1GlcHkOZIOY+cEx30k+MgRZ2YiqiIpmMCA8knTt70uMs8Ft7kGeSQwRkeOuQG+/OdZ7A1fBlalvfBAcatT7DNIkP9z5TDzUr1PR4WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qmeluZwSkDehjJnpYTtA0DrESnXG3lMUA5AYBBy6FA=;
 b=mLuJOOAgKimNpVkgfxJmIU9Oo8tr/GJnMuhays/3+RO5VzlMn3zG4hJxO5aUdethW1iBtq8lXarI1QjbJEpfrBZHBddM9jXzLo/Q9IRlAt4GVjdHxDXrYkvSqT869sbI9wSgaSi22cU2Ymm8YOdkcWPa4h7uG/Rg7f8BhjPmhgeJyXk7pFe2YwQI6Li6UYO8eV71IIOlUWUi8EV9I8cU6lB/3nomAyJPIRJRk+ShDYT4D0SS0fzZM5XdLIl7RYcA94Q9elve1+7TbxGG6tjr+kL9hDmsLJtmiqNGzs3RHOf0H8CCR7os2jaKF+a1cgjF5lzJYrrR1hlyKCeV5bBqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qmeluZwSkDehjJnpYTtA0DrESnXG3lMUA5AYBBy6FA=;
 b=Vv+z2UAT/wFLk7TWoSoWkW6KOJGGaJ/MHlsTzMGrXeAREgW8scPD82ecvjWeLJS9dyTYWqHtJ048NeE95nbYqzNoNdzZZG90XFjrr2YzsAiFzWJo7leZwf7KEcq5XCqX6XyIGyq/iUIuixghZCxfUGBZIjBEu7WCPAE/j9TtzMo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1696.namprd10.prod.outlook.com (2603:10b6:301:8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 21:33:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 21:33:39 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v7 5/5] mm/page_alloc: reuse tail struct pages for compound devmaps
Date: Thu,  3 Mar 2022 21:32:52 +0000
Message-Id: <20220303213252.28593-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220303213252.28593-1-joao.m.martins@oracle.com>
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0036.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 716135ad-5d3d-44ef-bbdc-08d9fd5d7b4e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1696:EE_
X-Microsoft-Antispam-PRVS: 
	<MWHPR10MB1696892892D1A9329E96B405BB049@MWHPR10MB1696.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	OuMvGk7XeCOaihqPuX/7e3fYDFHXQWJMUkBP+shmFq2te5QhdeymyhvJnFrf8EcHo/Vf7z2AJUabEo5OYxGn4J+LYyXkk7LJZQIZjMbSSXMehx7ELF4bnUDr+G4fYVnChw9+4SkXVzwodL0dVjyDBjsJudf62ATJTiVsEqcKE3ylU2vnv237kBzIWFMejUV7TXwt8c0ze1xyK9GeGNboQYY+oc3A/LouiRPNictZPOeiJa6V1hs7vJ06EuIiTDIZi+QAu3W3Up3LGzkpXZemJ5Vcpxv4ByIkNIBQlmgW7uJVdFwON8fD2FW0wAT37HHwpBs4kf+PviqbGnXHYkFiHNgqpSTF3TO+LKTcO2txUuuhP7WL205qYar663GWYDnIrj0UQTrEBXDa/RoZbvNvkDsHjIOnBewmpyeccdW7JjUwsrJVbR5pLQ2oR/jlYtfwEVNr9jj5pvpeoTxwgxDsfEXQXyTIr5uHOlSOrV1gKPXI/5hXtBI4Up66wJnuwCfsXCcCk1wfdcisnibgMDOjXHNlzCljdt88uXDiHHjH+GKH5n4A9aPMgnfp4GvTdEYEh0fVnm9M81+GdVaIP94HqXAfoRHNEw8oAxHzguPnvTHR8JSKWAJEVv9TPgQgnGtZf1gzxdPAugnBSmgwrEzHtK0pdJkG/ksynQxX9tAGfC3wnO6BD02kc/dtzqmfdUqp1FyTQEeBe/xi2O1/soQ3hQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(2906002)(7416002)(1076003)(38350700002)(52116002)(107886003)(6506007)(54906003)(6916009)(6512007)(103116003)(26005)(8936002)(186003)(83380400001)(2616005)(36756003)(6666004)(316002)(508600001)(6486002)(4326008)(86362001)(8676002)(66476007)(66556008)(38100700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BdfR1y4GRUtN5jFklHBsdHYdLY/0j++MffOB/OLRHXwF5QEg6uie2JqygF9A?=
 =?us-ascii?Q?rzUGlU4r/2XZTy4wK4ylq1tbGspDqrpT7xNrZv6S6uj4stOgKEag2ueDZJoP?=
 =?us-ascii?Q?JvUFCBZp1bTzjL2fuLtYR6U74gGOu5xHETEk/oMx3dtsm5iw8l9zXBnVgXl5?=
 =?us-ascii?Q?Z1e+CTj+FqbN4ts6kHDD1W8Jf16+OhPCjtQsJ6ItKyGDL17tx18ZhjG6ECi/?=
 =?us-ascii?Q?GJt3mWhgyVXZJPPuQEkps6a8s8AQhVy4C7C7eKHqeb4FJDh3IIbOz6dWojVI?=
 =?us-ascii?Q?4cTo/BDj8H53ssasUlaOvguwh4SaTDpbKppHOqFUIfT/BviQaPbb3/RYXHep?=
 =?us-ascii?Q?wR1mFzaNDGULz5Pm8pY8ZQtUKFnU7B78orHmoKb0Wj6Dn4UjIrZZxSRLqIB4?=
 =?us-ascii?Q?p6gK33gN2BIkSd+BCojqlg9ElqUNQPVGgTBocSCTZgzzAbZzfEUZnwXXuw+O?=
 =?us-ascii?Q?XMUxcu6juigcuNzvmXFOPbsVLs3YSxAozGCK4AMEzfr5xg/LIazYEf4+VLj2?=
 =?us-ascii?Q?oRRKaVsarLPdvD5/bh+Q/gg6PLcEik50Hrg1UOhdYdFQPlOFsV3OKloa9iln?=
 =?us-ascii?Q?7AtkkN4+BRaNleAyXfinfrWkYHPH+yp1WRWMbCj3XWkpLIbDDXOTJ4qtAHyd?=
 =?us-ascii?Q?LEHfDL/8ELxxzPIix8u9WVBEoguBArI2koDB5NsCAUxxSd8cA8kIkJmOU6C4?=
 =?us-ascii?Q?jDKTjWv9HLiB0jeAbJxC+TsOtoza3Ya3o3yXtK2gBFVWtvD79gOKNBRo6eZV?=
 =?us-ascii?Q?9HaV/1Hz+zjecXMAmjiJGnFAF/YUYUze2orufS7i2jqQ+V+OAp1KZ8vdMWDu?=
 =?us-ascii?Q?TSMxoTt1POJSokjlF/UJ9dzxw1OLwN18+YEp3hO4qxAVJXZ9J1x+djlJnlgi?=
 =?us-ascii?Q?+LY2QGenXGsSIoVkrb2Qnscw9kTQC2fNCakiuT3RjGs7hg5a9xEnkpdwezOQ?=
 =?us-ascii?Q?MTL+ZmGF6CAzU6rCu5kTV2SqicN5jVIHlIfKdy1omvwNb/hBRUHyzA4TYPQK?=
 =?us-ascii?Q?7VGCOiTHFb0cX50lC5t24zreXaNsQxlYzMgRwrTzfFYLW+k43xZzL4zPLMR3?=
 =?us-ascii?Q?u0y55egPZzDKqXm2TqJKT1HS6Tz/+SMGlyGmEAR1Wew7n9N5pMxjRY2eDpdf?=
 =?us-ascii?Q?4MI7FjJfGJFk+D6P5WW9/jmKAypLZa5Lo/jgAPx/xLG1IHfxhV3Ju+utBujX?=
 =?us-ascii?Q?XONZioT/xB/Cmcrzt0I0Ju3n+gjYjzZ3dYveuEpcZLPbMKUCGY6TVGXX1wEx?=
 =?us-ascii?Q?gvc+BXr9xRdbWES5Btm22/ni0wKs0k1aqSMnBMxrZJ3V4ZZZ0aqDh3NcOb03?=
 =?us-ascii?Q?bdeew+aPnCpP/roSQ5YhgG/UhhZRQfXq6wHrTS8mWs6F10qER9N2Bgg12uf0?=
 =?us-ascii?Q?OyTKbB0C4ep4D0arubLuuqCkjnmG0GYzH+mZWPS2MVGmVp1k2rXmTZECp62I?=
 =?us-ascii?Q?GDrwS3ZOXpcTVbswkCRSn0xcS5tdJ9d3h73kvC3ntFEaamhFmEF3lTXtgocU?=
 =?us-ascii?Q?sDuFu6XmnOpRGIlkRY3Cvy7Bfo7g/LT73/SNGI/BSk2dxq9GG6jXxwPvVmYI?=
 =?us-ascii?Q?3+aj2EGy3my7zz+zhzd3R8zOeNfoERHXpiRbaBbxmuCguQYfTzCTI+AGK529?=
 =?us-ascii?Q?tF5H7KLfzJUHbhKfc0m4eumqt+DZAWUq+9qb1bhQYpSNMZpgPD4EU9r7btrb?=
 =?us-ascii?Q?YiQHfg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716135ad-5d3d-44ef-bbdc-08d9fd5d7b4e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 21:33:39.5147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAkBiI9LOomegX6KqRWxv1j/u+zpTtm0KST4d1nZ1ZcqdlSDq+L26DccoV2kY8h9P/S95eWj4IUhWgwKZDYtTup4gM4Hn1ByOeVKdxrXKGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1696
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203030097
X-Proofpoint-ORIG-GUID: flRcCNK2K6vIWmpLKDy5XHp-ymcwbWBH
X-Proofpoint-GUID: flRcCNK2K6vIWmpLKDy5XHp-ymcwbWBH

Currently memmap_init_zone_device() ends up initializing 32768 pages
when it only needs to initialize 128 given tail page reuse. That
number is worse with 1GB compound pages, 262144 instead of 128. Update
memmap_init_zone_device() to skip redundant initialization, detailed
below.

When a pgmap @vmemmap_shift is set, all pages are mapped at a given
huge page alignment and use compound pages to describe them as opposed
to a struct per 4K.

With @vmemmap_shift > 0 and when struct pages are stored in ram
(!altmap) most tail pages are reused. Consequently, the amount of
unique struct pages is a lot smaller than the total amount of struct
pages being mapped.

The altmap path is left alone since it does not support memory savings
based on compound pages devmap.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e0c1e6bb09dd..e9282d043cca 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6653,6 +6653,21 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+/*
+ * With compound page geometry and when struct pages are stored in ram most
+ * tail pages are reused. Consequently, the amount of unique struct pages to
+ * initialize is a lot smaller that the total amount of struct pages being
+ * mapped. This is a paired / mild layering violation with explicit knowledge
+ * of how the sparse_vmemmap internals handle compound pages in the lack
+ * of an altmap. See vmemmap_populate_compound_pages().
+ */
+static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+					      unsigned long nr_pages)
+{
+	return is_power_of_2(sizeof(struct page)) &&
+		!altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
+}
+
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -6717,7 +6732,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

