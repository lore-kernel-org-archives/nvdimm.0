Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91C62C83
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:41 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACEgY3v005379;
	Fri, 12 Nov 2021 15:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Xce7fuO8ugtcHQyaqzDt+3x29zeBRhwbNDjHZ/Fbtqs=;
 b=Qxb6X0SgM6qF90FZBoZ61PxOhnmRWO0y2Mec8e1wolAtzL2CAYIHYp358TmhENSdWbKh
 vv24RkOz20YoRjO0a3i/irOvHLvHla4yds/wp8VqF59abuCeljsg+4jp3jczKrAXdkCq
 QyvXWEeTKD+gvopmLw7PLCZp29tDvdSrNGWUoUyxNOn4B1mejcgYOxKo/l2eceokJvEF
 uaajMbp5JkJ1XQ9SUBaQiugMsn3IOGcIC8pQazNt59SL62BLRPb1AkLDkHiPFRMD6r2j
 tCGUsZLIO/+rtQbWALofRYQm9qcLdpSquTBZvC6dGc7TisYionBPyOUs6KOI8HUVYazJ qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9ruc8k16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF6S9H104501;
	Fri, 12 Nov 2021 15:09:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by aserp3020.oracle.com with ESMTP id 3c5hh87m5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZT4QuYtV7+q6oVRacYy2cESAKpW3KFlmWUkTg29GYxPwdIj+D/BiwpjTSGxBjs2mzvR16Qb7GT19dKjNGrVAMYMWjKa1m2+z6KYyfET93xCNf50hNkbpY/OcVejs/wtF6e0CJq20rh9aaxtGMk0AelPty5Y+qbwcL9CfjVKiSjsaZJXDwlB1UPs7SmF90CtnTT4Y/au8Ww7S31e/Px+TyX7XoDpkhaEQEdi86Q6vfvus0FUPUjMtE65PQvjXQJiIVHQlOWhqt8vABXTPawUvAJdRIOq2RlNpgDK7j16I8q90ehTh8vH8YLhnUoeuqFmkS51r+BRMeOEQBbzvoZPzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xce7fuO8ugtcHQyaqzDt+3x29zeBRhwbNDjHZ/Fbtqs=;
 b=N6CqULY8ZDO0uVaQNSxWjDCfrNCTw78f5U+Aed8HTiaGuIZuMpOyaOxcnZS4mEJZDBdE7XNRyeSvNpbNQplpB6ULDVDqnXJIgWy2tk9R+PVQWUcQSyYPYs8P8QAJc1HZc3VoZC8azZXwXeMJlo3Cf1QUy4ac4Tt0ulut6LQ84QcKSyKAfI/zCVYaDKGJwdfY3AiNN7JC5pqjkbhdYgkrq8B001ofQK4y/jvlbxBjGGEeVedZ8XUvs4U73TAw7fapj0TW7RDzax0b0MPUmRiYX1Or/w/MYnWh9Zgk6uImiUr0aNknWpVDyYzgYGKDdyg3kSoVVwaf1HkXm5J0SJq6mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xce7fuO8ugtcHQyaqzDt+3x29zeBRhwbNDjHZ/Fbtqs=;
 b=A/XWoa3L9WmuiUo+mREP86AbrMN7wnvgDAeVi5mObpr//tI3zEAZnbxWVGPBfxtUSQy8oQ3AJhPuZr1kVxI/6UBfVBFvR46do/dB74ny8cfNUXK1Y5kpykdZuohquw/ZUVHV1mfWb7fclwQflxWSKTDZwpM6E7gyy97b023eayU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2916.namprd10.prod.outlook.com (2603:10b6:208:77::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Fri, 12 Nov
 2021 15:09:28 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:09:28 +0000
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
Subject: [PATCH v5 8/8] device-dax: compound devmap support
Date: Fri, 12 Nov 2021 16:08:24 +0100
Message-Id: <20211112150824.11028-9-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:09:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 159c9a54-3c35-4223-c21e-08d9a5ee6bb7
X-MS-TrafficTypeDiagnostic: BL0PR10MB2916:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB291631178D6EECFA4504157DBB959@BL0PR10MB2916.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EXiymA5Pb3qM74lSKasX/BcsP9zZbkvPuXg3SdTTP9Ol0vyZP0ZwLz0JdtxQbRFuzYjvGwxl20BpdwbLgPY4PpZq1n4hZfltdH2nDHQ46hJv9DuZx8z7JlEqX0OSnBSjGo1c0BI0jyWuzVJ/5Lm5qR/g9HbS5DsmI8UB4QuyPdsIy4AoQniP0eHGuwNL8SsMZpQUGLsNhSWL5bfPO3WiiscBRMDpVaxyIPvQvDYhERpf25vPOYTGtc9dwi1zLWBdY1z9Z+ZDSPKYI0/GL+JzZwnOyJTz7fUfkK4tw46T9G+GPFh6L0T5dOJ9qlj2wdoRzy6QhLAi4WiLeAkjy8LBoEhmp9D49uCG+bS/2irm1RzDz0uHW/Hz4d85nJzxEyWT6v+TUkA5sVM7hXxvwuw1erubLp48d1AfmL7ZnWTc9fgDr1KsWSUFkEhukQcL/dgy1e/S9peTJFg1NXnZ2uv4WTcvlug4eQFNd8pkCUW1lqmfafyqqRRJd4cjzXbT67Tq8F5cPWO9m+QdTY0dk0xctKM9kcBm84RvK0GKEd4ANt+sF0HQPKmBMje+pgBMxRfxIaOUMOT6iUS7rk+aTwRQqQgprYMPoRzRhyHp4uVUTsOf/NP9AxgQ3nm/rYjn8DyDJ1wKxjwzIRK39o7BlquGN0i2lkyhJewWfCIwT59INMLQxprNiKp12+JUtwCpSLbvEMm4FQGhTlYT0ER1Mk8KgSQTyAGBowF8tlDKyn4GL0OIpr49MvEmvDlhYLQSEe1c1OLIl16451tRCxNAqCBCL9o44RUrDOKC2TywFbxkOWY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(103116003)(316002)(2616005)(7416002)(54906003)(2906002)(38350700002)(7696005)(1076003)(38100700002)(8936002)(83380400001)(52116002)(66476007)(66556008)(66946007)(5660300002)(6916009)(26005)(8676002)(36756003)(107886003)(6486002)(86362001)(508600001)(186003)(966005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?H9oJGCl47LzbNReuERULlUcAl2OG3WiCGnOJd7rjQVqwOrCLbmEoBzO5DlCQ?=
 =?us-ascii?Q?5+/Z65FLO6Y13jZ5yWJdW5zg7Jpb8MDF5EuYfMpJBtvCeW3+fZp6FpFGbziA?=
 =?us-ascii?Q?PsgnqxxtITSVhk446IHkTNMHALYeuXHFxvyC2drJVUVcGyhnrgTQPRPgoWyt?=
 =?us-ascii?Q?RnptCCONd7qiyxMy6ROH6C1ql/a4eltl321Hmn1FNC8K+FNTD44ILxRxY/5R?=
 =?us-ascii?Q?0/V6lqpB/6V5AxjV2o5I4MzyJlJJMkcpAclv4hUudr51ISY/QSDWxweT+Gwr?=
 =?us-ascii?Q?zGSWk3PbpY9IfOmcss5rEybbayoADhwllGcFLdKVcUtZZmJGtMIYzqrAQ2hq?=
 =?us-ascii?Q?ILyrYoZVkncD9kOjDV+X1qxMIByfkCFlYNYb1IaqvSNuN1Bbq+StPdU5xLNA?=
 =?us-ascii?Q?tKa96T54Li4PGKcwJwvmKeTKKaS3O5ZjtcOGfKpN71VLgViHxv2f462A74sk?=
 =?us-ascii?Q?OAU6UrOMg8cKOlMu4A/iZueYLnH6bHWMWDAJNalVRExFHKOPjag9IPSpGQ0c?=
 =?us-ascii?Q?TckxUrbddUdwDExVaoaoSB3/WZ2C+FVpbu1JG7LReCGQb68f02MFfWXC3yEg?=
 =?us-ascii?Q?u55e2vemOsA8dJMEsv+2nO3iAeCPgKmXTU8aGS3R9g+7Lu845/j8qRpQeY2i?=
 =?us-ascii?Q?FdaOjb3HhxGEgGZRn7dzKdinweTy+rCkUSdEPkN8eqF6nG68bFXru9qmwkmh?=
 =?us-ascii?Q?9pBohjf9E76o+pH5MBuTp/ZJjV+FAs9PtgSbS/uy3FLqA5vkR8QFCHLToUGM?=
 =?us-ascii?Q?oicbcQcaLvDSB94x+wJGEdReLRo1hpR9IKwFgFe0s9LqqqGHz0h/MvseuSrA?=
 =?us-ascii?Q?R7Ls27i+I72oPf5esCspuHg0K3w1AgH8ebLAP+g6k/0jvz+wbNOjZkHiO0Rh?=
 =?us-ascii?Q?tHa37dP5z5MvJfUn63JLU+3ysx74WMJoLZy7pQqELfBbX27RBuIimgGSqgEM?=
 =?us-ascii?Q?DbjEU4wic6Goyl4JnHfwNlmwijt82wT3AFaW2yvj9yvgjNZIysuBYRhfnTfO?=
 =?us-ascii?Q?JaD1BFHIxB68OQ12jYv5m+Nd06rcxXRmPZ4yzwJFPDUSlRa5hWatiTzcCZlJ?=
 =?us-ascii?Q?1S/F0wl8Tr9PtcLLeYt7s7pJpaN9nl8K4vNan1FmngkjYzp8BRMTdsldZuAh?=
 =?us-ascii?Q?k9v0dJeu5XE68iKHqk9Q5yR6YkBydkmJIp3t2E6ugHj+RYynEtB6guJ7rboA?=
 =?us-ascii?Q?gfcmHk6Ta6S1qejsqdW8ba335/7h8FfOWxGK1A8Gl6G3gglHRYdZHIPraTeR?=
 =?us-ascii?Q?C8jsk7aP3YkdK3pTezx3y+FPHRrWzGR0KPvvf1BZG1cj/ANO5KI6uVqLWugI?=
 =?us-ascii?Q?tqK8VqNHCCqTd6Aj9FhYNQQpmdndu7OsHlsO1E+7hNxjHGrieLlrZDKGAnqC?=
 =?us-ascii?Q?UMLWayPQklw6nGZiiqFnG2LL8VGa60+/O56iQgj2TQJKgiLIiRk6PjP6LhOx?=
 =?us-ascii?Q?bZehppCC15hfB6unA7DFmj/wwlIEjx6suGkNRL7o3tHBG5yskVltaUou68oZ?=
 =?us-ascii?Q?IQjmgVuLUzLjxsp7wY+OZphcByi/kBUsdJAypKsaFVLGi0UBmFKTwyuCqKHg?=
 =?us-ascii?Q?ge6Nyv9YCxbqHxSKgjUlLSPsunqMwusvoOJJd9ZlHrZMf/MkFh3y0i/2UEoQ?=
 =?us-ascii?Q?hshh1rGLb6kX80R1ASS3ag3e1FCIVYX49P20GhCmLsZft4wYwF94mBWnQFQ7?=
 =?us-ascii?Q?J6O6Jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 159c9a54-3c35-4223-c21e-08d9a5ee6bb7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:09:28.0527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOsAEodz6w2qaJKBouH4BzLrFtEeO0Fh3PnX2Euv3h+1ra3KThNpM4w2b5qfJIGb7dbJNA+hlmkHC8ZZLhIEUTSJ71oj9DqfBLJ2UDMjiPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2916
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120087
X-Proofpoint-ORIG-GUID: 3KR7T6_ER0mVygb6tZ3CFV1lZuH7XSTn
X-Proofpoint-GUID: 3KR7T6_ER0mVygb6tZ3CFV1lZuH7XSTn

Use the newly added compound devmap facility which maps the assigned dax
ranges as compound pages at a page size of @align.

dax devices are created with a fixed @align (huge page size) which is
enforced through as well at mmap() of the device. Faults, consequently
happen too at the specified @align specified at the creation, and those
don't change throughout dax device lifetime. MCEs unmap a whole dax
huge page, as well as splits occurring at the configured page size.

Performance measured by gup_test improves considerably for
unpin_user_pages() and altmap with NVDIMMs:

$ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
[altmap]
(pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms

 $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
[altmap with -m 127004]
(pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

.. as well as unpin_user_page_range_dirty_lock() being just as effective
as THP/hugetlb[0] pages.

[0] https://lore.kernel.org/linux-mm/20210212130843.13865-5-joao.m.martins@oracle.com/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c | 57 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index a65c67ab5ee0..0c2ac97d397d 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 }
 #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
+static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
+			     unsigned long fault_size,
+			     struct address_space *f_mapping)
+{
+	unsigned long i;
+	pgoff_t pgoff;
+
+	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
+
+	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
+		struct page *page;
+
+		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+		if (page->mapping)
+			continue;
+		page->mapping = f_mapping;
+		page->index = pgoff + i;
+	}
+}
+
+static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
+				 unsigned long fault_size,
+				 struct address_space *f_mapping)
+{
+	struct page *head;
+
+	head = pfn_to_page(pfn_t_to_pfn(pfn));
+	head = compound_head(head);
+	if (head->mapping)
+		return;
+
+	head->mapping = f_mapping;
+	head->index = linear_page_index(vmf->vma,
+			ALIGN(vmf->address, fault_size));
+}
+
 static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
@@ -225,8 +261,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	}
 
 	if (rc == VM_FAULT_NOPAGE) {
-		unsigned long i;
-		pgoff_t pgoff;
+		struct dev_pagemap *pgmap = dev_dax->pgmap;
 
 		/*
 		 * In the device-dax case the only possibility for a
@@ -234,17 +269,10 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
-		pgoff = linear_page_index(vmf->vma,
-				ALIGN(vmf->address, fault_size));
-		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
-			struct page *page;
-
-			page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-			if (page->mapping)
-				continue;
-			page->mapping = filp->f_mapping;
-			page->index = pgoff + i;
-		}
+		if (pgmap->vmemmap_shift)
+			set_compound_mapping(vmf, pfn, fault_size, filp->f_mapping);
+		else
+			set_page_mapping(vmf, pfn, fault_size, filp->f_mapping);
 	}
 	dax_read_unlock(id);
 
@@ -439,6 +467,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	if (dev_dax->align > PAGE_SIZE)
+		pgmap->vmemmap_shift =
+			order_base_2(dev_dax->align >> PAGE_SHIFT);
 	addr = devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
-- 
2.17.2

