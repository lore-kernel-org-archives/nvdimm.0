Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938A63B3A
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 12:25:40 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227BtcK4006652;
	Mon, 7 Mar 2022 12:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PfV+ptT9CU8LgEDYYu4UlxE6bjm418W8DR94/bGF/C4=;
 b=v/0pjBFCUbuB6O14jHwzs8z3xRnklOieXuy9ZfNVIejDhB8vIauuUb9Lxe5vXBCsT431
 CWAHsZzhlTeqzoGEPanuPWSWbHSJSr2mG7tkGVNWF+eljkwf6Z8rZnsxTQqAQ4ZMvtFx
 yYkCu2C6x5BF2Y2OnkdwLKvMEBBIl8r9KWQPbR1luCyiad1M5bmPSLcSpoHe35VILGX3
 vZPwQy5OEjWvdCKLGNxZ2yNXBBEIujDSXSJsdABQBPkCJsJAlxkSmHUOYZGtsR8DMQlq
 epQFqE3aixw1mqTwf6Kr/AXbpAS5E5qrZTcnwDY2V98NU8h8gSyVxL8PXBOFpgrpNeP0 fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2bn3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227CCHbW029583;
	Mon, 7 Mar 2022 12:25:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by userp3030.oracle.com with ESMTP id 3ekvyter28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/t30j/WA4DzBGntRimtkAnBybWsbR1tyGNcErrwVATyGGW+T1E6cLbA0AXbhYIYEfzUuE+bc20HIhCBlm3dbzyftLAS2oewdGq7Wvomooyv7qkejmHKZWSPS89ILXGa2m5Np86UpYVuxZ4vUNFVmYtGUK56NaUWrOLahZB0N1jis48yIeLATgt15jnDC24vJE+SHvdgZJszd72yB/58TAuekVum1LHC/DZ7SUiRXt6u3a77lpzQr5S7lil8hX82gxZtwaYVrezyUYvjaaGd42aerXpHR/0v462SISQDHIyJ4mLhczg0Vc/FcC3lryw8Xvgt8KKCQH7Xim+d2jQ7cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfV+ptT9CU8LgEDYYu4UlxE6bjm418W8DR94/bGF/C4=;
 b=icc+BkrnV6tU85ZC05uNd2SXiQHLd54fULDM9+IPcfzQeYRqSyJCY84K+TXCzy90X6SpAawZ0Y9M//VPNXMlnlURFoukcrXgFoN3Qgtym03O35LX+QOGYisoL7Z1Cyt8GmNyyvfcB+3SA/iDo0Odxw+/Bt9cqqPAsacONkV7qaY9bJoMuSntfGWWqsG551A+VDQDTCExvpKma1G0FCh897jud7ZYmUt87oQ6zjJbZDEahQlfEwJGW4a5K6Ms4Sy8zoV/5kppjJxQ3ZRqCWEK4GRH3ayOHkXe/m7uuq3+f3e4BENeALRnMMGr+5hj5KUUJmJ+xx6+a+KpOLg/LlpFfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfV+ptT9CU8LgEDYYu4UlxE6bjm418W8DR94/bGF/C4=;
 b=gDQMEhX+SyZPZGF2CUs+h0/+SnVMUCNxnH9fZzJd4kP29b5tOv66UTcxtnr8mRc7AlmhvjlBj175k/HB2CHfhvPPR3DvvzHvGMtrlEBFDmhu7rYmp9y4lflWILUVa+oxYOgxBW+xYknCj0A3hRZkJq7PCqnGAnnxJE+slR4lTdA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3451.namprd10.prod.outlook.com (2603:10b6:5:61::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 12:25:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 12:25:17 +0000
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
Subject: [PATCH v8 4/5] mm/sparse-vmemmap: improve memory savings for compound devmaps
Date: Mon,  7 Mar 2022 12:24:56 +0000
Message-Id: <20220307122457.10066-5-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 12aad827-83ca-48db-e330-08da003589f9
X-MS-TrafficTypeDiagnostic: DM6PR10MB3451:EE_
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB3451E333EF7AB4A379976554BB089@DM6PR10MB3451.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	++Gqo33g3goHY589bm1f4m5lDxuUneekPYAd2jWoxi2+lTZrlzQ4x8PHEoPPy57XmI+tuO0Qc8Zzq7o0JLbZyiPa335sI/LwVlnvlEI5Q6JyjVBMmDrHP//XoJfNS0RBwG3rJzkcTuodf5EjgZ9XyhhAyuGAFJl7cY/L91E3S38soEnKfmenlDudpnKNQ+DmiVNh/XjCG5FYm6IRWW6DikttyJfXGOxfwHchiWJl50SwPVcUCs4UpzXxLUjGeaaadaFkoWXXlCQku/YU/cN9MILv4KDrFGM8QdsQqijUU0sgjnxZxnXQT89FLLf/Ggze6APdGlynH+0JrP98R1dOPGjEN0W5+A2/Jj3w3fS00WYcn6mFuqs2/cec8Nzp6pnGFmqZnbWfefhMEX9nu0evUwbixlzo/FaFaTqYyH+CNW1vDZX4frR1sbItZhwEQyjwIDGO+Sf8Rr85lnsgB259b+RBxe4sWc7htqzilU3EhW3HioZhXlGpP6r7/zI5vNu4+Sh3stCZ6fBvs7YxU463pz2pZCnCH762zLeUE5bIznehwuyuu48aL8q7IV6Bdqh/nfnFkEEAjnEW32/eyJkitdx/ySP16ezeQa0IcRL7dGQpeLRcjOonwEglzo6JbxctGb+1nUttfSLCK0JQz2SvfO6x6YNBQjXRA0yh9NTUhnek12JXv9286D11fVanmArR3sm8Ss4bRFSLY/NAv/a+KEgof3nKph3/udjd2tqJj0o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(26005)(508600001)(6666004)(1076003)(107886003)(2616005)(186003)(6512007)(52116002)(86362001)(6506007)(83380400001)(38100700002)(8936002)(103116003)(5660300002)(7416002)(66946007)(8676002)(66476007)(66556008)(4326008)(30864003)(38350700002)(36756003)(2906002)(54906003)(6916009)(316002)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?DLelZITmikSFMpWfS4e+LpGV+W8lWYET7X4FzPa3fzUAIsyqBJ8taqUxhmY0?=
 =?us-ascii?Q?l69l1iAQkwiGIZPmwdDg8mrn1S7NJrCIT4C4IMzqKOqBZ/YSx2QRmtOjdbf4?=
 =?us-ascii?Q?hs6nlGkUrke1xnhZxj4jOP66PHPg5GIWM4p6z3Tk26P/Hj8JsA8bIjaCQyZf?=
 =?us-ascii?Q?skwIEOLXzlho+06xOQKYcKYvgs4lQ/BJEE862y2qSJefYU3186FuD+EpkYH3?=
 =?us-ascii?Q?u807Q6PYjW2uNjnd21+2DN2jmiVz6i7LftfEiInWWvoZL8Gg+llYDo/6F561?=
 =?us-ascii?Q?2ljMhLlAHH5ay5RS+MdDi6K+bW9H6d+PyPjCSWyWDqd8Zpl1krvgrhYzPxzv?=
 =?us-ascii?Q?zpFHI5rnWxbTaKUTIt9U+AJDnB6FQd3PI0Tntprke+R10kHbD3019b3wNrVk?=
 =?us-ascii?Q?HTBmAynSAqy/mTxDQw0cKsFGsqjdTlGYphyAgR1JIPUAwBJ8xNFvnLKQfkzA?=
 =?us-ascii?Q?2L+elTtawLmc1H4WP7Hot3yB68qJRfnUqtYq/lcBxuoeBwP3Ex5+wESGT56q?=
 =?us-ascii?Q?zhWtn7EwKWbTWlmVmHQoItWIcDe8MCBUPEvcpg9CwI7pvgvIoiKVY/45tEvl?=
 =?us-ascii?Q?1wTMe+811IhQ/OCeKNTSylIsJXHmbcOSVUg0xRa3ULg4X4gERPVeUs2fWBep?=
 =?us-ascii?Q?eWG7Br8+DklyTZuMu55SZ5uI6XpZzF2NexJanIoBxMXbCIVgS0pBG7EHHhPg?=
 =?us-ascii?Q?aV4/ZDhVH5947kw4xjEepqoJxqd4bIxYkbubaQJrtAPPgJAw7JHWkIjfSY3Z?=
 =?us-ascii?Q?r5uWF8WSP6M9zd6xaS33ciDuskVHTELky0UrRmO/Ze5R5PrPZvI7CLkoKIWr?=
 =?us-ascii?Q?wwunLkwbAuV0Q3JUiCkjzAFPuTKhIlvlYGRtG0RamVim9Z/NlCe2Wk39l+K4?=
 =?us-ascii?Q?mquL7+7r1PN0dA2i3sK7qQFjUs5oTYPYCRg/BC/pCiNm1rrz90fSH67ryAEp?=
 =?us-ascii?Q?MFgc7arHkotZy0b7EVj2y5XVeIiYc78TjfZ+9VMSWWvX0sDVNEHSSYbdBTHF?=
 =?us-ascii?Q?fddwvmDH/8kt6oJqA/XbZ3AiXbOHIvcoQ/xatek7YKL6wkScesttv9wWdrHN?=
 =?us-ascii?Q?ZRxb4TgbZdR7//an0+BAhMKXTmkaf3HjZ8MkNYLZ+G60yqs8SL8Uk8o/2ym7?=
 =?us-ascii?Q?nVNQ3U+zJ37jvtx4Y9L56kJWI7vm9xHzj7Ay6bUyY/tiykdYvosbXPCVnu25?=
 =?us-ascii?Q?crQPpldftHrcoUbAH0AVXRWnDcxumGogzJFZCJ/baWYkZ5kJvwys2IjV7nQU?=
 =?us-ascii?Q?Jef5Lf9ON5jxB3b+2D17ECOmxP8QTipQJ4pfd6wJc27ewWKzCdodxWwpVLOE?=
 =?us-ascii?Q?nLCpD+YjxbvitwBsHIvaR+HF+BShyGW4u1grA747GutmcUK58dWoJiQP+ZyL?=
 =?us-ascii?Q?dTJ5NT7BtexqMcgjuTqizLnWf9Jnlkk0wCsPV7STQMsVcMdYVTC8jfpWN2zh?=
 =?us-ascii?Q?6c6v4WSLWR3JYTRKzPuHDd5XfWjQezA3SXWkZWxEDoeL+6PfB1ZMyqi5LuSt?=
 =?us-ascii?Q?0ujCIF15hdLlrQrCsPriq2UqKgXbvsccufpuU7HRyTu29Wkcw3yfD6sOwpat?=
 =?us-ascii?Q?OhL6bx/L+CjvXXvkedlVnjnFvj1H5OHOjclOJsbcnS/Oct2yd+EkQnyuU5Ce?=
 =?us-ascii?Q?GItsD2oJi/3rM8g2FEEIqnNsbNSLMh4M1/eLo21EFEEW2AOh09nt7l32OHtN?=
 =?us-ascii?Q?7gcvWw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12aad827-83ca-48db-e330-08da003589f9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 12:25:17.6967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58FhGayHNYued726hRIYGPdQ86MS6ropbi4wUSWCLYYj0W7DlvICLvzTxviA7ApQwJubiEyWpybOEnLOmnpVFvAnO3vI9klLoxW61gBe1xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3451
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070071
X-Proofpoint-ORIG-GUID: iI5c2Cj8UHVO-UNMTJooo-v3qt__kGUG
X-Proofpoint-GUID: iI5c2Cj8UHVO-UNMTJooo-v3qt__kGUG

A compound devmap is a dev_pagemap with @vmemmap_shift > 0 and it
means that pages are mapped at a given huge page alignment and utilize
uses compound pages as opposed to order-0 pages.

Take advantage of the fact that most tail pages look the same (except
the first two) to minimize struct page overhead. Allocate a separate
page for the vmemmap area which contains the head page and separate for
the next 64 pages. The rest of the subsections then reuse this tail
vmemmap page to initialize the rest of the tail pages.

Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
when initializing compound devmap with big enough @vmemmap_shift (e.g.
1G PUD) it may cross multiple sections. The vmemmap code needs to
consult @pgmap so that multiple sections that all map the same tail
data can refer back to the first copy of that data for a given
gigantic page.

On compound devmaps with 2M align, this mechanism lets 6 pages be
saved out of the 8 necessary PFNs necessary to set the subsection's
512 struct pages being mapped. On a 1G compound devmap it saves
4094 pages.

Altmap isn't supported yet, given various restrictions in altmap pfn
allocator, thus fallback to the already in use vmemmap_populate().  It
is worth noting that altmap for devmap mappings was there to relieve the
pressure of inordinate amounts of memmap space to map terabytes of pmem.
With compound pages the motivation for altmaps for pmem gets reduced.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 Documentation/vm/vmemmap_dedup.rst |  56 +++++++++++-
 include/linux/mm.h                 |   2 +-
 mm/memremap.c                      |   1 +
 mm/sparse-vmemmap.c                | 132 ++++++++++++++++++++++++++---
 4 files changed, 177 insertions(+), 14 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index 485ccf4f7b10..c9c495f62d12 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -1,8 +1,11 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-==================================
-Free some vmemmap pages of HugeTLB
-==================================
+=========================================
+A vmemmap diet for HugeTLB and Device DAX
+=========================================
+
+HugeTLB
+=======
 
 The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
@@ -171,3 +174,50 @@ tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
 more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
 associated with each HugeTLB page. The compound_head() can handle this
 correctly (more details refer to the comment above compound_head()).
+
+Device DAX
+==========
+
+The device-dax interface uses the same tail deduplication technique explained
+in the previous chapter, except when used with the vmemmap in
+the device (altmap).
+
+The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
+PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
+
+The differences with HugeTLB are relatively minor.
+
+It only use 3 page structs for storing all information as opposed
+to 4 on HugeTLB pages.
+
+There's no remapping of vmemmap given that device-dax memory is not part of
+System RAM ranges initialized at boot. Thus the tail page deduplication
+happens at a later stage when we populate the sections. HugeTLB reuses the
+the head vmemmap page representing, whereas device-dax reuses the tail
+vmemmap page. This results in only half of the savings compared to HugeTLB.
+
+Deduplicated tail pages are not mapped read-only.
+
+Here's how things look like on device-dax after the sections are populated::
+
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
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5f549cf6a4e8..ad7a845f15b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3118,7 +3118,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *reuse);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/memremap.c b/mm/memremap.c
index 2e9148a3421a..a6be2f5bf443 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -307,6 +307,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 1b30a82f285e..642e4c8467b6 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -533,16 +533,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap)
+				       struct vmem_altmap *altmap,
+				       struct page *reuse)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
 		void *p;
 
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-		if (!p)
-			return NULL;
+		if (!reuse) {
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
+			get_page(reuse);
+			p = page_to_virt(reuse);
+		}
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -629,7 +645,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -639,13 +655,14 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
+					    struct vmem_altmap *altmap,
+					    struct page *reuse)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+		pte = vmemmap_populate_address(addr, node, altmap, reuse);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -656,7 +673,95 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap);
+	return vmemmap_populate_range(start, end, node, altmap, NULL);
+}
+
+/*
+ * For compound pages bigger than section size (e.g. x86 1G compound
+ * pages with 2M subsection size) fill the rest of sections as tail
+ * pages.
+ *
+ * Note that memremap_pages() resets @nr_range value and will increment
+ * it after each range successful onlining. Thus the value or @nr_range
+ * at section memmap populate corresponds to the in-progress range
+ * being onlined here.
+ */
+static bool __meminit reuse_compound_section(unsigned long start_pfn,
+					     struct dev_pagemap *pgmap)
+{
+	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+	unsigned long offset = start_pfn -
+		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
+}
+
+static pte_t * __meminit compound_section_tail_page(unsigned long addr)
+{
+	pte_t *pte;
+
+	addr -= PAGE_SIZE;
+
+	/*
+	 * Assuming sections are populated sequentially, the previous section's
+	 * page data can be reused.
+	 */
+	pte = pte_offset_kernel(pmd_off_k(addr), addr);
+	if (!pte)
+		return NULL;
+
+	return pte;
+}
+
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
+{
+	unsigned long size, addr;
+	pte_t *pte;
+	int rc;
+
+	if (reuse_compound_section(start_pfn, pgmap)) {
+		pte = compound_section_tail_page(start);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the page that was populated in the prior iteration
+		 * with just tail struct pages.
+		 */
+		return vmemmap_populate_range(start, end, node, NULL,
+					      pte_page(*pte));
+	}
+
+	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	for (addr = start; addr < end; addr += size) {
+		unsigned long next = addr, last = addr + size;
+
+		/* Populate the head page vmemmap page */
+		pte = vmemmap_populate_address(addr, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/* Populate the tail pages vmemmap page */
+		next = addr + PAGE_SIZE;
+		pte = vmemmap_populate_address(next, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the previous page for the rest of tail pages
+		 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+		 */
+		next += PAGE_SIZE;
+		rc = vmemmap_populate_range(next, last, node, NULL,
+					    pte_page(*pte));
+		if (rc)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
@@ -665,12 +770,19 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (is_power_of_2(sizeof(struct page)) &&
+	    pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.17.2

