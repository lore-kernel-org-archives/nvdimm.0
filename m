Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC56E2CA5
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 19:34:32 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AHIRYM026356;
	Thu, 10 Feb 2022 19:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8co4H0jZZNMhD6hU/mlqQ0kW32xrtx8PNIOW0EmnwCo=;
 b=HxUDrIhq1MIK5y1bbGLwYbmWd/I3y7Oo1Afnf3wtXlyp4IGMS4rbVz2p7HXH/71ONH0Y
 0zGrlbqx0/CXyhmmwCkxu5VGnjRN/Tup80cRVQ8kY359VjvEn17vyqJJG42gvj8bAGNA
 iKij/Ynj5nuaigWxndqJZKoHApLcO7UML99rySqbOJeM/2ZEmRsnFQQYNIJq3+9NNzna
 tYEv1Q7QscUeEzc077s69TwMGJen/jaS8wFQgvDLvhX2ZcQjWpJ7p67zColmS4zD5Hlx
 U2BZ9iiuW7NRm1USBOiQZKJn3v/WU17qgAE+i5L+tN2KJsr1Vs+ugXzB6YmbtbUIDPih HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e54ykgtwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AJVgLQ144273;
	Thu, 10 Feb 2022 19:34:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by aserp3020.oracle.com with ESMTP id 3e1h2axsaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQZFZmn4UBshuz6iiPAv3rdlmtGVuRr/7rHkYg38GscyTHADngXt9xI5qzR2iCD2LJcQTb34Y3dfn1n8/x1Hlo6cVlO5SUVOpe6l+4cKpKvVFtcd4SDrTGSp7xom5B7Jg2Az5xw2wRLl6sYg7XU2R9mQ023rwTOdk8rXzBrOV+vregght/I70XlaZyvRR2rGOJEBDgYnRnYq2ceAvdwb7GGGyg+5J88S3ITL6wOeopl7BxsKhyHOWeKHW528n3o4f3DrdLjRYbR5VPjHLxVlT4PhhVfmLvRTlOUXNC7NRo4kpWRhzvcvoatof6gRKu4Jc00mxch1UBdsMVDKYfYHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8co4H0jZZNMhD6hU/mlqQ0kW32xrtx8PNIOW0EmnwCo=;
 b=AQBmT14fhos42JtC05vwlmjrcDHub3ki+E4sNNKp9tql2jxZn5ZLQSnx+jVMo9vnhfCatcsUU1CYip7fIowQSjS3JF0lJ6OVxWxMphSJnFCs/Nta9XkOhWeYpHvmTPunciK9sd6PmndD2LQporqSShoIk8cL2EAmz4DudMa9bkFd0zr19Rp9u1UzJ248yhg9qrEF2vpbXHq/CJeQTr1VCztGr+GFwf/xPatg5OGopLe3fGL9b58hk/+rjzISMBEioQ5B9GaFz5Ir6+qIxdMm4rtX34hf2BfWzNky1JldIadObSYsd1s9YScKJ2bYzm7LLIBwpUocAUxBFe7uKOILYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8co4H0jZZNMhD6hU/mlqQ0kW32xrtx8PNIOW0EmnwCo=;
 b=v1SYJ1/n+xD51hdeo1cDnCdIgn4IHOJUk4mpV+fYalt4KjMHxpqsAgPWAjpHBeUlGGFXFSGoo21syIYwUXgXKBcNWh+yEOJQOnlDdy9grFbDnT0uf2qoiCCbn34K3rQadDDaVqFRPc6GmwZZmj+Yw63BJgYwbKPIwP0QLszmPsw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2514.namprd10.prod.outlook.com (2603:10b6:406:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 19:34:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 19:34:19 +0000
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
Subject: [PATCH v5 4/5] mm/sparse-vmemmap: improve memory savings for compound devmaps
Date: Thu, 10 Feb 2022 19:33:44 +0000
Message-Id: <20220210193345.23628-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220210193345.23628-1-joao.m.martins@oracle.com>
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0170.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05baa233-67ce-4dfc-d257-08d9eccc54c4
X-MS-TrafficTypeDiagnostic: BN7PR10MB2514:EE_
X-Microsoft-Antispam-PRVS: 
	<BN7PR10MB2514F323490FFC6AFE2446C1BB2F9@BN7PR10MB2514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bElo7FAc/RfsWk+IkX+x3mEzOKPBJUUGHwkAnm3yKExwizPMUFuRM8D4cfPbJVDzo1OeZiAfBdAvMd/7mvW+RApZUoy5IN6eJOYD08l21j9aKay54JuWjQgdyAaHHuxkLOC4vYWydmePuKCCSgBb7G7dCh/YFcq2BkbAs4Wqi6NYXERWn8fCtf7S8EfMA09TK1/03R4+oH4Y+EAbNZ3JuUqZAN/Pw1HQLzUYOGhNKzIuXBoAnxWjp2Vv6yFV6RWThXoUTvTKdqzlurL6yd/0YBgU/2wSe5rYwe20TKvzTs+yPKbA24SGv9DKUxLzNh0bv+j3Sximh1gPeB4dC8tciB1z2QQkSsMukUWaxMKP1QBts0leI1nlKoCgr0boukvugNpJEOoVkT4qPKpMmsqrdPoZsZVW26SSLMHzIDXvXF2Ump0kqk5zeElzKFoUsARhmFSWo16pwloNwuKcGdiDrF6PSJHW1HsWNAtgl2l5PTldHOkPGsFv46ZA4FHMyQm0G2LVaXHMJNRdUCCDo2H9Uy9EHAlUtZlKq8D59Uo+wUlQXapssQMSAVAinB30OMcic+zAS93uIZRMgEeARNw44HNm6zWZY8hmKF4TfhdHygwdtp9ol+p6swaILoBj7nsSQ3bTJa9OgoPz01eMV9jXl+jcuSIE+KUI+S/MXrzzV3+BynNJMeqJHGfoLQN36lLUPW+lEHpt6gLJEo66QKCq2Feu+t0Hk/IQ+QbQtgfu/EI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(103116003)(66946007)(36756003)(66556008)(8676002)(2616005)(8936002)(316002)(7416002)(5660300002)(66476007)(30864003)(83380400001)(4326008)(186003)(107886003)(26005)(54906003)(6916009)(1076003)(6506007)(2906002)(86362001)(508600001)(38100700002)(52116002)(38350700002)(6666004)(6486002)(6512007)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?I2Mx7RVtOWLR0y/L3SSd7wQVd7GJ8rtDMoQDuugpu8Wi4q+uOIuyvw7pQk1c?=
 =?us-ascii?Q?LCZyO/YvSex23GNztCRKO9gJA2SayWKTOIRSIpOIr53gkjvhrBnAyF2d7BEj?=
 =?us-ascii?Q?bgbdq335LTB5EQ2WFVy6db04FIuB0Sw8aBcw/6v4pOi00zkx4Xhx882heX9L?=
 =?us-ascii?Q?LQKpDm7gzKWYwABszW+hsSbhErUs9ueorXg5ykf+ZxaRBPoi7oCWAuFB1ZKh?=
 =?us-ascii?Q?ZRSJhwHVwiNmT3pa6orKYXcA9qsOtZ3cNkTTePjU56evHMNWjTRzlms0muH8?=
 =?us-ascii?Q?yE7A9jB2DkyomhCu5lbpIRY00dpX102rOtsjlOyVBj/sX9N4SlxbSQPMH8ii?=
 =?us-ascii?Q?zsJYSoPLBRcKaEbOCca2VwFt/tn/zvBo4x2gmnMOhYb5Z5o504e3lrzvMDyv?=
 =?us-ascii?Q?c9RYUHaDGawPsxKjN83oDbD4r5hg6uOZLccl54VK0wL/ee1rdXGgpXCPrq2q?=
 =?us-ascii?Q?bO31X464lbrb7QALFMlmYD/FSI6WnCZBXjgECdQpMD4Y5CLtkhGvp3l8ZxSK?=
 =?us-ascii?Q?cRBbI2L7kXg34pRZh6+Qoy1DPE7fdNnqlb6PJheR8hprnAYrLt6PqkgTqUXp?=
 =?us-ascii?Q?LAnwH/s6ochl3vvRyZ+PSZheqYHgbowweodQFS4XdKnbX4AULBhyQbbAG9Ff?=
 =?us-ascii?Q?Xk4t+mMZ6JYB7U+BNSNwjWwrcICguM+ECMiai/ltRuDe2H37Gve+NQfnwGs8?=
 =?us-ascii?Q?xFD7AhnSTe4UKqQSFAmjzw/bYWsKGeGj0ylRVjg66iqIT6SAe97MQAl9j9Ji?=
 =?us-ascii?Q?lHFJnqUWceKqx95TTzbz1Ry9NLQFbTxo1jUxb6SYF+gGxbWuA6nw7tQptrTA?=
 =?us-ascii?Q?lfSOCjxnSvJpvt/sW0ppgLhaKgTybazVqWSuJjGKz18bH3YEn3S+Ku7q+OX4?=
 =?us-ascii?Q?giTg7yFbLsVNOMjAu0aEiJOnlIcY6p/DEErprEq0/Erp6spN2MrCVF2i8BZO?=
 =?us-ascii?Q?dHw0XJflb5TKuYPEREDfhq2S+hFNRff4Q+YUtq0fe8m6nGb8ev4YkdIiLeSu?=
 =?us-ascii?Q?d5qS0/4/E3am0rdejwwU0bXHtgJgiPd+WoA4q5GOM4iteAuHAmddDSJNTyau?=
 =?us-ascii?Q?vEp3pjSatDCxTd1Y4SelXmyVGy6KFl3Pv5c/kXI/b/eHVv9fZio5yyyLIw2L?=
 =?us-ascii?Q?gwtOqlPdKv6ADoqmmTv4BGGWzYVmE1puKnZ7qEoosy2MbA+3EOOoZIvf5zOX?=
 =?us-ascii?Q?kBXWYhtJmCQ+1D2mx06pVPUF08abH2BW0T2Y6RoqVY9w6gg8SGXUpCpIsFm9?=
 =?us-ascii?Q?J11nfQPe4XJZp+WFgRifyq1okumckqtEBRNnH8654i/sZvzv3OgeWJ3moNkE?=
 =?us-ascii?Q?/zpB8sqPSFz3njTLViL4to2eHU7jFRh3hRM1H+J/fKVO8QpRHLJAgMBAt+aJ?=
 =?us-ascii?Q?7qcnvQ9+S44CNSY/Bxc1tbhRFeRqiX06y1asDcjk6TS+IP86JkHGNSF6YLik?=
 =?us-ascii?Q?5clsOCfKRXWuFb/DcmFzvf6AMOD7hDfdgVpJWpjoKvjgKUyQhgYisuwXZ9TU?=
 =?us-ascii?Q?9dSWh4AHKkBamyHmmaNxFgl0iGLy/9tqoxm1PnvxEtuLi/P6roEMQF/iM3Mr?=
 =?us-ascii?Q?PMIkS50Ts6iLCwi+I32ETjdtzlRgrv+L0LlM9/QJeHrj8wMorj1P2zpJsqhf?=
 =?us-ascii?Q?PSh1/5F83I0wD9dX9dzz5vXuu11QF7CxiPOoafrc47MykiOzOPkCjgJ6jGw8?=
 =?us-ascii?Q?Mw2SHg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05baa233-67ce-4dfc-d257-08d9eccc54c4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 19:34:19.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3UU7Yq5Co0hRqwCR09KN/Ewtbm8vm2O/+lXEwVqJU2gYnpB9dkUbxqYMuK6hsTPEWST0bN3i01ppCintm6et1FHOzWd6WD0LMZaYTMEc/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100103
X-Proofpoint-GUID: LJHzM0EF1ZHuhHriwNkShIv-FmuEs73m
X-Proofpoint-ORIG-GUID: LJHzM0EF1ZHuhHriwNkShIv-FmuEs73m

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
 Documentation/vm/vmemmap_dedup.rst |  56 ++++++++++-
 include/linux/mm.h                 |   2 +-
 mm/memremap.c                      |   1 +
 mm/sparse-vmemmap.c                | 150 +++++++++++++++++++++++++++--
 4 files changed, 197 insertions(+), 12 deletions(-)

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
index f6a439582f63..0b7028b9ff2f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3172,7 +3172,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *block);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memremap.c b/mm/memremap.c
index 71b8d42d820c..a0ef95f09397 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -323,6 +323,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e7be2ef4454b..2e2b063ed285 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -533,16 +533,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
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
@@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static int __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse, struct page **page)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -629,11 +645,13 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
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
 
@@ -644,10 +662,120 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
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
+	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+	unsigned long offset = start_pfn -
+		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
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
+	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
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
@@ -659,12 +787,18 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.17.2

