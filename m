Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B4A2F28
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 19:34:30 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AIeRud008871;
	Thu, 10 Feb 2022 19:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=BD1JW+lG7pX5X54dfgctsW4clcyzAYY+ys39/qbxQ2w=;
 b=CgPNkkpWjZcizIVJqTbjJuDGBOQsQY9qiYRe3NfW+IbuakR0xOyQNEOE5RXsYhV6Vba6
 +kZH+GYHfEIBroQ0auFLgAzkenIEhqUV/+aK5QiNOeuhZZN+YIBgFB7zfIYbFxAioCtT
 4o1d5/LcOt9/uEJZqHMX8KvoMZepx1d9fRar9QUr9+E4xZOjTfrgSaHvOryKCyEdaWF8
 zdK2tBsudy5ZR6aPx5gfCMD+aFDFU4ADz4sdB/MfMWQPDUszGG9yCpVYSFQGYEVgzSjK
 QHJR+Y6Af8fXsP/AhIry4SxGGMkzRsHZh69W7dPtmXn/ewR4ADF6wjoi56LoHdRGvG9r BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgscag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AJUVSl120731;
	Thu, 10 Feb 2022 19:34:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by userp3020.oracle.com with ESMTP id 3e1jpw3cgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Feb 2022 19:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGoeAIDUiB9D+Audusk8gGG8LLAUs7nFHthiDqs3Xf9onM0tpYJD7ER0Fp1uO0fOjoGg0BoINefoe9E5gQhzWJBtsZOhWp2KeEUYfpoH/vbRJQIu3PIHDCrAc7PEWMnF2DBdE9ZYlSc6FIvnpoN/2Cb1lRSqRmKzoLyd0d7LxdgAk255Wzs32CNTdriU96IBokbQvluNJ2N7v370TMKETQXv4TgfzgcMyjoGXCcMuSsVZY/8MZAf7mk/jowJS70Y59NhuB894782OR79p2qlUsK3j2U/nYl89oVC3qzxKxWAki3FDWBYJT9GHHQEeM3wGphSFW4pJwZVm03/Z4A6jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BD1JW+lG7pX5X54dfgctsW4clcyzAYY+ys39/qbxQ2w=;
 b=kGM0Kcw++K+6I3asDaXzMvOfv5UbsqpTTWzmrtL4JB+ysKrWordkkA3Dr8o717bkuf2WJBo+NBfk5HJnKDC5QADyxPHM19LWWkoyazyz6NboGp/HKoPSMZuFirwqrnxeBmYYesys/vjSRyM+tl0Pmb8I2b4rpGBViW08QbeYXUQEHPN2+siuKvftnlz+3fA28V8A6LofryCRnKRFAJQbcyMlBCrrvzS+J3uSPXJmFjI7s32aslbfhM9uvUrJ560RcSE7Hl1goIrM/+eWjJNfzRaBwYdARRRQkIWYRviKXxWetj5gzSUGNNQVtP3IYYU+zAlUo3pAWKSvSeyYiNsSmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BD1JW+lG7pX5X54dfgctsW4clcyzAYY+ys39/qbxQ2w=;
 b=KqO11sESiycjRObs2aDKGBDIZnoIYhieb97tmHrEy2IPV++2CSx9USp5KUmOhJfXRYL7FR0gFndp2gauJ4HVpv9I13+FqRs3PKw34diN9Xe1nNCdMYdl2XTvFFi5X6700Mb2DgAQRPavcE6+IoHiFKlYeGLASra3YJutdB9obaw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3033.namprd10.prod.outlook.com (2603:10b6:5:6d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 19:34:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 19:34:09 +0000
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
Subject: [PATCH v5 0/5] sparse-vmemmap: memory savings for compound devmaps (device-dax)
Date: Thu, 10 Feb 2022 19:33:40 +0000
Message-Id: <20220210193345.23628-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0170.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9931d280-9c3b-4de7-bfca-08d9eccc4ed0
X-MS-TrafficTypeDiagnostic: DM6PR10MB3033:EE_
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB30332BB8B5A9FBF0AF9EA231BB2F9@DM6PR10MB3033.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	o7VF6bCtnwmTd1g3699Lafvh9O4PBxQB3L28M79uRkitoM4UCNhaxzHFeggQqT1uNB9hBHuhB3XJqOiJ/ghBKUJyu+Q1ozcUDL/VVNqLwYcPkv8cOlOQMNxii0MxCnKKV09Lgg0VaeQiHJPKB7+gc4Ci0v1uyY69xKV7HdarwacB6aBkzyCywQd79rxQzM6gOUyI/UPZ27YMMmrIqQ1CZM/EWp79JHGpPKuE6IPzujXqSSR1x5tkyt2/J1cON0WlUOrpFT6ByAXq5XZUjGNHq+KWXbSnqBSOpFSlr7PNDCq/VqF8HPYyyDkHI0jfXX96iirf7Ep1sn74hYYjfik8PkN+0u2gLNRFbLcKz93U+vH38/ww/68fh77c39msEUaJZn7zvxIS8Alz3Gnx4+tISlkB/IvkqOul2lfcVTjUHe1lBQwe0qFTWtHhPnqgkS2T1e0HEOyPZog5yLDweQ9NblWjYz5nPH4q56OggWCv9dgqy9vtXTOdd4pvvz7hGksGETqVBaj/uNnB7Hu6K5fecJCPUELQMsPa6WPJTs7xV3RFj2yOVhTsKko0RiLx9nbmkmHituHtfvmb9SH4sUKtMdEbzoNNurLVj4roojKexQdWkrj99g6IqtFzBytcL3/b1kPfc2nPgczVcfH/fvWhmsatnHM9iEoqaQ0NEwrgMzbY88dhdAwCL077vmrszcFkHx3XCT0ZXCX0ZyFK74gcpqnMV6VSLIuDSbmX1awQT1gSE/eyzgJQ0XFIlzldfOHwCgKCWGxGHb21SWj1MkC+RwC7bOXhCI6yslGeSsKC8vewV97X0wCMjNhYvktMmxznv12N2yK1BEGhxl02Tl7SMA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6916009)(38350700002)(38100700002)(966005)(6486002)(186003)(26005)(2616005)(1076003)(66476007)(66556008)(66946007)(316002)(8936002)(54906003)(4326008)(103116003)(86362001)(7416002)(6666004)(36756003)(52116002)(5660300002)(6506007)(8676002)(6512007)(107886003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?GPQ4Jga+tBaNqQn7qHaN+xfiDTdr+hQ7H/C4LRN8FxAOuAFe/qR+jkGftubD?=
 =?us-ascii?Q?GjRxam6NU4TUPQKQxHpNq/4VauDb654MYSCtDPUnzdtM7jlSS8POaUAwfw+U?=
 =?us-ascii?Q?YnzFvcTB7+jILEC2AS7Ug4gS8mDE7Dar8WwW1zKef2GQUmcLLSoMIUIpQM5q?=
 =?us-ascii?Q?fuvUXfeVyg62tVJCNbL6bhrzXXxlFdRJKZEBSU/c+ITQfTg/DFnaw2h3t/WS?=
 =?us-ascii?Q?W40/01mIQrTlrZC3iDo6koC5eEBikLV45DqVU4GRLhy7xNwilO1MiPAV73hr?=
 =?us-ascii?Q?x/+/RRGfhvRMA6hP4hATG7Y5KlpUntL0oZ5IZPH0VdL/y3kBRm37tydznhCF?=
 =?us-ascii?Q?axJz7xMFaUu216Vm30aYabfsx1PAN52IQa69FXo2wc0OOWo7zBU5oVN/qVX1?=
 =?us-ascii?Q?INUx4AELOrLplswC32HaEFCSiyymR2eibt2M0OQqKJnpNrbBpUUJHGJDtGqG?=
 =?us-ascii?Q?Kc3JVJWPXsnM4mT/ETgtpR+oh2OBU1gThHhJDwPParmPzfVEyA5MK1IBuJKT?=
 =?us-ascii?Q?cseVOL8YI8s08PO4W26M0W8wdLIeWENC3QspMNPkWJTinapN5hXzZgtU/hJI?=
 =?us-ascii?Q?qsSkGP/Lzy9wYNyaJpnOfa4AQXsATzr8vIWWjAbFX/gQ7JnUGJVv4fuMs3B2?=
 =?us-ascii?Q?EifKT13d/JuY3EslwH+pQHaoZ8n/CnSzSSDW6tZUoT62s7ubfySn+LPLX2g6?=
 =?us-ascii?Q?j4TZAsKnXk4VtPbTD7HgSssyJaFM7ihF6EhjwV2nr2XmUJEs0kFhAnYsx2kC?=
 =?us-ascii?Q?cG9HUwVW7JS87fKAtIivvanDFcXkkBw1e9GSMTJb2kIlW1/q8NP9L1D6Z0S5?=
 =?us-ascii?Q?gJolalogeqVBNjeRrug8GRM7knvqYC68zOcXEb0QFQQURdfx0e9gGZVzIkwW?=
 =?us-ascii?Q?MxLjrfGBasunIYh9rnV35raz4+EwReju1f8slqDbq/KM8v27oEIqp3LEAL8I?=
 =?us-ascii?Q?n2HngeFgtiEhtdnfA4zG3SMLPUA5u2EM3VZPpaahxBI/mb0I9q7RFYYaqYaf?=
 =?us-ascii?Q?jLdZfmJCpvQvPmWhNcaHzKefoH6+eUx1Pop5GOUVXBIA2dG6PNeoog4zgXml?=
 =?us-ascii?Q?oOUjyAUih2PR1k7rSmZl1DxJwCdNhzGBAQNpPuSqcov1mX6BqbywS/yrnicl?=
 =?us-ascii?Q?zRRiYEuIvahC+hWQOX4ijEzkKNIY+pSt2hBFyaHGCRuMRR9NCmAjC788iNV3?=
 =?us-ascii?Q?cjs0DJEYQoXWJYnOL2uzv8z5TjHxMUuRLO10LHOyCVbEI6wx1g+Tk9MoH3RG?=
 =?us-ascii?Q?y+SFMGUfD1vJBon9Z1muZsdVbB0IAUCKlYD5jsK86N5DOVT180TQdqzYpx5h?=
 =?us-ascii?Q?seo40Z+MQCZLKPuMv9JWtv7CWUXfykw1Ycmv7BFBdXo+5ChFR99izxiD93RG?=
 =?us-ascii?Q?g+lEMFAax+mdmPPvsqT7R4i6e1DqlHRSoB82jHBj34rW2RgslOuvIZn4MFbd?=
 =?us-ascii?Q?Y82KE//htQ9179mxT/Daa6BU4F8irBAW+4o7RvsvljRXP7Y0AEXWh5FY/k68?=
 =?us-ascii?Q?2fhFOGvvsoez7NtTujJzF/keZnR9O2AKxmLGWa1Egkrv8CyuikSzj58awaaM?=
 =?us-ascii?Q?fHLqHOIGq9r4p5FOD+8pb0B/d7l9zYzZzhUy/p1cwts2gxB/9w0XE8i/USbJ?=
 =?us-ascii?Q?gbFrcvklALPy97G6D93bOgmaMBmUHBiJztH6rGJbhCf95cbGmPNXCXAjoZOp?=
 =?us-ascii?Q?IoCQIw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9931d280-9c3b-4de7-bfca-08d9eccc4ed0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 19:34:09.2703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WN5rafeWd5JaRQrMW5kHKgvWQXGHr8fGeIFJMpF/xf3UJP734SDtFlvaEvbnCfsKLc2Vy3tuZ9b/5Ks42f0fL3F74E3AFC44xkBIFsJujsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3033
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100103
X-Proofpoint-GUID: -pgdBQ-TXkofY7rhoksA84o5n6-7mu4W
X-Proofpoint-ORIG-GUID: -pgdBQ-TXkofY7rhoksA84o5n6-7mu4W

Changes since v4[0]:
 * Rebased to next-20220210.
 * Adjust patch 3, given Muchun changes to the comment block, retained
 the Rb tags considering it is still just a move of text.
 * Rename @geometry to @vmemmap_shift in all patches/cover-letter.
 * Rename pgmap_geometry() calls to pgmap_vmemmap_nr().
 * HugeTLB in mmotm now remaps all but the first head vmemmap page
 hence adjust patch 4 to also document how device-dax is slightly different
 in the vmemmap pagetables setup (1 less deduplicate page per hugepage).
 * Remove the last patch that reuses PMD tail pages[1], to be a follow up
 after getting the core improvement first.
 * Rework cover-letter.

[0] https://lore.kernel.org/linux-mm/20210827145819.16471-1-joao.m.martins@oracle.com/
[1] https://lore.kernel.org/linux-mm/20210827145819.16471-15-joao.m.martins@oracle.com/

This used to be part of v4, but this was splitted between three subsets:
 1) compound page conversion of device-dax (in v5.17), 2) vmemmap deduplication
 for device-dax (this series) and 3) GUP improvements (to be respinned).

Full changelog (only for this series subset) at the bottom of cover letter.

---

This series, minimizes 'struct page' overhead by pursuing a similar approach as
Muchun Song series "Free some vmemmap pages of hugetlb page" (now merged since
v5.14), but applied to devmap with compound_pages. 

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
docs of hugetlb_vmemmap.c into a Documentation/vm/ entry and adjust them to the
device-dax case.

Patch 4: Patch 4 is the one that takes care of the struct page savings (also
referred to here as tail-page/vmemmap deduplication). Much like Muchun series,
we reuse the second PTE tail page vmemmap areas across a given @vmemmap_shift
On important difference though, is that contrary to the hugetlbfs series,
there's no vmemmap for the area because we are late-populating it as opposed to
remapping a system-ram range. IOW no freeing of pages of already initialized
vmemmap like the case for hugetlbfs, which greatly simplifies the logic
(besides not being arch-specific). altmap case unchanged and still goes via
the vmemmap_populate().

[Note that, device-dax is still a little behind HugeTLB in terms of savings.
I have an additional simple patch that reuses the head vmemmap page too,
as a follow-up. That will double the savings and namespaces initialization.]

Patch 5: Initialize fewer struct pages depending on the page size with DRAM backed
struct pages -- because fewer pages are unique and most tail pages (with bigger
vmemmap_shift).

    NVDIMM namespace bootstrap improves from ~268-358 ms to ~80-110/<1ms on 128G NVDIMMs
    with 2M and 1G respectivally. And struct page needed capacity will be 3.8x / 1071x
    smaller for 2M and 1G respectivelly. Tested on x86 with 1Tb+ of pmem,

Patches apply on top of linux-next tag next-20220210 (commit 395a61741f7e).

Comments and suggestions very much appreciated!

Older Changelog,

v3[0] -> v4[4]:

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
[3] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/
[4] https://lore.kernel.org/linux-mm/20210827145819.16471-1-joao.m.martins@oracle.com/

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
 mm/sparse-vmemmap.c                | 196 ++++++++++++++++++++++---
 mm/sparse.c                        |  26 ++--
 10 files changed, 440 insertions(+), 206 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

-- 
2.17.2

