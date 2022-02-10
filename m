Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41332C9C
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 19:34:31 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AIgT8p008856;
	Thu, 10 Feb 2022 19:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PwnPQYIZdOCPjNf7fzJaR+OCsfM2kLlldnauC3kDIjQ=;
 b=xgIiGVOpMk88rWKhu5oUiZZX6sRVe9j+FhwngDrTRNhDKhUY5PydpIuMF9Mpaaxv5oWq
 wvUuHIv1WOoT07FH7CK5Ton4FYkLQo6E2rNRHr9DDMT/Ro7rb7pv1SRZTmjzEGAHGLhN
 xmxmZWY9AcXwNNyNyLSH00M4vO6RAUDmXKliyoJCO7YQfl+ofWU+/IqSOOWNcgky0Hxl
 kMXzuq8hzJvtQMLowTLaPTPmLV1DGgy/C/AU04CheLPvJXpWfjs0XnuiS6iEuGuSe2XE
 C+OIg9eKzI6rD6zMVn2TM0CrLkLlElZlfFJE6GNsQT6ripnhTHAc5L30IoJmsleLWdMc aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgscat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AJUWth120837;
	Thu, 10 Feb 2022 19:34:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by userp3020.oracle.com with ESMTP id 3e1jpw3cks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGofokYmvceonay8XXRjdTtbS8NSPFuVeqQuCWJLZ1hgQ7Nk9GVm4MOAjrVM+isbgX2daJNKmgBI4tcOWqxn3wSu7yij53RuYl/Lpbx3k3lf7q7QgrsZfRJ+iOifMihHVDnyPNLlPWmGHxOP/f7+T3hU+n+JZjtr9qjzhAY/8vqZNRcKAd/t29HYq78mF4rCVh5daV9+6Ke3eO2EpoLqhAJC6f6S0OgAkM33PXgo4o7nmh1Kg4+e0t7vQ2FNI8sHuHxNxGPeA+GCfPWo2CnYLuEHX7p80g7FPV4zRgDemfBIz7b+2k40qUhY4dXwktyLdTJAXcddQFquCAngbhEPZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PwnPQYIZdOCPjNf7fzJaR+OCsfM2kLlldnauC3kDIjQ=;
 b=ARjR8udiRmYMEztLNUH/0CyjySIL1OAax2HeoJ5jYc7WBPhOkd/BVk3JsGv3CKfQKsFtUyOF3Qk7KHeyu53fAyipXahYhmbBUspKYEPgQYHYQ11ABtWz+MdzRwFfe0v5uS0WT2MYrCzA50+wDjw9Y/NhpKll+cFAAyX6TEz6772C78gp9KpKtqIbykDCYtxqizbHlsThxfEOSYo6HRbgdLOSX4snJWxAVngWVdgUIDu9UyjkKV4ZhW0tD/9GhoxqAwFaRgXw2XZeEIb8H4dTp5iFSvJ0eYDqEt/ysW7KuSQvEcRGXByLGOIVQjdgkpy/369p2PvLN7u4rRknskNfXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwnPQYIZdOCPjNf7fzJaR+OCsfM2kLlldnauC3kDIjQ=;
 b=Y3gHuVOsO/8pTP5luC0/x0QqtS/GwDVZ6zEqZtXfDUwsLWkqqrukI5jWD3QFlWu4HWiKEZwWK2OAXAqK7k7F7xjW70LgVrxCqF60C80SKvgE3DOT0/5zgI5QZlNHx3E2+VXgnZCv8LJZQ2H+JR5NbRL8KUN1xd9J69Tkz3OdJ3c=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2514.namprd10.prod.outlook.com (2603:10b6:406:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 19:34:14 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 19:34:14 +0000
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
Subject: [PATCH v5 2/5] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Thu, 10 Feb 2022 19:33:42 +0000
Message-Id: <20220210193345.23628-3-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7f1f4f99-4bd6-4f77-54ea-08d9eccc51b6
X-MS-TrafficTypeDiagnostic: BN7PR10MB2514:EE_
X-Microsoft-Antispam-PRVS: 
	<BN7PR10MB251483340DE86F37A6F48E64BB2F9@BN7PR10MB2514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	WR4HTiH7AclO07Zs66qh9Q/MKEQ0zcNcIdYDClN62QOU0Gon2dw/ZMQDUHyQNBYbVNCPqLvN1LvSlQlEoyTZW03BGiNTw2Vk0kEl6Kq6TLMz56h8na5fGKmcF+hn/kHFcV+riwD/C7v5445mnUGUQg8lFbiro5NG4xILlSI5gJAckiAN/IFBYAEapspRrD4Hc5ShIAC2OCA/wx6+ao7gp7f2J6deseGlvgCnpiTD+hlwbnsLrTbxXsUllrDo+iEp45gTfkcfmSB2slPHpVzpIIf0e7GdPq/DLiXaWEBgblpcKhqoFcNDi/hCCkD3NIwLAnlXvxpPjVAt0fkuYDut5G59FIPdEOvVt5kmGOGOBXluc9uPdH0DtybaitfHmrG43+PFa7g+D4FbfwUd6P2v5ETlujvfbvHoYs4NUKoitiEBto86CReVXJZXch2ROq1VR8V83pse+TvZ4c4tUQjDTWKHuLb/4N22Jm6SjEiUg2gUTGmBF/osscBFz6vUVdA/S+K3+1wrM+S7THNqBjnG+p9xDdLGYSfIzJvXgBYd/MHckWzdcBbkPnzbKGlqLWJV6U4I9W/bAX0EVoNblr2SjL2P0HprhxgMEklvooNPrqm8v/HNTOAcr5Qn5aTWhykP9GBTI6BWBviNMeoFN2iYbZtPGRqb/cmcH7+egV+orZ9n2MeGUKRara+E8bnZ5KPDygcGAKpWiB1MS/0txuXumQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(103116003)(66946007)(36756003)(66556008)(8676002)(2616005)(8936002)(316002)(7416002)(5660300002)(66476007)(83380400001)(4326008)(186003)(107886003)(26005)(54906003)(6916009)(1076003)(6506007)(2906002)(86362001)(508600001)(38100700002)(52116002)(38350700002)(6666004)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Z1NlGhtf1iRHF+HVVMRVFGG9MRGy8OLQn0kQEsU4heOEnav4SihARxbX87xn?=
 =?us-ascii?Q?L2aW+iTihAjxL6qHZEEeJJcyCsROxLdzrUsg8JtJ/8EW4RzrylC2QpJMOZv+?=
 =?us-ascii?Q?wGjj3myobuj75+Lao9I1EsaWaYiP1b/RHtpT4ZzpCYkEEOCaCsXV4TqXOClF?=
 =?us-ascii?Q?B3+QrflsImxzFUoB/ttfwfT1V2tXOQf2w5jTxVBcLS13pEuCDPvhSZQ3Died?=
 =?us-ascii?Q?rlIw3aOP94+Gf02l//+HiVzrjMK0Fe2R1Ev5dD+4frYNny88HAo203NGPUNk?=
 =?us-ascii?Q?OVzBPfz+dyvC97jtaTd8oYtpqufxaKX5GWvC6i2bDWSWsK/Wy+58XfusFU9Z?=
 =?us-ascii?Q?ocUxA4CMiPVEqMayV1Vz+bpYncKtsU/SiFPlAf0hQXKaRaazgm3EP/nqke6M?=
 =?us-ascii?Q?NKRHzF14IRIi4tETduGzEKDL9RpTgrZqC/CxT2Pp8L+6j3aBeCy2jirYTHxb?=
 =?us-ascii?Q?TP5nwM0Nuz2AcaerKG3YHjaiW1tzTUprcV05mjrHhrsl0Po8ehWBx4Hw4q6Y?=
 =?us-ascii?Q?p4duLGe4MSbWo2TzBRy6//EjxlUUuLykLHwJmRpwUbLKfW9CVMmadchVfNd1?=
 =?us-ascii?Q?damZXtk9SdSj5EXEEo9kpzjiNGVZigzet31PLxmWKiJc1zWzryw7StSLiD7y?=
 =?us-ascii?Q?+wXrZ253rTlwLtlb+lJrfMxy49HWHg/Fk1o3D8B0wty3iNe4sNGf0RI7Wik0?=
 =?us-ascii?Q?vXYigs6doalRwVeAzL9vNxvJdmG2aW7kVDh0Hd0MjX+57MeKB1AM4VCUG7+z?=
 =?us-ascii?Q?cPVBYnKt1MBM7nc6GZtK+2MFLnxONc6jh/G9H/pI6X2nHGUay2q/80PTnn5B?=
 =?us-ascii?Q?AlZ6Ll020ij2DC5TDE55BhDrdPuIQAlWoSvSQJIcsklgyXkMtNUoH2aW5D6L?=
 =?us-ascii?Q?GfZJXayN/aZmD28CBcH3zDat3qHVxJbN52q8557WtWPVSQZ3mCgpdxTTm2dW?=
 =?us-ascii?Q?KUxKfGG+Ibed9XnHo60+2n+hhcqXTyllYpahiXTeT+W2Bg2j8kO+0j18IJfY?=
 =?us-ascii?Q?5HXGN1Wq3GIJ/XLZO2mBIHdMK2AuIV92jMX4F8MK2ABeWMO9B3g6Cj5NOFtC?=
 =?us-ascii?Q?xz+zFMJIKoO3vISzrQZh+/wIRbW/DqtAHyDauzGxTBPSoSGLNRvrQOUtBlhB?=
 =?us-ascii?Q?dN7U4M199/8RgCbQkHs6qEAL6FeCacYaCjh5hpzwYhVMBZmhwt/1XKhJqH9g?=
 =?us-ascii?Q?QHVlYOkDZYEtQ+bSfwIxncH42NabiwiCVpsYEWlpJndFK8s2t9xywHwhrFaV?=
 =?us-ascii?Q?+y44tNpFq67bOKAGLbPshJgLkVpgMMYzmH4HJ8DUso/y+KzhUB/ZojGAvxWB?=
 =?us-ascii?Q?ikU+vaP/gsWbz7uKwUI3T/xZTm5GzYALWsyLLVfCak1cP3+SJDy/ynx2ft/0?=
 =?us-ascii?Q?HnbCBqOGNkvnEDQozIXnjpWR4OUU/vMRX2aKs8Z1Tf+AdSG6U23zw2Ug0faO?=
 =?us-ascii?Q?L8YLsUv/CclSuYeC0ozDUoVEUkoavED4GrzU1nvqw7eTboLwlOe7yYrSCC9/?=
 =?us-ascii?Q?8M/R6IO08JVQfCkqyeCMe8z+MoQ/1L19FelcMm1G+dAByII61poa2TWtc7OZ?=
 =?us-ascii?Q?Gmg9hix1f/L+sWxJ05TUjFDlx8EEQnAIEcUm4/jHDUAxvJ+VkWtsEUYoWAc/?=
 =?us-ascii?Q?5ElSOWm7/FWqXV8R/AIy/gQAgFZ/bRFNnfP06RWAeembRwmrh0zs7euYDWB8?=
 =?us-ascii?Q?HR/nfQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1f4f99-4bd6-4f77-54ea-08d9eccc51b6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 19:34:14.0378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DL0Lb5qMjLEoABWmDI+25Xlk5lmonm+tkj1puNgjcSWzEUBpPWOAjUsjwnIKwS88lzcqm9BKFmmLuZxQuPDhc4laoAqU2L8eRJFtj1NjhnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=974 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100103
X-Proofpoint-GUID: 3DQoNGBrEwfav0q-baaaFoOoq0K3OpEH
X-Proofpoint-ORIG-GUID: 3DQoNGBrEwfav0q-baaaFoOoq0K3OpEH

In preparation for describing a memmap with compound pages, move the
actual pte population logic into a separate function
vmemmap_populate_address() and have vmemmap_populate_basepages() walk
through all base pages it needs to populate.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/sparse-vmemmap.c | 51 ++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index c506f77cff23..e7be2ef4454b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -608,33 +608,46 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
+static int __meminit vmemmap_populate_address(unsigned long addr, int node,
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
+		return -ENOMEM;
+	p4d = vmemmap_p4d_populate(pgd, addr, node);
+	if (!p4d)
+		return -ENOMEM;
+	pud = vmemmap_pud_populate(p4d, addr, node);
+	if (!pud)
+		return -ENOMEM;
+	pmd = vmemmap_pmd_populate(pud, addr, node);
+	if (!pmd)
+		return -ENOMEM;
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	if (!pte)
+		return -ENOMEM;
+	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
+
+	return 0;
+}
+
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
+{
+	unsigned long addr = start;
+	int rc;
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
-		if (!pte)
-			return -ENOMEM;
-		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
+		rc = vmemmap_populate_address(addr, node, altmap);
+		if (rc)
+			return rc;
+
 	}
 
 	return 0;
-- 
2.17.2

