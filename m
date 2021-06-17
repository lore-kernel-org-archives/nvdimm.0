Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A424D71
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:00 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIawXE007626;
	Thu, 17 Jun 2021 18:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=1jBM/jw+0Rr2nHTVvKm539T8Wk4XHEoGywUC7BkqfAs=;
 b=z9gq2l1vT0rqQL2UHOZtk/ejcLjlDSFXV6ybsXwOBlWYzicnV8nCEcgYatA0R9Pnznp2
 NZXXsEpH1Wn7JzWtUZ/8GJqe6uWN4JJv86hddlmkG/wC1H96OCtl3hAiqhvihRX7yYs1
 AkqZa5Pfdm42jZODSZRPNDJ70bYewdPSDMR+PFkLg6lpyNEzzDyUTPFuAPg2TCTxkHDd
 nX6bbcrDtvrTE+LzQwPRr1zSDuskuM05u5ylukuY9d7J1EDw+FN/SNusqF0pOW45TREZ
 u6c59ulzis49AUtQLhGz/3qmUVn/XL9mFeRRlKcU5W5rcK2v2CD0OkjT9zGZwiVBvxGL Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 397w1y1r65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjaO8180356;
	Thu, 17 Jun 2021 18:45:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by userp3020.oracle.com with ESMTP id 396waxy5wg-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkMSqOGJkZIhLoRydYS6EUeapLBMWYuf8XvNiTcGnAewLeI0N0A5bQqLUOE3kpeqHW1KAOXwH8oz5NsvO5Dnxaf9pkybqWIDLWF3U3p1dr1b3F46rhC7m7qzlp/ghyyUYIg0t0nKMx6QPfWEAgECHsZMHjFpH4nBP+mQ6h/h0yKk3hDedcycwp44EWfVBHAa8iaUfixmamN06yHhGxn2TWiUPkKwLHIi4NrkAzo4M/8XMIH+XRhq5VtaCliRPgjYaNM5lmpDJZdbYuDPolAqmJQQ0RuA/V6ZxsPOyo0lq/cAlFCWvM21NM5/cXRKT67AmGadUsLQxXm5RJYpqeH0ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jBM/jw+0Rr2nHTVvKm539T8Wk4XHEoGywUC7BkqfAs=;
 b=JyWrpiHIRKK62Kk8O1mWzjxSa7hH+yeeOKcmXXfh9/mgf1RijV5nrURpoDzub/Lk5lVM4ehVtjDNK39BjQNtuTnv5W2BwegaV9F94IpNJT8q1HH3VCxt3jBvoW2CwZNbNsTAavNemrdJPyFlFx5gzZWbrKXLPbl3fb3AeIzg38mxeW1vTJyz8fhN149NDPxgTa74TGGJUGd1oTv/7zFf+MVSlSE09n03snGDtw3ip0qk8n4SfNBffWgXmlnknT//EKuxKxB9T57m0vO4Wf2InSSqMgze3FhXw6CL/phHsLrdR70mDvbYX6ATjO1hSDLgXIdfNK4ANuwaa9353YR5kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jBM/jw+0Rr2nHTVvKm539T8Wk4XHEoGywUC7BkqfAs=;
 b=SnawXwGF0YyqGRh3e76DFEQ43A4KyqFOpcaxyviKfoeq2T1Nba+8YHl63XemGKNAaPdaOySVLlijDeQFm2rVy6VWanNcGYVV+1XJ+kfUaJh13GZB+GpNjADJrFss9LQVpVLgDS0ZBoqlcyJYfHNVFTcZJD4bYfK/wJOSH7Q3xCk=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 18:45:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:34 +0000
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
Subject: [PATCH v2 04/14] mm/memremap: add ZONE_DEVICE support for compound pages
Date: Thu, 17 Jun 2021 19:44:57 +0100
Message-Id: <20210617184507.3662-5-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 009ce406-7c81-4adf-32d3-08d931c0175c
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4852FDED4890977B4E07BCF5BB0E9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AYWoufIoZLtWSyCFmy/WDL3l80/5cX+5Omynfms2N2uebTZS91l5ZZxBdDD+1fmphmvR+37I/qbaspgJwXJYPSBeqlu6OVS4FvkXKzzLsyexk83VD+7Pkrv1VidyW9d1tur8UNhUMlU9yqJPugaZvtbkWSbRqCA+47aGZ5rwUkZTbwdfgVfQcR9BU3EDB+XMyh2wjVcPXe/sWFxgAKHarkjqDETahIR3D5JGqG/1dXQSij8VDaYYwy84BsxfbM61gWmmrFxdoTwpGyNW1Im3Ya6F3uN5MdGQrw91tK4RHfomRQW9+6EcFHplWKIH9p3owFimhpTmrHjpGpiN+FOzMZLxBbtHVU4ZmTpEaoX3qVwqHeCqIwLGJnJtxYQOKpSrP5TtZUGGs7ftMLiTFB29/NS85ZdZrHXkeRITrs0ML6nnqRmlJwGMH4Gp1fICB0KgHo165F4SEIEiL2qrJvGfNogO11VhnbVqNjFwnwSjCozWgkBlSG3CTBHs1HdekqB9jU5G+hYIh4JSzkfVGj9c66xxzAWONFrVlRGnXbIfUxoJGmWa0xuPbCmyEhI2Dfkdd07v9Gj45/bE0BCsNTtsqg0QQ1D78goPRIoeO7gcInwMVQV/O00eyGV4/VKl7NdTbkuz6q7gx9XRZ95Tuejw2B6+QQ55VXPYecxSF5UhubA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(83380400001)(6666004)(38350700002)(4326008)(103116003)(7696005)(5660300002)(186003)(16526019)(26005)(54906003)(478600001)(38100700002)(316002)(107886003)(1076003)(52116002)(8936002)(66476007)(66946007)(66556008)(36756003)(6486002)(6916009)(2906002)(86362001)(7416002)(8676002)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uK/gsdVILvwelorGyY1z8M0fM72vqgCqFK7OWLVkMS4lJx+bbLlgHRUDEZvc?=
 =?us-ascii?Q?vg7ax/FlGZZAAAqgbLmPIuM1vcs62rSLvhBPVMedCcmmlKNxmFaHxuwgeHnY?=
 =?us-ascii?Q?oaD2gUNllI97GOsjyE4AN+kjXCKPBi7iBPqlIyU8Q5O77O9RqqtQ36lGWPJU?=
 =?us-ascii?Q?CCCDh/w/jKh5MRMkj3LUvQoX7EVLwpLx2+3Rm0+1aZsUjZoSvUD0e2XR7zIc?=
 =?us-ascii?Q?TQI07ny5Ti1XTUYsv4MYxV6Np/9pDnZ0OuPkz8zpNnQAbTXGG1zRXdjYua9+?=
 =?us-ascii?Q?xOWeX+8xiDjB6xbTYAAAdk5f0pF8CjSJL0FFG1KGOy7p5r0FMl+1kvs+7hel?=
 =?us-ascii?Q?XSPKH9KeBGnCHHx1PfjwJMMD+TJT+KeS9tv4QzyNqSYMC/SlMoXUKbkzmexL?=
 =?us-ascii?Q?WyVlAVi6FvzWbYYEpq3A80gUXbaDxjBivynvz+Jar/6GNnun/pCjWmNyOQFC?=
 =?us-ascii?Q?OveZaoHhRcQOlST7zNU7j1N+5lNQq565NwHG4QipkxjoVkMPvXfeIeUVSMje?=
 =?us-ascii?Q?GZ7/dcp7G0j+oBkoYVeVKtovp637siYakxM0NBjGazA0jVJVazxBwjbx6p/R?=
 =?us-ascii?Q?raV5/Sq407unFciVu06WyyBbk2j4zUNQoshTBIzL3eYmEx0vkgMAsqr18NeZ?=
 =?us-ascii?Q?pz2iUp9s1EgA7kYemNAV9xjdBnaXGNO+S5ewkjMC3SZRKDApHuP5P2eZbP8h?=
 =?us-ascii?Q?Ra+6O7HdTj+5XDupqbLbsZZwkQzyTxKWdwXzXZwPcKjOn4hNZ3a/jJOznyyi?=
 =?us-ascii?Q?cWpvBkQS2+6isH0w4VRAs7pLSpR4OkNd3YajwEmkP7sN/O13zhUhML1aGEfL?=
 =?us-ascii?Q?CAcXjT8zpdoEY7d0A5jtdTS87QjgeL7iQCkwB9VBmMh6ndE7WeZbUuQ6UhyN?=
 =?us-ascii?Q?mxkcazUU2kgxPM6InJo2aLt+lvoNSIg7Nwa3z/6vAp3R/HFyr18tjdN9y1Nc?=
 =?us-ascii?Q?CxDMHR5Nz5doMtUmlZ05lNsT+hZx9ktsbak2M5FC89NFMPpomeUeQtegJe9t?=
 =?us-ascii?Q?mAKJvMmwr8w2cOE9+rVVGJ/8iNZT8dcbzW4cMsfSh+CXV9ctJwiIgZpCHFVi?=
 =?us-ascii?Q?FyYnoQhOWE7ebcMetf4IfBBxJc9J+07sUxBZfUwD6SBUhQVrfi6Exz5oFLta?=
 =?us-ascii?Q?zXc+x26keFOCWahTbIjboeFQxffUdkJfoyiEmZi361Fy+oZspak/WzsQ0eh4?=
 =?us-ascii?Q?1kowZx5leWL9OXkl4bAwHgpslHYTpeRyun1NRUWw2zpzblXMO0BeN8oR0jzQ?=
 =?us-ascii?Q?7Ge5MwMsinY70pLbYUqoca/UsDEjaoVvYPzKrALPOWpYLJeUQW+kLUmLHjvu?=
 =?us-ascii?Q?ZJEcxjgLD+4iHZ3uk4532av8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009ce406-7c81-4adf-32d3-08d931c0175c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:34.6688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rm14ccEkFivxFWTmz+g6uZQ5G2d9+0B/e0CF00RexL8/BYdu59iUeTezXG5BlmgOwkYJJSZ53vCz8c/whIhU+Cw8Q8UZ5NON7/7Ws6oo6+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: gi4DWARM46z11_0f5r4zaVU21qvsQrG4
X-Proofpoint-GUID: gi4DWARM46z11_0f5r4zaVU21qvsQrG4

Add a new align property for struct dev_pagemap which specifies that a
pagemap is composed of a set of compound pages of size @align, instead of
base pages. When a compound page geometry is requested, all but the first
page are initialised as tail pages instead of order-0 pages.

For certain ZONE_DEVICE users like device-dax which have a fixed page size,
this creates an opportunity to optimize GUP and GUP-fast walkers, treating
it the same way as THP or hugetlb pages.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 include/linux/memremap.h | 17 +++++++++++++++++
 mm/memremap.c            |  8 ++++++--
 mm/page_alloc.c          | 34 +++++++++++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 119f130ef8f1..e5ab6d4525c1 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -99,6 +99,10 @@ struct dev_pagemap_ops {
  * @done: completion for @internal_ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
+ * @geometry: structural definition of how the vmemmap metadata is populated.
+ *	A zero or PAGE_SIZE defaults to using base pages as the memmap metadata
+ *	representation. A bigger value but also multiple of PAGE_SIZE will set
+ *	up compound struct pages representative of the requested geometry size.
  * @ops: method table
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
@@ -114,6 +118,7 @@ struct dev_pagemap {
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
+	unsigned long geometry;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
 	int nr_range;
@@ -130,6 +135,18 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 	return NULL;
 }
 
+static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
+{
+	if (!pgmap || !pgmap->geometry)
+		return PAGE_SIZE;
+	return pgmap->geometry;
+}
+
+static inline unsigned long pgmap_pfn_geometry(struct dev_pagemap *pgmap)
+{
+	return PHYS_PFN(pgmap_geometry(pgmap));
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 bool pfn_zone_device_reserved(unsigned long pfn);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
diff --git a/mm/memremap.c b/mm/memremap.c
index 805d761740c4..ffcb924eb6a5 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -318,8 +318,12 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
-			- pfn_first(pgmap, range_id));
+	if (pgmap_geometry(pgmap) > PAGE_SIZE)
+		percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
+			- pfn_first(pgmap, range_id)) / pgmap_pfn_geometry(pgmap));
+	else
+		percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
+				- pfn_first(pgmap, range_id));
 	return 0;
 
 err_add_memory:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1264c025becb..42611c206d0a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6605,6 +6605,31 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+static void __ref memmap_init_compound(struct page *page, unsigned long pfn,
+					unsigned long zone_idx, int nid,
+					struct dev_pagemap *pgmap,
+					unsigned long nr_pages)
+{
+	unsigned int order_align = order_base_2(nr_pages);
+	unsigned long i;
+
+	__SetPageHead(page);
+
+	for (i = 1; i < nr_pages; i++) {
+		__init_zone_device_page(page + i, pfn + i, zone_idx,
+					nid, pgmap);
+		prep_compound_tail(page, i);
+
+		/*
+		 * The first and second tail pages need to
+		 * initialized first, hence the head page is
+		 * prepared last.
+		 */
+		if (i == 2)
+			prep_compound_head(page, order_align);
+	}
+}
+
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -6613,6 +6638,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned int pfns_per_compound = pgmap_pfn_geometry(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
@@ -6630,10 +6656,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
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
2.17.1

