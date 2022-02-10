Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274C42CA7
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 19:34:33 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AHhrLY013393;
	Thu, 10 Feb 2022 19:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=h9iiemJXgAHtCnZbOUqbjEZrX+1jMccVF+3i6Ihza+BCbJRAV6vodC7md+inIyv+VnY+
 J2PD9Bab5Gbe1YmRrnTUee9PVqMopmVE8osT78yMp4dcITaxi5oZA+v5qPwCriBm9efI
 ziPAPAZzhJk3I1ZGwxJqbAbbqMO9mIfR6Z3D7fOCrCv3ykKZau3hJFlrRpcMdqiKrbM3
 mBwVQONufDW4h8+wdPsr5r4Zox/sr0fZfMpWPVGavlTwcns8C4G/e30BT8KdjUGpiS7A
 W7i5WonsPcUA2kkjU2Jluwpdbbe74hL8+MlwK3g/wqPdryOgayMlHBxmz6VkXLQjJz1K gA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e368u254b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AJWDqx001616;
	Thu, 10 Feb 2022 19:34:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by aserp3030.oracle.com with ESMTP id 3e51rtw73h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEyvHE+l0QS6tSoYL+SmLoJtJseUUabfjTW0D/0QELcDs0fmFW2+jFr0QonRmd7re9V/9i/KxStEG/5XPqQFSKCOKNq9QbmdO8TmM1bjCWIO7fjkgVAvKoLpCVo6HQ1fokJ2550McUsw61+DURh74XYwaYIPxHygC4ZpISq9PHXp/3kCnfsScscvqmArIAvDwKaQNpbVKcIjXIlePHU6AYeqpc1PLLdOQDPynymGJ6rwhKweylHADQRMBtZeaWw2dMsJWwceQT8HAi3dmdto+kZ5Yku6uJ7Q5ZGuFMivQGCc5aJib9sk1Bpc2VcDJ6PgZjIpsc/EAoGIvIdfEKLq6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=dcicEJmedNfzBC6+aaQrTw0PdtisZGLXHpNovMQHVoOaYhLn3fK+xDK5UqX1Vg/IFckqEmSBHecINl7u61Mb7SD0Ua0TeP0iIXvPb4HFQI1e6Pa/oni+OjPS+X/Z2e8MO742Tgy7G08gXKKOYHY0hvc9gxHHzNhYwC0JnWh7t7WLVBiSpvtOwokBlFToF6WYfjhSV8shofeAj9ykmrvVeVJsyNpOd5ZuGHbPfETqVMvQ/zS+ktUoFHhHyTmctYKqUvaGn61jhcSI4J44P5AnYoICwRtKcWIwJ36bWr/B9Si+pwklQ0P7nubodvYRdt0fge3M8nNliV9nvdwUqUvpEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=fxpuVKVDcmwCpBYmV+FixmSzmyQiTnIF12hlasWrvrk9k1BMKlTEIzWKxbpeBLutojSSTukENzYwCBHDJyzJjpS0s9PSaU2YpcfBi0yzPTibPZ/mG43pHEgY5t7oa+uBp1EJwTY6qdciwo8SvXMYR0xbWp0s3G58yhuHT0rTtjQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2514.namprd10.prod.outlook.com (2603:10b6:406:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 19:34:16 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 19:34:16 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v5 3/5] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Thu, 10 Feb 2022 19:33:43 +0000
Message-Id: <20220210193345.23628-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220210193345.23628-1-joao.m.martins@oracle.com>
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0170.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f1739e5-d985-47ad-c346-08d9eccc5350
X-MS-TrafficTypeDiagnostic: BN7PR10MB2514:EE_
X-Microsoft-Antispam-PRVS: 
	<BN7PR10MB25146FFF88E75E813B38AF9CBB2F9@BN7PR10MB2514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qsU0KR4YXh7zPEbObvxjbWihcZ/RTX9jIZyKaCxc9gryQcLeISQRC2/TKGyO7TMpQMokOSHjr7s6aotrHKP88OUpZy/dpllsnrur6zE1j0qIGVjMbhZsuAW8k+/mvNF4l3feffAcfKLDEJqNPpL7iNiSCKUSLk6iAYab8EbazDT/z4+UFhUs/VNTjhikts7xn0ZL6M+IBUiKj4Pm9vCm/cnWmJ4rltbIaIg7OUPo8f1NT46CbeYVRTCxDjW+lP2giQnRfPsTeajqpuNfG89jAM8IMDNWDQs4bIwDM8sE1et8P7jMhei8GuDQZd+k0/a+Scfao4ADI3c3JBcr/yw21bBnbEjfqqwQwHFnZ3k8Z/OZktvjBWL9A6KkgSzSkBenR2Cn+j3oHJENV41g7f6+56zCCDBeldrELuiNNh2KyTC5sGSWVlmgbXOfbwFa/8HfpWUVKY/6NIyLvAKto1Uve1hpOenV7iqAZUvSIwz3nMmQZKcdvOqr4a2/Xk27K2HUDmKRqP5mTLCVYl4VJljydK0tNRNlbbR+iXwMEvDUUBnIFpfmg00QkZIzFIOBbKwXVeUZqkMcNmq7JejnB5h/6VtC1NM7xtgIoerzB9+pgS5NVDyY3bvRarKf4IbMYwG4hujP00T6bShOEhiCSQyqinbMh8vaHxAypv/tKvsEnFsB149pCPlzPde17spAZ0LpJFmdGhfTsM+WHY1rUWW+pA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(103116003)(66946007)(36756003)(66556008)(8676002)(2616005)(8936002)(316002)(7416002)(5660300002)(66476007)(30864003)(83380400001)(4326008)(186003)(107886003)(26005)(54906003)(6916009)(1076003)(6506007)(2906002)(86362001)(508600001)(38100700002)(52116002)(38350700002)(6666004)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?mITWNu8dMMSaQcAvBUOlOBaBjrpt7hMKJaJ3CWfdCnCLC3sHAOGjWBm3Yo9T?=
 =?us-ascii?Q?N+mzsKi8dIQ/sDAUgOBKo2d4x0wbDy1qAy6db7SxKxkukKBnwsKzWTdsUQW9?=
 =?us-ascii?Q?RNmXftUB9vhOXxdkRaCp3HR9HBiOU/b0f6gKh/0MTwyqEhIyu4vXUjmx5dfq?=
 =?us-ascii?Q?e3FwM4Lcq24QvuyMzHZTvD+Id9Ms0GslomhQfB/vkbB1sVsa1VrmRkIooP+Z?=
 =?us-ascii?Q?QRqTNGI4WdX6ZliUJt7peVkmfAJ0Bx+L8nHZ6dTa32r52oE/68xzZcuE4N/b?=
 =?us-ascii?Q?1u0B54nKsk+SMpcvCWlA0+yrEfRizOegrgSq1f3oxINwkzMtfiWdYU6w4krc?=
 =?us-ascii?Q?/GxcUsD/iFPZkfyayDktPeq0+TS8tkzQ85+xsR3ntYdjViY1ht5kv09xDnSW?=
 =?us-ascii?Q?VP03GGrMRSkfiz6+6SL53Y8feJgFQjKpvsB8nEiSA/Os7YysgEy362ENKnqu?=
 =?us-ascii?Q?DU8TJ7PllwPqyFsizR9Fa+hTZTqirE37SuHHEtgJI8jqxa5kfuSP5mZKV1i7?=
 =?us-ascii?Q?mOIVNGl42oRwoW4Sws7Jq7xzHSe4k5Qi9WAPf5gWyKHI3WD3mTxq0rcvZSbS?=
 =?us-ascii?Q?UuzUAii82Jj6FE6x5vppCmQRd416Tz12bo4eYlIe25TThk4j6EkaZjz8xzAs?=
 =?us-ascii?Q?J7tKup5OCetZrK68QVcJANveLHlWMy4993dtoirVsNOkZVkSfNjiigy5fsEZ?=
 =?us-ascii?Q?K2rO3dc4nYcC+HEZI7ruhTbbJAPP+1OeifqPaCV83NKfd9aIiC59oiJTZp0c?=
 =?us-ascii?Q?U51ZqcUjNKf5rc84J5Os1ha7ciPFirJE22yphJMyld4RpDXvBPvcDpHAPDb9?=
 =?us-ascii?Q?L9Vb/0Xg704mLQfVJ9kXPvo/Wa9xD0aCxhQookyh3kCFybWwoZYvh4AZND9G?=
 =?us-ascii?Q?uQCkaKR4giPGpF0zoebALApLGS9gBxGDAVUqa+/GZrcln+SyMO04ZNJKwDiY?=
 =?us-ascii?Q?qk2iVu6I90+SRS2n5fSSgAnq+0A7mAcdAaTLbA7ltQzdiE+foHH4LdZWqdpz?=
 =?us-ascii?Q?gCEvk0Z+rxSAZ36lwjw+oPbgECJz7wLJKd0Fm/ixEOvKDxkrgO/PDV3DeJ2r?=
 =?us-ascii?Q?59DViuPt0F68Xz3sdUnUd4KqAJ51VfwcYr3Vmym6ynoUZDZjH/egKd7RSeSI?=
 =?us-ascii?Q?Ra+Gmrch7AFBfHZ16/eCy2Jtxg1FpoMDPfe/tznw2/v6GwJGhIjie3jsTZdK?=
 =?us-ascii?Q?elKDP+VhktwH9yJ0jpTcEuZ6cqItbZ9dadTZ4W+j5gEvOMMXtkkDSh9j94BJ?=
 =?us-ascii?Q?4CLnstHpFNOkYCQalM8kEj2KmRQCTUfOYjWzSz+QS34j4COM4UMU73p6xB6u?=
 =?us-ascii?Q?kIr5AZuw/D2WxYun1UipqNy0NRvhGfeOwAuZOsje+C8DerZfsPl9NJDa2li+?=
 =?us-ascii?Q?jownOJcpTGOPfo2hSn/XbL/NHkWnIW7ObL76McWLdn6fyu6uBa015AQX/yMW?=
 =?us-ascii?Q?AzT3Of6BJdtnLNPeaU8fOWGL6ABaXjnCQ24yBoHb7gb8pirPpvm+Xr+iuie/?=
 =?us-ascii?Q?OWI8MBLJE+1YlI898XHCz7XDYBKRXhpNV/vjnHRzpTe/cNN5jNylQa2lRk+c?=
 =?us-ascii?Q?riz5iG9hnv7uuuJTcFotrOvw9rDo1U6Gt1TmKKt/I99Ei9VJSWLkrumwp0z+?=
 =?us-ascii?Q?QvhI7j3QhSqunHtYDQhdfHBMinCk3EzEjgwuPNP5FgUJ07iKsx0yA8A2p3BO?=
 =?us-ascii?Q?rmLMOg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1739e5-d985-47ad-c346-08d9eccc5350
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 19:34:16.7732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCQCrK/J2MS/bO1v2pNfUGc6HTiSFhdjX8/k55HblN1UvHyWaC9y7VKPK3BnBsBl0Zyug00q/HjYgBPJa0Z/p4Ku1igm23bqW8XOPj2B1Tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100103
X-Proofpoint-ORIG-GUID: -BpEKEcrf3FNtH14b2Z75BLsG6x6OILU
X-Proofpoint-GUID: -BpEKEcrf3FNtH14b2Z75BLsG6x6OILU

In preparation for device-dax for using hugetlbfs compound page tail
deduplication technique, move the comment block explanation into a
common place in Documentation/vm.

Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/vm/index.rst         |   1 +
 Documentation/vm/vmemmap_dedup.rst | 175 +++++++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c               | 168 +--------------------------
 3 files changed, 177 insertions(+), 167 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
index 44365c4574a3..2fb612bb72c9 100644
--- a/Documentation/vm/index.rst
+++ b/Documentation/vm/index.rst
@@ -37,5 +37,6 @@ algorithms.  If you are looking for advice on simply allocating memory, see the
    transhuge
    unevictable-lru
    vmalloced-kernel-stacks
+   vmemmap_dedup
    z3fold
    zsmalloc
diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
new file mode 100644
index 000000000000..8143b2ce414d
--- /dev/null
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -0,0 +1,175 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _vmemmap_dedup:
+
+==================================
+Free some vmemmap pages of HugeTLB
+==================================
+
+The struct page structures (page structs) are used to describe a physical
+page frame. By default, there is a one-to-one mapping from a page frame to
+it's corresponding page struct.
+
+HugeTLB pages consist of multiple base page size pages and is supported by
+many architectures. See hugetlbpage.rst in the Documentation directory for
+more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
+are currently supported. Since the base page size on x86 is 4KB, a 2MB
+HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
+4096 base pages. For each base page, there is a corresponding page struct.
+
+Within the HugeTLB subsystem, only the first 4 page structs are used to
+contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
+this upper limit. The only 'useful' information in the remaining page structs
+is the compound_head field, and this field is the same for all tail pages.
+
+By removing redundant page structs for HugeTLB pages, memory can be returned
+to the buddy allocator for other uses.
+
+Different architectures support different HugeTLB pages. For example, the
+following table is the HugeTLB page size supported by x86 and arm64
+architectures. Because arm64 supports 4k, 16k, and 64k base pages and
+supports contiguous entries, so it supports many kinds of sizes of HugeTLB
+page.
+
++--------------+-----------+-----------------------------------------------+
+| Architecture | Page Size |                HugeTLB Page Size              |
++--------------+-----------+-----------+-----------+-----------+-----------+
+|    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
++--------------+-----------+-----------+-----------+-----------+-----------+
+|              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
+|              +-----------+-----------+-----------+-----------+-----------+
+|    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
+|              +-----------+-----------+-----------+-----------+-----------+
+|              |   64KB    |    2MB    |  512MB    |    16GB   |           |
++--------------+-----------+-----------+-----------+-----------+-----------+
+
+When the system boot up, every HugeTLB page has more than one struct page
+structs which size is (unit: pages):
+
+   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+
+Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
+of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
+relationship.
+
+   HugeTLB_Size = n * PAGE_SIZE
+
+Then,
+
+   struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+               = n * sizeof(struct page) / PAGE_SIZE
+
+We can use huge mapping at the pud/pmd level for the HugeTLB page.
+
+For the HugeTLB page of the pmd level mapping, then
+
+   struct_size = n * sizeof(struct page) / PAGE_SIZE
+               = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
+               = sizeof(struct page) / sizeof(pte_t)
+               = 64 / 8
+               = 8 (pages)
+
+Where n is how many pte entries which one page can contains. So the value of
+n is (PAGE_SIZE / sizeof(pte_t)).
+
+This optimization only supports 64-bit system, so the value of sizeof(pte_t)
+is 8. And this optimization also applicable only when the size of struct page
+is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
+x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
+size of struct page structs of it is 8 page frames which size depends on the
+size of the base page.
+
+For the HugeTLB page of the pud level mapping, then
+
+   struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
+               = PAGE_SIZE / 8 * 8 (pages)
+               = PAGE_SIZE (pages)
+
+Where the struct_size(pmd) is the size of the struct page structs of a
+HugeTLB page of the pmd level mapping.
+
+E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
+HugeTLB page consists in 4096.
+
+Next, we take the pmd level mapping of the HugeTLB page as an example to
+show the internal implementation of this optimization. There are 8 pages
+struct page structs associated with a HugeTLB page which is pmd mapped.
+
+Here is how things look before optimization.
+
+    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | -------------> |     1     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     2     | -------------> |     2     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     3     | -------------> |     3     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     4     | -------------> |     4     |
+ |    PMD    |                     +-----------+                +-----------+
+ |   level   |                     |     5     | -------------> |     5     |
+ |  mapping  |                     +-----------+                +-----------+
+ |           |                     |     6     | -------------> |     6     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     7     | -------------> |     7     |
+ |           |                     +-----------+                +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
+
+The value of page->compound_head is the same for all tail pages. The first
+page of page structs (page 0) associated with the HugeTLB page contains the 4
+page structs necessary to describe the HugeTLB. The only use of the remaining
+pages of page structs (page 1 to page 7) is to point to page->compound_head.
+Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of page structs
+will be used for each HugeTLB page. This will allow us to free the remaining
+7 pages to the buddy allocator.
+
+Here is how things look after remapping.
+
+    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                  | | | | | |
+ |           |                     |     2     | -----------------+ | | | | |
+ |           |                     +-----------+                    | | | | |
+ |           |                     |     3     | -------------------+ | | | |
+ |           |                     +-----------+                      | | | |
+ |           |                     |     4     | ---------------------+ | | |
+ |    PMD    |                     +-----------+                        | | |
+ |   level   |                     |     5     | -----------------------+ | |
+ |  mapping  |                     +-----------+                          | |
+ |           |                     |     6     | -------------------------+ |
+ |           |                     +-----------+                            |
+ |           |                     |     7     | ---------------------------+
+ |           |                     +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
+
+When a HugeTLB is freed to the buddy system, we should allocate 7 pages for
+vmemmap pages and restore the previous mapping relationship.
+
+For the HugeTLB page of the pud level mapping. It is similar to the former.
+We also can use this approach to free (PAGE_SIZE - 1) vmemmap pages.
+
+Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
+(e.g. aarch64) provides a contiguous bit in the translation table entries
+that hints to the MMU to indicate that it is one of a contiguous set of
+entries that can be cached in a single TLB entry.
+
+The contiguous bit is used to increase the mapping size at the pmd and pte
+(last) level. So this type of HugeTLB page can be optimized only when its
+size of the struct page structs is greater than 1 page.
+
+Notice: The head vmemmap page is not freed to the buddy allocator and all
+tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
+more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
+associated with each HugeTLB page. The compound_head() can handle this
+correctly (more details refer to the comment above compound_head()).
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 791626983c2e..dbaa837b19c6 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -6,173 +6,7 @@
  *
  *     Author: Muchun Song <songmuchun@bytedance.com>
  *
- * The struct page structures (page structs) are used to describe a physical
- * page frame. By default, there is a one-to-one mapping from a page frame to
- * it's corresponding page struct.
- *
- * HugeTLB pages consist of multiple base page size pages and is supported by
- * many architectures. See hugetlbpage.rst in the Documentation directory for
- * more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
- * are currently supported. Since the base page size on x86 is 4KB, a 2MB
- * HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
- * 4096 base pages. For each base page, there is a corresponding page struct.
- *
- * Within the HugeTLB subsystem, only the first 4 page structs are used to
- * contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
- * this upper limit. The only 'useful' information in the remaining page structs
- * is the compound_head field, and this field is the same for all tail pages.
- *
- * By removing redundant page structs for HugeTLB pages, memory can be returned
- * to the buddy allocator for other uses.
- *
- * Different architectures support different HugeTLB pages. For example, the
- * following table is the HugeTLB page size supported by x86 and arm64
- * architectures. Because arm64 supports 4k, 16k, and 64k base pages and
- * supports contiguous entries, so it supports many kinds of sizes of HugeTLB
- * page.
- *
- * +--------------+-----------+-----------------------------------------------+
- * | Architecture | Page Size |                HugeTLB Page Size              |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- * |    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- * |              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
- * |              +-----------+-----------+-----------+-----------+-----------+
- * |    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
- * |              +-----------+-----------+-----------+-----------+-----------+
- * |              |   64KB    |    2MB    |  512MB    |    16GB   |           |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- *
- * When the system boot up, every HugeTLB page has more than one struct page
- * structs which size is (unit: pages):
- *
- *    struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
- *
- * Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
- * of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
- * relationship.
- *
- *    HugeTLB_Size = n * PAGE_SIZE
- *
- * Then,
- *
- *    struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
- *                = n * sizeof(struct page) / PAGE_SIZE
- *
- * We can use huge mapping at the pud/pmd level for the HugeTLB page.
- *
- * For the HugeTLB page of the pmd level mapping, then
- *
- *    struct_size = n * sizeof(struct page) / PAGE_SIZE
- *                = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
- *                = sizeof(struct page) / sizeof(pte_t)
- *                = 64 / 8
- *                = 8 (pages)
- *
- * Where n is how many pte entries which one page can contains. So the value of
- * n is (PAGE_SIZE / sizeof(pte_t)).
- *
- * This optimization only supports 64-bit system, so the value of sizeof(pte_t)
- * is 8. And this optimization also applicable only when the size of struct page
- * is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
- * x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
- * size of struct page structs of it is 8 page frames which size depends on the
- * size of the base page.
- *
- * For the HugeTLB page of the pud level mapping, then
- *
- *    struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
- *                = PAGE_SIZE / 8 * 8 (pages)
- *                = PAGE_SIZE (pages)
- *
- * Where the struct_size(pmd) is the size of the struct page structs of a
- * HugeTLB page of the pmd level mapping.
- *
- * E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
- * HugeTLB page consists in 4096.
- *
- * Next, we take the pmd level mapping of the HugeTLB page as an example to
- * show the internal implementation of this optimization. There are 8 pages
- * struct page structs associated with a HugeTLB page which is pmd mapped.
- *
- * Here is how things look before optimization.
- *
- *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- * |           |                     |     0     | -------------> |     0     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | -------------> |     1     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     2     | -------------> |     2     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     3     | -------------> |     3     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     4     | -------------> |     4     |
- * |    PMD    |                     +-----------+                +-----------+
- * |   level   |                     |     5     | -------------> |     5     |
- * |  mapping  |                     +-----------+                +-----------+
- * |           |                     |     6     | -------------> |     6     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     7     | -------------> |     7     |
- * |           |                     +-----------+                +-----------+
- * |           |
- * |           |
- * |           |
- * +-----------+
- *
- * The value of page->compound_head is the same for all tail pages. The first
- * page of page structs (page 0) associated with the HugeTLB page contains the 4
- * page structs necessary to describe the HugeTLB. The only use of the remaining
- * pages of page structs (page 1 to page 7) is to point to page->compound_head.
- * Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of page structs
- * will be used for each HugeTLB page. This will allow us to free the remaining
- * 7 pages to the buddy allocator.
- *
- * Here is how things look after remapping.
- *
- *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- * |           |                     |     0     | -------------> |     0     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
- * |           |                     +-----------+                  | | | | | |
- * |           |                     |     2     | -----------------+ | | | | |
- * |           |                     +-----------+                    | | | | |
- * |           |                     |     3     | -------------------+ | | | |
- * |           |                     +-----------+                      | | | |
- * |           |                     |     4     | ---------------------+ | | |
- * |    PMD    |                     +-----------+                        | | |
- * |   level   |                     |     5     | -----------------------+ | |
- * |  mapping  |                     +-----------+                          | |
- * |           |                     |     6     | -------------------------+ |
- * |           |                     +-----------+                            |
- * |           |                     |     7     | ---------------------------+
- * |           |                     +-----------+
- * |           |
- * |           |
- * |           |
- * +-----------+
- *
- * When a HugeTLB is freed to the buddy system, we should allocate 7 pages for
- * vmemmap pages and restore the previous mapping relationship.
- *
- * For the HugeTLB page of the pud level mapping. It is similar to the former.
- * We also can use this approach to free (PAGE_SIZE - 1) vmemmap pages.
- *
- * Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
- * (e.g. aarch64) provides a contiguous bit in the translation table entries
- * that hints to the MMU to indicate that it is one of a contiguous set of
- * entries that can be cached in a single TLB entry.
- *
- * The contiguous bit is used to increase the mapping size at the pmd and pte
- * (last) level. So this type of HugeTLB page can be optimized only when its
- * size of the struct page structs is greater than 1 page.
- *
- * Notice: The head vmemmap page is not freed to the buddy allocator and all
- * tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
- * more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
- * associated with each HugeTLB page. The compound_head() can handle this
- * correctly (more details refer to the comment above compound_head()).
+ * See Documentation/vm/vmemmap_dedup.rst
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
-- 
2.17.2

