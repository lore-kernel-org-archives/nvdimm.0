Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9B94281
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 21:33:47 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KEsjN028305;
	Thu, 3 Mar 2022 21:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=O0LzBeF192X0jFwV1K8P5rafN4pW40eREDn74XtfaX0=;
 b=YSPHDrs6J2f2eldHalj1bRbSSHCx9KT/igzxoV81u1ZtDYnH3vyltzRTioA1M1Zo6riF
 QJJmQWng7wp2Zyz8Ylp5fnVjYUSEJUN3qiaX/KGlNip9qySuHGKBtkjgbQMspBUT00VD
 lcAdktoQ/uuJ3PnP2rQj7GdMQ3wrZf5RpjmhiksPhMAaJWgdhbZh3InKRmkCxTnhmvVq
 jMlgGBVLD0Kn49i0Ok8AnzPHWIUIzUDFl2PvfdjyLARbsA4IbAQ4QYjgb3NavUzT8sbw
 QHtDd/CN8CV1q2LiOiDpFRPW6i07aqUVmzfYQt3w0blX6O3p9JEJcQyNiuZD5PvY8s7e Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hw05h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223LKt6C132074;
	Thu, 3 Mar 2022 21:33:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
	by aserp3020.oracle.com with ESMTP id 3ek4j7tppw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 21:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJq4Ky7IhVbX9ACUxRmzr8Elak6HEMV6zLsL61tnI3dROwBArsHYWzz0aP0CZJTFsW78+5lqZfTZHxYK6nH51zYvamMfDk6xa1ydV5Ko0I1MvlEjoKY6FuZz18PWUK9EEVFfdGT6ZT77ihnm92LzSRLc13zl6zmio/1MvKj+dyMglYHapmOOt0pLUNHU3DQ3xK3xjp5TT0a/gsWFgGdfJ1kEyeYzUT+Hs5LxYss8e/8KcC7zEEUSN7XSXtFbHZWPWp1LL1Bwphw8oFdnf0ott0CdHHpI65QnrvQ7LuzYb6c8Mu5XUSh42kK0NFW08ADLXlwcJfXGFvs0+GZCLIpEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0LzBeF192X0jFwV1K8P5rafN4pW40eREDn74XtfaX0=;
 b=Zjdug+xQvDZWwG3R+UJpLnRAmS9xfaYLHwJ6y6ArFmxWX/RAMf7VYvaTwT3aU7wc0tNcF6uAFIZx+RQVqa2/9gTiaDjepoCNXTfVCTzq4xc1pVOHJulppM9Gv6VrveD4yO0F9azNqusOroBx1kwTGmubBQOJCbO/Nh/XioJdx2DL3KSJJ3aykYNqbVrSNsjdHf90fGYNwwYchXUT+r0wSQjKTkru2mx5hMpNPhElJtIzH/FSYdDmdJuG6H+g7MXExETpk9lg+LHzv002WqFAEswiGyOUloS9ltFDAr2JLpwtJFCXdmybjcO33KDH6zRd9mSmia7qAKs1y8ftPIXG+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0LzBeF192X0jFwV1K8P5rafN4pW40eREDn74XtfaX0=;
 b=W9GobkZt85HyRaFJBJTrQD8PoU07//xRAP5EFYYUogRpek/wVsxiO7mdgJrAClPG3CsDXXsmf1eFJDYtL9UCHdRM5IVUdCkuIEloBtg3Zc4o6pPzMVPqVQ1MgO5UV43NcmA2rgTWMLFQXjAEInFgTjHXtFSPoPvwyyedvJBv9uQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4197.namprd10.prod.outlook.com (2603:10b6:610:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 21:33:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 21:33:25 +0000
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
Subject: [PATCH v7 0/5] sparse-vmemmap: memory savings for compound devmaps (device-dax)
Date: Thu,  3 Mar 2022 21:32:47 +0000
Message-Id: <20220303213252.28593-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
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
X-MS-Office365-Filtering-Correlation-Id: 9e41d0c3-a786-470c-d473-08d9fd5d7283
X-MS-TrafficTypeDiagnostic: CH2PR10MB4197:EE_
X-Microsoft-Antispam-PRVS: 
	<CH2PR10MB4197979686DD166853F17F7CBB049@CH2PR10MB4197.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+0+ugOX6TZtk78NxtH/q8vScvOporTf4YbIU4SrM/nekNVmDrfFXevY5R/lzT1gq3pRQ3KjWraBCfEEZdBWIy2k3iLDliPtHPNM3JZn40LFBg2aEdGMQGupNJ0Q6oITzp4XS5URZhB/klOI61Tgdfck2Hy/VSC7tUrpJDnFSPPp3uC9tIlJU5WZwQJokHz/zXxiJluFzDOHoX/Rck/KghSjbFUe7RoSFfsknzNnGwxs/VvFjpRs7QMY4EMnaXz9ZlxYqwpAZeGBkE1IqV+Rkz/4a0pKZy9zioBY+h0IrmIIZ3lOM8Yc2/U0inKlO1La5bZBQpkvRkFF8Ild4PcKWl3+puzUQp7uJjjXsRxVZu09mR2lweMI5wyv03Myk7QXD/V/VSihtCfBgR1nrwLmtOMYg5E3C55QIzn+UfH1+OJVQnaHstBzPZ2rj4ukVQqS0NpXHWM3xgmVnO1eQiziYlqtg2XNcQMwHosdNHCeCn7LbaVzc4L3CT+CDKPSN9Xs81P29nw0Z4SZQteg6B7SP8qCOC+YHHoPOTl9m40KcZUJ2F5BNHr5X1REDYmhl+OUG5uoXCQPHxPJbquPuSCyu+F2t7tx8qE8rFrx/vp5FYpQ//esMvyvCIt8X8G4Z39agMm3yYIBNxXQm4yGBhPqkN1x2snAWSLI8LajjSymCSOJ01uPgszksgRanyzUbXt2tACp/YLzXZOgF6Fg2TkOIzrrBEXPEKOLbkjpf1h+obyO9pmymZcDFxIETDZ2OdmBaDTZnYBMyDf7y4/s7x3XueUSSpk9JF3B5+CRX5qveFitD51gx+VIC4NmAq4/M/YlJi6Q5psM6oQRfoOcytTxMtQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(316002)(2616005)(103116003)(6512007)(966005)(6486002)(83380400001)(508600001)(186003)(26005)(2906002)(86362001)(38100700002)(38350700002)(52116002)(54906003)(107886003)(6916009)(8676002)(30864003)(4326008)(8936002)(66556008)(66946007)(6666004)(66476007)(1076003)(6506007)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nSLeNyOxTFgNsotFA8LUHWEqQwWeCLxCjM2YIG3VK1951Vwlm5ugNKYimn+8?=
 =?us-ascii?Q?DR/koDDqkt+6wYLMM2WyIs7iEpkLXpyRUwHQw7L1kTMf+zKQomz1pyXO5Ayv?=
 =?us-ascii?Q?fF46jDjeUI3APGrj82osEfG4aDgK+ZLM3M6KnV7y34wf7dbOHtE+mhuyTE2X?=
 =?us-ascii?Q?7Hgflfv89KIjrxJaL8mQ1cc1P23f3CgEFyMzS9u9yrCkpPUSH92fl87wQM6B?=
 =?us-ascii?Q?+bKPZ6QV6ZTQCl/2DbGgBEn0LhoGslUd1X92DnI68I4Qe++86tKce6AprIP8?=
 =?us-ascii?Q?6DjkyrM+GlFxDsN73vHl0ffY0VpGzUp27rdFgeOFJhweiKFf30xRxRRP+zge?=
 =?us-ascii?Q?fNKbrbeqhzz+r4XcbVP0n9z/3r4q51dTIg0CbkBPjoduDsbQ05bgx7EuMlzm?=
 =?us-ascii?Q?UMbJSVUexzAO2BQww8i4OCvziJDrSs9Yjx8XbZ7aGJbzgBgXjVQElSzTJPeE?=
 =?us-ascii?Q?SLljneDbbK96TDoODPFQRbB/KiN+9MBOZNDCLuGdCPz9IcM/QMUbORh5bVvZ?=
 =?us-ascii?Q?vFBcXxrsWWXjQst55rprW8PJ+vMrbAbeRkURIRq/aRAh2ivIH2Pkhfow3RTi?=
 =?us-ascii?Q?ZYINImLXYh1fkgXPaFkb9hg6kDwgmg79NOSXR4hzkk0rg/zdC1y6Ck1e1WZ0?=
 =?us-ascii?Q?IqOG+RAMqss4n5n36eMrKh6r/jX6h30ncPw8GyKA4j9pLmql4MepRN5Yx9E9?=
 =?us-ascii?Q?7FVfah03UjZLNmuO146cbmMLEXRh+xhG4ATQfbphMl0m9EHpKwjkvLqZGWHr?=
 =?us-ascii?Q?H1CNJsSg3xyiDDx+wjBHKLl1xoZVuu95RVAhBWgHtzP/NH3Z3ZlZeacpIxjW?=
 =?us-ascii?Q?6F/QnN7nykKYjfgKsHFZnrCihS8a3cX0EmF62pjVt2BAmGfRJwiTbicUAWUc?=
 =?us-ascii?Q?SSMLCLsXJQqoGeQk6Ab7RZ9+zbfneZVQN0nG4E6VkTt572i6JxmCBzQ6ic7U?=
 =?us-ascii?Q?12Haw+r8D0jjt9ZbGvo/pcXlxhuKCQs4cs7qbXrylEGWRNv8XPrRcik4yaKT?=
 =?us-ascii?Q?0joiSzrRenJ4giotM+5X2c/+F55i/g0ZExkU69K7jQI2E6Hyujgk4Rk6P6J3?=
 =?us-ascii?Q?nWN3jSaONisCT3k9kgvAGYCMspYsd5Z9RN5XlmnBzA5zZuEYci3/mXK5ZAcP?=
 =?us-ascii?Q?EhvVD7TqYukwlerx2dnocYbbKGet6CviQRc/AkX0NHyjEAURCuxbCxQ5DR6o?=
 =?us-ascii?Q?FAz2wH/iC1wEOeo2Pf+kWqi3YAF5z3GQmykpaEXmXvjCRtGKdT9LYSCTD6d1?=
 =?us-ascii?Q?gzCpz1UoZkbAVIoLnWVcSBHfqPzSP23Z4GqbdGnxLAJsRf5KK5mdkZVVEvyI?=
 =?us-ascii?Q?rC6QRqa94xFo4NlADPSmu+xH3JkBlqmEBG/nTDsaUCwJOaLpjICR3pBm4GWW?=
 =?us-ascii?Q?e3pT3G+qhklA+3Ld5w2Ve/OxuuYkG0Mw41W5GbY96RplGBkhWkswqorNooVf?=
 =?us-ascii?Q?OyzAS9mOP0mnF4NwDMI5BzUZZM2ck7khiwYRomt5MFO9nlwSGdoY0bUa9ymx?=
 =?us-ascii?Q?PYJTia8cHkELNKXc2A3IoT1bnyczTMyU8gZ9Mn5ohpEQDw8U7mQrmJGyRYye?=
 =?us-ascii?Q?aNE/U2Pm98f7WwAeRbsQQAt8QdDxoHN8ntJyrZFIdFcV4RZg3yXPjZI9MEUj?=
 =?us-ascii?Q?dtR0vjGO7laW3QW45Ai/hoMiNjkdqGVvCDf7me74qMgKOGf8SOJwbtcO3IQl?=
 =?us-ascii?Q?bjeOXw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e41d0c3-a786-470c-d473-08d9fd5d7283
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 21:33:25.0092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HWA+A8nLpHW9pDJLkvr4Sec2Nwp36b7MMlgIgQkos2p2GCZoZi6UfpO6pgwqSa98Kh0mWADtfeb6nSEvztU/+TP0Fi3IW7BAqUbgOrOcsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4197
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203030097
X-Proofpoint-ORIG-GUID: 2UPMf6ggHu8yOQDOzkT5QKQgTUAAVN8P
X-Proofpoint-GUID: 2UPMf6ggHu8yOQDOzkT5QKQgTUAAVN8P

Changes since v6[7]:
 Comments from Muchun Song,
 * Add Muchun Reviewed-by in patch 1 and 2
 * Rework a tiny bit of patch 2 to introduce vmemmap_populate_range()
   as a generic helper and have vmemmap_populate_basepages() be based
   on that -- that removes duplicated code in patch 4.  Retained Rb tag
   per discussion with Muchun.
 * Update linux/mm.h declaration for the new @reuse argument name too
 * Use @reuse name widely in new code that reuses a page for vmemmap pages
 * Acoomodate callers of vmemmap_populate_range() to have an extra @altmap argument
 * Add missing is_power_of_2(sizeof(struct page)) in last patch
 * Fix a typo in commit message in last patch.

Full changelog at the bottom of cover letter.

Note: This series is meant to replace what's in mmotm, so I based of the same next-20220217
as v6. Note that these should preferably be applied on top of Muchun "free 2nd vmemmap page"
series given that I move docs that he adds in hugetlb_vmemmap.c into Documentation/.

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

v5[5] -> v6[7]:
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
[7] https://lore.kernel.org/linux-mm/20220223194807.12070-1-joao.m.martins@oracle.com/

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
 mm/page_alloc.c                    |  17 ++-
 mm/sparse-vmemmap.c                | 172 +++++++++++++++++++---
 mm/sparse.c                        |  26 ++--
 10 files changed, 421 insertions(+), 202 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

-- 
2.17.2

