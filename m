Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF872C80
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:06 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KOC2d006870;
	Thu, 2 Dec 2021 20:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=saJv+cmeXAb0i0lWCjomZjHXAEdm0lsOILVEOBAAS0Y=;
 b=Dw1Irwkk46kBFhS7ye2lz2I7HaMMdak1ze/r9GM0TpNu1/vIpU89WadaB5kIXuB+jsuT
 JFRp9mcs8Ssvn3XIVyyFSASQLqF0eEEN2ykommCDGU/9EHZyTRpoh+usjnOrp8+x4yYB
 bHQlSETAuy1q7iYQRbynZiYMD7o/hLZiPYmzAiQR2Jf1AREZ2O23gG3MJGIzy2aCK/dq
 6cGivWdiFY0iWgUS0TqCQYZAaHPRf+XbhqW9DhEyDa43Jqys1dXwQY68Vle7NjPnpA0U
 2X9VKjoUR7YJeLHdebMQbHA65eysVHpnrq855zdtHzFpRiD5jDkOtDXdH54AXMWASQFP 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp9gku3tj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2Ket7D121391;
	Thu, 2 Dec 2021 20:44:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by userp3030.oracle.com with ESMTP id 3ck9t4v49j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfMOk4VnQ+2rObphfSMD9wR/DosXA+cA34GVwfUnnMS9zhodzXly6hcfRPvd0/jgBFd3RO+WzkCUhfYpv4t1JX4IIhChA1iWp+HYWE5ZScndtZjAs52uMt4/KZq8+6A4uke17Nak1tmc7eS/xrBh3t2taksSyY0GLXyH9ocDLyrzeVlvhoN/K88yb5w36odK7NmEHC0m4uMVo1Jo1UxybI4S0U7HlkY5wmzRvj71v4dn3WAJuuNVcSImihc/Mxiw79rrVex+2y4xYyMaBZh86ati2xUFRNZBNPqFnif5seKX1BlMJIw5ex/CKeHbK41EiYJOk5GLXcN+y2NGqn7kCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saJv+cmeXAb0i0lWCjomZjHXAEdm0lsOILVEOBAAS0Y=;
 b=YGPN9W9+kcPLVGMHagF/jD5+Co9pMoiCHkAeKnnOXtVKR7CvFENBiCcpo4Ne63jf0XlPQ/u46eide9X3sKGa+YmdrjbCQcnqOyellLkG8bRlP0ikFkLnavFcKEfRUqJw1uUNs9rtZlXSJeyyzvFjuaBx1R90iftdWr+kefNhisFiIRrDZQ6blRjN1ONeRKybmmghw2ae1jhHjwiT4VxFE/lz9hpBt7UBduAJDamcztSxHZUPQVc12ewweJLw4oA6QKacB7mLX/DIRrJbIt0ubMRe/cRg1z289W+W9Y7nz3Qr2g//zcSgQxe8PRuXWXsEnhvvwsQArlVdjwxT0rPNDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saJv+cmeXAb0i0lWCjomZjHXAEdm0lsOILVEOBAAS0Y=;
 b=pTJIDu1KPnawuoWteDVztDhr5euQhROB1bXwu9CLBrugfpfn4QkgIyU7nl+kz3u/0/3SWeS99YJ1EhrH+hSCV/U3JRpRLPPpAqK2sOw+QucsyF2zm88BP3wFrtiSQzPzSHtgLkL43N5Gar2Bqv8Mf+VQGwWAvQxWc/qeTcLaOFA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Thu, 2 Dec
 2021 20:44:45 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:44:45 +0000
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
Subject: [PATCH v7 02/11] mm/page_alloc: split prep_compound_page into head and tail subparts
Date: Thu,  2 Dec 2021 20:44:13 +0000
Message-Id: <20211202204422.26777-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211202204422.26777-1-joao.m.martins@oracle.com>
References: <20211202204422.26777-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:44:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 053f0a48-6124-4560-2a06-08d9b5d492d9
X-MS-TrafficTypeDiagnostic: MN2PR10MB4303:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4303EE2391844D9D6623701FBB699@MN2PR10MB4303.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pKK47wyM8RU9ulWXVviQdiGaKP4Llb/kGcbHNdjHDIFXEUWOLm9W7gVobrIhtpuHE0E3X4w7bYjwMKvEa7CTIiOYQYjalQ9ZmbEuooLmPWtxuYCFchjpP0VrAjw8kVpGn0sh9GvqVX1dJupJF4eGSX6a62mGXZ5hg1aME/c3n6pfnxQo8tleVrC7HG1RFv94j7PeOqVhzj0RGo0ec3NtRGE6mFfOykudlAVEz0BJsOZX2jfVP667MtxyWt8jhHVbi1YM45xzpmfMozOmVAqt3c0PrgnYmF/U8kX7k90p0y18MW1mMk/VRFiI/dR9ARf++pULO1vbbAZjbrYMFPItK8oFaXLqTkBXThCNN/Yvug8OToJr9NsWOxUZ0WHSL9XRDjsY9RvQ6cOVsBrEhc93eOQwkIy6j8ze6myJLnChPubGsvCk4Oro3FgmQTQK1gcYv5j31R8ofalGkXU4z/jiq1G2VSDrQaOtzKaaHW3hZzKs8mzCraoZrDfAWPzdgOOkFIghIiRXjWcuU6qlq8LxU9gUBjid6QdG8+6B+4QExdKylOO0wBIfxAIiLS2nFLpTa0QD4W/iWLCJfFPOYGfbzf3ZStqvaGinIuHVtrAaBVU6fIdPKrbxT8T577I3dmo1Gtukmol8EEUaoWSDFKtvmA+TBqLRHZ1dmFiw+Ft3/Xt4KVV6y93T6QhNw4l76gjoE5RlXJm3R3+lvfBL2Pg0Fw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(6666004)(316002)(1076003)(8676002)(103116003)(66946007)(66476007)(83380400001)(66556008)(26005)(8936002)(54906003)(956004)(4326008)(186003)(107886003)(2616005)(508600001)(7696005)(5660300002)(52116002)(6486002)(86362001)(38350700002)(38100700002)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tEuXO6l/gMKg4hprpknWrbWFq+q/1Aj+QSfNW7MsxL1M6vWFW5af9iB0++gM?=
 =?us-ascii?Q?/5r4zcz5jE2egJE3Okz3QAVmtkXkmavIuRY8g6rwAaw7NClflFVcRu9tDvJh?=
 =?us-ascii?Q?foO5F7Iqifo9De1FwxQtsHxnURoof3omUycyLbGJiCrqbbaDFNOgWns1bD5Q?=
 =?us-ascii?Q?IcAx9V1TgRvGhq+sakpTmw7TkiOYcXtuLJp0tFA7REDXH37BKSq49TVDjcDG?=
 =?us-ascii?Q?G+WyAHYBAvYktMgSBlplHomHrJv0Jc/TdgcIBxwy/DSLBk8fLCHgKRFE2r5L?=
 =?us-ascii?Q?nfGCzT5ehwqVddPUMqsuVBGz+Po1Ehf+E3OPZyQLEj6cz9yeG6VogyTpJ2RV?=
 =?us-ascii?Q?RJ75r33CQpFhns8Kq/nWOTzq2NBSkUtPErLo5NKT9lkYHHkc8BNHxP5I8icJ?=
 =?us-ascii?Q?5060ersFklgjLv/EkkAyWNJSckUHBRHlTmmAyYHjeO5V7Gr8sjje1jsiPWIY?=
 =?us-ascii?Q?ceCdHz2xKNzLlL8vMgCRpbvLxjmj6ie/j0m1H/qDY/Wh7FoJmIw8dD8v2af8?=
 =?us-ascii?Q?FOOpEMk0ITaObqWqG2SQW3SPVqlFVQnTYevBe2eHIfcLjRXSwwNoHHVIPzA1?=
 =?us-ascii?Q?eT9m97c9fkyP8t48oUzdVX5izqUPHkI8xIsnmBvPS5mDZC3FI0332h6kURg0?=
 =?us-ascii?Q?C17N16KTgUoD3LN79nUeVkbRwFCspVSJqdNwnXlKid87ybCK35OJ/ImkDzFP?=
 =?us-ascii?Q?/pcAEEvYDhU8ipd0nmto7XazqN4P0QVqftktAHt6YIuInjBvEHa6QFbltw39?=
 =?us-ascii?Q?l4x1RlS/lvskVbKo1nyeLTeXhX3fKgrzBDqWTZHNZ8CDOSFYC3e7pq0ealml?=
 =?us-ascii?Q?Q77fjSi4fqXIJHTZLV6nIeib4hG/jwLMZxIVgs4BCVhY8dVGsAyQUSREN2s/?=
 =?us-ascii?Q?sg5kQuY1uIC+uhfD68ai4+h9uf+Yq/yKwknKOzbUEHrETnPK0Kg4ofrFUS0p?=
 =?us-ascii?Q?+4ctQ/hxV9unA4YTJoJIH8SrK382bKYWGMBOIMHODf6AmCSmpIt5bsKajbLP?=
 =?us-ascii?Q?xQtqyboblTjQG7aUn1AKRIkJduNDw5xf/2QJ2PGm5iWH9xhzbLE8M04yWJB7?=
 =?us-ascii?Q?ehch8zQN0I9YCjqsa1UUdvf/W9rx4ONei993gDnmmxbBm+40B0wBzSKrMBu0?=
 =?us-ascii?Q?HSATaro6ZOkZ+uKjrBki12TiXjQ8SRJg6f3MpHJA4+ggLp9W5/H/6QE0UPlZ?=
 =?us-ascii?Q?bQohRkN+FFid0/yHmRwMNDrAd1Iy/Ch6qNFWYFmB3wwdO+yE0fMzp2t6s9hl?=
 =?us-ascii?Q?vyOfcJfFCQY2dyjFJN3w4g7ZYl85HPgR3Eo3uNgnlUMVWPRZM8P4VkjlIcBi?=
 =?us-ascii?Q?xhDJ6cQB+80CC9GOUc7FHK6mFVL26t19KabZ/nSjgVucAkCF7F6uLpqAXFdH?=
 =?us-ascii?Q?43x1Jm0uzZKI5HyHxp6xM+snFshSBrdH/myd2urcalCXJ1SUBDqJ8pl/hGNR?=
 =?us-ascii?Q?9jNhgi2OGysS2KhXqyLBCinPNk854NDOFDN738sj6EeF7JOgD/EPU2BqkUDG?=
 =?us-ascii?Q?hOSj13I8yPztYIn5cFD8gOeX58qod7KWOHQJa4jChxB7KjSELuwXasXkXf6/?=
 =?us-ascii?Q?kQlKDL6uF96WQG3Z2DichUvpaESVkclcvY0bSV1CU7la/Ec1LpbM5KbAcb1u?=
 =?us-ascii?Q?50J0jzjKIMYz9ep+7gVZsc2WSL9IVi1KCnlkXchqHQ+rgT31yu9b5uqUKt5x?=
 =?us-ascii?Q?Jsg7xQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 053f0a48-6124-4560-2a06-08d9b5d492d9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:44:45.4617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQGjEXHf8r49q6nMiygmEFuJWVWSxUbqSnCdqyleLo2Z7VQDcNsKNBC8/wLkhXFi2nxYIxGXHvO0sJovrn8PF0GBj2OAfuM+8UAVrk9tGbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020130
X-Proofpoint-ORIG-GUID: O3V6_PynJqqo_jE3vLFVa5UWT31BJ4b4
X-Proofpoint-GUID: O3V6_PynJqqo_jE3vLFVa5UWT31BJ4b4

Split the utility function prep_compound_page() into head and tail
counterparts, and use them accordingly.

This is in preparation for sharing the storage for compound page
metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_alloc.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 58490fa8948d..ba096f731e36 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -727,23 +727,33 @@ void free_compound_page(struct page *page)
 	free_the_page(page, compound_order(page));
 }
 
+static void prep_compound_head(struct page *page, unsigned int order)
+{
+	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
+	set_compound_order(page, order);
+	atomic_set(compound_mapcount_ptr(page), -1);
+	if (hpage_pincount_available(page))
+		atomic_set(compound_pincount_ptr(page), 0);
+}
+
+static void prep_compound_tail(struct page *head, int tail_idx)
+{
+	struct page *p = head + tail_idx;
+
+	p->mapping = TAIL_MAPPING;
+	set_compound_head(p, head);
+}
+
 void prep_compound_page(struct page *page, unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
 
 	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
-		p->mapping = TAIL_MAPPING;
-		set_compound_head(p, page);
-	}
+	for (i = 1; i < nr_pages; i++)
+		prep_compound_tail(page, i);
 
-	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
-	set_compound_order(page, order);
-	atomic_set(compound_mapcount_ptr(page), -1);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	prep_compound_head(page, order);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
2.17.2

