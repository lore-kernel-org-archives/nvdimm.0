Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAA16D34
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:36:29 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EJVdnD009369;
	Wed, 14 Jul 2021 19:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0Pvcm+J+3I7j6BU9TtanyoN0Fmn8A133iSAWo+cf7Sk=;
 b=UDPRvio0pcN0G4drwXjniPMW29+4T6bo6fzs8HJncQgqR2dO2FVkaQaa5oe9y/khU+qv
 NaXtad/Rgqlfb8/hjaQfHS0In2ZswnAxSp8+9aW3ObAHhvYU3Ucpwi8BWoIfSCmz6YG0
 o7j+TdzaJTOOPrY9v8qCBW1uWxXeidkOm1BRr94qHJQ5TzH5TKaIsMy3JQ5phYqQyqmM
 OaFahTIh5gI0wNSJgaTA0wcnDGCTFSO9lfB3wWyECdZ6ba2yKye2H7Nxpls0BR9WsKz/
 Hu9cRwsC/iqXj+vn+EeCeY0gVUmr+1mLc8vryLlIN1N2GV5JeyRgmc2XCMjJikdrWgH3 ZA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0Pvcm+J+3I7j6BU9TtanyoN0Fmn8A133iSAWo+cf7Sk=;
 b=sJfM91boMvQMi9txAMTfMBt9SNbPn3T+dN94FAZhJE5flIy+5Z2BnSyEmDv/tYFhiMFP
 1ANr9q1WFdjmTqvM3eZsDsYVe44KjvMEo6GNkwYYBTQ5i5W9vfJHGdKB/p/CsheFHjsX
 oaQO6HKPtoSK46guDC0DQo2wmjATlMtFthCdXeRcghi0tbCNQIIZ1VqjTebesKKB90sl
 UX5FlWqHSERQ2WZbGKGoFLSA29JTYpfl6kbKuaaJcS554pP/lG1S1imYyxV0NJA8rxPD
 kEddzZf78DAbhp3X/+QCTFOK0J/U0EJqz022odK7L5m+eZ8dituZiB/wWMn7Hr4yZrf9 zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 39sbtuk7uw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16EJUnWR114139;
	Wed, 14 Jul 2021 19:36:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by aserp3020.oracle.com with ESMTP id 39q3cfyyyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 19:36:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOKi8G9Ab4nmg1UW2LLUajBBzOq5A5/Of79/EC0ssXyUKfVnocLfp6CrVouO69lC+HGRJC+RHapub0HVXgQqT6zI5bPG4ZFhDA0rXby1rtBkUxiLvuhTcn2ejPq0UFiLWjdW9rZxf0bUjP8ELTWe1RjlJlYYcdSuMfjOy3Wb+5eH0DTnw5flpqqos6KoHenY/MT4INh3o83BMcrnturFJBqn1/hqUtLMBWnOZYlDUi3ESjCPXql5XwaaOm5uDyUDcFTONAGLQMfNF5eAvp1jQd313oCURonsCL5CjEfNl8TZGSH1E/NjAa5Hh9bZIm/9NMw3Vj+QPNA8z7decp3NGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Pvcm+J+3I7j6BU9TtanyoN0Fmn8A133iSAWo+cf7Sk=;
 b=nY/g6XrSFTjH69NcEQuBqZltg8ocA1s457GU5+/qY86WNxrlmOYZQZvQOOA7SFin2FuK1AaD3/EeyUxoAv/mxnuq+jZOxkB930PTtlp92bX+GMoevoqTSXDYyYVpt6yH95pJGWiKZ/fQPQo8fPMs/NQUXnEZ1KW6yAk8EoqQ8ELvyjozGN5FXqAqW4p804r+z5odRNRKlJlvYcS+sTMGOZycj9E3ujXXHdTERlfYgkDVT5vMpXW68nCpvvSVTQXAj+yLFFeerdLlbZzEq6gtboICwlwoEXuOE3tLwrTm5g3IvRx63EegmhrswxYJxA3QaMWZVXzfkg+rcq0xS7oNpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Pvcm+J+3I7j6BU9TtanyoN0Fmn8A133iSAWo+cf7Sk=;
 b=jVc1CoPFGv07XfjexZ4XA2uwtnAdVZJnvFYbECB5O9iELgQkYbGgA+IY0318JMGORlJW+39nh7p2R0mzc5elZobS7Y9u6MwQPt+pXzlK/15xZ/g970FhgnZMo28uQeXbC+2YaTvngyZRfCcU+AbCWB/hiEoETpkfXQvPzRwZ1i8=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB3028.namprd10.prod.outlook.com (2603:10b6:208:77::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Wed, 14 Jul
 2021 19:36:18 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 19:36:18 +0000
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
Subject: [PATCH v3 08/14] mm/sparse-vmemmap: populate compound pagemaps
Date: Wed, 14 Jul 2021 20:35:36 +0100
Message-Id: <20210714193542.21857-9-joao.m.martins@oracle.com>
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
Received: from paddy.uk.oracle.com (94.61.1.144) by AM4PR0101CA0048.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 19:36:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa5be1c1-ed19-4c23-038d-08d946fea6df
X-MS-TrafficTypeDiagnostic: BL0PR10MB3028:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB3028F6EE859F19321213C0F7BB139@BL0PR10MB3028.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	tKk1EsqBiwuNozwXy3RxnQvKYQBJgiZv0kUNv5bRo4sLBzx38ASuXI3/DRLT8earoJ14CZ6gFt/oSihObsC/0ELFu/6V1eLDuxA1o598nNZez9vk8a3IMveSpnaITd7agFZY1PlUdBXZzTj97itKGOQ38Kr2B4ErCzkDEKE1GAXvNvWb5xbFM65H8fId/EGl8nlpC5jhSOWqLUNpIHC43qpciFrx6o8u8mM1Em3RwV6EvPkeBfmkpJ9OJ6M5xa8xVOsJcbIUFbVgNeQefbr9N6OXt/2aF/M03/oDc/2KEZuEmgdZW9GlXgvfSlisDTOet3uKhyQ4UgE7cyUcBk6T7kWyIRBN7hjQLt3DB6t6QnVFbBpWi+fEcRpNm3i787FXPTE+dy6wZJSKSRTvp20gKkP/9wNusuDqRfostCjecN/DtJWolT51EMvjWEwfvY2dUN3dJ422Ka1cajXfH1BqQB8PVkizrSpHANdqsg0KLOZO81JGhGZOMTjLQTIZGL0LT9ec2g/8WBBZkXp6oARdL032wxLTCZDhnSxhjUp5ckweinGZYpop3PxxdABJJO2fBcqb36wrKn9oiJWoN+diwt710vInGLFM8MjX0c5CoGu6Me/rSYbJOfOFXc0agQjOOqz+wBdn8SWNXTMtn4gErkOKeu219rA1ptnwc1r3LatnYoj5UeHyz7M86mJEqLx1WQt1Uc/3TwcL5+tzjs43DA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(136003)(366004)(316002)(86362001)(83380400001)(54906003)(4326008)(5660300002)(8676002)(8936002)(956004)(1076003)(6916009)(2906002)(2616005)(107886003)(36756003)(38100700002)(66556008)(7416002)(38350700002)(26005)(478600001)(103116003)(66946007)(6666004)(66476007)(186003)(6486002)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0EkzP1tGnfz18yHK7MklY4KFqIQU4DMRpwuMKcssWJHJtkCh+sZxzsGn5EmA?=
 =?us-ascii?Q?WjjV4Kv2ncEPs2GjO3e5EWc5/rI5lRQ1jBZGk0dDYXTPbxu81cQ3aC1QAYDU?=
 =?us-ascii?Q?6MfExtJ+chczZI21zCLXdr96dkzlGMOCGoSieobq395R6HDTRZA7CZzC7ZSM?=
 =?us-ascii?Q?BwIaKTNDaXxjEcNHqmbAIm4LppmJ/sIEtdrqInVzWBp6t62AtxTX2JJ8d1xE?=
 =?us-ascii?Q?hwu9laDUTqjYCr24pfOBWIEDfURixGEIZOMaAygBPKF4Yxc57OVHzmtnKdJ1?=
 =?us-ascii?Q?isYpfCcnQJmpFul8Pc0TnRGAM2BGsj2yl0qwqRa8BmsmfXzUJOgRcMbCs49H?=
 =?us-ascii?Q?eYmfuBGrYRk5BMivIWs7s+O9qNT4/XfZak55yxEYOKx5urREZsl7dLQ9JaXw?=
 =?us-ascii?Q?SBTu5U4OFkX20ItvkNXWtK/KTqVvnd+BYuDQAEjbNB7hTZeTzL6GhL9r2sw+?=
 =?us-ascii?Q?k4KSgdN1qEXCsvACYuq3Yo/bzSqJ4NqIGnmjvZ2R9IDQ0mb9tg830gzuV+oY?=
 =?us-ascii?Q?25/CXIqBwTIHIbRayolCRCxLpG5skWvE4OjovP07lVBu18CNQ4caNq7xS7d9?=
 =?us-ascii?Q?l7icg1bnKtjLi2tC0Q3jPV4w2IkISH6NecUJgUhfpzq0m96zGhN/iQ/Ml+B7?=
 =?us-ascii?Q?IV2uvZTD8j2Hes9VKKyxzxaWpjNbLzHH/l5ywPpQE3gIeESljG/mj1mWvtm7?=
 =?us-ascii?Q?Xpi66kisaRXXS78FV7i/CbGaXAz6e2BS5GDW16PDXOPzcExx1BRQWwQALpjv?=
 =?us-ascii?Q?U2zmsU9S2j7H+KRIyZaR3InuEiTfViJVPnm2kPHR5OnrtBewkNeduMEmf31j?=
 =?us-ascii?Q?APyRjygm4Owye0IQO1+W+GwvwAPbsdxve8hid9MErkglfaQLX5fuueOLeWHN?=
 =?us-ascii?Q?4D/dfPpkqE4jwvnV6Dkh+QKZBHArBB6IxlCqyu1KOhDXxS07SZ/NU+XqmDqm?=
 =?us-ascii?Q?N2lUO+OR2/NSy7l2SXqE/Z+3nENgKk/nhbsl9g7bElLsSqMhLnKHDIoF5htZ?=
 =?us-ascii?Q?StkmkHVtx3W8ez/atFPGF2Bloy+Cc6jzbvhsW467JhJ+vxxYKhDy0r3Io2A2?=
 =?us-ascii?Q?hrAGWdaS12fr/sJNxrYJGwekqgJkEFM4NQNq+MUTsxbojo3EsI8hFV5FUHuO?=
 =?us-ascii?Q?unx8ak/X5fccctxheaMxBwHWcbrp26C1XN8CNNaRGIdnuN5uqIa7ts6vdrNp?=
 =?us-ascii?Q?VxG8PPQ/bw5mbQAnSJqLSynC9gcJJxzF71owcnuzw2XifcXIPXxi8sqn+DsQ?=
 =?us-ascii?Q?T3OimfUG3JdbqijKPh3dXvlp/mH4seAM44qRzaSo/xA8REPPwvTIA8Mofupp?=
 =?us-ascii?Q?ukEOacElxHM0jf2l4sjb1/sR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5be1c1-ed19-4c23-038d-08d946fea6df
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 19:36:18.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3v3xu1XFaBoUEa0NGsRC0uLtfr3XyN6EEa9TYu453ItJHyIPr1XNd0y1KVnXt6F/ubimXuUo7mBCm188I79t/mUTx3PwcBBf8WnCtIh110g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3028
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140115
X-Proofpoint-GUID: ioyksikqfgUczpMncODgLRGMpnRNdL39
X-Proofpoint-ORIG-GUID: ioyksikqfgUczpMncODgLRGMpnRNdL39

A compound pagemap is a dev_pagemap with @align > PAGE_SIZE and it
means that pages are mapped at a given huge page alignment and utilize
uses compound pages as opposed to order-0 pages.

Take advantage of the fact that most tail pages look the same (except
the first two) to minimize struct page overhead. Allocate a separate
page for the vmemmap area which contains the head page and separate for
the next 64 pages. The rest of the subsections then reuse this tail
vmemmap page to initialize the rest of the tail pages.

Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
when initializing compound pagemap with big enough @align (e.g. 1G
PUD) it will cross various sections. To be able to reuse tail pages
across sections belonging to the same gigantic page, fetch the
@range being mapped (nr_ranges + 1).  If the section being mapped is
not offset 0 of the @align, then lookup the PFN of the struct page
address that precedes it and use that to populate the entire
section.

On compound pagemaps with 2M align, this mechanism lets 6 pages be
saved out of the 8 necessary PFNs necessary to set the subsection's
512 struct pages being mapped. On a 1G compound pagemap it saves
4094 pages.

Altmap isn't supported yet, given various restrictions in altmap pfn
allocator, thus fallback to the already in use vmemmap_populate().  It
is worth noting that altmap for devmap mappings was there to relieve the
pressure of inordinate amounts of memmap space to map terabytes of pmem.
With compound pages the motivation for altmaps for pmem gets reduced.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 Documentation/vm/vmemmap_dedup.rst |  27 +++++-
 include/linux/mm.h                 |   2 +-
 mm/memremap.c                      |   1 +
 mm/sparse-vmemmap.c                | 133 +++++++++++++++++++++++++++--
 4 files changed, 151 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index 215ae2ef3bce..42830a667c2a 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -2,9 +2,12 @@
 
 .. _vmemmap_dedup:
 
-==================================
-Free some vmemmap pages of HugeTLB
-==================================
+=================================================
+Free some vmemmap pages of HugeTLB and Device DAX
+=================================================
+
+HugeTLB
+=======
 
 The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
@@ -168,3 +171,21 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
 (last) level. So this type of HugeTLB page can be optimized only when its
 size of the struct page structs is greater than 2 pages.
 
+Device DAX
+==========
+
+The device-dax interface uses the same tail deduplication technique explained
+in the previous chapter, except when used with the vmemmap in the device (altmap).
+
+The differences with HugeTLB are relatively minor.
+
+The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
+PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
+
+There's no remapping of vmemmap given that device-dax memory is not part of
+System RAM ranges initialized at boot, hence the tail deduplication happens
+at a later stage when we populate the sections.
+
+It only use 3 page structs for storing all information as opposed
+to 4 on HugeTLB pages. This does not affect memory savings between both.
+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f244a9219ce4..5e3e153ddd3d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3090,7 +3090,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *block);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memremap.c b/mm/memremap.c
index ffcb924eb6a5..9198fdace903 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -345,6 +345,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 76f4158f6301..a8de6c472999 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -495,16 +495,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap)
+				       struct vmem_altmap *altmap,
+				       struct page *block)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
 		void *p;
 
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-		if (!p)
-			return NULL;
+		if (!block) {
+			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			if (!p)
+				return NULL;
+		} else {
+			/*
+			 * When a PTE/PMD entry is freed from the init_mm
+			 * there's a a free_pages() call to this page allocated
+			 * above. Thus this get_page() is paired with the
+			 * put_page_testzero() on the freeing path.
+			 * This can only called by certain ZONE_DEVICE path,
+			 * and through vmemmap_populate_compound_pages() when
+			 * slab is available.
+			 */
+			get_page(block);
+			p = page_to_virt(block);
+		}
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -571,7 +586,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static int __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse, struct page **page)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -591,10 +607,14 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return -ENOMEM;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return -ENOMEM;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
+
+	if (page)
+		*page = pte_page(*pte);
+	return 0;
 }
 
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
@@ -603,7 +623,97 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	unsigned long addr = start;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		if (vmemmap_populate_address(addr, node, altmap))
+		if (vmemmap_populate_address(addr, node, altmap, NULL, NULL))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int __meminit vmemmap_populate_range(unsigned long start,
+					    unsigned long end,
+					    int node, struct page *page)
+{
+	unsigned long addr = start;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		if (vmemmap_populate_address(addr, node, NULL, page, NULL))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
+						  struct page **page)
+{
+	return vmemmap_populate_address(addr, node, NULL, NULL, page);
+}
+
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
+{
+	unsigned long offset, size, addr;
+
+	/*
+	 * For compound pages bigger than section size (e.g. x86 1G compound
+	 * pages with 2M subsection size) fill the rest of sections as tail
+	 * pages.
+	 *
+	 * Note that memremap_pages() resets @nr_range value and will increment
+	 * it after each range successful onlining. Thus the value or @nr_range
+	 * at section memmap populate corresponds to the in-progress range
+	 * being onlined here.
+	 */
+	offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
+	if (!IS_ALIGNED(offset, pgmap_geometry(pgmap)) &&
+	    pgmap_geometry(pgmap) > SUBSECTION_SIZE) {
+		pte_t *ptep;
+
+		addr = start - PAGE_SIZE;
+
+		/*
+		 * Sections are populated sequently and in sucession meaning
+		 * this section being populated wouldn't start if the
+		 * preceding one wasn't successful. So there is a guarantee that
+		 * the previous struct pages are mapped when trying to lookup
+		 * the last tail page.
+		 */
+		ptep = pte_offset_kernel(pmd_off_k(addr), addr);
+		if (!ptep)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the page that was populated in the prior iteration
+		 * with just tail struct pages.
+		 */
+		return vmemmap_populate_range(start, end, node,
+					      pte_page(*ptep));
+	}
+
+	size = min(end - start, pgmap_pfn_geometry(pgmap) * sizeof(struct page));
+	for (addr = start; addr < end; addr += size) {
+		unsigned long next = addr, last = addr + size;
+		struct page *block;
+
+		/* Populate the head page vmemmap page */
+		if (vmemmap_populate_page(addr, node, NULL))
+			return -ENOMEM;
+
+		/* Populate the tail pages vmemmap page */
+		block = NULL;
+		next = addr + PAGE_SIZE;
+		if (vmemmap_populate_page(next, node, &block))
+			return -ENOMEM;
+
+		/*
+		 * Reuse the previous page for the rest of tail pages
+		 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+		 */
+		next += PAGE_SIZE;
+		if (vmemmap_populate_range(next, last, node, block))
 			return -ENOMEM;
 	}
 
@@ -616,12 +726,19 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	unsigned int geometry = pgmap_geometry(pgmap);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (geometry > PAGE_SIZE && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.17.1

