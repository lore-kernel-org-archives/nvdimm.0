Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0962F57
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 21:33:48 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KEb2w031267;
	Thu, 3 Mar 2022 21:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1YUEoTnh1aGzrXHHQVADdNm+TBpzs27JjOXaNE3VmQU=;
 b=zEVQK6ZYH0cCSGzHwYztwXM0GzC53OCLoiYPFCAozmPJxPcchOS9YaCJP39yXsn6Jnl3
 vrJ+fiYOiYdWfdMVRthG1CzTpESHkmS5mJSlFSAcmYkGYjLGeKbHD+tytg55+yQyHUfb
 YLseRC/+AX8dQVmfn5Oe/Y0NkF0drkKd/U683WlCM/0ORwhx8jGs2Dpnor20b875ogon
 GYwMOU/u/VhQpUR5yxikzrq/liA5hWUjc5IjtmjcaOJf0XskC0A7vEfh1Y5PR8YsaVpJ
 4Oe5jpnVUcO+HdCHex2JeqT7PYsG/+ZLuoAmHiRQ3cIR1Jeo38b7DLAv/cxTrxIxSZ6J ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4ht05dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223LKtL5132075;
	Thu, 3 Mar 2022 21:33:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by aserp3020.oracle.com with ESMTP id 3ek4j7tpuw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asOo3hA7Kfxzrlu4oPjFcmH6hllu/8Xkz8TZ53vX125GUjX5rcOquAOtpJscixCGH+6snhj8j8+gAUVLzMpQM+/uyUOSOO/1zobJjJUQkwnIiCSblcQYzJb3UQRfMxg57UZ7rjD8T4JIU7pA3zrbtwk8K7SDg1zeMItFOYiwi1Ouv+4ss2/rM7kUAUMIGPgcz4bPWAcrvCurFuKN/8UH9ireC6ZCH79tghwFBE4cw2cXYHuy//tvu8HETFrm04E114JO4NgxV6OyThwfSgAtm8J85tZxmA8ulNLuuf1oLV827BXDn2AmTypwFbX9LuRE8dktIrbZmcSmyoZ3o7O4yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YUEoTnh1aGzrXHHQVADdNm+TBpzs27JjOXaNE3VmQU=;
 b=JWxj2SIllBIm7Nw/Mqnsty6MP/gmWB7Etr+CwhgwqZnHgwIkGDbHuYV2TRmME2aDaY6mQ0t+mqElgVyHJ51fbx8yXGIaltI81WUXqyH1TMDx1AgfhovTdZYWTzikemE+SU5/IiosLdWORpUUgZR9reDg5PL1XJkmHYHPRVfSFsUvJx4WUyVsicxmcPko0EhU0nmh9N26c3aby63yUwn6dCirjx/Fi2NarL7aC33XGtmENkTZ+Qo+G9s7ya6mj/XjrEbde43289x5u1OYiw0BMQkVjwO09CqfulDHTEuF7J7RwhADJKtHBYSslf9cP2VvZthBxMsBXn70wDMBVqhw6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YUEoTnh1aGzrXHHQVADdNm+TBpzs27JjOXaNE3VmQU=;
 b=S33goalYhay2wF2yMWvxtykE12WXc9Cd6BDeAr9745x1qQsHxBknQ4VBQRL3iNAv2AU88DRthDSKqGOQsihTlxof91AX50NapU8XdmsDtPSGqSUl2ziXs63awrgkb/YT9VHqErOaGnPGyfnqMoxe5mmCj3i+MngsO1+TVmNcVCw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1658.namprd10.prod.outlook.com (2603:10b6:4:4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Thu, 3 Mar 2022 21:33:30 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 21:33:30 +0000
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
Subject: [PATCH v7 2/5] mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
Date: Thu,  3 Mar 2022 21:32:49 +0000
Message-Id: <20220303213252.28593-3-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6ad35acc-e3f6-4efb-a37a-08d9fd5d75d6
X-MS-TrafficTypeDiagnostic: DM5PR10MB1658:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR10MB16587087F5E2EC4133ED90C2BB049@DM5PR10MB1658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0MpJ5wMYcU4MmEgCHq848PRoEdQkG37pcdoNf8tek7YGt35hP5wF2qAEC6U+NwrRA04BJ4atBi/YXDg3Gt/f/dgo3AAmIWejx6DGGyL1APqxQg6pt4kH81lH+pRNA4LyS+zJEO9mpdT40aGLcg4HQ3lYIA1XGwctzp6LjUir9jtIcPCZubH0B7+ucTCopJJ5SXx/9GqSHztjYJSar6aTi2wwJkdRpy/AnyEVWOnJ5IfVmYEv0hlwh7u4SNn0RRSSL/RF911m7fAa56gBNbEGEutCij9gorF0QYhg9pzwtpTJgR0T+Z7yG00/4ulZZy52aSnCIHbxma8y/9LQa2SwT6Lm4oAnbf4A8KQvqsKlmMdmgrBvyKTnkUpg4NiGMNa0z1xNVDL8sQZwrZVsolDQLFENBGmm6oHSvrkSjRnXNa/NAhu4QoJux16p4KdjvqKYKax/1HlStWkX1f7/l1XT/O3fl7shAFmu9TGfW1sJRTRdKQ9SiZ741D/M60fXBCuGfcCeI/8BuspKqVazQcv5DVoJxVeXRDCCTSGAv2+1Gdv4q1q1l+BJ4hAp33kGrCRGbKE8S9reT0DaRlvhEi1MJPSxNG0TwIqACUMQrauwgHa1ZUIV/St1kxjszemW48IVcVTkuJIoxXWy2piiqBoUdYuINOZDoyhKYanTLOD6N2cgX74Qx3Bei6mwN3dDwEoqmqC2yTINcfnfQq7tIaQvSw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(38350700002)(186003)(107886003)(26005)(1076003)(5660300002)(36756003)(103116003)(2906002)(7416002)(8936002)(66946007)(508600001)(66556008)(86362001)(6486002)(66476007)(6512007)(52116002)(316002)(2616005)(8676002)(4326008)(6916009)(6506007)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?v8aSljQqnuOti+aR3Uzl5uzL8rgIxFM38qVqebReof/0rv5Gh8CkvSmGmalT?=
 =?us-ascii?Q?VnX9b7R4Rw419QVUasHiEtK+pi2kyXvjLhLX4Oqc672PRqFAn3kgxyubQBaj?=
 =?us-ascii?Q?6guLOmbSuiiKWRPRyeoDP1BkUGHI2aRB5+hgkZX1b1eifL+4oOd1Ar8o1LaN?=
 =?us-ascii?Q?KMcghr/cNY8VkidOMilOlIJuuNc11/aFtME4qLgFis5s7TNNknoK3Qs5MnmD?=
 =?us-ascii?Q?4tVpaXJh//nLrBWFNdta23twT5GAqYmdA6muhMazayUje+Gb41l1TDrtRIRD?=
 =?us-ascii?Q?CfoIN1x4NSvR0CIwPI8yXiO6qPVn+Y8IUTsHZ+XvZ9HB+OZqZSjaFRbBLyb7?=
 =?us-ascii?Q?8Izt4bjb2LPD0iSby89+rwx6j9R6JG3SrkNc4vL/PxG3eKVDXAoCBtm8/o1T?=
 =?us-ascii?Q?8lzBqUAxW+04xhZ4vSzdBOeDWXD4TlfG5E6h8Tfq/nu7uuNUnN0BzgAgDBZ8?=
 =?us-ascii?Q?kFAeYDQm3qA0g6aTyYYHa6Aa791L/p3b9VgdFhLcHTwYaQgc7rZBJGMHpcZZ?=
 =?us-ascii?Q?L5Gw+j6FVOz0LGleujX5k3PsUhPDXBahK1l6vxWrCk2rmoZgJGg5ZDo6N4yo?=
 =?us-ascii?Q?9IfAJ/AUKvfvxHzGquGfk8UN9zPPQ0W7XKcNj3txj6ZZ+X5CLnriDgfsAHxK?=
 =?us-ascii?Q?RxS2KA7t5t9edsbN+ai/4R1dPXtveny46njKJjhwi/EMvC3h40acebOWBVRI?=
 =?us-ascii?Q?9rS3vFKh/0gJol8G3AJAZoKFwwstzHLuEN/G7XP5JXKdocq+ffIYRV1zwa8b?=
 =?us-ascii?Q?1pfo7TKLNhFGJVw/94sh695ViEur/RX8/kfbkw0ovljUDDSsdE5YmHwpaygA?=
 =?us-ascii?Q?WYgDH3kzZpw3QoOHfCzebQMc4q5RCe6FSzuV9gQkhDIVy4REvjK9jIKMNeih?=
 =?us-ascii?Q?jrRp4KmAflXOV5m8JW6Pzi7vjbUAbM0lVgTyqUjOrNlU+4dGMFQ3t9UiUnXO?=
 =?us-ascii?Q?BLkQQ40LKgZfk1TaaraF3B6qZjLDri4cY/grrk7/y08uaZoL8gKvel44bAs1?=
 =?us-ascii?Q?PeV8C8SBUSsWQsXABuB1okL0+CinMw1NMGVkgO5aMtCTZ6QnKDuk2/GmxsGn?=
 =?us-ascii?Q?c/HcjDgIa5otNLLjWG9G7TVKtnNhWKSwLPvuoPAz0wc7Kd3hMvCgCFzX4BZn?=
 =?us-ascii?Q?4ChFs1Rdjxr5VFLcO6lFHEVAnrmNzeLrjygaOQbjkzSTPDS8Ic0Vrc7ztD6L?=
 =?us-ascii?Q?5sCFszdy9gUT74fmIc/3xLq/dlE4zg552j+ROI8IBKR9uNe3Z67iSjFdTlPQ?=
 =?us-ascii?Q?fmYQdPsZVhLnx72ljex23uTjrzD62bhEqRiHRddpExEj2fFoGKmvrwumZzjB?=
 =?us-ascii?Q?CED/bP3lr3deso7Tv775VNkaXAAwSoAwI3DLa0Ucpt7ZDoiXoi4W4BFhdd3T?=
 =?us-ascii?Q?8KrmJqn4jEfSu7j9CfAJHeBTy1EE9x1woX8tb77F40BhWhDgWv/R+cuYEX1X?=
 =?us-ascii?Q?PAPzcuIS0Jv3Nor3uuNvmzm+ItHW2HJj0U1cC/5Xm5pI3/COTZavOf4qNZU6?=
 =?us-ascii?Q?ABxKTqV7ttuvgKs1fxaq3jYSsPKntQawvguXdRfR94kb7uZAQvd3ruYaBiO3?=
 =?us-ascii?Q?E3NmfB6KjqKrkidbUjWoBRR7Pu7BrXmyI6YBdD56fbO//vh8JUhZiyYNS4C+?=
 =?us-ascii?Q?BwWvqt3r+RNt3ZfT7ya2b0/uASAk5HJabX8qvXZYTvKbEv0WLGV54Q1NjQPt?=
 =?us-ascii?Q?lAMtdw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad35acc-e3f6-4efb-a37a-08d9fd5d75d6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 21:33:30.5265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VOe+vBA6kpFK+vM4i5uXuzio8YKNcRudZFj1sd0vdKMnQJXggIV30RRD9zJRC46mDbX8P1CKK1ba+F5XuU0IT45dfZl3aB9Qwdow5M+ycc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1658
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=844
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203030097
X-Proofpoint-ORIG-GUID: wDv9F4bZyoW_LGTL2FJQWVckmh4NANmL
X-Proofpoint-GUID: wDv9F4bZyoW_LGTL2FJQWVckmh4NANmL

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

