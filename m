Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F49E288A2
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 20:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750193130; cv=fail; b=M5ioSrHsQUZ0ba7f+hj38GAaAZejmtEtGexLaJF63kyrILcddfWeWNSPWLNenaw+ZlHWrAQAIlml6nI0Fp3SdLjWcnocCut87CxGwmdhxo9YTEUjvy5Xzr/mGKkWOQWAn2nmlznbgeqYBVctajFZjBZQpxje52q+UIEnU9mEXFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750193130; c=relaxed/simple;
	bh=3nXA67jyFjk16I/xITt09iPeUDQ0jMnnpYbrnSvY6Qs=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=ofcA2mL38cdWjauKEKIv+K64YI8A6x0B4GHLfmNbG/RO+hkiYK6DBN3Fv0mnEMsH+3SQX2sGHQFM7B2/XZrVHFRiPUt1+nz7p/r1jdrifOvR/UTGL+Pif5g1zju8xPLr7NW9B76lIWxM5BHZY45bGbkBgZXkxSONu1R1Woewfpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CvMfSOdW; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CvMfSOdW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750193128; x=1781729128;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3nXA67jyFjk16I/xITt09iPeUDQ0jMnnpYbrnSvY6Qs=;
  b=CvMfSOdW6tC1YCwLXNjJb1SFn1rBF9g+Ajes9vl0LwpZ2oRn5N2ghOVC
   W4yhu2UV5gYiWReHOZCohGkX6SyJUxjoaT6uB5LKq5bdGM7Jry70KM0ZK
   8w/yvVvIml/77oneRMBG40Pz1jty/7PcM+25AgLUy6sCDUVfC2qU7hKXs
   0pIcM3+7zUrSwjEhtZiPA/Wju25Jj9zmv9mExEAL3r/9rmb58rRZ5z/1f
   cJsFe/UzBsnoneEyBB6veH96nAo+L7uU4aVuExoGw0GBux9KG/D5+dxxp
   xkrMczDBXySXgk6sno3kj6UcURgeMlYKz3X/iB0PWl+cLjB70y9TVv6Kw
   w==;
X-CSE-ConnectionGUID: sU+PLZMUSWiZMCtyScNS7g==
X-CSE-MsgGUID: YZvJ2qaDQE6azEJ1GQdRsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="55008030"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="55008030"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 13:45:27 -0700
X-CSE-ConnectionGUID: rGlGGqT1TmmGQALLnlYwHQ==
X-CSE-MsgGUID: IgQNF5q7S82064lo+mzCkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="153660983"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 13:45:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 13:45:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 13:45:13 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.40) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 13:45:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p96UyuP4BXvsJW2URa0E7lkTUDFjP/gg7S2IbADLH02zE7GUFEzpWd4YkHdw3zdzkqEL4715SKv0gBwqwLbjF8TPueCOc6ERMLSz9glVRKkHfxkmj3WaJDom1+TylPlrBfv2wktM7Wn488O8VSZtnqrDNNld2GlFprt53dJ4GB7mdFKeoEstt6FM5kzrL01Du/2lCXnZS/AVyHUgcKxGrtaUWsnr2mQbA+yhpUZEIl6BS55Uov79cUzRvqmd2uDSkWfUDYlKasQ5nnWsU0uPpu7PIVhwKz+hn3fn9ZJZG12JhEAA4TpvIPLD0pbrd7jXHs4JrfDMTOZMNEtByZ/seA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpCBiA2MMexy5QsMgJpzbZqYSc6N7RhP8985V39bIcM=;
 b=daPwG2B7YtcVBaP+BzT+bPI5kLVMb/nvusrWiEVSSosyaPxRCu4a+MlVjaQ9VpJY0bnfshO54yA03oKLVCjpuRT5mbBMEKkQ8OvAL+rpLIaBf4hclw0Tq7XOUqn1wqb15ZRhxFpPJPJ8gZoOeEJ20p4y5ghHOHnjzs6zJEhMGL27ieHuHaPeO8y7iZUPTY+IVUe3e57jTqPMs4DqV133o4N17K1f5VOMfUY9yuHpvwTKg5CyCFvebPrloV/Jt3tBkqmwYdx7KE6K/hlTO/dP4+xzJg4ZGewHgqZaC53jI7kdYOwP/CWIAzFMUeZh4gkjwaiLj/dx8hwG+tvdvjAXVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH3PPF018EB8BEC.namprd11.prod.outlook.com
 (2603:10b6:518:1::d04) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.28; Tue, 17 Jun
 2025 20:45:10 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Tue, 17 Jun 2025
 20:45:10 +0000
Date: Tue, 17 Jun 2025 15:46:23 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>, Conor Dooley
	<conor.dooley@microchip.com>, Oliver O'Halloran <oohall@gmail.com>, "Drew
 Fustini" <drew@pdp7.com>
Subject: [GIT PULL] NVDIMM fixes for 6.16-rc3
Message-ID: <6851d41fbecbd_25410c29475@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:303:8e::9) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH3PPF018EB8BEC:EE_
X-MS-Office365-Filtering-Correlation-Id: 425be728-61a4-48d5-e098-08ddaddfda0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Qec4W4anbN6i9IUC+Zw5uIDfjPgawwWxbwBzWGUDrDpaNab4e+MAZYtTkyDm?=
 =?us-ascii?Q?kDomVMRTYyQvA1W7GGJzX95IkhG5mk37z792gcopsTBBPNLdhJ6gjAd6h/5M?=
 =?us-ascii?Q?3XXuCjs65Wtg9Fl8afD2s35eSEAIDQ0A8ti/sTvY22JUWYnbnOa9v1huTEju?=
 =?us-ascii?Q?1+YYkdHBbN/SUQCP4fuVxR+T+HX7SKpE8HQqqR/rf3GYK6GacOqZucXuseHc?=
 =?us-ascii?Q?pkN2jqC3nNZ6dLG1ml+CuPRFJI0ujv2wqwkI/paSlvtdZIEJtWX+r2b/PAWf?=
 =?us-ascii?Q?sEK8XS5uzgr/ttfdJJpm3wRDFyT8PksaR1I99X6wcan/MvqCyy5WlCgGZEpM?=
 =?us-ascii?Q?8AEZxBJhDru4qQHdJVZiqGBXhYP6rHHopzAONt0TPO6bvqxKPBeNuH//NOoy?=
 =?us-ascii?Q?rBohwG0BSPBrBPOCxj4OLUjIF2/a7DchB+tP5N+Ajpg65SA6uyV5/u6kPmQ1?=
 =?us-ascii?Q?sz6kMd7xyW2lj7lHMjb4CY4FUbBkcfZlN2fHAVwvZMQe4BWrFQjv6xvwpe99?=
 =?us-ascii?Q?rrGsp5Nyq0nFqNG+ldqzpiw9aTs7+DDgIosS+U1oI10MD/bsTXfR+IsK58tU?=
 =?us-ascii?Q?rPLlhoUSjx4ITG+cb5hs3V7X4PKMIPMVSWIsrWRropWv9RdQmVCILH1nWfv/?=
 =?us-ascii?Q?iyRwVTHDbwbpon47FmuWwMivmH/RSWJgxVu9MhFdPOGmuvgsFlN6J1uPmYgV?=
 =?us-ascii?Q?XsxCXvtbCuAN0dAGTerFwHuo609GcqiW0CzrQLulNfrIE23O2nKyhVXCFEMp?=
 =?us-ascii?Q?j8ePvV1or3uDU6PbPHZPUH9Ilz6rLd2/ZUuxsbeqZiRZWvDlW7aa/H6a9jgz?=
 =?us-ascii?Q?xELWnkfQV1T6Cb+j3R0U+MS/nnuV7MMgTcFxaltfoxt3NORjj1kSKJS4r4bn?=
 =?us-ascii?Q?0Go6E+wBoIK4CXoD0wzPd3TttEOAN/0loVE4VQ5c3yf63leijx1iSd4ur6OP?=
 =?us-ascii?Q?JOHTKh0POY8rtir2LZhQ/RQuYyRZUoE66LQk5WzxCzCyy2OOH7Q2opA7BvDI?=
 =?us-ascii?Q?vJ/l26+0oLsl8PFPjfkxtJ3EudYpuNS1Y1ewPQmV4kKTt2Dale6baTQdg7u+?=
 =?us-ascii?Q?BFietWixO4liuga86/9fOoLVOPaOlnM8Ozc10DXNc/PAFQCk0kcm0c1DRneF?=
 =?us-ascii?Q?oVuqK39zTDnPBX7ENvyBXLFSHg4IaXSrgFlKk2Kcq0Wy/4M3MkfsWcWLi0Zj?=
 =?us-ascii?Q?3pTRDtjBqKSIc2ssvQ5cgR63nNm2tgST+aQ1UKJjOlQAI6vOMuebqLnQU2hr?=
 =?us-ascii?Q?NXjKGPoBwH/dlOM5qEukcOvtEbN41yrjINYnMKN7LeWanohxaAITotcQaoRY?=
 =?us-ascii?Q?n5C35VgwwSGOSsUOnzL6Z9VyHd0Nxrco9Y/sn1LQlKh0w6NcRmSIgz+aHphd?=
 =?us-ascii?Q?ls/C/bw6IbVYC5xiSgDEaI3yRSvh8TU2HOiPTL/08oUm8qwrw+ro3YmQ4Y8J?=
 =?us-ascii?Q?xISu9Y1AGfI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iM/2sTK93B1KqzPYk+2TnAp3Ms+siFQ8Jh5XPYduqQLv/rAeqI1PaBb8RpBg?=
 =?us-ascii?Q?kR7tDCUHwqM97hnBlEUkTjIcIITNOl7mr/6spd1LPAi3CXzJn2WXwR8rYgdf?=
 =?us-ascii?Q?TxLM/4FlFJPUXKUNtLewrvpkolPXdhkrg7hW7ldhoPJGifCbn430bIqwKlwn?=
 =?us-ascii?Q?mopdVdXB7GMN9adHhv5xMSG3o7Ojky7a9tQ0ldLyTRV0SrVihsvfJCJ1DZjt?=
 =?us-ascii?Q?Tu3leMdFeL2+PsGxEbxiRzNwOxu2qP18it0B5HgxyoZ0YqDG5GOJgiTv82Tp?=
 =?us-ascii?Q?LeDxSUFYxvBgK+nCPPAz95121AHgEC/wrEFyJ+lqP3Dm3/uRGoy7tD4TkLRS?=
 =?us-ascii?Q?lGocejvry2zUNL3Vq8YtGvjypzEtUnYD530r6LxoEL5vIzfCvnM+Y4jSHrfx?=
 =?us-ascii?Q?ZmC7aRnzCmL9OXKbemHdINLn4ohupT/gv7+YQ9OErC/g+tJTRVioDMnd1u4a?=
 =?us-ascii?Q?SQ1XbRQcOER3uRsH5g7/o0LAHAW9bz9BuTxhFpXn3U8rX5oilQr6jHKzOnak?=
 =?us-ascii?Q?sLpON1Dn4BBTlon1BCHAmcV33eYicGkx5sWeF+xPeoUlwvOTjWQ1Ls5Fp2Aj?=
 =?us-ascii?Q?w3ZSfj7Kp4pzr6qt/0Gt+t8cfC58wS37q3maKrNnklgsIqARf2w6qjpVW+xa?=
 =?us-ascii?Q?GNzmcsi5mmSMDaP+0SA6jf/HyVjD2zu/gvrOAdKKYwgRkbNNUBSh2ubaLwr7?=
 =?us-ascii?Q?xPBqB0EGO+OUhuqPodNS7peCLZvbakDv1s8NQNg6FGr7RFuE0jcDCRGPJ6Yf?=
 =?us-ascii?Q?ztzyLmjImfcYruhb1M+PdtpLQNSVNWVPUBl1aUfbqBOuF90rIhEbaPVWa9QM?=
 =?us-ascii?Q?TmP1sGubNr2XX3Ze1VKYEpAgaRGo+K99LxVl40p0fkLhT7bJqrrTh13sKUyr?=
 =?us-ascii?Q?ttQDWofFyiDoDrtlezxmAK5pPn/KbQVtbKPM+db6o+O1NqwYWjhMR171/jV0?=
 =?us-ascii?Q?4rikZg7WUl7vcDG4FuYkNLgST0pyuVcG9RE3h3OyMcgxZEhwA/b0NpxCAAyb?=
 =?us-ascii?Q?3nT3sodbWsBdxjhXbsT3A15H/d28HWp1y4RPeXV3l5E/tgCVU7/zQ+HXUu03?=
 =?us-ascii?Q?J9dSVN/jhpOuWSXepnFl4vYzSeT9AgCQIACz4aPZFnsQ/IrgP83gWV18sbjt?=
 =?us-ascii?Q?juogLp9KBKYt63BAWcemS+tSIKuwS7dneAmMftbVWxUx1GFE2GBopFf+k7qn?=
 =?us-ascii?Q?BaIeL1cbLG82vXRhXJv7aP4AJf57bV617QvMNlRQ4UZameoHuVvuQqkZuXeE?=
 =?us-ascii?Q?tj348bYoLE3PMUPozpsjNJht5uO7/oUtPC68Wzi2J89uTmCXIeW4FaR2R6Tm?=
 =?us-ascii?Q?Q6hKQJTbuCLUzbWoSTXHqHZEBT3kapK6LRMZyVY6be8E8uwMMx1eP4kpCFP6?=
 =?us-ascii?Q?EW87XYi7ioRMThwpd4Jb489Pkor9JLNPo9SA/9XZodVv+jH7wZ6OV67jvuiF?=
 =?us-ascii?Q?7WkgF1UN6+3qB2iVOmK1r7LfBXv3+XAMhs4fHC/Nd8eCdBUUECGcbO49UFwe?=
 =?us-ascii?Q?NVuXCjm7aBL3MIYQKRt37g3Y6xtzqdRXWPlZRwXwcJP1Rl05Egz+/pUA1JkF?=
 =?us-ascii?Q?lHYtxZnKGfQwDxBmOcFy08y9hPKDug4RApN2fzAe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 425be728-61a4-48d5-e098-08ddaddfda0d
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 20:45:10.5892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdOdAZxOf9BIN4las9oSvBMPL3Lmq/ldw8k1cq21oiNNNsCOnkbCpqHh/7y4AiaX42bfuDLlnpv91hAGwcv8BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF018EB8BEC
X-OriginatorOrg: intel.com

Hey Linus, please pull from:

  https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.16-rc3

This fix to the device tree came in late in the merge window and only now
has soaked in linux-next (since 6/12) long enough for me to feel
comfortable sending it.

It converts the pmem-region device tree bindings to YAML to fix errors and
bring it up to date.

Thanks,
Ira

---

The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-6.16-rc3

for you to fetch changes up to 62a65b32bddb0f242b106b8c464913f2f01c108d:

  dt-bindings: pmem: Convert binding to YAML (2025-06-11 14:36:55 -0500)

----------------------------------------------------------------
libnvdimm fixes for v6.16-rc3

	- Convert device tree bindings to YAML

----------------------------------------------------------------
Drew Fustini (1):
      dt-bindings: pmem: Convert binding to YAML

 .../devicetree/bindings/pmem/pmem-region.txt       | 65 ----------------------
 .../devicetree/bindings/pmem/pmem-region.yaml      | 48 ++++++++++++++++
 MAINTAINERS                                        |  2 +-
 3 files changed, 49 insertions(+), 66 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.txt
 create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.yaml

