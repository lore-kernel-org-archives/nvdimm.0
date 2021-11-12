Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB95C68
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:23 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACEQENp008613;
	Fri, 12 Nov 2021 15:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XT+ISnWwYhe5gFe4TDLrao6T9ENv/t2qqtZgPA+hHcg=;
 b=Hs/NHMbJ7DmjyunD7VAfaQ7Q3gYfMiqstvZjWODT5dpTGdfQuUq8bH7v+CPp1r7c026T
 Uw89Hj/12pp8QB79mOv4f4tCA29gmQJ1vFgwQTVjxYj4iZSXlgzEWX/VlPzTxB8qgs0B
 V1iaP2vSaDwDtmtL5RaSwg+Xnr/Pg2f9p2BQWxA1zzOSzR3W6rEWblDAxeXwcKAQB4oy
 wp73HTbA9HATtRlM666rHrYa41FAmk0A8j7OUJmcmFdrQxatLwnsgDBpqyenCrUB7+TK
 6qunpa28KJ9VWL/7apZCoDdKNnx2KOTFEpo8k2uqqWajP/0HQnlF7pFgJLRHwKqV2iyr pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9kn51yag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF6E7r094536;
	Fri, 12 Nov 2021 15:09:10 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by aserp3030.oracle.com with ESMTP id 3c5frjhw3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRrDcBtMunGWoZSDcLJ1SlD0rbnxJph1jxD7mqOYy0aZGPHVU4YA89Ji/dk+jRX0S7fdYNmpCWahiLy2RrenE2VqjwLghyB6xJ9lNQfTvxieKCFSHq69uSz4EbNOH7qvb/7uBk4VxITZUPoy5213wmp+G1GQGfd7fJXSU21dHD0nJQYK6wpW62YWpUbuWYIjLOUN0YioLnyZbapInoeLF7Sq6y8U6BVbzmRizlwF0NAkL6gpL765TybqdjvP/AX/HcrKVBQjlZUUnhTqiDNb0Er2TrnG0xP8uYK8fnrzmhOZus/NYBf1XezuUNr14MeBav2GETnRDkv4HZh5cRp+5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XT+ISnWwYhe5gFe4TDLrao6T9ENv/t2qqtZgPA+hHcg=;
 b=hh7uFJmVj1I6OU78722rfN+SeUpXjXlT4WPC5l8unrOEpwd0Rzc9lX/Bp7vZK1q7QWVGvamEkadey7TxqBQI7XO5EtVs950xS4Zncat06+/kJ03GYyjZ6W8n5JFLgP0DA0EZeQcbNoDiMEmC+rGKOxp17QcNIznrWZtPV/1+vgKPObEyzDtINc2lSX4QqMnQeEPuFkVXkJIMmzTHETxG1pUZEcRcoi+qxP6SeGXaSjHpdGJhXLWfTySkNOe2jlNGZaGIA6/J1uxGn3x5ZT/X0l78bsIOLw6Gv34pJKJ04dYEXN8KsE1ohdR3qUBpg8s9GQmh+qp//JNl9ziyEnIkfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XT+ISnWwYhe5gFe4TDLrao6T9ENv/t2qqtZgPA+hHcg=;
 b=nZG7gp2ARF1rRw+6GIXkYBLibP3+n2FaM12X3gwhU21FmrXsihKl0EDm52/7TddIR61+z0X6UKUV19xYyufsUeYmzUy9b234AHZ6bJBepk6YoM06ECYFTcaIGsuKqK4mNFQZauGSoTSk8UzluCjTYfGb4NHVNN2x8RWtCYRDikc=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.17; Fri, 12 Nov
 2021 15:09:08 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:09:08 +0000
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
Subject: [PATCH v5 3/8] mm/page_alloc: refactor memmap_init_zone_device() page init
Date: Fri, 12 Nov 2021 16:08:19 +0100
Message-Id: <20211112150824.11028-4-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:09:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edee9e87-7b8a-4e85-b6e2-08d9a5ee5ffe
X-MS-TrafficTypeDiagnostic: MN2PR10MB4223:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4223C58CEFA8A6D05378C4DBBB959@MN2PR10MB4223.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EtDS2SGrHt1GhetLPp8kv+JiXtj+PCMl+c5a4T8+U/6DscA7bjd9CO5z1/jUi7Sr1kPWdivq9AXFuCVUOwfrZrivfvTvoKjIE0ycvcjyMD9QKNB0gB5vesSy+vKDITlPbT5jXrDMkOabEvEbHw5Gl0dBcWjiTK2IAjCQREupbOXzmmYZRgVbRrI3MaOGHAjnvGIY0JR5QBCM6lBLp5b5YacErm25Cp/JlMXqhVtU+f2GRDsPEXwGps62TvJZziukekskoCVvHI8jxJarcC1QWkcgSYXGwgNbwt4rRjSVNPkb+G4xC6IpyAGhVMQllKBTXQ9btZ+J7wzVaMY8XJKk8MDgbagd6Qwzv8DmwYUs45eTXo9Gr/rzLoTYSazSdRrQnq1qwnQkd0tbzbjPM7W6Mr4+E5Z9oI7xbi7gRzov6DEbDvJ7cpEBMvmylyoez8y28PXK9ECoxo0WOVRkRs70P3VIW8pAD2YWc7wkLHgdrfzzi3CrJE684NPHNxejOEJ5kVpo/aDdEy2Xu17zuBjB2NOrx9rvy2Sb/1oM7rc00pSawc+pOzM0OC/uz+W8v6Z2QFZkbN3jORybEII4enQydO2MLYBjS4A4vOooI7f3BGcf8KZcx8qFi4DGMJHMJ3AMfc9TOYY2JUBskIXKKLYrWQyIqc5ZhkIUhowPId9aZkJ3RLY0HiJp6x3sdKm2Xjax0j1pz8D9ORT8TLrNftzEvg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(5660300002)(2616005)(107886003)(2906002)(38350700002)(38100700002)(66946007)(6916009)(6486002)(66476007)(54906003)(1076003)(66556008)(6666004)(52116002)(4326008)(8936002)(86362001)(36756003)(103116003)(186003)(316002)(26005)(956004)(83380400001)(508600001)(8676002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?f/C01gTGxdpALRE9sDY449/FNX5nu4MM5RAL2cvK15L3ZzeBvRQbezJj/LiT?=
 =?us-ascii?Q?E+1unfLv9alOdH/37WkctMLLbjDg03DSrLm/a+hX4LjV92zxTspNNDRm50pz?=
 =?us-ascii?Q?hAcE8QML8OrrcpwnF9bFRWF1IeVfpygErRVZB7+iOP7ORZytNDbZT6vUjaUH?=
 =?us-ascii?Q?liRDCSVlv7q7xuwbBokUMeeatG9+aWmY535fU2uwk5/cqLekjDAOvrUw7xDt?=
 =?us-ascii?Q?wp8Oblz2L8G7XLztsM/fRZBIKpfddHvQi9wGM9jKJAprOpegl40m4mXR4NSL?=
 =?us-ascii?Q?VucylOCWGh18rg/G5Y1qGPXGCDZgSTYQwkIoKtlzPFrOtgmUvCqy7aryhWZE?=
 =?us-ascii?Q?96zgqcNjlRE+IIzMVjjZWAnOryFIcgPUjrvPoRIjialXDyCjTNPlIiJ+1JwH?=
 =?us-ascii?Q?oLxvpfASl+XxwuA+sfRu4WWx7i7o4SZu1A4kt/sr1XYFaBvrN1MDoA7s/Bip?=
 =?us-ascii?Q?W26jp+0F5R30jFpW4475CMTGyWyAa6NctT4g4zl3/52oj1Y2pfmGGBFzsjjv?=
 =?us-ascii?Q?ZZ6W0V78wNChqhNfnrol/7oWm77tFDG/LuPDGHxpb98/jK8WNf/hYN5X2+Yj?=
 =?us-ascii?Q?BS2m1UhDoNssU1Eej6PsjPA4wEUAcdVo0fyDE8z9T7bPL9BiRdJJxyDUSqaa?=
 =?us-ascii?Q?czK2ClKGsoU7DvQYFPn3QHK26nsk8SdjLMaWgHVBguMn3u9bQnpy26VZF5mR?=
 =?us-ascii?Q?CtKoKvemuv2GxdUWjyMgZDZze702Jvip0Ewm0h85dRYvVM9SoLy4D+SYqO6r?=
 =?us-ascii?Q?pwwT3d94CEysB7ECgJlyFcEYmTBG1FpEUcMos2cvcRkmfezUtXpjntNV4t8E?=
 =?us-ascii?Q?id5k+uKdYNuji8Kf0fyVWZcBq6dmR+GFOMBk4y7JShtlUAHHoher4VEdsHX0?=
 =?us-ascii?Q?4soujSU8nbwuMa8kKPOcWIPTSJ0c5eQOSWFkBXwQu6F9HBBjaRqlbB7XIHVe?=
 =?us-ascii?Q?+eqGOIueK/sDJXj1QKK6IBubl6ik4FtgQ6iLXe/2/nbOrK4JeWbavUnqV2Ws?=
 =?us-ascii?Q?/U43wGbeSOogTp7WqK8CQFtCD8nifylzLwvnwgIWnMq5UiKIIEREvGKU9ynp?=
 =?us-ascii?Q?MOBbmZ+4tksgdgPtwHYyFrpbnrSzCLXiHIojxs47s+AjHuK3NFcjD46psHXb?=
 =?us-ascii?Q?yPVpaV+LjatRpHSg98XxXiRLKgAeocxupwN/tXiaWNl+l5AVHBAKAcYfcno0?=
 =?us-ascii?Q?26ozTbR5mSre4qf/SpOxMn7CObdA12IGOxGhtr/jugTRGGLcVfB4ellWNfMj?=
 =?us-ascii?Q?a9imu1A9QgDO4N6bqpTFb95WHJSYzK0jey0xZVvJIOURmHfeqoq4sphR5YIo?=
 =?us-ascii?Q?V6JUFCX4o/N7gShPP2tvDs7i8SIjPCDyglThe63yyJToVzfpfY2pKyJo/Npk?=
 =?us-ascii?Q?IRA8aaByzHtFy1T5k43igQdpGAwAttsUpO7Sc0P7/H4OdlfEJ7bwQpz8qhzF?=
 =?us-ascii?Q?qLcjUPxHnHgFFQIg+UlaVCPJ7g8GBPi1Vfaw18DP43JJu1x8Fu4fEP2QjaSr?=
 =?us-ascii?Q?iYGh6MkVWkdbgBPIqkqJ+2Q9i66Ob9n5XSpppaYKPOiEGs8o2uUbAOHEtNX/?=
 =?us-ascii?Q?4CxfFqvqU0f0T7+W/SVABzUM4k8De+q9rzurB3xmo7gFmTCqnB57UCQ1/X5b?=
 =?us-ascii?Q?mm17R/Ojhz/qsDZNJ8FvhGj1gTcslu3ygkQ5678Y9KNAMbUIfllxvIxyxFM9?=
 =?us-ascii?Q?PWi9ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edee9e87-7b8a-4e85-b6e2-08d9a5ee5ffe
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:09:08.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqglSBoPOCXsTnIb1xkFJxITXijHlx0gYfHTiacHBRB7hNVe5UySBodCKe/YMxkCFNNhskZYx4VYQnHocK8J4CMtOT4YqityiUK+SnShXLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120087
X-Proofpoint-ORIG-GUID: 2w9kIrxEcBcE6R3mx1NROGfNht0pAuTm
X-Proofpoint-GUID: 2w9kIrxEcBcE6R3mx1NROGfNht0pAuTm

Move struct page init to an helper function __init_zone_device_page().

This is in preparation for sharing the storage for compound page
metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/page_alloc.c | 74 +++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 20b9db0cf97c..23045a2a1339 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6572,6 +6572,46 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 }
 
 #ifdef CONFIG_ZONE_DEVICE
+static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+					  unsigned long zone_idx, int nid,
+					  struct dev_pagemap *pgmap)
+{
+
+	__init_single_page(page, pfn, zone_idx, nid);
+
+	/*
+	 * Mark page reserved as it will need to wait for onlining
+	 * phase for it to be fully associated with a zone.
+	 *
+	 * We can use the non-atomic __set_bit operation for setting
+	 * the flag as we are still initializing the pages.
+	 */
+	__SetPageReserved(page);
+
+	/*
+	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
+	 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
+	 * ever freed or placed on a driver-private list.
+	 */
+	page->pgmap = pgmap;
+	page->zone_device_data = NULL;
+
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations
+	 * to reserve their blocks rather than leaking throughout
+	 * the address space during boot when many long-lived
+	 * kernel allocations are made.
+	 *
+	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
+	 * because this is done early in section_activate()
+	 */
+	if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		cond_resched();
+	}
+}
+
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -6600,39 +6640,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_single_page(page, pfn, zone_idx, nid);
-
-		/*
-		 * Mark page reserved as it will need to wait for onlining
-		 * phase for it to be fully associated with a zone.
-		 *
-		 * We can use the non-atomic __set_bit operation for setting
-		 * the flag as we are still initializing the pages.
-		 */
-		__SetPageReserved(page);
-
-		/*
-		 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
-		 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
-		 * ever freed or placed on a driver-private list.
-		 */
-		page->pgmap = pgmap;
-		page->zone_device_data = NULL;
-
-		/*
-		 * Mark the block movable so that blocks are reserved for
-		 * movable at startup. This will force kernel allocations
-		 * to reserve their blocks rather than leaking throughout
-		 * the address space during boot when many long-lived
-		 * kernel allocations are made.
-		 *
-		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-		 * because this is done early in section_activate()
-		 */
-		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-			cond_resched();
-		}
+		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

