Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770466D11
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:05 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIawXD007626;
	Thu, 17 Jun 2021 18:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=VRH7+xHH70/n+QPNEPTu6FTZAS/XG+3Wl5/s+YYdgVU=;
 b=t8i7X8jo1KSljhOFzQ76xMURwomu5CI/k8jRO6oQNaYxrTtvBPiOBiMDBO3xEC+YEMka
 kHmyYyrdKkCfjsle+7/APlUc5JkEmd1Rp0tHiHuc+eEMc659pJ+qtlBJ8Od6krUqQF6N
 AoYAjLzPiivJQlPu7TIfBNiQjMnBY+0Nfk5jf3iHfaaop9Tz2R4MUmmXz6KHt45b+lZs
 W2m9cLShcMioQeyB/VX6p4qi8ua/2dhXfY+mGt3TeuoszVC/jnqgr7HdsTKpr9/zEyag
 K8FWrrbiIG4zK2kRsJ4YvY7pQTTs3MNCK6E5X65kQQhUA1TIQttdu6ADfhoN0PVgkvAL Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 397w1y1r64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjaO7180356;
	Thu, 17 Jun 2021 18:45:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by userp3020.oracle.com with ESMTP id 396waxy5wg-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ws2J1YJGkhWSC0GwxTJl8F6zXctXHSvWtX8QFx7dShGIp6whnXg+eQ0ifcKeyoropHGp8hVdp48Jkom8YkV8wWsmRq9rizLheI1NxpfW7I/d1CGRHr8qD7TqD9ab2XXgxQ6EC59t3f+fJpJbq/SisAmQqiwwIkz4IZAMIP0deRgdaNfU14LuRz0wA8WzYmm1BNvDfb54spp2jDDSVOThX55pQFQoRQ/n9g2NIZO64eB24UHSRkES+uH90Wcesawoz4lWoHmneZxxZ6W9wdDvmE1bqYlQx3avMEbqRHPwDEMQA2WHhe6QjPssNNLFiG9eWi16OblPSK9tLB71SrPVnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRH7+xHH70/n+QPNEPTu6FTZAS/XG+3Wl5/s+YYdgVU=;
 b=I4nCPRnU0TYi/CDK3jk1NuQB5VcZs5LvCcu9aj7tEfR4chjWy+ruAuj64L8P3LMAYq6G9qWKR8mGk7MGEPqU0mjqHLUNu5UTR1pOnFutJnpNiuea0rc+XKAzrXOc/rCc0Newmh+IcvyhBPL1vu5KmyxbtlAo9nwrnHkrDBq7lvwaJNhiYplaymQt+dltpJejY0VnpkHh7xq/KgMPRrFhm24NVw9XTN8NKpXg9w9E9lh+m5i0BNp3/2QCmwXsnjzBNXFhBk6qMXhF36r0kVW8sGYaOsdF3mBbvvrb3c4+oSyCpnXYdxQUchGBihXzQFvTiWZYd6Bu/jYlEj9royQfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRH7+xHH70/n+QPNEPTu6FTZAS/XG+3Wl5/s+YYdgVU=;
 b=eXhOAoq+Vn3DkMMvMEqOMlW3jtsDFDZJ6/Z6FTEDAKfcx80FEMWA/4fLKqicqZHW3E2bcJ024u+UbODPP9CT/yWIC9e5zeR43YTg/smuLAOtHDOan8918BA7jTrIk6Jgklscf2H3+AEHmfqt8dsWqCHvH60eX1S+/2l+WWmZLX8=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 18:45:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:32 +0000
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
Subject: [PATCH v2 03/14] mm/page_alloc: refactor memmap_init_zone_device() page init
Date: Thu, 17 Jun 2021 19:44:56 +0100
Message-Id: <20210617184507.3662-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210617184507.3662-1-joao.m.martins@oracle.com>
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c680f4e4-fc8e-42e3-7c0f-08d931c015df
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB485264173806BB3E44B70664BB0E9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UuJgS1vBlE8aWss5DWZZkbEEhYPbBJM6eIZtIUl5UWeMoTQIOSwfaQ18yqKbO3zlvzf1ALADmswGTAEb7hBtioWHRpmYiBXbhqhi+pe8/Y+F/o2V7shuWTYwvDsotMD95ZE5C0BRQbu8jNTFJYIe7t+OgV9pMGhLnUqLMBx+7ZeBIyWnzbj+UDQb654AbCu2AppE7bxaOSQyVcFA83vh/89JjUHwa1MeS+tcLHsY58m2m/hS1hvhSyIRCfRBfiGctLvV80ITC+QdVaCH/QBj+InwJ0D/zWfpe0TFBLWDS/i+dzpsh+qqQ1q3g+ho1xfSfp+2v7tbxq66lc1fH0CFlNjjNkNbA7ccKzVyn+u0UeYq/TtzaUM0u9l98oPplb69TN0gkOaJ/dofgmXSD0QfOwz14czusppeZ46p0KNoCgVoNDn6/JQwzWZ4hJPf58GXjVhILOvnzMQE7j3Fl0TmQqbGcaOHPnV3Qcrovwldkj1Rve13U/URpVcUpxeEqhnSurVyg2SI3WLDgZx6gBcJeeBd0UowkrxQp4GvBLfd2uGvF9Ufm8zuL2cbrbHMM2vYvaNRo9Dh4ZU7ea2ij5wIoNRrPh+LbYS3UnOKsLL+1mybz+TEu9O1qoQCrMD137Wl8zLg7MnufRHULxIurNi4Bw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(83380400001)(6666004)(38350700002)(4326008)(103116003)(7696005)(5660300002)(186003)(16526019)(26005)(54906003)(478600001)(38100700002)(316002)(107886003)(1076003)(52116002)(8936002)(66476007)(66946007)(66556008)(36756003)(6486002)(6916009)(2906002)(86362001)(7416002)(8676002)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?QzOp0MZwztt1B9ZsT1H8jJBimxSdcKyQRmilaEaszeG47hXbOeCpxSkDSE7y?=
 =?us-ascii?Q?ly89E2jFKYoQ6IUK20IoVhypAfkKUohTI7t+m7ejsZrJPgjwMi7v6dzv2mnk?=
 =?us-ascii?Q?cTzTCgtkjqaLslnytkK3KtY8MLQ9e9n/7xW61QoUlyR9F4t7IwVs1OUY0Huf?=
 =?us-ascii?Q?F56gRbxaHQsUvEK9VYSmxqSOCbXTW7DVp3i1XCWjmK2URf/dsPEkJNJKPhJm?=
 =?us-ascii?Q?4PfNq0VOkgwYdHx/sjuD8li6XdDi2+BwRlACbxQ66Wfa9H4HLkZSabkPrRHl?=
 =?us-ascii?Q?2JiV2l/1XAFsdhHkTJLFePS93RW127zQu4yrI6v9ygRW3ZyzE1O+KzNB6PhH?=
 =?us-ascii?Q?mBHMalFo/6a+g5OeMwR5j4YbS1+9cWxmOm0kzNyyJxu1EWjL/YDVBXIGp1lp?=
 =?us-ascii?Q?tm8LQOpa50sih6/b2wr7hkTboMAoIF/Nxm+jHfuz5sheW0BKoICtRPECoeN4?=
 =?us-ascii?Q?P0ZHgnh+JrDOpq4Hdt15uYlvOHWPjrSwXdAJjo4nosBJ8W17JUd39UOGpZ0c?=
 =?us-ascii?Q?5FJIc/fVN4pKEF6JmVrxbZykVZTDR1e+UGhgZd7ikOuCf6p0VMP1+SQOFY2t?=
 =?us-ascii?Q?PNy0mnvLVzScJXJ/7H+PsX4ZmsGHnNPQ2jXetqCofPgB8V1ovRlJT793llBU?=
 =?us-ascii?Q?4YmrOaHRI5pEvHejx5/C7mn0wcEhsS2tPNpjtIl5Mpomup2SqubYNsEobZrl?=
 =?us-ascii?Q?xvwnEVMNOgOk0F+87XiHPlicsWY4uglhaC2B735TWgigQTy9wxgFiMwgQNeC?=
 =?us-ascii?Q?zGYHFtM6F+k35OXAg8q90pmj8fKq1AJp9NTLishJtXjAbIHmnqCWJLp29LVK?=
 =?us-ascii?Q?lhq7aRHn/qAw/93QYGgGRtxx2KwzOpACcx9G5y9MKnIojOGtClw9UDZXx6xS?=
 =?us-ascii?Q?jVc0K66Bne/frnL9nCu39fkP4yUWHyWKVhhBlBsFA766XSktdIXai2dq0fRX?=
 =?us-ascii?Q?2Vt6V2pzMMUOiQQeyMYmIBweeV5V1aGJJpjO6SGEEjAQE+M9RuX9xxKxS5q2?=
 =?us-ascii?Q?ysoiZDzAHR8TIT7jWcaXuavVVknA8gAh118B9nGI4sZXJS29UIaIcgHO/eGr?=
 =?us-ascii?Q?a+bRytKCcMF/1J9289JV0Eszt2ABz94VD6onc9/QiLBXRJTTPluJc1AZZ3hd?=
 =?us-ascii?Q?in2L2tpIER0iYCc3FC/5+hqqW0QaAZ31B+jqkVL/mKW8epGWIFG17/48rZOK?=
 =?us-ascii?Q?lPGrptulEpNnqHHirRlrNlcoLzOPGw/b42y/dqo2q44HnItitnXdcYjDjlzr?=
 =?us-ascii?Q?9XGboosN0Wymgy6xm00HhH4nb1p00nvHntD1p1xYByk+BZoS/XILOF/OpDvL?=
 =?us-ascii?Q?Vz/HwUq2p6WJLvMqOu/szRrb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c680f4e4-fc8e-42e3-7c0f-08d931c015df
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:32.1578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ir2Ezy5L0CawABvTIqf6M5YBzVrUSqfiwICgDFBFVF6W7ws8m9mRfxdlzSL9Dkl5WG3WJ56f0kzxvJckm5xUKLwZ2I4RHUDL+uGucJZ4gF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: UREPtd2OYLFeuVk7yBYV7mQ3-k4uXE-Q
X-Proofpoint-GUID: UREPtd2OYLFeuVk7yBYV7mQ3-k4uXE-Q

Move struct page init to an helper function __init_zone_device_page().

This is in preparation for sharing the storage for / deduplicating
compound page metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 74 +++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 95967ce55829..1264c025becb 100644
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
2.17.1

