Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC193B38
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 12:25:39 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227Btv9U028756;
	Mon, 7 Mar 2022 12:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9NzCFt1Ozy2mhawUz8VK277naG0+CSyaJzZL6gsG9F0=;
 b=BzRK7aNG02zS2EilykdZGa1YCqW696dyNYTpuH+Sck2gCoDCsizj6ORdddAnSetXfYOP
 pFQETYKpvJ7qesbN1K2LIE1QERnVh7FEBAHmNzNmaUnTG/j24uLpqcysrLW42ukhQBll
 VPmlcRIXNK8B7woBIQhNYx35PSsTkeXfaQ7tW6uYAvRNN8F8Gc6FyszA1frinOhnMFMv
 Zia8MGM8wwQE52bxUpC5LkZuGR6aQYT7VLQaTqIOEKTyDfuT3KNeMat5ymQME+z9wvyJ
 7OjIWOuL5OXezzS4TcElmNXOjnoSRfp4jMacUdRePcj85iqP3d/nUsmGxgo3pDK9qgtG rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsbkc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227CBrRl143497;
	Mon, 7 Mar 2022 12:25:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by userp3020.oracle.com with ESMTP id 3em1ahx9b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFknRgvnz25DmtfMbUg9TtwVHBqs2n/3ouR0AUQiyshku3yGIjbfWDR+ovC55dnfs2qwf4kiAkDA0K3ar4SpRfr+gy18d28EWD8O+AICuS0FCmt1N8KpAG7diXKVWru0cpH3lV8EiaxB0ZEsR7tn9nvRwx+z8SA2zR7slNNUucZobgtCXws5k9ygWgdSLUKY0hDgOUEZVCGA16k8slK/LQFnyUqObrzEx2gtA+TOh1Z1LEU3J0nDXfguoeVXGSYsCB6robYaj6K4gtyWmnB73FB6qqu3yS8me5zIEYaME2Oeu9d/dfVn9R9RyA63BZOoqfpKhvU/592tNAJ/86/8UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NzCFt1Ozy2mhawUz8VK277naG0+CSyaJzZL6gsG9F0=;
 b=AEZ6vX7VmuM6QYMKGwAeToVuS6uxIr+HCiOyhC5cdNa09lF6DxvtqceRzkTe3VQnGWnDoTnAPnwdN8qX5M9qlXU6w2FUZ39A+bH8H5o8uvbVqFfeSHijZLkEV8n41FumWNUGGctIDIoc1H+lsyyMZmA4b53iZmY8qsvNuDyQiSRpmX9926JS7Mjv1AG5spgZPEfL4uGldTBjYm96EkHqQqjUYeEcllWv7uMaQSolxwcygLJ6YrikeIgP/7ymakhiU1LGDUVzf28LuuyCd+257zT6UePlEAkIom3Od+r9bW/w8s/BybEFZpcUE63UNGH/s46wo4Cq9XnDIQONwJbj7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NzCFt1Ozy2mhawUz8VK277naG0+CSyaJzZL6gsG9F0=;
 b=n1Fw+jraVA7RPLbGWr9z5f2h9C7EudImWh+PdlnH7dD+hdlIURlZQGth+OQJRJlltTuetUj4B+TCiCodfft2d4Yevzf4g4U5n6ezpV332xvHxcARv4PZBtG7Vd7B+bGNOoxf52bNDUSRATiPOP9F2RbHDQng2DJLLjUDBaDq2IU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR1001MB2284.namprd10.prod.outlook.com (2603:10b6:4:30::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Mon, 7 Mar
 2022 12:25:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 12:25:15 +0000
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
Subject: [PATCH v8 3/5] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Mon,  7 Mar 2022 12:24:55 +0000
Message-Id: <20220307122457.10066-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220307122457.10066-1-joao.m.martins@oracle.com>
References: <20220307122457.10066-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf492a30-26e4-433e-2133-08da00358894
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2284:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR1001MB2284B8FA391BC1F7ACC5ED21BB089@DM5PR1001MB2284.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	SMt1wePKKoXjAdiPZjI9fARNTi88BwsO44ppLA/nCneujoQgnY1XMLvdxSwop43Y8Pz63/V4ybY8bp5EC6gbC1FArB13XUFK7tldexKFiurmhgrkvGD6YeAqdOc7ukQIAeU0vsG8ryA3UoaGnxlGGM0Hw7of+7tyyJLp/X0OzdePd5z3zO/woPRReCaHD/ZIimuv3Jl6CDWVjoeYGIoFZT3GpfH1Gr27DATSSB5zeWZ23s5k8spSG8Dck25yH4wgtHKpK/5j9QeJhcvsDpa6F+8Wf8lv5/ZJAsVZAs5Z/+FboBTV22WYHkVWny5hMMqcFZZvQp84fxBaAYlAWnX8toKGLfl5pF5khImuWZh+zyvoDmiJU287Wwka4wx6uCu0wtF9Xgzc3cx3Z6iRBVeA0mKeDeToHQ1VsFMcg1y+jzL05Q6IYXN3Qspa6GzGDkEv3kBxDHpqw5DGLDYHI9lrq1PwMC/OH4G6s7/VeUW5SMcR3T4sK+HdTpFNeT7oMDl7VFjQncm8kIm2qxs26XTjhBdDYlCIVs0BTLcGxmu8U5Nn7FGlKQ7n/JUPHMfXIQYM7uBkhNtHTCcyY2tIjP3Eu6cS4NdnQgwWEhsC2kVmuG9ZQilgY18DDpBQFdKELZv7vas/WnMYCG+NxkFUG3I8ZoT3/nzXOdQoWiMLKhqDphOhocwJk+ARUJYAXDwtR0BP7WciWlCe0+UU8FP+sKYi6g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(4326008)(103116003)(316002)(30864003)(7416002)(5660300002)(8676002)(6916009)(66946007)(54906003)(36756003)(8936002)(52116002)(6506007)(6666004)(6512007)(6486002)(508600001)(66476007)(66556008)(186003)(1076003)(38350700002)(26005)(107886003)(38100700002)(86362001)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?//7kRJ9Pm+lnxoH9fMOpGgrXXsY+PNiBj/9KKlq46Ut0wDgqmh273OiZKHi/?=
 =?us-ascii?Q?zmUXb60oUAhizMFWc6FWB3sG0HCY2jjAiD3VZnDX521dqMkRJAG9UQ4NfwsD?=
 =?us-ascii?Q?g5+xNvq4Q9L00fK5Uoi1Pe1kXcYup13IEP/7bPRcoAa9n3j9s0Fqw8yxzpta?=
 =?us-ascii?Q?qOJBNy//uuTKjpQKmpA3UKaGDR5vZPUPlH22el+3mvzsjuRhd4p57J9tCnvN?=
 =?us-ascii?Q?xRhdy5g5VGjvM9n7Yd7Qvs8yVch2E252teWsFrpREaY26zcDn17BEq9w4th8?=
 =?us-ascii?Q?muTClC92T+38SYY8q08lqgP9YWA+tDNu0M1JwAEIdMAY28yATuAaP/+CIbpV?=
 =?us-ascii?Q?17Rr2J8geI8s/9ICXFOmsPXPHni97PBXXDvG8j0AuWTOBjF3Qajr0ldhZFct?=
 =?us-ascii?Q?erSN8/jtbmXvqsJ3QAcglezrGXR+D4j6KN5QuTOuYjqYd3/psWTotu1+XU0h?=
 =?us-ascii?Q?pUojbzoqr97kTj26YcCUyh5G4FZh7FxBAJMefxuEGpzalrP0xKBZ+J6SahFI?=
 =?us-ascii?Q?8Zt6tuRp1NBckq02+CogBbfB7VGKgzlfTyXDVGouKtx/sHYI5oLUuxZhCeWR?=
 =?us-ascii?Q?xFAtaS13O2S032DP599k7d5+kpjXH+ErkUqYnnScT5C2ZgSNCksqIGVyw3iT?=
 =?us-ascii?Q?iYqIGrMb8k94c8mPecuWHTczbNIg2jdrPNVVeun5TU+W3WCBvifDDwRPSgTK?=
 =?us-ascii?Q?edFkFltwAU0iL4kApb71uaFUMJKAZC7/IGPb0pPDDFrmTyJipJDe6hT8rFZr?=
 =?us-ascii?Q?ld9jYo5JZ8bqxM5/J7M0PoQ23fCXn0IKaR4cPT0pS9AsJ/TeotArG0fjM4hD?=
 =?us-ascii?Q?891qmVbHq/mZF2uFPZnlLdu98m3CfBLyzfvbomvcQ1ZoY7HjMxlFfKuDNv3G?=
 =?us-ascii?Q?P4YU8CwRPxb5bjW8dC3PxbfIMvi48RTEWIjmwbFpRo33AayrPF6CdqEqBh+Q?=
 =?us-ascii?Q?tc7JLJwwclth+TLePi8x75j2ttMD6WmFE1pBbNLMH1bcZO17vWiF41bSBhUL?=
 =?us-ascii?Q?K6jG9LafQaH42cYTmd2JTav1EVRIz3sEnIkce4mzn1bj22n0EPnwJlIISBmJ?=
 =?us-ascii?Q?kYn4Jqrgc8nf5omSEZ66kcpfv9V005zujtPQXixZCc7wbeVNRd08mbBEXrW1?=
 =?us-ascii?Q?p6DSH+Ftu63dIOrtzpV56KNm/RVzYZX1pTTVtCUNVTZyF2ZMxMgfFk3wLSMv?=
 =?us-ascii?Q?4ut7AbF35N/m7fmIIzFnMSI1VlORlNx0bprk7/egTLzYu3fNqmzsEqzHnrs+?=
 =?us-ascii?Q?VWttzP477MtJdyLIGGtcI4zZbWJqVyyFDiFmsXPkwGp2QZWdBP2ZYn/Euq98?=
 =?us-ascii?Q?ajM7dX8qMO98P1m2BTh91TngWPyxD7VZZ5yEwwIRsAF+Z1CZr6/Xk3ND+/YT?=
 =?us-ascii?Q?OdO7VRTWS8fsSPZdV1hAUrCGZJGGDmgUk4e/4XVNoGUfeX+zMX4bQMjywQUp?=
 =?us-ascii?Q?8EgCGy0pT+EWSJUnfHjh6Z6gMcS42A9ZjH27xOqzgQT2diReyPw9i++EX37y?=
 =?us-ascii?Q?UmC9F6RTxh1DzPAXXiPFxFr1qqyVnwPxWsN6CWxc5mdiLWgjoV5gbeuX4kVS?=
 =?us-ascii?Q?Q5/IILisOpb2y2evaKkVs8KLDc9ZKnaHLjM04lAFJ9pF2A6G8W+sOtqlvKY6?=
 =?us-ascii?Q?+wSnGE8+X4BA/o5PCwLxdUjJdlW08Tn3ACX2NRk3w6NoQBp/ppWYtLIuNwUP?=
 =?us-ascii?Q?H6vWiw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf492a30-26e4-433e-2133-08da00358894
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 12:25:15.3209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wx6rm9QbyWIGrGINod+RaOvF35EBX35giyMJfz1BqVN5hpzd2ELrolKMosWqb4gf19gFScml6aDs+7+UkyIhVoL5GiTHPIlKsUYA1dgNXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2284
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070071
X-Proofpoint-GUID: OBS4tgCPlCzbeGSZKAL71KJbi73rAJiQ
X-Proofpoint-ORIG-GUID: OBS4tgCPlCzbeGSZKAL71KJbi73rAJiQ

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

