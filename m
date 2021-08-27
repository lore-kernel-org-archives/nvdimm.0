Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523323FCD
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 14:59:22 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RDWM7C015220;
	Fri, 27 Aug 2021 14:58:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=zYv9x9u/DBU5OcQKULd9xMthYj1R4N/ezdL/izESqiA=;
 b=SV7vNMtzJ7tpuwdxkjTTOPDh36zf0zPHHp+Re+zcW95vRH8pnK+WyICijBkDrTAxSAFN
 O4oYXc5IYacm/yKeMjxwPQ1qGTyzOrdmEFyEFCD7PG4Ol+oZRhKuEtbsGqBJKqUVSSSK
 rRG/a0QrZUixl9cxEV10veqhQ2qUkqRIsXkOMEMR+S69mhFbFlvDkhIHBSQG5BAjLAgt
 0tzqeP5dd9F3gUcYSngCWzIQYX4TbiuDua8tyxbusgKmt4VJfy5CXALkrvTpAmVKdLTk
 LvaqkijVbEAjpS/GI6Wuonrbt9kvM/y0dCDmZX1mDek83SXYOkqN2V+4SR/fwIqXPGaB iQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=zYv9x9u/DBU5OcQKULd9xMthYj1R4N/ezdL/izESqiA=;
 b=doZLuIyEcUQE28Wk8gzekTgIDbSQ51FZDYGBxoZwAO+3oxVchiBdwbqs13ujbONYWTqR
 HIDDuzxrCLRTVjR9N0xIN0ub5665BlouC3S11AWPh1B9pKzzSjiGIdSm90REvKtKfEXH
 fK6ryRDzkm3jAUCf/zlTKMkovnTAp+OtPp96538McFdZKHVaqjzWVFOddtQBlPOXWly6
 lS3BXxi1HI/HwHi0695bZGcYjekOciaCfKgbujFZP/FpYEWQIUrzicQ2crleDPGZdqEh
 a9D3J0gz5DiBuWOLt4/npVdlM0tBnQV5liDw+PEXIJVzpwUjmfxaYeMoStylBSQyqfmg AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4ekuwq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17REpP7C187137;
	Fri, 27 Aug 2021 14:58:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by aserp3020.oracle.com with ESMTP id 3ajsabbq9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 14:58:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qmli7O7uQrKFEiv4eehYzLL9/YYGMekbX6JbWtBoU+T/79KiqqqKzaH27uRWFzBQDvqF4/jV9vyIgfiZ3XOnuZJp6m42etJGvoUEHtpFhVsuNm/jWiUDJslK+j38wUnsrFGBTXzCQkhlzkKzL27X7j8CFdqTeekO82aGITVWccHZ8tHU8b8GuR1Fum8PjBkH/U4AclHo03lX+/XHEYLO0e/WAczPHaRk/4Md60Lm1ef8q3WW1BWtFUyY3+JWnAKMGO243s3vOaG3KtcAbrHTpQWRSopVYHaBmrvUYdadP/xz9jlzBtd/M9sWMn1JjrAzpaaeH1tAmgvQtwfg5CjSng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYv9x9u/DBU5OcQKULd9xMthYj1R4N/ezdL/izESqiA=;
 b=h4XGtqt/zTFJMoGmY5iFxkAJOiGMxJlcArZZna0vrAF3RqXTGRhFXCFTvUJPQGMmR/RrMo0dDQUtF80cHDI1GFEj6drQwkU0OwvxQiuUOaKnMv3FFLtQKW4KpELMEvg6y+Q32XXxxZJ5iJXxpXHtj3srza7U3TwtdpNji3MrEQsPV3UcImsYxgc02oQzk6CNt2eF8DSc/R+Qg23nNIM5WEYNmT/8AhinwQAjhcgpxGkkEDDUQACBdqlfTdPHpUippVLxjYjbn08tTlu0MK+NIhnQgYvipNnkWmBlPXk+/p/aRRFHh7YT7phsOlggig5kj/f+9KyzwoPMV3Fr56oQfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYv9x9u/DBU5OcQKULd9xMthYj1R4N/ezdL/izESqiA=;
 b=t2QFToBTjEZ3fqwwtE3mFE1mKxBT5idoBqCV7PlQrqG8N9EVnL73mX7heNRvnkReJrUs2JKf3Ic+k7h/uBWTIpJardKv9n2Ydjw55oxwhJyegcHtfBCXez9IMghkzET7j12HW9KcGwktoKFFsIqA/vhrUmKBf2/DUpqIh/grNr4=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 14:58:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 14:58:38 +0000
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
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v4 00/14] mm, sparse-vmemmap: Introduce compound devmaps for device-dax
Date: Fri, 27 Aug 2021 15:58:05 +0100
Message-Id: <20210827145819.16471-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from paddy.uk.oracle.com (138.3.204.8) by LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 14:58:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd56b510-d070-447d-8e2b-08d9696b2696
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4881B586B0DAE2948BCC9A84BBC89@BLAPR10MB4881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+29/Cjc06bCB6defsMmuMJhB+t7rbk/Csa6jOP9dwZzNVqnxO7oTEyAc1yLr5emufRcK5lA9VpDHrnZj1QNw1rdkqKO4e7Tl7HxQeprC1OuDG0rNIhnCLhRtOrURwltkVkz0dZzlZtvrrrtkyoZ9vZ+E1a32VvQGPjnr6MTN4/BjRApPGTQjW8wB6KcoO0G8d/cBJBF/fGYA2R9cwoZyAH/N7m23L8LK+XztN/9MSOtRj9SlQu4LbRFu2DgRNBQ5tCahA0HOhN//QtabeCqWA7c3eXCE2iVzqDVW09Vq890G1PHDNVRLerWkomVIjW18sBhrmiQ1cg7/CYPnMWvnLbpL1HDWBuqo+PzwCzgytDdRpjTfsAVL4RqDY/ZPaHRoOTwM7gBD0XSS/aTX0KodjfWy+sGYMZMxdZGHIIhotGxrvLoL8EBo08N9jxPm6i/zF//QlJSlArhEKPM07bmWadAF7za143ti4IZtpQzEuG3FtZ+8/NPp0EUewgcS0+NN3pKroP980s1xR17H9my63cEK30Wo9m1FKQm/P0Gp/FYprL/Oa1KPtcfZTuRoSqQj+TPue83XE0vuXbUbw2x/u+Hej/XEFuZ3scjTMP9g3kuSIy9T6YHta8y1+YCGzhixPt7F5kHMT1/7n7LhjD8+YAHkl660eSg06AYZCX2z0ZBRva87HY1v7pJ1Z/PaGFHXKxXNlpC+lOTCAqGZt9W6xxS+148efGh9w+CG9sDxL3OiC2zG2TNK5HO/B9XzBCksRL0O4G3/WBiRWyCGxSdArZm17a+7TJgoycAYaCSohZ37foRFXswUTz5ySxfn/pqj
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(7696005)(2906002)(83380400001)(38350700002)(38100700002)(52116002)(966005)(6666004)(66946007)(8936002)(478600001)(7416002)(107886003)(86362001)(36756003)(6486002)(316002)(1076003)(8676002)(30864003)(103116003)(26005)(54906003)(956004)(4326008)(2616005)(5660300002)(66476007)(66556008)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?qORNlAd+tW3dA1VpqgHSGSWzvIZVys3ghAlaZZp5rjP0a/cllb6vkz+FiGRr?=
 =?us-ascii?Q?r7dKBJBGs+8XzwptxpS4iC4RPdInyMMZCcUk+vDWvwYKF84cWONETioB3a2O?=
 =?us-ascii?Q?ji8uO2eVd4xdzxwoiWtu+Bj85FdlaZ0mLfblUXC18zOWUZyYu1lIJDiqdGD9?=
 =?us-ascii?Q?iY5Ns1P/LOFL6TAwbvrdjBhgz64M5XAZ632PZav4EnwlmW0s4W7Yv7vZ6pEj?=
 =?us-ascii?Q?mEPHOXlrZDxAmbc8ecPLGL492a4vMQPT0WcsHbsFAbEVAYOFsGz7iQ7gYwJW?=
 =?us-ascii?Q?brd2eG25knr6lDl7XeYwwWl16AFwIE27zmM43xWblG3MHXTYvZdueUVNlh1s?=
 =?us-ascii?Q?HjYGRLC69DF4PiGU1PXyiqvO0Hed1IatwnMUtdplmpfL7RtayqLhY3cibKXa?=
 =?us-ascii?Q?pm+yWDS2tpg2kVfi5+4hIMqmXJJ1mUYA6QVorQ0ryggP/HB+GurRrnWragJJ?=
 =?us-ascii?Q?uiYAfYjfnqmWYzPqMSPi9aEevDEcNgFn6RTZhsjQ012xSGQDqqZxBEOkgJ2o?=
 =?us-ascii?Q?8CtZFl104MsezBOdqJgTtnvKmod0FqjX/rHWCnLYCltE61FvEjRe9WA+KU0O?=
 =?us-ascii?Q?qs5tT2Xgt6nsHsrlxs7cWdDR04jFuND1+0qg8UyTBc5woDlhx+fN/KLZP7Gj?=
 =?us-ascii?Q?/pyDaSxkkBq/ADS5AG5E1qGXjkL3neFZC1kaqpCkSbFGvKA9AbsJiiNtGAYf?=
 =?us-ascii?Q?KveXVbEMUQ1DWnK2ghAV27TRJUNlX6ylkL9QO1s1ZBbjOkM5gdxuNhMsGBIs?=
 =?us-ascii?Q?jmgKWI4HsSC0jFfnFjyTaBNVTETKzjJE30XziANJpZYzmkC5hCTUE5d0iL2A?=
 =?us-ascii?Q?AD2izTtYHKtyo6w0e6AL1wxw8/dic/1IG1PUZOO1STMt4Q4xyGOJbh7GgJeE?=
 =?us-ascii?Q?L7mm2SxGPnMt+eHlYIb4T7MUYE4MzOEcpcYG/9At1HK1dy3sVZd/oEcRizrm?=
 =?us-ascii?Q?5cjKMx9Y1uv3uUOwNig7L1o9WklAJHnQgKEjD2QbgSmoaCyKNBunFiClZaKx?=
 =?us-ascii?Q?z155UoZnAP0DU8+Ez5tDbisXSGLhk06TXo8YBJQf7RqSojyn0DImW2ne6l31?=
 =?us-ascii?Q?P6QTG65xJOntPy4Q2BhHi60y0xqwjo4d/gWrKvMT4S4ESmbMzTHAcPsu8Qq/?=
 =?us-ascii?Q?jGYVePiXdoF7aKrI5/Muy2w53t17YQj4LmqEIx9yoM5xeaYQqkQWtP1hoPFJ?=
 =?us-ascii?Q?1M/W5z8Td6o+Hv+14Hu9vKvahptKvgZ+RGWsAi3SGrIg+Cpy+I/6RBRIw3KQ?=
 =?us-ascii?Q?RPjZxQmehlpy74nE/sz7bsjZawnKtij3kZEYZDgO/nLTQQp5E5q4cwyfSSab?=
 =?us-ascii?Q?SoAUQ0EHX/KDXjkgWXGNNtDi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd56b510-d070-447d-8e2b-08d9696b2696
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:58:38.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I90IEHXMDHvAqrB7dg2RnGdYAN/bBkHvLD+567oC1AxDzpKeoVxkNfSCS5ArXXmFAPdIP7kjss3S0hTOQ68HYBqafT/G0pQowcOIGFlC/A8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270092
X-Proofpoint-GUID: o5L3r0lQoH0t2tAPvXXv2OO0oSxi8ujy
X-Proofpoint-ORIG-GUID: o5L3r0lQoH0t2tAPvXXv2OO0oSxi8ujy

Changes since v3[0]:

 * Collect Dan's Reviewed-by on patches 1-5,8,9,11
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
 * Simplify pgmap refcount pfn computation in memremap_pages() (Christoph)
 * Rework memmap_init_compound() in patch 4 to use the same style as
 memmap_init_zone_device i.e. iterating over PFNs, rather than struct pages (Dan)
 * Add comment on devmap prep_compound_head callsite explaining why it needs
 to be used after first+second tail pages have been initialized (Dan, Jane)
 * Initialize tail page refcount to zero in patch 4
 * Make sure pfn_next() iterate over compound pages (rather than base page) in
 patch 4 to tackle the zone_device elevated page refcount.
 [ Note these last two bullet points above are unneeded once this patch is merged:
   https://lore.kernel.org/linux-mm/20210825034828.12927-3-alex.sierra@amd.com/ ]
 * Remove usage of ternary operator when computing @end in gup_device_huge() in patch 8 (Dan)
 * Remove pinned_head variable in patch 8
 * Remove put_dev_pagemap() need for compound case as that is now fixed for the general case
 in patch 8
 * Switch to PageHead() instead of PageCompound() as we only work with either base pages
 or head pages in patch 8 (Matthew)
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
 * Handle the dynamic dax region properly when ensuring a stable dev_dax->pgmap in patch 6.
 * Add a compound_nr_pages() helper and use it in memmap_init_zone_device to calculate
 the number of unique struct pages to initialize depending on @altmap existence in patch 13 (Dan)
 * Add compound_section_tail_huge_page() for the tail page PMD reuse in patch 14 (Dan)
 * Reword cover letter.

[0] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/

Full changelog of previous versions at the bottom of cover letter.
---
This series, attempts at minimizing 'struct page' overhead by
pursuing a similar approach as Muchun Song series "Free some vmemmap
pages of hugetlb page"[0] (now merged for v5.14), but applied to devmap/ZONE_DEVICE.

[0] https://lore.kernel.org/linux-mm/20210308102807.59745-1-songmuchun@bytedance.com/

The link above describes it quite nicely, but the idea is to reuse/deduplicate tail
page vmemmap areas, particular the area which only describes tail pages.
So a vmemmap page describes 64 struct pages, and the first page for a given
ZONE_DEVICE vmemmap would contain the head page and 63 tail pages. The second
vmemmap page would contain only tail pages, and that's what gets reused across
the rest of the subsection/section. The bigger the page size, the bigger the
savings (2M hpage -> save 6 vmemmap pages; 1G hpage -> save 4094 vmemmap pages).

This series also takes one step further on 1GB pages and *also* deduplicate PMD pages
which only contain tail pages which allows to keep parity with current hugepage
based vmemmap. This further let us more than halve the overhead with 1GB pages
(40M -> 16M per Tb).

In terms of savings, per 1Tb of memory, the struct page cost would go down
with compound devmap:

* with 2M pages we lose 4G instead of 16G (0.39% instead of 1.5% of total memory)
* with 1G pages we lose 16MB instead of 16G (0.0014% instead of 1.5% of total memory)

Along the way I've extended it past 'struct page' overhead *trying* to address a
few performance issues we knew about for pmem, specifically on the
{pin,get}_user_pages_fast with device-dax vmas which are really
slow even of the fast variants. THP is great on -fast variants but all except
hugetlbfs perform rather poorly on non-fast gup. Although I deferred the
__get_user_pages() improvements (in a follow up small series I have stashed as its
ortogonal to device-dax; THP suffers from the same syndrome).

To summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-7: Prepare devmap infra to use compound pages (for device-dax).
Specifically, we split the current utility function of prep_compound_page()
into head and tail and use those two helpers where appropriate to take
advantage of caches being warm after __init_single_page(). Have
memmap_init_zone_device() initialize its metadata as compound pages, thus
introducing a new devmap property known as geometry which
outlines how the vmemmap is structured (defaults to base pages as done today).
Finally enable device-dax usage of devmap @geometry to a value
based on its own @align property. @geometry getter routine returns 1 by default (which
is today's case of base pages in devmap) and the usage of compound devmap is
optional. Starting with device-dax (*not* fsdax) we enable it by default
but fsdax and the rest of devmap users there's no change.

Patch 8: Optimize grabbing page refcount changes given that we
are working with compound pages i.e. we do 1 increment to the head
page for a given set of N subpages compared as opposed to N individual writes.
{get,pin}_user_pages_fast() for zone_device with compound devmap consequently
improves considerably with DRAM stored struct pages. It also *greatly*
improves pinning with altmap. Results with gup_test:

                                                   before     after
    (16G get_user_pages_fast 2M page size)         ~59 ms -> ~6.1 ms
    (16G pin_user_pages_fast 2M page size)         ~87 ms -> ~6.2 ms
    (16G get_user_pages_fast altmap 2M page size) ~494 ms -> ~9 ms
    (16G pin_user_pages_fast altmap 2M page size) ~494 ms -> ~10 ms

    altmap performance gets specially interesting when pinning a pmem dimm:

                                                   before     after
    (128G get_user_pages_fast 2M page size)         ~492 ms -> ~49 ms
    (128G pin_user_pages_fast 2M page size)         ~493 ms -> ~50 ms
    (128G get_user_pages_fast altmap 2M page size)  ~3.91 s -> ~70 ms
    (128G pin_user_pages_fast altmap 2M page size)  ~3.97 s -> ~74 ms

Patches 9-14: These patches take care of the struct page savings (also referred
to here as tail-page/vmemmap deduplication). Much like Muchun series, we reuse
PTE (and PMD) tail page vmemmap areas across a given geometry (which is seede by
 @align property of dax-core code) and enabling of memremap to
initialize the ZONE_DEVICE pages as compound pages of a given @align order. The
main difference though, is that contrary to the hugetlbfs series, there's no
vmemmap for the area, because we are populating it as opposed to remapping it.
IOW no freeing of pages of already initialized vmemmap like the case for
hugetlbfs, which simplifies the logic (besides not being arch-specific). After
these, there's also quite a visible region bootstrap of pmem vmemmap given that we
would initialize fewer struct pages depending on the page size with DRAM backed
struct pages -- because fewer pages are unique and most tail pages (with bigger
geometry sizes). altmap sees no significant difference in bootstrap AFAICT.
Patch 14 comes last as it's an improvement, not mandated for the initial
functionality. Also move the very nice docs of hugetlb_vmemmap.c into a
Documentation/vm/ entry and adjust them to the DAX case.

    NVDIMM namespace bootstrap improves from ~268-358 ms to ~80-110/<1ms on 128G NVDIMMs
    with 2M and 1G respectivally. And struct page needed capacity will be 3.8x / 1071x
    smaller for 2M and 1G respectivally.

Tested on x86 with 1Tb+ of pmem (alongside registering it with RDMA with and
without altmap), alongside gup_test selftests with dynamic dax regions and
static dax regions. Coupled with ndctl unit tests for both kinds of device-dax
regions (static/dynamic) that exercise all of this.
Note: Build-tested arm64 and ppc64.

I have deferred the __get_user_pages() patch to outside this series
(https://lore.kernel.org/linux-mm/20201208172901.17384-11-joao.m.martins@oracle.com/),
as I found an simpler way to address it and that is also applicable to
THP. But will submit that as a follow up of this.

Patches apply on top of linux-next tag next-20210827 (commit 5e63226c7228).

Comments and suggestions very much appreciated!

Older Changelog,

v2 -> v3[3]:
 * Collect Mike's Ack on patch 2 (Mike)
 * Collect Naoya's Reviewed-by on patch 1 (Naoya)
 * Rename compound_pagemaps.rst doc page (and its mentions) to vmemmap_dedup.rst (Mike, Muchun)
 * Rebased to next-20210714

v1[1] -> v2[2]:

 (New patches 7, 10, 11)
 * Remove occurences of 'we' in the commit descriptions (now for real) [Dan]
 * Add comment on top of compound_head() for fsdax (Patch 1) [Dan]
 * Massage commit descriptions of cleanup/refactor patches to reflect [Dan]
 that it's in preparation for bigger infra in sparse-vmemmap. (Patch 2,3,5) [Dan]
 * Greatly improve all commit messages in terms of grammar/wording and clearity. [Dan]
 * Rename variable/helpers from dev_pagemap::align to @geometry, reflecting
 tht it's not the same thing as dev_dax->align, Patch 4 [Dan]
 * Move compound page init logic into separate memmap_init_compound() helper, Patch 4 [Dan]
 * Simplify patch 9 as a result of having compound initialization differently [Dan]
 * Rename @pfn_align variable in memmap_init_zone_device to @pfns_per_compound [Dan]
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
 * Add cleanup patch for device-dax for ensuring dev_dax::pgmap is always set [Dan]
 * Add cleanup patch for device-dax for using ALIGN() [Dan]
 * Store pinned head in separate @pinned_head variable and fix error case, patch 13 [Dan]
 * Add comment on difference of @next value for PageCompound(), patch 13 [Dan]
 * Move PUD compound page to be last patch [Dan]
 * Add vmemmap layout for PUD compound geometry in compound_pagemaps.rst doc, patch 14 [Dan]
 * Rebased to next-20210617 

 RFC[0] -> v1:
 (New patches 1-3, 5-8 but the diffstat isn't that different)
 * Fix hwpoisoning of devmap pages reported by Jane (Patch 1 is new in v1)
 * Fix/Massage commit messages to be more clear and remove the 'we' occurences (Dan, John, Matthew)
 * Use pfn_align to be clear it's nr of pages for @align value (John, Dan)
 * Add two helpers pgmap_align() and pgmap_pfn_align() as accessors of pgmap->align;
 * Remove the gup_device_compound_huge special path and have the same code
   work both ways while special casing when devmap page is compound (Jason, John)
 * Avoid usage of vmemmap_populate_basepages() and introduce a first class
   loop that doesn't care about passing an altmap for memmap reuse. (Dan)
 * Completely rework the vmemmap_populate_compound() to avoid the sparse_add_section
   hack into passing block across sparse_add_section calls. It's a lot easier to
   follow and more explicit in what it does.
 * Replace the vmemmap refactoring with adding a @pgmap argument and moving
   parts of the vmemmap_populate_base_pages(). (Patch 5 and 6 are new as a result)
 * Add PMD tail page vmemmap area reuse for 1GB pages. (Patch 8 is new)
 * Improve memmap_init_zone_device() to initialize compound pages when
   struct pages are cache warm. That lead to a even further speed up further
   from RFC series from 190ms -> 80-120ms. Patches 2 and 3 are the new ones
   as a result (Dan)
 * Remove PGMAP_COMPOUND and use @align as the property to detect whether
   or not to reuse vmemmap areas (Dan)

[0] https://lore.kernel.org/linux-mm/20201208172901.17384-1-joao.m.martins@oracle.com/
[1] https://lore.kernel.org/linux-mm/20210325230938.30752-1-joao.m.martins@oracle.com/
[2] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/
[3] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/

Joao Martins (14):
  memory-failure: fetch compound_head after pgmap_pfn_valid()
  mm/page_alloc: split prep_compound_page into head and tail subparts
  mm/page_alloc: refactor memmap_init_zone_device() page init
  mm/memremap: add ZONE_DEVICE support for compound pages
  device-dax: use ALIGN() for determining pgoff
  device-dax: ensure dev_dax->pgmap is valid for dynamic devices
  device-dax: compound devmap support
  mm/gup: grab head page refcount once for group of subpages
  mm/sparse-vmemmap: add a pgmap argument to section activation
  mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to
    helper
  mm/hugetlb_vmemmap: move comment block to Documentation/vm
  mm/sparse-vmemmap: populate compound devmaps
  mm/page_alloc: reuse tail struct pages for compound devmaps
  mm/sparse-vmemmap: improve memory savings for compound pud geometry

 Documentation/vm/index.rst         |   1 +
 Documentation/vm/vmemmap_dedup.rst | 300 +++++++++++++++++++++++++++++
 drivers/dax/bus.c                  |   8 +
 drivers/dax/device.c               |  58 ++++--
 include/linux/memory_hotplug.h     |   5 +-
 include/linux/memremap.h           |  17 ++
 include/linux/mm.h                 |   8 +-
 mm/gup.c                           |  51 +++--
 mm/hugetlb_vmemmap.c               | 162 +---------------
 mm/memory-failure.c                |   6 +
 mm/memory_hotplug.c                |   3 +-
 mm/memremap.c                      |  13 +-
 mm/page_alloc.c                    | 151 +++++++++++----
 mm/sparse-vmemmap.c                | 278 +++++++++++++++++++++++---
 mm/sparse.c                        |  26 ++-
 15 files changed, 803 insertions(+), 284 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

-- 
2.17.1

