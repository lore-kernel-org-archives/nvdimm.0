Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AF2168
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:16 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJW1Cd025409;
	Wed, 14 Jul 2021 19:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tqBpzLt289ReGCbu38csppoJJep4yCygFu6meR/8Gn0=;
 b=f7FvNdWAHglyx7cxDawO9ovBwYatMTzMDH8S0fClubGgRuvyPQghyEjCw3v4Po3Rg0oC
 EFpD0GN72cE/fkSGqsph6CbYNMnipCsHQACMXFx0vqYk8lLtAzD7qFhcLvr1qkkBFOyK
 LPzK30jq9z1FVnYTBlkjLoWSLj6Y6TcdbCrsHyLpfPye7FFIpg9DGNIEUTiSibk/3Pjq
 dSrqDEBSYD+8Hdo1+2J9PaX7OWDxmSHoK6g2EtVOhLlrgkPkN7ayTxKW3rhHrfyff/Mp
 VYRki3Dwj4PGoQXvxznoGP40gb1gGItJCN0zqSGjFaAQYgfiX3XRi2MGKkNky9X9ZGDZ oA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tqBpzLt289ReGCbu38csppoJJep4yCygFu6meR/8Gn0=;
 b=0TNV1YTkzbNvmIYebkOYhZ0/PwssvIq1MWgk7wQTFBwaAtJ2CQL6Sw6cqGW8tSVd+cHy
 LdYvAQZYq1eoZEoH9K4Kr02HKKWKXs4tYVJnF5XTZAVlC0JyhXe00Yq3UrCbPxTkJMDY
 jZTtLBhzXdVFCOiF564fQBAOf6H7q4rfIMH1Ci+qQRjHBRDnoVvpDN7ENWevVi+otXY1
 H1VwEpcs5SmaOwcGq2Q4BFs811DQSYJSn4z+eFQKBSM2d+0i7TxIy79/t0zOqLponMam
 cmjBegCo1zTyS0pb8VlUq2uwhrYRaDLrhax1rjB69jyOYL0wlOIxo9QuwcBmod3NVPWI xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39t2tj0eyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUYrV021568;
	Wed, 14 Jul 2021 19:36:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
	by userp3030.oracle.com with ESMTP id 39q0p98kq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnQTlv8Rc0D3oZqLSGdzx5yVR04o6BMP1zsXWWzKGwBxALWnlXGWhoWtI/Y5cW9hBXY/beoQRpu9Y1QcydlLooVodUS7vBokfLI0R9UAegyOCMqGAJCfxDTXezhAKccBwaSew+2VB5LgJjM4paosXvp6WqNOC0QrJBU/gt5BKhPOM46+O6IFWphkVMCuIkE2+dboctv6HJbm5DRaoDhonQjeuefIgT+HMKX4b8MvaHnL+STZ3iYlcypzDFLhKqYVPuwRzdI8OpDOWkIWQNcFtQjEL9ALhXjq/8Z8Zwc6dxa4KL9NkdDuLuuSPxE62Nac84U2WtJReuzhRkw66JnltQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqBpzLt289ReGCbu38csppoJJep4yCygFu6meR/8Gn0=;
 b=T0T7mB6ftIVvnSqjJDaaXk4nTccNP8kuEv58+Zk5PtBMhiOozkBNNF8l7mXo8W5i16Df28ECuU2RPxND7WPItZJFtAWF4FFONQF//W/fee/BdWe1Iqy28wGQLAclvXCOEEVw+18oZnVJpX1KHuwwFdwrxGz1qXumtV5amy5NqwJ1CxRGq4o0C8xRKjgZPdOf5P9rW5hnen0n1FXir7dstjk+FMR7IqhllBPpFhPnpyRP/6fLNsr9rYWA5ivt1EPMtuNNwaLT74nueArniKg7TZifyKeKeQfjjm5shBgJsB1lgapdeVhfak/egKrSeTq340VZ0HsKNDgUeq8ppN+awA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqBpzLt289ReGCbu38csppoJJep4yCygFu6meR/8Gn0=;
 b=P7p+h0u07I2iOnbas8zZlxPHabqCVbHDXt8zn4OmRe1eBviZo7wqOsFX1R9JsFKuSbWNXSihTVDBTpn2Cf8i0KntvmfXVWnJtvw2mwhJKHwFzj8xnacxvBc41TbWFUMmdiCFwcP5SoZT0gu/1rwqVpLnWeKSXqUClh8b7TkIFXM=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:36:05 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:05 +0000
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
Subject: [PATCH v3 03/14] mm/page_alloc: refactor memmap_init_zone_device() page init
Date: Wed, 14 Jul 2021 20:35:31 +0100
Message-Id: <20210714193542.21857-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210714193542.21857-1-joao.m.martins@oracle.com>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf23e509-d98c-4032-146c-08d946fe9eac
X-MS-TrafficTypeDiagnostic: BLAPR10MB5204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB52042B1A78138E452EC2A146BB139@BLAPR10MB5204.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4ONauQ1f66fd4QXLrk0hnN/FCJ64disUyMZPbbnws+Onln3iIscMxdRxpdOolh+dPuPRjVVvXDrpm0KlJHXFv1VYzd5R0IwjJi/pSK6xkiwWdJU0rRTEabv9tkdl0TCoF34Y6qtpK5pNV1DRpFA/9EhNB/Mm8v2+k8OPCvnr0po2/ZivRWAl+9Hhy2ZtxPr7e96FjF+qp3MEYXyLoWVlSWzFEDKxQ6OnFbpA0F+/nMxle9dJOpCxrb1jHxr8193N3IXqTMwrce8DMaS+kTsbw1VhIabOAYix+yaVRLjUpJBhFdO9ONYqjZ/ukP/IZKSlokxfy+W+9BGGvVIZz5WFrjkY+St+hb7D729SZGQg4mdvy0ULEdv9XRbtGS3pOhmG3wUuYvBAPECEOjmFH0/BWGgR8xSDDs21iFacf+qO+rLUZd9SmcbFFYN5TYh5z7AD0S5Xf+i0vuyojagzkgkJPYAPYEi/+vrvSi8hZvx6lJv4vEpXtgJtEADb76IlbGbv8oIZCeclR0tU6umLayUPQdcgrAKVWDoJF5zMSkBjtXJfh3ko7QfV2JVSEN3QcyIveBv4VF0m36mug02V1u8CPXpD/MJCPOf2btbN+yRzdroyCMfpidLo3CiflBtaoRKmn9TEtivYa+fNmywHf1wL7j7rKNZoxXsaAeewuGtKxTueYLe3kmCjA3z5zxst6j7vLU1elVWvIf33wbRZ34VcYA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(8676002)(4326008)(86362001)(6916009)(7416002)(2906002)(956004)(107886003)(2616005)(6486002)(1076003)(8936002)(66476007)(5660300002)(36756003)(103116003)(83380400001)(38350700002)(38100700002)(54906003)(6666004)(66556008)(316002)(66946007)(478600001)(186003)(52116002)(7696005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cEcDA3dVwJwOu6YFq9efNVCIIrfy9oZ44PhY3Ggc8A6b9liWCAoxvzm4WKnt?=
 =?us-ascii?Q?w9rDYMc8S3TceFOvX374M2t4xqTNPBDiFLJmIPXJtQ1DI7/olDkSwINZtcES?=
 =?us-ascii?Q?tNdJo7qc/6MjupZA/WRy9J3DlTj0rMkoRY6dCn7NHb0/NRxUPbvnbOQsGh4/?=
 =?us-ascii?Q?1HqZMENazb0Qgd1ysEl8Wccvvp6Py+0eExV1+7eT761YzPlfBtv/cVyxpbL0?=
 =?us-ascii?Q?pq6/Ln5dvny7KWqVDHkmPdtgrdXkMSUJhgdoNRZY7CPBgBI/KZn0fkqMnvam?=
 =?us-ascii?Q?Akv1mWM5MoyfcQyh+9mmx14g75pWzFtxx/25G98Afpns4UK8wO5NANhCKaJ9?=
 =?us-ascii?Q?5YFp1asdd2S87Sz2Q1o97VJNlsN3pKtRSIF/4Y3xgVUOt4U4ng0jZIuIOKX0?=
 =?us-ascii?Q?Pk33nYMIjjkuHF6D++15eEvwvLBVJhUEe9x7K8s8ek2mwikV4H4cS51FxmJS?=
 =?us-ascii?Q?VU+4ezmAwKED02/ReZc/X4P9eN8VDpjpABs4w2FRzhtcie7UHPBz2AHt6/tH?=
 =?us-ascii?Q?8UIEyV8He0dvJ3IG+qC9mnQ5Hpm4Zjnxpc5+DfUVJDMFREihIp0iPwBn3miG?=
 =?us-ascii?Q?yD8AExPgvnKYI42Ah9Y+ZGwOsuz3lw39gbFYXqVhMAGTffM2MsO08SAcxldR?=
 =?us-ascii?Q?ofvOP7jhuJ34EP1vnbcsP0REBimNMDn80umrDPJRp+aaTnXABAJkk7wMCULS?=
 =?us-ascii?Q?p3yHKv1BK35p0e74tp/2OIBc9XY5gTe220dTbXNRah84Kag0QTQTZgQS3iYA?=
 =?us-ascii?Q?Kz4dB4+dsLFUfMJHDPn1Rh8EBGdYWLSPYC0+EZVrCUcvACf17iY8VOHX7+Q9?=
 =?us-ascii?Q?uxI9BP8uj10d4yF5nXtOGwfrOgGjof19qGE7+XSHg5r7GCBG/Q+4DcDjvriv?=
 =?us-ascii?Q?B7LQBtt7D/qiLYeLmk2FzDVpMRwhwlMMD+Z+QwgmmFJHwO4LJYJQChTgbs72?=
 =?us-ascii?Q?NXYh5p+ztR7/NFjmJFNB3pU7hV8oaveKt9WLKjh/S3488zrU/+EPDMGjQ8vY?=
 =?us-ascii?Q?JXfSvuM4ZCAYo5Oe8FlFQCmcTzZmPYGjUy2Ho4K+m/Q1RZyxsCgjvSekAxio?=
 =?us-ascii?Q?M5XKvtCdj/XzZ0ihhntuHcuOYra533TA9S3cUA6P8wFFCj9u2VH7xfj+4vNc?=
 =?us-ascii?Q?BT+3BcEHrgds1ExO52IsJlYbj2npHP8PGySOH601Ez83wWheU5KgmMj3KnZ1?=
 =?us-ascii?Q?F1yT5eYYmAQfeXqCUAybPXqhmpUL7yv4shu6ZlFX/ZHGjNSxIlEFQFS21viU?=
 =?us-ascii?Q?4XnXtTcZXNJ6Oi8kVQJQXdTP0BcmwWpkjzpAATj2WAuTOa9HucXxbww61Vze?=
 =?us-ascii?Q?o5wkqHYtrN4ExUY68zNFfMhH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf23e509-d98c-4032-146c-08d946fe9eac
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:04.9242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QNljCBMEY+VuFdqjk7tK2nPZIKbNQiZGZura6OLaXkYN4U/OuwyxVzZLVWPgwE6QMa7VUsNwzSaaiB1QpwQZwG+LoBmO0kGBrpwVHqVi6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-GUID: 1dw7y1K7D_lxIylc6_vxUfGqloHoJViq
X-Proofpoint-ORIG-GUID: 1dw7y1K7D_lxIylc6_vxUfGqloHoJViq

Move struct page init to an helper function __init_zone_device_page().

This is in preparation for sharing the storage for / deduplicating
compound page metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 74 +++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 68b5591a69fe..79f3b38afeca 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6557,6 +6557,46 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
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
@@ -6585,39 +6625,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
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

