Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1F03FC2
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:22 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWLfU024925;
	Fri, 27 Aug 2021 14:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=N1ejeuFkXnP7EXDM3V4VZS+JdAbvmrAUrphHaOs6m34=;
 b=NVuBGvSaVr/MMGvU/JylBbIjS1F0uOT+avaQSbo/dMZgxFHgc7J/cSGf4l1CNl8M5ORt
 /24yExRV0QH3Z6mtJvgFom3N6MhLfFU9rZATMob4/v2YknJzAIuqsjV+maCnPWLxkj3L
 96ykiIkJp0Gh7sQF/0cyT7f7k0a2DoneyAQUydyGB/34mbqZpWIF0NuCRP2so0URmR37
 NQ/ACJ5dQoep/5rNxgim5QrxB5AQ3pmYXL+2vBFgWF2+Qp+kY3uomqyh2Eak1kMv2J+x
 wJNWjTWCdbFCTbEdR8KzO2aycd18Q3s7lBiVjJKGxqtt6m7Ce4E7AvwqLoR5CRS0OXNc 2A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=N1ejeuFkXnP7EXDM3V4VZS+JdAbvmrAUrphHaOs6m34=;
 b=GlCVDRTfsXtxPupUM9gk8PVy6PbngV6p5GxhH20n+v828/TTL5eiOgJKe02OyPwZ3xLc
 npKeZ+CFCxV6ST1bUDweIRt8qqBJdekAe28T0g0TUXRDZ2Qf/pG1cLWFVLtTO3OkN1eN
 o68wPY1JR/jOgDvncDQsRHQrn0e/LrQiHrcoXJBkw5jBb4UCtzsjFFb50ASOtBwFRepz
 4p/76ODj1VOfagBActRzx89DVJRGrwcvDCevVn+9rpskjDyghsQsw+qK0ol4bJg7n4i0
 ERQCHveDC4WqaKzvdvdFSXLpcE1OXN42updBxqyIXUZ+gUyCNVGRd6g/jEbbf7TyU7C4 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4xv3s22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpPbf187140;
	Fri, 27 Aug 2021 14:58:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by aserp3020.oracle.com with ESMTP id 3ajsabbqag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clpfgj0NO/fk009c6/cCBtOapp0B8/e72u/gvzyS7yoM4a8MpcksUOJjztqga5+NJI92LkioU7+fKDxFxYXh9JvVQbDCRQ6DFXEmqbYzBwEC2TFxq8Aq3BLXKe2g8YTfTW+0Ky0Nysv9ZpEmGWoF+wdb7WyRltr+zXrt8ZHoua9o8CrdHHW0jiOaUxF7yKuZ8NyCsIy8rsLxkF19qL0/vg1vLjpIumCLpqtqasIWS59IrHH0y/ko1+4kVKkEp5r9+091kqLPyULgAB1B3VOYPoeMzJQXkelLz9AwuZ/meHLM14zrqy6sC1kdvFDTaz+03Mdiu1ucvlFHBE8oiHGRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1ejeuFkXnP7EXDM3V4VZS+JdAbvmrAUrphHaOs6m34=;
 b=eA1XFZDFkMKmVgo0ovOZJ1PnMlBLYLCFr+EvMNbGEXgvpG0qZkx3e5VTZZoPEZ/T4oXvvcxtxJfqKPGKcpG/YpN7Vn5+mqL3LJdni1WH6m+D8S5N5rhTiN9lnYfalCSXTa6+49BKcgw/wYZ6fekj+pn+TQrZFVtZr5ANEMbMkk1+1Tt9bbKX1tVbbqxKfCxey1a3r99GUFkHnVcHIuNLq+I3jwV0LznRx2mSSdERcsOHXHtY/3l0XwOciLV9WSr1ws0qqmG5W0QtmgbK4x5acGhbChyjrdyIpBjj82mt9XWAebUloQy6JzwXP+x73EjJ19m5nL51umPX0Kj+izKdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1ejeuFkXnP7EXDM3V4VZS+JdAbvmrAUrphHaOs6m34=;
 b=HLKy23LSaF78eNcNX0Y8yDNNfrjozLTMrvXuclF/741Vus+p6iXTcOeCMJ0eV2kmGOTk/pWZ6uyGk0F3A2S1jhoOuJEWUbjcqmSzIrmVZ4p4FvzA0qwrj7L6pHQLQPYNO0ls9GUOYtEP7XhOzuLw+MxSolXZwqpn22JOFBzT/tg=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 14:58:45 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:58:45 +0000
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
Subject: [PATCH v4 02/14] mm/page_alloc: split prep_compound_page into head and tail subparts
Date: Fri, 27 Aug 2021 15:58:07 +0100
Message-Id: <20210827145819.16471-3-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c71d9cd8-ee23-4d62-59dc-08d9696b2aa2
X-MS-TrafficTypeDiagnostic: BLAPR10MB5025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB50252AA5722AD524506B7088BBC89@BLAPR10MB5025.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Tc+XQJytI1RY49zXPh2fZJqxEFoy9qHtfRjrLmNitqc2CAebkb+ltu71R8nbyur2dyJJ+PuvtWV99pYzxqb+K+Og7/Y3ZmRAwWRAHRcrHE7nOAHWRnzn6e9i7LCFXDsAA+DJaIwlxlW8+n+YkDKzs/bwdple2l8j/pg3ysk8UORnGHl1Kla57vgIy1tv2RHykwUhFlHZYXbm7ivTwahkyC0ux1jjnPK0gPdG/Da6nw3KH6Y6YwIJVkt3Enkg8oiJrWZuI6wHiZdPGsJWsno01J8t/qzdKHFV4oDDOOeCUeVffgnmE4zCT03RBB6JYWUPZzojgjpXkD7kCnPsOEnale3fJU3389+sfTBBPo84Of4h5wSX0pZOyIGqudzncVAL4jFIPXPOio+5zul5873+uB33kSiM2Ys4v+jzWRF1jifsOr+lqVHl2LUg8hlOwlVjJHzguWFb5RFqacOus2qm5tIffQH9wuUs4rcrEmStHTi2WzjuqdK+wbUsfZVrRfRfi3XidasJM3Xa3cqkyI54tTZYlKy7lVsbA+BKB6hdBLXijJHCC16NIzNg6LxOCKYv8vArEfcUGcpwAmt8w7Cy5btYBh1CdNK2JATHgjrcPrkCNc01x/YXVKoMRJg/WejY+d1HMcU/ZlLRZSRuoNNujyxVbMIw6uEeiklhbHqs/Nj4nPQtg1p/hv8ldPnl4wd6fSwbfeMNwbhygec30yjLzQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(103116003)(66946007)(83380400001)(66476007)(86362001)(54906003)(6916009)(6666004)(6486002)(2906002)(1076003)(107886003)(8676002)(186003)(4326008)(38350700002)(5660300002)(956004)(26005)(66556008)(52116002)(7696005)(8936002)(36756003)(2616005)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?xHj7sspuGFk13y6MqNsB1yu7Fgp9dO23h740t+LqKa2luV142VD8d26vIaZP?=
 =?us-ascii?Q?i7i2e+unqdc/udVhZGpoG9JfG20caJHOwBNpcc8AkzBscAPtYpfidxtxBSOM?=
 =?us-ascii?Q?Te+wHdoUjO5xRjXmIjvDLQ32CGGn22OyqmuSMUjMg0yVZ4APQTaTnqv635oR?=
 =?us-ascii?Q?RMeHvmtR6OiIvm7EUb4nnjJTlp4qZ0R3QyK7GhyQKQL2QcRZKP59XuL5akf1?=
 =?us-ascii?Q?224FIDL4zzVM+5SnUM5jaBSN37Kv6GtE6Og7AU5pfk5lV22ATsglC8VUJlBl?=
 =?us-ascii?Q?9zFNYqI5jmtgBTpQvefXhqDtcvHQ8A2brMN9tpuaeLMGxLvOWlS6yVIH0Hpy?=
 =?us-ascii?Q?0qDvWfwlDleRB3QlNtFOpWt43+E9uywYuSu8o2b2POXBknZXYByDmGUt43e0?=
 =?us-ascii?Q?pudiQYra+0nPa11ffEPpLPN+OI37SZ+pi4f0f1LhgNR5gqwmxjHLa27o2fUK?=
 =?us-ascii?Q?/pMZpGoOvFg4uocm2eyNVeAdRxs7JRPlc4ZxlkuhkWRCRr3IpvGC3LlnhmgV?=
 =?us-ascii?Q?wu7dyj0D6EVDEnjAAPgABUJ8noN+dVxGhsxjusUzJWobhcb0AGB8an5K1uyT?=
 =?us-ascii?Q?sqZv2A02FZL772XuG0evT5qcefkCkL4UEx8Bp3o7oNhXk+5HfSsBGHscEEcj?=
 =?us-ascii?Q?+oOBwqkfgUp3HQAlmsAfhlHta8FuQkpS4s4zQP9JCWC2vb0N3hrVUJUZnSVw?=
 =?us-ascii?Q?noMJdRpJ/qYtWqpiY/JUqWRt86sVRnBun28hMufw7qZnLrfeYf9VNX88zWco?=
 =?us-ascii?Q?UgikyNt9wE9bwyvlxpLTB6QD73icgBjZTCU6KS5YB9cFV8PwnS36EwEr4YJC?=
 =?us-ascii?Q?mjvNlLMBatHPDFb2UplS4/R2ArYGZ3GFIyzmQfFFt6CkOnhNjoonqbxGn39P?=
 =?us-ascii?Q?IDqBzWv1oinPidxPQYEmSGlC1PakCNIks0ThDI5Rm7ExrzGfEju17Mpvml+3?=
 =?us-ascii?Q?nZIB/qBg+6a+bnwNDOnPro5a3UV2aXnuXF40ArbQwARsztooOpe7kQEO1QlE?=
 =?us-ascii?Q?tCujeLH18StIcBFUg/op6I0kvyxbmURZRLpWZMxeu76Hq8vmgmFgAr7nt0ap?=
 =?us-ascii?Q?ldQPaCH4/pcRGq0ZnKh7YYlk+pC5nWm8r9vMuEAw4OSHHQwpCRHtZU3D1biE?=
 =?us-ascii?Q?Zk0x8vqk/UqUyPwnnS70kCUNK8EdaT+cPS6ll2oz3Q8NDq8e8QJXCD7uEKgS?=
 =?us-ascii?Q?0Ai2trUV6VA+jLSXLyjD6xVBJS74pMd755Z6W9usQac+jByR4cBBJXhXHnvw?=
 =?us-ascii?Q?sLSBhb95SXzJsKiRH8g9gC4WxWFsVRiyLTEz5SMc3rgYOY3+WjD/UZp/Xmdq?=
 =?us-ascii?Q?TNeWK8PFLEJ/9xucjvVt81qY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c71d9cd8-ee23-4d62-59dc-08d9696b2aa2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:58:44.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9IoQou7z3UI+n02+zMI7TkO1aWBnGpXN6h+9AXiVzJFXNrfh+ClDb+V64SRiTfBCtDlTE641iXfCPVILc/f3ce/T8cBG+IO7G7ce1svyNuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270092
X-Proofpoint-ORIG-GUID: iQwjjTr-mUINkifZjE8XHLGpR1NVCqIr
X-Proofpoint-GUID: iQwjjTr-mUINkifZjE8XHLGpR1NVCqIr

Split the utility function prep_compound_page() into head and tail
counterparts, and use them accordingly.

This is in preparation for sharing the storage for / deduplicating
compound page metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_alloc.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91edb930b8ab..2f735b2ff417 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -728,23 +728,33 @@ void free_compound_page(struct page *page)
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
2.17.1

