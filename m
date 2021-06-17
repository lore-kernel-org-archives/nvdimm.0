Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3BE70
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:02 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIam6B020296;
	Thu, 17 Jun 2021 18:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+Di/bDAXE43OnWt5MOHanBvl+EkBqkE3LqLc4QmEmeY=;
 b=fTwQvBPq7I4wQxxeWN2dyis1BOck+IbHvpnBjwppe6weHWyTrmO1IV8M+S0nUsSxaZyb
 aEuGEK1yCT6YJ8geTmJkecsAy3gaeJSv0/zg1hUy+F9J5E/Me/zNUqqfeNwMuUkjrtk3
 /qVCjH9ksyEkvUkpSIiB20S8m32mVMGvLcP2Mez0jg+IGRXzi9Cx8fDw5bs/fxIA8wgq
 jt5dcVBKgNUoPJNamE6LEg0/lemy7FzsMkjcc4wwqYwRzWTPBStQfao//mPP3XFl2+PS
 PDDc7gfgTg8i91oUHJGlDEyijpP3S+HEa55QlU25XrDHocyWfb2UZ6szd6+ehB6Ow5Kz PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39770hby05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjMmu165499;
	Thu, 17 Jun 2021 18:45:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
	by aserp3030.oracle.com with ESMTP id 396wavvr6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mL2qrYm/8rSFAGQAUGVv0ejZB82qdfebNhG352xVnEZcurpW/BZGcsIEvYXq+jroj9J+a44Wy11l+smnwMOLGo3ZTLK5XoYB7E2ksJpP49Zyjek0lT7qKuBiHBxScuro5PuDVyTBmtbIEFuU1I3t1DFABpPy5ZMUTQLezpquVSlduAntLH6+0rmg1KpEt899YfBp8lUgbVZhxiN3w8OyE5kzETiHDUpdpAHnyBVMEmgWfdofnaF1F8DWyDmwz1QSVz9IBtKZ40s1BcoN0KmGK3keZGFcx8t6swj+L5efs7XM3nlo8iY63AMBlT6idlha0/HeRSfKwncW+HXEzlLnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Di/bDAXE43OnWt5MOHanBvl+EkBqkE3LqLc4QmEmeY=;
 b=JzVX7YunTqtlKwh9sZeKYHlW9opNJrG95ZoPvfMbdL7lqOc0oAAQSpB/XKFlorCo/GoS8k7ZaJW5w6k0lfzCeNQuYWSfZINgJady4sz8+8OXYgbrAxBHsYnCDeul6WqDcAdGgD1gQPYYGDhhA5O0vtqtqbQY/RjFQrW/DnYKYFTjWQEHECjewD1DeXP9sCjuCaViBNdjHMuwq0qt7ouVzhMZJ546PM0FChBKzG2rXZaCJeYbdniWycQbTqNWsD052FeyRo8mfKpmqIiS9vZygiHuZbj52xWM045HDOkBKg+R3U4ZUzstzIKByt3U7Sz2nrjMgZvRC2aBqWFABayG1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Di/bDAXE43OnWt5MOHanBvl+EkBqkE3LqLc4QmEmeY=;
 b=teU9lVbwLHL8fccoSqDDZByE87FUi7xl70Lm5dpEY8qUvxlkTT/fp8TGJzrPgM3wsYzp9dQ84soFA69Zf6yhVNfphBRi8sSF+ci40ixNxdGRiPPNwLLxRiiOuEWZNQlokcpDotMXeJMk0ajH9dorIL5lvrWvlikPWhAWtMazWtI=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4365.namprd10.prod.outlook.com (2603:10b6:208:199::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Thu, 17 Jun
 2021 18:45:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:40 +0000
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
Subject: [PATCH v2 06/14] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Thu, 17 Jun 2021 19:44:59 +0100
Message-Id: <20210617184507.3662-7-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13f03156-e50d-4f1c-c178-08d931c01abe
X-MS-TrafficTypeDiagnostic: MN2PR10MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB43650E545424A97F9F4C89DBBB0E9@MN2PR10MB4365.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vQk4kcpMYlyXwaHABt+Rtdy2YtYvUk5V53SKDI6+himylDBpQTP9LZY0zODNyNCA8aTxI7ygD/IsBPyqA8pG3CHeWLEuyvK3wVR44KMxDSlEPCnXJVkGN2Nnbhnh+78oidWgWlV4IHfsM3qUGamYHDHNS7zrDRWCyLmW+L0YYbK+KxebotWFX6Qf1j6tKxvB1wy0VhzcZUyzNIW4Eha9UTAgSIrGYS6djU2ZI3YBVa33bGrQ5VeH8GTs0h87YdQ9D4Q1VDPGvYjZnTPxab/wUdgZ75qav3+FLtFshEf07jqMd3DQjlKEiucxKcYkziT1Eez488BXZQyCkkF6RkNz/QsN1EqOJkfTtL8qyNf8a4jOxhaTufLjX4psKWUM2zhOPX1q0IekXTGyIew0AaYPfS69MB1dmCKt2PpOSgYCM9JT8V2LjIy5Uw58+fkMW2WDk9GVgLiAFmkSWUIf4a6HRH9/vbodOaQ0LRoMQgFR3d5HAo2r0kR4mGQOLiXxled9plQU0yn9xjPYqv3HezK3TGLJ3ndeCcbsA7n1e1lCq/RBcXxmcXFM6Trt0jRirWQ58pn4EHM+r0PuotAltDB28vxqy4Pm5pdaq2+QZjwIbQ6ATs35zimAIS+rheH78rXVisD/eV2W7A+T6G/qhCYzLFYrRWymQbrIwGqTa81SeFU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(2906002)(16526019)(316002)(186003)(86362001)(26005)(83380400001)(1076003)(956004)(66476007)(66946007)(8676002)(103116003)(6916009)(8936002)(5660300002)(38100700002)(7416002)(66556008)(54906003)(38350700002)(7696005)(52116002)(6486002)(107886003)(6666004)(4326008)(478600001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8Y/JqGwER7veMjI4Ba4xouIC1Q+jWsAv8B7iziHRr8Gho4YLPNB2+E8GsqE0?=
 =?us-ascii?Q?qRA/8cpd7ZpW/8RsfwjvbHRkAMTODZEcWQNj0kCMorHAWMLvwi3gpCcsnw6b?=
 =?us-ascii?Q?NheF/fgLEDylwVRwfkfUwJt2Vf6FGLq6HPsLO7lvPwXTEi2dQbvIchsFHTEy?=
 =?us-ascii?Q?TrZf64ow41pUy0Tko7R0xgLI2xOzXsSGDTGvsw4NK3I2xGrdVAR2tk9luqf+?=
 =?us-ascii?Q?CKYcSDg9yPhv5Qj5H1PC50v+2He6sRjOVPPYFRd3VolWdwQc/futQVGh6gnm?=
 =?us-ascii?Q?TvX1zOEEHRMgCLwQTBtrgo4R3JEOkSmTIDdoQQeceSE9DqRcSR22YbKR2YuU?=
 =?us-ascii?Q?X6bYMtETiiVGdeNOEWCAlYDhyA5xhGfPMg0GNE+tgr7WEKA42WMyYnrFIeSP?=
 =?us-ascii?Q?knS7cLa1UsTK7sLpRiPtJLWswJ580DId49DRATAr5/6WWUrRYTgQlQjhZkdp?=
 =?us-ascii?Q?1XdtyHrx7bXpGUAYHqHyRNBtTj9im8PN/7+dmrul5MD3NPvYsyt3q3isrgqY?=
 =?us-ascii?Q?nnOiLiHjT8rDJpfn8MNrBHiomy6do1Mlo8BZQiWTi+UoZKuxwNpnm89U9QmT?=
 =?us-ascii?Q?HzpU7/uqHke9B1i9bfrpeRpEmtlhbWyu/lTZnNTceNTP8KbaRcf6l2ABUmmt?=
 =?us-ascii?Q?xUzWnstEyQqr5ix8vaoEHHCTIRqy9525XFeb4oI37c6k20L/RI+PpxzK6sxg?=
 =?us-ascii?Q?8Omoi1ZHaXkma5epYTO4tznd1ZhTE3j7VoyVnbaJwWOjQJpppFPlbFp/KeqL?=
 =?us-ascii?Q?l9HSgnLldnmoI7XpLUC9qob4Ap7ZTZ811aouGUftVkMsl1iv5cJ7rZ7tg8iQ?=
 =?us-ascii?Q?ab8DElLEiwjFVXBq/BuA95rUYBJSuSsZy9D59uQu0GbsIF33IBEvRoaBImI0?=
 =?us-ascii?Q?lhcFmiEkiAG+3U/paF/xfnBtgl9LGD51N0VOsHJrUOz+jbk9XfThaPK711S+?=
 =?us-ascii?Q?KcwWrgEH8Enl83LYREGGHXx1TdPSwB5tHbGsaHYJknhUGy6r3nV7HZ3dOVUX?=
 =?us-ascii?Q?c9+N6fkkbKGi7we4S8TqKhuof/3m6w0LsBAvbl2DAK1LpZSl+ziCuxGqDrfM?=
 =?us-ascii?Q?0qm1ZN/rUSuJII/TY7iJdbOGL0FnG7cbULAIJenlifhSr3+D1lPT8zDwxFyI?=
 =?us-ascii?Q?iJpUf4Ycq9udovmsuM8jQ3CIyCbScqF1+/7RRrcYfiOnH/UBe370EMToHeZ/?=
 =?us-ascii?Q?QGnW2X66vGsdgQi/I4idUxm2zDadJkVrAC9eTGzVUp0P58MSRJ/gS9RxN4+P?=
 =?us-ascii?Q?eDcY4shduAXqSBSE3TXY7Qrrw1X4FDDyyusSroDVw3iLtJhYHMVucCbG2yQf?=
 =?us-ascii?Q?PFnjPrf8oq7ApyjIqlQ+R9NI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f03156-e50d-4f1c-c178-08d931c01abe
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:40.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAOlPGBv8USXstf49nD0FgXgZ7M6ofqUlBrcQLHNGpeuAcVrzA2Ku0rdUj8w4jxr1/JMkLsjpVen4KRucH/SLWLz6zfMN9PuZ6e7xF35azc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4365
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-GUID: 6a6TrCDbiXdyIACpoxPDiHzUZhAgiP4X
X-Proofpoint-ORIG-GUID: 6a6TrCDbiXdyIACpoxPDiHzUZhAgiP4X

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

