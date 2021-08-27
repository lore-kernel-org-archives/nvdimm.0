Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B7F3FC4
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:22 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWNnF015229;
	Fri, 27 Aug 2021 14:58:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DJxhtf2UP32RKJtBZO6aYGJ0FEFIQg4NRMEDKTpC288=;
 b=AOpwsd+ySzxx6CSxxVCWQL1nStC8+NJ+DKxFYxG2eIwj1ZIw+AwiWsi9wee/6clSr505
 MQkJhzjh8wC3uFP7Vr8vcNMMcF8jgVJMCr9JoAALTUx4yYlBwvxg+HvuYYB7W5ZE/bzx
 lm2vwPdIn32LKf+btUpBkll36pV2RYH7wHxJSB5nO3+7W/5uwIHVOkNBdooGteFymw+1
 ejHiYUpH5FUWhLjqoo2rlMbXzeEdLB4eRWw88j5MpyYcXN2zUOCrKHSveBhcPjlGJ2Ku
 XURptiugO4g7+Tpgi7oDvC6Z1jyOlkNokpNB50OcsFl/6sbQGOLh5eH/38IsXmX73EoT fg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DJxhtf2UP32RKJtBZO6aYGJ0FEFIQg4NRMEDKTpC288=;
 b=njvoaE409aSv52T8ngPgfVWUWKiLOsLpq4/ylpHLKxVR1Zo+2JB7XXhSMky5Ko9xfpdG
 FPy/W1A8xF4eWqRNC1zaKCEY1P2o+x+Y/bSWDqKKoyukE25JxYsK8vxySgfOWWi8e3CA
 CSOfcdMnWyBJVh4V4zIKvhLAp/Vmm9gw1yDiFGzsByr/J+d2kD82EQR/uugNp+XGP14B
 OyySFod8KjiKYOi5KTaehZqWF800JkWR81gctlf8yqHGtaLM9bkBzUtwrRQa3+vIG00J
 BVrgt4obHPDvX9Lppa32AtXtOQt3DCTPRWVZ05cRN4urOrkUdZyx3vEIdcxF41h1xoCa cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4ekuwq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpph2034347;
	Fri, 27 Aug 2021 14:58:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
	by userp3030.oracle.com with ESMTP id 3ajpm4u8av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rpk5j1EMeH/ByyXdOrDygTUtBdwTUJm4JgAYKwtqgrQYkE5Q/hvQEg+flj7Q4jnb2/GxlV0HIPzwz51uv4xEMVCUUokpM3dWWvR+WfFau0DFFJaQGXzQfBDxU7DQoEm573eG1TmR2npWEGUhF4Pk0A7qks7gizWhbjsbaorRZ+ugi2hMtaAcaV/OAX/NJ0A23abFz0bpW4HEGN6qBVLwho2Q2eZg/ELKUsS944RDGu9+3w166GMzcJ1rXcWrHzwr6SiIQzOddKDu5gwoFMh7wj2CIAFSluSLKQNq0S5tTRhVdmVGYeXQX8ZWdCQK+g4ZT8EAiBJo5abrkZfE+NyNwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJxhtf2UP32RKJtBZO6aYGJ0FEFIQg4NRMEDKTpC288=;
 b=jjttVF/qSETGyADOoL8uWEZcCNmsg7Oq+s52a8f56KC0h0AWAf2iFAzf2DAQOelRTaBX1KLSBWQrqAMt6QCIQ//qR6w1VfJgd4Qz5naVrbNNhZ9y4EMv5PmXJO2mQbFx5zPirx+ZJfJLu+VXpGzsWax7ixZlbMPBFfdtmyUVbcv1/KpgLL0T5kCiDZ2WsfhN12JOzKH/MGnhcxForHNx2YBJnEDyRTnrggJ9vjTzA6Ia899X0Y7GylUvPoRa1vxIWADrkbuvyhE2J98bzJ6GvcMkdtJs6gcHDlRAikUZE/SVs2Of4bO3twiZL33LarVIYSzTmzKbFu2UoCHabmocSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJxhtf2UP32RKJtBZO6aYGJ0FEFIQg4NRMEDKTpC288=;
 b=VdtDsPbNKNEB+2ekF97eOzHbDqszFhJ1N5uy2VlzEyWL8jJVmbhUKjbbKDXOt57B7MvYNF/IG3Kjp4FrNUYqBCQG6Z3b6FTBmQAem3IXZfPo/L9AhEC/ShRZhPmt2EjMawzbHoA1AStX9ZKFKI4kunXXsXJG/bfnmzufamGXE8U=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 14:58:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:58:47 +0000
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
Subject: [PATCH v4 03/14] mm/page_alloc: refactor memmap_init_zone_device() page init
Date: Fri, 27 Aug 2021 15:58:08 +0100
Message-Id: <20210827145819.16471-4-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f763bd4d-e7a5-4ae8-ae53-08d9696b2c5b
X-MS-TrafficTypeDiagnostic: BLAPR10MB5025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB502514DD9489BE4F34753CD4BBC89@BLAPR10MB5025.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rO8I8YU1cWASEYR10rBb7Jpf3RIL7x5WCfc632W755QOPqynQLdpPuCD1bzlbmoxxBllydKfMK/VQu9lhESwpMv+It6jJZxXSQ18+u0YTScEmlEoEElcZxibYSjbsDSmFTeT/Ml/4A7ewXNs+0J+Molzqsj0PiH5HUJQiyo0ChOult3XvoRHC0YPCaT33d5T4tWqNjOkI2ommpELtfBHcq7lHOAkPs4WeMcQ3NU7OHLYylj3tQLz4uX2fKrPfrURCqI5W/fIvkwWz8b9AWICvh3YnV7sknsRR2Xm30VDbQ5VudY/Cnc6pbANX2Dn6fb7DmX7B8y6Gw7Oe2CV2Y7gwNDNdMB4SaRtdb1QQnf+psOlRwbbQ9O0jyk8Lf67sYmkTvWLvxDSN9ik8bIuW1Z9CuxpDt/RTpWIld4DHX58NyN+DzaI/pLMb4clkEG2ZvkKXTwa15hWSNGWj4nOrM178/aqT/5rf6JqtXapRpCeq3/rUZwUwoLSsmMS9PVUw9yawcb8ZJ1lLm5tNbl51/5SUemah6Ytz7Df12YOBhRFtOD4/ocuPLUAuK6VV9xenlfft7582YF4Yr/GoFIdTteQv/UkFbnJaOI3iv3E/FYlpPuT02Ssm5KsgKSpDuobul/jfoKYI0Rj1cr4B7Q7fYuI4uwg261sawgEoIzCmVAnvO4zOOzw0RfabDwI/dU3vUWJd/Q6U1hz3MfUplKgJB7UvQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(103116003)(66946007)(83380400001)(66476007)(86362001)(54906003)(6916009)(6666004)(6486002)(2906002)(1076003)(107886003)(8676002)(186003)(4326008)(38350700002)(5660300002)(956004)(26005)(66556008)(52116002)(7696005)(8936002)(36756003)(2616005)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SSWmmgPdPDXviN/K87m0ecGYzjz1+l6zy93T18C9W+GRKEIenIfAlvhE7+8G?=
 =?us-ascii?Q?/3V6Rrrim6DZ9wrDYFUI+wqD95FbCORwkofATPEMT6Z+S+t3eBd9U6qvi5El?=
 =?us-ascii?Q?VKfS56dm2P40pHcosLxROxx9K5Gh7dsw8+s3CghgB7hFxbN7cQJBk3wza2EP?=
 =?us-ascii?Q?kwf8wckWCfDziQi2p38nkWpb+YCxtXXLJNIsVqClIYXHdeDxe2I97BJqi4pg?=
 =?us-ascii?Q?G/mHqRpNniRmArCq4cophU6Q1+3v5Xb7Ul8wUL2JO6WidlNg3sFoA9p4dYpx?=
 =?us-ascii?Q?ELQa+8Elb0fwsQ+SlZJdam7l8VNWC3aWhrv1mNp6RTaodX4AOH/bygccFRbQ?=
 =?us-ascii?Q?wFXDAfOxPPEI/O44JWx2wyyOQRhePFuO8a0nYEpQCRjdnxrijJJMbdN+H/YV?=
 =?us-ascii?Q?HDiaqQyQ9t/q3/f1pgGxxWorhl0LwYEYjIJHx0lxPqZROit2Kf8mJ7eZeFBk?=
 =?us-ascii?Q?Of7EkJcZ/NJPVEoSVgZhuyCXR6WDIQz5LsNzzgtWEWfqRlQDmhfnIzk7akfY?=
 =?us-ascii?Q?425twZFq7H2ScTXiwfoVm+DWKY2x1QSnI1AvXt18bFZ6vsKIxB166umV8RQi?=
 =?us-ascii?Q?rpgme3xlfxGINzxnfU4+hgy0AZfz81TqQP6VaZ/hUFqKFf1+EH+pl3YmRgBl?=
 =?us-ascii?Q?2oz7fFN5WqEi1x+hAY95jlOWs3NVFfADQxBZ0Pdmonw6dfUGcMDR2AB+9LD8?=
 =?us-ascii?Q?zT/Z2bTY83lHLYXmn4ecPVTIeNWUWyx0qTIWuVyaYR6izYtzWHdQjlHza44G?=
 =?us-ascii?Q?XvGkmEeATj5PP5+yPnkamPXAaOoWve8gAoaeMwRWS2oC5GEcy4YLUgGSQzBD?=
 =?us-ascii?Q?05vz4fYqKdxUcEdk/RvOr1bzy27Ca6XC65j7MSA7D39pqYUVeIChuuZcUBDC?=
 =?us-ascii?Q?ntTnyQGKJkq5jLnWBgufiY4l1Hf1C4zQdrtoROsORieuR0cvA88fgw18bsep?=
 =?us-ascii?Q?XCz1J0QofDlJpeSb1ZijyNwByKd0TJ+3XbytXAfMIamv2C02edOALfim1nWI?=
 =?us-ascii?Q?sSsvnQF0bNPwpnIXtIoKqYEo1RrlS4BgasI5MxitfS9CiI131WZl42dskM3+?=
 =?us-ascii?Q?304GvNCLRmDizIGwnRQqS8y1vxPtFklo0+4bHa6ECjx6GM+9/xuKLLNPSJkM?=
 =?us-ascii?Q?zJePboGofS+HAFBJWAruhEUVNg4WlUiHMoMsqRP5gt04x+N0eVK+t6yzmkjk?=
 =?us-ascii?Q?cX0pH/n76EOuzmSjkl11QRHuEs1bf12wbaLSouTXZfuIpJTXXix2Yw9cuRRm?=
 =?us-ascii?Q?XZEFiBBA1D+w8aaOwMQRmKXGF+X7cZjYkak3wA7pyt6aEw4pi4y1tfkjpTjR?=
 =?us-ascii?Q?lMVQpIx3asGZzFa1VAPf6L+I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f763bd4d-e7a5-4ae8-ae53-08d9696b2c5b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:58:47.8051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6aWHdLsE/NgOOYmS7Xs15NP6V3k1f/gRa7L5RdXMRfsfg32E1kGxXhjxO24nyTD2l2aLkxEQe3ROwkG2GUxNW8kmntkVEqVDy2wjp1gXxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-GUID: Vn1QbcZUwBvuxadr5ikVqud0sA3FbdF_
X-Proofpoint-ORIG-GUID: Vn1QbcZUwBvuxadr5ikVqud0sA3FbdF_

Move struct page init to an helper function __init_zone_device_page().

This is in preparation for sharing the storage for / deduplicating
compound page metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/page_alloc.c | 74 +++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2f735b2ff417..57ef05800c06 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6570,6 +6570,46 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
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
@@ -6598,39 +6638,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
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
2.17.1

