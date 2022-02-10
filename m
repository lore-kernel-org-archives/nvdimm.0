Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EC97D
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 19:34:30 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AJ2Kfq017470;
	Thu, 10 Feb 2022 19:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hrIAx00ltq5uyB5+dfUERGseD5CmKDJ3dpseYB57s/c=;
 b=EMfYlMCp3++7RwUMXyMhFQhHe9CKaE8lsbmnORNYzglStcLbTDwD9tUYIhevbOsJDlEn
 dObYh0SrlzaWEG/Wi3dsLGbXPrgT54AxstLeJzr10GBJORqLTWa1wJYEm1XXUcG5qPZZ
 4t8VwN/dmaylRI0QqI73bOOQfuO52nmjL5GVuDFZFgXTax5Z1bg1TEXSgbRVaA1tzVIN
 LU3j1jF/5LIYwHdAJY9osAgwHCG5sEWkEqODC/0jpWhhvdbz425RBsvEgxpQoeFEn8/l
 joJZLSWMi49rc1nkO1k9Kqonz50M1rmfoNsW2Pw4sgNV0aw0tKzzlf19BvkqylK0jTJa Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28s2t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AJUVqh120792;
	Thu, 10 Feb 2022 19:34:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by userp3020.oracle.com with ESMTP id 3e1jpw3cje-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZWAYLfJBnWfIsOCniKPdMZJfwS+xfp9SoszAVlmAlwug+LWw/ignsqTrosniL3QErdoIKavNU7EPAwxELjEIzuuFY+60JLddV0mb2uzBugZqa9zyVErPrH5BLKpB6Oku0JNRdyTWSCt6phnFf9OIyjs111TryWRcjLKwR+qkxYpAULLRFHnlZRz1vFVncbsSuS32VExym2TSXaw86MTfuYaQ9BLK6Ek5KO3lk8J1V5AELfwQj/iTgH6BOj0+7BInL0ADOn1MB3rlTIh06xfz266IfnjhcaNRpzn+gk2xOWwGK4D1bXHs/p3PYqJsQwJ41EbLncjw9I8CLiFno/n5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrIAx00ltq5uyB5+dfUERGseD5CmKDJ3dpseYB57s/c=;
 b=SJ0531LXAemNZ1GIz5sagE2xgSkBMXVxcEIlJmddwuN628L8g0zk2ppIdHivRqYPPfZ46RNCHTimtxacwWLcMSpLS83seuPQjVOE7UGjc/KSWE6RzBbi9ymVm+uHWrI+9hQ8Ba95eIBxG4KePIj7bLhgtJq8bNsXSZJe5MhF7Nl/jDQFkT7LlJmZ7TEm0z8FYb3vgm8WNP0NjFwMEB1o59q4MIlbPmFcV84qN8YRpxoTJTgdOu8Pg/otGEPza0fe4nyBy3fFBDzMlfNWr59TNvnZ6qGsUkVCgHl7pP4Y7D5cddmR4XFmlzjICHUnikGwGRLx3NrWWEEIzkdY4U+6vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrIAx00ltq5uyB5+dfUERGseD5CmKDJ3dpseYB57s/c=;
 b=wJ6rIX2vzZGOjyZY//tIO3WnVuoHpAjWWJrMn7rnrVH6heZ+mWL6fazUVKcAMQeHv0VHdSBESyfDd2Zr5HnRRDG/V0zyOT0peN0UnESkvk6+B3fAXRFQcjTR2NUoloaOQSTZoTydCMy/WwvZdG68b1HXa87qAQVOmJblpd3i+jA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2514.namprd10.prod.outlook.com (2603:10b6:406:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 19:34:11 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 19:34:11 +0000
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
Subject: [PATCH v5 1/5] mm/sparse-vmemmap: add a pgmap argument to section activation
Date: Thu, 10 Feb 2022 19:33:41 +0000
Message-Id: <20220210193345.23628-2-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 04972d93-4dde-4cea-b7e4-08d9eccc5050
X-MS-TrafficTypeDiagnostic: BN7PR10MB2514:EE_
X-Microsoft-Antispam-PRVS: 
	<BN7PR10MB25142B3A993A88A6679E6385BB2F9@BN7PR10MB2514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	NE14zuPA3pWZMm0MPGWCpUu2L0xWNH+Cg+sakIrFMbASIf19QSrz3Ke/hY4J02Vvj3hEHctK/EnsBr1bIrr0+hoy6VG1es90lZVPGJ0Jgu4n7kqo2eUT5e5XJkO3jqnawGb304nr9xrKkPskfLcMJvwxmu68rM3BN3VKn2zW8hNGNX20Lb/+DdpuYCKN6TT7N5sMgZYRrARNCrqRv6+lrwE0FMoAeafLxrBmuiNwP2Sx8mNWcywQuX8RZrWwcu03PCPRreaBbliXZ836IWHcJDOffO2R9UiPL2lFTLw/Xmtbe9pGPUydJLuK/NkUtuE6A9Ys6z6RUe8CSKVgROF3BC6iQSmtn4E5iqlqD1LcCYkWBnYqGiv3+C3c/EL7Xv6HZ2DYrTrRfVh4aQMpOwvoQsGxD3hS7einm9p4IcPM0IWnx4hOaznv4uzZ5bL9EC4at6PGejclheRdTYZnCQeNKrEw1DPiiFj1y7MHK+Sf1+fbwSXASs9gmhX6nHrDNJ4cICj3+wi6ZqRzGBMmO941ct7t784/ePGRRSpiGemI4wAmESZ32TzpArBBY5XZuCcom4wiTxn7hrIixlD77SXKMQg2s2ZK0pjRfwzmLZvewSCchhxmRLudmuuBqOJlAPgqKH+Jut9ZCwM17GM8GppcUa0YOqXW9V4WRaMbwhIwp8ohJOfaveOfYK7IVHzuEBPSLRyGRR4a4kcn/05aEAsmnx7Kn6tiXWm6UCdc8ycz7rjWcGgWamY5yhbE/qLzRnHhYRhvkHtBHEBaFqSRa4u1U7cYXuwVMcBzTpHvcLbxmVg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(103116003)(66946007)(36756003)(66556008)(8676002)(2616005)(8936002)(316002)(7416002)(5660300002)(66476007)(83380400001)(4326008)(186003)(107886003)(26005)(54906003)(6916009)(1076003)(6506007)(2906002)(86362001)(508600001)(38100700002)(52116002)(38350700002)(6666004)(6486002)(6512007)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?n/IPk+g58GHyp1rUoszCNU1EDHcvmmQxF/M7fYwOBerbKF76ymSBkoAjQOPg?=
 =?us-ascii?Q?Sy02GB/sStrABg3ByQTdiM7m0HBqxPnIVJNFg2/SGuh3UT0j7KkVnNU4QzAI?=
 =?us-ascii?Q?o2NvDUQ3KDESAsVvjLFYhI3w9SVYuZohFXaLSlFr/lTdwUMTXTbazgRLFDgp?=
 =?us-ascii?Q?XFCqQwwHL4TFX3xJ5hyZGh4PQpU+O/lLcZwD9/gtWlcnvojkbBPKVv07WcTI?=
 =?us-ascii?Q?dM0uxKj5lqqt4Cb4VS2JhdlW3Y10E69S4YvJHvU4gnxJK1IKXnMoWeGoyO+s?=
 =?us-ascii?Q?mulBZIhRqLk58ZIrDD6IHLXWZqNYF+aorrrxfkCP8zA/FMKaCI+oio9ALGtf?=
 =?us-ascii?Q?m5WhXOLDZLhC5mtLdRU04sE6SFUhS/UbQi+guBVN5/rJJ2G93T3GNUD6mJFj?=
 =?us-ascii?Q?spSLdx+XfE090htndkWPBQ0CuoO07NauAyQM3Ng6SBlkIV2DFVqTZWZpzBcT?=
 =?us-ascii?Q?ppExflGVXtCJ8GFujUpxgt41QQwcNubG9zJCjye2XoQDN6ju7v2rV+1xD29R?=
 =?us-ascii?Q?w5tOMy0T5PsyMnGL5eNT7GLuB0pIrXzaDpofkMrRb6is3ryED3mrqx9dPTQO?=
 =?us-ascii?Q?gDg1F6RNaNnF+oaqqwEkT5pvKvwQ6kB3Nei83YRFI3Oy2AqtLLuTNw3HgVLt?=
 =?us-ascii?Q?RZYXMZMh9K+pLJCUZm8lWMxlnZSF7m5hLSEEJlhOJmgppt8OHU4mmS6n3x/W?=
 =?us-ascii?Q?+DuNwvTM/VVRGZdSnKhR3vl9MwPzj2NLDSzo7fVfX4DO/p++djPT2h6R/W3w?=
 =?us-ascii?Q?SdKLeOqJos4eyfkxxVllTa0giLCF7EfvZ/SvlW7VwBgUZnHz9kp3SvVdHqe8?=
 =?us-ascii?Q?cWWYOWNfhsXbAt4p84FDXFTnQZtOU9xMDTThZTi/OmFhO2xZvI3Dp9VhW1tp?=
 =?us-ascii?Q?9ig3Z7zljDbdRMLkcUCLBp1WwJMdSXRz0RT7UzOCeJjaBH1MmkjRvBd4GkJe?=
 =?us-ascii?Q?39EJ1ULzb1qMdUUB5xjvyfIhLyjQtnRj4qvsm2dBcWvNC8kQXau3sKW3jJdM?=
 =?us-ascii?Q?/N7Pw1LxvQcFUr6/j3rFiu7mEKM8jf1sPQXplH3Oc7SUvHi94GW5qLAGXNnA?=
 =?us-ascii?Q?Rn+uxI9RWQAH6j+3/LM7RcpRa8qF4en9jLFsS0nDBZ1r/0//GZmNMILA8ZX6?=
 =?us-ascii?Q?t+2uXxRpvubVKPMfLUqU3GOIjYpwxwUyNwA8y4iyFTWX6lblnNTx8IZNotfB?=
 =?us-ascii?Q?QK2vJRgUogZcBjvm9IKlbBpOo6fE3HVbF+uQU7h0/tXxUYLwliH2nUm/S3qA?=
 =?us-ascii?Q?hyC4iGjSTVIVItov7s3sO+0uXcLnkC/kQ2pCIuYYc73+5M/BHp4gOn8AL42o?=
 =?us-ascii?Q?IAL21ty9M6UrCRaNa9S39QcKHLBNdKOMOpg0P2mabLDiFFMH505J2rl2gMAd?=
 =?us-ascii?Q?Wo52kapBbFjbwBjHl/Tq42w7j7LlbjCvrABsm2D9tkN90Z0diFgDoinIzRgD?=
 =?us-ascii?Q?hN4rVofOsLGLZ+akApBUafvWyylQZ7pOeTIouDiP0I0JLticTfUE3zsxLQEd?=
 =?us-ascii?Q?yWWAyBqmwDvALvZcYKvLWgPmbJKy7TZF1NfkELyU4a+gSjHNE6ZKgqSAh+A3?=
 =?us-ascii?Q?5eQqWnGFAxwYyEdvlMLhoqVL6RuU1lx0Kykn9Hs+fqB3rrg0Ee37txIi8kX9?=
 =?us-ascii?Q?SlvsttMlc1NH6EoMDW0Rr7tJQYRx4XuzIlc7/1bC1E19NwS4P8bbsKbpvzvD?=
 =?us-ascii?Q?k2LLWQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04972d93-4dde-4cea-b7e4-08d9eccc5050
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 19:34:11.6773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sziny4His2ayvklgfu+a6wOo+FIocaGxW6iQwI+d0os/zG6G08LkikOIL8HQhj8mZ4YAZkMadd08Li3pBcGNrHT2aR5/UVG7zDuTDfIGmdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100103
X-Proofpoint-ORIG-GUID: TjnM3-i_AHvgx35Ub_HK6WtDMOfEq2ff
X-Proofpoint-GUID: TjnM3-i_AHvgx35Ub_HK6WtDMOfEq2ff

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
index 76bf2de86def..405aa2b4ae4f 100644
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
@@ -335,7 +337,8 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
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
index bf60d947503e..f6a439582f63 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3165,7 +3165,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ce68098832aa..79e96b6a9036 100644
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

