Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1FD1862
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 15:54:34 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KElUXw009567;
	Wed, 20 Apr 2022 15:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cN2dJDQ5NpX137w33ZeWe6BTTCYZFR6xf3MP4K9nh1Q=;
 b=IDQeoVehnZG07MhdLwSpPYomh3kMpd4Iz1kZuKhAxE0nXXt9GWX4QsWKYaXLmgpJX4Xt
 gb6YRUiYJyGxQakQCNb6jiy26KtBy72aeO3iqmPmIn9O50weR73hhzWSmai4upNw9rV8
 QBoARn5sI3JEZj6Fcyp0oFdCVixsYuWOOO1chQlqhC42PrCfFZ1Uyl20jehyVKKnzGXG
 c1GxGfT3YCGSBQY9i/FXWj0+EMeab0dexYchp/b/kDJRQpclpAOCKiVsWAtNm8NxW67N
 HKMT3eZc/ZSkuPkgCZMBt373VnV8rQk+ItKXPDNP4xerpYvHtBn0roN6xPS/ixvcttXr Mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ffndthjd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KFokjd037654;
	Wed, 20 Apr 2022 15:54:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm87c8w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPa1uq5vJDCyU603LNkOBzQJQi3tnTnI2RiJ7nfhUvqroJmyR52viPmMDOIJyLCcgSI6fVokaNrIZg/fE76XmOObALhVC6/qrzQIWodJvaesasuN6if9kNqNuTMMmOfYFUQibXY4ohM+Zweq1ZDC8sW1IIOQ44UHtp6V3v4SRJCr8cS6QnL6iZPDzKw9b5fVYDsApWQ1/TbV5sgBLyI42eTKQkRedRkz2cner86BF06Yppm6lqvm2RiND9ssHNgAI5G+EJEh6PDsldhEW9mbB595mkBl2UdK7sVWjHpYhwU6CGfUuLGgTI876zlvwIpiVb69NlE3VTum8P6Rqir91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cN2dJDQ5NpX137w33ZeWe6BTTCYZFR6xf3MP4K9nh1Q=;
 b=RhRrCETi/thZY4yZdXwbe6uDHSIUJ/YICj5cD4dzNJr2j568OXO9XMJFP/J3d2BsNQy/ANFYDtKEylVKTJ3wbzgbG3RzlXNZp174ZO0klSiYILPJKAEcHkWK6JZNod6SY87pcHxNyQupXxMYdhSKW8zJPq8Xgikxo4B11zwP4QjpLPaLFvl4grBtBte5PXcFXMTus3XZKlq0JGdMjcX1jsDosPqbOLo4oUOXS5lNjl9sKqo2hkUYHAn4JiviZq+RUGY3LIYTrq97+0VMkwKczaKJdAIw02iVUVXYEZasTg2S2NFhtV5nZJGjU05/EKE/1CPW2WGnIKBon+A6ply+SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cN2dJDQ5NpX137w33ZeWe6BTTCYZFR6xf3MP4K9nh1Q=;
 b=hPxDdxxqyvvMu9nqYd9NkQ+PZY/6+eBn0JCL69f9hBgYv2bk9n1AkzwQFfAx2oNe41czZYOprc7tAywsh7RdduAUK5TvLILd11Bp8xOUIMdhB+cei3M7P+5LzX1Lld7iah9CWEntTFF0+nFIJOStWrxuccjmos3qq/3FfaRTyhw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR10MB1330.namprd10.prod.outlook.com (2603:10b6:404:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Wed, 20 Apr
 2022 15:54:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49%4]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 15:54:15 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: [PATCH v9 3/5] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Wed, 20 Apr 2022 16:53:08 +0100
Message-Id: <20220420155310.9712-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220420155310.9712-1-joao.m.martins@oracle.com>
References: <20220420155310.9712-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfcee955-07c2-473c-a7cc-08da22e604e2
X-MS-TrafficTypeDiagnostic: BN6PR10MB1330:EE_
X-Microsoft-Antispam-PRVS: 
	<BN6PR10MB13305EB1962EBD65E6E5F380BBF59@BN6PR10MB1330.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	aIHR/I0Jdjg8awHaVgATL1bwOvfQM1YelNo7dN72uY8u0x7XMLv2uQ8eIaFLxCRUgUqn6/t0392FbutTN6x0fYg/ee/rAD3+d3/FY/qLJmj5ImKSbrA2tLN4ZrZ4FWT1xfZc382b60yNJDZmfmsQGQesWLFxUrvH6u2s5NYe3USEJgwMfRQ8O+BP1hs1DlUGh78xcuJQ+WKpEX8vg/3DN37lpjOLgiUgLKv3yBaWisihOFcDhx6oL0eUEUv5ejFSV4NMNPxiQ6UfmhW3eXhS/d/12wMYi8QcnzZcjcBRzFxqC5XE6KtGZVL4ItntwOkRqh3zF0SskWAgV6AFTGYzJ6mv26MI5NX/sN/4cKsBr00OS42vjM9wDzAE/p8FA+ufLoGtHYfyYihDwIDU9+YlhV9ghWvwQWwL5U7ifgICJwTIBdHOMRH7ZCX5917V9xtMsDLozLtip+b8ggT6FNx/lRISQiaatvxEJFgLu2EAywlTxVjgZ8j0WEtX1s1vo0o8dZuxr8kY9piKoovX67wTCL6P7usy7ncIhK8qR3MO2znfDJHVuKXbjg6c7bMQvvxJGM+zGUKKRpJfdVAnfyYHPguwNOtIScsf16fLXkb404JjULTZImZBH4X9zFuKlCYmoPnaI0nTIUfNSZbpOPLFP75g9V6ROFjtfAHw2JDvdBpTsH/mWwhTHeBAD9wbv/VzkFn8lYSnVgtIc1hUCG0TMg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8676002)(26005)(6512007)(4326008)(86362001)(38100700002)(38350700002)(6486002)(30864003)(8936002)(66556008)(508600001)(66946007)(6666004)(7416002)(52116002)(316002)(1076003)(6916009)(186003)(2906002)(54906003)(36756003)(83380400001)(2616005)(66476007)(5660300002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?hFGhwJnexmjAZ/2WJ+HL/U+azibeNL6y/D12Z+11LhLjunxjeLn7jfnKckrf?=
 =?us-ascii?Q?7fq9sGbBHLC6uKOnnZRUhkRTBhi9B0VzL6y6nsW8YKcDeE3eG6e4ec0wssgg?=
 =?us-ascii?Q?yO33OJO7E7S2uSkR5uYzJnlljBnG7pC9zW5M2Uv07OABxvjmKF1U7LYKaj9q?=
 =?us-ascii?Q?bZOgaMAQffcr186/ByrbvXLD0Gxo9YdYrzN4oRhzdMpyqO/nGATmTc7T9mfa?=
 =?us-ascii?Q?3VeWmHYQZPF9KZIVLLDrzpZnea6rXukG3im8w3IQcleBz5RW2TmKkxQ7Q62s?=
 =?us-ascii?Q?jRtfKhsHAaI50w4NQjciXlwNRgvVJuIhluQeA5RnCsO+443Wi+kX91uOuxhe?=
 =?us-ascii?Q?oMyVtK/G7FlrKpaz9wFX4/1FrdnXjEpeXY0JaOtg98wMbFwKcvfxxCeghDNL?=
 =?us-ascii?Q?OFseCIWtEZdHOqC45tpsIIxeZXIc2F2P5VZWuhpfuNA1EpSciA8uoQBIkhCn?=
 =?us-ascii?Q?MyfLbH3cn0GEyZt6ByVpVb1BOTKDKhRpG6ParSAA2GKtDEo31bUc+ZQ8E0LR?=
 =?us-ascii?Q?6dNsvKoFbnQXcWE/Uanugg/kq9WjCyxvVWuXv0I9wcidZGFSNcA8J05tBx0N?=
 =?us-ascii?Q?hXqChR/5pd3/4Fk4fcI/qCV3L7/AzyzC+ngmr/7NZ5TWG//O33Pt21Wvzyv8?=
 =?us-ascii?Q?WT5spgDCr/bznVc5R2N5fmlu6Meq4dUPBiL5gXm9SEDEPF3L0UCz2SPyQB2B?=
 =?us-ascii?Q?b7o/3Ow9qHrpOtSgQeB3g+w2GPQSthEZImm6Z6MzqhTEas/cGYmfnhTmWnlc?=
 =?us-ascii?Q?f+VI578W9VJ7GF4LkTAyErLXniD8nHOoVW4CLQyJRygBfL89RaWZ4x3RxGqM?=
 =?us-ascii?Q?uHFMcW4OEnqyw4NINxCNH2DYmwFENo+HlLYPijGzcb7Bun5hH4fUnifQTYmC?=
 =?us-ascii?Q?1VZoJ8PsFGsEoU1egjI33gWnxkpewEa4ylQhc37z7GpH8pmy5LUufpWZSW+R?=
 =?us-ascii?Q?NDpIU+La3j/B3t4pA3wCDb/AADvWkLRUxTeMJove4nz+foAJwAK131OQyOYE?=
 =?us-ascii?Q?fJKp3If0w/IeXzzm12unwO4yJHkYEAT3EgWZpAtdDb8pxae0dJWOwx4vblRr?=
 =?us-ascii?Q?09ol/sTKi7Egqk6esWI5hx8n2IQ4JrKFrQjeMaCvmuthjUYFN13i/tljKAgj?=
 =?us-ascii?Q?G0e0YkzRy20/d/2gSFHapdTEBimStrXa4i98hTid0M+2UoYYvjmeX/bba8HS?=
 =?us-ascii?Q?b3O6SRCpeHWQHu0pia+eRfW3R5oRd7e81tLTk5gunTaIpOejIpeyQAJpLzzB?=
 =?us-ascii?Q?OrfT6znmRwHuW81HpAxXsemvV8P6tO5BKgVYVlistrBKnRcOP4W3Rnv56jsR?=
 =?us-ascii?Q?UOl4Nd8QJJBcWM+3Q6Yj8q9wxr0s+SMTPwKanfAtiwPRVOWQOr9Y9auT1S/0?=
 =?us-ascii?Q?q/kjuu/E55wPLKzIvW4pJzwkO9Co3C0aeOvX4s9yAHAN9BJ7cqo+CFCq52Bm?=
 =?us-ascii?Q?MT6LKbFhc7YgqM8OGh0hCNgb5jPgkB0vev6pcHOp0a8U6CiLCAclffB0Bhu5?=
 =?us-ascii?Q?97kUswyd3LTjeUO4733TDPNh34cqBhhuG85xkBxQ7doBSF/c1ZZe6PoqienK?=
 =?us-ascii?Q?cTp5YzMEfCiyo04DKPLnao7x6vZKC+wR06ZXcXFyq5rtCNXqAcqh9jZSSakF?=
 =?us-ascii?Q?ToDtSy80c+zA3oN0uDUS5ndAnf9Hl5EmOfeeppB16rXos1m2rY9uuhumYdHH?=
 =?us-ascii?Q?xpOl7d5KpMEu3ul9d8wKt/EeleD4r+gE1LDYgxv0gbwDGfDfXRAWLjSflidb?=
 =?us-ascii?Q?MEiSKuCpKxqjKaYiIt/dtXyJkh6gGYQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfcee955-07c2-473c-a7cc-08da22e604e2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:54:15.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzrZFgFhpILL3EoiHuDTwk4wb284M2mCIm2bOkx3r4PH1DK34HkzXrs5zesXvI/j+h93RF0nKlchTwwCq+1Ebea0DiXApCvW05BGStL11ls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1330
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_04:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200094
X-Proofpoint-ORIG-GUID: ypvYZDCaZJbwwC8es7m_brl-BdQZtVMj
X-Proofpoint-GUID: ypvYZDCaZJbwwC8es7m_brl-BdQZtVMj

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
 Documentation/vm/vmemmap_dedup.rst | 173 +++++++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c               | 168 +---------------------------
 3 files changed, 175 insertions(+), 167 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
index b48434300226..e0dc1ddc2265 100644
--- a/Documentation/vm/index.rst
+++ b/Documentation/vm/index.rst
@@ -38,5 +38,6 @@ algorithms.  If you are looking for advice on simply allocating memory, see the
    transhuge
    unevictable-lru
    vmalloced-kernel-stacks
+   vmemmap_dedup
    z3fold
    zsmalloc
diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
new file mode 100644
index 000000000000..485ccf4f7b10
--- /dev/null
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -0,0 +1,173 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+Free some vmemmap pages of HugeTLB
+==================================
+
+The struct page structures (page structs) are used to describe a physical
+page frame. By default, there is a one-to-one mapping from a page frame to
+it's corresponding page struct.
+
+HugeTLB pages consist of multiple base page size pages and is supported by many
+architectures. See Documentation/admin-guide/mm/hugetlbpage.rst for more
+details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB are
+currently supported. Since the base page size on x86 is 4KB, a 2MB HugeTLB page
+consists of 512 base pages and a 1GB HugeTLB page consists of 4096 base pages.
+For each base page, there is a corresponding page struct.
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
+structs which size is (unit: pages)::
+
+   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+
+Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
+of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
+relationship::
+
+   HugeTLB_Size = n * PAGE_SIZE
+
+Then::
+
+   struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+               = n * sizeof(struct page) / PAGE_SIZE
+
+We can use huge mapping at the pud/pmd level for the HugeTLB page.
+
+For the HugeTLB page of the pmd level mapping, then::
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
+For the HugeTLB page of the pud level mapping, then::
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
+Here is how things look before optimization::
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
+Here is how things look after remapping::
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
index 2655434a946b..29554c6ef2ae 100644
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

