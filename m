Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC3E2C8B
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:57 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOI2smF031388;
	Wed, 24 Nov 2021 19:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ebePip/+Gdg9SlJTCVyJbN+5HNXO4O1rodv0cXLk5hw=;
 b=UloswvdT/z2X6+DpQ4naVElmVy4HW132s1QA8nxzuex76hHAeJJaOIoBJ8D2VPZ1MXQV
 8nLM1kGaIdkdWUB/6edHF/My3OAeM0joWU9S7vICA0WWdHfMXFU45cVdN5i7B1WDSDQA
 O6Q1ynYZ3R+QQmyoOB0nEOR2HLmSj5mqEO1eL+2e37q40ssTGUAvIDhrS8tQpjuh7RVn
 MYB/6YVtviBVPJlhSR6abWZMiPZMUffiMLnOZQ4chO2UGmnmyMkhhke/NALyiuUS5JEk
 PLCvzhhJY5mRL1h7N2CEuLYCfy1ptxRyYGME9KNid2aWKiHj2B/giALrDLG00cZb4G5Z Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chmfn2quf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ14Xa037405;
	Wed, 24 Nov 2021 19:10:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by aserp3030.oracle.com with ESMTP id 3ceq2gj005-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6ehOrlUrd0HaEBO7agBdB76WOT5d6I6d1uj/0sczclLgeReQkaRQhkT+nn7jULwNSqIBgSfhSEuPPSGOtvxNc+X/lN+wVEkgDWCfqxv/g+V58nuIc7RQM4M0MKYB+QXyFDabeUKWi4gYBZqutKwjxLColsi3tQK8vgxJHdw7Zhx6KPxDpDUq5+EULKY0Sas79B1bs2l6JbU4MG3oH2t9oXwTlfHZSrW/PUjs458Z3SkGIysAEUyZfOGL6Fg54HrBtDrGoBbiPZQd2DWaP7p3NbRqnAJSC85VunOD8gnGsHTdf/nFpma7fklARZrolGwI5COjp/KMM3CbSTdYn4lhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebePip/+Gdg9SlJTCVyJbN+5HNXO4O1rodv0cXLk5hw=;
 b=l7N2Soaxl9GeL4OL0iRIZOPA78qJtgysfOj6qSn3xoTQ8Yu6Px9Fho6C7UZ4HmF4P0B8mUe0KnGk+B7wWNqD+Qdny+P48tU7iv0I/nuR8nfWol1XMnByfbYyKIqpleR3+sXhU7tJfaMABsErD08Gzjjr1/aT4ttKMdBR9xIYAihaAHbjOBxnBV2m67L7ApRRQ21vRcklTbZa2hoS5UZpfsW13LSTqhMmiP11cxx4pDLsrzHm8VoKmwxvmZo2bp+pbVpRdhnXhUrmnM8XYqNDUvGIR5ggeGZopDQ4vD9Q8v24I+SJS/7vmc+7d+cYvdXOv7ZKZ2WOw4nefMO5wATuIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebePip/+Gdg9SlJTCVyJbN+5HNXO4O1rodv0cXLk5hw=;
 b=hhrHAoTHkvRmEheUgMHeY5XfWTgBV/GMizojI9EcuVu8BC1v9OMjM79/s9mkMWvkk/A2DrI58hd/hfGuhfTOHvSL2N2yUatskEV8lsOIYrA8GctZvs4fv54m9zDTnCnFRhAX/gDo9hTGi9HPjpwPY9kFgTQG/Dh3xOd70DImSXE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2916.namprd10.prod.outlook.com (2603:10b6:208:77::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 24 Nov
 2021 19:10:48 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:48 +0000
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
Subject: [PATCH v6 08/10] device-dax: factor out page mapping initialization
Date: Wed, 24 Nov 2021 19:10:03 +0000
Message-Id: <20211124191005.20783-9-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211124191005.20783-1-joao.m.martins@oracle.com>
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0093.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85baeca7-39ea-4ba8-61b4-08d9af7e1f74
X-MS-TrafficTypeDiagnostic: BL0PR10MB2916:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB29160BC2CFCA7F4D3BF8F042BB619@BL0PR10MB2916.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	t3tGOPMBTQh1zdD1KMHgjh1TLz+aejtmqvZmcrRUVhqwQJ/isQxP5hwWjuRRWdUqIdkdb99D5NsehAGAvA6tmIK57RXxCCet/PF+DUupcvbK2KISn2R3Xj+Cuk9YJ35Zv9i+6vkBSwWlZrJ6I1co3OWh/73ehUI77lfLBFqMz3NjDrMsztYWz/HDj24gnqelHE37LSBdtdsLg0zXpHAYD83gNx6Ya8BBo3T59tgpcqby5eXPJNWJpBYvGa7kpLS5QG5/VgFS0JHnHxHEhS5UitS7fJUmQv6qb0juSgpJagaugdGDZoyoWdnA76MKI+QK0VdljegUm23jh8ZjrKDXygS2vdd88VWM5J6wB5BerGx3JbOd4zEwfUsqE88uu1bV40tcmYqThAcMA9vtAzjBn+ZWBYaqqGnMPwlsCiRRZCXj6bfqvyFEB6blPtLZxwEX/5ZzMizVraUJ9gWBWhjz83PaA2Zr4bsRY/I9Hj53k5wdYY5Gvb8EW+CE6+yXdbmHhXrzIFBwiSoWSq3J2HHp4GtfMjNw7hoCzU0LbLju83TzhlavdhJWdwgRM2PQpj1a18M8uKmxzL3zi1Zce0ZrJMO7ehXkm05RRsoxyU0L4MrGIwJ2vNAJ6XK1koz6yCN2KnlIZcRLJRc4HXgH/rtHo8Fklu6Zh3xnkgTmKpuXfN5Z8LhAJr5n73OXIYqFdv4LrSb3iSqziwGDKp3YUqjUXdP3rPA32/6CyybxtccAhOCY5AYPaPP0V9huArZ55JjW
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(5660300002)(103116003)(1076003)(36756003)(107886003)(6666004)(956004)(54906003)(7416002)(38100700002)(6486002)(2616005)(86362001)(8936002)(38350700002)(7696005)(52116002)(6916009)(508600001)(26005)(8676002)(66476007)(66556008)(186003)(2906002)(66946007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?iOcogGbWNzfIq1F0tmKvOH8Y2yAmBRW9ov+f5UR9ok+ZwryhVw1urQ3k9WCU?=
 =?us-ascii?Q?IkHO79PPV4gq/PA/vKJtuZeL+0gNNZ+qPbDMsyaKvy9cQjB6tJ5VxSLBC3RN?=
 =?us-ascii?Q?DncuSHRU3GhQCm63pie/2V9y0zleNxXJkLg2ZCZZ3hqIYPtQ8NAzwjAmfMmQ?=
 =?us-ascii?Q?Yjv1CVDMkE7LKzSQ8wqMjeq9a1cOYMKznGlHR4vhoQkGTc+XFs1KrvW5oHHG?=
 =?us-ascii?Q?3pG7uFB/LCEwii6/u3WEdKaT4XLknrH1h99dmJEd4iS7vDHOZI4vwKMEgTX3?=
 =?us-ascii?Q?k+qiZxbdqDZSfVkO0EmwvHTuzIvjAgxhSKCsYT4/xpy3AGvcanLvbzk5aWK9?=
 =?us-ascii?Q?Rk7X0l4imlqY03byaj8Dtg9IBtIELpidKLsK1YCcjI5NCBU7Fx79RHDppol/?=
 =?us-ascii?Q?oq1tpu5FeS8UT7XWA1nq8OaRhbPln/00/olJ8ItPOuJGQvIRVH6ECupBTvQU?=
 =?us-ascii?Q?1Y/WkFPo6B9cfw10xXf5yUqRRtqXEcWPhmZ5HIu6ZSUtzA2C3Aau4uJkGxg5?=
 =?us-ascii?Q?Z3O1bfScFKyg4pkncfEkmxfAL/P3zodQFFz3Ri9CiVAwW0M/HoMNLtTBZHNU?=
 =?us-ascii?Q?XIVEkCN4wWwQ8LsOk4OZI33yVyT0EtEaEp2+8A7KVCS2J5Z7rd0KLrhD8cTL?=
 =?us-ascii?Q?cKEDgoarAhuj8OU2mIdE+hfBjVQXok01Hqcp2Y1vv8WWMJOWtQZd8uuT9y1k?=
 =?us-ascii?Q?ge7K3+YjPtt7FR21+YxBrrRRvLkfn/P7+a6STFMRz0IFnNmVAPo2PGOOor8q?=
 =?us-ascii?Q?ESNbReqA/V46eQ29+zoJr/FB4AGsTwimu+QC+CkjL3DxS4MCPjtZJOJO2xkh?=
 =?us-ascii?Q?xpsBYn8UlVHouoGXqI8H6pMp6Tpk8pQ5DIOZkk/oklt3mpCfE52PiryZI+Uz?=
 =?us-ascii?Q?QH0n+A0J13tLWStDh2TIvgupiJieXCEaH1Yo9He9Rd/b00qZFTDmaulrZeJM?=
 =?us-ascii?Q?+Co4iR1Z0q2Z5wVekxqMX1a8X3UzI0jdRK0Yd3NHYBPmChB9RjDEwN7w/y9C?=
 =?us-ascii?Q?BKZbTFcGgfqfvdpof9mIjhmX/ucnKMsx9IASo2rBhb98tZ5l7xLSc89oPeSd?=
 =?us-ascii?Q?Hmft6qu7EbP3YSNk6aQxsUfWscMiy/IfnuB/5ujPyz40UYsS5lI5O4ZL0DSh?=
 =?us-ascii?Q?9OI/vLd1tfrkVDWtKS/FmjtiSKlyGhMhlLokESTlJyfejXH7jzVEcgGZIXUL?=
 =?us-ascii?Q?roS0HnWerAETMG8dBdD2/ZWo/oJFQzQfMBz02fY1RpdSou0qgrwN7nHANFFT?=
 =?us-ascii?Q?wmnEWyZfxnOjjmrjej3VBAm6cv9ycpwB/F7Mmuyj7JmNWWGHTPrOI1mUxMKg?=
 =?us-ascii?Q?t7cc5UJVzh84IDSoXu2AMDypr10b4xqW0gO4VyL1YCOYEQ70Af4xSBpc2/iH?=
 =?us-ascii?Q?JR0ixI4kWItse/DEnD4mtKrbrXIPzpDyL85c/pASo2sXD5WlXXzvLSNjXcKf?=
 =?us-ascii?Q?vF1A9F6CoTdRafr1ovq5jTDI9Td9srrmIfVf5JxijbwPMGxiVT6dbWazGo4P?=
 =?us-ascii?Q?o/35ROtFJ4HFT2tL7s8Wyo5ocb1hV2W62/PFwaRm/jWOwVRENMRbJPh1IrCQ?=
 =?us-ascii?Q?TD8CIbBav0/cCODOJBdxx6ILWXrjkuFDIiycpMJKVdYQTLRNiOkcDaWDxnoe?=
 =?us-ascii?Q?dWbnBT0+GAO90JFG1bxb7n40ZS/opvRZXkXfYHZtKK4MEooKT2d/5I4CjOMG?=
 =?us-ascii?Q?qKLogA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85baeca7-39ea-4ba8-61b4-08d9af7e1f74
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:48.1541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ub4iE0sjS47gMoD0PmrCRn3YeDoX0l6OoWw+EeUZOJaUcPlSh8IEQVo70ivUxIv1hx+4j0CF36MKRuHbTuZOGig4bmJBocY2nkYfGHf/tZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2916
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-ORIG-GUID: 9nK7fPp0aivsUqUTUQf0DHmQIVtCnUfe
X-Proofpoint-GUID: 9nK7fPp0aivsUqUTUQf0DHmQIVtCnUfe

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

