Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E896AB3
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:49:03 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NIDs0G001902;
	Wed, 23 Feb 2022 19:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ke+0t9/ky6qMXM0/4Y1jAe7ip7VHhbtZ6LYnYhQ8Pko=;
 b=GhQb6LV4L8eCXYT23zNBhnAVnF+QBW95Bita08dhgE9J2FnDpIbUewn1gSg7PBg4P95M
 RbJAyrtkVoxS2NQSR6gqpCLmua71achoMEPvS9PLHDhjs6PE0URSEhnQO6htlGebCIi7
 S1Ah84JI/xQHwVu9LfTdJTBa1yr7W6HR/bRB/gj4vEEeGUSNJkFbV1i3K+Hab/16m9L1
 Jy71FrSTbYTFngD7kwAxkRkNABsvbXclu6MhFqv44AdQG8HGO5b9seh5kdH08f/4DGSP
 QrCe5dGBxue7Fhfp+QKF04UBEa/ZjztWOnKpXqv6LGvfbHOtU+Kc3a0Hz8cDOxAIbZ/S Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6ew6hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21NJeWJ2047035;
	Wed, 23 Feb 2022 19:48:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
	by aserp3020.oracle.com with ESMTP id 3eb482vxks-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mo4IukUdAJ/z4FzR4IZn6N1/K4nbNH6LcOao3Cc82iSLAbhWnURemgKCfClXwuzKHu89KkIeRgFVRGfjrq0DjObRxT/td1cMVEoQorX3WCw4oLFN/77Cz+ZsgXh6O9aQ0IO2DinLy1qw6WzJQPe+1v5RbfO30n5/8jAH9LlPewSJyF8IESrQDcmUymGIHA8GyxCW0nQtGsfyYDHqAsEn0jcxDII5E44RsLiAuCzQldkVZVFJfAdOouRPH2SVOGOlAKIBjBbdrz1DtQ7cQDNaRqjjpyakdp4AF45ELmbaTSAbu2EVMdWPzdIIcCXgJND08hWgvu9Th2Tg/FmLReEBlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ke+0t9/ky6qMXM0/4Y1jAe7ip7VHhbtZ6LYnYhQ8Pko=;
 b=HQ/CeWaep/0Vv+tTaGJCgr4JM3Z9h1mC7XqB/xWVqAAkf9XtoqL2lq0RwQDgoESue1WWvsmMIqo+oze1YvwUv4NeISMHgg1rVxJfa9/RwAG1sjR02MCCQO8/qi3Io8ChI8WUEEjqcMqwIXn7ZpZvcp6islrR9GpxYeqzKIF09T82p8HOu0zQEFqsHCFa56w4dqOG7sA1CuT9veL7PR9/iMVRkwgsin/Y8m7DfGKuph9HLkJkUPdjPZV+z1KLPFi6MmmE3DvV3kgOB0TcBuEctpc29XifhKixoc/tdeb5eBYroeU5HGs7kE+6KXIFRpsh8hLpiqEtDKsEbzMdqOwxhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ke+0t9/ky6qMXM0/4Y1jAe7ip7VHhbtZ6LYnYhQ8Pko=;
 b=KtCvrEA0IDK4USrrUJVJshNIfcy4CowXzheu7G5l2b5nBxp8WCqj3jkz4t6Pc8MXJL0osYZrQMLLQ0iuSRwX1AivLk8rIuUSM9XXDIwG591gUiRxA4Vhu1rW0RtCwBWDplS1jSDpdfdetRL4aeks+iurrkffOmZMGkjoXnuujkk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4930.namprd10.prod.outlook.com (2603:10b6:208:323::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 19:48:37 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 19:48:37 +0000
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
Subject: [PATCH v6 2/5] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Wed, 23 Feb 2022 19:48:04 +0000
Message-Id: <20220223194807.12070-3-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 060b6405-7076-44a7-f7de-08d9f7057b6e
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:EE_
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB49301482637D4432F0A587E3BB3C9@BLAPR10MB4930.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9IB6QYXFvd1LC3uEsD2cP9+tBDy9Uq4rkedtoOjeteygv2+UKQBE4ZCicYDMWKSDEXPV2UBVJWpf9KU6L16Ri4m/cXxm+YxlGI56/pYjdwAezzI1fHK6zrvrUCTLAsvpIUQ4Che9Jt2/guENkd9kbK8nDo34fpiAEmvH7lL9Y9QaB9AxahTMHRVgjUZcCeSNZXaggpZUzzwxoOhFG2w8pfcm7MaUgZk7fPJZCPYs2PPg5HBgYtwQJ9sdSvlhOdVOEhHfxZz5bzbK1TLcJMew1ZMCrVNX7XuRci1z3OewxD1Y5lJigY/o8RP21nl/R5YcsnQF42pA6xLdp1VsWFu44wxBLbpmFQ+qHWNkihlwbVBIxMQvm4Vqfdsd9ywqxNL6iSgX0YY4lY1F/T2YBtZTF3H4ePjxuWwCzE7YTZuTu2tOei1I0E2cPQm6x94wBl8JwE8R5phS76imfIALpjb1goN3d81inkGXCvPce26X10OMsilbcukkQBDO2UOqunElr42G98dUu5fXUkK65miwkU01Q6DtkX8NhR1r4VSQq13IKniCXzihMRzLJwdOaxIWPXcnjnjskaAf0beU4ItDzGrYdju0MudQrFbaM10Nedgsm0f06Qah4mIZm5TWhz2fVkrGyV+hadsoLvq/zoO1Q6EC5gV+6J4/gbz0LRGR3aP6C/CFt0jIhxN2KLnE5eOpCLtQeMBMnx8SeA77UsxVRg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(103116003)(6916009)(36756003)(86362001)(6486002)(316002)(508600001)(54906003)(8676002)(2616005)(52116002)(107886003)(66946007)(66556008)(26005)(186003)(66476007)(1076003)(4326008)(8936002)(38100700002)(38350700002)(2906002)(5660300002)(6506007)(6512007)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3xYe6FfBG361SqCpFaE8ursLXgT0Weh3uDaBcdThSvgMf7tpCxOvW3lQi0GN?=
 =?us-ascii?Q?LIK+InFZN806vxArGzsm+dkhBu0iTcef0hsjleb96LDLwtiD8P0py3gWx0BS?=
 =?us-ascii?Q?KU1EgF2DV0a79zpXeGLWsvj+n73PSNKe8mzGpcxq21P++TbJmxvRUjTuyzQ+?=
 =?us-ascii?Q?5vsmn1udRtY+viLTJ/jPHUAgPemo7uO0L1K54kgX+YMWS68YQjJSJM+dTc8s?=
 =?us-ascii?Q?TiPLzvkQ4YFdNmQRvgfmUBxVGQfvX9qMFiic56Dx6TbQW4JGMFi+7AZwJO1h?=
 =?us-ascii?Q?d0B0KmxwoICiaiaNbwJR2QS+txBeyWWAnIcQQOBRl1Xz1SoVr/nQ2lJyt8hv?=
 =?us-ascii?Q?XWjKJo1galfg2AMlfV05OCqtUbE2nemS11iaro8qCHXJhRzWtGR/9SAqheQ4?=
 =?us-ascii?Q?Re1KxnQ3Ox7HprxCJkkugPLDZ9loI6804L1F+eLQ7K9qeVAGqyIBtO5WgaCO?=
 =?us-ascii?Q?uNz/EXeWcixSTlnVmUsbekCry+5Yx/S691GR75HW9VllvBuk9FB+Ii89wi36?=
 =?us-ascii?Q?tSMvx8e+4M2wURGyzQDNf16prpqMgWZCZyRP8FwyejJQMHEAm6LKvGQfc+3a?=
 =?us-ascii?Q?CnqdJw4FLf7lXpdnqtpUQYs0x4jl8RsTxD4HG9i4ctOS3ctxCmCf0gVNFBYb?=
 =?us-ascii?Q?fWIiuJELbFyMouC5ZeMCBMAvrb9Nm8uKul4M6n07tgWo+e13npj/56vxtdxb?=
 =?us-ascii?Q?NAfFdk7X49ALdy1vgkDoUz322y5gwr8uy0RM5u7rbPxI224XbUkWs4mnzpdm?=
 =?us-ascii?Q?CzoJk4+aJ1/C+eQwMXGKLYd1vdIeWe7Z4keASUsNbx7X2P2I01OiJ+U07n9V?=
 =?us-ascii?Q?crUdk5DqDlqzpDOr/pIrOXNKc95vStNaLcHrk4OpnvKEwcJuqy4y+hy2p8ay?=
 =?us-ascii?Q?wanmSCmrFateEY3tkJkKmq060BQaIicl8ED9aMfZA85FKlnVkAgrQsbnv4PQ?=
 =?us-ascii?Q?jqRakD2tZqWg/c+swbrNeSd5uEjuZA5Y3JynHUMDQ03zfRmcSoHdKMaC17Ke?=
 =?us-ascii?Q?Zh1GfA+UVAKgjTQxloh3z8pvF/wtuN6C6MmEO5idkLnoAPJfqSy555hQd404?=
 =?us-ascii?Q?1K4j6xPse0qoDPpEvFweBOsOOK2cwaeyS1hodqgBM9FVrqRLMutR7QQ7iYZB?=
 =?us-ascii?Q?oL82Q5GTlkXXJUWIGizGmCdIobZ/zB4YlmRkZwMRbaWUR/A2ADhcXdNCge++?=
 =?us-ascii?Q?1xnz5MfaudNwe+6bCuDKwwt6BcSI7nQXPCWfNcJebIOHGq1H4ZunQxoJjf8+?=
 =?us-ascii?Q?inh4gwoRG5s+4yyLJfSP1+Ngf9DPl3WiMvfEA+XvlYFAZYeBWK23x3e6a129?=
 =?us-ascii?Q?FL4D7Jl3f5pQhiJaP3fIymHx8YXVGN5AuANZpAGorQxzIJHx9s3wY9rfZyfR?=
 =?us-ascii?Q?OST2N0xfLLMYZcHzrpa58WYH6RL4pv2nairfmuBaUnmtt2mzKqpzeTH/9CdC?=
 =?us-ascii?Q?0+SPvquffctZ9KVvCDivjnguGEPrcRMlw4bZYD88q2DYARNlfo4hlpXRaNez?=
 =?us-ascii?Q?qJLuC7ZrVQ5FE4pxhCgko4Rt7HT4ZRPkPqHC/kYHaCndTj6BdRT1rWu63/sS?=
 =?us-ascii?Q?jmgErcCFvZJp6OV7SsHOJRHVEHFt8rXfUFWwB/N7gq8j2pJSRINJ18R2llrG?=
 =?us-ascii?Q?T/2QB/yPdQfra/QdNokxHA/llBc6YEII0HNirX4nK0tG6BmIVRVThQokWC5a?=
 =?us-ascii?Q?d+s4Iw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060b6405-7076-44a7-f7de-08d9f7057b6e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 19:48:36.9277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ug4Lweo2bEIROmgIQ0AxkDCCPnh1JtnvjhQr39CLCoBPWqmxWVIgHLpUC2AwE0DxKGF6wMpeKKXT95ryX+m2QgKMocrRuD7a4aaaE4qxg+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=839 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230111
X-Proofpoint-GUID: OswpN3nvueKMxgM1Do0ybSKUB45RzCFe
X-Proofpoint-ORIG-GUID: OswpN3nvueKMxgM1Do0ybSKUB45RzCFe

In preparation for describing a memmap with compound pages, move the
actual pte population logic into a separate function
vmemmap_populate_address() and have vmemmap_populate_basepages() walk
through all base pages it needs to populate.

While doing that, change the helper to use a pte_t* as return value,
rather than an hardcoded errno of 0 or -ENOMEM.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/sparse-vmemmap.c | 46 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index c506f77cff23..44cb77523003 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -608,33 +608,45 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
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
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
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
-- 
2.17.2

