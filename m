Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381942C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 19:10:45 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOIFX8J026943;
	Wed, 24 Nov 2021 19:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=saJv+cmeXAb0i0lWCjomZjHXAEdm0lsOILVEOBAAS0Y=;
 b=QZ1eo1SDS5zneVwhcigw763fgsMtNDbUkTb5+CMYSwXbhMxCTkFrmG2vZ6eJ+rmkLt9A
 Zu8OpIqI73T9SrdaG5ybVbiNsKFvFCmMDxYQmlqvhn4CNmxDRmpcIyR1JbFP81SItiym
 WF6VqIMMvvCfTEt4P7pPIGlZYfTWwxIovWs5aUKW8vcOCT/s8Uii5ZrYRH98bDGYw27H
 5jIzXrI+1AFa3XBNNaNFjcByl8k7O16UdPSR/h/svw8NwutuyemlsHnvFZNaw8HBtqjw
 coyIwKqvY03Bt7aZ8igDdYCUpPrTB6L0tMBTXSxKpUz4RV8s1FUcqXi3PdnyBSx/zTwT lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3chk002yrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOJ1GW3086978;
	Wed, 24 Nov 2021 19:10:29 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
	by userp3020.oracle.com with ESMTP id 3chtx6hcm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Nov 2021 19:10:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzK2Aa+qHqFMjSZdeZ734GxXoo6b6AuIo31fsQlAidL0xM6CiUA8P394KSNzjwHaIaugQR7OIhR1JAIxCRTnGy65EZrdixzex8M9aq6U+7lv9rbjeqAD0mvgfVOrQ4Ig0goKKClFSqh1rcZ9afOW55vL5wCHKRIBcnEfvGfZyPGZwiqTV+/xBAZCmlNv0WsBY2PU4Afp2tOTAh3Gq4UUoICJc9q8gBCEYjay2oKcINaHgqhPsh5m/Igf03fYp7mGtq0e+uGrf2tfM4W1kX+pw1UtFfKut7iPNTTby5ehzo6k5NBJY0a5HnluvNpAUbfO+CL1SvhI5er8QXBYCJzBKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saJv+cmeXAb0i0lWCjomZjHXAEdm0lsOILVEOBAAS0Y=;
 b=Jd7CQ9md7QmMwSRdrrfu0d5ZZqTSID2SRAmF4VvSoF9WF7IaaDozvuh0UKR3P0XOIh/O+n1voP2tm8Do1V3zC/ogufoeoMdUFgn8L60sxmDVF5uoHZstF9iysCbCWu6j2eJF0xE0eplQcwkYilPoTghq/HbIhJk2zsCywyPifx35GHP0c/ZcMIYItHZSeXHowGUSjiQxLAtFxSByUb7km5c9XnfCB5ki5B0bAJUyJDL1dNFrNkMmpDBjmCsOifbXaZrnTKBzfjyg6cTHeCtBnMSRP35h0Gf5o0RSp2EkXuKcrdkitEW3cFeiioVrxLX9eTteKBjbFpuH1uNfFA22wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saJv+cmeXAb0i0lWCjomZjHXAEdm0lsOILVEOBAAS0Y=;
 b=rpB5oNc/Y8MKUS0vgdbetLYTPYXXLjJX53K9aNod5RoHL5NAjz5iAyrIbtTwyUyhNm9uv+VTd6VBpchcU7avM/SjnJe+lvbZELF/UhlB7d1ET1Nw/aHar0nJpuhYqbF8lgvDbC0sk2NasOsqfganEp3V6JG+WHaEkiqpiNltac8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5234.namprd10.prod.outlook.com (2603:10b6:208:30c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 19:10:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:10:27 +0000
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
Subject: [PATCH v6 02/10] mm/page_alloc: split prep_compound_page into head and tail subparts
Date: Wed, 24 Nov 2021 19:09:57 +0000
Message-Id: <20211124191005.20783-3-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.47) by AM0PR06CA0093.eurprd06.prod.outlook.com (2603:10a6:208:fa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 19:10:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3887b772-c393-4973-49a3-08d9af7e1315
X-MS-TrafficTypeDiagnostic: BLAPR10MB5234:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB52340998D9B64876682C585DBB619@BLAPR10MB5234.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	smffKBOkvlu32MgUznUPcB9J186T194XFZi5zs8Ad134/puCvlgvHnsO+YlscQj//wsyy7KROxVv/KKRJd/Oc2NVMjamnhZXQIQy9OIJdTuYrmfqZiXSJdTtYm4uD59Kf1TxntuFm2YwN8jqZ3NQV+PeRPlHjLOO0Vyx8JYlBFu8/fadAMIbrL8BbHfhlDdG/998Vh1YM8VFKVc+3Jb9NyjS0JrjK4dtsw3ve6s+IHxWJ5twBg3pga/9embFU3fxq5LDj3NqOjF/u3K42KSaEgl7tyyHFkrInJ+5W/1kC+vKKJUZW+Z+kXGzgasY9GmKJ0+8WHbSRdUSL7s1B9ZBkBQURjTHXrAg7pgVg2CGBUDSt9z+qW7HCQ0/llHJ2pTtQp4ko+tvvtgpZ7a4Nq++B8MbJcq+GrGOc2aeDUm2vbytXLigiihrmROSkKhU7lt3n20mTnQsMGF+FRbg13UHWZd3a74vrnwBQjs3hswp+5y5t4sf1t/9WYdFQKzVg39QgrPwJXrFEEqAQMj1FZ23ynTT4JvXFGLdd2Cnf3c8Xn55C/SLupMtT8GgnyfSGT5Teo12s8HazDiKzlphClULtSY/iylAsooPRS2IVCuBul8E/RVlviHpVRSPTLmWfrK7oVcD2uI1sgR3D8HsH4ScdZxJanb2dwmlcMntX1PPR+Upx6/LCP2xNErVtxX9xZvg5KrrL5leh7vLHuGcDq0f2w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(26005)(7696005)(83380400001)(186003)(6916009)(103116003)(316002)(52116002)(508600001)(5660300002)(38350700002)(38100700002)(107886003)(7416002)(54906003)(4326008)(86362001)(2906002)(6486002)(66476007)(8936002)(8676002)(66946007)(2616005)(66556008)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?evtexMtXHs12rZUgsw3bj3gSqtX4U9tQt/zu7zNNVMQjlymynKoGJqNWahvX?=
 =?us-ascii?Q?IUDFAgDgGIESEHAZqbEBY5qYLImjLQd6m5hS2/QUEKsuNMxWr20v/eZnS8xU?=
 =?us-ascii?Q?vwONpqu0V2FcJlyyE1LVaXNC9UC4dV3yjs0jILUCfMPpmvWcCszZGsbLPlOd?=
 =?us-ascii?Q?DJ6ASn75ROUqiuLQR9WZn7zWc7Ui3A7Sx2hv3CgoBGvXvIUFTRCxza83yJxS?=
 =?us-ascii?Q?tFlthEyDHqPs6XVbNmR4cu5fLnC4Xaaykrcf/HU4iwsb5eJiaKYV+RfoziX7?=
 =?us-ascii?Q?DmyGV/tFPHHW/w6AMEBqBJS/FBGptdwwPewhsfTCHEMr4QPicDTNGPvFsn9f?=
 =?us-ascii?Q?RuT95DwBo6g61Z7wDBy4RKeZHF/93HKVVxQqYArP0BuzlnwDoxUeQDH/Ma3L?=
 =?us-ascii?Q?nNcvAqTAOIaOBx1lCZBIMlWiKoESIgmbutae9N4AOLo5nEezS7d8Q+Wxcfqj?=
 =?us-ascii?Q?J4zt2xeewG+VJsuabbha22qE0qUyFh91GkVCroNfdnd/M0qP/IZpvVW5wrfr?=
 =?us-ascii?Q?/65nlDIjhyo9EEPHVv+nx/UL/83/V1r4GTmNyPx3X2hPJ3QAt0qxZFmjTlkZ?=
 =?us-ascii?Q?DOxbW/KNY69OKOsIRTrO1l3Cxdk1Gn87XHOYG/QQXj/DBk4Ti1qJm56gg7yn?=
 =?us-ascii?Q?y1h/oFmm8ikrffJt19ZYK9NkG5o0TjVvAq7Cvc92v/2Uub2nvC732idTaXsa?=
 =?us-ascii?Q?ZwmT5JVEB0USg4d7jyO8cykWrrMJ/TGLbG+6IOtk+tO/1Pan7xZhAVQMGtbF?=
 =?us-ascii?Q?waTPzRL+quP+8G5a4TAzogpMR2LyN1BMlnkPeCybjesMrcM+eeDpFi8roN3h?=
 =?us-ascii?Q?YHpxlvyKepRl5GNp2I9wOHHzBtIxFc3qkRTmN/mUBzDxGYbPHz7xZiex+0Y9?=
 =?us-ascii?Q?bLrgBDndZbOIvOs1bKGr50bTeDV6I132Vd+DmRe2wIx+JiiN6+1+Ry1XT6iX?=
 =?us-ascii?Q?GiL64iokwCHQ/Hplbm9+2Mn0lPqCv0Ldu4s8XIM3+eWE/7BbSnSFElHOC4Tp?=
 =?us-ascii?Q?0n3AA+cVHp1M+oR8GrbhXs7Zxekrk6WJxL7J4u+5Ru8k1rCrvDvqqI1sTIhw?=
 =?us-ascii?Q?fagjkqQZM/d75uO2Mr7asH+M+tuVUjg8t4O8urQPqXzgiloPrbuQKik3kXOw?=
 =?us-ascii?Q?hYj0p2R5pzYYEramijRSc7DpN/ucF5yDwCHRAPZAGMM3zO8B0qU3OdNqM/px?=
 =?us-ascii?Q?xfSdP3v5kIFDYsCSH413zvWT0OWxp4fyD/ocmY8kwjPZDNxAzY0BEzAxTnTf?=
 =?us-ascii?Q?ZdQ608cOMTf9FqsyFFi1yaAbuYrBRLupbuB8wEHOZDfXQ8LPIWKM4Xe7fCP+?=
 =?us-ascii?Q?iNZmXv0PGR7D6TBW94j038ypV+vlLZW6Nu+yKk4pn2UFb6fPXCdL2c3UWW1C?=
 =?us-ascii?Q?XQMpU+SasHHM0f73aeoz4iLjjCOIS9ASy9RrAlj5fkGN+IR0rjLKN+Vgtt/n?=
 =?us-ascii?Q?nJV1rNkcD3o+wIGtTxw5An7zIz6+6HtmRkaFMKJSwS3xwjVvIc/5P1RQdlF1?=
 =?us-ascii?Q?euRB4eJAFU6djZyZKJHGjASxCrPiAApKrIsm5T/UE3lLq4qPSnoLiDvlOaWy?=
 =?us-ascii?Q?QT8jtpCv+tezFbzGTK6kXAPL3rLpQndU7NX1OF2NKBV8aAcKoP6bn7TX1fqS?=
 =?us-ascii?Q?uplBOZcMdZB7s8QfwAvmheXqj7YKFp9bmGuckuB18l99ZbFOmpRMvCqu02VT?=
 =?us-ascii?Q?As8BNg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3887b772-c393-4973-49a3-08d9af7e1315
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 19:10:27.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkIVS71ixA8Y8jCrxdMYCQaSz60W54sMJ36e7UMd/OERoiUadEtCTIL9aSLO7SBX8Wj7yswPfMmDYmbIPFt3WwGbf+ENPfSthpC6cDDMYIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5234
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240099
X-Proofpoint-ORIG-GUID: xKOlgitcew2J9gIz1o0R0S36rV4MV-lh
X-Proofpoint-GUID: xKOlgitcew2J9gIz1o0R0S36rV4MV-lh

Split the utility function prep_compound_page() into head and tail
counterparts, and use them accordingly.

This is in preparation for sharing the storage for compound page
metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_alloc.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 58490fa8948d..ba096f731e36 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -727,23 +727,33 @@ void free_compound_page(struct page *page)
 	free_the_page(page, compound_order(page));
 }
 
+static void prep_compound_head(struct page *page, unsigned int order)
+{
+	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
+	set_compound_order(page, order);
+	atomic_set(compound_mapcount_ptr(page), -1);
+	if (hpage_pincount_available(page))
+		atomic_set(compound_pincount_ptr(page), 0);
+}
+
+static void prep_compound_tail(struct page *head, int tail_idx)
+{
+	struct page *p = head + tail_idx;
+
+	p->mapping = TAIL_MAPPING;
+	set_compound_head(p, head);
+}
+
 void prep_compound_page(struct page *page, unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
 
 	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
-		p->mapping = TAIL_MAPPING;
-		set_compound_head(p, page);
-	}
+	for (i = 1; i < nr_pages; i++)
+		prep_compound_tail(page, i);
 
-	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
-	set_compound_order(page, order);
-	atomic_set(compound_mapcount_ptr(page), -1);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	prep_compound_head(page, order);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
2.17.2

