Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6D3FC2
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:26 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWEDL013579;
	Fri, 27 Aug 2021 14:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=keg8kqseuVixviAUTAEpC8IL/hzf/YKR4sC0T69lb54=;
 b=1BfrvPdoors89MrN5ZtwBLbPrl/Ka6VrbV3pF3lv5lQlnIMzxqPW9SVzK5cnWyHNb2+d
 pQ44qTG4lpW2AtZpQiY0WOr1CygXIROWlPcEiSeBmawucEp48OGb3F+EKo/3SP8F+nfk
 ZcYZU9qrk94gUlZGY9BUWGKuLjr3CyDoCrnmsxgYKpeq5qYUCbT7vIdRigf6slvTVahc
 iFla3KWwFOtjXX/+V8SA0NM8Gvn8k03ZjbziLgXs5ahYpb0rV2a4iyEXDaKt3xlGhhMG
 L8NL9c0PiZ926iKUXG2CQhH63dBIh5zJMq3gpJKmsf6nXdmMXLfixMbWUQsdtMmDAoq4 EQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=keg8kqseuVixviAUTAEpC8IL/hzf/YKR4sC0T69lb54=;
 b=cR4OKo1fNxvsU8CjDl9vAA1NM/tfyLkUUCgnbJyjXK0D1DydrM7YUwV7NieMxkkDvvBg
 owTJdcX/5DHclv7KBy2KwwwnjyzgIfPAX10e3NgYrxUc+dcfcg3eOXYbuUrmrCLSbbAz
 y4fhPGiUHMbOJI4cfLVa1YpKXjwCPdADKkSYJZlWkCPnOMRRTKxAYXsBLbtwCojLZUo0
 mqbY4x5dYkGZMShxT8xcequ9qAYh8wCho+zh/rQDpOWlTmTnsH82ng3KaQwxSOr+16ZC
 Nw+rpTG6al+1DBfQ83VUOySnTEbnRZ9hsaTNQy8r9j/0NS1i1axlSdOL9CiXR1iVjwH3 dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap552bst5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpbE3155999;
	Fri, 27 Aug 2021 14:59:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by userp3020.oracle.com with ESMTP id 3akb9293cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4m4pcd97Hhz+Z1KDdKn8j6k9niT19hQ0eXS3IU9hCNfOnyW+L5Hdf53jjJuYFnInHqKZyR2SvcrRPOdchNK3UFTlUP52JoKZhPUpH87e827hqHVx15YsfSRUP6/MzFKHmBoAtf1Ygt8XvIrz3YjVrLieYaF+LrPf4bv1irLK6uW+tZdylGZbUKhz3s5JlQMYhSW1D3PekL1HtoxH9Jbdvm1eDFwxQrKnIHmZbS5QNmWx5vmF0ZDGd6Hpu/7GNEmj4iOkYACPZhKsHji+xb9U7FMF9GgTxlp0OG54XFh6ZZ0axjVXW1svF9Ql74DJLVebibzeQEeJsf6un9vt0dBjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keg8kqseuVixviAUTAEpC8IL/hzf/YKR4sC0T69lb54=;
 b=H1jyQjkuQUfQbQcZtCTkLOeqZQARV0mu8DEMHrLIzEnlfHCa3GhwDkCTojxqTCgA03Hm4Eg/4gpJbr7aQs+ucJllF8rSS1j0n/saRqcwV6iH8lTF1UbNQAx+n7oLAw4/X8ebjYBUaW/XRQsiFYk2Y2Zvrk7z+t0xBJB+uWA1aTMWjWIDZDtRrzPcj+5bnCCwAepmReEFumas7PfHm3/OP7D5RH150wNNXWEGcbZtNQLlRMynZWxm3AluxMm7yTppkBART1jbWWzWnNcaEji/8JKo78GRqWkPX4T0YPc/dfP6vxfnpzBVJWY1qMqvXhkd6biSI6JwWmsEchb0ShSAaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keg8kqseuVixviAUTAEpC8IL/hzf/YKR4sC0T69lb54=;
 b=WpdQr3RtTcuj9P/0CfhUDE9jjVPwTi5DMa9ys+1C6UWkVyFWyAQK060TezC6/WJkPvdEGWTjnBLrCLzfuOC0QLdIjME6QrGqLNOVtw021+ZVvSkUnY6mIybEqP1mVIJjqK+Eynll86SOZtE/cyXgv+CuRvYHKwBzl7GnscQ7x0A=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 14:59:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:02 +0000
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
Subject: [PATCH v4 07/14] device-dax: compound devmap support
Date: Fri, 27 Aug 2021 15:58:12 +0100
Message-Id: <20210827145819.16471-8-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c31d806-7d10-4fa4-bf9d-08d9696b34a8
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB48818CCC7F03004BA10981A5BBC89@BLAPR10MB4881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3kOVmRjS/ruRpTayQ9UcfWngoCkh6iUMW/pXnSgYp0Kw5t5UXTGkC7zrlH14j1hSyqF/mQGp3OMA6kVOBmpG96RFuNXwdnV+jmODfA/7A5kmewvqmP32x87ZhcXVF4E1uJQOXAfseN0UkqLzijCFLOtRag0tvtz3mfKnRsjtJo1w2rBBjuccmzLeYpkTyDz0RPkBgnVxf4SDUk01ZYFj4Ig4LYmItMSHwtpboJNOGCTtR9JJZfHBG7Ya/RaMofQnbA1N8VNFmCQHktxdLH3dWCtmXRVHlPixkiroJpePRQsTRoECC3Dh65BXQlpvKeFgZ79JyAFkWYngbTQdNHLAXbrkv4t6sk5Rio6A6HzbFxlBafD1sCykOKSZyUx7iM9KwLi7j2XL0B2RHW7SyQdC0uYLliYRb+/d6njsE5opAGgzaERuQM1ib5v3TqwVyXBagSaPD89+BntJPeYIGduNS8yefxYCb6ZKyoP/mjfhO3/Xiccth1mz+C+34d+K2z087pJKk8lLUlr/HFIbeWuKRwrBk8tcTB6sEMNNq0Wv5ryqubl+I8hlFByfM2p8vENTklRPlF5NhuH4LFVr9ys0UdntA+mf2kY/2YUb0TyIWNiWPsRaq1X/e0w+qvSjgUPXCt4sOGVxDoRcUvQLCI1ZmY/SgM2nl+3iroFt2e73fGQApglYIQo92UW0cRjFFI/xxJddtKhVoN/sn029qCVFuA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(7696005)(2906002)(83380400001)(38350700002)(38100700002)(52116002)(6666004)(66946007)(8936002)(478600001)(7416002)(107886003)(86362001)(36756003)(6486002)(316002)(1076003)(8676002)(103116003)(26005)(54906003)(956004)(4326008)(2616005)(5660300002)(66476007)(66556008)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?y0V+nJZQTfgiZWFS2bekLA/nMVHodcX01mdhtwq8fdcgprIfnv7pxNDE39Rn?=
 =?us-ascii?Q?LKMeKqAE7G2t9bXe2sAtRMe4SL5S+1TgWzspicgyo5NYq7nIPWEnv7WDZmjp?=
 =?us-ascii?Q?pV61MTMRSsv2iTXN+/WT180FWaGhHo/khLkQvbbBHNojUq0r5Xjru3wiP5m0?=
 =?us-ascii?Q?v1c681yKtFBd4Gw0REL8tAdBIAc02rHLyPuGt6mp7hm4mlrHgp8+HHdfGGSt?=
 =?us-ascii?Q?pGfRH9ZaQFNj8mSyBt+VkJjC6HB6fYhU5+c7DRWfzVroxaXiOIYorhBWMQSm?=
 =?us-ascii?Q?Xzijn16CcpdK25sc7e8KoYTWw0t4BVYufDVFVgvwYeP8um4JQf82DXrLTlld?=
 =?us-ascii?Q?0w9/cYYgyfIagIrUHU0UJ70e8ml7iAUATfs9FU9im7yybUoZsOU1NfkaHyAv?=
 =?us-ascii?Q?sDjmBgjs239QevpVg9nLl0Et1sa1JZzLzzrs7Xi6UaoT9KSqblQT1RhVir+4?=
 =?us-ascii?Q?3hkUJSeL5jQ7p8KnyfosngtJ5b4gVsUGSO2Mtt0qT2ZxX4LDkDTEof7ZMEW7?=
 =?us-ascii?Q?bajvVW1HlylWyr56/cPnzzM6yarD2XZ023XPtEd32Zt0qOGKSKSsRMo8Ug/a?=
 =?us-ascii?Q?FquLujF/Ap2GEAgJzJ1z+sdCT2v7UTYJJUFyC2IAI0LAXrJQ7R2yZxzkuWNy?=
 =?us-ascii?Q?fb3Mzt+pzIE5BL/PULa/zPZl1n5v34LTmfi/pRBaMKanhlmb78NX0k0FMdE2?=
 =?us-ascii?Q?Su8lkyG0zDpwQKkjaOO0bQt4OMyiCHXFuWwHNaQfVwnLTxYgTrucsnwd8oHa?=
 =?us-ascii?Q?PVFxIaOICzApGsvB4tLfi/urSzRrsTTczzI3V0zMl/Ls+TQNF+YnN6cUW+ja?=
 =?us-ascii?Q?g5YlqaDeMsLBg/oJqqajYdECfbxdZibKc9qkYog5pKUUmMe1/Z04f1O2fGGN?=
 =?us-ascii?Q?vs7OyLwjWObbbKekDOYU08j5waHnPatecOIeYMRomA01R5NzSRkdZqv+rhdz?=
 =?us-ascii?Q?D0/k3iCASnd6x4F9Axbb4OH01jS5XRxE65BvhD2G7eK7yAdTpz7bq3pxYb8B?=
 =?us-ascii?Q?uJvzuYEZDdoXvKv2HY2ti9fVnkYAv444n7PsqzAEmFVcVHssyiLtI1FmNYBd?=
 =?us-ascii?Q?q79fI166OJqoJXTHi/f8HLFbyKJMQMdQ3R7yizVu+yw9pQp9v1GrOtFXb7kM?=
 =?us-ascii?Q?EtoZvPBifb7aEqsCDMlxbqmY+oEW9tiGImNUUoNno98JzA9572mg3QXooDfk?=
 =?us-ascii?Q?FkkePGdWUN0kdloizdQKmrfOiAYqdRm/I9crYNZCQ/WcFU1IOb75BsFbFCw7?=
 =?us-ascii?Q?aJYxJ2p4afSCCjD0DGOiPr98YBqG47No0JF42wMizqA1yeLhSBIUFQqVii/A?=
 =?us-ascii?Q?TWpk9jzmweqBbMlySCxE18LV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c31d806-7d10-4fa4-bf9d-08d9696b34a8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:02.4000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcEdRFm3PAwR87IM9LhBY5FpUFscXzVmg3R51/Qg1d2svtkQzzqVPHmhYuWAiTjjaEcNx24HwE8luqI2x29WR4k3xG/4jXQ5JHGXbUtfOUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-GUID: 1040wEk4GCOOl66nXwvdIrKZl__XKND8
X-Proofpoint-ORIG-GUID: 1040wEk4GCOOl66nXwvdIrKZl__XKND8

Use the newly added compound devmap facility which maps the assigned dax
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
index 6e348b5f9d45..5d23128f9a60 100644
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
+		if (pgmap_geometry(pgmap) > 1)
+			set_compound_mapping(vmf, pfn, fault_size, filp->f_mapping);
+		else
+			set_page_mapping(vmf, pfn, fault_size, filp->f_mapping);
 	}
 	dax_read_unlock(id);
 
@@ -426,6 +454,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	if (dev_dax->align > PAGE_SIZE)
+		pgmap->geometry = dev_dax->align >> PAGE_SHIFT;
 	dev_dax->pgmap = pgmap;
 
 	addr = devm_memremap_pages(dev, pgmap);
-- 
2.17.1

