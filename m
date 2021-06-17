Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6BE6D11
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:06 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIav0Q007622;
	Thu, 17 Jun 2021 18:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=eItdugg6FcfLnkv9zYSPCFwM/aIL01iwtGtFBoCYk6k=;
 b=oGrTslbVnufsIXdP2rpPqBgSejm8a+wXnPRQakegOb3I8sDJnS/4fgTDhMAQo31qQlH0
 ppc8yzM/lQLL97WZ3NsVzh9sdhrwWOtv3wwDq1G5HBOYdOlg2OjQ/37Wzttz0NGKZmfq
 aEYaMRGfo54Yyx+gJSin/ofSPW5rFUQoiWCcyA/kWwaq0s7qBMFrUNTbHm+/+6Wp1hbb
 SRA66w3ReLSmLaJzNC2nvdeMg6OYRkiHOdxbdDy3QqYb8UklRiQ1RQslp4lFdJ/PPmYj
 k8L3ymFq+B6hjfive+uTsuCWkpGN1BYmBS6xIfxAn4Vnm6wO/pOHykd2U2N2E8Fi5A7G dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 397w1y1r7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjbNk180431;
	Thu, 17 Jun 2021 18:45:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by userp3020.oracle.com with ESMTP id 396waxy699-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:45:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jb9BdFmTqF2ythukq6ZrBLBHWfSu7ee0vqiNfi2kcVfid6Che2/uXltKv+tre1ryhQlCHm4EE7PSsB2WmtGbtqbYJqu15jR2jqX9v8GBlXvi0QmCCtrkwjHilq147wQn3+0wOBq1V85ZH2nGcBQ1BnJcIa11hDc3+bkWexAGqDvjK1341Tl8NvdPrVVtdj2qNUwkEnDt7z479vdiLm7KRcX/WgvFNC0Wy5UTaNdzpha4MISEBFKC699woBAsVyzZ+qej9z2wvZ76y4iop9jTxCpynJ+Fb0mT7LtKYsotgqLmrRGo+O7AlAX3XU3PAhumgyzn5m0Wy3/iHHzW6cqLsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eItdugg6FcfLnkv9zYSPCFwM/aIL01iwtGtFBoCYk6k=;
 b=l88yNZrIn0VgQbw0WS9KgaHPBX5jA+g0z0xAtqRWG9qb1k/U0nAH8TV6V/4BMtYrDrB6n2e90mEJPxKgYxQV060AiOpu1VpjDEvpvHzjwjVvmEBf4/giy9ZLojlv6GFoYSZpPqN0Xl+JHfAo7kfhRH6nYwn3sbX0dQm66wu9juwYt272JP/slc2QewZs4jbs7qwVPsAgyJg5DoC+0L84T+Lou74lM3fywUr71FO9Z6GmUfSl4NCaxHF9PKcJdk6SiZUgN1Zjdovk8GquUntZxGsafzRj+5Wdj7iUd8W4gsXcN9EzakziypZpfSztKyWpxUcNn5gGMDFQhO7VVlYaZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eItdugg6FcfLnkv9zYSPCFwM/aIL01iwtGtFBoCYk6k=;
 b=KreOZcZnJgIokuWfuBTOKDU7E2zQsQw2NswZH0hG1qvSGwhfdFSsgQoryu6iP6b8ctJtKXlP2P1PMyBtCRBWyAlQ4SbXuIfF+Y/z2Vr1+yTI8XtLpxcMy7VPBid2qUaRDqqIU/7jTosrpMOmJRpAsSPOtCrhmO06EfTdXPMeR5Q=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2913.namprd10.prod.outlook.com (2603:10b6:208:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 18:45:56 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:56 +0000
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
Subject: [PATCH v2 12/14] device-dax: compound pagemap support
Date: Thu, 17 Jun 2021 19:45:05 +0100
Message-Id: <20210617184507.3662-13-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18e6dd22-fc3e-476a-0287-08d931c0243f
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB29139690417AA24174608646BB0E9@BL0PR10MB2913.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dJ99YG+/8N14x7c8trSoo9wBX+6lrxB9nIeV2lARI0yM1yHqnAOeVjK4oQLNoPfj+VdCIX8ve8ZGF4exxfZk1RniAehOVDXLqaEAmcype/uWfSwCGfFt1Z4vc8R+ufuqf5aJX7gQHN5D2pS384WRZtv0Fs4nPtcKxYCjBP7eR951prMN803AEtp31CDVK42ZBWRnCX4z4rb+dBhZ7g8r3gOUmjThHzE7d1LVe+Ktvwgwf6N2HPmndewlbLlzL0A+uiNjdveK6run/IYHH+MVZSfyIykeq3ZVSNn6sD+mj9u0HXh/WppD8KFY1AULvj8IfNCZzc5L3VdWCrskdCCfSgP8kHaZgPpnxqYdJ23BHs2bgwjSx9tbYu6yhNrNoosXIJUIO4s6cI/VDuM/Vdp7boQiQ2qhxsZsK5wCRsXYf92TLnGUNaQAVuov0Im3es948HxRz6c0MZ9bjgq7Sh13nAuYtbATH7bq/PtWPlNuuGQz3zZFDfPm6bliUvGwqk6GHDAfqY1V94G4DHaGzFVIPE0YtZsCnw+7fNNKFYYAG4Xa6fmhWex3+MvpMoz+DrS2ex2T0UK0Gk1X5QoWY+gldI589KlS3Ol6M5isGL1XsqP53saALnsplGa7opWi4uq0UCdFQoWNjmfEFhc+U1q1p1LAITtMtN6IzuUTxypLEvs=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(478600001)(16526019)(66556008)(52116002)(66476007)(38350700002)(86362001)(4326008)(38100700002)(186003)(36756003)(7416002)(6486002)(54906003)(8936002)(26005)(83380400001)(2616005)(6666004)(8676002)(7696005)(5660300002)(103116003)(316002)(2906002)(956004)(6916009)(107886003)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?P3HHfNyXtvHsAzNruSlXj8i2REaCq0tj2PGesL/dhmWduEGLMwwo8XCL8HCD?=
 =?us-ascii?Q?a3McGo1o9NfLXy8Bmb45SSkgS2iggaclljzcdMTzL8YzxO0BFM5dZgnBSqMk?=
 =?us-ascii?Q?C51xhBZK/xehFQy0YDBq03MsDL8OgtykcGZLCveqIbsTV8YMVyI8PnuQr+uU?=
 =?us-ascii?Q?WrHjDCEOSMI5huWgarnKh58Lco7oJxLmLE9NI5r0Pmd1twavwOLOdf6uY/Rp?=
 =?us-ascii?Q?bTFasBLzs8L2/7XtSGPSM1+mBTzu9/gQMwUma2m16HiDJZlroa2MUZfMHBLd?=
 =?us-ascii?Q?NrDyED+TsCSbrqNN8YcrgtyJ+1KBSqiwz6Xwm8ydqADaKtaUFZ8A5MYAjSyx?=
 =?us-ascii?Q?PIJfNv35FKS1nKrCX1cBhUEQNGLMFT+QmsOZlnPCbXF2o6BThrbtLrnFvKpc?=
 =?us-ascii?Q?Z7yn5qn8XF/oDU21MmGQAfpyePbQbO6Mki9okznoV/teErrQTALowIy8nfL+?=
 =?us-ascii?Q?aOYTh9woVYqeyWwwWAEIjf3Cu1taV9MqFLbhC98sz3+3RBHFjaWoNEMY4eI0?=
 =?us-ascii?Q?YrquDS8gs645ETpr/AoOmXopqOlZ9TgHzlSaMPMCJynzLkTm0tWQ0nXE2Mml?=
 =?us-ascii?Q?3RzJjQQw90jSTh0twCoXmyB6I6BIQJzxXw4GwUac074M1Nx6rtE7DB875oVn?=
 =?us-ascii?Q?fPzMI7E6zCJKZ2b23Gbb1n2821BBAKrh/h0HpLUMyBUnCJ0qyJlrtppILrsh?=
 =?us-ascii?Q?1hnfHpSF+6umqAsV8UI9lRvTx8xIH+nfQjPThuANZ5lM1+JR2hnQmiHkK3CU?=
 =?us-ascii?Q?SL24uo5OBHL74qOj49ecYLVQD3RJTZLVB989+mBqVNTo9EAe/lXpWYEqnnlh?=
 =?us-ascii?Q?1coZQSVZnbBulZeNI4PENCsYnpGCKPA6jppOCY6g/8c1OMZ3N9Wed5LkZLPP?=
 =?us-ascii?Q?JN9f7arjI/PVmP6jn9iipS9EUxjGiviWSt9i9io+jmzTHgX5e6kwRcSsr9bP?=
 =?us-ascii?Q?T30fS+bnp9DSCDL77n979x+1VJoEm5lRZbiEo2eUSN8/3PWNVck2grcYvfft?=
 =?us-ascii?Q?QGCm9n8UGfaYxypb5DXdV+PwGub5h0p411R5v+vA4rJPoi2CQa/sgtZiGBaU?=
 =?us-ascii?Q?lU2uTz+JGVXvHf8MuaJXMbOmlCofIL7zV9U4UsPsKPdE94WV2FfC/vVEUJ80?=
 =?us-ascii?Q?UvThV8kypZ69KkLbVxdeyhIrhf+qmvMNVcsK/4rYoLlAOVgV4X5bEMekCKU6?=
 =?us-ascii?Q?yaOxKrd+I6xpn15KL2z70Jq+i0lE6BVfZgETV+J3cB+gbolwAhvDguKbfiXc?=
 =?us-ascii?Q?xsM9BITM82xEXFjYLGvCaXcI8Q1ELHtNl3F1WimkRmNXXmg42LNtKTtorkUU?=
 =?us-ascii?Q?lpj3m+AgnpqgXK7HgMwCxFgT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e6dd22-fc3e-476a-0287-08d931c0243f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:56.3238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2G6pX6PXxSZC2L8A6KBDa4mRaMsP54nV0ea8JpjUfsPT+CA81aV+miAFrcZ6KA0OLV+NskzZ9cBHlyebJAkEgXNlHhL8TjXrM2l0316kJpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: -c3ovvukEtzqwovRSNE02twDLNcx_1_9
X-Proofpoint-GUID: -c3ovvukEtzqwovRSNE02twDLNcx_1_9

Use the newly added compound pagemap facility which maps the assigned dax
ranges as compound pages at a page size of @align. Currently, this means,
that region/namespace bootstrap would take considerably less, given that
you would initialize considerably less pages.

On setups with 128G NVDIMMs the initialization with DRAM stored struct
pages improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less
than a 1msec with 1G pages.

dax devices are created with a fixed @align (huge page size) which is
enforced through as well at mmap() of the device. Faults, consequently
happen too at the specified @align specified at the creation, and those
don't change through out dax device lifetime. MCEs poisons a whole dax
huge page, as well as splits occurring at the configured page size.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 56 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 6e348b5f9d45..149627c922cc 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 }
 #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
+static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
+			     unsigned long fault_size,
+			     struct address_space *f_mapping)
+{
+	unsigned long i;
+	pgoff_t pgoff;
+
+	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
+
+	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
+		struct page *page;
+
+		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+		if (page->mapping)
+			continue;
+		page->mapping = f_mapping;
+		page->index = pgoff + i;
+	}
+}
+
+static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
+				 unsigned long fault_size,
+				 struct address_space *f_mapping)
+{
+	struct page *head;
+
+	head = pfn_to_page(pfn_t_to_pfn(pfn));
+	head = compound_head(head);
+	if (head->mapping)
+		return;
+
+	head->mapping = f_mapping;
+	head->index = linear_page_index(vmf->vma,
+			ALIGN(vmf->address, fault_size));
+}
+
 static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
@@ -225,8 +261,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	}
 
 	if (rc == VM_FAULT_NOPAGE) {
-		unsigned long i;
-		pgoff_t pgoff;
+		struct dev_pagemap *pgmap = dev_dax->pgmap;
 
 		/*
 		 * In the device-dax case the only possibility for a
@@ -234,17 +269,10 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
-		pgoff = linear_page_index(vmf->vma,
-				ALIGN(vmf->address, fault_size));
-		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
-			struct page *page;
-
-			page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-			if (page->mapping)
-				continue;
-			page->mapping = filp->f_mapping;
-			page->index = pgoff + i;
-		}
+		if (pgmap_geometry(pgmap) > PAGE_SIZE)
+			set_compound_mapping(vmf, pfn, fault_size, filp->f_mapping);
+		else
+			set_page_mapping(vmf, pfn, fault_size, filp->f_mapping);
 	}
 	dax_read_unlock(id);
 
@@ -426,6 +454,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	if (dev_dax->align > PAGE_SIZE)
+		pgmap->geometry = dev_dax->align;
 	dev_dax->pgmap = pgmap;
 
 	addr = devm_memremap_pages(dev, pgmap);
-- 
2.17.1

