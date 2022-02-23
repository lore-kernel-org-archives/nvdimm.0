Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03866AB2
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:49:03 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NIDshZ001897;
	Wed, 23 Feb 2022 19:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vnnXMBZj0A/sh8+m2A+He/aevlDFglchx3FpBQ2zop4=;
 b=kAqAa6w0TQx3A2kD06aoPEaf7cu5iIs2f199oEqkyA1IPoNEiMUV/5Y+RwDwDLlQ3QY0
 6wOh5wYuDTwZflR4jegXw9Ksm1Pg/occeLCecJ+lxhO5wWzymjy3/bdssGmzLr0olB1o
 FTEWl4ctf3vwWr286g0BZfVNy1N1l2jaB+IvAulz6G/1p54QcZMEMIWoyhBYugUL/YFs
 FcVUDkUlZEX5OOdlxWWH+lsjbai3cYowmW5AWEWyjlWlrpwKcQupNt2RKM3p0L2JclsE
 WXuJmotUTIcL/RJjk8O0rH1ahaoVXZzJSmPrjhCDbOv1pPEc8cKz66PLTqf/KIk0gDUe Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6ew6hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21NJeWJ1047035;
	Wed, 23 Feb 2022 19:48:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
	by aserp3020.oracle.com with ESMTP id 3eb482vxks-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUpb6koK7aV8QYEOodtozXkhSsWiOuPsaHdePCBMYxbKFqfY85+6CFQ00nnGsWZpZ9BZmkkxLuCstUwol3lrhaeY74S/kOZzmu6AC6WttpzHIybSCX1EKB9C1CPpQVYerOMZ/uaH+WMJWlWfe6ijNNpiRUyl/F0fiMiz5eCVGfajEzR6BW5EzxSPg0jQJULaT7YXfvCCjAKqtNQHVlU2i9yKGb2FiabLLCpmgFjOfmHj08+HBg5iVendH1FQ3dx5txyLEfCxRjaTFQsQYHKwjzZBWy9WSvEZh3JJSR6PoU/vZ4qq9uNUfWwDnXdkiKiypZZe8CkHj2oTiuLSr+0BCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnnXMBZj0A/sh8+m2A+He/aevlDFglchx3FpBQ2zop4=;
 b=dn3eOzAtTmYyuny7XjIYz5vwJADNzjZUh9S/TVVdhKFQHK12iIa2zDDqhPQF3Mcc4FNiZCHRIdD8xtIUKXcO22oGIf2sgYjVyHKZznC4SF0cjEb5t6CWH4mUu1UXEXlpQC43VFd7MXp2glc6RGZdV2/TcoZC3rs0dWr6ha7d6a1caP21rnIzO+9Jm8Q/nvP/qCMPmmrKPzyhrP6uR1sbzebhXILI+zIWtu2QxmYw/qGJs+B8Ukv2y1iDlwobwS/8GgbWQTvsr1MJy4af+joRuXexWcrEADYkhrbKK9IjO1Na8IYX1hCc8ACoVnIJP38wE0TgP60nIQE22jYtj/qTPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnnXMBZj0A/sh8+m2A+He/aevlDFglchx3FpBQ2zop4=;
 b=TSz9n7KtpjMchz/kWp1pfH9w3Rmrz0wkWNGF8kKTnM6j+JFEhCCVTKyfrsZ91xLPKDmFy+JPtXd0YM5KNwXD6B7ymoO/jjvbNAiny6Ul3ViBYfmsup+TniKmWCXRluqh7dDZTRGrjnjUoV7G794ovfkHBv6dE/vJB2YSLMbTP8U=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4930.namprd10.prod.outlook.com (2603:10b6:208:323::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 19:48:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 19:48:34 +0000
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
Subject: [PATCH v6 1/5] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Wed, 23 Feb 2022 19:48:03 +0000
Message-Id: <20220223194807.12070-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220223194807.12070-1-joao.m.martins@oracle.com>
References: <20220223194807.12070-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0392.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea656f65-4428-4917-38d0-08d9f70579ea
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:EE_
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4930AA72FB0E136613376278BB3C9@BLAPR10MB4930.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ptx/laEjfXPj3ZO0d+B1YL3YCkP9sTDGu8i6bugbJHr3OQPFN2Nsbi+wBLdsyXtpny2IIGU856gwXoP4pjpZxuchLaoG3d579TbjV5v9fIvaa1GFeO0rbiz63/atZ2LdCJ7iOKoNFiG95U6+IKBmQzANlGArk/ROk76WG7xZA44s2w05a7R49JUlz7q0ahFpiwsF1Nbxw4IZMb078qyjHKw3nK5f8vPWCPUZmhQmRsgbCl1COaKWmlj68L2Y+7SQnKqmvdvYoyOyCiV5RmuFp+fH5+EVInHXyMI8s7MJHnvimtmsLYuL+hrdlt29XseEGN28PwrrlAAE1urk3jT6DoKenuyLHcu1eqOya2qk4pF8lxAvMGDNeA+XDP5hK3uYKGXVOkHh6/3ezHPVGR6xGjAka5kg8/VdtdZW6WMpWAAfI6N5xB9nF6Qatih3CyyiOB0uSqRl1QxYWLbpFLa4J4Xw94LIxGgKtYcKHEPvaQL/3w4ZoK3hIzobixkJ03lrR+sj+/iBZAFp9nN3F13spN3ikzTy1x5jXlkfk0J17ilNDO0SKIZpGNXjaFJVYNSXOVW+gfBmFiBLHnqrwCHWqX5Xv/IotCNNAmbeCNWucMk5SSqeP1g1yZ3Yq7wFJGCQjRu9lJTxgxvAmsC1n0BWku4TLofea5JzU8yVoOCFCWvfSrCmCBdFujWnY7nHFK7U2aZXSbJ/H/mWPgjXJmrbV5hgM+40HPKHQZ3gHwQM6aIryAYOiV9tnS5e5p0QA92ozy3AwiK79IC5KLrXgg4jOBjOH0HjMSVY43C6+AeASLY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(103116003)(6916009)(36756003)(966005)(86362001)(6486002)(316002)(508600001)(54906003)(8676002)(2616005)(52116002)(107886003)(66946007)(66556008)(26005)(186003)(66476007)(1076003)(4326008)(8936002)(38100700002)(38350700002)(2906002)(5660300002)(6506007)(6512007)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?u/+hSBRlg9/ZDtSRVmOYeG1kk2nAmWtSeM3DA1o71e6OpgPTuLdRAl7wrygs?=
 =?us-ascii?Q?1UgUp1r8rQcvP0FScMEoKb7hGOPTH+SworljuBtpBdLyVvwbDlt8eaGKD9Cv?=
 =?us-ascii?Q?OggbqqpmMeXbIn5BLUZI2nHUYmiX1mRw72QFFqzM3iZhfC0gYdoc1KASnTmT?=
 =?us-ascii?Q?jag6u6XzCqeuJ83R8aAmsm/+kcxJXTJUKVw6Os/Y469NGpOo2hFmjhFCEy1c?=
 =?us-ascii?Q?6mN4exn6xuIAunMmWjQI1KlpZ2D1EO8ChsYk8TUNWMZyFkf1W2mIk3fs7L0p?=
 =?us-ascii?Q?w/kwc2Dm6eGcLnR1FELtQYkcXrfJC7q1Jm+8YZrntS4cc3PUJKVE749/Q7pe?=
 =?us-ascii?Q?xg8FOd6dI2WuWh+HOqrRMZWCmnC6sJ4kof5+fJMdLwXZVM+M/WVp1EgGFbfe?=
 =?us-ascii?Q?3UZoYrzk4+SUlkpQ/iR48jGV8l4wPExgWDnNxACM9S1DijboWvpTQLNV5rxh?=
 =?us-ascii?Q?+2mmjl/xZ6AGEKptFKpgZ3A9HHTIqvLdWddN4qeJ5qFHE2MWINp6py+1chwG?=
 =?us-ascii?Q?p6O432DZYQibm3s2LwwfoDXH8gIJCnMvYdWtYYzuxyQfenOyP6D1NPL+Epxq?=
 =?us-ascii?Q?ays/CtqKs2+F4ZQ8+crINur8WZRJVljNC+5jKKRB3+X/7p5HUthqD2VyIA7y?=
 =?us-ascii?Q?CZAKzQRoFrozyaJe8gYBwjadUkLI4KDAtUiKx5IKrvkq0LCg/lhCh0dT0Qlo?=
 =?us-ascii?Q?3lnYY4phwJMjMSJDd2gPAfhvUbppPv9gxlJxR4LOO+/zKbOXt6uyKA6e3B1U?=
 =?us-ascii?Q?8ghywqT/+3MOwo7GtmtP8A8wejEbg8vdAr+SHSjv5sOVVqKvO3p4Pzpi5Pc0?=
 =?us-ascii?Q?fTFVnuHem05J6zHq/Gvk56y3tatNl1db7gjPCPTU7koto5s59LNXvZiO5Bpd?=
 =?us-ascii?Q?w8H7gU7djEPmbH1f432mf2k1D09ALo1RePC2gwHRfuPDRnTxJciIn2HWfcKO?=
 =?us-ascii?Q?LUrbCzM9IUxfuJOnlHL3L1pzM3pw78hXLZgHSkofq4/hJ7y6Ncf8bIkHjL40?=
 =?us-ascii?Q?58Fu7SPAXDtot9q/ITf+Z2El2AS9RbuAV70wwOnEc1F43UosqknPy7+gPMdJ?=
 =?us-ascii?Q?uJYpfsmSWXlTx1RDM4IlZuxOw291q0ldLt1pyyKnCVexTK8zOyrR3fFMWLfc?=
 =?us-ascii?Q?Y8/bs2L1s//v2/oDK5jjVWd2gHHGszVj5rvYnGCWT1wx2A7jbVtvQo8OIQqd?=
 =?us-ascii?Q?0N0gPP+fi7ikre0iUzQE2TWD3VpV9mY6vOSTdf0B5ZemrndxlTyYM2S/Nq6J?=
 =?us-ascii?Q?Brk+VZEc9BNpWfsNEh5CKvIgSA0eoMHzLiApQqr04F6niFounFCvb3bkzrJF?=
 =?us-ascii?Q?BE2XF9XbFadaSfrBdUoLDLnk8+ICh5Gaw/4nQRfSLZS6auzMzlanbLybflrl?=
 =?us-ascii?Q?csu6uJPoNdpC6lEQ5InpII97WhVgFfKBxKkgQKmZXadw22AO0FUnI2mD4mcy?=
 =?us-ascii?Q?h5nx1r3R0guIKZMww8PlO4w74qEB74fr7Qm29k1PSa3juS0dkh4whIsfnsVb?=
 =?us-ascii?Q?0qa0Tv63DjTOtm8vJRd+cdWzbgRUuH0QgCDDXcoFRBGJs70o8covJvUSZ3Ls?=
 =?us-ascii?Q?y91LKcpgbZ7CysuNEXVcyuNtbSNqQACfQJblpfuZRqGprFXo4D1rGPfxoSnU?=
 =?us-ascii?Q?+UDfxW+/nEMprDdZZm0KGsFTnRZKVC9m/EPBg1ID2tC/cAJOGl2kntOOBCaE?=
 =?us-ascii?Q?F19TyU2dYqpjhSgz9cSCrMFasFg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea656f65-4428-4917-38d0-08d9f70579ea
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 19:48:34.3800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKO49jJhYgmzErWBm/I7AW8mhQf+NXr4Jw5Cfb/+eeTXTDcSSpplmYW8pt+KlzkmWV9yxV5rEFrwwtB0KoojLOHlvjvAL0/BjRA0MaHqJQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230111
X-Proofpoint-GUID: sPpJJFvvbeDLXd2Oo6g_FKY5HC2-TKYc
X-Proofpoint-ORIG-GUID: sPpJJFvvbeDLXd2Oo6g_FKY5HC2-TKYc

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

