Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1845F3406
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:44 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVCjN028294;
	Wed, 14 Jul 2021 19:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=u9glgLq7pr1iwNPx5tMgAhYw42aywrTzKkFbLrYBLvM=;
 b=RDz+SNmpXTOof7iusbYqoX+FYb2sSbs0TabV4M/o7imVw7lO/tzkeWrsFl4yqF9RL6An
 Ylf/68Gb3CANWKZCdtxwjbOELCq6kc/fLzOf9rIbR98pz2nufbrXS2JGSsBnL2wtxqlr
 BIYtJpXXCgcFWCYmBv7uJ0J4C/+xt+jQ2a5sSzGsuFu+9RsZlWebYW74MpmM5CD3jSXk
 lo+bZbCGnju4RAnYW6/HTYMxgtj9riSO0cO78d2nOySvdihgRqKIwNFo3q2oqt3+6BCM
 a++5nVflBDW9RSvZmNzSoIef4NZoTtIDGAPA0K6X8tkRrCBPpvdMBq+09Ptr9okc0LRz KQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=u9glgLq7pr1iwNPx5tMgAhYw42aywrTzKkFbLrYBLvM=;
 b=gfD+AJW3VEvs6k1s9ZfmtEAgvwkXrJpL6KW/RVXOXnSAA4Cgbp+rftAQ6GgC0Lhik9Ny
 wuH0iodv4UbT1FQMpwvMcCZvN+VLRnq124citf0GiaBy5ND4bQfqdl5J9JxyNJb/zw8p
 1iwfLNuhPzMBvdyVYhnrg3OfPvS8dyNtO2nMsCMdNO6C/+wPsKlMzQbV//7I8MYOv1wd
 xKgyHzhCY1Ne8NMzP3LeLatZXqGiInL69L+iBeLKIRsWpwbs8dW8Akgi5FlmlKfvawxK
 AQO3Ap2kOeEeN/44vmHoN6MWwXoc/92VHBxXgITrymvBdFhU/XlCS5ZimzM2/mB5YOxP kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39t2fcggtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJV1WH079823;
	Wed, 14 Jul 2021 19:36:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by userp3020.oracle.com with ESMTP id 39qnb4295u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgHENo35TX3jpeNVQdLq0XMjnpfmikEylHhXhZQdom29NigUOIRi4Y/NRUdeKW723jfyhxwim9/Ed997AW7Otxclcbr2gFWTbzRDDUO0Lp7sZmiFs/3jhhooXlBwnB/TkMc0nLSU8Z/szQ9gd9qoWHHwDX+8PCmbtYpqF2TX9oI2L4zW+zRhqD1XBLB8QNHZt6M4/Gq/hPUhduSg69Iahwcz5Zl2rG5cKRnsMExEPE+ucKvZ5UAZcQ/4dJELcfDlHd14ED3B3iH0JjP4Tc/eWIlubE+RKU+ZqHwrB5MDu89IFQ2YNXveVmxUn1xLVarcP1IC4ejiCAROYwtiZY4DGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9glgLq7pr1iwNPx5tMgAhYw42aywrTzKkFbLrYBLvM=;
 b=Qu43Pqp1reyK5Z7+uQqmJXWTjzqtI0xtFYy7CglODS6NcXwqsHktY1M2hILNCH1M0Nv4+kyo2OVFU5PI6aJOWz1P/Kb4O1Phx9Yh3iVI6tGrJ1fA6QllfgC11Jgsttmg/k88CHrQL/6KvHTSPShf9Ku1dOGjc+IrC9bLNMDdCIaEjkZiM+YgsEYbutxq3cq6iWe2T/+jJBpOdlkKRUH6gm+CawzDGPuUUX3yXihsNszCBNQ2PrYiDoeTD+r6KVZAanTuYFcYObwCrRQAi09l4yfpq58OsCefjeFbYKvAn85GRQ9d7aOHWiDo9GA3NSUEm8/HlvkfUxSj3489G9cdGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9glgLq7pr1iwNPx5tMgAhYw42aywrTzKkFbLrYBLvM=;
 b=RpOx2DJbhaejp8nkKFiBfsC7uxhLthvJXBpp3R37gHmVoC+bbD9df08xnfS4bfGSelcPj5YzlJ38qW+5xgqZkdV/cy1ZalZYQJ3siVhvEyACbL+tRqtWDdC1Q6wuxZK0pAdScvbsOOol4/OXxRGpX7jWqja2DJjw5fHbmvq+TnU=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4368.namprd10.prod.outlook.com (2603:10b6:208:1d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Wed, 14 Jul
 2021 19:36:35 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:35 +0000
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
Subject: [PATCH v3 14/14] mm/sparse-vmemmap: improve memory savings for compound pud geometry
Date: Wed, 14 Jul 2021 20:35:42 +0100
Message-Id: <20210714193542.21857-15-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8d7434f-df70-485f-21a2-08d946feb0a0
X-MS-TrafficTypeDiagnostic: MN2PR10MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB43689AAF3F9BFDE9A121CF83BB139@MN2PR10MB4368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	h6cByBZUn4grEZYs/ArtHeOv29eJogEYe0601whyx0iWeXnHiqgshruV/pbW4ysnfmHi2itVbpaDOyWjJejtAh+SLoX9b4e/WfwoBWvZ+wISGgEWUslEtdfEi9jt5FcNtaE8AerjSjLxchpf+zgo6oXz7FM7dfOdDJb9qsfvn3jcb6yK5xxyi4dSUbcHqwo+5sCZLHK9Ib1NTS6ZbFnY35/yzPY9WZqaG405QQcF+XD0rdgxgTpXmDPIZW7YBnBWyXn3ps3MomHYy4p4oP5IqhyyYX0YklUHkpscEznlqUyG4RSywaaTpxByi4E9ZgtqnFEi/ExagYkaH8urb/wOie6BV51ZnVKj8YGPeym31RQMQNe0EFBthsBUlwmrJMURJddi9JKzn+R3HGx0A1Xq5/IYFszjw2Q2cPanvsLJykOIPqICgoU7dVib0ImJzww7v0G4B9fptsPIijIfekoqY+m7WMG4pozfZlffQbJazQXQWoNAlqN/xasv4rByubWYhJL6AK9Y5XGbty3XojWAMLt+277bpH7I7C3SGUxZsTCt/q5Iv3Jhk1xxvUyu2k0w4nhwoFirSyeJaP60UT7HZOxpdu8lqzZk8j+oO6pTZaUxio8llLLfVNNXWOI4BPovXnBRu1b57WPYXnDUL0s/cXEqTgCLQO3Gu7S629I5mYs7lQTmfg99xynDX8MIfgP0QHIdqGPr/eAnyYtP3SQHA5BuSdRc4v3p7HXPYQRZ0hk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(346002)(396003)(7416002)(26005)(6486002)(83380400001)(8676002)(107886003)(36756003)(6916009)(54906003)(103116003)(8936002)(38350700002)(2616005)(478600001)(6666004)(86362001)(956004)(316002)(186003)(4326008)(5660300002)(30864003)(7696005)(2906002)(38100700002)(1076003)(52116002)(66556008)(66476007)(66946007)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pWKYz+7skNHdxxv+AyGwwLQmLzBu773yNr8H24ziKuTiENaALbo20lt/St41?=
 =?us-ascii?Q?da1WndDacAnUbfHTViwGTyKddi0lQ8UA74Z11oNho7BFtyA2jHHFcidG5GeK?=
 =?us-ascii?Q?W5eDuk5TJ7OH2FMOr25s4eJT83nDHCrYj/k2XtGh3VZrBuwzWtxkHREh3xt9?=
 =?us-ascii?Q?T/Qrw5H7HRsk7p9unQ2kksOWj3vmsZcVCORMmmq2rONAkxdJvDH6ZBjWRx0/?=
 =?us-ascii?Q?Bslyu9eAycL9R7oVoxDQlnX1+0icad6tCEP0w7FYtXb9lyyQMooOJFSJBTpi?=
 =?us-ascii?Q?5jsOiTUqNtmtGctR586ejZyIuoF9AReL9whEWpzhIZUmQjDfHTtjYCbjDkap?=
 =?us-ascii?Q?3IywnHLlXztxisC30oLPHpsNwBxXheqD/icOpvLAq88FFwnkgn5UnSDNHmoW?=
 =?us-ascii?Q?hqiwBpY8lpkH7y/0xgOHl2Sqy5Fr/eRt3QuRDHJwja+ONoObNBA+/uPo2ptu?=
 =?us-ascii?Q?URN93bhBshWnyumaWYAeq7WMsHIAyBHhpjuQLZpDe9HqZyF/b6ALTAuKWC4S?=
 =?us-ascii?Q?a+i7XDd1HiAP4P5yO4yglOfoDwUAVrsEKr+UMaQpoO7+hA1lvoHjy8smkmJA?=
 =?us-ascii?Q?ZPepwHy61bI8BfhxtthHxWKFJJmBGUl1pwyaXmXcG2SKDt2WFNHkR4R7jFQK?=
 =?us-ascii?Q?3088V8HW6gyqh7rGNs/2e+RZc/yEdYb1Jc6QMr2ht/3M+8PBaWg0xTBj2ZO4?=
 =?us-ascii?Q?o29km+4If0+F+g63hYoo2Os7nv/QQPB+cVZ1KCMCXnTE3ZhD8WlgMa096NLV?=
 =?us-ascii?Q?AuOylRECGVsRGw10zMukuNNTNujghS0r6su3e4YXQdkLeiHHoYwPDRlZpo/n?=
 =?us-ascii?Q?2OWF+7fQ5SHJVvvIR+JctMLlZ8eEnDmFUCDsnUyY5t1EF2iaF6wOktlTYord?=
 =?us-ascii?Q?0QookR6dq4jeRAd6goXGLBz73rRVtLrWKgtbrP+SBKMTEgJ8fyEUjIjUVZz4?=
 =?us-ascii?Q?hHLtHmdFMhFMcmFNuK32wFkMBBUqzI60VlD/loPUpIV47rUfdGjkzuLgTqng?=
 =?us-ascii?Q?45S3HkE2umsbvIE9f3O0CjP/fpljeq2UoSV6ZiOtQytbaTEDVM+rBGlSakU0?=
 =?us-ascii?Q?GRZDzRkIKttI4axz7zSgqWRj09hoMeoXAhg8rho4wpDU9EHi8YY9oXXpzX0J?=
 =?us-ascii?Q?T3q3r/3rnF+ipE2B2NJkY/PcyDO3DxVrBjCvdsnbFxVPOj4XwJ+XoGpKxR8i?=
 =?us-ascii?Q?tkazyB7MMwJzRv6+/nr3MvuXc2l7PzDqu8oirz8MGf07Q3OSpXzIJX3Xj9KG?=
 =?us-ascii?Q?Kwvh/jCZ9GvQi7dPQe8egkIvE6Q4bnk9k1X+SEH4nNDHvO/JREJJch6nRjyP?=
 =?us-ascii?Q?HeUoigs9VF/VXdWJEpM7S2VD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d7434f-df70-485f-21a2-08d946feb0a0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:35.0658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nf6b1hhvxs45WOvvw8u+HOojSyxREvaMs6Fkr4puGWMIZSkEvAhw+UMLDJ6nEvVTyxN1L2xNTsgDheqi+lQKClxl9cNGU3taDZyOTTtc4x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4368
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140115
X-Proofpoint-GUID: Cps0hVHBooy3oufbcb3KKALHaJ2cbJZ1
X-Proofpoint-ORIG-GUID: Cps0hVHBooy3oufbcb3KKALHaJ2cbJZ1

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
 Documentation/vm/vmemmap_dedup.rst | 109 +++++++++++++++++++++++++++++
 include/linux/mm.h                 |   3 +-
 mm/sparse-vmemmap.c                |  74 +++++++++++++++++---
 3 files changed, 174 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index 42830a667c2a..96d9f5f0a497 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
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
index 5e3e153ddd3d..e9dc3e2de7be 100644
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
index a8de6c472999..68041ca9a797 100644
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
+		 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
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

