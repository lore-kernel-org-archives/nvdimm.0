Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400E3185B
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 15:54:23 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KDh2Dn019815;
	Wed, 20 Apr 2022 15:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AwJmhFsM52ANORHnTZ5JeadwvF5WNYlOh8ukDsPyOGo=;
 b=tjiReahPAHAyUH3gm6jiko3u664kn7TINBYUw/FBceX+ziMDDEfdtzYW8ZY7nykMjED/
 h0dYPrRhm2waoTwWAmdz1AwwcDx+Kibg+Se278SYLg2jL7jDROhdUONIvCtjXzNLWxtv
 sr0FdwurjjHUP/kX+aILAef+zIUzD7YKJYtDXYBy5Mr+HrvFsppRrinz4DVouPO2+qNb
 tSE6DjEA8JqAcP51u2xgwxIAmLAhaMuz3kdHYukAFW007bWHjzLiD+0lgx5xVdS5A0pt
 qAmtN+M6dxn/ijAE5pNIMYOxnspHHjUknWTccgb4Z/RQZCaCKmSOeqqPlU1pcGtxR8yQ Vw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd19ka0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KFokjG037654;
	Wed, 20 Apr 2022 15:54:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm87c890-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDXAZ63Q3q1Z/WtzhwY7HHWkNYca5cwyynzuxm96sCXPGlauvOeYk0FaTNr1vpMOxuMSYLAAiETd6EH7gWY5rGYrkwONKSCA55dNUhEPM1Dd0RM6FZsAMfXX3d5ZLfQwl0hhGGnugYUJk/ktAFXaEy+k/+kcgQak4BnNVUWgGYFvdE3HYif/69n/mFXZfjJAwEQFcT204Op1gDRUBkwXfaIHTjQ31cKFGmPYWtoaPgXB7fdYhtPlTfRhXn4xMYFqwhYJhE8JdCRbLsdwiWRSg/6TFDbAEKIz0bBUhmBjWomKVZOynxSQbYRu5V3997//YZJzKun2zde5H8bBJkSaCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwJmhFsM52ANORHnTZ5JeadwvF5WNYlOh8ukDsPyOGo=;
 b=aFTJFvUthPz6YBM2IstKffvy/p8xcph4ftzmPQI7aUv+F1ash/FznLmo7G17MIf9ysah4624S8eBhoPZhMcj/Wy7VdDkfZZ7hBEO3zAD+qLSlXuVfI9n/OZiohQcq+umlp4N/ORmFPnxNpJ5YhCEX9LGeKw7knzTj4V+Vl+EYOWqE7pHco+CZhL0/5jSeHyifBH3RSeWCf5mlyiNWEEbOO0FA0H1YYoUC93arDf1Sj7KZrCyQwgs7HdjkeYtbguYGXqPM0tx14Xs8R1mT6UdXxNzGLOQkHfUiUWUpObd53byuE6rzRsEkgpcYjnxcsFoWTyVkCTgfsbhm7DZYQoJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwJmhFsM52ANORHnTZ5JeadwvF5WNYlOh8ukDsPyOGo=;
 b=azb4dg16di8vEa7QVF9n7+uKFKAnzqNHRJCufLCqGwfrxRt6OA4xl4KhD0bMyIP1yRoMgZ8ftSHyjRexyodMYsAaL0VsvrFmOvB7BZy7hqZjbRmQd2BfbAWaga9M3okYuoCaX0sdXpL7eQjXyL0UirVb+0c0uov5uRYjD19iVUU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BYAPR10MB3046.namprd10.prod.outlook.com (2603:10b6:a03:8e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 15:53:58 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49%4]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 15:53:58 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: [PATCH v9 1/5] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Wed, 20 Apr 2022 16:53:06 +0100
Message-Id: <20220420155310.9712-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220420155310.9712-1-joao.m.martins@oracle.com>
References: <20220420155310.9712-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a62b5d0-e1c7-4e8b-25b7-08da22e5faa0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3046:EE_
X-Microsoft-Antispam-PRVS: 
	<BYAPR10MB30463C6FBA04D4DAA0A51091BBF59@BYAPR10MB3046.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	z9UymbEjPHGlA6C1UjlaORXV08PtSVm/N3rVpt6lc8R9fkyEhaNv+tIbxRvbPn9nmcwoiEjci0fARpPzUytp513y69P6LO/Q1cuvFY8ImTZ8KcE5rLpeS+TJa+TpsPBX03qX4NR25R2YntGHe5IS1GIUG5gXnjuAMZAzqm9HEZnsJ38UYECqgpQTHcEIdCWD/eB3w6rX2Guf33BaX1TrlrV3s7gtExSrF/a6n/zrHXq5xNm2GoKEOZ/a46UNYDgEzcVUASNt1QTKuzCXyZNYuYht9hEY+51FCDsl+aBBMQoqFj2t3Hf3l62ly+nklWybtNxIkYm5qfNCgW4hZfLQBh6fRkchRBRd4EC/Ks1EL6I/pu4FwN6XaY6gpTbhUQkrMttpSb/OrbTm/GgTsTscpB3rIUCxg3KF0Z5K3jybQNrjrPZlEqNIhIZ/n95edCWjabdKv0xrdTa6/y6+9TUb7uDdOJ20nUtrWbG5Y3xk+mwzvGYyeyzLBAh4mkFWEUGAqJdu3iJManOn7VLlr4z7Kf5N0UrR0KDkM7mIkgTTeQKtLuvNYLsOS5xxXpcygp+RH0jv837zEAqdQaKHHH44jxnpY4MtQmHRTDd+QfnXKBLfV3gtDayFuFl58b4kMQ4Y1BxSTAYtjekyrADiXogfCixEaJKUqaskp02rCqVUIrWomySXCGNnYuHfTdju40q4d67VAj+Jy1nqlwcXWyD4dizpZ1TJawID/wnl+jsIKIDbfuS5/kn7AIUXkGAtrmnPS9ZxbXXA5m0NDt5kd6sXu6qhHXUfrxosaVg6xMpKRRQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(103116003)(36756003)(66946007)(66556008)(186003)(966005)(2906002)(1076003)(66476007)(4326008)(8676002)(508600001)(38100700002)(6486002)(38350700002)(2616005)(5660300002)(52116002)(6666004)(86362001)(316002)(7416002)(6512007)(26005)(83380400001)(54906003)(6916009)(6506007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?GGYK/8T0Wz3g4iRIFG50pZ2WO7ms7k+J+SBbMss3KhBqyEsyTOlBNsMysezq?=
 =?us-ascii?Q?2oueklJnccgbFLBq0K8gYzwtkGEr3EibzVdhT55AYkRAthkd0rVcVbk+Yz8D?=
 =?us-ascii?Q?PXvf8ONhUehanocWLvRCVWewyLbDYb3Bww8oSq7BsTBGiDvFqxSD7ahiuxFP?=
 =?us-ascii?Q?/P/hYljDuXl0YRd+u11GomJlETrmZkHdR4Y6Er3x9B4/w9NiaoQAvDU9cyIj?=
 =?us-ascii?Q?oFwidOik9QoLzGn99hBgXRmF3prvUX1IllWvN5KnQLUZWZZTqpWeMacrz7hB?=
 =?us-ascii?Q?DsA8VTdZ9ly6964PeVAvJY97hKTnqniVpdvlBMlPVISTBnx18RviasNC27BW?=
 =?us-ascii?Q?x4m2nLmfXuzrwKs7M414Gf4NzbRqwhfZM/Mm/Zn2qdRMgyhN+aUOB6ZJc1an?=
 =?us-ascii?Q?EHqsuKz2RbK19eepVe2H+1hP0TB1+S3JU0JXOf9v67NkL1i2jeVBor8N5+OB?=
 =?us-ascii?Q?+87zOIyIanWj/GBOwXIqSwhcYQ1/b7ypee0AE6Wlrh1gSXgDp1vf3OGtZZjs?=
 =?us-ascii?Q?D5ZGIs+/8B8bTclTUChJ+kcA21ztfg0sX8U2rGtowt8ul/C3ZC6iw1F264aB?=
 =?us-ascii?Q?b+MiKUw5K9ZFXMrhFx0+tMUqkcxC+wMFyPj7zqmpFY9xIEo+9se2eou+aOKO?=
 =?us-ascii?Q?cFaGR5+a27TckkPOBZ2Xxu3NYeLLN0wBaDkWfSQ9oJWVDr9iwCUPrgIhxDNj?=
 =?us-ascii?Q?5ZSK/YIqH3qgxbD5pKbpHvHI2gGBFdMi/h8UDkcezbFPBstnZjw6aJ0OCJWY?=
 =?us-ascii?Q?QKsVCQ00S+6G+MCRbo8Rxgoi6afViMNDZ+OtUL0l9YTDHXkAtlYoFjYR0fOX?=
 =?us-ascii?Q?TaNJ6u6tuEEtE4SdX9Hggf80/X2/hLc90WLr5f2wznbd5hqFU15q/USjeXHe?=
 =?us-ascii?Q?t40SXA5UKBMwtkpWy7NMtP03UVbkf+xQ/LDPG1o8rEtfGUF1uzDLJEXRYuAp?=
 =?us-ascii?Q?sC1VMuyhoiCzpF3RlUxLZJcQFShsJCA2Ba32nWrXUXnEB1A6vfOG5DSE8Y4O?=
 =?us-ascii?Q?OOeK7YedSiRFILQGFWq7ncorZDamMVSft3TMQ4rdD2f124WygBKfJ9EqiUJq?=
 =?us-ascii?Q?QPiEWjPKD5mTKXjuHTc0V0ch8/dD3Pd5LJWpFnFQcBazhhBNNNn+XuppGQfG?=
 =?us-ascii?Q?HUfOaGff9VCZ3ggyCPju0gimy2aeqqLHpixJTtL11MC0ub3UmDUsdJWJnBab?=
 =?us-ascii?Q?QkTGLsesvA4ecLmyh2LNcfRehBP0yhWGKk+LoGNoJzrQ5zj1OzoNEAfxGEBk?=
 =?us-ascii?Q?u4XWRGG+bUez3kQo6eUEwiSj5ZOInPhUp93kftOEipOlkiegWAVsHmQuVmUz?=
 =?us-ascii?Q?NJOVzDLietiDkT/3FjE78J/1strhvGEmj1p0fXMrmYUqTy1XK7tly2EUPqEJ?=
 =?us-ascii?Q?v94tPSxV5HssTtMmzLYyeXZ1GWDUZL4Twx/8vGYzW7aGI1zTJgzXc98kIwDc?=
 =?us-ascii?Q?pnQignydy7d9ql3Mp8iQnJlGSgkEVv3gWmT9GRIlTr0qgJgm1H7Vq+3kcD/o?=
 =?us-ascii?Q?6LMiWQ5POq7jFK+kJy72CxgkZ6qqzMlYo41L81W7Q2Dp5WW9Rqm8uwTOeR/+?=
 =?us-ascii?Q?A2HpyBZuGpywY1hb3FOYcCMjB8/bvopRFiG3KO7Rnt65miTbgw8mEUNulRTn?=
 =?us-ascii?Q?hfzEef9voBtcEZZNYStxZbF7ueWyq4zy8VEKa/orvn+x17gOLbebEEww9kAI?=
 =?us-ascii?Q?fTmk88anhargL+oGLK+HHCfViT/KoRH9yrIY43RSzFcp7xHHLAf+lhDVQKdX?=
 =?us-ascii?Q?4YCxvFZ1ywygjIJulUed2OtTWsNmJvU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a62b5d0-e1c7-4e8b-25b7-08da22e5faa0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:53:58.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ay69S1yjLOzp0WjdVJer8EA3s7ZgfttZJJO6PoXKT4gFgS83kfAMSJoIVRRW9h6Wtw5sqb1mNwPrneBd6veSDrsbqDD+fEdgOgwfszP9aZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3046
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_04:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200094
X-Proofpoint-ORIG-GUID: YFJLfdUTG3Tf5Ey-DBNPrby1bc-tZIYx
X-Proofpoint-GUID: YFJLfdUTG3Tf5Ey-DBNPrby1bc-tZIYx

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
vmemmap_shift in which memmap metadata is created for and also to let
sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
whether to just reuse tail pages from past onlined sections.

While at it, fix the kdoc for @altmap for sparse_add_section().

[*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memory_hotplug.h |  5 ++++-
 include/linux/mm.h             |  3 ++-
 mm/memory_hotplug.c            |  3 ++-
 mm/sparse-vmemmap.c            |  3 ++-
 mm/sparse.c                    | 26 ++++++++++++++++----------
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7ab15d6fb227..029fb7e26504 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -15,6 +15,7 @@ struct memory_block;
 struct memory_group;
 struct resource;
 struct vmem_altmap;
+struct dev_pagemap;
 
 #ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
 /*
@@ -122,6 +123,7 @@ typedef int __bitwise mhp_t;
 struct mhp_params {
 	struct vmem_altmap *altmap;
 	pgprot_t pgprot;
+	struct dev_pagemap *pgmap;
 };
 
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
@@ -333,7 +335,8 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
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
index ad4b6c15c814..62564d81d8cb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3202,7 +3202,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 74430f88853d..8257e2e619c2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -328,7 +328,8 @@ int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
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
index 52f36527bab3..fb68e7764ba2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -641,7 +641,8 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
diff --git a/mm/sparse.c b/mm/sparse.c
index 952f06d8f373..d2d76d158b39 100644
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
2.17.2

