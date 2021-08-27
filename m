Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF90C3FD1
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:24 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWEDN013579;
	Fri, 27 Aug 2021 14:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jTz9Gcttrup59NqSwIQTfNduJVtZetbNHP5heiIiN90=;
 b=TAcAxocYU9q3cpG+mMWuHbMLVI8dPtMjjQLNMlIxoIUxCBgH5q9I/4z2NRvQ+6ZenR7w
 JsYPz1svxUu7s11rMXcCBSqZKTci1X4osbCGyyf6p3+Hd1nG0VQ+WAgjCpceKhQ/NlBm
 wfYFSTWiP0k28whHqPpqXdPVfPeTDjwjM8UUE0VOirB4kF738GwqjIHIlBRnY9+ZUZfN
 ek+xo/SybtAJbJkzuWYRuAF/W364A1LYAg+eootr3v5Xvrz5iVSTRubT6dZyOEqFMhcu
 HM6CIh0s87OWr1/JsnG7keGqiisMPlAyLvTJhs3Qy6LZ5Wug8yZsMn2v/CX7Piks/xDI YA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=jTz9Gcttrup59NqSwIQTfNduJVtZetbNHP5heiIiN90=;
 b=afZ49e46DljS0YTeWYQMcL6kYKBOo6S2oaAt1vMQTG/YZkDBslLRLR3xEYURLkNj1/DM
 6fIRjN8ZJo3af72EhNEqg5ISg/EhSCaO/fkViWR09im4a8MHv/uBjPEOBssHfESCZ4UC
 z/R7RWYOnv9fkbDv5jpzfOuBfKzqxtTWf5eNsC69OGlkgEKhieSe6JjHitJDazXTFvEC
 UhHokc2VXED+rYGkdq8s3/rJUv4e+NTwyzADghiukPpyxj4rJQX+pi5lUA3Bk8zk6ixb
 yzE6lLKHuSDtL4TeTUURndWMSg76BmCDN95gk+Kxtsh0f4kBb7i8BxnN8k47Gg7xlM0e 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap552bsth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpZPm152641;
	Fri, 27 Aug 2021 14:59:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by aserp3030.oracle.com with ESMTP id 3ajqhmq1q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHUFiD3/fy00bi3MNQuHZrxyYGxX613fPzvKVAcj6BQrRtDLUQrMFkG0J2KXNDW9IRmpUQa3TmAzT3y+vLH2MXv1p5+7+VmikwWXp+3lGoGoSBujO/af8lAGeD7670QwJ/iIFJ1GUzQFIqp+tHLtCw7OUagFg9ryEru8G9s2T0/Bxa3wbkE/A966cVHzfan5Kb3GasPHP+KYtyndf8UzKar0guvXYCsmq6b3LpAPEermQ3FJY2xobIpYyWZXRtnMFuPjLJ7oqvKqhFeAwvIq9nYrIzRniv533kPiO5oavqWcCx0hwsOd4/I7xNNU+dR2WLyCty5YMMgT//K3jkxAKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTz9Gcttrup59NqSwIQTfNduJVtZetbNHP5heiIiN90=;
 b=e39ZT16nN20FvSH//shT9q3MrBpTPzRP/NxncHC/oFKZosXaf3chhtVjzAXfLwI/02xOfgUfAsw/1zofeZg4Hc7y8OpR2y3ektWKRrFwbbiHo9BEtXJOTZuvLoQQrf9O97Kp+gSM6SXKcAbkYOBSYFdQ0/V2XXUJirdYH+HVy8lwpxyn1DuOon7D7SMxDlRlk/wfOoipjZy+VbXyv6opqnUgII/drK63PRQzrCsbdBgsSydbGuHXzN4UEW8ojAyPHhfxmTvr7ohp1PvLZ3Sq13BIqjLSvS86eUb93IJID+pg48YmKMjTyqWGeQzfPVZOa5nSON/O2ioA2JODsbGWpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTz9Gcttrup59NqSwIQTfNduJVtZetbNHP5heiIiN90=;
 b=GiaxpL1C+ArNittB3247YK+7Q6p2su8MYXPswI0VZgzrqah2pcLAmVGmnOWH0fXJw803G3Vg3KedjTF7ORLlC6StnZQeYxT3QSpfZF+twvPidA+L5nyuKkpeBae3MeFP51RwuywrbfTqhgkhx27gdFUAXJ+y+xs8aanLuiOkHX0=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 14:59:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:09 +0000
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
Subject: [PATCH v4 09/14] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Fri, 27 Aug 2021 15:58:14 +0100
Message-Id: <20210827145819.16471-10-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:59:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74bfb882-4a08-4672-6883-08d9696b3920
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4881C8202B138CEB8A5AF9ACBBC89@BLAPR10MB4881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gEyD3+Z+8WhaD9jeeEukl1ad1EzBfpsmiS2ECkciI4vSj6f0ejK+ahdEdXkBbIxOUvMDA5i8YClhZfzgzCXbSn4jSOh++y0m86XO5boJt1tFgdVAWma7laCIShOLwyYZ391/1oy/OHEHDWIgASR6+5/LIOhMgq+OQTZijT5LdY5JxWabHhTL+sSC4aPRQSDJg7uEqJS/OH6XNsxeyxqbEx7nUYQdZlrR3bu/16BmbmXf3c3S4IjRbA4OChVn4SJMtejvz0shElufem4hUGIWbRYlXgwEtWhx9YeRtcMWaRvYlko7e4qIFlzad8d5DvfVqPGQSKCAcQZWSkmO4eq2OhbCrTyP6gMmBmQoLQGmIkB1ecVOMG2KeUU64Iqg03xeyB3W9d7XGItPNQwq2IkL+SLlkQKUlNv1n+Nj4OQUK1xtMz6bkIHuOL7Qf/+YS2xfGB2WVX+17tOv1/pl57YLhN6sdx2kREeMMZtkJOyPvQkGWXTBSsNMtKSSt8I9owqZIon6vo1t4FPK/2K5SqwIZq5jGS8mMRpF8uIva9BLYF7mC9ps1CjD1mfqR5qbY//Ce5S7JdMZmQtaoaf7YPyC8aVhNSsp3zIzY9vExbamp/IBRYsF+2KSt/jfj4xW6eWaskixC9M/IyahIzlootxvrIwRzMle23+fgcLxIO+JEcsMZrK+a5RNbNq0kqN0lf5W/aV6sjydnuExmU7bhmulbUlp+unqfLO8MgwwIZC/2c619yfJ/WQLFZd2fPWFUbBrcbrQIRIXz6ElqvupzKqtK9Ud9AQzj2AvTTcRwQ7NItA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(7696005)(2906002)(83380400001)(38350700002)(38100700002)(52116002)(966005)(6666004)(66946007)(8936002)(478600001)(7416002)(107886003)(86362001)(36756003)(6486002)(316002)(1076003)(8676002)(103116003)(26005)(54906003)(956004)(4326008)(2616005)(5660300002)(66476007)(66556008)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?E4+440vBJ+vuIGhYUwLx77Yg5aLSg5LGR9JizBPxIQqJlomTbmkmmBLLNGKE?=
 =?us-ascii?Q?UgdLkGNovq1lAyRWRTQ2eqKoewa0kGSKwmATU83tqnZNbLiJqVK/A6H7ROXc?=
 =?us-ascii?Q?vF+APoX0aAc8vjTJiTNDCTSViypBQmYopk03OECnZPMW6AWvBK/++8s4Sxcs?=
 =?us-ascii?Q?5RrWgjWz74NxI2uC663iUkbDSbZXkkjMpisuEepGa9uO5AiKHm1u+QIOCPBD?=
 =?us-ascii?Q?gh0ownE1aTfbGOB1lQdRlfsF1TIEm7AZbL6Ptnb1Hs9ef144c1DSTNg3FW+e?=
 =?us-ascii?Q?ny4nWfEWbcIgVSSR9eUBrnQfLcRswfoqO+xb8M7+SGlSJZpcq6JmtHFwxM/P?=
 =?us-ascii?Q?PcAH7wup56WkfOYTHtjKk9BqiOoQLbY3JxBAJH+URABer+6xIKi5o8BkTi1k?=
 =?us-ascii?Q?J0kIuyA7GdFkkL6tutIF3Kbay9jJuxzdBRbd9BtG/XAwnHlgBmAqO6AkO7e3?=
 =?us-ascii?Q?UmY4b8cg3bQ1ymNOtX5DId577dXZcAwIrM3kHp6FigqkCZ6JP4Oy+AvVonbc?=
 =?us-ascii?Q?bcGEK11k50cHD9DKFXcZRvKp+40QvV0BFxZ5JgDFpfP3vfxwNmltFQF/84sP?=
 =?us-ascii?Q?Z3ny0iFlvSAmPL4F9VeSVJF8+X+ZWAOkssS4LENEnDk4ZNeR4Gwe3P3X8oEB?=
 =?us-ascii?Q?fjdQk0f4UmkXXPojwi1S3iy/VUgQvUj1oMPjhYZOWN6As6G57+6wT/vP/9cy?=
 =?us-ascii?Q?SOtbUTowbvCr15xzA+/G42CNyoDR7wMa+zDHetNctaaU+uRyP45563fE/qWM?=
 =?us-ascii?Q?+mP3JBgQIlWk/O1pFoyAJD8AAZP8/FlAeUBYhhkwWRnxQhNbbap2OY1yYv4q?=
 =?us-ascii?Q?ImhHOb5VIdtE/UqEMISS3/EBZvqbOYWLYQgpwm+i31HiTdJrBYwlPPYxCqi2?=
 =?us-ascii?Q?Mnt2FAXZZoDErSj6HD9QGlZ7JER6Butr7rmIgdew5DQAfXJAv0oVRlC8V2i8?=
 =?us-ascii?Q?cCGbvdNFZI8tpjhjk3hkrZ4W7DB6gD6KzlP2Gzsm4zho5pQ/qnUGgmboabZO?=
 =?us-ascii?Q?t7LU8An+poIcnnDHsAr0q8NuP0JjIIg84gPGesYzEj8yCZBk5opGMQWL9/3f?=
 =?us-ascii?Q?gjez/xJzqaLC3PJ16yJy/9gtnMUUoqnkXhIDUbfj9BXhPy6FN1EZjNQc9MJQ?=
 =?us-ascii?Q?nMOUSBN9u7dK3WGBr+OCCc8cB3Gvj65OLWU9KxncgnIk9+SyHZFS0ubLqdKS?=
 =?us-ascii?Q?KsDFlEaECyKQjtfg1R+kEQdwtEFW0/JnCwQk/Gaujm1jPT5wjFsxJ3hhH0F6?=
 =?us-ascii?Q?RSs/ITRz+ZSQuTVJwO9QLJ5RukJQElr/p2HOYCeJq3RleNYJXP/q5SUoxJMK?=
 =?us-ascii?Q?Brs7Ip0WsbQHZApLMa4NOQM1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bfb882-4a08-4672-6883-08d9696b3920
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:09.4052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Wy5H6KCNKoDjwYzdQIZGeATRolB0rzGesFrilpPNpb3EyHMOmeQFP7MugNDubFYW/bf83PCCVmhIbyIxAl2/msYifB7dAxiCyoL5aj36rY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-GUID: EzsnpvNzBUapVABHvcnevMXOOidRwAT6
X-Proofpoint-ORIG-GUID: EzsnpvNzBUapVABHvcnevMXOOidRwAT6

In support of using compound pages for devmap mappings, plumb the pgmap
down to the vmemmap_populate implementation. Note that while altmap is
retrievable from pgmap the memory hotplug code passes altmap without
pgmap[*], so both need to be independently plumbed.

So in addition to @altmap, pass @pgmap to sparse section populate
functions namely:

	sparse_add_section
	  section_activate
	    populate_section_memmap
   	      __populate_section_memmap

Passing @pgmap allows __populate_section_memmap() to both fetch the
geometry in which memmap metadata is created for and also to let
sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
whether to just reuse tail pages from past onlined sections.

While at it, fix the kdoc for @altmap for sparse_add_section().

[*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memory_hotplug.h |  5 ++++-
 include/linux/mm.h             |  3 ++-
 mm/memory_hotplug.c            |  3 ++-
 mm/sparse-vmemmap.c            |  3 ++-
 mm/sparse.c                    | 26 ++++++++++++++++----------
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index e5a867c950b2..a5e648ae86e9 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -15,6 +15,7 @@ struct memory_block;
 struct memory_group;
 struct resource;
 struct vmem_altmap;
+struct dev_pagemap;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
@@ -66,6 +67,7 @@ typedef int __bitwise mhp_t;
 struct mhp_params {
 	struct vmem_altmap *altmap;
 	pgprot_t pgprot;
+	struct dev_pagemap *pgmap;
 };
 
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
@@ -342,7 +344,8 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_section(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap);
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(struct mem_section *ms,
 		unsigned long pfn, unsigned long nr_pages,
 		unsigned long map_offset, struct vmem_altmap *altmap);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a3cc83d64564..4fca4942c0ab 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3167,7 +3167,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0488eed3327c..81d36de86842 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -335,7 +335,8 @@ int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap);
+		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
+					 params->pgmap);
 		if (err)
 			break;
 		cond_resched();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index bdce883f9286..80d3ba30d345 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -603,7 +603,8 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
diff --git a/mm/sparse.c b/mm/sparse.c
index 120bc8ea5293..122ac881f27b 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -427,7 +427,8 @@ static unsigned long __init section_map_size(void)
 }
 
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
 	struct page *map = sparse_buffer_alloc(size);
@@ -524,7 +525,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			break;
 
 		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-				nid, NULL);
+				nid, NULL, NULL);
 		if (!map) {
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
@@ -629,9 +630,10 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap);
+	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -700,7 +702,8 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 }
 #else
 struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	return kvmalloc_node(array_size(sizeof(struct page),
 					PAGES_PER_SECTION), GFP_KERNEL, nid);
@@ -823,7 +826,8 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
@@ -855,7 +859,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
@@ -869,7 +873,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * @nid: The node to add section on
  * @start_pfn: start pfn of the memory range
  * @nr_pages: number of pfns to add in the section
- * @altmap: device page map
+ * @altmap: alternate pfns to allocate the memmap backing store
+ * @pgmap: alternate compound page geometry for devmap mappings
  *
  * This is only intended for hotplug.
  *
@@ -883,7 +888,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * * -ENOMEM	- Out of memory.
  */
 int __meminit sparse_add_section(int nid, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -894,7 +900,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (ret < 0)
 		return ret;
 
-	memmap = section_activate(nid, start_pfn, nr_pages, altmap);
+	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
-- 
2.17.1

