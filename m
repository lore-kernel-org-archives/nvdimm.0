Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A234285
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 21:33:47 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KEmBd028284;
	Thu, 3 Mar 2022 21:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tSZQk7HtTV6HKgfK4W2uW+38Fl91pLiEqT8Zv3n42NA=;
 b=NNi3mXIfA4E8z6zW7TaVUoJ26jalqyNnK53VZpPXQly4JBIkfuMwjbIxWsFYHBrWYRb0
 LUBrF1hLMAHr+vNN4N7WZnnEjt7O92klKR/gD0t7EOI2pjpyy+UvbL40jJq/uQ9ducT3
 SgV5boN26xE7s8xThDK3dXja7CvneAr07YohrsJsroyQgI6aWTYkxNbNmEgnKkdVFn73
 c0h9y4XmWG4A0/pLmx1nQUlqUCZA8+AXa8hB0WJ+UtSPjbAfiCexXCIQLnAmvNbAEiWm
 +y0Ml1/Ax96n0dYDq9yS+gHWKZ+xwL9SGtP32psOsc/JBXGcIdf7KxZZfGHD4J/ImN/E Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hw05h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223LKtL4132075;
	Thu, 3 Mar 2022 21:33:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by aserp3020.oracle.com with ESMTP id 3ek4j7tpuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UC83XilLr3JKBezPskIKDKJLxFJ8HYwm/pNNZku636vxcbpe/emlereXT6LjiYpyCmXV/rdnh58aO7EuDrwAnyPq+q8y+wbHGXWjUVIow4T5I6QMyly302nMos1oizs+NVWxAvpEyNMSRMW714CPoIpsh9e8dBaPYmKf3cNqN1cuPL7XU+MyJ3tGCGKidicx/faYl8RgjlORqg/aMv+pee2nLN/V5UFH9OjRymLVxvnvpMb6QU6DCRK5Qy44XHLZIM8IgPtIrGPRO5Ym8YLoA9WkIm9dvMzx+E6vGkVcGpOuSZ3duj5h6XdXLC+xv8A+kE0AVfVnGOvq1+0QjuuUzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSZQk7HtTV6HKgfK4W2uW+38Fl91pLiEqT8Zv3n42NA=;
 b=l6llHqq3TR0uENX3LSo8dUHVVNkjsfNiQt2RQeRBYxxomnZWaoGG259nZR4YBX/NfQa9V32IOaEo5YE8CksOfs6gk9OqGFiMTIud4G0Ik6HCWyNuA6K9kqPbK0EYdDi/HrIkUVSxqSBK5+ETv548r/2HWk9HdV3c2HsR6gGQnzNLrljOJ+rVSFCYlo1KZiqaEKie4T7KapHDKCWBZ3rxoLXpIrad+jmCe8Ehr67YCfL/0bF3LAhu8ybeBARfb3uD1mF5My5SnU5bRAtmCz5diV8jkruu3YZ+lEBgSnRJdcHt6c2NklqfpaVU8TtMUyrgb0vd1L3jPHLTHWGmUrKklA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSZQk7HtTV6HKgfK4W2uW+38Fl91pLiEqT8Zv3n42NA=;
 b=vMAIx0v9hKMb7sf3YzznjNNJ9asKanXkYoKzFuX3CdcVEOBUknu0vL2BbgAQSfvKDfp5gTwT6SOIAMZSrzkWhFei5YA8s9LfG07KQOWRT5v/mSNovofe5q39FOYqn8t42gRRhGHFzEIeTm0NwPhjeH9tKRfPFseJ75GrEWxcQNw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1658.namprd10.prod.outlook.com (2603:10b6:4:4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Thu, 3 Mar 2022 21:33:28 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 21:33:27 +0000
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
Subject: [PATCH v7 1/5] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Thu,  3 Mar 2022 21:32:48 +0000
Message-Id: <20220303213252.28593-2-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: e1f52846-fc26-4da8-2609-08d9fd5d7427
X-MS-TrafficTypeDiagnostic: DM5PR10MB1658:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR10MB1658541F5F86DB409DA99383BB049@DM5PR10MB1658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qbnyFD1uoeG9mglRwqYyWpfL7023H4os2BBZcQSVLMYzFJsMKpbOM0rK8r4OVglD96oWzzGGNM9OLjyj0mn8LcByPNKnYE65HuQzTB5SkMJtqmfBW9DlmLxfLtNIxrOWRYap7hSyYD+G1XJxXWnwFkuvA/j1rCdjp63SQnA88aThOIQMtvEFHEbjDMKsaRVTttLtCfTZvMzbVoaZM9yP6PmhAv3H1sv7dSiFPFv9kDi5YVPI/9Ivh9ObF1g8aFkmlGfyzs0WIKNzVqAHMrHCbpsfApySGKq7YL2T+p39VLFhyzjoBjp8StaLTzyA8ND0Lr4U0C16Zpu65ZPfEe2hNaXs8c2yR7Ot6aAN7UEzNZ0Ussxb6JTiIoLTU7hfOLDPe3zuOLREPRDFyzpZFI1T5r3xQcEH0M/Ec2bc7GBJuSE4LYRldrZosuMyBL5KtXbFMThbB25bXNaUsr5c9i47mewveZ1zPyyTvzUserlgKnpxu9HgTBR6QiQd9wTBA8sSA45EO9+kgvCWeTZbTjEoyJIwaQrukzsTOFburCRYNp8+fgm4EUHSxol2UvSf8IVXCbblWqfozOM3JjrXaIn8FSBo+VJ7ltwQgkThvDMTpLaYuxeYnKAOjahNimMHDOklBD5l9wTkrSgjgnhTDY2EHaLBSHC1O/GVALpYcujkwGezVnAcRT4xHJBS71qBnvZSFBrfSeKi3oURvxd5Qimh9tvCfum8sT5w6P1TDjGCH1eWX4A/SmMSplRVUHpZp0oaPlnUfvmR30H86TwYON1/4zZu632cx+LCa39/y/xUq6E=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(38350700002)(186003)(107886003)(26005)(1076003)(5660300002)(36756003)(103116003)(2906002)(7416002)(8936002)(66946007)(508600001)(66556008)(86362001)(966005)(6486002)(66476007)(6512007)(52116002)(316002)(2616005)(8676002)(4326008)(6916009)(6506007)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?h8rc6vZYYy8swO25dBiv8su5NejdHehnleGw7H0FDsJF6EwIdF0JUaabWyOi?=
 =?us-ascii?Q?IrmqtNhNFRq4e6ogkqYnEpgNZD88d/kvQIVVEo+sgwFkrRbg44b1w2wh5JWa?=
 =?us-ascii?Q?T7ChBZhiUvuyuE8Ea7JiTZDVWHubjI2/UznqzNU+Zbao+ry/JGhFXfWt405+?=
 =?us-ascii?Q?B/Zyq+kkN9viT1vaO+RKKWuBC72BmyOMHnBXWTIPEqAuyiPWO7VtuWm4qoXZ?=
 =?us-ascii?Q?RVKGEIIGwNGKk1Yr0YY5HywW4R7tZfFN4kckwGD6KCCFmcdTxmKO4m0y927F?=
 =?us-ascii?Q?n+QorHBNhp1gYatPP5zg37EtR08jy8VLO/R/oypFnh36b+R83S1HBzgxVYMp?=
 =?us-ascii?Q?FEW7YpntpZecawj0iZ7mG6HxVTYCfmbK/LhRnGPEcZxOrhmonj6sX4fhjNlp?=
 =?us-ascii?Q?ezjaotwV3f6akM60od95lh58D57uNK3xqO0OM8zZLl2jVVpFw1mes/IA6fA9?=
 =?us-ascii?Q?fvD+6CCkCLq991nToRsHFYCUn1a6VSTqwuCWyw/YONKAqxS9CX08QBFBQkob?=
 =?us-ascii?Q?Ww3b+EghD1J7iOIigNSuRdvtpDMB6Y7n5wJScIWdqyHJgHf02bEj5X3rgy6g?=
 =?us-ascii?Q?peChR4/d4SFUXnZsDvFNSnxdAK0KblxWNBvjUL6i9qKsq8l9paWs1istBdDb?=
 =?us-ascii?Q?4jF2jrM+DPmWsylC6CqQjcuKLNdeZnmXvNgcmcoDSLKXC4CHcg8PWMyWm9+I?=
 =?us-ascii?Q?1iNeSLN4eu+r9fqe0nMP6cipuxmNOFhx1xrESeNy8LHbPy1u1wqHJ9UgIlAm?=
 =?us-ascii?Q?pJ1sJ8D64K6etz1Ja2a3P2MBRBj1hbOqjxXsx7Ue8eUPm+MDfFP5aDLvOgoW?=
 =?us-ascii?Q?8jSKXuTbNyPHsjTHEhzLY+aqaz0dtABJmt/ge+HaQ/cWQpraH1uHUn/YaMY7?=
 =?us-ascii?Q?nGWepmFQo+NWMn+j3IOvIxVSnWsV4DddNq5jSPD5jja8KGBtUUMu7SprNLQe?=
 =?us-ascii?Q?boMlwux3be4cuGFl2QUwTvRWhCGHHoKdyWxIXZ6yYJ5NL2Fqo+rT4lg9PhTV?=
 =?us-ascii?Q?UD2NRavLCAQocyWIqLv0cgzmOcYrSix6cs/OJB+MLNo46vf9dycV6S/1NYVc?=
 =?us-ascii?Q?PdSWR9C3KHsTs3GH/TSd/h9HjkI4OHoJpYW3BXOAA1oIl4+7/FHz64e1OCmD?=
 =?us-ascii?Q?bOfcMUuIZgvqQTEn9bsVDLxZd0e3tzDHgwzLjPja+988+QnbshCME+o0LUCn?=
 =?us-ascii?Q?5fXoBseDyfiefoxjpL9OkOkH3B06z1H4o8b+DEkdePyv9xcdaEC0oJ6dJnMf?=
 =?us-ascii?Q?cPgyhuWyUonenAyTbT8+av/gS6hPZMPeHdt/EhcS9w22sZ3gX2ZNHYhzYXjl?=
 =?us-ascii?Q?e/DlrgYgkFVsCb3J9uZ0fFmH4eVQ5s4/n8VA41Zq3+gd37sPv9bOgV3IUsEu?=
 =?us-ascii?Q?f3Mz7xvSBR9QswCaQxOSumdQNnnN3MOUxBBnIp4ZVMtoWaVOvvnvCGclX/88?=
 =?us-ascii?Q?p0ZoAryRvF7461kZUDt2DAdzgWLJE3rpcAPJftOTK97cJBWOn5Tb1mxC6qsB?=
 =?us-ascii?Q?ZuFKd4jMPQY30oQXPu4GEJPE2CiMCk2svYBowWeN4eNUE4rfTtIGLOqZCjhT?=
 =?us-ascii?Q?Jn4k6CqGzqnbEFDqdlAddNQ8QzOjMuOX+/YwBAqAb8KDGS2ABH71nh+g5t+x?=
 =?us-ascii?Q?PHoEncTPyYBjvc/CaEQGx+dHFiuoVCZIbmmv0jlJiUloXxUNLMVPhP3XN4Jq?=
 =?us-ascii?Q?haT3ZA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f52846-fc26-4da8-2609-08d9fd5d7427
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 21:33:27.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+lmIZJjXRozyc11pSVaMXCmfho1KEMygCA1yu2kq6BXrfBAA90G7N5v81zxe3Hj4QZte2UfeRSR880V461ODZyrQw/NzeH4vAJzvR3HNfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1658
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203030097
X-Proofpoint-ORIG-GUID: BovjFyJCuuIEa2U4vJc4ofjv6QjiMz6x
X-Proofpoint-GUID: BovjFyJCuuIEa2U4vJc4ofjv6QjiMz6x

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

