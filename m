Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF43D3674
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 12:25:39 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227C7jXc010192;
	Mon, 7 Mar 2022 12:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1YUEoTnh1aGzrXHHQVADdNm+TBpzs27JjOXaNE3VmQU=;
 b=iRfMpUet9aAWXcG6ZDy60pda84eRpJHzo4+CDXRqAMGIpbw8GABmPhl2sQ9u4dv6pQc1
 v+qqawlxoJQilfx2WHJ7Pkan+vgNF6CGmHp1Ja0f/5K+5NCDOJseAzxzPHF35zelf8H9
 AKaejivWnTh0aw1WTbroXbyYdUaMJKvk5FcEROCd2dPVeUZojRH392RWY3qh8JX5v/pQ
 ALgJZjvfl5G7cZPvI0HIVLkcjRdZ+AJT7W3NKVJsoOh5NhXn1sBn6yX79fQdtoGL6MPR
 bKWrXbOQNgdVn+YBfP4CkVFGr34wtJjqF3lgEKIdbpwm+evh4FUau2g+SljJn3bw91/d Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cbkwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227CBYBn009524;
	Mon, 7 Mar 2022 12:25:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by aserp3030.oracle.com with ESMTP id 3ekwwaxjyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaoEkc/az9ZYIRmM+Mm8Y8E3JhtkygUcLKHApUDR6Z7u4Dpe7zthjYqJsX42elXCGiiVQ17C8DynBb1/G0Z1b2h96tpwMwkCtn5pgdDyJ4vqNn6//4PxWSpib8G2fI5C7rOAVcZpwHAX5odoBnQ9JpjOyqm0o3aEuTvNGBkwZJkCHN9Yq53chWgrVj0KbP4A652vK4cNDoQdY/u+T/7BVZ8KQvLQkXptWKX3fVgp1MPbKjpY6Ezh/XqzyNjcFgGtL3tpgjjU7S4PffBQ9Lb2wBUw94AC65A/8cpElv+T5FLbaVNshXRIKie7cLK0eX8hrFWS5BhpCtSlo/Eitx8UMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YUEoTnh1aGzrXHHQVADdNm+TBpzs27JjOXaNE3VmQU=;
 b=dUn0SGrmopWDxfMx8K6T/yNxdBnmJULO1fLL+HbqsR3By7WWVvvZH8vI0aNEiYhUbK6zANxGb4l88FYfSxTd27gmIf9iyfSRZHZF/oRbIt8o2bFRu0yQT/rkuDP+yQGyvNQr+lhX3jkc9hs2nwWLOeM3S9iyPAeyw8okgAu9zVLUED1jGGNzKkmO54BFQknTHR+VPrRpK0n6WlrtUcE71WzGBZ+3vuRpNRVvIfEKeYSiZ4WFvYvCddd0OqYS1x+e29SVgMD5HnjdrK3zN2TD8ea3nMUFa6URr8RrnRcjdb/hpzennwh5zCkxosopTpChJizp8SXyF59prNgk6Y+OlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YUEoTnh1aGzrXHHQVADdNm+TBpzs27JjOXaNE3VmQU=;
 b=bzn7BQUK7iBG8ryPjYFXUPgY3bUbYUn9O8cyxPhH+2rh/RdTB2TVUMA94k9/dti5nsLCmTuhFbppuOOlcw1XpadjRuLtLNUITolTxmQkSQCUDR4uWuxOI5wcOBhqXDgGHRZ4KByybX2NPasMq8CHpCeS1GQg+F1lSThKExmnMao=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR1001MB2284.namprd10.prod.outlook.com (2603:10b6:4:30::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Mon, 7 Mar
 2022 12:25:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 12:25:12 +0000
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
Subject: [PATCH v8 2/5] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Mon,  7 Mar 2022 12:24:54 +0000
Message-Id: <20220307122457.10066-3-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 815f346d-d073-49d7-7d55-08da0035871b
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2284:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR1001MB228473DDB5ABFFEF68D77279BB089@DM5PR1001MB2284.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	NsP7skPpsH/sEREpAA78dGQYXcz6L+r9MikFa/u+rWLXXv8AtV+J/IU/NNOJEiU+LevAcN/lS9YNPhhH3aIbSN7Vc7RbvnzJdouJ6eBQJ/sP5e0k1SrzqgApdhLrVt42ZTwqJYCH4IdQLQiASgbQBB6JgG93C1jVzl8tXcMmm3oV0DASq8yMYoNJb06Av26jLUz2lm6or3xfsINxlsFZst1SIKEuLVWAUDInv5PhcJ95U7N+jWFX120ft7VhAH12UnGILj2UDF7xVbGTibNXeKAnYFsp4HEQKfsuggeGh9n7hHyItXjhdk4P4KFBdIEiLWxk+Nd9PN5f/guPGOVzSNEq3ey3S42Jxvj0jtDSkuOOSteOo5bvMz2KsBKTOai4l4xlxKA9t89K4Rn24hUCqLzZYaHAhcIJNB6fCrfsMth184Vsc6Fvde2qxTOE3wZXmDad3wr80D+GBemo2ut/1J7Hxm+LCX9i0a09Y/woJAt+271QHekYg/6jf9AQw9z8bZdIqr4R8nW/d4E7z52s93QcnejQ86xpC4xRkUIIiJcGFJZ6Nsyb9rt14qaDd3ksiTk5hOK1qo9YXkcUZBSuBtPmQ6kV3NGV0IFBqL6BBrqjA7U0G5FzR51VQMjZOxK45vgje0R8CfUPjX6ls2VYV0jAksQZAKRn+a7kZCf+jEcQh7ny21XAArN5Ieer4dUC7ULq/iX3N2tTTpfNrBc2dA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(4326008)(103116003)(316002)(7416002)(5660300002)(8676002)(6916009)(66946007)(54906003)(36756003)(8936002)(52116002)(6506007)(6666004)(6512007)(6486002)(508600001)(66476007)(66556008)(186003)(1076003)(38350700002)(26005)(107886003)(38100700002)(86362001)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ZBredoUx6NsBsVJG1iiiRv49yZbHiLPpghbdVy24Ktrc9n5XB446/FVeqb4e?=
 =?us-ascii?Q?prCpv/sRSkXT6XIt802bhCtFraa200bd8vhyA9T9hVEXe9mWXAfV98v5vE7x?=
 =?us-ascii?Q?2Ryj6RVVj7uojCG/VoqbW2xqGg5WK+llGIn8ndil96GxlVyC6qfXIOYwdZYe?=
 =?us-ascii?Q?LbFAKxPBsXYZvNHDCWRd6+2NfrQWtPG0lcf+ebs67UrlOIzoXSgc0nj/9AVm?=
 =?us-ascii?Q?KZ22AM2tM5TAs7UX9ncM/ecXO4WBJkbHLDguE5dt3npgs3GV2+VK+hkvq8mU?=
 =?us-ascii?Q?OgHW/J5ypLgrv8ad+7ez4D0UogHk1oLt4CeeGRzP5Y3nlhXWTTBGxqbHx/7R?=
 =?us-ascii?Q?6yrkTDsCQvTz7ZxlWw5/wxLbjxz4prIYeYF8Vd95aHl+YYrjNNiniJxBtBqF?=
 =?us-ascii?Q?7D8IcobOckqYAQLah/t1bJeeDC8GJNh5wHX7ZSvjLpHa3PMPEOkOXsXGenpw?=
 =?us-ascii?Q?SUDaRxbHoKf8PSav4F8J2+V6ceYwB4McEzK7vk7pW4gSC4hZeYnX4GZ2LJY1?=
 =?us-ascii?Q?ud+sdvPp0Xpx8cEF9vUuH7AOxsi32n6GWEa5O5fMXeT9h2KmCIc7UzBrwq+1?=
 =?us-ascii?Q?dLlAo1CYU4Yek6LkB7YtIt+/aJ2u52sK1kOMIqkHivaD+Mj3EipkLqOQ1Mhl?=
 =?us-ascii?Q?HTQ17t7K41TYOdeSAl0J9iPdxK6WrSqJvzND35Mw2cyjX4JzfAJHTecoCy6j?=
 =?us-ascii?Q?a7gLOQMCPKH6RrPFbYF52bz7Nps0++MwaEWE0MFEU8IOF1qOoP78z6upICsL?=
 =?us-ascii?Q?DIIZD14ba4R+f4aDT8OfpAG9D3GicBdGhGccW+d6gDasoChsoDu8OBkG4K0k?=
 =?us-ascii?Q?sAQXHu1u8QtQA/LAuOom5btJsAIjsAB/DcmbY5i8mH8JLxfMqsNWVEINl704?=
 =?us-ascii?Q?ahkZxCN83yDD98GMCBvP7tHeJuaKiAWg+67NPkG4qVzfKNbsjJhlxqQbMpRf?=
 =?us-ascii?Q?jfH8wpwoyGJx7WNtKXQMDGb3gktSyo51//RmaZDIi4224LjM9mVUjmiL4vRi?=
 =?us-ascii?Q?KA/bq14+/ZqdZvUEc+Z9W/5LbvbK5PsMpXGZCXN0s7c1SyGfOC/rAcPHnrF0?=
 =?us-ascii?Q?ByL1y/UH/UoTdL8CVPTPm7G21gzvZ0S/TvssBZ8vIPWB+aJvRoo9UrJvz+I2?=
 =?us-ascii?Q?CWiIyUundBaTlE7OV5KV49KqCrH42xNrDKf9Me1h42Nri1IBaBLF/UcEpL74?=
 =?us-ascii?Q?vnqHtUUAmGPFg8jS1w/iwiskFitmnFYkfT24+hlm4I8cls6UL0Tn1uk+luNo?=
 =?us-ascii?Q?ncgqHEGkxjgnCY31Y5cCme0R/rixXVj6eo5McAOiPIivaJECL2lvZeln0DSa?=
 =?us-ascii?Q?skjrpzmzpa6TmQqzHnnbDbX5PidDwd7qWI5ncm6LP1wWw/kG9iMNj7I6hRg7?=
 =?us-ascii?Q?Yl/iQCGFK/4MLUxxe9ZyYGQi9oo0T4FIAw87nFftCt/y5kzbFgRSTqIxKNG3?=
 =?us-ascii?Q?bdSZYAdGmsGSeOu9Dsl6TuE/deKTBun1F5DdMLtgDOOFiq1E35ubi0czKk4g?=
 =?us-ascii?Q?dxirQpzOERIZpjhCZVBzKaIlcIZRpP2Z2z+NSekXhQC4VnL7OWRhJzNa5Scd?=
 =?us-ascii?Q?rPlzfLs+gJaHiFDr2BdIScDj9yt34MkphVB1Y4mZInIcBBLVWhTrwOAK98kz?=
 =?us-ascii?Q?9kxXcJ+Xucbr5HdoSGJLIvNqS8+LAa8jq0hyoZZqU7ISQsQqcs6yh7V8EV8L?=
 =?us-ascii?Q?2nkJ4w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 815f346d-d073-49d7-7d55-08da0035871b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 12:25:12.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WjE11Gv+awbzsxFK07hC4aaTeKquxS12T1ucCZ91+iz0Wlmct/1ai6owDgVhxcuyqynm+KYCp0cr9XvwV14q6VZxLFhr9tmgB2bTpmEGlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2284
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=842 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070071
X-Proofpoint-ORIG-GUID: YIYzdHjbGz2JlDvW3bD98OPa6S3vsLeZ
X-Proofpoint-GUID: YIYzdHjbGz2JlDvW3bD98OPa6S3vsLeZ

In preparation for describing a memmap with compound pages, move the
actual pte population logic into a separate function
vmemmap_populate_address() and have a new helper
vmemmap_populate_range() walk through all base pages it needs to
populate.

While doing that, change the helper to use a pte_t* as return value,
rather than an hardcoded errno of 0 or -ENOMEM.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 53 ++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index c506f77cff23..1b30a82f285e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -608,38 +608,57 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
+static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
+					      struct vmem_altmap *altmap)
 {
-	unsigned long addr = start;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
+	pgd = vmemmap_pgd_populate(addr, node);
+	if (!pgd)
+		return NULL;
+	p4d = vmemmap_p4d_populate(pgd, addr, node);
+	if (!p4d)
+		return NULL;
+	pud = vmemmap_pud_populate(p4d, addr, node);
+	if (!pud)
+		return NULL;
+	pmd = vmemmap_pmd_populate(pud, addr, node);
+	if (!pmd)
+		return NULL;
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	if (!pte)
+		return NULL;
+	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
+
+	return pte;
+}
+
+static int __meminit vmemmap_populate_range(unsigned long start,
+					    unsigned long end, int node,
+					    struct vmem_altmap *altmap)
+{
+	unsigned long addr = start;
+	pte_t *pte;
+
 	for (; addr < end; addr += PAGE_SIZE) {
-		pgd = vmemmap_pgd_populate(addr, node);
-		if (!pgd)
-			return -ENOMEM;
-		p4d = vmemmap_p4d_populate(pgd, addr, node);
-		if (!p4d)
-			return -ENOMEM;
-		pud = vmemmap_pud_populate(p4d, addr, node);
-		if (!pud)
-			return -ENOMEM;
-		pmd = vmemmap_pmd_populate(pud, addr, node);
-		if (!pmd)
-			return -ENOMEM;
-		pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+		pte = vmemmap_populate_address(addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
-		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 	}
 
 	return 0;
 }
 
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_range(start, end, node, altmap);
+}
+
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
-- 
2.17.2

