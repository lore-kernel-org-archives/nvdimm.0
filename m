Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492336D2B
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:06 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIZal2004683;
	Thu, 17 Jun 2021 18:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=h4oUpIC84MOA73I32hlt5/11IyNT7LrSD6rSEUoSg5w=;
 b=En1HLGr1VhFocaQMWA6TjNtLXKCXrEG7QmfRDl2iIZxNlIgQDqmq1/9DoxQsh1qsFK5C
 mVROdP3IY4J2U8MdGUt0S8u5+ESkleH9VT915TT9m2FMcDYJiwrdF7ubbwmAetYc0BuZ
 RZR8u2fe0Wn352Ly9JE5mRLCiIRZg4go3VzrTCKedMSK4cd9ai8a7KK2BuVRARnQZ1K6
 SnbJwgF1XcSrZldi5GfDNBNSxdWSVhhAN5Bfe8Xgj2wzbDjl1k8NNwi0k0um//BHvAVB
 H7fRasiNgUHe328uxcqUkXizWfuulUyC9eF4eJ1AfbvPDfgg9ZjUTrY/ZhyGH5We/g0N oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39893qrcfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIiudu160858;
	Thu, 17 Jun 2021 18:45:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by userp3030.oracle.com with ESMTP id 396waqf6x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hErx+VhZxcbZTjKbVwB47xOde/DFZ4LBzpiJ5X9do5PVXAWYqmSKreQ1CHVji+ADF2Pk/6TsEMyGBh4QaUXVBtcfu7gjxk/mOQFS1IPONhUUFnmsT7cXYDBWPraSOdoigq5/F+DH8LcSYxB+Hur0ljJMB/35/sVmhI5woRuu6Ts6xIYTUBIC2bwZXm0zpT4BhGmorNk7DwjJa+7H3Z0epTU96NLXE/tSGQzNy0TWJ994xSUFVyuc06y8v9mLob6LFPMrtELuS0NrctKpgKnsGFzvNM5xb+D7kzIUUx7X0e6Zt/Vhtv8QW0pQKE3we5Y6R7zdlSTxmckBYZaQ94yt1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4oUpIC84MOA73I32hlt5/11IyNT7LrSD6rSEUoSg5w=;
 b=GBHhS4gHEnUFpJGmY5ZbqjKSbRNOfnlv8hhIs0loclEq9z9C3ybnOUleJcTW5EccxPcpGYPA77976FXaB++/ZPVlgU6a/eriS2nk4YbrqZIKmujONZUctCiSB3rSUoLTxPWwgns/k5YHm9P62BrMoEfVjKIUFzNPzwrIW8dfFlp3sFIBFibMbfM0hdYzH1AfHzdXB8a4srrJO8ZU3SGDRzMM3oHpH5/iFbU5MjrXqAvXM9jlrZaF8ItZagkpocPcpKYKLX53F+XUvdAMOxGlQgtxLPsjtIdIC6LHWT1P2OklurJFum9Gb7N12MchThNG3Q4I3oxK6m5GTVgP2LKl+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4oUpIC84MOA73I32hlt5/11IyNT7LrSD6rSEUoSg5w=;
 b=tL2CV437eQZpDCYFXI+2XfLK3GXtmck4KP8OLvixlIcAxwyEybb/w7Aj57appgvkuDXSNHhqhadnZJZFFR7IrxqNkYlD6t7rvlcVfg/0JrPyAqFYoGOcBGAkLsau73kjAD/8SccNgR7H2uZj/CYL5mqbulU3AwZvQNqSjTF+2ns=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2913.namprd10.prod.outlook.com (2603:10b6:208:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 18:45:48 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:48 +0000
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
Subject: [PATCH v2 09/14] mm/page_alloc: reuse tail struct pages for compound pagemaps
Date: Thu, 17 Jun 2021 19:45:02 +0100
Message-Id: <20210617184507.3662-10-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6cb6b75-86b0-4f9b-2b7b-08d931c01f62
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB2913B495F79DFF03C1F7009BBB0E9@BL0PR10MB2913.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	M9lAJS0g7QhBnHWmtkPYjCyQyRkRiMsb2mVyBLzhsSOHJeT4gb12iHBGa30OU8KA8Ysm6KGW34z2QxqFyhIUv7w8A4ewv+RjAE6UZeVOyMGzhWquMHQgJnE1Ygh84LF2R/PnZLsrZZAV7KLTDaXbskAibXV9rICU2sjEn5k04Iu0uHU9SicN7E0uoiVVItT2SgkmFotHmjZTb1xs5gsfeeiRY5XrwRp6rsLae6i7n5QZRdMtr6grMm32JxPqMGqXX9k5NBML30LF/cFT7mkKjXnJ0N8C/+ShQa2zEc4y/iWQOUIlOXpl4f1fsyZjdOlahde1+BOom9z1Plvz2dmD6nTUu7r5BWlNoq9Ad5+3m90FkKdV0f9UyX62F7w6uyzOM+4Xy6orJIlkH4uPThdp8V0voxdbzijQ9Uru3BlaZ4vxMDrIzyLIpT3gp69TQH6Az91KIv6DxebnPFiIogEfGiWaEVUJyaIWxwK4G26IbcFGWPZc1DB52UlnBV57HpaAASGYLgSyow4xsW1jsip/dEFj9ge2HvqHAoUyu6cdEViTsdf3hVSZqofmn2H1YkaBLRNkeFaPItbtPP8dwNhbzDb1LKMN3kIHSMqp4k6HUi80nljIXaD4l4zDPRLltgLgcLwatNKQDXlBguiUfrXzng==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(478600001)(16526019)(66556008)(52116002)(66476007)(38350700002)(86362001)(4326008)(38100700002)(186003)(36756003)(7416002)(6486002)(54906003)(8936002)(26005)(83380400001)(2616005)(6666004)(8676002)(7696005)(5660300002)(103116003)(316002)(2906002)(956004)(6916009)(107886003)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?oCJr+sIe4VvV8zzyuryMm94HDTSLsT3lvIoCNXe3vpk1KAvDk75QrHg72OFH?=
 =?us-ascii?Q?JrUwahX+zlRZVWIkJHgDZVkhr5ZAosflHDN+IOBfrkT9K6fCqmvIws8mpmKG?=
 =?us-ascii?Q?3+Vybb+SLrsPgvAzutvB8y8nXPcaIVSGOD3GUrmlvfWP3uMgG7AOMr1SR7yo?=
 =?us-ascii?Q?C6NYWJmh9pCBIWNREaD3imox39iRnq2GATmVJPZ4laIzutwkEdQwO0YOMVWM?=
 =?us-ascii?Q?BTWskjLWmSVPpFe8bwp7s5VrhHi6MWS1r+4YZI/WTl09dRc5xgHnX8R/7f5C?=
 =?us-ascii?Q?hW1XGAbKsO4eYgtg/SHnUrC7NP6hdVWC/puLkjqAKDdI8n2dzb3nxgtwpgfo?=
 =?us-ascii?Q?QAma9qLBROUyfRDe904uhUjesHIUc5bBUyqQ5nARCIetkfhb0NTP53UrM1Et?=
 =?us-ascii?Q?Ojj0hXT6RUQOfVpPECahuI1xhAMOw/SiXYhARPFPA10nRbEr5I9eibNaFO9v?=
 =?us-ascii?Q?5dkAps35TkXSXXtl8dzWo//ctx/z4+oacmDxqLL9kRM62yuNcYJkRM9Hu0zR?=
 =?us-ascii?Q?G3fJqNVCANBhD0VJk+5uQqUavfRAElTam/QqaPJqB5othZJLzHWANF77cwE3?=
 =?us-ascii?Q?r0qF8VGtusF6EbxKMsBaGmbH4+WEAfqmMYMySHLm3nH8A9VQaVvb15CMKpQ/?=
 =?us-ascii?Q?X15mWC89TMJeANhmYTvSz6mdz4yZOPuUhg97XLeW63ygvkPqVKPmcf7RVR4h?=
 =?us-ascii?Q?kCK59YNoM63rc80FzduD0Z2CI0RJJJ4lXZiDqDkXUj73JUZsY6OMtP6+o1Fx?=
 =?us-ascii?Q?2XkAJvPC9yXs8GJPkjuhcxLBlIVtwzg8aOVsZh1yz+nPocwTL/4stgYnh3YO?=
 =?us-ascii?Q?q6LdX+Xa9aU5ZyXjrfaQaeJ5yNosyI1987luwwfA5GwQEuYErFua6WzVIwa3?=
 =?us-ascii?Q?/ukwwS72PYvUe0+YL9h5DLTRiszhXsfsk6a7iKMzAgFtd0l8e487UPBp2iv5?=
 =?us-ascii?Q?7mBCLldC19N66PeIF6arpiybYu/CV5jbFvQP/DEp9leO58aSSiTa4SslrFZK?=
 =?us-ascii?Q?qnnKgWxzUfDvcmNYpKOjJQwAJJrmlh/xZc4vIQHLaeXRGoz2UkEcdj3kFBF6?=
 =?us-ascii?Q?hPDkpK80f+2nOTFuHiPPOpw2cRt56bgOvmAY1WMjoAWCqAbXpFQ2vaEBjlJ/?=
 =?us-ascii?Q?4Cbz6dcTv7hqDDMQNlZCQbmBqxKW+Oq48iVTdejtpoDy0VL+krNUDfqFM2BZ?=
 =?us-ascii?Q?Bf3FNg87Y5vTI9dKCmKLATEQIEvtNnyp8sW/ij/Aagra8JPbrgzUumpElhnp?=
 =?us-ascii?Q?IdatlDmjJym4BEiVnO8+eFPVPv8tjF2oVQnWAgyYP9WBxpiCOwnzFl0NRKoj?=
 =?us-ascii?Q?WpNdI9fTtB4GhZWllSvq0Y0Z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cb6b75-86b0-4f9b-2b7b-08d931c01f62
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:48.1218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2jZYt5RQ+4gYruqoNdkDfYjbaAzA2AfySt3D5VWx3Do/67cV6nAuTq2WGmPo/ZW893Us0cxFagPUFJnR36wj7rETME1DvbtrWcyFYevWGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: crXw_IrK-WZYqnhCWtvz-7I974ybnDTt
X-Proofpoint-GUID: crXw_IrK-WZYqnhCWtvz-7I974ybnDTt

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
index 42611c206d0a..cf4c2cd32874 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6608,11 +6608,23 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
@@ -6665,7 +6677,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     altmap, pfns_per_compound);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-- 
2.17.1

