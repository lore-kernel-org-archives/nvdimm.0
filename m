Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718862C2F
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 18:46:11 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HIavBb016877;
	Thu, 17 Jun 2021 18:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3mj1lwLN0qcqsdTuV65uEdmx7WahVMI775k4DK6dPXk=;
 b=E98V7SwhQ5RAjmAWFTCpG2qaRleuaLYLFyM9RugH+qpkkfINdtiRG66Ek7BtC4RM5Rq5
 HIU7qgAJEh8u6q0su6rCVglv3MGhYR0Pn1Ibq5Zmt1f6SHRU0iZGj0saKLY69XgPXr/O
 joKB2H+U7wtGb7rYUrv/nSq0NZfa4szKsJ1cT8CyuaCg2w5tgeXiN7xI6zBZUdmGsFp8
 JQcME8AHhECHU4jbNAWS17nysRWf2DmM9rWq55usKx39dLAs6WK/uu5kDxuLc6+VDrs5
 zJi2s0n3+j10HX0obKtFebocwuJVnGr/yEGL2Q7ys3yIn6kAgpgnLIctdkAWotW2crqE wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 397mptjh4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:46:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15HIjZ0x180178;
	Thu, 17 Jun 2021 18:46:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by userp3020.oracle.com with ESMTP id 396waxy64a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jun 2021 18:46:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWTvd00DcZWDbhmmvD2O+ZHwY0kvUcvJ+ht80oPjESE3A97lBkBBJ6YD/z179IDKYONbzqEoHBVim5qXxaeWzTDxDR9s2PIUBqlyv3rRN1TPLoTji461qwMk/NDcYArdslB9AZUGFWPgfkfUJ2UcYqtmaW/2/jgmL5wVoYngeM8YKIpdIjMhcZwBLfjsthFXtZ5tzh+p+c6MzEPtAtQaq/xbgWNnmBfoY/E4KdRlGWhfe9XOpp5vhhr2dw6OvWlHIQZOuJ2p4qPQjrE7sDk8YkljiDPvBg+4lPlI/ioMmKEHaN13bjBafyXfVBKGZ7CPAFYljVHWArATjub1CTIqlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mj1lwLN0qcqsdTuV65uEdmx7WahVMI775k4DK6dPXk=;
 b=k61XBk7XsJlc4RSOK7Wb3OtdXDn2Xqr/piiNWWLf0ESVbqKWjlYQBe1dO4FH/GJsMX+5611EiUFjmi7iPW+pxLVIjhf22/g31088PNmjmygoRrSeIAcCHEoRS2gt6pDi+tdqqH4iw1NIuZLQYCqrONfRzvKo4Alkngujof7xMjCRDNloKeg1whuedpQQQg9tLM0rsjSsnikh/m7h/hucixDBc4tDgcxzvxM46mcqm8rbCHTmjosf+r/0XPJ387M/vpueAWdVogcJegyG9M8j3NDsOqXEvo5FoR6XVVqfHnFdHC7OhteQOa9ytOndzPY69dUcnCINATYoS3lu6YRFtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mj1lwLN0qcqsdTuV65uEdmx7WahVMI775k4DK6dPXk=;
 b=ouqAoR8ly5EYR59/YKDVOIRVZnopbixUSRufpVQ/R9j1n4Mwjmaaj5lUGYRxb3QlyrSZW/fQhWoI1Xnc6rsRyeOiHsUjD4bnOGrkgb0Yp6ZFLIcnp4mp+bXh4HdAKQgcV2e8NZMCXG+frp56SQe3h1WakVO09nbjeUVOcNfNvq8=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4206.namprd10.prod.outlook.com (2603:10b6:208:1df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 18:45:43 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 18:45:43 +0000
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
Subject: [PATCH v2 07/14] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Thu, 17 Jun 2021 19:45:00 +0100
Message-Id: <20210617184507.3662-8-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 18:45:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47a416bd-32f2-48e5-4f3b-08d931c01c5a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB42068E03981A62584AC7DB71BB0E9@MN2PR10MB4206.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	z/jnCqKIejaZrNM1Zlx/P/TmwV/cz1b9BUAjVxUj3MIgCtNJZ8wOUST+FLKOS08Ql71JeiJIUpb58/5La3bmNG1Lkie6ODPxyapyMJNmobv0LsXhiReS0bh1M/I1FgWUC46fbTuU+IchBUZ7qLElmvpau3QdcrPHBgDb6LmG5d1V5HeFmx3yOs93qdG50Y/xYWb0z3MWAdsVa7Q+lb6l7UShBI7a3yJFoP4dOYJqxia+qluabAbWupJJa1SOkuJ34CXp93pkPZiK58biwrGMC/KtTABnO1HQZIBlgoS5Lge7/bbOBxllETFZM6ARTnEUZC8sN6GfT2lWNpDk76nTH87dDXc078dxoSjh0R+oV71fDFiEfqWHFGxxlkMZ/2rz1WcFMz/PsjQNI4ot9+GhUTv1HvlrwAMdTopZ/aDoYPwcZyi8vZGjPJqpiA4m7iKIIHt19f5yBa7NIQecR2zAoP4vWQYtbNh70LC0mxUr2LFCFTRlfna+XMQ2aOxlcqfE8CCfKzvNNsppqVySZl9LvAXBDzqwwxOo8qnGv9TjS+9Q0V/7oCJCyuhwkMx6x8G/WkR+zN2r88TNMavb2MtlMrl8+FbGXINfqkJ92qwyE18GOlFQflGJzFCwYHIjJ48m/t/SESrx5/VNvCT6gZLfsFhg+IHSOcdl/8eL6hLz3Ik=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(376002)(39860400002)(396003)(2616005)(956004)(478600001)(52116002)(38350700002)(7696005)(8676002)(5660300002)(38100700002)(186003)(107886003)(36756003)(6916009)(4326008)(2906002)(16526019)(66556008)(66476007)(316002)(6666004)(86362001)(6486002)(66946007)(30864003)(54906003)(83380400001)(1076003)(7416002)(26005)(103116003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?dZW/IRghpUxSb/+ApmKTbIfvnoZxkn1sNN/iBHT1UoRX0Dq3TKme8OxtVB2s?=
 =?us-ascii?Q?hKm1FxkisBhkirY3nt5c6Dyn6rcdjVpJxkWP5lSLO/3HrOTY2eljNzgoqy9z?=
 =?us-ascii?Q?as4SA27D5te3RyXlAGinmaZ62Rm/M4HImr+tXuUr4r5WdCmx0uodu0dNeyW4?=
 =?us-ascii?Q?7HrzrVTcojb2TTbvtGu7dZLdvm/6qcbEYnhcE13oYe1tBdsTattkKa5MMlKo?=
 =?us-ascii?Q?GmpTXhDbyIvILHXPwyBA3py9BuXAZwKpPznZR8OoYXduIX2IUuPLBitDeoJt?=
 =?us-ascii?Q?MU64cfKb5GkbN1FKEFdLvKZr3RwpgQjZRJ1jcq9j4f1PGpy894cwJlkAk4aO?=
 =?us-ascii?Q?I+07tMrG4ZKcck6k0/bnVcocOCd5xwyZZJIXKBCglTmRi0piuNoLQqdJgVU4?=
 =?us-ascii?Q?QN+n0WPbp1a5pMVNMyJq9wc+sMmubEMPR4HFCixVH9gBn7ewYToyuWH2Ze5J?=
 =?us-ascii?Q?z3cIGAvBtaaUKqH7yewFm7TKd363w//uQLAe9Xokl4B+RU1HuwUSLgcRYTu0?=
 =?us-ascii?Q?VrgfV3mPqLdSserqvk47ichmZunv86FW4HuZKq4PaFQiqJBXKDEylh8rykg2?=
 =?us-ascii?Q?mW2ogGC4n9SBL7nwkitxTE15eoGEluPPaF1SflBOAEXnJe5NNI/Bgm/iB0Ho?=
 =?us-ascii?Q?WSpqFSzkwLaC+0lgqlzDka5bwuo8HpfecBBFQGY/XxgRObX3d2S96Z8tiNqG?=
 =?us-ascii?Q?XIiIN3cYn0NPvw/8HwqtKfXbn6qRkmqWake2UoH4bhT4MzR7omDGdJlw8WTU?=
 =?us-ascii?Q?/yLysZqK9pPyyqwisNG9wA1HRV7avQhJoK5YvRR8b1rhvXOGhdfXp0uy7+ek?=
 =?us-ascii?Q?jkop0gxCFn0JHxscRXsyhHyPEqjkwFKswrpZRtftbWltkbTmJMQCoStqr1up?=
 =?us-ascii?Q?8nwvuh4hGbxGnxX+1d0IAa2tBqFG/U27mkAqIjLd+CAaq3uv3LyS0udiqDTx?=
 =?us-ascii?Q?fSQ3iuX6jA0+heujL66B+Ct2t7Xph0EpHvqJvmQGn0Occ5K8Edf3m5DLzZBq?=
 =?us-ascii?Q?P7wk1A8LnWBpT+KfAKQcOD0l68CLBy2H6V273tqkO0t6RnaGL38PcZcrL6tu?=
 =?us-ascii?Q?DMRQq8f7d8sGFNhg1+wRnLnjbe6Cy+tM0RrbJNn/p3z2oMCGVrwv8b0C9gxx?=
 =?us-ascii?Q?S0K4zs9NsDAk8p/RXzbzjFFmmfmCrUaMl9zFX92YMAhsjH3Q3Murkp89paF9?=
 =?us-ascii?Q?Og6XKEqTkKlaz3tkZqaEMqP0VsebSTLpdMWi7b4jq61VaXsKd7Tbt/wTYDL+?=
 =?us-ascii?Q?nPdGlk/0QaoGYnBPH1FLrO/FJP4V12byne5bC6tWHOiXRrEvV6Q2IdLjSRoE?=
 =?us-ascii?Q?MtNa+Bv3PeKhC7q7nTMgckPb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a416bd-32f2-48e5-4f3b-08d931c01c5a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 18:45:43.1147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Cim6kK80vwKXAPepWPXLrtNEOZXI27FfPCSSu0cbust0S4vXh/qA4nciE3FEFU2sx8/7wSOfJOebKOso4MEtR+2hq2v8qzBM59qlmpXW90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4206
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170117
X-Proofpoint-GUID: RIwiOldhSB3jbstGN3wyY7wTycuroupr
X-Proofpoint-ORIG-GUID: RIwiOldhSB3jbstGN3wyY7wTycuroupr

In preparation for device-dax for using hugetlbfs compound page tail
deduplication technique, move the comment block explanation into a
common place in Documentation/vm.

Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 Documentation/vm/compound_pagemaps.rst | 170 +++++++++++++++++++++++++
 Documentation/vm/index.rst             |   1 +
 mm/hugetlb_vmemmap.c                   | 162 +----------------------
 3 files changed, 172 insertions(+), 161 deletions(-)
 create mode 100644 Documentation/vm/compound_pagemaps.rst

diff --git a/Documentation/vm/compound_pagemaps.rst b/Documentation/vm/compound_pagemaps.rst
new file mode 100644
index 000000000000..6b1af50e8201
--- /dev/null
+++ b/Documentation/vm/compound_pagemaps.rst
@@ -0,0 +1,170 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _commpound_pagemaps:
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
diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
index eff5fbd492d0..19f981a73a54 100644
--- a/Documentation/vm/index.rst
+++ b/Documentation/vm/index.rst
@@ -31,6 +31,7 @@ descriptions of data structures and algorithms.
    active_mm
    arch_pgtable_helpers
    balance
+   commpound_pagemaps
    cleancache
    free_page_reporting
    frontswap
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c540c21e26f5..69d1f0a90e02 100644
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
+ * See Documentation/vm/compound_pagemaps.rst
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
-- 
2.17.1

