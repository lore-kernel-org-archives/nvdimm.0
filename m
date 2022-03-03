Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4BC4286
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 21:33:48 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KEiiT017342;
	Thu, 3 Mar 2022 21:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=R8DDQkIFxc/pBmzUTrpNK1/RSulJ0EPErufrYnIhA6o=;
 b=ZA3gx6DIsWk+JXBwuLLd9ikiz3dfNi+OJp/Nved9ogUtBlvnkBzI3jyRq5++hIFncJz3
 saTxhojvETHXuF+xFfKiAufWumT9oxO3SxBjdxuilpG+mPk3+RLsV7Zu9vxS3OYO7GpD
 tUPboJOc0t/O02iXkYb+zeY/mCon6Y38MSgGgqxNZ5tZu/V6Ds+KEwdFXNylOMT7Ovui
 2J3wkBm22fC9kWQg4XivRKB18XN5qX6o0mLht6J1F77SivtDMf53osEIE1ZZFSdhlGxH
 YUmuo5BhLoqGSTXCpZx5s3upBNXREAKPcW0neBUzdGjnQ+LExeVTAoHEaYjRWMZW4Pir ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hvg5hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223LKueo132178;
	Thu, 3 Mar 2022 21:33:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by aserp3020.oracle.com with ESMTP id 3ek4j7tq3n-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcbHsimnoGu4eHh8ggmJ1ubKRIh5AEX8pfNvtHgwOcoG5W3gCrXbNWy2EhQ9DIGMxZti4lhiOH2kv1xt0dwHICSgs6dwiGLhx8N3xH6GgW/J/OOWE7uDvdoYOGrQNf7Mt886Jy9CTdd2B80xtagPUu1Pmdr1bVLXVB04BhJ4n2CPi1vzBVIEca0cOmFntJC405rXjmclVuvr0Lu+c/vcrZ0qlhIZPuNylR2+z9cltRxtjdaSMfrrpqFeOBGzCkwc5Eiscaai4TBKa042PI3t14T30npnwVJHEIawxbLFX4Py89T3P1A0aiEF/zobX6OjCkz+tyok9H89E+7HtUVMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8DDQkIFxc/pBmzUTrpNK1/RSulJ0EPErufrYnIhA6o=;
 b=Jad8Yp9bgWY/rcaIDPlgC5ot57nP+CxYigTd8RpmzMCUhGgFEuIv15NdzE+2op8jURp2odP+ve+vGwDgHr028WRq9GL51qcbQK8F0f/tBejgTtw5oAeIQLIWDSei4NmU74645b4SBl91vvMwFLnD0sdd+x29AFppBH6C5uKMey0lG6n63HUtlKd+v4MHn+JQh0ocwWtx/Ok+vY4Cc4HTbm7b+slkbzcN0xpKpVKqwD53liP2FtePhTZT1jjyC2bPCj8nfo36MxMhYhGAW8zKmJXAEKGtwYrkc2fWGFDTx3+HKvgCQxYupoKtbnhRigkAJK6HJ5TLbS6pfAmjRI12xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8DDQkIFxc/pBmzUTrpNK1/RSulJ0EPErufrYnIhA6o=;
 b=hU5qAAn1qylKorlMEMmRIZGVssQOjziOyACbu+OjIG2olfxnaRcbz64FzRap3x2uInrqdiP5Ge0CxG2bdT30kRQCULQjtUnAeUSl+knpsfOPfhk/QYmQMv466N1WEy31GTqpxj2I6v+wlvQg1NMj/lFPPb2H9N6wnz0wUUYrPbo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1658.namprd10.prod.outlook.com (2603:10b6:4:4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Thu, 3 Mar 2022 21:33:36 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 21:33:36 +0000
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
Subject: [PATCH v7 4/5] mm/sparse-vmemmap: improve memory savings for compound devmaps
Date: Thu,  3 Mar 2022 21:32:51 +0000
Message-Id: <20220303213252.28593-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220303213252.28593-1-joao.m.martins@oracle.com>
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0036.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 035768f9-d9e4-4ef2-4d87-08d9fd5d797b
X-MS-TrafficTypeDiagnostic: DM5PR10MB1658:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR10MB1658ECFEE72FDDF14D1AE83DBB049@DM5PR10MB1658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Yb5nHGCOKKfFpblcjwv1M+3O5ByXJrOmuObOXNgZD0hr0P0BvEMcZBPGHFVEl8cP8iGOM1GN7ylRprLtzSO8WIG3Gc7FVv573HC5gjldi2r8SUmmSig8auJznFCO7/R+2ks2MnowfLFp/3nQL9xrq68WdLTq4w5lqJzcsFpk0IcCJAWFyVQ67Clz310vZLmca5qN7Aca/rYhZ2tnDTUrstIQfOVIzeN5G2NKiXW9ITCy8+lKZrkmH9uFJjP8joResSDye0Kwi6P2frXx5dUOOMHRav5eCnKOtndAmG6NVk/Pumbu84WAj8sLIkViwN0c/3KCiTmkBxJjZb4EISzTvds+JMIve8vs5deqWPck6Z7k79rpWjB/u3BqvKHzkiF/gQeOiF4TAM918lR0JYzCySw0rC+Fj4usaxq2fOmZbR7EneMlzVjr9RauNgE/U2u3X1O/70f9XOxUYQHyurGsFfbBhQxbXm+Yjx8tkXx6heTakuIKnHEhyj0JTjgYP2fVhQNdcKSVQ4EwM7FOkiREgbnCxQuqFeL0K1I28xDEYvTSw4LI3KC85AP0VI9CvRiq7K5PdJXY+5CABolwPz1j75Ih8CJWJy/EgsRqyvt0dOpro5qyquuTuCPxCC1qsrtjQQND9WJwpzeuSoWN6miyCgXFvtJe73cgoQX2gw17jAXAUYXGpLeuyKl0aFtyAEf+1QYay0rUqMSr98vw2GBvv3DOwtqKFWH9aieu10vZQ7M=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(38350700002)(186003)(107886003)(26005)(1076003)(5660300002)(36756003)(30864003)(103116003)(2906002)(7416002)(8936002)(66946007)(508600001)(66556008)(86362001)(6486002)(66476007)(6512007)(52116002)(316002)(2616005)(8676002)(4326008)(6916009)(6506007)(6666004)(54906003)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?EhuiSpDeBMSmJRDb5G8OJS999MZ8191mQ5k4B1KL2/D30cnXce/Kmk1P3thT?=
 =?us-ascii?Q?Rb+n0qDQ3CAnjjJElM17pJRIyM2f9ZKdDD1wJiPWgBXVR/MvycJvNTGhu4OB?=
 =?us-ascii?Q?SyrlbT6dk8cbHk4guCroFxaPDPIwpYZ91PkbraS6usUZMSdOPgXgR2ccv9/F?=
 =?us-ascii?Q?0zYRetWuetxM2FyD+KCr3xmD66Yn3YYAkzrOxj0BE7GxCdWazibERT4zJRUr?=
 =?us-ascii?Q?10jpQTKptlSOMxwUjd74CkaDll4J9iE4H6bCa54RZvRqxqgDkudYu+da5gpW?=
 =?us-ascii?Q?BvSm+RzIRJ3ksox1E/CPA5324R1lgpXm97uJxqe55GyX4Uq9sFUrVRpWul3n?=
 =?us-ascii?Q?eAHjDGCY1Q7rx0nuMbUzZJkf7/1xpR/Tro1pkXMvtoQmYb+0XoMxh8I1+Pzd?=
 =?us-ascii?Q?HruTHLuHoZ8T4cg1JeWplUzvtycSflwqOuMK2Ka7l3CgwynCZtobSaoCnsKd?=
 =?us-ascii?Q?NK5Gj38ws8LyWjD3ytqpTw2izkfzad3+SvGHBATyF+mwOMCH/O3dbYzfUFRT?=
 =?us-ascii?Q?Zp58pJm5yOAJdI0VVsJvJsRgTEibCnKOyg9w2vqhWfb0DkG0WD/pBiCISjIt?=
 =?us-ascii?Q?R01bvnTR50EW/TitdS6P/bgaTAYbPOALK3TLF2RheSjpeV0BMAPDMc3eVf+i?=
 =?us-ascii?Q?wtBxCa+Dqe8ar8wRz6NxSB1ig2cbyxAI0nbZs9aiiCPA+gSFvcPGHcERbR9k?=
 =?us-ascii?Q?/FeeQAUg6TKTQnJf8Jg42/cRn5yMBkARJiAnB+22w8rZz8ZEHpsx1aIiIENI?=
 =?us-ascii?Q?/k3KuNluJHoI9RDIgM+JMcJoSFpoqRog4yvc1C4U41ilKL5AwElwi8gSKd1j?=
 =?us-ascii?Q?0pxn9BwA/Md/IzivGshROjYN/SNdCjxgQ6Jsamqixzd4n+RHKmVmEp88/NCD?=
 =?us-ascii?Q?5tX2bWSDUyP9UMc8v6Kf8V8P1wa9Uewmzwc2+UJTEj6v0srApkGnIUh3RaMa?=
 =?us-ascii?Q?4xyNlvmGeEXQ98JAzFViNEiZ2Z9U6D4NaFpX6vcYPFQgGqUDVZbBX7jNvl36?=
 =?us-ascii?Q?PgKrL5tX2Kh3UFh5beHDjAqC1QhkvzaQiny9XLJOkBLEwdN95Md4r2HY6BFr?=
 =?us-ascii?Q?68kEKAe3cwvhX4cftYw7jloqdbxR1RUETIuPtCaGfnqNBcRrSL9VutX5g+21?=
 =?us-ascii?Q?WDXwb75DQ6fMrRaq4ZlIhVjviq6U1flk7usGiTD10XCSY0/44Ih/LfaP0YxU?=
 =?us-ascii?Q?7qiMSXAjpXsDTSnE2vml3KDK/FFYaLvzx+k/6rzfEil5pGAP7vmfxYmhoJr4?=
 =?us-ascii?Q?EmOKbThtOL5wry4tU/qJwPBXWPle/Tv8oLr++Lmj8F149N9313VUVYA10/q9?=
 =?us-ascii?Q?/cpp/KAZXWHGvW0jv3U29IdS2INGJgwih+phgh+OD4spQ/N5z2NwttqQezFL?=
 =?us-ascii?Q?9y9sGUnBkVj6ANadl2U6aEhfEm++i72Ae5l8ZPitcaXDfG8hmyz9BDD8pF2f?=
 =?us-ascii?Q?6j7VyJpNJDHbVDq/nA0MCZ1JuGWc+gzW9iJf+5mdF1wDz4mUNmK1vcHTO8WA?=
 =?us-ascii?Q?PGv/EKBEK+Ih52OX/3qYUDdsC8wBvS/E+0wQIEJQUapfau/pt9nu9nRLAGIc?=
 =?us-ascii?Q?frWFcBCVrtRAFbwbfbr70AasTCd9d+HejLWblu68Xt9u6DVy+2aCR2QUyVn4?=
 =?us-ascii?Q?fWkEvFzkLCf/dFnK0OQV6b/ugxpO+nKy5iT8JwRP74QVsE60PuHWuNRFX7Vr?=
 =?us-ascii?Q?kYsSiA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035768f9-d9e4-4ef2-4d87-08d9fd5d797b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 21:33:36.4670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pqN52rIBlRq1tJwpjn+u4YoVcjZwvjVPOg2mdtuh7K4tGe9xXtD27ZFHG840Kf7g+gk2sE8nBn0llREqai5MhoUxD6VY10w341xWp92Ghg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1658
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203030097
X-Proofpoint-ORIG-GUID: xQ0U74XWOP81Sb0ZUjj9f4bgMr_aGQdT
X-Proofpoint-GUID: xQ0U74XWOP81Sb0ZUjj9f4bgMr_aGQdT

A compound devmap is a dev_pagemap with @vmemmap_shift > 0 and it
means that pages are mapped at a given huge page alignment and utilize
uses compound pages as opposed to order-0 pages.

Take advantage of the fact that most tail pages look the same (except
the first two) to minimize struct page overhead. Allocate a separate
page for the vmemmap area which contains the head page and separate for
the next 64 pages. The rest of the subsections then reuse this tail
vmemmap page to initialize the rest of the tail pages.

Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
when initializing compound devmap with big enough @vmemmap_shift (e.g.
1G PUD) it may cross multiple sections. The vmemmap code needs to
consult @pgmap so that multiple sections that all map the same tail
data can refer back to the first copy of that data for a given
gigantic page.

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
 Documentation/vm/vmemmap_dedup.rst |  56 +++++++++++-
 include/linux/mm.h                 |   2 +-
 mm/memremap.c                      |   1 +
 mm/sparse-vmemmap.c                | 132 ++++++++++++++++++++++++++---
 4 files changed, 177 insertions(+), 14 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index 8143b2ce414d..de958bbbf78c 100644
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
@@ -173,3 +176,50 @@ tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
 more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
 associated with each HugeTLB page. The compound_head() can handle this
 correctly (more details refer to the comment above compound_head()).
+
+Device DAX
+==========
+
+The device-dax interface uses the same tail deduplication technique explained
+in the previous chapter, except when used with the vmemmap in
+the device (altmap).
+
+The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
+PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
+
+The differences with HugeTLB are relatively minor.
+
+It only use 3 page structs for storing all information as opposed
+to 4 on HugeTLB pages.
+
+There's no remapping of vmemmap given that device-dax memory is not part of
+System RAM ranges initialized at boot. Thus the tail page deduplication
+happens at a later stage when we populate the sections. HugeTLB reuses the
+the head vmemmap page representing, whereas device-dax reuses the tail
+vmemmap page. This results in only half of the savings compared to HugeTLB.
+
+Deduplicated tail pages are not mapped read-only.
+
+Here's how things look like on device-dax after the sections are populated:
+
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
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5f549cf6a4e8..ad7a845f15b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3118,7 +3118,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *reuse);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memremap.c b/mm/memremap.c
index 2e9148a3421a..a6be2f5bf443 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -307,6 +307,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 1b30a82f285e..642e4c8467b6 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -533,16 +533,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap)
+				       struct vmem_altmap *altmap,
+				       struct page *reuse)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
 		void *p;
 
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-		if (!p)
-			return NULL;
+		if (!reuse) {
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
+			get_page(reuse);
+			p = page_to_virt(reuse);
+		}
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -629,7 +645,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -639,13 +655,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
+					    struct vmem_altmap *altmap,
+					    struct page *reuse)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+		pte = vmemmap_populate_address(addr, node, altmap, reuse);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -656,7 +673,95 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap);
+	return vmemmap_populate_range(start, end, node, altmap, NULL);
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
+	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+	unsigned long offset = start_pfn -
+		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
+}
+
+static pte_t * __meminit compound_section_tail_page(unsigned long addr)
+{
+	pte_t *pte;
+
+	addr -= PAGE_SIZE;
+
+	/*
+	 * Assuming sections are populated sequentially, the previous section's
+	 * page data can be reused.
+	 */
+	pte = pte_offset_kernel(pmd_off_k(addr), addr);
+	if (!pte)
+		return NULL;
+
+	return pte;
+}
+
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
+{
+	unsigned long size, addr;
+	pte_t *pte;
+	int rc;
+
+	if (reuse_compound_section(start_pfn, pgmap)) {
+		pte = compound_section_tail_page(start);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the page that was populated in the prior iteration
+		 * with just tail struct pages.
+		 */
+		return vmemmap_populate_range(start, end, node, NULL,
+					      pte_page(*pte));
+	}
+
+	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	for (addr = start; addr < end; addr += size) {
+		unsigned long next = addr, last = addr + size;
+
+		/* Populate the head page vmemmap page */
+		pte = vmemmap_populate_address(addr, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/* Populate the tail pages vmemmap page */
+		next = addr + PAGE_SIZE;
+		pte = vmemmap_populate_address(next, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the previous page for the rest of tail pages
+		 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+		 */
+		next += PAGE_SIZE;
+		rc = vmemmap_populate_range(next, last, node, NULL,
+					    pte_page(*pte));
+		if (rc)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
@@ -665,12 +770,19 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (is_power_of_2(sizeof(struct page)) &&
+	    pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.17.2

