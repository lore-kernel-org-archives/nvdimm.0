Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E266AA3
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:49:05 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NIDxDp011743;
	Wed, 23 Feb 2022 19:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/BXFLbRSZu6RiVtnZuU4vmvBE1DH20dVRtATnKApp4E=;
 b=1K9ZJpoFDy3+M9vHjvCxf05N359VyLPZ53sjq32dO7XagFqV3kGDIqJNtRsQfqTRVK4d
 ZUWTYn9jVqDjJJOlkQClliaCMzX+UZ5xMAvJQzij7LcewQ5xJ9CTYcjwLUpLxYbpsRVR
 PFHM4E0P6kS1IejBZHUtfDB4CEpZ4KMH2x8TQt5vedGJF5YBaz6or8tDNbUeFFJd5LW2
 5JEYJPQshq0tqEh4Ulw+N42OLr7H/HOZ4dCq/MBXddC0pl7LrKLiggmSRAsv6qRSAbOJ
 cGL0M0D4EAjsUUP8xBd+Pu0IwnU0Zi3P46NbZ3p56raAV5rWGuvWndAoxXiyC+/pc+5w IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfavmyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21NJfcRa055196;
	Wed, 23 Feb 2022 19:48:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
	by userp3030.oracle.com with ESMTP id 3eannwbuvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk0m2vMw9W/sjJqCUderio6JGUI7pbKQ0TNPEmT2FVu+1plJPZKbefWRjfKpK7hgs6Vs1FSP/MGoVEhAwCktgSuRq+pkagX3HZmvTdA3KJITkKuy/SAzAimFryiu1jRZv6bztBddpvB/gZiyHRrc8wrU+a2UZSiHY4nqC3FHM5aSwVOdwUu0Qpg32oV0RZVarDbm4DIZYNomw7l9tVfPONJyUAs4ggC9h/NfLFNdWp/j1nkptFMNQJ6WspIQTzdkEZIUPskHkTjwftHzNBMSZlzMwspz033VjvBEyTikb2mua5TsQh19mN75qoOA71OaQRWVsH6542IdB/l3pQAoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BXFLbRSZu6RiVtnZuU4vmvBE1DH20dVRtATnKApp4E=;
 b=L4vyo7rGzZZaVG5as79nOyxzYEV8J8glHmcYxE65OS0bu4SjViASotvMe23+AcC60AmmHl6Kr2ufr45t/3az/iZ9FcOIl+PYIamMe7wXPLFyIWrWC5Pm20cUQpQjAi+Iy2WOmz4A9OnCuLTi4lvYipGJBrr8TN/JSQrcFQTGQBFcsxI/1TXEGovrNfydBPEFse2A7QdMsbBdkqnheIuV13N0agbmWJfh4OMVbRHhs6N+zWusvdwIhxE9LLLwmZihkJSKXobkoLmjICfmCCkqahj/+lEJy3XBpRTHvZUa0HYoCp0bGEDfYJtfFCe/pisSVOr4HVr2hOBfC4FbdB6gZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BXFLbRSZu6RiVtnZuU4vmvBE1DH20dVRtATnKApp4E=;
 b=HN58N43DcMcb2SLhQOW5we5b/PEp10U1Oj6K5VL6+HCwj8aclW61WtbxMBMcoMyvdYIwAUkurMtueps3tBb3+4p5OYFvW/JGB+Q4iCPZchj8Zk1FtCUEPL2DBmZgQ1KW6GWAlliKtEoAGMErURrVwU4b0DBPSEKK76zLZj6bEJs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4930.namprd10.prod.outlook.com (2603:10b6:208:323::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 19:48:42 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 19:48:42 +0000
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
Subject: [PATCH v6 4/5] mm/sparse-vmemmap: improve memory savings for compound devmaps
Date: Wed, 23 Feb 2022 19:48:06 +0000
Message-Id: <20220223194807.12070-5-joao.m.martins@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d317b2b6-5df2-413c-7c8a-08d9f7057e4d
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:EE_
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4930396BD45383C17681D303BB3C9@BLAPR10MB4930.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2+Y5zJMpKgWVy05a81iIk/xgdygRUIlu2ismx3ByhQtDDlaERnttGJWJ4jOnqhy7v/FIRqwcuMxO1tgSShGMK+/wQc/ChQ3qE594T52IbU8X71cBBVDJ+94Tn5ib3Je1XBfPN9L/GAvQd20BZxuwaHd5IPGw0mxMvpyN0HIWIR5NEToRiTf4OdSzGPbRsb5MrPW2YqWSRN0pOu6ZKJQbVxXlYPeU1bF7pCjXiedeVQQlRoVmX8hiznJ+kW9GqMZ/s0i5OBRYGQDLnm4AAeO670K/ubshfGCWiiPx0mQUqBDua3zw74t2tkDRwxqQsXyl2rnzjUZ/wNksyimpjcB0zuoJAgxwWDTtZi4O49ay8UuYmZz4lSRpQWlGG/Of942ktl6puXYdrPrkF5lV88MykdWwTzj19iLO3Lm/1QMep1jKBncdL9SO1BJkTlZFaLiI8zfzLq8fY/NgiJX2pGuc9ZIqgojETv01Z4vLVcP2Nu+KOjglEaz7kiDPkLSI90n9WtVf2BgXJLGLQBdW20O8a4ny6XdqD/HLp2/ca7pwLmldvxEBK8sR+B0XbrZly55HUjqadbt5iHhSfzu4Ty9313c3pwGX3OpoRmKBhlCq41foJFMiQrhNAUMq7po6Box7HvyMk+7CrPShQy27exoO7uw2EzmmV+BhYS27p9AwpjYT1kGDyzBPpN6pTU/P2o/y5DgURpS2CdoNhmxTVIDXfZ9o/AZ7oXojA8kH5oIrzQ0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(103116003)(6916009)(36756003)(86362001)(6486002)(316002)(508600001)(54906003)(8676002)(2616005)(52116002)(107886003)(66946007)(66556008)(26005)(186003)(66476007)(1076003)(4326008)(8936002)(38100700002)(38350700002)(2906002)(5660300002)(30864003)(6506007)(6512007)(6666004)(7416002)(25903002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Fh3JBBKK7eQgpnVOJoEcHaVuGMH5R7hFQppQI7J6FtrtNfwgC1juMuDscw78?=
 =?us-ascii?Q?JK39MFQmr5uDBOW7y0oxgMjVuHs5b9bYmajTcYERdU2uryxriU0bCRewxCcg?=
 =?us-ascii?Q?d+iFDnkewK77sQ0/1CypK8rOmTRtedSTmiAZwk6GXZaQlmQnW8xM/K4xEpoW?=
 =?us-ascii?Q?5Zk+FZg1q+DwZLnUtdd9H0oumTHISwSAYKUU//IhwLwoXE0x7ZxxYbJoXOvd?=
 =?us-ascii?Q?0getQ37kIV2eftHM6F4X6Po9EgLAoUUlQYSGq5wJAzqu7Ek/Gd6KFJhIx1hK?=
 =?us-ascii?Q?Nvi93exAiZWbr+ibCQcNNqsG94QDOEq0HLcwFwVXiCgIkLjnNE6ov8CfPmGk?=
 =?us-ascii?Q?9aWbnkqq+MkP7OzejHh5G/CXVH9f5h022N0mcLuclSE4o/H2WL1+YIalHOhF?=
 =?us-ascii?Q?UM2CLkMkSp2Yikgnh/CpKPvnl/+EFfPZmMFo75URPcSJpHxCZKfbJ+ToslWv?=
 =?us-ascii?Q?lqtv7ky2vfHAEXAQpUMwvzycwYFK7/+K80zDPSOsRypSdu9/dBqKKYAK56ux?=
 =?us-ascii?Q?czMH2/Oew/l1NS0Y+kE3YbnJRdHFnpVA9wTRbYcgykAqXgbQzxdPdjzwOCQg?=
 =?us-ascii?Q?OZKjVlpREJ15jmKQnnSNtQxF4+DMXQrYkIXAh0JycbknWroIKjYp/fj++dv5?=
 =?us-ascii?Q?wwArzJG9C7f7G8Oz+HmFuw0/Rxs0JvykBGTFn/cq03Um30RENs3e+hvPAwoX?=
 =?us-ascii?Q?Zbykcw7Sl45XCZbJRX0oJqqASBWHB9CxoQ3/4huBikugXbZuFZ6nOQz+yykB?=
 =?us-ascii?Q?GgZ0O5cj8ijhE9XrOJJRFFi/0oNpkV2yKYGPJyfSF529DTWrXGCTKDkLR3bN?=
 =?us-ascii?Q?ww0n5UOctpo+nlWDq3b8KdjIdQQDaq/JqL7Ap5tO9nEaZwnKBejGKWkU68yP?=
 =?us-ascii?Q?qA4IG309ffRsjT9D5zeADSIg74JaKDfp+7QgPvfBz7+qxs6gvtqT5JedQNKp?=
 =?us-ascii?Q?4ix7cbOBw6jCTiCP8LWYmm0zDNXqiY8Tbju/PsXiQvxBDBtTSxRq0pEcowTG?=
 =?us-ascii?Q?oX6JXaUEtvVpHvaKGDDrPP9o5e+Y4zX9MRZ0c1P0hywyzSNpYJdd9Hq2Ktyz?=
 =?us-ascii?Q?hZeiLHX5VBI7Swrg3/MGbPDsl3wqHvZk5jjBtrQV8SZOUKcveN8gHkc51PEv?=
 =?us-ascii?Q?Rt6iHxr7YNuqrhzhKeDsan0roUMfwuTh961Lc2Ns3vMzs8AWccrVoFFkdvrh?=
 =?us-ascii?Q?F4mG7JOj8fS7OD8Ig2uknya3GAvaw1r2OP1U3R9xAsBWzWd/NREe5eu+9GeN?=
 =?us-ascii?Q?RFqb9TRaZVrNMJcgvzSEzXyaDoSIgiz1UYqwr1A6tPvoTLJCdUW7PzqfiirN?=
 =?us-ascii?Q?YV9egns9ZZD4HwbC/Ffh3KBHsgjxfNgWSlaWsvTraP3ScA4EDqXPbZull8Hf?=
 =?us-ascii?Q?KVSI2QjbdPX7eoj+/KqcPlNgjcrkQN2eZsLq4iGEt3MfhqVGykpibGbj0ofD?=
 =?us-ascii?Q?3TnNvvaj+n2eZ/84gKEX7a+CZuV3BrNlFzpZGmHU5KD+DuCbxmzLHrhzFQ3H?=
 =?us-ascii?Q?dPu1JbdJzUwYv4QHOjMp+lOP+SlKmKGN2Ty/DbFw0WSaxC+ZRXjYYJPEOBvZ?=
 =?us-ascii?Q?8zZs91SQi6gUND4p2Ok3u9FmZXhT/OxCubJomfO/ZhLqhsf2D1c7AJmmmbow?=
 =?us-ascii?Q?tGLGh02F31pW96MGk13RyfYePK2fEOCPJHdHUF5w4jShQZJLaP1CRdcdOKIG?=
 =?us-ascii?Q?n3GDuA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d317b2b6-5df2-413c-7c8a-08d9f7057e4d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 19:48:42.0227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qVa4JAfzdgFC6teLklSglFAn/dU1Knejh6AEFbY76jjpl+17IrFaJvxkBDhdOaJBDGUEUY+4XWlGeNcBS/1Uk3xDbTtXnQ7P2gkVBJZOI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230111
X-Proofpoint-GUID: wqKIJU2aoAsu17ntauuGf5g00EyFctjG
X-Proofpoint-ORIG-GUID: wqKIJU2aoAsu17ntauuGf5g00EyFctjG

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
---
 Documentation/vm/vmemmap_dedup.rst |  56 +++++++++++-
 include/linux/mm.h                 |   2 +-
 mm/memremap.c                      |   1 +
 mm/sparse-vmemmap.c                | 141 +++++++++++++++++++++++++++--
 4 files changed, 188 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
index 8143b2ce414d..de958bbbf78c 100644
--- a/Documentation/vm/vmemmap_dedup.rst
+++ b/Documentation/vm/vmemmap_dedup.rst
@@ -2,9 +2,12 @@
 
 .. _vmemmap_dedup:
 
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
@@ -173,3 +176,50 @@ tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
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
+Here's how things look like on device-dax after the sections are populated:
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
index 5f549cf6a4e8..b0798b9c6a6a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3118,7 +3118,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *block);
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
index 44cb77523003..195c017c8d23 100644
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
@@ -644,7 +660,23 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+		pte = vmemmap_populate_address(addr, node, altmap, NULL);
+		if (!pte)
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
+	pte_t *pte;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		pte = vmemmap_populate_address(addr, node, NULL, page);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -652,18 +684,111 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
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
+		return vmemmap_populate_range(start, end, node, pte_page(*pte));
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
+		rc = vmemmap_populate_range(next, last, node, pte_page(*pte));
+		if (rc)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
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

