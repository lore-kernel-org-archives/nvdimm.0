Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2E53B53
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 15:07:51 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227BjMgb009281;
	Mon, 7 Mar 2022 12:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tSZQk7HtTV6HKgfK4W2uW+38Fl91pLiEqT8Zv3n42NA=;
 b=OEbR6mJhsmj0kOaRVGxfV3cnnR7El5b2qO3hGFI9bRB90jFFn/FQPBQ9NOpntVkGU6cL
 utmc/dWwlZLwf+ytdT45XBI9tKlUmpNxe/9a3IxgWzy/0CmMiDtXJcqZ4Nh2cWVLaV0b
 CHJTsoQdVkqdYSEA5VGyL+yUQe8HaaVgUh1Bhp60FWiksIHCxUw2D48HwCe4wJu2eM5A
 9kz5J+zG+1A4Y+l1twyXW6HKkQsDo/1JcX3XDYcUsnNNvEJWnGFbwo9lA6+k1dRpko4k
 rWXt9dOzp3EGdIN5IFGHAqrn7Mk6RZgyiHJNvltZ8zElqnRQQnxQo5v6s/0JviktZu1k yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0kqbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227CBWv8009482;
	Mon, 7 Mar 2022 12:25:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by aserp3030.oracle.com with ESMTP id 3ekwwaxjw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSqKIa0FFVA9/ZDmacFc/qsUo/OYv+8PmiTOhGAjUocLlRBZ6bdWTXZJDli/4WGm0/jb9ecLOZKrtqisa0PvtVPqBesd1oLLFhstwFEkKcv8pxFfMbk0CLK800GafzvOeX7NtWv/4rA4A4vy+dHxHJcuyEecidn7x2uP2IpVxdc0zoWQBhXDhPVhEtJrulObdN4R5C7c6DT0g2VURsc8OYrrQfsJR+z/IHZZm7vfUQnMi0Z3iAhFkvXBANecIfmzsBn/F5JcQcUkuF8WlJsD1a5+IrVe2JTsyGDgwYo5RHAjg8k3da27jDjIvMS0Bj/PU+YbSLIOLOOSbnkBlunKsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSZQk7HtTV6HKgfK4W2uW+38Fl91pLiEqT8Zv3n42NA=;
 b=TFviFZqk6GMC/BlvPrVOPyHo5qJP4mAeVw44E2uqcnnjZ9b2Kpb9WgsVDvah+inW0O3+HK+2gql37TqKfB5wyNcb9ksIljwUPFYPhXYBSTStnQcB6fiLojNSy9x1vH9B7V/+t3z+zBt8xX0FqIuoyBdA3qgJlQTX1J61r3HMTNX6sfBibqa4ri36Vmr7nbFXXTIAyc+7jbnsb7iHNF8krTR20AoOV2iC9shZOlIlf8ObNb9UNQZG1j5SoWEKqMTiIH+w9EirCkRgiEVa3t4P6OIbKXWpUU25WuInpTvjASITnOMUTzdLpwHQwoGWhLBbNHqJDprHRFMaYgIde9BD6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSZQk7HtTV6HKgfK4W2uW+38Fl91pLiEqT8Zv3n42NA=;
 b=DUwwB7XIQi6r5HaTZjK0pAtUEBtHIbI87mrWSDgJCMHKDXUuZQ5i9bA4qfmagSd/v05MCIztne65Y007SirrkH+Ll+840R3qWojlZxdKXPZdHTSf8Ri+n2CYMLAIQxUazQzMuNEErncWSZFPJ21HywTwDVs2mt27WDQcr/+udxo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3451.namprd10.prod.outlook.com (2603:10b6:5:61::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 12:25:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 12:25:10 +0000
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
Subject: [PATCH v8 1/5] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Mon,  7 Mar 2022 12:24:53 +0000
Message-Id: <20220307122457.10066-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220307122457.10066-1-joao.m.martins@oracle.com>
References: <20220307122457.10066-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 453137de-a815-4214-97b7-08da003585ae
X-MS-TrafficTypeDiagnostic: DM6PR10MB3451:EE_
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB34518B3CA53185CA3CEFAACFBB089@DM6PR10MB3451.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LHKmse3EH5CEQo+W3DlkLLeBY0YzFy/2+aYmGAkeGzsWTEpbgKqBhi5hiLDc3TXdd/xMo0acPXpGQbB0XyTRi/qvWZsu2oNJ27n5nn5Wv0y/ChRIbVTgx44CC1DSvN4SwzSS3a19ZKXUPgSnfTbVnFNrZioPqjvwXsfJeAiHZqWa1WsCdzW7NGUdm8CDxvEbrlT1sxfyyvLfh8dk4Zz8Ux+HBjdAJkVTbjrK25P5j4nzpiM8aU+NNELTD0ai+2b3hPN00lilHJ2F9gdTp4lprHgMlSzCtVECAPS8atrQcrLN72vJl6eyWZj7BWAJX3jn+QMgjZa+UWq0lldVB7PDqmwAYyKX7i38MrPCJaqlFVu0dyxwLEDEMYB3ixSd9vy3POI21wwT73WTdoq6iKl1j5+6IPiZhUgG4RHC812Jyk7b4DS1IHErYJCHneIiFzvFBwIH/38wSG0DKAEixKNRtRRT5HYgiwY1seRWWv9wAIjcfRJTX9kpCDOBYLXnTdoYcAaFyHly4FSHRBGxBdGtH013kbOUQOzAgFQngipamaU/5mPlZfnrkZ0Klj4xs2AEYgssev6jDmIe2Nl7rNOTMPzP1amtZOtOkpkXCa6Q1j3bFRQafXtDpeNQgg58K7Nh2zYqvp4dz0asof+DaJxQZgbZD6d9s5uN6tQ/mnf34UDQ5BmoB+KgbJgf0UuMYeNdZUyIpKiW1guETw9vC6mGDqIhTo36z2F/IuMQOdHcl00Kin+YItArmdLZ1w12M5RrJR66xgLV7VcmooFS0LekZRPv9vWMBNTSemSDXrqWHoU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(6486002)(26005)(508600001)(6666004)(1076003)(107886003)(2616005)(186003)(6512007)(52116002)(86362001)(6506007)(83380400001)(38100700002)(8936002)(103116003)(5660300002)(7416002)(66946007)(8676002)(66476007)(66556008)(4326008)(38350700002)(36756003)(2906002)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Tz6P0E7xnglvMns28ZcPl7aKqKKb94eCmKBImCTNRlxN+sxOI0APBRflCHpR?=
 =?us-ascii?Q?dyyQyqbNxCL7XLWWcmnMZdu9m5xQJQzACd+pmMK3wRPfRWaTFemtgTw6lT9b?=
 =?us-ascii?Q?rIxyxYJu6qpXSyFcJpDy3GScchvRjJiNnFE94vnwcGlsXJrQ4BN2Bk0xyT/T?=
 =?us-ascii?Q?6k3BYCOLq+195GEEuZjH/RhWvlXKfC5pKDFsRQG3fQqYtcD4kmrB0gH+cpvq?=
 =?us-ascii?Q?42qpNnJYJ/fpWZ2+fsNACaT/B1p1jp83JeUesdl+88Z19qtq4WQ4jI2puX8q?=
 =?us-ascii?Q?0lWcHecoQgWhfj/vCBANKdWOSktoH+81Z1pvxp9ZS1Fg50uk2ij2VpVXHzl5?=
 =?us-ascii?Q?H6QpJfW7lapfAi6OxMivx3bL8zx42rGq/tuCvVO3cTk6IYPgsNubA3qQO/ic?=
 =?us-ascii?Q?er1uUW47vG8CpgmLsr69qRON2rvAVlgda7ACIP0q8zEQJMJrGMwVW1tIXLOS?=
 =?us-ascii?Q?AVIBsTPXYJ6Iew+YscKzwVE5uV4a/I5N7KDSSAp5VRLbzaGUWc3PCZ4MUu5V?=
 =?us-ascii?Q?hxs0Z5Yj5Wcqd7Sb6YjGq+5UGcvyHUlrOnKaASuh3qnJelpyJYJQ5xpJhYgU?=
 =?us-ascii?Q?S5hSiWiqiNXeqFOUF6bbvVFFyru3g7wKi7q/jkJ2msmOyn5mDL3BtcaXbAaQ?=
 =?us-ascii?Q?ykjDifACeCteutgibXsiCmCKxiATDduO0zgXC01a7smEBigfXVPruGciBAjb?=
 =?us-ascii?Q?6XtmKbH75VVDDfuGt7ZD7f0LHbAg/5e6xA5C8vCvvf5ejApyDqggzimG4+l4?=
 =?us-ascii?Q?uks0d+S4wUg+yrksdumkA1H51Hs+OAH1UmEi7AM39j1spPj2SqdTzojfzztJ?=
 =?us-ascii?Q?kHiFquzy3Y3fV9tr35RqtzJRDKgOJqVs1ZGH62hWqJ8DdEUwWD4i9XmOCM9/?=
 =?us-ascii?Q?p2lCzsRNiQDgg0404AjxkxtzIIZ3j9Bh7rvjRGdJILCqhz8GnIJ1s1dlcDP8?=
 =?us-ascii?Q?zQXTsTwdtbc4Hnvy4W057EltgPSiMwalMm+rh7CmWE1V1ccxZ4XAZHJvYttq?=
 =?us-ascii?Q?AbSZY1drRopaSOOql0vabDE9S3J7oEFmeF3SOpWGlC15unbFNQ7fgnFnI77Q?=
 =?us-ascii?Q?DmNy0XbA8PWtP6XlL0JFpkTw5uuNhunqwKrcvprnephF+rPDdqN/gn82uqDZ?=
 =?us-ascii?Q?RwNpWRg9kd14ksA+bF0tXcDzIeNd3eN7/FbELvH/VdT0phdP4zLX/KWoLYOc?=
 =?us-ascii?Q?MXYwwtMmhj3a5g6A5q+LmBV2JH7CpEo58oAxOSkYHeuCF3eX6aJh83KM0Bcb?=
 =?us-ascii?Q?zXVuKnp8yJHyVkV7U45InmvzloDaNxntpyqjZ6y34s0YW+aio+W8HlV6vnHR?=
 =?us-ascii?Q?FkbhidKscwDUBr4BjcYbJ9VlMHXc2SReE/SIB7xRs6g8h4CEs5OPaZuY1OL3?=
 =?us-ascii?Q?BMxSwK1iShsziaBvo3HGEb2P88Xc9LItCxLaW8/HHdRvJoEoe4nmbxFTtQBm?=
 =?us-ascii?Q?v/Aq7YFsMvzesbY8HoquYDj7fTS+wcP1sEkZInckbhEfe6yg5nNffTRKpnC8?=
 =?us-ascii?Q?cmaUuxoxcOJwucha9vTf/AoSdL248Hou8EoPdOCiBrAuhMLGvtpk73+AV+op?=
 =?us-ascii?Q?GVUiqdkQ+25pmnweFRXxrkVROijy2BCAUd7/ghbgqSwwQwcIVdFMfONJkkvX?=
 =?us-ascii?Q?JjoB17ITB7pn7Qn1N4bBj4JPU6x3fWuws8CWclvEJbTPw/YhwCcwB2SiqqdE?=
 =?us-ascii?Q?0YmckQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453137de-a815-4214-97b7-08da003585ae
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 12:25:10.4612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaV/kViLZGc0rP0GY+QoKV0JfmJ/1iaB5Sax0I4aarGS1bnRXREzdRzeCnNfWiOKOCzWozmpAmKt/8Ln+GnB0sPLz9XU2XnNY2B9UmO97L4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3451
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070071
X-Proofpoint-ORIG-GUID: 8ECPqASM1YOu7hlTwp8pQ9521fPll304
X-Proofpoint-GUID: 8ECPqASM1YOu7hlTwp8pQ9521fPll304

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
index 1ce6f8044f1e..e0b2209ab71c 100644
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
index 49692a64d645..5f549cf6a4e8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3111,7 +3111,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index aee69281dad6..2cc1c49a2be6 100644
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
index 8aecd6b3896c..c506f77cff23 100644
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

