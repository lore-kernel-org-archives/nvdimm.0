Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915B22CAB
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:14 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KODxc006894;
	Thu, 2 Dec 2021 20:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ebePip/+Gdg9SlJTCVyJbN+5HNXO4O1rodv0cXLk5hw=;
 b=veo4JShZm6zZDhJXt/HXzdyG7U9vzZhDcPq0e1iqSyp/D8HAC1U4FwmBM4u9YnkqtXbj
 Dkp3HE/uxhuZ7m31a8WmE02nY09PPpKf8olfZ3CuOBS2Su9wMxW/VC9xyGz6zhAgoNuS
 bG5rUGfugd7GM8yQeo/6fKU28br/bwGSupeeKSbVaFKtlBRs5o0eOELUc4Z+lk9nKWvM
 ZySUTKV3vC7Ql4sTEejURLb69LhpCFCO0XO9ynB9HMxWqMmSLyj/ouxbUDGd9q+kU5Hy
 IDe6DNOCX6kvE6+XDsBVvtetL2Ry1w80aU+DLZruc1tyb2pahmgbAAUenAKSJZ4ybteA 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp9gku3x1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2Kfp6K167614;
	Thu, 2 Dec 2021 20:45:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by aserp3020.oracle.com with ESMTP id 3cnhvhc0tb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGVjJxCeMvaxk4CcBghOp1vvLfLs170/FQzb30Xu+UiXL8lkCQVYHkG77XQW/eFvVQoSfaz8fDMBKFYZd9Dut3r24887+9VQ2MSCDavcGLFTiwcpSfoYY6TyTuAIM7OP5DVrCNUNYeXQ8YaM638Vyweatfdr7LZWroQKDOyLlvZH+Cb/NzDIga8o7yFi0L8fmg9cmAxmkXcE5UpNN1tmu2nFW5HGSNKn5k2Lppf3joYw89r3IRwevVCA4wSIeoT31bxYXwI1xVvpFHXoVZY1IDcNE0KKOrNxLGF0yCpUmeysQXkMPCb7Ti/hPPRVvAU3eZ8y5hqGnxQmE/YaCn5bFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebePip/+Gdg9SlJTCVyJbN+5HNXO4O1rodv0cXLk5hw=;
 b=ajQxCiVS+aiSAOY9YPQ56bFjMEpRD75Q2auVKTFPt9ls6bn65e3BZyfgciaJtvxZzVs9kberbvHqoyUjATnmwk5ou2vCwtEGg+nXMVVlp4rz3LSjVBlOi3e+Gch1+n1E1VOwstRh081f7UpedODgnXsfNKHJTkPv2SOwT5USPyR0Gtm+cbWIge/Zxn11qBYK2RGurR7nrM8v1KLh4zLa6EKoyrJXSuD/RDvo/t6bU0G6+lo5kQLnYhJukFeASfIk819fiAnL1C75alOvLfW2+4/bC1UI2ohoASAXaytXKiV/2vqI4iKyMSRWyRuxxwbaWiXyGPdl+P1zpIbMK2tErQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebePip/+Gdg9SlJTCVyJbN+5HNXO4O1rodv0cXLk5hw=;
 b=aYvFQOGHRjY8Y+Uxl551+K3tE6U7tKRT4NXF9YHtWrVbqgor1csAd4OGIhfOw9Tau38N4Jo58giLkaBQ/vC1/wkMt2Xanf0QdZY99Tm/ocZd3Y+3AWOQ2n/xzbJQ/XR4Q1I+eWOxT24fu1P+dGbx+3/d4Js/mnA070taFHqXXS8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4351.namprd10.prod.outlook.com (2603:10b6:208:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 20:45:06 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:45:06 +0000
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
Subject: [PATCH v7 08/11] device-dax: factor out page mapping initialization
Date: Thu,  2 Dec 2021 20:44:19 +0000
Message-Id: <20211202204422.26777-9-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:45:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae962f75-8d7c-4bb7-f094-08d9b5d49f3a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4351:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB43510F68F0C9C4D84E3FFF7ABB699@MN2PR10MB4351.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	DarbSFsUc9STSvrg4VUtLjJSWg+sqhrqiBtiot2gereYww8aBQvDfszDKXNrAnNe8bgoIA9hwRvRbyl1rC8KLM5dbnSReBDbdabVuUjZDx+G/GbUqZdyRmNB7APH1Xv7rtT1Rhi5yRG42gvm8LhXTwvAt0UB7wtH++gLYHIztdNfDEOsTK5vV3zlzh+T8c6lIRPR9l+b6ssJMqd0pmsSxr78+cDikhU75GjR3u/Sj7N3OCs6fE0jW++zUomTe8sJWR3K/FaeRX5rK+EEZu+9q1twnLnhhWGjAoz+9UkwBuKWkdFD7dU8PeoivdJ0yO3wROCpD+6ojqXkcIjYpZy6UdlwJtn9SF32weTRZ5aRaIXFs6ygD1Jef60dMQfVydlWZwco0GCBiv/fZeJL6y93+Yd5fJfSvX3qaY57UevKNfWUE+fvhvTbQSHslHjV+toBskIFrqf9kmUIPaN9w+3FuCjT0yCU1RovaZaK0pXcnxERkf/iDr9nacAfrvUFC7uiImULtQOrR6UUmg+aBsfDC242hRztQY7kzpxmIEXPdaYsn2Dg/MuQ6jVINnuytAMXYtCx6Q4VlmMzNnCQB5YjQKM4SK13oyy11RWaPACEvq0swIqC2wj49i2fEDXM74I1M+tIFGukaqM27Bj7Xofon1k31omzAJpi+AwZoMX+ZkZWhb0iN90GJFP4ylc0GgxR8OWnxsQh6fbXpQvCvOVEvg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(1076003)(7416002)(2616005)(6666004)(38350700002)(7696005)(186003)(8936002)(956004)(4326008)(38100700002)(26005)(83380400001)(52116002)(103116003)(54906003)(107886003)(6486002)(36756003)(86362001)(316002)(8676002)(508600001)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NaUOLZ2sEOoLhgiu7N2j6n4T2r909Nye+RmRKEmu8jIaUMGaRylW+f2Hjga6?=
 =?us-ascii?Q?wYu5uxVn7GF17GFbkSda/lLOy4ClF+YRN0fbd98UBPg25eknVihz9MQfZSS4?=
 =?us-ascii?Q?qz5bZfGEA7jJ7vb3fetyjDwyJz+rqlXzT01VTlklGCuROZGzzYUWuwHPNKFM?=
 =?us-ascii?Q?nNJ+ta9M5gHd0qXaVrKwgVY3A7JiiBSU0cRMW9AlrRI6xh0MYXpk8oIuIRmO?=
 =?us-ascii?Q?HvUhfa2G80n59Ma65MK4xJ2EguMjIEktXiztVvOUEOXYeg4TZ6PLR4SGj9he?=
 =?us-ascii?Q?GIHrB3yp+RpkXqyYHRLkdpZzYpNmSnWwPfVPPWUgqNIpTlnMlJuddnteRx20?=
 =?us-ascii?Q?RPJmj9YfCYzYbEcsjqoPGOUSXkPXdOaDM6MNJy3ae9GuBNlwQM2Z/9XIeLB9?=
 =?us-ascii?Q?PZXergrufvc3RlWWOt5VaRNk7c3Cfmuxdgl6yA0NwzZa5t//wyRV/Epl5DhR?=
 =?us-ascii?Q?Akh9lZ2ikdxI3gCHYWER/NKuB+DJGKWX631f7LaGfR0PpwTAtJwMYi31vvTL?=
 =?us-ascii?Q?yWXMU1q0XrSGA0DWgV/F/1O51tcMWmi3xWAVQvuaPQQjMlMNaXn/0YMG9RqW?=
 =?us-ascii?Q?DSyj+s4Hlvv3+OcZpCtKLCiOtqh+4QBR3aw+jKlu1RGt90znN/+CR3UHk5dh?=
 =?us-ascii?Q?TrIPJZqmKJ3vsrFpyjNZuyr4go2ueFtImbhB12AhYIH+ir3j7u3sDaqHwxc3?=
 =?us-ascii?Q?LAPWfMJMe4XjaVNSaJgTiyW2dG9Tw7kM18q/BbNYtFXsiPE5sc0yseJ7uXWz?=
 =?us-ascii?Q?9Q/a4M9KhdoGN5oseh9Caqkrc6s4TWIv4r+EDTKK3rGjBaOTFHobRRqb4Yc7?=
 =?us-ascii?Q?KRpyXUf28/dq4zUCSw5AfwEsQJbP1SSEQiFKQjenUSPY8gDUBQ9TqnWYvaFV?=
 =?us-ascii?Q?n7doQw0JVb4yRqjr33CJ8l9dgNA3ciRCkkhyX4ZDAHyWa/g5cuRQ9GFd7k9T?=
 =?us-ascii?Q?f+iUeYZmU6/JZQW90FbxZDbvcq3uu5veSZNdgHrJDHNrvB8/5+24Ks8coLH6?=
 =?us-ascii?Q?h3hiMabtLwaK+30Xb9pr7Orgt0ldmIEn0k1HfeElJjk+z6w+Q5aK+kPFl2Js?=
 =?us-ascii?Q?I1H4VmhR4i0wVY9XqXD+/12jctOtKFpkfEu+eQCg/zqh3NXJvPsc2PQJPMaA?=
 =?us-ascii?Q?XJ++6ZxwBYiwm6FtpVpbhrlnNkw9QXh0fNml2A2rMW3r9Z1Qp6KgJi4k8ieO?=
 =?us-ascii?Q?YW/JuJPSOyEm5D434KVCkY0OdzcKVcYPjdv8RBhTRO/RRJlbPt+ukQGu+Oym?=
 =?us-ascii?Q?IMUi1S3RD9SBJOFJeKWlf2f0q7Exy6+8Fs6k32fZDSBOnxjlNgygMPAXzfcs?=
 =?us-ascii?Q?CWCJipQ0bQxFBI66X08L/Y3PdX3ZVlmNOJsMQ/Hv5WcbvchsP9GtVhHWPYmV?=
 =?us-ascii?Q?xzTnJ32sxqUOH1wpYRLkCwNHufffOe0RKCux4afITK/HP4skwKyYVgEvsBXP?=
 =?us-ascii?Q?S2bdgNBDREcrL2ifuU2EUp1y7XGU9EjseoVb7hkwCT0wru0PpruR6FrxpXJI?=
 =?us-ascii?Q?9bBU7pDBAq2DPWVw18DpYBT1Jo1GohQmSFqbGfuVI7AqPbSwwfdjvgwnTwSq?=
 =?us-ascii?Q?HVCv3JYdyKCod+QCRk4skXHdJztH+M029AfPHMnKs1lFxvV2L5fDwdmBdIl2?=
 =?us-ascii?Q?DkAoUbjFRSD/x/VjZ2ZuldwIXltjzSoe2XDKG+XkIW040xrPEZ6VGj94GBKg?=
 =?us-ascii?Q?2v441g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae962f75-8d7c-4bb7-f094-08d9b5d49f3a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:45:06.2062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FG0qwWTq3nkZDWT+VCLPs71jhOSXWNgbcl19eI2IKcqTP6GLA/mqbT6eK9zG8uekz+mS5GrsOiOBV0qGUjoaVN78z45YnC4GUwXy/mIX1eE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4351
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: ngkj3N-JfzN4Kd-PEJGnqxpXpLr-YpqI
X-Proofpoint-GUID: ngkj3N-JfzN4Kd-PEJGnqxpXpLr-YpqI

Move initialization of page->mapping into a separate helper.

This is in preparation to move the mapping set to be prior
to inserting the page table entry and also for tidying up
compound page handling into one helper.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 45 ++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 630de5a795b0..9c87927d4bc2 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -73,6 +73,27 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 	return -1;
 }
 
+static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
+			      unsigned long fault_size)
+{
+	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
+	struct file *filp = vmf->vma->vm_file;
+	pgoff_t pgoff;
+
+	pgoff = linear_page_index(vmf->vma,
+			ALIGN(vmf->address, fault_size));
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+
+		if (page->mapping)
+			continue;
+
+		page->mapping = filp->f_mapping;
+		page->index = pgoff + i;
+	}
+}
+
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf, pfn_t *pfn)
 {
@@ -224,28 +245,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		rc = VM_FAULT_SIGBUS;
 	}
 
-	if (rc == VM_FAULT_NOPAGE) {
-		unsigned long i;
-		pgoff_t pgoff;
-
-		/*
-		 * In the device-dax case the only possibility for a
-		 * VM_FAULT_NOPAGE result is when device-dax capacity is
-		 * mapped. No need to consider the zero page, or racing
-		 * conflicting mappings.
-		 */
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
-	}
+	if (rc == VM_FAULT_NOPAGE)
+		dax_set_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);
 
 	return rc;
-- 
2.17.2

