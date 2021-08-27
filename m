Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621973FD0
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:31 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWHDH002206;
	Fri, 27 Aug 2021 14:59:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vAhtJAv1Ep8TEn/uiSYFII5C86zN825jI8yYzbOwAOM=;
 b=NnPNeTvAD1WjGZBkTFK54tKLTUyjuBB1DbSQiZYk5CgEhOtjJgYo5hE/f6TmWPQ0JL5D
 /frXQaHqVBO53QLkYKRg1UrbWJMM0MWBoZOJZqE6kgjqTsMUNpKhowuMstm4cQITSxy1
 ZN6WBsU6yMmbj0x1EawpUqdlgVqO3cGQzyYuTp2dGS6wbF3W5VkinfMyY8/RpHItY51s
 cS1XIvFmJ1sFOpE7GggK3ZzswB7FO58xZXTOhOvpfTt5A4pXX44uoxzpqu5nBHyuLpWq
 B4ouIub3eWq4F7noCIVTogCFt3SMcDOTtkZaRfE2wIHShA/ZIlSXK02Kkc+B8CdHNsEN Mg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vAhtJAv1Ep8TEn/uiSYFII5C86zN825jI8yYzbOwAOM=;
 b=k5xzmkgptY6eoVhkw+FeVGE9Xmzvx0XmaB92JPG/n1urUt4VE/XKlHOY5/8zAs5BS3F5
 /CWij4ZbQwesS0By6viQBDdgC5tko41elbxkNBiFvW71JeAtv1qpyyUd4f/+tJPWwnTD
 A3vbX08rcjQ3KO8RzemhQRE3xCCmYqhYuwmmKExmHnQG3kpRSGrGGfVjg4wOqytIsmFm
 RmNdTZMCqD7XWoNHqAdknDyfLpBFdekSVqn72MEPOv0H7LMBiCyF5FWubm3LoX+OYiLu
 9O/GWYE2Gse9IwWOwOGOhjj/2gbnKuafMtMTjbizbARO/hjQEuWLRn/2KLqQ4A5wLQ+e Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr0vj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpP1T187148;
	Fri, 27 Aug 2021 14:59:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by aserp3020.oracle.com with ESMTP id 3ajsabbqt0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7AhMQ50vTM9l4ldxLlWlQiTRyorHsxUDyYDVZPpsIGCByaQm8OSx78AybFTtdRx9vR0jw4zgqU2hulH4+DDG0YmB68+oZqzB1GpQ2Rsyhp6rJiOUfOKtd60ut3Az+cwUJhaR9UZV6NXQpDPFir67XwgcBl0WbsZ4ihzzW3XZQLLgJpkAo6yzhA2JVNtOLztA2fyowbeLjkF6tslOE3d9NPWR6MPt6k89EmNk6ZjdIcmQwCK1Rkw78JHYiBPdSs4X6pc9CmkWW+ZIS9l9RlJVoIAmn50kAa9yDWZYWOF2NQzuetj4OxsQoffw//E3Re2wiYgqMGyZvYN2+/IlOMBhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAhtJAv1Ep8TEn/uiSYFII5C86zN825jI8yYzbOwAOM=;
 b=BKfUOVUanZhdTMH5OJ7KOhsPSy01qGVj6k+D/YCFT35YbMZUY7gkIkOdm1AvJaKusfiTbWI9soCP83ZhHQZyicbOnXRBD4XJdJUTtoHJUP/k2tX0JRx/EyIlm3khNGQeWTNOk5hJZK1aVe6Y80iklyd/IQ88fcUFZz+SpW5FHwRjUXb6BATtO42bDmHo8vKFP1/WoZuh/XwnRFI8PxTttaNtj0BZ/iQjbTV2eW1CXDMWCf0qaI8OdfbpPLxt6huKfZDwoWwV2RONCj4YKMhed+zwsWTb8gRC5AozgF4UwFrgsFsqltD+XVDAhljPoGK3gYTh13sFYoM1Brlr53T/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAhtJAv1Ep8TEn/uiSYFII5C86zN825jI8yYzbOwAOM=;
 b=d8KpFDJPxyY3z5cT7C0/4r8DvRlgW2qyUd8RV9RQ6QrTc6Q5cwk01e7dspdr6lyxrxNPVfT6PjR/+4H/pTwM1flg8lo0VuFwrGdlDLC4Lt++poqGBHEISrZpyy2W4aEtCwsNg8qtEO01+VLq9M3TQeu1HA8aUlDoqHiOUWOm92g=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4946.namprd10.prod.outlook.com (2603:10b6:208:323::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 14:59:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:19 +0000
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
Subject: [PATCH v4 12/14] mm/sparse-vmemmap: populate compound devmaps
Date: Fri, 27 Aug 2021 15:58:17 +0100
Message-Id: <20210827145819.16471-13-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:59:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b3aad28-e758-41f6-9e03-08d9696b3f1b
X-MS-TrafficTypeDiagnostic: BLAPR10MB4946:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4946398C835CD4CFA178AF52BBC89@BLAPR10MB4946.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bo8OaTPUht27kA74sk6Lp9dhdr+Ja3YxNS9mRbcv6j6gUq1Ql5RwRXN9hTqU8g68tlOiiplRw7OkzXFliF7QPiKLSiI4MrR/i8D6darLSXcWKKuguNPZGWBzLu2k+Xkc6KCxw8MpTe3rGGcVrNid3xASuPJbQaYE/X/18UuscTD0aDLOYA8fddUcTzkxQ6hMQVUBXOE1OZWRR9loOUjbSQW5VE7h0slEXP9fyFUPHFgaTGXzLLxAG4/Swn7uD8FckSgG1kjGCS7IAJAoj0KDbWO9Pc6TB5Q5FICyrypfbqALkSLtqUNrk7vipw3YThaan0xgba69iuKtMS04O9NiQgpK6oe16x0nVJYmiXSRaSlEuXlUGQp1RHEp6yCTRKTqSyly0zxt+fRVj0huwL/GO4SXkGIJksRQYv3TBdMEap9BBjAQABrjqKh42anmG1lWmVTr45SRmpArgNKBPpNnZ9m67dEWCBV4XBpyUfYvzpNpHl2MwNmj+SWmhrdgfRhSkK02d0PEHqSPcwDBKMR9UxaS3QCyXXm2tKkn7oZBkWTcHhhtlbE1JvEx/TAYpr9bYrYkJ2P9U7yl/OdbAh72gdlV5yq37ojbuIRDHjxA9mruzpD8CpbqHU/9kz68DWesxaupTtrwuWywbbKU1Q/9y04yiLQy+8Vg4sKvXo71uesyKEfJ0KKls29x0kYh+OupEiFAMHWjNWFFXSeEhEgBqDmyIAJceJX8FYMWQBpDDII=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(396003)(366004)(316002)(86362001)(1076003)(2906002)(7416002)(107886003)(8936002)(66476007)(66556008)(186003)(66946007)(478600001)(38350700002)(36756003)(4326008)(7696005)(2616005)(8676002)(5660300002)(52116002)(956004)(103116003)(6486002)(38100700002)(6916009)(26005)(54906003)(83380400001)(334744004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?rdAwp7V+rvDVyc6WAC4OrcQ3PH/RykiEXZ22Sr2g6LEDN1w3cIRF4JlJZimL?=
 =?us-ascii?Q?2t3TlZ4DKGDEBTIh6R5pWz/BCilRbS3c1nCr4z1Q742V0fjkJUe6cDV3sd2X?=
 =?us-ascii?Q?6iz0ld4QiX4AM4KYUVZykfCbQCff4sz6EdE0lP/xOWJsFuhTfPDiR2f52Q16?=
 =?us-ascii?Q?SiPWiIGmKDvZqnrs6xvmcPd8JVkDS3ywOIhvbP0tYV9cv1EPAXFd4tlP97zO?=
 =?us-ascii?Q?EMRlEIeR8Z+AAqIODfFizIBM822FoHKeLzyVxr3uIAyX2U2TQK8qhl/JNJri?=
 =?us-ascii?Q?lpMg60cV+M7sE7DQF4YgbsVCYWVnzcR5UuFAS23QpQaflH7tQiD/acOSPjJK?=
 =?us-ascii?Q?DcdbHoL0PhU6ZU6z5h1ltaaSa6ipHbg18b0JPloJPDvFr2X4rhWsO0AsQI00?=
 =?us-ascii?Q?kCPRDVjstlC4+pSN9HbnGKZ6vtYhPzRcZhVE8B751CKPh5mnDYmzXc5wfq9i?=
 =?us-ascii?Q?abRssI62QtcbvEYDFETYqMBmeksVu0jQs56z0tC5bBAIfrAe5Q7gMsuDtHW0?=
 =?us-ascii?Q?95n7zCmAvFKJsx04JVsLByjYcdhaCeBcPpZyqBSF/JLYOumLgPPhgIGYty0O?=
 =?us-ascii?Q?EphGPe86vx6PT6EN9qyGG0cIHVEneO0bSTBi8r2xrLDZ6DhYgpoV+FM1U2F0?=
 =?us-ascii?Q?3NDQv4yQnvPT13Z/qTDLIRrtd6mCPrjWXvwge13Cpw8+r4fC5KRn1Qj2g4Ly?=
 =?us-ascii?Q?HZlESWSpeE9WnnpuV8Qs08pTPpiZcwhVo8/QWZDluGNHmSZt9+z8ndq4/E/P?=
 =?us-ascii?Q?5kUlX3llZ+YvSoBTqYhzieRZyqxctBWiPfBBiw7Bg54AjQ3RXcTiq7cyPF/L?=
 =?us-ascii?Q?DGwQt/qhlqfCE8kUuLsn8y1GtTPD2Hb3XWMdA7ZnzvMI3wnGvv852xRur+Wj?=
 =?us-ascii?Q?81QS2BZvHK42an8pCB8Qr9lRl9zBQkUKM3/M+NuhLewuFYs6Vl/tdDrRAp+V?=
 =?us-ascii?Q?XfpG9J139KqO+2H0Qz/HLcOhJ345hu1yjfczdK3Yv9l5MzAaxXHOcC4HU5+a?=
 =?us-ascii?Q?pdENa23LmMxJbABkRVMriPlimqCrG+l2zEjKetpkAntiRnbS7JKGB7FtAy9P?=
 =?us-ascii?Q?mkqJ8cOW2Q+QZq2fKZQGkwVIeu2L+6ZD3c0F6k5BP19Jow5dVtxjmxXOZhdk?=
 =?us-ascii?Q?6PESReDv9jGcl2SKIlsvwIM0in6O59bs6wgLYllcZvIxsvbf3OZN+jQZtmup?=
 =?us-ascii?Q?69KilVg1t6Ar2Z3N9QXDnur3qZVwV1X1OzY43tMGzeYb9M93GAqR2CqOsZbW?=
 =?us-ascii?Q?sww4T8wjWCYq5L8W6oIahPvy4LrEe6Q+tZ+skywpJLR7j+KqmXBXeCf0zzVt?=
 =?us-ascii?Q?c/Iwqgpfw7+h8fo4rLGty8+N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3aad28-e758-41f6-9e03-08d9696b3f1b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:19.3326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/vEcUDS3YgVKdfxSdMmrNbdZzxj6++wlxgBCR0myY+TF0Z3UUJnIbUiS7DAXeXDlfAwVhzNFUVJgiNFh2dVsHk+ddVh1eUju5jymiN55mA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4946
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270092
X-Proofpoint-GUID: uiTuuas6BCndbBl9g2c3Uig-rb87hsgZ
X-Proofpoint-ORIG-GUID: uiTuuas6BCndbBl9g2c3Uig-rb87hsgZ

A compound devmap is a dev_pagemap with @geometry > PAGE_SIZE and it
means that pages are mapped at a given huge page alignment and utilize
uses compound pages as opposed to order-0 pages.

Take advantage of the fact that most tail pages look the same (except
the first two) to minimize struct page overhead. Allocate a separate
page for the vmemmap area which contains the head page and separate for
the next 64 pages. The rest of the subsections then reuse this tail
vmemmap page to initialize the rest of the tail pages.

Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
when initializing compound devmap with big enough @geometry (e.g. 1G
PUD) it may cross multiple sections. The vmemmap code needs to consult
@pgmap so that multiple sections that all map the same tail data can
refer back to the first copy of that data for a given gigantic page.

On compound devmaps with 2M align, this mechanism lets 6 pages be
saved out of the 8 necessary PFNs necessary to set the subsection's
512 struct pages being mapped. On a 1G compound devmap it saves
4094 pages.

Altmap isn't supported yet, given various restrictions in altmap pfn
allocator, thus fallback to the already in use vmemmap_populate().  It
is worth noting that altmap for devmap mappings was there to relieve the
pressure of inordinate amounts of memmap space to map terabytes of pmem.
With compound pages the motivation for altmaps for pmem gets reduced.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 Documentation/vm/vmemmap_dedup.rst |  27 +++++-
 include/linux/mm.h                 |   2 +-
 mm/memremap.c                      |   1 +
 mm/sparse-vmemmap.c                | 150 +++++++++++++++++++++++++++--
 4 files changed, 168 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index 215ae2ef3bce..faac78bef01c 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -2,9 +2,12 @@
 
 .. _vmemmap_dedup:
 
-==================================
-Free some vmemmap pages of HugeTLB
-==================================
+=========================================
+A vmemmap diet for HugeTLB and Device DAX
+=========================================
+
+HugeTLB
+=======
 
 The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
@@ -168,3 +171,21 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
 (last) level. So this type of HugeTLB page can be optimized only when its
 size of the struct page structs is greater than 2 pages.
 
+Device DAX
+==========
+
+The device-dax interface uses the same tail deduplication technique explained
+in the previous chapter, except when used with the vmemmap in the device (altmap).
+
+The differences with HugeTLB are relatively minor.
+
+The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
+PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
+
+There's no remapping of vmemmap given that device-dax memory is not part of
+System RAM ranges initialized at boot, hence the tail deduplication happens
+at a later stage when we populate the sections.
+
+It only use 3 page structs for storing all information as opposed
+to 4 on HugeTLB pages. This does not affect memory savings between both.
+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4fca4942c0ab..77eaeae497f9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3174,7 +3174,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *block);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memremap.c b/mm/memremap.c
index 99646082436f..0d4c98722c12 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -338,6 +338,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 58e8e77bd5b5..441bb95edd68 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -495,16 +495,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap)
+				       struct vmem_altmap *altmap,
+				       struct page *block)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
 		void *p;
 
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-		if (!p)
-			return NULL;
+		if (!block) {
+			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			if (!p)
+				return NULL;
+		} else {
+			/*
+			 * When a PTE/PMD entry is freed from the init_mm
+			 * there's a a free_pages() call to this page allocated
+			 * above. Thus this get_page() is paired with the
+			 * put_page_testzero() on the freeing path.
+			 * This can only called by certain ZONE_DEVICE path,
+			 * and through vmemmap_populate_compound_pages() when
+			 * slab is available.
+			 */
+			get_page(block);
+			p = page_to_virt(block);
+		}
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -571,7 +586,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static int __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse, struct page **page)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -591,11 +607,13 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return -ENOMEM;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return -ENOMEM;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
+	if (page)
+		*page = pte_page(*pte);
 	return 0;
 }
 
@@ -606,10 +624,120 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	int rc;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		rc = vmemmap_populate_address(addr, node, altmap);
+		rc = vmemmap_populate_address(addr, node, altmap, NULL, NULL);
 		if (rc)
 			return rc;
+	}
+
+	return 0;
+}
+
+static int __meminit vmemmap_populate_range(unsigned long start,
+					    unsigned long end,
+					    int node, struct page *page)
+{
+	unsigned long addr = start;
+	int rc;
 
+	for (; addr < end; addr += PAGE_SIZE) {
+		rc = vmemmap_populate_address(addr, node, NULL, page, NULL);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
+						  struct page **page)
+{
+	return vmemmap_populate_address(addr, node, NULL, NULL, page);
+}
+
+/*
+ * For compound pages bigger than section size (e.g. x86 1G compound
+ * pages with 2M subsection size) fill the rest of sections as tail
+ * pages.
+ *
+ * Note that memremap_pages() resets @nr_range value and will increment
+ * it after each range successful onlining. Thus the value or @nr_range
+ * at section memmap populate corresponds to the in-progress range
+ * being onlined here.
+ */
+static bool __meminit reuse_compound_section(unsigned long start_pfn,
+					     struct dev_pagemap *pgmap)
+{
+	unsigned long geometry = pgmap_geometry(pgmap);
+	unsigned long offset = start_pfn -
+		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+	return !IS_ALIGNED(offset, geometry) && geometry > PAGES_PER_SUBSECTION;
+}
+
+static struct page * __meminit compound_section_tail_page(unsigned long addr)
+{
+	pte_t *ptep;
+
+	addr -= PAGE_SIZE;
+
+	/*
+	 * Assuming sections are populated sequentially, the previous section's
+	 * page data can be reused.
+	 */
+	ptep = pte_offset_kernel(pmd_off_k(addr), addr);
+	if (!ptep)
+		return NULL;
+
+	return pte_page(*ptep);
+}
+
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
+{
+	unsigned long size, addr;
+
+	if (reuse_compound_section(start_pfn, pgmap)) {
+		struct page *page;
+
+		page = compound_section_tail_page(start);
+		if (!page)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the page that was populated in the prior iteration
+		 * with just tail struct pages.
+		 */
+		return vmemmap_populate_range(start, end, node, page);
+	}
+
+	size = min(end - start, pgmap_geometry(pgmap) * sizeof(struct page));
+	for (addr = start; addr < end; addr += size) {
+		unsigned long next = addr, last = addr + size;
+		struct page *block;
+		int rc;
+
+		/* Populate the head page vmemmap page */
+		rc = vmemmap_populate_page(addr, node, NULL);
+		if (rc)
+			return rc;
+
+		/* Populate the tail pages vmemmap page */
+		block = NULL;
+		next = addr + PAGE_SIZE;
+		rc = vmemmap_populate_page(next, node, &block);
+		if (rc)
+			return rc;
+
+		/*
+		 * Reuse the previous page for the rest of tail pages
+		 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+		 */
+		next += PAGE_SIZE;
+		rc = vmemmap_populate_range(next, last, node, block);
+		if (rc)
+			return rc;
 	}
 
 	return 0;
@@ -621,12 +749,18 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (pgmap_geometry(pgmap) > 1 && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.17.1

