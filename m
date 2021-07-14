Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74A86D14
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:21 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVU3b022310;
	Wed, 14 Jul 2021 19:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+Di/bDAXE43OnWt5MOHanBvl+EkBqkE3LqLc4QmEmeY=;
 b=wFOywtjPqKULnebJSNbZW2Tus4Rvn5/DS2gHSu33OecJ3M917AmFmwbZ7+bjG0v12kTo
 0dgIBHtCIT8b+fIhfvwyHBMPJmE7vYK7htDM3voxKvAo6DdqzTYKqvBuoPZZ8XzXDbiu
 HRlLrKKitoFLh5Dn+P0uPnMMtSgZuLXYpqF8D6Fj8cXl/+DnYgoUz8vx/Ar/EBX2dP4u
 3ynceYltQEwUbHl/eTgVaJ1OfhkcZLdO2lQJpbnsVrKwc1Oa6c6agWZLXg1jdfMuH4S1
 PpZI9JvjP6ePWUsEYS6u8vI0XcRo+NjvM+W39sFVUD4gBedCM66ZRJ94jrDqRk9Y6IA3 6g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+Di/bDAXE43OnWt5MOHanBvl+EkBqkE3LqLc4QmEmeY=;
 b=tZHvYdHf2NqFuJDB+U+AfkCKm0uGA3hOb7V/7SfwToEgnvojuDoH3tWcnT1G42mR3MRP
 8eh/8CFD39c/EipxUclj7Oe2a+0AKKuBIPuy0M1CGsVS1WorkQBE2JXkKNccax4kXCSk
 JgpMi8RnOupOfdDGajyWzqwB8y9pQ1vJQc9HPkTIhnH/16hU0NFf367wDKdSg48x6jr/
 iUgIBjls2Qojo6zfx+8zBK7dv16FbTZxmnOWmj8sp5czOuhpEtNvgMuBucLd8zxSSUZd
 kghVlDqSf5cBTr91ygM0AUvv/+XWqUacp818akGTA6v9VWxUiIrAOB5mOiTC2J9U0jIk rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39suk8sejh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJV3eE080003;
	Wed, 14 Jul 2021 19:36:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
	by userp3020.oracle.com with ESMTP id 39qnb428qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8gq3pMR4XPBVigjP8RWjBKJpCxpy64yQYytxtzdSVg10maoAyyl+wlb5n2rZ1hEdunSofTovR5TgXc0BmH3SZq5o/2Rv8q1DaEwkhz/6LMNEdoz4gwPBn/wu6GouwA1vW6EA7SG+TAHF+o3MbwWh/j7yTVI7riiUBlpRBIHpADXlI4mlJx2WR/KsPNyjd3QZ5BlkPM1vmYkcESqHBiA6rj1wZTsmdIUekbnimbJr+NTwwTKAS7s+Tvb/e6+Axus852v77Hfs8O9ZYqdZhcBCbJ3ilN4f0YJR3+FS23sWZaPhelqPHXKNeo9bxprMjG9BI9RttDcJKhFU++1G/Iu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Di/bDAXE43OnWt5MOHanBvl+EkBqkE3LqLc4QmEmeY=;
 b=dr0IKNuUowF4TwibZa3Sc8yBPXiJ1ujOAn71p/L1V7bvVXt3nedTDkCfRkxdKypeYIZOFKbulDFf/ZvnJHNXl/3gpZJtwPHuxY9RkniK+hYfmDJxDuZHnh7rdcgyrNf87H7GHEVeWXJTlRSGLlnOss388OYex2hMVPCzibGomYCIXbNGf9OWWDq/HdZYOjjhEZ1JowJ7PN/HCd8rwXVmY6IzVKTy6cyZbc2S6FrZdq8H7sjgBlgGOpjLVC9zTov2xmEqO3mq3z2hSHRFvMNe3eCIOT5kgO0BjrA2IfCmdzw5ySda4cOfKDpbA8jeNOUDlL76MqVTDXCAVGcVO8r4xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Di/bDAXE43OnWt5MOHanBvl+EkBqkE3LqLc4QmEmeY=;
 b=qJTDfiRJLmWy0DOM6JZ4ypvwQKHn4kJBscWS1/1DDCa0pgwT5vm2MciTfXc0u6k9TH1pvVb8scVqR5FE+2T6Fl+GX74sIq6clZoYJVOhpNU4c31J+YZ3WQw+osyhBemf6ZnIKNTnGtmipgR8L6IIBOh8YgPGaH/MfJAf6r/bZCA=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:36:13 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:13 +0000
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
Subject: [PATCH v3 06/14] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Wed, 14 Jul 2021 20:35:34 +0100
Message-Id: <20210714193542.21857-7-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210714193542.21857-1-joao.m.martins@oracle.com>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebd03e5b-12d7-4cf9-b1e4-08d946fea3b2
X-MS-TrafficTypeDiagnostic: BLAPR10MB5204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB52046532E10DADE187A323A2BB139@BLAPR10MB5204.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5a21q8lwVpwxcM9cW28/LOqiq0ibN6egHH2OzwFLzxPNz1enS/Pb9EDa0PeAuR2bsWOkS12rE541Dsjt8i8G9ybUIWbcTkawCas4Qbj38GyVDvw3xExboo+wVQji1lxDwpO12ZMZB8+ZWtoZnqi6xCi7QP1lLCUcgB4SXeMwVeErDbdWbXa7Y/FlNl3LGz3GROsjeCG0MhzRBXbMOmhRAm5tDJmIrOqq8WGHtOz4WNOF7ETo44oaNTTY6h/bMvhCXl0McBXdZWM4IlhdIigEfjfMDKQ33VT4YCdAeUZnrNs4kQGWNW4vRtsL9OpOqP81s8Dv3HfiIQVmlpddUU5c1HrTpDqIpmIH0S1T9rVrXbxI8LwnDFLpj1rd0N/2Rty9jdQOLLxw/0tks0AEk+wNOshx8cdDgr8pOwIMW66Ts185v4tNnUeQMicVrIKmfMETmUFgRPBROJmh63t65tof/KcNPvbqj9eNNbQ31OW22TZQ1j87E/jmpwJXtJULWiFgwYObXuNUkmqDJObp8CXHKkgGq3cKQf8hU0VlHEDDPbxvDnRz9XO69vn2Bn46I+OPDI9qSVLnUWDE5USTR5S0AfDpWBQjPWQmIASCrlSLa4iqqu72sCpR8G16GFdUu1K0vzqPU8pdTuozNxHQt8k6lN0u3wmfWyMfsHRjUOg8jWNt+n9wliEMK5DbmBTp54/p4TGYlF5fZsVWB7eiqVtsqA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(8676002)(4326008)(86362001)(6916009)(7416002)(2906002)(956004)(107886003)(2616005)(6486002)(1076003)(8936002)(66476007)(5660300002)(36756003)(103116003)(83380400001)(38350700002)(38100700002)(54906003)(6666004)(66556008)(316002)(66946007)(478600001)(186003)(52116002)(7696005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?EmojyKe0/nih23QRqbezz57OeFvcW1sE/OS7hzXZ1N/7GNr8YKfHP6rPc1up?=
 =?us-ascii?Q?e6zVZ6Bu1xUWEUjWgZbG4tnOdEO2MoAWhSwsbR6lBBlcaqhDY3IVf9paiT4F?=
 =?us-ascii?Q?HkMocq1Sq9sIHuC5EAqaw76CGUH09PlGR0NzDJsmdbtbQfCe89jZahpcOwRG?=
 =?us-ascii?Q?DuG86rYyGo+d6rH9GhnDB4LiUDExadaTUGPqDiFF48sFT4dRoCir+WfgRO4i?=
 =?us-ascii?Q?pgYVJmHOwm/CpfdtkNgNwXucc0CYkOU3DvVOvaubC2edBmF+ecrM41Axfvw5?=
 =?us-ascii?Q?6GscR6J29dYOHqiJk7+i5dlhM9vxuX1ur+WSm1n8yMo2B3ElAWWlk+lpBrGh?=
 =?us-ascii?Q?5A5K23uEOpprhikU32UooLnwuWdiasxuASFgAbxwEIfNsSxvKB1fBCRaHxRT?=
 =?us-ascii?Q?Ij+e7gW6Iy2gbNP7t6IlMEW7/Z39atlVCtDzuAaelVODIgRvHUPJvgEaXgbd?=
 =?us-ascii?Q?/btoFbrwkbecRuSqwwKhVJuXCki9THRRus3t7nZRSVph2RBba9GuMkYs0hsA?=
 =?us-ascii?Q?IJv9WxmBwie/Z8FnEh4dyecup2+bWe5URrIUgmqQrTARIQFu09y785L6nke2?=
 =?us-ascii?Q?kFAapUGnB3Q6OBVmEM2rGpBldLSAhiMoDdfQ4Ode4QNjB2pUAfrFhd2vx9rD?=
 =?us-ascii?Q?1GjUtk7M7zny+uqhGF1HmvILoYJs9lyhDDt3Fva9C3OZFHdl9UHMgvwSskQq?=
 =?us-ascii?Q?0Jf/TRJlelHbKvz8ESyZ2+KzIYPxYzqc1qH1ut6LYCehrAF6UJsvJ0+CL9CI?=
 =?us-ascii?Q?b37O4i+gqiH6z94xd5lZRFbFkOJPFiDrsxottPU767GVi2t9q6nHgnqoH9Cl?=
 =?us-ascii?Q?UoBkBswOy7xEoQUqDdEevfhnpIdEBRNF/2hsSJM6AS5pDhpR4SDw/BaCmeJC?=
 =?us-ascii?Q?vuIEYdEALY3p3w7/gDxVINvE2Z6KDRHB0Psmb12PsUR5Rl1qWgbW/lpXLFsI?=
 =?us-ascii?Q?cJMDFMnlzbns7iSnQADsaVcgBoOBmndw8Ef1snlnvg6X/dKC493lHLMWzEtg?=
 =?us-ascii?Q?S8n5G3qf8AQQ3cRgkgkSnUvBG9AlX9gx74sbGy+DMoKvJDRl9HwMoir3qEGE?=
 =?us-ascii?Q?JMUryBMciQQthlzv1/5sLaJ0GK7aB9JW5mgmeDpwmPcBVMRML8wn+MsmRZbK?=
 =?us-ascii?Q?ad03CU9NsxvaJVy+KoWcBcV4AAzfe8j1QPGr1xB/k3vST9XUXZkwoBBoksbU?=
 =?us-ascii?Q?68qcjVi8aeh757WJYgDqHsNV/SZ5eHQy+dBdK2dhOQo0hOMVvjY76PrrXPWX?=
 =?us-ascii?Q?jrUH0vmR8FcdCCosSs5sKdB8BxKVUFqUDVr+HPlWRLNpYvZubDx1uk/gmECJ?=
 =?us-ascii?Q?hNsqaIAWiRkLrUTmGBdNYY9s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd03e5b-12d7-4cf9-b1e4-08d946fea3b2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:13.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qk7nSZm4iv6K/nCYRKGZywN6/4VcmhVkvf8zaEIE4zgiiFE2saJSxpDP8g5KazJajOlrBj+/cknqcoQR4wtTnOz0SThXuElzIEuz/iPJIuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: _Cw1gc2gImGet65DfhBv8es3ivjGbjSZ
X-Proofpoint-GUID: _Cw1gc2gImGet65DfhBv8es3ivjGbjSZ

In preparation for describing a memmap with compound pages, move the
actual pte population logic into a separate function
vmemmap_populate_address() and have vmemmap_populate_basepages() walk
through all base pages it needs to populate.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/sparse-vmemmap.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 80d3ba30d345..76f4158f6301 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -570,33 +570,41 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
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
+}
+
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
+{
+	unsigned long addr = start;
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
+		if (vmemmap_populate_address(addr, node, altmap))
 			return -ENOMEM;
-		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 	}
 
 	return 0;
-- 
2.17.1

