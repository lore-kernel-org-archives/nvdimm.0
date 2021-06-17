Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED496D35
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:07 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIZdL1004692;
	Thu, 17 Jun 2021 18:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=V4tl+Eg71XG44E4s8uD07Q6GrHzl1AUOqv3jJcurla0=;
 b=utaPcTAhQR4O6TQH5Zj/A2XvnIjaB/20Pbcolw9paMpXp9H7LJYAw9Rqoh9jfgN1D1Ud
 QlU4eHju5oPobKyZP9XJ8zFk6ww1TkFzt1CPxhE87RLODsqgk3ffn3x880DnzXOCTU66
 oWdpj/VzMxY/mrh2ax+/ebc88PECYWT91adedGne6WE2sLEmbllOdO7FgKwYYJQON/cH
 3sJYqXMOYeBSGVtTSQbUlp171xvH2YuktELcOHOrnvYeD7ys4lb6i9iVCxXXmckuqq2C
 b89IFTSD68xULzAJIhLmCD0+shVlXApc2ERCNhuWkpi2134DIDQQqD6yCSSJM19SubrN Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 39893qrcga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:46:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjCPJ109688;
	Thu, 17 Jun 2021 18:46:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by aserp3020.oracle.com with ESMTP id 396waw6wk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:46:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBBpDkqvo4MyexW1tojkxHpxjggj4yWQDijmGcYbddhBHkxrywhcLY8NKcResUQEoztb8/BguJoWztnn5ndXzVDeiCQ2W2syHjRpXX1kA5j9gWhBiC9bGA4NKSEqJ6WjM5FnyaeP7LLpcmCuu4XQuuHcb5wCXMJIQZC9LojHFpFOqQgHP/QBHBwPl6s/Ob36Ucb8AQzxOSgOOA9RIFHsZkeemFUfg/AHLqUqCsVnG3wbr9faqZZo3+GEUhRqtCgKPROWcka2nBavQwabU86qSyV5oY97l7iykTI2zY9hWtPi4c9YTpX1/lJ3jlSJCGFpGwh5/o820ZcO2VXmbl1llA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4tl+Eg71XG44E4s8uD07Q6GrHzl1AUOqv3jJcurla0=;
 b=LRzZxwpqwRACs1hFZU6BaOBVJ6rlk42pVkhmULl3h4YoGbQ08wD2XVPESqB/DTV38gCwLQF18MjezwlPxdi8egzsy2tv3Yu0AWAocN7N3zdZAMu+J05yNumGdUzI1SEF/D/1JS86uqY/ImJ0EZXEoM7ukKQ4bgY7wtfM8D+YFV+TjgZuAvLjo50Tn9LM6W3QWRgFrh7j8DPosqYopayymuqx7usYQUpfa49FUSnwvof7bFqcR4062jWlWih9Ji63k/7T8bfzU9fWfkH5GEo9jTIfxDrHqf7I29sq+rpH95ibt+ZwC0b8NS2HbJXxcHCRfYx04jkTarYzXaEMvsHjIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4tl+Eg71XG44E4s8uD07Q6GrHzl1AUOqv3jJcurla0=;
 b=rzxGsa6wyuwZAe0VMv3JA5XNBI4u+adGU3is5ZT1rYjU6VTG1uwMgNsFHj9O7diXc9CLE99SdwoY6DDYYwAk8nVdEoxYQ8Rudg2VQz4Lx3lpW6Ab0VCOXqW01uIIg9MrLetRBfBaof3AbqmvSYJmGu47qPgPCnGLqKVhd3O9sR8=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2913.namprd10.prod.outlook.com (2603:10b6:208:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 18:45:59 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:59 +0000
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
Subject: [PATCH v2 13/14] mm/gup: grab head page refcount once for group of subpages
Date: Thu, 17 Jun 2021 19:45:06 +0100
Message-Id: <20210617184507.3662-14-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e79354d4-c052-4741-e2e1-08d931c02603
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB2913474A23ACD0467F6516AABB0E9@BL0PR10MB2913.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bgOfRXcpe5KqJbKhZ0ayLb2lSkPaMjV3GEQbzCK/8SM35Y5hxV6YK+f84OIpNnnnZYoqbKl4lAaUN6tCZ5WEloEMIgPutL6Ms5N8AF5R/Uy1vip8J7hWD0SpDUyF/MAJMbL9Dnq8SXhk0oOQZs+cOQw9xX6ArfxkLqvNgvMYXqr+lJZLFfZBOVdUC6OWiGh1x/Ol7zD3qEvIbHilDLUOnaAJm4XX2aJ9zCDySp2osGcybZvda6uNGlwcXAfstF5LLw7DMxKKtWwr9imL0Tx6zWUYitZfPUHWIZBIfWt+OV2QorAYeDVlgmZCZizGwO1Beuh/UNt60A6mz9dbEGMtNF5AaMtiRw5qIXvXG8DANqIpWmfr9Tn+I7dlO+FCAmZ34BMaVQn2V47kyvDUJN59YKxgG8buUyc9DgrktRC//slm30PB7bIEG6+Ra/U/SY+4MkcioYZXtayqbr9XprU/Hz3Zwzwib9gHai+GV1EARc7b+cdzEjimW6cz0nwiKV1Db7J7pbMHZeLvoEwpTXENF2P47c9b75zR2HTxgZaoXCanF0Cv1wu+BaANdJqsse6mdiCpEn7rIU7RRWMsuETSOQn18zXA02bCnRY91Uh3EeoMuKKCAcwkFb+eTtnPDiNJZN/hKZXQB8Nw/qJ5okqwyNPHxB8WmNSpEn7W8T7Xqz4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(478600001)(16526019)(66556008)(52116002)(66476007)(38350700002)(86362001)(4326008)(38100700002)(186003)(36756003)(7416002)(6486002)(54906003)(8936002)(26005)(83380400001)(2616005)(6666004)(8676002)(7696005)(5660300002)(103116003)(316002)(2906002)(956004)(6916009)(107886003)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?qeBETB634nkvJfLcBu3Ozy2Ho9ULpjoQdAbBybeK8Ysl616RakCCsD9VLG/G?=
 =?us-ascii?Q?l/OzabjsBKUoUF++NCA8o24Ds5/z0phauU+gQEcD/9B/VBLsZrF8CKZjMFHr?=
 =?us-ascii?Q?nXS9/VJcaC1PoJxlY4/qCJAcFTuClZkBTZUuwIyz5uj5xmplhxYmH/nKfoe7?=
 =?us-ascii?Q?Q2n3RCSsnKBC+jza1hOAcdudR/9EcDVQNAvIcQQifTcHacYgbmYIC+mLueSi?=
 =?us-ascii?Q?WczFUhsgmkH+XICKvxpJFdqSDObZNlrRRzB86dFYh3EsFcONj9SPOE7knxL8?=
 =?us-ascii?Q?ATH5600Ev0zgqXwtEEbN5YNl7wuPhn1ZE3ElludGvqFXmBfYcrV76T1Rpmbq?=
 =?us-ascii?Q?JojMKeb7k/QpMgycIDSccgo2ZMvYSI9yqhGZamMehmGpYX/D2KO58BGOzPm0?=
 =?us-ascii?Q?t+AdVovAMVJxmjQtYx9jp47W+j2+XzoJmZFiLvJWy19FeDeQGJFDzhDqGcJM?=
 =?us-ascii?Q?eLw5BffQ6N/pyBLKg9WyuFM1C2CUdjyJ1aRKRDr+wN4P1uhYjIZauJpgc97K?=
 =?us-ascii?Q?CB1gvDcugxiwXIy68LRSith0ZNdmCMu54fnNjNVfhE4MPKO94YJUV86dRoWT?=
 =?us-ascii?Q?hc6Nqh51wWbG/LvakqwOxMD2AYQadIHkUNBeA16lz5hrMMMYunNdPVx46Jhi?=
 =?us-ascii?Q?v6u/LAW7BGWfXLYI6FDDdATywT6rTlJIqnsxIVPFOhEoVnQeto81z/80brQv?=
 =?us-ascii?Q?csAHNvWalhL6SD9A8bzUuHpQVRtduQ/LHJK2dX13n2iX8Pp+/f4S8jbEwiHo?=
 =?us-ascii?Q?CA9QiHLQQqgruRXvoZwgdbAdoanXB3+NJ3Sij7tjy4EgmAXOk4t5j69i3tJA?=
 =?us-ascii?Q?Oswm8rHDHeIyDBbBJHiKALWdzWBOx9WS+UbbgKF6MX+tj4u/cyEDrN+YmaxE?=
 =?us-ascii?Q?gUtwiUTwmSC+wwKVpHXJR7yvSNtqOpASsfXXodRCRaHaQ2bd7+u01OYG0Vh1?=
 =?us-ascii?Q?VLjKlcaOVipRBq97JsSn7WoALrkzI1l/17THi7hMzA6ke1FRAsqypgOoR39D?=
 =?us-ascii?Q?9lizduUtMJz1ox+h4n3J7lRqCDu24WlCw9NoaLc/kpl0Yw+8RBMrMwl0e834?=
 =?us-ascii?Q?/T879iAz8vEnF1ooRrHb6ptW7ecbsuy1IoCBIFnCEt5lP1sNqZKOTTy/HjoV?=
 =?us-ascii?Q?ZXPCNDkLeKeg0nXzhFVSpOOKcsu3GtUDheK2GbkLSbx2ClMq9mL3sZZ/0Gde?=
 =?us-ascii?Q?RoWRV3BeTrNOBAUndb51EGGbp3dBaByqzWXNH4B1shbE4OTsXG2SA3YBwXHf?=
 =?us-ascii?Q?0BCJESfp0EWd7p8R3Nu0UsC7Dh6gzuvsYuSiYpY4wtkH3hrvI7JQE6z7Gu29?=
 =?us-ascii?Q?YrbyjqNnqvsk4xOcRL7Wmd+I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79354d4-c052-4741-e2e1-08d931c02603
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:59.3335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YBbpZU9aVBnxjg+EKzwdgQK/o9rhlbq6GuGPDSzFoTfDFwfE68sOswzTPWl7pI4TWK+L8pR/g8Oga0ADnRb43pN+vc8LHX6cPo/+V8Wvkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: znkNf4zdkR9Gm8KzZ7KiIksF4Pe16kiC
X-Proofpoint-GUID: znkNf4zdkR9Gm8KzZ7KiIksF4Pe16kiC

Use try_grab_compound_head() for device-dax GUP when configured with a
compound pagemap.

Rather than incrementing the refcount for each page, do one atomic
addition for all the pages to be pinned.

Performance measured by gup_benchmark improves considerably
get_user_pages_fast() and pin_user_pages_fast() with NVDIMMs:

 $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S [-u,-a] -n 512 -w
(get_user_pages_fast 2M pages) ~59 ms -> ~6.1 ms
(pin_user_pages_fast 2M pages) ~87 ms -> ~6.2 ms
[altmap]
(get_user_pages_fast 2M pages) ~494 ms -> ~9 ms
(pin_user_pages_fast 2M pages) ~494 ms -> ~10 ms

 $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S [-u,-a] -n 512 -w
(get_user_pages_fast 2M pages) ~492 ms -> ~49 ms
(pin_user_pages_fast 2M pages) ~493 ms -> ~50 ms
[altmap with -m 127004]
(get_user_pages_fast 2M pages) ~3.91 sec -> ~70 ms
(pin_user_pages_fast 2M pages) ~3.97 sec -> ~74 ms

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/gup.c | 53 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 42b8b1fa6521..9baaa1c0b7f3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2234,31 +2234,55 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 }
 #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
 
+
+static int record_subpages(struct page *page, unsigned long addr,
+			   unsigned long end, struct page **pages)
+{
+	int nr;
+
+	for (nr = 0; addr != end; addr += PAGE_SIZE)
+		pages[nr++] = page++;
+
+	return nr;
+}
+
 #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 			     unsigned long end, unsigned int flags,
 			     struct page **pages, int *nr)
 {
-	int nr_start = *nr;
+	int refs, nr_start = *nr;
 	struct dev_pagemap *pgmap = NULL;
 
 	do {
-		struct page *page = pfn_to_page(pfn);
+		struct page *pinned_head, *head, *page = pfn_to_page(pfn);
+		unsigned long next;
 
 		pgmap = get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
 			return 0;
 		}
-		SetPageReferenced(page);
-		pages[*nr] = page;
-		if (unlikely(!try_grab_page(page, flags))) {
-			undo_dev_pagemap(nr, nr_start, flags, pages);
+
+		head = compound_head(page);
+		/* @end is assumed to be limited at most one compound page */
+		next = PageCompound(head) ? end : addr + PAGE_SIZE;
+		refs = record_subpages(page, addr, next, pages + *nr);
+
+		SetPageReferenced(head);
+		pinned_head = try_grab_compound_head(head, refs, flags);
+		if (!pinned_head) {
+			if (PageCompound(head)) {
+				ClearPageReferenced(head);
+				put_dev_pagemap(pgmap);
+			} else {
+				undo_dev_pagemap(nr, nr_start, flags, pages);
+			}
 			return 0;
 		}
-		(*nr)++;
-		pfn++;
-	} while (addr += PAGE_SIZE, addr != end);
+		*nr += refs;
+		pfn += refs;
+	} while (addr += (refs << PAGE_SHIFT), addr != end);
 
 	if (pgmap)
 		put_dev_pagemap(pgmap);
@@ -2318,17 +2342,6 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
 }
 #endif
 
-static int record_subpages(struct page *page, unsigned long addr,
-			   unsigned long end, struct page **pages)
-{
-	int nr;
-
-	for (nr = 0; addr != end; addr += PAGE_SIZE)
-		pages[nr++] = page++;
-
-	return nr;
-}
-
 #ifdef CONFIG_ARCH_HAS_HUGEPD
 static unsigned long hugepte_addr_end(unsigned long addr, unsigned long end,
 				      unsigned long sz)
-- 
2.17.1

