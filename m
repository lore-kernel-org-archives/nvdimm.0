Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E833B37
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 12:25:39 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227BsdgO006681;
	Mon, 7 Mar 2022 12:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=R7mwzQZEzaTtIAFbwCYEUO4FaI/nLmuRKZ7Lv9jLtAA=;
 b=trSpt17R10F781KscUIRfDl8QurdA+dV5zgQN4v6spxdeqaByVNtA38OqaKnxfusindd
 Mo6YJm9kq27hoerPIHuEiEV15sdWcSzdzdVz1mIJr53rEDsGYpjOt0ajBYlQtgeja9U+
 sou24i/IF0aa+pHnIm8Bah/hRipZUEKNYlM7zWcIIJiqpnoWpxC4MLtfR9KMRpIFFSU2
 KfOR2moW1/5cVpAhKt6iABjiEbtnh6S0saQYaEn7aGSZpGadLyvOHkMWNW57hDQX0XY6
 uEcuNYBOzZhc77WRSWt2KaX4ymAgM8rEbMnNuYfCnqYpDqJuvLo9SOhA8fqEC/scSAAJ /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2bn3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227CBrSb143528;
	Mon, 7 Mar 2022 12:25:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by userp3020.oracle.com with ESMTP id 3em1ahx94s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Mar 2022 12:25:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsNvc1t/v8MghwYwuhR6hU6KajTt6m3BfutgUSNOMO7DpCrycxhnIAICBi1hb4Lk3u/3S359liZu9knryhXQSJecu1zCBHJi182V8Hc3YA+xRLOyqhYzbmvmUlI37N8JnxI8OI3lhT2ZnEvnh81vdTXoBfjXO5Ic6o8r+LBkSkCiLAHT62ciYP3l3Zcle39DtfALy+tpNazzpKTkkpL+C6HKFClLtGUWZlSWTiKugtjZPrAePFMQLtwp8hVcQ8ctpWwITzyj+ZslE2sve/A5gIj/bl1xSX8ppKq8JshyjObsGeflLLPsp966Visd+dMpPgHWT564WCGb63eaL6ojCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7mwzQZEzaTtIAFbwCYEUO4FaI/nLmuRKZ7Lv9jLtAA=;
 b=E49m9W0Z8ukiTalBpuZ9MNXPrd1NAhiHv7AbSqnaUocwySdIBWupsKxwnnPV8K3ykQ9gcUPUGwSPeyoHU6JCcs1csj4RctngcpWxjwGnzW6fA9TIlvsiqW7ExqWl4qGS8TyXgE1puOlmC5WW6qu8d1XiR2YqxHjk8YZ/jHHs2QqtFZnhBvSg3rdPVSeMdjvHV60sk2bEtclCWAZ8K+3pRzGRIyx7ZIUfkcBv2yPFvp9p6eQT0LVTeuNIhgiGuLcg1smq35MiXNwgnEl7P/tjRXTXDnP4qKP8TT0RsqVfTtRDncXmYbd7Un0NDv0FZBJTOIUhdMXznP8y3/e459P7ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7mwzQZEzaTtIAFbwCYEUO4FaI/nLmuRKZ7Lv9jLtAA=;
 b=e2zDEqGO4brBBQofzNsXpPea6pLnDSIW46tehKkvPOfu57olxQyXwId0Rvx23GZLawYdjbMadgos6+H6EiRcbdpOr2MLHiWZyFOtdHho8jlWU3iLUW+xpXgWxphZ/O+VyYZP5N7PzI7BhQEyKoTSts2WYMhRlJIm5FmdEc/hlIw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3451.namprd10.prod.outlook.com (2603:10b6:5:61::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 12:25:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 12:25:07 +0000
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
Subject: [PATCH v8 0/5] sparse-vmemmap: memory savings for compound devmaps (device-dax)
Date: Mon,  7 Mar 2022 12:24:52 +0000
Message-Id: <20220307122457.10066-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
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
X-MS-Office365-Filtering-Correlation-Id: 660170bb-d0eb-4c6b-1db8-08da00358419
X-MS-TrafficTypeDiagnostic: DM6PR10MB3451:EE_
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB3451CCCE43FFD4E7E7D9B90BBB089@DM6PR10MB3451.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	FIg3kVrwv7STukYjbcfVp/ObnAig1Ylhts6tVzV2hfEe+l99TAVmPDI1rGTqZc+IGyu6c8dF5emVYMdGS/HR+yV/fXucqjUGL8/SDnDrB4AhWiHZwzUQrVcL49USBnQbsf1UE/pf4qi7IjLyT10U+v7RZHrxL7WeT3d7y1/hR9DMCPWIuHxaU+KTwdmHIOZNIjYluyYJ/Vl2AF/9u4Td2IYKwIXG1Jjb+3/gKlSzsd0eLRJzby0oNrGtxVQLf9NOqnCe/VQRWCh1jXA8OEtcqiyCnsoMwQRgXFSAmeNS23RCxxq6ltj3B1+nnDqo81uC35hnl32+8x77bbN522kmSRtZB8kyQLZa3LPmL3gS8LyW1++gJNU+S8qhzk5ppcsKHLg4xK2of/LK/J2LXU9OlJT0FmMDqEI8vWFuIDkVPdQs4REQBlVsetOAj0bcjI7WzHEAMHujERUn7U51tm42UblN2dnB8KHN/6r03tuXoTIvtfME880JoUWbCwg3eqggXgsqlCUbTDR0WGVmX8nRd0Xjv7bB+yxGaWDmONcwENeW9Af0PvSaNlOuyGVQepW8+E5ULVfuF8/BKG0O2Kluf/cK605DAgDL9Rz3H5Wf/afIvCzrmV3xkHXh5lqOzem+AljRMP/JY1vXg810iB68dyopWHMzUzsY9lndctKTNTESvd/u6eM0fsZndnWRyBtpoi1/LKKNJ+hE5EPKooxqu/QzqfCOP6rttAASql1q2zi71zwrBq2wt+B7GUZWWezz8s7Qd+xyotwqpEn9rACGN4GPeVVsolIi7EVvLS1ju/Wl/FBbkkHpESUQHKcvU2I1bZt++rTGmF2QQ90kXR96+w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(6486002)(26005)(508600001)(6666004)(1076003)(107886003)(2616005)(186003)(6512007)(52116002)(86362001)(6506007)(83380400001)(38100700002)(8936002)(103116003)(5660300002)(7416002)(66946007)(8676002)(66476007)(66556008)(4326008)(30864003)(38350700002)(36756003)(2906002)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?vv1uOAnEailYQZBybmt4bO4js6zoEkAtSdmkZfWgf44SRBM0yfbtG/frFaOT?=
 =?us-ascii?Q?JDrdCurHWWeHOs8VMqSygGA61d1zSs5KIzAo4vPqwKHPo1O7jeeVrxFMGitQ?=
 =?us-ascii?Q?TZxNlo8zdRRJYRkhraGj6PH9KXM/Dn4xZn4Fx511PfB5YQuH4IETJAlYNAWD?=
 =?us-ascii?Q?zDh+Lq6iIFLlX80r+abUjJn7FVMazdqYsIfXy7wzpdmeWjD4YN5XkwLBOVhf?=
 =?us-ascii?Q?7fohNeL6O14UAZdfSppCwMG47ceWvE7Uqd0psXpTCU9KRrFt2H5CiQW5/Fad?=
 =?us-ascii?Q?cGwEDbxH5qqgiStiiSilpnmkYB1naM/RhwfneVN1aKw3mEt8xR31qwoFg1mJ?=
 =?us-ascii?Q?ZphdM6rXq4OF1j5eKqJSfuzjBk5gC73cWcMCbqGg1OB2oKHFj5AoJWajnwx+?=
 =?us-ascii?Q?NfRo8HJUymZkdrBWLvUisos3O6BiHQz+tf1t8gf1fyLVnfn5rnJMbuOqYB7v?=
 =?us-ascii?Q?Q66PjYD/ICXMrz4uMWZZfS+Ff1EjMvIHWk+CYiennAjbLXWrKfVVpeHOqjSo?=
 =?us-ascii?Q?v04J18i1fdRMGVEbEUOcLrIS9W12gn2gTbSOnmeJJmwgWljQtC5u2tGlk2ec?=
 =?us-ascii?Q?gVErWCV54jz0V/A9SQ25euWXXSy7EP5em0CDIynMTvzUhKGggRQJuvrmSYuP?=
 =?us-ascii?Q?hI6c56VCOOeIgG7oRnpI1hEgRH36SAHj/Mvh6LuklcFQSWKhh61YEgwzAsuL?=
 =?us-ascii?Q?qArijbA682pHqWh6orhjB5Hm0wk7kq4HW2fIgkMBDCR62yo2oEwv3UNf4+NX?=
 =?us-ascii?Q?ftYvqRwiT/qemwcYpd/oJN/MviCkmDu72i0N0AxTMNtBfALiHcM7V7oaSvML?=
 =?us-ascii?Q?Sm9s0Z5lquNlVNlZ4IoNNG9NEhWqYSFjprpdjX1TaZQkbTgzVQXmG3UD92CU?=
 =?us-ascii?Q?We0BTUGFaZrmMisE2aN2TCCtRFHbUEix/DagwRBUwrdaFHCPy76D5Y9m9T4A?=
 =?us-ascii?Q?sT5kj8Vq0+6r/o4ohK3D3cDIoHehKg/XJHvKTj2xrAqKkFQHBvfbDsu1uis/?=
 =?us-ascii?Q?5IWl2mo4KaPupcxP29fD04BNza+YeDCGCtUMFAN322f5CoI6EDGgkiwBmv5r?=
 =?us-ascii?Q?/K+zacwxctroby/AhQdgFucrtPsEElP/aGmNd4UBjIOFi+4J4lPM5Z7w7JWQ?=
 =?us-ascii?Q?zBPPvj7WgZ+lKY5kC845JlceIgTKIYtgj4Mb8VwkaUyzUvp5gu/7xb4nUgN+?=
 =?us-ascii?Q?/gnx+Qm+UI8SyNCrxGdmYiWvQfuBvsTNs3sCAn4x0wIM/AH3C029m/v9rrGB?=
 =?us-ascii?Q?Ic7/IKnmZ25tHw5cqLXP5DGEvIUh380k958QUYdnSqhjEWuvDodTFqRb6T4k?=
 =?us-ascii?Q?3x5Tc85Rh7GFot/XiyKtVi5mCQfG5E5WSbSwlKJzewlZ0XT/K07D3BX0NASE?=
 =?us-ascii?Q?R7nMkShjjVCHK3LQAW80wJzgWqutUw1q/QXTBD/hFy4fvwabPQJNUNAZH1xv?=
 =?us-ascii?Q?yTyXf693aMRQHrivS5HQXA1pBhGjIBAdB3C4J35n2LqelKNds0XiLN7PYs6C?=
 =?us-ascii?Q?JkSYrb2SiBKHVx0fHLGF3Mui7LTZOJm4H5iKvqDASHo3zfwtxhIYqDouWmPu?=
 =?us-ascii?Q?D2XFp2kwO38bNblwVXD3LPmVGRupNWBhgMSeGOxHMxyMsjIogBuG5hpBOk3h?=
 =?us-ascii?Q?NhgOfQCZgqQYz1wP7VrFa9eDQC93XsSfUmtZbcan8EoQuJ3q22MPzT22VlWW?=
 =?us-ascii?Q?HowKqQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660170bb-d0eb-4c6b-1db8-08da00358419
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 12:25:07.7726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hfJ9AUAmLvuZ9NOFSh2hkP+TDDCxgXG2nlEzVOPkGD4TpUxPUn4G9r606MSMWGkorU+OO1TVgAEk4Oz7stq+EeREolDn7VkOZbt8RgK7Y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3451
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070071
X-Proofpoint-ORIG-GUID: M6bDjqnJVuo_UA9KUW_lcL6llD-dx08A
X-Proofpoint-GUID: M6bDjqnJVuo_UA9KUW_lcL6llD-dx08A

Changes since v7[8]:
 * Add Muchun's Reviewed-by in patch 4 and 5 (Muchun Song)
 * Add spaces between the '/' operator for readability in patch 5 (Muchun Song)
 * Fix rendering issues in docs (Jonathan Corbet):
  - Add :: for code blocks and page table diagrams (patch 3 & 4)
  - Rework sentence to generate a link to hugetlbpage.rst (patch 3)
  - Remove the unnecessary vmemmap_dedup label (patch 3)

Full changelog at the bottom of cover letter.

Note: This series is meant to replace what's in mmotm, so I based of the same next-20220217
as v7. Note that these should be applied on top of Muchun "free 2nd vmemmap page"
series given that I move docs that he changes in hugetlb_vmemmap.c into Documentation/.

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

v6[7] -> v7[8]:
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
[8] https://lore.kernel.org/linux-mm/20220303213252.28593-1-joao.m.martins@oracle.com/

Joao Martins (5):
  mm/sparse-vmemmap: add a pgmap argument to section activation
  mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to
    helper
  mm/hugetlb_vmemmap: move comment block to Documentation/vm
  mm/sparse-vmemmap: improve memory savings for compound devmaps
  mm/page_alloc: reuse tail struct pages for compound devmaps

 Documentation/vm/index.rst         |   1 +
 Documentation/vm/vmemmap_dedup.rst | 223 +++++++++++++++++++++++++++++
 include/linux/memory_hotplug.h     |   5 +-
 include/linux/mm.h                 |   5 +-
 mm/hugetlb_vmemmap.c               | 168 +---------------------
 mm/memory_hotplug.c                |   3 +-
 mm/memremap.c                      |   1 +
 mm/page_alloc.c                    |  17 ++-
 mm/sparse-vmemmap.c                | 172 +++++++++++++++++++---
 mm/sparse.c                        |  26 ++--
 10 files changed, 419 insertions(+), 202 deletions(-)
 create mode 100644 Documentation/vm/vmemmap_dedup.rst

-- 
2.17.2

