Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AD76AA3
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:49:03 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NIEGJE003931;
	Wed, 23 Feb 2022 19:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mzhwY8ndxDV0XfEO1yZypVLBhOO8tBTEd6Wd8FN3Lqs=;
 b=flIysGKNhy3Gwh6vzYZRZ/Q8v6Derw1RDgByGfZ8ibfJFhLFPFbbzZBvTEks/u7oF7Ev
 KWb2FRlWJoDU95+VMf/SG7lCcylSaI5l/Lu97IPYFS0xhVRNuo7tgPFcPlvEqmCIrQzL
 JqRJGNk4L5ZkS3e5q9AngWbv/nlJ1Jm1Ka5F83//Dg5edsi95wD95F8//nXBegV0h4TF
 T3rvnCjDBnDo6dUrjOvmXJhSWV5i7Dv3odQw/Z1I8dqgJQq2u3XiOqSAGXYw+71IS0Nv
 0qHDbD3x3lCNcbSoxC8Ol8zhGorLEDUSTzP8OFttoxIRmHhdNfE18+LQ6ijIG0kz6XEW Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ect7anbpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21NJfcRb055196;
	Wed, 23 Feb 2022 19:48:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
	by userp3030.oracle.com with ESMTP id 3eannwbuvm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oETWn6CP5E/l6w2pClHN4mrJ2Zq9CfhMh2tJ7eP4v12JlPGOqMsukQ7zoSENgKP5EWHbEXAFqrBtwQUU/wg8OX7l0Xq7GTNXV+QzSAUe2t/9fH2kzO8nLvjFJzyxvrl0vGsIDZpOqJHH5Gcck8tUlL3o0mR9ibjyz0cQcxeb9mxWcrgsvuTgelbZ2euc8XRBWs5jiyV3AaycQd6yPSJXuCNlIXX3DH1H2EMQ2s/hEs1tvr9KcsOdC7+wxndnh00y00eUpgeGJjvNSL4KCLHR/IvyAlrPpq8U7hM8YtcXboD8o32OUPfb6+CHpG2ycPxUUGFmV9+HJV2BECKVFp1RQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzhwY8ndxDV0XfEO1yZypVLBhOO8tBTEd6Wd8FN3Lqs=;
 b=SmgyZZBXMe9jBdH2cL/9QUwCT59w9dmOrBhHkNbr58A8yEaozKBw8PNb7vAiNw0Atpy+Jeqtmgz5Rieq2XYt5+CvbH5K7qgXahsuN8Y0cSFRLboi7JeaoRE2Pt//osQAYKBrJlLu4w0zAtQiT9vR94aacF2Gpm7nLAWnI0i4Db5UxUvpNEj+7wicQQIe3erJhI9bF39IJA9zuj0pQc2Clf/gXMuEfJEHhOoCj274GmFW6Ev5B30kv0W+otaUnRZ63WbRrbH6IHkEk3wx6BKE34q7sqar0txYLgu+qiWaIYO+y7dqKjLa1BibPcxQiB4yLRI4bRasbWv3JgJ54ujUsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzhwY8ndxDV0XfEO1yZypVLBhOO8tBTEd6Wd8FN3Lqs=;
 b=XMKREw7pe888rHQDXmf1muLFDoUHsNLTtXHpRR9wSUMJCTNNOk+An3qwfShRvB0jfC4BrhM+uDmyJtKHWfktgAe+0aUxdNBr1Vtax/LdX77pqLs33c5r6nzTN6mnrqi05kaTITkfrNWnm9lwSYSxgriqgKXL5nq246H9smxgNdU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4930.namprd10.prod.outlook.com (2603:10b6:208:323::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 19:48:44 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 19:48:44 +0000
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
Subject: [PATCH v6 5/5] mm/page_alloc: reuse tail struct pages for compound devmaps
Date: Wed, 23 Feb 2022 19:48:07 +0000
Message-Id: <20220223194807.12070-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220223194807.12070-1-joao.m.martins@oracle.com>
References: <20220223194807.12070-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0392.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7196245-ea61-4a20-578b-08d9f7057fec
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:EE_
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB493056E4F62F27C16A54613CBB3C9@BLAPR10MB4930.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8ApdFQI+hgsKXp0ZQ3b///7qjoT6ZL8+dJ+bqJQuIfAO91EJ5xEvcVURDhLW73Ufg+TcAL8kUATWvH/Oav69LHQ3hC8InvUOD4UB/fdeGJ+rc0b45wpCqc9kGhnsWFk4EaKxphDmzUnDGTMfSqfxE5AZ4Qo/q9BOu0FCAxNa9F7/BM1U8BiSWpD0JEEspFb5AEccusZmp6ODqz0eASmoMYbROp7Hkhnf4X4dwtppoeUa5Al1ZMI2/gYvkx1MH1m0nC8+5oldpNtaPjS5pQOGIhWLrL2jMoNzyT9fouw8Dj4Mle/vabshhNLac5F0ofZHNXy71ADLbhY7nA8Q7b7cVgjrcR1P/DWoAnh2B55fh8fb/lcD1jVsVLs8a4IgGzFn3iQZH9p053axVsuFs9s7M3rwRt66bQVCpO3nCR0VMDf2BZEfSfgJgunoXi1RaHbSk43F0qnsmv7otHWD2JV19txUOvKuw5LcbKZ9pxRkadatPdAX18OnKiX1Iz2ZmTB9JSootCnZqXS16gigmJTX/D6n8u5OjUGo01ydMd3ulGbub7qdi+0v4RFHNdKkvKfVLzKsVycFROQjPkGa4cy5kdYs6YA5fbx0yrYR9bHIsluQ6xenZhCFk0K2vOkEVU0wHLxuRscpzCrUmxb8jtf0Kv7NJ5BOiH9MOR1Oeq3texGGPMz5ZBchaagbkNOKSNezn068yhpdXA3UsnAJwSftnQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(103116003)(6916009)(36756003)(86362001)(6486002)(316002)(508600001)(54906003)(8676002)(2616005)(52116002)(107886003)(66946007)(66556008)(26005)(186003)(66476007)(1076003)(4326008)(8936002)(38100700002)(38350700002)(2906002)(5660300002)(6506007)(6512007)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?xlyOL+RWXUYmSHmLtEGcKWyKMO8JTs351Yjy9tui9Mm6aLh7FLxcEhfhwfrI?=
 =?us-ascii?Q?OfeOUkL9P3S8TIezKwwFulU+Gy9cn+oYBgKdIZ4iXS8PglcXRDuJwZy9eUAH?=
 =?us-ascii?Q?khQ/JGrLC/zjVMoLUklabVe5J7yRwziwjtnE22oXPB52NnB7lotAoedEgbjH?=
 =?us-ascii?Q?3NN7oAfKAZm1cJiLXcLnLZH0Mk8uP3GZRpG2pS177odxOIq6Vt9NijMnniwb?=
 =?us-ascii?Q?ypTMEyMgetTtnpuJi8MEuAnMDOV26CDZIYcry+vTgD4YwOEDp8KspDVRf0wZ?=
 =?us-ascii?Q?Vah7VFqHI+V/aPg1Nbz0Tl3pnWzwYyB72pYGBkzoML8/ITOXfncwKZ0Bmv7D?=
 =?us-ascii?Q?nTjbP6LB4Q1UmZwXTheWFGK38xIXHiAI0aWtV+lqy1nrqICOK2YOMoEcFYaM?=
 =?us-ascii?Q?bIhLlEm2iNF9ZN9srRe7YI+zV5ihp8y3wANz4MhXJ4oeenUpNa97LuUSYVFw?=
 =?us-ascii?Q?OxPSZ4olydvcA6geEosiQc2DeNxD1Kf8rOrL/CpdveoYbij2zW3g+upteG/z?=
 =?us-ascii?Q?nC5nk9pFCZ0HaZM0iSyNSSHU9hsAENZS8sDK9TGMIwRcgP1rH1c8ja9NZykQ?=
 =?us-ascii?Q?7ZOU2z9Cj34f50BhVqNRflk9QJGFtxln3qH/aF4b6IJwe1GD3v1pvJFt83sk?=
 =?us-ascii?Q?ITfC5aE/4khd0JiNIE9rtza01GriBPLodOK2eB5m3QcVR5UaHeA0+7OPkhHO?=
 =?us-ascii?Q?mfZT0fRAuEPQCES6SJkmYaDnbR+N99TiXVI+nzmg02lGSa3RDto1hlU+RPES?=
 =?us-ascii?Q?6iZOVAftrJf6gn9M2i83KYbLpOTo95KTNGk8HgmbpZ6Ii8b7adJNZ+KE/y3d?=
 =?us-ascii?Q?+ej7p9ATVDktKylnzp9EB5w0EZjjxXMy7HsbJFm6vfuh7LmlmhbQhAmuGX97?=
 =?us-ascii?Q?+y7KsAIEo4kChOMm9qb+OWwVeHsxWSQmpwuCZfC2fHL6vRlSCvu8qtJMRG4W?=
 =?us-ascii?Q?HLE7uPWwPt3m8Bphp1ddNoC5Y1f98xzvHb+3MTvI/AGmIiqbsD8oMXE/STH4?=
 =?us-ascii?Q?wEJLxvpdmxkcg/9SMv+otE0i+jHh3Og986QFOrJRCS3iRceOXVqa1A7z8Vpb?=
 =?us-ascii?Q?uD2swyX4ipcklJsne0vLdoZexCffosM4kk+EgHDr7tDDH3n1a6kxFXfoZN/+?=
 =?us-ascii?Q?EUMQkVMD4pu3gwq/Y//CErHwHMv2cA2djumsU0CPz9MHsDJtFU9kMnCO/KkX?=
 =?us-ascii?Q?fN6+4V9R8pJu9F13iV1tl2puuVKjNgA7mP5wMDERPRkm+rc+2zrjC6ZSSnp1?=
 =?us-ascii?Q?C1WOcFqF085XpE9Vh9eSAuEqt5WvWCCLtCvyW+GH/Jq7aZu/pSOrxuNz72S4?=
 =?us-ascii?Q?UmQ3J8CCN4D7bPaGKx5yoEWdgNDUy+nUAXGtMnMD0eyKwTKjf5wN6iGXEzYO?=
 =?us-ascii?Q?947rOhKl/OsbA4PBzWYe1Gi0hd58yFC1Va4/Bf0NPsaIHaxvmHbD1HLD9hzh?=
 =?us-ascii?Q?KgQRtQuROtEl3V/nZJEOF9xsvSsv6X8onX35+wWGsRM07dkm1lxYrD1iwgHZ?=
 =?us-ascii?Q?jPS7KWqoOyFkScVfB5gTW/2lyGZYu+L1qOQJenyVnMkerJyUnp7wGK0yZwh3?=
 =?us-ascii?Q?5BMv90zzTYHoyEfjZoUvbVbOJ5HXaVUjDfltlaT+yblehP5q2UME/eQRNxFQ?=
 =?us-ascii?Q?UGsEscXtjYdUt6E59XKgcv6M7nDAWx/KljHf3f2c6CfIVcQaaBYwYnAr7yIv?=
 =?us-ascii?Q?Yvyi4g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7196245-ea61-4a20-578b-08d9f7057fec
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 19:48:44.4915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9gm4pA5IhoRR/n4BCakSaoxpwdQY7jNTraz+sKrTwsMsGva0mcvsLeGf5/mr77rVbf36tueCTKBtNIp1rRdv+JXMrNSR03w/kPENHfRkyLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230111
X-Proofpoint-GUID: QBq0lFUCZP3hYBHQjBn0EsSPVRdw5uKe
X-Proofpoint-ORIG-GUID: QBq0lFUCZP3hYBHQjBn0EsSPVRdw5uKe

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
unique struct pages is a lot smaller that the total amount of struct
pages being mapped.

The altmap path is left alone since it does not support memory savings
based on compound pages devmap.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e0c1e6bb09dd..01f10b5a4e47 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6653,6 +6653,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
+	return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
+}
+
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -6717,7 +6731,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

