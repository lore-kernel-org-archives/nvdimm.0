Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F002CAB
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:20 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KP5XR019803;
	Thu, 2 Dec 2021 20:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Pew2mxU+sAsmKJle5Hl2pyvwyQTkMrQLauVDtE4DxlA=;
 b=gMVbDO6ZPO6WbZXkRQCXRau+U5tGMhz93ST2tJsdXHKnrY/+0JIV72As2hVDRajwaqjf
 OdID4DrV8FN7JIapYffG/OwPEuy7/ruMX2TW4+Himc/X8q9F2zwXmou+K7SBJ8wSyYUY
 UdXXQC7tRNLz+sVm1uuOpMZ0oflte9GGkigF9EQKhMgbheB1aTnZ5xo1jRim8dZrNJGv
 JI6vi7/FHdrQ/a/eNsjbUQ8kc3Dw4hBqg3JtaBdoTTvKCmyMI3c7UhSDXfg2tTEptxkH
 2eV/aG/qAGA174aOwmqPVamU9oaN0q5a5u50z+Krn7QtK/F6Q2w211OyMPvKwsax2QSf VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp7weud6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KeuWE121646;
	Thu, 2 Dec 2021 20:45:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by userp3030.oracle.com with ESMTP id 3ck9t4v59a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo+XKzoo6wiGWW6PEyFLNZ0sIs8fSkhBsqNDwrSlpQNtrR4uF3UKfkwnLnLTwlQMEB3qPJC0D01MCUJXn79JPt0hbWcAHEuZnBkEKIj/QSZFXMabma5t5N/Mz8FPnGw5FgHxloq3jVJ8+e2paHFQqM6N3Vyuzbz6S+9N9fSTYzaZYOoTiGD+BBIiOpRK3xRd//7PjW3rR8DqHL4oLqLP2oe6wAZ8NNXJ29vQRuzDBgOU5x1LaMHESC9LmBctMEprZC1fGDuLzTGDsrnDLO7o6muSxJnOKjQPVNiLb+CyNkU2KmG7TUfvb1suNjsj8VX9PWPA4VmLTazxWYjny5CxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pew2mxU+sAsmKJle5Hl2pyvwyQTkMrQLauVDtE4DxlA=;
 b=hJInDDZKq+fVKFK9St0qNgCCFFNe1n/sJ3T/I2wjrUGk7XQcpRgp99kWvyS5k58OE3nrJ+7UF3C2fv+uwKCHv+5q4spv7tWULW0qj0R2wOWt1J+qWHfQSiqipFBT5O8Pid5rpNWhmotzvY7G8jMkILQfix838GY5kcfisXVPDiBnv+bY9Zdj2iOfuxoXb5f0RhGmZYclWkPwnWlohiSQLdTehGTDgvdJq5BBUrsrWkkp7b4UJFfHnbYdh48eoc0f4uyWSnTX29D7qmAX/mxWxsbYTKxYyRrMXLVAS0cIma5NxofqCHjd3H0MTtlzUXXsqN77BtaEhAKwTM9FHFvDuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pew2mxU+sAsmKJle5Hl2pyvwyQTkMrQLauVDtE4DxlA=;
 b=ZplXFQ2Af+N0Qoj5/e/SM9FOn8KmvRIovdaisy+8EHkX4vjTYr3ny1njXc4KwjtLBn7I+JcX019gsYpAroVD0uH1zkA68oFcX6mzGr+cVBbo4UNG+MEFiAezDRqRpj5phEWIQ/DGTdeCitNyaEZKm4eCICrrVtUB93XJpaxCNvA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4351.namprd10.prod.outlook.com (2603:10b6:208:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 20:45:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:45:09 +0000
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
Subject: [PATCH v7 09/11] device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()
Date: Thu,  2 Dec 2021 20:44:20 +0000
Message-Id: <20211202204422.26777-10-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:45:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4447e735-7b96-4f13-09e4-08d9b5d4a156
X-MS-TrafficTypeDiagnostic: MN2PR10MB4351:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB43518D7A08B9738C305EEE59BB699@MN2PR10MB4351.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uhxu+NY+vvEz+g+lbBHEtnr74TGufq2DWSe7iHGS5bpeZs1EoxNAGVpD82uaqLEupsHzGRYpfFj7+E+3GF3Cr+qOeoRhywQwbpgy9ErzIjcFEjD8Zj/wVnuanqCsuY8ir8fA8JF9KVN+jkQOiLGsmmHhJ1NcywTDEkACntVeJFYEk//GO7RwpDP9SItgykrzv37K0WfnUwEZs1d4seKpC0yz14jRffXcjoZkvmM3W17HSUJKsh2KUNvgt+skF2QPohjYCT6RsCEoVnjV1Zb57tS6zVRPHY/3YrYgvOGhzDTSVxhfis9ZXTHywzVy+cjXgH/Eu7Kj72lWOvNWUkDwX+v+g7UJicIQ/DDy0BjVy3SrSwcpKi2c5q/1RLPVfPrCaXe1jJyh00hYfCHx3ol1mlfhxn3cMByIExKO62/bnjIeETnf2J7U3bnk4TewQS+fRNbW62p6dI0q+V00hhb4I9u0/JzWoED6tFLKqjahAfZ08HK28/GUpr6k4mFjUvk9nulo6m78a84XGuHIJelrzmDh8kJiVmykPIa3LcYiZWWZ6hNQJD1Tq1c9Ig4Sx3prHbxBk5yg4k4EwrwZoMVhTiy76b03RWVzzW5rfWVujSW+uuf2sRV5c6IzObg70waVcm6Gy+KTqBieRigtGC5TZ3VtcVgWe/AqPCb19OzoP8YMOZi3g3lIspVF4uPxOekG/M99RiSE/U/yI5zGLk8tsQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(1076003)(7416002)(2616005)(6666004)(38350700002)(7696005)(186003)(8936002)(956004)(4326008)(38100700002)(26005)(83380400001)(52116002)(103116003)(54906003)(107886003)(6486002)(36756003)(86362001)(316002)(8676002)(508600001)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?/2cMk5uXqcath2CI77aYHyFQspG2j+iAY2rWNngfgMPO9funjOZeMuw/yzVh?=
 =?us-ascii?Q?JTEBoQ5l2FCWx8Rt8M3dKf5YXhExPDCum1zp0FvojNDZBdnaoLd7soaSK7xC?=
 =?us-ascii?Q?1Y1v6TG0MLF6Tfw6N9pzco5SeC1Y6UbdbaTX18nXMHP1kGu2Z4+o9S+QxLMU?=
 =?us-ascii?Q?2dZShozKjIdustGCMSAKaAjX2KWS+sA9eTByzuPXg3CVIj5rGataQ9vnz64k?=
 =?us-ascii?Q?2ULOEudPZymHxZnO0U+k20q/OOvCLDTx+uEQhB9JZXKTkjfsMVsz9SBNSaqV?=
 =?us-ascii?Q?nnuos53bDwSs0f+4NFrbCW4Q1ltm5hP7YqmsnLuk+aJrBe0QXrhUzGlgYqLm?=
 =?us-ascii?Q?M7GaIMhTEw8DmqFwWoP/m9cvOT4GZmyMQ2kQBV6IKmfI7izIZrt3vnwlX+Eo?=
 =?us-ascii?Q?dmXVF/NyAsr1XtVyQ5CiomnQs5nY+Zeg1Hg8HVZ7RdSBtLhdGwALwOWG5SLp?=
 =?us-ascii?Q?24Cb+OcUpCZVXt43SZqNIKIueciuogbSN6esLCGY5fV74ugRv/cKWlFoswAG?=
 =?us-ascii?Q?ErjzhMzy0pYi8YtZlj13oh6rFqx+AM1zngVgjmb+9rsLlp7g8SOQf3kGYWp4?=
 =?us-ascii?Q?ztzgTASAvTylYluaUztLOdgmvVC01z/JIA5meEhID8iHzfnBZ2/34PfQO3TH?=
 =?us-ascii?Q?whvkL7OHdiIQ3RNGJ3Ng8iEH2sTz23pZAdMZOZcQvBJhiyvpbazFMEet/nwH?=
 =?us-ascii?Q?YxVOFnTcqBppZWJiJmLWI/eM6SAuMAck3aa8DUjhjlD6LwmQt4JbxydSuWp5?=
 =?us-ascii?Q?vCvj1Tpss46M99WTrX9iTFFLcHhS1PTTl7G9crgMZUd5+h84UjtsCLytW/+r?=
 =?us-ascii?Q?rErPgaV+e7moajoh1c8uYKssUxyOZ4bmwFpJ1pbOA/QBcKwMEKYvkzCf06fR?=
 =?us-ascii?Q?J+OABK8yZKT2MmWzPvcKLqqPvI0eogWF90qjWawyQmqnyeJCBIIcD0x9dO9Q?=
 =?us-ascii?Q?hPS7e4baQvH4sbnxkiRPq2tDLynWcYQYv8Jta8hRiI3Qk0F3vkGUmwdS8Dp8?=
 =?us-ascii?Q?mjHnFjEevoTV+1PpfEbR1bzOvVCIWbEx1tr59faj7MHuKrv+dyYFv1iHBXI4?=
 =?us-ascii?Q?/Zql+dn098pEo0tPp+w2neSDd1Tp5dNKs5YIxMEEVcD5tfyNhaet6qJmruiv?=
 =?us-ascii?Q?GnQbw4bLoue2xyGxMA5IuY0Nx/O80vwLZrXPLIsDEXaL2Te/nnhWIkLnCgK9?=
 =?us-ascii?Q?za7Q5c74mxszHvXcey83lkCKCasGRB9M6jYOYulzd9xKap4nPu5ujAIoetmQ?=
 =?us-ascii?Q?3Hw+q6MiCo9PNFwRAH4pkJ9z8nFpby/ah6f5Ob+H+wlOQC20kIDQRDqCkLMh?=
 =?us-ascii?Q?GBnrcw5Zh13OANx9wQ8PiZHmk5Uvy8mAB61OqZkBqIbvfqAwR6SSg+pt09RK?=
 =?us-ascii?Q?pOtSmBVNvpnjyfq/UZQEOadOdBJdwbyOoh+/VPdBE3ZNC0/ZH2x0JdlR7RgR?=
 =?us-ascii?Q?78OaViObpcfTf7f9ggE0vyI7aQeVYfWwwR2PP7YN534NPyZZRZZXTNTLhWaz?=
 =?us-ascii?Q?sjnQlAeP2BV0si/T51/yDmQtV45COxJ1SVH4evPYpWSf6fpuxxMRctXCAMXx?=
 =?us-ascii?Q?tPNj791kAxvmqjjy3ANS3W71QnDTDA3faZq77QAai84md3e5nb9ijQIDyX95?=
 =?us-ascii?Q?6R43BiL9YJG13s0/G43Fy8WioXWpMHQIkOf5/1hVk0SvM5BSRvbjHm93y0mT?=
 =?us-ascii?Q?PanfNg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4447e735-7b96-4f13-09e4-08d9b5d4a156
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:45:09.7068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jCh1GmIbVxglZihkOgP0l8xOqCRE4D2+R+r+Wt0RAb0sHZQm6jkVSDCmiJ+QvkOVXasHqryIAxXnXsMP7iF/ESFQqEFeY7LYE4WqLSJqhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4351
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020130
X-Proofpoint-ORIG-GUID: D-O77wjrGsjcRVAg0Rn8a8__Pj5iOpDg
X-Proofpoint-GUID: D-O77wjrGsjcRVAg0Rn8a8__Pj5iOpDg

Normally, the @page mapping is set prior to inserting the page into a
page table entry. Make device-dax adhere to the same ordering, rather
than setting mapping after the PTE is inserted.

The address_space never changes and it is always associated with the
same inode and underlying pages. So, the page mapping is set once but
cleared when the struct pages are removed/freed (i.e. after
{devm_}memunmap_pages()).

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 9c87927d4bc2..19a6b86486ce 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -121,6 +121,8 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
 }
 
@@ -161,6 +163,8 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 
@@ -203,6 +207,8 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
@@ -217,7 +223,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
 	struct file *filp = vmf->vma->vm_file;
-	unsigned long fault_size;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
 	pfn_t pfn;
@@ -230,23 +235,18 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		fault_size = PAGE_SIZE;
 		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PMD:
-		fault_size = PMD_SIZE;
 		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PUD:
-		fault_size = PUD_SIZE;
 		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
 		break;
 	default:
 		rc = VM_FAULT_SIGBUS;
 	}
 
-	if (rc == VM_FAULT_NOPAGE)
-		dax_set_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);
 
 	return rc;
-- 
2.17.2

