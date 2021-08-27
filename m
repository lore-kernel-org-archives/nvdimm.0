Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4DF3FC3
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:22 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWLhq024915;
	Fri, 27 Aug 2021 14:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iywGmSUorxPiMyQNTM8KoFlTm/4AjDxqck3CR3VAoR4=;
 b=04uwW1Glv2DR7nGaAwn8vC2iH5XbUYqqy5lSo5vPN+/KM6XTca2huBl52H71V3RY9GHD
 P7zpLOISAVLyspAj/FcdjHIbk9+SltmuswoQ/P7JfNr5yBWw6x2hA5hpJt83sN2TeRIF
 5Rm86sLfEgoCkKboxXbylwXZOVPdqgpV+Kf/TrFX6SBMq+3YlnJkWvy4Z61ZanUIPQTn
 woS/3r5WV4STNMAu4x9r6UeXmgbUIG0JGtfLFsL4G5teiXnXpEpp/Ej/Aak/4EE/k22V
 DhiCdquPUF6VQF9Rk2A5yTXJQprHeNoKEZubQGWjOLBtmNylWLDWBLT9gLQlq9MAWVVL 9w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=iywGmSUorxPiMyQNTM8KoFlTm/4AjDxqck3CR3VAoR4=;
 b=jMKIhew5M7zqMj9a+b+tkvxXmY4CMhWaAPa0J8eruxDUJVimRCM10nAFUifCd+bsIqHz
 xBc2Vfx/9i84SwO8wHZWteKlea/glIG70ScYr3QAq4C0B1GZBZxqvzd2b9NpP9m2sYLE
 t4MuHJShHRii5settOoGrkTRUCYZpTDsM5yQ1Kha1JzUSR26YDf/FejbhyLNnFZJxZq6
 W6qtqLFtVWItyxyepQVOt5VJucZ0uKS00A8XwpUCgGXYeJpPaqLpSeCTsHc05+ZC8DlE
 pwL6MHUoz2JsVw5PKB6vPvWiqqdqmIBQAd4IN9jhJfMlY3/pQcX6PnGbAokV1o1Qowrz 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4xv3s1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpQK4187244;
	Fri, 27 Aug 2021 14:58:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by aserp3020.oracle.com with ESMTP id 3ajsabbq91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxW92oMgKSxRJnQxq6qooaJ/qN8YejJM+B0Cjc3aNMrWtdPnVo5RTpPEvRpEHHtdbRpXHi6+fXiOh+1hyk72kFWqv8V83KIv7yTitwgqBvP/aPYlA8OeDSQjQj3gAntASRS0cjz2kiHTCrVE2TnPZrOE5YYIKN+Vqec/pmwG3/TCC/lX8zkTmb3cok1f/zFhyIJ9aKSOLt7aiSoU9J+zHuc0diUjCLeNB76FmK/mtDJKfjdpicDqTdwyQtKWksu8hNzui4p1XQ370CcJSMQER/Y+9/aAFwYllkWtG6eR9nwytUpnYeGlE/Jp2eCK04qSrLmBtTu9kloKiCaanKaZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iywGmSUorxPiMyQNTM8KoFlTm/4AjDxqck3CR3VAoR4=;
 b=fERn7xQ8oYET1xSFNZtE2TiCUrXnO0kg3pnFW8RnfwP8qJNc8b/VCuIDeHKgcYrmXFow8m0KSFC/Dkq/6bQkb4suH5UnNjsr1IpiJ9crDpYySbRwPVriyr8vDszZsX4WDEM+OUngvaVk9tullj7kgvxe1NTyB6yDSFrttBQGvimE8yxLOn4gc2CgKb46fqWOWVpGk3+Lc7NExx9QXoSKzGGJdbfnhqmgn3g9kHbtv1hRRRNAW28/obMyL1rQZqZq75AzocSrqsvod8YnUlNUByoh9lY8NTqRIYkcThakPfmCjo9VuLMoBiCv24ShrAOiv47abv0cD+U8dstzg+K/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iywGmSUorxPiMyQNTM8KoFlTm/4AjDxqck3CR3VAoR4=;
 b=fPgMlCSxCDFLzvXVNJ0cvCbS55q+fMus5oRtPOvBz8+F+krRtN16tPGZrBYTG8DmtFPIKB8FC+JNN81eA8F8qHIzBtijGb/GcnD0SK2xRrzSjYtpzL/zMi4lQQXHoKowoZxmzc7nlw6xa2iSxwAmPO7ouZ+sn4OpAFS4JXex/3w=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 14:58:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:58:41 +0000
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
Subject: [PATCH v4 01/14] memory-failure: fetch compound_head after pgmap_pfn_valid()
Date: Fri, 27 Aug 2021 15:58:06 +0100
Message-Id: <20210827145819.16471-2-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2818fe2f-6bb1-495c-85f1-08d9696b2872
X-MS-TrafficTypeDiagnostic: BLAPR10MB5025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB50250F13CF09FE2765BAC645BBC89@BLAPR10MB5025.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jbsI2vFMURiQEeu/HeiXNqCDrgpShE8IE84Or5xDOXyHYE2hbv7ht18YdrIcDSozVQ5j7/lqYVnkiCq96mkCtXPkd2XUuZUTOim6r7e+QWsjnoDDsfGSL0Ms0AtZ8QbkszA+BKcRUokEyhFSJYdKM5avNdfrqCveG+BBy5yYiZfPxm/6BEzjWyZa2BjJ7W9JaUxAIleNfldd+HiKJlycUSW08izDJyrnua1z6GKcFi+eBqKrLCwxwynuGYmg13VH7ILEle2vKuBhscXC9a7w94aS/TywshqU5RyQMIr1Yy8+1fE/bWSozAJA+pz4pFa6Y+RiU/Nwh8CC2BU2IrO/RipDGpy/fHRGL1KUc49998ZNF1ib+WyoA0TlMDlNlRC7mGTi8PfKRcAXI25c9qfo0eZkolZG/LFUj5bcdsPTrTOXJbJB34Na2kVEXZN5oQd0ZgW0K9aXhiBbBqxXFkGQUjTdQp58We1HQ71yr293ipip2EEm1F417OJJZW0La1Z0VWL0VGkYht8bQ1+xvHQbeBcyd3Ln4Zek6shJzr7ZfElqYxB8kJLOaP6cUJiBgWHP3KCwpt0vZA9ISnq6SkRGy92E6DyB9d4tbMjFlMKuzSLjS9F6rJZMHHMXPPnn+TJfojUj0xi3IYhdcfywyHm77XKe34misk1xVCGwdHdBmoGKq1pfhmpzMx+6bvdV8/minChzXtCDhM4ZQG1NDb2tIw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(103116003)(66946007)(83380400001)(66476007)(86362001)(54906003)(6916009)(6666004)(6486002)(2906002)(1076003)(107886003)(8676002)(186003)(4326008)(38350700002)(5660300002)(956004)(26005)(66556008)(52116002)(7696005)(8936002)(36756003)(2616005)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?IBGZP44k9ImKNnhHRV8gIw1rKXiZB+YQwOlQiVb/5qcvO2WHHZBbwzvFqy7Q?=
 =?us-ascii?Q?eh1NkGA2nC3dzjvmYNmwK7IEUa4E57OQx8INWMBfm2cSEacQ15Iw1nyBSP6Q?=
 =?us-ascii?Q?tsV4QAbznSK2LUP48kpSgsLo+VjYeHJungiq1ilY91C+rsceh8sEIAXx0rmZ?=
 =?us-ascii?Q?WPayT8HqR9AtVn8sTQuM3cit/qr+kKyNmmWTVSxIH6i0jI+7cNfB/PnDRqmW?=
 =?us-ascii?Q?PGVDsIVPGY+I6HZUVHh+JNQbqxP300OK41vjrXaSwxJqqC8AFXXh9fJBuvXr?=
 =?us-ascii?Q?J/KaS/1A/GHS1s8QqeWikY+M9vZXOQJAPTSvg9jQ648vYt8bu7EsFqCgaFx0?=
 =?us-ascii?Q?N89MYp1krOGgxV3a2wlFiOt2frSJQCItzUcE5HR1HJ1DIz7iJoA5Zj7qIUIL?=
 =?us-ascii?Q?4SzIgW79fBjTBM/BoK64FKcZ3JcY2O56Qv9r+vH3IJ0XkK5I4bSwDDFwiswf?=
 =?us-ascii?Q?SDijaZX0a3LlsoDgUTLQpz9mxuhKoSarm7e6j5uq1Ibn5ecLRMznFzyvc4/h?=
 =?us-ascii?Q?bZGULJfvDR5FlWHRXaGMayZQjECXWUEZ9g2djY5nBEuUanm/gynavCr1vyXT?=
 =?us-ascii?Q?lQyzcqMYXB+lmmhFRvTAcIKUlN89tQckRgOPm1AnRDBC1AJSrtaSs9TAmPDN?=
 =?us-ascii?Q?z1F/UBEXlo/kMp3EwiqXgQ97U0XkyuwjCTqxP46x39BKUw2bBqoydCgiuCuq?=
 =?us-ascii?Q?EvqffbMBUP+oGu6s4uPHUzI6cUb0aIwqLdHH6TapVdPIGFBSTGNPlS6ndtue?=
 =?us-ascii?Q?Kr0XZIVdDCIxsvW3BaadvDIJ1O2L7mqKRL43UBgZbsQz4xkSbM8bWBMUZxA/?=
 =?us-ascii?Q?f4S5mO7GWbBw+whMs+GKWWZARPkon9JkuePHwBolsEidylyJOqWti3iLLhZm?=
 =?us-ascii?Q?pCJqEJ5y4F2MGA07ZD5qyBDlHNsxej0KtisZqKPOUzo/wArDu9M3rYX2BD5H?=
 =?us-ascii?Q?TuJ8pxr8aayulINhDeSat2rOBwxSaBCtGx2AlT4NEV56akp7DFZTqkViD6M+?=
 =?us-ascii?Q?tFcPYm/ARGIvegBDoIyMoQrWqxOvoeafG1ygqs4xzH7EvV6viRZARfb/lBM4?=
 =?us-ascii?Q?mOiR4YT+aDhvO50MZSDhw305QOgBTfIJ1xfmj1MlNXFq7JUXusICgzZRTdZq?=
 =?us-ascii?Q?OyPb82iJrbq2xUDSwoC4B21KA66HwrIYbhyDeMdqbBg4lZDc6HmwnYsnRkzF?=
 =?us-ascii?Q?2Pfbi5+ZUn5uqV8l6kBAV5hY0SSN0AgTVN0feXgrZNV2ZM8n14OO1JJmNIbl?=
 =?us-ascii?Q?35SG54WYzCRxj/MkOWBnMA4l1N4aLd5cdXQnTUERb725mS8On1Buv0ufOy90?=
 =?us-ascii?Q?kUsFXeja6EYJXwaTcEdopCG1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2818fe2f-6bb1-495c-85f1-08d9696b2872
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:58:41.3126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AC6WS3ORmXNTsiFuTP7QIsQBj0jPmHDJoqqPJ1hJ1AxaRRAwTVyklmRhnaZDJE7JHL6nWoruRPdn1VkVhgDZ+9iOBIROfLqvkNXlHLMnq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270092
X-Proofpoint-ORIG-GUID: r0ZnmbRoSOQ1xyHUHiZcjCrnuOrKJTP4
X-Proofpoint-GUID: r0ZnmbRoSOQ1xyHUHiZcjCrnuOrKJTP4

memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
dax_lock_page()).  For devmap with compound pages fetch the
compound_head in case a tail page memory failure is being handled.

Currently this is a nop, but in the advent of compound pages in
dev_pagemap it allows memory_failure_dev_pagemap() to keep working.

Reported-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memory-failure.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 60df8fcd0444..beee19a5aa0f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1538,6 +1538,12 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		goto out;
 	}
 
+	/*
+	 * Pages instantiated by device-dax (not filesystem-dax)
+	 * may be compound pages.
+	 */
+	page = compound_head(page);
+
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
-- 
2.17.1

