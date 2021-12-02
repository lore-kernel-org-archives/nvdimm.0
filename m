Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362BE2C80
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:04 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KOU94009638;
	Thu, 2 Dec 2021 20:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=m/+GhgCsvmfJQIBVoJtFTMnj/Z2zM3WqTUsIWMxECS4=;
 b=RCkeFpTLGYkssjagZWidWmpc04zfOSdqoo9O3rd9GHkU41tAajFrQd8B1z0wwiTkR4KV
 3y/VssS+NvmUYvYHqAXd6D/gKpUt/QKEKMBFmuCWn3pQnyjFGl4LyBjWpKtPfTN36ENe
 80oLv4H3SWzQ8QcO+8iv99KDffuJRAU6LOHA9O0SBuOpj7vpnRqXqkRy5FnmHD3LAOKB
 fVvjeBIeXEsHfCJiSGVmfWngTabbQiIPPm9d0CAJ4zUqsEmgLM6p4IQX/3zFZ90H3rcn
 U4XUaFkP1E/KjYGHXUfEz2qUKL2ROhNhLTiuHvPoyCt23cwQlQO3itQQQ6hkS8/VEJDe 4Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cpasysshj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KeukF121594;
	Thu, 2 Dec 2021 20:44:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by userp3030.oracle.com with ESMTP id 3ck9t4v4j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iY1AQnt93LGXwEtB6RW6Or30RP3zqRsAmBJ8y/hLYtoSVckvWmpGJ5nm5TfLi5urn2n2RA9d0R+6qdkPzgZTwPeGaYqDyjjX2gzqAq0+PhdQ2y8GfpRs2/xkvWe1sLYS4viEONPhSjqMzCkPl3fOYvHlhKsfzHqO9G2OA4bzNGv4z6lJwNenG+I9TAW8Jnj8Z6dVL3M2JipJ6Joj8kV7YKkzyTCbdLaKoKIbBoDHgWoWPtTagN8VKOHdg2IEGjYUPXH5k7YR6E9vJ2nab2kQ/xXEmXeYxA01IEaIW6oVCJKCjt3sPFip2P1SaQel3WUPfssiJ1oZxloYUhyK7Z3lkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/+GhgCsvmfJQIBVoJtFTMnj/Z2zM3WqTUsIWMxECS4=;
 b=DKRbS3Gj3MFx9aRINgtlL9WDZJeyHVuNE3fRhVBKevRa6CIVnkX2/fzxy/FoYLZqm+rA9CvjzYCChqwsoM1ErxGQLFOwIKKUdungi7zzIZMaAFnnkpGPZg69BE+ipNhjsnDA80qw6UgLPEnYwp1w2R3/+giYXzsTn6KHvC1z80jzyvg1LI8FaIuiziso+/xuHvzs1XR+zGsWATSNpuPqJOnktbBrORbuk4L3YY2vD15pHhbihXi3bgprEXnUiHiCa8NDZ1MttHCihCZYMLMVTS3lCSDeczXsANmarMQLyCYLCFeRiUjZGFuc4Kj8BIhsKofHviMhBJaMzaflZcWBUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/+GhgCsvmfJQIBVoJtFTMnj/Z2zM3WqTUsIWMxECS4=;
 b=PisvDXdrWH7OYNL1tlSQnCivPoSpaQOQ6Qk0gNkvn0oaEnrQzT46YrmFN9WP/J1eK3jg2AhtSzCqebAiYugyVlzvglHpl5Kvi7KrpQXEnKNPFAfCGefiUCdv8Jnl49NyxOhUDORyKY6nzh50Z4hvf/0o9RY/473o0BNZViGtffE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Thu, 2 Dec
 2021 20:44:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:44:52 +0000
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
Subject: [PATCH v7 04/11] mm/memremap: add ZONE_DEVICE support for compound pages
Date: Thu,  2 Dec 2021 20:44:15 +0000
Message-Id: <20211202204422.26777-5-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:44:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81b8e165-84b5-4c11-8a19-08d9b5d4973c
X-MS-TrafficTypeDiagnostic: MN2PR10MB4303:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB430308CBD381F7D7F4A58C44BB699@MN2PR10MB4303.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nmtjDC/FOm0Cao9klSX+LjAzSNgtgVU1uVKdHPD8QR7MUDgGOw8DGKoYf5UCEg8aOyKugne/fS2mQJ9FqfS3Dtm0nP6GFSm9c8KWy4VnSVZxaugnWt8LcbdXbcCYkPow4fyDKcKVPnvEa4nM2yIslkXnwLgiOEATM47joFsAjG2O0ZKEnxrKP7One+PwkS8aVRVL/9AEHuwE/g+/aubD+9ft3dpwzjndC11WVu7KBo2e2MylougukQhOxyCC8XniyJfLB6T5zA4H7Rv2Hlo+CDcNGE8wHizr2r7Wa+rAWSxfz2vzbXMWYlg551ntsyq00ig+W73M0Y/k6GevV8Dpfh9ROoN6H5ZBnfQr/ohIS8BBYHZacT2d0WaWeAVouAUk9ZRca1h59J0NusLNsxMivIPj2v84ibOTgPQcykg6DRlFrG5txLnD7BfVFgmouqxbp+tXvDjgGuEN6JAcE+kOU0aCBbUA+GkIH0Q4iZaVhxw5CXKJOYBJb4UdWuZkzgM+syz0Kw1fSTjVrPa3PgCY4on1MoswUp+Nzzwta/GW3mLtn0hrnHblrm4pN1znWj3tDetRph2a0ASHfykmF/xN/wgdw2Ncx0IxQHgbvB++TKztvdgIDArVbTwf9KDR/oMV1v68pKQaA3xytF5WqiCkzq8SQbhWlfuBJtPuNUX3V/UiHZBYQ447W+V6c5u1VF1bHDslnp7U1P/xJ+4XN+1fdQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(6666004)(316002)(1076003)(8676002)(103116003)(66946007)(66476007)(83380400001)(66556008)(26005)(8936002)(54906003)(956004)(4326008)(186003)(107886003)(2616005)(508600001)(7696005)(5660300002)(52116002)(6486002)(86362001)(38350700002)(38100700002)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?w9CVjYsk9F75siLQ0UxtRqrm3LLsndvMq2HeFu33c2GnpwU0qh3LGNH1ZFiX?=
 =?us-ascii?Q?dKUBpMSmm40xm/RLXB4l2jgrt9qFV8deQ3I6Z5ZpHWoYu9MxBEfypg/S+6zw?=
 =?us-ascii?Q?0vXGPxSIPjZxvDIQ47qpl87+KbGklrGpA4ogFlQlPloU7Pwvb7vERyFSelMB?=
 =?us-ascii?Q?5d/ayl5KQWcUJyuqQtjNVC5jtxZGurECtbFByRAm0pVolulg9/DZEgNezJbV?=
 =?us-ascii?Q?nlMHQbN0Hlz34kPh8gMMwSH451SO9tLZJs2rLMA4MhrXzOvqchN8zfxGY/ZC?=
 =?us-ascii?Q?K2LCWZ2wnC3trXqVKiIE2b/q9yEp9tA/pR6ysxjHxgfjHrPL7eXh8o2lQCcG?=
 =?us-ascii?Q?wrjio9o3IARQpajRZ396407Ud536ybZGj2CVvKzXjllLhiD3OrsoIOgukSPn?=
 =?us-ascii?Q?asG09erFxTE0oN5tg6mInWLtz1feJEp50vRGmU1KemtlclL8mKRZuBeyOhZI?=
 =?us-ascii?Q?10BVF3pP0eTmB1wTR655pgwMQ1+Yo7K8HOrt7mQnzMgILIxFTmb8u3nXorig?=
 =?us-ascii?Q?ieSdkpldZPH7S8eVozQbgeG5nSUayo84PDTi+yi3WsPzyoNvATkR4OXvLs0Y?=
 =?us-ascii?Q?E63V+bkqjf+Oi1v79a+D2CNv3Q/iAl+f8xSKBIUYfQSOM2ZBXpwe4CqwdqGI?=
 =?us-ascii?Q?zPXmy+rzVF1wWvQE8kPIW+DNL6fyAMy8kQYCQLtKhaEvkwNJQBYEIVsUZzOz?=
 =?us-ascii?Q?AGEnOOODr1nz01P0yhKJE5FF0oqVlf5qgownJCgq1PUj3A8i3n6boVIse6p8?=
 =?us-ascii?Q?kh9otErWilS7VsRkyhAoOOihpO/Wm7CaIBnxMD5TcTCQ2m+dGfUSOPQ+kC39?=
 =?us-ascii?Q?IeuG06LdxvljypOIKQaF2G2XZ6E3xx2khAOa90qjC0oW+dbQ1Heg1UvcQNIR?=
 =?us-ascii?Q?kDyHXX3dCC827KoIRNCDNDaUaaY/zvM81CIbBUlR3TSuxX1svPlyPo7rjqU5?=
 =?us-ascii?Q?sbFNrXd29owScpGjOqHPyGvpCgfwF+n3JjsoOfa2U4tbq5BhdPVh9t2vcMvj?=
 =?us-ascii?Q?VqsHG7d2fxVc5bOFYn5JIPRsyrNLyz3OPA/EihRX4z5ySIag7/A1SOD8NsOO?=
 =?us-ascii?Q?8tCSvvaLV9bd8NYu2bFfmUft9BICeON+csHB8654dgGDbM4xx+7TE7twJcvo?=
 =?us-ascii?Q?UqQ3sCBux0g7OQLJ22iMoekTPdKuhwtJMPzPYfe30d2HkGz4TkpkAPFBe1u/?=
 =?us-ascii?Q?n5iWdEAXH57CdBIDrVCsoERoaZW5e2gn3y/JV0FS7sMqX9vTQENT4BEISU5q?=
 =?us-ascii?Q?RUpSTHG1xqXRe4vzYKn4+rTSxzGa3KkfQGoSdwQXAVqvpDmdodTmRj+WcTNg?=
 =?us-ascii?Q?rs3hFobZiCTvA6fMDN6i+Zode4H4RixOWSq757sKPta4+y500leh+XK6e2Hn?=
 =?us-ascii?Q?cpmSExCsa42dkQS6e008EZPETd8fhhBpURsXDdXhSNpJpVIlQ91d96BULcy1?=
 =?us-ascii?Q?n4MYrwfodcFMXDJb/JpAalgAzYntc9yyDWwM6zvUguW0bvfDB0Q4AVp923R9?=
 =?us-ascii?Q?Fa/bri7TzGARiRN3UM2jI+ohc02ynsNwrSpHKASRVTtRU7yls1GAJH1FWooy?=
 =?us-ascii?Q?FCX9ztYGv2fbwfBZc5qjWpSXutVOocDQjea0Q5xezg+HhF3zWudz9lWekGFV?=
 =?us-ascii?Q?s2qhsKOngOxfiuRTmx8iyamQbVq3SlcFYNK2w3YVtj7coRJ5sByJU6Ol8J6C?=
 =?us-ascii?Q?D63ODA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b8e165-84b5-4c11-8a19-08d9b5d4973c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:44:52.8094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/XzsVbGkyCGwgYuiLndbNf/baRAoN2yeqjniD2u/q8uZXeESXjnjmwUCcsuRQzHOuZPgZac0euGJEzp5s/hvQSV9vU9TafgWUzonpfYWz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020130
X-Proofpoint-GUID: nWfFup-wvAAQkyEe1aBMChNik_nLt2lZ
X-Proofpoint-ORIG-GUID: nWfFup-wvAAQkyEe1aBMChNik_nLt2lZ

Add a new @vmemmap_shift property for struct dev_pagemap which specifies
that a devmap is composed of a set of compound pages of order
@vmemmap_shift, instead of base pages. When a compound page devmap is
requested, all but the first page are initialised as tail pages instead
of order-0 pages.

For certain ZONE_DEVICE users like device-dax which have a fixed page
size, this creates an opportunity to optimize GUP and GUP-fast walkers,
treating it the same way as THP or hugetlb pages.

Additionally, commit 7118fc2906e2 ("hugetlb: address ref count racing in
prep_compound_gigantic_page") removed set_page_count() because the
setting of page ref count to zero was redundant. devmap pages don't come
from page allocator though and only head page refcount is used for
compound pages, hence initialize tail page count to zero.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memremap.h | 11 +++++++++++
 mm/memremap.c            | 18 ++++++++++++------
 mm/page_alloc.c          | 38 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 119f130ef8f1..aaf85bda093b 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -99,6 +99,11 @@ struct dev_pagemap_ops {
  * @done: completion for @internal_ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
+ * @vmemmap_shift: structural definition of how the vmemmap page metadata
+ *      is populated, specifically the metadata page order.
+ *	A zero value (default) uses base pages as the vmemmap metadata
+ *	representation. A bigger value will set up compound struct pages
+ *	of the requested order value.
  * @ops: method table
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
@@ -114,6 +119,7 @@ struct dev_pagemap {
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
+	unsigned long vmemmap_shift;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
 	int nr_range;
@@ -130,6 +136,11 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 	return NULL;
 }
 
+static inline unsigned long pgmap_vmemmap_nr(struct dev_pagemap *pgmap)
+{
+	return 1 << pgmap->vmemmap_shift;
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 bool pfn_zone_device_reserved(unsigned long pfn);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
diff --git a/mm/memremap.c b/mm/memremap.c
index 84de22c14567..d591f3aa8884 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -102,11 +102,17 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
 	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
 
-static unsigned long pfn_next(unsigned long pfn)
+static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
 {
-	if (pfn % 1024 == 0)
+	if (pfn % (1024 << pgmap->vmemmap_shift))
 		cond_resched();
-	return pfn + 1;
+	return pfn + pgmap_vmemmap_nr(pgmap);
+}
+
+static unsigned long pfn_len(struct dev_pagemap *pgmap, unsigned long range_id)
+{
+	return (pfn_end(pgmap, range_id) -
+		pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift;
 }
 
 /*
@@ -130,7 +136,8 @@ bool pfn_zone_device_reserved(unsigned long pfn)
 }
 
 #define for_each_device_pfn(pfn, map, i) \
-	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
+	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); \
+	     pfn = pfn_next(map, pfn))
 
 static void dev_pagemap_kill(struct dev_pagemap *pgmap)
 {
@@ -315,8 +322,7 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
-			- pfn_first(pgmap, range_id));
+	percpu_ref_get_many(pgmap->ref, pfn_len(pgmap, range_id));
 	return 0;
 
 err_add_memory:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7f33c83222f..ea537839816e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6605,6 +6605,35 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+static void __ref memmap_init_compound(struct page *head,
+				       unsigned long head_pfn,
+				       unsigned long zone_idx, int nid,
+				       struct dev_pagemap *pgmap,
+				       unsigned long nr_pages)
+{
+	unsigned long pfn, end_pfn = head_pfn + nr_pages;
+	unsigned int order = pgmap->vmemmap_shift;
+
+	__SetPageHead(head);
+	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		prep_compound_tail(head, pfn - head_pfn);
+		set_page_count(page, 0);
+
+		/*
+		 * The first tail page stores compound_mapcount_ptr() and
+		 * compound_order() and the second tail page stores
+		 * compound_pincount_ptr(). Call prep_compound_head() after
+		 * the first and second tail pages have been initialized to
+		 * not have the data overwritten.
+		 */
+		if (pfn == head_pfn + 2)
+			prep_compound_head(head, order);
+	}
+}
+
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -6613,6 +6642,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
@@ -6630,10 +6660,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+
+		if (pfns_per_compound == 1)
+			continue;
+
+		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+				     pfns_per_compound);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

