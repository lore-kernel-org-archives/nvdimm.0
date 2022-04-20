Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC5A1862
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 15:54:23 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KDh2Dc019815;
	Wed, 20 Apr 2022 15:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=PQ3B13yG7U+lzfD1T+iIZi0MpMiPjgQQKVFO7IcaW1Y=;
 b=sdTJljq/1ZBGWt5pA+c4p3xsvTCMOWgTgpsVZUIi/IL9XOmhgjqQ2kKrXIDHwYn2QFga
 lZtaIu6zidgZw7jFIWeQUymVuhhsIJ0takqyDAYEFkmPCdyw6eb7Hxg84WzcaG0X343q
 E3AQDlrAvlCtr29NOFd+qPkn9usI7J8FCNAe5xE3PRSc5jq/wIHEnKivFz5ycp1PMXPD
 /QnePLqEMZJS1OCLGar5xGR5+Iz9sfmg/17qcNAxnB92ABRyYvPXXunXdYEfBGDmxkRA
 hPEITLkFQTUIThl89iCTZ6tb7S9jxCacA7gBGuP/BCMaIV+6qPZdtZ7Iqs2GyJYjAdrO YA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd19k95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:53:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KFojdt037626;
	Wed, 20 Apr 2022 15:53:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm87c80p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Apr 2022 15:53:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRHVmifB1kzJaq7sXWP/UY2+VuuxVM4TEj7yXUvlEt10qK+7sqTU8xTMBkK7uACE2KkdOpDqIqZ/08jHIT7jf9Z15mXQBuMHocgATpznN1YPK8OH8WRf7PlO31lmPXH/JqcqQ8Z414kgrmMQHo7wddT1zZUFrjFDdSgk925s60rohDrPTV1eVQUqHeM1hgdHkS+hW4lq2hyc13louLd5XWq45TbDSRK+TXlMLXishwbAY/i69iqXccji4cn0l4JQSz6bIcx9b4Y4Ksdgr4U9lTqFSbbB3juTN3aDCbs+qCyS77lDJu3xG/Yvsq6Y43dhZYtn96HGlGtAC0TpwW3tog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQ3B13yG7U+lzfD1T+iIZi0MpMiPjgQQKVFO7IcaW1Y=;
 b=JoClJ91D9qBeVhTVZvuSeRsM9fXSu8fUZnrnKjajz72eSvtsv0AgfaOItW8RSZcyFPcz3rI8MOnjxiLviy5uQsrCcdhI0+yEEi5xdC8rTXo/imuT7E6k0I8n9NilKRRTVYhiGJpneB3dzzVY39n8aOTuODKE9dstZ8kAw9ZxMdh9Z/QgyAROo4EGJ9mt0JyCAVyYzsbpD0QJAr6YHWhl+eR+IFQhU9vLTpAnE2VSFt17duPBgtRXE6N9D/MGMGiXprFtCuohzYU9IVPnKfzxkE9TGJEQVvOxGz+MXnU9bTbAqCdFm2cWsjrvb2JGhhkMYv77eS9V6dsl4Ju9j5wOJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQ3B13yG7U+lzfD1T+iIZi0MpMiPjgQQKVFO7IcaW1Y=;
 b=UhhVMMmDc20dMMSTqga688zZbxRFw1Kx8hrkzKbCLNHfJCXqmoeKzQmujGf6UK6Mn7hfxUbnR3Jdyk8aX2ZpOw6qyEmjTFgC85IBMDnRY+syeXeI1WcLp1/lp/Nk04yfm1dWR5zPxLKhxvTFWHVa8aK74pLjjUqYqRiQBn8nQdc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BYAPR10MB3046.namprd10.prod.outlook.com (2603:10b6:a03:8e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 15:53:49 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d17f:a2a4:ca0c:cb49%4]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 15:53:49 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: [PATCH v9 0/5] sparse-vmemmap: memory savings for compound devmaps (device-dax)
Date: Wed, 20 Apr 2022 16:53:05 +0100
Message-Id: <20220420155310.9712-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f1b23c4-99b7-43c2-3399-08da22e5f581
X-MS-TrafficTypeDiagnostic: BYAPR10MB3046:EE_
X-Microsoft-Antispam-PRVS: 
	<BYAPR10MB30467D4D0D38F65BEF333CE3BBF59@BYAPR10MB3046.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	TgmiXY6+ztmbgguZZV5I/ybVLxThq5wdD0bxaAIk0MfEOUG+u3F1ixJF1rUP1Mxm6AXrbXCO8yfZhppohzjXUwVXpqwRmsW44ln3vnqSZLAbaDklBXKNV/wtbizUE1xqi/QwQefJmD9JUjAfaBKcFTHn0Gn8jtovpFGgkJEwHsNAt4OHraB2JIC/4UADJSYjsamBYxwE2BWP+iOiaZ4jMubn96Aoi77R+t8buHLKiiJKEOYDEUS9uX1yWpn/sgLd56EymgS6tlfTIidXvhYSCPNwA+9AuFw0FIrWyzVKi29QVSm2kO5mls3mSww7W5DU7kng+EBIkOgBvSY22Dx/P8JrGRSog86sb2BLf/j7HEiVFQE3ckIsNcUin3nzEanFWVo+5hHF9v1tSA7d1dzyVWUpffIqN0mXjq3TcLR3gVfMUO2RS0j4UF0Wet7PZ23kp5qfN0ifL13ZcXtOL1q3SCwhE/GPphsE8ixNxVQVP64YLtkUCbC6JeUXkNu2jmw+4vwoy3w6WQvQgx6Xo+mAHEoFnwor+8p1j9Pn2EXoKM2MhzxO0zypZIrHV4LQHGGJ3XsldhRUHpCHo+KnR2BMQgDH8h/TUgXr1TVaWX2h3iI1gqk8JNJ7ojHVOc7pGgPdZ3RmOntHluukdbCsiTlB902WESTXpqNIrph3Atea88KUTvzXm+gG9OYClgHeHDdkXiuHa4KRl5lViFZFc+XW+4xBoeHECUgGPuUJcW+VucPbiRxUTYWehH2z3nIhsUErtDyvO+yl+BU6Hl5/771NWpcSK0L1WBKJ+mOzEfD4ZujmK2r35sEgNy/o74mjJd6O8iJng3DVGOuajOkeWdes/A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(103116003)(30864003)(36756003)(66946007)(66556008)(186003)(966005)(2906002)(1076003)(66476007)(4326008)(8676002)(508600001)(38100700002)(6486002)(38350700002)(2616005)(5660300002)(52116002)(6666004)(86362001)(316002)(7416002)(6512007)(26005)(83380400001)(54906003)(6916009)(6506007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uWOtZtTMkGUVF+YdQsmyJnszjj+TS5QXi5H4Nn3BuyzVaEh/yvEvPSnZBR9H?=
 =?us-ascii?Q?O0sbunmM9qJMD95pDXUy04p0a2673qHYj/uPu6RMmlqeMgISAsnOw5iz1LlG?=
 =?us-ascii?Q?utGjj3zsknX2mh4rC/jk/xFsdikPqMzu3ACoJVRWwYMbavBkJn5OLZGnJoBR?=
 =?us-ascii?Q?oSsr7evATS7nCqduUOf04WgI1zveJWR74/hj+uzhr+9/lsgpOLXt+mKktoql?=
 =?us-ascii?Q?xfu0w/RaAsJvh21VWJd+z4XPRYFlMxYqb5KmeKD2GyscS95kvoNawfDuRNoF?=
 =?us-ascii?Q?tchUzzOa8Pzl1XwHFSeup7IjA923CQeCAeNdGW985GaFMVBHxtjDgyBnKcDa?=
 =?us-ascii?Q?SSfZsjMq/KlYBwkcCHbnV5SYfMVPfdYPSkE/yKBVHeIfSiF9M/4JLJN5Ol3+?=
 =?us-ascii?Q?cEU1OYdoUhZFu00ArveQQZB43dHwNGN+qQIxj9OoR8WslkNa3iGo9Jklwc6G?=
 =?us-ascii?Q?Xo1sF9RBN4CW+qqRyYNkE+XYA1YsdmD4KjnsW+JBuprkSA4nZQuBbLz4pn2r?=
 =?us-ascii?Q?e5Rh+tOiICoVds+E7e3sAaNGrRWVDwpRcDTF/x89ZmmM7PRqQvWY4cODQ1sD?=
 =?us-ascii?Q?m2M5S/y5COctPgZp9AQXpXBC4pzTbwQcvj98qt1W/SBogCfCCDov9xQkK0tQ?=
 =?us-ascii?Q?zOLEa/xG+UtHUo+YpQ58HOSTOg3+nCu6C9ibYuWdLHN1WaQcvH8l+kcipf7w?=
 =?us-ascii?Q?R4PfJqmYOwc+r/KR32cBG/G/EVETMhm9Reha7WInjrjd6NK1JdTbUptwlZ5I?=
 =?us-ascii?Q?0Svg+m5mh9Wb4pF30xN16BCowJC2mbsC07ztswjmmDPsYm2ZPI3rxxntn4EZ?=
 =?us-ascii?Q?SmwJU0G3sdUQR29T4CqwDhkaGPWBZq7vwS0wilXGWX7V5t7kQ2dOxRUdHHHt?=
 =?us-ascii?Q?/F3maaIoCrW3oE5MqSHHkgsAQ0fS+WnH6aqW47WHv9qVy5AjBwVETGreOf5K?=
 =?us-ascii?Q?h5BHT1PuI+76OCynrS/nlP87wgXh7KuMxIXAazf42DdwnRDZIi6SyNxkAxQN?=
 =?us-ascii?Q?zuqVk80hLQWvE/PgIMyjbLILYlwD+Np8OZ4sAisO0z4Pf9riGVT0dLiMBSdi?=
 =?us-ascii?Q?e/D9sRIWTJGaLNYq+dNmUPpYHie9I55Q6SNc/oKtbMeVjf1GyZT7Amlr1c/4?=
 =?us-ascii?Q?TMsJ1gwbEunly+sSAWTrCgXxQha7aL5QAA6MbcwwdSvPHpQu9Am+75j8hJl2?=
 =?us-ascii?Q?rMQ+/tPOineUddtt+RvYXuHbtxRFcqi1ItPlJHnIfLGG5MhDpAQDvZ1ZEml5?=
 =?us-ascii?Q?NSjs2/dG7qbAGWRjP0cnupfIC5MQ6jGxbDhQXUPR50CLY/BD5EIinYAa72Of?=
 =?us-ascii?Q?7kyIvggKbhHSudUimByUSVSiTs/eNXc4jvilAl1wlbUEgKMQQp+mdsA0FN9k?=
 =?us-ascii?Q?5URvcUdS9HT47esMqUkMz5HAEDOTo34aCAMiDe7TZ8qLZXk5NyEgBa1DJqVB?=
 =?us-ascii?Q?OjjIjFPfqFk1HBonJ9yWG5TltBcVqeDr97QLk6AZRtqYXQ6PTEjojHZW4IVS?=
 =?us-ascii?Q?1qXySRAwvVh/4z+HBI3hpjDA2KWkHXkm3n192U3EV/Ezclr623VwBzct5ND/?=
 =?us-ascii?Q?4/9/hIXFOQTpCFn7gP0IhxKgPXLRoNHxvCkEZSrg8KUky8uc70Hq9DoOEHih?=
 =?us-ascii?Q?kgtrMSID8PaGzX0wNMxBekmqaYoY49gRPajahIIJRcQA/0/SglLWmhBO/FdV?=
 =?us-ascii?Q?1B6LS8sS5eYB2ZJcTRh0+dGQPuU073+BQcUueWEyfKiZoj8kICbmYO7W0G/y?=
 =?us-ascii?Q?a0RaeYXWRUuGjrBwkRh0pAVvf77r4c8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1b23c4-99b7-43c2-3399-08da22e5f581
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:53:49.3554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qiCthvCaV+kF4jF3DKdvZQxWJGQNEkKYZPE95t3lYHMJiQbYbzdnUtoOhr/LTP1uVO0Hwng/g+8qMQaLAMHIHmvw6pgiGCJpbfGp9xre/Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3046
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_04:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200094
X-Proofpoint-ORIG-GUID: HJB_OD3FN2vw5Aznf5R9_zTHzPA7VU-I
X-Proofpoint-GUID: HJB_OD3FN2vw5Aznf5R9_zTHzPA7VU-I

Changes since v8[9]:
* Rebased to next-20220420 / v5.18-rc3
* Rested

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
    smaller for 2M and 1G respectivelly. Tested on x86 with 1.5Tb of pmem (including
    pinning, and RDMA registration/deregistration scalability with 2M MRs)

Patches apply on top of linux-next tag next-20220217 (commit 3c30cf91b5ec).

Comments and suggestions very much appreciated!

Older Changelog,

v7[8] -> v8[9]:
 * Add Muchun's Reviewed-by in patch 4 and 5 (Muchun Song)
 * Add spaces between the '/' operator for readability in patch 5 (Muchun Song)
 * Fix rendering issues in docs (Jonathan Corbet):
  - Add :: for code blocks and page table diagrams (patch 3 & 4)
  - Rework sentence to generate a link to hugetlbpage.rst (patch 3)
  - Remove the unnecessary vmemmap_dedup label (patch 3)

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
[9] https://lore.kernel.org/linux-mm/20220307122457.10066-1-joao.m.martins@oracle.com/

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

