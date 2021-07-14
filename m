Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87E06D14
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:30 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVMMW031363;
	Wed, 14 Jul 2021 19:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DgFa36vKxyDbO5Oq+1ov6YbXaB8wMCO9g9s3XnYQq5E=;
 b=C6KNc5jOO+paSUiDwOEPLvPr9wElDqMzZg5VF1a0d8Yz7TwZapaOL2M7OaMebXT0aVLA
 1ZrSNPY+LOHenLm2pqFfj4jVW958BRsKhmKpesN+PQrieAbkR51P9rSkdEE/kpKaARqd
 7DlEl3s1kbyA+JhDEXDkvkAokj5P4VC1ANUoXT8mQO1Fnvm275NC07cI0hl5dkLOL9o/
 To5zIvWOPPXLmUrTaKDy4xxLlMvSETkBFXuUFVAxZwf/shRHnqJtpxvnOIA+GM6vGzht
 M9uTQ1fEMT0c4UtAXCWle/loxc7Gg7I1WfKE1U2TaX7wi1j/aloqxp1CRpO1PqA8DTT2 QQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DgFa36vKxyDbO5Oq+1ov6YbXaB8wMCO9g9s3XnYQq5E=;
 b=Bx9OnzGP9tq2kdP/DNtAeRVQhEUEaII5ovcKu6i2k/g0xMzqInXgRV8VQgSaHoSkaQkn
 kgQxcRc3i/SalyqeHaegzn2rWFqvz6bJUeadFTMeopvLJoVJJ+CzoOc8CtLK4qHO2bYo
 ZNlSGcaqyFGy4KMI/4THPUrbeE3CHsuYCT97f/lQvQO0RHJLLw7GJ5ImkWCFkR+lOjw6
 A3nHQbHF8/Brn+L1cO88C3EKJmu2wgu6bTkMNY3z7GLKGOT2PmCKZ2lmG2fUaHOodv0b
 53eZCZ0tbX3GpjOqgiqfZ3pc062lsJqbam0YsWhCuUoKmT1dVIC9awN9XyLP2Ma/JlUT 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb5knd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUXgJ021507;
	Wed, 14 Jul 2021 19:36:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
	by userp3030.oracle.com with ESMTP id 39q0p98max-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGjcXfZ1rwCjNTNfi7hw1qwfatSBYGogAHnJ9wyiVacuRa3ybyIRDq9y653sURhsIBNJ88ebSZwzp1wZrngTfxWBMaE8GIaEyzUfPdCr889ltUBzKQNpL6rVWMrZVS7O0/y/qjCWo5dDZSXv6z5CHocgNpZjzMjUD+/B3FYB6nV2B7ODUIiBCUrUKU2JA90ULIIVybRNRQL9zaUg7KCa9KP5CHVhyM05oJJRbw8UlGVHTE7fyTih26P6bH4v4y7J4oMij7I91EfihyIr7rrHEjiYcq1zL63a0UNazs+bu1m9Q/wFy8GS9fXJess/xYRIe+ZcSi8dJvEncj03YCkGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgFa36vKxyDbO5Oq+1ov6YbXaB8wMCO9g9s3XnYQq5E=;
 b=cAonrxfh2hbNGU/Ei5E3qDowR+Ws1LznVog6qugEhbPxzJ7+G3AdovYxPbnrov0DATg/S/uwHmTLino5b3YJezY/9OnhsOqLzlAvzdecPpoEzhumwJMzVDhfXplJObhWX2Nwd6CEHHIfxlUygnTze3ovZvv+a+snmNC6O4fVsEPyJKNL5N4tLYWpTFJRXPGAok21ImGm28tLAWH/tvPkg7h4yr5Gkwm18TdYdFA/v0u81TEh63a/whtCR4W1YAv8qcoz0a1UOSQHvUyx4ZnWSHsHm47XBL7d+TOxiN1WM44Y91fP25NbEDwO7qUjKStOgqzFk19J6N7X9Or3JzJlng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgFa36vKxyDbO5Oq+1ov6YbXaB8wMCO9g9s3XnYQq5E=;
 b=NGcJAWTIePrnribpIPZQz/bUPjoCqwvHUSkjxAROYfhLb/cp3EbiDpmZ1sAtgnA/LjsqbHY7GzTeHRUWqQbF9nBWytxIdzSWnnqZu5tI39wAYUZvqM6i/RDw0FAKV9PD2QfVYGfupyrGZoGVGCz6Kfw3I3CLPlzmAmTW8PTYEqo=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:36:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:21 +0000
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
Subject: [PATCH v3 09/14] mm/page_alloc: reuse tail struct pages for compound pagemaps
Date: Wed, 14 Jul 2021 20:35:37 +0100
Message-Id: <20210714193542.21857-10-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dc6b64f-a22f-4e25-1c62-08d946fea87a
X-MS-TrafficTypeDiagnostic: BLAPR10MB5204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB520436335753CC63CC46E3D7BB139@BLAPR10MB5204.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Z6ExAPWA9gSVMUJZYbq3jwbgIPnTpH4doipXlA1f5AdpVvj+dFRdvGft7SrA4qkgapC6+9iGlbZQV7vNR1aaCxRLGItkG21t+TWdeEZ8npvyUYucqiQW1FUO4+nKr/nGaKZaBwvUZQimH1roqF+fDm7/yNRT1Wf0rIIlvn4VoHC3KXYC7TVp5wRlhu+JlNAOSTs6N8My3uiuzuwGgD8wjlgWxGkqcD1JjW6+cuJg8BMtysukfXraLznuINwznCDvacDkRx87+FDx3mnuH4ZKnqwdJthhw459NjkW7iwyI48fwJ+pk92/SVZOK7Mjv+WnE/aMRTNr5TZsFDGfmOZbeJrpYYLwarQYS9eYKi+BFVzTGWvAq3XwrojQsdVQJL/kWyi8Y5BtLAYvZ1G884RCi5BbKfbZtLTxcljY0Pe/TuncHvqPFuupxrOPlEHmFOCYQ9wAeydKrh8qv1GdhQDnHO7Vj1LiuK0MdGIZnTsHBjhZWqJhtYS28RAFtWRFFCzfKlG3PYaxA3QwVO2z2hrSJ25/5HEKNSMwoewnT6FUMOpITt9Od2Bve6g23u8HOJ4eCxxiwsO37B9aZbaTIfDUthdEPMP5AYKGyWkKj3E8Xg4KiSdhpJb7h1GOwlyOAIZYtTz0uagi9PiXl2Nq4LlnpcUroaMjZmSn5/7eGUxhdbs9thpWSnALNrqD0Gp02IcLBhI8rIvgYiMnZCeoitSziA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(8676002)(4326008)(86362001)(6916009)(7416002)(2906002)(956004)(107886003)(2616005)(6486002)(1076003)(8936002)(66476007)(5660300002)(36756003)(103116003)(83380400001)(38350700002)(38100700002)(54906003)(6666004)(66556008)(316002)(66946007)(478600001)(186003)(52116002)(7696005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?xCdSzq4kC4+LesmXrsbwWRIHsPdvuCJ9fP65dTlOSBSKKNemMDLcLJp/YhTR?=
 =?us-ascii?Q?xWJme3KTK7eavRZ+P/hFigUDkXbr5v7IEur6FqmcfFI0hQJfnqb6hTvDmRbE?=
 =?us-ascii?Q?TDi68SqE3l7KJCrQQyCJPyAsBcik7aAfDHLgmzF0xaM3wGrkHCBEmQtsqBfB?=
 =?us-ascii?Q?gV38lex+u9es1nILvybEgErMNGgUgcyBWCD9G9qooHz4VMrOW2HusKEhq8OK?=
 =?us-ascii?Q?NYJ+++NpbCD41s/x+exE3CLnLAxVDA828V7AB5tfoaNXsc9MNliuycerQEl6?=
 =?us-ascii?Q?/zT7O4pIuFGFtb/IJINLOSKozu6IHeL1IyvFsYM8GnPgJoNI9G5/5Ki1gwzf?=
 =?us-ascii?Q?liihgRHF7hmd7e+/IDEBgrR9z53NplPlgmc2A5RtVl1YoRCafSQnojdD3sUP?=
 =?us-ascii?Q?M+t7144xZNeaxYHRFxvnC+hhP6khJwxIkeCTWlLMZqembSON56UxOlqHI9Dh?=
 =?us-ascii?Q?MddWrA/OHgxJpf2i0AGgrbFOs53R2WrZM3N+SpqibZ1PQGEbX/gJBhunNJz7?=
 =?us-ascii?Q?DDH9XBOdj16E8bW8x4plMJsNaoLNYxSQVpwpASym5ld6B8CPzKihzFOjy2uj?=
 =?us-ascii?Q?e0TpFH3b3Pb2FwFdOdcVGbrGKNXp5WRc62kW6mem8gCmw5LEEaOGv+QBS9IR?=
 =?us-ascii?Q?sIDSTUhrY3TBS+ZQRmW+xGQYa/bhzM5nFsQgrTMyzxdZ3P3sTlsbRX3i+A5D?=
 =?us-ascii?Q?iqUudH0vLbuSLXQuJNqZuozBF3u5PIySRuhsfvxl5j7NEPBa59veoeaDyRVF?=
 =?us-ascii?Q?f4ANYFfIUOWNpNjBTvaxt/u56gSprd2sooQEBWtfmgKJriRhWgB2vqtre+oP?=
 =?us-ascii?Q?A0QiZk3Rv9nAPLpihWgQbTTcto1sRWlUhNbdIkV1KSgN/eSvqhoOIu9SLp1+?=
 =?us-ascii?Q?SGxCa26DOMG3uXHZ00ehH6l88zJzSEHzJxDvy3Gb6FGv1e0+wE0aALJCaFcj?=
 =?us-ascii?Q?SoybwOPuAsvuFvU4GpTqlYT01Ju+FoTXPD3H5iq7tn5ZzyMqEdo7xiTNsutw?=
 =?us-ascii?Q?7/LRAFd1U//WJahT3QFcXhh8I0Y7tWZtf7LKfP+/inte/ILqvSMXwrRIcAza?=
 =?us-ascii?Q?PmIm2+RxNVUk1FJOgtoWq4IQgxsCGAZww9XUyNT6o3tTVUFXV987dVuBrQU6?=
 =?us-ascii?Q?iMjYJeFRTy/b1MztqK6vZpHuswO6biru5E2rrMTqJLdiqNNnEOdigrrT4Riw?=
 =?us-ascii?Q?x87ppySNmTVqeMmOti/BUQfAHXfAOALmL8rhUjaXJWUABg6gWqU2Z+mw9mH4?=
 =?us-ascii?Q?FLtlxaROdgw/GCpcGlTjedlLDn/5Hf9qYlH+MFw3w53AessotxYc2RPaDV21?=
 =?us-ascii?Q?PQ4iz2ILhdCCbko19VmiG/lr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc6b64f-a22f-4e25-1c62-08d946fea87a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:21.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sin5DG/cO6/Bfdlm/uP6T5eRg+O8IYknnIgCIM2kjAED9UAjq0r24LsHKeb0RTU5QezqHrllPRhNGkk1Nr9B5in5GLltp/bDBQQ1m/lxypw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: PNMdpS0IzVgF6E6OfWgr2zg7oxkWjhQK
X-Proofpoint-GUID: PNMdpS0IzVgF6E6OfWgr2zg7oxkWjhQK

Currently memmap_init_zone_device() ends up initializing 32768 pages
when it only needs to initialize 128 given tail page reuse. That
number is worse with 1GB compound page geometries, 262144 instead of
128. Update memmap_init_zone_device() to skip redundant
initialization, detailed below.

When a pgmap @geometry is set, all pages are mapped at a given huge page
alignment and use compound pages to describe them as opposed to a
struct per 4K.

With @geometry > PAGE_SIZE and when struct pages are stored in ram
(!altmap) most tail pages are reused. Consequently, the amount of unique
struct pages is a lot smaller that the total amount of struct pages
being mapped.

The altmap path is left alone since it does not support memory savings
based on compound pagemap geometries.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 188cb5f8c308..96975edac0a8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6600,11 +6600,23 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 static void __ref memmap_init_compound(struct page *page, unsigned long pfn,
 					unsigned long zone_idx, int nid,
 					struct dev_pagemap *pgmap,
+					struct vmem_altmap *altmap,
 					unsigned long nr_pages)
 {
 	unsigned int order_align = order_base_2(nr_pages);
 	unsigned long i;
 
+	/*
+	 * With compound page geometry and when struct pages are stored in ram
+	 * (!altmap) most tail pages are reused. Consequently, the amount of
+	 * unique struct pages to initialize is a lot smaller that the total
+	 * amount of struct pages being mapped.
+	 * See vmemmap_populate_compound_pages().
+	 */
+	if (!altmap)
+		nr_pages = min_t(unsigned long, nr_pages,
+				 2 * (PAGE_SIZE/sizeof(struct page)));
+
 	__SetPageHead(page);
 
 	for (i = 1; i < nr_pages; i++) {
@@ -6657,7 +6669,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     altmap, pfns_per_compound);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.1

