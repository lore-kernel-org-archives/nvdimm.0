Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0152C80
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:09:24 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACER7J6008739;
	Fri, 12 Nov 2021 15:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GNQT0rdlCOrwq/ZrZF16oWrUySXVl5z5ltnGWNuSce8=;
 b=0zdRTGXFE5TrdKW+VyNYvDUEwdRGUpFHm46eNkd3Yxd7bLBRd5uar1SmtpuU78IIjnqc
 S+fVueOKWs83/0pf5FESZHuo/BDeoTrhQf72cgXGlvjp7s0qa0IRpWCXOcKlGlTXhB3r
 H/DgJE5AdIAgC1+4P2c3UCM9YuymYHELZcfJzydgjCE2Sj+yMmV5u76WSfJzghaQD1cx
 6l8rGkd0hWEKz3yKLXnZU5TBGsyijzFsQLfa77Q8jYrn2NhUg95ZNIjFJmkgOoB/1htK
 WA+WmlARkILTMUclR7ocO/AR4DmwXbOcqQlMfBjd+u7vjYjzidrGpn5KB6R8DZb+Tdjr Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9kn51yad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACF6F6f094734;
	Fri, 12 Nov 2021 15:09:07 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
	by aserp3030.oracle.com with ESMTP id 3c5frjhw08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 15:09:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROCLEhUH8TKIVg1698a+9I/4fHjva8Zgp7nYhTL2AHk2NY91d1V0geBE4cs27cQqDJQZ79+3+z08GdBorwp7U6AaYREmHjWjVHi4DYVoBxkqyHuCmrEvpdAhss75YEzPNBTR21N1kYpsPUq/XVrcYp7J+y2yjbFImAEw00VRePHNCfh/+jaeYtpiCxxEefVu50n7N9iUONmXElb2buFFuLGo2S6y8h+WW1FFUgmWQV89b1KyPgHm0utl7zmns2NJnrhP252PXRFyLjEqACjfbA9SvIJcb8+JBEXfktbMtAQ3foUacTnqjA71xxX/JFUIrlUiGtj6/Km4JPVGGReqtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNQT0rdlCOrwq/ZrZF16oWrUySXVl5z5ltnGWNuSce8=;
 b=msU1CfdVqCBPHivMBBgdirlQBl9nUHCwKUUyZDtemi1MHOhOsmOnHsQRq+mvCoYSRIr863BfwIG8VN/MdVBVFlbOO9H/E8MxEIfIIV8VzvIDof+vsTWx68MJuN5ECEdp/JTHc2USkWv2Ef0M1MECrTRWBVeiivoZzmzpx44WbfC72xVY+RIFFnHSp7lABHGApgcymEXxyNzId2DrnMF7cBzvpqqFJDbufdNolKgyExEYob9N50/F1hUFyRMweHX6cwdaiBjcFocKMuvD5vGiW+a3vkTTsVZI64ry0qwyi2KOCBBo5DGL/04GKQmEl7KNyXBuQ3DhhnCggO23U7k9xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNQT0rdlCOrwq/ZrZF16oWrUySXVl5z5ltnGWNuSce8=;
 b=kCGFXtUtwuBDBm4ru6tqljR/5tOO07VU1VjHACcOeFFsRkjAL2lEdi3dvSfsUELTsZ7yUbe2S9gJ8fKwb+qjsBXLvFXPry6nP4o+HpYdmegZakLy8eEitfp7qFFynxTmrvEKoVrgsxCDSMQkb1KJ8y0osi7BvcDhZcz0oOMffjE=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.17; Fri, 12 Nov
 2021 15:09:05 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 15:09:05 +0000
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
Subject: [PATCH v5 2/8] mm/page_alloc: split prep_compound_page into head and tail subparts
Date: Fri, 12 Nov 2021 16:08:18 +0100
Message-Id: <20211112150824.11028-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20211112150824.11028-1-joao.m.martins@oracle.com>
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0134.eurprd07.prod.outlook.com
 (2603:10a6:207:8::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.9) by AM3PR07CA0134.eurprd07.prod.outlook.com (2603:10a6:207:8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.12 via Frontend Transport; Fri, 12 Nov 2021 15:09:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38c139f9-0d7c-4f36-fb5a-08d9a5ee5dfd
X-MS-TrafficTypeDiagnostic: MN2PR10MB4223:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB422329E0D012F171EFC4F920BB959@MN2PR10MB4223.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	RdQ60aP6orIelUOzyoIsNqcpQLdBiG/oBJg5U/NXFWUSdPKuRgFrlFRP+YoP6gQuAnN6zUmx64NfDs8eDGKdgvSJOntut8UP93hLE+gzNqgvCflhTJRepjwJe6PD7HLUxxUw+crCqxwkNEBL1RAcfTY00mL6fTWEOsONE6YOW4pCVqyqv3x6UWQl4Dr4Shd920bSvPaEUk8yJPkSSFQxkSJkaenxWrunc5JYi/XHnNezA5UURphUSOZfPCplKB3CMnonWAlIUuow1E05rd3fw+KP8i5DjeSSEbxpFlT2nIm9EzJY5x3XcOSedqA/8smMKnNYKLOYRlbiJffszqWJJHd2BI9egBdtY7v4dVa5mdzhItcmHueCj24GXhlVD+AEJYIV3XdMPk4gXCfNA4ZLZuo3PHEiq5C+uYiCIARapJXN3MzyfirdGn68zpbmuV9uVb0YcS9W824VPCrMEAhG2W+62IGLkzWvBk+SmwHYwQDbRHGMsdBOdhjkSRA2V2JR53sHlR3uqpckjLO8W9++ueVbE1j2aPyXRGJY/8Q3PhYlCUZiFktFB+do9Zw1CairJMTcjVf2SgJEnydFJn+HF40OZbonDm6qzrW2lTL2VxxMoNrY2pvYGBevoQA/9PQp+CBReqCy2xKAm4KBr0cTkwQga+Vg0MOV/tlqw1Gh03c6nQrD1QFZFLtctpikCefriJyOBswKiaNKR8ORBlkgiw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(5660300002)(2616005)(107886003)(2906002)(38350700002)(38100700002)(66946007)(6916009)(6486002)(66476007)(54906003)(1076003)(66556008)(6666004)(52116002)(4326008)(8936002)(86362001)(36756003)(103116003)(186003)(316002)(26005)(956004)(83380400001)(508600001)(8676002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cLrKldoK1A0VG31EAZEgFDwrbjZ17MQWrMR7IBpjtkbuOpnGU2pMniEOKIg7?=
 =?us-ascii?Q?HNDv2UOpRRmtOd7m3kpbWZ2Ny8jCqwKBFPZHypgqJVzw9+RvgpiCioUiJLkJ?=
 =?us-ascii?Q?Huntco5pWrNVs6GkUoci41P7PMnZCM/Wwrr02UZxvSqWXe/LymmFTxW6ISr9?=
 =?us-ascii?Q?nhIdeg+KMpyah3xEMVt7eZuQdxRNiN+tUQ76/jImw0v/UvkOvY3o4D3Kgnmu?=
 =?us-ascii?Q?CqKM9ClH1VYJQH1gR1P5UR/PlxpavSOX/U2ZvETt3grtbXDgl6nfa5xMsR3y?=
 =?us-ascii?Q?6waLYW1pkxMyJybZmF2G3m8Ya++OnpWQ0Cf/QoPxsbFwtVpx2Whv5aWKstHs?=
 =?us-ascii?Q?/+t6S/kSrbAxizsbuCD4tXvrP5Y8IedyDF+QAtawBRXs7gihJbto8QefaEan?=
 =?us-ascii?Q?iWsdLH1rcnsD16Kkl6t4hj/fosSSzxr1i3vorTXUeIEuBftlaAB6OoHEIIfe?=
 =?us-ascii?Q?FD0iQcWHH0sBVTILofkQTIiDMOQPPt6EkZ0Bglz014gmLER+dZcpNhY7I4Be?=
 =?us-ascii?Q?6OR9+iZC+M/fA95JgF5DazhXufzDCYWKXbZtbT7j8HXuSHxV0b+WvQnfLQdY?=
 =?us-ascii?Q?rZSuvu6PId6TbFgCp/zb3kVbLu2Zvhd9YmQrzdG34sDCUWJx8q7qexFWgxtO?=
 =?us-ascii?Q?LINQZJ+GaAsH0QKExdU+C47viUHfy9E9aj8XhyUwWx7j/XbdknlNhM6EZyKo?=
 =?us-ascii?Q?GkVkRF4tFpgW+rkRXxZ4KZJ4KVFiwqbjZYuqZ1ZWo6r8NyB9lRnIICtqPNVP?=
 =?us-ascii?Q?mL1vKnCSN31qiA2NIPFSA6JJYCSJlPgsajY4T7eNCO4IH4ifGusqSxo0Ld5i?=
 =?us-ascii?Q?IOiOzUpYJ+Pp03u3+oSiWAFA0LKgHKgO63+r4y4ZLJjqA2ZVfSkrZq5pD25c?=
 =?us-ascii?Q?ywnPDxYprd3+luw1dJPQstGdy4dTy9e9lqmsV8p/KhVYDzG5z7f/AFeOY4su?=
 =?us-ascii?Q?ude/PKPobX8QcOvPbPVzcR2mYlSjMEuXVUfbVgeTSgcnOa1ZOcE+cq+OWqNY?=
 =?us-ascii?Q?0gw0FzaUTrV7ox5s1esTBxC3tQwpq2i7VOIZhuu+yiso14wY9wztbZwql4cu?=
 =?us-ascii?Q?PCK+ujGMkaOTCGIwb/GrFVXf//nuN+XhhsY0FpK1tJoPnk8eL3hnOHtA7VJu?=
 =?us-ascii?Q?ynPHaKNFSsVklb0LEdAkBEfKCuOJWvVWvYTgs13SkDf5kUjmjcjovNEDgCTo?=
 =?us-ascii?Q?AqYWEa42sKYzlinakUwgd536pFYQ4jAYdcJqp09wQ0jN4y5IZDBtK4meiNwi?=
 =?us-ascii?Q?nPrjCtdbZsqaJ+RUZNh+a4IXyf3ETM/7mE2kmmvS8+ZKZUVk+y+u1ebMxWeU?=
 =?us-ascii?Q?qXRH8ozix80gx9UJPLCS+6TbLFJl3Y0yty04CeJFizAcpsDgf9y7mVP9aE5U?=
 =?us-ascii?Q?8MrSPJ+ekrD8qS5rgBO8tcJngwQ80CVO66m7CDzqyQjPGDb0bHpiJkWJI5ub?=
 =?us-ascii?Q?ET1cMxTQPD3NDXnCRBgvWERw/Es08QdiLMgVu5WX1cgesc2f+Dd+3Sn7dwmU?=
 =?us-ascii?Q?2E46ehkoylIIJQ2rFTK1l+Qn+cjNJlW5f7LOvpu7vVE/6plpiCzzROAQGruN?=
 =?us-ascii?Q?mbG/ldRDR8c/qgCF+S62ZZleJn/38dk4TFWJRl8xjdqhWPljBbjiW3TjhiT2?=
 =?us-ascii?Q?TCGVK7eFnaBDIqBgP+8NqJuRi15HESzNdXgiXvpfkiX9ITwfEUzJxGtxyxGU?=
 =?us-ascii?Q?XmLPiQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c139f9-0d7c-4f36-fb5a-08d9a5ee5dfd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:09:04.9830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7NXfJlglHME6v2DWjFtOx7e1hqSNK/zynFhRO2S3YO554HQLUhoI+qwnm24NaRBMkOtn7X8ga/oVl7d7QhFdQCkaHVmCrtQ71Ojxsb8FB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120087
X-Proofpoint-ORIG-GUID: GJtNzXO6OKfVOKS6ky7CuWHczRdw-WsU
X-Proofpoint-GUID: GJtNzXO6OKfVOKS6ky7CuWHczRdw-WsU

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
index c5952749ad40..20b9db0cf97c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -726,23 +726,33 @@ void free_compound_page(struct page *page)
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

