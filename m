Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D696D14
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:26 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVdnC009369;
	Wed, 14 Jul 2021 19:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3HwTnj70uitZefbBY/DNOFlh8e/6/Pc33VEsDK3qRKY=;
 b=MHPxikysxK8uwug5cl62qMpiO5tQOYoS+EAKW1CQ+VxTGU3AkENBbSPIpczrZ8n3Juk0
 kdqph3tAINO+S9afaZ8qg1A3Z6d1bmhZjwoLMUbAcbmJJrL+/Fkmo7pPdwA2bRcV8REI
 3HrjijM4SOdsPmG3QwtflGDWyBaEzg5YuHMV+evlxFVQtqUGXIUk/c3BI8eFFwQS4LqB
 gNvgmapN6gM0S/MNUqorvrZxyZ+m8EQaO4o410g7fSmQXUmVG5XRwGEOiTVceEOPRz34
 NrfCbF4rBlMWjR0cFoArCDVdQqwSLD8UDf7PeJR+W3KyFsCQZ6XyIjKNdITeDuvdSzM7 9A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3HwTnj70uitZefbBY/DNOFlh8e/6/Pc33VEsDK3qRKY=;
 b=x8psN6KN8oHEhstgaB2eohEByzXpD/pRjgEYYi3rtTQEXHOwPAcTCA3PpOrBmaJoJ8zT
 fx0g9VGwqCiMbEvRf5gQ1RWGNOpXEssFPZJNQvwWhfFmHuQ16mB65Fc0Q/Pt0jvr3MBF
 SKDFYCuSxFZwDDOr58uvZLpFWd8BKB/Havys/T4MBdHY3dX3eO6VES0bdnRp43OgLz/x
 /M9XB2kLBZGzKyhLKGs1B3u9frDbBwQEZG+SLnlDzOUrlLzkLIn/0EprkpAcboHeVzoC
 k6loilQ+svnqjYCFI3reas1AcdA+7zpZ4PJ8SjvLi8IDEJaIm7xIBM+4JAJNs4Q98qMN PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39sbtuk7uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJV0gZ187587;
	Wed, 14 Jul 2021 19:36:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
	by aserp3030.oracle.com with ESMTP id 39qyd1c5qr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivD/dQ5HO3suf64CXrjkYf+Q2AWWyWnVAcAeb3BFc3gzotB3Dp2hQurXWs9BJ7wEs2esVo8XLcv+GZkjWwu+hFXjNfYKxsxnA/ompyxbajvUkFGB0qY6dXwCfBnxp+zTMWE834qntXSLQ6fDGHmyvm4nk/eeT42jonx4Xvpl+fIinY5p1ODpaFyNGqJaEdaMUiLo9SzGaUaC3ivhBJ0AX7xRwuY4LENAiPCHEl+91+mDp/pASH23pCLAW9SDC8r72kXKUBOI74vCGVHKYBCXXs2qfP8C3DfeYiUrTPJW+6H05N1OrO4hbEFiwOYbZbwSWMLBItrKhjk0oIy3ueD7Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HwTnj70uitZefbBY/DNOFlh8e/6/Pc33VEsDK3qRKY=;
 b=PRYo4tzXsD/V1inW3L5CzIbq/Vm7d0/dgOAl/uXR/tjv8obZmtXakjai1uBi5wjT1R6fu6lgOLGx6MwUAD4yBnc1SCBk3o6pTay5/uco0/uBhFuz51vSlqcIZvTJSgoH4u6RpBpz4gvWWNtPGJZp7nbTzXvyNvR2sFcTh9VTY15e7HnaSpMR5ogE80SfSSZ5c61fF94jKHTMEf49plq3uShHLjmq9iQYZwwo/qqGl0ioZfpH+YZJXc0Toy9SY25ELhPS8p85dukcugKoihNMElMjQoDVzLv6pE4IReFqD8qEhooCByRpl1mWBJji59mDfGeWI3afgGS1LfRqJNUlYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HwTnj70uitZefbBY/DNOFlh8e/6/Pc33VEsDK3qRKY=;
 b=e83udu1Sc3/wQQilagWmzP+B1exNAGjt3g6ic3LmwI23NgpT6dIxiWqAi3Y2XfrUgvXyRwk5j/jKukBs5LFfQCr4Gbajct4b67qaCyXudPHsghLZ2couSbwkaivlXu2ltAE9HL3tZQvQd7jDrIBaXljNtUDZ2+sIpEA/9oFBkN8=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:36:16 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:16 +0000
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
Subject: [PATCH v3 07/14] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Wed, 14 Jul 2021 20:35:35 +0100
Message-Id: <20210714193542.21857-8-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8ec1b6-6c07-4bae-cd3e-08d946fea53a
X-MS-TrafficTypeDiagnostic: BLAPR10MB5204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5204A8E7735D0DD23DCA8E2CBB139@BLAPR10MB5204.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xc4C3wsZVkjgKE+GRsNY52H/yaDOeCWmfpqvdIYCjWKgWWVTI4QnB5OkTmr//b68eO+2sWXA41/r2QBD2SONj1DVumgKeOLHVGtUrQtU6Y0twc+P/5kXZhYHYTSUyMO+Dverrc0NA4PON/YWY7XSBIU6e1IUQ8sKH+OTjbNrD/U4t6vXzWZ6+TK1Nz50UgnSzHvQo2+PodF5IIJ1pOfc8R+DzDY2Xfj0KJQfSL0R6HjGEYDgIgoMTr1Yzq4RwN8xhLBaAxWtEOcDjDk4YCX2e6ypheTlpKTfIJfXK9EtmXpyCJoce5LKFxsDm5phbdnwvWvHaHKvYwA743gt3QHcim+NL2v4+RGjB+BU+S8xsnENsqWadeYzjFKEdAuVCUkYH0z/eSw11mTx5USo3Jli1zO7WoFP1vVZXnzbTDHybSNzkwZ3DwB3ESjXzMCrvhdwJX7F91TUY0rQbmMmSnf6Uz7k7fbJ12di+O85YcxEcP23Ee2Zj25Ozkrd8DHv2zD64/OKiuPd2JhH99G1Jyw6tbFK8kB90lVlhNeW/fg2nOa0L2Qz4dsKFwFJ9Q68VFpOluVHPfLMroOKrnrvRmwYbZBLmNhlxiTBCJwEVW4EVWi0Czz4Hhh5POK/h7+g2qNPfUKMuChy/eioBtwIM15YnrGGiHfa7Rg+nPj//9xTtyoA4zySSRKa7y2HEHQg0Rk4o9nJraQCdfQz7RqPycVG/g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(8676002)(4326008)(86362001)(6916009)(7416002)(2906002)(956004)(107886003)(2616005)(6486002)(1076003)(8936002)(66476007)(30864003)(5660300002)(36756003)(103116003)(83380400001)(38350700002)(38100700002)(54906003)(6666004)(66556008)(316002)(66946007)(478600001)(186003)(52116002)(7696005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+zI0nJExJo8l2rQg0eyfyhfZaLiuYJ65qhL4tP7JaV21NDHsZ0hZGiRqRvSV?=
 =?us-ascii?Q?HVAxlwesJu3VI/r3rrNdv/Ms/XqiJVtqTOx0xtxDOoQhAGuEGV1mD8M63Y1i?=
 =?us-ascii?Q?KbK+lkeiyJFheOkoRXWVf4RkvcaKbj5cm93QXsxuqRhttvtWAWCIT87hti3m?=
 =?us-ascii?Q?sWjok1Dke2L60vNNg56ve743b6+egzA/JpU75voeaorqrZ6DstHaC8XBrTu7?=
 =?us-ascii?Q?bxcmRtzOTRk8hAmKV5mNitvJ27nt10rfHdAUYKRSpra/OOxaSxKNaDBpXquI?=
 =?us-ascii?Q?e4laGbepk4SBz0Asb/mEjE7xO7yrzlsWbsDfPBknVVmf68dSUEuWNWrBn3Kz?=
 =?us-ascii?Q?qwDbAHyC6/++SejL6UycoVL6AysK5n8fkaRBs+d3Cr9NmRFSDtzXoxPuuqmZ?=
 =?us-ascii?Q?Bg4nsnKcMgDrISv/ksuVVrmsQ8aftKZaWFiLUSkn2yGIQe3HfRsp3s3ONZXO?=
 =?us-ascii?Q?XoCG9+WSkHk/U5+9I3rBEiQPtUB5pSqbze80mxB3muP/Lkdrvuvz0lHYblwm?=
 =?us-ascii?Q?UtLRI/2eR1ZL1VNlisC21O3f8p/X9X4INe3Y54Nz8dBj+pOF+5zhx/yga2Ec?=
 =?us-ascii?Q?2kx6YtUIw7zx+b4ic1ok96Ud7QfA+kfXN8hx6FQ/GQu5WWgm3JJ71KmyJ6ik?=
 =?us-ascii?Q?RexiIc5QunUfA7hnz0+3SGgW5GhIjIBaHmov1KupTjyszkVsSuuT6+F17msm?=
 =?us-ascii?Q?i06mEYqc0Lh96gkl5k7fLO02TcbzSPoOiI+2P2woMCkhrSi0MrO7U7Cj2u3W?=
 =?us-ascii?Q?vEwcaHAQ5wCAwbFrelC/0qguFMJ3iyQhjLUhXRhZ0XMwWeWKeQwwDVwDwVVb?=
 =?us-ascii?Q?cL0KOnVjKYVUzqI7UXi43XqymvtPKBfSIka4eob8DLXkONVEfKyoNmNWYAFV?=
 =?us-ascii?Q?SqJMIJKL8YuLA4hm0u7kyOS7BaLdbWmxV5RAg8AtutHf/P5JAk0t6/to46In?=
 =?us-ascii?Q?yIVzcL/EvHGimBTQYVb5UTsSspFVmriRc1l5tkjvFR5m5Lme7jaWwx52tjGb?=
 =?us-ascii?Q?WDsTSFvwZyHfF3D0hIQXGVvflHjwbWHKQFxYZL7uJmaU992axisNdCYiZlfI?=
 =?us-ascii?Q?rRMbBrrjyZvTK3vJLf+gffnZdUypfUhDRgHNX2oXksCpJLODaOgf7jNnFWsS?=
 =?us-ascii?Q?PkFF9nJCMXfUsrZJ0nq5dlL5ENUg7zF4lELYGhnbsoF8VVPMfD6ciu/LjqZB?=
 =?us-ascii?Q?bqZPqKgQWhZJNXblFTBfEMi9y5zBE1CaPdilrc4mxc3SYaq08um/sV3lL2Vq?=
 =?us-ascii?Q?93TOmzDoWa5vLfcNdikNbqrU1561POlH8CFZG78bvqLcz16T1Bw1MviORTDA?=
 =?us-ascii?Q?XjPbvfs9iMVlFwUgQ8ISM/Qp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8ec1b6-6c07-4bae-cd3e-08d946fea53a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:15.9796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enWOJHummvgtIqaL0hpYLBQ5AXIcxbLhu0mKDc4MEc+w/qfl5QZIx8rYGRuqa4IV/dnxtsI8rEC4yMSABuVDQXZzws5vqoEKXSydAS1qSbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-GUID: 5kWZcSiPQLkGrfwSDdhsCHqo0cLD73f6
X-Proofpoint-ORIG-GUID: 5kWZcSiPQLkGrfwSDdhsCHqo0cLD73f6

In preparation for device-dax for using hugetlbfs compound page tail
deduplication technique, move the comment block explanation into a
common place in Documentation/vm.

Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 Documentation/vm/index.rst         |   1 +
 Documentation/vm/vmemmap_dedup.rst | 170 +++++++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c               | 162 +--------------------------
 3 files changed, 172 insertions(+), 161 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
index eff5fbd492d0..edd690afd890 100644
--- a/Documentation/vm/index.rst
+++ b/Documentation/vm/index.rst
@@ -51,5 +51,6 @@ descriptions of data structures and algorithms.
    split_page_table_lock
    transhuge
    unevictable-lru
+   vmemmap_dedup
    z3fold
    zsmalloc
diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
new file mode 100644
index 000000000000..215ae2ef3bce
--- /dev/null
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -0,0 +1,170 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _vmemmap_dedup:
+
+==================================
+Free some vmemmap pages of HugeTLB
+==================================
+
+The struct page structures (page structs) are used to describe a physical
+page frame. By default, there is a one-to-one mapping from a page frame to
+it's corresponding page struct.
+
+HugeTLB pages consist of multiple base page size pages and is supported by
+many architectures. See hugetlbpage.rst in the Documentation directory for
+more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
+are currently supported. Since the base page size on x86 is 4KB, a 2MB
+HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
+4096 base pages. For each base page, there is a corresponding page struct.
+
+Within the HugeTLB subsystem, only the first 4 page structs are used to
+contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
+this upper limit. The only 'useful' information in the remaining page structs
+is the compound_head field, and this field is the same for all tail pages.
+
+By removing redundant page structs for HugeTLB pages, memory can be returned
+to the buddy allocator for other uses.
+
+Different architectures support different HugeTLB pages. For example, the
+following table is the HugeTLB page size supported by x86 and arm64
+architectures. Because arm64 supports 4k, 16k, and 64k base pages and
+supports contiguous entries, so it supports many kinds of sizes of HugeTLB
+page.
+
++--------------+-----------+-----------------------------------------------+
+| Architecture | Page Size |                HugeTLB Page Size              |
++--------------+-----------+-----------+-----------+-----------+-----------+
+|    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
++--------------+-----------+-----------+-----------+-----------+-----------+
+|              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
+|              +-----------+-----------+-----------+-----------+-----------+
+|    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
+|              +-----------+-----------+-----------+-----------+-----------+
+|              |   64KB    |    2MB    |  512MB    |    16GB   |           |
++--------------+-----------+-----------+-----------+-----------+-----------+
+
+When the system boot up, every HugeTLB page has more than one struct page
+structs which size is (unit: pages):
+
+   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+
+Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
+of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
+relationship.
+
+   HugeTLB_Size = n * PAGE_SIZE
+
+Then,
+
+   struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+               = n * sizeof(struct page) / PAGE_SIZE
+
+We can use huge mapping at the pud/pmd level for the HugeTLB page.
+
+For the HugeTLB page of the pmd level mapping, then
+
+   struct_size = n * sizeof(struct page) / PAGE_SIZE
+               = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
+               = sizeof(struct page) / sizeof(pte_t)
+               = 64 / 8
+               = 8 (pages)
+
+Where n is how many pte entries which one page can contains. So the value of
+n is (PAGE_SIZE / sizeof(pte_t)).
+
+This optimization only supports 64-bit system, so the value of sizeof(pte_t)
+is 8. And this optimization also applicable only when the size of struct page
+is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
+x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
+size of struct page structs of it is 8 page frames which size depends on the
+size of the base page.
+
+For the HugeTLB page of the pud level mapping, then
+
+   struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
+               = PAGE_SIZE / 8 * 8 (pages)
+               = PAGE_SIZE (pages)
+
+Where the struct_size(pmd) is the size of the struct page structs of a
+HugeTLB page of the pmd level mapping.
+
+E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
+HugeTLB page consists in 4096.
+
+Next, we take the pmd level mapping of the HugeTLB page as an example to
+show the internal implementation of this optimization. There are 8 pages
+struct page structs associated with a HugeTLB page which is pmd mapped.
+
+Here is how things look before optimization.
+
+    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | -------------> |     1     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     2     | -------------> |     2     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     3     | -------------> |     3     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     4     | -------------> |     4     |
+ |    PMD    |                     +-----------+                +-----------+
+ |   level   |                     |     5     | -------------> |     5     |
+ |  mapping  |                     +-----------+                +-----------+
+ |           |                     |     6     | -------------> |     6     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     7     | -------------> |     7     |
+ |           |                     +-----------+                +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
+
+The value of page->compound_head is the same for all tail pages. The first
+page of page structs (page 0) associated with the HugeTLB page contains the 4
+page structs necessary to describe the HugeTLB. The only use of the remaining
+pages of page structs (page 1 to page 7) is to point to page->compound_head.
+Therefore, we can remap pages 2 to 7 to page 1. Only 2 pages of page structs
+will be used for each HugeTLB page. This will allow us to free the remaining
+6 pages to the buddy allocator.
+
+Here is how things look after remapping.
+
+    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | -------------> |     1     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | |
+ |           |                     |     3     | ------------------+ | | | |
+ |           |                     +-----------+                     | | | |
+ |           |                     |     4     | --------------------+ | | |
+ |    PMD    |                     +-----------+                       | | |
+ |   level   |                     |     5     | ----------------------+ | |
+ |  mapping  |                     +-----------+                         | |
+ |           |                     |     6     | ------------------------+ |
+ |           |                     +-----------+                           |
+ |           |                     |     7     | --------------------------+
+ |           |                     +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
+
+When a HugeTLB is freed to the buddy system, we should allocate 6 pages for
+vmemmap pages and restore the previous mapping relationship.
+
+For the HugeTLB page of the pud level mapping. It is similar to the former.
+We also can use this approach to free (PAGE_SIZE - 2) vmemmap pages.
+
+Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
+(e.g. aarch64) provides a contiguous bit in the translation table entries
+that hints to the MMU to indicate that it is one of a contiguous set of
+entries that can be cached in a single TLB entry.
+
+The contiguous bit is used to increase the mapping size at the pmd and pte
+(last) level. So this type of HugeTLB page can be optimized only when its
+size of the struct page structs is greater than 2 pages.
+
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c540c21e26f5..e2994e50ddee 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -6,167 +6,7 @@
  *
  *     Author: Muchun Song <songmuchun@bytedance.com>
  *
- * The struct page structures (page structs) are used to describe a physical
- * page frame. By default, there is a one-to-one mapping from a page frame to
- * it's corresponding page struct.
- *
- * HugeTLB pages consist of multiple base page size pages and is supported by
- * many architectures. See hugetlbpage.rst in the Documentation directory for
- * more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
- * are currently supported. Since the base page size on x86 is 4KB, a 2MB
- * HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
- * 4096 base pages. For each base page, there is a corresponding page struct.
- *
- * Within the HugeTLB subsystem, only the first 4 page structs are used to
- * contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
- * this upper limit. The only 'useful' information in the remaining page structs
- * is the compound_head field, and this field is the same for all tail pages.
- *
- * By removing redundant page structs for HugeTLB pages, memory can be returned
- * to the buddy allocator for other uses.
- *
- * Different architectures support different HugeTLB pages. For example, the
- * following table is the HugeTLB page size supported by x86 and arm64
- * architectures. Because arm64 supports 4k, 16k, and 64k base pages and
- * supports contiguous entries, so it supports many kinds of sizes of HugeTLB
- * page.
- *
- * +--------------+-----------+-----------------------------------------------+
- * | Architecture | Page Size |                HugeTLB Page Size              |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- * |    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- * |              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
- * |              +-----------+-----------+-----------+-----------+-----------+
- * |    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
- * |              +-----------+-----------+-----------+-----------+-----------+
- * |              |   64KB    |    2MB    |  512MB    |    16GB   |           |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- *
- * When the system boot up, every HugeTLB page has more than one struct page
- * structs which size is (unit: pages):
- *
- *    struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
- *
- * Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
- * of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
- * relationship.
- *
- *    HugeTLB_Size = n * PAGE_SIZE
- *
- * Then,
- *
- *    struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
- *                = n * sizeof(struct page) / PAGE_SIZE
- *
- * We can use huge mapping at the pud/pmd level for the HugeTLB page.
- *
- * For the HugeTLB page of the pmd level mapping, then
- *
- *    struct_size = n * sizeof(struct page) / PAGE_SIZE
- *                = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
- *                = sizeof(struct page) / sizeof(pte_t)
- *                = 64 / 8
- *                = 8 (pages)
- *
- * Where n is how many pte entries which one page can contains. So the value of
- * n is (PAGE_SIZE / sizeof(pte_t)).
- *
- * This optimization only supports 64-bit system, so the value of sizeof(pte_t)
- * is 8. And this optimization also applicable only when the size of struct page
- * is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
- * x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
- * size of struct page structs of it is 8 page frames which size depends on the
- * size of the base page.
- *
- * For the HugeTLB page of the pud level mapping, then
- *
- *    struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
- *                = PAGE_SIZE / 8 * 8 (pages)
- *                = PAGE_SIZE (pages)
- *
- * Where the struct_size(pmd) is the size of the struct page structs of a
- * HugeTLB page of the pmd level mapping.
- *
- * E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
- * HugeTLB page consists in 4096.
- *
- * Next, we take the pmd level mapping of the HugeTLB page as an example to
- * show the internal implementation of this optimization. There are 8 pages
- * struct page structs associated with a HugeTLB page which is pmd mapped.
- *
- * Here is how things look before optimization.
- *
- *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- * |           |                     |     0     | -------------> |     0     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | -------------> |     1     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     2     | -------------> |     2     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     3     | -------------> |     3     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     4     | -------------> |     4     |
- * |    PMD    |                     +-----------+                +-----------+
- * |   level   |                     |     5     | -------------> |     5     |
- * |  mapping  |                     +-----------+                +-----------+
- * |           |                     |     6     | -------------> |     6     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     7     | -------------> |     7     |
- * |           |                     +-----------+                +-----------+
- * |           |
- * |           |
- * |           |
- * +-----------+
- *
- * The value of page->compound_head is the same for all tail pages. The first
- * page of page structs (page 0) associated with the HugeTLB page contains the 4
- * page structs necessary to describe the HugeTLB. The only use of the remaining
- * pages of page structs (page 1 to page 7) is to point to page->compound_head.
- * Therefore, we can remap pages 2 to 7 to page 1. Only 2 pages of page structs
- * will be used for each HugeTLB page. This will allow us to free the remaining
- * 6 pages to the buddy allocator.
- *
- * Here is how things look after remapping.
- *
- *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- * |           |                     |     0     | -------------> |     0     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | -------------> |     1     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- * |           |                     +-----------+                   | | | | |
- * |           |                     |     3     | ------------------+ | | | |
- * |           |                     +-----------+                     | | | |
- * |           |                     |     4     | --------------------+ | | |
- * |    PMD    |                     +-----------+                       | | |
- * |   level   |                     |     5     | ----------------------+ | |
- * |  mapping  |                     +-----------+                         | |
- * |           |                     |     6     | ------------------------+ |
- * |           |                     +-----------+                           |
- * |           |                     |     7     | --------------------------+
- * |           |                     +-----------+
- * |           |
- * |           |
- * |           |
- * +-----------+
- *
- * When a HugeTLB is freed to the buddy system, we should allocate 6 pages for
- * vmemmap pages and restore the previous mapping relationship.
- *
- * For the HugeTLB page of the pud level mapping. It is similar to the former.
- * We also can use this approach to free (PAGE_SIZE - 2) vmemmap pages.
- *
- * Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
- * (e.g. aarch64) provides a contiguous bit in the translation table entries
- * that hints to the MMU to indicate that it is one of a contiguous set of
- * entries that can be cached in a single TLB entry.
- *
- * The contiguous bit is used to increase the mapping size at the pmd and pte
- * (last) level. So this type of HugeTLB page can be optimized only when its
- * size of the struct page structs is greater than 2 pages.
+ * See Documentation/vm/vmemmap_dedup.rst
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
-- 
2.17.1

