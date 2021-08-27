Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B613FCE
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:23 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWEfY013581;
	Fri, 27 Aug 2021 14:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=FmvbiBQe/MGVCFEPF/TYoEsiAbi2ZkHeMEfUAyib74g=;
 b=XHejN7e6jWAfukXW0b0eGvsvLknSJTT539FdpqVy8OkCeitTV9td1hCGWttg5vYORhj3
 aSi8D3zgpm9O+IFgQmlmIDLOGetMsSZamOWw89AoRwR9KKjpnMexOCEHOp9CmXjntNhM
 UWumo2jowWBvc+IOQG+s5R25jER66FUBgM6cFHTUD03lGd9/zXmsDZbIw/q+PRDCGJVq
 nyU0i+W6KKHh4g6R1EqYdU9/Vt7uwN6amGhYqNo3t13V/8DQPHcDKbG5xbc8loKJ21Mh
 y93dy0MkuZ6kQTahUMpbY+IxF4kXSuaD5mu0BoDUquO0LlUNQLHL8Kvbbbxq40Z7+bbw 9w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=FmvbiBQe/MGVCFEPF/TYoEsiAbi2ZkHeMEfUAyib74g=;
 b=ha7DC0RTHYrU13pJSbA+7vE7JBW+pwXqLd6wQFjrQGLFerCwYiVjvtYhiNz+uwCc4p7Y
 jkwPtMvRecDvYk/9PLbcoGnnlSkoSWhiAq9oKkVUlL5lhQiz48OBEBvPnMxmNrgVKnQd
 F35M+Y+N70/GPq+sgfRRZnwe82KmMFiQN3qTctaHPhOViqluak9oYxjv4dTR2LLYZF/p
 MC9eAAmOTqdJw0ti2Q1txiI9aETWybewyEFeRlQAHEgolKALLS44wR7WZVFxSR2ZXNvN
 42l/LbAekO8I44ez22ah8M9uluOXudwTZFHaQAIDXq7sC3Eizg+Ex+PWu7fm3eYaqzdN vQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap552bsta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpYnl152588;
	Fri, 27 Aug 2021 14:59:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by aserp3030.oracle.com with ESMTP id 3ajqhmq1nb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h50T0LGTYUO/96DQ71xiIS4QgX4Wbq2qo+7tokBfnkwION6MOHwpDdvsXAdn338S1Z/pVZpjqcNyKrKRZBfhIVsiSUx9oW9mE/lykOjSRO7J9+uDlcl0mG/GgSpsYdpDt1czjVEe1kVNmzc2koGdt0kayzCrnCdBPp+oRoC+TWrXZWBin2BJ3LkfGwPqVCjMX4U7XhZ3HCrECrPoYw61sjjCkE6mTihOKXpL/K+XxtV4Fb755ckcOAfpBBNXkjT4aq+wDjPotk6q9mRQe9LDk2xNPLF03hJuHdx+ThLB/dth9HxDZCD1RO7IB4IiKbLPynhfhDyjA1EfH+axQ56oZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmvbiBQe/MGVCFEPF/TYoEsiAbi2ZkHeMEfUAyib74g=;
 b=nBFMGoKQ+s/MyWnUb87oP0PFdI1NJzWdPfGB7rPTcMaxIm7cenIXrtxlOLQK4S3p1NaIT9CETEGGGufb0U0FNKKTgSgIEH8o7OS7OFhRT9SjZXz892cw62vC73ri92TiNsHPuZcVhIld2csvrzarJ0khkrUlfylMj5usZML7mPEQ8ZooVYbpyEDj1cgSgrkSrY0gKvDSjEHP6px1gv/4YDViyGmt9c/3k1c6oisxbDJe0GZlUZ4XnxI85sk/yxEzpgzvUG8wQaSC3/eV8lx5VD7cs8yd9vLiYm5VF1tP47whftbrQdRm/U1guhUoKXY6lHZ2Jz3uJfY8x5WQ6H+HNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmvbiBQe/MGVCFEPF/TYoEsiAbi2ZkHeMEfUAyib74g=;
 b=KHgJ4wz62mLtMB3gOXx1MhaFoWcXAZlHH5F/hb0Dot9bEklbEmORo3h878FVJoN5RczkeNpt18wOuonjTLvxDmL9ZuwP5lHaSCVJ6ttV5BezxFS8yNtL3eEoC8hmRYpfUlGDXOzP+4GpHp6zWSV3I4D/jm+qX5K0PGDJOnaa8Qc=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 14:59:06 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:06 +0000
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
Subject: [PATCH v4 08/14] mm/gup: grab head page refcount once for group of subpages
Date: Fri, 27 Aug 2021 15:58:13 +0100
Message-Id: <20210827145819.16471-9-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:59:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b2384b0-5692-4966-c863-08d9696b3747
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4881A736F5E561C6087AD26BBBC89@BLAPR10MB4881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GQNxzSKZVdWFOIUbfKt3nYBxtXT5kHgVCqn4n81A5dLRmdXyclokPRYxbabGO4dYQI9GXQzG5ibdMrNvPkA0jLldtuuYRamGe2DgRDGR56rHUw1CQXI7yJla/5mCQhrEsVGYILDNenaqVM3tckV+vK8yF39ydXT2Hph8BzVQbphKj+aXjC4cZ/wI49KPySuEpCMcxS4Hzi9gqDVWxi9qTcgm+D14H9dxJvmrKjH2iPHXn+z/oHzxeHVQuKPMQWdX4JiDcixYd7jLSWSxn39U+tuuy/kCi7Q/RnP29oD8Ak+rREo4oH9Pmxvlukn5V2mniMFMaMzJHU5TkWI+FaHrmJkeOpBXUBYC8JYlgs8d+QPTx7zUiJWNPtHqErOLZFhHgtH49QGcV+mSvm6anoLg8KDqm3e49qJg2FSPN/q/s0t5TBbY60upONymBkr/q1BKz64qFZinjWyOyItrJfYOIRQqYkX19N07kKuZHT5PdobUD1UQ+C0youXkZjBTzC7dZtU4ehVEssIvcAYhO2Zt8RiJMgCOq0qu8IQIPyutFawjaFBiVXkBpvhkX0P7/HYHl9Nro/K+p5sKlDLA7Gz+Ui/ZJVRGVo/H8AIuV/nfk5ZtIVVjhDa2CvA1zlyQIuzZjRJ2IvhUSvqFOOntOcif7R1qJkwQBuD1OfQLhKz5pRkGBIhz5ZAPBAkuNBByGrJ5HlRmjobKr6ZnNCUYNhD2fg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(7696005)(2906002)(83380400001)(38350700002)(38100700002)(52116002)(6666004)(66946007)(8936002)(478600001)(7416002)(107886003)(86362001)(36756003)(6486002)(316002)(1076003)(8676002)(103116003)(26005)(54906003)(956004)(4326008)(2616005)(5660300002)(66476007)(66556008)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?IRWUI3uqT81WINLx81LzxRnAZYnhJKuGfmzU2qQA5ScTBCXKG5TIKmfz7RWi?=
 =?us-ascii?Q?MLsMI4nqnkt5PThTcGUTl1dpNggkiDn9vv6CjIwfrkratW8VUN630wxuDPC1?=
 =?us-ascii?Q?CDjMIGXRX1jdU/q9rYcT2NoeuffPkCUXuLbJri8mm7W9b71QhI6fpz1OO0db?=
 =?us-ascii?Q?DnVaeug7FBaB4pKFuaS+mtTHJhziTV5KquvWPkuLhZ7Ust0YTMFdRX0Yt9Z8?=
 =?us-ascii?Q?twrRyrsbb8ZVAW4Q/gXwJFhpzQ18bOSZydFqjlWYUF/R7C2Mr79+wldHEUcw?=
 =?us-ascii?Q?TtZAIdsKXA0prta0pC1evjHY7z63lbtntEe1weJ+Ulh0v3SbZSsnkTxQWToC?=
 =?us-ascii?Q?tlBfnR0WxcXJsvN3uwL9FAKAoUxSvnzGeYU8zIKsYLvWktWJQdrW4cZW0zqo?=
 =?us-ascii?Q?QPVVV/s2hBzbSqS28+h4zRiWNU+1l0PRPLKHQfHfy1zukxvdcB1uCvP5HLN4?=
 =?us-ascii?Q?IfH10NDk+nYyZtt1e/Ta328k6r2nFFNBiq6X2+7twIKBDoV52Q0V3ghvST/Q?=
 =?us-ascii?Q?gSH0tEGYjF2rbpBMIdOdq1Fj2dozBF2K9S8O0LD7z3FYZvutiEvHK8DrQM3v?=
 =?us-ascii?Q?rp0PrcMv/lPKgFsMYTs/s3NJPir5rLYWmG8cwKJhpC3uqGTHGfkSy3sXwu6o?=
 =?us-ascii?Q?CC9QWKJBXBJhhmHkmU7lFoM26OAeMkwxhGAJmEfabO+hQH8xDHGDVW8GPDsT?=
 =?us-ascii?Q?vGSUiKfnw6S8LZyppCQu9gatxfcQtA/azzTK5IylpvHAK/0OtK4C3G7zdcfp?=
 =?us-ascii?Q?fTuhpgNoUck/k9JiNdTABcGb9vra0t7v+kcAu62CLdvKObxVDMvUKzlPycJH?=
 =?us-ascii?Q?Dr0T0lUzt6e/8uEDiNyS2w92GaXjrsEOlm8NWZVUUz23RPLLRxGZRbR7sCjc?=
 =?us-ascii?Q?g5A48+ehb3tXMdmV5wpz391zg+sujHLwZapQq07EhwV52uCZlJbLCFff7QFv?=
 =?us-ascii?Q?yqZqN3mOld6ighMc2QcgaRROfzti0yYpAUMnl9y+sEqIwHVD/ss9vKHZdbBa?=
 =?us-ascii?Q?Q7tJ/ENdcz+yQKQvwbErdpboWFdH7pTxcHiG5oC43ohK0bfMXAAjxs6D1tVT?=
 =?us-ascii?Q?wmYDx9rG5JszQU+FO8ngiTgdp2eHcTvwr53hNb/C+aV4Ih1vDlBmNjJtTNVi?=
 =?us-ascii?Q?cze/UFrxCNaDZ/SX5ntborauidvQOvtdg104hGJYy4QOshHZ50itQe5BMQLN?=
 =?us-ascii?Q?lQbHFQ9DTiClf5ooIclV2++EwD+rsi+GQEBpE0iOFE9w+cKLj3WA0LFXYsrU?=
 =?us-ascii?Q?X9hEZrN7XPXtpMvjbYO5y8oS8hHxNeKQSwykMy7O7LP2O3fU5iG0GHu61Rb7?=
 =?us-ascii?Q?4Jy+GWL/kh3E/PywRCjwGKZc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2384b0-5692-4966-c863-08d9696b3747
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:06.1794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHaLM/zdCkbPOnD7fX8uxlAIvvw3M6FGyh7VjUwmeXdlmv+VtqNXIYP9pc8/7dOvFQizI31TYasY57DHZaGgfRb8BlBbGGHPbL0a0BCWJ/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-GUID: 2GCEytDOWoXQKD-djmLOGrlIJMkQQyH8
X-Proofpoint-ORIG-GUID: 2GCEytDOWoXQKD-djmLOGrlIJMkQQyH8

Use try_grab_compound_head() for device-dax GUP when configured with a
compound devmap.

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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/gup.c | 51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7a406d79bd2e..0741d2c0ba5e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2234,17 +2234,30 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
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
 	int ret = 1;
 
 	do {
-		struct page *page = pfn_to_page(pfn);
+		struct page *head, *page = pfn_to_page(pfn);
+		unsigned long next = addr + PAGE_SIZE;
 
 		pgmap = get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
@@ -2252,16 +2265,25 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 			ret = 0;
 			break;
 		}
-		SetPageReferenced(page);
-		pages[*nr] = page;
-		if (unlikely(!try_grab_page(page, flags))) {
-			undo_dev_pagemap(nr, nr_start, flags, pages);
+
+		head = compound_head(page);
+		/* @end is assumed to be limited at most one compound page */
+		if (PageHead(head))
+			next = end;
+		refs = record_subpages(page, addr, next, pages + *nr);
+
+		SetPageReferenced(head);
+		if (unlikely(!try_grab_compound_head(head, refs, flags))) {
+			if (PageHead(head))
+				ClearPageReferenced(head);
+			else
+				undo_dev_pagemap(nr, nr_start, flags, pages);
 			ret = 0;
 			break;
 		}
-		(*nr)++;
-		pfn++;
-	} while (addr += PAGE_SIZE, addr != end);
+		*nr += refs;
+		pfn += refs;
+	} while (addr += (refs << PAGE_SHIFT), addr != end);
 
 	put_dev_pagemap(pgmap);
 	return ret;
@@ -2320,17 +2342,6 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
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

