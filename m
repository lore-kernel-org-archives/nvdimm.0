Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AB82C9D
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 19:34:32 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AJ2Pe0017445;
	Thu, 10 Feb 2022 19:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jfW6myF/vYu2yff8Flpm0N/3fFb+8EbngzE0SqXUJgw=;
 b=tsIfEg2Q5Hfee1yjEYdmSoW9nz7+w4cyUusqyV5i+t8S3LQA8UOPdcZvKx5oJxomJJ08
 DrobTrWh0iFQ8G5UUbvPom9itEKx7WgU6xzbOqsC2vHpv8ezYx52jBPbgfrPh5iISE7Z
 b17bi7N8gfhiem2NfMXlWMGVAx59+NrGytzZNrM7oUS7UgBRCceccuF4RnYK1BBex82v
 8XneMkqvSr0Jitjk0/pWWnS5t3Hj+hOxEAJPFlzC4u/XMRmLLNsLClY9ruOxug3WJwVj
 gwLiRHNZvMta8VPSHkUjQricLr1J2SdYFvmhpTFL2l8btdNSflyeObaXEx71bWaY7+EE eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28s2u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AJVfDI144080;
	Thu, 10 Feb 2022 19:34:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by aserp3020.oracle.com with ESMTP id 3e1h2axsc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A98KR6UFPG6QI6G7yZEJp0wML7qX5zgr8KFJO63OfMyA3Z/U0v3aX+rJpLqDJYFBJZrxSQFnqP7IggcdDHj/OgTkl3+0pWFl5Dpl6gvNO89gASeyu5+ag5E3V0jTZYz3lacCLpuMSr9bwx2XByhYurnuTEDoO2TtNOVMsy0kTJFZZGKF6f7fBGq3SLTlWz5aTKEzDyNbABP+V5A8rI9Jhvv/PPiUxH49GoF374Fg8nq9xSzhWdbpVQF4MlztpVIv/+mIMEjK2gIdtoAi9wQSaqaG2TXIJ/tzjkzKVzdF9tTBhwvfKGcRis7lZNf8kR/GpdNOVuqrXmQRnykfn/7lGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfW6myF/vYu2yff8Flpm0N/3fFb+8EbngzE0SqXUJgw=;
 b=dl34yY03Y5UXm8lXuSZD64JhsqVbjIGSgZnJlIqJ1cN4WLrv8ZNCx8G65RNrDBJcNZDB8EF3wStqetlhEOWPtEBeGL3RwwTe9wvm+DZqpE9UI1arkTG0yJBixdUzu6j6BzMwPeF17xPyCE2+YWFmRH6c2NU59zt37BVvOS5WGGaIWqV5kyHzTfPGEAQ+7zCaWNZefNFtheuyVoMJt0oE6GV24NbP1aj4muU/hRGB0vwlT9rOEPnm81cVxZJ6LCuphgnLB+fm2NODdxKExVoMugUAe0YT16PLnFZd6LA6JqiTNzb5+WobjSF7pP4NnzriSJ81uFh/0KdJ5m9IpNrqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfW6myF/vYu2yff8Flpm0N/3fFb+8EbngzE0SqXUJgw=;
 b=PLmh8ZTGwgZz0KCXLuBIuatW9z5FzU4r3Kc4NCnbCINrCna+KiWcNPRTYDKtWMvtpJKc8k8UB6Xn17hDFYWBG69JtDkrreac8akthZUSmhI6fLmPUkMmWQ/UMi6KxL7yhI0g/6A3+ZwY1uhkLA9O7EE9f7oYk+ksRAFXgxiye3Y=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2514.namprd10.prod.outlook.com (2603:10b6:406:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 19:34:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 19:34:21 +0000
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
Subject: [PATCH v5 5/5] mm/page_alloc: reuse tail struct pages for compound devmaps
Date: Thu, 10 Feb 2022 19:33:45 +0000
Message-Id: <20220210193345.23628-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220210193345.23628-1-joao.m.martins@oracle.com>
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0170.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b9cca63-d450-4351-bbe5-08d9eccc5631
X-MS-TrafficTypeDiagnostic: BN7PR10MB2514:EE_
X-Microsoft-Antispam-PRVS: 
	<BN7PR10MB25143DC0B1288D25200EEF20BB2F9@BN7PR10MB2514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PmMLJ/Y+aESr4iIRgmQu2jQUpq1LEkUG7yP8FJUk2vZKLTznIRn52xYrgMys8zVlsCdBxwyDg8IoB+MUFCCeWBu1FoINQ5S4qQYkrgQgdL+vZKc+WgobgVLI2IegDxRI25Ep3dnTtASppIip+J2zuHPfovJdFug4G/ivBfCJFQ6GCAEwL+SxiLDbYTf21IKtieGoxbw+TMPwxG1A1dYJITT7GjXPmwmo0pjTzGTTHO3Qpn3glqvvi+9tDcqvyFrnl5/KgJ8H2VDNBEfi3BDBO0Cm5zOe0qf8oGM3YjaqhFYBogNXNxIHrCv6F8O6/uLJEvVk6hMyklQku8U9kLKcoRSp57rs2PQDlciFgkbGqicc6N/0x6LdjcAJL2G6ConQcDuWEHvf3f063cTgUsDpOGTSkhtgQ+fTo5adXTgksPFgkgJ7g1agQq7NtcPr4pvpOuYAB/8HCxz5aaphj4mAa/MBMGo7AzWzjwsgjVBb2u73Xzy2B6+Qb917d8hC2FgBchSPdUHPOR+vojgVQ9PBxOZy9qu2/WNh5BS1CK0rC08YM2wrnvLqFoxTcQPpA+BsPa/9/ofDSyPUjQe0Wz0tQpVg7cjw2TVL13UogSN7B56quCcGcBuDYpxiYQGESRXBOCeyS9St2envY2wvjmdxPwnSV7kp65DDa5TKVZ42QyHrR8aazO8gJkcoXZYL/yQFBeJUjP1HuU/kVFKJcJZmzA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(103116003)(66946007)(36756003)(66556008)(8676002)(2616005)(8936002)(316002)(7416002)(5660300002)(66476007)(83380400001)(4326008)(186003)(107886003)(26005)(54906003)(6916009)(1076003)(6506007)(2906002)(86362001)(508600001)(38100700002)(52116002)(38350700002)(6666004)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?peCuIl8A+o0fbmaqBZvPMnqx9rNqU2A2oDcrnqFuF9kGy06EDKHXypwWholk?=
 =?us-ascii?Q?oKq5RH59MFrFXXH/8PPHdZOHSOcudS/5MjM2JCA0AoB4ivdud9sxAgBZzcdI?=
 =?us-ascii?Q?fgkoRCwgI56VbY1MdUyGpPkY6jK8MKey8ga3diSwnDpt7tmiU8Hq/FQLsB7Z?=
 =?us-ascii?Q?EmBMA6qmHNXPwe6CotVhUBIzc26LEe9FCWAoFYJPLb6S6IXnsYR//HwAn5TF?=
 =?us-ascii?Q?5nhG0lTlv+hrTxhGU2Qw2AEVpp8HWw1p4imh0otcn3pQa8D1peDacUCecwTk?=
 =?us-ascii?Q?C1DquzZiG0fw5/RUqojcLbI0b0HjeMkxNVkWrekCwipaOSa/2rgvmjcOBk3X?=
 =?us-ascii?Q?9yKEaqkKFNHblkgx1pmLQMDsw0vQdb+22LN2YFb+XhG8qIN8woge/Ec9cRnU?=
 =?us-ascii?Q?Wh//YIAU5kYY/3wmUihhdkB4kjF9wyNPRDbbdR7/3lUAhW2ee0kA9KnybN4W?=
 =?us-ascii?Q?IIFrnhicn/WB6/u+5yqZSqJrykMIeRAw9P69G31j2O9XmnhuwWbxh+0TLd9R?=
 =?us-ascii?Q?wBHD3NO6jbiN4DtaHzS2YUClwdYCR+6l93lTYfIWvvJshiR281p0ecDrVy9T?=
 =?us-ascii?Q?E8+RLeKjmAOp8rv/AwvSuKzKI2UUfDSe0OLkwvb7PUZWajhrWjlrlHd//dZK?=
 =?us-ascii?Q?Q35pgCh6Lkvdra7/l5s4UdZBWRjLGqHdDDe1SD8dXLIDm8x3WRNyUIjZiq3B?=
 =?us-ascii?Q?RM/4zEJeuTHKQ1SJBn/4zNlknaw6SvVDGYwt62YRJWUdno/Zsqt9NeTlr8n8?=
 =?us-ascii?Q?prAY+Q6+xFnvdmYfFF+buW6zRGvAfS4ZXmUgYy8GKXL3vG3g/vlqYX7PXbVx?=
 =?us-ascii?Q?FboFS9pjpJry4C2AyoY7QNmnTp3QPlH5+ahEGWbLGjo+rnvFj0ONdieq1xc4?=
 =?us-ascii?Q?L9jlxmgiUUq82zP6lpI4d5+1th1BuOOCzE/isdyngSBhbG/yE4b/P0NHE4bM?=
 =?us-ascii?Q?auNXQgEbnZ1KAZWsLakXdexVJydvVLFLmwwFFyFlrh28D8zl4sP/i9zUxGO5?=
 =?us-ascii?Q?byI1rsKBGW+Vpip8yQA6saH3z447zSBvzSN5tA+bu+EKKT6J8MKnsE54R8J9?=
 =?us-ascii?Q?l9TtGQBCDqLqa4kdiCITrXLGFhgvvWTSkN1tJ/UHZf4lFoxDsu3CHfnrREli?=
 =?us-ascii?Q?3MASb1vfHCNu1+PZr5YzdyYYXowd/JP8McKOSDcGRQNPyz7oWOSGwFTVVcX1?=
 =?us-ascii?Q?MKRY9oYOmfbw/V10wffcjWwC+JACzKej5VNju7+8fWg/uWbrEjs6BtnoiTKm?=
 =?us-ascii?Q?vj1RvcVBySlVphzryIeK+gpu1iBoqsDSvJxLXeMaRhF8GTirAAdtMu7ggwux?=
 =?us-ascii?Q?NI62MELwM7Xfx7SRt9Ybp9u+bORmd05xl87+kuqTQyzLaNXZ6EyX6k5tmKK9?=
 =?us-ascii?Q?2VoxmAHN4sCf0g3wV2X7VyzwAoRGhMy8ORNAOX2CK/fOUJXDakpDavw43icT?=
 =?us-ascii?Q?Rdtj6aTVY+uYySTKCkgT+u83ZoTQJxZVnfeOtVBsgDirruly4mauST3Hev7m?=
 =?us-ascii?Q?swZd7YG6PL+MbCfmV8uY9zaREOplBa7gcTRepqoeYGH4szDQQ6MhK5JHlvRR?=
 =?us-ascii?Q?fxxWbBkB296gmDTt7Lp8oZjXYJlODclQJojit4SsbMpRNJEfo8lnKL/zTO/m?=
 =?us-ascii?Q?JaWs8EnaIrZCtQ9OmwsIj+a/phViwdhGCIlm3NqYuYECzaTQGKFNlTnCFWGL?=
 =?us-ascii?Q?KTmtJQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9cca63-d450-4351-bbe5-08d9eccc5631
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 19:34:21.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NM8Dgs/AbTzsIPFgENwxdosxb8PfiN1rae3lfZt1030DCUx3rx0GnxdJcvtMvojCSq8vXHa58q/nAEsaDqcaB/1YdSUevS/OyHpiPUMmN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100103
X-Proofpoint-ORIG-GUID: 44neGnJGT_99Olj2MkfcFeqtEFJJhkNH
X-Proofpoint-GUID: 44neGnJGT_99Olj2MkfcFeqtEFJJhkNH

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
unique struct pages is a lot smaller that the total amount of struct
pages being mapped.

The altmap path is left alone since it does not support memory savings
based on compound pages devmap.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/page_alloc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cface1d38093..c10df2fd0ec2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6666,6 +6666,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
+	return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
+}
+
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -6730,7 +6744,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.2

