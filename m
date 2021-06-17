Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435592C2F
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:47:02 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIawXC007626;
	Thu, 17 Jun 2021 18:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HJOY4OK+hvH8kqzf+T/g3v3TOM3Ict48IL4jQnIfAIE=;
 b=RQ0ri5VCPX4LOdXlCZKsrtTr9jWkdKwyuHHQSn3uNJ4qBDw+MhfDTyXn5jK9YnEp2dk8
 mP8OuPyDA1EXEAu4Qrj6kgDn/5ogcgGEeXllplibwl4242kZOT/jSAPLAnq5yPjjMxGm
 7o69PwRVovHUBcTZt0yQUAb9ZKY5ygVtYupeBMvjh1MdIGVDe18fducUw1YdIS2+bGo+
 9FcyOrFM51XzkUGFi3ToOCQle0KG70uL+6s9i9QKo8BLyJfOi56JvFuc2zcz3EDB0loe
 B6GwXNojWMaxPiXWeZbRYKT/pLcK25+gzSQmuJ9asK5q+5YJHjHBZV65c0LvWWr0ZPg+ xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 397w1y1r61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjaO6180356;
	Thu, 17 Jun 2021 18:45:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by userp3020.oracle.com with ESMTP id 396waxy5wg-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4lvCYwH9tzkwZpuNxDgykiWkdNOMX3OMU8uaFmz99TB+beHH7l2QsEJq0aLuiZm/tV48alfOHsyrnck8ZmL5om7i1NjKbbAOb9bNKxt/uBVhv2n0ZfWH3VN3NAwVuOb4WNrS7uR3MOx9I7s3n88ErGuB5y5lWZ8NYKxIDury8uJAXiSVqOIwkmZ3BzqFYW5JeBVZLPzdl/pfeUnbaDWSYlgNTDAK96cQ5l38OQWJHlIMvWHtqbZwHtKLCOuRijcnevKg9fm5Dy7wbzhUnvA2m8w+EhJujCb/N8lBFuY8sozncj3SmXFhVh1EDkQ0xCQGAHJt8seNuLC3ngsNkFSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJOY4OK+hvH8kqzf+T/g3v3TOM3Ict48IL4jQnIfAIE=;
 b=VDDxFjfqigrIHXbYnTH1Aoi+NWfiyc8JvypcXuxW+lfUtG3gMPq2NFBuARH/lxvjrDbGJhzI3fIi9SwsY7pEvdvvjFZD6i7Bb+Orh9ca2GM8IJPuDnvYsuPImjpNNMri5sAVkcHcWYAE0tO6sz5+XUFsCTLTxZm7Ra5yxggMXUvLfDTycBTOUo7GiSYd3p/EeUOWI9hK0p89ddYOBn+KddQRiJbZT21KITYOOcExoE9Bd33Pd/P5Fhi8TV/HRWM78nSQXeg7SOjqd+I8JXDcyuIGmnc34KOZfJyPenBJxTGl4Eo+K8614/gSj6dw/QrmzkFII7ElTeQLlqlvW/UjsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJOY4OK+hvH8kqzf+T/g3v3TOM3Ict48IL4jQnIfAIE=;
 b=lW32py9yWySvV+t+sSCT70lDFXAIbeYp/sEZTqzPvC+9B6cMpNm1CbNmL/4jZR+0MfFAs9t5iTTTcAjqZvC6uW5qUIhPqub97Q0zSY7I9vTjwVfNztOFmwuWhkYTW45HkSvAsX8jro8Ip8FetA/1vWOuKkmBc/daNPLxFEGK+/M=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 18:45:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:29 +0000
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
Subject: [PATCH v2 02/14] mm/page_alloc: split prep_compound_page into head and tail subparts
Date: Thu, 17 Jun 2021 19:44:55 +0100
Message-Id: <20210617184507.3662-3-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93704ef9-e252-4b7a-80e3-08d931c01459
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4852B50A634E12FA07228369BB0E9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nXOy3raysiL7Qc7utr41Ss0WWHP1922U+AR15FaeVANyp+9/9+rR7TE1bCHCHYrlB89SMEVPiXDKQixzqW5VxQMYo0YiZfGV7fWXg3sUqvKTIwf1hUvnOVUXRVGAjrp6zBXjiO4fsQu8Z5K2s3lGps9cbzvuE5iIOLsTjRCCEGbB7ZYBJSfsaezxwkN7xFqu3GmRCLNjB8lpwfX6ZTQIDqgMTSD8PGSr+izwAHB8m/nDetERMKtm/TrXt+LNIAstqTQj1KB9kJJ/svwAOPl1DsArDYY5GAMr2eGM2kOiFkPzF5Iha2gXRxYFczYjTUI5hCo5TG3FaILvwHCsH6QgYkOXNzrS3uWgY5y5EJHEHd2jw+SZ/M4WkPVZFgEcvT3xvVsHf5E8C38k2J26FvQENz+wPD02VbL9bxTRzEAR0lpYKE8TZYEGMinmemPyHbgSNlXlQkP8eF2h9+l7U2ds0KvdfooIUjOGLeD+oQxIAbLXORLzRSD5mH12nDQRDqcX9NuDgIrEodjrcD0U5QOJhvtbbMheEUxcTYDAJsJ8j7Vcw1PDFKzpJoZi/9bsVPjp4xVUPeIEWaMkvNDCWffFUbOlxyd1VNe6a0OXDYaivJg5Kc/Vf3qdXjsrC0MlKbucCSsHo2Qbay+8ff5e6bf79hW5wZiYhE8itN2XkWAf9QE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(83380400001)(6666004)(38350700002)(4326008)(103116003)(7696005)(5660300002)(186003)(16526019)(26005)(54906003)(478600001)(38100700002)(316002)(107886003)(1076003)(52116002)(8936002)(66476007)(66946007)(66556008)(36756003)(6486002)(6916009)(2906002)(86362001)(7416002)(8676002)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ryJbLSn4gEtLPceemFhHUnfTcft7QX970jHa3vNNBpOcRMFCWHL/+F9KSJU3?=
 =?us-ascii?Q?ki1Q95QFLqeZGDKfTX0H57n2zEl0ZkiS22koiLA/9Ag7ZYpFN+nOZufxxRhr?=
 =?us-ascii?Q?V+KuI4pBELoTcfAa9fuqkyq5uOA1PyUiBPV5ITsy4HCMlE34vfH46Rr4V2X8?=
 =?us-ascii?Q?fz5dS86UEUXZK4ANqjIfJmYORjLnCTQ4QLHLCSEh+fQ/2sNCIOuL72NDHppS?=
 =?us-ascii?Q?NJ9AaMzVWoH3jkso7CWOAGwl7xBzaBKunFgawVzGlZ0aKKHd8e09goqCL5Gu?=
 =?us-ascii?Q?ZPEaE1Bqz07QLi1+1Owj/aALhcUELXA7GWnfJSbCHMzdEAqoiwyP6jvYorL4?=
 =?us-ascii?Q?yyCixk2UCzFecvP3BK/E/aHQO3oUDWG1PUo9M8v1vgFAAAG7LEJooWXp47Os?=
 =?us-ascii?Q?K1fWpHaQKjIZ5sDBct1+H+V5jCrFiZGqZsykyeWtDLg5DAtvlpdDsre2w3PT?=
 =?us-ascii?Q?wg1t4Y32fnoFRVEmYPfr1PWyv0NEUEiPxm3snk1pVooTwH5rYaXPU46dd7er?=
 =?us-ascii?Q?DUbJAT48fvTkj0BWDnYGDT4YUG1csv2EMhjShNjixX1L8dTDaW2peCXcyiqc?=
 =?us-ascii?Q?woeBDZs3p2ILBS9plZjwuXebSQIKYIC1G31Lpn9UmaBE1Mnsf7RAp+2OWFz9?=
 =?us-ascii?Q?a0QVzg6FXyCknUt97ghfJrMUGvHdOw95jzZEXCexOU2xx+uEl9OByYHsGhoG?=
 =?us-ascii?Q?CXgOdPWkjKRSsf6pC0/4YJVdzidNMVvogWkUVOzOH/cTwvm55Li14xh0jW0R?=
 =?us-ascii?Q?K8QH1t7Bbjw6ppX5LoPEQB3AYOnx+DdLZEA4f86Ely3aO6bnM0J9ZlgW/J1r?=
 =?us-ascii?Q?ot6sz2gYVMBx9cnvy2e1nfS+gfYenV6siy18pu/o5ROwEVhWF/ZxP8wrxxl3?=
 =?us-ascii?Q?kWZR3u+SKuT/5hwcqIUQbhDrKu0d8dVvLQKbX1JZLRwAm03JASjY36J2liXt?=
 =?us-ascii?Q?L6NsWQNqczZYSSfAMxOVPdRORSaPGVD0ip5C2bhNxe8DGPTd1kgGr01I3/Zd?=
 =?us-ascii?Q?pxMx+aJH7ABNmTfRein1mIRuPcs34mC1vAxisaCywe4qEk1Hp++qAsH23WzQ?=
 =?us-ascii?Q?Pm8vb0SaiFUdCpRvC4kKmg5YxfHPV3SKJU7A5Hn4NBRZ7YrzUQmk7xAufmhc?=
 =?us-ascii?Q?6D1P6F0vBX68zzvQ2EdXG4IS81en8aeQ3kJsp+AHfG90K7F/C0HA1KxY3d+2?=
 =?us-ascii?Q?M0m7Ub3PBkam5yePtAJkHZxEke9DTI559eqr3rhSzD83NNhe8kTqOBNrsNTe?=
 =?us-ascii?Q?LU9C6VK8uEQclMwE+q+HEN2lCo4UywDrfKafGljHYxsYPFoKsRPOV5NUqMUk?=
 =?us-ascii?Q?I69KdRc7DgvAzIKsYoVmH7gL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93704ef9-e252-4b7a-80e3-08d931c01459
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:29.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3uVl1AWjHbuY4uforHC8Tv2Tm1jik27LCnWDoFGyKlq5fmxPgBLQv0RSXS2U1ZTeAPC0OEqEmD5PtCfOeypjaVlM7fku0zK/ZheOTWqT8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: 4gqGtjdyWebzxqPPj-ahIklorBhLesJ3
X-Proofpoint-GUID: 4gqGtjdyWebzxqPPj-ahIklorBhLesJ3

Split the utility function prep_compound_page() into head and tail
counterparts, and use them accordingly.

This is in preparation for sharing the storage for / deduplicating
compound page metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8836e54721ae..95967ce55829 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -741,24 +741,34 @@ void free_compound_page(struct page *page)
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
+	set_page_count(p, 0);
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
-		set_page_count(p, 0);
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
2.17.1

