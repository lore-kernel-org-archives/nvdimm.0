Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB51F6AB7
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:49:05 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NIDlxa029467;
	Wed, 23 Feb 2022 19:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=BREPMQh1crcFtcQO9URpbYhXpUce2Z3aygW7Wgof85WszGSqUN9UCibCHr5FL/u23OG2
 W7YgndYeCNTzgAzevJ84TKptrcNu53sZ6q/JicflmQb8m/Sy0eutoa0cvfn77VckIils
 vf0SvdiFkZ57zOqoY/J7DplaUlQJ1AsfpOg0Mht+m11hwfbEDnD/hdWnzHDXtMPQGWWY
 9H81Jl0xErWTEhZzJ1dOBlPDTu41wYSdcWEAm2Jm4vZHw7NIZuZnk2IyhuuYKmkiWVby
 7e92sdm84NFSOwXbEvX9HYAj03AbqG+6scEmBw2C7oXsMbCOYF3cqDpomy7t1zgUMNm1 kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx5cp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21NJeWJ3047035;
	Wed, 23 Feb 2022 19:48:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
	by aserp3020.oracle.com with ESMTP id 3eb482vxks-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IW6Zvml1imkwRCObekIY1W6OjdNxf2x+nGsuv9CNbabXqGbJg0mt6ie/7sZXokKwfYWU4D3RZer3/ToCNi/5gkOBEUdnJwQktrdXKuYrVzHXHgPpt3bXp9JDwAdGm7Pw91ddlTg1nITy3LY3CVh2k61dTiVJSStEG9O+x5GbkY3y/gkEP1QiJzHUp4vxc1PViBel2UMmhTs/A63+tLqYUX3hTMJagQFWZEZ+oMkf0LEN1IK8AexBgi+5X0HqoXtNQXITONxxkPHGCH4oXtOrZ8j4MXx8ZL5W0wbPAKsUcxH9TmZhV32SZcfZfQgOT/XJbRncVsEVaPEXw8Mva5GS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=RRi9b8e0nVPODCSK9T2GTqwTTDQU5U05TMBHQs9wD2MBLdF6IiM6prIJno+CNOKt91pw1giNUfn0L8JHMrgRxUbG5EakwfY87dxLFZPsVZ4ITwCD1K2H94WYbIUx0fjRkdj0q3jCkhTbdhngU3cpGv6pqUF4FNQVZ4UniRwDvE/GCwiAT/zgJpuwrkx/eqoIT2lmTMfgEBtVUSRpF+2Rcol+8bZgqbyXopt5RKrPOeDH5oQrVm08HX7+bUSvlr/02xZRXyR/8a/DFS/aj+NqaIBhG2Oo7fiQya01Nd49hbLeD+xcCZGVa6+OBLqNv0evAKR9sQWqvGty6npBLAXEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=kAD25fuJHfHNRrkhpvyI2LViup2bqqWVIbfSgJ8ZpwxpEfoHRILIAu0dELF+KjzjMUXdEuKf/nLtP4LJCtXWvfB5ZVnq5WfLYKM3PUsezsZDPM3Gtykq3Gkq6MXXocEK6DMt+UdLbaJrW3c7roDJe7Djl73qjGYDlgeDHXcyAkc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4930.namprd10.prod.outlook.com (2603:10b6:208:323::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 19:48:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 19:48:39 +0000
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
Subject: [PATCH v6 3/5] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Wed, 23 Feb 2022 19:48:05 +0000
Message-Id: <20220223194807.12070-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220223194807.12070-1-joao.m.martins@oracle.com>
References: <20220223194807.12070-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0392.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfe22726-b0d1-46fd-b266-08d9f7057ccf
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:EE_
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB493063BEC4610327808E8C55BB3C9@BLAPR10MB4930.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/fN8kiOW4hTI9CUT6zOpwXVS420D3EYVyGeDgbrio87lq7FpdMDLlB/lCt3WKH7fMK+ZpPG8TGCJ5NqELq4UNdkyltVNEhSKbKVrPHNQMfFrpCiVXkJI9B22/hHjG5tY4xyklKetTrZPzoQpQGfhWUahKqPRftUUo8iCp6z9P1zrGApACcJ2eIZPq1tPPbTUh9/1cH8oRO8lElFS9d5YC1t0ouQ7owup+e2LN5agKFNEUmgoHi1Dm8rImOqfp0pJfzFigb37JU69tLZRLYvGNaxYyiRDcd4eLbAZ1IYOtEpQ7N+XQtbbLA9ADlWaCfFNWlkVXi5rBXR8Qx0YIcS5MZxKBKn66UDAfF24zdhLvQ+yJYJ9MpizNBOlDvPHf+hUjBOEjs+lrXgz72CMY+OorU+J0j7hIwcHbMj0i+FVcdmkLY4TQtb7YrumT8Zf6vkCE93Mqvo0eSI/5BAGxY6cPnwomdq2XaCxS6r45RHfOurNsprbOjofBlMNKxvuErfxHtvoJGXqePWZIusZwDfX5wX5P17FFmbD7hb5j+ewEmZZnije6qC1e0GwhVlg5fkKaIdUG4hHwoqxNCJxHxPs4JIJ/aAHTUIdvkdBPvatl+qree8aicU92cWDNDadAmTN4AFyv5kbyZWcQmRETqWXXzr5mdc0/txUHdCVoFBma8xJrQaRbrtXc/U4bVhYZYV1xY134AP06xNYoCsULrd9iQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(103116003)(6916009)(36756003)(86362001)(6486002)(316002)(508600001)(54906003)(8676002)(2616005)(52116002)(107886003)(66946007)(66556008)(26005)(186003)(66476007)(1076003)(4326008)(8936002)(38100700002)(38350700002)(2906002)(5660300002)(30864003)(6506007)(6512007)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?gGKAvXxiAAI99uRuJDcTDA681VpiXdO3yyuUMLhz8jv6bLT5UjTol7Rx6yXZ?=
 =?us-ascii?Q?607dKuA/lEnFtVK0LUK8fWhgdd9vh8xESdrW1oiqOyKi0+b/HRcVqW+kdm7X?=
 =?us-ascii?Q?U8RtOpfCjUDC5r/abypN2gf3kUjxetRqZzqAaWskDTGayKvPfjns9Q8Rwiir?=
 =?us-ascii?Q?C2m8vUsQpqq1CVqo+rPHlTiT2JQGyiPl8J/t9foj9j9yWgCWwrwE7fHDi1vb?=
 =?us-ascii?Q?KugCJQOblVtkm1hbS340Kq599IzHirCKFstWw7atFM0w0qnlJ77MclSbuP3D?=
 =?us-ascii?Q?5t6UwzVzbcjdjWFDWsF2QS9g4u7kB0JzydBOdEHYoUE1LpICLShfZkJLKEa+?=
 =?us-ascii?Q?32kxjuVyInnfONJHi0XEmML6EEzTNNxGS/EncWNB5bnwRfCgHb9vGnbkdHMa?=
 =?us-ascii?Q?e7Q7VbeHKfqdcpM5euAD20XHXVjNHWsKxWKtSGzlTSf13+M4Fc8aArmr1b3h?=
 =?us-ascii?Q?eonMEJU0emTj1sXn81+lWXQIGp4q+a5W1HR92yCgZoJ367TEhfWEJ1Ahb6aj?=
 =?us-ascii?Q?EGCSKtfyflt9BSnZvqbjLbl3O3ZOaWnOyGoYvQNZ5g9PhM45y39AOKfxTGA+?=
 =?us-ascii?Q?bLokvyEn+hqDEMDlYjHk7c+tB+ZwHmGn3kRNR+cDtWcvyaN8665HCAbpLLd4?=
 =?us-ascii?Q?UkKrrcRQFKjamkBzC9qIkz6dJd0wj9ck78sFdhbJmYm1+RW+yvyg4He/xbvK?=
 =?us-ascii?Q?eM2Wv8bUFPmy20pKz6UKEd5Bbf5BTwYj3FD2ROL00xWQm1kTghGfsNvL5wOp?=
 =?us-ascii?Q?yxSSnM51vnjn1pt5dzHZguLn0IBXF/GiYtPllB4YS2fM1IqhcrQDtEosqcv2?=
 =?us-ascii?Q?ZldcwoWMWbd9pk+LVS39qYLNEIStvFI5/3tfXyw9rlt/UKe5P7D7a1T2Iygy?=
 =?us-ascii?Q?tzXa4re0eEYq5a3ef7tBywRFf8Pc9j+T6NXNqyDRRrd18FVeal2LS1M8mXFa?=
 =?us-ascii?Q?mkgPo46RkvTv1+NykX2amBIkSbwnw21pWwk3aPCi3LtQVPxkPNS9HZgAEiNN?=
 =?us-ascii?Q?ao49BnYRIzJVKvKidUkqla8zSsQCVt0luECmvXgfoU78QQh3Zpg5P6d9XB+6?=
 =?us-ascii?Q?X+HBF/qt5n1/r6FgFbk2l08J+V/8LoEpMp9wpjh+e9noXYDZ86Oy0ZpZ3Kr6?=
 =?us-ascii?Q?miK+mEJg5qDMeMu0QuJagLb0YZFWKoVk3WCsA8xdHNff7ndXqU6MIpAMsdsn?=
 =?us-ascii?Q?ZiREFJOxPe7r1M2tAp+AuIQcI3L3UZZtfPgqyRx+hcHx9kH/DM8s5TbBwEb7?=
 =?us-ascii?Q?Whx3DBMBYZNd0aqoQxsx+u+upoBQh+6c3+caQ0GVTtj1VlV3jOYInnq7KWQn?=
 =?us-ascii?Q?BjSHZ1Yi9zlC74IOGaoO/vnL3aDzGakdeNxdF1hJM7DO+7KS+lPJs6aQhW05?=
 =?us-ascii?Q?xmges9KUbwr1SEUzABzv7ji15GqDKwBt70lBXQkAJ/7Lm1JB4lp+tlfzGJGw?=
 =?us-ascii?Q?iUqBNpDiiOBVntOmXzAzhtPR/fsxS8th3gLFkX8d1GrIjkVgzx5/F8yaAPbG?=
 =?us-ascii?Q?a0Z7cTKBs2V1xjmf5qw4TtUVs9CioTGdKbeXK6W1ysaxBhgr4SWN7CO2+SSC?=
 =?us-ascii?Q?huVvwhnVqSNi5/1ze4L/a+P1y0GcaanqS2p+MySu+/qMGWjqKAqTl0nPVUMn?=
 =?us-ascii?Q?3d9s5fm9hsGocVli+PhXvteYwMbDFAGn3wU4ZxjHBHv9BSMGzNseyxtlyurh?=
 =?us-ascii?Q?CfwA0w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe22726-b0d1-46fd-b266-08d9f7057ccf
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 19:48:39.3187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRmS9n+Ln+em+RglDr08BU/ZfA5gcsLLzbpLAgYyXvnPsS5vpL76MAVtMyLhVjoSDSN2ZvSv8u/+/AttdCUkPQcPpHVOph9chvnSmw/011U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230111
X-Proofpoint-ORIG-GUID: 5zL8iVcp4CuFuOoNBhOtPxZsPNuehyXT
X-Proofpoint-GUID: 5zL8iVcp4CuFuOoNBhOtPxZsPNuehyXT

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

