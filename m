Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E82570
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:00 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIZakw004683;
	Thu, 17 Jun 2021 18:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pKYL0aGuXtxzTFSh6/IVah9AqDIYJZG0fVE5+ubXmuA=;
 b=Lsx5652pK8lSbUKM9GH95tZYlsY5FJx8qT6j0ZZsjFkCVIepVFBvxCkA3Gbc0Whlo3yq
 AhRNNOPp1fNybOnHljnxvEpeKVVJoGprwQHh/X8CSNFPPjdIzQ4Ad5OslOJFvWqhQsy7
 qzQ9qswc0sQyr9FnkJhXuiumV0Ab/CHV1SBpaMIuqPw7bm/weX0rNLjzWDlac6UXVAuT
 coPwR0+eGJNrFcs+w85xSW+hj8hSkeXkQTkE2ZK342+lBINFZEvLntd49qvOIeXeKqsJ
 XPMq06j/pefXA9Ak8YPgj6wz1jHgYFxMT4zaOSEUR3LQJ+N4hsdq1ebUbCLD2MBavlyt JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 39893qrcer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjAlI109296;
	Thu, 17 Jun 2021 18:45:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by aserp3020.oracle.com with ESMTP id 396waw6w0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuPkemGXjQlW3FrWbmV54px1S/+awdkWr+cHnoBVYs73BFCF5npxxHAdjZCrd5+8w9boDuQLbNsVRWkcapoIYgd8j20rZtRg+tOEXJDB9dpQUBPXzDGRtItQo7q6oTpRXiT0Wk5e5GIHsKbvVVz3gz4Mtd861rjBv4BE2FUM+ZXfFJzIAlK+OqL1D4HrmHvqzVd7C4F6X5ZBFt5Qq+NkEDLEtI1rW/mHNuu2R31Nv9SBow7JvyYML7C9wRmce5zMsKOJ9ywLDR062CwY7jBzjd8tU8MOzCNa/dqknOYxngWDrNGFgX2ikKAwskMI0fHs5HGxvRE8L23sgSNdeP4K6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKYL0aGuXtxzTFSh6/IVah9AqDIYJZG0fVE5+ubXmuA=;
 b=BzdJcbSQyYxd3spmcrLGr2hol28sZxb74kTUCQofSzolIEZBS0WP6EnzhTgTwjrJll0IDqHyGsh+VB+cCs26Exd0ISTbQZ8YI6U0zAftfNu5x5RjBA/y3XjmnbYyzEPU7LzbirYGu8hWufuyPZpAyI9jihk9QEMT3GrRkTIlwzFGaVw03nMkJMDwp+pW8I/5YlpdyG/kuIz3Dcob/3YVX3zqtmSq2b0kaacLUUPQFmua5tszU7U9jlgJDhuhgpelJmbgAhjn71XsCuojpE49rGorWkmOlVkUIzws6U45YLq/BNe0NaVtaNQDv5CEOC/of7u8ka5fkhx63l0ShJT7uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKYL0aGuXtxzTFSh6/IVah9AqDIYJZG0fVE5+ubXmuA=;
 b=PGHeh6ybMySdWQC32ctd/AbUtEja4sGdm5uKStg1z1En9+n2osZjQhK6RmK2YXfUxrrpiM0UwHIL0vod55TuPCX0h//jkYLhaspw+2X8lnj75CM4e+9XD8DOvV4SPLoCBj0hY8clF6GcOHmsbT7FL3bEIc6hzI32NLzDnout6aE=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3983.namprd10.prod.outlook.com (2603:10b6:208:1bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Thu, 17 Jun
 2021 18:45:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:38 +0000
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
Subject: [PATCH v2 05/14] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Thu, 17 Jun 2021 19:44:58 +0100
Message-Id: <20210617184507.3662-6-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f4b0ca2-9c6a-44c5-5be2-08d931c01947
X-MS-TrafficTypeDiagnostic: MN2PR10MB3983:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3983F9D84CA3D49A5D3FB2CDBB0E9@MN2PR10MB3983.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LeQvxhNsLSfo1v7NmhXXKNibWeYxEQD3jaXYbFMT/xXGTZKkSmywYFePSUc+uxQ93exj+5NMOA09V2X8n9QQ8cio4snRuRxYJ7V7Z7dGPo8S9gRYOH1CQc6oaN5ZXnzQnv4aL/h+1hJH+H+TKvXhwEzQdSmAQHJotC0e6my7osYZ+fcQ+yqQRAd6Ym/VZCszKyTEy2q88SASAtFiIuZH1se1MvXtyTOYPW2Uo8rfJTF4lruZOxPpdUFwFnXVSKsBQgvPDb61b9xV+ZIuT4ayBSFrNKuKVBeEy9nC/UVHoCCUv+NZgvpNyuH6cDvn0cB06X9ojxoLwGXtyljXe+gk5LQXLFOL8voELFo4pg5X8uXwzfe+R2lTJsw+EtIKNrq9sFvcOwp0Q9/BaPUqsTzJKdexp5eaQgYKjP5GzA/E9jYy0Aim0gUoNW6cWmZHPET6OZ1UA6Ry8JqN8PSACTfr7omS+jyhDcgI4at80VUVeYxbyFEyZ/bKffapvwQXhJsVYLFGESm2nNEpZuOmquoxpEtAi5FWuKYNwWzGvpl7NH7qq0RJLpBkrU6sKX8nkeOqVqzvi4U7NUxA0urcFFlKH3HOxV04/IOpREjJhjHlnt1WLDRtPYNrH0ZzqE4ax02M/GZaSjSsI2NSXnjUsYlZ3tPhGNa/rO9M0NzdlLyGUq2jdYAHyz3R1nNApRJIV5d0lMCJ1VXq+NpS2YZDx4QdAys9MF9Ng8yYcdAH1ENYukph750Nhlq3OTLh41Grx8MHrHVkDgfnJELkFqlCGuqNYQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(346002)(376002)(26005)(36756003)(16526019)(966005)(86362001)(7696005)(52116002)(4326008)(38350700002)(7416002)(1076003)(83380400001)(186003)(38100700002)(8936002)(54906003)(478600001)(2616005)(316002)(66476007)(5660300002)(6916009)(66556008)(66946007)(956004)(6486002)(6666004)(103116003)(107886003)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?u05gB7T281fATkcKe+oXb8q968r9HsvuL0TuqmubLvhgc5EzZhoV1LXPI4tr?=
 =?us-ascii?Q?O4citw57KN01Gp98Tm6UHlA+9biGgOV9qzkjFChGAOclIVxBH/NHYxjNvS/1?=
 =?us-ascii?Q?mfq0zmVAcxTubr8CshIzPU/SnupOsIesGeCIkZoQpp4b2x2AZMtlDoRd1JC3?=
 =?us-ascii?Q?jb7x9/jjvxy/RJcdORafKF1PQvPFnTMNKnQ00ZcTgJobhUL9MwikDTZji4ea?=
 =?us-ascii?Q?gwFlZDSQnUq8fCGaUZaTQsn3xbDW0M2pnyj3gYZxCk4J5F9DrA8p1KGfCCyf?=
 =?us-ascii?Q?e7ZzDL8FT/5nKyZhrwH2glzdwqqTgEV7B+QylsJ8wp9ZweSKVN6U1rvX1PKm?=
 =?us-ascii?Q?rMTREp3h7xH+/NTR4ym/LDCiL7zlP1OM/eKI/1YefdOSYaez6ywpWal+M71n?=
 =?us-ascii?Q?ZTqtnVPO5wSeg6c6JK3U7dY+z4I5kn/Dbdd9j2E0HAVFr+glsD3A3Jk7nMtj?=
 =?us-ascii?Q?0RDF5c/eqIF6YKbi2OpChWN12WXC8o2W4RCGC//atfq5zgYm3ByG3awl+nbu?=
 =?us-ascii?Q?jHyd8y6OLDppVNYQRcFaFuKEOSWU9mpMUdgKNm03neI0M8TRLvKB8KWO3Wlf?=
 =?us-ascii?Q?Ljyu17G2UlKbjBeLlkQLAT/wOvTw2KAZFRJBmbOn0b3zcl46FSVgk1ujonPn?=
 =?us-ascii?Q?hoQHOZUu5GMWH233k3DTF4fVSo8Et+YqfsaX9tji1ShcDpHjxcG/RqMbyeFY?=
 =?us-ascii?Q?HjKaZOkza2Bfgh5GVqbtkioqNKQzoLKI0FbAnPki3v3y71CV8B8YcWhMjSd8?=
 =?us-ascii?Q?CpeT4Y3a/CDbx8yKbsWLWdEZrzXHn20/ZMh8SUdhEx+wUu+1dWj5bvMMvL0L?=
 =?us-ascii?Q?dmcb4oG6d5qo5RVbudQZZTYFR0qFabFFvFPcwiOuYzolwh8DhMj/eteE64OP?=
 =?us-ascii?Q?FPePL7nWAtAMbKZSvhKrmusa3KpnFzgg+5RRWdyO7z9e+emVfoSFKfx1XusD?=
 =?us-ascii?Q?jsKPEO8xlklUrhP4knge2U54yQYbdFK0Q7x1S+vViANj4c92OWXiGFVKKtYj?=
 =?us-ascii?Q?plPbgTHQenoxYyEQZoOfzilPmg8sfFrvhNktvuPsbx1bWuEzOdSqxO0FQcCO?=
 =?us-ascii?Q?305UZ3qjbSatEz0sR757PebJ9Su1fezN0vdG5pmXNqpaUw/8O06gIFJodWpf?=
 =?us-ascii?Q?UZbzlzi3DLO0wS5vRg1fPJ+GcLeoD5ltOv90Fq70XQq/zjNz2nWiZ0yAnGy7?=
 =?us-ascii?Q?Wga/TzqiC5w+QIJH3Z4L/7D9yJUtXJEBaZcpXenKJO7YQmI+5mSlHT0cGTtx?=
 =?us-ascii?Q?bDNLvXlZSZ9tKu9JYJJ9q1yJpC6XSXzDJDGrXagPTOVBcXQF6/IZK924hCfc?=
 =?us-ascii?Q?tcO1vHpLmohB1ruWm92QWLP8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4b0ca2-9c6a-44c5-5be2-08d931c01947
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:37.8797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6209z0NfiuDeaCdUVktU2Qbpnq7ZkYEqwVraQ7eFDcDoAebezk1meGawMKrTLsuWufEE7HHEoFbGWbjgq46EJxPXgEBtHjXpwdrmHpwaKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3983
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: 9Xtekw7-PNB0vgxwDKWZ1Pp_2UGHcEac
X-Proofpoint-GUID: 9Xtekw7-PNB0vgxwDKWZ1Pp_2UGHcEac

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

[*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 include/linux/memory_hotplug.h |  5 ++++-
 include/linux/mm.h             |  3 ++-
 mm/memory_hotplug.c            |  3 ++-
 mm/sparse-vmemmap.c            |  3 ++-
 mm/sparse.c                    | 24 +++++++++++++++---------
 5 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index a7fd2c3ccb77..9b1bca80224d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -14,6 +14,7 @@ struct mem_section;
 struct memory_block;
 struct resource;
 struct vmem_altmap;
+struct dev_pagemap;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
@@ -60,6 +61,7 @@ typedef int __bitwise mhp_t;
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
index a127d93612fa..bb3b814e1860 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3083,7 +3083,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8cb75b26ea4f..c728a8ff38ad 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -268,7 +268,8 @@ int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
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
index 6326cdf36c4f..5310be6171f1 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -453,7 +453,8 @@ static unsigned long __init section_map_size(void)
 }
 
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
 	struct page *map = sparse_buffer_alloc(size);
@@ -552,7 +553,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			break;
 
 		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-				nid, NULL);
+				nid, NULL, NULL);
 		if (!map) {
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
@@ -657,9 +658,10 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 
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
@@ -728,7 +730,8 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 }
 #else
 struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	return kvmalloc_node(array_size(sizeof(struct page),
 					PAGES_PER_SECTION), GFP_KERNEL, nid);
@@ -851,7 +854,8 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
@@ -883,7 +887,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
@@ -898,6 +902,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * @start_pfn: start pfn of the memory range
  * @nr_pages: number of pfns to add in the section
  * @altmap: device page map
+ * @pgmap: device page map object that owns the section
  *
  * This is only intended for hotplug.
  *
@@ -911,7 +916,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * * -ENOMEM	- Out of memory.
  */
 int __meminit sparse_add_section(int nid, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -922,7 +928,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (ret < 0)
 		return ret;
 
-	memmap = section_activate(nid, start_pfn, nr_pages, altmap);
+	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
-- 
2.17.1

