Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E579A428B
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 21:33:49 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KEiiR017342;
	Thu, 3 Mar 2022 21:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=xNy3M0JCiVHPKx/2RF2Uxyj73Bmrdc6ti89CNWqoEs3Km6Ww/FWHY14Wt90tdNqnX4h5
 LwhjD0AEbbAHVw+27X61B2fRYagFIvpCRY2YJ4YYOsZbqH8r3s1AxDAGBKQWVHn0akYY
 SxK/WUb4qePa5o5aL+9zh3W4dU/Sk38iP+l9mfWfTcmSPivnnNS6QD1RP5wzawsvlEic
 lPX+eKZgTRPCJ2DhlH+GMUVygH06y5kniZtb73UlKilS2lmDwAVSpCY6BJRHMMFMKqoc
 VAAAPUO4iBcUiI/eIHFXlKeL7zz3Songg79pv7IwQJJCSUw+1CxgZSIqv5Rr1ke8+TmR 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hvg5he-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223LKt7t132037;
	Thu, 3 Mar 2022 21:33:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by aserp3020.oracle.com with ESMTP id 3ek4j7tq0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQO4eoY8cy7l4PtWBaRTVn6HC73z06n54n7+jkEGncf5eBtO5gbZbGJh/0b989Rj8vT4ItuyyDeFH4TrEYQetj2hRkqS5aW51StO95I3LAZeYi2XbP4duXmoHP7YTg8wgfP0W3OEudiNrdQ/m63/mvV8ZwUG+16+i8Mq7NPf08sSK1ebh7N1e3FqWaeIg2ZLBfKHKYT125IkJYan8hoe/4YjWHwdGiAYavkOzA1WNYQWMYFOP8OHcGFhYex//p+fLjUaMCR7VRGo8F9mJ3L5dfmPAKfAicnUR5dRCS/tWmZKKhPSyvjEwO0cYCV7zvIdLDz1mS61nBmF0J5s7PttTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=JlQJg5LQkfn/tmOkuRkTR3rR8crf/HEdIML6qQTy3kyyOaTQwI4uFmZXNmTUWe40+uQBk7U1G9Fv32+ea1Ws4DckYWLurBnSidjUtOuk+swX6ZdWakrCJJtL0YBOQp+7pkPglGEQZDS4UzBV2gbX+uOuJHGXbs23nfSKY3KJNQjWsn7f1u9PrUMTue+2N1fg7kKCI80wIcxZKiBx7Km7iyBGHYOMsrc4hE89RDo8ehormBtVfNWZlJHvM4CkhCyLEYklcsEQjm4lkTCt2xi9rQhE6VOygewD1kN6D5XqUtFV70iOAe1FmQ3+y8Uv/jK6azc5SmiOwW5TrSBNLTUjxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBZFKXBhUVcGaQee2IQyxW+Dj+TwY1lOwgsfsaR1Dgs=;
 b=rWWKBh2R2j/yNpfMd2AkAAw92yCyewetcpCdNxoMua61UHPn88UDlkPxTScGaljc6C8JvmJI3b5THeYjyaU0dG4K2Z5SErbLBgeF0QyrLRlLT/7QYYC/t6AOp5wtCYUj7S+dvwmS1HwlPf/ecpYS0RbbywI7PgQrxvDiT1TbfuM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1658.namprd10.prod.outlook.com (2603:10b6:4:4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Thu, 3 Mar 2022 21:33:33 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 21:33:33 +0000
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
Subject: [PATCH v7 3/5] mm/hugetlb_vmemmap: move comment block to Documentation/vm
Date: Thu,  3 Mar 2022 21:32:50 +0000
Message-Id: <20220303213252.28593-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220303213252.28593-1-joao.m.martins@oracle.com>
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0036.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbd7606d-25c3-4711-7778-08d9fd5d7786
X-MS-TrafficTypeDiagnostic: DM5PR10MB1658:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR10MB165852A57CA1D94235F3A9D8BB049@DM5PR10MB1658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nO4Y0BLWHDwDCycdjn4BKtTrazwfLcquRCo0Vb21dN5ARjY60tKYQM0UodRv+YbnpgfBY3IdeV+Yqx1eZP+ESTpe7LQe0lEXNAN2g2B36zgQsRVdkvtKl+xIgW3i5Kedi4y29zjcqEHdtk/D/3M6LxCqGwKkh2jV6PH9Gm36ymxrq4sKkwP1rhgt60hCiC1wIjYrSeopG/rTO3iOUrvfd3V98MRk+zhqmfv4JvRvd5u0+TIl/BFk3kP5QI5pvS8U4hrZFCaJg9iIv462NWsDqDlfXwu82AN1GSijyD3JUMVByzb5/qcgoCEHpFZq9BICoKkEB+R5sMs0kA4yGPFju+07KkqH9DPoB97gOsG8re/ehE2h++qqyn0QXQlgXVd23LgkQqPw3FS4FGctUL1WPpLctR9sTKVmt2mTAkEegfXfmYnnh+web2dsL3+YNrPZ4lN8O/iiLkpCkd0vAjSIOb2v1badRsZvjZzp++zryj8ehEnh8x+9zbcGx/iYD43Cgc7unT7ezgliz9BQoA/AMcwHb1Y2mgeytm2lScHoeflk3lTJP3Roo6WczNDhSJBHciNKmfDFXXDbDWKtb6zzvBrcG6oxr+v8FqBY1j0RuX6GuOPG566S8qLx1E80Z0c9z9aBOxqqCZA6Qd3UytFxI5y+Br17ZcM+dbXiXkOKhi1cKimtYtcXBmn+vD/E/87LaczO0QS7FmguarUPDgRp4A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(38350700002)(186003)(107886003)(26005)(1076003)(5660300002)(36756003)(30864003)(103116003)(2906002)(7416002)(8936002)(66946007)(508600001)(66556008)(86362001)(6486002)(66476007)(6512007)(52116002)(316002)(2616005)(8676002)(4326008)(6916009)(6506007)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FXz9jlfDX+zIcQUm/DdaPYjqqff5un6GF0zii5BMQUrcC0hGxro+kJNef7NZ?=
 =?us-ascii?Q?qnQWWQ87hP0QURpVE+TiGlXDHAs3GCBOYtaqdBG6i5EvaV2v7gp6fMkBh5LD?=
 =?us-ascii?Q?GFclQCBIzXbLvh/EV6WSHT3OoX1AQFZENpAu13EW3RyISHDS1WkJGqCRTn4d?=
 =?us-ascii?Q?f8SJQArxYHR35UewbA9ZPPPDrUqopsywFUZ18iR/SknA4hiWcrDx4laQxzLx?=
 =?us-ascii?Q?J+MD0avkZzXL0J5ZFOX5U8AWAF16COeJ82e14FBmlCBEkTG6byoZu4opvYEy?=
 =?us-ascii?Q?AxZwcgtvEF1l/hKWn+ZJXSV29KUW1jmH/3k3OgWVmuZc99AdmSRcVYE3DR/g?=
 =?us-ascii?Q?6AIgn5H+FpqXiLzdDwYXwc044QmnSWUgEoulLZIYUfClS/DJ+dRuVjsSBnGN?=
 =?us-ascii?Q?vVBgS2tYfNAuFff4tEKMsF50Mnj+JaTToWmephVUpjrT4jejdMI5qKHsM6QL?=
 =?us-ascii?Q?MIyTiwyH0FF79mJ6ueVj5SXb38qkSanHGBmoPr0i8qrFeG0uKtMmx87j7a5a?=
 =?us-ascii?Q?DQ+8DpdJA3JZB4u1Elo9z3fYZ3yJR5ayh8r5p3rg5csYuB3VuArQ416e5GjA?=
 =?us-ascii?Q?vcWN1A5/rSeH6pXKAdA1J69JSXUpuUz9cj6wOZMxOi6FCIsSYia/SpIOX+rg?=
 =?us-ascii?Q?nSps4GwR/5ScQzMiRaS5K7gFYPq4Atd9AeZv8EnTor1CdJIqWci/taXJXdPW?=
 =?us-ascii?Q?kUZxiHNnRtPfUASAC2h9O6CYh8dYNRrRgbOMQlMTWoherhYyx+N3W/Z8CG2k?=
 =?us-ascii?Q?1xsRdQ0lc/HzquvQXmLg6KqrAMMCS7FxG6Yg6VaX8oklPbLlUni9UEKeHzrc?=
 =?us-ascii?Q?smLmtMaQMbV99rwun53OzjdH2kvHrcg4Qqk3lmPXDljO/bZFHmMPuXuqHmXE?=
 =?us-ascii?Q?KiswPbzJcyUC60IJo8avUajprHCv5N7di65DeU1Ht5nDzblBMOrXsmY59TyC?=
 =?us-ascii?Q?596obTW57VdzwJIQjhqU2TPA4ICr5RJIcTDCvEizLXvrFhyk16S283FmPEdp?=
 =?us-ascii?Q?xo3pT9wpHFcRXnqUd4tx5QI6k0YO6dgSUUqvjkWg/DfqcdhfP7XZvU/embzg?=
 =?us-ascii?Q?gp7kgDRTuW3c75mlRQCND8/CN9cuYPUedjoyjonm6IXiL+XceBOdW7FKA068?=
 =?us-ascii?Q?Sur0tvLRliVkeCMzrnAA4HDYK5vJOPAcXR8H6PDCCi0iKJabXrvnRHffREQh?=
 =?us-ascii?Q?827djswP6JxYeQBiNyaJQkuiIthSxUOg4OiT7MeRo2E+tF84gJIcC5NN6gbL?=
 =?us-ascii?Q?d6MaMtL83AzRSnIL08+gYddv73wpSEgJL1Krz14agd0NViYYh+QgtNTpjy1c?=
 =?us-ascii?Q?1BLaUfl6DtNCFpRo0HyVcQuggJxXRTEgyQK8XbcK4GUK9tT2hcoDjd0tw9ya?=
 =?us-ascii?Q?vCGacSRRMk83nYZrLbeZ5D+/ZyXqhE2vZxpUtyLHxUgmoHAOYJNARJLt3iqH?=
 =?us-ascii?Q?l7WbPip++pyoZUY7v8fXj6NJWeEMhG6R9voC8dhMq4gVEb/rTjPoI1B9qvBg?=
 =?us-ascii?Q?b3m97RM6ejkrdPnoA8l1CN798TaBH3yhoAJuAweI1hvhhVyU77GLG7Reo7Bc?=
 =?us-ascii?Q?iyth78OtZOJtPLd3h57q3gqOF8tGbSz4lXUU5pHC1fC6UGoCP1l2HO+ctOmX?=
 =?us-ascii?Q?++/ZZ8KA/8ZprC9x5QwhgYYwyglXYsM9eN03FK48d1X71J6J8EKnQvV15gib?=
 =?us-ascii?Q?eb1L6Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd7606d-25c3-4711-7778-08d9fd5d7786
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 21:33:33.5609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fn/F79bXU568ilnQMnsNjB1EUa8E+uQdqtyiqWVaLb40nUKV6ORaL+NA21BEwgBF0Z0jDKOZ4NZMPwfztYMdR54VF6PuWBF3LcXxbxroTGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1658
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203030097
X-Proofpoint-ORIG-GUID: TVvnuv77LhZc0zyZUCXTqIM8NtaSYQ7i
X-Proofpoint-GUID: TVvnuv77LhZc0zyZUCXTqIM8NtaSYQ7i

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

