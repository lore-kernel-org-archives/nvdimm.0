Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DD71862
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 15:54:26 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KFlNAY020195;
	Wed, 20 Apr 2022 15:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oBlHkE/27aRnCcLZgw1SLiFlxrFQbSNKMwuZonexp8Y=;
 b=ebAbCiJgLN4tEu88xadbOhWvSevXvEtpvE9cpRUyxCE4tLTZc1QPp8GxTRop3vvCBspV
 agxtVeUF+eGVMY2sXjbTdFVXQU6nuYBFVV7v4EaojbY8uQ3uBT3T9SB0l/C/KlSSDs2j
 bGJ18Iz3JBM82Ln+VoGoF3v4MXmTROcdpVFgQMZHVJZQfQnuqLmMyRCLxSzpLBV63FwB
 PVc3S1XAnY3/IWctYYHCj87GDPK0k552ZgjbRIn+W86NJL76XSOF/OOLoEFERuARpQ+/
 p/eIAGJuoI93QWS0D8lc/wMnWwXntrivu0bN6kKGIfqFID0oi99aqlpNHtHJ6kksQwpQ kA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd19kaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KFojbT037583;
	Wed, 20 Apr 2022 15:54:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm87c8n4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrOrdRM45iOrpQD9YbHxyW2SBtWM/ba7mN/Ib/dIEwPWPIoZHCN9FoVC5yUvFBTefo0worbvqalWCN1kSHCoFS9DpcAbkPjpCXPxgSlDgcDjTy7un0e07DdKceiCmzBPQyvtaobLfOyS78zDWJBrOQtvIdHguy/tR8RPO7DPhTQY+fkYtI4HnviUKFKyVqFxQbjgNOeTHP6qcA9F42wEiOGR50OAqUshUwmsQnbt9/5XAk141pwMeMloSR8y2EgCknzgJiehrpBteQ7uutx8xdPceBT2cmCVqI9A5rW90DWKrP3lPYNnxtQw/Nz5uSOHLgA1xzi40dh3FJGVeER+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBlHkE/27aRnCcLZgw1SLiFlxrFQbSNKMwuZonexp8Y=;
 b=Ns5PWk4cglJChbeaqi3qDEvnLZLaB2RbwXOKyo1I/0fb3yMxbFMIuqhfeUy/DcR9P6taORRtnLa406FR3OBDUcoUH/CAgXpZj/gIR4W4OgDCiMde/WbR2vDVBfugqmXpZ5TloCRXRz9RELCfik3RIrDfvM1c2tU9fBRoO102Y3GmrkO182N5rgzRyGpr/u8iMIxtpQ/v/rXQhsGlM7PHir2o3z3MGKqNkzH2yl6IHXKFoLPvWfYOnLmqRtvmexJ09JUR7S45tc6XfVtY4zz+cpysHX1TC7oCX6qy/neSfz/yXLSFUOMVT93NpHeMSw6WlcxXR1mmw/NvrCioi026+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBlHkE/27aRnCcLZgw1SLiFlxrFQbSNKMwuZonexp8Y=;
 b=Q+CINwEt2dhPa1poAW/G2fQTvTc+VlNRDrLgte8sKYw0oFXHY5NZIeChK0ST7JNfsXW7qIPKs9Xgp+dk8J/eWpW5JCbuY1czOvJLadEfWM2Ffa4UKBTL8V4H+9XN/GIlC9qcEHDNNOrr3KUTJ8bmLwEcZw0Onys45YOClk2IRgw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR1001MB2208.namprd10.prod.outlook.com (2603:10b6:301:2c::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 20 Apr
 2022 15:54:06 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49%4]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 15:54:06 +0000
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
Subject: [PATCH v9 2/5] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Wed, 20 Apr 2022 16:53:07 +0100
Message-Id: <20220420155310.9712-3-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: db7dd6e8-138d-4aed-07c7-08da22e5fff0
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2208:EE_
X-Microsoft-Antispam-PRVS: 
	<MWHPR1001MB2208BCA0CD3D94132D65EC47BBF59@MWHPR1001MB2208.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Dy7N9SBbS9GEjScFpCtVRJO9HngJ2kVrevC7lZAF0cplYyFHTw3kou/6JB5frIzk/7JvC3+3f60yyCcisENfiO5TJijQRaOvAhXg+J+unb7QJXj9uCjZ2VY8+6XtmK6ubHVcTSrnAtskcgbt0vL/WvIseG3ZbkjEW510DLXA2sxTWEgHUih1pzLMfQ6hL1CLdvV5QAU7Byv8t8B9eo1wmu3MgQLUY4aysjbxLrgEvVrO/Zdgbc8THanQuTRMPo2sbBlVyiyxreQarZcCT9Z9Es3ImZwb0V3w5bu412E512/xybQzJa57Kw+lq/eKUfJ3Q/BVJjvAqtuR1NDE7b153m124HlqjL8wXbcjX5y41seMlQ6likjNURUlXAFSG4VITmnI3bfPME7Cm1xzD8bKC5uoXqkhrKomiQ9xsg/c8KVawca0wJAFs2xatmCbGNnGcECfA2vTk1VuXcJuv6YxjRTT1fYqDRccOQs4JLXnaxEQJ1TVxobAPJSwmU1r576IcZBURqNPH0TzDwz0pn1wHrK8BEtCO3D8lVTEZkLT5qNXFJu42gFqkh9/g6/cCMAMhHUh/5e0Jf7o4cmqVFT7ZznTHWGjohsBwElTp2K0eCvsmq3SUWjdMKkr+vb8Gc+3McWAO5EWJM0I5/va2cHMN+iHIAbNMzZ43A1UkCDQuruiBxDGWCNnwKGj9G9FOr9qGxrBUqJA1fyV7aybOvXcnA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(2906002)(6506007)(508600001)(316002)(6916009)(6486002)(66556008)(4326008)(36756003)(86362001)(66476007)(103116003)(52116002)(66946007)(54906003)(8676002)(8936002)(83380400001)(2616005)(5660300002)(38350700002)(38100700002)(7416002)(1076003)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?hxjvr8MqoNVjE4oS1QMWfA4/adQ5phOi9DWNy8qE2H8uRK6I79ivyS4NdEwG?=
 =?us-ascii?Q?TdZ+nbq29q9Gk3YteKvpeKlcGSSU6YUcYa9f2RC6HUnWqV5XhI8tllUYnzs1?=
 =?us-ascii?Q?g+ZseTWzgJl/VxG+cHybA1/qfeMwMzk//BX8XmTTX0It3wjohHSkUDZ0WuPy?=
 =?us-ascii?Q?pLmra/qpoyZjTgbP+sMpTU5jmyXTbLm1MyMNaGRyF5UuGoGbmC3lyJOlQIZL?=
 =?us-ascii?Q?OXhr3Klno5htGtGgNtKmMENt9FX0P4o1dqJ4BvVhgvwu2bzO1q7DCj+w1Zo3?=
 =?us-ascii?Q?FcdS0x8toDoO1lvWI6lYLkBlMGW1fwQtv9emiB8AH3ONvP7v+TotibohvVqq?=
 =?us-ascii?Q?gjoqYX0pTHLVp6hfrVnGYqNcORux+/rcj2w5oXAN8PTs6JLzKerVuFEiaN2H?=
 =?us-ascii?Q?Bs/wD1pLL8g8Yb5lHocss+8Z7pPhYVZpn29uxx1fCcYVKABPJk/UZQyt1Sky?=
 =?us-ascii?Q?Kr/r/fxUd2yeAFY531b8l0HDONVq4ZuG71XYFlu+xaa6RdDWiQt4DUzfudFg?=
 =?us-ascii?Q?6Isx3KPeZO+6yxwj4a452Mx/TT6TTFWwIuvBIoblFtYiJyX1lXKvX2ODiSvB?=
 =?us-ascii?Q?MBYq5v8J8L9KoXvb+u8j5rShB9d/cTSqlsD1WTY7nd65xuvKIIaYT2ZUWyLA?=
 =?us-ascii?Q?Sj38gU9seWll2cDUmqrkwkGdhUVeN8qzvfmqvh2mEmXYsA9zIOdPVgrS/PgA?=
 =?us-ascii?Q?XcukC/gfgzPrZJJ8Zx0gWAUB1d08N/jBy960geSkRColSC7nPTsfBKyc7x4Q?=
 =?us-ascii?Q?MKBu5nzeam3oVZ671rpCNqBNWVJhaBN2rsZftVrgnE5iG6xQfG9H6+OvYYE+?=
 =?us-ascii?Q?hUze0VH6Be0mUynzblyrOoDb9p7sI8T1dOMNBIZnWqNPDZD7EsIR+ngyVzeo?=
 =?us-ascii?Q?CGgp0AasBxSz8m4GAYYfKSPkEfT2ozrc6yphmZFdR4OnxT7BaV8g8JXS65Wy?=
 =?us-ascii?Q?PcSsjIB53gO8JW8FoTdLYVp+pJd/DYRMvfumSshcPWQZh4IHihfJ46n5P3w6?=
 =?us-ascii?Q?9smuxQh/3FEOSHsDHhMyJnVyleVm6k5fgEnGJAEOnfnhE/DajTwIN5k3xtVx?=
 =?us-ascii?Q?lBH6ksQuf0nVJoT9yp7bWzEVZlDImjEVhP1nzEwPczpMKNAAAOvLAhQ2a2il?=
 =?us-ascii?Q?Lqe7mokRvf5SV7uiBmqybXH11G4nFrelNtsKJrKHGPLvOZJx2m/K62znHafR?=
 =?us-ascii?Q?AUv6DkbJqyWiqLepyYNAy8939H3AfV3J9u9AMO0tDaVZ58nvrBQ5IGVHMyYe?=
 =?us-ascii?Q?d4fLlnVb/NHa4wNLM2UxmtQ4uK2852+WnmdLCGSu/CGs2Yhva9EoMFnk4Sex?=
 =?us-ascii?Q?8qzl3PL/RfLSZVo1ler1AqI8okGYHflFpc/inGW2oeiiXn7fu6zkf2RtpHk6?=
 =?us-ascii?Q?+Hc8vn8CPtyWRxH5IvbBbD9DFCKFgpCFXZUC+e7hyJdijoNU9bE7fZlh//1V?=
 =?us-ascii?Q?oZmLBKkS0+TGSZRT948t/arNCWTd/piGDdqqPxYB4ZMrHVi2z55OYOv5L8hN?=
 =?us-ascii?Q?gTnUOHLrnmg6RFiwYjXGEB+kwfUrd7HaPkcXR+1q2aQR/Vnb9akln6EhCOch?=
 =?us-ascii?Q?RpplYlLUMoFSJwSTwA9vpQocfhXNYWe/g61x1claiJaWp2cwi5cG27/ROu+7?=
 =?us-ascii?Q?xCQvBTivgVl8IAafcjnAUoVor5D+8s/xmFk8ZhCwbbj+GjYWUXjNBtWmc1S3?=
 =?us-ascii?Q?uSfCpisXjCwx5iHItYGWwJsvqC+gWeY7d2DJgPxZWcEakmEVdt82AEWGYe4F?=
 =?us-ascii?Q?eHZ3aMh+YBQ2vtMd3aNjg0c/UqMG7CY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db7dd6e8-138d-4aed-07c7-08da22e5fff0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:54:06.6403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4W6HmCTT7QJS+mf6nyzA2QmT7S+0vdRu12RppPUG0X5NwzoH3dk6wIss9+RSdc50ws7Z+lM6EQRw7ZoqSWVQBFZEawdGLTXA7D2ipqSiRFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2208
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_04:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=798 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200094
X-Proofpoint-ORIG-GUID: kg3Wgt10qzEFN6empL15fA24-bxvf6uG
X-Proofpoint-GUID: kg3Wgt10qzEFN6empL15fA24-bxvf6uG

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
index fb68e7764ba2..ef15664c6b6c 100644
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

