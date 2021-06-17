Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EFC2C32
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:13 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIZal9004683;
	Thu, 17 Jun 2021 18:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=FSIlMjqFrKWQi7mpEYHw63HXjrqwPmYnSQoXBdSH1v0=;
 b=vtKEsbEdMuQaX8xtLKfd9jWbFT0uWVX5RPOnp0QYZFKGD2QsZ57aZO/J40luzon2ckS1
 IvgIXAnNXh+Wf6PxsA+E8cOQjp0BHcU8zRt/Nlh/tsuaKlhWMir3jaRGes3+quiyiwUc
 Ik0Atl+aAWd9AaAqctqNHc1pyG9ACw+UPwkOEQVRmBT+RM7kx7UMK3eTNtzGjdGaOWqj
 mDqBItM7faN1EwNdrPBwM6QajZ6Nl53P04miQlEj9kJ/ZLRjYmwmPAJXb8sI+7zPTRVj
 tOgs6fzrsCSRlLckMgz4ZqGu7npTx2psR3nLBrDohbdTB5l97BkJNvXtRFbLzrwagrmH Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39893qrcgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:46:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjZKK180135;
	Thu, 17 Jun 2021 18:46:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by userp3020.oracle.com with ESMTP id 396waxy6ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:46:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAr5Wc2eN/nZYvxHnjGrp+i7eoRXArv1Umqvg+TYGeB+Z5VLPRDH38z6Qw5nRAOXEQpwuaPv+p6gn2hyo87GGylzMGO90dmSaCl+RMF5zZNN+0MunR/S5s89VbRcGYjcP2OjD1DpUhyyrIwtC6IZmgiImVGmrb9bMMVyPwR/1dO3xgi1AuZWH2onUBy8Gmb6ho9tcBdKzlSMzkE+NkES7pxhp+b8fvzh52IaHZEBJM/h/gMaAW1pmXb+VGBaq12xUfpo6veD2EaNr2xUzRlij9z5MgUxrFPECPb2kH2gYi78E35Cxba9a5YzqM2eYM1RD3bC7uW1AOvLVbq4JEVGgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSIlMjqFrKWQi7mpEYHw63HXjrqwPmYnSQoXBdSH1v0=;
 b=QPyt0UKsJJLrDGH9QzaiyeV657lBhAACsjKP1GsDVG/XJe9vYrnewY16sTIWNfY/FZA12QrCdfzeWL0AqIPzlEYZ9eAPpQhX7ReG6bS5+2ibGa+uBhqiR1j2ofe8Ygz3qIcgQ7Tc4LdFbCXa/NnmKec/ZG7WKs59rCKdw1EiI3y2QzsQHRZxKdn+AIbhpNS7hJfL3t7r0isoJ7MJWLZJZWP4xoRq+Xmt836hRaFEMC3zsbebdcu+AQtTPKKoOsk2fflrKM2XUQY2tWCpj/blrzG/nnFiuRrKKkSd5WvQrtF31JEXb3kp2Bt0RyEzFGuqz3bzXYAygXgVuj7cjMkc/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSIlMjqFrKWQi7mpEYHw63HXjrqwPmYnSQoXBdSH1v0=;
 b=cgw58Ik9t1UYzXOccdyiQVn+AEHbXwUUQFsHS+7Efz5jAbavafz8DYdL/1BGGJoXODDjzmWL3c3D/4PYRzZN1qVnukWMBFiH26rA3mvjf67J2hWMBGX4bSexOJafCzmh8/Pe1sFNLGnnU1FxA0EOqF5YdCJFje14L8HPwe7iKnc=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2913.namprd10.prod.outlook.com (2603:10b6:208:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 18:46:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:46:02 +0000
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
Subject: [PATCH v2 14/14] mm/sparse-vmemmap: improve memory savings for compound pud geometry
Date: Thu, 17 Jun 2021 19:45:07 +0100
Message-Id: <20210617184507.3662-15-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2b08e69-428d-447e-19ec-08d931c027b4
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB29132E12567682C304E6B9E0BB0E9@BL0PR10MB2913.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xDFbblCgdhDLtt3GWfWLtdyzGxKaE6kfGoAm8JXKbHFzg3drTzfsO9vg7jUa+/hlr4DqapMQrLcWluBL140b4Tnac8NlcOVqPwINCNFAdB1W1gjYBbhMsVzka6XLQeHUpy5MALvi6vVN3OJUejLPsDkXY2oMHmGQIqZv98YOHAIuLJ3VGr3x0oKrJP0pEf8Cj+CtABJrX9Z+OWS3uO6iiJDgRaEFqRbYAp47vFMVP4KhjUGC3Exjr2+MwovetIoV8dcrS2/9eRGu/s/CWguWzWDK7JjtBkxIgNv7rF75f+1BVihDOTI2Rk/+802X9JUQqW12T+N0o4sVD/rlwGaygcamkBFa/7SI1X9QjnVxxgZ4P8sXEi0tHgKpfJJyXL/m7UUxPCzEwnFEGDlZj+BakVgqOJwWee7usSAYcNm33ZHHMJBqNS/Iax7HfsaOWQRlK65acU2Oz0OhnIUhzto36Mpxb35AoyeB7bKicyfm0inY8V9lfvIoXHeYMN6J6i22SaPuCz7RmXdjpKQLEHkzVJlORHS7Yk1c+zENB/3owC1hav6868SmByKKPss3/6YkVoCa7re4SUHlG7u8LK+U13npFZJkJNYIMDWe8upHryxCgLMa1hpgJREFQlCfza3jTl300iBSgs9GX20WG3E+DMH24WssWRZ7R/7TlEv7vykP9sdqEzFX//G8h8G0z4Hf
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(478600001)(16526019)(66556008)(52116002)(66476007)(38350700002)(86362001)(4326008)(38100700002)(186003)(36756003)(30864003)(7416002)(6486002)(54906003)(8936002)(26005)(83380400001)(2616005)(6666004)(8676002)(7696005)(5660300002)(103116003)(316002)(2906002)(956004)(6916009)(107886003)(1076003)(66946007)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pPulQz8ZDUlXI5l6TW0kMNrFYNIn2aCe13FvKU2uRXJLpprsMECNQUiB/7jq?=
 =?us-ascii?Q?CRRgPIn2WR7hU30DorW4CJIRsakMIPjVGz5tbuzheZDXrnbcv/O+50M1rUch?=
 =?us-ascii?Q?9/SOz4Bb8VBRBIFUX7YHNbmz45a6p6YzYwR+uxnzc+7fWY1dl9uexYN/yRVF?=
 =?us-ascii?Q?Y1y6RI3QZtKGsrfNx0y+ET/eIcw0MJmkINp+oEKqyPGvlI1GcneEgeboA+ky?=
 =?us-ascii?Q?ZVpSLVdPBxipf+wTuUy3np2YD2hgecQkgd8L8/gZ28fcd+NZoxRUp0rWhCPN?=
 =?us-ascii?Q?C/CWKe8zJSq2ezvgXR81j6Z++tDQBvra9Gzq+alzUL7LB2EFokK5cnsGmP5R?=
 =?us-ascii?Q?wgqqx7DfybWsy6ruKNVL/I+ZtZLBsTaK4pEOprXfvfD+YgshV4/0r74S4Zs2?=
 =?us-ascii?Q?PQhrM7OqLNh9AdUSUEy8Ey4H0MUitr9wGd8sNvOZC8RhHs8VPF9hQjg9XcST?=
 =?us-ascii?Q?3bCWZmU0JydsGxzrcFIY2rhMORnS+3AolFny2FeSnkRqKMz/lYprOg9BOL25?=
 =?us-ascii?Q?Tr4rF9LsK/FJ5lzdzm/HcpkaT7Yb+bJ7kssiKbQO3eNwexnEZOF07QPxCDhh?=
 =?us-ascii?Q?XvdklzU0cjTkXFUMN1uuZXKf5DUPBM7UTwCFonVsfqIjH5R0etvHHG+aN3UY?=
 =?us-ascii?Q?ffUP1H4uOg5HtG0+KUqOrzM73EDPU6KtorKqtpXolujjbKwpA1FoCpy53ouF?=
 =?us-ascii?Q?hrPd9YYp8WXB5qe1sRS4ic1FSwFBGeA/mvX+Yp14MAPNBtXjftDSvFnBIt+O?=
 =?us-ascii?Q?lbPbgi8T/yGL8az46aaGpr7o5JMEiUohHYjx+tB/d5HeyhnGO/iL7/ByoBcy?=
 =?us-ascii?Q?CG8LSy0vMOksv1MuJNNwwoBKmTcVLIG0eS4/tvwXevCIv5TLy/MFk7O5I3b9?=
 =?us-ascii?Q?eD+WT0UdZHn8CuQu13ti6EhbCd2T7aQiszMyECI2SNMVfxWNdpfqWbP4V6WD?=
 =?us-ascii?Q?x2NLlmnOiSAKB839s3lK3dxbKYAECHDRiP3CbPO22S2whnMNb8P4s+31Bwth?=
 =?us-ascii?Q?UT1ledq8gWV0hWNYpe+mT7FJMPmoP36+ub6IaRK2Kf0l6ltjdWLLf8dfyURY?=
 =?us-ascii?Q?izG03Hxr5Rt8rUICQ3wdE3TUx/UDQw5X4Mt8Dw4h4HDk9kShKUdz53oquLaV?=
 =?us-ascii?Q?s1COUpZ1ud4uLD4JWDOReAJj+ekHXPbVK8T08DiWg9mgUF+xrlr264ulAErM?=
 =?us-ascii?Q?ugd7zf9D1LIycJNtw85uk0w+fA4W5m6rdmAXqSmuFzYhR90fGndou1s/gTps?=
 =?us-ascii?Q?gOPyxfCiWvBIEKL97NWqutdWmpPhoHzRxNwXblSwRVdOpX2Z1QDkPPmdNZnT?=
 =?us-ascii?Q?8KCoU9EHAbSDIjK3yzh/QIG3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b08e69-428d-447e-19ec-08d931c027b4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:46:02.1173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDSm66bT+v0sF+XDCk/xF5a1N572KCBvKtu+bWFQrGaJbwzf/ktEsDl5C9wqIrJMy6qVp8qyOPtzG76Ohhq3VPveSy3So3cACsbHVtmX6to=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-ORIG-GUID: c9c3eTyYahqIiMqc6vnhZGJGr5M8FWxv
X-Proofpoint-GUID: c9c3eTyYahqIiMqc6vnhZGJGr5M8FWxv

Currently, for compound PUD mappings, the implementation consumes 40MB
per TB but it can be optimized to 16MB per TB with the approach
detailed below.

Right now basepages are used to populate the PUD tail pages, and it
picks the address of the previous page of the subsection that precedes
the memmap being initialized.  This is done when a given memmap
address isn't aligned to the pgmap @geometry (which is safe to do because
@ranges are guaranteed to be aligned to @geometry).

For pagemaps with an align which spans various sections, this means
that PMD pages are unnecessarily allocated for reusing the same tail
pages.  Effectively, on x86 a PUD can span 8 sections (depending on
config), and a page is being  allocated a page for the PMD to reuse
the tail vmemmap across the rest of the PTEs. In short effecitvely the
PMD cover the tail vmemmap areas all contain the same PFN. So instead
of doing this way, populate a new PMD on the second section of the
compound page (tail vmemmap PMD), and then the following sections
utilize the preceding PMD previously populated which only contain
tail pages).

After this scheme for an 1GB pagemap aligned area, the first PMD
(section) would contain head page and 32767 tail pages, where the
second PMD contains the full 32768 tail pages.  The latter page gets
its PMD reused across future section mapping of the same pagemap.

Besides fewer pagetable entries allocated, keeping parity with
hugepages in the directmap (as done by vmemmap_populate_hugepages()),
this further increases savings per compound page. Rather than
requiring 8 PMD page allocations only need 2 (plus two base pages
allocated for head and tail areas for the first PMD). 2M pages still
require using base pages, though.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 Documentation/vm/compound_pagemaps.rst | 109 +++++++++++++++++++++++++
 include/linux/mm.h                     |   3 +-
 mm/sparse-vmemmap.c                    |  74 ++++++++++++++---
 3 files changed, 174 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/compound_pagemaps.rst b/Documentation/vm/compound_pagemaps.rst
index c81123327eea..a6603b7165f7 100644
--- a/Documentation/vm/compound_pagemaps.rst
+++ b/Documentation/vm/compound_pagemaps.rst
@@ -189,3 +189,112 @@ at a later stage when we populate the sections.
 It only use 3 page structs for storing all information as opposed
 to 4 on HugeTLB pages. This does not affect memory savings between both.
 
+Additionally, it further extends the tail page deduplication with 1GB
+device-dax compound pages.
+
+E.g.: A 1G device-dax page on x86_64 consists in 4096 page frames, split
+across 8 PMD page frames, with the first PMD having 2 PTE page frames.
+In total this represents a total of 40960 bytes per 1GB page.
+
+Here is how things look after the previously described tail page deduplication
+technique.
+
+   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
+ +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
+ |           |    |    0     |     |     0     | -------------> |      0      |
+ |           |    +----------+     +-----------+                +-------------+
+ |           |                     |     1     | -------------> |      1      |
+ |           |                     +-----------+                +-------------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | | |
+ |           |                     |     3     | ------------------+ | | | | |
+ |           |                     +-----------+                     | | | | |
+ |           |                     |     4     | --------------------+ | | | |
+ |   PMD 0   |                     +-----------+                       | | | |
+ |           |                     |     5     | ----------------------+ | | |
+ |           |                     +-----------+                         | | |
+ |           |                     |     ..    | ------------------------+ | |
+ |           |                     +-----------+                           | |
+ |           |                     |     511   | --------------------------+ |
+ |           |                     +-----------+                             |
+ |           |                                                               |
+ |           |                                                               |
+ |           |                                                               |
+ +-----------+     page frames                                               |
+ +-----------+ -> +----------+ --> +-----------+    mapping to               |
+ |           |    |  1 .. 7  |     |    512    | ----------------------------+
+ |           |    +----------+     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |    PMD    |                     +-----------+                             |
+ |  1 .. 7   |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    ..     | ----------------------------+
+ |           |                     +-----------+                             |
+ |           |                     |    4095   | ----------------------------+
+ +-----------+                     +-----------+
+
+Page frames of PMD 1 through 7 are allocated and mapped to the same PTE page frame
+that contains stores tail pages. As we can see in the diagram, PMDs 1 through 7
+all look like the same. Therefore we can map PMD 2 through 7 to PMD 1 page frame.
+This allows to free 6 vmemmap pages per 1GB page, decreasing the overhead per
+1GB page from 40960 bytes to 16384 bytes.
+
+Here is how things look after PMD tail page deduplication.
+
+   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
+ +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
+ |           |    |    0     |     |     0     | -------------> |      0      |
+ |           |    +----------+     +-----------+                +-------------+
+ |           |                     |     1     | -------------> |      1      |
+ |           |                     +-----------+                +-------------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | | |
+ |           |                     |     3     | ------------------+ | | | | |
+ |           |                     +-----------+                     | | | | |
+ |           |                     |     4     | --------------------+ | | | |
+ |   PMD 0   |                     +-----------+                       | | | |
+ |           |                     |     5     | ----------------------+ | | |
+ |           |                     +-----------+                         | | |
+ |           |                     |     ..    | ------------------------+ | |
+ |           |                     +-----------+                           | |
+ |           |                     |     511   | --------------------------+ |
+ |           |                     +-----------+                             |
+ |           |                                                               |
+ |           |                                                               |
+ |           |                                                               |
+ +-----------+     page frames                                               |
+ +-----------+ -> +----------+ --> +-----------+    mapping to               |
+ |           |    |    1     |     |    512    | ----------------------------+
+ |           |    +----------+     +-----------+                             |
+ |           |     ^ ^ ^ ^ ^ ^     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |   PMD 1   |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    ..     | ----------------------------+
+ |           |     | | | | | |     +-----------+                             |
+ |           |     | | | | | |     |    4095   | ----------------------------+
+ +-----------+     | | | | | |     +-----------+
+ |   PMD 2   | ----+ | | | | |
+ +-----------+       | | | | |
+ |   PMD 3   | ------+ | | | |
+ +-----------+         | | | |
+ |   PMD 4   | --------+ | | |
+ +-----------+           | | |
+ |   PMD 5   | ----------+ | |
+ +-----------+             | |
+ |   PMD 6   | ------------+ |
+ +-----------+               |
+ |   PMD 7   | --------------+
+ +-----------+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f1454525f4a8..3f3a5c308939 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3088,7 +3088,8 @@ struct page * __populate_section_memmap(unsigned long pfn,
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
-pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
+pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
+			    struct page *block);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 			    struct vmem_altmap *altmap, struct page *block);
 void *vmemmap_alloc_block(unsigned long size, int node);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aacc6148aec3..2eba2da31b91 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -537,13 +537,22 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
+pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
+				       struct page *block)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-		if (!p)
-			return NULL;
+		void *p;
+
+		if (!block) {
+			p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+			if (!p)
+				return NULL;
+		} else {
+			/* See comment in vmemmap_pte_populate(). */
+			get_page(block);
+			p = page_to_virt(block);
+		}
 		pmd_populate_kernel(&init_mm, pmd, p);
 	}
 	return pmd;
@@ -585,15 +594,14 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static int __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      struct page *reuse, struct page **page)
+static int __meminit vmemmap_populate_pmd_address(unsigned long addr, int node,
+						  struct vmem_altmap *altmap,
+						  struct page *reuse, pmd_t **ptr)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
 
 	pgd = vmemmap_pgd_populate(addr, node);
 	if (!pgd)
@@ -604,9 +612,24 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pud = vmemmap_pud_populate(p4d, addr, node);
 	if (!pud)
 		return -ENOMEM;
-	pmd = vmemmap_pmd_populate(pud, addr, node);
+	pmd = vmemmap_pmd_populate(pud, addr, node, reuse);
 	if (!pmd)
 		return -ENOMEM;
+	if (ptr)
+		*ptr = pmd;
+	return 0;
+}
+
+static int __meminit vmemmap_populate_address(unsigned long addr, int node,
+					      struct vmem_altmap *altmap,
+					      struct page *reuse, struct page **page)
+{
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (vmemmap_populate_pmd_address(addr, node, altmap, NULL, &pmd))
+		return -ENOMEM;
+
 	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return -ENOMEM;
@@ -650,6 +673,20 @@ static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
 	return vmemmap_populate_address(addr, node, NULL, NULL, page);
 }
 
+static int __meminit vmemmap_populate_pmd_range(unsigned long start,
+						unsigned long end,
+						int node, struct page *page)
+{
+	unsigned long addr = start;
+
+	for (; addr < end; addr += PMD_SIZE) {
+		if (vmemmap_populate_pmd_address(addr, node, NULL, page, NULL))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
 						     unsigned long end, int node,
@@ -670,6 +707,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
 	if (!IS_ALIGNED(offset, pgmap_geometry(pgmap)) &&
 	    pgmap_geometry(pgmap) > SUBSECTION_SIZE) {
+		pmd_t *pmdp;
 		pte_t *ptep;
 
 		addr = start - PAGE_SIZE;
@@ -681,11 +719,25 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 * the previous struct pages are mapped when trying to lookup
 		 * the last tail page.
 		 */
-		ptep = pte_offset_kernel(pmd_off_k(addr), addr);
-		if (!ptep)
+		pmdp = pmd_off_k(addr);
+		if (!pmdp)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the tail pages vmemmap pmd page
+		 * See layout diagram in Documentation/vm/compound_pagemaps.rst
+		 */
+		if (offset % pgmap_geometry(pgmap) > PFN_PHYS(PAGES_PER_SECTION))
+			return vmemmap_populate_pmd_range(start, end, node,
+							  pmd_page(*pmdp));
+
+		/* See comment above when pmd_off_k() is called. */
+		ptep = pte_offset_kernel(pmdp, addr);
+		if (pte_none(*ptep))
 			return -ENOMEM;
 
 		/*
+		 * Populate the tail pages vmemmap pmd page.
 		 * Reuse the page that was populated in the prior iteration
 		 * with just tail struct pages.
 		 */
-- 
2.17.1

