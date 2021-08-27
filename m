Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A67F3FCF
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:23 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RDWLfw010418;
	Fri, 27 Aug 2021 14:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=q84FdhJkLd7/8jzcasxBlvgfiKRkbuLEBL5wIpeF90U=;
 b=IVtFfwGmOn3Vr9SkzVDlYUOayTisZFwdE8lJF01ZlQ/jNc3iPvLaXxmrlg4/EAzHD1uX
 2EfQ9GDAiHOdqei1cOv4lE+43H9V1mSMx7bQn1jRnEwBDyu9ZM/9/+cCqGrE4WLnyhc4
 d+Q8lnBOYNUo0sncqRdAM9ggz+PBRnQLaEqsSmSik4PlZ8sAvJfWy9MQuQgmfQmbDMF9
 4VZdv7jFJ/KfGMYr5ta9VEH1AMhBaL+H7VdA3h6bbd0EsE2ywfHFpufLcnyVHQO4QCjT
 K19TA+IkNH5wL14lWZvXQQwKrgHgoMxK7DR2WggFoppCNN918SahCWLt3n3UYrt+Xkr8 ng== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=q84FdhJkLd7/8jzcasxBlvgfiKRkbuLEBL5wIpeF90U=;
 b=SOT8url4BFkyWZzEBCPTgyeGq7uDwWsSfFqqTsRJrrYAejoEHtzMDHs1ro8+eUBsICyl
 2mrmPuaAcm7I3d6//eEwEmbHTFj3F3XNTbN2LNl8vuoHWZKlX6iBMKS0Yoh36JwzxUhi
 8JCtd+KjaFWpek+IeYfqA6fqrbv+ER1ckNpCoMEqNditZ7hQbxY2+c5fQ4Zhl6KEjQW2
 PtQXagGLkAnTk0NWGfjJep8mkoUoph08aINDHqDLL7LpXGah4ORABAvMSkSwD+HInVFv
 o+fOLwI405u1DvJ10IQ6CSqI/D2CoXxIOznWSItH3tkBKXGqHjQUSNwkoKHDiBRK3u7E yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap3eauyms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpOPZ187123;
	Fri, 27 Aug 2021 14:59:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by aserp3020.oracle.com with ESMTP id 3ajsabbqqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gV4dxza5R3ZwNNLZlxd6ozE2RtQy3UE71t50Y8S1xu/ukVxzpKjdTL9vneGCubO1wTIxwE4t7G+pskbXLecMu33r8fuZJ8+J2qUoiv78cip4ImNoe2cH9QE22aaSMd97njp90oB/LQyiXPLNWBqq5BHr2y5Lftuu1e772WcnvPMAxFX0hausod+V5agl2DUE5UkQjc1lxCtrwXS47oKu8a7abBL+EDlw8nyNw8JKw3SDRrpAvP9aCFf7qt30EQ9BgbhG3KYaPWnUpotRaVbvxZawCbXkcb7oXbgHRd6FBaw6OpYlEpXROnlDSjqjS2jhd899Ll5W8UW7oQ19gpDoAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q84FdhJkLd7/8jzcasxBlvgfiKRkbuLEBL5wIpeF90U=;
 b=hG1l3YLwNIpOoxR20YMXp3hiJfvrZ4WevTQwRqa6qm3FGE38oy21z5etjHX39036gr2ajBIjt9sQgWrY/0wp+yJzmIP4FPkHMb0Ezi1YrrtsR5/t90qaln6MoGCP+h96G7afz3PtwQ/d1EqQ1u3yl4h+U8e9Mql85Dcjc+cvusPM8+D6Ip6JFIfuVeaEvOt5OxHZ0WMoblFduEOZ0McZyfUbLM0trLt53J+iYpcmuHktey4m6U90IiSLBIIMtF3mFjNJ7pl5MSEhfi7aX49yxJfHpxx2DfL7l/umnq31xq2cNGQu/RJQ0BJtEfW4GSmJTT8c1yNf6oIB9WF/tyBZng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q84FdhJkLd7/8jzcasxBlvgfiKRkbuLEBL5wIpeF90U=;
 b=GNbqSeqWWVWo3navKtwNNwiaQ7YDpjWTkajiFo5f4qrBwCpd89JeGORp7XfMWMl41DSTDTnSIeSt7ZnESPU2suuayFmCSodYqj8jI71rWHSUPCJAF/ze8IRUJmtBZ6euvhbUDFm2DVf6uvMkE8tGXUO+cZ9fltKvph4zfQNU654=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 14:59:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:12 +0000
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
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v4 10/14] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Fri, 27 Aug 2021 15:58:15 +0100
Message-Id: <20210827145819.16471-11-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210827145819.16471-1-joao.m.martins@oracle.com>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:59:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d62540da-e90f-485b-134c-08d9696b3b14
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4881C1DD73C998D5DFA19E7ABBC89@BLAPR10MB4881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iUFaFpeqd48GFEgFSrCWAo4QoPlhLFCGNfQW0so9dhHhPy2s1gDc5fLdx1qGNIQ93m1fk5dXxd0HKjDpuaFDpqEivg5FNtTj4o97jW6sJ33zRuXut2HLpHBuUMchqGokvlDrjJOg/M/DvmHIs171J6iUm6Lcy+ZD3XezXbV+kqzw3OrFmPFSF1Zp+1UxjYwDZjhfMUsD0+M2a0x3LVYUBBGTspVAwJNjWwmBQtWF8yZphNe73ae3ld87hTi6UWjxHj9FHw+pzeTPbP9Kvrcaj9fAI77F8699/gAP3vpC46b8GilR99qDHHW3dlVdyjDU9oSD54AOAoJtNlGSwpPTPZTjHWzpE1VJ4F1DlcFaHi6qxFUQeubQdYZZqNW5wsDTDx2nXElPn6o23eCK+LLPCejSeLcjACbzXQ/siXwpG7IaysHO0iTJiCAEhS/E059bvn9q+dn8RVb+y2cB6n/AzCXhiY/wtgUm2JRanxkQUtc7SLYTPoSLAuRIyEzU4FFOQLZ5TCxqWqFa9hLm74IvkLHkCeB7J9MWmt7+5FjQ4vojbL0786lc/baewKRrRBk9ivCLEnVzLwWl57UR8vrNlyhT9QOAORCw0gpdXxWR+TU252V8nF42cWO+tOUxHOqe7xhZCXryhiZ1soaaW84yhMd8tQwDd8JB7dEy3nmyLClvjzpW+Bae39lqQ6dT65cVMEkR4dg3DbJT5OK6F/CdtQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(7696005)(2906002)(83380400001)(38350700002)(38100700002)(52116002)(6666004)(66946007)(8936002)(478600001)(7416002)(107886003)(86362001)(36756003)(6486002)(316002)(1076003)(8676002)(103116003)(26005)(54906003)(956004)(4326008)(2616005)(5660300002)(66476007)(66556008)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?5nxZkwKelwuj2bJzaFkb8gxbB2FNd2t6ey2aJ0fvac0NyiBLnG0+SMutRkh7?=
 =?us-ascii?Q?v3ZQFRNbQNbNhDWi9yoXfx3HmrPaNG4WRpvAB6H2uP8+ux4gBD51v9sfxgAi?=
 =?us-ascii?Q?tfTs5VFrlLcexgVZqaT7Z4cKstz/I/ND0g60Kyii48ktc/KigWQkuQ06dqiD?=
 =?us-ascii?Q?dT90xIpW6tQTavs6S4rTDSG9EEQ3743QLTRHC7UJgJUvAqqq2yaP5HGn3q/z?=
 =?us-ascii?Q?11P3CacpvVy9J6vvW8jJmWvH4r+nrf2lsC8/4Hp1qjSted0w1jifw/lwkCoL?=
 =?us-ascii?Q?+wQArgB203eQkHZ83oeT77pxNKGd4gonyqlCGZRRiRhxC4DjsZMfuIpGyaHn?=
 =?us-ascii?Q?JpbuXjW0PpnUyej706OnnYOvAAIS0/n9XpjyDxJuBsiIOVLBR6cNBXbDIUAT?=
 =?us-ascii?Q?/2gl/YaFbOnvfV/Ryh/IQPW4ct7waA4zuHMa5eoDgSqdYfT47qNY86ddxLNN?=
 =?us-ascii?Q?b7oPhVfSywzy8dFdtfVjHKj7qJaxG5rrcJRmcL7SMjsGHzJtvuHTNmuMwFGU?=
 =?us-ascii?Q?m8Q7akfWV+prugSa1kgEkKUBqqdaZBeWwXoBcVCj1R3ZrHu3vlPmc/VUyLV5?=
 =?us-ascii?Q?roceEW+3X/Fd8w4JNVBjUPOcYJZgK1k/1U7L53CsY3e1tmsKh7r8LoXtcyZJ?=
 =?us-ascii?Q?lS/zyStZAgHB7/gsUpkL6HkF6XPTROmLwwnFMXKXuL7mzfxZF8lhF1LLf3l5?=
 =?us-ascii?Q?oQvzvjbZrqdjBbwHK2+I/T8kVTdumfLcr3klwR8QyVHgqR4sxEbncmcj+vtA?=
 =?us-ascii?Q?UK1VgQ2hPju/c7pDAf7R6nn5y8XoqrzOHmh/hbwZbrX4vj3/PbKXEdC5J9Hc?=
 =?us-ascii?Q?sBBDTagvWp2++1XQeLjRXJqi0D+e1cex+K9tfbdc+iFi7P9Em0CrV66Ax9g+?=
 =?us-ascii?Q?umpojP31nGXyW+jJmqtgCwfpH5EGJTxzJJTYMQYDnbLxsdYvm3d/pxIOQzI2?=
 =?us-ascii?Q?su6vF3DdePv6Qkw9yljvVA6ZwhQ9+1os6KxVvmPWawYeMk5X9QRw6Ut9Ttdk?=
 =?us-ascii?Q?UJEsjvaiDmAClvm7vDofsGM1YT9G/JSb3ma0b4tnR+wNw5R8vSbAnUZJQc8X?=
 =?us-ascii?Q?v7tvwAz7Hka0QpL34SsTLuyckBbgLspWoTuOzXOzQ1XGkd0APBG0c3Y5C12S?=
 =?us-ascii?Q?UHHm6SOnGNztpTctmANvMnAw/9SOy3slvrWbRG74LolPhLFjq79zv1vPoj5A?=
 =?us-ascii?Q?mwU3DyBeaiveKpp1vn2ifICfjh7r5FSstFCx1XHuNzaTJ2c1eFkmZkOCEPPs?=
 =?us-ascii?Q?+LTblxvTrNvCDcgygqOzBjCxG66TRc9yy/soDWo6WyMjSPZCpI1AmuoyOmfm?=
 =?us-ascii?Q?DjppF1mtmyMryXukWGqenvOH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d62540da-e90f-485b-134c-08d9696b3b14
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:12.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqnCklPomZUdlb8yUEpesxLUpOgVQJhmQtneQuw5KkAAfqVzQFdenj6xWWAsjManLmMuJyt84hzOB98YBDcRXXlsO6LInaKX4uYI06x4RKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270092
X-Proofpoint-ORIG-GUID: pq2xjpxyrNCVuHZbn7Qwud3Py5nEtPcL
X-Proofpoint-GUID: pq2xjpxyrNCVuHZbn7Qwud3Py5nEtPcL

In preparation for describing a memmap with compound pages, move the
actual pte population logic into a separate function
vmemmap_populate_address() and have vmemmap_populate_basepages() walk
through all base pages it needs to populate.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/sparse-vmemmap.c | 51 ++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 80d3ba30d345..58e8e77bd5b5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -570,33 +570,46 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
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
2.17.1

