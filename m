Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7285B6D14
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:23 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVWTh022332;
	Wed, 14 Jul 2021 19:36:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QF58l7lLOjz1kbBPHdHIdxCeV2ODkZdvt4bXLCnoySs=;
 b=g2SSLIdzkTeskzsE+vk0hGwkdn/Uwgx0pv23vOVgfZRY0EXCIALfLRB+YDv6Ffg41tfN
 iIjshxBh60Y9U91IX2z72Mj96yLpw11rSJwXWFXZutcvSCoeMyCg4Oz/TvvLs+jUVNHS
 ShN6VpPgBaHLwK4Q2lV9hPDy9+63XZsgaWfpmlSCN8JGmLcXY63gfKOE9UAFVMJd9E/I
 nGgzzpp21z2oVIE5Vb6Bznt8HaQlGMgdXalZvDrDwc09dkBZfYV2oGVHPhhydYECkfNm
 vqt6aW/oNvq1vn3VrL/N9hhKXHVn3GG40G0pyLy4SiippgYZF9M8tBomzR7My+d7qtf6 7w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=QF58l7lLOjz1kbBPHdHIdxCeV2ODkZdvt4bXLCnoySs=;
 b=F2b5PseRbQpjJ3+CnXBci+DtmywG3/E5w3hCb0zlVljndW9l50nJ+RSimX0YihB3mU2U
 HmXSEoAlO3humR2rXWMf3LBumTgUip5hPP7bYgE5Tyj+FZAqGInwJLOttsxOO1gBCWK5
 C3lIMlqi51xx+Wqi3AxYbJZStM1FCEcXOpxjAXwVHXhx7OP7veotB8NKSdnf7iwuU6mQ
 n2NVOy7xX0t1FW4s5Un87F/T4do8UJqohEJFYioy24zRKCPuIQlY6FZhochn9ZSyxDTU
 NoPPN7od/esAU27mIEYLQOVfZ8nAyfHA0hJofoZoTrojDfdyQMn08nKAIq7u6PC8yz7o RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39suk8sej3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJV0dW187598;
	Wed, 14 Jul 2021 19:36:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
	by aserp3030.oracle.com with ESMTP id 39qyd1c5dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbaK+L8d3F2l4Ed8FhkWh5phuPHO+UiFgSG83imBVHpvbg9Ohfg6xIA+0zQVr/di3uwqEJwtDs5Pqd8kvyEaUmtHroMQNhiqrVlxiGHlF2iAvyAI2oXHe/Y6+T0O888DEgIR7jQaqCdJWotFBsSS7JduC9zBnyh+l+Q4mdLAHXtdc0BtgfB0xL52SUiiJhXW4mveb+DwF/YxV4tRnsGU9LQPrdESKyrhzaQfA3MM0r+1wVyYt+pvf8nzG3WFsEW9R3yV5dr5kctQcZ4SiQM0xcR9xIaCuyRQkbdUMSVRfDAWIfsaADYFfUq6cB8E/JzGZ1vApjFwVa+ULCAlGqHOLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QF58l7lLOjz1kbBPHdHIdxCeV2ODkZdvt4bXLCnoySs=;
 b=T/XA2C2NQtpolICafVe9PIO0h2FMa9Z1iF7JzdiB/dUykV2BAzDF+m1JEyCOCD68fsndoPTansLPw6wa0GF2zVtG4ExzuoxwiI+2P/bELTWzIRyBoEq2VAFhkC4X/Y3pG/QJSk+OKD4oG1ys+53yDaosqAy71x3/jgnPOpmdNU9twPmvyTXRszPz5YwknogVuJ7tQim50NXzp/Jxe71LhfHIpxHUo/JQH2KT4e45cjtQ1MTODcn4v+fQtr10RNcQOVXxO4Ik7NZ+b0pyAnT3UlojKTkyCjacqu74T8u2mWcyVFMt067lfhASUnPcz12HvCM2ZFZgX0X3BOBKh86Kiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QF58l7lLOjz1kbBPHdHIdxCeV2ODkZdvt4bXLCnoySs=;
 b=JdjrS06DMzRd+IcKEiZKPBgKu5MR+6qXSPLlE8qgCl9JizgrScyH9r3zjKJAjcaMMaFmgb40GTaaydKNayF49K0hzwA5f8LvDyAjynsN7TSvn5u/pROi6nHO1dbPqbqkDkkqBMeA68MnQemqbEULPB9wFP5CVD0gAG4fsK342KQ=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 19:36:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:02 +0000
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
Subject: [PATCH v3 02/14] mm/page_alloc: split prep_compound_page into head and tail subparts
Date: Wed, 14 Jul 2021 20:35:30 +0100
Message-Id: <20210714193542.21857-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210714193542.21857-1-joao.m.martins@oracle.com>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:35:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f4687b-2fb3-40d0-15a3-08d946fe9d15
X-MS-TrafficTypeDiagnostic: BLAPR10MB5204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB52041E43FF1C7910A15DC22ABB139@BLAPR10MB5204.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	W4402u+lEF6pNB/KvYG/27tem37/Dz3TK4hf/6uOKB7ylMdEAL/7LDqemvBrZ818OLzZGnB3bQvqlZRZQfhVa3z270z8MiiVWjjYJqjeKbUrGbrvt0+jw+/cYwVTPTTD+QJFS+K/ZGsH4dv+f6XVsw9tuzai8P4ngjaTLsoyP2uicU4rlO06BW5qd7oClxCSFq5VrWjoKDIi5FYRjTQhrUvT0yffYkdEWFrr+KjIdkSzXR8l+cfMflzYsqIvRV73AlvrLjVkdECEKi34TTnytsV5tEY9B20Xkb9qT5etU6pScOulpiV2DGLZ/6FZRm3/O2yUIHK4oLCVUUEYGn1urgdaj+YqkHqoLGJ+XtmyEQaB6CN0qGMQGZsbP9H/p26zgLTUfOaISEnkbac3SlgIJs86pNhKJZasNZCX4AbRPaGHki6NjxlMR8ERZOmAcdV2whRhVyofJYfhwSvW3xGjJ5LqGSIO8izchpvGtx+smqriQpHY306O5RS0ltamdWFklZId+7wLBGPys9AirsmjvLT0dybjQGFAJh/Xii/BO4fKbuurpOMZ+ky5YOMyZZUcU5pE0Wk/x9Zix03nqnXGoqsYrTmLITK7m4nzx+fDTpH+PaK+DCnZ6JNO9C+i3AOQMPUanhvweNgxvK1USIispKiea+BAVDWXt8Jy8zna8Vr6XLBMbVS2torS7B/c9se2EXe7t6IDiShuLQ3QgbCTsQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(8676002)(4326008)(86362001)(6916009)(7416002)(2906002)(956004)(107886003)(2616005)(6486002)(1076003)(8936002)(66476007)(5660300002)(36756003)(103116003)(83380400001)(38350700002)(38100700002)(54906003)(6666004)(66556008)(316002)(66946007)(478600001)(186003)(52116002)(7696005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?rGiPgujiS2Ro6sxGUe0C1zPPklx8D9ELJ3+87mvbBmI/9v+Q6dTaFYeypRrV?=
 =?us-ascii?Q?w0qJdXZuobP8I7XDXMuo/gcANy6+OUAzyPfAGyx0M3Ub6s1nUYqB4SR3SbuO?=
 =?us-ascii?Q?EcX9hLqsZ499rO/+02yAv+kU/6w4sdCw9YmOQRPG2XtrELnCCLQlr0nIG8kh?=
 =?us-ascii?Q?hupngIuJaemXoNcMaiJW8oVmQshz/VFw8Qcwp6O+eHlSpHB24k84BFV7KcZe?=
 =?us-ascii?Q?YDjxrXyfwtt3EdY7/2Q6+e/RKObiDRbp827O1droReTpkVdzsmx9ZMdiNFP8?=
 =?us-ascii?Q?lxHoGWoQld0WZMFnyrtfRIJb1WvqgAhKHtQLn183vUnGwGoCH1YWMSRZm6ql?=
 =?us-ascii?Q?WsY56Wzo57ohYKFrdKUcN3reRciPrsyNuxKvSKXqJcRcwnS9bPMLED+pMUoc?=
 =?us-ascii?Q?1xMaD/ZpnYM8Ln184UJxn5JKfKQgJApP4vQcH/sTJjpa2bdoMoHK8r11LrRy?=
 =?us-ascii?Q?aaLUxVHkm/HirJa21qj4+HqS7wR9HFFLJrx+4J7NltX8BxQLHatqQHP5hxcJ?=
 =?us-ascii?Q?86/quWjuOjvQy03JN4kj+IglVKYkGk+9Tx1du7apoUhc7SQNASWcNU+OcUSw?=
 =?us-ascii?Q?8WfWMU6Tk8btB2BlzqDFTtNJPjzSrpmMXfBj/ZE6e5AxaRecJip+3c3R7VaN?=
 =?us-ascii?Q?Rdvofnmq6TOlcLmvDVvQ0gM9VLHX9ZFSihMw5DdchT5uJifDyImeBu5ETXOw?=
 =?us-ascii?Q?hIeORcnsJipiDMDtpHEdcd4A9v9JdrreUDU4H6FUc/Ow5Jb1sfwb01DY+DjC?=
 =?us-ascii?Q?+y6hx7PYsLYKT4YGDdvs9O+CwTjiQR6OCkN3CbbXpjG9S3QVp51wX5vrGWos?=
 =?us-ascii?Q?mbGcLatI422g/bhymzefzZuzNCrK6kuvqiJFge4wz++pZYC3ok4UFolgMMau?=
 =?us-ascii?Q?6as0JuyTnXS6w8fYtJTAY2ulFNqSIXzf1sRmnE1xUwbPofF//LFfnUNqYLOh?=
 =?us-ascii?Q?Fd11O9B/yBdoLBBJjShDP8WwAv09T5x4bYkLXKhuBR0xGQ2mEX+tATR6+fTX?=
 =?us-ascii?Q?BtkGx2FwaS0X7vzy0TybcjG/BhrCNkMFaMXYUGuXpkmLww4NsBaNHqF846G4?=
 =?us-ascii?Q?G4JgVtjjyJk2X/2H613nWgt6YZ7S+scjVs6JCbt2CZEZVIOpCDTh5Jbvf3dn?=
 =?us-ascii?Q?r0wPnYnxMLLQXwXp/E5A6M/Ybz/4vN06GB5qSK7M3kdEVX1UvMytYalr4xSc?=
 =?us-ascii?Q?Vpcop12NdhPprDl3KeJWpGnoo45b7XziNwFw5fUaaVgS74pJl1VUTEhJo/Wn?=
 =?us-ascii?Q?zsFwDe62HNGn5u8YTExJcLbdIB2KCBqwQsV+wiFs/JVnXhUej8PmIVlMWJEI?=
 =?us-ascii?Q?ztFsWgPCTA1kr4sgbFHbVk+9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f4687b-2fb3-40d0-15a3-08d946fe9d15
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:02.2888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEdCe539MzOzuQy6AG0upgUaUH3ZAzDNupiLO0V4Px571kd+OsY9aFafMrA6l1QDDmIvITDtdgrw1L56L3GcaFKPsQ7bFCvIy1s/cTvfD6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140115
X-Proofpoint-ORIG-GUID: mpdWGPn4O0DOK9HHpSBtNXM6pFrP1MKR
X-Proofpoint-GUID: mpdWGPn4O0DOK9HHpSBtNXM6pFrP1MKR

Split the utility function prep_compound_page() into head and tail
counterparts, and use them accordingly.

This is in preparation for sharing the storage for / deduplicating
compound page metadata.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/page_alloc.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3b97e17806be..68b5591a69fe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -730,23 +730,33 @@ void free_compound_page(struct page *page)
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

