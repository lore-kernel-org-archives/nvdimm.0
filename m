Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C8D3FE4
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:27 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RDWLg1010418;
	Fri, 27 Aug 2021 14:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=h8zX5EwGpoSKxgJhw5pcbNisWYyaf2L4YDqtha8/xJ4=;
 b=tlOe1ZzwjfbZt9k7NmCglC3ezkA8D1ScBRhUcXR5VNvsdGdAl7R6shl/gfLw91wlIcgC
 nner4K2U/bsPd6hw9B/HuzBePezuvF/eskltvo2fN/0CGdHQz1y3jq8RHVZbInwK/Lqq
 Qk728nQ5CPiCtAUHLESuq2DcrpGJ2P5lsBck3Z09U5t+7N/wljQ1/c00IQjGPyfLshI7
 bhZav1I3Fa7c4BXmoXSLtv4zLdZgw9gmznKkG+9CrZspFLMFxiAB9wc2IFWsk3FJuL4T
 SnjBbQPOF8qX94ZPxLI99Rjw3pAi8INrtjqWYjR3A+ZfbvyOm+vr6wmtwoLCvbEqbRU3 IA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=h8zX5EwGpoSKxgJhw5pcbNisWYyaf2L4YDqtha8/xJ4=;
 b=YobpENilg0pRjP75XsR7OZeYHGbPFRb5tPhxd+JGUVXif6VOw7Ojbkda+Ogak8AlPw7W
 zj1InWQVGKk+AjRuvxVn+E+cK3gwrr0vOaxiI/0N3dzPstjTaX3OPFJpXzG7StHHbKJF
 oxHw4IDIoBtGviAAwfZSCnc3bbF/JN97J+MpZAJc70JpkFAzuAmm5CSyxRzOnlfmN+C+
 8YXOj7rU62FGYJLuN7n+mj9rzjMgst2JaV/iJcvVPhNDLV43hanR7dHjw4ljf2i2/7XU
 /I/QewFL5vIQIyWiI1zAfoeCSmAp31aOklfD/fk0vVOzEMQm2O4x4ZHPtqu2v/vHFp+E CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap3eauymy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpbuL156012;
	Fri, 27 Aug 2021 14:59:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by userp3020.oracle.com with ESMTP id 3akb9293n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:59:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFrJpan+g2WCLKFk+K1pra5N7I/61noCcp5lFVNzFTv0FJbHGbNScPY6VDB7V2JQiyZ5WvoUHG1quMH/mNGDQidTXA9wp1hhcOfCAKKFX3HINsdhCjNH+VulHiAA8hBqZoUHpFjbi/53ULyNyIMFMFyCCcpOHt0VKtXYlpErubYHjN3KUGtWmgr2MqhlqLQHiKqiYYAXz+b9WXC6iyNWfcuSJ19+9FVD3Yx4kVCvwOxtaxpWntRk+5acwwsueBngV9G+TBMLBvt/fI/MjWFXFikxSuyTd/jaF++uhlxDsd5gf6N68Nk8IK6XDsQSVKxt5+DPyFEU4YquQyFot5ZhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8zX5EwGpoSKxgJhw5pcbNisWYyaf2L4YDqtha8/xJ4=;
 b=WdvSL6fDY85Q6SR/xrqkXybms6VJP5JKPREpo4bsT5gD114uTo1yK+Cm3yKQXP3B8z8nm6CElH7GbGPUCBGE3N/4eZjxWo6Mem/JcrR2eXswXM/GTmp39fIO/oiI3tqg5Z6vpZ8f5/aBU6xUUokZ3U3ILbjmyZWDE8aHn/wEgpTDcSljV2a7Km45lvmUAIVcg8Ubia7G4qSgI+9Vh8I5ZyJ1pV9Wz3nkamPkMM0XgONwNIv7ziKMsYidXaAeiHcFmS/DHdtpxdjrV3UFPw7xMsZtgRySJYIdQcPPY+J01vtvEBPkUi/+b6uBy0CjeMr9NDYz6MUxLCygeoGRVNt8+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8zX5EwGpoSKxgJhw5pcbNisWYyaf2L4YDqtha8/xJ4=;
 b=awHRuOcE592+2dptfovaqcbKz9VqfDPR9wA2b3NfvSIHaxjZ6F3YTwyDgNQLA5B9ByRxAuJEd8Cs/2Y+Jre55w/V7vUJSQaTlOGoesrbT4q3q/vSV/Ugfreoonun/0FZPLjTPynJUPST1VP2rRZD5IUDWrSyUBfJ3bfeuwK0SLc=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 14:59:16 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:59:16 +0000
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
Subject: [PATCH v4 11/14] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Fri, 27 Aug 2021 15:58:16 +0100
Message-Id: <20210827145819.16471-12-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:59:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53736d5a-7d54-463d-ed0e-08d9696b3cda
X-MS-TrafficTypeDiagnostic: BLAPR10MB5025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB502531A4FBB596A01CFE563EBBC89@BLAPR10MB5025.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	DDtpwVtxxHsZeKdxN3DV7nZz1k29rZT0pAYX5Cqu1+Fz94FCrcuB5XJm7Y0np6Y7PxVHNgjP/mjD/zTlp11Fh48FNBhcOs6XdsBiWt54APVEz1E6lQOYgI6ODWeHeazO9UPzh+NlB+OSl0J1DbGE8kKMivI9n5EdtC8MXx6TEgpcDtYcM50C4LVwUWe78WwRzfpSV6DGaS4aQrRnJbdCKOsRyP0fYlty5LH9A5E6b87m1pJcfjmRY20xz1yIrWoPi98Zm/MVMBv8ufehjmb+NtVhL9Pz3U3AK9lHi/3r1NL1D1S3cFhWE2WWJGVvxGpAWhBGIQetgCpgoB9pVJLwLf8bNxzaRJYxE4K0v7gxbuzwo81kSOa1juNbO06yffOR0+xGVCu+EEC5ioG54yX4MptSEteZAlS9BvvXxcO53PukSH30X18EGaL32ubkNQpceaPJza8f68REhBUQv6ApivwOpfWFjb9iBY6z6QSq3KL74Ufa6x7bda8b63vMORdaJHZ5OwRIT5/uK48KmCh95cDj0TbdHu/U/mkXONYTuP8d8srUd9gyujp8OX/9i9qR2pT88gyT2QPVAFuDHcC/wVx/q+YEGMB7x9W7Log4kNyjmBuWq+QuG8QqR+wSDszbKkZybY4uHzuKYdJjzU+yu+GDzFle84XXS5MDui8ouwgHFFLRXxz7mDs7FzaA6qlXqPdu//se84ChI4TrMVjJOA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(103116003)(66946007)(83380400001)(66476007)(86362001)(54906003)(6916009)(30864003)(6486002)(2906002)(1076003)(107886003)(8676002)(186003)(4326008)(38350700002)(5660300002)(956004)(26005)(66556008)(52116002)(7696005)(8936002)(36756003)(2616005)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8GwWkVw6L23HAFPdVr1iqfUqFqE2Rkj5q9sCXjV776A8tNJbUk8deqEm0Mp+?=
 =?us-ascii?Q?TFOJeWKikF2qgWfUd4LdcOExAaPkVeempO1tx2e4eA8ViJyaj2/CXc5tA0+W?=
 =?us-ascii?Q?LlYVyZO31ttAWMgu+9B+mQk2JdckAdlfC9RXttRyRUvH7rR0MwreQ7y7jpJx?=
 =?us-ascii?Q?jYlgISyuqIzahFVGxLj7KOEZuYAS4r/3y9IowHqWiwN91V+oUEg7Se/REbld?=
 =?us-ascii?Q?3eThCkshZeIQZZBClyWm1oIe3NZgmj1pf+458dc/g6t+KKpZ75uRzfE1uPIL?=
 =?us-ascii?Q?7UntXGNHC/7VwEK/CGzgi0fJQGhc0a8sQAe6ZK1910NC0qtuqGS/xMtBa8Re?=
 =?us-ascii?Q?j/yTiKt4RmLOepMD11FCJnwvuhTZwsprIgYJrd50hkr6qxZffZPKoFLwxE7z?=
 =?us-ascii?Q?aGGX2hW+lHZIdVh2TQJGje/guKC0y8Uy4tDmcLYEbt5o4SABjNfQg6qE421B?=
 =?us-ascii?Q?8bW/4xQNMslgVVHDukTLx4Z2p0h+N9jtsxwSX/pS8IedQXIcqnFGsQz6Sgqh?=
 =?us-ascii?Q?p9yTHLFmOV2xUAFpyxPK76NpJH/scjVTGIchZHxP1OfUIp55Tz3DmP27wzT/?=
 =?us-ascii?Q?7ODzcDW7X2+gFk0OJ4rWUHbDB38yqwa1HlTbwXHTAZKabdor7IURdW2aP6G5?=
 =?us-ascii?Q?kP8s4dr8YOFVe4hkTZZv5viNIj/GrsNreL45kt0BGJ3xgE0+MGUjaimXU5Yo?=
 =?us-ascii?Q?HNCMWJoe6jUhPXkaxql131BM3RPmExaISzLKq7j2OhxHMfclKBQwbEIamBJS?=
 =?us-ascii?Q?NNL1geyCft6KPGTB8XY1eXOQ3w+HqkpgZvTT41nnxgR1q9O1dro4IzGiHrX/?=
 =?us-ascii?Q?SBrtGSRg/UoFrTbySBVu3qQEmRlGivmySr6uJwBg3akNwC3oWmVMDFW7R5q/?=
 =?us-ascii?Q?S+R1htezzqq/mXZgtoXNnDUWhJIiS1Qs2CjN73VsCThH57WjO2bo+QeHCz9v?=
 =?us-ascii?Q?QZf97BIzv8Y1QVLmOPMgRF0yX/qSA7NwvOOj5jUbNZUZzyzGPqIMfhMsjifh?=
 =?us-ascii?Q?nduAdECEqPRrVTdfOrd7kK2LuPobxGHHvCZA/OgEZ/QwFQKM6U79pmHcno/N?=
 =?us-ascii?Q?ONECjikqXBELwDaPogoFK8AIPXMFWVUASJt8OK3+G0jv02gAfF4btaWcCeMw?=
 =?us-ascii?Q?jRBuixJxHxSsuoaJRRxeuLJQjVFSzjDTmHlTptYdnQ0I3IzTetltjFO4uGJC?=
 =?us-ascii?Q?1m2B6mQY9qR0yOHjb4iD40ZLtLO8gji5aZ9CNNlccD9c6MOHKfa6jAe8lLFi?=
 =?us-ascii?Q?8fo7LDSEeREHbIV54+2OfjM4lsItl2M152Y4yKo5x6L5hObAVlH263XPbgmV?=
 =?us-ascii?Q?pUzc+dV1bMLHtLOwwS9aOjFI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53736d5a-7d54-463d-ed0e-08d9696b3cda
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:59:16.3626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBmh0F0fiIRd9jDHTm0p+i1d73bJOPNrHH6m6IfXdZCHApd9Y0hEQuLSJLCluOcuHF8222NRdFkO+YqYgtdw0O+7SJ0r0VNLq3HlhQHn5eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270092
X-Proofpoint-ORIG-GUID: 7Q5E0LC2cZZ9C88yIY7WfrzNPH8LOw6R
X-Proofpoint-GUID: 7Q5E0LC2cZZ9C88yIY7WfrzNPH8LOw6R

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
 Documentation/vm/vmemmap_dedup.rst | 170 +++++++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c               | 162 +--------------------------
 3 files changed, 172 insertions(+), 161 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
index b51f0d8992f8..68fe9b953b0a 100644
--- a/Documentation/vm/index.rst
+++ b/Documentation/vm/index.rst
@@ -52,5 +52,6 @@ descriptions of data structures and algorithms.
    split_page_table_lock
    transhuge
    unevictable-lru
+   vmemmap_dedup
    z3fold
    zsmalloc
diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
new file mode 100644
index 000000000000..215ae2ef3bce
--- /dev/null
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -0,0 +1,170 @@
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
+Therefore, we can remap pages 2 to 7 to page 1. Only 2 pages of page structs
+will be used for each HugeTLB page. This will allow us to free the remaining
+6 pages to the buddy allocator.
+
+Here is how things look after remapping.
+
+    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | -------------> |     1     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | |
+ |           |                     |     3     | ------------------+ | | | |
+ |           |                     +-----------+                     | | | |
+ |           |                     |     4     | --------------------+ | | |
+ |    PMD    |                     +-----------+                       | | |
+ |   level   |                     |     5     | ----------------------+ | |
+ |  mapping  |                     +-----------+                         | |
+ |           |                     |     6     | ------------------------+ |
+ |           |                     +-----------+                           |
+ |           |                     |     7     | --------------------------+
+ |           |                     +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
+
+When a HugeTLB is freed to the buddy system, we should allocate 6 pages for
+vmemmap pages and restore the previous mapping relationship.
+
+For the HugeTLB page of the pud level mapping. It is similar to the former.
+We also can use this approach to free (PAGE_SIZE - 2) vmemmap pages.
+
+Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
+(e.g. aarch64) provides a contiguous bit in the translation table entries
+that hints to the MMU to indicate that it is one of a contiguous set of
+entries that can be cached in a single TLB entry.
+
+The contiguous bit is used to increase the mapping size at the pmd and pte
+(last) level. So this type of HugeTLB page can be optimized only when its
+size of the struct page structs is greater than 2 pages.
+
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c540c21e26f5..e2994e50ddee 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -6,167 +6,7 @@
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
- * Therefore, we can remap pages 2 to 7 to page 1. Only 2 pages of page structs
- * will be used for each HugeTLB page. This will allow us to free the remaining
- * 6 pages to the buddy allocator.
- *
- * Here is how things look after remapping.
- *
- *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- * |           |                     |     0     | -------------> |     0     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | -------------> |     1     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- * |           |                     +-----------+                   | | | | |
- * |           |                     |     3     | ------------------+ | | | |
- * |           |                     +-----------+                     | | | |
- * |           |                     |     4     | --------------------+ | | |
- * |    PMD    |                     +-----------+                       | | |
- * |   level   |                     |     5     | ----------------------+ | |
- * |  mapping  |                     +-----------+                         | |
- * |           |                     |     6     | ------------------------+ |
- * |           |                     +-----------+                           |
- * |           |                     |     7     | --------------------------+
- * |           |                     +-----------+
- * |           |
- * |           |
- * |           |
- * +-----------+
- *
- * When a HugeTLB is freed to the buddy system, we should allocate 6 pages for
- * vmemmap pages and restore the previous mapping relationship.
- *
- * For the HugeTLB page of the pud level mapping. It is similar to the former.
- * We also can use this approach to free (PAGE_SIZE - 2) vmemmap pages.
- *
- * Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
- * (e.g. aarch64) provides a contiguous bit in the translation table entries
- * that hints to the MMU to indicate that it is one of a contiguous set of
- * entries that can be cached in a single TLB entry.
- *
- * The contiguous bit is used to increase the mapping size at the pmd and pte
- * (last) level. So this type of HugeTLB page can be optimized only when its
- * size of the struct page structs is greater than 2 pages.
+ * See Documentation/vm/vmemmap_dedup.rst
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
-- 
2.17.1

