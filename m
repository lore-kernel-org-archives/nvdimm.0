Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA1D2C9D
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:37 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KP5ZN019804;
	Thu, 2 Dec 2021 20:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ulJEg/Kgpzv/I7StoVL/4+pHE3ZMH5euZvNJ/aod2+A=;
 b=CrAH1JXhf/ZDQCelbuOqIAriLbxJsowyBOv6fxOQYfSYmIv4I8qBXcl+T3OsXLC6S9E8
 hC+S25dZbrGz21Lu+r49yVK/Zy6BSIVXt65tl3HFdxq6dHAx8IoWSsKxbnFLNOCuu4Kk
 ie1tpdeBcQGluauywpd6gdV3Jao1YDI/ut1OWW9aGVGiKZ1a2FrAwDU8SQI8jvusuQbC
 sXy3OUljti06NHzt1QZiYjZB0EYnavgmNCH7YKTnmtxpV/F51L5xaJNG/EN+JYCM4NvM
 D8T1xGb3fQhEJQdw1a8+yiqm/xUU73/m7/upaNkNinAsRD+oIGw2Y3VpdWvSaAz++y7+ Zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp7weud9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KesvB121355;
	Thu, 2 Dec 2021 20:45:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by userp3030.oracle.com with ESMTP id 3ck9t4v5jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:45:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWohP7aKEexWutgh8qfcsEp3ZjYidKZvqOnmDqmILwDKLS7nB7Lsbc3ktaPAfc7ktgSTNXX55WHpz7FFLlhIVbpQ6jK3Xtmpk81PSVKLO2HSXpT2X0TiRUSgWI64HUR6uv35vsAJdh8jjPK2px3CMnZ7pKz0hCdGQpDd/N9aGbf5HZECrWAYBz74+B+2cl+DS3yXLa6cVr03HIHcyj5In914PFP8IlfGz3ky9xruWh98boo53Gs7EUWid1B7tEfi0MTwVRFU+2iPXrr4DH8nBsZe20THO0yLaHcpXaFvznp0wZsfJEr3vYIPirXY0MzUr8pg6FLE6pdPBIkOPrMSIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulJEg/Kgpzv/I7StoVL/4+pHE3ZMH5euZvNJ/aod2+A=;
 b=U7umRJ8Yg7qo6y4ONO+XttU+YjcNDwOE3TxGq/B2xvnnIGjvac2aEz6g5ap5K41L0fOzFsEcVOpe7/tMKkLEv5ffA4yaL1jnUcjPwKbUH3ndW/nUz8ZmJkTkFuJ2Nmzyb2GLOzp7VCuaWEh2rORf9JTWF2tysIYtuFXleDhLmTv3GPCjFrJ8usPAiVK7M6yWGDwj+8rHISz5XJkFG4azomGux2Z2+2VwZ+kNU3hp9MOJ2sWdF/3At1x8NNnhmGvi7SAv2ddS8CbkSTrfmoXYNLLeRFkD46IiqRtalHdp382h1jhJ7tK0Z3//8GMfoqBWLqiTLHngSUrEtghFZddtrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulJEg/Kgpzv/I7StoVL/4+pHE3ZMH5euZvNJ/aod2+A=;
 b=bLhbf6yXn17ps9Hg4lEppqWGMH9imPeB3L5eezrIeJISXXc8PSSmvgKe0219CjfswSFLPRKPtTc6KCMeMlTgCcSvGmDmSfhn0IFLRvdBjlHZ75TGQbnukIcosrzuamwI6YDiTHVsMUzU6Mh4pdOXbuc28k+1R6fuyS0L6NOd+0o=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5186.namprd10.prod.outlook.com (2603:10b6:208:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 20:45:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:45:17 +0000
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
Subject: [PATCH v7 11/11] device-dax: compound devmap support
Date: Thu,  2 Dec 2021 20:44:22 +0000
Message-Id: <20211202204422.26777-12-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:45:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 066451ab-5df8-43b0-06f3-08d9b5d4a5a6
X-MS-TrafficTypeDiagnostic: BLAPR10MB5186:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5186C9B5028497146D241DBBBB699@BLAPR10MB5186.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UHO65K3fsCc9KRaXjLQbyq1RF0sxDc3Gj6ZTYsDUiyQioVceefVWDHu79e/bImE85VrDMtd9EOWhMJermcqQYahfFTzAMfhYgi4PqpA8fgz3EARfttJXHVzgqKvvrpOpHffWPru/Nf7+Bdwyvm8zaaTxuxQOKxwHLrikVF3YcB7clUhGaTDvdbc4yiOcSmIOhN2I3wi0vCf73/3r+T6xYth+DVpai+904ej6g5PF0lUbYPxrAzPRD5WcU5WrBma3pIUrvqlOJfa0BWkeYO3qDFpJgBM1Ll/OgrGVIKJD9+X2oawlkip6TTdAKUdpnuzNEsOSXIfOKBCtyVnanWjnrNCedikWyCJlQO5dm3y0+NKQjmulnoxge0FhPh76hl8JHgGu2OhO4iy+d4hrwuHx5RSBZtcY1Ya3mPKzC0vM+5nsPvWozOTyFU8hZV1XFsTOJgwQadyJYS7E4L87G1hGGmeG6H2VXTPIDPYv6slTs7xbG1filJ9SFQNFYRv6dIXVbtwYtH3IM2eDGMpj96IwQJSugwSx6LUdzKQXIbLN+sgSyzjh2fSNgiYQcIJfSwapBVu2wbWL0BEcmvkxewhFrHWaySPA56vETilJB7w2cUTI9H05VJuIzidUaCNDXFor523f/P0N2Y/WBPgQ5K+5b3LEQeRZifx3p+NJKwutZ6BkvhwEDybbsz9BNKdj1SuLGyU9Y5Y339IlcjB4boNefD0CmN8QDiiBJHLxCiQfFc+hlaGO5hDOSbrz206bP+frcHTDj+mOL9RiJ4CG8NMBAFHmpPGxCGm49wHMj9ry7Ng=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(52116002)(7696005)(186003)(66556008)(36756003)(8936002)(26005)(6666004)(1076003)(8676002)(83380400001)(6486002)(107886003)(86362001)(2616005)(38350700002)(5660300002)(966005)(6916009)(38100700002)(103116003)(4326008)(7416002)(508600001)(54906003)(66476007)(956004)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?960MwqIPE3LnP33F2GFwxUdTqkzamQvefCDx7S9Tn44MNnBulx5xkb6QZWQA?=
 =?us-ascii?Q?zuLXV/kal9LbfkYErh/grHIzvxYEpJniqwKo23F8k0/SjVF7yNXx6+o/kusO?=
 =?us-ascii?Q?8mQKfOEGCqHUWjCDddDSAYnMtdxgku5FEY2fWsaPrJy8iBZKFkilnZvr1g7S?=
 =?us-ascii?Q?Xq0XyfmOjE0X1DACT7QXfDiWrmZkYTDdF4HamQsELw7QaRtq4z6xfUABBC/d?=
 =?us-ascii?Q?6RTYpfdwmlg39hloB8Rj+63T55NcCG21bnRtQsdvhoGWs2gZEzjPUlgjbALh?=
 =?us-ascii?Q?uupXO4Ul9X0CQ2d/oSjyOvLxXPalnZIaaVgjHDDyvlkChJxPwfLc9Lr/8F3p?=
 =?us-ascii?Q?35aD83eMOwB4l3empXJ680KYohagJi3wTNkhen0O3XVsikil24FBjzsy3dIB?=
 =?us-ascii?Q?3SYDWo/LKcyXbQqUZtyqc/GZSlrfypd7hnJmdjRzchByu+NTqFMyi5I3Hchg?=
 =?us-ascii?Q?flbntcklnYAUlO3UFl11aQOSxoDnjAEqYZRLaYegw4jhhD5thOMQFLT1jhI8?=
 =?us-ascii?Q?wr9vkW/SlfWs8QIR68hDqc4OtrnyCZ7daidmdTgU5orhDqHq4RMERSy6T/cv?=
 =?us-ascii?Q?gYfM3zGFJDw57X3aaCKu/tCECsZb8gHxpZLya9Y6TquHyCswCPlJZIYNHscL?=
 =?us-ascii?Q?za165S+7FzZd6JWMtIN/WUdU6uHtf/jD5+St+i1QBCcnELmEoMEQLaf7lCz8?=
 =?us-ascii?Q?kc/mS29gMR0CKTQOkUi1Zob8DtsEygagxxHGHDaARKwjMVz6E1q8Dlkl5O0q?=
 =?us-ascii?Q?GSP530spZMNSmNuEaFnpewmGaqQI2ltbx/WoV4kmLYNVFMjx9Z92dNE99dNg?=
 =?us-ascii?Q?5uNPG6UmDjAcqo+QTjHHNI+Y+KQ7iElhySrNx6hYFVI+hfGhiu/WPwKYeJMz?=
 =?us-ascii?Q?fPuS/oC9VdTo0eNiMgeYLIt9NoNhDT7Got+v4+cMn53mzzOCUoSDYqybch23?=
 =?us-ascii?Q?VmATBlj+75r1JZ7wSFippY2PKnYPsPx+xQwtFPnYXMsDfrAWWszk6fd6DX5w?=
 =?us-ascii?Q?swrY/IPhT1N+Co/jBNk2SalZVjidAz+Ur6pXhOZwWbdaf6ZFnwR9IwYXt0Q7?=
 =?us-ascii?Q?4BvZSfHFNuPxsmGoCssj7FJkww6eOfOoqNR51gZD36g+OK/nVaAvx/HDDH6A?=
 =?us-ascii?Q?d6fvkctLlnp1lpGwkYwm9ZxwfKgZlnARmRuD4/QpldbIwVC/jE0wT6XyPs59?=
 =?us-ascii?Q?Clc6QLdionwQaQInmlNvdHyL6oTCJ+2lIpJ5WNMq7nezn5ZS2R+tfyyNWepy?=
 =?us-ascii?Q?p3fuXHzHmsjoVjIeA927c2igaWWkBMa0fKorbrQXvNbl3jN1sEPGEEtmLjQ6?=
 =?us-ascii?Q?8+elgokGNyyK7+WgsteiDomnFULFWRqi3sstlXmEp2JQJW3R709Q3rSZRgky?=
 =?us-ascii?Q?82Lg7q4faRWW3Y4xmr77+huYpQinyaCYiKy+D/FGhzMgqYP3whBmYDxwr0NB?=
 =?us-ascii?Q?IN3vKK19CaKwglpS43OWtpZFyOgan9uYoYhER3L1ZTAST+mpxA8Qe5acpTVe?=
 =?us-ascii?Q?86i1RJTRWoDvn+hlvRfGrH3OzwjQ3ePlXgNN1Bi0m/koQQ8W7hp+o622h2FH?=
 =?us-ascii?Q?cT6YcdnY1zZRnIevQ71dMirSdsDZMCz7Fxa/U8yjwklZwci2ETXfvdxMsE+t?=
 =?us-ascii?Q?ddUyU0M+hRmWu4KXXv865fL1Ezyqdmw0JveKL37gsxUK3GpEtrEka9r1WyVH?=
 =?us-ascii?Q?q9CN6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 066451ab-5df8-43b0-06f3-08d9b5d4a5a6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:45:16.9732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1VSc3A7Ah8TIURDfu8b/T7monYmaheVErHBJJfTev5bgXG/NIlfhIMfAvFO4VOn1QvxUmpKyJYEBUPUb2+qRX9jZkhrGm7Kt99ASC3jFPTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5186
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020130
X-Proofpoint-ORIG-GUID: -Kzt_InKDDa1VFU6LtEImSOEriiSRSLr
X-Proofpoint-GUID: -Kzt_InKDDa1VFU6LtEImSOEriiSRSLr

Use the newly added compound devmap facility which maps the assigned dax
ranges as compound pages at a page size of @align.

dax devices are created with a fixed @align (huge page size) which is
enforced through as well at mmap() of the device. Faults, consequently
happen too at the specified @align specified at the creation, and those
don't change throughout dax device lifetime. MCEs unmap a whole dax
huge page, as well as splits occurring at the configured page size.

Performance measured by gup_test improves considerably for
unpin_user_pages() and altmap with NVDIMMs:

$ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
[altmap]
(pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms

 $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
[altmap with -m 127004]
(pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

.. as well as unpin_user_page_range_dirty_lock() being just as effective
as THP/hugetlb[0] pages.

[0] https://lore.kernel.org/linux-mm/20210212130843.13865-5-joao.m.martins@oracle.com/

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 914368164e05..6ef8f374e27b 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -78,14 +78,20 @@ static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
 {
 	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
 	struct file *filp = vmf->vma->vm_file;
+	struct dev_dax *dev_dax = filp->private_data;
 	pgoff_t pgoff;
 
+	/* mapping is only set on the head */
+	if (dev_dax->pgmap->vmemmap_shift)
+		nr_pages = 1;
+
 	pgoff = linear_page_index(vmf->vma,
 			ALIGN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
 
+		page = compound_head(page);
 		if (page->mapping)
 			continue;
 
@@ -443,6 +449,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	if (dev_dax->align > PAGE_SIZE)
+		pgmap->vmemmap_shift =
+			order_base_2(dev_dax->align >> PAGE_SHIFT);
 	addr = devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
-- 
2.17.2

