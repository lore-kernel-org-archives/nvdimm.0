Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC79258EDA
	for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 17:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802813; cv=fail; b=MlrndwLRZ3i3uuSAmTDs4GQQI0mH8O6N8Y3ODnbyNiSNwN/BR+jZgsu989ljgYKEbowPBLDJx1GKFyuVN7j5WyEUnQNxGEes4CfXC1K1yzCCCoAHla4VJImGQrM4tEOXx85F9gRGgrYck1Qum64XdYN/XIv90eVMLDY9TRwj8MY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802813; c=relaxed/simple;
	bh=d+EMPLtrgN8ZYo2AkBzCnV04lrObKjSkdSLM/Xrs1og=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=kCpBMBnS0gC9gBBIVIZ9wg5Uix9bnh+rAdsXnzxRYuwC9rPQA46BmgjrzkkPUbNSCI5ImvuCnLCrJc+G36yMMjJBdAAfw6wC1a+by0Hb8lvlEWyOojzNaAf/GhfLfcldVGsDVxWnlYTNaLhh/Bl812R5XVgnJmMTGuXgsSFnY0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/aV784e; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/aV784e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781802811; x=1813338811;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=d+EMPLtrgN8ZYo2AkBzCnV04lrObKjSkdSLM/Xrs1og=;
  b=R/aV784eMO0fSBK+Ow9uB7IMykiUWhSAGEC/AfrMYOqfitKptbnADUfH
   A1W/0/pSIpehCxKx4Hm2YRS/g5okWNH7AhAdDM3rA4TqfpAnOSfSvKey6
   ge4div43YRDA9aGmf5tntdEkd430jLNjc6f1gv89f90fVOun4F2S/t1/o
   ElqdmPd1kQcnru692xX6GAKxWvAcfIxUcI1e65W1gqvdMgrcXQnRbdULz
   gNI63Alk4pgFZPzHgMexwY1R4DPdrZugaqFigSUnpG8LMgeSOHKzs0SG+
   fdxjaWa6Usk3OJK+66Z79foZMQ05qcynoEALzr6TQ0vHVcZktad5UVKZD
   g==;
X-CSE-ConnectionGUID: zg8Ag8KSQrafiKl47SqcMg==
X-CSE-MsgGUID: rVuYk+gATo6VtrBHc0IoRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="93293878"
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="93293878"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 10:13:31 -0700
X-CSE-ConnectionGUID: 5m1+g9kIR3yuc/ZhQM3QhQ==
X-CSE-MsgGUID: 5tc9JGJLTXKqg7vrk+3vMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="278599489"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 10:13:31 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 10:13:30 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 18 Jun 2026 10:13:30 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 10:13:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=itItOPIowUxMhDHanTn/jQxxh+9CpSNiZtWCTZ+aguc3kmHWVb9pLd+VJQAc7RIhc6/wbi8uhk+wbMF8O7ZIXSb8E8GHh9A9HKHb0EkOAzmgBOOKERljHprmG037oF7I7u4K9nz1KER5G1xKUSevMth8jOgLlBjDxlep8VOiyu/7XBlzt2rrvtejE1cLOxbYdpuIXikU/Tt+gVupeWNf0pyGvQCVTCmq68SkbNq38DncpS1MDuRF3MUXizgJXccQf6RDkVJaSX3+PZI3NbIKtAOWP+laPXGn8WOjY5y2/omzEFI9aIa7AgEBlJ861C5oxxC/kGYrI1VK4Zd0Q2wtyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8YWluLgNmWFzWXom+7A71j4o4rX9Oa63fkZHY/cN7g=;
 b=B4bklv9SyEwDLFYCAwFe6i48GHOhuWhyy8QEGlmwr6FcSk8r0HVdJ67xl0oqPdsslMzUQihx/ucZbxDRjrUXq3An/9cxWvI+/sFm2pz0vRnnJqJjfHzxgZw7leBZRwc2pGDIkutycqB/2WtcVZtv8lEBDBeoeTXxv3U8YsYx8feDbfpNP5ftPpAh454qhd//tDs0OJnPKVrrbEeBjWJ9VoWlDGwamzXv2aAH2ov/3zkfU8HfFBMlb29MPCbQaGKmSq63RDB8b4p2nWwGYp7A2OaPUS0nYgzD+y7QPzBRw++XyPGdzCVvOG/tA1K6qWI9vSmNAhlO9rnsl/AVFxNh+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 17:13:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 17:13:24 +0000
Date: Thu, 18 Jun 2026 10:13:20 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] NVDIMM and DAX for 7.2
Message-ID: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SJ0PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:332::10) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB6992:EE_
X-MS-Office365-Filtering-Correlation-Id: e980e89a-2dad-40a0-2976-08decd5ce808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|56012099006|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info: 5pwe6tyIxdHJJg47LIc5NjdGMYI86BeIC2XJzunwX3rjFidW5LMCqQU1dCWfmkP5BbZblJUs4AG+Qma7vlP7Vy2kxrWSFnaKUQdgBOiqXFzHYgnNfhjIgIT0uIGhP8mqPxWCPNZkAUl5Y/srJFC1uWDqqQKQtEj+d56SxYWchvej/I5VjjwocUBuDJMglkCs3vtZ1UWD7aPJJsmX6tdK0Jbh1dyjbiVjQ/6GFeGOIZq85l4rdncCXDnxvahQh1XFih+l+NwqameIFCSF2tRq8gPV1JDksL7H/lCHOfyrDkwlPSUqrQdbXxz1pAIAmtzVPC38U98CvUD4VcW24b38zy/6Jobwez3TEaf94UznnnN07r1g6aJ7iGnZ6QN1tznGQpscauCWw6WOpFmMIIPOPhXE/dc1osKBX2Z1LMPFOk7S1Ri3PyUtUeEARdetRn5UkFpR/g3oYdgjsXjDiratpBDgcYdC+5jK1YJRxmWzpsl/4y8fhyK4tAxFAKwPxTBk+HU2xbeX/6XR9lDF5TsgzxOZMl4FQV/cTru2KTtL7HAWh6gzSU9/F35efabNhlUUg3y2xb6B9jYYJTYfWnj1BaJrayHQfoFOdh3gqeQILY6A1Hmj91I39w5maKqmwzHR2W4g2+fAWePxrfnGDtup/PWfNW3qP4AVfTAi5YIVBTI31fk1EHCZWK4qJ2aZm2mE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(56012099006)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w9aCt9ETwvmuz57XqO3rCGV2TTTD52MXbcFYQdJD98TNQghebztF7vnPDHf6?=
 =?us-ascii?Q?qNS4Exa6oa+IEEBqCMs2u+t8LHa6nl19GWfG0oC7mzuJIdeBOxxzkO9Sfurq?=
 =?us-ascii?Q?BmAc7ZUyHAA7jBkZy/EZJIG+vL34V7PHV9Gf8bQ3zIMLoT8va0TZyGC+N9Lo?=
 =?us-ascii?Q?GruJRPmItRqLMAcBGskGOv4hM03VAlGvXefE970magHNbXlG9UDCj5SnLVN8?=
 =?us-ascii?Q?dg9//ATULR0hjMwlbdQcP+JSQN+uK+jgdXg3Hq1ld7A5QznqD+v/umLElrqz?=
 =?us-ascii?Q?ylNMceYb55CL54iTDQPjUpKT1m6GXxnDR4FCcfn6Qooa2Pl/cfJ51XIRSoX7?=
 =?us-ascii?Q?8LxqHHJY/6VVozKvkU/4nLFp6aebqeAiZGBvJTM1oYosNdIRpxDbzD4bsnpD?=
 =?us-ascii?Q?6iAzEvve5CxqYiYMccREojWQ0zqTsUpJiwhEs2r/AcSBHVVxzuYQxMeVELq0?=
 =?us-ascii?Q?cjOhaKeSsh93f39k42WVyM8IclQqQ8ckeV5VPOVTNEPgZ2RHRXEoMONhwloZ?=
 =?us-ascii?Q?YoGsr3Uo2deIn3FATxQY+nE3ukw2me4F2gDNyVGao1D8mlbO1wcmrv14mFKO?=
 =?us-ascii?Q?Oq3sK/bg3WufZbD0g9txG1HM8t+MICdAJ/BzX8akgzDxU/o9PJUNAMvw0fst?=
 =?us-ascii?Q?k5GMSqBTStAq2XEFYYy+3UGEIZPSRom6fXeE8+Gc1BKndoHheZfDNUB4RnXS?=
 =?us-ascii?Q?Ok9tp/oHnoKlHmTuuUeyT24OO6aWw+AqnHjWENKves5K88mIc87y3V50zsZO?=
 =?us-ascii?Q?meyVUKIKRPV2/Udyn+/XpYHEpqHpbSSDmcTps3rkBrq15SLTagGKz/jQ3TaC?=
 =?us-ascii?Q?KGhiWJOvLjsuvfCkXvu7nn8dNacgkrFpjF7vM9iGC4pw/DGigCImV2DWJsMJ?=
 =?us-ascii?Q?+1pkN3JO9TMaZEY704qyHjfFg2AXUgUrDDAuCc5F2FknzDcl48rRMy6Pt+5/?=
 =?us-ascii?Q?EWvNA9HmqrcyI1Jdc4bJYc9oGaA/Amlw1Hmc7nERzys+HUPt6jSSIpChnjRv?=
 =?us-ascii?Q?qa82JReHB9G1mEXDDoc4ReL5GoGJKMuUzmzhQ93mpJO2n8TrZqsviwnodXLE?=
 =?us-ascii?Q?vMCIuX/EZi0f+9D5YG3xi5bYNWifAZzdr+HqSDUGmeI2fY4PuzJ4OIMEsEBl?=
 =?us-ascii?Q?Mt5uxqzaFBJWo4S1bAEs9s1POOd/cTaFbaGHg5wwtPSRSWlq5hD97kLhyRRY?=
 =?us-ascii?Q?pdz6K5cxA+Zfb/FFWnmJ2mxu210v63qCSFU0VHtWxECwgKEWEd7vARGkAvik?=
 =?us-ascii?Q?R8xK5TYJpRfI8+HbQbb0rsNRJ/FgHudVwRumJIROcuIhPtSsHPrE0HTo7sPk?=
 =?us-ascii?Q?m37zkK25U6WtCzGhPG+s5s/Lfr1/NJLw8LrNIyLFoeQrDokhd6UvoD1EbRbR?=
 =?us-ascii?Q?TYyax3cnaGVBNljpUcN7dC5pxSktvm4CTbxZHzKXlZDoIlUn6amX3jlMrRUg?=
 =?us-ascii?Q?b0fWbIVQodEAH8qZ4nOaXBPoENhXHEwbksigHLwfuEU5Mr4kv1cfxEHViFeg?=
 =?us-ascii?Q?L6hg95zlVUnfcQbggmWhk2ark7GvRWyeJRgM52LnrGw8LuHjDtdyaypJmld+?=
 =?us-ascii?Q?eoyUFI7lL1xvspqjUwqOgNLQX1udTlNgAHVibvVmlrrdECHyY5gH6Hyp45dl?=
 =?us-ascii?Q?Txe4VsnLHPUmmFYfBCAjmaU2w6J8OUcFqlv5iT1NsfXYkaZz5xJ8+WYomUn1?=
 =?us-ascii?Q?2me1cqMXRpNPHLqVTBW5sDiVYmRs69R7yP5kimbthwsfW1nwBguRLZji+z5P?=
 =?us-ascii?Q?RkitHFgBf0oAElLC9Yury13wb0dal40=3D?=
X-Exchange-RoutingPolicyChecked: FrvnMHBMtUe67udSd3ZlY7PYKLt77P2oSg4wKy23tHI5DVLzW/nzCQ0zE5qj9YSx8dWcocY17h1uYSKyG2f7CbjxHMp6PNQYepK3jeM+POCxUu12irov7yO70hM6uVt3R9pr+NcoenSeJLSPIb08ybvhWDZhx1CQ8saTFn5FzZQsh/kClXyTUTvgfhsk+2vJ3D3yTsRoVqTQ6v5z5R+/5qDUvhL2kb0ofMLRwIw7YPkPNETjzoKdIVybgmHZc95/cerkq1HShgjuBhwH/sA7HSxVr28KH12nRIhfZxWuPlAJcESannZ4mIaA/zfKi3dBT5hHVZYLWCUQZU6i5DbiLg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e980e89a-2dad-40a0-2976-08decd5ce808
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 17:13:24.8193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nMeSUTDKmgLKzi9CmQSmzwlurm8HjJkSt+9vxwG+Gs1z49K2LZcYhLzR6VWpMyUW8abKFXl4v27iSqRhBnlRlD6n+r3LbFLhk75/EK2gcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992
X-OriginatorOrg: intel.com

Hi Linus,

Please pull to receive a small set of NVDIMM and DAX changes. Also
included are updates to the MAINTAINER file, one which adds me as
I'm picking up the patch wrangling role from Ira Weiny.

All have been soaking in linux-next for a couple of weeks.

Thanks,
Alison Schofield

---
The following changes since commit e43ffb69e0438cddd72aaa30898b4dc446f664f8:

  Linux 7.1-rc6 (2026-05-31 15:14:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.2

for you to fetch changes up to 86e411b6ec277dbb8ac1f1d855dc337181a62a29:

  MAINTAINERS: nvdimm: Include maintainer profile (2026-06-01 18:06:08 -0700)

----------------------------------------------------------------
Updates for the 7.2 release

A race condition and a couple of static analysis issues are fixed in BTT
Use sysfs_emit() in preparation for removal of cpumap_print_to_pagebuf()
Escalate a dev_dbg to dev_err in a resource conflict message
MAINTAINER file updates

----------------------------------------------------------------
Abdun Nihaal (2):
      nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
      nvdimm/btt: Free arenas on btt_init() error paths

Alison Schofield (1):
      nvdimm/btt: Handle preemption in BTT lane acquisition

Dave Jiang (1):
      MAINTAINERS: Add maintainer info for libnvdimm and DAX

Ira Weiny (1):
      MAINTAINERS: Update address for Ira Weiny

Krzysztof Kozlowski (1):
      MAINTAINERS: nvdimm: Include maintainer profile

Tomasz Wolski (1):
      dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()

Yury Norov (1):
      nvdimm: Use sysfs_emit() for cpumask show callback

 .mailmap                                |  1 +
 Documentation/driver-api/nvdimm/btt.rst |  5 ++---
 MAINTAINERS                             | 11 ++++++++---
 drivers/dax/bus.c                       |  2 +-
 drivers/nvdimm/btt.c                    | 14 ++++++++++----
 drivers/nvdimm/nd.h                     | 11 +++++------
 drivers/nvdimm/nd_perf.c                |  2 +-
 drivers/nvdimm/region_devs.c            | 66 ++++++++++++++++++++++--------------------------------------------
 8 files changed, 50 insertions(+), 62 deletions(-)
