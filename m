Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D15D2FAF
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:40 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVe8R009412;
	Wed, 14 Jul 2021 19:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=V4tl+Eg71XG44E4s8uD07Q6GrHzl1AUOqv3jJcurla0=;
 b=pcIKmdfIFwwBUlUlfSdHT0LwELVa6x+yhdizAA4peqwwu9hJEQKnZvFIw8ULHq1alg4R
 Lt/a6SxIjM/pesH5WUv2Qr7nJSQhMo5hbkdA97TNesEyR9cVCMNBxNBFRJF1PH9zA4nt
 3aCnCoDwXsV0JBW/bopJNd/Ct9p4dVxM2/QQABSi+Jp2JXDIdGMk3oAFa/mKbzMSTBiV
 eU2eGnbD8zY403iMQje02M2YITZCV7rOJFpONzxP06tagyxA9NrvA/rEEn4a8Mw/lhZe
 cMbK+oNojDObP+77fbtXQGqkYlFBkPeq3717OiH3OE38edk+7sP4MmxGu6fjqK3V+AwR MA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=V4tl+Eg71XG44E4s8uD07Q6GrHzl1AUOqv3jJcurla0=;
 b=LFdg5Wp0g9iMXHetwOm8de4wgCp1V7RS2edBVa9VMCF/cJTQpzfbACM/ttfadtzL5Jjt
 tBNOidtj142ifuIbgnGDw1oncEhPQ1ChfPfyMROmIJkuq1P+YF3LGHAZv8PajT+fS9mX
 FIJ5Gml1bxyz98VwM/TUEE7/T2aejt4mS0U9XXJaGRMcw19blnyFVwNHGISMiiayas4Y
 QtHtEb+8CBACjn5lcX7H+kn1zH30N3uO00ndGjWJmdaKT6H6qkzjRAKlGai1+lVLok8K
 ysvPQ/AvNNllt2svGsg1w8fUMZr4QNP+wvr0qGqU7VIaIeVRqoxpy3i8dqSWNznuOqeC nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39sbtuk7v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUwFG187358;
	Wed, 14 Jul 2021 19:36:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by aserp3030.oracle.com with ESMTP id 39qyd1c60m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPJ0+SgyWIK+J6xGTZAtg+hUR/Inll4KQiI7Q8smCzLsRu0vPnX1rZZN5MreK+1wIedc5iQteO6ilmNdy09kGcr8d0154sK1dT74FATAgX3OxsEIctOUpUDGigewO5Q9HzFWd3H6vg4dcUtADm2d8Gtv7fkQAHnu6Hdww8QzM1hxqMBAXEhyJwRzUpyVJh6FV9fCgBML0QjvY9AD50oxXyiePR38FSrJbYP+GKTNOuU76Wb0q3pr4/A6vV5MDXdouxbbDh9CprI9kY/4j7Vx/DMSeHbiYUca9SR4t8UANY0CL7s451xJiEm2wMJZO4qoxDMWFFZx/0hrWJew0q5pRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4tl+Eg71XG44E4s8uD07Q6GrHzl1AUOqv3jJcurla0=;
 b=O2nSQKZ6w3lzSs3/yma/0EbRAZDlTkJcGIkqTxk7LCwL2GITlZHSwVN8xXFkEYdj6v98+AasSTNceznXR1NflQd3Xbtjc3Q2Yeuegl2K5Iv9+f5YDgCZxFcMubZ6HGncsBLQka6T6a4jMIeZsLcudEGyyYoCJG5jS0rfT8rjGWhBhG16Qf2pqwYWKP+an1J0FFTclsGA6wUyUa2HyAGr7MkTaxch8JwAr9jYEJP2bPnQTBXGib5IU0q+Zx8xkTEZ+lByCMkdgL/7OJUgrES9ZtYFjzxcN1RUC5gCZtvaaMmqhkodBZGbuWkN3EAR5i0baYmcIjMg1cKIyLDMOuP9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4tl+Eg71XG44E4s8uD07Q6GrHzl1AUOqv3jJcurla0=;
 b=ejvsZDR4MkGXHoRe4kNFAUKtvc12T96RV8a2tSDR+sR18dTGyLaqr8miIjypabMDRT2uc1kEXr8W/iYJgWpNdFZVc+Y2aw+TKNdFs3BNmJDGtq905NI8cwdfSj0+huOpMu98jEqq4BWeyTFK2HsZXv7YaWOYnlmD9o6SfwsfA30=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4368.namprd10.prod.outlook.com (2603:10b6:208:1d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Wed, 14 Jul
 2021 19:36:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:32 +0000
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
Subject: [PATCH v3 13/14] mm/gup: grab head page refcount once for group of subpages
Date: Wed, 14 Jul 2021 20:35:41 +0100
Message-Id: <20210714193542.21857-14-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b0bd4e0-b5e5-4efe-cdd4-08d946feaef2
X-MS-TrafficTypeDiagnostic: MN2PR10MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4368D828C2300C567EFD53A3BB139@MN2PR10MB4368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	e8HRuVsY5GL5emEH27DYgZtX4kPTweEDwCa40TY3MMQJ4j4YKRB2NHBPTzQ84AYzLSPatkJroLT20owCEodnFd8xij/lFW9EBnGGUvfVB1JNTrj2uQw6ixpkQZ1kuazfJgvNcZD0ZPKc+n9vMAsDQ1LpKjlSXQcL0d5Xycr/WCNCkq/lGqvlEHGmPKT8aovUqY/TtgconOi8V70h/FBDDuLqH5/YK1mTni3RVZicK7TB8IyRXkZx2FFvC4oNxEvKX12bWu54dVUBgloIzxxtXbOMBBiA+e0GA34eUtgoqc1jF/2pmMvbQpd9Gq+U+rqUEfabdU4mtvKy8Kl/POojtjGrsEI3lRcBiWAjJQm6a3jMNAfvlsOfP5EAG4VrbCohWrpJJ3MjH/e0LR1DGZmKOVUE9B5Z5DyzNtUzLMXPPdUf5zxqrjTZSql6rAYL9op3oN+xA1JFFF+07KiXRnRmZ0kVM8dlYfl2WTz77r+olatEdhQ4BVAFRxeGP2GBqAap7ReZL0DqPGUDdvItHvuQojof4k9tBCSuJgYZgV0czwKWh8687hw1eVXBtn9PmDJ92priyED2Yd9KFEmT0dPaWVUkPJsF1J4k1dpYk57/lf1Alv8KW82/6W9DvptLBak3JIRBnDtA2YTtgyFEDnwaNbsulLvNqNEeGh7Ivzg+FpggPH7/95hLeby+zm7yKZL/hIotU1O7Jj6gHvlFLotOeA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(346002)(396003)(7416002)(26005)(6486002)(83380400001)(8676002)(107886003)(36756003)(6916009)(54906003)(103116003)(8936002)(38350700002)(2616005)(478600001)(6666004)(86362001)(956004)(316002)(186003)(4326008)(5660300002)(7696005)(2906002)(38100700002)(1076003)(52116002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?jG3IFEMbikOydADuFxKSrCoBpZQt9bEDVhllKvYR5SVxV/jPoUTqBp/itwvJ?=
 =?us-ascii?Q?BloFdZ7zYUCbM4L7Rd/o3DTjJFRquWzH6bewG6NFtWjkTPG+NsrpX3LXI3dg?=
 =?us-ascii?Q?fgd/5osMy6kExBwiu/If6we6ASrTVyxHMAof/FGhlQhhqJvsc5aKvV7o2i1A?=
 =?us-ascii?Q?D6D6BQzkWMuUWnaPcplnQzUO47xA9awML0vjFjDcplFvlKaID1bvZ+2Jlqmx?=
 =?us-ascii?Q?bhNxkkiL29mdyox0PTwNLDQ6BJ4bPJNRePixkBrR3o4llYcSfbuBxE/AB3jj?=
 =?us-ascii?Q?/3RlKMiD9ehYmECuuZIo6c/axwdKFE4NL/lbQNw+S/bAelNOPY0fyRU8fIMt?=
 =?us-ascii?Q?exdJ/0NRXhAyPobaqOy28B62wjqziUlwJsc0/MKoxqpW9SDNMNLzTqWb2mdi?=
 =?us-ascii?Q?Ys+W/FEuJJspO4GmW/BYrQaN6LVz9m0UUNUhA3TC4I4tQFheBoV59RcwvW4p?=
 =?us-ascii?Q?P0+koCFonTUpD5Xf1gWWpWZOf6XShw9EwlGV54PVYezLK+pg524Eer4V7Xnk?=
 =?us-ascii?Q?n0HDPsZd3Hhvbg8Y7965vfumXA7swvMIJSip7janfktVVH3OVXmDtcU/boKe?=
 =?us-ascii?Q?leFWKBbfYGQKnerWa65BOwzGOk7QdDsgs082dqYWvG7EsVn049RUsFDNhhUU?=
 =?us-ascii?Q?JZ9BulBwCDlNdVL6Ag9JL9RoEjurnKVhEX/WCZmU40YiPx+ZLfi8b7FISbgL?=
 =?us-ascii?Q?zWFflQ7VVcc7SC3uWx204loqS6BYtSWHkg5CUHA/y+QybbClLOYC/gTnPCZI?=
 =?us-ascii?Q?INr/1p/dPdeImYIZOV53/LZxkw0Gm5gvAxOcOqGquKG8XFQUAcJET0BuhQI+?=
 =?us-ascii?Q?iHHxlbfRKcejO5rI8bnoaQhhBDnVq5hObCiLZAiTETipqsL2jCST0pXZ9f1g?=
 =?us-ascii?Q?7U1O4hv5zCBeRyGWPBrgShIfKxRBZqVJjEWA86kukjPLO7jv/OZC0YZG6i6m?=
 =?us-ascii?Q?/pCQOwZTYQlaECv3GtPS+KdfwqKlJ9DO8p7Cz8tAQqTPu/YK/IgfRu0e3Qxx?=
 =?us-ascii?Q?yOQqgDWm5+H9edYQViOsrN1nYtU+ApRHxxP7q3oKEzyr5t+W6BcZRyndlf3p?=
 =?us-ascii?Q?Li/GHrX4e8VURs4p0ORMEWBuci0lXT7CEj/Gqkz6vepIEKin3+jHpc6rfAPP?=
 =?us-ascii?Q?m8RpJFt8Sq2McXgOBL7Fz/cSil1FcHeFTH8g865ufJGZAkri2k+DllkbaHL0?=
 =?us-ascii?Q?spxnnHeoGLV0cHV4Z362J99TZtfJ5F+hmL6XciDn5wWxTr1BSX96f6u29Hli?=
 =?us-ascii?Q?sxtlpzREtfy7ab3B5T4xQjvqvQVvaKsylz+Kcm9nHriaGO5fxrg66Dfb/2g6?=
 =?us-ascii?Q?170/Rdtr4OobbwnXJygUL89/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0bd4e0-b5e5-4efe-cdd4-08d946feaef2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:32.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLgvzCOqrYVVBQ0OTizkTuuWv3cVbi/W4KSdByhneSOLnnQIpNQInGESJhnL3t4/6OOcnDaCYwjYRauXCi/M/vjsw69QQgS+C3rczVN0Jy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4368
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-GUID: Uc1CyPBQq8n_-8K54zU-beUugqfXnrk5
X-Proofpoint-ORIG-GUID: Uc1CyPBQq8n_-8K54zU-beUugqfXnrk5

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

