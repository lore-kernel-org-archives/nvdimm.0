Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8DC6AB1
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:49:03 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NIDnYS020614;
	Wed, 23 Feb 2022 19:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=gh20di5eJhMGZ7j6H84oQaJlyKH4saxoTy6ZZUjSVw4=;
 b=ZIZsYqUtl++r9NCgW3f5kWdT028mQaxFjSmL4Ipm85dW7V9r8JktaqjcpzykT7DxacME
 6VAL5M4UvXkt56vddcF79kVKDtUxmqR+n9jMXpdVFIt9sOWtdfwwPdb3fRInZLl6ux6R
 fPoOmFFsbowhexuEt0M8lt5Mni8Yzff2WmTmkiyCJ+xTpKvAh29w+8OlgmwnsKCy3cZG
 lVcl8Wm7QBlKqpecb9IQpw1F6ryxeEcCyIT563oTG6VRyuKzHUEB3A54Z06elQHWHxWL
 NZTrCEmIBFh4PFiToOGYzjhvKOgYWAkqJr0LyWLH47+yHjQcktZzDK4VFFRpHOZhUcyA Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecvar4ys6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21NJeWJ0047035;
	Wed, 23 Feb 2022 19:48:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
	by aserp3020.oracle.com with ESMTP id 3eb482vxks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 19:48:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ya6NTnra4DoqgZvF3b6MemIf5xzFqo6dhX09bs4qpt8xQBB9+wkbh8bmaXzFK5t1OUCzx472qbts8+FFdzftvmXVQR45Zpd/Uby6TEvhAa2gXX9bJcdAV2NA3SjgksmKGwBlhuDysxWXCkpAcn2jE5kMFE2JqKojQSSF2ZEOQgebk4TmFQZbbiogTNBDk+DCCJ0NWe5TQUuIWyqVjGyY83ln4KGd5O72ZlYZW9gzxUkNTe5Xavd6ejzCUYHKugY4494XgzMwcBfJeQhYh1yqFHcNIoSSU0tT/WTjusT4lDE9Fb1yb5Ho1jadpWVj7jHNIl1AoHaO6xbQId9oo+/9Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gh20di5eJhMGZ7j6H84oQaJlyKH4saxoTy6ZZUjSVw4=;
 b=Rz3MK8Vy6t3S+DN/zPoh0cEHqK4BBcOIjk/4N/i80sBCTs5WXlMT/dYdqAf65hpXEazq9F8Bvc9Pm4fPxXVUr0RGLqq9C9MTIjMEmECbRhORKR6odeTmIEnUvMqEmfZwW9h6tMOLKx/WEwcTHRmXgfjgHMDVcFV+CdE6qn8m76FMnKpEv7HAmmF7JWOzQc/J7WAcMLJaSSMK7GZv3ZKwmpijUA+yMa2wRqAcPr9Cv+YzEDmdDAHdkXMxFCT2BojN3h/+JFmxilJiZvkO1rA8l0N04sDtBc5Dod5gCsHF1Ic+FZdT35c3gR9Q9HUrfHeLUK5PQXxGDj7KZwmK6bYKWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gh20di5eJhMGZ7j6H84oQaJlyKH4saxoTy6ZZUjSVw4=;
 b=ISgTPxJjwVHzacuWZuDVHDn4gSg43IpN1JZUvOVkeEhWgxHe4ILiV2Zyuwrad94mkKzdmeKxzyNgrQwA0J4FIGBYgVqYidW7MRm8c80g8+3qcdYyL+bVAXp0vPbCLhdhHeNZzjwCIZsfCpM2JbYcVgAGl35CkYXX4OeeQg3eqeU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4930.namprd10.prod.outlook.com (2603:10b6:208:323::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 19:48:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 19:48:31 +0000
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
Subject: [PATCH v6 0/5] sparse-vmemmap: memory savings for compound devmaps (device-dax)
Date: Wed, 23 Feb 2022 19:48:02 +0000
Message-Id: <20220223194807.12070-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
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
X-MS-Office365-Filtering-Correlation-Id: 34d2fa47-8782-4404-3a74-08d9f705783f
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:EE_
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB49304BD2F6FCEA23740FAAF1BB3C9@BLAPR10MB4930.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EuE+bHJVey4mgaF1k4BQiYxzDqAU7gucGir0Wnvo+DqiJXxmIV8FBFD1ym2bMRo3ZMtTBgHLL30asYh9DXFNGXbqxoaGD9D92Ok2ufAHHTzxnXBdWYizbh9m/M7nbJCoPgjB4tsAI5OCqZmqWYW9gPP02dW4VdPy0awN9gtQ63r+KBwduSsIY1KdLp2vj1Tp7YlO4usZHaDiKH8f7COz2GGY26ht2cT3/ai+X39QkBnrexcZ99+VRKdjqYbHbwuGp8Dk3aq2V3ResPqRRAqHBjJPuJXuQYj9eu41wzBhHWki7YbbFlu5eLcjhYiFzv4G1E4lUFD3IytnPgWgSROy6cnFEZ2oM/2m+5WVD+qZ3XlEtHaWONctgg/WHdXSLJsaFwitVGGVMik+R/37K/wiD7eLGaUQobLp17qbbefzsYpLC/i3m4puySK/W09mvRBdcXGtA99Q6I7WO6lWmvIW4fUljFCDzNMJb43zKUDPZg+xFQ/ZFSm3PyixIYBTdZjDae9CqhOx+jrMhr8F4wnVcgOGuGtaU/AS40Uw6qnR+31e/V9sh7M5JrmEVhs2Hp0V9Qm6x67SMl69sWWyBUGy+6tZrn7M2QiE6Yz7N5ewwHIevy45f7uHV3gno6uOWxSoHtvjYqKJUu215GeA+XvYExYXYtEkD4ehodpa6DPSC6PgbNdEbuM0uC5MnDFQePK3HCGFXgvOfQWsgMyJB4lpIz6w6ztPQKMZ81oLrP0UFwz3G/zuUqISzxHrfmFSbLYHC6DSLUA0LuUhzHcH/3LPLNS4ELt6YEii65dP3rThZtpBr71GzmRnzwGbBhuQy3udQPG3iegF4GKohTGWF+UmnQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(103116003)(6916009)(36756003)(966005)(86362001)(6486002)(316002)(508600001)(54906003)(8676002)(2616005)(52116002)(107886003)(66946007)(66556008)(26005)(186003)(66476007)(1076003)(4326008)(8936002)(38100700002)(38350700002)(2906002)(5660300002)(30864003)(6506007)(6512007)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?jjnnfG387cHMHwVjxp5ePIVbc2zlyWWQJHRH3X8f7KzSrujuY7rbVD5Mo4iP?=
 =?us-ascii?Q?DnSti3sR+zEGM0ZUDs/xCf9+qig3xN1vwP6+zrEMrDbyya85MXGlkLbhh81l?=
 =?us-ascii?Q?zn8b5X5xHi+0jqHTU+j6d6L4yYpLWK2+I8JVERRWsrdEbal4TU0mjnz5fb5D?=
 =?us-ascii?Q?49zZzvDS73cs9Yt8aJPjpLy0/pCLcQ0X4E7+HhBKPS9XPHsajTz+O30bCuto?=
 =?us-ascii?Q?4+Riyd+nAxWY8Xoz0bpgvmJs4kJRA+q8CQejVkaEoHmodpfQq+Tq7ffSV7yR?=
 =?us-ascii?Q?00NR5nVagJ2hMjNL79AuVseGxrMyhRPeT0Ra85l4UJMDYg20rbUlNxGnMul8?=
 =?us-ascii?Q?DRL0ccFJkHjnqSUqNROn9aXnf151/UVQVglUN2dx2Qi/A11jGwTQEn/qeYy0?=
 =?us-ascii?Q?U+XqiBimE9TL1ExsS7ZgtxsdcWQdkxqJO2gVjsteYJDlwchbdYM1uJizjY+I?=
 =?us-ascii?Q?EskNCcBl4Z/sWGk8xywXrvzDJ3A1SNyiPz/dPkAV1eaeaiXmnyJDQX5g85OG?=
 =?us-ascii?Q?/13sjt4/k2kmr16wgtg8p7KteF3LWEtSMipBXH5kPm9Hi3+MqjwCZv0GQhKA?=
 =?us-ascii?Q?wSfgiPmsLemlDxt19R3snAY8KPZH9wYdRDXtR7dHaTf/qjy/BZS6SMXorYWq?=
 =?us-ascii?Q?Ny+yds1Zhguis4iHGHgoQjjLWy6G5WSlup3dRphNJhElRnHiivZDv3UH2y4C?=
 =?us-ascii?Q?33jZQpHFZyUhsFnEEQlMDnPbpSeAa1h8jZjaOGouJjnBXtMYFEsdfepODCRa?=
 =?us-ascii?Q?JPwrrgtPRDu80cUKtNXDL5UZE0IzeCSsmodYQBKk4rZ0lCxbRYKywjaUUiSl?=
 =?us-ascii?Q?bb5iFfBjbPGCxPewLvyd1qg4p/9dZUH6on8FBRQFah7UiW6GwLyGMgNkEOL8?=
 =?us-ascii?Q?LruIuHUhzabsDHhWR6tjJzgWDhAmbM+4OYD+TAG4X3fnmR5oBVIXULJZ0KVq?=
 =?us-ascii?Q?8aI7FptxUqlawV0KQLLN5Hr2HwusN3RD+EsFhoq7yZNyAWcpCGC/sC4WdiKB?=
 =?us-ascii?Q?D8Cuxg9k5pae+6sxB9H25y9wiAL0CqviaUc9M9Uv5zCEXCxDrLJzAws4invg?=
 =?us-ascii?Q?08kQ240mWk1nMRYHcvDXs115GSzUOlq9dtdMS4kFwLCJW3PcMYvBV/x5dfdg?=
 =?us-ascii?Q?DAl8By2ap2YgKvKK5fcjkAJRSqPN8TFcqci3YKK8tG+WyW3WCiyA7K7yl+1E?=
 =?us-ascii?Q?zYDApe2Kqnhor7n2noupOjc8WTYAQJHIyUsMcCG3BCbCjP20n/zsSWlwj1pE?=
 =?us-ascii?Q?0JH42Sag9GChewQOj0v7UqJdP5vhnkTWxBOZsTZOyFYK/QO/qBpO2qakL9n+?=
 =?us-ascii?Q?vFaNPFCuhQU5yyuZXbg2UzVQUkqoQLkH9TMFJzatG8HbwdIC9GVCqBCrknVU?=
 =?us-ascii?Q?+DoFMX47cznJeA56CYTZBQAl9H2BBu+g5d/wT4c/YDY1yk3w3PcMc+o4fUaC?=
 =?us-ascii?Q?OHR40xmfQamPM1y0iUqven9/XcIt100PF79yQPYkWD8urzn2fgI4wU/d3ZpR?=
 =?us-ascii?Q?Hx8JIJPItbPRCCSERoZpc+P5KVwtmp21CIA+e7Gz90x9vXzCebv7jRU68lMN?=
 =?us-ascii?Q?NSjACtuLf1lTQ5P0mbv0azn+VY08+arOGOiIko3TLYprDUK8XQscxl5lgpbl?=
 =?us-ascii?Q?r7iP+Y/6QuWpHIgOf7MFmKtHEUO0VWvz2WgVDwUYTpzwN3AGmPC2i//D7Bpy?=
 =?us-ascii?Q?z9/uc+O3k7ji8Nz8c/FgpzpMzuY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d2fa47-8782-4404-3a74-08d9f705783f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 19:48:31.5675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GFGERI5GHCZY+v9WVTCoNzyGKdiZtVKi/RZ6hCFO0iARyOCyRvfFSfvgzlMWgojTdTiRaNz7hK4q6NH6sGHFdCTLZUPXUCzB/kN1vEVCHdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230111
X-Proofpoint-GUID: JlBu2f3Y8qQ0ETnuj5m1n-ByQ-U94JEk
X-Proofpoint-ORIG-GUID: JlBu2f3Y8qQ0ETnuj5m1n-ByQ-U94JEk

Changes since v5[5]:
 Comments from Muchun Song,
 * Rebase to next-20220217.
 * Switch vmemmap_populate_address() to return a pte_t* rather
   than hardcoded errno value. (Muchun, Patch 2)
 * Switch vmemmap_populate_compound_pages() to only use pte_t* reflecting
   previous patch change. Simplifies things a bit and makes it for a
   slightly smaller diffstat. (Muchun, patch 4)
 * Delete extra argument for input/output in light of using pte_t* (Muchun, patch 4)
 * Rename reused page argument name from @block to @reuse (Muchun, patch 4)
 * Allow devmap vmemmap deduplication usage only for power_of_2
   struct page. (Muchun, Patch 4)
 * Change return value of compound_section_tail_page() to pte_t* to
   align the style/readability of the rest.
 * Delete vmemmap_populate_page() and use vmemmap_populate_address directly (patch 4)

Full changelog at the bottom of cover letter.

---

This series, minimizes 'struct page' overhead by pursuing a similar approach as
Muchun Song series "Free some vmemmap pages of hugetlb page" (now merged since
v5.14), but applied to devmap with @vmemmap_shift (device-dax). 

The vmemmap dedpulication original idea (already used in HugeTLB) is to
reuse/deduplicate tail page vmemmap areas, particular the area which only
describes tail pages. So a vmemmap page describes 64 struct pages, and the
first page for a given ZONE_DEVICE vmemmap would contain the head page and 63
tail pages. The second vmemmap page would contain only tail pages, and that's
what gets reused across the rest of the subsection/section. The bigger the page
size, the bigger the savings (2M hpage -> save 6 vmemmap pages;
1G hpage -> save 4094 vmemmap pages). 

This is done for PMEM /specifically only/ on device-dax configured
namespaces, not fsdax. In other words, a devmap with a @vmemmap_shift.

In terms of savings, per 1Tb of memory, the struct page cost would go down
with compound devmap:

* with 2M pages we lose 4G instead of 16G (0.39% instead of 1.5% of total memory)
* with 1G pages we lose 40MB instead of 16G (0.0014% instead of 1.5% of total memory)

The series is mostly summed up by patch 4, and to summarize what the series does:

Patches 1 - 3: Minor cleanups in preparation for patch 4.  Move the very nice
docs of hugetlb_vmemmap.c into a Documentation/vm/ entry.

Patch 4: Patch 4 is the one that takes care of the struct page savings (also
referred to here as tail-page/vmemmap deduplication). Much like Muchun series,
we reuse the second PTE tail page vmemmap areas across a given @vmemmap_shift
On important difference though, is that contrary to the hugetlbfs series,
there's no vmemmap for the area because we are late-populating it as opposed to
remapping a system-ram range. IOW no freeing of pages of already initialized
vmemmap like the case for hugetlbfs, which greatly simplifies the logic
(besides not being arch-specific). altmap case unchanged and still goes via
the vmemmap_populate(). Also adjust the newly added docs to the device-dax case.

[Note that, device-dax is still a little behind HugeTLB in terms of savings.
I have an additional simple patch that reuses the head vmemmap page too,
as a follow-up. That will double the savings and namespaces initialization.]

Patch 5: Initialize fewer struct pages depending on the page size with DRAM backed
struct pages -- because fewer pages are unique and most tail pages (with bigger
vmemmap_shift).

    NVDIMM namespace bootstrap improves from ~268-358 ms to ~80-110/<1ms on 128G NVDIMMs
    with 2M and 1G respectivally. And struct page needed capacity will be 3.8x / 1071x
    smaller for 2M and 1G respectivelly. Tested on x86 with 1Tb+ of pmem,

Patches apply on top of linux-next tag next-20220217 (commit 3c30cf91b5ec).

Comments and suggestions very much appreciated!

Older Changelog,

v4[4] -> v5[5]:
 * Rebased to next-20220210.
 * Adjust patch 3, given Muchun changes to the comment block, retained
 the Rb tags considering it is still just a move of text.
 * Rename @geometry to @vmemmap_shift in all patches/cover-letter.
 * Rename pgmap_geometry() calls to pgmap_vmemmap_nr().
 * HugeTLB in mmotm now remaps all but the first head vmemmap page
 hence adjust patch 4 to also document how device-dax is slightly different
 in the vmemmap pagetables setup (1 less deduplicate page per hugepage).
 * Remove the last patch that reuses PMD tail pages [6], to be a follow up
 after getting the core improvement first.
 * Rework cover-letter.

This used to be part of v4, but this was splitted between three subsets:
 1) compound page conversion of device-dax (in v5.17), 2) vmemmap deduplication
 for device-dax (this series) and 3) GUP improvements (to be respinned).

v3[0] -> v4:

 * Collect Dan's Reviewed-by on patches 8,9,11
 * Collect Muchun Reviewed-by on patch 1,2,11
 * Reorder patches to first introduce compound pages in ZONE_DEVICE with
 device-dax (for pmem) as first user (patches 1-8) followed by implementing
 the sparse-vmemmap changes for minimize struct page overhead for devmap (patches 9-14)
 * Eliminate remnant @align references to use @geometry (Dan)
 * Convert mentions of 'compound pagemap' to 'compound devmap' throughout
   the series to avoid confusions of this work conflicting/referring to
   anything Folio or pagemap related.
 * Delete pgmap_pfn_geometry() on patch 4
   and rework other patches to use pgmap_geometry() instead (Dan)
 * Convert @geometry to be a number of pages rather than page size in patch 4 (Dan)
 * Make pgmap_geometry() more readable (Christoph)
 * Fix kdoc of @altmap and improve kdoc for @pgmap in patch 9 (Dan)
 * Fix up missing return in vmemmap_populate_address() in patch 10
 * Change error handling style in all patches (Dan)
 * Change title of vmemmap_dedup.rst to be more representative of the purpose in patch 12 (Dan)
 * Move some of the section and subsection tail page reuse code into helpers
 reuse_compound_section() and compound_section_tail_page() for readability in patch 12 (Dan)
 * Commit description fixes for clearity in various patches (Dan)
 * Add pgmap_geometry_order() helper and
   drop unneeded geometry_size, order variables in patch 12
 * Drop unneeded byte based computation to be PFN in patch 12
 * Add a compound_nr_pages() helper and use it in memmap_init_zone_device to calculate
 the number of unique struct pages to initialize depending on @altmap existence in patch 13 (Dan)
 * Add compound_section_tail_huge_page() for the tail page PMD reuse in patch 14 (Dan)
 * Reword cover letter.

v2 -> v3[3]:
 * Rename compound_pagemaps.rst doc page (and its mentions) to vmemmap_dedup.rst (Mike, Muchun)
 * Rebased to next-20210714

v1[1] -> v2[2]:

 (New patches 7, 10, 11)
 * Remove occurences of 'we' in the commit descriptions (now for real) [Dan]
 * Massage commit descriptions of cleanup/refactor patches to reflect [Dan]
 that it's in preparation for bigger infra in sparse-vmemmap. (Patch 5) [Dan]
 * Greatly improve all commit messages in terms of grammar/wording and clearity. [Dan]
 * Simplify patch 9 as a result of having compound initialization differently [Dan]
 * Rename Subject of patch 6 [Dan]
 * Move hugetlb_vmemmap.c comment block to Documentation/vm Patch 7 [Dan]
 * Add some type-safety to @block and use 'struct page *' rather than
 void, Patch 8 [Dan]
 * Add some comments to less obvious parts on 1G compound page case, Patch 8 [Dan]
 * Remove vmemmap lookup function in place of
 pmd_off_k() + pte_offset_kernel() given some guarantees on section onlining
 serialization, Patch 8
 * Add a comment to get_page() mentioning where/how it is, Patch 8 freed [Dan]
 * Add docs about device-dax usage of tail dedup technique in newly added
 compound_pagemaps.rst doc entry.
 * Rebased to next-20210617 

 RFC[0] -> v1:
 (New patches 1-3, 5-8 but the diffstat isn't that different)
 * Fix/Massage commit messages to be more clear and remove the 'we' occurences (Dan, John, Matthew)
 * Use pfn_align to be clear it's nr of pages for @align value (John, Dan)
 * Add two helpers pgmap_align() and pgmap_pfn_align() as accessors of pgmap->align;
 * Avoid usage of vmemmap_populate_basepages() and introduce a first class
   loop that doesn't care about passing an altmap for memmap reuse. (Dan)
 * Completely rework the vmemmap_populate_compound() to avoid the sparse_add_section
   hack into passing block across sparse_add_section calls. It's a lot easier to
   follow and more explicit in what it does.
 * Replace the vmemmap refactoring with adding a @pgmap argument and moving
   parts of the vmemmap_populate_base_pages(). (Patch 5 and 6 are new as a result)
 * Improve memmap_init_zone_device() to initialize compound pages when
   struct pages are cache warm. That lead to a even further speed up further
   from RFC series from 190ms -> 80-120ms. Patches 2 and 3 are the new ones
   as a result (Dan)
 * Remove PGMAP_COMPOUND and use @align as the property to detect whether
   or not to reuse vmemmap areas (Dan)

[0] https://lore.kernel.org/linux-mm/20201208172901.17384-1-joao.m.martins@oracle.com/
[1] https://lore.kernel.org/linux-mm/20210325230938.30752-1-joao.m.martins@oracle.com/
[2] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/
[3] https://lore.kernel.org/linux-mm/20210714193542.21857-1-joao.m.martins@oracle.com/
[4] https://lore.kernel.org/linux-mm/20210827145819.16471-1-joao.m.martins@oracle.com/
[5] https://lore.kernel.org/linux-mm/20220210193345.23628-1-joao.m.martins@oracle.com/
[6] https://lore.kernel.org/linux-mm/20210827145819.16471-15-joao.m.martins@oracle.com/

Joao Martins (5):
  mm/sparse-vmemmap: add a pgmap argument to section activation
  mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to
    helper
  mm/hugetlb_vmemmap: move comment block to Documentation/vm
  mm/sparse-vmemmap: improve memory savings for compound devmaps
  mm/page_alloc: reuse tail struct pages for compound devmaps

 Documentation/vm/index.rst         |   1 +
 Documentation/vm/vmemmap_dedup.rst | 225 +++++++++++++++++++++++++++++
 include/linux/memory_hotplug.h     |   5 +-
 include/linux/mm.h                 |   5 +-
 mm/hugetlb_vmemmap.c               | 168 +--------------------
 mm/memory_hotplug.c                |   3 +-
 mm/memremap.c                      |   1 +
 mm/page_alloc.c                    |  16 +-
 mm/sparse-vmemmap.c                | 176 +++++++++++++++++++---
 mm/sparse.c                        |  26 ++--
 10 files changed, 425 insertions(+), 201 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

-- 
2.17.2

