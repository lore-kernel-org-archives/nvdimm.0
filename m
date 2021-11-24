Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF132C86
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:50 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOI2slv031388;
	Wed, 24 Nov 2021 19:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uTLYKEkYQvMOzaFUCKSxv8ku0oYdToHJNLmK7s3USEw=;
 b=kI44QLZYE2kocX852pd5wmIlpXkz5724UQ1Bdt0iEX0h5zGUZ6DV1piwWHTva/S5zPYG
 8NGHlxABjqkKgXGPeV3c84i/fhfsbRNpVcWIXoLyWMA88+PUvD9BFraMFZk4wIsWHvnf
 O21YmWV7AgHkMAJWIYGqXYa8tADQnSHJH5IqZQ4bsFH87sJylSrcB3tU8jKDPuaPGRfK
 aa6KeN6R7+dPJMqux+SZ57yMp9/JxE7b9YsIZHMImyqn2kYZ6WErlKMmFF+PJf0kOA0s
 uvalWfpnjBXYfjw0WBTPloJuo9VjqprT8dBTMNHcW5oRsn3q+ZhzvzVz8snL8XiM9Nob nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chmfn2qsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ1J4l178752;
	Wed, 24 Nov 2021 19:10:32 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
	by aserp3020.oracle.com with ESMTP id 3ceru7j9bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6+0K+z/RKDwLDCKXGs1j88EptRI+PEpqP6E++nlI+D1Bt6c8JUQvdJoUbX/s403V8yypj6lN3e15E8hIzMPyCGoxcuQyK8EE2Fj70H8eklWAvcXsqzj/jv4/aKqEmiZtgBGKt+B0cnngfyMvsYgs04lPoTiX2csWndI42F2THl7kjbWPi7T7NQr31Ei8OHzLGhGQ2yv7u3wF2p0PdgbGctU0JJmmBVaAzuW0388qXVEvOEDzotmO/i9JwQ+3I8FE1UPUs26qVSzFFCy5SZ6uK/3JPAo0UgPvCfBhWA5sx000PQ2NB2ikRbqnyaX1Hxg52F7vic1aFEmuX6qDxTX+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTLYKEkYQvMOzaFUCKSxv8ku0oYdToHJNLmK7s3USEw=;
 b=evNfyyCLILc+gWPSIm/Caf/laDSrxI9yAHj19LrfsinnSH1SHFmJ+rxM/ERBRJDuZbA+VyXrVWg0Qb+LxbbipMR/vdUhhILE+3ru/qF1hk28scH/Jnp3MYaO0qDYVkI7aADRDYUlTRG+J77TfmSX0CANel/cRYoHkywJezwee+TtT5Geu69eAcPPs9fblIs7nPJ+fVg20HbKby/IgxtKNCCJWkg8v9mUR8KCJbLPdRTCUXdWc++xd+59DyNqZ+8iaLnfOHyq2ps2/XfqyrGeSdTcL7KKEWiyIn4tHeJr94vCcN0ZWykenbyD/kbzR8btlzCOXwsfn73xhMdx+YB/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTLYKEkYQvMOzaFUCKSxv8ku0oYdToHJNLmK7s3USEw=;
 b=n12rnRS11F9uvwX+V+fxAs5893xatNjyuA9RGW3lQt/GBuMm4i51wSCIVN+UiCQi9ZWrHWnalGOQNDkO+15AZ7a5Dat8N7HjoNPa7vJNcZOa2ESZx+Y5r4iBlZwY96k8T1e4VAAwPzwhvIRoWqjrBEjuFoRuP952pLWGq5QNqK0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 19:10:30 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:30 +0000
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
Subject: [PATCH v6 03/10] mm/page_alloc: refactor memmap_init_zone_device() page init
Date: Wed, 24 Nov 2021 19:09:58 +0000
Message-Id: <20211124191005.20783-4-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f51aab-0e6d-4794-9b9c-08d9af7e14e1
X-MS-TrafficTypeDiagnostic: BLAPR10MB5234:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5234930F025B182783C475D1BB619@BLAPR10MB5234.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iCcVUSTx9tW3r+gvVp0RI0+bE+9iXbrczCx9cPWyQSk6eIj8kmROU0NJXE3jqoF6YSyEcIaF30iH70RxMzdPC/IThpM3qG30k5INoRYfI7xab/+sOBkQWGRt4NBC1b+XZtpAmVG32PY9km2b7flSCjOMxLXFXen+qW2YqYHINNh0yd45GOHBcN4YYxwJisVSHNQoCJZLPrH4nfBKy6W0zLaKSO3zkfYifb0uV841TwQqXTtyas4elN3VKcvmmf2jL6xQHYg88AZRjAR/Jz3teQfag6tWtrNx5HFTIYkoXRF7a45sHxH5+EiXwT3/hZJOimZNRafzJah1pBCCgY/2NJpeFKTJHvz6dkOTDVgj3FQhMtoeNy+o+PmSyC7aWj8GZD++6KrmRP1t6S35LT9R5kVmsDPgFL2CRrkB19f4MWKo2ir+SvXhWmAer/R7um34y5WJHgBWxiwdRwRgyXoBikEntIyq1iZNtL9BYvjQZMQJiUqZAIwXGmZ70Cg2SE/cdNvjhA3R8qaofZUo7en1awKeKuP1Q/98jsKwQaEx8jOBSvVJKMEdnvIcnHjnDP5vjVeq9N8BRfUX5pPcI2lHwHQWmOdj5A5rBSpAUaE65dYSj2B7/oJboDVg0RU7wnzB+8OYffFiLB37K1aXbinhVR9QmQWpfmC1xSmnQx+/oEBs62HbRYCEYNx07P0qkL8kfMAvmqa9vya/2Y0wEHjyBQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(26005)(7696005)(83380400001)(186003)(6916009)(103116003)(316002)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(107886003)(7416002)(54906003)(4326008)(86362001)(2906002)(6486002)(66476007)(8936002)(8676002)(66946007)(2616005)(66556008)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?rZxlZiHPI13enpLHXXX9nMmbGlibyx74iGpyO41kQmFlzb6Ykpk6Oj8NJXRX?=
 =?us-ascii?Q?hXmu7ft3DUw5axEh+Y7HVfOAdjuKSnnNB2wc/m1EJSTJJINs2I7nQ8DHuiBa?=
 =?us-ascii?Q?sKiA2cze0Io8c0y9lKENQQO+YiAZ/UQUehX+dX5/zOLovASlUz+iXkpPp5rx?=
 =?us-ascii?Q?uKvZdfjLmpRS0ugChnTK6Y2QLnQMfxwUOU1t3EFMXgNeNJYefq93xbPzeZiT?=
 =?us-ascii?Q?ueODyla7eslKHaihpwxfPywsXy8xva10uDJmsuomboQFz9QqA1axtLqvWt7k?=
 =?us-ascii?Q?bnJS7RdM6tgR2bctRTP0nofCLuAWfKGMsCoyQLg2pSIPLSxNtNqMxTRhi/py?=
 =?us-ascii?Q?at+q9qaFXnm0m5JvWJNym++3mI7O2MQL3eNlhVevs4BeB2WhF8y2kWXCaSFV?=
 =?us-ascii?Q?RM3IK5/FODgUx/JF8wmn060GjRErutKMHRx4NOnUA8XQdNqkXXXd/wTT+x6D?=
 =?us-ascii?Q?qkas8S+u+VDAMhs+Ji5PJm124de+rv/Skt7O8ZcBdjr8+JwB7McLnz6oq8jB?=
 =?us-ascii?Q?L00HOvEX8muhDbjTbjm3WFkYtSRXZ7fTdqTMTdZ5STB7SR0iwQ16PvuLBoIi?=
 =?us-ascii?Q?yss7ar5OXldToBrIBzJ1ZxgenjpI0Vjmz5MvtmJSPal6M0ZgsF3dszJTYFGP?=
 =?us-ascii?Q?k+v2DjysgcPUWBlxC8idfFulNP2mwbdpWToGQiyCeB8w+W0JNBd+Vs+ujyJV?=
 =?us-ascii?Q?JkQ3aNY7P9Fk3SvAFQTX7WM4JvxcgaCwEUKQzuoi8AXdWHKGaKo1K0ieIVWT?=
 =?us-ascii?Q?dGL5n8mbOGOrJQjI1OpnhjJET/4pJo8V49VgPYx7pNePpcRR8O/LD4zHwb7m?=
 =?us-ascii?Q?ZYSdw3q5V11hVWBNy4ysHYx9Vf48e3InxrMClalIchcbPZJYMgzPCoc71CnN?=
 =?us-ascii?Q?flyM57cFduqc16XIMYQtGaTXkKEuvLLM5PD8S+0MTzb7Nzy8mlLU8TUu92bg?=
 =?us-ascii?Q?8BORI22xtBnc/8kjJjpStUBMK5ORtvmF3nrRy4OzvvAj4tPGb1LUuBcgc65Z?=
 =?us-ascii?Q?LKR4rRyhRpM5sHnKCFosiJaf89MSNg1mptRyu9lkjpEDbbTyLy8HcBsh0q7i?=
 =?us-ascii?Q?J1rUAWhv56t+LSchA2bz9lCfZQyBaGnp24ELoaI0lV7G8KzxmYVVS6eboWYS?=
 =?us-ascii?Q?BYyKrDGxxASSxeKzKp4hGrbEBEJ4XsmHxUataZ9kAKcvrGMvM+LXmxwxXGW9?=
 =?us-ascii?Q?nlW8o621nzB5f6XCO4SzGpmNeSFFZBI3OFC8hok8Goa8Q7+cMxxd3PRMxhvv?=
 =?us-ascii?Q?vb9FuT6toAKOBJHoYlTZ6UagBBvgMhKk9DqUWC1ZyfT0rwBU1lgN41QEcbok?=
 =?us-ascii?Q?lWI9eG97B1+vF3f/FOQbB4vBqi3L0Zd/WihGqrYwmUIPtYmfKXjelD/7JQqC?=
 =?us-ascii?Q?j9CD3d/hS4HES85ijlVu0AB2VlNJckLPpQvpzmfp08LKCUWKCR6u7ibs5lxR?=
 =?us-ascii?Q?HVpEW6WOyU++hkXbKyU9z+sHCkSnLvvuvXaEsiKkKUsXZzRsXgIw5lVJEB48?=
 =?us-ascii?Q?TdSMjHpoldWv4xEWpPdW8modIobmfklvfQRKQa0Kckfe5G5Y859XhMl/BtTl?=
 =?us-ascii?Q?2rieihCXJUv4yc6ZgaPNrOvrbXObmum2gUh/Qyy9edz+r0yPbzpDNzb65+hj?=
 =?us-ascii?Q?i4sDx8gxn55FxlISV0vLauJN2jyyHsqO1nPpFIAUjPEd3B0//e9xcekIqVDg?=
 =?us-ascii?Q?dC5M6w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f51aab-0e6d-4794-9b9c-08d9af7e14e1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:30.2716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqDIMUkEWQK8CVBRTC7EFbxofDRVmXcjSZQk+sNaek6wLwMDwW1bXEO1AZOVxsY5U3QCaXZc5A0xOlzpzlvQTtGgMMaSGOAoshs/4nB4+68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-ORIG-GUID: QRdmqhNLQlYB7Jcuo09HabAdRD1XSFDD
X-Proofpoint-GUID: QRdmqhNLQlYB7Jcuo09HabAdRD1XSFDD

Move struct page init to an helper function __init_zone_device_page().

This is in preparation for sharing the storage for compound page
metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/page_alloc.c | 74 +++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ba096f731e36..f7f33c83222f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6565,6 +6565,46 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
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
@@ -6593,39 +6633,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
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

