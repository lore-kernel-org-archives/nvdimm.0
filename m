Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0630185B
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 15:54:47 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KFZ7rX012445;
	Wed, 20 Apr 2022 15:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ovme9e+tTvO4wJJnibmVHs6VjdH60MVWqY13XUbqeNQ=;
 b=RndOmyhn1tE4HvkUOG/trIOGeMNPniHA86gxv+NgTLtCwoagq9NkXBYzszl7PTmw+qUi
 MMYewsxSFAZkXsHVwpxjZvfXCy7qRBo5N0n+d9GdNNuWrDZT7G/WbXZwQ83c8YFUy1HK
 A1sUQ7FneiFqkyps/0rRxeFUbLWT5x4D2b7P40BIXo8mbugI3R2p346vJE781CcWSL1H
 ITphxOmZ0PNPppZHkrnQZSzNH+GIEHzVYA4EvbHZJphK05MB3fDfYN9f6I+mWYz/Ago5
 iK7vvUOJNNSEqRv7FG7QfOZMg83PsaChom7H09w2ICH8eqJYkQoC+KjZzlxCiENsTvHv ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbv9ndk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KFqAdL001383;
	Wed, 20 Apr 2022 15:54:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8727rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xp43mx3+UqCCQMJmljN6O+ZnZg6Zc3/ETqvwkJ4MjZ6GavhocvrgyjOW6jU99SpSJCtwW4aX8O5bmcc1kpuYWt0bIiVG4Gy/xpza2wI7AkRhLBQTdezbqChlcP916zxcARn7wO4hZI6ssyjlgPPsuos+pM64lFzpBP+S5ddzdto99gskoMTg1Yn/CUlHL3z+p40pBNagVheorJ/n0e6wymSi3wlmRtD1NZQEcvcOP2xVFRK+X4hKTIM9ldZVd1Qs0efxFuUhpoFsfPNvw2V2jkXgN1xxs1s+hDwM/AFW0lKaTO9FBNA2KAByAVX25ZFBiY0O123ggKCxQt7pgiMBUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovme9e+tTvO4wJJnibmVHs6VjdH60MVWqY13XUbqeNQ=;
 b=dGdQzohFeXEo9QaCm7RVxPwBaCH9YLTMFjH5c+sd+5Zq5JFtWFwyqwEGC5D6iSS77aCPRcmTiVtD/TkJArYHtgaa1iyxwXwOGUywzsfsBY5NF3N6opRtf80IUsmobGRE/8Wg3aTu66pQdRXJ10H2rpMddPY0hcAs/yDgJK8adML1aiuFuZtdby8DLNJdXHQn36lxXMiVoBuIeRsQpIJIIgxPfqT1FFl3WB3Q4h8W2xd8A201GxaPw3G19eNGHG42J705IF/aYH+MTVTHcbIV1oL3dWfFRlZA6SKQwW1gsyBx7BzilU6cQuC2Tu/NqZ4vfc0o+mI7azWEP72nNZBVhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovme9e+tTvO4wJJnibmVHs6VjdH60MVWqY13XUbqeNQ=;
 b=tJUr9gzA8qqNKL7m1bHuXarRPQ/9WhAHSCkgRGcv2/5VOcrybeB1fBSQxNh8ROdNm2egjGNhJAmTlbkcucTCpO5fh4D8ewdhCNtjZ50yxp1LCUgWHu5P35jZ9TovX+mUqllgageXqL9ShfyNpyMDvoILJi4lh0O26R2wo8dVYSI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR10MB1330.namprd10.prod.outlook.com (2603:10b6:404:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Wed, 20 Apr
 2022 15:54:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49%4]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 15:54:31 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: [PATCH v9 5/5] mm/page_alloc: reuse tail struct pages for compound devmaps
Date: Wed, 20 Apr 2022 16:53:10 +0100
Message-Id: <20220420155310.9712-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220420155310.9712-1-joao.m.martins@oracle.com>
References: <20220420155310.9712-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d3b2e22-4bbd-47d4-3711-08da22e60ec0
X-MS-TrafficTypeDiagnostic: BN6PR10MB1330:EE_
X-Microsoft-Antispam-PRVS: 
	<BN6PR10MB1330C14C06B214B809FDA18EBBF59@BN6PR10MB1330.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/uaQhrkuEZAE+GljW/TRWJv61FJxjRKFeQv2RRsRzRvUG1EAxglmR0k0mZ0HElvDk/f67B+bJR9AQlVjlyw49FRnznjB7KkKDYAJ1V7g+M6hlKivDiSkB0i0APUe0sFnmg7RuOM58B2gKOwmjq0qcDvidnCwVcG2/vUDLKGGsoOScC/D8OBIqTUKANLdERTiQ0yaYUfgngJ/AR0vF3+hs/9CrwLoVA6EhXgM678/zjeYdji+6+SuEfqHGpQR6RwSCpLjJ9MDHKl1Rf/TnGRNsgsBWkoRhybY5AHoVUWj/R2L4Hg2accWHRjLwTOHGQSu+ZOcIZIQS/b6MWngbtq/SrBBsD/APt8PcZ+QSzAbuWxHikNhED73wg5IpT1hO7LkV1P1o83rCCsGsbYf0ikXlAfCT6/e/DvweUHanSdSiLRRRcfqFxsgjmSPtmwGTexDCfPFieU/pOYaQYdRwZk3LsVZdhYiNaHh1ny+4i/8nuDbrMp/IbSdQ2ycAcxJuB/WwZ4mpRxBDCR5tQL9xqJTwGTIeG9bY1dC0CNC22Gj79tyJ1/qyS0EGafqlzlANjGUEsA11Jow04ESm/v3GUEA5q5DpIdWp7Ogw9XOqYQsa6R0SfwyebYk0YZ1qm4Zzi5t/Ab6A1Okno7JE5T0CkvPF1dpBF6eDZFRj+UZriR6REFY8u+Gxl6suJqfEUc8mXIvVQxxHm0Yn0X8va4VZYwBsA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8676002)(26005)(6512007)(4326008)(86362001)(38100700002)(38350700002)(6486002)(8936002)(66556008)(508600001)(66946007)(6666004)(7416002)(52116002)(316002)(1076003)(6916009)(186003)(2906002)(54906003)(36756003)(83380400001)(2616005)(66476007)(5660300002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?2F+l4YW2Q64H2LlQm3MOFDrJ6wZ0cEC5OI7xT+TznJ8PsKhB5AU7E6w5RkrZ?=
 =?us-ascii?Q?PY8urkZB8K7tqwuTLtSPTWESz9nN2C31XXtogCjS82/VaUxrWVEqOGl6UElj?=
 =?us-ascii?Q?N7DwLHemeNsRrcQ+a4cJGeN82iRwH5yPkFB0oivpcNtE0NyctoHT3lM40U2i?=
 =?us-ascii?Q?4eMcup2bkr/cYZyztjxLX962wjWhlHoGDi46qBENiHVdowa8SevxO4uQJcjB?=
 =?us-ascii?Q?GUq6f0pu6MH5bRfvvHsPyPw/1+A1S3U5KlokNOQSMVohWShXq5emcyUb9jOd?=
 =?us-ascii?Q?lZGk8gg6mEDbByAK2/YfkJ/faaraTpp1KjyFS72HbyUMvyy594q+dtUzfEtG?=
 =?us-ascii?Q?P1ki4/RGkDbqUlytRgbBfw+uDGbKwn0K4+26/TMrDXEAXjLijXolAobMOMyA?=
 =?us-ascii?Q?7kjEFWBci8ebZWEYhiTETX/iMSbUeL06CpXKay69B9nSL3Rt2PrV3F8Y1H8O?=
 =?us-ascii?Q?5VgXsOFKcA10JlzY53bSRTREYvAztWQkLvb7gkJMmKuyRQrp98IHivuB+ZVC?=
 =?us-ascii?Q?XkJ3j3siqOAuoeBeB0yUMyIlUxcFtzKJ4oMiCN69VWH/we+hkJFEh2w5akBZ?=
 =?us-ascii?Q?nZehfaaNz8q6ja6I79HDbhoMPP5oA+EFydMjp+fssyQmCPeHm8oHSkQ3CuuY?=
 =?us-ascii?Q?m+Krc445G64wf3DQxooX8JOgRTjE81ajZ50Hl5bygMZ91/7k+cZeL8/60aVf?=
 =?us-ascii?Q?5DZckLojysdTAwqQu0tpFMrKCuSeMigv0tCqFwNu05pd0j++QLHV0LfzczGj?=
 =?us-ascii?Q?vDXVoPNjE9p+VtxMklYt1F9bYEByBQmm3kJqi4idx1wWIaVx5yXhQFCNmLvE?=
 =?us-ascii?Q?B2pH0ttFSycmMn+9kINT5LZl7MyIvxKXYaRSi2ShLGwt0epXqb/2xqvYIisU?=
 =?us-ascii?Q?49wJ4er2x0d2s8lII0O9mj6UoIN+Jf+qongZkul3pesLiBOtfXaCGs3xl7XD?=
 =?us-ascii?Q?41WjNS0oOzwgHB9QvO/zIk5GVmVwQE4hU64tm0Yz1UU+fjG06GL9bn8HT9zL?=
 =?us-ascii?Q?Zj3PaHYMRz+UBwLKJkVC6P15Pj7Kh7W4Howhy0dDiASqNrOtMBdzajAc8zJT?=
 =?us-ascii?Q?78ytV0QUvw3B8IsAB9CFY7HYKTRV+QARgmkUray52n6oAopTzwUPuPakRMVa?=
 =?us-ascii?Q?5+ta0QOh9+9aWQ2ODmFd0wGPdebBLdMMq2ejQjWiG8Woh3CG6Fb/61UqnIV0?=
 =?us-ascii?Q?XcVBRITy98EWa5Sr+742kVMJXqcFotcCWiPh12axu7Cz+ySr2iLsCn7PAtjS?=
 =?us-ascii?Q?UTi1eGiv3o5HgOqIySyy/1jqs4mF2/rY1pC1pBBQJIoyqJFEOHAD9SK2+e/d?=
 =?us-ascii?Q?cGzgPiAcpEqRSx0gF3TC4i4XLA20sNDUAf1ElPzVSEfp1zKUr3j4JJtrF2Yx?=
 =?us-ascii?Q?oLGDqstJH1D6b74jYHGOe+YJtRmdPQv7lJ+QQpYDUppd0ACjC9s9RHv+3cNa?=
 =?us-ascii?Q?AXLUN/bcKyGOCWuh/wzGO88RZPPYoix5ubHAYwqiNf6B99MlMBIeuuaZKsta?=
 =?us-ascii?Q?ZhKQ0Zr1KAuyIsnp0sOPD6FmXsTDzBxSNAa5ZRllFGv/T4FlDgjV5TXCTVVi?=
 =?us-ascii?Q?nTd/R3VnpeiQzK1DpHqXbHFF6vwRqwor/tqFLhEsAJj/9cfJ11/bPLtI7/et?=
 =?us-ascii?Q?ailk09hlLIHJcrK23GP4vAVSfjDTLKa7Df8Tdb6FZsWqYpsmqDNZCB4aMxRi?=
 =?us-ascii?Q?Qgye2ZyA+ga1SPzKXDhU5Tqw6/6WebVIPhCEP863q7ktFZeQGgF6YjnFmKd8?=
 =?us-ascii?Q?SllvDhWWQI/ZzPTz5y+KTnhSsiir2iU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3b2e22-4bbd-47d4-3711-08da22e60ec0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:54:31.4458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBInq0BJeVRJCnICv5xmv92VJz12reESKnRupKHIW2fg0yVJx5JxHzTN+1qS4Q7TLHJCWHW0bGkSoNC0LR6SZW/3qpfdx/qf6lqmxar3UHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1330
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_04:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200094
X-Proofpoint-GUID: 2XgPbn4L1qH4ratiX2fP5or5HyUWEq_g
X-Proofpoint-ORIG-GUID: 2XgPbn4L1qH4ratiX2fP5or5HyUWEq_g

Currently memmap_init_zone_device() ends up initializing 32768 pages
when it only needs to initialize 128 given tail page reuse. That
number is worse with 1GB compound pages, 262144 instead of 128. Update
memmap_init_zone_device() to skip redundant initialization, detailed
below.

When a pgmap @vmemmap_shift is set, all pages are mapped at a given
huge page alignment and use compound pages to describe them as opposed
to a struct per 4K.

With @vmemmap_shift > 0 and when struct pages are stored in ram
(!altmap) most tail pages are reused. Consequently, the amount of
unique struct pages is a lot smaller than the total amount of struct
pages being mapped.

The altmap path is left alone since it does not support memory savings
based on compound pages devmap.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_alloc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d4c6a74fc85..8c34d43a4914 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6606,6 +6606,21 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+/*
+ * With compound page geometry and when struct pages are stored in ram most
+ * tail pages are reused. Consequently, the amount of unique struct pages to
+ * initialize is a lot smaller that the total amount of struct pages being
+ * mapped. This is a paired / mild layering violation with explicit knowledge
+ * of how the sparse_vmemmap internals handle compound pages in the lack
+ * of an altmap. See vmemmap_populate_compound_pages().
+ */
+static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+					      unsigned long nr_pages)
+{
+	return is_power_of_2(sizeof(struct page)) &&
+		!altmap ? 2 * (PAGE_SIZE / sizeof(struct page)) : nr_pages;
+}
+
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -6670,7 +6685,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

