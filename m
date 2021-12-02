Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979782CA8
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:07 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KOOi7009455;
	Thu, 2 Dec 2021 20:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uTLYKEkYQvMOzaFUCKSxv8ku0oYdToHJNLmK7s3USEw=;
 b=CW68oSny6EBwpdQoNmaosRy7ejywvEKqwyB9aXfgGoEUVH7PhE0hf3UIr+5iSKzfeqAk
 ej163PYoNjcIaenxl5wOcgGTMVc4WKzRs1vQqApYZlSZ4r/jx5z8uA0RpZ2zHsNoZIyF
 O+DghtFdwHaE+cqSnwx5mJNWfXjXP8avvJH2lkBtdjpO6TBbL/OBhmuDLjny6qLRSRz3
 Wlfcm1jl+un2sz5xQEj5thulwfMLaUWODYnAoYQwGDbbyb6L9ScdUK23H4aI9AwFCfXe
 aiMIsl2ZdyknuROXK74/an3bAuBUTHTLmJ4Rc/99bgQnLlL7VLLqOAti9JzmxqZDg4hF uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp9r5b1a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2Kfgtc026318;
	Thu, 2 Dec 2021 20:44:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by aserp3030.oracle.com with ESMTP id 3ckaqk6htu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QK0fpsqwAuUVVSTkGBU9pH2nXk0pXDxNrINzF24ptS/aIN/fZtDP3hRTniNvKgI0kxPeY7/SBDFeCvyU1b/U+qb0zl7WsoYTxmHFDoSviYJiB1+OTO8NBLGX5hR80LLlSPl7Wke06k8a2uEdrEgHSdADHtDix+pTw1316lBTN835s8vuJJR3mc3oM0uyY+TXvvHGy4d8ZF1nyVb1mPZHUsVNldJDWXFQ62qYVODL+QIHHLquwQ9y4WIelhKBq3k0K19IJHg5YaJrXEUgRNiexJpL3PgjjWDerTn2qWpkfzSoHREleQfnby6m3Ntz2O4fMF/KkeEa9yylMfM89lOemw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTLYKEkYQvMOzaFUCKSxv8ku0oYdToHJNLmK7s3USEw=;
 b=Hb26mINXfKgMLS2mpfAGv0+oAArqKPpfxXqg5ZfRThqf9ELLtU8SZiqSoVoN80fLPYIdhBOymNtABafhvJ4CZLNy2idKatXQqN+SGF/jvlR6JUPp3yuU/Nh3w92+Ef9H4dfpiPStmPK3r5etlQ/fSsef4UCYCwlZaoQ98e7t4zT0dq7/RhcIXJHR4rl/En11tIhFJp5NSbUrZIOQRRPc6YsSEOY3gGiSEG5GrF9FsGDJwfiWk7w3WXQDqyOhK8BcCuVYhvcZ5/bReJ8qqQj13E33D9wmJsklEHxby+PSbB7gXlvOfqNKiQsXZgHIV+BhSpd5L0P4ZQTicdck67BNFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTLYKEkYQvMOzaFUCKSxv8ku0oYdToHJNLmK7s3USEw=;
 b=dID6idbMHlEfVpimX7wDO8dq6IyzWuGkYlScHoa8gS0ikXlYjL7HvQm0buQM2ieQ7x6ePCEI/Yg9bsq2QWxQ1656xDpZLWtfzX5OXKIpp5eqoNP6qRk6C2NRuDYFw+1gmt8Wu2RpujmIYpf5yeOlbHVs3pElMs7G6EPuSWV1Lto=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2913.namprd10.prod.outlook.com (2603:10b6:208:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 20:44:49 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:44:49 +0000
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
Subject: [PATCH v7 03/11] mm/page_alloc: refactor memmap_init_zone_device() page init
Date: Thu,  2 Dec 2021 20:44:14 +0000
Message-Id: <20211202204422.26777-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211202204422.26777-1-joao.m.martins@oracle.com>
References: <20211202204422.26777-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:44:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3af51407-0693-4197-d39d-08d9b5d494fd
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB29138C678960C03BC0AE4072BB699@BL0PR10MB2913.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	BwgpkjVZhIzYI8zO9gnNA+yy+r5JPGGscgHEQ7UktvlZ22UyCWslxAbI8BJCrqQsdGH1txCvpixkrtX7vERQdWQ6zdsiQ8UWSIdpEOqD6SQrtqA3YV1/SUd0J1bECilnl6bJCHhKQ6oWDjtSw10nYr4B5V0r1DnwlAVmdI3aMDtppKK9OQET3SKSz5TIM+AxeQV6wTHUvCpqALwp+x9c+CPGVgp1uwl23dcyYdlfUWEQfxwEwcRSBqL0FxvmddliKc8INi83XrjcIrLZih1duKf8BvZpZp9m66L5GExjf60KmDVZSTqmFl/I4cm7qI3uyUB2mXyt8B1Si+2RoutdgB58OCOHcRI7QaIWLOabiSMY3yZS+BF9HPt5BXyC6LSICzkezQwzmnekfUzftwTlChWC+w2P4ENoRJBY3VZKTihM4K4AT3WpmAVnrHLVq7z68BssGg7IA4wdnNTSIjfwcgzqfSfYkWQ0S1nN0iDSGIcFbKd4zfYIbay6sIrcnqQEwTHOhR9RvmMSfoSEN2TWbaEDA8W2K9al11MIFcc8ZH/+TjmFVL1GlrPGpt2OU54HHY3YlvKTfTxHhgZRMnFCcJhPNfmCJa7/G7EvOSoUMTGvsxxwu3fJ90PZaD/xk+niZbnf7fwG877dnjEKbhnTi+w0WCTwrb8BUzL/z1hv/AvWHXhduZPohkHzognvyIWY76d69U0Jhf/IeRuLAwvoBA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(66556008)(38100700002)(1076003)(2616005)(956004)(83380400001)(38350700002)(66476007)(107886003)(6666004)(8936002)(66946007)(6916009)(103116003)(508600001)(7696005)(54906003)(52116002)(4326008)(186003)(7416002)(6486002)(26005)(2906002)(316002)(8676002)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?m4LhYTfNclhs0Shk0ZtBQI0jPP9/CVfq6POzemhXoR2758nnJFjPDIF7TLwl?=
 =?us-ascii?Q?UuKHHRc6ZmkKvJFuD31VdBHA3SI1yZxcTkS0Z+XL3CQBbvAViGpWoc/0tqDr?=
 =?us-ascii?Q?Tju7spwKFir4VWoGXmuVOBwhz1Mj+PFYQXvduo1AGecNb2JAgcdySr/EGcHJ?=
 =?us-ascii?Q?u2dSPjMfumvmby6eRLRRYKp+d25C5Scw676rtnur7JcSIGnQnQmfQ7j0uJsi?=
 =?us-ascii?Q?E9p21AHPYikIrvTWKOmShNtE3dCiceOW6/cDWhjil4CXoVqNZHJurgnauzBK?=
 =?us-ascii?Q?9Fh1agTvUBf7NtZetaN+RBuvbURK0MJy7CYPZm5rWWFNp6jxqJK5GtFc3wy2?=
 =?us-ascii?Q?Qtq4aDTQPlvxkMr2aSFR7W6kTCgG7VffOjqKb1MXaLUKYKKP0byY13M6+g7L?=
 =?us-ascii?Q?ektIZM8CsLBbSSSpgL40wy+aiIIZ4DjvIo/HTpkutWexknLkWZOvV9oYPu9N?=
 =?us-ascii?Q?mE9e+Jz84902aNXE0WCVBJF4RX2LsGuXXi2FaPhA/yH8rstZfcTN64ZkGe0q?=
 =?us-ascii?Q?ht4uVKwozX9+Ox7DKeUgrR+aWVq/r6sb9JyQpRnfXBGY/HAXrinEEWxgu49b?=
 =?us-ascii?Q?avm2XsPQEoKFe7YQvoOEMhrGl0pRL+Cn6Y7VdJdjgjemd8ynQAlT4f8ccT+h?=
 =?us-ascii?Q?VDHnDlMOqztb5Yrmt8FbEyVZaUEm/mqU8SfQG/03qQZehku/b26Uly1b1ZsF?=
 =?us-ascii?Q?hZlID9I1uZXCjMkxo43lRCLOgqlxxsmJ71l/Jdt5CW8w0V3JozGJqRftxOeu?=
 =?us-ascii?Q?ZxIiREIQnZvreAMYHsbY1+bR0V++bnWTwimjYODUlpAFXYnnikiNDlQMt/b/?=
 =?us-ascii?Q?9YQBFH0V7covkDOzoY7ZFBPN8WuVgYrG1xfbQzsvJrccg7GRhZ68mHdT1bJr?=
 =?us-ascii?Q?NmCkYDxlz2ja5TbyxXIQLmaw3+wqmQd7K7XakkTjFiXYvo5uGPezXZ2tChqo?=
 =?us-ascii?Q?bpq3SRT0Ii+/eTBjdsGuakyr31R0PzUGLpfBwqeBaOJQGsIZjcYl4dEJqciY?=
 =?us-ascii?Q?UlP+QTJmO0wTb47u2h0aaXvArg/Kiv6g/SrG1YO1mX/SE0ow43FWi0OrmtWV?=
 =?us-ascii?Q?YhtTiNtV3QD3mCxn9o7zajm61/sKG00E6wiIRsiEMJwrqIbTr/Nh6HyVBxEf?=
 =?us-ascii?Q?HUd7PuuEPn5IApTs55B5pXqaZH+gj6OWxTzbQq+SS/tNhjwe+aRHYa3X+E5T?=
 =?us-ascii?Q?qzFKCjuXDImgq8INs5AJWaLZEbdyK3ehCOR7CZdPWxLTPDddAVMgjIjIAR7L?=
 =?us-ascii?Q?FWMIobA7RGDud+bJbxnjGT4HhQ6E1mYtWUGYfLUtfxxAyt6Af8Z5/WdJZ7ok?=
 =?us-ascii?Q?BRHZzJ3BSfBMSoIy5X6SSQxWfgbi90dAbTMC6YZi2kdcYZd+Pm26Oaj4m/V0?=
 =?us-ascii?Q?4tAPw6M0FwUeZfm/BW0bTTVrVZ6AlEONordivTdals8LQNrNJZSUwwGD5kRr?=
 =?us-ascii?Q?AGOqMxnC5Y7R4i9bex7cU9bNupRJ8/T9jQpwIWiGqVh4fn6+jbaXMZNKsNyz?=
 =?us-ascii?Q?OasRJhXXku0EYpFqbZwR3FpLyT3ElJUpnLen6PLcVYhi1Dy/KB36rtiQE5ms?=
 =?us-ascii?Q?pj8CG+ZUs/VTYh76sQ7DzN+DDv2qcZTSc3tuIe58qiN94lrV1Q4slBgGc1ze?=
 =?us-ascii?Q?hRhjIGBiLR0JiIBJlpru4HH8Z0OS/sT/uKIIDm4hnZ/5mVW7ZsQwUkTPsLfI?=
 =?us-ascii?Q?s7KtCA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3af51407-0693-4197-d39d-08d9b5d494fd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:44:49.3710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayTD2vA2V4VRlNZ6iXJDBSH3uaR4MEE6KPKuxjOdlzlT2nBqjWOyUXeJiwkx3Ubq9PK1lWtwEgxk5OtQTARoXRGIrT546nkKoWSUMpcX7bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: jNyjN9QVs1yxH-dB3s-beZ31OBH2_ynu
X-Proofpoint-GUID: jNyjN9QVs1yxH-dB3s-beZ31OBH2_ynu

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

