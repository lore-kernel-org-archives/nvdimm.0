Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17A1157E6B
	for <nvdimm@lists.linux.dev>; Wed,  4 Jun 2025 03:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007319; cv=fail; b=ZJ7u2IRIgZdHfFyzL9iBepB5xldn20QOaaXFSdfmPxg4zAA5Y+3JKUuI0LDAlu0rSi0MiP+L2423mM0lOb0CZY9neTgb+AlhEIm4Xq6fK/7hBCKs3nIsId4brBtjaMk9v/IClAlQ8M6CmnnmEetK6ABLvAZ40lEtoJi62328iRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007319; c=relaxed/simple;
	bh=cqX4WdsNQU5soyS3PKFigtJ9T6AE/CEaeqdkNI2bDRw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lncRpsB1DX0hW2B7/8lWBg3st+cSxTOWqnGmRqjQAgW91HyK6P/sjAVGyek3c14UwI9Vyzg4gpEv/bPjbnnrJHiaJ1HpyKhZ+w6J68Tit0q0JedT5p3xG2r1jz64X33x538TvbX1ANfxTZi8+5eEy6tg0Hd2HdLOuygFvSxilQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F+iO80F2; arc=fail smtp.client-ip=40.107.237.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F+iO80F2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pi4HnBEPPRpp89+Sh43nmNocunglrh2J/8u5Ys9c0b8Lj7PBA/P72+DxiN2stQMQ7D36Sij1cWpgkOFaR/qbvg84ARmtQoospMLYLx7CNmMep2e//Hs2R0dUJqSQVRRDH6P61guejpxkmIySDPwW/cSnwmdP769lJ8rdmXV/5dYUbc8Mz7bVshj7k+yjcG8LjtbqwMAByUsz/wMdguHzQ5dgxUOg3UtRswGiPp6hi920cjGblWxqOpYTD9m7JzWJHsTjHqmn9cysL7mEwNsjzZN1lVTkx3yMWw97w5QLX7LNfK4Es4HFEXmJLRzqx7i2JDWcIJPS6Rt4fxNjvOa64w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nldueHI4DIFoK8V/rCiyAbjSUDl/INfB63h+TIysy/Q=;
 b=yIkv6rXE+xwEZWIHqFAtEufj9hqUHRHmchAspDfF54MzHArX3BYc4LaGmhxEtG/JxkCxwvarzGp+XxaGGmc4jcZOBHhUsoRYwV7xdwsXUZTWC02nDSqanOcXji7tvx+k0JXUYoJEkkiRypUdJiQnOFbSNwXrxc5Q8Tq0B1zMBnxJ7gK80LLKeeqcZkM2OtfbHAUagixxRHrxrh1vAstrk28L8kA9mDrkEDAQGdMMIcyTKr23Azvv7/jc5qsO1r7xPzzV4zDfgY9EqOxFHb3cIGsJxq0lbozh4dJ7RiuDKF0Xk7NJIEE23IEuhwFg3gvKCBUyPkkJClNFtv73sVJETQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nldueHI4DIFoK8V/rCiyAbjSUDl/INfB63h+TIysy/Q=;
 b=F+iO80F2hidnhjpWBmZcyaCyNzwrFvY2YIHF/9TO2/NgGc8HYsUDc3VcdOptUfv9ZIa9d566zKBDDQ03OYmbV0KXh7TrpxiThcxhXNJPzkuwUe3dWD/C414JHNg3KUzasgKrk68I4XPYDHcDL2unel2kkSNL57hENz5CDgD1xp61MYM+PZCBCvxmVUIrO3H2yLGL7KdjJ8xSVItp80MtwWBf95d1hQXImEeJC3s1eV00kJJdeynq3d/ZlZp4ESoKwku5LPRoo64TxzLl/R4wVkdM5oMNX/M/ZDFVfi0l5g9QxdNgHKDC6JKb4ZN+hxY+6rHEClGLVGprflNdHccukg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB7728.namprd12.prod.outlook.com (2603:10b6:8:13a::10)
 by MW3PR12MB4345.namprd12.prod.outlook.com (2603:10b6:303:59::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 03:21:52 +0000
Received: from DS0PR12MB7728.namprd12.prod.outlook.com
 ([fe80::f790:9057:1f2:6e67]) by DS0PR12MB7728.namprd12.prod.outlook.com
 ([fe80::f790:9057:1f2:6e67%5]) with mapi id 15.20.8769.022; Wed, 4 Jun 2025
 03:21:52 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: Alistair Popple <apopple@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	gerald.schaefer@linux.ibm.com,
	dan.j.williams@intel.com,
	jgg@ziepe.ca,
	willy@infradead.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	jhubbard@nvidia.com,
	zhang.lyra@gmail.com,
	debug@rivosinc.com,
	bjorn@kernel.org,
	balbirs@nvidia.com,
	lorenzo.stoakes@oracle.com,
	John@Groves.net
Subject: [PATCH] mm: Remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST
Date: Wed,  4 Jun 2025 13:21:45 +1000
Message-ID: <20250604032145.463934-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.47.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0051.namprd13.prod.outlook.com
 (2603:10b6:610:b2::26) To DS0PR12MB7728.namprd12.prod.outlook.com
 (2603:10b6:8:13a::10)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7728:EE_|MW3PR12MB4345:EE_
X-MS-Office365-Filtering-Correlation-Id: b2caa676-b35a-4519-328b-08dda316f2d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4C8aQWPf+ojgCyKijMG7V52dLq2RTkNuvYipN5xyS94jC+NvsoM/+wpMVAuy?=
 =?us-ascii?Q?5miQXrO3MqMZsBI+YaMY+0IDvbFwOJUbJynqB+51O1yrheqRhyoPUqAuHnv/?=
 =?us-ascii?Q?DK3vikkP/2XTqVq2kKN7BeMYjOI9a/0OHfTozLBJiYXicDVMEoC6v3/NBwHr?=
 =?us-ascii?Q?Cb1LgfFEtODb5gmTqQzLqeBXJsY7GsWpCsxLDf25v4y/+ohLCvUZRBz75dY1?=
 =?us-ascii?Q?UcuHhNyXy0NjU+avtk4GatC+ILwUc1P/i1UPlHFYf/PJtwXtsvR/lP7ZkTDu?=
 =?us-ascii?Q?lBGgmOjgGF5BUFFSvXqMldqeA7MSKCooHnmBu+yEDTOP9zktZt6Zl3jPz+vu?=
 =?us-ascii?Q?fWNns3Z/3BAxgwcvul3fJspDHBvzsXCXvqysPqR66FM7e7mU3mLiP5NXUvZj?=
 =?us-ascii?Q?3JnfD1uIS2UV6GIGqRQgdq6bFlXQG09MSbogiEYvEtdOUjWULVq5yImU1KfO?=
 =?us-ascii?Q?iVBCdhOLiv7b8YJpGzxhA/fUyfxdM0ljZ3GW/wY7xFsC7Z+lHDaoS9P2ov9a?=
 =?us-ascii?Q?+7i+5d+I4+l2knOJURaRC8Ho7+8cnXmvYTQif3EeE2cpqBAM+4zRARXcchjD?=
 =?us-ascii?Q?2WUHLNK16Ru56kQajU3hSb4ZDbzwbpaPjqrHo/OUjbhwzCVVma5D0tV+NECa?=
 =?us-ascii?Q?OKIW2ShDFNvJm/tKMLx7SU0gYtl+sIdfQ9t7sdqIWm/FmyDHhw3rBUzeA5po?=
 =?us-ascii?Q?BCJ8sFF/JVC6tziVqQuZ6RtScbfGeKV/g+kbRRIcbX6q61mZg2eDpAApX4W7?=
 =?us-ascii?Q?kdx9K+yhKKVDiBwjOvopOKm8+VsLYRoHVY+4EU2/u2vHR7ok5yxLZfww6GZp?=
 =?us-ascii?Q?IFPurOGQ8nVrhGmDyshO/pjrN0Z0BQJyh/M1pROUR/xrQq0QP4+LiB5PSikT?=
 =?us-ascii?Q?TwXBZUt3TBSuQKxTLevckyLT291CaySiY3HDgoSX93ssv1AcICwsrQqaVJ4i?=
 =?us-ascii?Q?uD+ZJiapM3N9nZ0h8sGAqkVbzylQcrAo3WSyARkLDdzFcz1nMALzbRBcQhlr?=
 =?us-ascii?Q?5oS8Uq51us3GCDpfA4z627agP+DlWwGty3R/xk+pzqmFYruaPgSciAezGTp2?=
 =?us-ascii?Q?YLsnaxAfLoq1F4tlTUvA5TUAQ5F4FioF2seN7rI9LATUeZI5ssA5N9QuWM/1?=
 =?us-ascii?Q?UEqq1ryhvmza0kvedB6rjqYZIS3z0WDYZiL3hIlEJVHJMsL7wkV70AMxWPwj?=
 =?us-ascii?Q?WCRGAvHvvEcjTW3ew9zhkmCcuawJ59w6IF+yPhieVfY1ZEiVXU4zkdGtzCU4?=
 =?us-ascii?Q?vCw1WmLlguskpUb3YnLxmLOqIeLjDnATp30am01wSk/MuKfEtNX3J4Uz5OtP?=
 =?us-ascii?Q?nOwCLAMgZtAWLVZ5T5ASFjh8EWmSJAx+Dqr9IEy/IAvKLPM083LS857sr9G1?=
 =?us-ascii?Q?I++TI+NyC2aZ7L+ShRfArGL82pyANS+Ed7jPkDv/Y9sFBALUICrq68xZQp7H?=
 =?us-ascii?Q?iU/RLseOo3E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wye4AqQk9NytKZc8tAuZuitxgkn8Jrxh5h6EPYHE8fRjfbrivCcboMPqXNPo?=
 =?us-ascii?Q?JtN5QQEsjvrSrQu5ggztlSrtMQZunyxsyAPmMdGvO518Ka0y3yoWpqgcdmEL?=
 =?us-ascii?Q?WJlUSgxHK06y17CABjoyCzfvGIWFtYwOKcAFdexhX7VtNYanFsQaL1dqDShb?=
 =?us-ascii?Q?4uhuBhQcAMDRRoCmlrqwc70/6v1ePKQnseRWD3moNNukt0kPEn4ychUEXkzT?=
 =?us-ascii?Q?zbhpKIw6Ew8iHgvCt4NKCd+yr/IMpz6Hn69bx5JvrZO0PRCrxmtlS/CxX/nY?=
 =?us-ascii?Q?Cau55Kd71AuG0fMb6LV5yKCfRAH45JtnY/u99sToFlrvow7hI0rncDb8Teay?=
 =?us-ascii?Q?0lX/unrnTVUQFk2sFWUAAjUmJgwUyMQvC5uoI1ykydW74gUsjUD9EZRx6q9X?=
 =?us-ascii?Q?IqIslBuGSiPAoHsTqIle3f855FZpxQhPx141i5g7yJzBTEdqKr8DHJNW1pzQ?=
 =?us-ascii?Q?jOv4XpklqAw0NLylE8Kvv8lv2vxckr3T15LJIDLtWBlGUznPMlg3Kt92ZCNG?=
 =?us-ascii?Q?loJMdW0JMWI4RH4eGYHcYE8yE/2YKD4wFCKk4/7A1CL2yr2MZVVJiTjMsWv1?=
 =?us-ascii?Q?+jfDW5jCtWtnjKQKOQDUs6rouDJvVc3aHCnYXhkauQ7PuaBT39DyC8zdu0Wi?=
 =?us-ascii?Q?gTKsZyjA9vgZcM9tz1HILHMxZiW7I9KfNhZImRanJ4p65Rz7lmtZvRFNyjhN?=
 =?us-ascii?Q?y3WOlENQubPiHsw5Jirbh9V6SI+qFp5QkMCacgF37nz0oWYfVenUTnKLwvCD?=
 =?us-ascii?Q?U4VILX4HTLx6sUKlLV1tGE+RdczY+TkBfnz0RJPqbb7pbF65D5GaVzIDGY4m?=
 =?us-ascii?Q?rZa0ux9cS1HBkTrkzmIZtI3kr2PnbXJOVbcG+sl9YBjmQ0kSjYUrZLrnxm3S?=
 =?us-ascii?Q?Q1ZFEe0IFLudQEzKq2B9r0UUUEhIAVdbBPl7yAgt3P4X0Rqa/0aA5iADcVkL?=
 =?us-ascii?Q?7SSx2OLjXwG8GO5bg/xLHL0VMEWkpFbi+0y1TIm0ob3bYMnVOyGXVja4E5Lk?=
 =?us-ascii?Q?J9g7qaLLlZT55uMVFX4laZwFOmrQRl9gOVWx5mlR4DWWtcfUVkmt62B0N+W7?=
 =?us-ascii?Q?wqOw2vrXKVaGq4mXtO7E16U+v4WXuXoZGj8zb0DOBFqk9xpFLoyTj3rTDqI6?=
 =?us-ascii?Q?zchIFj6MnODSMszkyTYOp20yRfuY51FLucKUx/UYtCfQGECB16QQdHNNeXsa?=
 =?us-ascii?Q?AQYYmSzhHN1MqSGuQagaUv0FrQL4DKadDUQXvaqZTOtl8xx/WKFFrtkwzIRu?=
 =?us-ascii?Q?BCCEO5QmQ5qGy+PFe9DSL/W2lzTS1e+DXNdJ1XmpagXR+ii6f2SzN9kr4Kjp?=
 =?us-ascii?Q?vZKr4SV5+GPgwJdNTs48KmUOhQuBr58kMc2+fKxIfHrO0O5UWTwRrU0JtYEU?=
 =?us-ascii?Q?gnhvkRSt7Jd4d72JuZcEAewhTOkmkC8/VCJGIvwc4nxCST3qS2pZz4wsM/Y5?=
 =?us-ascii?Q?H3SRH1a0xySis+MB+QkkYgpz3uLSf1lSEGw5L7rHFQwERN38dD/LsqU9wI/k?=
 =?us-ascii?Q?JZv6hHaEofxHZDsyZ5ml9vONQXk+QMA73m6NKBfCkoO1nZFpYac0lPblUQgN?=
 =?us-ascii?Q?u5/XPZmp3oNVKOSfYXHbn7BBLYXe3NAcFSWH54gM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2caa676-b35a-4519-328b-08dda316f2d1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:21:52.0740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyZa0f/mmu4L9pi2cZo9lqFaagjbS2ZZs3P9kFbMR9dKTqA2Uy2wJJ+KFxX0MxhWbO5Aji5UTcCJt+71WsTROw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4345

The PFN_MAP flag is no longer used for anything, so remove it.
The PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been
used so also remove them. The last user of PFN_SPECIAL was removed
by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
support").

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: gerald.schaefer@linux.ibm.com
Cc: dan.j.williams@intel.com
Cc: jgg@ziepe.ca
Cc: willy@infradead.org
Cc: david@redhat.com
Cc: linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Cc: jhubbard@nvidia.com
Cc: hch@lst.de
Cc: zhang.lyra@gmail.com
Cc: debug@rivosinc.com
Cc: bjorn@kernel.org
Cc: balbirs@nvidia.com
Cc: lorenzo.stoakes@oracle.com
Cc: John@Groves.net

---

Splitting this off from the rest of my series[1] as a separate clean-up
for consideration for the v6.16 merge window as suggested by Christoph.

[1] - https://lore.kernel.org/linux-mm/cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com/
---
 include/linux/pfn_t.h             | 31 +++----------------------------
 mm/memory.c                       |  2 --
 tools/testing/nvdimm/test/iomap.c |  4 ----
 3 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
index 2d9148221e9a..46afa12eb33b 100644
--- a/include/linux/pfn_t.h
+++ b/include/linux/pfn_t.h
@@ -5,26 +5,13 @@
 
 /*
  * PFN_FLAGS_MASK - mask of all the possible valid pfn_t flags
- * PFN_SG_CHAIN - pfn is a pointer to the next scatterlist entry
- * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
  * PFN_DEV - pfn is not covered by system memmap by default
- * PFN_MAP - pfn has a dynamic page mapping established by a device driver
- * PFN_SPECIAL - for CONFIG_FS_DAX_LIMITED builds to allow XIP, but not
- *		 get_user_pages
  */
 #define PFN_FLAGS_MASK (((u64) (~PAGE_MASK)) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
-#define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
-#define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
 #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
-#define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
-#define PFN_SPECIAL (1ULL << (BITS_PER_LONG_LONG - 5))
 
 #define PFN_FLAGS_TRACE \
-	{ PFN_SPECIAL,	"SPECIAL" }, \
-	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
-	{ PFN_SG_LAST,	"SG_LAST" }, \
-	{ PFN_DEV,	"DEV" }, \
-	{ PFN_MAP,	"MAP" }
+	{ PFN_DEV,	"DEV" }
 
 static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
 {
@@ -46,7 +33,7 @@ static inline pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags)
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
-	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
+	return (pfn.val & PFN_DEV) == 0;
 }
 
 static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
@@ -100,7 +87,7 @@ static inline pud_t pfn_t_pud(pfn_t pfn, pgprot_t pgprot)
 #ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
 static inline bool pfn_t_devmap(pfn_t pfn)
 {
-	const u64 flags = PFN_DEV|PFN_MAP;
+	const u64 flags = PFN_DEV;
 
 	return (pfn.val & flags) == flags;
 }
@@ -116,16 +103,4 @@ pmd_t pmd_mkdevmap(pmd_t pmd);
 pud_t pud_mkdevmap(pud_t pud);
 #endif
 #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
-
-#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
-static inline bool pfn_t_special(pfn_t pfn)
-{
-	return (pfn.val & PFN_SPECIAL) == PFN_SPECIAL;
-}
-#else
-static inline bool pfn_t_special(pfn_t pfn)
-{
-	return false;
-}
-#endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
 #endif /* _LINUX_PFN_T_H_ */
diff --git a/mm/memory.c b/mm/memory.c
index 49199410805c..cc85f814bc1c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2569,8 +2569,6 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn, bool mkwrite)
 		return true;
 	if (pfn_t_devmap(pfn))
 		return true;
-	if (pfn_t_special(pfn))
-		return true;
 	if (is_zero_pfn(pfn_t_to_pfn(pfn)))
 		return true;
 	return false;
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index e4313726fae3..ddceb04b4a9a 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -137,10 +137,6 @@ EXPORT_SYMBOL_GPL(__wrap_devm_memremap_pages);
 
 pfn_t __wrap_phys_to_pfn_t(phys_addr_t addr, unsigned long flags)
 {
-	struct nfit_test_resource *nfit_res = get_nfit_res(addr);
-
-	if (nfit_res)
-		flags &= ~PFN_MAP;
         return phys_to_pfn_t(addr, flags);
 }
 EXPORT_SYMBOL(__wrap_phys_to_pfn_t);
-- 
2.47.2

